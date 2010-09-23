Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0IWOop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 10:44:45 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:18668 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab0IWOoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 10:44:44 -0400
X-SpamScore: 1
X-BigFish: VS1(zzzz1202hzz8275bh8275dhz32i87h2a8h43h65h)
X-Spam-TCS-SCL: 4:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L97FM9-01-70P-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>, <stable@kernel.org>
Subject: [PATCH 3/3] x86/amd-iommu: Fix rounding-bug in __unmap_single
Date: Thu, 23 Sep 2010 16:44:49 +0200
Message-ID: <1285253089-4570-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
References: <1285253089-4570-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the __unmap_single function the dma_addr is rounded down
to a page boundary before the dma pages are unmapped. The
address is later also used to flush the TLB entries for that
mapping. But without the offset into the dma page the amount
of pages to flush might be miscalculated in the TLB flushing
path. This patch fixes this bug by using the original
address to flush the TLB.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fa044e1..679b645 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1953,6 +1953,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 			   size_t size,
 			   int dir)
 {
+	dma_addr_t flush_addr;
 	dma_addr_t i, start;
 	unsigned int pages;
 
@@ -1960,6 +1961,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	    (dma_addr + size > dma_dom->aperture_size))
 		return;
 
+	flush_addr = dma_addr;
 	pages = iommu_num_pages(dma_addr, size, PAGE_SIZE);
 	dma_addr &= PAGE_MASK;
 	start = dma_addr;
@@ -1974,7 +1976,7 @@ static void __unmap_single(struct dma_ops_domain *dma_dom,
 	dma_ops_free_addresses(dma_dom, dma_addr, pages);
 
 	if (amd_iommu_unmap_flush || dma_dom->need_flush) {
-		iommu_flush_pages(&dma_dom->domain, dma_addr, size);
+		iommu_flush_pages(&dma_dom->domain, flush_addr, size);
 		dma_dom->need_flush = false;
 	}
 }
-- 
1.7.0.4


