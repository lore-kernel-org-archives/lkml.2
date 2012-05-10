Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab2EJML5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 08:11:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:35649 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab2EJMLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 08:11:48 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, Richard Purdie <rpurdie@rpsys.net>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] mfd: lm3533: remove boost attributes
Date: Thu, 10 May 2012 14:11:29 +0200
Message-Id: <1336651889-6425-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.5
In-Reply-To: <1336651889-6425-1-git-send-email-jhovold@gmail.com>
References: <20120510120742.GA29437@localhost>
 <1336651889-6425-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove boost-frequency and ovp attributes, which can be set through
platform data, from sysfs.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 .../ABI/testing/sysfs-bus-i2c-devices-lm3533       |   23 -----
 drivers/mfd/lm3533-core.c                          |   88 --------------------
 2 files changed, 0 insertions(+), 111 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-lm3533 b/Documentation/ABI/testing/sysfs-bus-i2c-devices-lm3533
index 5700721..1b62230 100644
--- a/Documentation/ABI/testing/sysfs-bus-i2c-devices-lm3533
+++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-lm3533
@@ -1,26 +1,3 @@
-What:		/sys/bus/i2c/devices/.../boost_freq
-Date:		April 2012
-KernelVersion:	3.5
-Contact:	Johan Hovold <jhovold@gmail.com>
-Description:
-		Set the boost converter switching frequency (0, 1), where
-
-		0 -  500Hz
-		1 - 1000Hz
-
-What:		/sys/bus/i2c/devices/.../boost_ovp
-Date:		April 2012
-KernelVersion:	3.5
-Contact:	Johan Hovold <jhovold@gmail.com>
-Description:
-		Set the boost converter over-voltage protection threshold
-		(0..3), where
-
-		0 - 16V
-		1 - 24V
-		2 - 32V
-		3 - 40V
-
 What:		/sys/bus/i2c/devices/.../output_hvled[n]
 Date:		April 2012
 KernelVersion:	3.5
diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 053438c..d670543 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -26,11 +26,9 @@
 #include <linux/mfd/lm3533.h>
 
 
-#define LM3533_BOOST_OVP_MAX		0x03
 #define LM3533_BOOST_OVP_MASK		0x06
 #define LM3533_BOOST_OVP_SHIFT		1
 
-#define LM3533_BOOST_FREQ_MAX		0x01
 #define LM3533_BOOST_FREQ_MASK		0x01
 #define LM3533_BOOST_FREQ_SHIFT		0
 
@@ -253,96 +251,12 @@ struct lm3533_device_attribute {
 		struct {
 			u8 id;
 		} output;
-		struct {
-			u8 reg;
-			u8 shift;
-			u8 mask;
-			u8 max;
-		} generic;
 	} u;
 };
 
 #define to_lm3533_dev_attr(_attr) \
 	container_of(_attr, struct lm3533_device_attribute, dev_attr)
 
-static ssize_t show_lm3533_reg(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct lm3533 *lm3533 = dev_get_drvdata(dev);
-	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(attr);
-	u8 val;
-	int ret;
-
-	ret = lm3533_read(lm3533, lattr->u.generic.reg, &val);
-	if (ret)
-		return ret;
-
-	val = (val & lattr->u.generic.mask) >> lattr->u.generic.shift;
-
-	return scnprintf(buf, PAGE_SIZE, "%u\n", val);
-}
-
-static ssize_t store_lm3533_reg(struct device *dev,
-						struct device_attribute *attr,
-						const char *buf, size_t len)
-{
-	struct lm3533 *lm3533 = dev_get_drvdata(dev);
-	struct lm3533_device_attribute *lattr = to_lm3533_dev_attr(attr);
-	u8 val;
-	int ret;
-
-	if (kstrtou8(buf, 0, &val) || val > lattr->u.generic.max)
-		return -EINVAL;
-
-	val = val << lattr->u.generic.shift;
-	ret = lm3533_update(lm3533, lattr->u.generic.reg, val,
-							lattr->u.generic.mask);
-	if (ret)
-		return ret;
-
-	return len;
-}
-
-#define GENERIC_ATTR(_reg, _max, _mask, _shift) \
-	{ .reg		= _reg, \
-	  .max		= _max, \
-	  .mask		= _mask, \
-	  .shift	= _shift }
-
-#define LM3533_GENERIC_ATTR(_name, _mode, _show, _store, _type,	\
-						_reg, _max, _mask, _shift) \
-	struct lm3533_device_attribute lm3533_dev_attr_##_name = { \
-		.dev_attr	= __ATTR(_name, _mode, _show, _store), \
-		.type		= _type, \
-		.u.generic	= GENERIC_ATTR(_reg, _max, _mask, _shift) }
-
-#define LM3533_GENERIC_ATTR_RW(_name, _type, _reg, _max, _mask, _shift) \
-	LM3533_GENERIC_ATTR(_name, S_IRUGO | S_IWUSR, \
-					show_lm3533_reg, store_lm3533_reg, \
-					_type, _reg, _max, _mask, _shift)
-
-#define LM3533_BOOST_ATTR_RW(_name, _NAME) \
-	LM3533_GENERIC_ATTR_RW(_name, LM3533_ATTR_TYPE_BACKLIGHT, \
-				LM3533_REG_BOOST_PWM, LM3533_##_NAME##_MAX, \
-				LM3533_##_NAME##_MASK, LM3533_##_NAME##_SHIFT)
-/*
- * Boost Over Voltage Protection Select
- *
- *   0 - 16 V (default)
- *   1 - 24 V
- *   2 - 32 V
- *   3 - 40 V
- */
-static LM3533_BOOST_ATTR_RW(boost_ovp, BOOST_OVP);
-
-/*
- * Boost Frequency Select
- *
- *   0 - 500 kHz (default)
- *   1 - 1 MHz
- */
-static LM3533_BOOST_ATTR_RW(boost_freq, BOOST_FREQ);
-
 static ssize_t show_output(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
@@ -432,8 +346,6 @@ static LM3533_OUTPUT_LVLED_ATTR_RW(4);
 static LM3533_OUTPUT_LVLED_ATTR_RW(5);
 
 static struct attribute *lm3533_attributes[] = {
-	&lm3533_dev_attr_boost_freq.dev_attr.attr,
-	&lm3533_dev_attr_boost_ovp.dev_attr.attr,
 	&lm3533_dev_attr_output_hvled1.dev_attr.attr,
 	&lm3533_dev_attr_output_hvled2.dev_attr.attr,
 	&lm3533_dev_attr_output_lvled1.dev_attr.attr,
-- 
1.7.8.5

