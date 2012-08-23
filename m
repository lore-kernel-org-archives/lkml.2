Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab2HWE2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:28:21 -0400
Received: from ozlabs.org ([203.10.76.45]:58065 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2HWE2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:28:17 -0400
Message-ID: <1345696100.3338.21.camel@concordia>
Subject: Re: [PATCH v4 2/2] powerpc: Uprobes port to powerpc
From: Michael Ellerman <michael@ellerman.id.au>
To: ananth@in.ibm.com
Cc: ppcdev <linuxppc-dev@lists.ozlabs.org>,
        lkml <linux-kernel@vger.kernel.org>, benh@kernel.crashing.org,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        peterz@infradead.org, oleg@redhat.com,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Date: Thu, 23 Aug 2012 14:28:20 +1000
In-Reply-To: <20120822082708.GB29216@in.ibm.com>
References: <20120822082205.GA29216@in.ibm.com>
	 <20120822082708.GB29216@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 13:57 +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This is the port of uprobes to powerpc. Usage is similar to x86.

Hi Ananth,

Excuse my ignorance of uprobes, some comments inline ...


> [root@xxxx ~]# ./bin/perf probe -x /lib64/libc.so.6 malloc
> Added new event:
>   probe_libc:malloc    (on 0xb4860)
> 
> You can now use it in all perf tools, such as:
> 
> 	perf record -e probe_libc:malloc -aR sleep 1

Is there a test suite for any of this?


> Index: linux-tip-16aug/arch/powerpc/include/asm/uprobes.h
> ===================================================================
> --- /dev/null
> +++ linux-tip-16aug/arch/powerpc/include/asm/uprobes.h
> @@ -0,0 +1,58 @@
> +#ifndef _ASM_UPROBES_H
> +#define _ASM_UPROBES_H
> +/*
> + * User-space Probes (UProbes) for powerpc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2007-2012

The lawyers say we shouldn't use (C).

Is it really copyright IBM 2007-2012? Or is that because you copied
another header?


> +typedef unsigned int uprobe_opcode_t;

I'd prefer u32.

It would be nice if someone could consolidate this with kprobe_opcode_t.


> +#define MAX_UINSN_BYTES			4
> +#define UPROBE_XOL_SLOT_BYTES		(MAX_UINSN_BYTES)
> +
> +#define UPROBE_SWBP_INSN		0x7fe00008

This is just "trap" ?

> +#define UPROBE_SWBP_INSN_SIZE		4 /* swbp insn size in bytes */
> +
> +#define IS_TW(instr)		(((instr) & 0xfc0007fe) == 0x7c000008)
> +#define IS_TD(instr)		(((instr) & 0xfc0007fe) == 0x7c000088)
> +#define IS_TDI(instr)		(((instr) & 0xfc000000) == 0x08000000)
> +#define IS_TWI(instr)		(((instr) & 0xfc000000) == 0x0c000000)
> +
> +#define is_trap(instr)	(IS_TW(instr) || IS_TD(instr) || \
> +			IS_TWI(instr) || IS_TDI(instr))

These seem to be duplicated in kprobes.h, can we consolidate them.

> +struct arch_uprobe {
> +	u8	insn[MAX_UINSN_BYTES];
> +};

Why not uprobe_opcode_t insn ?



> Index: linux-tip-16aug/arch/powerpc/kernel/signal.c
> ===================================================================
> --- linux-tip-16aug.orig/arch/powerpc/kernel/signal.c
> +++ linux-tip-16aug/arch/powerpc/kernel/signal.c
> @@ -11,6 +11,7 @@
>  
>  #include <linux/tracehook.h>
>  #include <linux/signal.h>
> +#include <linux/uprobes.h>
>  #include <linux/key.h>
>  #include <asm/hw_breakpoint.h>
>  #include <asm/uaccess.h>
> @@ -157,6 +158,11 @@ static int do_signal(struct pt_regs *reg
>  
>  void do_notify_resume(struct pt_regs *regs, unsigned long thread_info_flags)
>  {
> +	if (thread_info_flags & _TIF_UPROBE) {
> +		clear_thread_flag(TIF_UPROBE);
> +		uprobe_notify_resume(regs);
> +	}

Presumably this ordering is crucial, ie. uprobes before signals.

>  	if (thread_info_flags & _TIF_SIGPENDING)
>  		do_signal(regs);
>  
> Index: linux-tip-16aug/arch/powerpc/kernel/uprobes.c
> ===================================================================
> --- /dev/null
> +++ linux-tip-16aug/arch/powerpc/kernel/uprobes.c
> @@ -0,0 +1,180 @@
> +/*
> + * User-space Probes (UProbes) for powerpc
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
> + *
> + * Copyright (C) IBM Corporation, 2007-2012
> + *
> + * Adapted from the x86 port by Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> + */
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/ptrace.h>
> +#include <linux/uprobes.h>
> +#include <linux/uaccess.h>
> +#include <linux/kdebug.h>
> +
> +#include <asm/sstep.h>
> +
> +#define UPROBE_TRAP_NR	UINT_MAX

In the comments below you talk about -1 a few times, but you actually
mean UINT_MAX.


> +/**
> + * arch_uprobe_analyze_insn

Analyze what about the instruction?

> + * @mm: the probed address space.
> + * @arch_uprobe: the probepoint information.
> + * @addr: vaddr to probe.
> + * Return 0 on success or a -ve number on error.
> + */
> +int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm, unsigned long addr)
> +{
> +	unsigned int insn;
> +
> +	if (addr & 0x03)
> +		return -EINVAL;
> +
> +	memcpy(&insn, auprobe->insn, MAX_UINSN_BYTES);

We shouldn't need to use memcpy, we know it's a u32.

> +	if (is_trap(insn))
> +		return -ENOTSUPP;

A comment saying why we can't handle this would be nice.

> +	return 0;
> +}


I am probably missing something, but why do we need to execute out of
line?

> +/*
> + * arch_uprobe_pre_xol - prepare to execute out of line.
> + * @auprobe: the probepoint information.
> + * @regs: reflects the saved user state of current task.
> + */
> +int arch_uprobe_pre_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct arch_uprobe_task *autask = &current->utask->autask;
> +
> +	autask->saved_trap_nr = current->thread.trap_nr;
> +	current->thread.trap_nr = UPROBE_TRAP_NR;
> +	regs->nip = current->utask->xol_vaddr;
> +	return 0;
> +}
> +
> +/**
> + * uprobe_get_swbp_addr - compute address of swbp given post-swbp regs
> + * @regs: Reflects the saved state of the task after it has hit a breakpoint
> + * instruction.
> + * Return the address of the breakpoint instruction.
> + */
> +unsigned long uprobe_get_swbp_addr(struct pt_regs *regs)
> +{
> +	return instruction_pointer(regs);
> +}

