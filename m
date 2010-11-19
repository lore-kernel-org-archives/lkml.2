Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab0KSP6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 10:58:30 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25182 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183Ab0KSP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 10:58:26 -0500
Date: Fri, 19 Nov 2010 16:58:00 +0100
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [RFCv6 02/13] lib: bitmap: Added alignment offset for
 bitmap_find_next_zero_area()
In-reply-to: <cover.1290172312.git.m.nazarewicz@samsung.com>
To: mina86@mina86.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ankita Garg <ankita@in.ibm.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Johan Mossberg <johan.xx.mossberg@stericsson.com>,
        Jonathan Corbet <corbet@lwn.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>, dipankar@in.ibm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org
Message-id: <23036a00743a5d45d435b32803463ec70041fc5a.1290172312.git.m.nazarewicz@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.2.3
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <cover.1290172312.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds a bitmap_find_next_zero_area_off() function which
works like bitmap_find_next_zero_area() function expect it allows an
offset to be specified when alignment is checked.  This lets caller
request a bit such that its number plus the offset is aligned
according to the mask.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/bitmap.h |   24 +++++++++++++++++++-----
 lib/bitmap.c           |   22 ++++++++++++----------
 2 files changed, 31 insertions(+), 15 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index daf8c48..c0528d1 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -45,6 +45,7 @@
  * bitmap_set(dst, pos, nbits)			Set specified bit area
  * bitmap_clear(dst, pos, nbits)		Clear specified bit area
  * bitmap_find_next_zero_area(buf, len, pos, n, mask)	Find bit free area
+ * bitmap_find_next_zero_area_off(buf, len, pos, n, mask)	as above
  * bitmap_shift_right(dst, src, n, nbits)	*dst = *src >> n
  * bitmap_shift_left(dst, src, n, nbits)	*dst = *src << n
  * bitmap_remap(dst, src, old, new, nbits)	*dst = map(old, new)(src)
@@ -113,11 +114,24 @@ extern int __bitmap_weight(const unsigned long *bitmap, int bits);
 
 extern void bitmap_set(unsigned long *map, int i, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
-extern unsigned long bitmap_find_next_zero_area(unsigned long *map,
-					 unsigned long size,
-					 unsigned long start,
-					 unsigned int nr,
-					 unsigned long align_mask);
+
+extern unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
+						    unsigned long size,
+						    unsigned long start,
+						    unsigned int nr,
+						    unsigned long align_mask,
+						    unsigned long align_offset);
+
+static inline unsigned long
+bitmap_find_next_zero_area(unsigned long *map,
+			   unsigned long size,
+			   unsigned long start,
+			   unsigned int nr,
+			   unsigned long align_mask)
+{
+	return bitmap_find_next_zero_area_off(map, size, start, nr,
+					      align_mask, 0);
+}
 
 extern int bitmap_scnprintf(char *buf, unsigned int len,
 			const unsigned long *src, int nbits);
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 741fae9..8e75a6f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -315,30 +315,32 @@ void bitmap_clear(unsigned long *map, int start, int nr)
 }
 EXPORT_SYMBOL(bitmap_clear);
 
-/*
+/**
  * bitmap_find_next_zero_area - find a contiguous aligned zero area
  * @map: The address to base the search on
  * @size: The bitmap size in bits
  * @start: The bitnumber to start searching at
  * @nr: The number of zeroed bits we're looking for
  * @align_mask: Alignment mask for zero area
+ * @align_offset: Alignment offset for zero area.
  *
  * The @align_mask should be one less than a power of 2; the effect is that
- * the bit offset of all zero areas this function finds is multiples of that
- * power of 2. A @align_mask of 0 means no alignment is required.
+ * the bit offset of all zero areas this function finds plus @align_offset
+ * is multiple of that power of 2.
  */
-unsigned long bitmap_find_next_zero_area(unsigned long *map,
-					 unsigned long size,
-					 unsigned long start,
-					 unsigned int nr,
-					 unsigned long align_mask)
+unsigned long bitmap_find_next_zero_area_off(unsigned long *map,
+					     unsigned long size,
+					     unsigned long start,
+					     unsigned int nr,
+					     unsigned long align_mask,
+					     unsigned long align_offset)
 {
 	unsigned long index, end, i;
 again:
 	index = find_next_zero_bit(map, size, start);
 
 	/* Align allocation */
-	index = __ALIGN_MASK(index, align_mask);
+	index = __ALIGN_MASK(index + align_offset, align_mask) - align_offset;
 
 	end = index + nr;
 	if (end > size)
@@ -350,7 +352,7 @@ again:
 	}
 	return index;
 }
-EXPORT_SYMBOL(bitmap_find_next_zero_area);
+EXPORT_SYMBOL(bitmap_find_next_zero_area_off);
 
 /*
  * Bitmap printing & parsing functions: first version by Bill Irwin,
-- 
1.7.2.3

