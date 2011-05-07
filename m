Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1EGBVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 21:21:08 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41423 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695Ab1EGBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 21:21:05 -0400
From: John Stultz <john.stultz@linaro.org>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        John Stultz <john.stultz@linaro.org>
Subject: [PATCH 01/11] rtc: mxc: Initialize drvdata before registering device
Date: Fri,  6 May 2011 18:20:44 -0700
Message-Id: <1304731254-3238-2-git-send-email-john.stultz@linaro.org>
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
 drivers/rtc/rtc-mxc.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 826ab64..d814417 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -418,14 +418,6 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 		goto exit_put_clk;
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
-				  THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto exit_put_clk;
-	}
-
-	pdata->rtc = rtc;
 	platform_set_drvdata(pdev, pdata);
 
 	/* Configure and enable the RTC */
@@ -438,8 +430,19 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 		pdata->irq = -1;
 	}
 
+	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
+				  THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto exit_clr_drvdata;
+	}
+
+	pdata->rtc = rtc;
+
 	return 0;
 
+exit_clr_drvdata:
+	platform_set_drvdata(pdev, NULL);
 exit_put_clk:
 	clk_disable(pdata->clk);
 	clk_put(pdata->clk);
-- 
1.7.3.2.146.gca209

