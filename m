Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab0FYVcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 17:32:32 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:30532 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0FYVca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 17:32:30 -0400
Message-ID: <4C25206D.6070305@tilera.com>
Date: Fri, 25 Jun 2010 17:32:29 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: Enable more sophisticated IRQ model for 32-bit
 chips.
References: <201006252110.o5PLAovH010769@farm-0002.internal.tilera.com> <alpine.LFD.2.00.1006252320430.18683@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1006252320430.18683@localhost.localdomain>
Content-Type: multipart/mixed;
	boundary="------------080804050503090502060800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------080804050503090502060800
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 6/25/2010 5:22 PM, Thomas Gleixner wrote:
> [...]
> can you please cc me on irq related changes ? Also I'd prefer a combo
> patch of the irq code which lets me see the full story w/o going to
> pull another git tree from somewhere.

Sure, I'll cc you going forward.

What kind of combo patch did you have in mind?  Do you just want copies
of the arch/tile files relevant to irqs?  I've attached irq.h and irq.c
to this email; the rest (e.g. smp.c) is pretty minimal and probably best
viewed in the diff context anyway.

I figured since the first round of tile-architecture changes has been
signed off on and is in linux-next, I should treat that as a baseline
when sending additional patches to LKML going forward.  Maybe I'm
confused :-)

Thanks in advance for your review and any patch-process clarification
you can offer.
-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


--------------080804050503090502060800
Content-Type: text/plain; name="irq.h"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="irq.h"

/*
 * Copyright 2010 Tilera Corporation. All Rights Reserved.
 *
 *   This program is free software; you can redistribute it and/or
 *   modify it under the terms of the GNU General Public License
 *   as published by the Free Software Foundation, version 2.
 *
 *   This program is distributed in the hope that it will be useful, but
 *   WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
 *   NON INFRINGEMENT.  See the GNU General Public License for
 *   more details.
 */

#ifndef _ASM_TILE_IRQ_H
#define _ASM_TILE_IRQ_H

#include <linux/hardirq.h>

/* The hypervisor interface provides 32 IRQs. */
#define NR_IRQS 32

/* IRQ numbers used for linux IPIs. */
#define IRQ_RESCHEDULE 1

void ack_bad_irq(unsigned int irq);

/*
 * Different ways of handling interrupts.  Tile interrupts are always
 * per-cpu; there is no global interrupt controller to implement
 * enable/disable.  Most onboard devices can send their interrupts to
 * many tiles at the same time, and Tile-specific drivers know how to
 * deal with this.
 *
 * However, generic devices (usually PCIE based, sometimes GPIO)
 * expect that interrupts will fire on a single core at a time and
 * that the irq can be enabled or disabled from any core at any time.
 * We implement this by directing such interrupts to a single core.
 *
 * One added wrinkle is that PCI interrupts can be either
 * hardware-cleared (legacy interrupts) or software cleared (MSI).
 * Other generic device systems (GPIO) are always software-cleared.
 *
 * The enums below are used by drivers for onboard devices, including
 * the internals of PCI root complex and GPIO.  They allow the driver
 * to tell the generic irq code what kind of interrupt is mapped to a
 * particular IRQ number.
 */
enum {
	/* per-cpu interrupt; use enable/disable_percpu_irq() to mask */
	TILE_IRQ_PERCPU,
	/* global interrupt, hardware responsible for clearing. */
	TILE_IRQ_HW_CLEAR,
	/* global interrupt, software responsible for clearing. */
	TILE_IRQ_SW_CLEAR,
};


/*
 * Paravirtualized drivers should call this when they dynamically
 * allocate a new IRQ or discover an IRQ that was pre-allocated by the
 * hypervisor for use with their particular device.  This gives the
 * IRQ subsystem an opportunity to do interrupt-type-specific
 * initialization.
 *
 * ISSUE: We should modify this API so that registering anything
 * except percpu interrupts also requires providing callback methods
 * for enabling and disabling the interrupt.  This would allow the
 * generic IRQ code to proxy enable/disable_irq() calls back into the
 * PCI subsystem, which in turn could enable or disable the interrupt
 * at the PCI shim.
 */
