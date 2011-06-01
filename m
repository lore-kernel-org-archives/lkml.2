Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162091Ab1FAJEH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 05:04:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43485 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162028Ab1FAIRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:17:10 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:02 2011
Message-Id: <20110601081102.168623030@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:09:53 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>,
        Mingming Cao <cmm@us.ibm.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [023/165] ext4: dont set PageUptodate in ext4_end_bio()
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 3118
Lines: 99

From: Curt Wohlgemuth <curtw@google.com>

commit 39db00f1c45e770856264bdb3ceca27980b01965 upstream.

In the bio completion routine, we should not be setting
PageUptodate at all -- it's set at sys_write() time, and is
unaffected by success/failure of the write to disk.

This can cause a page corruption bug when the file system's
block size is less than the architecture's VM page size.

if we have only written a single block -- we might end up
setting the page's PageUptodate flag, indicating that page
is completely read into memory, which may not be true.
This could cause subsequent reads to get bad data.

This commit also takes the opportunity to clean up error
handling in ext4_end_bio(), and remove some extraneous code:

   - fixes ext4_end_bio() to set AS_EIO in the
     page->mapping->flags on error, which was left out by
     mistake.  This is needed so that fsync() will
     return an error if there was an I/O error.
   - remove the clear_buffer_dirty() call on unmapped
     buffers for each page.
   - consolidate page/buffer error handling in a single
     section.

Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reported-by: Jim Meyering <jim@meyering.net>
Reported-by: Hugh Dickins <hughd@google.com>
Cc: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/page-io.c |   37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -203,46 +203,29 @@ static void ext4_end_bio(struct bio *bio
 	for (i = 0; i < io_end->num_io_pages; i++) {
 		struct page *page = io_end->pages[i]->p_page;
 		struct buffer_head *bh, *head;
-		int partial_write = 0;
+		loff_t offset;
+		loff_t io_end_offset;
 
-		head = page_buffers(page);
-		if (error)
+		if (error) {
 			SetPageError(page);
-		BUG_ON(!head);
-		if (head->b_size != PAGE_CACHE_SIZE) {
-			loff_t offset;
-			loff_t io_end_offset = io_end->offset + io_end->size;
+			set_bit(AS_EIO, &page->mapping->flags);
+			head = page_buffers(page);
+			BUG_ON(!head);
+
+			io_end_offset = io_end->offset + io_end->size;
 
 			offset = (sector_t) page->index << PAGE_CACHE_SHIFT;
 			bh = head;
 			do {
 				if ((offset >= io_end->offset) &&
-				    (offset+bh->b_size <= io_end_offset)) {
-					if (error)
-						buffer_io_error(bh);
+				    (offset+bh->b_size <= io_end_offset))
+					buffer_io_error(bh);
 
-				}
-				if (buffer_delay(bh))
-					partial_write = 1;
-				else if (!buffer_mapped(bh))
-					clear_buffer_dirty(bh);
-				else if (buffer_dirty(bh))
-					partial_write = 1;
 				offset += bh->b_size;
 				bh = bh->b_this_page;
 			} while (bh != head);
 		}
 
-		/*
-		 * If this is a partial write which happened to make
-		 * all buffers uptodate then we can optimize away a
-		 * bogus readpage() for the next read(). Here we
-		 * 'discover' whether the page went uptodate as a
-		 * result of this (potentially partial) write.
-		 */
-		if (!partial_write)
-			SetPageUptodate(page);
-
 		put_io_page(io_end->pages[i]);
 	}
 	io_end->num_io_pages = 0;


