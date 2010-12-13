Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0LMKBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:01:20 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35276 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab0LMKBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:01:17 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 5/6] ideapad: pass ideapad_priv as argument (part 1)
Date: Mon, 13 Dec 2010 18:01:01 +0800
Message-Id: <1292234461-2744-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
References: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing ideapad_priv as argument and try not to using too much global variable.
This is part 1 for platform driver and input device.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   54 +++++++++++++++++----------------
 1 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 3c6c5b5..37fe0d0 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -301,37 +301,37 @@ static struct attribute_group ideapad_attribute_group = {
 	.attrs = ideapad_attributes
 };
 
-static int __devinit ideapad_platform_init(void)
+static int __devinit ideapad_platform_init(struct ideapad_private *priv)
 {
 	int result;
 
-	ideapad_priv->platform_device = platform_device_alloc("ideapad", -1);
-	if (!ideapad_priv->platform_device)
+	priv->platform_device = platform_device_alloc("ideapad", -1);
+	if (!priv->platform_device)
 		return -ENOMEM;
-	platform_set_drvdata(ideapad_priv->platform_device, ideapad_priv);
+	platform_set_drvdata(priv->platform_device, priv);
 
-	result = platform_device_add(ideapad_priv->platform_device);
+	result = platform_device_add(priv->platform_device);
 	if (result)
 		goto fail_platform_device;
 
-	result = sysfs_create_group(&ideapad_priv->platform_device->dev.kobj,
+	result = sysfs_create_group(&priv->platform_device->dev.kobj,
 				    &ideapad_attribute_group);
 	if (result)
 		goto fail_sysfs;
 	return 0;
 
 fail_sysfs:
-	platform_device_del(ideapad_priv->platform_device);
+	platform_device_del(priv->platform_device);
 fail_platform_device:
-	platform_device_put(ideapad_priv->platform_device);
+	platform_device_put(priv->platform_device);
 	return result;
 }
 
-static void ideapad_platform_exit(void)
+static void ideapad_platform_exit(struct ideapad_private *priv)
 {
-	sysfs_remove_group(&ideapad_priv->platform_device->dev.kobj,
+	sysfs_remove_group(&priv->platform_device->dev.kobj,
 			   &ideapad_attribute_group);
-	platform_device_unregister(ideapad_priv->platform_device);
+	platform_device_unregister(priv->platform_device);
 }
 
 /*
@@ -343,7 +343,7 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_END, 0 },
 };
 
-static int __devinit ideapad_input_init(void)
+static int __devinit ideapad_input_init(struct ideapad_private *priv)
 {
 	struct input_dev *inputdev;
 	int error;
@@ -357,7 +357,7 @@ static int __devinit ideapad_input_init(void)
 	inputdev->name = "Ideapad extra buttons";
 	inputdev->phys = "ideapad/input0";
 	inputdev->id.bustype = BUS_HOST;
-	inputdev->dev.parent = &ideapad_priv->platform_device->dev;
+	inputdev->dev.parent = &priv->platform_device->dev;
 
 	error = sparse_keymap_setup(inputdev, ideapad_keymap, NULL);
 	if (error) {
@@ -371,7 +371,7 @@ static int __devinit ideapad_input_init(void)
 		goto err_free_keymap;
 	}
 
-	ideapad_priv->inputdev = inputdev;
+	priv->inputdev = inputdev;
 	return 0;
 
 err_free_keymap:
@@ -381,16 +381,17 @@ err_free_dev:
 	return error;
 }
 
-static void __devexit ideapad_input_exit(void)
+static void __devexit ideapad_input_exit(struct ideapad_private *priv)
 {
-	sparse_keymap_free(ideapad_priv->inputdev);
-	input_unregister_device(ideapad_priv->inputdev);
-	ideapad_priv->inputdev = NULL;
+	sparse_keymap_free(priv->inputdev);
+	input_unregister_device(priv->inputdev);
+	priv->inputdev = NULL;
 }
 
-static void ideapad_input_report(unsigned long scancode)
+static void ideapad_input_report(struct ideapad_private *priv,
+				 unsigned long scancode)
 {
-	sparse_keymap_report_event(ideapad_priv->inputdev, scancode, 1, true);
+	sparse_keymap_report_event(priv->inputdev, scancode, 1, true);
 }
 
 /*
@@ -417,11 +418,11 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 	priv->handle = adevice->handle;
 	dev_set_drvdata(&adevice->dev, priv);
 
-	ret = ideapad_platform_init();
+	ret = ideapad_platform_init(priv);
 	if (ret)
 		goto platform_failed;
 
-	ret = ideapad_input_init();
+	ret = ideapad_input_init(priv);
 	if (ret)
 		goto input_failed;
 
@@ -434,7 +435,7 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 	return 0;
 
 input_failed:
-	ideapad_platform_exit();
+	ideapad_platform_exit(priv);
 platform_failed:
 	kfree(priv);
 	return ret;
@@ -447,8 +448,8 @@ static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
 
 	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++)
 		ideapad_unregister_rfkill(adevice, i);
-	ideapad_input_exit();
-	ideapad_platform_exit();
+	ideapad_input_exit(priv);
+	ideapad_platform_exit(priv);
 	dev_set_drvdata(&adevice->dev, NULL);
 	kfree(priv);
 
@@ -457,6 +458,7 @@ static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
 
 static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 {
+	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	acpi_handle handle = adevice->handle;
 	unsigned long vpc1, vpc2, vpc_bit;
 
@@ -471,7 +473,7 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 			if (vpc_bit == 9)
 				ideapad_sync_rfk_state(adevice);
 			else
-				ideapad_input_report(vpc_bit);
+				ideapad_input_report(priv, vpc_bit);
 		}
 	}
 }
-- 
1.7.1

