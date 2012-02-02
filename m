Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2BBJYG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 04:24:06 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:43378 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab2BBJYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 04:24:02 -0500
X-AuditID: b753bd60-98c60ba00000359c-b0-4f2a55a9bfa0
Message-ID: <4F2A55B6.4030006@hitachi.com>
Date: Thu, 02 Feb 2012 18:21:58 +0900
From: Takuo Koguchi <takuo.koguchi.sw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
Cc: linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        linux@arm.linux.org.uk, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, jbaron@redhat.com, yrl.pp-manager.tt@hitachi.com,
        mcgrathr@google.com
Subject: Re: [PATCH] ARM: Wire up HAVE_SYSCALL_TRACEPOINTS
References: <XNM1$5$0$1$$3$9$0$A$8005107U4ed75e6e@hitachi.com> <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
In-Reply-To: <3743fd16323370925cf37c279f85d94a.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I am glad to start getting responses.
(2012/02/01 10:47), Indan Zupancic wrote:
> Hello,
>
> CC'ing Roland.
>
> On Thu, December 1, 2011 12:01, takuo.koguchi.sw@hitachi.com wrote:
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 44789ef..84181b3 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -13,6 +13,7 @@ config ARM
>>   	select HAVE_KPROBES if !XIP_KERNEL
>>   	select HAVE_KRETPROBES if (HAVE_KPROBES)
>>   	select HAVE_FUNCTION_TRACER if (!XIP_KERNEL)
>> +	select HAVE_SYSCALL_TRACEPOINTS
> Your patch totally ignores OABI, it should at least depend on CONFIG_AEABI
> and on !CONFIG_OABI_COMPAT.
Right.  As Russel King suggested, this patch depends on those configs 
until very large NR_syscalls is properly handled by ftrace.

