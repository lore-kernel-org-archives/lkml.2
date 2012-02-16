Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2BPTwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:52:12 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36714 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2BPTwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:52:11 -0500
Date: Thu, 16 Feb 2012 11:52:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Vasiliy Kulikov <segoon@openwall.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>, Valdis.Kletnieks@vt.edu,
        Michal Marek <mmarek@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: + syscalls-x86-add-__nr_kcmp-syscall-v8.patch added to -mm tree
Message-Id: <20120216115208.a488e10e.akpm@linux-foundation.org>
In-Reply-To: <20120216192952.GN1905@moon>
References: <20120215200533.GQ1894@moon>
	<20120215202538.GK4533@moon>
	<20120215210934.GL4533@moon>
	<20120215215807.GM4533@moon>
	<20120216144954.GA11953@redhat.com>
	<20120216151340.GI1905@moon>
	<20120216164901.GD3849@moon>
	<20120216174047.GA31176@redhat.com>
	<20120216175809.GJ1905@moon>
	<20120216190321.GA2216@redhat.com>
	<20120216192952.GN1905@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Feb 2012 23:29:52 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Final one ;)

syscalls-x86-add-__nr_kcmp-syscall-v8-fix-fix-fix-fix-fix.patch
is a tie for the world record!

I folded everything back into a single patch.  Here's what we currently
have:


From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: add __NR_kcmp syscall

While doing the checkpoint-restore in the user space one need to determine
whether various kernel objects (like mm_struct-s of file_struct-s) are
shared between tasks and restore this state.

The 2nd step can be solved by using appropriate CLONE_ flags and the
unshare syscall, while there's currently no ways for solving the 1st one.

One of the ways for checking whether two tasks share e.g.  mm_struct is to
provide some mm_struct ID of a task to its proc file, but showing such
info considered to be not that good for security reasons.

Thus after some debates we end up in conclusion that using that named
'comparison' syscall might be the best candidate.  So here is it --
__NR_kcmp.

It takes up to 5 arguments - the pids of the two tasks (which
characteristics should be compared), the comparison type and (in case of
comparison of files) two file descriptors.

Lookups for pids are done in the caller's PID namespace only.

At moment only x86 is supported and tested.

[akpm@linux-foundation.org: fix up selftests, warnings]
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Glauber Costa <glommer@parallels.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Matt Helsley <matthltc@us.ibm.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Valdis.Kletnieks@vt.edu
Cc: Michal Marek <mmarek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/syscalls/syscall_32.tbl         |    1 
 arch/x86/syscalls/syscall_64.tbl         |    1 
 include/linux/kcmp.h                     |   17 +
 include/linux/syscalls.h                 |    2 
 kernel/Makefile                          |    3 
 kernel/kcmp.c                            |  186 +++++++++++++++++++++
 kernel/sys_ni.c                          |    3 
 tools/testing/selftests/Makefile         |    2 
 tools/testing/selftests/kcmp/Makefile    |   29 +++
 tools/testing/selftests/kcmp/kcmp_test.c |   94 ++++++++++
 10 files changed, 337 insertions(+), 1 deletion(-)

diff -puN arch/x86/syscalls/syscall_32.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8 arch/x86/syscalls/syscall_32.tbl
--- a/arch/x86/syscalls/syscall_32.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/arch/x86/syscalls/syscall_32.tbl
@@ -355,3 +355,4 @@
 346	i386	setns			sys_setns
 347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
 348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
+349	i386	kcmp			sys_kcmp
diff -puN arch/x86/syscalls/syscall_64.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8 arch/x86/syscalls/syscall_64.tbl
--- a/arch/x86/syscalls/syscall_64.tbl~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/arch/x86/syscalls/syscall_64.tbl
@@ -318,3 +318,4 @@
 309	64	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
+312	64	kcmp			sys_kcmp
diff -puN /dev/null include/linux/kcmp.h
--- /dev/null
+++ a/include/linux/kcmp.h
@@ -0,0 +1,17 @@
+#ifndef _LINUX_KCMP_H
+#define _LINUX_KCMP_H
+
+/* Comparison type */
+enum kcmp_type {
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
diff -puN include/linux/syscalls.h~syscalls-x86-add-__nr_kcmp-syscall-v8 include/linux/syscalls.h
--- a/include/linux/syscalls.h~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/include/linux/syscalls.h
@@ -857,4 +857,6 @@ asmlinkage long sys_process_vm_writev(pi
 				      unsigned long riovcnt,
 				      unsigned long flags);
 
+asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
+			 unsigned long idx1, unsigned long idx2);
 #endif
diff -puN kernel/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8 kernel/Makefile
--- a/kernel/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/kernel/Makefile
@@ -25,6 +25,9 @@ endif
 obj-y += sched/
 obj-y += power/
 
+ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
+obj-$(CONFIG_X86) += kcmp.o
+endif
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff -puN /dev/null kernel/kcmp.c
--- /dev/null
+++ a/kernel/kcmp.c
@@ -0,0 +1,186 @@
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
+/*
+ * We don't expose real in-memory order of objects for security
+ * reasons, still the comparison results should be suitable for
+ * sorting. Thus, we obfuscate kernel pointers values and compare
+ * the production instead.
+ */
+static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
+
+static long kptr_obfuscate(long v, int type)
+{
+	return (v ^ cookies[type][0]) * cookies[type][1];
+}
+
+/*
+ * 0 - equal, i.e. v1 = v2
+ * 1 - less than, i.e. v1 < v2
+ * 2 - greater than, i.e. v1 > v2
+ * 3 - not equal but ordering unavailable (reserved for future)
+ */
+static int kcmp_ptr(void *v1, void *v2, enum kcmp_type type)
+{
+	long ret;
+
+	ret = kptr_obfuscate((long)v1, type) - kptr_obfuscate((long)v2, type);
+
+	return (ret < 0) | ((ret > 0) << 1);
+}
+
+/* The caller must have pinned the task */
+static struct file *
+get_file_raw_ptr(struct task_struct *task, unsigned int idx)
+{
+	struct file *file = NULL;
+
+	task_lock(task);
+	rcu_read_lock();
+
+	if (task->files)
+		file = fcheck_files(task->files, idx);
+
+	rcu_read_unlock();
+	task_unlock(task);
+
+	return file;
+}
+
+static void kcmp_unlock(struct mutex *m1, struct mutex *m2)
+{
+	if (likely(m2 != m1))
+		mutex_unlock(m2);
+	mutex_unlock(m1);
+}
+
+static int kcmp_lock(struct mutex *m1, struct mutex *m2)
+{
+	int err;
+
+	if (m2 > m1)
+		swap(m1, m2);
+
+	err = mutex_lock_killable(m1);
+	if (!err && likely(m1 != m2)) {
+		err = mutex_lock_killable_nested(m2, SINGLE_DEPTH_NESTING);
+		if (err)
+			mutex_unlock(m1);
+	}
+
+	return err;
+}
+
+SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
+		unsigned long, idx1, unsigned long, idx2)
+{
+	struct task_struct *task1, *task2;
+	int ret;
+
+	rcu_read_lock();
+
+	/*
+	 * Tasks are looked up in caller's PID namespace only.
+	 */
+	task1 = find_task_by_vpid(pid1);
+	task2 = find_task_by_vpid(pid2);
+	if (!task1 || !task2)
+		goto err_no_task;
+
+	get_task_struct(task1);
+	get_task_struct(task2);
+
+	rcu_read_unlock();
+
+	/*
+	 * One should have enough rights to inspect task details.
+	 */
+	ret = kcmp_lock(&task1->signal->cred_guard_mutex,
+			&task2->signal->cred_guard_mutex);
+	if (ret)
+		goto err;
+	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
+	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
+		ret = -EPERM;
+		goto err_unlock;
+	}
+
+	switch (type) {
+	case KCMP_FILE: {
+		struct file *filp1, *filp2;
+
+		filp1 = get_file_raw_ptr(task1, idx1);
+		filp2 = get_file_raw_ptr(task2, idx2);
+
+		if (filp1 && filp2)
+			ret = kcmp_ptr(filp1, filp2, KCMP_FILE);
+		else
+			ret = -EBADF;
+		break;
+	}
+	case KCMP_VM:
+		ret = kcmp_ptr(task1->mm, task2->mm, KCMP_VM);
+		break;
+	case KCMP_FILES:
+		ret = kcmp_ptr(task1->files, task2->files, KCMP_FILES);
+		break;
+	case KCMP_FS:
+		ret = kcmp_ptr(task1->fs, task2->fs, KCMP_FS);
+		break;
+	case KCMP_SIGHAND:
+		ret = kcmp_ptr(task1->sighand, task2->sighand, KCMP_SIGHAND);
+		break;
+	case KCMP_IO:
+		ret = kcmp_ptr(task1->io_context, task2->io_context, KCMP_IO);
+		break;
+	case KCMP_SYSVSEM:
+#ifdef CONFIG_SYSVIPC
+		ret = kcmp_ptr(task1->sysvsem.undo_list,
+			       task2->sysvsem.undo_list,
+			       KCMP_SYSVSEM);
+#else
+		ret = -EOPNOTSUP;
+#endif
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+err_unlock:
+	kcmp_unlock(&task1->signal->cred_guard_mutex,
+		    &task2->signal->cred_guard_mutex);
+err:
+	put_task_struct(task1);
+	put_task_struct(task2);
+
+	return ret;
+
+err_no_task:
+	rcu_read_unlock();
+	return -ESRCH;
+}
+
+static __init int kcmp_cookies_init(void)
+{
+	int i;
+
+	get_random_bytes(cookies, sizeof(cookies));
+
+	for (i = 0; i < KCMP_TYPES; i++)
+		cookies[i][1] |= (~(~0UL >>  1) | 1);
+
+	return 0;
+}
+arch_initcall(kcmp_cookies_init);
diff -puN kernel/sys_ni.c~syscalls-x86-add-__nr_kcmp-syscall-v8 kernel/sys_ni.c
--- a/kernel/sys_ni.c~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/kernel/sys_ni.c
@@ -203,3 +203,6 @@ cond_syscall(sys_fanotify_mark);
 cond_syscall(sys_name_to_handle_at);
 cond_syscall(sys_open_by_handle_at);
 cond_syscall(compat_sys_open_by_handle_at);
