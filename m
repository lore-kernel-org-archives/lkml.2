Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab1EGBVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:55 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:43073 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1EGBVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:36 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 04/11] rtc: ds1286: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:47 -0700
Message-Id: <1304731254-3238-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
References: <1304731254-3238-1-git-send-email-john.stultz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") uncovered
an issue in a number of RTC drivers, where the drivers call
rtc_device_register before initializing the device or platform drvdata.

This frequently results in null pointer dereferences when the
rtc_device_register immediately makes use of the rtc device, calling
rtc_read_alarm.

The solution is to ensure the drvdata is initialized prior to registering
the rtc device.

CC: Wolfram Sang <w.sang@pengutronix.de>
CC: Alessandro Zummo <a.zummo@towertech.it>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: rtc-linux@googlegroups.com
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-ds1286.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 60ce696..47e681d 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -355,6 +355,7 @@ static int __devinit ds1286_probe(struct platform_device *pdev)
 		goto out;
 	}
 	spin_lock_init(&priv->lock);
+	platform_set_drvdata(pdev, priv);
 	rtc = rtc_device_register("ds1286", &pdev->dev,
 				  &ds1286_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -362,7 +363,6 @@ static int __devinit ds1286_probe(struct platform_device *pdev)
 		goto out;
 	}
 	priv->rtc = rtc;
-	platform_set_drvdata(pdev, priv);
 	return 0;
 
 out:
-- 
1.7.3.2.146.gca209

