Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0FUNdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:33:35 -0400
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:53590 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518Ab0FUNdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:33:33 -0400
Date: Mon, 21 Jun 2010 19:03:07 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       "l.fu@pengutronix.de" <l.fu@pengutronix.de>
Subject: Re: [PATCH 1/3] mfd: add STMPExxxx I/O Expander support
Message-ID: <20100621133305.GA2744@bnru02.bnr.st.com>
References: <1275308236-1775-1-git-send-email-rabin.vincent@stericsson.com>
 <20100618234222.GL3582@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100618234222.GL3582@sortiz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 19, 2010 at 01:42:24 +0200, Samuel Ortiz wrote:
> On Mon, May 31, 2010 at 05:47:14PM +0530, Rabin Vincent wrote:
> > Add support for the STMPExxxx family of I/O Expanders from
> > STMicroelectronics.  These devices include upto 24 gpios, a PWM
> > controller, and a keypad controller.  This patch adds the MFD core.
> The patchset looks fairly good, but before merging it I'd like to know of we
> could merge it with this one:
> https://patchwork.kernel.org/patch/106173/
> 
> I don't know enough about the hardware, and although the register layouts don't
> look like they have much in common, I'd like to know from the actual HW
> manufacturer (i.e. you :)) if there's something we can do here.

I don't have any inside information about these parts (we just use them
on our U8500 dev boards), but all the datasheets are publicly
available[1].  There seems to be more than a dozen variants of this MFD
with varying combinations of devices.

[1] http://www.st.com/stonline/stappl/productcatalog/app?path=/pages/stcom/PcStComPartNumberSearch.searchPartNumber&search=stmpe

On Sat, Jun 19, 2010 at 15:50:16 +0200, Luotao Fu wrote:
> hmm, I took a quick look into the core driver. The register layout
> seems, as Samuel mentioned, quite different. However, the r/w
> functionalities and irq handling are quite the same. For now I'd say
> that should be possible to merge the stuff.

The IRQ handling and GPIO block seem to be about the same (registers are
at different offsets, but this is also the case between STMPE1601 and
STMPE24XX and is thus already handled in the STMPExxxx driver).  The
STMPExxxx GPIO driver should also already be able to handle a variant
with lesser gpios, such as STMPE811.

Similarities:
 - I2C access functions
 - GPIO block (same registers, different offsets)
 - IRQ block (same registers and handling, different irqs and different
   register offsets)

Differences:
 - Different blocks (but sharing between different groups of variants)
 - SYSCTRL register bits (reset, clock enabling)
 - GPIO altfunc bits
 - The STMPE811 also has a SPI interface, while most other support only I2C
   This is also not avaiabile in Luotao's driver so I'm not addressing
   this for now.

Here's a preliminary patch (untested!) which shows how the STMPExxx can
be made more generic to support 811 and hopefully other variants.  If
this looks sane, I'll complete it up, fold it in, and repost the
STMPExxxx series for review and also 811 testing and touchscreen
addition from Luotao.

Rabin

---
 drivers/gpio/stmpe-gpio.c             |   13 +-
 drivers/input/keyboard/stmpe-keypad.c |    7 +-
 drivers/mfd/Makefile                  |    2 +-
 drivers/mfd/stmpe-variants.c          |  328 +++++++++++++++++++++++++++++++++
 drivers/mfd/stmpe.c                   |  261 +++++++++-----------------
 drivers/mfd/stmpe.h                   |  138 ++++++++++++++
 include/linux/mfd/stmpe.h             |   41 +++-
 7 files changed, 602 insertions(+), 188 deletions(-)
 create mode 100644 drivers/mfd/stmpe-variants.c
 create mode 100644 drivers/mfd/stmpe.h

diff --git a/drivers/gpio/stmpe-gpio.c b/drivers/gpio/stmpe-gpio.c
index 857d3f5..fac2cb5 100644
--- a/drivers/gpio/stmpe-gpio.c
+++ b/drivers/gpio/stmpe-gpio.c
@@ -297,12 +297,11 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 	stmpe_gpio->chip = template_chip;
 	stmpe_gpio->chip.ngpio = stmpe->num_gpios;
 	stmpe_gpio->chip.dev = &pdev->dev;
-	stmpe_gpio->chip.base = pdata->gpio_base;
+	stmpe_gpio->chip.base = pdata ? pdata->gpio_base : - 1;
 
 	stmpe_gpio->irq_base = stmpe->irq_base + STMPE_INT_GPIO(0);
 
-	ret = stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE_GPIO,
-			     STMPE_SYSCON_ENABLE_GPIO);
+	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
 	if (ret)
 		return ret;
 
@@ -323,6 +322,9 @@ static int __devinit stmpe_gpio_probe(struct platform_device *pdev)
 		goto out_freeirq;
 	}
 
+	if (pdata && pdata->setup)
+		pdata->setup(stmpe, stmpe_gpio->chip.base);
+
 	platform_set_drvdata(pdev, stmpe_gpio);
 
 	return 0;
@@ -342,6 +344,9 @@ static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 	int ret;
 
+	if (pdata && pdata->remove)
+		pdata->remove(stmpe_gpio->stmpe, stmpe_gpio->chip.base);
+
 	ret = gpiochip_remove(&stmpe_gpio->chip);
 	if (ret < 0) {
 		dev_err(stmpe_gpio->dev,
@@ -349,6 +354,8 @@ static int __devexit stmpe_gpio_remove(struct platform_device *pdev)
 		return ret;
 	}
 
+	stmpe_disable(stmpe_gpio->stmpe, STMPE_BLOCK_GPIO);
+
 	free_irq(irq, stmpe_gpio);
 	stmpe_gpio_irq_remove(stmpe_gpio);
 	platform_set_drvdata(pdev, NULL);
diff --git a/drivers/input/keyboard/stmpe-keypad.c b/drivers/input/keyboard/stmpe-keypad.c
index 1ef8875..efb02ba 100644
--- a/drivers/input/keyboard/stmpe-keypad.c
+++ b/drivers/input/keyboard/stmpe-keypad.c
@@ -219,8 +219,7 @@ static int __devinit stmpe_keypad_chip_init(struct stmpe_keypad *keypad)
 	if (plat->scan_count > STMPE_KEYPAD_MAX_SCAN_COUNT)
 		return -EINVAL;
 
-	ret = stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE_KPC,
-			     STMPE_SYSCON_ENABLE_KPC);
+	ret = stmpe_enable(stmpe, STMPE_BLOCK_KEYPAD);
 	if (ret < 0)
 		return ret;
 
