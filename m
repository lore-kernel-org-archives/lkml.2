Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935022Ab1ETANo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:13:44 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:51486 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934982Ab1ETAMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:12:13 -0400
X-Sasl-enc: mzjWydoLdQLlTESbNbHZ95c1H0qf20q0Bh/Iq865y+NQ 1305850332
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Wanlong Gao <wanlong.gao@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 38/44] driver core: Add the device driver-model structures to kerneldoc
Date: Thu, 19 May 2011 17:10:56 -0700
Message-Id: <1305850262-9575-38-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

Add the comments to the structure bus_type, device_driver, device,
class to device.h for generating the driver-model kerneldoc. With another patch
these all removed from the files in Documentation/driver-model/ since
they are out of date. That will keep things up to date and provide a better way
to document this stuff.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
Acked-by: Harry Wei <harryxiyou@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 Documentation/DocBook/device-drivers.tmpl |    6 +-
 include/linux/device.h                    |  154 ++++++++++++++++++++++++++++-
 2 files changed, 154 insertions(+), 6 deletions(-)

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index 36f63d4..b638e50 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -96,10 +96,10 @@ X!Iinclude/linux/kobject.h
 
   <chapter id="devdrivers">
      <title>Device drivers infrastructure</title>
+     <sect1><title>The Basic Device Driver-Model Structures </title>
+!Iinclude/linux/device.h
+     </sect1>
      <sect1><title>Device Drivers Base</title>
-<!--
-X!Iinclude/linux/device.h
--->
 !Edrivers/base/driver.c
 !Edrivers/base/core.c
 !Edrivers/base/class.c
diff --git a/include/linux/device.h b/include/linux/device.h
index 2215d01..4236506 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -47,6 +47,38 @@ extern int __must_check bus_create_file(struct bus_type *,
 					struct bus_attribute *);
 extern void bus_remove_file(struct bus_type *, struct bus_attribute *);
 
