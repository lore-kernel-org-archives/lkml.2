Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2DQHam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:30:42 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:34197 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754454Ab2DQHak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:30:40 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Jonas Aaberg <jonas.aberg@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 3/6] mfd/ab8500: deny suspend if i2c transfer is ongoing
Date: Tue, 17 Apr 2012 09:30:33 +0200
Message-ID: <1334647833-1700-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.9.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

If we are in the middle of an I2C transfer we need to deny suspend
of the AB8500 core. Implement an atomic reference counter for the
I2C operations to make sure we don't do this.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Reviewed-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c         |   38 ++++++++++++++++++++++++++++++-------
 include/linux/mfd/abx500/ab8500.h |    6 +++++-
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index ae67612..eee9560 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -161,9 +161,13 @@ static int set_register_interruptible(struct ab8500 *ab8500, u8 bank,
 static int ab8500_set_register(struct device *dev, u8 bank,
 	u8 reg, u8 value)
 {
+	int ret;
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 
-	return set_register_interruptible(ab8500, bank, reg, value);
+	atomic_inc(&ab8500->transfer_ongoing);
+	ret = set_register_interruptible(ab8500, bank, reg, value);
+	atomic_dec(&ab8500->transfer_ongoing);
+	return ret;
 }
 
 static int get_register_interruptible(struct ab8500 *ab8500, u8 bank,
@@ -192,9 +196,13 @@ static int get_register_interruptible(struct ab8500 *ab8500, u8 bank,
 static int ab8500_get_register(struct device *dev, u8 bank,
 	u8 reg, u8 *value)
 {
+	int ret;
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 
-	return get_register_interruptible(ab8500, bank, reg, value);
+	atomic_inc(&ab8500->transfer_ongoing);
+	ret = get_register_interruptible(ab8500, bank, reg, value);
+	atomic_dec(&ab8500->transfer_ongoing);
+	return ret;
 }
 
 static int mask_and_set_register_interruptible(struct ab8500 *ab8500, u8 bank,
@@ -241,11 +249,14 @@ out:
 static int ab8500_mask_and_set_register(struct device *dev,
 	u8 bank, u8 reg, u8 bitmask, u8 bitvalues)
 {
+	int ret;
 	struct ab8500 *ab8500 = dev_get_drvdata(dev->parent);
 
-	return mask_and_set_register_interruptible(ab8500, bank, reg,
-		bitmask, bitvalues);
-
+	atomic_inc(&ab8500->transfer_ongoing);
+	ret= mask_and_set_register_interruptible(ab8500, bank, reg,
+						 bitmask, bitvalues);
+	atomic_dec(&ab8500->transfer_ongoing);
+	return ret;
 }
 
 static struct abx500_ops ab8500_ops = {
@@ -264,6 +275,7 @@ static void ab8500_irq_lock(struct irq_data *data)
 	struct ab8500 *ab8500 = irq_data_get_irq_chip_data(data);
 
 	mutex_lock(&ab8500->irq_lock);
+	atomic_inc(&ab8500->transfer_ongoing);
 }
 
 static void ab8500_irq_sync_unlock(struct irq_data *data)
@@ -292,7 +304,7 @@ static void ab8500_irq_sync_unlock(struct irq_data *data)
 		reg = AB8500_IT_MASK1_REG + ab8500->irq_reg_offset[i];
 		set_register_interruptible(ab8500, AB8500_INTERRUPT, reg, new);
 	}
-
+	atomic_dec(&ab8500->transfer_ongoing);
 	mutex_unlock(&ab8500->irq_lock);
 }
 
@@ -332,6 +344,8 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 
 	dev_vdbg(ab8500->dev, "interrupt\n");
 
+	atomic_inc(&ab8500->transfer_ongoing);
+
 	for (i = 0; i < ab8500->mask_size; i++) {
 		int regoffset = ab8500->irq_reg_offset[i];
 		int status;
@@ -355,9 +369,10 @@ static irqreturn_t ab8500_irq(int irq, void *dev)
 
 			handle_nested_irq(ab8500->irq_base + line);
 			value &= ~(1 << bit);
+
 		} while (value);
 	}
-
+	atomic_dec(&ab8500->transfer_ongoing);
 	return IRQ_HANDLED;
 }
 
@@ -411,6 +426,14 @@ static void ab8500_irq_remove(struct ab8500 *ab8500)
 	}
 }
 
+int ab8500_suspend(struct ab8500 *ab8500)
+{
+	if (atomic_read(&ab8500->transfer_ongoing))
+		return -EINVAL;
+	else
+		return 0;
+}
+
 /* AB8500 GPIO Resources */
 static struct resource __devinitdata ab8500_gpio_resources[] = {
 	{
@@ -1059,6 +1082,7 @@ int __devinit ab8500_init(struct ab8500 *ab8500, enum ab8500_version version)
 
 	mutex_init(&ab8500->lock);
 	mutex_init(&ab8500->irq_lock);
+	atomic_set(&ab8500->transfer_ongoing, 0);
 
 	if (version != AB8500_VERSION_UNDEFINED)
 		ab8500->version = version;
diff --git a/include/linux/mfd/abx500/ab8500.h b/include/linux/mfd/abx500/ab8500.h
index d798f5b..91dd3ef 100644
--- a/include/linux/mfd/abx500/ab8500.h
+++ b/include/linux/mfd/abx500/ab8500.h
@@ -7,6 +7,7 @@
 #ifndef MFD_AB8500_H
 #define MFD_AB8500_H
 
+#include <linux/atomic.h>
 #include <linux/mutex.h>
 
 struct device;
@@ -224,6 +225,7 @@ enum ab8500_version {
  * @dev: parent device
  * @lock: read/write operations lock
  * @irq_lock: genirq bus lock
+ * @transfer_ongoing: 0 if no transfer ongoing
  * @irq: irq line
  * @version: chip version id (e.g. ab8500 or ab9540)
  * @chip_id: chip revision id
@@ -242,7 +244,7 @@ struct ab8500 {
 	struct device	*dev;
 	struct mutex	lock;
 	struct mutex	irq_lock;
-
+	atomic_t	transfer_ongoing;
 	int		irq_base;
 	int		irq;
 	enum ab8500_version version;
@@ -288,6 +290,8 @@ extern int __devinit ab8500_init(struct ab8500 *ab8500,
 				 enum ab8500_version version);
 extern int __devexit ab8500_exit(struct ab8500 *ab8500);
 
+extern int ab8500_suspend(struct ab8500 *ab8500);
+
 static inline int is_ab8500(struct ab8500 *ab)
 {
 	return ab->version == AB8500_VERSION_AB8500;
-- 
1.7.9.2

