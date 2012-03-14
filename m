Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760695Ab2CNBlP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 21:41:15 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:40028 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760682Ab2CNBlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 21:41:12 -0400
Date: Tue, 13 Mar 2012 18:41:06 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120314014106.GI19584@count0.beaverton.ibm.com>
References: <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
 <20120313062625.GA1912@moon>
 <20120313071812.GA6969@moon>
 <20120313154337.GA25711@redhat.com>
 <20120313160044.GF1912@moon>
 <20120313160420.GA18307@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313160420.GA18307@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031401-3352-0000-0000-0000034DAF24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 08:04:20PM +0400, Cyrill Gorcunov wrote:
> On Tue, Mar 13, 2012 at 08:00:44PM +0400, Cyrill Gorcunov wrote:
> > > 
> > > This means that the num_exe_file_vmas check at the start is not needed.
> > > If you want it as a "fast-path" check, please fix the comment. Or just
> > > remove it. Otherwise the code looks as if we have to check them both.
> > 
> > Yes, I wanted a fast test first, while the second test will give
> > one-shot condition and the second attempt to setup new exe_file
> > will fail. OK, I'll update the comment block.
> > 
> 
> Something like below?
> 
> 	Cyrill
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: c/r: prctl: Add ability to set new mm_struct::exe_file
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
> Also this action is one-shot only. For secutiry reason
> we don't allow to chanage the symlink several times.
> 
> This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Reviewed-by: Oleg Nesterov <oleg@redhat.com>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Kees Cook <keescook@chromium.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: Matt Helsley <matthltc@us.ibm.com>
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
> +	 * Setting new mm::exe_file is only allowed
> +	 * when no VM_EXECUTABLE vma's left. So make
> +	 * a fast test first.
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
> +	 * Because the original mm->exe_file
> +	 * points to executable file, make sure
> +	 * this one is executable as well to not
> +	 * break an overall picture.
> +	 */
> +	err = -EACCES;
> +	if (!S_ISREG(dentry->d_inode->i_mode)	||
> +	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
> +		goto exit;

You could factor out this portion of the access checking from open_exec()
after the do_filp_open() in open_exec() and re-use it here. I know it's
tiny helper but tying these two together might be good for
maintenance later.

Should it check for some of the flags open_exec() uses? open_exec()
passes:

	O_LARGEFILE|O_RDONLY|__FMODE_EXEC

to do_filp_open(). I think a O_RDONLY check might be good. I don't
think __FMODE_EXEC is something userspace can set so could be ignored.
O_LARGEFILE might be important though.

Cheers,
	-Matt Helsley