void tile_irq_activate(unsigned int irq, int tile_irq_type);

/*
 * For onboard, non-PCI (e.g. TILE_IRQ_PERCPU) devices, drivers know
 * how to use enable/disable_percpu_irq() to manage interrupts on each
 * core.  We can't use the generic enable/disable_irq() because they
 * use a single reference count per irq, rather than per cpu per irq.
 */
void enable_percpu_irq(unsigned int irq);
void disable_percpu_irq(unsigned int irq);


void setup_irq_regs(void);

#endif /* _ASM_TILE_IRQ_H */


--------------080804050503090502060800
Content-Type: text/x-csrc; name="irq.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="irq.c"

/*
 * Copyright 2010 Tilera Corporation. All Rights Reserved.
 *
 *   This program is free software; you can redistribute it and/or
 *   modify it under the terms of the GNU General Public License
 *   as published by the Free Software Foundation, version 2.
 *
 *   This program is distributed in the hope that it will be useful, but
 *   WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
 *   NON INFRINGEMENT.  See the GNU General Public License for
 *   more details.
 */

#include <linux/module.h>
#include <linux/seq_file.h>
#include <linux/interrupt.h>
#include <linux/irq.h>
#include <linux/kernel_stat.h>
#include <linux/uaccess.h>
#include <hv/drv_pcie_rc_intf.h>
#include <arch/spr_def.h>
#include <asm/traps.h>

/* Bit-flag stored in irq_desc->chip_data to indicate HW-cleared irqs. */
#define IS_HW_CLEARED 1

/*
 * The set of interrupts we enable for raw_local_irq_enable().
 * This is initialized to have just a single interrupt that the kernel
 * doesn't actually use as a sentinel.  During kernel init,
 * interrupts are added as the kernel gets prepared to support them.
 * NOTE: we could probably initialize them all statically up front.
 */
DEFINE_PER_CPU(unsigned long long, interrupts_enabled_mask) =
  INITIAL_INTERRUPTS_ENABLED;
EXPORT_PER_CPU_SYMBOL(interrupts_enabled_mask);

/* Define per-tile device interrupt statistics state. */
DEFINE_PER_CPU(irq_cpustat_t, irq_stat) ____cacheline_internodealigned_in_smp;
EXPORT_PER_CPU_SYMBOL(irq_stat);

/*
 * Define per-tile irq disable mask; the hardware/HV only has a single
 * mask that we use to implement both masking and disabling.
 */
static DEFINE_PER_CPU(unsigned long, irq_disable_mask)
	____cacheline_internodealigned_in_smp;

/*
 * Per-tile IRQ nesting depth.  Used to make sure we enable newly
 * enabled IRQs before exiting the outermost interrupt.
 */
static DEFINE_PER_CPU(int, irq_depth);

/* State for allocating IRQs on Gx. */
#if CHIP_HAS_IPI()
static unsigned long available_irqs = ~(1UL << IRQ_RESCHEDULE);
static DEFINE_SPINLOCK(available_irqs_lock);
#endif

#if CHIP_HAS_IPI()
/* Use SPRs to manipulate device interrupts. */
#define mask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_SET_1, irq_mask)
#define unmask_irqs(irq_mask) __insn_mtspr(SPR_IPI_MASK_RESET_1, irq_mask)
#define clear_irqs(irq_mask) __insn_mtspr(SPR_IPI_EVENT_RESET_1, irq_mask)
#else
/* Use HV to manipulate device interrupts. */
#define mask_irqs(irq_mask) hv_disable_intr(irq_mask)
#define unmask_irqs(irq_mask) hv_enable_intr(irq_mask)
#define clear_irqs(irq_mask) hv_clear_intr(irq_mask)
#endif

/*
 * The interrupt handling path, implemented in terms of HV interrupt
 * emulation on TILE64 and TILEPro, and IPI hardware on TILE-Gx.
 */
