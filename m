Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab0G3Rzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:55:33 -0400
Received: from kroah.org ([198.145.64.141]:58070 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759645Ab0G3Ryy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:54 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:38 2010
Message-Id: <20100730175137.932239876@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joel Becker <joel.becker@oracle.com>
Subject: [048/205] ocfs2: No need to zero pages past i_size.
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joel Becker <joel.becker@oracle.com>

commit 693c241a5f6aa01417f5f4caf9f82e60e316398d upstream.

When ocfs2 fills a hole, it does so by allocating clusters.  When a
cluster is larger than the write, ocfs2 must zero the portions of the
cluster outside of the write.  If the clustersize is smaller than a
pagecache page, this is handled by the normal pagecache mechanisms, but
when the clustersize is larger than a page, ocfs2's write code will zero
the pages adjacent to the write.  This makes sure the entire cluster is
zeroed correctly.

Currently ocfs2 behaves exactly the same when writing past i_size.
However, this means ocfs2 is writing zeroed pages for portions of a new
cluster that are beyond i_size.  The page writeback code isn't expecting
this.  It treats all pages past the one containing i_size as left behind
due to a previous truncate operation.

Thankfully, ocfs2 calculates the number of pages it will be working on
up front.  The rest of the write code merely honors the original
calculation.  We can simply trim the number of pages to only cover the
actual file data.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/aops.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1131,23 +1131,37 @@ out:
  */
 static int ocfs2_grab_pages_for_write(struct address_space *mapping,
 				      struct ocfs2_write_ctxt *wc,
-				      u32 cpos, loff_t user_pos, int new,
+				      u32 cpos, loff_t user_pos,
+				      unsigned user_len, int new,
 				      struct page *mmap_page)
 {
 	int ret = 0, i;
-	unsigned long start, target_index, index;
+	unsigned long start, target_index, end_index, index;
 	struct inode *inode = mapping->host;
+	loff_t last_byte;
 
 	target_index = user_pos >> PAGE_CACHE_SHIFT;
 
 	/*
 	 * Figure out how many pages we'll be manipulating here. For
 	 * non allocating write, we just change the one
-	 * page. Otherwise, we'll need a whole clusters worth.
+	 * page. Otherwise, we'll need a whole clusters worth.  If we're
+	 * writing past i_size, we only need enough pages to cover the
+	 * last page of the write.
 	 */
 	if (new) {
 		wc->w_num_pages = ocfs2_pages_per_cluster(inode->i_sb);
 		start = ocfs2_align_clusters_to_page_index(inode->i_sb, cpos);
+		/*
+		 * We need the index *past* the last page we could possibly
+		 * touch.  This is the page past the end of the write or
+		 * i_size, whichever is greater.
+		 */
+		last_byte = max(user_pos + user_len, i_size_read(inode));
+		BUG_ON(last_byte < 1);
+		end_index = ((last_byte - 1) >> PAGE_CACHE_SHIFT) + 1;
+		if ((start + wc->w_num_pages) > end_index)
+			wc->w_num_pages = end_index - start;
 	} else {
 		wc->w_num_pages = 1;
 		start = target_index;
@@ -1786,7 +1800,7 @@ int ocfs2_write_begin_nolock(struct addr
 	 * that we can zero and flush if we error after adding the
 	 * extent.
 	 */
-	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos,
+	ret = ocfs2_grab_pages_for_write(mapping, wc, wc->w_cpos, pos, len,
 					 cluster_of_pages, mmap_page);
 	if (ret) {
 		mlog_errno(ret);


