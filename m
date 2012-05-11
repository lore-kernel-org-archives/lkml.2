Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932110Ab2EKOKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:10:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44675 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760096Ab2EKOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:10:43 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] Optimize bitmap_weight
Date: Fri, 11 May 2012 23:10:14 +0900
Message-Id: <1336745414-5530-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current implementation of bitmap_weight simply evaluates the
population count for each long word of the array, and adds.

The subsection "Counting 1-bits in an Array" in the revisions of
the book 'Hacker's Delight' explains more superior methods than
the naive method.

http://www.hackersdelight.org/revisions.pdf
http://www.hackersdelight.org/HDcode/newCode/pop_arrayHS.c.txt

My benchmark results on Intel Core i3 CPU with 32-bit kernel
showed 50% faster for 8192 bits bitmap.  However, it is not faster
for small bitmap (< BITS_PER_LONG * 8) than the naive method.
So if the bitmap size is known to be small at compile time,
use the naive method.

/*
 * userspace bitmap_weight() benchmark program
 */
extern int __bitmap_weight(const unsigned long *bitmap, int bits);
extern int __bitmap_weight_fast(const unsigned long *bitmap, int bits);

int main(int argc, char **argv)
{
	int i;
	struct timeval start[2], stop[2], diff[2];
	unsigned int bits;
	unsigned long bitmap[1024 * 1024];
	int n, m;
	int iterations;

	if (argc != 4) {
		fprintf(stderr, "Usage: %s SEED BITS ITERATIONS\n", argv[0]);
		return -1;
	}

	srand(atoi(argv[1]));
	bits = atoi(argv[2]) % (sizeof(bitmap) * 8);
	iterations = atoi(argv[3]);

	for (i = 0; i < sizeof(bitmap); i++)
		((unsigned char *)bitmap)[i] = rand();

	/* dummy call */
	gettimeofday(&start[0], NULL);
	n = __bitmap_weight(bitmap, bits);
	gettimeofday(&stop[0], NULL);
	gettimeofday(&start[1], NULL);
	m = __bitmap_weight_fast(bitmap, bits);
	gettimeofday(&stop[1], NULL);

	if (n != m) {
		fprintf(stderr, "Oops %d != %d (%d)\n", n, m, atoi(argv[1]));
		return -1;
	}

	gettimeofday(&start[0], NULL);
	for (i = 0; i < iterations; i++)
		n += __bitmap_weight(bitmap, bits);
	gettimeofday(&stop[0], NULL);

	gettimeofday(&start[1], NULL);
	for (i = 0; i < iterations; i++)
		m += __bitmap_weight_fast(bitmap, bits);
	gettimeofday(&stop[1], NULL);

	if (n != m)
		return -1;

	timersub(&stop[0], &start[0], &diff[0]);
	timersub(&stop[1], &start[1], &diff[1]);
	printf("%d %d: %lu.%06lu %lu.%06lu\n", bits, iterations,
		diff[0].tv_sec, diff[0].tv_usec,
		diff[1].tv_sec, diff[1].tv_usec);

	return 0;
}

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 include/linux/bitmap.h |    5 +++-
 lib/bitmap.c           |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 53 insertions(+), 1 deletions(-)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index 7ad6345..9191c7d 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -111,6 +111,7 @@ extern int __bitmap_intersects(const unsigned long *bitmap1,
 extern int __bitmap_subset(const unsigned long *bitmap1,
 			const unsigned long *bitmap2, int bits);
 extern int __bitmap_weight(const unsigned long *bitmap, int bits);
+extern int __bitmap_weight_fast(const unsigned long *bitmap, int bits);
 
 extern void bitmap_set(unsigned long *map, int i, int len);
 extern void bitmap_clear(unsigned long *map, int start, int nr);
@@ -277,7 +278,9 @@ static inline int bitmap_weight(const unsigned long *src, int nbits)
 {
 	if (small_const_nbits(nbits))
 		return hweight_long(*src & BITMAP_LAST_WORD_MASK(nbits));
-	return __bitmap_weight(src, nbits);
+	else if (__builtin_constant_p(nbits) && (nbits) < BITS_PER_LONG * 8)
+		return __bitmap_weight(src, nbits);
+	return __bitmap_weight_fast(src, nbits);
 }
 
 static inline void bitmap_shift_right(unsigned long *dst,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 18c67d8..7352263 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -254,6 +254,55 @@ int __bitmap_weight(const unsigned long *bitmap, int bits)
 }
 EXPORT_SYMBOL(__bitmap_weight);
 
+#define CSA(h, l, a, b, c) \
+	{ \
+		unsigned long u = a ^ b; \
+		unsigned long v = c; \
+		h = (a & b) | (u & v); \
+		l = u ^ v; \
+	} while (0)
+
+/**
+ * __bitmap_weight_fast - count the set bits in a bitmap
+ * @bitmap: pointer to bitmap
+ * @bits: bitmap size, in bits
+ *
+ * This implementation is based on the algorithm from the subsection
+ * "Counting 1-bits in an Array" in the revisions of the book
+ * 'Hacker's Delight'.
+ *
+ * http://www.hackersdelight.org/revisions.pdf
+ * http://www.hackersdelight.org/HDcode/newCode/pop_arrayHS.c.txt
+ */
+int __bitmap_weight_fast(const unsigned long *bitmap, int bits)
+{
+	int k, w = 0, lim = bits / BITS_PER_LONG;
+	unsigned long ones, twos, twosA, twosB, fours, foursA, foursB, eights;
+	fours = twos = ones = 0;
+
+	for (k = 0; k < lim - 7; k += 8) {
+		CSA(twosA, ones, ones, bitmap[k], bitmap[k + 1]);
+		CSA(twosB, ones, ones, bitmap[k + 2], bitmap[k + 3]);
+		CSA(foursA, twos, twos, twosA, twosB);
+		CSA(twosA, ones, ones, bitmap[k + 4], bitmap[k + 5]);
+		CSA(twosB, ones, ones, bitmap[k + 6], bitmap[k + 7]);
+		CSA(foursB, twos, twos, twosA, twosB);
+		CSA(eights, fours, fours, foursA, foursB);
+		w += hweight_long(eights);
+	}
+	w = 8 * w + 4 * hweight_long(fours) + 2 * hweight_long(twos) +
+		hweight_long(ones);
+
+	for (; k < lim; k++)
+		w += hweight_long(bitmap[k]);
+
+	if (bits % BITS_PER_LONG)
+		w += hweight_long(bitmap[k] & BITMAP_LAST_WORD_MASK(bits));
+
+	return w;
+}
+EXPORT_SYMBOL(__bitmap_weight_fast);
+
 void bitmap_set(unsigned long *map, int start, int nr)
 {
 	unsigned long *p = map + BIT_WORD(start);
-- 
1.7.7.6

