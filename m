Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2ATIkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 03:40:19 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58939 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2ATIkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 03:40:14 -0500
Date: Fri, 20 Jan 2012 12:40:08 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: david@lang.hm, Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC] syscalls, x86: Add __NR_kcmp syscall
Message-ID: <20120120084008.GD1954@moon>
References: <20120117142759.GE16213@moon>
 <CACVxJT8TJXopJ5-_0j=6CsWXJL8wMOFCerfvmhWa7wcYnejFEg@mail.gmail.com>
 <20120117144452.GG16213@moon>
 <4F15C249.3000602@zytor.com>
 <m1obu29fnf.fsf@fess.ebiederm.org>
 <alpine.DEB.2.02.1201181404480.6780@asgard.lang.hm>
 <20120118224956.GF15652@moon>
 <m1zkdk4mj5.fsf@fess.ebiederm.org>
 <20120119065541.GA31379@moon>
 <m1ty3rukr1.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ty3rukr1.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 07:16:02PM -0800, Eric W. Biederman wrote:
> Cyrill Gorcunov <gorcunov@gmail.com> writes:
> 
> > On Wed, Jan 18, 2012 at 03:29:50PM -0800, Eric W. Biederman wrote:
> >> >
> >> > It doesn't matter. Even if we take a list of objects the kernel either
> >> > should return us some ordering info or find duplicates, in any case it
> >> > makes things more complex i think. So we wanted to bring some minimum
> >> > into kernel leaving the rest of work to user-space.
> >> 
> >> Agreed a syscall does the duplication is probably not the way to go.
> >> 
> >>  A syscall that takes a huge list of objects would solve any security
> >> concerns that we have with returning the object order to user space if
> >> done carefully, but it would require a bunch of additional user space
> >> and kernel memory.
> >> 
> >
> > yes, an it increase syscall time itself since we will have to provide
> > this memory dynamically
> 
> I just did a back of the napkin calculation.
> struct kobj_id {
> 	pid_t pid;
>         size_t descriptor;
> 	size_t first_idx;
>         void *kernel_ignore_this_pointer;
> };
> 
> int find_kobject_dups(int type, struct kobj_id __user *ids, size_t count);
> 
> Looks pretty reasonable on a 64bit machine for 100,000 file
> descriptors.
> 
> 3 Meg of input data.
> 4 Meg of an internal rbtree that remembers the first entry where
> we saw an item.
> struct {
>        struct rb_node node;
>        void *key;
>        size_t idx;
> };
> 
> And the code is very straight forward.  Insert each pointer to a kernel
> object we find into an rbtree, and return the index we find.  Then
> finally tear down the rbtree.
> 
> 8Meg worst case does not seem like a lot of memory to me.  Especially
> since half of it is userspace memory.
> 
> A simple implementation plus a guarantee that we will never ever
> leak information that we don't intend to seem very attractive to me.
> 
> >> Sometimes taking a data structure transforming it into a weird form for
> >> a specific task and then transforming the data structure back to it's
> >> original form is a useful way to go.  So I think a general kernel object
> >> deduplicating system call is an interesting plan B, but a straight
> >> comparison function if we can make it work is a lot more flexible and
> >> useful.
> >> 
> >
> > I hope the root-only restriction would resolve the potential security
> > problem, since as I mentioned if I've hijacked the machine and already
> > goot root -- mem order is not that interesting info I could obtain from
> > such computer :)
> 
> We either need a full comparison operator or we don't.  Root-only is a
> solution just looking to get abused.
> 
> Eric
> 

Hi Eric, this approach sounds like a plan for me too. But what if
we make some cummulative approach and shuffle pointers randomly
(ie I think this is based on what Kosaki proposed in slightly
 different manner).

The patch is below. Eric, Peter, Kosaki, Pavel, could you please
check if this finally suits us from any point of view -- and
security and usability. Did I miss something?

Thanks!

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

At moment only x86 is supported.

v3:
 - Obfuscate kernel pointer addresses so still sorting
   is possible but order is not the same as in memory.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
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
 arch/x86/include/asm/kcmp.h      |   17 +++
 arch/x86/include/asm/syscalls.h  |    4 
 arch/x86/kernel/Makefile         |    1 
 arch/x86/kernel/kcmp.c           |  182 +++++++++++++++++++++++++++++++++++++++
 arch/x86/syscalls/syscall_32.tbl |    1 
 arch/x86/syscalls/syscall_64.tbl |    1 
 6 files changed, 206 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/kcmp.h
