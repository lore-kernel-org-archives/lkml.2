Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492Ab1A3Jrr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 04:47:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1A3Jrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 04:47:43 -0500
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Amerigo Wang <amwang@redhat.com>
Subject: [PATCH 3/4] kmap_atomic: Remove some function parameters of enum km_type
Date: Sun, 30 Jan 2011 17:46:59 +0800
Message-Id: <1296380820-8801-3-git-send-email-amwang@redhat.com>
In-Reply-To: <1296380820-8801-1-git-send-email-amwang@redhat.com>
References: <1296380820-8801-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although the code can be compiled successfully, but there
are still some unused function parameters of enum km_type.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>

---
 drivers/block/drbd/drbd_bitmap.c  |   42 ++++++++++++++++++------------------
 drivers/staging/hv/netvsc_drv.c   |    5 +--
 drivers/staging/hv/rndis_filter.c |    5 +--
 drivers/staging/hv/storvsc_drv.c  |   11 ++++-----
 drivers/staging/zram/xvmalloc.c   |   34 +++++++++++++++---------------
 net/rds/ib_recv.c                 |    3 +-
 net/rds/iw_recv.c                 |    3 +-
 net/rds/loop.c                    |    2 +-
 net/rds/rds.h                     |    2 +-
 net/rds/recv.c                    |    2 +-
 net/rds/tcp_recv.c                |   11 +++------
 11 files changed, 56 insertions(+), 64 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index e3c8224..a3640cf 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -85,7 +85,7 @@ struct drbd_bitmap {
 #define BM_P_VMALLOCED  2
 
 static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
-			       unsigned long e, int val, const enum km_type km);
+			       unsigned long e, int val);
 
 static int bm_is_locked(struct drbd_bitmap *b)
 {
@@ -155,7 +155,7 @@ void drbd_bm_unlock(struct drbd_conf *mdev)
 }
 
 /* word offset to long pointer */
