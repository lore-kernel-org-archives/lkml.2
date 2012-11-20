Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab2KTDPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 22:15:48 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2156 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab2KTDPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 22:15:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 19 Nov 2012 19:15:21 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <linux-kernel@vger.kernel.org>, <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH RESEND 5/5] mfd: tps65090: use regmap irq framework for interrupt support
Date: Tue, 20 Nov 2012 08:44:49 +0530
Message-ID: <1353381289-11643-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
References: <1353381289-11643-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the regmap irq framework for implementing TPS65090 interrupt
support in place of implementing it locally.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65090.c       |  263 ++++++++++++++++--------------------------
 include/linux/mfd/tps65090.h |   23 +++-
 2 files changed, 118 insertions(+), 168 deletions(-)

diff --git a/drivers/mfd/tps65090.c b/drivers/mfd/tps65090.c
index 355a077..2eaae52 100644
--- a/drivers/mfd/tps65090.c
+++ b/drivers/mfd/tps65090.c
@@ -38,35 +38,21 @@
 #define TPS65090_INT_MSK	0x2
 #define TPS65090_INT_MSK2	0x3
 
-struct tps65090_irq_data {
-	u8		mask_reg;
-	u8		mask_pos;
-};
-
-#define TPS65090_IRQ(_reg, _mask_pos)		\
-	{					\
-		.mask_reg	= (_reg),	\
-		.mask_pos	= (_mask_pos),	\
-	}
-
-static const struct tps65090_irq_data tps65090_irqs[] = {
-	[0]		= TPS65090_IRQ(0, 0),
-	[1]		= TPS65090_IRQ(0, 1),
-	[2]		= TPS65090_IRQ(0, 2),
-	[3]		= TPS65090_IRQ(0, 3),
-	[4]		= TPS65090_IRQ(0, 4),
-	[5]		= TPS65090_IRQ(0, 5),
-	[6]		= TPS65090_IRQ(0, 6),
-	[7]		= TPS65090_IRQ(0, 7),
-	[8]		= TPS65090_IRQ(1, 0),
-	[9]		= TPS65090_IRQ(1, 1),
-	[10]		= TPS65090_IRQ(1, 2),
-	[11]		= TPS65090_IRQ(1, 3),
-	[12]		= TPS65090_IRQ(1, 4),
-	[13]		= TPS65090_IRQ(1, 5),
-	[14]		= TPS65090_IRQ(1, 6),
-	[15]		= TPS65090_IRQ(1, 7),
-};
+#define TPS65090_INT1_MASK_VAC_STATUS_CHANGE		1
+#define TPS65090_INT1_MASK_VSYS_STATUS_CHANGE		2
+#define TPS65090_INT1_MASK_BAT_STATUS_CHANGE		3
+#define TPS65090_INT1_MASK_CHARGING_STATUS_CHANGE	4
+#define TPS65090_INT1_MASK_CHARGING_COMPLETE		5
+#define TPS65090_INT1_MASK_OVERLOAD_DCDC1		6
+#define TPS65090_INT1_MASK_OVERLOAD_DCDC2		7
+#define TPS65090_INT2_MASK_OVERLOAD_DCDC3		0
+#define TPS65090_INT2_MASK_OVERLOAD_FET1		1
+#define TPS65090_INT2_MASK_OVERLOAD_FET2		2
+#define TPS65090_INT2_MASK_OVERLOAD_FET3		3
+#define TPS65090_INT2_MASK_OVERLOAD_FET4		4
+#define TPS65090_INT2_MASK_OVERLOAD_FET5		5
+#define TPS65090_INT2_MASK_OVERLOAD_FET6		6
+#define TPS65090_INT2_MASK_OVERLOAD_FET7		7
 
 static struct mfd_cell tps65090s[] = {
 	{
@@ -77,132 +63,77 @@ static struct mfd_cell tps65090s[] = {
 	},
 };
 
-static void tps65090_irq_lock(struct irq_data *data)
-{
-	struct tps65090 *tps65090 = irq_data_get_irq_chip_data(data);
-
-	mutex_lock(&tps65090->irq_lock);
-}
-
-static void tps65090_irq_mask(struct irq_data *irq_data)
-{
-	struct tps65090 *tps65090 = irq_data_get_irq_chip_data(irq_data);
-	unsigned int __irq = irq_data->hwirq;
-	const struct tps65090_irq_data *data = &tps65090_irqs[__irq];
-
-	tps65090_set_bits(tps65090->dev, (TPS65090_INT_MSK + data->mask_reg),
-		data->mask_pos);
-}
-
-static void tps65090_irq_unmask(struct irq_data *irq_data)
-{
-	struct tps65090 *tps65090 = irq_data_get_irq_chip_data(irq_data);
-	unsigned int __irq = irq_data->irq - tps65090->irq_base;
-	const struct tps65090_irq_data *data = &tps65090_irqs[__irq];
-
-	tps65090_clr_bits(tps65090->dev, (TPS65090_INT_MSK + data->mask_reg),
-		data->mask_pos);
-}
-
-static void tps65090_irq_sync_unlock(struct irq_data *data)
-{
-	struct tps65090 *tps65090 = irq_data_get_irq_chip_data(data);
-
-	mutex_unlock(&tps65090->irq_lock);
-}
-
-static irqreturn_t tps65090_irq(int irq, void *data)
-{
-	struct tps65090 *tps65090 = data;
-	int ret = 0;
-	u8 status, mask;
-	unsigned long int acks = 0;
-	int i;
-
-	for (i = 0; i < NUM_INT_REG; i++) {
-		ret = tps65090_read(tps65090->dev, TPS65090_INT_MSK + i, &mask);
-		if (ret < 0) {
-			dev_err(tps65090->dev,
-				"failed to read mask reg [addr:%d]\n",
-				TPS65090_INT_MSK + i);
-			return IRQ_NONE;
-		}
-		ret = tps65090_read(tps65090->dev, TPS65090_INT_STS + i,
-			&status);
-		if (ret < 0) {
-			dev_err(tps65090->dev,
-				"failed to read status reg [addr:%d]\n",
-				 TPS65090_INT_STS + i);
-			return IRQ_NONE;
-		}
-		if (status) {
-			/* Ack only those interrupts which are not masked */
-			status &= (~mask);
-			ret = tps65090_write(tps65090->dev,
-					TPS65090_INT_STS + i, status);
-			if (ret < 0) {
-				dev_err(tps65090->dev,
-					"failed to write interrupt status\n");
-				return IRQ_NONE;
-			}
-			acks |= (status << (i * 8));
-		}
-	}
-
-	for_each_set_bit(i, &acks, ARRAY_SIZE(tps65090_irqs))
-		handle_nested_irq(tps65090->irq_base + i);
-	return acks ? IRQ_HANDLED : IRQ_NONE;
-}
-
-static int __devinit tps65090_irq_init(struct tps65090 *tps65090, int irq,
-	int irq_base)
-{
-	int i, ret;
-
-	if (!irq_base) {
-		dev_err(tps65090->dev, "IRQ base not set\n");
-		return -EINVAL;
-	}
-
-	mutex_init(&tps65090->irq_lock);
-
-	for (i = 0; i < NUM_INT_REG; i++)
-		tps65090_write(tps65090->dev, TPS65090_INT_MSK + i, 0xFF);
-
-	for (i = 0; i < NUM_INT_REG; i++)
-		tps65090_write(tps65090->dev, TPS65090_INT_STS + i, 0xff);
-
-	tps65090->irq_base = irq_base;
-	tps65090->irq_chip.name = "tps65090";
-	tps65090->irq_chip.irq_mask = tps65090_irq_mask;
-	tps65090->irq_chip.irq_unmask = tps65090_irq_unmask;
-	tps65090->irq_chip.irq_bus_lock = tps65090_irq_lock;
-	tps65090->irq_chip.irq_bus_sync_unlock = tps65090_irq_sync_unlock;
-
-	for (i = 0; i < ARRAY_SIZE(tps65090_irqs); i++) {
-		int __irq = i + tps65090->irq_base;
-		irq_set_chip_data(__irq, tps65090);
-		irq_set_chip_and_handler(__irq, &tps65090->irq_chip,
-					 handle_simple_irq);
-		irq_set_nested_thread(__irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(__irq, IRQF_VALID);
-#endif
-	}
-
-	ret = request_threaded_irq(irq, NULL, tps65090_irq, IRQF_ONESHOT,
-				"tps65090", tps65090);
-	if (!ret) {
-		device_init_wakeup(tps65090->dev, 1);
-		enable_irq_wake(irq);
-	}
+static const struct regmap_irq tps65090_irqs[] = {
+	/* INT1 IRQs*/
+	[TPS65090_IRQ_VAC_STATUS_CHANGE] = {
+			.mask = TPS65090_INT1_MASK_VAC_STATUS_CHANGE,
+	},
+	[TPS65090_IRQ_VSYS_STATUS_CHANGE] = {
+			.mask = TPS65090_INT1_MASK_VSYS_STATUS_CHANGE,
+	},
+	[TPS65090_IRQ_BAT_STATUS_CHANGE] = {
+			.mask = TPS65090_INT1_MASK_BAT_STATUS_CHANGE,
+	},
+	[TPS65090_IRQ_CHARGING_STATUS_CHANGE] = {
+			.mask = TPS65090_INT1_MASK_CHARGING_STATUS_CHANGE,
+	},
+	[TPS65090_IRQ_CHARGING_COMPLETE] = {
+			.mask = TPS65090_INT1_MASK_CHARGING_COMPLETE,
+	},
+	[TPS65090_IRQ_OVERLOAD_DCDC1] = {
+			.mask = TPS65090_INT1_MASK_OVERLOAD_DCDC1,
+	},
+	[TPS65090_IRQ_OVERLOAD_DCDC2] = {
+			.mask = TPS65090_INT1_MASK_OVERLOAD_DCDC2,
+	},
+	/* INT2 IRQs*/
+	[TPS65090_IRQ_OVERLOAD_DCDC3] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_DCDC3,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET1] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET1,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET2] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET2,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET3] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET3,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET4] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET4,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET5] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET5,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET6] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET6,
+	},
+	[TPS65090_IRQ_OVERLOAD_FET7] = {
+			.reg_offset = 1,
+			.mask = TPS65090_INT2_MASK_OVERLOAD_FET7,
+	},
+};
 
