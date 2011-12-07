Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab1LGM1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:27:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57618 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab1LGM1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:27:23 -0500
Date: Wed, 7 Dec 2011 16:27:18 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111207122718.GF21678@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
 <20111129201938.GP5169@outflux.net>
 <20111129202951.GG1775@moon>
 <20111129203714.GH1775@moon>
 <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
 <20111130173739.GI14515@moon>
 <CAGXu5jL=46_MyxrrB8G4FntnLJBtt+DbvVX0kEXh9n8Ss+Yfsw@mail.gmail.com>
 <20111130182310.GL14515@moon>
 <20111130210622.GM14515@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130210622.GM14515@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 01:06:22AM +0400, Cyrill Gorcunov wrote:
...
> 
> You know Kees, I tried it, and finally I think it's overheaded, so I prefer
> to stick with original version (no need to duplicate same data in two differen
> memory places as it'll be in case of arrays, and since the VM_ flags are
> constant the former code bloats kernel lesser. Thanks anyway!
> 

Ping. Kees, Andrew, are there some other objections I'm not yet addressed?
I've updated changelog a bit more. Please review.

(Kame CC'ed)

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH] prctl: Add PR_SET_MM codes to tune up mm_struct entires v2

At process of task restoration we need a way to tune up
a few members of mm_struct structure such as start_code,
end_code, start_data, end_data, start_stack, start_brk, brk.

While most of them have a statistical nature (their values
are involved into calculation of /proc/<pid>/statm output)
the start_brk and brk values are used to compute an allowed
size of program data segment expansion. Which means an arbitrary
changes of this value might be a bit dangerous operation.

To restrict access to this facility the following requirements
applied to prctl users:

 - The process has to have CAP_SYS_ADMIN capability granted.
 - For all opcodes except start_brk/brk members an appropriate
   VMA area must be existing and should fit certain VMA flags,
   such as:
   - code segment must be executable but not writable;
   - data segment must not be executable.

start_brk/brk values must not intersect with data segment
and must not exceed RLIMIT_DATA resource limit.

Still the main guard is CAP_SYS_ADMIN capability check.

v2:
 - Add a check for vma start address, testing for vma ending
   address is not enough. From Kees Cook.

 - Add some sanity tests for assigned addresses.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Kees Cook <keescook@chromium.org>
---
 include/linux/prctl.h |   12 +++++
 kernel/sys.c          |  118 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+)

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
@@ -1692,6 +1692,118 @@ SYSCALL_DEFINE1(umask, int, mask)
 	return mask;
 }
 
+static int prctl_set_mm(int opt, unsigned long addr)
+{
+	unsigned long rlim = rlimit(RLIMIT_DATA);
+	unsigned long vm_req_flags;
+	unsigned long vm_bad_flags;
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+	int error = 0;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (addr >= TASK_SIZE)
+		return -EINVAL;
+
+	mm = get_task_mm(current);
+	if (!mm)
+		return -ENOENT;
+
+	down_read(&mm->mmap_sem);
+	vma = find_vma(mm, addr);
+
+	if (opt != PR_SET_MM_START_BRK &&
+	    opt != PR_SET_MM_BRK) {
+		/* It must be existing VMA */
+		if (!vma || vma->vm_start > addr)
+			goto out;
+	}
+
+	error = -EINVAL;
+	switch (opt) {
+	case PR_SET_MM_START_CODE:
+	case PR_SET_MM_END_CODE:
+
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
+
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
+		if (addr <= mm->end_data)
+			goto out;
+
+		if (rlim < RLIM_INFINITY &&
+		    (mm->brk - addr) + (mm->end_data - mm->start_data) > rlim)
+			goto out;
+
+		current->mm->start_brk = addr;
+		break;
+
+	case PR_SET_MM_BRK:
+		if (addr <= mm->end_data)
+			goto out;
+
+		if (rlim < RLIM_INFINITY &&
+		    (addr - mm->start_brk) + (mm->end_data - mm->start_data) > rlim)
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
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+
+	return error;
+}
+
 SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		unsigned long, arg4, unsigned long, arg5)
 {
@@ -1841,6 +1953,12 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 			else
 				error = PR_MCE_KILL_DEFAULT;
 			break;
+		case PR_SET_MM: {
+			if (arg4 | arg5)
+				return -EINVAL;
+			error = prctl_set_mm(arg2, arg3);
+			break;
+		}
 		default:
 			error = -EINVAL;
 			break;
