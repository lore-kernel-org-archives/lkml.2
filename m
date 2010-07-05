Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab0GEPew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 11:34:52 -0400
Received: from scarab.smoula.net ([83.240.14.6]:58390 "EHLO scarab.smoula.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755267Ab0GEPev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 11:34:51 -0400
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jul 2010 11:34:51 EDT
Message-ID: <4C31F9C4.8090609@smoula.net>
Date: Mon, 05 Jul 2010 17:27:00 +0200
From: Martin Filip <bugtraq@smoula.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100630 Thunderbird/3.0.5
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Macbook Pro 5,5 nvidia backlight fix
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've MacBookPro5,5 with nVidia Corporation C79 [GeForce 9400M]. Until
now (last tested 2.6.34) it has broken brightness control in mbp_nvidia_bl.

I've patch is based on:
http://spuriousinterrupt.org/stuff/mbp_nvidia_bl-add_mmio_backlight_reg-2.6.31rc1.diff

Maybe someone involved with this module can merge this one?

Patch for 2.6.34:
diff -ruN a/drivers/video/backlight/mbp_nvidia_bl.c
b/drivers/video/backlight/mbp_nvidia_bl.c
--- a/drivers/video/backlight/mbp_nvidia_bl.c	2010-05-16
23:17:36.000000000 +0200
+++ b/drivers/video/backlight/mbp_nvidia_bl.c	2010-07-05
13:02:23.000000000 +0200
@@ -24,6 +24,7 @@
 #include <linux/err.h>
 #include <linux/dmi.h>
 #include <linux/io.h>
+#include <linux/pci.h>

 static struct backlight_device *mbp_backlight_device;

@@ -32,6 +33,12 @@
 	/* I/O resource to allocate. */
 	unsigned long iostart;
 	unsigned long iolen;
+
+	/* ... or MMIO region to allocate. */
+	unsigned long memstart;
+	unsigned long memlen;
+	void *membase;
+
 	/* Backlight operations structure. */
 	const struct backlight_ops backlight_ops;
 };
@@ -41,6 +48,9 @@
 module_param_named(debug, debug, int, 0644);
 MODULE_PARM_DESC(debug, "Set to one to enable debugging messages.");

+static /* const */ struct dmi_match_data *driver_data;
+
+
 /*
  * Implementation for MacBooks with Intel chipset.
  */
@@ -123,11 +133,58 @@
 	}
 };

+#define NV_PDISPLAY_OFFSET 0x610000
+#define NV_PDISPLAY_SOR0_REGS_BRIGHTNESS 0xc084
+#define NV_PDISPLAY_SOR0_REGS_BRIGHTNESS_CONTROL_ENABLED 0x80000000
+
+/* leave the driver's max_brightness value at 15 to avoid reworking how
+ * the driver works entirely.  we can just scale to the 'real' max of 1024
+ */
+#define NV_PDISPLAY_BACKLIGHT_MAX  1024
+static int nvidia_chipset_send_intensity_mmio(struct backlight_device *bd)
+{
+	int intensity = bd->props.brightness;
+
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: setting brightness to %d\n",
+		       intensity);
+
+	writel((intensity * NV_PDISPLAY_BACKLIGHT_MAX / 15) |
NV_PDISPLAY_SOR0_REGS_BRIGHTNESS_CONTROL_ENABLED,
+		   driver_data->membase + NV_PDISPLAY_OFFSET +
NV_PDISPLAY_SOR0_REGS_BRIGHTNESS);
+
+	return 0;
+}
+
+static int nvidia_chipset_get_intensity_mmio(struct backlight_device *bd)
+{
+	int intensity;
+	unsigned int val = readl(driver_data->membase + NV_PDISPLAY_OFFSET +
NV_PDISPLAY_SOR0_REGS_BRIGHTNESS);
+
+	if (debug)
+		printk(KERN_DEBUG "mbp_nvidia_bl: read brightness of %u\n",
+		       val);
+
+	/* convert to level between 0 and 15 */
+	intensity = (((double)val / NV_PDISPLAY_BACKLIGHT_MAX * 15) + 0.5);
+	return intensity;
+}
+
+static const struct dmi_match_data nvidia_chipset_data_mmio = {
+	.iolen = 0,
+	.backlight_ops		= {
+		.options	= BL_CORE_SUSPENDRESUME,
+		.get_brightness = nvidia_chipset_get_intensity_mmio,
+		.update_status	= nvidia_chipset_send_intensity_mmio
+	}
+};
+
+
 /*
  * DMI matching.
  */
 static /* const */ struct dmi_match_data *driver_data;

