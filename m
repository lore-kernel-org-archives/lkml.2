Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0ERKCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:02:34 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:35874 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab0ERKCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:02:31 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Greg KH <greg@kroah.com>
Subject: [PATCH]staging/dt3155v4l: remove private memory allocator
Date: Tue, 18 May 2010 13:05:29 +0300
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005181305.29476.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch removes the private memory allocator
and all conjugated functions. Now the driver uses
videobuf-dma-contig module for allocations.
Added reserving 4MB coherent memory for private
per device allocations at probe time.

Please, apply.

Thanks.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

===========================================================
diff -upN a/drivers/staging/dt3155v4l/Kconfig b/drivers/staging/dt3155v4l/Kconfig
--- a/drivers/staging/dt3155v4l/Kconfig	2010-05-17 20:48:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/Kconfig	2010-05-18 10:55:20.000000000 +0300
@@ -9,7 +9,7 @@ config VIDEO_DT3155
 	  In doubt, say N.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called dt3155_v4l.
+	  module will be called dt3155v4l.
 
 config DT3155_CCIR
 	bool "Selects CCIR/50Hz vertical refresh"
diff -upN a/drivers/staging/dt3155v4l/Makefile b/drivers/staging/dt3155v4l/Makefile
--- a/drivers/staging/dt3155v4l/Makefile	2010-05-17 20:48:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/Makefile	2010-05-18 10:54:10.000000000 +0300
@@ -1,4 +1 @@
-obj-$(CONFIG_VIDEO_DT3155)	+= dt3155_v4l.o
-dt3155_v4l-objs :=	\
-		dt3155-bufs.o	\
-		dt3155v4l.o
+obj-$(CONFIG_VIDEO_DT3155)	+= dt3155v4l.o
diff -upN a/drivers/staging/dt3155v4l/dt3155-bufs.c b/drivers/staging/dt3155v4l/dt3155-bufs.c
--- a/drivers/staging/dt3155v4l/dt3155-bufs.c	2010-05-17 20:48:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155-bufs.c	1970-01-01 02:00:00.000000000 +0200
@@ -1,256 +0,0 @@
-/***************************************************************************
- *   Copyright (C) 2006-2010 by Marin Mitov                                *
- *   mitov@issp.bas.bg                                                     *
- *                                                                         *
- *   This program is free software; you can redistribute it and/or modify  *
- *   it under the terms of the GNU General Public License as published by  *
- *   the Free Software Foundation; either version 2 of the License, or     *
- *   (at your option) any later version.                                   *
- *                                                                         *
- *   This program is distributed in the hope that it will be useful,       *
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- *   GNU General Public License for more details.                          *
- *                                                                         *
- *   You should have received a copy of the GNU General Public License     *
- *   along with this program; if not, write to the                         *
- *   Free Software Foundation, Inc.,                                       *
- *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- ***************************************************************************/
-
-#include "dt3155-bufs.h"
-
-/**
- * dt3155_init_chunks_buf - creates a chunk buffer and allocates memory for it
- *
- * returns:	a pointer to the struct dt3155_buf or NULL if failed
- *
- * Creates a struct dt3155_buf, then allocates a chunk of memory of
- * size DT3155_CHUNK_SIZE and sets all the pages in it as Reserved.
- * This is done to be able to use remap_pfn_range() on these buffers
- * (which do not work on normal memory if Reserved bit is not set)
- */
-struct dt3155_buf *
-dt3155_init_chunks_buf(void)
-{	/*  could sleep  */
-	struct dt3155_buf *buf;
-	int i;
-
-	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
-	if (!buf)
-		return NULL;
-	buf->cpu = (void *)__get_free_pages(DT3155_CHUNK_FLAGS,
-					get_order(DT3155_CHUNK_SIZE));
-	if (!buf->cpu) {
-		kfree(buf);
-		return NULL;
-	}
-	for (i = 0; i < DT3155_CHUNK_SIZE; i += PAGE_SIZE)
-		SetPageReserved(virt_to_page(buf->cpu + i));
-	return buf;  /*   success  */
-}
-
-/**
- * dt3155_free_chunks_buf - destroys the specified buffer
- *
- * @buf:	the buffer to be freed
- *
- * Clears Reserved bit of all pages in the chunk, frees the chunk memory
- * and destroys struct dt3155_buf.
- */
-void
-dt3155_free_chunks_buf(struct dt3155_buf *buf)
-{
-	int i;
-
-	for (i = 0; i < DT3155_CHUNK_SIZE; i += PAGE_SIZE)
-		ClearPageReserved(virt_to_page(buf->cpu + i));
-	free_pages((unsigned long)buf->cpu, get_order(DT3155_CHUNK_SIZE));
-	kfree(buf);
-}
-
-/**
- * dt3155_init_fifo - creates and initializes a fifo
- *
- * returns:	a pointer to the crated and initialized struct dt3155_fifo
- *		or NULL if failed
- */
-struct dt3155_fifo *
-dt3155_init_fifo(void)
-{	/* could sleep  */
-	struct dt3155_fifo *fifo = kzalloc(sizeof(*fifo), GFP_KERNEL);
-	if (fifo)
-		spin_lock_init(&fifo->lock);
-	return fifo;
-}
-
-/*	dt3155_free_fifo(x)  defined as macro in dt3155.h   */
-
-/**
- * dt3155_get_buf - gets a buffer from the fifo
- *
- * @fifo:	the fifo to get a buffer from
- *
- * returns:	a pointer to the buffer or NULL if failed
- *
- * dt3155_get_buf gets the fifo's spin_lock and returns the
- * buffer pointed by the head. Could be used in any context.
- */
-struct dt3155_buf *
-dt3155_get_buf(struct dt3155_fifo *fifo)
-{
-	unsigned long flags;
-	struct dt3155_buf *tmp_buf;
-
-	spin_lock_irqsave(&fifo->lock, flags);
-	tmp_buf = fifo->head;
-	if (fifo->head)
-		fifo->head = fifo->head->next;
-	if (!fifo->head)
-		fifo->tail = NULL;
-	spin_unlock_irqrestore(&fifo->lock, flags);
-	return tmp_buf;
-}
-
-/**
- * dt3155_put_buf - puts a buffer into a fifo
- *
- * @buf:	the buffer to put
- * @fifo:	the fifo to put the buffer in
- *
- * dt3155_put_buf gets the fifo's spin_lock and puts the buf
- * at the tail of the fifo. Could be used in any context.
- */
-void
-dt3155_put_buf(struct dt3155_buf *buf, struct dt3155_fifo *fifo)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&fifo->lock, flags);
-	buf->next = NULL;
-	if (fifo->tail)
-		fifo->tail->next = buf;
-	fifo->tail = buf;
-	if (!fifo->head)
-		fifo->head = buf;
-	spin_unlock_irqrestore(&fifo->lock, flags);
-}
-
-/**
- * dt3155_init_chunks_fifo - creates and fills a chunks_fifo
- *
- * returns:	a pointer to the fifo or NULL if failed
- *
- * dt3155_init_chunks_fifo creates and fills the fifo with
- * a number of chunks <= DT3155_CHUNK_NUM. The returned fifo
- * contains at least one chunk.
- */
-struct dt3155_fifo *
-dt3155_init_chunks_fifo(void)
-{	/*  could sleep  */
-	int i;
-
-	struct dt3155_fifo *chunks;
-	struct dt3155_buf *tmp_buf;
-
-	chunks = dt3155_init_fifo();
-	if (!chunks)
-		return NULL;
-	tmp_buf = dt3155_init_chunks_buf();
-	if (!tmp_buf) {
-		dt3155_free_fifo(chunks);
-		return NULL;
-	}
-	dt3155_put_buf(tmp_buf, chunks);
-	for (i = 1; i < DT3155_CHUNK_NUM; i++) {
-		tmp_buf = dt3155_init_chunks_buf();
-		if (!tmp_buf)
-			break;
-		dt3155_put_buf(tmp_buf, chunks);
-	}
-	return chunks;
-}
-
-/**
- * dt3155_free_chunks_fifo - empties and destroys the chunks_fifo
- *
- * @chunks:	the chunks_fifo to be freed
- *
- * dt3155_free_chunks_fifo deallocates all chunks in the fifo and
- * destroys it.
- */
-void
-dt3155_free_chunks_fifo(struct dt3155_fifo *chunks)
-{
-	int buf_count = 0;
-	struct dt3155_buf *buf;
-
-	while ((buf = dt3155_get_buf(chunks))) {
-		dt3155_free_chunks_buf(buf);
-		buf_count++;
-	}
-	dt3155_free_fifo(chunks);
-	printk(KERN_INFO "dt3155: %i chunks freed\n", buf_count);
-}
-
-/**
- * dt3155_init_ibufs_fifo - creates and fills an image buffer fifo
- *
- * @chunks:	chunks_fifo to take memory from
- * @buf_size:	the size of image buffers
- *
- * returns:	a pointer to the fifo filled with image buffers
- *
- * dt3155_init_ibufs_fifo takes chunks from chunks_fifo, chops them
- * into pieces of size buf_size and fills image fifo with them.
- */
-struct dt3155_fifo *
-dt3155_init_ibufs_fifo(struct dt3155_fifo *chunks, int buf_size)
-{	/*  could sleep  */
-	int i, buf_count = 0;
-	struct dt3155_buf *tmp_ibuf, *chunks_buf, *last_chunk;
-	struct dt3155_fifo *tmp_fifo;
-
-	tmp_fifo = dt3155_init_fifo();
-	if (!tmp_fifo)
-		return NULL;
-	last_chunk = chunks->tail;
-	do {
-		chunks_buf = dt3155_get_buf(chunks);
-		dt3155_put_buf(chunks_buf, chunks);
-		for (i = 0; i < DT3155_CHUNK_SIZE / buf_size; i++) {
-			tmp_ibuf = kzalloc(sizeof(*tmp_ibuf), GFP_KERNEL);
-			if (tmp_ibuf) {
-				tmp_ibuf->cpu =
-					chunks_buf->cpu + DT3155_BUF_SIZE * i;
-				dt3155_put_buf(tmp_ibuf, tmp_fifo);
-				buf_count++;
-			} else {
-				if (buf_count) {
-					goto print_num_bufs;
-				} else {
-					dt3155_free_fifo(tmp_fifo);
-					return NULL;
-				}
-			}
-		}
-	} while (chunks_buf != last_chunk);
-print_num_bufs:
-	printk(KERN_INFO "dt3155: %i image buffers available\n", buf_count);
-	return tmp_fifo;
-}
-
-/**
- * dt3155_free_ibufs_fifo - empties and destroys an image fifo
- *
- * @fifo:	the fifo to free
- */
-void
-dt3155_free_ibufs_fifo(struct dt3155_fifo *fifo)
-{
-	struct dt3155_buf *tmp_ibuf;
-
-	while ((tmp_ibuf = dt3155_get_buf(fifo)))
-		kfree(tmp_ibuf);
-	kfree(fifo);
-}
diff -upN a/drivers/staging/dt3155v4l/dt3155-bufs.h b/drivers/staging/dt3155v4l/dt3155-bufs.h
--- a/drivers/staging/dt3155v4l/dt3155-bufs.h	2010-05-17 20:48:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155-bufs.h	1970-01-01 02:00:00.000000000 +0200
@@ -1,88 +0,0 @@
-/***************************************************************************
- *   Copyright (C) 2006-2010 by Marin Mitov                                *
- *   mitov@issp.bas.bg                                                     *
- *                                                                         *
- *   This program is free software; you can redistribute it and/or modify  *
- *   it under the terms of the GNU General Public License as published by  *
- *   the Free Software Foundation; either version 2 of the License, or     *
- *   (at your option) any later version.                                   *
- *                                                                         *
- *   This program is distributed in the hope that it will be useful,       *
- *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
- *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
- *   GNU General Public License for more details.                          *
- *                                                                         *
- *   You should have received a copy of the GNU General Public License     *
- *   along with this program; if not, write to the                         *
- *   Free Software Foundation, Inc.,                                       *
- *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
- ***************************************************************************/
-
-#ifndef _DT3155_BUFS_H_
-#define _DT3155_BUFS_H_
-
-#include <linux/pci.h>
-
-/* 4 chunks of 4MB, 9 buffers each = 36 buffers (> VIDEO_MAX_FRAME) */
-#define DT3155_CHUNK_NUM 4
-
-/* DT3155_CHUNK_SIZE should be 4M (2^22) or less, but more than image size */
-#define DT3155_CHUNK_SIZE (1U << 22)
-#define DT3155_CHUNK_FLAGS (GFP_KERNEL | GFP_DMA32 | __GFP_COLD | __GFP_NOWARN)
-
-/* DT3155_BUF_SIZE = 108 * PAGE_SIZE, so each buf is PAGE_SIZE alligned  */
-#define DT3155_BUF_SIZE (768 * 576)
-
-/**
- * struct dt3155_buf - image buffer structure
- *
- * @cpu:	virtual kernel address of the buffer
- * @dma:	dma (bus) address of the buffer
- * @next:	pointer to the next buffer in the fifo
- * @tv:		time value when the image has been acquired
- */
-struct dt3155_buf {
-	void *cpu;
-	dma_addr_t dma;
-	struct dt3155_buf *next;
-	struct timeval tv;
-};
-
-/**
- * struct dt3155_fifo - fifo structure
- *
- * @head:	pointer to the head of the fifo
- * @tail:	pionter to the tail of the fifo
- * @lock:	spin_lock to protect the fifo
- */
-struct dt3155_fifo {
-	struct dt3155_buf *head;
-	struct dt3155_buf *tail;
-	spinlock_t lock;
-};
-
-struct dt3155_buf * __must_check
-dt3155_init_chunks_buf(void);
-void
-dt3155_free_chunks_buf(struct dt3155_buf *buf);
-
-struct dt3155_fifo * __must_check
-dt3155_init_fifo(void);
-#define dt3155_free_fifo(x) kfree(x)
-
-struct dt3155_buf * __must_check
-dt3155_get_buf(struct dt3155_fifo *fifo);
-void
-dt3155_put_buf(struct dt3155_buf *buf, struct dt3155_fifo *fifo);
-
-struct dt3155_fifo * __must_check
-dt3155_init_chunks_fifo(void);
-void
-dt3155_free_chunks_fifo(struct dt3155_fifo *chunks);
-
-struct dt3155_fifo * __must_check
-dt3155_init_ibufs_fifo(struct dt3155_fifo *chunks, int buf_size);
-void
-dt3155_free_ibufs_fifo(struct dt3155_fifo *fifo);
-
-#endif /*  _DT3155_BUFS_H_  */
diff -upN a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
--- a/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-17 20:48:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c	2010-05-18 11:02:06.000000000 +0300
@@ -18,22 +18,26 @@
  *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
  ***************************************************************************/
 
