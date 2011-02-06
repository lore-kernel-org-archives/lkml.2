Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab1BFMeZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:34:25 -0500
Received: from relay2-d.mail.gandi.net ([217.70.183.194]:36977 "EHLO
	relay2-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1BFMeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:34:23 -0500
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Feb 2011 07:34:22 EST
X-Originating-IP: 217.70.178.39
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Corentin Chary <corentincj@iksaif.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH 2/2] asus-laptop: remove deprecated interfaces (lcd_switch and display_get)
Date: Sun,  6 Feb 2011 13:27:31 +0100
Message-Id: <1296995251-5306-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995251-5306-1-git-send-email-corentincj@iksaif.net>
References: <1296995251-5306-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

I should have done that one year ago, so it's more than
time to do it.

These two features use non-standard interfaces. There are the
only features that really need multiple path to guess what's
the right method name on a specific laptop.

Removing them allow to remove a lot of code an significantly
clean the driver.

This will affect the backlight code which won't be able to know
if the backlight is on or off.

The platform display file will also be write only (like the one
in eeepc-laptop).

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 Documentation/feature-removal-schedule.txt |   20 ----
 drivers/platform/x86/asus-laptop.c         |  163 +---------------------------
 2 files changed, 3 insertions(+), 180 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index f2742e1..810106d 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -403,26 +403,6 @@ Who:	Tejun Heo <tj@kernel.org>
 
 ----------------------------
 
