Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1EaPxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 11:53:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab1EaPxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 11:53:48 -0400
Date: Tue, 31 May 2011 11:53:48 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, device-drivers-devel@blackfin.uclinux.org
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20110531155348.3621.73082.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/x-c; charset=us-ascii
Subject: [RFC PATCH 29/35] drivers/video changes for SMBIOS and System Firmware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 930ed370ec0b80a7a5f30d7362b8d19fa906295e Mon Sep 17 00:00:00 2001
From: Prarit Bhargava <prarit@redhat.com>
Date: Tue, 31 May 2011 09:31:06 -0400
Subject: [PATCH 29/35] drivers/video changes for SMBIOS and System Firmware

---
 drivers/video/aty/atyfb_base.c      |   18 +++---
 drivers/video/backlight/kb3886_bl.c |   12 ++--
 drivers/video/efifb.c               |  124 ++++++++++++++++++-----------------
 3 files changed, 79 insertions(+), 75 deletions(-)

diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index ebb893c..02eb9a3 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -67,7 +67,7 @@
 #include <linux/wait.h>
 #include <linux/backlight.h>
 #include <linux/reboot.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #include <asm/io.h>
 #include <linux/uaccess.h>
@@ -3957,17 +3957,17 @@ static struct notifier_block atyfb_reboot_notifier = {
 	.notifier_call = atyfb_reboot_notify,
 };
 
-static const struct dmi_system_id atyfb_reboot_ids[] = {
+static const struct sysfw_id atyfb_reboot_ids[] = {
 	{
 		.ident = "HP OmniBook 500",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "HP OmniBook PC"),
-			DMI_MATCH(DMI_PRODUCT_VERSION, "HP OmniBook 500 FA"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "Hewlett-Packard"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "HP OmniBook PC"),
+			SYSFW_MATCH(SYSFW_PRODUCT_VERSION,
+				    "HP OmniBook 500 FA"),
 		},
 	},
-
-	{ }
+	{}
 };
 
 static int __init atyfb_init(void)
@@ -3991,7 +3991,7 @@ static int __init atyfb_init(void)
 	if (err1 && err2)
 		return -ENODEV;
 
-	if (dmi_check_system(atyfb_reboot_ids))
+	if (sysfw_callback(atyfb_reboot_ids))
 		register_reboot_notifier(&atyfb_reboot_notifier);
 
 	return 0;
