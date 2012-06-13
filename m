Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab2FMGAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 02:00:54 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22166 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2FMGAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 02:00:53 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-73-4fd82c94b7d7
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] x86: dma-mapping: fix broken allocation when dma_mask has been
 provided
Date: Wed, 13 Jun 2012 07:57:26 +0200
Message-id: <1339567046-2264-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJJMWRmVeSWpSXmKPExsVy+t9jQd0pOjf8De4d5bC4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZDR/TCpo4K9ZtamJtYNzF3sXIySEhYCJx708nI4QtJnHh3nq2
	LkYuDiGB6YwSbVP+s0A4q5kkXny5wARSxSZgKNH1tosNxBYRMJDYsvIFK0gRs8BPRol1tzvA
	xgoLREm0/VjOAmKzCKhK3J4xAyjOwcEr4C7x+p8zxDZ5iaf3+9gmMHIvYGRYxSiaWpBcUJyU
	nmuoV5yYW1yal66XnJ+7iRHswWdSOxhXNlgcYhTgYFTi4f2idsNfiDWxrLgy9xCjBAezkghv
	8dbr/kK8KYmVValF+fFFpTmpxYcYpTlYlMR5m6wv+AsJpCeWpGanphakFsFkmTg4pRoY9XUZ
	Q+fI8slErO45ILjfVTq1csN8l/mXxXx/TDty9PHJ26q9Fscv3U25d2UdQ8jb9x1N+p9kvE9q
	FU9KfynH8e5XwrKfX2dK7LJIKVlt/dzBT0vEVma/jqtPj/N7ifVZq7ynJswJCbiRteSy3sSt
	1UIZLZn7hTa9/7Gq6wVXbeizYwfn/fq9SImlOCPRUIu5qDgRACmEzHvcAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 0a2b9a6ea93 ("X86: integrate CMA with DMA-mapping subsystem")
broke memory allocation with dma_mask. This patch fixes possible kernel
ops caused by lack of resetting page variable when jumping to 'again' label.

Reported-by: Konrad Rzeszutek Wilk <konrad@darnok.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 arch/x86/kernel/pci-dma.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 62c9457..c0f420f 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -100,7 +100,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 struct dma_attrs *attrs)
 {
 	unsigned long dma_mask;
-	struct page *page = NULL;
+	struct page *page;
 	unsigned int count = PAGE_ALIGN(size) >> PAGE_SHIFT;
 	dma_addr_t addr;
 
@@ -108,6 +108,7 @@ void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 
 	flag |= __GFP_ZERO;
 again:
+	page = NULL;
 	if (!(flag & GFP_ATOMIC))
 		page = dma_alloc_from_contiguous(dev, count, get_order(size));
 	if (!page)
-- 
1.7.1.569.g6f426

