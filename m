Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225Ab2EVKGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:06:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45863 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751859Ab2EVKF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:05:59 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rob Landley <rob@landley.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH 2/2] backlight: lm3533: replace als attribute with als_channel and als_en
Date: Tue, 22 May 2012 12:05:08 +0200
Message-Id: <1337681108-13838-2-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1337681108-13838-1-git-send-email-jhovold@gmail.com>
References: <1337681108-13838-1-git-send-email-jhovold@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace the als attribute with two separate attributes for selecting ALS
channel and enabling ALS-current-control mode.

This change is needed to reflect changes made to the ALS sub-driver
which now uses 0-indexed current output channels (rather than 1-indexed
ALS-mapper target sets).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 .../testing/sysfs-class-backlight-driver-lm3533    |   19 +++++---
 drivers/video/backlight/lm3533_bl.c                |   48 ++++++++++----------
 2 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533 b/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
index ea91f71..77cf7ac 100644
--- a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
+++ b/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
@@ -1,13 +1,20 @@
-What:		/sys/class/backlight/<backlight>/als
-Date:		April 2012
+What:		/sys/class/backlight/<backlight>/als_channel
+Date:		May 2012
 KernelVersion:	3.5
 Contact:	Johan Hovold <jhovold@gmail.com>
 Description:
-		Set the ALS-control mode (0..2), where
+		Get the ALS output channel used as input in
+		ALS-current-control mode (0, 1), where
+
+		0 - out_current0 (backlight 0)
+		1 - out_current1 (backlight 1)
 
-		0 - disabled
-		1 - ALS-mapper 1 (backlight 0)
-		2 - ALS-mapper 2 (backlight 1)
+What:		/sys/class/backlight/<backlight>/als_en
+Date:		May 2012
+KernelVersion:	3.5
+Contact:	Johan Hovold <jhovold@gmail.com>
+Description:
+		Enable ALS-current-control mode (0, 1).
 
 What:		/sys/class/backlight/<backlight>/id
 Date:		April 2012
diff --git a/drivers/video/backlight/lm3533_bl.c b/drivers/video/backlight/lm3533_bl.c
index d916ffe..18dca0c 100644
--- a/drivers/video/backlight/lm3533_bl.c
+++ b/drivers/video/backlight/lm3533_bl.c
@@ -79,55 +79,52 @@ static ssize_t show_id(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%d\n", bl->id);
 }
 
-/*
- * ALS-control setting:
- *
- *   0 - ALS disabled
- *   1 - ALS-mapper 1 (backlight 0)
- *   2 - ALS-mapper 2 (backlight 1)
- */
-static ssize_t show_als(struct device *dev,
+static ssize_t show_als_channel(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct lm3533_bl *bl = dev_get_drvdata(dev);
+	unsigned channel = lm3533_bl_get_ctrlbank_id(bl);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", channel);
+}
+
+static ssize_t show_als_en(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct lm3533_bl *bl = dev_get_drvdata(dev);
 	int ctrlbank = lm3533_bl_get_ctrlbank_id(bl);
 	u8 val;
 	u8 mask;
-	int als;
+	bool enable;
 	int ret;
 
 	ret = lm3533_read(bl->lm3533, LM3533_REG_CTRLBANK_AB_BCONF, &val);
 	if (ret)
 		return ret;
 
-	mask = 2 * ctrlbank;
-	als = val & mask;
-	if (als)
-		als = ctrlbank + 1;
+	mask = 1 << (2 * ctrlbank);
+	enable = val & mask;
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", als);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", enable);
 }
 
-static ssize_t store_als(struct device *dev,
+static ssize_t store_als_en(struct device *dev,
 					struct device_attribute *attr,
 					const char *buf, size_t len)
 {
 	struct lm3533_bl *bl = dev_get_drvdata(dev);
 	int ctrlbank = lm3533_bl_get_ctrlbank_id(bl);
-	int als;
+	int enable;
 	u8 val;
 	u8 mask;
 	int ret;
 
-	if (kstrtoint(buf, 0, &als))
-		return -EINVAL;
-
-	if (als != 0 && (als != ctrlbank + 1))
+	if (kstrtoint(buf, 0, &enable))
 		return -EINVAL;
 
 	mask = 1 << (2 * ctrlbank);
 
-	if (als)
+	if (enable)
 		val = mask;
 	else
 		val = 0;
@@ -224,13 +221,15 @@ static ssize_t store_pwm(struct device *dev,
 	return len;
 }
 
-static LM3533_ATTR_RW(als);
+static LM3533_ATTR_RO(als_channel);
+static LM3533_ATTR_RW(als_en);
 static LM3533_ATTR_RO(id);
 static LM3533_ATTR_RW(linear);
 static LM3533_ATTR_RW(pwm);
 
 static struct attribute *lm3533_bl_attributes[] = {
-	&dev_attr_als.attr,
+	&dev_attr_als_channel.attr,
+	&dev_attr_als_en.attr,
 	&dev_attr_id.attr,
 	&dev_attr_linear.attr,
 	&dev_attr_pwm.attr,
@@ -244,7 +243,8 @@ static umode_t lm3533_bl_attr_is_visible(struct kobject *kobj,
 	struct lm3533_bl *bl = dev_get_drvdata(dev);
 	umode_t mode = attr->mode;
 
-	if (attr == &dev_attr_als.attr) {
+	if (attr == &dev_attr_als_channel.attr ||
+					attr == &dev_attr_als_en.attr) {
 		if (!bl->lm3533->have_als)
 			mode = 0;
 	}
-- 
1.7.8.5

