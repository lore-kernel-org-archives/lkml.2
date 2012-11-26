Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab2KZNQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:16:28 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3975 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2KZNQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:16:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 26 Nov 2012 05:16:14 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <thierry.reding@avionic-design.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <linux-kernel@vger.kernel.org>, Terje Bergstrom <tbergstrom@nvidia.com>
Subject: [RFC v2 3/8] video: tegra: host: Add channel and client support
Date: Mon, 26 Nov 2012 15:19:09 +0200
Message-ID: <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for host1x client modules, and host1x channels to submit
work to the clients. The work is submitted in dmabuf buffers, so add
support for dmabuf memory management, too.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/video/tegra/host/Makefile                  |    8 +-
 drivers/video/tegra/host/bus_client.c              |   94 ++++
 drivers/video/tegra/host/chip_support.c            |    2 +-
 drivers/video/tegra/host/chip_support.h            |   64 +++
 drivers/video/tegra/host/dev.c                     |   67 +++
 drivers/video/tegra/host/dev.h                     |   33 ++
 drivers/video/tegra/host/dmabuf.c                  |  151 ++++++
 drivers/video/tegra/host/dmabuf.h                  |   45 ++
 drivers/video/tegra/host/host1x/host1x.c           |   17 +
 drivers/video/tegra/host/host1x/host1x.h           |    6 +
 drivers/video/tegra/host/host1x/host1x01.c         |   29 ++
 .../video/tegra/host/host1x/host1x01_hardware.h    |  121 +++++
 drivers/video/tegra/host/host1x/host1x_cdma.c      |  483 ++++++++++++++++++++
 drivers/video/tegra/host/host1x/host1x_cdma.h      |   39 ++
 drivers/video/tegra/host/host1x/host1x_channel.c   |  150 ++++++
 drivers/video/tegra/host/host1x/host1x_syncpt.c    |   11 +
 .../video/tegra/host/host1x/hw_host1x01_channel.h  |  182 ++++++++
 .../video/tegra/host/host1x/hw_host1x01_uclass.h   |  474 +++++++++++++++++++
 drivers/video/tegra/host/nvhost_cdma.c             |  429 +++++++++++++++++
 drivers/video/tegra/host/nvhost_cdma.h             |  109 +++++
 drivers/video/tegra/host/nvhost_channel.c          |  126 +++++
 drivers/video/tegra/host/nvhost_channel.h          |   65 +++
 drivers/video/tegra/host/nvhost_intr.c             |   23 +-
 drivers/video/tegra/host/nvhost_intr.h             |    8 +
 drivers/video/tegra/host/nvhost_job.c              |  390 ++++++++++++++++
 drivers/video/tegra/host/nvhost_memmgr.c           |  160 +++++++
 drivers/video/tegra/host/nvhost_memmgr.h           |   65 +++
 drivers/video/tegra/host/nvhost_syncpt.c           |    6 +
 drivers/video/tegra/host/nvhost_syncpt.h           |    2 +
 include/linux/nvhost.h                             |  149 ++++++
 30 files changed, 3505 insertions(+), 3 deletions(-)
 create mode 100644 drivers/video/tegra/host/bus_client.c
 create mode 100644 drivers/video/tegra/host/dev.h
 create mode 100644 drivers/video/tegra/host/dmabuf.c
 create mode 100644 drivers/video/tegra/host/dmabuf.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x_cdma.c
 create mode 100644 drivers/video/tegra/host/host1x/host1x_cdma.h
 create mode 100644 drivers/video/tegra/host/host1x/host1x_channel.c
 create mode 100644 drivers/video/tegra/host/host1x/hw_host1x01_channel.h
 create mode 100644 drivers/video/tegra/host/host1x/hw_host1x01_uclass.h
 create mode 100644 drivers/video/tegra/host/nvhost_cdma.c
 create mode 100644 drivers/video/tegra/host/nvhost_cdma.h
 create mode 100644 drivers/video/tegra/host/nvhost_channel.c
 create mode 100644 drivers/video/tegra/host/nvhost_channel.h
 create mode 100644 drivers/video/tegra/host/nvhost_job.c
 create mode 100644 drivers/video/tegra/host/nvhost_memmgr.c
 create mode 100644 drivers/video/tegra/host/nvhost_memmgr.h

diff --git a/drivers/video/tegra/host/Makefile b/drivers/video/tegra/host/Makefile
index 24acccc..128ad03 100644
--- a/drivers/video/tegra/host/Makefile
+++ b/drivers/video/tegra/host/Makefile
@@ -3,9 +3,15 @@ ccflags-y = -Idrivers/video/tegra/host
 nvhost-objs = \
 	nvhost_acm.o \
 	nvhost_syncpt.o \
+	nvhost_cdma.o \
 	nvhost_intr.o \
+	nvhost_channel.o \
+	nvhost_job.o \
 	dev.o \
-	chip_support.o
+	bus_client.o \
+	chip_support.o \
+	nvhost_memmgr.o \
+	dmabuf.o
 
 obj-$(CONFIG_TEGRA_HOST1X) += host1x/
 obj-$(CONFIG_TEGRA_HOST1X) += nvhost.o
diff --git a/drivers/video/tegra/host/bus_client.c b/drivers/video/tegra/host/bus_client.c
new file mode 100644
index 0000000..3986185
--- /dev/null
+++ b/drivers/video/tegra/host/bus_client.c
@@ -0,0 +1,94 @@
+/*
+ * drivers/video/tegra/host/bus_client.c
+ *
+ * Tegra host1x Client Module
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/spinlock.h>
+#include <linux/fs.h>
+#include <linux/cdev.h>
+#include <linux/uaccess.h>
+#include <linux/file.h>
+#include <linux/clk.h>
+#include <linux/hrtimer.h>
+#include <linux/export.h>
+
+#include <linux/io.h>
+#include <linux/string.h>
+
+#include <linux/nvhost.h>
+
+#include "dev.h"
+#include "nvhost_memmgr.h"
+#include "chip_support.h"
+#include "nvhost_acm.h"
+
+#include "nvhost_channel.h"
+
+int nvhost_client_device_init(struct platform_device *dev)
+{
+	int err;
+	struct nvhost_master *nvhost_master = nvhost_get_host(dev);
+	struct nvhost_channel *ch;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	ch = nvhost_alloc_channel(dev);
+	if (ch == NULL)
+		return -ENODEV;
+
+	/* store the pointer to this device for channel */
+	ch->dev = dev;
+
+	err = nvhost_channel_init(ch, nvhost_master, pdata->index);
+	if (err)
+		goto fail;
+
+	err = nvhost_module_init(dev);
+	if (err)
+		goto fail;
+
+	err = nvhost_device_list_add(dev);
+	if (err)
+		goto fail;
+
+	dev_info(&dev->dev, "initialized\n");
+
+	return 0;
+
+fail:
+	/* Add clean-up */
+	nvhost_free_channel(ch);
+	return err;
+}
+EXPORT_SYMBOL(nvhost_client_device_init);
+
+int nvhost_client_device_suspend(struct platform_device *dev)
+{
+	int ret = 0;
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+
+	ret = nvhost_channel_suspend(pdata->channel);
+	dev_info(&dev->dev, "suspend status: %d\n", ret);
+	if (ret)
+		return ret;
+
+	return ret;
+}
+EXPORT_SYMBOL(nvhost_client_device_suspend);
diff --git a/drivers/video/tegra/host/chip_support.c b/drivers/video/tegra/host/chip_support.c
index 5a44147..8765c83 100644
--- a/drivers/video/tegra/host/chip_support.c
+++ b/drivers/video/tegra/host/chip_support.c
@@ -25,7 +25,7 @@
 #include "chip_support.h"
 #include "host1x/host1x01.h"
 
-struct nvhost_chip_support *nvhost_chip_ops;
+static struct nvhost_chip_support *nvhost_chip_ops;
 
 struct nvhost_chip_support *nvhost_get_chip_ops(void)
 {
diff --git a/drivers/video/tegra/host/chip_support.h b/drivers/video/tegra/host/chip_support.h
index 5c8f49f..ff141ed 100644
--- a/drivers/video/tegra/host/chip_support.h
+++ b/drivers/video/tegra/host/chip_support.h
@@ -27,14 +27,63 @@ struct output;
 struct nvhost_master;
 struct nvhost_intr;
 struct nvhost_syncpt;
+struct nvhost_channel;
+struct nvhost_cdma;
+struct nvhost_job;
+struct push_buffer;
+struct dentry;
+struct nvhost_job;
+struct nvhost_job_unpin_data;
+struct nvhost_intr_syncpt;
+struct mem_handle;
 struct platform_device;
 
+struct nvhost_channel_ops {
+	const char *soc_name;
+	int (*init)(struct nvhost_channel *,
+		    struct nvhost_master *,
+		    int chid);
+	int (*submit)(struct nvhost_job *job);
+};
+
+struct nvhost_cdma_ops {
+	void (*start)(struct nvhost_cdma *);
+	void (*stop)(struct nvhost_cdma *);
+	void (*kick)(struct  nvhost_cdma *);
+	int (*timeout_init)(struct nvhost_cdma *,
+			    u32 syncpt_id);
+	void (*timeout_destroy)(struct nvhost_cdma *);
+	void (*timeout_teardown_begin)(struct nvhost_cdma *);
+	void (*timeout_teardown_end)(struct nvhost_cdma *,
+				     u32 getptr);
+	void (*timeout_cpu_incr)(struct nvhost_cdma *,
+				 u32 getptr,
+				 u32 syncpt_incrs,
+				 u32 syncval,
+				 u32 nr_slots);
+};
+
+struct nvhost_pushbuffer_ops {
+	void (*reset)(struct push_buffer *);
+	int (*init)(struct push_buffer *);
+	void (*destroy)(struct push_buffer *);
+	void (*push_to)(struct push_buffer *,
+			struct mem_handle *,
+			u32 op1, u32 op2);
+	void (*pop_from)(struct push_buffer *,
+			 unsigned int slots);
+	u32 (*space)(struct push_buffer *);
+	u32 (*putptr)(struct push_buffer *);
+};
+
 struct nvhost_syncpt_ops {
 	void (*reset)(struct nvhost_syncpt *, u32 id);
 	void (*reset_wait_base)(struct nvhost_syncpt *, u32 id);
 	void (*read_wait_base)(struct nvhost_syncpt *, u32 id);
 	u32 (*update_min)(struct nvhost_syncpt *, u32 id);
 	void (*cpu_incr)(struct nvhost_syncpt *, u32 id);
+	int (*patch_wait)(struct nvhost_syncpt *sp,
+			void *patch_addr);
 	void (*debug)(struct nvhost_syncpt *);
 	const char * (*name)(struct nvhost_syncpt *, u32 id);
 };
@@ -53,16 +102,31 @@ struct nvhost_intr_ops {
 	int (*free_syncpt_irq)(struct nvhost_intr *);
 };
 
+struct nvhost_dev_ops {
+	struct nvhost_channel *(*alloc_nvhost_channel)(
+			struct platform_device *dev);
+	void (*free_nvhost_channel)(struct nvhost_channel *ch);
+};
+
 struct nvhost_chip_support {
 	const char *soc_name;
+	struct nvhost_channel_ops channel;
+	struct nvhost_cdma_ops cdma;
+	struct nvhost_pushbuffer_ops push_buffer;
 	struct nvhost_syncpt_ops syncpt;
 	struct nvhost_intr_ops intr;
+	struct nvhost_dev_ops nvhost_dev;
 };
 
 struct nvhost_chip_support *nvhost_get_chip_ops(void);
 
+#define host_device_op()	(nvhost_get_chip_ops()->nvhost_dev)
+#define channel_cdma_op()	(nvhost_get_chip_ops()->cdma)
+#define channel_op()		(nvhost_get_chip_ops()->channel)
 #define syncpt_op()		(nvhost_get_chip_ops()->syncpt)
 #define intr_op()		(nvhost_get_chip_ops()->intr)
+#define cdma_op()		(nvhost_get_chip_ops()->cdma)
+#define cdma_pb_op()		(nvhost_get_chip_ops()->push_buffer)
 
 int nvhost_init_chip_support(struct nvhost_master *host);
 
diff --git a/drivers/video/tegra/host/dev.c b/drivers/video/tegra/host/dev.c
index 025a820..9dff8d8 100644
--- a/drivers/video/tegra/host/dev.c
+++ b/drivers/video/tegra/host/dev.c
@@ -19,6 +19,9 @@
  */
 
 #include <linux/module.h>
+#include <linux/nvhost.h>
+#include <linux/list.h>
+#include <linux/slab.h>
 #include "host1x/host1x.h"
 #include "nvhost_acm.h"
 
@@ -96,6 +99,70 @@ void host1x_idle(struct platform_device *dev)
 }
 EXPORT_SYMBOL(host1x_idle);
 
+/* host1x device list in debug-fs dump of host1x and client device
+ * as well as channel state */
+struct nvhost_device_list {
+	struct list_head list;
+	struct platform_device *pdev;
+};
+
+/* HEAD for the host1x device list */
+static struct nvhost_device_list ndev_head;
+
+/* Constructor for the host1x device list */
+void nvhost_device_list_init(void)
+{
+	INIT_LIST_HEAD(&ndev_head.list);
+}
+
+/* Adds a device to tail of host1x device list */
+int nvhost_device_list_add(struct platform_device *pdev)
+{
+	struct nvhost_device_list *list;
+
+	list = kzalloc(sizeof(struct nvhost_device_list), GFP_KERNEL);
+	if (!list)
+		return -ENOMEM;
+
+	list->pdev = pdev;
+	list_add_tail(&list->list, &ndev_head.list);
+
+	return 0;
+}
+
+/* Iterator function for host1x device list
+ * It takes a fptr as an argument and calls that function for each
+ * device in the list */
+void nvhost_device_list_for_all(void *data,
+	int (*fptr)(struct platform_device *pdev, void *fdata))
+{
+	struct nvhost_device_list *nlist;
+	int ret;
+
+	list_for_each_entry(nlist, &ndev_head.list, list) {
+		if (nlist && nlist->pdev && fptr) {
+			ret = fptr(nlist->pdev, data);
+			if (ret) {
+				pr_info("%s: iterator error\n", __func__);
+				break;
+			}
+		}
+	}
+}
+
+/* Removes a device from the host1x device list */
+void nvhost_device_list_remove(struct platform_device *pdev)
+{
+	struct nvhost_device_list *nlist;
+	list_for_each_entry(nlist, &ndev_head.list, list) {
+		if (nlist && nlist->pdev == pdev) {
+			list_del(&nlist->list);
+			kfree(nlist);
+			return;
+		}
+	}
+}
+
 MODULE_AUTHOR("Terje Bergstrom <tbergstrom@nvidia.com>");
 MODULE_DESCRIPTION("Host1x driver for Tegra products");
 MODULE_VERSION("1.0");
