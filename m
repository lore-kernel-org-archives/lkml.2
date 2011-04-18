Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1DROLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 10:11:24 -0400
Received: from dakia2.marvell.com ([65.219.4.35]:58362 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754140Ab1DROJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 10:09:50 -0400
X-ASG-Debug-ID: 1303135789-082e703c0001-xx1T2L
X-Barracuda-Envelope-From: haojian.zhuang@marvell.com
From: Haojian Zhuang <haojian.zhuang@marvell.com>
To: sameo@linux.intel.com, haojian.zhuang@gmail.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk,
        broonie@opensource.wolfsonmicro.com
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>
X-ASG-Orig-Subj: [PATCH 09/14] input: get irq from resource in max8925 onkey
Subject: [PATCH 09/14] input: get irq from resource in max8925 onkey
Date: Mon, 18 Apr 2011 22:04:06 +0800
X-ASG-Orig-Subj: [PATCH 09/14] input: get irq from resource in max8925 onkey
Message-Id: <1303135451-26362-10-git-send-email-haojian.zhuang@marvell.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <2011041801>
References: <2011041801>
X-Barracuda-Connect: maili.marvell.com[10.68.76.51]
X-Barracuda-Start-Time: 1303135789
X-Barracuda-URL: http://10.68.76.222:80/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: -1002.00
X-Barracuda-Spam-Status: No, SCORE=-1002.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid to use hardcoding irq numbers in max8925 onkey driver. Get irq
from resources instead.

Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/misc/max8925_onkey.c |   36 ++++++++++++++++--------------------
 1 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/input/misc/max8925_onkey.c b/drivers/input/misc/max8925_onkey.c
index 7de0ded..835cc2a 100644
--- a/drivers/input/misc/max8925_onkey.c
+++ b/drivers/input/misc/max8925_onkey.c
@@ -69,18 +69,7 @@ static int __devinit max8925_onkey_probe(struct platform_device *pdev)
 {
 	struct max8925_chip *chip = dev_get_drvdata(pdev->dev.parent);
 	struct max8925_onkey_info *info;
-	int irq[2], error;
-
-	irq[0] = platform_get_irq(pdev, 0);
-	if (irq[0] < 0) {
-		dev_err(&pdev->dev, "No IRQ resource!\n");
-		return -EINVAL;
-	}
-	irq[1] = platform_get_irq(pdev, 1);
-	if (irq[1] < 0) {
-		dev_err(&pdev->dev, "No IRQ resource!\n");
-		return -EINVAL;
-	}
+	int error = -EINVAL;
 
 	info = kzalloc(sizeof(struct max8925_onkey_info), GFP_KERNEL);
 	if (!info)
@@ -88,21 +77,30 @@ static int __devinit max8925_onkey_probe(struct platform_device *pdev)
 
 	info->i2c = chip->i2c;
 	info->dev = &pdev->dev;
-	irq[0] += chip->irq_base;
-	irq[1] += chip->irq_base;
 
-	error = request_threaded_irq(irq[0], NULL, max8925_onkey_handler,
+	info->irq[0] = platform_get_irq(pdev, 0);
+	if (info->irq[0] < 0) {
+		dev_err(&pdev->dev, "No IRQ resource!\n");
+		goto out;
+	}
+	info->irq[1] = platform_get_irq(pdev, 1);
+	if (info->irq[1] < 0) {
+		dev_err(&pdev->dev, "No IRQ resource!\n");
+		goto out;
+	}
+
+	error = request_threaded_irq(info->irq[0], NULL, max8925_onkey_handler,
 				     IRQF_ONESHOT, "onkey-down", info);
 	if (error < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
-			irq[0], error);
+			info->irq[0], error);
 		goto out;
 	}
-	error = request_threaded_irq(irq[1], NULL, max8925_onkey_handler,
+	error = request_threaded_irq(info->irq[1], NULL, max8925_onkey_handler,
 				     IRQF_ONESHOT, "onkey-up", info);
 	if (error < 0) {
 		dev_err(chip->dev, "Failed to request IRQ: #%d: %d\n",
-			irq[1], error);
+			info->irq[1], error);
 		goto out_irq;
 	}
 
@@ -117,8 +115,6 @@ static int __devinit max8925_onkey_probe(struct platform_device *pdev)
 	info->idev->phys = "max8925_on/input0";
 	info->idev->id.bustype = BUS_I2C;
 	info->idev->dev.parent = &pdev->dev;
-	info->irq[0] = irq[0];
-	info->irq[1] = irq[1];
 	info->idev->evbit[0] = BIT_MASK(EV_KEY);
 	info->idev->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);
 
-- 
1.5.6.5

