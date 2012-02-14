Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2BNQOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 11:14:00 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:54801 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756696Ab2BNQN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 11:13:57 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH 2/2 RFC] rtc-pcf8563: Add RTC_VL_READ/RTC_VL_CLR ioctl feature
Date: Tue, 14 Feb 2012 17:13:45 +0100
Message-Id: <1329236025-31323-2-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1329236025-31323-1-git-send-email-alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes are based on arch/cris/arch-v10/drivers/pcf8563.c

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/rtc/rtc-pcf8563.c |   44 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 43 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 606fdfa..0ba4ae7 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -64,6 +64,7 @@ struct pcf8563 {
 	 * 1970...2069.
 	 */
 	int c_polarity;	/* 0: MO_C=1 means 19xx, otherwise MO_C=1 means 20xx */
+	int voltage_low; /* incicates if a low_voltage was detected */
 };
 
 /*
@@ -86,9 +87,11 @@ static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 		return -EIO;
 	}
 
-	if (buf[PCF8563_REG_SC] & PCF8563_SC_LV)
+	if (buf[PCF8563_REG_SC] & PCF8563_SC_LV) {
+		pcf8563->voltage_low = 1;
 		dev_info(&client->dev,
 			"low voltage detected, date/time is not reliable.\n");
+	}
 
 	dev_dbg(&client->dev,
 		"%s: raw data is st1=%02x, st2=%02x, sec=%02x, min=%02x, hr=%02x, "
@@ -173,6 +176,44 @@ static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 	return 0;
 }
 
+#ifdef CONFIG_RTC_INTF_DEV
+static int pcf8563_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct pcf8563 *pcf8563 = i2c_get_clientdata(to_i2c_client(dev));
+	struct rtc_time tm;
+
+	switch (cmd) {
+	case RTC_VL_READ:
+		if (pcf8563->voltage_low)
+			dev_info(dev, "low voltage detected, date/time is not reliable.\n");
+
+		if (copy_to_user((int *) arg, &pcf8563->voltage_low,
+					sizeof(int)))
+			return -EFAULT;
+		return 0;
+	case RTC_VL_CLR:
+		/*
+		 * Clear the VL bit in the seconds register in case
+		 * the time has not been set already (which would
+		 * have cleared it). This does not really matter
+		 * because of the cached voltage_low value but do it
+		 * anyway for consistency.
+		 */
+		if (pcf8563_get_datetime(to_i2c_client(dev), &tm))
+			pcf8563_set_datetime(to_i2c_client(dev), &tm);
+
+		/* Clear the cached value. */
+		pcf8563->voltage_low = 0;
+
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+#else
+#define pcf8563_rtc_ioctl NULL
+#endif
+
 static int pcf8563_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	return pcf8563_get_datetime(to_i2c_client(dev), tm);
@@ -184,6 +225,7 @@ static int pcf8563_rtc_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 static const struct rtc_class_ops pcf8563_rtc_ops = {
+	.ioctl		= pcf8563_rtc_ioctl,
 	.read_time	= pcf8563_rtc_read_time,
 	.set_time	= pcf8563_rtc_set_time,
 };
-- 
1.7.3.4

