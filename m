Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1GAJg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:36:28 -0400
Received: from fb1.tech.numericable.fr ([82.216.111.51]:34231 "EHLO
	fb1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab1GAJfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:35:30 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: platform-driver-x86@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net> (maintainer:ASUS NOTEBOOKS
	AN...),
        Matthew Garrett <mjg@redhat.com> (maintainer:X86 PLATFORM DRIVERS),
        acpi4asus-user@lists.sourceforge.net (open list:ASUS NOTEBOOKS AN...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 14/16] asus-wmi: add CWAP support and clarify the meaning of WAPF bits
Date: Fri,  1 Jul 2011 11:34:39 +0200
Message-Id: <1309512881-2901-15-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
References: <1309512881-2901-1-git-send-email-corentin.chary@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ref: http://dev.iksaif.net/projects/3/wiki/Asus-laptop_WAPF

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    9 ++++-----
 drivers/platform/x86/asus-nb-wmi.c |   27 +++++++++++++++++++++++----
 drivers/platform/x86/asus-wmi.c    |    6 ++++++
 drivers/platform/x86/asus-wmi.h    |    1 +
 drivers/platform/x86/eeepc-wmi.c   |    1 +
 5 files changed, 35 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index d65df92..fa6d7ec 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -70,11 +70,10 @@ MODULE_LICENSE("GPL");
  * WAPF defines the behavior of the Fn+Fx wlan key
  * The significance of values is yet to be found, but
  * most of the time:
- * 0x0 will do nothing
- * 0x1 will allow to control the device with Fn+Fx key.
- * 0x4 will send an ACPI event (0x88) while pressing the Fn+Fx key
- * 0x5 like 0x1 or 0x4
- * So, if something doesn't work as you want, just try other values =)
+ * Bit | Bluetooth | WLAN
+ *  0  | Hardware  | Hardware
+ *  1  | Hardware  | Software
+ *  4  | Software  | Software
  */
 static uint wapf = 1;
 module_param(wapf, uint, 0444);
diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 0580d99..b0859d4 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -38,6 +38,24 @@ MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("wmi:"ASUS_NB_WMI_EVENT_GUID);
 
+/*
+ * WAPF defines the behavior of the Fn+Fx wlan key
+ * The significance of values is yet to be found, but
+ * most of the time:
+ * Bit | Bluetooth | WLAN
+ *  0  | Hardware  | Hardware
+ *  1  | Hardware  | Software
+ *  4  | Software  | Software
+ */
+static uint wapf;
+module_param(wapf, uint, 0444);
+MODULE_PARM_DESC(wapf, "WAPF value");
+
+static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
+{
+	driver->wapf = wapf;
+}
+
 static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
@@ -53,16 +71,16 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x51, { KEY_WWW } },
 	{ KE_KEY, 0x55, { KEY_CALC } },
 	{ KE_KEY, 0x5C, { KEY_F15 } },  /* Power Gear key */
-	{ KE_KEY, 0x5D, { KEY_WLAN } },
-	{ KE_KEY, 0x5E, { KEY_WLAN } },
-	{ KE_KEY, 0x5F, { KEY_WLAN } },
+	{ KE_KEY, 0x5D, { KEY_WLAN } }, /* Wireless console Toggle */
+	{ KE_KEY, 0x5E, { KEY_WLAN } }, /* Wireless console Enable */
+	{ KE_KEY, 0x5F, { KEY_WLAN } }, /* Wireless console Disable */
 	{ KE_KEY, 0x60, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x61, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x62, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x63, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY, 0x6B, { KEY_TOUCHPAD_TOGGLE } },
-	{ KE_KEY, 0x7E, { KEY_BLUETOOTH } },
 	{ KE_KEY, 0x7D, { KEY_BLUETOOTH } },
+	{ KE_KEY, 0x7E, { KEY_BLUETOOTH } },
 	{ KE_KEY, 0x82, { KEY_CAMERA } },
 	{ KE_KEY, 0x88, { KEY_RFKILL  } },
 	{ KE_KEY, 0x8A, { KEY_PROG1 } },
@@ -81,6 +99,7 @@ static struct asus_wmi_driver asus_nb_wmi_driver = {
 	.keymap = asus_nb_wmi_keymap,
 	.input_name = "Asus WMI hotkeys",
 	.input_phys = ASUS_NB_WMI_FILE "/input0",
+	.quirks = asus_nb_wmi_quirks,
 };
 
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index b181f5d..db4413a 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1413,6 +1413,12 @@ static int asus_wmi_platform_init(struct asus_wmi *asus)
 		return -ENODEV;
 	}
 
+	/* CWAP allow to define the behavior of the Fn+F2 key,
+	 * this method doesn't seems to be present on Eee PCs */
+	if (asus->driver->wapf >= 0)
+		asus_wmi_set_devstate(ASUS_WMI_DEVID_CWAP,
+				      asus->driver->wapf, NULL);
+
 	return asus_wmi_sysfs_init(asus->platform_device);
 }
 
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 4da6103..8147c10 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -37,6 +37,7 @@ struct asus_wmi;
 
 struct asus_wmi_driver {
 	bool			hotplug_wireless;
+	int			wapf;
 
 	const char		*name;
 	struct module		*owner;
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index f41a977..9f6e643 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -166,6 +166,7 @@ static void eeepc_dmi_check(struct asus_wmi_driver *driver)
 static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
 {
 	driver->hotplug_wireless = hotplug_wireless;
+	driver->wapf = -1;
 	eeepc_dmi_check(driver);
 }
 
-- 
1.7.3.4

