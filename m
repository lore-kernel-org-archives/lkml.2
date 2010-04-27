Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0D0M1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:27:10 -0400
Received: from sh.osrg.net ([192.16.179.4]:37058 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755398Ab0D0M0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:26:18 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH -mm 4/6] powerpc: remove unnecessary sync_single_range_* in swiotlb_dma_ops
Date: Tue, 27 Apr 2010 21:25:38 +0900
Message-Id: <1272371140-6085-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Apr 2010 21:26:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sync_single_range_for_cpu and sync_single_range_for_device hooks in
swiotlb_dma_ops are unnecessary because sync_single_for_cpu and
sync_single_for_device are used there.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Becky Bruce <beckyb@kernel.crashing.org>
---
 arch/powerpc/kernel/dma-swiotlb.c |    4 ++--
 arch/powerpc/kernel/dma.c         |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kernel/dma-swiotlb.c b/arch/powerpc/kernel/dma-swiotlb.c
index 59c9285..cc79e8d 100644
--- a/arch/powerpc/kernel/dma-swiotlb.c
+++ b/arch/powerpc/kernel/dma-swiotlb.c
@@ -38,8 +38,8 @@ struct dma_map_ops swiotlb_dma_ops = {
 	.dma_supported = swiotlb_dma_supported,
 	.map_page = swiotlb_map_page,
 	.unmap_page = swiotlb_unmap_page,
-	.sync_single_range_for_cpu = swiotlb_sync_single_range_for_cpu,
-	.sync_single_range_for_device = swiotlb_sync_single_range_for_device,
+	.sync_single_for_cpu = swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = swiotlb_sync_single_for_device,
 	.sync_sg_for_cpu = swiotlb_sync_sg_for_cpu,
 	.sync_sg_for_device = swiotlb_sync_sg_for_device,
 	.mapping_error = swiotlb_dma_mapping_error,
diff --git a/arch/powerpc/kernel/dma.c b/arch/powerpc/kernel/dma.c
index 6c1df57..8d1de6f 100644
--- a/arch/powerpc/kernel/dma.c
+++ b/arch/powerpc/kernel/dma.c
@@ -127,11 +127,11 @@ static inline void dma_direct_sync_sg(struct device *dev,
 		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
-static inline void dma_direct_sync_single_range(struct device *dev,
-		dma_addr_t dma_handle, unsigned long offset, size_t size,
-		enum dma_data_direction direction)
+static inline void dma_direct_sync_single(struct device *dev,
+					  dma_addr_t dma_handle, size_t size,
+					  enum dma_data_direction direction)
 {
-	__dma_sync(bus_to_virt(dma_handle+offset), size, direction);
+	__dma_sync(bus_to_virt(dma_handle), size, direction);
 }
 #endif
 
@@ -144,8 +144,8 @@ struct dma_map_ops dma_direct_ops = {
 	.map_page	= dma_direct_map_page,
 	.unmap_page	= dma_direct_unmap_page,
 #ifdef CONFIG_NOT_COHERENT_CACHE
-	.sync_single_range_for_cpu 	= dma_direct_sync_single_range,
-	.sync_single_range_for_device 	= dma_direct_sync_single_range,
+	.sync_single_for_cpu 		= dma_direct_sync_single,
+	.sync_single_for_device 	= dma_direct_sync_single,
 	.sync_sg_for_cpu 		= dma_direct_sync_sg,
 	.sync_sg_for_device 		= dma_direct_sync_sg,
 #endif
-- 
1.6.5

