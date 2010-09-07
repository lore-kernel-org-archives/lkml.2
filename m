Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab0IGUYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 16:24:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14249 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829Ab0IGUYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 16:24:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 07 Sep 2010 13:24:00 -0700
From: Gary King <gking@nvidia.com>
To: sameo@linux.intel.com
Cc: mike@compulab.co.il, linux-kernel@vger.kernel.org
Subject: [PATCH v2] mfd: tps6586x: add basic interrupt support
Date: Tue,  7 Sep 2010 13:15:48 -0700
Message-Id: <1283890548-29442-1-git-send-email-gking@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel, Mike,

This patch incorporates Mike Rapoport's feedback on my initial patch
to add interrupt support to the tps6586x driver.

Changes since v1:

* Move the interrupt enum ordering to match the ACK register values

* Treat the INT_ACK registers as a single 32b unsigned int.

* Name and define all the interrupts on the device

* If reading the ACK registers in the interrupt thread fails, IRQ_NONE
  is returned, rather than disabling the IRQ handler. This fixes
  interrupts following suspend.

* The cascaded IRQ is passed through the i2c_client's .irq field, rather
  than through platform data.

--
>From bf2f95da6f192e091d9ac0b30c186050aa5fd4e5 Mon Sep 17 00:00:00 2001
From: Gary King <gking@nvidia.com>
Date: Mon, 30 Aug 2010 16:16:55 -0700
Subject: mfd: tps6586x: add basic interrupt support

add support for enabling and disabling tps6586x subdevice interrupts,
and add support for the RTC interrupts

Signed-off-by: Gary King <gking@nvidia.com>
---
 drivers/mfd/tps6586x.c       |  202 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6586x.h |   31 +++++++
 2 files changed, 233 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4cde31e..626081c 100644
--- a/drivers/mfd/tps6586x.c
+++ b/drivers/mfd/tps6586x.c
@@ -15,6 +15,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/interrupt.h>
+#include <linux/irq.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
@@ -29,16 +31,76 @@
 #define TPS6586X_GPIOSET1	0x5d
 #define TPS6586X_GPIOSET2	0x5e
 
+/* interrupt control registers */
+#define TPS6586X_INT_ACK1	0xb5
+#define TPS6586X_INT_ACK2	0xb6
+#define TPS6586X_INT_ACK3	0xb7
+#define TPS6586X_INT_ACK4	0xb8
+
+/* interrupt mask registers */
+#define TPS6586X_INT_MASK1	0xb0
+#define TPS6586X_INT_MASK2	0xb1
+#define TPS6586X_INT_MASK3	0xb2
+#define TPS6586X_INT_MASK4	0xb3
+#define TPS6586X_INT_MASK5	0xb4
+
 /* device id */
 #define TPS6586X_VERSIONCRC	0xcd
 #define TPS658621A_VERSIONCRC	0x15
 
