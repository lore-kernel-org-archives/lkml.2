Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab1KILPL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 06:15:11 -0500
Received: from mail-pz0-f42.google.com ([209.85.210.42]:39271 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875Ab1KILPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 06:15:09 -0500
From: Eric Miao <eric.y.miao@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Cc: Eric Miao <eric.y.miao@gmail.com>
Subject: [PATCH] hwmon: (max1111) change sysfs interface to in[0-3]_input in millivolts
Date: Wed,  9 Nov 2011 19:15:03 +0800
Message-Id: <1320837303-30697-1-git-send-email-eric.y.miao@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed the inconsistent max1111 sysfs interface as pointed
out by Jean Delvare:

    It was pointed to me that the max1111 driver doesn't implement the
    standard sysfs interface for hwmon drivers (as described in
    Documentation/hwmon/sysfs-interface). It exports files adc[0-3]_in,
    which
    aren't part of the standard interface. Presumably these should be
    renamed to in[0-3]_input. Renaming them is probably not sufficient
    though, as I see no scaling done in the driver. As the MAX1111 chip has
    a documented full scale of 2.048V, I take it that the LSB of the ADC
    has a weight of 8 mV. Exporting raw register values to user-space is
    not OK.

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Eric Miao <eric.y.miao@gmail.com>
---
 drivers/hwmon/max1111.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index c97b78e..0e9fcfd 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -106,11 +106,12 @@ static ssize_t show_adc(struct device *dev,
 	if (ret < 0)
 		return ret;
 
-	return sprintf(buf, "%d\n", ret);
+	/* assume the reference voltage to be 2.048V */
+	return sprintf(buf, "%d\n", 2048 * 256 / ret);
 }
 
 #define MAX1111_ADC_ATTR(_id)		\
-	SENSOR_DEVICE_ATTR(adc##_id##_in, S_IRUGO, show_adc, NULL, _id)
+	SENSOR_DEVICE_ATTR(in##_id##_input, S_IRUGO, show_adc, NULL, _id)
 
 static DEVICE_ATTR(name, S_IRUGO, show_name, NULL);
 static MAX1111_ADC_ATTR(0);
@@ -120,10 +121,10 @@ static MAX1111_ADC_ATTR(3);
 
 static struct attribute *max1111_attributes[] = {
 	&dev_attr_name.attr,
-	&sensor_dev_attr_adc0_in.dev_attr.attr,
-	&sensor_dev_attr_adc1_in.dev_attr.attr,
-	&sensor_dev_attr_adc2_in.dev_attr.attr,
-	&sensor_dev_attr_adc3_in.dev_attr.attr,
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
 	NULL,
 };
 
-- 
1.7.5.4

