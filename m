Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907Ab1IOHX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:23:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48495 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab1IOHXZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 03:23:25 -0400
thread-index: AcxzeEMECwBW0s94SR2rEL2bOKO3eA==
Content-Transfer-Encoding: 7bit
Content-Class: urn:content-classes:message
Importance: normal
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4657
Subject: Re: [PATCH] irq: call also chip->irq_mask from irq_disable
From: Tero Kristo <t-kristo@ti.com>
Reply-To: <t-kristo@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "LKML" <linux-kernel@vger.kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>
In-Reply-To: <alpine.LFD.2.02.1109142149060.2723@ionos>
References: <1315990675-22814-1-git-send-email-t-kristo@ti.com> <alpine.LFD.2.02.1109141757150.2723@ionos> <1316023293.2355.33.camel@sokoban> <alpine.LFD.2.02.1109142149060.2723@ionos>
Content-Type: multipart/mixed; boundary="=-y255YSwldiZefr07Vx08"
Organization: Texas Instruments
Date: Thu, 15 Sep 2011 10:22:34 +0300
Message-ID: <1316071354.2216.6.camel@sokoban>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-y255YSwldiZefr07Vx08
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2011-09-14 at 21:50 +0200, Thomas Gleixner wrote:
> On Wed, 14 Sep 2011, Tero Kristo wrote:
> > On Wed, 2011-09-14 at 18:04 +0200, Thomas Gleixner wrote:
> > > What are you trying to solve ?
> >=20
> > I was seeing a hang with a chain handler implementation that was =
caused
> > by this delayed disable implementation, I am using a generic chip =
with
> > irq_mask / irq_unmask. Adding this patch to the kernel fixed the =
hang in
> > this case. There might be something wrong in my implementation of =
the
> > chain handler itself, I'll take a look at it again and try to figure =
out
> > another way to avoid it. I have another idea I can pursue, and based =
on
> > some initial testing it actually seems to be working.
>=20
> chained handlers are not subject to disable/enable_irq usually. Care
> to share the code ?
>=20

Sure, attached my current code as a c-file, it is probable easier to
check it out in this form rather than as a patch. Couple of things to
note in this driver, why I was trying to use irq_disable / irq_enable
was because I want to postpone processing of the wakeup events when we
are waking up from suspend, as this driver is potentially serving
several clients that want to have wakeup events from the IO chain. Now I
just disable all interrupts manually if we are within suspend cycle, and
re-enable all when we have completed wakeup. (Previously I tried calling
irq_disable / irq_enable from suspend.prepare and suspend.complete
callbacks.)

Don't mind about some of the magic numbers in the code, those will be
fixed once I get the proper init sequence in place. Some of the
strangeness in the code is also because this must work for multiple OMAP
versions, thus it should be pretty configurable.

-Tero


Texas Instruments Oy, Tekniikantie 12, 02150 Espoo. Y-tunnus: 0115040-6. =
Kotipaikka: Helsinki
=20


--=-y255YSwldiZefr07Vx08
Content-Disposition: attachment; filename="omap_prm.c"
Content-Type: text/x-csrc; charset="UTF-8"; name="omap_prm.c"
Content-Transfer-Encoding: 7bit

