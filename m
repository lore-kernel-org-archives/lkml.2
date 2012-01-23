Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107Ab2AWOj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:39:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:40470 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2AWOj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:39:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Vasiliy Kulikov <segoon@openwall.com>,
        Dan Ballard <dan@mindstab.net>, Jiri Kosina <jkosina@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Stephen Wilson <wilsons@start.ca>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v2] sysctl: control functionality of /proc/pid/mem
References: <20120121090644.GA31670@www.outflux.net>
Date: Mon, 23 Jan 2012 06:41:50 -0800
In-Reply-To: <20120121090644.GA31670@www.outflux.net> (Kees Cook's message of
	"Sat, 21 Jan 2012 01:06:44 -0800")
Message-ID: <m1mx9epjkh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19S2AxERSXCanH6k9GdNivnyjo4XhElA5c=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Add the "proc_pid_mem" sysctl to control whether or not /proc/pid/mem is
> allowed to work: 0: disabled, 1: read only, 2: read/write.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  Documentation/sysctl/kernel.txt |   14 ++++++++++++++
>  fs/proc/base.c                  |   14 +++++++++++++-
>  kernel/sysctl.c                 |   14 ++++++++++++++
>  3 files changed, 41 insertions(+), 1 deletions(-)
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 8c20fbd..6d52dba 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -56,6 +56,7 @@ show up in /proc/sys/kernel:
>  - printk_delay
>  - printk_ratelimit
>  - printk_ratelimit_burst
> +- proc_pid_mem
>  - randomize_va_space
>  - real-root-dev               ==> Documentation/initrd.txt
>  - reboot-cmd                  [ SPARC only ]
> @@ -477,6 +478,19 @@ send before ratelimiting kicks in.
>  
>  ==============================================================
>  
> +proc_pid_mem:
> +
> +This option can be used to select the level of access given to potential
> +ptracers when using the per-process "mem" file in /proc/pid/mem.
> +
> +0 - Disable entirely.
> +
> +1 - Allow potential ptracers read access to process memory, but not writes.
> +
> +2 - Allow potential ptracers read and write access to process memory.
> +
> +==============================================================
> +
>  randomize_va_space:
>  
>  This option can be used to select the type of process address
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 9cde9ed..53133c7 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -109,6 +109,8 @@ struct pid_entry {
>  	union proc_op op;
>  };
>  
> +int sysctl_proc_pid_mem = 2;
> +
>  #define NOD(NAME, MODE, IOP, FOP, OP) {			\
>  	.name = (NAME),					\
>  	.len  = sizeof(NAME) - 1,			\
> @@ -699,9 +701,13 @@ static const struct file_operations proc_single_file_operations = {
>  
>  static int mem_open(struct inode* inode, struct file* file)
>  {
> -	struct task_struct *task = get_proc_task(file->f_path.dentry->d_inode);
> +	struct task_struct *task;
>  	struct mm_struct *mm;
>  
> +	if (sysctl_proc_pid_mem < 1)
> +		return -EACCES;
> +
> +	task = get_proc_task(file->f_path.dentry->d_inode);
>  	if (!task)
>  		return -ESRCH;
>  
> @@ -726,6 +732,9 @@ static ssize_t mem_read(struct file * file, char __user * buf,
>  	unsigned long src = *ppos;
>  	struct mm_struct *mm = file->private_data;
>  
> +	if (sysctl_proc_pid_mem < 1)
> +		return -EACCES;
> +
>  	if (!mm)
>  		return 0;
>  
> @@ -770,6 +779,9 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
>  	unsigned long dst = *ppos;
>  	struct mm_struct *mm = file->private_data;
>  
> +	if (sysctl_proc_pid_mem < 2)
> +		return -EACCES;
> +
>  	if (!mm)
>  		return 0;
>  
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f487f25..dda911f 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -109,6 +109,9 @@ extern int sysctl_nr_trim_pages;
>  #ifdef CONFIG_BLOCK
>  extern int blk_iopoll_enabled;
>  #endif
> +#ifdef CONFIG_PROC_FS
> +extern int sysctl_proc_pid_mem;
> +#endif
>  
>  /* Constants used for minimum and  maximum */
>  #ifdef CONFIG_LOCKUP_DETECTOR
> @@ -1004,6 +1007,17 @@ static struct ctl_table kern_table[] = {
>  		.proc_handler	= proc_dointvec,
>  	},
>  #endif
> +#ifdef CONFIG_PROC_FS
    ^^^^^^^^^^^^^^^^^^^^^^

That ifdef is entertaining.  CONFIG_SYSCTL depends on CONFIG_PROC_FS
so which interesting case did you imagine this ifdef would be false?
Did you test to ensure the code is not compiled in that interesting case?

> +	{
> +		.procname	= "proc_pid_mem",
> +		.data		= &sysctl_proc_pid_mem,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &two,
> +	},
> +#endif
>  	{ }
>  };