+/**
+ * struct bus_type - The bus type of the device
+ *
+ * @name:	The name of the bus.
+ * @bus_attrs:	Default attributes of the bus.
+ * @dev_attrs:	Default attributes of the devices on the bus.
+ * @drv_attrs:	Default attributes of the device drivers on the bus.
+ * @match:	Called, perhaps multiple times, whenever a new device or driver
+ *		is added for this bus. It should return a nonzero value if the
+ *		given device can be handled by the given driver.
+ * @uevent:	Called when a device is added, removed, or a few other things
+ *		that generate uevents to add the environment variables.
+ * @probe:	Called when a new device or driver add to this bus, and callback
+ *		the specific driver's probe to initial the matched device.
+ * @remove:	Called when a device removed from this bus.
+ * @shutdown:	Called at shut-down time to quiesce the device.
+ * @suspend:	Called when a device on this bus wants to go to sleep mode.
+ * @resume:	Called to bring a device on this bus out of sleep mode.
+ * @pm:		Power management operations of this bus, callback the specific
+ *		device driver's pm-ops.
+ * @p:		The private data of the driver core, only the driver core can
+ *		touch this.
+ *
+ * A bus is a channel between the processor and one or more devices. For the
+ * purposes of the device model, all devices are connected via a bus, even if
+ * it is an internal, virtual, "platform" bus. Buses can plug into each other.
+ * A USB controller is usually a PCI device, for example. The device model
+ * represents the actual connections between buses and the devices they control.
+ * A bus is represented by the bus_type structure. It contains the name, the
+ * default attributes, the bus' methods, PM operations, and the driver core's
+ * private data.
+ */
 struct bus_type {
 	const char		*name;
 	struct bus_attribute	*bus_attrs;
@@ -119,6 +151,37 @@ extern int bus_unregister_notifier(struct bus_type *bus,
 extern struct kset *bus_get_kset(struct bus_type *bus);
 extern struct klist *bus_get_device_klist(struct bus_type *bus);
 
+/**
+ * struct device_driver - The basic device driver structure
+ * @name:	Name of the device driver.
+ * @bus:	The bus which the device of this driver belongs to.
+ * @owner:	The module owner.
+ * @mod_name:	Used for built-in modules.
+ * @suppress_bind_attrs: Disables bind/unbind via sysfs.
+ * @of_match_table: The open firmware table.
+ * @probe:	Called to query the existence of a specific device,
+ *		whether this driver can work with it, and bind the driver
+ *		to a specific device.
+ * @remove:	Called when the device is removed from the system to
+ *		unbind a device from this driver.
+ * @shutdown:	Called at shut-down time to quiesce the device.
+ * @suspend:	Called to put the device to sleep mode. Usually to a
+ *		low power state.
+ * @resume:	Called to bring a device from sleep mode.
+ * @groups:	Default attributes that get created by the driver core
+ *		automatically.
+ * @pm:		Power management operations of the device which matched
+ *		this driver.
+ * @p:		Driver core's private data, no one other than the driver
+ *		core can touch this.
+ *
+ * The device driver-model tracks all of the drivers known to the system.
+ * The main reason for this tracking is to enable the driver core to match
+ * up drivers with new devices. Once drivers are known objects within the
+ * system, however, a number of other things become possible. Device drivers
+ * can export information and configuration variables that are independent
+ * of any specific device.
+ */
 struct device_driver {
 	const char		*name;
 	struct bus_type		*bus;
@@ -185,8 +248,34 @@ struct device *driver_find_device(struct device_driver *drv,
 				  struct device *start, void *data,
 				  int (*match)(struct device *dev, void *data));
 
-/*
- * device classes
+/**
+ * struct class - device classes
+ * @name:	Name of the class.
+ * @owner:	The module owner.
+ * @class_attrs: Default attributes of this class.
+ * @dev_attrs:	Default attributes of the devices belong to the class.
+ * @dev_bin_attrs: Default binary attributes of the devices belong to the class.
+ * @dev_kobj:	The kobject that represents this class and links it into the hierarchy.
+ * @dev_uevent:	Called when a device is added, removed from this class, or a
+ *		few other things that generate uevents to add the environment
+ *		variables.
+ * @devnode:	Callback to provide the devtmpfs.
+ * @class_release: Called to release this class.
+ * @dev_release: Called to release the device.
+ * @suspend:	Used to put the device to sleep mode, usually to a low power
+ *		state.
+ * @resume:	Used to bring the device from the sleep mode.
+ * @ns_type:	Callbacks so sysfs can detemine namespaces.
+ * @namespace:	Namespace of the device belongs to this class.
+ * @pm:		The default device power management operations of this class.
+ * @p:		The private data of the driver core, no one other than the
+ *		driver core can touch this.
+ *
+ * A class is a higher-level view of a device that abstracts out low-level
+ * implementation details. Drivers may see a SCSI disk or an ATA disk, but,
+ * at the class level, they are all simply disks. Classes allow user space
+ * to work with devices based on what they do, rather than how they are
+ * connected or how they work.
  */
 struct class {
 	const char		*name;
@@ -401,6 +490,65 @@ struct device_dma_parameters {
 	unsigned long segment_boundary_mask;
 };
 
+/**
+ * struct device - The basic device structure
+ * @parent:	The device's "parent" device, the device to which it is attached.
+ * 		In most cases, a parent device is some sort of bus or host
+ * 		controller. If parent is NULL, the device, is a top-level device,
+ * 		which is not usually what you want.
+ * @p:		Holds the private data of the driver core portions of the device.
+ * 		See the comment of the struct device_private for detail.
+ * @kobj:	A top-level, abstract class from which other classes are derived.
+ * @init_name:	Initial name of the device.
+ * @type:	The type of device.
+ * 		This identifies the device type and carries type-specific
+ * 		information.
+ * @mutex:	Mutex to synchronize calls to its driver.
+ * @bus:	Type of bus device is on.
+ * @driver:	Which driver has allocated this
+ * @platform_data: Platform data specific to the device.
+ * 		Example: For devices on custom boards, as typical of embedded
+ * 		and SOC based hardware, Linux often uses platform_data to point
+ * 		to board-specific structures describing devices and how they
+ * 		are wired.  That can include what ports are available, chip
+ * 		variants, which GPIO pins act in what additional roles, and so
+ * 		on.  This shrinks the "Board Support Packages" (BSPs) and
+ * 		minimizes board-specific #ifdefs in drivers.
+ * @power:	For device power management.
+ * 		See Documentation/power/devices.txt for details.
+ * @pwr_domain:	Provide callbacks that are executed during system suspend,
+ * 		hibernation, system resume and during runtime PM transitions
+ * 		along with subsystem-level and driver-level callbacks.
+ * @numa_node:	NUMA node this device is close to.
+ * @dma_mask:	Dma mask (if dma'ble device).
+ * @coherent_dma_mask: Like dma_mask, but for alloc_coherent mapping as not all
+ * 		hardware supports 64-bit addresses for consistent allocations
+ * 		such descriptors.
+ * @dma_parms:	A low level driver may set these to teach IOMMU code about
+ * 		segment limitations.
+ * @dma_pools:	Dma pools (if dma'ble device).
+ * @dma_mem:	Internal for coherent mem override.
+ * @archdata:	For arch-specific additions.
+ * @of_node:	Associated device tree node.
+ * @of_match:	Matching of_device_id from driver.
+ * @devt:	For creating the sysfs "dev".
+ * @devres_lock: Spinlock to protect the resource of the device.
+ * @devres_head: The resources list of the device.
+ * @knode_class: The node used to add the device to the class list.
+ * @class:	The class of the device.
+ * @groups:	Optional attribute groups.
+ * @release:	Callback to free the device after all references have
+ * 		gone away. This should be set by the allocator of the
+ * 		device (i.e. the bus driver that discovered the device).
+ *
+ * At the lowest level, every device in a Linux system is represented by an
+ * instance of struct device. The device structure contains the information
+ * that the device model core needs to model the system. Most subsystems,
+ * however, track additional information about the devices they host. As a
+ * result, it is rare for devices to be represented by bare device structures;
+ * instead, that structure, like kobject structures, is usually embedded within
+ * a higher-level representation of the device.
+ */
 struct device {
 	struct device		*parent;
 
@@ -611,7 +759,7 @@ extern int (*platform_notify)(struct device *dev);
 extern int (*platform_notify_remove)(struct device *dev);
 
 
-/**
+/*
  * get_device - atomically increment the reference count for the device.
  *
  */
-- 
1.7.4.2

