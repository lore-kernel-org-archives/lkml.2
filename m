Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1CRNYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 09:24:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25991 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab1CRNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 09:24:36 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6288"; a="80729584"
From: Subhash Jadavani <subhashj@codeaurora.org>
To: cjb@laptop.org
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux-kernel@vger.kernel.org
Subject: [RFC] mmc: msm_sdcc: Use SPS BAM as DMA engine
Date: Fri, 18 Mar 2011 18:54:04 +0530
Message-Id: <1300454644-11361-2-git-send-email-subhashj@codeaurora.org>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>
References: <1300454644-11361-1-git-send-email-subhashj@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent MSMs, ADM (Data Mover) HW is not present
which means existing SDCC driver can perform data
transfer in PIO (peripheral IO) mode only.
But PIO mode requires lot of CPU attention which
would mean consuming extra CPU MIPS.

As a replacement on these recent MSMs, there is
a new DMA HW engine named SPS-BAM (as part of
Smart Peripheral System of MSM) is added for
data movement between SDCC core and system memory.

This patch has done changes in existing MSM SDCC
driver for using SPS-BAM as DMA engine.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/mmc/host/Kconfig        |   10 +
 drivers/mmc/host/Makefile       |    1 +
 drivers/mmc/host/msm_sdcc.c     |  929 +++++++++++++++++++++++++++++++++++++--
 drivers/mmc/host/msm_sdcc.h     |   47 ++
 drivers/mmc/host/msm_sdcc_dml.c |  303 +++++++++++++
 drivers/mmc/host/msm_sdcc_dml.h |  120 +++++
 6 files changed, 1374 insertions(+), 36 deletions(-)
 create mode 100644 drivers/mmc/host/msm_sdcc_dml.c
 create mode 100644 drivers/mmc/host/msm_sdcc_dml.h

diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index afe8c6f..8be85a3 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -430,6 +430,16 @@ config MMC_SDRICOH_CS
 	  To compile this driver as a module, choose M here: the
 	  module will be called sdricoh_cs.
 
+config MMC_MSM_SPS_SUPPORT
+	bool "Use SPS BAM HW as DMA engine"
+	depends on MMC_MSM && SPS
+	default n
+	help
+	  Select Y to use SPS BAM as DMA engine on Qualcomm's MSM. This
+	  config should be set when ADM HW is not available.
+
+	  If unsure, say N.
+
 config MMC_TMIO
 	tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function support"
 	depends on MFD_TMIO || MFD_ASIC3 || MFD_SH_MOBILE_SDHI
diff --git a/drivers/mmc/host/Makefile b/drivers/mmc/host/Makefile
index e834fb2..f19cec2 100644
--- a/drivers/mmc/host/Makefile
+++ b/drivers/mmc/host/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_MMC_AT91)		+= at91_mci.o
 obj-$(CONFIG_MMC_ATMELMCI)	+= atmel-mci.o
 obj-$(CONFIG_MMC_TIFM_SD)	+= tifm_sd.o
 obj-$(CONFIG_MMC_MSM)		+= msm_sdcc.o
+obj-$(CONFIG_MMC_MSM_SPS_SUPPORT) += msm_sdcc_dml.o
 obj-$(CONFIG_MMC_MVSDIO)	+= mvsdio.o
 obj-$(CONFIG_MMC_DAVINCI)       += davinci_mmc.o
 obj-$(CONFIG_MMC_SPI)		+= mmc_spi.o
diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 97c9b36..5dbb4ab 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2007 Google Inc,
  *  Copyright (C) 2003 Deep Blue Solutions, Ltd, All Rights Reserved.
- *  Copyright (C) 2009, Code Aurora Forum. All Rights Reserved.
+ *  Copyright (C) 2009-2011, Code Aurora Forum. All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -48,6 +48,7 @@
 #include <mach/clk.h>
 
 #include "msm_sdcc.h"
+#include "msm_sdcc_dml.h"
 
 #define DRIVER_NAME "msm-sdcc"
 
@@ -63,6 +64,12 @@ static unsigned int msmsdcc_sdioirq;
 #define PIO_SPINMAX 30
 #define CMD_SPINMAX 20
 
+#define SPS_SDCC_PRODUCER_PIPE_INDEX	1
+#define SPS_SDCC_CONSUMER_PIPE_INDEX	2
+#define SPS_CONS_PERIPHERAL		0
+#define SPS_PROD_PERIPHERAL		1
+/* 16 KB */
+#define SPS_MAX_DESC_SIZE		(16 * 1024)
 
 static inline void
 msmsdcc_disable_clocks(struct msmsdcc_host *host, int deferr)
@@ -149,7 +156,7 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
 		pr_err("%s: Clock deassert failed at %u Hz with err %d\n",
 				mmc_hostname(host->mmc), host->clk_rate, ret);
 
-	pr_info("%s: Controller has been re-initialiazed\n",
+	pr_debug("%s: Controller has been re-initialiazed\n",
 			mmc_hostname(host->mmc));
 
 	/* Restore the contoller state */
@@ -162,6 +169,70 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
 				mmc_hostname(host->mmc), host->clk_rate, ret);
 }
 
+#ifdef CONFIG_MMC_MSM_SPS_SUPPORT
+static int msmsdcc_sps_reset_ep(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep);
+static int msmsdcc_sps_restore_ep(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep);
+/**
+ * Apply soft reset
+ *
+ * This function applies soft reset to SDCC core and
+ * BAM, DML core.
+ *
+ * This function should be called to recover from error
+ * conditions encountered with CMD/DATA tranfsers with card.
+ *
+ * Soft reset should only be used with SDCC controller v4.
+ *
+ * @host - Pointer to driver's host structure
+ *
+ */
+static void msmsdcc_soft_reset_and_restore(struct msmsdcc_host *host)
+{
+	int rc;
+
+	if (host->is_sps_mode) {
+		/* Reset DML first */
+		msmsdcc_dml_reset(host);
+		/* Now reset all BAM pipes connections */
+		rc = msmsdcc_sps_reset_ep(host, &host->sps.prod);
+		if (rc)
+			pr_err("%s:msmsdcc_sps_reset_ep() error=%d\n",
+					mmc_hostname(host->mmc), rc);
+		rc = msmsdcc_sps_reset_ep(host, &host->sps.cons);
+		if (rc)
+			pr_err("%s:msmsdcc_sps_reset_ep() error=%d\n",
+					mmc_hostname(host->mmc), rc);
+	}
+	/*
+	 * Reset SDCC controller's DPSM (data path state machine
+	 * and CPSM (command path state machine).
+	 */
+	writel(0, host->base + MMCICOMMAND);
+	writel(0, host->base + MMCIDATACTRL);
+
+	pr_debug("%s: %s: Soft reset to SDCC\n",
+		mmc_hostname(host->mmc), __func__);
+
+	if (host->is_sps_mode) {
+		/* Restore all BAM pipes connections */
+		rc = msmsdcc_sps_restore_ep(host, &host->sps.prod);
+		if (rc)
+			pr_err("%s:msmsdcc_sps_restore_ep() error=%d\n",
+					mmc_hostname(host->mmc), rc);
+		rc = msmsdcc_sps_restore_ep(host, &host->sps.cons);
+		if (rc)
+			pr_err("%s:msmsdcc_sps_restore_ep() error=%d\n",
+					mmc_hostname(host->mmc), rc);
+		msmsdcc_dml_init(host);
+	}
+}
+#else
+static inline void msmsdcc_soft_reset_and_restore(
+			struct msmsdcc_host *host) { }
+#endif /* CONFIG_MMC_MSM_SPS_SUPPORT */
+
 static void
 msmsdcc_request_end(struct msmsdcc_host *host, struct mmc_request *mrq)
 {
@@ -308,6 +379,188 @@ out:
 	return;
 }
 
