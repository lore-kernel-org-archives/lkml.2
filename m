Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0IAW6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 18:58:00 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14322 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab0IAW57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 18:57:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Wed, 01 Sep 2010 15:57:52 -0700
From: Gary King <gking@nvidia.com>
To: linux-kernel@vger.kernel.org
Cc: mike@compulab.co.il, sameo@linux.intel.com, gking@nvidia.com
Subject: [PATCH] mfd: tps6586x: add basic interrupt support
Date: Wed,  1 Sep 2010 15:50:35 -0700
Message-Id: <1283381435-28664-1-git-send-email-gking@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds interrupt framework support to the tps6586x driver.

--
>From 9820b7412a2f209c3249da16a000ef2555978213 Mon Sep 17 00:00:00 2001
From: Gary King <gking@nvidia.com>
Date: Mon, 30 Aug 2010 16:16:55 -0700
Subject: [PATCH] mfd: tps6586x: add basic interrupt support

add support for enabling and disabling tps6586x subdevice interrupts,
and add support for the RTC interrupts

Signed-off-by: Gary King <gking@nvidia.com>
---
 drivers/mfd/tps6586x.c       |  184 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/tps6586x.h |    7 ++
 2 files changed, 191 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps6586x.c b/drivers/mfd/tps6586x.c
index 4cde31e..b98f41b 100644
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
@@ -29,16 +31,58 @@
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
+	u8	ack_reg;
+	u8	ack_mask;
+	u8	mask_reg;
+	u8	mask_mask;
+};
+
+static const struct tps6586x_irq_data tps6586x_irqs[] = {
+	[TPS6586X_INT_RTC_ALM1] = {
+		.ack_reg	= TPS6586X_INT_ACK3 - TPS6586X_INT_ACK1,
+		.ack_mask	= (1 << 0),
+		.mask_reg	= TPS6586X_INT_MASK5 - TPS6586X_INT_MASK1,
+		.mask_mask	= (1 << 4),
+	},
+	[TPS6586X_INT_RTC_ALM2] = {
+		.ack_reg	= TPS6586X_INT_ACK4 - TPS6586X_INT_ACK1,
+		.ack_mask	= (1 << 2),
+		.mask_reg	= TPS6586X_INT_MASK4 - TPS6586X_INT_MASK1,
+		.mask_mask	= (1 << 1),
+	},
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
+	int			core_irq;
+	bool			irq_en[ARRAY_SIZE(tps6586x_irqs)];
+	u8			mask_cache[5];
+	u8			mask_reg[5];
 };
 
 static inline int __tps6586x_read(struct i2c_client *client,
@@ -262,6 +306,134 @@ static int tps6586x_remove_subdevs(struct tps6586x *tps6586x)
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
+	tps6586x->irq_en[__irq] = true;
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
+	tps6586x->irq_en[__irq] = false;
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
+	u8 acks[4];
+	int ret = 0, i;
+
+	for (i = 0; i < 4 && !ret; i++) {
+		ret = tps6586x_read(tps6586x->dev, TPS6586X_INT_ACK1 + i,
+				    &acks[i]);
+	}
+
+	if (WARN_ON(ret)) {
+		disable_irq_nosync(irq);
+		return IRQ_HANDLED;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(tps6586x_irqs); i++) {
+		u8 ack;
+
+		ack = acks[tps6586x_irqs[i].ack_reg];
+		ack &= tps6586x_irqs[i].ack_mask;
+		if (tps6586x->irq_en[i] && ack)
+			handle_nested_irq(tps6586x->irq_base + i);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static int __devinit tps6586x_irq_init(struct tps6586x *tps6586x, int irq,
+				       int irq_base)
+{
+	int i, ret;
+	u8 tmp;
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
+	tps6586x_read(tps6586x->dev, TPS6586X_INT_ACK1, &tmp);
+	tps6586x_read(tps6586x->dev, TPS6586X_INT_ACK2, &tmp);
+	tps6586x_read(tps6586x->dev, TPS6586X_INT_ACK3, &tmp);
+	tps6586x_read(tps6586x->dev, TPS6586X_INT_ACK4, &tmp);
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
+	tps6586x->core_irq = irq;
+	ret = request_threaded_irq(irq, NULL, tps6586x_irq, IRQF_ONESHOT,
+				   "tps6586x", tps6586x);
+	if (ret) {
+		dev_err(tps6586x->dev, "Failed to request IRQ: %d\n", ret);
+		tps6586x->core_irq = -1;
+	} else {
+		device_init_wakeup(tps6586x->dev, 1);
+		enable_irq_wake(tps6586x->core_irq);
+	}
+
+	return ret;
+}
+
 static int __devinit tps6586x_add_subdevs(struct tps6586x *tps6586x,
 					  struct tps6586x_platform_data *pdata)
 {
@@ -315,12 +487,19 @@ static int __devinit tps6586x_i2c_probe(struct i2c_client *client,
 	if (tps6586x == NULL)
 		return -ENOMEM;
 
+	tps6586x->core_irq = -1;
 	tps6586x->client = client;
 	tps6586x->dev = &client->dev;
 	i2c_set_clientdata(client, tps6586x);
 
 	mutex_init(&tps6586x->lock);
 
+	if (pdata->irq) {
+		ret = tps6586x_irq_init(tps6586x, pdata->irq, pdata->irq_base);
+		if (ret)
+			dev_warn(&client->dev, "IRQ init failed: %d\n", ret);
+	}
+
 	ret = tps6586x_add_subdevs(tps6586x, pdata);
 	if (ret) {
 		dev_err(&client->dev, "add devices failed: %d\n", ret);
@@ -338,6 +517,11 @@ err_add_devs:
 
 static int __devexit tps6586x_i2c_remove(struct i2c_client *client)
 {
+	struct tps6586x *tps6586x = i2c_get_clientdata(client);
+
+	if (tps6586x->core_irq != -1)
+		free_irq(tps6586x->core_irq, tps6586x);
+
 	return 0;
 }
 
diff --git a/include/linux/mfd/tps6586x.h b/include/linux/mfd/tps6586x.h
index 772b3ae..e395219 100644
--- a/include/linux/mfd/tps6586x.h
+++ b/include/linux/mfd/tps6586x.h
@@ -18,6 +18,11 @@ enum {
 	TPS6586X_ID_LDO_RTC,
 };
 
+enum {
+	TPS6586X_INT_RTC_ALM1,
+	TPS6586X_INT_RTC_ALM2,
+};
+
 struct tps6586x_subdev_info {
 	int		id;
 	const char	*name;
@@ -29,6 +34,8 @@ struct tps6586x_platform_data {
 	struct tps6586x_subdev_info *subdevs;
 
 	int gpio_base;
+	int irq_base;
+	int irq;
 };
 
 /*
-- 
1.7.0.4

