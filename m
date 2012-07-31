Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab2GaUPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 16:15:30 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39464 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab2GaUPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 16:15:25 -0400
From: Federico Vaga <federico.vaga@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Pawel Osciak <pawel@osciak.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH 2/3] [media] videobuf2-dma-streaming: new videobuf2 memory allocator
Date: Tue, 31 Jul 2012 22:17:08 +0200
Message-Id: <1343765829-6006-3-git-send-email-federico.vaga@gmail.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
References: <1343765829-6006-1-git-send-email-federico.vaga@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 drivers/media/video/Kconfig                   |   6 +-
 drivers/media/video/Makefile                  |   1 +
 drivers/media/video/videobuf2-dma-streaming.c | 187 ++++++++++++++++++++++++++
 include/media/videobuf2-dma-streaming.h       |  24 ++++
 4 file modificati, 217 inserzioni(+). 1 rimozione(-)
 create mode 100644 drivers/media/video/videobuf2-dma-streaming.c
 create mode 100644 include/media/videobuf2-dma-streaming.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index be6d718..6c60b59 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -59,6 +59,10 @@ config VIDEOBUF2_DMA_NC
 	select VIDEOBUF2_CORE
 	select VIDEOBUF2_MEMOPS
 	tristate
+config VIDEOBUF2_DMA_STREAMING
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
 
 config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_CORE
@@ -844,7 +848,7 @@ config STA2X11_VIP
 	tristate "STA2X11 VIP Video For Linux"
 	depends on STA2X11
 	select VIDEO_ADV7180 if VIDEO_HELPER_CHIPS_AUTO
-	select VIDEOBUF_DMA_CONTIG
+	select VIDEOBUF2_DMA_STREAMING
 	depends on PCI && VIDEO_V4L2 && VIRT_TO_BUS
 	help
 	  Say Y for support for STA2X11 VIP (Video Input Port) capture
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index 30234af..c1a08b9e 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -140,6 +140,7 @@ obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
 obj-$(CONFIG_VIDEOBUF2_DMA_NC)		+= videobuf2-dma-nc.o
+obj-$(CONFIG_VIDEOBUF2_DMA_STREAMING)	+= videobuf2-dma-streaming.o
 
 obj-$(CONFIG_V4L2_MEM2MEM_DEV) += v4l2-mem2mem.o
 