>>   	select HAVE_FTRACE_MCOUNT_RECORD if (!XIP_KERNEL)
>>   	select HAVE_DYNAMIC_FTRACE if (!XIP_KERNEL)
>>   	select HAVE_FUNCTION_GRAPH_TRACER if (!THUMB2_KERNEL)
>> diff --git a/arch/arm/include/asm/syscall.h b/arch/arm/include/asm/syscall.h
>> new file mode 100644
>> index 0000000..cabeb67
>> --- /dev/null
>> +++ b/arch/arm/include/asm/syscall.h
>> @@ -0,0 +1,45 @@
>> +#ifndef _ASM_ARM_SYSCALL_H
>> +#define _ASM_ARM_SYSCALL_H
>> +
>> +extern const unsigned long sys_call_table[];
>> +
>> +#include<linux/sched.h>
>> +
>> +static inline long syscall_get_nr(struct task_struct *task,
>> +				  struct pt_regs *regs)
>> +{
>> +	return regs->ARM_r7;
>> +}
>> +
>> +static inline long syscall_get_return_value(struct task_struct *task,
>> +					    struct pt_regs *regs)
>> +{
>> +	return regs->ARM_r0;
>> +}
>> +
>> +static inline void syscall_get_arguments(struct task_struct *task,
>> +					 struct pt_regs *regs,
>> +					 unsigned int i, unsigned int n,
>> +					 unsigned long *args)
>> +{
>> +	BUG_ON(i);
> This is unacceptable, that would make this function useless.
>
> See Rolands patch:
>
> https://lkml.org/lkml/2009/4/24/399 for a better implementation.
Thanks.  My apology for the lack of investigation.

>> +#endif	/* _ASM_ARM_SYSCALL_H */
>> diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
>> index 7b5cc8d..2509028 100644
>> --- a/arch/arm/include/asm/thread_info.h
>> +++ b/arch/arm/include/asm/thread_info.h
>> @@ -139,6 +139,7 @@ extern void vfp_flush_hwstate(struct thread_info *);
>>   #define TIF_NEED_RESCHED	1
>>   #define TIF_NOTIFY_RESUME	2	/* callback before returning to user */
>>   #define TIF_SYSCALL_TRACE	8
>> +#define TIF_SYSCALL_TRACEPOINT	15
>>   #define TIF_POLLING_NRFLAG	16
>>   #define TIF_USING_IWMMXT	17
>>   #define TIF_MEMDIE		18	/* is terminating due to OOM killer */
>> @@ -150,11 +151,13 @@ extern void vfp_flush_hwstate(struct thread_info *);
>>   #define _TIF_NEED_RESCHED	(1<<  TIF_NEED_RESCHED)
>>   #define _TIF_NOTIFY_RESUME	(1<<  TIF_NOTIFY_RESUME)
>>   #define _TIF_SYSCALL_TRACE	(1<<  TIF_SYSCALL_TRACE)
>> +#define _TIF_SYSCALL_TRACEPOINT	(1<<  TIF_SYSCALL_TRACEPOINT)
>>   #define _TIF_POLLING_NRFLAG	(1<<  TIF_POLLING_NRFLAG)
>>   #define _TIF_USING_IWMMXT	(1<<  TIF_USING_IWMMXT)
>>   #define _TIF_FREEZE		(1<<  TIF_FREEZE)
>>   #define _TIF_RESTORE_SIGMASK	(1<<  TIF_RESTORE_SIGMASK)
>>   #define _TIF_SECCOMP		(1<<  TIF_SECCOMP)
>> +#define _TIF_SYSCALL_T_OR_A	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT)
> What does 'A' stand for?
'A' originally stands for AUDIT.  I should have used a better name as 
there is no _TIF_SYSCALL_AUDIT for ARM.
Probably it is better to define _TIF_WORK_SYSCALL_ENTRY and 
_TIF_WORK_SYSCALL_EXIT properly.

>>   /*
>>    * Change these and you break ASM code in entry-common.S
>> diff --git a/arch/arm/include/asm/unistd.h b/arch/arm/include/asm/unistd.h
>> index 4a11237..f4eac2d 100644
>> --- a/arch/arm/include/asm/unistd.h
>> +++ b/arch/arm/include/asm/unistd.h
>> @@ -405,6 +405,9 @@
>>   #define __NR_process_vm_readv		(__NR_SYSCALL_BASE+376)
>>   #define __NR_process_vm_writev		(__NR_SYSCALL_BASE+377)
>>
>> +#ifndef __ASSEMBLY__
>> +#define NR_syscalls		378
>> +#endif
>>   /*
>>    * The following SWIs are ARM private.
>>    */
>> diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
>> index b2a27b6..a1577c2 100644
>> --- a/arch/arm/kernel/entry-common.S
>> +++ b/arch/arm/kernel/entry-common.S
>> @@ -87,7 +87,7 @@ ENTRY(ret_from_fork)
>>   	get_thread_info tsk
>>   	ldr	r1, [tsk, #TI_FLAGS]		@ check for syscall tracing
>>   	mov	why, #1
>> -	tst	r1, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
>> +	tst	r1, #_TIF_SYSCALL_T_OR_A	@ are we tracing syscalls?
>>   	beq	ret_slow_syscall
>>   	mov	r1, sp
>>   	mov	r0, #1				@ trace exit [IP = 1]
>> @@ -443,7 +443,7 @@ ENTRY(vector_swi)
>>   1:
>>   #endif
>>
>> -	tst	r10, #_TIF_SYSCALL_TRACE		@ are we tracing syscalls?
>> +	tst	r10, #_TIF_SYSCALL_T_OR_A	@ are we tracing syscalls?
>>   	bne	__sys_trace
>>
>>   	cmp	scno, #NR_syscalls		@ check upper syscall limit
>> diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
>> index 483727a..a690c9f 100644
>> --- a/arch/arm/kernel/ptrace.c
>> +++ b/arch/arm/kernel/ptrace.c
>> @@ -28,6 +28,9 @@
>>   #include<asm/system.h>
>>   #include<asm/traps.h>
>>
>> +#define CREATE_TRACE_POINTS
>> +#include<trace/events/syscalls.h>
>> +
>>   #define REG_PC	15
>>   #define REG_PSR	16
>>   /*
>> @@ -906,6 +909,13 @@ asmlinkage int syscall_trace(int why, struct pt_regs *regs, int
>> scno)
>>   {
>>   	unsigned long ip;
> Not used, you get the same info from 'why'.
Sorry. But I do not understand what you suggest here.  This is the 
existing code.

>
>> +	if (unlikely(test_thread_flag(TIF_SYSCALL_TRACEPOINT))) {
>> +		if (why)
>> +			trace_sys_exit(regs, regs->ARM_r0);
>> +		else
>> +			trace_sys_enter(regs, scno);
>> +	}
>> +
>>   	if (!test_thread_flag(TIF_SYSCALL_TRACE))
>>   		return scno;
>>   	if (!(current->ptrace&  PT_PTRACED))
>

Thanks,

Takuo


