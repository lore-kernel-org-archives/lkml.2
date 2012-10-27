Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab2J0PuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 11:50:08 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43958 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab2J0PuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 11:50:04 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: [PATCH] dma: amba-pl08x: use vchan_dma_desc_free_list
Date: Sun, 28 Oct 2012 00:49:31 +0900
Message-Id: <1351352973-3719-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
References: <1351352973-3719-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vchan_dma_desc_free_list() iterates through each virt_dma_desc in the
specified list_head and calls vchan->desc_free().

We can use it instead of repeated execution of pl08x_desc_free() for each
virt_dma_desc in the list_head.  Because vchan->desc_free callback is set
as pl08x_desc_free() for amba-pl08x driver.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
---
 drivers/dma/amba-pl08x.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index d1cc579..6eb6a5c 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1096,15 +1096,9 @@ static void pl08x_free_txd_list(struct pl08x_driver_data *pl08x,
 				struct pl08x_dma_chan *plchan)
 {
 	LIST_HEAD(head);
-	struct pl08x_txd *txd;
 
 	vchan_get_all_descriptors(&plchan->vc, &head);
-
-	while (!list_empty(&head)) {
-		txd = list_first_entry(&head, struct pl08x_txd, vd.node);
-		list_del(&txd->vd.node);
-		pl08x_desc_free(&txd->vd);
-	}
+	vchan_dma_desc_free_list(&plchan->vc, &head);
 }
 
 /*
-- 
1.7.11.7

