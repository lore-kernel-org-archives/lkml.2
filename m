Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab0E1UGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:06:34 -0400
Received: from bosmailout07.eigbox.net ([66.96.187.7]:35508 "EHLO
	bosmailout07.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab0E1UG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:06:26 -0400
X-EN-OrigOutIP: 10.20.18.8
X-EN-IMPSID: P7YT1e00J0ASroS017YTMm
Message-ID: <4C0018E1.5060007@jaysonking.com>
Date: Fri, 28 May 2010 14:26:25 -0500
From: "Jayson R. King" <dev@jaysonking.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Stable team <stable@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
CC: "Jayson R. King" <dev@jaysonking.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Dave Chinner <david@fromorbit.com>,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Kay Diederichs <Kay.Diederichs@uni-konstanz.de>
Subject: [PATCH 2.6.27.y 1/3] ext4: Use our own write_cache_pages()
References: <4C001888.8020006@jaysonking.com>
In-Reply-To: <4C001888.8020006@jaysonking.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 06af1bc540adb20c3d2d7097199478a6:08dd1976e651f6e3791fbe97eaa5f898
X-EN-AuthUser: jaysonking@jaysonking.com
X-EN-OrigIP: 68.93.139.172
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>
Date: Sun May 16 18:00:00 2010 -0400
Subject: ext4: Use our own write_cache_pages()

commit 8e48dcfbd7c0892b4cfd064d682cc4c95a29df32 upstream.

Make a copy of write_cache_pages() for the benefit of
ext4_da_writepages().  This allows us to simplify the code some, and
will allow us to further customize the code in future patches.

There are some nasty hacks in write_cache_pages(), which Linus has
(correctly) characterized as vile.  I've just copied it into
write_cache_pages_da(), without trying to clean those bits up lest I
break something in the ext4's delalloc implementation, which is a bit
fragile right now.  This will allow Dave Chinner to clean up
write_cache_pages() in mm/page-writeback.c, without worrying about
breaking ext4.  Eventually write_cache_pages_da() will go away when I
rewrite ext4's delayed allocation and create a general
ext4_writepages() which is used for all of ext4's writeback.  Until
now this is the lowest risk way to clean up the core
write_cache_pages() function.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
[dev@jaysonking.com: Dropped the hunks which reverted the use of no_nrwrite_index_update, since those lines weren't ever created on 2.6.27.y]
[dev@jaysonking.com: Copied from 2.6.27.y's version of write_cache_pages(), plus the changes to it from patch "vfs: Add no_nrwrite_index_update writeback control flag"]
Signed-off-by: Jayson R. King <dev@jaysonking.com>

---
 fs/ext4/inode.c |  144 ++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 132 insertions(+), 12 deletions(-)

diff -udrNp linux-2.6.27.orig/fs/ext4/inode.c linux-2.6.27/fs/ext4/inode.c
--- linux-2.6.27.orig/fs/ext4/inode.c	2010-05-28 12:50:17.376962920 -0500
+++ linux-2.6.27/fs/ext4/inode.c	2010-05-28 12:50:33.361963378 -0500
@@ -2059,17 +2059,6 @@ static int __mpage_da_writepage(struct p
 	struct buffer_head *bh, *head, fake;
 	sector_t logical;
 
-	if (mpd->io_done) {
-		/*
-		 * Rest of the page in the page_vec
-		 * redirty then and skip then. We will
-		 * try to to write them again after
-		 * starting a new transaction
-		 */
-		redirty_page_for_writepage(wbc, page);
-		unlock_page(page);
-		return MPAGE_DA_EXTENT_TAIL;
-	}
 	/*
 	 * Can we merge this page to current extent?
 	 */
@@ -2160,6 +2149,137 @@ static int __mpage_da_writepage(struct p
 }
 
 /*
+ * write_cache_pages_da - walk the list of dirty pages of the given
+ * address space and call the callback function (which usually writes
+ * the pages).
+ *
+ * This is a forked version of write_cache_pages().  Differences:
+ *	Range cyclic is ignored.
+ *	no_nrwrite_index_update is always presumed true
+ */
+static int write_cache_pages_da(struct address_space *mapping,
+				struct writeback_control *wbc,
+				struct mpage_da_data *mpd)
+{
+	struct backing_dev_info *bdi = mapping->backing_dev_info;
+	int ret = 0;
+	int done = 0;
+	struct pagevec pvec;
+	int nr_pages;
+	pgoff_t index;
+	pgoff_t end;		/* Inclusive */
+	long nr_to_write = wbc->nr_to_write;
+
+	if (wbc->nonblocking && bdi_write_congested(bdi)) {
+		wbc->encountered_congestion = 1;
+		return 0;
+	}
+
+	pagevec_init(&pvec, 0);
+	index = wbc->range_start >> PAGE_CACHE_SHIFT;
+	end = wbc->range_end >> PAGE_CACHE_SHIFT;
+
+	while (!done && (index <= end)) {
+		int i;
+
+		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
+			      PAGECACHE_TAG_DIRTY,
+			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
+		if (nr_pages == 0)
+			break;
+
+		for (i = 0; i < nr_pages; i++) {
+			struct page *page = pvec.pages[i];
+
+			/*
+			 * At this point, the page may be truncated or
+			 * invalidated (changing page->mapping to NULL), or
+			 * even swizzled back from swapper_space to tmpfs file
+			 * mapping. However, page->index will not change
+			 * because we have a reference on the page.
+			 */
+			if (page->index > end) {
+				done = 1;
+				break;
+			}
+
+			lock_page(page);
+
+			/*
+			 * Page truncated or invalidated. We can freely skip it
+			 * then, even for data integrity operations: the page
+			 * has disappeared concurrently, so there could be no
+			 * real expectation of this data interity operation
+			 * even if there is now a new, dirty page at the same
+			 * pagecache address.
+			 */
+			if (unlikely(page->mapping != mapping)) {
+continue_unlock:
+				unlock_page(page);
+				continue;
+			}
+
+			if (!PageDirty(page)) {
+				/* someone wrote it for us */
+				goto continue_unlock;
+			}
+
+			if (PageWriteback(page)) {
+				if (wbc->sync_mode != WB_SYNC_NONE)
+					wait_on_page_writeback(page);
+				else
+					goto continue_unlock;
+			}
+
+			BUG_ON(PageWriteback(page));
+			if (!clear_page_dirty_for_io(page))
+				goto continue_unlock;
+
+			ret = __mpage_da_writepage(page, wbc, mpd);
+
+			if (unlikely(ret)) {
+				if (ret == AOP_WRITEPAGE_ACTIVATE) {
+					unlock_page(page);
+					ret = 0;
+				} else {
+					done = 1;
+					break;
+				}
+ 			}
+
+			if (nr_to_write > 0) {
+				nr_to_write--;
+				if (nr_to_write == 0 &&
+				    wbc->sync_mode == WB_SYNC_NONE) {
+					/*
+					 * We stop writing back only if we are
+					 * not doing integrity sync. In case of
+					 * integrity sync we have to keep going
+					 * because someone may be concurrently
+					 * dirtying pages, and we might have
+					 * synced a lot of newly appeared dirty
+					 * pages, but have not synced all of the
+					 * old dirty pages.
+					 */
+					done = 1;
+					break;
+				}
+			}
+
+			if (wbc->nonblocking && bdi_write_congested(bdi)) {
+				wbc->encountered_congestion = 1;
+				done = 1;
+				break;
+			}
+		}
+		pagevec_release(&pvec);
+		cond_resched();
+	}
+	return ret;
+}
+
+
+/*
  * mpage_da_writepages - walk the list of dirty pages of the given
  * address space, allocates non-allocated blocks, maps newly-allocated
  * blocks to existing bhs and issue IO them
@@ -2192,7 +2312,7 @@ static int mpage_da_writepages(struct ad
 
 	to_write = wbc->nr_to_write;
 
-	ret = write_cache_pages(mapping, wbc, __mpage_da_writepage, mpd);
+	ret = write_cache_pages_da(mapping, wbc, mpd);
 
 	/*
 	 * Handle last extent of pages
