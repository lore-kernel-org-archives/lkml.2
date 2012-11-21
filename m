Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab2KUOon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:44:43 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:44251 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab2KUOol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:44:41 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: [RFC] driver-core: Remove dummy 'platform_bus'
Date: Wed, 21 Nov 2012 14:44:31 +0000
Message-Id: <1353509071-8658-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "platform_bus" (note: not platform_bus_type) only exists as an empty
directory to put platform devices into. However, it really doesn't make
sense to segregate all the platform devices into a sub directory when
typically they are memory mapped devices that doen't go through any
particular bus. Particularly on embedded type platforms the platform_bus
directory doesn't add anything.

However, this will probably just end up breaking some userspace that
depends on the /sys/devices/platform/ path to be present (no matter how
much we protest that userspace must not depend on paths in sysfs). So
while I'm seriously proposing this change, it may just be unacceptable
ABI breakage

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 arch/arm/plat-mxc/devices.c         |    2 --
 arch/unicore32/kernel/puv3-core.c   |    2 +-
 arch/unicore32/kernel/puv3-nb0916.c |    6 +++---
 drivers/base/platform.c             |   16 +---------------
 drivers/char/tile-srom.c            |    2 +-
 drivers/mmc/host/sdhci-pltfm.c      |    6 ++----
 drivers/scsi/hosts.c                |    2 +-
 include/linux/platform_device.h     |    1 -
 8 files changed, 9 insertions(+), 28 deletions(-)

diff --git a/arch/arm/plat-mxc/devices.c b/arch/arm/plat-mxc/devices.c
index 4d55a7a..7df592b 100644
--- a/arch/arm/plat-mxc/devices.c
+++ b/arch/arm/plat-mxc/devices.c
@@ -25,12 +25,10 @@
 
 struct device mxc_aips_bus = {
 	.init_name	= "mxc_aips",
-	.parent		= &platform_bus,
 };
 
 struct device mxc_ahb_bus = {
 	.init_name	= "mxc_ahb",
-	.parent		= &platform_bus,
 };
 
 static int __init mxc_device_init(void)
diff --git a/arch/unicore32/kernel/puv3-core.c b/arch/unicore32/kernel/puv3-core.c
index 254adee..438dd2e 100644
--- a/arch/unicore32/kernel/puv3-core.c
+++ b/arch/unicore32/kernel/puv3-core.c
@@ -272,7 +272,7 @@ void __init puv3_core_init(void)
 	platform_device_register_simple("PKUnity-v3-UART", 1,
 			puv3_uart1_resources, ARRAY_SIZE(puv3_uart1_resources));
 	platform_device_register_simple("PKUnity-v3-AC97", -1, NULL, 0);
-	platform_device_register_resndata(&platform_bus, "musb_hdrc", -1,
+	platform_device_register_resndata(NULL, "musb_hdrc", -1,
 			puv3_usb_resources, ARRAY_SIZE(puv3_usb_resources),
 			&puv3_usb_plat, sizeof(puv3_usb_plat));
 }
diff --git a/arch/unicore32/kernel/puv3-nb0916.c b/arch/unicore32/kernel/puv3-nb0916.c
index 181108b..e9991b6 100644
--- a/arch/unicore32/kernel/puv3-nb0916.c
+++ b/arch/unicore32/kernel/puv3-nb0916.c
@@ -111,13 +111,13 @@ int __init mach_nb0916_init(void)
 	platform_device_register_simple("PKUnity-v3-I2C", -1,
 			puv3_i2c_resources, ARRAY_SIZE(puv3_i2c_resources));
 
