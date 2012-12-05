Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753974Ab2LELMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 06:12:50 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:60591 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2LELLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 06:11:31 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7e-50bf2be10403
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: vinod.koul@intel.com
Cc: linux-kernel@vger.kernel.org, djbw@fb.com, dwmw2@infradead.org,
        hskinnemoen@gmail.com, iws@ovro.caltech.edu, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH resend 3/7] mtd: fsmc_nand: add missing DMA unmap to dma_xfer()
Date: Wed, 05 Dec 2012 12:10:41 +0100
Message-id: <1354705845-29439-4-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
References: <1354705845-29439-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t9jAd2H2vsDDG6vsLa4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ/VfDCn4KViy/fJexgfEmXxcjJ4eEgInE8mmnWSFsMYkL99az
	dTFycQgJLGKU+H77CDuEs5pJYv2NM0wgVWwCVhIT21cxgtgiAhIS25/1gRUxC7xjlGha9xes
	SFjAX+LRzUYWEJtFQFXiz8djYA28Ah4SrxffZYNYJy/x9H4fmM0p4CnxYOpMoHoOoG0eErMO
	hExg5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTI9jjz6R3MK5qsDjEKMDBqMTDK2G8
	L0CINbGsuDL3EKMEB7OSCO88mf0BQrwpiZVVqUX58UWlOanFhxilOViUxHmbPVIChATSE0tS
	s1NTC1KLYLJMHJxSDYzKUglzp2suTb9/donzq5n1S3Ztvl9gycj3MmzNRJVXXyIux4ufjVUu
	iXqmevPGp8OCk1wr96VoiC6/VOlX5jNrktRCvQPXaj5Lt5c8VSs66rt+iQFn5M2klObc44X/
	z6k7zGxvag7/pSvZmP9fQuji6cTGHSY30ptPdDZXe99Wd/xWGdPgr6zEUpyRaKjFXFScCAB8
	SXpq9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dma_xfer() do DMA unmapping itself and fix handling
of failure cases.

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Vipin Kumar <vipin.kumar@st.com>
Acked-by: Dan Williams <djbw@fb.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mtd/nand/fsmc_nand.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 1d74464..a665768 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -573,23 +573,22 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
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
@@ -599,7 +598,7 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	ret = dma_submit_error(cookie);
 	if (ret) {
 		dev_err(host->dev, "dma_submit_error %d\n", cookie);
-		return ret;
+		goto unmap_dma;
 	}
 
 	dma_async_issue_pending(chan);
@@ -610,10 +609,17 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
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

