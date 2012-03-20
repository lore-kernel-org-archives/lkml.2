Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030709Ab2CTI5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:57:37 -0400
Received: from smtp5.tech.numericable.fr ([82.216.111.41]:39075 "EHLO
	smtp5.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964972Ab2CTIyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:54:10 -0400
From: Corentin Chary <corentin.chary@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, AceLan Kao <acelan.kao@canonical.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 08/14] asus-wmi: add scalar board brightness adj. support
Date: Tue, 20 Mar 2012 09:53:08 +0100
Message-Id: <1332233594-13099-9-git-send-email-corentin.chary@gmail.com>
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

Some ASUS ET2012E/I All-in-One machines that use a scalar board
to control the brightness, and they only accept brightness up and down
command. So, I introduced a get_scalar_command() function to pass the
command to the scalar board through WMI.

Besides, we have to store the brightness value locally, for we need the
old value to know the brightness value is increasing or decreasing.

BTW, since there is no way to retrieve the actual brightness(it would be
a fixed value), and the max brightness value would be fixed to 1, so we
have to keep passing the brightness up/down command when we reached the
max brightness value or 0.

Signed-off-by: AceLan Kao <acelan.kao@canonical.com>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-nb-wmi.c |    2 +-
 drivers/platform/x86/asus-wmi.c    |   33 ++++++++++++--
 drivers/platform/x86/asus-wmi.h    |   10 +++-
 drivers/platform/x86/eeepc-wmi.c   |   85 +++++++++++++++++++++++++-----------
 4 files changed, 97 insertions(+), 33 deletions(-)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 3501127..1aea6b8 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -101,7 +101,7 @@ static struct asus_wmi_driver asus_nb_wmi_driver = {
 	.keymap = asus_nb_wmi_keymap,
 	.input_name = "Asus WMI hotkeys",
 	.input_phys = ASUS_NB_WMI_FILE "/input0",
-	.quirks = asus_nb_wmi_quirks,
+	.detect_quirks = asus_nb_wmi_quirks,
 };
 
 
diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 2b88347..eb114f8 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -784,7 +784,8 @@ static int asus_new_rfkill(struct asus_wmi *asus,
 	arfkill->dev_id = dev_id;
 	arfkill->asus = asus;
 
-	if (dev_id == ASUS_WMI_DEVID_WLAN && asus->driver->hotplug_wireless)
+	if (dev_id == ASUS_WMI_DEVID_WLAN &&
+	    asus->driver->quirks->hotplug_wireless)
 		*rfkill = rfkill_alloc(name, &asus->platform_device->dev, type,
 				       &asus_rfkill_wlan_ops, arfkill);
 	else
@@ -895,7 +896,7 @@ static int asus_wmi_rfkill_init(struct asus_wmi *asus)
 	if (result && result != -ENODEV)
 		goto exit;
 
-	if (!asus->driver->hotplug_wireless)
+	if (!asus->driver->quirks->hotplug_wireless)
 		goto exit;
 
 	result = asus_setup_pci_hotplug(asus);
@@ -1116,13 +1117,33 @@ static int read_brightness(struct backlight_device *bd)
 	return retval & ASUS_WMI_DSTS_BRIGHTNESS_MASK;
 }
 
+static u32 get_scalar_command(struct backlight_device *bd)
+{
+	struct asus_wmi *asus = bl_get_data(bd);
+	u32 ctrl_param = 0;
+
+	if ((asus->driver->brightness < bd->props.brightness) ||
+	    bd->props.brightness == bd->props.max_brightness)
+		ctrl_param = 0x00008001;
+	else if ((asus->driver->brightness > bd->props.brightness) ||
+		 bd->props.brightness == 0)
+		ctrl_param = 0x00008000;
+
+	asus->driver->brightness = bd->props.brightness;
+
+	return ctrl_param;
+}
+
 static int update_bl_status(struct backlight_device *bd)
 {
 	struct asus_wmi *asus = bl_get_data(bd);
 	u32 ctrl_param;
 	int power, err;
 
-	ctrl_param = bd->props.brightness;
+	if (asus->driver->quirks->scalar_panel_brightness)
+		ctrl_param = get_scalar_command(bd);
+	else
+		ctrl_param = bd->props.brightness;
 
 	err = asus_wmi_set_devstate(ASUS_WMI_DEVID_BRIGHTNESS,
 				    ctrl_param, NULL);
@@ -1200,6 +1221,8 @@ static int asus_wmi_backlight_init(struct asus_wmi *asus)
 	bd->props.power = power;
 	backlight_update_status(bd);
 
+	asus->driver->brightness = bd->props.brightness;
+
 	return 0;
 }
 
@@ -1622,8 +1645,8 @@ static int asus_wmi_add(struct platform_device *pdev)
 	wdrv->platform_device = pdev;
 	platform_set_drvdata(asus->platform_device, asus);
 
-	if (wdrv->quirks)
-		wdrv->quirks(asus->driver);
+	if (wdrv->detect_quirks)
+		wdrv->detect_quirks(asus->driver);
 
 	err = asus_wmi_platform_init(asus);
 	if (err)
