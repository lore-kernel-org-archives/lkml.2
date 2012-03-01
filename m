Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab2CAIMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 03:12:32 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49993 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757247Ab2CAIM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 03:12:26 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of ohad@wizery.com designates 10.216.137.219 as permitted sender) smtp.mail=ohad@wizery.com
MIME-Version: 1.0
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Brian Swetland <swetland@google.com>,
        Iliyan Malchev <malchev@google.com>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>, Mark Grosen <mgrosen@ti.com>,
        John Williams <john.williams@petalogix.com>,
        Michal Simek <monstr@monstr.eu>,
        Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Guzman Lugo Fernando <fernando.lugo@ti.com>,
        Anna Suman <s-anna@ti.com>, Clark Rob <rob@ti.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brown <davidb@codeaurora.org>,
        Kieran Bingham <kieranbingham@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 1/7] remoteproc: resource table overhaul
Date: Thu,  1 Mar 2012 10:11:31 +0200
Message-Id: <1330589497-4139-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1330589497-4139-1-git-send-email-ohad@wizery.com>
References: <1330589497-4139-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resource table is an array of 'struct fw_resource' members, where
each resource entry is expressed as a single member of that array.

This approach got us this far, but it has a few drawbacks:

1. Different resource entries end up overloading the same members of 'struct
   fw_resource' with different meanings. The resulting code is error prone
   and hard to read and maintain.

2. It's impossible to extend 'struct fw_resource' without breaking the
   existing firmware images (and we already want to: we can't introduce the
   new virito device resource entry with the current scheme).

3. It doesn't scale: 'struct fw_resource' must be as big as the largest
   resource entry type. As a result, smaller resource entries end up
   utilizing only small part of it.

This is fixed by defining a dedicated structure for every resource type,
and then converting the resource table to a list of type-value members.
Instead of a rigid array of homogeneous structs, the resource table
is turned into a collection of heterogeneous structures.

This way:
1. Resource entries consume exactly the amount of bytes they need.
2. It's easy to extend: just create a new resource entry structure, and assign
   it a new type.
3. The code is easier to read and maintain: the structures' members names are
   meaningful.

While we're at it, this patch has several other resource table changes:
1. The resource table gains a simple header which contains the
   number of entries in the table and their offsets within the table. This
   makes the parsing code simpler and easier to read.
2. A version member is added to the resource table. Should we change the
   format again, we'll bump up this version to prevent breakage with
   existing firmware images.
3. The VRING and VIRTIO_DEV resource entries are combined to a single
   VDEV entry. This paves the way to supporting multiple VDEV entries.
4. Since we don't really support 64-bit rprocs yet, convert two stray u64
   members to u32.

Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Brian Swetland <swetland@google.com>
Cc: Iliyan Malchev <malchev@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Mark Grosen <mgrosen@ti.com>
Cc: John Williams <john.williams@petalogix.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>
Cc: Ludovic BARRE <ludovic.barre@stericsson.com>
Cc: Omar Ramirez Luna <omar.luna@linaro.org>
Cc: Guzman Lugo Fernando <fernando.lugo@ti.com>
Cc: Anna Suman <s-anna@ti.com>
Cc: Clark Rob <rob@ti.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>
Cc: Saravana Kannan <skannan@codeaurora.org>
Cc: David Brown <davidb@codeaurora.org>
Cc: Kieran Bingham <kieranbingham@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>
---
 Documentation/remoteproc.txt         |  127 +++++++--------
 drivers/remoteproc/remoteproc_core.c |  306 +++++++++++++++++++++++-----------
 include/linux/remoteproc.h           |  289 ++++++++++++++++++++++++++------
 3 files changed, 505 insertions(+), 217 deletions(-)

diff --git a/Documentation/remoteproc.txt b/Documentation/remoteproc.txt
index 23ff734..07057ca 100644
--- a/Documentation/remoteproc.txt
+++ b/Documentation/remoteproc.txt
@@ -221,43 +221,52 @@ resource entries that publish the existence of supported features
 or configurations by the remote processor, such as trace buffers and
 supported virtio devices (and their configurations).
 
-Currently the resource table is just an array of:
+The resource table begins with this header:
 
 /**
- * struct fw_resource - describes an entry from the resource section
+ * struct resource_table - firmware resource table header
+ * @ver: version number
+ * @num: number of resource entries
+ * @reserved: reserved (must be zero)
+ * @offset: array of offsets pointing at the various resource entries
+ *
+ * The header of the resource table, as expressed by this structure,
+ * contains a version number (should we need to change this format in the
+ * future), the number of available resource entries, and their offsets
+ * in the table.
+ */
+struct resource_table {
+	u32 ver;
+	u32 num;
+	u32 reserved[2];
+	u32 offset[0];
+} __packed;
+
+Immediately following this header are the resource entries themselves,
+each of which begins with the following resource entry header:
+
+/**
+ * struct fw_rsc_hdr - firmware resource entry header
  * @type: resource type
- * @id: index number of the resource
- * @da: device address of the resource
- * @pa: physical address of the resource
- * @len: size, in bytes, of the resource
- * @flags: properties of the resource, e.g. iommu protection required
- * @reserved: must be 0 atm
- * @name: name of resource
+ * @data: resource data
+ *
+ * Every resource entry begins with a 'struct fw_rsc_hdr' header providing
+ * its @type. The content of the entry itself will immediately follow
+ * this header, and it should be parsed according to the resource type.
  */
