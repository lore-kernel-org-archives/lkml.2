Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab0LMKAr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:00:47 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34799 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443Ab0LMKAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:00:45 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 3/6] ideapad: add hotkey support
Date: Mon, 13 Dec 2010 18:00:38 +0800
Message-Id: <1292234438-2686-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
References: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hotkey enabled by this patch:
  Fn+F3: Video mode switch
  Fn+F5: software rfkill for wifi

For some ideapad when push Fn+F3, hardware generates Super-P keys, those key
will not be enabled by this patch.

Thanks for Dave Hansen report the problem. If CONFIG_INPUT_SPARSEKMAP is not
set, when building, you will have error message:

  ERROR: "sparse_keymap_setup" [drivers/platform/x86/ideapad-laptop.ko] undefined!
  ERROR: "sparse_keymap_free" [drivers/platform/x86/ideapad-laptop.ko] undefined!
  ERROR: "sparse_keymap_report_event" [drivers/platform/x86/ideapad-laptop.ko] undefined!

To select INPUT_SPARSEKMAP solve this issue.

Ref: http://lkml.org/lkml/2010/12/2/340

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/Kconfig          |    1 +
 drivers/platform/x86/ideapad-laptop.c |   72 +++++++++++++++++++++++++++++++++
 2 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index faec777..879d266 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -226,6 +226,7 @@ config IDEAPAD_LAPTOP
 	tristate "Lenovo IdeaPad Laptop Extras"
 	depends on ACPI
 	depends on RFKILL
+	select INPUT_SPARSEKMAP
 	help
 	  This is a driver for the rfkill switches on Lenovo IdeaPad netbooks.
 
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 49f207f..04b4f5b 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -28,6 +28,8 @@
 #include <acpi/acpi_drivers.h>
 #include <linux/rfkill.h>
 #include <linux/platform_device.h>
+#include <linux/input.h>
+#include <linux/input/sparse-keymap.h>
 
 #define IDEAPAD_DEV_CAMERA	0
 #define IDEAPAD_DEV_WLAN	1
@@ -39,6 +41,7 @@ struct ideapad_private {
 	acpi_handle handle;
 	struct rfkill *rfk[5];
 	struct platform_device *platform_device;
+	struct input_dev *inputdev;
 } *ideapad_priv;
 
 static struct {
@@ -325,6 +328,66 @@ static void ideapad_platform_exit(void)
 }
 /* the above is platform device */
 
+/*
+ * input device
+ */
+static const struct key_entry ideapad_keymap[] = {
+	{ KE_KEY, 0x06, { KEY_SWITCHVIDEOMODE } },
+	{ KE_KEY, 0x0D, { KEY_WLAN } },
+	{ KE_END, 0 },
+};
+
+static int __devinit ideapad_input_init(void)
+{
+	struct input_dev *inputdev;
+	int error;
+
+	inputdev = input_allocate_device();
+	if (!inputdev) {
+		pr_info("Unable to allocate input device\n");
+		return -ENOMEM;
+	}
+
+	inputdev->name = "Ideapad extra buttons";
+	inputdev->phys = "ideapad/input0";
+	inputdev->id.bustype = BUS_HOST;
+	inputdev->dev.parent = &ideapad_priv->platform_device->dev;
+
+	error = sparse_keymap_setup(inputdev, ideapad_keymap, NULL);
+	if (error) {
+		pr_err("Unable to setup input device keymap\n");
+		goto err_free_dev;
+	}
+
+	error = input_register_device(inputdev);
+	if (error) {
+		pr_err("Unable to register input device\n");
+		goto err_free_keymap;
+	}
+
+	ideapad_priv->inputdev = inputdev;
+	return 0;
+
+err_free_keymap:
+	sparse_keymap_free(inputdev);
+err_free_dev:
+	input_free_device(inputdev);
+	return error;
+}
+
+static void __devexit ideapad_input_exit(void)
+{
+	sparse_keymap_free(ideapad_priv->inputdev);
+	input_unregister_device(ideapad_priv->inputdev);
+	ideapad_priv->inputdev = NULL;
+}
+
+static void ideapad_input_report(unsigned long scancode)
+{
+	sparse_keymap_report_event(ideapad_priv->inputdev, scancode, 1, true);
+}
+/* the above is input device */
+
 static const struct acpi_device_id ideapad_device_ids[] = {
 	{ "VPC2004", 0},
 	{ "", 0},
@@ -350,6 +413,10 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 	if (ret)
 		goto platform_failed;
 
+	ret = ideapad_input_init();
+	if (ret)
+		goto input_failed;
+
 	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++) {
 		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
 			ideapad_register_rfkill(adevice, i);
@@ -358,6 +425,8 @@ static int ideapad_acpi_add(struct acpi_device *adevice)
 
 	return 0;
 
+input_failed:
+	ideapad_platform_exit();
 platform_failed:
 	kfree(priv);
 	return ret;
@@ -370,6 +439,7 @@ static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
 
 	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++)
 		ideapad_unregister_rfkill(adevice, i);
+	ideapad_input_exit();
 	ideapad_platform_exit();
 	dev_set_drvdata(&adevice->dev, NULL);
 	kfree(priv);
@@ -392,6 +462,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
 		if (test_bit(vpc_bit, &vpc1)) {
 			if (vpc_bit == 9)
 				ideapad_sync_rfk_state(adevice);
+			else
+				ideapad_input_report(vpc_bit);
 		}
 	}
 }
-- 
1.7.1

