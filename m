Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab0ELATt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 20:19:49 -0400
Received: from blue-ld-261.synserver.de ([217.119.54.83]:58049 "EHLO
	smtp-out-072.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752932Ab0ELASy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 20:18:54 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 21078
From: Lars-Peter Clausen <lars@metafoo.de>
To: sameo@linux.intel.com
Cc: fercerpav@gmail.com, linux-kernel@vger.kernel.org,
       Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 4/4] MFD: pcf50633: Move irq related functions to its own file.
Date: Wed, 12 May 2010 02:10:56 +0200
Message-Id: <1273623056-1243-5-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1273623056-1243-4-git-send-email-lars@metafoo.de>
References: <1273623056-1243-1-git-send-email-lars@metafoo.de>
 <1273623056-1243-2-git-send-email-lars@metafoo.de>
 <1273623056-1243-3-git-send-email-lars@metafoo.de>
 <1273623056-1243-4-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces code clutter a bit and will ease an migration to genirq.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/mfd/Makefile        |    3 +-
 drivers/mfd/pcf50633-core.c |  303 ++---------------------------------------
 drivers/mfd/pcf50633-irq.c  |  318 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 330 insertions(+), 294 deletions(-)
 create mode 100644 drivers/mfd/pcf50633-irq.c

diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
index 8593496..ca1517e 100644
--- a/drivers/mfd/Makefile
+++ b/drivers/mfd/Makefile
@@ -57,7 +57,8 @@ obj-$(CONFIG_PMIC_DA903X)	+= da903x.o
 max8925-objs			:= max8925-core.o max8925-i2c.o
 obj-$(CONFIG_MFD_MAX8925)	+= max8925.o
 
-obj-$(CONFIG_MFD_PCF50633)	+= pcf50633-core.o pcf50633-irq.o
+pcf50633-objs			:= pcf50633-core.o pcf50633-irq.o
+obj-$(CONFIG_MFD_PCF50633)	+= pcf50633.o
 obj-$(CONFIG_PCF50633_ADC)	+= pcf50633-adc.o
 obj-$(CONFIG_PCF50633_GPIO)	+= pcf50633-gpio.o
 obj-$(CONFIG_ABX500_CORE)	+= abx500-core.o
diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index fc5cd7f..e1ee046 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -21,16 +21,16 @@
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
 #include <linux/i2c.h>
-#include <linux/irq.h>
 #include <linux/slab.h>
 
 #include <linux/mfd/pcf50633/core.h>
 
