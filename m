Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030668Ab2CGW25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:28:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39876 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab2CGW2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:28:51 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Shawn Guo <shawn.guo@linaro.org>, Huang Shijie <b32955@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 3/3] rtc: stmp3xxx: use global stmp_device functionality
Date: Wed,  7 Mar 2012 23:28:34 +0100
Message-Id: <1331159314-12022-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
References: <1331159314-12022-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The former mach specific reset_block function has been converted to a global
one. Use the new one to remove mach dependency from the driver. Also simplify
code using the new STMP_OFFSET_REG_* macros.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/rtc/Kconfig        |    1 +
 drivers/rtc/rtc-stmp3xxx.c |   29 ++++++++++-------------------
 2 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 3a125b8..e124f93 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -983,6 +983,7 @@ config RTC_DRV_COH901331
 config RTC_DRV_STMP
 	tristate "Freescale STMP3xxx/i.MX23/i.MX28 RTC"
 	depends on ARCH_MXS
+	select STMP_DEVICE
 	help
 	  If you say yes here you will get support for the onboard
 	  STMP3xxx/i.MX23/i.MX28 RTC.
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index 1028786..e755d3e 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -25,11 +25,9 @@
 #include <linux/interrupt.h>
 #include <linux/rtc.h>
 #include <linux/slab.h>
-
-#include <mach/common.h>
+#include <linux/stmp_device.h>
 
 #define STMP3XXX_RTC_CTRL			0x0
-#define STMP3XXX_RTC_CTRL_SET			0x4
 #define STMP3XXX_RTC_CTRL_CLR			0x8
 #define STMP3XXX_RTC_CTRL_ALARM_IRQ_EN		0x00000001
 #define STMP3XXX_RTC_CTRL_ONEMSEC_IRQ_EN	0x00000002
@@ -44,7 +42,6 @@
 #define STMP3XXX_RTC_ALARM			0x40
 
 #define STMP3XXX_RTC_PERSISTENT0		0x60
-#define STMP3XXX_RTC_PERSISTENT0_SET		0x64
 #define STMP3XXX_RTC_PERSISTENT0_CLR		0x68
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN	0x00000002
 #define STMP3XXX_RTC_PERSISTENT0_ALARM_EN	0x00000004
@@ -106,20 +103,14 @@ static irqreturn_t stmp3xxx_rtc_interrupt(int irq, void *dev_id)
 static int stmp3xxx_alarm_irq_enable(struct device *dev, unsigned int enabled)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
+	u32 set_clr_offset = enabled ? STMP_OFFSET_REG_SET : STMP_OFFSET_REG_CLR;
+
+	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
+		STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
+		rtc_data->io + STMP3XXX_RTC_PERSISTENT0 + set_clr_offset);
+	writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
+		rtc_data->io + STMP3XXX_RTC_CTRL + set_clr_offset);
 
-	if (enabled) {
-		writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
-				STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
-				rtc_data->io + STMP3XXX_RTC_PERSISTENT0_SET);
-		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
-				rtc_data->io + STMP3XXX_RTC_CTRL_SET);
-	} else {
-		writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
-				STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN,
-				rtc_data->io + STMP3XXX_RTC_PERSISTENT0_CLR);
-		writel(STMP3XXX_RTC_CTRL_ALARM_IRQ_EN,
-				rtc_data->io + STMP3XXX_RTC_CTRL_CLR);
-	}
 	return 0;
 }
 
@@ -206,7 +197,7 @@ static int stmp3xxx_rtc_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, rtc_data);
 
-	mxs_reset_block(rtc_data->io);
+	stmp_reset_block(rtc_data->io);
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
@@ -253,7 +244,7 @@ static int stmp3xxx_rtc_resume(struct platform_device *dev)
 {
 	struct stmp3xxx_rtc_data *rtc_data = platform_get_drvdata(dev);
 
-	mxs_reset_block(rtc_data->io);
+	stmp_reset_block(rtc_data->io);
 	writel(STMP3XXX_RTC_PERSISTENT0_ALARM_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE_EN |
 			STMP3XXX_RTC_PERSISTENT0_ALARM_WAKE,
-- 
1.7.9.1

