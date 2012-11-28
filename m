Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2K1HVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:21:51 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:47122 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab2K1HVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:21:50 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH] vfio powerpc: implemented IOMMU driver for VFIO
Date: Wed, 28 Nov 2012 18:21:39 +1100
Message-Id: <1354087299-26791-1-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353992877.1809.156.camel@bling.home>
References: <1353992877.1809.156.camel@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VFIO implements platform independent stuff such as
a PCI driver, BAR access (via read/write on a file descriptor
or direct mapping when possible) and IRQ signaling.

The platform dependent part includes IOMMU initialization
and handling. This patch implements an IOMMU driver for VFIO
which does mapping/unmapping pages for the guest IO and
provides information about DMA window (required by a POWERPC
guest).

The counterpart in QEMU is required to support this functionality.

Cc: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 drivers/vfio/Kconfig                |    6 +
 drivers/vfio/Makefile               |    1 +
 drivers/vfio/vfio_iommu_spapr_tce.c |  332 +++++++++++++++++++++++++++++++++++
 include/linux/vfio.h                |   33 ++++
 4 files changed, 372 insertions(+)
 create mode 100644 drivers/vfio/vfio_iommu_spapr_tce.c

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index 7cd5dec..b464687 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -3,10 +3,16 @@ config VFIO_IOMMU_TYPE1
 	depends on VFIO
 	default n
 
+config VFIO_IOMMU_SPAPR_TCE
+	tristate
+	depends on VFIO && SPAPR_TCE_IOMMU
+	default n
+
 menuconfig VFIO
 	tristate "VFIO Non-Privileged userspace driver framework"
 	depends on IOMMU_API
 	select VFIO_IOMMU_TYPE1 if X86
+	select VFIO_IOMMU_SPAPR_TCE if PPC_POWERNV
 	help
 	  VFIO provides a framework for secure userspace device drivers.
 	  See Documentation/vfio.txt for more details.
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 2398d4a..72bfabc 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_VFIO) += vfio.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
+obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
 obj-$(CONFIG_VFIO_PCI) += pci/