-	return ret;
-}
+static struct regmap_irq_chip tps65090_irq_chip = {
+	.name = "tps65090",
+	.irqs = tps65090_irqs,
+	.num_irqs = ARRAY_SIZE(tps65090_irqs),
+	.num_regs = NUM_INT_REG,
+	.status_base = TPS65090_INT_STS,
+	.mask_base = TPS65090_INT_MSK,
+	.mask_invert = true,
+};
 
 static bool is_volatile_reg(struct device *dev, unsigned int reg)
 {
-	if (reg == TPS65090_INT_STS)
+	if ((reg == TPS65090_INT_STS) || (reg == TPS65090_INT_STS2))
 		return true;
 	else
 		return false;
@@ -238,24 +169,27 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 	tps65090->dev = &client->dev;
 	i2c_set_clientdata(client, tps65090);
 
-	if (client->irq) {
-		ret = tps65090_irq_init(tps65090, client->irq, pdata->irq_base);
-		if (ret) {
-			dev_err(&client->dev, "IRQ init failed with err: %d\n",
-				ret);
-			goto err_exit;
-		}
-	}
-
 	tps65090->rmap = devm_regmap_init_i2c(client, &tps65090_regmap_config);
 	if (IS_ERR(tps65090->rmap)) {
 		ret = PTR_ERR(tps65090->rmap);
 		dev_err(&client->dev, "regmap_init failed with err: %d\n", ret);
-		goto err_irq_exit;
+		return ret;
+	}
+
+	if (client->irq) {
+		ret = regmap_add_irq_chip(tps65090->rmap, client->irq,
+			IRQF_ONESHOT | IRQF_TRIGGER_LOW, pdata->irq_base,
+			&tps65090_irq_chip, &tps65090->irq_data);
+			if (ret) {
+				dev_err(&client->dev,
+					"IRQ init failed with err: %d\n", ret);
+			return ret;
+		}
 	}
 
 	ret = mfd_add_devices(tps65090->dev, -1, tps65090s,
-			      ARRAY_SIZE(tps65090s), NULL, 0, NULL);
+		ARRAY_SIZE(tps65090s), NULL,
+		regmap_irq_chip_get_base(tps65090->irq_data), NULL);
 	if (ret) {
 		dev_err(&client->dev, "add mfd devices failed with err: %d\n",
 			ret);
@@ -266,8 +200,7 @@ static int __devinit tps65090_i2c_probe(struct i2c_client *client,
 
 err_irq_exit:
 	if (client->irq)
-		free_irq(client->irq, tps65090);
-err_exit:
+		regmap_del_irq_chip(client->irq, tps65090->irq_data);
 	return ret;
 }
 
@@ -277,7 +210,7 @@ static int __devexit tps65090_i2c_remove(struct i2c_client *client)
 
 	mfd_remove_devices(tps65090->dev);
 	if (client->irq)
-		free_irq(client->irq, tps65090);
+		regmap_del_irq_chip(client->irq, tps65090->irq_data);
 
 	return 0;
 }
