Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1LLUvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 15:51:20 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48664 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab1LLUvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 15:51:19 -0500
Date: Tue, 13 Dec 2011 00:51:14 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [patch 3/3] [PATCH] prctl: Add PR_SET_MM codes to set up
 mm_struct entires v3
Message-ID: <20111212205114.GR2199@moon>
References: <20111212200642.836001668@openvz.org>
 <20111212201715.244414996@openvz.org>
 <CAGXu5jLSrwLeWoQNAA5uyWEewugnr1cWrxzH=wD9JnvZwgAggw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5jLSrwLeWoQNAA5uyWEewugnr1cWrxzH=wD9JnvZwgAggw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 12:38:58PM -0800, Kees Cook wrote:
> On Mon, Dec 12, 2011 at 12:06 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> > When we restore a task we need to set up text, data and data
> > heap sizes from userspace to the values a task had at
> > checkpoint time. This patch adds auxilary prctl codes for that.
> > ...
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> 
> Looks good; I like having this wrapped in CONFIG_CHECKPOINT_RESTORE.
> 
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +static int prctl_set_mm(int opt, unsigned long addr,
> > +                       unsigned long arg4, unsigned long arg5)
> > ...
> > +#else /* CONFIG_CHECKPOINT_RESTORE */
> > +static int prctl_set_mm(int opt, unsigned long addr)
> 
> These need to have matching argument lists.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

Ups! Thanks Kees! Will update in a minute.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] prctl: Add PR_SET_MM codes to set up mm_struct entires v4

When we restore a task we need to set up text, data and data
heap sizes from userspace to the values a task had at
checkpoint time. This patch adds auxilary prctl codes for that.

While most of them have a statistical nature (their values
are involved into calculation of /proc/<pid>/statm output)
the start_brk and brk values are used to compute an allowed
size of program data segment expansion. Which means an arbitrary
changes of this values might be dangerous operation. So to restrict
access the following requirements applied to prctl calls:

 - The process has to have CAP_SYS_ADMIN capability granted.
 - For all opcodes except start_brk/brk members an appropriate
   VMA area must exist and should fit certain VMA flags,
   such as:
   - code segment must be executable but not writable;
   - data segment must not be executable.

start_brk/brk values must not intersect with data segment
and must not exceed RLIMIT_DATA resource limit.

Still the main guard is CAP_SYS_ADMIN capability check.

Note the kernel should be compiled with CONFIG_CHECKPOINT_RESTORE
support otherwise these prctl calls will return -EINVAL.

v2:
 - Add a check for vma start address, testing for vma ending
   address is not enough. From Kees Cook.
 - Add some sanity tests for assigned addresses.
v3:
 - Make code CONFIG_CHECKPOINT_RESTORE dependant.
 - Drop get_task_mm call since "current" is known
   to be running and we have control over it (from
   Andrew Morton).

v4:
 - Arguments matching for function declaration
   from Kees Cook.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 include/linux/prctl.h |   12 +++++
 kernel/sys.c          |  120 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 132 insertions(+)

Index: linux-2.6.git/include/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/linux/prctl.h
+++ linux-2.6.git/include/linux/prctl.h
@@ -102,4 +102,16 @@
 
 #define PR_MCE_KILL_GET 34
 
+/*
+ * Tune up process memory map specifics.
+ */
+#define PR_SET_MM		35
+# define PR_SET_MM_START_CODE		1
+# define PR_SET_MM_END_CODE		2
+# define PR_SET_MM_START_DATA		3
+# define PR_SET_MM_END_DATA		4
+# define PR_SET_MM_START_STACK		5
+# define PR_SET_MM_START_BRK		6
+# define PR_SET_MM_BRK			7
+
 #endif /* _LINUX_PRCTL_H */
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1692,6 +1692,123 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+#ifdef CONFIG_CHECKPOINT_RESTORE
+static int prctl_set_mm(int opt, unsigned long addr,
+			unsigned long arg4, unsigned long arg5)
+{
+	unsigned long rlim = rlimit(RLIMIT_DATA);
+	unsigned long vm_req_flags;
+	unsigned long vm_bad_flags;
+	struct vm_area_struct *vma;
+	int error = 0;
+
+	if (arg4 | arg5)
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (addr >= TASK_SIZE)
+		return -EINVAL;
+
+	down_read(&current->mm->mmap_sem);
+	vma = find_vma(current->mm, addr);
+
+	if (opt != PR_SET_MM_START_BRK && opt != PR_SET_MM_BRK) {
+		/* It must be existing VMA */
+		if (!vma || vma->vm_start > addr)
+			goto out;
+	}
+
+	error = -EINVAL;
+	switch (opt) {
+	case PR_SET_MM_START_CODE:
+	case PR_SET_MM_END_CODE:
+		vm_req_flags = VM_READ | VM_EXEC;
+		vm_bad_flags = VM_WRITE | VM_MAYSHARE;
+
+		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
+		    (vma->vm_flags & vm_bad_flags))
+			goto out;
+
+		if (opt == PR_SET_MM_START_CODE)
+			current->mm->start_code = addr;
+		else
+			current->mm->end_code = addr;
+		break;
+
+	case PR_SET_MM_START_DATA:
+	case PR_SET_MM_END_DATA:
+		vm_req_flags = VM_READ | VM_WRITE;
+		vm_bad_flags = VM_EXEC | VM_MAYSHARE;
+
+		if ((vma->vm_flags & vm_req_flags) != vm_req_flags ||
+		    (vma->vm_flags & vm_bad_flags))
+			goto out;
+
+		if (opt == PR_SET_MM_START_DATA)
+			current->mm->start_data = addr;
+		else
+			current->mm->end_data = addr;
+		break;
+
+	case PR_SET_MM_START_STACK:
+
+#ifdef CONFIG_STACK_GROWSUP
+		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSUP;
+#else
+		vm_req_flags = VM_READ | VM_WRITE | VM_GROWSDOWN;
+#endif
+		if ((vma->vm_flags & vm_req_flags) != vm_req_flags)
+			goto out;
+
+		current->mm->start_stack = addr;
+		break;
+
+	case PR_SET_MM_START_BRK:
+		if (addr <= current->mm->end_data)
+			goto out;
+
+		if (rlim < RLIM_INFINITY &&
+		    (current->mm->brk - addr) +
+		    (current->mm->end_data - current->mm->start_data) > rlim)
+			goto out;
+
+		current->mm->start_brk = addr;
+		break;
+
+	case PR_SET_MM_BRK:
+		if (addr <= current->mm->end_data)
+			goto out;
+
+		if (rlim < RLIM_INFINITY &&
+		    (addr - current->mm->start_brk) +
+		    (current->mm->end_data - current->mm->start_data) > rlim)
+			goto out;
+
+		current->mm->brk = addr;
+		break;
+
+	default:
+		error = -EINVAL;
+		goto out;
+	}
+
+	error = 0;
+
+out:
+	up_read(&current->mm->mmap_sem);
+
+	return error;
+}
+#else /* CONFIG_CHECKPOINT_RESTORE */
+static int prctl_set_mm(int opt, unsigned long addr,
+			unsigned long arg4, unsigned long arg5)
+{
+	return -EINVAL;
+}
+#endif
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1841,6 +1958,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_MM:
+			error = prctl_set_mm(arg2, arg3, arg4, arg5);
+			break;
 		default:
 			error = -EINVAL;
 			break;
