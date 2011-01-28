Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1A1PCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:02:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34519 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab1A1PCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 10:02:12 -0500
Date: Fri, 28 Jan 2011 09:01:55 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] zram/xvmalloc: combine duplicate block delete code
Message-ID: <20110128150155.GH2062@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110128145602.GA2062@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110128145602.GA2062@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch eliminates duplicate code.  The remove_block_head function
is a special case of remove_block which can be contained in remove_block
without confusion.

The portion of code in remove_block_head which was noted as "DEBUG ONLY"
is now mandatory.  Doing this provides consistent management of the double
linked list of blocks under a freelist and makes this consolidation
of delete block code safe.  The first and last blocks will have NULL
pointers in their previous and next page pointers respectively.

Additionally, any time a block is removed from a free list the next and
previous pointers will be set to NULL to avoid misuse outside xvmalloc.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/xvmalloc.c |   73 ++++++++++++++++----------------------
 1 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index 0560e9d..fc4a3df 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -213,54 +213,14 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
 }
 
 /*
- * Remove block from head of freelist. Index 'slindex' identifies the freelist.
- */
-static void remove_block_head(struct xv_pool *pool,
-			struct block_header *block, u32 slindex)
-{
-	struct block_header *tmpblock;
-	u32 flindex = slindex / BITS_PER_LONG;
-
-	pool->freelist[slindex].page = block->link.next_page;
-	pool->freelist[slindex].offset = block->link.next_offset;
-	block->link.prev_page = NULL;
-	block->link.prev_offset = 0;
-
-	if (!pool->freelist[slindex].page) {
-		__clear_bit(slindex % BITS_PER_LONG, &pool->slbitmap[flindex]);
-		if (!pool->slbitmap[flindex])
-			__clear_bit(flindex, &pool->flbitmap);
-	} else {
-		/*
-		 * DEBUG ONLY: We need not reinitialize freelist head previous
-		 * pointer to 0 - we never depend on its value. But just for
-		 * sanity, lets do it.
-		 */
-		tmpblock = get_ptr_atomic(pool->freelist[slindex].page,
-				pool->freelist[slindex].offset, KM_USER1);
-		tmpblock->link.prev_page = NULL;
-		tmpblock->link.prev_offset = 0;
-		put_ptr_atomic(tmpblock, KM_USER1);
-	}
-}
-
-/*
  * Remove block from freelist. Index 'slindex' identifies the freelist.
  */
 static void remove_block(struct xv_pool *pool, struct page *page, u32 offset,
 			struct block_header *block, u32 slindex)
 {
-	u32 flindex;
+	u32 flindex = slindex / BITS_PER_LONG;
 	struct block_header *tmpblock;
 
-	if (pool->freelist[slindex].page == page
-	   && pool->freelist[slindex].offset == offset) {
-		remove_block_head(pool, block, slindex);
-		return;
-	}
-
-	flindex = slindex / BITS_PER_LONG;
-
 	if (block->link.prev_page) {
 		tmpblock = get_ptr_atomic(block->link.prev_page,
 				block->link.prev_offset, KM_USER1);
@@ -276,6 +236,35 @@ static void remove_block(struct xv_pool *pool, struct page *page, u32 offset,
 		tmpblock->link.prev_offset = block->link.prev_offset;
 		put_ptr_atomic(tmpblock, KM_USER1);
 	}
+
+	/* Is this block is at the head of the freelist? */
+	if (pool->freelist[slindex].page == page
+	   && pool->freelist[slindex].offset == offset) {
+
+		pool->freelist[slindex].page = block->link.next_page;
+		pool->freelist[slindex].offset = block->link.next_offset;
+
+		if (pool->freelist[slindex].page) {
+			struct block_header *tmpblock;
+			tmpblock = get_ptr_atomic(pool->freelist[slindex].page,
+					pool->freelist[slindex].offset,
+					KM_USER1);
+			tmpblock->link.prev_page = NULL;
+			tmpblock->link.prev_offset = 0;
+			put_ptr_atomic(tmpblock, KM_USER1);
+		} else {
+			/* This freelist bucket is empty */
+			__clear_bit(slindex % BITS_PER_LONG,
+				    &pool->slbitmap[flindex]);
+			if (!pool->slbitmap[flindex])
+				__clear_bit(flindex, &pool->flbitmap);
+		}
+	}
+
+	block->link.prev_page = NULL;
+	block->link.prev_offset = 0;
+	block->link.next_page = NULL;
+	block->link.next_offset = 0;
 }
 
 /*
@@ -384,7 +373,7 @@ int xv_malloc(struct xv_pool *pool, u32 size, struct page **page,
 
 	block = get_ptr_atomic(*page, *offset, KM_USER0);
 
-	remove_block_head(pool, block, index);
+	remove_block(pool, *page, *offset, block, index);
 
 	/* Split the block if required */
 	tmpoffset = *offset + size + XV_ALIGN;
-- 
1.7.0.4