diff --git a/drivers/video/tegra/host/dev.h b/drivers/video/tegra/host/dev.h
new file mode 100644
index 0000000..12dfda5
--- /dev/null
+++ b/drivers/video/tegra/host/dev.h
@@ -0,0 +1,33 @@
+/*
+ * drivers/video/tegra/host/dev.h
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef NVHOST_DEV_H
+#define NVHOST_DEV_H
+
+#include "host1x/host1x.h"
+
+struct platform_device;
+
+void nvhost_device_list_init(void);
+int nvhost_device_list_add(struct platform_device *pdev);
+void nvhost_device_list_for_all(void *data,
+	int (*fptr)(struct platform_device *pdev, void *fdata));
+struct platform_device *nvhost_device_list_match_by_id(u32 id);
+void nvhost_device_list_remove(struct platform_device *pdev);
+
+#endif
diff --git a/drivers/video/tegra/host/dmabuf.c b/drivers/video/tegra/host/dmabuf.c
new file mode 100644
index 0000000..8af79b7
--- /dev/null
+++ b/drivers/video/tegra/host/dmabuf.c
@@ -0,0 +1,151 @@
+/*
+ * drivers/video/tegra/host/dmabuf.c
+ *
+ * Tegra host1x DMA-BUF support
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/dma-buf.h>
+#include <linux/nvhost.h>
+#include "chip_support.h"
+#include "nvhost_memmgr.h"
+
+static inline struct dma_buf_attachment *to_dmabuf_att(struct mem_handle *h)
+{
+	return (struct dma_buf_attachment *)(((u32)h) & ~0x3);
+}
+
+static inline struct dma_buf *to_dmabuf(struct mem_handle *h)
+{
+	return to_dmabuf_att(h)->dmabuf;
+}
+
+static inline int to_dmabuf_fd(u32 id)
+{
+	return nvhost_memmgr_id(id) >> 2;
+}
+struct mem_handle *nvhost_dmabuf_alloc(size_t size, size_t align, int flags)
+{
+	/* TODO: Add allocation via DMA Mapping API */
+	return NULL;
+}
+
+void nvhost_dmabuf_put(struct mem_handle *handle)
+{
+	struct dma_buf_attachment *attach = to_dmabuf_att(handle);
+	struct dma_buf *dmabuf = attach->dmabuf;
+	dma_buf_detach(dmabuf, attach);
+	dma_buf_put(dmabuf);
+}
+
+struct sg_table *nvhost_dmabuf_pin(struct mem_handle *handle)
+{
+	return dma_buf_map_attachment(to_dmabuf_att(handle),
+				DMA_BIDIRECTIONAL);
+}
+
+void nvhost_dmabuf_unpin(struct mem_handle *handle, struct sg_table *sgt)
+{
+	dma_buf_unmap_attachment(to_dmabuf_att(handle), sgt, DMA_BIDIRECTIONAL);
+}
+
+
+void *nvhost_dmabuf_mmap(struct mem_handle *handle)
+{
+	return dma_buf_vmap(to_dmabuf(handle));
+}
+
+void nvhost_dmabuf_munmap(struct mem_handle *handle, void *addr)
+{
+	dma_buf_vunmap(to_dmabuf(handle), addr);
+}
+
+void *nvhost_dmabuf_kmap(struct mem_handle *handle, unsigned int pagenum)
+{
+	return dma_buf_kmap(to_dmabuf(handle), pagenum);
+}
+
+void nvhost_dmabuf_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr)
+{
+	dma_buf_kunmap(to_dmabuf(handle), pagenum, addr);
+}
+
+struct mem_handle *nvhost_dmabuf_get(u32 id, struct platform_device *dev)
+{
+	struct mem_handle *h;
+	struct dma_buf *buf;
+
+	buf = dma_buf_get(to_dmabuf_fd(id));
+	if (IS_ERR_OR_NULL(buf))
+		return (struct mem_handle *)buf;
+
+	h = (struct mem_handle *)dma_buf_attach(buf, &dev->dev);
+	if (IS_ERR_OR_NULL(h))
+		dma_buf_put(buf);
+
+	return (struct mem_handle *) ((u32)h | mem_mgr_type_dmabuf);
+}
+
+int nvhost_dmabuf_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		long unsigned id_type_mask,
+		long unsigned id_type,
+		u32 count,
+		struct nvhost_job_unpin_data *unpin_data,
+		dma_addr_t *phys_addr)
+{
+	int i;
+	int pin_count = 0;
+	int err;
+
+	for (i = 0; i < count; i++) {
+		struct mem_handle *handle;
+		struct sg_table *sgt;
+
+		if ((ids[i] & id_type_mask) != id_type)
+			continue;
+
+		handle = nvhost_dmabuf_get(ids[i], dev);
+
+		if (IS_ERR(handle)) {
+			err = PTR_ERR(handle);
+			goto fail;
+		}
+
+		sgt = nvhost_dmabuf_pin(handle);
+		if (IS_ERR_OR_NULL(sgt)) {
+			nvhost_dmabuf_put(handle);
+			err = PTR_ERR(sgt);
+			goto fail;
+		}
+
+		phys_addr[i] = sg_dma_address(sgt->sgl);
+
+		unpin_data[pin_count].h = handle;
+		unpin_data[pin_count].mem = sgt;
+		pin_count++;
+	}
+	return pin_count;
+fail:
+	while (pin_count) {
+		pin_count--;
+		nvhost_dmabuf_unpin(unpin_data[pin_count].h,
+				unpin_data[pin_count].mem);
+		nvhost_dmabuf_put(unpin_data[pin_count].h);
+	}
+	return err;
+}
diff --git a/drivers/video/tegra/host/dmabuf.h b/drivers/video/tegra/host/dmabuf.h
new file mode 100644
index 0000000..d31827b
--- /dev/null
+++ b/drivers/video/tegra/host/dmabuf.h
@@ -0,0 +1,45 @@
+/*
+ * drivers/video/tegra/host/dmabuf.h
+ *
+ * Tegra host1x dmabuf memory manager
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_DMABUF_H
+#define __NVHOST_DMABUF_H
+
+#include "nvhost_memmgr.h"
+
+struct platform_device;
+
+struct mem_handle *nvhost_dmabuf_alloc(size_t size, size_t align, int flags);
+void nvhost_dmabuf_put(struct mem_handle *handle);
+struct sg_table *nvhost_dmabuf_pin(struct mem_handle *handle);
+void nvhost_dmabuf_unpin(struct mem_handle *handle, struct sg_table *sgt);
+void *nvhost_dmabuf_mmap(struct mem_handle *handle);
+void nvhost_dmabuf_munmap(struct mem_handle *handle, void *addr);
+void *nvhost_dmabuf_kmap(struct mem_handle *handle, unsigned int pagenum);
+void nvhost_dmabuf_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr);
+int nvhost_dmabuf_get(u32 id, struct platform_device *dev);
+int nvhost_dmabuf_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		long unsigned id_type_mask,
+		long unsigned id_type,
+		u32 count,
+		struct nvhost_job_unpin_data *unpin_data,
+		dma_addr_t *phys_addr);
+#endif
diff --git a/drivers/video/tegra/host/host1x/host1x.c b/drivers/video/tegra/host/host1x/host1x.c
index 766931b..8033b2d 100644
--- a/drivers/video/tegra/host/host1x/host1x.c
+++ b/drivers/video/tegra/host/host1x/host1x.c
@@ -29,8 +29,10 @@
 #include <linux/of.h>
 #include <linux/nvhost.h>
 
+#include "dev.h"
 #include "host1x/host1x.h"
 #include "nvhost_acm.h"
+#include "nvhost_channel.h"
 #include "chip_support.h"
 
 #define DRIVER_NAME		"tegra-host1x"
@@ -66,6 +68,16 @@ static int clock_off_host(struct platform_device *dev)
 	return 0;
 }
 
+struct nvhost_channel *nvhost_alloc_channel(struct platform_device *dev)
+{
+	return host_device_op().alloc_nvhost_channel(dev);
+}
+
+void nvhost_free_channel(struct nvhost_channel *ch)
+{
+	host_device_op().free_nvhost_channel(ch);
+}
+
 static void nvhost_free_resources(struct nvhost_master *host)
 {
 	kfree(host->intr.syncpt);
@@ -167,6 +179,11 @@ static int __devinit nvhost_probe(struct platform_device *dev)
 	for (i = 0; i < pdata->num_clks; i++)
 		clk_disable_unprepare(pdata->clk[i]);
 
+	nvhost_device_list_init();
+	err = nvhost_device_list_add(dev);
+	if (err)
+		goto fail;
+
 	dev_info(&dev->dev, "initialized\n");
 
 	return 0;
diff --git a/drivers/video/tegra/host/host1x/host1x.h b/drivers/video/tegra/host/host1x/host1x.h
index af9bfef..28ec916 100644
--- a/drivers/video/tegra/host/host1x/host1x.h
+++ b/drivers/video/tegra/host/host1x/host1x.h
@@ -30,17 +30,23 @@
 #define TRACE_MAX_LENGTH	128U
 #define IFACE_NAME		"nvhost"
 
+struct nvhost_channel;
+
 struct nvhost_master {
 	void __iomem *aperture;
 	void __iomem *sync_aperture;
 	struct nvhost_syncpt syncpt;
 	struct nvhost_intr intr;
 	struct platform_device *dev;
+	atomic_t clientid;
 	struct host1x_device_info info;
 };
 
 extern struct nvhost_master *nvhost;
 
+struct nvhost_channel *nvhost_alloc_channel(struct platform_device *dev);
+void nvhost_free_channel(struct nvhost_channel *ch);
+
 static inline void *nvhost_get_private_data(struct platform_device *_dev)
 {
 	struct nvhost_device_data *pdata =
diff --git a/drivers/video/tegra/host/host1x/host1x01.c b/drivers/video/tegra/host/host1x/host1x01.c
index 5bf0e6e..cd97339 100644
--- a/drivers/video/tegra/host/host1x/host1x01.c
+++ b/drivers/video/tegra/host/host1x/host1x01.c
@@ -18,22 +18,51 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/init.h>
+#include <linux/clk.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/nvhost.h>
 
 #include "host1x/host1x01.h"
 #include "host1x/host1x.h"
+#include "nvhost_channel.h"
 #include "host1x/host1x01_hardware.h"
 #include "chip_support.h"
 
+static int t20_num_alloc_channels;
+
+static void t20_free_nvhost_channel(struct nvhost_channel *ch)
+{
+	nvhost_free_channel_internal(ch, &t20_num_alloc_channels);
+}
+
+static
+struct nvhost_channel *t20_alloc_nvhost_channel(struct platform_device *dev)
+{
+	struct nvhost_device_data *pdata = platform_get_drvdata(dev);
+	return nvhost_alloc_channel_internal(pdata->index,
+		nvhost_get_host(dev)->info.nb_channels,
+		&t20_num_alloc_channels);
+}
+
+#include "host1x/host1x_channel.c"
+#include "host1x/host1x_cdma.c"
 #include "host1x/host1x_syncpt.c"
 #include "host1x/host1x_intr.c"
 
 int nvhost_init_host1x01_support(struct nvhost_master *host,
 	struct nvhost_chip_support *op)
 {
+	op->channel = host1x_channel_ops;
+	op->cdma = host1x_cdma_ops;
+	op->push_buffer = host1x_pushbuffer_ops;
 	host->sync_aperture = host->aperture + HOST1X_CHANNEL_SYNC_REG_BASE;
 	op->syncpt = host1x_syncpt_ops;
 	op->intr = host1x_intr_ops;
 
+	op->nvhost_dev.alloc_nvhost_channel = t20_alloc_nvhost_channel;
+	op->nvhost_dev.free_nvhost_channel = t20_free_nvhost_channel;
+
 	return 0;
 }
diff --git a/drivers/video/tegra/host/host1x/host1x01_hardware.h b/drivers/video/tegra/host/host1x/host1x01_hardware.h
index 0da7e06..0065b24 100644
--- a/drivers/video/tegra/host/host1x/host1x01_hardware.h
+++ b/drivers/video/tegra/host/host1x/host1x01_hardware.h
@@ -23,7 +23,9 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include "hw_host1x01_channel.h"
 #include "hw_host1x01_sync.h"
+#include "hw_host1x01_uclass.h"
 
 /* channel registers */
 #define NV_HOST1X_CHANNEL_MAP_SIZE_BYTES 16384
@@ -33,4 +35,123 @@
 #define HOST1X_CHANNEL_SYNC_REG_BASE   0x3000
 #define NV_HOST1X_NB_MLOCKS 16
 
+static inline u32 nvhost_class_host_wait_syncpt(
+	unsigned indx, unsigned threshold)
+{
+	return host1x_uclass_wait_syncpt_indx_f(indx)
+		| host1x_uclass_wait_syncpt_thresh_f(threshold);
+}
+
+static inline u32 nvhost_class_host_load_syncpt_base(
+	unsigned indx, unsigned threshold)
+{
+	return host1x_uclass_load_syncpt_base_base_indx_f(indx)
+		| host1x_uclass_load_syncpt_base_value_f(threshold);
+}
+
+static inline u32 nvhost_class_host_wait_syncpt_base(
+	unsigned indx, unsigned base_indx, unsigned offset)
+{
+	return host1x_uclass_wait_syncpt_base_indx_f(indx)
+		| host1x_uclass_wait_syncpt_base_base_indx_f(base_indx)
+		| host1x_uclass_wait_syncpt_base_offset_f(offset);
+}
+
+static inline u32 nvhost_class_host_incr_syncpt_base(
+	unsigned base_indx, unsigned offset)
+{
+	return host1x_uclass_incr_syncpt_base_base_indx_f(base_indx)
+		| host1x_uclass_incr_syncpt_base_offset_f(offset);
+}
+
+static inline u32 nvhost_class_host_incr_syncpt(
+	unsigned cond, unsigned indx)
+{
+	return host1x_uclass_incr_syncpt_cond_f(cond)
+		| host1x_uclass_incr_syncpt_indx_f(indx);
+}
+
+static inline u32 nvhost_class_host_indoff_reg_write(
+	unsigned mod_id, unsigned offset, bool auto_inc)
+{
+	u32 v = host1x_uclass_indoff_indbe_f(0xf)
+		| host1x_uclass_indoff_indmodid_f(mod_id)
+		| host1x_uclass_indoff_indroffset_f(offset);
+	if (auto_inc)
+		v |= host1x_uclass_indoff_autoinc_f(1);
+	return v;
+}
+
+static inline u32 nvhost_class_host_indoff_reg_read(
+	unsigned mod_id, unsigned offset, bool auto_inc)
+{
+	u32 v = host1x_uclass_indoff_indmodid_f(mod_id)
+		| host1x_uclass_indoff_indroffset_f(offset)
+		| host1x_uclass_indoff_rwn_read_v();
+	if (auto_inc)
+		v |= host1x_uclass_indoff_autoinc_f(1);
+	return v;
+}
+
+
+/* cdma opcodes */
+static inline u32 nvhost_opcode_setclass(
+	unsigned class_id, unsigned offset, unsigned mask)
+{
+	return (0 << 28) | (offset << 16) | (class_id << 6) | mask;
+}
+
+static inline u32 nvhost_opcode_incr(unsigned offset, unsigned count)
+{
+	return (1 << 28) | (offset << 16) | count;
+}
+
+static inline u32 nvhost_opcode_nonincr(unsigned offset, unsigned count)
+{
+	return (2 << 28) | (offset << 16) | count;
+}
+
+static inline u32 nvhost_opcode_mask(unsigned offset, unsigned mask)
+{
+	return (3 << 28) | (offset << 16) | mask;
+}
+
+static inline u32 nvhost_opcode_imm(unsigned offset, unsigned value)
+{
+	return (4 << 28) | (offset << 16) | value;
+}
+
+static inline u32 nvhost_opcode_imm_incr_syncpt(unsigned cond, unsigned indx)
+{
+	return nvhost_opcode_imm(host1x_uclass_incr_syncpt_r(),
+		nvhost_class_host_incr_syncpt(cond, indx));
+}
+
+static inline u32 nvhost_opcode_restart(unsigned address)
+{
+	return (5 << 28) | (address >> 4);
+}
+
+static inline u32 nvhost_opcode_gather(unsigned count)
+{
+	return (6 << 28) | count;
+}
+
+static inline u32 nvhost_opcode_gather_nonincr(unsigned offset,	unsigned count)
+{
+	return (6 << 28) | (offset << 16) | BIT(15) | count;
+}
+
+static inline u32 nvhost_opcode_gather_incr(unsigned offset, unsigned count)
+{
+	return (6 << 28) | (offset << 16) | BIT(15) | BIT(14) | count;
+}
+
+#define NVHOST_OPCODE_NOOP nvhost_opcode_nonincr(0, 0)
+
+static inline u32 nvhost_mask2(unsigned x, unsigned y)
+{
+	return 1 | (1 << (y - x));
+}
+
 #endif
