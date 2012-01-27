Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab2A0Dl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 22:41:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:48949 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab2A0Dki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 22:40:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="100232694"
Message-Id: <20120127031326.752229208@intel.com>
User-Agent: quilt/0.48-1
Date: Fri, 27 Jan 2012 11:05:27 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <andi@firstfloor.org>, Jan Kara <jack@suse.cz>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Linux Memory Management List <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/9] readahead: tag mmap page fault call sites
References: <20120127030524.854259561@intel.com>
Content-Disposition: inline; filename=readahead-for-mmap
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce a bit field ra->for_mmap for tagging mmap reads.
The tag will be cleared immediate after submitting the IO.

Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/linux/fs.h |    1 +
 mm/filemap.c       |    6 +++++-
 mm/readahead.c     |    1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

--- linux-next.orig/include/linux/fs.h	2012-01-25 15:57:50.000000000 +0800
+++ linux-next/include/linux/fs.h	2012-01-25 15:57:51.000000000 +0800
@@ -954,6 +954,7 @@ struct file_ra_state {
 	unsigned int ra_pages;		/* Maximum readahead window */
 	u16 mmap_miss;			/* Cache miss stat for mmap accesses */
 	u8 pattern;			/* one of RA_PATTERN_* */
+	unsigned int for_mmap:1;	/* readahead for mmap accesses */
 
 	loff_t prev_pos;		/* Cache last read() position */
 };
--- linux-next.orig/mm/filemap.c	2012-01-25 15:57:50.000000000 +0800
+++ linux-next/mm/filemap.c	2012-01-25 15:57:51.000000000 +0800
@@ -1578,6 +1578,7 @@ static void do_sync_mmap_readahead(struc
 		return;
 
 	if (VM_SequentialReadHint(vma)) {
+		ra->for_mmap = 1;
 		page_cache_sync_readahead(mapping, ra, file, offset,
 					  ra->ra_pages);
 		return;
@@ -1597,6 +1598,7 @@ static void do_sync_mmap_readahead(struc
 	/*
 	 * mmap read-around
 	 */
+	ra->for_mmap = 1;
 	ra->pattern = RA_PATTERN_MMAP_AROUND;
 	ra_pages = max_sane_readahead(ra->ra_pages);
 	ra->start = max_t(long, 0, offset - ra_pages / 2);
@@ -1622,9 +1624,11 @@ static void do_async_mmap_readahead(stru
 		return;
 	if (ra->mmap_miss > 0)
 		ra->mmap_miss--;
-	if (PageReadahead(page))
+	if (PageReadahead(page)) {
+		ra->for_mmap = 1;
 		page_cache_async_readahead(mapping, ra, file,
 					   page, offset, ra->ra_pages);
+	}
 }
 
 /**
--- linux-next.orig/mm/readahead.c	2012-01-25 15:57:50.000000000 +0800
+++ linux-next/mm/readahead.c	2012-01-25 15:57:51.000000000 +0800
@@ -259,6 +259,7 @@ unsigned long ra_submit(struct file_ra_s
 	actual = __do_page_cache_readahead(mapping, filp,
 					ra->start, ra->size, ra->async_size);
 
+	ra->for_mmap = 0;
 	return actual;
 }
 


