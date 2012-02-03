Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab2BCRm2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 12:42:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56479 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756828Ab2BCRmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 12:42:25 -0500
Date: Fri, 3 Feb 2012 21:42:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-ID: <20120203174218.GN11834@moon>
References: <20120130140905.441199885@openvz.org>
 <20120130141852.309402052@openvz.org>
 <20120203074656.GC30543@elte.hu>
 <20120203083530.GD1968@moon>
 <20120203090929.GA23996@elte.hu>
 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
 <20120203092823.GE1968@moon>
 <4F2C1A46.4010105@zytor.com>
 <4F2C1AC9.7090509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2C1AC9.7090509@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:35:05AM -0800, H. Peter Anvin wrote:
...
> >How about:
> >
> >const int size = sizeof(cookies[0]);
> >
> >get_random_bytes(&cookies[i], size);
> >
> >... and skip the completely unnecessary for loop?
> >
> 
> Even better:
> 
> static __init int kcmp_cookie_init(void)
> {
> 	int i;
> 
> 	get_random_bytes(cookies, sizeof cookies);
> 
> 	for (i = 0; i < KCMP_TYPES; i++)
> 		cookies[i][1] |= ~(~0UL >> 1) | 1;
> }
> 

Oh, cool! It's a way simplier (I somehow forgot that
get_random_bytes operates with stream of bytes).

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: syscalls, x86: Add __NR_kcmp syscall v8

While doing the checkpoint-restore in the user space one need to determine
whether various kernel objects (like mm_struct-s of file_struct-s) are shared
between tasks and restore this state.

The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
syscall, while there's currently no ways for solving the 1st one.

One of the ways for checking whether two tasks share e.g. mm_struct is to
provide some mm_struct ID of a task to its proc file, but showing such
info considered to be not that good for security reasons.

Thus after some debates we end up in conclusion that using that named
'comparison' syscall might be the best candidate. So here is it --
__NR_kcmp.

It takes up to 5 arguments - the pids of the two tasks (which
characteristics should be compared), the comparison type and
(in case of comparison of files) two file descriptors.

Lookups for pids are done in the caller's PID namespace only.

At moment only x86 is supported and tested.

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
CC: Michal Marek <mmarek@suse.cz>
---
 arch/x86/syscalls/syscall_32.tbl         |    1 
 arch/x86/syscalls/syscall_64.tbl         |    1 
 include/linux/kcmp.h                     |   17 +++
 include/linux/syscalls.h                 |    2 
 kernel/Makefile                          |    3 
 kernel/kcmp.c                            |  155 +++++++++++++++++++++++++++++++
 kernel/sys_ni.c                          |    3 
 tools/testing/selftests/kcmp/Makefile    |   36 +++++++
 tools/testing/selftests/kcmp/kcmp_test.c |   84 ++++++++++++++++
 tools/testing/selftests/run_tests        |    2 
 10 files changed, 303 insertions(+), 1 deletion(-)

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
Index: linux-2.6.git/include/linux/syscalls.h
===================================================================
--- linux-2.6.git.orig/include/linux/syscalls.h
+++ linux-2.6.git/include/linux/syscalls.h
@@ -857,4 +857,6 @@ asmlinkage long sys_process_vm_writev(pi
 				      unsigned long riovcnt,
 				      unsigned long flags);
 
+asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
+			 unsigned long idx1, unsigned long idx2);
 #endif
Index: linux-2.6.git/kernel/Makefile
===================================================================
--- linux-2.6.git.orig/kernel/Makefile
+++ linux-2.6.git/kernel/Makefile
@@ -25,6 +25,9 @@ endif
 obj-y += sched/
 obj-y += power/
 
+ifeq ($(CONFIG_CHECKPOINT_RESTORE),y)
+obj-$(CONFIG_X86) += kcmp.o
+endif
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
Index: linux-2.6.git/kernel/kcmp.c
===================================================================
--- /dev/null
+++ linux-2.6.git/kernel/kcmp.c
@@ -0,0 +1,155 @@
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
+	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
+	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
+		ret = -EACCES;
+		goto err;
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
Index: linux-2.6.git/kernel/sys_ni.c
===================================================================
--- linux-2.6.git.orig/kernel/sys_ni.c
+++ linux-2.6.git/kernel/sys_ni.c
@@ -203,3 +203,6 @@ cond_syscall(sys_fanotify_mark);
 cond_syscall(sys_name_to_handle_at);
 cond_syscall(sys_open_by_handle_at);
 cond_syscall(compat_sys_open_by_handle_at);
+
+/* compare kernel pointers */
+cond_syscall(sys_kcmp);
Index: linux-2.6.git/tools/testing/selftests/kcmp/Makefile
===================================================================
--- /dev/null
+++ linux-2.6.git/tools/testing/selftests/kcmp/Makefile
@@ -0,0 +1,36 @@
+ifeq ($(strip $(V)),)
+	E = @echo
+	Q = @
+else
+	E = @\#
+	Q =
+endif
+export E Q
+
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
+
+all:
+ifeq ($(ARCH),X86)
+	$(E) "  CC run_test"
+	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
+else
+	$(E) "Not an x86 target, can't build kcmp selftest"
+endif
+
+clean:
+	$(E) "  CLEAN"
+	$(Q) rm -fr ./run_test
+	$(Q) rm -fr ./test-file
Index: linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
===================================================================
--- /dev/null
+++ linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
@@ -0,0 +1,84 @@
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
+		printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
+		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
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
+		exit(ret);
+	}
+
+	waitpid(pid2, &status, P_ALL);
+
+	return 0;
+}
Index: linux-2.6.git/tools/testing/selftests/run_tests
===================================================================
--- linux-2.6.git.orig/tools/testing/selftests/run_tests
+++ linux-2.6.git/tools/testing/selftests/run_tests
@@ -1,6 +1,6 @@
 #!/bin/bash
 
-TARGETS=breakpoints
+TARGETS="breakpoints kcmp"
 
 for TARGET in $TARGETS
 do
