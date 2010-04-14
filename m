Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab0DNGeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 02:34:50 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:39022 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753547Ab0DNGet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 02:34:49 -0400
Message-ID: <4BC56202.9020507@monstr.eu>
Date: Wed, 14 Apr 2010 08:34:42 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Steven J. Magnani" <steve@digidescorp.com>
CC: microblaze-uclinux@itee.uq.edu.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] microblaze: add stack unwinder
References: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
In-Reply-To: <1271220928-3502-1-git-send-email-steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven J. Magnani wrote:
> Implement intelligent backtracing by searching for stack frame creation,
> and emitting only return addresses. Use print_hex_dump() to display the
> entire binary kernel stack.
> 
> Limitation: MMU kernels are not currently able to trace beyond a system trap
> (interrupt, syscall, etc.). It is the intent of this patch to provide
> infrastructure that can be extended to add this capability later.
> 
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN a/arch/microblaze/include/asm/exceptions.h b/arch/microblaze/include/asm/exceptions.h
> --- a/arch/microblaze/include/asm/exceptions.h	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/include/asm/exceptions.h	2010-04-12 22:21:01.000000000 -0500
> @@ -14,6 +14,11 @@
>  #define _ASM_MICROBLAZE_EXCEPTIONS_H
>  
>  #ifdef __KERNEL__
> +
> +#ifndef CONFIG_MMU
> +#define EX_HANDLER_STACK_SIZ	(4*19)
> +#endif
> +
>  #ifndef __ASSEMBLY__
>  
>  /* Macros to enable and disable HW exceptions in the MSR */
> diff -uprN a/arch/microblaze/include/asm/system.h b/arch/microblaze/include/asm/system.h
> --- a/arch/microblaze/include/asm/system.h	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/include/asm/system.h	2010-04-12 22:16:01.000000000 -0500
> @@ -44,7 +44,6 @@ extern struct task_struct *_switch_to(st
>  #define smp_rmb()		rmb()
>  #define smp_wmb()		wmb()
>  
> -void show_trace(struct task_struct *task, unsigned long *stack);
>  void __bad_xchg(volatile void *ptr, int size);
>  
>  static inline unsigned long __xchg(unsigned long x, volatile void *ptr,
> diff -uprN a/arch/microblaze/kernel/entry-nommu.S b/arch/microblaze/kernel/entry-nommu.S
> --- a/arch/microblaze/kernel/entry-nommu.S	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/kernel/entry-nommu.S	2010-04-12 22:16:01.000000000 -0500
> @@ -586,3 +586,31 @@ sys_rt_sigsuspend_wrapper:
>  #include "syscall_table.S"
>  
>  syscall_table_size=(.-sys_call_table)
> +
> +type_SYSCALL:
> +	.ascii "SYSCALL\0"
> +type_IRQ:
> +	.ascii "IRQ\0"
> +type_IRQ_PREEMPT:
> +	.ascii "IRQ (PREEMPTED)\0"
> +type_SYSCALL_PREEMPT:
> +	.ascii " SYSCALL (PREEMPTED)\0"
> +
> +	/*
> +	 * Trap decoding for stack unwinder
> +	 * Tuples are (start addr, end addr, string)
> +	 * If return address lies on [start addr, end addr],
> +	 * unwinder displays 'string'
> +	 */
> +
> +	.align 4
> +.global microblaze_trap_handlers
> +microblaze_trap_handlers:
> +	/* Exact matches come first */
> +	.word ret_to_user  ; .word ret_to_user    ; .word type_SYSCALL
> +	.word ret_from_intr; .word ret_from_intr  ; .word type_IRQ
> +	/* Fuzzy matches go here */
> +	.word ret_from_intr; .word no_intr_resched; .word type_IRQ_PREEMPT
> +	.word work_pending ; .word no_work_pending; .word type_SYSCALL_PREEMPT
> +	/* End of table */
> +	.word 0             ; .word 0               ; .word 0
> diff -uprN a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
> --- a/arch/microblaze/kernel/entry.S	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/kernel/entry.S	2010-04-12 22:16:01.000000000 -0500
> @@ -1127,3 +1127,30 @@ ENTRY(_break)
>  
>  syscall_table_size=(.-sys_call_table)
>  
> +type_SYSCALL:
> +	.ascii "SYSCALL\0"
> +type_IRQ:
> +	.ascii "IRQ\0"
> +type_IRQ_PREEMPT:
> +	.ascii "IRQ (PREEMPTED)\0"
> +type_SYSCALL_PREEMPT:
> +	.ascii " SYSCALL (PREEMPTED)\0"
> +
> +	/*
> +	 * Trap decoding for stack unwinder
> +	 * Tuples are (start addr, end addr, string)
> +	 * If return address lies on [start addr, end addr],
> +	 * unwinder displays 'string'
> +	 */
> +
> +	.align 4
> +.global microblaze_trap_handlers
> +microblaze_trap_handlers:
> +	/* Exact matches come first */
> +	.word ret_from_trap; .word ret_from_trap   ; .word type_SYSCALL
> +	.word ret_from_irq ; .word ret_from_irq    ; .word type_IRQ
> +	/* Fuzzy matches go here */
> +	.word ret_from_irq ; .word no_intr_resched ; .word type_IRQ_PREEMPT
> +	.word ret_from_trap; .word TRAP_return     ; .word type_SYSCALL_PREEMPT
> +	/* End of table */
> +	.word 0               ; .word 0               ; .word 0
> diff -uprN a/arch/microblaze/kernel/hw_exception_handler.S b/arch/microblaze/kernel/hw_exception_handler.S
> --- a/arch/microblaze/kernel/hw_exception_handler.S	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/kernel/hw_exception_handler.S	2010-04-12 22:21:15.000000000 -0500
> @@ -78,9 +78,6 @@
>  #include <asm/asm-offsets.h>
>  
>  /* Helpful Macros */
> -#ifndef CONFIG_MMU
> -#define EX_HANDLER_STACK_SIZ	(4*19)
> -#endif
>  #define NUM_TO_REG(num)		r ## num
>  
>  #ifdef CONFIG_MMU
> @@ -988,6 +985,7 @@ ex_unaligned_fixup:
>  .end _unaligned_data_exception
>  #endif /* CONFIG_MMU */
>  
> +.global ex_handler_unhandled
>  ex_handler_unhandled:
>  /* FIXME add handle function for unhandled exception - dump register */
>  	bri 0
> diff -uprN a/arch/microblaze/kernel/Makefile b/arch/microblaze/kernel/Makefile
> --- a/arch/microblaze/kernel/Makefile	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/kernel/Makefile	2010-04-12 22:16:01.000000000 -0500
> @@ -17,7 +17,8 @@ extra-y := head.o vmlinux.lds
>  obj-y += dma.o exceptions.o \
>  	hw_exception_handler.o init_task.o intc.o irq.o of_device.o \
>  	of_platform.o process.o prom.o prom_parse.o ptrace.o \
> -	setup.o signal.o sys_microblaze.o timer.o traps.o reset.o
> +	setup.o signal.o sys_microblaze.o timer.o traps.o reset.o \
> +	unwind.o
>  
>  obj-y += cpu/
>  
> diff -uprN a/arch/microblaze/kernel/stacktrace.c b/arch/microblaze/kernel/stacktrace.c
> --- a/arch/microblaze/kernel/stacktrace.c	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/kernel/stacktrace.c	2010-04-12 22:16:01.000000000 -0500
> @@ -14,52 +14,18 @@
>  #include <linux/thread_info.h>
>  #include <linux/ptrace.h>
>  #include <linux/module.h>
> +#include "unwind.h"
>  
> -/* FIXME initial support */
>  void save_stack_trace(struct stack_trace *trace)
>  {
> -	unsigned long *sp;
> -	unsigned long addr;
> -	asm("addik %0, r1, 0" : "=r" (sp));
> -
> -	while (!kstack_end(sp)) {
> -		addr = *sp++;
> -		if (__kernel_text_address(addr)) {
> -			if (trace->skip > 0)
> -				trace->skip--;
> -			else
> -				trace->entries[trace->nr_entries++] = addr;
> -
> -			if (trace->nr_entries >= trace->max_entries)
> -				break;
> -		}
> -	}
> +	/* Exclude our helper functions from the trace*/
> +	trace->skip += 2;
> +	microblaze_unwind(NULL, trace);
>  }
>  EXPORT_SYMBOL_GPL(save_stack_trace);
>  
>  void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
>  {
> -	unsigned int *sp;
> -	unsigned long addr;
> -
> -	struct thread_info *ti = task_thread_info(tsk);
> -
> -	if (tsk == current)
> -		asm("addik %0, r1, 0" : "=r" (sp));
> -	else
> -		sp = (unsigned int *)ti->cpu_context.r1;
> -
> -	while (!kstack_end(sp)) {
> -		addr = *sp++;
> -		if (__kernel_text_address(addr)) {
> -			if (trace->skip > 0)
> -				trace->skip--;
> -			else
> -				trace->entries[trace->nr_entries++] = addr;
> -
> -			if (trace->nr_entries >= trace->max_entries)
> -				break;
> -		}
> -	}
> +	microblaze_unwind(tsk, trace);
>  }
>  EXPORT_SYMBOL_GPL(save_stack_trace_tsk);
> diff -uprN a/arch/microblaze/kernel/traps.c b/arch/microblaze/kernel/traps.c
> --- a/arch/microblaze/kernel/traps.c	2010-04-09 21:52:36.000000000 -0500
> +++ b/arch/microblaze/kernel/traps.c	2010-04-12 22:16:01.000000000 -0500
> @@ -13,16 +13,19 @@
>  #include <linux/module.h>
>  #include <linux/sched.h>
>  #include <linux/debug_locks.h>
> +#include <linux/seq_file.h>
>  
>  #include <asm/exceptions.h>
>  #include <asm/system.h>
>  
> +#include "unwind.h"
> +
>  void trap_init(void)
>  {
>  	__enable_hw_exceptions();
>  }
>  
> -static unsigned long kstack_depth_to_print = 24;
> +static unsigned long kstack_depth_to_print;	/* 0 == entire stack */
>  
>  static int __init kstack_setup(char *s)
>  {
> @@ -30,31 +33,42 @@ static int __init kstack_setup(char *s)
>  }
>  __setup("kstack=", kstack_setup);
>  
> -void show_trace(struct task_struct *task, unsigned long *stack)
> +void show_stack(struct task_struct *task, unsigned long *sp)
>  {
> -	unsigned long addr;
> +	unsigned long words_to_show;
> +	__u32 fp = (__u32) sp;
>  
> -	if (!stack)
> -		stack = (unsigned long *)&stack;
> +	if (fp == 0) {
> +		if (task)
> +			fp = ((struct thread_info *)
> +				(task->stack))->cpu_context.r1;
> +		else {
> +			/* Pick up caller of dump_stack() */
> +			fp = (__u32)&sp - 8;
> +		}
> +	}
>  
> -	printk(KERN_NOTICE "Call Trace: ");
> -#ifdef CONFIG_KALLSYMS
> -	printk(KERN_NOTICE "\n");
> -#endif
> -	while (!kstack_end(stack)) {
> -		addr = *stack++;
> -		/*
> -		 * If the address is either in the text segment of the
> -		 * kernel, or in the region which contains vmalloc'ed
> -		 * memory, it *may* be the address of a calling
> -		 * routine; if so, print it so that someone tracing
> -		 * down the cause of the crash will be able to figure
> -		 * out the call path that was taken.
> -		 */
> -		if (kernel_text_address(addr))
> -			print_ip_sym(addr);
> +	words_to_show = (THREAD_SIZE - (fp & (THREAD_SIZE-1))) >> 2;
> +	if (kstack_depth_to_print && (words_to_show > kstack_depth_to_print))
> +		words_to_show = kstack_depth_to_print;
> +
> +	pr_info("Stack:\n");
> +	if (fp & 0xF) {
> +		unsigned long line1_words = (0x10 - (fp & 0xF)) >> 2;
> +		if (line1_words < words_to_show) {
> +			print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 32,
> +				       4, (void *)fp, line1_words << 2, 0);
> +			fp += line1_words << 2;
> +			words_to_show -= line1_words;
> +		}
>  	}
> -	printk(KERN_NOTICE "\n");
> +	print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 32, 4, (void *)fp,
> +		       words_to_show << 2, 0);
> +	printk(KERN_INFO "\n\n");
> +
> +	pr_info("Call Trace:\n");
> +	microblaze_unwind(task, NULL);
> +	pr_info("\n");
>  
>  	if (!task)
>  		task = current;
> @@ -62,34 +76,6 @@ void show_trace(struct task_struct *task
>  	debug_show_held_locks(task);
>  }
>  
> -void show_stack(struct task_struct *task, unsigned long *sp)
> -{
> -	unsigned long *stack;
> -	int i;
> -
> -	if (sp == NULL) {
> -		if (task)
> -			sp = (unsigned long *) ((struct thread_info *)
> -						(task->stack))->cpu_context.r1;
> -		else
> -			sp = (unsigned long *)&sp;
> -	}
> -
> -	stack = sp;
> -
> -	printk(KERN_INFO "\nStack:\n  ");
> -
> -	for (i = 0; i < kstack_depth_to_print; i++) {
> -		if (kstack_end(sp))
> -			break;
> -		if (i && ((i % 8) == 0))
> -			printk("\n  ");
> -		printk("%08lx ", *sp++);
> -	}
> -	printk("\n");
> -	show_trace(task, stack);
> -}
> -
>  void dump_stack(void)
>  {
>  	show_stack(NULL, NULL);
> @@ -129,3 +115,4 @@ int debug_trap(struct pt_regs *regs)
>  	return -ENOSYS;
>  }
>  #endif
> +
> diff -uprN a/arch/microblaze/kernel/unwind.c b/arch/microblaze/kernel/unwind.c
> --- a/arch/microblaze/kernel/unwind.c	1969-12-31 18:00:00.000000000 -0600
> +++ b/arch/microblaze/kernel/unwind.c	2010-04-12 22:16:01.000000000 -0500
> @@ -0,0 +1,316 @@
> +/*
> + * Backtrace support for Microblaze
> + *
> + * Copyright (C) 2010  Digital Design Corporation
> + *
> + * Based on arch/sh/kernel/cpu/sh5/unwind.c code which is:
> + * Copyright (C) 2004  Paul Mundt
> + * Copyright (C) 2004  Richard Curnow
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +
> +/* #define DEBUG 1 */
> +#include <linux/kallsyms.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/stacktrace.h>
> +#include <linux/types.h>
> +#include <linux/errno.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <asm/sections.h>
> +#include <asm/exceptions.h>
> +#include "unwind.h"
> +
> +struct stack_trace;
> +
> +/*
> + * On Microblaze, finding the previous stack frame is a little tricky.
> + * At this writing (3/2010), Microblaze does not support CONFIG_FRAME_POINTERS,
> + * and even if it did, gcc (4.1.2) does not store the frame pointer at
> + * a consistent offset within each frame. To determine frame size, it is
> + * necessary to search for the assembly instruction that creates the frame
> + * and extract the size from it.
> + *
> + * Microblaze stores the stack pointer in r1, and creates a frame via
> + *
> + *     addik r1, r1, -FRAME_SIZE
> + *
> + * A stack frame is usually not created in a leaf function.
> + *
> + */
> +
> +/**
> + * get_frame_size - Extract the stack adjustment from an
> + *                  "addik r1, r1, -adjust" instruction
> + * @instr : Microblaze instruction
> + *
> + * Return - Number of bytes the instruction reserves for a stack frame
> + */
> +inline s16 get_frame_size(unsigned long instr)
> +{
> +	return -(s16)(instr & 0xFFFF);
> +}
> +
> +/**
> + * find_frame_creation - Search backward to find the instruction that creates
> + *                       the stack frame (hopefully, for the same function the
> + *                       initial PC is in).
> + * @pc : Program counter at which to begin the search
> + *
> + * Return - PC at which stack frame creation occurs
> + *          NULL if this cannot be found, i.e. a leaf function
> + */
> +static unsigned long *find_frame_creation(unsigned long *pc)
> +{
> +	int i;
> +
> +	/* NOTE: Distance to search is arbitrary
> +	 *	 250 works well for most things,
> +	 *	 750 picks up things like tcp_recvmsg(),
> +	 *	1000 needed for fat_fill_super()
> +	 */
> +	for (i = 0; i < 1000; i++, pc--) {
> +		unsigned long instr;
> +		s16 frame_size;
> +
> +		if (!kernel_text_address((unsigned long) pc))
> +			return NULL;
> +
> +		instr = *pc;
> +
> +		/*
> +		 * rtsd of some sort,
> +		 * i.e., a return from a previous function?
> +		 */
> +		if ((instr & 0xFFE00000) == 0xb6000000)
> +			return NULL;
> +
> +		if ((instr & 0xFFFF0000) != 0x30210000)	/* addik r1, r1 */
> +			continue;
> +
> +		frame_size = get_frame_size(instr);
> +		if ((frame_size < 8) || (frame_size & 3)) {
> +			pr_debug("    Invalid frame size %d at 0x%p\n",
> +				 frame_size, pc);
> +			return NULL;
> +		}
> +
> +		pr_debug("    Found frame creation at 0x%p, size %d\n", pc,
> +			 frame_size);
> +		return pc;
> +	}
> +
> +	return NULL;
> +}
> +
> +/**
> + * lookup_prev_stack_frame - Find the stack frame of the previous function.
> + * @fp          : Frame (stack) pointer for current function
> + * @pc          : Program counter within current function
> + * @leaf_return : r15 value within current function. If the current function
> + *		  is a leaf, this is the caller's return address.
> + * @pprev_fp    : On exit, set to frame (stack) pointer for previous function
> + * @pprev_pc    : On exit, set to current function caller's return address
> + *
> + * Return - 0 on success, -EINVAL if the previous frame cannot be found
> + */
> +static int lookup_prev_stack_frame(unsigned long fp, unsigned long pc,
> +				   unsigned long leaf_return,
> +				   unsigned long *pprev_fp,
> +				   unsigned long *pprev_pc)
> +{
> +	unsigned long *prologue = NULL;
> +
> +	/* _switch_to is a special leaf function */
> +	if (pc != (unsigned long) &_switch_to)
> +		prologue = find_frame_creation((unsigned long *)pc);
> +
> +	if (prologue) {
> +		s16 frame_size = get_frame_size(*prologue);
> +
> +		*pprev_fp = fp + frame_size;
> +		*pprev_pc = *(unsigned long *)fp;
> +	} else {
> +		if (!leaf_return)
> +			return -EINVAL;
> +		*pprev_pc = leaf_return;
> +		*pprev_fp = fp;
> +	}
> +
> +	/* NOTE: don't check kernel_text_address here, to allow display
> +	 *	 of userland return address
> +	 */
> +	return (!*pprev_pc || (*pprev_pc & 3)) ? -EINVAL : 0;
> +}
> +
> +static void microblaze_unwind_inner(struct task_struct *task,
> +				    unsigned long pc, unsigned long fp,
> +				    unsigned long leaf_return,
> +				    struct stack_trace *trace);
> +
> +/**
> + * unwind_trap - Unwind through a system trap, that stored previous state
> + *		 on the stack.
> + */
> +#ifdef CONFIG_MMU
> +static inline void unwind_trap(struct task_struct *task, unsigned long pc,
> +				unsigned long fp, struct stack_trace *trace)
> +{
> +	/* To be implemented */
> +}
> +#else
> +static inline void unwind_trap(struct task_struct *task, unsigned long pc,
> +				unsigned long fp, struct stack_trace *trace)
> +{
> +	const struct pt_regs *regs = (const struct pt_regs *) fp;
> +	microblaze_unwind_inner(task, regs->pc, regs->r1, regs->r15, trace);
> +}
> +#endif
> +
> +/**
> + * microblaze_unwind_inner - Unwind the stack from the specified point
> + * @task  : Task whose stack we are to unwind (may be NULL)
> + * @pc    : Program counter from which we start unwinding
> + * @fp    : Frame (stack) pointer from which we start unwinding
> + * @leaf_return : Value of r15 at pc. If the function is a leaf, this is
> + *				  the caller's return address.
> + * @trace : Where to store stack backtrace (PC values).
> + *	    NULL == print backtrace to kernel log
> + */
> +void microblaze_unwind_inner(struct task_struct *task,
> +			     unsigned long pc, unsigned long fp,
> +			     unsigned long leaf_return,
> +			     struct stack_trace *trace)
> +{
> +	int ofs = 0;
> +
> +	pr_debug("    Unwinding with PC=%p, FP=%p\n", (void *)pc, (void *)fp);
> +	if (!pc || !fp || (pc & 3) || (fp & 3)) {
> +		pr_debug("    Invalid state for unwind, aborting\n");
> +		return;
> +	}
> +	for (; pc != 0;) {
> +		unsigned long next_fp, next_pc = 0;
> +		unsigned long return_to = pc +  2 * sizeof(unsigned long);
> +		const struct trap_handler_info *handler =
> +			&microblaze_trap_handlers;
> +
> +		/* Is previous function the HW exception handler? */
> +		if ((return_to >= (unsigned long)&_hw_exception_handler)
> +		    &&(return_to < (unsigned long)&ex_handler_unhandled)) {
> +			/*
> +			 * HW exception handler doesn't save all registers,
> +			 * so we open-code a special case of unwind_trap()
> +			 */
> +#ifndef CONFIG_MMU
> +			const struct pt_regs *regs =
> +				(const struct pt_regs *) fp;
> +#endif
> +			pr_info("HW EXCEPTION\n");
> +#ifndef CONFIG_MMU
> +			microblaze_unwind_inner(task, regs->r17 - 4,
> +						fp + EX_HANDLER_STACK_SIZ,
> +						regs->r15, trace);
> +#endif
> +			return;
> +		}
> +
> +		/* Is previous function a trap handler? */
> +		for (; handler->start_addr; ++handler) {
> +			if ((return_to >= handler->start_addr)
> +			    && (return_to <= handler->end_addr)) {
> +				if (!trace)
> +					pr_info("%s\n", handler->trap_name);
> +				unwind_trap(task, pc, fp, trace);
> +				return;
> +			}
> +		}
> +		pc -= ofs;
> +
> +		if (trace) {
> +#ifdef CONFIG_STACKTRACE
> +			if (trace->skip > 0)
> +				trace->skip--;
> +			else
> +				trace->entries[trace->nr_entries++] = pc;
> +
> +			if (trace->nr_entries >= trace->max_entries)
> +				break;
> +#endif
> +		} else {
> +			/* Have we reached userland? */
> +			if (unlikely(pc == task_pt_regs(task)->pc)) {
> +				pr_info("[<%p>] PID %lu [%s]\n",
> +					(void *) pc,
> +					(unsigned long) task->pid,
> +					task->comm);
> +				break;
> +			} else
> +				print_ip_sym(pc);
> +		}
> +
> +		/* Stop when we reach anything not part of the kernel */
> +		if (!kernel_text_address(pc))
> +			break;
> +
> +		if (lookup_prev_stack_frame(fp, pc, leaf_return, &next_fp,
> +					    &next_pc) == 0) {
> +			ofs = sizeof(unsigned long);
> +			pc = next_pc & ~3;
> +			fp = next_fp;
> +			leaf_return = 0;
> +		} else {
> +			pr_debug("    Failed to find previous stack frame\n");
> +			break;
> +		}
> +
> +		pr_debug("    Next PC=%p, next FP=%p\n",
> +			 (void *)next_pc, (void *)next_fp);
> +	}
> +}
> +
> +/**
> + * microblaze_unwind - Stack unwinder for Microblaze (external entry point)
> + * @task  : Task whose stack we are to unwind (NULL == current)
> + * @trace : Where to store stack backtrace (PC values).
> + *	    NULL == print backtrace to kernel log
> + */
> +void microblaze_unwind(struct task_struct *task, struct stack_trace *trace)
> +{
> +	if (task) {
> +		if (task == current) {
> +			const struct pt_regs *regs = task_pt_regs(task);
> +			microblaze_unwind_inner(task, regs->pc, regs->r1,
> +						regs->r15, trace);
> +		} else {
> +			struct thread_info *thread_info =
> +				(struct thread_info *)(task->stack);
> +			const struct cpu_context *cpu_context =
> +				&thread_info->cpu_context;
> +
> +			microblaze_unwind_inner(task,
> +						(unsigned long) &_switch_to,
> +						cpu_context->r1,
> +						cpu_context->r15, trace);
> +		}
> +	} else {
> +		unsigned long pc, fp;
> +
> +		__asm__ __volatile__ ("or %0, r1, r0" : "=r" (fp));
> +
> +		__asm__ __volatile__ (
> +			"brlid %0, 0f;"
> +			"nop;"
> +			"0:"
> +			: "=r" (pc)
> +		);
> +
> +		/* Since we are not a leaf function, use leaf_return = 0 */
> +		microblaze_unwind_inner(current, pc, fp, 0, trace);
> +	}
> +}
> +
> diff -uprN a/arch/microblaze/kernel/unwind.h b/arch/microblaze/kernel/unwind.h
> --- a/arch/microblaze/kernel/unwind.h	1969-12-31 18:00:00.000000000 -0600
> +++ b/arch/microblaze/kernel/unwind.h	2010-04-12 22:16:01.000000000 -0500

This should go to arch/microblaze/include/asm.
I will test it later today.

Thanks,
Michal



> @@ -0,0 +1,29 @@
> +/*
> + * Backtrace support for Microblaze
> + *
> + * Copyright (C) 2010  Digital Design Corporation
> + *
> + * This file is subject to the terms and conditions of the GNU General Public
> + * License.  See the file "COPYING" in the main directory of this archive
> + * for more details.
> + */
> +
> +#ifndef __MICROBLAZE_UNWIND_H
> +#define __MICROBLAZE_UNWIND_H
> +
> +struct stack_trace;
> +
> +struct trap_handler_info {
> +	unsigned long start_addr;
> +	unsigned long end_addr;
> +	const char    *trap_name;
> +};
> +extern struct trap_handler_info microblaze_trap_handlers;
> +
> +extern const char _hw_exception_handler;
> +extern const char ex_handler_unhandled;
> +
> +void microblaze_unwind(struct task_struct *task, struct stack_trace *trace);
> +
> +#endif	/* __MICROBLAZE_UNWIND_H */
> +
> 
> 


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
