Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab2LSOFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 09:05:07 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:54911 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2LSOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 09:04:59 -0500
Date: Wed, 19 Dec 2012 15:04:56 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-pcf8523: Add low battery voltage support
Message-ID: <20121219140456.GA14217@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements reading of the battery voltage low signal for
rtc-pcf8523.

The bit is read-only and cannot be cleared by software, so no
clear-function is implemented.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
diff --git a/drivers/rtc/rtc-pcf8523.c b/drivers/rtc/rtc-pcf8523.c
index be05a64..82a9895 100644
--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -23,6 +23,7 @@
 #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
 #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
 #define REG_CONTROL3_PM_MASK 0xe0
+#define REG_CONTROL3_BLF (1 << 2) /* Battery low bit, read-only */
 
 #define REG_SECONDS  0x03
 #define REG_SECONDS_OS (1 << 7)
@@ -250,9 +252,29 @@ static int pcf8523_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return pcf8523_start_rtc(client);
 }
 
+static int pcf8523_rtc_read_vl(struct device *dev, int *vl)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 value;
+	int err;
+
+	err = pcf8523_read(client, REG_CONTROL3, &value);
+	if (err < 0)
+		return err;
+
+	if (value & REG_CONTROL3_BLF)
+		*vl = 1;
+	else
+		*vl = 0;
+
+	return 0;
+}
+
+
 static const struct rtc_class_ops pcf8523_rtc_ops = {
-	.read_time = pcf8523_rtc_read_time,
-	.set_time = pcf8523_rtc_set_time,
+	.read_time	= pcf8523_rtc_read_time,
+	.set_time	= pcf8523_rtc_set_time,
+	.read_vl	= pcf8523_rtc_read_vl,
 };
 
 static int pcf8523_probe(struct i2c_client *client,

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
