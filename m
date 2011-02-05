Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab1BEOWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab1BEOWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tH4KLMp7JvkS2JR40lJr9rNi7w1h+CbLhRYAMyxqLaYoAg/f2hOFOuYrB7HoMxSBvX
         fBFf/VkNS3naZ+dMVpJfed0BYkQABzue/U96eWBuEGIFEvmc5xt8GDWpLNUzqbDsNy0T
         saPS5AdtOCBt0CaBWyihZF/pQL8YoGnD7UumI=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 41/52] kstrtox: convert drivers/video/
Date: Sat,  5 Feb 2011 16:20:44 +0200
Message-Id: <1296915654-7458-41-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/video/backlight/adp5520_bl.c               |   13 +-
 drivers/video/backlight/adp8860_bl.c               |   12 +-
 drivers/video/backlight/backlight.c                |    4 +-
 drivers/video/backlight/s6e63m0.c                  |    2 +-
 drivers/video/fsl-diu-fb.c                         |   36 +++--
 .../video/omap2/displays/panel-tpo-td043mtea1.c    |   10 +-
 drivers/video/omap2/dss/display.c                  |   16 +-
 drivers/video/via/viafbdev.c                       |  155 ++++++++++++--------
 drivers/video/wm8505fb.c                           |    2 +-
 9 files changed, 152 insertions(+), 98 deletions(-)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index 9f436e0..497d0a7 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -18,7 +18,7 @@ struct adp5520_bl {
 	struct device *master;
 	struct adp5520_backlight_platform_data *pdata;
 	struct mutex lock;
-	unsigned long cached_daylight_max;
+	u8 cached_daylight_max;
 	int id;
 	int current_brightness;
 };
