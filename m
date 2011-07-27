Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1G0NYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:24:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53873 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab1G0NYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:24:46 -0400
MIME-Version: 1.0
Date: Wed, 27 Jul 2011 21:24:45 +0800
Message-ID: <CAJd=RBBU7SvVLmVqR_LmJMWG=rgya80DbdPNEc-nR=_d4YQrDQ@mail.gmail.com>
Subject: [RFC patch] DMA engine/Langwell: release LLI pool
From: Hillf Danton <dhillf@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When releasing resources allocated before for DMA channel, checking LLI pool is
added and it is reclaimed if still available.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---
 drivers/dma/intel_mid_dma.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/intel_mid_dma.c b/drivers/dma/intel_mid_dma.c
index f653517..4c758fc 100644
--- a/drivers/dma/intel_mid_dma.c
+++ b/drivers/dma/intel_mid_dma.c
@@ -833,6 +833,10 @@ static void
intel_mid_dma_free_chan_resources(struct dma_chan *chan)
 	midc->descs_allocated = 0;
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
 		list_del(&desc->desc_node);
+		if (desc->lli != NULL) {
+			pci_pool_free(desc->lli_pool, desc->lli, desc->lli_phys);
+			pci_pool_destroy(desc->lli_pool);
+		}
 		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
 	}
 	list_for_each_entry_safe(desc, _desc, &midc->free_list, desc_node) {
@@ -841,6 +845,10 @@ static void
intel_mid_dma_free_chan_resources(struct dma_chan *chan)
 	}
 	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
 		list_del(&desc->desc_node);
+		if (desc->lli != NULL) {
+			pci_pool_free(desc->lli_pool, desc->lli, desc->lli_phys);
+			pci_pool_destroy(desc->lli_pool);
+		}
 		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
 	}
 	spin_unlock_bh(&midc->lock);
