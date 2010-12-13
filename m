Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0LMKBA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:01:00 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34936 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0LMKA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:00:57 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 4/6] ideapad: add markups, unify comments and return result when init
Date: Mon, 13 Dec 2010 18:00:48 +0800
Message-Id: <1292234448-2715-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
References: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Add markups on init and exit functions
2. Unify the comments in the same style
3. Return result when module initial

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   31 +++++++++++++++++--------------
 1 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 04b4f5b..3c6c5b5 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1,5 +1,5 @@
 /*
- *  ideapad_acpi.c - Lenovo IdeaPad ACPI Extras
+ *  ideapad-laptop.c - Lenovo IdeaPad ACPI Extras
  *
  *  Copyright © 2010 Intel Corporation
  *  Copyright © 2010 David Woodhouse <dwmw2@infradead.org>
@@ -168,8 +168,10 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
 	pr_err("timeout in write_ec_cmd\n");
 	return -1;
 }
-/* the above is ACPI helpers */
 
+/*
+ * camera power
+ */
 static ssize_t show_ideapad_cam(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
@@ -203,6 +205,9 @@ static ssize_t store_ideapad_cam(struct device *dev,
 
 static DEVICE_ATTR(camera_power, 0644, show_ideapad_cam, store_ideapad_cam);
 
+/*
+ * Rfkill
+ */
 static int ideapad_rfk_set(void *data, bool blocked)
 {
 	int device = (unsigned long)data;
@@ -235,7 +240,8 @@ static void ideapad_sync_rfk_state(struct acpi_device *adevice)
 			rfkill_set_hw_state(priv->rfk[i], hw_blocked);
 }
 
-static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
+static int __devinit ideapad_register_rfkill(struct acpi_device *adevice,
+					     int dev)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int ret;
@@ -271,7 +277,8 @@ static int ideapad_register_rfkill(struct acpi_device *adevice, int dev)
 	return 0;
 }
 
-static void ideapad_unregister_rfkill(struct acpi_device *adevice, int dev)
+static void __devexit ideapad_unregister_rfkill(struct acpi_device *adevice,
+						int dev)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 
@@ -326,7 +333,6 @@ static void ideapad_platform_exit(void)
 			   &ideapad_attribute_group);
 	platform_device_unregister(ideapad_priv->platform_device);
 }
-/* the above is platform device */
 
 /*
  * input device
@@ -386,15 +392,17 @@ static void ideapad_input_report(unsigned long scancode)
 {
 	sparse_keymap_report_event(ideapad_priv->inputdev, scancode, 1, true);
 }
-/* the above is input device */
 
+/*
+ * module init/exit
+ */
 static const struct acpi_device_id ideapad_device_ids[] = {
 	{ "VPC2004", 0},
 	{ "", 0},
 };
 MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 
-static int ideapad_acpi_add(struct acpi_device *adevice)
+static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 {
 	int ret, i, cfg;
 	struct ideapad_private *priv;
@@ -432,7 +440,7 @@ platform_failed:
 	return ret;
 }
 
-static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
+static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int i;
@@ -478,19 +486,14 @@ static struct acpi_driver ideapad_acpi_driver = {
 	.owner = THIS_MODULE,
 };
 
-
 static int __init ideapad_acpi_module_init(void)
 {
-	acpi_bus_register_driver(&ideapad_acpi_driver);
-
-	return 0;
+	return acpi_bus_register_driver(&ideapad_acpi_driver);
 }
 
-
 static void __exit ideapad_acpi_module_exit(void)
 {
 	acpi_bus_unregister_driver(&ideapad_acpi_driver);
-
 }
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
-- 
1.7.1

