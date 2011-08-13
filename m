Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab1HMEQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 00:16:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39531 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1HMEQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 00:16:44 -0400
MIME-Version: 1.0
In-Reply-To: <1312824249.1539.40.camel@vkoul-udesk3>
References: <CAJd=RBBU7SvVLmVqR_LmJMWG=rgya80DbdPNEc-nR=_d4YQrDQ@mail.gmail.com>
	<1312824249.1539.40.camel@vkoul-udesk3>
Date: Sat, 13 Aug 2011 12:16:43 +0800
Message-ID: <CAJd=RBB2LPeqQ0Fg+NHQdSzPPR8Fg_PbquuOtp1RFt3xtRmjow@mail.gmail.com>
Subject: [RFC patch resend] DMA engine/Langwell: release LLI pool
From: Hillf Danton <dhillf@gmail.com>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When releasing resources allocated before for DMA channel, checking LLI pool
is added and it is reclaimed if necessary.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/drivers/dma/intel_mid_dma.c	Sat Aug 13 11:44:46 2011
+++ intel_mid_dma.c	Sat Aug 13 12:21:41 2011
@@ -833,6 +833,11 @@ static void intel_mid_dma_free_chan_reso
 	midc->descs_allocated = 0;
 	list_for_each_entry_safe(desc, _desc, &midc->active_list, desc_node) {
 		list_del(&desc->desc_node);
+		if (desc->lli != NULL) {
+			pci_pool_free(desc->lli_pool, desc->lli,
+					desc->lli_phys);
+			pci_pool_destroy(desc->lli_pool);
+		}
 		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
 	}
 	list_for_each_entry_safe(desc, _desc, &midc->free_list, desc_node) {
@@ -841,6 +846,11 @@ static void intel_mid_dma_free_chan_reso
 	}
 	list_for_each_entry_safe(desc, _desc, &midc->queue, desc_node) {
 		list_del(&desc->desc_node);
+		if (desc->lli != NULL) {
+			pci_pool_free(desc->lli_pool, desc->lli,
+					desc->lli_phys);
+			pci_pool_destroy(desc->lli_pool);
+		}
 		pci_pool_free(mid->dma_pool, desc, desc->txd.phys);
 	}
 	spin_unlock_bh(&midc->lock);