+#ifdef CONFIG_MMC_MSM_SPS_SUPPORT
+/**
+ * Callback notification from SPS driver
+ *
+ * This callback function gets triggered called from
+ * SPS driver when requested SPS data transfer is
+ * completed.
+ *
+ * SPS driver invokes this callback in BAM irq context so
+ * SDCC driver schedule a tasklet for further processing
+ * this callback notification at later point of time in
+ * tasklet context and immediately returns control back
+ * to SPS driver.
+ *
+ * @nofity - Pointer to sps event notify sturcture
+ *
+ */
+static void
+msmsdcc_sps_complete_cb(struct sps_event_notify *notify)
+{
+	struct msmsdcc_host *host =
+		(struct msmsdcc_host *)
+		((struct sps_event_notify *)notify)->user;
+
+	host->sps.notify = *notify;
+	pr_debug("%s: %s: sps ev_id=%d, addr=0x%x, size=0x%x, flags=0x%x\n",
+		mmc_hostname(host->mmc), __func__, notify->event_id,
+		notify->data.transfer.iovec.addr,
+		notify->data.transfer.iovec.size,
+		notify->data.transfer.iovec.flags);
+	/* Schedule a tasklet for completing data transfer */
+	tasklet_schedule(&host->sps.tlet);
+}
+
+/**
+ * Tasklet handler for processing SPS callback event
+ *
+ * This function processing SPS event notification and
+ * checks if the SPS transfer is completed or not and
+ * then accordingly notifies status to MMC core layer.
+ *
+ * This function is called in tasklet context.
+ *
+ * @data - Pointer to sdcc driver data
+ *
+ */
+static void msmsdcc_sps_complete_tlet(unsigned long data)
+{
+	unsigned long flags;
+	int i, rc;
+	u32 data_xfered = 0;
+	struct mmc_request *mrq;
+	struct sps_iovec iovec;
+	struct sps_pipe *sps_pipe_handle;
+	struct msmsdcc_host *host = (struct msmsdcc_host *)data;
+	struct sps_event_notify *notify = &host->sps.notify;
+
+	spin_lock_irqsave(&host->lock, flags);
+	if (host->sps.dir == DMA_FROM_DEVICE)
+		sps_pipe_handle = host->sps.prod.pipe_handle;
+	else
+		sps_pipe_handle = host->sps.cons.pipe_handle;
+	mrq = host->curr.mrq;
+	BUG_ON(!mrq);
+	pr_debug("%s: %s: sps event_id=%d\n",
+		mmc_hostname(host->mmc), __func__,
+		notify->event_id);
+
+	if (msmsdcc_is_dml_busy(host)) {
+		/* oops !!! this should never happen. */
+		pr_err("%s: %s: Received SPS EOT event"
+			" but DML HW is still busy !!!\n",
+			mmc_hostname(host->mmc), __func__);
+	}
+	/*
+	 * Got End of transfer event!!! Check if all of the data
+	 * has been transferred?
+	 */
+	for (i = 0; i < host->sps.xfer_req_cnt; i++) {
+		rc = sps_get_iovec(sps_pipe_handle, &iovec);
+		if (rc) {
+			pr_err("%s: %s: sps_get_iovec() failed rc=%d, i=%d",
+				mmc_hostname(host->mmc), __func__, rc, i);
+			break;
+		}
+		data_xfered += iovec.size;
+	}
+
+	if (data_xfered == host->curr.xfer_size) {
+		host->curr.data_xfered = host->curr.xfer_size;
+		pr_debug("%s: Data xfer success. data_xfered=0x%x",
+			mmc_hostname(host->mmc),
+			host->curr.xfer_size);
+	} else {
+		pr_err("%s: Data xfer failed. data_xfered=0x%x,"
+			" xfer_size=%d", mmc_hostname(host->mmc),
+			data_xfered, host->curr.xfer_size);
+		host->core_reset(host);
+		if (!mrq->data->error)
+			mrq->data->error = -EIO;
+	}
+
+	/* Unmap sg buffers */
+	dma_unmap_sg(mmc_dev(host->mmc), host->sps.sg, host->sps.num_ents,
+			 host->sps.dir);
+
+	host->sps.sg = NULL;
+	host->sps.busy = 0;
+
+	if (host->curr.got_dataend || mrq->data->error) {
+		/*
+		 * If we've already gotten our DATAEND / DATABLKEND
+		 * for this request, then complete it through here.
+		 */
+		msmsdcc_stop_data(host);
+
+		if (!mrq->data->error)
+			host->curr.data_xfered = host->curr.xfer_size;
+		if (!mrq->data->stop || mrq->cmd->error) {
+			host->curr.mrq = NULL;
+			host->curr.cmd = NULL;
+			mrq->data->bytes_xfered = host->curr.data_xfered;
+
+			spin_unlock_irqrestore(&host->lock, flags);
+
+#ifdef CONFIG_MMC_MSM_PROG_DONE_SCAN
+			if ((mrq->cmd->opcode == SD_IO_RW_EXTENDED)
+				&& (mrq->cmd->arg & 0x80000000)) {
+				/* Set the prog_scan in a cmd53.*/
+				host->prog_scan = 1;
+				/* Send STOP to let the SDCC know to stop. */
+				writel(MCI_CSPM_MCIABORT,
+						host->base + MMCICOMMAND);
+			}
+#endif /* CONFIG_MMC_MSM_PROG_DONE_SCAN */
+			mmc_request_done(host->mmc, mrq);
+			return;
+		} else {
+			msmsdcc_start_command(host, mrq->data->stop, 0);
+		}
+	}
+	spin_unlock_irqrestore(&host->lock, flags);
+}
+
+/**
+ * Exit from current SPS data transfer
+ *
+ * This function exits from current SPS data transfer.
+ *
+ * This function should be called when error condition
+ * is encountered during data transfer.
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ */
+static void msmsdcc_sps_exit_curr_xfer(struct msmsdcc_host *host)
+{
+	struct mmc_request *mrq;
+
+	mrq = host->curr.mrq;
+	BUG_ON(!mrq);
+
+	host->core_reset(host);
+	if (!mrq->data->error)
+		mrq->data->error = -EIO;
+
+	/* Unmap sg buffers */
+	dma_unmap_sg(mmc_dev(host->mmc), host->sps.sg, host->sps.num_ents,
+			 host->sps.dir);
+
+	host->sps.sg = NULL;
+	host->sps.busy = 0;
+	msmsdcc_stop_data(host);
+	msmsdcc_request_end(host, mrq);
+
+}
+#else
+static inline void msmsdcc_sps_complete_cb(struct sps_event_notify *notify) { }
+static inline void msmsdcc_sps_complete_tlet(unsigned long data) { }
+static inline void msmsdcc_sps_exit_curr_xfer(struct msmsdcc_host *host) { }
+#endif /* CONFIG_MMC_MSM_SPS_SUPPORT */
+
 static void
 msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 			  unsigned int result,
@@ -324,16 +577,13 @@ msmsdcc_dma_complete_func(struct msm_dmov_cmd *cmd,
 	tasklet_schedule(&host->dma_tlet);
 }
 
-static int validate_dma(struct msmsdcc_host *host, struct mmc_data *data)
+static int msmsdcc_check_dma_op_req(struct mmc_data *data)
 {
-	if (host->dma.channel == -1)
-		return -ENOENT;
-
-	if ((data->blksz * data->blocks) < MCI_FIFOSIZE)
+	if (((data->blksz * data->blocks) < MCI_FIFOSIZE) ||
+	     ((data->blksz * data->blocks) % MCI_FIFOSIZE))
 		return -EINVAL;
-	if ((data->blksz * data->blocks) % MCI_FIFOSIZE)
-		return -EINVAL;
-	return 0;
+	else
+		return 0;
 }
 
 static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
@@ -343,12 +593,11 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 	uint32_t rows;
 	uint32_t crci;
 	unsigned int n;
-	int i, rc;
+	int i;
 	struct scatterlist *sg = data->sg;
 
-	rc = validate_dma(host, data);
-	if (rc)
-		return rc;
+	if (host->dma.channel == -1)
+		return -ENOENT;
 
 	host->dma.sg = data->sg;
 	host->dma.num_ents = data->sg_len;
@@ -440,6 +689,107 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
 	return 0;
 }
 
