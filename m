Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566Ab0FAMWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:22:00 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:36185 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756536Ab0FAMV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:21:56 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Jonas Aaberg <jonas.aberg@stericsson.com>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 10/18] DMAENGINE: ste_dma40: interrupts only on dst
Date: Tue, 1 Jun 2010 14:21:43 +0200
Message-ID: <1275394903-26539-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.3.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonas Aaberg <jonas.aberg@stericsson.com>

We don't want interrupts when the source is done, only when
the destination is done and everything is complete at the
recieveing end of a transfer.

Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/dma/ste_dma40.c    |    2 +-
 drivers/dma/ste_dma40_ll.c |   11 ++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 0e7ed4f..21f898a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1765,7 +1765,7 @@ static struct dma_async_tx_descriptor *d40_prep_memcpy(struct dma_chan *chan,
 				 0,
 				 d40c->log_def.lcsp1,
 				 d40c->dma_cfg.src_info.data_width,
-				 true, true);
+				 false, true);
 
 		d40_log_fill_lli(d40d->lli_log.dst,
 				 dst,
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index e0194e4..772636b 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -315,11 +315,8 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 	int total_size = 0;
 	struct scatterlist *current_sg = sg;
 	int i;
-	u32 next_lli_off_dst;
-	u32 next_lli_off_src;
-
-	next_lli_off_src = 0;
-	next_lli_off_dst = 0;
+	u32 next_lli_off_dst = 0;
+	u32 next_lli_off_src = 0;
 
 	for_each_sg(sg, current_sg, sg_len, i) {
 		total_size += sg_dma_len(current_sg);
@@ -351,7 +348,7 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 					 sg_dma_len(current_sg),
 					 next_lli_off_src,
 					 lcsp->lcsp1, src_data_width,
-					 term_int && !next_lli_off_src,
+					 false,
 					 true);
 			d40_log_fill_lli(&lli->dst[i],
 					 dev_addr,
@@ -375,7 +372,7 @@ int d40_log_sg_to_dev(struct d40_lcla_elem *lcla,
 					 sg_dma_len(current_sg),
 					 next_lli_off_src,
 					 lcsp->lcsp1, src_data_width,
-					 term_int && !next_lli_off_src,
+					 false,
 					 false);
 		}
 	}
-- 
1.6.3.3

