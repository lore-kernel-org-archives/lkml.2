Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700Ab1CAAsR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:48:17 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62205 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753541Ab1CAAsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:48:16 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77221864"
From: Murali Nalajala <mnalajal@codeaurora.org>
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Murali Nalajala <mnalajal@codeaurora.org>,
        Dima Zavin <dima@android.com>, Brian Swetland <swetland@google.com>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: [PATCH 2/2] mtd: msm_nand: Add initial msm nand driver support.
Date: Tue,  1 Mar 2011 06:17:30 +0530
Message-Id: <1298940450-27365-2-git-send-email-mnalajal@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
References: <1298940450-27365-1-git-send-email-mnalajal@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add initial msm nand driver support for Qualcomm MSM platforms.
This driver is capable of handling both 2k and 4k page support
nand devices.

This driver was originally developed by Arve Hjønnevåg at google.
Its source is available at
http://android.git.kernel.org/?p=kernel/msm.git under
android-msm-2.6.35 branch.

CC: Dima Zavin <dima@android.com>
CC: Brian Swetland <swetland@google.com>
CC: Arve Hjønnevåg <arve@android.com>
Signed-off-by: Murali Nalajala <mnalajal@codeaurora.org>
---
 drivers/mtd/devices/Kconfig    |   11 +
 drivers/mtd/devices/Makefile   |    1 +
 drivers/mtd/devices/msm_nand.c | 1597 ++++++++++++++++++++++++++++++++++++++++
 drivers/mtd/devices/msm_nand.h |   77 ++
 4 files changed, 1686 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mtd/devices/msm_nand.c
 create mode 100644 drivers/mtd/devices/msm_nand.h

diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
index 35081ce..c2900c5 100644
--- a/drivers/mtd/devices/Kconfig
+++ b/drivers/mtd/devices/Kconfig
@@ -49,6 +49,17 @@ config MTD_MS02NV
 	  say M here and read <file:Documentation/kbuild/modules.txt>.
 	  The module will be called ms02-nv.
 
+config MTD_MSM_NAND
+	tristate "MSM on-chip NAND Flash Controller driver"
+	depends on MTD && ARCH_MSM
+	select MTD_NAND_IDS
+	help
+	  This enables the on-chip NAND flash controller driver on Qualcomm's
+	  MSM and QSD platforms.
+
+	  MSM NAND controller is capable of interfacing to all leading nand
+	  flash vendor devices ie Samsung, Micron, Hynix etc.
+
 config MTD_DATAFLASH
 	tristate "Support for AT45xxx DataFlash"
 	depends on SPI_MASTER && EXPERIMENTAL
diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
index f3226b1..fe959e8 100644
--- a/drivers/mtd/devices/Makefile
+++ b/drivers/mtd/devices/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_MTD_SLRAM)		+= slram.o
 obj-$(CONFIG_MTD_PHRAM)		+= phram.o
 obj-$(CONFIG_MTD_PMC551)	+= pmc551.o
 obj-$(CONFIG_MTD_MS02NV)	+= ms02-nv.o
+obj-$(CONFIG_MTD_MSM_NAND)	+= msm_nand.o
 obj-$(CONFIG_MTD_MTDRAM)	+= mtdram.o
 obj-$(CONFIG_MTD_LART)		+= lart.o
 obj-$(CONFIG_MTD_BLOCK2MTD)	+= block2mtd.o
