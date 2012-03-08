Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab2CHSdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:33:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab2CHSdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:33:39 -0500
Date: Thu, 8 Mar 2012 19:26:23 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>, Matt Helsley <matthltc@us.ibm.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308182623.GA17221@redhat.com>
References: <20120308165112.GF21812@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308165112.GF21812@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Cyrill Gorcunov wrote:
>
> Hi Oleg, could you please take a look once you get a minute (no urgency).

Add Matt. I won't touch the text below to keep the patch intact.

With this change

	down_write(&mm->mmap_sem);
	if (mm->num_exe_file_vmas) {
		fput(mm->exe_file);
		mm->exe_file = exe_file;
		exe_file = NULL;
	} else
		set_mm_exe_file(mm, exe_file);
	up_write(&mm->mmap_sem);

I simply do not understand what mm->num_exe_file_vmas means after
PR_SET_MM_EXE_FILE.

I think that you should do

	down_write(&mm->mmap_sem);
	if (mm->num_exe_file_vmas) {
		fput(mm->exe_file);
		mm->exe_file = exe_file;
		exe_file = NULL;
	}
	up_write(&mm->mmap_sem);

to keep the current "mm->exe_file goes away after the final
unmap(MAP_EXECUTABLE)" logic.

OK, may be this doesn't work in c/r case because you are actually
going to remove the old mappings? But in this case the new exe_file
will go away anyway, afaics PR_SET_MM_EXE_FILE is called when you
still have the old mappings.

And I don't think the unconditional

	down_write(&mm->mmap_sem);
	set_mm_exe_file(mm, exe_file);
	up_write(&mm->mmap_sem);

is 100% right, this clears ->num_exe_file_vmas. This means that
(if you still have the old mapping) the new exe_file can go away
after added_exe_file_vma() + removed_exe_file_vma(). Normally this
should happen, but afaics this is possible. Note that even, say,
mprotect() can trigger added_exe_file_vma().

May be we can do something like

	down_write(&mm->mmap_sem);
	set_mm_exe_file(mm, exe_file);
	// we are cheating anyway, make sure it can never == 0
	// if we have the "old" VM_EXECUTABLE vmas.
	mm->num_exe_file_vmas = LONG_MAX;
	up_write(&mm->mmap_sem);

I dunno. Matt, could you help?

> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: c/r: prctl: Add ability to set new mm_struct::exe_file v3
>
> When we do restore we would like to have a way to setup
> a former mm_struct::exe_file so that /proc/pid/exe would
> point to the original executable file a process had at
> checkpoint time.
>
> For this the PR_SET_MM_EXE_FILE code is introduced.
> This option takes a file descriptor which will be
> set as new /proc/$pid/exe symlink.
>
> This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Kees Cook <keescook@chromium.org>
> CC: Tejun Heo <tj@kernel.org>
> ---
>  include/linux/prctl.h |    1 +
>  kernel/sys.c          |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
>
> Index: linux-2.6.git/include/linux/prctl.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/prctl.h
> +++ linux-2.6.git/include/linux/prctl.h
> @@ -118,5 +118,6 @@
>  # define PR_SET_MM_ENV_START		10
>  # define PR_SET_MM_ENV_END		11
>  # define PR_SET_MM_AUXV			12
> +# define PR_SET_MM_EXE_FILE		13
>
>  #endif /* _LINUX_PRCTL_H */
> Index: linux-2.6.git/kernel/sys.c
> ===================================================================
> --- linux-2.6.git.orig/kernel/sys.c
> +++ linux-2.6.git/kernel/sys.c
> @@ -36,6 +36,8 @@
>  #include <linux/personality.h>
>  #include <linux/ptrace.h>
>  #include <linux/fs_struct.h>
> +#include <linux/file.h>
> +#include <linux/mount.h>
>  #include <linux/gfp.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/version.h>
> @@ -1701,6 +1703,50 @@ static bool vma_flags_mismatch(struct vm
>  		(vma->vm_flags & banned);
>  }
>
> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *exe_file;
> +	struct dentry *dentry;
> +	int err;
> +
> +	exe_file = fget(fd);
> +	if (!exe_file)
> +		return -EBADF;
> +
> +	dentry = exe_file->f_path.dentry;
> +
> +	/*
> +	 * Because the original mm->exe_file
> +	 * points to executable file, make sure
> +	 * this one is executable as well to not
> +	 * break "big" picture and proc/pid/exe
> +	 * symlink will be still pointing to
> +	 * executable one.
> +	 */
> +	err = -EACCES;
> +	if (!S_ISREG(dentry->d_inode->i_mode)	||
> +	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> +		goto exit;
> +
> +	err = inode_permission(dentry->d_inode, MAY_EXEC);
> +	if (err)
> +		goto exit;
> +
> +	down_write(&mm->mmap_sem);
> +	if (mm->num_exe_file_vmas) {
> +		fput(mm->exe_file);
> +		mm->exe_file = exe_file;
> +		exe_file = NULL;
> +	} else
> +		set_mm_exe_file(mm, exe_file);
> +	up_write(&mm->mmap_sem);
> +
> +exit:
> +	if (exe_file)
> +		fput(exe_file);
> +	return err;
> +}
> +
>  static int prctl_set_mm(int opt, unsigned long addr,
>  			unsigned long arg4, unsigned long arg5)
>  {
> @@ -1715,6 +1761,9 @@ static int prctl_set_mm(int opt, unsigne
>  	if (!capable(CAP_SYS_RESOURCE))
>  		return -EPERM;
>
> +	if (opt == PR_SET_MM_EXE_FILE)
> +		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
> +
>  	if (addr >= TASK_SIZE)
>  		return -EINVAL;
>
> @@ -1837,6 +1886,7 @@ static int prctl_set_mm(int opt, unsigne
>
>  		return 0;
>  	}
> +
>  	default:
>  		error = -EINVAL;
>  		goto out;