+struct tps6586x_irq_data {
+	u8	mask_reg;
+	u8	mask_mask;
+};
+
+#define TPS6586X_IRQ(_reg, _mask)				\
+	{							\
+		.mask_reg = (_reg) - TPS6586X_INT_MASK1,	\
+		.mask_mask = (_mask),				\
+	}
+
+static const struct tps6586x_irq_data tps6586x_irqs[] = {
+	[TPS6586X_INT_PLDO_0]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 0),
+	[TPS6586X_INT_PLDO_1]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 1),
+	[TPS6586X_INT_PLDO_2]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 2),
+	[TPS6586X_INT_PLDO_3]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 3),
+	[TPS6586X_INT_PLDO_4]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 4),
+	[TPS6586X_INT_PLDO_5]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 5),
+	[TPS6586X_INT_PLDO_6]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 6),
+	[TPS6586X_INT_PLDO_7]	= TPS6586X_IRQ(TPS6586X_INT_MASK1, 1 << 7),
+	[TPS6586X_INT_COMP_DET]	= TPS6586X_IRQ(TPS6586X_INT_MASK4, 1 << 0),
+	[TPS6586X_INT_ADC]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 1),
+	[TPS6586X_INT_PLDO_8]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 2),
+	[TPS6586X_INT_PLDO_9]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 3),
+	[TPS6586X_INT_PSM_0]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 4),
+	[TPS6586X_INT_PSM_1]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 5),
+	[TPS6586X_INT_PSM_2]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 6),
+	[TPS6586X_INT_PSM_3]	= TPS6586X_IRQ(TPS6586X_INT_MASK2, 1 << 7),
+	[TPS6586X_INT_RTC_ALM1]	= TPS6586X_IRQ(TPS6586X_INT_MASK5, 1 << 4),
+	[TPS6586X_INT_ACUSB_OVP] = TPS6586X_IRQ(TPS6586X_INT_MASK5, 0x03),
+	[TPS6586X_INT_USB_DET]	= TPS6586X_IRQ(TPS6586X_INT_MASK5, 1 << 2),
+	[TPS6586X_INT_AC_DET]	= TPS6586X_IRQ(TPS6586X_INT_MASK5, 1 << 3),
+	[TPS6586X_INT_BAT_DET]	= TPS6586X_IRQ(TPS6586X_INT_MASK3, 1 << 0),
+	[TPS6586X_INT_CHG_STAT]	= TPS6586X_IRQ(TPS6586X_INT_MASK4, 0xfc),
+	[TPS6586X_INT_CHG_TEMP]	= TPS6586X_IRQ(TPS6586X_INT_MASK3, 0x06),
+	[TPS6586X_INT_PP]	= TPS6586X_IRQ(TPS6586X_INT_MASK3, 0xf0),
+	[TPS6586X_INT_RESUME]	= TPS6586X_IRQ(TPS6586X_INT_MASK5, 1 << 5),
+	[TPS6586X_INT_LOW_SYS]	= TPS6586X_IRQ(TPS6586X_INT_MASK5, 1 << 6),
+	[TPS6586X_INT_RTC_ALM2] = TPS6586X_IRQ(TPS6586X_INT_MASK4, 1 << 1),
+};
+
 struct tps6586x {
 	struct mutex		lock;
 	struct device		*dev;
 	struct i2c_client	*client;
 
 	struct gpio_chip	gpio;
+	struct irq_chip		irq_chip;
+	struct mutex		irq_lock;
+	int			irq_base;
+	u32			irq_en;
+	u8			mask_cache[5];
+	u8			mask_reg[5];
 };
 
 static inline int __tps6586x_read(struct i2c_client *client,
@@ -262,6 +324,129 @@ static int tps6586x_remove_subdevs(struct tps6586x *tps6586x)
 	return device_for_each_child(tps6586x->dev, NULL, __remove_subdev);
 }
 
