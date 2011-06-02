Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958Ab1FBJWm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:22:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:39558 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab1FBJWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:22:40 -0400
From: Ike Panhc <ike.pan@canonical.com>
To: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 1/3] ideapad: Use define for cfg bits
Date: Thu,  2 Jun 2011 17:22:33 +0800
Message-Id: <1307006553-12667-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

instead of hard code the number.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   19 +++++++++++++------
 1 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index bfdda33..a5c0efa 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -35,10 +35,15 @@
 
 #define IDEAPAD_RFKILL_DEV_NUM	(3)
 
+#define CFG_BT_BIT	(16)
+#define CFG_3G_BIT	(17)
+#define CFG_WIFI_BIT	(18)
+
 struct ideapad_private {
 	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
 	struct platform_device *platform_device;
 	struct input_dev *inputdev;
+	unsigned long	cfg;
 };
 
 static acpi_handle ideapad_handle;
@@ -197,9 +202,9 @@ struct ideapad_rfk_data {
 };
 
 const struct ideapad_rfk_data ideapad_rfk_data[] = {
-	{ "ideapad_wlan",	18, 0x15, RFKILL_TYPE_WLAN },
-	{ "ideapad_bluetooth",	16, 0x17, RFKILL_TYPE_BLUETOOTH },
-	{ "ideapad_3g",		17, 0x20, RFKILL_TYPE_WWAN },
+	{ "ideapad_wlan",	CFG_WIFI_BIT,	0x15, RFKILL_TYPE_WLAN },
+	{ "ideapad_bluetooth",	CFG_BT_BIT,	0x17, RFKILL_TYPE_BLUETOOTH },
+	{ "ideapad_3g",		CFG_3G_BIT,	0x20, RFKILL_TYPE_WWAN },
 };
 
 static int ideapad_rfk_set(void *data, bool blocked)
@@ -393,10 +398,11 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
 static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 {
-	int ret, i, cfg;
+	int ret, i;
+	unsigned long cfg;
 	struct ideapad_private *priv;
 
-	if (read_method_int(adevice->handle, "_CFG", &cfg))
+	if (read_method_int(adevice->handle, "_CFG", (int *)&cfg))
 		return -ENODEV;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -404,6 +410,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 		return -ENOMEM;
 	dev_set_drvdata(&adevice->dev, priv);
 	ideapad_handle = adevice->handle;
+	priv->cfg = cfg;
 
 	ret = ideapad_platform_init(priv);
 	if (ret)
@@ -414,7 +421,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 		goto input_failed;
 
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++) {
-		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
+		if (test_bit(ideapad_rfk_data[i].cfgbit, &cfg))
 			ideapad_register_rfkill(adevice, i);
 		else
 			priv->rfk[i] = NULL;
-- 
1.7.4.1

