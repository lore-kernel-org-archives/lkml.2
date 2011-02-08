Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab1BIANN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:13:13 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:33825 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755971Ab1BIANM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:13:12 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 1/2] misc: add CARMA DATA-FPGA Access Driver
Date: Tue,  8 Feb 2011 15:37:46 -0800
Message-Id: <1297208267-27087-2-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1297208267-27087-1-git-send-email-iws@ovro.caltech.edu>
References: <1297208267-27087-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Tue, 08 Feb 2011 15:37:59 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver allows userspace to access the data processing FPGAs on the
OVRO CARMA board. It has two modes of operation:

1) random access

This allows users to poke any DATA-FPGA registers by using mmap to map
the address region directly into their memory map.

2) correlation dumping

When correlating, the DATA-FPGA's have special requirements for getting
the data out of their memory before the next correlation. This nominally
happens at 64Hz (every 15.625ms). If the data is not dumped before the
next correlation, data is lost.

The data dumping driver handles buffering up to 1 second worth of
correlation data from the FPGAs. This lowers the realtime scheduling
requirements for the userspace process reading the device.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/misc/Kconfig            |    1 +
 drivers/misc/Makefile           |    1 +
 drivers/misc/carma/Kconfig      |    9 +
 drivers/misc/carma/Makefile     |    1 +
 drivers/misc/carma/carma-fpga.c | 1396 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 1408 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/carma/Kconfig
 create mode 100644 drivers/misc/carma/Makefile
 create mode 100644 drivers/misc/carma/carma-fpga.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index cc8e49d..93cf1e6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -457,5 +457,6 @@ source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
 source "drivers/misc/iwmc3200top/Kconfig"
 source "drivers/misc/ti-st/Kconfig"
+source "drivers/misc/carma/Kconfig"
 
 endif # MISC_DEVICES
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 98009cc..2c1610e 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -42,3 +42,4 @@ obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
 obj-$(CONFIG_PCH_PHUB)		+= pch_phub.o
 obj-y				+= ti-st/
 obj-$(CONFIG_AB8500_PWM)	+= ab8500-pwm.o
