Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1JNJIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:08:31 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51140 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664Ab1JNJI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:28 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 1/8] asus-laptop: Platform detection for Pegatron Lucid
Date: Fri, 14 Oct 2011 11:13:35 +0200
Message-Id: <1318583622-23518-2-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Ross <andy.ross@windriver.com>

Recognize the Pegatron Lucid tablets by their method signatures.

Signed-off-by: Andy Ross <andy.ross@windriver.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/Kconfig       |   18 ++++++++++--------
 drivers/platform/x86/asus-laptop.c |   23 ++++++++++++++++++++---
 2 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index 1e88d47..4e5623e 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -64,15 +64,17 @@ config ASUS_LAPTOP
 	depends on INPUT
 	depends on RFKILL || RFKILL = n
 	select INPUT_SPARSEKMAP
+	select INPUT_POLLDEV
 	---help---
-	  This is the new Linux driver for Asus laptops. It may also support some
-	  MEDION, JVC or VICTOR laptops. It makes all the extra buttons generate
-	  standard ACPI events and input events. It also adds
-	  support for video output switching, LCD backlight control, Bluetooth and
-	  Wlan control, and most importantly, allows you to blink those fancy LEDs.
+	  This is a driver for Asus laptops, Lenovo SL and the Pegatron
+	  Lucid tablet. It may also support some MEDION, JVC or VICTOR
+	  laptops. It makes all the extra buttons generate standard
+	  ACPI events and input events. It also adds support for video
+	  output switching, LCD backlight control, Bluetooth and Wlan
+	  control, and most importantly, allows you to blink those
+	  fancy LEDs.
 
-	  For more information and a userspace daemon for handling the extra
-	  buttons see <http://acpi4asus.sf.net>.
+	  For more information see <http://acpi4asus.sf.net>.
 
 	  If you have an ACPI-compatible ASUS laptop, say Y or M here.
 
diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index fa6d7ec..c08f4c2 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -4,6 +4,7 @@
  *
  *  Copyright (C) 2002-2005 Julien Lerouge, 2003-2006 Karol Kozimor
  *  Copyright (C) 2006-2007 Corentin Chary
+ *  Copyright (C) 2011 Wind River Systems
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -48,6 +49,7 @@
 #include <linux/uaccess.h>
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
+#include <linux/input-polldev.h>
 #include <linux/rfkill.h>
 #include <linux/slab.h>
 #include <linux/dmi.h>
@@ -173,6 +175,12 @@ MODULE_PARM_DESC(wwan_status, "Set the wireless status on boot "
 #define METHOD_KBD_LIGHT_SET	"SLKB"
 #define METHOD_KBD_LIGHT_GET	"GLKB"
 
+/* For Pegatron Lucid tablet */
+#define DEVICE_NAME_PEGA	"Lucid"
+#define METHOD_PEGA_ENABLE	"ENPR"
+#define METHOD_PEGA_DISABLE	"DAPR"
+#define METHOD_PEGA_READ	"RDLN"
+
 /*
  * Define a specific led structure to keep the main structure clean
  */
@@ -209,6 +217,7 @@ struct asus_laptop {
 
 	int wireless_status;
 	bool have_rsts;
+	bool is_pega_lucid;
 
 	struct rfkill *gps_rfkill;
 
@@ -323,6 +332,14 @@ static int acpi_check_handle(acpi_handle handle, const char *method,
 	return 0;
 }
 
+static bool asus_check_pega_lucid(struct asus_laptop *asus)
+{
+	return !strcmp(asus->name, DEVICE_NAME_PEGA) &&
+	   !acpi_check_handle(asus->handle, METHOD_PEGA_ENABLE, NULL) &&
+	   !acpi_check_handle(asus->handle, METHOD_PEGA_DISABLE, NULL) &&
+	   !acpi_check_handle(asus->handle, METHOD_PEGA_READ, NULL);
+}
+
 /* Generic LED function */
 static int asus_led_set(struct asus_laptop *asus, const char *method,
 			 int value)
@@ -1203,7 +1220,6 @@ static mode_t asus_sysfs_is_visible(struct kobject *kobj,
 		   attr == &dev_attr_ls_level.attr) {
 		supported = !acpi_check_handle(handle, METHOD_ALS_CONTROL, NULL) &&
 			    !acpi_check_handle(handle, METHOD_ALS_LEVEL, NULL);
-
 	} else if (attr == &dev_attr_gps.attr) {
 		supported = !acpi_check_handle(handle, METHOD_GPS_ON, NULL) &&
 			    !acpi_check_handle(handle, METHOD_GPS_OFF, NULL) &&
@@ -1439,9 +1455,10 @@ static int __devinit asus_acpi_add(struct acpi_device *device)
 		goto fail_platform;
 
 	/*
-	 * Register the platform device first.  It is used as a parent for the
-	 * sub-devices below.
+	 * Need platform type detection first, then the platform
+	 * device.  It is used as a parent for the sub-devices below.
 	 */
+	asus->is_pega_lucid = asus_check_pega_lucid(asus);
 	result = asus_platform_init(asus);
 	if (result)
 		goto fail_platform;
-- 
1.7.3.4

