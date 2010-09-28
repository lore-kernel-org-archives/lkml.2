Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab0I1MX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:23:57 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:51340 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007Ab0I1MX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=D8oxSwTwqT3H7Krq45akykFHoXIi0Se2atiVRgKm3OqEsgv1CBomF3dHWH/mb9yoid
         VNtKy4BRyBzAIh0pwHN09tYzbvjZBFkP2XStKzN5OM6byY9B4k9M4oq7jroceWUlmN8D
         DLbdIhX8Ylaax0ISLgWwSBbeNs1kM7C6mTXUs=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: cleanup gfp_zone()
Date: Tue, 28 Sep 2010 21:23:44 +0900
Message-Id: <1285676624-1300-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use Z[TB]_SHIFT() macro to calculate GFP_ZONE_TABLE and GFP_ZONE_BAD.
This also removes lots of warnings from sparse like following:

 warning: restricted gfp_t degrades to integer

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/gfp.h |   43 ++++++++++++++++++++++++-------------------
 1 files changed, 24 insertions(+), 19 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 975609c..cebfee1 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -185,15 +185,16 @@ static inline int allocflags_to_migratetype(gfp_t gfp_flags)
 #error ZONES_SHIFT too large to create GFP_ZONE_TABLE integer
 #endif
 
+#define ZT_SHIFT(gfp) ((__force int) (gfp) * ZONES_SHIFT)
 #define GFP_ZONE_TABLE ( \
-	(ZONE_NORMAL << 0 * ZONES_SHIFT)				\
-	| (OPT_ZONE_DMA << __GFP_DMA * ZONES_SHIFT)			\
-	| (OPT_ZONE_HIGHMEM << __GFP_HIGHMEM * ZONES_SHIFT)		\
-	| (OPT_ZONE_DMA32 << __GFP_DMA32 * ZONES_SHIFT)			\
-	| (ZONE_NORMAL << __GFP_MOVABLE * ZONES_SHIFT)			\
-	| (OPT_ZONE_DMA << (__GFP_MOVABLE | __GFP_DMA) * ZONES_SHIFT)	\
-	| (ZONE_MOVABLE << (__GFP_MOVABLE | __GFP_HIGHMEM) * ZONES_SHIFT)\
-	| (OPT_ZONE_DMA32 << (__GFP_MOVABLE | __GFP_DMA32) * ZONES_SHIFT)\
+	(ZONE_NORMAL        << ZT_SHIFT(0))				\
+	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_DMA))			\
+	| (OPT_ZONE_HIGHMEM << ZT_SHIFT(__GFP_HIGHMEM))			\
+	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_DMA32))			\
+	| (ZONE_NORMAL      << ZT_SHIFT(__GFP_MOVABLE))			\
+	| (OPT_ZONE_DMA     << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA))	\
+	| (ZONE_MOVABLE     << ZT_SHIFT(__GFP_MOVABLE | __GFP_HIGHMEM)) \
+	| (OPT_ZONE_DMA32   << ZT_SHIFT(__GFP_MOVABLE | __GFP_DMA32))	\
 )
 
 /*
@@ -202,24 +203,25 @@ static inline int allocflags_to_migratetype(gfp_t gfp_flags)
  * entry starting with bit 0. Bit is set if the combination is not
  * allowed.
  */
+#define ZB_SHIFT(gfp) ((__force int) (gfp))
 #define GFP_ZONE_BAD ( \
-	1 << (__GFP_DMA | __GFP_HIGHMEM)				\
-	| 1 << (__GFP_DMA | __GFP_DMA32)				\
-	| 1 << (__GFP_DMA32 | __GFP_HIGHMEM)				\
-	| 1 << (__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)		\
-	| 1 << (__GFP_MOVABLE | __GFP_HIGHMEM | __GFP_DMA)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_HIGHMEM)		\
-	| 1 << (__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA | __GFP_HIGHMEM)\
+	1   << ZB_SHIFT(__GFP_DMA | __GFP_HIGHMEM)			\
+	| 1 << ZB_SHIFT(__GFP_DMA | __GFP_DMA32)			\
+	| 1 << ZB_SHIFT(__GFP_DMA32 | __GFP_HIGHMEM)			\
+	| 1 << ZB_SHIFT(__GFP_DMA | __GFP_DMA32 | __GFP_HIGHMEM)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_HIGHMEM | __GFP_DMA)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_DMA32 | __GFP_HIGHMEM)	\
+	| 1 << ZB_SHIFT(__GFP_MOVABLE | __GFP_DMA32 | __GFP_DMA |	\
+			__GFP_HIGHMEM)					\
 )
 
 static inline enum zone_type gfp_zone(gfp_t flags)
 {
 	enum zone_type z;
-	int bit = flags & GFP_ZONEMASK;
+	int bit = (__force int) (flags & GFP_ZONEMASK);
 
-	z = (GFP_ZONE_TABLE >> (bit * ZONES_SHIFT)) &
-					 ((1 << ZONES_SHIFT) - 1);
+	z = (GFP_ZONE_TABLE >> ZT_SHIFT(bit)) & ((1 << ZONES_SHIFT) - 1);
 
 	if (__builtin_constant_p(bit))
 		MAYBE_BUILD_BUG_ON((GFP_ZONE_BAD >> bit) & 1);
@@ -231,6 +233,9 @@ static inline enum zone_type gfp_zone(gfp_t flags)
 	return z;
 }
 
+#undef ZT_SHIFT
+#undef ZB_SHIFT
+
 /*
  * There is only one page-allocator function, and two main namespaces to
  * it. The alloc_page*() variants return 'struct page *' and as such
-- 
1.7.2.2

