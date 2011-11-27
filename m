Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab1K0FbS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:31:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101Ab1K0FbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:31:12 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Peter Osterlund <petero2@telia.com>, Jens Axboe <axboe@kernel.dk>,
        Kay Sievers <kay.sievers@vrfy.org>, Namhyung Kim <namhyung@gmail.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>, drbd-user@lists.linbit.com
Subject: [PATCH 11/62] block: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:51 +0800
Message-Id: <1322371662-26166-12-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/block/brd.c              |   20 ++++++++++----------
 drivers/block/drbd/drbd_bitmap.c |   36 ++++++++++++++++++------------------
 drivers/block/drbd/drbd_nl.c     |    4 ++--
 drivers/block/loop.c             |   16 ++++++++--------
 drivers/block/pktcdvd.c          |    8 ++++----
 5 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index d22119d..b345834 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -242,9 +242,9 @@ static void copy_to_brd(struct brd_device *brd, const void *src,
 	page = brd_lookup_page(brd, sector);
 	BUG_ON(!page);
 
-	dst = kmap_atomic(page, KM_USER1);
+	dst = kmap_atomic(page);
 	memcpy(dst + offset, src, copy);
-	kunmap_atomic(dst, KM_USER1);
+	kunmap_atomic(dst);
 
 	if (copy < n) {
 		src += copy;
@@ -253,9 +253,9 @@ static void copy_to_brd(struct brd_device *brd, const void *src,
 		page = brd_lookup_page(brd, sector);
 		BUG_ON(!page);
 
-		dst = kmap_atomic(page, KM_USER1);
+		dst = kmap_atomic(page);
 		memcpy(dst, src, copy);
-		kunmap_atomic(dst, KM_USER1);
+		kunmap_atomic(dst);
 	}
 }
 
@@ -273,9 +273,9 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
 	page = brd_lookup_page(brd, sector);
 	if (page) {
-		src = kmap_atomic(page, KM_USER1);
+		src = kmap_atomic(page);
 		memcpy(dst, src + offset, copy);
-		kunmap_atomic(src, KM_USER1);
+		kunmap_atomic(src);
 	} else
 		memset(dst, 0, copy);
 
@@ -285,9 +285,9 @@ static void copy_from_brd(void *dst, struct brd_device *brd,
 		copy = n - copy;
 		page = brd_lookup_page(brd, sector);
 		if (page) {
-			src = kmap_atomic(page, KM_USER1);
+			src = kmap_atomic(page);
 			memcpy(dst, src, copy);
-			kunmap_atomic(src, KM_USER1);
+			kunmap_atomic(src);
 		} else
 			memset(dst, 0, copy);
 	}
@@ -309,7 +309,7 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 			goto out;
 	}
 
