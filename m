Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1BRDKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:10:06 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51919 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932538Ab1BRDIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:19 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 28/29] mfd-core: add platform_device sharing support for mfd (v2)
Date: Thu, 17 Feb 2011 19:07:35 -0800
Message-Id: <1297998456-7615-29-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds functions to enable platform_device sharing for mfd clients.

Each platform driver (mfd client) that wants to share an mfd_cell's
platform_device uses the mfd_shared_platform_driver_{un,}register()
functions instead of platform_driver_{un,}register().  Along with
registering the platform driver, these also register a new platform
device with the same characteristics as the original cell, but a different
name.  Given an mfd_cell with the name "foo", drivers that want to
share access to its resources can call mfd_shared_platform_driver_register
with platform drivers named (for example) "bar" and "baz".  This
will register two platform devices and drivers named "bar" and "baz"
that share the same cell as the platform device "foo".  The drivers
can then call "foo" cell's enable hooks (or mfd_shared_cell_enable)
to enable resources, and obtain platform resources as they normally
would.

This deals with platform handling only; mfd driver-specific details,
hardware handling, refcounting, etc are all dealt with separately.

v2: Drop the randomized names, and instead let drivers specify
their own names.  This gets rid of a bunch of code, and ensures
that userspace will know where platform drivers/devices will show
up in sysfs.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/mfd/mfd-core.c   |   61 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/core.h |    9 +++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index ca789f8..bb2264c 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -184,5 +184,66 @@ void mfd_remove_devices(struct device *parent)
 }
 EXPORT_SYMBOL(mfd_remove_devices);
 
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
+	int err;
+
+	err = add_shared_platform_device(cellname, drv->driver.name);
+	if (err)
+		printk(KERN_ERR "failed to add platform device %s\n",
+				drv->driver.name);
+
+	err = platform_driver_register(drv);
+	if (err)
+		printk(KERN_ERR "failed to add platform driver %s\n",
+				drv->driver.name);
+
+	return err;
+}
+EXPORT_SYMBOL(mfd_shared_platform_driver_register);
+
+void mfd_shared_platform_driver_unregister(struct platform_driver *drv)
+{
+	struct device *dev;
+
+	dev = bus_find_device_by_name(&platform_bus_type, NULL,
+			drv->driver.name);
+	if (dev)
+		platform_device_unregister(to_platform_device(dev));
+
+	platform_driver_unregister(drv);
+}
+EXPORT_SYMBOL(mfd_shared_platform_driver_unregister);
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ian Molton, Dmitry Baryshkov");
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 22a2f5e..ed99704 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -87,4 +87,13 @@ extern int mfd_add_devices(struct device *parent, int id,
 
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