/*
 * OMAP Power and Reset Management (PRM) driver
 *
 * Copyright (C) 2011 Texas Instruments, Inc.
 *
 * Author: Tero Kristo <t-kristo@ti.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

#include <linux/kernel.h>
#include <linux/ctype.h>
#include <linux/module.h>
#include <linux/io.h>
#include <linux/irq.h>
#include <linux/interrupt.h>
#include <linux/slab.h>
#include <linux/init.h>
#include <linux/err.h>
#include <linux/platform_device.h>

#include <plat/irqs.h>

#define DRIVER_NAME "omap-prm"
#define OMAP_PRCM_MAX_NR_PENDING_REG 2

struct omap_prcm_irq_setup {
	u32 ack;
	u32 mask;
	int irq;
	int io_irq;
	int base_irq;
	int nr_regs;
};

struct omap_prm_device {
	struct platform_device		pdev;
	struct omap_prcm_irq_setup	irq_setup;
	struct irq_chip_generic		**irq_chips;
	int				suspended;
	u32				*saved_ena;
};

static struct omap_prm_device prm_dev = {
	.pdev		= {
		.name	= DRIVER_NAME,
		.id	= -1,
	},
};

struct omap_prcm_irq {
	const char *name;
	unsigned int offset;
	const struct omap_chip_id omap_chip;
};

#define OMAP_PRCM_IRQ(_name, _offset, _chip) {	\
	.name = _name,				\
	.offset = _offset,			\
	.omap_chip = OMAP_CHIP_INIT(_chip)	\
	}

static struct omap_prcm_irq omap_prcm_irqs[] = {
	OMAP_PRCM_IRQ("wkup",		0,
			CHIP_IS_OMAP3430 | CHIP_GE_OMAP3630ES1_1),
	OMAP_PRCM_IRQ("io",		9,
			CHIP_IS_OMAP3430 | CHIP_GE_OMAP3630ES1_1 |
			CHIP_IS_OMAP4430),
};

static void prm_pending_events(unsigned long *events)
{
	u32 ena, st;
	int i;

	memset(events, 0, prm_dev.irq_setup.nr_regs * 8);

	for (i = 0; i < prm_dev.irq_setup.nr_regs; i++) {
		ena = readl(prm_dev.irq_setup.mask + i * 4);
		st = readl(prm_dev.irq_setup.ack + i * 4);
		events[i] = ena & st;
	}
}

/*
 * PRCM Interrupt Handler
 *
 * The PRM_IRQSTATUS_MPU register indicates if there are any pending
 * interrupts from the PRCM for the MPU. These bits must be cleared in
 * order to clear the PRCM interrupt. The PRCM interrupt handler is
 * implemented to simply clear the PRM_IRQSTATUS_MPU in order to clear
 * the PRCM interrupt. Please note that bit 0 of the PRM_IRQSTATUS_MPU
 * register indicates that a wake-up event is pending for the MPU and
 * this bit can only be cleared if the all the wake-up events latched
 * in the various PM_WKST_x registers have been cleared. The interrupt
 * handler is implemented using a do-while loop so that if a wake-up
 * event occurred during the processing of the prcm interrupt handler
 * (setting a bit in the corresponding PM_WKST_x register and thus
 * preventing us from clearing bit 0 of the PRM_IRQSTATUS_MPU register)
 * this would be handled.
 */
static void prcm_irq_handler(unsigned int irq, struct irq_desc *desc)
{
	int i;
	unsigned long pending[OMAP_PRCM_MAX_NR_PENDING_REG];
	struct irq_chip *chip = irq_desc_get_chip(desc);
	unsigned int virtirq;
	int nr_irqs = prm_dev.irq_setup.nr_regs * 32;

	if (prm_dev.suspended)
		for (i = 0; i < prm_dev.irq_setup.nr_regs; i++) {
			prm_dev.saved_ena[i] =
				readl(prm_dev.irq_setup.mask + i * 4);
			writel(0, prm_dev.irq_setup.mask + i * 4);
		}

	/*
	 * Loop until all pending irqs are handled, since
	 * generic_handle_irq() can cause new irqs to come
	 */
	while (!prm_dev.suspended) {
		prm_pending_events(pending);

		/* No bit set, then all IRQs are handled */
		if (find_first_bit(pending, nr_irqs) >= nr_irqs) {
			break;
		}

		/*
		 * Loop on all currently pending irqs so that new irqs
		 * cannot starve previously pending irqs
		 */
		for_each_set_bit(virtirq, pending, nr_irqs)
			generic_handle_irq(prm_dev.irq_setup.base_irq +
				virtirq);

	}
	if (chip->irq_ack)
		chip->irq_ack(&desc->irq_data);
	if (chip->irq_eoi)
		chip->irq_eoi(&desc->irq_data);
	chip->irq_unmask(&desc->irq_data);
}

/*
 * Given a PRCM event name, returns the corresponding IRQ on which the
 * handler should be registered.
 */
int omap_prcm_event_to_irq(const char *name)
{
	int i;

	for (i = 0; i < ARRAY_SIZE(omap_prcm_irqs); i++)
		if (!strcmp(omap_prcm_irqs[i].name, name))
			return prm_dev.irq_setup.base_irq +
				omap_prcm_irqs[i].offset;

	return -ENOENT;
}

/*
 * Reverses memory allocated and other setups done by
 * omap_prcm_irq_init().
 */
void omap_prcm_irq_cleanup(void)
{
	int i;

	if (prm_dev.irq_chips) {
		for (i = 0; i < prm_dev.irq_setup.nr_regs; i++) {
			if (prm_dev.irq_chips[i])
				irq_remove_generic_chip(prm_dev.irq_chips[i],
					0xffffffff, 0, 0);
			prm_dev.irq_chips[i] = NULL;
		}
		kfree(prm_dev.irq_chips);
		prm_dev.irq_chips = NULL;
	}

	irq_set_chained_handler(prm_dev.irq_setup.irq, NULL);

	if (prm_dev.irq_setup.base_irq > 0)
		irq_free_descs(prm_dev.irq_setup.base_irq,
				prm_dev.irq_setup.nr_regs * 32);
	prm_dev.irq_setup.base_irq = 0;
}

/*
 * Prepare the array of PRCM events corresponding to the current SoC,
 * and set-up the chained interrupt handler mechanism.
 */
