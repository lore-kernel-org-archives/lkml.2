Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0LFPxP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 10:53:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59160 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab0LFPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 10:53:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EduqWdCcUHoWBieozU9pkWqJzEenW4nUOARF5K8/Qe5m7a1aXznD0eRmP9o3jL5CAR
         /zDKt+bLlfZajwXblCYzbWx1Zmqo89pXytFMQ15dc/PTV6ifc0exS+eoaMgD08tNQ+Gu
         g8/N3ut8DfRO4svfL6t2dUcWVt08xNaLfvvZY=
MIME-Version: 1.0
Date: Mon, 6 Dec 2010 15:53:10 +0000
Message-ID: <AANLkTi=0RtvsGX+Q3goL3mdG6oKeNidYtiudTZ8ZTpRP@mail.gmail.com>
Subject: [RESEND PATCH] dw_mmc: Add Synopsys DesignWare mmc host driver.
From: Will Newton <will.newton@gmail.com>
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Content-Type: multipart/mixed; boundary=00163649a3e386a83c0496bfe248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00163649a3e386a83c0496bfe248
Content-Type: text/plain; charset=ISO-8859-1

This adds the mmc host driver for the Synopsys DesignWare mmc
host controller, found in a number of embedded SoC designs.

Signed-off-by: Will Newton <will.newton@imgtec.com>
---
 drivers/mmc/host/Kconfig   |   15 +
 drivers/mmc/host/Makefile  |    1 +
 drivers/mmc/host/dw_mmc.c  | 1810 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/dw_mmc.h  |  155 ++++
 include/linux/mmc/dw_mmc.h |  149 ++++
 5 files changed, 2130 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mmc/host/dw_mmc.c
 create mode 100644 drivers/mmc/host/dw_mmc.h
 create mode 100644 include/linux/mmc/dw_mmc.h

Resending, hopefully this time the patch will make it to the linux-mmc list.

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index f8fa9ef..c99d2c6 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -469,6 +469,21 @@ config SDH_BFIN_MISSING_CMD_PULLUP_WORKAROUND
 	help
 	  If you say yes here SD-Cards may work on the EZkit.

+config MMC_DW
+	tristate "Synopsys DesignWare Memory Card Interface"
+	help
+	  This selects support for the Synopsys DesignWare Mobile Storage IP
+	  block, this provides host support for SD and MMC interfaces, in both
+	  PIO and external DMA modes.
+
+config MMC_DW_IDMAC
+	depends on MMC_DW
+	bool "Internal DMAC interface"
+	help
+	  This selects support for the internal DMAC block within the Synopsys
+	  Designware Mobile Storage IP block. This disables the external DMA
+	  interface.
+
 config MMC_SH_MMCIF
 	tristate "SuperH Internal MMCIF support"
 	depends on MMC_BLOCK && (SUPERH || ARCH_SHMOBILE)
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index d91364d..a5d1cb2 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_MMC_TMIO)		+= tmio_mmc.o
 obj-$(CONFIG_MMC_CB710)	+= cb710-mmc.o
 obj-$(CONFIG_MMC_VIA_SDMMC)	+= via-sdmmc.o
 obj-$(CONFIG_SDH_BFIN)		+= bfin_sdh.o
