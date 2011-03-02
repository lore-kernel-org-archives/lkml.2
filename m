Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1CBKxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 05:53:47 -0500
Received: from eu1sys200aog107.obsmtp.com ([207.126.144.123]:47036 "EHLO
	eu1sys200aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757041Ab1CBKxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 05:53:45 -0500
From: Mattias Wallin <mattias.wallin@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>
Subject: [PATCH] MFD: ab8500-core switch off status added
Date: Wed, 2 Mar 2011 11:52:36 +0100
Message-ID: <1299063156-31972-1-git-send-email-mattias.wallin@stericsson.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a sysfs file with the ab8500 switch off status.
The switch off status contains information of what caused the ab8500
chip to power off. A print during boot is also added.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |   47 +++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 8d6c292..6e185b2 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -90,6 +90,7 @@
 #define AB8500_IT_MASK24_REG		0x57
 
 #define AB8500_REV_REG			0x80
+#define AB8500_SWITCH_OFF_STATUS	0x00
 
 /*
  * Map interrupt numbers to the LATCH and MASK register offsets, Interrupt
@@ -652,10 +653,38 @@ static ssize_t show_chip_id(struct device *dev,
 	return sprintf(buf, "%#x\n", ab8500 ? ab8500->chip_id : -EINVAL);
 }
 
+/*
+ * ab8500 has switched off due to (SWITCH_OFF_STATUS):
+ * 0x01 Swoff bit programming
+ * 0x02 Thermal protection activation
+ * 0x04 Vbat lower then BattOk falling threshold
+ * 0x08 Watchdog expired
+ * 0x10 Non presence of 32kHz clock
+ * 0x20 Battery level lower than power on reset threshold
+ * 0x40 Power on key 1 pressed longer than 10 seconds
+ * 0x80 DB8500 thermal shutdown
+ */
+static ssize_t show_switch_off_status(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u8 value;
+	struct ab8500 *ab8500;
+
+	ab8500 = dev_get_drvdata(dev);
+	ret = get_register_interruptible(ab8500, AB8500_RTC,
+		AB8500_SWITCH_OFF_STATUS, &value);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%#x\n", value);
+}
+
 static DEVICE_ATTR(chip_id, S_IRUGO, show_chip_id, NULL);
+static DEVICE_ATTR(switch_off_status, S_IRUGO, show_switch_off_status, NULL);
 
 static struct attribute *ab8500_sysfs_entries[] = {
 	&dev_attr_chip_id.attr,
+	&dev_attr_switch_off_status.attr,
 	NULL,
 };
 
@@ -697,6 +726,24 @@ int __devinit ab8500_init(struct ab8500 *ab8500)
 	}
 	ab8500->chip_id = value;
 
+	/*
+	 * ab8500 has switched off due to (SWITCH_OFF_STATUS):
+	 * 0x01 Swoff bit programming
+	 * 0x02 Thermal protection activation
+	 * 0x04 Vbat lower then BattOk falling threshold
+	 * 0x08 Watchdog expired
+	 * 0x10 Non presence of 32kHz clock
+	 * 0x20 Battery level lower than power on reset threshold
+	 * 0x40 Power on key 1 pressed longer than 10 seconds
+	 * 0x80 DB8500 thermal shutdown
+	 */
+
+	ret = get_register_interruptible(ab8500, AB8500_RTC,
+		AB8500_SWITCH_OFF_STATUS, &value);
+	if (ret < 0)
+		return ret;
+	dev_info(ab8500->dev, "switch off status: %#x", value);
+
 	if (plat && plat->init)
 		plat->init(ab8500);
 
-- 
1.7.4.1