-What:	Support for lcd_switch and display_get in asus-laptop driver
-When:	March 2010
-Why:	These two features use non-standard interfaces. There are the
-	only features that really need multiple path to guess what's
-	the right method name on a specific laptop.
-
-	Removing them will allow to remove a lot of code an significantly
-	clean the drivers.
-
-	This will affect the backlight code which won't be able to know
-	if the backlight is on or off. The platform display file will also be
-	write only (like the one in eeepc-laptop).
-
-	This should'nt affect a lot of user because they usually know
-	when their display is on or off.
-
-Who:	Corentin Chary <corentin.chary@gmail.com>
-
-----------------------------
-
 What:	sysfs-class-rfkill state file
 When:	Feb 2014
 Files:	net/rfkill/core.c
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 1909685..6bfca85 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -158,46 +158,9 @@ MODULE_PARM_DESC(wwan_status, "Set the wireless status on boot "
 #define METHOD_BRIGHTNESS_SET	"SPLV"
 #define METHOD_BRIGHTNESS_GET	"GPLV"
 
-/* Backlight */
-static acpi_handle lcd_switch_handle;
-static char *lcd_switch_paths[] = {
-  "\\_SB.PCI0.SBRG.EC0._Q10",	/* All new models */
-  "\\_SB.PCI0.ISA.EC0._Q10",	/* A1x */
-  "\\_SB.PCI0.PX40.ECD0._Q10",	/* L3C */
-  "\\_SB.PCI0.PX40.EC0.Q10",	/* M1A */
-  "\\_SB.PCI0.LPCB.EC0._Q10",	/* P30 */
-  "\\_SB.PCI0.LPCB.EC0._Q0E", /* P30/P35 */
-  "\\_SB.PCI0.PX40.Q10",	/* S1x */
-  "\\Q10"};		/* A2x, L2D, L3D, M2E */
-
 /* Display */
 #define METHOD_SWITCH_DISPLAY	"SDSP"
 
-static acpi_handle display_get_handle;
-static char *display_get_paths[] = {
-  /* A6B, A6K A6R A7D F3JM L4R M6R A3G M6A M6V VX-1 V6J V6V W3Z */
-  "\\_SB.PCI0.P0P1.VGA.GETD",
-  /* A3E A4K, A4D A4L A6J A7J A8J Z71V M9V S5A M5A z33A W1Jc W2V G1 */
-  "\\_SB.PCI0.P0P2.VGA.GETD",
-  /* A6V A6Q */
-  "\\_SB.PCI0.P0P3.VGA.GETD",
-  /* A6T, A6M */
-  "\\_SB.PCI0.P0PA.VGA.GETD",
-  /* L3C */
-  "\\_SB.PCI0.PCI1.VGAC.NMAP",
-  /* Z96F */
-  "\\_SB.PCI0.VGA.GETD",
-  /* A2D */
-  "\\ACTD",
-  /* A4G Z71A W1N W5A W5F M2N M3N M5N M6N S1N S5N */
-  "\\ADVG",
-  /* P30 */
-  "\\DNXT",
-  /* A2H D1 L2D L3D L3H L2E L5D L5C M1A M2E L4L W3V */
-  "\\INFB",
-  /* A3F A6F A3N A3L M6N W3N W6A */
-  "\\SSTE"};
-
 #define METHOD_ALS_CONTROL	"ALSC" /* Z71A Z71V */
 #define METHOD_ALS_LEVEL	"ALSL" /* Z71A Z71V */
 
@@ -247,7 +210,6 @@ struct asus_laptop {
 
 	int wireless_status;
 	bool have_rsts;
-	int lcd_state;
 
 	struct rfkill *gps_rfkill;
 
@@ -560,48 +522,6 @@ error:
 /*
  * Backlight device
  */
-static int asus_lcd_status(struct asus_laptop *asus)
-{
-	return asus->lcd_state;
-}
-
-static int asus_lcd_set(struct asus_laptop *asus, int value)
-{
-	int lcd = 0;
-	acpi_status status = 0;
-
-	lcd = !!value;
-
-	if (lcd == asus_lcd_status(asus))
-		return 0;
-
-	if (!lcd_switch_handle)
-		return -ENODEV;
-
-	status = acpi_evaluate_object(lcd_switch_handle,
-				      NULL, NULL, NULL);
-
-	if (ACPI_FAILURE(status)) {
-		pr_warning("Error switching LCD\n");
-		return -ENODEV;
-	}
-
-	asus->lcd_state = lcd;
-	return 0;
-}
-
-static void lcd_blank(struct asus_laptop *asus, int blank)
-{
-	struct backlight_device *bd = asus->backlight_device;
-
-	asus->lcd_state = (blank == FB_BLANK_UNBLANK);
-
-	if (bd) {
-		bd->props.power = blank;
-		backlight_update_status(bd);
-	}
-}
-
 static int asus_read_brightness(struct backlight_device *bd)
 {
 	struct asus_laptop *asus = bl_get_data(bd);
@@ -629,16 +549,9 @@ static int asus_set_brightness(struct backlight_device *bd, int value)
 
 static int update_bl_status(struct backlight_device *bd)
 {
-	struct asus_laptop *asus = bl_get_data(bd);
-	int rv;
 	int value = bd->props.brightness;
 
-	rv = asus_set_brightness(bd, value);
-	if (rv)
-		return rv;
-
-	value = (bd->props.power == FB_BLANK_UNBLANK) ? 1 : 0;
-	return asus_lcd_set(asus, value);
+	return asus_set_brightness(bd, value);
 }
 
 static struct backlight_ops asusbl_ops = {
@@ -662,8 +575,7 @@ static int asus_backlight_init(struct asus_laptop *asus)
 	struct backlight_properties props;
 
 	if (acpi_check_handle(asus->handle, METHOD_BRIGHTNESS_GET, NULL) ||
-	    acpi_check_handle(asus->handle, METHOD_BRIGHTNESS_SET, NULL) ||
-	    !lcd_switch_handle)
+	    acpi_check_handle(asus->handle, METHOD_BRIGHTNESS_SET, NULL))
 		return 0;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
@@ -971,41 +883,6 @@ static void asus_set_display(struct asus_laptop *asus, int value)
 	return;
 }
 
-static int read_display(struct asus_laptop *asus)
-{
-	unsigned long long value = 0;
-	acpi_status rv = AE_OK;
-
-	/*
-	 * In most of the case, we know how to set the display, but sometime
-	 * we can't read it
-	 */
-	if (display_get_handle) {
-		rv = acpi_evaluate_integer(display_get_handle, NULL,
-					   NULL, &value);
-		if (ACPI_FAILURE(rv))
-			pr_warning("Error reading display status\n");
-	}
-
-	value &= 0x0F; /* needed for some models, shouldn't hurt others */
-
-	return value;
-}
-
-/*
- * Now, *this* one could be more user-friendly, but so far, no-one has
- * complained. The significance of bits is the same as in store_disp()
- */
-static ssize_t show_disp(struct device *dev,
-			 struct device_attribute *attr, char *buf)
-{
-	struct asus_laptop *asus = dev_get_drvdata(dev);
-
-	if (!display_get_handle)
-		return -ENODEV;
-	return sprintf(buf, "%d\n", read_display(asus));
-}
-
 /*
  * Experimental support for display switching. As of now: 1 should activate
  * the LCD output, 2 should do for CRT, 4 for TV-Out and 8 for DVI.
@@ -1247,15 +1124,6 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 	struct asus_laptop *asus = acpi_driver_data(device);
 	u16 count;
 
-	/*
-	 * We need to tell the backlight device when the backlight power is
-	 * switched
-	 */
-	if (event == ATKD_LCD_ON)
-		lcd_blank(asus, FB_BLANK_UNBLANK);
-	else if (event == ATKD_LCD_OFF)
-		lcd_blank(asus, FB_BLANK_POWERDOWN);
-
 	/* TODO Find a better way to handle events count. */
 	count = asus->event_count[event % 128]++;
 	acpi_bus_generate_proc_event(asus->device, event, count);
@@ -1282,7 +1150,7 @@ static DEVICE_ATTR(bluetooth, S_IRUGO | S_IWUSR,
 		   show_bluetooth, store_bluetooth);
 static DEVICE_ATTR(wimax, S_IRUGO | S_IWUSR, show_wimax, store_wimax);
 static DEVICE_ATTR(wwan, S_IRUGO | S_IWUSR, show_wwan, store_wwan);
-static DEVICE_ATTR(display, S_IRUGO | S_IWUSR, show_disp, store_disp);
+static DEVICE_ATTR(display, S_IWUSR, NULL, store_disp);
 static DEVICE_ATTR(ledd, S_IRUGO | S_IWUSR, show_ledd, store_ledd);
 static DEVICE_ATTR(ls_level, S_IRUGO | S_IWUSR, show_lslvl, store_lslvl);
 static DEVICE_ATTR(ls_switch, S_IRUGO | S_IWUSR, show_lssw, store_lssw);
@@ -1393,26 +1261,6 @@ static struct platform_driver platform_driver = {
 	}
 };
 
-static int asus_handle_init(char *name, acpi_handle * handle,
-			    char **paths, int num_paths)
-{
-	int i;
-	acpi_status status;
-
-	for (i = 0; i < num_paths; i++) {
-		status = acpi_get_handle(NULL, paths[i], handle);
-		if (ACPI_SUCCESS(status))
-			return 0;
-	}
-
-	*handle = NULL;
-	return -ENODEV;
-}
-
-#define ASUS_HANDLE_INIT(object)					\
-	asus_handle_init(#object, &object##_handle, object##_paths,	\
-			 ARRAY_SIZE(object##_paths))
-
 /*
  * This function is used to initialize the context with right values. In this
  * method, we can make all the detection we want, and modify the asus_laptop
@@ -1498,10 +1346,6 @@ static int asus_laptop_get_info(struct asus_laptop *asus)
 	if (!acpi_check_handle(asus->handle, METHOD_WL_STATUS, NULL))
 		asus->have_rsts = true;
 
-	/* Scheduled for removal */
-	ASUS_HANDLE_INIT(lcd_switch);
-	ASUS_HANDLE_INIT(display_get);
-
 	kfree(model);
 
 	return AE_OK;
@@ -1553,7 +1397,6 @@ static int __devinit asus_acpi_init(struct asus_laptop *asus)
 		asus_als_level(asus, asus->light_level);
 	}
 
-	asus->lcd_state = 1; /* LCD should be on when the module load */
 	return result;
 }
 
-- 
1.7.4.rc3

