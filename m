Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147Ab0CTThi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 15:37:38 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:40793 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0CTThg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 15:37:36 -0400
From: Marin Mitov <mitov@issp.bas.bg>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] Yet another (third) dt3155 driver PCI/video4linux compliant
Date: Sat, 20 Mar 2010 21:40:16 +0200
User-Agent: KMail/1.9.10
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org
References: <201003201118.36736.mitov@issp.bas.bg> <20100320130158.GA13682@kroah.com>
In-Reply-To: <20100320130158.GA13682@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003202140.16412.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.3.2010, Greg KH wrote:
> On Sat, Mar 20, 2010 at 11:18:36AM +0200, Marin Mitov wrote:
> > Hi Scott, Greg, all,
> > 
> > Here you will find a link to the source code for a dt3155 driver
> > rewritten to be  PCI/video4linux compliant.
> > 
> > http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/
> > 
> > It works with xawtv (if the window is bigger than the acquired image).
> > See 
> > 
> > http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/00README
> > 
> > for more details.
> > 
> > Any critics/comments will be appreciated.
> 
> Can you send it in patch form?  I can't really do anything with it like
> this, sorry.
> 
> greg k-h

OK, here it is:

======================================================

Kernel module (device driver) for dt3155 frame grabber
video4linux2 compliant (finaly). Works with xawtv.

======================================================

This driver is written (almost) from scratch, usung the
allocator developed for dt3155pci see bellow). The driver
uses videobuf-dma-contig interface modified to use the above
mentioned allocator instead of dma_alloc_coheren().

The first thing to do was to design a new allocator based
on allocating a configurable number of 4MB chunks of memory,
that latter are broken into frame buffers of 768x576 bytes
kept in different FIFOs (queues). As far as the driver autoloads
as a kernel module during kernel boot, the allocation of 4MB
chunks succeeds.

The driver keeps three FIFOs: one for 4MB chunks, one for free
buffers (available for allocations) and one for buffers already
allocated. Allocation/deallocation is done automatically though
the video4linux videobuf subsystem (some pointers to functions
are replaced by driver supplied functions).

Sure, there are problems:

1. The device works by read() method only (for now).

2. Works for CCIR, but should work for RS-170 (not tested)
   This is made during kernel configuration.

3. Could work for multiple dt3155 frame grabbers in a PC,
   (private data is allocated during PCI probe() method), but
   is not tested due to lack of a second board.

4. Not tested on a BIG ENDIAN architecture.

5. Many others you could find .... :-)

All critics, comments, suggestions are wellcome.

Marin Mitov

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

