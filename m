Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1EAFvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 01:51:21 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40129 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1EAFvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 01:51:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oUKAQtMTLpwELS1hUBfPGemFJWYtGX4QrFB6SnmXMOYjlvMUoq+ELrkMIK2JA2guZE
         xYNpX2kJBiVmI43fGzq214jjKZWD1Ub4N8yGxzxuHmpqbw0Fjr+f6dNdhtECcrmXPIVP
         ZOOVWMTKwf5cxUlwt2CaHRL7XYWFcaD7Q4IgA=
From: wanlong.gao@gmail.com
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: rdunlap@xenotime.net, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] Fix the over time interface of the driver-model docs
Date: Sun,  1 May 2011 13:50:56 +0800
Message-Id: <1304229056-5554-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao<wanlong.gao@gmail.com>

The driver-model documentation seems like out-of-date, Can we
fix them or rewrite ?

Signed-off-by: Wanlong Gao<wanlong.gao@gmail.com>
---
 Documentation/driver-model/bus.txt    |   32 ++++----
 Documentation/driver-model/device.txt |  149 +++++++++++++++++++--------------
 2 files changed, 104 insertions(+), 77 deletions(-)

diff --git a/Documentation/driver-model/bus.txt b/Documentation/driver-model/bus.txt
index 5001b75..82bca26 100644
--- a/Documentation/driver-model/bus.txt
+++ b/Documentation/driver-model/bus.txt
@@ -5,21 +5,23 @@ Definition
 ~~~~~~~~~~
 
 struct bus_type {
-	char			* name;
+	const char		*name;
+	struct bus_attribute	*bus_attrs;
+	struct device_attribute	*dev_attrs;
+	struct driver_attribute	*drv_attrs;
 
-	struct subsystem	subsys;
-	struct kset		drivers;
-	struct kset		devices;
+	int (*match)(struct device *dev, struct device_driver *drv);
+	int (*uevent)(struct device *dev, struct kobj_uevent_env *env);
+	int (*probe)(struct device *dev);
+	int (*remove)(struct device *dev);
+	void (*shutdown)(struct device *dev);
 
-	struct bus_attribute	* bus_attrs;
-	struct device_attribute	* dev_attrs;
-	struct driver_attribute	* drv_attrs;
+	int (*suspend)(struct device *dev, pm_message_t state);
+	int (*resume)(struct device *dev);
 
-	int		(*match)(struct device * dev, struct device_driver * drv);
-	int		(*hotplug) (struct device *dev, char **envp, 
-				    int num_envp, char *buffer, int buffer_size);
-	int		(*suspend)(struct device * dev, pm_message_t state);
-	int		(*resume)(struct device * dev);
+	const struct dev_pm_ops *pm;
+
+	struct subsys_private *p;
 };
 
 int bus_register(struct bus_type * bus);
@@ -127,9 +129,9 @@ hierarchy:
 
 	/sys/bus/pci/
 	|-- devices
