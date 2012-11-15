Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993172Ab2KOKXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:23:04 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45269 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992947Ab2KOKXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:23:00 -0500
From: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
To: linux-acpi@vger.kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        wency@cn.fujitsu.com
Cc: rjw@sisk.pl, lenb@kernel.org, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
Subject: [RFC PATCH v2 1/3] driver core: Introduce prepare_remove in bus_type
Date: Thu, 15 Nov 2012 11:22:48 +0100
Message-Id: <1352974970-6643-2-git-send-email-vasilis.liaskovitis@profitbricks.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
References: <1352974970-6643-1-git-send-email-vasilis.liaskovitis@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function will call a bus-specific prepare_remove callback. If this call
is not successful, the device cannot be safely removed, or the driver cannot be
safely unbound.

This operation is needed to safely execute OSPM-induced unbind or rebind of ACPI
memory devices e.g.

echo "PNP0C80:00" > /sys/bus/acpi/drivers/acpi_memhotplug/unbind

driver_unbind and device_reprobe will use the new callback before calling
device_release_driver()

PROBLEM: bus_remove_device and bus_remove_driver also call device_release_driver
but these functions always succeed under the core device-driver model i.e. there
is no possibility of failure. These functions do not call the prepare_remove
callback currently. This creates an unwanted assymetry between device/driver
removal and driver unbinding. Suggestions to fix welcome.

Signed-off-by: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
---
 drivers/base/bus.c     |   36 ++++++++++++++++++++++++++++++++++++
 include/linux/device.h |    2 ++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 181ed26..c5dad55 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -34,6 +34,7 @@ static struct kset *system_kset;
 
 static int __must_check bus_rescan_devices_helper(struct device *dev,
 						void *data);
+static int bus_prepare_remove_device(struct device *dev);
 
 static struct bus_type *bus_get(struct bus_type *bus)
 {
@@ -178,11 +179,18 @@ static ssize_t driver_unbind(struct device_driver *drv,
 	if (dev && dev->driver == drv) {
 		if (dev->parent)	/* Needed for USB */
 			device_lock(dev->parent);
+		err = bus_prepare_remove_device(dev);
+		if (err) {
+			if (dev->parent)
+				device_unlock(dev->parent);
+			goto out;
+		}
 		device_release_driver(dev);
 		if (dev->parent)
 			device_unlock(dev->parent);
 		err = count;
 	}
+out:
 	put_device(dev);
 	bus_put(bus);
 	return err;
@@ -587,6 +595,26 @@ void bus_remove_device(struct device *dev)
 	bus_put(dev->bus);
 }
 
+/**
+ * device_prepare_release_driver - call driver specific operations to prepare
+ * for manually detaching device from driver.
+ * @dev: device.
+ *
+ * Prepare for detaching device from driver.
+ * When called for a USB interface, @dev->parent lock must be held.
+ * This function returns 0 if preparation is successful, non-zero error value
+ * otherwise.
+ */
+static int bus_prepare_remove_device(struct device *dev)
+{
+	int ret = 0;
+	device_lock(dev);
+	if (dev->bus)
+		ret = dev->bus->prepare_remove(dev);
+	device_unlock(dev);
+	return ret;
+}
+
 static int driver_add_attrs(struct bus_type *bus, struct device_driver *drv)
 {
 	int error = 0;
@@ -820,9 +848,17 @@ EXPORT_SYMBOL_GPL(bus_rescan_devices);
  */
 int device_reprobe(struct device *dev)
 {
+	int ret;
+
 	if (dev->driver) {
 		if (dev->parent)        /* Needed for USB */
 			device_lock(dev->parent);
+		ret = bus_prepare_remove_device(dev);
+		if (ret) {
+			if (dev->parent)
+				device_unlock(dev->parent);
+			return ret;
+		}
 		device_release_driver(dev);
 		if (dev->parent)
 			device_unlock(dev->parent);
diff --git a/include/linux/device.h b/include/linux/device.h
index cc3aee5..8e7055b 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -104,6 +104,7 @@ struct bus_type {
 
 	int (*suspend)(struct device *dev, pm_message_t state);
 	int (*resume)(struct device *dev);
+	int (*prepare_remove) (struct device *dev);
 
 	const struct dev_pm_ops *pm;
 
@@ -853,6 +854,7 @@ extern void device_release_driver(struct device *dev);
 extern int  __must_check device_attach(struct device *dev);
 extern int __must_check driver_attach(struct device_driver *drv);
 extern int __must_check device_reprobe(struct device *dev);
+extern int device_prepare_release_driver(struct device *dev);
 
 /*
  * Easy functions for dynamically creating devices on the fly
-- 
1.7.9