@@ -3999,7 +3999,7 @@ static int __init atyfb_init(void)
 
 static void __exit atyfb_exit(void)
 {
-	if (dmi_check_system(atyfb_reboot_ids))
+	if (sysfw_callback(atyfb_reboot_ids))
 		unregister_reboot_notifier(&atyfb_reboot_notifier);
 
 #ifdef CONFIG_PCI
diff --git a/drivers/video/backlight/kb3886_bl.c b/drivers/video/backlight/kb3886_bl.c
index 72dd555..ad3fc80 100644
--- a/drivers/video/backlight/kb3886_bl.c
+++ b/drivers/video/backlight/kb3886_bl.c
@@ -19,7 +19,7 @@
 #include <linux/fb.h>
 #include <linux/backlight.h>
 #include <linux/delay.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 
 #define KB3886_PARENT 0x64
 #define KB3886_IO 0x60
@@ -78,12 +78,12 @@ static struct kb3886bl_machinfo *bl_machinfo;
 static unsigned long kb3886bl_flags;
 #define KB3886BL_SUSPENDED     0x01
 
-static struct dmi_system_id __initdata kb3886bl_device_table[] = {
+static struct sysfw_id __initdata kb3886bl_device_table[] = {
 	{
 		.ident = "Sahara Touch-iT",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SDV"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "iTouch T201"),
+			SYSFW_MATCH(SYSFW_SYS_VENDOR, "SDV"),
+			SYSFW_MATCH(SYSFW_PRODUCT_NAME, "iTouch T201"),
 		},
 	},
 	{ }
@@ -188,7 +188,7 @@ static struct platform_driver kb3886bl_driver = {
 
 static int __init kb3886_init(void)
 {
-	if (!dmi_check_system(kb3886bl_device_table))
+	if (!sysfw_callback(kb3886bl_device_table))
 		return -ENODEV;
 
 	platform_add_devices(devices, ARRAY_SIZE(devices));
@@ -206,4 +206,4 @@ module_exit(kb3886_exit);
 MODULE_AUTHOR("Claudio Nieder <private@claudio.ch>");
 MODULE_DESCRIPTION("Tabletkiosk Sahara Touch-iT Backlight Driver");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS("dmi:*:svnSDV:pniTouchT201:*");
+MODULE_ALIAS("smbios:*:svnSDV:pniTouchT201:*");
diff --git a/drivers/video/efifb.c b/drivers/video/efifb.c
index fb20584..d2203cb 100644
--- a/drivers/video/efifb.c
+++ b/drivers/video/efifb.c
@@ -12,7 +12,7 @@
 #include <linux/fb.h>
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
-#include <linux/dmi.h>
+#include <linux/sysfw.h>
 #include <linux/pci.h>
 #include <video/vga.h>
 
@@ -75,14 +75,14 @@ enum {
 #define OVERRIDE_HEIGHT	0x4
 #define OVERRIDE_WIDTH	0x8
 
-static struct efifb_dmi_info {
+static struct efifb_smbios_info {
 	char *optname;
 	unsigned long base;
 	int stride;
 	int width;
 	int height;
 	int flags;
-} dmi_list[] __initdata = {
+} smbios_list[] __initdata = {
 	[M_I17] = { "i17", 0x80010000, 1472 * 4, 1440, 900, OVERRIDE_NONE },
 	[M_I20] = { "i20", 0x80010000, 1728 * 4, 1680, 1050, OVERRIDE_NONE }, /* guess */
 	[M_I20_SR] = { "imac7", 0x40010000, 1728 * 4, 1680, 1050, OVERRIDE_NONE },
@@ -115,71 +115,74 @@ static struct efifb_dmi_info {
 	[M_UNKNOWN] = { NULL, 0, 0, 0, 0, OVERRIDE_NONE }
 };
 
-static int set_system(const struct dmi_system_id *id);
+static int set_system(const struct sysfw_id *id);
 
-#define EFIFB_DMI_SYSTEM_ID(vendor, name, enumid)		\
+#define EFIFB_SMBIOS_SYSTEM_ID(vendor, name, enumid)		\
 	{ set_system, name, {					\
-		DMI_MATCH(DMI_BIOS_VENDOR, vendor),		\
-		DMI_MATCH(DMI_PRODUCT_NAME, name) },		\
-	  &dmi_list[enumid] }
+		SYSFW_MATCH(SYSFW_BIOS_VENDOR, vendor),		\
+		SYSFW_MATCH(SYSFW_PRODUCT_NAME, name) },		\
+	  &smbios_list[enumid] }
 
-static const struct dmi_system_id dmi_system_table[] __initconst = {
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac4,1", M_I17),
+static const struct sysfw_id smbios_system_table[] __initconst = {
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "iMac4,1", M_I17),
 	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac5,1", M_I20),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac5,1", M_I20),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "iMac5,1", M_I20),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "iMac5,1", M_I20),
 	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "iMac6,1", M_I24),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac6,1", M_I24),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac7,1", M_I20_SR),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac8,1", M_I24_8_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac10,1", M_I24_10_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "iMac11,1", M_I27_11_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "Macmini1,1", M_MINI),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini3,1", M_MINI_3_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "Macmini4,1", M_MINI_4_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook1,1", M_MB),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "iMac6,1", M_I24),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "iMac6,1", M_I24),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "iMac7,1", M_I20_SR),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "iMac8,1", M_I24_8_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "iMac10,1", M_I24_10_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "iMac11,1", M_I27_11_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "Macmini1,1", M_MINI),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "Macmini3,1", M_MINI_3_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "Macmini4,1", M_MINI_4_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBook1,1", M_MB),
 	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook2,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook2,1", M_MB),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBook2,1", M_MB),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBook2,1", M_MB),
 	/* At least one of these two will be right; maybe both? */
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBook3,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook3,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook4,1", M_MB),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook5,1", M_MB_5_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook6,1", M_MB_6_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBook7,1", M_MB_7_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir1,1", M_MBA),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookAir3,1", M_MBA_3),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro1,1", M_MBP),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,1", M_MBP_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,2", M_MBP_2_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro2,1", M_MBP_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1", M_MBP_SR),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,2", M_MBP_5_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro5,3", M_MBP_5_3),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,1", M_MBP_6_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro6,2", M_MBP_6_2),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro7,1", M_MBP_7_1),
-	EFIFB_DMI_SYSTEM_ID("Apple Inc.", "MacBookPro8,2", M_MBP_8_2),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBook3,1", M_MB),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBook3,1", M_MB),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBook4,1", M_MB),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBook5,1", M_MB_5_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBook6,1", M_MB_6_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBook7,1", M_MB_7_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookAir1,1", M_MBA),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookAir3,1", M_MBA_3),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro1,1", M_MBP),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,1",
+			       M_MBP_2),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro2,2",
+			       M_MBP_2_2),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro2,1", M_MBP_2),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Computer, Inc.", "MacBookPro3,1",
+			       M_MBP_SR),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro3,1", M_MBP_SR),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro4,1", M_MBP_4),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro5,1", M_MBP_5_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro5,2", M_MBP_5_2),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro5,3", M_MBP_5_3),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro6,1", M_MBP_6_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro6,2", M_MBP_6_2),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro7,1", M_MBP_7_1),
+	EFIFB_SMBIOS_SYSTEM_ID("Apple Inc.", "MacBookPro8,2", M_MBP_8_2),
 	{},
 };
 
