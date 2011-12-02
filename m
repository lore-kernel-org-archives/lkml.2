Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab1LBJOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:14:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab1LBJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:14:06 -0500
From: Ming Lei <ming.lei@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>
Cc: Sylwester Nawrocki <snjw23@gmail.com>, Greg KH <greg@kroah.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: [RFC PATCH v1 4/7] media: videobuf2: introduce VIDEOBUF2_PAGE memops
Date: Fri,  2 Dec 2011 17:12:55 +0800
Message-Id: <1322817178-8931-5-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
References: <1322817178-8931-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DMA contig memory resource is very limited and precious, also
accessing to it from CPU is very slow on some platform.

For some cases(such as the comming face detection driver), DMA Streaming
buffer is enough, so introduce VIDEOBUF2_PAGE to allocate continuous
physical memory but letting video device driver to handle DMA buffer mapping
and unmapping things.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 drivers/media/video/Kconfig          |    4 +
 drivers/media/video/Makefile         |    1 +
 drivers/media/video/videobuf2-page.c |  115 ++++++++++++++++++++++++++++++++++
 include/media/videobuf2-page.h       |   20 ++++++
 4 files changed, 140 insertions(+), 0 deletions(-)
 create mode 100644 drivers/media/video/videobuf2-page.c
 create mode 100644 include/media/videobuf2-page.h

diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index 4e8a0c4..5684a00 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -60,6 +60,10 @@ config VIDEOBUF2_VMALLOC
 	select VIDEOBUF2_MEMOPS
 	tristate
 
+config VIDEOBUF2_PAGE
+	select VIDEOBUF2_CORE
+	select VIDEOBUF2_MEMOPS
+	tristate
 
 config VIDEOBUF2_DMA_SG
 	#depends on HAS_DMA
diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
index ddeaa6c..bc797f2 100644
--- a/drivers/media/video/Makefile
+++ b/drivers/media/video/Makefile
@@ -125,6 +125,7 @@ obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
 obj-$(CONFIG_VIDEOBUF2_CORE)		+= videobuf2-core.o
 obj-$(CONFIG_VIDEOBUF2_MEMOPS)		+= videobuf2-memops.o
 obj-$(CONFIG_VIDEOBUF2_VMALLOC)		+= videobuf2-vmalloc.o
+obj-$(CONFIG_VIDEOBUF2_PAGE)		+= videobuf2-page.o
 obj-$(CONFIG_VIDEOBUF2_DMA_CONTIG)	+= videobuf2-dma-contig.o
 obj-$(CONFIG_VIDEOBUF2_DMA_SG)		+= videobuf2-dma-sg.o
 
diff --git a/drivers/media/video/videobuf2-page.c b/drivers/media/video/videobuf2-page.c
new file mode 100644
index 0000000..b3f003a
--- /dev/null
+++ b/drivers/media/video/videobuf2-page.c
@@ -0,0 +1,115 @@
+/*
+ * videobuf2-page.c - page memory allocator for videobuf2
+ *
+ * Copyright (C) 2011 Canonical Ltd.
+ *
+ * Author: Ming Lei <ming.lei@canonical.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+
+#include <media/videobuf2-core.h>
+#include <media/videobuf2-memops.h>
+
+struct vb2_page_buf {
+	void				*vaddr;
+	unsigned long			size;
+	atomic_t			refcount;
+	struct vb2_vmarea_handler	handler;
+};
+
+static void vb2_page_put(void *buf_priv);
+
+static void *vb2_page_alloc(void *alloc_ctx, unsigned long size)
+{
+	struct vb2_page_buf *buf;
+
+	buf = kzalloc(sizeof *buf, GFP_KERNEL);
+	if (!buf)
+		return NULL;
+
+	buf->size = size;
+	buf->vaddr = (void *)__get_free_pages(GFP_KERNEL,
+			get_order(buf->size));
+	buf->handler.refcount = &buf->refcount;
+	buf->handler.put = vb2_page_put;
+	buf->handler.arg = buf;
+
+	if (!buf->vaddr) {
+		printk(KERN_ERR "page of size %ld failed\n", buf->size);
+		kfree(buf);
+		return NULL;
+	}
+
+	atomic_inc(&buf->refcount);
+	printk(KERN_DEBUG "Allocated page buffer of size %ld at vaddr=%p\n",
+			buf->size, buf->vaddr);
+
+	return buf;
+}
+
+static void vb2_page_put(void *buf_priv)
+{
+	struct vb2_page_buf *buf = buf_priv;
+
+	if (atomic_dec_and_test(&buf->refcount)) {
+		printk(KERN_DEBUG "%s: Freeing page mem at vaddr=%p\n",
+			__func__, buf->vaddr);
+		free_pages((unsigned long)buf->vaddr, get_order(buf->size));
+		kfree(buf);
+	}
+}
+
+static void *vb2_page_vaddr(void *buf_priv)
+{
+	struct vb2_page_buf *buf = buf_priv;
+
+	BUG_ON(!buf);
+
+	if (!buf->vaddr) {
+		printk(KERN_ERR "Address of an unallocated plane requested\n");
+		return NULL;
+	}
+
+	return buf->vaddr;
+}
+
+static unsigned int vb2_page_num_users(void *buf_priv)
+{
+	struct vb2_page_buf *buf = buf_priv;
+	return atomic_read(&buf->refcount);
+}
+
+static int vb2_page_mmap(void *buf_priv, struct vm_area_struct *vma)
+{
+	struct vb2_page_buf *buf = buf_priv;
+
+	if (!buf) {
+		printk(KERN_ERR "No memory to map\n");
+		return -EINVAL;
+	}
+
+	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	return vb2_mmap_pfn_range(vma, virt_to_phys(buf->vaddr),
+			buf->size, &vb2_common_vm_ops,
+			&buf->handler);
+}
+
+const struct vb2_mem_ops vb2_page_memops = {
+	.alloc		= vb2_page_alloc,
+	.put		= vb2_page_put,
+	.vaddr		= vb2_page_vaddr,
+	.mmap		= vb2_page_mmap,
+	.num_users	= vb2_page_num_users,
+};
+EXPORT_SYMBOL_GPL(vb2_page_memops);
+
+MODULE_DESCRIPTION("page memory handling routines for videobuf2");
+MODULE_AUTHOR("Ming Lei");
+MODULE_LICENSE("GPL");
diff --git a/include/media/videobuf2-page.h b/include/media/videobuf2-page.h
new file mode 100644
index 0000000..29b3e20
--- /dev/null
+++ b/include/media/videobuf2-page.h
@@ -0,0 +1,20 @@
+/*
+ * videobuf2-vmalloc.h - vmalloc memory allocator for videobuf2
+ *
+ * Copyright (C) 2010 Samsung Electronics
+ *
+ * Author: Pawel Osciak <pawel@osciak.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation.
+ */
+
+#ifndef _MEDIA_VIDEOBUF2_VMALLOC_H
+#define _MEDIA_VIDEOBUF2_VMALLOC_H
+
+#include <media/videobuf2-core.h>
+
+extern const struct vb2_mem_ops vb2_page_memops;
+
+#endif
-- 
1.7.5.4

