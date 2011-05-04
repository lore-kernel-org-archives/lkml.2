Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab1EDPc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 11:32:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42848 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1EDPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 11:32:24 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 2/3] rtc: mxc: fix crash on boot
Date: Wed,  4 May 2011 17:31:27 +0200
Message-Id: <1304523088-17039-3-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
References: <1304523088-17039-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f44f7f96a20 ("RTC: Initialize kernel state from RTC") caused a
crash using the mxc-rtc driver.

The reason is that rtc_device_register() calls rtc_read_alarm() after
that change, when the driver does not have all driver data set up yet.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
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
1.7.2.5

