Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2ARL5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:57:10 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54096 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535Ab2ARL5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:57:07 -0500
Date: Wed, 18 Jan 2012 15:57:00 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrey Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120118115700.GO1968@moon>
References: <20120117142759.GE16213@moon>
 <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
 <20120117144452.GG16213@moon>
 <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
 <20120118080103.GA2889@moon>
 <4F168CF3.5090400@gmail.com>
 <4F168E93.5010000@parallels.com>
 <4F168F8C.8090504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F168F8C.8090504@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 04:23:24AM -0500, KOSAKI Motohiro wrote:
> (1/18/12 4:19 AM), Pavel Emelyanov wrote:
> >>I think Eric only said gt/lt compare is useful. We don't need to expose bare
> >>pointer order. example, kcmp(rotate(ptr, per-task-random-value)) is enough
> >>hide the critical information. I think.
> >
> >The per-task might break thinks up in case
> >
> >(tsk1->file != tsk2->file)&&  (rotate(tsk1->file, tsk1->random) == rotate(tsk2->file, tsk2->rotate))
> 
> I meant,
> 
> (tsk1->file != tsk2->file) && (rotate(tsk1->file, caller_task->random) == rotate(tsk2->file, caller_task->random))
> 
> 
> >
> >but I agree, that the overall idea of comparing not bare pointers, but those poisoned with
> >some global value can address the Peter's concerns about rootkits.
> 
> 

Guys, can we stick with something simplier? I could use hashes here (again?!) or
even aes encoded pointers extended to 128 bits as it was proposed too. But
maybe we can live with something more simplier?

We could export EQ/NE for regular users (which might be usefull for less
frequently used objects such as namespaces I guess). And GT/LT for root
only.

Does it look better? Does the change log tells enough?

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC] syscalls, x86: Add __NR_kcmp syscall v3

While doing the checkpoint-restore in the userspace one need to determine
whether various kernel objects (like mm_struct-s of file_struct-s) are shared
between tasks and restore this state.

The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
syscall, while there's currently no ways for solving the 1st one.

One of the ways for checking whether two tasks share e.g. mm_struct is to
provide some mm_struct ID of a task to its proc file, but showing such
info considered to be not that good for security reasons.

Thus after some debates we end up in conclusion that using that named
'comparision' syscall might be the best candidate. So here is it --
__NR_kcmp.

It takes up to 5 agruments - the pids of the two tasks (which
characteristics should be compared), the comparision type and
(in case of comparision of files) two file descriptors.

Only two results are supported at moment -- if the objects
are the same or not. So there is no way to restore in-memory
order of objects.

At moment only x86 is supported.

v2: Drop ordered results.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Glauber Costa <glommer@parallels.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Valdis.Kletnieks@vt.edu
---
 arch/x86/include/asm/kcmp.h        |   20 +++++
 arch/x86/include/asm/syscalls.h    |    4 +
 arch/x86/include/asm/unistd_32.h   |    1 
 arch/x86/include/asm/unistd_64.h   |    2 
 arch/x86/kernel/Makefile           |    1 
 arch/x86/kernel/kcmp.c             |  124 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/syscall_table_32.S |    1 
 7 files changed, 153 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/kcmp.h
===================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/include/asm/kcmp.h
@@ -0,0 +1,20 @@
+#ifndef _LINUX_KCMP_H
+#define _LINUX_KCMP_H
+
+/* Comparision type */
+enum {
+	KCMP_FILE,
+	KCMP_VM,
+	KCMP_FILES,
+	KCMP_FS,
+	KCMP_SIGHAND,
+	KCMP_IO,
+	KCMP_SYSVSEM,
+
+	KCMP_TYPES,
+};
+
+#define KCMP_EQ		0
+#define KCMP_NE		1
+
+#endif /* _LINUX_KCMP_H */
Index: linux-2.6.git/arch/x86/include/asm/syscalls.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/syscalls.h
+++ linux-2.6.git/arch/x86/include/asm/syscalls.h
@@ -42,6 +42,10 @@ long sys_sigaltstack(const stack_t __use
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
 asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
+/* kenrel/kcmp.c */
+asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
+			 unsigned long idx1, unsigned long idx2);
+
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 
Index: linux-2.6.git/arch/x86/include/asm/unistd_32.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/unistd_32.h
+++ linux-2.6.git/arch/x86/include/asm/unistd_32.h
@@ -354,6 +354,7 @@
 #define __NR_setns		346
 #define __NR_process_vm_readv	347
 #define __NR_process_vm_writev	348
