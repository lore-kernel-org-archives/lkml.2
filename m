Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396Ab1K0Fal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:30:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1K0Fai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:30:38 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Williams <dan.j.williams@intel.com>, linux-crypto@vger.kernel.org
Subject: [PATCH 09/62] crypto: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:26:49 +0800
Message-Id: <1322371662-26166-10-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 crypto/ahash.c                 |    4 ++--
 crypto/async_tx/async_memcpy.c |    8 ++++----
 crypto/blkcipher.c             |    8 ++++----
 crypto/ccm.c                   |    4 ++--
 crypto/scatterwalk.c           |    8 ++++----
 crypto/shash.c                 |    8 ++++----
 include/crypto/scatterwalk.h   |   28 +++-------------------------
 7 files changed, 23 insertions(+), 45 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index ac93c99..33bc9b6 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -46,7 +46,7 @@ static int hash_walk_next(struct crypto_hash_walk *walk)
 	unsigned int nbytes = min(walk->entrylen,
 				  ((unsigned int)(PAGE_SIZE)) - offset);
 
-	walk->data = crypto_kmap(walk->pg, 0);
+	walk->data = kmap_atomic(walk->pg);
 	walk->data += offset;
 
 	if (offset & alignmask) {
@@ -93,7 +93,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 		return nbytes;
 	}
 
-	crypto_kunmap(walk->data, 0);
+	kunmap_atomic(walk->data);
 	crypto_yield(walk->flags);
 
 	if (err)
diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index 0d5a90c..361b5e8 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -79,13 +79,13 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 		/* wait for any prerequisite operations */
 		async_tx_quiesce(&submit->depend_tx);
 
-		dest_buf = kmap_atomic(dest, KM_USER0) + dest_offset;
-		src_buf = kmap_atomic(src, KM_USER1) + src_offset;
+		dest_buf = kmap_atomic(dest) + dest_offset;
+		src_buf = kmap_atomic(src) + src_offset;
 
 		memcpy(dest_buf, src_buf, len);
 
-		kunmap_atomic(src_buf, KM_USER1);
-		kunmap_atomic(dest_buf, KM_USER0);
+		kunmap_atomic(src_buf);
+		kunmap_atomic(dest_buf);
 
 		async_tx_sync_epilog(submit);
 	}
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 1e61d1a..4dd80c7 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -43,22 +43,22 @@ static int blkcipher_walk_first(struct blkcipher_desc *desc,
 
 static inline void blkcipher_map_src(struct blkcipher_walk *walk)
 {
-	walk->src.virt.addr = scatterwalk_map(&walk->in, 0);
+	walk->src.virt.addr = scatterwalk_map(&walk->in);
 }
 
 static inline void blkcipher_map_dst(struct blkcipher_walk *walk)
 {
-	walk->dst.virt.addr = scatterwalk_map(&walk->out, 1);
+	walk->dst.virt.addr = scatterwalk_map(&walk->out);
 }
 
 static inline void blkcipher_unmap_src(struct blkcipher_walk *walk)
 {
-	scatterwalk_unmap(walk->src.virt.addr, 0);
+	scatterwalk_unmap(walk->src.virt.addr);
 }
 
 static inline void blkcipher_unmap_dst(struct blkcipher_walk *walk)
 {
-	scatterwalk_unmap(walk->dst.virt.addr, 1);
+	scatterwalk_unmap(walk->dst.virt.addr);
 }
 
 /* Get a spot of the specified length that does not straddle a page.
diff --git a/crypto/ccm.c b/crypto/ccm.c
index c36d654..32fe1bb 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -216,12 +216,12 @@ static void get_data_to_compute(struct crypto_cipher *tfm,
 			scatterwalk_start(&walk, sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
-		data_src = scatterwalk_map(&walk, 0);
+		data_src = scatterwalk_map(&walk);
 
 		compute_mac(tfm, data_src, n, pctx);
 		len -= n;
 
-		scatterwalk_unmap(data_src, 0);
+		scatterwalk_unmap(data_src);
 		scatterwalk_advance(&walk, n);
 		scatterwalk_done(&walk, 0, len);
 		if (len)
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 41e529a..7281b8a 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -40,9 +40,9 @@ void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg)
 }
 EXPORT_SYMBOL_GPL(scatterwalk_start);
 
-void *scatterwalk_map(struct scatter_walk *walk, int out)
+void *scatterwalk_map(struct scatter_walk *walk)
 {
-	return crypto_kmap(scatterwalk_page(walk), out) +
+	return kmap_atomic(scatterwalk_page(walk)) +
 	       offset_in_page(walk->offset);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map);
@@ -83,9 +83,9 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		if (len_this_page > nbytes)
 			len_this_page = nbytes;
 
-		vaddr = scatterwalk_map(walk, out);
+		vaddr = scatterwalk_map(walk);
 		memcpy_dir(buf, vaddr, len_this_page, out);
-		scatterwalk_unmap(vaddr, out);
+		scatterwalk_unmap(vaddr);
 
 		scatterwalk_advance(walk, len_this_page);
 
diff --git a/crypto/shash.c b/crypto/shash.c
index 9100912..21fc12e 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -281,10 +281,10 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	if (nbytes < min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset)) {
 		void *data;
 
-		data = crypto_kmap(sg_page(sg), 0);
+		data = kmap_atomic(sg_page(sg));
 		err = crypto_shash_digest(desc, data + offset, nbytes,
 					  req->result);
-		crypto_kunmap(data, 0);
+		kunmap_atomic(data);
 		crypto_yield(desc->flags);
 	} else
 		err = crypto_shash_init(desc) ?:
@@ -420,9 +420,9 @@ static int shash_compat_digest(struct hash_desc *hdesc, struct scatterlist *sg,
 
 		desc->flags = hdesc->flags;
 
-		data = crypto_kmap(sg_page(sg), 0);
+		data = kmap_atomic(sg_page(sg));
 		err = crypto_shash_digest(desc, data + offset, nbytes, out);
-		crypto_kunmap(data, 0);
+		kunmap_atomic(data);
 		crypto_yield(desc->flags);
 		goto out;
 	}
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 4fd95a3..3744d2a 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -25,28 +25,6 @@
 #include <linux/scatterlist.h>
 #include <linux/sched.h>
 
-static inline enum km_type crypto_kmap_type(int out)
-{
-	enum km_type type;
-
-	if (in_softirq())
-		type = out * (KM_SOFTIRQ1 - KM_SOFTIRQ0) + KM_SOFTIRQ0;
-	else
-		type = out * (KM_USER1 - KM_USER0) + KM_USER0;
-
-	return type;
-}
-
-static inline void *crypto_kmap(struct page *page, int out)
-{
-	return kmap_atomic(page, crypto_kmap_type(out));
-}
-
-static inline void crypto_kunmap(void *vaddr, int out)
-{
-	kunmap_atomic(vaddr, crypto_kmap_type(out));
-}
-
 static inline void crypto_yield(u32 flags)
 {
 	if (flags & CRYPTO_TFM_REQ_MAY_SLEEP)
@@ -121,15 +99,15 @@ static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 }
 
-static inline void scatterwalk_unmap(void *vaddr, int out)
+static inline void scatterwalk_unmap(void *vaddr)
 {
-	crypto_kunmap(vaddr, out);
+	kunmap_atomic(vaddr);
 }
 
 void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg);
 void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			    size_t nbytes, int out);
-void *scatterwalk_map(struct scatter_walk *walk, int out);
+void *scatterwalk_map(struct scatter_walk *walk);
 void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
-- 
1.7.4.4