diff --git a/include/linux/mfd/tps65090.h b/include/linux/mfd/tps65090.h
index 1a5f916..4bbbb13 100644
--- a/include/linux/mfd/tps65090.h
+++ b/include/linux/mfd/tps65090.h
@@ -25,12 +25,29 @@
 #include <linux/irq.h>
 #include <linux/regmap.h>
 
+/* TPS65090 IRQs */
+enum {
+	TPS65090_IRQ_VAC_STATUS_CHANGE,
+	TPS65090_IRQ_VSYS_STATUS_CHANGE,
+	TPS65090_IRQ_BAT_STATUS_CHANGE,
+	TPS65090_IRQ_CHARGING_STATUS_CHANGE,
+	TPS65090_IRQ_CHARGING_COMPLETE,
+	TPS65090_IRQ_OVERLOAD_DCDC1,
+	TPS65090_IRQ_OVERLOAD_DCDC2,
+	TPS65090_IRQ_OVERLOAD_DCDC3,
+	TPS65090_IRQ_OVERLOAD_FET1,
+	TPS65090_IRQ_OVERLOAD_FET2,
+	TPS65090_IRQ_OVERLOAD_FET3,
+	TPS65090_IRQ_OVERLOAD_FET4,
+	TPS65090_IRQ_OVERLOAD_FET5,
+	TPS65090_IRQ_OVERLOAD_FET6,
+	TPS65090_IRQ_OVERLOAD_FET7,
+};
+
 struct tps65090 {
 	struct device		*dev;
 	struct regmap		*rmap;
-	struct irq_chip		irq_chip;
-	struct mutex		irq_lock;
-	int			irq_base;
+	struct regmap_irq_chip_data *irq_data;
 };
 
 struct tps65090_platform_data {
-- 
1.7.1.1