void tile_dev_intr(struct pt_regs *regs, int intnum)
{
	int depth = __get_cpu_var(irq_depth)++;
	unsigned long original_irqs;
	unsigned long remaining_irqs;
	struct pt_regs *old_regs;

#if CHIP_HAS_IPI()
	/*
	 * Pending interrupts are listed in an SPR.  We might be
	 * nested, so be sure to only handle irqs that weren't already
	 * masked by a previous interrupt.  Then, mask out the ones
	 * we're going to handle.
	 */
	unsigned long masked = __insn_mfspr(SPR_IPI_MASK_1);
	original_irqs = __insn_mfspr(SPR_IPI_EVENT_1) & ~masked;
	__insn_mtspr(SPR_IPI_MASK_SET_1, original_irqs);
#else
	/*
	 * Hypervisor performs the equivalent of the Gx code above and
	 * then puts the pending interrupt mask into a system save reg
	 * for us to find.
	 */
	original_irqs = __insn_mfspr(SPR_SYSTEM_SAVE_1_3);
#endif
	remaining_irqs = original_irqs;

	/* Track time spent here in an interrupt context. */
	old_regs = set_irq_regs(regs);
	irq_enter();

#ifdef CONFIG_DEBUG_STACKOVERFLOW
	/* Debugging check for stack overflow: less than 1/8th stack free? */
	{
		long sp = stack_pointer - (long) current_thread_info();
		if (unlikely(sp < (sizeof(struct thread_info) + STACK_WARN))) {
			pr_emerg("tile_dev_intr: "
			       "stack overflow: %ld\n",
			       sp - sizeof(struct thread_info));
			dump_stack();
		}
	}
#endif
	while (remaining_irqs) {
		unsigned long irq = __ffs(remaining_irqs);
		remaining_irqs &= ~(1UL << irq);

		/* Count device irqs; Linux IPIs are counted elsewhere. */
		if (irq != IRQ_RESCHEDULE)
			__get_cpu_var(irq_stat).irq_dev_intr_count++;

		generic_handle_irq(irq);
	}

	/*
	 * If we weren't nested, turn on all enabled interrupts,
	 * including any that were reenabled during interrupt
	 * handling.
	 */
	if (depth == 0)
		unmask_irqs(~__get_cpu_var(irq_disable_mask));

	__get_cpu_var(irq_depth)--;

	/*
	 * Track time spent against the current process again and
	 * process any softirqs if they are waiting.
	 */
	irq_exit();
	set_irq_regs(old_regs);
}


/*
 * Remove an irq from the disabled mask.  If we're in an interrupt
 * context, defer enabling the HW interrupt until we leave.
 */
void enable_percpu_irq(unsigned int irq)
{
	get_cpu_var(irq_disable_mask) &= ~(1UL << irq);
	if (__get_cpu_var(irq_depth) == 0)
		unmask_irqs(1UL << irq);
	put_cpu_var(irq_disable_mask);
}
EXPORT_SYMBOL(enable_percpu_irq);

/*
 * Add an irq to the disabled mask.  We disable the HW interrupt
 * immediately so that there's no possibility of it firing.  If we're
 * in an interrupt context, the return path is careful to avoid
 * unmasking a newly disabled interrupt.
 */
void disable_percpu_irq(unsigned int irq)
{
	get_cpu_var(irq_disable_mask) |= (1UL << irq);
	mask_irqs(1UL << irq);
	put_cpu_var(irq_disable_mask);
}
EXPORT_SYMBOL(disable_percpu_irq);

/* Mask an interrupt. */
static void tile_irq_chip_mask(unsigned int irq)
{
	mask_irqs(1UL << irq);
}

/* Unmask an interrupt. */
static void tile_irq_chip_unmask(unsigned int irq)
{
	unmask_irqs(1UL << irq);
}

/*
 * Clear an interrupt before processing it so that any new assertions
 * will trigger another irq.
 */
static void tile_irq_chip_ack(unsigned int irq)
{
	if ((unsigned long)get_irq_chip_data(irq) != IS_HW_CLEARED)
		clear_irqs(1UL << irq);
}

/*
 * For per-cpu interrupts, we need to avoid unmasking any interrupts
 * that we disabled via disable_percpu_irq().
 */
