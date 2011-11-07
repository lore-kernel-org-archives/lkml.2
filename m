Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1KGL5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:57:21 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:53165 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835Ab1KGL5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:57:19 -0500
From: JJ Ding <jj_ding@emc.com.tw>
To: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: JJ Ding <jj_ding@emc.com.tw>, JJ Ding <dgdunix@gmail.com>
Subject: [PATCH v2] Input: convert obsolete strict_strtox to kstrtox
Date: Mon,  7 Nov 2011 19:54:50 +0800
Message-Id: <1320666890-29615-1-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.8.rc0.32.g87bf9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: JJ Ding <dgdunix@gmail.com>

With commit 67d0a0754455f89ef3946946159d8ec9e45ce33a we mark strict_strtox
as obsolete. Convert all remaining such uses in drivers/input/.

Also change the data type from long to int as Dmitry sugguests, we now have
kstrtouint which suits these uses better.

Signed-off-by: JJ Ding <dgdunix@gmail.com>
---
 drivers/input/input-polldev.c       |    4 ++--
 drivers/input/keyboard/atkbd.c      |   20 ++++++++++----------
 drivers/input/keyboard/lm8323.c     |    9 ++++-----
 drivers/input/misc/adxl34x.c        |   16 ++++++++--------
 drivers/input/misc/ati_remote2.c    |   12 ++++++------
 drivers/input/mouse/elantech.c      |    4 ++--
 drivers/input/mouse/hgpk.c          |    8 ++++----
 drivers/input/mouse/logips2pp.c     |    4 ++--
 drivers/input/mouse/psmouse-base.c  |   15 ++++++---------
 drivers/input/mouse/sentelic.c      |   21 ++++++++++-----------
 drivers/input/mouse/trackpoint.c    |    8 ++++----
 drivers/input/tablet/aiptek.c       |   26 +++++++++++++-------------
 drivers/input/touchscreen/ad7877.c  |   16 ++++++++--------
 drivers/input/touchscreen/ad7879.c  |    4 ++--
 drivers/input/touchscreen/ads7846.c |    4 ++--
 15 files changed, 83 insertions(+), 88 deletions(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index b253973..0ccf2b6 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -83,9 +83,9 @@ static ssize_t input_polldev_set_poll(struct device *dev,
 {
 	struct input_polled_dev *polldev = dev_get_drvdata(dev);
 	struct input_dev *input = polldev->input;
-	unsigned long interval;
+	unsigned int interval;
 
-	if (strict_strtoul(buf, 0, &interval))
+	if (kstrtouint(buf, 0, &interval))
 		return -EINVAL;
 
 	if (interval < polldev->poll_interval_min)
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 19cfc0c..1e98ebf 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1305,7 +1305,7 @@ static ssize_t atkbd_show_extra(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_extra(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	bool old_extra;
 	unsigned char old_set;
@@ -1313,7 +1313,7 @@ static ssize_t atkbd_set_extra(struct atkbd *atkbd, const char *buf, size_t coun
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtouint(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->extra != value) {
@@ -1389,11 +1389,11 @@ static ssize_t atkbd_show_scroll(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_scroll(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	bool old_scroll;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtouint(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->scroll != value) {
@@ -1433,7 +1433,7 @@ static ssize_t atkbd_show_set(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_set(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	unsigned char old_set;
 	bool old_extra;
@@ -1441,7 +1441,7 @@ static ssize_t atkbd_set_set(struct atkbd *atkbd, const char *buf, size_t count)
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || (value != 2 && value != 3))
+	if (kstrtouint(buf, 10, &value) || (value != 2 && value != 3))
 		return -EINVAL;
 
 	if (atkbd->set != value) {
@@ -1484,14 +1484,14 @@ static ssize_t atkbd_show_softrepeat(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_softrepeat(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	bool old_softrepeat, old_softraw;
 
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtouint(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->softrepeat != value) {
@@ -1534,11 +1534,11 @@ static ssize_t atkbd_show_softraw(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_softraw(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	bool old_softraw;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtouint(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (atkbd->softraw != value) {
diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index 82d1dc8..54eeab2 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -545,10 +545,9 @@ static ssize_t lm8323_pwm_store_time(struct device *dev,
 {
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm8323_pwm *pwm = cdev_to_pwm(led_cdev);
-	int ret;
-	unsigned long time;
+	int ret, time;
 
-	ret = strict_strtoul(buf, 10, &time);
+	ret = kstrtoint(buf, 10, &time);
 	/* Numbers only, please. */
 	if (ret)
 		return -EINVAL;
@@ -613,9 +612,9 @@ static ssize_t lm8323_set_disable(struct device *dev,
 {
 	struct lm8323_chip *lm = dev_get_drvdata(dev);
 	int ret;
-	unsigned long i;
+	unsigned int i;
 
-	ret = strict_strtoul(buf, 10, &i);
+	ret = kstrtouint(buf, 10, &i);
 
 	mutex_lock(&lm->lock);
 	lm->kp_enabled = !i;
diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index 144ddbd..af35885 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -451,10 +451,10 @@ static ssize_t adxl34x_disable_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct adxl34x *ac = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -540,10 +540,10 @@ static ssize_t adxl34x_rate_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct adxl34x *ac = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -575,10 +575,10 @@ static ssize_t adxl34x_autosleep_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct adxl34x *ac = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -622,13 +622,13 @@ static ssize_t adxl34x_write_store(struct device *dev,
 				   const char *buf, size_t count)
 {
 	struct adxl34x *ac = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
 	/*
 	 * This allows basic ADXL register write access for debug purposes.
 	 */
-	error = strict_strtoul(buf, 16, &val);
+	error = kstrtouint(buf, 16, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 1de58e8..efc7eba 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -41,13 +41,13 @@ static int ati_remote2_set_mask(const char *val,
 				const struct kernel_param *kp,
 				unsigned int max)
 {
-	unsigned long mask;
+	unsigned int mask;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtoul(val, 0, &mask);
+	ret = kstrtouint(val, 0, &mask);
 	if (ret)
 		return ret;
 
@@ -719,10 +719,10 @@ static ssize_t ati_remote2_store_channel_mask(struct device *dev,
 	struct usb_device *udev = to_usb_device(dev);
 	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
-	unsigned long mask;
+	unsigned int mask;
 	int r;
 
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtouint(buf, 0, &mask))
 		return -EINVAL;
 
 	if (mask & ~ATI_REMOTE2_MAX_CHANNEL_MASK)
@@ -768,9 +768,9 @@ static ssize_t ati_remote2_store_mode_mask(struct device *dev,
 	struct usb_device *udev = to_usb_device(dev);
 	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
-	unsigned long mask;
+	unsigned int mask;
 
-	if (strict_strtoul(buf, 0, &mask))
+	if (kstrtouint(buf, 0, &mask))
 		return -EINVAL;
 
 	if (mask & ~ATI_REMOTE2_MAX_MODE_MASK)
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 09b93b1..4bb3b7e 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -1031,10 +1031,10 @@ static ssize_t elantech_set_int_attr(struct psmouse *psmouse,
 	struct elantech_data *etd = psmouse->private;
 	struct elantech_attr_data *attr = data;
 	unsigned char *reg = (unsigned char *) etd + attr->field_offset;
-	unsigned long value;
+	unsigned int value;
 	int err;
 
-	err = strict_strtoul(buf, 16, &value);
+	err = kstrtouint(buf, 16, &value);
 	if (err)
 		return err;
 
diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index 0470dd4..a25f11c 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -789,10 +789,10 @@ static ssize_t hgpk_set_powered(struct psmouse *psmouse, void *data,
 				const char *buf, size_t count)
 {
 	struct hgpk_data *priv = psmouse->private;
-	unsigned long value;
+	unsigned int value;
 	int err;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtouint(buf, 10, &value);
 	if (err || value > 1)
 		return -EINVAL;
 
@@ -881,10 +881,10 @@ static ssize_t hgpk_trigger_recal(struct psmouse *psmouse, void *data,
 				const char *buf, size_t count)
 {
 	struct hgpk_data *priv = psmouse->private;
-	unsigned long value;
+	unsigned int value;
 	int err;
 
-	err = strict_strtoul(buf, 10, &value);
+	err = kstrtouint(buf, 10, &value);
 	if (err || value != 1)
 		return -EINVAL;
 
diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index faac2c3..ac04553 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -155,9 +155,9 @@ static ssize_t ps2pp_attr_show_smartscroll(struct psmouse *psmouse,
 static ssize_t ps2pp_attr_set_smartscroll(struct psmouse *psmouse, void *data,
 					  const char *buf, size_t count)
 {
-	unsigned long value;
+	unsigned int value;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtouint(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	ps2pp_set_smartscroll(psmouse, value);
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 9f352fb..c7ecb06 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1558,12 +1558,9 @@ static ssize_t psmouse_show_int_attr(struct psmouse *psmouse, void *offset, char
 static ssize_t psmouse_set_int_attr(struct psmouse *psmouse, void *offset, const char *buf, size_t count)
 {
 	unsigned int *field = (unsigned int *)((char *)psmouse + (size_t)offset);
-	unsigned long value;
+	unsigned int value;
 
-	if (strict_strtoul(buf, 10, &value))
-		return -EINVAL;
-
-	if ((unsigned int)value != value)
+	if (kstrtouint(buf, 10, &value))
 		return -EINVAL;
 
 	*field = value;
@@ -1671,9 +1668,9 @@ static ssize_t psmouse_attr_set_protocol(struct psmouse *psmouse, void *data, co
 
 static ssize_t psmouse_attr_set_rate(struct psmouse *psmouse, void *data, const char *buf, size_t count)
 {
-	unsigned long value;
+	unsigned int value;
 
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtouint(buf, 10, &value))
 		return -EINVAL;
 
 	psmouse->set_rate(psmouse, value);
@@ -1682,9 +1679,9 @@ static ssize_t psmouse_attr_set_rate(struct psmouse *psmouse, void *data, const
 
 static ssize_t psmouse_attr_set_resolution(struct psmouse *psmouse, void *data, const char *buf, size_t count)
 {
-	unsigned long value;
+	unsigned int value;
 
-	if (strict_strtoul(buf, 10, &value))
+	if (kstrtouint(buf, 10, &value))
 		return -EINVAL;
 
 	psmouse->set_resolution(psmouse, value);
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index c5b12d2..9d4818c 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -408,7 +408,7 @@ static int fsp_onpad_hscr(struct psmouse *psmouse, bool enable)
 static ssize_t fsp_attr_set_setreg(struct psmouse *psmouse, void *data,
 				   const char *buf, size_t count)
 {
-	unsigned long reg, val;
+	int reg, val;
 	char *rest;
 	ssize_t retval;
 
@@ -416,7 +416,7 @@ static ssize_t fsp_attr_set_setreg(struct psmouse *psmouse, void *data,
 	if (rest == buf || *rest != ' ' || reg > 0xff)
 		return -EINVAL;
 
-	if (strict_strtoul(rest + 1, 16, &val) || val > 0xff)
+	if (kstrtoint(rest + 1, 16, &val) || val > 0xff)
 		return -EINVAL;
 
 	if (fsp_reg_write_enable(psmouse, true))
@@ -448,10 +448,9 @@ static ssize_t fsp_attr_set_getreg(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
 	struct fsp_data *pad = psmouse->private;
-	unsigned long reg;
-	int val;
+	int reg, val;
 
-	if (strict_strtoul(buf, 16, &reg) || reg > 0xff)
+	if (kstrtoint(buf, 16, &reg) || reg > 0xff)
 		return -EINVAL;
 
 	if (fsp_reg_read(psmouse, reg, &val))
@@ -480,9 +479,9 @@ static ssize_t fsp_attr_show_pagereg(struct psmouse *psmouse,
 static ssize_t fsp_attr_set_pagereg(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
-	unsigned long val;
+	int val;
 
-	if (strict_strtoul(buf, 16, &val) || val > 0xff)
+	if (kstrtoint(buf, 16, &val) || val > 0xff)
 		return -EINVAL;
 
 	if (fsp_page_reg_write(psmouse, val))
@@ -505,9 +504,9 @@ static ssize_t fsp_attr_show_vscroll(struct psmouse *psmouse,
 static ssize_t fsp_attr_set_vscroll(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
-	unsigned long val;
+	unsigned int val;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	if (kstrtouint(buf, 10, &val) || val > 1)
 		return -EINVAL;
 
 	fsp_onpad_vscr(psmouse, val);
@@ -529,9 +528,9 @@ static ssize_t fsp_attr_show_hscroll(struct psmouse *psmouse,
 static ssize_t fsp_attr_set_hscroll(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
-	unsigned long val;
+	unsigned int val;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	if (kstrtouint(buf, 10, &val) || val > 1)
 		return -EINVAL;
 
 	fsp_onpad_hscr(psmouse, val);
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 54b2fa8..ac9e520 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -89,9 +89,9 @@ static ssize_t trackpoint_set_int_attr(struct psmouse *psmouse, void *data,
 	struct trackpoint_data *tp = psmouse->private;
 	struct trackpoint_attr_data *attr = data;
 	unsigned char *field = (unsigned char *)((char *)tp + attr->field_offset);
-	unsigned long value;
+	unsigned int value;
 
-	if (strict_strtoul(buf, 10, &value) || value > 255)
+	if (kstrtouint(buf, 10, &value) || value > 255)
 		return -EINVAL;
 
 	*field = value;
@@ -115,9 +115,9 @@ static ssize_t trackpoint_set_bit_attr(struct psmouse *psmouse, void *data,
 	struct trackpoint_data *tp = psmouse->private;
 	struct trackpoint_attr_data *attr = data;
 	unsigned char *field = (unsigned char *)((char *)tp + attr->field_offset);
-	unsigned long value;
+	unsigned int value;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	if (kstrtouint(buf, 10, &value) || value > 1)
 		return -EINVAL;
 
 	if (attr->inverted)
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 6d89fd1..79fec1b 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1198,9 +1198,9 @@ static ssize_t
 store_tabletXtilt(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long x;
+	int x;
 
-	if (strict_strtol(buf, 10, &x)) {
+	if (kstrtoint(buf, 10, &x)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
 		if (strncmp(buf, "disable", len))
@@ -1240,9 +1240,9 @@ static ssize_t
 store_tabletYtilt(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long y;
+	int y;
 
-	if (strict_strtol(buf, 10, &y)) {
+	if (kstrtoint(buf, 10, &y)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
 		if (strncmp(buf, "disable", len))
@@ -1277,12 +1277,12 @@ static ssize_t
 store_tabletJitterDelay(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long j;
+	int j;
 
-	if (strict_strtol(buf, 10, &j))
+	if (kstrtoint(buf, 10, &j))
 		return -EINVAL;
 
-	aiptek->newSetting.jitterDelay = (int)j;
+	aiptek->newSetting.jitterDelay = j;
 	return count;
 }
 
@@ -1306,12 +1306,12 @@ static ssize_t
 store_tabletProgrammableDelay(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long d;
+	int d;
 
-	if (strict_strtol(buf, 10, &d))
+	if (kstrtoint(buf, 10, &d))
 		return -EINVAL;
 
-	aiptek->newSetting.programmableDelay = (int)d;
+	aiptek->newSetting.programmableDelay = d;
 	return count;
 }
 
@@ -1557,11 +1557,11 @@ static ssize_t
 store_tabletWheel(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long w;
+	int w;
 
-	if (strict_strtol(buf, 10, &w)) return -EINVAL;
+	if (kstrtoint(buf, 10, &w)) return -EINVAL;
 
-	aiptek->newSetting.wheel = (int)w;
+	aiptek->newSetting.wheel = w;
 	return count;
 }
 
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index 714d4e0..374370e 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -487,10 +487,10 @@ static ssize_t ad7877_disable_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -517,10 +517,10 @@ static ssize_t ad7877_dac_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -547,10 +547,10 @@ static ssize_t ad7877_gpio3_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -578,10 +578,10 @@ static ssize_t ad7877_gpio4_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct ad7877 *ts = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index 131f9d1..76f5cb4 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -339,10 +339,10 @@ static ssize_t ad7879_disable_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct ad7879 *ts = dev_get_drvdata(dev);
-	unsigned long val;
+	unsigned int val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtouint(buf, 10, &val);
 	if (error)
 		return error;
 
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index d507b9b..b72e99c 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -601,9 +601,9 @@ static ssize_t ads7846_disable_store(struct device *dev,
 				     const char *buf, size_t count)
 {
 	struct ads7846 *ts = dev_get_drvdata(dev);
-	unsigned long i;
+	unsigned int i;
 
-	if (strict_strtoul(buf, 10, &i))
+	if (kstrtouint(buf, 10, &i))
 		return -EINVAL;
 
 	if (i)
-- 
1.7.8.rc0.32.g87bf9