+static void tps6586x_irq_lock(unsigned int irq)
+{
+	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+
+	mutex_lock(&tps6586x->irq_lock);
+}
+
+static void tps6586x_irq_enable(unsigned int irq)
+{
+	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+	unsigned int __irq = irq - tps6586x->irq_base;
+	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
+
+	tps6586x->mask_reg[data->mask_reg] &= ~data->mask_mask;
+	tps6586x->irq_en |= (1 << __irq);
+}
+
+static void tps6586x_irq_disable(unsigned int irq)
+{
+	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+
+	unsigned int __irq = irq - tps6586x->irq_base;
+	const struct tps6586x_irq_data *data = &tps6586x_irqs[__irq];
+
+	tps6586x->mask_reg[data->mask_reg] |= data->mask_mask;
+	tps6586x->irq_en &= ~(1 << __irq);
+}
+
+static void tps6586x_irq_sync_unlock(unsigned int irq)
+{
+	struct tps6586x *tps6586x = get_irq_chip_data(irq);
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(tps6586x->mask_reg); i++) {
+		if (tps6586x->mask_reg[i] != tps6586x->mask_cache[i]) {
+			if (!WARN_ON(tps6586x_write(tps6586x->dev,
+						    TPS6586X_INT_MASK1 + i,
+						    tps6586x->mask_reg[i])))
+				tps6586x->mask_cache[i] = tps6586x->mask_reg[i];
+		}
+	}
+
+	mutex_unlock(&tps6586x->irq_lock);
+}
+
+static irqreturn_t tps6586x_irq(int irq, void *data)
+{
+	struct tps6586x *tps6586x = data;
+	u32 acks;
+	int ret = 0;
+
+	ret = tps6586x_reads(tps6586x->dev, TPS6586X_INT_ACK1,
+			     sizeof(acks), (uint8_t *)&acks);
+
+	if (ret < 0) {
+		dev_err(tps6586x->dev, "failed to read interrupt status\n");
+		return IRQ_NONE;
+	}
+
+	acks = le32_to_cpu(acks);
+
+	while (acks) {
+		int i = __ffs(acks);
+
+		if (tps6586x->irq_en & (1 << i))
+			handle_nested_irq(tps6586x->irq_base + i);
+
+		acks &= ~(1 << i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
+				       int irq_base)
+{
+	int i, ret;
+	u8 tmp[4];
+
+	if (!irq_base) {
+		dev_warn(tps6586x->dev, "No interrupt support on IRQ base\n");
+		return -EINVAL;
+	}
+
+	mutex_init(&tps6586x->irq_lock);
+	for (i = 0; i < 5; i++) {
+		tps6586x->mask_cache[i] = 0xff;
+		tps6586x->mask_reg[i] = 0xff;
+		tps6586x_write(tps6586x->dev, TPS6586X_INT_MASK1 + i, 0xff);
+	}
+
+	tps6586x_reads(tps6586x->dev, TPS6586X_INT_ACK1, sizeof(tmp), tmp);
+
+	tps6586x->irq_base = irq_base;
+
+	tps6586x->irq_chip.name = "tps6586x";
+	tps6586x->irq_chip.enable = tps6586x_irq_enable;
+	tps6586x->irq_chip.disable = tps6586x_irq_disable;
+	tps6586x->irq_chip.bus_lock = tps6586x_irq_lock;
+	tps6586x->irq_chip.bus_sync_unlock = tps6586x_irq_sync_unlock;
+
+	for (i = 0; i < ARRAY_SIZE(tps6586x_irqs); i++) {
+		int __irq = i + tps6586x->irq_base;
+		set_irq_chip_data(__irq, tps6586x);
+		set_irq_chip_and_handler(__irq, &tps6586x->irq_chip,
+					 handle_simple_irq);
+		set_irq_nested_thread(__irq, 1);
+#ifdef CONFIG_ARM
+		set_irq_flags(__irq, IRQF_VALID);
+#endif
+	}
+
+	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
+				   "tps6586x", tps6586x);
+
+	if (!ret) {
+		device_init_wakeup(tps6586x->dev, 1);
+		enable_irq_wake(irq);
+	}
+
+	return ret;
+}
+
 static int __devinit tps6586x_add_subdevs(struct tps6586x *tps6586x,
 					  struct tps6586x_platform_data *pdata)
 {
@@ -321,6 +506,15 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 
 	mutex_init(&tps6586x->lock);
 
+	if (client->irq) {
+		ret = tps6586x_irq_init(tps6586x, client->irq,
+					pdata->irq_base);
+		if (ret) {
+			dev_err(&client->dev, "IRQ init failed: %d\n", ret);
+			goto err_irq_init;
+		}
+	}
+
 	ret = tps6586x_add_subdevs(tps6586x, pdata);
 	if (ret) {
 		dev_err(&client->dev, "add devices failed: %d\n", ret);
@@ -332,12 +526,20 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 	return 0;
 
 err_add_devs:
+	if (client->irq)
+		free_irq(client->irq, tps6586x);
+err_irq_init:
 	kfree(tps6586x);
 	return ret;
 }
 
 static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 {
+	struct tps6586x *tps6586x = i2c_get_clientdata(client);
+
+	if (client->irq)
+		free_irq(client->irq, tps6586x);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index 772b3ae..b6bab1b 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -18,6 +18,36 @@ enum {
 	TPS6586X_ID_LDO_RTC,
 };
 
+enum {
+	TPS6586X_INT_PLDO_0,
+	TPS6586X_INT_PLDO_1,
+	TPS6586X_INT_PLDO_2,
+	TPS6586X_INT_PLDO_3,
+	TPS6586X_INT_PLDO_4,
+	TPS6586X_INT_PLDO_5,
+	TPS6586X_INT_PLDO_6,
+	TPS6586X_INT_PLDO_7,
+	TPS6586X_INT_COMP_DET,
+	TPS6586X_INT_ADC,
+	TPS6586X_INT_PLDO_8,
+	TPS6586X_INT_PLDO_9,
+	TPS6586X_INT_PSM_0,
+	TPS6586X_INT_PSM_1,
+	TPS6586X_INT_PSM_2,
+	TPS6586X_INT_PSM_3,
+	TPS6586X_INT_RTC_ALM1,
+	TPS6586X_INT_ACUSB_OVP,
+	TPS6586X_INT_USB_DET,
+	TPS6586X_INT_AC_DET,
+	TPS6586X_INT_BAT_DET,
+	TPS6586X_INT_CHG_STAT,
+	TPS6586X_INT_CHG_TEMP,
+	TPS6586X_INT_PP,
+	TPS6586X_INT_RESUME,
+	TPS6586X_INT_LOW_SYS,
+	TPS6586X_INT_RTC_ALM2,
+};
+
 struct tps6586x_subdev_info {
 	int		id;
 	const char	*name;
@@ -29,6 +59,7 @@ struct tps6586x_platform_data {
 	struct tps6586x_subdev_info *subdevs;
 
 	int gpio_base;
+	int irq_base;
 };
 
 /*
-- 
1.7.0.4

