Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1EKVGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:06:50 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756060Ab1EKVGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:06:47 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 13/16] C6X: add drivers/platform/c6x files
Date: Wed, 11 May 2011 16:14:00 -0400
Message-Id: <1305144843-5058-14-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-13-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
 <1305144843-5058-9-git-send-email-msalter@redhat.com>
 <1305144843-5058-10-git-send-email-msalter@redhat.com>
 <1305144843-5058-11-git-send-email-msalter@redhat.com>
 <1305144843-5058-12-git-send-email-msalter@redhat.com>
 <1305144843-5058-13-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds driver support for miscellaneous drivers for hardware found
on C64x DSP chips but not really part of the CPU core. These could have been
put under arch/c6x/kernel, but that would get cluttered pretty quickly as
new SoC parts are supported.

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 drivers/platform/Kconfig             |    4 +
 drivers/platform/Makefile            |    1 +
 drivers/platform/c6x/Kconfig         |   27 ++
 drivers/platform/c6x/Makefile        |    8 +
 drivers/platform/c6x/irq-c64xplus.c  |  583 ++++++++++++++++++++++++++++++++++
 drivers/platform/c6x/pll-tci648x.c   |  433 +++++++++++++++++++++++++
 drivers/platform/c6x/timer-tci648x.c |  121 +++++++
 drivers/platform/c6x/tsc-c64xplus.c  |   53 +++
 8 files changed, 1230 insertions(+), 0 deletions(-)
 create mode 100644 drivers/platform/c6x/Kconfig
 create mode 100644 drivers/platform/c6x/Makefile
 create mode 100644 drivers/platform/c6x/irq-c64xplus.c
 create mode 100644 drivers/platform/c6x/pll-tci648x.c
 create mode 100644 drivers/platform/c6x/timer-tci648x.c
 create mode 100644 drivers/platform/c6x/tsc-c64xplus.c

diff --git a/drivers/platform/Kconfig b/drivers/platform/Kconfig
index 8390dca..df334ed 100644
--- a/drivers/platform/Kconfig
+++ b/drivers/platform/Kconfig
@@ -1,3 +1,7 @@
 if X86
 source "drivers/platform/x86/Kconfig"
 endif
+
+if TMS320C6X
+source "drivers/platform/c6x/Kconfig"
+endif
diff --git a/drivers/platform/Makefile b/drivers/platform/Makefile
index 782953a..bd9e0e3 100644
--- a/drivers/platform/Makefile
+++ b/drivers/platform/Makefile
@@ -3,3 +3,4 @@
 #
 
 obj-$(CONFIG_X86)		+= x86/