static void tile_irq_chip_eoi(unsigned int irq)
{
	if (!(__get_cpu_var(irq_disable_mask) & (1UL << irq)))
		unmask_irqs(1UL << irq);
}

static struct irq_chip tile_irq_chip = {
	.typename = "tile_irq_chip",
	.ack = tile_irq_chip_ack,
	.eoi = tile_irq_chip_eoi,
	.mask = tile_irq_chip_mask,
	.unmask = tile_irq_chip_unmask,
};

void __init init_IRQ(void)
{
	ipi_init();
}

void __cpuinit setup_irq_regs(void)
{
	/* Enable interrupt delivery. */
	unmask_irqs(~0UL);
#if CHIP_HAS_IPI()
	raw_local_irq_unmask(INT_IPI_1);
#endif
}

void tile_irq_activate(unsigned int irq, int tile_irq_type)
{
	/*
	 * We use handle_level_irq() by default because the pending
	 * interrupt vector (whether modeled by the HV on TILE64 and
	 * TILEPro or implemented in hardware on TILE-Gx) has
	 * level-style semantics for each bit.  An interrupt fires
	 * whenever a bit is high, not just at edges.
	 */
	irq_flow_handler_t handle = handle_level_irq;
	if (tile_irq_type == TILE_IRQ_PERCPU)
		handle = handle_percpu_irq;
	set_irq_chip_and_handler(irq, &tile_irq_chip, handle);

	/*
	 * Flag interrupts that are hardware-cleared so that ack()
	 * won't clear them.
	 */
	if (tile_irq_type == TILE_IRQ_HW_CLEAR)
		set_irq_chip_data(irq, (void *)IS_HW_CLEARED);
}
EXPORT_SYMBOL(tile_irq_activate);


void ack_bad_irq(unsigned int irq)
{
	pr_err("unexpected IRQ trap at vector %02x\n", irq);
}

/*
 * Generic, controller-independent functions:
 */

int show_interrupts(struct seq_file *p, void *v)
{
	int i = *(loff_t *) v, j;
	struct irqaction *action;
	unsigned long flags;

	if (i == 0) {
		seq_printf(p, "           ");
		for (j = 0; j < NR_CPUS; j++)
			if (cpu_online(j))
				seq_printf(p, "CPU%-8d", j);
		seq_putc(p, '\n');
	}

	if (i < NR_IRQS) {
		raw_spin_lock_irqsave(&irq_desc[i].lock, flags);
		action = irq_desc[i].action;
		if (!action)
			goto skip;
		seq_printf(p, "%3d: ", i);
#ifndef CONFIG_SMP
		seq_printf(p, "%10u ", kstat_irqs(i));
#else
		for_each_online_cpu(j)
			seq_printf(p, "%10u ", kstat_irqs_cpu(i, j));
#endif
		seq_printf(p, " %14s", irq_desc[i].chip->typename);
		seq_printf(p, "  %s", action->name);

		for (action = action->next; action; action = action->next)
			seq_printf(p, ", %s", action->name);

		seq_putc(p, '\n');
skip:
		raw_spin_unlock_irqrestore(&irq_desc[i].lock, flags);
	}
	return 0;
}

#if CHIP_HAS_IPI()
int create_irq(void)
{
	unsigned long flags;
	int result;

	spin_lock_irqsave(&available_irqs_lock, flags);
	if (available_irqs == 0)
		result = -ENOMEM;
	else {
		result = __ffs(available_irqs);
		available_irqs &= ~(1UL << result);
		dynamic_irq_init(result);
	}
	spin_unlock_irqrestore(&available_irqs_lock, flags);

	return result;
}
EXPORT_SYMBOL(create_irq);

void destroy_irq(unsigned int irq)
{
	unsigned long flags;

	spin_lock_irqsave(&available_irqs_lock, flags);
	available_irqs |= (1UL << irq);
	dynamic_irq_cleanup(irq);
	spin_unlock_irqrestore(&available_irqs_lock, flags);
}
EXPORT_SYMBOL(destroy_irq);
#endif


--------------080804050503090502060800--
