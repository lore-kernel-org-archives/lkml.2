Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab1BFMaR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 07:30:17 -0500
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:42404 "EHLO
	relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1BFMaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 07:30:13 -0500
X-Originating-IP: 217.70.178.41
X-Originating-IP: 82.241.209.44
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Corentin Chary <corentincj@iksaif.net>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/18] eeepc-wmi: support backlight power (bl_power) attribute
Date: Sun,  6 Feb 2011 13:28:39 +0100
Message-Id: <1296995324-5462-15-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.4.rc3
In-Reply-To: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
References: <1296995324-5462-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/eeepc-wmi.c |   75 +++++++++++++++++++++++++++++++-------
 1 files changed, 61 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
index 75dd692..910eb00 100644
--- a/drivers/platform/x86/eeepc-wmi.c
+++ b/drivers/platform/x86/eeepc-wmi.c
@@ -73,13 +73,16 @@ MODULE_ALIAS("wmi:"EEEPC_WMI_MGMT_GUID);
 #define EEEPC_WMI_DEVID_BLUETOOTH	0x00010013
 #define EEEPC_WMI_DEVID_WIMAX		0x00010017
 #define EEEPC_WMI_DEVID_WWAN3G		0x00010019
-#define EEEPC_WMI_DEVID_BACKLIGHT	0x00050012
+#define EEEPC_WMI_DEVID_BACKLIGHT	0x00050011
+#define EEEPC_WMI_DEVID_BRIGHTNESS	0x00050012
 #define EEEPC_WMI_DEVID_CAMERA		0x00060013
 #define EEEPC_WMI_DEVID_CARDREADER	0x00080013
 #define EEEPC_WMI_DEVID_TPDLED		0x00100011
 
 #define EEEPC_WMI_DSTS_STATUS_BIT	0x00000001
 #define EEEPC_WMI_DSTS_PRESENCE_BIT	0x00010000
+#define EEEPC_WMI_DSTS_BRIGHTNESS_MASK	0x000000FF
+#define EEEPC_WMI_DSTS_MAX_BRIGTH_MASK	0x0000FF00
 
 static bool hotplug_wireless;
 
@@ -262,7 +265,7 @@ static acpi_status eeepc_wmi_set_devstate(u32 dev_id, u32 ctrl_param,
 }
 
 /* Helper for special devices with magic return codes */
-static int eeepc_wmi_get_devstate_simple(u32 dev_id)
+static int eeepc_wmi_get_devstate_bits(u32 dev_id, u32 mask)
 {
 	u32 retval = 0;
 	acpi_status status;
@@ -275,7 +278,12 @@ static int eeepc_wmi_get_devstate_simple(u32 dev_id)
 	if (!(retval & EEEPC_WMI_DSTS_PRESENCE_BIT))
 		return -ENODEV;
 
-	return retval & EEEPC_WMI_DSTS_STATUS_BIT;
+	return retval & mask;
+}
+
+static int eeepc_wmi_get_devstate_simple(u32 dev_id)
+{
+	return eeepc_wmi_get_devstate_bits(dev_id, EEEPC_WMI_DSTS_STATUS_BIT);
 }
 
 /*
@@ -770,34 +778,53 @@ exit:
 /*
  * Backlight
  */
+static int read_backlight_power(void)
+{
+	int ret = eeepc_wmi_get_devstate_simple(EEEPC_WMI_DEVID_BACKLIGHT);
+
+	if (ret < 0)
+		return ret;
+
+	return ret ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;
+}
+
 static int read_brightness(struct backlight_device *bd)
 {
 	u32 retval;
 	acpi_status status;
 
-	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_BACKLIGHT, &retval);
+	status = eeepc_wmi_get_devstate(EEEPC_WMI_DEVID_BRIGHTNESS, &retval);
 
 	if (ACPI_FAILURE(status))
-		return -1;
+		return -EIO;
 	else
-		return retval & 0xFF;
+		return retval & EEEPC_WMI_DSTS_BRIGHTNESS_MASK;
 }
 
 static int update_bl_status(struct backlight_device *bd)
 {
-
 	u32 ctrl_param;
 	acpi_status status;
+	int power;
 
 	ctrl_param = bd->props.brightness;
 
-	status = eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_BACKLIGHT,
+	status = eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_BRIGHTNESS,
 					ctrl_param, NULL);
 
 	if (ACPI_FAILURE(status))
-		return -1;
-	else
-		return 0;
+		return -EIO;
+
+	power = read_backlight_power();
+	if (power != -ENODEV && bd->props.power != power) {
+		ctrl_param = !!(bd->props.power == FB_BLANK_UNBLANK);
+		status = eeepc_wmi_set_devstate(EEEPC_WMI_DEVID_BACKLIGHT,
+						ctrl_param, NULL);
+
+		if (ACPI_FAILURE(status))
+			return -EIO;
+	}
+	return 0;
 }
 
 static const struct backlight_ops eeepc_wmi_bl_ops = {
@@ -827,9 +854,29 @@ static int eeepc_wmi_backlight_init(struct eeepc_wmi *eeepc)
 {
 	struct backlight_device *bd;
 	struct backlight_properties props;
+	int max;
+	int power;
+
+	max = eeepc_wmi_get_devstate_bits(EEEPC_WMI_DEVID_BRIGHTNESS,
+					  EEEPC_WMI_DSTS_MAX_BRIGTH_MASK);
+	power = read_backlight_power();
+
+	if (max < 0 && power < 0) {
+		/* Try to keep the original error */
+		if (max == -ENODEV && power == -ENODEV)
+			return -ENODEV;
+		if (max != -ENODEV)
+			return max;
+		else
+			return power;
+	}
+	if (max == -ENODEV)
+		max = 0;
+	if (power == -ENODEV)
+		power = FB_BLANK_UNBLANK;
 
 	memset(&props, 0, sizeof(struct backlight_properties));
-	props.max_brightness = 15;
+	props.max_brightness = max;
 	bd = backlight_device_register(EEEPC_WMI_FILE,
 				       &eeepc->platform_device->dev, eeepc,
 				       &eeepc_wmi_bl_ops, &props);
@@ -841,7 +888,7 @@ static int eeepc_wmi_backlight_init(struct eeepc_wmi *eeepc)
 	eeepc->backlight_device = bd;
 
 	bd->props.brightness = read_brightness(bd);
-	bd->props.power = FB_BLANK_UNBLANK;
+	bd->props.power = power;
 	backlight_update_status(bd);
 
 	return 0;
@@ -1202,7 +1249,7 @@ static int __init eeepc_wmi_add(struct platform_device *pdev)
 
 	if (!acpi_video_backlight_support()) {
 		err = eeepc_wmi_backlight_init(eeepc);
-		if (err)
+		if (err && err != -ENODEV)
 			goto fail_backlight;
 	} else
 		pr_info("Backlight controlled by ACPI video driver\n");
-- 
1.7.4.rc3

