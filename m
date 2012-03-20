Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab2CTGzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 02:55:50 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35958 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754808Ab2CTGzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 02:55:48 -0400
Date: Tue, 20 Mar 2012 10:55:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>
Subject: Re: [patch 1/2] c/r: prctl: Add ability to set new
 mm_struct::exe_file
Message-ID: <20120320065543.GB14269@moon>
References: <20120316205556.595309230@openvz.org>
 <20120316210343.925446961@openvz.org>
 <20120319151507.93bab32a.akpm@linux-foundation.org>
 <20120319223941.GJ19594@moon>
 <CAFLxGvxEDs=RG7tX+j6XEUx2+wEvuCGipUzh2vSp3rj15Rq6zA@mail.gmail.com>
 <20120319154649.0687f545.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319154649.0687f545.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 03:46:49PM -0700, Andrew Morton wrote:
> > >>
> > >> What is this mysterious "security reason"?
> > >>
> > >
> > > Oh, sorry I should have included Matt's comment here
> 
> Please send a patch with the updated changelog and improved comment?
> 

Andrew, take a look please, will the changelog and comments look better?

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: add ability to set new mm_struct::exe_file

When we do restore we would like to have a way to setup
a former mm_struct::exe_file so that /proc/pid/exe would
point to the original executable file a process had at
checkpoint time.

For this the PR_SET_MM_EXE_FILE code is introduced.
This option takes a file descriptor which will be
set as a source for new /proc/$pid/exe symlink.

Note it allows to change /proc/$pid/exe iif there
are no VM_EXECUTABLE vmas present for current process,
simply because this feature is a special to C/R
and mm::num_exe_file_vmas become meaningless after
that.

To minimize the amount of transition the /proc/pid/exe
symlink might have, this feature is implemented in one-shot
manner. Thus once changed the symlink can't be changed
again. This should help sysadmins to monitor the symlinks
over all process running in a system.

In particular one could make a snapshot of processes and
ring alarm if there unexpected changes of /proc/pid/exe's
in a system.

Note -- this feature is available iif CONFIG_CHECKPOINT_RESTORE
is set and the caller must have CAP_SYS_RESOURCE capability
granted, otherwise the request to change symlink will be
rejected.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Kees Cook <keescook@chromium.org>
CC: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>
---
 include/linux/prctl.h |    1 
 kernel/sys.c          |   56 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

Index: linux-2.6.git/include/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/linux/prctl.h
+++ linux-2.6.git/include/linux/prctl.h
@@ -118,5 +118,6 @@
 # define PR_SET_MM_ENV_START		10
 # define PR_SET_MM_ENV_END		11
 # define PR_SET_MM_AUXV			12
+# define PR_SET_MM_EXE_FILE		13
 
 #endif /* _LINUX_PRCTL_H */
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -36,6 +36,8 @@
 #include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/fs_struct.h>
+#include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
 #include <linux/version.h>
@@ -1701,6 +1703,57 @@ static bool vma_flags_mismatch(struct vm
 		(vma->vm_flags & banned);
 }
 
+static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+{
+	struct file *exe_file;
+	struct dentry *dentry;
+	int err;
+
+	/*
+	 * Setting new mm::exe_file is only allowed when no VM_EXECUTABLE vma's
+	 * remain. So perform a quick test first.
+	 */
+	if (mm->num_exe_file_vmas)
+		return -EBUSY;
+
+	exe_file = fget(fd);
+	if (!exe_file)
+		return -EBADF;
+
+	dentry = exe_file->f_path.dentry;
+
+	/*
+	 * Because the original mm->exe_file points to executable file, make
+	 * sure that this one is executable as well, to avoid breaking an
+	 * overall picture.
+	 */
+	err = -EACCES;
+	if (!S_ISREG(dentry->d_inode->i_mode)	||
+	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+		goto exit;
+
+	err = inode_permission(dentry->d_inode, MAY_EXEC);
+	if (err)
+		goto exit;
+
+	/*
+	 * The symlink can be changed only once, just to disallow arbitrary
+	 * transitions malicious software might bring in. This means one
+	 * could make a snapshot over all processes running and monitor
+	 * /proc/pid/exe changes to notice unusual activity if needed.
+	 */
+	down_write(&mm->mmap_sem);
+	if (likely(!mm->exe_file))
+		set_mm_exe_file(mm, exe_file);
+	else
+		err = -EBUSY;
+	up_write(&mm->mmap_sem);
+
+exit:
+	fput(exe_file);
+	return err;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -1715,6 +1768,9 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
+	if (opt == PR_SET_MM_EXE_FILE)
+		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
