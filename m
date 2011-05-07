Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1EGBVK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:10 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:42972 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718Ab1EGBVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:06 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com
Subject: [PATCH 07/11] rtc: max8998: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:50 -0700
Message-Id: <1304731254-3238-8-git-send-email-john.stultz@linaro.org>
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
 drivers/rtc/rtc-max8998.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 3f7bc6b..2e48aa6 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -265,6 +265,8 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 	info->rtc = max8998->rtc;
 	info->irq = max8998->irq_base + MAX8998_IRQ_ALARM0;
 
+	platform_set_drvdata(pdev, info);
+
 	info->rtc_dev = rtc_device_register("max8998-rtc", &pdev->dev,
 			&max8998_rtc_ops, THIS_MODULE);
 
@@ -274,8 +276,6 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	platform_set_drvdata(pdev, info);
-
 	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
 			"rtc-alarm0", info);
 
@@ -293,6 +293,7 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 out_rtc:
+	platform_set_drvdata(pdev, NULL);
 	kfree(info);
 	return ret;
 }
-- 
1.7.3.2.146.gca209

