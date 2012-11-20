Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab2KTA5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 19:57:24 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:54083 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753418Ab2KTA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 19:56:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jean Delvare <khali@linux-fr.org>,
        ben-linux@fluff.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        mathias.nyman@linux.intel.com, linux-acpi@vger.kernel.org
Subject: [Update][PATCH 2/3] ACPI / driver core: Introduce struct acpi_dev_node and related macros
Date: Tue, 20 Nov 2012 01:59:23 +0100
Message-ID: <6570191.KCDMiILtRE@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <4036218.zBRlg5OZsZ@vostro.rjw.lan>
References: <1352977397-2280-1-git-send-email-mika.westerberg@linux.intel.com> <1758879.PKgPhTGcB7@vostro.rjw.lan> <4036218.zBRlg5OZsZ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

To avoid adding an ACPI handle pointer to struct device on
architectures that don't use ACPI, or generally when CONFIG_ACPI is
not set, in which cases that pointer is useless, define struct
acpi_dev_node that will contain the handle pointer if CONFIG_ACPI is
set and will be empty otherwise and use it to represent the ACPI
device node field in struct device.

In addition to that define macros for reading and setting the ACPI
handle of a device that don't generate code when CONFIG_ACPI is
unset.  Modify the ACPI subsystem to use those macros instead of
referring to the given device's ACPI handle directly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/glue.c     |   16 ++++++++--------
 drivers/acpi/scan.c     |    4 ++--
 include/acpi/acpi_bus.h |    2 +-
 include/linux/device.h  |   16 +++++++++++++++-
 4 files changed, 26 insertions(+), 12 deletions(-)

Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -578,6 +578,12 @@ struct device_dma_parameters {
 	unsigned long segment_boundary_mask;
 };
 
+struct acpi_dev_node {
+#ifdef CONFIG_ACPI
+	void	*handle;
+#endif
+};
+
 /**
  * struct device - The basic device structure
  * @parent:	The device's "parent" device, the device to which it is attached.
@@ -683,7 +689,7 @@ struct device {
 	struct dev_archdata	archdata;
 
 	struct device_node	*of_node; /* associated device tree node */
-	void			*acpi_handle; /* associated ACPI device node */
+	struct acpi_dev_node	acpi_node; /* associated ACPI device node */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	u32			id;	/* device instance */
@@ -704,6 +710,14 @@ static inline struct device *kobj_to_dev
 	return container_of(kobj, struct device, kobj);
 }
 
+#ifdef CONFIG_ACPI
+#define ACPI_HANDLE(dev)	((dev)->acpi_node.handle)
+#define ACPI_HANDLE_SET(dev, _handle_)	(dev)->acpi_node.handle = (_handle_)
+#else
+#define ACPI_HANDLE(dev)	(NULL)
+#define ACPI_HANDLE_SET(dev, _handle_)	do { } while(0)
+#endif
+
 /* Get the wakeup routines, which depend on struct device */
 #include <linux/pm_wakeup.h>
 
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -411,7 +411,7 @@ acpi_handle acpi_get_child(acpi_handle,
 int acpi_is_root_bridge(acpi_handle);
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
-#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->acpi_handle))
+#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
 
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int state);
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -134,12 +134,12 @@ static int acpi_bind_one(struct device *
 	char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
 	int retval = -EINVAL;
 
-	if (dev->acpi_handle) {
+	if (ACPI_HANDLE(dev)) {
 		if (handle) {
 			dev_warn(dev, "ACPI handle is already set\n");
 			return -EINVAL;
 		} else {
-			handle = dev->acpi_handle;
+			handle = ACPI_HANDLE(dev);
 		}
 	}
 	if (!handle)
@@ -181,8 +181,8 @@ static int acpi_bind_one(struct device *
 
 	mutex_unlock(&acpi_dev->physical_node_lock);
 
-	if (!dev->acpi_handle)
-		dev->acpi_handle = handle;
+	if (!ACPI_HANDLE(dev))
+		ACPI_HANDLE_SET(dev, acpi_dev->handle);
 
 	if (!physical_node->node_id)
 		strcpy(physical_node_name, PHYSICAL_NODE_STRING);
@@ -200,7 +200,7 @@ static int acpi_bind_one(struct device *
 	return 0;
 
  err:
-	dev->acpi_handle = NULL;
+	ACPI_HANDLE_SET(dev, NULL);
 	put_device(dev);
 	return retval;
 
@@ -217,10 +217,10 @@ static int acpi_unbind_one(struct device
 	acpi_status status;
 	struct list_head *node, *next;
 
-	if (!dev->acpi_handle)
+	if (!ACPI_HANDLE(dev))
 		return 0;
 
-	status = acpi_bus_get_device(dev->acpi_handle, &acpi_dev);
+	status = acpi_bus_get_device(ACPI_HANDLE(dev), &acpi_dev);
 	if (ACPI_FAILURE(status))
 		goto err;
 
@@ -246,7 +246,7 @@ static int acpi_unbind_one(struct device
 
 		sysfs_remove_link(&acpi_dev->dev.kobj, physical_node_name);
 		sysfs_remove_link(&dev->kobj, "firmware_node");
-		dev->acpi_handle = NULL;
+		ACPI_HANDLE_SET(dev, NULL);
 		/* acpi_bind_one increase refcnt by one */
 		put_device(dev);
 		kfree(entry);
Index: linux/drivers/acpi/scan.c
===================================================================
--- linux.orig/drivers/acpi/scan.c
+++ linux/drivers/acpi/scan.c
@@ -443,8 +443,8 @@ const struct acpi_device_id *acpi_match_
 {
 	struct acpi_device *adev;
 
-	if (!ids || !dev->acpi_handle
-	    || ACPI_FAILURE(acpi_bus_get_device(dev->acpi_handle, &adev)))
+	if (!ids || !ACPI_HANDLE(dev)
+	    || ACPI_FAILURE(acpi_bus_get_device(ACPI_HANDLE(dev), &adev)))
 		return NULL;
 
 	return __acpi_match_device(adev, ids);

