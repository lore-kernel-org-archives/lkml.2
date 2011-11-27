Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab1K0Fdj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 00:33:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab1K0Fdh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 00:33:37 -0500
From: Cong Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Cong Wang <amwang@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        devel@driverdev.osuosl.org
Subject: [PATCH 25/62] rtl8192u: remove the second argument of k[un]map_atomic()
Date: Sun, 27 Nov 2011 13:27:05 +0800
Message-Id: <1322371662-26166-26-git-send-email-amwang@redhat.com>
In-Reply-To: <1322371662-26166-1-git-send-email-amwang@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Cong Wang <amwang@redhat.com>
---
 drivers/staging/rtl8192u/ieee80211/cipher.c      |    8 ++++----
 drivers/staging/rtl8192u/ieee80211/digest.c      |    8 ++++----
 drivers/staging/rtl8192u/ieee80211/internal.h    |   17 -----------------
 drivers/staging/rtl8192u/ieee80211/kmap_types.h  |   20 --------------------
 drivers/staging/rtl8192u/ieee80211/scatterwalk.c |   19 +++++--------------
 5 files changed, 13 insertions(+), 59 deletions(-)
 delete mode 100644 drivers/staging/rtl8192u/ieee80211/kmap_types.h

diff --git a/drivers/staging/rtl8192u/ieee80211/cipher.c b/drivers/staging/rtl8192u/ieee80211/cipher.c
index 69dcc31..d47345c 100644
--- a/drivers/staging/rtl8192u/ieee80211/cipher.c
+++ b/drivers/staging/rtl8192u/ieee80211/cipher.c
@@ -71,8 +71,8 @@ static int crypt(struct crypto_tfm *tfm,
 		u8 *src_p, *dst_p;
 		int in_place;
 
-		scatterwalk_map(&walk_in, 0);
-		scatterwalk_map(&walk_out, 1);
+		scatterwalk_map(&walk_in);
+		scatterwalk_map(&walk_out);
 		src_p = scatterwalk_whichbuf(&walk_in, bsize, tmp_src);
 		dst_p = scatterwalk_whichbuf(&walk_out, bsize, tmp_dst);
 		in_place = scatterwalk_samebuf(&walk_in, &walk_out,
@@ -84,10 +84,10 @@ static int crypt(struct crypto_tfm *tfm,
 
 		prfn(tfm, dst_p, src_p, crfn, enc, info, in_place);
 
-		scatterwalk_done(&walk_in, 0, nbytes);
+		scatterwalk_done(&walk_in, nbytes);
 
 		scatterwalk_copychunks(dst_p, &walk_out, bsize, 1);
-		scatterwalk_done(&walk_out, 1, nbytes);
+		scatterwalk_done(&walk_out, nbytes);
 
 		if (!nbytes)
 			return 0;
diff --git a/drivers/staging/rtl8192u/ieee80211/digest.c b/drivers/staging/rtl8192u/ieee80211/digest.c
index 301ed51..05e7497 100644
--- a/drivers/staging/rtl8192u/ieee80211/digest.c
+++ b/drivers/staging/rtl8192u/ieee80211/digest.c
@@ -39,12 +39,12 @@ static void update(struct crypto_tfm *tfm,
 			unsigned int bytes_from_page = min(l, ((unsigned int)
 							   (PAGE_SIZE)) -
 							   offset);
-			char *p = crypto_kmap(pg, 0) + offset;
+			char *p = kmap_atomic(pg) + offset;
 
 			tfm->__crt_alg->cra_digest.dia_update
 					(crypto_tfm_ctx(tfm), p,
 					 bytes_from_page);
-			crypto_kunmap(p, 0);
+			kunmap_atomic(p);
 			crypto_yield(tfm);
 			offset = 0;
 			pg++;
@@ -75,10 +75,10 @@ static void digest(struct crypto_tfm *tfm,
 	tfm->crt_digest.dit_init(tfm);
 
 	for (i = 0; i < nsg; i++) {
-		char *p = crypto_kmap(sg[i].page, 0) + sg[i].offset;
+		char *p = kmap_atomic(sg[i].page) + sg[i].offset;
 		tfm->__crt_alg->cra_digest.dia_update(crypto_tfm_ctx(tfm),
 						      p, sg[i].length);
-		crypto_kunmap(p, 0);
+		kunmap_atomic(p);
 		crypto_yield(tfm);
 	}
 	crypto_digest_final(tfm, out);
diff --git a/drivers/staging/rtl8192u/ieee80211/internal.h b/drivers/staging/rtl8192u/ieee80211/internal.h
index a7c096e..bebe13a 100644
--- a/drivers/staging/rtl8192u/ieee80211/internal.h
+++ b/drivers/staging/rtl8192u/ieee80211/internal.h
@@ -23,23 +23,6 @@
 #include <asm/kmap_types.h>
 
 
-extern enum km_type crypto_km_types[];
-
-static inline enum km_type crypto_kmap_type(int out)
-{
-	return crypto_km_types[(in_softirq() ? 2 : 0) + out];
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
 static inline void crypto_yield(struct crypto_tfm *tfm)
 {
 	if (!in_softirq())
diff --git a/drivers/staging/rtl8192u/ieee80211/kmap_types.h b/drivers/staging/rtl8192u/ieee80211/kmap_types.h
deleted file mode 100644
index de67bb0..0000000
--- a/drivers/staging/rtl8192u/ieee80211/kmap_types.h
+++ /dev/null
@@ -1,20 +0,0 @@
-#ifndef __KMAP_TYPES_H
-
-#define __KMAP_TYPES_H
-
-
-enum km_type {
-	KM_BOUNCE_READ,
-	KM_SKB_SUNRPC_DATA,
-	KM_SKB_DATA_SOFTIRQ,
-	KM_USER0,
-	KM_USER1,
-	KM_BH_IRQ,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-	KM_TYPE_NR
-};
-
-#define _ASM_KMAP_TYPES_H
-
-#endif
diff --git a/drivers/staging/rtl8192u/ieee80211/scatterwalk.c b/drivers/staging/rtl8192u/ieee80211/scatterwalk.c
index 3543a61..8b73f6c 100644
--- a/drivers/staging/rtl8192u/ieee80211/scatterwalk.c
+++ b/drivers/staging/rtl8192u/ieee80211/scatterwalk.c
@@ -13,8 +13,6 @@
  * any later version.
  *
  */
-#include "kmap_types.h"
-
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/pagemap.h>
@@ -23,13 +21,6 @@
 #include "internal.h"
 #include "scatterwalk.h"
 
-enum km_type crypto_km_types[] = {
-	KM_USER0,
-	KM_USER1,
-	KM_SOFTIRQ0,
-	KM_SOFTIRQ1,
-};
-
 void *scatterwalk_whichbuf(struct scatter_walk *walk, unsigned int nbytes, void *scratch)
 {
 	if (nbytes <= walk->len_this_page &&
@@ -62,9 +53,9 @@ void scatterwalk_start(struct scatter_walk *walk, struct scatterlist *sg)
 	walk->offset = sg->offset;
 }
 
-void scatterwalk_map(struct scatter_walk *walk, int out)
+void scatterwalk_map(struct scatter_walk *walk)
 {
-	walk->data = crypto_kmap(walk->page, out) + walk->offset;
+	walk->data = kmap_atomic(walk->page) + walk->offset;
 }
 
 static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
@@ -103,7 +94,7 @@ void scatterwalk_done(struct scatter_walk *walk, int out, int more)
  * has been verified as multiple of the block size.
  */
 int scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
-			   size_t nbytes, int out)
+			   size_t nbytes)
 {
 	if (buf != walk->data) {
 		while (nbytes > walk->len_this_page) {
@@ -111,9 +102,9 @@ int scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 			buf += walk->len_this_page;
 			nbytes -= walk->len_this_page;
 
-			crypto_kunmap(walk->data, out);
+			kunmap_atomic(walk->data);
 			scatterwalk_pagedone(walk, out, 1);
-			scatterwalk_map(walk, out);
+			scatterwalk_map(walk);
 		}
 
 		memcpy_dir(buf, walk->data, nbytes, out);
-- 
1.7.4.4

