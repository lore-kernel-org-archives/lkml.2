Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab1K3Rhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 12:37:47 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38096 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1K3Rhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 12:37:45 -0500
Date: Wed, 30 Nov 2011 21:37:39 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111130173739.GI14515@moon>
References: <20111129191252.769160532@openvz.org>
 <20111129191638.912537377@openvz.org>
 <20111129201938.GP5169@outflux.net>
 <20111129202951.GG1775@moon>
 <20111129203714.GH1775@moon>
 <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 12:40:57PM -0800, Kees Cook wrote:
> >
> > On the other hands these fields are set up by elf hanlder code, which
> > does mmap these areas, so we have to check that particular member
> > belongs to existing VMA and never cross user-space area, and together
> > with root-only approach would not it be enough? I'm sure missing something
> > that is why I'm asking.
> 
> Right, if you verify that the addresses are actually inside valid
> userspace vmas, that is likely to be right, though there are probably
> other things I haven't thought of. The trouble is avoiding vdso, stack
> guard page, vsyscall, and anything else that isn't meant for the mm to
> have direct access to.
> 

Hi Kees,

what about this one? Note that these mm_struct members don't affect
kernel much (at least as far as I see, except maybe brk,start_brk and
start_stack values), so I've added some sanity checks here, hope they
would fit. Still main protection is root-only access only. The kernel
itself uses vma_area::start/end members for overlows tests internally
so I think even passing crazy data here won't crash the kernel itself.
What do you think?

	Cyrill
---
prctl: Add PR_SET_MM codes to tune up mm_struct entires v2

A few members of mm_struct such as start_code, end_code,
start_data, end_data, start_stack, start_brk, brk provided
by the kernel via /proc/$pid/stat and we use it at checkpoint
time.

At restore time we need a mechanism to restore those values
back and for this sake PR_SET_MM prctl code is introduced.

Note because of being a dangerous operation this inteface
is allowed for CAP_SYS_ADMIN only.

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
