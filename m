Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab2JOUJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:09:52 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:42248 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab2JOUJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:09:44 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com
Cc: Kent Overstreet <koverstreet@google.com>, tj@kernel.org, axboe@kernel.dk,
        neilb@suse.de, vgoyal@redhat.com
Subject: [PATCH v4 01/24] block: Add bio_advance()
Date: Mon, 15 Oct 2012 13:08:35 -0700
Message-Id: <1350331769-14856-2-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1350331769-14856-1-git-send-email-koverstreet@google.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is prep work for immutable bio vecs; we first want to centralize
where bvecs are modified.

Next two patches convert some existing code to use this function.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
CC: Jens Axboe <axboe@kernel.dk>
---
 fs/bio.c                  | 41 +++++++++++++++++++++++++++++++++++++++++
 include/linux/bio.h       |  2 ++
 include/linux/blk_types.h |  2 ++
 3 files changed, 45 insertions(+)

diff --git a/fs/bio.c b/fs/bio.c
index f16aa6b..dc3452e 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -750,6 +750,47 @@ int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 }
 EXPORT_SYMBOL(bio_add_page);
 
+/**
+ * bio_advance - increment/complete a bio by some number of bytes
+ * @bio:	bio to advance
+ * @bytes:	number of bytes to complete
+ *
+ * This updates bi_sector, bi_size and bi_idx; if the number of bytes to
+ * complete doesn't align with a bvec boundary, then bv_len and bv_offset will
+ * be updated on the last bvec as well.
+ *
+ * @bio will then represent the remaining, uncompleted portion of the io.
+ */
+void bio_advance(struct bio *bio, unsigned bytes)
+{
+	if (bio_integrity(bio))
+		bio_integrity_advance(bio, bytes);
+
+	bio->bi_sector += bytes >> 9;
+	bio->bi_size -= bytes;
+
+	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+		return;
+
+	while (bytes) {
+		if (unlikely(bio->bi_idx >= bio->bi_vcnt)) {
+			WARN_ONCE(1, "bio idx %d >= vcnt %d\n",
+				  bio->bi_idx, bio->bi_vcnt);
+			break;
+		}
+
+		if (bytes >= bio_iovec(bio)->bv_len) {
+			bytes -= bio_iovec(bio)->bv_len;
+			bio->bi_idx++;
+		} else {
+			bio_iovec(bio)->bv_len -= bytes;
+			bio_iovec(bio)->bv_offset += bytes;
+			bytes = 0;
+		}
+	}
+}
+EXPORT_SYMBOL(bio_advance);
+
 struct bio_map_data {
 	struct bio_vec *iovecs;
 	struct sg_iovec *sgvecs;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 669b1cb..fcb4dba 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -248,6 +248,8 @@ extern void bio_endio(struct bio *, int);
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
+extern void bio_advance(struct bio *, unsigned);
+
 extern void bio_init(struct bio *);
 extern void bio_reset(struct bio *);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index cdf1119..c178d25 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -197,6 +197,8 @@ enum rq_flag_bits {
 	 REQ_SECURE)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
+#define BIO_NO_ADVANCE_ITER_MASK	(REQ_DISCARD|REQ_WRITE_SAME)
+
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
 	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
-- 
1.7.12