+
 static int mbp_dmi_match(const struct dmi_system_id *id)
 {
 	driver_data = id->driver_data;
@@ -136,6 +193,35 @@
 	return 1;
 }

+
+static int mbp_dmi_match_mmio(const struct dmi_system_id *id)
+{
+	struct pci_dev *pdev = NULL;
+
+	driver_data = id->driver_data;
+
+	printk(KERN_INFO "mbp_nvidia_bl: %s detected\n", id->ident);
+
+	while((pdev = pci_get_device(PCI_VENDOR_ID_NVIDIA, PCI_ANY_ID, pdev))) {
+		if((pdev->class >> 16) != PCI_BASE_CLASS_DISPLAY)  /* XXX: should we
use PCI_CLASS_DISPLAY_VGA? */
+			continue;
+
+		driver_data->memstart = pdev->resource[0].start;
+		driver_data->memlen = pdev->resource[0].end - pdev->resource[0].start
+ 1;
+		if (debug)
+			printk(KERN_DEBUG "Found video device, memstart=0x%lx, memlen=0x%lx\n",
+			       driver_data->memstart, driver_data->memlen);
+		return 1;
+	}
+
+	driver_data = NULL;
+	printk(KERN_ERR "mbp_nvidia_bl: Couldn't find PCI device\n");
+
+	return 0;
+}
+
+
+
 static const struct dmi_system_id __initdata mbp_device_table[] = {
 	{
 		.callback	= mbp_dmi_match,
@@ -281,27 +367,35 @@
 		},
 		.driver_data	= (void *)&nvidia_chipset_data,
 	},
-	{
-		.callback	= mbp_dmi_match,
-		.ident		= "MacBookPro 5,5",
-		.matches	= {
-			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,5"),
-		},
-		.driver_data	= (void *)&nvidia_chipset_data,
-	},
+ 	{
+ 		.callback	= mbp_dmi_match_mmio,
+ 		.ident		= "MacBookPro 5,5",
+ 		.matches	= {
+ 			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+ 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro5,5"),
+ 		},
+ 		.driver_data	= (void *)&nvidia_chipset_data_mmio,
+ 	},
 	{ }
 };

 static int __init mbp_init(void)
 {
 	struct backlight_properties props;
-	if (!dmi_check_system(mbp_device_table))
+ 	if (!dmi_check_system(mbp_device_table) || !driver_data)
 		return -ENODEV;

-	if (!request_region(driver_data->iostart, driver_data->iolen,
+ 	if (driver_data->iolen != 0) {
+ 		if (!request_region(driver_data->iostart, driver_data->iolen,
 						"Macbook Pro backlight"))
 		return -ENXIO;
+ 	} else if (driver_data->memlen != 0) {
+ 		driver_data->membase = ioremap(driver_data->memstart,
+ 						driver_data->memlen);
+
+ 		if (!driver_data->membase)
+ 			return -ENXIO;
+ 	}

 	memset(&props, 0, sizeof(struct backlight_properties));
 	props.max_brightness = 15;
@@ -310,7 +404,11 @@
 							 &driver_data->backlight_ops,
 							 &props);
 	if (IS_ERR(mbp_backlight_device)) {
-		release_region(driver_data->iostart, driver_data->iolen);
+ 		if (driver_data->iolen != 0)
+ 			release_region(driver_data->iostart, driver_data->iolen);
+ 		else if (driver_data->memlen != 0)
+ 			iounmap(driver_data->membase);
+
 		return PTR_ERR(mbp_backlight_device);
 	}

@@ -325,7 +423,10 @@
 {
 	backlight_device_unregister(mbp_backlight_device);

-	release_region(driver_data->iostart, driver_data->iolen);
+	if (driver_data->iolen != 0)
+		release_region(driver_data->iostart, driver_data->iolen);
+	else if (driver_data->membase)
+		iounmap(driver_data->membase);
 }

 module_init(mbp_init);


Thank you for your time
-- 
Martin Filip
e-mail: nexus@smoula.net
jabberID: nexus@smoula.net
http://www.smoula.net