@@ -156,11 +156,11 @@ static ssize_t adp5520_store(struct device *dev, const char *buf,
 			 size_t count, int reg)
 {
 	struct adp5520_bl *data = dev_get_drvdata(dev);
-	unsigned long val;
+	u8 val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
-	if (ret)
+	ret = kstrtou8(buf, 10, &val);
+	if (ret < 0)
 		return ret;
 
 	mutex_lock(&data->lock);
@@ -211,8 +211,11 @@ static ssize_t adp5520_bl_daylight_max_store(struct device *dev,
 			const char *buf, size_t count)
 {
 	struct adp5520_bl *data = dev_get_drvdata(dev);
+	int rv;
 
-	strict_strtoul(buf, 10, &data->cached_daylight_max);
+	rv = kstrtou8(buf, 10, &data->cached_daylight_max);
+	if (rv < 0)
+		return rv;
 	return adp5520_store(dev, buf, count, ADP5520_DAYLIGHT_MAX);
 }
 static DEVICE_ATTR(daylight_max, 0664, adp5520_bl_daylight_max_show,
diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index 734c650..6cfbb5f 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -110,7 +110,7 @@ struct adp8860_bl {
 	struct adp8860_led *led;
 	struct adp8860_backlight_platform_data *pdata;
 	struct mutex lock;
-	unsigned long cached_daylight_max;
+	u8 cached_daylight_max;
 	int id;
 	int revid;
 	int current_brightness;
@@ -449,10 +449,10 @@ static ssize_t adp8860_store(struct device *dev, const char *buf,
 			 size_t count, int reg)
 {
 	struct adp8860_bl *data = dev_get_drvdata(dev);
-	unsigned long val;
+	u8 val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtou8(buf, 10, &val);
 	if (ret)
 		return ret;
 
@@ -502,7 +502,9 @@ static ssize_t adp8860_bl_l1_daylight_max_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct adp8860_bl *data = dev_get_drvdata(dev);
-	int ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	int ret;
+
+	ret = kstrtou8(buf, 10, &data->cached_daylight_max);
 	if (ret)
 		return ret;
 
@@ -609,7 +611,7 @@ static ssize_t adp8860_bl_ambient_light_zone_store(struct device *dev,
 	uint8_t reg_val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 0870329..e6cd673 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -110,7 +110,7 @@ static ssize_t backlight_store_power(struct device *dev,
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long power;
 
-	rc = strict_strtoul(buf, 0, &power);
+	rc = kstrtoul(buf, 0, &power);
 	if (rc)
 		return rc;
 
@@ -144,7 +144,7 @@ static ssize_t backlight_store_brightness(struct device *dev,
 	struct backlight_device *bd = to_backlight_device(dev);
 	unsigned long brightness;
 
-	rc = strict_strtoul(buf, 0, &brightness);
+	rc = kstrtoul(buf, 0, &brightness);
 	if (rc)
 		return rc;
 
diff --git a/drivers/video/backlight/s6e63m0.c b/drivers/video/backlight/s6e63m0.c
index 5927db0..8bbbc4a 100644
--- a/drivers/video/backlight/s6e63m0.c
+++ b/drivers/video/backlight/s6e63m0.c
@@ -689,7 +689,7 @@ static ssize_t s6e63m0_sysfs_store_gamma_mode(struct device *dev,
 	struct backlight_device *bd = NULL;
 	int brightness, rc;
 
-	rc = strict_strtoul(buf, 0, (unsigned long *)&lcd->gamma_mode);
+	rc = kstrtouint(buf, 0, &lcd->gamma_mode);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/video/fsl-diu-fb.c b/drivers/video/fsl-diu-fb.c
index 8bbbf08..88ffbac 100644
--- a/drivers/video/fsl-diu-fb.c
+++ b/drivers/video/fsl-diu-fb.c
@@ -182,7 +182,7 @@ static struct fb_videomode __devinitdata fsl_diu_mode_db[] = {
 };
 
 static char *fb_mode = "1024x768-32@60";
-static unsigned long default_bpp = 32;
+static unsigned int default_bpp = 32;
 static int monitor_port;
 
 #if defined(CONFIG_NOT_COHERENT_CACHE)
@@ -1455,13 +1455,15 @@ static void free_buf(struct device *dev, struct diu_addr *buf, u32 size,
 static ssize_t store_monitor(struct device *device,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
-	int old_monitor_port;
-	unsigned long val;
 	struct fsl_diu_data *machine_data =
 		container_of(attr, struct fsl_diu_data, dev_attr);
+	int old_monitor_port;
+	int val;
+	int rv;
 
-	if (strict_strtoul(buf, 10, &val))
-		return 0;
+	rv = kstrtoint(buf, 10, &val);
+	if (rv < 0)
+		return rv;
 
 	old_monitor_port = machine_data->monitor_port;
 	machine_data->monitor_port = diu_ops.set_sysfs_monitor_port(val);
@@ -1700,20 +1702,28 @@ static int fsl_diu_remove(struct platform_device *ofdev)
 static int __init fsl_diu_setup(char *options)
 {
 	char *opt;
-	unsigned long val;
 
 	if (!options || !*options)
 		return 0;
 
 	while ((opt = strsep(&options, ",")) != NULL) {
+		int rv;
+
 		if (!*opt)
 			continue;
 		if (!strncmp(opt, "monitor=", 8)) {
-			if (!strict_strtoul(opt + 8, 10, &val) && (val <= 2))
-				monitor_port = val;
+			int val;
+
+			rv = kstrtoint(opt + 8, 10, &val);
+			if (rv < 0)
+				return rv;
+			if (val < 0 || val > 2)
+				return -EINVAL;
+			monitor_port = val;
 		} else if (!strncmp(opt, "bpp=", 4)) {
-			if (!strict_strtoul(opt + 4, 10, &val))
-				default_bpp = val;
+			rv = kstrtouint(opt + 4, 10, &default_bpp);
+			if (rv < 0)
+				return rv;
 		} else
 			fb_mode = opt;
 	}
@@ -1762,7 +1772,9 @@ static int __init fsl_diu_init(void)
 	 */
 	if (fb_get_options("fslfb", &option))
 		return -ENODEV;
-	fsl_diu_setup(option);
+	ret = fsl_diu_setup(option);
+	if (ret < 0)
+		return ret;
 #endif
 	printk(KERN_INFO "Freescale DIU driver\n");
 
@@ -1827,7 +1839,7 @@ MODULE_LICENSE("GPL");
 module_param_named(mode, fb_mode, charp, 0);
 MODULE_PARM_DESC(mode,
 	"Specify resolution as \"<xres>x<yres>[-<bpp>][@<refresh>]\" ");
-module_param_named(bpp, default_bpp, ulong, 0);
+module_param_named(bpp, default_bpp, uint, 0);
 MODULE_PARM_DESC(bpp, "Specify bit-per-pixel if not specified mode");
 module_param_named(monitor, monitor_port, int, 0);
 MODULE_PARM_DESC(monitor,
diff --git a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
index dbe9d43..77a363b 100644
--- a/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
+++ b/drivers/video/omap2/displays/panel-tpo-td043mtea1.c
@@ -147,7 +147,7 @@ static ssize_t tpo_td043_vmirror_store(struct device *dev,
 	long val;
 	int ret;
 
-	ret = strict_strtol(buf, 0, &val);
+	ret = kstrtol(buf, 0, &val);
 	if (ret < 0)
 		return ret;
 
@@ -172,11 +172,13 @@ static ssize_t tpo_td043_mode_store(struct device *dev,
 	struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct tpo_td043_device *tpo_td043 = dev_get_drvdata(dev);
-	long val;
+	u8 val;
 	int ret;
 
-	ret = strict_strtol(buf, 0, &val);
-	if (ret != 0 || val & ~7)
+	ret = kstrtou8(buf, 0, &val);
+	if (ret < 0)
+		return ret;
+	if (val & ~7)
 		return -EINVAL;
 
 	tpo_td043->mode = val;
diff --git a/drivers/video/omap2/dss/display.c b/drivers/video/omap2/dss/display.c
index 22dd7a4..413b618 100644
--- a/drivers/video/omap2/dss/display.c
+++ b/drivers/video/omap2/dss/display.c
@@ -262,21 +262,21 @@ static ssize_t display_wss_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t size)
 {
 	struct omap_dss_device *dssdev = to_dss_device(dev);
-	unsigned long wss;
-	int r;
+	u32 wss;
+	int rv;
 
 	if (!dssdev->driver->get_wss || !dssdev->driver->set_wss)
 		return -ENOENT;
 
-	if (strict_strtoul(buf, 0, &wss))
-		return -EINVAL;
-
+	rv = kstrtou32(buf, 0, &wss);
+	if (rv < 0)
+		return rv;
 	if (wss > 0xfffff)
 		return -EINVAL;
 
-	r = dssdev->driver->set_wss(dssdev, wss);
-	if (r)
-		return r;
+	rv = dssdev->driver->set_wss(dssdev, wss);
+	if (rv)
+		return rv;
 
 	return size;
 }
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 4e66349..58a3765 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1129,7 +1129,6 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
-	u8 reg_val = 0;
 	unsigned long length, i;
 	if (count < 1)
 		return -EINVAL;
@@ -1141,7 +1140,12 @@ static ssize_t viafb_dvp0_proc_write(struct file *file,
 	for (i = 0; i < 3; i++) {
 		value = strsep(&pbuf, " ");
 		if (value != NULL) {
-			strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			u8 reg_val;
+			int rv;
+
+			rv = kstrtou8(value, 0, &reg_val);
+			if (rv < 0)
+				return rv;
 			DEBUG_MSG(KERN_INFO "DVP0:reg_val[%l]=:%x\n", i,
 				  reg_val);
 			switch (i) {
@@ -1199,7 +1203,6 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20], *value, *pbuf;
-	u8 reg_val = 0;
 	unsigned long length, i;
 	if (count < 1)
 		return -EINVAL;
@@ -1211,7 +1214,10 @@ static ssize_t viafb_dvp1_proc_write(struct file *file,
 	for (i = 0; i < 3; i++) {
 		value = strsep(&pbuf, " ");
 		if (value != NULL) {
-			strict_strtoul(value, 0, (unsigned long *)&reg_val);
+			u8 reg_val;
+			int rv;
+
+			rv = kstrtou8(value, 0, &reg_val);
 			switch (i) {
 			case 0:
 				viafb_write_reg_mask(CR9B, VIACR,
@@ -1261,15 +1267,19 @@ static ssize_t viafb_dfph_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20];
-	u8 reg_val = 0;
+	u8 reg_val;
 	unsigned long length;
+	int rv;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
 	if (copy_from_user(&buf[0], buffer, length))
 		return -EFAULT;
 	buf[length - 1] = '\0';	/*Ensure end string */
-	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	rv = kstrtou8(&buf[0], 0, &reg_val);
+	if (rv < 0)
+		return rv;
 	viafb_write_reg_mask(CR97, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1300,15 +1310,19 @@ static ssize_t viafb_dfpl_proc_write(struct file *file,
 	const char __user *buffer, size_t count, loff_t *pos)
 {
 	char buf[20];
-	u8 reg_val = 0;
+	u8 reg_val;
 	unsigned long length;
+	int rv;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 20 ? 20 : count;
 	if (copy_from_user(&buf[0], buffer, length))
 		return -EFAULT;
 	buf[length - 1] = '\0';	/*Ensure end string */
-	strict_strtoul(&buf[0], 0, (unsigned long *)&reg_val);
+	rv = kstrtou8(&buf[0], 0, &reg_val);
+	if (rv < 0)
+		return rv;
 	viafb_write_reg_mask(CR99, VIACR, reg_val, 0x0f);
 	return count;
 }
@@ -1365,6 +1379,8 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 	char buf[30], *value, *pbuf;
 	struct IODATA reg_val;
 	unsigned long length, i;
+	int rv;
+
 	if (count < 1)
 		return -EINVAL;
 	length = count > 30 ? 30 : count;
@@ -1377,8 +1393,9 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 		for (i = 0; i < 2; i++) {
 			value = strsep(&pbuf, " ");
 			if (value != NULL) {
-				strict_strtoul(value, 0,
-					(unsigned long *)&reg_val.Data);
+				rv = kstrtou8(value, 0, &reg_val.Data);
+				if (rv < 0)
+					return rv;
 				switch (i) {
 				case 0:
 					reg_val.Index = 0x08;
@@ -1414,8 +1431,9 @@ static ssize_t viafb_vt1636_proc_write(struct file *file,
 		for (i = 0; i < 2; i++) {
 			value = strsep(&pbuf, " ");
 			if (value != NULL) {
-				strict_strtoul(value, 0,
-					(unsigned long *)&reg_val.Data);
+				rv = kstrtou8(value, 0, &reg_val.Data);
+				if (rv < 0)
+					return rv;
 				switch (i) {
 				case 0:
 					reg_val.Index = 0x08;
@@ -1936,6 +1954,8 @@ static int __init viafb_setup(char *options)
 		return 0;
 
 	while ((this_opt = strsep(&options, ",")) != NULL) {
+		int rv;
+
 		if (!*this_opt)
 			continue;
 
@@ -1943,54 +1963,65 @@ static int __init viafb_setup(char *options)
 			viafb_mode1 = kstrdup(this_opt + 12, GFP_KERNEL);
 		else if (!strncmp(this_opt, "viafb_mode=", 11))
 			viafb_mode = kstrdup(this_opt + 11, GFP_KERNEL);
-		else if (!strncmp(this_opt, "viafb_bpp1=", 11))
-			strict_strtoul(this_opt + 11, 0,
-				(unsigned long *)&viafb_bpp1);
-		else if (!strncmp(this_opt, "viafb_bpp=", 10))
-			strict_strtoul(this_opt + 10, 0,
-				(unsigned long *)&viafb_bpp);
-		else if (!strncmp(this_opt, "viafb_refresh1=", 15))
-			strict_strtoul(this_opt + 15, 0,
-				(unsigned long *)&viafb_refresh1);
-		else if (!strncmp(this_opt, "viafb_refresh=", 14))
-			strict_strtoul(this_opt + 14, 0,
-				(unsigned long *)&viafb_refresh);
-		else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21))
-			strict_strtoul(this_opt + 21, 0,
-				(unsigned long *)&viafb_lcd_dsp_method);
-		else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19))
-			strict_strtoul(this_opt + 19, 0,
-				(unsigned long *)&viafb_lcd_panel_id);
-		else if (!strncmp(this_opt, "viafb_accel=", 12))
-			strict_strtoul(this_opt + 12, 0,
-				(unsigned long *)&viafb_accel);
-		else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14))
-			strict_strtoul(this_opt + 14, 0,
-				(unsigned long *)&viafb_SAMM_ON);
-		else if (!strncmp(this_opt, "viafb_active_dev=", 17))
+		else if (!strncmp(this_opt, "viafb_bpp1=", 11)) {
+			rv = kstrtoint(this_opt + 11, 0, &viafb_bpp1);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_bpp=", 10)) {
+			rv = kstrtoint(this_opt + 10, 0, &viafb_bpp);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_refresh1=", 15)) {
+			rv = kstrtoint(this_opt + 15, 0, &viafb_refresh1);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_refresh=", 14)) {
+			rv = kstrtoint(this_opt + 14, 0, &viafb_refresh);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_lcd_dsp_method=", 21)) {
+			rv = kstrtoint(this_opt + 21, 0, &viafb_lcd_dsp_method);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_lcd_panel_id=", 19)) {
+			rv = kstrtoint(this_opt + 19, 0, &viafb_lcd_panel_id);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_accel=", 12)) {
+			rv = kstrtoint(this_opt + 12, 0, &viafb_accel);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_SAMM_ON=", 14)) {
+			rv = kstrtoint(this_opt + 14, 0, &viafb_SAMM_ON);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_active_dev=", 17))
 			viafb_active_dev = kstrdup(this_opt + 17, GFP_KERNEL);
-		else if (!strncmp(this_opt,
-			"viafb_display_hardware_layout=", 30))
-			strict_strtoul(this_opt + 30, 0,
-			(unsigned long *)&viafb_display_hardware_layout);
-		else if (!strncmp(this_opt, "viafb_second_size=", 18))
-			strict_strtoul(this_opt + 18, 0,
-				(unsigned long *)&viafb_second_size);
-		else if (!strncmp(this_opt,
-			"viafb_platform_epia_dvi=", 24))
-			strict_strtoul(this_opt + 24, 0,
-				(unsigned long *)&viafb_platform_epia_dvi);
-		else if (!strncmp(this_opt,
-			"viafb_device_lcd_dualedge=", 26))
-			strict_strtoul(this_opt + 26, 0,
-				(unsigned long *)&viafb_device_lcd_dualedge);
-		else if (!strncmp(this_opt, "viafb_bus_width=", 16))
-			strict_strtoul(this_opt + 16, 0,
-				(unsigned long *)&viafb_bus_width);
-		else if (!strncmp(this_opt, "viafb_lcd_mode=", 15))
-			strict_strtoul(this_opt + 15, 0,
-				(unsigned long *)&viafb_lcd_mode);
-		else if (!strncmp(this_opt, "viafb_lcd_port=", 15))
+		else if (!strncmp(this_opt, "viafb_display_hardware_layout=", 30)) {
+			rv = kstrtoint(this_opt + 30, 0, &viafb_display_hardware_layout);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_second_size=", 18)) {
+			rv = kstrtoint(this_opt + 18, 0, &viafb_second_size);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_platform_epia_dvi=", 24)) {
+			rv = kstrtoint(this_opt + 24, 0, &viafb_platform_epia_dvi);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_device_lcd_dualedge=", 26)) {
+			rv = kstrtoint(this_opt + 26, 0, &viafb_device_lcd_dualedge);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_bus_width=", 16)) {
+			rv = kstrtoint(this_opt + 16, 0, &viafb_bus_width);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_lcd_mode=", 15)) {
+			rv = kstrtoint(this_opt + 15, 0, &viafb_lcd_mode);
+			if (rv < 0)
+				return rv;
+		} else if (!strncmp(this_opt, "viafb_lcd_port=", 15))
 			viafb_lcd_port = kstrdup(this_opt + 15, GFP_KERNEL);
 		else if (!strncmp(this_opt, "viafb_dvi_port=", 15))
 			viafb_dvi_port = kstrdup(this_opt + 15, GFP_KERNEL);
@@ -2007,9 +2038,13 @@ int __init viafb_init(void)
 	u32 dummy;
 #ifndef MODULE
 	char *option = NULL;
+	int rv;
+
 	if (fb_get_options("viafb", &option))
 		return -ENODEV;
-	viafb_setup(option);
+	rv = viafb_setup(option);
+	if (rv < 0)
+		return rv;
 #endif
 	if (parse_mode(viafb_mode, &dummy, &dummy)
 		|| parse_mode(viafb_mode1, &dummy, &dummy)
diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 96e34a5..09f95ec 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -154,7 +154,7 @@ static ssize_t contrast_store(struct device *dev,
 	struct wm8505fb_info *fbi = to_wm8505fb_info(info);
 	unsigned long tmp;
 
-	if (strict_strtoul(buf, 10, &tmp) || (tmp > 0xff))
+	if (kstrtoul(buf, 10, &tmp) || (tmp > 0xff))
 		return -EINVAL;
 	fbi->contrast = tmp;
 
-- 
1.7.3.4

