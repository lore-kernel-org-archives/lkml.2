Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1KDVgI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 17:36:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38109 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab1KDVgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 17:36:06 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: Jon Medhurst <tixy@yxit.co.uk>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] arm: dma:  Drop GFP_COMP for DMA memory allocations
Date: Fri,  4 Nov 2011 15:35:39 -0600
Message-Id: <1320442539-7753-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sumit Bhattacharya <sumitb@nvidia.com>

dma_alloc_coherent wants to split pages after allocation in order to
reduce the memory footprint. This does not work well with GFP_COMP
pages, so drop this flag before allocation.

This patch is ported from arch/avr32
(commit 3611553ef985ef7c5863c8a94641738addd04cff).

Signed-off-by: Sumit Bhattacharya <sumitb@nvidia.com>
Tested-by: Varun Colbert <vcolbert@nvidia.com>
[swarren: s/HUGETLB_PAGE/HUGETLBFS/ in comment, minor comment cleanup]
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index e4e7f6c..68d64b4 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -332,6 +332,15 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 	struct page *page;
 	void *addr;
 
+	/*
+	 * Following is a work-around (a.k.a. hack) to prevent pages
+	 * with __GFP_COMP being passed to split_page() which cannot
+	 * handle them.  The real problem is that this flag probably
+	 * should be 0 on ARM as it is not supported on this
+	 * platform; see CONFIG_HUGETLBFS.
+	 */
+	gfp &= ~(__GFP_COMP);
+
 	*handle = ~0;
 	size = PAGE_ALIGN(size);
 
-- 
1.7.0.4

