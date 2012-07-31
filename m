Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2GaQjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 12:39:33 -0400
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:55273 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755735Ab2GaQj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 12:39:29 -0400
X-IronPort-AV: E=Sophos;i="4.77,688,1336341600"; 
   d="scan'208";a="168700823"
From: Damien Cassou <damien.cassou@lifl.fr>
To: Jingoo Han <jg1.han@samsung.com>
Cc: kernel-janitors@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] drivers/video/exynos/exynos_dp_core.c: use devm_ functions
Date: Tue, 31 Jul 2012 18:39:22 +0200
Message-Id: <1343752762-16861-6-git-send-email-damien.cassou@lifl.fr>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
References: <1343752762-16861-1-git-send-email-damien.cassou@lifl.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Damien Cassou <damien.cassou@lifl.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Damien Cassou <damien.cassou@lifl.fr>

---
 drivers/video/exynos/exynos_dp_core.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/video/exynos/exynos_dp_core.c b/drivers/video/exynos/exynos_dp_core.c
index c6c016a..00fe4f0 100644
--- a/drivers/video/exynos/exynos_dp_core.c
+++ b/drivers/video/exynos/exynos_dp_core.c
@@ -872,7 +872,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
 
 	dp->dev = &pdev->dev;
 
-	dp->clock = clk_get(&pdev->dev, "dp");
+	dp->clock = devm_clk_get(&pdev->dev, "dp");
 	if (IS_ERR(dp->clock)) {
 		dev_err(&pdev->dev, "failed to get clock\n");
 		return PTR_ERR(dp->clock);
@@ -881,31 +881,24 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
 	clk_enable(dp->clock);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(&pdev->dev, "failed to get registers\n");
-		ret = -EINVAL;
-		goto err_clock;
-	}
 
 	dp->reg_base = devm_request_and_ioremap(&pdev->dev, res);
 	if (!dp->reg_base) {
 		dev_err(&pdev->dev, "failed to ioremap\n");
-		ret = -ENOMEM;
-		goto err_clock;
+		return -ENOMEM;
 	}
 
 	dp->irq = platform_get_irq(pdev, 0);
 	if (!dp->irq) {
 		dev_err(&pdev->dev, "failed to get irq\n");
-		ret = -ENODEV;
-		goto err_clock;
+		return -ENODEV;
 	}
 
 	ret = devm_request_irq(&pdev->dev, dp->irq, exynos_dp_irq_handler, 0,
 				"exynos-dp", dp);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to request irq\n");
-		goto err_clock;
+		return ret;
 	}
 
 	dp->video_info = pdata->video_info;
@@ -917,7 +910,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
 	ret = exynos_dp_detect_hpd(dp);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to detect hpd\n");
-		goto err_clock;
+		return ret;
 	}
 
 	exynos_dp_handle_edid(dp);
@@ -926,7 +919,7 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
 				dp->video_info->link_rate);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to do link train\n");
-		goto err_clock;
+		return ret;
 	}
 
 	exynos_dp_enable_scramble(dp, 1);
@@ -940,17 +933,12 @@ static int __devinit exynos_dp_probe(struct platform_device *pdev)
 	ret = exynos_dp_config_video(dp, dp->video_info);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to config video\n");
-		goto err_clock;
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, dp);
 
 	return 0;
-
-err_clock:
-	clk_put(dp->clock);
-
-	return ret;
 }
 
 static int __devexit exynos_dp_remove(struct platform_device *pdev)
@@ -962,7 +950,6 @@ static int __devexit exynos_dp_remove(struct platform_device *pdev)
 		pdata->phy_exit();
 
 	clk_disable(dp->clock);
-	clk_put(dp->clock);
 
 	return 0;
 }

