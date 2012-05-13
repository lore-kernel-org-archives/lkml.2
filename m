Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2EMS5a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 14:57:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58006 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580Ab2EMS53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 14:57:29 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Update to fully use irq_domain
Date: Sun, 13 May 2012 19:57:22 +0100
Message-Id: <1336935442-1920-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take advantage of the new regmap irq_domain support to dynamically
allocate interrupts, using regmap_irq_get_virq() rather than irq_base
to look up the interrupts. This means that most users should not need
to specify an irq_base at all.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

The regmap-irq irq_domain support is only in -next, is it OK to merge
this via regmap?  There's no massive urgency but it'd be nice.

 drivers/mfd/wm8994-irq.c        |    6 ------
 include/linux/mfd/wm8994/core.h |   12 ++++++------
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index 46b20c4..f1837f6 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -147,12 +147,6 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 		return 0;
 	}
 
-	if (!wm8994->irq_base) {
-		dev_err(wm8994->dev,
-			"No interrupt base specified, no interrupts\n");
-		return 0;
-	}
-
 	ret = regmap_add_irq_chip(wm8994->regmap, wm8994->irq,
 				  IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
 				  wm8994->irq_base, &wm8994_irq_chip,
diff --git a/include/linux/mfd/wm8994/core.h b/include/linux/mfd/wm8994/core.h
index d41bc7b..1f17330 100644
--- a/include/linux/mfd/wm8994/core.h
+++ b/include/linux/mfd/wm8994/core.h
@@ -17,6 +17,7 @@
 
 #include <linux/mutex.h>
 #include <linux/interrupt.h>
+#include <linux/regmap.h>
 
 enum wm8994_type {
 	WM8994 = 0,
@@ -26,7 +27,6 @@ enum wm8994_type {
 
 struct regulator_dev;
 struct regulator_bulk_data;
-struct regmap;
 
 #define WM8994_NUM_GPIO_REGS 11
 #define WM8994_NUM_LDO_REGS   2
@@ -95,17 +95,17 @@ static inline int wm8994_request_irq(struct wm8994 *wm8994, int irq,
 				     irq_handler_t handler, const char *name,
 				     void *data)
 {
-	if (!wm8994->irq_base)
+	if (!wm8994->irq_data)
 		return -EINVAL;
-	return request_threaded_irq(wm8994->irq_base + irq, NULL, handler,
-				    IRQF_TRIGGER_RISING, name,
+	return request_threaded_irq(regmap_irq_get_virq(wm8994->irq_data, irq),
+				    NULL, handler, IRQF_TRIGGER_RISING, name,
 				    data);
 }
 static inline void wm8994_free_irq(struct wm8994 *wm8994, int irq, void *data)
 {
-	if (!wm8994->irq_base)
+	if (!wm8994->irq_data)
 		return;
-	free_irq(wm8994->irq_base + irq, data);
+	free_irq(regmap_irq_get_virq(wm8994->irq_data, irq), data);
 }
 
 int wm8994_irq_init(struct wm8994 *wm8994);
-- 
1.7.10

