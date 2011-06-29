Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1F2I3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 04:29:18 -0400
Received: from multi.imgtec.com ([194.200.65.239]:61721 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753750Ab1F2I3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:29:15 -0400
Message-ID: <4E0AE23B.2010107@imgtec.com>
Date: Wed, 29 Jun 2011 09:28:43 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] mmc: dw_mmc: fix stop when fallen back to PIO
References: <4E0AE1FC.3070201@imgtec.com>
In-Reply-To: <4E0AE1FC.3070201@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2011 08:28:44.0072 (UTC) FILETIME=[8EE9C280:01CC3636]
X-SEF-Processed: 7_3_0_01158__2011_06_29_09_28_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are several situations when dw_mci_submit_data_dma() decides to
fall back to PIO mode instead of using DMA, due to a short (to avoid
overhead) or "complex" (e.g. with unaligned buffers) transaction, even
though host->use_dma is set. However dw_mci_stop_dma() decides whether
to stop DMA or set the EVENT_XFER_COMPLETE event based on host->use_dma.
When falling back to PIO mode this results in data timeout errors
getting missed and the driver locking up.

Therefore add host->using_dma to indicate whether the current
transaction is using dma or not, and adjust dw_mci_stop_dma() to use
that instead.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/mmc/host/dw_mmc.c  |    6 +++++-
 include/linux/mmc/dw_mmc.h |    2 ++
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 10b6979..fcff3c0 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -287,7 +287,7 @@ static void send_stop_cmd(struct dw_mci *host, struct mmc_data *data)
 /* DMA interface functions */
 static void dw_mci_stop_dma(struct dw_mci *host)
 {
-	if (host->use_dma) {
+	if (host->using_dma) {
 		host->dma_ops->stop(host);
 		host->dma_ops->cleanup(host);
 	} else {
@@ -435,6 +435,8 @@ static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
 	unsigned int i, direction, sg_len;
 	u32 temp;
 
+	host->using_dma = 0;
+
 	/* If we don't have a channel, we can't do DMA */
 	if (!host->use_dma)
 		return -ENODEV;
@@ -454,6 +456,8 @@ static int dw_mci_submit_data_dma(struct dw_mci *host, struct mmc_data *data)
 			return -EINVAL;
 	}
 
+	host->using_dma = 1;
+
 	if (data->flags & MMC_DATA_READ)
 		direction = DMA_FROM_DEVICE;
 	else
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index f3f68ee..6b46819 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -48,6 +48,7 @@ struct mmc_data;
  * @data: The data currently being transferred, or NULL if no data
  *	transfer is in progress.
  * @use_dma: Whether DMA channel is initialized or not.
+ * @using_dma: Whether DMA is in use for the current transfer.
  * @sg_dma: Bus address of DMA buffer.
  * @sg_cpu: Virtual address of DMA buffer.
  * @dma_ops: Pointer to platform-specific DMA callbacks.
@@ -121,6 +122,7 @@ struct dw_mci {
 
 	/* DMA interface members*/
 	int			use_dma;
+	int			using_dma;
 
 	dma_addr_t		sg_dma;
 	void			*sg_cpu;
-- 
1.7.2.3