+#define __NR_kcmp		349
 
 #ifdef __KERNEL__
 
Index: linux-2.6.git/arch/x86/include/asm/unistd_64.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/unistd_64.h
+++ linux-2.6.git/arch/x86/include/asm/unistd_64.h
@@ -686,6 +686,8 @@ __SYSCALL(__NR_getcpu, sys_getcpu)
 __SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev			311
 __SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
+#define __NR_kcmp				312
+__SYSCALL(__NR_kcmp, sys_kcmp)
 
 #ifndef __NO_STUBS
 #define __ARCH_WANT_OLD_READDIR
Index: linux-2.6.git/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/Makefile
+++ linux-2.6.git/arch/x86/kernel/Makefile
@@ -33,6 +33,7 @@ obj-y			+= alternative.o i8253.o pci-nom
 obj-y			+= tsc.o io_delay.o rtc.o
 obj-y			+= pci-iommu_table.o
 obj-y			+= resource.o
+obj-y			+= kcmp.o
 
 obj-y				+= trampoline.o trampoline_$(BITS).o
 obj-y				+= process.o
Index: linux-2.6.git/arch/x86/kernel/kcmp.c
===================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/kernel/kcmp.c
@@ -0,0 +1,124 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <linux/fdtable.h>
+#include <linux/err.h>
+
+#include <asm/unistd.h>
+#include <asm/kcmp.h>
+
+static int kcmp_ptr(long v1, long v2)
+{
+	long ret = v1 - v2;
+	return ret == 0 ? KCMP_EQ : KCMP_NE;
+}
+
+#define KCMP_TASK_PTR(task1, task2, member)	\
+	kcmp_ptr((long)(task1)->member, (long)(task2)->member)
+
+#define KCMP_PTR(ptr1, ptr2)			\
+	kcmp_ptr((long)ptr1, (long)ptr2)
+
+/* A caller must be sure the task is presented in memory */
+static struct file *
+get_file_raw_ptr(struct task_struct *task, unsigned int idx)
+{
+	struct fdtable *fdt;
+	struct file *file;
+
+	spin_lock(&task->files->file_lock);
+	fdt = files_fdtable(task->files);
+	if (idx < fdt->max_fds)
+		file = fdt->fd[idx];
+	else
+		file = NULL;
+	spin_unlock(&task->files->file_lock);
+
+	return file;
+}
+
+SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
+		unsigned long, idx1, unsigned long, idx2)
+{
+	struct task_struct *task1;
+	struct task_struct *task2;
+	int ret = 0;
+
+	rcu_read_lock();
+
+	task1 = find_task_by_vpid(pid1);
+	if (!task1) {
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+
+	task2 = find_task_by_vpid(pid2);
+	if (!task2) {
+		put_task_struct(task1);
+		rcu_read_unlock();
+		return -ESRCH;
+	}
+
+	get_task_struct(task1);
+	get_task_struct(task2);
+
+	rcu_read_unlock();
+
+	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
+	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
+		ret = -EACCES;
+		goto err;
+	}
+
+	/*
+	 * Note for all cases but the KCMP_FILE we
+	 * don't take any locks and do a plain pointer
+	 * comparision in a sake of speed.
+	 */
+
+	switch (type) {
+	case KCMP_FILE: {
+		struct file *filp1, *filp2;
+
+		filp1 = get_file_raw_ptr(task1, idx1);
+		filp2 = get_file_raw_ptr(task2, idx2);
+
+		if (filp1 && filp2)
+			ret = KCMP_PTR(filp1, filp2);
+		else
+			ret = -ENOENT;
+		break;
+	}
+	case KCMP_VM:
+		ret = KCMP_TASK_PTR(task1, task2, mm);
+		break;
+	case KCMP_FILES:
+		ret = KCMP_TASK_PTR(task1, task2, files);
+		break;
+	case KCMP_FS:
+		ret = KCMP_TASK_PTR(task1, task2, fs);
+		break;
+	case KCMP_SIGHAND:
+		ret = KCMP_TASK_PTR(task1, task2, sighand);
+		break;
+	case KCMP_IO:
+		ret = KCMP_TASK_PTR(task1, task2, io_context);
+		break;
+	case KCMP_SYSVSEM:
+#ifdef CONFIG_SYSVIPC
+		ret = KCMP_TASK_PTR(task1, task2, sysvsem.undo_list);
+#else
+		ret = -ENOENT;
+		goto err;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		goto err;
+	}
+
+err:
+	put_task_struct(task1);
+	put_task_struct(task2);
+
+	return ret;
+}
Index: linux-2.6.git/arch/x86/kernel/syscall_table_32.S
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/syscall_table_32.S
+++ linux-2.6.git/arch/x86/kernel/syscall_table_32.S
@@ -348,3 +348,4 @@ ENTRY(sys_call_table)
 	.long sys_setns
 	.long sys_process_vm_readv
 	.long sys_process_vm_writev
