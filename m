Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2LSPem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:34:42 -0500
Received: from anubis.se.axis.com ([195.60.68.12]:59332 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab2LSPeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:34:36 -0500
Date: Wed, 19 Dec 2012 16:34:32 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] rtc-pcf8523: Add low battery voltage support
Message-ID: <20121219153432.GC14217@axis.com>
References: <20121219140456.GA14217@axis.com>
 <20121219144225.GB7837@avionic-0098.adnet.avionic-design.de>
 <20121219151054.GB14217@axis.com>
 <20121219151937.GA21212@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121219151937.GA21212@avionic-0098.adnet.avionic-design.de>
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
index be05a64..62905fb 100644
--- a/drivers/rtc/rtc-pcf8523.c
+++ b/drivers/rtc/rtc-pcf8523.c
@@ -23,6 +23,7 @@
 #define REG_CONTROL3_PM_VDD (1 << 6) /* switch-over disabled */
 #define REG_CONTROL3_PM_DSM (1 << 5) /* direct switching mode */
 #define REG_CONTROL3_PM_MASK 0xe0
+#define REG_CONTROL3_BLF (1 << 2) /* battery low bit, read-only */
 
 #define REG_SECONDS  0x03
 #define REG_SECONDS_OS (1 << 7)
@@ -250,9 +252,36 @@ static int pcf8523_rtc_set_time(struct device *dev, struct rtc_time *tm)
 	return pcf8523_start_rtc(client);
 }
 
+static int
+pcf8523_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	u8 value;
+	int err;
+	int ret = 0;
+
+	switch (cmd) {
+	case RTC_VL_READ:
+		err = pcf8523_read(client, REG_CONTROL3, &value);
+		if (err < 0)
+			return err;
+
+		if (value & REG_CONTROL3_BLF)
+			ret = 1;
+
+		if (copy_to_user((void __user *)arg, &ret, sizeof(int)))
+			return -EFAULT;
+
+		return 0;
+	default:
+		return -ENOIOCTLCMD;
+	}
+}
+
 static const struct rtc_class_ops pcf8523_rtc_ops = {
 	.read_time = pcf8523_rtc_read_time,
 	.set_time = pcf8523_rtc_set_time,
+	.ioctl = pcf8523_rtc_ioctl,
 };
 
 static int pcf8523_probe(struct i2c_client *client,


/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
