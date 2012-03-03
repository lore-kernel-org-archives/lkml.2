Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2CCWdj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 17:33:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54253 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab2CCWdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 17:33:38 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.133.196 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Sun, 4 Mar 2012 02:33:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120303223333.GB26846@moon>
References: <20120229151634.GE4796@moon>
 <20120229192400.GA13194@redhat.com>
 <20120229200103.GJ11326@moon>
 <20120301180616.GA7652@redhat.com>
 <20120301191714.GF9930@moon>
 <20120301194120.GA11400@redhat.com>
 <20120302142630.GK8681@moon>
 <20120302152621.GA29744@redhat.com>
 <20120302161247.GO8681@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120302161247.GO8681@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 02, 2012 at 08:12:47PM +0400, Cyrill Gorcunov wrote:
...
> 
> Yes, Oleg, you're right of course! The set_mm_exe_file confused
> me a bit (I didn't reply to your previous emails simply because
> you were asking me to prove what exactly is broken when num_exe_file_vmas
> greater 2 and we reassign new exe_file, and I didn't know what to reply
> since I knew I was wrong in first assumption).
> 
> As a conclusion -- sure I need to check for num_exe_file_vmas to
> not break current logic, thanks!
> 

Hi Oleg,

i suppose the below one should do the trick. I mostly concerned
at moment if I added all permission tests needed.

	Cyrill
---
c/r: prctl: Add ability to set new mm_struct::exe_file v2

From: Cyrill Gorcunov <gorcunov@openvz.org>

When we do restore we would like to have a way to setup
a former mm_struct::exe_file so that /proc/pid/exe would
point to the original executable file a process had at
checkpoint time.

For this the PR_SET_MM_EXE_FILE code is introduced.

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Kees Cook <keescook@chromium.org>
CC: Tejun Heo <tj@kernel.org>
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
@@ -1701,6 +1703,56 @@ static bool vma_flags_mismatch(struct vm
 		(vma->vm_flags & banned);
 }
 
+static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+{
+	struct file *exe_file;
+	struct dentry *dentry;
+	int err;
+
+	exe_file = fget(fd);
+	if (!exe_file)
+		return -EBADF;
+
+	dentry = exe_file->f_path.dentry;
+
+	/*
+	 * Permissions should be the same as if the
+	 * file has being opened by the kernel for
+	 * execution.
+	 */
+	err = -EACCES;
+	if (!S_ISREG(dentry->d_inode->i_mode)	||
+	    exe_file->f_path.mnt->mnt_flags & MNT_NOEXEC)
+		goto exit;
+
+	if ((exe_file->f_flags & O_ACCMODE) != O_RDONLY)
+		goto exit;
+
+	err = inode_permission(dentry->d_inode, MAY_EXEC);
+	if (err)
+		goto exit;
+
+	down_write(&mm->mmap_sem);
+	if (mm->num_exe_file_vmas) {
+
+		err = deny_write_access(exe_file);
+		if (err) {
+			up_write(&mm->mmap_sem);
+			goto exit;
+		}
+
+		fput(mm->exe_file);
+		mm->exe_file = exe_file;
+	} else {
+		fput(exe_file);
+		err = -ENXIO;
+	}
+	up_write(&mm->mmap_sem);
+
+exit:
+	return err;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -1715,6 +1767,9 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (opt == PR_SET_MM_EXE_FILE)
+		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
@@ -1837,6 +1892,7 @@ static int prctl_set_mm(int opt, unsigne
 
 		return 0;
 	}
+
 	default:
 		error = -EINVAL;
 		goto out;
