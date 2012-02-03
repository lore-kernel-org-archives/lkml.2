Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2BCRKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:10:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45438 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894Ab2BCRKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:10:52 -0500
Date: Fri, 3 Feb 2012 21:10:45 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 4/4] c/r: prctl: Extend PR_SET_MM to set up more
 mm_struct entries
Message-ID: <20120203171045.GK11834@moon>
References: <20120203151928.474036973@openvz.org>
 <20120203152650.894621377@openvz.org>
 <CAGXu5jKsFoMS4XgfOQBZYabrD_5BJAyaXn=5tW9xFd4GuBXTQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jKsFoMS4XgfOQBZYabrD_5BJAyaXn=5tW9xFd4GuBXTQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 08:56:20AM -0800, Kees Cook wrote:
> On Fri, Feb 3, 2012 at 7:19 AM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > +       case PR_SET_MM_AUXV: {
> > +               unsigned long user_auxv[AT_VECTOR_SIZE];
> > +
> > +               if (arg4 > sizeof(mm->saved_auxv))
> > +                       goto out;
> 
> While these are both AT_VECTOR_SIZE, I think it might be better to use
> sizeof(mm->saved_auxv) instead of AT_VECTOR_SIZE, just so that they
> can never get out sync and there's a single reference for the size.
> 

I suppose you meant ARRAY_SIZE rather since plain sizeof will give you
the summary size in bytes, but I think I have better idea -- lets put
BUILD_BUG_ON here, like below.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: c/r: prctl: Extend PR_SET_MM to set up more mm_struct entries v2

During checkpoint we dump whole process memory to a file and
the dump includes process stack memory. But among stack data
itself, the stack carries additional parameters such as command
line arguments, environment data and auxiliary vector.

So when we do restore procedure and once we've restored stack
data itself we need to setup mm_struct::arg_start/end,
env_start/end, so restored process would be able to find
command line arguments and environment data it had at checkpoint
time. The same applies to auxiliary vector.

For this reason additional PR_SET_MM_(ARG_START | ARG_END |
ENV_START | ENV_END | AUXV) codes are introduced.

v2: Add BUILD_BUG_ON guard

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
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
 include/linux/prctl.h |    5 ++
 kernel/sys.c          |  107 +++++++++++++++++++++++++++++++++++---------------
 2 files changed, 82 insertions(+), 30 deletions(-)

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
@@ -1693,17 +1693,23 @@ SYSCALL_DEFINE1(umask, int, mask)
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
+	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int error = 0;
-	struct mm_struct *mm = current->mm;
 
-	if (arg4 | arg5)
+	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1715,7 +1721,9 @@ static int prctl_set_mm(int opt, unsigne
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
-	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
+	if (opt != PR_SET_MM_START_BRK &&
+	    opt != PR_SET_MM_BRK &&
+	    opt != PR_SET_MM_AUXV) {
 		/* It must be existing VMA */
 		if (!vma || vma->vm_start > addr)
 			goto out;
@@ -1725,11 +1733,8 @@ static int prctl_set_mm(int opt, unsigne
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
@@ -1740,11 +1745,8 @@ static int prctl_set_mm(int opt, unsigne
 
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
@@ -1753,19 +1755,6 @@ static int prctl_set_mm(int opt, unsigne
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
@@ -1790,16 +1779,74 @@ static int prctl_set_mm(int opt, unsigne
 		mm->brk = addr;
 		break;
 
+	/*
+	 * If command line arguments and environment
+	 * are placed somewhere else on stack, we can
+	 * set them up here, ARG_START/END to setup
+	 * command line argumets and ENV_START/END
+	 * for environment.
+	 */
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
+		if (opt == PR_SET_MM_START_STACK)
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
+	/*
+	 * This doesn't move auxiliary vector itself
+	 * since it's pinned to mm_struct, but allow
+	 * to fill vector with new values. It's up
+	 * to a caller to provide sane values here
+	 * otherwise user space tools which use this
+	 * vector might be unhappy.
+	 */
+	case PR_SET_MM_AUXV: {
+		unsigned long user_auxv[AT_VECTOR_SIZE];
+
+		if (arg4 > sizeof(user_auxv))
+			goto out;
+		up_read(&mm->mmap_sem);
+
+		if (copy_from_user(user_auxv, (const void __user *)addr, arg4))
+			return -EFAULT;
+
+		/* Make sure the last entry is always AT_NULL */
+		user_auxv[AT_VECTOR_SIZE - 2] = 0;
+		user_auxv[AT_VECTOR_SIZE - 1] = 0;
+
+		BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
+
+		task_lock(current);
+		memcpy(mm->saved_auxv, user_auxv, arg4);
+		task_unlock(current);
+
+		return 0;
+	}
 	default:
 		error = -EINVAL;
 		goto out;
 	}
 
 	error = 0;
-
 out:
 	up_read(&mm->mmap_sem);
-
 	return error;
 }
 #else /* CONFIG_CHECKPOINT_RESTORE */