-#include <media/v4l2-dev.h>
-#include <media/videobuf-core.h>
-#include <media/v4l2-ioctl.h>
-#include <linux/pci.h>
 #include <linux/version.h>
 #include <linux/stringify.h>
 #include <linux/delay.h>
-#include <media/videobuf-dma-contig.h>
 #include <linux/kthread.h>
+#include <media/v4l2-dev.h>
+#include <media/v4l2-ioctl.h>
+#include <media/videobuf-dma-contig.h>
 
 #include "dt3155v4l.h"
-#include "dt3155-bufs.h"
 
 #define DT3155_VENDOR_ID 0x8086
 #define DT3155_DEVICE_ID 0x1223
 
+/* DT3155_CHUNK_SIZE is 4M (2^22) 8 full size buffers */
+#define DT3155_CHUNK_SIZE (1U << 22)
+
+#define DT3155_COH_FLAGS (GFP_KERNEL | GFP_DMA32 | __GFP_COLD | __GFP_NOWARN)
+
+#define DT3155_BUF_SIZE (768 * 576)
+
 /*  global initializers (for all boards)  */
 #ifdef CONFIG_DT3155_CCIR
 static const u8 csr2_init = VT_50HZ;
@@ -190,441 +194,6 @@ static int wait_i2c_reg(void __iomem *ad
 	return 0;
 }
 
