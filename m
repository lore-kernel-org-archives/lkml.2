Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2IGLQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:16:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760435Ab2IGLPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:38 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 16/19] mfd: Provide the tc3589x with its own IRQ domain
Date: Fri,  7 Sep 2012 12:14:56 +0100
Message-Id: <1347016499-29354-17-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for Device Tree enablement all IRQ controllers
should control their own IRQ domain. This patch provides just
that.

CC: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/tc3589x.c       |   73 ++++++++++++++++++++++++++++---------------
 include/linux/mfd/tc3589x.h |    1 +
 2 files changed, 48 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/tc3589x.c b/drivers/mfd/tc3589x.c
index b56ba6b..2df44ac 100644
--- a/drivers/mfd/tc3589x.c
+++ b/drivers/mfd/tc3589x.c
@@ -9,6 +9,7 @@
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
+#include <linux/irqdomain.h>
 #include <linux/slab.h>
 #include <linux/i2c.h>
 #include <linux/mfd/core.h>
@@ -168,8 +169,9 @@ again:
 
 	while (status) {
 		int bit = __ffs(status);
+		int virq = irq_create_mapping(tc3589x->domain, bit);
 
-		handle_nested_irq(tc3589x->irq_base + bit);
+		handle_nested_irq(virq);
 		status &= ~(1 << bit);
 	}
 
@@ -186,38 +188,60 @@ again:
 	return IRQ_HANDLED;
 }
 
-static int tc3589x_irq_init(struct tc3589x *tc3589x)
+static int tc3589x_irq_map(struct irq_domain *d, unsigned int virq,
+				irq_hw_number_t hwirq)
 {
-	int base = tc3589x->irq_base;
-	int irq;
+	struct tc3589x *tc3589x = d->host_data;
 
-	for (irq = base; irq < base + TC3589x_NR_INTERNAL_IRQS; irq++) {
-		irq_set_chip_data(irq, tc3589x);
-		irq_set_chip_and_handler(irq, &dummy_irq_chip,
-					 handle_edge_irq);
-		irq_set_nested_thread(irq, 1);
+	irq_set_chip_data(virq, tc3589x);
+	irq_set_chip_and_handler(virq, &dummy_irq_chip,
+				handle_edge_irq);
+	irq_set_nested_thread(virq, 1);
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, IRQF_VALID);
+	set_irq_flags(virq, IRQF_VALID);
 #else
-		irq_set_noprobe(irq);
+	irq_set_noprobe(virq);
 #endif
-	}
 
 	return 0;
 }
 
-static void tc3589x_irq_remove(struct tc3589x *tc3589x)
+static void tc3589x_irq_unmap(struct irq_domain *d, unsigned int virq)
 {
-	int base = tc3589x->irq_base;
-	int irq;
-
-	for (irq = base; irq < base + TC3589x_NR_INTERNAL_IRQS; irq++) {
 #ifdef CONFIG_ARM
-		set_irq_flags(irq, 0);
+	set_irq_flags(virq, 0);
 #endif
-		irq_set_chip_and_handler(irq, NULL, NULL);
-		irq_set_chip_data(irq, NULL);
+	irq_set_chip_and_handler(virq, NULL, NULL);
+	irq_set_chip_data(virq, NULL);
+}
+
+static struct irq_domain_ops tc3589x_irq_ops = {
+        .map    = tc3589x_irq_map,
+	.unmap  = tc3589x_irq_unmap,
+        .xlate  = irq_domain_xlate_twocell,
+};
+
+static int tc3589x_irq_init(struct tc3589x *tc3589x)
+{
+	int base = tc3589x->irq_base;
+
+	if (base) {
+		tc3589x->domain = irq_domain_add_legacy(
+			NULL, TC3589x_NR_INTERNAL_IRQS, base,
+			0, &tc3589x_irq_ops, tc3589x);
 	}
+	else {
+		tc3589x->domain = irq_domain_add_linear(
+			NULL, TC3589x_NR_INTERNAL_IRQS,
+			&tc3589x_irq_ops, tc3589x);
+	}
+
+	if (!tc3589x->domain) {
+		dev_err(tc3589x->dev, "Failed to create irqdomain\n");
+		return -ENOSYS;
+	}
+
+	return 0;
 }
 
 static int tc3589x_chip_init(struct tc3589x *tc3589x)
@@ -263,7 +287,7 @@ static int __devinit tc3589x_device_init(struct tc3589x *tc3589x)
 	if (blocks & TC3589x_BLOCK_GPIO) {
 		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_gpio,
 				      ARRAY_SIZE(tc3589x_dev_gpio), NULL,
-				      tc3589x->irq_base, NULL);
+				      tc3589x->irq_base, tc3589x->domain);
 		if (ret) {
 			dev_err(tc3589x->dev, "failed to add gpio child\n");
 			return ret;
@@ -274,7 +298,7 @@ static int __devinit tc3589x_device_init(struct tc3589x *tc3589x)
 	if (blocks & TC3589x_BLOCK_KEYPAD) {
 		ret = mfd_add_devices(tc3589x->dev, -1, tc3589x_dev_keypad,
 				      ARRAY_SIZE(tc3589x_dev_keypad), NULL,
-				      tc3589x->irq_base, NULL);
+				      tc3589x->irq_base, tc3589x->domain);
 		if (ret) {
 			dev_err(tc3589x->dev, "failed to keypad child\n");
 			return ret;
@@ -323,7 +347,7 @@ static int __devinit tc3589x_probe(struct i2c_client *i2c,
 				   "tc3589x", tc3589x);
 	if (ret) {
 		dev_err(tc3589x->dev, "failed to request IRQ: %d\n", ret);
-		goto out_removeirq;
+		goto out_free;
 	}
 
 	ret = tc3589x_device_init(tc3589x);
@@ -336,8 +360,6 @@ static int __devinit tc3589x_probe(struct i2c_client *i2c,
 
 out_freeirq:
 	free_irq(tc3589x->i2c->irq, tc3589x);
-out_removeirq:
-	tc3589x_irq_remove(tc3589x);
 out_free:
 	kfree(tc3589x);
 	return ret;
@@ -350,7 +372,6 @@ static int __devexit tc3589x_remove(struct i2c_client *client)
 	mfd_remove_devices(tc3589x->dev);
 
 	free_irq(tc3589x->i2c->irq, tc3589x);
-	tc3589x_irq_remove(tc3589x);
 
 	kfree(tc3589x);
 
diff --git a/include/linux/mfd/tc3589x.h b/include/linux/mfd/tc3589x.h
index 3acb3a8..6b8e1ff 100644
--- a/include/linux/mfd/tc3589x.h
+++ b/include/linux/mfd/tc3589x.h
@@ -117,6 +117,7 @@ struct tc3589x {
 	struct mutex lock;
 	struct device *dev;
 	struct i2c_client *i2c;
+	struct irq_domain *domain;
 
 	int irq_base;
 	int num_gpio;
-- 
1.7.9.5