-static unsigned long *__bm_map_paddr(struct drbd_bitmap *b, unsigned long offset, const enum km_type km)
+static unsigned long *__bm_map_paddr(struct drbd_bitmap *b, unsigned long offset)
 {
 	struct page *page;
 	unsigned long page_nr;
@@ -170,17 +170,17 @@ static unsigned long *__bm_map_paddr(struct drbd_bitmap *b, unsigned long offset
 
 static unsigned long * bm_map_paddr(struct drbd_bitmap *b, unsigned long offset)
 {
-	return __bm_map_paddr(b, offset, KM_IRQ1);
+	return __bm_map_paddr(b, offset);
 }
 
-static void __bm_unmap(unsigned long *p_addr, const enum km_type km)
+static void __bm_unmap(unsigned long *p_addr)
 {
 	kunmap_atomic(p_addr);
 };
 
 static void bm_unmap(unsigned long *p_addr)
 {
-	return __bm_unmap(p_addr, KM_IRQ1);
+	return __bm_unmap(p_addr);
 }
 
 /* long word offset of _bitmap_ sector */
@@ -379,7 +379,7 @@ static unsigned long __bm_count_bits(struct drbd_bitmap *b, const int swap_endia
 
 	while (offset < b->bm_words) {
 		i = do_now = min_t(size_t, b->bm_words-offset, LWPP);
-		p_addr = __bm_map_paddr(b, offset, KM_USER0);
+		p_addr = __bm_map_paddr(b, offset);
 		bm = p_addr + MLPP(offset);
 		while (i--) {
 #ifndef __LITTLE_ENDIAN
@@ -388,7 +388,7 @@ static unsigned long __bm_count_bits(struct drbd_bitmap *b, const int swap_endia
 #endif
 			bits += hweight_long(*bm++);
 		}
-		__bm_unmap(p_addr, KM_USER0);
+		__bm_unmap(p_addr);
 		offset += do_now;
 		cond_resched();
 	}
@@ -934,7 +934,7 @@ int drbd_bm_write_sect(struct drbd_conf *mdev, unsigned long enr) __must_hold(lo
  */
 #define BPP_MASK ((1UL << (PAGE_SHIFT+3)) - 1)
 static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
-	const int find_zero_bit, const enum km_type km)
+	const int find_zero_bit)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned long i = -1UL;
@@ -948,14 +948,14 @@ static unsigned long __bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo,
 			unsigned long offset;
 			bit_offset = bm_fo & ~BPP_MASK; /* bit offset of the page */
 			offset = bit_offset >> LN2_BPL;    /* word offset of the page */
-			p_addr = __bm_map_paddr(b, offset, km);
+			p_addr = __bm_map_paddr(b, offset);
 
 			if (find_zero_bit)
 				i = find_next_zero_bit(p_addr, PAGE_SIZE*8, bm_fo & BPP_MASK);
 			else
 				i = find_next_bit(p_addr, PAGE_SIZE*8, bm_fo & BPP_MASK);
 
-			__bm_unmap(p_addr, km);
+			__bm_unmap(p_addr);
 			if (i < PAGE_SIZE*8) {
 				i = bit_offset + i;
 				if (i >= b->bm_bits)
@@ -983,7 +983,7 @@ static unsigned long bm_find_next(struct drbd_conf *mdev,
 	if (bm_is_locked(b))
 		bm_print_lock_info(mdev);
 
-	i = __bm_find_next(mdev, bm_fo, find_zero_bit, KM_IRQ1);
+	i = __bm_find_next(mdev, bm_fo, find_zero_bit);
 
 	spin_unlock_irq(&b->bm_lock);
 	return i;
@@ -1007,13 +1007,13 @@ unsigned long drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo
 unsigned long _drbd_bm_find_next(struct drbd_conf *mdev, unsigned long bm_fo)
 {
 	/* WARN_ON(!bm_is_locked(mdev)); */
-	return __bm_find_next(mdev, bm_fo, 0, KM_USER1);
+	return __bm_find_next(mdev, bm_fo, 0);
 }
 
 unsigned long _drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_fo)
 {
 	/* WARN_ON(!bm_is_locked(mdev)); */
-	return __bm_find_next(mdev, bm_fo, 1, KM_USER1);
+	return __bm_find_next(mdev, bm_fo, 1);
 }
 
 /* returns number of bits actually changed.
@@ -1023,7 +1023,7 @@ unsigned long _drbd_bm_find_next_zero(struct drbd_conf *mdev, unsigned long bm_f
  * expected to be called for only a few bits (e - s about BITS_PER_LONG).
  * Must hold bitmap lock already. */
 static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
-	unsigned long e, int val, const enum km_type km)
+	unsigned long e, int val)
 {
 	struct drbd_bitmap *b = mdev->bitmap;
 	unsigned long *p_addr = NULL;
@@ -1041,8 +1041,8 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 		unsigned long page_nr = offset >> (PAGE_SHIFT - LN2_BPL + 3);
 		if (page_nr != last_page_nr) {
 			if (p_addr)
-				__bm_unmap(p_addr, km);
-			p_addr = __bm_map_paddr(b, offset, km);
+				__bm_unmap(p_addr);
+			p_addr = __bm_map_paddr(b, offset);
 			last_page_nr = page_nr;
 		}
 		if (val)
@@ -1051,7 +1051,7 @@ static int __bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 			c -= (0 != __test_and_clear_bit(bitnr & BPP_MASK, p_addr));
 	}
 	if (p_addr)
-		__bm_unmap(p_addr, km);
+		__bm_unmap(p_addr);
 	b->bm_set += c;
 	return c;
 }
@@ -1074,7 +1074,7 @@ static int bm_change_bits_to(struct drbd_conf *mdev, const unsigned long s,
 	if (bm_is_locked(b))
 		bm_print_lock_info(mdev);
 
-	c = __bm_change_bits_to(mdev, s, e, val, KM_IRQ1);
+	c = __bm_change_bits_to(mdev, s, e, val);
 
 	spin_unlock_irqrestore(&b->bm_lock, flags);
 	return c;
@@ -1132,7 +1132,7 @@ void _drbd_bm_set_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 
 	if (e - s <= 3*BITS_PER_LONG) {
 		/* don't bother; el and sl may even be wrong. */
-		__bm_change_bits_to(mdev, s, e, 1, KM_USER0);
+		__bm_change_bits_to(mdev, s, e, 1);
 		return;
 	}
 
@@ -1140,7 +1140,7 @@ void _drbd_bm_set_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 
 	/* bits filling the current long */
 	if (sl)
-		__bm_change_bits_to(mdev, s, sl-1, 1, KM_USER0);
+		__bm_change_bits_to(mdev, s, sl-1, 1);
 
 	first_page = sl >> (3 + PAGE_SHIFT);
 	last_page = el >> (3 + PAGE_SHIFT);
@@ -1167,7 +1167,7 @@ void _drbd_bm_set_bits(struct drbd_conf *mdev, const unsigned long s, const unsi
 	 * it would trigger an assert in __bm_change_bits_to()
 	 */
 	if (el <= e)
-		__bm_change_bits_to(mdev, el, e, 1, KM_USER0);
+		__bm_change_bits_to(mdev, el, e, 1);
 }
 
 /* returns bit state
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 0147b40..df8f771 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -277,8 +277,7 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 	 * hv_netvsc_packet cannot be deallocated
 	 */
 	for (i = 0; i < packet->page_buf_cnt; i++) {
-		data = kmap_atomic(pfn_to_page(packet->page_buf[i].Pfn),
-					       KM_IRQ1);
+		data = kmap_atomic(pfn_to_page(packet->page_buf[i].Pfn));
 		data = (void *)(unsigned long)data +
 				packet->page_buf[i].Offset;
 
@@ -286,7 +285,7 @@ static int netvsc_recv_callback(struct hv_device *device_obj,
 		       packet->page_buf[i].Length);
 
 		kunmap_atomic((void *)((unsigned long)data -
-				       packet->page_buf[i].Offset), KM_IRQ1);
+				       packet->page_buf[i].Offset));
 	}
 
 	local_irq_restore(flags);
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index e5ac8ad..69ae0a1 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -406,7 +406,7 @@ static int rndis_filter_receive(struct hv_device *dev,
 	}
 
 	rndis_hdr = (struct rndis_message *)kmap_atomic(
-			pfn_to_page(pkt->page_buf[0].Pfn), KM_IRQ0);
+			pfn_to_page(pkt->page_buf[0].Pfn));
 
 	rndis_hdr = (void *)((unsigned long)rndis_hdr +
 			pkt->page_buf[0].Offset);
