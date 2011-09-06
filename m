Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab1IFIAz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:00:55 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:33691 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753362Ab1IFIAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:00:21 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 5/5] spi-topcliff-pch: Fix overrun issue
Date: Tue,  6 Sep 2011 16:58:34 +0900
Message-Id: <1315295914-6862-5-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315295914-6862-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1315295914-6862-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found that adding load, Rx data sometimes drops.(with DMA transfer mode)
The cause is that before starting Rx-DMA processing, Tx-DMA processing starts.
This causes FIFO overrun occurs.

This patch fixes the issue by modifying FIFO tx-threshold and DMA descriptor
size like below.

                      Current                   this patch
Rx-descriptor   4Byte+12Byte*341    -->    12Byte*340-4Byte-12Byte
Rx-threshold                   (Not modified)
Tx-descriptor   4Byte+12Byte*341    -->    16Byte-12Byte*340
Rx-threshold    12Byte              -->    2Byte

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/spi/spi-topcliff-pch.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 5be1142..c02fa62 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -50,6 +50,8 @@
 #define PCH_RX_THOLD		7
 #define PCH_RX_THOLD_MAX	15
 
+#define PCH_TX_THOLD		2
+
 #define PCH_MAX_BAUDRATE	5000000
 #define PCH_MAX_FIFO_DEPTH	16
 
@@ -1043,8 +1045,7 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	/* set receive fifo threshold and transmit fifo threshold */
 	pch_spi_setclr_reg(data->master, PCH_SPCR,
 			   ((size - 1) << SPCR_RFIC_FIELD) |
-			   ((PCH_MAX_FIFO_DEPTH - PCH_DMA_TRANS_SIZE) <<
-			    SPCR_TFIC_FIELD),
+			   (PCH_TX_THOLD << SPCR_TFIC_FIELD),
 			   MASK_RFIC_SPCR_BITS | MASK_TFIC_SPCR_BITS);
 
 	spin_unlock_irqrestore(&data->lock, flags);
@@ -1055,13 +1056,20 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	/* offset, length setting */
 	sg = dma->sg_rx_p;
 	for (i = 0; i < num; i++, sg++) {
-		if (i == 0) {
-			sg->offset = 0;
+		if (i == (num - 2)) {
+			sg->offset = size * i;
+			sg->offset = sg->offset * (*bpw / 8);
 			sg_set_page(sg, virt_to_page(dma->rx_buf_virt), rem,
 				    sg->offset);
 			sg_dma_len(sg) = rem;
+		} else if (i == (num - 1)) {
+			sg->offset = size * (i - 1) + rem;
+			sg->offset = sg->offset * (*bpw / 8);
+			sg_set_page(sg, virt_to_page(dma->rx_buf_virt), size,
+				    sg->offset);
+			sg_dma_len(sg) = size;
 		} else {
-			sg->offset = rem + size * (i - 1);
+			sg->offset = size * i;
 			sg->offset = sg->offset * (*bpw / 8);
 			sg_set_page(sg, virt_to_page(dma->rx_buf_virt), size,
 				    sg->offset);
@@ -1085,6 +1093,16 @@ static void pch_spi_handle_dma(struct pch_spi_data *data, int *bpw)
 	dma->desc_rx = desc_rx;
 
 	/* TX */
+	if (data->bpw_len > PCH_DMA_TRANS_SIZE) {
+		num = data->bpw_len / PCH_DMA_TRANS_SIZE;
+		size = PCH_DMA_TRANS_SIZE;
+		rem = 16;
+	} else {
+		num = 1;
+		size = data->bpw_len;
+		rem = data->bpw_len;
+	}
+
 	dma->sg_tx_p = kzalloc(sizeof(struct scatterlist)*num, GFP_ATOMIC);
 	sg_init_table(dma->sg_tx_p, num); /* Initialize SG table */
 	/* offset, length setting */
-- 
1.7.4.4