diff --git a/drivers/vfio/vfio_iommu_spapr_tce.c b/drivers/vfio/vfio_iommu_spapr_tce.c
new file mode 100644
index 0000000..b98770e
--- /dev/null
+++ b/drivers/vfio/vfio_iommu_spapr_tce.c
@@ -0,0 +1,332 @@
+/*
+ * VFIO: IOMMU DMA mapping support for TCE on POWER
+ *
+ * Copyright (C) 2012 IBM Corp.  All rights reserved.
+ *     Author: Alexey Kardashevskiy <aik@ozlabs.ru>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Derived from original vfio_iommu_type1.c:
+ * Copyright (C) 2012 Red Hat, Inc.  All rights reserved.
+ *     Author: Alex Williamson <alex.williamson@redhat.com>
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/err.h>
+#include <linux/vfio.h>
+#include <asm/iommu.h>
+
+#define DRIVER_VERSION  "0.1"
+#define DRIVER_AUTHOR   "aik@ozlabs.ru"
+#define DRIVER_DESC     "VFIO IOMMU SPAPR TCE"
+
+static void tce_iommu_detach_group(void *iommu_data,
+		struct iommu_group *iommu_group);
+
+/*
+ * VFIO IOMMU fd for SPAPR_TCE IOMMU implementation
+ */
+
+/*
+ * This code handles mapping and unmapping of user data buffers
+ * into DMA'ble space using the IOMMU
+ */
+
+#define NPAGE_TO_SIZE(npage)	((size_t)(npage) << PAGE_SHIFT)
+
+struct vwork {
+	struct mm_struct	*mm;
+	long			npage;
+	struct work_struct	work;
+};
+
+/* delayed decrement/increment for locked_vm */
+static void lock_acct_bg(struct work_struct *work)
+{
+	struct vwork *vwork = container_of(work, struct vwork, work);
+	struct mm_struct *mm;
+
+	mm = vwork->mm;
+	down_write(&mm->mmap_sem);
+	mm->locked_vm += vwork->npage;
+	up_write(&mm->mmap_sem);
+	mmput(mm);
+	kfree(vwork);
+}
+
+static void lock_acct(long npage)
+{
+	struct vwork *vwork;
+	struct mm_struct *mm;
+
+	if (!current->mm)
+		return; /* process exited */
+
+	if (down_write_trylock(&current->mm->mmap_sem)) {
+		current->mm->locked_vm += npage;
+		up_write(&current->mm->mmap_sem);
+		return;
+	}
+
+	/*
+	 * Couldn't get mmap_sem lock, so must setup to update
+	 * mm->locked_vm later. If locked_vm were atomic, we
+	 * wouldn't need this silliness
+	 */
+	vwork = kmalloc(sizeof(struct vwork), GFP_KERNEL);
+	if (!vwork)
+		return;
+	mm = get_task_mm(current);
+	if (!mm) {
+		kfree(vwork);
+		return;
+	}
+	INIT_WORK(&vwork->work, lock_acct_bg);
+	vwork->mm = mm;
+	vwork->npage = npage;
+	schedule_work(&vwork->work);
+}
+
+/*
+ * The container descriptor supports only a single group per container.
+ * Required by the API as the container is not supplied with the IOMMU group
+ * at the moment of initialization.
+ */
+struct tce_container {
+	struct mutex lock;
+	struct iommu_table *tbl;
+};
+
+static void *tce_iommu_open(unsigned long arg)
+{
+	struct tce_container *container;
+
+	if (arg != VFIO_SPAPR_TCE_IOMMU) {
+		pr_err("tce_vfio: Wrong IOMMU type\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	container = kzalloc(sizeof(*container), GFP_KERNEL);
+	if (!container)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&container->lock);
+
+	return container;
+}
+
+static void tce_iommu_release(void *iommu_data)
+{
+	struct tce_container *container = iommu_data;
+
+	WARN_ON(container->tbl && !container->tbl->it_group);
+	if (container->tbl && container->tbl->it_group)
+		tce_iommu_detach_group(iommu_data, container->tbl->it_group);
+
+	mutex_destroy(&container->lock);
+
+	kfree(container);
+}
+
+static long tce_iommu_ioctl(void *iommu_data,
+				 unsigned int cmd, unsigned long arg)
+{
+	struct tce_container *container = iommu_data;
+	unsigned long minsz;
+	long ret;
+
+	switch (cmd) {
+	case VFIO_CHECK_EXTENSION: {
+		return (arg == VFIO_SPAPR_TCE_IOMMU) ? 1 : 0;
+	}
+	case VFIO_IOMMU_SPAPR_TCE_GET_INFO: {
+		struct vfio_iommu_spapr_tce_info info;
+		struct iommu_table *tbl = container->tbl;
+
+		if (WARN_ON(!tbl))
+			return -ENXIO;
+
+		minsz = offsetofend(struct vfio_iommu_spapr_tce_info,
+				dma64_window_size);
+
+		if (copy_from_user(&info, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (info.argsz < minsz)
+			return -EINVAL;
+
+		info.dma32_window_start = tbl->it_offset << IOMMU_PAGE_SHIFT;
+		info.dma32_window_size = tbl->it_size << IOMMU_PAGE_SHIFT;
+		info.dma64_window_start = 0;
+		info.dma64_window_size = 0;
+		info.flags = 0;
+
+		if (copy_to_user((void __user *)arg, &info, minsz))
+			return -EFAULT;
+
+		return 0;
+	}
+	case VFIO_IOMMU_MAP_DMA: {
+		vfio_iommu_spapr_tce_dma_map param;
+		struct iommu_table *tbl = container->tbl;
+		enum dma_data_direction direction;
+		unsigned long locked, lock_limit;
+
+		if (WARN_ON(!tbl))
+			return -ENXIO;
+
+		minsz = offsetofend(vfio_iommu_spapr_tce_dma_map, size);
+
+		if (copy_from_user(&param, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (param.argsz < minsz)
+			return -EINVAL;
+
+		if ((param.flags & VFIO_DMA_MAP_FLAG_READ) &&
+				(param.flags & VFIO_DMA_MAP_FLAG_WRITE))
+			direction = DMA_BIDIRECTIONAL;
+		else if (param.flags & VFIO_DMA_MAP_FLAG_READ)
+			direction = DMA_TO_DEVICE;
+		else if (param.flags & VFIO_DMA_MAP_FLAG_WRITE)
+			direction = DMA_FROM_DEVICE;
+		else
+			return -EINVAL;
+
+		if ((param.size & ~IOMMU_PAGE_MASK) ||
+				(param.iova & ~IOMMU_PAGE_MASK) ||
+				(param.vaddr & ~IOMMU_PAGE_MASK))
+			return -EINVAL;
+
+		/* Account for locked pages */
+		locked = current->mm->locked_vm +
+				(param.size >> IOMMU_PAGE_SHIFT);
+		lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+		if (locked > lock_limit && !capable(CAP_IPC_LOCK)) {
+			pr_warn("RLIMIT_MEMLOCK (%ld) exceeded\n",
+					rlimit(RLIMIT_MEMLOCK));
+			return -ENOMEM;
+		}
+
+		ret = iommu_put_tces(tbl, param.iova >> IOMMU_PAGE_SHIFT,
+				param.vaddr, direction,
+				param.size >> IOMMU_PAGE_SHIFT);
+		if (ret > 0)
+			lock_acct(ret);
+
+		return ret;
+	}
+	case VFIO_IOMMU_UNMAP_DMA: {
+		vfio_iommu_spapr_tce_dma_unmap param;
+		struct iommu_table *tbl = container->tbl;
+
+		if (WARN_ON(!tbl))
+			return -ENXIO;
+
+		minsz = offsetofend(vfio_iommu_spapr_tce_dma_unmap, size);
+
+		if (copy_from_user(&param, (void __user *)arg, minsz))
+			return -EFAULT;
+
+		if (param.argsz < minsz)
+			return -EINVAL;
+
+		if ((param.size & ~IOMMU_PAGE_MASK) ||
+				(param.iova & ~IOMMU_PAGE_MASK))
+			return -EINVAL;
+
+		ret = iommu_clear_tces(tbl, param.iova >> IOMMU_PAGE_SHIFT,
+				param.size >> IOMMU_PAGE_SHIFT);
+		if (ret > 0)
+			lock_acct(-ret);
+
+		return ret;
+	}
+	default:
+		pr_warn("tce_vfio: unexpected cmd %x\n", cmd);
+	}
+
+	return -ENOTTY;
+}
+
+static int tce_iommu_attach_group(void *iommu_data,
+		struct iommu_group *iommu_group)
+{
+	struct tce_container *container = iommu_data;
+	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
+
+	BUG_ON(!tbl);
+	mutex_lock(&container->lock);
+	pr_debug("tce_vfio: Attaching group #%u to iommu %p\n",
+			iommu_group_id(iommu_group), iommu_group);
+	if (container->tbl) {
+		pr_warn("tce_vfio: Only one group per IOMMU container is allowed, existing id=%d, attaching id=%d\n",
+				iommu_group_id(container->tbl->it_group),
+				iommu_group_id(iommu_group));
+		mutex_unlock(&container->lock);
+		return -EBUSY;
+	}
+
+	container->tbl = tbl;
+	iommu_clear_tces(tbl, tbl->it_offset, tbl->it_size);
+	mutex_unlock(&container->lock);
+
+	return 0;
+}
+
+static void tce_iommu_detach_group(void *iommu_data,
+		struct iommu_group *iommu_group)
+{
+	struct tce_container *container = iommu_data;
+	struct iommu_table *tbl = iommu_group_get_iommudata(iommu_group);
+
+	BUG_ON(!tbl);
+	mutex_lock(&container->lock);
+	if (tbl != container->tbl) {
+		pr_warn("tce_vfio: detaching group #%u, expected group is #%u\n",
+				iommu_group_id(iommu_group),
+				iommu_group_id(tbl->it_group));
+	} else {
+
+		pr_debug("tce_vfio: detaching group #%u from iommu %p\n",
+				iommu_group_id(iommu_group), iommu_group);
+
+		iommu_clear_tces(tbl, tbl->it_offset, tbl->it_size);
+		container->tbl = NULL;
+	}
+	mutex_unlock(&container->lock);
+}
+
+const struct vfio_iommu_driver_ops tce_iommu_driver_ops = {
+	.name		= "iommu-vfio-powerpc",
+	.owner		= THIS_MODULE,
+	.open		= tce_iommu_open,
+	.release	= tce_iommu_release,
+	.ioctl		= tce_iommu_ioctl,
+	.attach_group	= tce_iommu_attach_group,
+	.detach_group	= tce_iommu_detach_group,
+};
+
+static int __init tce_iommu_init(void)
+{
+	return vfio_register_iommu_driver(&tce_iommu_driver_ops);
+}
+
+static void __exit tce_iommu_cleanup(void)
+{
+	vfio_unregister_iommu_driver(&tce_iommu_driver_ops);
+}
+
+module_init(tce_iommu_init);
+module_exit(tce_iommu_cleanup);
+
+MODULE_VERSION(DRIVER_VERSION);
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 0a4f180..820af1e 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -99,6 +99,7 @@ extern void vfio_unregister_iommu_driver(
 /* Extensions */
 
 #define VFIO_TYPE1_IOMMU		1
+#define VFIO_SPAPR_TCE_IOMMU		2
 
 /*
  * The IOCTL interface is designed for extensibility by embedding the
@@ -442,4 +443,36 @@ struct vfio_iommu_type1_dma_unmap {
 
 #define VFIO_IOMMU_UNMAP_DMA _IO(VFIO_TYPE, VFIO_BASE + 14)
 
+/* -------- Additional API for SPAPR TCE (Server POWERPC) IOMMU -------- */
+
+/*
+ * The SPAPR TCE info struct provides the information about the PCI bus
+ * address ranges available for DMA, these values are programmed into
+ * the hardware so the guest has to know that information.
+ *
+ * Pages within 32 bit window should be explicitely mapped/unmapped via ioctls.
+ * 64 bit window (not supported at the moment for the guest) is supposed to
+ * be mapped completely to the guest memory so the devices capable of 64bit
+ * DMA will not have to use map/unmap ioctls.
+ *
+ * The IOMMU page size is always 4K.
+ */
+
+struct vfio_iommu_spapr_tce_info {
+	__u32 argsz;
+	__u32 flags;			/* reserved for future use */
+	__u32 dma32_window_start;	/* 32 bit window start (bytes) */
+	__u32 dma32_window_size;	/* 32 bit window size (bytes) */
+	__u64 dma64_window_start;	/* 64 bit window start (bytes) */
+	__u64 dma64_window_size;	/* 64 bit window size (bytes) */
+};
+
+#define VFIO_IOMMU_SPAPR_TCE_GET_INFO	_IO(VFIO_TYPE, VFIO_BASE + 12)
+
+/* Reuse type1 map/unmap structs as they are the same at the moment */
+typedef struct vfio_iommu_type1_dma_map vfio_iommu_spapr_tce_dma_map;
+typedef struct vfio_iommu_type1_dma_unmap vfio_iommu_spapr_tce_dma_unmap;
+
+/* ***************************************************************** */
+
 #endif /* VFIO_H */
-- 
1.7.10.4

