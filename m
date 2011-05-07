Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab1EGBVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:52 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:41962 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1EGBVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:07 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 03/11] rtc: ep93xx: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:46 -0700
Message-Id: <1304731254-3238-4-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
References: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <w.sang@pengutronix.de>

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") uncovered
an issue in a number of RTC drivers, where the drivers call
rtc_device_register before initializing the device or platform drvdata.

This frequently results in null pointer dereferences when the
rtc_device_register immediately makes use of the rtc device, calling
rtc_read_alarm.

The solution is to ensure the drvdata is initialized prior to registering
the rtc device.

CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: rtc-linux@googlegroups.com
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
[Fixed up commit log -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-ep93xx.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 11ae64d..335551d 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -151,6 +151,7 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		return -ENXIO;
 
 	pdev->dev.platform_data = ep93xx_rtc;
+	platform_set_drvdata(pdev, rtc);
 
 	rtc = rtc_device_register(pdev->name,
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
@@ -159,8 +160,6 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	platform_set_drvdata(pdev, rtc);
-
 	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
 		goto fail;
@@ -168,9 +167,9 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail:
-	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(rtc);
 exit:
+	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
 	return err;
 }
-- 
1.7.3.2.146.gca209