@@ -312,7 +311,7 @@ static int __devinit stmpe_keypad_probe(struct platform_device *pdev)
 	keypad->stmpe = stmpe;
 	keypad->plat = plat;
 	keypad->input = input;
-	keypad->variant = &stmpe_keypad_variants[stmpe->variant];
+	keypad->variant = &stmpe_keypad_variants[stmpe->partnum];
 
 	ret = stmpe_keypad_chip_init(keypad);
 	if (ret < 0)
@@ -353,7 +352,7 @@ static int __devexit stmpe_keypad_remove(struct platform_device *pdev)
 	int irq = platform_get_irq(pdev, 0);
 
 	/* Disable the keypad module.  Ignore any errors. */
-	stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE_KPC, 0);
+	stmpe_disable(stmpe, STMPE_BLOCK_KEYPAD);
 
 	free_irq(irq, keypad);
 	input_unregister_device(keypad->input);
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 4410747..74ce677 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -15,7 +15,7 @@ obj-$(CONFIG_HTC_I2CPLD)	+= htc-i2cpld.o
 obj-$(CONFIG_MFD_DAVINCI_VOICECODEC)	+= davinci_voicecodec.o
 obj-$(CONFIG_MFD_DM355EVM_MSP)	+= dm355evm_msp.o
 
-obj-$(CONFIG_MFD_STMPE)		+= stmpe.o
+obj-$(CONFIG_MFD_STMPE)		+= stmpe.o stmpe-variants.o
 obj-$(CONFIG_MFD_TC35892)	+= tc35892.o
 obj-$(CONFIG_MFD_T7L66XB)	+= t7l66xb.o tmio_core.o
 obj-$(CONFIG_MFD_TC6387XB)	+= tc6387xb.o tmio_core.o
