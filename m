Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759760Ab0KQHAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 02:00:23 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56178 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab0KQHAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 02:00:22 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 1/3] ideapad: add platform driver for ideapad
Date: Wed, 17 Nov 2010 15:00:16 +0800
Message-Id: <1289977216-14989-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289977165-14802-1-git-send-email-ike.pan@canonical.com>
References: <1289977165-14802-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create /sys/devices/platform/Ideapad for nodes of ideapad landing.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   59 ++++++++++++++++++++++++++------
 1 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 5ff1220..26edbdb 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -27,6 +27,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <linux/rfkill.h>
+#include <linux/platform_device.h>
 
 #define IDEAPAD_DEV_CAMERA	0
 #define IDEAPAD_DEV_WLAN	1
@@ -37,6 +38,7 @@
 struct ideapad_private {
 	acpi_handle handle;
 	struct rfkill *rfk[5];
+	struct platform_device *platform_device;
 } *ideapad_priv;
 
 static struct {
@@ -277,6 +279,35 @@ static void ideapad_unregister_rfkill(struct acpi_device *adevice, int dev)
 	rfkill_destroy(priv->rfk[dev]);
 }
 
+/*
+ * Platform device
+ */
+static int ideapad_platform_init(void)
+{
+	int result;
+
+	ideapad_priv->platform_device = platform_device_alloc("Ideapad", -1);
+	if (!ideapad_priv->platform_device)
+		return -ENOMEM;
+	platform_set_drvdata(ideapad_priv->platform_device, ideapad_priv);
+
+	result = platform_device_add(ideapad_priv->platform_device);
+	if (result)
+		goto fail_platform_device;
+
+	return 0;
+
+fail_platform_device:
+	platform_device_put(ideapad_priv->platform_device);
+	return result;
+}
+
+static void ideapad_platform_exit(void)
+{
+	platform_device_unregister(ideapad_priv->platform_device);
+}
+/* the above is platform device */
+
 static const struct acpi_device_id ideapad_device_ids[] = {
 	{ "VPC2004", 0},
 	{ "", 0},
@@ -285,7 +316,7 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
 static int ideapad_acpi_add(struct acpi_device *adevice)
 {
-	int i, cfg;
+	int ret, i, cfg;
 	int devs_present[5];
 	struct ideapad_private *priv;
 
@@ -305,18 +336,20 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	ideapad_priv = priv;
+
+	ret = ideapad_platform_init();
+	if (ret)
+		goto platform_failed;
 
 	if (devs_present[IDEAPAD_DEV_CAMERA]) {
-		int ret = device_create_file(&adevice->dev, &dev_attr_camera_power);
-		if (ret) {
-			kfree(priv);
-			return ret;
-		}
+		ret = device_create_file(&adevice->dev, &dev_attr_camera_power);
+		if (ret)
+			goto camera_failed;
 	}
 
 	priv->handle = adevice->handle;
 	dev_set_drvdata(&adevice->dev, priv);
-	ideapad_priv = priv;
 	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++) {
 		if (!devs_present[i])
 			continue;
@@ -325,6 +358,12 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 	}
 	ideapad_sync_rfk_state(adevice);
 	return 0;
+
+camera_failed:
+	ideapad_platform_exit();
+platform_failed:
+	kfree(priv);
+	return ret;
 }
 
 static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
@@ -337,6 +376,7 @@ static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
 	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++)
 		ideapad_unregister_rfkill(adevice, i);
 
+	ideapad_platform_exit();
 	dev_set_drvdata(&adevice->dev, NULL);
 	kfree(priv);
 	return 0;
@@ -374,16 +414,13 @@ static struct acpi_driver ideapad_acpi_driver = {
 
 static int __init ideapad_acpi_module_init(void)
 {
-	acpi_bus_register_driver(&ideapad_acpi_driver);
-
-	return 0;
+	return acpi_bus_register_driver(&ideapad_acpi_driver);
 }
 
 
 static void __exit ideapad_acpi_module_exit(void)
 {
 	acpi_bus_unregister_driver(&ideapad_acpi_driver);
-
 }
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-- 
1.7.1