-struct fw_resource {
+struct fw_rsc_hdr {
 	u32 type;
-	u32 id;
-	u64 da;
-	u64 pa;
-	u32 len;
-	u32 flags;
-	u8 reserved[16];
-	u8 name[48];
+	u8 data[0];
 } __packed;
 
 Some resources entries are mere announcements, where the host is informed
 of specific remoteproc configuration. Other entries require the host to
-do something (e.g. reserve a requested resource) and possibly also reply
-by overwriting a member inside 'struct fw_resource' with info about the
-allocated resource.
-
-Different resource entries use different members of this struct,
-with different meanings. This is pretty limiting and error-prone,
-so the plan is to move to variable-length TLV-based resource entries,
-where each resource will begin with a type and length fields, followed by
-its own specific structure.
+do something (e.g. allocate a system resource). Sometimes a negotiation
+is expected, where the firmware requests a resource, and once allocated,
+the host should provide back its details (e.g. address of an allocated
+memory region).
 
-Here are the resource types that are currently being used:
+Here are the various resource types that are currently supported:
 
 /**
  * enum fw_resource_type - types of resource entries
@@ -266,59 +275,45 @@ Here are the resource types that are currently being used:
  *		    memory region.
  * @RSC_DEVMEM:     request to iommu_map a memory-based peripheral.
  * @RSC_TRACE:	    announces the availability of a trace buffer into which
- *		    the remote processor will be writing logs. In this case,
- *		    'da' indicates the device address where logs are written to,
- *		    and 'len' is the size of the trace buffer.
- * @RSC_VRING:	    request for allocation of a virtio vring (address should
- *		    be indicated in 'da', and 'len' should contain the number
- *		    of buffers supported by the vring).
- * @RSC_VIRTIO_DEV: announces support for a virtio device, and serves as
- *		    the virtio header. 'da' contains the virtio device
- *		    features, 'pa' holds the virtio guest features (host
- *		    will write them here after they're negotiated), 'len'
- *		    holds the virtio status, and 'flags' holds the virtio
- *		    device id (currently only VIRTIO_ID_RPMSG is supported).
+ *		    the remote processor will be writing logs.
+ * @RSC_VDEV:       declare support for a virtio device, and serve as its
+ *		    virtio header.
+ * @RSC_LAST:       just keep this one at the end
+ *
+ * Please note that these values are used as indices to the rproc_handle_rsc
+ * lookup table, so please keep them sane. Moreover, @RSC_LAST is used to
+ * check the validity of an index before the lookup table is accessed, so
+ * please update it as needed.
  */
 enum fw_resource_type {
 	RSC_CARVEOUT	= 0,
 	RSC_DEVMEM	= 1,
 	RSC_TRACE	= 2,
-	RSC_VRING	= 3,
-	RSC_VIRTIO_DEV	= 4,
-	RSC_VIRTIO_CFG	= 5,
+	RSC_VDEV	= 3,
+	RSC_LAST	= 4,
 };
 
-Most of the resource entries share the basic idea of address/length
-negotiation with the host: the firmware usually asks for memory
-of size 'len' bytes, and the host needs to allocate it and provide
-the device/physical address (when relevant) in 'da'/'pa' respectively.
-
-If the firmware is compiled with hard coded device addresses, and
-can't handle dynamically allocated 'da' values, then the 'da' field
-will contain the expected device addresses (today we actually only support
-this scheme, as there aren't yet any use cases for dynamically allocated
-device addresses).
+For more details regarding a specific resource type, please see its
+dedicated structure in include/linux/remoteproc.h.
 
 We also expect that platform-specific resource entries will show up
-at some point. When that happens, we could easily add a new RSC_PLAFORM
+at some point. When that happens, we could easily add a new RSC_PLATFORM
 type, and hand those resources to the platform-specific rproc driver to handle.
 
 7. Virtio and remoteproc
 
 The firmware should provide remoteproc information about virtio devices
-that it supports, and their configurations: a RSC_VIRTIO_DEV resource entry
-should specify the virtio device id, and subsequent RSC_VRING resource entries
-should indicate the vring size (i.e. how many buffers do they support) and
-where should they be mapped (i.e. which device address). Note: the alignment
-between the consumer and producer parts of the vring is assumed to be 4096.
-
-At this point we only support a single virtio rpmsg device per remote
-processor, but the plan is to remove this limitation. In addition, once we
-move to TLV-based resource table, the plan is to have a single RSC_VIRTIO
-entry per supported virtio device, which will include the virtio header,
-the vrings information and the virtio config space.
-
-Of course, RSC_VIRTIO resource entries are only good enough for static
+that it supports, and their configurations: a RSC_VDEV resource entry
+should specify the virtio device id (as in virtio_ids.h), virtio features,
+virtio config space, vrings information, etc.
+
+When a new remote processor is registered, the remoteproc framework
+will look for its resource table and will register the virtio devices
+it supports. A firmware may support any number of virtio devices, and
+of any type (a single remote processor can also easily support several
+rpmsg virtio devices this way, if desired).
+
+Of course, RSC_VDEV resource entries are only good enough for static
 allocation of virtio devices. Dynamic allocations will also be made possible
 using the rpmsg bus (similar to how we already do dynamic allocations of
 rpmsg channels; read more about it in rpmsg.txt).
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index 8990c51..1034845 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -63,9 +63,8 @@ static void klist_rproc_put(struct klist_node *n);
 static DEFINE_KLIST(rprocs, klist_rproc_get, klist_rproc_put);
 
 typedef int (*rproc_handle_resources_t)(struct rproc *rproc,
-				struct fw_resource *rsc, int len);
-typedef int (*rproc_handle_resource_t)(struct rproc *rproc,
-				struct fw_resource *rsc);
+				struct resource_table *table, int len);
+typedef int (*rproc_handle_resource_t)(struct rproc *rproc, void *, int avail);
 
 /*
  * This is the IOMMU fault handler we register with the IOMMU API
@@ -281,9 +280,10 @@ rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
 }
 
 /**
- * rproc_handle_virtio_hdr() - handle a virtio header resource
+ * rproc_handle_early_vdev() - early handle a virtio header resource
  * @rproc: the remote processor
  * @rsc: the resource descriptor
+ * @avail: size of available data (for sanity checking the image)
  *
  * The existence of this virtio hdr resource entry means that the firmware
  * of this @rproc supports this virtio device.
@@ -291,37 +291,32 @@ rproc_load_segments(struct rproc *rproc, const u8 *elf_data, size_t len)
  * Currently we support only a single virtio device of type VIRTIO_ID_RPMSG,
  * but the plan is to remove this limitation and support any number
  * of virtio devices (and of any type). We'll also add support for dynamically
- * adding (and removing) virtio devices over the rpmsg bus, but small
+ * adding (and removing) virtio devices over the rpmsg bus, but simple
  * firmwares that doesn't want to get involved with rpmsg will be able
- * to simple use the resource table for this.
- *
- * At this point this virtio header entry is rather simple: it just
- * announces the virtio device id and the supported virtio device features.
- * The plan though is to extend this to include the vring information and
- * the virtio config space, too (but first, some resource table overhaul
- * is needed: move from fixed-sized to variable-length TLV entries).
- *
- * For now, the 'flags' member of the resource entry contains the virtio
- * device id, the 'da' member contains the device features, and 'pa' is
- * where we need to store the guest features once negotiation completes.
- * As usual, the 'id' member of this resource contains the index of this
- * resource type (i.e. is this the first virtio hdr entry, the 2nd, ...).
+ * to simply use the resource table for this.
  *
  * Returns 0 on success, or an appropriate error code otherwise
  */