+obj-y				+= carma/
diff --git a/drivers/misc/carma/Kconfig b/drivers/misc/carma/Kconfig
new file mode 100644
index 0000000..4be183f
--- /dev/null
+++ b/drivers/misc/carma/Kconfig
@@ -0,0 +1,9 @@
+config CARMA_FPGA
+	tristate "CARMA DATA-FPGA Access Driver"
+	depends on FSL_SOC && PPC_83xx && MEDIA_SUPPORT && HAS_DMA && FSL_DMA
+	select VIDEOBUF_DMA_SG
+	default n
+	help
+	  Say Y here to include support for communicating with the data
+	  processing FPGAs on the OVRO CARMA board.
+
diff --git a/drivers/misc/carma/Makefile b/drivers/misc/carma/Makefile
new file mode 100644
index 0000000..0b69fa7
--- /dev/null
+++ b/drivers/misc/carma/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_CARMA_FPGA)		+= carma-fpga.o
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
new file mode 100644
index 0000000..4ea473a
--- /dev/null
+++ b/drivers/misc/carma/carma-fpga.c
@@ -0,0 +1,1396 @@
+/*
+ * CARMA DATA-FPGA Access Driver
+ *
+ * Copyright (c) 2009-2011 Ira W. Snyder <iws@ovro.caltech.edu>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ */
+
+/*
+ * FPGA Memory Dump Format
+ *
+ * FPGA #0 control registers (32 x 32-bit words)
+ * FPGA #1 control registers (32 x 32-bit words)
+ * FPGA #2 control registers (32 x 32-bit words)
+ * FPGA #3 control registers (32 x 32-bit words)
+ * SYSFPGA control registers (32 x 32-bit words)
+ * FPGA #0 correlation array (NUM_CORL0 correlation blocks)
+ * FPGA #1 correlation array (NUM_CORL1 correlation blocks)
+ * FPGA #2 correlation array (NUM_CORL2 correlation blocks)
+ * FPGA #3 correlation array (NUM_CORL3 correlation blocks)
+ *
+ * Each correlation array consists of:
+ *
+ * Correlation Data      (2 x NUM_LAGSn x 32-bit words)
+ * Pipeline Metadata     (2 x NUM_METAn x 32-bit words)
+ * Quantization Counters (2 x NUM_QCNTn x 32-bit words)
+ *
+ * The NUM_CORLn, NUM_LAGSn, NUM_METAn, and NUM_QCNTn values come from
+ * the FPGA configuration registers. They do not change once the FPGA's
+ * have been programmed, they only change on re-programming.
+ */
+
+/*
+ * Basic Description:
+ *
+ * This driver is used to capture correlation spectra off of the four data
+ * processing FPGAs. The FPGAs are often reprogrammed at runtime, therefore
+ * this driver supports dynamic enable/disable of capture while the device
+ * remains open.
+ *
+ * The nominal capture rate is 64Hz (every 15.625ms). To facilitate this fast
+ * capture rate, all buffers are pre-allocated to avoid any potentially long
+ * running memory allocations while capturing.
+ *
+ * There are three lists which are used to keep track of the different states
+ * of data buffers.
+ *
+ * 1) free list
+ * This list holds all empty data buffers which are ready to receive data.
+ *
+ * 2) inflight list
+ * This list holds data buffers which are currently waiting for a DMA operation
+ * to complete.
+ *
+ * 3) used list
+ * This list holds data buffers which have been filled, and are waiting to be
+ * read by userspace.
+ *
+ * All buffers start life on the free list, then move successively to the
+ * inflight list, and then to the used list. After they have been read by
+ * userspace, they are moved back to the free list. The cycle repeats as long
+ * as necessary.
+ *
+ * It should be noted that all buffers are mapped and ready for DMA when they
+ * are on any of the three lists. They are only unmapped when they are in the
+ * process of being read by userspace.
+ */
+
+/*
+ * Notes on the IRQ masking scheme:
+ *
+ * The IRQ masking scheme here is different than most other hardware. The only
+ * way for the DATA-FPGAs to detect if the kernel has taken too long to copy
+ * the data is if the status registers are not cleared before the next
+ * correlation data dump is ready.
+ *
+ * The interrupt line is connected to the status registers, such that when they
+ * are cleared, the interrupt is de-asserted. Therein lies our problem. We need
+ * to schedule a long-running DMA operation and return from the interrupt
+ * handler quickly, but we cannot clear the status registers.
+ *
+ * To handle this, the system controller FPGA has the capability to connect the
+ * interrupt line to a user-controlled GPIO pin. This pin is driven high
+ * (unasserted) and left that way. To mask the interrupt, we change the
+ * interrupt source to the GPIO pin. Tada, we hid the interrupt. :)
+ */
+
+#include <linux/of_platform.h>
+#include <linux/dma-mapping.h>
+#include <linux/miscdevice.h>
+#include <linux/interrupt.h>
+#include <linux/dmaengine.h>
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+#include <media/videobuf-dma-sg.h>
+
+/* system controller registers */
+#define SYS_IRQ_SOURCE_CTL	0x24
+#define SYS_IRQ_OUTPUT_EN	0x28
+#define SYS_IRQ_OUTPUT_DATA	0x2C
+#define SYS_IRQ_INPUT_DATA	0x30
+#define SYS_FPGA_CONFIG_STATUS	0x44
+
+/* GPIO IRQ line assignment */
+#define IRQ_CORL_DONE		0x10
+
+/* FPGA registers */
+#define MMAP_REG_VERSION	0x00
+#define MMAP_REG_CORL_CONF1	0x08
+#define MMAP_REG_CORL_CONF2	0x0C
+#define MMAP_REG_STATUS		0x48
+
+#define SYS_FPGA_BLOCK		0xF0000000
+
+#define DATA_FPGA_START		0x400000
+#define DATA_FPGA_SIZE		0x80000
+
+static const char drv_name[] = "carma-fpga";
+
+#define NUM_FPGA	4
+
+#define MIN_DATA_BUFS	8
+#define MAX_DATA_BUFS	64
+
+struct fpga_info {
+	unsigned int num_lag_ram;
+	unsigned int blk_size;
+};
+
+struct data_buf {
+	struct list_head entry;
+	struct videobuf_dmabuf vb;
+	size_t size;
+};
+
+struct fpga_device {
+	struct miscdevice miscdev;
+	struct device *dev;
+	struct mutex mutex;
+
+	/* FPGA registers and information */
+	struct fpga_info info[NUM_FPGA];
+	void __iomem *regs;
+	int irq;
+
+	/* FPGA Physical Address/Size Information */
+	resource_size_t phys_addr;
+	size_t phys_size;
+
+	/* DMA structures */
+	struct sg_table corl_table;
+	unsigned int corl_nents;
+	struct dma_chan *chan;
+
+	/* Protection for all members below */
+	spinlock_t lock;
+
+	/* Device enable/disable flag */
+	bool enabled;
+
+	/* Correlation data buffers */
+	wait_queue_head_t wait;
+	struct list_head free;
+	struct list_head used;
+	struct list_head inflight;
+
+	/* Information about data buffers */
+	unsigned int num_dropped;
+	unsigned int num_buffers;
+	size_t bufsize;
+};
+
+struct fpga_reader {
+	struct fpga_device *priv;
+	struct data_buf *buf;
+	off_t buf_start;
+};
+
+#define inode_to_dev(inode) container_of(inode->i_cdev, struct fpga_device, cdev)
+
+/*
+ * Data Buffer Allocation Helpers
+ */
+
+static int data_map_buffer(struct device *dev, struct data_buf *buf)
+{
+	return videobuf_dma_map(dev, &buf->vb);
+}
+
+static void data_unmap_buffer(struct device *dev, struct data_buf *buf)
+{
+	videobuf_dma_unmap(dev, &buf->vb);
+}
+
+/**
+ * data_free_buffer() - free a single data buffer and all allocated memory
+ * @buf: the buffer to free
+ *
+ * This will free all of the pages allocated to the given data buffer, and
+ * then free the structure itself
+ */
+static void data_free_buffer(struct data_buf *buf)
+{
+	/* It is ok to free a NULL buffer */
+	if (!buf)
+		return;
+
+	/* free all memory */
+	videobuf_dma_free(&buf->vb);
+	kfree(buf);
+}
+
+/**
+ * data_alloc_buffer() - allocate and fill a data buffer with pages
+ * @bytes: the number of bytes required
+ *
+ * This allocates all space needed for a data buffer. It must be mapped before
+ * use in a DMA transaction using data_map_buffer().
+ *
+ * Returns NULL on failure
+ */
+static struct data_buf *data_alloc_buffer(const size_t bytes)
+{
+	unsigned int nr_pages;
+	struct data_buf *buf;
+	int ret;
+
+	/* calculate the number of pages necessary */
+	nr_pages = DIV_ROUND_UP(bytes, PAGE_SIZE);
+
+	/* allocate the buffer structure */
+	buf = kzalloc(sizeof(*buf), GFP_KERNEL);
+	if (!buf)
+		goto out_return;
+
+	/* initialize internal fields */
+	INIT_LIST_HEAD(&buf->entry);
+	buf->size = bytes;
+
+	/* allocate the videobuf */
+	videobuf_dma_init(&buf->vb);
+	ret = videobuf_dma_init_kernel(&buf->vb, DMA_FROM_DEVICE, nr_pages);
+	if (ret)
+		goto out_free_buf;
+
+	return buf;
+
+out_free_buf:
+	kfree(buf);
+out_return:
+	return NULL;
+}
+
+/**
+ * data_free_buffers() - free all allocated buffers
+ * @priv: the driver's private data structure
+ *
+ * Free all buffers allocated by the driver (except those currently in the
+ * process of being read by userspace).
+ *
+ * LOCKING: must hold dev->mutex
+ * CONTEXT: user
+ */
+static void data_free_buffers(struct fpga_device *priv)
+{
+	struct data_buf *buf, *tmp;
+
+	BUG_ON(!list_empty(&priv->inflight));
+
+	list_for_each_entry_safe(buf, tmp, &priv->free, entry) {
+		list_del_init(&buf->entry);
+		data_unmap_buffer(priv->dev, buf);
+		data_free_buffer(buf);
+	}
+
+	list_for_each_entry_safe(buf, tmp, &priv->used, entry) {
+		list_del_init(&buf->entry);
+		data_unmap_buffer(priv->dev, buf);
+		data_free_buffer(buf);
+	}
+
+	priv->num_buffers = 0;
+	priv->bufsize = 0;
+}
+
+/**
+ * data_alloc_buffers() - allocate 1 seconds worth of data buffers
+ * @priv: the driver's private data structure
+ *
+ * Allocate enough buffers for a whole second worth of data
+ *
+ * This routine will attempt to degrade nicely by succeeding even if a full
+ * second worth of data buffers could not be allocated, as long as a minimum
+ * number were allocated. In this case, it will print a message to the kernel
+ * log.
+ *
+ * The device must not be modifying any lists when this is called.
+ *
+ * CONTEXT: user
+ * LOCKING: must hold dev->mutex
+ *
+ * Returns 0 on success, -ERRNO otherwise
+ */
+static int data_alloc_buffers(struct fpga_device *priv)
+{
+	struct data_buf *buf;
+	int i, ret;
+
+	for (i = 0; i < MAX_DATA_BUFS; i++) {
+
+		/* allocate a buffer */
+		buf = data_alloc_buffer(priv->bufsize);
+		if (!buf)
+			continue;
+
+		/* map it for DMA */
+		ret = data_map_buffer(priv->dev, buf);
+		if (ret) {
+			data_free_buffer(buf);
+			continue;
+		}
+
+		/* add it to the list of free buffers */
+		list_add_tail(&buf->entry, &priv->free);
+		priv->num_buffers++;
+	}
+
+	/* Make sure we allocated the minimum required number of buffers */
+	if (priv->num_buffers < MIN_DATA_BUFS) {
+		dev_err(priv->dev, "Unable to allocate enough data buffers\n");
+		data_free_buffers(priv);
+		return -ENOMEM;
+	}
+
+	/* Warn if we are running in a degraded state, but do not fail */
+	if (priv->num_buffers < MAX_DATA_BUFS) {
+		dev_warn(priv->dev, "Unable to allocate one second worth of "
+				    "buffers, using %d buffers instead\n", i);
+	}
+
+	return 0;
+}
+
+/*
+ * DMA Operations Helpers
+ */
+
+/**
+ * fpga_start_addr() - get the physical address a DATA-FPGA
+ * @priv: the driver's private data structure
+ * @fpga: the DATA-FPGA number (zero based)
+ */
+static dma_addr_t fpga_start_addr(struct fpga_device *priv, unsigned int fpga)
+{
+	return priv->phys_addr + 0x400000 + (0x80000 * fpga);
+}
+
+/**
+ * fpga_block_addr() - get the physical address of a correlation data block
+ * @priv: the driver's private data structure
+ * @fpga: the DATA-FPGA number (zero based)
+ * @blknum: the correlation block number (zero based)
+ */
+static dma_addr_t fpga_block_addr(struct fpga_device *priv, unsigned int fpga,
+				  unsigned int blknum)
+{
+	return fpga_start_addr(priv, fpga) + (0x10000 * (1 + blknum));
+}
+
+#define REG_BLOCK_SIZE	(32 * 4)
+
+/**
+ * data_setup_corl_table() - create the scatterlist for correlation dumps
+ * @priv: the driver's private data structure
+ *
+ * Create the scatterlist for transferring a correlation dump from the
+ * DATA FPGAs. This structure will be reused for each buffer than needs
+ * to be filled with correlation data.
+ *
+ * Returns 0 on success, -ERRNO otherwise
+ */
+static int data_setup_corl_table(struct fpga_device *priv)
+{
+	struct sg_table *table = &priv->corl_table;
+	struct scatterlist *sg;
+	struct fpga_info *info;
+	int i, j, ret;
+
+	/* Calculate the number of entries needed */
+	priv->corl_nents = (1 + NUM_FPGA) * REG_BLOCK_SIZE;
+	for (i = 0; i < NUM_FPGA; i++)
+		priv->corl_nents += priv->info[i].num_lag_ram;
+
+	/* Allocate the scatterlist table */
+	ret = sg_alloc_table(table, priv->corl_nents, GFP_KERNEL);
+	if (ret) {
+		dev_err(priv->dev, "unable to allocate DMA table\n");
+		return ret;
+	}
+
+	/* Add the DATA FPGA registers to the scatterlist */
+	sg = table->sgl;
+	for (i = 0; i < NUM_FPGA; i++) {
+		sg_dma_address(sg) = fpga_start_addr(priv, i);
+		sg_dma_len(sg) = REG_BLOCK_SIZE;
+		sg = sg_next(sg);
+	}
+
+	/* Add the SYS-FPGA registers to the scatterlist */
+	sg_dma_address(sg) = SYS_FPGA_BLOCK;
+	sg_dma_len(sg) = REG_BLOCK_SIZE;
+	sg = sg_next(sg);
+
+	/* Add the FPGA correlation data blocks to the scatterlist */
+	for (i = 0; i < NUM_FPGA; i++) {
+		info = &priv->info[i];
+		for (j = 0; j < info->num_lag_ram; j++) {
+			sg_dma_address(sg) = fpga_block_addr(priv, i, j);
+			sg_dma_len(sg) = info->blk_size;
+			sg = sg_next(sg);
+		}
+	}
+
+	/*
+	 * All physical addresses and lengths are present in the structure
+	 * now. It can be reused for every FPGA DATA interrupt
+	 */
+	return 0;
+}
+
+/*
+ * FPGA Register Access Helpers
+ */
+
+static void fpga_write_reg(struct fpga_device *priv, unsigned int fpga,
+			   unsigned int reg, u32 val)
+{
+	const int fpga_start = DATA_FPGA_START + (fpga * DATA_FPGA_SIZE);
+	iowrite32be(val, priv->regs + fpga_start + reg);
+}
+
+static u32 fpga_read_reg(struct fpga_device *priv, unsigned int fpga,
+			 unsigned int reg)
+{
+	const int fpga_start = DATA_FPGA_START + (fpga * DATA_FPGA_SIZE);
+	return ioread32be(priv->regs + fpga_start + reg);
+}
+
+/**
+ * data_calculate_bufsize() - calculate the data buffer size required
+ * @priv: the driver's private data structure
+ *
+ * Calculate the total buffer size needed to hold a single block
+ * of correlation data
+ *
+ * CONTEXT: user
+ *
+ * Returns 0 on success, -ERRNO otherwise
+ */
+static int data_calculate_bufsize(struct fpga_device *priv)
+{
+	u32 num_corl, num_lags, num_meta, num_qcnt, num_pack;
+	u32 conf1, conf2, version;
+	u32 num_lag_ram, blk_size;
+	int i;
+
+	/* Each buffer starts with the 5 FPGA register areas */
+	priv->bufsize = (1 + NUM_FPGA) * REG_BLOCK_SIZE;
+
+	/* Read and store the configuration data for each FPGA */
+	for (i = 0; i < NUM_FPGA; i++) {
+		version = fpga_read_reg(priv, i, MMAP_REG_VERSION);
+		conf1 = fpga_read_reg(priv, i, MMAP_REG_CORL_CONF1);
+		conf2 = fpga_read_reg(priv, i, MMAP_REG_CORL_CONF2);
+
+		/* minor version 2 and later */
+		if ((version & 0x000000FF) >= 2) {
+			num_corl = (conf1 & 0x000000F0) >> 4;
+			num_pack = (conf1 & 0x00000F00) >> 8;
+			num_lags = (conf1 & 0x00FFF000) >> 12;
+			num_meta = (conf1 & 0x7F000000) >> 24;
+			num_qcnt = (conf2 & 0x00000FFF) >> 0;
+		} else {
+			num_corl = (conf1 & 0x000000F0) >> 4;
+			num_pack = 1; /* implied */
+			num_lags = (conf1 & 0x000FFF00) >> 8;
+			num_meta = (conf1 & 0x7FF00000) >> 20;
+			num_qcnt = (conf2 & 0x00000FFF) >> 0;
+		}
+
+		num_lag_ram = (num_corl + num_pack - 1) / num_pack;
+		blk_size = ((num_pack * num_lags) + num_meta + num_qcnt) * 8;
+
+		priv->info[i].num_lag_ram = num_lag_ram;
+		priv->info[i].blk_size = blk_size;
+		priv->bufsize += num_lag_ram * blk_size;
+
+		dev_dbg(priv->dev, "FPGA %d NUM_CORL: %d\n", i, num_corl);
+		dev_dbg(priv->dev, "FPGA %d NUM_PACK: %d\n", i, num_pack);
+		dev_dbg(priv->dev, "FPGA %d NUM_LAGS: %d\n", i, num_lags);
+		dev_dbg(priv->dev, "FPGA %d NUM_META: %d\n", i, num_meta);
+		dev_dbg(priv->dev, "FPGA %d NUM_QCNT: %d\n", i, num_qcnt);
+		dev_dbg(priv->dev, "FPGA %d BLK_SIZE: %d\n", i, blk_size);
+	}
+
+	dev_dbg(priv->dev, "TOTAL BUFFER SIZE: %zu bytes\n", priv->bufsize);
+	return 0;
+}
+
+/*
+ * Interrupt Handling
+ */
+
+/**
+ * data_disable_interrupts() - stop the device from generating interrupts
+ * @priv: the driver's private data structure
+ *
+ * Hide interrupts by switching to GPIO interrupt source
+ *
+ * LOCKING: must hold dev->lock
+ */
+static void data_disable_interrupts(struct fpga_device *priv)
+{
+	/* hide the interrupt by switching the IRQ driver to GPIO */
+	iowrite32be(0x2F, priv->regs + SYS_IRQ_SOURCE_CTL);
+}
+
+/**
+ * data_enable_interrupts() - allow the device to generate interrupts
+ * @priv: the driver's private data structure
+ *
+ * Unhide interrupts by switching to the FPGA interrupt source. At the
+ * same time, clear the DATA-FPGA status registers.
+ *
+ * LOCKING: must hold dev->lock
+ */
+static void data_enable_interrupts(struct fpga_device *priv)
+{
+	/* clear the actual FPGA corl_done interrupt */
+	fpga_write_reg(priv, 0, MMAP_REG_STATUS, 0x0);
+	fpga_write_reg(priv, 1, MMAP_REG_STATUS, 0x0);
+	fpga_write_reg(priv, 2, MMAP_REG_STATUS, 0x0);
+	fpga_write_reg(priv, 3, MMAP_REG_STATUS, 0x0);
+
+	/* flush the writes */
+	fpga_read_reg(priv, 0, MMAP_REG_STATUS);
+
+	/* switch back to the external interrupt source */
+	iowrite32be(0x3F, priv->regs + SYS_IRQ_SOURCE_CTL);
+}
+
+/**
+ * data_dma_cb() - DMAEngine callback for DMA completion
+ * @data: the driver's private data structure
+ *
+ * Complete a DMA transfer from the DATA-FPGA's
+ *
+ * This is called via the DMA callback mechanism, and will handle moving the
+ * completed DMA transaction to the used list, and then wake any processes
+ * waiting for new data
+ *
+ * CONTEXT: any, softirq expected
+ */
+static void data_dma_cb(void *data)
+{
+	struct fpga_device *priv = data;
+	struct data_buf *buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* clear the FPGA status and re-enable interrupts */
+	data_enable_interrupts(priv);
+
+	/* If the inflight list is empty, we've got a bug */
+	BUG_ON(list_empty(&priv->inflight));
+
+	/* Grab the first buffer from the inflight list */
+	buf = list_first_entry(&priv->inflight, struct data_buf, entry);
+	list_del_init(&buf->entry);
+
+	/* Add it to the used list */
+	list_add_tail(&buf->entry, &priv->used);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* We've changed both the inflight and used lists, so we need
+	 * to wake up any processes that are blocking for those events */
+	wake_up(&priv->wait);
+}
+
+/**
+ * data_submit_dma() - prepare and submit the required DMA to fill a buffer
+ * @priv: the driver's private data structure
+ * @buf: the data buffer
+ *
+ * Prepare and submit the necessary DMA transactions to fill a correlation
+ * data buffer.
+ *
+ * LOCKING: must hold dev->lock
+ * CONTEXT: hardirq only
+ *
+ * Returns 0 on success, -ERRNO otherwise
+ */
+static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
+{
+	struct scatterlist *dst_sg, *src_sg;
+	unsigned int dst_nents, src_nents;
+	struct dma_chan *chan = priv->chan;
+	struct dma_async_tx_descriptor *tx;
+	dma_cookie_t cookie;
+	dma_addr_t dst, src;
+
+	dst_sg = buf->vb.sglist;
+	dst_nents = buf->vb.sglen;
+
+	src_sg = priv->corl_table.sgl;
+	src_nents = priv->corl_nents;
+
+	/*
+	 * All buffers passed to this function should be ready and mapped
+	 * for DMA already. Therefore, we don't need to do anything except
+	 * submit it to the Freescale DMA Engine for processing
+	 */
+
+	/* setup the scatterlist to scatterlist transfer */
+	tx = chan->device->device_prep_dma_sg(chan,
+					      dst_sg, dst_nents,
+					      src_sg, src_nents,
+					      0);
+	if (!tx) {
+		dev_err(priv->dev, "unable to prep scatterlist DMA\n");
+		return -ENOMEM;
+	}
+
+	/* submit the transaction to the DMA controller */
+	cookie = tx->tx_submit(tx);
+	if (dma_submit_error(cookie)) {
+		dev_err(priv->dev, "unable to submit scatterlist DMA\n");
+		return -ENOMEM;
+	}
+
+	/* Prepare the re-read of the SYS-FPGA block */
+	dst = sg_dma_address(dst_sg) + (NUM_FPGA * REG_BLOCK_SIZE);
+	src = SYS_FPGA_BLOCK;
+	tx = chan->device->device_prep_dma_memcpy(chan, dst, src,
+						  REG_BLOCK_SIZE,
+						  DMA_PREP_INTERRUPT);
+	if (!tx) {
+		dev_err(priv->dev, "unable to prep SYS-FPGA DMA\n");
+		return -ENOMEM;
+	}
+
+	/* Setup the callback */
+	tx->callback = data_dma_cb;
+	tx->callback_param = priv;
+
+	/* submit the transaction to the DMA controller */
+	cookie = tx->tx_submit(tx);
+	if (dma_submit_error(cookie)) {
+		dev_err(priv->dev, "unable to submit SYS-FPGA DMA\n");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+#define CORL_DONE	0x1
+#define CORL_ERR	0x2
+
+static irqreturn_t data_irq(int irq, void *dev_id)
+{
+	struct fpga_device *priv = dev_id;
+	struct data_buf *buf;
+	u32 status;
+	int i;
+
+	/* detect spurious interrupts via FPGA status */
+	for (i = 0; i < 4; i++) {
+		status = fpga_read_reg(priv, i, MMAP_REG_STATUS);
+		if (!(status & (CORL_DONE | CORL_ERR))) {
+			dev_err(priv->dev, "spurious irq detected (FPGA)\n");
+			return IRQ_NONE;
+		}
+	}
+
+	/* detect spurious interrupts via raw IRQ pin readback */
+	status = ioread32be(priv->regs + SYS_IRQ_INPUT_DATA);
+	if (status & IRQ_CORL_DONE) {
+		dev_err(priv->dev, "spurious irq detected (IRQ)\n");
+		return IRQ_NONE;
+	}
+
+	spin_lock(&priv->lock);
+
+	/* hide the interrupt by switching the IRQ driver to GPIO */
+	data_disable_interrupts(priv);
+
+	/* Check that we actually have a free buffer */
+	if (list_empty(&priv->free)) {
+		priv->num_dropped++;
+		data_enable_interrupts(priv);
+		goto out_unlock;
+	}
+
+	buf = list_first_entry(&priv->free, struct data_buf, entry);
+	list_del_init(&buf->entry);
+
+	/* Check the buffer size */
+	BUG_ON(buf->size != priv->bufsize);
+
+	/* Submit a DMA transfer to get the correlation data */
+	if (data_submit_dma(priv, buf)) {
+		dev_err(priv->dev, "Unable to setup DMA transfer\n");
+		list_add_tail(&buf->entry, &priv->free);
+		data_enable_interrupts(priv);
+		goto out_unlock;
+	}
+
+	/* DMA setup succeeded, GO!!! */
+	list_add_tail(&buf->entry, &priv->inflight);
+	dma_async_memcpy_issue_pending(priv->chan);
+
+out_unlock:
+	spin_unlock(&priv->lock);
+	return IRQ_HANDLED;
+}
+
+/*
+ * Realtime Device Enable Helpers
+ */
+
+/**
+ * data_device_enable() - enable the device for buffered dumping
+ * @priv: the driver's private data structure
+ *
+ * Enable the device for buffered dumping. Allocates buffers and hooks up
+ * the interrupt handler. When this finishes, data will come pouring in.
+ *
+ * LOCKING: must hold dev->mutex
+ * CONTEXT: user context only
+ *
+ * Returns 0 on success, -ERRNO otherwise
+ */
+static int data_device_enable(struct fpga_device *priv)
+{
+	u32 val;
+	int ret;
+
+	/* multiple enables are safe: they do nothing */
+	if (priv->enabled)
+		return 0;
+
+	/* check that the FPGAs are programmed */
+	val = ioread32be(priv->regs + SYS_FPGA_CONFIG_STATUS);
+	if (!(val & (1 << 18))) {
+		dev_err(priv->dev, "DATA-FPGAs are not enabled\n");
+		return -ENODATA;
+	}
+
+	/* read the FPGAs to calculate the buffer size */
+	ret = data_calculate_bufsize(priv);
+	if (ret) {
+		dev_err(priv->dev, "unable to calculate buffer size\n");
+		goto out_error;
+	}
+
+	/* allocate the correlation data buffers */
+	ret = data_alloc_buffers(priv);
+	if (ret) {
+		dev_err(priv->dev, "unable to allocate buffers\n");
+		goto out_error;
+	}
+
+	/* setup the source scatterlist for dumping correlation data */
+	ret = data_setup_corl_table(priv);
+	if (ret) {
+		dev_err(priv->dev, "unable to setup correlation DMA table\n");
+		goto out_error;
+	}
+
+	/* switch to the external FPGA IRQ line */
+	data_enable_interrupts(priv);
+
+	/* hookup the irq handler */
+	ret = request_irq(priv->irq, data_irq, IRQF_SHARED, drv_name, priv);
+	if (ret) {
+		dev_err(priv->dev, "unable to request IRQ handler\n");
+		goto out_error;
+	}
+
+	/* success, we're enabled */
+	priv->enabled = true;
+	return 0;
+
+out_error:
+	sg_free_table(&priv->corl_table);
+	priv->corl_nents = 0;
+
+	data_free_buffers(priv);
+	return ret;
+}
+
+/**
+ * data_device_disable() - disable the device for buffered dumping
+ * @priv: the driver's private data structure
+ *
+ * Disable the device for buffered dumping. Stops new DMA transactions from
+ * being generated, waits for all outstanding DMA to complete, and then frees
+ * all buffers.
+ *
+ * LOCKING: must hold dev->mutex
+ * CONTEXT: user only
+ *
+ * Returns 0 on success, -ERRNO otherwise
+ */
+static int data_device_disable(struct fpga_device *priv)
+{
+	struct list_head *list;
+	int ret;
+
+	/* allow multiple disable */
+	if (!priv->enabled)
+		return 0;
+
+	/* switch to the internal GPIO IRQ line */
+	data_disable_interrupts(priv);
+
+	/* unhook the irq handler */
+	free_irq(priv->irq, priv);
+
+	/*
+	 * wait for all outstanding DMA to complete
+	 *
+	 * Device interrupts are disabled, so no more buffers can be added to
+	 * the inflight list. Therefore we do not need any locking.
+	 */
+	list = &priv->inflight;
+	while (!list_empty(list)) {
+		ret = wait_event_interruptible(priv->wait, list_empty(list));
+		if (ret)
+			return ret;
+	}
+
+	/* free the correlation table */
+	sg_free_table(&priv->corl_table);
+	priv->corl_nents = 0;
+
+	/* free all of the buffers */
+	data_free_buffers(priv);
+	priv->enabled = false;
+	return 0;
+}
+
+/*
+ * SYSFS Attributes
+ */
+
+/*
+ * Count the number of entries in the given list
+ */
+static unsigned int list_num_entries(struct list_head *list)
+{
+	struct list_head *entry;
+	unsigned int ret = 0;
+
+	list_for_each(entry, list)
+		ret++;
+
+	return ret;
+}
+
+static ssize_t data_num_buffers_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%u\n", priv->num_buffers);
+}
+
+static ssize_t data_bufsize_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%zu\n", priv->bufsize);
+}
+
+static ssize_t data_inflight_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	unsigned int num = list_num_entries(&priv->inflight);
+	return snprintf(buf, PAGE_SIZE, "%u\n", num);
+}
+
+static ssize_t data_free_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	unsigned int num = list_num_entries(&priv->free);
+	return snprintf(buf, PAGE_SIZE, "%u\n", num);
+}
+
+static ssize_t data_used_show(struct device *dev,
+			      struct device_attribute *attr, char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	unsigned int num = list_num_entries(&priv->used);
+	return snprintf(buf, PAGE_SIZE, "%u\n", num);
+}
+
+static ssize_t data_num_dropped_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	return snprintf(buf, PAGE_SIZE, "%u\n", priv->num_dropped);
+}
+
+static ssize_t data_en_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	ssize_t count;
+
+	count = mutex_lock_interruptible(&priv->mutex);
+	if (count)
+		return count;
+
+	count = snprintf(buf, PAGE_SIZE, "%u\n", priv->enabled);
+	mutex_unlock(&priv->mutex);
+	return count;
+}
+
+static ssize_t data_en_set(struct device *dev, struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct fpga_device *priv = dev_get_drvdata(dev);
+	unsigned long enable;
+	int ret;
+
+	ret = strict_strtoul(buf, 0, &enable);
+	if (ret) {
+		dev_err(priv->dev, "unable to parse enable input\n");
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&priv->mutex);
+	if (ret)
+		return ret;
+
+	if (enable)
+		ret = data_device_enable(priv);
+	else
+		ret = data_device_disable(priv);
+
+	if (ret) {
+		dev_err(priv->dev, "device %s failed\n",
+			enable ? "enable" : "disable");
+		count = ret;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&priv->mutex);
+	return count;
+}
+
+static DEVICE_ATTR(num_buffers, S_IRUGO, data_num_buffers_show, NULL);
+static DEVICE_ATTR(buffer_size, S_IRUGO, data_bufsize_show, NULL);
+static DEVICE_ATTR(num_inflight, S_IRUGO, data_inflight_show, NULL);
+static DEVICE_ATTR(num_free, S_IRUGO, data_free_show, NULL);
+static DEVICE_ATTR(num_used, S_IRUGO, data_used_show, NULL);
+static DEVICE_ATTR(num_dropped, S_IRUGO, data_num_dropped_show, NULL);
+static DEVICE_ATTR(enable, S_IWUSR | S_IRUGO, data_en_show, data_en_set);
+
+static struct attribute *data_sysfs_attrs[] = {
+	&dev_attr_num_buffers.attr,
+	&dev_attr_buffer_size.attr,
+	&dev_attr_num_inflight.attr,
+	&dev_attr_num_free.attr,
+	&dev_attr_num_used.attr,
+	&dev_attr_num_dropped.attr,
+	&dev_attr_enable.attr,
+	NULL,
+};
+
+static const struct attribute_group rt_sysfs_attr_group = {
+	.attrs = data_sysfs_attrs,
+};
+
+/*
+ * FPGA Realtime Data Character Device
+ */
+
+static int data_open(struct inode *inode, struct file *filp)
+{
+	/*
+	 * The miscdevice layer puts our struct miscdevice into the
+	 * filp->private_data field. We use this to find our private
+	 * data and then overwrite it with our own private structure.
+	 */
+	struct fpga_device *priv = container_of(filp->private_data,
+						struct fpga_device, miscdev);
+	struct fpga_reader *reader;
+	int ret;
+
+	/* allocate private data */
+	reader = kzalloc(sizeof(*reader), GFP_KERNEL);
+	if (!reader)
+		return -ENOMEM;
+
+	reader->priv = priv;
+	reader->buf = NULL;
+
+	filp->private_data = reader;
+	ret = nonseekable_open(inode, filp);
+	if (ret) {
+		dev_err(priv->dev, "nonseekable-open failed\n");
+		kfree(reader);
+		return ret;
+	}
+
+	return 0;
+}
+
+static int data_release(struct inode *inode, struct file *filp)
+{
+	struct fpga_reader *reader = filp->private_data;
+
+	/* free the per-reader structure */
+	data_free_buffer(reader->buf);
+	kfree(reader);
+	filp->private_data = NULL;
+	return 0;
+}
+
+static ssize_t data_read(struct file *filp, char __user *ubuf, size_t count,
+			 loff_t *f_pos)
+{
+	struct fpga_reader *reader = filp->private_data;
+	struct fpga_device *priv = reader->priv;
+	struct list_head *used = &priv->used;
+	struct data_buf *dbuf;
+	size_t avail;
+	void *data;
+	int ret;
+
+	/* check if we already have a partial buffer */
+	if (reader->buf) {
+		dbuf = reader->buf;
+		goto have_buffer;
+	}
+
+	spin_lock_irq(&priv->lock);
+
+	/* Block until there is at least one buffer on the used list */
+	while (list_empty(used)) {
+		spin_unlock_irq(&priv->lock);
+
+		if (filp->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		ret = wait_event_interruptible(priv->wait, !list_empty(used));
+		if (ret)
+			return ret;
+
+		spin_lock_irq(&priv->lock);
+	}
+
+	/* Grab the first buffer off of the used list */
+	dbuf = list_first_entry(used, struct data_buf, entry);
+	list_del_init(&dbuf->entry);
+
+	spin_unlock_irq(&priv->lock);
+
+	/* Buffers are always mapped: unmap it */
+	data_unmap_buffer(priv->dev, dbuf);
+
+	/* save the buffer for later */
+	reader->buf = dbuf;
+	reader->buf_start = 0;
+
+	/* we removed a buffer from the used list: wake any waiters */
+	wake_up(&priv->wait);
+
+have_buffer:
+	/* Get the number of bytes available */
+	avail = dbuf->size - reader->buf_start;
+	data = dbuf->vb.vaddr + reader->buf_start;
+
+	/* Get the number of bytes we can transfer */
+	count = min(count, avail);
+
+	/* Copy the data to the userspace buffer */
+	if (copy_to_user(ubuf, data, count))
+		return -EFAULT;
+
+	/* Update the amount of available space */
+	avail -= count;
+
+	/* Lock against concurrent enable/disable */
+	ret = mutex_lock_interruptible(&priv->mutex);
+	if (ret)
+		return ret;
+
+	/* Still some space available: save the buffer for later */
+	if (avail != 0) {
+		reader->buf_start += count;
+		reader->buf = dbuf;
+		goto out_unlock;
+	}
+
+	/*
+	 * No space is available in this buffer
+	 *
+	 * This is a complicated decision:
+	 * - if the device is not enabled: free the buffer
+	 * - if the buffer is too small: free the buffer
+	 */
+	if (!priv->enabled || dbuf->size != priv->bufsize) {
+		data_free_buffer(dbuf);
+		reader->buf = NULL;
+		goto out_unlock;
+	}
+
+	/*
+	 * The buffer is safe to recycle: remap it and finish
+	 *
+	 * If this fails, we pretend that the read never happened, and return
+	 * -EFAULT to userspace. They'll retry the read again.
+	 */
+	ret = data_map_buffer(priv->dev, dbuf);
+	if (ret) {
+		dev_err(priv->dev, "unable to remap buffer for DMA\n");
+		count = -EFAULT;
+		goto out_unlock;
+	}
+
+	/* Add the buffer back to the free list */
+	reader->buf = NULL;
+	spin_lock_irq(&priv->lock);
+	list_add_tail(&dbuf->entry, &priv->free);
+	spin_unlock_irq(&priv->lock);
+
+out_unlock:
+	mutex_unlock(&priv->mutex);
+	return count;
+}
+
+static unsigned int data_poll(struct file *filp, struct poll_table_struct *tbl)
+{
+	struct fpga_reader *reader = filp->private_data;
+	struct fpga_device *priv = reader->priv;
+	unsigned int mask = 0;
+
+	poll_wait(filp, &priv->wait, tbl);
+
+	spin_lock_irq(&priv->lock);
+
+	if (!list_empty(&priv->used))
+		mask |= POLLIN | POLLRDNORM;
+
+	spin_unlock_irq(&priv->lock);
+	return mask;
+}
+
+static int data_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct fpga_reader *reader = filp->private_data;
+	struct fpga_device *priv = reader->priv;
+	unsigned long offset, vsize, psize, addr;
+
+	/* VMA properties */
+	offset = vma->vm_pgoff << PAGE_SHIFT;
+	vsize = vma->vm_end - vma->vm_start;
+	psize = priv->phys_size - offset;
+	addr = (priv->phys_addr + offset) >> PAGE_SHIFT;
+
+	/* Check against the FPGA region's physical memory size */
+	if (vsize > psize) {
+		dev_err(priv->dev, "requested mmap mapping too large\n");
+		return -EINVAL;
+	}
+
+	/* IO memory (stop cacheing) */
+	vma->vm_flags |= VM_IO | VM_RESERVED;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	return io_remap_pfn_range(vma, vma->vm_start, addr, vsize,
+				  vma->vm_page_prot);
+}
+
+static const struct file_operations data_fops = {
+	.owner		= THIS_MODULE,
+	.open		= data_open,
+	.release	= data_release,
+	.read		= data_read,
+	.poll		= data_poll,
+	.mmap		= data_mmap,
+	.llseek		= no_llseek,
+};
+
+/*
+ * OpenFirmware Device Subsystem
+ */
+
+static bool dma_filter(struct dma_chan *chan, void *data)
+{
+	/*
+	 * DMA Channel #0 is used for the FPGA Programmer, so ignore it
+	 *
+	 * This probably won't survive an unload/load cycle of the Freescale
+	 * DMAEngine driver, but that won't be a problem
+	 */
+	if (chan->chan_id == 0 && chan->device->dev_id == 0)
+		return false;
+
+	return true;
+}
+
+static int data_of_probe(struct platform_device *op,
+			 const struct of_device_id *match)
+{
+	struct device_node *of_node = op->dev.of_node;
+	struct device *this_device;
+	struct fpga_device *priv;
+	struct resource res;
+	dma_cap_mask_t mask;
+	int ret;
+
+	/* Allocate private data */
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&op->dev, "Unable to allocate device private data\n");
+		ret = -ENOMEM;
+		goto out_return;
+	}
+
+	dev_set_drvdata(&op->dev, priv);
+	priv->dev = &op->dev;
+
+	/* Setup the misc device */
+	priv->miscdev.minor = MISC_DYNAMIC_MINOR;
+	priv->miscdev.name = drv_name;
+	priv->miscdev.fops = &data_fops;
+
+	/* Get the physical address of the FPGA registers */
+	ret = of_address_to_resource(of_node, 0, &res);
+	if (ret) {
+		dev_err(&op->dev, "Unable to find FPGA physical address\n");
+		ret = -ENODEV;
+		goto out_free_priv;
+	}
+
+	priv->phys_addr = res.start;
+	priv->phys_size = resource_size(&res);
+
+	/* ioremap the registers for use */
+	priv->regs = of_iomap(of_node, 0);
+	if (!priv->regs) {
+		dev_err(&op->dev, "Unable to ioremap registers\n");
+		ret = -ENOMEM;
+		goto out_free_priv;
+	}
+
+	dma_cap_zero(mask);
+	dma_cap_set(DMA_MEMCPY, mask);
+	dma_cap_set(DMA_INTERRUPT, mask);
+	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SG, mask);
+
+	/* Request a DMA channel */
+	priv->chan = dma_request_channel(mask, dma_filter, NULL);
+	if (!priv->chan) {
+		dev_err(&op->dev, "Unable to request DMA channel\n");
+		ret = -ENODEV;
+		goto out_unmap_regs;
+	}
+
+	/* Find the correct IRQ number */
+	priv->irq = irq_of_parse_and_map(of_node, 0);
+	if (priv->irq == NO_IRQ) {
+		dev_err(&op->dev, "Unable to find IRQ line\n");
+		ret = -ENODEV;
+		goto out_release_dma;
+	}
+
+	dev_set_drvdata(priv->dev, priv);
+	mutex_init(&priv->mutex);
+	spin_lock_init(&priv->lock);
+	INIT_LIST_HEAD(&priv->free);
+	INIT_LIST_HEAD(&priv->used);
+	INIT_LIST_HEAD(&priv->inflight);
+	init_waitqueue_head(&priv->wait);
+
+	/* Drive the GPIO for FPGA IRQ high (no interrupt) */
+	iowrite32be(IRQ_CORL_DONE, priv->regs + SYS_IRQ_OUTPUT_DATA);
+
+	/* Register the miscdevice */
+	ret = misc_register(&priv->miscdev);
+	if (ret) {
+		dev_err(&op->dev, "Unable to register miscdevice\n");
+		goto out_irq_dispose_mapping;
+	}
+
+	/* Create the sysfs files */
+	this_device = priv->miscdev.this_device;
+	dev_set_drvdata(this_device, priv);
+	ret = sysfs_create_group(&this_device->kobj, &rt_sysfs_attr_group);
+	if (ret) {
+		dev_err(&op->dev, "Unable to create sysfs files\n");
+		goto out_misc_deregister;
+	}
+
+	dev_info(&op->dev, "CARMA FPGA Realtime Data Driver Loaded\n");
+	return 0;
+
+out_misc_deregister:
+	misc_deregister(&priv->miscdev);
+out_irq_dispose_mapping:
+	irq_dispose_mapping(priv->irq);
+out_release_dma:
+	dma_release_channel(priv->chan);
+out_unmap_regs:
+	iounmap(priv->regs);
+out_free_priv:
+	mutex_destroy(&priv->mutex);
+	kfree(priv);
+out_return:
+	return ret;
+}
+
+static int data_of_remove(struct platform_device *op)
+{
+	struct fpga_device *priv = dev_get_drvdata(&op->dev);
+	struct device *this_device = priv->miscdev.this_device;
+
+	/* remove all sysfs files, now the device cannot be re-enabled */
+	sysfs_remove_group(&this_device->kobj, &rt_sysfs_attr_group);
+
+	/* disable the device from generating data */
+	data_device_disable(priv);
+
+	misc_deregister(&priv->miscdev);
+	irq_dispose_mapping(priv->irq);
+	dma_release_channel(priv->chan);
+	iounmap(priv->regs);
+	mutex_destroy(&priv->mutex);
+	kfree(priv);
+
+	return 0;
+}
+
+static struct of_device_id data_of_match[] = {
+	{ .compatible = "carma,carma-fpga", },
+	{},
+};
+
+static struct of_platform_driver data_of_driver = {
+	.probe		= data_of_probe,
+	.remove		= data_of_remove,
+	.driver		= {
+		.name		= drv_name,
+		.of_match_table	= data_of_match,
+		.owner		= THIS_MODULE,
+	},
+};
+
+/*
+ * Module Init / Exit
+ */
+
+static int __init data_init(void)
+{
+	return of_register_platform_driver(&data_of_driver);
+}
+
+static void __exit data_exit(void)
+{
+	of_unregister_platform_driver(&data_of_driver);
+}
+
+MODULE_AUTHOR("Ira W. Snyder <iws@ovro.caltech.edu>");
+MODULE_DESCRIPTION("CARMA DATA-FPGA Access Driver");
+MODULE_LICENSE("GPL");
+
+module_init(data_init);
+module_exit(data_exit);
-- 
1.7.3.4

