Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1EPXfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:35:36 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:34378 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753053Ab1EPXfb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:35:31 -0400
From: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCHv4 3/6] TPS65911: Add new irq definitions
Date: Mon, 16 May 2011 18:35:07 -0500
Message-Id: <D1ABDABE-9EDE-4D97-956F-D309B102CFB0@slimlogic.co.uk>
Cc: broonie@opensource.wolfsonmicro.com, sameo@linux.intel.com,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca
To: linux-kernel@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1084)
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TPS65911 adds new interrupt sources, as well as two new registers
to handle them, one for interrupt status and one for interrupt
masking. The added irqs are:

-VMBCH2 - Low and High threshold
-GPIO1-8 - Rising and falling edge detection
-WTCHDG - Watchdog interrupt
-PWRDN	- PWRDN reset interrupt

The code should handle these new registers only when the chip
version is TPS65911.

Signed-off-by: Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
---
 drivers/mfd/tps65910-irq.c   |   57 ++++++++++++++++++++++++++++++++---------
 include/linux/mfd/tps65910.h |   32 ++++++++++++++++++++++-
 2 files changed, 75 insertions(+), 14 deletions(-)

diff --git a/drivers/mfd/tps65910-irq.c b/drivers/mfd/tps65910-irq.c
index b8435e0..2bfad5c 100644
--- a/drivers/mfd/tps65910-irq.c
+++ b/drivers/mfd/tps65910-irq.c
@@ -41,8 +41,8 @@ static inline int irq_to_tps65910_irq(struct tps65910 *tps65910,
 static irqreturn_t tps65910_irq(int irq, void *irq_data)
 {
 	struct tps65910 *tps65910 = irq_data;
-	u16 irq_sts;
-	u16 irq_mask;
+	u32 irq_sts;
+	u32 irq_mask;
 	u8 reg;
 	int i;
 
@@ -50,18 +50,28 @@ static irqreturn_t tps65910_irq(int irq, void *irq_data)
 	irq_sts = reg;
 	tps65910->read(tps65910, TPS65910_INT_STS2, 1, &reg);
 	irq_sts |= reg << 8;
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65911:
+		tps65910->read(tps65910, TPS65910_INT_STS3, 1, &reg);
+		irq_sts |= reg << 16;
+	}
 
 	tps65910->read(tps65910, TPS65910_INT_MSK, 1, &reg);
 	irq_mask = reg;
 	tps65910->read(tps65910, TPS65910_INT_MSK2, 1, &reg);
 	irq_mask |= reg << 8;
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65911:
+		tps65910->read(tps65910, TPS65910_INT_MSK3, 1, &reg);
+		irq_mask |= reg << 16;
+	}
 
 	irq_sts &= ~irq_mask;
 
 	if (!irq_sts)
 		return IRQ_NONE;
 
-	for (i = 0; i < TPS65910_NUM_IRQ; i++) {
+	for (i = 0; i < tps65910->irq_num; i++) {
 
 		if (!(irq_sts & (1 << i)))
 			continue;
@@ -71,9 +81,15 @@ static irqreturn_t tps65910_irq(int irq, void *irq_data)
 
 	/* Write the STS register back to clear IRQs we handled */
 	reg = irq_sts & 0xFF;
+	irq_sts >>= 8;
 	tps65910->write(tps65910, TPS65910_INT_STS, 1, &reg);
-	reg = irq_sts >> 8;
+	reg = irq_sts & 0xFF;
 	tps65910->write(tps65910, TPS65910_INT_STS2, 1, &reg);
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65911:
+		reg = irq_sts >> 8;
+		tps65910->write(tps65910, TPS65910_INT_STS3, 1, &reg);
+	}
 
 	return IRQ_HANDLED;
 }
@@ -88,19 +104,29 @@ static void tps65910_irq_lock(struct irq_data *data)
 static void tps65910_irq_sync_unlock(struct irq_data *data)
 {
 	struct tps65910 *tps65910 = irq_data_get_irq_chip_data(data);
-	u16 reg_mask;
+	u32 reg_mask;
 	u8 reg;
 
 	tps65910->read(tps65910, TPS65910_INT_MSK, 1, &reg);
 	reg_mask = reg;
 	tps65910->read(tps65910, TPS65910_INT_MSK2, 1, &reg);
 	reg_mask |= reg << 8;
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65911:
+		tps65910->read(tps65910, TPS65910_INT_MSK3, 1, &reg);
+		reg_mask |= reg << 16;
+	}
 
 	if (tps65910->irq_mask != reg_mask) {
 		reg = tps65910->irq_mask & 0xFF;
 		tps65910->write(tps65910, TPS65910_INT_MSK, 1, &reg);
-		reg = tps65910->irq_mask >> 8;
+		reg = tps65910->irq_mask >> 8 & 0xFF;
 		tps65910->write(tps65910, TPS65910_INT_MSK2, 1, &reg);
+		switch (tps65910_chip_id(tps65910)) {
+		case TPS65911:
+			reg = tps65910->irq_mask >> 16;
+			tps65910->write(tps65910, TPS65910_INT_MSK3, 1, &reg);
+		}
 	}
 	mutex_unlock(&tps65910->irq_lock);
 }
