Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab0FXA2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 20:28:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43231 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860Ab0FXA22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 20:28:28 -0400
X-Authority-Analysis: v=1.1 cv=hVjE12FRt4v4sD2HVuppbi620CRC5en4UNTr7KPd1ng= c=1 sm=0 a=q8OS1GolVHwA:10 a=kj9zAlcOel0A:10 a=Nqdp4+S2FArj7gZzHVn+tA==:17 a=DfNHnWVPAAAA:8 a=hBqU3vQJAAAA:8 a=rI5KbPxm1VBh6KXL930A:9 a=Rm0PeW1c_cxL_NHDpCwA:7 a=7ePWS3aOhbOebyD5bITOCVlHjPgA:4 a=CjuIK1q_8ugA:10 a=lBRciGGoxdUA:10 a=4gZ4WExUoD4A:10 wl=env:18 a=Nqdp4+S2FArj7gZzHVn+tA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 70.120.198.24
Date: Wed, 23 Jun 2010 19:28:59 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] security: Yama LSM
Message-ID: <20100624002859.GA4841@hallyn.com>
References: <20100623182054.GN5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623182054.GN5876@outflux.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (kees.cook@canonical.com):
> This adds the Yama Linux Security Module to collect several security
> features (symlink, hardlink, and PTRACE scope restrictions) that have
> existed in various forms over the years and have been carried outside the
> mainline kernel by other Linux distributions like Openwall and grsecurity.
> 
> Signed-off-by: Kees Cook <kees.cook@canonical.com>

Acked-by: Serge E. Hallyn <serge@hallyn.com>

> +==============================================================
> diff --git a/fs/exec.c b/fs/exec.c
> index e19de6a..85092e3 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -55,6 +55,7 @@
>  #include <linux/fsnotify.h>
>  #include <linux/fs_struct.h>
>  #include <linux/pipe_fs_i.h>
> +#include <linux/ctype.h>
>  
>  #include <asm/uaccess.h>
>  #include <asm/mmu_context.h>

Can you explain the fs/exec.c hunk?

...

> +static int yama_ptrace_access_check(struct task_struct *child,
> +				    unsigned int mode)
> +{
> +	int rc;
> +
> +	rc = cap_ptrace_access_check(child, mode);
> +	if (rc != 0)
> +		return rc;
> +
> +	/* require ptrace target be a child of ptracer on attach */
> +	if (mode == PTRACE_MODE_ATTACH && ptrace_scope &&
> +	    !capable(CAP_SYS_PTRACE)) {
> +		struct task_struct *walker = child;
> +
> +		rcu_read_lock();
> +		read_lock(&tasklist_lock);
> +		while (walker->pid > 0) {
> +			if (walker == current)
> +				break;
> +			walker = walker->real_parent;
> +		}
> +		if (walker->pid == 0)
> +			rc = -EPERM;

Don't recall whether I ended up sending the email addressing this
last time, but task->pid is the global pid, so pid==0 does mean
what you think it does regardless of pid namespaces.

> +		read_unlock(&tasklist_lock);
> +		rcu_read_unlock();
> +	}
> +
> +	if (rc) {
> +		char name[sizeof(current->comm)];
> +		printk_ratelimited(KERN_INFO "ptrace of non-child"
> +			" pid %d was attempted by: %s (pid %d)\n",
> +			child->pid, get_task_comm(name, current),
> +			current->pid);
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * yama_inode_follow_link - check for symlinks in sticky world-writeable dirs
> + * @dentry: The inode/dentry of the symlink
> + * @nameidata: The path data of the symlink
> + *
> + * In the case of the protected_sticky_symlinks sysctl being enabled,
> + * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
> + * in a sticky world-writable directory.  This is to protect privileged
> + * processes from failing races against path names that may change out
> + * from under them by way of other users creating malicious symlinks.
> + * It will permit symlinks to only be followed when outside a sticky
> + * world-writable directory, or when the uid of the symlink and follower
> + * match, or when the directory owner matches the symlink's owner.
> + *
> + * Returns 0 if following the symlink is allowed, -ve on error.
> + */
> +static int yama_inode_follow_link(struct dentry *dentry,
> +				  struct nameidata *nameidata)
> +{
> +	int rc = 0;
> +	const struct inode *parent;
> +	const struct inode *inode;
> +	const struct cred *cred;
> +
> +	if (!protected_sticky_symlinks)
> +		return 0;
> +
> +	/* owner and follower match? */
> +	cred = current_cred();
> +	inode = dentry->d_inode;
> +	if (cred->fsuid == inode->i_uid)
> +		return 0;

This'll need user-namespace luvin' at some point, but that's my problem,
not yours.

-serge
