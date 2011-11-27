Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab1K0FfF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:35:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754966Ab1K0FfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:35:00 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Benjamin LaHaise <bcrl@kvack.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Tao Ma <boyu.mt@taobao.com>,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 29/62] fs: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:09 +0800
Message-Id: <1322371662-26166-30-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 fs/aio.c            |   30 +++++++++++++++---------------
 fs/bio-integrity.c  |   10 +++++-----
 fs/exec.c           |    4 ++--
 fs/namei.c          |    4 ++--
 fs/pipe.c           |    8 ++++----
 fs/splice.c         |    7 ++-----
 include/linux/bio.h |    8 ++++----
 7 files changed, 34 insertions(+), 37 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 78c514c..34e0d9f 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -160,7 +160,7 @@ static int aio_setup_ring(struct kioctx *ctx)
 
 	info->nr = nr_events;		/* trusted copy */
 
-	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
+	ring = kmap_atomic(info->ring_pages[0]);
 	ring->nr = nr_events;	/* user copy */
 	ring->id = ctx->user_id;
 	ring->head = ring->tail = 0;
@@ -168,32 +168,32 @@ static int aio_setup_ring(struct kioctx *ctx)
 	ring->compat_features = AIO_RING_COMPAT_FEATURES;
 	ring->incompat_features = AIO_RING_INCOMPAT_FEATURES;
 	ring->header_length = sizeof(struct aio_ring);
-	kunmap_atomic(ring, KM_USER0);
+	kunmap_atomic(ring);
 
 	return 0;
 }
 
 
 /* aio_ring_event: returns a pointer to the event at the given index from
- * kmap_atomic(, km).  Release the pointer with put_aio_ring_event();
+ * kmap_atomic().  Release the pointer with put_aio_ring_event();
  */
 #define AIO_EVENTS_PER_PAGE	(PAGE_SIZE / sizeof(struct io_event))
 #define AIO_EVENTS_FIRST_PAGE	((PAGE_SIZE - sizeof(struct aio_ring)) / sizeof(struct io_event))
 #define AIO_EVENTS_OFFSET	(AIO_EVENTS_PER_PAGE - AIO_EVENTS_FIRST_PAGE)
 
-#define aio_ring_event(info, nr, km) ({					\
+#define aio_ring_event(info, nr) ({					\
 	unsigned pos = (nr) + AIO_EVENTS_OFFSET;			\
 	struct io_event *__event;					\
 	__event = kmap_atomic(						\
-			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE], km); \
+			(info)->ring_pages[pos / AIO_EVENTS_PER_PAGE]); \
 	__event += pos % AIO_EVENTS_PER_PAGE;				\
 	__event;							\
 })
 
-#define put_aio_ring_event(event, km) do {	\
+#define put_aio_ring_event(event) do {		\
 	struct io_event *__event = (event);	\
 	(void)__event;				\
-	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK), km); \
+	kunmap_atomic((void *)((unsigned long)__event & PAGE_MASK)); \
 } while(0)
 
 static void ctx_rcu_free(struct rcu_head *head)
@@ -1012,10 +1012,10 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	if (kiocbIsCancelled(iocb))
 		goto put_rq;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_IRQ1);
+	ring = kmap_atomic(info->ring_pages[0]);
 
 	tail = info->tail;
-	event = aio_ring_event(info, tail, KM_IRQ0);
+	event = aio_ring_event(info, tail);
 	if (++tail >= info->nr)
 		tail = 0;
 
@@ -1036,8 +1036,8 @@ int aio_complete(struct kiocb *iocb, long res, long res2)
 	info->tail = tail;
 	ring->tail = tail;
 
-	put_aio_ring_event(event, KM_IRQ0);
-	kunmap_atomic(ring, KM_IRQ1);
+	put_aio_ring_event(event);
+	kunmap_atomic(ring);
 
 	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
 
@@ -1082,7 +1082,7 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 	unsigned long head;
 	int ret = 0;
 
-	ring = kmap_atomic(info->ring_pages[0], KM_USER0);
+	ring = kmap_atomic(info->ring_pages[0]);
 	dprintk("in aio_read_evt h%lu t%lu m%lu\n",
 		 (unsigned long)ring->head, (unsigned long)ring->tail,
 		 (unsigned long)ring->nr);
@@ -1094,18 +1094,18 @@ static int aio_read_evt(struct kioctx *ioctx, struct io_event *ent)
 
 	head = ring->head % info->nr;
 	if (head != ring->tail) {
-		struct io_event *evp = aio_ring_event(info, head, KM_USER1);
+		struct io_event *evp = aio_ring_event(info, head);
 		*ent = *evp;
 		head = (head + 1) % info->nr;
 		smp_mb(); /* finish reading the event before updatng the head */
 		ring->head = head;
 		ret = 1;
-		put_aio_ring_event(evp, KM_USER1);
+		put_aio_ring_event(evp);
 	}
 	spin_unlock(&info->ring_lock);
 
 out:
-	kunmap_atomic(ring, KM_USER0);
+	kunmap_atomic(ring);
 	dprintk("leaving aio_read_evt: %d  h%lu t%lu\n", ret,
 		 (unsigned long)ring->head, (unsigned long)ring->tail);
 	return ret;
diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
index c2183f3..e85c04b 100644
--- a/fs/bio-integrity.c
+++ b/fs/bio-integrity.c
@@ -357,7 +357,7 @@ static void bio_integrity_generate(struct bio *bio)
 	bix.sector_size = bi->sector_size;
 
 	bio_for_each_segment(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page, KM_USER0);
