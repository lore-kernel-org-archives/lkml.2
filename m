Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756245Ab2DHX01 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:26:27 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63701 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab2DHX00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:26:26 -0400
From: Olof Johansson <olof@lixom.net>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, Boojin Kim <boojin.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH v2] dma: pl330: fix a couple of compilation warnings
Date: Sun,  8 Apr 2012 16:26:19 -0700
Message-Id: <1333927579-16999-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.9.2.359.gebfc2
In-Reply-To: <1333919920-25481-1-git-send-email-olof@lixom.net>
References: <1333919920-25481-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move a couple of tests and do a minor refactor to avoid:

drivers/dma/pl330.c: In function 'pl330_probe':
drivers/dma/pl330.c:2929:215: warning: comparison of distinct pointer types lacks a cast [enabled by default]
drivers/dma/pl330.c: In function 'pl330_tasklet':
drivers/dma/pl330.c:2250:8: warning: 'pch' may be used uninitialized in this function [-Wuninitialized]
drivers/dma/pl330.c:2228:25: note: 'pch' was declared here
drivers/dma/pl330.c:2277:130: warning: 'pch' may be used uninitialized in this function [-Wuninitialized]
drivers/dma/pl330.c:2260:25: note: 'pch' was declared here

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/dma/pl330.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 282caf11..2ee6e23 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2225,12 +2225,9 @@ static inline void free_desc_list(struct list_head *list)
 {
 	struct dma_pl330_dmac *pdmac;
 	struct dma_pl330_desc *desc;
-	struct dma_pl330_chan *pch;
+	struct dma_pl330_chan *pch = NULL;
 	unsigned long flags;
 
-	if (list_empty(list))
-		return;
-
 	/* Finish off the work list */
 	list_for_each_entry(desc, list, node) {
 		dma_async_tx_callback callback;
@@ -2247,6 +2244,10 @@ static inline void free_desc_list(struct list_head *list)
 		desc->pchan = NULL;
 	}
 
+	/* pch will be unset if list was empty */
+	if (!pch)
+		return;
+
 	pdmac = pch->dmac;
 
 	spin_lock_irqsave(&pdmac->pool_lock, flags);
@@ -2257,12 +2258,9 @@ static inline void free_desc_list(struct list_head *list)
 static inline void handle_cyclic_desc_list(struct list_head *list)
 {
 	struct dma_pl330_desc *desc;
-	struct dma_pl330_chan *pch;
+	struct dma_pl330_chan *pch = NULL;
 	unsigned long flags;
 
-	if (list_empty(list))
-		return;
-
 	list_for_each_entry(desc, list, node) {
 		dma_async_tx_callback callback;
 
@@ -2274,6 +2272,10 @@ static inline void handle_cyclic_desc_list(struct list_head *list)
 			callback(desc->txd.callback_param);
 	}
 
+	/* pch will be unset if list was empty */
+	if (!pch)
+		return;
+
 	spin_lock_irqsave(&pch->lock, flags);
 	list_splice_tail_init(list, &pch->work_list);
 	spin_unlock_irqrestore(&pch->lock, flags);
@@ -2926,8 +2928,11 @@ pl330_probe(struct amba_device *adev, const struct amba_id *id)
 	INIT_LIST_HEAD(&pd->channels);
 
 	/* Initialize channel parameters */
-	num_chan = max(pdat ? pdat->nr_valid_peri : (u8)pi->pcfg.num_peri,
-			(u8)pi->pcfg.num_chan);
+	if (pdat)
+		num_chan = max_t(int, pdat->nr_valid_peri, pi->pcfg.num_chan);
+	else
+		num_chan = max_t(int, pi->pcfg.num_peri, pi->pcfg.num_chan);
+
 	pdmac->peripherals = kzalloc(num_chan * sizeof(*pch), GFP_KERNEL);
 
 	for (i = 0; i < num_chan; i++) {
-- 
1.7.9.2.359.gebfc2

