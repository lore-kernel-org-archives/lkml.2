Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab2AXIsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 03:48:31 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:44702 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2AXIsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 03:48:30 -0500
Date: Tue, 24 Jan 2012 12:48:23 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-ID: <20120124084823.GF29735@moon>
References: <20120123142036.025893883@openvz.org>
 <20120123142436.258631438@openvz.org>
 <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124064719.GA29735@moon>
 <4F1E57F3.6020607@zytor.com>
 <20120124071716.GC29735@moon>
 <20120124162031.a3956058.kamezawa.hiroyu@jp.fujitsu.com>
 <20120124073842.GE29735@moon>
 <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124164008.aa1714bd.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 04:40:08PM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 24 Jan 2012 11:38:42 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > On Tue, Jan 24, 2012 at 04:20:31PM +0900, KAMEZAWA Hiroyuki wrote:
> > ...
> > > > > 
> > > > > That's not a reason to put it in arch/ ... that's possibly a reason to
> > > > > not map the system call on other architectures yet.
> > > > > 
> > > > 
> > > > Where it should live then? In kernel/ or mm/ ?
> > > > 
> > > 
> > > kernel/checkpoint_restart ?
> > > 
> > > gathering related changes to a directory may help developpers joins later....
> > > To me, this makes seeing git log easy ;)
> > >  
> > 
> > Such separate directory implies everything related to c/r should live there,
> > it also implies (I think) that code which is under CHECKPOINT_RESTORE should
> > be moved there as well, so I'm not sure, Kame ;) I guess mm/ will be a good
> > place since these are operations with memory pointers.
> > 
> 
> please do as you like. 

So it should be something like below I think...

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [RFC] syscalls, x86: Add __NR_kcmp syscall v5

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
 arch/x86/include/asm/syscalls.h  |    4 
 arch/x86/syscalls/syscall_32.tbl |    1 
 arch/x86/syscalls/syscall_64.tbl |    1 
 include/linux/kcmp.h             |   17 ++++
 mm/Makefile                      |    1 
 mm/kcmp.c                        |  163 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 187 insertions(+)

Index: linux-2.6.git/arch/x86/include/asm/syscalls.h
===================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/syscalls.h
+++ linux-2.6.git/arch/x86/include/asm/syscalls.h
@@ -42,6 +42,10 @@ long sys_sigaltstack(const stack_t __use
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
 asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
+/* mm/kcmp.c */
+asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
+			 unsigned long idx1, unsigned long idx2);
+
 /* X86_32 only */
 #ifdef CONFIG_X86_32
 
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
Index: linux-2.6.git/include/linux/kcmp.h
===================================================================
--- /dev/null
+++ linux-2.6.git/include/linux/kcmp.h
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
Index: linux-2.6.git/mm/Makefile
===================================================================
--- linux-2.6.git.orig/mm/Makefile
+++ linux-2.6.git/mm/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoiso
 obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
 obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
 obj-$(CONFIG_CLEANCACHE) += cleancache.o
+obj-$(CONFIG_X86) += kcmp.o
Index: linux-2.6.git/mm/kcmp.c
===================================================================
--- /dev/null
+++ linux-2.6.git/mm/kcmp.c
@@ -0,0 +1,163 @@
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
+#include <linux/kcmp.h>
+
+#include <asm/unistd.h>
+
+static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
+
+static long kptr_obfuscate(long v, int type)
+{
+	return (v ^ cookies[type][0]) * cookies[type][1];
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
+	return (ret < 0) | ((ret > 0) << 1);
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
+	 * don't take any locks in a sake of speed.
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
+			get_random_bytes(&cookies[i][j],
+					 sizeof(cookies[i][j]));
+		}
+		cookies[i][1] |= (~(~0UL >>  1) | 1);
+	}
+
+	return 0;
+}
+late_initcall(kcmp_cookie_init);
