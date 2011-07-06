Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1GFJjf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:39:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:1029 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1GFJje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:39:34 -0400
Message-ID: <4E142D53.8010602@imgtec.com>
Date: Wed, 06 Jul 2011 10:39:31 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Chris Ball <cjb@laptop.org>, Will <will.newton@imgtec.com>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/4] mmc: dw_mmc: handle "no CRC status" error
References: <4E142C10.3050508@imgtec.com>
In-Reply-To: <4E142C10.3050508@imgtec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jul 2011 09:39:31.0956 (UTC) FILETIME=[9BBDAB40:01CC3BC0]
X-SEF-Processed: 7_3_0_01158__2011_07_06_10_39_32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a data write isn't acknowledged by the card (so no CRC status token
is detected after the data), the error -EIO is returned instead of the
-ETIMEDOUT expected by mmc_test 15 - "Correct xfer_size at write (start
failure)" and 17 "Correct xfer_size at write (midway failure)". In PIO
mode the reported number of bytes transferred is also exaggerated since
the last block actually failed.

Handle the "Write no CRC" error specially, setting the error to
-ETIMEDOUT and setting the bytes_xferred to 0.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Acked-by: Will Newton <will.newton@imgtec.com>
Tested-by: Jaehoon Chung <jh80.chung@samsung.com>
---
 drivers/mmc/host/dw_mmc.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index bf2157a..0dac397 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -496,15 +496,16 @@ static void dw_mci_submit_data(struct dw_mci *host, struct mmc_data *data)
 	host->sg = NULL;
 	host->data = data;
 
+	if (data->flags & MMC_DATA_READ)
+		host->dir_status = DW_MCI_RECV_STATUS;
+	else
+		host->dir_status = DW_MCI_SEND_STATUS;
+
 	if (dw_mci_submit_data_dma(host, data)) {
 		host->sg = data->sg;
 		host->pio_offset = 0;
 		host->part_buf_start = 0;
 		host->part_buf_count = 0;
-		if (data->flags & MMC_DATA_READ)
-			host->dir_status = DW_MCI_RECV_STATUS;
-		else
-			host->dir_status = DW_MCI_SEND_STATUS;
 
 		mci_writel(host, RINTSTS, SDMMC_INT_TXDR | SDMMC_INT_RXDR);
 		temp = mci_readl(host, INTMASK);
@@ -911,6 +912,16 @@ static void dw_mci_tasklet_func(unsigned long priv)
 					data->error = -ETIMEDOUT;
 				} else if (status & SDMMC_INT_DCRC) {
 					data->error = -EILSEQ;
+				} else if (status & SDMMC_INT_EBE &&
+					   host->dir_status ==
+							DW_MCI_SEND_STATUS) {
+					/*
+					 * No data CRC status was returned.
+					 * The number of bytes transferred will
+					 * be exaggerated in PIO mode.
+					 */
+					data->bytes_xfered = 0;
+					data->error = -ETIMEDOUT;
 				} else {
 					dev_err(&host->pdev->dev,
 						"data FIFO error "
-- 
1.7.2.3

