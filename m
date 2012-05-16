Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932967Ab2EPHl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:41:57 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16153 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab2EPHly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:41:54 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-6f-4fb35a412bd4
From: Chanwoo Choi <cw00.choi@samsung.com>
To: gregkh@linuxfoundation.org, broonie@opensource.wolfsonmicro.com,
        thomas.abraham@linaro.org
Cc: grant.likely@secretlab.ca, sameo@linux.intel.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
Date: Wed, 16 May 2012 16:41:44 +0900
Message-id: <1337154104-22036-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Abraham <thomas.abraham@linaro.org>

Add irq domain support for max8997 interrupts. The reverse mapping method
used is linear mapping since the sub-drivers of max8997 such as regulator
and charger drivers can use the max8997 irq_domain to get the linux irq
number for max8997 interrupts. All uses of irq_base in platform data and
max8997 driver private data are removed.

Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Acked-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-exynos/mach-nuri.c    |    4 --
 arch/arm/mach-exynos/mach-origen.c  |    1 -
 drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
 drivers/mfd/max8997.c               |    1 -
 include/linux/mfd/max8997-private.h |    4 ++-
 include/linux/mfd/max8997.h         |    1 -
 6 files changed, 40 insertions(+), 33 deletions(-)

diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
index 23d2254..0a53849 100644
--- a/arch/arm/mach-exynos/mach-nuri.c
+++ b/arch/arm/mach-exynos/mach-nuri.c
@@ -1064,12 +1064,8 @@ static struct platform_device nuri_max8903_device = {
 static void __init nuri_power_init(void)
 {
 	int gpio;
-	int irq_base = IRQ_GPIO_END + 1;
 	int ta_en = 0;
 
-	nuri_max8997_pdata.irq_base = irq_base;
-	irq_base += MAX8997_IRQ_NR;
-
 	gpio = EXYNOS4_GPX0(7);
 	gpio_request(gpio, "AP_PMIC_IRQ");
 	s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
index 827cb99..d3b2e9d 100644
--- a/arch/arm/mach-exynos/mach-origen.c
+++ b/arch/arm/mach-exynos/mach-origen.c
@@ -424,7 +424,6 @@ static struct max8997_platform_data __initdata origen_max8997_pdata = {
 	.buck1_gpiodvs	= false,
 	.buck2_gpiodvs	= false,
 	.buck5_gpiodvs	= false,
-	.irq_base	= IRQ_GPIO_END + 1,
 
 	.ignore_gpiodvs_side_effect = true,
 	.buck125_default_idx = 0x0,
diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
index 87cdfbd..3454855 100644
--- a/drivers/mfd/max8997-irq.c
+++ b/drivers/mfd/max8997-irq.c
@@ -142,7 +142,8 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
 static const inline struct max8997_irq_data *
 irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
 {
-	return &max8997_irqs[irq - max8997->irq_base];
+	struct irq_data *data = irq_get_irq_data(irq);
+	return &max8997_irqs[data->hwirq];
 }
 
 static void max8997_irq_mask(struct irq_data *data)
@@ -182,7 +183,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 	u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
 	u8 irq_src;
 	int ret;
-	int i;
+	int i, cur_irq;
 
 	ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
 	if (ret < 0) {
@@ -269,8 +270,11 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 
 	/* Report */
 	for (i = 0; i < MAX8997_IRQ_NR; i++) {
-		if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask)
-			handle_nested_irq(max8997->irq_base + i);
+		if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask) {
+			cur_irq = irq_find_mapping(max8997->irq_domain, i);
+			if (cur_irq)
+				handle_nested_irq(cur_irq);
+		}
 	}
 
 	return IRQ_HANDLED;
@@ -278,26 +282,40 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
 
 int max8997_irq_resume(struct max8997_dev *max8997)
 {
-	if (max8997->irq && max8997->irq_base)
-		max8997_irq_thread(max8997->irq_base, max8997);
+	if (max8997->irq && max8997->irq_domain)
+		max8997_irq_thread(0, max8997);
+	return 0;
+}
+
+static int max8997_irq_domain_map(struct irq_domain *d, unsigned int irq,
+					irq_hw_number_t hw)
+{
+	struct max8997_dev *max8997 = d->host_data;
+
+	irq_set_chip_data(irq, max8997);
+	irq_set_chip_and_handler(irq, &max8997_irq_chip, handle_edge_irq);
+	irq_set_nested_thread(irq, 1);
+#ifdef CONFIG_ARM
+	set_irq_flags(irq, IRQF_VALID);
+#else
+	irq_set_noprobe(irq);
+#endif
 	return 0;
 }
 
+static struct irq_domain_ops max8997_irq_domain_ops = {
+	.map = max8997_irq_domain_map,
+};
+
 int max8997_irq_init(struct max8997_dev *max8997)
 {
+	struct irq_domain *domain;
 	int i;
-	int cur_irq;
 	int ret;
 	u8 val;
 
 	if (!max8997->irq) {
 		dev_warn(max8997->dev, "No interrupt specified.\n");
-		max8997->irq_base = 0;
-		return 0;
-	}
-
-	if (!max8997->irq_base) {
-		dev_err(max8997->dev, "No interrupt base specified.\n");
 		return 0;
 	}
 
@@ -327,19 +345,13 @@ int max8997_irq_init(struct max8997_dev *max8997)
 					true : false;
 	}
 
-	/* Register with genirq */
-	for (i = 0; i < MAX8997_IRQ_NR; i++) {
-		cur_irq = i + max8997->irq_base;
-		irq_set_chip_data(cur_irq, max8997);
-		irq_set_chip_and_handler(cur_irq, &max8997_irq_chip,
-				handle_edge_irq);
-		irq_set_nested_thread(cur_irq, 1);
-#ifdef CONFIG_ARM
-		set_irq_flags(cur_irq, IRQF_VALID);
-#else
-		irq_set_noprobe(cur_irq);
-#endif
+	domain = irq_domain_add_linear(NULL, MAX8997_IRQ_NR,
+					&max8997_irq_domain_ops, max8997);
+	if (!domain) {
+		dev_err(max8997->dev, "could not create irq domain\n");
+		return -ENODEV;
 	}
+	max8997->irq_domain = domain;
 
 	ret = request_threaded_irq(max8997->irq, NULL, max8997_irq_thread,
 			IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index cb83a7a..20ecad3 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -143,7 +143,6 @@ static int max8997_i2c_probe(struct i2c_client *i2c,
 	if (!pdata)
 		goto err;
 
-	max8997->irq_base = pdata->irq_base;
 	max8997->ono = pdata->ono;
 
 	mutex_init(&max8997->iolock);
diff --git a/include/linux/mfd/max8997-private.h b/include/linux/mfd/max8997-private.h
index 3f4deb6..830152c 100644
--- a/include/linux/mfd/max8997-private.h
+++ b/include/linux/mfd/max8997-private.h
@@ -23,6 +23,8 @@
 #define __LINUX_MFD_MAX8997_PRIV_H
 
 #include <linux/i2c.h>
+#include <linux/export.h>
+#include <linux/irqdomain.h>
 
 #define MAX8997_REG_INVALID	(0xff)
 
@@ -325,7 +327,7 @@ struct max8997_dev {
 
 	int irq;
 	int ono;
-	int irq_base;
+	struct irq_domain *irq_domain;
 	struct mutex irqlock;
 	int irq_masks_cur[MAX8997_IRQ_GROUP_NR];
 	int irq_masks_cache[MAX8997_IRQ_GROUP_NR];
diff --git a/include/linux/mfd/max8997.h b/include/linux/mfd/max8997.h
index b40c08c..328d8e2 100644
--- a/include/linux/mfd/max8997.h
+++ b/include/linux/mfd/max8997.h
@@ -181,7 +181,6 @@ struct max8997_led_platform_data {
 
 struct max8997_platform_data {
 	/* IRQ */
-	int irq_base;
 	int ono;
 	int wakeup;
 
-- 
1.7.0.4

