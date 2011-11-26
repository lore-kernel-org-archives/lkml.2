Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1KZKCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 05:02:32 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:43782 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754065Ab1KZKBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 05:01:22 -0500
From: Corentin Chary <corentincj@iksaif.net>
To: platform-driver-x86@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
        Corentin Chary <corentincj@iksaif.net>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/16] samsung-laptop: add true rfkill support for swsmi
Date: Sat, 26 Nov 2011 11:00:09 +0100
Message-Id: <1322301613-8801-13-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
References: <1322301613-8801-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wireless status get and get commands seems to use one
byte per device. First byte is for wlan and third is for bluetooh,
we will have to find what the other are for.

Signed-off-by: Corentin Chary <corentincj@iksaif.net>
---
 drivers/platform/x86/samsung-laptop.c |  209 ++++++++++++++++++++++++++++-----
 1 files changed, 178 insertions(+), 31 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index 4a46a7b..931b964 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -45,6 +45,9 @@
 #define SABI_IFACE_COMPLETE		0x04
 #define SABI_IFACE_DATA			0x05
 
+#define WL_STATUS_WLAN			0x0
+#define WL_STATUS_BT			0x2
+
 /* Structure get/set data using sabi */
 struct sabi_data {
 	union {
@@ -113,6 +116,10 @@ struct sabi_commands {
 	u16 get_usb_charge;
 	u16 set_usb_charge;
 
+	/* the first byte is for bluetooth and the third one is for wlan */
+	u16 get_wireless_status;
+	u16 set_wireless_status;
+
 	/* 0x81 to read, (0x82 | level << 8) to set, 0xaabb to enable */
 	u16 kbd_backlight;
 
@@ -129,6 +136,7 @@ struct sabi_performance_level {
 };
 
 struct sabi_config {
+	int sabi_version;
 	const char *test_string;
 	u16 main_function;
 	const struct sabi_header_offsets header_offsets;
@@ -140,6 +148,10 @@ struct sabi_config {
 
 static const struct sabi_config sabi_configs[] = {
 	{
+		/* I don't know if it is really 2, but it it is
+		 * less than 3 anyway */
+		.sabi_version = 2,
+
 		.test_string = "SECLINUX",
 
 		.main_function = 0x4c49,
@@ -175,6 +187,9 @@ static const struct sabi_config sabi_configs[] = {
 			.get_usb_charge = 0xFFFF,
 			.set_usb_charge = 0xFFFF,
 
+			.get_wireless_status = 0xFFFF,
+			.set_wireless_status = 0xFFFF,
+
 			.kbd_backlight = 0xFFFF,
 
 			.set_linux = 0x0a,
@@ -195,6 +210,8 @@ static const struct sabi_config sabi_configs[] = {
 		.max_brightness = 8,
 	},
 	{
+		.sabi_version = 3,
+
 		.test_string = "SwSmi@",
 
 		.main_function = 0x5843,
@@ -230,6 +247,9 @@ static const struct sabi_config sabi_configs[] = {
 			.get_usb_charge = 0x67,
 			.set_usb_charge = 0x68,
 
+			.get_wireless_status = 0x69,
+			.set_wireless_status = 0x6a,
+
 			.kbd_backlight = 0x78,
 
 			.set_linux = 0xff,
@@ -285,6 +305,14 @@ struct samsung_laptop_debug {
 	struct debugfs_blob_wrapper data_wrapper;
 };
 
+struct samsung_laptop;
+
+struct samsung_rfkill {
+	struct samsung_laptop *samsung;
+	struct rfkill *rfkill;
+	enum rfkill_type type;
+};
+
 struct samsung_laptop {
 	const struct sabi_config *config;
 
@@ -296,7 +324,9 @@ struct samsung_laptop {
 
 	struct platform_device *platform_device;
 	struct backlight_device *backlight_device;
-	struct rfkill *rfk;
+
+	struct samsung_rfkill wlan;
+	struct samsung_rfkill bluetooth;
 
 	struct led_classdev kbd_led;
 	int kbd_led_wk;
@@ -498,26 +528,78 @@ static const struct backlight_ops backlight_ops = {
 	.update_status	= update_status,
 };
 
-static int rfkill_set(void *data, bool blocked)
+static int seclinux_rfkill_set(void *data, bool blocked)
 {
 	struct samsung_laptop *samsung = data;
 	const struct sabi_commands *commands = &samsung->config->commands;
 
-	/* Do something with blocked...*/
-	/*
-	 * blocked == false is on
-	 * blocked == true is off
-	 */
-	if (blocked)
-		sabi_set_commandb(samsung, commands->set_wireless_button, 0);
+	return sabi_set_commandb(samsung, commands->set_wireless_button,
+				 !blocked);
+}
+
+static struct rfkill_ops seclinux_rfkill_ops = {
+	.set_block = seclinux_rfkill_set,
+};
+
+static int swsmi_wireless_status(struct samsung_laptop *samsung,
+				 struct sabi_data *data)
+{
+	const struct sabi_commands *commands = &samsung->config->commands;
+
+	return sabi_command(samsung, commands->get_wireless_status,
+			    NULL, data);
+}
+
+static int swsmi_rfkill_set(void *priv, bool blocked)
+{
+	struct samsung_rfkill *srfkill = priv;
+	struct samsung_laptop *samsung = srfkill->samsung;
+	const struct sabi_commands *commands = &samsung->config->commands;
+	struct sabi_data data;
+	int ret, i;
+
+	ret = swsmi_wireless_status(samsung, &data);
+	if (ret)
+		return ret;
+
+	/* Don't set the state for non-present devices */
+	for (i = 0; i < 4; i++)
+		if (data.data[i] == 0x02)
+			data.data[1] = 0;
+
+	if (srfkill->type == RFKILL_TYPE_WLAN)
+		data.data[WL_STATUS_WLAN] = !blocked;
+	else if (srfkill->type == RFKILL_TYPE_BLUETOOTH)
+		data.data[WL_STATUS_BT] = !blocked;
+
+	return sabi_command(samsung, commands->set_wireless_status,
+			    &data, &data);
+}
+
+static void swsmi_rfkill_query(struct rfkill *rfkill, void *priv)
+{
+	struct samsung_rfkill *srfkill = priv;
+	struct samsung_laptop *samsung = srfkill->samsung;
+	struct sabi_data data;
+	int ret;
+
+	ret = swsmi_wireless_status(samsung, &data);
+	if (ret)
+		return ;
+
+	if (srfkill->type == RFKILL_TYPE_WLAN)
+		ret = data.data[WL_STATUS_WLAN];
+	else if (srfkill->type == RFKILL_TYPE_BLUETOOTH)
+		ret = data.data[WL_STATUS_BT];
 	else
-		sabi_set_commandb(samsung, commands->set_wireless_button, 1);
+		return ;
 
-	return 0;
+	rfkill_set_sw_state(rfkill, !ret);
 }
 
-static struct rfkill_ops rfkill_ops = {
-	.set_block = rfkill_set,
+static struct rfkill_ops swsmi_rfkill_ops = {
+	.set_block = swsmi_rfkill_set,
+	.query = swsmi_rfkill_query,
 };
 
 static ssize_t get_performance_level(struct device *dev,
@@ -742,31 +824,96 @@ static int find_signature(void __iomem *memcheck, const char *testStr)
 
 static void samsung_rfkill_exit(struct samsung_laptop *samsung)
 {
-	if (samsung->rfk) {
-		rfkill_unregister(samsung->rfk);
-		rfkill_destroy(samsung->rfk);
-		samsung->rfk = NULL;
+	if (samsung->wlan.rfkill) {
+		rfkill_unregister(samsung->wlan.rfkill);
+		rfkill_destroy(samsung->wlan.rfkill);
+		samsung->wlan.rfkill = NULL;
+	}
+	if (samsung->bluetooth.rfkill) {
+		rfkill_unregister(samsung->bluetooth.rfkill);
+		rfkill_destroy(samsung->bluetooth.rfkill);
+		samsung->bluetooth.rfkill = NULL;
 	}
 }
 
-static int __init samsung_rfkill_init(struct samsung_laptop *samsung)
+static int samsung_new_rfkill(struct samsung_laptop *samsung,
+			      struct samsung_rfkill *arfkill,
+			      const char *name, enum rfkill_type type,
+			      const struct rfkill_ops *ops,
+			      int blocked)
 {
-	int retval;
+	struct rfkill **rfkill = &arfkill->rfkill;
+	int ret;
 
-	samsung->rfk = rfkill_alloc("samsung-wifi",
-				    &samsung->platform_device->dev,
-				    RFKILL_TYPE_WLAN,
-				    &rfkill_ops, samsung);
-	if (!samsung->rfk)
-		return -ENOMEM;
+	arfkill->type = type;
+	arfkill->samsung = samsung;
 
-	retval = rfkill_register(samsung->rfk);
-	if (retval) {
-		rfkill_destroy(samsung->rfk);
-		samsung->rfk = NULL;
-		return -ENODEV;
+	*rfkill = rfkill_alloc(name, &samsung->platform_device->dev,
+			       type, ops, arfkill);
+
+	if (!*rfkill)
+		return -EINVAL;
+
+	if (blocked != -1)
+		rfkill_init_sw_state(*rfkill, blocked);
+
+	ret = rfkill_register(*rfkill);
+	if (ret) {
+		rfkill_destroy(*rfkill);
+		*rfkill = NULL;
+		return ret;
 	}
+	return 0;
+}
+
+static int __init samsung_rfkill_init_seclinux(struct samsung_laptop *samsung)
+{
+	return samsung_new_rfkill(samsung, &samsung->wlan, "samsung-wlan",
+				  RFKILL_TYPE_WLAN, &seclinux_rfkill_ops, -1);
+}
 
+static int __init samsung_rfkill_init_swsmi(struct samsung_laptop *samsung)
+{
+	struct sabi_data data;
+	int ret;
+
+	ret = swsmi_wireless_status(samsung, &data);
+	if (ret)
+		return ret;
+
+	/* 0x02 seems to mean that the device is no present/available */
+
+	if (data.data[WL_STATUS_WLAN] != 0x02)
+		ret = samsung_new_rfkill(samsung, &samsung->wlan,
+					 "samsung-wlan",
+					 RFKILL_TYPE_WLAN,
+					 &swsmi_rfkill_ops,
+					 !data.data[WL_STATUS_WLAN]);
+	if (ret)
+		goto exit;
+
+	if (data.data[WL_STATUS_BT] != 0x02)
+		ret = samsung_new_rfkill(samsung, &samsung->bluetooth,
+					 "samsung-bluetooth",
+					 RFKILL_TYPE_BLUETOOTH,
+					 &swsmi_rfkill_ops,
+					 !data.data[WL_STATUS_BT]);
+	if (ret)
+		goto exit;
+
+exit:
+	if (ret)
+		samsung_rfkill_exit(samsung);
+
+	return ret;
+}
+
+static int __init samsung_rfkill_init(struct samsung_laptop *samsung)
+{
+	if (samsung->config->sabi_version == 2)
+		return samsung_rfkill_init_seclinux(samsung);
+	if (samsung->config->sabi_version == 3)
+		return samsung_rfkill_init_swsmi(samsung);
 	return 0;
 }
 
-- 
1.7.5.4