+#ifdef CONFIG_MMC_MSM_SPS_SUPPORT
+/**
+ * Submits data transfer request to SPS driver
+ *
+ * This function make sg (scatter gather) data buffers
+ * DMA ready and then submits them to SPS driver for
+ * transfer.
+ *
+ * @host - Pointer to sdcc host structure
+ * @data - Pointer to mmc_data structure
+ *
+ * @return 0 if success else negative value
+ */
+static int msmsdcc_sps_start_xfer(struct msmsdcc_host *host,
+				struct mmc_data *data)
+{
+	int rc = 0;
+	u32 flags;
+	int i;
+	u32 addr, len, data_cnt;
+	struct scatterlist *sg = data->sg;
+	struct sps_pipe *sps_pipe_handle;
+
+	BUG_ON(data->sg_len > NR_SG); /* Prevent memory corruption */
+
+	host->sps.sg = data->sg;
+	host->sps.num_ents = data->sg_len;
+	host->sps.xfer_req_cnt = 0;
+	if (data->flags & MMC_DATA_READ) {
+		host->sps.dir = DMA_FROM_DEVICE;
+		sps_pipe_handle = host->sps.prod.pipe_handle;
+	} else {
+		host->sps.dir = DMA_TO_DEVICE;
+		sps_pipe_handle = host->sps.cons.pipe_handle;
+	}
+
+	/* Make sg buffers DMA ready */
+	rc = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
+			host->sps.dir);
+
+	if (rc != data->sg_len) {
+		pr_err("%s: Unable to map in all sg elements, rc=%d\n",
+		       mmc_hostname(host->mmc), rc);
+		host->sps.sg = NULL;
+		host->sps.num_ents = 0;
+		rc = -ENOMEM;
+		goto dma_map_err;
+	}
+
+	pr_debug("%s: %s: %s: pipe=0x%x, total_xfer=0x%x, sg_len=%d\n",
+		mmc_hostname(host->mmc), __func__,
+		host->sps.dir == DMA_FROM_DEVICE ? "READ" : "WRITE",
+		(u32)sps_pipe_handle, host->curr.xfer_size, data->sg_len);
+
+	for (i = 0; i < data->sg_len; i++) {
+		/*
+		 * Check if this is the last buffer to transfer?
+		 * If yes then set the INT and EOT flags.
+		 */
+		len = sg_dma_len(sg);
+		addr = sg_dma_address(sg);
+		flags = 0;
+		while (len > 0) {
+			if (len > SPS_MAX_DESC_SIZE) {
+				data_cnt = SPS_MAX_DESC_SIZE;
+			} else {
+				data_cnt = len;
+				if (i == data->sg_len - 1)
+					flags = SPS_IOVEC_FLAG_INT |
+						SPS_IOVEC_FLAG_EOT;
+			}
+			rc = sps_transfer_one(sps_pipe_handle, addr,
+						data_cnt, host, flags);
+			if (rc) {
+				pr_err("%s: sps_transfer_one() error! rc=%d,"
+					" pipe=0x%x, sg=0x%x, sg_buf_no=%d\n",
+					mmc_hostname(host->mmc), rc,
+					(u32)sps_pipe_handle, (u32)sg, i);
+				goto dma_map_err;
+			}
+			addr += data_cnt;
+			len -= data_cnt;
+			host->sps.xfer_req_cnt++;
+		}
+		sg++;
+	}
+	goto out;
+
+dma_map_err:
+	/* unmap sg buffers */
+	dma_unmap_sg(mmc_dev(host->mmc), host->sps.sg, host->sps.num_ents,
+			host->sps.dir);
+out:
+	return rc;
+}
+#else
+static int msmsdcc_sps_start_xfer(struct msmsdcc_host *host,
+				struct mmc_data *data) { return 0; }
+#endif /* CONFIG_MMC_MSM_SPS_SUPPORT */
+
+
 static int
 snoop_cccr_abort(struct mmc_command *cmd)
 {
@@ -506,9 +856,34 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 
 	datactrl = MCI_DPSM_ENABLE | (data->blksz << 4);
 
-	if (!msmsdcc_config_dma(host, data))
-		datactrl |= MCI_DPSM_DMAENABLE;
-	else {
+	if (!msmsdcc_check_dma_op_req(data)) {
+		if (host->is_dma_mode && !msmsdcc_config_dma(host, data)) {
+			datactrl |= MCI_DPSM_DMAENABLE;
+		} else if (host->is_sps_mode) {
+			if (!msmsdcc_is_dml_busy(host)) {
+				if (!msmsdcc_sps_start_xfer(host, data)) {
+					/* Now kick start DML transfer */
+					msmsdcc_dml_start_xfer(host, data);
+					datactrl |= MCI_DPSM_DMAENABLE;
+					host->sps.busy = 1;
+				}
+			} else {
+				/*
+				 * Can't proceed with new transfer as
+				 * previous trasnfer is already in progress.
+				 * There is no point of going into PIO mode
+				 * as well. Is this a time to do kernel panic?
+				 */
+				pr_err("%s: %s: DML HW is busy!!!"
+					" Can't perform new SPS transfers"
+					" now\n", mmc_hostname(host->mmc),
+					__func__);
+			}
+		}
+	}
+
+	/* Is data transfer in PIO mode required? */
+	if (!(datactrl & MCI_DPSM_DMAENABLE)) {
 		host->pio.sg = data->sg;
 		host->pio.sg_len = data->sg_len;
 		host->pio.sg_off = 0;
@@ -528,8 +903,9 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 	do_div(clks, NSEC_PER_SEC);
 	timeout = data->timeout_clks + (unsigned int)clks*2 ;
 
-	if (datactrl & MCI_DPSM_DMAENABLE) {
-		/* Save parameters for the exec function */
+	if (host->is_dma_mode && (datactrl & MCI_DPSM_DMAENABLE)) {
+		/* Use ADM (Application Data Mover) HW for Data transfer */
+		/* Save parameters for the dma exec function */
 		host->cmd_timeout = timeout;
 		host->cmd_pio_irqmask = pio_irqmask;
 		host->cmd_datactrl = datactrl;
@@ -543,10 +919,13 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 			msmsdcc_start_command_deferred(host, cmd, &c);
 			host->cmd_c = c;
 		}
-		msm_dmov_enqueue_cmd(host->dma.channel, &host->dma.hdr);
 		if (data->flags & MMC_DATA_WRITE)
 			host->prog_scan = true;
+		msm_dmov_enqueue_cmd(host->dma.channel, &host->dma.hdr);
 	} else {
+		if (data->flags & MMC_DATA_WRITE)
+			host->prog_scan = true;
+		/* SPS-BAM mode or PIO mode */
 		msmsdcc_writel(host, timeout, MMCIDATATIMER);
 
 		msmsdcc_writel(host, host->curr.xfer_size, MMCIDATALENGTH);
@@ -754,11 +1133,17 @@ static void msmsdcc_do_cmdirq(struct msmsdcc_host *host, uint32_t status)
 	}
 
 	if (!cmd->data || cmd->error) {
-		if (host->curr.data && host->dma.sg)
+		if (host->curr.data && host->dma.sg &&
+			host->is_dma_mode)
 			msm_dmov_stop_cmd(host->dma.channel,
 					  &host->dma.hdr, 0);
+		else if (host->curr.data && host->sps.sg &&
+			host->is_sps_mode){
+				/* Stop current SPS transfer */
+				msmsdcc_sps_exit_curr_xfer(host);
+		}
 		else if (host->curr.data) { /* Non DMA */
-			msmsdcc_reset_and_restore(host);
+			host->core_reset(host);
 			msmsdcc_stop_data(host);
 			msmsdcc_request_end(host, cmd->mrq);
 		} else { /* host->data == NULL */
@@ -803,11 +1188,15 @@ msmsdcc_handle_irq_data(struct msmsdcc_host *host, u32 status,
 		      MCI_TXUNDERRUN | MCI_RXOVERRUN)) {
 		msmsdcc_data_err(host, data, status);
 		host->curr.data_xfered = 0;
-		if (host->dma.sg)
+		if (host->dma.sg && host->is_dma_mode)
 			msm_dmov_stop_cmd(host->dma.channel,
 					  &host->dma.hdr, 0);
+		else if (host->sps.sg && host->is_sps_mode) {
+			/* Stop current SPS transfer */
+			msmsdcc_sps_exit_curr_xfer(host);
+		}
 		else {
-			msmsdcc_reset_and_restore(host);
+			host->core_reset(host);
 			if (host->curr.data)
 				msmsdcc_stop_data(host);
 			if (!data->stop)
@@ -824,7 +1213,9 @@ msmsdcc_handle_irq_data(struct msmsdcc_host *host, u32 status,
 	/*
 	 * If DMA is still in progress, we complete via the completion handler
 	 */
-	if (host->curr.got_dataend && !host->dma.busy) {
+	if ((host->is_dma_mode && !host->dma.busy)
+		|| (host->is_sps_mode && !host->sps.busy)
+	) {
 		/*
 		 * There appears to be an issue in the controller where
 		 * if you request a small block transfer (< fifo size),
@@ -1151,6 +1542,405 @@ msmsdcc_init_dma(struct msmsdcc_host *host)
 	return 0;
 }
 
+#ifdef CONFIG_MMC_MSM_SPS_SUPPORT
+/**
+ * Allocate and Connect a SDCC peripheral's SPS endpoint
+ *
+ * This function allocates endpoint context and
+ * connect it with memory endpoint by calling
+ * appropriate SPS driver APIs.
+ *
+ * Also registers a SPS callback function with
+ * SPS driver
+ *
+ * This function should only be called once typically
+ * during driver probe.
+ *
+ * @host - Pointer to sdcc host structure
+ * @ep   - Pointer to sps endpoint data structure
+ * @is_produce - 1 means Producer endpoint
+ *		 0 means Consumer endpoint
+ *
+ * @return - 0 if successful else negative value.
+ *
+ */
+static int msmsdcc_sps_init_ep_conn(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep,
+				bool is_producer)
+{
+	int rc = 0;
+	struct sps_pipe *sps_pipe_handle;
+	struct sps_connect *sps_config = &ep->config;
+	struct sps_register_event *sps_event = &ep->event;
+
+	/* Allocate endpoint context */
+	sps_pipe_handle = sps_alloc_endpoint();
+	if (!sps_pipe_handle) {
+		pr_err("%s: sps_alloc_endpoint() failed!!! is_producer=%d",
+			   mmc_hostname(host->mmc), is_producer);
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* Get default connection configuration for an endpoint */
+	rc = sps_get_config(sps_pipe_handle, sps_config);
+	if (rc) {
+		pr_err("%s: sps_get_config() failed!!! pipe_handle=0x%x,"
+			" rc=%d", mmc_hostname(host->mmc),
+			(u32)sps_pipe_handle, rc);
+		goto get_config_err;
+	}
+
+	/* Modify the default connection configuration */
+	if (is_producer) {
+		/*
+		 * For SDCC producer transfer, source should be
+		 * SDCC peripheral where as destination should
+		 * be system memory.
+		 */
+		sps_config->source = host->sps.bam_handle;
+		sps_config->destination = SPS_DEV_HANDLE_MEM;
+		/* Producer pipe will handle this connection */
+		sps_config->mode = SPS_MODE_SRC;
+		sps_config->options =
+			SPS_O_AUTO_ENABLE | SPS_O_EOT | SPS_O_ACK_TRANSFERS;
+	} else {
+		/*
+		 * For SDCC consumer transfer, source should be
+		 * system memory where as destination should
+		 * SDCC peripheral
+		 */
+		sps_config->source = SPS_DEV_HANDLE_MEM;
+		sps_config->destination = host->sps.bam_handle;
+		sps_config->mode = SPS_MODE_DEST;
+		sps_config->options =
+			SPS_O_AUTO_ENABLE | SPS_O_EOT | SPS_O_ACK_TRANSFERS;
+	}
+
+	/* Producer pipe index */
+	sps_config->src_pipe_index = host->sps.src_pipe_index;
+	/* Consumer pipe index */
+	sps_config->dest_pipe_index = host->sps.dest_pipe_index;
+	/*
+	 * This event thresold value is only significant for BAM-to-BAM
+	 * transfer. It's ignored for BAM-to-System mode transfer.
+	 */
+	sps_config->event_thresh = 0x10;
+	/*
+	 * Max. no of scatter/gather buffers that can
+	 * be passed by block layer = 32 (NR_SG).
+	 * Each BAM descritor needs 64 bits (8 bytes).
+	 * One BAM descriptor is required per buffer transfer.
+	 * So we would require total 256 (32 * 8) bytes of descriptor FIFO.
+	 * But due to HW limitation we need to allocate atleast one extra
+	 * descriptor memory (256 bytes + 8 bytes). But in order to be
+	 * in power of 2, we are allocating 512 bytes of memory.
+	 */
+	sps_config->desc.size = 512;
+	sps_config->desc.base = dma_alloc_coherent(mmc_dev(host->mmc),
+						sps_config->desc.size,
+						&sps_config->desc.phys_base,
+						GFP_KERNEL);
+
+	memset(sps_config->desc.base, 0x00, sps_config->desc.size);
+
+	/* Establish connection between peripheral and memory endpoint */
+	rc = sps_connect(sps_pipe_handle, sps_config);
+	if (rc) {
+		pr_err("%s: sps_connect() failed!!! pipe_handle=0x%x,"
+			" rc=%d", mmc_hostname(host->mmc),
+			(u32)sps_pipe_handle, rc);
+		goto sps_connect_err;
+	}
+
+	sps_event->mode = SPS_TRIGGER_CALLBACK;
+	sps_event->options = SPS_O_EOT;
+	sps_event->callback = msmsdcc_sps_complete_cb;
+	sps_event->xfer_done = NULL;
+	sps_event->user = (void *)host;
+
+	/* Register callback event for EOT (End of transfer) event. */
+	rc = sps_register_event(sps_pipe_handle, sps_event);
+	if (rc) {
+		pr_err("%s: sps_connect() failed!!! pipe_handle=0x%x,"
+			" rc=%d", mmc_hostname(host->mmc),
+			(u32)sps_pipe_handle, rc);
+		goto reg_event_err;
+	}
+	/* Now save the sps pipe handle */
+	ep->pipe_handle = sps_pipe_handle;
+	pr_debug("%s: %s, success !!! %s: pipe_handle=0x%x,"
+		" desc_fifo.phys_base=0x%x\n", mmc_hostname(host->mmc),
+		__func__, is_producer ? "READ" : "WRITE",
+		(u32)sps_pipe_handle, sps_config->desc.phys_base);
+	goto out;
+
+reg_event_err:
+	sps_disconnect(sps_pipe_handle);
+sps_connect_err:
+	dma_free_coherent(mmc_dev(host->mmc),
+			sps_config->desc.size,
+			sps_config->desc.base,
+			sps_config->desc.phys_base);
+get_config_err:
+	sps_free_endpoint(sps_pipe_handle);
+out:
+	return rc;
+}
+
+/**
+ * Disconnect and Deallocate a SDCC peripheral's SPS endpoint
+ *
+ * This function disconnect endpoint and deallocates
+ * endpoint context.
+ *
+ * This function should only be called once typically
+ * during driver remove.
+ *
+ * @host - Pointer to sdcc host structure
+ * @ep   - Pointer to sps endpoint data structure
+ *
+ */
+static void msmsdcc_sps_exit_ep_conn(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep)
+{
+	struct sps_pipe *sps_pipe_handle = ep->pipe_handle;
+	struct sps_connect *sps_config = &ep->config;
+	struct sps_register_event *sps_event = &ep->event;
+
+	sps_event->xfer_done = NULL;
+	sps_event->callback = NULL;
+	sps_register_event(sps_pipe_handle, sps_event);
+	sps_disconnect(sps_pipe_handle);
+	dma_free_coherent(mmc_dev(host->mmc),
+			sps_config->desc.size,
+			sps_config->desc.base,
+			sps_config->desc.phys_base);
+	sps_free_endpoint(sps_pipe_handle);
+}
+
+/**
+ * Reset SDCC peripheral's SPS endpoint
+ *
+ * This function disconnects an endpoint.
+ *
+ * This function should be called for reseting
+ * SPS endpoint when data transfer error is
+ * encountered during data transfer. This
+ * can be considered as soft reset to endpoint.
+ *
+ * This function should only be called if
+ * msmsdcc_sps_init() is already called.
+ *
+ * @host - Pointer to sdcc host structure
+ * @ep   - Pointer to sps endpoint data structure
+ *
+ * @return - 0 if successful else negative value.
+ */
+static int msmsdcc_sps_reset_ep(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep)
+{
+	int rc = 0;
+	struct sps_pipe *sps_pipe_handle = ep->pipe_handle;
+
+	rc = sps_disconnect(sps_pipe_handle);
+	if (rc) {
+		pr_err("%s: %s: sps_disconnect() failed!!! pipe_handle=0x%x,"
+			" rc=%d", mmc_hostname(host->mmc), __func__,
+			(u32)sps_pipe_handle, rc);
+		goto out;
+	}
+ out:
+	return rc;
+}
+
+/**
+ * Restore SDCC peripheral's SPS endpoint
+ *
+ * This function connects an endpoint.
+ *
+ * This function should be called for restoring
+ * SPS endpoint after data transfer error is
+ * encountered during data transfer. This
+ * can be considered as soft reset to endpoint.
+ *
+ * This function should only be called if
+ * msmsdcc_sps_reset_ep() is called before.
+ *
+ * @host - Pointer to sdcc host structure
+ * @ep   - Pointer to sps endpoint data structure
+ *
+ * @return - 0 if successful else negative value.
+ */
+static int msmsdcc_sps_restore_ep(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep)
+{
+	int rc = 0;
+	struct sps_pipe *sps_pipe_handle = ep->pipe_handle;
+	struct sps_connect *sps_config = &ep->config;
+	struct sps_register_event *sps_event = &ep->event;
+
+	/* Establish connection between peripheral and memory endpoint */
+	rc = sps_connect(sps_pipe_handle, sps_config);
+	if (rc) {
+		pr_err("%s: %s: sps_connect() failed!!! pipe_handle=0x%x,"
+			" rc=%d", mmc_hostname(host->mmc), __func__,
+			(u32)sps_pipe_handle, rc);
+		goto out;
+	}
+
+	/* Register callback event for EOT (End of transfer) event. */
+	rc = sps_register_event(sps_pipe_handle, sps_event);
+	if (rc) {
+		pr_err("%s: %s: sps_register_event() failed!!!"
+			" pipe_handle=0x%x, rc=%d",
+			mmc_hostname(host->mmc), __func__,
+			(u32)sps_pipe_handle, rc);
+		goto reg_event_err;
+	}
+	goto out;
+
+reg_event_err:
+	sps_disconnect(sps_pipe_handle);
+out:
+	return rc;
+}
+
+/**
+ * Initialize SPS HW connected with SDCC core
+ *
+ * This function register BAM HW resources with
+ * SPS driver and then initialize 2 SPS endpoints
+ *
+ * This function should only be called once typically
+ * during driver probe.
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ * @return - 0 if successful else negative value.
+ *
+ */
+static int msmsdcc_sps_init(struct msmsdcc_host *host)
+{
+	int rc = 0;
+	struct sps_bam_props bam = {0};
+
+	host->bam_base = ioremap(host->bam_memres->start,
+				resource_size(host->bam_memres));
+	if (!host->bam_base) {
+		pr_err("%s: BAM ioremap() failed!!! phys_addr=0x%x,"
+			" size=0x%x", mmc_hostname(host->mmc),
+			host->bam_memres->start,
+			(host->bam_memres->end -
+			host->bam_memres->start));
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	bam.phys_addr = host->bam_memres->start;
+	bam.virt_addr = host->bam_base;
+	/*
+	 * This event thresold value is only significant for BAM-to-BAM
+	 * transfer. It's ignored for BAM-to-System mode transfer.
+	 */
+	bam.event_threshold = 0x10;	/* Pipe event threshold */
+	/*
+	 * This threshold controls when the BAM publish
+	 * the descriptor size on the sideband interface.
+	 * SPS HW will only be used when
+	 * data transfer size >  MCI_FIFOSIZE (64 bytes).
+	 * PIO mode will be used when
+	 * data transfer size < MCI_FIFOSIZE (64 bytes).
+	 * So set this thresold value to 64 bytes.
+	 */
+	bam.summing_threshold = 64;
+	/* SPS driver wll handle the SDCC BAM IRQ */
+	bam.irq = (u32)host->bam_irqres->start;
+	bam.manage = SPS_BAM_MGR_LOCAL;
+
+	pr_info("%s: bam physical base=0x%x\n", mmc_hostname(host->mmc),
+			(u32)bam.phys_addr);
+	pr_info("%s: bam virtual base=0x%x\n", mmc_hostname(host->mmc),
+			(u32)bam.virt_addr);
+
+	/* Register SDCC Peripheral BAM device to SPS driver */
+	rc = sps_register_bam_device(&bam, &host->sps.bam_handle);
+	if (rc) {
+		pr_err("%s: sps_register_bam_device() failed!!! err=%d",
+			   mmc_hostname(host->mmc), rc);
+		goto reg_bam_err;
+	}
+	pr_info("%s: BAM device registered. bam_handle=0x%x",
+		mmc_hostname(host->mmc), host->sps.bam_handle);
+
+	host->sps.src_pipe_index = SPS_SDCC_PRODUCER_PIPE_INDEX;
+	host->sps.dest_pipe_index = SPS_SDCC_CONSUMER_PIPE_INDEX;
+
+	rc = msmsdcc_sps_init_ep_conn(host, &host->sps.prod,
+					SPS_PROD_PERIPHERAL);
+	if (rc)
+		goto sps_reset_err;
+	rc = msmsdcc_sps_init_ep_conn(host, &host->sps.cons,
+					SPS_CONS_PERIPHERAL);
+	if (rc)
+		goto cons_conn_err;
+
+	pr_info("%s: Qualcomm MSM SDCC-BAM at 0x%016llx irq %d\n",
+		mmc_hostname(host->mmc),
+		(unsigned long long)host->bam_memres->start,
+		(unsigned int)host->bam_irqres->start);
+	goto out;
+
+cons_conn_err:
+	msmsdcc_sps_exit_ep_conn(host, &host->sps.prod);
+sps_reset_err:
+	sps_deregister_bam_device(host->sps.bam_handle);
+reg_bam_err:
+	iounmap(host->bam_base);
+out:
+	return rc;
+}
+
+/**
+ * De-initialize SPS HW connected with SDCC core
+ *
+ * This function deinitialize SPS endpoints and then
+ * deregisters BAM resources from SPS driver.
+ *
+ * This function should only be called once typically
+ * during driver remove.
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ */
+static void msmsdcc_sps_exit(struct msmsdcc_host *host)
+{
+	msmsdcc_sps_exit_ep_conn(host, &host->sps.cons);
+	msmsdcc_sps_exit_ep_conn(host, &host->sps.prod);
+	sps_deregister_bam_device(host->sps.bam_handle);
+	iounmap(host->bam_base);
+}
+#else
+static inline int msmsdcc_sps_init_ep_conn(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep,
+				bool is_producer) { return 0; }
+static inline void msmsdcc_sps_exit_ep_conn(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep) { }
+static inline int msmsdcc_sps_reset_ep(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep)
+{
+	return 0;
+}
+static inline int msmsdcc_sps_restore_ep(struct msmsdcc_host *host,
+				struct msmsdcc_sps_ep_conn_data *ep)
+{
+	return 0;
+}
+static inline int msmsdcc_sps_init(struct msmsdcc_host *host) { return 0; }
+static inline void msmsdcc_sps_exit(struct msmsdcc_host *host) {}
+#endif /* CONFIG_MMC_MSM_SPS_SUPPORT */
+
+
 static int
 msmsdcc_probe(struct platform_device *pdev)
 {
@@ -1159,8 +1949,11 @@ msmsdcc_probe(struct platform_device *pdev)
 	struct mmc_host *mmc;
 	struct resource *cmd_irqres = NULL;
 	struct resource *pio_irqres = NULL;
+	struct resource *bam_irqres = NULL;
 	struct resource *stat_irqres = NULL;
 	struct resource *memres = NULL;
+	struct resource *bam_memres = NULL;
+	struct resource *dml_memres = NULL;
 	struct resource *dmares = NULL;
 	int ret;
 
@@ -1171,7 +1964,7 @@ msmsdcc_probe(struct platform_device *pdev)
 		goto out;
 	}
 
-	if (pdev->id < 1 || pdev->id > 4)
+	if (pdev->id < 1 || pdev->id > 5)
 		return -EINVAL;
 
 	if (pdev->resource == NULL || pdev->num_resources < 2) {
@@ -1180,11 +1973,17 @@ msmsdcc_probe(struct platform_device *pdev)
 	}
 
 	memres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	bam_memres = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+							"bam_mem");
+	dml_memres = platform_get_resource_byname(pdev, IORESOURCE_MEM,
+							"dml_mem");
 	dmares = platform_get_resource(pdev, IORESOURCE_DMA, 0);
 	cmd_irqres = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
 						  "cmd_irq");
 	pio_irqres = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
 						  "pio_irq");
+	bam_irqres = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
+						  "bam_irq");
 	stat_irqres = platform_get_resource_byname(pdev, IORESOURCE_IRQ,
 						   "status_irq");
 
@@ -1194,6 +1993,17 @@ msmsdcc_probe(struct platform_device *pdev)
 	}
 
 	/*
+	 * Both BAM and DML memory resource should be preset.
+	 * BAM IRQ resource should also be present.
+	 */
+	if ((bam_memres && !dml_memres) ||
+		(!bam_memres && dml_memres) ||
+		((bam_memres && dml_memres) && !bam_irqres)) {
+		pr_err("%s: Invalid sdcc BAM/DML resource\n", __func__);
+		return -ENXIO;
+	}
+
+	/*
 	 * Setup our host structure
 	 */
 
@@ -1211,31 +2021,45 @@ msmsdcc_probe(struct platform_device *pdev)
 
 	host->cmdpoll = 1;
 
-	host->base = ioremap(memres->start, PAGE_SIZE);
+	if (bam_memres && dml_memres && bam_irqres)
+		host->is_sps_mode = 1;
+	else if (dmares)
+		host->is_dma_mode = 1;
+
+	host->base = ioremap(memres->start,
+			resource_size(host->memres));
 	if (!host->base) {
 		ret = -ENOMEM;
-		goto out;
+		goto host_free;
 	}
 
 	host->cmd_irqres = cmd_irqres;
 	host->pio_irqres = pio_irqres;
+	host->bam_irqres = bam_irqres;
 	host->memres = memres;
+	host->dml_memres = dml_memres;
+	host->bam_memres = bam_memres;
 	host->dmares = dmares;
 	spin_lock_init(&host->lock);
 
 	tasklet_init(&host->dma_tlet, msmsdcc_dma_complete_tlet,
 			(unsigned long)host);
 
-	/*
-	 * Setup DMA
-	 */
-	msmsdcc_init_dma(host);
+	tasklet_init(&host->sps.tlet, msmsdcc_sps_complete_tlet,
+			(unsigned long)host);
+	if (host->is_dma_mode) {
+		/* Setup DMA */
+		ret = msmsdcc_init_dma(host);
+		if (ret)
+			goto ioremap_free;
+		host->core_reset = msmsdcc_reset_and_restore;
+	}
 
 	/* Get our clocks */
 	host->pclk = clk_get(&pdev->dev, "sdc_pclk");
 	if (IS_ERR(host->pclk)) {
 		ret = PTR_ERR(host->pclk);
-		goto host_free;
+		goto dma_free;
 	}
 
 	host->clk = clk_get(&pdev->dev, "sdc_clk");
@@ -1258,6 +2082,19 @@ msmsdcc_probe(struct platform_device *pdev)
 	host->pclk_rate = clk_get_rate(host->pclk);
 	host->clk_rate = clk_get_rate(host->clk);
 
+	/* Clocks has to be running before accessing SPS/DML HW blocks */
+	if (host->is_sps_mode) {
+		/* Initialize SPS */
+		ret = msmsdcc_sps_init(host);
+		if (ret)
+			goto clk_disable;
+		/* Initialize DML */
+		ret = msmsdcc_dml_init(host);
+		if (ret)
+			goto sps_exit;
+		host->core_reset = msmsdcc_soft_reset_and_restore;
+	}
+
 	/*
 	 * Setup MMC host structure
 	 */
@@ -1304,7 +2141,10 @@ msmsdcc_probe(struct platform_device *pdev)
 		if (ret) {
 			pr_err("%s: Unable to get slot IRQ %d (%d)\n",
 			       mmc_hostname(mmc), host->stat_irq, ret);
-			goto clk_disable;
+			if (host->is_sps_mode)
+				goto dml_exit;
+			else
+				goto clk_disable;
 		}
 	} else if (plat->register_status_notify) {
 		plat->register_status_notify(msmsdcc_status_notify_cb, host);
@@ -1353,12 +2193,15 @@ msmsdcc_probe(struct platform_device *pdev)
 	pr_info("%s: Power save feature enable = %d\n",
 		mmc_hostname(mmc), msmsdcc_pwrsave);
 
-	if (host->dma.channel != -1) {
+	if (host->is_dma_mode && host->dma.channel != -1) {
 		pr_info("%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
 			mmc_hostname(mmc), host->dma.nc, host->dma.nc_busaddr);
 		pr_info("%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
 			mmc_hostname(mmc), host->dma.cmd_busaddr,
 			host->dma.cmdptr_busaddr);
+	} else if (host->is_sps_mode) {
+		pr_info("%s: SPS-BAM data transfer mode available\n",
+			mmc_hostname(mmc));
 	} else
 		pr_info("%s: PIO transfer enabled\n", mmc_hostname(mmc));
 	if (host->timer.function)
@@ -1370,12 +2213,27 @@ msmsdcc_probe(struct platform_device *pdev)
  stat_irq_free:
 	if (host->stat_irq)
 		free_irq(host->stat_irq, host);
+ dml_exit:
+	if (host->is_sps_mode)
+		msmsdcc_dml_exit(host);
+ sps_exit:
+	if (host->is_sps_mode)
+		msmsdcc_sps_exit(host);
  clk_disable:
 	msmsdcc_disable_clocks(host, 0);
  clk_put:
 	clk_put(host->clk);
  pclk_put:
 	clk_put(host->pclk);
+ dma_free:
+	if (host->is_dma_mode) {
+		if (host->dmares)
+			dma_free_coherent(NULL,
+				sizeof(struct msmsdcc_nc_dmadata),
+				host->dma.nc, host->dma.nc_busaddr);
+	}
+ ioremap_free:
+	iounmap(host->base);
  host_free:
 	mmc_free_host(mmc);
  out:
@@ -1399,7 +2257,6 @@ do_resume_work(struct work_struct *work)
 }
 #endif
 
-
 static int
 msmsdcc_suspend(struct platform_device *dev, pm_message_t state)
 {
diff --git a/drivers/mmc/host/msm_sdcc.h b/drivers/mmc/host/msm_sdcc.h
index 42d7bbc..f206195 100644
--- a/drivers/mmc/host/msm_sdcc.h
+++ b/drivers/mmc/host/msm_sdcc.h
@@ -2,6 +2,7 @@
  *  linux/drivers/mmc/host/msmsdcc.h - QCT MSM7K SDC Controller
  *
  *  Copyright (C) 2008 Google, All Rights Reserved.
+ *  Copyright (c) 2009-2011, Code Aurora Forum. All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -18,6 +19,21 @@
 #define MSMSDCC_CRCI_SDC3	12
 #define MSMSDCC_CRCI_SDC4	13
 
+#include <linux/types.h>
+
+#include <linux/ioport.h>
+#include <linux/interrupt.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/sdio.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include <mach/sps.h>
+
+#include <asm/sizes.h>
+#include <mach/dma.h>
+
 #define MMCIPOWER		0x000
 #define MCI_PWR_OFF		0x00
 #define MCI_PWR_UP		0x02
@@ -200,12 +216,39 @@ struct msmsdcc_stats {
 	unsigned int cmdpoll_misses;
 };
 
+struct msmsdcc_sps_ep_conn_data {
+	struct sps_pipe			*pipe_handle;
+	struct sps_connect		config;
+	struct sps_register_event	event;
+};
+
+struct msmsdcc_sps_data {
+	struct msmsdcc_sps_ep_conn_data	prod;
+	struct msmsdcc_sps_ep_conn_data	cons;
+	struct sps_event_notify		notify;
+	enum dma_data_direction		dir;
+	struct scatterlist		*sg;
+	int				num_ents;
+	u32				bam_handle;
+	unsigned int			src_pipe_index;
+	unsigned int			dest_pipe_index;
+	unsigned int			busy;
+	unsigned int			xfer_req_cnt;
+	struct tasklet_struct		tlet;
+
+};
+
 struct msmsdcc_host {
 	struct resource		*cmd_irqres;
 	struct resource		*pio_irqres;
+	struct resource		*bam_irqres;
 	struct resource		*memres;
+	struct resource		*bam_memres;
+	struct resource		*dml_memres;
 	struct resource		*dmares;
 	void __iomem		*base;
+	void __iomem		*dml_base;
+	void __iomem		*bam_base;
 	int			pdev_id;
 	unsigned int		stat_irq;
 
@@ -233,8 +276,12 @@ struct msmsdcc_host {
 
 	struct msmsdcc_dma_data	dma;
 	struct msmsdcc_pio_data	pio;
+	struct msmsdcc_sps_data sps;
+	bool			is_dma_mode;
+	bool			is_sps_mode;
 	int			cmdpoll;
 	struct msmsdcc_stats	stats;
+	void (*core_reset) (struct msmsdcc_host *host);
 
 	struct tasklet_struct	dma_tlet;
 	/* Command parameters */
diff --git a/drivers/mmc/host/msm_sdcc_dml.c b/drivers/mmc/host/msm_sdcc_dml.c
new file mode 100644
index 0000000..9c325cf
--- /dev/null
+++ b/drivers/mmc/host/msm_sdcc_dml.c
@@ -0,0 +1,303 @@
+/*
+ * linux/drivers/mmc/host/msm_sdcc_dml.c - Qualcomm MSM SDCC DML Driver
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
+ * 02110-1301, USA.
+ */
+
+#include <linux/io.h>
+#include <asm/sizes.h>
+#include <mach/msm_iomap.h>
+
+#include "msm_sdcc_dml.h"
+
+/*
+ * DML registers definations
+ */
+
+/* DML config register defination */
+#define DML_CONFIG 0x0000
+#define PRODUCER_CRCI_DIS   0x00
+#define PRODUCER_CRCI_X_SEL 0x01
+#define PRODUCER_CRCI_Y_SEL 0x02
+#define PRODUCER_CRCI_MSK   0x3
+#define CONSUMER_CRCI_DIS   (0x00 << 2)
+#define CONSUMER_CRCI_X_SEL (0x01 << 2)
+#define CONSUMER_CRCI_Y_SEL (0x02 << 2)
+#define CONSUMER_CRCI_MSK   (0x3 << 2)
+#define PRODUCER_TRANS_END_EN (1 << 4)
+#define BYPASS (1 << 16)
+#define DIRECT_MODE (1 << 17)
+#define INFINITE_CONS_TRANS (1 << 18)
+
+/* DML status register defination */
+#define DML_STATUS 0x0004
+#define PRODUCER_IDLE (1 << 0)
+#define CONSUMER_IDLE (1 << 16)
+
+/*
+ * DML SW RESET register defination
+ * NOTE: write to this register resets the DML core.
+ * All internal state information will be lost and all
+ * register values will be reset as well
+ */
+#define DML_SW_RESET 0x0008
+
+/*
+ * DML PRODUCER START register defination
+ * NOTE: A write to this register triggers the DML
+ * Producer state machine. No SW register values will be
+ * altered.
+ */
+#define DML_PRODUCER_START 0x000C
+
+/*
+ * DML CONSUMER START register defination
+ * NOTE: A write to this register triggers the DML
+ * Consumer state machine. No SW register values will be
+ * altered.
+ */
+#define DML_CONSUMER_START 0x0010
+
+/*
+ * DML producer pipe logical size register defination
+ * NOTE: This register holds the size of the producer pipe
+ * (in units of bytes) _to_ which the peripheral can
+ * keep writing data to when its the PRODUCER.
+ */
+#define DML_PRODUCER_PIPE_LOGICAL_SIZE 0x0014
+
+/*
+ * DML producer pipe logical size register defination
+ * NOTE: This register holds the size of the consumer pipe
+ * (in units of bytes) _from_ which the peripheral
+ * can keep _reading_ data from when its the CONSUMER.
+ */
+#define DML_CONSUMER_PIPE_LOGICAL_SIZE 0x00018
+
+/*
+ * DML PIPE ID register
+ * This register holds pipe IDs that services
+ * the producer and consumer side of the peripheral
+ */
+#define DML_PIPE_ID 0x0001C
+#define PRODUCER_PIPE_ID_SHFT 0
+#define PRODUCER_PIPE_ID_MSK 0x1f
+#define CONSUMER_PIPE_ID_SHFT 16
+#define CONSUMER_PIPE_ID_MSK (0x1f << 16)
+
+/*
+ * DML Producer trackers register defination.
+ * This register is for debug purposes only. They reflect
+ * the value of the producer block and transaction counters
+ * when read. The values may be dynamically changing when
+ * a transaction is in progress.
+ */
+#define DML_PRODUCER_TRACKERS 0x00020
+#define PROD_BLOCK_CNT_SHFT 0
+#define PROD_BLOCK_CNT_MSK  0xffff
+#define PROD_TRANS_CNT_SHFT 16
+#define PROD_TRANS_CNT_MSK  (0xffff << 16)
+
+/*
+ * DML Producer BAM block size register defination.
+ * This regsiter holds the block size, in units of bytes,
+ * associated with the Producer BAM. The DML asserts the
+ * block_end side band signal to the BAM whenever the producer
+ * side of the peripheral has generated the said amount of data.
+ * This register value should be an integral multiple of the
+ * Producer CRCI Block Size.
+ */
+#define DML_PRODUCER_BAM_BLOCK_SIZE 0x00024
+
+/*
+ * DML Producer BAM Transaction size defination.
+ * This regsiter holds the transaction size, in units of bytes,
+ * associated with the Producer BAM. The DML asserts the transaction_end
+ * side band signal to the BAM whenever the producer side of the peripheral
+ * has generated the said amount of data.
+ */
+#define DML_PRODUCER_BAM_TRANS_SIZE 0x00028
+
+/*
+ * DML Direct mode base address defination
+ * This register is used whenever the DIRECT_MODE bit
+ * in config register is set.
+ */
+#define DML_DIRECT_MODE_BASE_ADDR 0x002C
+#define PRODUCER_BASE_ADDR_BSHFT 0
+#define PRODUCER_BASE_ADDR_BMSK  0xffff
+#define CONSUMER_BASE_ADDR_BSHFT 16
+#define CONSUMER_BASE_ADDR_BMSK  (0xffff << 16)
+
+/*
+ * DMA Debug and status register defination.
+ * These are the read-only registers useful debugging.
+ */
+#define DML_DEBUG 0x0030
+#define DML_BAM_SIDE_STATUS_1 0x0034
+#define DML_BAM_SIDE_STATUS_2 0x0038
+
+/* other definations */
+#define PRODUCER_PIPE_LOGICAL_SIZE 4096
+#define CONSUMER_PIPE_LOGICAL_SIZE 4096
+
+#ifdef CONFIG_MMC_MSM_SPS_SUPPORT
+/**
+ * Initialize DML HW connected with SDCC core
+ *
+ */
+int msmsdcc_dml_init(struct msmsdcc_host *host)
+{
+	int rc = 0;
+	u32 config = 0;
+	void __iomem *dml_base;
+
+	if (!host->dml_base) {
+		host->dml_base = ioremap(host->dml_memres->start,
+					resource_size(host->dml_memres));
+		if (!host->dml_base) {
+			pr_err("%s: DML ioremap() failed!!! phys_addr=0x%x,"
+				" size=0x%x", mmc_hostname(host->mmc),
+				host->dml_memres->start,
+				(host->dml_memres->end -
+				host->dml_memres->start));
+			rc = -ENOMEM;
+			goto out;
+		}
+		pr_info("%s: Qualcomm MSM SDCC-DML at 0x%016llx\n",
+			mmc_hostname(host->mmc),
+			(unsigned long long)host->dml_memres->start);
+	}
+
+	dml_base = host->dml_base;
+	/* Reset the DML block */
+	writel(1, (dml_base + DML_SW_RESET));
+
+	/* Disable the producer and consumer CRCI */
+	config = (PRODUCER_CRCI_DIS | CONSUMER_CRCI_DIS);
+	/*
+	 * Disable the bypass mode. Bypass mode will only be used
+	 * if data transfer is to happen in PIO mode and don't
+	 * want the BAM interface to connect with SDCC-DML.
+	 */
+	config &= ~BYPASS;
+	/*
+	 * Disable direct mode as we don't DML to MASTER the AHB bus.
+	 * BAM connected with DML should MASTER the AHB bus.
+	 */
+	config &= ~DIRECT_MODE;
+	/*
+	 * Disable infinite mode transfer as we won't be doing any
+	 * infinite size data transfers. All data transfer will be
+	 * of finite data size.
+	 */
+	config &= ~INFINITE_CONS_TRANS;
+	writel(config, (dml_base + DML_CONFIG));
+
+	/*
+	 * Initialize the logical BAM pipe size for producer
+	 * and consumer.
+	 */
+	writel(PRODUCER_PIPE_LOGICAL_SIZE,
+		(dml_base + DML_PRODUCER_PIPE_LOGICAL_SIZE));
+	writel(CONSUMER_PIPE_LOGICAL_SIZE,
+		(dml_base + DML_CONSUMER_PIPE_LOGICAL_SIZE));
+
+	/* Initialize Producer/consumer pipe id */
+	writel(host->sps.src_pipe_index |
+		(host->sps.dest_pipe_index << CONSUMER_PIPE_ID_SHFT),
+		(dml_base + DML_PIPE_ID));
+out:
+	return rc;
+}
+
+/**
+ * Soft reset DML HW
+ *
+ */
+void msmsdcc_dml_reset(struct msmsdcc_host *host)
+{
+	/* Reset the DML block */
+	writel(1, (host->dml_base + DML_SW_RESET));
+}
+
+/**
+ * Checks if DML HW is busy or not?
+ *
+ */
+bool msmsdcc_is_dml_busy(struct msmsdcc_host *host)
+{
+	return !(readl(host->dml_base + DML_STATUS) & PRODUCER_IDLE) ||
+		!(readl(host->dml_base + DML_STATUS) & CONSUMER_IDLE);
+}
+
+/**
+ * Start data transfer.
+ *
+ */
+void msmsdcc_dml_start_xfer(struct msmsdcc_host *host, struct mmc_data *data)
+{
+	u32 config;
+	void __iomem *dml_base = host->dml_base;
+
+	if (data->flags & MMC_DATA_READ) {
+		/* Read operation: configure DML for producer operation */
+		/* Set producer CRCI-x and disable consumer CRCI */
+		config = readl(dml_base + DML_CONFIG);
+		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_X_SEL;
+		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_DIS;
+		writel(config, (dml_base + DML_CONFIG));
+
+		/* Set the Producer BAM block size */
+		writel(data->blksz, (dml_base + DML_PRODUCER_BAM_BLOCK_SIZE));
+
+		/* Set Producer BAM Transaction size */
+		writel(host->curr.xfer_size,
+			(dml_base + DML_PRODUCER_BAM_TRANS_SIZE));
+		/* Set Producer Transaction End bit */
+		writel((readl(dml_base + DML_CONFIG)
+			| PRODUCER_TRANS_END_EN),
+			(dml_base + DML_CONFIG));
+		/* Trigger producer */
+		writel(1, (dml_base + DML_PRODUCER_START));
+	} else {
+		/* Write operation: configure DML for consumer operation */
+		/* Set consumer CRCI-x and disable producer CRCI*/
+		config = readl(dml_base + DML_CONFIG);
+		config = (config & ~CONSUMER_CRCI_MSK) | CONSUMER_CRCI_X_SEL;
+		config = (config & ~PRODUCER_CRCI_MSK) | PRODUCER_CRCI_DIS;
+		writel(config, (dml_base + DML_CONFIG));
+		/* Clear Producer Transaction End bit */
+		writel((readl(dml_base + DML_CONFIG)
+			& ~PRODUCER_TRANS_END_EN),
+			(dml_base + DML_CONFIG));
+		/* Trigger consumer */
+		writel(1, (dml_base + DML_CONSUMER_START));
+	}
+}
+
+/**
+ * Deinitialize DML HW connected with SDCC core
+ *
+ */
+void msmsdcc_dml_exit(struct msmsdcc_host *host)
+{
+	/* Put DML block in reset state before exiting */
+	msmsdcc_dml_reset(host);
+	iounmap(host->dml_base);
+}
+#endif /* CONFIG_MMC_MSM_SPS_SUPPORT */
diff --git a/drivers/mmc/host/msm_sdcc_dml.h b/drivers/mmc/host/msm_sdcc_dml.h
new file mode 100644
index 0000000..b1ce230
--- /dev/null
+++ b/drivers/mmc/host/msm_sdcc_dml.h
@@ -0,0 +1,120 @@
+/*
+ *  linux/drivers/mmc/host/msm_sdcc_dml.h - Qualcomm SDCC DML driver
+ *					    header file
+ *
+ * Copyright (c) 2011, Code Aurora Forum. All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are
+ * met:
+ *   * Redistributions of source code must retain the above copyright
+ *     notice, this list of conditions and the following disclaimer.
+ *   * Redistributions in binary form must reproduce the above
+ *     copyright notice, this list of conditions and the following
+ *     disclaimer in the documentation and/or other materials provided
+ *     with the distribution.
+ *   * Neither the name of Code Aurora Forum, Inc. nor the names of its
+ *     contributors may be used to endorse or promote products derived
+ *     from this software without specific prior written permission.
+
+ * THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED
+ * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT
+ * ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
+ * BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
+ * BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
+ * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
+ * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
+ * IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _MSM_SDCC_DML_H
+#define _MSM_SDCC_DML_H
+
+#include <linux/types.h>
+#include <linux/mmc/host.h>
+
+#include "msm_sdcc.h"
+
+#ifdef CONFIG_MMC_MSM_SPS_SUPPORT
+/**
+ * Initialize DML HW connected with SDCC core
+ *
+ * This function initialize DML HW.
+ *
+ * This function should only be called once
+ * typically during driver probe.
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ * @return - 0 if successful else negative value.
+ *
+ */
+int msmsdcc_dml_init(struct msmsdcc_host *host);
+
+/**
+ * Start data transfer.
+ *
+ * This function configure DML HW registers with
+ * data transfer direction and data transfer size.
+ *
+ * This function should be called after submitting
+ * data transfer request to SPS HW and before kick
+ * starting data transfer in SDCC core.
+ *
+ * @host - Pointer to sdcc host structure
+ * @data - Pointer to mmc_data structure
+ *
+ */
+void msmsdcc_dml_start_xfer(struct msmsdcc_host *host, struct mmc_data *data);
+
+/**
+ * Checks if DML HW is busy or not?
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ * @return - 1 if DML HW is busy with data transfer
+ *           0 if DML HW is IDLE.
+ *
+ */
+bool msmsdcc_is_dml_busy(struct msmsdcc_host *host);
+
+/**
+ * Soft reset DML HW
+ *
+ * This function give soft reset to DML HW.
+ *
+ * This function should be called to reset DML HW
+ * if data transfer error is detected.
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ */
+void msmsdcc_dml_reset(struct msmsdcc_host *host);
+
+/**
+ * Deinitialize DML HW connected with SDCC core
+ *
+ * This function resets DML HW and unmap DML
+ * register region.
+ *
+ * This function should only be called once
+ * typically during driver remove.
+ *
+ * @host - Pointer to sdcc host structure
+ *
+ */
+void msmsdcc_dml_exit(struct msmsdcc_host *host);
+#else
+static inline int msmsdcc_dml_init(struct msmsdcc_host *host) { return 0; }
+static inline int msmsdcc_dml_start_xfer(struct msmsdcc_host *host,
+				struct mmc_data *data) { return 0; }
+static inline bool msmsdcc_is_dml_busy(
+				struct msmsdcc_host *host) { return 0; }
+static inline void msmsdcc_dml_reset(struct msmsdcc_host *host) { }
+static inline void msmsdcc_dml_exit(struct msmsdcc_host *host) { }
+#endif /* CONFIG_MMC_MSM_SPS_SUPPORT */
+
+#endif /* _MSM_SDCC_DML_H */
-- 
1.7.1.1

--
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
