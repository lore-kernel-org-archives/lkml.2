Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757552Ab2BCU2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:28:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab2BCU2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:28:11 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 2/3] apple_bl: Rework in advance of gmux backlight support
Date: Fri,  3 Feb 2012 14:28:03 -0600
Message-Id: <1328300884-21551-3-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it easier to support backlights without a fixed I/O range, and
remove use of global variables to allow having multiple backlights
concurrently.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/video/backlight/apple_bl.c |  163 +++++++++++++++++++-----------------
 1 files changed, 85 insertions(+), 78 deletions(-)

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index 66d5bec..e65b459 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
@@ -27,39 +27,30 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 
-static struct backlight_device *apple_backlight_device;
-
-struct hw_data {
+struct apple_bl_data {
 	/* I/O resource to allocate. */
 	unsigned long iostart;
 	unsigned long iolen;
+
+	/* Backlight device */
+	struct backlight_device *bdev;
+
 	/* Backlight operations structure. */
-	const struct backlight_ops backlight_ops;
-	void (*set_brightness)(int);
+	int (*get_brightness)(struct apple_bl_data *);
+	void (*set_brightness)(struct apple_bl_data *, int);
 };
 
-static const struct hw_data *hw_data;
-
 /*
  * Implementation for machines with Intel chipset.
  */
-static void intel_chipset_set_brightness(int intensity)
+static void intel_chipset_set_brightness(struct apple_bl_data *bl_data,
+					 int intensity)
 {
 	outb(0x04 | (intensity << 4), 0xb3);
 	outb(0xbf, 0xb2);
 }
 
-static int intel_chipset_send_intensity(struct backlight_device *bd)
-{
-	int intensity = bd->props.brightness;
-
-	pr_debug("setting brightness to %d\n", intensity);
-
-	intel_chipset_set_brightness(intensity);
-	return 0;
-}
-
-static int intel_chipset_get_intensity(struct backlight_device *bd)
+static int intel_chipset_get_brightness(struct apple_bl_data *bl_data)
 {
 	int intensity;
 
@@ -72,37 +63,17 @@ static int intel_chipset_get_intensity(struct backlight_device *bd)
 	return intensity;
 }
 
-static const struct hw_data intel_chipset_data = {
-	.iostart = 0xb2,
-	.iolen = 2,
-	.backlight_ops	= {
-		.options	= BL_CORE_SUSPENDRESUME,
-		.get_brightness	= intel_chipset_get_intensity,
-		.update_status	= intel_chipset_send_intensity,
-	},
-	.set_brightness = intel_chipset_set_brightness,
-};
-
 /*
  * Implementation for machines with Nvidia chipset.
  */
-static void nvidia_chipset_set_brightness(int intensity)
+static void nvidia_chipset_set_brightness(struct apple_bl_data *bl_data,
+					  int intensity)
 {
 	outb(0x04 | (intensity << 4), 0x52f);
 	outb(0xbf, 0x52e);
 }
 
-static int nvidia_chipset_send_intensity(struct backlight_device *bd)
-{
-	int intensity = bd->props.brightness;
-
-	pr_debug("setting brightness to %d\n", intensity);
-
-	nvidia_chipset_set_brightness(intensity);
-	return 0;
-}
-
-static int nvidia_chipset_get_intensity(struct backlight_device *bd)
+static int nvidia_chipset_get_brightness(struct apple_bl_data *bl_data)
 {
 	int intensity;
 
@@ -115,82 +86,118 @@ static int nvidia_chipset_get_intensity(struct backlight_device *bd)
 	return intensity;
 }
 
-static const struct hw_data nvidia_chipset_data = {
-	.iostart = 0x52e,
-	.iolen = 2,
-	.backlight_ops		= {
-		.options	= BL_CORE_SUSPENDRESUME,
-		.get_brightness	= nvidia_chipset_get_intensity,
-		.update_status	= nvidia_chipset_send_intensity
-	},
-	.set_brightness = nvidia_chipset_set_brightness,
+/*
+ * Backlight device class operations
+ */
+static int apple_bl_get_brightness(struct backlight_device *bd)
+{
+	struct apple_bl_data *bl_data = bl_get_data(bd);
+	return bl_data->get_brightness(bl_data);
+}
+
+static int apple_bl_update_status(struct backlight_device *bd)
+{
+	struct apple_bl_data *bl_data = bl_get_data(bd);
+
+	bl_data->set_brightness(bl_data, bd->props.brightness);
+	return 0;
+}
+
+static const struct backlight_ops apple_bl_ops = {
+	.get_brightness = apple_bl_get_brightness,
+	.update_status = apple_bl_update_status,
 };
 
 static int __devinit apple_bl_add(struct acpi_device *dev)
 {
+	struct apple_bl_data *bl_data;
 	struct backlight_properties props;
+	struct backlight_device *bdev;
 	struct pci_dev *host;
+	unsigned short vendor;
 	int intensity;
+	int ret = -ENODEV;
+
+	bl_data = kzalloc(sizeof(*bl_data), GFP_KERNEL);
+	if (!bl_data)
+		return -ENOMEM;
+	dev->driver_data = dev;
 
 	host = pci_get_bus_and_slot(0, 0);
 
 	if (!host) {
 		pr_err("unable to find PCI host\n");
-		return -ENODEV;
+		goto err_free;
 	}
 
-	if (host->vendor == PCI_VENDOR_ID_INTEL)
-		hw_data = &intel_chipset_data;
-	else if (host->vendor == PCI_VENDOR_ID_NVIDIA)
-		hw_data = &nvidia_chipset_data;
-
+	vendor = host->vendor;
 	pci_dev_put(host);
 
-	if (!hw_data) {
+	if (vendor == PCI_VENDOR_ID_INTEL) {
+		bl_data->iostart = 0xb2;
+		bl_data->iolen = 2;
+		bl_data->get_brightness = intel_chipset_get_brightness;
+		bl_data->set_brightness = intel_chipset_set_brightness;
+	} else if (vendor == PCI_VENDOR_ID_NVIDIA) {
+		bl_data->iostart = 0x52e;
+		bl_data->iolen = 2;
+		bl_data->get_brightness = nvidia_chipset_get_brightness;
+		bl_data->set_brightness = nvidia_chipset_set_brightness;
+	} else {
 		pr_err("unknown hardware\n");
-		return -ENODEV;
+		goto err_free;
 	}
 
 	/* Check that the hardware responds - this may not work under EFI */
 
-	intensity = hw_data->backlight_ops.get_brightness(NULL);
+	intensity = bl_data->get_brightness(bl_data);
 
 	if (!intensity) {
-		hw_data->set_brightness(1);
-		if (!hw_data->backlight_ops.get_brightness(NULL))
-			return -ENODEV;
+		bl_data->set_brightness(bl_data, 1);
+		if (!bl_data->get_brightness(bl_data))
+			goto err_free;
 
-		hw_data->set_brightness(0);
+		bl_data->set_brightness(bl_data, 0);
 	}
 
-	if (!request_region(hw_data->iostart, hw_data->iolen,
-			    "Apple backlight"))
-		return -ENXIO;
+	if (!request_region(bl_data->iostart, bl_data->iolen,
+			    "Apple backlight")) {
+		ret = -ENXIO;
+		goto err_free;
+	}
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
 	props.max_brightness = 15;
-	apple_backlight_device = backlight_device_register("apple_backlight",
-				  NULL, NULL, &hw_data->backlight_ops, &props);
+	bdev = backlight_device_register("apple_backlight", NULL, bl_data,
+					 &apple_bl_ops, &props);
 
-	if (IS_ERR(apple_backlight_device)) {
-		release_region(hw_data->iostart, hw_data->iolen);
-		return PTR_ERR(apple_backlight_device);
+	if (IS_ERR(bdev)) {
+		ret = PTR_ERR(bdev);
+		goto err_release;
 	}
 
-	apple_backlight_device->props.brightness =
-		hw_data->backlight_ops.get_brightness(apple_backlight_device);
-	backlight_update_status(apple_backlight_device);
+	bl_data->bdev = bdev;
+	bdev->props.brightness = bl_data->get_brightness(bl_data);
+	backlight_update_status(bdev);
 
 	return 0;
+
+err_release:
+	release_region(bl_data->iostart, bl_data->iolen);
+err_free:
+	kfree(bl_data);
+	return ret;
 }
 
 static int __devexit apple_bl_remove(struct acpi_device *dev, int type)
 {
-	backlight_device_unregister(apple_backlight_device);
+	struct apple_bl_data *bl_data = dev->driver_data;
+
+	backlight_device_unregister(bl_data->bdev);
+	release_region(bl_data->iostart, bl_data->iolen);
+	kfree(bl_data);
 
-	release_region(hw_data->iostart, hw_data->iolen);
-	hw_data = NULL;
 	return 0;
 }
 
-- 
1.7.8.3

