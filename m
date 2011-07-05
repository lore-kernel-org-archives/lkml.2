Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab1GETt5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:49:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60278 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab1GETtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:49:55 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Misael Lopez Cruz <misael.lopez@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v3 2/5] input: twl6040-vibra: Do not use wrapper for irq request
Date: Tue, 5 Jul 2011 22:49:33 +0300
Message-ID: <1309895376-17446-3-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
References: <1309895376-17446-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The twl6040_request_irq/free_irq inline functions are going
to be removed, so replace them with direct calls.
The irq number is provided by the core driver via resource.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 drivers/input/misc/twl6040-vibra.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/input/misc/twl6040-vibra.c b/drivers/input/misc/twl6040-vibra.c
index dbf745d..c43002e 100644
--- a/drivers/input/misc/twl6040-vibra.c
+++ b/drivers/input/misc/twl6040-vibra.c
@@ -47,6 +47,7 @@ struct vibra_info {
 	struct workqueue_struct *workqueue;
 	struct work_struct play_work;
 	struct mutex mutex;
+	int irq;
 
 	bool enabled;
 	int weak_speed;
@@ -277,6 +278,13 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 		goto err_kzalloc;
 	}
 
+	info->irq = platform_get_irq(pdev, 0);
+	if (info->irq < 0) {
+		dev_err(info->dev, "invalid irq\n");
+		ret = -EINVAL;
+		goto err_kzalloc;
+	}
+
 	mutex_init(&info->mutex);
 
 	info->input_dev = input_allocate_device();
@@ -308,9 +316,8 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, info);
 
-	ret = twl6040_request_irq(info->twl6040, TWL6040_IRQ_VIB,
-				  twl6040_vib_irq_handler, 0,
-				  "twl6040_irq_vib", info);
+	ret = request_threaded_irq(info->irq, NULL, twl6040_vib_irq_handler, 0,
+				   "twl6040_irq_vib", info);
 	if (ret) {
 		dev_err(info->dev, "VIB IRQ request failed: %d\n", ret);
 		goto err_irq;
@@ -360,7 +367,7 @@ static int __devinit twl6040_vibra_probe(struct platform_device *pdev)
 err_voltage:
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 err_regulator:
-	twl6040_free_irq(info->twl6040, TWL6040_IRQ_VIB, info);
+	free_irq(info->irq, info);
 err_irq:
 	input_unregister_device(info->input_dev);
 	info->input_dev = NULL;
@@ -379,7 +386,7 @@ static int __devexit twl6040_vibra_remove(struct platform_device *pdev)
 	struct vibra_info *info = platform_get_drvdata(pdev);
 
 	input_unregister_device(info->input_dev);
-	twl6040_free_irq(info->twl6040, TWL6040_IRQ_VIB, info);
+	free_irq(info->irq, info);
 	regulator_bulk_free(ARRAY_SIZE(info->supplies), info->supplies);
 	destroy_workqueue(info->workqueue);
 	kfree(info);
-- 
1.7.6

