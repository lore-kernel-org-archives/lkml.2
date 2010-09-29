Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab0I2QYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 12:24:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab0I2QX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 12:23:57 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@epfl.ch>
Subject: [PATCH 3/4] mfd/mc13xxx: add support for mc13892
Date: Wed, 29 Sep 2010 18:23:46 +0200
Message-Id: <1285777427-2887-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20100929162315.GG29811@pengutronix.de>
References: <20100929162315.GG29811@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mc13892 is the companion PMIC for Freescale's i.MX51.  It's similar enough
to mc13782 to support it in a single driver.

This patch introduces enough compatibility cruft to keep all users of the
superseded mc13783 driver unchanged.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/mfd/Kconfig         |    9 +-
 drivers/mfd/Makefile        |    2 +-
 drivers/mfd/mc13783-core.c  |  743 --------------------------------------
 drivers/mfd/mc13xxx-core.c  |  840 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/mc13783.h |  247 ++++++-------
 include/linux/mfd/mc13xxx.h |  154 ++++++++
 6 files changed, 1113 insertions(+), 882 deletions(-)
 delete mode 100644 drivers/mfd/mc13783-core.c
 create mode 100644 drivers/mfd/mc13xxx-core.c
 create mode 100644 include/linux/mfd/mc13xxx.h

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index db51ea1..1868d9b 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -408,11 +408,16 @@ config MFD_PCF50633
 	  so that function-specific drivers can bind to them.
 
 config MFD_MC13783
-	tristate "Support Freescale MC13783"
+	tristate
+
+config MFD_MC13XXX
+	tristate "Support Freescale MC13783 and MC13892"
 	depends on SPI_MASTER
 	select MFD_CORE
+	select MFD_MC13783
 	help
-	  Support for the Freescale (Atlas) MC13783 PMIC and audio CODEC.
+	  Support for the Freescale (Atlas) PMIC and audio CODECs
+	  MC13783 and MC13892.
 	  This driver provides common support for accessing  the device,
 	  additional drivers must be enabled in order to use the
 	  functionality of the device.
diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index feaeeae..56965c9 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -39,7 +39,7 @@ obj-$(CONFIG_TWL4030_POWER)    += twl4030-power.o
 obj-$(CONFIG_TWL4030_CODEC)	+= twl4030-codec.o
 obj-$(CONFIG_TWL6030_PWM)	+= twl6030-pwm.o
 
-obj-$(CONFIG_MFD_MC13783)	+= mc13783-core.o
+obj-$(CONFIG_MFD_MC13XXX)	+= mc13xxx-core.o
 
 obj-$(CONFIG_MFD_CORE)		+= mfd-core.o
 
