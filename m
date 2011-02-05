Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1BEO0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:26:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54987 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab1BEOWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=k9NSe5i3ZTKIFHOLQquxiK3DqT19sDZGjpUHo3w991dQhN0sDMOx5Ph8QJFWfvi6Sd
         vQyHmB8COsbUrBc8kOP+DTdwVkrKrDlVWOEtSxf/muQMy3ljqmO+7ITtlRMkOwystmXo
         Cpopt13XMof2AtJFPOER4vQOaHtUOxoxtb50g=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 23/52] kstrtox: convert drivers/input/
Date: Sat,  5 Feb 2011 16:20:26 +0200
Message-Id: <1296915654-7458-23-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/input/input-polldev.c       |    8 ++-
 drivers/input/keyboard/atkbd.c      |   33 ++++++++++----
 drivers/input/keyboard/lm8323.c     |   20 ++++-----
 drivers/input/misc/adxl34x.c        |   14 +++---
 drivers/input/misc/ati_remote2.c    |   31 +++++++------
 drivers/input/mouse/elantech.c      |   10 +---
 drivers/input/mouse/hgpk.c          |   18 +++++---
 drivers/input/mouse/logips2pp.c     |    8 +++-
 drivers/input/mouse/psmouse-base.c  |   31 ++++++-------
 drivers/input/mouse/sentelic.c      |   79 ++++++++++++++++++----------------
 drivers/input/mouse/sentelic.h      |   10 ++--
 drivers/input/mouse/trackpoint.c    |   19 +++++----
 drivers/input/tablet/aiptek.c       |   34 +++++++--------
 drivers/input/touchscreen/ad7877.c  |   16 ++++----
 drivers/input/touchscreen/ad7879.c  |    4 +-
 drivers/input/touchscreen/ads7846.c |    6 ++-
 16 files changed, 182 insertions(+), 159 deletions(-)

