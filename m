Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0FVTqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:46:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50824 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab0FVTqN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: "Ronny.Hegewald@online.de" <Ronny.Hegewald@online.de>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/19] swiotlb-xen: Don't allocate DMA-memory beyond 4GB in 32-bit mode.
Date: Tue, 22 Jun 2010 15:42:41 -0400
Message-Id: <1277235772-26757-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C2112AB.00AC:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ronny.Hegewald@online.de <Ronny.Hegewald@online.de>

When running in 32-bit PV environment various drivers try to allocate
a coherent DMA memory and the Xen SWIOTLB would return memory beyond 4GB.

On bare-metal the coherent DMA-memory using the native SWIOTLB would
always allocate memory inside the 32-bit address-range by calling
dma_alloc_coherent_mask.

The attached patch adds the same functionality to Xen SWIOTLB.

Signed-off-by: Ronny Hegewald <Ronny.Hegewald@online.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 lib/swiotlb-xen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/swiotlb-xen.c b/lib/swiotlb-xen.c
index 89443e4..2ebfcbd 100644
--- a/lib/swiotlb-xen.c
+++ b/lib/swiotlb-xen.c
@@ -150,7 +150,7 @@ xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 	ret = (void *)vstart;
 
 	if (hwdev && hwdev->coherent_dma_mask)
-		dma_mask = hwdev->coherent_dma_mask;
+		dma_mask = dma_alloc_coherent_mask(hwdev, flags);
 
 	if (ret) {
 		if (xen_create_contiguous_region(vstart, order,
-- 
1.7.0.1

