Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419Ab2CBO0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:26:39 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42323 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757915Ab2CBO0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:26:35 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gorcunov@gmail.com designates 10.204.148.89 as permitted sender) smtp.mail=gorcunov@gmail.com; dkim=pass header.i=gorcunov@gmail.com
Date: Fri, 2 Mar 2012 18:26:30 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file
Message-ID: <20120302142630.GK8681@moon>
References: <20120229151634.GE4796@moon>
 <20120229192400.GA13194@redhat.com>
 <20120229200103.GJ11326@moon>
 <20120301180616.GA7652@redhat.com>
 <20120301191714.GF9930@moon>
 <20120301194120.GA11400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120301194120.GA11400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 08:41:20PM +0100, Oleg Nesterov wrote:
...
> Still can't understand. I think you need:
> 
> 	file = fget(fd);
> 	if (!file)
> 		return -EBADF;
> 
> 	down_write(&mm->mmap_sem);
> 	if (mm->num_exe_file_vmas) {
> 		fput(mm->exe_file);
> 		mm->exe_file = file;
> 		file = NULL;
> 	}
> 	up_write(&mm->mmap_sem);
> 
> 	if (!file)
> 		return 0;
> 
> 	fput(file);
> 	return -ESOMETHING;
> 
> and that is all.

Hi Oleg, sure you were right. I even think testing for
num_exe_file_vmas is not needed, since until real
executable VMA is read and mapped it might remain
zero. So I guess something like below should work.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: Add ability to set new mm_struct::exe_file v2

When we do restore we would like to have a way to setup
a former mm_struct::exe_file so that /proc/pid/exe would
point to the original executable file a process had at
checkpoint time.

For this sake PR_SET_MM_EXE_FILE code is introduced.

This feature is available iif CONFIG_CHECKPOINT_RESTORE is set.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Kees Cook <keescook@chromium.org>
CC: Tejun Heo <tj@kernel.org>
---
 include/linux/prctl.h |    1 +
 kernel/sys.c          |   24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

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
@@ -36,6 +36,7 @@
 #include <linux/personality.h>
 #include <linux/ptrace.h>
 #include <linux/fs_struct.h>
+#include <linux/file.h>
 #include <linux/gfp.h>
 #include <linux/syscore_ops.h>
 #include <linux/version.h>
@@ -1701,6 +1702,25 @@ static bool vma_flags_mismatch(struct vm
 		(vma->vm_flags & banned);
 }
 
+static int prctl_set_mm_exe_file(struct mm_struct *mm, unsigned int fd)
+{
+	struct file *new_exe_file, *old_exe_file;
+
+	new_exe_file = fget(fd);
+	if (!new_exe_file)
+		return -EBADF;
+
+	down_write(&mm->mmap_sem);
+	old_exe_file = mm->exe_file;
+	mm->exe_file = new_exe_file;
+	up_write(&mm->mmap_sem);
+
+	if (old_exe_file)
+		fput(old_exe_file);
+
+	return 0;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -1715,6 +1735,9 @@ static int prctl_set_mm(int opt, unsigne
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (opt == PR_SET_MM_EXE_FILE)
+		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
+
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
@@ -1837,6 +1860,7 @@ static int prctl_set_mm(int opt, unsigne
 
 		return 0;
 	}
+
 	default:
 		error = -EINVAL;
 		goto out;