+	.long sys_kcmp
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC] syscalls, x86: Report objects ordering for CAP_SYS_ADMIN in __NR_kcmp syscall

For checkpoint-restore procedure we would like to increase performance
over comparision test if huge number of file descriptros is involved,
i.e. being able to re-create at least parial order of kernel objects
compared.

Thus __NR_kcmp syscall is extended to return values representing
the objects order ("greater" and "less").

Such approach allows us to sort file descriptors and don't compare
every file with every other, increasing performance from O(n^2)
to about O(NlogN).

In a sake of safety this interface is allowed for CAP_SYS_ADMIN
only. A regular user still get EQ/NE results only.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: H. Peter Anvin <hpa@zytor.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Glauber Costa <glommer@parallels.com>
CC: Andi Kleen <andi@firstfloor.org>
CC: Tejun Heo <tj@kernel.org>
CC: Matt Helsley <matthltc@us.ibm.com>
CC: Pekka Enberg <penberg@kernel.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Vasiliy Kulikov <segoon@openwall.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Valdis.Kletnieks@vt.edu
---
 arch/x86/include/asm/kcmp.h |    6 ++++--
 arch/x86/kernel/kcmp.c      |   13 ++++++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/kcmp.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/kcmp.h
+++ linux-2.6.git/arch/x86/include/asm/kcmp.h
@@ -14,7 +14,9 @@ enum {
 	KCMP_TYPES,
 };
 
-#define KCMP_EQ		0
-#define KCMP_NE		1
+#define KCMP_EQ		0	/* objects are equal */
+#define KCMP_NE		1	/* objects are not equal */
+#define KCMP_GT		2	/* 1st is greater than 2nd */
+#define KCMP_LT		3	/* 1st is less than 2nd */
 
 #endif /* _LINUX_KCMP_H */
Index: linux-2.6.git/arch/x86/kernel/kcmp.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/kcmp.c
+++ linux-2.6.git/arch/x86/kernel/kcmp.c
@@ -9,7 +9,18 @@
 static int kcmp_ptr(long v1, long v2)
 {
 	long ret = v1 - v2;
-	return ret == 0 ? KCMP_EQ : KCMP_NE;
+
+	if (ret == 0) {
+		return KCMP_EQ;
+	} else {
+		/* More detailed result for root only */
+		if (capable(CAP_SYS_ADMIN))
+			ret = ret < 0 ? KCMP_LT : KCMP_GT;
+		else
+			ret = KCMP_NE;
+	}
+
+	return ret;
 }
 
 #define KCMP_TASK_PTR(task1, task2, member)	\
