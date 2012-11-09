Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2KIPcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 10:32:12 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:42781 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab2KIPcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 10:32:05 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: sameo@linux.intel.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 1/2] mfd: stmpe: Use devm_*() routines
Date: Fri,  9 Nov 2012 21:01:54 +0530
Message-Id: <07672d0597e23fbc580843193415b89e81dba326.1352475033.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch frees stmpe driver from tension of freeing resources :)
devm_* derivatives of multiple routines are used while allocating resources,
which would be freed automatically by kernel.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/mfd/stmpe.c | 46 +++++++++++++++-------------------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/drivers/mfd/stmpe.c b/drivers/mfd/stmpe.c
index c94f521..761348c 100644
--- a/drivers/mfd/stmpe.c
+++ b/drivers/mfd/stmpe.c
@@ -1002,7 +1002,7 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 	if (!pdata)
 		return -EINVAL;
 
-	stmpe = kzalloc(sizeof(struct stmpe), GFP_KERNEL);
+	stmpe = devm_kzalloc(ci->dev, sizeof(struct stmpe), GFP_KERNEL);
 	if (!stmpe)
 		return -ENOMEM;
 
@@ -1024,11 +1024,12 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 		ci->init(stmpe);
 
 	if (pdata->irq_over_gpio) {
-		ret = gpio_request_one(pdata->irq_gpio, GPIOF_DIR_IN, "stmpe");
+		ret = devm_gpio_request_one(ci->dev, pdata->irq_gpio,
+				GPIOF_DIR_IN, "stmpe");
 		if (ret) {
 			dev_err(stmpe->dev, "failed to request IRQ GPIO: %d\n",
 					ret);
-			goto out_free;
+			return ret;
 		}
 
 		stmpe->irq = gpio_to_irq(pdata->irq_gpio);
@@ -1045,23 +1046,22 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 			dev_err(stmpe->dev,
 				"%s does not support no-irq mode!\n",
 				stmpe->variant->name);
-			ret = -ENODEV;
-			goto free_gpio;
+			return -ENODEV;
 		}
 		stmpe->variant = stmpe_noirq_variant_info[stmpe->partnum];
 	}
 
 	ret = stmpe_chip_init(stmpe);
 	if (ret)
-		goto free_gpio;
+		return ret;
 
 	if (stmpe->irq >= 0) {
 		ret = stmpe_irq_init(stmpe);
 		if (ret)
-			goto free_gpio;
+			return ret;
 
-		ret = request_threaded_irq(stmpe->irq, NULL, stmpe_irq,
-				pdata->irq_trigger | IRQF_ONESHOT,
+		ret = devm_request_threaded_irq(ci->dev, stmpe->irq, NULL,
+				stmpe_irq, pdata->irq_trigger | IRQF_ONESHOT,
 				"stmpe", stmpe);
 		if (ret) {
 			dev_err(stmpe->dev, "failed to request IRQ: %d\n",
@@ -1071,25 +1071,16 @@ int __devinit stmpe_probe(struct stmpe_client_info *ci, int partnum)
 	}
 
 	ret = stmpe_devices_init(stmpe);
-	if (ret) {
-		dev_err(stmpe->dev, "failed to add children\n");
-		goto out_removedevs;
-	}
-
-	return 0;
+	if (!ret)
+		return 0;
 
-out_removedevs:
+	dev_err(stmpe->dev, "failed to add children\n");
 	mfd_remove_devices(stmpe->dev);
-	if (stmpe->irq >= 0)
-		free_irq(stmpe->irq, stmpe);
+
 out_removeirq:
 	if (stmpe->irq >= 0)
 		stmpe_irq_remove(stmpe);
-free_gpio:
-	if (pdata->irq_over_gpio)
-		gpio_free(pdata->irq_gpio);
-out_free:
-	kfree(stmpe);
+
 	return ret;
 }
 
@@ -1097,15 +1088,8 @@ int stmpe_remove(struct stmpe *stmpe)
 {
 	mfd_remove_devices(stmpe->dev);
 
-	if (stmpe->irq >= 0) {
-		free_irq(stmpe->irq, stmpe);
+	if (stmpe->irq >= 0)
 		stmpe_irq_remove(stmpe);
-	}
-
-	if (stmpe->pdata->irq_over_gpio)
-		gpio_free(stmpe->pdata->irq_gpio);
-
-	kfree(stmpe);
 
 	return 0;
 }
-- 
1.7.12.rc2.18.g61b472e

