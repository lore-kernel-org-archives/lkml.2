Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab2JaJew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:34:52 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48180 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038Ab2JaJeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:34:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 list <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 1/5] driver core / ACPI: Move ACPI support to core device and driver types
Date: Wed, 31 Oct 2012 10:38:29 +0100
Message-ID: <1825320.jYYkSTpTOm@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <1421417.rIOjExM5Pt@vostro.rjw.lan>
References: <1421417.rIOjExM5Pt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

With ACPI 5 we are starting to see devices that don't natively support
discovery but can be enumerated with the help of the ACPI namespace.
Typically, these devices can be represented in the Linux device driver
model as platform devices or some serial bus devices, like SPI or I2C
devices.

Since we want to re-use existing drivers for those devices, we need a
way for drivers to specify the ACPI IDs of supported devices, so that
they can be matched against device nodes in the ACPI namespace.  To
this end, it is sufficient to add a pointer to an array of supported
ACPI device IDs, that can be provided by the driver, to struct device.

Moreover, things like ACPI power management need to have access to
the ACPI handle of each supported device, because that handle is used
to invoke AML methods associated with the corresponding ACPI device
node.  The ACPI handles of devices are now stored in the archdata
member structure of struct device whose definition depends on the
architecture and includes the ACPI handle only on x86 and ia64. Since
the pointer to an array of supported ACPI IDs is added to struct
device_driver in an architecture-independent way, it is logical to
move the ACPI handle from archdata to struct device itself at the same
time.  This also makes code more straightforward in some places and
follows the example of Device Trees that have a poiter to struct
device_node in there too.

This changeset is based on Mika Westerberg's work.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/ia64/include/asm/device.h |    3 ---
 arch/x86/include/asm/device.h  |    3 ---
 drivers/acpi/glue.c            |   14 ++++++--------
 include/acpi/acpi_bus.h        |    2 +-
 include/linux/device.h         |    4 ++++
 5 files changed, 11 insertions(+), 15 deletions(-)

Index: linux/drivers/acpi/glue.c
===================================================================
--- linux.orig/drivers/acpi/glue.c
+++ linux/drivers/acpi/glue.c
@@ -134,7 +134,7 @@ static int acpi_bind_one(struct device *
 	char physical_node_name[sizeof(PHYSICAL_NODE_STRING) + 2];
 	int retval = -EINVAL;
 
-	if (dev->archdata.acpi_handle) {
+	if (dev->acpi_handle) {
 		dev_warn(dev, "Drivers changed 'acpi_handle'\n");
 		return -EINVAL;
 	}
@@ -169,7 +169,7 @@ static int acpi_bind_one(struct device *
 	acpi_dev->physical_node_count++;
 	mutex_unlock(&acpi_dev->physical_node_lock);
 
-	dev->archdata.acpi_handle = handle;
+	dev->acpi_handle = handle;
 
 	if (!physical_node->node_id)
 		strcpy(physical_node_name, PHYSICAL_NODE_STRING);
@@ -198,11 +198,10 @@ static int acpi_unbind_one(struct device
 	acpi_status status;
 	struct list_head *node, *next;
 
-	if (!dev->archdata.acpi_handle)
+	if (!dev->acpi_handle)
 		return 0;
 
-	status = acpi_bus_get_device(dev->archdata.acpi_handle,
-		&acpi_dev);
+	status = acpi_bus_get_device(dev->acpi_handle, &acpi_dev);
 	if (ACPI_FAILURE(status))
 		goto err;
 
@@ -228,7 +227,7 @@ static int acpi_unbind_one(struct device
 
 		sysfs_remove_link(&acpi_dev->dev.kobj, physical_node_name);
 		sysfs_remove_link(&dev->kobj, "firmware_node");
-		dev->archdata.acpi_handle = NULL;
+		dev->acpi_handle = NULL;
 		/* acpi_bind_one increase refcnt by one */
 		put_device(dev);
 		kfree(entry);
@@ -269,8 +268,7 @@ static int acpi_platform_notify(struct d
 	if (!ret) {
 		struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
 
-		acpi_get_name(dev->archdata.acpi_handle,
-			      ACPI_FULL_PATHNAME, &buffer);
+		acpi_get_name(dev->acpi_handle, ACPI_FULL_PATHNAME, &buffer);
 		DBG("Device %s -> %s\n", dev_name(dev), (char *)buffer.pointer);
 		kfree(buffer.pointer);
 	} else
Index: linux/include/acpi/acpi_bus.h
===================================================================
--- linux.orig/include/acpi/acpi_bus.h
+++ linux/include/acpi/acpi_bus.h
@@ -410,7 +410,7 @@ acpi_handle acpi_get_child(acpi_handle,
 int acpi_is_root_bridge(acpi_handle);
 acpi_handle acpi_get_pci_rootbridge_handle(unsigned int, unsigned int);
 struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
-#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->archdata.acpi_handle))
+#define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)((dev)->acpi_handle))
 
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int state);
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
Index: linux/include/linux/device.h
===================================================================
--- linux.orig/include/linux/device.h
+++ linux/include/linux/device.h
@@ -190,6 +190,7 @@ extern struct klist *bus_get_device_klis
  * @mod_name:	Used for built-in modules.
  * @suppress_bind_attrs: Disables bind/unbind via sysfs.
  * @of_match_table: The open firmware table.
+ * @acpi_match_table: The ACPI match table.
  * @probe:	Called to query the existence of a specific device,
  *		whether this driver can work with it, and bind the driver
  *		to a specific device.
@@ -223,6 +224,7 @@ struct device_driver {
 	bool suppress_bind_attrs;	/* disables bind/unbind via sysfs */
 
 	const struct of_device_id	*of_match_table;
+	const struct acpi_device_id	*acpi_match_table;
 
 	int (*probe) (struct device *dev);
 	int (*remove) (struct device *dev);
@@ -616,6 +618,7 @@ struct device_dma_parameters {
  * @dma_mem:	Internal for coherent mem override.
  * @archdata:	For arch-specific additions.
  * @of_node:	Associated device tree node.
+ * @acpi_handle: Associated ACPI device node's namespace handle.
  * @devt:	For creating the sysfs "dev".
  * @id:		device instance
  * @devres_lock: Spinlock to protect the resource of the device.
@@ -680,6 +683,7 @@ struct device {
 	struct dev_archdata	archdata;
 
 	struct device_node	*of_node; /* associated device tree node */
+	void			*acpi_handle; /* associated ACPI device node */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 	u32			id;	/* device instance */
Index: linux/arch/x86/include/asm/device.h
===================================================================
--- linux.orig/arch/x86/include/asm/device.h
+++ linux/arch/x86/include/asm/device.h
@@ -2,9 +2,6 @@
 #define _ASM_X86_DEVICE_H
 
 struct dev_archdata {
-#ifdef CONFIG_ACPI
-	void	*acpi_handle;
-#endif
 #ifdef CONFIG_X86_DEV_DMA_OPS
 	struct dma_map_ops *dma_ops;
 #endif
Index: linux/arch/ia64/include/asm/device.h
===================================================================
--- linux.orig/arch/ia64/include/asm/device.h
+++ linux/arch/ia64/include/asm/device.h
@@ -7,9 +7,6 @@
 #define _ASM_IA64_DEVICE_H
 
 struct dev_archdata {
-#ifdef CONFIG_ACPI
-	void	*acpi_handle;
-#endif
 #ifdef CONFIG_INTEL_IOMMU
 	void *iommu; /* hook for IOMMU specific extension */
 #endif
