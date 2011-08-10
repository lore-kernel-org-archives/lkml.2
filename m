Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751052Ab1HJNLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 09:11:39 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61974 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab1HJNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 09:11:38 -0400
Subject: [PATCH] rtc: ep93xx: Fix 'rtc' may be used uninitialized warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <w.sang@pengutronix.de>, Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 21:11:26 +0800
Message-ID: <1312981886.21916.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 92d921c5d "rtc: ep93xx: Initialize drvdata before registering device"
ensures the drvdata is initialized prior to registering the rtc device.
But it set the drvdata to an uninitialized pointer.
Thus calling platform_get_drvdata in ep93xx_rtc_remove does not get correct address.

This patch fixes below warning by adding struct rtc_device *rtc to struct ep93xx_rtc.
Then set platform drvdata to ep93xx_rtc instead of rtc.

  CC      drivers/rtc/rtc-ep93xx.o
drivers/rtc/rtc-ep93xx.c: In function 'ep93xx_rtc_probe':
drivers/rtc/rtc-ep93xx.c:154: warning: 'rtc' may be used uninitialized in this function

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
hi,
I don't have this hardware handy, I appreciate someone can test this patch.
Thanks,
Axel

 drivers/rtc/rtc-ep93xx.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 335551d..14a42a1 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -36,6 +36,7 @@
  */
 struct ep93xx_rtc {
 	void __iomem	*mmio_base;
+	struct rtc_device *rtc;
 };
 
 static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
@@ -130,7 +131,6 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 {
 	struct ep93xx_rtc *ep93xx_rtc;
 	struct resource *res;
-	struct rtc_device *rtc;
 	int err;
 
 	ep93xx_rtc = devm_kzalloc(&pdev->dev, sizeof(*ep93xx_rtc), GFP_KERNEL);
@@ -151,12 +151,12 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		return -ENXIO;
 
 	pdev->dev.platform_data = ep93xx_rtc;
-	platform_set_drvdata(pdev, rtc);
+	platform_set_drvdata(pdev, ep93xx_rtc);
 
-	rtc = rtc_device_register(pdev->name,
+	ep93xx_rtc->rtc = rtc_device_register(pdev->name,
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
+	if (IS_ERR(ep93xx_rtc->rtc)) {
+		err = PTR_ERR(ep93xx_rtc->rtc);
 		goto exit;
 	}
 
@@ -167,7 +167,7 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail:
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(ep93xx_rtc->rtc);
 exit:
 	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
@@ -176,11 +176,11 @@ exit:
 
 static int __exit ep93xx_rtc_remove(struct platform_device *pdev)
 {
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	struct ep93xx_rtc *ep93xx_rtc = platform_get_drvdata(pdev);
 
 	sysfs_remove_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	platform_set_drvdata(pdev, NULL);
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(ep93xx_rtc->rtc);
 	pdev->dev.platform_data = NULL;
 
 	return 0;
-- 
1.7.4.1



