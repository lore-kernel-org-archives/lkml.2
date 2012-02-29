Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031173Ab2B2PQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 10:16:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52475 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031134Ab2B2PQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 10:16:40 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.152.208 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Wed, 29 Feb 2012 19:16:34 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120229151634.GE4796@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

at restore time we would like to have a way for /proc/pid/exe
symlink recovering. So I thought extending prctl might be
a good idea.

Still maybe there some other good and 'right' way to do it,
so I would like to gather opinions.

Please review, thanks!

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file

When we do restore we would like to have a way to setup
a former mm_struct::exe_file so that /proc/pid/exe would
point to the original executable file a process had at
checkpoint time.

For this sake PR_SET_MM_EXE_FILE code is introduced.

Note, if mm_struct::exe_file already mapped more than once
we refuse to change anything (which prevents kernel from
potential problems).

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 include/linux/prctl.h |    1 
 kernel/sys.c          |   73 +++++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 73 insertions(+), 1 deletion(-)

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
@@ -1701,6 +1701,66 @@ static bool vma_flags_mismatch(struct vm
 		(vma->vm_flags & banned);
 }
 
+/* Expects mm->mmap_sem is read-taken */
+static int prctl_set_mm_exe_file(struct mm_struct *mm,
+				 const void __user *path,
+				 size_t size)
+{
+	struct file *new_exe_file;
+	char *pathbuf;
+	int ret = 0;
+
+	if (size >= PATH_MAX)
+		return -EINVAL;
+
+	/*
+	 * We allow to change only those exe's which
+	 * are not mapped several times. This one
+	 * is early test while mmap_sem is taken.
+	 */
+	if (mm->num_exe_file_vmas > 1)
+		return -EBUSY;
+
+	up_read(&mm->mmap_sem);
+
+	pathbuf = kmalloc(size, GFP_TEMPORARY);
+	if (!pathbuf) {
+		ret = -ENOMEM;
+		goto err_down;
+	}
+
+	if (copy_from_user(pathbuf, path, size)) {
+		kfree(pathbuf);
+		ret = -EFAULT;
+		goto err_down;
+	}
+	pathbuf[size-1] = '\0';
+
+	new_exe_file = open_exec(pathbuf);
+	kfree(pathbuf);
+
+	down_read(&mm->mmap_sem);
+
+	if (IS_ERR(new_exe_file))
+		return PTR_ERR(new_exe_file);
+
+	/*
+	 * We allow to change only those exe's which
+	 * are not mapped several times.
+	 */
+	if (mm->num_exe_file_vmas < 2) {
+		set_mm_exe_file(mm, new_exe_file);
+		ret = 0;
+	} else
+		ret = -EBUSY;
+
+	return ret;
+
+err_down:
+	down_read(&mm->mmap_sem);
+	return ret;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -1709,7 +1769,9 @@ static int prctl_set_mm(int opt, unsigne
 	struct vm_area_struct *vma;
 	int error = 0;
 
-	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
+	if (arg5 || (arg4 &&
+		     opt != PR_SET_MM_AUXV &&
+		     opt != PR_SET_MM_EXE_FILE))
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1837,6 +1899,15 @@ static int prctl_set_mm(int opt, unsigne
 
 		return 0;
 	}
+
+	/*
+	 * This to restore /proc/self/exe link.
+	 */
+	case PR_SET_MM_EXE_FILE:
+		error = prctl_set_mm_exe_file(mm, (const void __user *)addr, arg4);
+		if (error)
+			goto out;
+		break;
 	default:
 		error = -EINVAL;
 		goto out;
