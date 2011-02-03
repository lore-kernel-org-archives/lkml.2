Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab1BCEX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:23:57 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:53541 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1BCEXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:23:55 -0500
Date: Wed, 2 Feb 2011 20:23:52 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 18/19] mfd-core: add platform_device sharing support for mfd
Message-ID: <20110202202352.18c669b7@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This adds functions to enable platform_device sharing for mfd clients.

Each platform driver (mfd client) that wants to share an mfd_cell's
platform_device uses the mfd_shared_platform_driver_{un,}register()
functions instead of platform_driver_{un,}register().  Along with
registering the platform driver, these also register a new platform
device with the same characteristics as the original, but a different
name.  Given an mfd_cell with the name "foo", the first call to
mfd_shared_platform_driver_register will register a platform device
named "foo0", as well as an associated platform_driver named "foo0".
The second call would register a platform device and driver with the
name "foo1", and so on.

This deals with platform handling only; mfd driver-specific details,
hardware handling, refcounting, etc are all dealt with separately.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |  115 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/core.h |    9 ++++
 2 files changed, 124 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 90e9483..a27a377 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -172,5 +172,120 @@ void mfd_remove_devices(struct device *parent)
 }
 EXPORT_SYMBOL(mfd_remove_devices);
 
+/*
+ * Find the first available platform_driver name, appending decimals
+ * after the name.  That is, given the string "foo", check whether
+ * "foo0", "foo1", "foo2", etc are in use.  Once a name is found
+ * that isn't in use, fill in *newname with it.
+ *
+ * If this returns non-zero, *newname must be kfree()d.
+ */
+static int get_unique_driver_name(const char *oldname, char **newname)
+{
+	struct device_driver *drv;
+	char *endp;
+	size_t len;
+	int i;
+
+	/* allocate memory for new name; includes space for extra 2 digits */
+	len = strlen(oldname);
+	*newname = kmalloc(len + 3, GFP_KERNEL);
+	if (!*newname)
+		return -ENOMEM;
+	endp = strcpy(*newname, oldname) + len;
+	BUG_ON(*endp != '\0');
+
+	/* search for the first driver name available */
+	for (i = 0; i < 99; i++) {
+		sprintf(endp, "%d", i);
+		drv = driver_find(*newname, &platform_bus_type);
+		if (!drv)
+			break;
+		put_driver(drv);
+	}
+
+	if (i > 99) {
+		/* we have too many subdevices registered?  allow up to 99. */
+		kfree(*newname);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static int add_shared_platform_device(const char *cell, const char *name)
+{
+	struct mfd_cell cell_entry;
+	struct device *dev;
+	struct platform_device *pdev;
+	int err;
+
+	/* check if we've already registered a device (don't fail if we have) */
+	if (bus_find_device_by_name(&platform_bus_type, NULL, name))
+		return 0;
+
+	/* fetch the parent cell's device (should already be registered!) */
+	dev = bus_find_device_by_name(&platform_bus_type, NULL, cell);
+	if (!dev) {
+		printk(KERN_ERR "failed to find device for cell %s\n", cell);
+		return -ENODEV;
+	}
+	pdev = to_platform_device(dev);
+	memcpy(&cell_entry, mfd_get_cell(pdev), sizeof(cell_entry));
+
+	WARN_ON(!cell_entry.enable);
+
+printk(KERN_WARNING "found cell %s, registering platform device %s\n", cell_entry.name, name);
+	cell_entry.name = name;
+	err = mfd_add_device(pdev->dev.parent, -1, &cell_entry, NULL, 0);
+	if (err)
+		dev_err(dev, "MFD add devices failed: %d\n", err);
+	return err;
+}
+
+int mfd_shared_platform_driver_register(struct platform_driver *drv,
+		const char *cellname)
+{
+	char *unique = NULL;
+	int err;
+
+	err = get_unique_driver_name(cellname, &unique);
+	if (err)
+		return err;
+printk(KERN_WARNING "registering platform device %s\n", unique);
+
+	err = add_shared_platform_device(cellname, unique);
+	if (err)
+		printk(KERN_ERR "failed to add platform device %s\n", unique);
+
+printk(KERN_WARNING "registering platform driver %s\n", unique);
+
+	drv->driver.name = unique;
+	err = platform_driver_register(drv);
+	if (err)
+		kfree(unique);
+/* TODO: if cs5535-mfd is already loaded, need to create devices as well */
+
+	return err;
+}
+EXPORT_SYMBOL(mfd_shared_platform_driver_register);
+
+void mfd_shared_platform_driver_unregister(struct platform_driver *drv)
+{
+	struct device *dev;
+
+printk(KERN_WARNING "unregistering platform device %s\n", drv->driver.name);
+	dev = bus_find_device_by_name(&platform_bus_type, NULL,
+			drv->driver.name);
+	if (dev)
+		platform_device_unregister(to_platform_device(dev));
+
+printk(KERN_WARNING "unregistering platform driver %s\n", drv->driver.name);
+	platform_driver_unregister(drv);
+	kfree(drv->driver.name);
+	drv->driver.name = NULL;
+}
+EXPORT_SYMBOL(mfd_shared_platform_driver_unregister);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ian Molton, Dmitry Baryshkov");
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index d13b992..ee1dd83 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -78,4 +78,13 @@ extern int mfd_add_devices(struct device *parent, int id,
 
 extern void mfd_remove_devices(struct device *parent);
 
+/*
+ * For MFD drivers with clients sharing access to resources, these create
+ * multiple platform devices per cell.  Contention handling must still be
+ * handled via drivers (ie, with enable/disable hooks).
+ */
+extern int mfd_shared_platform_driver_register(struct platform_driver *drv,
+		const char *cellname);
+extern void mfd_shared_platform_driver_unregister(struct platform_driver *drv);
+
 #endif
-- 
1.7.2.3

