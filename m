Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1JKJIC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:08:02 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:48113 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752612Ab1JKJH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:07:59 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Andrew Lynn <andrew.lynn@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 4/4] mfd/ab8500-core: expose TurnOnStatus in sysfs
Date: Tue, 11 Oct 2011 10:49:47 +0200
Message-ID: <1318322987-11536-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lynn <andrew.lynn@stericsson.com>

Expose TurnOnStatus (Power key, RTC alarm, Vbus detect, etc) in
sysfs. This magic value can be read by system users to determine
what caused the platform to turn on last (this) time.

Signed-off-by: Andrew Lynn <andrew.lynn@stericsson.com>
Reviewed-by: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Reviewed-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/mfd/ab8500-core.c |   30 ++++++++++++++++++++++++++++++
 1 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/ab8500-core.c b/drivers/mfd/ab8500-core.c
index 41da973..1e91738 100644
--- a/drivers/mfd/ab8500-core.c
+++ b/drivers/mfd/ab8500-core.c
@@ -92,6 +92,8 @@
 #define AB8500_REV_REG			0x80
 #define AB8500_SWITCH_OFF_STATUS	0x00
 
+#define AB8500_TURN_ON_STATUS		0x00
+
 /*
  * Map interrupt numbers to the LATCH and MASK register offsets, Interrupt
  * numbers are indexed into this array with (num / 8).
@@ -812,12 +814,40 @@ static ssize_t show_switch_off_status(struct device *dev,
 	return sprintf(buf, "%#x\n", value);
 }
 
+/*
+ * ab8500 has turned on due to (TURN_ON_STATUS):
+ * 0x01 PORnVbat
+ * 0x02 PonKey1dbF
+ * 0x04 PonKey2dbF
+ * 0x08 RTCAlarm
+ * 0x10 MainChDet
+ * 0x20 VbusDet
+ * 0x40 UsbIDDetect
+ * 0x80 Reserved
+ */
+static ssize_t show_turn_on_status(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	int ret;
+	u8 value;
+	struct ab8500 *ab8500;
+
+	ab8500 = dev_get_drvdata(dev);
+	ret = get_register_interruptible(ab8500, AB8500_SYS_CTRL1_BLOCK,
+		AB8500_TURN_ON_STATUS, &value);
+	if (ret < 0)
+		return ret;
+	return sprintf(buf, "%#x\n", value);
+}
+
 static DEVICE_ATTR(chip_id, S_IRUGO, show_chip_id, NULL);
 static DEVICE_ATTR(switch_off_status, S_IRUGO, show_switch_off_status, NULL);
+static DEVICE_ATTR(turn_on_status, S_IRUGO, show_turn_on_status, NULL);
 
 static struct attribute *ab8500_sysfs_entries[] = {
 	&dev_attr_chip_id.attr,
 	&dev_attr_switch_off_status.attr,
+	&dev_attr_turn_on_status.attr,
 	NULL,
 };
 
-- 
1.7.3.2

