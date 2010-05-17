Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab0EQQAY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 12:00:24 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:35471 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751648Ab0EQQAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 12:00:22 -0400
Date: Mon, 17 May 2010 21:30:06 +0530
From: Rabin VINCENT <rabin.vincent@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
       Linus WALLEIJ <linus.walleij@stericsson.com>,
       Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: new AB8500 driver
Message-ID: <20100517160005.GA32741@bnru02.bnr.st.com>
References: <1273553131-9312-1-git-send-email-rabin.vincent@stericsson.com>
 <20100516225355.GF3236@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100516225355.GF3236@sortiz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Mon, May 17, 2010 at 00:53:55 +0200, Samuel Ortiz wrote:
> On Tue, May 11, 2010 at 10:15:31AM +0530, Rabin Vincent wrote:
> > Add a new driver to support the AB8500 Power Management chip, replacing
> > the current AB4500.  The new driver replaces the old one, instead of an
> > incremental modification, because this is a substantial overhaul
> > including:
> > 
> >  - Split of the driver into -core and -spi portions, to allow another
> >    interface layer to be added
> > 
> >  - Addition of interrupt support
> > 
> >  - Switch to MFD core API for handling subdevices
> > 
> >  - Simplification of the APIs to remove a redundant block parameter
> > 
> >  - Rename of the APIs and macros from ab4500_* to ab8500_*
> > 
> >  - Rename of the files from ab4500* to ab8500*
> > 
> > The driver still identifes itself as "ab4500" 
> The patch looks good, but why not changing that to "ab8500" and integrating
> the relevant board file changes to this patch ?

I originally didn't do this because I thought that this would create
merge conflicts with some code movement in the arm tree, but looks like
I was wrong -- there won't be conflicts for this change.

So, the updated patch below also includes the board file change to
change the driver name from ab4500 to ab8500.  (It also includes a small
fix to the interrupt handling, found after the previous version was
sent.)

Rabin

>From 6ae3ed931d495a1311f052360f8e78c02b66f5ca Mon Sep 17 00:00:00 2001
From: Rabin Vincent <rabin.vincent@stericsson.com>
Date: Fri, 30 Apr 2010 09:07:15 +0530
Subject: [PATCH] mfd: new AB8500 driver