-/* Two MBCS registers used during cold start */
-#define PCF50633_REG_MBCS1		0x4b
-#define PCF50633_REG_MBCS2		0x4c
-#define PCF50633_MBCS1_USBPRES 		0x01
-#define PCF50633_MBCS1_ADAPTPRES	0x01
+int pcf50633_irq_init(struct pcf50633 *pcf, int irq);
+void pcf50633_irq_free(struct pcf50633 *pcf);
+#ifdef CONFIG_PM
+int pcf50633_irq_suspend(struct pcf50633 *pcf);
+int pcf50633_irq_resume(struct pcf50633 *pcf);
+#endif
 
 static int __pcf50633_read(struct pcf50633 *pcf, u8 reg, int num, u8 *data)
 {
@@ -215,228 +215,6 @@ static struct attribute_group pcf_attr_group = {
 	.attrs	= pcf_sysfs_entries,
 };
 
-int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
-			void (*handler) (int, void *), void *data)
-{
-	if (irq < 0 || irq >= PCF50633_NUM_IRQ || !handler)
-		return -EINVAL;
-
-	if (WARN_ON(pcf->irq_handler[irq].handler))
-		return -EBUSY;
-
-	mutex_lock(&pcf->lock);
-	pcf->irq_handler[irq].handler = handler;
-	pcf->irq_handler[irq].data = data;
-	mutex_unlock(&pcf->lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(pcf50633_register_irq);
-
-int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
-{
-	if (irq < 0 || irq >= PCF50633_NUM_IRQ)
-		return -EINVAL;
-
-	mutex_lock(&pcf->lock);
-	pcf->irq_handler[irq].handler = NULL;
-	mutex_unlock(&pcf->lock);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(pcf50633_free_irq);
-
-static int __pcf50633_irq_mask_set(struct pcf50633 *pcf, int irq, u8 mask)
-{
-	u8 reg, bits, tmp;
-	int ret = 0, idx;
-
-	idx = irq >> 3;
-	reg =  PCF50633_REG_INT1M + idx;
-	bits = 1 << (irq & 0x07);
-
-	mutex_lock(&pcf->lock);
-
-	if (mask) {
-		ret = __pcf50633_read(pcf, reg, 1, &tmp);
-		if (ret < 0)
-			goto out;
-
-		tmp |= bits;
-
-		ret = __pcf50633_write(pcf, reg, 1, &tmp);
-		if (ret < 0)
-			goto out;
-
-		pcf->mask_regs[idx] &= ~bits;
-		pcf->mask_regs[idx] |= bits;
-	} else {
-		ret = __pcf50633_read(pcf, reg, 1, &tmp);
-		if (ret < 0)
-			goto out;
-
-		tmp &= ~bits;
-
-		ret = __pcf50633_write(pcf, reg, 1, &tmp);
-		if (ret < 0)
-			goto out;
-
-		pcf->mask_regs[idx] &= ~bits;
-	}
-out:
-	mutex_unlock(&pcf->lock);
-
-	return ret;
-}
-
-int pcf50633_irq_mask(struct pcf50633 *pcf, int irq)
-{
-	dev_dbg(pcf->dev, "Masking IRQ %d\n", irq);
-
-	return __pcf50633_irq_mask_set(pcf, irq, 1);
-}
-EXPORT_SYMBOL_GPL(pcf50633_irq_mask);
-
-int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq)
-{
-	dev_dbg(pcf->dev, "Unmasking IRQ %d\n", irq);
-
-	return __pcf50633_irq_mask_set(pcf, irq, 0);
-}
-EXPORT_SYMBOL_GPL(pcf50633_irq_unmask);
-
-int pcf50633_irq_mask_get(struct pcf50633 *pcf, int irq)
-{
-	u8 reg, bits;
-
-	reg =  irq >> 3;
-	bits = 1 << (irq & 0x07);
-
-	return pcf->mask_regs[reg] & bits;
-}
-EXPORT_SYMBOL_GPL(pcf50633_irq_mask_get);
-
-static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
-{
-	if (pcf->irq_handler[irq].handler)
-		pcf->irq_handler[irq].handler(irq, pcf->irq_handler[irq].data);
-}
-
-/* Maximum amount of time ONKEY is held before emergency action is taken */
-#define PCF50633_ONKEY1S_TIMEOUT 8
-
-static irqreturn_t pcf50633_irq(int irq, void *data)
-{
-	struct pcf50633 *pcf = data;
-	int ret, i, j;
-	u8 pcf_int[5], chgstat;
-
-	/* Read the 5 INT regs in one transaction */
-	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
-						ARRAY_SIZE(pcf_int), pcf_int);
-	if (ret != ARRAY_SIZE(pcf_int)) {
-		dev_err(pcf->dev, "Error reading INT registers\n");
-
-		/*
-		 * If this doesn't ACK the interrupt to the chip, we'll be
-		 * called once again as we're level triggered.
-		 */
-		goto out;
-	}
-
-	/* defeat 8s death from lowsys on A5 */
-	pcf50633_reg_write(pcf, PCF50633_REG_OOCSHDWN,  0x04);
-
-	/* We immediately read the usb and adapter status. We thus make sure
-	 * only of USBINS/USBREM IRQ handlers are called */
-	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
-		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
-		if (chgstat & (0x3 << 4))
-			pcf_int[0] &= ~PCF50633_INT1_USBREM;
-		else
-			pcf_int[0] &= ~PCF50633_INT1_USBINS;
-	}
-
-	/* Make sure only one of ADPINS or ADPREM is set */
-	if (pcf_int[0] & (PCF50633_INT1_ADPINS | PCF50633_INT1_ADPREM)) {
-		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
-		if (chgstat & (0x3 << 4))
-			pcf_int[0] &= ~PCF50633_INT1_ADPREM;
-		else
-			pcf_int[0] &= ~PCF50633_INT1_ADPINS;
-	}
-
-	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
-			"INT4=0x%02x INT5=0x%02x\n", pcf_int[0],
-			pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
-
-	/* Some revisions of the chip don't have a 8s standby mode on
-	 * ONKEY1S press. We try to manually do it in such cases. */
-	if ((pcf_int[0] & PCF50633_INT1_SECOND) && pcf->onkey1s_held) {
-		dev_info(pcf->dev, "ONKEY1S held for %d secs\n",
-							pcf->onkey1s_held);
-		if (pcf->onkey1s_held++ == PCF50633_ONKEY1S_TIMEOUT)
-			if (pcf->pdata->force_shutdown)
-				pcf->pdata->force_shutdown(pcf);
-	}
-
-	if (pcf_int[2] & PCF50633_INT3_ONKEY1S) {
-		dev_info(pcf->dev, "ONKEY1S held\n");
-		pcf->onkey1s_held = 1 ;
-
-		/* Unmask IRQ_SECOND */
-		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT1M,
-						PCF50633_INT1_SECOND);
-
-		/* Unmask IRQ_ONKEYR */
-		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT2M,
-						PCF50633_INT2_ONKEYR);
-	}
-
-	if ((pcf_int[1] & PCF50633_INT2_ONKEYR) && pcf->onkey1s_held) {
-		pcf->onkey1s_held = 0;
-
-		/* Mask SECOND and ONKEYR interrupts */
-		if (pcf->mask_regs[0] & PCF50633_INT1_SECOND)
-			pcf50633_reg_set_bit_mask(pcf,
-					PCF50633_REG_INT1M,
-					PCF50633_INT1_SECOND,
-					PCF50633_INT1_SECOND);
-
-		if (pcf->mask_regs[1] & PCF50633_INT2_ONKEYR)
-			pcf50633_reg_set_bit_mask(pcf,
-					PCF50633_REG_INT2M,
-					PCF50633_INT2_ONKEYR,
-					PCF50633_INT2_ONKEYR);
-	}
-
-	/* Have we just resumed ? */
-	if (pcf->is_suspended) {
-		pcf->is_suspended = 0;
-
-		/* Set the resume reason filtering out non resumers */
-		for (i = 0; i < ARRAY_SIZE(pcf_int); i++)
-			pcf->resume_reason[i] = pcf_int[i] &
-						pcf->pdata->resumers[i];
-
-		/* Make sure we don't pass on any ONKEY events to
-		 * userspace now */
-		pcf_int[1] &= ~(PCF50633_INT2_ONKEYR | PCF50633_INT2_ONKEYF);
-	}
-
-	for (i = 0; i < ARRAY_SIZE(pcf_int); i++) {
-		/* Unset masked interrupts */
-		pcf_int[i] &= ~pcf->mask_regs[i];
-
-		for (j = 0; j < 8 ; j++)
-			if (pcf_int[i] & (1 << j))
-				pcf50633_irq_call_handler(pcf, (i * 8) + j);
-	}
-
-out:
-	return IRQ_HANDLED
-}
-
 static void
 pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 						struct platform_device **pdev)
