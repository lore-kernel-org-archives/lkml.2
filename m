Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1FTVyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:54:46 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:48074 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab1FTVyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:54:43 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-11.tower-131.messagelabs.com!1308606879!13019216!4
X-StarScan-Version: 6.2.17; banners=-,-,-
X-Originating-IP: [216.166.12.97]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] locomo: drop special locomo_{read/write}l in favor of io{read/write}16
Date: Mon, 20 Jun 2011 14:54:17 -0700
User-Agent: KMail/1.9.9
CC: ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-input@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <rpurdie@rpsys.net>,
        <lethal@linux-sh.org>, <tglx@linutronix.de>, <buytenh@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201106201454.18070.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the locomo registers are 16-bit ioremap'ed memory addresses.  

Make the locomo drivers use generic purpose io routines: ioread16
and iowrite16 instead of directly accessing memory.

There are still a couple checkpatch warnings about lines exceeding
79 characters.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lennert Buytenhek <buytenh@secretlab.ca>

---

diff --git a/arch/arm/common/locomo.c b/arch/arm/common/locomo.c
index b55c362..3ced960 100644
--- a/arch/arm/common/locomo.c
+++ b/arch/arm/common/locomo.c
@@ -141,13 +141,14 @@ static struct locomo_dev_info locomo_devices[] = {
 static void locomo_handler(unsigned int irq, struct irq_desc *desc)
 {
 	struct locomo *lchip = irq_get_chip_data(irq);
-	int req, i;
+	u16 req;
+	int i;
 
 	/* Acknowledge the parent IRQ */
 	desc->irq_data.chip->irq_ack(&desc->irq_data);
 
 	/* check why this interrupt was generated */
-	req = locomo_readl(lchip->base + LOCOMO_ICR) & 0x0f00;
+	req = ioread16(lchip->base + LOCOMO_ICR) & 0x0f00;
 
 	if (req) {
 		/* generate the next interrupt(s) */
@@ -168,19 +169,21 @@ static void locomo_ack_irq(struct irq_data *d)
 static void locomo_mask_irq(struct irq_data *d)
 {
 	struct locomo *lchip = irq_data_get_irq_chip_data(d);
-	unsigned int r;
-	r = locomo_readl(lchip->base + LOCOMO_ICR);
+	u16 r;
+
+	r = ioread16(lchip->base + LOCOMO_ICR);
 	r &= ~(0x0010 << (d->irq - lchip->irq_base));
-	locomo_writel(r, lchip->base + LOCOMO_ICR);
+	iowrite16(r, lchip->base + LOCOMO_ICR);
 }
 
 static void locomo_unmask_irq(struct irq_data *d)
 {
 	struct locomo *lchip = irq_data_get_irq_chip_data(d);
-	unsigned int r;
-	r = locomo_readl(lchip->base + LOCOMO_ICR);
+	u16 r;
+
+	r = ioread16(lchip->base + LOCOMO_ICR);
 	r |= (0x0010 << (d->irq - lchip->irq_base));
-	locomo_writel(r, lchip->base + LOCOMO_ICR);
+	iowrite16(r, lchip->base + LOCOMO_ICR);
 }
 
 static struct irq_chip locomo_chip = {
@@ -265,11 +268,11 @@ locomo_init_one_child(struct locomo *lchip, struct locomo_dev_info *info)
 #ifdef CONFIG_PM
 
 struct locomo_save_data {
-	u16	LCM_GPO;
-	u16	LCM_SPICT;
-	u16	LCM_GPE;
-	u16	LCM_ASD;
-	u16	LCM_SPIMD;
+	u16	LCM_GPO;	/* GPIO */
+	u16	LCM_SPICT;	/* SPI */
+	u16	LCM_GPE;	/* GPIO */
+	u16	LCM_ASD;	/* ADSTART */
+	u16	LCM_SPIMD;	/* SPI */
 };
 
 static int locomo_suspend(struct platform_device *dev, pm_message_t state)
@@ -286,30 +289,31 @@ static int locomo_suspend(struct platform_device *dev, pm_message_t state)
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
-	save->LCM_GPO     = locomo_readl(lchip->base + LOCOMO_GPO);	/* GPIO */
-	locomo_writel(0x00, lchip->base + LOCOMO_GPO);
-	save->LCM_SPICT   = locomo_readl(lchip->base + LOCOMO_SPI + LOCOMO_SPICT);	/* SPI */
-	locomo_writel(0x40, lchip->base + LOCOMO_SPI + LOCOMO_SPICT);
-	save->LCM_GPE     = locomo_readl(lchip->base + LOCOMO_GPE);	/* GPIO */
-	locomo_writel(0x00, lchip->base + LOCOMO_GPE);
-	save->LCM_ASD     = locomo_readl(lchip->base + LOCOMO_ASD);	/* ADSTART */
-	locomo_writel(0x00, lchip->base + LOCOMO_ASD);
-	save->LCM_SPIMD   = locomo_readl(lchip->base + LOCOMO_SPI + LOCOMO_SPIMD);	/* SPI */
-	locomo_writel(0x3C14, lchip->base + LOCOMO_SPI + LOCOMO_SPIMD);
-
-	locomo_writel(0x00, lchip->base + LOCOMO_PAIF);
-	locomo_writel(0x00, lchip->base + LOCOMO_DAC);
-	locomo_writel(0x00, lchip->base + LOCOMO_BACKLIGHT + LOCOMO_TC);
-
-	if ((locomo_readl(lchip->base + LOCOMO_LED + LOCOMO_LPT0) & 0x88) && (locomo_readl(lchip->base + LOCOMO_LED + LOCOMO_LPT1) & 0x88))
-		locomo_writel(0x00, lchip->base + LOCOMO_C32K); 	/* CLK32 off */
+	save->LCM_GPO = ioread16(lchip->base + LOCOMO_GPO);
+	save->LCM_SPICT = ioread16(lchip->base + LOCOMO_SPI + LOCOMO_SPICT);
+	save->LCM_GPE = ioread16(lchip->base + LOCOMO_GPE);
+	save->LCM_ASD = ioread16(lchip->base + LOCOMO_ASD);
+	save->LCM_SPIMD = ioread16(lchip->base + LOCOMO_SPI + LOCOMO_SPIMD);
+	iowrite16(0x00, lchip->base + LOCOMO_GPO);
+	iowrite16(0x40, lchip->base + LOCOMO_SPI + LOCOMO_SPICT);
+	iowrite16(0x00, lchip->base + LOCOMO_GPE);
+	iowrite16(0x00, lchip->base + LOCOMO_ASD);
+	iowrite16(0x3C14, lchip->base + LOCOMO_SPI + LOCOMO_SPIMD);
+
+	iowrite16(0x00, lchip->base + LOCOMO_PAIF);
+	iowrite16(0x00, lchip->base + LOCOMO_DAC);
+	iowrite16(0x00, lchip->base + LOCOMO_BACKLIGHT + LOCOMO_TC);
+
+	if ((ioread16(lchip->base + LOCOMO_LED + LOCOMO_LPT0) & 0x88) &&
+	    (ioread16(lchip->base + LOCOMO_LED + LOCOMO_LPT1) & 0x88))
+		iowrite16(0x00, lchip->base + LOCOMO_C32K);	/* CLK32 off */
 	else
 		/* 18MHz already enabled, so no wait */
-		locomo_writel(0xc1, lchip->base + LOCOMO_C32K); 	/* CLK32 on */
+		iowrite16(0xc1, lchip->base + LOCOMO_C32K);	/* CLK32 on */
 
-	locomo_writel(0x00, lchip->base + LOCOMO_TADC);		/* 18MHz clock off*/
-	locomo_writel(0x00, lchip->base + LOCOMO_AUDIO + LOCOMO_ACC);			/* 22MHz/24MHz clock off */
-	locomo_writel(0x00, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);			/* FL */
+	iowrite16(0x00, lchip->base + LOCOMO_TADC);		/* 18MHz clock off*/
+	iowrite16(0x00, lchip->base + LOCOMO_AUDIO + LOCOMO_ACC);	/* 22MHz/24MHz clock off */
+	iowrite16(0x00, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);	/* FL */
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 
@@ -320,7 +324,7 @@ static int locomo_resume(struct platform_device *dev)
 {
 	struct locomo *lchip = platform_get_drvdata(dev);
 	struct locomo_save_data *save;
-	unsigned long r;
+	u16 r;
 	unsigned long flags;
 
 	save = lchip->saved_state;
@@ -329,20 +333,20 @@ static int locomo_resume(struct platform_device *dev)
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
-	locomo_writel(save->LCM_GPO, lchip->base + LOCOMO_GPO);
-	locomo_writel(save->LCM_SPICT, lchip->base + LOCOMO_SPI + LOCOMO_SPICT);
-	locomo_writel(save->LCM_GPE, lchip->base + LOCOMO_GPE);
-	locomo_writel(save->LCM_ASD, lchip->base + LOCOMO_ASD);
-	locomo_writel(save->LCM_SPIMD, lchip->base + LOCOMO_SPI + LOCOMO_SPIMD);
+	iowrite16(save->LCM_GPO, lchip->base + LOCOMO_GPO);
+	iowrite16(save->LCM_SPICT, lchip->base + LOCOMO_SPI + LOCOMO_SPICT);
+	iowrite16(save->LCM_GPE, lchip->base + LOCOMO_GPE);
+	iowrite16(save->LCM_ASD, lchip->base + LOCOMO_ASD);
+	iowrite16(save->LCM_SPIMD, lchip->base + LOCOMO_SPI + LOCOMO_SPIMD);
 
-	locomo_writel(0x00, lchip->base + LOCOMO_C32K);
-	locomo_writel(0x90, lchip->base + LOCOMO_TADC);
+	iowrite16(0x00, lchip->base + LOCOMO_C32K);
+	iowrite16(0x90, lchip->base + LOCOMO_TADC);
 
-	locomo_writel(0, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KSC);
-	r = locomo_readl(lchip->base + LOCOMO_KEYBOARD + LOCOMO_KIC);
+	iowrite16(0, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KSC);
+	r = ioread16(lchip->base + LOCOMO_KEYBOARD + LOCOMO_KIC);
 	r &= 0xFEFF;
-	locomo_writel(r, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KIC);
-	locomo_writel(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
+	iowrite16(r, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KIC);
+	iowrite16(0x1, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KCMD);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 
@@ -371,7 +375,7 @@ __locomo_probe(struct device *me, struct resource *mem, int irq)
 {
 	struct locomo_platform_data *pdata = me->platform_data;
 	struct locomo *lchip;
-	unsigned long r;
+	u16 r;
 	int i, ret = -ENODEV;
 
 	lchip = kzalloc(sizeof(struct locomo), GFP_KERNEL);
@@ -398,54 +402,53 @@ __locomo_probe(struct device *me, struct resource *mem, int irq)
 	}
 
 	/* locomo initialize */
-	locomo_writel(0, lchip->base + LOCOMO_ICR);
+	iowrite16(0, lchip->base + LOCOMO_ICR);
 	/* KEYBOARD */
-	locomo_writel(0, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KIC);
+	iowrite16(0, lchip->base + LOCOMO_KEYBOARD + LOCOMO_KIC);
 
 	/* GPIO */
-	locomo_writel(0, lchip->base + LOCOMO_GPO);
-	locomo_writel((LOCOMO_GPIO(1) | LOCOMO_GPIO(2) | LOCOMO_GPIO(13) | LOCOMO_GPIO(14))
-			, lchip->base + LOCOMO_GPE);
-	locomo_writel((LOCOMO_GPIO(1) | LOCOMO_GPIO(2) | LOCOMO_GPIO(13) | LOCOMO_GPIO(14))
-			, lchip->base + LOCOMO_GPD);
-	locomo_writel(0, lchip->base + LOCOMO_GIE);
+	iowrite16(0, lchip->base + LOCOMO_GPO);
+	r = LOCOMO_GPIO(1) | LOCOMO_GPIO(2) | LOCOMO_GPIO(13) | LOCOMO_GPIO(14);
+	iowrite16(r, lchip->base + LOCOMO_GPE);
+	iowrite16(r, lchip->base + LOCOMO_GPD);
+	iowrite16(0, lchip->base + LOCOMO_GIE);
 
 	/* Frontlight */
-	locomo_writel(0, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);
-	locomo_writel(0, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALD);
+	iowrite16(0, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);
+	iowrite16(0, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALD);
 
 	/* Longtime timer */
-	locomo_writel(0, lchip->base + LOCOMO_LTINT);
+	iowrite16(0, lchip->base + LOCOMO_LTINT);
 	/* SPI */
-	locomo_writel(0, lchip->base + LOCOMO_SPI + LOCOMO_SPIIE);
+	iowrite16(0, lchip->base + LOCOMO_SPI + LOCOMO_SPIIE);
 
-	locomo_writel(6 + 8 + 320 + 30 - 10, lchip->base + LOCOMO_ASD);
-	r = locomo_readl(lchip->base + LOCOMO_ASD);
+	iowrite16(6 + 8 + 320 + 30 - 10, lchip->base + LOCOMO_ASD);
+	r = ioread16(lchip->base + LOCOMO_ASD);
 	r |= 0x8000;
-	locomo_writel(r, lchip->base + LOCOMO_ASD);
+	iowrite16(r, lchip->base + LOCOMO_ASD);
 
-	locomo_writel(6 + 8 + 320 + 30 - 10 - 128 + 4, lchip->base + LOCOMO_HSD);
-	r = locomo_readl(lchip->base + LOCOMO_HSD);
+	iowrite16(6 + 8 + 320 + 30 - 10 - 128 + 4, lchip->base + LOCOMO_HSD);
+	r = ioread16(lchip->base + LOCOMO_HSD);
 	r |= 0x8000;
-	locomo_writel(r, lchip->base + LOCOMO_HSD);
+	iowrite16(r, lchip->base + LOCOMO_HSD);
 
-	locomo_writel(128 / 8, lchip->base + LOCOMO_HSC);
+	iowrite16(128 / 8, lchip->base + LOCOMO_HSC);
 
 	/* XON */
-	locomo_writel(0x80, lchip->base + LOCOMO_TADC);
+	iowrite16(0x80, lchip->base + LOCOMO_TADC);
 	udelay(1000);
 	/* CLK9MEN */
-	r = locomo_readl(lchip->base + LOCOMO_TADC);
+	r = ioread16(lchip->base + LOCOMO_TADC);
 	r |= 0x10;
-	locomo_writel(r, lchip->base + LOCOMO_TADC);
+	iowrite16(r, lchip->base + LOCOMO_TADC);
 	udelay(100);
 
 	/* init DAC */
-	r = locomo_readl(lchip->base + LOCOMO_DAC);
+	r = ioread16(lchip->base + LOCOMO_DAC);
 	r |= LOCOMO_DAC_SCLOEB | LOCOMO_DAC_SDAOEB;
-	locomo_writel(r, lchip->base + LOCOMO_DAC);
+	iowrite16(r, lchip->base + LOCOMO_DAC);
 
-	r = locomo_readl(lchip->base + LOCOMO_VER);
+	r = ioread16(lchip->base + LOCOMO_VER);
 	printk(KERN_INFO "LoCoMo Chip: %lu%lu\n", (r >> 8), (r & 0xff));
 
 	/*
@@ -541,26 +544,26 @@ void locomo_gpio_set_dir(struct device *dev, unsigned int bits, unsigned int dir
 {
 	struct locomo *lchip = dev_get_drvdata(dev);
 	unsigned long flags;
-	unsigned int r;
+	u16 r;
 
 	if (!lchip)
 		return;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
-	r = locomo_readl(lchip->base + LOCOMO_GPD);
+	r = ioread16(lchip->base + LOCOMO_GPD);
 	if (dir)
 		r |= bits;
 	else
 		r &= ~bits;
-	locomo_writel(r, lchip->base + LOCOMO_GPD);
+	iowrite16(r, lchip->base + LOCOMO_GPD);
 
-	r = locomo_readl(lchip->base + LOCOMO_GPE);
+	r = ioread16(lchip->base + LOCOMO_GPE);
 	if (dir)
 		r |= bits;
 	else
 		r &= ~bits;
-	locomo_writel(r, lchip->base + LOCOMO_GPE);
+	iowrite16(r, lchip->base + LOCOMO_GPE);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 }
@@ -570,13 +573,13 @@ int locomo_gpio_read_level(struct device *dev, unsigned int bits)
 {
 	struct locomo *lchip = dev_get_drvdata(dev);
 	unsigned long flags;
-	unsigned int ret;
+	u16 ret;
 
 	if (!lchip)
 		return -ENODEV;
 
 	spin_lock_irqsave(&lchip->lock, flags);
-	ret = locomo_readl(lchip->base + LOCOMO_GPL);
+	ret = ioread16(lchip->base + LOCOMO_GPL);
 	spin_unlock_irqrestore(&lchip->lock, flags);
 
 	ret &= bits;
@@ -588,13 +591,13 @@ int locomo_gpio_read_output(struct device *dev, unsigned int bits)
 {
 	struct locomo *lchip = dev_get_drvdata(dev);
 	unsigned long flags;
-	unsigned int ret;
+	u16 ret;
 
 	if (!lchip)
 		return -ENODEV;
 
 	spin_lock_irqsave(&lchip->lock, flags);
-	ret = locomo_readl(lchip->base + LOCOMO_GPO);
+	ret = ioread16(lchip->base + LOCOMO_GPO);
 	spin_unlock_irqrestore(&lchip->lock, flags);
 
 	ret &= bits;
@@ -606,19 +609,19 @@ void locomo_gpio_write(struct device *dev, unsigned int bits, unsigned int set)
 {
 	struct locomo *lchip = dev_get_drvdata(dev);
 	unsigned long flags;
-	unsigned int r;
+	u16 r;
 
 	if (!lchip)
 		return;
 
 	spin_lock_irqsave(&lchip->lock, flags);
 
-	r = locomo_readl(lchip->base + LOCOMO_GPO);
+	r = ioread16(lchip->base + LOCOMO_GPO);
 	if (set)
 		r |= bits;
 	else
 		r &= ~bits;
-	locomo_writel(r, lchip->base + LOCOMO_GPO);
+	iowrite16(r, lchip->base + LOCOMO_GPO);
 
 	spin_unlock_irqrestore(&lchip->lock, flags);
 }
@@ -626,35 +629,35 @@ EXPORT_SYMBOL(locomo_gpio_write);
 
 static void locomo_m62332_sendbit(void *mapbase, int bit)
 {
-	unsigned int r;
+	u16 r;
 
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SCLOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	udelay(DAC_DATA_HOLD_TIME);	/* 300 nsec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SCLOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	udelay(DAC_SCL_LOW_HOLD_TIME);	/* 4.7 usec */
 
 	if (bit & 1) {
-		r = locomo_readl(mapbase + LOCOMO_DAC);
+		r = ioread16(mapbase + LOCOMO_DAC);
 		r |=  LOCOMO_DAC_SDAOEB;
-		locomo_writel(r, mapbase + LOCOMO_DAC);
+		iowrite16(r, mapbase + LOCOMO_DAC);
 		udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	} else {
-		r = locomo_readl(mapbase + LOCOMO_DAC);
+		r = ioread16(mapbase + LOCOMO_DAC);
 		r &=  ~(LOCOMO_DAC_SDAOEB);
-		locomo_writel(r, mapbase + LOCOMO_DAC);
+		iowrite16(r, mapbase + LOCOMO_DAC);
 		udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	}
 
 	udelay(DAC_DATA_SETUP_TIME);	/* 250 nsec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/*  4.0 usec */
 }
@@ -664,7 +667,7 @@ void locomo_m62332_senddata(struct locomo_dev *ldev, unsigned int dac_data, int
 	struct locomo *lchip = locomo_chip_driver(ldev);
 	int i;
 	unsigned char data;
-	unsigned int r;
+	u16 r;
 	void *mapbase = lchip->base;
 	unsigned long flags;
 
@@ -672,14 +675,14 @@ void locomo_m62332_senddata(struct locomo_dev *ldev, unsigned int dac_data, int
 
 	/* Start */
 	udelay(DAC_BUS_FREE_TIME);	/* 5.0 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB | LOCOMO_DAC_SDAOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/* 4.0 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SDAOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_START_HOLD_TIME);	/* 5.0 usec */
 	udelay(DAC_DATA_HOLD_TIME);	/* 300 nsec */
 
@@ -690,21 +693,21 @@ void locomo_m62332_senddata(struct locomo_dev *ldev, unsigned int dac_data, int
 	}
 
 	/* Check A bit */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SCLOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	udelay(DAC_SCL_LOW_HOLD_TIME);	/* 4.7 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SDAOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/* 4.7 usec */
-	if (locomo_readl(mapbase + LOCOMO_DAC) & LOCOMO_DAC_SDAOEB) {	/* High is error */
+	if (ioread16(mapbase + LOCOMO_DAC) & LOCOMO_DAC_SDAOEB) {	/* High is error */
 		printk(KERN_WARNING "locomo: m62332_senddata Error 1\n");
 		goto out;
 	}
@@ -718,21 +721,21 @@ void locomo_m62332_senddata(struct locomo_dev *ldev, unsigned int dac_data, int
 	}
 
 	/* Check A bit */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SCLOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	udelay(DAC_SCL_LOW_HOLD_TIME);	/* 4.7 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SDAOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/* 4.7 usec */
-	if (locomo_readl(mapbase + LOCOMO_DAC) & LOCOMO_DAC_SDAOEB) {	/* High is error */
+	if (ioread16(mapbase + LOCOMO_DAC) & LOCOMO_DAC_SDAOEB) {	/* High is error */
 		printk(KERN_WARNING "locomo: m62332_senddata Error 2\n");
 		goto out;
 	}
@@ -743,45 +746,45 @@ void locomo_m62332_senddata(struct locomo_dev *ldev, unsigned int dac_data, int
 	}
 
 	/* Check A bit */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SCLOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	udelay(DAC_SCL_LOW_HOLD_TIME);	/* 4.7 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SDAOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/* 4.7 usec */
-	if (locomo_readl(mapbase + LOCOMO_DAC) & LOCOMO_DAC_SDAOEB) {	/* High is error */
+	if (ioread16(mapbase + LOCOMO_DAC) & LOCOMO_DAC_SDAOEB) {	/* High is error */
 		printk(KERN_WARNING "locomo: m62332_senddata Error 3\n");
 	}
 
 out:
 	/* stop */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r &=  ~(LOCOMO_DAC_SCLOEB);
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 300 nsec */
 	udelay(DAC_SCL_LOW_HOLD_TIME);	/* 4.7 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/* 4 usec */
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SDAOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_HIGH_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_HIGH_HOLD_TIME);	/* 4 usec */
 
-	r = locomo_readl(mapbase + LOCOMO_DAC);
+	r = ioread16(mapbase + LOCOMO_DAC);
 	r |=  LOCOMO_DAC_SCLOEB | LOCOMO_DAC_SDAOEB;
-	locomo_writel(r, mapbase + LOCOMO_DAC);
+	iowrite16(r, mapbase + LOCOMO_DAC);
 	udelay(DAC_LOW_SETUP_TIME);	/* 1000 nsec */
 	udelay(DAC_SCL_LOW_HOLD_TIME);	/* 4.7 usec */
 
@@ -804,10 +807,10 @@ void locomo_frontlight_set(struct locomo_dev *dev, int duty, int vr, int bpwf)
 		locomo_gpio_write(dev->dev.parent, LOCOMO_GPIO_FL_VR, 0);
 
 	spin_lock_irqsave(&lchip->lock, flags);
-	locomo_writel(bpwf, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);
+	iowrite16(bpwf, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);
 	udelay(100);
-	locomo_writel(duty, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALD);
-	locomo_writel(bpwf | LOCOMO_ALC_EN, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);
+	iowrite16(duty, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALD);
+	iowrite16(bpwf | LOCOMO_ALC_EN, lchip->base + LOCOMO_FRONTLIGHT + LOCOMO_ALS);
 	spin_unlock_irqrestore(&lchip->lock, flags);
 }
 EXPORT_SYMBOL(locomo_frontlight_set);
diff --git a/arch/arm/include/asm/hardware/locomo.h b/arch/arm/include/asm/hardware/locomo.h
index 74e51d6..dc90c21 100644
--- a/arch/arm/include/asm/hardware/locomo.h
+++ b/arch/arm/include/asm/hardware/locomo.h
@@ -13,9 +13,6 @@
 #ifndef _ASM_ARCH_LOCOMO
 #define _ASM_ARCH_LOCOMO
 
-#define locomo_writel(val,addr)	({ *(volatile u16 *)(addr) = (val); })
-#define locomo_readl(addr)	(*(volatile u16 *)(addr))
-
 /* LOCOMO version */
 #define LOCOMO_VER	0x00
 
diff --git a/drivers/input/keyboard/locomokbd.c b/drivers/input/keyboard/locomokbd.c
index b1ab298..ddb9595 100644
--- a/drivers/input/keyboard/locomokbd.c
+++ b/drivers/input/keyboard/locomokbd.c
@@ -31,6 +31,7 @@
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/ioport.h>
+#include <linux/io.h>
 
 #include <asm/hardware/locomo.h>
 #include <asm/irq.h>
@@ -86,35 +87,35 @@ struct locomokbd {
 /* helper functions for reading the keyboard matrix */
 static inline void locomokbd_charge_all(unsigned long membase)
 {
-	locomo_writel(0x00FF, membase + LOCOMO_KSC);
+	iowrite16(0x00FF, membase + LOCOMO_KSC);
 }
 
 static inline void locomokbd_activate_all(unsigned long membase)
 {
-	unsigned long r;
+	u16 r;
 
-	locomo_writel(0, membase + LOCOMO_KSC);
-	r = locomo_readl(membase + LOCOMO_KIC);
+	iowrite16(0, membase + LOCOMO_KSC);
+	r = ioread16(membase + LOCOMO_KIC);
 	r &= 0xFEFF;
-	locomo_writel(r, membase + LOCOMO_KIC);
+	iowrite16(r, membase + LOCOMO_KIC);
 }
 
 static inline void locomokbd_activate_col(unsigned long membase, int col)
 {
-	unsigned short nset;
-	unsigned short nbset;
+	u16 nset;
+	u16 nbset;
 
 	nset = 0xFF & ~(1 << col);
 	nbset = (nset << 8) + nset;
-	locomo_writel(nbset, membase + LOCOMO_KSC);
+	iowrite16(nbset, membase + LOCOMO_KSC);
 }
 
 static inline void locomokbd_reset_col(unsigned long membase, int col)
 {
-	unsigned short nbset;
+	u16 nbset;
 
 	nbset = ((0xFF & ~(1 << col)) << 8) + 0xFF;
-	locomo_writel(nbset, membase + LOCOMO_KSC);
+	iowrite16(nbset, membase + LOCOMO_KSC);
 }
 
 /*
@@ -126,7 +127,7 @@ static inline void locomokbd_reset_col(unsigned long membase, int col)
 /* Scan the hardware keyboard and push any changes up through the input layer */
 static void locomokbd_scankeyboard(struct locomokbd *locomokbd)
 {
-	unsigned int row, col, rowd;
+	u16 row, col, rowd;
 	unsigned long flags;
 	unsigned int num_pressed;
 	unsigned long membase = locomokbd->base;
@@ -141,7 +142,7 @@ static void locomokbd_scankeyboard(struct locomokbd *locomokbd)
 		locomokbd_activate_col(membase, col);
 		udelay(KB_DELAY);
 
-		rowd = ~locomo_readl(membase + LOCOMO_KIB);
+		rowd = ~ioread16(membase + LOCOMO_KIB);
 		for (row = 0; row < KB_ROWS; row++) {
 			unsigned int scancode, pressed, key;
 
@@ -194,11 +195,11 @@ static irqreturn_t locomokbd_interrupt(int irq, void *dev_id)
 	struct locomokbd *locomokbd = dev_id;
 	u16 r;
 
-	r = locomo_readl(locomokbd->base + LOCOMO_KIC);
+	r = ioread16(locomokbd->base + LOCOMO_KIC);
 	if ((r & 0x0001) == 0)
 		return IRQ_HANDLED;
 
-	locomo_writel(r & ~0x0100, locomokbd->base + LOCOMO_KIC); /* Ack */
+	iowrite16(r & ~0x0100, locomokbd->base + LOCOMO_KIC); /* Ack */
 
 	/** wait chattering delay **/
 	udelay(100);
@@ -222,8 +223,8 @@ static int locomokbd_open(struct input_dev *dev)
 	struct locomokbd *locomokbd = input_get_drvdata(dev);
 	u16 r;
 	
-	r = locomo_readl(locomokbd->base + LOCOMO_KIC) | 0x0010;
-	locomo_writel(r, locomokbd->base + LOCOMO_KIC);
+	r = ioread16(locomokbd->base + LOCOMO_KIC) | 0x0010;
+	iowrite16(r, locomokbd->base + LOCOMO_KIC);
 	return 0;
 }
 
@@ -232,8 +233,8 @@ static void locomokbd_close(struct input_dev *dev)
 	struct locomokbd *locomokbd = input_get_drvdata(dev);
 	u16 r;
 	
-	r = locomo_readl(locomokbd->base + LOCOMO_KIC) & ~0x0010;
-	locomo_writel(r, locomokbd->base + LOCOMO_KIC);
+	r = ioread16(locomokbd->base + LOCOMO_KIC) & ~0x0010;
+	iowrite16(r, locomokbd->base + LOCOMO_KIC);
 }
 
 static int __devinit locomokbd_probe(struct locomo_dev *dev)
diff --git a/drivers/leds/leds-locomo.c b/drivers/leds/leds-locomo.c
index 1f7c10f..6cc6b69 100644
--- a/drivers/leds/leds-locomo.c
+++ b/drivers/leds/leds-locomo.c
@@ -12,6 +12,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/leds.h>
+#include <linux/io.h>
 
 #include <mach/hardware.h>
 #include <asm/hardware/locomo.h>
@@ -24,9 +25,9 @@ static void locomoled_brightness_set(struct led_classdev *led_cdev,
 
 	local_irq_save(flags);
 	if (value)
-		locomo_writel(LOCOMO_LPT_TOFH, locomo_dev->mapbase + offset);
+		iowrite16(LOCOMO_LPT_TOFH, locomo_dev->mapbase + offset);
 	else
-		locomo_writel(LOCOMO_LPT_TOFL, locomo_dev->mapbase + offset);
+		iowrite16(LOCOMO_LPT_TOFL, locomo_dev->mapbase + offset);
 	local_irq_restore(flags);
 }
 
diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index be20b5c..37f325c 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -18,6 +18,7 @@
 #include <linux/interrupt.h>
 #include <linux/fb.h>
 #include <linux/backlight.h>
+#include <linux/io.h>
 
 #include <asm/hardware/locomo.h>
 #include <asm/irq.h>
@@ -49,13 +50,13 @@ static void locomolcd_on(int comadj)
 	mdelay(10);
 
 	/* TFTCRST | CPSOUT=0 | CPSEN */
-	locomo_writel(0x01, locomolcd_dev->mapbase + LOCOMO_TC);
+	iowrite16(0x01, locomolcd_dev->mapbase + LOCOMO_TC);
 
 	/* Set CPSD */
-	locomo_writel(6, locomolcd_dev->mapbase + LOCOMO_CPSD);
+	iowrite16(6, locomolcd_dev->mapbase + LOCOMO_CPSD);
 
 	/* TFTCRST | CPSOUT=0 | CPSEN */
-	locomo_writel((0x04 | 0x01), locomolcd_dev->mapbase + LOCOMO_TC);
+	iowrite16((0x04 | 0x01), locomolcd_dev->mapbase + LOCOMO_TC);
 	mdelay(10);
 
 	locomo_gpio_set_dir(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_MOD, 0);
@@ -65,7 +66,7 @@ static void locomolcd_on(int comadj)
 static void locomolcd_off(int comadj)
 {
 	/* TFTCRST=1 | CPSOUT=1 | CPSEN = 0 */
-	locomo_writel(0x06, locomolcd_dev->mapbase + LOCOMO_TC);
+	iowrite16(0x06, locomolcd_dev->mapbase + LOCOMO_TC);
 	mdelay(1);
 
 	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHA_ON, 0);
@@ -75,7 +76,7 @@ static void locomolcd_off(int comadj)
 	mdelay(700);
 
 	/* TFTCRST=0 | CPSOUT=0 | CPSEN = 0 */
-	locomo_writel(0, locomolcd_dev->mapbase + LOCOMO_TC);
+	iowrite16(0, locomolcd_dev->mapbase + LOCOMO_TC);
 	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_MOD, 0);
 	locomo_gpio_write(locomolcd_dev->dev.parent, LOCOMO_GPIO_LCD_VSHD_ON, 0);
 }
