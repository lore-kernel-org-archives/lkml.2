Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0LFX0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 18:26:00 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27258 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867Ab0LFXZd (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 6 Dec 2010 18:25:33 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com, airlied@redhat.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 13/23] ia64/agp/zx1: Use PCI API for inserting pages in HP's ZX1 AGP device.
Date: Mon,  6 Dec 2010 18:24:25 -0500
Message-Id: <1291677875-30493-14-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hp-agp.c code sets its own GATT up, but relies on
agp_generic_[alloc|destroy]_page[|s] functions, which use the PCI API.

Following the chain of functions that pci_alloc_consistent does
on a ZX1 w/ a SBA or w/ a SBA + SWIOTLB it ends up in either
sba_alloc_coherent or ia64_swiotlb_alloc_coherent. The SBA ends
up using alloc_pages_exact_node, while the other: __get_free_pages.
The dma_address they come up with is virt_to_phys(addr) or in case
of needing to use the SWIOTLB or SBA's pool, they give the DMA address
of the virtual pages in their pool.

Since the dma_addr[i] ends up having the value from virt_to_phys(addr)
or page_to_phys(addr), lets utilize the dma_addr[i] and stick
a WARN_ON just in case.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/char/agp/hp-agp.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
index 056b289..a19d599 100644
--- a/drivers/char/agp/hp-agp.c
+++ b/drivers/char/agp/hp-agp.c
@@ -362,7 +362,8 @@ hp_zx1_insert_memory (struct agp_memory *mem, off_t pg_start, int type)
 	for (i = 0, j = io_pg_start; i < mem->page_count; i++) {
 		unsigned long paddr;
 
-		paddr = page_to_phys(mem->pages[i]);
+		paddr = (unsigned long)mem->dma_addr[i];
+		WARN_ON(page_to_phys(mem->pages[i]) != mem->dma_addr[i]);
 		for (k = 0;
 		     k < hp->io_pages_per_kpage;
 		     k++, j++, paddr += hp->io_page_size) {
-- 
1.7.1

