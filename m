Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab1AZRYA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:24:00 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:56464 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1AZRX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:23:58 -0500
Date: Wed, 26 Jan 2011 11:23:55 -0600
From: Robert Jennings <rcj@linux.vnet.ibm.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] zram: Speed insertion of new pages with cached idx
Message-ID: <20110126172354.GE8446@linux.vnet.ibm.com>
Mail-Followup-To: Nitin Gupta <ngupta@vflare.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Pekka Enberg <penberg@cs.helsinki.fi>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <20110126172148.GB8446@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110126172148.GB8446@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate the first- and second-level indices for new page when the pool
is initialized rather than calculating them on each insertion.

Signed-off-by: Robert Jennings <rcj@linux.vnet.ibm.com>
---
 drivers/staging/zram/xvmalloc.c     |   13 +++++++++++--
 drivers/staging/zram/xvmalloc_int.h |    4 ++++
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/xvmalloc.c b/drivers/staging/zram/xvmalloc.c
index 3fdbb8a..a507f95 100644
--- a/drivers/staging/zram/xvmalloc.c
+++ b/drivers/staging/zram/xvmalloc.c
@@ -184,8 +184,13 @@ static void insert_block(struct xv_pool *pool, struct page *page, u32 offset,
 	u32 flindex, slindex;
 	struct block_header *nextblock;
 
-	slindex = get_index_for_insert(block->size);
-	flindex = slindex / BITS_PER_LONG;
+	if (block->size >= (PAGE_SIZE - XV_ALIGN)) {
+		slindex = pagesize_slindex;
+		flindex = pagesize_flindex;
+	} else {
+		slindex = get_index_for_insert(block->size);
+		flindex = slindex / BITS_PER_LONG;
+	}
 
 	block->link.prev_page = 0;
 	block->link.prev_offset = 0;
@@ -316,6 +321,10 @@ struct xv_pool *xv_create_pool(void)
 	if (!pool)
 		return NULL;
 
+	/* cache the first/second-level indices for PAGE_SIZE allocations */
+	pagesize_slindex = get_index_for_insert(PAGE_SIZE);
+	pagesize_flindex = pagesize_slindex / BITS_PER_LONG;
+
 	spin_lock_init(&pool->lock);
 
 	return pool;
diff --git a/drivers/staging/zram/xvmalloc_int.h b/drivers/staging/zram/xvmalloc_int.h
index 051a49b..68db384 100644
--- a/drivers/staging/zram/xvmalloc_int.h
+++ b/drivers/staging/zram/xvmalloc_int.h
@@ -52,6 +52,10 @@
 
 /* End of user params */
 
+/* Cache of the first/second-level indices for PAGE_SIZE allocations */
+static u32 pagesize_slindex;
+static u32 pagesize_flindex;
+
 enum blockflags {
 	BLOCK_FREE,
 	PREV_FREE,
-- 
1.6.0.2