diff --git a/drivers/platform/x86/asus-wmi.h b/drivers/platform/x86/asus-wmi.h
index 8147c10..ac7dd4e 100644
--- a/drivers/platform/x86/asus-wmi.h
+++ b/drivers/platform/x86/asus-wmi.h
@@ -35,9 +35,14 @@ struct module;
 struct key_entry;
 struct asus_wmi;
 
+struct quirk_entry {
+	bool hotplug_wireless;
+	bool scalar_panel_brightness;
+};
+
 struct asus_wmi_driver {
-	bool			hotplug_wireless;
 	int			wapf;
+	int			brightness;
 
 	const char		*name;
 	struct module		*owner;
@@ -47,13 +52,14 @@ struct asus_wmi_driver {
 	const struct key_entry	*keymap;
 	const char		*input_name;
 	const char		*input_phys;
+	struct quirk_entry	*quirks;
 	/* Returns new code, value, and autorelease values in arguments.
 	 * Return ASUS_WMI_KEY_IGNORE in code if event should be ignored. */
 	void (*key_filter) (struct asus_wmi_driver *driver, int *code,
 			    unsigned int *value, bool *autorelease);
 
 	int (*probe) (struct platform_device *device);
-	void (*quirks) (struct asus_wmi_driver *driver);
+	void (*detect_quirks) (struct asus_wmi_driver *driver);
 
 	struct platform_driver	platform_driver;
 	struct platform_device *platform_device;
diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 1d91eb2..67186e6 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -48,6 +48,7 @@ MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("wmi:"EEEPC_WMI_EVENT_GUID);
 
+static struct quirk_entry *quirks;
 static bool hotplug_wireless;
 
 module_param(hotplug_wireless, bool, 0444);
@@ -90,6 +91,60 @@ static const struct key_entry eeepc_wmi_keymap[] = {
 	{ KE_END, 0},
 };
 
+static struct quirk_entry quirk_asus_unknown = {
+};
+
+static struct quirk_entry quirk_asus_1000h = {
+	.hotplug_wireless = true,
+};
+
+static struct quirk_entry quirk_asus_et2012_type3 = {
+	.scalar_panel_brightness = true,
+};
+
+static int dmi_matched(const struct dmi_system_id *dmi)
+{
+	char *model;
+	quirks = dmi->driver_data;
+
+	model = (char *)dmi->matches[1].substr;
+	if (unlikely(strncmp(model, "ET2012", 6) == 0)) {
+		const struct dmi_device *dev = NULL;
+		char oemstring[30];
+		while ((dev = dmi_find_device(DMI_DEV_TYPE_OEM_STRING, NULL,
+					      dev))) {
+			if (sscanf(dev->name, "AEMS%24c", oemstring) == 1) {
+				if (oemstring[18] == '3')
+					quirks = &quirk_asus_et2012_type3;
+				break;
+			}
+		}
+	}
+	return 1;
+}
+
+static struct dmi_system_id asus_quirks[] = {
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK Computer INC. 1000H",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "1000H"),
+		},
+		.driver_data = &quirk_asus_1000h,
+	},
+	{
+		.callback = dmi_matched,
+		.ident = "ASUSTeK Computer INC. ET2012E/I",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK Computer INC."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "ET2012"),
+		},
+		.driver_data = &quirk_asus_unknown,
+	},
+	{},
+};
+
 static void eeepc_wmi_key_filter(struct asus_wmi_driver *asus_wmi, int *code,
 				 unsigned int *value, bool *autorelease)
 {
@@ -144,33 +199,13 @@ static int eeepc_wmi_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void eeepc_dmi_check(struct asus_wmi_driver *driver)
-{
-	const char *model;
-
-	model = dmi_get_system_info(DMI_PRODUCT_NAME);
-	if (!model)
-		return;
-
-	/*
-	 * Whitelist for wlan hotplug
-	 *
-	 * Asus 1000H needs the current hotplug code to handle
-	 * Fn+F2 correctly. We may add other Asus here later, but
-	 * it seems that most of the laptops supported by asus-wmi
-	 * don't need to be on this list
-	 */
-	if (strcmp(model, "1000H") == 0) {
-		driver->hotplug_wireless = true;
-		pr_info("wlan hotplug enabled\n");
-	}
-}
-
 static void eeepc_wmi_quirks(struct asus_wmi_driver *driver)
 {
-	driver->hotplug_wireless = hotplug_wireless;
 	driver->wapf = -1;
-	eeepc_dmi_check(driver);
+	driver->quirks = &quirk_asus_unknown;
+	driver->quirks->hotplug_wireless = hotplug_wireless;
+	dmi_check_system(asus_quirks);
+	driver->quirks = quirks;
 }
 
 static struct asus_wmi_driver asus_wmi_driver = {
@@ -182,7 +217,7 @@ static struct asus_wmi_driver asus_wmi_driver = {
 	.input_phys = EEEPC_WMI_FILE "/input0",
 	.key_filter = eeepc_wmi_key_filter,
 	.probe = eeepc_wmi_probe,
-	.quirks = eeepc_wmi_quirks,
+	.detect_quirks = eeepc_wmi_quirks,
 };
 
 
-- 
1.7.3.4