-/*
- * global pointers to a list of 4MB chunks reserved at driver
- * load, broken down to contiguous buffers of 768 * 576 bytes
- * each to form a pool of buffers for allocations
- * FIXME: add spinlock to protect moves between alloc/free lists
- */
-static struct dt3155_fifo *dt3155_chunks;	/* list of 4MB chuncks */
-static struct dt3155_fifo *dt3155_free_bufs;	/* list of free buffers */
-static struct dt3155_fifo *dt3155_alloc_bufs;	/* list of allocated buffers */
-
-/* same as in <drivers/media/video/videobuf-dma-contig.c> */
-struct videobuf_dma_contig_memory {
-	u32 magic;
-	void *vaddr;
-	dma_addr_t dma_handle;
-	unsigned long size;
-	int is_userptr;
-};
-
-#define MAGIC_DC_MEM 0x0733ac61
-#define MAGIC_CHECK(is, should)						    \
-	if (unlikely((is) != (should)))	{				    \
-		pr_err("magic mismatch: %x expected %x\n", (is), (should)); \
-		BUG();							    \
-	}
-
-/* helper functions to allocate/free buffers from the pool */
-static void *
-dt3155_alloc_buffer(struct device *dev, size_t size, dma_addr_t *dma_handle,
-								gfp_t flag)
-{
-	struct dt3155_buf *buf;
-
-	if (size > DT3155_BUF_SIZE)
-		return NULL;
-	size = DT3155_BUF_SIZE; /* same for CCIR & RS-170 */
-	buf = dt3155_get_buf(dt3155_free_bufs);
-	if (!buf)
-		return NULL;
-	buf->dma = dma_map_single(dev, buf->cpu, size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(dev, buf->dma)) {
-		dt3155_put_buf(buf, dt3155_free_bufs);
-		return NULL;
-	}
-	dt3155_put_buf(buf, dt3155_alloc_bufs);
-	*dma_handle = buf->dma;
-	return buf->cpu;
-}
-
-static void
-dt3155_free_buffer(struct device *dev, size_t size, void *cpu_addr,
-							dma_addr_t dma_handle)
-{
-	struct dt3155_buf *buf, *last;
-	int found = 0;
-
-	if (!cpu_addr) /* to free NULL is OK */
-		return;
-	last = dt3155_get_buf(dt3155_alloc_bufs);
-	if (!last) {
-		printk(KERN_ERR "dt3155: %s(): no alloc buffers\n", __func__);
-		return;
-	}
-	dt3155_put_buf(last, dt3155_alloc_bufs);
-	do {
-		buf = dt3155_get_buf(dt3155_alloc_bufs);
-		if (buf->cpu == cpu_addr && buf->dma == dma_handle) {
-			found = 1;
-			break;
-		}
-		dt3155_put_buf(buf, dt3155_alloc_bufs);
-	} while (buf != last);
-	if (!found) {
-		printk(KERN_ERR "dt3155: %s(): buffer not found\n", __func__);
-		return;
-	}
-	size = DT3155_BUF_SIZE; /* same for CCIR & RS-170 */
-	dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
-	dt3155_put_buf(buf, dt3155_free_bufs);
-}
-
-/* same as videobuf_dma_contig_user_get() */
-static int
-dt3155_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
-					struct videobuf_buffer *vb)
-{
-	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
-	unsigned long prev_pfn, this_pfn;
-	unsigned long pages_done, user_address;
-	unsigned int offset;
-	int ret;
-
-	offset = vb->baddr & ~PAGE_MASK;
-	mem->size = PAGE_ALIGN(vb->size + offset);
-	mem->is_userptr = 0;
-	ret = -EINVAL;
-
-	down_read(&mm->mmap_sem);
-
-	vma = find_vma(mm, vb->baddr);
-	if (!vma)
-		goto out_up;
-
-	if ((vb->baddr + mem->size) > vma->vm_end)
-		goto out_up;
-
-	pages_done = 0;
-	prev_pfn = 0; /* kill warning */
-	user_address = vb->baddr;
-
-	while (pages_done < (mem->size >> PAGE_SHIFT)) {
-		ret = follow_pfn(vma, user_address, &this_pfn);
-		if (ret)
-			break;
-
-		if (pages_done == 0)
-			mem->dma_handle = (this_pfn << PAGE_SHIFT) + offset;
-		else if (this_pfn != (prev_pfn + 1))
-			ret = -EFAULT;
-
-		if (ret)
-			break;
-
-		prev_pfn = this_pfn;
-		user_address += PAGE_SIZE;
-		pages_done++;
-	}
-
-	if (!ret)
-		mem->is_userptr = 1;
-
- out_up:
-	up_read(&current->mm->mmap_sem);
-
-	return ret;
-}
-
-/* same as videobuf_dma_contig_user_put() */
-static void
-dt3155_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
-{
-	mem->is_userptr = 0;
-	mem->dma_handle = 0;
-	mem->size = 0;
-}
-
-/* same as videobuf_iolock() but uses allocations from the pool */
-static int
-dt3155_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
-						struct v4l2_framebuffer *fbuf)
-{
-	struct videobuf_dma_contig_memory *mem = vb->priv;
-
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	switch (vb->memory) {
-	case V4L2_MEMORY_MMAP:
-		dev_dbg(q->dev, "%s memory method MMAP\n", __func__);
-
-		/* All handling should be done by __videobuf_mmap_mapper() */
-		if (!mem->vaddr) {
-			dev_err(q->dev, "memory is not alloced/mmapped.\n");
-			return -EINVAL;
-		}
-		break;
-	case V4L2_MEMORY_USERPTR:
-		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
-
-		/* handle pointer from user space */
-		if (vb->baddr)
-			return dt3155_dma_contig_user_get(mem, vb);
-
-		/* allocate memory for the read() method */
-		mem->size = PAGE_ALIGN(vb->size);
-		mem->vaddr = dt3155_alloc_buffer(q->dev, mem->size,
-						&mem->dma_handle, GFP_KERNEL);
-		if (!mem->vaddr) {
-			dev_err(q->dev, "dma_alloc_coherent %ld failed\n",
-					 mem->size);
-			return -ENOMEM;
-		}
-
-		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%ld)\n",
-			mem->vaddr, mem->size);
-		break;
-	case V4L2_MEMORY_OVERLAY:
-	default:
-		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n",
-			__func__);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-/* same as videobuf_dma_contig_free() but uses the pool */
-void
-dt3155_dma_contig_free(struct videobuf_queue *q, struct videobuf_buffer *buf)
-{
-	struct videobuf_dma_contig_memory *mem = buf->priv;
-
-	/* mmapped memory can't be freed here, otherwise mmapped region
-	   would be released, while still needed. In this case, the memory
-	   release should happen inside videobuf_vm_close().
-	   So, it should free memory only if the memory were allocated for
-	   read() operation.
-	 */
-	if (buf->memory != V4L2_MEMORY_USERPTR)
-		return;
-
-	if (!mem)
-		return;
-
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	/* handle user space pointer case */
-	if (buf->baddr) {
-		dt3155_dma_contig_user_put(mem);
-		return;
-	}
-
-	/* read() method */
-	dt3155_free_buffer(q->dev, mem->size, mem->vaddr, mem->dma_handle);
-	mem->vaddr = NULL;
-}
-
-/* same as videobuf_vm_open() */
-static void
-dt3155_vm_open(struct vm_area_struct *vma)
-{
-	struct videobuf_mapping *map = vma->vm_private_data;
-
-	dev_dbg(map->q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
-		map, map->count, vma->vm_start, vma->vm_end);
-
-	map->count++;
-}
-
-/* same as videobuf_vm_close(), but free to the pool */
-static void
-dt3155_vm_close(struct vm_area_struct *vma)
-{
-	struct videobuf_mapping *map = vma->vm_private_data;
-	struct videobuf_queue *q = map->q;
-	int i;
-
-	dev_dbg(q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
-		map, map->count, vma->vm_start, vma->vm_end);
-
-	map->count--;
-	if (0 == map->count) {
-		struct videobuf_dma_contig_memory *mem;
-
-		dev_dbg(q->dev, "munmap %p q=%p\n", map, q);
-		mutex_lock(&q->vb_lock);
-
-		/* We need first to cancel streams, before unmapping */
-		if (q->streaming)
-			videobuf_queue_cancel(q);
-
-		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
-			if (NULL == q->bufs[i])
-				continue;
-
-			if (q->bufs[i]->map != map)
-				continue;
-
-			mem = q->bufs[i]->priv;
-			if (mem) {
-				/* This callback is called only if kernel has
-				   allocated memory and this memory is mmapped.
-				   In this case, memory should be freed,
-				   in order to do memory unmap.
-				 */
-
-				MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-				/* vfree is not atomic - can't be
-				   called with IRQ's disabled
-				 */
-				dev_dbg(q->dev, "buf[%d] freeing %p\n",
-					i, mem->vaddr);
-
-				dt3155_free_buffer(q->dev, mem->size,
-						mem->vaddr, mem->dma_handle);
-				mem->vaddr = NULL;
-			}
-
-			q->bufs[i]->map   = NULL;
-			q->bufs[i]->baddr = 0;
-		}
-
-		kfree(map);
-
-		mutex_unlock(&q->vb_lock);
-	}
-}
-
-static const struct vm_operations_struct dt3155_vm_ops = {
-	.open     = dt3155_vm_open,
-	.close    = dt3155_vm_close,
-};
-
-/* same as videobuf_mmap_mapper(), but allocates from the pool */
-static int
-dt3155_mmap_mapper(struct videobuf_queue *q, struct videobuf_buffer *buf,
-						struct vm_area_struct *vma)
-{
-	struct videobuf_dma_contig_memory *mem;
-	struct videobuf_mapping *map;
-	int retval;
-	unsigned long size;
-
-	dev_dbg(q->dev, "%s\n", __func__);
-
-	/* create mapping + update buffer list */
-	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
-	if (!map)
-		return -ENOMEM;
-
-	buf->map = map;
-	map->start = vma->vm_start;
-	map->end = vma->vm_end;
-	map->q = q;
-
-	buf->baddr = vma->vm_start;
-
-	mem = buf->priv;
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	mem->size = PAGE_ALIGN(buf->bsize);
-	mem->vaddr = dt3155_alloc_buffer(q->dev, mem->size,
-					&mem->dma_handle, GFP_KERNEL);
-	if (!mem->vaddr) {
-		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
-			mem->size);
-		goto error;
-	}
-	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %ld)\n",
-		mem->vaddr, mem->size);
-
-	/* Try to remap memory */
-
-	size = vma->vm_end - vma->vm_start;
-	size = (size < mem->size) ? size : mem->size;
-
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	retval = remap_pfn_range(vma, vma->vm_start,
-				 mem->dma_handle >> PAGE_SHIFT,
-				 size, vma->vm_page_prot);
-	if (retval) {
-		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
-		dt3155_free_buffer(q->dev, mem->size,
-				  mem->vaddr, mem->dma_handle);
-		goto error;
-	}
-
-	vma->vm_ops          = &dt3155_vm_ops;
-	vma->vm_flags       |= VM_DONTEXPAND;
-	vma->vm_private_data = map;
-
-	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
-		map, q, vma->vm_start, vma->vm_end,
-		(long int)buf->bsize,
-		vma->vm_pgoff, buf->i);
-
-	dt3155_vm_open(vma);
-
-	return 0;
-
-error:
-	kfree(map);
-	return -ENOMEM;
-}
-
-static int
-dt3155_sync_for_cpu(struct videobuf_queue *q, struct videobuf_buffer *vb)
-{
-	struct dt3155_priv *pd = q->priv_data;
-	struct videobuf_dma_contig_memory *mem = vb->priv;
-
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	pci_dma_sync_single_for_cpu(pd->pdev, mem->dma_handle,
-					mem->size, PCI_DMA_FROMDEVICE);
-	return 0;
-}
-
-static int
-dt3155_sync_for_device(struct videobuf_queue *q, struct videobuf_buffer *vb)
-{
-	struct dt3155_priv *pd = q->priv_data;
-	struct videobuf_dma_contig_memory *mem = vb->priv;
-
-	BUG_ON(!mem);
-	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
-
-	pci_dma_sync_single_for_device(pd->pdev, mem->dma_handle,
-						mem->size, PCI_DMA_FROMDEVICE);
-	return 0;
-}
-
-/*
- * same as videobuf_queue_dma_contig_init(), but after
- * initialisation overwrites videobuf_iolock() and
- * videobuf_mmap_mapper() with our customized versions
- * as well as adds sync() method
- */
-static void
-dt3155_queue_dma_contig_init(struct videobuf_queue *q,
-					struct videobuf_queue_ops *ops,
-					struct device *dev,
-					spinlock_t *irqlock,
-					enum v4l2_buf_type type,
-					enum v4l2_field field,
-					unsigned int msize,
-					void *priv)
-{
-	struct dt3155_priv *pd = priv;
-
-	videobuf_queue_dma_contig_init(q, ops, dev, irqlock,
-				       type, field, msize, priv);
-	/* replace with local copy */
-	pd->qt_ops = *q->int_ops;
-	q->int_ops = &pd->qt_ops;
-	/* and overwrite with our methods */
-	q->int_ops->iolock = dt3155_iolock;
-	q->int_ops->mmap_mapper = dt3155_mmap_mapper;
-	q->int_ops->sync = dt3155_sync_for_cpu;
-}
-
 static int
 dt3155_start_acq(struct dt3155_priv *pd)
 {
@@ -699,7 +268,7 @@ dt3155_buf_prepare(struct videobuf_queue
 	if (ret) {
 		vb->state = VIDEOBUF_ERROR;
 		printk(KERN_ERR "ERROR: videobuf_iolock() failed\n");
-		videobuf_dma_contig_free(q, vb);
+		videobuf_dma_contig_free(q, vb); /* FIXME: needed? */
 	} else
 		vb->state = VIDEOBUF_PREPARED;
 	return ret;
@@ -713,7 +282,6 @@ dt3155_buf_queue(struct videobuf_queue *
 
 	if (vb->state != VIDEOBUF_NEEDS_INIT) {
 		vb->state = VIDEOBUF_QUEUED;
-		dt3155_sync_for_device(q, vb);
 		list_add_tail(&vb->queue, &pd->dmaq);
 		wake_up_interruptible_sync(&pd->do_dma);
 	} else
@@ -726,7 +294,7 @@ dt3155_buf_release(struct videobuf_queue
 {
 	if (vb->state == VIDEOBUF_ACTIVE)
 		videobuf_waiton(vb, 0, 0); /* FIXME: cannot be interrupted */
-	dt3155_dma_contig_free(q, vb);
+	videobuf_dma_contig_free(q, vb);
 	vb->state = VIDEOBUF_NEEDS_INIT;
 }
 
@@ -869,7 +437,7 @@ dt3155_open(struct file *filp)
 			ret = -ENOMEM;
 			goto err_alloc_queue;
 		}
-		dt3155_queue_dma_contig_init(pd->vidq, &vbq_ops,
+		videobuf_queue_dma_contig_init(pd->vidq, &vbq_ops,
 				&pd->pdev->dev, &pd->lock,
 				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
 				sizeof(struct videobuf_buffer), pd);
@@ -1317,11 +885,13 @@ static const struct v4l2_ioctl_ops dt315
 static int __devinit
 dt3155_init_board(struct pci_dev *dev)
 {
+	struct dt3155_priv *pd = pci_get_drvdata(dev);
+	void *buf_cpu;
+	dma_addr_t buf_dma;
 	int i;
 	u8 tmp;
-	struct dt3155_buf *buf;
-	struct dt3155_priv *pd = pci_get_drvdata(dev);
-	pci_set_master(dev); /* dt3155 needs it  */
+
+	pci_set_master(dev); /* dt3155 needs it */
 
 	/*  resetting the adapter  */
 	iowrite32(FLD_CRPT_ODD | FLD_CRPT_EVEN | FLD_DN_ODD | FLD_DN_EVEN,
@@ -1381,22 +951,16 @@ dt3155_init_board(struct pci_dev *dev)
 	write_i2c_reg(pd->regs, AD_ADDR, AD_CMD_REG);
 	write_i2c_reg(pd->regs, AD_CMD, VIDEO_CNL_1 | SYNC_CNL_1 | SYNC_LVL_3);
 
-	/* allocate and pci_map memory, and initialize the DMA machine */
-	buf = dt3155_get_buf(dt3155_free_bufs);
-	if (!buf) {
-		printk(KERN_ERR "dt3155: dt3155_get_buf "
+	/* allocate memory, and initialize the DMA machine */
+	buf_cpu = dma_alloc_coherent(&dev->dev, DT3155_BUF_SIZE, &buf_dma,
+								GFP_KERNEL);
+	if (!buf_cpu) {
+		printk(KERN_ERR "dt3155: dma_alloc_coherent "
 					"(in dt3155_init_board) failed\n");
 		return -ENOMEM;
 	}
-	buf->dma = pci_map_single(dev, buf->cpu,
-					DT3155_BUF_SIZE, PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(dev, buf->dma)) {
-		printk(KERN_ERR "dt3155: pci_map_single failed\n");
-		dt3155_put_buf(buf, dt3155_free_bufs);
-		return -ENOMEM;
-	}
-	iowrite32(buf->dma, pd->regs + EVEN_DMA_START);
-	iowrite32(buf->dma, pd->regs + ODD_DMA_START);
+	iowrite32(buf_dma, pd->regs + EVEN_DMA_START);
+	iowrite32(buf_dma, pd->regs + ODD_DMA_START);
 	iowrite32(0, pd->regs + EVEN_DMA_STRIDE);
 	iowrite32(0, pd->regs + ODD_DMA_STRIDE);
 
@@ -1413,9 +977,8 @@ dt3155_init_board(struct pci_dev *dev)
 	write_i2c_reg(pd->regs, CSR2, pd->csr2);
 	iowrite32(FIFO_EN | SRST | FLD_DN_EVEN | FLD_DN_ODD, pd->regs + CSR1);
 
-	/*  pci_unmap and deallocate memory  */
-	pci_unmap_single(dev, buf->dma, DT3155_BUF_SIZE, PCI_DMA_FROMDEVICE);
-	dt3155_put_buf(buf, dt3155_free_bufs);
+	/*  deallocate memory  */
+	dma_free_coherent(&dev->dev, DT3155_BUF_SIZE, buf_cpu, buf_dma);
 	if (tmp & BUSY_EVEN) {
 		printk(KERN_ERR "dt3155: BUSY_EVEN not cleared\n");
 		return -EIO;
@@ -1433,17 +996,82 @@ static struct video_device dt3155_vdev =
 	.current_norm = DT3155_CURRENT_NORM,
 };
 
+/* same as in drivers/base/dma-coherent.c */
+struct dma_coherent_mem {
+	void		*virt_base;
+	u32		device_base;
+	int		size;
+	int		flags;
+	unsigned long	*bitmap;
+};
+
+static int __devinit
+dt3155_alloc_coherent(struct device *dev, size_t size, int flags)
+{
+	int pages = size >> PAGE_SHIFT;
+	int bitmap_size = BITS_TO_LONGS(pages) * sizeof(long);
+
+	if ((flags & DMA_MEMORY_MAP) == 0)
+		goto out;
+	if (!size)
+		goto out;
+	if (dev->dma_mem)
+		goto out;
+
+	dev->dma_mem = kzalloc(sizeof(struct dma_coherent_mem), GFP_KERNEL);
+	if (!dev->dma_mem)
+		goto out;
+	dev->dma_mem->bitmap = kzalloc(bitmap_size, GFP_KERNEL);
+	if (!dev->dma_mem->bitmap)
+		goto err_bitmap;
+
+	dev->dma_mem->virt_base = dma_alloc_coherent(dev, size,
+				&dev->dma_mem->device_base, DT3155_COH_FLAGS);
+	if (!dev->dma_mem->virt_base)
+		goto err_coherent;
+	dev->dma_mem->size = pages;
+	dev->dma_mem->flags = flags;
+	return DMA_MEMORY_MAP;
+
+err_coherent:
+	kfree(dev->dma_mem->bitmap);
+err_bitmap:
+	kfree(dev->dma_mem);
+out:
+	return 0;
+}
+
+static void __devexit
+dt3155_free_coherent(struct device *dev)
+{
+	struct dma_coherent_mem *mem = dev->dma_mem;
+
+	if (!mem)
+		return;
+	dev->dma_mem = NULL;
+	dma_free_coherent(dev, mem->size << PAGE_SHIFT,
+					mem->virt_base, mem->device_base);
+	kfree(mem->bitmap);
+	kfree(mem);
+}
+
 static int __devinit
 dt3155_probe(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	int err = -ENODEV;
+	int err;
 	struct dt3155_priv *pd;
 
 	printk(KERN_INFO "dt3155: probe()\n");
-	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
+	err = dma_set_mask(&dev->dev, DMA_BIT_MASK(32));
+	if (err) {
 		printk(KERN_ERR "dt3155: cannot set dma_mask\n");
 		return -ENODEV;
 	}
+	err = dma_set_coherent_mask(&dev->dev, DMA_BIT_MASK(32));
+	if (err) {
+		printk(KERN_ERR "dt3155: cannot set dma_coherent_mask\n");
+		return -ENODEV;
+	}
 	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
 	if (!pd) {
 		printk(KERN_ERR "dt3155: cannot allocate dt3155_priv\n");
@@ -1451,12 +1079,12 @@ dt3155_probe(struct pci_dev *dev, const 
 	}
 	pd->vdev = video_device_alloc();
 	if (!pd->vdev) {
-		printk(KERN_ERR "dt3155: cannot allocate vdp structure\n");
+		printk(KERN_ERR "dt3155: cannot allocate vdev structure\n");
 		goto err_video_device_alloc;
 	}
 	*pd->vdev = dt3155_vdev;
-	pci_set_drvdata(dev, pd);   /* for use in dt3155_remove()  */
-	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops  */
+	pci_set_drvdata(dev, pd);    /* for use in dt3155_remove() */
+	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops */
 	pd->users = 0;
 	pd->acq_fp = NULL;
 	pd->pdev = dev;
@@ -1489,6 +1117,10 @@ dt3155_probe(struct pci_dev *dev, const 
 		printk(KERN_ERR "dt3155: Cannot register video device\n");
 		goto err_init_board;
 	}
+	err = dt3155_alloc_coherent(&dev->dev, DT3155_CHUNK_SIZE,
+							DMA_MEMORY_MAP);
+	if (err)
+		printk(KERN_INFO "dt3155: preallocated 8 buffers\n");
 	printk(KERN_INFO "dt3155: /dev/video%i is ready\n", pd->vdev->minor);
 	return 0;  /*   success   */
 
@@ -1511,6 +1143,7 @@ dt3155_remove(struct pci_dev *dev)
 	struct dt3155_priv *pd = pci_get_drvdata(dev);
 
 	printk(KERN_INFO "dt3155: remove()\n");
+	dt3155_free_coherent(&dev->dev);
 	video_unregister_device(pd->vdev);
 	pci_iounmap(dev, pd->regs);
 	pci_release_region(pd->pdev, 0);
@@ -1542,48 +1175,18 @@ dt3155_init_module(void)
 
 	printk(KERN_INFO "dt3155: ==================\n");
 	printk(KERN_INFO "dt3155: init()\n");
-	dt3155_chunks = dt3155_init_chunks_fifo();
-	if (!dt3155_chunks) {
-		err = -ENOMEM;
-		printk(KERN_ERR "dt3155: cannot init dt3155_chunks_fifo\n");
-		goto err_init_chunks_fifo;
-	}
-	dt3155_free_bufs = dt3155_init_ibufs_fifo(dt3155_chunks,
-							DT3155_BUF_SIZE);
-	if (!dt3155_free_bufs) {
-		err = -ENOMEM;
-		printk(KERN_ERR "dt3155: cannot dt3155_init_ibufs_fifo\n");
-		goto err_init_ibufs_fifo;
-	}
-	dt3155_alloc_bufs = dt3155_init_fifo();
-	if (!dt3155_alloc_bufs) {
-		err = -ENOMEM;
-		printk(KERN_ERR "dt3155: cannot dt3155_init_fifo\n");
-		goto err_init_fifo;
-	}
 	err = pci_register_driver(&pci_driver);
 	if (err) {
 		printk(KERN_ERR "dt3155: cannot register pci_driver\n");
-		goto err_register_driver;
+		return err;
 	}
 	return 0; /* succes */
-err_register_driver:
-	dt3155_free_fifo(dt3155_alloc_bufs);
-err_init_fifo:
-	dt3155_free_ibufs_fifo(dt3155_free_bufs);
-err_init_ibufs_fifo:
-	dt3155_free_chunks_fifo(dt3155_chunks);
-err_init_chunks_fifo:
-	return err;
 }
 
 static void __exit
 dt3155_exit_module(void)
 {
 	pci_unregister_driver(&pci_driver);
-	dt3155_free_fifo(dt3155_alloc_bufs);
-	dt3155_free_ibufs_fifo(dt3155_free_bufs);
-	dt3155_free_chunks_fifo(dt3155_chunks);
 	printk(KERN_INFO "dt3155: exit()\n");
 	printk(KERN_INFO "dt3155: ==================\n");
 }
diff -upN a/drivers/staging/dt3155v4l/dt3155v4l.h b/drivers/staging/dt3155v4l/dt3155v4l.h
--- a/drivers/staging/dt3155v4l/dt3155v4l.h	2010-05-17 20:48:06.000000000 +0300
+++ b/drivers/staging/dt3155v4l/dt3155v4l.h	2010-05-18 12:30:56.000000000 +0300
@@ -29,8 +29,8 @@
 
 #define DT3155_NAME "dt3155"
 #define DT3155_VER_MAJ 1
-#define DT3155_VER_MIN 0
-#define DT3155_VER_EXT 3
+#define DT3155_VER_MIN 1
+#define DT3155_VER_EXT 0
 #define DT3155_VERSION  __stringify(DT3155_VER_MAJ)	"."		\
 			__stringify(DT3155_VER_MIN)	"."		\
 			__stringify(DT3155_VER_EXT)
