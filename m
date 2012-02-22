Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab2BVCYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 21:24:52 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:57972 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2BVCYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 21:24:50 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.211.202 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1329877484.3210.6.camel@phoenix>
Subject: [PATCH] mfd: wm8994: Return error when device ID mismatch is
 detected
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Wed, 22 Feb 2012 10:24:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We base on wm8994->type to set wm8994->supplies and wm8994->num_supplies.
But in current code, wm8994->type may be changed when device ID mismatch is
detected. If we change wm8994->type, then the wm8994->supplies and
wm8994->num_supplies settings are wrong.

Fix it by return error immediately when device ID mismatch is detected.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8994-core.c |   32 +++++++-------------------------
 1 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 1599bba..6e4612e 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -415,14 +415,17 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 
 	switch (wm8994->type) {
 	case WM1811:
+		devname = "WM1811";
 		for (i = 0; i < ARRAY_SIZE(wm1811_main_supplies); i++)
 			wm8994->supplies[i].supply = wm1811_main_supplies[i];
 		break;
 	case WM8994:
+		devname = "WM8994";
 		for (i = 0; i < ARRAY_SIZE(wm8994_main_supplies); i++)
 			wm8994->supplies[i].supply = wm8994_main_supplies[i];
 		break;
 	case WM8958:
+		devname = "WM8958";
 		for (i = 0; i < ARRAY_SIZE(wm8958_main_supplies); i++)
 			wm8994->supplies[i].supply = wm8958_main_supplies[i];
 		break;
@@ -450,31 +453,10 @@ static __devinit int wm8994_device_init(struct wm8994 *wm8994, int irq)
 		dev_err(wm8994->dev, "Failed to read ID register\n");
 		goto err_enable;
 	}
-	switch (ret) {
-	case 0x1811:
-		devname = "WM1811";
-		if (wm8994->type != WM1811)
-			dev_warn(wm8994->dev, "Device registered as type %d\n",
-				 wm8994->type);
-		wm8994->type = WM1811;
-		break;
-	case 0x8994:
-		devname = "WM8994";
-		if (wm8994->type != WM8994)
-			dev_warn(wm8994->dev, "Device registered as type %d\n",
-				 wm8994->type);
-		wm8994->type = WM8994;
-		break;
-	case 0x8958:
-		devname = "WM8958";
-		if (wm8994->type != WM8958)
-			dev_warn(wm8994->dev, "Device registered as type %d\n",
-				 wm8994->type);
-		wm8994->type = WM8958;
-		break;
-	default:
-		dev_err(wm8994->dev, "Device is not a WM8994, ID is %x\n",
-			ret);
+
+	if (ret != wm8994->type) {
+		dev_err(wm8994->dev, "Device ID mismatch: expect %x but we got %x\n",
+			wm8994->type, ret);
 		ret = -EINVAL;
 		goto err_enable;
 	}
-- 
1.7.5.4



