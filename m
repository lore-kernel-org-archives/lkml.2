Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab2BCU2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 15:28:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59870 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab2BCU2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 15:28:13 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, Matthew Garrett <mjg@redhat.com>
Subject: [PATCH 3/3] apple_bl: Add support for gmux backlight control
Date: Fri,  3 Feb 2012 14:28:04 -0600
Message-Id: <1328300884-21551-4-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
References: <1328300884-21551-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many Apple models the gmux device, which controls the display mux,
also supports control of the display backlight. On some models this is
the only way to adjust screen brightness.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/video/backlight/apple_bl.c |  183 +++++++++++++++++++++++++++++++-----
 1 files changed, 160 insertions(+), 23 deletions(-)

diff --git a/drivers/video/backlight/apple_bl.c b/drivers/video/backlight/apple_bl.c
index e65b459..b705dc2 100644
--- a/drivers/video/backlight/apple_bl.c
+++ b/drivers/video/backlight/apple_bl.c
@@ -27,7 +27,13 @@
 #include <linux/pci.h>
 #include <linux/acpi.h>
 
+#define APPLE_BL_ID	"APP0002"
+#define APPLE_GMUX_ID	"APP000B"
+
 struct apple_bl_data {
+	const char *name;
+	int max_brightness;
+
 	/* I/O resource to allocate. */
 	unsigned long iostart;
 	unsigned long iolen;
@@ -41,6 +47,37 @@ struct apple_bl_data {
 };
 
 /*
+ * gmux port offsets. Many of these are not yet used, but may be in the
+ * future, and it's useful to have them documented here anyhow.
+ */
+#define GMUX_PORT_VERSION_MAJOR		0x04
+#define GMUX_PORT_VERSION_MINOR		0x05
+#define GMUX_PORT_VERSION_RELEASE	0x06
+#define GMUX_PORT_SWITCH_DISPLAY	0x10
+#define GMUX_PORT_SWITCH_GET_DISPLAY	0x11
+#define GMUX_PORT_INTERRUPT_ENABLE	0x14
+#define GMUX_PORT_INTERRUPT_STATUS	0x16
+#define GMUX_PORT_SWITCH_DDC		0x28
+#define GMUX_PORT_SWITCH_EXTERNAL	0x40
+#define GMUX_PORT_SWITCH_GET_EXTERNAL	0x41
+#define GMUX_PORT_DISCRETE_POWER	0x50
+#define GMUX_PORT_MAX_BRIGHTNESS	0x70
+#define GMUX_PORT_BRIGHTNESS		0x74
+
+#define GMUX_MIN_IO_LEN			(GMUX_PORT_BRIGHTNESS + 4)
+
+#define GMUX_INTERRUPT_ENABLE		0xff
+#define GMUX_INTERRUPT_DISABLE		0x00
+
+#define GMUX_INTERRUPT_STATUS_ACTIVE	0
+#define GMUX_INTERRUPT_STATUS_DISPLAY	(1 << 0)
+#define GMUX_INTERRUPT_STATUS_POWER	(1 << 2)
+#define GMUX_INTERRUPT_STATUS_HOTPLUG	(1 << 3)
+
+#define GMUX_BRIGHTNESS_MASK		0x00ffffff
+#define GMUX_MAX_BRIGHTNESS		GMUX_BRIGHTNESS_MASK
+
+/*
  * Implementation for machines with Intel chipset.
  */
 static void intel_chipset_set_brightness(struct apple_bl_data *bl_data,
@@ -87,6 +124,28 @@ static int nvidia_chipset_get_brightness(struct apple_bl_data *bl_data)
 }
 
 /*
+ * Implementation for gmux backlight control
+ */
+static void gmux_set_brightness(struct apple_bl_data *bl_data, int intensity)
+{
+	/*
+	 * Older versions of gmux require writing out lower bytes first
+	 * then setting upper byte to 0 to flush values. Newer versions
+	 * accept a single u32 write, but the old method works as well
+	 * so just use it for everything.
+	 */
+	outb(intensity, bl_data->iostart + GMUX_PORT_BRIGHTNESS);
+	outb(intensity >> 8, bl_data->iostart + GMUX_PORT_BRIGHTNESS + 1);
+	outb(intensity >> 16, bl_data->iostart + GMUX_PORT_BRIGHTNESS + 2);
+	outb(0, bl_data->iostart + GMUX_PORT_BRIGHTNESS + 3);
+}
+
+static int gmux_get_brightness(struct apple_bl_data *bl_data)
+{
+	return inl(bl_data->iostart + GMUX_PORT_BRIGHTNESS) & GMUX_BRIGHTNESS_MASK;
+}
+
+/*
  * Backlight device class operations
  */
 static int apple_bl_get_brightness(struct backlight_device *bd)
@@ -108,54 +167,131 @@ static const struct backlight_ops apple_bl_ops = {
 	.update_status = apple_bl_update_status,
 };
 
-static int __devinit apple_bl_add(struct acpi_device *dev)
+static int __devinit legacy_bl_init(struct apple_bl_data *bl_data,
+				    struct acpi_device *dev)
 {
-	struct apple_bl_data *bl_data;
-	struct backlight_properties props;
-	struct backlight_device *bdev;
 	struct pci_dev *host;
 	unsigned short vendor;
-	int intensity;
-	int ret = -ENODEV;
-
-	bl_data = kzalloc(sizeof(*bl_data), GFP_KERNEL);
-	if (!bl_data)
-		return -ENOMEM;
-	dev->driver_data = dev;
 
 	host = pci_get_bus_and_slot(0, 0);
-
 	if (!host) {
 		pr_err("unable to find PCI host\n");
-		goto err_free;
+		return -ENODEV;
 	}
 
 	vendor = host->vendor;
 	pci_dev_put(host);
 
-	if (vendor == PCI_VENDOR_ID_INTEL) {
+	switch (vendor) {
+	case PCI_VENDOR_ID_INTEL:
 		bl_data->iostart = 0xb2;
 		bl_data->iolen = 2;
 		bl_data->get_brightness = intel_chipset_get_brightness;
 		bl_data->set_brightness = intel_chipset_set_brightness;
-	} else if (vendor == PCI_VENDOR_ID_NVIDIA) {
+		break;
+	case PCI_VENDOR_ID_NVIDIA:
 		bl_data->iostart = 0x52e;
 		bl_data->iolen = 2;
 		bl_data->get_brightness = nvidia_chipset_get_brightness;
 		bl_data->set_brightness = nvidia_chipset_set_brightness;
-	} else {
-		pr_err("unknown hardware\n");
-		goto err_free;
+		break;
+	default:
+		pr_err("no backlight support for PCI vendor %hu\n", vendor);
+		return -ENODEV;
+	}
+
+	bl_data->name = "apple_backlight";
+	bl_data->max_brightness = 15;
+	return 0;
+}
+
+static acpi_status __devinit gmux_get_resources(struct acpi_resource *res,
+						void *context)
+{
+	struct apple_bl_data *bl_data = context;
+	struct acpi_resource_io *io;
+
+	if (res->type == ACPI_RESOURCE_TYPE_IO) {
+		io = &res->data.io;
+		bl_data->iostart = io->minimum;
+		bl_data->iolen = io->maximum - io->minimum;
+
+		return AE_CTRL_TERMINATE;
+	}
+
+	return AE_OK;
+}
+
+static int __devinit gmux_init(struct apple_bl_data *bl_data,
+			       struct acpi_device *dev)
+{
+	acpi_status status;
+
+	status = acpi_walk_resources(dev->handle, METHOD_NAME__CRS,
+				     gmux_get_resources, bl_data);
+	if (ACPI_FAILURE(status))
+		return -ENXIO;
+
+	if (!bl_data->iostart) {
+		pr_err("Failed to find gmux I/O resources\n");
+		return -ENXIO;
+	}
+
+	if (bl_data->iolen < GMUX_MIN_IO_LEN) {
+		pr_err("gmux I/O region too small (%lu < %u)\n",
+		       bl_data->iolen, GMUX_MIN_IO_LEN);
+		return -ENXIO;
 	}
 
+	bl_data->name = "gmux_backlight";
+	bl_data->get_brightness = gmux_get_brightness;
+	bl_data->set_brightness = gmux_set_brightness;
+	bl_data->max_brightness =
+		inl(bl_data->iostart + GMUX_PORT_MAX_BRIGHTNESS);
+
+	/*
+	 * Currently it's assumed that the maximum brightness is less
+	 * than 2^24 for compatibility with old gmux versions. Cap the
+	 * max brightness at this max value, but print a warning if
+	 * the hardware reports something higher so it can be fixed.
+	 */
+	if (WARN_ON(bl_data->max_brightness > GMUX_MAX_BRIGHTNESS))
+		bl_data->max_brightness = GMUX_MAX_BRIGHTNESS;
+
+	return 0;
+}
+
+static int __devinit apple_bl_add(struct acpi_device *dev)
+{
+	struct apple_bl_data *bl_data;
+	struct backlight_properties props;
+	struct backlight_device *bdev;
+	int intensity;
+	int ret = -ENODEV;
+
+	bl_data = kzalloc(sizeof(*bl_data), GFP_KERNEL);
+	if (!bl_data)
+		return -ENOMEM;
+	dev->driver_data = bl_data;
+
+	if (!strcmp(acpi_device_hid(dev), APPLE_GMUX_ID))
+		ret = gmux_init(bl_data, dev);
+	else
+		ret = legacy_bl_init(bl_data, dev);
+
+	if (ret)
+		goto err_free;
+
 	/* Check that the hardware responds - this may not work under EFI */
 
 	intensity = bl_data->get_brightness(bl_data);
 
 	if (!intensity) {
 		bl_data->set_brightness(bl_data, 1);
-		if (!bl_data->get_brightness(bl_data))
+		if (!bl_data->get_brightness(bl_data)) {
+			ret = -ENODEV;
 			goto err_free;
+		}
 
 		bl_data->set_brightness(bl_data, 0);
 	}
@@ -168,8 +304,8 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 
 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = 15;
-	bdev = backlight_device_register("apple_backlight", NULL, bl_data,
+	props.max_brightness = bl_data->max_brightness;
+	bdev = backlight_device_register(bl_data->name, &dev->dev, bl_data,
 					 &apple_bl_ops, &props);
 
 	if (IS_ERR(bdev)) {
@@ -178,7 +314,7 @@ static int __devinit apple_bl_add(struct acpi_device *dev)
 	}
 
 	bl_data->bdev = bdev;
-	bdev->props.brightness = bl_data->get_brightness(bl_data);
+	bdev->props.brightness = intensity;
 	backlight_update_status(bdev);
 
 	return 0;
@@ -202,7 +338,8 @@ static int __devexit apple_bl_remove(struct acpi_device *dev, int type)
 }
 
 static const struct acpi_device_id apple_bl_ids[] = {
-	{"APP0002", 0},
+	{APPLE_BL_ID, 0},
+	{APPLE_GMUX_ID, 0},
 	{"", 0},
 };
 
-- 
1.7.8.3

