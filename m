Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0FVTqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51764 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab0FVTqv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 11/19] swiotlb-xen: Make 'xen_swiotlb_sync_single' work.
Date: Tue, 22 Jun 2010 15:42:44 -0400
Message-Id: <1277235772-26757-12-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4C2112E9.014B:SCFMA4539811,ss=1,fgs=0
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
index efafcce..ca6c537 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -282,11 +282,12 @@ xen_swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 			size_t size, enum dma_data_direction dir,
 			enum dma_sync_target target)
 {
-	phys_addr_t paddr = dma_to_phys(hwdev, dev_addr);
+	phys_addr_t paddr = xen_bus_to_phys(hwdev, dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 
-	if (is_xen_swiotlb_buffer(paddr)) {
+	/* NOTE: We use dev_addr here, not paddr! */
+	if (is_xen_swiotlb_buffer(dev_addr)) {
 		swiotlb_tbl_sync_single(hwdev, phys_to_virt(paddr), size, dir,
 				       target);
 		return;
-- 
1.7.0.1