@@ -463,58 +241,17 @@ pcf50633_client_dev_register(struct pcf50633 *pcf, const char *name,
 static int pcf50633_suspend(struct i2c_client *client, pm_message_t state)
 {
 	struct pcf50633 *pcf;
-	int ret = 0, i;
-	u8 res[5];
-
 	pcf = i2c_get_clientdata(client);
 
-	/* Make sure our interrupt handlers are not called
-	 * henceforth */
-	disable_irq(pcf->irq);
-
-	/* Save the masks */
-	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
-				ARRAY_SIZE(pcf->suspend_irq_masks),
-					pcf->suspend_irq_masks);
-	if (ret < 0) {
-		dev_err(pcf->dev, "error saving irq masks\n");
-		goto out;
-	}
-
-	/* Write wakeup irq masks */
-	for (i = 0; i < ARRAY_SIZE(res); i++)
-		res[i] = ~pcf->pdata->resumers[i];
-
-	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
-					ARRAY_SIZE(res), &res[0]);
-	if (ret < 0) {
-		dev_err(pcf->dev, "error writing wakeup irq masks\n");
-		goto out;
-	}
-
-	pcf->is_suspended = 1;
-
-out:
-	return ret;
+	return pcf50633_irq_suspend(pcf);
 }
 
 static int pcf50633_resume(struct i2c_client *client)
 {
 	struct pcf50633 *pcf;
-	int ret;
-
 	pcf = i2c_get_clientdata(client);
 
-	/* Write the saved mask registers */
-	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
-				ARRAY_SIZE(pcf->suspend_irq_masks),
-					pcf->suspend_irq_masks);
-	if (ret < 0)
-		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
-
-	enable_irq(pcf->irq);
-
-	return 0;
+	return pcf50633_irq_resume(pcf);
 }
 #else
 #define pcf50633_suspend NULL
@@ -545,7 +282,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, pcf);
 	pcf->dev = &client->dev;
 	pcf->i2c_client = client;
