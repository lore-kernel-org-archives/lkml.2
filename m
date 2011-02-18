Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444Ab1BRA3R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:29:17 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35445 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1BRA3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:29:13 -0500
Date: Thu, 17 Feb 2011 18:29:04 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Eric Paris <eparis@redhat.com>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        Steve Grubb <sgrubb@redhat.com>,
        "Serge E. Hallyn" <serge@canonical.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] System Wide Capability Bounding Set
Message-ID: <20110218002904.GA12679@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
 <201101270942.07689.sgrubb@redhat.com>
 <20110128184901.GA5134@localhost>
 <201101281410.29794.sgrubb@redhat.com>
 <20110128193809.GB8854@localhost>
 <1296584221.3145.12.camel@localhost.localdomain>
 <20110201212605.GB5294@localhost>
 <AANLkTin6Msom+b8wHULvzEjA+VL5ofQ9wx-ZN5SiK6-p@mail.gmail.com>
 <1297133758.2323.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297133758.2323.5.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric Paris (eparis@redhat.com):
> On Tue, 2011-02-01 at 20:02 -0800, Andrew G. Morgan wrote:
> 
> > In this case, I would like to suggest what you need is a user
> > configurable state for kernel threads to launch helper programs - a
> > kernel side equivalent to Sergey's wrapper idea.  I continue to
> > dislike the global bounding set idea, but I would support a base
> > credential set for this kthread launcher. I'd include pI, bset, and
> > securebits and uid as something your initrd could initialize away from
> > their default values for kernel launched helper binaries. I'd prefer
> > it if you allowed the regular capability convolution rules to apply
> > and propagate this bounding set for all kernel launched binaries, and
> > also add the relevant code to init to enforce your desired bounding
> > set for init parented processes.
> 
> 
> > >> Or an interface in which I can force things out of the bset and pI of
> > >> other tasks?  Possibly the interface could be specific to the "khelper"
> > >> thread?
> > >
> > > No no no no no :)
> 
> Below is what I'm working on.  I've asked dhowells to review the creds
> code, since commit_creds() does not take const.  Maybe that's just an
> oversight.  Basically I've exposed two new sysctls.
> 
> /proc/sys/kernel/usermodehelper/bset
> /proc/sys/kernel/usermodehelper/inheritable
> 
> You must have CAP_SYS_MODULE to change these (changes are &= ONLY).
> When the kernel launches a usermodehelper it will do so with these as
> the bset and pI.  I haven't attempted securebits and uid (since I didn't
> really need them I don't think)  But will if anyone can think of a use
> case.
> 
> Is this what you were thinking?

Sorry about the wait.

No objection from me.

If someone ends up wanting to do more generic security context tweaking
we can worry about that later.

thanks,
-serge

