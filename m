Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab2CINgB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:36:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63840 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2CINgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:36:00 -0500
Date: Fri, 9 Mar 2012 17:35:55 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309133555.GA23040@moon>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
 <20120308190534.GA19827@redhat.com>
 <20120308192504.GH21812@moon>
 <20120308192559.GA20782@redhat.com>
 <20120308214817.GO21812@moon>
 <20120309124811.GA610@redhat.com>
 <20120309125735.GB13346@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309125735.GB13346@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 04:57:35PM +0400, Cyrill Gorcunov wrote:
> 
> yeah, thanks, will update.
> 

This one should fit all requirements I hope.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: Add ability to set new mm_struct::exe_file v5

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

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>
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
+	 * Setting new mm::exe_file is only allowed
+	 * when no VM_EXECUTABLE vma's left. This is
+	 * a special C/R case when a restored program
+	 * need to change own /proc/$pid/exe symlink.
+	 * After this call mm::num_exe_file_vmas become
+	 * meaningless. If mm::num_exe_file_vmas will
+	 * ever increase back from zero -- this code
+	 * needs to be revised, thus WARN_ here, just
+	 * to be sure.
+	 */
+	down_write(&mm->mmap_sem);
+	WARN_ON_ONCE(mm->num_exe_file_vmas);
+	set_mm_exe_file(mm, exe_file);
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
 