-static int rproc_handle_virtio_hdr(struct rproc *rproc, struct fw_resource *rsc)
+static int rproc_handle_early_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
+								int avail)
 {
 	struct rproc_vdev *rvdev;
 
+	/* make sure resource isn't truncated */
+	if (sizeof(*rsc) > avail) {
+		dev_err(rproc->dev, "vdev rsc is truncated\n");
+		return -EINVAL;
+	}
+
 	/* we only support VIRTIO_ID_RPMSG devices for now */
-	if (rsc->flags != VIRTIO_ID_RPMSG) {
-		dev_warn(rproc->dev, "unsupported vdev: %d\n", rsc->flags);
+	if (rsc->id != VIRTIO_ID_RPMSG) {
+		dev_warn(rproc->dev, "unsupported vdev: %d\n", rsc->id);
 		return -EINVAL;
 	}
 
 	/* we only support a single vdev per rproc for now */
-	if (rsc->id || rproc->rvdev) {
-		dev_warn(rproc->dev, "redundant vdev entry: %s\n", rsc->name);
+	if (rproc->rvdev) {
+		dev_warn(rproc->dev, "redundant vdev entry\n");
 		return -EINVAL;
 	}
 
@@ -330,7 +325,7 @@ static int rproc_handle_virtio_hdr(struct rproc *rproc, struct fw_resource *rsc)
 		return -ENOMEM;
 
 	/* remember the device features */
-	rvdev->dfeatures = rsc->da;
+	rvdev->dfeatures = rsc->dfeatures;
 
 	rproc->rvdev = rvdev;
 	rvdev->rproc = rproc;
@@ -339,9 +334,10 @@ static int rproc_handle_virtio_hdr(struct rproc *rproc, struct fw_resource *rsc)
 }
 
 /**
- * rproc_handle_vring() - handle a vring fw resource
+ * rproc_handle_vdev() - handle a vdev fw resource
  * @rproc: the remote processor
  * @rsc: the vring resource descriptor
+ * @avail: size of available data (for sanity checking the image)
  *
  * This resource entry requires allocation of non-cacheable memory
  * for a virtio vring. Currently we only support two vrings per remote
@@ -360,57 +356,82 @@ static int rproc_handle_virtio_hdr(struct rproc *rproc, struct fw_resource *rsc)
  *
  * Returns 0 on success, or an appropriate error code otherwise
  */
-static int rproc_handle_vring(struct rproc *rproc, struct fw_resource *rsc)
+static int rproc_handle_vdev(struct rproc *rproc, struct fw_rsc_vdev *rsc,
+								int avail)
 {
 	struct device *dev = rproc->dev;
 	struct rproc_vdev *rvdev = rproc->rvdev;
-	dma_addr_t dma;
-	int size, id = rsc->id;
-	void *va;
+	int i;
 
-	/* no vdev is in place ? */
-	if (!rvdev) {
-		dev_err(dev, "vring requested without a virtio dev entry\n");
+	/* make sure resource isn't truncated */
+	if (sizeof(*rsc) + rsc->num_of_vrings * sizeof(struct fw_rsc_vdev_vring)
+			+ rsc->config_len > avail) {
+		dev_err(rproc->dev, "vdev rsc is truncated\n");
 		return -EINVAL;
 	}
 
-	/* the firmware must provide the expected queue size */
-	if (!rsc->len) {
-		dev_err(dev, "missing expected queue size\n");
+	/* make sure reserved bytes are zeroes */
+	if (rsc->reserved[0] || rsc->reserved[1]) {
+		dev_err(dev, "vdev rsc has non zero reserved bytes\n");
 		return -EINVAL;
 	}
 
-	/* we currently support two vrings per rproc (for rx and tx) */
-	if (id >= ARRAY_SIZE(rvdev->vring)) {
-		dev_err(dev, "%s: invalid vring id %d\n", rsc->name, id);
+	dev_dbg(dev, "vdev rsc: id %d, dfeatures %x, cfg len %d, %d vrings\n",
+		rsc->id, rsc->dfeatures, rsc->config_len, rsc->num_of_vrings);
+
+	/* no vdev is in place ? */
+	if (!rvdev) {
+		dev_err(dev, "vring requested without a virtio dev entry\n");
 		return -EINVAL;
 	}
 
-	/* have we already allocated this vring id ? */
-	if (rvdev->vring[id].len) {
-		dev_err(dev, "%s: duplicated id %d\n", rsc->name, id);
+	/* we currently support two vrings per rproc (for rx and tx) */
+	if (rsc->num_of_vrings != ARRAY_SIZE(rvdev->vring)) {
+		dev_err(dev, "too many vrings: %d\n", rsc->num_of_vrings);
 		return -EINVAL;
 	}
 
-	/* actual size of vring (in bytes) */
-	size = PAGE_ALIGN(vring_size(rsc->len, AMP_VRING_ALIGN));
+	/* initialize the vrings */
+	for (i = 0; i < rsc->num_of_vrings; i++) {
+		struct fw_rsc_vdev_vring *vring = &rsc->vring[i];
+		dma_addr_t dma;
+		int size;
+		void *va;
+
+		/* make sure reserved bytes are zeroes */
+		if (vring->reserved) {
+			dev_err(dev, "vring rsc has non zero reserved bytes\n");
+			return -EINVAL;
+		}
 
-	/*
-	 * Allocate non-cacheable memory for the vring. In the future
-	 * this call will also configure the IOMMU for us
-	 */
-	va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
-	if (!va) {
-		dev_err(dev, "dma_alloc_coherent failed\n");
-		return -ENOMEM;
-	}
+		/* the firmware must provide the expected queue size */
+		if (!vring->num) {
+			dev_err(dev, "missing expected queue size\n");
+			/* potential cleanups are taken care of later on */
+			return -EINVAL;
+		}
 
-	dev_dbg(dev, "vring%d: va %p dma %x qsz %d ring size %x\n", id, va,
-					dma, rsc->len, size);
+		/* actual size of vring (in bytes) */
+		size = PAGE_ALIGN(vring_size(vring->num, AMP_VRING_ALIGN));
 
-	rvdev->vring[id].len = rsc->len;
-	rvdev->vring[id].va = va;
-	rvdev->vring[id].dma = dma;
+		/*
+		 * Allocate non-cacheable memory for the vring. In the future
+		 * this call will also configure the IOMMU for us
+		 */
+		va = dma_alloc_coherent(dev, size, &dma, GFP_KERNEL);
+		if (!va) {
+			dev_err(dev, "dma_alloc_coherent failed\n");
+			/* potential cleanups are taken care of later on */
+			return -EINVAL;
+		}
+
+		dev_dbg(dev, "vring%d: va %p dma %x qsz %d ring size %x\n", i,
+						va, dma, vring->num, size);
+
+		rvdev->vring[i].len = vring->num;
+		rvdev->vring[i].va = va;
+		rvdev->vring[i].dma = dma;
+	}
 
 	return 0;
 }
@@ -419,6 +440,7 @@ static int rproc_handle_vring(struct rproc *rproc, struct fw_resource *rsc)
  * rproc_handle_trace() - handle a shared trace buffer resource
  * @rproc: the remote processor
  * @rsc: the trace resource descriptor
+ * @avail: size of available data (for sanity checking the image)
  *
  * In case the remote processor dumps trace logs into memory,
  * export it via debugfs.
@@ -430,13 +452,25 @@ static int rproc_handle_vring(struct rproc *rproc, struct fw_resource *rsc)
  *
  * Returns 0 on success, or an appropriate error code otherwise
  */
-static int rproc_handle_trace(struct rproc *rproc, struct fw_resource *rsc)
+static int rproc_handle_trace(struct rproc *rproc, struct fw_rsc_trace *rsc,
+								int avail)
 {
 	struct rproc_mem_entry *trace;
 	struct device *dev = rproc->dev;
 	void *ptr;
 	char name[15];
 
+	if (sizeof(*rsc) > avail) {
+		dev_err(rproc->dev, "trace rsc is truncated\n");
+		return -EINVAL;
+	}
+
+	/* make sure reserved bytes are zeroes */
+	if (rsc->reserved) {
+		dev_err(dev, "trace rsc has non zero reserved bytes\n");
+		return -EINVAL;
+	}
+
 	/* what's the kernel address of this resource ? */
 	ptr = rproc_da_to_va(rproc, rsc->da, rsc->len);
 	if (!ptr) {
@@ -469,7 +503,7 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_resource *rsc)
 
 	rproc->num_traces++;
 
-	dev_dbg(dev, "%s added: va %p, da 0x%llx, len 0x%x\n", name, ptr,
+	dev_dbg(dev, "%s added: va %p, da 0x%x, len 0x%x\n", name, ptr,
 						rsc->da, rsc->len);
 
 	return 0;
@@ -479,6 +513,7 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_resource *rsc)
  * rproc_handle_devmem() - handle devmem resource entry
  * @rproc: remote processor handle
  * @rsc: the devmem resource entry
+ * @avail: size of available data (for sanity checking the image)
  *
  * Remote processors commonly need to access certain on-chip peripherals.
  *
@@ -499,7 +534,8 @@ static int rproc_handle_trace(struct rproc *rproc, struct fw_resource *rsc)
  * and not allow firmwares to request access to physical addresses that
  * are outside those ranges.
  */
-static int rproc_handle_devmem(struct rproc *rproc, struct fw_resource *rsc)
+static int rproc_handle_devmem(struct rproc *rproc, struct fw_rsc_devmem *rsc,
+								int avail)
 {
 	struct rproc_mem_entry *mapping;
 	int ret;
@@ -508,6 +544,17 @@ static int rproc_handle_devmem(struct rproc *rproc, struct fw_resource *rsc)
 	if (!rproc->domain)
 		return -EINVAL;
 
+	if (sizeof(*rsc) > avail) {
+		dev_err(rproc->dev, "devmem rsc is truncated\n");
+		return -EINVAL;
+	}
+
+	/* make sure reserved bytes are zeroes */
+	if (rsc->reserved) {
+		dev_err(rproc->dev, "devmem rsc has non zero reserved bytes\n");
+		return -EINVAL;
+	}
+
 	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
 	if (!mapping) {
 		dev_err(rproc->dev, "kzalloc mapping failed\n");
@@ -531,7 +578,7 @@ static int rproc_handle_devmem(struct rproc *rproc, struct fw_resource *rsc)
 	mapping->len = rsc->len;
 	list_add_tail(&mapping->node, &rproc->mappings);
 
-	dev_dbg(rproc->dev, "mapped devmem pa 0x%llx, da 0x%llx, len 0x%x\n",
+	dev_dbg(rproc->dev, "mapped devmem pa 0x%x, da 0x%x, len 0x%x\n",
 					rsc->pa, rsc->da, rsc->len);
 
 	return 0;
@@ -545,6 +592,7 @@ out:
  * rproc_handle_carveout() - handle phys contig memory allocation requests
  * @rproc: rproc handle
  * @rsc: the resource entry
+ * @avail: size of available data (for image validation)
  *
  * This function will handle firmware requests for allocation of physically
  * contiguous memory regions.
@@ -558,7 +606,8 @@ out:
  * needed to map it (in case @rproc is using an IOMMU). Reducing the TLB
  * pressure is important; it may have a substantial impact on performance.
  */
-static int rproc_handle_carveout(struct rproc *rproc, struct fw_resource *rsc)
+static int rproc_handle_carveout(struct rproc *rproc,
+				struct fw_rsc_carveout *rsc, int avail)
 {
 	struct rproc_mem_entry *carveout, *mapping;
 	struct device *dev = rproc->dev;
@@ -566,6 +615,20 @@ static int rproc_handle_carveout(struct rproc *rproc, struct fw_resource *rsc)
 	void *va;
 	int ret;
 
+	if (sizeof(*rsc) > avail) {
+		dev_err(rproc->dev, "carveout rsc is truncated\n");
+		return -EINVAL;
+	}
+
+	/* make sure reserved bytes are zeroes */
+	if (rsc->reserved) {
+		dev_err(dev, "carveout rsc has non zero reserved bytes\n");
+		return -EINVAL;
+	}
+
+	dev_dbg(dev, "carveout rsc: da %x, pa %x, len %x, flags %x\n",
+			rsc->da, rsc->pa, rsc->len, rsc->flags);
+
 	mapping = kzalloc(sizeof(*mapping), GFP_KERNEL);
 	if (!mapping) {
 		dev_err(dev, "kzalloc mapping failed\n");
@@ -624,7 +687,7 @@ static int rproc_handle_carveout(struct rproc *rproc, struct fw_resource *rsc)
 		mapping->len = rsc->len;
 		list_add_tail(&mapping->node, &rproc->mappings);
 
-		dev_dbg(dev, "carveout mapped 0x%llx to 0x%x\n", rsc->da, dma);
+		dev_dbg(dev, "carveout mapped 0x%x to 0x%x\n", rsc->da, dma);
 
 		/*
 		 * Some remote processors might need to know the pa
@@ -665,36 +728,44 @@ free_mapping:
  * enum fw_resource_type.
  */
 static rproc_handle_resource_t rproc_handle_rsc[] = {
-	[RSC_CARVEOUT] = rproc_handle_carveout,
-	[RSC_DEVMEM] = rproc_handle_devmem,
-	[RSC_TRACE] = rproc_handle_trace,
-	[RSC_VRING] = rproc_handle_vring,
-	[RSC_VIRTIO_DEV] = NULL, /* handled early upon registration */
+	[RSC_CARVEOUT] = (rproc_handle_resource_t)rproc_handle_carveout,
+	[RSC_DEVMEM] = (rproc_handle_resource_t)rproc_handle_devmem,
+	[RSC_TRACE] = (rproc_handle_resource_t)rproc_handle_trace,
+	[RSC_VDEV] = (rproc_handle_resource_t)rproc_handle_vdev,
 };
 
 /* handle firmware resource entries before booting the remote processor */
 static int
-rproc_handle_boot_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
+rproc_handle_boot_rsc(struct rproc *rproc, struct resource_table *table, int len)
 {
 	struct device *dev = rproc->dev;
 	rproc_handle_resource_t handler;
-	int ret = 0;
+	int ret = 0, i;
+
+	for (i = 0; i < table->num; i++) {
+		int offset = table->offset[i];
+		struct fw_rsc_hdr *hdr = (void *)table + offset;
+		int avail = len - offset - sizeof(*hdr);
+		void *rsc = (void *)hdr + sizeof(*hdr);
+
+		/* make sure table isn't truncated */
+		if (avail < 0) {
+			dev_err(dev, "rsc table is truncated\n");
+			return -EINVAL;
+		}
 
-	for (; len >= sizeof(*rsc); rsc++, len -= sizeof(*rsc)) {
-		dev_dbg(dev, "rsc: type %d, da 0x%llx, pa 0x%llx, len 0x%x, "
-			"id %d, name %s, flags %x\n", rsc->type, rsc->da,
-			rsc->pa, rsc->len, rsc->id, rsc->name, rsc->flags);
+		dev_dbg(dev, "rsc: type %d\n", hdr->type);
 
-		if (rsc->type >= RSC_LAST) {
-			dev_warn(dev, "unsupported resource %d\n", rsc->type);
+		if (hdr->type >= RSC_LAST) {
+			dev_warn(dev, "unsupported resource %d\n", hdr->type);
 			continue;
 		}
 
-		handler = rproc_handle_rsc[rsc->type];
+		handler = rproc_handle_rsc[hdr->type];
 		if (!handler)
 			continue;
 
-		ret = handler(rproc, rsc);
+		ret = handler(rproc, rsc, avail);
 		if (ret)
 			break;
 	}
@@ -704,18 +775,31 @@ rproc_handle_boot_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
 
 /* handle firmware resource entries while registering the remote processor */
 static int
-rproc_handle_virtio_rsc(struct rproc *rproc, struct fw_resource *rsc, int len)
+rproc_handle_virtio_rsc(struct rproc *rproc, struct resource_table *table, int len)
 {
 	struct device *dev = rproc->dev;
-	int ret = -ENODEV;
+	int ret = 0, i;
+
+	for (i = 0; i < table->num; i++) {
+		int offset = table->offset[i];
+		struct fw_rsc_hdr *hdr = (void *)table + offset;
+		int avail = len - offset - sizeof(*hdr);
 
-	for (; len >= sizeof(*rsc); rsc++, len -= sizeof(*rsc))
-		if (rsc->type == RSC_VIRTIO_DEV) {
-			dev_dbg(dev, "found vdev %d/%s features %llx\n",
-					rsc->flags, rsc->name, rsc->da);
-			ret = rproc_handle_virtio_hdr(rproc, rsc);
+		/* make sure table isn't truncated */
+		if (avail < 0) {
+			dev_err(dev, "rsc table is truncated\n");
+			return -EINVAL;
+		}
+
+		dev_dbg(dev, "%s: rsc type %d\n", __func__, hdr->type);
+
+		if (hdr->type == RSC_VDEV) {
+			struct fw_rsc_vdev *vrsc =
+					(struct fw_rsc_vdev *)hdr->data;
+			ret = rproc_handle_early_vdev(rproc, vrsc, avail);
 			break;
 		}
+	}
 
 	return ret;
 }
@@ -744,7 +828,9 @@ static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
 	struct elf32_hdr *ehdr;
 	struct elf32_shdr *shdr;
 	const char *name_table;
+	struct device *dev = rproc->dev;
 	int i, ret = -EINVAL;
+	struct resource_table *table;
 
 	ehdr = (struct elf32_hdr *)elf_data;
 	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
@@ -752,21 +838,47 @@ static int rproc_handle_resources(struct rproc *rproc, const u8 *elf_data,
 
 	/* look for the resource table and handle it */
 	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
-		if (!strcmp(name_table + shdr->sh_name, ".resource_table")) {
-			struct fw_resource *table = (struct fw_resource *)
-						(elf_data + shdr->sh_offset);
+		int size = shdr->sh_size;
+		int offset = shdr->sh_offset;
 
-			if (shdr->sh_offset + shdr->sh_size > len) {
-				dev_err(rproc->dev,
-					"truncated fw: need 0x%x avail 0x%x\n",
-					shdr->sh_offset + shdr->sh_size, len);
-				ret = -EINVAL;
-			}
+		if (strcmp(name_table + shdr->sh_name, ".resource_table"))
+			continue;
 
-			ret = handler(rproc, table, shdr->sh_size);
+		table = (struct resource_table *)(elf_data + offset);
 
-			break;
+		/* make sure we have the entire table */
+		if (offset + size > len) {
+			dev_err(dev, "resource table truncated\n");
+			return -EINVAL;
+		}
+
+		/* make sure table has at least the header */
+		if (sizeof(struct resource_table) > size) {
+			dev_err(dev, "header-less resource table\n");
+			return -EINVAL;
 		}
+
+		/* we don't support any version beyond the first */
+		if (table->ver != 1) {
+			dev_err(dev, "unsupported fw ver: %d\n", table->ver);
+			return -EINVAL;
+		}
+
+		/* make sure reserved bytes are zeroes */
+		if (table->reserved[0] || table->reserved[1]) {
+			dev_err(dev, "non zero reserved bytes\n");
+			return -EINVAL;
+		}
+
+		/* make sure the offsets array isn't truncated */
+		if (table->num * sizeof(table->offset[0]) +
+				sizeof(struct resource_table) > size) {
+			dev_err(dev, "resource table incomplete\n");
+			return -EINVAL;
+		}
+
+		ret = handler(rproc, table, shdr->sh_size);
+		break;
 	}
 
 	return ret;
@@ -980,7 +1092,7 @@ static void rproc_fw_config_virtio(const struct firmware *fw, void *context)
 	if (rproc_fw_sanity_check(rproc, fw) < 0)
 		goto out;
 
-	/* does the fw supports any virtio devices ? */
+	/* does the fw support any virtio devices ? */
 	ret = rproc_handle_resources(rproc, fw->data, fw->size,
 						rproc_handle_virtio_rsc);
 	if (ret) {
diff --git a/include/linux/remoteproc.h b/include/linux/remoteproc.h
index ada4cb0..6040f83 100644
--- a/include/linux/remoteproc.h
+++ b/include/linux/remoteproc.h
@@ -50,39 +50,51 @@
 #define AMP_VRING_ALIGN	(4096)
 
 /**
- * struct fw_resource - describes an entry from the resource section
- * @type: resource type
- * @id: index number of the resource
- * @da: device address of the resource
- * @pa: physical address of the resource
- * @len: size, in bytes, of the resource
- * @flags: properties of the resource, e.g. iommu protection required
- * @reserved: must be 0 atm
- * @name: name of resource
+ * struct resource_table - firmware resource table header
+ * @ver: version number
+ * @num: number of resource entries
+ * @reserved: reserved (must be zero)
+ * @offset: array of offsets pointing at the various resource entries
  *
- * The remote processor firmware should contain a "resource table":
- * array of 'struct fw_resource' entries.
+ * A resource table is essentially a list of system resources required
+ * by the remote processor. It may also include configuration entries.
+ * If needed, the remote processor firmware should contain this table
+ * as a dedicated ".resource_table" ELF section.
  *
  * Some resources entries are mere announcements, where the host is informed
  * of specific remoteproc configuration. Other entries require the host to
- * do something (e.g. reserve a requested resource) and possibly also reply
- * by overwriting a member inside 'struct fw_resource' with info about the
- * allocated resource.
- *
- * Different resource entries use different members of this struct,
- * with different meanings. This is pretty limiting and error-prone,
- * so the plan is to move to variable-length TLV-based resource entries,
- * where each resource type will have its own structure.
+ * do something (e.g. allocate a system resource). Sometimes a negotiation
+ * is expected, where the firmware requests a resource, and once allocated,
+ * the host should provide back its details (e.g. address of an allocated
+ * memory region).
+ *
+ * The header of the resource table, as expressed by this structure,
+ * contains a version number (should we need to change this format in the
+ * future), the number of available resource entries, and their offsets
+ * in the table.
+ *
+ * Immediately following this header are the resource entries themselves,
+ * each of which begins with a resource entry header (as described below).
+ */
+struct resource_table {
+	u32 ver;
+	u32 num;
+	u32 reserved[2];
+	u32 offset[0];
+} __packed;
+
+/**
+ * struct fw_rsc_hdr - firmware resource entry header
+ * @type: resource type
+ * @data: resource data
+ *
+ * Every resource entry begins with a 'struct fw_rsc_hdr' header providing
+ * its @type. The content of the entry itself will immediately follow
+ * this header, and it should be parsed according to the resource type.
  */
-struct fw_resource {
+struct fw_rsc_hdr {
 	u32 type;
-	u32 id;
-	u64 da;
-	u64 pa;
-	u32 len;
-	u32 flags;
-	u8 reserved[16];
-	u8 name[48];
+	u8 data[0];
 } __packed;
 
 /**
@@ -92,30 +104,13 @@ struct fw_resource {
  *		    memory region.
  * @RSC_DEVMEM:     request to iommu_map a memory-based peripheral.
  * @RSC_TRACE:	    announces the availability of a trace buffer into which
- *		    the remote processor will be writing logs. In this case,
- *		    'da' indicates the device address where logs are written to,
- *		    and 'len' is the size of the trace buffer.
- * @RSC_VRING:	    request for allocation of a virtio vring (address should
- *		    be indicated in 'da', and 'len' should contain the number
- *		    of buffers supported by the vring).
- * @RSC_VIRTIO_DEV: this entry declares about support for a virtio device,
- *		    and serves as the virtio header. 'da' holds the
- *		    the virtio device features, 'pa' holds the virtio guest
- *		    features, 'len' holds the virtio status, and 'flags' holds
- *		    the virtio id (currently only VIRTIO_ID_RPMSG is supported).
+ *		    the remote processor will be writing logs.
+ * @RSC_VDEV:       declare support for a virtio device, and serve as its
+ *		    virtio header.
  * @RSC_LAST:       just keep this one at the end
  *
- * Most of the resource entries share the basic idea of address/length
- * negotiation with the host: the firmware usually asks (on behalf of the
- * remote processor that will soon be booted with it) for memory
- * of size 'len' bytes, and the host needs to allocate it and provide
- * the device/physical address (when relevant) in 'da'/'pa' respectively.
- *
- * If the firmware is compiled with hard coded device addresses, and
- * can't handle dynamically allocated 'da' values, then the 'da' field
- * will contain the expected device addresses (today we actually only support
- * this scheme, as there aren't yet any use cases for dynamically allocated
- * device addresses).
+ * For more details regarding a specific resource type, please see its
+ * dedicated structure below.
  *
  * Please note that these values are used as indices to the rproc_handle_rsc
  * lookup table, so please keep them sane. Moreover, @RSC_LAST is used to
@@ -126,11 +121,197 @@ enum fw_resource_type {
 	RSC_CARVEOUT	= 0,
 	RSC_DEVMEM	= 1,
 	RSC_TRACE	= 2,
-	RSC_VRING	= 3,
-	RSC_VIRTIO_DEV	= 4,
-	RSC_LAST	= 5,
+	RSC_VDEV	= 3,
+	RSC_LAST	= 4,
 };
 
+#define FW_RSC_ADDR_ANY (0xFFFFFFFFFFFFFFFF)
+
+/**
+ * struct fw_rsc_carveout - physically contiguous memory request
+ * @da: device address
+ * @pa: physical address
+ * @len: length (in bytes)
+ * @flags: iommu protection flags
+ * @reserved: reserved (must be zero)
+ * @name: human-readable name of the requested memory region
+ *
+ * This resource entry requests the host to allocate a physically contiguous
+ * memory region.
+ *
+ * These request entries should precede other firmware resource entries,
+ * as other entries might request placing other data objects inside
+ * these memory regions (e.g. data/code segments, trace resource entries, ...).
+ *
+ * Allocating memory this way helps utilizing the reserved physical memory
+ * (e.g. CMA) more efficiently, and also minimizes the number of TLB entries
+ * needed to map it (in case @rproc is using an IOMMU). Reducing the TLB
+ * pressure is important; it may have a substantial impact on performance.
+ *
+ * If the firmware is compiled with static addresses, then @da should specify
+ * the expected device address of this memory region. If @da is set to
+ * FW_RSC_ADDR_ANY, then the host will dynamically allocate it, and then
+ * overwrite @da with the dynamically allocated address.
+ *
+ * We will always use @da to negotiate the device addresses, even if it
+ * isn't using an iommu. In that case, though, it will obviously contain
+ * physical addresses.
+ *
+ * Some remote processors needs to know the allocated physical address
+ * even if they do use an iommu. This is needed, e.g., if they control
+ * hardware accelerators which access the physical memory directly (this
+ * is the case with OMAP4 for instance). In that case, the host will
+ * overwrite @pa with the dynamically allocated physical address.
+ * Generally we don't want to expose physical addresses if we don't have to
+ * (remote processors are generally _not_ trusted), so we might want to
+ * change this to happen _only_ when explicitly required by the hardware.
+ *
+ * @flags is used to provide IOMMU protection flags, and @name should
+ * (optionally) contain a human readable name of this carveout region
+ * (mainly for debugging purposes).
+ */
+struct fw_rsc_carveout {
+	u32 da;
+	u32 pa;
+	u32 len;
+	u32 flags;
+	u32 reserved;
+	u8 name[32];
+} __packed;
+
+/**
+ * struct fw_rsc_devmem - iommu mapping request
+ * @da: device address
+ * @pa: physical address
+ * @len: length (in bytes)
+ * @flags: iommu protection flags
+ * @reserved: reserved (must be zero)
+ * @name: human-readable name of the requested region to be mapped
+ *
+ * This resource entry requests the host to iommu map a physically contiguous
+ * memory region. This is needed in case the remote processor requires
+ * access to certain memory-based peripherals; _never_ use it to access
+ * regular memory.
+ *
+ * This is obviously only needed if the remote processor is accessing memory
+ * via an iommu.
+ *
+ * @da should specify the required device address, @pa should specify
+ * the physical address we want to map, @len should specify the size of
+ * the mapping and @flags is the IOMMU protection flags. As always, @name may
+ * (optionally) contain a human readable name of this mapping (mainly for
+ * debugging purposes).
+ *
+ * Note: at this point we just "trust" those devmem entries to contain valid
+ * physical addresses, but this isn't safe and will be changed: eventually we
+ * want remoteproc implementations to provide us ranges of physical addresses
+ * the firmware is allowed to request, and not allow firmwares to request
+ * access to physical addresses that are outside those ranges.
+ */
+struct fw_rsc_devmem {
+	u32 da;
+	u32 pa;
+	u32 len;
+	u32 flags;
+	u32 reserved;
+	u8 name[32];
+} __packed;
+
+/**
+ * struct fw_rsc_trace - trace buffer declaration
+ * @da: device address
+ * @len: length (in bytes)
+ * @reserved: reserved (must be zero)
+ * @name: human-readable name of the trace buffer
+ *
+ * This resource entry provides the host information about a trace buffer
+ * into which the remote processor will write log messages.
+ *
+ * @da specifies the device address of the buffer, @len specifies
+ * its size, and @name may contain a human readable name of the trace buffer.
+ *
+ * After booting the remote processor, the trace buffers are exposed to the
+ * user via debugfs entries (called trace0, trace1, etc..).
+ */
+struct fw_rsc_trace {
+	u32 da;
+	u32 len;
+	u32 reserved;
+	u8 name[32];
+} __packed;
+
+/**
+ * struct fw_rsc_vdev_vring - vring descriptor entry
+ * @da: device address
+ * @align: the alignment between the consumer and producer parts of the vring
+ * @num: num of buffers supported by this vring (must be power of two)
+ * @notifyid is a unique rproc-wide notify index for this vring. This notify
+ * index is used when kicking a remote processor, to let it know that this
+ * vring is triggered.
+ * @reserved: reserved (must be zero)
+ *
+ * This descriptor is not a resource entry by itself; it is part of the
+ * vdev resource type (see below).
+ *
+ * Note that @da should either contain the device address where
+ * the remote processor is expecting the vring, or indicate that
+ * dynamically allocation of the vring's device address is supported.
+ */
+struct fw_rsc_vdev_vring {
+	u32 da;
+	u32 align;
+	u32 num;
+	u32 notifyid;
+	u32 reserved;
+} __packed;
+
+/**
+ * struct fw_rsc_vdev - virtio device header
+ * @id: virtio device id (as in virtio_ids.h)
+ * @notifyid is a unique rproc-wide notify index for this vdev. This notify
+ * index is used when kicking a remote processor, to let it know that the
+ * status/features of this vdev have changes.
+ * @dfeatures specifies the virtio device features supported by the firmware
+ * @gfeatures is a place holder used by the host to write back the
+ * negotiated features that are supported by both sides.
+ * @config_len is the size of the virtio config space of this vdev. The config
+ * space lies in the resource table immediate after this vdev header.
+ * @status is a place holder where the host will indicate its virtio progress.
+ * @num_of_vrings indicates how many vrings are described in this vdev header
+ * @reserved: reserved (must be zero)
+ * @vring is an array of @num_of_vrings entries of 'struct fw_rsc_vdev_vring'.
+ *
+ * This resource is a virtio device header: it provides information about
+ * the vdev, and is then used by the host and its peer remote processors
+ * to negotiate and share certain virtio properties.
+ *
+ * By providing this resource entry, the firmware essentially asks remoteproc
+ * to statically allocate a vdev upon registration of the rproc (dynamic vdev
+ * allocation is not yet supported).
+ *
+ * Note: unlike virtualization systems, the term 'host' here means
+ * the Linux side which is running remoteproc to control the remote
+ * processors. We use the name 'gfeatures' to comply with virtio's terms,
+ * though there isn't really any virtualized guest OS here: it's the host
+ * which is responsible for negotiating the final features.
+ * Yeah, it's a bit confusing.
+ *
+ * Note: immediately following this structure is the virtio config space for
+ * this vdev (which is specific to the vdev; for more info, read the virtio
+ * spec). the size of the config space is specified by @config_len.
+ */
+struct fw_rsc_vdev {
+	u32 id;
+	u32 notifyid;
+	u32 dfeatures;
+	u32 gfeatures;
+	u32 config_len;
+	u8 status;
+	u8 num_of_vrings;
+	u8 reserved[2];
+	struct fw_rsc_vdev_vring vring[0];
+} __packed;
+
 /**
  * struct rproc_mem_entry - memory entry descriptor
  * @va:	virtual address
@@ -144,7 +325,7 @@ struct rproc_mem_entry {
 	void *va;
 	dma_addr_t dma;
 	int len;
-	u64 da;
+	u32 da;
 	void *priv;
 	struct list_head node;
 };
@@ -226,7 +407,7 @@ struct rproc {
 	struct list_head carveouts;
 	struct list_head mappings;
 	struct completion firmware_loading_complete;
-	u64 bootaddr;
+	u32 bootaddr;
 	struct rproc_vdev *rvdev;
 };
 
-- 
1.7.5.4

