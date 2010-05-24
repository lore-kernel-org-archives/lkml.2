Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758286Ab0EXWiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:38:22 -0400
Received: from kroah.org ([198.145.64.141]:42322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab0EXWiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:16 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 15:30:15 2010
Message-Id: <20100524223015.642557299@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:28:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Tso" <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [08/24] ext4: Use tag dirty lookup during mpage_da_submit_io
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit af6f029d3836eb7264cd3fbb13a6baf0e5fdb5ea upstream.

This enables us to drop the range_cont writeback mode
use from ext4_da_writepages.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/inode.c |   30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1699,17 +1699,23 @@ static int mpage_da_submit_io(struct mpa
 
 	pagevec_init(&pvec, 0);
 	while (index <= end) {
-		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
+		/*
+		 * We can use PAGECACHE_TAG_DIRTY lookup here because
+		 * even though we have cleared the dirty flag on the page
+		 * We still keep the page in the radix tree with tag
+		 * PAGECACHE_TAG_DIRTY. See clear_page_dirty_for_io.
+		 * The PAGECACHE_TAG_DIRTY is cleared in set_page_writeback
+		 * which is called via the below writepage callback.
+		 */
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+					PAGECACHE_TAG_DIRTY,
+					min(end - index,
+					(pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0)
 			break;
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
 
-			index = page->index;
-			if (index > end)
-				break;
-			index++;
-
 			BUG_ON(!PageLocked(page));
 			BUG_ON(PageWriteback(page));
 
@@ -2442,7 +2448,6 @@ static int ext4_da_writepages(struct add
 			      struct writeback_control *wbc)
 {
 	handle_t *handle = NULL;
-	loff_t range_start = 0;
 	struct mpage_da_data mpd;
 	struct inode *inode = mapping->host;
 	int needed_blocks, ret = 0, nr_to_writebump = 0;
@@ -2481,14 +2486,7 @@ static int ext4_da_writepages(struct add
 		wbc->nr_to_write = sbi->s_mb_stream_request;
 	}
 
-	if (!wbc->range_cyclic)
-		/*
-		 * If range_cyclic is not set force range_cont
-		 * and save the old writeback_index
-		 */
-		wbc->range_cont = 1;
 
-	range_start =  wbc->range_start;
 	pages_skipped = wbc->pages_skipped;
 
 	mpd.wbc = wbc;
@@ -2559,9 +2557,8 @@ restart_loop:
 		wbc->nr_to_write = to_write;
 	}
 
-	if (wbc->range_cont && (pages_skipped != wbc->pages_skipped)) {
+	if (!wbc->range_cyclic && (pages_skipped != wbc->pages_skipped)) {
 		/* We skipped pages in this loop */
-		wbc->range_start = range_start;
 		wbc->nr_to_write = to_write +
 				wbc->pages_skipped - pages_skipped;
 		wbc->pages_skipped = pages_skipped;
@@ -2570,7 +2567,6 @@ restart_loop:
 
 out_writepages:
 	wbc->nr_to_write = to_write - nr_to_writebump;
-	wbc->range_start = range_start;
 	return ret;
 }
 