================================================================================
diff -uN a/drivers/staging/dt3155v4l/Kconfig b/drivers/staging/dt3155v4l/Kconfig
--- a/drivers/staging/dt3155v4l/Kconfig	1970-01-01 02:00:00.000000000 +0200
+++ b/drivers/staging/dt3155v4l/Kconfig	2010-03-20 17:59:59.000000000 +0200
@@ -0,0 +1,20 @@
+config VIDEO_DT3155
+	tristate "DT3155 frame grabber, Video4Linux interface"
+	depends on PCI && VIDEO_DEV && VIDEO_V4L2
+	select VIDEOBUF_DMA_CONTIG
+	default n
+	---help---
+	  Enables dt3155 device driver for the DataTranslation DT3155 frame grabber.
+	  Say Y here if you have this hardware.
+	  In doubt, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called dt3155_v4l.
+
+config DT3155_CCIR
+	bool "Selects CCIR/50Hz vertical refresh"
+	depends on VIDEO_DT3155
+	default y
+	---help---
+	  Select it for CCIR/50Hz (European region),
+	  or leave it unselected for RS-170/60Hz (North America).
diff -uN a/drivers/staging/dt3155v4l/Makefile b/drivers/staging/dt3155v4l/Makefile
--- a/drivers/staging/dt3155v4l/Makefile	1970-01-01 02:00:00.000000000 +0200
+++ b/drivers/staging/dt3155v4l/Makefile	2010-03-20 17:34:16.000000000 +0200
@@ -0,0 +1,4 @@
+obj-$(CONFIG_VIDEO_DT3155)	+= dt3155_v4l.o
+dt3155_v4l-objs :=	\
+		dt3155-bufs.o	\
+		dt3155v4l.o
diff -uN a/drivers/staging/dt3155v4l/dt3155-bufs.c b/drivers/staging/dt3155v4l/dt3155-bufs.c
--- a/drivers/staging/dt3155v4l/dt3155-bufs.c	1970-01-01 02:00:00.000000000 +0200
+++ b/drivers/staging/dt3155v4l/dt3155-bufs.c	2010-03-20 17:03:19.000000000 +0200
@@ -0,0 +1,256 @@
+/***************************************************************************
+ *   Copyright (C) 2006-2010 by Marin Mitov                                *
+ *   mitov@issp.bas.bg                                                     *
+ *                                                                         *
+ *   This program is free software; you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation; either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
+ *   GNU General Public License for more details.                          *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this program; if not, write to the                         *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+
+#include "dt3155-bufs.h"
+
+/**
+ * dt3155_init_chunks_buf - creates a chunk buffer and allocates memory for it
+ *
+ * returns:	a pointer to the struct dt3155_buf or NULL if failed
+ *
+ * Creates a struct dt3155_buf, then allocates a chunk of memory of
+ * size DT3155_CHUNK_SIZE and sets all the pages in it as Reserved.
+ * This is done to be able to use remap_pfn_range() on these buffers
+ * (which do not work on normal memory if Reserved bit is not set)
+ */
+struct dt3155_buf *
+dt3155_init_chunks_buf(void)
+{	/*  could sleep  */
+	struct dt3155_buf *buf;
+	int i;
+
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		return NULL;
+	buf->cpu = (void *)__get_free_pages(DT3155_CHUNK_FLAGS,
+					get_order(DT3155_CHUNK_SIZE));
+	if (!buf->cpu) {
+		kfree(buf);
+		return NULL;
+	}
+	for (i = 0; i < DT3155_CHUNK_SIZE; i += PAGE_SIZE)
+		SetPageReserved(virt_to_page(buf->cpu + i));
+	return buf;  /*   success  */
+}
+
+/**
+ * dt3155_free_chunks_buf - destroys the specified buffer
+ *
+ * @buf:	the buffer to be freed
+ *
+ * Clears Reserved bit of all pages in the chunk, frees the chunk memory
+ * and destroys struct dt3155_buf.
+ */
+void
+dt3155_free_chunks_buf(struct dt3155_buf *buf)
+{
+	int i;
+
+	for (i = 0; i < DT3155_CHUNK_SIZE; i += PAGE_SIZE)
+		ClearPageReserved(virt_to_page(buf->cpu + i));
+	free_pages((unsigned long)buf->cpu, get_order(DT3155_CHUNK_SIZE));
+	kfree(buf);
+}
+
+/**
+ * dt3155_init_fifo - creates and initializes a fifo
+ *
+ * returns:	a pointer to the crated and initialized struct dt3155_fifo
+ *		or NULL if failed
+ */
+struct dt3155_fifo *
+dt3155_init_fifo(void)
+{	/* could sleep  */
+	struct dt3155_fifo *fifo = kzalloc(sizeof(*fifo), GFP_KERNEL);
+	if (fifo)
+		spin_lock_init(&fifo->lock);
+	return fifo;
+}
+
+/*	dt3155_free_fifo(x)  defined as macro in dt3155.h   */
+
+/**
+ * dt3155_get_buf - gets a buffer from the fifo
+ *
+ * @fifo:	the fifo to get a buffer from
+ *
+ * returns:	a pointer to the buffer or NULL if failed
+ *
+ * dt3155_get_buf gets the fifo's spin_lock and returns the
+ * buffer pointed by the head. Could be used in any context.
+ */
+struct dt3155_buf *
+dt3155_get_buf(struct dt3155_fifo *fifo)
+{
+	unsigned long flags;
+	struct dt3155_buf *tmp_buf;
+
+	spin_lock_irqsave(&fifo->lock, flags);
+	tmp_buf = fifo->head;
+	if (fifo->head)
+		fifo->head = fifo->head->next;
+	if (!fifo->head)
+		fifo->tail = NULL;
+	spin_unlock_irqrestore(&fifo->lock, flags);
+	return tmp_buf;
+}
+
+/**
+ * dt3155_put_buf - puts a buffer into a fifo
+ *
+ * @buf:	the buffer to put
+ * @fifo:	the fifo to put the buffer in
+ *
+ * dt3155_put_buf gets the fifo's spin_lock and puts the buf
+ * at the tail of the fifo. Could be used in any context.
+ */
+void
+dt3155_put_buf(struct dt3155_buf *buf, struct dt3155_fifo *fifo)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&fifo->lock, flags);
+	buf->next = NULL;
+	if (fifo->tail)
+		fifo->tail->next = buf;
+	fifo->tail = buf;
+	if (!fifo->head)
+		fifo->head = buf;
+	spin_unlock_irqrestore(&fifo->lock, flags);
+}
+
+/**
+ * dt3155_init_chunks_fifo - creates and fills a chunks_fifo
+ *
+ * returns:	a pointer to the fifo or NULL if failed
+ *
+ * dt3155_init_chunks_fifo creates and fills the fifo with
+ * a number of chunks <= DT3155_CHUNK_NUM. The returned fifo
+ * contains at least one chunk.
+ */
+struct dt3155_fifo *
+dt3155_init_chunks_fifo(void)
+{	/*  could sleep  */
+	int i;
+
+	struct dt3155_fifo *chunks;
+	struct dt3155_buf *tmp_buf;
+
+	chunks = dt3155_init_fifo();
+	if (!chunks)
+		return NULL;
+	tmp_buf = dt3155_init_chunks_buf();
+	if (!tmp_buf) {
+		dt3155_free_fifo(chunks);
+		return NULL;
+	}
+	dt3155_put_buf(tmp_buf, chunks);
+	for (i = 1; i < DT3155_CHUNK_NUM; i++) {
+		tmp_buf = dt3155_init_chunks_buf();
+		if (!tmp_buf)
+			break;
+		dt3155_put_buf(tmp_buf, chunks);
+	}
+	return chunks;
+}
+
+/**
+ * dt3155_free_chunks_fifo - empties and destroys the chunks_fifo
+ *
+ * @chunks:	the chunks_fifo to be freed
+ *
+ * dt3155_free_chunks_fifo deallocates all chunks in the fifo and
+ * destroys it.
+ */
+void
+dt3155_free_chunks_fifo(struct dt3155_fifo *chunks)
+{
+	int buf_count = 0;
+	struct dt3155_buf *buf;
+
+	while ((buf = dt3155_get_buf(chunks))) {
+		dt3155_free_chunks_buf(buf);
+		buf_count++;
+	}
+	dt3155_free_fifo(chunks);
+	printk(KERN_INFO "dt3155: %i chunks freed\n", buf_count);
+}
+
+/**
+ * dt3155_init_ibufs_fifo - creates and fills an image buffer fifo
+ *
+ * @chunks:	chunks_fifo to take memory from
+ * @buf_size:	the size of image buffers
+ *
+ * returns:	a pointer to the fifo filled with image buffers
+ *
+ * dt3155_init_ibufs_fifo takes chunks from chunks_fifo, chops them
+ * into pieces of size buf_size and fills image fifo with them.
+ */
+struct dt3155_fifo *
+dt3155_init_ibufs_fifo(struct dt3155_fifo *chunks, int buf_size)
+{	/*  could sleep  */
+	int i, buf_count = 0;
+	struct dt3155_buf *tmp_ibuf, *chunks_buf, *last_chunk;
+	struct dt3155_fifo *tmp_fifo;
+
+	tmp_fifo = dt3155_init_fifo();
+	if (!tmp_fifo)
+		return NULL;
+	last_chunk = chunks->tail;
+	do {
+		chunks_buf = dt3155_get_buf(chunks);
+		dt3155_put_buf(chunks_buf, chunks);
+		for (i = 0; i < DT3155_CHUNK_SIZE / buf_size; i++) {
+			tmp_ibuf = kzalloc(sizeof(*tmp_ibuf), GFP_KERNEL);
+			if (tmp_ibuf) {
+				tmp_ibuf->cpu =
+					chunks_buf->cpu + DT3155_BUF_SIZE * i;
+				dt3155_put_buf(tmp_ibuf, tmp_fifo);
+				buf_count++;
+			} else {
+				if (buf_count) {
+					goto print_num_bufs;
+				} else {
+					dt3155_free_fifo(tmp_fifo);
+					return NULL;
+				}
+			}
+		}
+	} while (chunks_buf != last_chunk);
+print_num_bufs:
+	printk(KERN_INFO "dt3155: %i image buffers available\n", buf_count);
+	return tmp_fifo;
+}
+
+/**
+ * dt3155_free_ibufs_fifo - empties and destroys an image fifo
+ *
+ * @fifo:	the fifo to free
+ */
+void
+dt3155_free_ibufs_fifo(struct dt3155_fifo *fifo)
+{
+	struct dt3155_buf *tmp_ibuf;
+
+	while ((tmp_ibuf = dt3155_get_buf(fifo)))
+		kfree(tmp_ibuf);
+	kfree(fifo);
+}
diff -uN a/drivers/staging/dt3155v4l/dt3155-bufs.h b/drivers/staging/dt3155v4l/dt3155-bufs.h
--- a/drivers/staging/dt3155v4l/dt3155-bufs.h	1970-01-01 02:00:00.000000000 +0200
+++ b/drivers/staging/dt3155v4l/dt3155-bufs.h	2010-03-20 19:58:16.000000000 +0200
@@ -0,0 +1,86 @@
+/***************************************************************************
+ *   Copyright (C) 2006-2010 by Marin Mitov                                *
+ *   mitov@issp.bas.bg                                                     *
+ *                                                                         *
+ *   This program is free software; you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation; either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
+ *   GNU General Public License for more details.                          *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this program; if not, write to the                         *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+
+#ifndef _DT3155_BUFS_H_
+#define _DT3155_BUFS_H_
+
+#include <linux/pci.h>
+
+#define DT3155_CHUNK_NUM 1
+/* DT3155_CHUNK_SIZE should be 4M (2^22) or less, but more than image size */
+#define DT3155_CHUNK_SIZE (1U << 22)
+#define DT3155_CHUNK_FLAGS (GFP_KERNEL | GFP_DMA32 | __GFP_COLD | __GFP_NOWARN)
+
+/* DT3155_BUF_SIZE = 108 * PAGE_SIZE, so each buf is PAGE_SIZE alligned  */
+#define DT3155_BUF_SIZE (768 * 576)
+
+/**
+ * struct dt3155_buf - image buffer structure
+ *
+ * @cpu:	virtual kernel address of the buffer
+ * @dma:	dma (bus) address of the buffer
+ * @next:	pointer to the next buffer in the fifo
+ * @tv:		time value when the image has been acquired
+ */
+struct dt3155_buf {
+	void *cpu;
+	dma_addr_t dma;
+	struct dt3155_buf *next;
+	struct timeval tv;
+};
+
+/**
+ * struct dt3155_fifo - fifo structure
+ *
+ * @head:	pointer to the head of the fifo
+ * @tail:	pionter to the tail of the fifo
+ * @lock:	spin_lock to protect the fifo
+ */
+struct dt3155_fifo {
+	struct dt3155_buf *head;
+	struct dt3155_buf *tail;
+	spinlock_t lock;
+};
+
+struct dt3155_buf * __must_check
+dt3155_init_chunks_buf(void);
+void
+dt3155_free_chunks_buf(struct dt3155_buf *buf);
+
+struct dt3155_fifo * __must_check
+dt3155_init_fifo(void);
+#define dt3155_free_fifo(x) kfree(x)
+
+struct dt3155_buf * __must_check
+dt3155_get_buf(struct dt3155_fifo *fifo);
+void
+dt3155_put_buf(struct dt3155_buf *buf, struct dt3155_fifo *fifo);
+
+struct dt3155_fifo * __must_check
+dt3155_init_chunks_fifo(void);
+void
+dt3155_free_chunks_fifo(struct dt3155_fifo *chunks);
+
+struct dt3155_fifo * __must_check
+dt3155_init_ibufs_fifo(struct dt3155_fifo *chunks, int buf_size);
+void
+dt3155_free_ibufs_fifo(struct dt3155_fifo *fifo);
+
+#endif /*  _DT3155_BUFS_H_  */
diff -uN a/drivers/staging/dt3155v4l/dt3155v4l.c b/drivers/staging/dt3155v4l/dt3155v4l.c
--- a/drivers/staging/dt3155v4l/dt3155v4l.c	1970-01-01 02:00:00.000000000 +0200
+++ b/drivers/staging/dt3155v4l/dt3155v4l.c	2010-03-20 17:03:33.000000000 +0200
@@ -0,0 +1,1417 @@
+#include <media/v4l2-dev.h>
+#include <media/videobuf-core.h>
+#include <media/v4l2-ioctl.h>
+#include <linux/pci.h>
+#include <linux/version.h>
+#include <linux/stringify.h>
+#include <media/videobuf-dma-contig.h>
+
+#include "dt3155v4l.h"
+#include "dt3155-bufs.h"
+
+#define DT3155_VENDOR_ID 0x8086
+#define DT3155_DEVICE_ID 0x1223
+
+/*  global initializers (for all boards)  */
+#ifdef CONFIG_DT3155_CCIR
+static const u8 csr2_init = VT_50HZ;
+#define DT3155_CURRENT_NORM V4L2_STD_625_50
+static const unsigned int img_width = 768;
+static const unsigned int img_height = 576;
+static const struct v4l2_fmtdesc frame_std[] = {
+	{
+	.index = 0,
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	.flags = 0,
+	.description = "CCIR/50Hz 8 bits gray",
+	.pixelformat = V4L2_PIX_FMT_GREY,
+	},
+};
+#else
+static const u8 csr2_init = VT_60HZ;
+#define DT3155_CURRENT_NORM V4L2_STD_525_60
+static const unsigned int img_width = 640;
+static const unsigned int img_height = 480;
+static const struct v4l2_fmtdesc frame_std[] = {
+	{
+	.index = 0,
+	.type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
+	.flags = 0,
+	.description = "RS-170/60Hz 8 bits gray",
+	.pixelformat = V4L2_PIX_FMT_GREY,
+	},
+};
+#endif
+
+#define NUM_OF_FORMATS ARRAY_SIZE(frame_std)
+
+#define PR printk
+
+static u8 config_init = ACQ_MODE_EVEN;
+
+/**
+ * read_i2c_reg - reads an internal i2c register
+ *
+ * @addr:	dt3155 mmio base address
+ * @index:	index (internal address) of register to read
+ * @data:	pointer to byte the read data will be placed in
+ *
+ * returns:	zero on success or error code
+ *
+ * This function starts reading the specified (by index) register
+ * and busy waits for the process to finish. The result is placed
+ * in a byte pointed by data.
+ */
+static int
+read_i2c_reg(void *addr, u8 index, u8 *data)
+{
+	u32 tmp = index;
+
+	iowrite32((tmp<<17) | IIC_READ, addr + IIC_CSR2);
+	mmiowb();
+	udelay(45); /* wait at least 43 usec for NEW_CYCLE to clear */
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
+		/* error: NEW_CYCLE not cleared */
+		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
+		return -EIO;
+	}
+	tmp = ioread32(addr + IIC_CSR1);
+	if (tmp & DIRECT_ABORT) {
+		/* error: DIRECT_ABORT not cleared */
+		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
+		/* reset DIRECT_ABORT bit */
+		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
+		return -EIO;
+	}
+	*data = tmp>>24;
+	return 0;
+}
+
+/**
+ * write_i2c_reg - writes to an internal i2c register
+ *
+ * @addr:	dt3155 mmio base address
+ * @index:	index (internal address) of register to read
+ * @data:	data to be written
+ *
+ * returns:	zero on success or error code
+ *
+ * This function starts writting the specified (by index) register
+ * and busy waits for the process to finish.
+ */
+static int
+write_i2c_reg(void *addr, u8 index, u8 data)
+{
+	u32 tmp = index;
+
+	iowrite32((tmp<<17) | IIC_WRITE | data, addr + IIC_CSR2);
+	mmiowb();
+	udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
+		/* error: NEW_CYCLE not cleared */
+		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
+		return -EIO;
+	}
+	if (ioread32(addr + IIC_CSR1) & DIRECT_ABORT) {
+		/* error: DIRECT_ABORT not cleared */
+		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
+		/* reset DIRECT_ABORT bit */
+		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
+		return -EIO;
+	}
+	return 0;
+}
+
+/**
+ * write_i2c_reg_nowait - writes to an internal i2c register
+ *
+ * @addr:	dt3155 mmio base address
+ * @index:	index (internal address) of register to read
+ * @data:	data to be written
+ *
+ * This function starts writting the specified (by index) register
+ * and then returns.
+ */
+void
+write_i2c_reg_nowait(void *addr, u8 index, u8 data)
+{
+	u32 tmp = index;
+
+	iowrite32((tmp<<17) | IIC_WRITE | data, addr + IIC_CSR2);
+	mmiowb();
+}
+
+/**
+ * wait_i2c_reg - waits the read/write to finish
+ *
+ * @addr:	dt3155 mmio base address
+ *
+ * returns:	zero on success or error code
+ *
+ * This function waits reading/writting to finish.
+ */
+static int
+wait_i2c_reg(void *addr)
+{
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE)
+		udelay(65); /* wait at least 63 usec for NEW_CYCLE to clear */
+	if (ioread32(addr + IIC_CSR2) & NEW_CYCLE) {
+		/* error: NEW_CYCLE not cleared */
+		printk(KERN_ERR "dt3155: NEW_CYCLE not cleared\n");
+		return -EIO;
+	}
+	if (ioread32(addr + IIC_CSR1) & DIRECT_ABORT) {
+		/* error: DIRECT_ABORT not cleared */
+		printk(KERN_ERR "dt3155: DIRECT_ABORT set\n");
+		/* reset DIRECT_ABORT bit */
+		iowrite32(DIRECT_ABORT, addr + IIC_CSR1);
+		return -EIO;
+	}
+	return 0;
+}
+
+/*
+ * global pointers to a list of 4MB chunks reserved at driver
+ * load, broken down to contiguous buffers of 768 * 576 bytes
+ * each to form a pool of buffers for allocations
+ */
+static struct dt3155_fifo *dt3155_chunks;	/* list of 4MB chuncks */
+static struct dt3155_fifo *dt3155_free_bufs;	/* list of free buffers */
+static struct dt3155_fifo *dt3155_alloc_bufs;	/* list of allocated buffers */
+
+/* same as in <drivers/media/video/videobuf-dma-contig.c> */
+struct videobuf_dma_contig_memory {
+	u32 magic;
+	void *vaddr;
+	dma_addr_t dma_handle;
+	unsigned long size;
+	int is_userptr;
+};
+
+#define MAGIC_DC_MEM 0x0733ac61
+#define MAGIC_CHECK(is, should)						    \
+	if (unlikely((is) != (should)))	{				    \
+		pr_err("magic mismatch: %x expected %x\n", (is), (should)); \
+		BUG();							    \
+	}
+
+/* helper functions to allocate/free buffers from the pool */
+static void *
+dt3155_alloc_buffer(struct device *dev, size_t size, dma_addr_t *dma_handle,
+								gfp_t flag)
+{
+	struct dt3155_buf *buf;
+
+	if (size > img_width * img_height)
+		return NULL;
+	size = img_width * img_height;
+	buf = dt3155_get_buf(dt3155_free_bufs);
+	if (!buf)
+		return NULL;
+	buf->dma = dma_map_single(dev, buf->cpu, size, DMA_FROM_DEVICE);
+	if (dma_mapping_error(dev, buf->dma)) {
+		dt3155_put_buf(buf, dt3155_free_bufs);
+		return NULL;
+	}
+	dt3155_put_buf(buf, dt3155_alloc_bufs);
+	*dma_handle = buf->dma;
+	return buf->cpu;
+}
+
+static void
+dt3155_free_buffer(struct device *dev, size_t size, void *cpu_addr,
+							dma_addr_t dma_handle)
+{
+	struct dt3155_buf *buf, *last;
+	int found = 0;
+
+	last = dt3155_get_buf(dt3155_alloc_bufs);
+	BUG_ON(!last);
+	dt3155_put_buf(last, dt3155_alloc_bufs);
+	do {
+		buf = dt3155_get_buf(dt3155_alloc_bufs);
+		if (buf->cpu == cpu_addr && buf->dma == dma_handle) {
+			found = 1;
+			break;
+		}
+		dt3155_put_buf(buf, dt3155_alloc_bufs);
+	} while (buf != last);
+	BUG_ON(!found);
+	size = img_width * img_height;
+	dma_unmap_single(dev, dma_handle, size, DMA_FROM_DEVICE);
+	dt3155_put_buf(buf, dt3155_free_bufs);
+}
+
+/* same as videobuf_dma_contig_user_get() */
+static int
+dt3155_dma_contig_user_get(struct videobuf_dma_contig_memory *mem,
+					struct videobuf_buffer *vb)
+{
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *vma;
+	unsigned long prev_pfn, this_pfn;
+	unsigned long pages_done, user_address;
+	int ret;
+
+	mem->size = PAGE_ALIGN(vb->size);
+	mem->is_userptr = 0;
+	ret = -EINVAL;
+
+	down_read(&mm->mmap_sem);
+
+	vma = find_vma(mm, vb->baddr);
+	if (!vma)
+		goto out_up;
+
+	if ((vb->baddr + mem->size) > vma->vm_end)
+		goto out_up;
+
+	pages_done = 0;
+	prev_pfn = 0; /* kill warning */
+	user_address = vb->baddr;
+
+	while (pages_done < (mem->size >> PAGE_SHIFT)) {
+		ret = follow_pfn(vma, user_address, &this_pfn);
+		if (ret)
+			break;
+
+		if (pages_done == 0)
+			mem->dma_handle = this_pfn << PAGE_SHIFT;
+		else if (this_pfn != (prev_pfn + 1))
+			ret = -EFAULT;
+
+		if (ret)
+			break;
+
+		prev_pfn = this_pfn;
+		user_address += PAGE_SIZE;
+		pages_done++;
+	}
+
+	if (!ret)
+		mem->is_userptr = 1;
+
+ out_up:
+	up_read(&current->mm->mmap_sem);
+
+	return ret;
+}
+
+/* same as videobuf_dma_contig_user_put() */
+static void
+dt3155_dma_contig_user_put(struct videobuf_dma_contig_memory *mem)
+{
+	mem->is_userptr = 0;
+	mem->dma_handle = 0;
+	mem->size = 0;
+}
+
+/* same as videobuf_iolock() but uses allocations from the pool */
+static int
+dt3155_iolock(struct videobuf_queue *q, struct videobuf_buffer *vb,
+						struct v4l2_framebuffer *fbuf)
+{
+	struct videobuf_dma_contig_memory *mem = vb->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	switch (vb->memory) {
+	case V4L2_MEMORY_MMAP:
+		dev_dbg(q->dev, "%s memory method MMAP\n", __func__);
+
+		/* All handling should be done by __videobuf_mmap_mapper() */
+		if (!mem->vaddr) {
+			dev_err(q->dev, "memory is not alloced/mmapped.\n");
+			return -EINVAL;
+		}
+		break;
+	case V4L2_MEMORY_USERPTR:
+		dev_dbg(q->dev, "%s memory method USERPTR\n", __func__);
+
+		/* handle pointer from user space */
+		if (vb->baddr)
+			return dt3155_dma_contig_user_get(mem, vb);
+
+		/* allocate memory for the read() method */
+		mem->size = PAGE_ALIGN(vb->size);
+		mem->vaddr = dt3155_alloc_buffer(q->dev, mem->size,
+						&mem->dma_handle, GFP_KERNEL);
+		if (!mem->vaddr) {
+			dev_err(q->dev, "dma_alloc_coherent %ld failed\n",
+					 mem->size);
+			return -ENOMEM;
+		}
+
+		dev_dbg(q->dev, "dma_alloc_coherent data is at %p (%ld)\n",
+			mem->vaddr, mem->size);
+		break;
+	case V4L2_MEMORY_OVERLAY:
+	default:
+		dev_dbg(q->dev, "%s memory method OVERLAY/unknown\n",
+			__func__);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+/* same as videobuf_dma_contig_free() but uses the pool */
+void
+dt3155_dma_contig_free(struct videobuf_queue *q, struct videobuf_buffer *buf)
+{
+	struct videobuf_dma_contig_memory *mem = buf->priv;
+
+	/* mmapped memory can't be freed here, otherwise mmapped region
+	   would be released, while still needed. In this case, the memory
+	   release should happen inside videobuf_vm_close().
+	   So, it should free memory only if the memory were allocated for
+	   read() operation.
+	 */
+	if (buf->memory != V4L2_MEMORY_USERPTR)
+		return;
+
+	if (!mem)
+		return;
+
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	/* handle user space pointer case */
+	if (buf->baddr) {
+		dt3155_dma_contig_user_put(mem);
+		return;
+	}
+
+	/* read() method */
+	dt3155_free_buffer(q->dev, mem->size, mem->vaddr, mem->dma_handle);
+	mem->vaddr = NULL;
+}
+
+/* same as videobuf_vm_open() */
+static void
+dt3155_vm_open(struct vm_area_struct *vma)
+{
+	struct videobuf_mapping *map = vma->vm_private_data;
+
+	dev_dbg(map->q->dev, "vm_open %p [count=%u,vma=%08lx-%08lx]\n",
+		map, map->count, vma->vm_start, vma->vm_end);
+
+	map->count++;
+}
+
+/* same as videobuf_vm_close(), but free to the pool */
+static void
+dt3155_vm_close(struct vm_area_struct *vma)
+{
+	struct videobuf_mapping *map = vma->vm_private_data;
+	struct videobuf_queue *q = map->q;
+	int i;
+
+	dev_dbg(map->q->dev, "vm_close %p [count=%u,vma=%08lx-%08lx]\n",
+		map, map->count, vma->vm_start, vma->vm_end);
+
+	map->count--;
+	if (0 == map->count) {
+		struct videobuf_dma_contig_memory *mem;
+
+		dev_dbg(map->q->dev, "munmap %p q=%p\n", map, q);
+		mutex_lock(&q->vb_lock);
+
+		/* We need first to cancel streams, before unmapping */
+		if (q->streaming)
+			videobuf_queue_cancel(q);
+
+		for (i = 0; i < VIDEO_MAX_FRAME; i++) {
+			if (NULL == q->bufs[i])
+				continue;
+
+			if (q->bufs[i]->map != map)
+				continue;
+
+			mem = q->bufs[i]->priv;
+			if (mem) {
+				/* This callback is called only if kernel has
+				   allocated memory and this memory is mmapped.
+				   In this case, memory should be freed,
+				   in order to do memory unmap.
+				 */
+
+				MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+				/* vfree is not atomic - can't be
+				   called with IRQ's disabled
+				 */
+				dev_dbg(map->q->dev, "buf[%d] freeing %p\n",
+					i, mem->vaddr);
+
+				dt3155_free_buffer(q->dev, mem->size,
+						mem->vaddr, mem->dma_handle);
+				mem->vaddr = NULL;
+			}
+
+			q->bufs[i]->map   = NULL;
+			q->bufs[i]->baddr = 0;
+		}
+
+		kfree(map);
+
+		mutex_unlock(&q->vb_lock);
+	}
+}
+
+static const struct vm_operations_struct dt3155_vm_ops = {
+	.open     = dt3155_vm_open,
+	.close    = dt3155_vm_close,
+};
+
+/* same as videobuf_mmap_mapper(), but allocates from the pool */
+static int
+dt3155_mmap_mapper(struct videobuf_queue *q, struct vm_area_struct *vma)
+{
+	struct videobuf_dma_contig_memory *mem;
+	struct videobuf_mapping *map;
+	unsigned int first;
+	int retval;
+	unsigned long size, offset = vma->vm_pgoff << PAGE_SHIFT;
+
+	dev_dbg(q->dev, "%s\n", __func__);
+	if (!(vma->vm_flags & VM_WRITE) || !(vma->vm_flags & VM_SHARED))
+		return -EINVAL;
+
+	/* look for first buffer to map */
+	for (first = 0; first < VIDEO_MAX_FRAME; first++) {
+		if (!q->bufs[first])
+			continue;
+
+		if (V4L2_MEMORY_MMAP != q->bufs[first]->memory)
+			continue;
+		if (q->bufs[first]->boff == offset)
+			break;
+	}
+	if (VIDEO_MAX_FRAME == first) {
+		dev_dbg(q->dev, "invalid user space offset [offset=0x%lx]\n",
+			offset);
+		return -EINVAL;
+	}
+
+	/* create mapping + update buffer list */
+	map = kzalloc(sizeof(struct videobuf_mapping), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	q->bufs[first]->map = map;
+	map->start = vma->vm_start;
+	map->end = vma->vm_end;
+	map->q = q;
+
+	q->bufs[first]->baddr = vma->vm_start;
+
+	mem = q->bufs[first]->priv;
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	mem->size = PAGE_ALIGN(q->bufs[first]->bsize);
+	mem->vaddr = dt3155_alloc_buffer(q->dev, mem->size,
+					&mem->dma_handle, GFP_KERNEL);
+	if (!mem->vaddr) {
+		dev_err(q->dev, "dma_alloc_coherent size %ld failed\n",
+			mem->size);
+		goto error;
+	}
+	dev_dbg(q->dev, "dma_alloc_coherent data is at addr %p (size %ld)\n",
+		mem->vaddr, mem->size);
+
+	/* Try to remap memory */
+
+	size = vma->vm_end - vma->vm_start;
+	size = (size < mem->size) ? size : mem->size;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	retval = remap_pfn_range(vma, vma->vm_start,
+				 mem->dma_handle >> PAGE_SHIFT,
+				 size, vma->vm_page_prot);
+	if (retval) {
+		dev_err(q->dev, "mmap: remap failed with error %d. ", retval);
+		dt3155_free_buffer(q->dev, mem->size,
+				  mem->vaddr, mem->dma_handle);
+		goto error;
+	}
+
+	vma->vm_ops          = &dt3155_vm_ops;
+	vma->vm_flags       |= VM_DONTEXPAND;
+	vma->vm_private_data = map;
+
+	dev_dbg(q->dev, "mmap %p: q=%p %08lx-%08lx (%lx) pgoff %08lx buf %d\n",
+		map, q, vma->vm_start, vma->vm_end,
+		(long int) q->bufs[first]->bsize,
+		vma->vm_pgoff, first);
+
+	dt3155_vm_open(vma);
+
+	return 0;
+
+error:
+	kfree(map);
+	return -ENOMEM;
+}
+
+static int
+dt3155_sync_for_cpu(struct videobuf_queue *q, struct videobuf_buffer *vb)
+{
+	struct dt3155_priv *pd = q->priv_data;
+	struct videobuf_dma_contig_memory *mem = vb->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	pci_dma_sync_single_for_cpu(pd->pdev, mem->dma_handle,
+					mem->size, PCI_DMA_FROMDEVICE);
+	return 0;
+}
+
+static int
+dt3155_sync_for_device(struct videobuf_queue *q, struct videobuf_buffer *vb)
+{
+	struct dt3155_priv *pd = q->priv_data;
+	struct videobuf_dma_contig_memory *mem = vb->priv;
+
+	BUG_ON(!mem);
+	MAGIC_CHECK(mem->magic, MAGIC_DC_MEM);
+
+	pci_dma_sync_single_for_device(pd->pdev, mem->dma_handle,
+						mem->size, PCI_DMA_FROMDEVICE);
+	return 0;
+}
+
+/*
+ * same as videobuf_queue_dma_contig_init(), but after
+ * initialisation overwrites videobuf_iolock() and
+ * videobuf_mmap_mapper() with our customized versions
+ * as well as adds sync() method
+ */
+static void
+dt3155_queue_dma_contig_init(struct videobuf_queue *q,
+					struct videobuf_queue_ops *ops,
+					struct device *dev,
+					spinlock_t *irqlock,
+					enum v4l2_buf_type type,
+					enum v4l2_field field,
+					unsigned int msize,
+					void *priv)
+{
+	videobuf_queue_dma_contig_init(q, ops, dev, irqlock,
+				       type, field, msize, priv);
+	/* overwrite with our methods */
+	q->int_ops->iolock = dt3155_iolock;
+	q->int_ops->mmap_mapper = dt3155_mmap_mapper;
+	q->int_ops->sync = dt3155_sync_for_cpu;
+}
+
+static int
+dt3155_start_acq(struct file *filp, struct videobuf_buffer *vb,
+							const char *f_name)
+{
+	struct dt3155_priv *pd = video_drvdata(filp);
+	dma_addr_t dma_addr;
+
+	/*  prepare acquisition  */
+	pd->curr_buf = vb;
+	dma_addr = videobuf_to_dma_contig(vb);
+	iowrite32(dma_addr, pd->regs + EVEN_DMA_START);
+	iowrite32(dma_addr + vb->width, pd->regs + ODD_DMA_START);
+	iowrite32(vb->width, pd->regs + EVEN_DMA_STRIDE);
+	iowrite32(vb->width, pd->regs + ODD_DMA_STRIDE);
+	iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START |
+			FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
+	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+		  FLD_DN_ODD | FLD_DN_EVEN | CAP_CONT_EVEN | CAP_CONT_ODD,
+							pd->regs + CSR1);
+	wait_i2c_reg(pd->regs);
+	write_i2c_reg(pd->regs, CONFIG, pd->config);
+	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);
+	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);
+
+	/*  start the board  */
+	write_i2c_reg(pd->regs, CSR2, pd->csr2 | BUSY_EVEN | BUSY_ODD);
+	return 0; /* success  */
+}
+
+static int
+dt3155_stop_acq(struct file *filp, struct videobuf_buffer *vb,
+							const char *f_name)
+{
+	int tmp;
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	/*  stop the board  */
+	wait_i2c_reg(pd->regs);
+	write_i2c_reg(pd->regs, CSR2, pd->csr2);
+
+	/* disable all irqs from the board */
+	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD, pd->regs + INT_CSR);
+	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);
+	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);
+	tmp = ioread32(pd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
+	if (tmp)
+		printk(KERN_ERR "dt3155: %s(): corrupted field %u\n",
+								f_name, tmp);
+	iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+		  FLD_DN_ODD | FLD_DN_EVEN | CAP_CONT_EVEN | CAP_CONT_ODD,
+							pd->regs + CSR1);
+	return 0;
+}
+
+static int
+dt3155_buf_setup(struct videobuf_queue *q, unsigned int *count,
+							unsigned int *size)
+{
+	*size = img_width * img_height;
+	return 0;
+}
+
+static int
+dt3155_buf_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
+							enum v4l2_field field)
+{
+	int ret = 0;
+
+	vb->width = img_width;
+	vb->height = img_height;
+	vb->size = img_width * img_height;
+	vb->field = field;
+	if (vb->state == VIDEOBUF_NEEDS_INIT)
+		ret = videobuf_iolock(q, vb, NULL);
+	if (ret)
+		vb->state = VIDEOBUF_ERROR;
+	else
+		vb->state = VIDEOBUF_PREPARED;
+	return ret;
+}
+
+static void
+dt3155_buf_queue(struct videobuf_queue *q, struct videobuf_buffer *vb)
+{
+	struct dt3155_priv *pd = q->priv_data;
+
+	dt3155_sync_for_device(q, vb);
+	if (pd->acq_fp) {
+		/* start capture here for read() */
+		vb->state = VIDEOBUF_ACTIVE;
+		dt3155_start_acq(pd->acq_fp, vb, __func__);
+	} else
+		vb->state = VIDEOBUF_QUEUED;
+}
+
+static void
+dt3155_buf_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
+{
+	videobuf_waiton(vb, 0, 0); /* FIXME: cannot be interrupted */
+	dt3155_dma_contig_free(q, vb);
+}
+
+static struct videobuf_queue_ops vbq_ops = {
+	.buf_setup = dt3155_buf_setup,
+	.buf_prepare = dt3155_buf_prepare,
+	.buf_queue = dt3155_buf_queue,
+	.buf_release = dt3155_buf_release,
+};
+
+static irqreturn_t
+dt3155_irq_handler_even(int irq, void *dev_id)
+{
+	struct dt3155_priv *ipd = dev_id;
+	u32 tmp;
+
+	tmp = ioread32(ipd->regs + INT_CSR) & (FLD_START | FLD_END_ODD);
+	if (!tmp)
+		return IRQ_NONE;  /* not our irq */
+	if ((tmp & FLD_START) && !(tmp & FLD_END_ODD)) {
+		iowrite32(FLD_START_EN | FLD_END_ODD_EN | FLD_START,
+							ipd->regs + INT_CSR);
+		return IRQ_HANDLED; /* start of field irq */
+	}
+	if ((tmp & FLD_START) && (tmp & FLD_END_ODD)) {
+		if (!ipd->stats.start_before_end++)
+			printk(KERN_ERR "dt3155: irq: START before END\n");
+	}
+	/*	check for corrupted fields     */
+/*	write_i2c_reg(ipd->regs, EVEN_CSR, CSR_ERROR | CSR_DONE);	*/
+/*	write_i2c_reg(ipd->regs, ODD_CSR, CSR_ERROR | CSR_DONE);	*/
+	tmp = ioread32(ipd->regs + CSR1) & (FLD_CRPT_EVEN | FLD_CRPT_ODD);
+	if (tmp) {
+		if (!ipd->stats.corrupted_fields++)
+			printk(KERN_ERR "dt3155: corrupted field %u\n", tmp);
+		iowrite32(FIFO_EN | SRST | FLD_CRPT_ODD | FLD_CRPT_EVEN |
+						FLD_DN_ODD | FLD_DN_EVEN |
+						CAP_CONT_EVEN | CAP_CONT_ODD,
+							ipd->regs + CSR1);
+		mmiowb();
+	}
+	/* stop the board */
+	write_i2c_reg_nowait(ipd->regs, CSR2, ipd->csr2);
+	/* disable interrupts */
+	iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD, ipd->regs + INT_CSR);
+	ipd->curr_buf->state = VIDEOBUF_DONE;
+	wake_up_interruptible_sync(&ipd->curr_buf->done);
+	return IRQ_HANDLED;
+}
+
+static int
+dt3155_open(struct file *filp)
+{
+	int ret = 0;
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	PR(KERN_INFO "dt3155: open(): minor: %i\n", pd->vdev->minor);
+
+	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
+		return -ERESTARTSYS;
+	if (!pd->users) {
+		pd->vidq = kzalloc(sizeof(*pd->vidq), GFP_KERNEL);
+		if (!pd->vidq) {
+			printk(KERN_ERR "dt3155: error: alloc queue\n");
+			ret = -ENOMEM;
+			goto err_alloc_queue;
+		}
+		dt3155_queue_dma_contig_init(pd->vidq, &vbq_ops,
+				&pd->pdev->dev, &pd->lock,
+				V4L2_BUF_TYPE_VIDEO_CAPTURE, V4L2_FIELD_NONE,
+				sizeof(struct videobuf_buffer), pd);
+		/* disable all irqs */
+		iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
+						pd->regs + INT_CSR);
+		pd->irq_handler = dt3155_irq_handler_even;
+		ret = request_irq(pd->pdev->irq, pd->irq_handler,
+						IRQF_SHARED, DT3155_NAME, pd);
+		if (ret) {
+			printk(KERN_ERR "dt3155: error: request_irq\n");
+			goto err_request_irq;
+		}
+	}
+	pd->users++;
+	goto done;
+err_request_irq:
+	kfree(pd->vidq);
+	pd->vidq = NULL;
+err_alloc_queue:
+done:
+	mutex_unlock(&pd->mux);
+	return ret;
+}
+
+static int
+dt3155_release(struct file *filp)
+{
+	struct dt3155_priv *pd = video_drvdata(filp);
+	int ret = 0;
+
+	PR(KERN_INFO "dt3155: release(): minor: %i\n", pd->vdev->minor);
+
+	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
+		return -ERESTARTSYS;
+	pd->users--;
+	BUG_ON(pd->users < 0);
+	if (pd->acq_fp == filp) {
+		/* disable all irqs */
+		dt3155_stop_acq(filp, pd->curr_buf, __func__);
+		iowrite32(FLD_START | FLD_END_EVEN | FLD_END_ODD,
+							pd->regs + INT_CSR);
+		videobuf_stop(pd->vidq);
+		ret = videobuf_mmap_free(pd->vidq);
+		if (ret)
+			printk(KERN_ERR "dt3155: ERR: videobuf_mmap_free()\n");
+		pd->acq_fp = NULL;
+	}
+	if (!pd->users) {
+		free_irq(pd->pdev->irq, pd);
+		kfree(pd->vidq);
+		pd->vidq = NULL;
+	}
+	mutex_unlock(&pd->mux);
+	return ret;
+}
+
+static ssize_t
+dt3155_read(struct file *filp, char __user *user, size_t size, loff_t *loff)
+{
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
+		return -ERESTARTSYS;
+	if (!pd->acq_fp)
+		pd->acq_fp = filp;
+	else if (pd->acq_fp != filp) {
+		mutex_unlock(&pd->mux);
+		return -EBUSY;
+	}
+	mutex_unlock(&pd->mux);
+	if (size > img_width * img_height)
+		size = img_width * img_height;
+	return videobuf_read_one(pd->vidq, user, size, loff,
+						filp->f_flags & O_NONBLOCK);
+}
+
+static ssize_t
+dt3155_write(struct file *filp, const char __user *user, size_t size,
+								loff_t *loff)
+{
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	PR(KERN_DEBUG "%s()\n", __func__);
+
+	pd->vidq->read_buf->state = VIDEOBUF_DONE;
+	wake_up(&pd->vidq->read_buf->done);
+	return size;
+}
+
+static unsigned int
+dt3155_poll(struct file *filp, struct poll_table_struct *polltbl)
+{
+	struct dt3155_priv *pd = video_drvdata(filp);
+	int ret;
+
+	PR(KERN_DEBUG "%s()\n", __func__);
+
+	if (mutex_lock_interruptible(&pd->mux) == -EINTR)
+		return -ERESTARTSYS;
+	ret = videobuf_poll_stream(filp, pd->vidq, polltbl);
+	mutex_unlock(&pd->mux);
+	return ret;
+}
+
+/*
+static int
+dt3155_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	printk(KERN_DEBUG "%s()\n", __func__);
+
+	return 0;
+}
+*/
+
+static const struct v4l2_file_operations dt3155_fops = {
+	.owner = THIS_MODULE,
+	.open = dt3155_open,
+	.release = dt3155_release,
+	.read = dt3155_read,
+	.write = dt3155_write,
+	.poll = dt3155_poll,
+	.unlocked_ioctl = video_ioctl2, /* V4L2 ioctl handler */
+/*
+	.mmap = dt3155_mmap,
+*/
+};
+
+static int
+dt3155_ioc_querycap(struct file *filp, void *priv, struct v4l2_capability *cap)
+{
+	struct dt3155_priv *pd = video_drvdata(filp);
+
+	strcpy(cap->driver, DT3155_NAME);
+	strcpy(cap->card, DT3155_NAME " frame grabber");
+	sprintf(cap->bus_info, "PCI:%s", pci_name(pd->pdev));
+	cap->version =
+	       KERNEL_VERSION(DT3155_VER_MAJ, DT3155_VER_MIN, DT3155_VER_EXT);
+	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE |
+/*
+				V4L2_CAP_STREAMING |
+*/
+				V4L2_CAP_READWRITE;
+	return 0;
+}
+
+static int
+dt3155_ioc_enum_fmt_vid_cap(struct file *filp, void *priv,
+							struct v4l2_fmtdesc *f)
+{
+	if (f->index >= NUM_OF_FORMATS)
+		return -EINVAL;
+	*f = frame_std[f->index];
+	return 0;
+}
+
+static int
+dt3155_ioc_g_fmt_vid_cap(struct file *filp, void *priv, struct v4l2_format *f)
+{
+	PR(KERN_DEBUG "Entering: %s()\n", __func__);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	f->fmt.pix.width = img_width;
+	f->fmt.pix.height = img_height;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_GREY;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.bytesperline = f->fmt.pix.width;
+	f->fmt.pix.sizeimage = f->fmt.pix.width * f->fmt.pix.height;
+	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.priv = 0;
+	return 0;
+}
+
+static int
+dt3155_ioc_try_fmt_vid_cap(struct file *filp, void *priv,
+							struct v4l2_format *f)
+{
+	PR(KERN_DEBUG "Entering: %s()\n", __func__);
+
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (f->fmt.pix.width == img_width &&
+		f->fmt.pix.height == img_height &&
+		f->fmt.pix.pixelformat == V4L2_PIX_FMT_GREY &&
+		f->fmt.pix.field == V4L2_FIELD_NONE &&
+		f->fmt.pix.bytesperline == f->fmt.pix.width &&
+		f->fmt.pix.sizeimage == f->fmt.pix.width * f->fmt.pix.height)
+			return 0;
+	else
+		return -EINVAL;
+}
+
+static int
+dt3155_ioc_s_fmt_vid_cap(struct file *filp, void *priv, struct v4l2_format *f)
+{
+	if (f->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	f->fmt.pix.width = img_width;
+	f->fmt.pix.height = img_height;
+	f->fmt.pix.pixelformat = V4L2_PIX_FMT_GREY;
+	f->fmt.pix.field = V4L2_FIELD_NONE;
+	f->fmt.pix.bytesperline = f->fmt.pix.width;
+	f->fmt.pix.sizeimage = f->fmt.pix.width * f->fmt.pix.height;
+	f->fmt.pix.colorspace = 0;
+	f->fmt.pix.priv = 0;
+	return 0;
+}
+
+static int
+dt3155_ioc_reqbufs(struct file *filp, void *fh, struct v4l2_requestbuffers *b)
+{
+	struct videobuf_queue *q = fh;
+
+	PR(KERN_DEBUG "Entering: %s()\n", __func__);
+
+	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (b->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+	b->count = VIDEO_MAX_FRAME;
+	return videobuf_reqbufs(q, b);
+}
+
+static int
+dt3155_ioc_querybuf(struct file *filp, void *fh, struct v4l2_buffer *b)
+{
+	struct videobuf_queue *q = fh;
+
+	PR(KERN_DEBUG "Entering: %s()\n", __func__);
+
+	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (b->index >= VIDEO_MAX_FRAME)
+		return -EINVAL;
+	b->bytesused = img_width * img_height;
+	b->field = V4L2_FIELD_NONE;
+	b->length = b->bytesused;
+	return videobuf_querybuf(q, b);
+}
+
+static int
+dt3155_ioc_qbuf(struct file *filp, void *fh, struct v4l2_buffer *b)
+{
+	struct videobuf_queue *q = fh;
+
+	PR(KERN_DEBUG "Entering: %s()\n", __func__);
+
+	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (b->index >= VIDEO_MAX_FRAME || b->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+	b->flags = V4L2_BUF_FLAG_QUEUED;
+	return videobuf_qbuf(q, b);
+}
+
+static int
+dt3155_ioc_dqbuf(struct file *filp, void *fh, struct v4l2_buffer *b)
+{
+	struct videobuf_queue *q = fh;
+
+	PR(KERN_DEBUG "Entering: %s()\n", __func__);
+
+	if (b->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
+		return -EINVAL;
+	if (b->index >= VIDEO_MAX_FRAME || b->memory != V4L2_MEMORY_MMAP)
+		return -EINVAL;
+	b->flags = V4L2_BUF_FLAG_MAPPED;
+	return videobuf_dqbuf(q, b, 0);
+}
+
+static int
+dt3155_ioc_querystd(struct file *filp, void *fh, v4l2_std_id *norm)
+{
+	*norm = DT3155_CURRENT_NORM;
+	return 0;
+}
+
+static int
+dt3155_ioc_g_std(struct file *filp, void *fh, v4l2_std_id *norm)
+{
+	*norm = DT3155_CURRENT_NORM;
+	return 0;
+}
+
+static int
+dt3155_ioc_s_std(struct file *filp, void *fh, v4l2_std_id *norm)
+{
+	if (*norm & DT3155_CURRENT_NORM)
+		return 0;
+	return -EINVAL;
+}
+
+static int
+dt3155_ioc_enum_input(struct file *filp, void *priv, struct v4l2_input *input)
+{
+	if (input->index)
+		return -EINVAL;
+	strcpy(input->name, "Coax in");
+	input->type = V4L2_INPUT_TYPE_CAMERA;
+	input->std = V4L2_STD_ALL;
+	input->status = 0;/* FIXME: add sync detection & V4L2_IN_ST_NO_H_LOCK */
+	return 0;
+}
+
+static int
+dt3155_ioc_g_input(struct file *filp, void *priv, unsigned int *i)
+{
+	*i = 0;
+	return 0;
+}
+
+static int
+dt3155_ioc_s_input(struct file *filp, void *priv, unsigned int i)
+{
+	if (i)
+		return -EINVAL;
+	return 0;
+}
+
+static const struct v4l2_ioctl_ops dt3155_ioctl_ops = {
+	.vidioc_querycap = dt3155_ioc_querycap,
+/*
+	.vidioc_g_priority = dt3155_ioc_g_priority,
+	.vidioc_s_priority = dt3155_ioc_s_priority,
+*/
+	.vidioc_enum_fmt_vid_cap = dt3155_ioc_enum_fmt_vid_cap,
+	.vidioc_try_fmt_vid_cap = dt3155_ioc_try_fmt_vid_cap,
+	.vidioc_g_fmt_vid_cap = dt3155_ioc_g_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap = dt3155_ioc_s_fmt_vid_cap,
+	.vidioc_reqbufs = dt3155_ioc_reqbufs,
+	.vidioc_querybuf = dt3155_ioc_querybuf,
+	.vidioc_qbuf = dt3155_ioc_qbuf,
+	.vidioc_dqbuf = dt3155_ioc_dqbuf,
+	.vidioc_querystd = dt3155_ioc_querystd,
+	.vidioc_g_std = dt3155_ioc_g_std,
+	.vidioc_s_std = dt3155_ioc_s_std,
+	.vidioc_enum_input = dt3155_ioc_enum_input,
+	.vidioc_g_input = dt3155_ioc_g_input,
+	.vidioc_s_input = dt3155_ioc_s_input,
+/*
+	.vidioc_queryctrl = dt3155_ioc_queryctrl,
+	.vidioc_g_ctrl = dt3155_ioc_g_ctrl,
+	.vidioc_s_ctrl = dt3155_ioc_s_ctrl,
+	.vidioc_querymenu = dt3155_ioc_querymenu,
+	.vidioc_g_ext_ctrls = dt3155_ioc_g_ext_ctrls,
+	.vidioc_s_ext_ctrls = dt3155_ioc_s_ext_ctrls,
+	.vidioc_streamon = dt3155_ioc_streamon,
+	.vidioc_streamoff = dt3155_ioc_streamoff,
+	.vidioc_g_parm = dt3155_ioc_g_parm,
+	.vidioc_s_parm = dt3155_ioc_s_parm,
+	.vidioc_cropcap = dt3155_ioc_cropcap,
+	.vidioc_g_crop = dt3155_ioc_g_crop,
+	.vidioc_s_crop = dt3155_ioc_s_crop,
+	.vidioc_enum_framesizes = dt3155_ioc_enum_framesizes,
+	.vidioc_enum_frameintervals = dt3155_ioc_enum_frameintervals,
+#ifdef CONFIG_VIDEO_V4L1_COMPAT
+	.vidiocgmbuf = iocgmbuf,
+#endif
+*/
+};
+
+static int __devinit
+dt3155_init_board(struct pci_dev *dev)
+{
+	int i;
+	u8 tmp;
+	struct dt3155_buf *buf;
+	struct dt3155_priv *pd = pci_get_drvdata(dev);
+	pci_set_master(dev); /* dt3155 needs it  */
+
+	/*  resetting the adapter  */
+	iowrite32(FLD_CRPT_ODD | FLD_CRPT_EVEN | FLD_DN_ODD | FLD_DN_EVEN,
+							pd->regs + CSR1);
+	mmiowb();
+	msleep(10);
+
+	/*  initializing adaper registers  */
+	iowrite32(FIFO_EN | SRST, pd->regs + CSR1);
+	mmiowb();
+	iowrite32(0xEEEEEE01, pd->regs + EVEN_PIXEL_FMT);
+	iowrite32(0xEEEEEE01, pd->regs + ODD_PIXEL_FMT);
+	iowrite32(0x00000020, pd->regs + FIFO_TRIGER);
+	iowrite32(0x00000103, pd->regs + XFER_MODE);
+	iowrite32(0, pd->regs + RETRY_WAIT_CNT);
+	iowrite32(0, pd->regs + INT_CSR);
+	iowrite32(1, pd->regs + EVEN_FLD_MASK);
+	iowrite32(1, pd->regs + ODD_FLD_MASK);
+	iowrite32(0, pd->regs + MASK_LENGTH);
+	iowrite32(0x0005007C, pd->regs + FIFO_FLAG_CNT);
+	iowrite32(0x01010101, pd->regs + IIC_CLK_DUR);
+	mmiowb();
+
+	/* verifying that we have a DT3155 board (not just a SAA7116 chip) */
+	read_i2c_reg(pd->regs, DT_ID, &tmp);
+	if (tmp != DT3155_ID)
+		return -ENODEV;
+
+	/* initialize AD LUT */
+	write_i2c_reg(pd->regs, AD_ADDR, 0);
+	for (i = 0; i < 256; i++)
+		write_i2c_reg(pd->regs, AD_LUT, i);
+
+	/* initialize ADC references */
+	/* FIXME: pos_ref & neg_ref depend on VT_50HZ */
+	write_i2c_reg(pd->regs, AD_ADDR, AD_CMD_REG);
+	write_i2c_reg(pd->regs, AD_CMD, VIDEO_CNL_1 | SYNC_CNL_1 | SYNC_LVL_3);
+	write_i2c_reg(pd->regs, AD_ADDR, AD_POS_REF);
+	write_i2c_reg(pd->regs, AD_CMD, 34);
+	write_i2c_reg(pd->regs, AD_ADDR, AD_NEG_REF);
+	write_i2c_reg(pd->regs, AD_CMD, 0);
+
+	/* initialize PM LUT */
+	write_i2c_reg(pd->regs, CONFIG, pd->config | PM_LUT_PGM);
+	for (i = 0; i < 256; i++) {
+		write_i2c_reg(pd->regs, PM_LUT_ADDR, i);
+		write_i2c_reg(pd->regs, PM_LUT_DATA, i);
+	}
+	write_i2c_reg(pd->regs, CONFIG, pd->config | PM_LUT_PGM | PM_LUT_SEL);
+	for (i = 0; i < 256; i++) {
+		write_i2c_reg(pd->regs, PM_LUT_ADDR, i);
+		write_i2c_reg(pd->regs, PM_LUT_DATA, i);
+	}
+	write_i2c_reg(pd->regs, CONFIG, pd->config); /*  ACQ_MODE_EVEN  */
+
+	/* select chanel 1 for input and set sync level */
+	write_i2c_reg(pd->regs, AD_ADDR, AD_CMD_REG);
+	write_i2c_reg(pd->regs, AD_CMD, VIDEO_CNL_1 | SYNC_CNL_1 | SYNC_LVL_3);
+
+	/* allocate and pci_map memory, and initialize the DMA machine */
+	buf = dt3155_get_buf(dt3155_free_bufs);
+	if (!buf) {
+		printk(KERN_ERR "dt3155: dt3155_get_buf "
+					"(in dt3155_init_board) failed\n");
+		return -ENOMEM;
+	}
+	buf->dma = pci_map_single(dev, buf->cpu,
+					DT3155_BUF_SIZE, PCI_DMA_FROMDEVICE);
+	if (pci_dma_mapping_error(dev, buf->dma)) {
+		printk(KERN_ERR "dt3155: pci_map_single failed\n");
+		dt3155_put_buf(buf, dt3155_free_bufs);
+		return -ENOMEM;
+	}
+	iowrite32(buf->dma, pd->regs + EVEN_DMA_START);
+	iowrite32(buf->dma, pd->regs + ODD_DMA_START);
+	iowrite32(0, pd->regs + EVEN_DMA_STRIDE);
+	iowrite32(0, pd->regs + ODD_DMA_STRIDE);
+
+	/*  Perform a pseudo even field acquire    */
+	iowrite32(FIFO_EN | SRST | CAP_CONT_ODD, pd->regs + CSR1);
+	write_i2c_reg(pd->regs, CSR2, pd->csr2 | SYNC_SNTL);
+	write_i2c_reg(pd->regs, CONFIG, pd->config);
+	write_i2c_reg(pd->regs, EVEN_CSR, CSR_SNGL);
+	write_i2c_reg(pd->regs, CSR2, pd->csr2 | BUSY_EVEN | SYNC_SNTL);
+	msleep(100);
+	read_i2c_reg(pd->regs, CSR2, &tmp);
+	write_i2c_reg(pd->regs, EVEN_CSR, CSR_ERROR | CSR_SNGL | CSR_DONE);
+	write_i2c_reg(pd->regs, ODD_CSR, CSR_ERROR | CSR_SNGL | CSR_DONE);
+	write_i2c_reg(pd->regs, CSR2, pd->csr2);
+	iowrite32(FIFO_EN | SRST | FLD_DN_EVEN | FLD_DN_ODD, pd->regs + CSR1);
+
+	/*  pci_unmap and deallocate memory  */
+	pci_unmap_single(dev, buf->dma, DT3155_BUF_SIZE, PCI_DMA_FROMDEVICE);
+	dt3155_put_buf(buf, dt3155_free_bufs);
+	if (tmp & BUSY_EVEN) {
+		printk(KERN_ERR "dt3155: BUSY_EVEN not cleared\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+static struct video_device dt3155_vdev = {
+	.name = DT3155_NAME,
+	.fops = &dt3155_fops,
+	.ioctl_ops = &dt3155_ioctl_ops,
+	.minor = -1,
+	.release = video_device_release,
+	.tvnorms = V4L2_STD_ALL,
+	.current_norm = DT3155_CURRENT_NORM,
+};
+
+static int __devinit
+dt3155_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	int err = -ENODEV;
+	struct dt3155_priv *pd;
+
+	printk(KERN_INFO "dt3155: probe()\n");
+	if (pci_set_dma_mask(dev, DMA_BIT_MASK(32))) {
+		printk(KERN_ERR "dt3155: cannot set dma_mask\n");
+		return -ENODEV;
+	}
+	pd = kzalloc(sizeof(*pd), GFP_KERNEL);
+	if (!pd) {
+		printk(KERN_ERR "dt3155: cannot allocate dt3155_priv\n");
+		return -ENOMEM;
+	}
+	pd->vdev = video_device_alloc();
+	if (!pd->vdev) {
+		printk(KERN_ERR "dt3155: cannot allocate vdp structure\n");
+		goto err_video_device_alloc;
+	}
+	*pd->vdev = dt3155_vdev;
+	pci_set_drvdata(dev, pd);   /* for use in dt3155_remove()  */
+	video_set_drvdata(pd->vdev, pd);  /* for use in video_fops  */
+	pd->users = 0;
+	pd->acq_fp = NULL;
+	pd->pdev = dev;
+	mutex_init(&pd->mux);
+	pd->csr2 = csr2_init;
+	pd->config = config_init;
+	err = pci_enable_device(pd->pdev);
+	if (err) {
+		printk(KERN_ERR "dt3155: pci_dev not enabled\n");
+		goto err_enable_dev;
+	}
+	err = pci_request_region(pd->pdev, 0, pci_name(pd->pdev));
+	if (err)
+		goto err_req_region;
+	pd->regs = pci_iomap(pd->pdev, 0, pci_resource_len(pd->pdev, 0));
+	if (!pd->regs) {
+		err = -ENOMEM;
+		printk(KERN_ERR "dt3155: pci_iomap failed\n");
+		goto err_pci_iomap;
+	}
+	err = dt3155_init_board(pd->pdev);
+	if (err) {
+		printk(KERN_ERR "dt3155: dt3155_init_board failed\n");
+		goto err_init_board;
+	}
+	err = video_register_device(pd->vdev, VFL_TYPE_GRABBER, -1);
+	if (err) {
+		printk(KERN_ERR "dt3155: Cannot register video device\n");
+		goto err_init_board;
+	}
+	printk(KERN_INFO "dt3155: /dev/video%i is ready\n", pd->vdev->minor);
+	return 0;  /*   success   */
+
+err_init_board:
+	pci_iounmap(pd->pdev, pd->regs);
+err_pci_iomap:
+	pci_release_region(pd->pdev, 0);
+err_req_region:
+	pci_disable_device(pd->pdev);
+err_enable_dev:
+	video_device_release(pd->vdev);
+err_video_device_alloc:
+	kfree(pd);
+	return err;
+}
+
+static void __devexit
+dt3155_remove(struct pci_dev *dev)
+{
+	struct dt3155_priv *pd = pci_get_drvdata(dev);
+
+	printk(KERN_INFO "dt3155: remove()\n");
+	video_unregister_device(pd->vdev);
+	pci_iounmap(dev, pd->regs);
+	pci_release_region(pd->pdev, 0);
+	pci_disable_device(pd->pdev);
+	/*
+	 * video_device_release() is invoked automatically
+	 * see: struct video_device dt3155_vdev
+	 */
+	kfree(pd);
+}
+
+static DEFINE_PCI_DEVICE_TABLE(pci_ids) = {
+	{ PCI_DEVICE(DT3155_VENDOR_ID, DT3155_DEVICE_ID) },
+	{ 0, /* zero marks the end */ },
+};
+MODULE_DEVICE_TABLE(pci, pci_ids);
+
+static struct pci_driver pci_driver = {
+	.name = DT3155_NAME,
+	.id_table = pci_ids,
+	.probe = dt3155_probe,
+	.remove = __devexit_p(dt3155_remove),
+};
+
+static int __init
+dt3155_init_module(void)
+{
+	int err;
+
+	printk(KERN_INFO "dt3155: ==================\n");
+	printk(KERN_INFO "dt3155: init()\n");
+	dt3155_chunks = dt3155_init_chunks_fifo();
+	if (!dt3155_chunks) {
+		err = -ENOMEM;
+		printk(KERN_ERR "dt3155: cannot init dt3155_chunks_fifo\n");
+		goto err_init_chunks_fifo;
+	}
+	dt3155_free_bufs = dt3155_init_ibufs_fifo(dt3155_chunks,
+							DT3155_BUF_SIZE);
+	if (!dt3155_free_bufs) {
+		err = -ENOMEM;
+		printk(KERN_ERR "dt3155: cannot dt3155_init_ibufs_fifo\n");
+		goto err_init_ibufs_fifo;
+	}
+	dt3155_alloc_bufs = dt3155_init_fifo();
+	if (!dt3155_alloc_bufs) {
+		err = -ENOMEM;
+		printk(KERN_ERR "dt3155: cannot dt3155_init_fifo\n");
+		goto err_init_fifo;
+	}
+	err = pci_register_driver(&pci_driver);
+	if (err) {
+		printk(KERN_ERR "dt3155: cannot register pci_driver\n");
+		goto err_register_driver;
+	}
+	return 0; /* succes */
+err_register_driver:
+	dt3155_free_fifo(dt3155_alloc_bufs);
+err_init_fifo:
+	dt3155_free_ibufs_fifo(dt3155_free_bufs);
+err_init_ibufs_fifo:
+	dt3155_free_chunks_fifo(dt3155_chunks);
+err_init_chunks_fifo:
+	return err;
+}
+
+static void __exit
+dt3155_exit_module(void)
+{
+	pci_unregister_driver(&pci_driver);
+	dt3155_free_fifo(dt3155_alloc_bufs);
+	dt3155_free_ibufs_fifo(dt3155_free_bufs);
+	dt3155_free_chunks_fifo(dt3155_chunks);
+	printk(KERN_INFO "dt3155: exit()\n");
+	printk(KERN_INFO "dt3155: ==================\n");
+}
+
+module_init(dt3155_init_module);
+module_exit(dt3155_exit_module);
+
+MODULE_DESCRIPTION("video4linux pci-driver for dt3155 frame grabber");
+MODULE_AUTHOR("Marin Mitov <mitov@issp.bas.bg>");
+MODULE_VERSION(DT3155_VERSION);
+MODULE_LICENSE("GPL");
diff -uN a/drivers/staging/dt3155v4l/dt3155v4l.h b/drivers/staging/dt3155v4l/dt3155v4l.h
--- a/drivers/staging/dt3155v4l/dt3155v4l.h	1970-01-01 02:00:00.000000000 +0200
+++ b/drivers/staging/dt3155v4l/dt3155v4l.h	2010-03-20 18:07:01.000000000 +0200
@@ -0,0 +1,214 @@
+/***************************************************************************
+ *   Copyright (C) 2006-2010 by Marin Mitov                                *
+ *   mitov@issp.bas.bg                                                     *
+ *                                                                         *
+ *   This program is free software; you can redistribute it and/or modify  *
+ *   it under the terms of the GNU General Public License as published by  *
+ *   the Free Software Foundation; either version 2 of the License, or     *
+ *   (at your option) any later version.                                   *
+ *                                                                         *
+ *   This program is distributed in the hope that it will be useful,       *
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
+ *   GNU General Public License for more details.                          *
+ *                                                                         *
+ *   You should have received a copy of the GNU General Public License     *
+ *   along with this program; if not, write to the                         *
+ *   Free Software Foundation, Inc.,                                       *
+ *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
+ ***************************************************************************/
+
+/*    DT3155 header file    */
+#ifndef _DT3155_H_
+#define _DT3155_H_
+
+#ifdef __KERNEL__
+
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+
+#define DT3155_NAME "dt3155"
+#define DT3155_VER_MAJ 1
+#define DT3155_VER_MIN 0
+#define DT3155_VER_EXT 0
+#define DT3155_VERSION  __stringify(DT3155_VER_MAJ)	"."		\
+			__stringify(DT3155_VER_MIN)	"."		\
+			__stringify(DT3155_VER_EXT)
+
+/* DT3155 Base Register offsets (memory mapped) */
+#define EVEN_DMA_START	 0x00
+#define ODD_DMA_START	 0x0C
+#define EVEN_DMA_STRIDE  0x18
+#define ODD_DMA_STRIDE	 0x24
+#define EVEN_PIXEL_FMT	 0x30
+#define ODD_PIXEL_FMT	 0x34
+#define FIFO_TRIGER	 0x38
+#define XFER_MODE	 0x3C
+#define CSR1		 0x40
+#define RETRY_WAIT_CNT	 0x44
+#define INT_CSR		0x48
+#define EVEN_FLD_MASK	 0x4C
+#define ODD_FLD_MASK	 0x50
+#define MASK_LENGTH	 0x54
+#define FIFO_FLAG_CNT	 0x58
+#define IIC_CLK_DUR	 0x5C
+#define IIC_CSR1	 0x60
+#define IIC_CSR2	 0x64
+
+/*  DT3155 Internal Registers indexes (i2c/IIC mapped) */
+#define CSR2	     0x10
+#define EVEN_CSR     0x11
+#define ODD_CSR      0x12
+#define CONFIG	     0x13
+#define DT_ID	     0x1F
+#define X_CLIP_START 0x20
+#define Y_CLIP_START 0x22
+#define X_CLIP_END   0x24
+#define Y_CLIP_END   0x26
+#define AD_ADDR      0x30
+#define AD_LUT	     0x31
+#define AD_CMD	     0x32
+#define DIG_OUT      0x40
+#define PM_LUT_ADDR  0x50
+#define PM_LUT_DATA  0x51
+
+/* AD command register values  */
+#define AD_CMD_REG   0x00
+#define AD_POS_REF   0x01
+#define AD_NEG_REF   0x02
+
+/* CSR1 bit masks */
+#define CRPT_DIS       0x00004000
+#define FLD_CRPT_ODD   0x00000200
+#define FLD_CRPT_EVEN  0x00000100
+#define FIFO_EN        0x00000080
+#define SRST	       0x00000040
+#define FLD_DN_ODD     0x00000020
+#define FLD_DN_EVEN    0x00000010
+/*   These should not be used.
+ *   Use CAP_CONT_ODD/EVEN instead
+#define CAP_SNGL_ODD   0x00000008
+#define CAP_SNGL_EVEN  0x00000004
+*/
+#define CAP_CONT_ODD   0x00000002
+#define CAP_CONT_EVEN  0x00000001
+
+/*  INT_CSR bit masks */
+#define FLD_START_EN	 0x00000400
+#define FLD_END_ODD_EN	 0x00000200
+#define FLD_END_EVEN_EN  0x00000100
+#define FLD_START	 0x00000004
+#define FLD_END_ODD	 0x00000002
+#define FLD_END_EVEN	 0x00000001
+
+/* IIC_CSR1 bit masks */
+#define DIRECT_ABORT	 0x00000200
+
+/* IIC_CSR2 bit masks */
+#define NEW_CYCLE   0x01000000
+#define DIR_RD	    0x00010000
+#define IIC_READ    0x01010000
+#define IIC_WRITE   0x01000000
+
+/* CSR2 bit masks */
+#define DISP_PASS     0x40
+#define BUSY_ODD      0x20
+#define BUSY_EVEN     0x10
+#define SYNC_PRESENT  0x08
+#define VT_50HZ       0x04
+#define SYNC_SNTL     0x02
+#define CHROM_FILT    0x01
+#define VT_60HZ       0x00
+
+/* CSR_EVEN/ODD bit masks */
+#define CSR_ERROR	0x04
+#define CSR_SNGL	0x02
+#define CSR_DONE	0x01
+
+/* CONFIG bit masks */
+#define PM_LUT_PGM     0x80
+#define PM_LUT_SEL     0x40
+#define CLIP_EN        0x20
+#define HSCALE_EN      0x10
+#define EXT_TRIG_UP    0x0C
+#define EXT_TRIG_DOWN  0x04
+#define ACQ_MODE_NEXT  0x02
+#define ACQ_MODE_ODD   0x01
+#define ACQ_MODE_EVEN  0x00
+
+/* AD_CMD bit masks */
+#define VIDEO_CNL_1  0x00
+#define VIDEO_CNL_2  0x40
+#define VIDEO_CNL_3  0x80
+#define VIDEO_CNL_4  0xC0
+#define SYNC_CNL_1   0x00
+#define SYNC_CNL_2   0x10
+#define SYNC_CNL_3   0x20
+#define SYNC_CNL_4   0x30
+#define SYNC_LVL_1   0x00
+#define SYNC_LVL_2   0x04
+#define SYNC_LVL_3   0x08
+#define SYNC_LVL_4   0x0C
+
+/* DT3155 identificator */
+#define DT3155_ID   0x20
+
+#ifdef CONFIG_DT3155_CCIR
+	#define DMA_STRIDE 768
+#else
+	#define DMA_STRIDE 640
+#endif
+
+/**
+ * struct dt3155_stats - statistics structure
+ *
+ * @free_bufs_empty:	no free image buffers
+ * @corrupted_fields:	corrupted fields
+ * @dma_map_failed:	dma mapping failed
+ * @start_before_end:	new started before old ended
+ */
+struct dt3155_stats {
+	int free_bufs_empty;
+	int corrupted_fields;
+	int dma_map_failed;
+	int start_before_end;
+};
+
+/*    per board private data structure   */
+/**
+ * struct dt3155_priv - private data structure
+ *
+ * @vdev:		pointer to video_device structure
+ * @acq_fp		pointer to filp that starts acquisition
+ * @pdev:		pointer to pci_dev structure
+ * @vidq		pointer to videobuf_queue structure
+ * @curr_buf:		pointer to curren buffer
+ * @irq_handler:	irq handler for the driver
+ * @mux:		mutex to protect the instance
+ * @lock		spinlock
+ * @stats:		statistics structure
+ * @users		open count
+ * @dma_running		dma is running
+ * @regs:		local copy of mmio base register
+ * @csr2:		local copy of csr2 register
+ * @config:		local copy of config register
+ */
+struct dt3155_priv {
+	struct video_device *vdev;
+	struct file *acq_fp;
+	struct pci_dev *pdev;
+	struct videobuf_queue *vidq;
+	struct videobuf_buffer *curr_buf;
+	irq_handler_t irq_handler;
+	struct mutex mux;
+	spinlock_t lock;
+	struct dt3155_stats stats;
+	void *regs;
+	unsigned int users;
+	unsigned int dma_running;
+	u8 csr2, config;
+};
+
+#endif /*  __KERNEL__  */
+
+#endif /*  _DT3155_H_  */

==============================================
A patch for drivers/staging/Kconfig

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

======================================================================
--- a/drivers/staging/Kconfig	2010-03-20 18:11:30.000000000 +0200
+++ b/drivers/staging/Kconfig	2010-03-20 18:12:23.000000000 +0200
@@ -137,6 +137,8 @@
 
 source "drivers/staging/dt3155/Kconfig"
 
+source "drivers/staging/dt3155v4l/Kconfig"
+
 source "drivers/staging/crystalhd/Kconfig"
 
 endif # !STAGING_EXCLUDE_BUILD

