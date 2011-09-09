Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1IIFDH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 01:03:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:53871 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab1IIFDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 01:03:03 -0400
X-AuditID: cbfee61b-b7b7fae000005864-66-4e699e04512d
From: Inki Dae <inki.dae@samsung.com>
To: FlorianSchandinat@gmx.de, linux-fbdev@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, Inki Dae <inki.dae@samsung.com>
Subject: [PATCH] FB: add early fb blank feature.
Date: Fri, 09 Sep 2011 14:03:01 +0900
Message-id: <1315544581-16379-1-git-send-email-inki.dae@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 09 Sep 2011 05:03:33.0818 (UTC)
 FILETIME=[D32C11A0:01CC6EAD]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch adds early fb blank feature that this is a callback of
lcd panel driver would be called prior to fb driver's one.
in case of MIPI-DSI based video mode LCD Panel, for lcd power off,
the power off commands should be transferred to lcd panel with display
and mipi-dsi controller enabled because the commands is set to lcd panel
at vsync porch period. on the other hand, in opposite case, the callback
of fb driver should be called prior to lcd panel driver's one because of
same issue. now we could handle call order to fb blank properly.

the order is as the following:

at fb_blank function of fbmem.c
  -> fb_early_notifier_call_chain()
     -> lcd panel driver's early_set_power()
  -> info->fbops->fb_blank()
     -> fb driver's fb_blank()
  -> fb_notifier_call_chain()
     -> lcd panel driver's set_power()

note that early fb blank mode is valid only if lcd_ops->early_blank_mode is 1.
if the value is 0 then early fb blank callback would be ignored.

this patch is based on git repository below:
git://github.com/schandinat/linux-2.6.git
branch: fbdev-next
commit-id: a67472ad1ae040f073e45048cbc5a01195f2e3f5

Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
---
 drivers/video/backlight/lcd.c |   77 ++++++++++++++++++++++++++++++++++++++--
 drivers/video/fb_notify.c     |   31 ++++++++++++++++
 drivers/video/fbmem.c         |   25 +++++++------
 include/linux/fb.h            |    4 ++
 include/linux/lcd.h           |   61 ++++++++++++++++++++++++--------
 5 files changed, 167 insertions(+), 31 deletions(-)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 71a11ca..066d2bf 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -17,6 +17,37 @@
 
 #if defined(CONFIG_FB) || (defined(CONFIG_FB_MODULE) && \
 			   defined(CONFIG_LCD_CLASS_DEVICE_MODULE))
+/* This callback gets called prior to framebuffer's one
+ * when something important happens inside a framebuffer driver.
+ * We're looking if that important event is blanking,
+ * and if it is, we're switching lcd power as well ...
+ */
+static int fb_notifier_early_callback(struct notifier_block *self,
+				 unsigned long event, void *data)
+{
+	struct lcd_device *ld;
+	struct fb_event *evdata = data;
+
+	/* skip all events except FB_EVENT_BLANK. */
+	if (event != FB_EVENT_BLANK)
+		return 0;
+
+	ld = container_of(self, struct lcd_device, fb_early_notif);
+	if (!ld->ops)
+		return 0;
+
+	mutex_lock(&ld->ops_lock);
+	if (!ld->ops->check_fb || ld->ops->check_fb(ld, evdata->info)) {
+		if (event == FB_EVENT_BLANK) {
+			if (ld->ops->early_set_power)
+				ld->ops->early_set_power(ld,
+						*(int *)evdata->data);
+		}
+	}
+	mutex_unlock(&ld->ops_lock);
+	return 0;
+}
+
 /* This callback gets called when something important happens inside a
  * framebuffer driver. We're looking if that important event is blanking,
  * and if it is, we're switching lcd power as well ...
@@ -55,6 +86,13 @@ static int fb_notifier_callback(struct notifier_block *self,
 	return 0;
 }
 
+static int lcd_register_early_fb(struct lcd_device *ld)
+{
+	memset(&ld->fb_early_notif, 0, sizeof(ld->fb_early_notif));
+	ld->fb_early_notif.notifier_call = fb_notifier_early_callback;
+	return fb_register_early_client(&ld->fb_early_notif);
+}
+
 static int lcd_register_fb(struct lcd_device *ld)
 {
 	memset(&ld->fb_notif, 0, sizeof(ld->fb_notif));
@@ -66,12 +104,26 @@ static void lcd_unregister_fb(struct lcd_device *ld)
 {
 	fb_unregister_client(&ld->fb_notif);
 }
+
+static void lcd_unregister_early_fb(struct lcd_device *ld)
+{
+	fb_unregister_early_client(&ld->fb_notif);
+}
 #else
+static int lcd_register_early_fb(struct lcd_device *ld)
+{
+	return 0;
+}
+
 static int lcd_register_fb(struct lcd_device *ld)
 {
 	return 0;
 }
 
+static inline void lcd_unregister_early_fb(struct lcd_device *ld)
+{
+}
+
 static inline void lcd_unregister_fb(struct lcd_device *ld)
 {
 }
@@ -218,15 +270,30 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
 		return ERR_PTR(rc);
 	}
 
-	rc = lcd_register_fb(new_ld);
-	if (rc) {
-		device_unregister(&new_ld->dev);
-		return ERR_PTR(rc);
+	if (ops->early_blank_mode) {
+		rc = lcd_register_early_fb(new_ld);
+		if (rc)
+			goto err_early_register;
 	}
 
+	rc = lcd_register_fb(new_ld);
+	if (rc)
+		goto err_register;
+
 	new_ld->ops = ops;
 
 	return new_ld;
+
+err_register:
+	if (ops->early_blank_mode)
+		lcd_unregister_early_fb(new_ld);
+
+err_early_register:
+	device_unregister(&new_ld->dev);
+	kfree(new_ld);
+
+	return ERR_PTR(rc);
+
 }
 EXPORT_SYMBOL(lcd_device_register);
 
@@ -242,6 +309,8 @@ void lcd_device_unregister(struct lcd_device *ld)
 		return;
 
 	mutex_lock(&ld->ops_lock);
+	if (ld->ops->early_blank_mode)
+		lcd_unregister_early_fb(ld);
 	ld->ops = NULL;
 	mutex_unlock(&ld->ops_lock);
 	lcd_unregister_fb(ld);
diff --git a/drivers/video/fb_notify.c b/drivers/video/fb_notify.c
index 8c02038..3930c7c 100644
--- a/drivers/video/fb_notify.c
+++ b/drivers/video/fb_notify.c
@@ -13,9 +13,20 @@
 #include <linux/fb.h>
 #include <linux/notifier.h>
 
+static BLOCKING_NOTIFIER_HEAD(fb_early_notifier_list);
 static BLOCKING_NOTIFIER_HEAD(fb_notifier_list);
 
 /**
+ *	fb_register_early_client - register a client early notifier
+ *	@nb: notifier block to callback on events
+ */
+int fb_register_early_client(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&fb_early_notifier_list, nb);
+}
+EXPORT_SYMBOL(fb_register_early_client);
+
+/**
  *	fb_register_client - register a client notifier
  *	@nb: notifier block to callback on events
  */