diff --git a/drivers/mfd/mc13783-core.c b/drivers/mfd/mc13783-core.c
deleted file mode 100644
index 2506e68..0000000
--- a/drivers/mfd/mc13783-core.c
+++ /dev/null
@@ -1,743 +0,0 @@
-/*
- * Copyright 2009 Pengutronix
- * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
- *
- * loosely based on an earlier driver that has
- * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
- *
- * This program is free software; you can redistribute it and/or modify it under
- * the terms of the GNU General Public License version 2 as published by the
- * Free Software Foundation.
- */
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/platform_device.h>
-#include <linux/mutex.h>
-#include <linux/interrupt.h>
-#include <linux/spi/spi.h>
-#include <linux/mfd/core.h>
-#include <linux/mfd/mc13783.h>
-
-struct mc13783 {
-	struct spi_device *spidev;
-	struct mutex lock;
-	int irq;
-	int adcflags;
-
-	irq_handler_t irqhandler[MC13783_NUM_IRQ];
-	void *irqdata[MC13783_NUM_IRQ];
-};
-
-#define MC13783_REG_REVISION			 7
-#define MC13783_REG_ADC_0			43
-#define MC13783_REG_ADC_1			44
-#define MC13783_REG_ADC_2			45
-
-#define MC13783_IRQSTAT0	0
-#define MC13783_IRQSTAT0_ADCDONEI	(1 << 0)
-#define MC13783_IRQSTAT0_ADCBISDONEI	(1 << 1)
-#define MC13783_IRQSTAT0_TSI		(1 << 2)
-#define MC13783_IRQSTAT0_WHIGHI		(1 << 3)
-#define MC13783_IRQSTAT0_WLOWI		(1 << 4)
-#define MC13783_IRQSTAT0_CHGDETI	(1 << 6)
-#define MC13783_IRQSTAT0_CHGOVI		(1 << 7)
-#define MC13783_IRQSTAT0_CHGREVI	(1 << 8)
-#define MC13783_IRQSTAT0_CHGSHORTI	(1 << 9)
-#define MC13783_IRQSTAT0_CCCVI		(1 << 10)
-#define MC13783_IRQSTAT0_CHGCURRI	(1 << 11)
-#define MC13783_IRQSTAT0_BPONI		(1 << 12)
-#define MC13783_IRQSTAT0_LOBATLI	(1 << 13)
-#define MC13783_IRQSTAT0_LOBATHI	(1 << 14)
-#define MC13783_IRQSTAT0_UDPI		(1 << 15)
-#define MC13783_IRQSTAT0_USBI		(1 << 16)
-#define MC13783_IRQSTAT0_IDI		(1 << 19)
-#define MC13783_IRQSTAT0_SE1I		(1 << 21)
-#define MC13783_IRQSTAT0_CKDETI		(1 << 22)
-#define MC13783_IRQSTAT0_UDMI		(1 << 23)
-
-#define MC13783_IRQMASK0	1
-#define MC13783_IRQMASK0_ADCDONEM	MC13783_IRQSTAT0_ADCDONEI
-#define MC13783_IRQMASK0_ADCBISDONEM	MC13783_IRQSTAT0_ADCBISDONEI
-#define MC13783_IRQMASK0_TSM		MC13783_IRQSTAT0_TSI
-#define MC13783_IRQMASK0_WHIGHM		MC13783_IRQSTAT0_WHIGHI
-#define MC13783_IRQMASK0_WLOWM		MC13783_IRQSTAT0_WLOWI
-#define MC13783_IRQMASK0_CHGDETM	MC13783_IRQSTAT0_CHGDETI
-#define MC13783_IRQMASK0_CHGOVM		MC13783_IRQSTAT0_CHGOVI
-#define MC13783_IRQMASK0_CHGREVM	MC13783_IRQSTAT0_CHGREVI
-#define MC13783_IRQMASK0_CHGSHORTM	MC13783_IRQSTAT0_CHGSHORTI
-#define MC13783_IRQMASK0_CCCVM		MC13783_IRQSTAT0_CCCVI
-#define MC13783_IRQMASK0_CHGCURRM	MC13783_IRQSTAT0_CHGCURRI
-#define MC13783_IRQMASK0_BPONM		MC13783_IRQSTAT0_BPONI
-#define MC13783_IRQMASK0_LOBATLM	MC13783_IRQSTAT0_LOBATLI
-#define MC13783_IRQMASK0_LOBATHM	MC13783_IRQSTAT0_LOBATHI
-#define MC13783_IRQMASK0_UDPM		MC13783_IRQSTAT0_UDPI
-#define MC13783_IRQMASK0_USBM		MC13783_IRQSTAT0_USBI
-#define MC13783_IRQMASK0_IDM		MC13783_IRQSTAT0_IDI
-#define MC13783_IRQMASK0_SE1M		MC13783_IRQSTAT0_SE1I
-#define MC13783_IRQMASK0_CKDETM		MC13783_IRQSTAT0_CKDETI
-#define MC13783_IRQMASK0_UDMM		MC13783_IRQSTAT0_UDMI
-
-#define MC13783_IRQSTAT1	3
-#define MC13783_IRQSTAT1_1HZI		(1 << 0)
-#define MC13783_IRQSTAT1_TODAI		(1 << 1)
-#define MC13783_IRQSTAT1_ONOFD1I	(1 << 3)
-#define MC13783_IRQSTAT1_ONOFD2I	(1 << 4)
-#define MC13783_IRQSTAT1_ONOFD3I	(1 << 5)
-#define MC13783_IRQSTAT1_SYSRSTI	(1 << 6)
-#define MC13783_IRQSTAT1_RTCRSTI	(1 << 7)
-#define MC13783_IRQSTAT1_PCI		(1 << 8)
-#define MC13783_IRQSTAT1_WARMI		(1 << 9)
-#define MC13783_IRQSTAT1_MEMHLDI	(1 << 10)
-#define MC13783_IRQSTAT1_PWRRDYI	(1 << 11)
-#define MC13783_IRQSTAT1_THWARNLI	(1 << 12)
-#define MC13783_IRQSTAT1_THWARNHI	(1 << 13)
-#define MC13783_IRQSTAT1_CLKI		(1 << 14)
-#define MC13783_IRQSTAT1_SEMAFI		(1 << 15)
-#define MC13783_IRQSTAT1_MC2BI		(1 << 17)
-#define MC13783_IRQSTAT1_HSDETI		(1 << 18)
-#define MC13783_IRQSTAT1_HSLI		(1 << 19)
-#define MC13783_IRQSTAT1_ALSPTHI	(1 << 20)
-#define MC13783_IRQSTAT1_AHSSHORTI	(1 << 21)
-
-#define MC13783_IRQMASK1	4
-#define MC13783_IRQMASK1_1HZM		MC13783_IRQSTAT1_1HZI
-#define MC13783_IRQMASK1_TODAM		MC13783_IRQSTAT1_TODAI
-#define MC13783_IRQMASK1_ONOFD1M	MC13783_IRQSTAT1_ONOFD1I
-#define MC13783_IRQMASK1_ONOFD2M	MC13783_IRQSTAT1_ONOFD2I
-#define MC13783_IRQMASK1_ONOFD3M	MC13783_IRQSTAT1_ONOFD3I
-#define MC13783_IRQMASK1_SYSRSTM	MC13783_IRQSTAT1_SYSRSTI
-#define MC13783_IRQMASK1_RTCRSTM	MC13783_IRQSTAT1_RTCRSTI
-#define MC13783_IRQMASK1_PCM		MC13783_IRQSTAT1_PCI
-#define MC13783_IRQMASK1_WARMM		MC13783_IRQSTAT1_WARMI
-#define MC13783_IRQMASK1_MEMHLDM	MC13783_IRQSTAT1_MEMHLDI
-#define MC13783_IRQMASK1_PWRRDYM	MC13783_IRQSTAT1_PWRRDYI
-#define MC13783_IRQMASK1_THWARNLM	MC13783_IRQSTAT1_THWARNLI
-#define MC13783_IRQMASK1_THWARNHM	MC13783_IRQSTAT1_THWARNHI
-#define MC13783_IRQMASK1_CLKM		MC13783_IRQSTAT1_CLKI
-#define MC13783_IRQMASK1_SEMAFM		MC13783_IRQSTAT1_SEMAFI
-#define MC13783_IRQMASK1_MC2BM		MC13783_IRQSTAT1_MC2BI
-#define MC13783_IRQMASK1_HSDETM		MC13783_IRQSTAT1_HSDETI
-#define MC13783_IRQMASK1_HSLM		MC13783_IRQSTAT1_HSLI
-#define MC13783_IRQMASK1_ALSPTHM	MC13783_IRQSTAT1_ALSPTHI
-#define MC13783_IRQMASK1_AHSSHORTM	MC13783_IRQSTAT1_AHSSHORTI
-
-#define MC13783_ADC1		44
-#define MC13783_ADC1_ADEN		(1 << 0)
-#define MC13783_ADC1_RAND		(1 << 1)
-#define MC13783_ADC1_ADSEL		(1 << 3)
-#define MC13783_ADC1_ASC		(1 << 20)
-#define MC13783_ADC1_ADTRIGIGN		(1 << 21)
-
-#define MC13783_NUMREGS 0x3f
-
-void mc13783_lock(struct mc13783 *mc13783)
-{
-	if (!mutex_trylock(&mc13783->lock)) {
-		dev_dbg(&mc13783->spidev->dev, "wait for %s from %pf\n",
-				__func__, __builtin_return_address(0));
-
-		mutex_lock(&mc13783->lock);
-	}
-	dev_dbg(&mc13783->spidev->dev, "%s from %pf\n",
-			__func__, __builtin_return_address(0));
-}
-EXPORT_SYMBOL(mc13783_lock);
-
-void mc13783_unlock(struct mc13783 *mc13783)
-{
-	dev_dbg(&mc13783->spidev->dev, "%s from %pf\n",
-			__func__, __builtin_return_address(0));
-	mutex_unlock(&mc13783->lock);
-}
-EXPORT_SYMBOL(mc13783_unlock);
-
-#define MC13783_REGOFFSET_SHIFT 25
-int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val)
-{
-	struct spi_transfer t;
-	struct spi_message m;
-	int ret;
-
-	BUG_ON(!mutex_is_locked(&mc13783->lock));
-
-	if (offset > MC13783_NUMREGS)
-		return -EINVAL;
-
-	*val = offset << MC13783_REGOFFSET_SHIFT;
-
-	memset(&t, 0, sizeof(t));
-
-	t.tx_buf = val;
-	t.rx_buf = val;
-	t.len = sizeof(u32);
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(mc13783->spidev, &m);
-
-	/* error in message.status implies error return from spi_sync */
-	BUG_ON(!ret && m.status);
-
-	if (ret)
-		return ret;
-
-	*val &= 0xffffff;
-
-	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13783_reg_read);
-
-int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val)
-{
-	u32 buf;
-	struct spi_transfer t;
-	struct spi_message m;
-	int ret;
-
-	BUG_ON(!mutex_is_locked(&mc13783->lock));
-
-	dev_vdbg(&mc13783->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
-
-	if (offset > MC13783_NUMREGS || val > 0xffffff)
-		return -EINVAL;
-
-	buf = 1 << 31 | offset << MC13783_REGOFFSET_SHIFT | val;
-
-	memset(&t, 0, sizeof(t));
-
-	t.tx_buf = &buf;
-	t.rx_buf = &buf;
-	t.len = sizeof(u32);
-
-	spi_message_init(&m);
-	spi_message_add_tail(&t, &m);
-
-	ret = spi_sync(mc13783->spidev, &m);
-
-	BUG_ON(!ret && m.status);
-
-	if (ret)
-		return ret;
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13783_reg_write);
-
-int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
-		u32 mask, u32 val)
-{
-	int ret;
-	u32 valread;
-
-	BUG_ON(val & ~mask);
-
-	ret = mc13783_reg_read(mc13783, offset, &valread);
-	if (ret)
-		return ret;
-
-	valread = (valread & ~mask) | val;
-
-	return mc13783_reg_write(mc13783, offset, valread);
-}
-EXPORT_SYMBOL(mc13783_reg_rmw);
-
-int mc13783_get_flags(struct mc13783 *mc13783)
-{
-	struct mc13783_platform_data *pdata =
-		dev_get_platdata(&mc13783->spidev->dev);
-
-	return pdata->flags;
-}
-EXPORT_SYMBOL(mc13783_get_flags);
-
-int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
-{
-	int ret;
-	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
-	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
-	u32 mask;
-
-	if (irq < 0 || irq >= MC13783_NUM_IRQ)
-		return -EINVAL;
-
-	ret = mc13783_reg_read(mc13783, offmask, &mask);
-	if (ret)
-		return ret;
-
-	if (mask & irqbit)
-		/* already masked */
-		return 0;
-
-	return mc13783_reg_write(mc13783, offmask, mask | irqbit);
-}
-EXPORT_SYMBOL(mc13783_irq_mask);
-
-int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
-{
-	int ret;
-	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
-	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
-	u32 mask;
-
-	if (irq < 0 || irq >= MC13783_NUM_IRQ)
-		return -EINVAL;
-
-	ret = mc13783_reg_read(mc13783, offmask, &mask);
-	if (ret)
-		return ret;
-
-	if (!(mask & irqbit))
-		/* already unmasked */
-		return 0;
-
-	return mc13783_reg_write(mc13783, offmask, mask & ~irqbit);
-}
-EXPORT_SYMBOL(mc13783_irq_unmask);
-
-int mc13783_irq_status(struct mc13783 *mc13783, int irq,
-		int *enabled, int *pending)
-{
-	int ret;
-	unsigned int offmask = irq < 24 ? MC13783_IRQMASK0 : MC13783_IRQMASK1;
-	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
-	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
-
-	if (irq < 0 || irq >= MC13783_NUM_IRQ)
-		return -EINVAL;
-
-	if (enabled) {
-		u32 mask;
-
-		ret = mc13783_reg_read(mc13783, offmask, &mask);
-		if (ret)
-			return ret;
-
-		*enabled = mask & irqbit;
-	}
-
-	if (pending) {
-		u32 stat;
-
-		ret = mc13783_reg_read(mc13783, offstat, &stat);
-		if (ret)
-			return ret;
-
-		*pending = stat & irqbit;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13783_irq_status);
-
-int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
-{
-	unsigned int offstat = irq < 24 ? MC13783_IRQSTAT0 : MC13783_IRQSTAT1;
-	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
-
-	BUG_ON(irq < 0 || irq >= MC13783_NUM_IRQ);
-
-	return mc13783_reg_write(mc13783, offstat, val);
-}
-EXPORT_SYMBOL(mc13783_irq_ack);
-
-int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	BUG_ON(!mutex_is_locked(&mc13783->lock));
-	BUG_ON(!handler);
-
-	if (irq < 0 || irq >= MC13783_NUM_IRQ)
-		return -EINVAL;
-
-	if (mc13783->irqhandler[irq])
-		return -EBUSY;
-
-	mc13783->irqhandler[irq] = handler;
-	mc13783->irqdata[irq] = dev;
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13783_irq_request_nounmask);
-
-int mc13783_irq_request(struct mc13783 *mc13783, int irq,
-		irq_handler_t handler, const char *name, void *dev)
-{
-	int ret;
-
-	ret = mc13783_irq_request_nounmask(mc13783, irq, handler, name, dev);
-	if (ret)
-		return ret;
-
-	ret = mc13783_irq_unmask(mc13783, irq);
-	if (ret) {
-		mc13783->irqhandler[irq] = NULL;
-		mc13783->irqdata[irq] = NULL;
-		return ret;
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13783_irq_request);
-
-int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev)
-{
-	int ret;
-	BUG_ON(!mutex_is_locked(&mc13783->lock));
-
-	if (irq < 0 || irq >= MC13783_NUM_IRQ || !mc13783->irqhandler[irq] ||
-			mc13783->irqdata[irq] != dev)
-		return -EINVAL;
-
-	ret = mc13783_irq_mask(mc13783, irq);
-	if (ret)
-		return ret;
-
-	mc13783->irqhandler[irq] = NULL;
-	mc13783->irqdata[irq] = NULL;
-
-	return 0;
-}
-EXPORT_SYMBOL(mc13783_irq_free);
-
-static inline irqreturn_t mc13783_irqhandler(struct mc13783 *mc13783, int irq)
-{
-	return mc13783->irqhandler[irq](irq, mc13783->irqdata[irq]);
-}
-
-/*
- * returns: number of handled irqs or negative error
- * locking: holds mc13783->lock
- */
-static int mc13783_irq_handle(struct mc13783 *mc13783,
-		unsigned int offstat, unsigned int offmask, int baseirq)
-{
-	u32 stat, mask;
-	int ret = mc13783_reg_read(mc13783, offstat, &stat);
-	int num_handled = 0;
-
-	if (ret)
-		return ret;
-
-	ret = mc13783_reg_read(mc13783, offmask, &mask);
-	if (ret)
-		return ret;
-
-	while (stat & ~mask) {
-		int irq = __ffs(stat & ~mask);
-
-		stat &= ~(1 << irq);
-
-		if (likely(mc13783->irqhandler[baseirq + irq])) {
-			irqreturn_t handled;
-
-			handled = mc13783_irqhandler(mc13783, baseirq + irq);
-			if (handled == IRQ_HANDLED)
-				num_handled++;
-		} else {
-			dev_err(&mc13783->spidev->dev,
-					"BUG: irq %u but no handler\n",
-					baseirq + irq);
-
-			mask |= 1 << irq;
-
-			ret = mc13783_reg_write(mc13783, offmask, mask);
-		}
-	}
-
-	return num_handled;
-}
-
-static irqreturn_t mc13783_irq_thread(int irq, void *data)
-{
-	struct mc13783 *mc13783 = data;
-	irqreturn_t ret;
-	int handled = 0;
-
-	mc13783_lock(mc13783);
-
-	ret = mc13783_irq_handle(mc13783, MC13783_IRQSTAT0,
-			MC13783_IRQMASK0, MC13783_IRQ_ADCDONE);
-	if (ret > 0)
-		handled = 1;
-
-	ret = mc13783_irq_handle(mc13783, MC13783_IRQSTAT1,
-			MC13783_IRQMASK1, MC13783_IRQ_1HZ);
-	if (ret > 0)
-		handled = 1;
-
-	mc13783_unlock(mc13783);
-
-	return IRQ_RETVAL(handled);
-}
-
-#define MC13783_ADC1_CHAN0_SHIFT	5
-#define MC13783_ADC1_CHAN1_SHIFT	8
-
-struct mc13783_adcdone_data {
-	struct mc13783 *mc13783;
-	struct completion done;
-};
-
-static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
-{
-	struct mc13783_adcdone_data *adcdone_data = data;
-
-	mc13783_irq_ack(adcdone_data->mc13783, irq);
-
-	complete_all(&adcdone_data->done);
-
-	return IRQ_HANDLED;
-}
-
-#define MC13783_ADC_WORKING (1 << 0)
-
-int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
-		unsigned int channel, unsigned int *sample)
-{
-	u32 adc0, adc1, old_adc0;
-	int i, ret;
-	struct mc13783_adcdone_data adcdone_data = {
-		.mc13783 = mc13783,
-	};
-	init_completion(&adcdone_data.done);
-
-	dev_dbg(&mc13783->spidev->dev, "%s\n", __func__);
-
-	mc13783_lock(mc13783);
-
-	if (mc13783->adcflags & MC13783_ADC_WORKING) {
-		ret = -EBUSY;
-		goto out;
-	}
-
-	mc13783->adcflags |= MC13783_ADC_WORKING;
-
-	mc13783_reg_read(mc13783, MC13783_ADC0, &old_adc0);
-
-	adc0 = MC13783_ADC0_ADINC1 | MC13783_ADC0_ADINC2;
-	adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN | MC13783_ADC1_ASC;
-
-	if (channel > 7)
-		adc1 |= MC13783_ADC1_ADSEL;
-
-	switch (mode) {
-	case MC13783_ADC_MODE_TS:
-		adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_TSMOD0 |
-			MC13783_ADC0_TSMOD1;
-		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
-		break;
-
-	case MC13783_ADC_MODE_SINGLE_CHAN:
-		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
-		adc1 |= (channel & 0x7) << MC13783_ADC1_CHAN0_SHIFT;
-		adc1 |= MC13783_ADC1_RAND;
-		break;
-
-	case MC13783_ADC_MODE_MULT_CHAN:
-		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
-		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
-		break;
-
-	default:
-		mc13783_unlock(mc13783);
-		return -EINVAL;
-	}
-
-	dev_dbg(&mc13783->spidev->dev, "%s: request irq\n", __func__);
-	mc13783_irq_request(mc13783, MC13783_IRQ_ADCDONE,
-			mc13783_handler_adcdone, __func__, &adcdone_data);
-	mc13783_irq_ack(mc13783, MC13783_IRQ_ADCDONE);
-
-	mc13783_reg_write(mc13783, MC13783_REG_ADC_0, adc0);
-	mc13783_reg_write(mc13783, MC13783_REG_ADC_1, adc1);
-
-	mc13783_unlock(mc13783);
-
-	ret = wait_for_completion_interruptible_timeout(&adcdone_data.done, HZ);
-
-	if (!ret)
-		ret = -ETIMEDOUT;
-
-	mc13783_lock(mc13783);
-
-	mc13783_irq_free(mc13783, MC13783_IRQ_ADCDONE, &adcdone_data);
-
-	if (ret > 0)
-		for (i = 0; i < 4; ++i) {
-			ret = mc13783_reg_read(mc13783,
-					MC13783_REG_ADC_2, &sample[i]);
-			if (ret)
-				break;
-		}
-
-	if (mode == MC13783_ADC_MODE_TS)
-		/* restore TSMOD */
-		mc13783_reg_write(mc13783, MC13783_REG_ADC_0, old_adc0);
-
-	mc13783->adcflags &= ~MC13783_ADC_WORKING;
-out:
-	mc13783_unlock(mc13783);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
-
-static int mc13783_add_subdevice_pdata(struct mc13783 *mc13783,
-		const char *name, void *pdata, size_t pdata_size)
-{
-	struct mfd_cell cell = {
-		.name = name,
-		.platform_data = pdata,
-		.data_size = pdata_size,
-	};
-
-	return mfd_add_devices(&mc13783->spidev->dev, -1, &cell, 1, NULL, 0);
-}
-
-static int mc13783_add_subdevice(struct mc13783 *mc13783, const char *name)
-{
-	return mc13783_add_subdevice_pdata(mc13783, name, NULL, 0);
-}
-
-static int mc13783_check_revision(struct mc13783 *mc13783)
-{
-	u32 rev_id, rev1, rev2, finid, icid;
-
-	mc13783_reg_read(mc13783, MC13783_REG_REVISION, &rev_id);
-
-	rev1 = (rev_id & 0x018) >> 3;
-	rev2 = (rev_id & 0x007);
-	icid = (rev_id & 0x01C0) >> 6;
-	finid = (rev_id & 0x01E00) >> 9;
-
-	/* Ver 0.2 is actually 3.2a.  Report as 3.2 */
-	if ((rev1 == 0) && (rev2 == 2))
-		rev1 = 3;
-
-	if (rev1 == 0 || icid != 2) {
-		dev_err(&mc13783->spidev->dev, "No MC13783 detected.\n");
-		return -ENODEV;
-	}
-
-	dev_info(&mc13783->spidev->dev,
-			"MC13783 Rev %d.%d FinVer %x detected\n",
-			rev1, rev2, finid);
-
-	return 0;
-}
-
-static int mc13783_probe(struct spi_device *spi)
-{
-	struct mc13783 *mc13783;
-	struct mc13783_platform_data *pdata = dev_get_platdata(&spi->dev);
-	int ret;
-
-	mc13783 = kzalloc(sizeof(*mc13783), GFP_KERNEL);
-	if (!mc13783)
-		return -ENOMEM;
-
-	dev_set_drvdata(&spi->dev, mc13783);
-	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
-	spi->bits_per_word = 32;
-	spi_setup(spi);
-
-	mc13783->spidev = spi;
-
-	mutex_init(&mc13783->lock);
-	mc13783_lock(mc13783);
-
-	ret = mc13783_check_revision(mc13783);
-	if (ret)
-		goto err_revision;
-
-	/* mask all irqs */
-	ret = mc13783_reg_write(mc13783, MC13783_IRQMASK0, 0x00ffffff);
-	if (ret)
-		goto err_mask;
-
-	ret = mc13783_reg_write(mc13783, MC13783_IRQMASK1, 0x00ffffff);
-	if (ret)
-		goto err_mask;
-
-	ret = request_threaded_irq(spi->irq, NULL, mc13783_irq_thread,
-			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13783", mc13783);
-
-	if (ret) {
-err_mask:
-err_revision:
-		mutex_unlock(&mc13783->lock);
-		dev_set_drvdata(&spi->dev, NULL);
-		kfree(mc13783);
-		return ret;
-	}
-
-	mc13783_unlock(mc13783);
-
-	if (pdata->flags & MC13783_USE_ADC)
-		mc13783_add_subdevice(mc13783, "mc13783-adc");
-
-	if (pdata->flags & MC13783_USE_CODEC)
-		mc13783_add_subdevice(mc13783, "mc13783-codec");
-
-	if (pdata->flags & MC13783_USE_REGULATOR) {
-		struct mc13783_regulator_platform_data regulator_pdata = {
-			.num_regulators = pdata->num_regulators,
-			.regulators = pdata->regulators,
-		};
-
-		mc13783_add_subdevice_pdata(mc13783, "mc13783-regulator",
-				&regulator_pdata, sizeof(regulator_pdata));
-	}
-
-	if (pdata->flags & MC13783_USE_RTC)
-		mc13783_add_subdevice(mc13783, "mc13783-rtc");
-
-	if (pdata->flags & MC13783_USE_TOUCHSCREEN)
-		mc13783_add_subdevice(mc13783, "mc13783-ts");
-
-	if (pdata->flags & MC13783_USE_LED)
-		mc13783_add_subdevice_pdata(mc13783, "mc13783-led",
-					pdata->leds, sizeof(*pdata->leds));
-
-	return 0;
-}
-
-static int __devexit mc13783_remove(struct spi_device *spi)
-{
-	struct mc13783 *mc13783 = dev_get_drvdata(&spi->dev);
-
-	free_irq(mc13783->spidev->irq, mc13783);
-
-	mfd_remove_devices(&spi->dev);
-
-	return 0;
-}
-
-static struct spi_driver mc13783_driver = {
-	.driver = {
-		.name = "mc13783",
-		.bus = &spi_bus_type,
-		.owner = THIS_MODULE,
-	},
-	.probe = mc13783_probe,
-	.remove = __devexit_p(mc13783_remove),
-};
-
-static int __init mc13783_init(void)
-{
-	return spi_register_driver(&mc13783_driver);
-}
-subsys_initcall(mc13783_init);
-
-static void __exit mc13783_exit(void)
-{
-	spi_unregister_driver(&mc13783_driver);
-}
-module_exit(mc13783_exit);
-
-MODULE_DESCRIPTION("Core driver for Freescale MC13783 PMIC");
-MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
-MODULE_LICENSE("GPL v2");
diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
new file mode 100644
index 0000000..93258ad
--- /dev/null
+++ b/drivers/mfd/mc13xxx-core.c
@@ -0,0 +1,840 @@
+/*
+ * Copyright 2009-2010 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * loosely based on an earlier driver that has
+ * Copyright 2009 Pengutronix, Sascha Hauer <s.hauer@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#define DEBUG
+#define VERBOSE_DEBUG
+
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/interrupt.h>
+#include <linux/spi/spi.h>
+#include <linux/mfd/core.h>
+#include <linux/mfd/mc13xxx.h>
+
+struct mc13xxx {
+	struct spi_device *spidev;
+	struct mutex lock;
+	int irq;
+
+	irq_handler_t irqhandler[MC13XXX_NUM_IRQ];
+	void *irqdata[MC13XXX_NUM_IRQ];
+};
+
+struct mc13783 {
+	struct mc13xxx mc13xxx;
+
+	int adcflags;
+};
+
+struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783)
+{
+	return &mc13783->mc13xxx;
+}
+EXPORT_SYMBOL(mc13783_to_mc13xxx);
+
+#define MC13XXX_IRQSTAT0	0
+#define MC13XXX_IRQSTAT0_ADCDONEI	(1 << 0)
+#define MC13XXX_IRQSTAT0_ADCBISDONEI	(1 << 1)
+#define MC13XXX_IRQSTAT0_TSI		(1 << 2)
+#define MC13783_IRQSTAT0_WHIGHI		(1 << 3)
+#define MC13783_IRQSTAT0_WLOWI		(1 << 4)
+#define MC13XXX_IRQSTAT0_CHGDETI	(1 << 6)
+#define MC13783_IRQSTAT0_CHGOVI		(1 << 7)
+#define MC13XXX_IRQSTAT0_CHGREVI	(1 << 8)
+#define MC13XXX_IRQSTAT0_CHGSHORTI	(1 << 9)
+#define MC13XXX_IRQSTAT0_CCCVI		(1 << 10)
+#define MC13XXX_IRQSTAT0_CHGCURRI	(1 << 11)
+#define MC13XXX_IRQSTAT0_BPONI		(1 << 12)
+#define MC13XXX_IRQSTAT0_LOBATLI	(1 << 13)
+#define MC13XXX_IRQSTAT0_LOBATHI	(1 << 14)
+#define MC13783_IRQSTAT0_UDPI		(1 << 15)
+#define MC13783_IRQSTAT0_USBI		(1 << 16)
+#define MC13783_IRQSTAT0_IDI		(1 << 19)
+#define MC13783_IRQSTAT0_SE1I		(1 << 21)
+#define MC13783_IRQSTAT0_CKDETI		(1 << 22)
+#define MC13783_IRQSTAT0_UDMI		(1 << 23)
+
+#define MC13XXX_IRQMASK0	1
+#define MC13XXX_IRQMASK0_ADCDONEM	MC13XXX_IRQSTAT0_ADCDONEI
+#define MC13XXX_IRQMASK0_ADCBISDONEM	MC13XXX_IRQSTAT0_ADCBISDONEI
+#define MC13XXX_IRQMASK0_TSM		MC13XXX_IRQSTAT0_TSI
+#define MC13783_IRQMASK0_WHIGHM		MC13783_IRQSTAT0_WHIGHI
+#define MC13783_IRQMASK0_WLOWM		MC13783_IRQSTAT0_WLOWI
+#define MC13XXX_IRQMASK0_CHGDETM	MC13XXX_IRQSTAT0_CHGDETI
+#define MC13783_IRQMASK0_CHGOVM		MC13783_IRQSTAT0_CHGOVI
+#define MC13XXX_IRQMASK0_CHGREVM	MC13XXX_IRQSTAT0_CHGREVI
+#define MC13XXX_IRQMASK0_CHGSHORTM	MC13XXX_IRQSTAT0_CHGSHORTI
+#define MC13XXX_IRQMASK0_CCCVM		MC13XXX_IRQSTAT0_CCCVI
+#define MC13XXX_IRQMASK0_CHGCURRM	MC13XXX_IRQSTAT0_CHGCURRI
+#define MC13XXX_IRQMASK0_BPONM		MC13XXX_IRQSTAT0_BPONI
+#define MC13XXX_IRQMASK0_LOBATLM	MC13XXX_IRQSTAT0_LOBATLI
+#define MC13XXX_IRQMASK0_LOBATHM	MC13XXX_IRQSTAT0_LOBATHI
+#define MC13783_IRQMASK0_UDPM		MC13783_IRQSTAT0_UDPI
+#define MC13783_IRQMASK0_USBM		MC13783_IRQSTAT0_USBI
+#define MC13783_IRQMASK0_IDM		MC13783_IRQSTAT0_IDI
+#define MC13783_IRQMASK0_SE1M		MC13783_IRQSTAT0_SE1I
+#define MC13783_IRQMASK0_CKDETM		MC13783_IRQSTAT0_CKDETI
+#define MC13783_IRQMASK0_UDMM		MC13783_IRQSTAT0_UDMI
+
+#define MC13XXX_IRQSTAT1	3
+#define MC13XXX_IRQSTAT1_1HZI		(1 << 0)
+#define MC13XXX_IRQSTAT1_TODAI		(1 << 1)
+#define MC13783_IRQSTAT1_ONOFD1I	(1 << 3)
+#define MC13783_IRQSTAT1_ONOFD2I	(1 << 4)
+#define MC13783_IRQSTAT1_ONOFD3I	(1 << 5)
+#define MC13XXX_IRQSTAT1_SYSRSTI	(1 << 6)
+#define MC13XXX_IRQSTAT1_RTCRSTI	(1 << 7)
+#define MC13XXX_IRQSTAT1_PCI		(1 << 8)
+#define MC13XXX_IRQSTAT1_WARMI		(1 << 9)
+#define MC13XXX_IRQSTAT1_MEMHLDI	(1 << 10)
+#define MC13783_IRQSTAT1_PWRRDYI	(1 << 11)
+#define MC13XXX_IRQSTAT1_THWARNLI	(1 << 12)
+#define MC13XXX_IRQSTAT1_THWARNHI	(1 << 13)
+#define MC13XXX_IRQSTAT1_CLKI		(1 << 14)
+#define MC13783_IRQSTAT1_SEMAFI		(1 << 15)
+#define MC13783_IRQSTAT1_MC2BI		(1 << 17)
+#define MC13783_IRQSTAT1_HSDETI		(1 << 18)
+#define MC13783_IRQSTAT1_HSLI		(1 << 19)
+#define MC13783_IRQSTAT1_ALSPTHI	(1 << 20)
+#define MC13783_IRQSTAT1_AHSSHORTI	(1 << 21)
+
+#define MC13XXX_IRQMASK1	4
+#define MC13XXX_IRQMASK1_1HZM		MC13XXX_IRQSTAT1_1HZI
+#define MC13XXX_IRQMASK1_TODAM		MC13XXX_IRQSTAT1_TODAI
+#define MC13783_IRQMASK1_ONOFD1M	MC13783_IRQSTAT1_ONOFD1I
+#define MC13783_IRQMASK1_ONOFD2M	MC13783_IRQSTAT1_ONOFD2I
+#define MC13783_IRQMASK1_ONOFD3M	MC13783_IRQSTAT1_ONOFD3I
+#define MC13XXX_IRQMASK1_SYSRSTM	MC13XXX_IRQSTAT1_SYSRSTI
+#define MC13XXX_IRQMASK1_RTCRSTM	MC13XXX_IRQSTAT1_RTCRSTI
+#define MC13XXX_IRQMASK1_PCM		MC13XXX_IRQSTAT1_PCI
+#define MC13XXX_IRQMASK1_WARMM		MC13XXX_IRQSTAT1_WARMI
+#define MC13XXX_IRQMASK1_MEMHLDM	MC13XXX_IRQSTAT1_MEMHLDI
+#define MC13783_IRQMASK1_PWRRDYM	MC13783_IRQSTAT1_PWRRDYI
+#define MC13XXX_IRQMASK1_THWARNLM	MC13XXX_IRQSTAT1_THWARNLI
+#define MC13XXX_IRQMASK1_THWARNHM	MC13XXX_IRQSTAT1_THWARNHI
+#define MC13XXX_IRQMASK1_CLKM		MC13XXX_IRQSTAT1_CLKI
+#define MC13783_IRQMASK1_SEMAFM		MC13783_IRQSTAT1_SEMAFI
+#define MC13783_IRQMASK1_MC2BM		MC13783_IRQSTAT1_MC2BI
+#define MC13783_IRQMASK1_HSDETM		MC13783_IRQSTAT1_HSDETI
+#define MC13783_IRQMASK1_HSLM		MC13783_IRQSTAT1_HSLI
+#define MC13783_IRQMASK1_ALSPTHM	MC13783_IRQSTAT1_ALSPTHI
+#define MC13783_IRQMASK1_AHSSHORTM	MC13783_IRQSTAT1_AHSSHORTI
+
+#define MC13XXX_REVISION	7
+#define MC13XXX_REVISION_REVMETAL	(0x07 <<  0)
+#define MC13XXX_REVISION_REVFULL	(0x03 <<  3)
+#define MC13XXX_REVISION_ICID		(0x07 <<  6)
+#define MC13XXX_REVISION_FIN		(0x03 <<  9)
+#define MC13XXX_REVISION_FAB		(0x03 << 11)
+#define MC13XXX_REVISION_ICIDCODE	(0x3f << 13)
+
+#define MC13783_ADC1		44
+#define MC13783_ADC1_ADEN		(1 << 0)
+#define MC13783_ADC1_RAND		(1 << 1)
+#define MC13783_ADC1_ADSEL		(1 << 3)
+#define MC13783_ADC1_ASC		(1 << 20)
+#define MC13783_ADC1_ADTRIGIGN		(1 << 21)
+
+#define MC13783_ADC2		45
+
+#define MC13XXX_NUMREGS 0x3f
+
+void mc13xxx_lock(struct mc13xxx *mc13xxx)
+{
+	if (!mutex_trylock(&mc13xxx->lock)) {
+		dev_dbg(&mc13xxx->spidev->dev, "wait for %s from %pf\n",
+				__func__, __builtin_return_address(0));
+
+		mutex_lock(&mc13xxx->lock);
+	}
+	dev_dbg(&mc13xxx->spidev->dev, "%s from %pf\n",
+			__func__, __builtin_return_address(0));
+}
+EXPORT_SYMBOL(mc13xxx_lock);
+
+void mc13xxx_unlock(struct mc13xxx *mc13xxx)
+{
+	dev_dbg(&mc13xxx->spidev->dev, "%s from %pf\n",
+			__func__, __builtin_return_address(0));
+	mutex_unlock(&mc13xxx->lock);
+}
+EXPORT_SYMBOL(mc13xxx_unlock);
+
+#define MC13XXX_REGOFFSET_SHIFT 25
+int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
+{
+	struct spi_transfer t;
+	struct spi_message m;
+	int ret;
+
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+
+	if (offset > MC13XXX_NUMREGS)
+		return -EINVAL;
+
+	*val = offset << MC13XXX_REGOFFSET_SHIFT;
+
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = val;
+	t.rx_buf = val;
+	t.len = sizeof(u32);
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+
+	ret = spi_sync(mc13xxx->spidev, &m);
+
+	/* error in message.status implies error return from spi_sync */
+	BUG_ON(!ret && m.status);
+
+	if (ret)
+		return ret;
+
+	*val &= 0xffffff;
+
+	dev_vdbg(&mc13xxx->spidev->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13xxx_reg_read);
+
+int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
+{
+	u32 buf;
+	struct spi_transfer t;
+	struct spi_message m;
+	int ret;
+
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+
+	dev_vdbg(&mc13xxx->spidev->dev, "[0x%02x] <- 0x%06x\n", offset, val);
+
+	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
+		return -EINVAL;
+
+	buf = 1 << 31 | offset << MC13XXX_REGOFFSET_SHIFT | val;
+
+	memset(&t, 0, sizeof(t));
+
+	t.tx_buf = &buf;
+	t.rx_buf = &buf;
+	t.len = sizeof(u32);
+
+	spi_message_init(&m);
+	spi_message_add_tail(&t, &m);
+
+	ret = spi_sync(mc13xxx->spidev, &m);
+
+	BUG_ON(!ret && m.status);
+
+	if (ret)
+		return ret;
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13xxx_reg_write);
+
+int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
+		u32 mask, u32 val)
+{
+	int ret;
+	u32 valread;
+
+	BUG_ON(val & ~mask);
+
+	ret = mc13xxx_reg_read(mc13xxx, offset, &valread);
+	if (ret)
+		return ret;
+
+	valread = (valread & ~mask) | val;
+
+	return mc13xxx_reg_write(mc13xxx, offset, valread);
+}
+EXPORT_SYMBOL(mc13xxx_reg_rmw);
+
+int mc13xxx_irq_mask(struct mc13xxx *mc13xxx, int irq)
+{
+	int ret;
+	unsigned int offmask = irq < 24 ? MC13XXX_IRQMASK0 : MC13XXX_IRQMASK1;
+	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
+	u32 mask;
+
+	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
+		return -EINVAL;
+
+	ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
+	if (ret)
+		return ret;
+
+	if (mask & irqbit)
+		/* already masked */
+		return 0;
+
+	return mc13xxx_reg_write(mc13xxx, offmask, mask | irqbit);
+}
+EXPORT_SYMBOL(mc13xxx_irq_mask);
+
+int mc13xxx_irq_unmask(struct mc13xxx *mc13xxx, int irq)
+{
+	int ret;
+	unsigned int offmask = irq < 24 ? MC13XXX_IRQMASK0 : MC13XXX_IRQMASK1;
+	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
+	u32 mask;
+
+	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
+		return -EINVAL;
+
+	ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
+	if (ret)
+		return ret;
+
+	if (!(mask & irqbit))
+		/* already unmasked */
+		return 0;
+
+	return mc13xxx_reg_write(mc13xxx, offmask, mask & ~irqbit);
+}
+EXPORT_SYMBOL(mc13xxx_irq_unmask);
+
+int mc13xxx_irq_status(struct mc13xxx *mc13xxx, int irq,
+		int *enabled, int *pending)
+{
+	int ret;
+	unsigned int offmask = irq < 24 ? MC13XXX_IRQMASK0 : MC13XXX_IRQMASK1;
+	unsigned int offstat = irq < 24 ? MC13XXX_IRQSTAT0 : MC13XXX_IRQSTAT1;
+	u32 irqbit = 1 << (irq < 24 ? irq : irq - 24);
+
+	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
+		return -EINVAL;
+
+	if (enabled) {
+		u32 mask;
+
+		ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
+		if (ret)
+			return ret;
+
+		*enabled = mask & irqbit;
+	}
+
+	if (pending) {
+		u32 stat;
+
+		ret = mc13xxx_reg_read(mc13xxx, offstat, &stat);
+		if (ret)
+			return ret;
+
+		*pending = stat & irqbit;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13xxx_irq_status);
+
+int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq)
+{
+	unsigned int offstat = irq < 24 ? MC13XXX_IRQSTAT0 : MC13XXX_IRQSTAT1;
+	unsigned int val = 1 << (irq < 24 ? irq : irq - 24);
+
+	BUG_ON(irq < 0 || irq >= MC13XXX_NUM_IRQ);
+
+	return mc13xxx_reg_write(mc13xxx, offstat, val);
+}
+EXPORT_SYMBOL(mc13xxx_irq_ack);
+
+int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
+		irq_handler_t handler, const char *name, void *dev)
+{
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+	BUG_ON(!handler);
+
+	if (irq < 0 || irq >= MC13XXX_NUM_IRQ)
+		return -EINVAL;
+
+	if (mc13xxx->irqhandler[irq])
+		return -EBUSY;
+
+	mc13xxx->irqhandler[irq] = handler;
+	mc13xxx->irqdata[irq] = dev;
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13xxx_irq_request_nounmask);
+
+int mc13xxx_irq_request(struct mc13xxx *mc13xxx, int irq,
+		irq_handler_t handler, const char *name, void *dev)
+{
+	int ret;
+
+	ret = mc13xxx_irq_request_nounmask(mc13xxx, irq, handler, name, dev);
+	if (ret)
+		return ret;
+
+	ret = mc13xxx_irq_unmask(mc13xxx, irq);
+	if (ret) {
+		mc13xxx->irqhandler[irq] = NULL;
+		mc13xxx->irqdata[irq] = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13xxx_irq_request);
+
+int mc13xxx_irq_free(struct mc13xxx *mc13xxx, int irq, void *dev)
+{
+	int ret;
+	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
+
+	if (irq < 0 || irq >= MC13XXX_NUM_IRQ || !mc13xxx->irqhandler[irq] ||
+			mc13xxx->irqdata[irq] != dev)
+		return -EINVAL;
+
+	ret = mc13xxx_irq_mask(mc13xxx, irq);
+	if (ret)
+		return ret;
+
+	mc13xxx->irqhandler[irq] = NULL;
+	mc13xxx->irqdata[irq] = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL(mc13xxx_irq_free);
+
+static inline irqreturn_t mc13xxx_irqhandler(struct mc13xxx *mc13xxx, int irq)
+{
+	return mc13xxx->irqhandler[irq](irq, mc13xxx->irqdata[irq]);
+}
+
+/*
+ * returns: number of handled irqs or negative error
+ * locking: holds mc13xxx->lock
+ */
+static int mc13xxx_irq_handle(struct mc13xxx *mc13xxx,
+		unsigned int offstat, unsigned int offmask, int baseirq)
+{
+	u32 stat, mask;
+	int ret = mc13xxx_reg_read(mc13xxx, offstat, &stat);
+	int num_handled = 0;
+
+	if (ret)
+		return ret;
+
+	ret = mc13xxx_reg_read(mc13xxx, offmask, &mask);
+	if (ret)
+		return ret;
+
+	while (stat & ~mask) {
+		int irq = __ffs(stat & ~mask);
+
+		stat &= ~(1 << irq);
+
+		if (likely(mc13xxx->irqhandler[baseirq + irq])) {
+			irqreturn_t handled;
+
+			handled = mc13xxx_irqhandler(mc13xxx, baseirq + irq);
+			if (handled == IRQ_HANDLED)
+				num_handled++;
+		} else {
+			dev_err(&mc13xxx->spidev->dev,
+					"BUG: irq %u but no handler\n",
+					baseirq + irq);
+
+			mask |= 1 << irq;
+
+			ret = mc13xxx_reg_write(mc13xxx, offmask, mask);
+		}
+	}
+
+	return num_handled;
+}
+
+static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
+{
+	struct mc13xxx *mc13xxx = data;
+	irqreturn_t ret;
+	int handled = 0;
+
+	mc13xxx_lock(mc13xxx);
+
+	ret = mc13xxx_irq_handle(mc13xxx, MC13XXX_IRQSTAT0,
+			MC13XXX_IRQMASK0, 0);
+	if (ret > 0)
+		handled = 1;
+
+	ret = mc13xxx_irq_handle(mc13xxx, MC13XXX_IRQSTAT1,
+			MC13XXX_IRQMASK1, 24);
+	if (ret > 0)
+		handled = 1;
+
+	mc13xxx_unlock(mc13xxx);
+
+	return IRQ_RETVAL(handled);
+}
+
+enum mc13xxx_id {
+	MC13XXX_ID_MC13783,
+	MC13XXX_ID_MC13892,
+	MC13XXX_ID_INVALID,
+};
+
+const char *mc13xxx_chipname[] = {
+	[MC13XXX_ID_MC13783] = "mc13783",
+	[MC13XXX_ID_MC13892] = "mc13892",
+};
+
+#define maskval(reg, mask)	(((reg) & (mask)) >> __ffs(mask))
+static int mc13xxx_identify(struct mc13xxx *mc13xxx, enum mc13xxx_id *id)
+{
+	u32 icid;
+	u32 revision;
+	const char *name;
+	int ret;
+
+	ret = mc13xxx_reg_read(mc13xxx, 46, &icid);
+	if (ret)
+		return ret;
+
+	icid = (icid >> 6) & 0x7;
+
+	switch (icid) {
+	case 2:
+		*id = MC13XXX_ID_MC13783;
+		name = "mc13783";
+		break;
+	case 7:
+		*id = MC13XXX_ID_MC13892;
+		name = "mc13892";
+		break;
+	default:
+		*id = MC13XXX_ID_INVALID;
+		break;
+	}
+
+	if (*id == MC13XXX_ID_MC13783 || *id == MC13XXX_ID_MC13892) {
+		ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
+		if (ret)
+			return ret;
+
+		dev_info(&mc13xxx->spidev->dev, "%s: rev: %d.%d, "
+				"fin: %d, fab: %d, icid: %d/%d\n",
+				mc13xxx_chipname[*id],
+				maskval(revision, MC13XXX_REVISION_REVFULL),
+				maskval(revision, MC13XXX_REVISION_REVMETAL),
+				maskval(revision, MC13XXX_REVISION_FIN),
+				maskval(revision, MC13XXX_REVISION_FAB),
+				maskval(revision, MC13XXX_REVISION_ICID),
+				maskval(revision, MC13XXX_REVISION_ICIDCODE));
+	}
+
+	if (*id != MC13XXX_ID_INVALID) {
+		const struct spi_device_id *devid =
+			spi_get_device_id(mc13xxx->spidev);
+		if (!devid || devid->driver_data != *id)
+			dev_warn(&mc13xxx->spidev->dev, "device id doesn't "
+					"match auto detection!\n");
+	}
+
+	return 0;
+}
+
+static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
+{
+	const struct spi_device_id *devid =
+		spi_get_device_id(mc13xxx->spidev);
+
+	if (!devid)
+		return NULL;
+
+	return mc13xxx_chipname[devid->driver_data];
+}
+
+#include <linux/mfd/mc13783.h>
+
+int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
+{
+	struct mc13xxx_platform_data *pdata =
+		dev_get_platdata(&mc13xxx->spidev->dev);
+
+	return pdata->flags;
+}
+EXPORT_SYMBOL(mc13xxx_get_flags);
+
+#define MC13783_ADC1_CHAN0_SHIFT	5
+#define MC13783_ADC1_CHAN1_SHIFT	8
+
+struct mc13xxx_adcdone_data {
+	struct mc13xxx *mc13xxx;
+	struct completion done;
+};
+
+static irqreturn_t mc13783_handler_adcdone(int irq, void *data)
+{
+	struct mc13xxx_adcdone_data *adcdone_data = data;
+
+	mc13xxx_irq_ack(adcdone_data->mc13xxx, irq);
+
+	complete_all(&adcdone_data->done);
+
+	return IRQ_HANDLED;
+}
+
+#define MC13783_ADC_WORKING (1 << 0)
+
+int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
+		unsigned int channel, unsigned int *sample)
+{
+	struct mc13xxx *mc13xxx = &mc13783->mc13xxx;
+	u32 adc0, adc1, old_adc0;
+	int i, ret;
+	struct mc13xxx_adcdone_data adcdone_data = {
+		.mc13xxx = mc13xxx,
+	};
+	init_completion(&adcdone_data.done);
+
+	dev_dbg(&mc13xxx->spidev->dev, "%s\n", __func__);
+
+	mc13xxx_lock(mc13xxx);
+
+	if (mc13783->adcflags & MC13783_ADC_WORKING) {
+		ret = -EBUSY;
+		goto out;
+	}
+
+	mc13783->adcflags |= MC13783_ADC_WORKING;
+
+	mc13xxx_reg_read(mc13xxx, MC13783_ADC0, &old_adc0);
+
+	adc0 = MC13783_ADC0_ADINC1 | MC13783_ADC0_ADINC2;
+	adc1 = MC13783_ADC1_ADEN | MC13783_ADC1_ADTRIGIGN | MC13783_ADC1_ASC;
+
+	if (channel > 7)
+		adc1 |= MC13783_ADC1_ADSEL;
+
+	switch (mode) {
+	case MC13783_ADC_MODE_TS:
+		adc0 |= MC13783_ADC0_ADREFEN | MC13783_ADC0_TSMOD0 |
+			MC13783_ADC0_TSMOD1;
+		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
+		break;
+
+	case MC13783_ADC_MODE_SINGLE_CHAN:
+		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
+		adc1 |= (channel & 0x7) << MC13783_ADC1_CHAN0_SHIFT;
+		adc1 |= MC13783_ADC1_RAND;
+		break;
+
+	case MC13783_ADC_MODE_MULT_CHAN:
+		adc0 |= old_adc0 & MC13783_ADC0_TSMOD_MASK;
+		adc1 |= 4 << MC13783_ADC1_CHAN1_SHIFT;
+		break;
+
+	default:
+		mc13783_unlock(mc13783);
+		return -EINVAL;
+	}
+
+	dev_dbg(&mc13783->mc13xxx.spidev->dev, "%s: request irq\n", __func__);
+	mc13xxx_irq_request(mc13xxx, MC13783_IRQ_ADCDONE,
+			mc13783_handler_adcdone, __func__, &adcdone_data);
+	mc13xxx_irq_ack(mc13xxx, MC13783_IRQ_ADCDONE);
+
+	mc13xxx_reg_write(mc13xxx, MC13783_ADC0, adc0);
+	mc13xxx_reg_write(mc13xxx, MC13783_ADC1, adc1);
+
+	mc13xxx_unlock(mc13xxx);
+
+	ret = wait_for_completion_interruptible_timeout(&adcdone_data.done, HZ);
+
+	if (!ret)
+		ret = -ETIMEDOUT;
+
+	mc13xxx_lock(mc13xxx);
+
+	mc13xxx_irq_free(mc13xxx, MC13783_IRQ_ADCDONE, &adcdone_data);
+
+	if (ret > 0)
+		for (i = 0; i < 4; ++i) {
+			ret = mc13xxx_reg_read(mc13xxx,
+					MC13783_ADC2, &sample[i]);
+			if (ret)
+				break;
+		}
+
+	if (mode == MC13783_ADC_MODE_TS)
+		/* restore TSMOD */
+		mc13xxx_reg_write(mc13xxx, MC13783_ADC0, old_adc0);
+
+	mc13783->adcflags &= ~MC13783_ADC_WORKING;
+out:
+	mc13xxx_unlock(mc13xxx);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mc13783_adc_do_conversion);
+
+static int mc13xxx_add_subdevice_pdata(struct mc13xxx *mc13xxx,
+		const char *format, void *pdata, size_t pdata_size)
+{
+	char buf[30];
+	const char *name = mc13xxx_get_chipname(mc13xxx);
+
+	struct mfd_cell cell = {
+		.platform_data = pdata,
+		.data_size = pdata_size,
+	};
+
+	/* there is no asnprintf in the kernel :-( */
+	if (snprintf(buf, sizeof(buf), format, name) > sizeof(buf))
+		return -E2BIG;
+
+	cell.name = kmemdup(buf, strlen(buf) + 1, GFP_KERNEL);
+	if (!cell.name)
+		return -ENOMEM;
+
+	return mfd_add_devices(&mc13xxx->spidev->dev, -1, &cell, 1, NULL, 0);
+}
+
+static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
+{
+	return mc13xxx_add_subdevice_pdata(mc13xxx, format, NULL, 0);
+}
+
+static int mc13xxx_probe(struct spi_device *spi)
+{
+	struct mc13xxx *mc13xxx;
+	struct mc13xxx_platform_data *pdata = dev_get_platdata(&spi->dev);
+	enum mc13xxx_id id;
+	int ret;
+
+	mc13xxx = kzalloc(sizeof(*mc13xxx), GFP_KERNEL);
+	if (!mc13xxx)
+		return -ENOMEM;
+
+	dev_set_drvdata(&spi->dev, mc13xxx);
+	spi->mode = SPI_MODE_0 | SPI_CS_HIGH;
+	spi->bits_per_word = 32;
+	spi_setup(spi);
+
+	mc13xxx->spidev = spi;
+
+	mutex_init(&mc13xxx->lock);
+	mc13xxx_lock(mc13xxx);
+
+	ret = mc13xxx_identify(mc13xxx, &id);
+	if (ret || id == MC13XXX_ID_INVALID)
+		goto err_revision;
+
+	/* mask all irqs */
+	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
+	if (ret)
+		goto err_mask;
+
+	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK1, 0x00ffffff);
+	if (ret)
+		goto err_mask;
+
+	ret = request_threaded_irq(spi->irq, NULL, mc13xxx_irq_thread,
+			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
+
+	if (ret) {
+err_mask:
+err_revision:
+		mutex_unlock(&mc13xxx->lock);
+		dev_set_drvdata(&spi->dev, NULL);
+		kfree(mc13xxx);
+		return ret;
+	}
+
+	mc13xxx_unlock(mc13xxx);
+
+	if (pdata->flags & MC13XXX_USE_ADC)
+		mc13xxx_add_subdevice(mc13xxx, "%s-adc");
+
+	if (pdata->flags & MC13XXX_USE_CODEC)
+		mc13xxx_add_subdevice(mc13xxx, "%s-codec");
+
+	if (pdata->flags & MC13XXX_USE_REGULATOR) {
+		struct mc13xxx_regulator_platform_data regulator_pdata = {
+			.num_regulators = pdata->num_regulators,
+			.regulators = pdata->regulators,
+		};
+
+		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-regulator",
+				&regulator_pdata, sizeof(regulator_pdata));
+	}
+
+	if (pdata->flags & MC13XXX_USE_RTC)
+		mc13xxx_add_subdevice(mc13xxx, "%s-rtc");
+
+	if (pdata->flags & MC13XXX_USE_TOUCHSCREEN)
+		mc13xxx_add_subdevice(mc13xxx, "%s-ts");
+
+	if (pdata->flags & MC13XXX_USE_LED) {
+		mc13xxx_add_subdevice_pdata(mc13xxx, "%s-led",
+					pdata->leds, sizeof(*pdata->leds));
+	}
+
+	return 0;
+}
+
+static int __devexit mc13xxx_remove(struct spi_device *spi)
+{
+	struct mc13xxx *mc13xxx = dev_get_drvdata(&spi->dev);
+
+	free_irq(mc13xxx->spidev->irq, mc13xxx);
+
+	mfd_remove_devices(&spi->dev);
+
+	return 0;
+}
+
+static const struct spi_device_id mc13xxx_device_id[] = {
+	{
+		.name = "mc13783",
+		.driver_data = MC13XXX_ID_MC13783,
+	}, {
+		.name = "mc13892",
+		.driver_data = MC13XXX_ID_MC13892,
+	}, {
+		/* sentinel */
+	}
+};
+
+static struct spi_driver mc13xxx_driver = {
+	.id_table = mc13xxx_device_id,
+	.driver = {
+		.name = "mc13xxx",
+		.bus = &spi_bus_type,
+		.owner = THIS_MODULE,
+	},
+	.probe = mc13xxx_probe,
+	.remove = __devexit_p(mc13xxx_remove),
+};
+
+static int __init mc13xxx_init(void)
+{
+	return spi_register_driver(&mc13xxx_driver);
+}
+subsys_initcall(mc13xxx_init);
+
+static void __exit mc13xxx_exit(void)
+{
+	spi_unregister_driver(&mc13xxx_driver);
+}
+module_exit(mc13xxx_exit);
+
+MODULE_DESCRIPTION("Core driver for Freescale MC13XXX PMIC");
+MODULE_AUTHOR("Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/linux/mfd/mc13783.h b/include/linux/mfd/mc13783.h
index 5f6aff5..b4c741e 100644
--- a/include/linux/mfd/mc13783.h
+++ b/include/linux/mfd/mc13783.h
@@ -1,5 +1,5 @@
 /*
- * Copyright 2009 Pengutronix
+ * Copyright 2009-2010 Pengutronix
  * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
  *
  * This program is free software; you can redistribute it and/or modify it under
@@ -9,31 +9,84 @@
 #ifndef __LINUX_MFD_MC13783_H
 #define __LINUX_MFD_MC13783_H
 
-#include <linux/interrupt.h>
+#include <linux/mfd/mc13xxx.h>
 
 struct mc13783;
 
-void mc13783_lock(struct mc13783 *mc13783);
-void mc13783_unlock(struct mc13783 *mc13783);
-
-int mc13783_reg_read(struct mc13783 *mc13783, unsigned int offset, u32 *val);
-int mc13783_reg_write(struct mc13783 *mc13783, unsigned int offset, u32 val);
-int mc13783_reg_rmw(struct mc13783 *mc13783, unsigned int offset,
-		u32 mask, u32 val);
-
-int mc13783_get_flags(struct mc13783 *mc13783);
-
-int mc13783_irq_request(struct mc13783 *mc13783, int irq,
-		irq_handler_t handler, const char *name, void *dev);
-int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
-		irq_handler_t handler, const char *name, void *dev);
-int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev);
-
-int mc13783_irq_mask(struct mc13783 *mc13783, int irq);
-int mc13783_irq_unmask(struct mc13783 *mc13783, int irq);
-int mc13783_irq_status(struct mc13783 *mc13783, int irq,
-		int *enabled, int *pending);
-int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
+struct mc13xxx *mc13783_to_mc13xxx(struct mc13783 *mc13783);
+
+static inline void mc13783_lock(struct mc13783 *mc13783)
+{
+	mc13xxx_lock(mc13783_to_mc13xxx(mc13783));
+}
+
+static inline void mc13783_unlock(struct mc13783 *mc13783)
+{
+	mc13xxx_unlock(mc13783_to_mc13xxx(mc13783));
+}
+
+static inline int mc13783_reg_read(struct mc13783 *mc13783,
+		unsigned int offset, u32 *val)
+{
+	return mc13xxx_reg_read(mc13783_to_mc13xxx(mc13783), offset, val);
+}
+
+static inline int mc13783_reg_write(struct mc13783 *mc13783,
+		unsigned int offset, u32 val)
+{
+	return mc13xxx_reg_write(mc13783_to_mc13xxx(mc13783), offset, val);
+}
+
+static inline int mc13783_reg_rmw(struct mc13783 *mc13783,
+		unsigned int offset, u32 mask, u32 val)
+{
+	return mc13xxx_reg_rmw(mc13783_to_mc13xxx(mc13783), offset, mask, val);
+}
+
+static inline int mc13783_get_flags(struct mc13783 *mc13783)
+{
+	return mc13xxx_get_flags(mc13783_to_mc13xxx(mc13783));
+}
+
+static inline int mc13783_irq_request(struct mc13783 *mc13783, int irq,
+		irq_handler_t handler, const char *name, void *dev)
+{
+	return mc13xxx_irq_request(mc13783_to_mc13xxx(mc13783), irq,
+			handler, name, dev);
+}
+
+static inline int mc13783_irq_request_nounmask(struct mc13783 *mc13783, int irq,
+		irq_handler_t handler, const char *name, void *dev)
+{
+	return mc13xxx_irq_request_nounmask(mc13783_to_mc13xxx(mc13783), irq,
+			handler, name, dev);
+}
+
+static inline int mc13783_irq_free(struct mc13783 *mc13783, int irq, void *dev)
+{
+	return mc13xxx_irq_free(mc13783_to_mc13xxx(mc13783), irq, dev);
+}
+
+static inline int mc13783_irq_mask(struct mc13783 *mc13783, int irq)
+{
+	return mc13xxx_irq_mask(mc13783_to_mc13xxx(mc13783), irq);
+}
+
+static inline int mc13783_irq_unmask(struct mc13783 *mc13783, int irq)
+{
+	return mc13xxx_irq_unmask(mc13783_to_mc13xxx(mc13783), irq);
+}
+static inline int mc13783_irq_status(struct mc13783 *mc13783, int irq,
+		int *enabled, int *pending)
+{
+	return mc13xxx_irq_status(mc13783_to_mc13xxx(mc13783),
+			irq, enabled, pending);
+}
+
+static inline int mc13783_irq_ack(struct mc13783 *mc13783, int irq)
+{
+	return mc13xxx_irq_ack(mc13783_to_mc13xxx(mc13783), irq);
+}
 
 #define MC13783_ADC0		43
 #define MC13783_ADC0_ADREFEN		(1 << 10)
@@ -48,96 +101,18 @@ int mc13783_irq_ack(struct mc13783 *mc13783, int irq);
 					MC13783_ADC0_TSMOD1 | \
 					MC13783_ADC0_TSMOD2)
 
-struct mc13783_led_platform_data {
-#define MC13783_LED_MD		0
-#define MC13783_LED_AD		1
-#define MC13783_LED_KP		2
-#define MC13783_LED_R1		3
-#define MC13783_LED_G1		4
-#define MC13783_LED_B1		5
-#define MC13783_LED_R2		6
-#define MC13783_LED_G2		7
-#define MC13783_LED_B2		8
-#define MC13783_LED_R3		9
-#define MC13783_LED_G3		10
-#define MC13783_LED_B3		11
-#define MC13783_LED_MAX MC13783_LED_B3
-	int id;
-	const char *name;
-	const char *default_trigger;
-
-/* Three or two bits current selection depending on the led */
-	char max_current;
-};
-
-struct mc13783_leds_platform_data {
-	int num_leds;
-	struct mc13783_led_platform_data *led;
-
-#define MC13783_LED_TRIODE_MD	(1 << 0)
-#define MC13783_LED_TRIODE_AD	(1 << 1)
-#define MC13783_LED_TRIODE_KP	(1 << 2)
-#define MC13783_LED_BOOST_EN	(1 << 3)
-#define MC13783_LED_TC1HALF	(1 << 4)
-#define MC13783_LED_SLEWLIMTC	(1 << 5)
-#define MC13783_LED_SLEWLIMBL	(1 << 6)
-#define MC13783_LED_TRIODE_TC1	(1 << 7)
-#define MC13783_LED_TRIODE_TC2	(1 << 8)
-#define MC13783_LED_TRIODE_TC3	(1 << 9)
-	int flags;
-
-#define MC13783_LED_AB_DISABLED		0
-#define MC13783_LED_AB_MD1		1
-#define MC13783_LED_AB_MD12		2
-#define MC13783_LED_AB_MD123		3
-#define MC13783_LED_AB_MD1234		4
-#define MC13783_LED_AB_MD1234_AD1	5
-#define MC13783_LED_AB_MD1234_AD12	6
-#define MC13783_LED_AB_MD1_AD		7
-	char abmode;
-
-#define MC13783_LED_ABREF_200MV	0
-#define MC13783_LED_ABREF_400MV	1
-#define MC13783_LED_ABREF_600MV	2
-#define MC13783_LED_ABREF_800MV	3
-	char abref;
-
-#define MC13783_LED_PERIOD_10MS		0
-#define MC13783_LED_PERIOD_100MS	1
-#define MC13783_LED_PERIOD_500MS	2
-#define MC13783_LED_PERIOD_2S		3
-	char bl_period;
-	char tc1_period;
-	char tc2_period;
-	char tc3_period;
-};
-
-/* to be cleaned up */
-struct regulator_init_data;
-
-struct mc13783_regulator_init_data {
-	int id;
-	struct regulator_init_data *init_data;
-};
-
-struct mc13783_regulator_platform_data {
-	int num_regulators;
-	struct mc13783_regulator_init_data *regulators;
-};
-
-struct mc13783_platform_data {
-	int num_regulators;
-	struct mc13783_regulator_init_data *regulators;
-	struct mc13783_leds_platform_data *leds;
-
-#define MC13783_USE_TOUCHSCREEN (1 << 0)
-#define MC13783_USE_CODEC	(1 << 1)
-#define MC13783_USE_ADC		(1 << 2)
-#define MC13783_USE_RTC		(1 << 3)
-#define MC13783_USE_REGULATOR	(1 << 4)
-#define MC13783_USE_LED		(1 << 5)
-	unsigned int flags;
-};
+#define mc13783_regulator_init_data mc13xxx_regulator_init_data
+#define mc13783_regulator_platform_data mc13xxx_regulator_platform_data
+#define mc13783_led_platform_data mc13xxx_led_platform_data
+#define mc13783_leds_platform_data mc13xxx_leds_platform_data
+
+#define mc13783_platform_data mc13xxx_platform_data
+#define MC13783_USE_TOUCHSCREEN	MC13XXX_USE_TOUCHSCREEN
+#define MC13783_USE_CODEC	MC13XXX_USE_CODEC
+#define MC13783_USE_ADC		MC13XXX_USE_ADC
+#define MC13783_USE_RTC		MC13XXX_USE_RTC
+#define MC13783_USE_REGULATOR	MC13XXX_USE_REGULATOR
+#define MC13783_USE_LED		MC13XXX_USE_LED
 
 #define MC13783_ADC_MODE_TS		1
 #define MC13783_ADC_MODE_SINGLE_CHAN	2
