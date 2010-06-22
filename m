Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282Ab0FVTrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:47:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32970 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab0FVTrg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:47:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 12/19] swiotlb-xen: Make 'xen_swiotlb_map_sg_attrs' work.
Date: Tue, 22 Jun 2010 15:42:45 -0400
Message-Id: <1277235772-26757-13-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4C2112EA.0115:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refer to "swiotlb-xen: Make 'xen_swiotlb_[map|unmap]_page' work." for
details why we want to use our own address translation mechanism.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index ca6c537..d457f7e 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -343,10 +343,11 @@ xen_swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nelems, i) {
 		phys_addr_t paddr = sg_phys(sg);
-		dma_addr_t dev_addr = phys_to_dma(hwdev, paddr);
+		dma_addr_t dev_addr = xen_phys_to_bus(hwdev, paddr);
 
 		if (swiotlb_force ||
-		    !dma_capable(hwdev, dev_addr, sg->length)) {
+		    !dma_capable(hwdev, dev_addr, sg->length) ||
+		    range_straddles_page_boundary(paddr, sg->length)) {
 			void *map = xen_map_single(hwdev, sg_phys(sg),
 						   sg->length, dir);
 			if (!map) {
-- 
1.7.0.1