diff --git a/drivers/input/input-polldev.c b/drivers/input/input-polldev.c
index 0559e30..25b2fbb 100644
--- a/drivers/input/input-polldev.c
+++ b/drivers/input/input-polldev.c
@@ -130,10 +130,12 @@ static ssize_t input_polldev_set_poll(struct device *dev,
 {
 	struct input_polled_dev *polldev = dev_get_drvdata(dev);
 	struct input_dev *input = polldev->input;
-	unsigned long interval;
+	unsigned int interval;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &interval))
-		return -EINVAL;
+	rv = kstrtouint(buf, 0, &interval);
+	if (rv < 0)
+		return rv;
 
 	if (interval < polldev->poll_interval_min)
 		return -EINVAL;
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 11478eb..b01c7e7 100644
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
@@ -1313,7 +1313,10 @@ static ssize_t atkbd_set_extra(struct atkbd *atkbd, const char *buf, size_t coun
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	err = kstrtouint(buf, 10, &value);
+	if (err < 0)
+		return err;
+	if (value > 1)
 		return -EINVAL;
 
 	if (atkbd->extra != value) {
@@ -1389,11 +1392,14 @@ static ssize_t atkbd_show_scroll(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_scroll(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	bool old_scroll;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	err = kstrtouint(buf, 10, &value);
+	if (err < 0)
+		return err;
+	if (value > 1)
 		return -EINVAL;
 
 	if (atkbd->scroll != value) {
@@ -1433,7 +1439,7 @@ static ssize_t atkbd_show_set(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_set(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	int value;
 	int err;
 	unsigned char old_set;
 	bool old_extra;
@@ -1441,7 +1447,10 @@ static ssize_t atkbd_set_set(struct atkbd *atkbd, const char *buf, size_t count)
 	if (!atkbd->write)
 		return -EIO;
 
-	if (strict_strtoul(buf, 10, &value) || (value != 2 && value != 3))
+	err = kstrtoint(buf, 10, &value);
+	if (err < 0)
+		return err;
+	if (value != 2 && value != 3)
 		return -EINVAL;
 
 	if (atkbd->set != value) {
@@ -1484,14 +1493,17 @@ static ssize_t atkbd_show_softrepeat(struct atkbd *atkbd, char *buf)
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
+	err = kstrtouint(buf, 10, &value);
+	if (err < 0)
+		return err;
+	if (value > 1)
 		return -EINVAL;
 
 	if (atkbd->softrepeat != value) {
@@ -1534,11 +1546,12 @@ static ssize_t atkbd_show_softraw(struct atkbd *atkbd, char *buf)
 static ssize_t atkbd_set_softraw(struct atkbd *atkbd, const char *buf, size_t count)
 {
 	struct input_dev *old_dev, *new_dev;
-	unsigned long value;
+	unsigned int value;
 	int err;
 	bool old_softraw;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	err = kstrtouint(buf, 10, &value);
+	if (value > 1)
 		return -EINVAL;
 
 	if (atkbd->softraw != value) {
diff --git a/drivers/input/keyboard/lm8323.c b/drivers/input/keyboard/lm8323.c
index f7c2a16..79ca455 100644
--- a/drivers/input/keyboard/lm8323.c
+++ b/drivers/input/keyboard/lm8323.c
@@ -557,15 +557,10 @@ static ssize_t lm8323_pwm_store_time(struct device *dev,
 	struct led_classdev *led_cdev = dev_get_drvdata(dev);
 	struct lm8323_pwm *pwm = cdev_to_pwm(led_cdev);
 	int ret;
-	unsigned long time;
-
-	ret = strict_strtoul(buf, 10, &time);
-	/* Numbers only, please. */
-	if (ret)
-		return -EINVAL;
-
-	pwm->fade_time = time;
 
+	ret = kstrtoint(buf, 10, &pwm->fade_time);
+	if (ret < 0)
+		return ret;
 	return strlen(buf);
 }
 static DEVICE_ATTR(time, 0644, lm8323_pwm_show_time, lm8323_pwm_store_time);
@@ -623,13 +618,14 @@ static ssize_t lm8323_set_disable(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct lm8323_chip *lm = dev_get_drvdata(dev);
+	unsigned int kp_enabled;
 	int ret;
-	unsigned long i;
-
-	ret = strict_strtoul(buf, 10, &i);
 
+	ret = kstrtouint(buf, 10, &kp_enabled);
+	if (ret < 0)
+		return ret;
 	mutex_lock(&lm->lock);
-	lm->kp_enabled = !i;
+	lm->kp_enabled = !kp_enabled;
 	mutex_unlock(&lm->lock);
 
 	return count;
diff --git a/drivers/input/misc/adxl34x.c b/drivers/input/misc/adxl34x.c
index de5900d..03b284a 100644
--- a/drivers/input/misc/adxl34x.c
+++ b/drivers/input/misc/adxl34x.c
@@ -454,8 +454,8 @@ static ssize_t adxl34x_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
-	if (error)
+	error = kstrtoul(buf, 10, &val);
+	if (error < 0)
 		return error;
 
 	mutex_lock(&ac->mutex);
@@ -543,7 +543,7 @@ static ssize_t adxl34x_rate_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -578,7 +578,7 @@ static ssize_t adxl34x_autosleep_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
+	error = kstrtoul(buf, 10, &val);
 	if (error)
 		return error;
 
@@ -622,13 +622,13 @@ static ssize_t adxl34x_write_store(struct device *dev,
 				   const char *buf, size_t count)
 {
 	struct adxl34x *ac = dev_get_drvdata(dev);
-	unsigned long val;
+	u16 val;
 	int error;
 
 	/*
 	 * This allows basic ADXL register write access for debug purposes.
 	 */
-	error = strict_strtoul(buf, 16, &val);
+	error = kstrtou16(buf, 16, &val);
 	if (error)
 		return error;
 
@@ -639,7 +639,7 @@ static ssize_t adxl34x_write_store(struct device *dev,
 	return count;
 }
 
-static DEVICE_ATTR(write, 0664, NULL, adxl34x_write_store);
+static DEVICE_ATTR(write, 0220, NULL, adxl34x_write_store);
 #endif
 
 static struct attribute *adxl34x_attributes[] = {
diff --git a/drivers/input/misc/ati_remote2.c b/drivers/input/misc/ati_remote2.c
index 0b0e9be..3226c9a 100644
--- a/drivers/input/misc/ati_remote2.c
+++ b/drivers/input/misc/ati_remote2.c
@@ -41,14 +41,14 @@ static int ati_remote2_set_mask(const char *val,
 				const struct kernel_param *kp,
 				unsigned int max)
 {
-	unsigned long mask;
+	unsigned int mask;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
 
-	ret = strict_strtoul(val, 0, &mask);
-	if (ret)
+	ret = kstrtouint(val, 0, &mask);
+	if (ret < 0)
 		return ret;
 
 	if (mask & ~max)
@@ -719,20 +719,21 @@ static ssize_t ati_remote2_store_channel_mask(struct device *dev,
 	struct usb_device *udev = to_usb_device(dev);
 	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
-	unsigned long mask;
-	int r;
+	unsigned int mask;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &mask))
-		return -EINVAL;
+	rv = kstrtouint(buf, 0, &mask);
+	if (rv < 0)
+		return rv;
 
 	if (mask & ~ATI_REMOTE2_MAX_CHANNEL_MASK)
 		return -EINVAL;
 
-	r = usb_autopm_get_interface(ar2->intf[0]);
-	if (r) {
+	rv = usb_autopm_get_interface(ar2->intf[0]);
+	if (rv) {
 		dev_err(&ar2->intf[0]->dev,
-			"%s(): usb_autopm_get_interface() = %d\n", __func__, r);
-		return r;
+			"%s(): usb_autopm_get_interface() = %d\n", __func__, rv);
+		return rv;
 	}
 
 	mutex_lock(&ati_remote2_mutex);
@@ -765,10 +766,12 @@ static ssize_t ati_remote2_store_mode_mask(struct device *dev,
 	struct usb_device *udev = to_usb_device(dev);
 	struct usb_interface *intf = usb_ifnum_to_if(udev, 0);
 	struct ati_remote2 *ar2 = usb_get_intfdata(intf);
-	unsigned long mask;
+	unsigned int mask;
+	int rv;
 
-	if (strict_strtoul(buf, 0, &mask))
-		return -EINVAL;
+	rv = kstrtouint(buf, 0, &mask);
+	if (rv < 0)
+		return rv;
 
 	if (mask & ~ATI_REMOTE2_MAX_MODE_MASK)
 		return -EINVAL;
diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 04d9bf3..b3c788b 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -517,16 +517,12 @@ static ssize_t elantech_set_int_attr(struct psmouse *psmouse,
 	struct elantech_data *etd = psmouse->private;
 	struct elantech_attr_data *attr = data;
 	unsigned char *reg = (unsigned char *) etd + attr->field_offset;
-	unsigned long value;
+	u8 value;
 	int err;
 
-	err = strict_strtoul(buf, 16, &value);
-	if (err)
+	err = kstrtou8(buf, 16, &value);
+	if (err < 0)
 		return err;
-
-	if (value > 0xff)
-		return -EINVAL;
-
 	/* Do we need to preserve some bits for version 2 hardware too? */
 	if (etd->hw_version == 1) {
 		if (attr->reg == 0x10)
diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index 95577c1..b98edc7 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -787,11 +787,13 @@ static ssize_t hgpk_set_powered(struct psmouse *psmouse, void *data,
 				const char *buf, size_t count)
 {
 	struct hgpk_data *priv = psmouse->private;
-	unsigned long value;
+	unsigned int value;
 	int err;
 
-	err = strict_strtoul(buf, 10, &value);
-	if (err || value > 1)
+	err = kstrtouint(buf, 10, &value);
+	if (err < 0)
+		return err;
+	if (value > 1)
 		return -EINVAL;
 
 	if (value != priv->powered) {
@@ -879,11 +881,13 @@ static ssize_t hgpk_trigger_recal(struct psmouse *psmouse, void *data,
 				const char *buf, size_t count)
 {
 	struct hgpk_data *priv = psmouse->private;
-	unsigned long value;
+	unsigned int value;
 	int err;
 
-	err = strict_strtoul(buf, 10, &value);
-	if (err || value != 1)
+	err = kstrtouint(buf, 10, &value);
+	if (err < 0)
+		return err;
+	if (value != 1)
 		return -EINVAL;
 
 	/*
@@ -895,7 +899,7 @@ static ssize_t hgpk_trigger_recal(struct psmouse *psmouse, void *data,
 	return count;
 }
 
-__PSMOUSE_DEFINE_ATTR(recalibrate, S_IWUSR | S_IRUGO, NULL,
+__PSMOUSE_DEFINE_ATTR(recalibrate, S_IWUSR, NULL,
 		      hgpk_trigger_recal_show, hgpk_trigger_recal, false);
 
 static void hgpk_disconnect(struct psmouse *psmouse)
diff --git a/drivers/input/mouse/logips2pp.c b/drivers/input/mouse/logips2pp.c
index c9983ae..c977ea9 100644
--- a/drivers/input/mouse/logips2pp.c
+++ b/drivers/input/mouse/logips2pp.c
@@ -155,9 +155,13 @@ static ssize_t ps2pp_attr_show_smartscroll(struct psmouse *psmouse,
 static ssize_t ps2pp_attr_set_smartscroll(struct psmouse *psmouse, void *data,
 					  const char *buf, size_t count)
 {
-	unsigned long value;
+	unsigned int value;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	rv = kstrtouint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
+	if (value > 1)
 		return -EINVAL;
 
 	ps2pp_set_smartscroll(psmouse, value);
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 3f74bae..5438f16 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1546,16 +1546,11 @@ static ssize_t psmouse_show_int_attr(struct psmouse *psmouse, void *offset, char
 static ssize_t psmouse_set_int_attr(struct psmouse *psmouse, void *offset, const char *buf, size_t count)
 {
 	unsigned int *field = (unsigned int *)((char *)psmouse + (size_t)offset);
-	unsigned long value;
-
-	if (strict_strtoul(buf, 10, &value))
-		return -EINVAL;
-
-	if ((unsigned int)value != value)
-		return -EINVAL;
-
-	*field = value;
+	int rv;
 
+	rv = kstrtouint(buf, 10, field);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
@@ -1660,22 +1655,24 @@ static ssize_t psmouse_attr_set_protocol(struct psmouse *psmouse, void *data, co
 
 static ssize_t psmouse_attr_set_rate(struct psmouse *psmouse, void *data, const char *buf, size_t count)
 {
-	unsigned long value;
-
-	if (strict_strtoul(buf, 10, &value))
-		return -EINVAL;
+	unsigned int value;
+	int rv;
 
+	rv = kstrtouint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
 	psmouse->set_rate(psmouse, value);
 	return count;
 }
 
 static ssize_t psmouse_attr_set_resolution(struct psmouse *psmouse, void *data, const char *buf, size_t count)
 {
-	unsigned long value;
-
-	if (strict_strtoul(buf, 10, &value))
-		return -EINVAL;
+	unsigned int value;
+	int rv;
 
+	rv = kstrtouint(buf, 10, &value);
+	if (rv < 0)
+		return rv;
 	psmouse->set_resolution(psmouse, value);
 	return count;
 }
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 1242775..baaa141 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -78,7 +78,7 @@ static unsigned char fsp_test_invert_cmd(unsigned char reg_val)
 	}
 }
 
-static int fsp_reg_read(struct psmouse *psmouse, int reg_addr, int *reg_val)
+static int fsp_reg_read(struct psmouse *psmouse, u8 reg_addr, u8 *reg_val)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[3];
@@ -136,7 +136,7 @@ static int fsp_reg_read(struct psmouse *psmouse, int reg_addr, int *reg_val)
 	return rc;
 }
 
-static int fsp_reg_write(struct psmouse *psmouse, int reg_addr, int reg_val)
+static int fsp_reg_write(struct psmouse *psmouse, u8 reg_addr, u8 reg_val)
 {
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char v;
@@ -190,7 +190,7 @@ static int fsp_reg_write(struct psmouse *psmouse, int reg_addr, int reg_val)
 /* Enable register clock gating for writing certain registers */
 static int fsp_reg_write_enable(struct psmouse *psmouse, bool enable)
 {
-	int v, nv;
+	u8 v, nv;
 
 	if (fsp_reg_read(psmouse, FSP_REG_SYSCTL1, &v) == -1)
 		return -1;
@@ -284,7 +284,7 @@ static int fsp_page_reg_write(struct psmouse *psmouse, int reg_val)
 	return rc;
 }
 
-static int fsp_get_version(struct psmouse *psmouse, int *version)
+static int fsp_get_version(struct psmouse *psmouse, u8 *version)
 {
 	if (fsp_reg_read(psmouse, FSP_REG_VERSION, version))
 		return -EIO;
@@ -292,7 +292,7 @@ static int fsp_get_version(struct psmouse *psmouse, int *version)
 	return 0;
 }
 
-static int fsp_get_revision(struct psmouse *psmouse, int *rev)
+static int fsp_get_revision(struct psmouse *psmouse, u8 *rev)
 {
 	if (fsp_reg_read(psmouse, FSP_REG_REVISION, rev))
 		return -EIO;
@@ -300,7 +300,7 @@ static int fsp_get_revision(struct psmouse *psmouse, int *rev)
 	return 0;
 }
 
-static int fsp_get_buttons(struct psmouse *psmouse, int *btn)
+static int fsp_get_buttons(struct psmouse *psmouse, u8 *btn)
 {
 	static const int buttons[] = {
 		0x16, /* Left/Middle/Right/Forward/Backward & Scroll Up/Down */
@@ -308,7 +308,7 @@ static int fsp_get_buttons(struct psmouse *psmouse, int *btn)
 		0x04, /* Left/Middle/Right & Scroll Up/Down */
 		0x02, /* Left/Middle/Right */
 	};
-	int val;
+	u8 val;
 
 	if (fsp_reg_read(psmouse, FSP_REG_TMOD_STATUS1, &val) == -1)
 		return -EIO;
@@ -320,7 +320,7 @@ static int fsp_get_buttons(struct psmouse *psmouse, int *btn)
 /* Enable on-pad command tag output */
 static int fsp_opc_tag_enable(struct psmouse *psmouse, bool enable)
 {
-	int v, nv;
+	u8 v, nv;
 	int res = 0;
 
 	if (fsp_reg_read(psmouse, FSP_REG_OPC_QDOWN, &v) == -1) {
@@ -352,7 +352,7 @@ static int fsp_opc_tag_enable(struct psmouse *psmouse, bool enable)
 static int fsp_onpad_vscr(struct psmouse *psmouse, bool enable)
 {
 	struct fsp_data *pad = psmouse->private;
-	int val;
+	u8 val;
 
 	if (fsp_reg_read(psmouse, FSP_REG_ONPAD_CTL, &val))
 		return -EIO;
@@ -373,7 +373,7 @@ static int fsp_onpad_vscr(struct psmouse *psmouse, bool enable)
 static int fsp_onpad_hscr(struct psmouse *psmouse, bool enable)
 {
 	struct fsp_data *pad = psmouse->private;
-	int val, v2;
+	u8 val, v2;
 
 	if (fsp_reg_read(psmouse, FSP_REG_ONPAD_CTL, &val))
 		return -EIO;
@@ -409,24 +409,18 @@ static int fsp_onpad_hscr(struct psmouse *psmouse, bool enable)
 static ssize_t fsp_attr_set_setreg(struct psmouse *psmouse, void *data,
 				   const char *buf, size_t count)
 {
-	unsigned long reg, val;
-	char *rest;
-	ssize_t retval;
+	u8 reg, val;
+	int rv;
 
-	reg = simple_strtoul(buf, &rest, 16);
-	if (rest == buf || *rest != ' ' || reg > 0xff)
-		return -EINVAL;
-
-	if (strict_strtoul(rest + 1, 16, &val) || val > 0xff)
+	if (sscanf(buf, "%hhu %hhu", &reg, &val) != 2)
 		return -EINVAL;
 
 	if (fsp_reg_write_enable(psmouse, true))
 		return -EIO;
-
-	retval = fsp_reg_write(psmouse, reg, val) < 0 ? -EIO : count;
-
+	rv = fsp_reg_write(psmouse, reg, val);
 	fsp_reg_write_enable(psmouse, false);
-
+	if (rv < 0)
+		return -EIO;
 	return count;
 }
 
@@ -449,11 +443,12 @@ static ssize_t fsp_attr_set_getreg(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
 	struct fsp_data *pad = psmouse->private;
-	unsigned long reg;
-	int val;
+	u8 reg, val;
+	int rv;
 
-	if (strict_strtoul(buf, 16, &reg) || reg > 0xff)
-		return -EINVAL;
+	rv = kstrtou8(buf, 16, &reg);
+	if (rv < 0)
+		return rv;
 
 	if (fsp_reg_read(psmouse, reg, &val))
 		return -EIO;
@@ -481,10 +476,12 @@ static ssize_t fsp_attr_show_pagereg(struct psmouse *psmouse,
 static ssize_t fsp_attr_set_pagereg(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
-	unsigned long val;
+	u8 val;
+	int rv;
 
-	if (strict_strtoul(buf, 16, &val) || val > 0xff)
-		return -EINVAL;
+	rv = kstrtou8(buf, 16, &val);
+	if (rv < 0)
+		return rv;
 
 	if (fsp_page_reg_write(psmouse, val))
 		return -EIO;
@@ -506,9 +503,13 @@ static ssize_t fsp_attr_show_vscroll(struct psmouse *psmouse,
 static ssize_t fsp_attr_set_vscroll(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
-	unsigned long val;
+	unsigned int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	rv = kstrtouint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val > 1)
 		return -EINVAL;
 
 	fsp_onpad_vscr(psmouse, val);
@@ -530,9 +531,13 @@ static ssize_t fsp_attr_show_hscroll(struct psmouse *psmouse,
 static ssize_t fsp_attr_set_hscroll(struct psmouse *psmouse, void *data,
 					const char *buf, size_t count)
 {
-	unsigned long val;
+	unsigned int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val) || val > 1)
+	rv = kstrtouint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
+	if (val > 1)
 		return -EINVAL;
 
 	fsp_onpad_hscr(psmouse, val);
@@ -704,7 +709,7 @@ static int fsp_activate_protocol(struct psmouse *psmouse)
 	struct fsp_data *pad = psmouse->private;
 	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	unsigned char param[2];
-	int val;
+	u8 val;
 
 	/*
 	 * Standard procedure to enter FSP Intellimouse mode
@@ -761,7 +766,7 @@ static int fsp_activate_protocol(struct psmouse *psmouse)
 
 int fsp_detect(struct psmouse *psmouse, bool set_properties)
 {
-	int id;
+	u8 id;
 
 	if (fsp_reg_read(psmouse, FSP_REG_DEVICE_ID, &id))
 		return -EIO;
@@ -795,7 +800,7 @@ static void fsp_disconnect(struct psmouse *psmouse)
 
 static int fsp_reconnect(struct psmouse *psmouse)
 {
-	int version;
+	u8 version;
 
 	if (fsp_detect(psmouse, 0))
 		return -ENODEV;
@@ -812,7 +817,7 @@ static int fsp_reconnect(struct psmouse *psmouse)
 int fsp_init(struct psmouse *psmouse)
 {
 	struct fsp_data *priv;
-	int ver, rev, buttons;
+	u8 ver, rev, buttons;
 	int error;
 
 	if (fsp_get_version(psmouse, &ver) ||
diff --git a/drivers/input/mouse/sentelic.h b/drivers/input/mouse/sentelic.h
index ed1395a..363df999 100644
--- a/drivers/input/mouse/sentelic.h
+++ b/drivers/input/mouse/sentelic.h
@@ -66,17 +66,17 @@
 #ifdef __KERNEL__
 
 struct fsp_data {
-	unsigned char	ver;		/* hardware version */
-	unsigned char	rev;		/* hardware revison */
-	unsigned char	buttons;	/* Number of buttons */
+	u8		ver;		/* hardware version */
+	u8		rev;		/* hardware revison */
+	u8		buttons;	/* Number of buttons */
 	unsigned int	flags;
 #define	FSPDRV_FLAG_EN_OPC	(0x001)	/* enable on-pad clicking */
 
 	bool		vscroll;	/* Vertical scroll zone enabled */
 	bool		hscroll;	/* Horizontal scroll zone enabled */
 
-	unsigned char	last_reg;	/* Last register we requested read from */
-	unsigned char	last_val;
+	u8		last_reg;	/* Last register we requested read from */
+	u8		last_val;
 };
 
 #ifdef CONFIG_MOUSE_PS2_SENTELIC
diff --git a/drivers/input/mouse/trackpoint.c b/drivers/input/mouse/trackpoint.c
index 54b2fa8..daf74c4 100644
--- a/drivers/input/mouse/trackpoint.c
+++ b/drivers/input/mouse/trackpoint.c
@@ -89,13 +89,12 @@ static ssize_t trackpoint_set_int_attr(struct psmouse *psmouse, void *data,
 	struct trackpoint_data *tp = psmouse->private;
 	struct trackpoint_attr_data *attr = data;
 	unsigned char *field = (unsigned char *)((char *)tp + attr->field_offset);
-	unsigned long value;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &value) || value > 255)
-		return -EINVAL;
-
-	*field = value;
-	trackpoint_write(&psmouse->ps2dev, attr->command, value);
+	rv = kstrtou8(buf, 10, field);
+	if (rv < 0)
+		return rv;
+	trackpoint_write(&psmouse->ps2dev, attr->command, *field);
 
 	return count;
 }
@@ -115,9 +114,13 @@ static ssize_t trackpoint_set_bit_attr(struct psmouse *psmouse, void *data,
 	struct trackpoint_data *tp = psmouse->private;
 	struct trackpoint_attr_data *attr = data;
 	unsigned char *field = (unsigned char *)((char *)tp + attr->field_offset);
-	unsigned long value;
+	u8 value;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &value) || value > 1)
+	rv = kstrtou8(buf, 10, &value);
+	if (rv < 0)
+		return rv;
+	if (value > 1)
 		return -EINVAL;
 
 	if (attr->inverted)
diff --git a/drivers/input/tablet/aiptek.c b/drivers/input/tablet/aiptek.c
index 0a619c5..6fb2ac2 100644
--- a/drivers/input/tablet/aiptek.c
+++ b/drivers/input/tablet/aiptek.c
@@ -1199,9 +1199,9 @@ static ssize_t
 store_tabletXtilt(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long x;
+	int x;
 
-	if (strict_strtol(buf, 10, &x)) {
+	if (kstrtoint(buf, 10, &x)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
 		if (strncmp(buf, "disable", len))
@@ -1241,9 +1241,9 @@ static ssize_t
 store_tabletYtilt(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long y;
+	int y;
 
-	if (strict_strtol(buf, 10, &y)) {
+	if (kstrtoint(buf, 10, &y)) {
 		size_t len = buf[count - 1] == '\n' ? count - 1 : count;
 
 		if (strncmp(buf, "disable", len))
@@ -1278,12 +1278,11 @@ static ssize_t
 store_tabletJitterDelay(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long j;
+	int rv;
 
-	if (strict_strtol(buf, 10, &j))
-		return -EINVAL;
-
-	aiptek->newSetting.jitterDelay = (int)j;
+	rv = kstrtoint(buf, 10, &aiptek->newSetting.jitterDelay);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
@@ -1307,12 +1306,11 @@ static ssize_t
 store_tabletProgrammableDelay(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long d;
+	int rv;
 
-	if (strict_strtol(buf, 10, &d))
-		return -EINVAL;
-
-	aiptek->newSetting.programmableDelay = (int)d;
+	rv = kstrtoint(buf, 10, &aiptek->newSetting.programmableDelay);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
@@ -1558,11 +1556,11 @@ static ssize_t
 store_tabletWheel(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct aiptek *aiptek = dev_get_drvdata(dev);
-	long w;
-
-	if (strict_strtol(buf, 10, &w)) return -EINVAL;
+	int rv;
 
-	aiptek->newSetting.wheel = (int)w;
+	rv = kstrtoint(buf, 10, &aiptek->newSetting.wheel);
+	if (rv < 0)
+		return rv;
 	return count;
 }
 
diff --git a/drivers/input/touchscreen/ad7877.c b/drivers/input/touchscreen/ad7877.c
index a1952fc..dac8711 100644
--- a/drivers/input/touchscreen/ad7877.c
+++ b/drivers/input/touchscreen/ad7877.c
@@ -489,8 +489,8 @@ static ssize_t ad7877_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
-	if (error)
+	error = kstrtoul(buf, 10, &val);
+	if (error < 0)
 		return error;
 
 	if (val)
@@ -519,8 +519,8 @@ static ssize_t ad7877_dac_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
-	if (error)
+	error = kstrtoul(buf, 10, &val);
+	if (error < 0)
 		return error;
 
 	mutex_lock(&ts->mutex);
@@ -549,8 +549,8 @@ static ssize_t ad7877_gpio3_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
-	if (error)
+	error = kstrtoul(buf, 10, &val);
+	if (error < 0)
 		return error;
 
 	mutex_lock(&ts->mutex);
@@ -580,8 +580,8 @@ static ssize_t ad7877_gpio4_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
-	if (error)
+	error = kstrtoul(buf, 10, &val);
+	if (error < 0)
 		return error;
 
 	mutex_lock(&ts->mutex);
diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index bc3b518..d3e0b9c 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -340,8 +340,8 @@ static ssize_t ad7879_disable_store(struct device *dev,
 	unsigned long val;
 	int error;
 
-	error = strict_strtoul(buf, 10, &val);
-	if (error)
+	error = kstrtoul(buf, 10, &val);
+	if (error < 0)
 		return error;
 
 	ad7879_toggle(ts, val);
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index 14ea54b..3a02113 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -590,9 +590,11 @@ static ssize_t ads7846_disable_store(struct device *dev,
 {
 	struct ads7846 *ts = dev_get_drvdata(dev);
 	unsigned long i;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &i))
-		return -EINVAL;
+	rv = kstrtoul(buf, 10, &i);
+	if (rv < 0)
+		return rv;
 
 	if (i)
 		ads7846_disable(ts);
-- 
1.7.3.4

