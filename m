Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543Ab1JYJwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:52:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41435 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756001Ab1JYJs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:48:59 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: <akpm@linux-foundation.org>, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ohad Ben-Cohen <ohad@wizery.com>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH 1/7] amp/remoteproc: add framework for controlling remote processors
Date: Tue, 25 Oct 2011 11:48:20 +0200
Message-Id: <1319536106-25802-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1319536106-25802-1-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern SoCs typically employ a central symmetric multiprocessing (SMP)
application processor running Linux, with several other asymmetric
multiprocessing (AMP) heterogeneous processors running different instances
of operating system, whether Linux or any other flavor of real-time OS.

Booting a remote processor in an AMP configuration typically involves:
- Loading a firmware which contains the OS image
- Allocating and providing it required system resources (e.g. memory)
- Programming an IOMMU (when relevant)
- Powering on the device

This patch introduces a generic framework that allows drivers to do
that. In the future, this framework will also include runtime power
management and error recovery.

Based on (but now quite far from) work done by Fernando Guzman Lugo
<fernando.lugo@ti.com>.

ELF loader was written by Mark Grosen <mgrosen@ti.com>, based on
msm's Peripheral Image Loader (PIL) by Stephen Boyd <sboyd@codeaurora.org>.

Designed with Brian Swetland <swetland@google.com>.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/amp/remoteproc.txt             |  324 ++++++
 MAINTAINERS                                  |    7 +
 drivers/Kconfig                              |    2 +
 drivers/Makefile                             |    1 +
 drivers/amp/Kconfig                          |    9 +
 drivers/amp/Makefile                         |    1 +
 drivers/amp/remoteproc/Kconfig               |    3 +
 drivers/amp/remoteproc/Makefile              |    6 +
 drivers/amp/remoteproc/remoteproc_core.c     | 1410 ++++++++++++++++++++++++++
 drivers/amp/remoteproc/remoteproc_internal.h |   44 +
 include/linux/amp/remoteproc.h               |  265 +++++
 11 files changed, 2072 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/amp/remoteproc.txt
 create mode 100644 drivers/amp/Kconfig
 create mode 100644 drivers/amp/Makefile
 create mode 100644 drivers/amp/remoteproc/Kconfig
 create mode 100644 drivers/amp/remoteproc/Makefile
 create mode 100644 drivers/amp/remoteproc/remoteproc_core.c
 create mode 100644 drivers/amp/remoteproc/remoteproc_internal.h
 create mode 100644 include/linux/amp/remoteproc.h

diff --git a/Documentation/amp/remoteproc.txt b/Documentation/amp/remoteproc.txt
new file mode 100644
index 0000000..63cecd9
--- /dev/null
+++ b/Documentation/amp/remoteproc.txt
@@ -0,0 +1,324 @@
+Remote Processor Framework
+
+1. Introduction
+
+Modern SoCs typically have heterogeneous remote processor devices in asymmetric
+multiprocessing (AMP) configurations, which may be running different instances
+of operating system, whether it's Linux or any other flavor of real-time OS.
+
+OMAP4, for example, has dual Cortex-A9, dual Cortex-M3 and a C64x+ DSP.
+In a typical configuration, the dual cortex-A9 is running Linux in a SMP
+configuration, and each of the other three cores (two M3 cores and a DSP)
+is running its own instance of RTOS in an AMP configuration.
+
+The remoteproc framework allows different platforms/architectures to
+control (power on, load firmware, power off) those remote processors while
+abstracting the hardware differences, so the entire driver doesn't need to be
+duplicated. In addition, this framework also adds rpmsg virtio devices
+for remote processors that supports this kind of communication. This way,
+platform-specific remoteproc drivers only need to provide a few low-level
+handlers, and then all rpmsg drivers will then just work
+(for more information about the virtio-based rpmsg bus and its drivers,
+please read Documentation/amp/rpmsg.txt).
+
+2. User API
+
+  int rproc_boot(struct rproc *rproc)
+    - Boot a remote processor (i.e. load its firmware, power it on, ...).
+      If the remote processor is already powered on, this function immediately
+      returns (successfully).
+      Returns 0 on success, and an appropriate error value otherwise.
+      Note: to use this function you should already have a valid rproc
+      handle. There are several ways to achieve that cleanly (devres, pdata,
+      the way remoteproc_rpmsg.c does this, or, if this becomes prevalent, we
+      might also consider using dev_archdata for this). See also
+      rproc_get_by_name() below.
+
+  void rproc_shutdown(struct rproc *rproc)
+    - Power off a remote processor (previously booted with rproc_boot()).
+      In case @rproc is still being used by an additional user(s), then
+      this function will just decrement the power refcount and exit,
+      without really powering off the device.
+      Every call to rproc_boot() must (eventually) be accompanied by a call
+      to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
+      Notes:
+      - we're not decrementing the rproc's refcount, only the power refcount.
+        which means that the @rproc handle stays valid even after
+        rproc_shutdown() returns, and users can still use it with a subsequent
+        rproc_boot(), if needed.
+      - don't call rproc_shutdown() to unroll rproc_get_by_name(), exactly
+        because rproc_shutdown() _does not_ decrement the refcount of @rproc.
+        To decrement the refcount of @rproc, use rproc_put() (but _only_ if
+        you acquired @rproc using rproc_get_by_name()).
+
+  struct rproc *rproc_get_by_name(const char *name)
+    - Find an rproc handle using the remote processor's name, and then
+      boot it. If it's already powered on, then just immediately return
+      (successfully). Returns the rproc handle on success, and NULL on failure.
+      This function increments the remote processor's refcount, so always
+      use rproc_put() to decrement it back once rproc isn't needed anymore.
+      Note: currently this function (and its counterpart rproc_put()) are not
+      used anymore by the amp sub-system. We need to scrutinize the use cases
+      that still need them, and see if we can migrate them to use the non
+      name-based boot/shutdown interface.
+
+  void rproc_put(struct rproc *rproc)
+    - Decrement @rproc's power refcount and shut it down if it reaches zero
+      (essentially by just calling rproc_shutdown), and then decrement @rproc's
+      validity refcount too.
+      After this function returns, @rproc may _not_ be used anymore, and its
+      handle should be considered invalid.
+      This function should be called _iff_ the @rproc handle was grabbed by
+      calling rproc_get_by_name().
+
+3. Typical usage
+
+#include <linux/amp/remoteproc.h>
+
+/* in case we were given a valid 'rproc' handle */
+int dummy_rproc_example(struct rproc *my_rproc)
+{
+	int ret;
+
+	/* let's power on and boot our remote processor */
+	ret = rproc_boot(my_rproc);
+	if (ret) {
+		/*
+		 * something went wrong. handle it and leave.
+		 */
+	}
+
+	/*
+	 * our remote processor is now powered on... give it some work
+	 */
+
+	/* let's shut it down now */
+	rproc_shutdown(my_rproc);
+}
+
+4. API for implementors
+
+  struct rproc *rproc_alloc(struct device *dev, const char *name,
+				const struct rproc_ops *ops,
+				const char *firmware, int len)
+    - Allocate a new remote processor handle, but don't register
+      it yet. Required parameters are the underlying device, the
+      name of this remote processor, platform-specific ops handlers,
+      the name of the firmware to boot this rproc with, and the
+      length of private data needed by the allocating rproc driver (in bytes).
+
+      This function should be used by rproc implementations during
+      initialization of the remote processor.
+      After creating an rproc handle using this function, and when ready,
+      implementations should then call rproc_register() to complete
+      the registration of the remote processor.
+      On success, the new rproc is returned, and on failure, NULL.
+
+      Note: _never_ directly deallocate @rproc, even if it was not registered
+      yet. Instead, if you just need to unroll rproc_alloc(), use rproc_free().
+
+  void rproc_free(struct rproc *rproc)
+    - Free an rproc handle that was allocated by rproc_alloc.
+      This function should _only_ be used if @rproc was only allocated,
+      but not registered yet.
+      If @rproc was already successfully registered (by calling
+      rproc_register()), then use rproc_unregister() instead.
+
+  int rproc_register(struct rproc *rproc)
+    - Register @rproc with the remoteproc framework, after it has been
+      allocated with rproc_alloc().
+      This is called by the platform-specific rproc implementation, whenever
+      a new remote processor device is probed.
+      Returns 0 on success and an appropriate error code otherwise.
+      Note: this function initiates an asynchronous firmware loading
+      context, which will look for virtio devices supported by the rproc's
+      firmware.
+      If found, those virtio devices will be created and added, so as a result
+      of registering this remote processor, additional virtio drivers might get
+      probed.
+      Currently, though, we only support a single RPMSG virtio vdev per remote
+      processor.
+
+  int rproc_unregister(struct rproc *rproc)
+    - Unregister a remote processor, and decrement its refcount.
+      If its refcount drops to zero, then @rproc will be freed. If not,
+      it will be freed later once the last reference is dropped.
+
+      This function should be called when the platform specific rproc
+      implementation decides to remove the rproc device. it should
+      _only_ be called if a previous invocation of rproc_register()
+      has completed successfully.
+
+      After rproc_unregister() returns, @rproc is _not_ valid anymore and
+      it shouldn't be used. More specifically, don't call rproc_free()
+      or try to directly free @rproc after rproc_unregister() returns;
+      none of these are needed, and calling them is a bug.
+
+      Returns 0 on success and -EINVAL if @rproc isn't valid.
+
+5. Implementation callbacks
+
+These callbacks should be provided by platform-specific remoteproc
+drivers:
+
+/**
+ * struct rproc_ops - platform-specific device handlers
+ * @start:	power on the device and boot it
+ * @stop:	power off the device
+ * @kick:	kick a virtqueue (virtqueue id given as a parameter)
+ */
+struct rproc_ops {
+	int (*start)(struct rproc *rproc);
+	int (*stop)(struct rproc *rproc);
+	void (*kick)(struct rproc *rproc, int vqid);
+};
+
+Every remoteproc implementation should at least provide the ->start and ->stop
+handlers. If rpmsg functionality is also desired, then the ->kick handler
+should be provided as well.
+
+The ->start() handler takes an rproc handle and should then power on the
+device and boot it (use rproc->priv to access platform-specific private data).
+The boot address, in case needed, can be found in rproc->bootaddr (remoteproc
+core puts there the ELF entry point).
+On success, 0 should be returned, and on failure, an appropriate error code.
+
+The ->stop() handler takes an rproc handle and powers the device down.
+On success, 0 is returned, and on failure, an appropriate error code.
+
+The ->kick() handler takes an rproc handle, and an index of a virtqueue
+where new message was placed in. Implementations should interrupt the remote
+processor and let it know it has pending messages. Notifying remote processors
+the exact virtqueue index to look in is optional: it is easy (and not
+too expensive) to go through the existing virtqueues and look for new buffers
+in the used rings.
+
+6. Binary Firmware Structure
+
+At this point remoteproc only supports ELF32 firmware binaries. However,
+it is quite expected that other platforms/devices which we'd want to
+support with this framework will be based on different binary formats.
+
+When those use cases show up, we will have to decouple the binary format
+from the framework core, so we can support several binary formats without
+duplicating common code.
+
+When the firmware is parsed, its various segments are loaded to memory
+according to the specified device address (might be a physical address
+if the remote processor is accessing memory directly).
+
+In addition to the standard ELF segments, most remote processors would
+also include a special section which we call "the resource table".
+
+The resource table contains system resources that the remote processor
+requires before it should be powered on, such as allocation of physically
+contiguous memory, or iommu mapping of certain on-chip peripherals.
+Remotecore will only power up the device after all the resource table's
+requirement are met.
+
+In addition to system resources, the resource table may also contain
+resource entries that publish the existence of supported features
+or configurations by the remote processor, such as trace buffers and
+supported virtio devices (and their configurations).
+
+Currently the resource table is just an array of:
+
+/**
+ * struct fw_resource - describes an entry from the resource section
+ * @type: resource type
+ * @id: index number of the resource
+ * @da: device address of the resource
+ * @pa: physical address of the resource
+ * @len: size, in bytes, of the resource
+ * @flags: properties of the resource, e.g. iommu protection required
+ * @reserved: must be 0 atm
+ * @name: name of resource
+ */
+struct fw_resource {
+	u32 type;
+	u32 id;
+	u64 da;
+	u64 pa;
+	u32 len;
+	u32 flags;
+	u8 reserved[16];
+	u8 name[48];
+} __packed;
+
+Some resources entries are mere announcements, where the host is informed
+of specific remoteproc configuration. Other entries require the host to
+do something (e.g. reserve a requested resource) and possibly also reply
+by overwriting a member inside 'struct fw_resource' with info about the
+allocated resource.
+
+Different resource entries use different members of this struct,
+with different meanings. This is pretty limiting and error-prone,
+so the plan is to move to variable-length TLV-based resource entries,
+where each resource will begin with a type and length fields, followed by
+its own specific structure.
+
+Here are the resource types that are currently being used:
+
+/**
+ * enum fw_resource_type - types of resource entries
+ *
+ * @RSC_CARVEOUT:   request for allocation of a physically contiguous
+ *		    memory region.
+ * @RSC_DEVMEM:     request to iommu_map a memory-based peripheral.
+ * @RSC_TRACE:	    announces the availability of a trace buffer into which
+ *		    the remote processor will be writing logs. In this case,
+ *		    'da' indicates the device address where logs are written to,
+ *		    and 'len' is the size of the trace buffer.
+ * @RSC_VRING:	    request for allocation of a virtio vring (address should
+ *		    be indicated in 'da', and 'len' should contain the number
+ *		    of buffers supported by the vring).
+ * @RSC_VIRTIO_DEV: announces support for a virtio device, and serves as
+ *		    the virtio header. 'da' contains the virtio device
+ *		    features, 'pa' holds the virtio guest features (host
+ *		    will write them here after they're negotiated), 'len'
+ *		    holds the virtio status, and 'flags' holds the virtio
+ *		    device id (currently only VIRTIO_ID_RPMSG is supported).
+ */
+enum fw_resource_type {
+	RSC_CARVEOUT	= 0,
+	RSC_DEVMEM	= 1,
+	RSC_TRACE	= 2,
+	RSC_VRING	= 3,
+	RSC_VIRTIO_DEV	= 4,
+	RSC_VIRTIO_CFG	= 5,
+};
+
+Most of the resource entries share the basic idea of address/length
+negotiation with the host: the firmware usually asks for memory
+of size 'len' bytes, and the host needs to allocate it and provide
+the device/physical address (when relevant) in 'da'/'pa' respectively.
+
+If the firmware is compiled with hard coded device addresses, and
+can't handle dynamically allocated 'da' values, then the 'da' field
+will contain the expected device addresses (today we actually only support
+this scheme, as there aren't yet any use cases for dynamically allocated
+device addresses).
+
+We also expect that platform-specific resource entries will show up
+at some point. When that happens, we could easily add a new RSC_PLAFORM
+type, and hand those resources to the platform-specific rproc driver to handle.
+
+7. Virtio and remoteproc
+
+The firmware should provide remoteproc information about virtio devices
+that it supports, and their configurations: a RSC_VIRTIO_DEV resource entry
+should specify the virtio device id, and subsequent RSC_VRING resource entries
+should indicate the vring size (i.e. how many buffers do they support) and
+where should they be mapped (i.e. which device address). Note: the alignment
+between the consumer and producer parts of the vring is assumed to be 4096.
+
+At this point we only support a single virtio rpmsg device per remote
+processor, but the plan is to remove this limitation. In addition, once we
+move to TLV-based resource table, the plan is to have a single RSC_VIRTIO
+entry per supported virtio device, which will include the virtio header,
+the vrings information and the virtio config space.
+
+Of course, RSC_VIRTIO resource entries are only good enough for static
+allocation of virtio devices. Dynamic allocations will also be made possible
+using the rpmsg bus (similar to how we already do dynamic allocations of
+rpmsg channels; read more about it in rpmsg.txt).
diff --git a/MAINTAINERS b/MAINTAINERS
index ace8f9c..2812cd7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1205,6 +1205,13 @@ L:	lm-sensors@lm-sensors.org
 S:	Maintained
 F:	drivers/hwmon/asb100.c
 
