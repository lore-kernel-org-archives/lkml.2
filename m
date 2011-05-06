Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab1EFAjF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:39:05 -0400
Received: from kroah.org ([198.145.64.141]:37339 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab1EFA0C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:26:02 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:18 2011
Message-Id: <20110506002217.957734951@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [129/143] MIPS: DMA: Fix computation of DMA flags from devices coherent_dma_mask.
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ralf Baechle <ralf@linux-mips.org>

commit 3b9c6c11f519718d618f5d7c9508daf78b207f6f upstream.

This only matters for ISA devices with a 24-bit DMA limit or for devices
with a 32-bit DMA limit on systems with ZONE_DMA32 enabled.  The latter
currently only affects 32-bit PCI cards on Sibyte-based systems with more
than 1GB RAM installed.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/mips/mm/dma-default.c |   28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -43,27 +43,39 @@ static inline int cpu_is_noncoherent_r10
 
 static gfp_t massage_gfp_flags(const struct device *dev, gfp_t gfp)
 {
+	gfp_t dma_flag;
+
 	/* ignore region specifiers */
 	gfp &= ~(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM);
 
-#ifdef CONFIG_ZONE_DMA
+#ifdef CONFIG_ISA
 	if (dev == NULL)
-		gfp |= __GFP_DMA;
-	else if (dev->coherent_dma_mask < DMA_BIT_MASK(24))
-		gfp |= __GFP_DMA;
+		dma_flag = __GFP_DMA;
 	else
 #endif
-#ifdef CONFIG_ZONE_DMA32
+#if defined(CONFIG_ZONE_DMA32) && defined(CONFIG_ZONE_DMA)
 	     if (dev->coherent_dma_mask < DMA_BIT_MASK(32))
-		gfp |= __GFP_DMA32;
+			dma_flag = __GFP_DMA;
+	else if (dev->coherent_dma_mask < DMA_BIT_MASK(64))
+			dma_flag = __GFP_DMA32;
+	else
+#endif
+#if defined(CONFIG_ZONE_DMA32) && !defined(CONFIG_ZONE_DMA)
+	     if (dev->coherent_dma_mask < DMA_BIT_MASK(64))
+		dma_flag = __GFP_DMA32;
+	else
+#endif
+#if defined(CONFIG_ZONE_DMA) && !defined(CONFIG_ZONE_DMA32)
+	     if (dev->coherent_dma_mask < DMA_BIT_MASK(64))
+		dma_flag = __GFP_DMA;
 	else
 #endif
-		;
+		dma_flag = 0;
 
 	/* Don't invoke OOM killer */
 	gfp |= __GFP_NORETRY;
 
-	return gfp;
+	return gfp | dma_flag;
 }
 
 void *dma_alloc_noncoherent(struct device *dev, size_t size,


