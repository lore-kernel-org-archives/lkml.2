Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933418Ab1J1VTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 17:19:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56934 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933385Ab1J1VTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 17:19:00 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Russell King <rmk@arm.linux.org.uk>, Marc Singer <elf@buici.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        Sumit Bhattacharya <sumitb@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH] arm: dma: Drop GFP_COMP for DMA memory allocations
Date: Fri, 28 Oct 2011 15:18:52 -0600
Message-Id: <1319836732-31687-1-git-send-email-swarren@nvidia.com>
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
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Russell, for background, please see:
http://www.spinics.net/lists/alsa-devel/msg05399.html
https://lkml.org/lkml/2006/7/8/236

I believe the patch below was once posted to solve this for ARM, but never
got picked up. Evidently, AVR32 did pick it up. I'm wondering if we should
pick this up for ARM now, or if there's some other solution?

(note: This patch is actually based on one of our older internal kernels;
I'd need to rebase it if we do decide to go ahead with it. I also haven't
tested it in mainline, and would have difficulty doing so, since the issue
this solves only shows up when using our HD-Audio controller on Tegra30,
and that isn't upstream yet.)

 arch/arm/mm/dma-mapping.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 82a093c..93b86e6 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -308,6 +308,13 @@ __dma_alloc(struct device *dev, size_t size, dma_addr_t *handle, gfp_t gfp,
 	struct page *page;
 	void *addr;
 
+	/* Following is a work-around (a.k.a. hack) to prevent pages
+	 * with __GFP_COMP being passed to split_page() which cannot
+	 * handle them.  The real problem is that this flag probably
+	 * should be 0 on ARM as it is not supported on this
+	 * platform--see CONFIG_HUGETLB_PAGE. */
+	gfp &= ~(__GFP_COMP);
+
 	*handle = ~0;
 	size = PAGE_ALIGN(size);
 
-- 
1.7.0.4

