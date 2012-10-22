Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab2JVPuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:50:22 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45399 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750950Ab2JVPuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:50:20 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
To: <mchehab@infradead.org>, <laurent.pinchart@ideasonboard.com>,
        <manjunath.hadli@ti.com>, <prabhakar.lad@ti.com>,
        <linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RESEND-PATCH] media:davinci: clk - {prepare/unprepare} for common clk
Date: Mon, 22 Oct 2012 11:50:07 -0400
Message-ID: <1350921007-22419-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a first step towards migrating davinci platforms to use common clock
framework, replace all instances of clk_enable() with clk_prepare_enable()
and clk_disable() with clk_disable_unprepare().

Also fixes some issues related to clk clean up in the driver

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
rebased to v3.7-rc1

 drivers/media/platform/davinci/dm355_ccdc.c  |    8 ++++++--
 drivers/media/platform/davinci/dm644x_ccdc.c |   16 ++++++++++------
 drivers/media/platform/davinci/isif.c        |    5 ++++-
 drivers/media/platform/davinci/vpbe.c        |   10 +++++++---
 drivers/media/platform/davinci/vpif.c        |    8 ++++----
 5 files changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index ce0e413..030950d 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -1003,7 +1003,7 @@ static int __devinit dm355_ccdc_probe(struct platform_device *pdev)
 		status = PTR_ERR(ccdc_cfg.mclk);
 		goto fail_nomap;
 	}
-	if (clk_enable(ccdc_cfg.mclk)) {
+	if (clk_prepare_enable(ccdc_cfg.mclk)) {
 		status = -ENODEV;
 		goto fail_mclk;
 	}
@@ -1014,7 +1014,7 @@ static int __devinit dm355_ccdc_probe(struct platform_device *pdev)
 		status = PTR_ERR(ccdc_cfg.sclk);
 		goto fail_mclk;
 	}
-	if (clk_enable(ccdc_cfg.sclk)) {
+	if (clk_prepare_enable(ccdc_cfg.sclk)) {
 		status = -ENODEV;
 		goto fail_sclk;
 	}
@@ -1034,8 +1034,10 @@ static int __devinit dm355_ccdc_probe(struct platform_device *pdev)
 	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
 	return 0;
 fail_sclk:
+	clk_disable_unprepare(ccdc_cfg.sclk);
 	clk_put(ccdc_cfg.sclk);
 fail_mclk:
+	clk_disable_unprepare(ccdc_cfg.mclk);
 	clk_put(ccdc_cfg.mclk);
 fail_nomap:
 	iounmap(ccdc_cfg.base_addr);
@@ -1050,6 +1052,8 @@ static int dm355_ccdc_remove(struct platform_device *pdev)
 {
 	struct resource	*res;
 
+	clk_disable_unprepare(ccdc_cfg.sclk);
+	clk_disable_unprepare(ccdc_cfg.mclk);
 	clk_put(ccdc_cfg.mclk);
 	clk_put(ccdc_cfg.sclk);
 	iounmap(ccdc_cfg.base_addr);
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index ee7942b..0215ab6 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -994,7 +994,7 @@ static int __devinit dm644x_ccdc_probe(struct platform_device *pdev)
 		status = PTR_ERR(ccdc_cfg.mclk);
 		goto fail_nomap;
 	}
-	if (clk_enable(ccdc_cfg.mclk)) {
+	if (clk_prepare_enable(ccdc_cfg.mclk)) {
 		status = -ENODEV;
 		goto fail_mclk;
 	}
@@ -1005,7 +1005,7 @@ static int __devinit dm644x_ccdc_probe(struct platform_device *pdev)
 		status = PTR_ERR(ccdc_cfg.sclk);
 		goto fail_mclk;
 	}
-	if (clk_enable(ccdc_cfg.sclk)) {
+	if (clk_prepare_enable(ccdc_cfg.sclk)) {
 		status = -ENODEV;
 		goto fail_sclk;
 	}
@@ -1013,8 +1013,10 @@ static int __devinit dm644x_ccdc_probe(struct platform_device *pdev)
 	printk(KERN_NOTICE "%s is registered with vpfe.\n", ccdc_hw_dev.name);
 	return 0;
 fail_sclk:
+	clk_disable_unprepare(ccdc_cfg.sclk);
 	clk_put(ccdc_cfg.sclk);
 fail_mclk:
+	clk_disable_unprepare(ccdc_cfg.mclk);
 	clk_put(ccdc_cfg.mclk);
 fail_nomap:
 	iounmap(ccdc_cfg.base_addr);
@@ -1029,6 +1031,8 @@ static int dm644x_ccdc_remove(struct platform_device *pdev)
 {
 	struct resource	*res;
 
+	clk_disable_unprepare(ccdc_cfg.mclk);
+	clk_disable_unprepare(ccdc_cfg.sclk);
 	clk_put(ccdc_cfg.mclk);
 	clk_put(ccdc_cfg.sclk);
 	iounmap(ccdc_cfg.base_addr);
@@ -1046,8 +1050,8 @@ static int dm644x_ccdc_suspend(struct device *dev)
 	/* Disable CCDC */
 	ccdc_enable(0);
 	/* Disable both master and slave clock */
-	clk_disable(ccdc_cfg.mclk);
-	clk_disable(ccdc_cfg.sclk);
+	clk_disable_unprepare(ccdc_cfg.mclk);
+	clk_disable_unprepare(ccdc_cfg.sclk);
 
 	return 0;
 }
@@ -1055,8 +1059,8 @@ static int dm644x_ccdc_suspend(struct device *dev)
 static int dm644x_ccdc_resume(struct device *dev)
 {
 	/* Enable both master and slave clock */
-	clk_enable(ccdc_cfg.mclk);
-	clk_enable(ccdc_cfg.sclk);
+	clk_prepare_enable(ccdc_cfg.mclk);
+	clk_prepare_enable(ccdc_cfg.sclk);
 	/* Restore CCDC context */
 	ccdc_restore_context();
 
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index b99d542..2c26c3e 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1053,7 +1053,7 @@ static int __devinit isif_probe(struct platform_device *pdev)
 		status = PTR_ERR(isif_cfg.mclk);
 		goto fail_mclk;
 	}
-	if (clk_enable(isif_cfg.mclk)) {
+	if (clk_prepare_enable(isif_cfg.mclk)) {
 		status = -ENODEV;
 		goto fail_mclk;
 	}
@@ -1125,6 +1125,7 @@ fail_nobase_res:
 		i--;
 	}
 fail_mclk:
+	clk_disable_unprepare(isif_cfg.mclk);
 	clk_put(isif_cfg.mclk);
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
 	return status;
@@ -1145,6 +1146,8 @@ static int isif_remove(struct platform_device *pdev)
 		i++;
 	}
 	vpfe_unregister_ccdc_device(&isif_hw_dev);
+	clk_disable_unprepare(isif_cfg.mclk);
+	clk_put(isif_cfg.mclk);
 	return 0;
 }
 
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 69d7a58..7f5cf9b 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -612,7 +612,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 			ret =  PTR_ERR(vpbe_dev->dac_clk);
 			goto fail_mutex_unlock;
 		}