diff --git a/drivers/mfd/stmpe-variants.c b/drivers/mfd/stmpe-variants.c
new file mode 100644
index 0000000..49257c1
--- /dev/null
+++ b/drivers/mfd/stmpe-variants.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/stmpe.h>
+#include "stmpe.h"
+
+/*
+ * GPIO (all variants)
+ */
+
+static struct resource stmpe_gpio_resources[] = {
+	/* Start and end filled dynamically */
+	{
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_gpio_cell = {
+	.name		= "stmpe-gpio",
+	.resources	= stmpe_gpio_resources,
+	.num_resources	= ARRAY_SIZE(stmpe_gpio_resources),
+};
+
+/*
+ * Keypad (1601, 2401, 2403)
+ */
+
+static struct resource stmpe_keypad_resources[] = {
+	{
+		.name	= "KEYPAD",
+		.start	= 0,
+		.end	= 0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "KEYPAD_OVER",
+		.start	= 1,
+		.end	= 1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_keypad_cell = {
+	.name		= "stmpe-keypad",
+	.resources	= stmpe_keypad_resources,
+	.num_resources	= ARRAY_SIZE(stmpe_keypad_resources),
+};
+
+/*
+ * Touchscreen (STMPE811)
+ */
+
+static struct resource stmpe_ts_resources[] = {
+	{
+		.name	= "TOUCH_DET",
+		.start	= 0,
+		.end	= 0,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "FIFO_TH",
+		.start	= 1,
+		.end	= 1,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell stmpe_ts_cell = {
+	.name		= "stmpe-ts",
+	.resources	= stmpe_ts_resources,
+	.num_resources	= ARRAY_SIZE(stmpe_ts_resources),
+};
+
+/*
+ * STMPE811
+ */
+
+static const u8 stmpe811_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE811_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE811_REG_INT_CTRL,
+	[STMPE_IDX_IER_LSB]	= STMPE811_REG_INT_EN,
+	[STMPE_IDX_ISR_MSB]	= STMPE811_REG_INT_STA,
+	[STMPE_IDX_GPMR_LSB]	= STMPE811_REG_GPIO_MP_STA,
+	[STMPE_IDX_GPSR_LSB]	= STMPE811_REG_GPIO_SET_PIN,
+	[STMPE_IDX_GPCR_LSB]	= STMPE811_REG_GPIO_CLR_PIN,
+	[STMPE_IDX_GPDR_LSB]	= STMPE811_REG_GPIO_DIR,
+	[STMPE_IDX_GPRER_LSB]	= STMPE811_REG_GPIO_RE,
+	[STMPE_IDX_GPFER_LSB]	= STMPE811_REG_GPIO_FE,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE811_REG_GPIO_AF,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE811_REG_GPIO_INT_EN,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE811_REG_GPIO_INT_STA,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE811_REG_GPIO_ED,
+};
+
+static struct stmpe_variant_block stmpe811_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE811_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_ts_cell,
+		.irq	= STMPE811_IRQ_TOUCH_DET,
+		.block	= STMPE_BLOCK_TOUCHSCREEN,
+	},
+};
+
+static int stmpe811_enable(struct stmpe *stmpe, unsigned int blocks,
+			   bool enable)
+{
+	unsigned int mask = 0;
+
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE811_SYS_CTRL2_GPIO_OFF;
+
+	if (blocks & STMPE_BLOCK_ADC)
+		mask |= STMPE811_SYS_CTRL2_ADC_OFF;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE811_SYS_CTRL2_TSC_OFF;
+
+	return stmpe_set_bits(stmpe, STMPE811_REG_SYS_CTRL2, mask,
+			      enable ? 0 : mask);
+}
+
+static int stmpe811_get_altfunc(struct stmpe *stmpe, enum stmpe_block block)
+{
+	/* 0 for touchscreen, 1 for GPIO */
+	return block != STMPE_BLOCK_TOUCHSCREEN;
+}
+
+static struct stmpe_variant_info stmpe811 = {
+	.name		= "stmpe811",
+	.id_val		= 0x0811,
+	.id_mask	= 0xffff,
+	.num_gpios	= 8,
+	.af_per_reg	= 8,
+	.regs		= stmpe811_regs,
+	.blocks		= stmpe811_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe811_blocks),
+	.num_irqs	= STMPE811_NR_INTERNAL_IRQS,
+	.enable		= stmpe811_enable,
+	.get_altfunc	= stmpe811_get_altfunc,
+};
+
+/*
+ * STMPE1601
+ */
+
+static const u8 stmpe1601_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE1601_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE1601_REG_ICR_LSB,
+	[STMPE_IDX_IER_LSB]	= STMPE1601_REG_IER_LSB,
+	[STMPE_IDX_ISR_MSB]	= STMPE1601_REG_ISR_MSB,
+	[STMPE_IDX_GPMR_LSB]	= STMPE1601_REG_GPIO_MP_LSB,
+	[STMPE_IDX_GPSR_LSB]	= STMPE1601_REG_GPIO_SET_LSB,
+	[STMPE_IDX_GPCR_LSB]	= STMPE1601_REG_GPIO_CLR_LSB,
+	[STMPE_IDX_GPDR_LSB]	= STMPE1601_REG_GPIO_SET_DIR_LSB,
+	[STMPE_IDX_GPRER_LSB]	= STMPE1601_REG_GPIO_RE_LSB,
+	[STMPE_IDX_GPFER_LSB]	= STMPE1601_REG_GPIO_FE_LSB,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE1601_REG_GPIO_AF_U_MSB,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1601_REG_INT_EN_GPIO_MASK_LSB,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE1601_REG_INT_STA_GPIO_MSB,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE1601_REG_GPIO_ED_MSB,
+};
+
+static struct stmpe_variant_block stmpe1601_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE24XX_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_keypad_cell,
+		.irq	= STMPE24XX_IRQ_KEYPAD,
+		.block	= STMPE_BLOCK_KEYPAD,
+	},
+};
+
+static int stmpe1601_enable(struct stmpe *stmpe, unsigned int blocks,
+			    bool enable)
+{
+	unsigned int mask = 0;
+
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE1601_SYS_CTRL_ENABLE_GPIO;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE1601_SYS_CTRL_ENABLE_KPC;
+
+	return stmpe_set_bits(stmpe, STMPE1601_REG_SYS_CTRL, mask,
+			      enable ? mask : 0);
+}
+
+static int stmpe1601_get_altfunc(struct stmpe *stmpe, enum stmpe_block block)
+{
+	switch (block) {
+	case STMPE_BLOCK_PWM:
+		return 2;
+
+	case STMPE_BLOCK_KEYPAD:
+		return 1;
+
+	case STMPE_BLOCK_GPIO:
+	default:
+		return 0;
+	}
+}
+
+static struct stmpe_variant_info stmpe1601 = {
+	.name		= "stmpe1601",
+	.id_val		= 0x0210,
+	.id_mask	= 0xfff0,	/* at least 0x0210 and 0x0212 */
+	.num_gpios	= 16,
+	.af_per_reg	= 4,
+	.regs		= stmpe1601_regs,
+	.blocks		= stmpe1601_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe1601_blocks),
+	.num_irqs	= STMPE1601_NR_INTERNAL_IRQS,
+	.enable		= stmpe1601_enable,
+	.get_altfunc	= stmpe1601_get_altfunc,
+};
+
+/*
+ * STMPE24XX
+ */
+
+static const u8 stmpe24xx_regs[] = {
+	[STMPE_IDX_CHIP_ID]	= STMPE24XX_REG_CHIP_ID,
+	[STMPE_IDX_ICR_LSB]	= STMPE24XX_REG_ICR_LSB,
+	[STMPE_IDX_IER_LSB]	= STMPE24XX_REG_IER_LSB,
+	[STMPE_IDX_ISR_MSB]	= STMPE24XX_REG_ISR_MSB,
+	[STMPE_IDX_GPMR_LSB]	= STMPE24XX_REG_GPMR_LSB,
+	[STMPE_IDX_GPSR_LSB]	= STMPE24XX_REG_GPSR_LSB,
+	[STMPE_IDX_GPCR_LSB]	= STMPE24XX_REG_GPCR_LSB,
+	[STMPE_IDX_GPDR_LSB]	= STMPE24XX_REG_GPDR_LSB,
+	[STMPE_IDX_GPRER_LSB]	= STMPE24XX_REG_GPRER_LSB,
+	[STMPE_IDX_GPFER_LSB]	= STMPE24XX_REG_GPFER_LSB,
+	[STMPE_IDX_GPAFR_U_MSB]	= STMPE24XX_REG_GPAFR_U_MSB,
+	[STMPE_IDX_IEGPIOR_LSB]	= STMPE24XX_REG_IEGPIOR_LSB,
+	[STMPE_IDX_ISGPIOR_MSB]	= STMPE24XX_REG_ISGPIOR_MSB,
+	[STMPE_IDX_GPEDR_MSB]	= STMPE24XX_REG_GPEDR_MSB,
+};
+
+static struct stmpe_variant_block stmpe24xx_blocks[] = {
+	{
+		.cell	= &stmpe_gpio_cell,
+		.irq	= STMPE24XX_IRQ_GPIOC,
+		.block	= STMPE_BLOCK_GPIO,
+	},
+	{
+		.cell	= &stmpe_keypad_cell,
+		.irq	= STMPE24XX_IRQ_KEYPAD,
+		.block	= STMPE_BLOCK_KEYPAD,
+	},
+};
+
+static int stmpe24xx_enable(struct stmpe *stmpe, unsigned int blocks,
+			    bool enable)
+{
+	unsigned int mask = 0;
+
+	if (blocks & STMPE_BLOCK_GPIO)
+		mask |= STMPE24XX_SYS_CTRL_ENABLE_GPIO;
+
+	if (blocks & STMPE_BLOCK_KEYPAD)
+		mask |= STMPE24XX_SYS_CTRL_ENABLE_KPC;
+
+	return stmpe_set_bits(stmpe, STMPE24XX_REG_SYS_CTRL, mask,
+			      enable ? mask : 0);
+}
+
+static int stmpe24xx_get_altfunc(struct stmpe *stmpe, enum stmpe_block block)
+{
+	switch (block) {
+	case STMPE_BLOCK_ROTATOR:
+		return 2;
+
+	case STMPE_BLOCK_KEYPAD:
+		return 1;
+
+	case STMPE_BLOCK_GPIO:
+	default:
+		return 0;
+	}
+}
+
+static struct stmpe_variant_info stmpe2401 = {
+	.name		= "stmpe2401",
+	.id_val		= 0x0101,
+	.id_mask	= 0xffff,
+	.num_gpios	= 24,
+	.af_per_reg	= 4,
+	.regs		= stmpe24xx_regs,
+	.blocks		= stmpe24xx_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe24xx_blocks),
+	.num_irqs	= STMPE24XX_NR_INTERNAL_IRQS,
+	.enable		= stmpe24xx_enable,
+	.get_altfunc	= stmpe24xx_get_altfunc,
+};
+
+static struct stmpe_variant_info stmpe2403 = {
+	.name		= "stmpe2403",
+	.id_val		= 0x0120,
+	.id_mask	= 0xffff,
+	.num_gpios	= 24,
+	.af_per_reg	= 4,
+	.regs		= stmpe24xx_regs,
+	.blocks		= stmpe24xx_blocks,
+	.num_blocks	= ARRAY_SIZE(stmpe24xx_blocks),
+	.num_irqs	= STMPE24XX_NR_INTERNAL_IRQS,
+	.enable		= stmpe24xx_enable,
+	.get_altfunc	= stmpe24xx_get_altfunc,
+};
+
+struct stmpe_variant_info *stmpe_variant_info[] = {
+	[STMPE811]	= &stmpe811,
+	[STMPE1601]	= &stmpe1601,
+	[STMPE2401]	= &stmpe2401,
+	[STMPE2403]	= &stmpe2403,
+};
diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index 53e72b6..06ff885 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -13,84 +13,25 @@
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
 #include <linux/mfd/stmpe.h>