> -Eric
> 
> commit 23dbb6813349509a463103a34b51b18182c2ca0f
> Author: Eric Paris <eparis@redhat.com>
> Date:   Mon Feb 7 21:39:58 2011 -0500
> 
>     limit kthreads usermode helper words stuff
> 
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 6efd7a7..79bb98d 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -24,6 +24,7 @@
>  #include <linux/errno.h>
>  #include <linux/compiler.h>
>  #include <linux/workqueue.h>
> +#include <linux/sysctl.h>
>  
>  #define KMOD_PATH_LEN 256
>  
> @@ -109,6 +110,8 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
>  				       NULL, NULL, NULL);
>  }
>  
> +extern struct ctl_table usermodehelper_table[];
> +
>  extern void usermodehelper_init(void);
>  
>  extern int usermodehelper_disable(void);
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 9cd0591..d38be14 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -25,6 +25,7 @@
>  #include <linux/kmod.h>
>  #include <linux/slab.h>
>  #include <linux/completion.h>
> +#include <linux/cred.h>
>  #include <linux/file.h>
>  #include <linux/fdtable.h>
>  #include <linux/workqueue.h>
> @@ -43,6 +44,12 @@ extern int max_threads;
>  
>  static struct workqueue_struct *khelper_wq;
>  
> +#define CAP_BSET	(void *)1
> +#define CAP_PI		(void *)2
> +
> +kernel_cap_t usermodehelper_bset = CAP_FULL_SET;
> +kernel_cap_t usermodehelper_inheritable = CAP_FULL_SET;
> +
>  #ifdef CONFIG_MODULES
>  
>  /*
> @@ -132,6 +139,8 @@ EXPORT_SYMBOL(__request_module);
>  static int ____call_usermodehelper(void *data)
>  {
>  	struct subprocess_info *sub_info = data;
> +	const struct cred *old;
> +	struct cred *new;
>  	int retval;
>  
>  	spin_lock_irq(&current->sighand->siglock);
> @@ -153,10 +162,23 @@ static int ____call_usermodehelper(void *data)
>  			goto fail;
>  	}
>  
> +	retval = -ENOMEM;
> +	new = prepare_kernel_cred(current);
> +	if (!new)
> +		goto fail;
> +
> +	new->cap_bset = usermodehelper_bset;
> +	new->cap_inheritable = usermodehelper_inheritable; 
> +
> +	old = get_cred(current_cred());
> +	commit_creds(new);
> +
>  	retval = kernel_execve(sub_info->path,
>  			       (const char *const *)sub_info->argv,
>  			       (const char *const *)sub_info->envp);
>  
> +	commit_creds(old);
> +
>  	/* Exec failed? */
>  fail:
>  	sub_info->retval = retval;
> @@ -418,6 +440,79 @@ unlock:
>  }
>  EXPORT_SYMBOL(call_usermodehelper_exec);
>  
> +static int proc_cap_handler(struct ctl_table *table, int write,
> +			 void __user *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	struct ctl_table t;
> +	unsigned long cap_array[_KERNEL_CAPABILITY_U32S];
> +	kernel_cap_t new_cap;
> +	int err, i;
> +
> +	if (write && !capable(CAP_SYS_MODULE))
> +		return -EPERM;
> +
> +	/*
> +	 * convert from the global kernel_cap_t to the ulong array to print to
> +	 * userspace if this is a read.
> +	 */
> +	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)  {
> +		if (table->data == CAP_BSET)
> +			cap_array[i] = usermodehelper_bset.cap[i];
> +		else if (table->data == CAP_PI)
> +			cap_array[i] = usermodehelper_inheritable.cap[i];
> +		else
> +			BUG();
> +	}
> +
> +	t = *table;
> +	t.data = &cap_array;
> +
> +	/*
> +	 * actually read or write and array of ulongs from userspace.  Remember
> +	 * these are least significant 32 bits first
> +	 */
> +	err = proc_doulongvec_minmax(&t, write, buffer, lenp, ppos);
> +	if (err < 0)
> +		return err;
> +
> +	/*
> +	 * convert from the sysctl array of ulongs to the kernel_cap_t
> +	 * internal representation
> +	 */
> +	for (i = 0; i < _KERNEL_CAPABILITY_U32S; i++)
> +		new_cap.cap[i] = cap_array[i];
> +
> +	/*
> +	 * Drop everything not in the new_cap (but don't add things)
> +	 */
> +	if (write) {
> +		if (table->data == CAP_BSET)
> +			usermodehelper_bset = cap_intersect(usermodehelper_bset, new_cap);
> +		if (table->data == CAP_PI)
> +			usermodehelper_inheritable = cap_intersect(usermodehelper_inheritable, new_cap);
> +	}
> +
> +	return 0;
> +}
> +
> +struct ctl_table usermodehelper_table[] = {
> +	{
> +		.procname	= "bset",
> +		.data		= CAP_BSET,
> +		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
> +		.mode		= 0600,
> +		.proc_handler	= proc_cap_handler,
> +	},
> +	{
> +		.procname	= "inheritable",
> +		.data		= CAP_PI,
> +		.maxlen		= _KERNEL_CAPABILITY_U32S * sizeof(unsigned long),
> +		.mode		= 0600,
> +		.proc_handler	= proc_cap_handler,
> +	},
> +	{ }
> +};
> +
>  void __init usermodehelper_init(void)
>  {
>  	khelper_wq = create_singlethread_workqueue("khelper");
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 0f1bd83..099d2e2 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -56,6 +56,7 @@
>  #include <linux/kprobes.h>
>  #include <linux/pipe_fs_i.h>
>  #include <linux/oom.h>
> +#include <linux/kmod.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/processor.h>
> @@ -617,6 +618,11 @@ static struct ctl_table kern_table[] = {
>  		.child		= random_table,
>  	},
>  	{
> +		.procname	= "usermodehelper",
> +		.mode		= 0555,
> +		.child		= usermodehelper_table,
> +	},
> +	{
>  		.procname	= "overflowuid",
>  		.data		= &overflowuid,
>  		.maxlen		= sizeof(int),
> 
> 
