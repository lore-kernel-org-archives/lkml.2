Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497Ab1FXNNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:13:08 -0400
Received: from multi.imgtec.com ([194.200.65.239]:1961 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab1FXNNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:13:06 -0400
Message-ID: <4E0489AE.2080405@imgtec.com>
Date: Fri, 24 Jun 2011 13:57:18 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will Newton <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Fleming <matt@console-pimps.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, james@albanarts.com
Subject: [PATCH 5/6] mmc: dw_mmc: don't hard code fifo depth, fix usage
References: <4E0488A9.6050109@imgtec.com>
In-Reply-To: <4E0488A9.6050109@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2011 12:57:19.0257 (UTC) FILETIME=[403F1890:01CC326E]
X-SEF-Processed: 7_3_0_01158__2011_06_24_13_57_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FIFO_DEPTH hardware configuration parameter can be found from the
power-on value of RX_WMark in the FIFOTH register. This is used to
initialise the watermarks, but when calculating the number of free fifo
spaces a preprocessor definition is used which is hard coded to 32.

Fix reading the value out of FIFOTH (the default value in the RX_WMark
field is FIFO_DEPTH-1 not FIFO_DEPTH). Allow the fifo depth to be
overriden by platform data (since a bootloader may have changed FIFOTH
making auto-detection unreliable). Store the fifo_depth for later use.
Also fix the calculation to find the number of free bytes in the fifo to
include the fifo depth in the left shift by the data shift, since the
fifo depth is measured in fifo items not bytes.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c  |   23 ++++++++++++++++++-----
 drivers/mmc/host/dw_mmc.h  |    1 -
 include/linux/mmc/dw_mmc.h |    8 ++++++++
 3 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 3f610d5..3832312 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1116,8 +1116,8 @@ static void dw_mci_write_data_pio(struct dw_mci *host)
 	unsigned int nbytes = 0, len;
 
 	do {
-		len = SDMMC_FIFO_SZ -
-			(SDMMC_GET_FCNT(mci_readl(host, STATUS)) << shift);
+		len = (host->fifo_depth -
+			SDMMC_GET_FCNT(mci_readl(host, STATUS))) << shift;
 		if (offset + len <= sg->length) {
 			host->push_data(host, (void *)(buf + offset), len);
 
@@ -1659,8 +1659,19 @@ static int dw_mci_probe(struct platform_device *pdev)
 	 * FIFO threshold settings  RxMark  = fifo_size / 2 - 1,
 	 *                          Tx Mark = fifo_size / 2 DMA Size = 8
 	 */
-	fifo_size = mci_readl(host, FIFOTH);
-	fifo_size = (fifo_size >> 16) & 0x7ff;
+	if (!host->pdata->fifo_depth) {
+		/*
+		 * Power-on value of RX_WMark is FIFO_DEPTH-1, but this may
+		 * have been overwritten by the bootloader, just like we're
+		 * about to do, so if you know the value for your hardware, you
+		 * should put it in the platform data.
+		 */
+		fifo_size = mci_readl(host, FIFOTH);
+		fifo_size = 1 + ((fifo_size >> 16) & 0x7ff);
+	} else {
+		fifo_size = host->pdata->fifo_depth;
+	}
+	host->fifo_depth = fifo_size;
 	host->fifoth_val = ((0x2 << 28) | ((fifo_size/2 - 1) << 16) |
 			((fifo_size/2) << 0));
 	mci_writel(host, FIFOTH, host->fifoth_val);
@@ -1707,7 +1718,9 @@ static int dw_mci_probe(struct platform_device *pdev)
 	mci_writel(host, CTRL, SDMMC_CTRL_INT_ENABLE); /* Enable mci interrupt */
 
 	dev_info(&pdev->dev, "DW MMC controller at irq %d, "
-		 "%d bit host data width\n", irq, width);
+		 "%d bit host data width, "
+		 "%u deep fifo\n",
+		 irq, width, fifo_size);
 	if (host->quirks & DW_MCI_QUIRK_IDMAC_DTO)
 		dev_info(&pdev->dev, "Internal DMAC interrupt fix enabled.\n");
 
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index bb9e5de..027d377 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -118,7 +118,6 @@
 #define SDMMC_CMD_INDX(n)		((n) & 0x1F)
 /* Status register defines */
 #define SDMMC_GET_FCNT(x)		(((x)>>17) & 0x1FF)
-#define SDMMC_FIFO_SZ			32
 /* Internal DMAC interrupt defines */
 #define SDMMC_IDMAC_INT_AI		BIT(9)
 #define SDMMC_IDMAC_INT_NI		BIT(8)
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index dea4847..01db1a0 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -74,6 +74,7 @@ struct mmc_data;
  * @pdev: Platform device associated with the MMC controller.
  * @pdata: Platform data associated with the MMC controller.
  * @slot: Slots sharing this MMC controller.
+ * @fifo_depth: depth of FIFO.
  * @data_shift: log2 of FIFO item size.
  * @push_data: Pointer to FIFO push function.
  * @pull_data: Pointer to FIFO pull function.
@@ -146,6 +147,7 @@ struct dw_mci {
 	struct dw_mci_slot	*slot[MAX_MCI_SLOTS];
 
 	/* FIFO push and pull */
+	int			fifo_depth;
 	int			data_shift;
 	void (*push_data)(struct dw_mci *host, void *buf, int cnt);
 	void (*pull_data)(struct dw_mci *host, void *buf, int cnt);
@@ -196,6 +198,12 @@ struct dw_mci_board {
 	unsigned int bus_hz; /* Bus speed */
 
 	unsigned int caps;	/* Capabilities */
+	/*
+	 * Override fifo depth. If 0, autodetect it from the FIFOTH register,
+	 * but note that this may not be reliable after a bootloader has used
+	 * it.
+	 */
+	unsigned int fifo_depth;
 
 	/* delay in mS before detecting cards after interrupt */
 	u32 detect_delay_ms;
-- 
1.7.2.3


