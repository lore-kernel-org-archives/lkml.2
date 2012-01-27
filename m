Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab2A0USo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 15:18:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:36244 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab2A0USm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 15:18:42 -0500
Message-ID: <4F2306BB.5090907@jp.fujitsu.com>
Date: Fri, 27 Jan 2012 15:19:07 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: gorcunov@openvz.org
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, xemul@openvz.org, xemul@parallels.com,
        avagin@openvz.org, kosaki.motohiro@gmail.com, mingo@elte.hu,
        hpa@zytor.com, tglx@linutronix.de, glommer@parallels.com,
        andi@firstfloor.org, tj@kernel.org, matthltc@us.ibm.com,
        penberg@kernel.org, eric.dumazet@gmail.com, segoon@openwall.com,
        adobriyan@gmail.com, Valdis.Kletnieks@vt.edu
Subject: Re: [RFC c/r 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
References: <20120127175342.273260614@openvz.org> <20120127175939.795551339@openvz.org>
In-Reply-To: <20120127175939.795551339@openvz.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/27/2012 12:53 PM, Cyrill Gorcunov wrote:
> While doing the checkpoint-restore in the userspace one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
> 
> The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
> syscall, while there's currently no ways for solving the 1st one.
> 
> One of the ways for checking whether two tasks share e.g. mm_struct is to
> provide some mm_struct ID of a task to its proc file, but showing such
> info considered to be not that good for security reasons.
> 
> Thus after some debates we end up in conclusion that using that named
> 'comparision' syscall might be the best candidate. So here is it --
> __NR_kcmp.
> 
> It takes up to 5 agruments - the pids of the two tasks (which
> characteristics should be compared), the comparision type and
> (in case of comparision of files) two file descriptors.
> 
> Lookups for pids are done in the caller's PID namespace only.
> 
> At moment only x86 is supported and tested.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: H. Peter Anvin <hpa@zytor.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Glauber Costa <glommer@parallels.com>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: Tejun Heo <tj@kernel.org>
> CC: Matt Helsley <matthltc@us.ibm.com>
> CC: Pekka Enberg <penberg@kernel.org>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> CC: Vasiliy Kulikov <segoon@openwall.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Alexey Dobriyan <adobriyan@gmail.com>
> CC: Valdis.Kletnieks@vt.edu
> ---
>  arch/x86/syscalls/syscall_32.tbl         |    1 
>  arch/x86/syscalls/syscall_64.tbl         |    1 
>  include/linux/kcmp.h                     |   17 ++
>  include/linux/syscalls.h                 |    2 
>  kernel/Makefile                          |    1 
>  kernel/kcmp.c                            |  181 +++++++++++++++++++++++++++++++
>  tools/testing/selftests/kcmp/Makefile    |   35 +++++
>  tools/testing/selftests/kcmp/kcmp_test.c |  126 +++++++++++++++++++++
>  tools/testing/selftests/run_tests        |    2 
>  9 files changed, 365 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6.git/arch/x86/syscalls/syscall_32.tbl
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/syscalls/syscall_32.tbl
> +++ linux-2.6.git/arch/x86/syscalls/syscall_32.tbl
> @@ -355,3 +355,4 @@
>  346	i386	setns			sys_setns
>  347	i386	process_vm_readv	sys_process_vm_readv		compat_sys_process_vm_readv
>  348	i386	process_vm_writev	sys_process_vm_writev		compat_sys_process_vm_writev
> +349	i386	kcmp			sys_kcmp
> Index: linux-2.6.git/arch/x86/syscalls/syscall_64.tbl
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/syscalls/syscall_64.tbl
> +++ linux-2.6.git/arch/x86/syscalls/syscall_64.tbl
> @@ -318,3 +318,4 @@
>  309	64	getcpu			sys_getcpu
>  310	64	process_vm_readv	sys_process_vm_readv
>  311	64	process_vm_writev	sys_process_vm_writev
> +312	64	kcmp			sys_kcmp
> Index: linux-2.6.git/include/linux/kcmp.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/include/linux/kcmp.h
> @@ -0,0 +1,17 @@
> +#ifndef _LINUX_KCMP_H
> +#define _LINUX_KCMP_H
> +
> +/* Comparision type */
> +enum kcmp_type {
> +	KCMP_FILE,
> +	KCMP_VM,
> +	KCMP_FILES,
> +	KCMP_FS,
> +	KCMP_SIGHAND,
> +	KCMP_IO,
> +	KCMP_SYSVSEM,
> +
> +	KCMP_TYPES,
> +};
> +
> +#endif /* _LINUX_KCMP_H */
> Index: linux-2.6.git/include/linux/syscalls.h
> ===================================================================
> --- linux-2.6.git.orig/include/linux/syscalls.h
> +++ linux-2.6.git/include/linux/syscalls.h
> @@ -857,4 +857,6 @@ asmlinkage long sys_process_vm_writev(pi
>  				      unsigned long riovcnt,
>  				      unsigned long flags);
>  
> +asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
> +			 unsigned long idx1, unsigned long idx2);
>  #endif
> Index: linux-2.6.git/kernel/Makefile
> ===================================================================
> --- linux-2.6.git.orig/kernel/Makefile
> +++ linux-2.6.git/kernel/Makefile
> @@ -25,6 +25,7 @@ endif
>  obj-y += sched/
>  obj-y += power/
>  
> +obj-$(CONFIG_X86) += kcmp.o
>  obj-$(CONFIG_FREEZER) += freezer.o
>  obj-$(CONFIG_PROFILING) += profile.o
>  obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
> Index: linux-2.6.git/kernel/kcmp.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/kernel/kcmp.c
> @@ -0,0 +1,181 @@
> +#include <linux/kernel.h>
> +#include <linux/syscalls.h>
> +#include <linux/fdtable.h>
> +#include <linux/string.h>
> +#include <linux/random.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/cache.h>
> +#include <linux/bug.h>
> +#include <linux/err.h>
> +#include <linux/kcmp.h>
> +
> +#include <asm/unistd.h>
> +
> +/*
> + * We don't expose real in-memory order of objects for security
> + * reasons, still the comparision results should be suitable for
> + * sorting. Thus, we obfuscate kernel pointers values (using random
> + * cookies obtaned at early boot stage) and compare the production
> + * instead.
> + */
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> +
> +static long kptr_obfuscate(long v, int type)
> +{
> +	return (v ^ cookies[type][0]) * cookies[type][1];
> +}
> +
> +/*
> + * 0 - equal
> + * 1 - less than
> + * 2 - greater than
> + * 3 - not equal but ordering unavailable (reserved for future)
> + */
> +static int kcmp_ptr(long v1, long v2, enum kcmp_type type)
> +{
> +	long ret;
> +
> +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
> +
> +	return (ret < 0) | ((ret > 0) << 1);
> +}
> +
> +/* The caller must have pinned the task */
> +static struct file *
> +get_file_raw_ptr(struct task_struct *task, unsigned int idx)
> +{
> +	struct fdtable *fdt;
> +	struct file *file;
> +
> +	spin_lock(&task->files->file_lock);
> +	fdt = files_fdtable(task->files);
> +	if (idx < fdt->max_fds)
> +		file = fdt->fd[idx];
> +	else
> +		file = NULL;
> +	spin_unlock(&task->files->file_lock);
> +
> +	return file;
> +}
> +
> +SYSCALL_DEFINE5(kcmp, pid_t, pid1, pid_t, pid2, int, type,
> +		unsigned long, idx1, unsigned long, idx2)
> +{
> +	struct task_struct *task1, *task2;
> +	int ret;
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * Tasks are looked up in caller's
> +	 * PID namespace only.
> +	 */
> +
> +	task1 = find_task_by_vpid(pid1);
> +	if (!task1) {
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	task2 = find_task_by_vpid(pid2);
> +	if (!task2) {
> +		put_task_struct(task1);
> +		rcu_read_unlock();
> +		return -ESRCH;
> +	}
> +
> +	get_task_struct(task1);
> +	get_task_struct(task2);
> +
> +	rcu_read_unlock();
> +
> +	/*
> +	 * One should have enough rights to inspect tasks details.
> +	 */
> +	if (!ptrace_may_access(task1, PTRACE_MODE_READ) ||
> +	    !ptrace_may_access(task2, PTRACE_MODE_READ)) {
> +		ret = -EACCES;
> +		goto err;
> +	}
> +
> +	/*
> +	 * Note for all cases but the KCMP_FILE we
> +	 * don't take any locks in a sake of speed.
> +	 */
> +
> +	switch (type) {
> +	case KCMP_FILE: {
> +		struct file *filp1, *filp2;
> +
> +		filp1 = get_file_raw_ptr(task1, idx1);
> +		filp2 = get_file_raw_ptr(task2, idx2);
> +
> +		if (filp1 && filp2)
> +			ret = kcmp_ptr((long)filp1, (long)filp2, KCMP_FILE);
> +		else
> +			ret = -ENOENT;

If my remember is correct, Andrew pointed out EINVAL is better than ENOENT.


> +		break;
> +	}
> +	case KCMP_VM:
> +		ret = kcmp_ptr((long)task1->mm,
> +			       (long)task2->mm,
> +			       KCMP_VM);
> +		break;
> +	case KCMP_FILES:
> +		ret = kcmp_ptr((long)task1->files,
> +			       (long)task2->files,
> +			       KCMP_FILES);
> +		break;
> +	case KCMP_FS:
> +		ret = kcmp_ptr((long)task1->fs,
> +			       (long)task2->fs,
> +			       KCMP_FS);
> +		break;
> +	case KCMP_SIGHAND:
> +		ret = kcmp_ptr((long)task1->sighand,
> +			       (long)task2->sighand,
> +			       KCMP_SIGHAND);
> +		break;
> +	case KCMP_IO:
> +		ret = kcmp_ptr((long)task1->io_context,
> +			       (long)task2->io_context,
> +			       KCMP_IO);
> +		break;
> +	case KCMP_SYSVSEM:
> +#ifdef CONFIG_SYSVIPC
> +		ret = kcmp_ptr((long)task1->sysvsem.undo_list,
> +			       (long)task2->sysvsem.undo_list,
> +			       KCMP_SYSVSEM);
> +#else
> +		ret = -EINVAL;

ENOTSUP is better, I think. because of, EINVAL implicitly mean _caller_ is wrong.
but in this case, it is not bad. only the kernel doesn't have enough feature.


> +		goto err;

you don't need err label at all.


> +#endif
> +		break;
> +	default:
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +err:
> +	put_task_struct(task1);
> +	put_task_struct(task2);
> +
> +	return ret;
> +}
> +
> +static __init int kcmp_cookie_init(void)
> +{
> +	int i, j;
> +
> +	for (i = 0; i < KCMP_TYPES; i++) {
> +		for (j = 0; j < 2; j++) {
> +			get_random_bytes(&cookies[i][j],
> +					 sizeof(cookies[i][j]));
> +		}
> +		cookies[i][1] |= (~(~0UL >>  1) | 1);
> +	}
> +
> +	return 0;
> +}
> +late_initcall(kcmp_cookie_init);
> Index: linux-2.6.git/tools/testing/selftests/kcmp/Makefile
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/tools/testing/selftests/kcmp/Makefile
> @@ -0,0 +1,35 @@
> +ifeq ($(strip $(V)),)
> +	E = @echo
> +	Q = @
> +else
> +	E = @\#
> +	Q =
> +endif
> +export E Q
> +
> +uname_M := $(shell uname -m 2>/dev/null || echo not)
> +ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/i386/)
> +ifeq ($(ARCH),i386)
> +        ARCH := X86
> +	CFLAGS := -DCONFIG_X86_32
> +endif
> +ifeq ($(ARCH),x86_64)
> +	ARCH := X86
> +	CFLAGS := -DCONFIG_X86_64
> +endif
> +
> +CFLAGS += -I../../../../arch/x86/include/generated/
> +CFLAGS += -I../../../../include/
> +
> +all:
> +ifeq ($(ARCH),X86)
> +	$(E) "  CC run_test"
> +	$(Q) gcc $(CFLAGS) kcmp_test.c -o run_test
> +else
> +	$(E) "Not an x86 target, can't build breakpoints selftests"
> +endif
> +
> +clean:
> +	$(E) "  CLEAN"
> +	$(Q) rm -fr ./run_test
> +	$(Q) rm -fr ./test-file
> Index: linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/tools/testing/selftests/kcmp/kcmp_test.c
> @@ -0,0 +1,126 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <signal.h>
> +#include <limits.h>
> +#include <unistd.h>
> +#include <errno.h>
> +#include <string.h>
> +#include <fcntl.h>
> +
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <sys/wait.h>
> +
> +#ifdef CONFIG_X86_64
> +#include "asm/unistd_64.h"
> +#else
> +#include "asm/unistd_32.h"
> +#endif
> +
> +#include "linux/kcmp.h"
> +
> +#ifdef CONFIG_X86_64
> +static long syscall5(int nr, unsigned long arg0, unsigned long arg1,
> +		unsigned long arg2, unsigned long arg3,
> +		unsigned long arg4)
> +{
> +	long ret;
> +	asm volatile(
> +		"movl %1, %%eax		\n"
> +		"movq %2, %%rdi		\n"
> +		"movq %3, %%rsi		\n"
> +		"movq %4, %%rdx		\n"
> +		"movq %5, %%r10		\n"
> +		"movq %6, %%r8		\n"
> +		"syscall		\n"
> +		"movq %%rax, %0		\n"
> +		: "=r"(ret)
> +		: "g" ((int)nr), "g" (arg0), "g" (arg1), "g" (arg2),
> +			"g" (arg3), "g" (arg4)
> +		: "rax", "rdi", "rsi", "rdx", "r10", "r8", "memory");
> +	return ret;
> +}
> +#else
> +static long syscall5(int nr, unsigned long arg0, unsigned long arg1,
> +		unsigned long arg2, unsigned long arg3,
> +		unsigned long arg4)
> +{
> +	long ret;
> +	asm volatile(
> +		"movl %1, %%eax		\n"
> +		"movl %2, %%ebx		\n"
> +		"movl %3, %%ecx		\n"
> +		"movl %4, %%edx		\n"
> +		"movl %5, %%esi		\n"
> +		"movl %6, %%edi		\n"
> +		"intl $0x80		\n"
> +		"movq %%eax, %0		\n"
> +		: "=r"(ret)
> +		: "g" ((int)nr), "g" (arg0), "g" (arg1), "g" (arg2),
> +			"g" (arg3), "g" (arg4)
> +		: "eax", "ebx", "ecx", "edx", "esi", "edi", "memory");
> +	return ret;
> +}
> +#endif
> +
> +static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
> +{
> +	return syscall5(__NR_kcmp, (long)pid1, (long)pid2,
> +			(long)type, (long)fd1, (long)fd2);
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	int pid1, pid2;
> +	int fd1, fd2;
> +	int status;
> +
> +	fd1 = open("test-file", O_RDWR | O_CREAT | O_TRUNC, 0644);
> +	pid1 = getpid();
> +
> +	if (fd1 < 0) {
> +		perror("Can't create file");
> +		exit(1);
> +	}
> +
> +	pid2 = fork();
> +	if (pid2 < 0) {
> +		perror("fork failed");
> +		exit(1);
> +	}
> +
> +	if (!pid2) {
> +		int pid2 = getpid();
> +
> +		fd2 = open("test-file", O_RDWR, 0644);
> +		if (fd2 < 0) {
> +			perror("Can't open file");
> +			exit(1);
> +		}
> +
> +                printf("pid1: %6d pid2: %6d FD: %2d FILES: %2d VM: %2d FS: %2d "
> +		       "SIGHAND: %2d IO: %2d SYSVSEM: %2d INV: %2d\n",
> +		       pid1, pid2,
> +		       sys_kcmp(pid1, pid2, KCMP_FILE,		fd1, fd2),
> +		       sys_kcmp(pid1, pid2, KCMP_FILES,		0, 0),
> +		       sys_kcmp(pid1, pid2, KCMP_VM,		0, 0),
> +		       sys_kcmp(pid1, pid2, KCMP_FS,		0, 0),
> +		       sys_kcmp(pid1, pid2, KCMP_SIGHAND,	0, 0),
> +		       sys_kcmp(pid1, pid2, KCMP_IO,		0, 0),
> +		       sys_kcmp(pid1, pid2, KCMP_SYSVSEM,	0, 0),.

The best practice of auto test is

 AssertFooBar(expected_value, actual_value);

and, just only print "correct or not". Only you know the correct value.



> +
> +			/* This one should fail */
> +		       sys_kcmp(pid1, pid2, KCMP_TYPES + 1,	0, 0));
> +
> +		/* This one should return same fd */
> +		printf("pid1: %6d pid2: %6d SAME-FD: %2d\n",
> +		       pid1, pid2,
> +		       sys_kcmp(pid1, pid2, KCMP_FILE,		fd1, fd1));
> +
> +		exit(0);
> +	}
> +
> +	waitpid(pid2, &status, P_ALL);
> +
> +	return 0;
> +}
> Index: linux-2.6.git/tools/testing/selftests/run_tests
> ===================================================================
> --- linux-2.6.git.orig/tools/testing/selftests/run_tests
> +++ linux-2.6.git/tools/testing/selftests/run_tests
> @@ -1,6 +1,6 @@
>  #!/bin/bash
>  
> -TARGETS=breakpoints
> +TARGETS="breakpoints kcmp"
>  
>  for TARGET in $TARGETS
>  do
> 
> 

