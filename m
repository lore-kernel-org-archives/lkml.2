Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2CMQE2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:04:28 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64753 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab2CMQE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:04:27 -0400
Date: Tue, 13 Mar 2012 20:04:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120313160420.GA18307@moon>
References: <20120309154224.GE13346@moon>
 <20120309220244.GD19584@count0.beaverton.ibm.com>
 <20120309223932.GB725@moon>
 <20120309235901.GE19584@count0.beaverton.ibm.com>
 <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
 <20120313062625.GA1912@moon>
 <20120313071812.GA6969@moon>
 <20120313154337.GA25711@redhat.com>
 <20120313160044.GF1912@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120313160044.GF1912@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 08:00:44PM +0400, Cyrill Gorcunov wrote:
> > 
> > This means that the num_exe_file_vmas check at the start is not needed.
> > If you want it as a "fast-path" check, please fix the comment. Or just
> > remove it. Otherwise the code looks as if we have to check them both.
> 
> Yes, I wanted a fast test first, while the second test will give
> one-shot condition and the second attempt to setup new exe_file
> will fail. OK, I'll update the comment block.
> 

Something like below?

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: Add ability to set new mm_struct::exe_file

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

Also this action is one-shot only. For secutiry reason
we don't allow to chanage the symlink several times.

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Kees Cook <keescook@chromium.org>
CC: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>
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
+	 * Setting new mm::exe_file is only allowed
+	 * when no VM_EXECUTABLE vma's left. So make
+	 * a fast test first.
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
+	 * Because the original mm->exe_file
+	 * points to executable file, make sure
+	 * this one is executable as well to not
+	 * break an overall picture.
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
+	 * For security reason changing mm->exe_file
+	 * is one-shot action.
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
 