This seems like it would be better in asm/uprobes.h as a static inline,
but that's not your fault.

> +/*
> + * If xol insn itself traps and generates a signal (SIGILL/SIGSEGV/etc),
> + * then detect the case where a singlestepped instruction jumps back to its
> + * own address. It is assumed that anything like do_page_fault/do_trap/etc
> + * sets thread.trap_nr != -1.
> + *
> + * arch_uprobe_pre_xol/arch_uprobe_post_xol save/restore thread.trap_nr,
> + * arch_uprobe_xol_was_trapped() simply checks that ->trap_nr is not equal to
> + * UPROBE_TRAP_NR == -1 set by arch_uprobe_pre_xol().
> + */
> +bool arch_uprobe_xol_was_trapped(struct task_struct *t)
> +{
> +	if (t->thread.trap_nr != UPROBE_TRAP_NR)
> +		return true;
> +
> +	return false;
> +}
> +
> +/*
> + * Called after single-stepping. To avoid the SMP problems that can
> + * occur when we temporarily put back the original opcode to
> + * single-step, we single-stepped a copy of the instruction.
> + *
> + * This function prepares to resume execution after the single-step.
> + */
> +int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
> +
> +	current->thread.trap_nr = utask->autask.saved_trap_nr;
> +
> +	/*
> +	 * On powerpc, except for loads and stores, most instructions
> +	 * including ones that alter code flow (branches, calls, returns)
> +	 * are emulated in the kernel. We get here only if the emulation
> +	 * support doesn't exist and have to fix-up the next instruction
> +	 * to be executed.
> +	 */
> +	regs->nip = utask->vaddr + MAX_UINSN_BYTES;
> +	return 0;
> +}
> +
> +/* callback routine for handling exceptions. */
> +int arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data)
> +{
> +	struct die_args *args = data;
> +	struct pt_regs *regs = args->regs;
> +
> +	/* We are only interested in userspace traps */
> +	if (regs && !user_mode(regs))
> +		return NOTIFY_DONE;

Do we ever get here with a NULL regs?

> +	switch (val) {
> +	case DIE_BPT:
> +		if (uprobe_pre_sstep_notifier(regs))
> +			return NOTIFY_STOP;
> +		break;
> +	case DIE_SSTEP:
> +		if (uprobe_post_sstep_notifier(regs))
> +			return NOTIFY_STOP;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +/*
> + * This function gets called when XOL instruction either gets trapped or
> + * the thread has a fatal signal, so reset the instruction pointer to its
> + * probed address.
> + */
> +void arch_uprobe_abort_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	struct uprobe_task *utask = current->utask;
> +
> +	current->thread.trap_nr = utask->autask.saved_trap_nr;
> +	instruction_pointer_set(regs, utask->vaddr);
> +}
> +
> +/*
> + * See if the instruction can be emulated.
> + * Returns true if instruction was emulated, false otherwise.
> + */
> +bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> +{
> +	int ret;
> +	unsigned int insn;
> +
> +	memcpy(&insn, auprobe->insn, MAX_UINSN_BYTES);

Why memcpy?

> +
> +	/*
> +	 * emulate_step() returns 1 if the insn was successfully emulated.
> +	 * For all other cases, we need to single-step in hardware.
> +	 */
> +	ret = emulate_step(regs, insn);
> +	if (ret > 0)
> +		return true;

This actually emulates the instruction, ie. the contents of regs are
changed based on the instruction.

That seems to differ vs x86, where arch_uprobe_skip_sstep() just checks
the instruction and returns true/false. Is that because on x86 they are
only returning true for nops? ie. there is no emulation to be done?

It's a little surprising that can_skip_sstep() actually emulates the
instruction, but again that's not your fault.

cheers

