Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab2GDFL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:11:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54651 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956Ab2GDFLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:11:54 -0400
From: Bryan Wu <bryan.wu@canonical.com>
To: linux-leds@vger.kernel.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH 10/25] leds: convert Renesas TPU LED driver to devm_kzalloc() and cleanup error exit path
Date: Wed,  4 Jul 2012 13:10:02 +0800
Message-Id: <1341378617-10386-11-git-send-email-bryan.wu@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Magnus Damm <damm@opensource.se>
Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
---
 drivers/leds/leds-renesas-tpu.c |   23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/leds-renesas-tpu.c b/drivers/leds/leds-renesas-tpu.c
index 32fe337..9ee12c2 100644
--- a/drivers/leds/leds-renesas-tpu.c
+++ b/drivers/leds/leds-renesas-tpu.c
@@ -243,31 +243,30 @@ static int __devinit r_tpu_probe(struct platform_device *pdev)
 	struct led_renesas_tpu_config *cfg = pdev->dev.platform_data;
 	struct r_tpu_priv *p;
 	struct resource *res;
-	int ret = -ENXIO;
+	int ret;
 
 	if (!cfg) {
 		dev_err(&pdev->dev, "missing platform data\n");
 		goto err0;
 	}
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&pdev->dev, sizeof(*p), GFP_KERNEL);
 	if (p == NULL) {
 		dev_err(&pdev->dev, "failed to allocate driver data\n");
-		ret = -ENOMEM;
-		goto err0;
+		return -ENOMEM;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res) {
 		dev_err(&pdev->dev, "failed to get I/O memory\n");
-		goto err1;
+		return -ENXIO;
 	}
 
 	/* map memory, let mapbase point to our channel */
 	p->mapbase = ioremap_nocache(res->start, resource_size(res));
 	if (p->mapbase == NULL) {
 		dev_err(&pdev->dev, "failed to remap I/O memory\n");
-		goto err1;
+		return -ENXIO;
 	}
 
 	/* get hold of clock */
@@ -275,7 +274,7 @@ static int __devinit r_tpu_probe(struct platform_device *pdev)
 	if (IS_ERR(p->clk)) {
 		dev_err(&pdev->dev, "cannot get clock\n");
 		ret = PTR_ERR(p->clk);
-		goto err2;
+		goto err0;
 	}
 
 	p->pdev = pdev;
@@ -294,7 +293,7 @@ static int __devinit r_tpu_probe(struct platform_device *pdev)
 	p->ldev.flags |= LED_CORE_SUSPENDRESUME;
 	ret = led_classdev_register(&pdev->dev, &p->ldev);
 	if (ret < 0)
-		goto err3;
+		goto err1;
 
 	/* max_brightness may be updated by the LED core code */
 	p->min_rate = p->ldev.max_brightness * p->refresh_rate;
@@ -302,14 +301,11 @@ static int __devinit r_tpu_probe(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 	return 0;
 
- err3:
+ err1:
 	r_tpu_set_pin(p, R_TPU_PIN_UNUSED, LED_OFF);
 	clk_put(p->clk);
- err2:
-	iounmap(p->mapbase);
- err1:
-	kfree(p);
  err0:
+	iounmap(p->mapbase);
 	return ret;
 }
 
@@ -327,7 +323,6 @@ static int __devexit r_tpu_remove(struct platform_device *pdev)
 	clk_put(p->clk);
 
 	iounmap(p->mapbase);
-	kfree(p);
 	return 0;
 }
 
-- 
1.7.10.4