-#define choose_value(dmivalue, fwvalue, field, flags) ({	\
+#define choose_value(smbiosvalue, fwvalue, field, flags) ({	\
 		typeof(fwvalue) _ret_ = fwvalue;		\
 		if ((flags) & (field))				\
-			_ret_ = dmivalue;			\
+			_ret_ = smbiosvalue;			\
 		else if ((fwvalue) == 0)			\
-			_ret_ = dmivalue;			\
+			_ret_ = smbiosvalue;			\
 		_ret_;						\
 	})
 
-static int set_system(const struct dmi_system_id *id)
+static int set_system(const struct sysfw_id *id)
 {
-	struct efifb_dmi_info *info = id->driver_data;
+	struct efifb_smbios_info *info = id->driver_data;
 
 	if (info->base == 0 && info->height == 0 && info->width == 0
 			&& info->stride == 0)
@@ -242,7 +245,7 @@ static int set_system(const struct dmi_system_id *id)
 		return 0;
 	}
 
-	printk(KERN_INFO "efifb: dmi detected %s - framebuffer at 0x%08x "
+	printk(KERN_INFO "efifb: smbios detected %s - framebuffer at 0x%08x "
 			 "(%dx%d, stride %d)\n", id->ident,
 			 screen_info.lfb_base, screen_info.lfb_width,
 			 screen_info.lfb_height, screen_info.lfb_linelength);
@@ -306,12 +309,13 @@ static int __init efifb_setup(char *options)
 		if (!*this_opt) continue;
 
 		for (i = 0; i < M_UNKNOWN; i++) {
-			if (!strcmp(this_opt, dmi_list[i].optname) &&
-					dmi_list[i].base != 0) {
-				screen_info.lfb_base = dmi_list[i].base;
-				screen_info.lfb_linelength = dmi_list[i].stride;
-				screen_info.lfb_width = dmi_list[i].width;
-				screen_info.lfb_height = dmi_list[i].height;
+			if (!strcmp(this_opt, smbios_list[i].optname) &&
+					smbios_list[i].base != 0) {
+				screen_info.lfb_base = smbios_list[i].base;
+				screen_info.lfb_linelength =
+							  smbios_list[i].stride;
+				screen_info.lfb_width = smbios_list[i].width;
+				screen_info.lfb_height = smbios_list[i].height;
 			}
 		}
 		if (!strncmp(this_opt, "base:", 5))
@@ -512,7 +516,7 @@ static int __init efifb_init(void)
 	int ret;
 	char *option = NULL;
 
-	dmi_check_system(dmi_system_table);
+	sysfw_callback(smbios_system_table);
 
 	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return -ENODEV;
@@ -522,7 +526,7 @@ static int __init efifb_init(void)
 	efifb_setup(option);
 
 	/* We don't get linelength from UGA Draw Protocol, only from
-	 * EFI Graphics Protocol.  So if it's not in DMI, and it's not
+	 * EFI Graphics Protocol.  So if it's not in SMBIOS, and it's not
 	 * passed in from the user, we really can't use the framebuffer.
 	 */
 	if (!screen_info.lfb_linelength)
-- 
1.7.5.1

