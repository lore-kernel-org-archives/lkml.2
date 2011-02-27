Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab1B0QCI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 11:02:08 -0500
Received: from hera.kernel.org ([140.211.167.34]:58582 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1B0QCC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 11:02:02 -0500
From: Guan Xuetao <epip@hera.kernel.org>
To: arnd@arndb.de
Cc: GuanXuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, greg@kroah.com
Subject: [PATCH 13/17] unicore32 io: redefine __REG(x) and re-use readl/writel funcs
Date: Sun, 27 Feb 2011 15:59:41 +0000
Message-Id: <b05e05c32279bbb45939006a6bbaf7e7183f14ce.1298821856.git.epip@hera.kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
In-Reply-To: <cover.1298821856.git.epip@hera.kernel.org>
References: <cover.1298821856.git.epip@hera.kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 27 Feb 2011 16:01:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: GuanXuetao <gxt@mprc.pku.edu.cn>

  -- by advice of Arnd Bergmann

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/include/asm/gpio.h       |    9 ++--
 arch/unicore32/include/mach/dma.h       |   11 ++++-
 arch/unicore32/include/mach/hardware.h  |    8 +---
 arch/unicore32/kernel/clock.c           |   34 +++++++------
 arch/unicore32/kernel/dma.c             |   15 ++++--
 arch/unicore32/kernel/gpio.c            |   12 ++--
 arch/unicore32/kernel/irq.c             |   80 +++++++++++++++---------------
 arch/unicore32/kernel/pci.c             |   58 +++++++++++-----------
 arch/unicore32/kernel/process.c         |   10 ++--
 arch/unicore32/kernel/puv3-core.c       |   10 ++--
 arch/unicore32/kernel/rtc.c             |   34 +++++++-------
 arch/unicore32/kernel/time.c            |   46 +++++++++---------
 drivers/input/serio/i8042-unicore32io.h |    8 ++--
 13 files changed, 171 insertions(+), 164 deletions(-)

diff --git a/arch/unicore32/include/asm/gpio.h b/arch/unicore32/include/asm/gpio.h
index 3aaa41e..2716f14 100644
--- a/arch/unicore32/include/asm/gpio.h
+++ b/arch/unicore32/include/asm/gpio.h
@@ -13,6 +13,7 @@
 #ifndef __UNICORE_GPIO_H__
 #define __UNICORE_GPIO_H__
 
+#include <linux/io.h>
 #include <asm/irq.h>
 #include <mach/hardware.h>
 #include <asm-generic/gpio.h>
@@ -66,7 +67,7 @@
 static inline int gpio_get_value(unsigned gpio)
 {
 	if (__builtin_constant_p(gpio) && (gpio <= GPIO_MAX))
-		return GPIO_GPLR & GPIO_GPIO(gpio);
+		return readl(GPIO_GPLR) & GPIO_GPIO(gpio);
 	else
 		return __gpio_get_value(gpio);
 }
@@ -75,9 +76,9 @@ static inline void gpio_set_value(unsigned gpio, int value)
 {
 	if (__builtin_constant_p(gpio) && (gpio <= GPIO_MAX))
 		if (value)
-			GPIO_GPSR = GPIO_GPIO(gpio);
+			writel(GPIO_GPIO(gpio), GPIO_GPSR);
 		else
-			GPIO_GPCR = GPIO_GPIO(gpio);
+			writel(GPIO_GPIO(gpio), GPIO_GPCR);
 	else
 		__gpio_set_value(gpio, value);
 }
@@ -86,7 +87,7 @@ static inline void gpio_set_value(unsigned gpio, int value)
 
 static inline unsigned gpio_to_irq(unsigned gpio)
 {
-	if ((gpio < IRQ_GPIOHIGH) && (FIELD(1, 1, gpio) & GPIO_GPIR))
+	if ((gpio < IRQ_GPIOHIGH) && (FIELD(1, 1, gpio) & readl(GPIO_GPIR)))
 		return IRQ_GPIOLOW0 + gpio;
 	else
 		return IRQ_GPIO0 + gpio;
diff --git a/arch/unicore32/include/mach/dma.h b/arch/unicore32/include/mach/dma.h
index 3e3224a..d655c1b 100644
--- a/arch/unicore32/include/mach/dma.h
+++ b/arch/unicore32/include/mach/dma.h
@@ -35,7 +35,14 @@ extern int puv3_request_dma(char *name,
 
 extern void puv3_free_dma(int dma_ch);
 
-#define puv3_stop_dma(ch)		(DMAC_CONFIG(ch) &= ~DMAC_CONFIG_EN)
-#define puv3_resume_dma(ch)             (DMAC_CONFIG(ch) |= DMAC_CONFIG_EN)
+static inline void puv3_stop_dma(int ch)
+{
+	writel(readl(DMAC_CONFIG(ch)) & ~DMAC_CONFIG_EN, DMAC_CONFIG(ch));
+}
+
+static inline void puv3_resume_dma(int ch)
+{
+	writel(readl(DMAC_CONFIG(ch)) | DMAC_CONFIG_EN, DMAC_CONFIG(ch));
+}
 
 #endif /* __MACH_PUV3_DMA_H__ */
diff --git a/arch/unicore32/include/mach/hardware.h b/arch/unicore32/include/mach/hardware.h
index c7d3dd6..b71405a 100644
--- a/arch/unicore32/include/mach/hardware.h
+++ b/arch/unicore32/include/mach/hardware.h
@@ -22,13 +22,7 @@
 
 #ifndef __ASSEMBLY__
 
-# define __REG(x)	(*((volatile unsigned long *)io_p2v(x)))
-# define __PREG(x)	(io_v2p((unsigned long)&(x)))
-
-#else
-
-# define __REG(x)	io_p2v(x)
-# define __PREG(x)	io_v2p(x)
+# define __REG(x)	(void __iomem *)io_p2v(x)
 
 #endif
 
diff --git a/arch/unicore32/kernel/clock.c b/arch/unicore32/kernel/clock.c
index 80323db..18d4563 100644
--- a/arch/unicore32/kernel/clock.c
+++ b/arch/unicore32/kernel/clock.c
@@ -20,6 +20,7 @@
 #include <linux/clk.h>
 #include <linux/mutex.h>
 #include <linux/delay.h>
+#include <linux/io.h>
 
 #include <mach/hardware.h>
 
@@ -152,28 +153,29 @@ int clk_set_rate(struct clk *clk, unsigned long rate)
 		if (ret)
 			return ret;
 
-		if (PM_PLLVGACFG == pll_vgacfg)
+		if (readl(PM_PLLVGACFG) == pll_vgacfg)
 			return 0;
 
 		/* set pll vga cfg reg. */
-		PM_PLLVGACFG = pll_vgacfg;
+		writel(pll_vgacfg, PM_PLLVGACFG);
 
-		PM_PMCR = PM_PMCR_CFBVGA;
-		while ((PM_PLLDFCDONE & PM_PLLDFCDONE_VGADFC)
+		writel(PM_PMCR_CFBVGA, PM_PMCR);
+		while ((readl(PM_PLLDFCDONE) & PM_PLLDFCDONE_VGADFC)
 				!= PM_PLLDFCDONE_VGADFC)
 			udelay(100); /* about 1ms */
 
 		/* set div cfg reg. */
-		PM_PCGR |= PM_PCGR_VGACLK;
+		writel(readl(PM_PCGR) | PM_PCGR_VGACLK, PM_PCGR);
 
-		PM_DIVCFG = (PM_DIVCFG & ~PM_DIVCFG_VGACLK_MASK)
-				| PM_DIVCFG_VGACLK(pll_vgadiv);
+		writel((readl(PM_DIVCFG) & ~PM_DIVCFG_VGACLK_MASK)
+				| PM_DIVCFG_VGACLK(pll_vgadiv), PM_DIVCFG);
 
-		PM_SWRESET |= PM_SWRESET_VGADIV;
-		while ((PM_SWRESET & PM_SWRESET_VGADIV) == PM_SWRESET_VGADIV)
+		writel(readl(PM_SWRESET) | PM_SWRESET_VGADIV, PM_SWRESET);
+		while ((readl(PM_SWRESET) & PM_SWRESET_VGADIV)
+				== PM_SWRESET_VGADIV)
 			udelay(100); /* 65536 bclk32, about 320us */
 
-		PM_PCGR &= ~PM_PCGR_VGACLK;
+		writel(readl(PM_PCGR) & ~PM_PCGR_VGACLK, PM_PCGR);
 	}
 #ifdef CONFIG_CPU_FREQ
 	if (clk == &clk_mclk_clk) {
@@ -323,15 +325,15 @@ struct {
 static int __init clk_init(void)
 {
 #ifdef CONFIG_PUV3_PM
-	u32 pllrate, divstatus = PM_DIVSTATUS;
-	u32 pcgr_val = PM_PCGR;
+	u32 pllrate, divstatus = readl(PM_DIVSTATUS);
+	u32 pcgr_val = readl(PM_PCGR);
 	int i;
 
 	pcgr_val |= PM_PCGR_BCLKMME | PM_PCGR_BCLKH264E | PM_PCGR_BCLKH264D
 			| PM_PCGR_HECLK | PM_PCGR_HDCLK;
-	PM_PCGR = pcgr_val;
+	writel(pcgr_val, PM_PCGR);
 
-	pllrate = PM_PLLSYSSTATUS;
+	pllrate = readl(PM_PLLSYSSTATUS);
 
 	/* lookup pmclk_table */
 	clk_mclk_clk.rate = 0;
@@ -346,7 +348,7 @@ static int __init clk_init(void)
 		clk_bclk32_clk.rate = clk_mclk_clk.rate /
 			(((divstatus & 0x0000f000) >> 12) + 1);
 
-	pllrate = PM_PLLDDRSTATUS;
+	pllrate = readl(PM_PLLDDRSTATUS);
 
 	/* lookup pddr_table */
 	clk_ddr_clk.rate = 0;
@@ -357,7 +359,7 @@ static int __init clk_init(void)
 		}
 	}
 
-	pllrate = PM_PLLVGASTATUS;
+	pllrate = readl(PM_PLLVGASTATUS);
 
 	/* lookup pvga_table */
 	clk_vga_clk.rate = 0;
diff --git a/arch/unicore32/kernel/dma.c b/arch/unicore32/kernel/dma.c
index b8dcc25..ae441bc 100644
--- a/arch/unicore32/kernel/dma.c
+++ b/arch/unicore32/kernel/dma.c
@@ -16,6 +16,7 @@
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
+#include <linux/io.h>
 
 #include <asm/system.h>
 #include <asm/irq.h>
@@ -94,15 +95,16 @@ EXPORT_SYMBOL(puv3_free_dma);
 
 static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 {
-	int i, dint = DMAC_ITCSR;
+	int i, dint;
 
+	dint = readl(DMAC_ITCSR);
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
 		if (dint & DMAC_CHANNEL(i)) {
 			struct dma_channel *channel = &dma_channels[i];
 
 			/* Clear TC interrupt of channel i */
-			DMAC_ITCCR = DMAC_CHANNEL(i);
-			DMAC_ITCCR = 0;
+			writel(DMAC_CHANNEL(i), DMAC_ITCCR);
+			writel(0, DMAC_ITCCR);
 
 			if (channel->name && channel->irq_handler) {
 				channel->irq_handler(i, channel->data);
@@ -121,15 +123,16 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)
 
 static irqreturn_t dma_err_handler(int irq, void *dev_id)
 {
-	int i, dint = DMAC_IESR;
+	int i, dint;
 
+	dint = readl(DMAC_IESR);
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
 		if (dint & DMAC_CHANNEL(i)) {
 			struct dma_channel *channel = &dma_channels[i];
 
 			/* Clear Err interrupt of channel i */
-			DMAC_IECR = DMAC_CHANNEL(i);
-			DMAC_IECR = 0;
+			writel(DMAC_CHANNEL(i), DMAC_IECR);
+			writel(0, DMAC_IECR);
 
 			if (channel->name && channel->err_handler) {
 				channel->err_handler(i, channel->data);
diff --git a/arch/unicore32/kernel/gpio.c b/arch/unicore32/kernel/gpio.c
index 4cb2830..cb12ec3 100644
--- a/arch/unicore32/kernel/gpio.c
+++ b/arch/unicore32/kernel/gpio.c
@@ -52,15 +52,15 @@ device_initcall(puv3_gpio_leds_init);
 
 static int puv3_gpio_get(struct gpio_chip *chip, unsigned offset)
 {
-	return GPIO_GPLR & GPIO_GPIO(offset);
+	return readl(GPIO_GPLR) & GPIO_GPIO(offset);
 }
 
 static void puv3_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
 {
 	if (value)
-		GPIO_GPSR = GPIO_GPIO(offset);
+		writel(GPIO_GPIO(offset), GPIO_GPSR);
 	else
-		GPIO_GPCR = GPIO_GPIO(offset);
+		writel(GPIO_GPIO(offset), GPIO_GPCR);
 }
 
 static int puv3_direction_input(struct gpio_chip *chip, unsigned offset)
@@ -68,7 +68,7 @@ static int puv3_direction_input(struct gpio_chip *chip, unsigned offset)
 	unsigned long flags;
 
 	local_irq_save(flags);
-	GPIO_GPDR &= ~GPIO_GPIO(offset);
+	writel(readl(GPIO_GPDR) & ~GPIO_GPIO(offset), GPIO_GPDR);
 	local_irq_restore(flags);
 	return 0;
 }
@@ -80,7 +80,7 @@ static int puv3_direction_output(struct gpio_chip *chip, unsigned offset,
 
 	local_irq_save(flags);
 	puv3_gpio_set(chip, offset, value);
-	GPIO_GPDR |= GPIO_GPIO(offset);
+	writel(readl(GPIO_GPDR) | GPIO_GPIO(offset), GPIO_GPDR);
 	local_irq_restore(flags);
 	return 0;
 }
@@ -97,7 +97,7 @@ static struct gpio_chip puv3_gpio_chip = {
 
 void __init puv3_init_gpio(void)
 {
-	GPIO_GPDR = GPIO_DIR;
+	writel(GPIO_DIR, GPIO_GPDR);
 #if	defined(CONFIG_PUV3_NB0916) || defined(CONFIG_PUV3_SMW0919)	\
 	|| defined(CONFIG_PUV3_DB0913)
 	gpio_set_value(GPO_WIFI_EN, 1);
diff --git a/arch/unicore32/kernel/irq.c b/arch/unicore32/kernel/irq.c
index 38e3089..e1dbfcb 100644
--- a/arch/unicore32/kernel/irq.c
+++ b/arch/unicore32/kernel/irq.c
@@ -66,8 +66,8 @@ static int puv3_gpio_type(struct irq_data *d, unsigned int type)
 	else
 		GPIO_IRQ_falling_edge &= ~mask;
 
-	GPIO_GRER = GPIO_IRQ_rising_edge & GPIO_IRQ_mask;
-	GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
+	writel(GPIO_IRQ_rising_edge & GPIO_IRQ_mask, GPIO_GRER);
+	writel(GPIO_IRQ_falling_edge & GPIO_IRQ_mask, GPIO_GFER);
 
 	return 0;
 }
@@ -77,25 +77,25 @@ static int puv3_gpio_type(struct irq_data *d, unsigned int type)
  */
 static void puv3_low_gpio_ack(struct irq_data *d)
 {
-	GPIO_GEDR = (1 << d->irq);
+	writel((1 << d->irq), GPIO_GEDR);
 }
 
 static void puv3_low_gpio_mask(struct irq_data *d)
 {
-	INTC_ICMR &= ~(1 << d->irq);
+	writel(readl(INTC_ICMR) & ~(1 << d->irq), INTC_ICMR);
 }
 
 static void puv3_low_gpio_unmask(struct irq_data *d)
 {
-	INTC_ICMR |= 1 << d->irq;
+	writel(readl(INTC_ICMR) | (1 << d->irq), INTC_ICMR);
 }
 
 static int puv3_low_gpio_wake(struct irq_data *d, unsigned int on)
 {
 	if (on)
-		PM_PWER |= 1 << d->irq;
+		writel(readl(PM_PWER) | (1 << d->irq), PM_PWER);
 	else
-		PM_PWER &= ~(1 << d->irq);
+		writel(readl(PM_PWER) & ~(1 << d->irq), PM_PWER);
 	return 0;
 }
 
@@ -118,13 +118,13 @@ puv3_gpio_handler(unsigned int irq, struct irq_desc *desc)
 {
 	unsigned int mask;
 
-	mask = GPIO_GEDR;
+	mask = readl(GPIO_GEDR);
 	do {
 		/*
 		 * clear down all currently active IRQ sources.
 		 * We will be processing them all.
 		 */
-		GPIO_GEDR = mask;
+		writel(mask, GPIO_GEDR);
 
 		irq = IRQ_GPIO0;
 		do {
@@ -133,7 +133,7 @@ puv3_gpio_handler(unsigned int irq, struct irq_desc *desc)
 			mask >>= 1;
 			irq++;
 		} while (mask);
-		mask = GPIO_GEDR;
+		mask = readl(GPIO_GEDR);
 	} while (mask);
 }
 
@@ -146,7 +146,7 @@ static void puv3_high_gpio_ack(struct irq_data *d)
 {
 	unsigned int mask = GPIO_MASK(d->irq);
 
-	GPIO_GEDR = mask;
+	writel(mask, GPIO_GEDR);
 }
 
 static void puv3_high_gpio_mask(struct irq_data *d)
@@ -155,8 +155,8 @@ static void puv3_high_gpio_mask(struct irq_data *d)
 
 	GPIO_IRQ_mask &= ~mask;
 
-	GPIO_GRER &= ~mask;
-	GPIO_GFER &= ~mask;
+	writel(readl(GPIO_GRER) & ~mask, GPIO_GRER);
+	writel(readl(GPIO_GFER) & ~mask, GPIO_GFER);
 }
 
 static void puv3_high_gpio_unmask(struct irq_data *d)
@@ -165,16 +165,16 @@ static void puv3_high_gpio_unmask(struct irq_data *d)
 
 	GPIO_IRQ_mask |= mask;
 
-	GPIO_GRER = GPIO_IRQ_rising_edge & GPIO_IRQ_mask;
-	GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
+	writel(GPIO_IRQ_rising_edge & GPIO_IRQ_mask, GPIO_GRER);
+	writel(GPIO_IRQ_falling_edge & GPIO_IRQ_mask, GPIO_GFER);
 }
 
 static int puv3_high_gpio_wake(struct irq_data *d, unsigned int on)
 {
 	if (on)
-		PM_PWER |= PM_PWER_GPIOHIGH;
+		writel(readl(PM_PWER) | PM_PWER_GPIOHIGH, PM_PWER);
 	else
-		PM_PWER &= ~PM_PWER_GPIOHIGH;
+		writel(readl(PM_PWER) & ~PM_PWER_GPIOHIGH, PM_PWER);
 	return 0;
 }
 
@@ -193,12 +193,12 @@ static struct irq_chip puv3_high_gpio_chip = {
  */
 static void puv3_mask_irq(struct irq_data *d)
 {
-	INTC_ICMR &= ~(1 << d->irq);
+	writel(readl(INTC_ICMR) & ~(1 << d->irq), INTC_ICMR);
 }
 
 static void puv3_unmask_irq(struct irq_data *d)
 {
-	INTC_ICMR |= (1 << d->irq);
+	writel(readl(INTC_ICMR) | (1 << d->irq), INTC_ICMR);
 }
 
 /*
@@ -208,9 +208,9 @@ static int puv3_set_wake(struct irq_data *d, unsigned int on)
 {
 	if (d->irq == IRQ_RTCAlarm) {
 		if (on)
-			PM_PWER |= PM_PWER_RTC;
+			writel(readl(PM_PWER) | PM_PWER_RTC, PM_PWER);
 		else
-			PM_PWER &= ~PM_PWER_RTC;
+			writel(readl(PM_PWER) & ~PM_PWER_RTC, PM_PWER);
 		return 0;
 	}
 	return -EINVAL;
@@ -242,25 +242,25 @@ static int puv3_irq_suspend(struct sys_device *dev, pm_message_t state)
 	struct puv3_irq_state *st = &puv3_irq_state;
 
 	st->saved = 1;
-	st->icmr = INTC_ICMR;
-	st->iclr = INTC_ICLR;
-	st->iccr = INTC_ICCR;
+	st->icmr = readl(INTC_ICMR);
+	st->iclr = readl(INTC_ICLR);
+	st->iccr = readl(INTC_ICCR);
 
 	/*
 	 * Disable all GPIO-based interrupts.
 	 */
-	INTC_ICMR &= ~(0x1ff);
+	writel(readl(INTC_ICMR) & ~(0x1ff), INTC_ICMR);
 
 	/*
 	 * Set the appropriate edges for wakeup.
 	 */
-	GPIO_GRER = PM_PWER & GPIO_IRQ_rising_edge;
-	GPIO_GFER = PM_PWER & GPIO_IRQ_falling_edge;
+	writel(readl(PM_PWER) & GPIO_IRQ_rising_edge, GPIO_GRER);
+	writel(readl(PM_PWER) & GPIO_IRQ_falling_edge, GPIO_GFER);
 
 	/*
 	 * Clear any pending GPIO interrupts.
 	 */
-	GPIO_GEDR = GPIO_GEDR;
+	writel(readl(GPIO_GEDR), GPIO_GEDR);
 
 	return 0;
 }
@@ -270,13 +270,13 @@ static int puv3_irq_resume(struct sys_device *dev)
 	struct puv3_irq_state *st = &puv3_irq_state;
 
 	if (st->saved) {
-		INTC_ICCR = st->iccr;
-		INTC_ICLR = st->iclr;
+		writel(st->iccr, INTC_ICCR);
+		writel(st->iclr, INTC_ICLR);
 
-		GPIO_GRER = GPIO_IRQ_rising_edge & GPIO_IRQ_mask;
-		GPIO_GFER = GPIO_IRQ_falling_edge & GPIO_IRQ_mask;
+		writel(GPIO_IRQ_rising_edge & GPIO_IRQ_mask, GPIO_GRER);
+		writel(GPIO_IRQ_falling_edge & GPIO_IRQ_mask, GPIO_GFER);
 
-		INTC_ICMR = st->icmr;
+		writel(st->icmr, INTC_ICMR);
 	}
 	return 0;
 }
@@ -307,18 +307,18 @@ void __init init_IRQ(void)
 	request_resource(&iomem_resource, &irq_resource);
 
 	/* disable all IRQs */
-	INTC_ICMR = 0;
+	writel(0, INTC_ICMR);
 
 	/* all IRQs are IRQ, not REAL */
-	INTC_ICLR = 0;
+	writel(0, INTC_ICLR);
 
 	/* clear all GPIO edge detects */
-	GPIO_GPIR = FMASK(8, 0) & ~FIELD(1, 1, GPI_SOFF_REQ);
-	GPIO_GFER = 0;
-	GPIO_GRER = 0;
-	GPIO_GEDR = 0x0FFFFFFF;
+	writel(FMASK(8, 0) & ~FIELD(1, 1, GPI_SOFF_REQ), GPIO_GPIR);
+	writel(0, GPIO_GFER);
+	writel(0, GPIO_GRER);
+	writel(0x0FFFFFFF, GPIO_GEDR);
 
-	INTC_ICCR = 1;
+	writel(1, INTC_ICCR);
 
 	for (irq = 0; irq < IRQ_GPIOHIGH; irq++) {
 		set_irq_chip(irq, &puv3_low_gpio_chip);
diff --git a/arch/unicore32/kernel/pci.c b/arch/unicore32/kernel/pci.c
index d4e55e2..65c265e 100644
--- a/arch/unicore32/kernel/pci.c
+++ b/arch/unicore32/kernel/pci.c
@@ -30,16 +30,16 @@ static int
 puv3_read_config(struct pci_bus *bus, unsigned int devfn, int where,
 			int size, u32 *value)
 {
-	PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
+	writel(CONFIG_CMD(bus, devfn, where), PCICFG_ADDR);
 	switch (size) {
 	case 1:
-		*value = (PCICFG_DATA >> ((where & 3) * 8)) & 0xFF;
+		*value = (readl(PCICFG_DATA) >> ((where & 3) * 8)) & 0xFF;
 		break;
 	case 2:
-		*value = (PCICFG_DATA >> ((where & 2) * 8)) & 0xFFFF;
+		*value = (readl(PCICFG_DATA) >> ((where & 2) * 8)) & 0xFFFF;
 		break;
 	case 4:
-		*value = PCICFG_DATA;
+		*value = readl(PCICFG_DATA);
 		break;
 	}
 	return PCIBIOS_SUCCESSFUL;
@@ -49,18 +49,18 @@ static int
 puv3_write_config(struct pci_bus *bus, unsigned int devfn, int where,
 			int size, u32 value)
 {
-	PCICFG_ADDR = CONFIG_CMD(bus, devfn, where);
+	writel(CONFIG_CMD(bus, devfn, where), PCICFG_ADDR);
 	switch (size) {
 	case 1:
-		PCICFG_DATA = (PCICFG_DATA & ~FMASK(8, (where&3)*8))
-			| FIELD(value, 8, (where&3)*8);
+		writel((readl(PCICFG_DATA) & ~FMASK(8, (where&3)*8))
+			| FIELD(value, 8, (where&3)*8), PCICFG_DATA);
 		break;
 	case 2:
-		PCICFG_DATA = (PCICFG_DATA & ~FMASK(16, (where&2)*8))
-			| FIELD(value, 16, (where&2)*8);
+		writel((readl(PCICFG_DATA) & ~FMASK(16, (where&2)*8))
+			| FIELD(value, 16, (where&2)*8), PCICFG_DATA);
 		break;
 	case 4:
-		PCICFG_DATA = value;
+		writel(value, PCICFG_DATA);
 		break;
 	}
 	return PCIBIOS_SUCCESSFUL;
@@ -75,31 +75,31 @@ void pci_puv3_preinit(void)
 {
 	printk(KERN_DEBUG "PCI: PKUnity PCI Controller Initializing ...\n");
 	/* config PCI bridge base */
-	PCICFG_BRIBASE = PKUNITY_PCIBRI_BASE;
+	writel(PKUNITY_PCIBRI_BASE, PCICFG_BRIBASE);
 
-	PCIBRI_AHBCTL0 = 0;
-	PCIBRI_AHBBAR0 = PKUNITY_PCIBRI_BASE | PCIBRI_BARx_MEM;
-	PCIBRI_AHBAMR0 = 0xFFFF0000;
-	PCIBRI_AHBTAR0 = 0;
+	writel(0, PCIBRI_AHBCTL0);
+	writel(PKUNITY_PCIBRI_BASE | PCIBRI_BARx_MEM, PCIBRI_AHBBAR0);
+	writel(0xFFFF0000, PCIBRI_AHBAMR0);
+	writel(0, PCIBRI_AHBTAR0);
 
-	PCIBRI_AHBCTL1 = PCIBRI_CTLx_AT;
-	PCIBRI_AHBBAR1 = PKUNITY_PCILIO_BASE | PCIBRI_BARx_IO;
-	PCIBRI_AHBAMR1 = 0xFFFF0000;
-	PCIBRI_AHBTAR1 = 0x00000000;
+	writel(PCIBRI_CTLx_AT, PCIBRI_AHBCTL1);
+	writel(PKUNITY_PCILIO_BASE | PCIBRI_BARx_IO, PCIBRI_AHBBAR1);
+	writel(0xFFFF0000, PCIBRI_AHBAMR1);
+	writel(0x00000000, PCIBRI_AHBTAR1);
 
-	PCIBRI_AHBCTL2 = PCIBRI_CTLx_PREF;
-	PCIBRI_AHBBAR2 = PKUNITY_PCIMEM_BASE | PCIBRI_BARx_MEM;
-	PCIBRI_AHBAMR2 = 0xF8000000;
-	PCIBRI_AHBTAR2 = 0;
+	writel(PCIBRI_CTLx_PREF, PCIBRI_AHBCTL2);
+	writel(PKUNITY_PCIMEM_BASE | PCIBRI_BARx_MEM, PCIBRI_AHBBAR2);
+	writel(0xF8000000, PCIBRI_AHBAMR2);
+	writel(0, PCIBRI_AHBTAR2);
 
-	PCIBRI_BAR1 = PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM;
+	writel(PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM, PCIBRI_BAR1);
 
-	PCIBRI_PCICTL0 = PCIBRI_CTLx_AT | PCIBRI_CTLx_PREF;
-	PCIBRI_PCIBAR0 = PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM;
-	PCIBRI_PCIAMR0 = 0xF8000000;
-	PCIBRI_PCITAR0 = PKUNITY_SDRAM_BASE;
+	writel(PCIBRI_CTLx_AT | PCIBRI_CTLx_PREF, PCIBRI_PCICTL0);
+	writel(PKUNITY_PCIAHB_BASE | PCIBRI_BARx_MEM, PCIBRI_PCIBAR0);
+	writel(0xF8000000, PCIBRI_PCIAMR0);
+	writel(PKUNITY_SDRAM_BASE, PCIBRI_PCITAR0);
 
-	PCIBRI_CMD = PCIBRI_CMD | PCIBRI_CMD_IO | PCIBRI_CMD_MEM;
+	writel(readl(PCIBRI_CMD) | PCIBRI_CMD_IO | PCIBRI_CMD_MEM, PCIBRI_CMD);
 }
 
 static int __init pci_puv3_map_irq(struct pci_dev *dev, u8 slot, u8 pin)
diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 8d4a273..ba401df 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -125,9 +125,9 @@ void machine_restart(char *cmd)
 		/* Jump into ROM at address 0xffff0000 */
 		cpu_reset(VECTORS_BASE);
 	} else {
-		PM_PLLSYSCFG = 0x00002001; /* cpu clk = 250M */
-		PM_PLLDDRCFG = 0x00100800; /* ddr clk =  44M */
-		PM_PLLVGACFG = 0x00002001; /* vga clk = 250M */
+		writel(0x00002001, PM_PLLSYSCFG); /* cpu clk = 250M */
+		writel(0x00100800, PM_PLLDDRCFG); /* ddr clk =  44M */
+		writel(0x00002001, PM_PLLVGACFG); /* vga clk = 250M */
 
 		/* Use on-chip reset capability */
 		/* following instructions must be in one icache line */
@@ -141,10 +141,10 @@ void machine_restart(char *cmd)
 			"	nop; nop; nop\n\t"
 			/* prefetch 3 instructions at most */
 			:
-			: "r" ((unsigned long)&PM_PMCR),
+			: "r" (PM_PMCR),
 			  "r" (PM_PMCR_CFBSYS | PM_PMCR_CFBDDR
 				| PM_PMCR_CFBVGA),
-			  "r" ((unsigned long)&RESETC_SWRR),
+			  "r" (RESETC_SWRR),
 			  "r" (RESETC_SWRR_SRB)
 			: "r0", "memory");
 	}
diff --git a/arch/unicore32/kernel/puv3-core.c b/arch/unicore32/kernel/puv3-core.c
index 26cc52b..6edf928 100644
--- a/arch/unicore32/kernel/puv3-core.c
+++ b/arch/unicore32/kernel/puv3-core.c
@@ -36,7 +36,7 @@
  */
 unsigned long long sched_clock(void)
 {
-	unsigned long long v = cnt32_to_63(OST_OSCR);
+	unsigned long long v = cnt32_to_63(readl(OST_OSCR));
 
 	/* original conservative method, but overflow frequently
 	 * v *= NSEC_PER_SEC >> 12;
@@ -187,15 +187,15 @@ static void puv3_cpu_pm_restore(unsigned long *sleep_save)
 static int puv3_cpu_pm_prepare(void)
 {
 	/* set resume return address */
-	PM_DIVCFG = virt_to_phys(puv3_cpu_resume);
+	writel(virt_to_phys(puv3_cpu_resume), PM_DIVCFG);
 	return 0;
 }
 
 static void puv3_cpu_pm_enter(suspend_state_t state)
 {
 	/* Clear reset status */
-	RESETC_RSSR = RESETC_RSSR_HWR | RESETC_RSSR_WDR
-			| RESETC_RSSR_SMR | RESETC_RSSR_SWR;
+	writel(RESETC_RSSR_HWR | RESETC_RSSR_WDR
+			| RESETC_RSSR_SMR | RESETC_RSSR_SWR, RESETC_RSSR);
 
 	switch (state) {
 /*	case PM_SUSPEND_ON:
@@ -242,7 +242,7 @@ void puv3_ps2_init(void)
 	struct clk *bclk32;
 
 	bclk32 = clk_get(NULL, "BUS32_CLK");
-	PS2_CNT = clk_get_rate(bclk32) / 200000; /* should > 5us */
+	writel(clk_get_rate(bclk32) / 200000, PS2_CNT); /* should > 5us */
 }
 
 void __init puv3_core_init(void)
diff --git a/arch/unicore32/kernel/rtc.c b/arch/unicore32/kernel/rtc.c
index 5e4db41..c5f0682 100644
--- a/arch/unicore32/kernel/rtc.c
+++ b/arch/unicore32/kernel/rtc.c
@@ -41,7 +41,7 @@ static irqreturn_t puv3_rtc_alarmirq(int irq, void *id)
 {
 	struct rtc_device *rdev = id;
 
-	RTC_RTSR |= RTC_RTSR_AL;
+	writel(readl(RTC_RTSR) | RTC_RTSR_AL, RTC_RTSR);
 	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
 	return IRQ_HANDLED;
 }
@@ -50,7 +50,7 @@ static irqreturn_t puv3_rtc_tickirq(int irq, void *id)
 {
 	struct rtc_device *rdev = id;
 
-	RTC_RTSR |= RTC_RTSR_HZ;
+	writel(readl(RTC_RTSR) | RTC_RTSR_HZ, RTC_RTSR);
 	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
 	return IRQ_HANDLED;
 }
@@ -62,12 +62,12 @@ static void puv3_rtc_setaie(int to)
 
 	pr_debug("%s: aie=%d\n", __func__, to);
 
-	tmp = RTC_RTSR & ~RTC_RTSR_ALE;
+	tmp = readl(RTC_RTSR) & ~RTC_RTSR_ALE;
 
 	if (to)
 		tmp |= RTC_RTSR_ALE;
 
-	RTC_RTSR = tmp;
+	writel(tmp, RTC_RTSR);
 }
 
 static int puv3_rtc_setpie(struct device *dev, int enabled)
@@ -77,12 +77,12 @@ static int puv3_rtc_setpie(struct device *dev, int enabled)
 	pr_debug("%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&puv3_rtc_pie_lock);
-	tmp = RTC_RTSR & ~RTC_RTSR_HZE;
+	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
 
 	if (enabled)
 		tmp |= RTC_RTSR_HZE;
 
-	RTC_RTSR = tmp;
+	writel(tmp, RTC_RTSR);
 	spin_unlock_irq(&puv3_rtc_pie_lock);
 
 	return 0;
@@ -97,7 +97,7 @@ static int puv3_rtc_setfreq(struct device *dev, int freq)
 
 static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
-	rtc_time_to_tm(RTC_RCNR, rtc_tm);
+	rtc_time_to_tm(readl(RTC_RCNR), rtc_tm);
 
 	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
 		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
@@ -115,7 +115,7 @@ static int puv3_rtc_settime(struct device *dev, struct rtc_time *tm)
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
 	rtc_tm_to_time(tm, &rtc_count);
-	RTC_RCNR = rtc_count;
+	writel(rtc_count, RTC_RCNR);
 
 	return 0;
 }
@@ -124,9 +124,9 @@ static int puv3_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct rtc_time *alm_tm = &alrm->time;
 
-	rtc_time_to_tm(RTC_RTAR, alm_tm);
+	rtc_time_to_tm(readl(RTC_RTAR), alm_tm);
 
-	alrm->enabled = RTC_RTSR & RTC_RTSR_ALE;
+	alrm->enabled = readl(RTC_RTSR) & RTC_RTSR_ALE;
 
 	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
 		 alrm->enabled,
@@ -147,7 +147,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
 
 	rtc_tm_to_time(tm, &rtcalarm_count);
-	RTC_RTAR = rtcalarm_count;
+	writel(rtcalarm_count, RTC_RTAR);
 
 	puv3_rtc_setaie(alrm->enabled);
 
@@ -162,7 +162,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 static int puv3_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	seq_printf(seq, "periodic_IRQ\t: %s\n",
-		     (RTC_RTSR & RTC_RTSR_HZE) ? "yes" : "no");
+		     (readl(RTC_RTSR) & RTC_RTSR_HZE) ? "yes" : "no");
 	return 0;
 }
 
@@ -222,13 +222,13 @@ static const struct rtc_class_ops puv3_rtcops = {
 static void puv3_rtc_enable(struct platform_device *pdev, int en)
 {
 	if (!en) {
-		RTC_RTSR &= ~RTC_RTSR_HZE;
+		writel(readl(RTC_RTSR) & ~RTC_RTSR_HZE, RTC_RTSR);
 	} else {
 		/* re-enable the device, and check it is ok */
 
-		if ((RTC_RTSR & RTC_RTSR_HZE) == 0) {
+		if ((readl(RTC_RTSR) & RTC_RTSR_HZE) == 0) {
 			dev_info(&pdev->dev, "rtc disabled, re-enabling\n");
-			RTC_RTSR |= RTC_RTSR_HZE;
+			writel(readl(RTC_RTSR) | RTC_RTSR_HZE, RTC_RTSR);
 		}
 	}
 }
@@ -331,7 +331,7 @@ static int ticnt_save;
 static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	/* save RTAR for anyone using periodic interrupts */
-	ticnt_save = RTC_RTAR;
+	ticnt_save = readl(RTC_RTAR);
 	puv3_rtc_enable(pdev, 0);
 	return 0;
 }
@@ -339,7 +339,7 @@ static int puv3_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 static int puv3_rtc_resume(struct platform_device *pdev)
 {
 	puv3_rtc_enable(pdev, 1);
-	RTC_RTAR = ticnt_save;
+	writel(ticnt_save, RTC_RTAR);
 	return 0;
 }
 #else
diff --git a/arch/unicore32/kernel/time.c b/arch/unicore32/kernel/time.c
index 8bb4b81..080710c 100644
--- a/arch/unicore32/kernel/time.c
+++ b/arch/unicore32/kernel/time.c
@@ -26,8 +26,8 @@ static irqreturn_t puv3_ost0_interrupt(int irq, void *dev_id)
 	struct clock_event_device *c = dev_id;
 
 	/* Disarm the compare/match, signal the event. */
-	OST_OIER &= ~OST_OIER_E0;
-	OST_OSSR &= ~OST_OSSR_M0;
+	writel(readl(OST_OIER) & ~OST_OIER_E0, OST_OIER);
+	writel(readl(OST_OSSR) & ~OST_OSSR_M0, OST_OSSR);
 	c->event_handler(c);
 
 	return IRQ_HANDLED;
@@ -38,10 +38,10 @@ puv3_osmr0_set_next_event(unsigned long delta, struct clock_event_device *c)
 {
 	unsigned long next, oscr;
 
-	OST_OIER |= OST_OIER_E0;
-	next = OST_OSCR + delta;
-	OST_OSMR0 = next;
-	oscr = OST_OSCR;
+	writel(readl(OST_OIER) | OST_OIER_E0, OST_OIER);
+	next = readl(OST_OSCR) + delta;
+	writel(next, OST_OSMR0);
+	oscr = readl(OST_OSCR);
 
 	return (signed)(next - oscr) <= MIN_OSCR_DELTA ? -ETIME : 0;
 }
@@ -53,8 +53,8 @@ puv3_osmr0_set_mode(enum clock_event_mode mode, struct clock_event_device *c)
 	case CLOCK_EVT_MODE_ONESHOT:
 	case CLOCK_EVT_MODE_UNUSED:
 	case CLOCK_EVT_MODE_SHUTDOWN:
-		OST_OIER &= ~OST_OIER_E0;
-		OST_OSSR &= ~OST_OSSR_M0;
+		writel(readl(OST_OIER) & ~OST_OIER_E0, OST_OIER);
+		writel(readl(OST_OSSR) & ~OST_OSSR_M0, OST_OSSR);
 		break;
 
 	case CLOCK_EVT_MODE_RESUME:
@@ -73,7 +73,7 @@ static struct clock_event_device ckevt_puv3_osmr0 = {
 
 static cycle_t puv3_read_oscr(struct clocksource *cs)
 {
-	return OST_OSCR;
+	return readl(OST_OSCR);
 }
 
 static struct clocksource cksrc_puv3_oscr = {
@@ -93,8 +93,8 @@ static struct irqaction puv3_timer_irq = {
 
 void __init time_init(void)
 {
-	OST_OIER = 0;		/* disable any timer interrupts */
-	OST_OSSR = 0;		/* clear status on all timers */
+	writel(0, OST_OIER);		/* disable any timer interrupts */
+	writel(0, OST_OSSR);		/* clear status on all timers */
 
 	clockevents_calc_mult_shift(&ckevt_puv3_osmr0, CLOCK_TICK_RATE, 5);
 
@@ -115,26 +115,26 @@ unsigned long osmr[4], oier;
 
 void puv3_timer_suspend(void)
 {
-	osmr[0] = OST_OSMR0;
-	osmr[1] = OST_OSMR1;
-	osmr[2] = OST_OSMR2;
-	osmr[3] = OST_OSMR3;
-	oier = OST_OIER;
+	osmr[0] = readl(OST_OSMR0);
+	osmr[1] = readl(OST_OSMR1);
+	osmr[2] = readl(OST_OSMR2);
+	osmr[3] = readl(OST_OSMR3);
+	oier = readl(OST_OIER);
 }
 
 void puv3_timer_resume(void)
 {
-	OST_OSSR = 0;
-	OST_OSMR0 = osmr[0];
-	OST_OSMR1 = osmr[1];
-	OST_OSMR2 = osmr[2];
-	OST_OSMR3 = osmr[3];
-	OST_OIER = oier;
+	writel(0, OST_OSSR);
+	writel(osmr[0], OST_OSMR0);
+	writel(osmr[1], OST_OSMR1);
+	writel(osmr[2], OST_OSMR2);
+	writel(osmr[3], OST_OSMR3);
+	writel(oier, OST_OIER);
 
 	/*
 	 * OSMR0 is the system timer: make sure OSCR is sufficiently behind
 	 */
-	OST_OSCR = OST_OSMR0 - LATCH;
+	writel(readl(OST_OSMR0) - LATCH, OST_OSCR);
 }
 #else
 void puv3_timer_suspend(void) { };
diff --git a/drivers/input/serio/i8042-unicore32io.h b/drivers/input/serio/i8042-unicore32io.h
index 620b040..73f5cc1 100644
--- a/drivers/input/serio/i8042-unicore32io.h
+++ b/drivers/input/serio/i8042-unicore32io.h
@@ -29,11 +29,11 @@
 /*
  * Register numbers.
  */
-#define I8042_COMMAND_REG	((volatile void __iomem *)&PS2_COMMAND)
-#define I8042_STATUS_REG	((volatile void __iomem *)&PS2_STATUS)
-#define I8042_DATA_REG		((volatile void __iomem *)&PS2_DATA)
+#define I8042_COMMAND_REG	PS2_COMMAND
+#define I8042_STATUS_REG	PS2_STATUS
+#define I8042_DATA_REG		PS2_DATA
 
-#define I8042_REGION_START	(resource_size_t)(&PS2_DATA)
+#define I8042_REGION_START	(resource_size_t)(PS2_DATA)
 #define I8042_REGION_SIZE	(resource_size_t)(16)
 
 static inline int i8042_read_data(void)
-- 
1.7.4.1

