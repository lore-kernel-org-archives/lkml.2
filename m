Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882Ab0LMKB1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:01:27 -0500
Received: from adelie.canonical.com ([91.189.90.139]:35377 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab0LMKBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:01:24 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 6/6] ideapad: pass ideapad_priv as argument (part 2)
Date: Mon, 13 Dec 2010 18:01:12 +0800
Message-Id: <1292234472-2773-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
References: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Passing ideapad_priv as argument and try not to using too much global variable.
This is part 2 for rfkill.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/ideapad-laptop.c |   71 +++++++++++++-------------------
 1 files changed, 29 insertions(+), 42 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 37fe0d0..114d952 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -31,32 +31,15 @@
 #include <linux/input.h>
 #include <linux/input/sparse-keymap.h>
 
-#define IDEAPAD_DEV_CAMERA	0
-#define IDEAPAD_DEV_WLAN	1
-#define IDEAPAD_DEV_BLUETOOTH	2
-#define IDEAPAD_DEV_3G		3
-#define IDEAPAD_DEV_KILLSW	4
+#define IDEAPAD_RFKILL_DEV_NUM	(3)
 
 struct ideapad_private {
-	acpi_handle handle;
-	struct rfkill *rfk[5];
+	struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
 	struct platform_device *platform_device;
 	struct input_dev *inputdev;
-} *ideapad_priv;
-
-static struct {
-	char *name;
-	int cfgbit;
-	int opcode;
-	int type;
-} ideapad_rfk_data[] = {
-	{ "ideapad_camera",	19, 0x1E, NUM_RFKILL_TYPES },
-	{ "ideapad_wlan",	18, 0x15, RFKILL_TYPE_WLAN },
-	{ "ideapad_bluetooth",	16, 0x17, RFKILL_TYPE_BLUETOOTH },
-	{ "ideapad_3g",		17, 0x20, RFKILL_TYPE_WWAN },
-	{ "ideapad_killsw",	0,  0,    RFKILL_TYPE_WLAN }
 };
 
+static acpi_handle ideapad_handle;
 static bool no_bt_rfkill;
 module_param(no_bt_rfkill, bool, 0444);
 MODULE_PARM_DESC(no_bt_rfkill, "No rfkill for bluetooth.");
@@ -176,11 +159,9 @@ static ssize_t show_ideapad_cam(struct device *dev,
 				struct device_attribute *attr,
 				char *buf)
 {
-	struct ideapad_private *priv = dev_get_drvdata(dev);
-	acpi_handle handle = priv->handle;
 	unsigned long result;
 
-	if (read_ec_data(handle, 0x1D, &result))
+	if (read_ec_data(ideapad_handle, 0x1D, &result))
 		return sprintf(buf, "-1\n");
 	return sprintf(buf, "%lu\n", result);
 }
@@ -189,15 +170,13 @@ static ssize_t store_ideapad_cam(struct device *dev,
 				 struct device_attribute *attr,
 				 const char *buf, size_t count)
 {
-	struct ideapad_private *priv = dev_get_drvdata(dev);
-	acpi_handle handle = priv->handle;
 	int ret, state;
 
 	if (!count)
 		return 0;
 	if (sscanf(buf, "%i", &state) != 1)
 		return -EINVAL;
-	ret = write_ec_cmd(handle, 0x1E, state);
+	ret = write_ec_cmd(ideapad_handle, 0x1E, state);
 	if (ret < 0)
 		return ret;
 	return count;
@@ -208,16 +187,24 @@ static DEVICE_ATTR(camera_power, 0644, show_ideapad_cam, store_ideapad_cam);
 /*
  * Rfkill
  */
+struct ideapad_rfk_data {
+	char *name;
+	int cfgbit;
+	int opcode;
+	int type;
+};
+
+const struct ideapad_rfk_data ideapad_rfk_data[] = {
+	{ "ideapad_wlan",	18, 0x15, RFKILL_TYPE_WLAN },
+	{ "ideapad_bluetooth",	16, 0x17, RFKILL_TYPE_BLUETOOTH },
+	{ "ideapad_3g",		17, 0x20, RFKILL_TYPE_WWAN },
+};
+
 static int ideapad_rfk_set(void *data, bool blocked)
 {
-	int device = (unsigned long)data;
-
-	if (device == IDEAPAD_DEV_KILLSW)
-		return -EINVAL;
+	unsigned long opcode = (unsigned long)data;
 
-	return write_ec_cmd(ideapad_priv->handle,
-			    ideapad_rfk_data[device].opcode,
-			    !blocked);
+	return write_ec_cmd(ideapad_handle, opcode, !blocked);
 }
 
 static struct rfkill_ops ideapad_rfk_ops = {
@@ -227,15 +214,14 @@ static struct rfkill_ops ideapad_rfk_ops = {
 static void ideapad_sync_rfk_state(struct acpi_device *adevice)
 {
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
-	acpi_handle handle = priv->handle;
 	unsigned long hw_blocked;
 	int i;
 
-	if (read_ec_data(handle, 0x23, &hw_blocked))
+	if (read_ec_data(ideapad_handle, 0x23, &hw_blocked))
 		return;
 	hw_blocked = !hw_blocked;
 
-	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++)
+	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		if (priv->rfk[i])
 			rfkill_set_hw_state(priv->rfk[i], hw_blocked);
 }
@@ -250,7 +236,7 @@ static int __devinit ideapad_register_rfkill(struct acpi_device *adevice,
 	if (no_bt_rfkill &&
 	    (ideapad_rfk_data[dev].type == RFKILL_TYPE_BLUETOOTH)) {
 		/* Force to enable bluetooth when no_bt_rfkill=1 */
-		write_ec_cmd(ideapad_priv->handle,
+		write_ec_cmd(ideapad_handle,
 			     ideapad_rfk_data[dev].opcode, 1);
 		return 0;
 	}
@@ -261,7 +247,7 @@ static int __devinit ideapad_register_rfkill(struct acpi_device *adevice,
 	if (!priv->rfk[dev])
 		return -ENOMEM;
 
-	if (read_ec_data(ideapad_priv->handle, ideapad_rfk_data[dev].opcode-1,
+	if (read_ec_data(ideapad_handle, ideapad_rfk_data[dev].opcode-1,
 			 &sw_blocked)) {
 		rfkill_init_sw_state(priv->rfk[dev], 0);
 	} else {
@@ -414,9 +400,8 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
-	ideapad_priv = priv;
-	priv->handle = adevice->handle;
 	dev_set_drvdata(&adevice->dev, priv);
+	ideapad_handle = adevice->handle;
 
 	ret = ideapad_platform_init(priv);
 	if (ret)
@@ -426,9 +411,11 @@ static int __devinit ideapad_acpi_add(struct acpi_device *adevice)
 	if (ret)
 		goto input_failed;
 
-	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++) {
+	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++) {
 		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
 			ideapad_register_rfkill(adevice, i);
+		else
+			priv->rfk[i] = NULL;
 	}
 	ideapad_sync_rfk_state(adevice);
 
@@ -446,7 +433,7 @@ static int __devexit ideapad_acpi_remove(struct acpi_device *adevice, int type)
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int i;
 
-	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++)
+	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		ideapad_unregister_rfkill(adevice, i);
 	ideapad_input_exit(priv);
 	ideapad_platform_exit(priv);
-- 
1.7.1