@@ -419,8 +419,7 @@ static int rndis_filter_receive(struct hv_device *dev,
 	 * */
 #if 0
 	if (pkt->total_data_buflen != rndis_hdr->msg_len) {
-		kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset,
-			      KM_IRQ0);
+		kunmap_atomic(rndis_hdr - pkt->page_buf[0].Offset);
 
 		DPRINT_ERR(NETVSC, "invalid rndis message? (expected %u "
 			   "bytes got %u)...dropping this message!",
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index dd0245c..7bec9ed 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -486,8 +486,8 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-				KM_IRQ0) + orig_sgl[i].offset;
+		src_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
+				+ orig_sgl[i].offset;
 		src = src_addr;
 		srclen = orig_sgl[i].length;
 
@@ -548,8 +548,8 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 	local_irq_save(flags);
 
 	for (i = 0; i < orig_sgl_count; i++) {
-		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])),
-					KM_IRQ0) + orig_sgl[i].offset;
+		dest_addr = (unsigned long)kmap_atomic(sg_page((&orig_sgl[i])))
+					+ orig_sgl[i].offset;
 		dest = dest_addr;
 		destlen = orig_sgl[i].length;
 		/* ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE); */
@@ -583,8 +583,7 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 			}
 		}
 
-		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset),
-			      KM_IRQ0);
+		kunmap_atomic((void *)(dest_addr - orig_sgl[i].offset));
 	}
 
 	local_irq_restore(flags);
diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index a005e52..bd08bd1 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -50,7 +50,7 @@ static void clear_flag(struct block_header *block, enum blockflags flag)
  * This is called from xv_malloc/xv_free path, so it
  * needs to be fast.
  */
-static void *get_ptr_atomic(struct page *page, u16 offset, enum km_type type)
+static void *get_ptr_atomic(struct page *page, u16 offset)
 {
 	unsigned char *base;
 
@@ -58,7 +58,7 @@ static void *get_ptr_atomic(struct page *page, u16 offset, enum km_type type)
 	return base + offset;
 }
 
-static void put_ptr_atomic(void *ptr, enum km_type type)
+static void put_ptr_atomic(void *ptr)
 {
 	kunmap_atomic(ptr);
 }
@@ -196,10 +196,10 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
 
 	if (block->link.next_page) {
 		nextblock = get_ptr_atomic(block->link.next_page,
-					block->link.next_offset, KM_USER1);
+					block->link.next_offset);
 		nextblock->link.prev_page = page;
 		nextblock->link.prev_offset = offset;
-		put_ptr_atomic(nextblock, KM_USER1);
+		put_ptr_atomic(nextblock);
 	}
 
 	__set_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
@@ -231,10 +231,10 @@ static void remove_block_head(struct xv_pool *pool,
 		 * sanity, lets do it.
 		 */
 		tmpblock = get_ptr_atomic(pool->freelist[slindex].page,
-				pool->freelist[slindex].offset, KM_USER1);
+				pool->freelist[slindex].offset);
 		tmpblock->link.prev_page = NULL;
 		tmpblock->link.prev_offset = 0;
-		put_ptr_atomic(tmpblock, KM_USER1);
+		put_ptr_atomic(tmpblock);
 	}
 }
 
@@ -257,18 +257,18 @@ static void remove_block(struct xv_pool *pool, struct page *page, u32 offset,
 
 	if (block->link.prev_page) {
 		tmpblock = get_ptr_atomic(block->link.prev_page,
-				block->link.prev_offset, KM_USER1);
+				block->link.prev_offset);
 		tmpblock->link.next_page = block->link.next_page;
 		tmpblock->link.next_offset = block->link.next_offset;
-		put_ptr_atomic(tmpblock, KM_USER1);
+		put_ptr_atomic(tmpblock);
 	}
 
 	if (block->link.next_page) {
 		tmpblock = get_ptr_atomic(block->link.next_page,
-				block->link.next_offset, KM_USER1);
+				block->link.next_offset);
 		tmpblock->link.prev_page = block->link.prev_page;
 		tmpblock->link.prev_offset = block->link.prev_offset;
-		put_ptr_atomic(tmpblock, KM_USER1);
+		put_ptr_atomic(tmpblock);
 	}
 }
 
@@ -287,7 +287,7 @@ static int grow_pool(struct xv_pool *pool, gfp_t flags)
 	stat_inc(&pool->total_pages);
 
 	spin_lock(&pool->lock);
-	block = get_ptr_atomic(page, 0, KM_USER0);
+	block = get_ptr_atomic(page, 0);
 
 	block->size = PAGE_SIZE - XV_ALIGN;
 	set_flag(block, BLOCK_FREE);
@@ -296,7 +296,7 @@ static int grow_pool(struct xv_pool *pool, gfp_t flags)
 
 	insert_block(pool, page, 0, block);
 
-	put_ptr_atomic(block, KM_USER0);
+	put_ptr_atomic(block);
 	spin_unlock(&pool->lock);
 
 	return 0;
@@ -376,7 +376,7 @@ int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
 		return -ENOMEM;
 	}
 