@@ -181,46 +156,46 @@ int mc13783_adc_do_conversion(struct mc13783 *mc13783, unsigned int mode,
 #define	MC13783_REGU_PWGT1SPI	31
 #define	MC13783_REGU_PWGT2SPI	32
 
-#define MC13783_IRQ_ADCDONE	0
-#define MC13783_IRQ_ADCBISDONE	1
-#define MC13783_IRQ_TS		2
+#define MC13783_IRQ_ADCDONE	MC13XXX_IRQ_ADCDONE
+#define MC13783_IRQ_ADCBISDONE	MC13XXX_IRQ_ADCBISDONE
+#define MC13783_IRQ_TS		MC13XXX_IRQ_TS
 #define MC13783_IRQ_WHIGH	3
 #define MC13783_IRQ_WLOW	4
-#define MC13783_IRQ_CHGDET	6
+#define MC13783_IRQ_CHGDET	MC13XXX_IRQ_CHGDET
 #define MC13783_IRQ_CHGOV	7
-#define MC13783_IRQ_CHGREV	8
-#define MC13783_IRQ_CHGSHORT	9
-#define MC13783_IRQ_CCCV	10
-#define MC13783_IRQ_CHGCURR	11
-#define MC13783_IRQ_BPON	12
-#define MC13783_IRQ_LOBATL	13
-#define MC13783_IRQ_LOBATH	14
+#define MC13783_IRQ_CHGREV	MC13XXX_IRQ_CHGREV
+#define MC13783_IRQ_CHGSHORT	MC13XXX_IRQ_CHGSHORT
+#define MC13783_IRQ_CCCV	MC13XXX_IRQ_CCCV
+#define MC13783_IRQ_CHGCURR	MC13XXX_IRQ_CHGCURR
+#define MC13783_IRQ_BPON	MC13XXX_IRQ_BPON
+#define MC13783_IRQ_LOBATL	MC13XXX_IRQ_LOBATL
+#define MC13783_IRQ_LOBATH	MC13XXX_IRQ_LOBATH
 #define MC13783_IRQ_UDP		15
 #define MC13783_IRQ_USB		16
 #define MC13783_IRQ_ID		19
 #define MC13783_IRQ_SE1		21
 #define MC13783_IRQ_CKDET	22
 #define MC13783_IRQ_UDM		23
-#define MC13783_IRQ_1HZ		24
-#define MC13783_IRQ_TODA	25
+#define MC13783_IRQ_1HZ		MC13XXX_IRQ_1HZ
+#define MC13783_IRQ_TODA	MC13XXX_IRQ_TODA
 #define MC13783_IRQ_ONOFD1	27
 #define MC13783_IRQ_ONOFD2	28
 #define MC13783_IRQ_ONOFD3	29
-#define MC13783_IRQ_SYSRST	30
-#define MC13783_IRQ_RTCRST	31
-#define MC13783_IRQ_PC		32
-#define MC13783_IRQ_WARM	33
-#define MC13783_IRQ_MEMHLD	34
+#define MC13783_IRQ_SYSRST	MC13XXX_IRQ_SYSRST
+#define MC13783_IRQ_RTCRST	MC13XXX_IRQ_RTCRST
+#define MC13783_IRQ_PC		MC13XXX_IRQ_PC
+#define MC13783_IRQ_WARM	MC13XXX_IRQ_WARM
+#define MC13783_IRQ_MEMHLD	MC13XXX_IRQ_MEMHLD
 #define MC13783_IRQ_PWRRDY	35
-#define MC13783_IRQ_THWARNL	36
-#define MC13783_IRQ_THWARNH	37
-#define MC13783_IRQ_CLK		38
+#define MC13783_IRQ_THWARNL	MC13XXX_IRQ_THWARNL
+#define MC13783_IRQ_THWARNH	MC13XXX_IRQ_THWARNH
+#define MC13783_IRQ_CLK		MC13XXX_IRQ_CLK
 #define MC13783_IRQ_SEMAF	39
 #define MC13783_IRQ_MC2B	41
 #define MC13783_IRQ_HSDET	42
 #define MC13783_IRQ_HSL		43
 #define MC13783_IRQ_ALSPTH	44
 #define MC13783_IRQ_AHSSHORT	45
-#define MC13783_NUM_IRQ		46
+#define MC13783_NUM_IRQ		MC13XXX_NUM_IRQ
 
-#endif /* __LINUX_MFD_MC13783_H */
+#endif /* ifndef __LINUX_MFD_MC13783_H */
diff --git a/include/linux/mfd/mc13xxx.h b/include/linux/mfd/mc13xxx.h
new file mode 100644
index 0000000..a1d391b
--- /dev/null
+++ b/include/linux/mfd/mc13xxx.h
@@ -0,0 +1,154 @@
+/*
+ * Copyright 2009-2010 Pengutronix
+ * Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it under
+ * the terms of the GNU General Public License version 2 as published by the
+ * Free Software Foundation.
+ */
+#ifndef __LINUX_MFD_MC13XXX_H
+#define __LINUX_MFD_MC13XXX_H
+
+#include <linux/interrupt.h>
+
+struct mc13xxx;
+
+void mc13xxx_lock(struct mc13xxx *mc13xxx);
+void mc13xxx_unlock(struct mc13xxx *mc13xxx);
+
+int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val);
+int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val);
+int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
+		u32 mask, u32 val);
+
+int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
+
+int mc13xxx_irq_request(struct mc13xxx *mc13xxx, int irq,
+		irq_handler_t handler, const char *name, void *dev);
+int mc13xxx_irq_request_nounmask(struct mc13xxx *mc13xxx, int irq,
+		irq_handler_t handler, const char *name, void *dev);
+int mc13xxx_irq_free(struct mc13xxx *mc13xxx, int irq, void *dev);
+
+int mc13xxx_irq_mask(struct mc13xxx *mc13xxx, int irq);
+int mc13xxx_irq_unmask(struct mc13xxx *mc13xxx, int irq);
+int mc13xxx_irq_status(struct mc13xxx *mc13xxx, int irq,
+		int *enabled, int *pending);
+int mc13xxx_irq_ack(struct mc13xxx *mc13xxx, int irq);
+
+int mc13xxx_get_flags(struct mc13xxx *mc13xxx);
+
+#define MC13XXX_IRQ_ADCDONE	0
+#define MC13XXX_IRQ_ADCBISDONE	1
+#define MC13XXX_IRQ_TS		2
+#define MC13XXX_IRQ_CHGDET	6
+#define MC13XXX_IRQ_CHGREV	8
+#define MC13XXX_IRQ_CHGSHORT	9
+#define MC13XXX_IRQ_CCCV	10
+#define MC13XXX_IRQ_CHGCURR	11
+#define MC13XXX_IRQ_BPON	12
+#define MC13XXX_IRQ_LOBATL	13
+#define MC13XXX_IRQ_LOBATH	14
+#define MC13XXX_IRQ_1HZ		24
+#define MC13XXX_IRQ_TODA	25
+#define MC13XXX_IRQ_SYSRST	30
+#define MC13XXX_IRQ_RTCRST	31
+#define MC13XXX_IRQ_PC		32
+#define MC13XXX_IRQ_WARM	33
+#define MC13XXX_IRQ_MEMHLD	34
+#define MC13XXX_IRQ_THWARNL	36
+#define MC13XXX_IRQ_THWARNH	37
+#define MC13XXX_IRQ_CLK		38
+
+#define MC13XXX_NUM_IRQ		46
+
+struct regulator_init_data;
+
+struct mc13xxx_regulator_init_data {
+	int id;
+	struct regulator_init_data *init_data;
+};
+
+struct mc13xxx_regulator_platform_data {
+	int num_regulators;
+	struct mc13xxx_regulator_init_data *regulators;
+};
+
+struct mc13xxx_led_platform_data {
+#define MC13783_LED_MD		0
+#define MC13783_LED_AD		1
+#define MC13783_LED_KP		2
+#define MC13783_LED_R1		3
+#define MC13783_LED_G1		4
+#define MC13783_LED_B1		5
+#define MC13783_LED_R2		6
+#define MC13783_LED_G2		7
+#define MC13783_LED_B2		8
+#define MC13783_LED_R3		9
+#define MC13783_LED_G3		10
+#define MC13783_LED_B3		11
+#define MC13783_LED_MAX MC13783_LED_B3
+	int id;
+	const char *name;
+	const char *default_trigger;
+
+/* Three or two bits current selection depending on the led */
+	char max_current;
+};
+
+struct mc13xxx_leds_platform_data {
+	int num_leds;
+	struct mc13xxx_led_platform_data *led;
+
+#define MC13783_LED_TRIODE_MD	(1 << 0)
+#define MC13783_LED_TRIODE_AD	(1 << 1)
+#define MC13783_LED_TRIODE_KP	(1 << 2)
+#define MC13783_LED_BOOST_EN	(1 << 3)
+#define MC13783_LED_TC1HALF	(1 << 4)
+#define MC13783_LED_SLEWLIMTC	(1 << 5)
+#define MC13783_LED_SLEWLIMBL	(1 << 6)
+#define MC13783_LED_TRIODE_TC1	(1 << 7)
+#define MC13783_LED_TRIODE_TC2	(1 << 8)
+#define MC13783_LED_TRIODE_TC3	(1 << 9)
+	int flags;
+
+#define MC13783_LED_AB_DISABLED		0
+#define MC13783_LED_AB_MD1		1
+#define MC13783_LED_AB_MD12		2
+#define MC13783_LED_AB_MD123		3
+#define MC13783_LED_AB_MD1234		4
+#define MC13783_LED_AB_MD1234_AD1	5
+#define MC13783_LED_AB_MD1234_AD12	6
+#define MC13783_LED_AB_MD1_AD		7
+	char abmode;
+
+#define MC13783_LED_ABREF_200MV	0
+#define MC13783_LED_ABREF_400MV	1
+#define MC13783_LED_ABREF_600MV	2
+#define MC13783_LED_ABREF_800MV	3
+	char abref;
+
+#define MC13783_LED_PERIOD_10MS		0
+#define MC13783_LED_PERIOD_100MS	1
+#define MC13783_LED_PERIOD_500MS	2
+#define MC13783_LED_PERIOD_2S		3
+	char bl_period;
+	char tc1_period;
+	char tc2_period;
+	char tc3_period;
+};
+
+struct mc13xxx_platform_data {
+#define MC13XXX_USE_TOUCHSCREEN (1 << 0)
+#define MC13XXX_USE_CODEC	(1 << 1)
+#define MC13XXX_USE_ADC		(1 << 2)
+#define MC13XXX_USE_RTC		(1 << 3)
+#define MC13XXX_USE_REGULATOR	(1 << 4)
+#define MC13XXX_USE_LED		(1 << 5)
+	unsigned int flags;
+
+	int num_regulators;
+	struct mc13xxx_regulator_init_data *regulators;
+	struct mc13xxx_leds_platform_data *leds;
+};
+
+#endif /* ifndef __LINUX_MFD_MC13XXX_H */
-- 
1.7.2.3