-	platform_device_register_data(&platform_bus, "pwm-backlight", -1,
+	platform_device_register_data(NULL, "pwm-backlight", -1,
 			&nb0916_backlight_data, sizeof(nb0916_backlight_data));
 
-	platform_device_register_data(&platform_bus, "gpio-keys", -1,
+	platform_device_register_data(NULL, "gpio-keys", -1,
 			&nb0916_gpio_button_data, sizeof(nb0916_gpio_button_data));
 
-	platform_device_register_resndata(&platform_bus, "physmap-flash", -1,
+	platform_device_register_resndata(NULL, "physmap-flash", -1,
 			&physmap_flash_resource, 1,
 			&physmap_flash_data, sizeof(physmap_flash_data));
 
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 72c776f..4f1c969 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -31,11 +31,6 @@ static DEFINE_IDA(platform_devid_ida);
 #define to_platform_driver(drv)	(container_of((drv), struct platform_driver, \
 				 driver))
 
-struct device platform_bus = {
-	.init_name	= "platform",
-};
-EXPORT_SYMBOL_GPL(platform_bus);
-
 /**
  * arch_setup_pdev_archdata - Allow manipulation of archdata before its used
  * @pdev: platform device
@@ -283,9 +278,6 @@ int platform_device_add(struct platform_device *pdev)
 	if (!pdev)
 		return -EINVAL;
 
-	if (!pdev->dev.parent)
-		pdev->dev.parent = &platform_bus;
-
 	pdev->dev.bus = &platform_bus_type;
 
 	switch (pdev->id) {
@@ -883,13 +875,7 @@ int __init platform_bus_init(void)
 
 	early_platform_cleanup();
 
-	error = device_register(&platform_bus);
-	if (error)
-		return error;
-	error =  bus_register(&platform_bus_type);
-	if (error)
-		device_unregister(&platform_bus);
-	return error;
+	return bus_register(&platform_bus_type);
 }
 
 #ifndef ARCH_HAS_DMA_GET_REQUIRED_MASK
diff --git a/drivers/char/tile-srom.c b/drivers/char/tile-srom.c
index 3b22a60..854ab2b 100644
--- a/drivers/char/tile-srom.c
+++ b/drivers/char/tile-srom.c
@@ -369,7 +369,7 @@ static int srom_setup_minor(struct srom_dev *srom, int index)
 		       SROM_PAGE_SIZE_OFF, sizeof(srom->page_size)) < 0)
 		return -EIO;
 
-	dev = device_create(srom_class, &platform_bus,
+	dev = device_create(srom_class, NULL,
 			    MKDEV(srom_major, index), srom, "%d", index);
 	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
 }
diff --git a/drivers/mmc/host/sdhci-pltfm.c b/drivers/mmc/host/sdhci-pltfm.c
index 2716445..841425c 100644
--- a/drivers/mmc/host/sdhci-pltfm.c
+++ b/drivers/mmc/host/sdhci-pltfm.c
@@ -115,10 +115,8 @@ struct sdhci_host *sdhci_pltfm_init(struct platform_device *pdev,
 		dev_err(&pdev->dev, "Invalid iomem size!\n");
 
 	/* Some PCI-based MFD need the parent here */
-	if (pdev->dev.parent != &platform_bus && !np)
-		host = sdhci_alloc_host(pdev->dev.parent, sizeof(*pltfm_host));
-	else
-		host = sdhci_alloc_host(&pdev->dev, sizeof(*pltfm_host));
+	host = sdhci_alloc_host(pdev->dev.parent ? pdev->dev.parent : &pdev->dev,
+				sizeof(*pltfm_host));
 
 	if (IS_ERR(host)) {
 		ret = PTR_ERR(host);
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 593085a..c1f9966 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -217,7 +217,7 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 		goto fail;
 
 	if (!shost->shost_gendev.parent)
-		shost->shost_gendev.parent = dev ? dev : &platform_bus;
+		shost->shost_gendev.parent = dev;
 	if (!dma_dev)
 		dma_dev = shost->shost_gendev.parent;
 
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 5711e95..e01efb3 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -44,7 +44,6 @@ extern int platform_device_register(struct platform_device *);
 extern void platform_device_unregister(struct platform_device *);
 
 extern struct bus_type platform_bus_type;
-extern struct device platform_bus;
 
 extern void arch_setup_pdev_archdata(struct platform_device *);
 extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
-- 
1.7.10.4

