Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2KEKBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:01:16 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:26058 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab2KEKBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:01:13 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-8b-50978e5f2f3e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 03/20] mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
Date: Mon, 05 Nov 2012 11:00:14 +0100
Message-id: <1352109631-3385-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jAd34vukBBn/OGlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M5x97WQpOCVZ8+3afvYFxPV8XIyeHhICJxKWLc1ggbDGJC/fW
	s3UxcnEICSxilGg6soEZwlnNJHHn2VZmkCo2ASuJie2rGEFsEQEFic29z1hBipgFnjFKzLjd
	DVYkLOAl8fLdIaAidg4WAVWJb2DlvALuEksnT2CFWCYv8fR+HxuIzSngIdHYMAUsLgRUc7nz
	OPMERt4FjAyrGEVTC5ILipPScw31ihNzi0vz0vWS83M3MYI9/kxqB+PKBotDjAIcjEo8vDPF
	pgcIsSaWFVfmHmKU4GBWEuHlYAAK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnN
	Tk0tSC2CyTJxcEo1MBavj/NdJi7xf/GvvzbWRja7RaaIrZBepPq5MiSCe/X2TN9U+1mr7bm3
	G0XpF/8JDeRPerYr1jbG0oNfI1G605hD4nabJut8gcV3n3iu5145Tfyn9Y28gEOdLLcU51Wd
	n9Ba0GRo9vveWs/u/vPaKvKh2zZf+nE8pzfxplrsjOfym10jfz2QUGIpzkg01GIuKk4EAANZ
	JKj0AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dma_xfer() do DMA unmapping itself and fix handling
of failure cases.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vipin Kumar <vipin.kumar@st.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mtd/nand/fsmc_nand.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 38d2624..679ede8 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -569,23 +569,22 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
 
+	flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
+
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;
 		dma_dst = host->data_pa;
-		flags |= DMA_COMPL_SRC_UNMAP_SINGLE | DMA_COMPL_SKIP_DEST_UNMAP;
 	} else {
 		dma_src = host->data_pa;
 		dma_dst = dma_addr;
-		flags |= DMA_COMPL_DEST_UNMAP_SINGLE | DMA_COMPL_SKIP_SRC_UNMAP;
 	}
 
 	tx = dma_dev->device_prep_dma_memcpy(chan, dma_dst, dma_src,
 			len, flags);
-
 	if (!tx) {
 		dev_err(host->dev, "device_prep_dma_memcpy error\n");
-		dma_unmap_single(dma_dev->dev, dma_addr, len, direction);
-		return -EIO;
+		ret = -EIO;
+		goto unmap_dma;
 	}
 
 	tx->callback = dma_complete;
@@ -595,7 +594,7 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	ret = dma_submit_error(cookie);
 	if (ret) {
 		dev_err(host->dev, "dma_submit_error %d\n", cookie);
-		return ret;
+		goto unmap_dma;
 	}
 
 	dma_async_issue_pending(chan);
@@ -606,10 +605,17 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	if (ret <= 0) {
 		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
 		dev_err(host->dev, "wait_for_completion_timeout\n");
-		return ret ? ret : -ETIMEDOUT;
+		if (!ret)
+			ret = -ETIMEDOUT;
+		goto unmap_dma;
 	}
 
-	return 0;
+	ret = 0;
+
+unmap_dma:
+	dma_unmap_single(dma_dev->dev, dma_addr, len, direction);
+
+	return ret;
 }
 
 /*
-- 
1.8.0

