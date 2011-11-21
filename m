Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab1KUJlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 04:41:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:36114 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551Ab1KUJk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 04:40:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78289932"
Message-Id: <20111121093846.378529145@intel.com>
User-Agent: quilt/0.48-1
Date: Mon, 21 Nov 2011 17:18:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/8] readahead: replace ra->mmap_miss with ra->ra_flags
References: <20111121091819.394895091@intel.com>
Content-Disposition: inline; filename=readahead-flags.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a readahead flags field and embed the existing mmap_miss in it
(mainly to save space).

It will be possible to lose the flags in race conditions, however the
impact should be limited.  For the race to happen, there must be two
threads sharing the same file descriptor to be in page fault or
readahead at the same time.

Note that it has always been racy for "page faults" at the same time.

And if ever the race happen, we'll lose one mmap_miss++ or mmap_miss--.
Which may change some concrete readahead behavior, but won't really
impact overall I/O performance.

CC: Andi Kleen <andi@firstfloor.org>
CC: Steven Whitehouse <swhiteho@redhat.com>
Acked-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |   31 ++++++++++++++++++++++++++++++-
 mm/filemap.c       |    9 ++-------
 2 files changed, 32 insertions(+), 8 deletions(-)

--- linux-next.orig/include/linux/fs.h	2011-11-20 11:30:55.000000000 +0800
+++ linux-next/include/linux/fs.h	2011-11-20 11:48:53.000000000 +0800
@@ -945,10 +945,39 @@ struct file_ra_state {
 					   there are only # of pages ahead */
 
 	unsigned int ra_pages;		/* Maximum readahead window */
-	unsigned int mmap_miss;		/* Cache miss stat for mmap accesses */
+	unsigned int ra_flags;
 	loff_t prev_pos;		/* Cache last read() position */
 };
 
+/* ra_flags bits */
+#define	READAHEAD_MMAP_MISS	0x000003ff /* cache misses for mmap access */
+
+/*
+ * Don't do ra_flags++ directly to avoid possible overflow:
+ * the ra fields can be accessed concurrently in a racy way.
+ */
+static inline unsigned int ra_mmap_miss_inc(struct file_ra_state *ra)
+{
+	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
+
+	/* the upper bound avoids banging the cache line unnecessarily */
+	if (miss < READAHEAD_MMAP_MISS) {
+		miss++;
+		ra->ra_flags = miss | (ra->ra_flags & ~READAHEAD_MMAP_MISS);
+	}
+	return miss;
+}
+
+static inline void ra_mmap_miss_dec(struct file_ra_state *ra)
+{
+	unsigned int miss = ra->ra_flags & READAHEAD_MMAP_MISS;
+
+	if (miss) {
+		miss--;
+		ra->ra_flags = miss | (ra->ra_flags & ~READAHEAD_MMAP_MISS);
+	}
+}
+
 /*
  * Check if @index falls in the readahead windows.
  */
--- linux-next.orig/mm/filemap.c	2011-11-20 11:30:55.000000000 +0800
+++ linux-next/mm/filemap.c	2011-11-20 11:48:29.000000000 +0800
@@ -1597,15 +1597,11 @@ static void do_sync_mmap_readahead(struc
 		return;
 	}
 
-	/* Avoid banging the cache line if not needed */
-	if (ra->mmap_miss < MMAP_LOTSAMISS * 10)
-		ra->mmap_miss++;
-
 	/*
 	 * Do we miss much more than hit in this file? If so,
 	 * stop bothering with read-ahead. It will only hurt.
 	 */
-	if (ra->mmap_miss > MMAP_LOTSAMISS)
+	if (ra_mmap_miss_inc(ra) > MMAP_LOTSAMISS)
 		return;
 
 	/*
@@ -1633,8 +1629,7 @@ static void do_async_mmap_readahead(stru
 	/* If we don't want any read-ahead, don't bother */
 	if (VM_RandomReadHint(vma))
 		return;
-	if (ra->mmap_miss > 0)
-		ra->mmap_miss--;
+	ra_mmap_miss_dec(ra);
 	if (PageReadahead(page))
 		page_cache_async_readahead(mapping, ra, file,
 					   page, offset, ra->ra_pages);