+obj-$(CONFIG_MMC_DW)		+= dw_mmc.o
 obj-$(CONFIG_MMC_SH_MMCIF)	+= sh_mmcif.o
 obj-$(CONFIG_MMC_JZ4740)	+= jz4740_mmc.o
 obj-$(CONFIG_MMC_USHC)		+= ushc.o
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
new file mode 100644
index 0000000..fa90b44
--- /dev/null
+++ b/drivers/mmc/host/dw_mmc.c
@@ -0,0 +1,1810 @@
+/*
+ * Synopsys DesignWare Multimedia Card Interface driver
+ *  (Based on NXP driver for lpc 31xx)
+ *
+ * Copyright (C) 2009 NXP Semiconductors
+ * Copyright (C) 2009, 2010 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <linux/blkdev.h>
+#include <linux/clk.h>
+#include <linux/debugfs.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/ioport.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/scatterlist.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/stat.h>
+#include <linux/delay.h>
+#include <linux/irq.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/dw_mmc.h>
+#include <linux/bitops.h>
+
+#include "dw_mmc.h"
+
+/* Common flag combinations */
+#define DW_MCI_DATA_ERROR_FLAGS	(SDMMC_INT_DTO | SDMMC_INT_DCRC | \
+				 SDMMC_INT_HTO | SDMMC_INT_SBE  | \
+				 SDMMC_INT_EBE)
+#define DW_MCI_CMD_ERROR_FLAGS	(SDMMC_INT_RTO | SDMMC_INT_RCRC | \
+				 SDMMC_INT_RESP_ERR)
+#define DW_MCI_ERROR_FLAGS	(DW_MCI_DATA_ERROR_FLAGS | \
+				 DW_MCI_CMD_ERROR_FLAGS  | SDMMC_INT_HLE)
+#define DW_MCI_SEND_STATUS	1
+#define DW_MCI_RECV_STATUS	2
+#define DW_MCI_DMA_THRESHOLD	16
+
+#ifdef CONFIG_MMC_DW_IDMAC
+struct idmac_desc {
+	u32		des0;	/* Control Descriptor */
+#define IDMAC_DES0_DIC	BIT(1)
+#define IDMAC_DES0_LD	BIT(2)
+#define IDMAC_DES0_FD	BIT(3)
+#define IDMAC_DES0_CH	BIT(4)
+#define IDMAC_DES0_ER	BIT(5)
+#define IDMAC_DES0_CES	BIT(30)
+#define IDMAC_DES0_OWN	BIT(31)
+
+	u32		des1;	/* Buffer sizes */
+#define IDMAC_SET_BUFFER1_SIZE(d, s) \
+	((d)->des1 = ((d)->des1 & 0x03ffc000) | ((s) & 0x3fff))
+
+	u32		des2;	/* buffer 1 physical address */
+
+	u32		des3;	/* buffer 2 physical address */
+};
+#endif /* CONFIG_MMC_DW_IDMAC */
+
+struct dw_mci_slot {
+	struct mmc_host		*mmc;
+	struct dw_mci		*host;
+
+	u32			ctype;
+
+	struct mmc_request	*mrq;
+	struct list_head	queue_node;
+
+	unsigned int		clock;
+	unsigned long		flags;
+#define DW_MMC_CARD_PRESENT	0
+#define DW_MMC_CARD_NEED_INIT	1
+	int			id;
+	int			last_detect_state;
+};
+
+#if defined(CONFIG_DEBUG_FS)
+/*
+ * The debugfs stuff below is mostly optimized away when
+ * CONFIG_DEBUG_FS is not set.
+ */
+static int dw_mci_req_show(struct seq_file *s, void *v)
+{
+	struct dw_mci_slot *slot = s->private;
+	struct mmc_request *mrq;
+	struct mmc_command *cmd;
+	struct mmc_command *stop;
+	struct mmc_data	*data;
+
+	/* Make sure we get a consistent snapshot */
+	spin_lock_bh(&slot->host->lock);
+	mrq = slot->mrq;
+
+	if (mrq) {
+		cmd = mrq->cmd;
+		data = mrq->data;
+		stop = mrq->stop;
+
+		if (cmd)
+			seq_printf(s,
+				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
+				cmd->opcode, cmd->arg, cmd->flags,
+				cmd->resp[0], cmd->resp[1], cmd->resp[2],
+				cmd->resp[2], cmd->error);
+		if (data)
+			seq_printf(s, "DATA %u / %u * %u flg %x err %d\n",
+				data->bytes_xfered, data->blocks,
+				data->blksz, data->flags, data->error);
+		if (stop)
+			seq_printf(s,
+				"CMD%u(0x%x) flg %x rsp %x %x %x %x err %d\n",
+				stop->opcode, stop->arg, stop->flags,
+				stop->resp[0], stop->resp[1], stop->resp[2],
+				stop->resp[2], stop->error);
+	}
+
+	spin_unlock_bh(&slot->host->lock);
+
+	return 0;
+}
+
+static int dw_mci_req_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dw_mci_req_show, inode->i_private);
+}
+
+static const struct file_operations dw_mci_req_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dw_mci_req_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static int dw_mci_regs_show(struct seq_file *s, void *v)
+{
+	seq_printf(s, "STATUS:\t0x%08x\n", SDMMC_STATUS);
+	seq_printf(s, "RINTSTS:\t0x%08x\n", SDMMC_RINTSTS);
+	seq_printf(s, "CMD:\t0x%08x\n", SDMMC_CMD);
+	seq_printf(s, "CTRL:\t0x%08x\n", SDMMC_CTRL);
+	seq_printf(s, "INTMASK:\t0x%08x\n", SDMMC_INTMASK);
+	seq_printf(s, "CLKENA:\t0x%08x\n", SDMMC_CLKENA);
+
+	return 0;
+}
+
+static int dw_mci_regs_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, dw_mci_regs_show, inode->i_private);
+}
+
+static const struct file_operations dw_mci_regs_fops = {
+	.owner		= THIS_MODULE,
+	.open		= dw_mci_regs_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+static void dw_mci_init_debugfs(struct dw_mci_slot *slot)
+{
+	struct mmc_host	*mmc = slot->mmc;
+	struct dw_mci *host = slot->host;
+	struct dentry *root;
+	struct dentry *node;
+
+	root = mmc->debugfs_root;
+	if (!root)
+		return;
+
+	node = debugfs_create_file("regs", S_IRUSR, root, host,
+			&dw_mci_regs_fops);
+	if (IS_ERR(node))
+		return;
+	if (!node)
+		goto err;
+
+	node = debugfs_create_file("req", S_IRUSR, root, slot,
+			&dw_mci_req_fops);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_u32("state", S_IRUSR, root, (u32 *)&host->state);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_x32("pending_events", S_IRUSR, root,
+				     (u32 *)&host->pending_events);
+	if (!node)
+		goto err;
+
+	node = debugfs_create_x32("completed_events", S_IRUSR, root,
+				     (u32 *)&host->completed_events);
+	if (!node)
+		goto err;
+
+	return;
+
+err:
+	dev_err(&mmc->class_dev, "failed to initialize debugfs for slot\n");
+}
+#endif /* defined(CONFIG_DEBUG_FS) */
+
+static void dw_mci_set_timeout(struct dw_mci *host)
+{
+	mci_writel(host, TMOUT, 0xffffffff); /* timeout (maximum) */
+}
+
+static u32 dw_mci_prepare_command(struct mmc_host *mmc,
+				  struct mmc_command *cmd)
+{
+	struct mmc_data	*data;
+	u32 cmdr;
+	cmd->error = -EINPROGRESS;
+
+	cmdr = cmd->opcode;
+
+	if (cmdr == MMC_STOP_TRANSMISSION)
+		cmdr |= SDMMC_CMD_STOP;
+	else
+		cmdr |= SDMMC_CMD_PRV_DAT_WAIT;
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		cmdr |= SDMMC_CMD_RESP_EXP;
+		/* expect the respond, need to set this bit */
+		if (cmd->flags & MMC_RSP_136)
+			cmdr |= SDMMC_CMD_RESP_LONG; /* expect long respond */
+	}
+
+	if (cmd->flags & MMC_RSP_CRC)
+		cmdr |= SDMMC_CMD_RESP_CRC;
+
+	data = cmd->data;
+	if (data) {
+		cmdr |= SDMMC_CMD_DAT_EXP;
+		if (data->flags & MMC_DATA_STREAM)
+			cmdr |= SDMMC_CMD_STRM_MODE; /*  set stream mode */
+		if (data->flags & MMC_DATA_WRITE)
+			cmdr |= SDMMC_CMD_DAT_WR;
+	}
+
+	return cmdr;
+}
+
+static void dw_mci_start_command(struct dw_mci *host,
+				 struct mmc_command *cmd, u32 cmd_flags)
+{
+	host->cmd = cmd;
+	dev_vdbg(&host->pdev->dev,
+			"start command: ARGR=0x%08x CMDR=0x%08x\n",
+			cmd->arg, cmd_flags);
+
+	/* write to CMDARG register */
+	mci_writel(host, CMDARG, cmd->arg);
+	wmb();
+
+	/* write to CMD register */
+	mci_writel(host, CMD, cmd_flags | SDMMC_CMD_START);
+}
+
+static void send_stop_cmd(struct dw_mci *host, struct mmc_data *data)
+{
+	dw_mci_start_command(host, data->stop, host->stop_cmdr);
+}
+
+/* DMA interface functions */
+static void dw_mci_stop_dma(struct dw_mci *host)
+{
+	if (host->use_dma) {
+		host->dma_ops->stop(host);
+		host->dma_ops->cleanup(host);
+
+	} else {
+		/* Data transfer was stopped by the interrupt handler */
+		set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
+	}
+}
+
+#ifdef CONFIG_MMC_DW_IDMAC
+static void dw_mci_dma_cleanup(struct dw_mci *host)
+{
+	struct mmc_data *data = host->data;
+
+	if (data)
+		dma_unmap_sg(&host->pdev->dev, data->sg, data->sg_len,
+		     ((data->flags & MMC_DATA_WRITE)
+		      ? DMA_TO_DEVICE : DMA_FROM_DEVICE));
+}
+
+static void dw_mci_idmac_stop_dma(struct dw_mci *host)
+{
+	u32 temp;
+
+	/* Disable and reset the IDMAC interface */
+	temp = mci_readl(host, CTRL);
+	temp &= ~SDMMC_CTRL_USE_IDMAC;
+	temp |= SDMMC_CTRL_DMA_RESET;
+	mci_writel(host, CTRL, temp);
+
+	/* Stop the IDMAC running */
+	temp = mci_readl(host, BMOD);
+	temp &= ~SDMMC_IDMAC_ENABLE;
+	mci_writel(host, BMOD, temp);
+}
+
+static void dw_mci_idmac_complete_dma(struct dw_mci *host)
+{
+	struct mmc_data *data = host->data;
+
+	dev_vdbg(&host->pdev->dev, "DMA complete\n");
+
+	host->dma_ops->cleanup(host);
+
+	/*
+	 * If the card was removed, data will be NULL. No point in trying to
+	 * send the stop command or waiting for NBUSY in this case.
+	 */
+	if (data) {
+		set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
+		tasklet_schedule(&host->tasklet);
+	}
+}
+
+static void dw_mci_translate_sglist(struct dw_mci *host,
+				    struct mmc_data *data, unsigned int sg_len)
+{
+	int i;
+	struct idmac_desc *desc = host->sg_cpu;
+
+	for (i = 0; i < sg_len; i++, desc++) {
+		unsigned int length = sg_dma_len(&data->sg[i]);
+		u32 mem_addr = sg_dma_address(&data->sg[i]);
+
+		/* Set the OWN bit and disable interrupts for this descriptor */
+		desc->des0 = IDMAC_DES0_OWN | IDMAC_DES0_DIC | IDMAC_DES0_CH;
+
+		/* Buffer length */
+		IDMAC_SET_BUFFER1_SIZE(desc, length);
+
+		/* Physical address to DMA to/from */
+		desc->des2 = mem_addr;
+	}
+
+	/* Set first descriptor */
+	desc = host->sg_cpu;
+	desc->des0 |= IDMAC_DES0_FD;
+
+	/* Set last descriptor */
+	desc = host->sg_cpu + (i - 1) * sizeof(struct idmac_desc);
+	desc->des0 &= ~(IDMAC_DES0_CH | IDMAC_DES0_DIC);
+	desc->des0 |= IDMAC_DES0_LD;
+
+	wmb();
+}
+
+static void dw_mci_idmac_start_dma(struct dw_mci *host, unsigned int sg_len)
+{
+	u32 temp;
+
+	dw_mci_translate_sglist(host, host->data, sg_len);
+
+	/* Select IDMAC interface */
+	temp = mci_readl(host, CTRL);
+	temp |= SDMMC_CTRL_USE_IDMAC;
+	mci_writel(host, CTRL, temp);
+
+	wmb();
+
+	/* Enable the IDMAC */
+	temp = mci_readl(host, BMOD);
+	temp |= SDMMC_IDMAC_ENABLE;
+	mci_writel(host, BMOD, temp);
+
+	/* Start it running */
+	mci_writel(host, PLDMND, 1);
+}
+
+static int dw_mci_idmac_init(struct dw_mci *host)
+{
+	struct idmac_desc *p;
+	int i;
+
+	/* Number of descriptors in the ring buffer */
+	host->ring_size = PAGE_SIZE / sizeof(struct idmac_desc);
+
+	/* Forward link the descriptor list */
+	for (i = 0, p = host->sg_cpu; i < host->ring_size - 1; i++, p++)
+		p->des3 = host->sg_dma + (sizeof(struct idmac_desc) * (i + 1));
+
+	/* Set the last descriptor as the end-of-ring descriptor */
+	p->des3 = host->sg_dma;
+	p->des0 = IDMAC_DES0_ER;
+
+	/* Mask out interrupts - get Tx & Rx complete only */
+	mci_writel(host, IDINTEN, SDMMC_IDMAC_INT_NI | SDMMC_IDMAC_INT_RI |
+			SDMMC_IDMAC_INT_TI);
+
+	/* Set the descriptor base address */
+	mci_writel(host, DBADDR, host->sg_dma);
+	return 0;
+}
+
+static struct dw_mci_dma_ops dw_mci_idmac_ops = {
+	.init = dw_mci_idmac_init,
+	.start = dw_mci_idmac_start_dma,
+	.stop = dw_mci_idmac_stop_dma,
+	.complete = dw_mci_idmac_complete_dma,
+	.cleanup = dw_mci_dma_cleanup,
+};
+#endif /* CONFIG_MMC_DW_IDMAC */
+
+static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
+{
+	struct scatterlist *sg;
+	unsigned int i, direction, sg_len;
+	u32 temp;
+
+	/* If we don't have a channel, we can't do DMA */
+	if (!host->use_dma)
+		return -ENODEV;
+
+	/*
+	 * We don't do DMA on "complex" transfers, i.e. with
+	 * non-word-aligned buffers or lengths. Also, we don't bother
+	 * with all the DMA setup overhead for short transfers.
+	 */
+	if (data->blocks * data->blksz < DW_MCI_DMA_THRESHOLD)
+		return -EINVAL;
+	if (data->blksz & 3)
+		return -EINVAL;
+
+	for_each_sg(data->sg, sg, data->sg_len, i) {
+		if (sg->offset & 3 || sg->length & 3)
+			return -EINVAL;
+	}
+
+	if (data->flags & MMC_DATA_READ)
+		direction = DMA_FROM_DEVICE;
+	else
+		direction = DMA_TO_DEVICE;
+
+	sg_len = dma_map_sg(&host->pdev->dev, data->sg, data->sg_len,
+				   direction);
+
+	dev_vdbg(&host->pdev->dev,
+		"sd sg_cpu: %#lx sg_dma: %#lx sg_len: %d\n",
+		(unsigned long)host->sg_cpu, (unsigned long)host->sg_dma,
+		 sg_len);
+
+	/* Enable the DMA interface */
+	temp = mci_readl(host, CTRL);
+	temp |= SDMMC_CTRL_DMA_ENABLE;
+	mci_writel(host, CTRL, temp);
+
+	/* disable irq of RX & TX, let DMA handle it */
+	temp = mci_readl(host, INTMASK);
+	temp  &= ~(SDMMC_INT_RXDR | SDMMC_INT_TXDR);
+	mci_writel(host, INTMASK, temp);
+
+	host->dma_ops->start(host, sg_len);
+
+	return 0;
+}
+
+static void dw_mci_submit_data(struct dw_mci *host, struct mmc_data *data)
+{
+	u32 temp;
+
+	data->error = -EINPROGRESS;
+
+	WARN_ON(host->data);
+	host->sg = NULL;
+	host->data = data;
+
+	if (dw_mci_submit_data_dma(host, data)) {
+		host->sg = data->sg;
+		host->pio_offset = 0;
+		if (data->flags & MMC_DATA_READ)
+			host->dir_status = DW_MCI_RECV_STATUS;
+		else
+			host->dir_status = DW_MCI_SEND_STATUS;
+
+		temp = mci_readl(host, INTMASK);
+		temp |= SDMMC_INT_TXDR | SDMMC_INT_RXDR;
+		mci_writel(host, INTMASK, temp);
+
+		temp = mci_readl(host, CTRL);
+		temp &= ~SDMMC_CTRL_DMA_ENABLE;
+		mci_writel(host, CTRL, temp);
+	}
+}
+
+static void mci_send_cmd(struct dw_mci_slot *slot, u32 cmd, u32 arg)
+{
+	struct dw_mci *host = slot->host;
+	unsigned long timeout = jiffies + msecs_to_jiffies(500);
+	unsigned int cmd_status = 0;
+
+	mci_writel(host, CMDARG, arg);
+	wmb();
+	mci_writel(host, CMD, SDMMC_CMD_START | cmd);
+
+	while (time_before(jiffies, timeout)) {
+		cmd_status = mci_readl(host, CMD);
+		if (!(cmd_status & SDMMC_CMD_START))
+			return;
+	}
+	dev_err(&slot->mmc->class_dev,
+		"Timeout sending command (cmd %#x arg %#x status %#x)\n",
+		cmd, arg, cmd_status);
+}
+
+static void dw_mci_setup_bus(struct dw_mci_slot *slot)
+{
+	struct dw_mci *host = slot->host;
+	u32 div;
+
+	if (slot->clock != host->current_speed) {
+		if (host->bus_hz % slot->clock)
+			/*
+			 * move the + 1 after the dvide
+			 * to prevent over-clocking the card.
+			 */
+			div = ((host->bus_hz / slot->clock) >> 1) + 1;
+		else
+			div = (host->bus_hz  / slot->clock) >> 1;
+
+		dev_info(&slot->mmc->class_dev,
+			"Bus speed (slot %d) = %dHz (slot req %dHz, actual %dHZ"
+			" div = %d)\n",
+			slot->id, host->bus_hz, slot->clock,
+			div ? ((host->bus_hz / div) >> 1) : host->bus_hz, div);
+
+		/* disable clock */
+		mci_writel(host, CLKENA, 0);
+		mci_writel(host, CLKSRC, 0);
+
+		/* inform CIU */
+		mci_send_cmd(slot,
+			SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
+
+		/* set clock to desired speed */
+		mci_writel(host, CLKDIV, div);
+
+		/* inform CIU */
+		mci_send_cmd(slot,
+			SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
+
+		/* enable clock */
+		mci_writel(host, CLKENA, SDMMC_CLKEN_ENABLE);
+
+		/* inform CIU */
+		mci_send_cmd(slot,
+			SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
+
+		host->current_speed = slot->clock;
+	}
+
+	/* Set the current slot bus width */
+	mci_writel(host, CTYPE, slot->ctype);
+}
+
+static void dw_mci_start_request(struct dw_mci *host,
+				 struct dw_mci_slot *slot)
+{
+	struct mmc_request *mrq;
+	struct mmc_command *cmd;
+	struct mmc_data	*data;
+	u32 cmdflags;
+
+	mrq = slot->mrq;
+	/* no select the proper slot */
+	if (host->pdata->select_slot)
+		host->pdata->select_slot(slot->id);
+
+	/* Slot specific timing and width adjustment */
+	dw_mci_setup_bus(slot);
+
+	host->cur_slot = slot;
+	host->mrq = mrq;
+
+	host->pending_events = 0;
+	host->completed_events = 0;
+	host->data_status = 0;
+
+	data = mrq->data;
+	if (data) {
+		dw_mci_set_timeout(host);
+		mci_writel(host, BYTCNT, data->blksz*data->blocks);
+		mci_writel(host, BLKSIZ, data->blksz);
+	}
+
+	cmd = mrq->cmd;
+	cmdflags = dw_mci_prepare_command(slot->mmc, cmd);
+
+	/* this is the first command, lets send the initialization clock */
+	if (unlikely(
+		test_and_clear_bit(DW_MMC_CARD_NEED_INIT, &slot->flags))) {
+		cmdflags |= SDMMC_CMD_INIT;
+	}
+
+	/* we may need to move this code to mci_start_command */
+	if (data) {
+		dw_mci_submit_data(host, data);
+		wmb();
+	}
+
+	dw_mci_start_command(host, cmd, cmdflags);
+
+	if (mrq->stop)
+		host->stop_cmdr = dw_mci_prepare_command(slot->mmc, mrq->stop);
+}
+
+static void dw_mci_queue_request(struct dw_mci *host, struct dw_mci_slot *slot,
+				 struct mmc_request *mrq)
+{
+	dev_vdbg(&slot->mmc->class_dev, "queue request: state=%d\n",
+			host->state);
+
+	spin_lock_bh(&host->lock);
+	slot->mrq = mrq;
+
+	if (host->state == STATE_IDLE) {
+		host->state = STATE_SENDING_CMD;
+		dw_mci_start_request(host, slot);
+	} else {
+		list_add_tail(&slot->queue_node, &host->queue);
+	}
+
+	spin_unlock_bh(&host->lock);
+}
+
+static void dw_mci_request(struct mmc_host *mmc, struct mmc_request *mrq)
+{
+	struct dw_mci_slot *slot = mmc_priv(mmc);
+	struct dw_mci *host = slot->host;
+
+	WARN_ON(slot->mrq);
+
+	if (!test_bit(DW_MMC_CARD_PRESENT, &slot->flags)) {
+		mrq->cmd->error = -ENOMEDIUM;
+		mmc_request_done(mmc, mrq);
+		return;
+	}
+
+	/* We don't support multiple blocks of weird lengths. */
+	dw_mci_queue_request(host, slot, mrq);
+}
+
+static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct dw_mci_slot *slot = mmc_priv(mmc);
+
+	/* set default 1 bit mode */
+	slot->ctype = SDMMC_CTYPE_1BIT;
+
+	switch (ios->bus_width) {
+	case MMC_BUS_WIDTH_1:
+		slot->ctype = SDMMC_CTYPE_1BIT;
+		break;
+	case MMC_BUS_WIDTH_4:
+		slot->ctype = SDMMC_CTYPE_4BIT;
+		break;
+	}
+
+	if (ios->clock) {
+		/*
+		 * Use mirror of ios->clock to prevent race with mmc
+		 * core ios update when finding the minimum.
+		 */
+		slot->clock = ios->clock;
+	}
+
+	switch (ios->power_mode) {
+	case MMC_POWER_UP:
+		set_bit(DW_MMC_CARD_NEED_INIT, &slot->flags);
+		break;
+	default:
+		break;
+	}
+}
+
+static int dw_mci_get_ro(struct mmc_host *mmc)
+{
+	int read_only;
+	struct dw_mci_slot *slot = mmc_priv(mmc);
+	struct dw_mci_board *brd = slot->host->pdata;
+
+	if (brd->get_ro != NULL) {
+		read_only = brd->get_ro(slot->id);
+	} else {
+		/* Try on board write protect */
+		read_only =
+			mci_readl(slot->host, WRTPRT) & (1 << slot->id) ? 1 : 0;
+	}
+
+	dev_dbg(&mmc->class_dev, "card is %s\n",
+				read_only ? "read-only" : "read-write");
+
+	return read_only;
+}
+
+static int dw_mci_get_cd(struct mmc_host *mmc)
+{
+	int present;
+	struct dw_mci_slot *slot = mmc_priv(mmc);
+	struct dw_mci_board *brd = slot->host->pdata;
+
+	if (brd->get_cd != NULL)
+		present = !brd->get_cd(slot->id);
+	else	/* try onboard card detect */
+		present = (mci_readl(slot->host, CDETECT) & (1 << slot->id))
+				== 0 ? 1 : 0;
+
+	dev_dbg(&mmc->class_dev, "card is %spresent\n", present ? "" : "not ");
+
+	return present;
+}
+
+static const struct mmc_host_ops dw_mci_ops = {
+	.request	= dw_mci_request,
+	.set_ios	= dw_mci_set_ios,
+	.get_ro		= dw_mci_get_ro,
+	.get_cd		= dw_mci_get_cd,
+};
+
+static void dw_mci_request_end(struct dw_mci *host, struct mmc_request *mrq)
+	__releases(&host->lock)
+	__acquires(&host->lock)
+{
+	struct dw_mci_slot *slot;
+	struct mmc_host	*prev_mmc = host->cur_slot->mmc;
+
+	WARN_ON(host->cmd || host->data);
+
+	host->cur_slot->mrq = NULL;
+	host->mrq = NULL;
+	if (!list_empty(&host->queue)) {
+		slot = list_entry(host->queue.next,
+				struct dw_mci_slot, queue_node);
+		list_del(&slot->queue_node);
+		dev_vdbg(&host->pdev->dev, "list not empty: %s is next\n",
+				mmc_hostname(slot->mmc));
+		host->state = STATE_SENDING_CMD;
+		dw_mci_start_request(host, slot);
+	} else {
+		dev_vdbg(&host->pdev->dev, "list empty\n");
+		host->state = STATE_IDLE;
+	}
+
+	spin_unlock(&host->lock);
+	mmc_request_done(prev_mmc, mrq);
+
+	spin_lock(&host->lock);
+}
+
+static void dw_mci_command_complete(struct dw_mci *host,
+				    struct mmc_command *cmd)
+{
+	u32 status = host->cmd_status;
+
+	host->cmd_status = 0;
+
+	/* Read the response from the card (up to 16 bytes) */
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136) {
+			cmd->resp[3] = mci_readl(host, RESP0);
+			cmd->resp[2] = mci_readl(host, RESP1);
+			cmd->resp[1] = mci_readl(host, RESP2);
+			cmd->resp[0] = mci_readl(host, RESP3);
+		} else {
+			cmd->resp[0] = mci_readl(host, RESP0);
+			cmd->resp[1] = 0;
+			cmd->resp[2] = 0;
+			cmd->resp[3] = 0;
+		}
+	}
+
+	if (status & SDMMC_INT_RTO)
+		cmd->error = -ETIMEDOUT;
+	else if ((cmd->flags & MMC_RSP_CRC) && (status & SDMMC_INT_RCRC))
+		cmd->error = -EILSEQ;
+	else if (status & SDMMC_INT_RESP_ERR)
+		cmd->error = -EIO;
+	else
+		cmd->error = 0;
+
+	if (cmd->error) {
+		/* newer ip versions need a delay between retries */
+		if (host->quirks & DW_MCI_QUIRK_RETRY_DELAY)
+			mdelay(20);
+
+		if (cmd->data) {
+			host->data = NULL;
+			dw_mci_stop_dma(host);
+		}
+	}
+}
+
+static void dw_mci_tasklet_func(unsigned long priv)
+{
+	struct dw_mci *host = (struct dw_mci *)priv;
+	struct mmc_data	*data;
+	struct mmc_command *cmd;
+	enum dw_mci_state state;
+	enum dw_mci_state prev_state;
+	u32 status;
+
+	spin_lock(&host->lock);
+
+	state = host->state;
+	data = host->data;
+
+	do {
+		prev_state = state;
+
+		switch (state) {
+		case STATE_IDLE:
+			break;
+
+		case STATE_SENDING_CMD:
+			if (!test_and_clear_bit(EVENT_CMD_COMPLETE,
+						&host->pending_events))
+				break;
+
+			cmd = host->cmd;
+			host->cmd = NULL;
+			set_bit(EVENT_CMD_COMPLETE, &host->completed_events);
+			dw_mci_command_complete(host, host->mrq->cmd);
+			if (!host->mrq->data || cmd->error) {
+				dw_mci_request_end(host, host->mrq);
+				goto unlock;
+			}
+
+			prev_state = state = STATE_SENDING_DATA;
+			/* fall through */
+
+		case STATE_SENDING_DATA:
+			if (test_and_clear_bit(EVENT_DATA_ERROR,
+					       &host->pending_events)) {
+				dw_mci_stop_dma(host);
+				if (data->stop)
+					send_stop_cmd(host, data);
+				state = STATE_DATA_ERROR;
+				break;
+			}
+
+			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
+						&host->pending_events))
+				break;
+
+			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
+			prev_state = state = STATE_DATA_BUSY;
+			/* fall through */
+
+		case STATE_DATA_BUSY:
+			if (!test_and_clear_bit(EVENT_DATA_COMPLETE,
+						&host->pending_events))
+				break;
+
+			host->data = NULL;
+			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
+			status = host->data_status;
+
+			if (unlikely(status & DW_MCI_DATA_ERROR_FLAGS)) {
+				if (status & SDMMC_INT_DTO) {
+					dev_err(&host->pdev->dev,
+							"data timeout error\n");
+					data->error = -ETIMEDOUT;
+				} else if (status & SDMMC_INT_DCRC) {
+					dev_err(&host->pdev->dev,
+							"data CRC error\n");
+					data->error = -EILSEQ;
+				} else {
+					dev_err(&host->pdev->dev,
+						"data FIFO error "
+						"(status=%08x)\n",
+						status);
+					data->error = -EIO;
+				}
+			} else {
+				data->bytes_xfered = data->blocks * data->blksz;
+				data->error = 0;
+			}
+
+			if (!data->stop) {
+				dw_mci_request_end(host, host->mrq);
+				goto unlock;
+			}
+
+			prev_state = state = STATE_SENDING_STOP;
+			if (!data->error)
+				send_stop_cmd(host, data);
+			/* fall through */
+
+		case STATE_SENDING_STOP:
+			if (!test_and_clear_bit(EVENT_CMD_COMPLETE,
+						&host->pending_events))
+				break;
+
+			host->cmd = NULL;
+			dw_mci_command_complete(host, host->mrq->stop);
+			dw_mci_request_end(host, host->mrq);
+			goto unlock;
+
+		case STATE_DATA_ERROR:
+			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
+						&host->pending_events))
+				break;
+
+			state = STATE_DATA_BUSY;
+			break;
+		}
+	} while (state != prev_state);
+
+	host->state = state;
+unlock:
+	spin_unlock(&host->lock);
+
+}
+
+static void dw_mci_push_data16(struct dw_mci *host, void *buf, int cnt)
+{
+	u16 *pData = (u16 *)buf;
+
+	WARN_ON(cnt % 2 != 0);
+
+	cnt = cnt >> 1;
+	while (cnt > 0) {
+		mci_writew(host, DATA, *pData++);
+		cnt--;
+	}
+}
+
+static void dw_mci_pull_data16(struct dw_mci *host, void *buf, int cnt)
+{
+	u16 *pData = (u16 *)buf;
+
+	WARN_ON(cnt % 2 != 0);
+
+	cnt = cnt >> 1;
+	while (cnt > 0) {
+		*pData++ = mci_readw(host, DATA);
+		cnt--;
+	}
+}
+
+static void dw_mci_push_data32(struct dw_mci *host, void *buf, int cnt)
+{
+	u32 *pData = (u32 *)buf;
+
+	WARN_ON(cnt % 4 != 0);
+	WARN_ON((unsigned long)pData & 0x3);
+
+	cnt = cnt >> 2;
+	while (cnt > 0) {
+		mci_writel(host, DATA, *pData++);
+		cnt--;
+	}
+}
+
+static void dw_mci_pull_data32(struct dw_mci *host, void *buf, int cnt)
+{
+	u32 *pData = (u32 *)buf;
+
+	WARN_ON(cnt % 4 != 0);
+	WARN_ON((unsigned long)pData & 0x3);
+
+	cnt = cnt >> 2;
+	while (cnt > 0) {
+		*pData++ = mci_readl(host, DATA);
+		cnt--;
+	}
+}
+
+static void dw_mci_push_data64(struct dw_mci *host, void *buf, int cnt)
+{
+	u64 *pData = (u64 *)buf;
+
+	WARN_ON(cnt % 8 != 0);
+
+	cnt = cnt >> 3;
+	while (cnt > 0) {
+		mci_writeq(host, DATA, *pData++);
+		cnt--;
+	}
+}
+
+static void dw_mci_pull_data64(struct dw_mci *host, void *buf, int cnt)
+{
+	u64 *pData = (u64 *)buf;
+
+	WARN_ON(cnt % 8 != 0);
+
+	cnt = cnt >> 3;
+	while (cnt > 0) {
+		*pData++ = mci_readq(host, DATA);
+		cnt--;
+	}
+}
+
+static void dw_mci_read_data_pio(struct dw_mci *host)
+{
+	struct scatterlist *sg = host->sg;
+	void *buf = sg_virt(sg);
+	unsigned int offset = host->pio_offset;
+	struct mmc_data	*data = host->data;
+	int shift = host->data_shift;
+	u32 status;
+	unsigned int nbytes = 0, len, old_len, count = 0;
+
+	do {
+		len = SDMMC_GET_FCNT(mci_readl(host, STATUS)) << shift;
+		if (count == 0)
+			old_len = len;
+
+		if (likely(offset + len <= sg->length)) {
+			host->pull_data(host, (void *)(buf + offset), len);
+
+			offset += len;
+			nbytes += len;
+
+			if (offset == sg->length) {
+				flush_dcache_page(sg_page(sg));
+				host->sg = sg = sg_next(sg);
+				if (!sg)
+					goto done;
+
+				offset = 0;
+				buf = sg_virt(sg);
+			}
+		} else {
+			unsigned int remaining = sg->length - offset;
+			host->pull_data(host,
+				(void *)(buf + offset), remaining);
+			nbytes += remaining;
+
+			flush_dcache_page(sg_page(sg));
+			host->sg = sg = sg_next(sg);
+			if (!sg)
+				goto done;
+
+			offset = len - remaining;
+			buf = sg_virt(sg);
+			host->pull_data(host, buf, offset);
+			nbytes += offset;
+		}
+
+		status = mci_readl(host, MINTSTS);
+		mci_writel(host, RINTSTS, SDMMC_INT_RXDR);
+		if (status & DW_MCI_DATA_ERROR_FLAGS) {
+			host->data_status = status;
+			data->bytes_xfered += nbytes;
+			smp_wmb();
+
+			set_bit(EVENT_DATA_ERROR, &host->pending_events);
+
+			tasklet_schedule(&host->tasklet);
+			return;
+		}
+		count++;
+	} while (status & SDMMC_INT_RXDR); /*if the RXDR is ready
+						lets read again*/
+	len = SDMMC_GET_FCNT(mci_readl(host, STATUS));
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+	return;
+
+done:
+	data->bytes_xfered += nbytes;
+	smp_wmb();
+	set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
+}
+
+static void dw_mci_write_data_pio(struct dw_mci *host)
+{
+	struct scatterlist *sg = host->sg;
+	void *buf = sg_virt(sg);
+	unsigned int offset = host->pio_offset;
+	struct mmc_data	*data = host->data;
+	int shift = host->data_shift;
+	u32 status;
+	unsigned int nbytes = 0, len;
+
+	do {
+		len = SDMMC_FIFO_SZ -
+			(SDMMC_GET_FCNT(mci_readl(host, STATUS)) << shift);
+		if (likely(offset + len <= sg->length)) {
+			host->push_data(host, (void *)(buf + offset), len);
+
+			offset += len;
+			nbytes += len;
+			if (offset == sg->length) {
+				host->sg = sg = sg_next(sg);
+				if (!sg)
+					goto done;
+
+				offset = 0;
+				buf = sg_virt(sg);
+			}
+		} else {
+			unsigned int remaining = sg->length - offset;
+
+			host->push_data(host,
+				(void *)(buf + offset), remaining);
+			nbytes += remaining;
+
+			host->sg = sg = sg_next(sg);
+			if (!sg)
+				goto done;
+
+			offset = len - remaining;
+			buf = sg_virt(sg);
+			host->push_data(host, (void *)buf, offset);
+			nbytes += offset;
+		}
+
+		status = mci_readl(host, MINTSTS);
+		mci_writel(host, RINTSTS, SDMMC_INT_TXDR);
+		if (status & DW_MCI_DATA_ERROR_FLAGS) {
+			host->data_status = status;
+			data->bytes_xfered += nbytes;
+
+			smp_wmb();
+
+			set_bit(EVENT_DATA_ERROR, &host->pending_events);
+
+			tasklet_schedule(&host->tasklet);
+			return;
+		}
+	} while (status & SDMMC_INT_TXDR); /* if TXDR, lets write again */
+
+	host->pio_offset = offset;
+	data->bytes_xfered += nbytes;
+
+	return;
+
+done:
+	data->bytes_xfered += nbytes;
+	smp_wmb();
+	set_bit(EVENT_XFER_COMPLETE, &host->pending_events);
+}
+
+static void dw_mci_cmd_interrupt(struct dw_mci *host, u32 status)
+{
+	if (!host->cmd_status)
+		host->cmd_status = status;
+
+	smp_wmb();
+
+	set_bit(EVENT_CMD_COMPLETE, &host->pending_events);
+	tasklet_schedule(&host->tasklet);
+}
+
+static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
+{
+	struct dw_mci *host = dev_id;
+	u32 status,  pending;
+	unsigned int pass_count = 0;
+
+	do {
+		status = mci_readl(host, RINTSTS);
+		pending = mci_readl(host, MINTSTS);/* read only mask reg */
+
+		/*
+		 * DTO fix - version 2.10a and below, and only if internal DMA
+		 * is configured.
+		 */
+		if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO) {
+			if (!pending &&
+			    ((mci_readl(host, STATUS) >> 17) & 0x1fff))
+				pending |= SDMMC_INT_DATA_OVER;
+		}
+
+		if (!pending)
+			break;
+
+		if (pending & DW_MCI_CMD_ERROR_FLAGS) {
+			mci_writel(host, RINTSTS, DW_MCI_CMD_ERROR_FLAGS);
+			host->cmd_status = status;
+			smp_wmb();
+			set_bit(EVENT_CMD_COMPLETE, &host->pending_events);
+			tasklet_schedule(&host->tasklet);
+		}
+
+		if (pending & DW_MCI_DATA_ERROR_FLAGS) {
+			/* if there is an error, lets report DATA_ERROR */
+			mci_writel(host, RINTSTS, DW_MCI_DATA_ERROR_FLAGS);
+			host->data_status = status;
+			smp_wmb();
+			set_bit(EVENT_DATA_ERROR, &host->pending_events);
+			tasklet_schedule(&host->tasklet);
+		}
+
+
+		if (pending & SDMMC_INT_DATA_OVER) {
+			mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
+			if (!host->data_status)
+				host->data_status = status;
+			smp_wmb();
+			if (host->dir_status == DW_MCI_RECV_STATUS) {
+				if (host->sg != NULL)
+					dw_mci_read_data_pio(host);
+			}
+			set_bit(EVENT_DATA_COMPLETE, &host->pending_events);
+			tasklet_schedule(&host->tasklet);
+		}
+
+		if (pending & SDMMC_INT_RXDR) {
+			mci_writel(host, RINTSTS, SDMMC_INT_RXDR);
+			if (host->sg)
+				dw_mci_read_data_pio(host);
+		}
+
+		if (pending & SDMMC_INT_TXDR) {
+			mci_writel(host, RINTSTS, SDMMC_INT_TXDR);
+			if (host->sg)
+				dw_mci_write_data_pio(host);
+		}
+
+		if (pending & SDMMC_INT_CMD_DONE) {
+			mci_writel(host, RINTSTS, SDMMC_INT_CMD_DONE);
+			dw_mci_cmd_interrupt(host, status);
+		}
+
+		if (pending & SDMMC_INT_CD) {
+			mci_writel(host, RINTSTS, SDMMC_INT_CD);
+			tasklet_schedule(&host->card_tasklet);
+		}
+
+	} while (pass_count++ < 5);
+
+#ifdef CONFIG_MMC_DW_IDMAC
+	/* Handle DMA interrupts */
+	pending = mci_readl(host, IDSTS);
+	if (pending & (SDMMC_IDMAC_INT_TI | SDMMC_IDMAC_INT_RI)) {
+		mci_writel(host, IDSTS, SDMMC_IDMAC_INT_TI |
+				SDMMC_IDMAC_INT_RI);
+		mci_writel(host, IDSTS, SDMMC_IDMAC_INT_NI);
+		set_bit(EVENT_DATA_COMPLETE, &host->pending_events);
+		host->dma_ops->complete(host);
+	}
+#endif
+
+	return IRQ_HANDLED;
+}
+
+static void dw_mci_tasklet_card(unsigned long data)
+{
+	struct dw_mci *host = (struct dw_mci *)data;
+	int i;
+
+	for (i = 0; i < host->num_slots; i++) {
+		struct dw_mci_slot *slot = host->slot[i];
+		struct mmc_host *mmc = slot->mmc;
+		struct mmc_request *mrq;
+		int present;
+		u32 ctrl;
+
+		present = dw_mci_get_cd(mmc);
+		while (present != slot->last_detect_state) {
+			spin_lock(&host->lock);
+
+			dev_dbg(&slot->mmc->class_dev, "card %s\n",
+					present ? "inserted" : "removed");
+
+			/* Card change detected */
+			slot->last_detect_state = present;
+
+			/* Power up slot */
+			if (present != 0) {
+				if (host->pdata->setpower)
+					host->pdata->setpower(slot->id,
+						mmc->ocr_avail);
+
+				set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
+			}
+
+			/* Clean up queue if present */
+			mrq = slot->mrq;
+			if (mrq) {
+				if (mrq == host->mrq) {
+					host->data = NULL;
+					host->cmd = NULL;
+
+					switch (host->state) {
+					case STATE_IDLE:
+						break;
+					case STATE_SENDING_CMD:
+						mrq->cmd->error = -ENOMEDIUM;
+						if (!mrq->data)
+							break;
+						/* fall through */
+					case STATE_SENDING_DATA:
+						mrq->data->error = -ENOMEDIUM;
+						dw_mci_stop_dma(host);
+						break;
+					case STATE_DATA_BUSY:
+					case STATE_DATA_ERROR:
+						if (mrq->data->error == -EINPROGRESS)
+							mrq->data->error = -ENOMEDIUM;
+						if (!mrq->stop)
+							break;
+						/* fall through */
+					case STATE_SENDING_STOP:
+						mrq->stop->error = -ENOMEDIUM;
+						break;
+					}
+
+					dw_mci_request_end(host, mrq);
+				} else {
+					list_del(&slot->queue_node);
+					mrq->cmd->error = -ENOMEDIUM;
+					if (mrq->data)
+						mrq->data->error = -ENOMEDIUM;
+					if (mrq->stop)
+						mrq->stop->error = -ENOMEDIUM;
+
+					spin_unlock(&host->lock);
+					mmc_request_done(slot->mmc, mrq);
+					spin_lock(&host->lock);
+				}
+			}
+
+			/* Power down slot */
+			if (present == 0) {
+				if (host->pdata->setpower)
+					host->pdata->setpower(slot->id, 0);
+				clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
+
+				/*
+				 * Clear down the FIFO - doing so generates a
+				 * block interrupt, hence setting the
+				 * scatter-gather pointer to NULL.
+				 */
+				host->sg = NULL;
+
+				ctrl = mci_readl(host, CTRL);
+				ctrl |= SDMMC_CTRL_FIFO_RESET;
+				mci_writel(host, CTRL, ctrl);
+
+#ifdef CONFIG_MMC_DW_IDMAC
+				ctrl = mci_readl(host, BMOD);
+				ctrl |= 0x01;	/* Software reset of DMA */
+				mci_writel(host, BMOD, ctrl);
+#endif
+
+			}
+
+			spin_unlock(&host->lock);
+			present = dw_mci_get_cd(mmc);
+		}
+
+		mmc_detect_change(slot->mmc,
+			msecs_to_jiffies(host->pdata->detect_delay_ms));
+	}
+}
+
+static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
+{
+	struct mmc_host *mmc;
+	struct dw_mci_slot *slot;
+
+	mmc = mmc_alloc_host(sizeof(struct dw_mci_slot), &host->pdev->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	slot = mmc_priv(mmc);
+	slot->id = id;
+	slot->mmc = mmc;
+	slot->host = host;
+
+	mmc->ops = &dw_mci_ops;
+	mmc->f_min = DIV_ROUND_UP(host->bus_hz, 510);
+	mmc->f_max = host->bus_hz;
+
+	if (host->pdata->get_ocr)
+		mmc->ocr_avail = host->pdata->get_ocr(id);
+	else
+		mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+
+	/*
+	 * Start with slot power disabled,
+	 * will be enabled when card is detected
+	 */
+	if (host->pdata->setpower)
+		host->pdata->setpower(id, 0);
+
+	mmc->caps = 0;
+	if (host->pdata->get_bus_wd)
+		if (host->pdata->get_bus_wd(slot->id) >= 4)
+			mmc->caps |= MMC_CAP_4_BIT_DATA;
+
+	if (host->pdata->quirks & DW_MCI_QUIRK_HIGHSPEED)
+		mmc->caps |= MMC_CAP_SD_HIGHSPEED;
+
+#ifdef CONFIG_MMC_DW_IDMAC
+	mmc->max_segs = host->ring_size;
+	mmc->max_blk_size = 65536;
+	mmc->max_blk_count = host->ring_size;
+	mmc->max_seg_size = 0x1000;
+	mmc->max_req_size = mmc->max_seg_size * mmc->max_blk_count;
+#else
+	if (host->pdata->blk_settings) {
+		mmc->max_segs = host->pdata->blk_settings->max_segs;
+		mmc->max_blk_size = host->pdata->blk_settings->max_blk_size;
+		mmc->max_blk_count = host->pdata->blk_settings->max_blk_count;
+		mmc->max_req_size = host->pdata->blk_settings->max_req_size;
+		mmc->max_seg_size = host->pdata->blk_settings->max_seg_size;
+	} else {
+		/*useful defaults*/
+		mmc->max_segs = 64;
+		mmc->max_blk_size = 65536; /* BLKSIZ is 16 bits */
+		mmc->max_blk_count = 512;
+		mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
+		mmc->max_seg_size = mmc->max_req_size;
+	}
+#endif /* CONFIG_MMC_DW_IDMAC */
+
+	/* Assume card is present initially */
+	if (dw_mci_get_cd(mmc))
+		set_bit(DW_MMC_CARD_PRESENT, &slot->flags);
+	else
+		clear_bit(DW_MMC_CARD_PRESENT, &slot->flags);
+
+	host->slot[id] = slot;
+	mmc_add_host(mmc);
+
+#if defined(CONFIG_DEBUG_FS)
+	dw_mci_init_debugfs(slot);
+#endif
+
+	/* Card initially undetected */
+	slot->last_detect_state = 0;
+
+	return 0;
+}
+
+static void dw_mci_cleanup_slot(struct dw_mci_slot *slot,
+				unsigned int id)
+{
+	/* Shutdown detect IRQ */
+	if (slot->host->pdata->exit)
+		slot->host->pdata->exit(id);
+
+	/* Debugfs stuff is cleaned up by mmc core */
+	mmc_remove_host(slot->mmc);
+	slot->host->slot[id] = NULL;
+	mmc_free_host(slot->mmc);
+}
+
+static void dw_mci_init_dma(struct dw_mci *host)
+{
+	/* Alloc memory for sg translation */
+	host->sg_cpu = dma_alloc_coherent(&host->pdev->dev, PAGE_SIZE,
+			&host->sg_dma, GFP_KERNEL);
+	if (!host->sg_cpu) {
+		dev_err(&host->pdev->dev, "%s: could not alloc DMA memory\n",
+				__func__);
+		goto no_dma;
+	}
+
+	/* Determine which DMA interface to use */
+#ifdef CONFIG_MMC_DW_IDMAC
+	host->dma_ops = &dw_mci_idmac_ops;
+	dev_info(&host->pdev->dev, "Using internal DMA controller.\n");
+#endif
+
+	if (!host->dma_ops)
+		goto no_dma;
+
+	if (host->dma_ops->init) {
+		if (host->dma_ops->init(host)) {
+			dev_err(&host->pdev->dev, "%s: Unable to initialise "
+					"DMA Controller.\n", __func__);
+			goto no_dma;
+		}
+	} else {
+		dev_err(&host->pdev->dev, "DMA initialisation not found.\n");
+		goto no_dma;
+	}
+
+	host->use_dma = 1;
+	return;
+
+no_dma:
+	dev_info(&host->pdev->dev, "Using PIO mode.\n");
+	host->use_dma = 0;
+	return;
+}
+
+static bool mci_wait_reset(struct device *dev, struct dw_mci *host)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(500);
+	unsigned int ctrl;
+
+	mci_writel(host, CTRL, (SDMMC_CTRL_RESET |
+			SDMMC_CTRL_FIFO_RESET | SDMMC_CTRL_DMA_RESET));
+
+	/* wait till resets clear */
+	do {
+		ctrl = mci_readl(host, CTRL);
+		if (!(ctrl & (SDMMC_CTRL_RESET |
+			      SDMMC_CTRL_FIFO_RESET | SDMMC_CTRL_DMA_RESET)))
+			return true;
+	} while (time_before(jiffies, timeout));
+
+	dev_err(dev, "Timeout resetting block (ctrl %#x)\n", ctrl);
+
+	return false;
+}
+
+static int dw_mci_probe(struct platform_device *pdev)
+{
+	struct dw_mci *host;
+	struct resource	*regs;
+	struct dw_mci_board *pdata;
+	int irq, ret, i, width;
+	u32 fifo_size;
+
+	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!regs)
+		return -ENXIO;
+
+	irq = platform_get_irq(pdev, 0);
+	if (irq < 0)
+		return irq;
+
+	host = kzalloc(sizeof(struct dw_mci), GFP_KERNEL);
+	if (!host)
+		return -ENOMEM;
+
+	host->pdev = pdev;
+	host->pdata = pdata = pdev->dev.platform_data;
+	if (!pdata) {
+		dev_err(&pdev->dev, "Platform data missing\n");
+		ret = -ENODEV;
+		goto err_freehost;
+	}
+
+	if (((pdata->num_slots > 1) && !(pdata->select_slot))
+			|| !(pdata->init)) {
+		dev_err(&pdev->dev, "Platform data wrong\n");
+		ret = -ENODEV;
+		goto err_freehost;
+	}
+
+	if (!pdata->bus_hz) {
+		dev_err(&pdev->dev,
+			"Bus speed undefined in platform data!\n");
+		ret = -ENODEV;
+		goto err_freehost;
+	}
+
+	host->bus_hz = pdata->bus_hz;
+	host->quirks = pdata->quirks;
+
+	spin_lock_init(&host->lock);
+	INIT_LIST_HEAD(&host->queue);
+
+	ret = -ENOMEM;
+	host->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	if (!host->regs)
+		goto err_freehost;
+
+	host->dma_ops = pdata->dma_ops;
+	dw_mci_init_dma(host);
+
+	/*
+	 * Get the host data width - this assumes that HCON has been set with
+	 * the correct values.
+	 */
+	i = (mci_readl(host, HCON) >> 7) & 0x7;
+	if (!i) {
+		host->push_data = dw_mci_push_data16;
+		host->pull_data = dw_mci_pull_data16;
+		width = 16;
+		host->data_shift = 1;
+	} else if (i == 2) {
+		host->push_data = dw_mci_push_data64;
+		host->pull_data = dw_mci_pull_data64;
+		width = 64;
+		host->data_shift = 3;
+	} else {
+		/* Check for a reserved value, and warn if it is */
+		WARN((i != 1),
+			"HCON reports a reserved host data width!\n"
+			"Defaulting to 32-bit access.\n");
+		host->push_data = dw_mci_push_data32;
+		host->pull_data = dw_mci_pull_data32;
+		width = 32;
+		host->data_shift = 2;
+	}
+
+	/* reset all blocks */
+	if (!mci_wait_reset(&pdev->dev, host)) {
+		ret = -ENODEV;
+		goto err_dmaunmap;
+	}
+
+	 /* Clear the interrupts for the host controller */
+	mci_writel(host, RINTSTS, 0xFFFFFFFF);
+	mci_writel(host, INTMASK, 0); /* disable all mmc interrupt first */
+
+	/* Put in max timeout */
+	mci_writel(host, TMOUT, 0xFFFFFFFF);
+
+	/*
+	 * FIFO threshold settings  RxMark = fifo_size/2-1,
+	 *                          Tx Mark =fifo_size/2 DMA Size = 8
+	 */
+	fifo_size = mci_readl(host, FIFOTH);
+	fifo_size = (fifo_size >> 16) & 0x7ff;
+	mci_writel(host, FIFOTH, ((0x2 << 28) | ((fifo_size/2 - 1) << 16) |
+				((fifo_size/2) << 0)));
+
+	/* disable clock to CIU */
+	mci_writel(host, CLKENA, 0);
+	mci_writel(host, CLKSRC, 0);
+
+	tasklet_init(&host->tasklet, dw_mci_tasklet_func, (unsigned long)host);
+	tasklet_init(&host->card_tasklet,
+		dw_mci_tasklet_card, (unsigned long)host);
+
+	ret = request_irq(irq, dw_mci_interrupt, 0, "dw-mci", host);
+	if (ret)
+		goto err_dmaunmap;
+
+	platform_set_drvdata(pdev, host);
+
+	if (host->pdata->num_slots)
+		host->num_slots = host->pdata->num_slots;
+	else
+		host->num_slots = ((mci_readl(host, HCON) >> 1) & 0x1F) + 1;
+
+	/* We need at least one slot to succeed ####pd####*/
+	for (i = 0; i < host->num_slots; i++) {
+		ret = dw_mci_init_slot(host, i);
+		if (ret) {
+			ret = -ENODEV;
+			goto err_init_slot;
+		}
+	}
+
+	/*
+	 * enable interrupt for command done, data over, data empty,
+	 * receive ready and error such as transmit, receive timeout, crc error
+	 */
+	mci_writel(host, RINTSTS, 0xFFFFFFFF);
+	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER |
+				SDMMC_INT_TXDR | SDMMC_INT_RXDR |
+				DW_MCI_ERROR_FLAGS | SDMMC_INT_CD);
+	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE); /*enable mci interrupt*/
+
+	dev_info(&pdev->dev, "DW MMC controller at irq %d, "
+			"%d bit host data width\n",
+			irq, width);
+	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
+		dev_info(&pdev->dev, "Internal DMAC interrupt fix enabled.\n");
+
+	return 0;
+
+err_init_slot:
+	/* De-init any initialized slots */
+	while (i > 0) {
+		if (host->slot[i])
+			dw_mci_cleanup_slot(host->slot[i], i);
+		i--;
+	}
+	free_irq(irq, host);
+
+err_dmaunmap:
+	if (host->use_dma && host->dma_ops->exit)
+		host->dma_ops->exit(host);
+	dma_free_coherent(&host->pdev->dev, PAGE_SIZE,
+			host->sg_cpu, host->sg_dma);
+	iounmap(host->regs);
+
+err_freehost:
+	kfree(host);
+	return ret;
+}
+
+static int __exit dw_mci_remove(struct platform_device *pdev)
+{
+	struct dw_mci *host = platform_get_drvdata(pdev);
+	int i;
+
+	mci_writel(host, RINTSTS, 0xFFFFFFFF);
+	mci_writel(host, INTMASK, 0); /* disable all mmc interrupt first */
+
+	platform_set_drvdata(pdev, NULL);
+
+	for (i = 0; i < host->num_slots; i++) {
+		dev_dbg(&pdev->dev, "remove slot %d\n", i);
+		if (host->slot[i])
+			dw_mci_cleanup_slot(host->slot[i], i);
+	}
+
+	/* disable clock to CIU */
+	mci_writel(host, CLKENA, 0);
+	mci_writel(host, CLKSRC, 0);
+
+	free_irq(platform_get_irq(pdev, 0), host);
+	dma_free_coherent(&pdev->dev, PAGE_SIZE, host->sg_cpu, host->sg_dma);
+
+	if (host->use_dma && host->dma_ops->exit)
+		host->dma_ops->exit(host);
+
+	iounmap(host->regs);
+
+	kfree(host);
+	return 0;
+}
+
+#ifdef CONFIG_PM
+/*
+ * TODO: we should probably disable the clock to the card in the suspend path.
+ */
+static int dw_mci_suspend(struct platform_device *pdev, pm_message_t mesg)
+{
+	int i, ret;
+	struct dw_mci *host = platform_get_drvdata(pdev);
+
+	for (i = 0; i < host->num_slots; i++) {
+		struct dw_mci_slot *slot = host->slot[i];
+		if (!slot)
+			continue;
+		ret = mmc_suspend_host(slot->mmc);
+		if (ret < 0) {
+			while (--i >= 0) {
+				slot = host->slot[i];
+				if (slot)
+					mmc_resume_host(host->slot[i]->mmc);
+			}
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+static int dw_mci_resume(struct platform_device *pdev)
+{
+	int i, ret;
+	struct dw_mci *host = platform_get_drvdata(pdev);
+
+	for (i = 0; i < host->num_slots; i++) {
+		struct dw_mci_slot *slot = host->slot[i];
+		if (!slot)
+			continue;
+		ret = mmc_resume_host(host->slot[i]->mmc);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+#else
+#define dw_mci_suspend	NULL
+#define dw_mci_resume	NULL
+#endif /* CONFIG_PM */
+
+static struct platform_driver dw_mci_driver = {
+	.remove		= __exit_p(dw_mci_remove),
+	.suspend	= dw_mci_suspend,
+	.resume		= dw_mci_resume,
+	.driver		= {
+		.name		= "dw_mmc",
+	},
+};
+
+static int __init dw_mci_init(void)
+{
+	return platform_driver_probe(&dw_mci_driver, dw_mci_probe);
+}
+
+static void __exit dw_mci_exit(void)
+{
+	platform_driver_unregister(&dw_mci_driver);
+}
+
+module_init(dw_mci_init);
+module_exit(dw_mci_exit);
+
+MODULE_DESCRIPTION("DW Multimedia Card Interface driver");
+MODULE_AUTHOR("NXP Semiconductor VietNam");
+MODULE_AUTHOR("Imagination Technologies Ltd");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
new file mode 100644
index 0000000..65bcff7
--- /dev/null
+++ b/drivers/mmc/host/dw_mmc.h
@@ -0,0 +1,155 @@
+/*
+ * Synopsys DesignWare Multimedia Card Interface driver
+ *  (Based on NXP driver for lpc 31xx)
+ *
+ * Copyright (C) 2009 NXP Semiconductors
+ * Copyright (C) 2009, 2010 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _DW_MMC_H_
+#define _DW_MMC_H_
+
+#define MCI_SLOT		0
+
+#define SDMMC_CTRL		0x000
+#define SDMMC_PWREN		0x004
+#define SDMMC_CLKDIV		0x008
+#define SDMMC_CLKSRC		0x00c
+#define SDMMC_CLKENA		0x010
+#define SDMMC_TMOUT		0x014
+#define SDMMC_CTYPE		0x018
+#define SDMMC_BLKSIZ		0x01c
+#define SDMMC_BYTCNT		0x020
+#define SDMMC_INTMASK		0x024
+#define SDMMC_CMDARG		0x028
+#define SDMMC_CMD		0x02c
+#define SDMMC_RESP0		0x030
+#define SDMMC_RESP1		0x034
+#define SDMMC_RESP2		0x038
+#define SDMMC_RESP3		0x03c
+#define SDMMC_MINTSTS		0x040
+#define SDMMC_RINTSTS		0x044
+#define SDMMC_STATUS		0x048
+#define SDMMC_FIFOTH		0x04c
+#define SDMMC_CDETECT		0x050
+#define SDMMC_WRTPRT		0x054
+#define SDMMC_GPIO		0x058
+#define SDMMC_TCBCNT		0x05c
+#define SDMMC_TBBCNT		0x060
+#define SDMMC_DEBNCE		0x064
+#define SDMMC_USRID		0x068
+#define SDMMC_VERID		0x06c
+#define SDMMC_HCON		0x070
+#define SDMMC_BMOD		0x080
+#define SDMMC_PLDMND		0x084
+#define SDMMC_DBADDR		0x088
+#define SDMMC_IDSTS		0x08c
+#define SDMMC_IDINTEN		0x090
+#define SDMMC_DSCADDR		0x094
+#define SDMMC_BUFADDR		0x098
+#define SDMMC_DATA		0x100
+#define SDMMC_DATA_ADR		0x100
+
+/* shift bit field */
+#define _SBF(f, v)		((v) << (f))
+
+/* Control register defines */
+#define SDMMC_CTRL_USE_IDMAC		BIT(25)
+#define SDMMC_CTRL_CEATA_INT_EN		BIT(11)
+#define SDMMC_CTRL_SEND_AS_CCSD		BIT(10)
+#define SDMMC_CTRL_SEND_CCSD		BIT(9)
+#define SDMMC_CTRL_ABRT_READ_DATA	BIT(8)
+#define SDMMC_CTRL_SEND_IRQ_RESP	BIT(7)
+#define SDMMC_CTRL_READ_WAIT		BIT(6)
+#define SDMMC_CTRL_DMA_ENABLE		BIT(5)
+#define SDMMC_CTRL_INT_ENABLE		BIT(4)
+#define SDMMC_CTRL_DMA_RESET		BIT(2)
+#define SDMMC_CTRL_FIFO_RESET		BIT(1)
+#define SDMMC_CTRL_RESET		BIT(0)
+/* Clock Enable register defines */
+#define SDMMC_CLKEN_LOW_PWR		BIT(16)
+#define SDMMC_CLKEN_ENABLE		BIT(0)
+/* time-out register defines */
+#define SDMMC_TMOUT_DATA(n)		_SBF(8, (n))
+#define SDMMC_TMOUT_DATA_MSK		0xFFFFFF00
+#define SDMMC_TMOUT_RESP(n)		((n) & 0xFF)
+#define SDMMC_TMOUT_RESP_MSK		0xFF
+/* card-type register defines */
+#define SDMMC_CTYPE_8BIT		BIT(16)
+#define SDMMC_CTYPE_4BIT		BIT(0)
+#define SDMMC_CTYPE_1BIT		0
+/* Interrupt status & mask register defines */
+#define SDMMC_INT_SDIO			BIT(16)
+#define SDMMC_INT_EBE			BIT(15)
+#define SDMMC_INT_ACD			BIT(14)
+#define SDMMC_INT_SBE			BIT(13)
+#define SDMMC_INT_HLE			BIT(12)
+#define SDMMC_INT_FRUN			BIT(11)
+#define SDMMC_INT_HTO			BIT(10)
+#define SDMMC_INT_DTO			BIT(9)
+#define SDMMC_INT_RTO			BIT(8)
+#define SDMMC_INT_DCRC			BIT(7)
+#define SDMMC_INT_RCRC			BIT(6)
+#define SDMMC_INT_RXDR			BIT(5)
+#define SDMMC_INT_TXDR			BIT(4)
+#define SDMMC_INT_DATA_OVER		BIT(3)
+#define SDMMC_INT_CMD_DONE		BIT(2)
+#define SDMMC_INT_RESP_ERR		BIT(1)
+#define SDMMC_INT_CD			BIT(0)
+#define SDMMC_INT_ERROR			0xbfc2
+/* Command register defines */
+#define SDMMC_CMD_START			BIT(31)
+#define SDMMC_CMD_CCS_EXP		BIT(23)
+#define SDMMC_CMD_CEATA_RD		BIT(22)
+#define SDMMC_CMD_UPD_CLK		BIT(21)
+#define SDMMC_CMD_INIT			BIT(15)
+#define SDMMC_CMD_STOP			BIT(14)
+#define SDMMC_CMD_PRV_DAT_WAIT		BIT(13)
+#define SDMMC_CMD_SEND_STOP		BIT(12)
+#define SDMMC_CMD_STRM_MODE		BIT(11)
+#define SDMMC_CMD_DAT_WR		BIT(10)
+#define SDMMC_CMD_DAT_EXP		BIT(9)
+#define SDMMC_CMD_RESP_CRC		BIT(8)
+#define SDMMC_CMD_RESP_LONG		BIT(7)
+#define SDMMC_CMD_RESP_EXP		BIT(6)
+#define SDMMC_CMD_INDX(n)		((n) & 0x1F)
+/* Status register defines */
+#define SDMMC_GET_FCNT(x)		(((x)>>17) & 0x1FF)
+#define SDMMC_FIFO_SZ			32
+/* Internal DMAC interrupt defines */
+#define SDMMC_IDMAC_INT_AI		BIT(9)
+#define SDMMC_IDMAC_INT_NI		BIT(8)
+#define SDMMC_IDMAC_INT_CES		BIT(5)
+#define SDMMC_IDMAC_INT_DU		BIT(4)
+#define SDMMC_IDMAC_INT_FBE		BIT(2)
+#define SDMMC_IDMAC_INT_RI		BIT(1)
+#define SDMMC_IDMAC_INT_TI		BIT(0)
+/* Internal DMAC bus mode bits */
+#define SDMMC_IDMAC_ENABLE		BIT(7)
+#define SDMMC_IDMAC_FB			BIT(1)
+#define SDMMC_IDMAC_SWRESET		BIT(0)
+
+/* Register access macros */
+#define mci_readl(dev, reg)			\
+	__raw_readl(dev->regs + SDMMC_##reg)
+#define mci_writel(dev, reg, value)			\
+	__raw_writel((value), dev->regs + SDMMC_##reg)
+
+/* 16-bit FIFO access macros */
+#define mci_readw(dev, reg)			\
+	__raw_readw(dev->regs + SDMMC_##reg)
+#define mci_writew(dev, reg, value)			\
+	__raw_writew((value), dev->regs + SDMMC_##reg)
+
+/* 64-bit FIFO access macros */
+#define mci_readq(dev, reg)			\
+	__raw_readq(dev->regs + SDMMC_##reg)
+#define mci_writeq(dev, reg, value)			\
+	__raw_writeq((value), dev->regs + SDMMC_##reg)
+
+#endif /* _DW_MMC_H_ */
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
new file mode 100644
index 0000000..d2f92bd
--- /dev/null
+++ b/include/linux/mmc/dw_mmc.h
@@ -0,0 +1,149 @@
+/*
+ * Synopsys DesignWare Multimedia Card Interface driver
+ *  (Based on NXP driver for lpc 31xx)
+ *
+ * Copyright (C) 2009 NXP Semiconductors
+ * Copyright (C) 2009, 2010 Imagination Technologies Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _LINUX_MMC_DW_MMC_H_
+#define _LINUX_MMC_DW_MMC_H_
+
+#define MAX_MCI_SLOTS	2
+
+enum dw_mci_state {
+	STATE_IDLE = 0,
+	STATE_SENDING_CMD,
+	STATE_SENDING_DATA,
+	STATE_DATA_BUSY,
+	STATE_SENDING_STOP,
+	STATE_DATA_ERROR,
+};
+
+enum {
+	EVENT_CMD_COMPLETE = 0,
+	EVENT_XFER_COMPLETE,
+	EVENT_DATA_COMPLETE,
+	EVENT_DATA_ERROR,
+	EVENT_XFER_ERROR
+};
+
+struct mmc_data;
+
+struct dw_mci {
+	spinlock_t		lock;
+	void __iomem		*regs;
+
+	struct scatterlist	*sg;
+	unsigned int		pio_offset;
+
+	struct dw_mci_slot	*cur_slot;
+	struct mmc_request	*mrq;
+	struct mmc_command	*cmd;
+	struct mmc_data		*data;
+
+	/* DMA interface members*/
+	int			use_dma;
+
+	dma_addr_t		sg_dma;
+	void			*sg_cpu;
+	struct dw_mci_dma_ops	*dma_ops;
+#ifdef CONFIG_MMC_DW_IDMAC
+	unsigned int		ring_size;
+#else
+	struct dw_mci_dma_data	*dma_data;
+#endif
+	u32			cmd_status;
+	u32			data_status;
+	u32			stop_cmdr;
+	u32			dir_status;
+	struct tasklet_struct	tasklet;
+	struct tasklet_struct	card_tasklet;
+	unsigned long		pending_events;
+	unsigned long		completed_events;
+	enum dw_mci_state	state;
+	struct list_head	queue;
+
+	u32			bus_hz;
+	u32			current_speed;
+	u32			num_slots;
+	struct platform_device	*pdev;
+	struct dw_mci_board	*pdata;
+	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
+
+	/* FIFO push and pull */
+	int			data_shift;
+	void (*push_data)(struct dw_mci *host, void *buf, int cnt);
+	void (*pull_data)(struct dw_mci *host, void *buf, int cnt);
+
+	/* Workaround flags */
+	u32			quirks;
+};
+
+/* DMA ops for Internal/External DMAC interface */
+struct dw_mci_dma_ops {
+	/* DMA Ops */
+	int (*init)(struct dw_mci *host);
+	void (*start)(struct dw_mci *host, unsigned int sg_len);
+	void (*complete)(struct dw_mci *host);
+	void (*stop)(struct dw_mci *host);
+	void (*cleanup)(struct dw_mci *host);
+	void (*exit)(struct dw_mci *host);
+};
+
+/* IP Quirks/flags. */
+/* No special quirks or flags to cater for */
+#define DW_MCI_QUIRK_NONE		0
+/* DTO fix for command transmission with IDMAC configured */
+#define DW_MCI_QUIRK_IDMAC_DTO		1
+/* delay needed between retries on some 2.11a implementations */
+#define DW_MCI_QUIRK_RETRY_DELAY	2
+/* High Speed Capable - Supports HS cards (upto 50MHz) */
+#define DW_MCI_QUIRK_HIGHSPEED		4
+
+
+struct dma_pdata;
+
+struct block_settings {
+	unsigned short	max_segs;	/* see blk_queue_max_segments */
+	unsigned int	max_blk_size;	/* maximum size of one mmc block */
+	unsigned int	max_blk_count;	/* maximum number of blocks in one req*/
+	unsigned int	max_req_size;	/* maximum number of bytes in one req*/
+	unsigned int	max_seg_size;	/* see blk_queue_max_segment_size */
+};
+
+/* Board platform data */
+struct dw_mci_board {
+	u32 num_slots;
+
+	u32 quirks; /* Workaround / Quirk flags */
+	unsigned long bus_hz; /* Bus speed */
+
+	/* delay in mS before detecting cards after interrupt */
+	u32 detect_delay_ms;
+
+	int (*init)(u32 slot_id, irq_handler_t , void *);
+	int (*get_ro)(u32 slot_id);
+	int (*get_cd)(u32 slot_id);
+	int (*get_ocr)(u32 slot_id);
+	int (*get_bus_wd)(u32 slot_id);
+	/*
+	 * Enable power to selected slot and set voltage to desired level.
+	 * Voltage levels are specified using MMC_VDD_xxx defines defined
+	 * in linux/mmc/host.h file.
+	 */
+	void (*setpower)(u32 slot_id, u32 volt);
+	void (*exit)(u32 slot_id);
+	void (*select_slot)(u32 slot_id);
+
+	struct dw_mci_dma_ops *dma_ops;
+	struct dma_pdata *data;
+	struct block_settings *blk_settings;
+};
+
+#endif /* _LINUX_MMC_DW_MMC_H_ */
-- 
1.7.2.2

--00163649a3e386a83c0496bfe248
Content-Type: text/x-patch; charset=US-ASCII; 
	name="0001-dw_mmc-Add-Synopsys-DesignWare-mmc-host-driver.patch"
Content-Disposition: attachment; 
	filename="0001-dw_mmc-Add-Synopsys-DesignWare-mmc-host-driver.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghdjemez0

RnJvbSAxOTliOTYyOGU2NWRlM2Q3OTYwNjJjOWI3MjI4NjVjYmY1ZTliMGI1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXaWxsIE5ld3RvbiA8d2lsbC5uZXd0b25AaW1ndGVjLmNvbT4K
RGF0ZTogV2VkLCAyNCBOb3YgMjAxMCAxNzoxNTowNCArMDAwMApTdWJqZWN0OiBbUEFUQ0hdIGR3
X21tYzogQWRkIFN5bm9wc3lzIERlc2lnbldhcmUgbW1jIGhvc3QgZHJpdmVyLgoKVGhpcyBhZGRz
IHRoZSBtbWMgaG9zdCBkcml2ZXIgZm9yIHRoZSBTeW5vcHN5cyBEZXNpZ25XYXJlIG1tYwpob3N0
IGNvbnRyb2xsZXIsIGZvdW5kIGluIGEgbnVtYmVyIG9mIGVtYmVkZGVkIFNvQyBkZXNpZ25zLgoK
U2lnbmVkLW9mZi1ieTogV2lsbCBOZXd0b24gPHdpbGwubmV3dG9uQGltZ3RlYy5jb20+Ci0tLQog
ZHJpdmVycy9tbWMvaG9zdC9LY29uZmlnICAgfCAgIDE1ICsKIGRyaXZlcnMvbW1jL2hvc3QvTWFr
ZWZpbGUgIHwgICAgMSArCiBkcml2ZXJzL21tYy9ob3N0L2R3X21tYy5jICB8IDE4MTAgKysrKysr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGRyaXZlcnMvbW1jL2hvc3Qv
ZHdfbW1jLmggIHwgIDE1NSArKysrCiBpbmNsdWRlL2xpbnV4L21tYy9kd19tbWMuaCB8ICAxNDkg
KysrKwogNSBmaWxlcyBjaGFuZ2VkLCAyMTMwIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0p
CiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9tbWMvaG9zdC9kd19tbWMuYwogY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvbW1jL2hvc3QvZHdfbW1jLmgKIGNyZWF0ZSBtb2RlIDEwMDY0NCBp
bmNsdWRlL2xpbnV4L21tYy9kd19tbWMuaAoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbW1jL2hvc3Qv
S2NvbmZpZyBiL2RyaXZlcnMvbW1jL2hvc3QvS2NvbmZpZwppbmRleCBmOGZhOWVmLi5jOTlkMmM2
IDEwMDY0NAotLS0gYS9kcml2ZXJzL21tYy9ob3N0L0tjb25maWcKKysrIGIvZHJpdmVycy9tbWMv
aG9zdC9LY29uZmlnCkBAIC00NjksNiArNDY5LDIxIEBAIGNvbmZpZyBTREhfQkZJTl9NSVNTSU5H
X0NNRF9QVUxMVVBfV09SS0FST1VORAogCWhlbHAKIAkgIElmIHlvdSBzYXkgeWVzIGhlcmUgU0Qt
Q2FyZHMgbWF5IHdvcmsgb24gdGhlIEVaa2l0LgogCitjb25maWcgTU1DX0RXCisJdHJpc3RhdGUg
IlN5bm9wc3lzIERlc2lnbldhcmUgTWVtb3J5IENhcmQgSW50ZXJmYWNlIgorCWhlbHAKKwkgIFRo
aXMgc2VsZWN0cyBzdXBwb3J0IGZvciB0aGUgU3lub3BzeXMgRGVzaWduV2FyZSBNb2JpbGUgU3Rv
cmFnZSBJUAorCSAgYmxvY2ssIHRoaXMgcHJvdmlkZXMgaG9zdCBzdXBwb3J0IGZvciBTRCBhbmQg
TU1DIGludGVyZmFjZXMsIGluIGJvdGgKKwkgIFBJTyBhbmQgZXh0ZXJuYWwgRE1BIG1vZGVzLgor
Citjb25maWcgTU1DX0RXX0lETUFDCisJZGVwZW5kcyBvbiBNTUNfRFcKKwlib29sICJJbnRlcm5h
bCBETUFDIGludGVyZmFjZSIKKwloZWxwCisJICBUaGlzIHNlbGVjdHMgc3VwcG9ydCBmb3IgdGhl
IGludGVybmFsIERNQUMgYmxvY2sgd2l0aGluIHRoZSBTeW5vcHN5cworCSAgRGVzaWdud2FyZSBN
b2JpbGUgU3RvcmFnZSBJUCBibG9jay4gVGhpcyBkaXNhYmxlcyB0aGUgZXh0ZXJuYWwgRE1BCisJ
ICBpbnRlcmZhY2UuCisKIGNvbmZpZyBNTUNfU0hfTU1DSUYKIAl0cmlzdGF0ZSAiU3VwZXJIIElu
dGVybmFsIE1NQ0lGIHN1cHBvcnQiCiAJZGVwZW5kcyBvbiBNTUNfQkxPQ0sgJiYgKFNVUEVSSCB8
fCBBUkNIX1NITU9CSUxFKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9NYWtlZmlsZSBi
L2RyaXZlcnMvbW1jL2hvc3QvTWFrZWZpbGUKaW5kZXggZDkxMzY0ZC4uYTVkMWNiMiAxMDA2NDQK
LS0tIGEvZHJpdmVycy9tbWMvaG9zdC9NYWtlZmlsZQorKysgYi9kcml2ZXJzL21tYy9ob3N0L01h
a2VmaWxlCkBAIC0zMSw2ICszMSw3IEBAIG9iai0kKENPTkZJR19NTUNfVE1JTykJCSs9IHRtaW9f
bW1jLm8KIG9iai0kKENPTkZJR19NTUNfQ0I3MTApCSs9IGNiNzEwLW1tYy5vCiBvYmotJChDT05G
SUdfTU1DX1ZJQV9TRE1NQykJKz0gdmlhLXNkbW1jLm8KIG9iai0kKENPTkZJR19TREhfQkZJTikJ
CSs9IGJmaW5fc2RoLm8KK29iai0kKENPTkZJR19NTUNfRFcpCQkrPSBkd19tbWMubwogb2JqLSQo
Q09ORklHX01NQ19TSF9NTUNJRikJKz0gc2hfbW1jaWYubwogb2JqLSQoQ09ORklHX01NQ19KWjQ3
NDApCSs9IGp6NDc0MF9tbWMubwogb2JqLSQoQ09ORklHX01NQ19VU0hDKQkJKz0gdXNoYy5vCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL21tYy9ob3N0L2R3X21tYy5jIGIvZHJpdmVycy9tbWMvaG9zdC9k
d19tbWMuYwpuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi5mYTkwYjQ0Ci0tLSAv
ZGV2L251bGwKKysrIGIvZHJpdmVycy9tbWMvaG9zdC9kd19tbWMuYwpAQCAtMCwwICsxLDE4MTAg
QEAKKy8qCisgKiBTeW5vcHN5cyBEZXNpZ25XYXJlIE11bHRpbWVkaWEgQ2FyZCBJbnRlcmZhY2Ug
ZHJpdmVyCisgKiAgKEJhc2VkIG9uIE5YUCBkcml2ZXIgZm9yIGxwYyAzMXh4KQorICoKKyAqIENv
cHlyaWdodCAoQykgMjAwOSBOWFAgU2VtaWNvbmR1Y3RvcnMKKyAqIENvcHlyaWdodCAoQykgMjAw
OSwgMjAxMCBJbWFnaW5hdGlvbiBUZWNobm9sb2dpZXMgTHRkLgorICoKKyAqIFRoaXMgcHJvZ3Jh
bSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IgbW9kaWZ5
CisgKiBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
IGFzIHB1Ymxpc2hlZCBieQorICogdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVy
IHZlcnNpb24gMiBvZiB0aGUgTGljZW5zZSwgb3IKKyAqIChhdCB5b3VyIG9wdGlvbikgYW55IGxh
dGVyIHZlcnNpb24uCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBo
b3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWwsCisgKiBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7
IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogTUVSQ0hBTlRBQklMSVRZ
IG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQorICogR05VIEdl
bmVyYWwgUHVibGljIExpY2Vuc2UgZm9yIG1vcmUgZGV0YWlscy4KKyAqCisgKiBZb3Ugc2hvdWxk
IGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQor
ICogYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29m
dHdhcmUKKyAqIEZvdW5kYXRpb24sIEluYy4sIDU5IFRlbXBsZSBQbGFjZSwgU3VpdGUgMzMwLCBC
b3N0b24sIE1BICAwMjExMS0xMzA3ICBVU0EKKyAqCisgKi8KKworI2luY2x1ZGUgPGxpbnV4L2Js
a2Rldi5oPgorI2luY2x1ZGUgPGxpbnV4L2Nsay5oPgorI2luY2x1ZGUgPGxpbnV4L2RlYnVnZnMu
aD4KKyNpbmNsdWRlIDxsaW51eC9kZXZpY2UuaD4KKyNpbmNsdWRlIDxsaW51eC9kbWEtbWFwcGlu
Zy5oPgorI2luY2x1ZGUgPGxpbnV4L2Vyci5oPgorI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KKyNp
bmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNpbmNsdWRlIDxsaW51eC9pb3BvcnQuaD4KKyNp
bmNsdWRlIDxsaW51eC9tb2R1bGUuaD4KKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2Uu
aD4KKyNpbmNsdWRlIDxsaW51eC9zY2F0dGVybGlzdC5oPgorI2luY2x1ZGUgPGxpbnV4L3NlcV9m
aWxlLmg+CisjaW5jbHVkZSA8bGludXgvc2xhYi5oPgorI2luY2x1ZGUgPGxpbnV4L3N0YXQuaD4K
KyNpbmNsdWRlIDxsaW51eC9kZWxheS5oPgorI2luY2x1ZGUgPGxpbnV4L2lycS5oPgorI2luY2x1
ZGUgPGxpbnV4L21tYy9ob3N0Lmg+CisjaW5jbHVkZSA8bGludXgvbW1jL21tYy5oPgorI2luY2x1
ZGUgPGxpbnV4L21tYy9kd19tbWMuaD4KKyNpbmNsdWRlIDxsaW51eC9iaXRvcHMuaD4KKworI2lu
Y2x1ZGUgImR3X21tYy5oIgorCisvKiBDb21tb24gZmxhZyBjb21iaW5hdGlvbnMgKi8KKyNkZWZp
bmUgRFdfTUNJX0RBVEFfRVJST1JfRkxBR1MJKFNETU1DX0lOVF9EVE8gfCBTRE1NQ19JTlRfRENS
QyB8IFwKKwkJCQkgU0RNTUNfSU5UX0hUTyB8IFNETU1DX0lOVF9TQkUgIHwgXAorCQkJCSBTRE1N
Q19JTlRfRUJFKQorI2RlZmluZSBEV19NQ0lfQ01EX0VSUk9SX0ZMQUdTCShTRE1NQ19JTlRfUlRP
IHwgU0RNTUNfSU5UX1JDUkMgfCBcCisJCQkJIFNETU1DX0lOVF9SRVNQX0VSUikKKyNkZWZpbmUg
RFdfTUNJX0VSUk9SX0ZMQUdTCShEV19NQ0lfREFUQV9FUlJPUl9GTEFHUyB8IFwKKwkJCQkgRFdf
TUNJX0NNRF9FUlJPUl9GTEFHUyAgfCBTRE1NQ19JTlRfSExFKQorI2RlZmluZSBEV19NQ0lfU0VO
RF9TVEFUVVMJMQorI2RlZmluZSBEV19NQ0lfUkVDVl9TVEFUVVMJMgorI2RlZmluZSBEV19NQ0lf
RE1BX1RIUkVTSE9MRAkxNgorCisjaWZkZWYgQ09ORklHX01NQ19EV19JRE1BQworc3RydWN0IGlk
bWFjX2Rlc2MgeworCXUzMgkJZGVzMDsJLyogQ29udHJvbCBEZXNjcmlwdG9yICovCisjZGVmaW5l
IElETUFDX0RFUzBfRElDCUJJVCgxKQorI2RlZmluZSBJRE1BQ19ERVMwX0xECUJJVCgyKQorI2Rl
ZmluZSBJRE1BQ19ERVMwX0ZECUJJVCgzKQorI2RlZmluZSBJRE1BQ19ERVMwX0NICUJJVCg0KQor
I2RlZmluZSBJRE1BQ19ERVMwX0VSCUJJVCg1KQorI2RlZmluZSBJRE1BQ19ERVMwX0NFUwlCSVQo
MzApCisjZGVmaW5lIElETUFDX0RFUzBfT1dOCUJJVCgzMSkKKworCXUzMgkJZGVzMTsJLyogQnVm
ZmVyIHNpemVzICovCisjZGVmaW5lIElETUFDX1NFVF9CVUZGRVIxX1NJWkUoZCwgcykgXAorCSgo
ZCktPmRlczEgPSAoKGQpLT5kZXMxICYgMHgwM2ZmYzAwMCkgfCAoKHMpICYgMHgzZmZmKSkKKwor
CXUzMgkJZGVzMjsJLyogYnVmZmVyIDEgcGh5c2ljYWwgYWRkcmVzcyAqLworCisJdTMyCQlkZXMz
OwkvKiBidWZmZXIgMiBwaHlzaWNhbCBhZGRyZXNzICovCit9OworI2VuZGlmIC8qIENPTkZJR19N
TUNfRFdfSURNQUMgKi8KKworc3RydWN0IGR3X21jaV9zbG90IHsKKwlzdHJ1Y3QgbW1jX2hvc3QJ
CSptbWM7CisJc3RydWN0IGR3X21jaQkJKmhvc3Q7CisKKwl1MzIJCQljdHlwZTsKKworCXN0cnVj
dCBtbWNfcmVxdWVzdAkqbXJxOworCXN0cnVjdCBsaXN0X2hlYWQJcXVldWVfbm9kZTsKKworCXVu
c2lnbmVkIGludAkJY2xvY2s7CisJdW5zaWduZWQgbG9uZwkJZmxhZ3M7CisjZGVmaW5lIERXX01N
Q19DQVJEX1BSRVNFTlQJMAorI2RlZmluZSBEV19NTUNfQ0FSRF9ORUVEX0lOSVQJMQorCWludAkJ
CWlkOworCWludAkJCWxhc3RfZGV0ZWN0X3N0YXRlOworfTsKKworI2lmIGRlZmluZWQoQ09ORklH
X0RFQlVHX0ZTKQorLyoKKyAqIFRoZSBkZWJ1Z2ZzIHN0dWZmIGJlbG93IGlzIG1vc3RseSBvcHRp
bWl6ZWQgYXdheSB3aGVuCisgKiBDT05GSUdfREVCVUdfRlMgaXMgbm90IHNldC4KKyAqLworc3Rh
dGljIGludCBkd19tY2lfcmVxX3Nob3coc3RydWN0IHNlcV9maWxlICpzLCB2b2lkICp2KQorewor
CXN0cnVjdCBkd19tY2lfc2xvdCAqc2xvdCA9IHMtPnByaXZhdGU7CisJc3RydWN0IG1tY19yZXF1
ZXN0ICptcnE7CisJc3RydWN0IG1tY19jb21tYW5kICpjbWQ7CisJc3RydWN0IG1tY19jb21tYW5k
ICpzdG9wOworCXN0cnVjdCBtbWNfZGF0YQkqZGF0YTsKKworCS8qIE1ha2Ugc3VyZSB3ZSBnZXQg
YSBjb25zaXN0ZW50IHNuYXBzaG90ICovCisJc3Bpbl9sb2NrX2JoKCZzbG90LT5ob3N0LT5sb2Nr
KTsKKwltcnEgPSBzbG90LT5tcnE7CisKKwlpZiAobXJxKSB7CisJCWNtZCA9IG1ycS0+Y21kOwor
CQlkYXRhID0gbXJxLT5kYXRhOworCQlzdG9wID0gbXJxLT5zdG9wOworCisJCWlmIChjbWQpCisJ
CQlzZXFfcHJpbnRmKHMsCisJCQkJIkNNRCV1KDB4JXgpIGZsZyAleCByc3AgJXggJXggJXggJXgg
ZXJyICVkXG4iLAorCQkJCWNtZC0+b3Bjb2RlLCBjbWQtPmFyZywgY21kLT5mbGFncywKKwkJCQlj
bWQtPnJlc3BbMF0sIGNtZC0+cmVzcFsxXSwgY21kLT5yZXNwWzJdLAorCQkJCWNtZC0+cmVzcFsy
XSwgY21kLT5lcnJvcik7CisJCWlmIChkYXRhKQorCQkJc2VxX3ByaW50ZihzLCAiREFUQSAldSAv
ICV1ICogJXUgZmxnICV4IGVyciAlZFxuIiwKKwkJCQlkYXRhLT5ieXRlc194ZmVyZWQsIGRhdGEt
PmJsb2NrcywKKwkJCQlkYXRhLT5ibGtzeiwgZGF0YS0+ZmxhZ3MsIGRhdGEtPmVycm9yKTsKKwkJ
aWYgKHN0b3ApCisJCQlzZXFfcHJpbnRmKHMsCisJCQkJIkNNRCV1KDB4JXgpIGZsZyAleCByc3Ag
JXggJXggJXggJXggZXJyICVkXG4iLAorCQkJCXN0b3AtPm9wY29kZSwgc3RvcC0+YXJnLCBzdG9w
LT5mbGFncywKKwkJCQlzdG9wLT5yZXNwWzBdLCBzdG9wLT5yZXNwWzFdLCBzdG9wLT5yZXNwWzJd
LAorCQkJCXN0b3AtPnJlc3BbMl0sIHN0b3AtPmVycm9yKTsKKwl9CisKKwlzcGluX3VubG9ja19i
aCgmc2xvdC0+aG9zdC0+bG9jayk7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBkd19t
Y2lfcmVxX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbGUpCit7CisJ
cmV0dXJuIHNpbmdsZV9vcGVuKGZpbGUsIGR3X21jaV9yZXFfc2hvdywgaW5vZGUtPmlfcHJpdmF0
ZSk7Cit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGR3X21jaV9yZXFf
Zm9wcyA9IHsKKwkub3duZXIJCT0gVEhJU19NT0RVTEUsCisJLm9wZW4JCT0gZHdfbWNpX3JlcV9v
cGVuLAorCS5yZWFkCQk9IHNlcV9yZWFkLAorCS5sbHNlZWsJCT0gc2VxX2xzZWVrLAorCS5yZWxl
YXNlCT0gc2luZ2xlX3JlbGVhc2UsCit9OworCitzdGF0aWMgaW50IGR3X21jaV9yZWdzX3Nob3co
c3RydWN0IHNlcV9maWxlICpzLCB2b2lkICp2KQoreworCXNlcV9wcmludGYocywgIlNUQVRVUzpc
dDB4JTA4eFxuIiwgU0RNTUNfU1RBVFVTKTsKKwlzZXFfcHJpbnRmKHMsICJSSU5UU1RTOlx0MHgl
MDh4XG4iLCBTRE1NQ19SSU5UU1RTKTsKKwlzZXFfcHJpbnRmKHMsICJDTUQ6XHQweCUwOHhcbiIs
IFNETU1DX0NNRCk7CisJc2VxX3ByaW50ZihzLCAiQ1RSTDpcdDB4JTA4eFxuIiwgU0RNTUNfQ1RS
TCk7CisJc2VxX3ByaW50ZihzLCAiSU5UTUFTSzpcdDB4JTA4eFxuIiwgU0RNTUNfSU5UTUFTSyk7
CisJc2VxX3ByaW50ZihzLCAiQ0xLRU5BOlx0MHglMDh4XG4iLCBTRE1NQ19DTEtFTkEpOworCisJ
cmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgZHdfbWNpX3JlZ3Nfb3BlbihzdHJ1Y3QgaW5vZGUg
Kmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlsZSkKK3sKKwlyZXR1cm4gc2luZ2xlX29wZW4oZmlsZSwg
ZHdfbWNpX3JlZ3Nfc2hvdywgaW5vZGUtPmlfcHJpdmF0ZSk7Cit9CisKK3N0YXRpYyBjb25zdCBz
dHJ1Y3QgZmlsZV9vcGVyYXRpb25zIGR3X21jaV9yZWdzX2ZvcHMgPSB7CisJLm93bmVyCQk9IFRI
SVNfTU9EVUxFLAorCS5vcGVuCQk9IGR3X21jaV9yZWdzX29wZW4sCisJLnJlYWQJCT0gc2VxX3Jl
YWQsCisJLmxsc2VlawkJPSBzZXFfbHNlZWssCisJLnJlbGVhc2UJPSBzaW5nbGVfcmVsZWFzZSwK
K307CisKK3N0YXRpYyB2b2lkIGR3X21jaV9pbml0X2RlYnVnZnMoc3RydWN0IGR3X21jaV9zbG90
ICpzbG90KQoreworCXN0cnVjdCBtbWNfaG9zdAkqbW1jID0gc2xvdC0+bW1jOworCXN0cnVjdCBk
d19tY2kgKmhvc3QgPSBzbG90LT5ob3N0OworCXN0cnVjdCBkZW50cnkgKnJvb3Q7CisJc3RydWN0
IGRlbnRyeSAqbm9kZTsKKworCXJvb3QgPSBtbWMtPmRlYnVnZnNfcm9vdDsKKwlpZiAoIXJvb3Qp
CisJCXJldHVybjsKKworCW5vZGUgPSBkZWJ1Z2ZzX2NyZWF0ZV9maWxlKCJyZWdzIiwgU19JUlVT
Uiwgcm9vdCwgaG9zdCwKKwkJCSZkd19tY2lfcmVnc19mb3BzKTsKKwlpZiAoSVNfRVJSKG5vZGUp
KQorCQlyZXR1cm47CisJaWYgKCFub2RlKQorCQlnb3RvIGVycjsKKworCW5vZGUgPSBkZWJ1Z2Zz
X2NyZWF0ZV9maWxlKCJyZXEiLCBTX0lSVVNSLCByb290LCBzbG90LAorCQkJJmR3X21jaV9yZXFf
Zm9wcyk7CisJaWYgKCFub2RlKQorCQlnb3RvIGVycjsKKworCW5vZGUgPSBkZWJ1Z2ZzX2NyZWF0
ZV91MzIoInN0YXRlIiwgU19JUlVTUiwgcm9vdCwgKHUzMiAqKSZob3N0LT5zdGF0ZSk7CisJaWYg
KCFub2RlKQorCQlnb3RvIGVycjsKKworCW5vZGUgPSBkZWJ1Z2ZzX2NyZWF0ZV94MzIoInBlbmRp
bmdfZXZlbnRzIiwgU19JUlVTUiwgcm9vdCwKKwkJCQkgICAgICh1MzIgKikmaG9zdC0+cGVuZGlu
Z19ldmVudHMpOworCWlmICghbm9kZSkKKwkJZ290byBlcnI7CisKKwlub2RlID0gZGVidWdmc19j
cmVhdGVfeDMyKCJjb21wbGV0ZWRfZXZlbnRzIiwgU19JUlVTUiwgcm9vdCwKKwkJCQkgICAgICh1
MzIgKikmaG9zdC0+Y29tcGxldGVkX2V2ZW50cyk7CisJaWYgKCFub2RlKQorCQlnb3RvIGVycjsK
KworCXJldHVybjsKKworZXJyOgorCWRldl9lcnIoJm1tYy0+Y2xhc3NfZGV2LCAiZmFpbGVkIHRv
IGluaXRpYWxpemUgZGVidWdmcyBmb3Igc2xvdFxuIik7Cit9CisjZW5kaWYgLyogZGVmaW5lZChD
T05GSUdfREVCVUdfRlMpICovCisKK3N0YXRpYyB2b2lkIGR3X21jaV9zZXRfdGltZW91dChzdHJ1
Y3QgZHdfbWNpICpob3N0KQoreworCW1jaV93cml0ZWwoaG9zdCwgVE1PVVQsIDB4ZmZmZmZmZmYp
OyAvKiB0aW1lb3V0IChtYXhpbXVtKSAqLworfQorCitzdGF0aWMgdTMyIGR3X21jaV9wcmVwYXJl
X2NvbW1hbmQoc3RydWN0IG1tY19ob3N0ICptbWMsCisJCQkJICBzdHJ1Y3QgbW1jX2NvbW1hbmQg
KmNtZCkKK3sKKwlzdHJ1Y3QgbW1jX2RhdGEJKmRhdGE7CisJdTMyIGNtZHI7CisJY21kLT5lcnJv
ciA9IC1FSU5QUk9HUkVTUzsKKworCWNtZHIgPSBjbWQtPm9wY29kZTsKKworCWlmIChjbWRyID09
IE1NQ19TVE9QX1RSQU5TTUlTU0lPTikKKwkJY21kciB8PSBTRE1NQ19DTURfU1RPUDsKKwllbHNl
CisJCWNtZHIgfD0gU0RNTUNfQ01EX1BSVl9EQVRfV0FJVDsKKworCWlmIChjbWQtPmZsYWdzICYg
TU1DX1JTUF9QUkVTRU5UKSB7CisJCWNtZHIgfD0gU0RNTUNfQ01EX1JFU1BfRVhQOworCQkvKiBl
eHBlY3QgdGhlIHJlc3BvbmQsIG5lZWQgdG8gc2V0IHRoaXMgYml0ICovCisJCWlmIChjbWQtPmZs
YWdzICYgTU1DX1JTUF8xMzYpCisJCQljbWRyIHw9IFNETU1DX0NNRF9SRVNQX0xPTkc7IC8qIGV4
cGVjdCBsb25nIHJlc3BvbmQgKi8KKwl9CisKKwlpZiAoY21kLT5mbGFncyAmIE1NQ19SU1BfQ1JD
KQorCQljbWRyIHw9IFNETU1DX0NNRF9SRVNQX0NSQzsKKworCWRhdGEgPSBjbWQtPmRhdGE7CisJ
aWYgKGRhdGEpIHsKKwkJY21kciB8PSBTRE1NQ19DTURfREFUX0VYUDsKKwkJaWYgKGRhdGEtPmZs
YWdzICYgTU1DX0RBVEFfU1RSRUFNKQorCQkJY21kciB8PSBTRE1NQ19DTURfU1RSTV9NT0RFOyAv
KiAgc2V0IHN0cmVhbSBtb2RlICovCisJCWlmIChkYXRhLT5mbGFncyAmIE1NQ19EQVRBX1dSSVRF
KQorCQkJY21kciB8PSBTRE1NQ19DTURfREFUX1dSOworCX0KKworCXJldHVybiBjbWRyOworfQor
CitzdGF0aWMgdm9pZCBkd19tY2lfc3RhcnRfY29tbWFuZChzdHJ1Y3QgZHdfbWNpICpob3N0LAor
CQkJCSBzdHJ1Y3QgbW1jX2NvbW1hbmQgKmNtZCwgdTMyIGNtZF9mbGFncykKK3sKKwlob3N0LT5j
bWQgPSBjbWQ7CisJZGV2X3ZkYmcoJmhvc3QtPnBkZXYtPmRldiwKKwkJCSJzdGFydCBjb21tYW5k
OiBBUkdSPTB4JTA4eCBDTURSPTB4JTA4eFxuIiwKKwkJCWNtZC0+YXJnLCBjbWRfZmxhZ3MpOwor
CisJLyogd3JpdGUgdG8gQ01EQVJHIHJlZ2lzdGVyICovCisJbWNpX3dyaXRlbChob3N0LCBDTURB
UkcsIGNtZC0+YXJnKTsKKwl3bWIoKTsKKworCS8qIHdyaXRlIHRvIENNRCByZWdpc3RlciAqLwor
CW1jaV93cml0ZWwoaG9zdCwgQ01ELCBjbWRfZmxhZ3MgfCBTRE1NQ19DTURfU1RBUlQpOworfQor
CitzdGF0aWMgdm9pZCBzZW5kX3N0b3BfY21kKHN0cnVjdCBkd19tY2kgKmhvc3QsIHN0cnVjdCBt
bWNfZGF0YSAqZGF0YSkKK3sKKwlkd19tY2lfc3RhcnRfY29tbWFuZChob3N0LCBkYXRhLT5zdG9w
LCBob3N0LT5zdG9wX2NtZHIpOworfQorCisvKiBETUEgaW50ZXJmYWNlIGZ1bmN0aW9ucyAqLwor
c3RhdGljIHZvaWQgZHdfbWNpX3N0b3BfZG1hKHN0cnVjdCBkd19tY2kgKmhvc3QpCit7CisJaWYg
KGhvc3QtPnVzZV9kbWEpIHsKKwkJaG9zdC0+ZG1hX29wcy0+c3RvcChob3N0KTsKKwkJaG9zdC0+
ZG1hX29wcy0+Y2xlYW51cChob3N0KTsKKworCX0gZWxzZSB7CisJCS8qIERhdGEgdHJhbnNmZXIg
d2FzIHN0b3BwZWQgYnkgdGhlIGludGVycnVwdCBoYW5kbGVyICovCisJCXNldF9iaXQoRVZFTlRf
WEZFUl9DT01QTEVURSwgJmhvc3QtPnBlbmRpbmdfZXZlbnRzKTsKKwl9Cit9CisKKyNpZmRlZiBD
T05GSUdfTU1DX0RXX0lETUFDCitzdGF0aWMgdm9pZCBkd19tY2lfZG1hX2NsZWFudXAoc3RydWN0
IGR3X21jaSAqaG9zdCkKK3sKKwlzdHJ1Y3QgbW1jX2RhdGEgKmRhdGEgPSBob3N0LT5kYXRhOwor
CisJaWYgKGRhdGEpCisJCWRtYV91bm1hcF9zZygmaG9zdC0+cGRldi0+ZGV2LCBkYXRhLT5zZywg
ZGF0YS0+c2dfbGVuLAorCQkgICAgICgoZGF0YS0+ZmxhZ3MgJiBNTUNfREFUQV9XUklURSkKKwkJ
ICAgICAgPyBETUFfVE9fREVWSUNFIDogRE1BX0ZST01fREVWSUNFKSk7Cit9CisKK3N0YXRpYyB2
b2lkIGR3X21jaV9pZG1hY19zdG9wX2RtYShzdHJ1Y3QgZHdfbWNpICpob3N0KQoreworCXUzMiB0
ZW1wOworCisJLyogRGlzYWJsZSBhbmQgcmVzZXQgdGhlIElETUFDIGludGVyZmFjZSAqLworCXRl
bXAgPSBtY2lfcmVhZGwoaG9zdCwgQ1RSTCk7CisJdGVtcCAmPSB+U0RNTUNfQ1RSTF9VU0VfSURN
QUM7CisJdGVtcCB8PSBTRE1NQ19DVFJMX0RNQV9SRVNFVDsKKwltY2lfd3JpdGVsKGhvc3QsIENU
UkwsIHRlbXApOworCisJLyogU3RvcCB0aGUgSURNQUMgcnVubmluZyAqLworCXRlbXAgPSBtY2lf
cmVhZGwoaG9zdCwgQk1PRCk7CisJdGVtcCAmPSB+U0RNTUNfSURNQUNfRU5BQkxFOworCW1jaV93
cml0ZWwoaG9zdCwgQk1PRCwgdGVtcCk7Cit9CisKK3N0YXRpYyB2b2lkIGR3X21jaV9pZG1hY19j
b21wbGV0ZV9kbWEoc3RydWN0IGR3X21jaSAqaG9zdCkKK3sKKwlzdHJ1Y3QgbW1jX2RhdGEgKmRh
dGEgPSBob3N0LT5kYXRhOworCisJZGV2X3ZkYmcoJmhvc3QtPnBkZXYtPmRldiwgIkRNQSBjb21w
bGV0ZVxuIik7CisKKwlob3N0LT5kbWFfb3BzLT5jbGVhbnVwKGhvc3QpOworCisJLyoKKwkgKiBJ
ZiB0aGUgY2FyZCB3YXMgcmVtb3ZlZCwgZGF0YSB3aWxsIGJlIE5VTEwuIE5vIHBvaW50IGluIHRy
eWluZyB0bworCSAqIHNlbmQgdGhlIHN0b3AgY29tbWFuZCBvciB3YWl0aW5nIGZvciBOQlVTWSBp
biB0aGlzIGNhc2UuCisJICovCisJaWYgKGRhdGEpIHsKKwkJc2V0X2JpdChFVkVOVF9YRkVSX0NP
TVBMRVRFLCAmaG9zdC0+cGVuZGluZ19ldmVudHMpOworCQl0YXNrbGV0X3NjaGVkdWxlKCZob3N0
LT50YXNrbGV0KTsKKwl9Cit9CisKK3N0YXRpYyB2b2lkIGR3X21jaV90cmFuc2xhdGVfc2dsaXN0
KHN0cnVjdCBkd19tY2kgKmhvc3QsCisJCQkJICAgIHN0cnVjdCBtbWNfZGF0YSAqZGF0YSwgdW5z
aWduZWQgaW50IHNnX2xlbikKK3sKKwlpbnQgaTsKKwlzdHJ1Y3QgaWRtYWNfZGVzYyAqZGVzYyA9
IGhvc3QtPnNnX2NwdTsKKworCWZvciAoaSA9IDA7IGkgPCBzZ19sZW47IGkrKywgZGVzYysrKSB7
CisJCXVuc2lnbmVkIGludCBsZW5ndGggPSBzZ19kbWFfbGVuKCZkYXRhLT5zZ1tpXSk7CisJCXUz
MiBtZW1fYWRkciA9IHNnX2RtYV9hZGRyZXNzKCZkYXRhLT5zZ1tpXSk7CisKKwkJLyogU2V0IHRo
ZSBPV04gYml0IGFuZCBkaXNhYmxlIGludGVycnVwdHMgZm9yIHRoaXMgZGVzY3JpcHRvciAqLwor
CQlkZXNjLT5kZXMwID0gSURNQUNfREVTMF9PV04gfCBJRE1BQ19ERVMwX0RJQyB8IElETUFDX0RF
UzBfQ0g7CisKKwkJLyogQnVmZmVyIGxlbmd0aCAqLworCQlJRE1BQ19TRVRfQlVGRkVSMV9TSVpF
KGRlc2MsIGxlbmd0aCk7CisKKwkJLyogUGh5c2ljYWwgYWRkcmVzcyB0byBETUEgdG8vZnJvbSAq
LworCQlkZXNjLT5kZXMyID0gbWVtX2FkZHI7CisJfQorCisJLyogU2V0IGZpcnN0IGRlc2NyaXB0
b3IgKi8KKwlkZXNjID0gaG9zdC0+c2dfY3B1OworCWRlc2MtPmRlczAgfD0gSURNQUNfREVTMF9G
RDsKKworCS8qIFNldCBsYXN0IGRlc2NyaXB0b3IgKi8KKwlkZXNjID0gaG9zdC0+c2dfY3B1ICsg
KGkgLSAxKSAqIHNpemVvZihzdHJ1Y3QgaWRtYWNfZGVzYyk7CisJZGVzYy0+ZGVzMCAmPSB+KElE
TUFDX0RFUzBfQ0ggfCBJRE1BQ19ERVMwX0RJQyk7CisJZGVzYy0+ZGVzMCB8PSBJRE1BQ19ERVMw
X0xEOworCisJd21iKCk7Cit9CisKK3N0YXRpYyB2b2lkIGR3X21jaV9pZG1hY19zdGFydF9kbWEo
c3RydWN0IGR3X21jaSAqaG9zdCwgdW5zaWduZWQgaW50IHNnX2xlbikKK3sKKwl1MzIgdGVtcDsK
KworCWR3X21jaV90cmFuc2xhdGVfc2dsaXN0KGhvc3QsIGhvc3QtPmRhdGEsIHNnX2xlbik7CisK
KwkvKiBTZWxlY3QgSURNQUMgaW50ZXJmYWNlICovCisJdGVtcCA9IG1jaV9yZWFkbChob3N0LCBD
VFJMKTsKKwl0ZW1wIHw9IFNETU1DX0NUUkxfVVNFX0lETUFDOworCW1jaV93cml0ZWwoaG9zdCwg
Q1RSTCwgdGVtcCk7CisKKwl3bWIoKTsKKworCS8qIEVuYWJsZSB0aGUgSURNQUMgKi8KKwl0ZW1w
ID0gbWNpX3JlYWRsKGhvc3QsIEJNT0QpOworCXRlbXAgfD0gU0RNTUNfSURNQUNfRU5BQkxFOwor
CW1jaV93cml0ZWwoaG9zdCwgQk1PRCwgdGVtcCk7CisKKwkvKiBTdGFydCBpdCBydW5uaW5nICov
CisJbWNpX3dyaXRlbChob3N0LCBQTERNTkQsIDEpOworfQorCitzdGF0aWMgaW50IGR3X21jaV9p
ZG1hY19pbml0KHN0cnVjdCBkd19tY2kgKmhvc3QpCit7CisJc3RydWN0IGlkbWFjX2Rlc2MgKnA7
CisJaW50IGk7CisKKwkvKiBOdW1iZXIgb2YgZGVzY3JpcHRvcnMgaW4gdGhlIHJpbmcgYnVmZmVy
ICovCisJaG9zdC0+cmluZ19zaXplID0gUEFHRV9TSVpFIC8gc2l6ZW9mKHN0cnVjdCBpZG1hY19k
ZXNjKTsKKworCS8qIEZvcndhcmQgbGluayB0aGUgZGVzY3JpcHRvciBsaXN0ICovCisJZm9yIChp
ID0gMCwgcCA9IGhvc3QtPnNnX2NwdTsgaSA8IGhvc3QtPnJpbmdfc2l6ZSAtIDE7IGkrKywgcCsr
KQorCQlwLT5kZXMzID0gaG9zdC0+c2dfZG1hICsgKHNpemVvZihzdHJ1Y3QgaWRtYWNfZGVzYykg
KiAoaSArIDEpKTsKKworCS8qIFNldCB0aGUgbGFzdCBkZXNjcmlwdG9yIGFzIHRoZSBlbmQtb2Yt
cmluZyBkZXNjcmlwdG9yICovCisJcC0+ZGVzMyA9IGhvc3QtPnNnX2RtYTsKKwlwLT5kZXMwID0g
SURNQUNfREVTMF9FUjsKKworCS8qIE1hc2sgb3V0IGludGVycnVwdHMgLSBnZXQgVHggJiBSeCBj
b21wbGV0ZSBvbmx5ICovCisJbWNpX3dyaXRlbChob3N0LCBJRElOVEVOLCBTRE1NQ19JRE1BQ19J
TlRfTkkgfCBTRE1NQ19JRE1BQ19JTlRfUkkgfAorCQkJU0RNTUNfSURNQUNfSU5UX1RJKTsKKwor
CS8qIFNldCB0aGUgZGVzY3JpcHRvciBiYXNlIGFkZHJlc3MgKi8KKwltY2lfd3JpdGVsKGhvc3Qs
IERCQUREUiwgaG9zdC0+c2dfZG1hKTsKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHN0cnVjdCBk
d19tY2lfZG1hX29wcyBkd19tY2lfaWRtYWNfb3BzID0geworCS5pbml0ID0gZHdfbWNpX2lkbWFj
X2luaXQsCisJLnN0YXJ0ID0gZHdfbWNpX2lkbWFjX3N0YXJ0X2RtYSwKKwkuc3RvcCA9IGR3X21j
aV9pZG1hY19zdG9wX2RtYSwKKwkuY29tcGxldGUgPSBkd19tY2lfaWRtYWNfY29tcGxldGVfZG1h
LAorCS5jbGVhbnVwID0gZHdfbWNpX2RtYV9jbGVhbnVwLAorfTsKKyNlbmRpZiAvKiBDT05GSUdf
TU1DX0RXX0lETUFDICovCisKK3N0YXRpYyBpbnQgZHdfbWNpX3N1Ym1pdF9kYXRhX2RtYShzdHJ1
Y3QgZHdfbWNpICpob3N0LCBzdHJ1Y3QgbW1jX2RhdGEgKmRhdGEpCit7CisJc3RydWN0IHNjYXR0
ZXJsaXN0ICpzZzsKKwl1bnNpZ25lZCBpbnQgaSwgZGlyZWN0aW9uLCBzZ19sZW47CisJdTMyIHRl
bXA7CisKKwkvKiBJZiB3ZSBkb24ndCBoYXZlIGEgY2hhbm5lbCwgd2UgY2FuJ3QgZG8gRE1BICov
CisJaWYgKCFob3N0LT51c2VfZG1hKQorCQlyZXR1cm4gLUVOT0RFVjsKKworCS8qCisJICogV2Ug
ZG9uJ3QgZG8gRE1BIG9uICJjb21wbGV4IiB0cmFuc2ZlcnMsIGkuZS4gd2l0aAorCSAqIG5vbi13
b3JkLWFsaWduZWQgYnVmZmVycyBvciBsZW5ndGhzLiBBbHNvLCB3ZSBkb24ndCBib3RoZXIKKwkg
KiB3aXRoIGFsbCB0aGUgRE1BIHNldHVwIG92ZXJoZWFkIGZvciBzaG9ydCB0cmFuc2ZlcnMuCisJ
ICovCisJaWYgKGRhdGEtPmJsb2NrcyAqIGRhdGEtPmJsa3N6IDwgRFdfTUNJX0RNQV9USFJFU0hP
TEQpCisJCXJldHVybiAtRUlOVkFMOworCWlmIChkYXRhLT5ibGtzeiAmIDMpCisJCXJldHVybiAt
RUlOVkFMOworCisJZm9yX2VhY2hfc2coZGF0YS0+c2csIHNnLCBkYXRhLT5zZ19sZW4sIGkpIHsK
KwkJaWYgKHNnLT5vZmZzZXQgJiAzIHx8IHNnLT5sZW5ndGggJiAzKQorCQkJcmV0dXJuIC1FSU5W
QUw7CisJfQorCisJaWYgKGRhdGEtPmZsYWdzICYgTU1DX0RBVEFfUkVBRCkKKwkJZGlyZWN0aW9u
ID0gRE1BX0ZST01fREVWSUNFOworCWVsc2UKKwkJZGlyZWN0aW9uID0gRE1BX1RPX0RFVklDRTsK
KworCXNnX2xlbiA9IGRtYV9tYXBfc2coJmhvc3QtPnBkZXYtPmRldiwgZGF0YS0+c2csIGRhdGEt
PnNnX2xlbiwKKwkJCQkgICBkaXJlY3Rpb24pOworCisJZGV2X3ZkYmcoJmhvc3QtPnBkZXYtPmRl
diwKKwkJInNkIHNnX2NwdTogJSNseCBzZ19kbWE6ICUjbHggc2dfbGVuOiAlZFxuIiwKKwkJKHVu
c2lnbmVkIGxvbmcpaG9zdC0+c2dfY3B1LCAodW5zaWduZWQgbG9uZylob3N0LT5zZ19kbWEsCisJ
CSBzZ19sZW4pOworCisJLyogRW5hYmxlIHRoZSBETUEgaW50ZXJmYWNlICovCisJdGVtcCA9IG1j
aV9yZWFkbChob3N0LCBDVFJMKTsKKwl0ZW1wIHw9IFNETU1DX0NUUkxfRE1BX0VOQUJMRTsKKwlt
Y2lfd3JpdGVsKGhvc3QsIENUUkwsIHRlbXApOworCisJLyogZGlzYWJsZSBpcnEgb2YgUlggJiBU
WCwgbGV0IERNQSBoYW5kbGUgaXQgKi8KKwl0ZW1wID0gbWNpX3JlYWRsKGhvc3QsIElOVE1BU0sp
OworCXRlbXAgICY9IH4oU0RNTUNfSU5UX1JYRFIgfCBTRE1NQ19JTlRfVFhEUik7CisJbWNpX3dy
aXRlbChob3N0LCBJTlRNQVNLLCB0ZW1wKTsKKworCWhvc3QtPmRtYV9vcHMtPnN0YXJ0KGhvc3Qs
IHNnX2xlbik7CisKKwlyZXR1cm4gMDsKK30KKworc3RhdGljIHZvaWQgZHdfbWNpX3N1Ym1pdF9k
YXRhKHN0cnVjdCBkd19tY2kgKmhvc3QsIHN0cnVjdCBtbWNfZGF0YSAqZGF0YSkKK3sKKwl1MzIg
dGVtcDsKKworCWRhdGEtPmVycm9yID0gLUVJTlBST0dSRVNTOworCisJV0FSTl9PTihob3N0LT5k
YXRhKTsKKwlob3N0LT5zZyA9IE5VTEw7CisJaG9zdC0+ZGF0YSA9IGRhdGE7CisKKwlpZiAoZHdf
bWNpX3N1Ym1pdF9kYXRhX2RtYShob3N0LCBkYXRhKSkgeworCQlob3N0LT5zZyA9IGRhdGEtPnNn
OworCQlob3N0LT5waW9fb2Zmc2V0ID0gMDsKKwkJaWYgKGRhdGEtPmZsYWdzICYgTU1DX0RBVEFf
UkVBRCkKKwkJCWhvc3QtPmRpcl9zdGF0dXMgPSBEV19NQ0lfUkVDVl9TVEFUVVM7CisJCWVsc2UK
KwkJCWhvc3QtPmRpcl9zdGF0dXMgPSBEV19NQ0lfU0VORF9TVEFUVVM7CisKKwkJdGVtcCA9IG1j
aV9yZWFkbChob3N0LCBJTlRNQVNLKTsKKwkJdGVtcCB8PSBTRE1NQ19JTlRfVFhEUiB8IFNETU1D
X0lOVF9SWERSOworCQltY2lfd3JpdGVsKGhvc3QsIElOVE1BU0ssIHRlbXApOworCisJCXRlbXAg
PSBtY2lfcmVhZGwoaG9zdCwgQ1RSTCk7CisJCXRlbXAgJj0gflNETU1DX0NUUkxfRE1BX0VOQUJM
RTsKKwkJbWNpX3dyaXRlbChob3N0LCBDVFJMLCB0ZW1wKTsKKwl9Cit9CisKK3N0YXRpYyB2b2lk
IG1jaV9zZW5kX2NtZChzdHJ1Y3QgZHdfbWNpX3Nsb3QgKnNsb3QsIHUzMiBjbWQsIHUzMiBhcmcp
Cit7CisJc3RydWN0IGR3X21jaSAqaG9zdCA9IHNsb3QtPmhvc3Q7CisJdW5zaWduZWQgbG9uZyB0
aW1lb3V0ID0gamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNTAwKTsKKwl1bnNpZ25lZCBpbnQg
Y21kX3N0YXR1cyA9IDA7CisKKwltY2lfd3JpdGVsKGhvc3QsIENNREFSRywgYXJnKTsKKwl3bWIo
KTsKKwltY2lfd3JpdGVsKGhvc3QsIENNRCwgU0RNTUNfQ01EX1NUQVJUIHwgY21kKTsKKworCXdo
aWxlICh0aW1lX2JlZm9yZShqaWZmaWVzLCB0aW1lb3V0KSkgeworCQljbWRfc3RhdHVzID0gbWNp
X3JlYWRsKGhvc3QsIENNRCk7CisJCWlmICghKGNtZF9zdGF0dXMgJiBTRE1NQ19DTURfU1RBUlQp
KQorCQkJcmV0dXJuOworCX0KKwlkZXZfZXJyKCZzbG90LT5tbWMtPmNsYXNzX2RldiwKKwkJIlRp
bWVvdXQgc2VuZGluZyBjb21tYW5kIChjbWQgJSN4IGFyZyAlI3ggc3RhdHVzICUjeClcbiIsCisJ
CWNtZCwgYXJnLCBjbWRfc3RhdHVzKTsKK30KKworc3RhdGljIHZvaWQgZHdfbWNpX3NldHVwX2J1
cyhzdHJ1Y3QgZHdfbWNpX3Nsb3QgKnNsb3QpCit7CisJc3RydWN0IGR3X21jaSAqaG9zdCA9IHNs
b3QtPmhvc3Q7CisJdTMyIGRpdjsKKworCWlmIChzbG90LT5jbG9jayAhPSBob3N0LT5jdXJyZW50
X3NwZWVkKSB7CisJCWlmIChob3N0LT5idXNfaHogJSBzbG90LT5jbG9jaykKKwkJCS8qCisJCQkg
KiBtb3ZlIHRoZSArIDEgYWZ0ZXIgdGhlIGR2aWRlCisJCQkgKiB0byBwcmV2ZW50IG92ZXItY2xv
Y2tpbmcgdGhlIGNhcmQuCisJCQkgKi8KKwkJCWRpdiA9ICgoaG9zdC0+YnVzX2h6IC8gc2xvdC0+
Y2xvY2spID4+IDEpICsgMTsKKwkJZWxzZQorCQkJZGl2ID0gKGhvc3QtPmJ1c19oeiAgLyBzbG90
LT5jbG9jaykgPj4gMTsKKworCQlkZXZfaW5mbygmc2xvdC0+bW1jLT5jbGFzc19kZXYsCisJCQki
QnVzIHNwZWVkIChzbG90ICVkKSA9ICVkSHogKHNsb3QgcmVxICVkSHosIGFjdHVhbCAlZEhaIgor
CQkJIiBkaXYgPSAlZClcbiIsCisJCQlzbG90LT5pZCwgaG9zdC0+YnVzX2h6LCBzbG90LT5jbG9j
aywKKwkJCWRpdiA/ICgoaG9zdC0+YnVzX2h6IC8gZGl2KSA+PiAxKSA6IGhvc3QtPmJ1c19oeiwg
ZGl2KTsKKworCQkvKiBkaXNhYmxlIGNsb2NrICovCisJCW1jaV93cml0ZWwoaG9zdCwgQ0xLRU5B
LCAwKTsKKwkJbWNpX3dyaXRlbChob3N0LCBDTEtTUkMsIDApOworCisJCS8qIGluZm9ybSBDSVUg
Ki8KKwkJbWNpX3NlbmRfY21kKHNsb3QsCisJCQlTRE1NQ19DTURfVVBEX0NMSyB8IFNETU1DX0NN
RF9QUlZfREFUX1dBSVQsIDApOworCisJCS8qIHNldCBjbG9jayB0byBkZXNpcmVkIHNwZWVkICov
CisJCW1jaV93cml0ZWwoaG9zdCwgQ0xLRElWLCBkaXYpOworCisJCS8qIGluZm9ybSBDSVUgKi8K
KwkJbWNpX3NlbmRfY21kKHNsb3QsCisJCQlTRE1NQ19DTURfVVBEX0NMSyB8IFNETU1DX0NNRF9Q
UlZfREFUX1dBSVQsIDApOworCisJCS8qIGVuYWJsZSBjbG9jayAqLworCQltY2lfd3JpdGVsKGhv
c3QsIENMS0VOQSwgU0RNTUNfQ0xLRU5fRU5BQkxFKTsKKworCQkvKiBpbmZvcm0gQ0lVICovCisJ
CW1jaV9zZW5kX2NtZChzbG90LAorCQkJU0RNTUNfQ01EX1VQRF9DTEsgfCBTRE1NQ19DTURfUFJW
X0RBVF9XQUlULCAwKTsKKworCQlob3N0LT5jdXJyZW50X3NwZWVkID0gc2xvdC0+Y2xvY2s7CisJ
fQorCisJLyogU2V0IHRoZSBjdXJyZW50IHNsb3QgYnVzIHdpZHRoICovCisJbWNpX3dyaXRlbCho
b3N0LCBDVFlQRSwgc2xvdC0+Y3R5cGUpOworfQorCitzdGF0aWMgdm9pZCBkd19tY2lfc3RhcnRf
cmVxdWVzdChzdHJ1Y3QgZHdfbWNpICpob3N0LAorCQkJCSBzdHJ1Y3QgZHdfbWNpX3Nsb3QgKnNs
b3QpCit7CisJc3RydWN0IG1tY19yZXF1ZXN0ICptcnE7CisJc3RydWN0IG1tY19jb21tYW5kICpj
bWQ7CisJc3RydWN0IG1tY19kYXRhCSpkYXRhOworCXUzMiBjbWRmbGFnczsKKworCW1ycSA9IHNs
b3QtPm1ycTsKKwkvKiBubyBzZWxlY3QgdGhlIHByb3BlciBzbG90ICovCisJaWYgKGhvc3QtPnBk
YXRhLT5zZWxlY3Rfc2xvdCkKKwkJaG9zdC0+cGRhdGEtPnNlbGVjdF9zbG90KHNsb3QtPmlkKTsK
KworCS8qIFNsb3Qgc3BlY2lmaWMgdGltaW5nIGFuZCB3aWR0aCBhZGp1c3RtZW50ICovCisJZHdf
bWNpX3NldHVwX2J1cyhzbG90KTsKKworCWhvc3QtPmN1cl9zbG90ID0gc2xvdDsKKwlob3N0LT5t
cnEgPSBtcnE7CisKKwlob3N0LT5wZW5kaW5nX2V2ZW50cyA9IDA7CisJaG9zdC0+Y29tcGxldGVk
X2V2ZW50cyA9IDA7CisJaG9zdC0+ZGF0YV9zdGF0dXMgPSAwOworCisJZGF0YSA9IG1ycS0+ZGF0
YTsKKwlpZiAoZGF0YSkgeworCQlkd19tY2lfc2V0X3RpbWVvdXQoaG9zdCk7CisJCW1jaV93cml0
ZWwoaG9zdCwgQllUQ05ULCBkYXRhLT5ibGtzeipkYXRhLT5ibG9ja3MpOworCQltY2lfd3JpdGVs
KGhvc3QsIEJMS1NJWiwgZGF0YS0+Ymxrc3opOworCX0KKworCWNtZCA9IG1ycS0+Y21kOworCWNt
ZGZsYWdzID0gZHdfbWNpX3ByZXBhcmVfY29tbWFuZChzbG90LT5tbWMsIGNtZCk7CisKKwkvKiB0
aGlzIGlzIHRoZSBmaXJzdCBjb21tYW5kLCBsZXRzIHNlbmQgdGhlIGluaXRpYWxpemF0aW9uIGNs
b2NrICovCisJaWYgKHVubGlrZWx5KAorCQl0ZXN0X2FuZF9jbGVhcl9iaXQoRFdfTU1DX0NBUkRf
TkVFRF9JTklULCAmc2xvdC0+ZmxhZ3MpKSkgeworCQljbWRmbGFncyB8PSBTRE1NQ19DTURfSU5J
VDsKKwl9CisKKwkvKiB3ZSBtYXkgbmVlZCB0byBtb3ZlIHRoaXMgY29kZSB0byBtY2lfc3RhcnRf
Y29tbWFuZCAqLworCWlmIChkYXRhKSB7CisJCWR3X21jaV9zdWJtaXRfZGF0YShob3N0LCBkYXRh
KTsKKwkJd21iKCk7CisJfQorCisJZHdfbWNpX3N0YXJ0X2NvbW1hbmQoaG9zdCwgY21kLCBjbWRm
bGFncyk7CisKKwlpZiAobXJxLT5zdG9wKQorCQlob3N0LT5zdG9wX2NtZHIgPSBkd19tY2lfcHJl
cGFyZV9jb21tYW5kKHNsb3QtPm1tYywgbXJxLT5zdG9wKTsKK30KKworc3RhdGljIHZvaWQgZHdf
bWNpX3F1ZXVlX3JlcXVlc3Qoc3RydWN0IGR3X21jaSAqaG9zdCwgc3RydWN0IGR3X21jaV9zbG90
ICpzbG90LAorCQkJCSBzdHJ1Y3QgbW1jX3JlcXVlc3QgKm1ycSkKK3sKKwlkZXZfdmRiZygmc2xv
dC0+bW1jLT5jbGFzc19kZXYsICJxdWV1ZSByZXF1ZXN0OiBzdGF0ZT0lZFxuIiwKKwkJCWhvc3Qt
PnN0YXRlKTsKKworCXNwaW5fbG9ja19iaCgmaG9zdC0+bG9jayk7CisJc2xvdC0+bXJxID0gbXJx
OworCisJaWYgKGhvc3QtPnN0YXRlID09IFNUQVRFX0lETEUpIHsKKwkJaG9zdC0+c3RhdGUgPSBT
VEFURV9TRU5ESU5HX0NNRDsKKwkJZHdfbWNpX3N0YXJ0X3JlcXVlc3QoaG9zdCwgc2xvdCk7CisJ
fSBlbHNlIHsKKwkJbGlzdF9hZGRfdGFpbCgmc2xvdC0+cXVldWVfbm9kZSwgJmhvc3QtPnF1ZXVl
KTsKKwl9CisKKwlzcGluX3VubG9ja19iaCgmaG9zdC0+bG9jayk7Cit9CisKK3N0YXRpYyB2b2lk
IGR3X21jaV9yZXF1ZXN0KHN0cnVjdCBtbWNfaG9zdCAqbW1jLCBzdHJ1Y3QgbW1jX3JlcXVlc3Qg
Km1ycSkKK3sKKwlzdHJ1Y3QgZHdfbWNpX3Nsb3QgKnNsb3QgPSBtbWNfcHJpdihtbWMpOworCXN0
cnVjdCBkd19tY2kgKmhvc3QgPSBzbG90LT5ob3N0OworCisJV0FSTl9PTihzbG90LT5tcnEpOwor
CisJaWYgKCF0ZXN0X2JpdChEV19NTUNfQ0FSRF9QUkVTRU5ULCAmc2xvdC0+ZmxhZ3MpKSB7CisJ
CW1ycS0+Y21kLT5lcnJvciA9IC1FTk9NRURJVU07CisJCW1tY19yZXF1ZXN0X2RvbmUobW1jLCBt
cnEpOworCQlyZXR1cm47CisJfQorCisJLyogV2UgZG9uJ3Qgc3VwcG9ydCBtdWx0aXBsZSBibG9j
a3Mgb2Ygd2VpcmQgbGVuZ3Rocy4gKi8KKwlkd19tY2lfcXVldWVfcmVxdWVzdChob3N0LCBzbG90
LCBtcnEpOworfQorCitzdGF0aWMgdm9pZCBkd19tY2lfc2V0X2lvcyhzdHJ1Y3QgbW1jX2hvc3Qg
Km1tYywgc3RydWN0IG1tY19pb3MgKmlvcykKK3sKKwlzdHJ1Y3QgZHdfbWNpX3Nsb3QgKnNsb3Qg
PSBtbWNfcHJpdihtbWMpOworCisJLyogc2V0IGRlZmF1bHQgMSBiaXQgbW9kZSAqLworCXNsb3Qt
PmN0eXBlID0gU0RNTUNfQ1RZUEVfMUJJVDsKKworCXN3aXRjaCAoaW9zLT5idXNfd2lkdGgpIHsK
KwljYXNlIE1NQ19CVVNfV0lEVEhfMToKKwkJc2xvdC0+Y3R5cGUgPSBTRE1NQ19DVFlQRV8xQklU
OworCQlicmVhazsKKwljYXNlIE1NQ19CVVNfV0lEVEhfNDoKKwkJc2xvdC0+Y3R5cGUgPSBTRE1N
Q19DVFlQRV80QklUOworCQlicmVhazsKKwl9CisKKwlpZiAoaW9zLT5jbG9jaykgeworCQkvKgor
CQkgKiBVc2UgbWlycm9yIG9mIGlvcy0+Y2xvY2sgdG8gcHJldmVudCByYWNlIHdpdGggbW1jCisJ
CSAqIGNvcmUgaW9zIHVwZGF0ZSB3aGVuIGZpbmRpbmcgdGhlIG1pbmltdW0uCisJCSAqLworCQlz
bG90LT5jbG9jayA9IGlvcy0+Y2xvY2s7CisJfQorCisJc3dpdGNoIChpb3MtPnBvd2VyX21vZGUp
IHsKKwljYXNlIE1NQ19QT1dFUl9VUDoKKwkJc2V0X2JpdChEV19NTUNfQ0FSRF9ORUVEX0lOSVQs
ICZzbG90LT5mbGFncyk7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCWJyZWFrOworCX0KK30KKwor
c3RhdGljIGludCBkd19tY2lfZ2V0X3JvKHN0cnVjdCBtbWNfaG9zdCAqbW1jKQoreworCWludCBy
ZWFkX29ubHk7CisJc3RydWN0IGR3X21jaV9zbG90ICpzbG90ID0gbW1jX3ByaXYobW1jKTsKKwlz
dHJ1Y3QgZHdfbWNpX2JvYXJkICpicmQgPSBzbG90LT5ob3N0LT5wZGF0YTsKKworCWlmIChicmQt
PmdldF9ybyAhPSBOVUxMKSB7CisJCXJlYWRfb25seSA9IGJyZC0+Z2V0X3JvKHNsb3QtPmlkKTsK
Kwl9IGVsc2UgeworCQkvKiBUcnkgb24gYm9hcmQgd3JpdGUgcHJvdGVjdCAqLworCQlyZWFkX29u
bHkgPQorCQkJbWNpX3JlYWRsKHNsb3QtPmhvc3QsIFdSVFBSVCkgJiAoMSA8PCBzbG90LT5pZCkg
PyAxIDogMDsKKwl9CisKKwlkZXZfZGJnKCZtbWMtPmNsYXNzX2RldiwgImNhcmQgaXMgJXNcbiIs
CisJCQkJcmVhZF9vbmx5ID8gInJlYWQtb25seSIgOiAicmVhZC13cml0ZSIpOworCisJcmV0dXJu
IHJlYWRfb25seTsKK30KKworc3RhdGljIGludCBkd19tY2lfZ2V0X2NkKHN0cnVjdCBtbWNfaG9z
dCAqbW1jKQoreworCWludCBwcmVzZW50OworCXN0cnVjdCBkd19tY2lfc2xvdCAqc2xvdCA9IG1t
Y19wcml2KG1tYyk7CisJc3RydWN0IGR3X21jaV9ib2FyZCAqYnJkID0gc2xvdC0+aG9zdC0+cGRh
dGE7CisKKwlpZiAoYnJkLT5nZXRfY2QgIT0gTlVMTCkKKwkJcHJlc2VudCA9ICFicmQtPmdldF9j
ZChzbG90LT5pZCk7CisJZWxzZQkvKiB0cnkgb25ib2FyZCBjYXJkIGRldGVjdCAqLworCQlwcmVz
ZW50ID0gKG1jaV9yZWFkbChzbG90LT5ob3N0LCBDREVURUNUKSAmICgxIDw8IHNsb3QtPmlkKSkK
KwkJCQk9PSAwID8gMSA6IDA7CisKKwlkZXZfZGJnKCZtbWMtPmNsYXNzX2RldiwgImNhcmQgaXMg
JXNwcmVzZW50XG4iLCBwcmVzZW50ID8gIiIgOiAibm90ICIpOworCisJcmV0dXJuIHByZXNlbnQ7
Cit9CisKK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbW1jX2hvc3Rfb3BzIGR3X21jaV9vcHMgPSB7CisJ
LnJlcXVlc3QJPSBkd19tY2lfcmVxdWVzdCwKKwkuc2V0X2lvcwk9IGR3X21jaV9zZXRfaW9zLAor
CS5nZXRfcm8JCT0gZHdfbWNpX2dldF9ybywKKwkuZ2V0X2NkCQk9IGR3X21jaV9nZXRfY2QsCit9
OworCitzdGF0aWMgdm9pZCBkd19tY2lfcmVxdWVzdF9lbmQoc3RydWN0IGR3X21jaSAqaG9zdCwg
c3RydWN0IG1tY19yZXF1ZXN0ICptcnEpCisJX19yZWxlYXNlcygmaG9zdC0+bG9jaykKKwlfX2Fj
cXVpcmVzKCZob3N0LT5sb2NrKQoreworCXN0cnVjdCBkd19tY2lfc2xvdCAqc2xvdDsKKwlzdHJ1
Y3QgbW1jX2hvc3QJKnByZXZfbW1jID0gaG9zdC0+Y3VyX3Nsb3QtPm1tYzsKKworCVdBUk5fT04o
aG9zdC0+Y21kIHx8IGhvc3QtPmRhdGEpOworCisJaG9zdC0+Y3VyX3Nsb3QtPm1ycSA9IE5VTEw7
CisJaG9zdC0+bXJxID0gTlVMTDsKKwlpZiAoIWxpc3RfZW1wdHkoJmhvc3QtPnF1ZXVlKSkgewor
CQlzbG90ID0gbGlzdF9lbnRyeShob3N0LT5xdWV1ZS5uZXh0LAorCQkJCXN0cnVjdCBkd19tY2lf
c2xvdCwgcXVldWVfbm9kZSk7CisJCWxpc3RfZGVsKCZzbG90LT5xdWV1ZV9ub2RlKTsKKwkJZGV2
X3ZkYmcoJmhvc3QtPnBkZXYtPmRldiwgImxpc3Qgbm90IGVtcHR5OiAlcyBpcyBuZXh0XG4iLAor
CQkJCW1tY19ob3N0bmFtZShzbG90LT5tbWMpKTsKKwkJaG9zdC0+c3RhdGUgPSBTVEFURV9TRU5E
SU5HX0NNRDsKKwkJZHdfbWNpX3N0YXJ0X3JlcXVlc3QoaG9zdCwgc2xvdCk7CisJfSBlbHNlIHsK
KwkJZGV2X3ZkYmcoJmhvc3QtPnBkZXYtPmRldiwgImxpc3QgZW1wdHlcbiIpOworCQlob3N0LT5z
dGF0ZSA9IFNUQVRFX0lETEU7CisJfQorCisJc3Bpbl91bmxvY2soJmhvc3QtPmxvY2spOworCW1t
Y19yZXF1ZXN0X2RvbmUocHJldl9tbWMsIG1ycSk7CisKKwlzcGluX2xvY2soJmhvc3QtPmxvY2sp
OworfQorCitzdGF0aWMgdm9pZCBkd19tY2lfY29tbWFuZF9jb21wbGV0ZShzdHJ1Y3QgZHdfbWNp
ICpob3N0LAorCQkJCSAgICBzdHJ1Y3QgbW1jX2NvbW1hbmQgKmNtZCkKK3sKKwl1MzIgc3RhdHVz
ID0gaG9zdC0+Y21kX3N0YXR1czsKKworCWhvc3QtPmNtZF9zdGF0dXMgPSAwOworCisJLyogUmVh
ZCB0aGUgcmVzcG9uc2UgZnJvbSB0aGUgY2FyZCAodXAgdG8gMTYgYnl0ZXMpICovCisJaWYgKGNt
ZC0+ZmxhZ3MgJiBNTUNfUlNQX1BSRVNFTlQpIHsKKwkJaWYgKGNtZC0+ZmxhZ3MgJiBNTUNfUlNQ
XzEzNikgeworCQkJY21kLT5yZXNwWzNdID0gbWNpX3JlYWRsKGhvc3QsIFJFU1AwKTsKKwkJCWNt
ZC0+cmVzcFsyXSA9IG1jaV9yZWFkbChob3N0LCBSRVNQMSk7CisJCQljbWQtPnJlc3BbMV0gPSBt
Y2lfcmVhZGwoaG9zdCwgUkVTUDIpOworCQkJY21kLT5yZXNwWzBdID0gbWNpX3JlYWRsKGhvc3Qs
IFJFU1AzKTsKKwkJfSBlbHNlIHsKKwkJCWNtZC0+cmVzcFswXSA9IG1jaV9yZWFkbChob3N0LCBS
RVNQMCk7CisJCQljbWQtPnJlc3BbMV0gPSAwOworCQkJY21kLT5yZXNwWzJdID0gMDsKKwkJCWNt
ZC0+cmVzcFszXSA9IDA7CisJCX0KKwl9CisKKwlpZiAoc3RhdHVzICYgU0RNTUNfSU5UX1JUTykK
KwkJY21kLT5lcnJvciA9IC1FVElNRURPVVQ7CisJZWxzZSBpZiAoKGNtZC0+ZmxhZ3MgJiBNTUNf
UlNQX0NSQykgJiYgKHN0YXR1cyAmIFNETU1DX0lOVF9SQ1JDKSkKKwkJY21kLT5lcnJvciA9IC1F
SUxTRVE7CisJZWxzZSBpZiAoc3RhdHVzICYgU0RNTUNfSU5UX1JFU1BfRVJSKQorCQljbWQtPmVy
cm9yID0gLUVJTzsKKwllbHNlCisJCWNtZC0+ZXJyb3IgPSAwOworCisJaWYgKGNtZC0+ZXJyb3Ip
IHsKKwkJLyogbmV3ZXIgaXAgdmVyc2lvbnMgbmVlZCBhIGRlbGF5IGJldHdlZW4gcmV0cmllcyAq
LworCQlpZiAoaG9zdC0+cXVpcmtzICYgRFdfTUNJX1FVSVJLX1JFVFJZX0RFTEFZKQorCQkJbWRl
bGF5KDIwKTsKKworCQlpZiAoY21kLT5kYXRhKSB7CisJCQlob3N0LT5kYXRhID0gTlVMTDsKKwkJ
CWR3X21jaV9zdG9wX2RtYShob3N0KTsKKwkJfQorCX0KK30KKworc3RhdGljIHZvaWQgZHdfbWNp
X3Rhc2tsZXRfZnVuYyh1bnNpZ25lZCBsb25nIHByaXYpCit7CisJc3RydWN0IGR3X21jaSAqaG9z
dCA9IChzdHJ1Y3QgZHdfbWNpICopcHJpdjsKKwlzdHJ1Y3QgbW1jX2RhdGEJKmRhdGE7CisJc3Ry
dWN0IG1tY19jb21tYW5kICpjbWQ7CisJZW51bSBkd19tY2lfc3RhdGUgc3RhdGU7CisJZW51bSBk
d19tY2lfc3RhdGUgcHJldl9zdGF0ZTsKKwl1MzIgc3RhdHVzOworCisJc3Bpbl9sb2NrKCZob3N0
LT5sb2NrKTsKKworCXN0YXRlID0gaG9zdC0+c3RhdGU7CisJZGF0YSA9IGhvc3QtPmRhdGE7CisK
KwlkbyB7CisJCXByZXZfc3RhdGUgPSBzdGF0ZTsKKworCQlzd2l0Y2ggKHN0YXRlKSB7CisJCWNh
c2UgU1RBVEVfSURMRToKKwkJCWJyZWFrOworCisJCWNhc2UgU1RBVEVfU0VORElOR19DTUQ6CisJ
CQlpZiAoIXRlc3RfYW5kX2NsZWFyX2JpdChFVkVOVF9DTURfQ09NUExFVEUsCisJCQkJCQkmaG9z
dC0+cGVuZGluZ19ldmVudHMpKQorCQkJCWJyZWFrOworCisJCQljbWQgPSBob3N0LT5jbWQ7CisJ
CQlob3N0LT5jbWQgPSBOVUxMOworCQkJc2V0X2JpdChFVkVOVF9DTURfQ09NUExFVEUsICZob3N0
LT5jb21wbGV0ZWRfZXZlbnRzKTsKKwkJCWR3X21jaV9jb21tYW5kX2NvbXBsZXRlKGhvc3QsIGhv
c3QtPm1ycS0+Y21kKTsKKwkJCWlmICghaG9zdC0+bXJxLT5kYXRhIHx8IGNtZC0+ZXJyb3IpIHsK
KwkJCQlkd19tY2lfcmVxdWVzdF9lbmQoaG9zdCwgaG9zdC0+bXJxKTsKKwkJCQlnb3RvIHVubG9j
azsKKwkJCX0KKworCQkJcHJldl9zdGF0ZSA9IHN0YXRlID0gU1RBVEVfU0VORElOR19EQVRBOwor
CQkJLyogZmFsbCB0aHJvdWdoICovCisKKwkJY2FzZSBTVEFURV9TRU5ESU5HX0RBVEE6CisJCQlp
ZiAodGVzdF9hbmRfY2xlYXJfYml0KEVWRU5UX0RBVEFfRVJST1IsCisJCQkJCSAgICAgICAmaG9z
dC0+cGVuZGluZ19ldmVudHMpKSB7CisJCQkJZHdfbWNpX3N0b3BfZG1hKGhvc3QpOworCQkJCWlm
IChkYXRhLT5zdG9wKQorCQkJCQlzZW5kX3N0b3BfY21kKGhvc3QsIGRhdGEpOworCQkJCXN0YXRl
ID0gU1RBVEVfREFUQV9FUlJPUjsKKwkJCQlicmVhazsKKwkJCX0KKworCQkJaWYgKCF0ZXN0X2Fu
ZF9jbGVhcl9iaXQoRVZFTlRfWEZFUl9DT01QTEVURSwKKwkJCQkJCSZob3N0LT5wZW5kaW5nX2V2
ZW50cykpCisJCQkJYnJlYWs7CisKKwkJCXNldF9iaXQoRVZFTlRfWEZFUl9DT01QTEVURSwgJmhv
c3QtPmNvbXBsZXRlZF9ldmVudHMpOworCQkJcHJldl9zdGF0ZSA9IHN0YXRlID0gU1RBVEVfREFU
QV9CVVNZOworCQkJLyogZmFsbCB0aHJvdWdoICovCisKKwkJY2FzZSBTVEFURV9EQVRBX0JVU1k6
CisJCQlpZiAoIXRlc3RfYW5kX2NsZWFyX2JpdChFVkVOVF9EQVRBX0NPTVBMRVRFLAorCQkJCQkJ
Jmhvc3QtPnBlbmRpbmdfZXZlbnRzKSkKKwkJCQlicmVhazsKKworCQkJaG9zdC0+ZGF0YSA9IE5V
TEw7CisJCQlzZXRfYml0KEVWRU5UX0RBVEFfQ09NUExFVEUsICZob3N0LT5jb21wbGV0ZWRfZXZl
bnRzKTsKKwkJCXN0YXR1cyA9IGhvc3QtPmRhdGFfc3RhdHVzOworCisJCQlpZiAodW5saWtlbHko
c3RhdHVzICYgRFdfTUNJX0RBVEFfRVJST1JfRkxBR1MpKSB7CisJCQkJaWYgKHN0YXR1cyAmIFNE
TU1DX0lOVF9EVE8pIHsKKwkJCQkJZGV2X2VycigmaG9zdC0+cGRldi0+ZGV2LAorCQkJCQkJCSJk
YXRhIHRpbWVvdXQgZXJyb3JcbiIpOworCQkJCQlkYXRhLT5lcnJvciA9IC1FVElNRURPVVQ7CisJ
CQkJfSBlbHNlIGlmIChzdGF0dXMgJiBTRE1NQ19JTlRfRENSQykgeworCQkJCQlkZXZfZXJyKCZo
b3N0LT5wZGV2LT5kZXYsCisJCQkJCQkJImRhdGEgQ1JDIGVycm9yXG4iKTsKKwkJCQkJZGF0YS0+
ZXJyb3IgPSAtRUlMU0VROworCQkJCX0gZWxzZSB7CisJCQkJCWRldl9lcnIoJmhvc3QtPnBkZXYt
PmRldiwKKwkJCQkJCSJkYXRhIEZJRk8gZXJyb3IgIgorCQkJCQkJIihzdGF0dXM9JTA4eClcbiIs
CisJCQkJCQlzdGF0dXMpOworCQkJCQlkYXRhLT5lcnJvciA9IC1FSU87CisJCQkJfQorCQkJfSBl
bHNlIHsKKwkJCQlkYXRhLT5ieXRlc194ZmVyZWQgPSBkYXRhLT5ibG9ja3MgKiBkYXRhLT5ibGtz
ejsKKwkJCQlkYXRhLT5lcnJvciA9IDA7CisJCQl9CisKKwkJCWlmICghZGF0YS0+c3RvcCkgewor
CQkJCWR3X21jaV9yZXF1ZXN0X2VuZChob3N0LCBob3N0LT5tcnEpOworCQkJCWdvdG8gdW5sb2Nr
OworCQkJfQorCisJCQlwcmV2X3N0YXRlID0gc3RhdGUgPSBTVEFURV9TRU5ESU5HX1NUT1A7CisJ
CQlpZiAoIWRhdGEtPmVycm9yKQorCQkJCXNlbmRfc3RvcF9jbWQoaG9zdCwgZGF0YSk7CisJCQkv
KiBmYWxsIHRocm91Z2ggKi8KKworCQljYXNlIFNUQVRFX1NFTkRJTkdfU1RPUDoKKwkJCWlmICgh
dGVzdF9hbmRfY2xlYXJfYml0KEVWRU5UX0NNRF9DT01QTEVURSwKKwkJCQkJCSZob3N0LT5wZW5k
aW5nX2V2ZW50cykpCisJCQkJYnJlYWs7CisKKwkJCWhvc3QtPmNtZCA9IE5VTEw7CisJCQlkd19t
Y2lfY29tbWFuZF9jb21wbGV0ZShob3N0LCBob3N0LT5tcnEtPnN0b3ApOworCQkJZHdfbWNpX3Jl
cXVlc3RfZW5kKGhvc3QsIGhvc3QtPm1ycSk7CisJCQlnb3RvIHVubG9jazsKKworCQljYXNlIFNU
QVRFX0RBVEFfRVJST1I6CisJCQlpZiAoIXRlc3RfYW5kX2NsZWFyX2JpdChFVkVOVF9YRkVSX0NP
TVBMRVRFLAorCQkJCQkJJmhvc3QtPnBlbmRpbmdfZXZlbnRzKSkKKwkJCQlicmVhazsKKworCQkJ
c3RhdGUgPSBTVEFURV9EQVRBX0JVU1k7CisJCQlicmVhazsKKwkJfQorCX0gd2hpbGUgKHN0YXRl
ICE9IHByZXZfc3RhdGUpOworCisJaG9zdC0+c3RhdGUgPSBzdGF0ZTsKK3VubG9jazoKKwlzcGlu
X3VubG9jaygmaG9zdC0+bG9jayk7CisKK30KKworc3RhdGljIHZvaWQgZHdfbWNpX3B1c2hfZGF0
YTE2KHN0cnVjdCBkd19tY2kgKmhvc3QsIHZvaWQgKmJ1ZiwgaW50IGNudCkKK3sKKwl1MTYgKnBE
YXRhID0gKHUxNiAqKWJ1ZjsKKworCVdBUk5fT04oY250ICUgMiAhPSAwKTsKKworCWNudCA9IGNu
dCA+PiAxOworCXdoaWxlIChjbnQgPiAwKSB7CisJCW1jaV93cml0ZXcoaG9zdCwgREFUQSwgKnBE
YXRhKyspOworCQljbnQtLTsKKwl9Cit9CisKK3N0YXRpYyB2b2lkIGR3X21jaV9wdWxsX2RhdGEx
NihzdHJ1Y3QgZHdfbWNpICpob3N0LCB2b2lkICpidWYsIGludCBjbnQpCit7CisJdTE2ICpwRGF0
YSA9ICh1MTYgKilidWY7CisKKwlXQVJOX09OKGNudCAlIDIgIT0gMCk7CisKKwljbnQgPSBjbnQg
Pj4gMTsKKwl3aGlsZSAoY250ID4gMCkgeworCQkqcERhdGErKyA9IG1jaV9yZWFkdyhob3N0LCBE
QVRBKTsKKwkJY250LS07CisJfQorfQorCitzdGF0aWMgdm9pZCBkd19tY2lfcHVzaF9kYXRhMzIo
c3RydWN0IGR3X21jaSAqaG9zdCwgdm9pZCAqYnVmLCBpbnQgY250KQoreworCXUzMiAqcERhdGEg
PSAodTMyICopYnVmOworCisJV0FSTl9PTihjbnQgJSA0ICE9IDApOworCVdBUk5fT04oKHVuc2ln
bmVkIGxvbmcpcERhdGEgJiAweDMpOworCisJY250ID0gY250ID4+IDI7CisJd2hpbGUgKGNudCA+
IDApIHsKKwkJbWNpX3dyaXRlbChob3N0LCBEQVRBLCAqcERhdGErKyk7CisJCWNudC0tOworCX0K
K30KKworc3RhdGljIHZvaWQgZHdfbWNpX3B1bGxfZGF0YTMyKHN0cnVjdCBkd19tY2kgKmhvc3Qs
IHZvaWQgKmJ1ZiwgaW50IGNudCkKK3sKKwl1MzIgKnBEYXRhID0gKHUzMiAqKWJ1ZjsKKworCVdB
Uk5fT04oY250ICUgNCAhPSAwKTsKKwlXQVJOX09OKCh1bnNpZ25lZCBsb25nKXBEYXRhICYgMHgz
KTsKKworCWNudCA9IGNudCA+PiAyOworCXdoaWxlIChjbnQgPiAwKSB7CisJCSpwRGF0YSsrID0g
bWNpX3JlYWRsKGhvc3QsIERBVEEpOworCQljbnQtLTsKKwl9Cit9CisKK3N0YXRpYyB2b2lkIGR3
X21jaV9wdXNoX2RhdGE2NChzdHJ1Y3QgZHdfbWNpICpob3N0LCB2b2lkICpidWYsIGludCBjbnQp
Cit7CisJdTY0ICpwRGF0YSA9ICh1NjQgKilidWY7CisKKwlXQVJOX09OKGNudCAlIDggIT0gMCk7
CisKKwljbnQgPSBjbnQgPj4gMzsKKwl3aGlsZSAoY250ID4gMCkgeworCQltY2lfd3JpdGVxKGhv
c3QsIERBVEEsICpwRGF0YSsrKTsKKwkJY250LS07CisJfQorfQorCitzdGF0aWMgdm9pZCBkd19t
Y2lfcHVsbF9kYXRhNjQoc3RydWN0IGR3X21jaSAqaG9zdCwgdm9pZCAqYnVmLCBpbnQgY250KQor
eworCXU2NCAqcERhdGEgPSAodTY0ICopYnVmOworCisJV0FSTl9PTihjbnQgJSA4ICE9IDApOwor
CisJY250ID0gY250ID4+IDM7CisJd2hpbGUgKGNudCA+IDApIHsKKwkJKnBEYXRhKysgPSBtY2lf
cmVhZHEoaG9zdCwgREFUQSk7CisJCWNudC0tOworCX0KK30KKworc3RhdGljIHZvaWQgZHdfbWNp
X3JlYWRfZGF0YV9waW8oc3RydWN0IGR3X21jaSAqaG9zdCkKK3sKKwlzdHJ1Y3Qgc2NhdHRlcmxp
c3QgKnNnID0gaG9zdC0+c2c7CisJdm9pZCAqYnVmID0gc2dfdmlydChzZyk7CisJdW5zaWduZWQg
aW50IG9mZnNldCA9IGhvc3QtPnBpb19vZmZzZXQ7CisJc3RydWN0IG1tY19kYXRhCSpkYXRhID0g
aG9zdC0+ZGF0YTsKKwlpbnQgc2hpZnQgPSBob3N0LT5kYXRhX3NoaWZ0OworCXUzMiBzdGF0dXM7
CisJdW5zaWduZWQgaW50IG5ieXRlcyA9IDAsIGxlbiwgb2xkX2xlbiwgY291bnQgPSAwOworCisJ
ZG8geworCQlsZW4gPSBTRE1NQ19HRVRfRkNOVChtY2lfcmVhZGwoaG9zdCwgU1RBVFVTKSkgPDwg
c2hpZnQ7CisJCWlmIChjb3VudCA9PSAwKQorCQkJb2xkX2xlbiA9IGxlbjsKKworCQlpZiAobGlr
ZWx5KG9mZnNldCArIGxlbiA8PSBzZy0+bGVuZ3RoKSkgeworCQkJaG9zdC0+cHVsbF9kYXRhKGhv
c3QsICh2b2lkICopKGJ1ZiArIG9mZnNldCksIGxlbik7CisKKwkJCW9mZnNldCArPSBsZW47CisJ
CQluYnl0ZXMgKz0gbGVuOworCisJCQlpZiAob2Zmc2V0ID09IHNnLT5sZW5ndGgpIHsKKwkJCQlm
bHVzaF9kY2FjaGVfcGFnZShzZ19wYWdlKHNnKSk7CisJCQkJaG9zdC0+c2cgPSBzZyA9IHNnX25l
eHQoc2cpOworCQkJCWlmICghc2cpCisJCQkJCWdvdG8gZG9uZTsKKworCQkJCW9mZnNldCA9IDA7
CisJCQkJYnVmID0gc2dfdmlydChzZyk7CisJCQl9CisJCX0gZWxzZSB7CisJCQl1bnNpZ25lZCBp
bnQgcmVtYWluaW5nID0gc2ctPmxlbmd0aCAtIG9mZnNldDsKKwkJCWhvc3QtPnB1bGxfZGF0YSho
b3N0LAorCQkJCSh2b2lkICopKGJ1ZiArIG9mZnNldCksIHJlbWFpbmluZyk7CisJCQluYnl0ZXMg
Kz0gcmVtYWluaW5nOworCisJCQlmbHVzaF9kY2FjaGVfcGFnZShzZ19wYWdlKHNnKSk7CisJCQlo
b3N0LT5zZyA9IHNnID0gc2dfbmV4dChzZyk7CisJCQlpZiAoIXNnKQorCQkJCWdvdG8gZG9uZTsK
KworCQkJb2Zmc2V0ID0gbGVuIC0gcmVtYWluaW5nOworCQkJYnVmID0gc2dfdmlydChzZyk7CisJ
CQlob3N0LT5wdWxsX2RhdGEoaG9zdCwgYnVmLCBvZmZzZXQpOworCQkJbmJ5dGVzICs9IG9mZnNl
dDsKKwkJfQorCisJCXN0YXR1cyA9IG1jaV9yZWFkbChob3N0LCBNSU5UU1RTKTsKKwkJbWNpX3dy
aXRlbChob3N0LCBSSU5UU1RTLCBTRE1NQ19JTlRfUlhEUik7CisJCWlmIChzdGF0dXMgJiBEV19N
Q0lfREFUQV9FUlJPUl9GTEFHUykgeworCQkJaG9zdC0+ZGF0YV9zdGF0dXMgPSBzdGF0dXM7CisJ
CQlkYXRhLT5ieXRlc194ZmVyZWQgKz0gbmJ5dGVzOworCQkJc21wX3dtYigpOworCisJCQlzZXRf
Yml0KEVWRU5UX0RBVEFfRVJST1IsICZob3N0LT5wZW5kaW5nX2V2ZW50cyk7CisKKwkJCXRhc2ts
ZXRfc2NoZWR1bGUoJmhvc3QtPnRhc2tsZXQpOworCQkJcmV0dXJuOworCQl9CisJCWNvdW50Kys7
CisJfSB3aGlsZSAoc3RhdHVzICYgU0RNTUNfSU5UX1JYRFIpOyAvKmlmIHRoZSBSWERSIGlzIHJl
YWR5CisJCQkJCQlsZXRzIHJlYWQgYWdhaW4qLworCWxlbiA9IFNETU1DX0dFVF9GQ05UKG1jaV9y
ZWFkbChob3N0LCBTVEFUVVMpKTsKKwlob3N0LT5waW9fb2Zmc2V0ID0gb2Zmc2V0OworCWRhdGEt
PmJ5dGVzX3hmZXJlZCArPSBuYnl0ZXM7CisJcmV0dXJuOworCitkb25lOgorCWRhdGEtPmJ5dGVz
X3hmZXJlZCArPSBuYnl0ZXM7CisJc21wX3dtYigpOworCXNldF9iaXQoRVZFTlRfWEZFUl9DT01Q
TEVURSwgJmhvc3QtPnBlbmRpbmdfZXZlbnRzKTsKK30KKworc3RhdGljIHZvaWQgZHdfbWNpX3dy
aXRlX2RhdGFfcGlvKHN0cnVjdCBkd19tY2kgKmhvc3QpCit7CisJc3RydWN0IHNjYXR0ZXJsaXN0
ICpzZyA9IGhvc3QtPnNnOworCXZvaWQgKmJ1ZiA9IHNnX3ZpcnQoc2cpOworCXVuc2lnbmVkIGlu
dCBvZmZzZXQgPSBob3N0LT5waW9fb2Zmc2V0OworCXN0cnVjdCBtbWNfZGF0YQkqZGF0YSA9IGhv
c3QtPmRhdGE7CisJaW50IHNoaWZ0ID0gaG9zdC0+ZGF0YV9zaGlmdDsKKwl1MzIgc3RhdHVzOwor
CXVuc2lnbmVkIGludCBuYnl0ZXMgPSAwLCBsZW47CisKKwlkbyB7CisJCWxlbiA9IFNETU1DX0ZJ
Rk9fU1ogLQorCQkJKFNETU1DX0dFVF9GQ05UKG1jaV9yZWFkbChob3N0LCBTVEFUVVMpKSA8PCBz
aGlmdCk7CisJCWlmIChsaWtlbHkob2Zmc2V0ICsgbGVuIDw9IHNnLT5sZW5ndGgpKSB7CisJCQlo
b3N0LT5wdXNoX2RhdGEoaG9zdCwgKHZvaWQgKikoYnVmICsgb2Zmc2V0KSwgbGVuKTsKKworCQkJ
b2Zmc2V0ICs9IGxlbjsKKwkJCW5ieXRlcyArPSBsZW47CisJCQlpZiAob2Zmc2V0ID09IHNnLT5s
ZW5ndGgpIHsKKwkJCQlob3N0LT5zZyA9IHNnID0gc2dfbmV4dChzZyk7CisJCQkJaWYgKCFzZykK
KwkJCQkJZ290byBkb25lOworCisJCQkJb2Zmc2V0ID0gMDsKKwkJCQlidWYgPSBzZ192aXJ0KHNn
KTsKKwkJCX0KKwkJfSBlbHNlIHsKKwkJCXVuc2lnbmVkIGludCByZW1haW5pbmcgPSBzZy0+bGVu
Z3RoIC0gb2Zmc2V0OworCisJCQlob3N0LT5wdXNoX2RhdGEoaG9zdCwKKwkJCQkodm9pZCAqKShi
dWYgKyBvZmZzZXQpLCByZW1haW5pbmcpOworCQkJbmJ5dGVzICs9IHJlbWFpbmluZzsKKworCQkJ
aG9zdC0+c2cgPSBzZyA9IHNnX25leHQoc2cpOworCQkJaWYgKCFzZykKKwkJCQlnb3RvIGRvbmU7
CisKKwkJCW9mZnNldCA9IGxlbiAtIHJlbWFpbmluZzsKKwkJCWJ1ZiA9IHNnX3ZpcnQoc2cpOwor
CQkJaG9zdC0+cHVzaF9kYXRhKGhvc3QsICh2b2lkICopYnVmLCBvZmZzZXQpOworCQkJbmJ5dGVz
ICs9IG9mZnNldDsKKwkJfQorCisJCXN0YXR1cyA9IG1jaV9yZWFkbChob3N0LCBNSU5UU1RTKTsK
KwkJbWNpX3dyaXRlbChob3N0LCBSSU5UU1RTLCBTRE1NQ19JTlRfVFhEUik7CisJCWlmIChzdGF0
dXMgJiBEV19NQ0lfREFUQV9FUlJPUl9GTEFHUykgeworCQkJaG9zdC0+ZGF0YV9zdGF0dXMgPSBz
dGF0dXM7CisJCQlkYXRhLT5ieXRlc194ZmVyZWQgKz0gbmJ5dGVzOworCisJCQlzbXBfd21iKCk7
CisKKwkJCXNldF9iaXQoRVZFTlRfREFUQV9FUlJPUiwgJmhvc3QtPnBlbmRpbmdfZXZlbnRzKTsK
KworCQkJdGFza2xldF9zY2hlZHVsZSgmaG9zdC0+dGFza2xldCk7CisJCQlyZXR1cm47CisJCX0K
Kwl9IHdoaWxlIChzdGF0dXMgJiBTRE1NQ19JTlRfVFhEUik7IC8qIGlmIFRYRFIsIGxldHMgd3Jp
dGUgYWdhaW4gKi8KKworCWhvc3QtPnBpb19vZmZzZXQgPSBvZmZzZXQ7CisJZGF0YS0+Ynl0ZXNf
eGZlcmVkICs9IG5ieXRlczsKKworCXJldHVybjsKKworZG9uZToKKwlkYXRhLT5ieXRlc194ZmVy
ZWQgKz0gbmJ5dGVzOworCXNtcF93bWIoKTsKKwlzZXRfYml0KEVWRU5UX1hGRVJfQ09NUExFVEUs
ICZob3N0LT5wZW5kaW5nX2V2ZW50cyk7Cit9CisKK3N0YXRpYyB2b2lkIGR3X21jaV9jbWRfaW50
ZXJydXB0KHN0cnVjdCBkd19tY2kgKmhvc3QsIHUzMiBzdGF0dXMpCit7CisJaWYgKCFob3N0LT5j
bWRfc3RhdHVzKQorCQlob3N0LT5jbWRfc3RhdHVzID0gc3RhdHVzOworCisJc21wX3dtYigpOwor
CisJc2V0X2JpdChFVkVOVF9DTURfQ09NUExFVEUsICZob3N0LT5wZW5kaW5nX2V2ZW50cyk7CisJ
dGFza2xldF9zY2hlZHVsZSgmaG9zdC0+dGFza2xldCk7Cit9CisKK3N0YXRpYyBpcnFyZXR1cm5f
dCBkd19tY2lfaW50ZXJydXB0KGludCBpcnEsIHZvaWQgKmRldl9pZCkKK3sKKwlzdHJ1Y3QgZHdf
bWNpICpob3N0ID0gZGV2X2lkOworCXUzMiBzdGF0dXMsICBwZW5kaW5nOworCXVuc2lnbmVkIGlu
dCBwYXNzX2NvdW50ID0gMDsKKworCWRvIHsKKwkJc3RhdHVzID0gbWNpX3JlYWRsKGhvc3QsIFJJ
TlRTVFMpOworCQlwZW5kaW5nID0gbWNpX3JlYWRsKGhvc3QsIE1JTlRTVFMpOy8qIHJlYWQgb25s
eSBtYXNrIHJlZyAqLworCisJCS8qCisJCSAqIERUTyBmaXggLSB2ZXJzaW9uIDIuMTBhIGFuZCBi
ZWxvdywgYW5kIG9ubHkgaWYgaW50ZXJuYWwgRE1BCisJCSAqIGlzIGNvbmZpZ3VyZWQuCisJCSAq
LworCQlpZiAoaG9zdC0+cXVpcmtzICYgRFdfTUNJX1FVSVJLX0lETUFDX0RUTykgeworCQkJaWYg
KCFwZW5kaW5nICYmCisJCQkgICAgKChtY2lfcmVhZGwoaG9zdCwgU1RBVFVTKSA+PiAxNykgJiAw
eDFmZmYpKQorCQkJCXBlbmRpbmcgfD0gU0RNTUNfSU5UX0RBVEFfT1ZFUjsKKwkJfQorCisJCWlm
ICghcGVuZGluZykKKwkJCWJyZWFrOworCisJCWlmIChwZW5kaW5nICYgRFdfTUNJX0NNRF9FUlJP
Ul9GTEFHUykgeworCQkJbWNpX3dyaXRlbChob3N0LCBSSU5UU1RTLCBEV19NQ0lfQ01EX0VSUk9S
X0ZMQUdTKTsKKwkJCWhvc3QtPmNtZF9zdGF0dXMgPSBzdGF0dXM7CisJCQlzbXBfd21iKCk7CisJ
CQlzZXRfYml0KEVWRU5UX0NNRF9DT01QTEVURSwgJmhvc3QtPnBlbmRpbmdfZXZlbnRzKTsKKwkJ
CXRhc2tsZXRfc2NoZWR1bGUoJmhvc3QtPnRhc2tsZXQpOworCQl9CisKKwkJaWYgKHBlbmRpbmcg
JiBEV19NQ0lfREFUQV9FUlJPUl9GTEFHUykgeworCQkJLyogaWYgdGhlcmUgaXMgYW4gZXJyb3Is
IGxldHMgcmVwb3J0IERBVEFfRVJST1IgKi8KKwkJCW1jaV93cml0ZWwoaG9zdCwgUklOVFNUUywg
RFdfTUNJX0RBVEFfRVJST1JfRkxBR1MpOworCQkJaG9zdC0+ZGF0YV9zdGF0dXMgPSBzdGF0dXM7
CisJCQlzbXBfd21iKCk7CisJCQlzZXRfYml0KEVWRU5UX0RBVEFfRVJST1IsICZob3N0LT5wZW5k
aW5nX2V2ZW50cyk7CisJCQl0YXNrbGV0X3NjaGVkdWxlKCZob3N0LT50YXNrbGV0KTsKKwkJfQor
CisKKwkJaWYgKHBlbmRpbmcgJiBTRE1NQ19JTlRfREFUQV9PVkVSKSB7CisJCQltY2lfd3JpdGVs
KGhvc3QsIFJJTlRTVFMsIFNETU1DX0lOVF9EQVRBX09WRVIpOworCQkJaWYgKCFob3N0LT5kYXRh
X3N0YXR1cykKKwkJCQlob3N0LT5kYXRhX3N0YXR1cyA9IHN0YXR1czsKKwkJCXNtcF93bWIoKTsK
KwkJCWlmIChob3N0LT5kaXJfc3RhdHVzID09IERXX01DSV9SRUNWX1NUQVRVUykgeworCQkJCWlm
IChob3N0LT5zZyAhPSBOVUxMKQorCQkJCQlkd19tY2lfcmVhZF9kYXRhX3Bpbyhob3N0KTsKKwkJ
CX0KKwkJCXNldF9iaXQoRVZFTlRfREFUQV9DT01QTEVURSwgJmhvc3QtPnBlbmRpbmdfZXZlbnRz
KTsKKwkJCXRhc2tsZXRfc2NoZWR1bGUoJmhvc3QtPnRhc2tsZXQpOworCQl9CisKKwkJaWYgKHBl
bmRpbmcgJiBTRE1NQ19JTlRfUlhEUikgeworCQkJbWNpX3dyaXRlbChob3N0LCBSSU5UU1RTLCBT
RE1NQ19JTlRfUlhEUik7CisJCQlpZiAoaG9zdC0+c2cpCisJCQkJZHdfbWNpX3JlYWRfZGF0YV9w
aW8oaG9zdCk7CisJCX0KKworCQlpZiAocGVuZGluZyAmIFNETU1DX0lOVF9UWERSKSB7CisJCQlt
Y2lfd3JpdGVsKGhvc3QsIFJJTlRTVFMsIFNETU1DX0lOVF9UWERSKTsKKwkJCWlmIChob3N0LT5z
ZykKKwkJCQlkd19tY2lfd3JpdGVfZGF0YV9waW8oaG9zdCk7CisJCX0KKworCQlpZiAocGVuZGlu
ZyAmIFNETU1DX0lOVF9DTURfRE9ORSkgeworCQkJbWNpX3dyaXRlbChob3N0LCBSSU5UU1RTLCBT
RE1NQ19JTlRfQ01EX0RPTkUpOworCQkJZHdfbWNpX2NtZF9pbnRlcnJ1cHQoaG9zdCwgc3RhdHVz
KTsKKwkJfQorCisJCWlmIChwZW5kaW5nICYgU0RNTUNfSU5UX0NEKSB7CisJCQltY2lfd3JpdGVs
KGhvc3QsIFJJTlRTVFMsIFNETU1DX0lOVF9DRCk7CisJCQl0YXNrbGV0X3NjaGVkdWxlKCZob3N0
LT5jYXJkX3Rhc2tsZXQpOworCQl9CisKKwl9IHdoaWxlIChwYXNzX2NvdW50KysgPCA1KTsKKwor
I2lmZGVmIENPTkZJR19NTUNfRFdfSURNQUMKKwkvKiBIYW5kbGUgRE1BIGludGVycnVwdHMgKi8K
KwlwZW5kaW5nID0gbWNpX3JlYWRsKGhvc3QsIElEU1RTKTsKKwlpZiAocGVuZGluZyAmIChTRE1N
Q19JRE1BQ19JTlRfVEkgfCBTRE1NQ19JRE1BQ19JTlRfUkkpKSB7CisJCW1jaV93cml0ZWwoaG9z
dCwgSURTVFMsIFNETU1DX0lETUFDX0lOVF9USSB8CisJCQkJU0RNTUNfSURNQUNfSU5UX1JJKTsK
KwkJbWNpX3dyaXRlbChob3N0LCBJRFNUUywgU0RNTUNfSURNQUNfSU5UX05JKTsKKwkJc2V0X2Jp
dChFVkVOVF9EQVRBX0NPTVBMRVRFLCAmaG9zdC0+cGVuZGluZ19ldmVudHMpOworCQlob3N0LT5k
bWFfb3BzLT5jb21wbGV0ZShob3N0KTsKKwl9CisjZW5kaWYKKworCXJldHVybiBJUlFfSEFORExF
RDsKK30KKworc3RhdGljIHZvaWQgZHdfbWNpX3Rhc2tsZXRfY2FyZCh1bnNpZ25lZCBsb25nIGRh
dGEpCit7CisJc3RydWN0IGR3X21jaSAqaG9zdCA9IChzdHJ1Y3QgZHdfbWNpICopZGF0YTsKKwlp
bnQgaTsKKworCWZvciAoaSA9IDA7IGkgPCBob3N0LT5udW1fc2xvdHM7IGkrKykgeworCQlzdHJ1
Y3QgZHdfbWNpX3Nsb3QgKnNsb3QgPSBob3N0LT5zbG90W2ldOworCQlzdHJ1Y3QgbW1jX2hvc3Qg
Km1tYyA9IHNsb3QtPm1tYzsKKwkJc3RydWN0IG1tY19yZXF1ZXN0ICptcnE7CisJCWludCBwcmVz
ZW50OworCQl1MzIgY3RybDsKKworCQlwcmVzZW50ID0gZHdfbWNpX2dldF9jZChtbWMpOworCQl3
aGlsZSAocHJlc2VudCAhPSBzbG90LT5sYXN0X2RldGVjdF9zdGF0ZSkgeworCQkJc3Bpbl9sb2Nr
KCZob3N0LT5sb2NrKTsKKworCQkJZGV2X2RiZygmc2xvdC0+bW1jLT5jbGFzc19kZXYsICJjYXJk
ICVzXG4iLAorCQkJCQlwcmVzZW50ID8gImluc2VydGVkIiA6ICJyZW1vdmVkIik7CisKKwkJCS8q
IENhcmQgY2hhbmdlIGRldGVjdGVkICovCisJCQlzbG90LT5sYXN0X2RldGVjdF9zdGF0ZSA9IHBy
ZXNlbnQ7CisKKwkJCS8qIFBvd2VyIHVwIHNsb3QgKi8KKwkJCWlmIChwcmVzZW50ICE9IDApIHsK
KwkJCQlpZiAoaG9zdC0+cGRhdGEtPnNldHBvd2VyKQorCQkJCQlob3N0LT5wZGF0YS0+c2V0cG93
ZXIoc2xvdC0+aWQsCisJCQkJCQltbWMtPm9jcl9hdmFpbCk7CisKKwkJCQlzZXRfYml0KERXX01N
Q19DQVJEX1BSRVNFTlQsICZzbG90LT5mbGFncyk7CisJCQl9CisKKwkJCS8qIENsZWFuIHVwIHF1
ZXVlIGlmIHByZXNlbnQgKi8KKwkJCW1ycSA9IHNsb3QtPm1ycTsKKwkJCWlmIChtcnEpIHsKKwkJ
CQlpZiAobXJxID09IGhvc3QtPm1ycSkgeworCQkJCQlob3N0LT5kYXRhID0gTlVMTDsKKwkJCQkJ
aG9zdC0+Y21kID0gTlVMTDsKKworCQkJCQlzd2l0Y2ggKGhvc3QtPnN0YXRlKSB7CisJCQkJCWNh
c2UgU1RBVEVfSURMRToKKwkJCQkJCWJyZWFrOworCQkJCQljYXNlIFNUQVRFX1NFTkRJTkdfQ01E
OgorCQkJCQkJbXJxLT5jbWQtPmVycm9yID0gLUVOT01FRElVTTsKKwkJCQkJCWlmICghbXJxLT5k
YXRhKQorCQkJCQkJCWJyZWFrOworCQkJCQkJLyogZmFsbCB0aHJvdWdoICovCisJCQkJCWNhc2Ug
U1RBVEVfU0VORElOR19EQVRBOgorCQkJCQkJbXJxLT5kYXRhLT5lcnJvciA9IC1FTk9NRURJVU07
CisJCQkJCQlkd19tY2lfc3RvcF9kbWEoaG9zdCk7CisJCQkJCQlicmVhazsKKwkJCQkJY2FzZSBT
VEFURV9EQVRBX0JVU1k6CisJCQkJCWNhc2UgU1RBVEVfREFUQV9FUlJPUjoKKwkJCQkJCWlmICht
cnEtPmRhdGEtPmVycm9yID09IC1FSU5QUk9HUkVTUykKKwkJCQkJCQltcnEtPmRhdGEtPmVycm9y
ID0gLUVOT01FRElVTTsKKwkJCQkJCWlmICghbXJxLT5zdG9wKQorCQkJCQkJCWJyZWFrOworCQkJ
CQkJLyogZmFsbCB0aHJvdWdoICovCisJCQkJCWNhc2UgU1RBVEVfU0VORElOR19TVE9QOgorCQkJ
CQkJbXJxLT5zdG9wLT5lcnJvciA9IC1FTk9NRURJVU07CisJCQkJCQlicmVhazsKKwkJCQkJfQor
CisJCQkJCWR3X21jaV9yZXF1ZXN0X2VuZChob3N0LCBtcnEpOworCQkJCX0gZWxzZSB7CisJCQkJ
CWxpc3RfZGVsKCZzbG90LT5xdWV1ZV9ub2RlKTsKKwkJCQkJbXJxLT5jbWQtPmVycm9yID0gLUVO
T01FRElVTTsKKwkJCQkJaWYgKG1ycS0+ZGF0YSkKKwkJCQkJCW1ycS0+ZGF0YS0+ZXJyb3IgPSAt
RU5PTUVESVVNOworCQkJCQlpZiAobXJxLT5zdG9wKQorCQkJCQkJbXJxLT5zdG9wLT5lcnJvciA9
IC1FTk9NRURJVU07CisKKwkJCQkJc3Bpbl91bmxvY2soJmhvc3QtPmxvY2spOworCQkJCQltbWNf
cmVxdWVzdF9kb25lKHNsb3QtPm1tYywgbXJxKTsKKwkJCQkJc3Bpbl9sb2NrKCZob3N0LT5sb2Nr
KTsKKwkJCQl9CisJCQl9CisKKwkJCS8qIFBvd2VyIGRvd24gc2xvdCAqLworCQkJaWYgKHByZXNl
bnQgPT0gMCkgeworCQkJCWlmIChob3N0LT5wZGF0YS0+c2V0cG93ZXIpCisJCQkJCWhvc3QtPnBk
YXRhLT5zZXRwb3dlcihzbG90LT5pZCwgMCk7CisJCQkJY2xlYXJfYml0KERXX01NQ19DQVJEX1BS
RVNFTlQsICZzbG90LT5mbGFncyk7CisKKwkJCQkvKgorCQkJCSAqIENsZWFyIGRvd24gdGhlIEZJ
Rk8gLSBkb2luZyBzbyBnZW5lcmF0ZXMgYQorCQkJCSAqIGJsb2NrIGludGVycnVwdCwgaGVuY2Ug
c2V0dGluZyB0aGUKKwkJCQkgKiBzY2F0dGVyLWdhdGhlciBwb2ludGVyIHRvIE5VTEwuCisJCQkJ
ICovCisJCQkJaG9zdC0+c2cgPSBOVUxMOworCisJCQkJY3RybCA9IG1jaV9yZWFkbChob3N0LCBD
VFJMKTsKKwkJCQljdHJsIHw9IFNETU1DX0NUUkxfRklGT19SRVNFVDsKKwkJCQltY2lfd3JpdGVs
KGhvc3QsIENUUkwsIGN0cmwpOworCisjaWZkZWYgQ09ORklHX01NQ19EV19JRE1BQworCQkJCWN0
cmwgPSBtY2lfcmVhZGwoaG9zdCwgQk1PRCk7CisJCQkJY3RybCB8PSAweDAxOwkvKiBTb2Z0d2Fy
ZSByZXNldCBvZiBETUEgKi8KKwkJCQltY2lfd3JpdGVsKGhvc3QsIEJNT0QsIGN0cmwpOworI2Vu
ZGlmCisKKwkJCX0KKworCQkJc3Bpbl91bmxvY2soJmhvc3QtPmxvY2spOworCQkJcHJlc2VudCA9
IGR3X21jaV9nZXRfY2QobW1jKTsKKwkJfQorCisJCW1tY19kZXRlY3RfY2hhbmdlKHNsb3QtPm1t
YywKKwkJCW1zZWNzX3RvX2ppZmZpZXMoaG9zdC0+cGRhdGEtPmRldGVjdF9kZWxheV9tcykpOwor
CX0KK30KKworc3RhdGljIGludCBfX2luaXQgZHdfbWNpX2luaXRfc2xvdChzdHJ1Y3QgZHdfbWNp
ICpob3N0LCB1bnNpZ25lZCBpbnQgaWQpCit7CisJc3RydWN0IG1tY19ob3N0ICptbWM7CisJc3Ry
dWN0IGR3X21jaV9zbG90ICpzbG90OworCisJbW1jID0gbW1jX2FsbG9jX2hvc3Qoc2l6ZW9mKHN0
cnVjdCBkd19tY2lfc2xvdCksICZob3N0LT5wZGV2LT5kZXYpOworCWlmICghbW1jKQorCQlyZXR1
cm4gLUVOT01FTTsKKworCXNsb3QgPSBtbWNfcHJpdihtbWMpOworCXNsb3QtPmlkID0gaWQ7CisJ
c2xvdC0+bW1jID0gbW1jOworCXNsb3QtPmhvc3QgPSBob3N0OworCisJbW1jLT5vcHMgPSAmZHdf
bWNpX29wczsKKwltbWMtPmZfbWluID0gRElWX1JPVU5EX1VQKGhvc3QtPmJ1c19oeiwgNTEwKTsK
KwltbWMtPmZfbWF4ID0gaG9zdC0+YnVzX2h6OworCisJaWYgKGhvc3QtPnBkYXRhLT5nZXRfb2Ny
KQorCQltbWMtPm9jcl9hdmFpbCA9IGhvc3QtPnBkYXRhLT5nZXRfb2NyKGlkKTsKKwllbHNlCisJ
CW1tYy0+b2NyX2F2YWlsID0gTU1DX1ZERF8zMl8zMyB8IE1NQ19WRERfMzNfMzQ7CisKKwkvKgor
CSAqIFN0YXJ0IHdpdGggc2xvdCBwb3dlciBkaXNhYmxlZCwKKwkgKiB3aWxsIGJlIGVuYWJsZWQg
d2hlbiBjYXJkIGlzIGRldGVjdGVkCisJICovCisJaWYgKGhvc3QtPnBkYXRhLT5zZXRwb3dlcikK
KwkJaG9zdC0+cGRhdGEtPnNldHBvd2VyKGlkLCAwKTsKKworCW1tYy0+Y2FwcyA9IDA7CisJaWYg
KGhvc3QtPnBkYXRhLT5nZXRfYnVzX3dkKQorCQlpZiAoaG9zdC0+cGRhdGEtPmdldF9idXNfd2Qo
c2xvdC0+aWQpID49IDQpCisJCQltbWMtPmNhcHMgfD0gTU1DX0NBUF80X0JJVF9EQVRBOworCisJ
aWYgKGhvc3QtPnBkYXRhLT5xdWlya3MgJiBEV19NQ0lfUVVJUktfSElHSFNQRUVEKQorCQltbWMt
PmNhcHMgfD0gTU1DX0NBUF9TRF9ISUdIU1BFRUQ7CisKKyNpZmRlZiBDT05GSUdfTU1DX0RXX0lE
TUFDCisJbW1jLT5tYXhfc2VncyA9IGhvc3QtPnJpbmdfc2l6ZTsKKwltbWMtPm1heF9ibGtfc2l6
ZSA9IDY1NTM2OworCW1tYy0+bWF4X2Jsa19jb3VudCA9IGhvc3QtPnJpbmdfc2l6ZTsKKwltbWMt
Pm1heF9zZWdfc2l6ZSA9IDB4MTAwMDsKKwltbWMtPm1heF9yZXFfc2l6ZSA9IG1tYy0+bWF4X3Nl
Z19zaXplICogbW1jLT5tYXhfYmxrX2NvdW50OworI2Vsc2UKKwlpZiAoaG9zdC0+cGRhdGEtPmJs
a19zZXR0aW5ncykgeworCQltbWMtPm1heF9zZWdzID0gaG9zdC0+cGRhdGEtPmJsa19zZXR0aW5n
cy0+bWF4X3NlZ3M7CisJCW1tYy0+bWF4X2Jsa19zaXplID0gaG9zdC0+cGRhdGEtPmJsa19zZXR0
aW5ncy0+bWF4X2Jsa19zaXplOworCQltbWMtPm1heF9ibGtfY291bnQgPSBob3N0LT5wZGF0YS0+
YmxrX3NldHRpbmdzLT5tYXhfYmxrX2NvdW50OworCQltbWMtPm1heF9yZXFfc2l6ZSA9IGhvc3Qt
PnBkYXRhLT5ibGtfc2V0dGluZ3MtPm1heF9yZXFfc2l6ZTsKKwkJbW1jLT5tYXhfc2VnX3NpemUg
PSBob3N0LT5wZGF0YS0+YmxrX3NldHRpbmdzLT5tYXhfc2VnX3NpemU7CisJfSBlbHNlIHsKKwkJ
Lyp1c2VmdWwgZGVmYXVsdHMqLworCQltbWMtPm1heF9zZWdzID0gNjQ7CisJCW1tYy0+bWF4X2Js
a19zaXplID0gNjU1MzY7IC8qIEJMS1NJWiBpcyAxNiBiaXRzICovCisJCW1tYy0+bWF4X2Jsa19j
b3VudCA9IDUxMjsKKwkJbW1jLT5tYXhfcmVxX3NpemUgPSBtbWMtPm1heF9ibGtfc2l6ZSAqIG1t
Yy0+bWF4X2Jsa19jb3VudDsKKwkJbW1jLT5tYXhfc2VnX3NpemUgPSBtbWMtPm1heF9yZXFfc2l6
ZTsKKwl9CisjZW5kaWYgLyogQ09ORklHX01NQ19EV19JRE1BQyAqLworCisJLyogQXNzdW1lIGNh
cmQgaXMgcHJlc2VudCBpbml0aWFsbHkgKi8KKwlpZiAoZHdfbWNpX2dldF9jZChtbWMpKQorCQlz
ZXRfYml0KERXX01NQ19DQVJEX1BSRVNFTlQsICZzbG90LT5mbGFncyk7CisJZWxzZQorCQljbGVh
cl9iaXQoRFdfTU1DX0NBUkRfUFJFU0VOVCwgJnNsb3QtPmZsYWdzKTsKKworCWhvc3QtPnNsb3Rb
aWRdID0gc2xvdDsKKwltbWNfYWRkX2hvc3QobW1jKTsKKworI2lmIGRlZmluZWQoQ09ORklHX0RF
QlVHX0ZTKQorCWR3X21jaV9pbml0X2RlYnVnZnMoc2xvdCk7CisjZW5kaWYKKworCS8qIENhcmQg
aW5pdGlhbGx5IHVuZGV0ZWN0ZWQgKi8KKwlzbG90LT5sYXN0X2RldGVjdF9zdGF0ZSA9IDA7CisK
KwlyZXR1cm4gMDsKK30KKworc3RhdGljIHZvaWQgZHdfbWNpX2NsZWFudXBfc2xvdChzdHJ1Y3Qg
ZHdfbWNpX3Nsb3QgKnNsb3QsCisJCQkJdW5zaWduZWQgaW50IGlkKQoreworCS8qIFNodXRkb3du
IGRldGVjdCBJUlEgKi8KKwlpZiAoc2xvdC0+aG9zdC0+cGRhdGEtPmV4aXQpCisJCXNsb3QtPmhv
c3QtPnBkYXRhLT5leGl0KGlkKTsKKworCS8qIERlYnVnZnMgc3R1ZmYgaXMgY2xlYW5lZCB1cCBi
eSBtbWMgY29yZSAqLworCW1tY19yZW1vdmVfaG9zdChzbG90LT5tbWMpOworCXNsb3QtPmhvc3Qt
PnNsb3RbaWRdID0gTlVMTDsKKwltbWNfZnJlZV9ob3N0KHNsb3QtPm1tYyk7Cit9CisKK3N0YXRp
YyB2b2lkIGR3X21jaV9pbml0X2RtYShzdHJ1Y3QgZHdfbWNpICpob3N0KQoreworCS8qIEFsbG9j
IG1lbW9yeSBmb3Igc2cgdHJhbnNsYXRpb24gKi8KKwlob3N0LT5zZ19jcHUgPSBkbWFfYWxsb2Nf
Y29oZXJlbnQoJmhvc3QtPnBkZXYtPmRldiwgUEFHRV9TSVpFLAorCQkJJmhvc3QtPnNnX2RtYSwg
R0ZQX0tFUk5FTCk7CisJaWYgKCFob3N0LT5zZ19jcHUpIHsKKwkJZGV2X2VycigmaG9zdC0+cGRl
di0+ZGV2LCAiJXM6IGNvdWxkIG5vdCBhbGxvYyBETUEgbWVtb3J5XG4iLAorCQkJCV9fZnVuY19f
KTsKKwkJZ290byBub19kbWE7CisJfQorCisJLyogRGV0ZXJtaW5lIHdoaWNoIERNQSBpbnRlcmZh
Y2UgdG8gdXNlICovCisjaWZkZWYgQ09ORklHX01NQ19EV19JRE1BQworCWhvc3QtPmRtYV9vcHMg
PSAmZHdfbWNpX2lkbWFjX29wczsKKwlkZXZfaW5mbygmaG9zdC0+cGRldi0+ZGV2LCAiVXNpbmcg
aW50ZXJuYWwgRE1BIGNvbnRyb2xsZXIuXG4iKTsKKyNlbmRpZgorCisJaWYgKCFob3N0LT5kbWFf
b3BzKQorCQlnb3RvIG5vX2RtYTsKKworCWlmIChob3N0LT5kbWFfb3BzLT5pbml0KSB7CisJCWlm
IChob3N0LT5kbWFfb3BzLT5pbml0KGhvc3QpKSB7CisJCQlkZXZfZXJyKCZob3N0LT5wZGV2LT5k
ZXYsICIlczogVW5hYmxlIHRvIGluaXRpYWxpc2UgIgorCQkJCQkiRE1BIENvbnRyb2xsZXIuXG4i
LCBfX2Z1bmNfXyk7CisJCQlnb3RvIG5vX2RtYTsKKwkJfQorCX0gZWxzZSB7CisJCWRldl9lcnIo
Jmhvc3QtPnBkZXYtPmRldiwgIkRNQSBpbml0aWFsaXNhdGlvbiBub3QgZm91bmQuXG4iKTsKKwkJ
Z290byBub19kbWE7CisJfQorCisJaG9zdC0+dXNlX2RtYSA9IDE7CisJcmV0dXJuOworCitub19k
bWE6CisJZGV2X2luZm8oJmhvc3QtPnBkZXYtPmRldiwgIlVzaW5nIFBJTyBtb2RlLlxuIik7CisJ
aG9zdC0+dXNlX2RtYSA9IDA7CisJcmV0dXJuOworfQorCitzdGF0aWMgYm9vbCBtY2lfd2FpdF9y
ZXNldChzdHJ1Y3QgZGV2aWNlICpkZXYsIHN0cnVjdCBkd19tY2kgKmhvc3QpCit7CisJdW5zaWdu
ZWQgbG9uZyB0aW1lb3V0ID0gamlmZmllcyArIG1zZWNzX3RvX2ppZmZpZXMoNTAwKTsKKwl1bnNp
Z25lZCBpbnQgY3RybDsKKworCW1jaV93cml0ZWwoaG9zdCwgQ1RSTCwgKFNETU1DX0NUUkxfUkVT
RVQgfAorCQkJU0RNTUNfQ1RSTF9GSUZPX1JFU0VUIHwgU0RNTUNfQ1RSTF9ETUFfUkVTRVQpKTsK
KworCS8qIHdhaXQgdGlsbCByZXNldHMgY2xlYXIgKi8KKwlkbyB7CisJCWN0cmwgPSBtY2lfcmVh
ZGwoaG9zdCwgQ1RSTCk7CisJCWlmICghKGN0cmwgJiAoU0RNTUNfQ1RSTF9SRVNFVCB8CisJCQkg
ICAgICBTRE1NQ19DVFJMX0ZJRk9fUkVTRVQgfCBTRE1NQ19DVFJMX0RNQV9SRVNFVCkpKQorCQkJ
cmV0dXJuIHRydWU7CisJfSB3aGlsZSAodGltZV9iZWZvcmUoamlmZmllcywgdGltZW91dCkpOwor
CisJZGV2X2VycihkZXYsICJUaW1lb3V0IHJlc2V0dGluZyBibG9jayAoY3RybCAlI3gpXG4iLCBj
dHJsKTsKKworCXJldHVybiBmYWxzZTsKK30KKworc3RhdGljIGludCBkd19tY2lfcHJvYmUoc3Ry
dWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKK3sKKwlzdHJ1Y3QgZHdfbWNpICpob3N0OworCXN0
cnVjdCByZXNvdXJjZQkqcmVnczsKKwlzdHJ1Y3QgZHdfbWNpX2JvYXJkICpwZGF0YTsKKwlpbnQg
aXJxLCByZXQsIGksIHdpZHRoOworCXUzMiBmaWZvX3NpemU7CisKKwlyZWdzID0gcGxhdGZvcm1f
Z2V0X3Jlc291cmNlKHBkZXYsIElPUkVTT1VSQ0VfTUVNLCAwKTsKKwlpZiAoIXJlZ3MpCisJCXJl
dHVybiAtRU5YSU87CisKKwlpcnEgPSBwbGF0Zm9ybV9nZXRfaXJxKHBkZXYsIDApOworCWlmIChp
cnEgPCAwKQorCQlyZXR1cm4gaXJxOworCisJaG9zdCA9IGt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBk
d19tY2kpLCBHRlBfS0VSTkVMKTsKKwlpZiAoIWhvc3QpCisJCXJldHVybiAtRU5PTUVNOworCisJ
aG9zdC0+cGRldiA9IHBkZXY7CisJaG9zdC0+cGRhdGEgPSBwZGF0YSA9IHBkZXYtPmRldi5wbGF0
Zm9ybV9kYXRhOworCWlmICghcGRhdGEpIHsKKwkJZGV2X2VycigmcGRldi0+ZGV2LCAiUGxhdGZv
cm0gZGF0YSBtaXNzaW5nXG4iKTsKKwkJcmV0ID0gLUVOT0RFVjsKKwkJZ290byBlcnJfZnJlZWhv
c3Q7CisJfQorCisJaWYgKCgocGRhdGEtPm51bV9zbG90cyA+IDEpICYmICEocGRhdGEtPnNlbGVj
dF9zbG90KSkKKwkJCXx8ICEocGRhdGEtPmluaXQpKSB7CisJCWRldl9lcnIoJnBkZXYtPmRldiwg
IlBsYXRmb3JtIGRhdGEgd3JvbmdcbiIpOworCQlyZXQgPSAtRU5PREVWOworCQlnb3RvIGVycl9m
cmVlaG9zdDsKKwl9CisKKwlpZiAoIXBkYXRhLT5idXNfaHopIHsKKwkJZGV2X2VycigmcGRldi0+
ZGV2LAorCQkJIkJ1cyBzcGVlZCB1bmRlZmluZWQgaW4gcGxhdGZvcm0gZGF0YSFcbiIpOworCQly
ZXQgPSAtRU5PREVWOworCQlnb3RvIGVycl9mcmVlaG9zdDsKKwl9CisKKwlob3N0LT5idXNfaHog
PSBwZGF0YS0+YnVzX2h6OworCWhvc3QtPnF1aXJrcyA9IHBkYXRhLT5xdWlya3M7CisKKwlzcGlu
X2xvY2tfaW5pdCgmaG9zdC0+bG9jayk7CisJSU5JVF9MSVNUX0hFQUQoJmhvc3QtPnF1ZXVlKTsK
KworCXJldCA9IC1FTk9NRU07CisJaG9zdC0+cmVncyA9IGlvcmVtYXAocmVncy0+c3RhcnQsIHJl
Z3MtPmVuZCAtIHJlZ3MtPnN0YXJ0ICsgMSk7CisJaWYgKCFob3N0LT5yZWdzKQorCQlnb3RvIGVy
cl9mcmVlaG9zdDsKKworCWhvc3QtPmRtYV9vcHMgPSBwZGF0YS0+ZG1hX29wczsKKwlkd19tY2lf
aW5pdF9kbWEoaG9zdCk7CisKKwkvKgorCSAqIEdldCB0aGUgaG9zdCBkYXRhIHdpZHRoIC0gdGhp
cyBhc3N1bWVzIHRoYXQgSENPTiBoYXMgYmVlbiBzZXQgd2l0aAorCSAqIHRoZSBjb3JyZWN0IHZh
bHVlcy4KKwkgKi8KKwlpID0gKG1jaV9yZWFkbChob3N0LCBIQ09OKSA+PiA3KSAmIDB4NzsKKwlp
ZiAoIWkpIHsKKwkJaG9zdC0+cHVzaF9kYXRhID0gZHdfbWNpX3B1c2hfZGF0YTE2OworCQlob3N0
LT5wdWxsX2RhdGEgPSBkd19tY2lfcHVsbF9kYXRhMTY7CisJCXdpZHRoID0gMTY7CisJCWhvc3Qt
PmRhdGFfc2hpZnQgPSAxOworCX0gZWxzZSBpZiAoaSA9PSAyKSB7CisJCWhvc3QtPnB1c2hfZGF0
YSA9IGR3X21jaV9wdXNoX2RhdGE2NDsKKwkJaG9zdC0+cHVsbF9kYXRhID0gZHdfbWNpX3B1bGxf
ZGF0YTY0OworCQl3aWR0aCA9IDY0OworCQlob3N0LT5kYXRhX3NoaWZ0ID0gMzsKKwl9IGVsc2Ug
eworCQkvKiBDaGVjayBmb3IgYSByZXNlcnZlZCB2YWx1ZSwgYW5kIHdhcm4gaWYgaXQgaXMgKi8K
KwkJV0FSTigoaSAhPSAxKSwKKwkJCSJIQ09OIHJlcG9ydHMgYSByZXNlcnZlZCBob3N0IGRhdGEg
d2lkdGghXG4iCisJCQkiRGVmYXVsdGluZyB0byAzMi1iaXQgYWNjZXNzLlxuIik7CisJCWhvc3Qt
PnB1c2hfZGF0YSA9IGR3X21jaV9wdXNoX2RhdGEzMjsKKwkJaG9zdC0+cHVsbF9kYXRhID0gZHdf
bWNpX3B1bGxfZGF0YTMyOworCQl3aWR0aCA9IDMyOworCQlob3N0LT5kYXRhX3NoaWZ0ID0gMjsK
Kwl9CisKKwkvKiByZXNldCBhbGwgYmxvY2tzICovCisJaWYgKCFtY2lfd2FpdF9yZXNldCgmcGRl
di0+ZGV2LCBob3N0KSkgeworCQlyZXQgPSAtRU5PREVWOworCQlnb3RvIGVycl9kbWF1bm1hcDsK
Kwl9CisKKwkgLyogQ2xlYXIgdGhlIGludGVycnVwdHMgZm9yIHRoZSBob3N0IGNvbnRyb2xsZXIg
Ki8KKwltY2lfd3JpdGVsKGhvc3QsIFJJTlRTVFMsIDB4RkZGRkZGRkYpOworCW1jaV93cml0ZWwo
aG9zdCwgSU5UTUFTSywgMCk7IC8qIGRpc2FibGUgYWxsIG1tYyBpbnRlcnJ1cHQgZmlyc3QgKi8K
KworCS8qIFB1dCBpbiBtYXggdGltZW91dCAqLworCW1jaV93cml0ZWwoaG9zdCwgVE1PVVQsIDB4
RkZGRkZGRkYpOworCisJLyoKKwkgKiBGSUZPIHRocmVzaG9sZCBzZXR0aW5ncyAgUnhNYXJrID0g
Zmlmb19zaXplLzItMSwKKwkgKiAgICAgICAgICAgICAgICAgICAgICAgICAgVHggTWFyayA9Zmlm
b19zaXplLzIgRE1BIFNpemUgPSA4CisJICovCisJZmlmb19zaXplID0gbWNpX3JlYWRsKGhvc3Qs
IEZJRk9USCk7CisJZmlmb19zaXplID0gKGZpZm9fc2l6ZSA+PiAxNikgJiAweDdmZjsKKwltY2lf
d3JpdGVsKGhvc3QsIEZJRk9USCwgKCgweDIgPDwgMjgpIHwgKChmaWZvX3NpemUvMiAtIDEpIDw8
IDE2KSB8CisJCQkJKChmaWZvX3NpemUvMikgPDwgMCkpKTsKKworCS8qIGRpc2FibGUgY2xvY2sg
dG8gQ0lVICovCisJbWNpX3dyaXRlbChob3N0LCBDTEtFTkEsIDApOworCW1jaV93cml0ZWwoaG9z
dCwgQ0xLU1JDLCAwKTsKKworCXRhc2tsZXRfaW5pdCgmaG9zdC0+dGFza2xldCwgZHdfbWNpX3Rh
c2tsZXRfZnVuYywgKHVuc2lnbmVkIGxvbmcpaG9zdCk7CisJdGFza2xldF9pbml0KCZob3N0LT5j
YXJkX3Rhc2tsZXQsCisJCWR3X21jaV90YXNrbGV0X2NhcmQsICh1bnNpZ25lZCBsb25nKWhvc3Qp
OworCisJcmV0ID0gcmVxdWVzdF9pcnEoaXJxLCBkd19tY2lfaW50ZXJydXB0LCAwLCAiZHctbWNp
IiwgaG9zdCk7CisJaWYgKHJldCkKKwkJZ290byBlcnJfZG1hdW5tYXA7CisKKwlwbGF0Zm9ybV9z
ZXRfZHJ2ZGF0YShwZGV2LCBob3N0KTsKKworCWlmIChob3N0LT5wZGF0YS0+bnVtX3Nsb3RzKQor
CQlob3N0LT5udW1fc2xvdHMgPSBob3N0LT5wZGF0YS0+bnVtX3Nsb3RzOworCWVsc2UKKwkJaG9z
dC0+bnVtX3Nsb3RzID0gKChtY2lfcmVhZGwoaG9zdCwgSENPTikgPj4gMSkgJiAweDFGKSArIDE7
CisKKwkvKiBXZSBuZWVkIGF0IGxlYXN0IG9uZSBzbG90IHRvIHN1Y2NlZWQgIyMjI3BkIyMjIyov
CisJZm9yIChpID0gMDsgaSA8IGhvc3QtPm51bV9zbG90czsgaSsrKSB7CisJCXJldCA9IGR3X21j
aV9pbml0X3Nsb3QoaG9zdCwgaSk7CisJCWlmIChyZXQpIHsKKwkJCXJldCA9IC1FTk9ERVY7CisJ
CQlnb3RvIGVycl9pbml0X3Nsb3Q7CisJCX0KKwl9CisKKwkvKgorCSAqIGVuYWJsZSBpbnRlcnJ1
cHQgZm9yIGNvbW1hbmQgZG9uZSwgZGF0YSBvdmVyLCBkYXRhIGVtcHR5LAorCSAqIHJlY2VpdmUg
cmVhZHkgYW5kIGVycm9yIHN1Y2ggYXMgdHJhbnNtaXQsIHJlY2VpdmUgdGltZW91dCwgY3JjIGVy
cm9yCisJICovCisJbWNpX3dyaXRlbChob3N0LCBSSU5UU1RTLCAweEZGRkZGRkZGKTsKKwltY2lf
d3JpdGVsKGhvc3QsIElOVE1BU0ssIFNETU1DX0lOVF9DTURfRE9ORSB8IFNETU1DX0lOVF9EQVRB
X09WRVIgfAorCQkJCVNETU1DX0lOVF9UWERSIHwgU0RNTUNfSU5UX1JYRFIgfAorCQkJCURXX01D
SV9FUlJPUl9GTEFHUyB8IFNETU1DX0lOVF9DRCk7CisJbWNpX3dyaXRlbChob3N0LCBDVFJMLCBT
RE1NQ19DVFJMX0lOVF9FTkFCTEUpOyAvKmVuYWJsZSBtY2kgaW50ZXJydXB0Ki8KKworCWRldl9p
bmZvKCZwZGV2LT5kZXYsICJEVyBNTUMgY29udHJvbGxlciBhdCBpcnEgJWQsICIKKwkJCSIlZCBi
aXQgaG9zdCBkYXRhIHdpZHRoXG4iLAorCQkJaXJxLCB3aWR0aCk7CisJaWYgKGhvc3QtPnF1aXJr
cyAmIERXX01DSV9RVUlSS19JRE1BQ19EVE8pCisJCWRldl9pbmZvKCZwZGV2LT5kZXYsICJJbnRl
cm5hbCBETUFDIGludGVycnVwdCBmaXggZW5hYmxlZC5cbiIpOworCisJcmV0dXJuIDA7CisKK2Vy
cl9pbml0X3Nsb3Q6CisJLyogRGUtaW5pdCBhbnkgaW5pdGlhbGl6ZWQgc2xvdHMgKi8KKwl3aGls
ZSAoaSA+IDApIHsKKwkJaWYgKGhvc3QtPnNsb3RbaV0pCisJCQlkd19tY2lfY2xlYW51cF9zbG90
KGhvc3QtPnNsb3RbaV0sIGkpOworCQlpLS07CisJfQorCWZyZWVfaXJxKGlycSwgaG9zdCk7CisK
K2Vycl9kbWF1bm1hcDoKKwlpZiAoaG9zdC0+dXNlX2RtYSAmJiBob3N0LT5kbWFfb3BzLT5leGl0
KQorCQlob3N0LT5kbWFfb3BzLT5leGl0KGhvc3QpOworCWRtYV9mcmVlX2NvaGVyZW50KCZob3N0
LT5wZGV2LT5kZXYsIFBBR0VfU0laRSwKKwkJCWhvc3QtPnNnX2NwdSwgaG9zdC0+c2dfZG1hKTsK
Kwlpb3VubWFwKGhvc3QtPnJlZ3MpOworCitlcnJfZnJlZWhvc3Q6CisJa2ZyZWUoaG9zdCk7CisJ
cmV0dXJuIHJldDsKK30KKworc3RhdGljIGludCBfX2V4aXQgZHdfbWNpX3JlbW92ZShzdHJ1Y3Qg
cGxhdGZvcm1fZGV2aWNlICpwZGV2KQoreworCXN0cnVjdCBkd19tY2kgKmhvc3QgPSBwbGF0Zm9y
bV9nZXRfZHJ2ZGF0YShwZGV2KTsKKwlpbnQgaTsKKworCW1jaV93cml0ZWwoaG9zdCwgUklOVFNU
UywgMHhGRkZGRkZGRik7CisJbWNpX3dyaXRlbChob3N0LCBJTlRNQVNLLCAwKTsgLyogZGlzYWJs
ZSBhbGwgbW1jIGludGVycnVwdCBmaXJzdCAqLworCisJcGxhdGZvcm1fc2V0X2RydmRhdGEocGRl
diwgTlVMTCk7CisKKwlmb3IgKGkgPSAwOyBpIDwgaG9zdC0+bnVtX3Nsb3RzOyBpKyspIHsKKwkJ
ZGV2X2RiZygmcGRldi0+ZGV2LCAicmVtb3ZlIHNsb3QgJWRcbiIsIGkpOworCQlpZiAoaG9zdC0+
c2xvdFtpXSkKKwkJCWR3X21jaV9jbGVhbnVwX3Nsb3QoaG9zdC0+c2xvdFtpXSwgaSk7CisJfQor
CisJLyogZGlzYWJsZSBjbG9jayB0byBDSVUgKi8KKwltY2lfd3JpdGVsKGhvc3QsIENMS0VOQSwg
MCk7CisJbWNpX3dyaXRlbChob3N0LCBDTEtTUkMsIDApOworCisJZnJlZV9pcnEocGxhdGZvcm1f
Z2V0X2lycShwZGV2LCAwKSwgaG9zdCk7CisJZG1hX2ZyZWVfY29oZXJlbnQoJnBkZXYtPmRldiwg
UEFHRV9TSVpFLCBob3N0LT5zZ19jcHUsIGhvc3QtPnNnX2RtYSk7CisKKwlpZiAoaG9zdC0+dXNl
X2RtYSAmJiBob3N0LT5kbWFfb3BzLT5leGl0KQorCQlob3N0LT5kbWFfb3BzLT5leGl0KGhvc3Qp
OworCisJaW91bm1hcChob3N0LT5yZWdzKTsKKworCWtmcmVlKGhvc3QpOworCXJldHVybiAwOwor
fQorCisjaWZkZWYgQ09ORklHX1BNCisvKgorICogVE9ETzogd2Ugc2hvdWxkIHByb2JhYmx5IGRp
c2FibGUgdGhlIGNsb2NrIHRvIHRoZSBjYXJkIGluIHRoZSBzdXNwZW5kIHBhdGguCisgKi8KK3N0
YXRpYyBpbnQgZHdfbWNpX3N1c3BlbmQoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldiwgcG1f
bWVzc2FnZV90IG1lc2cpCit7CisJaW50IGksIHJldDsKKwlzdHJ1Y3QgZHdfbWNpICpob3N0ID0g
cGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7CisKKwlmb3IgKGkgPSAwOyBpIDwgaG9zdC0+bnVt
X3Nsb3RzOyBpKyspIHsKKwkJc3RydWN0IGR3X21jaV9zbG90ICpzbG90ID0gaG9zdC0+c2xvdFtp
XTsKKwkJaWYgKCFzbG90KQorCQkJY29udGludWU7CisJCXJldCA9IG1tY19zdXNwZW5kX2hvc3Qo
c2xvdC0+bW1jKTsKKwkJaWYgKHJldCA8IDApIHsKKwkJCXdoaWxlICgtLWkgPj0gMCkgeworCQkJ
CXNsb3QgPSBob3N0LT5zbG90W2ldOworCQkJCWlmIChzbG90KQorCQkJCQltbWNfcmVzdW1lX2hv
c3QoaG9zdC0+c2xvdFtpXS0+bW1jKTsKKwkJCX0KKwkJCXJldHVybiByZXQ7CisJCX0KKwl9CisK
KwlyZXR1cm4gMDsKK30KKworc3RhdGljIGludCBkd19tY2lfcmVzdW1lKHN0cnVjdCBwbGF0Zm9y
bV9kZXZpY2UgKnBkZXYpCit7CisJaW50IGksIHJldDsKKwlzdHJ1Y3QgZHdfbWNpICpob3N0ID0g
cGxhdGZvcm1fZ2V0X2RydmRhdGEocGRldik7CisKKwlmb3IgKGkgPSAwOyBpIDwgaG9zdC0+bnVt
X3Nsb3RzOyBpKyspIHsKKwkJc3RydWN0IGR3X21jaV9zbG90ICpzbG90ID0gaG9zdC0+c2xvdFtp
XTsKKwkJaWYgKCFzbG90KQorCQkJY29udGludWU7CisJCXJldCA9IG1tY19yZXN1bWVfaG9zdCho
b3N0LT5zbG90W2ldLT5tbWMpOworCQlpZiAocmV0IDwgMCkKKwkJCXJldHVybiByZXQ7CisJfQor
CisJcmV0dXJuIDA7Cit9CisjZWxzZQorI2RlZmluZSBkd19tY2lfc3VzcGVuZAlOVUxMCisjZGVm
aW5lIGR3X21jaV9yZXN1bWUJTlVMTAorI2VuZGlmIC8qIENPTkZJR19QTSAqLworCitzdGF0aWMg
c3RydWN0IHBsYXRmb3JtX2RyaXZlciBkd19tY2lfZHJpdmVyID0geworCS5yZW1vdmUJCT0gX19l
eGl0X3AoZHdfbWNpX3JlbW92ZSksCisJLnN1c3BlbmQJPSBkd19tY2lfc3VzcGVuZCwKKwkucmVz
dW1lCQk9IGR3X21jaV9yZXN1bWUsCisJLmRyaXZlcgkJPSB7CisJCS5uYW1lCQk9ICJkd19tbWMi
LAorCX0sCit9OworCitzdGF0aWMgaW50IF9faW5pdCBkd19tY2lfaW5pdCh2b2lkKQoreworCXJl
dHVybiBwbGF0Zm9ybV9kcml2ZXJfcHJvYmUoJmR3X21jaV9kcml2ZXIsIGR3X21jaV9wcm9iZSk7
Cit9CisKK3N0YXRpYyB2b2lkIF9fZXhpdCBkd19tY2lfZXhpdCh2b2lkKQoreworCXBsYXRmb3Jt
X2RyaXZlcl91bnJlZ2lzdGVyKCZkd19tY2lfZHJpdmVyKTsKK30KKworbW9kdWxlX2luaXQoZHdf
bWNpX2luaXQpOworbW9kdWxlX2V4aXQoZHdfbWNpX2V4aXQpOworCitNT0RVTEVfREVTQ1JJUFRJ
T04oIkRXIE11bHRpbWVkaWEgQ2FyZCBJbnRlcmZhY2UgZHJpdmVyIik7CitNT0RVTEVfQVVUSE9S
KCJOWFAgU2VtaWNvbmR1Y3RvciBWaWV0TmFtIik7CitNT0RVTEVfQVVUSE9SKCJJbWFnaW5hdGlv
biBUZWNobm9sb2dpZXMgTHRkIik7CitNT0RVTEVfTElDRU5TRSgiR1BMIHYyIik7CmRpZmYgLS1n
aXQgYS9kcml2ZXJzL21tYy9ob3N0L2R3X21tYy5oIGIvZHJpdmVycy9tbWMvaG9zdC9kd19tbWMu
aApuZXcgZmlsZSBtb2RlIDEwMDY0NAppbmRleCAwMDAwMDAwLi42NWJjZmY3Ci0tLSAvZGV2L251
bGwKKysrIGIvZHJpdmVycy9tbWMvaG9zdC9kd19tbWMuaApAQCAtMCwwICsxLDE1NSBAQAorLyoK
KyAqIFN5bm9wc3lzIERlc2lnbldhcmUgTXVsdGltZWRpYSBDYXJkIEludGVyZmFjZSBkcml2ZXIK
KyAqICAoQmFzZWQgb24gTlhQIGRyaXZlciBmb3IgbHBjIDMxeHgpCisgKgorICogQ29weXJpZ2h0
IChDKSAyMDA5IE5YUCBTZW1pY29uZHVjdG9ycworICogQ29weXJpZ2h0IChDKSAyMDA5LCAyMDEw
IEltYWdpbmF0aW9uIFRlY2hub2xvZ2llcyBMdGQuCisgKgorICogVGhpcyBwcm9ncmFtIGlzIGZy
ZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqIGl0
IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgYXMgcHVi
bGlzaGVkIGJ5CisgKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lv
biAyIG9mIHRoZSBMaWNlbnNlLCBvcgorICogKGF0IHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVy
c2lvbi4KKyAqLworCisjaWZuZGVmIF9EV19NTUNfSF8KKyNkZWZpbmUgX0RXX01NQ19IXworCisj
ZGVmaW5lIE1DSV9TTE9UCQkwCisKKyNkZWZpbmUgU0RNTUNfQ1RSTAkJMHgwMDAKKyNkZWZpbmUg
U0RNTUNfUFdSRU4JCTB4MDA0CisjZGVmaW5lIFNETU1DX0NMS0RJVgkJMHgwMDgKKyNkZWZpbmUg
U0RNTUNfQ0xLU1JDCQkweDAwYworI2RlZmluZSBTRE1NQ19DTEtFTkEJCTB4MDEwCisjZGVmaW5l
IFNETU1DX1RNT1VUCQkweDAxNAorI2RlZmluZSBTRE1NQ19DVFlQRQkJMHgwMTgKKyNkZWZpbmUg
U0RNTUNfQkxLU0laCQkweDAxYworI2RlZmluZSBTRE1NQ19CWVRDTlQJCTB4MDIwCisjZGVmaW5l
IFNETU1DX0lOVE1BU0sJCTB4MDI0CisjZGVmaW5lIFNETU1DX0NNREFSRwkJMHgwMjgKKyNkZWZp
bmUgU0RNTUNfQ01ECQkweDAyYworI2RlZmluZSBTRE1NQ19SRVNQMAkJMHgwMzAKKyNkZWZpbmUg
U0RNTUNfUkVTUDEJCTB4MDM0CisjZGVmaW5lIFNETU1DX1JFU1AyCQkweDAzOAorI2RlZmluZSBT
RE1NQ19SRVNQMwkJMHgwM2MKKyNkZWZpbmUgU0RNTUNfTUlOVFNUUwkJMHgwNDAKKyNkZWZpbmUg
U0RNTUNfUklOVFNUUwkJMHgwNDQKKyNkZWZpbmUgU0RNTUNfU1RBVFVTCQkweDA0OAorI2RlZmlu
ZSBTRE1NQ19GSUZPVEgJCTB4MDRjCisjZGVmaW5lIFNETU1DX0NERVRFQ1QJCTB4MDUwCisjZGVm
aW5lIFNETU1DX1dSVFBSVAkJMHgwNTQKKyNkZWZpbmUgU0RNTUNfR1BJTwkJMHgwNTgKKyNkZWZp
bmUgU0RNTUNfVENCQ05UCQkweDA1YworI2RlZmluZSBTRE1NQ19UQkJDTlQJCTB4MDYwCisjZGVm
aW5lIFNETU1DX0RFQk5DRQkJMHgwNjQKKyNkZWZpbmUgU0RNTUNfVVNSSUQJCTB4MDY4CisjZGVm
aW5lIFNETU1DX1ZFUklECQkweDA2YworI2RlZmluZSBTRE1NQ19IQ09OCQkweDA3MAorI2RlZmlu
ZSBTRE1NQ19CTU9ECQkweDA4MAorI2RlZmluZSBTRE1NQ19QTERNTkQJCTB4MDg0CisjZGVmaW5l
IFNETU1DX0RCQUREUgkJMHgwODgKKyNkZWZpbmUgU0RNTUNfSURTVFMJCTB4MDhjCisjZGVmaW5l
IFNETU1DX0lESU5URU4JCTB4MDkwCisjZGVmaW5lIFNETU1DX0RTQ0FERFIJCTB4MDk0CisjZGVm
aW5lIFNETU1DX0JVRkFERFIJCTB4MDk4CisjZGVmaW5lIFNETU1DX0RBVEEJCTB4MTAwCisjZGVm
aW5lIFNETU1DX0RBVEFfQURSCQkweDEwMAorCisvKiBzaGlmdCBiaXQgZmllbGQgKi8KKyNkZWZp
bmUgX1NCRihmLCB2KQkJKCh2KSA8PCAoZikpCisKKy8qIENvbnRyb2wgcmVnaXN0ZXIgZGVmaW5l
cyAqLworI2RlZmluZSBTRE1NQ19DVFJMX1VTRV9JRE1BQwkJQklUKDI1KQorI2RlZmluZSBTRE1N
Q19DVFJMX0NFQVRBX0lOVF9FTgkJQklUKDExKQorI2RlZmluZSBTRE1NQ19DVFJMX1NFTkRfQVNf
Q0NTRAkJQklUKDEwKQorI2RlZmluZSBTRE1NQ19DVFJMX1NFTkRfQ0NTRAkJQklUKDkpCisjZGVm
aW5lIFNETU1DX0NUUkxfQUJSVF9SRUFEX0RBVEEJQklUKDgpCisjZGVmaW5lIFNETU1DX0NUUkxf
U0VORF9JUlFfUkVTUAlCSVQoNykKKyNkZWZpbmUgU0RNTUNfQ1RSTF9SRUFEX1dBSVQJCUJJVCg2
KQorI2RlZmluZSBTRE1NQ19DVFJMX0RNQV9FTkFCTEUJCUJJVCg1KQorI2RlZmluZSBTRE1NQ19D
VFJMX0lOVF9FTkFCTEUJCUJJVCg0KQorI2RlZmluZSBTRE1NQ19DVFJMX0RNQV9SRVNFVAkJQklU
KDIpCisjZGVmaW5lIFNETU1DX0NUUkxfRklGT19SRVNFVAkJQklUKDEpCisjZGVmaW5lIFNETU1D
X0NUUkxfUkVTRVQJCUJJVCgwKQorLyogQ2xvY2sgRW5hYmxlIHJlZ2lzdGVyIGRlZmluZXMgKi8K
KyNkZWZpbmUgU0RNTUNfQ0xLRU5fTE9XX1BXUgkJQklUKDE2KQorI2RlZmluZSBTRE1NQ19DTEtF
Tl9FTkFCTEUJCUJJVCgwKQorLyogdGltZS1vdXQgcmVnaXN0ZXIgZGVmaW5lcyAqLworI2RlZmlu
ZSBTRE1NQ19UTU9VVF9EQVRBKG4pCQlfU0JGKDgsIChuKSkKKyNkZWZpbmUgU0RNTUNfVE1PVVRf
REFUQV9NU0sJCTB4RkZGRkZGMDAKKyNkZWZpbmUgU0RNTUNfVE1PVVRfUkVTUChuKQkJKChuKSAm
IDB4RkYpCisjZGVmaW5lIFNETU1DX1RNT1VUX1JFU1BfTVNLCQkweEZGCisvKiBjYXJkLXR5cGUg
cmVnaXN0ZXIgZGVmaW5lcyAqLworI2RlZmluZSBTRE1NQ19DVFlQRV84QklUCQlCSVQoMTYpCisj
ZGVmaW5lIFNETU1DX0NUWVBFXzRCSVQJCUJJVCgwKQorI2RlZmluZSBTRE1NQ19DVFlQRV8xQklU
CQkwCisvKiBJbnRlcnJ1cHQgc3RhdHVzICYgbWFzayByZWdpc3RlciBkZWZpbmVzICovCisjZGVm
aW5lIFNETU1DX0lOVF9TRElPCQkJQklUKDE2KQorI2RlZmluZSBTRE1NQ19JTlRfRUJFCQkJQklU
KDE1KQorI2RlZmluZSBTRE1NQ19JTlRfQUNECQkJQklUKDE0KQorI2RlZmluZSBTRE1NQ19JTlRf
U0JFCQkJQklUKDEzKQorI2RlZmluZSBTRE1NQ19JTlRfSExFCQkJQklUKDEyKQorI2RlZmluZSBT
RE1NQ19JTlRfRlJVTgkJCUJJVCgxMSkKKyNkZWZpbmUgU0RNTUNfSU5UX0hUTwkJCUJJVCgxMCkK
KyNkZWZpbmUgU0RNTUNfSU5UX0RUTwkJCUJJVCg5KQorI2RlZmluZSBTRE1NQ19JTlRfUlRPCQkJ
QklUKDgpCisjZGVmaW5lIFNETU1DX0lOVF9EQ1JDCQkJQklUKDcpCisjZGVmaW5lIFNETU1DX0lO
VF9SQ1JDCQkJQklUKDYpCisjZGVmaW5lIFNETU1DX0lOVF9SWERSCQkJQklUKDUpCisjZGVmaW5l
IFNETU1DX0lOVF9UWERSCQkJQklUKDQpCisjZGVmaW5lIFNETU1DX0lOVF9EQVRBX09WRVIJCUJJ
VCgzKQorI2RlZmluZSBTRE1NQ19JTlRfQ01EX0RPTkUJCUJJVCgyKQorI2RlZmluZSBTRE1NQ19J
TlRfUkVTUF9FUlIJCUJJVCgxKQorI2RlZmluZSBTRE1NQ19JTlRfQ0QJCQlCSVQoMCkKKyNkZWZp
bmUgU0RNTUNfSU5UX0VSUk9SCQkJMHhiZmMyCisvKiBDb21tYW5kIHJlZ2lzdGVyIGRlZmluZXMg
Ki8KKyNkZWZpbmUgU0RNTUNfQ01EX1NUQVJUCQkJQklUKDMxKQorI2RlZmluZSBTRE1NQ19DTURf
Q0NTX0VYUAkJQklUKDIzKQorI2RlZmluZSBTRE1NQ19DTURfQ0VBVEFfUkQJCUJJVCgyMikKKyNk
ZWZpbmUgU0RNTUNfQ01EX1VQRF9DTEsJCUJJVCgyMSkKKyNkZWZpbmUgU0RNTUNfQ01EX0lOSVQJ
CQlCSVQoMTUpCisjZGVmaW5lIFNETU1DX0NNRF9TVE9QCQkJQklUKDE0KQorI2RlZmluZSBTRE1N
Q19DTURfUFJWX0RBVF9XQUlUCQlCSVQoMTMpCisjZGVmaW5lIFNETU1DX0NNRF9TRU5EX1NUT1AJ
CUJJVCgxMikKKyNkZWZpbmUgU0RNTUNfQ01EX1NUUk1fTU9ERQkJQklUKDExKQorI2RlZmluZSBT
RE1NQ19DTURfREFUX1dSCQlCSVQoMTApCisjZGVmaW5lIFNETU1DX0NNRF9EQVRfRVhQCQlCSVQo
OSkKKyNkZWZpbmUgU0RNTUNfQ01EX1JFU1BfQ1JDCQlCSVQoOCkKKyNkZWZpbmUgU0RNTUNfQ01E
X1JFU1BfTE9ORwkJQklUKDcpCisjZGVmaW5lIFNETU1DX0NNRF9SRVNQX0VYUAkJQklUKDYpCisj
ZGVmaW5lIFNETU1DX0NNRF9JTkRYKG4pCQkoKG4pICYgMHgxRikKKy8qIFN0YXR1cyByZWdpc3Rl
ciBkZWZpbmVzICovCisjZGVmaW5lIFNETU1DX0dFVF9GQ05UKHgpCQkoKCh4KT4+MTcpICYgMHgx
RkYpCisjZGVmaW5lIFNETU1DX0ZJRk9fU1oJCQkzMgorLyogSW50ZXJuYWwgRE1BQyBpbnRlcnJ1
cHQgZGVmaW5lcyAqLworI2RlZmluZSBTRE1NQ19JRE1BQ19JTlRfQUkJCUJJVCg5KQorI2RlZmlu
ZSBTRE1NQ19JRE1BQ19JTlRfTkkJCUJJVCg4KQorI2RlZmluZSBTRE1NQ19JRE1BQ19JTlRfQ0VT
CQlCSVQoNSkKKyNkZWZpbmUgU0RNTUNfSURNQUNfSU5UX0RVCQlCSVQoNCkKKyNkZWZpbmUgU0RN
TUNfSURNQUNfSU5UX0ZCRQkJQklUKDIpCisjZGVmaW5lIFNETU1DX0lETUFDX0lOVF9SSQkJQklU
KDEpCisjZGVmaW5lIFNETU1DX0lETUFDX0lOVF9USQkJQklUKDApCisvKiBJbnRlcm5hbCBETUFD
IGJ1cyBtb2RlIGJpdHMgKi8KKyNkZWZpbmUgU0RNTUNfSURNQUNfRU5BQkxFCQlCSVQoNykKKyNk
ZWZpbmUgU0RNTUNfSURNQUNfRkIJCQlCSVQoMSkKKyNkZWZpbmUgU0RNTUNfSURNQUNfU1dSRVNF
VAkJQklUKDApCisKKy8qIFJlZ2lzdGVyIGFjY2VzcyBtYWNyb3MgKi8KKyNkZWZpbmUgbWNpX3Jl
YWRsKGRldiwgcmVnKQkJCVwKKwlfX3Jhd19yZWFkbChkZXYtPnJlZ3MgKyBTRE1NQ18jI3JlZykK
KyNkZWZpbmUgbWNpX3dyaXRlbChkZXYsIHJlZywgdmFsdWUpCQkJXAorCV9fcmF3X3dyaXRlbCgo
dmFsdWUpLCBkZXYtPnJlZ3MgKyBTRE1NQ18jI3JlZykKKworLyogMTYtYml0IEZJRk8gYWNjZXNz
IG1hY3JvcyAqLworI2RlZmluZSBtY2lfcmVhZHcoZGV2LCByZWcpCQkJXAorCV9fcmF3X3JlYWR3
KGRldi0+cmVncyArIFNETU1DXyMjcmVnKQorI2RlZmluZSBtY2lfd3JpdGV3KGRldiwgcmVnLCB2
YWx1ZSkJCQlcCisJX19yYXdfd3JpdGV3KCh2YWx1ZSksIGRldi0+cmVncyArIFNETU1DXyMjcmVn
KQorCisvKiA2NC1iaXQgRklGTyBhY2Nlc3MgbWFjcm9zICovCisjZGVmaW5lIG1jaV9yZWFkcShk
ZXYsIHJlZykJCQlcCisJX19yYXdfcmVhZHEoZGV2LT5yZWdzICsgU0RNTUNfIyNyZWcpCisjZGVm
aW5lIG1jaV93cml0ZXEoZGV2LCByZWcsIHZhbHVlKQkJCVwKKwlfX3Jhd193cml0ZXEoKHZhbHVl
KSwgZGV2LT5yZWdzICsgU0RNTUNfIyNyZWcpCisKKyNlbmRpZiAvKiBfRFdfTU1DX0hfICovCmRp
ZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21tYy9kd19tbWMuaCBiL2luY2x1ZGUvbGludXgvbW1j
L2R3X21tYy5oCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4IDAwMDAwMDAuLmQyZjkyYmQKLS0t
IC9kZXYvbnVsbAorKysgYi9pbmNsdWRlL2xpbnV4L21tYy9kd19tbWMuaApAQCAtMCwwICsxLDE0
OSBAQAorLyoKKyAqIFN5bm9wc3lzIERlc2lnbldhcmUgTXVsdGltZWRpYSBDYXJkIEludGVyZmFj
ZSBkcml2ZXIKKyAqICAoQmFzZWQgb24gTlhQIGRyaXZlciBmb3IgbHBjIDMxeHgpCisgKgorICog
Q29weXJpZ2h0IChDKSAyMDA5IE5YUCBTZW1pY29uZHVjdG9ycworICogQ29weXJpZ2h0IChDKSAy
MDA5LCAyMDEwIEltYWdpbmF0aW9uIFRlY2hub2xvZ2llcyBMdGQuCisgKgorICogVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2Rp
ZnkKKyAqIGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vu
c2UgYXMgcHVibGlzaGVkIGJ5CisgKiB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRo
ZXIgdmVyc2lvbiAyIG9mIHRoZSBMaWNlbnNlLCBvcgorICogKGF0IHlvdXIgb3B0aW9uKSBhbnkg
bGF0ZXIgdmVyc2lvbi4KKyAqLworCisjaWZuZGVmIF9MSU5VWF9NTUNfRFdfTU1DX0hfCisjZGVm
aW5lIF9MSU5VWF9NTUNfRFdfTU1DX0hfCisKKyNkZWZpbmUgTUFYX01DSV9TTE9UUwkyCisKK2Vu
dW0gZHdfbWNpX3N0YXRlIHsKKwlTVEFURV9JRExFID0gMCwKKwlTVEFURV9TRU5ESU5HX0NNRCwK
KwlTVEFURV9TRU5ESU5HX0RBVEEsCisJU1RBVEVfREFUQV9CVVNZLAorCVNUQVRFX1NFTkRJTkdf
U1RPUCwKKwlTVEFURV9EQVRBX0VSUk9SLAorfTsKKworZW51bSB7CisJRVZFTlRfQ01EX0NPTVBM
RVRFID0gMCwKKwlFVkVOVF9YRkVSX0NPTVBMRVRFLAorCUVWRU5UX0RBVEFfQ09NUExFVEUsCisJ
RVZFTlRfREFUQV9FUlJPUiwKKwlFVkVOVF9YRkVSX0VSUk9SCit9OworCitzdHJ1Y3QgbW1jX2Rh
dGE7CisKK3N0cnVjdCBkd19tY2kgeworCXNwaW5sb2NrX3QJCWxvY2s7CisJdm9pZCBfX2lvbWVt
CQkqcmVnczsKKworCXN0cnVjdCBzY2F0dGVybGlzdAkqc2c7CisJdW5zaWduZWQgaW50CQlwaW9f
b2Zmc2V0OworCisJc3RydWN0IGR3X21jaV9zbG90CSpjdXJfc2xvdDsKKwlzdHJ1Y3QgbW1jX3Jl
cXVlc3QJKm1ycTsKKwlzdHJ1Y3QgbW1jX2NvbW1hbmQJKmNtZDsKKwlzdHJ1Y3QgbW1jX2RhdGEJ
CSpkYXRhOworCisJLyogRE1BIGludGVyZmFjZSBtZW1iZXJzKi8KKwlpbnQJCQl1c2VfZG1hOwor
CisJZG1hX2FkZHJfdAkJc2dfZG1hOworCXZvaWQJCQkqc2dfY3B1OworCXN0cnVjdCBkd19tY2lf
ZG1hX29wcwkqZG1hX29wczsKKyNpZmRlZiBDT05GSUdfTU1DX0RXX0lETUFDCisJdW5zaWduZWQg
aW50CQlyaW5nX3NpemU7CisjZWxzZQorCXN0cnVjdCBkd19tY2lfZG1hX2RhdGEJKmRtYV9kYXRh
OworI2VuZGlmCisJdTMyCQkJY21kX3N0YXR1czsKKwl1MzIJCQlkYXRhX3N0YXR1czsKKwl1MzIJ
CQlzdG9wX2NtZHI7CisJdTMyCQkJZGlyX3N0YXR1czsKKwlzdHJ1Y3QgdGFza2xldF9zdHJ1Y3QJ
dGFza2xldDsKKwlzdHJ1Y3QgdGFza2xldF9zdHJ1Y3QJY2FyZF90YXNrbGV0OworCXVuc2lnbmVk
IGxvbmcJCXBlbmRpbmdfZXZlbnRzOworCXVuc2lnbmVkIGxvbmcJCWNvbXBsZXRlZF9ldmVudHM7
CisJZW51bSBkd19tY2lfc3RhdGUJc3RhdGU7CisJc3RydWN0IGxpc3RfaGVhZAlxdWV1ZTsKKwor
CXUzMgkJCWJ1c19oejsKKwl1MzIJCQljdXJyZW50X3NwZWVkOworCXUzMgkJCW51bV9zbG90czsK
KwlzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlCSpwZGV2OworCXN0cnVjdCBkd19tY2lfYm9hcmQJKnBk
YXRhOworCXN0cnVjdCBkd19tY2lfc2xvdAkqc2xvdFtNQVhfTUNJX1NMT1RTXTsKKworCS8qIEZJ
Rk8gcHVzaCBhbmQgcHVsbCAqLworCWludAkJCWRhdGFfc2hpZnQ7CisJdm9pZCAoKnB1c2hfZGF0
YSkoc3RydWN0IGR3X21jaSAqaG9zdCwgdm9pZCAqYnVmLCBpbnQgY250KTsKKwl2b2lkICgqcHVs
bF9kYXRhKShzdHJ1Y3QgZHdfbWNpICpob3N0LCB2b2lkICpidWYsIGludCBjbnQpOworCisJLyog
V29ya2Fyb3VuZCBmbGFncyAqLworCXUzMgkJCXF1aXJrczsKK307CisKKy8qIERNQSBvcHMgZm9y
IEludGVybmFsL0V4dGVybmFsIERNQUMgaW50ZXJmYWNlICovCitzdHJ1Y3QgZHdfbWNpX2RtYV9v
cHMgeworCS8qIERNQSBPcHMgKi8KKwlpbnQgKCppbml0KShzdHJ1Y3QgZHdfbWNpICpob3N0KTsK
Kwl2b2lkICgqc3RhcnQpKHN0cnVjdCBkd19tY2kgKmhvc3QsIHVuc2lnbmVkIGludCBzZ19sZW4p
OworCXZvaWQgKCpjb21wbGV0ZSkoc3RydWN0IGR3X21jaSAqaG9zdCk7CisJdm9pZCAoKnN0b3Ap
KHN0cnVjdCBkd19tY2kgKmhvc3QpOworCXZvaWQgKCpjbGVhbnVwKShzdHJ1Y3QgZHdfbWNpICpo
b3N0KTsKKwl2b2lkICgqZXhpdCkoc3RydWN0IGR3X21jaSAqaG9zdCk7Cit9OworCisvKiBJUCBR
dWlya3MvZmxhZ3MuICovCisvKiBObyBzcGVjaWFsIHF1aXJrcyBvciBmbGFncyB0byBjYXRlciBm
b3IgKi8KKyNkZWZpbmUgRFdfTUNJX1FVSVJLX05PTkUJCTAKKy8qIERUTyBmaXggZm9yIGNvbW1h
bmQgdHJhbnNtaXNzaW9uIHdpdGggSURNQUMgY29uZmlndXJlZCAqLworI2RlZmluZSBEV19NQ0lf
UVVJUktfSURNQUNfRFRPCQkxCisvKiBkZWxheSBuZWVkZWQgYmV0d2VlbiByZXRyaWVzIG9uIHNv
bWUgMi4xMWEgaW1wbGVtZW50YXRpb25zICovCisjZGVmaW5lIERXX01DSV9RVUlSS19SRVRSWV9E
RUxBWQkyCisvKiBIaWdoIFNwZWVkIENhcGFibGUgLSBTdXBwb3J0cyBIUyBjYXJkcyAodXB0byA1
ME1IeikgKi8KKyNkZWZpbmUgRFdfTUNJX1FVSVJLX0hJR0hTUEVFRAkJNAorCisKK3N0cnVjdCBk
bWFfcGRhdGE7CisKK3N0cnVjdCBibG9ja19zZXR0aW5ncyB7CisJdW5zaWduZWQgc2hvcnQJbWF4
X3NlZ3M7CS8qIHNlZSBibGtfcXVldWVfbWF4X3NlZ21lbnRzICovCisJdW5zaWduZWQgaW50CW1h
eF9ibGtfc2l6ZTsJLyogbWF4aW11bSBzaXplIG9mIG9uZSBtbWMgYmxvY2sgKi8KKwl1bnNpZ25l
ZCBpbnQJbWF4X2Jsa19jb3VudDsJLyogbWF4aW11bSBudW1iZXIgb2YgYmxvY2tzIGluIG9uZSBy
ZXEqLworCXVuc2lnbmVkIGludAltYXhfcmVxX3NpemU7CS8qIG1heGltdW0gbnVtYmVyIG9mIGJ5
dGVzIGluIG9uZSByZXEqLworCXVuc2lnbmVkIGludAltYXhfc2VnX3NpemU7CS8qIHNlZSBibGtf
cXVldWVfbWF4X3NlZ21lbnRfc2l6ZSAqLworfTsKKworLyogQm9hcmQgcGxhdGZvcm0gZGF0YSAq
Lworc3RydWN0IGR3X21jaV9ib2FyZCB7CisJdTMyIG51bV9zbG90czsKKworCXUzMiBxdWlya3M7
IC8qIFdvcmthcm91bmQgLyBRdWlyayBmbGFncyAqLworCXVuc2lnbmVkIGxvbmcgYnVzX2h6OyAv
KiBCdXMgc3BlZWQgKi8KKworCS8qIGRlbGF5IGluIG1TIGJlZm9yZSBkZXRlY3RpbmcgY2FyZHMg
YWZ0ZXIgaW50ZXJydXB0ICovCisJdTMyIGRldGVjdF9kZWxheV9tczsKKworCWludCAoKmluaXQp
KHUzMiBzbG90X2lkLCBpcnFfaGFuZGxlcl90ICwgdm9pZCAqKTsKKwlpbnQgKCpnZXRfcm8pKHUz
MiBzbG90X2lkKTsKKwlpbnQgKCpnZXRfY2QpKHUzMiBzbG90X2lkKTsKKwlpbnQgKCpnZXRfb2Ny
KSh1MzIgc2xvdF9pZCk7CisJaW50ICgqZ2V0X2J1c193ZCkodTMyIHNsb3RfaWQpOworCS8qCisJ
ICogRW5hYmxlIHBvd2VyIHRvIHNlbGVjdGVkIHNsb3QgYW5kIHNldCB2b2x0YWdlIHRvIGRlc2ly
ZWQgbGV2ZWwuCisJICogVm9sdGFnZSBsZXZlbHMgYXJlIHNwZWNpZmllZCB1c2luZyBNTUNfVkRE
X3h4eCBkZWZpbmVzIGRlZmluZWQKKwkgKiBpbiBsaW51eC9tbWMvaG9zdC5oIGZpbGUuCisJICov
CisJdm9pZCAoKnNldHBvd2VyKSh1MzIgc2xvdF9pZCwgdTMyIHZvbHQpOworCXZvaWQgKCpleGl0
KSh1MzIgc2xvdF9pZCk7CisJdm9pZCAoKnNlbGVjdF9zbG90KSh1MzIgc2xvdF9pZCk7CisKKwlz
dHJ1Y3QgZHdfbWNpX2RtYV9vcHMgKmRtYV9vcHM7CisJc3RydWN0IGRtYV9wZGF0YSAqZGF0YTsK
KwlzdHJ1Y3QgYmxvY2tfc2V0dGluZ3MgKmJsa19zZXR0aW5nczsKK307CisKKyNlbmRpZiAvKiBf
TElOVVhfTU1DX0RXX01NQ19IXyAqLwotLSAKMS43LjIuMgoK
--00163649a3e386a83c0496bfe248--
