Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab1G0NZC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:25:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39150 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450Ab1G0NY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:24:58 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 21:24:57 +0800
Message-ID: <CAJd=RBCH8TVsdxctSGtdAYAmjgW8GsY6Jnx4_09DRzc=rAEObA@mail.gmail.com>
Subject: [RFC patch] DMA engine/Langwell: clean up race of descriptor operations
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three contexts that descriptors are migrated between lists under no
lock protection, which races with same operations in other contexts.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..e39be42 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -301,10 +301,11 @@ static void midc_descriptor_complete(struct
intel_mid_dma_chan *midc,
 		else
 			desc->current_lli = 0;
 	}
-	spin_unlock_bh(&midc->lock);
 	if (callback_txd) {
+		spin_unlock_bh(&midc->lock);
 		pr_debug("MDMA: TXD callback set ... calling\n");
 		callback_txd(param_txd);
+		spin_lock_bh(&midc->lock);
 	}
 	if (midc->raw_tfr) {
 		desc->status = DMA_SUCCESS;
@@ -316,8 +317,6 @@ static void midc_descriptor_complete(struct
intel_mid_dma_chan *midc,
 		list_move(&desc->desc_node, &midc->free_list);
 		midc->busy = false;
 	}
-	spin_lock_bh(&midc->lock);
-
 }
 /**
  * midc_scan_descriptors -		check the descriptors in channel
@@ -491,7 +490,9 @@ static enum dma_status
intel_mid_dma_tx_status(struct dma_chan *chan,

 	ret = dma_async_is_complete(cookie, last_complete, last_used);
 	if (ret != DMA_SUCCESS) {
+		spin_lock_bh(&midc->lock);
 		midc_scan_descriptors(to_middma_device(chan->device), midc);
+		spin_unlock_bh(&midc->lock);

 		last_complete = midc->completed;
 		last_used = chan->cookie;
@@ -561,7 +562,6 @@ static int intel_mid_dma_device_control(struct
dma_chan *chan,
 	disable_dma_interrupt(midc);
 	midc->descs_allocated = 0;

-	spin_unlock_bh(&midc->lock);
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
 		if (desc->lli != NULL) {
 			pci_pool_free(desc->lli_pool, desc->lli,
@@ -570,6 +570,7 @@ static int intel_mid_dma_device_control(struct
dma_chan *chan,
 		}
 		list_move(&desc->desc_node, &midc->free_list);
 	}
+	spin_unlock_bh(&midc->lock);
 	return 0;
 }