Add a new driver to support the AB8500 Power Management chip, replacing
the current AB4500.  The new driver replaces the old one, instead of an
incremental modification, because this is a substantial overhaul
including:

 - Split of the driver into -core and -spi portions, to allow another
   interface layer to be added

 - Addition of interrupt support

 - Switch to MFD core API for handling subdevices

 - Simplification of the APIs to remove a redundant block parameter

 - Rename of the APIs and macros from ab4500_* to ab8500_*

 - Rename of the files from ab4500* to ab8500*

 - Change of the driver name from ab4500 to ab8500

Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Acked-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c |    2 +-
 drivers/mfd/Kconfig                |    9 +-
 drivers/mfd/Makefile               |    2 +-
 drivers/mfd/ab4500-core.c          |  209 -----------------
 drivers/mfd/ab8500-core.c          |  442 ++++++++++++++++++++++++++++++++++++
 drivers/mfd/ab8500-spi.c           |  133 +++++++++++
 include/linux/mfd/ab4500.h         |  262 ---------------------
 include/linux/mfd/ab8500.h         |  128 +++++++++++
 8 files changed, 710 insertions(+), 477 deletions(-)
 delete mode 100644 drivers/mfd/ab4500-core.c
 create mode 100644 drivers/mfd/ab8500-core.c
 create mode 100644 drivers/mfd/ab8500-spi.c
 delete mode 100644 include/linux/mfd/ab4500.h
 create mode 100644 include/linux/mfd/ab8500.h

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 072196c..bb8d7b7 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -50,7 +50,7 @@ struct pl022_config_chip ab4500_chip_info = {
 
 static struct spi_board_info u8500_spi_devices[] = {
 	{
-		.modalias = "ab4500",
+		.modalias = "ab8500",
 		.controller_data = &ab4500_chip_info,
 		.max_speed_hz = 12000000,
 		.bus_num = 0,
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index fea62a9..07f58b3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -414,11 +414,12 @@ config EZX_PCAP
 	  This enables the PCAP ASIC present on EZX Phones. This is
 	  needed for MMC, TouchScreen, Sound, USB, etc..
 
-config AB4500_CORE
-	tristate "ST-Ericsson's AB4500 Mixed Signal Power management chip"
-	depends on SPI
+config AB8500_CORE
+	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
+	depends on SPI=y && GENERIC_HARDIRQS
+	select MFD_CORE
 	help
-	  Select this option to enable access to AB4500 power management
+	  Select this option to enable access to AB8500 power management
 	  chip. This connects to U8500 on the SSP/SPI bus and exports
 	  read/write functions for the devices to get access to this chip.
 	  This chip embeds various other multimedia funtionalities as well.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index ca1517e..fb503e7 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -64,8 +64,8 @@ obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_ABX500_CORE)	+= abx500-core.o
 obj-$(CONFIG_AB3100_CORE)	+= ab3100-core.o
 obj-$(CONFIG_AB3100_OTP)	+= ab3100-otp.o
-obj-$(CONFIG_AB4500_CORE)	+= ab4500-core.o
 obj-$(CONFIG_AB3550_CORE)	+= ab3550-core.o
+obj-$(CONFIG_AB8500_CORE)	+= ab8500-core.o ab8500-spi.o
 obj-$(CONFIG_MFD_TIMBERDALE)    += timberdale.o
 obj-$(CONFIG_PMIC_ADP5520)	+= adp5520.o
 obj-$(CONFIG_LPC_SCH)		+= lpc_sch.o
diff --git a/drivers/mfd/ab4500-core.c b/drivers/mfd/ab4500-core.c
deleted file mode 100644
index c275daa..0000000
--- a/drivers/mfd/ab4500-core.c
+++ /dev/null
@@ -1,209 +0,0 @@
-/*
- * Copyright (C) 2009 ST-Ericsson
- *
- * Author: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
- *
- * This program is free software; you can redistribute it
- * and/or modify it under the terms of the GNU General Public
- * License version 2, as published by the Free Software Foundation.
- *
- * AB4500 is a companion power management chip used with U8500.
- * On this platform, this is interfaced with SSP0 controller
- * which is a ARM primecell pl022.
- *
- * At the moment the module just exports read/write features.
- * Interrupt management to be added - TODO.
- */
-#include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/spi/spi.h>
-#include <linux/mfd/ab4500.h>
-
-/* just required if probe fails, we need to
- * unregister the device
- */
-static struct spi_driver ab4500_driver;
-
-/*
- * This funtion writes to any AB4500 registers using
- * SPI protocol &  before it writes it packs the data
- * in the below 24 bit frame format
- *
- *	 *|------------------------------------|
- *	 *| 23|22...18|17.......10|9|8|7......0|
- *	 *| r/w  bank       adr          data  |
- *	 * ------------------------------------
- *
- * This function shouldn't be called from interrupt
- * context
- */
-int ab4500_write(struct ab4500 *ab4500, unsigned char block,
-		unsigned long addr, unsigned char data)
-{
-	struct spi_transfer xfer;
-	struct spi_message	msg;
-	int err;
-	unsigned long spi_data =
-		block << 18 | addr << 10 | data;
-
-	mutex_lock(&ab4500->lock);
-	ab4500->tx_buf[0] = spi_data;
-	ab4500->rx_buf[0] = 0;
-
-	xfer.tx_buf	= ab4500->tx_buf;
-	xfer.rx_buf 	= NULL;
-	xfer.len	= sizeof(unsigned long);
-
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-
-	err = spi_sync(ab4500->spi, &msg);
-	mutex_unlock(&ab4500->lock);
-
-	return err;
-}
-EXPORT_SYMBOL(ab4500_write);
-
-int ab4500_read(struct ab4500 *ab4500, unsigned char block,
-		unsigned long addr)
-{
-	struct spi_transfer xfer;
-	struct spi_message	msg;
-	unsigned long spi_data =
-		1 << 23 | block << 18 | addr << 10;
-
-	mutex_lock(&ab4500->lock);
-	ab4500->tx_buf[0] = spi_data;
-	ab4500->rx_buf[0] = 0;
-
-	xfer.tx_buf	= ab4500->tx_buf;
-	xfer.rx_buf 	= ab4500->rx_buf;
-	xfer.len	= sizeof(unsigned long);
-
-	spi_message_init(&msg);
-	spi_message_add_tail(&xfer, &msg);
-
-	spi_sync(ab4500->spi, &msg);
-	mutex_unlock(&ab4500->lock);
-
-	return  ab4500->rx_buf[0];
-}
-EXPORT_SYMBOL(ab4500_read);
-
-/* ref: ab3100 core */
-#define AB4500_DEVICE(devname, devid)				\
-static struct platform_device ab4500_##devname##_device = {	\
-	.name	= devid,					\
-	.id	= -1,						\
-}
-
-/* list of childern devices of ab4500 - all are
- * not populated here - TODO
- */
-AB4500_DEVICE(charger, "ab4500-charger");
-AB4500_DEVICE(audio, "ab4500-audio");
-AB4500_DEVICE(usb, "ab4500-usb");
-AB4500_DEVICE(tvout, "ab4500-tvout");
-AB4500_DEVICE(sim, "ab4500-sim");
-AB4500_DEVICE(gpadc, "ab4500-gpadc");
-AB4500_DEVICE(clkmgt, "ab4500-clkmgt");
-AB4500_DEVICE(misc, "ab4500-misc");
-
-static struct platform_device *ab4500_platform_devs[] = {
-	&ab4500_charger_device,
-	&ab4500_audio_device,
-	&ab4500_usb_device,
-	&ab4500_tvout_device,
-	&ab4500_sim_device,
-	&ab4500_gpadc_device,
-	&ab4500_clkmgt_device,
-	&ab4500_misc_device,
-};
-
-static int __init ab4500_probe(struct spi_device *spi)
-{
-	struct ab4500	*ab4500;
-	unsigned char revision;
-	int err = 0;
-	int i;
-
-	ab4500 = kzalloc(sizeof *ab4500, GFP_KERNEL);
-	if (!ab4500) {
-		dev_err(&spi->dev, "could not allocate AB4500\n");
-		err = -ENOMEM;
-		goto not_detect;
-	}
-
-	ab4500->spi = spi;
-	spi_set_drvdata(spi, ab4500);
-
-	mutex_init(&ab4500->lock);
-
-	/* read the revision register */
-	revision = ab4500_read(ab4500, AB4500_MISC, AB4500_REV_REG);
-
-	/* revision id 0x0 is for early drop, 0x10 is for cut1.0 */
-	if (revision == 0x0 || revision == 0x10)
-		dev_info(&spi->dev, "Detected chip: %s, revision = %x\n",
-			ab4500_driver.driver.name, revision);
-	else	{
-		dev_err(&spi->dev, "unknown chip: 0x%x\n", revision);
-		goto not_detect;
-	}
-
-	for (i = 0; i < ARRAY_SIZE(ab4500_platform_devs); i++)	{
-		ab4500_platform_devs[i]->dev.parent =
-			&spi->dev;
-		platform_set_drvdata(ab4500_platform_devs[i], ab4500);
-	}
-
-	/* register the ab4500 platform devices */
-	platform_add_devices(ab4500_platform_devs,
-			ARRAY_SIZE(ab4500_platform_devs));
-
-	return err;
-
- not_detect:
-	spi_unregister_driver(&ab4500_driver);
-	kfree(ab4500);
-	return err;
-}
-
-static int __devexit ab4500_remove(struct spi_device *spi)
-{
-	struct ab4500 *ab4500 =
-		spi_get_drvdata(spi);
-
-	kfree(ab4500);
-
-	return 0;
-}
-
-static struct spi_driver ab4500_driver = {
-	.driver = {
-		.name = "ab4500",
-		.owner = THIS_MODULE,
-	},
-	.probe = ab4500_probe,
-	.remove = __devexit_p(ab4500_remove)
-};
-
-static int __devinit ab4500_init(void)
-{
-	return spi_register_driver(&ab4500_driver);
-}
-
-static void __exit ab4500_exit(void)
-{
-	spi_unregister_driver(&ab4500_driver);
-}
-
-subsys_initcall(ab4500_init);
-module_exit(ab4500_exit);
-
-MODULE_AUTHOR("Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com");
-MODULE_DESCRIPTION("AB4500 core driver");
-MODULE_LICENSE("GPL");
diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
new file mode 100644
index 0000000..e93833f
--- /dev/null
+++ b/drivers/mfd/ab8500-core.c
@@ -0,0 +1,442 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
+ * Author: Rabin Vincent <rabin.vincent@stericsson.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/irq.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/ab8500.h>
+
+/*
+ * Interrupt register offsets
+ * Bank : 0x0E
+ */
+#define AB8500_IT_SOURCE1_REG		0x0E00
+#define AB8500_IT_SOURCE2_REG		0x0E01
+#define AB8500_IT_SOURCE3_REG		0x0E02
+#define AB8500_IT_SOURCE4_REG		0x0E03
+#define AB8500_IT_SOURCE5_REG		0x0E04
+#define AB8500_IT_SOURCE6_REG		0x0E05
+#define AB8500_IT_SOURCE7_REG		0x0E06
+#define AB8500_IT_SOURCE8_REG		0x0E07
+#define AB8500_IT_SOURCE19_REG		0x0E12
+#define AB8500_IT_SOURCE20_REG		0x0E13
+#define AB8500_IT_SOURCE21_REG		0x0E14
+#define AB8500_IT_SOURCE22_REG		0x0E15
+#define AB8500_IT_SOURCE23_REG		0x0E16
+#define AB8500_IT_SOURCE24_REG		0x0E17
+
+/*
+ * latch registers
+ */
+#define AB8500_IT_LATCH1_REG		0x0E20
+#define AB8500_IT_LATCH2_REG		0x0E21
+#define AB8500_IT_LATCH3_REG		0x0E22
+#define AB8500_IT_LATCH4_REG		0x0E23
+#define AB8500_IT_LATCH5_REG		0x0E24
+#define AB8500_IT_LATCH6_REG		0x0E25
+#define AB8500_IT_LATCH7_REG		0x0E26
+#define AB8500_IT_LATCH8_REG		0x0E27
+#define AB8500_IT_LATCH9_REG		0x0E28
+#define AB8500_IT_LATCH10_REG		0x0E29
+#define AB8500_IT_LATCH19_REG		0x0E32
+#define AB8500_IT_LATCH20_REG		0x0E33
+#define AB8500_IT_LATCH21_REG		0x0E34
+#define AB8500_IT_LATCH22_REG		0x0E35
+#define AB8500_IT_LATCH23_REG		0x0E36
+#define AB8500_IT_LATCH24_REG		0x0E37
+
+/*
+ * mask registers
+ */
+
+#define AB8500_IT_MASK1_REG		0x0E40
+#define AB8500_IT_MASK2_REG		0x0E41
+#define AB8500_IT_MASK3_REG		0x0E42
+#define AB8500_IT_MASK4_REG		0x0E43
+#define AB8500_IT_MASK5_REG		0x0E44
+#define AB8500_IT_MASK6_REG		0x0E45
+#define AB8500_IT_MASK7_REG		0x0E46
+#define AB8500_IT_MASK8_REG		0x0E47
+#define AB8500_IT_MASK9_REG		0x0E48
+#define AB8500_IT_MASK10_REG		0x0E49
+#define AB8500_IT_MASK11_REG		0x0E4A
+#define AB8500_IT_MASK12_REG		0x0E4B
+#define AB8500_IT_MASK13_REG		0x0E4C
+#define AB8500_IT_MASK14_REG		0x0E4D
+#define AB8500_IT_MASK15_REG		0x0E4E
+#define AB8500_IT_MASK16_REG		0x0E4F
+#define AB8500_IT_MASK17_REG		0x0E50
+#define AB8500_IT_MASK18_REG		0x0E51
+#define AB8500_IT_MASK19_REG		0x0E52
+#define AB8500_IT_MASK20_REG		0x0E53
+#define AB8500_IT_MASK21_REG		0x0E54
+#define AB8500_IT_MASK22_REG		0x0E55
+#define AB8500_IT_MASK23_REG		0x0E56
+#define AB8500_IT_MASK24_REG		0x0E57
+
+#define AB8500_REV_REG			0x1080
+
+/*
+ * Map interrupt numbers to the LATCH and MASK register offsets, Interrupt
+ * numbers are indexed into this array with (num / 8).
+ *
+ * This is one off from the register names, i.e. AB8500_IT_MASK1_REG is at
+ * offset 0.
+ */
+static const int ab8500_irq_regoffset[AB8500_NUM_IRQ_REGS] = {
+	0, 1, 2, 3, 4, 6, 7, 8, 9, 18, 19, 20, 21,
+};
+
+static int __ab8500_write(struct ab8500 *ab8500, u16 addr, u8 data)
+{
+	int ret;
+
+	dev_vdbg(ab8500->dev, "wr: addr %#x <= %#x\n", addr, data);
+
+	ret = ab8500->write(ab8500, addr, data);
+	if (ret < 0)
+		dev_err(ab8500->dev, "failed to write reg %#x: %d\n",
+			addr, ret);
+
+	return ret;
+}
+
+/**
+ * ab8500_write() - write an AB8500 register
+ * @ab8500: device to write to
+ * @addr: address of the register
+ * @data: value to write
+ */
+int ab8500_write(struct ab8500 *ab8500, u16 addr, u8 data)
+{
+	int ret;
+
+	mutex_lock(&ab8500->lock);
+	ret = __ab8500_write(ab8500, addr, data);
+	mutex_unlock(&ab8500->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ab8500_write);
+
+static int __ab8500_read(struct ab8500 *ab8500, u16 addr)
+{
+	int ret;
+
+	ret = ab8500->read(ab8500, addr);
+	if (ret < 0)
+		dev_err(ab8500->dev, "failed to read reg %#x: %d\n",
+			addr, ret);
+
+	dev_vdbg(ab8500->dev, "rd: addr %#x => data %#x\n", addr, ret);
+
+	return ret;
+}
+
+/**
+ * ab8500_read() - read an AB8500 register
+ * @ab8500: device to read from
+ * @addr: address of the register
+ */
+int ab8500_read(struct ab8500 *ab8500, u16 addr)
+{
+	int ret;
+
+	mutex_lock(&ab8500->lock);
+	ret = __ab8500_read(ab8500, addr);
+	mutex_unlock(&ab8500->lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ab8500_read);
+
+/**
+ * ab8500_set_bits() - set a bitfield in an AB8500 register
+ * @ab8500: device to read from
+ * @addr: address of the register
+ * @mask: mask of the bitfield to modify
+ * @data: value to set to the bitfield
+ */
+int ab8500_set_bits(struct ab8500 *ab8500, u16 addr, u8 mask, u8 data)
+{
+	int ret;
+
+	mutex_lock(&ab8500->lock);
+
+	ret = __ab8500_read(ab8500, addr);
+	if (ret < 0)
+		goto out;
+
+	ret &= ~mask;
+	ret |= data;
+
+	ret = __ab8500_write(ab8500, addr, ret);
+
+out:
+	mutex_unlock(&ab8500->lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ab8500_set_bits);
+
+static void ab8500_irq_lock(unsigned int irq)
+{
+	struct ab8500 *ab8500 = get_irq_chip_data(irq);
+
+	mutex_lock(&ab8500->irq_lock);
+}
+
+static void ab8500_irq_sync_unlock(unsigned int irq)
+{
+	struct ab8500 *ab8500 = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
+		u8 old = ab8500->oldmask[i];
+		u8 new = ab8500->mask[i];
+		int reg;
+
+		if (new == old)
+			continue;
+
+		ab8500->oldmask[i] = new;
+
+		reg = AB8500_IT_MASK1_REG + ab8500_irq_regoffset[i];
+		ab8500_write(ab8500, reg, new);
+	}
+
+	mutex_unlock(&ab8500->irq_lock);
+}
+
+static void ab8500_irq_mask(unsigned int irq)
+{
+	struct ab8500 *ab8500 = get_irq_chip_data(irq);
+	int offset = irq - ab8500->irq_base;
+	int index = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	ab8500->mask[index] |= mask;
+}
+
+static void ab8500_irq_unmask(unsigned int irq)
+{
+	struct ab8500 *ab8500 = get_irq_chip_data(irq);
+	int offset = irq - ab8500->irq_base;
+	int index = offset / 8;
+	int mask = 1 << (offset % 8);
+
+	ab8500->mask[index] &= ~mask;
+}
+
+static struct irq_chip ab8500_irq_chip = {
+	.name			= "ab8500",
+	.bus_lock		= ab8500_irq_lock,
+	.bus_sync_unlock	= ab8500_irq_sync_unlock,
+	.mask			= ab8500_irq_mask,
+	.unmask			= ab8500_irq_unmask,
+};
+
+static irqreturn_t ab8500_irq(int irq, void *dev)
+{
+	struct ab8500 *ab8500 = dev;
+	int i;
+
+	dev_vdbg(ab8500->dev, "interrupt\n");
+
+	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++) {
+		int regoffset = ab8500_irq_regoffset[i];
+		int status;
+
+		status = ab8500_read(ab8500, AB8500_IT_LATCH1_REG + regoffset);
+		if (status <= 0)
+			continue;
+
+		do {
+			int bit = __ffs(status);
+			int line = i * 8 + bit;
+
+			handle_nested_irq(ab8500->irq_base + line);
+			status &= ~(1 << bit);
+		} while (status);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int ab8500_irq_init(struct ab8500 *ab8500)
+{
+	int base = ab8500->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
+		set_irq_chip_data(irq, ab8500);
+		set_irq_chip_and_handler(irq, &ab8500_irq_chip,
+					 handle_simple_irq);
+		set_irq_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(irq, IRQF_VALID);
+#else
+		set_irq_noprobe(irq);
+#endif
+	}
+
+	return 0;
+}
+
+static void ab8500_irq_remove(struct ab8500 *ab8500)
+{
+	int base = ab8500->irq_base;
+	int irq;
+
+	for (irq = base; irq < base + AB8500_NR_IRQS; irq++) {
+		set_irq_flags(irq, 0);
+		set_irq_chip_and_handler(irq, NULL, NULL);
+		set_irq_chip_data(irq, NULL);
+	}
+}
+
+static struct resource ab8500_gpadc_resources[] = {
+	{
+		.name	= "HW_CONV_END",
+		.start	= AB8500_INT_GP_HW_ADC_CONV_END,
+		.end	= AB8500_INT_GP_HW_ADC_CONV_END,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "SW_CONV_END",
+		.start	= AB8500_INT_GP_SW_ADC_CONV_END,
+		.end	= AB8500_INT_GP_SW_ADC_CONV_END,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct resource ab8500_rtc_resources[] = {
+	{
+		.name	= "60S",
+		.start	= AB8500_INT_RTC_60S,
+		.end	= AB8500_INT_RTC_60S,
+		.flags	= IORESOURCE_IRQ,
+	},
+	{
+		.name	= "ALARM",
+		.start	= AB8500_INT_RTC_ALARM,
+		.end	= AB8500_INT_RTC_ALARM,
+		.flags	= IORESOURCE_IRQ,
+	},
+};
+
+static struct mfd_cell ab8500_devs[] = {
+	{
+		.name = "ab8500-gpadc",
+		.num_resources = ARRAY_SIZE(ab8500_gpadc_resources),
+		.resources = ab8500_gpadc_resources,
+	},
+	{
+		.name = "ab8500-rtc",
+		.num_resources = ARRAY_SIZE(ab8500_rtc_resources),
+		.resources = ab8500_rtc_resources,
+	},
+	{ .name = "ab8500-charger", },
+	{ .name = "ab8500-audio", },
+	{ .name = "ab8500-usb", },
+	{ .name = "ab8500-pwm", },
+};
+
+int __devinit ab8500_init(struct ab8500 *ab8500)
+{
+	struct ab8500_platform_data *plat = dev_get_platdata(ab8500->dev);
+	int ret;
+	int i;
+
+	if (plat)
+		ab8500->irq_base = plat->irq_base;
+
+	mutex_init(&ab8500->lock);
+	mutex_init(&ab8500->irq_lock);
+
+	ret = ab8500_read(ab8500, AB8500_REV_REG);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * 0x0 - Early Drop
+	 * 0x10 - Cut 1.0
+	 * 0x11 - Cut 1.1
+	 */
+	if (ret == 0x0 || ret == 0x10 || ret == 0x11) {
+		ab8500->revision = ret;
+		dev_info(ab8500->dev, "detected chip, revision: %#x\n", ret);
+	} else {
+		dev_err(ab8500->dev, "unknown chip, revision: %#x\n", ret);
+		return -EINVAL;
+	}
+
+	if (plat && plat->init)
+		plat->init(ab8500);
+
+	/* Clear and mask all interrupts */
+	for (i = 0; i < 10; i++) {
+		ab8500_read(ab8500, AB8500_IT_LATCH1_REG + i);
+		ab8500_write(ab8500, AB8500_IT_MASK1_REG + i, 0xff);
+	}
+
+	for (i = 18; i < 24; i++) {
+		ab8500_read(ab8500, AB8500_IT_LATCH1_REG + i);
+		ab8500_write(ab8500, AB8500_IT_MASK1_REG + i, 0xff);
+	}
+
+	for (i = 0; i < AB8500_NUM_IRQ_REGS; i++)
+		ab8500->mask[i] = ab8500->oldmask[i] = 0xff;
+
+	if (ab8500->irq_base) {
+		ret = ab8500_irq_init(ab8500);
+		if (ret)
+			return ret;
+
+		ret = request_threaded_irq(ab8500->irq, NULL, ab8500_irq,
+					   IRQF_ONESHOT, "ab8500", ab8500);
+		if (ret)
+			goto out_removeirq;
+	}
+
+	ret = mfd_add_devices(ab8500->dev, -1, ab8500_devs,
+			      ARRAY_SIZE(ab8500_devs), NULL,
+			      ab8500->irq_base);
+	if (ret)
+		goto out_freeirq;
+
+	return ret;
+
+out_freeirq:
+	if (ab8500->irq_base) {
+		free_irq(ab8500->irq, ab8500);
+out_removeirq:
+		ab8500_irq_remove(ab8500);
+	}
+	return ret;
+}
+
+int __devexit ab8500_exit(struct ab8500 *ab8500)
+{
+	mfd_remove_devices(ab8500->dev);
+	if (ab8500->irq_base) {
+		free_irq(ab8500->irq, ab8500);
+		ab8500_irq_remove(ab8500);
+	}
+
+	return 0;
+}
+
+MODULE_AUTHOR("Srinidhi Kasagar, Rabin Vincent");
+MODULE_DESCRIPTION("AB8500 MFD core");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/ab8500-spi.c b/drivers/mfd/ab8500-spi.c
new file mode 100644
index 0000000..b81d4f7
--- /dev/null
+++ b/drivers/mfd/ab8500-spi.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/ab8500.h>
+
+/*
+ * This funtion writes to any AB8500 registers using
+ * SPI protocol &  before it writes it packs the data
+ * in the below 24 bit frame format
+ *
+ *	 *|------------------------------------|
+ *	 *| 23|22...18|17.......10|9|8|7......0|
+ *	 *| r/w  bank       adr          data  |
+ *	 * ------------------------------------
+ *
+ * This function shouldn't be called from interrupt
+ * context
+ */
+static int ab8500_spi_write(struct ab8500 *ab8500, u16 addr, u8 data)
+{
+	struct spi_device *spi = container_of(ab8500->dev, struct spi_device,
+					      dev);
+	unsigned long spi_data = addr << 10 | data;
+	struct spi_transfer xfer;
+	struct spi_message msg;
+
+	ab8500->tx_buf[0] = spi_data;
+	ab8500->rx_buf[0] = 0;
+
+	xfer.tx_buf	= ab8500->tx_buf;
+	xfer.rx_buf	= NULL;
+	xfer.len	= sizeof(unsigned long);
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	return spi_sync(spi, &msg);
+}
+
+static int ab8500_spi_read(struct ab8500 *ab8500, u16 addr)
+{
+	struct spi_device *spi = container_of(ab8500->dev, struct spi_device,
+					      dev);
+	unsigned long spi_data = 1 << 23 | addr << 10;
+	struct spi_transfer xfer;
+	struct spi_message msg;
+	int ret;
+
+	ab8500->tx_buf[0] = spi_data;
+	ab8500->rx_buf[0] = 0;
+
+	xfer.tx_buf	= ab8500->tx_buf;
+	xfer.rx_buf	= ab8500->rx_buf;
+	xfer.len	= sizeof(unsigned long);
+
+	spi_message_init(&msg);
+	spi_message_add_tail(&xfer, &msg);
+
+	ret = spi_sync(spi, &msg);
+	if (!ret)
+		ret = ab8500->rx_buf[0];
+
+	return ret;
+}
+
+static int __devinit ab8500_spi_probe(struct spi_device *spi)
+{
+	struct ab8500 *ab8500;
+	int ret;
+
+	ab8500 = kzalloc(sizeof *ab8500, GFP_KERNEL);
+	if (!ab8500)
+		return -ENOMEM;
+
+	ab8500->dev = &spi->dev;
+	ab8500->irq = spi->irq;
+
+	ab8500->read = ab8500_spi_read;
+	ab8500->write = ab8500_spi_write;
+
+	spi_set_drvdata(spi, ab8500);
+
+	ret = ab8500_init(ab8500);
+	if (ret)
+		kfree(ab8500);
+
+	return ret;
+}
+
+static int __devexit ab8500_spi_remove(struct spi_device *spi)
+{
+	struct ab8500 *ab8500 = spi_get_drvdata(spi);
+
+	ab8500_exit(ab8500);
+	kfree(ab8500);
+
+	return 0;
+}
+
+static struct spi_driver ab8500_spi_driver = {
+	.driver = {
+		.name = "ab8500",
+		.owner = THIS_MODULE,
+	},
+	.probe	= ab8500_spi_probe,
+	.remove	= __devexit_p(ab8500_spi_remove)
+};
+
+static int __init ab8500_spi_init(void)
+{
+	return spi_register_driver(&ab8500_spi_driver);
+}
+subsys_initcall(ab8500_spi_init);
+
+static void __exit ab8500_spi_exit(void)
+{
+	spi_unregister_driver(&ab8500_spi_driver);
+}
+module_exit(ab8500_spi_exit);
+
+MODULE_AUTHOR("Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com");
+MODULE_DESCRIPTION("AB8500 SPI");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/ab4500.h b/include/linux/mfd/ab4500.h
deleted file mode 100644
index a42a703..0000000
--- a/include/linux/mfd/ab4500.h
+++ /dev/null
@@ -1,262 +0,0 @@
-/*
- * Copyright (C) 2009 ST-Ericsson
- *
- * Author: Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2, as
- * published by the Free Software Foundation.
- *
- * AB4500 device core funtions, for client access
- */
-#ifndef MFD_AB4500_H
-#define MFD_AB4500_H
-
-#include <linux/device.h>
-
-/*
- * AB4500 bank addresses
- */
-#define AB4500_SYS_CTRL1_BLOCK	0x1
-#define AB4500_SYS_CTRL2_BLOCK	0x2
-#define AB4500_REGU_CTRL1	0x3
-#define AB4500_REGU_CTRL2	0x4
-#define AB4500_USB		0x5
-#define AB4500_TVOUT		0x6
-#define AB4500_DBI		0x7
-#define AB4500_ECI_AV_ACC	0x8
-#define AB4500_RESERVED		0x9
-#define AB4500_GPADC		0xA
-#define AB4500_CHARGER		0xB
-#define AB4500_GAS_GAUGE	0xC
-#define AB4500_AUDIO		0xD
-#define AB4500_INTERRUPT	0xE
-#define AB4500_RTC		0xF
-#define AB4500_MISC		0x10
-#define AB4500_DEBUG		0x12
-#define AB4500_PROD_TEST	0x13
-#define AB4500_OTP_EMUL		0x15
-
-/*
- * System control 1 register offsets.
- * Bank = 0x01
- */
-#define AB4500_TURNON_STAT_REG		0x0100
-#define AB4500_RESET_STAT_REG		0x0101
-#define AB4500_PONKEY1_PRESS_STAT_REG	0x0102
-
-#define AB4500_FSM_STAT1_REG		0x0140
-#define AB4500_FSM_STAT2_REG		0x0141
-#define AB4500_SYSCLK_REQ_STAT_REG	0x0142
-#define AB4500_USB_STAT1_REG		0x0143
-#define AB4500_USB_STAT2_REG		0x0144
-#define AB4500_STATUS_SPARE1_REG	0x0145
-#define AB4500_STATUS_SPARE2_REG	0x0146
-
-#define AB4500_CTRL1_REG		0x0180
-#define AB4500_CTRL2_REG		0x0181
-
-/*
- * System control 2 register offsets.
- * bank = 0x02
- */
-#define AB4500_CTRL3_REG		0x0200
-#define AB4500_MAIN_WDOG_CTRL_REG	0x0201
-#define AB4500_MAIN_WDOG_TIMER_REG	0x0202
-#define AB4500_LOW_BAT_REG		0x0203
-#define AB4500_BATT_OK_REG		0x0204
-#define AB4500_SYSCLK_TIMER_REG		0x0205
-#define AB4500_SMPSCLK_CTRL_REG		0x0206
-#define AB4500_SMPSCLK_SEL1_REG		0x0207
-#define AB4500_SMPSCLK_SEL2_REG		0x0208
-#define AB4500_SMPSCLK_SEL3_REG		0x0209
-#define AB4500_SYSULPCLK_CONF_REG	0x020A
-#define AB4500_SYSULPCLK_CTRL1_REG	0x020B
-#define AB4500_SYSCLK_CTRL_REG		0x020C
-#define AB4500_SYSCLK_REQ1_VALID_REG	0x020D
-#define AB4500_SYSCLK_REQ_VALID_REG	0x020E
-#define AB4500_SYSCTRL_SPARE_REG	0x020F
-#define AB4500_PAD_CONF_REG		0x0210
-
-/*
- * Regu control1 register offsets
- * Bank = 0x03
- */
-#define AB4500_REGU_SERIAL_CTRL1_REG	0x0300
-#define AB4500_REGU_SERIAL_CTRL2_REG	0x0301
-#define AB4500_REGU_SERIAL_CTRL3_REG	0x0302
-#define AB4500_REGU_REQ_CTRL1_REG	0x0303
-#define AB4500_REGU_REQ_CTRL2_REG	0x0304
-#define AB4500_REGU_REQ_CTRL3_REG	0x0305
-#define AB4500_REGU_REQ_CTRL4_REG	0x0306
-#define AB4500_REGU_MISC1_REG		0x0380
-#define AB4500_REGU_OTGSUPPLY_CTRL_REG	0x0381
-#define AB4500_REGU_VUSB_CTRL_REG	0x0382
-#define AB4500_REGU_VAUDIO_SUPPLY_REG	0x0383
-#define AB4500_REGU_CTRL1_SPARE_REG	0x0384
-
-/*
- * Regu control2 Vmod register offsets
- */
-#define AB4500_REGU_VMOD_REGU_REG	0x0440
-#define AB4500_REGU_VMOD_SEL1_REG	0x0441
-#define AB4500_REGU_VMOD_SEL2_REG	0x0442
-#define AB4500_REGU_CTRL_DISCH_REG	0x0443
-#define AB4500_REGU_CTRL_DISCH2_REG	0x0444
-
-/*
- * USB/ULPI register offsets
- * Bank : 0x5
- */
-#define AB4500_USB_LINE_STAT_REG	0x0580
-#define AB4500_USB_LINE_CTRL1_REG	0x0581
-#define AB4500_USB_LINE_CTRL2_REG	0x0582
-#define AB4500_USB_LINE_CTRL3_REG	0x0583
-#define AB4500_USB_LINE_CTRL4_REG	0x0584
-#define AB4500_USB_LINE_CTRL5_REG	0x0585
-#define AB4500_USB_OTG_CTRL_REG		0x0587
-#define AB4500_USB_OTG_STAT_REG		0x0588
-#define AB4500_USB_OTG_STAT_REG		0x0588
-#define AB4500_USB_CTRL_SPARE_REG	0x0589
-#define AB4500_USB_PHY_CTRL_REG		0x058A
-
-/*
- * TVOUT / CTRL register offsets
- * Bank : 0x06
- */
-#define AB4500_TVOUT_CTRL_REG		0x0680
-
-/*
- * DBI register offsets
- * Bank : 0x07
- */
-#define AB4500_DBI_REG1_REG		0x0700
-#define AB4500_DBI_REG2_REG		0x0701
-
-/*
- * ECI regsiter offsets
- * Bank : 0x08
- */
-#define AB4500_ECI_CTRL_REG		0x0800
-#define AB4500_ECI_HOOKLEVEL_REG	0x0801
-#define AB4500_ECI_DATAOUT_REG		0x0802
-#define AB4500_ECI_DATAIN_REG		0x0803
-
-/*
- * AV Connector register offsets
- * Bank : 0x08
- */
-#define AB4500_AV_CONN_REG		0x0840
-
-/*
- * Accessory detection register offsets
- * Bank : 0x08
- */
-#define AB4500_ACC_DET_DB1_REG		0x0880
-#define AB4500_ACC_DET_DB2_REG		0x0881
-
-/*
- * GPADC register offsets
- * Bank : 0x0A
- */
-#define AB4500_GPADC_CTRL1_REG		0x0A00
-#define AB4500_GPADC_CTRL2_REG		0x0A01
-#define AB4500_GPADC_CTRL3_REG		0x0A02
-#define AB4500_GPADC_AUTO_TIMER_REG	0x0A03
-#define AB4500_GPADC_STAT_REG		0x0A04
-#define AB4500_GPADC_MANDATAL_REG	0x0A05
-#define AB4500_GPADC_MANDATAH_REG	0x0A06
-#define AB4500_GPADC_AUTODATAL_REG	0x0A07
-#define AB4500_GPADC_AUTODATAH_REG	0x0A08
-#define AB4500_GPADC_MUX_CTRL_REG	0x0A09
-
-/*
- * Charger / status register offfsets
- * Bank : 0x0B
- */
-#define AB4500_CH_STATUS1_REG		0x0B00
-#define AB4500_CH_STATUS2_REG		0x0B01
-#define AB4500_CH_USBCH_STAT1_REG	0x0B02
-#define AB4500_CH_USBCH_STAT2_REG	0x0B03
-#define AB4500_CH_FSM_STAT_REG		0x0B04
-#define AB4500_CH_STAT_REG		0x0B05
-
-/*
- * Charger / control register offfsets
- * Bank : 0x0B
- */
-#define AB4500_CH_VOLT_LVL_REG		0x0B40
-
-/*
- * Charger / main control register offfsets
- * Bank : 0x0B
- */
-#define AB4500_MCH_CTRL1		0x0B80
-#define AB4500_MCH_CTRL2		0x0B81
-#define AB4500_MCH_IPT_CURLVL_REG	0x0B82
-#define AB4500_CH_WD_REG		0x0B83
-
-/*
- * Charger / USB control register offsets
- * Bank : 0x0B
- */
-#define AB4500_USBCH_CTRL1_REG		0x0BC0
-#define AB4500_USBCH_CTRL2_REG		0x0BC1
-#define AB4500_USBCH_IPT_CRNTLVL_REG	0x0BC2
-
-/*
- * RTC bank register offsets
- * Bank : 0xF
- */
-#define AB4500_RTC_SOFF_STAT_REG	0x0F00
-#define AB4500_RTC_CC_CONF_REG		0x0F01
-#define AB4500_RTC_READ_REQ_REG		0x0F02
-#define AB4500_RTC_WATCH_TSECMID_REG	0x0F03
-#define AB4500_RTC_WATCH_TSECHI_REG	0x0F04
-#define AB4500_RTC_WATCH_TMIN_LOW_REG	0x0F05
-#define AB4500_RTC_WATCH_TMIN_MID_REG	0x0F06
-#define AB4500_RTC_WATCH_TMIN_HI_REG	0x0F07
-#define AB4500_RTC_ALRM_MIN_LOW_REG	0x0F08
-#define AB4500_RTC_ALRM_MIN_MID_REG	0x0F09
-#define AB4500_RTC_ALRM_MIN_HI_REG	0x0F0A
-#define AB4500_RTC_STAT_REG		0x0F0B
-#define AB4500_RTC_BKUP_CHG_REG		0x0F0C
-#define AB4500_RTC_FORCE_BKUP_REG	0x0F0D
-#define AB4500_RTC_CALIB_REG		0x0F0E
-#define AB4500_RTC_SWITCH_STAT_REG	0x0F0F
-
-/*
- * PWM Out generators
- * Bank: 0x10
- */
-#define AB4500_PWM_OUT_CTRL1_REG	0x1060
-#define AB4500_PWM_OUT_CTRL2_REG	0x1061
-#define AB4500_PWM_OUT_CTRL3_REG	0x1062
-#define AB4500_PWM_OUT_CTRL4_REG	0x1063
-#define AB4500_PWM_OUT_CTRL5_REG	0x1064
-#define AB4500_PWM_OUT_CTRL6_REG	0x1065
-#define AB4500_PWM_OUT_CTRL7_REG	0x1066
-
-#define AB4500_I2C_PAD_CTRL_REG		0x1067
-#define AB4500_REV_REG			0x1080
-
-/**
- * struct ab4500
- * @spi: spi device structure
- * @tx_buf: transmit buffer
- * @rx_buf: receive buffer
- * @lock: sync primitive
- */
-struct ab4500 {
-	struct spi_device	*spi;
-	unsigned long		tx_buf[4];
-	unsigned long		rx_buf[4];
-	struct mutex		lock;
-};
-
-int ab4500_write(struct ab4500 *ab4500, unsigned char block,
-		unsigned long addr, unsigned char data);
-int ab4500_read(struct ab4500 *ab4500, unsigned char block,
-		unsigned long addr);
-
-#endif /* MFD_AB4500_H */
diff --git a/include/linux/mfd/ab8500.h b/include/linux/mfd/ab8500.h
new file mode 100644
index 0000000..b63ff3b
--- /dev/null
+++ b/include/linux/mfd/ab8500.h
@@ -0,0 +1,128 @@
+/*
+ * Copyright (C) ST-Ericsson SA 2010
+ *
+ * License Terms: GNU General Public License v2
+ * Author: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
+ */
+#ifndef MFD_AB8500_H
+#define MFD_AB8500_H
+
+#include <linux/device.h>
+
+/*
+ * Interrupts
+ */
+
+#define AB8500_INT_MAIN_EXT_CH_NOT_OK	0
+#define AB8500_INT_UN_PLUG_TV_DET	1
+#define AB8500_INT_PLUG_TV_DET		2
+#define AB8500_INT_TEMP_WARM		3
+#define AB8500_INT_PON_KEY2DB_F		4
+#define AB8500_INT_PON_KEY2DB_R		5
+#define AB8500_INT_PON_KEY1DB_F		6
+#define AB8500_INT_PON_KEY1DB_R		7
+#define AB8500_INT_BATT_OVV		8
+#define AB8500_INT_MAIN_CH_UNPLUG_DET	10
+#define AB8500_INT_MAIN_CH_PLUG_DET	11
+#define AB8500_INT_USB_ID_DET_F		12
+#define AB8500_INT_USB_ID_DET_R		13
+#define AB8500_INT_VBUS_DET_F		14
+#define AB8500_INT_VBUS_DET_R		15
+#define AB8500_INT_VBUS_CH_DROP_END	16
+#define AB8500_INT_RTC_60S		17
+#define AB8500_INT_RTC_ALARM		18
+#define AB8500_INT_BAT_CTRL_INDB	20
+#define AB8500_INT_CH_WD_EXP		21
+#define AB8500_INT_VBUS_OVV		22
+#define AB8500_INT_MAIN_CH_DROP_END	23
+#define AB8500_INT_CCN_CONV_ACC		24
+#define AB8500_INT_INT_AUD		25
+#define AB8500_INT_CCEOC		26
+#define AB8500_INT_CC_INT_CALIB		27
+#define AB8500_INT_LOW_BAT_F		28
+#define AB8500_INT_LOW_BAT_R		29
+#define AB8500_INT_BUP_CHG_NOT_OK	30
+#define AB8500_INT_BUP_CHG_OK		31
+#define AB8500_INT_GP_HW_ADC_CONV_END	32
+#define AB8500_INT_ACC_DETECT_1DB_F	33
+#define AB8500_INT_ACC_DETECT_1DB_R	34
+#define AB8500_INT_ACC_DETECT_22DB_F	35
+#define AB8500_INT_ACC_DETECT_22DB_R	36
+#define AB8500_INT_ACC_DETECT_21DB_F	37
+#define AB8500_INT_ACC_DETECT_21DB_R	38
+#define AB8500_INT_GP_SW_ADC_CONV_END	39
+#define AB8500_INT_BTEMP_LOW		72
+#define AB8500_INT_BTEMP_LOW_MEDIUM	73
+#define AB8500_INT_BTEMP_MEDIUM_HIGH	74
+#define AB8500_INT_BTEMP_HIGH		75
+#define AB8500_INT_USB_CHARGER_NOT_OK	81
+#define AB8500_INT_ID_WAKEUP_R		82
+#define AB8500_INT_ID_DET_R1R		84
+#define AB8500_INT_ID_DET_R2R		85
+#define AB8500_INT_ID_DET_R3R		86
+#define AB8500_INT_ID_DET_R4R		87
+#define AB8500_INT_ID_WAKEUP_F		88
+#define AB8500_INT_ID_DET_R1F		90
+#define AB8500_INT_ID_DET_R2F		91
+#define AB8500_INT_ID_DET_R3F		92
+#define AB8500_INT_ID_DET_R4F		93
+#define AB8500_INT_USB_CHG_DET_DONE	94
+#define AB8500_INT_USB_CH_TH_PROT_F	96
+#define AB8500_INT_USB_CH_TH_PROP_R	97
+#define AB8500_INT_MAIN_CH_TH_PROP_F	98
+#define AB8500_INT_MAIN_CH_TH_PROT_R	99
+#define AB8500_INT_USB_CHARGER_NOT_OKF	103
+
+#define AB8500_NR_IRQS			104
+#define AB8500_NUM_IRQ_REGS		13
+
+/**
+ * struct ab8500 - ab8500 internal structure
+ * @dev: parent device
+ * @lock: read/write operations lock
+ * @irq_lock: genirq bus lock
+ * @revision: chip revision
+ * @irq: irq line
+ * @write: register write
+ * @read: register read
+ * @rx_buf: rx buf for SPI
+ * @tx_buf: tx buf for SPI
+ * @mask: cache of IRQ regs for bus lock
+ * @oldmask: cache of previous IRQ regs for bus lock
+ */
+struct ab8500 {
+	struct device	*dev;
+	struct mutex	lock;
+	struct mutex	irq_lock;
+	int		revision;
+	int		irq_base;
+	int		irq;
+
+	int (*write) (struct ab8500 *a8500, u16 addr, u8 data);
+	int (*read) (struct ab8500 *a8500, u16 addr);
+
+	unsigned long	tx_buf[4];
+	unsigned long	rx_buf[4];
+
+	u8 mask[AB8500_NUM_IRQ_REGS];
+	u8 oldmask[AB8500_NUM_IRQ_REGS];
+};
+
+/**
+ * struct ab8500_platform_data - AB8500 platform data
+ * @irq_base: start of AB8500 IRQs, AB8500_NR_IRQS will be used
+ * @init: board-specific initialization after detection of ab8500
+ */
+struct ab8500_platform_data {
+	int irq_base;
+	void (*init) (struct ab8500 *);
+};
+
+extern int ab8500_write(struct ab8500 *a8500, u16 addr, u8 data);
+extern int ab8500_read(struct ab8500 *a8500, u16 addr);
+extern int ab8500_set_bits(struct ab8500 *a8500, u16 addr, u8 mask, u8 data);
+
+extern int __devinit ab8500_init(struct ab8500 *ab8500);
+extern int __devexit ab8500_exit(struct ab8500 *ab8500);
+
+#endif /* MFD_AB8500_H */
-- 
1.7.0