diff --git a/drivers/video/tegra/host/host1x/host1x_cdma.c b/drivers/video/tegra/host/host1x/host1x_cdma.c
new file mode 100644
index 0000000..07f0758
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x_cdma.c
@@ -0,0 +1,483 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x_cdma.c
+ *
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include "nvhost_acm.h"
+#include "nvhost_cdma.h"
+#include "nvhost_channel.h"
+#include "dev.h"
+#include "chip_support.h"
+#include "nvhost_memmgr.h"
+
+#include "host1x_cdma.h"
+
+static inline u32 host1x_channel_dmactrl(int stop, int get_rst, int init_get)
+{
+	return host1x_channel_dmactrl_dmastop_f(stop)
+		| host1x_channel_dmactrl_dmagetrst_f(get_rst)
+		| host1x_channel_dmactrl_dmainitget_f(init_get);
+}
+
+static void cdma_timeout_handler(struct work_struct *work);
+
+/*
+ * push_buffer
+ *
+ * The push buffer is a circular array of words to be fetched by command DMA.
+ * Note that it works slightly differently to the sync queue; fence == cur
+ * means that the push buffer is full, not empty.
+ */
+
+
+/**
+ * Reset to empty push buffer
+ */
+static void push_buffer_reset(struct push_buffer *pb)
+{
+	pb->fence = PUSH_BUFFER_SIZE - 8;
+	pb->cur = 0;
+}
+
+/**
+ * Init push buffer resources
+ */
+static void push_buffer_destroy(struct push_buffer *pb);
+static int push_buffer_init(struct push_buffer *pb)
+{
+	struct nvhost_cdma *cdma = pb_to_cdma(pb);
+	struct nvhost_master *master = cdma_to_dev(cdma);
+	pb->mapped = NULL;
+	pb->phys = 0;
+	pb->handle = NULL;
+
+	cdma_pb_op().reset(pb);
+
+	/* allocate and map pushbuffer memory */
+	pb->mapped = dma_alloc_writecombine(&master->dev->dev,
+			PUSH_BUFFER_SIZE + 4, &pb->phys, GFP_KERNEL);
+	if (IS_ERR_OR_NULL(pb->mapped)) {
+		pb->mapped = NULL;
+		goto fail;
+	}
+
+	/* memory for storing mem client and handles for each opcode pair */
+	pb->handle = kzalloc(NVHOST_GATHER_QUEUE_SIZE *
+				sizeof(struct mem_handle *),
+			GFP_KERNEL);
+	if (!pb->handle)
+		goto fail;
+
+	/* put the restart at the end of pushbuffer memory */
+	*(pb->mapped + (PUSH_BUFFER_SIZE >> 2)) =
+		nvhost_opcode_restart(pb->phys);
+
+	return 0;
+
+fail:
+	push_buffer_destroy(pb);
+	return -ENOMEM;
+}
+
+/**
+ * Clean up push buffer resources
+ */
+static void push_buffer_destroy(struct push_buffer *pb)
+{
+	struct nvhost_cdma *cdma = pb_to_cdma(pb);
+	struct nvhost_master *master = cdma_to_dev(cdma);
+
+	if (pb->phys != 0)
+		dma_free_writecombine(&master->dev->dev,
+				PUSH_BUFFER_SIZE + 4,
+				pb->mapped, pb->phys);
+
+	kfree(pb->handle);
+
+	pb->mapped = NULL;
+	pb->phys = 0;
+	pb->handle = 0;
+}
+
+/**
+ * Push two words to the push buffer
+ * Caller must ensure push buffer is not full
+ */
+static void push_buffer_push_to(struct push_buffer *pb,
+		struct mem_handle *handle,
+		u32 op1, u32 op2)
+{
+	u32 cur = pb->cur;
+	u32 *p = (u32 *)((u32)pb->mapped + cur);
+	u32 cur_mem = (cur/8) & (NVHOST_GATHER_QUEUE_SIZE - 1);
+	WARN_ON(cur == pb->fence);
+	*(p++) = op1;
+	*(p++) = op2;
+	pb->handle[cur_mem] = handle;
+	pb->cur = (cur + 8) & (PUSH_BUFFER_SIZE - 1);
+}
+
+/**
+ * Pop a number of two word slots from the push buffer
+ * Caller must ensure push buffer is not empty
+ */
+static void push_buffer_pop_from(struct push_buffer *pb,
+		unsigned int slots)
+{
+	/* Clear the mem references for old items from pb */
+	unsigned int i;
+	u32 fence_mem = pb->fence/8;
+	for (i = 0; i < slots; i++) {
+		int cur_fence_mem = (fence_mem+i)
+				& (NVHOST_GATHER_QUEUE_SIZE - 1);
+		pb->handle[cur_fence_mem] = NULL;
+	}
+	/* Advance the next write position */
+	pb->fence = (pb->fence + slots * 8) & (PUSH_BUFFER_SIZE - 1);
+}
+
+/**
+ * Return the number of two word slots free in the push buffer
+ */
+static u32 push_buffer_space(struct push_buffer *pb)
+{
+	return ((pb->fence - pb->cur) & (PUSH_BUFFER_SIZE - 1)) / 8;
+}
+
+static u32 push_buffer_putptr(struct push_buffer *pb)
+{
+	return pb->phys + pb->cur;
+}
+
+/*
+ * The syncpt incr buffer is filled with methods to increment syncpts, which
+ * is later GATHER-ed into the mainline PB. It's used when a timed out context
+ * is interleaved with other work, so needs to inline the syncpt increments
+ * to maintain the count (but otherwise does no work).
+ */
+
+/**
+ * Init timeout resources
+ */
+static int cdma_timeout_init(struct nvhost_cdma *cdma,
+				 u32 syncpt_id)
+{
+	if (syncpt_id == NVSYNCPT_INVALID)
+		return -EINVAL;
+
+	INIT_DELAYED_WORK(&cdma->timeout.wq, cdma_timeout_handler);
+	cdma->timeout.initialized = true;
+
+	return 0;
+}
+
+/**
+ * Clean up timeout resources
+ */
+static void cdma_timeout_destroy(struct nvhost_cdma *cdma)
+{
+	if (cdma->timeout.initialized)
+		cancel_delayed_work(&cdma->timeout.wq);
+	cdma->timeout.initialized = false;
+}
+
+/**
+ * Increment timedout buffer's syncpt via CPU.
+ */
+static void cdma_timeout_cpu_incr(struct nvhost_cdma *cdma, u32 getptr,
+				u32 syncpt_incrs, u32 syncval, u32 nr_slots)
+{
+	struct nvhost_master *dev = cdma_to_dev(cdma);
+	struct push_buffer *pb = &cdma->push_buffer;
+	u32 i, getidx;
+
+	for (i = 0; i < syncpt_incrs; i++)
+		nvhost_syncpt_cpu_incr(&dev->syncpt, cdma->timeout.syncpt_id);
+
+	/* after CPU incr, ensure shadow is up to date */
+	nvhost_syncpt_update_min(&dev->syncpt, cdma->timeout.syncpt_id);
+
+	/* NOP all the PB slots */
+	getidx = getptr - pb->phys;
+	while (nr_slots--) {
+		u32 *p = (u32 *)((u32)pb->mapped + getidx);
+		*(p++) = NVHOST_OPCODE_NOOP;
+		*(p++) = NVHOST_OPCODE_NOOP;
+		dev_dbg(&dev->dev->dev, "%s: NOP at 0x%x\n",
+			__func__, pb->phys + getidx);
+		getidx = (getidx + 8) & (PUSH_BUFFER_SIZE - 1);
+	}
+	wmb();
+}
+
+/**
+ * Start channel DMA
+ */
+static void cdma_start(struct nvhost_cdma *cdma)
+{
+	void __iomem *chan_regs = cdma_to_channel(cdma)->aperture;
+
+	if (cdma->running)
+		return;
+
+	cdma->last_put = cdma_pb_op().putptr(&cdma->push_buffer);
+
+	writel(host1x_channel_dmactrl(true, false, false),
+		chan_regs + host1x_channel_dmactrl_r());
+
+	/* set base, put, end pointer (all of memory) */
+	writel(0, chan_regs + host1x_channel_dmastart_r());
+	writel(cdma->last_put, chan_regs + host1x_channel_dmaput_r());
+	writel(0xFFFFFFFF, chan_regs + host1x_channel_dmaend_r());
+
+	/* reset GET */
+	writel(host1x_channel_dmactrl(true, true, true),
+		chan_regs + host1x_channel_dmactrl_r());
+
+	/* start the command DMA */
+	writel(host1x_channel_dmactrl(false, false, false),
+		chan_regs + host1x_channel_dmactrl_r());
+
+	cdma->running = true;
+}
+
+/**
+ * Similar to cdma_start(), but rather than starting from an idle
+ * state (where DMA GET is set to DMA PUT), on a timeout we restore
+ * DMA GET from an explicit value (so DMA may again be pending).
+ */
+static void cdma_timeout_restart(struct nvhost_cdma *cdma, u32 getptr)
+{
+	struct nvhost_master *dev = cdma_to_dev(cdma);
+	void __iomem *chan_regs = cdma_to_channel(cdma)->aperture;
+
+	if (cdma->running)
+		return;
+
+	cdma->last_put = cdma_pb_op().putptr(&cdma->push_buffer);
+
+	writel(host1x_channel_dmactrl(true, false, false),
+		chan_regs + host1x_channel_dmactrl_r());
+
+	/* set base, end pointer (all of memory) */
+	writel(0, chan_regs + host1x_channel_dmastart_r());
+	writel(0xFFFFFFFF, chan_regs + host1x_channel_dmaend_r());
+
+	/* set GET, by loading the value in PUT (then reset GET) */
+	writel(getptr, chan_regs + host1x_channel_dmaput_r());
+	writel(host1x_channel_dmactrl(true, true, true),
+		chan_regs + host1x_channel_dmactrl_r());
+
+	dev_dbg(&dev->dev->dev,
+		"%s: DMA GET 0x%x, PUT HW 0x%x / shadow 0x%x\n",
+		__func__,
+		readl(chan_regs + host1x_channel_dmaget_r()),
+		readl(chan_regs + host1x_channel_dmaput_r()),
+		cdma->last_put);
+
+	/* deassert GET reset and set PUT */
+	writel(host1x_channel_dmactrl(true, false, false),
+		chan_regs + host1x_channel_dmactrl_r());
+	writel(cdma->last_put, chan_regs + host1x_channel_dmaput_r());
+
+	/* start the command DMA */
+	writel(host1x_channel_dmactrl(false, false, false),
+		chan_regs + host1x_channel_dmactrl_r());
+
+	cdma->running = true;
+}
+
+/**
+ * Kick channel DMA into action by writing its PUT offset (if it has changed)
+ */
+static void cdma_kick(struct nvhost_cdma *cdma)
+{
+	u32 put;
+
+	put = cdma_pb_op().putptr(&cdma->push_buffer);
+
+	if (put != cdma->last_put) {
+		void __iomem *chan_regs = cdma_to_channel(cdma)->aperture;
+		writel(put, chan_regs + host1x_channel_dmaput_r());
+		cdma->last_put = put;
+	}
+}
+
+static void cdma_stop(struct nvhost_cdma *cdma)
+{
+	void __iomem *chan_regs = cdma_to_channel(cdma)->aperture;
+
+	mutex_lock(&cdma->lock);
+	if (cdma->running) {
+		nvhost_cdma_wait_locked(cdma, CDMA_EVENT_SYNC_QUEUE_EMPTY);
+		writel(host1x_channel_dmactrl(true, false, false),
+			chan_regs + host1x_channel_dmactrl_r());
+		cdma->running = false;
+	}
+	mutex_unlock(&cdma->lock);
+}
+
+/**
+ * Stops both channel's command processor and CDMA immediately.
+ * Also, tears down the channel and resets corresponding module.
+ */
+static void cdma_timeout_teardown_begin(struct nvhost_cdma *cdma)
+{
+	struct nvhost_master *dev = cdma_to_dev(cdma);
+	struct nvhost_channel *ch = cdma_to_channel(cdma);
+	u32 cmdproc_stop;
+
+	if (cdma->torndown && !cdma->running) {
+		dev_warn(&dev->dev->dev, "Already torn down\n");
+		return;
+	}
+
+	dev_dbg(&dev->dev->dev,
+		"begin channel teardown (channel id %d)\n", ch->chid);
+
+	cmdproc_stop = readl(dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+	cmdproc_stop |= BIT(ch->chid);
+	writel(cmdproc_stop, dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+
+	dev_dbg(&dev->dev->dev,
+		"%s: DMA GET 0x%x, PUT HW 0x%x / shadow 0x%x\n",
+		__func__,
+		readl(ch->aperture + host1x_channel_dmaget_r()),
+		readl(ch->aperture + host1x_channel_dmaput_r()),
+		cdma->last_put);
+
+	writel(host1x_channel_dmactrl(true, false, false),
+		ch->aperture + host1x_channel_dmactrl_r());
+
+	writel(BIT(ch->chid), dev->sync_aperture + host1x_sync_ch_teardown_r());
+
+	cdma->running = false;
+	cdma->torndown = true;
+}
+
+static void cdma_timeout_teardown_end(struct nvhost_cdma *cdma, u32 getptr)
+{
+	struct nvhost_master *dev = cdma_to_dev(cdma);
+	struct nvhost_channel *ch = cdma_to_channel(cdma);
+	u32 cmdproc_stop;
+
+	dev_dbg(&dev->dev->dev,
+		"end channel teardown (id %d, DMAGET restart = 0x%x)\n",
+		ch->chid, getptr);
+
+	cmdproc_stop = readl(dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+	cmdproc_stop &= ~(BIT(ch->chid));
+	writel(cmdproc_stop, dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+
+	cdma->torndown = false;
+	cdma_timeout_restart(cdma, getptr);
+}
+
+/**
+ * If this timeout fires, it indicates the current sync_queue entry has
+ * exceeded its TTL and the userctx should be timed out and remaining
+ * submits already issued cleaned up (future submits return an error).
+ */
+static void cdma_timeout_handler(struct work_struct *work)
+{
+	struct nvhost_cdma *cdma;
+	struct nvhost_master *dev;
+	struct nvhost_syncpt *sp;
+	struct nvhost_channel *ch;
+
+	u32 syncpt_val;
+
+	u32 prev_cmdproc, cmdproc_stop;
+
+	cdma = container_of(to_delayed_work(work), struct nvhost_cdma,
+			    timeout.wq);
+	dev = cdma_to_dev(cdma);
+	sp = &dev->syncpt;
+	ch = cdma_to_channel(cdma);
+
+	mutex_lock(&cdma->lock);
+
+	if (!cdma->timeout.clientid) {
+		dev_dbg(&dev->dev->dev,
+			 "cdma_timeout: expired, but has no clientid\n");
+		mutex_unlock(&cdma->lock);
+		return;
+	}
+
+	/* stop processing to get a clean snapshot */
+	prev_cmdproc = readl(dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+	cmdproc_stop = prev_cmdproc | BIT(ch->chid);
+	writel(cmdproc_stop, dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+
+	dev_dbg(&dev->dev->dev, "cdma_timeout: cmdproc was 0x%x is 0x%x\n",
+		prev_cmdproc, cmdproc_stop);
+
+	syncpt_val = nvhost_syncpt_update_min(&dev->syncpt,
+			cdma->timeout.syncpt_id);
+
+	/* has buffer actually completed? */
+	if ((s32)(syncpt_val - cdma->timeout.syncpt_val) >= 0) {
+		dev_dbg(&dev->dev->dev,
+			 "cdma_timeout: expired, but buffer had completed\n");
+		/* restore */
+		cmdproc_stop = prev_cmdproc & ~(BIT(ch->chid));
+		writel(cmdproc_stop,
+			dev->sync_aperture + host1x_sync_cmdproc_stop_r());
+		mutex_unlock(&cdma->lock);
+		return;
+	}
+
+	dev_warn(&dev->dev->dev,
+		"%s: timeout: %d (%s), HW thresh %d, done %d\n",
+		__func__,
+		cdma->timeout.syncpt_id,
+		syncpt_op().name(sp, cdma->timeout.syncpt_id),
+		syncpt_val, cdma->timeout.syncpt_val);
+
+	/* stop HW, resetting channel/module */
+	cdma_op().timeout_teardown_begin(cdma);
+
+	nvhost_cdma_update_sync_queue(cdma, sp, ch->dev);
+	mutex_unlock(&cdma->lock);
+}
+
+static const struct nvhost_cdma_ops host1x_cdma_ops = {
+	.start = cdma_start,
+	.stop = cdma_stop,
+	.kick = cdma_kick,
+
+	.timeout_init = cdma_timeout_init,
+	.timeout_destroy = cdma_timeout_destroy,
+	.timeout_teardown_begin = cdma_timeout_teardown_begin,
+	.timeout_teardown_end = cdma_timeout_teardown_end,
+	.timeout_cpu_incr = cdma_timeout_cpu_incr,
+};
+
+static const struct nvhost_pushbuffer_ops host1x_pushbuffer_ops = {
+	.reset = push_buffer_reset,
+	.init = push_buffer_init,
+	.destroy = push_buffer_destroy,
+	.push_to = push_buffer_push_to,
+	.pop_from = push_buffer_pop_from,
+	.space = push_buffer_space,
+	.putptr = push_buffer_putptr,
+};
+
diff --git a/drivers/video/tegra/host/host1x/host1x_cdma.h b/drivers/video/tegra/host/host1x/host1x_cdma.h
new file mode 100644
index 0000000..dc0d0b0
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x_cdma.h
@@ -0,0 +1,39 @@
+/*
+ * drivers/video/tegra/host/host1x/host1x_cdma.h
+ *
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2011-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_HOST1X_HOST1X_CDMA_H
+#define __NVHOST_HOST1X_HOST1X_CDMA_H
+
+/* Size of the sync queue. If it is too small, we won't be able to queue up
+ * many command buffers. If it is too large, we waste memory. */
+#define NVHOST_SYNC_QUEUE_SIZE 512
+
+/* Number of gathers we allow to be queued up per channel. Must be a
+ * power of two. Currently sized such that pushbuffer is 4KB (512*8B). */
+#define NVHOST_GATHER_QUEUE_SIZE 512
+
+/* 8 bytes per slot. (This number does not include the final RESTART.) */
+#define PUSH_BUFFER_SIZE (NVHOST_GATHER_QUEUE_SIZE * 8)
+
+/* 4K page containing GATHERed methods to increment channel syncpts
+ * and replaces the original timed out contexts GATHER slots */
+#define SYNCPT_INCR_BUFFER_SIZE_WORDS   (4096 / sizeof(u32))
+
+#endif
diff --git a/drivers/video/tegra/host/host1x/host1x_channel.c b/drivers/video/tegra/host/host1x/host1x_channel.c
new file mode 100644
index 0000000..78df954
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/host1x_channel.c
@@ -0,0 +1,150 @@
+/*
+ * drivers/video/tegra/host/host1x/channel_host1x.c
+ *
+ * Tegra host1x Channel
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/nvhost.h>
+#include "nvhost_channel.h"
+#include "dev.h"
+#include "nvhost_acm.h"
+#include <linux/slab.h>
+#include "nvhost_intr.h"
+
+static void submit_gathers(struct nvhost_job *job)
+{
+	/* push user gathers */
+	int i;
+	for (i = 0 ; i < job->num_gathers; i++) {
+		struct nvhost_job_gather *g = &job->gathers[i];
+		u32 op1 = nvhost_opcode_gather(g->words);
+		u32 op2 = g->mem_base + g->offset;
+		nvhost_cdma_push_gather(&job->ch->cdma,
+				job->gathers[i].ref,
+				job->gathers[i].offset,
+				op1, op2);
+	}
+}
+
+static int host1x_channel_submit(struct nvhost_job *job)
+{
+	struct nvhost_channel *ch = job->ch;
+	struct nvhost_syncpt *sp = &nvhost_get_host(job->ch->dev)->syncpt;
+	u32 user_syncpt_incrs = job->syncpt_incrs;
+	u32 prev_max = 0;
+	u32 syncval;
+	int err;
+	void *completed_waiter = NULL;
+	struct nvhost_device_data *pdata = platform_get_drvdata(ch->dev);
+
+	/* Turn on the client module and host1x */
+	nvhost_module_busy(ch->dev);
+
+	/* before error checks, return current max */
+	prev_max = job->syncpt_end =
+		nvhost_syncpt_read_max(sp, job->syncpt_id);
+
+	/* get submit lock */
+	err = mutex_lock_interruptible(&ch->submitlock);
+	if (err) {
+		nvhost_module_idle(ch->dev);
+		goto error;
+	}
+
+	completed_waiter = nvhost_intr_alloc_waiter();
+	if (!completed_waiter) {
+		nvhost_module_idle(ch->dev);
+		mutex_unlock(&ch->submitlock);
+		err = -ENOMEM;
+		goto error;
+	}
+
+	/* begin a CDMA submit */
+	err = nvhost_cdma_begin(&ch->cdma, job);
+	if (err) {
+		mutex_unlock(&ch->submitlock);
+		nvhost_module_idle(ch->dev);
+		goto error;
+	}
+
+	if (pdata->serialize) {
+		/* Force serialization by inserting a host wait for the
+		 * previous job to finish before this one can commence. */
+		nvhost_cdma_push(&ch->cdma,
+				nvhost_opcode_setclass(NV_HOST1X_CLASS_ID,
+					host1x_uclass_wait_syncpt_r(),
+					1),
+				nvhost_class_host_wait_syncpt(job->syncpt_id,
+					nvhost_syncpt_read_max(sp,
+						job->syncpt_id)));
+	}
+
+	syncval = nvhost_syncpt_incr_max(sp,
+			job->syncpt_id, user_syncpt_incrs);
+
+	job->syncpt_end = syncval;
+
+	/* add a setclass for modules that require it */
+	if (pdata->class)
+		nvhost_cdma_push(&ch->cdma,
+			nvhost_opcode_setclass(pdata->class, 0, 0),
+			NVHOST_OPCODE_NOOP);
+
+	submit_gathers(job);
+
+	/* end CDMA submit & stash pinned hMems into sync queue */
+	nvhost_cdma_end(&ch->cdma, job);
+
+	/* schedule a submit complete interrupt */
+	err = nvhost_intr_add_action(&nvhost_get_host(ch->dev)->intr,
+			job->syncpt_id, syncval,
+			NVHOST_INTR_ACTION_SUBMIT_COMPLETE, ch,
+			completed_waiter,
+			NULL);
+	completed_waiter = NULL;
+	WARN(err, "Failed to set submit complete interrupt");
+
+	mutex_unlock(&ch->submitlock);
+
+	return 0;
+
+error:
+	kfree(completed_waiter);
+	return err;
+}
+
+static inline void __iomem *host1x_channel_aperture(void __iomem *p, int ndx)
+{
+	p += ndx * NV_HOST1X_CHANNEL_MAP_SIZE_BYTES;
+	return p;
+}
+
+static int host1x_channel_init(struct nvhost_channel *ch,
+	struct nvhost_master *dev, int index)
+{
+	ch->chid = index;
+	mutex_init(&ch->reflock);
+	mutex_init(&ch->submitlock);
+
+	ch->aperture = host1x_channel_aperture(dev->aperture, index);
+	return 0;
+}
+
+static const struct nvhost_channel_ops host1x_channel_ops = {
+	.init = host1x_channel_init,
+	.submit = host1x_channel_submit,
+};
diff --git a/drivers/video/tegra/host/host1x/host1x_syncpt.c b/drivers/video/tegra/host/host1x/host1x_syncpt.c
index 57cc1b1..e47bd71 100644
--- a/drivers/video/tegra/host/host1x/host1x_syncpt.c
+++ b/drivers/video/tegra/host/host1x/host1x_syncpt.c
@@ -107,6 +107,16 @@ static void host1x_syncpt_cpu_incr(struct nvhost_syncpt *sp, u32 id)
 	wmb();
 }
 
+/* remove a wait pointed to by patch_addr */
+static int host1x_syncpt_patch_wait(struct nvhost_syncpt *sp,
+		void *patch_addr)
+{
+	u32 override = nvhost_class_host_wait_syncpt(
+			NVSYNCPT_GRAPHICS_HOST, 0);
+	__raw_writel(override, patch_addr);
+	return 0;
+}
+
 static const char *host1x_syncpt_name(struct nvhost_syncpt *sp, u32 id)
 {
 	struct host1x_device_info *info = &syncpt_to_dev(sp)->info;
@@ -151,6 +161,7 @@ static const struct nvhost_syncpt_ops host1x_syncpt_ops = {
 	.read_wait_base = host1x_syncpt_read_wait_base,
 	.update_min = host1x_syncpt_update_min,
 	.cpu_incr = host1x_syncpt_cpu_incr,
+	.patch_wait = host1x_syncpt_patch_wait,
 	.debug = host1x_syncpt_debug,
 	.name = host1x_syncpt_name,
 };
diff --git a/drivers/video/tegra/host/host1x/hw_host1x01_channel.h b/drivers/video/tegra/host/host1x/hw_host1x01_channel.h
new file mode 100644
index 0000000..ca2f9a0
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/hw_host1x01_channel.h
@@ -0,0 +1,182 @@
+/*
+ * drivers/video/tegra/host/host1x/hw_host1x_channel_host1x.h
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_channel_host1x_h__
+#define __hw_host1x_channel_host1x_h__
+/*This file is autogenerated.  Do not edit. */
+
+static inline u32 host1x_channel_fifostat_r(void)
+{
+	return 0x0;
+}
+static inline u32 host1x_channel_fifostat_cfempty_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_channel_fifostat_cfempty_f(u32 v)
+{
+	return (v & 0x1) << 10;
+}
+static inline u32 host1x_channel_fifostat_cfempty_m(void)
+{
+	return 0x1 << 10;
+}
+static inline u32 host1x_channel_fifostat_cfempty_v(u32 r)
+{
+	return (r >> 10) & 0x1;
+}
+static inline u32 host1x_channel_fifostat_cfempty_notempty_v(void)
+{
+	return 0;
+}
+static inline u32 host1x_channel_fifostat_cfempty_empty_v(void)
+{
+	return 1;
+}
+static inline u32 host1x_channel_fifostat_outfentries_s(void)
+{
+	return 5;
+}
+static inline u32 host1x_channel_fifostat_outfentries_f(u32 v)
+{
+	return (v & 0x1f) << 24;
+}
+static inline u32 host1x_channel_fifostat_outfentries_m(void)
+{
+	return 0x1f << 24;
+}
+static inline u32 host1x_channel_fifostat_outfentries_v(u32 r)
+{
+	return (r >> 24) & 0x1f;
+}
+static inline u32 host1x_channel_inddata_r(void)
+{
+	return 0xc;
+}
+static inline u32 host1x_channel_dmastart_r(void)
+{
+	return 0x14;
+}
+static inline u32 host1x_channel_dmaput_r(void)
+{
+	return 0x18;
+}
+static inline u32 host1x_channel_dmaget_r(void)
+{
+	return 0x1c;
+}
+static inline u32 host1x_channel_dmaend_r(void)
+{
+	return 0x20;
+}
+static inline u32 host1x_channel_dmactrl_r(void)
+{
+	return 0x24;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_f(u32 v)
+{
+	return (v & 0x1) << 0;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_m(void)
+{
+	return 0x1 << 0;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_run_v(void)
+{
+	return 0;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_stop_v(void)
+{
+	return 1;
+}
+static inline u32 host1x_channel_dmactrl_dmagetrst_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_channel_dmactrl_dmagetrst_f(u32 v)
+{
+	return (v & 0x1) << 1;
+}
+static inline u32 host1x_channel_dmactrl_dmagetrst_m(void)
+{
+	return 0x1 << 1;
+}
+static inline u32 host1x_channel_dmactrl_dmagetrst_v(u32 r)
+{
+	return (r >> 1) & 0x1;
+}
+static inline u32 host1x_channel_dmactrl_dmainitget_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_channel_dmactrl_dmainitget_f(u32 v)
+{
+	return (v & 0x1) << 2;
+}
+static inline u32 host1x_channel_dmactrl_dmainitget_m(void)
+{
+	return 0x1 << 2;
+}
+static inline u32 host1x_channel_dmactrl_dmainitget_v(u32 r)
+{
+	return (r >> 2) & 0x1;
+}
+
+#endif /* __hw_host1x_channel_host1x_h__ */
diff --git a/drivers/video/tegra/host/host1x/hw_host1x01_uclass.h b/drivers/video/tegra/host/host1x/hw_host1x01_uclass.h
new file mode 100644
index 0000000..ed6e4b7
--- /dev/null
+++ b/drivers/video/tegra/host/host1x/hw_host1x01_uclass.h
@@ -0,0 +1,474 @@
+/*
+ * drivers/video/tegra/host/host1x/hw_host1x_uclass_host1x.h
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_uclass_host1x_h__
+#define __hw_host1x_uclass_host1x_h__
+/*This file is autogenerated.  Do not edit. */
+
+static inline u32 host1x_uclass_incr_syncpt_r(void)
+{
+	return 0x0;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
+{
+	return (v & 0xff) << 8;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_m(void)
+{
+	return 0xff << 8;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_v(u32 r)
+{
+	return (r >> 8) & 0xff;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_immediate_v(void)
+{
+	return 0;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_op_done_v(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_rd_done_v(void)
+{
+	return 2;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_reg_wr_safe_v(void)
+{
+	return 3;
+}
+static inline u32 host1x_uclass_incr_syncpt_indx_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_incr_syncpt_indx_f(u32 v)
+{
+	return (v & 0xff) << 0;
+}
+static inline u32 host1x_uclass_incr_syncpt_indx_m(void)
+{
+	return 0xff << 0;
+}
+static inline u32 host1x_uclass_incr_syncpt_indx_v(u32 r)
+{
+	return (r >> 0) & 0xff;
+}
+static inline u32 host1x_uclass_wait_syncpt_r(void)
+{
+	return 0x8;
+}
+static inline u32 host1x_uclass_wait_syncpt_indx_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_wait_syncpt_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_indx_m(void)
+{
+	return 0xff << 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_indx_v(u32 r)
+{
+	return (r >> 24) & 0xff;
+}
+static inline u32 host1x_uclass_wait_syncpt_thresh_s(void)
+{
+	return 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_thresh_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+static inline u32 host1x_uclass_wait_syncpt_thresh_m(void)
+{
+	return 0xffffff << 0;
+}
+static inline u32 host1x_uclass_wait_syncpt_thresh_v(u32 r)
+{
+	return (r >> 0) & 0xffffff;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_r(void)
+{
+	return 0x9;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_indx_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_indx_m(void)
+{
+	return 0xff << 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_indx_v(u32 r)
+{
+	return (r >> 24) & 0xff;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_base_indx_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 16;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_base_indx_m(void)
+{
+	return 0xff << 16;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_base_indx_v(u32 r)
+{
+	return (r >> 16) & 0xff;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_offset_s(void)
+{
+	return 16;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_offset_f(u32 v)
+{
+	return (v & 0xffff) << 0;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_offset_m(void)
+{
+	return 0xffff << 0;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_offset_v(u32 r)
+{
+	return (r >> 0) & 0xffff;
+}
+static inline u32 host1x_uclass_load_syncpt_base_r(void)
+{
+	return 0xb;
+}
+static inline u32 host1x_uclass_load_syncpt_base_base_indx_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_load_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_load_syncpt_base_base_indx_m(void)
+{
+	return 0xff << 24;
+}
+static inline u32 host1x_uclass_load_syncpt_base_base_indx_v(u32 r)
+{
+	return (r >> 24) & 0xff;
+}
+static inline u32 host1x_uclass_load_syncpt_base_value_s(void)
+{
+	return 24;
+}
+static inline u32 host1x_uclass_load_syncpt_base_value_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+static inline u32 host1x_uclass_load_syncpt_base_value_m(void)
+{
+	return 0xffffff << 0;
+}
+static inline u32 host1x_uclass_load_syncpt_base_value_v(u32 r)
+{
+	return (r >> 0) & 0xffffff;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_r(void)
+{
+	return 0xc;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_base_indx_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_base_indx_m(void)
+{
+	return 0xff << 24;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_base_indx_v(u32 r)
+{
+	return (r >> 24) & 0xff;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_offset_s(void)
+{
+	return 24;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_offset_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_offset_m(void)
+{
+	return 0xffffff << 0;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_offset_v(u32 r)
+{
+	return (r >> 0) & 0xffffff;
+}
+static inline u32 host1x_uclass_indoff_r(void)
+{
+	return 0x2d;
+}
+static inline u32 host1x_uclass_indoff_indbe_s(void)
+{
+	return 4;
+}
+static inline u32 host1x_uclass_indoff_indbe_f(u32 v)
+{
+	return (v & 0xf) << 28;
+}
+static inline u32 host1x_uclass_indoff_indbe_m(void)
+{
+	return 0xf << 28;
+}
+static inline u32 host1x_uclass_indoff_indbe_v(u32 r)
+{
+	return (r >> 28) & 0xf;
+}
+static inline u32 host1x_uclass_indoff_autoinc_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_indoff_autoinc_f(u32 v)
+{
+	return (v & 0x1) << 27;
+}
+static inline u32 host1x_uclass_indoff_autoinc_m(void)
+{
+	return 0x1 << 27;
+}
+static inline u32 host1x_uclass_indoff_autoinc_v(u32 r)
+{
+	return (r >> 27) & 0x1;
+}
+static inline u32 host1x_uclass_indoff_spool_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_indoff_spool_f(u32 v)
+{
+	return (v & 0x1) << 26;
+}
+static inline u32 host1x_uclass_indoff_spool_m(void)
+{
+	return 0x1 << 26;
+}
+static inline u32 host1x_uclass_indoff_spool_v(u32 r)
+{
+	return (r >> 26) & 0x1;
+}
+static inline u32 host1x_uclass_indoff_indoffset_s(void)
+{
+	return 24;
+}
+static inline u32 host1x_uclass_indoff_indoffset_f(u32 v)
+{
+	return (v & 0xffffff) << 2;
+}
+static inline u32 host1x_uclass_indoff_indoffset_m(void)
+{
+	return 0xffffff << 2;
+}
+static inline u32 host1x_uclass_indoff_indoffset_v(u32 r)
+{
+	return (r >> 2) & 0xffffff;
+}
+static inline u32 host1x_uclass_indoff_indmodid_s(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_indoff_indmodid_f(u32 v)
+{
+	return (v & 0xff) << 18;
+}
+static inline u32 host1x_uclass_indoff_indmodid_m(void)
+{
+	return 0xff << 18;
+}
+static inline u32 host1x_uclass_indoff_indmodid_v(u32 r)
+{
+	return (r >> 18) & 0xff;
+}
+static inline u32 host1x_uclass_indoff_indmodid_host1x_v(void)
+{
+	return 0;
+}
+static inline u32 host1x_uclass_indoff_indmodid_mpe_v(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_indoff_indmodid_vi_v(void)
+{
+	return 2;
+}
+static inline u32 host1x_uclass_indoff_indmodid_epp_v(void)
+{
+	return 3;
+}
+static inline u32 host1x_uclass_indoff_indmodid_isp_v(void)
+{
+	return 4;
+}
+static inline u32 host1x_uclass_indoff_indmodid_gr2d_v(void)
+{
+	return 5;
+}
+static inline u32 host1x_uclass_indoff_indmodid_gr3d_v(void)
+{
+	return 6;
+}
+static inline u32 host1x_uclass_indoff_indmodid_display_v(void)
+{
+	return 8;
+}
+static inline u32 host1x_uclass_indoff_indmodid_tvo_v(void)
+{
+	return 11;
+}
+static inline u32 host1x_uclass_indoff_indmodid_displayb_v(void)
+{
+	return 9;
+}
+static inline u32 host1x_uclass_indoff_indmodid_dsi_v(void)
+{
+	return 12;
+}
+static inline u32 host1x_uclass_indoff_indmodid_hdmi_v(void)
+{
+	return 10;
+}
+static inline u32 host1x_uclass_indoff_indmodid_dsib_v(void)
+{
+	return 16;
+}
+static inline u32 host1x_uclass_indoff_indroffset_s(void)
+{
+	return 16;
+}
+static inline u32 host1x_uclass_indoff_indroffset_f(u32 v)
+{
+	return (v & 0xffff) << 2;
+}
+static inline u32 host1x_uclass_indoff_indroffset_m(void)
+{
+	return 0xffff << 2;
+}
+static inline u32 host1x_uclass_indoff_indroffset_v(u32 r)
+{
+	return (r >> 2) & 0xffff;
+}
+static inline u32 host1x_uclass_indoff_acctype_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_indoff_acctype_f(u32 v)
+{
+	return (v & 0x1) << 1;
+}
+static inline u32 host1x_uclass_indoff_acctype_m(void)
+{
+	return 0x1 << 1;
+}
+static inline u32 host1x_uclass_indoff_acctype_v(u32 r)
+{
+	return (r >> 1) & 0x1;
+}
+static inline u32 host1x_uclass_indoff_acctype_reg_v(void)
+{
+	return 0;
+}
+static inline u32 host1x_uclass_indoff_acctype_fb_v(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_indoff_rwn_s(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_indoff_rwn_f(u32 v)
+{
+	return (v & 0x1) << 0;
+}
+static inline u32 host1x_uclass_indoff_rwn_m(void)
+{
+	return 0x1 << 0;
+}
+static inline u32 host1x_uclass_indoff_rwn_v(u32 r)
+{
+	return (r >> 0) & 0x1;
+}
+static inline u32 host1x_uclass_indoff_rwn_write_v(void)
+{
+	return 0;
+}
+static inline u32 host1x_uclass_indoff_rwn_read_v(void)
+{
+	return 1;
+}
+static inline u32 host1x_uclass_inddata_r(void)
+{
+	return 0x2e;
+}
+
+#endif /* __hw_host1x_uclass_host1x_h__ */
diff --git a/drivers/video/tegra/host/nvhost_cdma.c b/drivers/video/tegra/host/nvhost_cdma.c
new file mode 100644
index 0000000..e581836
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_cdma.c
@@ -0,0 +1,429 @@
+/*
+ * drivers/video/tegra/host/nvhost_cdma.c
+ *
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "nvhost_cdma.h"
+#include "nvhost_channel.h"
+#include "dev.h"
+#include "nvhost_memmgr.h"
+#include "chip_support.h"
+#include <asm/cacheflush.h>
+
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/interrupt.h>
+
+/*
+ * TODO:
+ *   stats
+ *     - for figuring out what to optimize further
+ *   resizable push buffer
+ *     - some channels hardly need any, some channels (3d) could use more
+ */
+
+/**
+ * Add an entry to the sync queue.
+ */
+static void add_to_sync_queue(struct nvhost_cdma *cdma,
+			      struct nvhost_job *job,
+			      u32 nr_slots,
+			      u32 first_get)
+{
+	if (job->syncpt_id == NVSYNCPT_INVALID) {
+		dev_warn(&job->ch->dev->dev, "%s: Invalid syncpt\n",
+				__func__);
+		return;
+	}
+
+	job->first_get = first_get;
+	job->num_slots = nr_slots;
+	nvhost_job_get(job);
+	list_add_tail(&job->list, &cdma->sync_queue);
+}
+
+/**
+ * Return the status of the cdma's sync queue or push buffer for the given event
+ *  - sq empty: returns 1 for empty, 0 for not empty (as in "1 empty queue" :-)
+ *  - pb space: returns the number of free slots in the channel's push buffer
+ * Must be called with the cdma lock held.
+ */
+static unsigned int cdma_status_locked(struct nvhost_cdma *cdma,
+		enum cdma_event event)
+{
+	switch (event) {
+	case CDMA_EVENT_SYNC_QUEUE_EMPTY:
+		return list_empty(&cdma->sync_queue) ? 1 : 0;
+	case CDMA_EVENT_PUSH_BUFFER_SPACE: {
+		struct push_buffer *pb = &cdma->push_buffer;
+		return cdma_pb_op().space(pb);
+	}
+	default:
+		return 0;
+	}
+}
+
+/**
+ * Sleep (if necessary) until the requested event happens
+ *   - CDMA_EVENT_SYNC_QUEUE_EMPTY : sync queue is completely empty.
+ *     - Returns 1
+ *   - CDMA_EVENT_PUSH_BUFFER_SPACE : there is space in the push buffer
+ *     - Return the amount of space (> 0)
+ * Must be called with the cdma lock held.
+ */
+unsigned int nvhost_cdma_wait_locked(struct nvhost_cdma *cdma,
+		enum cdma_event event)
+{
+	for (;;) {
+		unsigned int space = cdma_status_locked(cdma, event);
+		if (space)
+			return space;
+
+		/* If somebody has managed to already start waiting, yield */
+		if (cdma->event != CDMA_EVENT_NONE) {
+			mutex_unlock(&cdma->lock);
+			schedule();
+			mutex_lock(&cdma->lock);
+			continue;
+		}
+		cdma->event = event;
+
+		mutex_unlock(&cdma->lock);
+		down(&cdma->sem);
+		mutex_lock(&cdma->lock);
+	}
+	return 0;
+}
+
+/**
+ * Start timer for a buffer submition that has completed yet.
+ * Must be called with the cdma lock held.
+ */
+static void cdma_start_timer_locked(struct nvhost_cdma *cdma,
+		struct nvhost_job *job)
+{
+	if (cdma->timeout.clientid) {
+		/* timer already started */
+		return;
+	}
+
+	cdma->timeout.clientid = job->clientid;
+	cdma->timeout.syncpt_id = job->syncpt_id;
+	cdma->timeout.syncpt_val = job->syncpt_end;
+	cdma->timeout.start_ktime = ktime_get();
+
+	schedule_delayed_work(&cdma->timeout.wq,
+			msecs_to_jiffies(job->timeout));
+}
+
+/**
+ * Stop timer when a buffer submition completes.
+ * Must be called with the cdma lock held.
+ */
+static void stop_cdma_timer_locked(struct nvhost_cdma *cdma)
+{
+	cancel_delayed_work(&cdma->timeout.wq);
+	cdma->timeout.clientid = 0;
+}
+
+/**
+ * For all sync queue entries that have already finished according to the
+ * current sync point registers:
+ *  - unpin & unref their mems
+ *  - pop their push buffer slots
+ *  - remove them from the sync queue
+ * This is normally called from the host code's worker thread, but can be
+ * called manually if necessary.
+ * Must be called with the cdma lock held.
+ */
+static void update_cdma_locked(struct nvhost_cdma *cdma)
+{
+	bool signal = false;
+	struct nvhost_master *dev = cdma_to_dev(cdma);
+	struct nvhost_syncpt *sp = &dev->syncpt;
+	struct nvhost_job *job, *n;
+
+	/* If CDMA is stopped, queue is cleared and we can return */
+	if (!cdma->running)
+		return;
+
+	/*
+	 * Walk the sync queue, reading the sync point registers as necessary,
+	 * to consume as many sync queue entries as possible without blocking
+	 */
+	list_for_each_entry_safe(job, n, &cdma->sync_queue, list) {
+		/* Check whether this syncpt has completed, and bail if not */
+		if (!nvhost_syncpt_is_expired(sp,
+				job->syncpt_id, job->syncpt_end)) {
+			/* Start timer on next pending syncpt */
+			if (job->timeout)
+				cdma_start_timer_locked(cdma, job);
+			break;
+		}
+
+		/* Cancel timeout, when a buffer completes */
+		if (cdma->timeout.clientid)
+			stop_cdma_timer_locked(cdma);
+
+		/* Unpin the memory */
+		nvhost_job_unpin(job);
+
+		/* Pop push buffer slots */
+		if (job->num_slots) {
+			struct push_buffer *pb = &cdma->push_buffer;
+			cdma_pb_op().pop_from(pb, job->num_slots);
+			if (cdma->event == CDMA_EVENT_PUSH_BUFFER_SPACE)
+				signal = true;
+		}
+
+		list_del(&job->list);
+		nvhost_job_put(job);
+	}
+
+	if (list_empty(&cdma->sync_queue) &&
+				cdma->event == CDMA_EVENT_SYNC_QUEUE_EMPTY)
+			signal = true;
+
+	/* Wake up CdmaWait() if the requested event happened */
+	if (signal) {
+		cdma->event = CDMA_EVENT_NONE;
+		up(&cdma->sem);
+	}
+}
+
+void nvhost_cdma_update_sync_queue(struct nvhost_cdma *cdma,
+		struct nvhost_syncpt *syncpt, struct platform_device *dev)
+{
+	u32 get_restart;
+	u32 syncpt_incrs;
+	struct nvhost_job *job = NULL;
+	u32 syncpt_val;
+
+	syncpt_val = nvhost_syncpt_update_min(syncpt, cdma->timeout.syncpt_id);
+
+	dev_dbg(&dev->dev,
+		"%s: starting cleanup (thresh %d)\n",
+		__func__, syncpt_val);
+
+	/*
+	 * Move the sync_queue read pointer to the first entry that hasn't
+	 * completed based on the current HW syncpt value. It's likely there
+	 * won't be any (i.e. we're still at the head), but covers the case
+	 * where a syncpt incr happens just prior/during the teardown.
+	 */
+
+	dev_dbg(&dev->dev,
+		"%s: skip completed buffers still in sync_queue\n",
+		__func__);
+
+	list_for_each_entry(job, &cdma->sync_queue, list) {
+		if (syncpt_val < job->syncpt_end)
+			break;
+
+		nvhost_job_dump(&dev->dev, job);
+	}
+
+	/*
+	 * Walk the sync_queue, first incrementing with the CPU syncpts that
+	 * are partially executed (the first buffer) or fully skipped while
+	 * still in the current context (slots are also NOP-ed).
+	 *
+	 * At the point contexts are interleaved, syncpt increments must be
+	 * done inline with the pushbuffer from a GATHER buffer to maintain
+	 * the order (slots are modified to be a GATHER of syncpt incrs).
+	 *
+	 * Note: save in get_restart the location where the timed out buffer
+	 * started in the PB, so we can start the refetch from there (with the
+	 * modified NOP-ed PB slots). This lets things appear to have completed
+	 * properly for this buffer and resources are freed.
+	 */
+
+	dev_dbg(&dev->dev,
+		"%s: perform CPU incr on pending same ctx buffers\n",
+		__func__);
+
+	get_restart = cdma->last_put;
+	if (!list_empty(&cdma->sync_queue))
+		get_restart = job->first_get;
+
+	/* do CPU increments as long as this context continues */
+	list_for_each_entry_from(job, &cdma->sync_queue, list) {
+		/* different context, gets us out of this loop */
+		if (job->clientid != cdma->timeout.clientid)
+			break;
+
+		/* won't need a timeout when replayed */
+		job->timeout = 0;
+
+		syncpt_incrs = job->syncpt_end - syncpt_val;
+		dev_dbg(&dev->dev,
+			"%s: CPU incr (%d)\n", __func__, syncpt_incrs);
+
+		nvhost_job_dump(&dev->dev, job);
+
+		/* safe to use CPU to incr syncpts */
+		cdma_op().timeout_cpu_incr(cdma,
+				job->first_get,
+				syncpt_incrs,
+				job->syncpt_end,
+				job->num_slots);
+
+		syncpt_val += syncpt_incrs;
+	}
+
+	list_for_each_entry_from(job, &cdma->sync_queue, list)
+		if (job->clientid == cdma->timeout.clientid)
+			job->timeout = 500;
+
+	dev_dbg(&dev->dev,
+		"%s: finished sync_queue modification\n", __func__);
+
+	/* roll back DMAGET and start up channel again */
+	cdma_op().timeout_teardown_end(cdma, get_restart);
+}
+
+/**
+ * Create a cdma
+ */
+int nvhost_cdma_init(struct nvhost_cdma *cdma)
+{
+	int err;
+	struct push_buffer *pb = &cdma->push_buffer;
+	mutex_init(&cdma->lock);
+	sema_init(&cdma->sem, 0);
+
+	INIT_LIST_HEAD(&cdma->sync_queue);
+
+	cdma->event = CDMA_EVENT_NONE;
+	cdma->running = false;
+	cdma->torndown = false;
+
+	err = cdma_pb_op().init(pb);
+	if (err)
+		return err;
+	return 0;
+}
+
+/**
+ * Destroy a cdma
+ */
+void nvhost_cdma_deinit(struct nvhost_cdma *cdma)
+{
+	struct push_buffer *pb = &cdma->push_buffer;
+
+	if (cdma->running) {
+		pr_warn("%s: CDMA still running\n",
+				__func__);
+	} else {
+		cdma_pb_op().destroy(pb);
+		cdma_op().timeout_destroy(cdma);
+	}
+}
+
+/**
+ * Begin a cdma submit
+ */
+int nvhost_cdma_begin(struct nvhost_cdma *cdma, struct nvhost_job *job)
+{
+	mutex_lock(&cdma->lock);
+
+	if (job->timeout) {
+		/* init state on first submit with timeout value */
+		if (!cdma->timeout.initialized) {
+			int err;
+			err = cdma_op().timeout_init(cdma,
+				job->syncpt_id);
+			if (err) {
+				mutex_unlock(&cdma->lock);
+				return err;
+			}
+		}
+	}
+	if (!cdma->running)
+		cdma_op().start(cdma);
+
+	cdma->slots_free = 0;
+	cdma->slots_used = 0;
+	cdma->first_get = cdma_pb_op().putptr(&cdma->push_buffer);
+	return 0;
+}
+
+/**
+ * Push two words into a push buffer slot
+ * Blocks as necessary if the push buffer is full.
+ */
+void nvhost_cdma_push(struct nvhost_cdma *cdma, u32 op1, u32 op2)
+{
+	nvhost_cdma_push_gather(cdma, NULL, 0, op1, op2);
+}
+
+/**
+ * Push two words into a push buffer slot
+ * Blocks as necessary if the push buffer is full.
+ */
+void nvhost_cdma_push_gather(struct nvhost_cdma *cdma,
+		struct mem_handle *handle,
+		u32 offset, u32 op1, u32 op2)
+{
+	u32 slots_free = cdma->slots_free;
+	struct push_buffer *pb = &cdma->push_buffer;
+
+	if (slots_free == 0) {
+		cdma_op().kick(cdma);
+		slots_free = nvhost_cdma_wait_locked(cdma,
+				CDMA_EVENT_PUSH_BUFFER_SPACE);
+	}
+	cdma->slots_free = slots_free - 1;
+	cdma->slots_used++;
+	cdma_pb_op().push_to(pb, handle, op1, op2);
+}
+
+/**
+ * End a cdma submit
+ * Kick off DMA, add job to the sync queue, and a number of slots to be freed
+ * from the pushbuffer. The handles for a submit must all be pinned at the same
+ * time, but they can be unpinned in smaller chunks.
+ */
+void nvhost_cdma_end(struct nvhost_cdma *cdma,
+		struct nvhost_job *job)
+{
+	bool was_idle = list_empty(&cdma->sync_queue);
+
+	cdma_op().kick(cdma);
+
+	add_to_sync_queue(cdma,
+			job,
+			cdma->slots_used,
+			cdma->first_get);
+
+	/* start timer on idle -> active transitions */
+	if (job->timeout && was_idle)
+		cdma_start_timer_locked(cdma, job);
+
+	mutex_unlock(&cdma->lock);
+}
+
+/**
+ * Update cdma state according to current sync point values
+ */
+void nvhost_cdma_update(struct nvhost_cdma *cdma)
+{
+	mutex_lock(&cdma->lock);
+	update_cdma_locked(cdma);
+	mutex_unlock(&cdma->lock);
+}
diff --git a/drivers/video/tegra/host/nvhost_cdma.h b/drivers/video/tegra/host/nvhost_cdma.h
new file mode 100644
index 0000000..ab40bf1
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_cdma.h
@@ -0,0 +1,109 @@
+/*
+ * drivers/video/tegra/host/nvhost_cdma.h
+ *
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_CDMA_H
+#define __NVHOST_CDMA_H
+
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+
+#include <linux/nvhost.h>
+#include <linux/list.h>
+
+struct nvhost_syncpt;
+struct nvhost_userctx_timeout;
+struct nvhost_job;
+struct mem_handle;
+
+/*
+ * cdma
+ *
+ * This is in charge of a host command DMA channel.
+ * Sends ops to a push buffer, and takes responsibility for unpinning
+ * (& possibly freeing) of memory after those ops have completed.
+ * Producer:
+ *	begin
+ *		push - send ops to the push buffer
+ *	end - start command DMA and enqueue handles to be unpinned
+ * Consumer:
+ *	update - call to update sync queue and push buffer, unpin memory
+ */
+
+struct push_buffer {
+	u32 *mapped;			/* mapped pushbuffer memory */
+	dma_addr_t phys;		/* physical address of pushbuffer */
+	u32 fence;			/* index we've written */
+	u32 cur;			/* index to write to */
+	struct mem_handle **handle;	/* handle for each opcode pair */
+};
+
+struct buffer_timeout {
+	struct delayed_work wq;		/* work queue */
+	bool initialized;		/* timer one-time setup flag */
+	u32 syncpt_id;			/* buffer completion syncpt id */
+	u32 syncpt_val;			/* syncpt value when completed */
+	ktime_t start_ktime;		/* starting time */
+	/* context timeout information */
+	int clientid;
+};
+
+enum cdma_event {
+	CDMA_EVENT_NONE,		/* not waiting for any event */
+	CDMA_EVENT_SYNC_QUEUE_EMPTY,	/* wait for empty sync queue */
+	CDMA_EVENT_PUSH_BUFFER_SPACE	/* wait for space in push buffer */
+};
+
+struct nvhost_cdma {
+	struct mutex lock;		/* controls access to shared state */
+	struct semaphore sem;		/* signalled when event occurs */
+	enum cdma_event event;		/* event that sem is waiting for */
+	unsigned int slots_used;	/* pb slots used in current submit */
+	unsigned int slots_free;	/* pb slots free in current submit */
+	unsigned int first_get;		/* DMAGET value, where submit begins */
+	unsigned int last_put;		/* last value written to DMAPUT */
+	struct push_buffer push_buffer;	/* channel's push buffer */
+	struct list_head sync_queue;	/* job queue */
+	struct buffer_timeout timeout;	/* channel's timeout state/wq */
+	bool running;
+	bool torndown;
+};
+
+#define cdma_to_channel(cdma) container_of(cdma, struct nvhost_channel, cdma)
+#define cdma_to_dev(cdma) nvhost_get_host(cdma_to_channel(cdma)->dev)
+#define cdma_to_memmgr(cdma) ((cdma_to_dev(cdma))->memmgr)
+#define pb_to_cdma(pb) container_of(pb, struct nvhost_cdma, push_buffer)
+
+int	nvhost_cdma_init(struct nvhost_cdma *cdma);
+void	nvhost_cdma_deinit(struct nvhost_cdma *cdma);
+void	nvhost_cdma_stop(struct nvhost_cdma *cdma);
+int	nvhost_cdma_begin(struct nvhost_cdma *cdma, struct nvhost_job *job);
+void	nvhost_cdma_push(struct nvhost_cdma *cdma, u32 op1, u32 op2);
+void	nvhost_cdma_push_gather(struct nvhost_cdma *cdma,
+		struct mem_handle *handle, u32 offset, u32 op1, u32 op2);
+void	nvhost_cdma_end(struct nvhost_cdma *cdma,
+		struct nvhost_job *job);
+void	nvhost_cdma_update(struct nvhost_cdma *cdma);
+void	nvhost_cdma_peek(struct nvhost_cdma *cdma,
+		u32 dmaget, int slot, u32 *out);
+unsigned int nvhost_cdma_wait_locked(struct nvhost_cdma *cdma,
+		enum cdma_event event);
+void nvhost_cdma_update_sync_queue(struct nvhost_cdma *cdma,
+		struct nvhost_syncpt *syncpt, struct platform_device *dev);
+#endif
diff --git a/drivers/video/tegra/host/nvhost_channel.c b/drivers/video/tegra/host/nvhost_channel.c
new file mode 100644
index 0000000..a134f33
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_channel.c
@@ -0,0 +1,126 @@
+/*
+ * drivers/video/tegra/host/nvhost_channel.c
+ *
+ * Tegra host1x Channel
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "nvhost_channel.h"
+#include "dev.h"
+#include "nvhost_acm.h"
+#include "chip_support.h"
+
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#define NVHOST_CHANNEL_LOW_PRIO_MAX_WAIT 50
+
+int nvhost_channel_init(struct nvhost_channel *ch,
+		struct nvhost_master *dev, int index)
+{
+	int err;
+	struct nvhost_device_data *pdata = platform_get_drvdata(ch->dev);
+
+	/* Link platform_device to nvhost_channel */
+	err = channel_op().init(ch, dev, index);
+	if (err < 0) {
+		dev_err(&dev->dev->dev, "failed to init channel %d\n",
+				index);
+		return err;
+	}
+	pdata->channel = ch;
+
+	return 0;
+}
+
+int nvhost_channel_submit(struct nvhost_job *job)
+{
+	return channel_op().submit(job);
+}
+EXPORT_SYMBOL(nvhost_channel_submit);
+
+struct nvhost_channel *nvhost_getchannel(struct nvhost_channel *ch)
+{
+	int err = 0;
+	struct nvhost_device_data *pdata = platform_get_drvdata(ch->dev);
+
+	mutex_lock(&ch->reflock);
+	if (ch->refcount == 0) {
+		if (pdata->init)
+			pdata->init(ch->dev);
+		err = nvhost_cdma_init(&ch->cdma);
+	}
+	if (!err)
+		ch->refcount++;
+
+	mutex_unlock(&ch->reflock);
+
+	return err ? NULL : ch;
+}
+EXPORT_SYMBOL(nvhost_getchannel);
+
+void nvhost_putchannel(struct nvhost_channel *ch)
+{
+	mutex_lock(&ch->reflock);
+	if (ch->refcount == 1) {
+		channel_cdma_op().stop(&ch->cdma);
+		nvhost_cdma_deinit(&ch->cdma);
+		nvhost_module_suspend(ch->dev);
+	}
+	ch->refcount--;
+	mutex_unlock(&ch->reflock);
+}
+EXPORT_SYMBOL(nvhost_putchannel);
+
+int nvhost_channel_suspend(struct nvhost_channel *ch)
+{
+	int ret = 0;
+
+	mutex_lock(&ch->reflock);
+
+	if (ch->refcount) {
+		ret = nvhost_module_suspend(ch->dev);
+		if (!ret)
+			channel_cdma_op().stop(&ch->cdma);
+	}
+	mutex_unlock(&ch->reflock);
+
+	return ret;
+}
+
+struct nvhost_channel *nvhost_alloc_channel_internal(int chindex,
+	int max_channels, int *current_channel_count)
+{
+	struct nvhost_channel *ch = NULL;
+
+	if (chindex > max_channels ||
+	     (*current_channel_count + 1) > max_channels)
+		return NULL;
+
+	ch = kzalloc(sizeof(*ch), GFP_KERNEL);
+	if (ch == NULL)
+		return NULL;
+
+	(*current_channel_count)++;
+	return ch;
+}
+
+void nvhost_free_channel_internal(struct nvhost_channel *ch,
+	int *current_channel_count)
+{
+	kfree(ch);
+	(*current_channel_count)--;
+}
diff --git a/drivers/video/tegra/host/nvhost_channel.h b/drivers/video/tegra/host/nvhost_channel.h
new file mode 100644
index 0000000..fff94b1
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_channel.h
@@ -0,0 +1,65 @@
+/*
+ * drivers/video/tegra/host/nvhost_channel.h
+ *
+ * Tegra host1x Channel
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_CHANNEL_H
+#define __NVHOST_CHANNEL_H
+
+#include <linux/cdev.h>
+#include <linux/io.h>
+#include "nvhost_cdma.h"
+
+#define NVHOST_MAX_WAIT_CHECKS		256
+#define NVHOST_MAX_GATHERS		512
+#define NVHOST_MAX_HANDLES		1280
+#define NVHOST_MAX_POWERGATE_IDS	2
+
+struct nvhost_master;
+struct platform_device;
+struct nvhost_channel;
+
+struct nvhost_channel {
+	int refcount;
+	int chid;
+	u32 syncpt_id;
+	struct mutex reflock;
+	struct mutex submitlock;
+	void __iomem *aperture;
+	struct device *node;
+	struct platform_device *dev;
+	struct cdev cdev;
+	struct nvhost_cdma cdma;
+};
+
+int nvhost_channel_init(struct nvhost_channel *ch,
+	struct nvhost_master *dev, int index);
+
+struct nvhost_channel *nvhost_getchannel(struct nvhost_channel *ch);
+void nvhost_putchannel(struct nvhost_channel *ch);
+int nvhost_channel_suspend(struct nvhost_channel *ch);
+
+struct nvhost_channel *nvhost_alloc_channel_internal(int chindex,
+	int max_channels, int *current_channel_count);
+
+void nvhost_free_channel_internal(struct nvhost_channel *ch,
+	int *current_channel_count);
+
+int nvhost_channel_save_context(struct nvhost_channel *ch);
+
+#endif
diff --git a/drivers/video/tegra/host/nvhost_intr.c b/drivers/video/tegra/host/nvhost_intr.c
index 35dd7bb..0b451c8 100644
--- a/drivers/video/tegra/host/nvhost_intr.c
+++ b/drivers/video/tegra/host/nvhost_intr.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include "nvhost_channel.h"
 #include "chip_support.h"
 #include "host1x/host1x.h"
 
@@ -78,7 +79,7 @@ static void remove_completed_waiters(struct list_head *head, u32 sync,
 			struct list_head completed[NVHOST_INTR_ACTION_COUNT])
 {
 	struct list_head *dest;
-	struct nvhost_waitlist *waiter, *next;
+	struct nvhost_waitlist *waiter, *next, *prev;
 
 	list_for_each_entry_safe(waiter, next, head, list) {
 		if ((s32)(waiter->thresh - sync) > 0)
@@ -86,6 +87,17 @@ static void remove_completed_waiters(struct list_head *head, u32 sync,
 
 		dest = completed + waiter->action;
 
+		/* consolidate submit cleanups */
+		if (waiter->action == NVHOST_INTR_ACTION_SUBMIT_COMPLETE
+			&& !list_empty(dest)) {
+			prev = list_entry(dest->prev,
+					struct nvhost_waitlist, list);
+			if (prev->data == waiter->data) {
+				prev->count++;
+				dest = NULL;
+			}
+		}
+
 		/* PENDING->REMOVED or CANCELLED->HANDLED */
 		if (atomic_inc_return(&waiter->state) == WLS_HANDLED || !dest) {
 			list_del(&waiter->list);
@@ -107,6 +119,14 @@ void reset_threshold_interrupt(struct nvhost_intr *intr,
 	intr_op().enable_syncpt_intr(intr, id);
 }
 
+static void action_submit_complete(struct nvhost_waitlist *waiter)
+{
+	struct nvhost_channel *channel = waiter->data;
+	int nr_completed = waiter->count;
+
+	nvhost_cdma_update(&channel->cdma);
+	nvhost_module_idle_mult(channel->dev, nr_completed);
+}
 
 static void action_wakeup(struct nvhost_waitlist *waiter)
 {
@@ -125,6 +145,7 @@ static void action_wakeup_interruptible(struct nvhost_waitlist *waiter)
 typedef void (*action_handler)(struct nvhost_waitlist *waiter);
 
 static action_handler action_handlers[NVHOST_INTR_ACTION_COUNT] = {
+	action_submit_complete,
 	action_wakeup,
 	action_wakeup_interruptible,
 };
diff --git a/drivers/video/tegra/host/nvhost_intr.h b/drivers/video/tegra/host/nvhost_intr.h
index 31b0a38..601ea64 100644
--- a/drivers/video/tegra/host/nvhost_intr.h
+++ b/drivers/video/tegra/host/nvhost_intr.h
@@ -26,8 +26,16 @@
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
 
+struct nvhost_channel;
+
 enum nvhost_intr_action {
 	/**
+	 * Perform cleanup after a submit has completed.
+	 * 'data' points to a channel
+	 */
+	NVHOST_INTR_ACTION_SUBMIT_COMPLETE = 0,
+
+	/**
 	 * Wake up a  task.
 	 * 'data' points to a wait_queue_head_t
 	 */
diff --git a/drivers/video/tegra/host/nvhost_job.c b/drivers/video/tegra/host/nvhost_job.c
new file mode 100644
index 0000000..aaa51b5
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_job.c
@@ -0,0 +1,390 @@
+/*
+ * drivers/video/tegra/host/nvhost_job.c
+ *
+ * Tegra host1x Job
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <linux/err.h>
+#include <linux/vmalloc.h>
+#include <linux/scatterlist.h>
+#include <linux/nvhost.h>
+#include "nvhost_channel.h"
+#include "nvhost_syncpt.h"
+#include "dev.h"
+#include "nvhost_memmgr.h"
+#include "chip_support.h"
+
+/* Magic to use to fill freed handle slots */
+#define BAD_MAGIC 0xdeadbeef
+
+static size_t job_size(u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
+{
+	u32 num_unpins = num_cmdbufs + num_relocs;
+	s64 total;
+
+	if (num_relocs < 0 || num_waitchks < 0 || num_cmdbufs < 0)
+		return 0;
+
+	total = sizeof(struct nvhost_job)
+			+ num_relocs * sizeof(struct nvhost_reloc)
+			+ num_unpins * sizeof(struct nvhost_job_unpin_data)
+			+ num_waitchks * sizeof(struct nvhost_waitchk)
+			+ num_cmdbufs * sizeof(struct nvhost_job_gather);
+
+	if (total > ULONG_MAX)
+		return 0;
+	return (size_t)total;
+}
+
+
+static void init_fields(struct nvhost_job *job,
+		u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
+{
+	u32 num_unpins = num_cmdbufs + num_relocs;
+	void *mem = job;
+
+	/* First init state to zero */
+
+	/*
+	 * Redistribute memory to the structs.
+	 * Overflows and negative conditions have
+	 * already been checked in job_alloc().
+	 */
+	mem += sizeof(struct nvhost_job);
+	job->relocarray = num_relocs ? mem : NULL;
+	mem += num_relocs * sizeof(struct nvhost_reloc);
+	job->unpins = num_unpins ? mem : NULL;
+	mem += num_unpins * sizeof(struct nvhost_job_unpin_data);
+	job->waitchk = num_waitchks ? mem : NULL;
+	mem += num_waitchks * sizeof(struct nvhost_waitchk);
+	job->gathers = num_cmdbufs ? mem : NULL;
+	mem += num_cmdbufs * sizeof(struct nvhost_job_gather);
+	job->addr_phys = (num_cmdbufs || num_relocs) ? mem : NULL;
+
+	job->reloc_addr_phys = job->addr_phys;
+	job->gather_addr_phys = &job->addr_phys[num_relocs];
+}
+
+struct nvhost_job *nvhost_job_alloc(struct nvhost_channel *ch,
+		int num_cmdbufs, int num_relocs, int num_waitchks)
+{
+	struct nvhost_job *job = NULL;
+	size_t size = job_size(num_cmdbufs, num_relocs, num_waitchks);
+
+	if (!size)
+		return NULL;
+	job = vzalloc(size);
+	if (!job)
+		return NULL;
+
+	kref_init(&job->ref);
+	job->ch = ch;
+
+	init_fields(job, num_cmdbufs, num_relocs, num_waitchks);
+
+	return job;
+}
+EXPORT_SYMBOL(nvhost_job_alloc);
+
+void nvhost_job_get(struct nvhost_job *job)
+{
+	kref_get(&job->ref);
+}
+EXPORT_SYMBOL(nvhost_job_get);
+
+static void job_free(struct kref *ref)
+{
+	struct nvhost_job *job = container_of(ref, struct nvhost_job, ref);
+
+	vfree(job);
+}
+
+void nvhost_job_put(struct nvhost_job *job)
+{
+	kref_put(&job->ref, job_free);
+}
+EXPORT_SYMBOL(nvhost_job_put);
+
+void nvhost_job_add_gather(struct nvhost_job *job,
+		u32 mem_id, u32 words, u32 offset)
+{
+	struct nvhost_job_gather *cur_gather =
+			&job->gathers[job->num_gathers];
+
+	cur_gather->words = words;
+	cur_gather->mem_id = mem_id;
+	cur_gather->offset = offset;
+	job->num_gathers += 1;
+}
+EXPORT_SYMBOL(nvhost_job_add_gather);
+
+/*
+ * Check driver supplied waitchk structs for syncpt thresholds
+ * that have already been satisfied and NULL the comparison (to
+ * avoid a wrap condition in the HW).
+ */
+static int do_waitchks(struct nvhost_job *job, struct nvhost_syncpt *sp,
+		u32 patch_mem, struct mem_handle *h)
+{
+	int i;
+
+	/* compare syncpt vs wait threshold */
+	for (i = 0; i < job->num_waitchk; i++) {
+		struct nvhost_waitchk *wait = &job->waitchk[i];
+
+		/* validate syncpt id */
+		if (wait->syncpt_id > nvhost_syncpt_nb_pts(sp))
+			continue;
+
+		/* skip all other gathers */
+		if (patch_mem != wait->mem)
+			continue;
+
+		if (nvhost_syncpt_is_expired(sp,
+					wait->syncpt_id, wait->thresh)) {
+			void *patch_addr = NULL;
+
+			/*
+			 * NULL an already satisfied WAIT_SYNCPT host method,
+			 * by patching its args in the command stream. The
+			 * method data is changed to reference a reserved
+			 * (never given out or incr) NVSYNCPT_GRAPHICS_HOST
+			 * syncpt with a matching threshold value of 0, so
+			 * is guaranteed to be popped by the host HW.
+			 */
+			dev_dbg(&syncpt_to_dev(sp)->dev->dev,
+			    "drop WAIT id %d (%s) thresh 0x%x, min 0x%x\n",
+			    wait->syncpt_id,
+			    syncpt_op().name(sp, wait->syncpt_id),
+			    wait->thresh,
+			    nvhost_syncpt_read_min(sp, wait->syncpt_id));
+
+			/* patch the wait */
+			patch_addr = nvhost_memmgr_kmap(h,
+					wait->offset >> PAGE_SHIFT);
+			if (patch_addr) {
+				nvhost_syncpt_patch_wait(sp,
+					(patch_addr +
+					 (wait->offset & ~PAGE_MASK)));
+				nvhost_memmgr_kunmap(h,
+						wait->offset >> PAGE_SHIFT,
+						patch_addr);
+			} else {
+				pr_err("Couldn't map cmdbuf for wait check\n");
+			}
+		}
+
+		wait->mem = 0;
+	}
+	return 0;
+}
+
+
+static int pin_job_mem(struct nvhost_job *job)
+{
+	int i;
+	int count = 0;
+	int result;
+	long unsigned *ids =
+			kmalloc(sizeof(u32 *) *
+				(job->num_relocs + job->num_gathers),
+				GFP_KERNEL);
+	if (!ids)
+		return -ENOMEM;
+
+	for (i = 0; i < job->num_relocs; i++) {
+		struct nvhost_reloc *reloc = &job->relocarray[i];
+		ids[count] = reloc->target;
+		count++;
+	}
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct nvhost_job_gather *g = &job->gathers[i];
+		ids[count] = g->mem_id;
+		count++;
+	}
+
+	/* validate array and pin unique ids, get refs for unpinning */
+	result = nvhost_memmgr_pin_array_ids(job->ch->dev,
+		ids, job->addr_phys,
+		count,
+		job->unpins);
+	kfree(ids);
+
+	if (result > 0)
+		job->num_unpins = result;
+
+	return result;
+}
+
+static int do_relocs(struct nvhost_job *job,
+		u32 cmdbuf_mem, struct mem_handle *h)
+{
+	int i = 0;
+	int last_page = -1;
+	void *cmdbuf_page_addr = NULL;
+
+	/* pin & patch the relocs for one gather */
+	while (i < job->num_relocs) {
+		struct nvhost_reloc *reloc = &job->relocarray[i];
+
+		/* skip all other gathers */
+		if (cmdbuf_mem != reloc->cmdbuf_mem) {
+			i++;
+			continue;
+		}
+
+		if (last_page != reloc->cmdbuf_offset >> PAGE_SHIFT) {
+			if (cmdbuf_page_addr)
+				nvhost_memmgr_kunmap(h, last_page, cmdbuf_page_addr);
+
+			cmdbuf_page_addr = nvhost_memmgr_kmap(h,
+					reloc->cmdbuf_offset >> PAGE_SHIFT);
+			last_page = reloc->cmdbuf_offset >> PAGE_SHIFT;
+
+			if (unlikely(!cmdbuf_page_addr)) {
+				pr_err("Couldn't map cmdbuf for relocation\n");
+				return -ENOMEM;
+			}
+		}
+
+		__raw_writel(
+			(job->reloc_addr_phys[i] +
+				reloc->target_offset) >> reloc->shift,
+			(cmdbuf_page_addr +
+				(reloc->cmdbuf_offset & ~PAGE_MASK)));
+
+		/* remove completed reloc from the job */
+		if (i != job->num_relocs - 1) {
+			struct nvhost_reloc *reloc_last =
+				&job->relocarray[job->num_relocs - 1];
+			reloc->cmdbuf_mem	= reloc_last->cmdbuf_mem;
+			reloc->cmdbuf_offset	= reloc_last->cmdbuf_offset;
+			reloc->target		= reloc_last->target;
+			reloc->target_offset	= reloc_last->target_offset;
+			reloc->shift		= reloc_last->shift;
+			job->reloc_addr_phys[i] =
+				job->reloc_addr_phys[job->num_relocs - 1];
+			job->num_relocs--;
+		} else {
+			break;
+		}
+	}
+
+	if (cmdbuf_page_addr)
+		nvhost_memmgr_kunmap(h, last_page, cmdbuf_page_addr);
+
+	return 0;
+}
+
+
+int nvhost_job_pin(struct nvhost_job *job, struct platform_device *pdev)
+{
+	int err = 0, i = 0, j = 0;
+	struct nvhost_syncpt *sp = &nvhost_get_host(pdev)->syncpt;
+	unsigned long waitchk_mask[nvhost_syncpt_nb_pts(sp) / BITS_PER_LONG];
+
+	memset(&waitchk_mask[0], 0, sizeof(waitchk_mask));
+	for (i = 0; i < job->num_waitchk; i++) {
+		u32 syncpt_id = job->waitchk[i].syncpt_id;
+		if (syncpt_id < nvhost_syncpt_nb_pts(sp))
+			waitchk_mask[BIT_WORD(syncpt_id)] |=
+				BIT_MASK(syncpt_id);
+	}
+
+	/* get current syncpt values for waitchk */
+	for_each_set_bit(i, &waitchk_mask[0], sizeof(waitchk_mask))
+		nvhost_syncpt_update_min(sp, i);
+
+	/* pin memory */
+	err = pin_job_mem(job);
+	if (err <= 0)
+		goto fail;
+
+	/* patch gathers */
+	for (i = 0; i < job->num_gathers; i++) {
+		struct nvhost_job_gather *g = &job->gathers[i];
+
+		/* process each gather mem only once */
+		if (!g->ref) {
+			g->ref = nvhost_memmgr_get(g->mem_id, job->ch->dev);
+			if (IS_ERR(g->ref)) {
+				err = PTR_ERR(g->ref);
+				g->ref = NULL;
+				break;
+			}
+
+			g->mem_base = job->gather_addr_phys[i];
+
+			for (j = 0; j < job->num_gathers; j++) {
+				struct nvhost_job_gather *tmp =
+					&job->gathers[j];
+				if (!tmp->ref && tmp->mem_id == g->mem_id) {
+					tmp->ref = g->ref;
+					tmp->mem_base = g->mem_base;
+				}
+			}
+			err = do_relocs(job, g->mem_id,  g->ref);
+			if (!err)
+				err = do_waitchks(job, sp,
+						g->mem_id, g->ref);
+			nvhost_memmgr_put(g->ref);
+			if (err)
+				break;
+		}
+	}
+fail:
+	wmb();
+
+	return err;
+}
+EXPORT_SYMBOL(nvhost_job_pin);
+
+void nvhost_job_unpin(struct nvhost_job *job)
+{
+	int i;
+
+	for (i = 0; i < job->num_unpins; i++) {
+		struct nvhost_job_unpin_data *unpin = &job->unpins[i];
+		nvhost_memmgr_unpin(unpin->h, unpin->mem);
+		nvhost_memmgr_put(unpin->h);
+	}
+	job->num_unpins = 0;
+}
+EXPORT_SYMBOL(nvhost_job_unpin);
+
+/**
+ * Debug routine used to dump job entries
+ */
+void nvhost_job_dump(struct device *dev, struct nvhost_job *job)
+{
+	dev_dbg(dev, "    SYNCPT_ID   %d\n",
+		job->syncpt_id);
+	dev_dbg(dev, "    SYNCPT_VAL  %d\n",
+		job->syncpt_end);
+	dev_dbg(dev, "    FIRST_GET   0x%x\n",
+		job->first_get);
+	dev_dbg(dev, "    TIMEOUT     %d\n",
+		job->timeout);
+	dev_dbg(dev, "    NUM_SLOTS   %d\n",
+		job->num_slots);
+	dev_dbg(dev, "    NUM_HANDLES %d\n",
+		job->num_unpins);
+}
diff --git a/drivers/video/tegra/host/nvhost_memmgr.c b/drivers/video/tegra/host/nvhost_memmgr.c
new file mode 100644
index 0000000..bdceb74
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_memmgr.c
@@ -0,0 +1,160 @@
+/*
+ * drivers/video/tegra/host/nvhost_memmgr.c
+ *
+ * Tegra host1x Memory Management Abstraction
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/err.h>
+
+#include "nvhost_memmgr.h"
+#include "dmabuf.h"
+#include "chip_support.h"
+
+struct mem_handle *nvhost_memmgr_alloc(size_t size, size_t align, int flags)
+{
+	struct mem_handle *h = NULL;
+	h = nvhost_dmabuf_alloc(size, align, flags);
+
+	return h;
+}
+
+struct mem_handle *nvhost_memmgr_get(u32 id, struct platform_device *dev)
+{
+	struct mem_handle *h = NULL;
+
+	switch (nvhost_memmgr_type(id)) {
+	case mem_mgr_type_dmabuf:
+		h = (struct mem_handle *) nvhost_dmabuf_get(id, dev);
+		break;
+	default:
+		break;
+	}
+
+	return h;
+}
+
+void nvhost_memmgr_put(struct mem_handle *handle)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		nvhost_dmabuf_put(handle);
+		break;
+	default:
+		break;
+	}
+}
+
+struct sg_table *nvhost_memmgr_pin(struct mem_handle *handle)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		return nvhost_dmabuf_pin(handle);
+		break;
+	default:
+		return 0;
+		break;
+	}
+}
+
+void nvhost_memmgr_unpin(struct mem_handle *handle, struct sg_table *sgt)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		nvhost_dmabuf_unpin(handle, sgt);
+		break;
+	default:
+		break;
+	}
+}
+
+void *nvhost_memmgr_mmap(struct mem_handle *handle)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		return nvhost_dmabuf_mmap(handle);
+		break;
+	default:
+		return 0;
+		break;
+	}
+}
+
+void nvhost_memmgr_munmap(struct mem_handle *handle, void *addr)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		nvhost_dmabuf_munmap(handle, addr);
+		break;
+	default:
+		break;
+	}
+}
+
+void *nvhost_memmgr_kmap(struct mem_handle *handle, unsigned int pagenum)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		return nvhost_dmabuf_kmap(handle, pagenum);
+		break;
+	default:
+		return 0;
+		break;
+	}
+}
+
+void nvhost_memmgr_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr)
+{
+	switch (nvhost_memmgr_type((u32)handle)) {
+	case mem_mgr_type_dmabuf:
+		nvhost_dmabuf_kunmap(handle, pagenum, addr);
+		break;
+	default:
+		break;
+	}
+}
+
+int nvhost_memmgr_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		dma_addr_t *phys_addr,
+		u32 count,
+		struct nvhost_job_unpin_data *unpin_data)
+{
+	int pin_count = 0;
+
+	int dmabuf_count = 0;
+	dmabuf_count = nvhost_dmabuf_pin_array_ids(dev,
+		ids, MEMMGR_TYPE_MASK,
+		mem_mgr_type_dmabuf,
+		count, &unpin_data[pin_count],
+		phys_addr);
+
+	if (dmabuf_count < 0) {
+		/* clean up previous handles */
+		while (pin_count) {
+			pin_count--;
+			/* unpin, put */
+			nvhost_memmgr_unpin(unpin_data[pin_count].h,
+					unpin_data[pin_count].mem);
+			nvhost_memmgr_put(unpin_data[pin_count].h);
+		}
+		return dmabuf_count;
+	}
+	pin_count += dmabuf_count;
+	return pin_count;
+}
diff --git a/drivers/video/tegra/host/nvhost_memmgr.h b/drivers/video/tegra/host/nvhost_memmgr.h
new file mode 100644
index 0000000..77b755d
--- /dev/null
+++ b/drivers/video/tegra/host/nvhost_memmgr.h
@@ -0,0 +1,65 @@
+/*
+ * drivers/video/tegra/host/nvhost_memmgr.h
+ *
+ * Tegra host1x Memory Management Abstraction header
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _NVHOST_MEM_MGR_H_
+#define _NVHOST_MEM_MGR_H_
+
+struct nvhost_chip_support;
+struct mem_handle;
+struct platform_device;
+
+struct nvhost_job_unpin_data {
+	struct mem_handle *h;
+	struct sg_table *mem;
+};
+
+enum mem_mgr_flag {
+	mem_mgr_flag_uncacheable = 0,
+	mem_mgr_flag_write_combine = 1,
+};
+
+enum mem_mgr_type {
+	mem_mgr_type_dmabuf = 1,
+};
+
+#define MEMMGR_TYPE_MASK	0x3
+#define MEMMGR_ID_MASK		~0x3
+
+struct mem_handle *nvhost_memmgr_alloc(size_t size, size_t align,
+		int flags);
+struct mem_handle *nvhost_memmgr_get(u32 id, struct platform_device *dev);
+void nvhost_memmgr_put(struct mem_handle *handle);
+struct sg_table *nvhost_memmgr_pin(struct mem_handle *handle);
+void nvhost_memmgr_unpin(struct mem_handle *handle, struct sg_table *sgt);
+void *nvhost_memmgr_mmap(struct mem_handle *handle);
+void nvhost_memmgr_munmap(struct mem_handle *handle, void *addr);
+void *nvhost_memmgr_kmap(struct mem_handle *handle, unsigned int pagenum);
+void nvhost_memmgr_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr);
+static inline int nvhost_memmgr_type(u32 id) { return id & MEMMGR_TYPE_MASK; }
+static inline int nvhost_memmgr_id(u32 id) { return id & MEMMGR_ID_MASK; }
+
+int nvhost_memmgr_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		dma_addr_t *phys_addr,
+		u32 count,
+		struct nvhost_job_unpin_data *unpin_data);
+
+#endif
diff --git a/drivers/video/tegra/host/nvhost_syncpt.c b/drivers/video/tegra/host/nvhost_syncpt.c
index 6ef0ba4..f61b924 100644
--- a/drivers/video/tegra/host/nvhost_syncpt.c
+++ b/drivers/video/tegra/host/nvhost_syncpt.c
@@ -299,6 +299,12 @@ void nvhost_syncpt_debug(struct nvhost_syncpt *sp)
 {
 	syncpt_op().debug(sp);
 }
+/* remove a wait pointed to by patch_addr */
+int nvhost_syncpt_patch_wait(struct nvhost_syncpt *sp, void *patch_addr)
+{
+	return syncpt_op().patch_wait(sp, patch_addr);
+}
+
 /* Displays the current value of the sync point via sysfs */
 static ssize_t syncpt_min_show(struct kobject *kobj,
 		struct kobj_attribute *attr, char *buf)
diff --git a/drivers/video/tegra/host/nvhost_syncpt.h b/drivers/video/tegra/host/nvhost_syncpt.h
index dbd3890..93ec123 100644
--- a/drivers/video/tegra/host/nvhost_syncpt.h
+++ b/drivers/video/tegra/host/nvhost_syncpt.h
@@ -136,6 +136,8 @@ static inline int nvhost_syncpt_wait(struct nvhost_syncpt *sp,
 					  MAX_SCHEDULE_TIMEOUT, NULL);
 }
 
+int nvhost_syncpt_patch_wait(struct nvhost_syncpt *sp, void *patch_addr);
+
 void nvhost_syncpt_debug(struct nvhost_syncpt *sp);
 
 static inline int nvhost_syncpt_is_valid(struct nvhost_syncpt *sp, u32 id)
diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
index 745f31c..96405bf 100644
--- a/include/linux/nvhost.h
+++ b/include/linux/nvhost.h
@@ -27,7 +27,9 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 
+struct nvhost_job;
 struct nvhost_device_power_attr;
+struct nvhost_job_unpin_data;
 
 #define NVHOST_MODULE_MAX_CLOCKS		3
 #define NVHOST_MODULE_MAX_POWERGATE_IDS		2
@@ -37,6 +39,19 @@ struct nvhost_device_power_attr;
 #define NVSYNCPT_INVALID			(-1)
 #define NVHOST_NO_TIMEOUT			(-1)
 
+#define NVSYNCPT_2D_0		(18)
+#define NVSYNCPT_2D_1		(19)
+#define NVSYNCPT_VBLANK0	(26)
+#define NVSYNCPT_VBLANK1	(27)
+
+/* sync points that are wholly managed by the client */
+#define NVSYNCPTS_CLIENT_MANAGED (\
+	BIT(NVSYNCPT_VBLANK0) | \
+	BIT(NVSYNCPT_VBLANK1) | \
+	BIT(NVSYNCPT_2D_1))
+
+#define NVWAITBASE_2D_0 (1)
+#define NVWAITBASE_2D_1 (2)
 enum nvhost_power_sysfs_attributes {
 	NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY = 0,
 	NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY,
@@ -142,4 +157,138 @@ void host1x_syncpt_incr(u32 id);
 u32 host1x_syncpt_read(u32 id);
 int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value);
 
+/* Register device */
+int nvhost_client_device_init(struct platform_device *dev);
+int nvhost_client_device_suspend(struct platform_device *dev);
+struct nvhost_channel *nvhost_getchannel(struct nvhost_channel *ch);
+void nvhost_putchannel(struct nvhost_channel *ch);
+int nvhost_channel_submit(struct nvhost_job *job);
+
+enum host1x_class {
+	NV_HOST1X_CLASS_ID		= 0x1,
+	NV_GRAPHICS_2D_CLASS_ID		= 0x51,
+};
+
+struct nvhost_job_gather {
+	u32 words;
+	struct sg_table *mem_sgt;
+	dma_addr_t mem_base;
+	u32 mem_id;
+	int offset;
+	struct mem_handle *ref;
+};
+
+struct nvhost_cmdbuf {
+	__u32 mem;
+	__u32 offset;
+	__u32 words;
+};
+
+struct nvhost_reloc {
+	__u32 cmdbuf_mem;
+	__u32 cmdbuf_offset;
+	__u32 target;
+	__u32 target_offset;
+	__u32 shift;
+};
+
+struct nvhost_waitchk {
+	__u32 mem;
+	__u32 offset;
+	__u32 syncpt_id;
+	__u32 thresh;
+};
+
+/*
+ * Each submit is tracked as a nvhost_job.
+ */
+struct nvhost_job {
+	/* When refcount goes to zero, job can be freed */
+	struct kref ref;
+
+	/* List entry */
+	struct list_head list;
+
+	/* Channel where job is submitted to */
+	struct nvhost_channel *ch;
+
+	int clientid;
+
+	/* Gathers and their memory */
+	struct nvhost_job_gather *gathers;
+	int num_gathers;
+
+	/* Wait checks to be processed at submit time */
+	struct nvhost_waitchk *waitchk;
+	int num_waitchk;
+	u32 waitchk_mask;
+
+	/* Array of handles to be pinned & unpinned */
+	struct nvhost_reloc *relocarray;
+	int num_relocs;
+	struct nvhost_job_unpin_data *unpins;
+	int num_unpins;
+
+	dma_addr_t *addr_phys;
+	dma_addr_t *gather_addr_phys;
+	dma_addr_t *reloc_addr_phys;
+
+	/* Sync point id, number of increments and end related to the submit */
+	u32 syncpt_id;
+	u32 syncpt_incrs;
+	u32 syncpt_end;
+
+	/* Maximum time to wait for this job */
+	int timeout;
+
+	/* Null kickoff prevents submit from being sent to hardware */
+	bool null_kickoff;
+
+	/* Index and number of slots used in the push buffer */
+	int first_get;
+	int num_slots;
+};
+/*
+ * Allocate memory for a job. Just enough memory will be allocated to
+ * accomodate the submit.
+ */
+struct nvhost_job *nvhost_job_alloc(struct nvhost_channel *ch,
+		int num_cmdbufs, int num_relocs, int num_waitchks);
+
+/*
+ * Add a gather to a job.
+ */
+void nvhost_job_add_gather(struct nvhost_job *job,
+		u32 mem_id, u32 words, u32 offset);
+
+/*
+ * Increment reference going to nvhost_job.
+ */
+void nvhost_job_get(struct nvhost_job *job);
+
+/*
+ * Decrement reference job, free if goes to zero.
+ */
+void nvhost_job_put(struct nvhost_job *job);
+
+/*
+ * Pin memory related to job. This handles relocation of addresses to the
+ * host1x address space. Handles both the gather memory and any other memory
+ * referred to from the gather buffers.
+ *
+ * Handles also patching out host waits that would wait for an expired sync
+ * point value.
+ */
+int nvhost_job_pin(struct nvhost_job *job, struct platform_device *pdev);
+
+/*
+ * Unpin memory related to job.
+ */
+void nvhost_job_unpin(struct nvhost_job *job);
+
+/*
+ * Dump contents of job to debug output.
+ */
+void nvhost_job_dump(struct device *dev, struct nvhost_job *job);
+
 #endif
-- 
1.7.9.5