diff --git a/drivers/mtd/devices/msm_nand.c b/drivers/mtd/devices/msm_nand.c
new file mode 100644
index 0000000..d782d6a
--- /dev/null
+++ b/drivers/mtd/devices/msm_nand.c
@@ -0,0 +1,1597 @@
+/*
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#define pr_fmt(fmt) "%s:" fmt, __func__
+
+#include <linux/kernel.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/nand.h>
+#include <linux/mtd/partitions.h>
+#include <linux/platform_device.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/dma-mapping.h>
+#include <asm/mach/flash.h>
+#include <mach/dma.h>
+
+#include "msm_nand.h"
+
+unsigned long msm_nand_phys;
+
+#define MSM_NAND_DMA_BUFFER_SIZE SZ_4K
+#define SRC_CRCI_NAND_CMD  CMD_SRC_CRCI(DMOV_NAND_CRCI_CMD)
+#define DST_CRCI_NAND_CMD  CMD_DST_CRCI(DMOV_NAND_CRCI_CMD)
+#define SRC_CRCI_NAND_DATA CMD_SRC_CRCI(DMOV_NAND_CRCI_DATA)
+#define DST_CRCI_NAND_DATA CMD_DST_CRCI(DMOV_NAND_CRCI_DATA)
+
+#define MSM_NAND_DMA_BUFFER_SLOTS \
+	(MSM_NAND_DMA_BUFFER_SIZE / (sizeof(((atomic_t *)0)->counter) * 8))
+
+#define msm_virt_to_dma(chip, vaddr) \
+		 ((chip)->dma_addr + \
+		 ((uint8_t *)(vaddr) - (chip)->dma_buffer))
+
+/**
+ * struct msm_nand_chip - Describe the msm nand chip and dma properties
+ * @dev:                Holds the device structure pointer
+ * @wait_queue:         Wait queue for handling DMA buffer requests
+ * @dma_buffer_busy:    Check DMA buffer status
+ * @dma_channel:        DMA channel number
+ * @dma_buffer:         Allocated dma buffer address
+ * @dma_addr:           Bus-specific DMA address
+ * @cfg0:               Nand controller configuration0 register value
+ * @cfg1:               Nand controller configuration1 register value
+ * @page_shift:         Page shift value to calculate page address
+ * @last_sector:        Last sector number
+ * @last_sectorsz:      Last sector size
+ * @ecc_buf_cfg:        Stores ECC buffer configuration
+ *
+ * This structure is used to store the DMA and nand controller information
+ */
+struct msm_nand_chip {
+	struct device *dev;
+	wait_queue_head_t wait_queue;
+	atomic_t dma_buffer_busy;
+	unsigned dma_channel;
+	uint8_t *dma_buffer;
+	dma_addr_t dma_addr;
+	unsigned cfg0, cfg1;
+	unsigned page_shift;
+	unsigned last_sector;
+	unsigned last_sectorsz;
+	uint32_t ecc_buf_cfg;
+};
+
+/**
+ * struct msm_nand_info - Stores the mtd and nand device information
+ * @mtd:         MTD device structure
+ * @parts:       Pointer to the MTD partitions
+ * @msm_nand:    Holds the nand device information
+ *
+ * It stores the mtd properties associted to the nand device and also
+ * mtd partition details.
+ */
+struct msm_nand_info {
+	struct mtd_info         mtd;
+	struct mtd_partition    *parts;
+	struct msm_nand_chip    msm_nand;
+};
+
+/**
+ * msm_nand_oob_64 - oob info for large (2KB) page
+ */
+static struct nand_ecclayout msm_nand_oob_64 = {
+	.oobavail	= 16,
+	.oobfree	= {
+		{30, 16},
+	}
+};
+
+/*
+ * msm_nand_oob_128 - oob info for 4KB page
+ */
+static struct nand_ecclayout msm_nand_oob_128 = {
+	.oobavail       = 32,
+	.oobfree        = {
+		{70, 32},
+	}
+};
+
+static void *msm_nand_get_dma_buffer(struct msm_nand_chip *chip, size_t size)
+{
+	unsigned int bitmask, free_bitmask, old_bitmask;
+	unsigned int need_mask, current_need_mask;
+	int free_index;
+
+	need_mask = (1UL << DIV_ROUND_UP(size, MSM_NAND_DMA_BUFFER_SLOTS)) - 1;
+	bitmask = atomic_read(&chip->dma_buffer_busy);
+	free_bitmask = ~bitmask;
+	do {
+		free_index = __ffs(free_bitmask);
+		current_need_mask = need_mask << free_index;
+		if ((bitmask & current_need_mask) == 0) {
+			old_bitmask =
+				atomic_cmpxchg(&chip->dma_buffer_busy,
+					       bitmask,
+					       bitmask | current_need_mask);
+			if (old_bitmask == bitmask)
+				return chip->dma_buffer +
+					free_index * MSM_NAND_DMA_BUFFER_SLOTS;
+			free_bitmask = 0; /* force return */
+		}
+		/* current free range was too small, clear all free bits */
+		/* below the top busy bit within current_need_mask */
+		free_bitmask &=
+			~(~0U >> (32 - fls(bitmask & current_need_mask)));
+	} while (free_bitmask);
+
+	return NULL;
+}
+
+static void msm_nand_release_dma_buffer(struct msm_nand_chip *chip,
+					void *buffer, size_t size)
+{
+	int index;
+	unsigned int used_mask;
+
+	used_mask = (1UL << DIV_ROUND_UP(size, MSM_NAND_DMA_BUFFER_SLOTS)) - 1;
+	index = ((uint8_t *)buffer - chip->dma_buffer) /
+		MSM_NAND_DMA_BUFFER_SLOTS;
+	atomic_sub(used_mask << index, &chip->dma_buffer_busy);
+
+	wake_up(&chip->wait_queue);
+}
+
+static uint32_t flash_read_id(struct msm_nand_chip *chip)
+{
+	struct {
+		dmov_s cmd[5];
+		unsigned cmdptr;
+		unsigned data[5];
+	} *dma_buffer;
+	uint32_t rv;
+
+	wait_event(chip->wait_queue,
+		   (dma_buffer = msm_nand_get_dma_buffer(
+			    chip, sizeof(*dma_buffer))));
+
+	dma_buffer->data[0] = NAND_DEV_SEL_CS0 | DM_ENABLE;
+	dma_buffer->data[1] = MSM_NAND_CMD_FETCH_ID;
+	dma_buffer->data[2] = 1;
+	dma_buffer->data[3] = MSM_NAND_STATS_INIT;
+	dma_buffer->data[4] = MSM_NAND_STATS_INIT;
+	/* verify the array size statically to avoid array overflow access */
+	BUILD_BUG_ON(4 != ARRAY_SIZE(dma_buffer->data) - 1);
+
+	dma_buffer->cmd[0].cmd = 0 | CMD_OCB;
+	dma_buffer->cmd[0].src = msm_virt_to_dma(chip, &dma_buffer->data[0]);
+	dma_buffer->cmd[0].dst = MSM_NAND_FLASH_CHIP_SELECT;
+	dma_buffer->cmd[0].len = 4;
+
+	dma_buffer->cmd[1].cmd = DST_CRCI_NAND_CMD;
+	dma_buffer->cmd[1].src = msm_virt_to_dma(chip, &dma_buffer->data[1]);
+	dma_buffer->cmd[1].dst = MSM_NAND_FLASH_CMD;
+	dma_buffer->cmd[1].len = 4;
+
+	dma_buffer->cmd[2].cmd = 0;
+	dma_buffer->cmd[2].src = msm_virt_to_dma(chip, &dma_buffer->data[2]);
+	dma_buffer->cmd[2].dst = MSM_NAND_EXEC_CMD;
+	dma_buffer->cmd[2].len = 4;
+
+	dma_buffer->cmd[3].cmd = SRC_CRCI_NAND_DATA;
+	dma_buffer->cmd[3].src = MSM_NAND_FLASH_STATUS;
+	dma_buffer->cmd[3].dst = msm_virt_to_dma(chip, &dma_buffer->data[3]);
+	dma_buffer->cmd[3].len = 4;
+
+	dma_buffer->cmd[4].cmd = CMD_OCU | CMD_LC;
+	dma_buffer->cmd[4].src = MSM_NAND_READ_ID;
+	dma_buffer->cmd[4].dst = msm_virt_to_dma(chip, &dma_buffer->data[4]);
+	dma_buffer->cmd[4].len = 4;
+	/* verify the array size statically to avoid array overflow access */
+	BUILD_BUG_ON(4 != ARRAY_SIZE(dma_buffer->cmd) - 1);
+
+	dma_buffer->cmdptr =
+		(msm_virt_to_dma(chip, dma_buffer->cmd) >> 3) | CMD_PTR_LP;
+
+	msm_dmov_exec_cmd(
+		chip->dma_channel, DMOV_CMD_PTR_LIST |
+		DMOV_CMD_ADDR(msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+	rv = dma_buffer->data[4];
+	pr_debug("nandid %x status %x\n", rv, dma_buffer->data[3]);
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+	return rv;
+}
+
+static int flash_read_config(struct msm_nand_chip *chip)
+{
+	struct {
+		dmov_s cmd[2];
+		unsigned cmdptr;
+		unsigned cfg0;
+		unsigned cfg1;
+	} *dma_buffer;
+
+	wait_event(chip->wait_queue,
+		   (dma_buffer = msm_nand_get_dma_buffer(
+			    chip, sizeof(*dma_buffer))));
+	dma_buffer->cfg0 = 0;
+	dma_buffer->cfg1 = 0;
+
+	dma_buffer->cmd[0].cmd = CMD_OCB;
+	dma_buffer->cmd[0].src = MSM_NAND_DEV0_CFG0;
+	dma_buffer->cmd[0].dst = msm_virt_to_dma(chip, &dma_buffer->cfg0);
+	dma_buffer->cmd[0].len = 4;
+
+	dma_buffer->cmd[1].cmd = CMD_OCU | CMD_LC;
+	dma_buffer->cmd[1].src = MSM_NAND_DEV0_CFG1;
+	dma_buffer->cmd[1].dst = msm_virt_to_dma(chip, &dma_buffer->cfg1);
+	dma_buffer->cmd[1].len = 4;
+	/* verify the array size statically to avoid array overflow access */
+	BUILD_BUG_ON(1 != ARRAY_SIZE(dma_buffer->cmd) - 1);
+
+	dma_buffer->cmdptr =
+		(msm_virt_to_dma(chip, dma_buffer->cmd) >> 3) | CMD_PTR_LP;
+
+	msm_dmov_exec_cmd(
+		chip->dma_channel, DMOV_CMD_PTR_LIST |
+		DMOV_CMD_ADDR(msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+	chip->cfg0 = dma_buffer->cfg0;
+	chip->cfg1 = dma_buffer->cfg1;
+	pr_debug("Default cfg0 = %x cfg1 = %x\n", chip->cfg0, chip->cfg1);
+	pr_debug("cfg0 info: cw/page=%d ud_sz=%d ecc_sz=%d spare_sz=%d\n",
+		(chip->cfg0 >> 6) & 7, (chip->cfg0 >> 9) & 0x3ff,
+		(chip->cfg0 >> 19) & 15, (chip->cfg0 >> 23) & 15);
+
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+
+	if ((chip->cfg0 == 0) || (chip->cfg1 == 0))
+		return -ENODEV;
+
+	return 0;
+}
+
+unsigned flash_rd_reg(struct msm_nand_chip *chip, unsigned addr)
+{
+	struct {
+		dmov_s cmd;
+		unsigned cmdptr;
+		unsigned data;
+	} *dma_buffer;
+	unsigned rv;
+
+	wait_event(chip->wait_queue,
+		   (dma_buffer = msm_nand_get_dma_buffer(
+			    chip, sizeof(*dma_buffer))));
+
+	dma_buffer->cmd.cmd = CMD_LC;
+	dma_buffer->cmd.src = addr;
+	dma_buffer->cmd.dst = msm_virt_to_dma(chip, &dma_buffer->data);
+	dma_buffer->cmd.len = 4;
+
+	dma_buffer->cmdptr =
+		(msm_virt_to_dma(chip, &dma_buffer->cmd) >> 3) | CMD_PTR_LP;
+	dma_buffer->data = MSM_NAND_STATS_INIT;
+
+	msm_dmov_exec_cmd(
+		chip->dma_channel, DMOV_CMD_PTR_LIST |
+		DMOV_CMD_ADDR(msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+	rv = dma_buffer->data;
+
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+
+	return rv;
+}
+
+void flash_wr_reg(struct msm_nand_chip *chip, unsigned addr, unsigned val)
+{
+	struct {
+		dmov_s cmd;
+		unsigned cmdptr;
+		unsigned data;
+	} *dma_buffer;
+
+	wait_event(chip->wait_queue,
+		   (dma_buffer = msm_nand_get_dma_buffer(
+			    chip, sizeof(*dma_buffer))));
+
+	dma_buffer->cmd.cmd = CMD_LC;
+	dma_buffer->cmd.src = msm_virt_to_dma(chip, &dma_buffer->data);
+	dma_buffer->cmd.dst = addr;
+	dma_buffer->cmd.len = 4;
+
+	dma_buffer->cmdptr =
+		(msm_virt_to_dma(chip, &dma_buffer->cmd) >> 3) | CMD_PTR_LP;
+	dma_buffer->data = val;
+
+	msm_dmov_exec_cmd(
+		chip->dma_channel, DMOV_CMD_PTR_LIST |
+		DMOV_CMD_ADDR(msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+}
+
+static dma_addr_t
+msm_nand_dma_map(struct device *dev, void *addr, size_t size,
+		 enum dma_data_direction dir)
+{
+	struct page *page;
+	unsigned long offset = (unsigned long)addr & ~PAGE_MASK;
+	if (virt_addr_valid(addr))
+		page = virt_to_page(addr);
+	else {
+		if (WARN_ON(size + offset > PAGE_SIZE))
+			return ~0;
+		page = vmalloc_to_page(addr);
+	}
+	return dma_map_page(dev, page, offset, size, dir);
+}
+
+static int msm_nand_check_empty(struct mtd_info *mtd, struct mtd_oob_ops *ops,
+				unsigned long *uncorrected)
+{
+	unsigned int p, n, end;
+	uint8_t *datbuf = ops->datbuf;
+	uint8_t *oobbuf = ops->oobbuf;
+	size_t oobsize;
+	int page_count;
+
+	if (ops->mode == MTD_OOB_RAW)
+		return false;
+
+	page_count = ops->retlen / mtd->writesize;
+	oobsize = (ops->mode == MTD_OOB_AUTO) ? mtd->oobavail : mtd->oobsize;
+
+	for_each_set_bit(p, uncorrected, page_count) {
+		if (datbuf) {
+			datbuf = ops->datbuf + p * mtd->writesize;
+			for (n = 0; n < mtd->writesize; n++) {
+				/* empty blocks read 0x54 at these offsets */
+				if (datbuf[n] != ((n % 516 == 3) ? 0x54 : 0xff))
+					return false;
+			}
+		}
+		if (oobbuf) {
+			n = p * oobsize;
+			end = min(n + oobsize, ops->oobretlen);
+			for (; n < end; n++)
+				if (oobbuf[n] != 0xff)
+					return false;
+		}
+		if (ops->datbuf)
+			for (n = 3; n < mtd->writesize; n += 516)
+				datbuf[n] = 0xff;
+	}
+	return true;
+}
+
+static int msm_nand_read_oob(struct mtd_info *mtd, loff_t from,
+			     struct mtd_oob_ops *ops)
+{
+	struct msm_nand_chip *chip = mtd->priv;
+
+	struct {
+		dmov_s cmd[8 * 5 + 3];
+		unsigned cmdptr;
+		struct {
+			uint32_t cmd;
+			uint32_t addr0;
+			uint32_t addr1;
+			uint32_t chipsel;
+			uint32_t cfg0;
+			uint32_t cfg1;
+			uint32_t exec;
+			uint32_t ecccfg;
+			struct {
+				uint32_t flash_status;
+				uint32_t buffer_status;
+			} result[8];
+		} data;
+	} *dma_buffer;
+	dmov_s *cmd;
+	unsigned n;
+	unsigned page = from >> chip->page_shift;
+	uint32_t oob_len = ops->ooblen;
+	uint32_t sectordatasize;
+	uint32_t sectoroobsize;
+	int err, pageerr;
+	dma_addr_t data_dma_addr = 0;
+	dma_addr_t oob_dma_addr = 0;
+	dma_addr_t data_dma_addr_curr = 0;
+	dma_addr_t oob_dma_addr_curr = 0;
+	uint32_t oob_col = 0;
+	unsigned page_count;
+	unsigned pages_read = 0;
+	unsigned start_sector = 0;
+	uint32_t sector_corrected;
+	uint32_t page_corrected;
+	uint32_t total_corrected = 0;
+	uint32_t total_uncorrected = 0;
+	unsigned long uncorrected_noalloc = 0;
+	unsigned long *uncorrected = &uncorrected_noalloc;
+
+	if (from & (mtd->writesize - 1)) {
+		pr_err("Unsupported from, 0x%llx\n", from);
+		return -EINVAL;
+	}
+	if (ops->mode != MTD_OOB_RAW) {
+		if (ops->datbuf != NULL && (ops->len % mtd->writesize) != 0) {
+			pr_err("Unsupported ops->len, %d\n", ops->len);
+			return -EINVAL;
+		}
+	} else {
+		if (ops->datbuf != NULL &&
+			(ops->len % (mtd->writesize + mtd->oobsize)) != 0) {
+			pr_err("Unsupported ops->len,"
+				" %d for MTD_OOB_RAW\n", ops->len);
+			return -EINVAL;
+		}
+	}
+
+	if (ops->mode != MTD_OOB_RAW && ops->ooblen != 0 && ops->ooboffs != 0) {
+		pr_err("Unsupported ops->ooboffs, %d\n", ops->ooboffs);
+		return -EINVAL;
+	}
+
+	if (ops->oobbuf && !ops->datbuf && ops->mode == MTD_OOB_AUTO)
+		start_sector = chip->last_sector;
+
+	if (ops->oobbuf && !ops->datbuf) {
+		unsigned tmpoobsz = (ops->mode == MTD_OOB_AUTO) ?
+			mtd->oobavail : mtd->oobsize;
+		page_count = DIV_ROUND_UP(ops->ooblen, tmpoobsz);
+	} else if (ops->mode != MTD_OOB_RAW)
+		page_count = ops->len / mtd->writesize;
+	else
+		page_count = ops->len / (mtd->writesize + mtd->oobsize);
+
+	pr_debug("%llx %p %x %p %x\n",
+		from, ops->datbuf, ops->len, ops->oobbuf, ops->ooblen);
+
+	if (ops->datbuf) {
+		data_dma_addr_curr = data_dma_addr =
+			msm_nand_dma_map(chip->dev, ops->datbuf, ops->len,
+					 DMA_FROM_DEVICE);
+		if (dma_mapping_error(chip->dev, data_dma_addr)) {
+			pr_err("failed to get dma addr for %p\n", ops->datbuf);
+			return -EIO;
+		}
+	}
+	if (ops->oobbuf) {
+		memset(ops->oobbuf, 0xff, ops->ooblen);
+		oob_dma_addr_curr = oob_dma_addr =
+			msm_nand_dma_map(chip->dev, ops->oobbuf,
+					 ops->ooblen, DMA_BIDIRECTIONAL);
+		if (dma_mapping_error(chip->dev, oob_dma_addr)) {
+			pr_err("failed to get dma addr for %p\n", ops->oobbuf);
+			err = -EIO;
+			goto err_dma_map_oobbuf_failed;
+		}
+	}
+	if (BITS_TO_LONGS(page_count) > 1) {
+		uncorrected = kzalloc(BITS_TO_LONGS(page_count) * sizeof(long),
+				      GFP_NOIO);
+		if (!uncorrected) {
+			err = -ENOMEM;
+			goto err_alloc_uncorrected_failed;
+		}
+	}
+
+	wait_event(chip->wait_queue,
+		   (dma_buffer = msm_nand_get_dma_buffer(
+			    chip, sizeof(*dma_buffer))));
+
+	oob_col = start_sector * 0x210;
+	if (chip->cfg1 & CFG1_WIDE_FLASH)
+		oob_col >>= 1;
+
+	err = 0;
+	while (page_count-- > 0) {
+		cmd = dma_buffer->cmd;
+
+		/* CMD / ADDR0 / ADDR1 / CHIPSEL program values */
+		if (ops->mode != MTD_OOB_RAW) {
+			dma_buffer->data.cmd = MSM_NAND_CMD_PAGE_READ_ECC;
+			dma_buffer->data.cfg0 =
+				(chip->cfg0 & ~(7U << 6)) |
+				((chip->last_sector - start_sector) << 6);
+			dma_buffer->data.cfg1 = chip->cfg1;
+		} else {
+			dma_buffer->data.cmd = MSM_NAND_CMD_PAGE_READ;
+			dma_buffer->data.cfg0 =
+				(MSM_NAND_CFG0_RAW & ~(7U << 6)) |
+				(chip->last_sector << 6);
+			dma_buffer->data.cfg1 = MSM_NAND_CFG1_RAW |
+						(chip->cfg1 & CFG1_WIDE_FLASH);
+		}
+
+		dma_buffer->data.addr0 = (page << 16) | oob_col;
+		dma_buffer->data.addr1 = (page >> 16) & 0xff;
+		/* flash0 + undoc bit */
+		dma_buffer->data.chipsel = NAND_DEV_SEL_CS0 | DM_ENABLE;
+
+		/* GO bit for the EXEC register */
+		dma_buffer->data.exec = 1;
+
+		/* verify the array size statically to avoid array
+		 * overflow access
+		 */
+		BUILD_BUG_ON(8 != ARRAY_SIZE(dma_buffer->data.result));
+
+		for (n = start_sector; n <= chip->last_sector; n++) {
+			/* flash + buffer status return words */
+			dma_buffer->data.result[n].flash_status =
+							 MSM_NAND_STATS_INIT;
+			dma_buffer->data.result[n].buffer_status =
+							 MSM_NAND_STATS_INIT;
+
+			/* block on cmd ready, then
+			 * write CMD / ADDR0 / ADDR1 / CHIPSEL
+			 * regs in a burst
+			 */
+			cmd->cmd = DST_CRCI_NAND_CMD;
+			cmd->src = msm_virt_to_dma(chip, &dma_buffer->data.cmd);
+			cmd->dst = MSM_NAND_FLASH_CMD;
+			if (n == start_sector)
+				cmd->len = 16;
+			else
+				cmd->len = 4;
+			cmd++;
+
+			if (n == start_sector) {
+				cmd->cmd = 0;
+				cmd->src = msm_virt_to_dma(chip,
+							&dma_buffer->data.cfg0);
+				cmd->dst = MSM_NAND_DEV0_CFG0;
+				cmd->len = 8;
+				cmd++;
+
+				dma_buffer->data.ecccfg = chip->ecc_buf_cfg;
+				cmd->cmd = 0;
+				cmd->src = msm_virt_to_dma(chip,
+						&dma_buffer->data.ecccfg);
+				cmd->dst = MSM_NAND_EBI2_ECC_BUF_CFG;
+				cmd->len = 4;
+				cmd++;
+			}
+
+			/* kick the execute register */
+			cmd->cmd = 0;
+			cmd->src =
+				msm_virt_to_dma(chip, &dma_buffer->data.exec);
+			cmd->dst = MSM_NAND_EXEC_CMD;
+			cmd->len = 4;
+			cmd++;
+
+			/* block on data ready, then
+			 * read the status register
+			 */
+			cmd->cmd = SRC_CRCI_NAND_DATA;
+			cmd->src = MSM_NAND_FLASH_STATUS;
+			cmd->dst = msm_virt_to_dma(chip,
+						   &dma_buffer->data.result[n]);
+			/* MSM_NAND_FLASH_STATUS + MSM_NAND_BUFFER_STATUS */
+			cmd->len = 8;
+			cmd++;
+
+			/* read data block
+			 * (only valid if status says success)
+			 */
+			if (ops->datbuf) {
+				if (ops->mode != MTD_OOB_RAW)
+					sectordatasize =
+						(n < chip->last_sector) ?
+						516 : chip->last_sectorsz;
+				else
+					sectordatasize = 528;
+
+				cmd->cmd = 0;
+				cmd->src = MSM_NAND_FLASH_BUFFER;
+				cmd->dst = data_dma_addr_curr;
+				data_dma_addr_curr += sectordatasize;
+				cmd->len = sectordatasize;
+				cmd++;
+			}
+
+			if (ops->oobbuf && (n == chip->last_sector ||
+					    ops->mode != MTD_OOB_AUTO)) {
+				cmd->cmd = 0;
+				if (n == chip->last_sector) {
+					cmd->src = MSM_NAND_FLASH_BUFFER +
+						chip->last_sectorsz;
+					sectoroobsize =
+						(chip->last_sector + 1) * 4;
+					if (ops->mode != MTD_OOB_AUTO)
+						sectoroobsize += 10;
+				} else {
+					cmd->src = MSM_NAND_FLASH_BUFFER + 516;
+					sectoroobsize = 10;
+				}
+
+				cmd->dst = oob_dma_addr_curr;
+				if (sectoroobsize < oob_len)
+					cmd->len = sectoroobsize;
+				else
+					cmd->len = oob_len;
+				oob_dma_addr_curr += cmd->len;
+				oob_len -= cmd->len;
+				if (cmd->len > 0)
+					cmd++;
+			}
+		}
+
+		/* verify the array size statically to avoid array
+		 * overflow access
+		 */
+		BUILD_BUG_ON(8 * 5 + 3 != ARRAY_SIZE(dma_buffer->cmd));
+		BUG_ON(cmd - dma_buffer->cmd > ARRAY_SIZE(dma_buffer->cmd));
+		dma_buffer->cmd[0].cmd |= CMD_OCB;
+		cmd[-1].cmd |= CMD_OCU | CMD_LC;
+
+		dma_buffer->cmdptr =
+			(msm_virt_to_dma(chip, dma_buffer->cmd) >> 3)
+			| CMD_PTR_LP;
+
+		msm_dmov_exec_cmd(
+			chip->dma_channel, DMOV_CMD_PTR_LIST | DMOV_CMD_ADDR(
+				msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+		/* if any of the writes failed (0x10), or there
+		 * was a protection violation (0x100), we lose
+		 */
+		pageerr = 0;
+		page_corrected = 0;
+		for (n = start_sector; n <= chip->last_sector; n++) {
+			uint32_t buf_stat =
+				dma_buffer->data.result[n].buffer_status;
+			if (buf_stat & BUF_STAT_UNCORRECTABLE) {
+				total_uncorrected++;
+				uncorrected[BIT_WORD(pages_read)] |=
+							BIT_MASK(pages_read);
+				pageerr = -EBADMSG;
+				break;
+			}
+			if (dma_buffer->data.result[n].flash_status & 0x110) {
+				pageerr = -EIO;
+				break;
+			}
+			sector_corrected = buf_stat & BUF_STAT_NUM_ERRS_MASK;
+			page_corrected += sector_corrected;
+			if (sector_corrected > 1)
+				pageerr = -EUCLEAN;
+		}
+		if ((!pageerr && page_corrected) || pageerr == -EUCLEAN) {
+			total_corrected += page_corrected;
+			mtd->ecc_stats.corrected += page_corrected;
+		}
+		if (pageerr && (pageerr != -EUCLEAN || err == 0))
+			err = pageerr;
+
+		for (n = start_sector; n <= chip->last_sector; n++)
+			pr_debug("flash_status[%d] = %x,\
+				buffr_status[%d] = %x\n",
+				n, dma_buffer->data.result[n].flash_status,
+				n, dma_buffer->data.result[n].buffer_status);
+
+		if (err && err != -EUCLEAN && err != -EBADMSG)
+			break;
+		pages_read++;
+		page++;
+	}
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+
+err_alloc_uncorrected_failed:
+	if (ops->oobbuf) {
+		dma_unmap_page(chip->dev, oob_dma_addr,
+			       ops->ooblen, DMA_FROM_DEVICE);
+	}
+err_dma_map_oobbuf_failed:
+	if (ops->datbuf) {
+		dma_unmap_page(chip->dev, data_dma_addr,
+			       ops->len, DMA_FROM_DEVICE);
+	}
+
+	if (ops->mode != MTD_OOB_RAW)
+		ops->retlen = mtd->writesize * pages_read;
+	else
+		ops->retlen = (mtd->writesize +  mtd->oobsize) *
+							pages_read;
+	ops->oobretlen = ops->ooblen - oob_len;
+
+	if (err == -EBADMSG && msm_nand_check_empty(mtd, ops, uncorrected))
+		err = 0;
+	else if (total_uncorrected)
+		mtd->ecc_stats.failed += total_uncorrected; /* not threadsafe */
+	if (uncorrected != &uncorrected_noalloc)
+		kfree(uncorrected);
+
+	if (err)
+		pr_err("%llx %x %x failed %d, corrected %d\n",
+		       from, ops->datbuf ? ops->len : 0, ops->ooblen, err,
+		       total_corrected);
+	return err;
+}
+
+static int
+msm_nand_read(struct mtd_info *mtd, loff_t from, size_t len,
+	      size_t *retlen, u_char *buf)
+{
+	int ret;
+	struct mtd_oob_ops ops;
+
+	ops.mode = MTD_OOB_PLACE;
+	ops.len = len;
+	ops.retlen = 0;
+	ops.ooblen = 0;
+	ops.datbuf = buf;
+	ops.oobbuf = NULL;
+	ret =  msm_nand_read_oob(mtd, from, &ops);
+	*retlen = ops.retlen;
+	return ret;
+}
+
+static int
+msm_nand_write_oob(struct mtd_info *mtd, loff_t to, struct mtd_oob_ops *ops)
+{
+	struct msm_nand_chip *chip = mtd->priv;
+	struct {
+		dmov_s cmd[8 * 6 + 3];
+		unsigned cmdptr;
+		struct {
+			uint32_t cmd;
+			uint32_t addr0;
+			uint32_t addr1;
+			uint32_t chipsel;
+			uint32_t cfg0;
+			uint32_t cfg1;
+			uint32_t exec;
+			uint32_t ecccfg;
+			uint32_t flash_status[8];
+			uint32_t zeroes;
+		} data;
+	} *dma_buffer;
+	dmov_s *cmd;
+	unsigned n;
+	unsigned page = to >> chip->page_shift;
+	uint32_t oob_len = ops->ooblen;
+	uint32_t sectordatawritesize;
+	int err;
+	dma_addr_t data_dma_addr = 0;
+	dma_addr_t oob_dma_addr = 0;
+	dma_addr_t data_dma_addr_curr = 0;
+	dma_addr_t oob_dma_addr_curr = 0;
+	unsigned page_count;
+	unsigned pages_written = 0;
+
+	if (to & (mtd->writesize - 1)) {
+		pr_err("Unsupported to, 0x%llx\n", to);
+		return -EINVAL;
+	}
+
+	if (ops->mode != MTD_OOB_RAW) {
+		if (ops->ooblen != 0 && ops->mode != MTD_OOB_AUTO) {
+			pr_err("Unsupported ops->mode,%d\n", ops->mode);
+			return -EINVAL;
+		}
+		if ((ops->len % mtd->writesize) != 0) {
+			pr_err("Unsupported ops->len, %d\n", ops->len);
+			return -EINVAL;
+		}
+	} else {
+		if ((ops->len % (mtd->writesize + mtd->oobsize)) != 0) {
+			pr_err("Unsupported ops->len, "
+				"%d for MTD_OOB_RAW mode\n", ops->len);
+			return -EINVAL;
+		}
+	}
+
+	if (ops->datbuf == NULL) {
+		pr_err("Unsupported ops->datbuf == NULL\n");
+		return -EINVAL;
+	}
+
+	if (ops->mode != MTD_OOB_RAW && ops->ooblen != 0 && ops->ooboffs != 0) {
+		pr_err("Unsupported ops->ooboffs, %d\n", ops->ooboffs);
+		return -EINVAL;
+	}
+
+	if (ops->datbuf) {
+		data_dma_addr_curr = data_dma_addr =
+			msm_nand_dma_map(chip->dev, ops->datbuf,
+					 ops->len, DMA_TO_DEVICE);
+		if (dma_mapping_error(chip->dev, data_dma_addr)) {
+			pr_err("failed to get dma addr for %p\n", ops->datbuf);
+			return -EIO;
+		}
+	}
+	if (ops->oobbuf) {
+		oob_dma_addr_curr = oob_dma_addr =
+			msm_nand_dma_map(chip->dev, ops->oobbuf,
+					 ops->ooblen, DMA_TO_DEVICE);
+		if (dma_mapping_error(chip->dev, oob_dma_addr)) {
+			pr_err("failed to get dma addr for %p\n", ops->oobbuf);
+			err = -EIO;
+			goto err_dma_map_oobbuf_failed;
+		}
+	}
+	if (ops->mode != MTD_OOB_RAW)
+		page_count = ops->len / mtd->writesize;
+	else
+		page_count = ops->len / (mtd->writesize + mtd->oobsize);
+
+	wait_event(chip->wait_queue, (dma_buffer =
+			msm_nand_get_dma_buffer(chip, sizeof(*dma_buffer))));
+
+	while (page_count-- > 0) {
+		cmd = dma_buffer->cmd;
+
+		/* CMD / ADDR0 / ADDR1 / CHIPSEL program values */
+		if (ops->mode != MTD_OOB_RAW) {
+			dma_buffer->data.cfg0 = chip->cfg0;
+			dma_buffer->data.cfg1 = chip->cfg1;
+		} else {
+			dma_buffer->data.cfg0 =
+				(MSM_NAND_CFG0_RAW & ~(7U << 6)) |
+				(chip->last_sector << 6);
+			dma_buffer->data.cfg1 = MSM_NAND_CFG1_RAW |
+				(chip->cfg1 & CFG1_WIDE_FLASH);
+		}
+
+		dma_buffer->data.cmd = MSM_NAND_CMD_PRG_PAGE;
+		dma_buffer->data.addr0 = page << 16;
+		dma_buffer->data.addr1 = (page >> 16) & 0xff;
+		dma_buffer->data.chipsel = NAND_DEV_SEL_CS0 | DM_ENABLE;
+		dma_buffer->data.zeroes = 0;
+
+		/* GO bit for the EXEC register */
+		dma_buffer->data.exec = 1;
+
+		/* verify the array size statically to avoid array
+		 * overflow access
+		 */
+		BUILD_BUG_ON(8 != ARRAY_SIZE(dma_buffer->data.flash_status));
+
+		for (n = 0; n <= chip->last_sector ; n++) {
+			/* status return words */
+			dma_buffer->data.flash_status[n] = MSM_NAND_STATS_INIT;
+			/* block on cmd ready, then
+			 * write CMD / ADDR0 / ADDR1 / CHIPSEL regs in a burst
+			 */
+			cmd->cmd = DST_CRCI_NAND_CMD;
+			cmd->src =
+				msm_virt_to_dma(chip, &dma_buffer->data.cmd);
+			cmd->dst = MSM_NAND_FLASH_CMD;
+			if (n == 0)
+				cmd->len = 16;
+			else
+				cmd->len = 4;
+			cmd++;
+
+			if (n == 0) {
+				cmd->cmd = 0;
+				cmd->src = msm_virt_to_dma(chip,
+							&dma_buffer->data.cfg0);
+				cmd->dst = MSM_NAND_DEV0_CFG0;
+				cmd->len = 8;
+				cmd++;
+
+				dma_buffer->data.ecccfg = chip->ecc_buf_cfg;
+				cmd->cmd = 0;
+				cmd->src = msm_virt_to_dma(chip,
+						&dma_buffer->data.ecccfg);
+				cmd->dst = MSM_NAND_EBI2_ECC_BUF_CFG;
+				cmd->len = 4;
+				cmd++;
+			}
+
+			/* write data block */
+			if (ops->mode != MTD_OOB_RAW)
+				sectordatawritesize = (n < chip->last_sector) ?
+					516 : chip->last_sectorsz;
+			else
+				sectordatawritesize = 528;
+
+			cmd->cmd = 0;
+			cmd->src = data_dma_addr_curr;
+			data_dma_addr_curr += sectordatawritesize;
+			cmd->dst = MSM_NAND_FLASH_BUFFER;
+			cmd->len = sectordatawritesize;
+			cmd++;
+
+			if (ops->oobbuf) {
+				if (n == chip->last_sector) {
+					cmd->cmd = 0;
+					cmd->src = oob_dma_addr_curr;
+					cmd->dst = MSM_NAND_FLASH_BUFFER +
+						chip->last_sectorsz;
+					cmd->len = 516 - chip->last_sectorsz;
+					if (oob_len <= cmd->len)
+						cmd->len = oob_len;
+					oob_dma_addr_curr += cmd->len;
+					oob_len -= cmd->len;
+					if (cmd->len > 0)
+						cmd++;
+				}
+				if (ops->mode != MTD_OOB_AUTO) {
+					/* skip ecc bytes in oobbuf */
+					if (oob_len < 10) {
+						oob_dma_addr_curr += 10;
+						oob_len -= 10;
+					} else {
+						oob_dma_addr_curr += oob_len;
+						oob_len = 0;
+					}
+				}
+			}
+
+			/* kick the execute register */
+			cmd->cmd = 0;
+			cmd->src =
+				msm_virt_to_dma(chip, &dma_buffer->data.exec);
+			cmd->dst = MSM_NAND_EXEC_CMD;
+			cmd->len = 4;
+			cmd++;
+
+			/* block on data ready, then
+			 * read the status register
+			 */
+			cmd->cmd = SRC_CRCI_NAND_DATA;
+			cmd->src = MSM_NAND_FLASH_STATUS;
+			cmd->dst = msm_virt_to_dma(chip,
+					     &dma_buffer->data.flash_status[n]);
+			cmd->len = 4;
+			cmd++;
+
+			/* clear the status register in case the OP_ERR is set
+			 * due to the write, to work around a h/w bug */
+			cmd->cmd = 0;
+			cmd->src = msm_virt_to_dma(chip,
+						   &dma_buffer->data.zeroes);
+			cmd->dst = MSM_NAND_FLASH_STATUS;
+			cmd->len = 4;
+			cmd++;
+		}
+
+		dma_buffer->cmd[0].cmd |= CMD_OCB;
+		cmd[-1].cmd |= CMD_OCU | CMD_LC;
+		/* verify the array size statically to avoid array
+		 * overflow access
+		 */
+		BUILD_BUG_ON(8 * 6 + 3 != ARRAY_SIZE(dma_buffer->cmd));
+		BUG_ON(cmd - dma_buffer->cmd > ARRAY_SIZE(dma_buffer->cmd));
+		dma_buffer->cmdptr =
+			(msm_virt_to_dma(chip, dma_buffer->cmd) >> 3) |
+			CMD_PTR_LP;
+
+		msm_dmov_exec_cmd(chip->dma_channel,
+			DMOV_CMD_PTR_LIST | DMOV_CMD_ADDR(
+				msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+		/* if any of the writes failed (0x10), or there was a
+		 * protection violation (0x100), or the program success
+		 * bit (0x80) is unset, we lose
+		 */
+		err = 0;
+		for (n = 0; n <= chip->last_sector ; n++) {
+			if (dma_buffer->data.flash_status[n] & 0x110) {
+				if (dma_buffer->data.flash_status[n] & 0x10)
+					pr_err("Critical write error,"
+					       " 0x%x(%d)\n", page, n);
+				err = -EIO;
+				break;
+			}
+			if (!(dma_buffer->data.flash_status[n] & 0x80)) {
+				err = -EIO;
+				break;
+			}
+		}
+
+		for (n = 0; n <= chip->last_sector; n++)
+			pr_debug("write pg %d: flash_status[%d] = %x\n", page,
+				n, dma_buffer->data.flash_status[n]);
+
+		if (err)
+			break;
+		pages_written++;
+		page++;
+	}
+
+	if (ops->mode != MTD_OOB_RAW)
+		ops->retlen = mtd->writesize * pages_written;
+	else
+		ops->retlen = (mtd->writesize + mtd->oobsize) * pages_written;
+
+	ops->oobretlen = ops->ooblen - oob_len;
+
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+
+	if (ops->oobbuf)
+		dma_unmap_page(chip->dev, oob_dma_addr,
+			       ops->ooblen, DMA_TO_DEVICE);
+err_dma_map_oobbuf_failed:
+	if (ops->datbuf)
+		dma_unmap_page(chip->dev, data_dma_addr,
+			       ops->len, DMA_TO_DEVICE);
+	if (err)
+		pr_err("%llx %x %x failed %d\n",
+		       to, ops->len, ops->ooblen, err);
+	return err;
+}
+
+static int msm_nand_write(struct mtd_info *mtd, loff_t to, size_t len,
+			  size_t *retlen, const u_char *buf)
+{
+	int ret;
+	struct mtd_oob_ops ops;
+
+	ops.mode = MTD_OOB_PLACE;
+	ops.len = len;
+	ops.retlen = 0;
+	ops.ooblen = 0;
+	ops.datbuf = (uint8_t *)buf;
+	ops.oobbuf = NULL;
+	ret =  msm_nand_write_oob(mtd, to, &ops);
+	*retlen = ops.retlen;
+	return ret;
+}
+
+static int
+msm_nand_erase(struct mtd_info *mtd, struct erase_info *instr)
+{
+	int err;
+	struct msm_nand_chip *chip = mtd->priv;
+	struct {
+		dmov_s cmd[5];
+		unsigned cmdptr;
+		unsigned data[9];
+	} *dma_buffer;
+	unsigned page = instr->addr >> chip->page_shift;
+
+	if (instr->addr & (mtd->erasesize - 1)) {
+		pr_err("Unsupported erase address, 0x%llx\n", instr->addr);
+		return -EINVAL;
+	}
+	if (instr->len != mtd->erasesize) {
+		pr_err("Unsupported erase len, %lld\n", instr->len);
+		return -EINVAL;
+	}
+
+	wait_event(chip->wait_queue,
+		   (dma_buffer = msm_nand_get_dma_buffer(
+			    chip, sizeof(*dma_buffer))));
+
+	dma_buffer->data[0] = MSM_NAND_CMD_BLOCK_ERASE;
+	dma_buffer->data[1] = page;
+	dma_buffer->data[2] = 0;
+	dma_buffer->data[3] = NAND_DEV_SEL_CS0 | DM_ENABLE;
+	dma_buffer->data[4] = 1;
+	dma_buffer->data[5] = 0xeeeeeeee;
+	dma_buffer->data[6] = chip->cfg0 & (~(7 << 6));
+	dma_buffer->data[7] = chip->cfg1;
+	dma_buffer->data[8] = 0;
+	/* verify the array size statically to avoid array overflow access */
+	BUILD_BUG_ON(8 != ARRAY_SIZE(dma_buffer->data) - 1);
+
+	dma_buffer->cmd[0].cmd = DST_CRCI_NAND_CMD | CMD_OCB;
+	dma_buffer->cmd[0].src = msm_virt_to_dma(chip, &dma_buffer->data[0]);
+	dma_buffer->cmd[0].dst = MSM_NAND_FLASH_CMD;
+	dma_buffer->cmd[0].len = 16;
+
+	dma_buffer->cmd[1].cmd = 0;
+	dma_buffer->cmd[1].src = msm_virt_to_dma(chip, &dma_buffer->data[6]);
+	dma_buffer->cmd[1].dst = MSM_NAND_DEV0_CFG0;
+	dma_buffer->cmd[1].len = 8;
+
+	dma_buffer->cmd[2].cmd = 0;
+	dma_buffer->cmd[2].src = msm_virt_to_dma(chip, &dma_buffer->data[4]);
+	dma_buffer->cmd[2].dst = MSM_NAND_EXEC_CMD;
+	dma_buffer->cmd[2].len = 4;
+
+	dma_buffer->cmd[3].cmd = SRC_CRCI_NAND_DATA;
+	dma_buffer->cmd[3].src = MSM_NAND_FLASH_STATUS;
+	dma_buffer->cmd[3].dst = msm_virt_to_dma(chip, &dma_buffer->data[5]);
+	dma_buffer->cmd[3].len = 4;
+
+	/* clear the status register in case the OP_ERR is set
+	 * due to the write, to work around a h/w bug */
+	dma_buffer->cmd[4].cmd = CMD_OCU | CMD_LC;
+	dma_buffer->cmd[4].src = msm_virt_to_dma(chip, &dma_buffer->data[8]);
+	dma_buffer->cmd[4].dst = MSM_NAND_FLASH_STATUS;
+	dma_buffer->cmd[4].len = 4;
+
+	BUILD_BUG_ON(4 != ARRAY_SIZE(dma_buffer->cmd) - 1);
+
+	dma_buffer->cmdptr =
+		(msm_virt_to_dma(chip, dma_buffer->cmd) >> 3) | CMD_PTR_LP;
+
+	msm_dmov_exec_cmd(
+		chip->dma_channel, DMOV_CMD_PTR_LIST |
+		DMOV_CMD_ADDR(msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+	/* we fail if there was an operation error, a mpu error, or the
+	 * erase success bit was not set.
+	 */
+
+	if (dma_buffer->data[5] & 0x110 || !(dma_buffer->data[5] & 0x80)) {
+		if (dma_buffer->data[5] & 0x10)
+			pr_warning("Critical erase error, 0x%llx\n",
+				  instr->addr);
+		err = -EIO;
+	} else
+		err = 0;
+
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer));
+	if (err) {
+		pr_err("erase failed, 0x%llx\n", instr->addr);
+		instr->fail_addr = instr->addr;
+		instr->state = MTD_ERASE_FAILED;
+	} else {
+		instr->state = MTD_ERASE_DONE;
+		instr->fail_addr = 0xffffffff;
+		mtd_erase_callback(instr);
+	}
+	return err;
+}
+
+static int
+msm_nand_block_isbad(struct mtd_info *mtd, loff_t ofs)
+{
+	struct msm_nand_chip *chip = mtd->priv;
+	int ret;
+	struct {
+		dmov_s cmd[5];
+		unsigned cmdptr;
+		struct {
+			uint32_t cmd;
+			uint32_t addr0;
+			uint32_t addr1;
+			uint32_t chipsel;
+			uint32_t cfg0;
+			uint32_t cfg1;
+			uint32_t exec;
+			uint32_t ecccfg;
+			struct {
+				uint32_t flash_status;
+				uint32_t buffer_status;
+			} result;
+		} data;
+	} *dma_buffer;
+	dmov_s *cmd;
+	uint8_t *buf;
+	unsigned page = ofs >> chip->page_shift;
+
+	/* Check for invalid offset */
+	if (ofs > mtd->size)
+		return -EINVAL;
+	if (ofs & (mtd->erasesize - 1)) {
+		pr_err("Unsupported block address, 0x%x\n", (uint32_t)ofs);
+		return -EINVAL;
+	}
+
+	wait_event(chip->wait_queue,
+		(dma_buffer = msm_nand_get_dma_buffer(chip ,
+					 sizeof(*dma_buffer) + 4)));
+	buf = (uint8_t *)dma_buffer + sizeof(*dma_buffer);
+
+	/* Read 4 bytes starting from the bad block marker location
+	 * in the last code word of the page
+	 */
+	cmd = dma_buffer->cmd;
+
+	dma_buffer->data.cmd = MSM_NAND_CMD_PAGE_READ;
+	dma_buffer->data.cfg0 = MSM_NAND_CFG0_RAW & ~(7U << 6);
+	dma_buffer->data.cfg1 = MSM_NAND_CFG1_RAW |
+					 (chip->cfg1 & CFG1_WIDE_FLASH);
+
+	if (chip->cfg1 & CFG1_WIDE_FLASH)
+		dma_buffer->data.addr0 = (page << 16) |
+			((528 * chip->last_sector) >> 1);
+	else
+		dma_buffer->data.addr0 = (page << 16) |
+			(528 * chip->last_sector);
+
+	dma_buffer->data.addr1 = (page >> 16) & 0xff;
+	dma_buffer->data.chipsel = NAND_DEV_SEL_CS0 | DM_ENABLE;
+
+	dma_buffer->data.exec = 1;
+
+	dma_buffer->data.result.flash_status = MSM_NAND_STATS_INIT;
+	dma_buffer->data.result.buffer_status = MSM_NAND_STATS_INIT;
+
+	cmd->cmd = DST_CRCI_NAND_CMD;
+	cmd->src = msm_virt_to_dma(chip, &dma_buffer->data.cmd);
+	cmd->dst = MSM_NAND_FLASH_CMD;
+	cmd->len = 16;
+	cmd++;
+
+	cmd->cmd = 0;
+	cmd->src = msm_virt_to_dma(chip, &dma_buffer->data.cfg0);
+	cmd->dst = MSM_NAND_DEV0_CFG0;
+	cmd->len = 8;
+	cmd++;
+
+	cmd->cmd = 0;
+	cmd->src = msm_virt_to_dma(chip, &dma_buffer->data.exec);
+	cmd->dst = MSM_NAND_EXEC_CMD;
+	cmd->len = 4;
+	cmd++;
+
+	cmd->cmd = SRC_CRCI_NAND_DATA;
+	cmd->src = MSM_NAND_FLASH_STATUS;
+	cmd->dst = msm_virt_to_dma(chip, &dma_buffer->data.result);
+	cmd->len = 8;
+	cmd++;
+
+	cmd->cmd = 0;
+	cmd->src = MSM_NAND_FLASH_BUFFER +
+		(mtd->writesize - 528 * chip->last_sector);
+	cmd->dst = msm_virt_to_dma(chip, buf);
+	cmd->len = 4;
+	cmd++;
+
+	BUILD_BUG_ON(5 != ARRAY_SIZE(dma_buffer->cmd));
+	BUG_ON(cmd - dma_buffer->cmd > ARRAY_SIZE(dma_buffer->cmd));
+	dma_buffer->cmd[0].cmd |= CMD_OCB;
+	cmd[-1].cmd |= CMD_OCU | CMD_LC;
+
+	dma_buffer->cmdptr = (msm_virt_to_dma(chip,
+				dma_buffer->cmd) >> 3) | CMD_PTR_LP;
+
+	msm_dmov_exec_cmd(chip->dma_channel, DMOV_CMD_PTR_LIST |
+		DMOV_CMD_ADDR(msm_virt_to_dma(chip, &dma_buffer->cmdptr)));
+
+	ret = 0;
+	if (dma_buffer->data.result.flash_status & 0x110)
+		ret = -EIO;
+
+	if (!ret) {
+		/* Check for bad block marker byte */
+		if (chip->cfg1 & CFG1_WIDE_FLASH) {
+			if (buf[0] != 0xFF || buf[1] != 0xFF)
+				ret = 1;
+		} else {
+			if (buf[0] != 0xFF)
+				ret = 1;
+		}
+	}
+
+	msm_nand_release_dma_buffer(chip, dma_buffer, sizeof(*dma_buffer) + 4);
+	return ret;
+}
+
+
+static int
+msm_nand_block_markbad(struct mtd_info *mtd, loff_t ofs)
+{
+	struct mtd_oob_ops ops;
+	int ret;
+	uint8_t *buf;
+
+	/* Check for invalid offset */
+	if (ofs > mtd->size)
+		return -EINVAL;
+	if (ofs & (mtd->erasesize - 1)) {
+		pr_err("Unsupported block address, 0x%x\n", (uint32_t)ofs);
+		return -EINVAL;
+	}
+
+	/*
+	Write all 0s to the first page
+	This will set the BB marker to 0
+	*/
+
+	/* Use the already existing zero page */
+	buf =  page_address(ZERO_PAGE());
+
+	ops.mode = MTD_OOB_RAW;
+	ops.len = mtd->writesize + mtd->oobsize;
+	ops.retlen = 0;
+	ops.ooblen = 0;
+	ops.datbuf = buf;
+	ops.oobbuf = NULL;
+	ret =  msm_nand_write_oob(mtd, ofs, &ops);
+
+	return ret;
+}
+
+/**
+ * msm_nand_scan - [msm_nand Interface] Scan for the msm_nand device
+ * @mtd:        MTD device structure
+ * @maxchips:   Number of chips to scan for
+ *
+ * This fills out all the not initialized function pointers
+ * with the defaults.
+ * The flash ID is read and the mtd/chip structures are
+ * filled with the appropriate values.
+ */
+static int msm_nand_scan(struct mtd_info *mtd, int maxchips)
+{
+	unsigned n;
+	struct msm_nand_chip *chip = mtd->priv;
+	uint32_t flash_id;
+	uint32_t manid;
+	uint32_t devid;
+	uint32_t devcfg;
+	uint32_t busw16;
+	struct nand_flash_dev *flashdev = NULL;
+	struct nand_manufacturers *flashman = NULL;
+
+	if (flash_read_config(chip)) {
+		pr_err("ERRROR: could not save cfg0 & cfg1 state\n");
+		return -ENODEV;
+	}
+	pr_info("NAND_READ_ID = %x\n", flash_rd_reg(chip, MSM_NAND_READ_ID));
+	flash_wr_reg(chip, MSM_NAND_READ_ID, 0x12345678);
+
+	flash_id = flash_read_id(chip);
+	manid = flash_id & 0xff;
+	devid = (flash_id >> 8) & 0xff;
+	devcfg = (flash_id >> 24) & 0xff;
+
+	for (n = 0;  !flashman && nand_manuf_ids[n].id; ++n)
+		if (nand_manuf_ids[n].id == manid)
+			flashman = &nand_manuf_ids[n];
+	for (n = 0; !flashdev && nand_flash_ids[n].id; ++n)
+		if (nand_flash_ids[n].id == devid)
+			flashdev = &nand_flash_ids[n];
+	if (!flashdev || !flashman) {
+		pr_err("ERROR: unknown nand device manuf=%x devid=%x\n",
+		       manid, devid);
+		return -ENOENT;
+	}
+
+	if (!flashdev->pagesize) {
+		mtd->erasesize = (64 * 1024) << ((devcfg >> 4) & 0x3);
+		mtd->writesize = 1024 << (devcfg & 0x3);
+		mtd->oobsize = (8 << ((devcfg >> 2) & 1)) *
+			(mtd->writesize / 512);
+		busw16 = devcfg & (1 << 6) ? CFG1_WIDE_FLASH : 0;
+	} else {
+		mtd->writesize = flashdev->pagesize;
+		mtd->erasesize = flashdev->erasesize;
+		mtd->oobsize = flashdev->pagesize / 32;
+		busw16 = flashdev->options & NAND_BUSWIDTH_16 ?
+			CFG1_WIDE_FLASH : 0;
+	}
+	mtd->size = flashdev->chipsize << 20;
+	pr_info("manuf %s (0x%x) device 0x%x blocksz %x pagesz %x "
+		"size %llx\n", flashman->name, flashman->id, flashdev->id,
+		mtd->erasesize, mtd->writesize, mtd->size);
+
+	if (mtd->writesize == 2048) {
+		chip->page_shift = 11;
+	} else if (mtd->writesize == 4096) {
+		chip->page_shift = 12;
+	} else {
+		pr_err("Unsupported page size (%d)\n", mtd->writesize);
+		return -EINVAL;
+	}
+
+	chip->last_sector = (mtd->writesize / 512) - 1;
+	chip->last_sectorsz = mtd->writesize - chip->last_sector * 516;
+
+	if (mtd->oobsize == 64) {
+		mtd->ecclayout = &msm_nand_oob_64;
+	} else if (mtd->oobsize == 128) {
+		mtd->ecclayout = &msm_nand_oob_128;
+	} else {
+		pr_err("Unsupported oob size (%d)\n", mtd->oobsize);
+		return -EINVAL;
+	}
+	mtd->oobavail = mtd->ecclayout->oobavail;
+
+	chip->cfg0 = (chip->last_sector << 6) /* codewords per page */
+		|  (516 <<  9)  /* 516 user data bytes */
+		|   (10 << 19)  /* 10 parity bytes */
+		|    (5 << 27)  /* 5 address cycles */
+		|    (1 << 30)  /* Read status before data */
+		|    (1 << 31)  /* Send read cmd */
+		/* 0 spare bytes for 16 bit nand or 1 spare bytes for 8 bit */
+		| ((busw16 & CFG1_WIDE_FLASH) ? (0 << 23) : (1 << 23));
+	chip->cfg1 = (0 <<  0)  /* Enable ecc */
+		|    (7 <<  2)  /* 8 recovery cycles */
+		|    (0 <<  5)  /* Allow CS deassertion */
+		|  ((mtd->writesize - (528 * chip->last_sector) + 1) <<  6)
+				/* Bad block marker location */
+		|    (0 << 16)  /* Bad block in user data area */
+		|    (2 << 17)  /* 6 cycle tWB/tRB */
+		| (busw16 & CFG1_WIDE_FLASH); /* preserve wide flag */
+
+	pr_info("Save cfg0 = %x cfg1 = %x\n", chip->cfg0, chip->cfg1);
+	pr_info("cfg0: cw/page=%d ud_sz=%d ecc_sz=%d spare_sz=%d "
+		"num_addr_cycles=%d\n", (chip->cfg0 >> 6) & 7,
+		(chip->cfg0 >> 9) & 0x3ff, (chip->cfg0 >> 19) & 15,
+		(chip->cfg0 >> 23) & 15, (chip->cfg0 >> 27) & 7);
+
+	n = flash_rd_reg(chip, MSM_NAND_DEV_CMD1);
+	pr_debug("DEV_CMD1: %x\n", n);
+
+	n = flash_rd_reg(chip, MSM_NAND_EBI2_ECC_BUF_CFG);
+	pr_info("NAND_EBI2_ECC_BUF_CFG: %x\n", n);
+
+	chip->ecc_buf_cfg = 0x203;
+
+	/* Fill in remaining MTD driver data */
+	mtd->type = MTD_NANDFLASH;
+	mtd->flags = MTD_CAP_NANDFLASH;
+	mtd->erase = msm_nand_erase;
+	mtd->point = NULL;
+	mtd->unpoint = NULL;
+	mtd->read = msm_nand_read;
+	mtd->write = msm_nand_write;
+	mtd->read_oob = msm_nand_read_oob;
+	mtd->write_oob = msm_nand_write_oob;
+	mtd->lock = NULL;
+	mtd->suspend = NULL;
+	mtd->resume = NULL;
+	mtd->block_isbad = msm_nand_block_isbad;
+	mtd->block_markbad = msm_nand_block_markbad;
+	mtd->owner = THIS_MODULE;
+
+	return 0;
+}
+
+/**
+ * msm_nand_release - [msm_nand Interface] Free resources held by the msm_nand device
+ * @mtd:    MTD device structure
+ */
+static void msm_nand_release(struct mtd_info *mtd)
+{
+
+#ifdef CONFIG_MTD_PARTITIONS
+	/* Deregister partitions */
+	del_mtd_partitions(mtd);
+#endif
+	/* Deregister the device */
+	del_mtd_device(mtd);
+}
+
+#ifdef CONFIG_MTD_PARTITIONS
+static const char const *part_probes[] = { "cmdlinepart", NULL,  };
+#endif
+
+static int __devinit msm_nand_probe(struct platform_device *pdev)
+{
+	struct msm_nand_info *info;
+	struct resource *res;
+	struct flash_platform_data const *pdata = pdev->dev.platform_data;
+	int err;
+	int i;
+
+	res = platform_get_resource_byname(pdev,
+					IORESOURCE_MEM, "msm_nand_phys");
+	if (!res || !res->start) {
+		pr_err("msm_nand_phys resource invalid/absent\n");
+		return -EINVAL;
+	}
+	msm_nand_phys = res->start;
+	pr_debug("phys addr 0x%lx\n", msm_nand_phys);
+
+	res = platform_get_resource_byname(pdev,
+					IORESOURCE_DMA, "msm_nand_dmac");
+	if (!res || !res->start) {
+		pr_err("Invalid msm_nand_dmac resource\n");
+		return -EINVAL;
+	}
+
+	info = kzalloc(sizeof(struct msm_nand_info), GFP_KERNEL);
+	if (!info) {
+		pr_err("No memory for msm_nand_info\n");
+		return -ENOMEM;
+	}
+
+	info->msm_nand.dev = &pdev->dev;
+
+	init_waitqueue_head(&info->msm_nand.wait_queue);
+
+	info->msm_nand.dma_channel = res->start;
+	pr_debug("dma channel 0x%x\n", info->msm_nand.dma_channel);
+
+	info->msm_nand.dma_buffer =
+		dma_alloc_coherent(&pdev->dev, MSM_NAND_DMA_BUFFER_SIZE,
+				   &info->msm_nand.dma_addr, GFP_KERNEL);
+	if (info->msm_nand.dma_buffer == NULL) {
+		err = -ENOMEM;
+		goto out_free_info;
+	}
+
+	pr_debug("allocated dma buffer at %p, dma_addr %x\n",
+		info->msm_nand.dma_buffer, info->msm_nand.dma_addr);
+
+	info->mtd.name = dev_name(&pdev->dev);
+	info->mtd.priv = &info->msm_nand;
+	info->mtd.owner = THIS_MODULE;
+
+	if (msm_nand_scan(&info->mtd, 1)) {
+		err = -ENXIO;
+		goto out_free_dma_buffer;
+	}
+
+#ifdef CONFIG_MTD_PARTITIONS
+	err = parse_mtd_partitions(&info->mtd, part_probes, &info->parts, 0);
+	if (err > 0)
+		err = add_mtd_partitions(&info->mtd, info->parts, err);
+	else if (err <= 0 && pdata && pdata->parts) {
+		for (i = 0; i < pdata->nr_parts; ++i) {
+			pdata->parts[i].offset *= info->mtd.erasesize;
+			pdata->parts[i].size *= info->mtd.erasesize;
+		}
+		err = add_mtd_partitions(&info->mtd, pdata->parts,
+					 pdata->nr_parts);
+	} else
+#endif
+		err = add_mtd_device(&info->mtd);
+	if (err != 0)
+		goto out_free_dma_buffer;
+
+	platform_set_drvdata(pdev, info);
+
+	return 0;
+
+out_free_dma_buffer:
+	dma_free_coherent(&pdev->dev, MSM_NAND_DMA_BUFFER_SIZE,
+			  info->msm_nand.dma_buffer, info->msm_nand.dma_addr);
+out_free_info:
+	kfree(info);
+
+	return err;
+}
+
+static int __devexit msm_nand_remove(struct platform_device *pdev)
+{
+	struct msm_nand_info *info = platform_get_drvdata(pdev);
+
+	platform_set_drvdata(pdev, NULL);
+
+#ifdef CONFIG_MTD_PARTITIONS
+	if (info->parts)
+		del_mtd_partitions(&info->mtd);
+	else
+#endif
+		del_mtd_device(&info->mtd);
+
+	msm_nand_release(&info->mtd);
+	dma_free_coherent(&pdev->dev, MSM_NAND_DMA_BUFFER_SIZE,
+			  info->msm_nand.dma_buffer, info->msm_nand.dma_addr);
+	kfree(info);
+
+	return 0;
+}
+
+static struct platform_driver msm_nand_driver = {
+	.probe		= msm_nand_probe,
+	.remove		= __devexit_p(msm_nand_remove),
+	.driver = {
+		.name	= "msm_nand",
+		.owner	= THIS_MODULE,
+	}
+};
+
+static int __init msm_nand_init(void)
+{
+	return platform_driver_register(&msm_nand_driver);
+}
+module_init(msm_nand_init);
+
+static void __exit msm_nand_exit(void)
+{
+	platform_driver_unregister(&msm_nand_driver);
+}
+module_exit(msm_nand_exit);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("msm_nand flash driver code");
+MODULE_ALIAS("platform:msm_nand");
diff --git a/drivers/mtd/devices/msm_nand.h b/drivers/mtd/devices/msm_nand.h
new file mode 100644
index 0000000..88aec30
--- /dev/null
+++ b/drivers/mtd/devices/msm_nand.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2011 Code Aurora Forum. All rights reserved.
+ * Copyright (C) 2007 Google, Inc.
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, and
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __DRIVERS_MTD_DEVICES_MSM_NAND_H
+#define __DRIVERS_MTD_DEVICES_MSM_NAND_H
+
+extern unsigned long msm_nand_phys;
+#define MSM_NAND_REG(off) (msm_nand_phys + (off))
+
+#define MSM_NAND_FLASH_CMD            MSM_NAND_REG(0x0000)
+#define MSM_NAND_ADDR0                MSM_NAND_REG(0x0004)
+#define MSM_NAND_ADDR1                MSM_NAND_REG(0x0008)
+#define MSM_NAND_FLASH_CHIP_SELECT    MSM_NAND_REG(0x000C)
+#define MSM_NAND_EXEC_CMD             MSM_NAND_REG(0x0010)
+#define MSM_NAND_FLASH_STATUS         MSM_NAND_REG(0x0014)
+#define MSM_NAND_BUFFER_STATUS        MSM_NAND_REG(0x0018)
+#define MSM_NAND_DEV0_CFG0            MSM_NAND_REG(0x0020)
+#define MSM_NAND_DEV0_CFG1            MSM_NAND_REG(0x0024)
+#define MSM_NAND_DEV1_CFG0            MSM_NAND_REG(0x0030)
+#define MSM_NAND_DEV1_CFG1            MSM_NAND_REG(0x0034)
+#define MSM_NAND_READ_ID              MSM_NAND_REG(0x0040)
+#define MSM_NAND_READ_STATUS          MSM_NAND_REG(0x0044)
+#define MSM_NAND_CONFIG_DATA          MSM_NAND_REG(0x0050)
+#define MSM_NAND_CONFIG               MSM_NAND_REG(0x0054)
+#define MSM_NAND_CONFIG_MODE          MSM_NAND_REG(0x0058)
+#define MSM_NAND_CONFIG_STATUS        MSM_NAND_REG(0x0060)
+#define MSM_NAND_MACRO1_REG           MSM_NAND_REG(0x0064)
+#define MSM_NAND_XFR_STEP1            MSM_NAND_REG(0x0070)
+#define MSM_NAND_XFR_STEP2            MSM_NAND_REG(0x0074)
+#define MSM_NAND_XFR_STEP3            MSM_NAND_REG(0x0078)
+#define MSM_NAND_XFR_STEP4            MSM_NAND_REG(0x007C)
+#define MSM_NAND_XFR_STEP5            MSM_NAND_REG(0x0080)
+#define MSM_NAND_XFR_STEP6            MSM_NAND_REG(0x0084)
+#define MSM_NAND_XFR_STEP7            MSM_NAND_REG(0x0088)
+#define MSM_NAND_DEV_CMD0             MSM_NAND_REG(0x00A0)
+#define MSM_NAND_DEV_CMD1             MSM_NAND_REG(0x00A4)
+#define MSM_NAND_DEV_CMD2             MSM_NAND_REG(0x00A8)
+#define MSM_NAND_DEV_CMD_VLD          MSM_NAND_REG(0x00AC)
+#define MSM_NAND_EBI2_MISR_SIG_REG    MSM_NAND_REG(0x00B0)
+#define MSM_NAND_EBI2_ECC_BUF_CFG     MSM_NAND_REG(0x00F0)
+#define MSM_NAND_FLASH_BUFFER         MSM_NAND_REG(0x0100)
+
+/* device commands */
+#define MSM_NAND_CMD_SOFT_RESET         0x01
+#define MSM_NAND_CMD_PAGE_READ          0x32
+#define MSM_NAND_CMD_PAGE_READ_ECC      0x33
+#define MSM_NAND_CMD_PAGE_READ_ALL      0x34
+#define MSM_NAND_CMD_SEQ_PAGE_READ      0x15
+#define MSM_NAND_CMD_PRG_PAGE           0x36
+#define MSM_NAND_CMD_PRG_PAGE_ECC       0x37
+#define MSM_NAND_CMD_PRG_PAGE_ALL       0x39
+#define MSM_NAND_CMD_BLOCK_ERASE        0x3A
+#define MSM_NAND_CMD_FETCH_ID           0x0B
+
+#define MSM_NAND_STATS_INIT	    0xeeeeeeee
+#define DM_ENABLE		    (1 << 2)
+#define NAND_DEV_SEL_CS0	    (0 << 0)
+
+#define CFG1_WIDE_FLASH		    (1U << 1)
+#define MSM_NAND_CFG0_RAW	    0xA80420C0
+#define MSM_NAND_CFG1_RAW	    0x5045D
+#define BUF_STAT_UNCORRECTABLE	    (1U << 3)
+#define BUF_STAT_NUM_ERRS_MASK	    (0x7)
+
+#endif
-- 
1.7.1.1

--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