-		if (clk_enable(vpbe_dev->dac_clk)) {
+		if (clk_prepare_enable(vpbe_dev->dac_clk)) {
 			ret =  -ENODEV;
 			goto fail_mutex_unlock;
 		}
@@ -759,8 +759,10 @@ fail_kfree_encoders:
 fail_dev_unregister:
 	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
 fail_clk_put:
-	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
+	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0) {
+		clk_disable_unprepare(vpbe_dev->dac_clk);
 		clk_put(vpbe_dev->dac_clk);
+	}
 fail_mutex_unlock:
 	mutex_unlock(&vpbe_dev->lock);
 	return ret;
@@ -777,8 +779,10 @@ fail_mutex_unlock:
 static void vpbe_deinitialize(struct device *dev, struct vpbe_device *vpbe_dev)
 {
 	v4l2_device_unregister(&vpbe_dev->v4l2_dev);
-	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0)
+	if (strcmp(vpbe_dev->cfg->module_name, "dm644x-vpbe-display") != 0) {
+		clk_disable_unprepare(vpbe_dev->dac_clk);
 		clk_put(vpbe_dev->dac_clk);
+	}
 
 	kfree(vpbe_dev->amp);
 	kfree(vpbe_dev->encoders);
diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index cff3c0a..0d6cc8e 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -444,7 +444,7 @@ static int __devinit vpif_probe(struct platform_device *pdev)
 		status = PTR_ERR(vpif_clk);
 		goto clk_fail;
 	}
-	clk_enable(vpif_clk);
+	clk_prepare_enable(vpif_clk);
 
 	spin_lock_init(&vpif_lock);
 	dev_info(&pdev->dev, "vpif probe success\n");
@@ -460,7 +460,7 @@ fail:
 static int __devexit vpif_remove(struct platform_device *pdev)
 {
 	if (vpif_clk) {
-		clk_disable(vpif_clk);
+		clk_disable_unprepare(vpif_clk);
 		clk_put(vpif_clk);
 	}
 
@@ -472,13 +472,13 @@ static int __devexit vpif_remove(struct platform_device *pdev)
 #ifdef CONFIG_PM
 static int vpif_suspend(struct device *dev)
 {
-	clk_disable(vpif_clk);
+	clk_disable_unprepare(vpif_clk);
 	return 0;
 }
 
 static int vpif_resume(struct device *dev)
 {
-	clk_enable(vpif_clk);
+	clk_prepare_enable(vpif_clk);
 	return 0;
 }
 
-- 
1.7.9.5