===================================================================
--- /dev/null
+++ linux-2.6.git/arch/x86/include/asm/kcmp.h
@@ -0,0 +1,17 @@
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
 
Index: linux-2.6.git/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/Makefile
+++ linux-2.6.git/arch/x86/kernel/Makefile
@@ -34,6 +34,7 @@ obj-y			+= alternative.o i8253.o pci-nom
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
@@ -0,0 +1,182 @@
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+#include <linux/fdtable.h>
+#include <linux/string.h>
+#include <linux/random.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/cache.h>
+#include <linux/bug.h>
+#include <linux/err.h>
+
+#include <asm/unistd.h>
+#include <asm/kcmp.h>
+
+static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
+static bool cookies_valid __read_mostly;
+
+static long kptr_obfuscate(long v, int type)
+{
+	return (v + cookies[type][0]) ^ cookies[type][1];
+}
+
+/*
+ * 0 - equal
+ * 1 - less than
+ * 2 - greater than
+ * 3 - not equal but ordering unavailable
+ */
+static int kcmp_ptr(long v1, long v2, int type)
+{
+	long ret;
+
+	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
+
+	if (likely(cookies_valid))
+		return (ret < 0) | ((ret > 0) << 1);
+
+	/*
+	 * Cookies failed to init,
+	 * still it's safe to point if
+	 * objects are equal.
+	 */
+	return ret ? 3 : 0;
+}
+
+#define KCMP_TASK_PTR(task1, task2, member, type)	\
+	kcmp_ptr((long)(task1)->member,			\
+		 (long)(task2)->member,			\
+		 type)
+
+#define KCMP_PTR(ptr1, ptr2, type)			\
+	kcmp_ptr((long)ptr1, (long)ptr2, type)
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
+			ret = KCMP_PTR(filp1, filp2, KCMP_FILE);
+		else
+			ret = -ENOENT;
+		break;
+	}
+	case KCMP_VM:
+		ret = KCMP_TASK_PTR(task1, task2, mm, KCMP_VM);
+		break;
+	case KCMP_FILES:
+		ret = KCMP_TASK_PTR(task1, task2, files, KCMP_FILES);
+		break;
+	case KCMP_FS:
+		ret = KCMP_TASK_PTR(task1, task2, fs, KCMP_FS);
+		break;
+	case KCMP_SIGHAND:
+		ret = KCMP_TASK_PTR(task1, task2, sighand, KCMP_SIGHAND);
+		break;
+	case KCMP_IO:
+		ret = KCMP_TASK_PTR(task1, task2, io_context, KCMP_IO);
+		break;
+	case KCMP_SYSVSEM:
+#ifdef CONFIG_SYSVIPC
+		ret = KCMP_TASK_PTR(task1, task2, sysvsem.undo_list, KCMP_SYSVSEM);
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
+
+static __init int kcmp_cookie_init(void)
+{
+	int i, j;
+
+	for (i = 0; i < KCMP_TYPES; i++) {
+		for (j = 0; j < 2; j++) {
+			get_random_bytes(&cookies[i][j], sizeof(cookies[i][j]));
+
+			if (cookies[i][j])
+				continue;
+
+			/*
+			 * This is impossible case but just to be sure.
+			 */
+			cookies_valid = false;
+			WARN_ONCE(1, "Can't get random bytes for k-pointers\n");
+		}
+	}
+
+	cookies_valid = true;
+
+	return 0;
+}
+late_initcall(kcmp_cookie_init);
Index: linux-2.6.git/arch/x86/syscalls/syscall_32.tbl
===================================================================
--- linux-2.6.git.orig/arch/x86/syscalls/syscall_32.tbl
+++ linux-2.6.git/arch/x86/syscalls/syscall_32.tbl
@@ -355,3 +355,4 @@
 346	i386	setns			sys_setns
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+349	i386	kcmp			sys_kcmp
Index: linux-2.6.git/arch/x86/syscalls/syscall_64.tbl
===================================================================
--- linux-2.6.git.orig/arch/x86/syscalls/syscall_64.tbl
+++ linux-2.6.git/arch/x86/syscalls/syscall_64.tbl
@@ -318,3 +318,4 @@
 309	64	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+312	64	kcmp			sys_kcmp