-	block = get_ptr_atomic(*page, *offset, KM_USER0);
+	block = get_ptr_atomic(*page, *offset);
 
 	remove_block_head(pool, block, index);
 
@@ -406,7 +406,7 @@ int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
 	block->size = origsize;
 	clear_flag(block, BLOCK_FREE);
 
-	put_ptr_atomic(block, KM_USER0);
+	put_ptr_atomic(block);
 	spin_unlock(&pool->lock);
 
 	*offset += XV_ALIGN;
@@ -426,7 +426,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 
 	spin_lock(&pool->lock);
 
-	page_start = get_ptr_atomic(page, 0, KM_USER0);
+	page_start = get_ptr_atomic(page, 0);
 	block = (struct block_header *)((char *)page_start + offset);
 
 	/* Catch double free bugs */
@@ -468,7 +468,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 
 	/* No used objects in this page. Free it. */
 	if (block->size == PAGE_SIZE - XV_ALIGN) {
-		put_ptr_atomic(page_start, KM_USER0);
+		put_ptr_atomic(page_start);
 		spin_unlock(&pool->lock);
 
 		__free_page(page);
@@ -486,7 +486,7 @@ void xv_free(struct xv_pool *pool, struct page *page, u32 offset)
 		set_blockprev(tmpblock, offset);
 	}
 
-	put_ptr_atomic(page_start, KM_USER0);
+	put_ptr_atomic(page_start);
 	spin_unlock(&pool->lock);
 }
 
diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 8981665..744a00d 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -919,8 +919,7 @@ static void rds_ib_process_recv(struct rds_connection *conn,
 			rds_ib_cong_recv(conn, ibinc);
 		else {
 			rds_recv_incoming(conn, conn->c_faddr, conn->c_laddr,
-					  &ibinc->ii_inc, GFP_ATOMIC,
-					  KM_SOFTIRQ0);
+					  &ibinc->ii_inc, GFP_ATOMIC);
 			state->ack_next = be64_to_cpu(hdr->h_sequence);
 			state->ack_next_valid = 1;
 		}
diff --git a/net/rds/iw_recv.c b/net/rds/iw_recv.c
index 3b53f34..0bd9b5e 100644
--- a/net/rds/iw_recv.c
+++ b/net/rds/iw_recv.c
@@ -754,8 +754,7 @@ static void rds_iw_process_recv(struct rds_connection *conn,
 			rds_iw_cong_recv(conn, iwinc);
 		else {
 			rds_recv_incoming(conn, conn->c_faddr, conn->c_laddr,
-					  &iwinc->ii_inc, GFP_ATOMIC,
-					  KM_SOFTIRQ0);
+					  &iwinc->ii_inc, GFP_ATOMIC);
 			state->ack_next = be64_to_cpu(hdr->h_sequence);
 			state->ack_next_valid = 1;
 		}
diff --git a/net/rds/loop.c b/net/rds/loop.c
index aeec1d4..49fb963 100644
--- a/net/rds/loop.c
+++ b/net/rds/loop.c
@@ -74,7 +74,7 @@ static int rds_loop_xmit(struct rds_connection *conn, struct rds_message *rm,
 	rds_message_addref(rm);
 
 	rds_recv_incoming(conn, conn->c_laddr, conn->c_faddr, &rm->m_inc,
-			  GFP_KERNEL, KM_USER0);
+			  GFP_KERNEL);
 
 	rds_send_drop_acked(conn, be64_to_cpu(rm->m_inc.i_hdr.h_sequence),
 			    NULL);
diff --git a/net/rds/rds.h b/net/rds/rds.h
index 9542449..ac8ab10 100644
--- a/net/rds/rds.h
+++ b/net/rds/rds.h
@@ -705,7 +705,7 @@ void rds_inc_init(struct rds_incoming *inc, struct rds_connection *conn,
 		  __be32 saddr);
 void rds_inc_put(struct rds_incoming *inc);
 void rds_recv_incoming(struct rds_connection *conn, __be32 saddr, __be32 daddr,
-		       struct rds_incoming *inc, gfp_t gfp, enum km_type km);
+		       struct rds_incoming *inc, gfp_t gfp);
 int rds_recvmsg(struct kiocb *iocb, struct socket *sock, struct msghdr *msg,
 		size_t size, int msg_flags);
 void rds_clear_recv_queue(struct rds_sock *rs);