-
-/* Interrupts */
-#define STMPE_INT_GPIOC		8
-#define STMPE1601_INT_PWM3	7
-#define STMPE1601_INT_PWM2	6
-#define STMPE1601_INT_PWM1	5
-#define STMPE1601_INT_PWM0	4
-#define STMPE24XX_INT_PWM2	7
-#define STMPE24XX_INT_PWM1	6
-#define STMPE24XX_INT_PWM0	5
-#define STMPE24XX_INT_ROT_OVER	4
-#define STMPE24XX_INT_ROT	3
-#define STMPE_INT_KEYPAD_OVER	2
-#define STMPE_INT_KEYPAD	1
-#define STMPE_INT_WAKEUP	0
-
-/* Core registers at same addresses on all variants */
-#define STMPE_ICR_LSB		0x11
-#define STMPE_IER_LSB		0x13
-#define STMPE_ISR_MSB		0x14
-#define STMPE_CHIP_ID		0x80
+#include "stmpe.h"
 
 #define STMPE_ICR_LSB_HIGH	(1 << 2)
 #define STMPE_ICR_LSB_EDGE	(1 << 1)
 #define STMPE_ICR_LSB_GIM	(1 << 0)
 
-/*
- * The following registers are at different addresses on different variants.
- * We provide a set of register indices and a translation table.
- */
-
-#define STMPE1601_INT_EN_GPIO_MASK_LSB	0x17
-#define STMPE1601_INT_STA_GPIO_MSB	0x18
-#define STMPE1601_GPIO_MP_LSB		0x87
-#define STMPE1601_GPIO_SET_LSB		0x83
-#define STMPE1601_GPIO_CLR_LSB		0x85
-#define STMPE1601_GPIO_SET_DIR_LSB	0x89
-#define STMPE1601_GPIO_ED_MSB		0x8A
-#define STMPE1601_GPIO_RE_LSB		0x8D
-#define STMPE1601_GPIO_FE_LSB		0x8F
-#define STMPE1601_GPIO_AF_U_MSB		0x92
-
-#define STMPE24XX_IEGPIOR_LSB		0x18
-#define STMPE24XX_ISGPIOR_MSB		0x19
-#define STMPE24XX_GPMR_LSB		0xA5
-#define STMPE24XX_GPSR_LSB		0x85
-#define STMPE24XX_GPCR_LSB		0x88
-#define STMPE24XX_GPDR_LSB		0x8B
-#define STMPE24XX_GPEDR_MSB		0x8C
-#define STMPE24XX_GPRER_LSB		0x91
-#define STMPE24XX_GPFER_LSB		0x94
-#define STMPE24XX_GPAFR_U_MSB		0x9B
-
-static const u8 stmpe1601_regs[] = {
-	[STMPE_IDX_GPMR_LSB]	= STMPE1601_GPIO_MP_LSB,
-	[STMPE_IDX_GPSR_LSB]	= STMPE1601_GPIO_SET_LSB,
-	[STMPE_IDX_GPCR_LSB]	= STMPE1601_GPIO_CLR_LSB,
-	[STMPE_IDX_GPDR_LSB]	= STMPE1601_GPIO_SET_DIR_LSB,
-	[STMPE_IDX_GPRER_LSB]	= STMPE1601_GPIO_RE_LSB,
-	[STMPE_IDX_GPFER_LSB]	= STMPE1601_GPIO_FE_LSB,
-	[STMPE_IDX_GPAFR_U_MSB]	= STMPE1601_GPIO_AF_U_MSB,
-	[STMPE_IDX_IEGPIOR_LSB]	= STMPE1601_INT_EN_GPIO_MASK_LSB,
-	[STMPE_IDX_ISGPIOR_MSB]	= STMPE1601_INT_STA_GPIO_MSB,
-	[STMPE_IDX_GPEDR_MSB]	= STMPE1601_GPIO_ED_MSB,
-};
+int stmpe_enable(struct stmpe *stmpe, unsigned int blocks)
+{
+	struct stmpe_variant_info *variant = stmpe->variant;
+	return variant->enable(stmpe, blocks, true);
+}
+EXPORT_SYMBOL_GPL(stmpe_enable);
 
