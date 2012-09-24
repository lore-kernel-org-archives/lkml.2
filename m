Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab2IXWf5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 18:35:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37645 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2IXWft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 18:35:49 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v3 16/26] block: Add bio_copy_data()
Date: Mon, 24 Sep 2012 15:34:56 -0700
Message-Id: <1348526106-17074-17-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348526106-17074-1-git-send-email-koverstreet@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This gets open coded quite a bit and it's tricky to get right, so make a
generic version and convert some existing users over to it instead.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c            | 70 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h |  2 ++
 2 files changed, 72 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index 9a30dcf..d433825 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -827,6 +827,76 @@ void bio_advance(struct bio *bio, unsigned bytes)
 }
 EXPORT_SYMBOL(bio_advance);
 
+/**
+ * bio_copy_data - copy contents of data buffers from one chain of bios to
+ * another
+ * @src: source bio list
+ * @dst: destination bio list
+ *
+ * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
+ * @src and @dst as linked lists of bios.
+ *
+ * Stops when it reaches the end of either @src or @dst - that is, copies
+ * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
+ */
+void bio_copy_data(struct bio *dst, struct bio *src)
+{
+	struct bio_vec *src_bv, *dst_bv;
+	unsigned src_offset, dst_offset, bytes;
+	void *src_p, *dst_p;
+
+	src_bv = bio_iovec(src);
+	dst_bv = bio_iovec(dst);
+
+	src_offset = src_bv->bv_offset;
+	dst_offset = dst_bv->bv_offset;
+
+	while (1) {
+		if (src_offset == src_bv->bv_offset + src_bv->bv_len) {
+			src_bv++;
+			if (src_bv == bio_iovec_idx(src, src->bi_vcnt)) {
+				src = src->bi_next;
+				if (!src)
+					break;
+
+				src_bv = bio_iovec(src);
+			}
+
+			src_offset = src_bv->bv_offset;
+		}
+
+		if (dst_offset == dst_bv->bv_offset + dst_bv->bv_len) {
+			dst_bv++;
+			if (dst_bv == bio_iovec_idx(dst, dst->bi_vcnt)) {
+				dst = dst->bi_next;
+				if (!dst)
+					break;
+
+				dst_bv = bio_iovec(dst);
+			}
+
+			dst_offset = dst_bv->bv_offset;
+		}
+
+		bytes = min(dst_bv->bv_offset + dst_bv->bv_len - dst_offset,
+			    src_bv->bv_offset + src_bv->bv_len - src_offset);
+
+		src_p = kmap_atomic(src_bv->bv_page);
+		dst_p = kmap_atomic(dst_bv->bv_page);
+
+		memcpy(dst_p + dst_bv->bv_offset,
+		       src_p + src_bv->bv_offset,
+		       bytes);
+
+		kunmap_atomic(dst_p);
+		kunmap_atomic(src_p);
+
+		src_offset += bytes;
+		dst_offset += bytes;
+	}
+}
+EXPORT_SYMBOL(bio_copy_data);
+
 struct bio_map_data {
 	struct bio_vec *iovecs;
 	struct sg_iovec *sgvecs;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 3bf696b..467e101 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -289,6 +289,8 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
 }
 #endif
 
+extern void bio_copy_data(struct bio *dst, struct bio *src);
+
 extern struct bio *bio_copy_user(struct request_queue *, struct rq_map_data *,
 				 unsigned long, unsigned int, int, gfp_t);
 extern struct bio *bio_copy_user_iov(struct request_queue *,
-- 
1.7.12

