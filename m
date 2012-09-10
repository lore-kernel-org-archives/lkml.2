Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2IJKqm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 06:46:42 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:38311 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757150Ab2IJKqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 06:46:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Dmitry Torokhov <dtor@mail.ru>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Tero Kristo <t-kristo@ti.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/14] Input: twl4030-vibra: Support for DT booted kernel
Date: Mon, 10 Sep 2012 13:46:26 +0300
Message-Id: <1347273992-9107-9-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
References: <1347273992-9107-1-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support when the kernel has been booted with DT blob. In this case the
pdata is NULL, we need to reach up to the core node and check if the codec
part has been enabled to determine if we need to coexist with the codec or
not.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/twl4030-vibra.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/input/misc/twl4030-vibra.c b/drivers/input/misc/twl4030-vibra.c
index fc0ed9b..2194a3c 100644
--- a/drivers/input/misc/twl4030-vibra.c
+++ b/drivers/input/misc/twl4030-vibra.c
@@ -26,6 +26,7 @@
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 #include <linux/workqueue.h>
 #include <linux/i2c/twl.h>
 #include <linux/mfd/twl4030-audio.h>
@@ -194,13 +195,26 @@ static int twl4030_vibra_resume(struct device *dev)
 static SIMPLE_DEV_PM_OPS(twl4030_vibra_pm_ops,
 			 twl4030_vibra_suspend, twl4030_vibra_resume);
 
+static bool twl4030_vibra_check_coexist(struct twl4030_vibra_data *pdata,
+			      struct device_node *node)
+{
+	if (pdata && pdata->coexist)
+		return true;
+
+	if (of_find_node_by_name(node, "codec"))
+		return true;
+
+	return false;
+}
+
 static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
 {
 	struct twl4030_vibra_data *pdata = pdev->dev.platform_data;
+	struct device_node *twl4030_core_node = pdev->dev.parent->of_node;
 	struct vibra_info *info;
 	int ret;
 
-	if (!pdata) {
+	if (!pdata && !twl4030_core_node) {
 		dev_dbg(&pdev->dev, "platform_data not available\n");
 		return -EINVAL;
 	}
@@ -210,7 +224,7 @@ static int __devinit twl4030_vibra_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	info->dev = &pdev->dev;
-	info->coexist = pdata->coexist;
+	info->coexist = twl4030_vibra_check_coexist(pdata, twl4030_core_node);
 	INIT_WORK(&info->play_work, vibra_play_work);
 
 	info->input_dev = input_allocate_device();
-- 
1.7.12