+
+/* compare kernel pointers */
+cond_syscall(sys_kcmp);
diff -puN /dev/null tools/testing/selftests/kcmp/Makefile
--- /dev/null
+++ a/tools/testing/selftests/kcmp/Makefile
@@ -0,0 +1,29 @@
+uname_M := $(shell uname -m 2>/dev/null || echo not)
+ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
+ifeq ($(ARCH),i386)
+        ARCH := X86
+	CFLAGS := -DCONFIG_X86_32 -D__i386__
+endif
+ifeq ($(ARCH),x86_64)
+	ARCH := X86
+	CFLAGS := -DCONFIG_X86_64 -D__x86_64__
+endif
+
+CFLAGS += -I../../../../arch/x86/include/generated/
+CFLAGS += -I../../../../include/
+CFLAGS += -I../../../../usr/include/
+CFLAGS += -I../../../../arch/x86/include/
+
+all:
+ifeq ($(ARCH),X86)
+	gcc $(CFLAGS) kcmp_test.c -o run_test
+else
+	echo "Not an x86 target, can't build kcmp selftest"
+endif
+
+run-tests: all
+	./kcmp_test
+
+clean:
+	rm -fr ./run_test
+	rm -fr ./test-file
diff -puN /dev/null tools/testing/selftests/kcmp/kcmp_test.c
--- /dev/null
+++ a/tools/testing/selftests/kcmp/kcmp_test.c
@@ -0,0 +1,94 @@
+#define _GNU_SOURCE
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <limits.h>
+#include <unistd.h>
+#include <errno.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include <linux/unistd.h>
+#include <linux/kcmp.h>
+
+#include <sys/syscall.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+
+static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
+{
+	return syscall(__NR_kcmp, pid1, pid2, type, fd1, fd2);
+}
+
+int main(int argc, char **argv)
+{
+	const char kpath[] = "kcmp-test-file";
+	int pid1, pid2;
+	int fd1, fd2;
+	int status;
+
+	fd1 = open(kpath, O_RDWR | O_CREAT | O_TRUNC, 0644);
+	pid1 = getpid();
+
+	if (fd1 < 0) {
+		perror("Can't create file");
+		exit(1);
+	}
+
+	pid2 = fork();
+	if (pid2 < 0) {
+		perror("fork failed");
+		exit(1);
+	}
+
+	if (!pid2) {
+		int pid2 = getpid();
+		int ret;
+
+		fd2 = open(kpath, O_RDWR, 0644);
+		if (fd2 < 0) {
+			perror("Can't open file");
+			exit(1);
+		}
+
+		/* An example of output and arguments */
+		printf("pid1: %6d pid2: %6d FD: %2ld FILES: %2ld VM: %2ld "
+		       "FS: %2ld SIGHAND: %2ld IO: %2ld SYSVSEM: %2ld "
+		       "INV: %2ld\n",
+		       pid1, pid2,
+		       sys_kcmp(pid1, pid2, KCMP_FILE,		fd1, fd2),
+		       sys_kcmp(pid1, pid2, KCMP_FILES,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_VM,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_FS,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_SIGHAND,	0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_IO,		0, 0),
+		       sys_kcmp(pid1, pid2, KCMP_SYSVSEM,	0, 0),
+
+			/* This one should fail */
+		       sys_kcmp(pid1, pid2, KCMP_TYPES + 1,	0, 0));
+
+		/* This one should return same fd */
+		ret = sys_kcmp(pid1, pid2, KCMP_FILE, fd1, fd1);
+		if (ret) {
+			printf("FAIL: 0 expected but %d returned\n", ret);
+			ret = -1;
+		} else
+			printf("PASS: 0 returned as expected\n");
+
+		/* Compare with self */
+		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
+		if (ret) {
+			printf("FAIL: 0 expected but %li returned\n", ret);
+			ret = -1;
+		} else
+			printf("PASS: 0 returned as expected\n");
+
+		exit(ret);
+	}
+
+	waitpid(pid2, &status, P_ALL);
+
+	return 0;
+}
diff -puN tools/testing/selftests/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8 tools/testing/selftests/Makefile
--- a/tools/testing/selftests/Makefile~syscalls-x86-add-__nr_kcmp-syscall-v8
+++ a/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints vm
+TARGETS = breakpoints vm kcmp
 
 all:
 	for TARGET in $(TARGETS); do \
_