diff --git a/drivers/media/video/videobuf2-dma-streaming.c b/drivers/media/video/videobuf2-dma-streaming.c
new file mode 100644
index 0000000..d96d3d9
--- /dev/null
+++ b/drivers/media/video/videobuf2-dma-streaming.c
@@ -0,0 +1,187 @@
+/*
+ * videobuf2-dma-streaming.c - DMA streaming memory allocator for videobuf2
+ *
+ * Copyright (C) 2012 Federico Vaga <federico.vaga@gmail.com>
+ * *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/pagemap.h>
+#include <linux/dma-mapping.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-dma-streaming.h>
+#include <media/videobuf2-memops.h>
+
+struct vb2_streaming_conf {
+	struct device			*dev;
+};
+struct vb2_streaming_buf {
+	struct vb2_streaming_conf	*conf;
+	void				*vaddr;
+
+	dma_addr_t			dma_handle;
+
+	unsigned long			size;
+	struct vm_area_struct		*vma;
+
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_dma_streaming_put(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		dma_unmap_single(buf->conf->dev, buf->dma_handle, buf->size,
+				 DMA_FROM_DEVICE);
+		free_pages_exact(buf->vaddr, buf->size);
+		kfree(buf);
+	}
+
+}
+
+static void *vb2_dma_streaming_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_streaming_conf *conf = alloc_ctx;
+	struct vb2_streaming_buf *buf;
+	int err;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+	buf->vaddr = alloc_pages_exact(size, GFP_KERNEL | GFP_DMA);
+	if (!buf->vaddr) {
+		err = -ENOMEM;
+		goto out;
+	}
+	buf->dma_handle = dma_map_single(conf->dev, buf->vaddr, size,
+					 DMA_FROM_DEVICE);
+	err = dma_mapping_error(conf->dev, buf->dma_handle);
+	if (err) {
+		dev_err(conf->dev, "dma_map_single failed\n");
+
+		free_pages_exact(buf->vaddr, size);
+		buf->vaddr = NULL;
+		goto out_pages;
+	}
+	buf->conf = conf;
+	buf->size = size;
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_dma_streaming_put;
+	buf->handler.arg = buf;
+
+	atomic_inc(&buf->refcount);
+	return buf;
+
+out_pages:
+	free_pages_exact(buf->vaddr, buf->size);
+out:
+	kfree(buf);
+	return ERR_PTR(err);
+}
+
+static void *vb2_dma_streaming_cookie(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	return (void *)buf->dma_handle;
+}
+
+static void *vb2_dma_streaming_vaddr(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	if (!buf)
+		return NULL;
+	return buf->vaddr;
+}
+
+static unsigned int vb2_dma_streaming_num_users(void *buf_priv)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_dma_streaming_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_streaming_buf *buf = buf_priv;
+	unsigned long pos, start = vma->vm_start;
+	unsigned long size;
+	struct page *page;
+	int err;
+
+	/* Try to remap memory */
+	size = vma->vm_end - vma->vm_start;
+	size = (size < buf->size) ? size : buf->size;
+	pos = (unsigned long)buf->vaddr;
+
+	while (size > 0) {
+		page = virt_to_page((void *)pos);
+		if (!page) {
+			dev_err(buf->conf->dev, "mmap: virt_to_page failed\n");
+			return -ENOMEM;
+		}
+		err = vm_insert_page(vma, start, page);
+		if (err) {
+			dev_err(buf->conf->dev, "mmap: insert failed %d\n", err);
+			return -ENOMEM;
+		}
+		start += PAGE_SIZE;
+		pos += PAGE_SIZE;
+
+		if (size > PAGE_SIZE)
+			size -= PAGE_SIZE;
+		else
+			size = 0;
+	}
+
+
+	vma->vm_ops = &vb2_common_vm_ops;
+	vma->vm_flags |= VM_DONTEXPAND;
+	vma->vm_private_data = &buf->handler;
+
+	vma->vm_ops->open(vma);
+
+	return 0;
+}
+
+const struct vb2_mem_ops vb2_dma_streaming_memops = {
+	.alloc		= vb2_dma_streaming_alloc,
+	.put		= vb2_dma_streaming_put,
+	.cookie		= vb2_dma_streaming_cookie,
+	.vaddr		= vb2_dma_streaming_vaddr,
+	.mmap		= vb2_dma_streaming_mmap,
+	.num_users	= vb2_dma_streaming_num_users,
+};
+EXPORT_SYMBOL_GPL(vb2_dma_streaming_memops);
+
+void *vb2_dma_streaming_init_ctx(struct device *dev)
+{
+	struct vb2_streaming_conf *conf;
+
+	conf = kmalloc(sizeof *conf, GFP_KERNEL);
+	if (!conf)
+		return ERR_PTR(-ENOMEM);
+
+	conf->dev = dev;
+
+	return conf;
+}
+EXPORT_SYMBOL_GPL(vb2_dma_streaming_init_ctx);
+
+void vb2_dma_streaming_cleanup_ctx(void *alloc_ctx)
+{
+	kfree(alloc_ctx);
+}
+EXPORT_SYMBOL_GPL(vb2_dma_streaming_cleanup_ctx);
+
+MODULE_DESCRIPTION("DMA-streaming memory allocator for videobuf2");
+MODULE_AUTHOR("Federico Vaga <federico.vaga@gmail.com>");
+MODULE_LICENSE("GPL v2");
diff --git a/include/media/videobuf2-dma-streaming.h b/include/media/videobuf2-dma-streaming.h
new file mode 100644
index 0000000..89cbd06
--- /dev/null
+++ b/include/media/videobuf2-dma-streaming.h
@@ -0,0 +1,24 @@
+/*
+ * videobuf2-dma-streaming.h - DMA steaming memory allocator for videobuf2
+ *
+ * Copyright (C) 2012 Federico Vaga
+ *
+ * Author: Federico Vaga <federico.vaga@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_DMA_STREAMING_H
+#define _MEDIA_VIDEOBUF2_DMA_STREAMING_H
+
+#include <media/videobuf2-core.h>
+#include <linux/dma-mapping.h>
+
+void *vb2_dma_streaming_init_ctx(struct device *dev);
+void vb2_dma_streaming_cleanup_ctx(void *alloc_ctx);
+
+extern const struct vb2_mem_ops vb2_dma_streaming_memops;
+
+#endif
-- 
1.7.11.2