static int __init omap_prcm_irq_init(void)
{
	int i;
	struct irq_chip_generic *gc;
	struct irq_chip_type *ct;
	u32 mask[OMAP_PRCM_MAX_NR_PENDING_REG];
	int offset;
	int max_irq = 0;

	memset(mask, 0, sizeof(mask));
	for (i = 0; i < ARRAY_SIZE(omap_prcm_irqs); i++)
		if (omap_chip_is(omap_prcm_irqs[i].omap_chip)) {
			offset = omap_prcm_irqs[i].offset;
			mask[offset >> 5] |= 1 << (offset & 0x1f);
			if (offset > max_irq)
				max_irq = offset;
		}

	irq_set_chained_handler(prm_dev.irq_setup.irq, prcm_irq_handler);

	prm_dev.irq_setup.base_irq =
		irq_alloc_descs(-1, 0, prm_dev.irq_setup.nr_regs * 32, 0);

	if (prm_dev.irq_setup.base_irq < 0) {
		pr_err("PRCM: failed to allocate irq descs\n");
		goto err;
	}

	prm_dev.irq_chips = kzalloc(sizeof(void *) * prm_dev.irq_setup.nr_regs,
		GFP_KERNEL);

	prm_dev.saved_ena = kzalloc(sizeof(u32) * prm_dev.irq_setup.nr_regs,
		GFP_KERNEL);

	if (!prm_dev.irq_chips || !prm_dev.saved_ena) {
		pr_err("PRCM: kzalloc failed\n");
		goto err;
	}

	for (i = 0; i <= prm_dev.irq_setup.nr_regs; i++) {
		gc = irq_alloc_generic_chip("PRCM", 1,
			prm_dev.irq_setup.base_irq + i * 32, NULL,
			handle_level_irq);

		if (!gc) {
			pr_err("PRCM: failed to allocate generic chip\n");
			goto err;
		}
		ct = gc->chip_types;
		ct->chip.irq_ack = irq_gc_ack_set_bit;
		ct->chip.irq_mask = irq_gc_mask_clr_bit;
		ct->chip.irq_unmask = irq_gc_mask_set_bit;

		ct->regs.ack = prm_dev.irq_setup.ack + (i << 2);
		ct->regs.mask = prm_dev.irq_setup.mask + (i << 2);

		irq_setup_generic_chip(gc, mask[i], 0, IRQ_NOREQUEST, 0);
		prm_dev.irq_chips[i] = gc;
	}

	return 0;

err:
	omap_prcm_irq_cleanup();
	return -ENOMEM;
}

static int omap_prm_prepare(struct device *kdev)
{
	prm_dev.suspended = 1;
	return 0;
}

static void omap_prm_complete(struct device *kdev)
{
	int i;

	prm_dev.suspended = 0;

	for (i = 0; i < prm_dev.irq_setup.nr_regs; i++)
		writel(prm_dev.saved_ena[i], prm_dev.irq_setup.mask + i * 4);
}

static int __devexit omap_prm_remove(struct platform_device *pdev)
{
	return 0;
}

static int __init omap_prm_probe(struct platform_device *pdev)
{
	prm_dev.irq_setup.ack = 0xb2000000 + 0x4a306010;
	prm_dev.irq_setup.mask = 0xb2000000 + 0x4a306018;
	prm_dev.irq_setup.irq = OMAP44XX_IRQ_PRCM;
	prm_dev.irq_setup.nr_regs = 2;

	omap_prcm_irq_init();

	prm_dev.irq_setup.io_irq = omap_prcm_event_to_irq("io");

	return 0;
}

static const struct dev_pm_ops prm_pm_ops = {
	.prepare = omap_prm_prepare,
	.complete = omap_prm_complete,
};

static struct platform_driver prm_driver = {
	.remove		= __exit_p(omap_prm_remove),
	.driver		= {
		.name	= DRIVER_NAME,
		.pm	= &prm_pm_ops,
	},
};

static int __init omap_prm_init(void)
{
	int ret;

	ret = platform_device_register(&prm_dev.pdev);

	if (ret) {
		printk(KERN_ERR "Unable to register PRM device: %d\n", ret);
		return ret;
	}

	ret = platform_driver_probe(&prm_driver, omap_prm_probe);

	if (ret)
		printk(KERN_ERR "PRM driver probe failed: %d\n", ret);

	return ret;
}
subsys_initcall(omap_prm_init);

static void __exit omap_prm_exit(void)
{
	platform_device_unregister(&prm_dev.pdev);
	platform_driver_unregister(&prm_driver);
}
module_exit(omap_prm_exit);

MODULE_ALIAS("platform:"DRIVER_NAME);
MODULE_AUTHOR("Tero Kristo <t-kristo@ti.com>");
MODULE_DESCRIPTION("OMAP PRM driver");
MODULE_LICENSE("GPL");

--=-y255YSwldiZefr07Vx08--