-static const u8 stmpe24xx_regs[] = {
-	[STMPE_IDX_GPMR_LSB]	= STMPE24XX_GPMR_LSB,
-	[STMPE_IDX_GPSR_LSB]	= STMPE24XX_GPSR_LSB,
-	[STMPE_IDX_GPCR_LSB]	= STMPE24XX_GPCR_LSB,
-	[STMPE_IDX_GPDR_LSB]	= STMPE24XX_GPDR_LSB,
-	[STMPE_IDX_GPRER_LSB]	= STMPE24XX_GPRER_LSB,
-	[STMPE_IDX_GPFER_LSB]	= STMPE24XX_GPFER_LSB,
-	[STMPE_IDX_GPAFR_U_MSB]	= STMPE24XX_GPAFR_U_MSB,
-	[STMPE_IDX_IEGPIOR_LSB]	= STMPE24XX_IEGPIOR_LSB,
-	[STMPE_IDX_ISGPIOR_MSB]	= STMPE24XX_ISGPIOR_MSB,
-	[STMPE_IDX_GPEDR_MSB]	= STMPE24XX_GPEDR_MSB,
-};
+int stmpe_disable(struct stmpe *stmpe, unsigned int blocks)
+{
+	struct stmpe_variant_info *variant = stmpe->variant;
+	return variant->enable(stmpe, blocks, false);
+}
+EXPORT_SYMBOL_GPL(stmpe_disable);
 
 /**
  * stmpe_reg_read() - read a single STMPE register
@@ -225,28 +166,23 @@ EXPORT_SYMBOL_GPL(stmpe_block_write);
  * If the GPIO module is not enabled, this function automatically enables it in
  * order to perform the change.
  */
-int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, int af)
+int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, enum stmpe_block block)
 {
+	struct stmpe_variant_info *variant = stmpe->variant;
 	u8 regaddr = stmpe->regs[STMPE_IDX_GPAFR_U_MSB];
-	int numregs = stmpe->num_gpios / 4;
+	int afperreg = variant->af_per_reg;
+	int numregs = stmpe->num_gpios / afperreg;
 	u8 regs[numregs];
-	bool gpioon;
-	int syscon;
+	int af;
 	int ret;
 
-	mutex_lock(&stmpe->lock);
+	ret = stmpe_enable(stmpe, STMPE_BLOCK_GPIO);
+	if (ret < 0)
+		return ret;
 
-	syscon = stmpe_reg_read(stmpe, STMPE_SYSCON);
-	if (syscon < 0)
-		return syscon;
+	mutex_lock(&stmpe->lock);
 
-	gpioon = syscon & STMPE_SYSCON_ENABLE_GPIO;
-	if (!gpioon) {
-		ret = stmpe_reg_write(stmpe, STMPE_SYSCON,
-				      syscon | STMPE_SYSCON_ENABLE_GPIO);
-		if (ret < 0)
-			return ret;
-	}
+	af = variant->get_altfunc(stmpe, block);
 
 	ret = stmpe_block_read(stmpe, regaddr, numregs, regs);
 	if (ret < 0)
@@ -254,10 +190,11 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, int af)
 
 	while (pins) {
 		int pin = __ffs(pins);
-		int regoffset = numregs - (pin / 4) - 1;
-		int pos = (pin % 4) * 2;
+		int regoffset = numregs - (pin / afperreg) - 1;
+		int pos = (pin % afperreg) * (8 / afperreg);
+		int mask = afperreg == 4 ? 0x3 : 1;
 
-		regs[regoffset] &= ~(0x3 << pos);
+		regs[regoffset] &= ~(mask << pos);
 		regs[regoffset] |= af << pos;
 
 		pins &= ~(1 << pin);
@@ -265,58 +202,23 @@ int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, int af)
 
 	ret = stmpe_block_write(stmpe, regaddr, numregs, regs);
 
-	if (!gpioon)
-		stmpe_reg_write(stmpe, STMPE_SYSCON, syscon);
-
 out:
 	mutex_unlock(&stmpe->lock);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(stmpe_set_altfunc);
 
-static struct resource gpio_resources[] = {
-	{
-		.start	= STMPE_INT_GPIOC,
-		.end	= STMPE_INT_GPIOC,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct resource keypad_resources[] = {
-	{
-		.start	= STMPE_INT_KEYPAD,
-		.end	= STMPE_INT_KEYPAD,
-		.flags	= IORESOURCE_IRQ,
-	},
-	{
-		.start	= STMPE_INT_KEYPAD_OVER,
-		.end	= STMPE_INT_KEYPAD_OVER,
-		.flags	= IORESOURCE_IRQ,
-	},
-};
-
-static struct mfd_cell stmpe_devs[] = {
-	{
-		.name		= "stmpe-gpio",
-		.resources	= gpio_resources,
-		.num_resources	= ARRAY_SIZE(gpio_resources),
-	},
-	{
-		.name		= "stmpe-keypad",
-		.resources	= keypad_resources,
-		.num_resources	= ARRAY_SIZE(keypad_resources),
-	},
-};
-
 static irqreturn_t stmpe_irq(int irq, void *data)
 {
 	struct stmpe *stmpe = data;
-	int num = ARRAY_SIZE(stmpe->ier);
+	struct stmpe_variant_info *variant = stmpe->variant;
+	int num = DIV_ROUND_UP(variant->num_irqs, 8);
+	u8 israddr = stmpe->regs[STMPE_IDX_ISR_MSB];
 	u8 isr[num];
 	int ret;
 	int i;
 
-	ret = stmpe_block_read(stmpe, STMPE_ISR_MSB, num, isr);
+	ret = stmpe_block_read(stmpe, israddr, num, isr);
 	if (ret < 0)
 		return IRQ_NONE;
 
@@ -338,7 +240,7 @@ static irqreturn_t stmpe_irq(int irq, void *data)
 			status &= ~(1 << bit);
 		}
 
-		stmpe_reg_write(stmpe, STMPE_ISR_MSB + i, clear);
+		stmpe_reg_write(stmpe, israddr + i, clear);
 	}
 
 	return IRQ_HANDLED;
@@ -354,9 +256,11 @@ static void stmpe_irq_lock(unsigned int irq)
 static void stmpe_irq_sync_unlock(unsigned int irq)
 {
 	struct stmpe *stmpe = get_irq_chip_data(irq);
+	struct stmpe_variant_info *variant = stmpe->variant;
+	int num = DIV_ROUND_UP(variant->num_irqs, 8);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(stmpe->ier); i++) {
+	for (i = 0; i < num; i++) {
 		u8 new = stmpe->ier[i];
 		u8 old = stmpe->oldier[i];
 
@@ -364,7 +268,7 @@ static void stmpe_irq_sync_unlock(unsigned int irq)
 			continue;
 
 		stmpe->oldier[i] = new;
-		stmpe_reg_write(stmpe, STMPE_IER_LSB - i, new);
+		stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_IER_LSB] - i, new);
 	}
 
 	mutex_unlock(&stmpe->irq_lock);