+		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
@@ -371,7 +371,7 @@ static void bio_integrity_generate(struct bio *bio)
 		total += sectors * bi->tuple_size;
 		BUG_ON(total > bio->bi_integrity->bip_size);
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 }
 
@@ -498,7 +498,7 @@ static int bio_integrity_verify(struct bio *bio)
 	bix.sector_size = bi->sector_size;
 
 	bio_for_each_segment(bv, bio, i) {
-		void *kaddr = kmap_atomic(bv->bv_page, KM_USER0);
+		void *kaddr = kmap_atomic(bv->bv_page);
 		bix.data_buf = kaddr + bv->bv_offset;
 		bix.data_size = bv->bv_len;
 		bix.prot_buf = prot_buf;
@@ -507,7 +507,7 @@ static int bio_integrity_verify(struct bio *bio)
 		ret = bi->verify_fn(&bix);
 
 		if (ret) {
-			kunmap_atomic(kaddr, KM_USER0);
+			kunmap_atomic(kaddr);
 			return ret;
 		}
 
@@ -517,7 +517,7 @@ static int bio_integrity_verify(struct bio *bio)
 		total += sectors * bi->tuple_size;
 		BUG_ON(total > bio->bi_integrity->bip_size);
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 	}
 
 	return ret;
diff --git a/fs/exec.c b/fs/exec.c
index 3625464..ca141db 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1334,13 +1334,13 @@ int remove_arg_zero(struct linux_binprm *bprm)
 			ret = -EFAULT;
 			goto out;
 		}
-		kaddr = kmap_atomic(page, KM_USER0);
+		kaddr = kmap_atomic(page);
 
 		for (; offset < PAGE_SIZE && kaddr[offset];
 				offset++, bprm->p++)
 			;
 
-		kunmap_atomic(kaddr, KM_USER0);
+		kunmap_atomic(kaddr);
 		put_arg_page(page);
 
 		if (offset == PAGE_SIZE)
diff --git a/fs/namei.c b/fs/namei.c
index 5008f01..c02b2c6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3346,9 +3346,9 @@ retry:
 	if (err)
 		goto fail;
 
-	kaddr = kmap_atomic(page, KM_USER0);
+	kaddr = kmap_atomic(page);
 	memcpy(kaddr, symname, len-1);
-	kunmap_atomic(kaddr, KM_USER0);
+	kunmap_atomic(kaddr);
 
 	err = pagecache_write_end(NULL, mapping, 0, len-1, len-1,
 							page, fsdata);
diff --git a/fs/pipe.c b/fs/pipe.c
index 4065f07..2c59dfa 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -230,7 +230,7 @@ void *generic_pipe_buf_map(struct pipe_inode_info *pipe,
 {
 	if (atomic) {
 		buf->flags |= PIPE_BUF_FLAG_ATOMIC;
-		return kmap_atomic(buf->page, KM_USER0);
+		return kmap_atomic(buf->page);
 	}
 
 	return kmap(buf->page);
@@ -251,7 +251,7 @@ void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
 {
 	if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
 		buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
-		kunmap_atomic(map_data, KM_USER0);
+		kunmap_atomic(map_data);
 	} else
 		kunmap(buf->page);
 }
@@ -565,14 +565,14 @@ redo1:
 			iov_fault_in_pages_read(iov, chars);
 redo2:
 			if (atomic)
-				src = kmap_atomic(page, KM_USER0);
+				src = kmap_atomic(page);
 			else
 				src = kmap(page);
 
 			error = pipe_iov_copy_from_user(src, iov, chars,
 							atomic);
 			if (atomic)
-				kunmap_atomic(src, KM_USER0);
+				kunmap_atomic(src);
 			else
 				kunmap(page);
 
diff --git a/fs/splice.c b/fs/splice.c
index fa2defa..da01377 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -738,15 +738,12 @@ int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		goto out;
 
 	if (buf->page != page) {
-		/*
-		 * Careful, ->map() uses KM_USER0!
-		 */
 		char *src = buf->ops->map(pipe, buf, 1);
-		char *dst = kmap_atomic(page, KM_USER1);
+		char *dst = kmap_atomic(page);
 
 		memcpy(dst + offset, src + buf->offset, this_len);
 		flush_dcache_page(page);
-		kunmap_atomic(dst, KM_USER1);
+		kunmap_atomic(dst);
 		buf->ops->unmap(pipe, buf, src);
 	}
 	ret = pagecache_write_end(file, mapping, sd->pos, this_len, this_len,
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 847994a..6ed3ba4 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -101,10 +101,10 @@ static inline int bio_has_allocated_vec(struct bio *bio)
  * I/O completely on that queue (see ide-dma for example)
  */
 #define __bio_kmap_atomic(bio, idx, kmtype)				\
-	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page, kmtype) +	\
+	(kmap_atomic(bio_iovec_idx((bio), (idx))->bv_page) +	\
 		bio_iovec_idx((bio), (idx))->bv_offset)
 
-#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic(addr, kmtype)
+#define __bio_kunmap_atomic(addr, kmtype) kunmap_atomic(addr)
 
 /*
  * merge helpers etc
@@ -317,7 +317,7 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	 * balancing is a lot nicer this way
 	 */
 	local_irq_save(*flags);
-	addr = (unsigned long) kmap_atomic(bvec->bv_page, KM_BIO_SRC_IRQ);
+	addr = (unsigned long) kmap_atomic(bvec->bv_page);
 
 	BUG_ON(addr & ~PAGE_MASK);
 
@@ -328,7 +328,7 @@ static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-	kunmap_atomic((void *) ptr, KM_BIO_SRC_IRQ);
+	kunmap_atomic((void *) ptr);
 	local_irq_restore(*flags);
 }
 
-- 
1.7.4.4

