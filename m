Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab2AXCSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:18:40 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45517 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701Ab2AXCSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:18:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 24 Jan 2012 11:16:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Matt Helsley <matthltc@us.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v4
Message-Id: <20120124111655.b29264d2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120123142436.258631438@openvz.org>
References: <20120123142036.025893883@openvz.org>
	<20120123142436.258631438@openvz.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012 18:20:38 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

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
> At moment only x86 is supported.
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
>  arch/x86/include/asm/kcmp.h      |   17 ++++
>  arch/x86/include/asm/syscalls.h  |    4 
>  arch/x86/kernel/Makefile         |    1 
>  arch/x86/kernel/kcmp.c           |  163 +++++++++++++++++++++++++++++++++++++++
>  arch/x86/syscalls/syscall_32.tbl |    1 
>  arch/x86/syscalls/syscall_64.tbl |    1 
>  6 files changed, 187 insertions(+)
> 
> Index: linux-2.6.git/arch/x86/include/asm/kcmp.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/arch/x86/include/asm/kcmp.h
> @@ -0,0 +1,17 @@
> +#ifndef _LINUX_KCMP_H
> +#define _LINUX_KCMP_H
> +
> +/* Comparision type */
> +enum {
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

Why under /arch ?





> Index: linux-2.6.git/arch/x86/include/asm/syscalls.h
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/include/asm/syscalls.h
> +++ linux-2.6.git/arch/x86/include/asm/syscalls.h
> @@ -42,6 +42,10 @@ long sys_sigaltstack(const stack_t __use
>  asmlinkage int sys_set_thread_area(struct user_desc __user *);
>  asmlinkage int sys_get_thread_area(struct user_desc __user *);
>  
> +/* kenrel/kcmp.c */
> +asmlinkage long sys_kcmp(pid_t pid1, pid_t pid2, int type,
> +			 unsigned long idx1, unsigned long idx2);
> +
>  /* X86_32 only */
>  #ifdef CONFIG_X86_32
>  
> Index: linux-2.6.git/arch/x86/kernel/Makefile
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/Makefile
> +++ linux-2.6.git/arch/x86/kernel/Makefile
> @@ -34,6 +34,7 @@ obj-y			+= alternative.o i8253.o pci-nom
>  obj-y			+= tsc.o io_delay.o rtc.o
>  obj-y			+= pci-iommu_table.o
>  obj-y			+= resource.o
> +obj-y			+= kcmp.o
>  
>  obj-y				+= trampoline.o trampoline_$(BITS).o
>  obj-y				+= process.o
> Index: linux-2.6.git/arch/x86/kernel/kcmp.c
> ===================================================================
> --- /dev/null
> +++ linux-2.6.git/arch/x86/kernel/kcmp.c
> @@ -0,0 +1,163 @@
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
> +
> +#include <asm/unistd.h>
> +#include <asm/kcmp.h>
> +
> +static unsigned long cookies[KCMP_TYPES][2] __read_mostly;
> +
> +static long kptr_obfuscate(long v, int type)
> +{
> +	return (v + cookies[type][0]) ^ cookies[type][1];
> +}
> +

I'm sorry could you add comments to swho what this does ?



> +/*
> + * 0 - equal
> + * 1 - less than
> + * 2 - greater than
> + * 3 - not equal but ordering unavailable
> + */
> +static int kcmp_ptr(long v1, long v2, int type)
> +{
> +	long ret;
> +
> +	ret = kptr_obfuscate(v1, type) - kptr_obfuscate(v2, type);
> +
> +	return (ret < 0) | ((ret > 0) << 1);
> +}
> +
> +#define KCMP_TASK_PTR(task1, task2, member, type)	\
> +	kcmp_ptr((long)(task1)->member,			\
> +		 (long)(task2)->member,			\
> +		 type)
> +
> +#define KCMP_PTR(ptr1, ptr2, type)			\
> +	kcmp_ptr((long)ptr1, (long)ptr2, type)
> +
> +/* A caller must be sure the task is presented in memory */
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
> +	struct task_struct *task1;
> +	struct task_struct *task2;
> +	int ret = 0;
> +
> +	rcu_read_lock();
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
> +			ret = KCMP_PTR(filp1, filp2, KCMP_FILE);
> +		else
> +			ret = -ENOENT;
> +		break;
> +	}
> +	case KCMP_VM:
> +		ret = KCMP_TASK_PTR(task1, task2, mm, KCMP_VM);
> +		break;
> +	case KCMP_FILES:
> +		ret = KCMP_TASK_PTR(task1, task2, files, KCMP_FILES);
> +		break;
> +	case KCMP_FS:
> +		ret = KCMP_TASK_PTR(task1, task2, fs, KCMP_FS);
> +		break;
> +	case KCMP_SIGHAND:
> +		ret = KCMP_TASK_PTR(task1, task2, sighand, KCMP_SIGHAND);
> +		break;
> +	case KCMP_IO:
> +		ret = KCMP_TASK_PTR(task1, task2, io_context, KCMP_IO);
> +		break;
> +	case KCMP_SYSVSEM:
> +#ifdef CONFIG_SYSVIPC
> +		ret = KCMP_TASK_PTR(task1, task2, sysvsem.undo_list, KCMP_SYSVSEM);
> +#else
> +		ret = -ENOENT;
> +		goto err;
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

It seems this function itself doesn't depend on arch.

Thanks,
-Kame

