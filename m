Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920Ab2FAPdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:33:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38863 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756067Ab2FAPdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:33:36 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Chris Rattray <crattray@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: wm8994: Support for user defined irq flags
Date: Fri,  1 Jun 2012 16:33:19 +0100
Message-Id: <1338564800-20936-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chris Rattray <crattray@opensource.wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8994-irq.c         |   10 +++++++++-
 include/linux/mfd/wm8994/pdata.h |    1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/mfd/wm8994-irq.c b/drivers/mfd/wm8994-irq.c
index f1837f6..0aac4af 100644
--- a/drivers/mfd/wm8994-irq.c
+++ b/drivers/mfd/wm8994-irq.c
@@ -21,6 +21,7 @@
 #include <linux/regmap.h>
 
 #include <linux/mfd/wm8994/core.h>
+#include <linux/mfd/wm8994/pdata.h>
 #include <linux/mfd/wm8994/registers.h>
 
 #include <linux/delay.h>
@@ -139,6 +140,8 @@ static struct regmap_irq_chip wm8994_irq_chip = {
 int wm8994_irq_init(struct wm8994 *wm8994)
 {
 	int ret;
+	unsigned long irqflags;
+	struct wm8994_pdata *pdata = wm8994->dev->platform_data;
 
 	if (!wm8994->irq) {
 		dev_warn(wm8994->dev,
@@ -147,8 +150,13 @@ int wm8994_irq_init(struct wm8994 *wm8994)
 		return 0;
 	}
 
+	/* select user or default irq flags */
+	irqflags = IRQF_TRIGGER_HIGH | IRQF_ONESHOT;
+	if (pdata->irq_flags)
+		irqflags = pdata->irq_flags;
+
 	ret = regmap_add_irq_chip(wm8994->regmap, wm8994->irq,
-				  IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+				  irqflags,
 				  wm8994->irq_base, &wm8994_irq_chip,
 				  &wm8994->irq_data);
 	if (ret != 0) {
diff --git a/include/linux/mfd/wm8994/pdata.h b/include/linux/mfd/wm8994/pdata.h
index 893267b..f0361c0 100644
--- a/include/linux/mfd/wm8994/pdata.h
+++ b/include/linux/mfd/wm8994/pdata.h
@@ -141,6 +141,7 @@ struct wm8994_pdata {
 	struct wm8994_ldo_pdata ldo[WM8994_NUM_LDO];
 
 	int irq_base;  /** Base IRQ number for WM8994, required for IRQs */
+	unsigned long irq_flags; /** user irq flags */
 
         int num_drc_cfgs;
         struct wm8994_drc_cfg *drc_cfgs;
-- 
1.7.10

