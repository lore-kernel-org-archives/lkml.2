Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab1C2KTl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:19:41 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45044 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1C2KTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=H1r4DtOHTTSg/Cx5WqTE9V4qih1w3rY9/0J04YiaVYh7HQiY2Nb9vGIHFO7+7oHcxE
         +WzMBtQBbPh0LgQ2hyhcQirQAoosz8dI3VUKNPO5KqrupoPbLiJNwv3e5VJjG6IVksTB
         qSempWS4FrkpM/iqDNXmLLcEMpjveY2/LS864=
MIME-Version: 1.0
From: "vooon341@gmail.com" <vooon341@gmail.com>
Date: Tue, 29 Mar 2011 14:19:18 +0400
Message-ID: <AANLkTi=cMzOj-NEc0uksDDBiBvyaKQWta9T9jtO12Gxr@mail.gmail.com>
Subject: [PATCH] mmc: Add MPC512x SDHC driver.
To: linux-mmc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds MPC512x SDHC driver.

MPC512x have similar sdhc module as in MX2/MX3,
but use different access to the registers.

DMA currently not supported.

Signed-off-by: Vladimir Ermakov <vooon341@gmail.com>
---
 drivers/mmc/host/Kconfig  |    8 +
 drivers/mmc/host/Makefile |    1 +
 drivers/mmc/host/mpcmmc.c |  840 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 849 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 1a21c64..c45deaa 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -328,6 +328,14 @@ config MMC_MXS

 	  If unsure, say N.

+config MMC_MPC512x
+	tristate "Freescale MPC512x Secure Digital Host Controller support"
+	depends on PPC_MPC512x
+	default n
+	help
+	  This selects the SD Host Controller on the MPC5121 and MPC5125.
+	  If you have a MPC512x Platform with SD slot, say Y or M here.
+
 config MMC_TIFM_SD
 	tristate "TI Flash Media MMC/SD Interface support  (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && PCI
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index 30aa686..aec3ed0 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_MMC_DW)		+= dw_mmc.o
 obj-$(CONFIG_MMC_SH_MMCIF)	+= sh_mmcif.o
 obj-$(CONFIG_MMC_JZ4740)	+= jz4740_mmc.o
 obj-$(CONFIG_MMC_USHC)		+= ushc.o
+obj-$(CONFIG_MMC_MPC512x)	+= mpcmmc.o

 obj-$(CONFIG_MMC_SDHCI_PLTFM)			+= sdhci-platform.o
 sdhci-platform-y				:= sdhci-pltfm.o