-	pcf->irq = client->irq;
 
 	version = pcf50633_reg_read(pcf, 0);
 	variant = pcf50633_reg_read(pcf, 1);
@@ -558,22 +294,7 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 	dev_info(pcf->dev, "Probed device version %d variant %d\n",
 							version, variant);
 
-	/* Enable all interrupts except RTC SECOND */
-	pcf->mask_regs[0] = 0x80;
-	pcf50633_reg_write(pcf, PCF50633_REG_INT1M, pcf->mask_regs[0]);
-	pcf50633_reg_write(pcf, PCF50633_REG_INT2M, 0x00);
-	pcf50633_reg_write(pcf, PCF50633_REG_INT3M, 0x00);
-	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
-	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
-
-	ret = request_threaded_irq(client->irq, NULL, pcf50633_irq,
-					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-					"pcf50633", pcf);
-
-	if (ret) {
-		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
-		goto err_free;
-	}
+	pcf50633_irq_init(pcf, client->irq);
 
 	/* Create sub devices */
 	pcf50633_client_dev_register(pcf, "pcf50633-input",
@@ -602,10 +323,6 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		platform_device_add(pdev);
 	}
 
-	if (enable_irq_wake(client->irq) < 0)
-		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
-			"in this hardware revision", client->irq);
-
 	ret = sysfs_create_group(&client->dev.kobj, &pcf_attr_group);
 	if (ret)
 		dev_err(pcf->dev, "error creating sysfs entries\n");
@@ -627,7 +344,7 @@ static int __devexit pcf50633_remove(struct i2c_client *client)
 	struct pcf50633 *pcf = i2c_get_clientdata(client);
 	int i;
 
-	free_irq(pcf->irq, pcf);
+	pcf50633_irq_free(pcf);
 
 	platform_device_unregister(pcf->input_pdev);
 	platform_device_unregister(pcf->rtc_pdev);
