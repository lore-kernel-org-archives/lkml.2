Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1HJXcG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 19:32:06 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53403 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab1HJXcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 19:32:03 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6434"; a="109478581"
From: Kenneth Heitke <kheitke@codeaurora.org>
To: davidb@codeaurora.org, bryanh@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        ohad@wizery.com, gregkh@suse.de, stefanr@s5r6.in-berlin.de,
        lethal@linux-sh.org, linville@tuxdriver.com, zajec5@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Wed, 10 Aug 2011 17:31:28 -0600
Message-Id: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
X-Mailer: git-send-email 1.7.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sagar Dharia <sdharia@codeaurora.org>

SLIMbus (Serial Low Power Interchip Media Bus) is a specification
developed by MIPI (Mobile Industry Processor Interface) alliance.
SLIMbus is a 2-wire implementation, which is used to communicate with
peripheral components like audio. Commonly used digital audio
interfaces such as I2S, PCM are intended for point-to-point connection
between application processor and single audio device and support one
or two channels. Adding more channels or functions is difficult
without increasing number of bus structures and hence pin count.
In parallel to audio channels, control buses such as I2C are typically
used for low-bandwidth control tasks.
SLIMbus replaces many digital audio buses and control buses by
providing flexible and dynamic bus-bandwidth between data-functions
and control-functions.

The framework supports message APIs, channel scheduling for SLIMbus.
Message APIs are used for status/control type of communication with a
device. Data Channel APIs are used for setting data channels between
SLIMbus devices.

Framework supports multiple busses (1 controller per bus) and multiple
clients/slave devices per controller.

Signed-off-by: Sagar Dharia <sdharia@codeaurora.org>
---
 Documentation/slimbus/slimbus-framework.txt |  282 +++
 drivers/Kconfig                             |    2 +
 drivers/Makefile                            |    1 +
 drivers/slimbus/Kconfig                     |   10 +
 drivers/slimbus/Makefile                    |    4 +
 drivers/slimbus/slimbus.c                   | 2629 +++++++++++++++++++++++++++
 include/linux/mod_devicetable.h             |    9 +
 include/linux/slimbus/slimbus.h             |  939 ++++++++++
 8 files changed, 3876 insertions(+), 0 deletions(-)
 create mode 100755 Documentation/slimbus/slimbus-framework.txt
 create mode 100644 drivers/slimbus/Kconfig
 create mode 100644 drivers/slimbus/Makefile
 create mode 100644 drivers/slimbus/slimbus.c
 create mode 100644 include/linux/slimbus/slimbus.h

diff --git a/Documentation/slimbus/slimbus-framework.txt b/Documentation/slimbus/slimbus-framework.txt
new file mode 100755
index 0000000..a091417
--- /dev/null
+++ b/Documentation/slimbus/slimbus-framework.txt
@@ -0,0 +1,282 @@
+Introduction
+============
+
+Slimbus (Serial Low Power Interchip Media Bus) is a specification developed by
+MIPI (Mobile Industry Processor Interface) alliance. Slimbus is a 2-wire
+implementation, which is used to communicate with peripheral components like
+audio. Commonly used digital audio interfaces such as I2S, PCM are intended for
+point-to-point connection between application processor and single audio device
+and support one or two channels. Adding more channels or functions is difficult
+without increasing number of bus structures and hence pin count. In parallel to
+audio channels, control buses such as I2C are typically used for low-bandwidth
+control tasks.
+
+Slimbus replaces many digital audio buses and control buses by providing
+flexible and dynamic bus-bandwidth between data-functions and control-functions.
+
+
+
+Hardware Description
+====================
+
+Slimbus is a 2-wire multi-drop interface and uses TDM frame structure.
+The devices communicate over a shared bus using predefined transport protocols.
+There are 2 different type of transports.
+
+The message transport is used for various control functions such as bus
+management, configuration and status updates. Messages are seen by all devices
+and the messages can be of unicast and broadcast type. e.g. Reading/writing
+device specific values is typically a unicast message. A data channel
+reconfiguration sequence is announced to all devices using broadcast message.
+
+A data transport is used for data-transfer between 2 Slimbus devices. Data
+transport uses dedicated ports on the device. This data-transfer is not seen
+by all devices.
+
+Slimbus specification has different types of device classifications based on
+their capabilities. Manager device is responsible for enumeration,
+configuration, and dynamic channel allocation. Every bus has 1 active manager.
+Framer device is responsible for driving clock line and placing information on
+data line. Multiple framers may exist on a bus and manager is responsible for
+doing framer-handoffs. (Not supported in the SW driver right now).
+
+Per specification, Slimbus uses "clock gears" to do power management based on
+current frequency and bandwidth requirements. There are 10 clock gears and each
+gear changes the Slimbus frequency to be twice of its previous gear.
+
+Generic device is a device providing Slimbus functionality and typically has
+ports for data-channel support. Its registers are mapped as 'value elements'
+so that they can be written/read using Slimbus message transport for
+exchanging control/status type of information. Generic devices are also referred
+to as 'clients' in this document from here-onwards.
+
+Each device has a 6-byte elemental-address and the manager assigns every device
+with a 1-byte logical address after the devices report present on the bus.
+
+Slimbus uses TDM framing at the physical layer and has variable number of
+frames used for messaging and data-channels. The TDM framing is out of scope
+of this document since clients can not directly access or interfere with it.
+
+
+
+Software Description:
+====================
+
+Initialization/Bringup:
+-----------------------
+Each bus has one active manager and that is represented by slim_controller
+data structure. The controller is probed during initial kernel bring-up and it
+is responsible to probe other "Generic Devices" and "Framer Devices". All
+devices report present (Broadcast message) after they are probed and
+manager stores their elemental addresses and assigns logical addresses. Clients
+get their logical address by calling a public API in case they don't get
+interrupt after receiving the message.
+
+Clients are added using similar logic to I2C. (There is one controller per
+Slimbus who does active-manager duties. Each controller has a bus-number and
+the clients are populated in boards file on that controller). This way, it is
+more target-independent. In addition, clients can be added to the controller
+using add_device API. This is useful if the client is to be added later
+(as a module). It is also useful if each slave can have multiple elemental
+generic devices but only one driver. The generic device (slave) driver can then
+add more devices per its capability and still have 1 driver.
+
+Framers are also added per numbered controller and they are expected to
+initialize/enable clock related hardware in their probe. It may be common to
+have 1 driver for manager (controller) and framer. In that case, separate framer
+device and/or driver is not needed. Framer handover can be used by controller to
+change framer per Slimbus spec, but the capability is not currently implemented
+in this framework yet.
+
+Message-based APIs:
+-------------------
+As described earlier, control and status information can be exchanged on
+Slimbus. Slimbus client device driver can write/read control registers using the
+message-based APIs for doing elemental accesses. Per Slimbus specification,
+there are two type of elements in every device. Value based (values can be
+read/written) and information based (bit-wise information can be set/cleared).
+Slimbus slave device driver can call these APIs. This typically replaces I2C
+type of control/status transaction. Framework makes sanity checks based on
+Slimbus specification and then calls controller specific message transfer
+function pointer. The sanity checks make sure that accesses to reserved-address
+space are not allowed, or the size of message isn't out-of-bounds per the
+specification.
+
+Messages are queued in a work-queue (per controller). Slimbus specification has
+transaction identification number (TID) for each transaction expecting response.
+The transaction message is kept per controller until response is received, or
+write-acknowledgement is received.
+
+Client can request to reserve certain bandwidth for messaging if it anticipates
+heavy messaging-traffic on the bus. Slimbus framework tries to reserve the
+messaging bandwidth and may decide to change clock frequency (clock gear)
+based on existing data-channels on the bus and current frequency (clock gear),
+and pre-existing reserved-message bandwidth. Reserving bandwidth will fail if
+clock gear is already maximum and pre-existing data channels and the newly
+requested reserved bandwidth cannot be satisfied.
+
+Data Channel based APIs:
+------------------------
+Data channels can be setup between 2 devices using their data ports. Per
+Slimbus specification, there can be multiple sources and one sink per one data
+channel. Each data channel is uniquely defined by its location in the TDM frame.
+Every manager device also typically has many ports and they are used for data
+transfer between software and the device. Ports have different configuration and
+request types. For each half-duplex port, 2 adjacent physical ports are located.
+
+A port can have source or sink flow. Port has events/errors associated with it.
+Typically, client requests ports on manager and slave devices. That causes a
+Slimbus specification message to be sent to the device (connect-source or
+connect-sink). Once the port allocation is done, client requests for channel to
+be allocated using the ports it has. Data channel has different protocols
+(such as isochronous, soft-isochronous, asynchronous) based on the clock at
+which Slimbus runs and the channel bandwidth requirements. Clients specify rate
+and the protocol to allocate channel. Clients then call transfer on the port
+with the input/output vectors and specify completion structure to be notified.
+Clients then call channel activation API to activate the channel.
+
+Channels with common parameters can benefit from grouping. Grouping channels
+helps to schedule/deactive a set of channels at the same time. (e.g. 5.1 audio).
+Framework signals completion when the buffers are done and it's upto client to
+supply more buffers and/or deactivate the channel. Completion signal is also
+used to communicate port errors to the client. It's upto the client to act
+according to the error.  Activation/Deactivation can be done on a pre-existing
+channels. Clients can call deallocation APIs on channels and/or ports when they
+no longer need the resources.
+
+Clients use "commit" flag in the control channel APIs to group their requests.
+This avoids sending the expensive reconfiguration sequence on the bus too
+frequently. Once the "commit" flag is set, all channel-requests pending on that
+client are acted upon (active-channels are scheduled, remove-channels are
+removed from scheduling etc.)
+
+Scheduling of channels: Controller and/or framework will call API to reschedule
+TDM framing as it is deemed necessary. This is internally implemented by the
+framework based on current data-channel and message bandwidth requirements.
+Controller may also change scheduling of already active-channels to use TDM
+effectively.
+
+
+
+Design
+======
+Bus-type:
+---------
+Slimbus is represented as a bus and different type of devices listed above hang
+on it. The bus registers with Linux kernel in early stages of kernel bringup.
+Every Slimbus typically has one manager device, one framer device, and multiple
+generic devices (clients). When a device is added/registered, Slimbus matches a
+driver (registered earlier) and calls the driver probe.
+
+Message transactions:
+---------------------
+For faster and efficient transaction management, Linux framework uses tid for
+every transaction irrespective of whether it expects a response. This helps in
+O(1) search of the transaction when it's complete, or its response is received,
+or it needs to be resent due to collision/NACK. Once transaction is complete,
+its resources are just marked unused and not deleted. A transaction is allocated
+if an unused transaction is not found. Per Slimbus specification, TID is 8-bit
+long and cannot exceed 256. So this won't cause a lot of memory usage and
+allocation for transactions won't be required to be done too often.
+
+Ports and channels:
+-------------------
+Manager-ports and channels are allocated as arrays. This helps faster access
+based on channel/port number. Typically number of ports and channels are limited
+and having this as a list won't gain significant memory advantage.
+
+For effective scheduling, 2 most commonly used frequency-channels (4KHz and
+12KHz) are grouped in 2 sorted lists. The lists only have pointers (to channel
+elements allocated above).
+
+
+Power Management
+================
+Slimbus hardware uses only 2 wires for managing multiple devices, multiple
+channels and control/status messaging. This is power efficient. In addition,
+clock gears are used to go to lower clock gears when low-bandwidth messaging
+is used and/or limited data channels are used. Controller will call clock-pause
+API to pause the slimbus clock if no channels are active.
+
+Runtime suspend/resume will be used from Linux kernel power management
+framework to implement power management functionality.
+
+
+
+SMP/multi-core
+==============
+Board initialization list for listing devices, framers use a board-specific
+mutex. This mutex is common to all controllers.
+
+Controllers are listed in the framework using idr list. The list is protected by
+a common mutex.
+
+Controller data structures (channel, port, address-table, transaction-id table)
+are protected using a controller mutex.
+
+Reconfiguration mutex per controller is used to make sure that only one
+reconfiguration sequence is in progress per controller.
+
+Client structure has a mutex to protect the pending data channel request-lists
+per client.
+
+
+
+Security
+========
+None at this point.
+
+
+
+Interface
+=========
+There is no plan of exporting slimbus functionality to user space right now.
+
+Kernel space APIs:
+include/linux/slimbus/slimbus.h
+-----------------------
+
+
+
+Driver parameters
+=================
+None.
+
+
+
+Config options
+==============
+Slimbus in drivers/Kconfig
+
+
+
+Dependencies
+============
+None.
+
+
+
+User space utilities
+====================
+None at this point. No user space access is expected for Slimbus at this point.
+If need be, a client can be implemented to manage all use-space accesses
+using ioctl.
+
+
+
+Known issues
+============
+None.
+
+
+
+To do
+=====
+Framer handoff is not supported right now. This is required when a bus has
+multiple framers and active framer needs to be decided on the fly.
+
+Specific logical address request is not supported right now. Client drivers may
+request for specific logical address and that may change logical addresses of
+other preexisting devices on the bus.
+
+Debugfs will be used to debug channel management and bandwidth usage in future.
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 3bb154d..8083490 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -52,6 +52,8 @@ source "drivers/i2c/Kconfig"
 
 source "drivers/spi/Kconfig"
 
+source "drivers/slimbus/Kconfig"
+
 source "drivers/pps/Kconfig"
 
 source "drivers/ptp/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index 09f3232..5ba22a0 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -51,6 +51,7 @@ obj-$(CONFIG_ATA)		+= ata/
 obj-$(CONFIG_TARGET_CORE)	+= target/
 obj-$(CONFIG_MTD)		+= mtd/
 obj-$(CONFIG_SPI)		+= spi/
+obj-$(CONFIG_SLIMBUS)		+= slimbus/
 obj-y				+= net/
 obj-$(CONFIG_ATM)		+= atm/
 obj-$(CONFIG_FUSION)		+= message/
