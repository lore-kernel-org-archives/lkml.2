Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976Ab2ATVZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 16:25:43 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:40270 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299Ab2ATVZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 16:25:39 -0500
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: kernel-janitors@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] drivers/video/backlight/wm831x_bl.c: use devm_ functions
Date: Fri, 20 Jan 2012 22:25:29 +0100
Message-Id: <1327094732-9050-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1327094732-9050-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1327094732-9050-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The various devm_ functions allocate memory that is released when a driver
detaches.  This patch uses these functions for data that is allocated in
the probe function of a platform device and is only freed in the remove
function.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/video/backlight/wm831x_bl.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/video/backlight/wm831x_bl.c b/drivers/video/backlight/wm831x_bl.c
index 4e915f5..5d365de 100644
--- a/drivers/video/backlight/wm831x_bl.c
+++ b/drivers/video/backlight/wm831x_bl.c
@@ -186,7 +186,7 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return ret;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
 	if (data == NULL)
 		return -ENOMEM;
 
@@ -200,7 +200,6 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 				       &wm831x_backlight_ops, &props);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-		kfree(data);
 		return PTR_ERR(bl);
 	}
 
@@ -211,7 +210,6 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 	/* Disable the DCDC if it was started so we can bootstrap */
 	wm831x_set_bits(wm831x, WM831X_DCDC_ENABLE, WM831X_DC4_ENA, 0);
 
-
 	backlight_update_status(bl);
 
 	return 0;
@@ -220,10 +218,8 @@ static int wm831x_backlight_probe(struct platform_device *pdev)
 static int wm831x_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct wm831x_backlight_data *data = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
-	kfree(data);
 	return 0;
 }
 