diff --git a/drivers/mfd/pcf50633-irq.c b/drivers/mfd/pcf50633-irq.c
new file mode 100644
index 0000000..1b0192f
--- /dev/null
+++ b/drivers/mfd/pcf50633-irq.c
@@ -0,0 +1,318 @@
+/* NXP PCF50633 Power Management Unit (PMU) driver
+ *
+ * (C) 2006-2008 by Openmoko, Inc.
+ * Author: Harald Welte <laforge@openmoko.org>
+ * 	   Balaji Rao <balajirrao@openmoko.org>
+ * All rights reserved.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include <linux/mfd/pcf50633/core.h>
+
+/* Two MBCS registers used during cold start */
+#define PCF50633_REG_MBCS1		0x4b
+#define PCF50633_REG_MBCS2		0x4c
+#define PCF50633_MBCS1_USBPRES 		0x01
+#define PCF50633_MBCS1_ADAPTPRES	0x01
+
+int pcf50633_register_irq(struct pcf50633 *pcf, int irq,
+			void (*handler) (int, void *), void *data)
+{
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ || !handler)
+		return -EINVAL;
+
+	if (WARN_ON(pcf->irq_handler[irq].handler))
+		return -EBUSY;
+
+	mutex_lock(&pcf->lock);
+	pcf->irq_handler[irq].handler = handler;
+	pcf->irq_handler[irq].data = data;
+	mutex_unlock(&pcf->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcf50633_register_irq);
+
+int pcf50633_free_irq(struct pcf50633 *pcf, int irq)
+{
+	if (irq < 0 || irq >= PCF50633_NUM_IRQ)
+		return -EINVAL;
+
+	mutex_lock(&pcf->lock);
+	pcf->irq_handler[irq].handler = NULL;
+	mutex_unlock(&pcf->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pcf50633_free_irq);
+
+static int __pcf50633_irq_mask_set(struct pcf50633 *pcf, int irq, u8 mask)
+{
+	u8 reg, bit;
+	int ret = 0, idx;
+
+	idx = irq >> 3;
+	reg = PCF50633_REG_INT1M + idx;
+	bit = 1 << (irq & 0x07);
+
+	pcf50633_reg_set_bit_mask(pcf, reg, bit, mask ? bit : 0);
+
+	mutex_lock(&pcf->lock);
+
+	if (mask)
+		pcf->mask_regs[idx] |= bit;
+	else
+		pcf->mask_regs[idx] &= ~bit;
+
+	mutex_unlock(&pcf->lock);
+
+	return ret;
+}
+
+int pcf50633_irq_mask(struct pcf50633 *pcf, int irq)
+{
+	dev_dbg(pcf->dev, "Masking IRQ %d\n", irq);
+
+	return __pcf50633_irq_mask_set(pcf, irq, 1);
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_mask);
+
+int pcf50633_irq_unmask(struct pcf50633 *pcf, int irq)
+{
+	dev_dbg(pcf->dev, "Unmasking IRQ %d\n", irq);
+
+	return __pcf50633_irq_mask_set(pcf, irq, 0);
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_unmask);
+
+int pcf50633_irq_mask_get(struct pcf50633 *pcf, int irq)
+{
+	u8 reg, bits;
+
+	reg =  irq >> 3;
+	bits = 1 << (irq & 0x07);
+
+	return pcf->mask_regs[reg] & bits;
+}
+EXPORT_SYMBOL_GPL(pcf50633_irq_mask_get);
+
+static void pcf50633_irq_call_handler(struct pcf50633 *pcf, int irq)
+{
+	if (pcf->irq_handler[irq].handler)
+		pcf->irq_handler[irq].handler(irq, pcf->irq_handler[irq].data);
+}
+
+/* Maximum amount of time ONKEY is held before emergency action is taken */
+#define PCF50633_ONKEY1S_TIMEOUT 8
+
+static irqreturn_t pcf50633_irq(int irq, void *data)
+{
+	struct pcf50633 *pcf = data;
+	int ret, i, j;
+	u8 pcf_int[5], chgstat;
+
+	/* Read the 5 INT regs in one transaction */
+	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1,
+						ARRAY_SIZE(pcf_int), pcf_int);
+	if (ret != ARRAY_SIZE(pcf_int)) {
+		dev_err(pcf->dev, "Error reading INT registers\n");
+
+		/*
+		 * If this doesn't ACK the interrupt to the chip, we'll be
+		 * called once again as we're level triggered.
+		 */
+		goto out;
+	}
+
+	/* defeat 8s death from lowsys on A5 */
+	pcf50633_reg_write(pcf, PCF50633_REG_OOCSHDWN,  0x04);
+
+	/* We immediately read the usb and adapter status. We thus make sure
+	 * only of USBINS/USBREM IRQ handlers are called */
+	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
+		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+		if (chgstat & (0x3 << 4))
+			pcf_int[0] &= ~PCF50633_INT1_USBREM;
+		else
+			pcf_int[0] &= ~PCF50633_INT1_USBINS;
+	}
+
+	/* Make sure only one of ADPINS or ADPREM is set */
+	if (pcf_int[0] & (PCF50633_INT1_ADPINS | PCF50633_INT1_ADPREM)) {
+		chgstat = pcf50633_reg_read(pcf, PCF50633_REG_MBCS2);
+		if (chgstat & (0x3 << 4))
+			pcf_int[0] &= ~PCF50633_INT1_ADPREM;
+		else
+			pcf_int[0] &= ~PCF50633_INT1_ADPINS;
+	}
+
+	dev_dbg(pcf->dev, "INT1=0x%02x INT2=0x%02x INT3=0x%02x "
+			"INT4=0x%02x INT5=0x%02x\n", pcf_int[0],
+			pcf_int[1], pcf_int[2], pcf_int[3], pcf_int[4]);
+
+	/* Some revisions of the chip don't have a 8s standby mode on
+	 * ONKEY1S press. We try to manually do it in such cases. */
+	if ((pcf_int[0] & PCF50633_INT1_SECOND) && pcf->onkey1s_held) {
+		dev_info(pcf->dev, "ONKEY1S held for %d secs\n",
+							pcf->onkey1s_held);
+		if (pcf->onkey1s_held++ == PCF50633_ONKEY1S_TIMEOUT)
+			if (pcf->pdata->force_shutdown)
+				pcf->pdata->force_shutdown(pcf);
+	}
+
+	if (pcf_int[2] & PCF50633_INT3_ONKEY1S) {
+		dev_info(pcf->dev, "ONKEY1S held\n");
+		pcf->onkey1s_held = 1 ;
+
+		/* Unmask IRQ_SECOND */
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT1M,
+						PCF50633_INT1_SECOND);
+
+		/* Unmask IRQ_ONKEYR */
+		pcf50633_reg_clear_bits(pcf, PCF50633_REG_INT2M,
+						PCF50633_INT2_ONKEYR);
+	}
+
+	if ((pcf_int[1] & PCF50633_INT2_ONKEYR) && pcf->onkey1s_held) {
+		pcf->onkey1s_held = 0;
+
+		/* Mask SECOND and ONKEYR interrupts */
+		if (pcf->mask_regs[0] & PCF50633_INT1_SECOND)
+			pcf50633_reg_set_bit_mask(pcf,
+					PCF50633_REG_INT1M,
+					PCF50633_INT1_SECOND,
+					PCF50633_INT1_SECOND);
+
+		if (pcf->mask_regs[1] & PCF50633_INT2_ONKEYR)
+			pcf50633_reg_set_bit_mask(pcf,
+					PCF50633_REG_INT2M,
+					PCF50633_INT2_ONKEYR,
+					PCF50633_INT2_ONKEYR);
+	}
+
+	/* Have we just resumed ? */
+	if (pcf->is_suspended) {
+		pcf->is_suspended = 0;
+
+		/* Set the resume reason filtering out non resumers */
+		for (i = 0; i < ARRAY_SIZE(pcf_int); i++)
+			pcf->resume_reason[i] = pcf_int[i] &
+						pcf->pdata->resumers[i];
+
+		/* Make sure we don't pass on any ONKEY events to
+		 * userspace now */
+		pcf_int[1] &= ~(PCF50633_INT2_ONKEYR | PCF50633_INT2_ONKEYF);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(pcf_int); i++) {
+		/* Unset masked interrupts */
+		pcf_int[i] &= ~pcf->mask_regs[i];
+
+		for (j = 0; j < 8 ; j++)
+			if (pcf_int[i] & (1 << j))
+				pcf50633_irq_call_handler(pcf, (i * 8) + j);
+	}
+
+out:
+	return IRQ_HANDLED;
+}
+
+#ifdef CONFIG_PM
+
+int pcf50633_irq_suspend(struct pcf50633 *pcf)
+{
+	int ret;
+	int i;
+	u8 res[5];
+
+
+	/* Make sure our interrupt handlers are not called
+	 * henceforth */
+	disable_irq(pcf->irq);
+
+	/* Save the masks */
+	ret = pcf50633_read_block(pcf, PCF50633_REG_INT1M,
+				ARRAY_SIZE(pcf->suspend_irq_masks),
+					pcf->suspend_irq_masks);
+	if (ret < 0) {
+		dev_err(pcf->dev, "error saving irq masks\n");
+		goto out;
+	}
+
+	/* Write wakeup irq masks */
+	for (i = 0; i < ARRAY_SIZE(res); i++)
+		res[i] = ~pcf->pdata->resumers[i];
+
+	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
+					ARRAY_SIZE(res), &res[0]);
+	if (ret < 0) {
+		dev_err(pcf->dev, "error writing wakeup irq masks\n");
+		goto out;
+	}
+
+	pcf->is_suspended = 1;
+
+out:
+	return ret;
+}
+
+int pcf50633_irq_resume(struct pcf50633 *pcf)
+{
+	int ret;
+
+	/* Write the saved mask registers */
+	ret = pcf50633_write_block(pcf, PCF50633_REG_INT1M,
+				ARRAY_SIZE(pcf->suspend_irq_masks),
+					pcf->suspend_irq_masks);
+	if (ret < 0)
+		dev_err(pcf->dev, "Error restoring saved suspend masks\n");
+
+	enable_irq(pcf->irq);
+
+	return ret;
+}
+
+#endif
+
+int pcf50633_irq_init(struct pcf50633 *pcf, int irq)
+{
+	int ret;
+
+	pcf->irq = irq;
+
+	/* Enable all interrupts except RTC SECOND */
+	pcf->mask_regs[0] = 0x80;
+	pcf50633_reg_write(pcf, PCF50633_REG_INT1M, pcf->mask_regs[0]);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT2M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT3M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT4M, 0x00);
+	pcf50633_reg_write(pcf, PCF50633_REG_INT5M, 0x00);
+
+	ret = request_threaded_irq(irq, NULL, pcf50633_irq,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"pcf50633", pcf);
+
+	if (ret)
+		dev_err(pcf->dev, "Failed to request IRQ %d\n", ret);
+
+	if (enable_irq_wake(irq) < 0)
+		dev_err(pcf->dev, "IRQ %u cannot be enabled as wake-up source"
+			"in this hardware revision", irq);
+
+	return ret;
+}
+
+void pcf50633_irq_free(struct pcf50633 *pcf)
+{
+	free_irq(pcf->irq, pcf);
+}
-- 
1.5.6.5

