Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab1EGBVr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44134 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab1EGBVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:10 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 02/11] rtc: davinci: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:45 -0700
Message-Id: <1304731254-3238-3-git-send-email-john.stultz@linaro.org>
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
[fixed up commit log -jstultz]
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/rtc/rtc-davinci.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 8d46838..755e1fe 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -524,6 +524,8 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 		goto fail2;
 	}
 
+	platform_set_drvdata(pdev, davinci_rtc);
+
 	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
@@ -553,8 +555,6 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	rtcss_write(davinci_rtc, PRTCSS_RTC_CCTRL_CAEN, PRTCSS_RTC_CCTRL);
 
-	platform_set_drvdata(pdev, davinci_rtc);
-
 	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
@@ -562,6 +562,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 fail4:
 	rtc_device_unregister(davinci_rtc->rtc);
 fail3:
+	platform_set_drvdata(pdev, NULL);
 	iounmap(davinci_rtc->base);
 fail2:
 	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
-- 
1.7.3.2.146.gca209