+ASYNCHRONOUS MULTIPROCESSING (AMP) FRAMEWORK
+M:	Ohad Ben-Cohen <ohad@wizery.com>
+S:	Maintained
+F:	drivers/amp/
+F:	Documentation/amp/
+F:	include/linux/amp/
+
 ASYNCHRONOUS TRANSFERS/TRANSFORMS (IOAT) API
 M:	Dan Williams <dan.j.williams@intel.com>
 W:	http://sourceforge.net/projects/xscaleiop
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 95b9e7e..dfb7d36 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -128,6 +128,8 @@ source "drivers/clocksource/Kconfig"
 
 source "drivers/iommu/Kconfig"
 
+source "drivers/amp/Kconfig"
+
 source "drivers/virt/Kconfig"
 
 endmenu
diff --git a/drivers/Makefile b/drivers/Makefile
index 7fa433a..8f41a77 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -124,6 +124,7 @@ obj-y				+= clk/
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
 obj-$(CONFIG_NFC)		+= nfc/
 obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/
+obj-y				+= amp/
 
 # Virtualization drivers
 obj-$(CONFIG_VIRT_DRIVERS)	+= virt/
diff --git a/drivers/amp/Kconfig b/drivers/amp/Kconfig
new file mode 100644
index 0000000..23a8ed1
--- /dev/null
+++ b/drivers/amp/Kconfig
@@ -0,0 +1,9 @@
+#
+# AMP subsystem configuration
+#
+
+menu "Asymmetric Multiprocessing (AMP) Framework"
+
+source "drivers/amp/remoteproc/Kconfig"
+
+endmenu
diff --git a/drivers/amp/Makefile b/drivers/amp/Makefile
new file mode 100644
index 0000000..708461d
--- /dev/null
+++ b/drivers/amp/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_REMOTEPROC)	+= remoteproc/
diff --git a/drivers/amp/remoteproc/Kconfig b/drivers/amp/remoteproc/Kconfig
new file mode 100644
index 0000000..b250b15
--- /dev/null
+++ b/drivers/amp/remoteproc/Kconfig
@@ -0,0 +1,3 @@
+# REMOTEPROC gets selected by whoever wants it
+config REMOTEPROC
+	tristate
diff --git a/drivers/amp/remoteproc/Makefile b/drivers/amp/remoteproc/Makefile
new file mode 100644
index 0000000..2a5fd79
--- /dev/null
+++ b/drivers/amp/remoteproc/Makefile
@@ -0,0 +1,6 @@
+#
+# Generic framework for controlling remote processors
+#
+
+obj-$(CONFIG_REMOTEPROC)		+= remoteproc.o
+remoteproc-y				:= remoteproc_core.o
diff --git a/drivers/amp/remoteproc/remoteproc_core.c b/drivers/amp/remoteproc/remoteproc_core.c
new file mode 100644
index 0000000..be6774f
--- /dev/null
+++ b/drivers/amp/remoteproc/remoteproc_core.c
@@ -0,0 +1,1410 @@
+/*
+ * Remote Processor Framework
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Brian Swetland <swetland@google.com>
+ * Mark Grosen <mgrosen@ti.com>
+ * Fernando Guzman Lugo <fernando.lugo@ti.com>
+ * Suman Anna <s-anna@ti.com>
+ * Robert Tivy <rtivy@ti.com>
+ * Armando Uribe De Leon <x0095078@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt)    "%s: " fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/dma-mapping.h>
+#include <linux/firmware.h>
+#include <linux/string.h>
+#include <linux/debugfs.h>
+#include <linux/amp/remoteproc.h>
+#include <linux/iommu.h>
+#include <linux/klist.h>
+#include <linux/elf.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_ring.h>
+
+#include "remoteproc_internal.h"
+
+static void klist_rproc_get(struct klist_node *n);
+static void klist_rproc_put(struct klist_node *n);
+
+/*
+ * klist of the available remote processors.
+ *
+ * We need this in order to support name-based lookups (needed by the
+ * rproc_get_by_name()).
+ *
+ * That said, we don't use rproc_get_by_name() anymore within the amp
+ * framework. The use cases that do require its existence should be
+ * scrutinized, and hopefully migrated to rproc_boot() using device-based
+ * binding.
+ *
+ * If/when this materializes, we could drop the klist (and the by_name
+ * API).
+ */
+static DEFINE_KLIST(rprocs, klist_rproc_get, klist_rproc_put);
+
+typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
+				struct fw_resource *rsc, int len);
+
+/*
+ * This is the IOMMU fault handler we register with the IOMMU API
+ * (when relevant; not all remote processors access memory through
+ * an IOMMU).
+ *
+ * IOMMU core will invoke this handler whenever the remote processor
+ * will try to access an unmapped device address.
+ *
+ * Currently this is mostly a stub, but it will be later used to trigger
+ * the recovery of the remote processor.
+ */
+static int rproc_iommu_fault(struct iommu_domain *domain, struct device *dev,
+		unsigned long iova, int flags)
+{
+	dev_err(dev, "iommu fault: da 0x%lx flags 0x%x\n", iova, flags);
+
+	/*
+	 * Let the iommu core know we're not really handling this fault;
+	 * we just plan to use this as a recovery trigger.
+	 */
+	return -ENOSYS;
+}
+
+static int rproc_enable_iommu(struct rproc *rproc)
+{
+	struct iommu_domain *domain;
+	struct device *dev = rproc->dev;
+	int ret;
+
+	/*
+	 * We currently use iommu_present() to decide if an IOMMU
+	 * setup is needed.
+	 *
+	 * This works for simple cases, but will easily fail with
+	 * platforms that do have an IOMMU, but not for this specific
+	 * rproc.
+	 *
+	 * This will be easily solved by introducing hw capabilities
+	 * that will be set by the remoteproc driver.
+	 */
+	if (!iommu_present(dev->bus)) {
+		dev_err(dev, "iommu not found\n");
+		return -ENODEV;
+	}
+
+	domain = iommu_domain_alloc(dev->bus);
+	if (!domain) {
+		dev_err(dev, "can't alloc iommu domain\n");
+		return -ENOMEM;
+	}
+
+	iommu_set_fault_handler(domain, rproc_iommu_fault);
+
+	ret = iommu_attach_device(domain, dev);
+	if (ret) {
+		dev_err(dev, "can't attach iommu device: %d\n", ret);
+		goto free_domain;
+	}
+
+	rproc->domain = domain;
+
+	return 0;
+
+free_domain:
+	iommu_domain_free(domain);
+	return ret;
+}
+
+static void rproc_disable_iommu(struct rproc *rproc)
+{
+	struct iommu_domain *domain = rproc->domain;
+	struct device *dev = rproc->dev;
+
+	if (!domain)
+		return;
+
+	iommu_detach_device(domain, dev);
+	iommu_domain_free(domain);
+
+	return;
+}
+
+/*
+ * Some remote processors will ask us to allocate them physically contiguous
+ * memory regions (which we call "carveouts"), and map them to specific
+ * device addresses (which are hardcoded in the firmware).
+ *
+ * They may then ask us to copy objects into specific device addresses (e.g.
+ * code/data sections) or expose us certain symbols in other device address
+ * (e.g. their trace buffer).
+ *
+ * This function is an internal helper with which we can go over the allocated
+ * carveouts and translate specific device address to kernel virtual addresses
+ * so we can access the referenced memory.
+ *
+ * Note: phys_to_virt(iommu_iova_to_phys(rproc->domain, da)) will work too,
+ * but only on kernel direct mapped RAM memory. Instead, we're just using
+ * here the output of the DMA API, which should be more correct.
+ */
+static void *rproc_da_to_va(struct rproc *rproc, u64 da, int len)
+{
+	struct rproc_mem_entry *carveout;
+	void *ptr = NULL;
+
+	list_for_each_entry(carveout, &rproc->carveouts, node) {
+		int offset = da - carveout->da;
+
+		/* try next carveout if da is too small */
+		if (offset < 0)
+			continue;
+
+		/* try next carveout if da is too large */
+		if (offset + len > carveout->len)
+			continue;
+
+		ptr = carveout->va + offset;
+
+		break;
+	}
+
+	return ptr;
+}
+
+/**
+ * rproc_load_segments() - load firmware segments to memory
+ * @rproc: remote processor which will be booted using these fw segments
+ * @elf_data: the content of the ELF firmware image
+ *
+ * This function loads the firmware segments to memory, where the remote
+ * processor expects them.
+ *
+ * Some remote processors will expect their code and data to be placed
+ * in specific device addresses, and can't have them dynamically assigned.
+ *
+ * We currently support only those kind of remote processors, and expect
+ * the program header's paddr member to contain those addresses. We then go
+ * through the physically contiguous "carveout" memory regions which we
+ * allocated (and mapped) earlier on behalf of the remote processor,
+ * and "translate" device address to kernel addresses, so we can copy the
+ * segments where they are expected.
+ *
+ * Currently we only support remote processors that required carveout
+ * allocations and got them mapped onto their iommus. Some processors
+ * might be different: they might not have iommus, and would prefer to
+ * directly allocate memory for every segment/resource. This is not yet
+ * supported, though.
+ */
+static int rproc_load_segments(struct rproc *rproc, const u8 *elf_data)
+{
+	struct device *dev = rproc->dev;
+	struct elf32_hdr *ehdr;
+	struct elf32_phdr *phdr;
+	int i, ret = 0;
+
+	ehdr = (struct elf32_hdr *)elf_data;
+	phdr = (struct elf32_phdr *)(elf_data + ehdr->e_phoff);
+
+	/* go through the available ELF segments */
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		u32 da = phdr->p_paddr;
+		u32 memsz = phdr->p_memsz;
+		u32 filesz = phdr->p_filesz;
+		void *ptr;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		dev_dbg(dev, "phdr: type %d da 0x%x memsz 0x%x filesz 0x%x\n",
+					phdr->p_type, da, memsz, filesz);
+
+		if (filesz > memsz) {
+			dev_err(dev, "bad phdr filesz 0x%x memsz 0x%x\n",
+							filesz, memsz);
+			ret = -EINVAL;
+			break;
+		}
+
+		/* grab the kernel address for this device address */
+		ptr = rproc_da_to_va(rproc, da, memsz);
+		if (!ptr) {
+			dev_err(dev, "bad phdr da 0x%x mem 0x%x\n", da, memsz);
+			ret = -EINVAL;
+			break;
+		}
+
+		/* put the segment where the remote processor expects it */
+		if (phdr->p_filesz)
+			memcpy(ptr, elf_data + phdr->p_offset, filesz);
+
+		/*
+		 * Zero out remaining memory for this segment.
+		 *
+		 * This isn't strictly required since dma_alloc_coherent already
+		 * did this for us. albeit harmless, we may consider removing
+		 * this.
+		 */
+		if (memsz > filesz)
+			memset(ptr + filesz, 0, memsz - filesz);
+	}
+
+	return ret;
+}
+
+/**
+ * rproc_handle_virtio_hdr() - handle a virtio header resource
+ * @rproc: the remote processor
+ * @rsc: the resource descriptor
+ *
+ * The existence of this virtio hdr resource entry means that the firmware
+ * of this @rproc supports this virtio device.
+ *
+ * Currently we support only a single virtio device of type VIRTIO_ID_RPMSG,
+ * but the plan is to remove this limitation and support any number
+ * of virtio devices (and of any type). We'll also add support for dynamically
+ * adding (and removing) virtio devices over the rpmsg bus, but small
+ * firmwares that doesn't want to get involved with rpmsg will be able
+ * to simple use the resource table for this.
+ *
+ * At this point this virtio header entry is rather simple: it just
+ * announces the virtio device id and the supported virtio device features.
+ * The plan though is to extend this to include the vring information and
+ * the virtio config space, too (but first, some resource table overhaul
+ * is needed: move from fixed-sized to variable-length TLV entries).
+ *
+ * For now, the 'flags' member of the resource entry contains the virtio
+ * device id, the 'da' member contains the device features, and 'pa' is
+ * where we need to store the guest features once negotiation completes.
+ * As usual, the 'id' member of this resource contains the index of this
+ * resource type (i.e. is this the first virtio hdr entry, the 2nd, ...).
+ *
+ * Returns 0 on success, or an appropriate error code otherwise
+ */
+static int rproc_handle_virtio_hdr(struct rproc *rproc, struct fw_resource *rsc)
+{
+	struct rproc_vdev *rvdev;
+
+	/* we only support VIRTIO_ID_RPMSG devices for now */
+	if (rsc->flags != VIRTIO_ID_RPMSG) {
+		dev_warn(rproc->dev, "unsupported vdev: %d\n", rsc->flags);
+		return -EINVAL;
+	}
+
+	/* we only support a single vdev per rproc for now */
+	if (rsc->id || rproc->rvdev) {
+		dev_warn(rproc->dev, "redundant vdev entry: %s\n", rsc->name);
+		return -EINVAL;
+	}
+
+	rvdev = kzalloc(sizeof(struct rproc_vdev), GFP_KERNEL);
+	if (!rvdev)
+		return -ENOMEM;
+
+	/* remember the device features */
+	rvdev->dfeatures = rsc->da;
+
+	rproc->rvdev = rvdev;
+	rvdev->rproc = rproc;
+
+	return 0;
+}
+
+/**
+ * rproc_handle_vring() - handle a vring fw resource
+ * @rproc: the remote processor
+ * @rsc: the vring resource descriptor
+ *
+ * This resource entry requires allocation of non-cacheable memory
+ * for a virtio vring. Currently we only support two vrings per remote
+ * processor, required for the virtio rpmsg device.
+ *
+ * The 'len' member of @rsc should contain the number of buffers this vring
+ * support and 'da' should either contain the device address where
+ * the remote processor is expecting the vring, or indicate that
+ * dynamically allocation of the vring's device address is supported.
+ *
+ * Note: 'da' is currently not handled. This will be revised when the generic
+ * iommu-based DMA API will arrive, or a dynanic & non-iommu use case show
+ * up. Meanwhile, statically-addressed iommu-based images should use
+ * RSC_DEVMEM resource entries to map their require 'da' to the physical
+ * address of their base CMA region.
+ *
+ * Returns 0 on success, or an appropriate error code otherwise
+ */
+static int rproc_handle_vring(struct rproc *rproc, struct fw_resource *rsc)
+{
+	struct device *dev = rproc->dev;
+	struct rproc_vdev *rvdev = rproc->rvdev;
+	dma_addr_t dma;
+	int size, id = rsc->id;
+	void *va;
+
+	/* no vdev is in place ? */
+	if (!rvdev) {
+		dev_err(dev, "vring requested without a virtio dev entry\n");
+		return -EINVAL;
+	}
+
+	/* the firmware must provide the expected queue size */
+	if (!rsc->len) {
+		dev_err(dev, "missing expected queue size\n");
+		return -EINVAL;
+	}
+
+	/* we currently support two vrings per rproc (for rx and tx) */
+	if (id >= ARRAY_SIZE(rvdev->vring)) {
+		dev_err(dev, "%s: invalid vring id %d\n", rsc->name, id);
+		return -EINVAL;
+	}
+
+	/* have we already allocated this vring id ? */
+	if (rvdev->vring[id].len) {
+		dev_err(dev, "%s: duplicated id %d\n", rsc->name, id);
+		return -EINVAL;
+	}
+
+	/* actual size of vring (in bytes) */
+	size = PAGE_ALIGN(vring_size(rsc->len, AMP_VRING_ALIGN));
+
+	/*
+	 * Allocate non-cacheable memory for the vring. In the future
+	 * this call will also configure the IOMMU for us
+	 */
+	va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
+	if (!va) {
+		dev_err(dev, "dma_alloc_coherent failed\n");
+		return -ENOMEM;
+	}
+
+	dev_dbg(dev, "vring%d: va %p dma %x qsz %d ring size %x\n", id, va,
+					dma, rsc->len, size);
+
+	rvdev->vring[id].len = rsc->len;
+	rvdev->vring[id].va = va;
+	rvdev->vring[id].dma = dma;
+
+	return 0;
+}
+
+/**
+ * rproc_handle_trace() - handle a shared trace buffer resource
+ * @rproc: the remote processor
+ * @rsc: the trace resource descriptor
+ *
+ * In case the remote processor dumps trace logs into memory,
+ * export it via debugfs.
+ *
+ * Currently, the 'da' member of @rsc should contain the device address
+ * where the remote processor is dumping the traces. Later we could also
+ * support dynamically allocating this address using the generic
+ * DMA API (but currently there isn't a use case for that).
+ *
+ * Returns 0 on success, or an appropriate error code otherwise
+ */
+static int rproc_handle_trace(struct rproc *rproc, struct fw_resource *rsc)
+{
+	struct rproc_mem_entry *trace;
+	struct device *dev = rproc->dev;
+	void *ptr;
+	char name[15];
+
+	/* what's the kernel address of this resource ? */
+	ptr = rproc_da_to_va(rproc, rsc->da, rsc->len);
+	if (!ptr) {
+		dev_err(dev, "erroneous trace resource entry\n");
+		return -EINVAL;
+	}
+
+	trace = kzalloc(sizeof(*trace), GFP_KERNEL);
+	if (!trace) {
+		dev_err(dev, "kzalloc trace failed\n");
+		return -ENOMEM;
+	}
+
+	/* set the trace buffer dma properties */
+	trace->len = rsc->len;
+	trace->va = ptr;
+
+	/* make sure snprintf always null terminates, even if truncating */
+	snprintf(name, sizeof(name), "trace%d", rproc->num_traces);
+
+	/* create the debugfs entry */
+	trace->priv = rproc_create_trace_file(name, rproc, trace);
+	if (!trace->priv) {
+		trace->va = NULL;
+		kfree(trace);
+		return -EINVAL;
+	}
+
+	list_add_tail(&trace->node, &rproc->traces);
+
+	rproc->num_traces++;
+
+	dev_dbg(dev, "%s added: va %p, da 0x%llx, len 0x%x\n", name, ptr,
+						rsc->da, rsc->len);
+
+	return 0;
+}
+
+/**
+ * rproc_handle_devmem() - handle devmem resource entry
+ * @rproc: remote processor handle
+ * @rsc: the devmem resource entry
+ *
+ * Remote processors commonly need to access certain on-chip peripherals.
+ *
+ * Some of these remote processors access memory via an iommu device,
+ * and might require us to configure their iommu before they can access
+ * the on-chip peripherals they need.
+ *
+ * This resource entry is a request to map such a peripheral device.
+ *
+ * These devmem entries will contain the physical address of the device in
+ * the 'pa' member. If a specific device address is expected, then 'da' will
+ * contain it (currently this is the only use case supported). 'len' will
+ * contain the size of the physical region we need to map.
+ *
+ * Currently we just "trust" those devmem entries to contain valid physical
+ * addresses, but this is going to change: we want the implementations to
+ * tell us ranges of physical addresses the firmware is allowed to request,
+ * and not allow firmwares to request access to physical addresses that
+ * are outside those ranges.
+ */
+static int rproc_handle_devmem(struct rproc *rproc, struct fw_resource *rsc)
+{
+	struct rproc_mem_entry *mapping;
+	int ret;
+
+	/* no point in handling this resource without a valid iommu domain */
+	if (!rproc->domain)
+		return -EINVAL;
+
+	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping) {
+		dev_err(rproc->dev, "kzalloc mapping failed\n");
+		return -ENOMEM;
+	}
+
+	ret = iommu_map(rproc->domain, rsc->da, rsc->pa, rsc->len, rsc->flags);
+	if (ret) {
+		dev_err(rproc->dev, "failed to map devmem: %d\n", ret);
+		goto out;
+	}
+
+	/*
+	 * We'll need this info later when we'll want to unmap everything
+	 * (e.g. on shutdown).
+	 *
+	 * We can't trust the remote processor not to change the resource
+	 * table, so we must maintain this info independently.
+	 */
+	mapping->da = rsc->da;
+	mapping->len = rsc->len;
+	list_add_tail(&mapping->node, &rproc->mappings);
+
+	dev_dbg(rproc->dev, "mapped devmem pa 0x%llx, da 0x%llx, len 0x%x\n",
+					rsc->pa, rsc->da, rsc->len);
+
+	return 0;
+
+out:
+	kfree(mapping);
+	return ret;
+}
+
+/**
+ * rproc_handle_carveout() - handle phys contig memory allocation requests
+ * @rproc: rproc handle
+ * @rsc: the resource entry
+ *
+ * This function will handle firmware requests for allocation of physically
+ * contiguous memory regions.
+ *
+ * These request entries should come first in the firmware's resource table,
+ * as other firmware entries might request placing other data objects inside
+ * these memory regions (e.g. data/code segments, trace resource entries, ...).
+ *
+ * Allocating memory this way helps utilizing the reserved physical memory
+ * (e.g. CMA) more efficiently, and also minimizes the number of TLB entries
+ * needed to map it (in case @rproc is using an IOMMU). Reducing the TLB
+ * pressure is important; it may have a substantial impact on performance.
+ */
+static int rproc_handle_carveout(struct rproc *rproc, struct fw_resource *rsc)
+{
+	struct rproc_mem_entry *carveout, *mapping;
+	struct device *dev = rproc->dev;
+	dma_addr_t dma;
+	void *va;
+	int ret;
+
+	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
+	if (!mapping) {
+		dev_err(dev, "kzalloc mapping failed\n");
+		return -ENOMEM;
+	}
+
+	carveout = kzalloc(sizeof(*carveout), GFP_KERNEL);
+	if (!carveout) {
+		dev_err(dev, "kzalloc carveout failed\n");
+		ret = -ENOMEM;
+		goto free_mapping;
+	}
+
+	va = dma_alloc_coherent(dev, rsc->len, &dma, GFP_KERNEL);
+	if (!va) {
+		dev_err(dev, "failed to dma alloc carveout: %d\n", rsc->len);
+		ret = -ENOMEM;
+		goto free_carv;
+	}
+
+	dev_dbg(dev, "carveout va %p, dma %x, len 0x%x\n", va, dma, rsc->len);
+
+	/*
+	 * Ok, this is non-standard.
+	 *
+	 * Sometimes we can't rely on the generic iommu-based DMA API
+	 * to dynamically allocate the device address and then set the IOMMU
+	 * tables accordingly, because some remote processors might
+	 * _require_ us to use hard coded device addresses that their
+	 * firmware was compiled with.
+	 *
+	 * In this case, we must use the IOMMU API directly and map
+	 * the memory to the device address as expected by the remote
+	 * processor.
+	 *
+	 * Obviously such remote processor devices should not be configured
+	 * to use the iommu-based DMA API: we expect 'dma' to contain the
+	 * physical address in this case.
+	 */
+	if (rproc->domain) {
+		ret = iommu_map(rproc->domain, rsc->da, dma, rsc->len,
+								rsc->flags);
+		if (ret) {
+			dev_err(dev, "iommu_map failed: %d\n", ret);
+			goto dma_free;
+		}
+
+		/*
+		 * We'll need this info later when we'll want to unmap
+		 * everything (e.g. on shutdown).
+		 *
+		 * We can't trust the remote processor not to change the
+		 * resource table, so we must maintain this info independently.
+		 */
+		mapping->da = rsc->da;
+		mapping->len = rsc->len;
+		list_add_tail(&mapping->node, &rproc->mappings);
+
+		dev_dbg(dev, "carveout mapped 0x%llx to 0x%x\n", rsc->da, dma);
+
+		/*
+		 * Some remote processors might need to know the pa
+		 * even though they are behind an IOMMU. E.g., OMAP4's
+		 * remote M3 processor needs this so it can control
+		 * on-chip hardware accelerators that are not behind
+		 * the IOMMU, and therefor must know the pa.
+		 *
+		 * Generally we don't want to expose physical addresses
+		 * if we don't have to (remote processors are generally
+		 * _not_ trusted), so we might want to do this only for
+		 * remote processor that _must_ have this (e.g. OMAP4's
+		 * dual M3 subsystem).
+		 */
+		rsc->pa = dma;
+	}
+
+	carveout->va = va;
+	carveout->len = rsc->len;
+	carveout->dma = dma;
+	carveout->da = rsc->da;
+
+	list_add_tail(&carveout->node, &rproc->carveouts);
+
+	return 0;
+
+dma_free:
+	dma_free_coherent(dev, rsc->len, va, dma);
+free_carv:
+	kfree(carveout);
+free_mapping:
+	kfree(mapping);
+	return ret;
+}
+
+/* handle firmware resource entries before booting the remote processor */
+static int
+rproc_handle_boot_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
+{
+	struct device *dev = rproc->dev;
+	int ret = 0;
+
+	while (len >= sizeof(*rsc)) {
+		dev_dbg(dev, "rsc: type %d, da 0x%llx, pa 0x%llx, len 0x%x, "
+			"id %d, name %s, flags %x\n", rsc->type, rsc->da,
+			rsc->pa, rsc->len, rsc->id, rsc->name, rsc->flags);
+
+		switch (rsc->type) {
+		case RSC_CARVEOUT:
+			ret = rproc_handle_carveout(rproc, rsc);
+			break;
+		case RSC_DEVMEM:
+			ret = rproc_handle_devmem(rproc, rsc);
+			break;
+		case RSC_TRACE:
+			ret = rproc_handle_trace(rproc, rsc);
+			break;
+		case RSC_VRING:
+			ret = rproc_handle_vring(rproc, rsc);
+			break;
+		case RSC_VIRTIO_DEV:
+			/* this one is handled early upon registration */
+			break;
+		default:
+			dev_warn(dev, "unsupported resource %d\n", rsc->type);
+			break;
+		}
+
+		if (ret)
+			break;
+
+		rsc++;
+		len -= sizeof(*rsc);
+	}
+
+	return ret;
+}
+
+/* handle firmware resource entries while registering the remote processor */
+static int
+rproc_handle_virtio_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
+{
+	struct device *dev = rproc->dev;
+	int ret = 0;
+
+	for (; len >= sizeof(*rsc); rsc++, len -= sizeof(*rsc))
+		if (rsc->type == RSC_VIRTIO_DEV) {
+			dev_dbg(dev, "found vdev %d/%s features %llx\n",
+					rsc->flags, rsc->name, rsc->da);
+			ret = rproc_handle_virtio_hdr(rproc, rsc);
+			break;
+		}
+
+	return ret;
+}
+
+/**
+ * rproc_handle_resources() - find and handle the resource table
+ * @rproc: the rproc handle
+ * @elf_data: the content of the ELF firmware image
+ * @handler: function that should be used to handle the resource table
+ *
+ * This function finds the resource table inside the remote processor's
+ * firmware, and invoke a user-supplied handler with it (we have two
+ * possible handlers: one is invoked upon registration of @rproc,
+ * in order to register the supported virito devices, and the other is
+ * invoked when @rproc is actually booted).
+ *
+ * Currently this function fails if a resource table doesn't exist.
+ * This restriction will be removed when we'll start supporting remote
+ * processors that don't need a resource table.
+ */
+static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
+					rproc_handle_resources_t handler)
+
+{
+	struct elf32_hdr *ehdr;
+	struct elf32_shdr *shdr;
+	const char *name_table;
+	int i, ret = -EINVAL;
+
+	ehdr = (struct elf32_hdr *)elf_data;
+	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
+	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
+
+	/* look for the resource table and handle it */
+	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
+		if (!strcmp(name_table + shdr->sh_name, ".resource_table")) {
+			struct fw_resource *table = (struct fw_resource *)
+						(elf_data + shdr->sh_offset);
+
+			ret = handler(rproc, table, shdr->sh_size);
+
+			break;
+		}
+	}
+
+	return ret;
+}
+
+/**
+ * rproc_resource_cleanup() - clean up and free all acquired resources
+ * @rproc: rproc handle
+ *
+ * This function will free all resources acquired for @rproc, and it
+ * is called when @rproc shuts down, or just failed booting.
+ */
+static void rproc_resource_cleanup(struct rproc *rproc)
+{
+	struct rproc_mem_entry *entry, *tmp;
+	struct device *dev = rproc->dev;
+	struct rproc_vdev *rvdev = rproc->rvdev;
+	int i;
+
+	/* clean up debugfs trace entries */
+	list_for_each_entry_safe(entry, tmp, &rproc->traces, node) {
+		rproc_remove_trace_file(entry->priv);
+		rproc->num_traces--;
+		list_del(&entry->node);
+		kfree(entry);
+	}
+
+	/* free the coherent memory allocated for the vrings */
+	for (i = 0; rvdev && i < ARRAY_SIZE(rvdev->vring); i++) {
+		int qsz = rvdev->vring[i].len;
+		void *va = rvdev->vring[i].va;
+		int dma = rvdev->vring[i].dma;
+
+		/* virtqueue size is expressed in number of buffers supported */
+		if (qsz) {
+			/* how many bytes does this vring really occupy ? */
+			int size = PAGE_ALIGN(vring_size(qsz, AMP_VRING_ALIGN));
+
+			dma_free_coherent(rproc->dev, size, va, dma);
+
+			rvdev->vring[i].len = 0;
+		}
+	}
+
+	/* clean up carveout allocations */
+	list_for_each_entry_safe(entry, tmp, &rproc->carveouts, node) {
+		dma_free_coherent(dev, entry->len, entry->va, entry->dma);
+		list_del(&entry->node);
+		kfree(entry);
+	}
+
+	/* clean up iommu mapping entries */
+	list_for_each_entry_safe(entry, tmp, &rproc->mappings, node) {
+		size_t unmapped;
+
+		unmapped = iommu_unmap(rproc->domain, entry->da, entry->len);
+		if (unmapped != entry->len) {
+			/* nothing much to do besides complaining */
+			dev_err(dev, "failed to unmap %u/%u\n", entry->len,
+								unmapped);
+		}
+
+		list_del(&entry->node);
+		kfree(entry);
+	}
+}
+
+/* make sure this fw image is sane */
+static int rproc_fw_sanity_check(struct rproc *rproc, const struct firmware *fw)
+{
+	const char *name = rproc->firmware;
+	struct device *dev = rproc->dev;
+	struct elf32_hdr *ehdr;
+
+	if (!fw) {
+		dev_err(dev, "failed to load %s\n", name);
+		return -EINVAL;
+	}
+
+	if (fw->size < sizeof(struct elf32_hdr)) {
+		dev_err(dev, "Image is too small\n");
+		return -EINVAL;
+	}
+
+	ehdr = (struct elf32_hdr *)fw->data;
+
+	if (memcmp(ehdr->e_ident, ELFMAG, SELFMAG)) {
+		dev_err(dev, "Image is corrupted (bad magic)\n");
+		return -EINVAL;
+	}
+
+	if (ehdr->e_phnum == 0) {
+		dev_err(dev, "No loadable segments\n");
+		return -EINVAL;
+	}
+
+	if (ehdr->e_phoff > fw->size) {
+		dev_err(dev, "Firmware size is too small\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/*
+ * take a firmware and boot a remote processor with it.
+ */
+static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
+{
+	struct device *dev = rproc->dev;
+	const char *name = rproc->firmware;
+	struct elf32_hdr *ehdr;
+	int ret;
+
+	ret = rproc_fw_sanity_check(rproc, fw);
+	if (ret)
+		return ret;
+
+	ehdr = (struct elf32_hdr *)fw->data;
+
+	dev_info(dev, "Booting fw image %s, size %d\n", name, fw->size);
+
+	/*
+	 * if enabling an IOMMU isn't relevant for this rproc, this is
+	 * just a nop
+	 */
+	ret = rproc_enable_iommu(rproc);
+	if (ret) {
+		dev_err(dev, "can't enable iommu: %d\n", ret);
+		return ret;
+	}
+
+	/*
+	 * The ELF entry point is the rproc's boot addr (though this is not
+	 * a configurable property of all remote processors: some will always
+	 * boot at a specific hardcoded address).
+	 */
+	rproc->bootaddr = ehdr->e_entry;
+
+	/* handle fw resources which are required to boot rproc */
+	ret = rproc_handle_resources(rproc, fw->data, rproc_handle_boot_rsc);
+	if (ret) {
+		dev_err(dev, "Failed to process resources: %d\n", ret);
+		goto clean_up;
+	}
+
+	/* load the ELF segments to memory */
+	ret = rproc_load_segments(rproc, fw->data);
+	if (ret) {
+		dev_err(dev, "Failed to load program segments: %d\n", ret);
+		goto clean_up;
+	}
+
+	/* power up the remote processor */
+	ret = rproc->ops->start(rproc);
+	if (ret) {
+		dev_err(dev, "can't start rproc %s: %d\n", rproc->name, ret);
+		goto clean_up;
+	}
+
+	rproc->state = RPROC_RUNNING;
+
+	dev_info(dev, "remote processor %s is now up\n", rproc->name);
+
+	return 0;
+
+clean_up:
+	rproc_resource_cleanup(rproc);
+	rproc_disable_iommu(rproc);
+	return ret;
+}
+
+/*
+ * take a firmware and look for virtio devices to register.
+ *
+ * Note: this function is called asynchronously upon registration of the
+ * remote processor (so we must wait until it completes before we try
+ * to unregister the device. one other option is just to use kref here,
+ * that might be cleaner).
+ */
+static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
+{
+	struct rproc *rproc = context;
+	struct device *dev = rproc->dev;
+	int ret;
+
+	if (rproc_fw_sanity_check(rproc, fw) < 0)
+		goto out;
+
+	/* does the fw supports any virtio devices ? */
+	ret = rproc_handle_resources(rproc, fw->data, rproc_handle_virtio_rsc);
+	if (ret) {
+		dev_info(dev, "No fw virtio device was found\n");
+		goto out;
+	}
+
+	/* add the virtio device (currently only rpmsg vdevs are supported) */
+	ret = rproc_add_rpmsg_vdev(rproc);
+	if (ret)
+		goto out;
+
+out:
+	if (fw)
+		release_firmware(fw);
+	/* allow rproc_unregister() contexts, if any, to proceed */
+	complete_all(&rproc->firmware_loading_complete);
+}
+
+/**
+ * rproc_boot() - boot a remote processor
+ * @rproc: handle of a remote processor
+ *
+ * Boot a remote processor (i.e. load its firmware, power it on, ...).
+ *
+ * If the remote processor is already powered on, this function immediately
+ * returns (successfully).
+ *
+ * Returns 0 on success, and an appropriate error value otherwise.
+ */
+int rproc_boot(struct rproc *rproc)
+{
+	const struct firmware *firmware_p;
+	struct device *dev;
+	int ret;
+
+	if (!rproc) {
+		pr_err("invalid rproc handle\n");
+		return -EINVAL;
+	}
+
+	dev = rproc->dev;
+
+	ret = mutex_lock_interruptible(&rproc->lock);
+	if (ret) {
+		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, ret);
+		return ret;
+	}
+
+	/* loading a firmware is required */
+	if (!rproc->firmware) {
+		dev_err(dev, "%s: no firmware to load\n", __func__);
+		ret = -EINVAL;
+		goto unlock_mutex;
+	}
+
+	/* prevent underlying implementation from being removed */
+	if (!try_module_get(dev->driver->owner)) {
+		dev_err(dev, "%s: can't get owner\n", __func__);
+		ret = -EINVAL;
+		goto unlock_mutex;
+	}
+
+	/* skip the boot process if rproc is already powered up */
+	if (atomic_inc_return(&rproc->power) > 1) {
+		ret = 0;
+		goto unlock_mutex;
+	}
+
+	dev_info(dev, "powering up %s\n", rproc->name);
+
+	/* load firmware */
+	ret = request_firmware(&firmware_p, rproc->firmware, dev);
+	if (ret < 0) {
+		dev_err(dev, "request_firmware failed: %d\n", ret);
+		goto downref_rproc;
+	}
+
+	ret = rproc_fw_boot(rproc, firmware_p);
+
+	release_firmware(firmware_p);
+
+downref_rproc:
+	if (ret) {
+		module_put(dev->driver->owner);
+		atomic_dec(&rproc->power);
+	}
+unlock_mutex:
+	mutex_unlock(&rproc->lock);
+	return ret;
+}
+EXPORT_SYMBOL(rproc_boot);
+
+/**
+ * rproc_shutdown() - power off the remote processor
+ * @rproc: the remote processor
+ *
+ * Power off a remote processor (previously booted with rproc_boot()).
+ *
+ * In case @rproc is still being used by an additional user(s), then
+ * this function will just decrement the power refcount and exit,
+ * without really powering off the device.
+ *
+ * Every call to rproc_boot() must (eventually) be accompanied by a call
+ * to rproc_shutdown(). Calling rproc_shutdown() redundantly is a bug.
+ *
+ * Notes:
+ * - we're not decrementing the rproc's refcount, only the power refcount.
+ *   which means that the @rproc handle stays valid even after rproc_shutdown()
+ *   returns, and users can still use it with a subsequent rproc_boot(), if
+ *   needed.
+ * - don't call rproc_shutdown() to unroll rproc_get_by_name(), exactly
+ *   because rproc_shutdown() _does not_ decrement the refcount of @rproc.
+ *   To decrement the refcount of @rproc, use rproc_put() (but _only_ if
+ *   you acquired @rproc using rproc_get_by_name()).
+ */
+void rproc_shutdown(struct rproc *rproc)
+{
+	struct device *dev = rproc->dev;
+	int ret;
+
+	ret = mutex_lock_interruptible(&rproc->lock);
+	if (ret) {
+		dev_err(dev, "can't lock rproc %s: %d\n", rproc->name, ret);
+		return;
+	}
+
+	/* if the remote proc is still needed, bail out */
+	if (!atomic_dec_and_test(&rproc->power))
+		goto out;
+
+	/* power off the remote processor */
+	ret = rproc->ops->stop(rproc);
+	if (ret) {
+		atomic_inc(&rproc->power);
+		dev_err(dev, "can't stop rproc: %d\n", ret);
+		goto out;
+	}
+
+	/* clean up all acquired resources */
+	rproc_resource_cleanup(rproc);
+
+	rproc_disable_iommu(rproc);
+
+	rproc->state = RPROC_OFFLINE;
+
+	dev_info(dev, "stopped remote processor %s\n", rproc->name);
+
+out:
+	mutex_unlock(&rproc->lock);
+	if (!ret)
+		module_put(dev->driver->owner);
+}
+EXPORT_SYMBOL(rproc_shutdown);
+
+/**
+ * rproc_release() - completely deletes the existence of a remote processor
+ * @kref: the rproc's kref
+ *
+ * This function should _never_ be called directly.
+ *
+ * The only reasonable location to use it is as an argument when kref_put'ing
+ * @rproc's refcount.
+ *
+ * This way it will be called when no one holds a valid pointer to this @rproc
+ * anymore (and obviously after it is removed from the rprocs klist).
+ *
+ * Note: this function is not static because rproc_vdev_release() needs it when
+ * it decrements @rproc's refcount.
+ */
+void rproc_release(struct kref *kref)
+{
+	struct rproc *rproc = container_of(kref, struct rproc, refcount);
+
+	dev_info(rproc->dev, "removing %s\n", rproc->name);
+
+	rproc_delete_debug_dir(rproc);
+
+	/* at this point no one holds a reference to rproc anymore */
+	kfree(rproc);
+}
+
+/* will be called when an rproc is added to the rprocs klist */
+static void klist_rproc_get(struct klist_node *n)
+{
+	struct rproc *rproc = container_of(n, struct rproc, node);
+
+	kref_get(&rproc->refcount);
+}
+
+/* will be called when an rproc is removed from the rprocs klist */
+static void klist_rproc_put(struct klist_node *n)
+{
+	struct rproc *rproc = container_of(n, struct rproc, node);
+
+	kref_put(&rproc->refcount, rproc_release);
+}
+
+static struct rproc *next_rproc(struct klist_iter *i)
+{
+	struct klist_node *n;
+
+	n = klist_next(i);
+	if (!n)
+		return NULL;
+
+	return container_of(n, struct rproc, node);
+}
+
+/**
+ * rproc_get_by_name() - find a remote processor by name and boot it
+ * @name: name of the remote processor
+ *
+ * Finds an rproc handle using the remote processor's name, and then
+ * boot it. If it's already powered on, then just immediately return
+ * (successfully).
+ *
+ * Returns the rproc handle on success, and NULL on failure.
+ *
+ * This function increments the remote processor's refcount, so always
+ * use rproc_put() to decrement it back once rproc isn't needed anymore.
+ *
+ * Note: currently this function (and its counterpart rproc_put()) are not
+ * used anymore by the amp sub-system. We need to scrutinize the use cases
+ * that still need them, and see if we can migrate them to use the non
+ * name-based boot/shutdown interface.
+ */
+struct rproc *rproc_get_by_name(const char *name)
+{
+	struct rproc *rproc;
+	struct klist_iter i;
+	int ret;
+
+	/* find the remote processor, and upref its refcount */
+	klist_iter_init(&rprocs, &i);
+	while ((rproc = next_rproc(&i)) != NULL)
+		if (!strcmp(rproc->name, name)) {
+			kref_get(&rproc->refcount);
+			break;
+		}
+	klist_iter_exit(&i);
+
+	/* can't find this rproc ? */
+	if (!rproc) {
+		pr_err("can't find remote processor %s\n", name);
+		return NULL;
+	}
+
+	ret = rproc_boot(rproc);
+	if (ret < 0) {
+		kref_put(&rproc->refcount, rproc_release);
+		return NULL;
+	}
+
+	return rproc;
+}
+EXPORT_SYMBOL(rproc_get_by_name);
+
+/**
+ * rproc_put() - decrement the refcount of a remote processor, and shut it down
+ * @rproc: the remote processor
+ *
+ * This function tries to shutdown @rproc, and it then decrements its
+ * refcount.
+ *
+ * After this function returns, @rproc may _not_ be used anymore, and its
+ * handle should be considered invalid.
+ *
+ * This function should be called _iff_ the @rproc handle was grabbed by
+ * calling rproc_get_by_name().
+ */
+void rproc_put(struct rproc *rproc)
+{
+	/* try to power off the remote processor */
+	rproc_shutdown(rproc);
+
+	/* downref rproc's refcount */
+	kref_put(&rproc->refcount, rproc_release);
+}
+EXPORT_SYMBOL(rproc_put);
+
+/**
+ * rproc_register() - register a remote processor
+ * @rproc: the remote processor handle to register
+ *
+ * Registers @rproc with the remoteproc framework, after it has been
+ * allocated with rproc_alloc().
+ *
+ * This is called by the platform-specific rproc implementation, whenever
+ * a new remote processor device is probed.
+ *
+ * Returns 0 on success and an appropriate error code otherwise.
+ *
+ * Note: this function initiates an asynchronous firmware loading
+ * context, which will look for virtio devices supported by the rproc's
+ * firmware.
+ *
+ * If found, those virtio devices will be created and added, so as a result
+ * of registering this remote processor, additional virtio drivers will be
+ * probed.
+ *
+ * Currently, though, we only support a single RPMSG virtio vdev per remote
+ * processor.
+ */
+int rproc_register(struct rproc *rproc)
+{
+	struct device *dev = rproc->dev;
+	int ret = 0;
+
+	/* expose to rproc_get_by_name users */
+	klist_add_tail(&rproc->node, &rprocs);
+
+	dev_info(rproc->dev, "%s is available\n", rproc->name);
+
+	/* create debugfs entries */
+	rproc_create_debug_dir(rproc);
+
+	/* rproc_unregister() calls must wait until async loader completes */
+	init_completion(&rproc->firmware_loading_complete);
+
+	/*
+	 * We must retrieve early virtio configuration info from
+	 * the firmware (e.g. whether to register a virtio rpmsg device,
+	 * what virtio features does it support, ...).
+	 *
+	 * We're initiating an asynchronous firmware loading, so we can
+	 * be built-in kernel code, without hanging the boot process.
+	 */
+	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_HOTPLUG,
+					rproc->firmware, dev, GFP_KERNEL,
+					rproc, rproc_fw_config_virtio);
+	if (ret < 0) {
+		dev_err(dev, "request_firmware_nowait failed: %d\n", ret);
+		complete_all(&rproc->firmware_loading_complete);
+		klist_remove(&rproc->node);
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL(rproc_register);
+
+/**
+ * rproc_alloc() - allocate a remote processor handle
+ * @dev: the underlying device
+ * @name: name of this remote processor
+ * @ops: platform-specific handlers (mainly start/stop)
+ * @firmware: name of firmware file to load
+ * @len: length of private data needed by the rproc driver (in bytes)
+ *
+ * Allocates a new remote processor handle, but does not register
+ * it yet.
+ *
+ * This function should be used by rproc implementations during initialization
+ * of the remote processor.
+ *
+ * After creating an rproc handle using this function, and when ready,
+ * implementations should then call rproc_register() to complete
+ * the registration of the remote processor.
+ *
+ * On success the new rproc is returned, and on failure, NULL.
+ *
+ * Note: _never_ directly deallocate @rproc, even if it was not registered
+ * yet. Instead, if you just need to unroll rproc_alloc(), use rproc_free().
+ */
+struct rproc *rproc_alloc(struct device *dev, const char *name,
+				const struct rproc_ops *ops,
+				const char *firmware, int len)
+{
+	struct rproc *rproc;
+
+	if (!dev || !name || !ops)
+		return NULL;
+
+	rproc = kzalloc(sizeof(struct rproc) + len, GFP_KERNEL);
+	if (!rproc) {
+		dev_err(dev, "%s: kzalloc failed\n", __func__);
+		return NULL;
+	}
+
+	rproc->dev = dev;
+	rproc->name = name;
+	rproc->ops = ops;
+	rproc->firmware = firmware;
+	rproc->priv = &rproc[1];
+
+	atomic_set(&rproc->power, 0);
+
+	kref_init(&rproc->refcount);
+
+	mutex_init(&rproc->lock);
+
+	INIT_LIST_HEAD(&rproc->carveouts);
+	INIT_LIST_HEAD(&rproc->mappings);
+	INIT_LIST_HEAD(&rproc->traces);
+
+	rproc->state = RPROC_OFFLINE;
+
+	return rproc;
+}
+EXPORT_SYMBOL(rproc_alloc);
+
+/**
+ * rproc_free() - free an rproc handle that was allocated by rproc_alloc
+ * @rproc: the remote processor handle
+ *
+ * This function should _only_ be used if @rproc was only allocated,
+ * but not registered yet.
+ *
+ * If @rproc was already successfully registered (by calling rproc_register()),
+ * then use rproc_unregister() instead.
+ */
+void rproc_free(struct rproc *rproc)
+{
+	kfree(rproc);
+}
+EXPORT_SYMBOL(rproc_free);
+
+/**
+ * rproc_unregister() - unregister a remote processor
+ * @rproc: rproc handle to unregister
+ *
+ * Unregisters a remote processor, and decrements its refcount.
+ * If its refcount drops to zero, then @rproc will be freed. If not,
+ * it will be freed later once the last reference is dropped.
+ *
+ * This function should be called when the platform specific rproc
+ * implementation decides to remove the rproc device. it should
+ * _only_ be called if a previous invocation of rproc_register()
+ * has completed successfully.
+ *
+ * After rproc_unregister() returns, @rproc is _not_ valid anymore and
+ * it shouldn't be used. More specifically, don't call rproc_free()
+ * or try to directly free @rproc after rproc_unregister() returns;
+ * none of these are needed, and calling them is a bug.
+ *
+ * Returns 0 on success and -EINVAL if @rproc isn't valid.
+ */
+int rproc_unregister(struct rproc *rproc)
+{
+	if (!rproc)
+		return -EINVAL;
+
+	/* if rproc is just being registered, wait */
+	wait_for_completion(&rproc->firmware_loading_complete);
+
+	/* was an rpmsg vdev created ? */
+	if (rproc->rvdev)
+		rproc_remove_rpmsg_vdev(rproc);
+
+	klist_remove(&rproc->node);
+
+	kref_put(&rproc->refcount, rproc_release);
+
+	return 0;
+}
+EXPORT_SYMBOL(rproc_unregister);
+
+static int __init remoteproc_init(void)
+{
+	rproc_init_debugfs();
+	return 0;
+}
+module_init(remoteproc_init);
+
+static void __exit remoteproc_exit(void)
+{
+	rproc_exit_debugfs();
+}
+module_exit(remoteproc_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("Generic Remote Processor Framework");
diff --git a/drivers/amp/remoteproc/remoteproc_internal.h b/drivers/amp/remoteproc/remoteproc_internal.h
new file mode 100644
index 0000000..8b2fc40
--- /dev/null
+++ b/drivers/amp/remoteproc/remoteproc_internal.h
@@ -0,0 +1,44 @@
+/*
+ * Remote processor framework
+ *
+ * Copyright (C) 2011 Texas Instruments, Inc.
+ * Copyright (C) 2011 Google, Inc.
+ *
+ * Ohad Ben-Cohen <ohad@wizery.com>
+ * Brian Swetland <swetland@google.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#ifndef REMOTEPROC_INTERNAL_H
+#define REMOTEPROC_INTERNAL_H
+
+#include <linux/irqreturn.h>
+
+struct rproc;
+
+/* from remoteproc_core.c */
+void rproc_release(struct kref *kref);
+irqreturn_t rproc_vq_interrupt(struct rproc *rproc, int vq_id);
+
+/* from remoteproc_rpmsg.c */
+int rproc_add_rpmsg_vdev(struct rproc *);
+void rproc_remove_rpmsg_vdev(struct rproc *rproc);
+
+/* from remoteproc_debugfs.c */
+void rproc_remove_trace_file(struct dentry *tfile);
+struct dentry *rproc_create_trace_file(const char *name, struct rproc *rproc,
+					struct rproc_mem_entry *trace);
+void rproc_delete_debug_dir(struct rproc *rproc);
+void rproc_create_debug_dir(struct rproc *rproc);
+void rproc_init_debugfs(void);
+void rproc_exit_debugfs(void);
+
+#endif /* REMOTEPROC_INTERNAL_H */
diff --git a/include/linux/amp/remoteproc.h b/include/linux/amp/remoteproc.h
new file mode 100644
index 0000000..1edbfde
--- /dev/null
+++ b/include/linux/amp/remoteproc.h
@@ -0,0 +1,265 @@
+/*
+ * Remote Processor Framework
+ *
+ * Copyright(c) 2011 Texas Instruments, Inc.
+ * Copyright(c) 2011 Google, Inc.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ * * Redistributions of source code must retain the above copyright
+ *   notice, this list of conditions and the following disclaimer.
+ * * Redistributions in binary form must reproduce the above copyright
+ *   notice, this list of conditions and the following disclaimer in
+ *   the documentation and/or other materials provided with the
+ *   distribution.
+ * * Neither the name Texas Instruments nor the names of its
+ *   contributors may be used to endorse or promote products derived
+ *   from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef REMOTEPROC_H
+#define REMOTEPROC_H
+
+#include <linux/types.h>
+#include <linux/kref.h>
+#include <linux/klist.h>
+#include <linux/mutex.h>
+#include <linux/virtio.h>
+#include <linux/completion.h>
+
+/*
+ * The alignment between the consumer and producer parts of the vring.
+ * Note: this is part of the "wire" protocol. If you change this, you need
+ * to update your peers too.
+ */
+#define AMP_VRING_ALIGN	(4096)
+
+/**
+ * struct fw_resource - describes an entry from the resource section
+ * @type: resource type
+ * @id: index number of the resource
+ * @da: device address of the resource
+ * @pa: physical address of the resource
+ * @len: size, in bytes, of the resource
+ * @flags: properties of the resource, e.g. iommu protection required
+ * @reserved: must be 0 atm
+ * @name: name of resource
+ *
+ * The remote processor firmware should contain a "resource table":
+ * array of 'struct fw_resource' entries.
+ *
+ * Some resources entries are mere announcements, where the host is informed
+ * of specific remoteproc configuration. Other entries require the host to
+ * do something (e.g. reserve a requested resource) and possibly also reply
+ * by overwriting a member inside 'struct fw_resource' with info about the
+ * allocated resource.
+ *
+ * Different resource entries use different members of this struct,
+ * with different meanings. This is pretty limiting and error-prone,
+ * so the plan is to move to variable-length TLV-based resource entries,
+ * where each resource type will have its own structure.
+ */
+struct fw_resource {
+	u32 type;
+	u32 id;
+	u64 da;
+	u64 pa;
+	u32 len;
+	u32 flags;
+	u8 reserved[16];
+	u8 name[48];
+} __packed;
+
+/**
+ * enum fw_resource_type - types of resource entries
+ *
+ * @RSC_CARVEOUT:   request for allocation of a physically contiguous
+ *		    memory region.
+ * @RSC_DEVMEM:     request to iommu_map a memory-based peripheral.
+ * @RSC_TRACE:	    announces the availability of a trace buffer into which
+ *		    the remote processor will be writing logs. In this case,
+ *		    'da' indicates the device address where logs are written to,
+ *		    and 'len' is the size of the trace buffer.
+ * @RSC_VRING:	    request for allocation of a virtio vring (address should
+ *		    be indicated in 'da', and 'len' should contain the number
+ *		    of buffers supported by the vring).
+ * @RSC_VIRTIO_DEV: this entry declares about support for a virtio device,
+ *		    and serves as the virtio header. 'da' holds the
+ *		    the virtio device features, 'pa' holds the virtio guest
+ *		    features, 'len' holds the virtio status, and 'flags' holds
+ *		    the virtio id (currently only VIRTIO_ID_RPMSG is supported).
+ *
+ * Most of the resource entries share the basic idea of address/length
+ * negotiation with the host: the firmware usually asks (on behalf of the
+ * remote processor that will soon be booted with it) for memory
+ * of size 'len' bytes, and the host needs to allocate it and provide
+ * the device/physical address (when relevant) in 'da'/'pa' respectively.
+ *
+ * If the firmware is compiled with hard coded device addresses, and
+ * can't handle dynamically allocated 'da' values, then the 'da' field
+ * will contain the expected device addresses (today we actually only support
+ * this scheme, as there aren't yet any use cases for dynamically allocated
+ * device addresses).
+ */
+enum fw_resource_type {
+	RSC_CARVEOUT	= 0,
+	RSC_DEVMEM	= 1,
+	RSC_TRACE	= 2,
+	RSC_VRING	= 3,
+	RSC_VIRTIO_DEV	= 4,
+	RSC_VIRTIO_CFG	= 5,
+};
+
+/**
+ * struct rproc_mem_entry - memory entry descriptor
+ * @va:	virtual address
+ * @dma: dma address
+ * @len: length, in bytes
+ * @da: device address
+ * @priv: associated data
+ * @node: list node
+ */
+struct rproc_mem_entry {
+	void *va;
+	dma_addr_t dma;
+	int len;
+	u64 da;
+	void *priv;
+	struct list_head node;
+};
+
+struct rproc;
+
+/**
+ * struct rproc_ops - platform-specific device handlers
+ * @start:	power on the device and boot it
+ * @stop:	power off the device
+ * @kick:	kick a virtqueue (virtqueue id given as a parameter)
+ */
+struct rproc_ops {
+	int (*start)(struct rproc *rproc);
+	int (*stop)(struct rproc *rproc);
+	void (*kick)(struct rproc *rproc, int vqid);
+};
+
+/**
+ * enum rproc_state - remote processor states
+ * @RPROC_OFFLINE:	device is powered off
+ * @RPROC_SUSPENDED:	device is suspended; needs to be woken up to receive
+ *			a message.
+ * @RPROC_RUNNING:	device is up and running
+ * @RPROC_CRASHED:	device has crashed; need to start recovery
+ * @RPROC_LAST:		just keep this one at the end
+ *
+ * Please note that the values of these states are used as indices
+ * to rproc_state_string, a state-to-name lookup table,
+ * so please keep the two synchronized. @RPROC_LAST is used to check
+ * the validity of an index before the lookup table is accessed, so
+ * please update it as needed too.
+ */
+enum rproc_state {
+	RPROC_OFFLINE	= 0,
+	RPROC_SUSPENDED	= 1,
+	RPROC_RUNNING	= 2,
+	RPROC_CRASHED	= 3,
+	RPROC_LAST	= 4,
+};
+
+/**
+ * struct rproc - represents a physical remote processor device
+ * @node: klist node of this rproc object
+ * @domain: iommu domain
+ * @name: human readable name of the rproc
+ * @firmware: name of firmware file to be loaded
+ * @priv: private data which belongs to the platform-specific rproc module
+ * @ops: platform-specific start/stop rproc handlers
+ * @dev: underlying device
+ * @refcount: refcount of users that have a valid pointer to this rproc
+ * @power: refcount of users who need this rproc powered up
+ * @state: state of the device
+ * @lock: lock which protects concurrent manipulations of the rproc
+ * @dbg_dir: debugfs directory of this rproc device
+ * @traces: list of trace buffers
+ * @num_traces: number of trace buffers
+ * @carveouts: list of physically contiguous memory allocations
+ * @mappings: list of iommu mappings we initiated, needed on shutdown
+ * @firmware_loading_complete: marks e/o asynchronous firmware loading
+ * @bootaddr: address of first instruction to boot rproc with (optional)
+ * @rvdev: virtio device (we only support a single rpmsg virtio device for now)
+ */
+struct rproc {
+	struct klist_node node;
+	struct iommu_domain *domain;
+	const char *name;
+	const char *firmware;
+	void *priv;
+	const struct rproc_ops *ops;
+	struct device *dev;
+	struct kref refcount;
+	atomic_t power;
+	unsigned int state;
+	struct mutex lock;
+	struct dentry *dbg_dir;
+	struct list_head traces;
+	int num_traces;
+	struct list_head carveouts;
+	struct list_head mappings;
+	struct completion firmware_loading_complete;
+	u64 bootaddr;
+	struct rproc_vdev *rvdev;
+};
+
+/**
+ * struct rproc_vdev - remoteproc state for a supported virtio device
+ * @rproc: the rproc handle
+ * @vdev: the virio device
+ * @vq: the virtqueues for this vdev
+ * @vring: the vrings for this vdev
+ * @dfeatures: virtio device features
+ * @gfeatures: virtio guest features
+ */
+struct rproc_vdev {
+	struct rproc *rproc;
+	struct virtio_device vdev;
+	struct virtqueue *vq[2];
+	struct rproc_mem_entry vring[2];
+	unsigned long dfeatures;
+	unsigned long gfeatures;
+};
+
+struct rproc *rproc_get_by_name(const char *name);
+void rproc_put(struct rproc *rproc);
+
+struct rproc *rproc_alloc(struct device *dev, const char *name,
+				const struct rproc_ops *ops,
+				const char *firmware, int len);
+void rproc_free(struct rproc *rproc);
+int rproc_register(struct rproc *rproc);
+int rproc_unregister(struct rproc *rproc);
+
+int rproc_boot(struct rproc *rproc);
+void rproc_shutdown(struct rproc *rproc);
+
+static inline struct rproc *vdev_to_rproc(struct virtio_device *vdev)
+{
+	struct rproc_vdev *rvdev = container_of(vdev, struct rproc_vdev, vdev);
+
+	return rvdev->rproc;
+}
+
+#endif /* REMOTEPROC_H */
-- 
1.7.5.4

