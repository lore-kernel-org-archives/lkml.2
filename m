Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031528Ab2CVXfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:35:21 -0400
Received: from out07.mta.xmission.com ([166.70.13.237]:39193 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752664Ab2CVXfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:35:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
References: <20120316205556.595309230@openvz.org>
	<20120316210343.925446961@openvz.org>
	<20120319151507.93bab32a.akpm@linux-foundation.org>
	<20120319223941.GJ19594@moon>
	<CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
	<20120319154649.0687f545.akpm@linux-foundation.org>
	<20120320065543.GB14269@moon>
Date: Thu, 22 Mar 2012 16:38:43 -0700
In-Reply-To: <20120320065543.GB14269@moon> (Cyrill Gorcunov's message of "Tue,
	20 Mar 2012 10:55:43 +0400")
Message-ID: <m14ntgxl30.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+JhsAjAyYBMnS/5yaB2DSRLFHmbWshFAY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  7.0 XM_URI_RBL URI blacklisted in uri.bl.xmission.com
	*      [URIs: openvz.org]
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *******;Cyrill Gorcunov <gorcunov@openvz.org>
X-Spam-Relay-Country: **
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new mm_struct::exe_file
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov <gorcunov@openvz.org> writes:

> On Mon, Mar 19, 2012 at 03:46:49PM -0700, Andrew Morton wrote:
>> > >>
>> > >> What is this mysterious "security reason"?
>> > >>
>> > >
>> > > Oh, sorry I should have included Matt's comment here
>> 
>> Please send a patch with the updated changelog and improved comment?
>> 
>
> Andrew, take a look please, will the changelog and comments look
> better?

Can you change this to take an actual address and get the exe_file
from an mmapped area and make certain that the mmaped_area is already
mapped MAP_EXEC.

That will prevent out-right lies.

At least then we will know that exe_file will at least be a file that is
mapped executable in the process's address space.  It's not a lot better
but it makes /proc/<pid>/exe at almost as trustable as it is now.

> 	Cyrill
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: c/r: prctl: add ability to set new mm_struct::exe_file
>
> When we do restore we would like to have a way to setup
> a former mm_struct::exe_file so that /proc/pid/exe would
> point to the original executable file a process had at
> checkpoint time.
>
> For this the PR_SET_MM_EXE_FILE code is introduced.
> This option takes a file descriptor which will be
> set as a source for new /proc/$pid/exe symlink.
>
> Note it allows to change /proc/$pid/exe iif there
> are no VM_EXECUTABLE vmas present for current process,
> simply because this feature is a special to C/R
> and mm::num_exe_file_vmas become meaningless after
> that.
>
> To minimize the amount of transition the /proc/pid/exe
> symlink might have, this feature is implemented in one-shot
> manner. Thus once changed the symlink can't be changed
> again. This should help sysadmins to monitor the symlinks
> over all process running in a system.
>
> In particular one could make a snapshot of processes and
> ring alarm if there unexpected changes of /proc/pid/exe's
> in a system.
>
> Note -- this feature is available iif CONFIG_CHECKPOINT_RESTORE
> is set and the caller must have CAP_SYS_RESOURCE capability
> granted, otherwise the request to change symlink will be
> rejected.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Kees Cook <keescook@chromium.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: Matt Helsley <matthltc@us.ibm.com>
> CC: richard -rw- weinberger <richard.weinberger@gmail.com>
> ---
>  include/linux/prctl.h |    1 
>  kernel/sys.c          |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 57 insertions(+)
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
> @@ -1701,6 +1703,57 @@ static bool vma_flags_mismatch(struct vm
>  		(vma->vm_flags & banned);
>  }
>  
> +static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
> +{
> +	struct file *exe_file;
> +	struct dentry *dentry;
> +	int err;
> +
> +	/*
> +	 * Setting new mm::exe_file is only allowed when no VM_EXECUTABLE vma's
> +	 * remain. So perform a quick test first.
> +	 */
> +	if (mm->num_exe_file_vmas)
> +		return -EBUSY;
> +
> +	exe_file = fget(fd);
> +	if (!exe_file)
> +		return -EBADF;
> +
> +	dentry = exe_file->f_path.dentry;
> +
> +	/*
> +	 * Because the original mm->exe_file points to executable file, make
> +	 * sure that this one is executable as well, to avoid breaking an
> +	 * overall picture.
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
> +	/*
> +	 * The symlink can be changed only once, just to disallow arbitrary
> +	 * transitions malicious software might bring in. This means one
> +	 * could make a snapshot over all processes running and monitor
> +	 * /proc/pid/exe changes to notice unusual activity if needed.
> +	 */
> +	down_write(&mm->mmap_sem);
> +	if (likely(!mm->exe_file))
> +		set_mm_exe_file(mm, exe_file);
> +	else
> +		err = -EBUSY;
> +	up_write(&mm->mmap_sem);
> +
> +exit:
> +	fput(exe_file);
> +	return err;
> +}
> +
>  static int prctl_set_mm(int opt, unsigned long addr,
>  			unsigned long arg4, unsigned long arg5)
>  {
> @@ -1715,6 +1768,9 @@ static int prctl_set_mm(int opt, unsigne
>  	if (!capable(CAP_SYS_RESOURCE))
>  		return -EPERM;
>  
> +	if (opt == PR_SET_MM_EXE_FILE)
> +		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
> +
>  	if (addr >= TASK_SIZE)
>  		return -EINVAL;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