diff --git a/drivers/mmc/host/mpcmmc.c b/drivers/mmc/host/mpcmmc.c
new file mode 100644
index 0000000..b26a4cf
--- /dev/null
+++ b/drivers/mmc/host/mpcmmc.c
@@ -0,0 +1,840 @@
+/*
+ *  drivers/mmc/host/mpcmmc.c
+ *  Freescale MPC512x Secure Digital Host Controller driver
+ *
+ *  This is a driver for the SDHC controller found in Freescale MPC512x
+ *  SoCs. It is basically the same hardware as found on MX2/MX3 (mxcmmc.c).
+ *
+ *  Copyright (C) 2011 Ermakov Vladimir <vooon341@gmail.com>
+ *  Copyright (C) 2008 Freescale Semicondutor, Inc. All rights reserved.
+ *
+ * derived from mxcmmc.c by Sascha Hauer
+ *
+ * This program is free software; you can redistribute  it and/or modify it
+ * under  the terms of  the GNU General  Public License as published by the
+ * Free Software Foundation;  either version 2 of the  License, or (at your
+ * option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/highmem.h>
+#include <linux/dma-mapping.h>
+#include <linux/scatterlist.h>
+#include <linux/uaccess.h>
+#include <linux/clk.h>
+#include <linux/of_device.h>
+#include <linux/of_platform.h>
+#include <linux/slab.h>
+#include <linux/err.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sd.h>
+#include <linux/mmc/host.h>
+
+#include <asm/reg.h>
+
+#define DRIVER_NAME "mpc-mmc"
+
+#define MMC_REG_STR_STP_CLK		0x00
+#define MMC_REG_STATUS			0x04
+#define MMC_REG_CLK_RATE		0x08
+#define MMC_REG_CMD_DAT_CONT		0x0C
+#define MMC_REG_RES_TO			0x10
+#define MMC_REG_READ_TO			0x14
+#define MMC_REG_BLK_LEN			0x18
+#define MMC_REG_NOB			0x1C
+#define MMC_REG_REV_NO			0x20
+#define MMC_REG_INT_CNTR		0x24
+#define MMC_REG_CMD			0x28
+#define MMC_REG_ARG			0x2C
+#define MMC_REG_RES_FIFO		0x34
+#define MMC_REG_BUFFER_ACCESS		0x38
+
+#define STR_STP_CLK_IPG_CLK_GATE_DIS	(1 << 15)
+#define STR_STP_CLK_IPG_PERCLK_GATE_DIS	(1 << 14)
+#define STR_STP_CLK_RESET		(1 << 3)
+#define STR_STP_CLK_START_CLK		(1 << 1)
+#define STR_STP_CLK_STOP_CLK		(1 << 0)
+
+#define STATUS_CARD_INSERTION		(1 << 31)
+#define STATUS_CARD_REMOVAL		(1 << 30)
+#define STATUS_YBUF_EMPTY		(1 << 29)
+#define STATUS_XBUF_EMPTY		(1 << 28)
+#define STATUS_YBUF_FULL		(1 << 27)
+#define STATUS_XBUF_FULL		(1 << 26)
+#define STATUS_BUF_UND_RUN		(1 << 25)
+#define STATUS_BUF_OVFL			(1 << 24)
+#define STATUS_SDIO_INT_ACTIVE		(1 << 14)
+#define STATUS_END_CMD_RESP		(1 << 13)
+#define STATUS_WRITE_OP_DONE		(1 << 12)
+#define STATUS_DATA_TRANS_DONE		(1 << 11)
+#define STATUS_READ_OP_DONE		(1 << 11)
+#define STATUS_WR_CRC_ERROR_CODE_MASK	(3 << 10)
+#define STATUS_CARD_BUS_CLK_RUN		(1 << 8)
+#define STATUS_BUF_READ_RDY		(1 << 7)
+#define STATUS_BUF_WRITE_RDY		(1 << 6)
+#define STATUS_RESP_CRC_ERR		(1 << 5)
+#define STATUS_CRC_READ_ERR		(1 << 3)
+#define STATUS_CRC_WRITE_ERR		(1 << 2)
+#define STATUS_TIME_OUT_RESP		(1 << 1)
+#define STATUS_TIME_OUT_READ		(1 << 0)
+#define STATUS_ERR_MASK			0x3f
+
+#define CMD_DAT_CONT_CMD_RESP_LONG_OFF	(1 << 12)
+#define CMD_DAT_CONT_STOP_READWAIT	(1 << 11)
+#define CMD_DAT_CONT_START_READWAIT	(1 << 10)
+#define CMD_DAT_CONT_BUS_WIDTH_4	(2 << 8)
+#define CMD_DAT_CONT_INIT		(1 << 7)
+#define CMD_DAT_CONT_WRITE		(1 << 4)
+#define CMD_DAT_CONT_DATA_ENABLE	(1 << 3)
+#define CMD_DAT_CONT_RESPONSE_48BIT_CRC	(1 << 0)
+#define CMD_DAT_CONT_RESPONSE_136BIT	(2 << 0)
+#define CMD_DAT_CONT_RESPONSE_48BIT	(3 << 0)
+
+#define INT_SDIO_INT_WKP_EN		(1 << 18)
+#define INT_CARD_INSERTION_WKP_EN	(1 << 17)
+#define INT_CARD_REMOVAL_WKP_EN		(1 << 16)
+#define INT_CARD_INSERTION_EN		(1 << 15)
+#define INT_CARD_REMOVAL_EN		(1 << 14)
+#define INT_SDIO_IRQ_EN			(1 << 13)
+#define INT_DAT0_EN			(1 << 12)
+#define INT_BUF_READ_EN			(1 << 4)
+#define INT_BUF_WRITE_EN		(1 << 3)
+#define INT_END_CMD_RES_EN		(1 << 2)
+#define INT_WRITE_OP_DONE_EN		(1 << 1)
+#define INT_READ_OP_EN			(1 << 0)
+
+struct mpcmci_host {
+	struct mmc_host		*mmc;
+	struct resource		res;
+	void __iomem		*base;
+	int			irq;
+	int			detect_irq;
+	int			default_irq_mask;
+	int			use_sdio;
+	unsigned int		power_mode;
+
+	struct mmc_request	*req;
+	struct mmc_command	*cmd;
+	struct mmc_data		*data;
+
+	unsigned int		datasize;
+
+	u16			rev_no;
+	unsigned int		cmdat;
+
+	struct clk		*clk;
+
+	int			clock;
+
+	struct work_struct	datawork;
+	spinlock_t		lock;
+};
+
+static void mpcmci_set_clk_rate(struct mpcmci_host *host, unsigned
int clk_ios);
+
+static inline void mpcmci_writel(struct mpcmci_host *host, u32 val, u32 reg)
+{
+	out_be32(host->base + reg, val);
+}
+
+static inline u32 mpcmci_readl(struct mpcmci_host *host, u32 reg)
+{
+	return in_be32(host->base + reg);
+}
+
+static void mpcmci_softreset(struct mpcmci_host *host)
+{
+	int i;
+
+	/* reset sequence */
+	mpcmci_writel(host, STR_STP_CLK_RESET, MMC_REG_STR_STP_CLK);
+	mpcmci_writel(host, STR_STP_CLK_RESET | STR_STP_CLK_STOP_CLK,
+			MMC_REG_STR_STP_CLK);
+
+	for (i = 0; i < 8; i++)
+		mpcmci_writel(host, STR_STP_CLK_STOP_CLK, MMC_REG_STR_STP_CLK);
+
+	mpcmci_writel(host, 0x3f, MMC_REG_CLK_RATE);
+
+	mpcmci_writel(host, 0xff, MMC_REG_RES_TO);
+	mpcmci_writel(host, 512, MMC_REG_BLK_LEN);
+	mpcmci_writel(host, 1, MMC_REG_NOB);
+}
+
+static int mpcmci_setup_data(struct mpcmci_host *host, struct mmc_data *data)
+{
+	unsigned int nob = data->blocks;
+	unsigned int blksz = data->blksz;
+	unsigned int datasize = nob * blksz;
+
+	if (data->flags & MMC_DATA_STREAM)
+		nob = 0xffff;
+
+	host->data = data;
+	data->bytes_xfered = 0;
+
+	mpcmci_writel(host, nob, MMC_REG_NOB);
+	mpcmci_writel(host, blksz, MMC_REG_BLK_LEN);
+	host->datasize = datasize;
+
+	return 0;
+}
+
+static int mpcmci_start_cmd(struct mpcmci_host *host, struct mmc_command *cmd,
+		unsigned int cmdat)
+{
+	u32 int_cntr = host->default_irq_mask;
+	unsigned long flags;
+
+	WARN_ON(host->cmd != NULL);
+	host->cmd = cmd;
+
+	switch (mmc_resp_type(cmd)) {
+	case MMC_RSP_R1: /* short CRC, OPCODE */
+	case MMC_RSP_R1B:/* short CRC, OPCODE, BUSY */
+		cmdat |= CMD_DAT_CONT_RESPONSE_48BIT_CRC;
+		break;
+	case MMC_RSP_R2: /* long 136 bit + CRC */
+		cmdat |= CMD_DAT_CONT_RESPONSE_136BIT;
+		break;
+	case MMC_RSP_R3: /* short */
+		cmdat |= CMD_DAT_CONT_RESPONSE_48BIT;
+		break;
+	case MMC_RSP_NONE:
+		break;
+	default:
+		dev_err(mmc_dev(host->mmc), "unhandled response type 0x%x\n",
+				mmc_resp_type(cmd));
+		cmd->error = -EINVAL;
+		return -EINVAL;
+	}
+
+	int_cntr = INT_END_CMD_RES_EN;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (host->use_sdio)
+		int_cntr |= INT_SDIO_IRQ_EN;
+	mpcmci_writel(host, int_cntr, MMC_REG_INT_CNTR);
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	mpcmci_writel(host, cmd->opcode, MMC_REG_CMD);
+	mpcmci_writel(host, cmd->arg, MMC_REG_ARG);
+	mpcmci_writel(host, cmdat, MMC_REG_CMD_DAT_CONT);
+
+	return 0;
+}
+
+static void mpcmci_finish_request(struct mpcmci_host *host,
+		struct mmc_request *req)
+{
+	u32 int_cntr = host->default_irq_mask;
+	unsigned long flags;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (host->use_sdio)
+		int_cntr |= INT_SDIO_IRQ_EN;
+	mpcmci_writel(host, int_cntr, MMC_REG_INT_CNTR);
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	host->req = NULL;
+	host->cmd = NULL;
+	host->data = NULL;
+
+	mmc_request_done(host->mmc, req);
+}
+
+static int mpcmci_finish_data(struct mpcmci_host *host, unsigned int stat)
+{
+	struct mmc_data *data = host->data;
+	int data_error;
+
+	if (stat & STATUS_ERR_MASK) {
+		dev_dbg(mmc_dev(host->mmc), "request failed. status: 0x%08x\n",
+				stat);
+		if (stat & STATUS_CRC_READ_ERR) {
+			dev_err(mmc_dev(host->mmc), "%s: -EILSEQ\n", __func__);
+			data->error = -EILSEQ;
+		} else if (stat & STATUS_CRC_WRITE_ERR) {
+			u32 err_code = (stat >> 9) & 0x3;
+			if (err_code == 2) { /* No CRC response */
+				dev_err(mmc_dev(host->mmc),
+					"%s: No CRC -ETIMEDOUT\n", __func__);
+				data->error = -ETIMEDOUT;
+			} else {
+				dev_err(mmc_dev(host->mmc),
+					"%s: -EILSEQ\n", __func__);
+				data->error = -EILSEQ;
+			}
+		} else if (stat & STATUS_TIME_OUT_READ) {
+			dev_err(mmc_dev(host->mmc),
+				"%s: read -ETIMEDOUT\n", __func__);
+			data->error = -ETIMEDOUT;
+		} else {
+			dev_err(mmc_dev(host->mmc), "%s: -EIO\n", __func__);
+			data->error = -EIO;
+		}
+	} else {
+		data->bytes_xfered = host->datasize;
+	}
+
+	data_error = data->error;
+
+	host->data = NULL;
+
+	return data_error;
+}
+
+static void mpcmci_read_response(struct mpcmci_host *host, unsigned int stat)
+{
+	struct mmc_command *cmd = host->cmd;
+	int i;
+	u32 a, b, c;
+
+	if (!cmd)
+		return;
+
+	if (stat & STATUS_TIME_OUT_RESP) {
+		dev_dbg(mmc_dev(host->mmc), "CMD TIMEOUT\n");
+		cmd->error = -ETIMEDOUT;
+	} else if (stat & STATUS_RESP_CRC_ERR && cmd->flags & MMC_RSP_CRC) {
+		dev_dbg(mmc_dev(host->mmc), "cmd crc error\n");
+		cmd->error = -EILSEQ;
+	}
+
+	if (cmd->flags & MMC_RSP_PRESENT) {
+		if (cmd->flags & MMC_RSP_136) {
+			for (i = 0; i < 4; i++) {
+				a = mpcmci_readl(host, MMC_REG_RES_FIFO);
+				b = mpcmci_readl(host, MMC_REG_RES_FIFO);
+				cmd->resp[i] = a << 16 | b;
+			}
+		} else {
+			a = mpcmci_readl(host, MMC_REG_RES_FIFO);
+			b = mpcmci_readl(host, MMC_REG_RES_FIFO);
+			c = mpcmci_readl(host, MMC_REG_RES_FIFO);
+			cmd->resp[0] = a << 24 | b << 8 | c >> 8;
+		}
+	}
+}
+
+static int mpcmci_poll_status(struct mpcmci_host *host, u32 mask)
+{
+	u32 stat;
+	unsigned long timeout = jiffies + HZ;
+
+	do {
+		stat = mpcmci_readl(host, MMC_REG_STATUS);
+		if (stat & STATUS_ERR_MASK)
+			return stat;
+		if (time_after(jiffies, timeout)) {
+			mpcmci_softreset(host);
+			mpcmci_set_clk_rate(host, host->clock);
+			return STATUS_TIME_OUT_READ;
+		}
+		if (stat & mask)
+			return 0;
+		cpu_relax();
+	} while (1);
+}
+
+static int mpcmci_pull(struct mpcmci_host *host, void *_buf, int bytes)
+{
+	unsigned int stat;
+	u32 *buf = _buf;
+
+	while (bytes > 3) {
+		stat = mpcmci_poll_status(host,
+				STATUS_BUF_READ_RDY | STATUS_READ_OP_DONE);
+		if (stat)
+			return stat;
+		*buf++ = mpcmci_readl(host, MMC_REG_BUFFER_ACCESS);
+		bytes -= 4;
+	}
+
+	if (bytes) {
+		u8 *b = (u8 *)buf;
+		u32 tmp;
+
+		stat = mpcmci_poll_status(host,
+				STATUS_BUF_READ_RDY | STATUS_READ_OP_DONE);
+		if (stat)
+			return stat;
+		tmp = mpcmci_readl(host, MMC_REG_BUFFER_ACCESS);
+		memcpy(b, &tmp, bytes);
+	}
+
+	return 0;
+}
+
+static int mpcmci_push(struct mpcmci_host *host, void *_buf, int bytes)
+{
+	unsigned int stat;
+	u32 *buf = _buf;
+
+	while (bytes > 3) {
+		stat = mpcmci_poll_status(host, STATUS_BUF_WRITE_RDY);
+		if (stat)
+			return stat;
+		mpcmci_writel(host, *buf++, MMC_REG_BUFFER_ACCESS);
+		bytes -= 4;
+	}
+
+	if (bytes) {
+		u8 *b = (u8 *)buf;
+		u32 tmp;
+
+		stat = mpcmci_poll_status(host, STATUS_BUF_WRITE_RDY);
+		if (stat)
+			return stat;
+
+		memcpy(&tmp, b, bytes);
+		mpcmci_writel(host, tmp, MMC_REG_BUFFER_ACCESS);
+	}
+
+	stat = mpcmci_poll_status(host, STATUS_BUF_WRITE_RDY);
+	if (stat)
+		return stat;
+
+	return 0;
+}
+
+static int mpcmci_transfer_data(struct mpcmci_host *host)
+{
+	struct mmc_data *data = host->req->data;
+	struct scatterlist *sg;
+	int stat, i;
+
+	host->data = data;
+	host->datasize = 0;
+
+	if (data->flags & MMC_DATA_READ) {
+		for_each_sg(data->sg, sg, data->sg_len, i) {
+			stat = mpcmci_pull(host, sg_virt(sg), sg->length);
+			if (stat)
+				return stat;
+			host->datasize += sg->length;
+		}
+	} else {
+		for_each_sg(data->sg, sg, data->sg_len, i) {
+			stat = mpcmci_push(host, sg_virt(sg), sg->length);
+			if (stat)
+				return stat;
+			host->datasize += sg->length;
+		}
+		stat = mpcmci_poll_status(host, STATUS_WRITE_OP_DONE);
+		if (stat)
+			return stat;
+	}
+	return 0;
+}
+
+static void mpcmci_datawork(struct work_struct *work)
+{
+	struct mpcmci_host *host = container_of(work, struct mpcmci_host,
+						  datawork);
+	int datastat = mpcmci_transfer_data(host);
+
+	mpcmci_writel(host, STATUS_READ_OP_DONE | STATUS_WRITE_OP_DONE,
+			MMC_REG_STATUS);
+	mpcmci_finish_data(host, datastat);
+
+	if (host->req->stop) {
+		if (mpcmci_start_cmd(host, host->req->stop, 0)) {
+			mpcmci_finish_request(host, host->req);
+			return;
+		}
+	} else {
+		mpcmci_finish_request(host, host->req);
+	}
+}
+
+static void mpcmci_data_done(struct mpcmci_host *host, unsigned int stat)
+{
+	struct mmc_data *data = host->data;
+	int data_error;
+
+	if (!data)
+		return;
+
+	data_error = mpcmci_finish_data(host, stat);
+
+	mpcmci_read_response(host, stat);
+	host->cmd = NULL;
+
+	if (host->req->stop) {
+		if (mpcmci_start_cmd(host, host->req->stop, 0)) {
+			mpcmci_finish_request(host, host->req);
+			return;
+		}
+	} else {
+		mpcmci_finish_request(host, host->req);
+	}
+}
+
+static void mpcmci_cmd_done(struct mpcmci_host *host, unsigned int stat)
+{
+	mpcmci_read_response(host, stat);
+	host->cmd = NULL;
+
+	if (!host->data && host->req) {
+		mpcmci_finish_request(host, host->req);
+		return;
+	}
+
+	/* For the DMA case the DMA engine handles the data transfer
+	 * automatically. For non DMA we have to do it ourselves.
+	 * Don't do it in interrupt context though.
+	 */
+	if (host->data)
+		schedule_work(&host->datawork);
+
+}
+
+static irqreturn_t mpcmci_irq(int irq, void *devid)
+{
+	struct mpcmci_host *host = devid;
+	unsigned long flags;
+	bool sdio_irq;
+	u32 stat;
+
+	stat = mpcmci_readl(host, MMC_REG_STATUS);
+	mpcmci_writel(host, stat & ~(STATUS_SDIO_INT_ACTIVE |
+			STATUS_DATA_TRANS_DONE | STATUS_WRITE_OP_DONE),
+			MMC_REG_STATUS);
+
+	dev_dbg(mmc_dev(host->mmc), "%s: 0x%08x\n", __func__, stat);
+
+	spin_lock_irqsave(&host->lock, flags);
+	sdio_irq = (stat & STATUS_SDIO_INT_ACTIVE) && host->use_sdio;
+	spin_unlock_irqrestore(&host->lock, flags);
+
+	if (sdio_irq) {
+		mpcmci_writel(host, STATUS_SDIO_INT_ACTIVE, MMC_REG_STATUS);
+		mmc_signal_sdio_irq(host->mmc);
+	}
+
+	if (stat & STATUS_END_CMD_RESP)
+		mpcmci_cmd_done(host, stat);
+
+	if (host->default_irq_mask &&
+		  (stat & (STATUS_CARD_INSERTION | STATUS_CARD_REMOVAL)))
+		mmc_detect_change(host->mmc, msecs_to_jiffies(200));
+
+	return IRQ_HANDLED;
+}
+
+/* ------------------------------------------------------------------------ */
+/* MMC callbacks */
+
+static void mpcmci_request(struct mmc_host *mmc, struct mmc_request *req)
+{
+	struct mpcmci_host *host = mmc_priv(mmc);
+	unsigned int cmdat = host->cmdat;
+	int error;
+
+	WARN_ON(host->req != NULL);
+
+	host->req = req;
+	host->cmdat &= ~CMD_DAT_CONT_INIT;
+
+	if (req->data) {
+		error = mpcmci_setup_data(host, req->data);
+		if (error) {
+			req->cmd->error = error;
+			goto out;
+		}
+
+
+		cmdat |= CMD_DAT_CONT_DATA_ENABLE;
+
+		if (req->data->flags & MMC_DATA_WRITE)
+			cmdat |= CMD_DAT_CONT_WRITE;
+	}
+
+	error = mpcmci_start_cmd(host, req->cmd, cmdat);
+
+out:
+	if (error)
+		mpcmci_finish_request(host, req);
+}
+
+static void mpcmci_set_clk_rate(struct mpcmci_host *host, unsigned int clk_ios)
+{
+	unsigned int divider;
+	int prescaler = 0;
+	unsigned int clk_in = clk_get_rate(host->clk);
+
+	while (prescaler <= 0x800) {
+		for (divider = 1; divider <= 0xF; divider++) {
+			int x;
+
+			x = (clk_in / (divider + 1));
+
+			if (prescaler)
+				x /= (prescaler * 2);
+
+			if (x <= clk_ios)
+				break;
+		}
+		if (divider < 0x10)
+			break;
+
+		if (prescaler == 0)
+			prescaler = 1;
+		else
+			prescaler <<= 1;
+	}
+
+	mpcmci_writel(host, (prescaler << 4) | divider, MMC_REG_CLK_RATE);
+
+	dev_dbg(mmc_dev(host->mmc), "scaler: %d divider: %d in: %d out: %d\n",
+			prescaler, divider, clk_in, clk_ios);
+}
+
+static void mpcmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
+{
+	struct mpcmci_host *host = mmc_priv(mmc);
+	int ret;
+
+
+	if (ios->bus_width == MMC_BUS_WIDTH_4)
+		host->cmdat |= CMD_DAT_CONT_BUS_WIDTH_4;
+	else
+		host->cmdat &= ~CMD_DAT_CONT_BUS_WIDTH_4;
+
+	if (host->power_mode != ios->power_mode) {
+		/* power regulator not supported */
+		host->power_mode = ios->power_mode;
+
+		if (ios->power_mode == MMC_POWER_ON)
+			host->cmdat |= CMD_DAT_CONT_INIT;
+	}
+
+	if (ios->clock) {
+		mpcmci_set_clk_rate(host, ios->clock);
+		mpcmci_writel(host, STR_STP_CLK_START_CLK, MMC_REG_STR_STP_CLK);
+	} else {
+		mpcmci_writel(host, STR_STP_CLK_STOP_CLK, MMC_REG_STR_STP_CLK);
+	}
+
+	host->clock = ios->clock;
+}
+
+static irqreturn_t mpcmci_detect_irq(int irq, void *data)
+{
+	struct mmc_host *mmc = data;
+
+	dev_dbg(mmc_dev(mmc), "%s\n", __func__);
+
+	mmc_detect_change(mmc, msecs_to_jiffies(250));
+	return IRQ_HANDLED;
+}
+
+static int mpcmci_get_ro(struct mmc_host *mmc)
+{
+	struct mpcmci_host *host = mmc_priv(mmc);
+
+	/*
+	 * Board doesn't support read only detection; let the mmc core
+	 * decide what to do.
+	 */
+	return -ENOSYS;
+}
+
+static void mpcmci_enable_sdio_irq(struct mmc_host *mmc, int enable)
+{
+	struct mpcmci_host *host = mmc_priv(mmc);
+	unsigned long flags;
+	u32 int_cntr;
+
+	spin_lock_irqsave(&host->lock, flags);
+	host->use_sdio = enable;
+	int_cntr = mpcmci_readl(host, MMC_REG_INT_CNTR);
+
+	if (enable)
+		int_cntr |= INT_SDIO_IRQ_EN;
+	else
+		int_cntr &= ~INT_SDIO_IRQ_EN;
+
+	mpcmci_writel(host, int_cntr, MMC_REG_INT_CNTR);
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+static const struct mmc_host_ops mpcmci_ops = {
+	.request		= mpcmci_request,
+	.set_ios		= mpcmci_set_ios,
+	.get_ro			= mpcmci_get_ro,
+	.enable_sdio_irq	= mpcmci_enable_sdio_irq,
+};
+
+/* ------------------------------------------------------------------------ */
+/* Device probing/removal */
+
+static int __devinit mpcmci_probe(struct platform_device *op)
+{
+	struct device_node *np = op->dev.of_node;
+	struct mmc_host *mmc;
+	struct mpcmci_host *host = NULL;
+	int ret = 0;
+
+	printk(KERN_INFO "MPC512x SDHC driver\n");
+
+	mmc = mmc_alloc_host(sizeof(struct mpcmci_host), &op->dev);
+	if (!mmc)
+		return -ENOMEM;
+
+	mmc->ops = &mpcmci_ops;
+	mmc->caps = MMC_CAP_4_BIT_DATA | MMC_CAP_SDIO_IRQ;
+
+	/* MMC core transfer sizes tunable parameters */
+	mmc->max_segs = 64;
+	mmc->max_blk_size = 2048;
+	mmc->max_blk_count = 65535;
+	mmc->max_req_size = mmc->max_blk_size * mmc->max_blk_count;
+	mmc->max_seg_size = mmc->max_req_size;
+	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
+
+	host = mmc_priv(mmc);
+
+	ret = of_address_to_resource(np, 0, &host->res);
+	if (ret)
+		goto out_free;
+
+	if (!request_mem_region(host->res.start, resource_size(&host->res),
+				DRIVER_NAME)) {
+		ret = -EBUSY;
+		goto out_release_mem;
+	}
+
+	host->base = ioremap(host->res.start, resource_size(&host->res));
+	if (!host->base) {
+		ret = -ENOMEM;
+		goto out_release_mem;
+	}
+
+	host->irq = irq_of_parse_and_map(np, 0);
+
+	host->mmc = mmc;
+	spin_lock_init(&host->lock);
+
+	if (1) /* D3 insertion detection */
+		host->default_irq_mask =
+			INT_CARD_INSERTION_EN | INT_CARD_REMOVAL_EN;
+	else
+		host->default_irq_mask = 0;
+
+	host->clk = clk_get(&op->dev, "sdhc_clk");
+	if (IS_ERR(host->clk)) {
+		ret = PTR_ERR(host->clk);
+		goto out_iounmap;
+	}
+	clk_enable(host->clk);
+
+	mpcmci_softreset(host);
+
+	host->rev_no = mpcmci_readl(host, MMC_REG_REV_NO);
+	if (host->rev_no != 0x400) {
+		ret = -ENODEV;
+		dev_err(mmc_dev(host->mmc), "wrong rev.no. 0x%08x. aborting.\n",
+			host->rev_no);
+		goto out_clk_put;
+	}
+
+	mmc->f_min = clk_get_rate(host->clk) >> 16;
+	mmc->f_max = clk_get_rate(host->clk) >> 1;
+
+	/* recommended in data sheet */
+	mpcmci_writel(host, 0x2db4, MMC_REG_READ_TO);
+
+	mpcmci_writel(host, host->default_irq_mask, MMC_REG_INT_CNTR);
+
+	dev_info(mmc_dev(host->mmc), "dma not available. Using PIO\n");
+
+	INIT_WORK(&host->datawork, mpcmci_datawork);
+
+	ret = request_irq(host->irq, mpcmci_irq, 0, DRIVER_NAME, host);
+	if (ret)
+		goto out_clk_put;
+
+	platform_set_drvdata(op, mmc);
+
+	mmc_add_host(mmc);
+
+	return 0;
+
+out_clk_put:
+	clk_disable(host->clk);
+	clk_put(host->clk);
+out_iounmap:
+	iounmap(host->base);
+out_release_mem:
+	release_mem_region(host->res.start, resource_size(&host->res));
+out_free:
+	mmc_free_host(mmc);
+	return ret;
+}
+
+static int __devexit mpcmci_remove(struct platform_device *op)
+{
+	struct mmc_host *mmc = platform_get_drvdata(op);
+	struct mpcmci_host *host = mmc_priv(mmc);
+
+	platform_set_drvdata(op, NULL);
+
+	mmc_remove_host(mmc);
+
+	free_irq(host->irq, host);
+	iounmap(host->base);
+
+	clk_disable(host->clk);
+	clk_put(host->clk);
+
+	release_mem_region(host->res.start, resource_size(&host->res));
+
+	mmc_free_host(mmc);
+
+	return 0;
+}
+
+
+/*-------------------------------------------------------------------------*/
+static struct of_device_id fsl_mpcmci_match[] __devinitdata = {
+	{ .compatible = "fsl,mpc5121-sdhc", },
+	{ .compatible = "fsl,mpc5125-sdhc", },
+	{},
+};
+
+static struct platform_driver mpcmci_driver = {
+	.driver = {
+		.name =	DRIVER_NAME,
+		.owner = THIS_MODULE,
+		.of_match_table = fsl_mpcmci_match,
+	},
+	.probe = mpcmci_probe,
+	.remove = __devexit_p(mpcmci_remove),
+};
+
+static int __init mpcmci_drv_init(void)
+{
+	return platform_driver_register(&mpcmci_driver);
+}
+
+static void __exit mpcmci_drv_exit(void)
+{
+	platform_driver_unregister(&mpcmci_driver);
+}
+
+module_init(mpcmci_drv_init);
+module_exit(mpcmci_drv_exit);
+
+MODULE_AUTHOR("Freescale Semiconductor, Inc.");
+MODULE_DESCRIPTION("Secure Digital Host Controller driver");
+MODULE_LICENSE("GPL");
-- 
1.7.1
