Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0FVTrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:47:09 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51790 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756441Ab0FVTq7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 09/19] swiotlb-xen: Make 'xen_swiotlb_free_coherent' work.
Date: Tue, 22 Jun 2010 15:42:42 -0400
Message-Id: <1277235772-26757-10-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C2112CE.013A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See "swiotlb-xen: Make 'xen_swiotlb_free_coherent' work." for
detailed description.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index 2ebfcbd..2640052 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -169,14 +169,13 @@ void
 xen_swiotlb_free_coherent(struct device *hwdev, size_t size, void *vaddr,
 			  dma_addr_t dev_addr)
 {
-	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
+	int order = get_order(size);
+
+	if (dma_release_from_coherent(hwdev, order, vaddr))
+		return;
 
-	WARN_ON(irqs_disabled());
-	if (!is_xen_swiotlb_buffer(paddr))
-		free_pages((unsigned long)vaddr, get_order(size));
-	else
-		/* DMA_TO_DEVICE to avoid memcpy in swiotlb_tbl_unmap_single */
-		swiotlb_tbl_unmap_single(hwdev, vaddr, size, DMA_TO_DEVICE);
+	xen_destroy_contiguous_region((unsigned long)vaddr, order);
+	free_pages((unsigned long)vaddr, order);
 }
 EXPORT_SYMBOL_GPL(xen_swiotlb_free_coherent);
 
-- 
1.7.0.1