diff --git a/net/rds/recv.c b/net/rds/recv.c
index 596689e..24de92c 100644
--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -154,7 +154,7 @@ static void rds_recv_incoming_exthdrs(struct rds_incoming *inc, struct rds_sock
  * tell us which roles the addrs in the conn are playing for this message.
  */
 void rds_recv_incoming(struct rds_connection *conn, __be32 saddr, __be32 daddr,
-		       struct rds_incoming *inc, gfp_t gfp, enum km_type km)
+		       struct rds_incoming *inc, gfp_t gfp)
 {
 	struct rds_sock *rs = NULL;
 	struct sock *sk;
diff --git a/net/rds/tcp_recv.c b/net/rds/tcp_recv.c
index 78205e2..6243258 100644
--- a/net/rds/tcp_recv.c
+++ b/net/rds/tcp_recv.c
@@ -169,7 +169,6 @@ static void rds_tcp_cong_recv(struct rds_connection *conn,
 struct rds_tcp_desc_arg {
 	struct rds_connection *conn;
 	gfp_t gfp;
-	enum km_type km;
 };
 
 static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
@@ -255,7 +254,7 @@ static int rds_tcp_data_recv(read_descriptor_t *desc, struct sk_buff *skb,
 			else
 				rds_recv_incoming(conn, conn->c_faddr,
 						  conn->c_laddr, &tinc->ti_inc,
-						  arg->gfp, arg->km);
+						  arg->gfp);
 
 			tc->t_tinc_hdr_rem = sizeof(struct rds_header);
 			tc->t_tinc_data_rem = 0;
@@ -272,8 +271,7 @@ out:
 }
 
 /* the caller has to hold the sock lock */
-static int rds_tcp_read_sock(struct rds_connection *conn, gfp_t gfp,
-			     enum km_type km)
+static int rds_tcp_read_sock(struct rds_connection *conn, gfp_t gfp)
 {
 	struct rds_tcp_connection *tc = conn->c_transport_data;
 	struct socket *sock = tc->t_sock;
@@ -283,7 +281,6 @@ static int rds_tcp_read_sock(struct rds_connection *conn, gfp_t gfp,
 	/* It's like glib in the kernel! */
 	arg.conn = conn;
 	arg.gfp = gfp;
-	arg.km = km;
 	desc.arg.data = &arg;
 	desc.error = 0;
 	desc.count = 1; /* give more than one skb per call */
@@ -311,7 +308,7 @@ int rds_tcp_recv(struct rds_connection *conn)
 	rdsdebug("recv worker conn %p tc %p sock %p\n", conn, tc, sock);
 
 	lock_sock(sock->sk);
-	ret = rds_tcp_read_sock(conn, GFP_KERNEL, KM_USER0);
+	ret = rds_tcp_read_sock(conn, GFP_KERNEL);
 	release_sock(sock->sk);
 
 	return ret;
@@ -336,7 +333,7 @@ void rds_tcp_data_ready(struct sock *sk, int bytes)
 	ready = tc->t_orig_data_ready;
 	rds_tcp_stats_inc(s_tcp_data_ready_calls);
 
-	if (rds_tcp_read_sock(conn, GFP_ATOMIC, KM_SOFTIRQ0) == -ENOMEM)
+	if (rds_tcp_read_sock(conn, GFP_ATOMIC) == -ENOMEM)
 		queue_delayed_work(rds_wq, &conn->c_recv_w, 0);
 out:
 	read_unlock_bh(&sk->sk_callback_lock);
-- 
1.7.3.5

