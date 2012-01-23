Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab2AWOYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 09:24:46 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48773 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2AWOYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 09:24:43 -0500
Message-Id: <20120123142436.431548686@openvz.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 Jan 2012 18:20:40 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: [patch 4/4] c/r: prctl: Extend PR_SET_MM to set up more mm_struct entries
References: <20120123142036.025893883@openvz.org>
Content-Disposition: inline; filename=prctl-restore-mm-members-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After restore we would like the 'ps' command show the command
line and evironment exactly the same it was at checkpoint time.

So this additional PR_SET_MM_ allow us to do so. Note that
these members of mm_struct is rather used for output in
procfs, except auxv vector which is used by ld.so mostly.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/prctl.h |    5 +++
 kernel/sys.c          |   73 +++++++++++++++++++++++++++++++-------------------
 2 files changed, 51 insertions(+), 27 deletions(-)

Index: linux-2.6.git/include/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/linux/prctl.h
+++ linux-2.6.git/include/linux/prctl.h
@@ -113,5 +113,10 @@
 # define PR_SET_MM_START_STACK		5
 # define PR_SET_MM_START_BRK		6
 # define PR_SET_MM_BRK			7
+# define PR_SET_MM_ARG_START		8
+# define PR_SET_MM_ARG_END		9
+# define PR_SET_MM_ENV_START		10
+# define PR_SET_MM_ENV_END		11
+# define PR_SET_MM_AUXV			12
 
 #endif /* _LINUX_PRCTL_H */
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1693,17 +1693,25 @@ SYSCALL_DEFINE1(umask, int, mask)
 }
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
+static bool vma_flags_mismatch(struct vm_area_struct *vma,
+			       unsigned long required,
+			       unsigned long banned)
+{
+	return (vma->vm_flags & required) != required ||
+		(vma->vm_flags & banned);
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
 	unsigned long rlim = rlimit(RLIMIT_DATA);
-	unsigned long vm_req_flags;
-	unsigned long vm_bad_flags;
 	struct vm_area_struct *vma;
 	int error = 0;
 	struct mm_struct *mm = current->mm;
 
-	if (arg4 | arg5)
+	if (arg4 && opt != PR_SET_MM_AUXV)
+		return -EINVAL;
+	else if (arg4 | arg5)
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1715,7 +1723,9 @@ static int prctl_set_mm(int opt, unsigne
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
-	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
+	if (opt != PR_SET_MM_START_BRK &&
+	    opt != PR_SET_MM_BRK &&
+	    opt != PR_SET_MM_AUXV) {
 		/* It must be existing VMA */
 		if (!vma || vma->vm_start > addr)
 			goto out;
@@ -1725,11 +1735,8 @@ static int prctl_set_mm(int opt, unsigne
 	switch (opt) {
 	case PR_SET_MM_START_CODE:
 	case PR_SET_MM_END_CODE:
-		vm_req_flags = VM_READ | VM_EXEC;
-		vm_bad_flags = VM_WRITE | VM_MAYSHARE;
-
-		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
-		    (vma->vm_flags & vm_bad_flags))
+		if (vma_flags_mismatch(vma, VM_READ | VM_EXEC,
+				       VM_WRITE | VM_MAYSHARE))
 			goto out;
 
 		if (opt == PR_SET_MM_START_CODE)
@@ -1740,11 +1747,8 @@ static int prctl_set_mm(int opt, unsigne
 
 	case PR_SET_MM_START_DATA:
 	case PR_SET_MM_END_DATA:
-		vm_req_flags = VM_READ | VM_WRITE;
-		vm_bad_flags = VM_EXEC | VM_MAYSHARE;
-
-		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
-		    (vma->vm_flags & vm_bad_flags))
+		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE,
+				       VM_EXEC | VM_MAYSHARE))
 			goto out;
 
 		if (opt == PR_SET_MM_START_DATA)
@@ -1753,19 +1757,6 @@ static int prctl_set_mm(int opt, unsigne
 			mm->end_data = addr;
 		break;
 
-	case PR_SET_MM_START_STACK:
-
-#ifdef CONFIG_STACK_GROWSUP
-		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSUP;
-#else
-		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSDOWN;
-#endif
-		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
-			goto out;
-
-		mm->start_stack = addr;
-		break;
-
 	case PR_SET_MM_START_BRK:
 		if (addr <= mm->end_data)
 			goto out;
@@ -1790,6 +1781,34 @@ static int prctl_set_mm(int opt, unsigne
 		mm->brk = addr;
 		break;
 
+	case PR_SET_MM_START_STACK:
+	case PR_SET_MM_ARG_START:
+	case PR_SET_MM_ARG_END:
+	case PR_SET_MM_ENV_START:
+	case PR_SET_MM_ENV_END:
+#ifdef CONFIG_STACK_GROWSUP
+		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSUP, 0))
+#else
+		if (vma_flags_mismatch(vma, VM_READ | VM_WRITE | VM_GROWSDOWN, 0))
+#endif
+			goto out;
+		if (opt == PR_SET_MM_ARG_START)
+			mm->start_stack = addr;
+		else if (opt == PR_SET_MM_ARG_START)
+			mm->arg_start = addr;
+		else if (opt == PR_SET_MM_ARG_END)
+			mm->arg_end = addr;
+		else if (opt == PR_SET_MM_ENV_START)
+			mm->env_start = addr;
+		else if (opt == PR_SET_MM_ENV_END)
+			mm->env_end = addr;
+		break;
+
+	case PR_SET_MM_AUXV:
+		if (arg4 > sizeof(mm->saved_auxv))
+			goto out;
+		error = copy_from_user(mm->saved_auxv, (const void __user *)addr, arg4);
+		break;
 	default:
 		error = -EINVAL;
 		goto out;

