Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1EAVLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 17:11:14 -0400
Received: from smtp-out.google.com ([216.239.44.51]:3554 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab1EAVKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 17:10:46 -0400
From: Colin Cross <ccross@android.com>
To: lakml <linux-arm-kernel@lists.infradead.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Cc: Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: tegra: irq: Move legacy_irq.c into irq.c
Date: Sun,  1 May 2011 14:10:12 -0700
Message-Id: <1304284213-11950-4-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304284213-11950-1-git-send-email-ccross@android.com>
References: <1304284213-11950-1-git-send-email-ccross@android.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that irq.c is just an interface layer between the gic
and legacy_irq.c, move the contents of legacy_irq.c into
irq.c.

Signed-off-by: Colin Cross <ccross@android.com>
---
 arch/arm/mach-tegra/Makefile                  |    2 +-
 arch/arm/mach-tegra/include/mach/legacy_irq.h |   32 ------
 arch/arm/mach-tegra/irq.c                     |   83 +++++++++++++--
 arch/arm/mach-tegra/legacy_irq.c              |  138 -------------------------
 4 files changed, 72 insertions(+), 183 deletions(-)
 delete mode 100644 arch/arm/mach-tegra/include/mach/legacy_irq.h
 delete mode 100644 arch/arm/mach-tegra/legacy_irq.c

diff --git a/arch/arm/mach-tegra/Makefile b/arch/arm/mach-tegra/Makefile
index 1afe050..823c703 100644
--- a/arch/arm/mach-tegra/Makefile
+++ b/arch/arm/mach-tegra/Makefile
@@ -1,7 +1,7 @@
 obj-y                                   += common.o
 obj-y                                   += devices.o
 obj-y                                   += io.o
-obj-y                                   += irq.o legacy_irq.o
+obj-y                                   += irq.o
 obj-y                                   += clock.o
 obj-y                                   += timer.o
 obj-y                                   += gpio.o
diff --git a/arch/arm/mach-tegra/include/mach/legacy_irq.h b/arch/arm/mach-tegra/include/mach/legacy_irq.h
deleted file mode 100644
index 4c1f535..0000000
--- a/arch/arm/mach-tegra/include/mach/legacy_irq.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * arch/arm/mach-tegra/include/mach/legacy_irq.h
- *
- * Copyright (C) 2010 Google, Inc.
- * Author: Colin Cross <ccross@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#ifndef _ARCH_ARM_MACH_TEGRA_LEGARY_IRQ_H
-#define _ARCH_ARM_MACH_TEGRA_LEGARY_IRQ_H
-
-void tegra_legacy_mask_irq(unsigned int irq);
-void tegra_legacy_unmask_irq(unsigned int irq);
-void tegra_legacy_select_fiq(unsigned int irq, bool fiq);
-void tegra_legacy_force_irq_set(unsigned int irq);
-void tegra_legacy_force_irq_clr(unsigned int irq);
-int tegra_legacy_force_irq_status(unsigned int irq);
-void tegra_legacy_select_fiq(unsigned int irq, bool fiq);
-unsigned long tegra_legacy_vfiq(int nr);
-unsigned long tegra_legacy_class(int nr);
-void tegra_init_legacy_irq(void);
-
-#endif
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 4fa7a37..1883203 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -18,8 +18,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/delay.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
@@ -27,40 +25,101 @@
 #include <asm/hardware/gic.h>
 
 #include <mach/iomap.h>
-#include <mach/legacy_irq.h>
 
 #include "board.h"
 
+#define INT_SYS_NR	(INT_GPIO_BASE - INT_PRI_BASE)
+#define INT_SYS_SZ	(INT_SEC_BASE - INT_PRI_BASE)
+#define PPI_NR		((INT_SYS_NR+INT_SYS_SZ-1)/INT_SYS_SZ)
+
+#define ICTLR_CPU_IEP_VFIQ	0x08
+#define ICTLR_CPU_IEP_FIR	0x14
+#define ICTLR_CPU_IEP_FIR_SET	0x18
+#define ICTLR_CPU_IEP_FIR_CLR	0x1c
+
+#define ICTLR_CPU_IER		0x20
+#define ICTLR_CPU_IER_SET	0x24
+#define ICTLR_CPU_IER_CLR	0x28
+#define ICTLR_CPU_IEP_CLASS	0x2C
+
+#define ICTLR_COP_IER		0x30
+#define ICTLR_COP_IER_SET	0x34
+#define ICTLR_COP_IER_CLR	0x38
+#define ICTLR_COP_IEP_CLASS	0x3c
+
+#define NUM_ICTLRS 4
+#define FIRST_LEGACY_IRQ 32
+
+static void __iomem *ictlr_reg_base[] = {
+	IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE),
+	IO_ADDRESS(TEGRA_SECONDARY_ICTLR_BASE),
+	IO_ADDRESS(TEGRA_TERTIARY_ICTLR_BASE),
+	IO_ADDRESS(TEGRA_QUATERNARY_ICTLR_BASE),
+};
+
 static void tegra_mask(struct irq_data *d)
 {
-	if (d->irq >= 32)
-		tegra_legacy_mask_irq(d->irq);
+	void __iomem *base;
+	int leg_irq;
+
+	if (d->irq < FIRST_LEGACY_IRQ)
+		return;
+
+	leg_irq = d->irq - FIRST_LEGACY_IRQ;
+	base = ictlr_reg_base[leg_irq >> 5];
+	writel(1 << (leg_irq & 31), base + ICTLR_CPU_IER_CLR);
 }
 
 static void tegra_unmask(struct irq_data *d)
 {
-	if (d->irq >= 32)
-		tegra_legacy_unmask_irq(d->irq);
+	void __iomem *base;
+	int leg_irq;
+
+	if (d->irq < FIRST_LEGACY_IRQ)
+		return;
+
+	leg_irq = d->irq - FIRST_LEGACY_IRQ;
+	base = ictlr_reg_base[leg_irq >> 5];
+	writel(1 << (leg_irq & 31), base + ICTLR_CPU_IER_SET);
 }
 
 static void tegra_ack(struct irq_data *d)
 {
-	if (d->irq >= 32)
-		tegra_legacy_force_irq_clr(d->irq);
+	void __iomem *base;
+	int leg_irq;
+
+	if (d->irq < FIRST_LEGACY_IRQ)
+		return;
+
+	leg_irq = d->irq - FIRST_LEGACY_IRQ;
+	base = ictlr_reg_base[leg_irq >> 5];
+	writel(1 << (leg_irq & 31), base + ICTLR_CPU_IEP_FIR_CLR);
 }
 
 static int tegra_retrigger(struct irq_data *d)
 {
-	if (d->irq < 32)
+	void __iomem *base;
+	int leg_irq;
+
+	if (d->irq < FIRST_LEGACY_IRQ)
 		return 0;
 
-	tegra_legacy_force_irq_set(d->irq);
+	leg_irq = d->irq - FIRST_LEGACY_IRQ;
+	base = ictlr_reg_base[leg_irq >> 5];
+	writel(1 << (leg_irq & 31), base + ICTLR_CPU_IEP_FIR_SET);
+
 	return 1;
 }
 
 void __init tegra_init_irq(void)
 {
-	tegra_init_legacy_irq();
+	int i;
+
+	for (i = 0; i < NUM_ICTLRS; i++) {
+		void __iomem *ictlr = ictlr_reg_base[i];
+		writel(~0, ictlr + ICTLR_CPU_IER_CLR);
+		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
+	}
 
 	gic_arch_extn.irq_ack = tegra_ack;
 	gic_arch_extn.irq_mask = tegra_mask;
diff --git a/arch/arm/mach-tegra/legacy_irq.c b/arch/arm/mach-tegra/legacy_irq.c
deleted file mode 100644
index cb31669..0000000
--- a/arch/arm/mach-tegra/legacy_irq.c
+++ /dev/null
@@ -1,138 +0,0 @@
-/*
- * arch/arm/mach-tegra/legacy_irq.c
- *
- * Copyright (C) 2010 Google, Inc.
- * Author: Colin Cross <ccross@android.com>
- *
- * This software is licensed under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation, and
- * may be copied, distributed, and modified under those terms.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- */
-
-#include <linux/io.h>
-#include <linux/kernel.h>
-#include <mach/iomap.h>
-#include <mach/irqs.h>
-#include <mach/legacy_irq.h>
-
-#define INT_SYS_NR	(INT_GPIO_BASE - INT_PRI_BASE)
-#define INT_SYS_SZ	(INT_SEC_BASE - INT_PRI_BASE)
-#define PPI_NR		((INT_SYS_NR+INT_SYS_SZ-1)/INT_SYS_SZ)
-
-#define ICTLR_CPU_IEP_VFIQ	0x08
-#define ICTLR_CPU_IEP_FIR	0x14
-#define ICTLR_CPU_IEP_FIR_SET	0x18
-#define ICTLR_CPU_IEP_FIR_CLR	0x1c
-
-#define ICTLR_CPU_IER		0x20
-#define ICTLR_CPU_IER_SET	0x24
-#define ICTLR_CPU_IER_CLR	0x28
-#define ICTLR_CPU_IEP_CLASS	0x2C
-
-#define ICTLR_COP_IER		0x30
-#define ICTLR_COP_IER_SET	0x34
-#define ICTLR_COP_IER_CLR	0x38
-#define ICTLR_COP_IEP_CLASS	0x3c
-
-#define NUM_ICTLRS 4
-
-static void __iomem *ictlr_reg_base[] = {
-	IO_ADDRESS(TEGRA_PRIMARY_ICTLR_BASE),
-	IO_ADDRESS(TEGRA_SECONDARY_ICTLR_BASE),
-	IO_ADDRESS(TEGRA_TERTIARY_ICTLR_BASE),
-	IO_ADDRESS(TEGRA_QUATERNARY_ICTLR_BASE),
-};
-
-/* When going into deep sleep, the CPU is powered down, taking the GIC with it
-   In order to wake, the wake interrupts need to be enabled in the legacy
-   interrupt controller. */
-void tegra_legacy_unmask_irq(unsigned int irq)
-{
-	void __iomem *base;
-	pr_debug("%s: %d\n", __func__, irq);
-
-	irq -= 32;
-	base = ictlr_reg_base[irq>>5];
-	writel(1 << (irq & 31), base + ICTLR_CPU_IER_SET);
-}
-
-void tegra_legacy_mask_irq(unsigned int irq)
-{
-	void __iomem *base;
-	pr_debug("%s: %d\n", __func__, irq);
-
-	irq -= 32;
-	base = ictlr_reg_base[irq>>5];
-	writel(1 << (irq & 31), base + ICTLR_CPU_IER_CLR);
-}
-
-void tegra_legacy_force_irq_set(unsigned int irq)
-{
-	void __iomem *base;
-	pr_debug("%s: %d\n", __func__, irq);
-
-	irq -= 32;
-	base = ictlr_reg_base[irq>>5];
-	writel(1 << (irq & 31), base + ICTLR_CPU_IEP_FIR_SET);
-}
-
-void tegra_legacy_force_irq_clr(unsigned int irq)
-{
-	void __iomem *base;
-	pr_debug("%s: %d\n", __func__, irq);
-
-	irq -= 32;
-	base = ictlr_reg_base[irq>>5];
-	writel(1 << (irq & 31), base + ICTLR_CPU_IEP_FIR_CLR);
-}
-
-int tegra_legacy_force_irq_status(unsigned int irq)
-{
-	void __iomem *base;
-	pr_debug("%s: %d\n", __func__, irq);
-
-	irq -= 32;
-	base = ictlr_reg_base[irq>>5];
-	return !!(readl(base + ICTLR_CPU_IEP_FIR) & (1 << (irq & 31)));
-}
-
-void tegra_legacy_select_fiq(unsigned int irq, bool fiq)
-{
-	void __iomem *base;
-	pr_debug("%s: %d\n", __func__, irq);
-
-	irq -= 32;
-	base = ictlr_reg_base[irq>>5];
-	writel(fiq << (irq & 31), base + ICTLR_CPU_IEP_CLASS);
-}
-
-unsigned long tegra_legacy_vfiq(int nr)
-{
-	void __iomem *base;
-	base = ictlr_reg_base[nr];
-	return readl(base + ICTLR_CPU_IEP_VFIQ);
-}
-
-unsigned long tegra_legacy_class(int nr)
-{
-	void __iomem *base;
-	base = ictlr_reg_base[nr];
-	return readl(base + ICTLR_CPU_IEP_CLASS);
-}
-
-void tegra_init_legacy_irq(void)
-{
-	int i;
-
-	for (i = 0; i < NUM_ICTLRS; i++) {
-		void __iomem *ictlr = ictlr_reg_base[i];
-		writel(~0, ictlr + ICTLR_CPU_IER_CLR);
-		writel(0, ictlr + ICTLR_CPU_IEP_CLASS);
-	}
-}
-- 
1.7.4.1

