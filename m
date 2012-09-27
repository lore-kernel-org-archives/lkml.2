Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757093Ab2I0Kmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:42:39 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab2I0Kgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdAEhAgMVcGE4gJt2+RNQOVaYk8iVg
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447798"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 02/17] Staging: ipack: Make ipack_device_register() analogous to device_register().
Date: Thu, 27 Sep 2012 12:37:26 +0200
Message-Id: <1348742261-28145-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

ipack_device_register() is no longer creating the struct ipack_device
but only registering it.  Instead of releasing memory directly the new
ipack_device->release callback is called.

This is preparational work for later patches.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |   19 ++++++++++++++++++-
 drivers/staging/ipack/ipack.c           |   30 +++++++++---------------------
 drivers/staging/ipack/ipack.h           |   15 +++++++++------
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 2f48dd5..ee66129 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -640,6 +640,23 @@ static int tpci200_install(struct tpci200_board *tpci200)
 	return 0;
 }
 
+static void tpci200_release_device(struct ipack_device *dev)
+{
+	kfree(dev);
+}
+
+static int tpci200_create_device(struct tpci200_board *tpci200, int i)
+{
+	struct ipack_device *dev =
+		kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
+	if (!dev)
+		return -ENOMEM;
+	dev->slot = i;
+	dev->bus = tpci200->info->ipack_bus;
+	dev->release = tpci200_release_device;
+	return ipack_device_register(dev);
+}
+
 static int tpci200_pci_probe(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
@@ -715,7 +732,7 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	dev_set_drvdata(&pdev->dev, tpci200);
 
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		ipack_device_register(tpci200->info->ipack_bus, i);
+		tpci200_create_device(tpci200, i);
 	return 0;
 
 out_err_bus_register:
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index ca8cb327..d2ed9f5 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -24,7 +24,7 @@ static void ipack_device_release(struct device *dev)
 {
 	struct ipack_device *device = to_ipack_dev(dev);
 	kfree(device->id);
-	kfree(device);
+	device->release(device);
 }
 
 static inline const struct ipack_device_id *
@@ -426,51 +426,39 @@ out:
 	return ret;
 }
 
-struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
-					   int slot)
+int ipack_device_register(struct ipack_device *dev)
 {
 	int ret;
-	struct ipack_device *dev;
-
-	dev = kzalloc(sizeof(struct ipack_device), GFP_KERNEL);
-	if (!dev)
-		return NULL;
 
 	dev->dev.bus = &ipack_bus_type;
 	dev->dev.release = ipack_device_release;
-	dev->dev.parent = bus->parent;
-	dev->slot = slot;
-	dev->bus = bus;
+	dev->dev.parent = dev->bus->parent;
 	dev_set_name(&dev->dev,
 		     "ipack-dev.%u.%u", dev->bus->bus_nr, dev->slot);
 
-	if (bus->ops->set_clockrate(dev, 8))
+	if (dev->bus->ops->set_clockrate(dev, 8))
 		dev_warn(&dev->dev, "failed to switch to 8 MHz operation for reading of device ID.\n");
-	if (bus->ops->reset_timeout(dev))
+	if (dev->bus->ops->reset_timeout(dev))
 		dev_warn(&dev->dev, "failed to reset potential timeout.");
 
 	ret = ipack_device_read_id(dev);
 	if (ret < 0) {
 		dev_err(&dev->dev, "error reading device id section.\n");
-		kfree(dev);
-		return NULL;
+		return ret;
 	}
 
 	/* if the device supports 32 MHz operation, use it. */
 	if (dev->speed_32mhz) {
-		ret = bus->ops->set_clockrate(dev, 32);
+		ret = dev->bus->ops->set_clockrate(dev, 32);
 		if (ret < 0)
 			dev_err(&dev->dev, "failed to switch to 32 MHz operation.\n");
 	}
 
 	ret = device_register(&dev->dev);
-	if (ret < 0) {
+	if (ret < 0)
 		kfree(dev->id);
-		kfree(dev);
-		return NULL;
-	}
 
-	return dev;
+	return ret;
 }
 EXPORT_SYMBOL_GPL(ipack_device_register);
 
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index 33fdea5..e2987d5 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -71,6 +71,7 @@ struct ipack_device {
 	struct ipack_addr_space int_space;
 	struct ipack_addr_space mem_space;
 	struct device dev;
+	void (*release) (struct ipack_device *dev);
 	u8                      *id;
 	size_t			 id_avail;
 	u32			 id_vendor;
@@ -179,15 +180,17 @@ int ipack_driver_register(struct ipack_driver *edrv, struct module *owner,
 void ipack_driver_unregister(struct ipack_driver *edrv);
 
 /**
- *	ipack_device_register -- register a new mezzanine device
+ *	ipack_device_register -- register an IPack device with the kernel
+ *	@dev: the new device to register.
  *
- * @bus: ipack bus device it is plugged to.
- * @slot: slot position in the bus device.
+ *	Register a new IPack device ("module" in IndustryPack jargon). The call
+ *	is done by the carrier driver.  The carrier should populate the fields
+ *	bus and slot of @dev prior to calling this function.  The rest of the
+ *	fields will be allocated and populated during registration.
  *
- * Register a new ipack device (mezzanine device). The call is done by
- * the carrier device driver.
+ *	Return zero on success or error code on failure.
  */
-struct ipack_device *ipack_device_register(struct ipack_bus_device *bus, int slot);
+int ipack_device_register(struct ipack_device *dev);
 void ipack_device_unregister(struct ipack_device *dev);
 
 /**
-- 
1.7.10.4