@@ -26,6 +37,16 @@ int fb_register_client(struct notifier_block *nb)
 EXPORT_SYMBOL(fb_register_client);
 
 /**
+ *	fb_unregister_early_client - unregister a client early notifier
+ *	@nb: notifier block to callback on events
+ */
+int fb_unregister_early_client(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&fb_early_notifier_list, nb);
+}
+EXPORT_SYMBOL(fb_unregister_early_client);
+
+/**
  *	fb_unregister_client - unregister a client notifier
  *	@nb: notifier block to callback on events
  */
@@ -36,6 +57,16 @@ int fb_unregister_client(struct notifier_block *nb)
 EXPORT_SYMBOL(fb_unregister_client);
 
 /**
+ * fb_early_notifier_call_chain - early notify clients of fb_events
+ *
+ */
+int fb_early_notifier_call_chain(unsigned long val, void *v)
+{
+	return blocking_notifier_call_chain(&fb_early_notifier_list, val, v);
+}
+EXPORT_SYMBOL_GPL(fb_early_notifier_call_chain);
+
+/**
  * fb_notifier_call_chain - notify clients of fb_events
  *
  */
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index ad93629..cf22516 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1031,24 +1031,25 @@ fb_set_var(struct fb_info *info, struct fb_var_screeninfo *var)
 
 int
 fb_blank(struct fb_info *info, int blank)
