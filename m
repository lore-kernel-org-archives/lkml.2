Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0LMKAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:00:38 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34685 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458Ab0LMKAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:00:33 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-acpi@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 2/6] ideapad: let camera power control entry under platform driver
Date: Mon, 13 Dec 2010 18:00:27 +0800
Message-Id: <1292234427-2657-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
References: <1292234384-2599-1-git-send-email-ike.pan@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The entry was at /sys/devices/LNXSYSTM:00/../VPC2004:00/camera_power
move to /sys/devices/platform/ideapad/camera_power

Add document about usage of ideapad node in sysfs.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 .../ABI/testing/sysfs-platform-ideapad-laptop      |    6 ++
 drivers/platform/x86/ideapad-laptop.c              |   55 +++++++++-----------
 2 files changed, 31 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-ideapad-laptop

diff --git a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
new file mode 100644
index 0000000..807fca2
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
@@ -0,0 +1,6 @@
+What:		/sys/devices/platform/ideapad/camera_power
+Date:		Dec 2010
+KernelVersion:	2.6.37
+Contact:	"Ike Panhc <ike.pan@canonical.com>"
+Description:
+		Control the power of camera module. 1 means on, 0 means off.
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 5998ae1..49f207f 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -282,6 +282,15 @@ static void ideapad_unregister_rfkill(struct acpi_device *adevice, int dev)
 /*
  * Platform device
  */
+static struct attribute *ideapad_attributes[] = {
+	&dev_attr_camera_power.attr,
+	NULL
+};
+
+static struct attribute_group ideapad_attribute_group = {
+	.attrs = ideapad_attributes
+};
+
 static int __devinit ideapad_platform_init(void)
 {
 	int result;
@@ -295,8 +304,14 @@ static int __devinit ideapad_platform_init(void)
 	if (result)
 		goto fail_platform_device;
 
+	result = sysfs_create_group(&ideapad_priv->platform_device->dev.kobj,
+				    &ideapad_attribute_group);
+	if (result)
+		goto fail_sysfs;
 	return 0;
 
+fail_sysfs:
+	platform_device_del(ideapad_priv->platform_device);
 fail_platform_device:
 	platform_device_put(ideapad_priv->platform_device);
 	return result;
@@ -304,6 +319,8 @@ fail_platform_device:
 
 static void ideapad_platform_exit(void)
 {
+	sysfs_remove_group(&ideapad_priv->platform_device->dev.kobj,
+			   &ideapad_attribute_group);
 	platform_device_unregister(ideapad_priv->platform_device);
 }
 /* the above is platform device */
@@ -317,50 +334,30 @@ MODULE_DEVICE_TABLE(acpi, ideapad_device_ids);
 static int ideapad_acpi_add(struct acpi_device *adevice)
 {
 	int ret, i, cfg;
-	int devs_present[5];
 	struct ideapad_private *priv;
 
 	if (read_method_int(adevice->handle, "_CFG", &cfg))
 		return -ENODEV;
 
-	for (i = IDEAPAD_DEV_CAMERA; i < IDEAPAD_DEV_KILLSW; i++) {
-		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
-			devs_present[i] = 1;
-		else
-			devs_present[i] = 0;
-	}
-
-	/* The hardware switch is always present */
-	devs_present[IDEAPAD_DEV_KILLSW] = 1;
-
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 	ideapad_priv = priv;
+	priv->handle = adevice->handle;
+	dev_set_drvdata(&adevice->dev, priv);
 
 	ret = ideapad_platform_init();
 	if (ret)
 		goto platform_failed;
 
-	if (devs_present[IDEAPAD_DEV_CAMERA]) {
-		ret = device_create_file(&adevice->dev, &dev_attr_camera_power);
-		if (ret)
-			goto camera_failed;
-	}
-
-	priv->handle = adevice->handle;
-	dev_set_drvdata(&adevice->dev, priv);
-	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++) {
-		if (!devs_present[i])
-			continue;
-
-		ideapad_register_rfkill(adevice, i);
+	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++) {
+		if (test_bit(ideapad_rfk_data[i].cfgbit, (unsigned long *)&cfg))
+			ideapad_register_rfkill(adevice, i);
 	}
 	ideapad_sync_rfk_state(adevice);
+
 	return 0;
 
-camera_failed:
-	ideapad_platform_exit();
 platform_failed:
 	kfree(priv);
 	return ret;
@@ -371,14 +368,12 @@ static int ideapad_acpi_remove(struct acpi_device *adevice, int type)
 	struct ideapad_private *priv = dev_get_drvdata(&adevice->dev);
 	int i;
 
-	device_remove_file(&adevice->dev, &dev_attr_camera_power);
-
-	for (i = IDEAPAD_DEV_WLAN; i <= IDEAPAD_DEV_KILLSW; i++)
+	for (i = IDEAPAD_DEV_WLAN; i < IDEAPAD_DEV_KILLSW; i++)
 		ideapad_unregister_rfkill(adevice, i);
-
 	ideapad_platform_exit();
 	dev_set_drvdata(&adevice->dev, NULL);
 	kfree(priv);
+
 	return 0;
 }
 
-- 
1.7.1

