Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2BABsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 20:48:02 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:35814 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab2BABsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 20:48:01 -0500
Message-ID: <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
In-Reply-To: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com>
Date: Wed, 1 Feb 2012 02:47:56 +0100
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
From: "Indan Zupancic" <indan@nul.nu>
To: takuo.koguchi.sw@hitachi.com
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux@arm.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, jbaron@redhat.com, yrl.pp-manager.tt@hitachi.com,
        mcgrathr@google.com
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: b1d7cd7c4865bacd8cc28201708f08cd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

CC'ing Roland.

On Thu, December 1, 2011 12:01, takuo.koguchi.sw@hitachi.com wrote:
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 44789ef..84181b3 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -13,6 +13,7 @@ config ARM
>  	select HAVE_KPROBES if !XIP_KERNEL
>  	select HAVE_KRETPROBES if (HAVE_KPROBES)
>  	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
> +	select HAVE_SYSCALL_TRACEPOINTS

Your patch totally ignores OABI, it should at least depend on CONFIG_AEABI
and on !CONFIG_OABI_COMPAT.

>  	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
>  	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
>  	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
> diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
> new file mode 100644
> index 0000000..cabeb67
> --- /dev/null
> +++ b/arch/arm/include/asm/syscall.h
> @@ -0,0 +1,45 @@
> +#ifndef _ASM_ARM_SYSCALL_H
> +#define _ASM_ARM_SYSCALL_H
> +
> +extern const unsigned long sys_call_table[];
> +
> +#include <linux/sched.h>
> +
> +static inline long syscall_get_nr(struct task_struct *task,
> +				  struct pt_regs *regs)
> +{
> +	return regs->ARM_r7;
> +}
> +
> +static inline long syscall_get_return_value(struct task_struct *task,
> +					    struct pt_regs *regs)
> +{
> +	return regs->ARM_r0;
> +}
> +
> +static inline void syscall_get_arguments(struct task_struct *task,
> +					 struct pt_regs *regs,
> +					 unsigned int i, unsigned int n,
> +					 unsigned long *args)
> +{
> +	BUG_ON(i);

This is unacceptable, that would make this function useless.

See Rolands patch:

https://lkml.org/lkml/2009/4/24/399 for a better implementation.

> +	switch (n) {
> +	case 6:
> +		args[5] = regs->ARM_r5; /* fall through */
> +	case 5:
> +		args[4] = regs->ARM_r4;
> +	case 4:
> +		args[3] = regs->ARM_r3;
> +	case 3:
> +		args[2] = regs->ARM_r2;
> +	case 2:
> +		args[1] = regs->ARM_r1;
> +	case 1:
> +		args[0] = regs->ARM_r0;
> +	case 0:
> +		break;
> +	default:
> +		BUG();
> +	}
> +}
> +#endif	/* _ASM_ARM_SYSCALL_H */
> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
> index 7b5cc8d..2509028 100644
> --- a/arch/arm/include/asm/thread_info.h
> +++ b/arch/arm/include/asm/thread_info.h
> @@ -139,6 +139,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
>  #define TIF_NEED_RESCHED	1
>  #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>  #define TIF_SYSCALL_TRACE	8
> +#define TIF_SYSCALL_TRACEPOINT	15
>  #define TIF_POLLING_NRFLAG	16
>  #define TIF_USING_IWMMXT	17
>  #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
> @@ -150,11 +151,13 @@ extern void vfp_flush_hwstate(struct thread_info *);
>  #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
>  #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
>  #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
> +#define _TIF_SYSCALL_TRACEPOINT	(1 << TIF_SYSCALL_TRACEPOINT)
>  #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
>  #define _TIF_USING_IWMMXT	(1 << TIF_USING_IWMMXT)
>  #define _TIF_FREEZE		(1 << TIF_FREEZE)
>  #define _TIF_RESTORE_SIGMASK	(1 << TIF_RESTORE_SIGMASK)
>  #define _TIF_SECCOMP		(1 << TIF_SECCOMP)
> +#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT)

What does 'A' stand for?

>
>  /*
>   * Change these and you break ASM code in entry-common.S
> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
> index 4a11237..f4eac2d 100644
> --- a/arch/arm/include/asm/unistd.h
> +++ b/arch/arm/include/asm/unistd.h
> @@ -405,6 +405,9 @@
>  #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
>  #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
>
> +#ifndef __ASSEMBLY__
> +#define NR_syscalls		378
> +#endif
>  /*
>   * The following SWIs are ARM private.
>   */
> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
> index b2a27b6..a1577c2 100644
> --- a/arch/arm/kernel/entry-common.S
> +++ b/arch/arm/kernel/entry-common.S
> @@ -87,7 +87,7 @@ ENTRY(ret_from_fork)
>  	get_thread_info tsk
>  	ldr	r1, [tsk, #TI_FLAGS]		@ check for syscall tracing
>  	mov	why, #1
> -	tst	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
> +	tst	r1, #_TIF_SYSCALL_T_OR_A	@ are we tracing syscalls?
>  	beq	ret_slow_syscall
>  	mov	r1, sp
>  	mov	r0, #1				@ trace exit [IP = 1]
> @@ -443,7 +443,7 @@ ENTRY(vector_swi)
>  1:
>  #endif
>
> -	tst	r10, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
> +	tst	r10, #_TIF_SYSCALL_T_OR_A	@ are we tracing syscalls?
>  	bne	__sys_trace
>
>  	cmp	scno, #NR_syscalls		@ check upper syscall limit
> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
> index 483727a..a690c9f 100644
> --- a/arch/arm/kernel/ptrace.c
> +++ b/arch/arm/kernel/ptrace.c
> @@ -28,6 +28,9 @@
>  #include <asm/system.h>
>  #include <asm/traps.h>
>
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/syscalls.h>
> +
>  #define REG_PC	15
>  #define REG_PSR	16
>  /*
> @@ -906,6 +909,13 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int
> scno)
>  {
>  	unsigned long ip;

Not used, you get the same info from 'why'.

> +	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT))) {
> +		if (why)
> +			trace_sys_exit(regs, regs->ARM_r0);
> +		else
> +			trace_sys_enter(regs, scno);
> +	}
> +
>  	if (!test_thread_flag(TIF_SYSCALL_TRACE))
>  		return scno;
>  	if (!(current->ptrace & PT_PTRACED))

Greetings,

Indan