-{	
- 	int ret = -EINVAL;
+{
+	struct fb_event event;
+	int ret = -EINVAL;
 
- 	if (blank > FB_BLANK_POWERDOWN)
- 		blank = FB_BLANK_POWERDOWN;
+	if (blank > FB_BLANK_POWERDOWN)
+		blank = FB_BLANK_POWERDOWN;
 
-	if (info->fbops->fb_blank)
- 		ret = info->fbops->fb_blank(blank, info);
+	event.info = info;
+	event.data = &blank;
 
- 	if (!ret) {
-		struct fb_event event;
+	fb_early_notifier_call_chain(FB_EVENT_BLANK, &event);
 
-		event.info = info;
-		event.data = &blank;
+	if (info->fbops->fb_blank)
+		ret = info->fbops->fb_blank(blank, info);
+
+	if (!ret)
 		fb_notifier_call_chain(FB_EVENT_BLANK, &event);
-	}
 
- 	return ret;
+	return ret;
 }
 
 static long do_fb_ioctl(struct fb_info *info, unsigned int cmd,
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 1d6836c..1d7d995 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -562,6 +562,10 @@ struct fb_blit_caps {
 	u32 flags;
 };
 
+extern int fb_register_early_client(struct notifier_block *nb);
+extern int fb_unregister_early_client(struct notifier_block *nb);
+extern int fb_early_notifier_call_chain(unsigned long val, void *v);
+
 extern int fb_register_client(struct notifier_block *nb);
 extern int fb_unregister_client(struct notifier_block *nb);
 extern int fb_notifier_call_chain(unsigned long val, void *v);
diff --git a/include/linux/lcd.h b/include/linux/lcd.h
index 8877123..930d1cc 100644
--- a/include/linux/lcd.h
+++ b/include/linux/lcd.h
@@ -37,10 +37,21 @@ struct lcd_properties {
 };
 
 struct lcd_ops {
-	/* Get the LCD panel power status (0: full on, 1..3: controller
-	   power on, flat panel power off, 4: full off), see FB_BLANK_XXX */
+	/*
+	 * Get the LCD panel power status (0: full on, 1..3: controller
+	 * power on, flat panel power off, 4: full off), see FB_BLANK_XXX
+	 */
 	int (*get_power)(struct lcd_device *);
-	/* Enable or disable power to the LCD (0: on; 4: off, see FB_BLANK_XXX) */
+	/*
+	 * Get the current contrast setting (0-max_contrast) and
+	 * Enable or disable power to the LCD (0: on; 4: off, see FB_BLANK_XXX)
+	 * this callback would be called proir to fb driver's fb_blank callback.
+	 */
+	int (*early_set_power)(struct lcd_device *, int power);
+	/*
+	 * Get the current contrast setting (0-max_contrast)
+	 * Enable or disable power to the LCD (0: on; 4: off, see FB_BLANK_XXX)
+	 */
 	int (*set_power)(struct lcd_device *, int power);
 	/* Get the current contrast setting (0-max_contrast) */
 	int (*get_contrast)(struct lcd_device *);
@@ -48,21 +59,35 @@ struct lcd_ops {
         int (*set_contrast)(struct lcd_device *, int contrast);
 	/* Set LCD panel mode (resolutions ...) */
 	int (*set_mode)(struct lcd_device *, struct fb_videomode *);
-	/* Check if given framebuffer device is the one LCD is bound to;
-	   return 0 if not, !=0 if it is. If NULL, lcd always matches the fb. */
+	/*
+	 * Check if given framebuffer device is the one LCD is bound to;
+	 * return 0 if not, !=0 if it is. If NULL, lcd always matches the fb.
+	 */
 	int (*check_fb)(struct lcd_device *, struct fb_info *);
+
+	/*
+	 * indicate whether enabling early blank mode or not.
+	 * (0: disable; 1: enable);
+	 * if enabled, lcd blank callback would be called prior
+	 * to fb blank callback.
+	 */
+	unsigned int early_blank_mode;
 };
 
 struct lcd_device {
 	struct lcd_properties props;
-	/* This protects the 'ops' field. If 'ops' is NULL, the driver that
-	   registered this device has been unloaded, and if class_get_devdata()
-	   points to something in the body of that driver, it is also invalid. */
+	/*
+	 * This protects the 'ops' field. If 'ops' is NULL, the driver that
+	 * registered this device has been unloaded, and if class_get_devdata()
+	 * points to something in the body of that driver, it is also invalid.
+	 */
 	struct mutex ops_lock;
 	/* If this is NULL, the backing module is unloaded */
 	struct lcd_ops *ops;
 	/* Serialise access to set_power method */
 	struct mutex update_lock;
+	/* The framebuffer early notifier block */
+	struct notifier_block fb_early_notif;
 	/* The framebuffer notifier block */
 	struct notifier_block fb_notif;
 
@@ -72,16 +97,22 @@ struct lcd_device {
 struct lcd_platform_data {
 	/* reset lcd panel device. */
 	int (*reset)(struct lcd_device *ld);
-	/* on or off to lcd panel. if 'enable' is 0 then
-	   lcd power off and 1, lcd power on. */
+	/*
+	 * on or off to lcd panel. if 'enable' is 0 then
+	 * lcd power off and 1, lcd power on.
+	 */
 	int (*power_on)(struct lcd_device *ld, int enable);
 
-	/* it indicates whether lcd panel was enabled
-	   from bootloader or not. */
+	/*
+	 * it indicates whether lcd panel was enabled
+	 * from bootloader or not.
+	 */
 	int lcd_enabled;
-	/* it means delay for stable time when it becomes low to high
-	   or high to low that is dependent on whether reset gpio is
-	   low active or high active. */
+	/*
+	 * it means delay for stable time when it becomes low to high
+	 * or high to low that is dependent on whether reset gpio is
+	 * low active or high active.
+	 */
 	unsigned int reset_delay;
 	/* stable time needing to become lcd power on. */
 	unsigned int power_on_delay;
-- 
1.7.0.4

