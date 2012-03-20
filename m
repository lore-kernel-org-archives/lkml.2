Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030536Ab2CTI4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:56:47 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39112 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965135Ab2CTIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:11 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] asus-wmi: store backlight power status for AIO machine
Date: Tue, 20 Mar 2012 09:53:09 +0100
Message-Id: <1332233594-13099-10-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: AceLan Kao <acelan.kao@canonical.com>

Due to some implementation reasons, ASUS ET2012 All-in-One machines
can't report the correct backlight power status, it will always return
1. To track the backlight power status correctly, we have to store the
status by ourselves.

BTW, by the BIOS design, the backlight power will be turn on/off
sequently, no matter what the value of the parameter will be.
More over, the brightness adjustment command will turn on the backlight
power. Those behaviors will make us fail to track the backlight power
status.
For example, While we are trying to turn on the backlight power,
we will send out the brightness adjustment command and then trying to
figure out if we have to turn on the backlight power, then send out
the command. But, the real case is that, the backlight power turns on
while sending the brightness adjustment command, and then we send out
the command to turn on the backlight power, it actually will turn off
the backlight power and the backlight power status we recorded becomes
wrong. So, we have to seperate these two commands by a if statement.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-wmi.c  |   33 ++++++++++++++++++++-------------
 drivers/platform/x86/asus-wmi.h  |    2 ++
 drivers/platform/x86/eeepc-wmi.c |   15 ++++++++++++---
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index eb114f8..c4ad76e 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1076,7 +1076,12 @@ static int asus_wmi_hwmon_init(struct asus_wmi *asus)
  */
 static int read_backlight_power(struct asus_wmi *asus)
 {
-	int ret = asus_wmi_get_devstate_simple(asus, ASUS_WMI_DEVID_BACKLIGHT);
+	int ret;
+	if (asus->driver->quirks->store_backlight_power)
+		ret = !asus->driver->panel_power;
+	else
+		ret = asus_wmi_get_devstate_simple(asus,
+						   ASUS_WMI_DEVID_BACKLIGHT);
 
 	if (ret < 0)
 		return ret;
@@ -1138,24 +1143,23 @@ static int update_bl_status(struct backlight_device *bd)
 {
 	struct asus_wmi *asus = bl_get_data(bd);
 	u32 ctrl_param;
-	int power, err;
-
-	if (asus->driver->quirks->scalar_panel_brightness)
-		ctrl_param = get_scalar_command(bd);
-	else
-		ctrl_param = bd->props.brightness;
-
-	err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
-				    ctrl_param, NULL);
-
-	if (err < 0)
-		return err;
+	int power, err = 0;
 
 	power = read_backlight_power(asus);
 	if (power != -ENODEV && bd->props.power != power) {
 		ctrl_param = !!(bd->props.power == FB_BLANK_UNBLANK);
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BACKLIGHT,
 					    ctrl_param, NULL);
+		if (asus->driver->quirks->store_backlight_power)
+			asus->driver->panel_power = bd->props.power;
+	} else {
+		if (asus->driver->quirks->scalar_panel_brightness)
+			ctrl_param = get_scalar_command(bd);
+		else
+			ctrl_param = bd->props.brightness;
+
+		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
+					    ctrl_param, NULL);
 	}
 	return err;
 }
@@ -1217,6 +1221,9 @@ static int asus_wmi_backlight_init(struct asus_wmi *asus)
 
 	asus->backlight_device = bd;
 
+	if (asus->driver->quirks->store_backlight_power)
+		asus->driver->panel_power = power;
+
 	bd->props.brightness = read_brightness(bd);
 	bd->props.power = power;
 	backlight_update_status(bd);
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index ac7dd4e..35003e4 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -38,11 +38,13 @@ struct asus_wmi;
 struct quirk_entry {
 	bool hotplug_wireless;
 	bool scalar_panel_brightness;
+	bool store_backlight_power;
 };
 
 struct asus_wmi_driver {
 	int			wapf;
 	int			brightness;
+	int			panel_power;
 
 	const char		*name;
 	struct module		*owner;
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 67186e6..9f8ccf9 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -32,6 +32,7 @@
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 #include <linux/dmi.h>
+#include <linux/fb.h>
 #include <acpi/acpi_bus.h>
 
 #include "asus-wmi.h"
@@ -98,8 +99,13 @@ static struct quirk_entry quirk_asus_1000h = {
 	.hotplug_wireless = true,
 };
 
+static struct quirk_entry quirk_asus_et2012_type1 = {
+	.store_backlight_power = true,
+};
+
 static struct quirk_entry quirk_asus_et2012_type3 = {
 	.scalar_panel_brightness = true,
+	.store_backlight_power = true,
 };
 
 static int dmi_matched(const struct dmi_system_id *dmi)
@@ -111,10 +117,12 @@ static int dmi_matched(const struct dmi_system_id *dmi)
 	if (unlikely(strncmp(model, "ET2012", 6) == 0)) {
 		const struct dmi_device *dev = NULL;
 		char oemstring[30];
-		while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING, NULL,
-					      dev))) {
+		while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING,
+					      NULL, dev))) {
 			if (sscanf(dev->name, "AEMS%24c", oemstring) == 1) {
-				if (oemstring[18] == '3')
+				if (oemstring[18] == '1')
+					quirks = &quirk_asus_et2012_type1;
+				else if (oemstring[18] == '3')
 					quirks = &quirk_asus_et2012_type3;
 				break;
 			}
@@ -202,6 +210,7 @@ static int eeepc_wmi_probe(struct platform_device *pdev)
 static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
 {
 	driver->wapf = -1;
+	driver->panel_power = FB_BLANK_UNBLANK;
 	driver->quirks = &quirk_asus_unknown;
 	driver->quirks->hotplug_wireless = hotplug_wireless;
 	dmi_check_system(asus_quirks);
-- 
1.7.3.4