-	|   |-- 00:00.0 -> ../../../root/pci0/00:00.0
-	|   |-- 00:01.0 -> ../../../root/pci0/00:01.0
-	|   `-- 00:02.0 -> ../../../root/pci0/00:02.0
+	|   |-- 00:00.0 -> ../../../devices/pci0/00:00.0
+	|   |-- 00:01.0 -> ../../../devices/pci0/00:01.0
+	|   `-- 00:02.0 -> ../../../devices/pci0/00:02.0
 	`-- drivers
 
 
diff --git a/Documentation/driver-model/device.txt b/Documentation/driver-model/device.txt
index a124f31..98dca04 100644
--- a/Documentation/driver-model/device.txt
+++ b/Documentation/driver-model/device.txt
@@ -3,95 +3,121 @@ The Basic Device Structure
 ~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 struct device {
-        struct list_head g_list;
-        struct list_head node;
-        struct list_head bus_list;
-        struct list_head driver_list;
-        struct list_head intf_list;
-        struct list_head children;
-        struct device   * parent;
+	struct device		*parent;
 
-        char    name[DEVICE_NAME_SIZE];
-        char    bus_id[BUS_ID_SIZE];
+	struct device_private	*p;
 
-        spinlock_t      lock;
-        atomic_t        refcount;
+	struct kobject kobj;
+	const char		*init_name;
+	struct device_type	*type;
 
-        struct bus_type * bus;
-        struct driver_dir_entry dir;
+	struct mutex		mutex;
+	struct bus_type	*bus;
+	struct device_driver *driver;
+	void		*platform_data;
+	struct dev_pm_info	power;
+	struct dev_power_domain	*pwr_domain;
 
-	u32		class_num;
+#ifdef CONFIG_NUMA
+	int		numa_node;
+#endif
+	u64		*dma_mask;
+	u64		coherent_dma_mask;
 
-        struct device_driver *driver;
-        void            *driver_data;
-        void            *platform_data;
+	struct device_dma_parameters *dma_parms;
 
-        u32             current_state;
-        unsigned char *saved_state;
+	struct list_head	dma_pools;
 
-        void    (*release)(struct device * dev);
+	struct dma_coherent_mem	*dma_mem;
+	struct dev_archdata	archdata;
+
+	struct device_node	*of_node;
+	const struct of_device_id *of_match;
+
+	dev_t			devt;
+
+	spinlock_t		devres_lock;
+	struct list_head	devres_head;
+
+	struct klist_node	knode_class;
+	struct class		*class;
+	const struct attribute_group **groups;
+
+	void	(*release)(struct device *dev);
 };
 
 Fields 
 ~~~~~~
-g_list:	Node in the global device list.
+parent:		Parent of the device.
+
+p:		Hold the private to the driver core portions of the device.
+		See the comment of the struct device_private for detail.
+
+kobj:		A top-level, abstract class from which other classes are derived.
+
+init_name:	Initial name of the device.
+
+type:		The type of device.
+		This identifies the device type and carries type-specific
+		information.
+
+mutex:		Mutex to synchronize calls to its driver.
 
-node:	Node in device's parent's children list.
+bus:		Type of bus device is on.
 
-bus_list: Node in device's bus's devices list.
+platform_data:	Platform data specific to the device.
 
-driver_list:   Node in device's driver's devices list.
+		Example:  for devices on custom boards, as typical of embedded
+		and SOC based hardware, Linux often uses platform_data to point
+		to board-specific structures describing devices and how they
+		are wired.  That can include what ports are available, chip
+		variants, which GPIO pins act in what additional roles, and so
+		on.  This shrinks the "Board Support Packages" (BSPs) and
+		minimizes board-specific #ifdefs in drivers.
 
-intf_list:     List of intf_data. There is one structure allocated for
-	       each interface that the device supports.
+power:		For device power management.
+		See the Documentation/power/devices.txt for details.
 
-children:      List of child devices.
+dev_power_domain:Provide callbacks that are executed during system suspend,
+		hibernation, system resume and during runtime PM transitions 
+		along with subsystem-level and driver-level callbacks.
 
-parent:        *** FIXME ***
+numa_node:	NUMA node this device is close to.
 
-name:	       ASCII description of device. 
-	       Example: " 3Com Corporation 3c905 100BaseTX [Boomerang]"
+dma_mask:	Dma mask (if dma'ble device).
 
-bus_id:	       ASCII representation of device's bus position. This 
-	       field should be a name unique across all devices on the
-	       bus type the device belongs to. 
+coherent_dma_mask:Like dma_mask, but for alloc_coherent mapping as not all
+		hardware supports 64 bit addresses for consistent allocations
+		such description.
 
-	       Example: PCI bus_ids are in the form of
-	       <bus number>:<slot number>.<function number> 
-	       This name is unique across all PCI devices in the system.
+dma_parms:	A low level driver may set these to teach IOMMU code about
+		segment limitations.
 
-lock:	       Spinlock for the device. 
+dma_pools:	Dma pools (if dma'ble device) .
 
-refcount:      Reference count on the device.
+dma_mem:	Internal for coherent mem override.
 
-bus:	       Pointer to struct bus_type that device belongs to.
+archdata:	For arch specific additions.
 
-dir:	       Device's sysfs directory.
+of_node:	Associated device tree node.
 
-class_num:     Class-enumerated value of the device.
+of_match:	Matching of_device_id from driver.
 
-driver:	       Pointer to struct device_driver that controls the device.
+devt:		For creating the sysfs "dev".
 
-driver_data:   Driver-specific data.
+devres_lock:	Spinlock to protect the resource of the device.
 
-platform_data: Platform data specific to the device.
+devres_head:	The resources list of the device.
 
-	       Example:  for devices on custom boards, as typical of embedded
-	       and SOC based hardware, Linux often uses platform_data to point
-	       to board-specific structures describing devices and how they
-	       are wired.  That can include what ports are available, chip
-	       variants, which GPIO pins act in what additional roles, and so
-	       on.  This shrinks the "Board Support Packages" (BSPs) and
-	       minimizes board-specific #ifdefs in drivers.
+knode_class:	The node used to add the device to the class list.
 
-current_state: Current power state of the device.
+class:		The class of the device.
 
-saved_state:   Pointer to saved state of the device. This is usable by
-	       the device driver controlling the device.
+groups:		Optional attribute groups.
 
-release:       Callback to free the device after all references have 
-	       gone away. This should be set by the allocator of the 
-	       device (i.e. the bus driver that discovered the device).
+release:	Callback to free the device after all references have 
+		gone away. This should be set by the allocator of the 
+		device (i.e. the bus driver that discovered the device).
 
 
 Programming Interface
@@ -104,8 +130,7 @@ int device_register(struct device * dev);
 The bus should initialize the following fields:
 
     - parent
-    - name
-    - bus_id
+    - init_name OR kobj->name
     - bus
 
 A device is removed from the core when its reference count goes to
@@ -120,8 +145,8 @@ removed already).
 
 A driver can access the lock in the device structure using: 
 
-void lock_device(struct device * dev);
-void unlock_device(struct device * dev);
+void device_lock(struct device * dev);
+void device_unlock(struct device * dev);
 
 
 Attributes
@@ -193,4 +218,4 @@ Then in the module init function is would do:
 
 And assuming 'dev' is the struct device passed into the probe hook, the driver
 probe function would do something like:
-	create_device(&mydriver_class, dev, chrdev, &private_data, "my_name");
+	device_create(&mydriver_class, dev->parent, devt, &drvdata, "my_name");
-- 
1.7.4.1

