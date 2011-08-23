Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868Ab1HWRjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:39:36 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6747 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1HWRjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:39:31 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6446"; a="112353742"
From: David Brown <davidb@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: Sahitya Tummala <stummala@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Murali Palnati <palnatim@codeaurora.org>
Subject: [PATCH 4/6] mmc: msm_sdcc: Use MCI_INT_MASK0 for PIO interrupts
Date: Tue, 23 Aug 2011 10:39:16 -0700
Message-Id: <1314121158-3319-5-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
References: <1314121158-3319-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sahitya Tummala <stummala@codeaurora.org>

Not all targets have IRQ1 line routed from the SD controller to
the processor. So we cannot rely on IRQ1 for PIO interrupts.
This patch moves all PIO interrupts to IRQ0 and enables the PIO
mode.

Signed-off-by: Murali Palnati <palnatim@codeaurora.org>
Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: David Brown <davidb@codeaurora.org>
---
 drivers/mmc/host/msm_sdcc.c |   20 ++++++++++++++++----
 drivers/mmc/host/msm_sdcc.h |    5 +++++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
index 1f1eff9..c405e93 100644
--- a/drivers/mmc/host/msm_sdcc.c
+++ b/drivers/mmc/host/msm_sdcc.c
@@ -213,7 +213,8 @@ msmsdcc_dma_exec_func(struct msm_dmov_cmd *cmd)
 	msmsdcc_writel(host, host->cmd_timeout, MMCIDATATIMER);
 	msmsdcc_writel(host, (unsigned int)host->curr.xfer_size,
 		       MMCIDATALENGTH);
-	msmsdcc_writel(host, host->cmd_pio_irqmask, MMCIMASK1);
+	msmsdcc_writel(host, (msmsdcc_readl(host, MMCIMASK0) &
+			(~MCI_IRQ_PIO)) | host->cmd_pio_irqmask, MMCIMASK0);
 	msmsdcc_writel(host, host->cmd_datactrl, MMCIDATACTRL);
 
 	if (host->cmd_cmd) {
@@ -543,7 +544,9 @@ msmsdcc_start_data(struct msmsdcc_host *host, struct mmc_data *data,
 
 		msmsdcc_writel(host, host->curr.xfer_size, MMCIDATALENGTH);
 
-		msmsdcc_writel(host, pio_irqmask, MMCIMASK1);
+		msmsdcc_writel(host, (msmsdcc_readl(host, MMCIMASK0) &
+				(~MCI_IRQ_PIO)) | pio_irqmask, MMCIMASK0);
+
 		msmsdcc_writel(host, datactrl, MMCIDATACTRL);
 
 		if (cmd) {
@@ -659,8 +662,13 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 {
 	struct msmsdcc_host	*host = dev_id;
 	uint32_t		status;
+	u32 mci_mask0;
 
 	status = msmsdcc_readl(host, MMCISTATUS);
+	mci_mask0 = msmsdcc_readl(host, MMCIMASK0);
+
+	if (((mci_mask0 & status) & MCI_IRQ_PIO) == 0)
+		return IRQ_NONE;
 
 	do {
 		unsigned long flags;
@@ -719,10 +727,12 @@ msmsdcc_pio_irq(int irq, void *dev_id)
 	} while (1);
 
 	if (status & MCI_RXACTIVE && host->curr.xfer_remain < MCI_FIFOSIZE)
-		msmsdcc_writel(host, MCI_RXDATAAVLBLMASK, MMCIMASK1);
+		msmsdcc_writel(host, (mci_mask0 & (~MCI_IRQ_PIO)) |
+					MCI_RXDATAAVLBLMASK, MMCIMASK0);
 
 	if (!host->curr.xfer_remain)
-		msmsdcc_writel(host, 0, MMCIMASK1);
+		msmsdcc_writel(host, (mci_mask0 & (~MCI_IRQ_PIO)) | 0,
+					MMCIMASK0);
 
 	return IRQ_HANDLED;
 }
@@ -854,6 +864,8 @@ msmsdcc_irq(int irq, void *dev_id)
 	do {
 		status = msmsdcc_readl(host, MMCISTATUS);
 		status &= msmsdcc_readl(host, MMCIMASK0);
+		if ((status & (~MCI_IRQ_PIO)) == 0)
+			break;
 		msmsdcc_writel(host, status, MMCICLEAR);
 
 		if (status & MCI_SDIOINTR)
diff --git a/drivers/mmc/host/msm_sdcc.h b/drivers/mmc/host/msm_sdcc.h
index fa626ed..402028d 100644
--- a/drivers/mmc/host/msm_sdcc.h
+++ b/drivers/mmc/host/msm_sdcc.h
@@ -140,6 +140,11 @@
 	MCI_DATATIMEOUTMASK|MCI_TXUNDERRUNMASK|MCI_RXOVERRUNMASK|	\
 	MCI_CMDRESPENDMASK|MCI_CMDSENTMASK|MCI_DATAENDMASK|MCI_PROGDONEMASK)
 
+#define MCI_IRQ_PIO \
+	(MCI_RXDATAAVLBLMASK | MCI_TXDATAAVLBLMASK | MCI_RXFIFOEMPTYMASK | \
+	 MCI_TXFIFOEMPTYMASK | MCI_RXFIFOFULLMASK | MCI_TXFIFOFULLMASK | \
+	 MCI_RXFIFOHALFFULLMASK | MCI_TXFIFOHALFEMPTYMASK | \
+	 MCI_RXACTIVEMASK | MCI_TXACTIVEMASK)
 /*
  * The size of the FIFO in bytes.
  */
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