-	mem = kmap_atomic(page, KM_USER0);
+	mem = kmap_atomic(page);
 	if (rw == READ) {
 		copy_from_brd(mem + off, brd, sector, len);
 		flush_dcache_page(page);
@@ -317,7 +317,7 @@ static int brd_do_bvec(struct brd_device *brd, struct page *page,
 		flush_dcache_page(page);
 		copy_to_brd(brd, mem + off, sector, len);
 	}
-	kunmap_atomic(mem, KM_USER0);
+	kunmap_atomic(mem);
 
 out:
 	return err;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 912f585..39de9ff 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -292,22 +292,22 @@ static unsigned int bm_bit_to_page_idx(struct drbd_bitmap *b, u64 bitnr)
 static unsigned long *__bm_map_pidx(struct drbd_bitmap *b, unsigned int idx, const enum km_type km)
 {
 	struct page *page = b->bm_pages[idx];
-	return (unsigned long *) kmap_atomic(page, km);
+	return (unsigned long *) kmap_atomic(page);
 }
 
 static unsigned long *bm_map_pidx(struct drbd_bitmap *b, unsigned int idx)
 {
-	return __bm_map_pidx(b, idx, KM_IRQ1);
+	return __bm_map_pidx(b, idx);
 }
 
-static void __bm_unmap(unsigned long *p_addr, const enum km_type km)
+static void __bm_unmap(unsigned long *p_addr)
 {
-	kunmap_atomic(p_addr, km);
+	kunmap_atomic(p_addr);
 };
 
 static void bm_unmap(unsigned long *p_addr)
 {
-	return __bm_unmap(p_addr, KM_IRQ1);
+	return __bm_unmap(p_addr);
 }
 
 /* long word offset of _bitmap_ sector */
@@ -543,10 +543,10 @@ static unsigned long bm_count_bits(struct drbd_bitmap *b)
 
 	/* all but last page */
 	for (idx = 0; idx < b->bm_number_of_pages - 1; idx++) {
-		p_addr = __bm_map_pidx(b, idx, KM_USER0);
+		p_addr = __bm_map_pidx(b, idx);
 		for (i = 0; i < LWPP; i++)
 			bits += hweight_long(p_addr[i]);
-		__bm_unmap(p_addr, KM_USER0);
+		__bm_unmap(p_addr);
 		cond_resched();
 	}
 	/* last (or only) page */
@@ -1163,7 +1163,7 @@ int drbd_bm_write_page(struct drbd_conf *mdev, unsigned int idx) __must_hold(loc
  * this returns a bit number, NOT a sector!
  */
 static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
-	const int find_zero_bit, const enum km_type km)
+	const int find_zero_bit)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned long *p_addr;
@@ -1178,7 +1178,7 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
 		while (bm_fo < b->bm_bits) {
 			/* bit offset of the first bit in the page */
 			bit_offset = bm_fo & ~BITS_PER_PAGE_MASK;
-			p_addr = __bm_map_pidx(b, bm_bit_to_page_idx(b, bm_fo), km);
+			p_addr = __bm_map_pidx(b, bm_bit_to_page_idx(b, bm_fo));
 
 			if (find_zero_bit)
 				i = find_next_zero_bit_le(p_addr,
@@ -1187,7 +1187,7 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
 				i = find_next_bit_le(p_addr,
 						PAGE_SIZE*8, bm_fo & BITS_PER_PAGE_MASK);
 
-			__bm_unmap(p_addr, km);
+			__bm_unmap(p_addr);
 			if (i < PAGE_SIZE*8) {
 				bm_fo = bit_offset + i;
 				if (bm_fo >= b->bm_bits)
@@ -1215,7 +1215,7 @@ static unsigned long bm_find_next(struct drbd_conf *mdev,
 	if (BM_DONT_TEST & b->bm_flags)
 		bm_print_lock_info(mdev);
 
-	i = __bm_find_next(mdev, bm_fo, find_zero_bit, KM_IRQ1);
+	i = __bm_find_next(mdev, bm_fo, find_zero_bit);
 
 	spin_unlock_irq(&b->bm_lock);
 	return i;
@@ -1239,13 +1239,13 @@ unsigned long drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo
 unsigned long _drbd_bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo)
 {
 	/* WARN_ON(!(BM_DONT_SET & mdev->b->bm_flags)); */
-	return __bm_find_next(mdev, bm_fo, 0, KM_USER1);
+	return __bm_find_next(mdev, bm_fo, 0);
 }
 
 unsigned long _drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo)
 {
 	/* WARN_ON(!(BM_DONT_SET & mdev->b->bm_flags)); */
-	return __bm_find_next(mdev, bm_fo, 1, KM_USER1);
+	return __bm_find_next(mdev, bm_fo, 1);
 }
 
 /* returns number of bits actually changed.
@@ -1273,14 +1273,14 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 		unsigned int page_nr = bm_bit_to_page_idx(b, bitnr);
 		if (page_nr != last_page_nr) {
 			if (p_addr)
-				__bm_unmap(p_addr, KM_IRQ1);
+				__bm_unmap(p_addr);
 			if (c < 0)
 				bm_set_page_lazy_writeout(b->bm_pages[last_page_nr]);
 			else if (c > 0)
 				bm_set_page_need_writeout(b->bm_pages[last_page_nr]);
 			changed_total += c;
 			c = 0;
-			p_addr = __bm_map_pidx(b, page_nr, KM_IRQ1);
+			p_addr = __bm_map_pidx(b, page_nr);
 			last_page_nr = page_nr;
 		}
 		if (val)
@@ -1289,7 +1289,7 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 			c -= (0 != __test_and_clear_bit_le(bitnr & BITS_PER_PAGE_MASK, p_addr));
 	}
 	if (p_addr)
-		__bm_unmap(p_addr, KM_IRQ1);
+		__bm_unmap(p_addr);
 	if (c < 0)
 		bm_set_page_lazy_writeout(b->bm_pages[last_page_nr]);
 	else if (c > 0)
@@ -1342,13 +1342,13 @@ static inline void bm_set_full_words_within_one_page(struct drbd_bitmap *b,
 {
 	int i;
 	int bits;
-	unsigned long *paddr = kmap_atomic(b->bm_pages[page_nr], KM_IRQ1);
+	unsigned long *paddr = kmap_atomic(b->bm_pages[page_nr]);
 	for (i = first_word; i < last_word; i++) {
 		bits = hweight_long(paddr[i]);
 		paddr[i] = ~0UL;
 		b->bm_set += BITS_PER_LONG - bits;
 	}
-	kunmap_atomic(paddr, KM_IRQ1);
+	kunmap_atomic(paddr);
 }
 
 /* Same thing as drbd_bm_set_bits,
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index af2a250..e09f9ce 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -2526,10 +2526,10 @@ void drbd_bcast_ee(struct drbd_conf *mdev,
 
 	page = e->pages;
 	page_chain_for_each(page) {
-		void *d = kmap_atomic(page, KM_USER0);
+		void *d = kmap_atomic(page);
 		unsigned l = min_t(unsigned, len, PAGE_SIZE);
 		memcpy(tl, d, l);
-		kunmap_atomic(d, KM_USER0);
+		kunmap_atomic(d);
 		tl = (unsigned short*)((char*)tl + l);
 		len -= l;
 		if (len == 0)
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 68b205a..4fe6227 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -94,16 +94,16 @@ static int transfer_none(struct loop_device *lo, int cmd,
 			 struct page *loop_page, unsigned loop_off,
 			 int size, sector_t real_block)
 {
-	char *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
+	char *raw_buf = kmap_atomic(raw_page) + raw_off;
+	char *loop_buf = kmap_atomic(loop_page) + loop_off;
 
 	if (cmd == READ)
 		memcpy(loop_buf, raw_buf, size);
 	else
 		memcpy(raw_buf, loop_buf, size);
 
-	kunmap_atomic(loop_buf, KM_USER1);
-	kunmap_atomic(raw_buf, KM_USER0);
+	kunmap_atomic(loop_buf);
+	kunmap_atomic(raw_buf);
 	cond_resched();
 	return 0;
 }
@@ -113,8 +113,8 @@ static int transfer_xor(struct loop_device *lo, int cmd,
 			struct page *loop_page, unsigned loop_off,
 			int size, sector_t real_block)
 {
-	char *raw_buf = kmap_atomic(raw_page, KM_USER0) + raw_off;
-	char *loop_buf = kmap_atomic(loop_page, KM_USER1) + loop_off;
+	char *raw_buf = kmap_atomic(raw_page) + raw_off;
+	char *loop_buf = kmap_atomic(loop_page) + loop_off;
 	char *in, *out, *key;
 	int i, keysize;
 
@@ -131,8 +131,8 @@ static int transfer_xor(struct loop_device *lo, int cmd,
 	for (i = 0; i < size; i++)
 		*out++ = *in++ ^ key[(i & 511) % keysize];
 
-	kunmap_atomic(loop_buf, KM_USER1);
-	kunmap_atomic(raw_buf, KM_USER0);
+	kunmap_atomic(loop_buf);
+	kunmap_atomic(raw_buf);
 	cond_resched();
 	return 0;
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a63b0a2..4e06fa3 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -987,14 +987,14 @@ static void pkt_copy_bio_data(struct bio *src_bio, int seg, int offs, struct pag
 
 	while (copy_size > 0) {
 		struct bio_vec *src_bvl = bio_iovec_idx(src_bio, seg);
-		void *vfrom = kmap_atomic(src_bvl->bv_page, KM_USER0) +
+		void *vfrom = kmap_atomic(src_bvl->bv_page) +
 			src_bvl->bv_offset + offs;
 		void *vto = page_address(dst_page) + dst_offs;
 		int len = min_t(int, copy_size, src_bvl->bv_len - offs);
 
 		BUG_ON(len < 0);
 		memcpy(vto, vfrom, len);
-		kunmap_atomic(vfrom, KM_USER0);
+		kunmap_atomic(vfrom);
 
 		seg++;
 		offs = 0;
@@ -1019,10 +1019,10 @@ static void pkt_make_local_copy(struct packet_data *pkt, struct bio_vec *bvec)
 	offs = 0;
 	for (f = 0; f < pkt->frames; f++) {
 		if (bvec[f].bv_page != pkt->pages[p]) {
-			void *vfrom = kmap_atomic(bvec[f].bv_page, KM_USER0) + bvec[f].bv_offset;
+			void *vfrom = kmap_atomic(bvec[f].bv_page) + bvec[f].bv_offset;
 			void *vto = page_address(pkt->pages[p]) + offs;
 			memcpy(vto, vfrom, CD_FRAMESIZE);
-			kunmap_atomic(vfrom, KM_USER0);
+			kunmap_atomic(vfrom);
 			bvec[f].bv_page = pkt->pages[p];
 			bvec[f].bv_offset = offs;
 		} else {
-- 
1.7.4.4

