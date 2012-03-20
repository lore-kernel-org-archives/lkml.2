Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030487Ab2CTI4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:56:48 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39113 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965076Ab2CTIyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:11 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org,
        Corentin Chary <corentin.chary@gmail.com>,
        AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] asus-wmi: move WAPF variable into quirks_entry
Date: Tue, 20 Mar 2012 09:53:10 +0100
Message-Id: <1332233594-13099-11-git-send-email-corentin.chary@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
References: <1332233594-13099-1-git-send-email-corentin.chary@gmail.com>
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeegvddrgeejucetggdotefuucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some models work better with different values of wapf, so move the
variable into quriks_entry to make it more easy to give a specific
value to different models.

Based on original patch from AceLan Kao <acelan.kao@canonical.com>

Cc: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-nb-wmi.c |    6 +++++-
 drivers/platform/x86/asus-wmi.c    |    4 ++--
 drivers/platform/x86/asus-wmi.h    |    2 +-
 drivers/platform/x86/eeepc-wmi.c   |    2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 1aea6b8..b12038c 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -51,9 +51,13 @@ static uint wapf;
 module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
+static struct quirk_entry quirk_asus_unknown = {
+};
+
 static void asus_nb_wmi_quirks(struct asus_wmi_driver *driver)
 {
-	driver->wapf = wapf;
+	driver->quirks = &quirk_asus_unknown;
+	driver->quirks->wapf = wapf;
 }
 
 static const struct key_entry asus_nb_wmi_keymap[] = {
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index c4ad76e..ff9cfd8 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1471,9 +1471,9 @@ static int asus_wmi_platform_init(struct asus_wmi *asus)
 
 	/* CWAP allow to define the behavior of the Fn+F2 key,
 	 * this method doesn't seems to be present on Eee PCs */
-	if (asus->driver->wapf >= 0)
+	if (asus->driver->quirks->wapf >= 0)
 		asus_wmi_set_devstate(ASUS_WMI_DEVID_CWAP,
-				      asus->driver->wapf, NULL);
+				      asus->driver->quirks->wapf, NULL);
 
 	return asus_wmi_sysfs_init(asus->platform_device);
 }
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 35003e4..d43b667 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -39,10 +39,10 @@ struct quirk_entry {
 	bool hotplug_wireless;
 	bool scalar_panel_brightness;
 	bool store_backlight_power;
+	int wapf;
 };
 
 struct asus_wmi_driver {
-	int			wapf;
 	int			brightness;
 	int			panel_power;
 
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 9f8ccf9..389ff88 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -209,10 +209,10 @@ static int eeepc_wmi_probe(struct platform_device *pdev)
 
 static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
 {
-	driver->wapf = -1;
 	driver->panel_power = FB_BLANK_UNBLANK;
 	driver->quirks = &quirk_asus_unknown;
 	driver->quirks->hotplug_wireless = hotplug_wireless;
+	driver->quirks->wapf = -1;
 	dmi_check_system(asus_quirks);
 	driver->quirks = quirks;
 }
-- 
1.7.3.4