diff --git a/drivers/slimbus/Kconfig b/drivers/slimbus/Kconfig
new file mode 100644
index 0000000..78f8111
--- /dev/null
+++ b/drivers/slimbus/Kconfig
@@ -0,0 +1,10 @@
+#
+# SLIMBUS driver configuration
+#
+menuconfig SLIMBUS
+	bool "SLIMbus support"
+	depends on HAS_IOMEM
+	help
+	  SLIMbus is standard interface between baseband and
+	  application processors and peripheral components in mobile
+	  terminals.
diff --git a/drivers/slimbus/Makefile b/drivers/slimbus/Makefile
new file mode 100644
index 0000000..05f53bc
--- /dev/null
+++ b/drivers/slimbus/Makefile
@@ -0,0 +1,4 @@
+#
+# Makefile for kernel slimbus framework.
+#
+obj-$(CONFIG_SLIMBUS)			+= slimbus.o
diff --git a/drivers/slimbus/slimbus.c b/drivers/slimbus/slimbus.c
new file mode 100644
index 0000000..313837a
--- /dev/null
+++ b/drivers/slimbus/slimbus.c
@@ -0,0 +1,2629 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/completion.h>
+#include <linux/idr.h>
+#include <linux/pm_runtime.h>
+#include <linux/slimbus/slimbus.h>
+
+#define SLIM_PORT_HDL(la, f, p) ((la)<<24 | (f) << 16 | (p))
+
+#define SLIM_HDL_TO_LA(hdl)	((u32)((hdl) & 0xFF000000) >> 24)
+#define SLIM_HDL_TO_FLOW(hdl)	(((u32)(hdl) & 0xFF0000) >> 16)
+#define SLIM_HDL_TO_PORT(hdl)	((u32)(hdl) & 0xFF)
+
+#define SLIM_SLAVE_PORT(p, la)	(((la)<<16) | (p))
+#define SLIM_MGR_PORT(p)	((0xFF << 16) | (p))
+#define SLIM_LA_MANAGER		0xFF
+
+#define SLIM_START_GRP		(1 << 8)
+#define SLIM_END_GRP		(1 << 9)
+
+#define SLIM_MAX_INTR_COEFF_3	(SLIM_SL_PER_SUPERFRAME/3)
+#define SLIM_MAX_INTR_COEFF_1	SLIM_SL_PER_SUPERFRAME
+
+static DEFINE_MUTEX(slim_lock);
+static DEFINE_IDR(ctrl_idr);
+static struct device_type slim_dev_type;
+static struct device_type slim_ctrl_type;
+
+static const struct slim_device_id *slim_match(const struct slim_device_id *id,
+					const struct slim_device *slim_dev)
+{
+	while (id->name[0]) {
+		if (strncmp(slim_dev->name, id->name, SLIMBUS_NAME_SIZE) == 0)
+			return id;
+		id++;
+	}
+	return NULL;
+}
+
+static int slim_device_match(struct device *dev, struct device_driver *driver)
+{
+	struct slim_device *slim_dev;
+	struct slim_driver *drv = to_slim_driver(driver);
+
+	if (dev->type == &slim_dev_type)
+		slim_dev = to_slim_device(dev);
+	else
+		return 0;
+	if (drv->id_table)
+		return slim_match(drv->id_table, slim_dev) != NULL;
+
+	if (driver->name)
+		return strncmp(slim_dev->name, driver->name, SLIMBUS_NAME_SIZE)
+			== 0;
+	return 0;
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int slim_legacy_suspend(struct device *dev, pm_message_t mesg)
+{
+	struct slim_device *slim_dev = NULL;
+	struct slim_driver *driver;
+	if (dev->type == &slim_dev_type)
+		slim_dev = to_slim_device(dev);
+
+	if (!slim_dev || !dev->driver)
+		return 0;
+
+	driver = to_slim_driver(dev->driver);
+	if (!driver->suspend)
+		return 0;
+
+	return driver->suspend(slim_dev, mesg);
+}
+
+static int slim_legacy_resume(struct device *dev)
+{
+	struct slim_device *slim_dev = NULL;
+	struct slim_driver *driver;
+	if (dev->type == &slim_dev_type)
+		slim_dev = to_slim_device(dev);
+
+	if (!slim_dev || !dev->driver)
+		return 0;
+
+	driver = to_slim_driver(dev->driver);
+	if (!driver->resume)
+		return 0;
+
+	return driver->resume(slim_dev);
+}
+
+static int slim_pm_suspend(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm)
+		return pm_generic_suspend(dev);
+	else
+		return slim_legacy_suspend(dev, PMSG_SUSPEND);
+}
+
+static int slim_pm_resume(struct device *dev)
+{
+	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
+
+	if (pm)
+		return pm_generic_resume(dev);
+	else
+		return slim_legacy_resume(dev);
+}
+
+#else
+#define slim_pm_suspend		NULL
+#define slim_pm_resume		NULL
+#endif
+
+static const struct dev_pm_ops slimbus_pm = {
+	.suspend = slim_pm_suspend,
+	.resume = slim_pm_resume,
+	SET_RUNTIME_PM_OPS(
+		pm_generic_suspend,
+		pm_generic_resume,
+		pm_generic_runtime_idle
+		)
+};
+struct bus_type slimbus_type = {
+	.name		= "slimbus",
+	.match		= slim_device_match,
+	.pm		= &slimbus_pm,
+};
+EXPORT_SYMBOL_GPL(slimbus_type);
+
+struct device slimbus_dev = {
+	.init_name = "slimbus",
+};
+
+static void __exit slimbus_exit(void)
+{
+	device_unregister(&slimbus_dev);
+	bus_unregister(&slimbus_type);
+}
+
+static int __init slimbus_init(void)
+{
+	int retval;
+
+	retval = bus_register(&slimbus_type);
+	if (!retval)
+		retval = device_register(&slimbus_dev);
+
+	if (retval)
+		bus_unregister(&slimbus_type);
+
+	return retval;
+}
+postcore_initcall(slimbus_init);
+module_exit(slimbus_exit);
+
+static int slim_drv_probe(struct device *dev)
+{
+	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
+
+	if (sdrv->probe)
+		return sdrv->probe(to_slim_device(dev));
+	return -ENODEV;
+}
+
+static int slim_drv_remove(struct device *dev)
+{
+	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
+
+	if (sdrv->remove)
+		return sdrv->remove(to_slim_device(dev));
+	return -ENODEV;
+}
+
+static void slim_drv_shutdown(struct device *dev)
+{
+	const struct slim_driver *sdrv = to_slim_driver(dev->driver);
+
+	if (sdrv->shutdown)
+		sdrv->shutdown(to_slim_device(dev));
+}
+
+/*
+ * slim_driver_register: Client driver registration with slimbus
+ * @drv:Client driver to be associated with client-device.
+ * This API will register the client driver with the slimbus
+ * It is called from the driver's module-init function.
+ */
+int slim_driver_register(struct slim_driver *drv)
+{
+	drv->driver.bus = &slimbus_type;
+	if (drv->probe)
+		drv->driver.probe = slim_drv_probe;
+
+	if (drv->remove)
+		drv->driver.remove = slim_drv_remove;
+
+	if (drv->shutdown)
+		drv->driver.shutdown = slim_drv_shutdown;
+
+	return driver_register(&drv->driver);
+}
+EXPORT_SYMBOL_GPL(slim_driver_register);
+
+#define slim_ctrl_attr_gr NULL
+
+static void slim_ctrl_release(struct device *dev)
+{
+	struct slim_controller *ctrl = to_slim_controller(dev);
+
+	complete(&ctrl->dev_released);
+}
+
+static struct device_type slim_ctrl_type = {
+	.groups		= slim_ctrl_attr_gr,
+	.release	= slim_ctrl_release,
+};
+
+static struct slim_controller *slim_ctrl_get(struct slim_controller *ctrl)
+{
+	if (!ctrl || !get_device(&ctrl->dev))
+		return NULL;
+
+	return ctrl;
+}
+
+static void slim_ctrl_put(struct slim_controller *ctrl)
+{
+	if (ctrl)
+		put_device(&ctrl->dev);
+}
+
+#define slim_device_attr_gr NULL
+#define slim_device_uevent NULL
+static void slim_dev_release(struct device *dev)
+{
+	struct slim_device *sbdev = to_slim_device(dev);
+	slim_ctrl_put(sbdev->ctrl);
+}
+
+static struct device_type slim_dev_type = {
+	.groups		= slim_device_attr_gr,
+	.uevent		= slim_device_uevent,
+	.release	= slim_dev_release,
+};
+
+/*
+ * slim_add_device: Add a new device without register board info.
+ * @ctrl: Controller to which this device is to be added to.
+ * Called when device doesn't have an explicit client-driver to be probed, or
+ * the client-driver is a module installed dynamically.
+ */
+int slim_add_device(struct slim_controller *ctrl, struct slim_device *sbdev)
+{
+	int ret = 0;
+
+	sbdev->dev.bus = &slimbus_type;
+	sbdev->dev.parent = ctrl->dev.parent;
+	sbdev->dev.type = &slim_dev_type;
+	sbdev->ctrl = ctrl;
+	slim_ctrl_get(ctrl);
+	dev_set_name(&sbdev->dev, "%s", sbdev->name);
+	/* probe slave on this controller */
+	ret = device_register(&sbdev->dev);
+
+	if (ret)
+		return ret;
+
+	mutex_init(&sbdev->sldev_reconf);
+	INIT_LIST_HEAD(&sbdev->mark_define);
+	INIT_LIST_HEAD(&sbdev->mark_suspend);
+	INIT_LIST_HEAD(&sbdev->mark_removal);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_add_device);
+
+struct sbi_boardinfo {
+	struct list_head	list;
+	struct slim_boardinfo	board_info;
+};
+
+static LIST_HEAD(board_list);
+static LIST_HEAD(slim_ctrl_list);
+static DEFINE_MUTEX(board_lock);
+
+/* If controller is not present, only add to boards list */
+static void slim_match_ctrl_to_boardinfo(struct slim_controller *ctrl,
+				struct slim_boardinfo *bi)
+{
+	int ret;
+	if (ctrl->nr != bi->bus_num)
+		return;
+
+	ret = slim_add_device(ctrl, bi->slim_slave);
+	if (ret != 0)
+		dev_err(ctrl->dev.parent, "can't create new device for %s\n",
+			bi->slim_slave->name);
+}
+
+/*
+ * slim_register_board_info: Board-initialization routine.
+ * @info: List of all devices on all controllers present on the board.
+ * @n: number of entries.
+ * API enumerates respective devices on corresponding controller.
+ * Called from board-init function.
+ */
+int slim_register_board_info(struct slim_boardinfo const *info, unsigned n)
+{
+	struct sbi_boardinfo *bi;
+	int i;
+
+	bi = kzalloc(n * sizeof(*bi), GFP_KERNEL);
+	if (!bi)
+		return -ENOMEM;
+
+	for (i = 0; i < n; i++, bi++, info++) {
+		struct slim_controller *ctrl;
+
+		memcpy(&bi->board_info, info, sizeof(*info));
+		mutex_lock(&board_lock);
+		list_add_tail(&bi->list, &board_list);
+		list_for_each_entry(ctrl, &slim_ctrl_list, list)
+			slim_match_ctrl_to_boardinfo(ctrl, &bi->board_info);
+		mutex_unlock(&board_lock);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_register_board_info);
+
+/*
+ * slim_busnum_to_ctrl: Map bus number to controller
+ * @busnum: Bus number
+ * Returns controller representing this bus number
+ */
+struct slim_controller *slim_busnum_to_ctrl(u32 bus_num)
+{
+	struct slim_controller *ctrl;
+	mutex_lock(&board_lock);
+	list_for_each_entry(ctrl, &slim_ctrl_list, list)
+		if (bus_num == ctrl->nr) {
+			mutex_unlock(&board_lock);
+			return ctrl;
+		}
+	mutex_unlock(&board_lock);
+	return NULL;
+}
+EXPORT_SYMBOL_GPL(slim_busnum_to_ctrl);
+
+static int slim_register_controller(struct slim_controller *ctrl)
+{
+	int ret = 0;
+	struct sbi_boardinfo *bi;
+
+	/* Can't register until after driver model init */
+	if (WARN_ON(!slimbus_type.p)) {
+		ret = -EAGAIN;
+		goto out_list;
+	}
+
+	dev_set_name(&ctrl->dev, "sb-%d", ctrl->nr);
+	ctrl->dev.bus = &slimbus_type;
+	ctrl->dev.type = &slim_ctrl_type;
+	ctrl->dev.parent = &slimbus_dev;
+	ctrl->num_dev = 0;
+	if (!ctrl->min_cg)
+		ctrl->min_cg = SLIM_MIN_CLK_GEAR;
+	if (!ctrl->max_cg)
+		ctrl->max_cg = SLIM_MAX_CLK_GEAR;
+	mutex_init(&ctrl->m_ctrl);
+	mutex_init(&ctrl->sched.m_reconf);
+	ret = device_register(&ctrl->dev);
+	if (ret)
+		goto out_list;
+
+	dev_dbg(&ctrl->dev, "Bus [%s] registered:dev:%x\n", ctrl->name,
+							(u32)&ctrl->dev);
+
+	if (ctrl->nports) {
+		ctrl->ports = kzalloc(ctrl->nports * sizeof(struct slim_port),
+					GFP_KERNEL);
+		if (!ctrl->ports) {
+			ret = -ENOMEM;
+			goto err_port_failed;
+		}
+	}
+	if (ctrl->nchans) {
+		ctrl->chans = kzalloc(ctrl->nchans * sizeof(struct slim_ich),
+					GFP_KERNEL);
+		if (!ctrl->chans) {
+			ret = -ENOMEM;
+			goto err_chan_failed;
+		}
+
+		ctrl->sched.chc1 =
+			kzalloc(ctrl->nchans * sizeof(struct slim_ich *),
+			GFP_KERNEL);
+		if (!ctrl->sched.chc1) {
+			kfree(ctrl->chans);
+			ret = -ENOMEM;
+			goto err_chan_failed;
+		}
+		ctrl->sched.chc3 =
+			kzalloc(ctrl->nchans * sizeof(struct slim_ich *),
+			GFP_KERNEL);
+		if (!ctrl->sched.chc3) {
+			kfree(ctrl->sched.chc1);
+			kfree(ctrl->chans);
+			ret = -ENOMEM;
+			goto err_chan_failed;
+		}
+	}
+#ifdef DEBUG
+	ctrl->sched.slots = kzalloc(SLIM_SL_PER_SUPERFRAME, GFP_KERNEL);
+#endif
+	/*
+	 * If devices on a controller were registered before controller,
+	 * this will make sure that they get probed now that controller is up
+	 */
+	mutex_lock(&board_lock);
+	list_add_tail(&ctrl->list, &slim_ctrl_list);
+	list_for_each_entry(bi, &board_list, list)
+		slim_match_ctrl_to_boardinfo(ctrl, &bi->board_info);
+	mutex_unlock(&board_lock);
+
+	return 0;
+
+err_chan_failed:
+	kfree(ctrl->ports);
+err_port_failed:
+	device_unregister(&ctrl->dev);
+out_list:
+	mutex_lock(&slim_lock);
+	idr_remove(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&slim_lock);
+	return ret;
+}
+
+/* slim_remove_device: Remove the effect of slim_add_device() */
+void slim_remove_device(struct slim_device *sbdev)
+{
+	device_unregister(&sbdev->dev);
+}
+EXPORT_SYMBOL_GPL(slim_remove_device);
+
+static void slim_ctrl_remove_device(struct slim_controller *ctrl,
+				struct slim_boardinfo *bi)
+{
+	if (ctrl->nr == bi->bus_num)
+		slim_remove_device(bi->slim_slave);
+}
+
+/*
+ * slim_del_controller: Controller tear-down.
+ * Controller added with the above API is teared down using this API.
+ */
+int slim_del_controller(struct slim_controller *ctrl)
+{
+	struct slim_controller *found;
+	struct sbi_boardinfo *bi;
+
+	/* First make sure that this bus was added */
+	mutex_lock(&slim_lock);
+	found = idr_find(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&slim_lock);
+	if (found != ctrl)
+		return -EINVAL;
+
+	/* Remove all clients */
+	mutex_lock(&board_lock);
+	list_for_each_entry(bi, &board_list, list)
+		slim_ctrl_remove_device(ctrl, &bi->board_info);
+	mutex_unlock(&board_lock);
+
+	init_completion(&ctrl->dev_released);
+	device_unregister(&ctrl->dev);
+
+	wait_for_completion(&ctrl->dev_released);
+	list_del(&ctrl->list);
+	/* free bus id */
+	mutex_lock(&slim_lock);
+	idr_remove(&ctrl_idr, ctrl->nr);
+	mutex_unlock(&slim_lock);
+
+	kfree(ctrl->sched.chc1);
+	kfree(ctrl->sched.chc3);
+#ifdef DEBUG
+	kfree(ctrl->sched.slots);
+#endif
+	kfree(ctrl->chans);
+	kfree(ctrl->ports);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_del_controller);
+
+/*
+ * slim_add_numbered_controller: Controller bring-up.
+ * @ctrl: Controller to be registered.
+ * A controller is registered with the framework using this API. ctrl->nr is the
+ * desired number with which slimbus framework registers the controller.
+ * Function will return -EBUSY if the number is in use.
+ */
+int slim_add_numbered_controller(struct slim_controller *ctrl)
+{
+	int	id;
+	int	status;
+
+	if (ctrl->nr & ~MAX_ID_MASK)
+		return -EINVAL;
+
+retry:
+	if (idr_pre_get(&ctrl_idr, GFP_KERNEL) == 0)
+		return -ENOMEM;
+
+	mutex_lock(&slim_lock);
+	status = idr_get_new_above(&ctrl_idr, ctrl, ctrl->nr, &id);
+	if (status == 0 && id != ctrl->nr) {
+		status = -EAGAIN;
+		idr_remove(&ctrl_idr, id);
+	}
+	mutex_unlock(&slim_lock);
+	if (status == -EAGAIN)
+		goto retry;
+
+	if (status == 0)
+		status = slim_register_controller(ctrl);
+	return status;
+}
+EXPORT_SYMBOL_GPL(slim_add_numbered_controller);
+
+/*
+ * slim_msg_response: Deliver Message response received from a device to the
+ *	framework.
+ * @ctrl: Controller handle
+ * @reply: Reply received from the device
+ * @len: Length of the reply
+ * @tid: Transaction ID received with which framework can associate reply.
+ * Called by controller to inform framework about the response received.
+ * This helps in making the API asynchronous, and controller-driver doesn't need
+ * to manage 1 more table other than the one managed by framework mapping TID
+ * with buffers
+ */
+void slim_msg_response(struct slim_controller *ctrl, u8 *reply, u8 tid, u8 len)
+{
+	int i;
+	struct slim_msg_txn *txn;
+
+	mutex_lock(&ctrl->m_ctrl);
+	txn = ctrl->txnt[tid];
+	if (txn == NULL) {
+		dev_err(&ctrl->dev, "Got response to invalid TID:%d, len:%d",
+				tid, len);
+		mutex_unlock(&ctrl->m_ctrl);
+		return;
+	}
+	for (i = 0; i < len; i++)
+		txn->rbuf[i] = reply[i];
+	if (txn->comp)
+		complete(txn->comp);
+	ctrl->txnt[tid] = NULL;
+	mutex_unlock(&ctrl->m_ctrl);
+	kfree(txn);
+}
+EXPORT_SYMBOL_GPL(slim_msg_response);
+
+static int slim_processtxn(struct slim_controller *ctrl, u8 dt, u8 mc, u16 ec,
+			u8 mt, u8 *rbuf, const u8 *wbuf, u8 len, u8 mlen,
+			struct completion *comp, u8 la, u8 *tid)
+{
+	u8 i = 0;
+	int ret = 0;
+	struct slim_msg_txn *txn = kmalloc(sizeof(struct slim_msg_txn),
+					GFP_KERNEL);
+	if (!txn)
+		return -ENOMEM;
+	if (tid) {
+		mutex_lock(&ctrl->m_ctrl);
+		for (i = 0; i < ctrl->last_tid; i++) {
+			if (ctrl->txnt[i] == NULL)
+				break;
+		}
+		if (i >= ctrl->last_tid) {
+			if (ctrl->last_tid == 255) {
+				mutex_unlock(&ctrl->m_ctrl);
+				kfree(txn);
+				return -ENOMEM;
+			}
+			ctrl->txnt = krealloc(ctrl->txnt,
+					(i + 1) * sizeof(struct slim_msg_txn *),
+					GFP_KERNEL);
+			if (!ctrl->txnt) {
+				mutex_unlock(&ctrl->m_ctrl);
+				kfree(txn);
+				return -ENOMEM;
+			}
+			ctrl->last_tid++;
+		}
+		ctrl->txnt[i] = txn;
+		mutex_unlock(&ctrl->m_ctrl);
+		txn->tid = i;
+		*tid = i;
+	}
+	txn->mc = mc;
+	txn->mt = mt;
+	txn->dt = dt;
+	txn->ec = ec;
+	txn->la = la;
+	txn->rbuf = rbuf;
+	txn->wbuf = wbuf;
+	txn->rl = mlen;
+	txn->len = len;
+	txn->comp = comp;
+
+	ret = ctrl->xfer_msg(ctrl, txn);
+	if (!tid)
+		kfree(txn);
+	return ret;
+}
+
+static int ctrl_getlogical_addr(struct slim_controller *ctrl, const u8 *eaddr,
+				u8 e_len, u8 *laddr)
+{
+	u8 i;
+	for (i = 0; i < ctrl->num_dev; i++) {
+		if (ctrl->addrt[i].valid &&
+			memcmp(ctrl->addrt[i].eaddr, eaddr, e_len) == 0) {
+			*laddr = i;
+			return 0;
+		}
+	}
+	return -ENXIO;
+}
+
+/*
+ * slim_assign_laddr: Assign logical address to a device enumerated.
+ * @ctrl: Controller with which device is enumerated.
+ * @e_addr: 6-byte elemental address of the device.
+ * @e_len: buffer length for e_addr
+ * @laddr: Return logical address.
+ * Called by controller in response to REPORT_PRESENT. Framework will assign
+ * a logical address to this enumeration address.
+ * Function returns -EXFULL to indicate that all logical addresses are already
+ * taken.
+ */
+int slim_assign_laddr(struct slim_controller *ctrl, const u8 *e_addr,
+				u8 e_len, u8 *laddr)
+{
+	int ret;
+	u8 i;
+	mutex_lock(&ctrl->m_ctrl);
+	/* already assigned */
+	if (ctrl_getlogical_addr(ctrl, e_addr, e_len, laddr) == 0)
+		i = *laddr;
+	else {
+		if (ctrl->num_dev >= 254) {
+			ret = -EXFULL;
+			goto ret_assigned_laddr;
+		}
+		for (i = 0; i < ctrl->num_dev; i++) {
+			if (ctrl->addrt[i].valid == false)
+				break;
+		}
+		if (i == ctrl->num_dev) {
+			ctrl->addrt = krealloc(ctrl->addrt,
+					(ctrl->num_dev + 1) *
+					sizeof(struct slim_addrt),
+					GFP_KERNEL);
+			if (!ctrl->addrt) {
+				ret = -ENOMEM;
+				goto ret_assigned_laddr;
+			}
+			ctrl->num_dev++;
+		}
+		memcpy(ctrl->addrt[i].eaddr, e_addr, e_len);
+		ctrl->addrt[i].valid = true;
+	}
+
+	ret = ctrl->set_laddr(ctrl, ctrl->addrt[i].eaddr, 6, i);
+	if (ret) {
+		ctrl->addrt[i].valid = false;
+		goto ret_assigned_laddr;
+	}
+	*laddr = i;
+
+	dev_dbg(&ctrl->dev, "setting slimbus l-addr:%x\n", i);
+ret_assigned_laddr:
+	mutex_unlock(&ctrl->m_ctrl);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_assign_laddr);
+
+/*
+ * slim_get_logical_addr: Return the logical address of a slimbus device.
+ * @sb: client handle requesting the adddress.
+ * @e_addr: Elemental address of the device.
+ * @e_len: Length of e_addr
+ * @laddr: output buffer to store the address
+ * context: can sleep
+ * -EINVAL is returned in case of invalid parameters, and -ENXIO is returned if
+ *  the device with this elemental address is not found.
+ */
+int slim_get_logical_addr(struct slim_device *sb, const u8 *e_addr,
+				u8 e_len, u8 *laddr)
+{
+	int ret = 0;
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl || !laddr || !e_addr || e_len != 6)
+		return -EINVAL;
+	mutex_lock(&ctrl->m_ctrl);
+	ret = ctrl_getlogical_addr(ctrl, e_addr, e_len, laddr);
+	mutex_unlock(&ctrl->m_ctrl);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_get_logical_addr);
+
+static int slim_ele_access_sanity(struct slim_ele_access *msg, int oper,
+				u8 *rbuf, const u8 *wbuf, u8 len)
+{
+	if (!msg || msg->num_bytes > 16 || msg->start_offset + len > 0xC00)
+		return -EINVAL;
+	switch (oper) {
+	case SLIM_MSG_MC_REQUEST_VALUE:
+	case SLIM_MSG_MC_REQUEST_INFORMATION:
+		if (rbuf == NULL)
+			return -EINVAL;
+		return 0;
+	case SLIM_MSG_MC_CHANGE_VALUE:
+	case SLIM_MSG_MC_CLEAR_INFORMATION:
+		if (wbuf == NULL)
+			return -EINVAL;
+		return 0;
+	case SLIM_MSG_MC_REQUEST_CHANGE_VALUE:
+	case SLIM_MSG_MC_REQUEST_CLEAR_INFORMATION:
+		if (rbuf == NULL || wbuf == NULL)
+			return -EINVAL;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static u16 slim_slicecodefromsize(u32 req)
+{
+	u8 codetosize[8] = {1, 2, 3, 4, 6, 8, 12, 16};
+	if (req >= 8)
+		return 0;
+	else
+		return codetosize[req];
+}
+
+static u16 slim_slicesize(u32 code)
+{
+	u8 sizetocode[16] = {0, 1, 2, 3, 3, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7};
+	if (code == 0)
+		code = 1;
+	if (code > 16)
+		code = 16;
+	return sizetocode[code - 1];
+}
+
+
+/* Message APIs Unicast message APIs used by slimbus slave drivers */
+
+/*
+ * Message API access routines.
+ * @sb: client handle requesting elemental message reads, writes.
+ * @msg: Input structure for start-offset, number of bytes to read.
+ * @rbuf: data buffer to be filled with values read.
+ * @len: data buffer size
+ * @wbuf: data buffer containing value/information to be written
+ * context: can sleep
+ * Returns:
+ * -EINVAL: Invalid parameters
+ * -ETIMEDOUT: If controller could not complete the request. This may happen if
+ *  the bus lines are not clocked, controller is not powered-on, slave with
+ *  given address is not enumerated/responding.
+ */
+int slim_request_val_element(struct slim_device *sb,
+				struct slim_ele_access *msg, u8 *buf, u8 len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl)
+		return -EINVAL;
+	return slim_xfer_msg(ctrl, sb, msg, SLIM_MSG_MC_REQUEST_VALUE, buf,
+			NULL, len);
+}
+EXPORT_SYMBOL_GPL(slim_request_val_element);
+
+int slim_request_inf_element(struct slim_device *sb,
+				struct slim_ele_access *msg, u8 *buf, u8 len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl)
+		return -EINVAL;
+	return slim_xfer_msg(ctrl, sb, msg, SLIM_MSG_MC_REQUEST_INFORMATION,
+			buf, NULL, len);
+}
+EXPORT_SYMBOL_GPL(slim_request_inf_element);
+
+int slim_change_val_element(struct slim_device *sb, struct slim_ele_access *msg,
+				const u8 *buf, u8 len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl)
+		return -EINVAL;
+	return slim_xfer_msg(ctrl, sb, msg, SLIM_MSG_MC_CHANGE_VALUE, NULL, buf,
+					len);
+}
+EXPORT_SYMBOL_GPL(slim_change_val_element);
+
+int slim_clear_inf_element(struct slim_device *sb, struct slim_ele_access *msg,
+				u8 *buf, u8 len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl)
+		return -EINVAL;
+	return slim_xfer_msg(ctrl, sb, msg, SLIM_MSG_MC_CLEAR_INFORMATION, NULL,
+					buf, len);
+}
+EXPORT_SYMBOL_GPL(slim_clear_inf_element);
+
+int slim_request_change_val_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *rbuf,
+					const u8 *wbuf, u8 len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl)
+		return -EINVAL;
+	return slim_xfer_msg(ctrl, sb, msg, SLIM_MSG_MC_REQUEST_CHANGE_VALUE,
+					rbuf, wbuf, len);
+}
+EXPORT_SYMBOL_GPL(slim_request_change_val_element);
+
+int slim_request_clear_inf_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *rbuf,
+					const u8 *wbuf, u8 len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	if (!ctrl)
+		return -EINVAL;
+	return slim_xfer_msg(ctrl, sb, msg,
+					SLIM_MSG_MC_REQUEST_CLEAR_INFORMATION,
+					rbuf, wbuf, len);
+}
+EXPORT_SYMBOL_GPL(slim_request_clear_inf_element);
+
+/*
+ * Broadcast message API:
+ * call this API directly with sbdev = NULL.
+ * For broadcast reads, make sure that buffers are big-enough to incorporate
+ * replies from all logical addresses.
+ * All controllers may not support broadcast
+ */
+int slim_xfer_msg(struct slim_controller *ctrl, struct slim_device *sbdev,
+			struct slim_ele_access *msg, u8 mc, u8 *rbuf,
+			const u8 *wbuf, u8 len)
+{
+	DECLARE_COMPLETION_ONSTACK(complete);
+	int ret;
+	u16 sl, cur;
+	u16 ec;
+	u8 tid, mlen = 6;
+
+	if (sbdev->laddr != SLIM_LA_MANAGER && sbdev->laddr >= ctrl->num_dev)
+		return -ENXIO;
+	ret = slim_ele_access_sanity(msg, mc, rbuf, wbuf, len);
+	if (ret)
+		goto xfer_err;
+
+	sl = slim_slicesize(len);
+	dev_dbg(&ctrl->dev, "SB xfer msg:os:%x, len:%d, MC:%x, sl:%x\n",
+				msg->start_offset, len, mc, sl);
+
+	cur = slim_slicecodefromsize(sl);
+	ec = ((sl | (1 << 3)) | ((msg->start_offset & 0xFFF) << 4));
+
+	if (wbuf)
+		mlen += len;
+	if (rbuf) {
+		mlen++;
+		if (!msg->comp)
+			ret = slim_processtxn(ctrl, SLIM_MSG_DEST_LOGICALADDR,
+				mc, ec, SLIM_MSG_MT_CORE, rbuf, wbuf, len, mlen,
+				&complete, sbdev->laddr, &tid);
+		else
+			ret = slim_processtxn(ctrl, SLIM_MSG_DEST_LOGICALADDR,
+				mc, ec, SLIM_MSG_MT_CORE, rbuf, wbuf, len, mlen,
+				msg->comp, sbdev->laddr, &tid);
+		/* sync read */
+		if (!ret && !msg->comp)
+			wait_for_completion_timeout(&complete, HZ);
+	} else
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_LOGICALADDR, mc, ec,
+				SLIM_MSG_MT_CORE, rbuf, wbuf, len, mlen,
+				NULL, sbdev->laddr, NULL);
+xfer_err:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_xfer_msg);
+
+/*
+ * slim_alloc_mgrports: Allocate port on manager side.
+ * @sb: device/client handle.
+ * @req: Port request type.
+ * @nports: Number of ports requested
+ * @rh: output buffer to store the port handles
+ * @hsz: size of buffer storing handles
+ * context: can sleep
+ * This port will be typically used by SW. e.g. client driver wants to receive
+ * some data from audio codec HW using a data channel.
+ * Port allocated using this API will be used to receive the data.
+ * If half-duplex ports are requested, two adjacent ports are allocated for
+ * 1 half-duplex port. So the handle-buffer size should be twice the number
+ * of half-duplex ports to be allocated.
+ * -EDQUOT is returned if all ports are in use.
+ */
+int slim_alloc_mgrports(struct slim_device *sb, enum slim_port_req req,
+				int nports, u32 *rh, int hsz)
+{
+	int i, j, ret;
+	int nphysp = nports;
+	struct slim_controller *ctrl = sb->ctrl;
+
+	if (!rh || !ctrl)
+		return -EINVAL;
+	if (req == SLIM_REQ_HALF_DUP)
+		nphysp *= 2;
+	if (hsz/sizeof(u32) < nphysp)
+		return -EINVAL;
+	mutex_lock(&ctrl->m_ctrl);
+
+	for (i = 0; i < ctrl->nports; i++) {
+		bool multiok = true;
+		if (ctrl->ports[i].state != SLIM_P_FREE)
+			continue;
+		/* Start half duplex channel at even port */
+		if (req == SLIM_REQ_HALF_DUP && (i % 2))
+			continue;
+		/* Allocate ports contiguously for multi-ch */
+		if (ctrl->nports < (i + nphysp)) {
+			i = ctrl->nports;
+			break;
+		}
+		if (req == SLIM_REQ_MULTI_CH) {
+			multiok = true;
+			for (j = i; j < i + nphysp; j++) {
+				if (ctrl->ports[j].state != SLIM_P_FREE) {
+					multiok = false;
+					break;
+				}
+			}
+			if (!multiok)
+				continue;
+		}
+		break;
+	}
+	if (i >= ctrl->nports)
+		ret = -EDQUOT;
+	for (j = i; j < i + nphysp; j++) {
+		ctrl->ports[j].state = SLIM_P_UNCFG;
+		ctrl->ports[j].req = req;
+		if (req == SLIM_REQ_HALF_DUP && (j % 2))
+			ctrl->ports[j].flow = SLIM_SINK;
+		else
+			ctrl->ports[j].flow = SLIM_SRC;
+		ret = ctrl->config_port(ctrl, j);
+		if (ret) {
+			for (; j >= i; j--)
+				ctrl->ports[j].state = SLIM_P_FREE;
+			goto alloc_err;
+		}
+		*rh++ = SLIM_PORT_HDL(SLIM_LA_MANAGER, 0, j);
+	}
+alloc_err:
+	mutex_unlock(&ctrl->m_ctrl);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_alloc_mgrports);
+
+/* Deallocate the port(s) allocated using the API above */
+int slim_dealloc_mgrports(struct slim_device *sb, u32 *hdl, int nports)
+{
+	int i;
+	struct slim_controller *ctrl = sb->ctrl;
+
+	if (!ctrl || !hdl)
+		return -EINVAL;
+
+	mutex_lock(&ctrl->m_ctrl);
+
+	for (i = 0; i < nports; i++) {
+		u8 pn;
+		pn = SLIM_HDL_TO_PORT(hdl[i]);
+		if (ctrl->ports[pn].state == SLIM_P_CFG) {
+			int j;
+			dev_err(&ctrl->dev, "Can't dealloc connected port:%d",
+					i);
+			for (j = i - 1; j >= 0; j--) {
+				pn = SLIM_HDL_TO_PORT(hdl[j]);
+				ctrl->ports[pn].state = SLIM_P_UNCFG;
+			}
+			mutex_unlock(&ctrl->m_ctrl);
+			return -EISCONN;
+		}
+		ctrl->ports[pn].state = SLIM_P_FREE;
+	}
+	mutex_unlock(&ctrl->m_ctrl);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_dealloc_mgrports);
+
+/*
+ * slim_get_slaveport: Get slave port handle
+ * @la: slave device logical address.
+ * @idx: port index at slave
+ * @rh: return handle
+ * @flw: Flow type (source or destination)
+ * This API only returns a slave port's representation as expected by slimbus
+ * driver. This port is not managed by the slimbus driver. Caller is expected
+ * to have visibility of this port since it's a device-port.
+ */
+int slim_get_slaveport(u8 la, int idx, u32 *rh, enum slim_port_flow flw)
+{
+	if (rh == NULL)
+		return -EINVAL;
+	*rh = SLIM_PORT_HDL(la, flw, idx);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_get_slaveport);
+
+static int connect_port_ch(struct slim_controller *ctrl, u8 ch, u32 ph,
+				enum slim_port_flow flow)
+{
+	int ret;
+	u8 mc;
+	u8 buf[2];
+	u32 la = SLIM_HDL_TO_LA(ph);
+	u8 pn = (u8)SLIM_HDL_TO_PORT(ph);
+
+	if (flow == SLIM_SRC)
+		mc = SLIM_MSG_MC_CONNECT_SOURCE;
+	else
+		mc = SLIM_MSG_MC_CONNECT_SINK;
+	buf[0] = pn;
+	buf[1] = ch;
+	if (la == SLIM_LA_MANAGER)
+		ctrl->ports[pn].flow = flow;
+	ret = slim_processtxn(ctrl, SLIM_MSG_DEST_LOGICALADDR, mc, 0,
+				SLIM_MSG_MT_CORE, NULL, buf, 2, 6, NULL, la,
+				NULL);
+	if (!ret && la == SLIM_LA_MANAGER)
+		ctrl->ports[pn].state = SLIM_P_CFG;
+	return ret;
+}
+
+static int disconnect_port_ch(struct slim_controller *ctrl, u32 ph)
+{
+	int ret;
+	u8 mc;
+	u32 la = SLIM_HDL_TO_LA(ph);
+	u8 pn = (u8)SLIM_HDL_TO_PORT(ph);
+
+	mc = SLIM_MSG_MC_DISCONNECT_PORT;
+	ret = slim_processtxn(ctrl, SLIM_MSG_DEST_LOGICALADDR, mc, 0,
+				SLIM_MSG_MT_CORE, NULL, &pn, 1, 5,
+				NULL, la, NULL);
+	if (ret)
+		return ret;
+	if (la == SLIM_LA_MANAGER)
+		ctrl->ports[pn].state = SLIM_P_UNCFG;
+	return 0;
+}
+
+/*
+ * slim_connect_ports: Connect port(s) to channel.
+ * @sb: client handle
+ * @srch: source handles to be connected to this channel
+ * @nrsc: number of source ports
+ * @sinkh: sink handle to be connected to this channel
+ * @chanh: Channel with which the ports need to be associated with.
+ * Per slimbus specification, a channel may have multiple source-ports and 1
+ * sink port.Channel specified in chanh needs to be allocated first.
+ */
+int slim_connect_ports(struct slim_device *sb, u32 *srch, int nsrc, u32 sinkh,
+			u16 chanh)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	int j;
+	int ret = 0;
+	u8 chan = (u8)(chanh & 0xFF);
+	struct slim_ich *slc = &ctrl->chans[chan];
+
+	mutex_lock(&ctrl->m_ctrl);
+	/* Make sure the channel is not already pending reconf. or active */
+	if (slc->state >= SLIM_CH_PENDING_ACTIVE) {
+		dev_err(&ctrl->dev, "Channel %d  already active", chan);
+		ret = -EISCONN;
+		goto connect_port_err;
+	}
+
+	/*
+	 * Once channel is removed, its ports can be considered disconnected
+	 * So its ports can be reassigned. Source port array is freed
+	 * when channel is deallocated.
+	 */
+	slc->srch = krealloc(slc->srch, (sizeof(u32) * nsrc), GFP_KERNEL);
+	if (!slc->srch) {
+		ret = -ENOMEM;
+		goto connect_port_err;
+	}
+	/* connect source */
+	for (j = 0; j < nsrc; j++) {
+		ret = connect_port_ch(ctrl, chan, srch[j], SLIM_SRC);
+		if (ret) {
+			for ( ; j >= 0 ; j--)
+				disconnect_port_ch(ctrl,
+						srch[j]);
+			kfree(slc->srch);
+			slc->srch = NULL;
+			goto connect_port_err;
+		}
+	}
+	/* connect sink */
+	ret = connect_port_ch(ctrl, chan, sinkh, SLIM_SINK);
+	if (ret) {
+		for (j = 0; j < nsrc; j++)
+			disconnect_port_ch(ctrl, srch[j]);
+		kfree(slc->srch);
+		slc->srch = NULL;
+		goto connect_port_err;
+	}
+
+	memcpy(slc->srch, srch, (sizeof(u32) * nsrc));
+	slc->nsrc = nsrc;
+	if (sinkh)
+		slc->sinkh = sinkh;
+
+connect_port_err:
+	mutex_unlock(&ctrl->m_ctrl);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_connect_ports);
+
+/*
+ * slim_disconnect_ports: Disconnect port(s) from channel
+ * @sb: client handle
+ * @ph: ports to be disconnected
+ * @nph: number of ports.
+ * Disconnects ports from a channel.
+ */
+int slim_disconnect_ports(struct slim_device *sb, u32 *ph, int nph)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	int i;
+	mutex_lock(&ctrl->m_ctrl);
+	for (i = 0; i < nph; i++)
+		disconnect_port_ch(ctrl, ph[i]);
+	mutex_unlock(&ctrl->m_ctrl);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_disconnect_ports);
+
+/*
+ * slim_port_xfer: Schedule buffer to be transferred/received using port-handle.
+ * @sb: client handle
+ * @ph: port-handle
+ * @iobuf: buffer to be transferred or populated
+ * @len: buffer size.
+ * @comp: completion signal to indicate transfer done or error.
+ * context: can sleep
+ * Returns number of bytes transferred/received if used synchronously.
+ * Will return 0 if used asynchronously.
+ * Client will call slim_port_get_xfer_status to get error and/or number of
+ * bytes transferred if used asynchronously.
+ */
+int slim_port_xfer(struct slim_device *sb, u32 ph, u8 *iobuf, u32 len,
+				struct completion *comp)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	u8 pn = SLIM_HDL_TO_PORT(ph);
+	dev_dbg(&ctrl->dev, "port xfer: num:%d", pn);
+	return ctrl->port_xfer(ctrl, pn, iobuf, len, comp);
+}
+EXPORT_SYMBOL_GPL(slim_port_xfer);
+
+/*
+ * slim_port_get_xfer_status: Poll for port transfers, or get transfer status
+ *	after completion is done.
+ * @sb: client handle
+ * @ph: port-handle
+ * @done_buf: return pointer (iobuf from slim_port_xfer) which is processed.
+ * @done_len: Number of bytes transferred.
+ * This can be called when port_xfer complition is signalled.
+ * The API will return port transfer error (underflow/overflow/disconnect)
+ * and/or done_len will reflect number of bytes transferred. Note that
+ * done_len may be valid even if port error (overflow/underflow) has happened.
+ * e.g. If the transfer was scheduled with a few bytes to be transferred and
+ * client has not supplied more data to be transferred, done_len will indicate
+ * number of bytes transferred with underflow error. To avoid frequent underflow
+ * errors, multiple transfers can be queued (e.g. ping-pong buffers) so that
+ * channel has data to be transferred even if client is not ready to transfer
+ * data all the time. done_buf will indicate address of the last buffer
+ * processed from the multiple transfers.
+ */
+enum slim_port_err slim_port_get_xfer_status(struct slim_device *sb, u32 ph,
+			u8 **done_buf, u32 *done_len)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	u8 pn = SLIM_HDL_TO_PORT(ph);
+	u32 la = SLIM_HDL_TO_LA(ph);
+	enum slim_port_err err;
+	dev_dbg(&ctrl->dev, "get status port num:%d", pn);
+	/*
+	 * Framework only has insight into ports managed by ported device
+	 * used by the manager and not slave
+	 */
+	if (la != SLIM_LA_MANAGER) {
+		if (done_buf)
+			*done_buf = NULL;
+		if (done_len)
+			*done_len = 0;
+		return SLIM_P_NOT_OWNED;
+	}
+	err = ctrl->port_xfer_status(ctrl, pn, done_buf, done_len);
+	if (err == SLIM_P_INPROGRESS)
+		err = ctrl->ports[pn].err;
+	return err;
+}
+EXPORT_SYMBOL_GPL(slim_port_get_xfer_status);
+
+static void slim_add_ch(struct slim_controller *ctrl, struct slim_ich *slc)
+{
+	struct slim_ich **arr;
+	int i, j;
+	int *len;
+	int sl = slc->seglen << slc->rootexp;
+	if (slc->coeff == SLIM_COEFF_1) {
+		arr = ctrl->sched.chc1;
+		len = &ctrl->sched.num_cc1;
+	} else {
+		arr = ctrl->sched.chc3;
+		len = &ctrl->sched.num_cc3;
+		sl *= 3;
+	}
+
+	*len += 1;
+
+	/* Insert the channel based on rootexp and seglen */
+	for (i = 0; i < *len - 1; i++) {
+		/*
+		 * Primary key: exp low to high.
+		 * Secondary key: seglen: high to low
+		 */
+		if ((slc->rootexp > arr[i]->rootexp) ||
+			((slc->rootexp == arr[i]->rootexp) &&
+			(slc->seglen < arr[i]->seglen)))
+			continue;
+		else
+			break;
+	}
+	for (j = *len - 1; j > i; j--)
+		arr[j] = arr[j - 1];
+	arr[i] = slc;
+	ctrl->sched.usedslots += sl;
+
+	return;
+}
+
+static int slim_remove_ch(struct slim_controller *ctrl, struct slim_ich *slc)
+{
+	struct slim_ich **arr;
+	int i;
+	u32 la, ph;
+	int *len;
+	if (slc->coeff == SLIM_COEFF_1) {
+		arr = ctrl->sched.chc1;
+		len = &ctrl->sched.num_cc1;
+	} else {
+		arr = ctrl->sched.chc3;
+		len = &ctrl->sched.num_cc3;
+	}
+
+	for (i = 0; i < *len; i++) {
+		if (arr[i] == slc)
+			break;
+	}
+	if (i >= *len)
+		return -EXFULL;
+	for (; i < *len - 1; i++)
+		arr[i] = arr[i + 1];
+	*len -= 1;
+	arr[*len] = NULL;
+
+	slc->state = SLIM_CH_ALLOCATED;
+	slc->newintr = 0;
+	slc->newoff = 0;
+	for (i = 0; i < slc->nsrc; i++) {
+		ph = slc->srch[i];
+		la = SLIM_HDL_TO_LA(ph);
+		/*
+		 * For ports managed by manager's ported device, no need to send
+		 * disconnect. It is client's responsibility to call disconnect
+		 * on ports owned by the slave device
+		 */
+		if (la == SLIM_LA_MANAGER)
+			ctrl->ports[SLIM_HDL_TO_PORT(ph)].state = SLIM_P_UNCFG;
+	}
+
+	ph = slc->sinkh;
+	la = SLIM_HDL_TO_LA(ph);
+	if (la == SLIM_LA_MANAGER)
+		ctrl->ports[SLIM_HDL_TO_PORT(ph)].state = SLIM_P_UNCFG;
+
+	return 0;
+}
+
+static u32 slim_calc_prrate(struct slim_controller *ctrl, struct slim_ch *prop)
+{
+	u32 rate = 0, rate4k = 0, rate11k = 0;
+	u32 exp = 0;
+	u32 pr = 0;
+	bool exact = true;
+	bool done = false;
+	enum slim_ch_rate ratefam;
+
+	if (prop->prot >= SLIM_PUSH)
+		return 0;
+	if (prop->baser == SLIM_RATE_1HZ) {
+		rate = prop->ratem / 4000;
+		rate4k = rate;
+		if (rate * 4000 == prop->ratem)
+			ratefam = SLIM_RATE_4000HZ;
+		else {
+			rate = prop->ratem / 11025;
+			rate11k = rate;
+			if (rate * 11025 == prop->ratem)
+				ratefam = SLIM_RATE_11025HZ;
+			else
+				ratefam = SLIM_RATE_1HZ;
+		}
+	} else {
+		ratefam = prop->baser;
+		rate = prop->ratem;
+	}
+	if (ratefam == SLIM_RATE_1HZ) {
+		exact = false;
+		if ((rate4k + 1) * 4000 < (rate11k + 1) * 11025) {
+			rate = rate4k + 1;
+			ratefam = SLIM_RATE_4000HZ;
+		} else {
+			rate = rate11k + 1;
+			ratefam = SLIM_RATE_11025HZ;
+		}
+	}
+	/* covert rate to coeff-exp */
+	while (!done) {
+		while ((rate & 0x1) != 0x1) {
+			rate >>= 1;
+			exp++;
+		}
+		if (rate > 3) {
+			/* roundup if not exact */
+			rate++;
+			exact = false;
+		} else
+			done = true;
+	}
+	if (ratefam == SLIM_RATE_4000HZ) {
+		if (rate == 1)
+			pr = 0x10;
+		else {
+			pr = 0;
+			exp++;
+		}
+	} else {
+		pr = 8;
+		exp++;
+	}
+	if (exp <= 7) {
+		pr |= exp;
+		if (exact)
+			pr |= 0x80;
+	} else
+		pr = 0;
+	return pr;
+}
+
+static int slim_nextdefine_ch(struct slim_device *sb, u8 chan)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	u32 chrate = 0;
+	u32 exp = 0;
+	u32 coeff = 0;
+	bool exact = true;
+	bool done = false;
+	int ret = 0;
+	struct slim_ich *slc = &ctrl->chans[chan];
+	struct slim_ch *prop = &slc->prop;
+
+	slc->prrate = slim_calc_prrate(ctrl, prop);
+	dev_dbg(&ctrl->dev, "ch:%d, chan PR rate:%x\n", chan, slc->prrate);
+	if (prop->baser == SLIM_RATE_4000HZ)
+		chrate = 4000 * prop->ratem;
+	else if (prop->baser == SLIM_RATE_11025HZ)
+		chrate = 11025 * prop->ratem;
+	else
+		chrate = prop->ratem;
+	/* max allowed sample freq = 768 seg/frame */
+	if (chrate > 3600000)
+		return -EDQUOT;
+	if (prop->baser == SLIM_RATE_4000HZ &&
+			ctrl->a_framer->superfreq == 4000)
+		coeff = prop->ratem;
+	else if (prop->baser == SLIM_RATE_11025HZ &&
+			ctrl->a_framer->superfreq == 3675)
+		coeff = 3 * prop->ratem;
+	else {
+		u32 tempr = 0;
+		tempr = chrate * SLIM_CL_PER_SUPERFRAME_DIV8;
+		coeff = tempr / ctrl->a_framer->rootfreq;
+		if (coeff * ctrl->a_framer->rootfreq != tempr) {
+			coeff++;
+			exact = false;
+		}
+	}
+
+	/* convert coeff to coeff-exponent */
+	exp = 0;
+	while (!done) {
+		while ((coeff & 0x1) != 0x1) {
+			coeff >>= 1;
+			exp++;
+		}
+		if (coeff > 3) {
+			coeff++;
+			exact = false;
+		} else
+			done = true;
+	}
+	if (prop->prot == SLIM_HARD_ISO && !exact)
+		return -EPROTONOSUPPORT;
+	else if (prop->prot == SLIM_AUTO_ISO) {
+		if (exact)
+			prop->prot = SLIM_HARD_ISO;
+		else {
+			/* Push-Pull not supported for now */
+			return -EPROTONOSUPPORT;
+		}
+	}
+	slc->rootexp = exp;
+	slc->seglen = prop->sampleszbits/SLIM_CL_PER_SL;
+	if (prop->prot != SLIM_HARD_ISO)
+		slc->seglen++;
+	if (prop->prot >= SLIM_EXT_SMPLX)
+		slc->seglen++;
+	/* convert coeff to enum */
+	if (coeff == 1) {
+		if (exp > 9)
+			ret = -EIO;
+		coeff = SLIM_COEFF_1;
+	} else {
+		if (exp > 8)
+			ret = -EIO;
+		coeff = SLIM_COEFF_3;
+	}
+	slc->coeff = coeff;
+
+	return ret;
+}
+
+/*
+ * slim_alloc_ch: Allocate a slimbus channel and return its handle.
+ * @sb: client handle.
+ * @chanh: return channel handle
+ * Slimbus channels are limited to 256 per specification. LSB of the handle
+ * indicates channel number and MSB of the handle is used by the slimbus
+ * framework. -EXFULL is returned if all channels are in use.
+ * Although slimbus specification supports 256 channels, a controller may not
+ * support that many channels.
+ */
+int slim_alloc_ch(struct slim_device *sb, u16 *chanh)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	u16 i;
+
+	if (!ctrl)
+		return -EINVAL;
+	mutex_lock(&ctrl->m_ctrl);
+	for (i = 0; i < ctrl->nchans; i++) {
+		if (ctrl->chans[i].state == SLIM_CH_FREE)
+			break;
+	}
+	if (i >= ctrl->nchans) {
+		mutex_unlock(&ctrl->m_ctrl);
+		return -EXFULL;
+	}
+	*chanh = i;
+	ctrl->chans[i].nextgrp = 0;
+	ctrl->chans[i].state = SLIM_CH_ALLOCATED;
+
+	mutex_unlock(&ctrl->m_ctrl);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_alloc_ch);
+
+/*
+ * slim_dealloc_ch: Deallocate channel allocated using the API above
+ * -EISCONN is returned if the channel is tried to be deallocated without
+ *  being removed first.
+ */
+int slim_dealloc_ch(struct slim_device *sb, u16 chanh)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	u8 chan = (u8)(chanh & 0xFF);
+	struct slim_ich *slc = &ctrl->chans[chan];
+	if (!ctrl)
+		return -EINVAL;
+
+	mutex_lock(&ctrl->m_ctrl);
+	if (slc->state >= SLIM_CH_PENDING_ACTIVE) {
+		dev_err(&ctrl->dev, "Channel:%d should be removed first", chan);
+		mutex_unlock(&ctrl->m_ctrl);
+		return -EISCONN;
+	}
+	kfree(slc->srch);
+	slc->srch = NULL;
+	slc->state = SLIM_CH_FREE;
+	mutex_unlock(&ctrl->m_ctrl);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(slim_dealloc_ch);
+
+/*
+ * slim_get_ch_state: Channel state.
+ * This API returns the channel's state (active, suspended, inactive etc)
+ */
+enum slim_ch_state slim_get_ch_state(struct slim_device *sb, u16 chanh)
+{
+	u8 chan = (u8)(chanh & 0xFF);
+	struct slim_ich *slc = &sb->ctrl->chans[chan];
+	return slc->state;
+}
+EXPORT_SYMBOL_GPL(slim_get_ch_state);
+
+/*
+ * slim_define_ch: Define a channel.This API defines channel parameters for a
+ *	given channel.
+ * @sb: client handle.
+ * @prop: slim_ch structure with channel parameters desired to be used.
+ * @chanh: list of channels to be defined.
+ * @nchan: number of channels in a group (1 if grp is false)
+ * @grp: Are the channels grouped
+ * @grph: return group handle if grouping of channels is desired.
+ * Channels can be grouped if multiple channels use same parameters
+ * (e.g. 5.1 audio has 6 channels with same parameters. They will all be grouped
+ * and given 1 handle for simplicity and avoid repeatedly calling the API)
+ * -EISCONN is returned if the channel is already connected. -EBUSY is
+ * returned if the channel is already allocated to some other client.
+ */
+int slim_define_ch(struct slim_device *sb, struct slim_ch *prop, u16 *chanh,
+			u8 nchan, bool grp, u16 *grph)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	int i, ret = 0;
+
+	if (!ctrl || !chanh || !prop || !nchan)
+		return -EINVAL;
+	mutex_lock(&ctrl->m_ctrl);
+	for (i = 0; i < nchan; i++) {
+		u8 chan = (u8)(chanh[i] & 0xFF);
+		dev_dbg(&ctrl->dev, "define_ch: port:%d, state:%d", chanh[i],
+				(int)ctrl->chans[chan].state);
+		if (ctrl->chans[chan].state < SLIM_CH_ALLOCATED ||
+			ctrl->chans[chan].state > SLIM_CH_DEFINED) {
+			int j;
+			for (j = i - 1; j >= 0; j--)
+				ctrl->chans[chan].state = SLIM_CH_ALLOCATED;
+			ret = -EBUSY;
+			goto err_define_ch;
+		}
+		ctrl->chans[chan].prop = *prop;
+		ret = slim_nextdefine_ch(sb, chan);
+		if (ret) {
+			int j;
+			for (j = i - 1; j >= 0; j--) {
+				chan = chanh[j] & 0xFF;
+				ctrl->chans[chan].nextgrp = 0;
+				ctrl->chans[chan].state = SLIM_CH_ALLOCATED;
+			}
+			goto err_define_ch;
+		}
+		if (i < (nchan - 1))
+			ctrl->chans[chan].nextgrp = chanh[i + 1];
+		if (i == 0)
+			ctrl->chans[chan].nextgrp |= SLIM_START_GRP;
+		if (i == (nchan - 1))
+			ctrl->chans[chan].nextgrp |= SLIM_END_GRP;
+
+		ctrl->chans[chan].state = SLIM_CH_DEFINED;
+	}
+
+	if (grp)
+		*grph = chanh[0];
+err_define_ch:
+	mutex_unlock(&ctrl->m_ctrl);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_define_ch);
+
+static u32 getsubfrmcoding(u32 *ctrlw, u32 *subfrml, u32 *msgsl)
+{
+	u32 code = 0;
+	if (*ctrlw == *subfrml) {
+		*ctrlw = 8;
+		*subfrml = 8;
+		*msgsl = SLIM_SL_PER_SUPERFRAME - SLIM_FRM_SLOTS_PER_SUPERFRAME
+				- SLIM_GDE_SLOTS_PER_SUPERFRAME;
+		return 0;
+	}
+	if (*subfrml == 6) {
+		code = 0;
+		*msgsl = 256;
+	} else if (*subfrml == 8) {
+		code = 1;
+		*msgsl = 192;
+	} else if (*subfrml == 24) {
+		code = 2;
+		*msgsl = 64;
+	} else { /* 32 */
+		code = 3;
+		*msgsl = 48;
+	}
+
+	if (*ctrlw < 8) {
+		if (*ctrlw >= 6) {
+			*ctrlw = 6;
+			code |= 0x14;
+		} else {
+			if (*ctrlw == 5)
+				*ctrlw = 4;
+			code |= (*ctrlw << 2);
+		}
+	} else {
+		code -= 2;
+		if (*ctrlw >= 24) {
+			*ctrlw = 24;
+			code |= 0x1e;
+		} else if (*ctrlw >= 16) {
+			*ctrlw = 16;
+			code |= 0x1c;
+		} else if (*ctrlw >= 12) {
+			*ctrlw = 12;
+			code |= 0x1a;
+		} else {
+			*ctrlw = 8;
+			code |= 0x18;
+		}
+	}
+
+	*msgsl = (*msgsl * *ctrlw) - SLIM_FRM_SLOTS_PER_SUPERFRAME -
+				SLIM_GDE_SLOTS_PER_SUPERFRAME;
+	return code;
+}
+
+static void shiftsegoffsets(struct slim_controller *ctrl, struct slim_ich **ach,
+				int sz, u32 shft)
+{
+	int i;
+	u32 oldoff;
+	for (i = 0; i < sz; i++) {
+		struct slim_ich *slc;
+		if (ach[i] == NULL)
+			continue;
+		slc = ach[i];
+		if (slc->state == SLIM_CH_PENDING_REMOVAL)
+			continue;
+		oldoff = slc->newoff;
+		slc->newoff += shft;
+		/* seg. offset must be <= interval */
+		if (slc->newoff >= slc->newintr)
+			slc->newoff -= slc->newintr;
+	}
+}
+
+static int slim_sched_chans(struct slim_device *sb, u32 clkgear,
+			u32 *ctrlw, u32 *subfrml)
+{
+	int coeff1, coeff3;
+	enum slim_ch_coeff bias;
+	struct slim_controller *ctrl = sb->ctrl;
+	int last1 = ctrl->sched.num_cc1 - 1;
+	int last3 = ctrl->sched.num_cc3 - 1;
+
+	/*
+	 * Find first channels with coeff 1 & 3 as starting points for
+	 * scheduling
+	 */
+	for (coeff3 = 0; coeff3 < ctrl->sched.num_cc3; coeff3++) {
+		struct slim_ich *slc = ctrl->sched.chc3[coeff3];
+		if (slc->state == SLIM_CH_PENDING_REMOVAL)
+			continue;
+		else
+			break;
+	}
+	for (coeff1 = 0; coeff1 < ctrl->sched.num_cc1; coeff1++) {
+		struct slim_ich *slc = ctrl->sched.chc1[coeff1];
+		if (slc->state == SLIM_CH_PENDING_REMOVAL)
+			continue;
+		else
+			break;
+	}
+	if (coeff3 == ctrl->sched.num_cc3 && coeff1 == ctrl->sched.num_cc1) {
+		*ctrlw = 8;
+		*subfrml = 8;
+		return 0;
+	} else if (coeff3 == ctrl->sched.num_cc3)
+		bias = SLIM_COEFF_1;
+	else
+		bias = SLIM_COEFF_3;
+
+	/*
+	 * Find last chan in coeff1, 3 list, we will use to know when we
+	* have done scheduling all coeff1 channels
+	*/
+	while (last1 >= 0) {
+		if (ctrl->sched.chc1[last1] != NULL &&
+			(ctrl->sched.chc1[last1])->state !=
+			SLIM_CH_PENDING_REMOVAL)
+			break;
+		last1--;
+	}
+	while (last3 >= 0) {
+		if (ctrl->sched.chc3[last3] != NULL &&
+			(ctrl->sched.chc3[last3])->state !=
+			SLIM_CH_PENDING_REMOVAL)
+			break;
+		last3--;
+	}
+
+	if (bias == SLIM_COEFF_1) {
+		struct slim_ich *slc1 = ctrl->sched.chc1[coeff1];
+		u32 expshft = SLIM_MAX_CLK_GEAR - clkgear;
+		int curexp, finalexp;
+		u32 curintr, curmaxsl;
+		int opensl1[2];
+		int maxctrlw1;
+
+		finalexp = (ctrl->sched.chc1[last1])->rootexp;
+		curexp = (int)expshft - 1;
+
+		curintr = (SLIM_MAX_INTR_COEFF_1 * 2) >> (curexp + 1);
+		curmaxsl = curintr >> 1;
+		opensl1[0] = opensl1[1] = curmaxsl;
+
+		while ((coeff1 < ctrl->sched.num_cc1) || (curintr > 24)) {
+			curintr >>= 1;
+			curmaxsl >>= 1;
+
+			/* update 4K family open slot records */
+			if (opensl1[1] < opensl1[0])
+				opensl1[1] -= curmaxsl;
+			else
+				opensl1[1] = opensl1[0] - curmaxsl;
+			opensl1[0] = curmaxsl;
+			if (opensl1[1] < 0) {
+				opensl1[0] += opensl1[1];
+				opensl1[1] = 0;
+			}
+			if (opensl1[0] <= 0) {
+				dev_dbg(&ctrl->dev, "reconfig failed:%d\n",
+						__LINE__);
+				return -EXFULL;
+			}
+			curexp++;
+			/* schedule 4k family channels */
+
+			while ((coeff1 < ctrl->sched.num_cc1) && (curexp ==
+					(int)(slc1->rootexp + expshft))) {
+				if (slc1->state == SLIM_CH_PENDING_REMOVAL) {
+					coeff1++;
+					slc1 = ctrl->sched.chc1[coeff1];
+					continue;
+				}
+				if (opensl1[1] >= opensl1[0] ||
+					(finalexp == (int)slc1->rootexp &&
+					 curintr <= 24 &&
+					 opensl1[0] == curmaxsl)) {
+					opensl1[1] -= slc1->seglen;
+					slc1->newoff = curmaxsl + opensl1[1];
+					if (opensl1[1] < 0 &&
+						opensl1[0] == curmaxsl) {
+						opensl1[0] += opensl1[1];
+						opensl1[1] = 0;
+						if (opensl1[0] < 0) {
+							dev_dbg(&ctrl->dev,
+							"reconfig failed:%d\n",
+							__LINE__);
+							return -EXFULL;
+						}
+					}
+				} else {
+					if (slc1->seglen > opensl1[0]) {
+						dev_dbg(&ctrl->dev,
+						"reconfig failed:%d\n",
+						__LINE__);
+						return -EXFULL;
+					}
+					slc1->newoff = opensl1[0] -
+							slc1->seglen;
+					opensl1[0] = slc1->newoff;
+				}
+				slc1->newintr = curintr;
+				coeff1++;
+				slc1 = ctrl->sched.chc1[coeff1];
+			}
+		}
+		if (opensl1[1] > opensl1[0]) {
+			int temp = opensl1[0];
+			opensl1[0] = opensl1[1];
+			opensl1[1] = temp;
+			shiftsegoffsets(ctrl, ctrl->sched.chc1,
+					ctrl->sched.num_cc1, curmaxsl);
+		}
+		/* choose subframe mode to maximize bw */
+		maxctrlw1 = opensl1[0];
+		if (opensl1[0] == curmaxsl)
+			maxctrlw1 += opensl1[1];
+		if (curintr >= 24) {
+			*subfrml = 24;
+			*ctrlw = maxctrlw1;
+		} else if (curintr == 12) {
+			if (maxctrlw1 > opensl1[1] * 4) {
+				*subfrml = 24;
+				*ctrlw = maxctrlw1;
+			} else {
+				*subfrml = 6;
+				*ctrlw = opensl1[1];
+			}
+		} else {
+			*subfrml = 6;
+			*ctrlw = maxctrlw1;
+		}
+	} else {
+		struct slim_ich *slc1;
+		struct slim_ich *slc3 = ctrl->sched.chc3[coeff3];
+		u32 expshft = SLIM_MAX_CLK_GEAR - clkgear;
+		int curexp, finalexp, exp1;
+		u32 curintr, curmaxsl;
+		int opensl3[2];
+		int opensl1[6];
+		bool opensl1valid = false;
+		int maxctrlw1, maxctrlw3, i;
+		finalexp = (ctrl->sched.chc3[last3])->rootexp;
+		if (last1 >= 0) {
+			slc1 = ctrl->sched.chc1[coeff1];
+			exp1 = (ctrl->sched.chc1[last1])->rootexp;
+			if (exp1 > finalexp)
+				finalexp = exp1;
+		}
+		curexp = (int)expshft - 1;
+
+		curintr = (SLIM_MAX_INTR_COEFF_3 * 2) >> (curexp + 1);
+		curmaxsl = curintr >> 1;
+		opensl3[0] = opensl3[1] = curmaxsl;
+
+		while (coeff1 < ctrl->sched.num_cc1 ||
+			coeff3 < ctrl->sched.num_cc3 ||
+			curintr > 32) {
+			curintr >>= 1;
+			curmaxsl >>= 1;
+
+			/* update 12k family open slot records */
+			if (opensl3[1] < opensl3[0])
+				opensl3[1] -= curmaxsl;
+			else
+				opensl3[1] = opensl3[0] - curmaxsl;
+			opensl3[0] = curmaxsl;
+			if (opensl3[1] < 0) {
+				opensl3[0] += opensl3[1];
+				opensl3[1] = 0;
+			}
+			if (opensl3[0] <= 0) {
+				dev_dbg(&ctrl->dev, "reconfig failed:%d\n",
+						__LINE__);
+				return -EXFULL;
+			}
+			curexp++;
+
+			/* schedule 12k family channels */
+			while (coeff3 < ctrl->sched.num_cc3 &&
+				curexp == (int)slc3->rootexp + expshft) {
+				if (slc3->state == SLIM_CH_PENDING_REMOVAL) {
+					coeff3++;
+					slc3 = ctrl->sched.chc3[coeff3];
+					continue;
+				}
+				opensl1valid = false;
+				if (opensl3[1] >= opensl3[0] ||
+					(finalexp == (int)slc3->rootexp &&
+					 curintr <= 32 &&
+					 opensl3[0] == curmaxsl &&
+					 last1 < 0)) {
+					opensl3[1] -= slc3->seglen;
+					slc3->newoff = curmaxsl + opensl3[1];
+					if (opensl3[1] < 0 &&
+						opensl3[0] == curmaxsl) {
+						opensl3[0] += opensl3[1];
+						opensl3[1] = 0;
+					}
+					if (opensl3[0] < 0) {
+						dev_dbg(&ctrl->dev,
+						"reconfig failed:%d\n",
+						__LINE__);
+						return -EXFULL;
+					}
+				} else {
+					if (slc3->seglen > opensl3[0]) {
+						dev_dbg(&ctrl->dev,
+						"reconfig failed:%d\n",
+						__LINE__);
+						return -EXFULL;
+					}
+					slc3->newoff = opensl3[0] -
+							slc3->seglen;
+					opensl3[0] = slc3->newoff;
+				}
+				slc3->newintr = curintr;
+				coeff3++;
+				slc3 = ctrl->sched.chc3[coeff3];
+			}
+			/* update 4k openslot records */
+			if (opensl1valid == false) {
+				for (i = 0; i < 3; i++) {
+					opensl1[i * 2] = opensl3[0];
+					opensl1[(i * 2) + 1] = opensl3[1];
+				}
+			} else {
+				int opensl1p[6];
+				memcpy(opensl1p, opensl1, sizeof(opensl1));
+				for (i = 0; i < 3; i++) {
+					if (opensl1p[i] < opensl1p[i + 3])
+						opensl1[(i * 2) + 1] =
+							opensl1p[i];
+					else
+						opensl1[(i * 2) + 1] =
+							opensl1p[i + 3];
+				}
+				for (i = 0; i < 3; i++) {
+					opensl1[(i * 2) + 1] -= curmaxsl;
+					opensl1[i * 2] = curmaxsl;
+					if (opensl1[(i * 2) + 1] < 0) {
+						opensl1[i * 2] +=
+							opensl1[(i * 2) + 1];
+						opensl1[(i * 2) + 1] = 0;
+					}
+					if (opensl1[i * 2] < 0) {
+						dev_dbg(&ctrl->dev,
+						"reconfig failed:%d\n",
+						__LINE__);
+						return -EXFULL;
+					}
+				}
+			}
+			/* schedule 4k family channels */
+			while (coeff1 < ctrl->sched.num_cc1 &&
+				curexp == (int)slc1->rootexp + expshft) {
+				/* searchorder effective when opensl valid */
+				static const int srcho[] = { 5, 2, 4, 1, 3, 0 };
+				int maxopensl = 0;
+				int maxi = 0;
+				if (slc1->state == SLIM_CH_PENDING_REMOVAL) {
+					coeff1++;
+					slc1 = ctrl->sched.chc1[coeff1];
+					continue;
+				}
+				opensl1valid = true;
+				for (i = 0; i < 6; i++) {
+					if (opensl1[srcho[i]] > maxopensl) {
+						maxopensl = opensl1[srcho[i]];
+						maxi = srcho[i];
+					}
+				}
+				opensl1[maxi] -= slc1->seglen;
+				slc1->newoff = (curmaxsl * maxi) +
+						opensl1[maxi];
+				if (opensl1[maxi] < 0) {
+					if (((maxi & 1) == 1) &&
+					(opensl1[maxi - 1] == curmaxsl)) {
+						opensl1[maxi - 1] +=
+							opensl1[maxi];
+						if (opensl3[0] >
+							opensl1[maxi - 1])
+							opensl3[0] =
+							opensl1[maxi - 1];
+						opensl3[1] = 0;
+						opensl1[maxi] = 0;
+						if (opensl1[maxi - 1] < 0) {
+							dev_dbg(&ctrl->dev,
+							"reconfig failed:%d\n",
+							__LINE__);
+							return -EXFULL;
+						}
+					} else {
+						dev_dbg(&ctrl->dev,
+						"reconfig failed:%d\n",
+						__LINE__);
+						return -EXFULL;
+					}
+				} else {
+					if (opensl3[maxi & 1] > opensl1[maxi])
+						opensl3[maxi & 1] =
+							opensl1[maxi];
+				}
+				slc1->newintr = curintr * 3;
+				coeff1++;
+				slc1 = ctrl->sched.chc1[coeff1];
+			}
+		}
+		/* swap 1st and 2nd bucket if 2nd bucket has more open slots */
+		if (opensl3[1] > opensl3[0]) {
+			int temp = opensl3[0];
+			opensl3[0] = opensl3[1];
+			opensl3[1] = temp;
+			temp = opensl1[5];
+			opensl1[5] = opensl1[4];
+			opensl1[4] = opensl1[3];
+			opensl1[3] = opensl1[2];
+			opensl1[2] = opensl1[1];
+			opensl1[1] = opensl1[0];
+			opensl1[0] = temp;
+			shiftsegoffsets(ctrl, ctrl->sched.chc1,
+					ctrl->sched.num_cc1, curmaxsl);
+			shiftsegoffsets(ctrl, ctrl->sched.chc3,
+					ctrl->sched.num_cc3, curmaxsl);
+		}
+		/* subframe mode to maximize BW */
+		maxctrlw3 = opensl3[0];
+		maxctrlw1 = opensl1[0];
+		if (opensl3[0] == curmaxsl)
+			maxctrlw3 += opensl3[1];
+		for (i = 0; i < 5 && opensl1[i] == curmaxsl; i++)
+			maxctrlw1 += opensl1[i + 1];
+		if (curintr >= 32) {
+			*subfrml = 32;
+			*ctrlw = maxctrlw3;
+		} else if (curintr == 16) {
+			if (maxctrlw3 > (opensl3[1] * 4)) {
+				*subfrml = 32;
+				*ctrlw = maxctrlw3;
+			} else {
+				*subfrml = 8;
+				*ctrlw = opensl3[1];
+			}
+		} else {
+			if ((maxctrlw1 * 8) >= (maxctrlw3 * 24)) {
+				*subfrml = 24;
+				*ctrlw = maxctrlw1;
+			} else {
+				*subfrml = 8;
+				*ctrlw = maxctrlw3;
+			}
+		}
+	}
+	return 0;
+}
+
+#ifdef DEBUG
+static int slim_verifychansched(struct slim_controller *ctrl, u32 ctrlw,
+				u32 subfrml, u32 clkgear)
+{
+	int sl, i;
+	int cc1 = 0;
+	int cc3 = 0;
+	struct slim_ich *slc = NULL;
+	if (!ctrl->sched.slots)
+		return 0;
+	memset(ctrl->sched.slots, 0, SLIM_SL_PER_SUPERFRAME);
+	dev_dbg(&ctrl->dev, "Clock gear is:%d\n", clkgear);
+	for (sl = 0; sl < SLIM_SL_PER_SUPERFRAME; sl += subfrml) {
+		for (i = 0; i < ctrlw; i++)
+			ctrl->sched.slots[sl + i] = 33;
+	}
+	while (cc1 < ctrl->sched.num_cc1) {
+		slc = ctrl->sched.chc1[cc1];
+		if (slc == NULL) {
+			dev_err(&ctrl->dev, "SLC1 null in verify: chan%d\n",
+				cc1);
+			return -EIO;
+		}
+		dev_dbg(&ctrl->dev, "chan:%d, offset:%d, intr:%d, seglen:%d\n",
+				(slc - ctrl->chans), slc->newoff,
+				slc->newintr, slc->seglen);
+
+		if (slc->state != SLIM_CH_PENDING_REMOVAL) {
+			for (sl = slc->newoff;
+				sl < SLIM_SL_PER_SUPERFRAME;
+				sl += slc->newintr) {
+				for (i = 0; i < slc->seglen; i++) {
+					if (ctrl->sched.slots[sl + i])
+						return -EXFULL;
+					ctrl->sched.slots[sl + i] = cc1 + 1;
+				}
+			}
+		}
+		cc1++;
+	}
+	while (cc3 < ctrl->sched.num_cc3) {
+		slc = ctrl->sched.chc3[cc3];
+		if (slc == NULL) {
+			dev_err(&ctrl->dev, "SLC3 null in verify: chan%d\n",
+				cc3);
+			return -EIO;
+		}
+		dev_dbg(&ctrl->dev, "chan:%d, offset:%d, intr:%d, seglen:%d\n",
+				(slc - ctrl->chans), slc->newoff,
+				slc->newintr, slc->seglen);
+		if (slc->state != SLIM_CH_PENDING_REMOVAL) {
+			for (sl = slc->newoff;
+				sl < SLIM_SL_PER_SUPERFRAME;
+				sl += slc->newintr) {
+				for (i = 0; i < slc->seglen; i++) {
+					if (ctrl->sched.slots[sl + i])
+						return -EXFULL;
+					ctrl->sched.slots[sl + i] = cc3 + 1;
+				}
+			}
+		}
+		cc3++;
+	}
+
+	return 0;
+}
+#else
+static int slim_verifychansched(struct slim_controller *ctrl, u32 ctrlw,
+				u32 subfrml, u32 clkgear)
+{
+	return 0;
+}
+#endif
+
+static void slim_sort_chan_grp(struct slim_controller *ctrl,
+				struct slim_ich *slc)
+{
+	u8  last = (u8)-1;
+	u8 second = 0;
+
+	for (; last > 0; last--) {
+		struct slim_ich *slc1 = slc;
+		struct slim_ich *slc2;
+		u8 next = (u8)(slc1->nextgrp & 0xFF);
+		slc2 = &ctrl->chans[next];
+		for (second = 1; second <= last && slc2 &&
+			(slc2->state == SLIM_CH_ACTIVE ||
+			 slc2->state == SLIM_CH_PENDING_ACTIVE); second++) {
+			if (slc1->newoff > slc2->newoff) {
+				u32 temp = slc2->newoff;
+				slc2->newoff = slc1->newoff;
+				slc1->newoff = temp;
+			}
+			if (slc2->nextgrp & SLIM_END_GRP) {
+				last = second;
+				break;
+			}
+			slc1 = slc2;
+			next = (u8)(slc1->nextgrp & 0xFF);
+			slc2 = &ctrl->chans[next];
+		}
+		if (slc2 == NULL)
+			last = second - 1;
+	}
+}
+
+
+static int slim_allocbw(struct slim_device *sb, int *subfrmc, int *clkgear)
+{
+	u32 msgsl = 0;
+	u32 ctrlw = 0;
+	u32 subfrml = 0;
+	int ret = -EIO;
+	struct slim_controller *ctrl = sb->ctrl;
+	u32 usedsl = ctrl->sched.usedslots + ctrl->sched.pending_msgsl;
+	u32 availsl = SLIM_SL_PER_SUPERFRAME - SLIM_FRM_SLOTS_PER_SUPERFRAME -
+			SLIM_GDE_SLOTS_PER_SUPERFRAME;
+	*clkgear = SLIM_MAX_CLK_GEAR;
+
+	dev_dbg(&ctrl->dev, "used sl:%u, availlable sl:%u\n", usedsl, availsl);
+	dev_dbg(&ctrl->dev, "pending:chan sl:%u, :msg sl:%u, clkgear:%u\n",
+				ctrl->sched.usedslots,
+				ctrl->sched.pending_msgsl, *clkgear);
+	while ((usedsl * 2 <= availsl) && (*clkgear > ctrl->min_cg)) {
+		*clkgear -= 1;
+		usedsl *= 2;
+	}
+
+	/*
+	 * Try scheduling data channels at current clock gear, if all channels
+	 * can be scheduled, or reserved BW can't be satisfied, increase clock
+	 * gear and try again
+	 */
+	for (; *clkgear <= ctrl->max_cg; (*clkgear)++) {
+		ret = slim_sched_chans(sb, *clkgear, &ctrlw, &subfrml);
+
+		if (ret == 0) {
+			*subfrmc = getsubfrmcoding(&ctrlw, &subfrml, &msgsl);
+			if ((msgsl >> (ctrl->max_cg - *clkgear) <
+				ctrl->sched.pending_msgsl) &&
+				(*clkgear < ctrl->max_cg))
+				continue;
+			else
+				break;
+		}
+	}
+	if (ret == 0) {
+		int i;
+		/* Sort channel-groups */
+		for (i = 0; i < ctrl->sched.num_cc1; i++) {
+			struct slim_ich *slc = ctrl->sched.chc1[i];
+			if (slc->state == SLIM_CH_PENDING_REMOVAL)
+				continue;
+			if ((slc->nextgrp & SLIM_START_GRP) &&
+				!(slc->nextgrp & SLIM_END_GRP)) {
+				slim_sort_chan_grp(ctrl, slc);
+			}
+		}
+		for (i = 0; i < ctrl->sched.num_cc3; i++) {
+			struct slim_ich *slc = ctrl->sched.chc3[i];
+			if (slc->state == SLIM_CH_PENDING_REMOVAL)
+				continue;
+			if ((slc->nextgrp & SLIM_START_GRP) &&
+				!(slc->nextgrp & SLIM_END_GRP)) {
+				slim_sort_chan_grp(ctrl, slc);
+			}
+		}
+
+		ret = slim_verifychansched(ctrl, ctrlw, subfrml, *clkgear);
+	}
+
+	return ret;
+}
+
+static void slim_chan_changes(struct slim_device *sb, bool revert)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	while (!list_empty(&sb->mark_define)) {
+		struct slim_ich *slc;
+		struct slim_pending_ch *pch =
+				list_entry(sb->mark_define.next,
+					struct slim_pending_ch, pending);
+		slc = &ctrl->chans[pch->chan];
+		if (revert) {
+			u32 sl = slc->seglen << slc->rootexp;
+			if (slc->coeff == SLIM_COEFF_3)
+				sl *= 3;
+			ctrl->sched.usedslots -= sl;
+			slim_remove_ch(ctrl, slc);
+			slc->state = SLIM_CH_DEFINED;
+		} else {
+			slc->offset = slc->newoff;
+			slc->interval = slc->newintr;
+			slc->state = SLIM_CH_ACTIVE;
+		}
+		list_del_init(&pch->pending);
+		kfree(pch);
+	}
+
+	while (!list_empty(&sb->mark_removal)) {
+		struct slim_pending_ch *pch =
+				list_entry(sb->mark_removal.next,
+					struct slim_pending_ch, pending);
+		struct slim_ich *slc = &ctrl->chans[pch->chan];
+		u32 sl = slc->seglen << slc->rootexp;
+		if (revert) {
+			if (slc->coeff == SLIM_COEFF_3)
+				sl *= 3;
+			ctrl->sched.usedslots += sl;
+			slc->state = SLIM_CH_ACTIVE;
+		} else
+			slim_remove_ch(ctrl, slc);
+		list_del_init(&pch->pending);
+		kfree(pch);
+	}
+
+	while (!list_empty(&sb->mark_suspend)) {
+		struct slim_pending_ch *pch =
+				list_entry(sb->mark_suspend.next,
+					struct slim_pending_ch, pending);
+		struct slim_ich *slc = &ctrl->chans[pch->chan];
+		if (revert)
+			slc->state = SLIM_CH_ACTIVE;
+		list_del_init(&pch->pending);
+		kfree(pch);
+	}
+}
+
+/*
+ * slim_reconfigure_now: Request reconfiguration now.
+ * @sb: client handle
+ * This API does what commit flag in other scheduling APIs do.
+ * -EXFULL is returned if there is no space in TDM to reserve the
+ * bandwidth. -EBUSY is returned if reconfiguration request is already in
+ * progress.
+ */
+int slim_reconfigure_now(struct slim_device *sb)
+{
+	u8 i;
+	u8 wbuf[4];
+	u32 clkgear, subframe;
+	u32 curexp;
+	int ret;
+	struct slim_controller *ctrl = sb->ctrl;
+	u32 expshft;
+	u32 segdist;
+	struct slim_pending_ch *pch;
+
+	mutex_lock(&ctrl->sched.m_reconf);
+	mutex_lock(&ctrl->m_ctrl);
+	ctrl->sched.pending_msgsl += sb->pending_msgsl - sb->cur_msgsl;
+	list_for_each_entry(pch, &sb->mark_define, pending) {
+		struct slim_ich *slc = &ctrl->chans[pch->chan];
+		slim_add_ch(ctrl, slc);
+		slc->state = SLIM_CH_PENDING_ACTIVE;
+	}
+
+	list_for_each_entry(pch, &sb->mark_removal, pending) {
+		struct slim_ich *slc = &ctrl->chans[pch->chan];
+		u32 sl = slc->seglen << slc->rootexp;
+		if (slc->coeff == SLIM_COEFF_3)
+			sl *= 3;
+		ctrl->sched.usedslots -= sl;
+		slc->state = SLIM_CH_PENDING_REMOVAL;
+	}
+	list_for_each_entry(pch, &sb->mark_suspend, pending) {
+		struct slim_ich *slc = &ctrl->chans[pch->chan];
+		slc->state = SLIM_CH_SUSPENDED;
+	}
+	mutex_unlock(&ctrl->m_ctrl);
+
+	ret = slim_allocbw(sb, &subframe, &clkgear);
+
+	if (!ret) {
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+			SLIM_MSG_MC_BEGIN_RECONFIGURATION, 0, SLIM_MSG_MT_CORE,
+			NULL, NULL, 0, 3, NULL, 0, NULL);
+		dev_dbg(&ctrl->dev, "sending begin_reconfig:ret:%d\n", ret);
+	}
+
+	if (!ret && subframe != ctrl->sched.subfrmcode) {
+		wbuf[0] = (u8)(subframe & 0xFF);
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+			SLIM_MSG_MC_NEXT_SUBFRAME_MODE, 0, SLIM_MSG_MT_CORE,
+			NULL, (u8 *)&subframe, 1, 4, NULL, 0, NULL);
+		dev_dbg(&ctrl->dev, "sending subframe:%d,ret:%d\n",
+				(int)wbuf[0], ret);
+	}
+	if (!ret && clkgear != ctrl->clkgear) {
+		wbuf[0] = (u8)(clkgear & 0xFF);
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+			SLIM_MSG_MC_NEXT_CLOCK_GEAR, 0, SLIM_MSG_MT_CORE,
+			NULL, wbuf, 1, 4, NULL, 0, NULL);
+		dev_dbg(&ctrl->dev, "sending clkgear:%d,ret:%d\n",
+				(int)wbuf[0], ret);
+	}
+	if (ret)
+		goto revert_reconfig;
+
+	expshft = SLIM_MAX_CLK_GEAR - clkgear;
+	/* activate/remove channel */
+	list_for_each_entry(pch, &sb->mark_define, pending) {
+		struct slim_ich *slc = &ctrl->chans[pch->chan];
+		/* Define content */
+		wbuf[0] = pch->chan;
+		wbuf[1] = slc->prrate;
+		wbuf[2] = slc->prop.dataf | (slc->prop.auxf << 4);
+		wbuf[3] = slc->prop.sampleszbits / SLIM_CL_PER_SL;
+		dev_dbg(&ctrl->dev, "define content, activate:%x, %x, %x, %x\n",
+				wbuf[0], wbuf[1], wbuf[2], wbuf[3]);
+		/* Right now, channel link bit is not supported */
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+				SLIM_MSG_MC_NEXT_DEFINE_CONTENT, 0,
+				SLIM_MSG_MT_CORE, NULL, (u8 *)&wbuf, 4, 7,
+				NULL, 0, NULL);
+		if (ret)
+			goto revert_reconfig;
+
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+				SLIM_MSG_MC_NEXT_ACTIVATE_CHANNEL, 0,
+				SLIM_MSG_MT_CORE, NULL, (u8 *)&wbuf, 1, 4,
+				NULL, 0, NULL);
+		if (ret)
+			goto revert_reconfig;
+	}
+
+	list_for_each_entry(pch, &sb->mark_removal, pending) {
+		dev_dbg(&ctrl->dev, "remove chan:%x\n", pch->chan);
+		wbuf[0] = pch->chan;
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+				SLIM_MSG_MC_NEXT_REMOVE_CHANNEL, 0,
+				SLIM_MSG_MT_CORE, NULL, wbuf, 1, 4,
+				NULL, 0, NULL);
+		if (ret)
+			goto revert_reconfig;
+	}
+	list_for_each_entry(pch, &sb->mark_suspend, pending) {
+		dev_dbg(&ctrl->dev, "suspend chan:%x\n", pch->chan);
+		wbuf[0] = pch->chan;
+		ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+				SLIM_MSG_MC_NEXT_DEACTIVATE_CHANNEL, 0,
+				SLIM_MSG_MT_CORE, NULL, wbuf, 1, 4,
+				NULL, 0, NULL);
+		if (ret)
+			goto revert_reconfig;
+	}
+
+	/* Define CC1 channel */
+	for (i = 0; i < ctrl->sched.num_cc1; i++) {
+		struct slim_ich *slc = ctrl->sched.chc1[i];
+		if (slc->state == SLIM_CH_PENDING_REMOVAL)
+			continue;
+		curexp = slc->rootexp + expshft;
+		segdist = (slc->newoff << curexp) & 0x1FF;
+		expshft = SLIM_MAX_CLK_GEAR - clkgear;
+
+		if (slc->state < SLIM_CH_ACTIVE ||
+			slc->newintr != slc->interval ||
+			slc->newoff != slc->offset) {
+			segdist |= 0x200;
+			segdist >>= curexp;
+			segdist |= (slc->newoff << (curexp + 1)) & 0xC00;
+			wbuf[0] = (u8)(slc - ctrl->chans);
+			wbuf[1] = (u8)(segdist & 0xFF);
+			wbuf[2] = (u8)((segdist & 0xF00) >> 8) |
+					(slc->prop.prot << 4);
+			wbuf[3] = slc->seglen;
+			ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+					SLIM_MSG_MC_NEXT_DEFINE_CHANNEL, 0,
+					SLIM_MSG_MT_CORE, NULL, (u8 *)wbuf, 4,
+					7, NULL, 0, NULL);
+			if (ret)
+				goto revert_reconfig;
+		}
+	}
+
+	/* Define CC3 channels */
+	for (i = 0; i < ctrl->sched.num_cc3; i++) {
+		struct slim_ich *slc = ctrl->sched.chc3[i];
+		if (slc->state == SLIM_CH_PENDING_REMOVAL)
+			continue;
+		curexp = slc->rootexp + expshft;
+		segdist = (slc->newoff << curexp) & 0x1FF;
+		expshft = SLIM_MAX_CLK_GEAR - clkgear;
+
+		if (slc->state < SLIM_CH_ACTIVE ||
+			slc->newintr != slc->interval ||
+			slc->newoff != slc->offset) {
+			segdist |= 0x200;
+			segdist >>= curexp;
+			segdist |= 0xC00;
+			wbuf[0] = (u8)(slc - ctrl->chans);
+			wbuf[1] = (u8)(segdist & 0xFF);
+			wbuf[2] = (u8)((segdist & 0xF00) >> 8) |
+					(slc->prop.prot << 4);
+			wbuf[3] = (u8)(slc->seglen);
+			ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+					SLIM_MSG_MC_NEXT_DEFINE_CHANNEL, 0,
+					SLIM_MSG_MT_CORE, NULL, (u8 *)wbuf, 4,
+					7, NULL, 0, NULL);
+			if (ret)
+				goto revert_reconfig;
+		}
+	}
+	ret = slim_processtxn(ctrl, SLIM_MSG_DEST_BROADCAST,
+			SLIM_MSG_MC_RECONFIGURE_NOW, 0, SLIM_MSG_MT_CORE, NULL,
+			NULL, 0, 3, NULL, 0, NULL);
+	dev_dbg(&ctrl->dev, "reconfig now:ret:%d\n", ret);
+	if (!ret) {
+		mutex_lock(&ctrl->m_ctrl);
+		ctrl->sched.subfrmcode = subframe;
+		ctrl->clkgear = clkgear;
+		ctrl->sched.msgsl = ctrl->sched.pending_msgsl;
+		sb->cur_msgsl = sb->pending_msgsl;
+		slim_chan_changes(sb, false);
+		mutex_unlock(&ctrl->m_ctrl);
+		mutex_unlock(&ctrl->sched.m_reconf);
+		return 0;
+	}
+
+revert_reconfig:
+	mutex_lock(&ctrl->m_ctrl);
+	/* Revert channel changes */
+	slim_chan_changes(sb, true);
+	mutex_unlock(&ctrl->m_ctrl);
+	mutex_unlock(&ctrl->sched.m_reconf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_reconfigure_now);
+
+static int add_pending_ch(struct list_head *listh, u8 chan)
+{
+	struct slim_pending_ch *pch;
+	pch = kmalloc(sizeof(struct slim_pending_ch), GFP_KERNEL);
+	if (!pch)
+		return -ENOMEM;
+	pch->chan = chan;
+	list_add_tail(&pch->pending, listh);
+	return 0;
+}
+
+/*
+ * slim_control_ch: Channel control API.
+ * @sb: client handle
+ * @chanh: group or channel handle to be controlled
+ * @chctrl: Control command (activate/suspend/remove)
+ * @commit: flag to indicate whether the control should take effect right-away.
+ * This API activates, removes or suspends a channel (or group of channels)
+ * chanh indicates the channel or group handle (returned by the define_ch API).
+ * Reconfiguration may be time-consuming since it can change all other active
+ * channel allocations on the bus, change in clock gear used by the slimbus,
+ * and change in the control space width used for messaging.
+ * commit makes sure that multiple channels can be activated/deactivated before
+ * reconfiguration is started.
+ * -EXFULL is returned if there is no space in TDM to reserve the bandwidth.
+ * -EISCONN/-ENOTCONN is returned if the channel is already connected or not
+ * yet defined.
+ */
+int slim_control_ch(struct slim_device *sb, u16 chanh,
+			enum slim_ch_control chctrl, bool commit)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	struct slim_ich *slc;
+	int ret = 0;
+	/* Get rid of the group flag in MSB if any */
+	u8 chan = (u8)(chanh & 0xFF);
+	mutex_lock(&sb->sldev_reconf);
+	mutex_lock(&ctrl->m_ctrl);
+	do {
+		slc = &ctrl->chans[chan];
+		if (slc->state < SLIM_CH_DEFINED) {
+			ret = -ENOTCONN;
+			break;
+		}
+		if (chctrl == SLIM_CH_SUSPEND) {
+			ret = add_pending_ch(&sb->mark_suspend, chan);
+			if (ret)
+				break;
+		} else if (chctrl == SLIM_CH_ACTIVATE) {
+			if (slc->state >= SLIM_CH_ACTIVE) {
+				ret = -EISCONN;
+				break;
+			}
+			ret = add_pending_ch(&sb->mark_define, chan);
+			if (ret)
+				break;
+		} else {
+			if (slc->state < SLIM_CH_ACTIVE) {
+				ret = -ENOTCONN;
+				break;
+			}
+			ret = add_pending_ch(&sb->mark_removal, chan);
+			if (ret)
+				break;
+		}
+
+		if (!(slc->nextgrp & SLIM_END_GRP))
+			chan = (u8)(slc->nextgrp & 0xFF);
+	} while (!(slc->nextgrp & SLIM_END_GRP));
+	mutex_unlock(&ctrl->m_ctrl);
+	if (!ret && commit == true)
+		ret = slim_reconfigure_now(sb);
+	mutex_unlock(&sb->sldev_reconf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_control_ch);
+
+/*
+ * slim_reservemsg_bw: Request to reserve bandwidth for messages.
+ * @sb: client handle
+ * @bw_bps: message bandwidth in bits per second to be requested
+ * @commit: indicates whether the reconfiguration needs to be acted upon.
+ * This API call can be grouped with slim_control_ch API call with only one of
+ * the APIs specifying the commit flag to avoid reconfiguration being called too
+ * frequently. -EXFULL is returned if there is no space in TDM to reserve the
+ * bandwidth. -EBUSY is returned if reconfiguration is requested, but a request
+ * is already in progress.
+ */
+int slim_reservemsg_bw(struct slim_device *sb, u32 bw_bps, bool commit)
+{
+	struct slim_controller *ctrl = sb->ctrl;
+	int ret = 0;
+	int sl;
+	mutex_lock(&sb->sldev_reconf);
+	if ((bw_bps >> 3) >= ctrl->a_framer->rootfreq)
+		sl = SLIM_SL_PER_SUPERFRAME;
+	else {
+		sl = (bw_bps * (SLIM_CL_PER_SUPERFRAME_DIV8/SLIM_CL_PER_SL/2) +
+			(ctrl->a_framer->rootfreq/2 - 1)) /
+			(ctrl->a_framer->rootfreq/2);
+	}
+	dev_dbg(&ctrl->dev, "request:bw:%d, slots:%d, current:%d\n", bw_bps, sl,
+						sb->cur_msgsl);
+	sb->pending_msgsl = sl;
+	if (commit == true)
+		ret = slim_reconfigure_now(sb);
+	mutex_unlock(&sb->sldev_reconf);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(slim_reservemsg_bw);
+
+
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION("0.1");
+MODULE_DESCRIPTION("Slimbus module");
+MODULE_ALIAS("platform:slimbus");
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index ae28e93..18997d7 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -427,6 +427,15 @@ struct spi_device_id {
 			__attribute__((aligned(sizeof(kernel_ulong_t))));
 };
 
+#define SLIMBUS_NAME_SIZE	32
+#define SLIMBUS_MODULE_PREFIX "slim:"
+
+struct slim_device_id {
+	char name[SLIMBUS_NAME_SIZE];
+	kernel_ulong_t driver_data	/* Data private to the driver */
+			__attribute__((aligned(sizeof(kernel_ulong_t))));
+};
+
 /* dmi */
 enum dmi_field {
 	DMI_NONE,
diff --git a/include/linux/slimbus/slimbus.h b/include/linux/slimbus/slimbus.h
new file mode 100644
index 0000000..79dabce5
--- /dev/null
+++ b/include/linux/slimbus/slimbus.h
@@ -0,0 +1,939 @@
+/* Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef _LINUX_SLIMBUS_H
+#define _LINUX_SLIMBUS_H
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/mod_devicetable.h>
+
+/* Interfaces between SLIMbus manager drivers and SLIMbus infrastructure. */
+
+extern struct bus_type slimbus_type;
+
+/* Standard values per SLIMbus spec needed by controllers and devices */
+#define SLIM_CL_PER_SUPERFRAME		6144
+#define SLIM_CL_PER_SUPERFRAME_DIV8	(SLIM_CL_PER_SUPERFRAME >> 3)
+#define SLIM_MAX_CLK_GEAR		10
+#define SLIM_MIN_CLK_GEAR		1
+#define SLIM_CL_PER_SL			4
+#define SLIM_SL_PER_SUPERFRAME		(SLIM_CL_PER_SUPERFRAME >> 2)
+#define SLIM_FRM_SLOTS_PER_SUPERFRAME	16
+#define SLIM_GDE_SLOTS_PER_SUPERFRAME	2
+
+/*
+ * SLIMbus message types. Related to interpretation of message code.
+ * Values are defined in Table 32 (slimbus spec 1.01.01)
+ */
+#define SLIM_MSG_MT_CORE			0x0
+#define SLIM_MSG_MT_DEST_REFERRED_CLASS		0x1
+#define SLIM_MSG_MT_DEST_REFERRED_USER		0x2
+#define SLIM_MSG_MT_SRC_REFERRED_CLASS		0x5
+#define SLIM_MSG_MT_SRC_REFERRED_USER		0x6
+
+/*
+ * SLIMbus core type Message Codes.
+ * Values are defined in Table 65 (slimbus spec 1.01.01)
+ */
+/* Device management messages */
+#define SLIM_MSG_MC_REPORT_PRESENT               0x1
+#define SLIM_MSG_MC_ASSIGN_LOGICAL_ADDRESS       0x2
+#define SLIM_MSG_MC_RESET_DEVICE                 0x4
+#define SLIM_MSG_MC_CHANGE_LOGICAL_ADDRESS       0x8
+#define SLIM_MSG_MC_CHANGE_ARBITRATION_PRIORITY  0x9
+#define SLIM_MSG_MC_REQUEST_SELF_ANNOUNCEMENT    0xC
+#define SLIM_MSG_MC_REPORT_ABSENT                0xF
+
+/* Data channel management messages */
+#define SLIM_MSG_MC_CONNECT_SOURCE               0x10
+#define SLIM_MSG_MC_CONNECT_SINK                 0x11
+#define SLIM_MSG_MC_DISCONNECT_PORT              0x14
+#define SLIM_MSG_MC_CHANGE_CONTENT               0x18
+
+/* Information management messages */
+#define SLIM_MSG_MC_REQUEST_INFORMATION          0x20
+#define SLIM_MSG_MC_REQUEST_CLEAR_INFORMATION    0x21
+#define SLIM_MSG_MC_REPLY_INFORMATION            0x24
+#define SLIM_MSG_MC_CLEAR_INFORMATION            0x28
+#define SLIM_MSG_MC_REPORT_INFORMATION           0x29
+
+/* Reconfiguration messages */
+#define SLIM_MSG_MC_BEGIN_RECONFIGURATION        0x40
+#define SLIM_MSG_MC_NEXT_ACTIVE_FRAMER           0x44
+#define SLIM_MSG_MC_NEXT_SUBFRAME_MODE           0x45
+#define SLIM_MSG_MC_NEXT_CLOCK_GEAR              0x46
+#define SLIM_MSG_MC_NEXT_ROOT_FREQUENCY          0x47
+#define SLIM_MSG_MC_NEXT_PAUSE_CLOCK             0x4A
+#define SLIM_MSG_MC_NEXT_RESET_BUS               0x4B
+#define SLIM_MSG_MC_NEXT_SHUTDOWN_BUS            0x4C
+#define SLIM_MSG_MC_NEXT_DEFINE_CHANNEL          0x50
+#define SLIM_MSG_MC_NEXT_DEFINE_CONTENT          0x51
+#define SLIM_MSG_MC_NEXT_ACTIVATE_CHANNEL        0x54
+#define SLIM_MSG_MC_NEXT_DEACTIVATE_CHANNEL      0x55
+#define SLIM_MSG_MC_NEXT_REMOVE_CHANNEL          0x58
+#define SLIM_MSG_MC_RECONFIGURE_NOW              0x5F
+
+/* Value management messages */
+#define SLIM_MSG_MC_REQUEST_VALUE                0x60
+#define SLIM_MSG_MC_REQUEST_CHANGE_VALUE         0x61
+#define SLIM_MSG_MC_REPLY_VALUE                  0x64
+#define SLIM_MSG_MC_CHANGE_VALUE                 0x68
+
+struct slim_controller;
+struct slim_device;
+
+/* Destination type Values defined in Table 33 (slimbus spec 1.01.01) */
+#define SLIM_MSG_DEST_LOGICALADDR	0
+#define SLIM_MSG_DEST_ENUMADDR		1
+#define	SLIM_MSG_DEST_BROADCAST		3
+
+/*
+ * @start_offset: Specifies starting offset in information/value element map
+ * @num_bytes: Can be 1, 2, 3, 4, 6, 8, 12, 16 per spec. This ensures that the
+ *	message will fit in the 40-byte message limit and the slicesize can be
+ *	compatible with values in table 21 (slimbus spec 1.01.01)
+ * @comp: Completion to indicate end of message-transfer. Used if client wishes
+ *	to use the API asynchronously.
+ */
+struct slim_ele_access {
+	u16			start_offset;
+	u8			num_bytes;
+	struct completion	*comp;
+};
+
+/*
+ * struct slim_framer - Represents Slimbus framer.
+ * Every controller may have multiple framers.
+ * Manager is responsible for framer hand-over.
+ * @e_addr: 6 byte Elemental address of the framer.
+ * @rootfreq: Root Frequency at which the framer can run. This is maximum
+ *	frequency (clock gear 10 per slimbus spec) at which the bus can operate.
+ * @superfreq: Superframes per root frequency. Every frame is 6144 cells (bits)
+ *	per slimbus specification.
+ */
+struct slim_framer {
+	u8	e_addr[6];
+	int	rootfreq;
+	int	superfreq;
+};
+#define to_slim_framer(d) container_of(d, struct slim_framer, dev);
+
+/*
+ * struct slim_addrt: slimbus address used internally by the slimbus framework.
+ * @valid: If the device is still there or if the address can be reused.
+ * @eaddr: 6-bytes-long elemental address
+ */
+struct slim_addrt {
+	bool	valid;
+	u8	eaddr[6];
+};
+
+/*
+ * struct slim_msg_txn: Message to be sent by the controller.
+ * Linux framework uses this structure with drivers implementing controller.
+ * This structure has packet header, payload and buffer to be filled (if any)
+ * For the header information, refer to Table 34-36.
+ * @rl: Header field. remaining length.
+ * @mt: Header field. Message type.
+ * @mc: Header field. Message code for type mt.
+ * @dt: Header field. Destination type.
+ * @ec: Element size. Used for elemental access APIs.
+ * @len: Length of payload. (excludes ec)
+ * @tid: Transaction ID. Used for messages expecting response.
+ *	(e.g. relevant for mc = SLIM_MSG_MC_REQUEST_INFORMATION)
+ * @la: Logical address of the device this message is going to.
+ *	(Not used when destination type is broadcast.)
+ * @rbuf: Buffer to be populated by controller when response is received.
+ * @wbuf: Payload of the message. (e.g. channel number for DATA channel APIs)
+ * @comp: Completion structure. Used by controller to notify response.
+ *	(Field is relevant when tid is used)
+ */
+struct slim_msg_txn {
+	u8			rl;
+	u8			mt;
+	u8			mc;
+	u8			dt;
+	u16			ec;
+	u8			len;
+	u8			tid;
+	u8			la;
+	u8			*rbuf;
+	const u8		*wbuf;
+	struct completion	*comp;
+};
+
+/* Internal port state used by slimbus framework to manage data-ports */
+enum slim_port_state {
+	SLIM_P_FREE,
+	SLIM_P_UNCFG,
+	SLIM_P_CFG,
+};
+
+/*
+ * enum slim_port_req: Request port type by user through APIs to manage ports
+ * User can request default, half-duplex or port to be used in multi-channel
+ * configuration. Default indicates a simplex port.
+ */
+enum slim_port_req {
+	SLIM_REQ_DEFAULT,
+	SLIM_REQ_HALF_DUP,
+	SLIM_REQ_MULTI_CH,
+};
+
+/*
+ * enum slim_port_cfg: Port configuration parameters requested.
+ * User can request no configuration, packed data, or MSB aligned data port
+ */
+enum slim_port_cfg {
+	SLIM_CFG_NONE,
+	SLIM_CFG_PACKED,
+	SLIM_CFG_ALIGN_MSB,
+};
+
+/* enum slim_port_flow: Port flow type (inbound/outbound). */
+enum slim_port_flow {
+	SLIM_SRC,
+	SLIM_SINK,
+};
+
+/* enum slim_port_err: Port errors */
+enum slim_port_err {
+	SLIM_P_INPROGRESS,
+	SLIM_P_OVERFLOW,
+	SLIM_P_UNDERFLOW,
+	SLIM_P_DISCONNECT,
+	SLIM_P_NOT_OWNED,
+};
+
+/*
+ * struct slim_port: Internal structure used by framework to manage ports
+ * @err: Port error if any for this port. Refer to enum above.
+ * @state: Port state. Refer to enum above.
+ * @req: Port request for this port.
+ * @cfg: Port configuration for this port.
+ * @flow: Flow type of this port.
+ * @ch: Channel association of this port.
+ * @xcomp: Completion to indicate error, data transfer done event.
+ * @ctrl: Controller to which this port belongs to. This is useful to associate
+ *	port with the SW since port hardware interrupts may only contain port
+ *	information.
+ */
+struct slim_port {
+	enum slim_port_err	err;
+	enum slim_port_state	state;
+	enum slim_port_req	req;
+	enum slim_port_cfg	cfg;
+	enum slim_port_flow	flow;
+	struct slim_ch		*ch;
+	struct completion	*xcomp;
+	struct slim_controller	*ctrl;
+};
+
+/*
+ * enum slim_ch_state: Channel state of a channel.
+ * Channel transition happens from free-to-allocated-to-defined-to-pending-
+ * active-to-active.
+ * Once active, channel can be removed or suspended. Suspended channels are
+ * still scheduled, but data transfer doesn't happen.
+ * Removed channels are not deallocated until dealloc_ch API is used.
+ * Deallocation reset channel state back to free.
+ * Removed channels can be defined with different parameters.
+ */
+enum slim_ch_state {
+	SLIM_CH_FREE,
+	SLIM_CH_ALLOCATED,
+	SLIM_CH_DEFINED,
+	SLIM_CH_PENDING_ACTIVE,
+	SLIM_CH_ACTIVE,
+	SLIM_CH_SUSPENDED,
+	SLIM_CH_PENDING_REMOVAL,
+};
+
+/*
+ * enum slim_ch_proto: Channel protocol used by the channel.
+ * Hard Isochronous channel is not scheduled if current frequency doesn't allow
+ * the channel to be run without flow-control.
+ * Auto isochronous channel will be scheduled as hard-isochronous or push-pull
+ * depending on current bus frequency.
+ * Currently, Push-pull or async or extended channels are not supported.
+ * For more details, refer to slimbus spec
+ */
+enum slim_ch_proto {
+	SLIM_HARD_ISO,
+	SLIM_AUTO_ISO,
+	SLIM_PUSH,
+	SLIM_PULL,
+	SLIM_ASYNC_SMPLX,
+	SLIM_ASYNC_HALF_DUP,
+	SLIM_EXT_SMPLX,
+	SLIM_EXT_HALF_DUP,
+};
+
+/*
+ * enum slim_ch_rate: Most commonly used frequency rate families.
+ * Use 1HZ for push-pull transport.
+ * 4KHz and 11.025KHz are most commonly used in audio applications.
+ * Typically, slimbus runs at frequencies to support channels running at 4KHz
+ * and/or 11.025KHz isochronously.
+ */
+enum slim_ch_rate {
+	SLIM_RATE_1HZ,
+	SLIM_RATE_4000HZ,
+	SLIM_RATE_11025HZ,
+};
+
+/*
+ * enum slim_ch_coeff: Coefficient of a channel used internally by framework.
+ * Coefficient is applicable to channels running isochronously.
+ * Coefficient is calculated based on channel rate multiplier.
+ * (If rate multiplier is power of 2, it's coeff.1 channel. Otherwise it's
+ * coeff.3 channel.
+ */
+enum slim_ch_coeff {
+	SLIM_COEFF_1,
+	SLIM_COEFF_3,
+};
+
+/*
+ * enum slim_ch_control: Channel control.
+ * Activate will schedule channel and/or group of channels in the TDM frame.
+ * Suspend will keep the schedule but data-transfer won't happen.
+ * Remove will remove the channel/group from the TDM frame.
+ */
+enum slim_ch_control {
+	SLIM_CH_ACTIVATE,
+	SLIM_CH_SUSPEND,
+	SLIM_CH_REMOVE,
+};
+
+/* enum slim_ch_dataf: Data format per table 60 from slimbus spec 1.01.01 */
+enum slim_ch_dataf {
+	SLIM_CH_DATAF_NOT_DEFINED = 0,
+	SLIM_CH_DATAF_LPCM_AUDIO = 1,
+	SLIM_CH_DATAF_IEC61937_COMP_AUDIO = 2,
+	SLIM_CH_DATAF_PACKED_PDM_AUDIO = 3,
+};
+
+/* enum slim_ch_auxf: Auxiliary field format per table 59 from slimbus spec */
+enum slim_ch_auxf {
+	SLIM_CH_AUXF_NOT_APPLICABLE = 0,
+	SLIM_CH_AUXF_ZCUV_TUNNEL_IEC60958 = 1,
+	SLIM_CH_USER_DEFINED = 0xF,
+};
+
+/*
+ * struct slim_ch: Channel structure used externally by users of channel APIs.
+ * @prot: Desired slimbus protocol.
+ * @baser: Desired base rate. (Typical isochronous rates are: 4KHz, or 11.025KHz
+ * @dataf: Data format.
+ * @auxf: Auxiliary format.
+ * @ratem: Channel rate multiplier. (e.g. 48KHz channel will have 4KHz base rate
+ *	and 12 as rate multiplier.
+ * @sampleszbits: Sample size in bits.
+ */
+struct slim_ch {
+	enum slim_ch_proto	prot;
+	enum slim_ch_rate	baser;
+	enum slim_ch_dataf	dataf;
+	enum slim_ch_auxf	auxf;
+	u32			ratem;
+	u32			sampleszbits;
+};
+
+/*
+ * struct slim_ich: Internal channel structure used by slimbus framework.
+ * @prop: structure passed by the client.
+ * @coeff: Coefficient of this channel.
+ * @state: Current state of the channel.
+ * @nextgrp: If this channel is part of group, next channel in this group.
+ * @prrate: Presence rate of this channel (per table 62 of the spec)
+ * @offset: Offset of this channel in the superframe.
+ * @newoff: Used during scheduling to hold temporary new offset until the offset
+ *	is accepted/rejected by slimbus reconfiguration.
+ * @interval: Interval of this channel per superframe.
+ * @newintr: Used during scheduling to new interval temporarily.
+ * @seglen: Segment length of this channel.
+ * @rootexp: root exponent of this channel. Rate can be found using rootexp and
+ *	coefficient. Used during scheduling.
+ * @srch: Source ports used by this channel.
+ * @nsrc: number of source ports used by this channel.
+ * @sinkh: Sink port used by this channel.
+ */
+struct slim_ich {
+	struct slim_ch		prop;
+	enum slim_ch_coeff	coeff;
+	enum slim_ch_state	state;
+	u16			nextgrp;
+	u32			prrate;
+	u32			offset;
+	u32			newoff;
+	u32			interval;
+	u32			newintr;
+	u32			seglen;
+	u8			rootexp;
+	u32			*srch;
+	int			nsrc;
+	u32			sinkh;
+};
+
+/*
+ * struct slim_sched: Framework uses this structure internally for scheduling.
+ * @chc3: Array of all active coeffient 3 channels.
+ * @num_cc3: Number of active coeffient 3 channels.
+ * @chc1: Array of all active coeffient 1 channels.
+ * @num_cc1: Number of active coeffient 1 channels.
+ * @subfrmcode: Current subframe-code used by TDM. This is decided based on
+ *	requested message bandwidth and current channels scheduled.
+ * @usedslots: Slots used by all active channels.
+ * @msgsl: Slots used by message-bandwidth.
+ * @pending_msgsl: Used to store pending request of message bandwidth (in slots)
+ *	until the scheduling is accepted by reconfiguration.
+ * @m_reconf: This mutex is held until current reconfiguration (data channel
+ *	scheduling, message bandwidth reservation) is done. Message APIs can
+ *	use the bus concurrently when this mutex is held since elemental access
+ *	messages can be sent on the bus when reconfiguration is in progress.
+ * @slots: Used for debugging purposes to debug/verify current schedule in TDM.
+ */
+struct slim_sched {
+	struct slim_ich	**chc3;
+	int		num_cc3;
+	struct slim_ich	**chc1;
+	int		num_cc1;
+	u32		subfrmcode;
+	u32		usedslots;
+	u32		msgsl;
+	u32		pending_msgsl;
+	struct mutex	m_reconf;
+	u8		*slots;
+};
+
+/*
+ * struct slim_controller: Represents manager for a SlimBUS
+ *				(similar to 'master' on I2C)
+ * @dev: Device interface to this driver
+ * @nr: Board-specific number identifier for this controller/bus
+ * @list: Link with other slimbus controllers
+ * @name: Name for this controller
+ * @clkgear: Current clock gear in which this bus is running
+ * @min_cg: Minimum clock gear supported by this controller (default value: 1)
+ * @max_cg: Maximum clock gear supported by this controller (default value: 10)
+ * @a_framer: Active framer which is clocking the bus managed by this controller
+ * @m_ctrl: Mutex protecting controller data structures (ports, channels etc)
+ * @addrt: Logical address table
+ * @num_dev: Number of active slimbus slaves on this bus
+ * @txnt: Table of transactions having transaction ID
+ * @last_tid: size of the table txnt (can't grow beyond 256 since TID is 8-bits)
+ * @ports: Ports associated with this controller
+ * @nports: Number of ports supported by the controller
+ * @chans: Channels associated with this controller
+ * @nchans: Number of channels supported
+ * @sched: scheduler structure used by the controller
+ * @dev_released: completion used to signal when sysfs has released this
+ *	controller so that it can be deleted during shutdown
+ * @xfer_msg: Transfer a message on this controller (this can be a broadcast
+ *	control/status message like data channel setup, or a unicast message
+ *	like value element read/write.
+ * @set_laddr: Setup logical address at laddr for the slave with elemental
+ *	address e_addr. Drivers implementing controller will be expected to
+ *	send unicast message to this device with its logical address.
+ * @config_port: Configure a port and make it ready for data transfer. This is
+ *	called by framework after connect_port message is sent successfully.
+ * @framer_handover: If this controller has multiple framers, this API will
+ *	be called to switch between framers if controller desires to change
+ *	the active framer.
+ * @port_xfer: Called to schedule a transfer on port pn. iobuf is physical
+ *	address and the buffer may have to be DMA friendly since data channels
+ *	will be using data from this buffers without SW intervention.
+ * @port_xfer_status: Called by framework when client calls get_xfer_status
+ *	API. Returns how much buffer is actually processed and the port
+ *	errors (e.g. overflow/underflow) if any.
+ */
+struct slim_controller {
+	struct device		dev;
+	unsigned int		nr;
+	struct list_head	list;
+	char			name[SLIMBUS_NAME_SIZE];
+	int			clkgear;
+	int			min_cg;
+	int			max_cg;
+	struct slim_framer	*a_framer;
+	struct mutex		m_ctrl;
+	struct slim_addrt	*addrt;
+	u8			num_dev;
+	struct slim_msg_txn	**txnt;
+	u8			last_tid;
+	struct slim_port	*ports;
+	int			nports;
+	struct slim_ich		*chans;
+	int			nchans;
+	struct slim_sched	sched;
+	struct completion	dev_released;
+	int			(*xfer_msg)(struct slim_controller *ctrl,
+				struct slim_msg_txn *txn);
+	int			(*set_laddr)(struct slim_controller *ctrl,
+				const u8 *ea, u8 elen, u8 laddr);
+	int			(*config_port)(struct slim_controller *ctrl,
+				u8 port);
+	int			(*framer_handover)(struct slim_controller *ctrl,
+				struct slim_framer *new_framer);
+	int			(*port_xfer)(struct slim_controller *ctrl,
+				u8 pn, u8 *iobuf, u32 len,
+				struct completion *comp);
+	enum slim_port_err	(*port_xfer_status)(struct slim_controller *ctr,
+				u8 pn, u8 **done_buf, u32 *done_len);
+};
+#define to_slim_controller(d) container_of(d, struct slim_controller, dev)
+
+/*
+ * struct slim_driver: Manage Slimbus generic/slave device driver
+ * @probe: Binds this driver to a slimbus device.
+ * @remove: Unbinds this driver from the slimbus device.
+ * @shutdown: Standard shutdown callback used during powerdown/halt.
+ * @suspend: Standard suspend callback used during system suspend
+ * @resume: Standard resume callback used during system resume
+ * @driver: Slimbus device drivers should initialize name and owner field of
+ *	this structure
+ * @id_table: List of slimbus devices supported by this driver
+ */
+struct slim_driver {
+	int				(*probe)(struct slim_device *sldev);
+	int				(*remove)(struct slim_device *sldev);
+	void				(*shutdown)(struct slim_device *sldev);
+	int				(*suspend)(struct slim_device *sldev,
+					pm_message_t pmesg);
+	int				(*resume)(struct slim_device *sldev);
+
+	struct device_driver		driver;
+	const struct slim_device_id	*id_table;
+};
+#define to_slim_driver(d) container_of(d, struct slim_driver, driver)
+
+/*
+ * struct slim_pending_ch: List of pending channels used by framework.
+ * @chan: Channel number
+ * @pending: list of channels
+ */
+struct slim_pending_ch {
+	u8	chan;
+	struct	list_head pending;
+};
+
+/*
+ * Client/device handle (struct slim_device):
+ * ------------------------------------------
+ *  This is the client/device handle returned when a slimbus
+ *  device is registered with a controller. This structure can be provided
+ *  during register_board_info, or can be allocated using slim_add_device API.
+ *  Pointer to this structure is used by client-driver as a handle.
+ *  @dev: Driver model representation of the device.
+ *  @name: Name of driver to use with this device.
+ *  @e_addr: 6-byte elemental address of this device.
+ *  @driver: Device's driver. Pointer to access routines.
+ *  @ctrl: Slimbus controller managing the bus hosting this device.
+ *  @laddr: 1-byte Logical address of this device.
+ *  @mark_define: List of channels pending definition/activation.
+ *  @mark_suspend: List of channels pending suspend.
+ *  @mark_removal: List of channels pending removal.
+ *  @sldev_reconf: Mutex to protect the pending data-channel lists.
+ *  @pending_msgsl: Message bandwidth reservation request by this client in
+ *	slots that's pending reconfiguration.
+ *  @cur_msgsl: Message bandwidth reserved by this client in slots.
+ *  These 3 lists are managed by framework. Lists are populated when client
+ *  calls channel control API without reconfig-flag set and the lists are
+ *  emptied when the reconfiguration is done by this client.
+ */
+struct slim_device {
+	struct device		dev;
+	const char		*name;
+	u8			e_addr[6];
+	struct slim_driver	*driver;
+	struct slim_controller	*ctrl;
+	u8			laddr;
+	struct list_head	mark_define;
+	struct list_head	mark_suspend;
+	struct list_head	mark_removal;
+	struct mutex		sldev_reconf;
+	u32			pending_msgsl;
+	u32			cur_msgsl;
+};
+#define to_slim_device(d) container_of(d, struct slim_device, dev)
+
+/*
+ * struct slim_boardinfo: Declare board info for Slimbus device bringup.
+ * @bus_num: Controller number (bus) on which this device will sit.
+ * @slim_slave: Device to be registered with slimbus.
+ */
+struct slim_boardinfo {
+	int			bus_num;
+	struct slim_device	*slim_slave;
+};
+
+/*
+ * slim_get_logical_addr: Return the logical address of a slimbus device.
+ * @sb: client handle requesting the adddress.
+ * @e_addr: Elemental address of the device.
+ * @e_len: Length of e_addr
+ * @laddr: output buffer to store the address
+ * context: can sleep
+ * -EINVAL is returned in case of invalid parameters, and -ENXIO is returned if
+ *  the device with this elemental address is not found.
+ */
+
+extern int slim_get_logical_addr(struct slim_device *sb, const u8 *e_addr,
+					u8 e_len, u8 *laddr);
+
+
+/* Message APIs Unicast message APIs used by slimbus slave drivers */
+
+/*
+ * Message API access routines.
+ * @sb: client handle requesting elemental message reads, writes.
+ * @msg: Input structure for start-offset, number of bytes to read.
+ * @rbuf: data buffer to be filled with values read.
+ * @len: data buffer size
+ * @wbuf: data buffer containing value/information to be written
+ * context: can sleep
+ * Returns:
+ * -EINVAL: Invalid parameters
+ * -ETIMEDOUT: If controller could not complete the request. This may happen if
+ *  the bus lines are not clocked, controller is not powered-on, slave with
+ *  given address is not enumerated/responding.
+ */
+extern int slim_request_val_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *buf,
+					u8 len);
+extern int slim_request_inf_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *buf,
+					u8 len);
+extern int slim_change_val_element(struct slim_device *sb,
+					struct slim_ele_access *msg,
+					const u8 *buf, u8 len);
+extern int slim_clear_inf_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *buf,
+					u8 len);
+extern int slim_request_change_val_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *rbuf,
+					const u8 *wbuf, u8 len);
+extern int slim_request_clear_inf_element(struct slim_device *sb,
+					struct slim_ele_access *msg, u8 *rbuf,
+					const u8 *wbuf, u8 len);
+
+/*
+ * Broadcast message API:
+ * call this API directly with sbdev = NULL.
+ * For broadcast reads, make sure that buffers are big-enough to incorporate
+ * replies from all logical addresses.
+ * All controllers may not support broadcast
+ */
+extern int slim_xfer_msg(struct slim_controller *ctrl,
+			struct slim_device *sbdev, struct slim_ele_access *msg,
+			u8 mc, u8 *rbuf, const u8 *wbuf, u8 len);
+/* end of message apis */
+
+/* Port management for manager device APIs */
+
+/*
+ * slim_alloc_mgrports: Allocate port on manager side.
+ * @sb: device/client handle.
+ * @req: Port request type.
+ * @nports: Number of ports requested
+ * @rh: output buffer to store the port handles
+ * @hsz: size of buffer storing handles
+ * context: can sleep
+ * This port will be typically used by SW. e.g. client driver wants to receive
+ * some data from audio codec HW using a data channel.
+ * Port allocated using this API will be used to receive the data.
+ * If half-duplex ports are requested, two adjacent ports are allocated for
+ * 1 half-duplex port. So the handle-buffer size should be twice the number
+ * of half-duplex ports to be allocated.
+ * -EDQUOT is returned if all ports are in use.
+ */
+extern int slim_alloc_mgrports(struct slim_device *sb, enum slim_port_req req,
+				int nports, u32 *rh, int hsz);
+
+/* Deallocate the port(s) allocated using the API above */
+extern int slim_dealloc_mgrports(struct slim_device *sb, u32 *hdl, int hsz);
+
+/*
+ * slim_port_xfer: Schedule buffer to be transferred/received using port-handle.
+ * @sb: client handle
+ * @ph: port-handle
+ * @iobuf: buffer to be transferred or populated
+ * @len: buffer size.
+ * @comp: completion signal to indicate transfer done or error.
+ * context: can sleep
+ * Returns number of bytes transferred/received if used synchronously.
+ * Will return 0 if used asynchronously.
+ * Client will call slim_port_get_xfer_status to get error and/or number of
+ * bytes transferred if used asynchronously.
+ */
+extern int slim_port_xfer(struct slim_device *sb, u32 ph, u8 *iobuf, u32 len,
+				struct completion *comp);
+
+/*
+ * slim_port_get_xfer_status: Poll for port transfers, or get transfer status
+ *	after completion is done.
+ * @sb: client handle
+ * @ph: port-handle
+ * @done_buf: return pointer (iobuf from slim_port_xfer) which is processed.
+ * @done_len: Number of bytes transferred.
+ * This can be called when port_xfer complition is signalled.
+ * The API will return port transfer error (underflow/overflow/disconnect)
+ * and/or done_len will reflect number of bytes transferred. Note that
+ * done_len may be valid even if port error (overflow/underflow) has happened.
+ * e.g. If the transfer was scheduled with a few bytes to be transferred and
+ * client has not supplied more data to be transferred, done_len will indicate
+ * number of bytes transferred with underflow error. To avoid frequent underflow
+ * errors, multiple transfers can be queued (e.g. ping-pong buffers) so that
+ * channel has data to be transferred even if client is not ready to transfer
+ * data all the time. done_buf will indicate address of the last buffer
+ * processed from the multiple transfers.
+ */
+extern enum slim_port_err slim_port_get_xfer_status(struct slim_device *sb,
+			u32 ph, u8 **done_buf, u32 *done_len);
+
+/*
+ * slim_connect_ports: Connect port(s) to channel.
+ * @sb: client handle
+ * @srch: source handles to be connected to this channel
+ * @nrsc: number of source ports
+ * @sinkh: sink handle to be connected to this channel
+ * @chanh: Channel with which the ports need to be associated with.
+ * Per slimbus specification, a channel may have multiple source-ports and 1
+ * sink port.Channel specified in chanh needs to be allocated first.
+ */
+extern int slim_connect_ports(struct slim_device *sb, u32 *srch, int nsrc,
+				u32 sinkh, u16 chanh);
+
+/*
+ * slim_disconnect_ports: Disconnect port(s) from channel
+ * @sb: client handle
+ * @ph: ports to be disconnected
+ * @nph: number of ports.
+ * Disconnects ports from a channel.
+ */
+extern int slim_disconnect_ports(struct slim_device *sb, u32 *ph, int nph);
+
+/*
+ * slim_get_slaveport: Get slave port handle
+ * @la: slave device logical address.
+ * @idx: port index at slave
+ * @rh: return handle
+ * @flw: Flow type (source or destination)
+ * This API only returns a slave port's representation as expected by slimbus
+ * driver. This port is not managed by the slimbus driver. Caller is expected
+ * to have visibility of this port since it's a device-port.
+ */
+extern int slim_get_slaveport(u8 la, int idx, u32 *rh, enum slim_port_flow flw);
+
+
+/* Channel functions. */
+
+/*
+ * slim_alloc_ch: Allocate a slimbus channel and return its handle.
+ * @sb: client handle.
+ * @chanh: return channel handle
+ * Slimbus channels are limited to 256 per specification. LSB of the handle
+ * indicates channel number and MSB of the handle is used by the slimbus
+ * framework. -EXFULL is returned if all channels are in use.
+ * Although slimbus specification supports 256 channels, a controller may not
+ * support that many channels.
+ */
+extern int slim_alloc_ch(struct slim_device *sb, u16 *chanh);
+
+/*
+ * slim_dealloc_ch: Deallocate channel allocated using the API above
+ * -EISCONN is returned if the channel is tried to be deallocated without
+ *  being removed first.
+ */
+extern int slim_dealloc_ch(struct slim_device *sb, u16 chanh);
+
+
+/*
+ * slim_define_ch: Define a channel.This API defines channel parameters for a
+ *	given channel.
+ * @sb: client handle.
+ * @prop: slim_ch structure with channel parameters desired to be used.
+ * @chanh: list of channels to be defined.
+ * @nchan: number of channels in a group (1 if grp is false)
+ * @grp: Are the channels grouped
+ * @grph: return group handle if grouping of channels is desired.
+ *	Channels can be grouped if multiple channels use same parameters
+ *	(e.g. 5.1 audio has 6 channels with same parameters. They will all be
+ *	grouped and given 1 handle for simplicity and avoid repeatedly calling
+ *	the API)
+ * -EISCONN is returned if the channel is already connected. -EBUSY is
+ * returned if the channel is already allocated to some other client.
+ */
+extern int slim_define_ch(struct slim_device *sb, struct slim_ch *prop,
+				u16 *chanh, u8 nchan, bool grp, u16 *grph);
+
+/*
+ * slim_control_ch: Channel control API.
+ * @sb: client handle
+ * @grpchanh: group or channel handle to be controlled
+ * @chctrl: Control command (activate/suspend/remove)
+ * @commit: flag to indicate whether the control should take effect right-away.
+ * This API activates, removes or suspends a channel (or group of channels)
+ * grpchanh indicates the channel or group handle (returned by the define_ch
+ * API). Reconfiguration may be time-consuming since it can change all other
+ * active channel allocations on the bus, change in clock gear used by the
+ * slimbus, and change in the control space width used for messaging.
+ * commit makes sure that multiple channels can be activated/deactivated before
+ * reconfiguration is started.
+ * -EXFULL is returned if there is no space in TDM to reserve the bandwidth.
+ * -EISCONN/-ENOTCONN is returned if the channel is already connected or not
+ * yet defined.
+ */
+extern int slim_control_ch(struct slim_device *sb, u16 grpchanh,
+				enum slim_ch_control chctrl, bool commit);
+
+/*
+ * slim_get_ch_state: Channel state.
+ * This API returns the channel's state (active, suspended, inactive etc)
+ */
+extern enum slim_ch_state slim_get_ch_state(struct slim_device *sb,
+						u16 chanh);
+
+/*
+ * slim_reservemsg_bw: Request to reserve bandwidth for messages.
+ * @sb: client handle
+ * @bw_bps: message bandwidth in bits per second to be requested
+ * @commit: indicates whether the reconfiguration needs to be acted upon.
+ * This API call can be grouped with slim_control_ch API call with only one of
+ * the APIs specifying the commit flag to avoid reconfiguration being called too
+ * frequently. -EXFULL is returned if there is no space in TDM to reserve the
+ * bandwidth. -EBUSY is returned if reconfiguration is requested, but a request
+ * is already in progress.
+ */
+extern int slim_reservemsg_bw(struct slim_device *sb, u32 bw_bps, bool commit);
+
+/*
+ * slim_reconfigure_now: Request reconfiguration now.
+ * @sb: client handle
+ * This API does what commit flag in other scheduling APIs do.
+ * -EXFULL is returned if there is no space in TDM to reserve the
+ * bandwidth. -EBUSY is returned if reconfiguration request is already in
+ * progress.
+ */
+extern int slim_reconfigure_now(struct slim_device *sb);
+
+/*
+ * slim_driver_register: Client driver registration with slimbus
+ * @drv:Client driver to be associated with client-device.
+ * This API will register the client driver with the slimbus
+ * It is called from the driver's module-init function.
+ */
+extern int slim_driver_register(struct slim_driver *drv);
+
+/*
+ * slim_add_numbered_controller: Controller bring-up.
+ * @ctrl: Controller to be registered.
+ * A controller is registered with the framework using this API. ctrl->nr is the
+ * desired number with which slimbus framework registers the controller.
+ * Function will return -EBUSY if the number is in use.
+ */
+extern int slim_add_numbered_controller(struct slim_controller *ctrl);
+
+/*
+ * slim_del_controller: Controller tear-down.
+ * Controller added with the above API is teared down using this API.
+ */
+extern int slim_del_controller(struct slim_controller *ctrl);
+
+/*
+ * slim_add_device: Add a new device without register board info.
+ * @ctrl: Controller to which this device is to be added to.
+ * Called when device doesn't have an explicit client-driver to be probed, or
+ * the client-driver is a module installed dynamically.
+ */
+extern int slim_add_device(struct slim_controller *ctrl,
+			struct slim_device *sbdev);
+
+/* slim_remove_device: Remove the effect of slim_add_device() */
+extern void slim_remove_device(struct slim_device *sbdev);
+
+/*
+ * slim_assign_laddr: Assign logical address to a device enumerated.
+ * @ctrl: Controller with which device is enumerated.
+ * @e_addr: 6-byte elemental address of the device.
+ * @e_len: buffer length for e_addr
+ * @laddr: Return logical address.
+ * Called by controller in response to REPORT_PRESENT. Framework will assign
+ * a logical address to this enumeration address.
+ * Function returns -EXFULL to indicate that all logical addresses are already
+ * taken.
+ */
+extern int slim_assign_laddr(struct slim_controller *ctrl, const u8 *e_addr,
+				u8 e_len, u8 *laddr);
+
+/*
+ * slim_msg_response: Deliver Message response received from a device to the
+ *	framework.
+ * @ctrl: Controller handle
+ * @reply: Reply received from the device
+ * @len: Length of the reply
+ * @tid: Transaction ID received with which framework can associate reply.
+ * Called by controller to inform framework about the response received.
+ * This helps in making the API asynchronous, and controller-driver doesn't need
+ * to manage 1 more table other than the one managed by framework mapping TID
+ * with buffers
+ */
+extern void slim_msg_response(struct slim_controller *ctrl, u8 *reply, u8 tid,
+				u8 len);
+
+/*
+ * slim_busnum_to_ctrl: Map bus number to controller
+ * @busnum: Bus number
+ * Returns controller representing this bus number
+ */
+extern struct slim_controller *slim_busnum_to_ctrl(u32 busnum);
+
+/*
+ * slim_register_board_info: Board-initialization routine.
+ * @info: List of all devices on all controllers present on the board.
+ * @n: number of entries.
+ * API enumerates respective devices on corresponding controller.
+ * Called from board-init function.
+ */
+#ifdef CONFIG_SLIMBUS
+extern int slim_register_board_info(struct slim_boardinfo const *info,
+					unsigned n);
+#else
+int slim_register_board_info(struct slim_boardinfo const *info,
+					unsigned n)
+{
+	return 0;
+}
+#endif
+
+static inline void *slim_get_ctrldata(const struct slim_controller *dev)
+{
+	return dev_get_drvdata(&dev->dev);
+}
+
+static inline void slim_set_ctrldata(struct slim_controller *dev, void *data)
+{
+	dev_set_drvdata(&dev->dev, data);
+}
+
+static inline void *slim_get_devicedata(const struct slim_device *dev)
+{
+	return dev_get_drvdata(&dev->dev);
+}
+
+static inline void slim_set_clientdata(struct slim_device *dev, void *data)
+{
+	dev_set_drvdata(&dev->dev, data);
+}
+#endif /* _LINUX_SLIMBUS_H */
-- 
1.7.3.3

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