+obj-$(CONFIG_TMS320C6X)		+= c6x/
diff --git a/drivers/platform/c6x/Kconfig b/drivers/platform/c6x/Kconfig
new file mode 100644
index 0000000..a950fb8
--- /dev/null
+++ b/drivers/platform/c6x/Kconfig
@@ -0,0 +1,27 @@
+#
+# C6X Platform Specific Drivers
+#
+
+menuconfig C6X_PLATFORM_DEVICES
+	bool "C6X Platform Specific Device Drivers"
+	default y
+	depends on TMS320C6X
+	---help---
+	  Say Y here to get to see options for device drivers for various
+	  c64x platforms. This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
+if C6X_PLATFORM_DEVICES
+
+config PLL_TCI648X
+	bool "PLL_TCI648X"
+	depends on COMMON_CLKDEV
+
+config TIMER_TCI648X
+	bool "TIMER_TCI648X"
+
+config PIC_C64XPLUS
+	bool "C64X+ Megamodule Interrupt Controller"
+
+endif # C6X_PLATFORM_DEVICES
diff --git a/drivers/platform/c6x/Makefile b/drivers/platform/c6x/Makefile
new file mode 100644
index 0000000..2f9be75
--- /dev/null
+++ b/drivers/platform/c6x/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for drivers/platform/c6x
+#
+
+obj-$(CONFIG_PLL_TCI648X)      += pll-tci648x.o
+obj-$(CONFIG_TMS320C64XPLUS)   += tsc-c64xplus.o
+obj-$(CONFIG_TIMER_TCI648X)    += timer-tci648x.o
+obj-$(CONFIG_PIC_C64XPLUS)     += irq-c64xplus.o
diff --git a/drivers/platform/c6x/irq-c64xplus.c b/drivers/platform/c6x/irq-c64xplus.c
new file mode 100644
index 0000000..4eff863
--- /dev/null
+++ b/drivers/platform/c6x/irq-c64xplus.c
@@ -0,0 +1,583 @@
+/*
+ *  Support for C64x+ Megamodule Interrupt Controller
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/types.h>
+#include <linux/sched.h>
+#include <linux/kernel_stat.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/hardirq.h>
+#include <linux/seq_file.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/io.h>
+#include <linux/hardirq.h>
+
+#include <asm/system.h>
+#include <asm/irq.h>
+#include <asm/traps.h>
+#include <asm/page.h>
+#include <asm/hardware.h>
+
+#define IRQ_UNMAPPED 0xffff
+
+#define NR_MEGAMOD_COMBINERS 4
+
+#ifdef CONFIG_SOC_TMS320C6474
+#define NR_CIC_COMBINERS 2
+#define NR_CIC_OUTPUTS	 16
+#else
+#define NR_CIC_COMBINERS 0
+#endif
+
+#define NR_COMBINERS (NR_MEGAMOD_COMBINERS + NR_CIC_COMBINERS)
+
+struct combiner_handler_info {
+	volatile uint32_t *mevtflag;
+	volatile uint32_t *evtclr;
+	uint16_t irqmap[32];
+};
+
+struct combiner_mask_info {
+	int irq_base;
+	volatile uint32_t *evtmask;
+};
+
+struct c6x_irq_chip {
+	struct irq_chip chip;
+	struct combiner_mask_info *minfo;
+};
+
+static struct combiner_mask_info    megamod_mask_info[NR_MEGAMOD_COMBINERS];
+static struct combiner_handler_info megamod_handler_info[NR_MEGAMOD_COMBINERS];
+
+uint16_t prio_to_irq[NR_SYS_IRQS];
+
+static uint8_t	irq_to_prio[NR_IRQS];
+
+/* The 16 SoC GPIOs can span more than one megamodule */
+#define NR_GPIO_CHIPS 2
+
+static struct c6x_irq_chip direct_chips[(INT15 - INT4) + 1];
+static struct c6x_irq_chip gpio_chips[NR_GPIO_CHIPS];
+static struct c6x_irq_chip *prio_saved_chips[NR_SYS_IRQS];
+
+#if NR_CIC_COMBINERS > 0
+static struct combiner_mask_info    cic_mask_info[NR_CIC_COMBINERS];
+static struct combiner_handler_info cic_handler_info[NR_CIC_COMBINERS];
+
+static uint8_t	cic_output_to_evt[NR_CIC_OUTPUTS];
+static uint8_t	cic_evt_to_output[NR_CIC_IRQS];
+static struct c6x_irq_chip cic_mapped_chips[CIC_MAPLEN - NR_CIC_COMBINERS];
+static struct c6x_irq_chip *cic_saved_chips[CIC_MAPLEN - NR_CIC_COMBINERS];
+#endif
+
+/* lock protecting irq mappings */
+static spinlock_t map_lock;
+
+static void mask_direct(struct irq_data *data)
+{
+	uint16_t prio;
+
+	BUG_ON(data->irq >= NR_IRQS);
+	prio = irq_to_prio[data->irq];
+	BUG_ON(prio >= NR_SYS_IRQS);
+	and_creg(IER, ~(1 << prio));
+}
+
+static void unmask_direct(struct irq_data *data)
+{
+	uint16_t prio;
+
+	BUG_ON(data->irq >= NR_IRQS);
+	prio = irq_to_prio[data->irq];
+	BUG_ON(prio >= NR_SYS_IRQS);
+	or_creg(IER, 1 << prio);
+}
+
+static const char * const direct_chip_names[] = {
+	"direct-4",
+	"direct-5",
+	"direct-6",
+	"direct-7",
+	"direct-8",
+	"direct-9",
+	"direct-10",
+	"direct-11",
+	"direct-12",
+	"direct-13",
+	"direct-14",
+	"direct-15",
+};
+
+#if NR_CIC_COMBINERS > 0
+/*
+ * CIC IRQs mapped directly to megamodule use chip data from the megamodule
+ * combiner since the megamodule combiner will controlling masking. All other
+ * CIC IRQs use CIC combiner chip data.
+ */
+static inline int cic_mapped_irq(uint16_t irq)
+{
+	uint8_t output;
+
+	if (irq < IRQ_CIC_START || irq >= (IRQ_CIC_START + NR_CIC_IRQS))
+		return irq;
+
+	/* the CIC combined IRQs are hardwired */
+	if (irq < (IRQ_CIC_START + NR_CIC_COMBINERS))
+		return CIC_MAPBASE + (irq - IRQ_CIC_START);
+
+	/* the other CIC events may or may not be mapped to megamodule */
+	output = cic_evt_to_output[irq - IRQ_CIC_START];
+	if (output)
+		return CIC_MAPBASE + output;
+
+	return irq;
+}
+#else
+#define cic_mapped_irq(i) (i)
+#endif
+
+#define c6x_irq_to_chip(i) ((struct c6x_irq_chip *)irq_to_desc((i))->chip)
+
+static void mask_combined(struct irq_data *data)
+{
+	struct c6x_irq_chip *chip = (struct c6x_irq_chip *)data->chip;
+	int irq = data->irq;
+
+	irq = cic_mapped_irq(irq);
+	*chip->minfo->evtmask |= (1 << (irq - chip->minfo->irq_base));
+}
+
+static void unmask_combined(struct irq_data *data)
+{
+	struct c6x_irq_chip *chip = (struct c6x_irq_chip *)data->chip;
+	int irq = data->irq;
+
+	irq = cic_mapped_irq(irq);
+	*chip->minfo->evtmask &= ~(1 << (irq - chip->minfo->irq_base));
+}
+
+#define __CHIP(namestr, i, m, u)	\
+	{				\
+		.chip = { .name = namestr #i,	\
+			  .irq_mask = m,	\
+			  .irq_unmask = u,	\
+		},				\
+	}
+
+/* Combiner chips */
+#define MEGAMOD_CHIP(i)	\
+	__CHIP("combiner-", i, mask_combined, unmask_combined)
+
+static struct c6x_irq_chip megamod_chips[] = {
+	MEGAMOD_CHIP(0),
+	MEGAMOD_CHIP(1),
+	MEGAMOD_CHIP(2),
+	MEGAMOD_CHIP(3),
+};
+
+#if NR_CIC_COMBINERS > 0
+
+#define CIC_CHIP(i)	\
+	__CHIP("cicombiner-", i, mask_combined, unmask_combined)
+
+static struct c6x_irq_chip cic_chips[] = {
+	CIC_CHIP(0),
+#if NR_CIC_COMBINERS > 1
+	CIC_CHIP(1),
+#endif
+#if NR_CIC_COMBINERS > 2
+	CIC_CHIP(2),
+#endif
+#if NR_CIC_COMBINERS > 3
+	CIC_CHIP(3),
+#endif
+};
+#endif /* NR_CIC_COMBINERS > 0 */
+
+/*
+ * When handling IRQs through the CIC, ack after the handler runs.
+ * For IRQs through the megamodule, ack before handler runs.
+ */
+#if NR_CIC_COMBINERS
+#define PRE_ACK (irq < IRQ_CIC_START || \
+		 irq >= (IRQ_CIC_START + NR_CIC_COMBINERS))
+#else
+#define PRE_ACK 1
+#endif
+
+static void handle_combined_irq(unsigned int irq, struct irq_desc *desc)
+{
+	struct combiner_handler_info *info = irq_desc_get_handler_data(desc);
+	unsigned long events;
+	int n;
+
+	while ((events = *info->mevtflag) != 0) {
+		n = __ffs(events);
+		irq = info->irqmap[n]; /* irq to handle */
+
+		if (PRE_ACK)
+			*info->evtclr = (1 << n);
+
+		generic_handle_irq(irq);
+
+		if (!PRE_ACK)
+			*info->evtclr = (1 << n);
+	}
+}
+
+/*
+ * Setup megamodule event mappings.
+ */
+static inline void __irq_megamod_map(unsigned int src, unsigned int dst)
+{
+	uint32_t val;
+	int offset, nr_srcs;
+
+	nr_srcs = (NR_MEGAMOD_COMBINERS * 32);
+
+	BUG_ON(dst < INT4 || dst > INT15);
+	BUG_ON(src >= nr_srcs);
+
+	/* each mux register controls four outputs */
+	offset = (dst & 3) << 3;
+	val = IC_INTMUX[dst >> 2];
+	val &= ~((nr_srcs - 1) << offset);
+	val |= ((src & (nr_srcs - 1)) << offset);
+	IC_INTMUX[dst >> 2] = val;
+}
+
+/*
+ * Map a C64x+ megamodule event to a CPU core priority interrupt.
+ */
+void irq_map(unsigned int irq_src, unsigned int prio)
+{
+	struct irq_desc *desc;
+	struct c6x_irq_chip *chip, *direct;
+	unsigned long flags;
+	unsigned int prio_idx = prio - INT4;
+
+	if (prio < INT4 || prio > INT15)
+		return;
+
+	/* only map megamodule event sources here */
+	if (irq_src >= (NR_MEGAMOD_COMBINERS * 32))
+		return;
+
+	spin_lock_irqsave(&map_lock, flags);
+
+	/* make sure this IRQ is not mapped to another core IRQ */
+	if (irq_to_prio[irq_src])
+		goto out_unlock;
+
+	/* make sure no other IRQ is mapped to the requested priority */
+	if (prio_to_irq[prio] != IRQ_UNMAPPED)
+		goto out_unlock;
+
+#if NR_CIC_COMBINERS > 0
+	/* handle mapping for IRQs coming from CIC */
+	if (irq_src >= CIC_MAPBASE &&
+	    irq_src < (CIC_MAPBASE + CIC_MAPLEN)) {
+		uint8_t cic_src, output = (irq_src - CIC_MAPBASE);
+		uint16_t cic_irq;
+		struct irq_data *data;
+
+		if (output >= NR_CIC_COMBINERS) {
+			cic_src = cic_output_to_evt[output];
+			if (cic_src < NR_CIC_COMBINERS)
+				goto out_unlock;
+			cic_irq = IRQ_CIC_START + cic_src;
+		} else
+			cic_irq = IRQ_CIC_START + output;
+
+		desc = irq_to_desc(cic_irq);
+		data = &desc->irq_data;
+		chip = (struct c6x_irq_chip *)data->chip;
+
+		/* mask combined CIC irq in megamodule combiner */
+		if (output < NR_CIC_COMBINERS)
+			mask_combined(data);
+
+		direct = &direct_chips[prio_idx];
+		*direct = *chip;
+		direct->chip.name = direct_chip_names[prio_idx];
+		direct->chip.irq_mask = mask_direct;
+		direct->chip.irq_unmask = unmask_direct;
+
+		prio_saved_chips[prio] = chip;
+		data->chip = (struct irq_chip *)direct;
+		irq_to_prio[cic_irq] = prio;
+		prio_to_irq[prio] = cic_irq;
+
+		__irq_megamod_map(irq_src, prio);
+
+		if (output < NR_CIC_COMBINERS)
+			irq_set_chained_handler(irq_src, handle_combined_irq);
+
+		goto out_unlock;
+	}
+#endif
+	desc = irq_to_desc(irq_src);
+	chip = (struct c6x_irq_chip *)desc->irq_data.chip;
+
+	direct = &direct_chips[prio_idx];
+	if (irq_src < NR_MEGAMOD_COMBINERS)
+		memset(&direct->chip, 0, sizeof(direct->chip));
+	else
+		*direct = *(struct c6x_irq_chip *)chip;
+	direct->chip.name = direct_chip_names[prio_idx];
+	direct->chip.irq_mask = mask_direct;
+	direct->chip.irq_unmask = unmask_direct;
+
+	prio_saved_chips[prio] = chip;
+	irq_set_chip(irq_src, (struct irq_chip *)direct);
+	irq_to_prio[irq_src] = prio;
+	prio_to_irq[prio] = irq_src;
+
+	__irq_megamod_map(irq_src, prio);
+
+	if (irq_src < NR_MEGAMOD_COMBINERS) {
+		irq_set_handler_data(irq_src, &megamod_handler_info[irq_src]);
+		irq_set_chained_handler(irq_src, handle_combined_irq);
+	}
+
+out_unlock:
+	spin_unlock_irqrestore(&map_lock, flags);
+}
+EXPORT_SYMBOL(irq_map);
+
+
+#if NR_CIC_COMBINERS > 0
+/*
+ * Setup CIC event mappings on given core.
+ */
+static inline void __irq_cic_map(int core, unsigned int src, unsigned int dst)
+{
+	uint32_t val;
+	int offset, nr_srcs;
+
+	nr_srcs = (NR_CIC_COMBINERS * 32);
+
+	/* output0 and output1 are hardwired */
+	BUG_ON(dst < 2 || dst > 15);
+	BUG_ON(src >= nr_srcs);
+
+	offset = (dst & 3) << 3;
+	val = CIC_MUX(core)[dst >> 2];
+	val &= ~(0x7f << offset);
+	val |= ((src & 0x7f) << offset);
+	CIC_MUX(core)[dst >> 2] = val;
+}
+
+/*
+ * Map a C64x+ CIC IRQ to a megamodule event
+ *
+ * Do nothing for CIC combined IRQs. They are always mapped.
+ */
+void irq_cic_map(unsigned int irq_src, unsigned int irq_dst)
+{
+	struct irq_desc *desc;
+	struct c6x_irq_chip *chip, *mmchip;
+	unsigned long flags;
+	int src, output;
+	struct combiner_handler_info *info;
+	unsigned int idx = irq_dst - (CIC_MAPBASE + NR_CIC_COMBINERS);
+
+	if (irq_dst < (CIC_MAPBASE + NR_CIC_COMBINERS) ||
+	    irq_dst >= (CIC_MAPBASE + CIC_MAPLEN))
+		return;
+
+	/* only map CIC event sources */
+	if (irq_src < (IRQ_CIC_START + NR_CIC_COMBINERS) ||
+	    irq_src >= (IRQ_CIC_START + NR_CIC_IRQS))
+		return;
+
+	src = irq_src - IRQ_CIC_START;
+	output = irq_dst - CIC_MAPBASE;
+
+	spin_lock_irqsave(&map_lock, flags);
+
+	/* make sure this IRQ is not already mapped */
+	if (cic_evt_to_output[src])
+		goto out_unlock;
+
+	/* make sure the requested output is not in use */
+	if (cic_output_to_evt[output])
+		goto out_unlock;
+
+	/* record the mapping */
+	cic_evt_to_output[src] = output;
+	cic_output_to_evt[output] = src;
+
+	mmchip = &megamod_chips[(CIC_MAPBASE + output) / 32];
+	info = &megamod_handler_info[(CIC_MAPBASE + output) / 32];
+	info->irqmap[(CIC_MAPBASE + output) & 31] = irq_src;
+
+	desc = irq_to_desc(irq_src);
+	cic_saved_chips[idx] = (struct c6x_irq_chip *)desc->irq_data.chip;
+
+	chip = &cic_mapped_chips[idx];
+	*chip = *(struct c6x_irq_chip *)desc->irq_data.chip;
+	chip->chip.name = mmchip->chip.name;
+	chip->minfo = mmchip->minfo;
+
+	desc->irq_data.chip = (struct irq_chip *)chip;
+
+	__irq_cic_map(get_coreid(), src, output);
+out_unlock:
+	spin_unlock_irqrestore(&map_lock, flags);
+}
+EXPORT_SYMBOL(irq_cic_map);
+
+/*
+ * Map a CIC source to a give CIC output event for a given core or TPCC
+ */
+void cic_raw_map(unsigned int src, unsigned int dst, int core)
+{
+	__irq_cic_map(core, src, dst);
+}
+EXPORT_SYMBOL(cic_raw_map);
+
+#endif  /* NR_CIC_COMBINERS > 0 */
+
+void __init init_pic_c64xplus(void)
+{
+	int i, j, idx;
+	struct irq_desc *desc;
+	struct c6x_irq_chip *c6x_chip, *last_chip;
+	struct irq_chip *chip;
+	struct combiner_mask_info *minfo;
+	struct combiner_handler_info *hinfo;
+#if NR_CIC_COMBINERS > 0
+	unsigned core = get_coreid();
+#endif
+
+	spin_lock_init(&map_lock);
+
+	/* initialize chip info */
+	minfo = &megamod_mask_info[0];
+	hinfo = &megamod_handler_info[0];
+	for (i = 0; i < NR_MEGAMOD_COMBINERS; i++) {
+		minfo->irq_base = IRQ_EVT0 + (i * 32);
+		minfo->evtmask  = &IC_EVTMASK[i];
+		hinfo->mevtflag = &IC_MEVTFLAG[i];
+		hinfo->evtclr   = &IC_EVTCLR[i];
+		for (j = 0; j < 32; j++)
+			hinfo->irqmap[j] = minfo->irq_base + j;
+		minfo++;
+		hinfo++;
+	}
+#if NR_CIC_COMBINERS > 0
+	minfo = &cic_mask_info[0];
+	hinfo = &cic_handler_info[0];
+	for (i = 0; i < NR_CIC_COMBINERS; i++) {
+		minfo->irq_base = IRQ_CIC_START + (i * 32);
+		minfo->evtmask  = &CIC_EVTMASK(core)[i];
+		hinfo->mevtflag = &CIC_MEVTFLAG(core)[i];
+		hinfo->evtclr   = &CIC_EVTCLR(core)[i];
+		for (j = 0; j < 32; j++)
+			hinfo->irqmap[j] = minfo->irq_base + j;
+		minfo++;
+		hinfo++;
+	}
+#endif
+
+	/* initialize mapping arrays */
+	for (i = 0; i < NR_SYS_IRQS; i++)
+		prio_to_irq[i] = IRQ_UNMAPPED;
+	memset(&irq_to_prio[0], 0, sizeof(irq_to_prio));
+#if NR_CIC_COMBINERS > 0
+	memset(&cic_output_to_evt[0], 0, sizeof(cic_output_to_evt));
+	memset(&cic_evt_to_output[0], 0, sizeof(cic_evt_to_output));
+#endif
+
+	/* initialize megamodule combined IRQs */
+	for (i = 0; i < NR_MEGAMOD_COMBINERS; i++) {
+		desc = irq_to_desc(i);
+
+		IC_EVTMASK[i] = ~0;	/* mask all events */
+		IC_EVTCLR[i] = ~0;	/* clear all events */
+
+		irq_set_chip_and_handler(i, &dummy_irq_chip, handle_bad_irq);
+
+		megamod_chips[i].minfo = &megamod_mask_info[i];
+		irq_set_handler_data(i, &megamod_handler_info[i]);
+	}
+
+	/* initialize individual megamodule IRQs */
+	for (i = NR_MEGAMOD_COMBINERS; i < (NR_MEGAMOD_COMBINERS * 32); i++) {
+		chip = (struct irq_chip *)&megamod_chips[i / 32];
+		irq_set_chip_and_handler(i, chip, handle_level_irq);
+	}
+
+#if NR_CIC_COMBINERS > 0
+	/* megamodule IRQs coming from CIC cannot be used directly */
+	for (i = CIC_MAPBASE; i < (CIC_MAPBASE + CIC_MAPLEN); i++)
+		irq_set_chip_and_handler(i, &dummy_irq_chip, handle_bad_irq);
+
+	/* CIC combined IRQs are hardwired to CIC_MAPBASE in megamodule */
+	for (i = 0; i < NR_CIC_COMBINERS; i++) {
+		int irq = IRQ_CIC_START + i;
+
+		CIC_EVTMASK(core)[i] = ~0;	/* mask all events */
+		CIC_EVTCLR(core)[i] = ~0;	/* clear all events */
+
+		cic_chips[i].minfo = &cic_mask_info[i];
+
+		/* chip info for megamodule combiner we are wired through */
+		chip = (struct irq_chip *)&megamod_chips[(CIC_MAPBASE + i)/32];
+		hinfo = &megamod_handler_info[(CIC_MAPBASE + i) / 32];
+
+		/* redirect megamodule irq to right place */
+		hinfo->irqmap[(CIC_MAPBASE + i) & 31] = irq;
+
+		irq_set_chip(irq, chip);
+		irq_set_handler_data(irq, &cic_handler_info[i]);
+		irq_set_chained_handler(irq, handle_combined_irq);
+	}
+
+	/* initialize individual CIC IRQs */
+	for (i = NR_CIC_COMBINERS; i < (NR_CIC_COMBINERS * 32); i++) {
+		int irq = IRQ_CIC_START + i;
+
+		irq_set_chip(irq, (struct irq_chip *)&cic_chips[i / 32]);
+		irq_set_handler(irq, handle_level_irq);
+	}
+
+	/*
+	 * clear again megamodule combined IRQs because spurious CIC interrupts
+	 * may have occur after the CIC initialization.
+	 */
+	for (i = 0; i < NR_MEGAMOD_COMBINERS; i++)
+		IC_EVTCLR[i] = ~0;	/* clear all events */
+#endif
+
+	/*
+	 * GPIO interrupts need separate copies of megamodule chips
+	 * so gpio code can add edge triggering support.
+	 */
+	last_chip = NULL;
+	idx = 0;
+	for (i = IRQ_GPIO_START; i <= IRQ_GPIO15; i++) {
+		c6x_chip = (struct c6x_irq_chip *)irq_to_desc(i)->irq_data.chip;
+		if (c6x_chip != last_chip) {
+			last_chip = c6x_chip;
+			gpio_chips[idx++] = *c6x_chip;
+		}
+		irq_to_desc(i)->irq_data.chip = &gpio_chips[idx - 1].chip;
+	}
+
+	/* map megamodule combined IRQs to low-priority core IRQs */
+	irq_map(IRQ_EVT0, INT12);
+	irq_map(IRQ_EVT1, INT13);
+	irq_map(IRQ_EVT2, INT14);
+	irq_map(IRQ_EVT3, INT15);
+}
diff --git a/drivers/platform/c6x/pll-tci648x.c b/drivers/platform/c6x/pll-tci648x.c
new file mode 100644
index 0000000..ae15659
--- /dev/null
+++ b/drivers/platform/c6x/pll-tci648x.c
@@ -0,0 +1,433 @@
+/*
+ * Clock and PLL control for TCI648x devices
+ *
+ * Copyright (C) 2010 Texas Instruments.
+ * Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ * Copied heavily from arm/mach-davinci/clock.c, so:
+ *
+ * Copyright (C) 2006-2007 Texas Instruments.
+ * Copyright (C) 2008-2009 Deep Root Systems, LLC
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/clk.h>
+#include <linux/err.h>
+#include <linux/mutex.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <asm/clock.h>
+
+static LIST_HEAD(clocks);
+static DEFINE_MUTEX(clocks_mutex);
+static DEFINE_SPINLOCK(clockfw_lock);
+
+static void __clk_enable(struct clk *clk)
+{
+	if (clk->parent)
+		__clk_enable(clk->parent);
+	clk->usecount++;
+}
+
+static void __clk_disable(struct clk *clk)
+{
+	if (WARN_ON(clk->usecount == 0))
+		return;
+	--clk->usecount;
+
+	if (clk->parent)
+		__clk_disable(clk->parent);
+}
+
+int clk_enable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	__clk_enable(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_enable);
+
+void clk_disable(struct clk *clk)
+{
+	unsigned long flags;
+
+	if (clk == NULL || IS_ERR(clk))
+		return;
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	__clk_disable(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+}
+EXPORT_SYMBOL(clk_disable);
+
+unsigned long clk_get_rate(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_get_rate);
+
+long clk_round_rate(struct clk *clk, unsigned long rate)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	if (clk->round_rate)
+		return clk->round_rate(clk, rate);
+
+	return clk->rate;
+}
+EXPORT_SYMBOL(clk_round_rate);
+
+/* Propagate rate to children */
+static void propagate_rate(struct clk *root)
+{
+	struct clk *clk;
+
+	list_for_each_entry(clk, &root->children, childnode) {
+		if (clk->recalc)
+			clk->rate = clk->recalc(clk);
+		propagate_rate(clk);
+	}
+}
+
+int clk_set_rate(struct clk *clk, unsigned long rate)
+{
+	unsigned long flags;
+	int ret = -EINVAL;
+
+	if (clk == NULL || IS_ERR(clk))
+		return ret;
+
+	if (clk->set_rate)
+		ret = clk->set_rate(clk, rate);
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (ret == 0) {
+		if (clk->recalc)
+			clk->rate = clk->recalc(clk);
+		propagate_rate(clk);
+	}
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL(clk_set_rate);
+
+int clk_set_parent(struct clk *clk, struct clk *parent)
+{
+	unsigned long flags;
+
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	/* Cannot change parent on enabled clock */
+	if (WARN_ON(clk->usecount))
+		return -EINVAL;
+
+	mutex_lock(&clocks_mutex);
+	clk->parent = parent;
+	list_del_init(&clk->childnode);
+	list_add(&clk->childnode, &clk->parent->children);
+	mutex_unlock(&clocks_mutex);
+
+	spin_lock_irqsave(&clockfw_lock, flags);
+	if (clk->recalc)
+		clk->rate = clk->recalc(clk);
+	propagate_rate(clk);
+	spin_unlock_irqrestore(&clockfw_lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_set_parent);
+
+int clk_register(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return -EINVAL;
+
+	if (WARN(clk->parent && !clk->parent->rate,
+		 "CLK: %s parent %s has no rate!\n",
+		 clk->name, clk->parent->name))
+		return -EINVAL;
+
+	mutex_lock(&clocks_mutex);
+	list_add_tail(&clk->node, &clocks);
+	if (clk->parent)
+		list_add_tail(&clk->childnode, &clk->parent->children);
+	mutex_unlock(&clocks_mutex);
+
+	/* If rate is already set, use it */
+	if (clk->rate)
+		return 0;
+
+	/* Else, see if there is a way to calculate it */
+	if (clk->recalc)
+		clk->rate = clk->recalc(clk);
+
+	/* Otherwise, default to parent rate */
+	else if (clk->parent)
+		clk->rate = clk->parent->rate;
+
+	return 0;
+}
+EXPORT_SYMBOL(clk_register);
+
+void clk_unregister(struct clk *clk)
+{
+	if (clk == NULL || IS_ERR(clk))
+		return;
+
+	mutex_lock(&clocks_mutex);
+	list_del(&clk->node);
+	list_del(&clk->childnode);
+	mutex_unlock(&clocks_mutex);
+}
+EXPORT_SYMBOL(clk_unregister);
+
+static unsigned long clk_sysclk_recalc(struct clk *clk)
+{
+	u32 v, plldiv = 0;
+	struct pll_data *pll;
+	unsigned long rate = clk->rate;
+
+	if (WARN_ON(!clk->parent))
+		return rate;
+
+	rate = clk->parent->rate;
+
+	/* the parent must be a PLL */
+	if (WARN_ON(!clk->parent->pll_data))
+		return rate;
+
+	pll = clk->parent->pll_data;
+
+	/* If pre-PLL, source clock is before the multiplier and divider(s) */
+	if (clk->flags & PRE_PLL)
+		rate = pll->input_rate;
+
+	if (!clk->div) {
+		pr_debug("%s: (no divider) rate = %lu KHz\n",
+			 clk->name, rate / 1000);
+		return rate;
+	}
+
+	if (clk->flags & FIXED_DIV_PLL) {
+		rate /= clk->div;
+		pr_debug("%s: (fixed divide by %d) rate = %lu KHz\n",
+			 clk->name, clk->div, rate / 1000);
+		return rate;
+	}
+
+	v = __raw_readl(pll->base + clk->div);
+	if (v & PLLDIV_EN)
+		plldiv = (v & PLLDIV_RATIO_MASK) + 1;
+
+	if (plldiv == 0)
+		plldiv = 1;
+
+	rate /= plldiv;
+
+	pr_debug("%s: (divide by %d) rate = %lu KHz\n",
+		 clk->name, plldiv, rate / 1000);
+
+	return rate;
+}
+
+static unsigned long clk_leafclk_recalc(struct clk *clk)
+{
+	if (WARN_ON(!clk->parent))
+		return clk->rate;
+
+	pr_debug("%s: (parent %s) rate = %lu KHz\n",
+		 clk->name, clk->parent->name,	clk->parent->rate / 1000);
+
+	return clk->parent->rate;
+}
+
+static unsigned long clk_pllclk_recalc(struct clk *clk)
+{
+	u32 ctrl, mult = 1, prediv = 1;
+	u8 bypass;
+	struct pll_data *pll = clk->pll_data;
+	unsigned long rate = clk->rate;
+
+	if (clk->flags & FIXED_RATE_PLL)
+		return rate;
+
+	pll->base = ioremap(pll->phys_base, 1024);
+	ctrl = __raw_readl(pll->base + PLLCTL);
+	rate = pll->input_rate = clk->parent->rate;
+
+	if (ctrl & PLLCTL_PLLEN) {
+		bypass = 0;
+		mult = __raw_readl(pll->base + PLLM);
+		mult = (mult & PLLM_PLLM_MASK) + 1;
+	} else
+		bypass = 1;
+
+	if (pll->flags & PLL_HAS_PREDIV) {
+		prediv = __raw_readl(pll->base + PREDIV);
+		if (prediv & PLLDIV_EN)
+			prediv = (prediv & PLLDIV_RATIO_MASK) + 1;
+		else
+			prediv = 1;
+	}
+
+	if (!bypass) {
+		rate /= prediv;
+		rate *= mult;
+	}
+
+	pr_debug("PLL%d: input = %lu MHz [ ",
+		 pll->num, clk->parent->rate / 1000000);
+	if (bypass)
+		pr_debug("bypass ");
+	if (prediv > 1)
+		pr_debug("/ %d ", prediv);
+	if (mult > 1)
+		pr_debug("* %d ", mult);
+	pr_debug("] --> %lu MHz output.\n", rate / 1000000);
+
+	return rate;
+}
+
+
+int __init c6x_clk_init(struct clk_lookup *clocks)
+{
+	struct clk_lookup *c;
+	struct clk *clk;
+	size_t num_clocks = 0;
+
+	for (c = clocks; c->clk; c++) {
+		clk = c->clk;
+
+		INIT_LIST_HEAD(&clk->node);
+		INIT_LIST_HEAD(&clk->children);
+		INIT_LIST_HEAD(&clk->childnode);
+
+		if (!clk->recalc) {
+
+			/* Check if clock is a PLL */
+			if (clk->pll_data)
+				clk->recalc = clk_pllclk_recalc;
+
+			/* Else, if it is a PLL-derived clock */
+			else if (clk->flags & CLK_PLL)
+				clk->recalc = clk_sysclk_recalc;
+
+			/* Otherwise, it is a leaf clock (PSC clock) */
+			else if (clk->parent)
+				clk->recalc = clk_leafclk_recalc;
+		}
+
+		if (clk->recalc)
+			clk->rate = clk->recalc(clk);
+
+		clk_register(clk);
+		num_clocks++;
+
+		/* Turn on clocks that Linux doesn't otherwise manage */
+		if (clk->flags & ALWAYS_ENABLED)
+			clk_enable(clk);
+	}
+
+	clkdev_add_table(clocks, num_clocks);
+
+	return 0;
+}
+
+#ifdef CONFIG_DEBUG_FS
+
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+#define CLKNAME_MAX	10		/* longest clock name */
+#define NEST_DELTA	2
+#define NEST_MAX	4
+
+static void
+dump_clock(struct seq_file *s, unsigned nest, struct clk *parent)
+{
+	char		*state;
+	char		buf[CLKNAME_MAX + NEST_DELTA * NEST_MAX];
+	struct clk	*clk;
+	unsigned	i;
+
+	if (parent->flags & CLK_PLL)
+		state = "pll";
+	else
+		state = "";
+
+	/* <nest spaces> name <pad to end> */
+	memset(buf, ' ', sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = 0;
+	i = strlen(parent->name);
+	memcpy(buf + nest, parent->name,
+	       min(i, (unsigned)(sizeof(buf) - 1 - nest)));
+
+	seq_printf(s, "%s users=%2d %-3s %9ld Hz\n",
+		   buf, parent->usecount, state, clk_get_rate(parent));
+	/* REVISIT show device associations too */
+
+	/* cost is now small, but not linear... */
+	list_for_each_entry(clk, &parent->children, childnode) {
+		dump_clock(s, nest + NEST_DELTA, clk);
+	}
+}
+
+static int c6x_ck_show(struct seq_file *m, void *v)
+{
+	struct clk *clk;
+
+	/*
+	 * Show clock tree; We trust nonzero usecounts equate to PSC enables...
+	 */
+	mutex_lock(&clocks_mutex);
+	list_for_each_entry(clk, &clocks, node)
+		if (!clk->parent)
+			dump_clock(m, 0, clk);
+	mutex_unlock(&clocks_mutex);
+
+	return 0;
+}
+
+static int c6x_ck_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, c6x_ck_show, NULL);
+}
+
+static const struct file_operations c6x_ck_operations = {
+	.open		= c6x_ck_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int __init c6x_clk_debugfs_init(void)
+{
+	debugfs_create_file("c6x_clocks", S_IFREG | S_IRUGO, NULL, NULL,
+			    &c6x_ck_operations);
+
+	return 0;
+}
+device_initcall(c6x_clk_debugfs_init);
+#endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/platform/c6x/timer-tci648x.c b/drivers/platform/c6x/timer-tci648x.c
new file mode 100644
index 0000000..79cda27
--- /dev/null
+++ b/drivers/platform/c6x/timer-tci648x.c
@@ -0,0 +1,121 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Contributed by: Mark Salter (msalter@redhat.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/clockchips.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
+#include <linux/smp.h>
+#include <linux/io.h>
+#include <linux/bug.h>
+
+#include <asm/irq.h>
+#include <asm/timer.h>
+#include <asm/system.h>
+
+#include <mach/board.h>
+
+#ifdef CONFIG_GENERIC_CLOCKEVENTS
+
+static int next_event(unsigned long delta,
+		      struct clock_event_device *evt)
+{
+	u32 timer_CNTLO = TIMER_CNTLO_REG(LINUX_TIMER_SRC);
+	u32 timer_PRDLO = TIMER_PRDLO_REG(LINUX_TIMER_SRC);
+	u32 timer_TCR	= TIMER_TCR_REG(LINUX_TIMER_SRC);
+
+	TIMER_REG(timer_TCR)  &= ~TIMER_B_TCR_ENAMODELO_MASK;
+	TIMER_REG(timer_PRDLO) = delta - 1;
+	TIMER_REG(timer_CNTLO) = 0;
+	TIMER_REG(timer_TCR) |= TIMER_B_TCR_ENAMODELO_ONCE;
+
+	return 0;
+}
+
+static void set_clock_mode(enum clock_event_mode mode,
+			   struct clock_event_device *evt)
+{
+}
+
+static void event_handler(struct clock_event_device *dev)
+{
+}
+
+static struct clock_event_device t64_clockevent_device;
+
+static irqreturn_t timer_interrupt(int irq, void *dev_id)
+{
+	struct clock_event_device *cd = &t64_clockevent_device;
+
+	cd->event_handler(cd);
+
+	return IRQ_HANDLED;
+}
+
+int __init c6x_arch_init_clockevents(void)
+{
+	struct clock_event_device *cd = &t64_clockevent_device;
+	u64 temp;
+	u32 shift, timer_TCR, timer_TGCR;
+	u32 timer_PRDLO, timer_CNTLO, timer_EMUMGTCLKSPD;
+
+	timer_TCR	   = TIMER_TCR_REG(LINUX_TIMER_SRC);
+	timer_TGCR	   = TIMER_TGCR_REG(LINUX_TIMER_SRC);
+	timer_CNTLO	   = TIMER_CNTLO_REG(LINUX_TIMER_SRC);
+	timer_PRDLO	   = TIMER_PRDLO_REG(LINUX_TIMER_SRC);
+	timer_EMUMGTCLKSPD = TIMER_EMUMGTCLKSPD_REG(LINUX_TIMER_SRC);
+
+	/* disable timer, reset count */
+	TIMER_REG(timer_TCR)  &= ~TIMER_B_TCR_ENAMODELO_MASK;
+	TIMER_REG(timer_PRDLO) = 0;
+
+	/* use internal clock and 1 cycle pulse width */
+	TIMER_REG(timer_TCR)  &= ~(TIMER_B_TCR_CLKSRCLO | TIMER_B_TCR_PWIDLO_MASK);
+
+	/* dual 32-bit unchained mode */
+	TIMER_REG(timer_TGCR) &= ~TIMER_B_TGCR_TIMMODE_MASK;
+	TIMER_REG(timer_TGCR) |= (TIMER_B_TGCR_TIMLORS | TIMER_B_TGCR_TIMMODE_UD32);
+
+	cd->irq		= LINUX_TIMER_IRQ;
+	cd->name	= "TIMER64_EVT32_TIMER";
+	cd->features	= CLOCK_EVT_FEAT_ONESHOT;
+
+	/* Calculate the min / max delta */
+	/* Find a shift value */
+	for (shift = 32; shift > 0; shift--) {
+		temp = (u64)(c6x_core_freq / TIMER_DIVISOR(LINUX_TIMER_SRC));
+		temp <<=  shift;
+
+		do_div(temp, NSEC_PER_SEC);
+		if ((temp >> 32) == 0)
+			break;
+	}
+	cd->shift = shift;
+	cd->mult = (u32) temp;
+
+	cd->max_delta_ns	= clockevent_delta2ns(0x7fffffff, cd);
+	cd->min_delta_ns	= clockevent_delta2ns(250, cd);
+
+	cd->rating		= 200;
+	cd->set_mode		= set_clock_mode;
+	cd->event_handler	= event_handler;
+	cd->set_next_event	= next_event;
+	cd->cpumask		= cpumask_of(smp_processor_id());
+
+	clockevents_register_device(cd);
+
+	/* Set handler */
+	request_irq(cd->irq, timer_interrupt, IRQF_DISABLED | IRQF_TIMER,
+		    "timer", NULL);
+
+	return 0;
+}
+
+#endif /* CONFIG_GENERIC_CLOCKEVENTS */
+
diff --git a/drivers/platform/c6x/tsc-c64xplus.c b/drivers/platform/c6x/tsc-c64xplus.c
new file mode 100644
index 0000000..437bf25
--- /dev/null
+++ b/drivers/platform/c6x/tsc-c64xplus.c
@@ -0,0 +1,53 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Contributed by: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/clocksource.h>
+#include <asm/timer.h>
+
+
+#ifdef CONFIG_GENERIC_TIME
+static cycle_t tsc_read(struct clocksource *cs)
+{
+	return get_cycles();
+}
+
+static struct clocksource clocksource_tsc = {
+	.name		= "TSC64",
+	.rating		= 300,
+	.read		= tsc_read,
+	.mask		= CLOCKSOURCE_MASK(64),
+	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+};
+
+int __init c6x_arch_init_clocksource(void)
+{
+	struct clocksource *cs = &clocksource_tsc;
+	u64 temp;
+	u32 shift;
+
+	/* Find a shift value */
+	for (shift = 32; shift > 0; shift--) {
+		temp = (u64) NSEC_PER_SEC << shift;
+		do_div(temp, c6x_core_freq);
+		if ((temp >> 32) == 0)
+			break;
+	}
+	cs->shift = shift;
+	cs->mult = (u32) temp;
+
+	/* write anything into TSCL to enable counting */
+	set_creg(TSCL, 0);
+
+	clocksource_register(cs);
+
+	return 0;
+}
+#endif /* CONFIG_GENERIC_TIME */
+
-- 
1.6.2.5