@@ -400,10 +304,11 @@ static struct irq_chip stmpe_irq_chip = {
 
 static int __devinit stmpe_irq_init(struct stmpe *stmpe)
 {
+	int num_irqs = stmpe->variant->num_irqs;
 	int base = stmpe->irq_base;
 	int irq;
 
-	for (irq = base; irq < base + STMPE_NR_INTERNAL_IRQS; irq++) {
+	for (irq = base; irq < base + num_irqs; irq++) {
 		set_irq_chip_data(irq, stmpe);
 		set_irq_chip_and_handler(irq, &stmpe_irq_chip,
 					 handle_edge_irq);
@@ -420,10 +325,11 @@ static int __devinit stmpe_irq_init(struct stmpe *stmpe)
 
 static void stmpe_irq_remove(struct stmpe *stmpe)
 {
+	int num_irqs = stmpe->variant->num_irqs;
 	int base = stmpe->irq_base;
 	int irq;
 
-	for (irq = base; irq < base + STMPE_NR_INTERNAL_IRQS; irq++) {
+	for (irq = base; irq < base + num_irqs; irq++) {
 #ifdef CONFIG_ARM
 		set_irq_flags(irq, 0);
 #endif
@@ -435,50 +341,27 @@ static void stmpe_irq_remove(struct stmpe *stmpe)
 static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 {
 	unsigned int irq_trigger = stmpe->pdata->irq_trigger;
+	struct stmpe_variant_info *variant = stmpe->variant;
 	u8 icr = STMPE_ICR_LSB_GIM;
-	const char *name;
 	unsigned int id;
 	u8 data[2];
 	int ret;
 
-	ret = stmpe_block_read(stmpe, STMPE_CHIP_ID, ARRAY_SIZE(data), data);
+	ret = stmpe_block_read(stmpe, stmpe->regs[STMPE_IDX_CHIP_ID],
+			       ARRAY_SIZE(data), data);
 	if (ret < 0)
 		return ret;
 
 	id = (data[0] << 8) | data[1];
-
-	switch (id) {
-	case 0x0210:
-	case 0x0212:
-		name = "STMPE1601";
-		stmpe->variant = STMPE1601;
-		stmpe->regs = stmpe1601_regs;
-		stmpe->num_gpios = 16;
-		break;
-
-	case 0x0101:
-		name = "STMPE2401";
-		stmpe->variant = STMPE2401;
-		stmpe->regs = stmpe24xx_regs;
-		stmpe->num_gpios = 24;
-		break;
-
-	case 0x0120:
-		name = "STMPE2403";
-		stmpe->variant = STMPE2403;
-		stmpe->regs = stmpe24xx_regs;
-		stmpe->num_gpios = 24;
-		break;
-
-	default:
-		dev_err(stmpe->dev, "unknown id: %#x\n", id);
+	if ((id & variant->id_mask) != variant->id_val) {
+		dev_err(stmpe->dev, "unknown chip id: %#x\n", id);
 		return -EINVAL;
 	}
 
-	dev_info(stmpe->dev, "%s detected\n", name);
+	dev_info(stmpe->dev, "%s detected, chip id: %#x\n", variant->name, id);
 
 	/* Disable all modules -- subdrivers should enable what they need. */
-	ret = stmpe_set_bits(stmpe, STMPE_SYSCON, STMPE_SYSCON_ENABLE, 0);
+	ret = stmpe_disable(stmpe, ~0);
 	if (ret)
 		return ret;
 
@@ -490,7 +373,42 @@ static int __devinit stmpe_chip_init(struct stmpe *stmpe)
 	    irq_trigger == IRQF_TRIGGER_HIGH)
 		icr |= STMPE_ICR_LSB_HIGH;
 
-	return stmpe_reg_write(stmpe, STMPE_ICR_LSB, icr);
+	if (stmpe->pdata->irq_invert_polarity)
+		icr ^= STMPE_ICR_LSB_HIGH;
+
+	return stmpe_reg_write(stmpe, stmpe->regs[STMPE_IDX_ICR_LSB], icr);
+}
+
+static int __devinit stmpe_add_device(struct stmpe *stmpe,
+				      struct mfd_cell *cell, int irq)
+{
+	return mfd_add_devices(stmpe->dev, stmpe->pdata->id, cell, 1,
+			       NULL, stmpe->irq_base + irq);
+}
+
+static int __devinit stmpe_devices_init(struct stmpe *stmpe)
+{
+	struct stmpe_variant_info *variant = stmpe->variant;
+	unsigned int platform_blocks = stmpe->pdata->blocks;
+	int ret;
+	int i;
+
+	for (i = 0; i < variant->num_blocks; i++) {
+		struct stmpe_variant_block *block = &variant->blocks[i];
+
+		if (!(platform_blocks & block->block))
+			continue;
+
+		platform_blocks &= ~block->block;
+		ret = stmpe_add_device(stmpe, block->cell, block->irq);
+	}
+
+	if (platform_blocks)
+		dev_warn(stmpe->dev,
+			 "platform wants blocks (%#x) not present on variant",
+			 platform_blocks);
+
+	return ret;
 }
 
 static int __devinit stmpe_probe(struct i2c_client *i2c,
@@ -516,6 +434,10 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 	stmpe->pdata = pdata;
 	stmpe->irq_base = pdata->irq_base;
 
+	stmpe->partnum = id->driver_data;
+	stmpe->variant = stmpe_variant_info[stmpe->partnum];
+	stmpe->regs = stmpe->variant->regs;
+
 	i2c_set_clientdata(i2c, stmpe);
 
 	ret = stmpe_chip_init(stmpe);
@@ -534,9 +456,7 @@ static int __devinit stmpe_probe(struct i2c_client *i2c,
 		goto out_removeirq;
 	}
 
-	ret = mfd_add_devices(stmpe->dev, pdata->id, stmpe_devs,
-			      ARRAY_SIZE(stmpe_devs), NULL,
-			      stmpe->irq_base);
+	ret = stmpe_devices_init(stmpe);
 	if (ret) {
 		dev_err(stmpe->dev, "failed to add children\n");
 		goto out_freeirq;
@@ -570,7 +490,10 @@ static int __devexit stmpe_remove(struct i2c_client *client)
 }
 
 static const struct i2c_device_id stmpe_id[] = {
-	{ "stmpe", 0 },
+	{ "stmpe811", STMPE811 },
+	{ "stmpe1601", STMPE1601 },
+	{ "stmpe2401", STMPE2401 },
+	{ "stmpe2403", STMPE2403 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, stmpe_id);
diff --git a/drivers/mfd/stmpe.h b/drivers/mfd/stmpe.h
new file mode 100644
index 0000000..b1e4815
--- /dev/null
+++ b/drivers/mfd/stmpe.h
@@ -0,0 +1,138 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License, version 2
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
+ */
+
+#ifndef __STMPE_H
+#define __STMPE_H
+
+struct stmpe_variant_block {
+	struct mfd_cell		*cell;
+	int			irq;
+	enum stmpe_block	block;
+};
+
+struct stmpe_variant_info {
+	const char *name;
+	u16 id_val;
+	u16 id_mask;
+	int num_gpios;
+	int af_per_reg;
+	const u8 *regs;
+	struct stmpe_variant_block *blocks;
+	int num_blocks;
+	int num_irqs;
+	int (*enable)(struct stmpe *stmpe, unsigned int blocks, bool enable);
+	int (*get_altfunc)(struct stmpe *stmpe, enum stmpe_block block);
+};
+
+extern struct stmpe_variant_info *stmpe_variant_info[];
+
+/*
+ * STMPE811
+ */
+
+#define STMPE811_IRQ_TOUCH_DET		0
+#define STMPE811_IRQ_FIFO_TH		1
+#define STMPE811_IRQ_FIFO_OFLOW		2
+#define STMPE811_IRQ_FIFO_FULL		3
+#define STMPE811_IRQ_FIFO_EMPTY		4
+#define STMPE811_IRQ_TEMP_SENS		5
+#define STMPE811_IRQ_ADC		6
+#define STMPE811_IRQ_GPIOC		7
+#define STMPE811_NR_INTERNAL_IRQS	8
+
+#define STMPE811_REG_CHIP_ID		0x00
+#define STMPE811_REG_SYS_CTRL2		0x04
+#define STMPE811_REG_INT_CTRL		0x09
+#define STMPE811_REG_INT_EN		0x0A
+#define STMPE811_REG_INT_STA		0x0B
+#define STMPE811_REG_GPIO_INT_EN	0x0C
+#define STMPE811_REG_GPIO_INT_STA	0x0D
+#define STMPE811_REG_GPIO_SET_PIN	0x10
+#define STMPE811_REG_GPIO_CLR_PIN	0x11
+#define STMPE811_REG_GPIO_MP_STA	0x12
+#define STMPE811_REG_GPIO_DIR		0x13
+#define STMPE811_REG_GPIO_ED		0x14
+#define STMPE811_REG_GPIO_RE		0x15
+#define STMPE811_REG_GPIO_FE		0x16
+#define STMPE811_REG_GPIO_AF		0x17
+
+#define STMPE811_SYS_CTRL2_ADC_OFF	(1 << 0)
+#define STMPE811_SYS_CTRL2_TSC_OFF	(1 << 1)
+#define STMPE811_SYS_CTRL2_GPIO_OFF	(1 << 2)
+#define STMPE811_SYS_CTRL2_TS_OFF	(1 << 3)
+
+/*
+ * STMPE1601
+ */
+
+#define STMPE1601_IRQ_GPIOC		8
+#define STMPE1601_IRQ_PWM3		7
+#define STMPE1601_IRQ_PWM2		6
+#define STMPE1601_IRQ_PWM1		5
+#define STMPE1601_IRQ_PWM0		4
+#define STMPE1601_IRQ_KEYPAD_OVER	2
+#define STMPE1601_IRQ_KEYPAD		1
+#define STMPE1601_IRQ_WAKEUP		0
+#define STMPE1601_NR_INTERNAL_IRQS	9
+
+#define STMPE1601_REG_SYS_CTRL			0x02
+#define STMPE1601_REG_ICR_LSB			0x11
+#define STMPE1601_REG_IER_LSB			0x13
+#define STMPE1601_REG_ISR_MSB			0x14
+#define STMPE1601_REG_CHIP_ID			0x80
+#define STMPE1601_REG_INT_EN_GPIO_MASK_LSB	0x17
+#define STMPE1601_REG_INT_STA_GPIO_MSB		0x18
+#define STMPE1601_REG_GPIO_MP_LSB		0x87
+#define STMPE1601_REG_GPIO_SET_LSB		0x83
+#define STMPE1601_REG_GPIO_CLR_LSB		0x85
+#define STMPE1601_REG_GPIO_SET_DIR_LSB		0x89
+#define STMPE1601_REG_GPIO_ED_MSB		0x8A
+#define STMPE1601_REG_GPIO_RE_LSB		0x8D
+#define STMPE1601_REG_GPIO_FE_LSB		0x8F
+#define STMPE1601_REG_GPIO_AF_U_MSB		0x92
+
+#define STMPE1601_SYS_CTRL_ENABLE_GPIO		(1 << 3)
+#define STMPE1601_SYS_CTRL_ENABLE_KPC		(1 << 1)
+#define STMPE1601_SYSCON_ENABLE_SPWM		(1 << 0)
+
+/*
+ * STMPE24xx
+ */
+
+#define STMPE24XX_IRQ_GPIOC		8
+#define STMPE24XX_IRQ_PWM2		7
+#define STMPE24XX_IRQ_PWM1		6
+#define STMPE24XX_IRQ_PWM0		5
+#define STMPE24XX_IRQ_ROT_OVER		4
+#define STMPE24XX_IRQ_ROT		3
+#define STMPE24XX_IRQ_KEYPAD_OVER	2
+#define STMPE24XX_IRQ_KEYPAD		1
+#define STMPE24XX_IRQ_WAKEUP		0
+#define STMPE24XX_NR_INTERNAL_IRQS	9
+
+#define STMPE24XX_REG_SYS_CTRL		0x02
+#define STMPE24XX_REG_ICR_LSB		0x11
+#define STMPE24XX_REG_IER_LSB		0x13
+#define STMPE24XX_REG_ISR_MSB		0x14
+#define STMPE24XX_REG_CHIP_ID		0x80
+#define STMPE24XX_REG_IEGPIOR_LSB	0x18
+#define STMPE24XX_REG_ISGPIOR_MSB	0x19
+#define STMPE24XX_REG_GPMR_LSB		0xA5
+#define STMPE24XX_REG_GPSR_LSB		0x85
+#define STMPE24XX_REG_GPCR_LSB		0x88
+#define STMPE24XX_REG_GPDR_LSB		0x8B
+#define STMPE24XX_REG_GPEDR_MSB		0x8C
+#define STMPE24XX_REG_GPRER_LSB		0x91
+#define STMPE24XX_REG_GPFER_LSB		0x94
+#define STMPE24XX_REG_GPAFR_U_MSB	0x9B
+
+#define STMPE24XX_SYS_CTRL_ENABLE_GPIO		(1 << 3)
+#define STMPE24XX_SYSCON_ENABLE_PWM		(1 << 2)
+#define STMPE24XX_SYS_CTRL_ENABLE_KPC		(1 << 1)
+#define STMPE24XX_SYSCON_ENABLE_ROT		(1 << 0)
+
+#endif
diff --git a/include/linux/mfd/stmpe.h b/include/linux/mfd/stmpe.h
index 7c6733b..cf2155f 100644
--- a/include/linux/mfd/stmpe.h
+++ b/include/linux/mfd/stmpe.h
@@ -10,16 +10,17 @@
 
 #include <linux/device.h>
 
-#define STMPE_SYSCON			0x02
-
-#define STMPE_SYSCON_ENABLE		(0xf << 0)
-#define STMPE_SYSCON_ENABLE_GPIO	(1 << 3)
-#define STMPE24XX_SYSCON_ENABLE_PWM	(1 << 2)
-#define STMPE_SYSCON_ENABLE_KPC		(1 << 1)
-#define STMPE16XX_SYSCON_ENABLE_SPWM	(1 << 0)
-#define STMPE24XX_SYSCON_ENABLE_ROT	(1 << 0)
+enum stmpe_block {
+	STMPE_BLOCK_GPIO	= 1 << 0,
+	STMPE_BLOCK_KEYPAD	= 1 << 1,
+	STMPE_BLOCK_TOUCHSCREEN	= 1 << 2,
+	STMPE_BLOCK_ADC		= 1 << 3,
+	STMPE_BLOCK_PWM		= 1 << 4,
+	STMPE_BLOCK_ROTATOR	= 1 << 5,
+};
 
-enum stmpe_variant {
+enum stmpe_partnum {
+	STMPE811,
 	STMPE1601,
 	STMPE2401,
 	STMPE2403,
@@ -30,6 +31,10 @@ enum stmpe_variant {
  * obtained by indexing stmpe->regs with one of the following.
  */
 enum {
+	STMPE_IDX_CHIP_ID,
+	STMPE_IDX_ICR_LSB,
+	STMPE_IDX_IER_LSB,
+	STMPE_IDX_ISR_MSB,
 	STMPE_IDX_GPMR_LSB,
 	STMPE_IDX_GPSR_LSB,
 	STMPE_IDX_GPCR_LSB,
@@ -40,8 +45,12 @@ enum {
 	STMPE_IDX_GPAFR_U_MSB,
 	STMPE_IDX_IEGPIOR_LSB,
 	STMPE_IDX_ISGPIOR_MSB,
+	STMPE_IDX_MAX,
 };
 
+
+struct stmpe_variant_info;
+
 /**
  * struct stmpe - STMPE MFD structure
  * @lock: lock protecting I/O operations
@@ -62,7 +71,8 @@ struct stmpe {
 	struct mutex irq_lock;
 	struct device *dev;
 	struct i2c_client *i2c;
-	enum stmpe_variant variant;
+	enum stmpe_partnum partnum;
+	struct stmpe_variant_info *variant;
 	const u8 *regs;
 
 	int irq_base;
@@ -79,7 +89,10 @@ extern int stmpe_block_read(struct stmpe *stmpe, u8 reg, u8 length,
 extern int stmpe_block_write(struct stmpe *stmpe, u8 reg, u8 length,
 			     const u8 *values);
 extern int stmpe_set_bits(struct stmpe *stmpe, u8 reg, u8 mask, u8 val);
-extern int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins, int af);
+extern int stmpe_set_altfunc(struct stmpe *stmpe, u32 pins,
+			     enum stmpe_block block);
+extern int stmpe_enable(struct stmpe *stmpe, unsigned int blocks);
+extern int stmpe_disable(struct stmpe *stmpe, unsigned int blocks);
 
 struct matrix_keymap_data;
 
@@ -106,12 +119,16 @@ struct stmpe_keypad_platform_data {
  */
 struct stmpe_gpio_platform_data {
 	int gpio_base;
+	void (*setup)(struct stmpe *stmpe, unsigned gpio_base);
+	void (*remove)(struct stmpe *stmpe, unsigned gpio_base);
 };
 
 /**
  * struct stmpe_platform_data - STMPE platform data
  * @id: device id to distinguish between multiple STMPEs on the same board
+ * @blocks: bitmask of blocks to enable (use STMPE_BLOCK_*)
  * @irq_trigger: IRQ trigger to use for the interrupt to the host
+ * @irq_invert_polarity: IRQ line is connected with reversed polarity
  * @irq_base: base IRQ number.  %STMPE_NR_IRQS irqs will be used, or
  *	      %STMPE_NR_INTERNAL_IRQS if the GPIO driver is not used.
  * @gpio: GPIO-specific platform data
@@ -119,8 +136,10 @@ struct stmpe_gpio_platform_data {
  */
 struct stmpe_platform_data {
 	int id;
+	unsigned int blocks;
 	int irq_base;
 	unsigned int irq_trigger;
+	bool irq_invert_polarity;
 
 	struct stmpe_gpio_platform_data *gpio;
 	struct stmpe_keypad_platform_data *keypad;
-- 
1.7.0