@@ -132,7 +158,6 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 {
 	int ret, cur_irq;
 	int flags = IRQF_ONESHOT;
-	u8 reg;
 
 	if (!irq) {
 		dev_warn(tps65910->dev, "No interrupt support, no core IRQ\n");
@@ -144,19 +169,22 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		return -EINVAL;
 	}
 
-	/* Mask top level interrupts */
-	reg = 0xFF;
-	tps65910->write(tps65910, TPS65910_INT_MSK, 1, &reg);
-	reg = 0x03;
-	tps65910->write(tps65910, TPS65910_INT_MSK2, 1, &reg);
+	tps65910->irq_mask = 0xFFFFFF;
 
 	mutex_init(&tps65910->irq_lock);
 	tps65910->chip_irq = irq;
 	tps65910->irq_base = pdata->irq_base;
 
+	switch (tps65910_chip_id(tps65910)) {
+	case TPS65910:
+		tps65910->irq_num = TPS65910_NUM_IRQ;
+	case TPS65911:
+		tps65910->irq_num = TPS65911_NUM_IRQ;
+	}
+
 	/* Register with genirq */
 	for (cur_irq = tps65910->irq_base;
-	     cur_irq < TPS65910_NUM_IRQ + tps65910->irq_base;
+	     cur_irq < tps65910->irq_num + tps65910->irq_base;
 	     cur_irq++) {
 		irq_set_chip_data(cur_irq, tps65910);
 		irq_set_chip_and_handler(cur_irq, &tps65910_irq_chip,
@@ -174,6 +202,9 @@ int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 
 	ret = request_threaded_irq(irq, NULL, tps65910_irq, flags,
 				   "tps65910", tps65910);
+
+	irq_set_irq_type(irq, IRQ_TYPE_LEVEL_LOW);
+
 	if (ret != 0)
 		dev_err(tps65910->dev, "Failed to request IRQ: %d\n", ret);
 
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 20359e6..32bb7b8 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -763,6 +763,35 @@
 #define TPS65910_IRQ_GPIO_F				9
 #define TPS65910_NUM_IRQ				10
 
+#define TPS65911_IRQ_VBAT_VMBDCH			0
+#define TPS65911_IRQ_VBAT_VMBDCH2L			1
+#define TPS65911_IRQ_VBAT_VMBDCH2H			2
+#define TPS65911_IRQ_VBAT_VMHI				3
+#define TPS65911_IRQ_PWRON				4
+#define TPS65911_IRQ_PWRON_LP				5
+#define TPS65911_IRQ_PWRHOLD_F				6
+#define TPS65911_IRQ_PWRHOLD_R				7
+#define TPS65911_IRQ_HOTDIE				8
+#define TPS65911_IRQ_RTC_ALARM				9
+#define TPS65911_IRQ_RTC_PERIOD				10
+#define TPS65911_IRQ_GPIO0_R				11
+#define TPS65911_IRQ_GPIO0_F				12
+#define TPS65911_IRQ_GPIO1_R				13
+#define TPS65911_IRQ_GPIO1_F				14
+#define TPS65911_IRQ_GPIO2_R				15
+#define TPS65911_IRQ_GPIO2_F				16
+#define TPS65911_IRQ_GPIO3_R				17
+#define TPS65911_IRQ_GPIO3_F				18
+#define TPS65911_IRQ_GPIO4_R				19
+#define TPS65911_IRQ_GPIO4_F				20
+#define TPS65911_IRQ_GPIO5_R				21
+#define TPS65911_IRQ_GPIO5_F				22
+#define TPS65911_IRQ_WTCHDG				23
+#define TPS65911_IRQ_PWRDN				24
+
+#define TPS65911_NUM_IRQ				25
+
+
 /* GPIO Register Definitions */
 #define TPS65910_GPIO_DEB				BIT(2)
 #define TPS65910_GPIO_PUEN				BIT(3)
@@ -806,7 +835,8 @@ struct tps65910 {
 	struct mutex irq_lock;
 	int chip_irq;
 	int irq_base;
-	u16 irq_mask;
+	int irq_num;
+	u32 irq_mask;
 };
 
 struct tps65910_platform_data {
-- 
1.7.1

