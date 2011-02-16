Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab1BPAWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:06 -0500
Received: from kroah.org ([198.145.64.141]:39410 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab1BPAVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:54 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.422958807@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Curt Wohlgemuth <curtw@google.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [134/272] ext4: Fix data corruption with multi-block writepages support
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Curt Wohlgemuth <curtw@google.com>

commit d50bdd5aa55127635fd8a5c74bd2abb256bd34e3 upstream.

This fixes a corruption problem with the multi-block
writepages submittal change for ext4, from commit
bd2d0210cf22f2bd0cef72eb97cf94fc7d31d8cc ("ext4: use bio
layer instead of buffer layer in mpage_da_submit_io").

(Note that this corruption is not present in 2.6.37 on
ext4, because the corruption was detected after the
feature was merged in 2.6.37-rc1, and so it was turned
off by adding a non-default mount option,
mblk_io_submit.  With this commit, which hopefully
fixes the last of the bugs with this feature, we'll be
able to turn on this performance feature by default in
2.6.38, and remove the mblk_io_submit option.)

The ext4 code path to bundle multiple pages for
writeback in ext4_bio_write_page() had a bug: we should
be clearing buffer head dirty flags *before* we submit
the bio, not in the completion routine.

The patch below was tested on 2.6.37 under KVM with the
postgresql script which was submitted by Jon Nelson as
documented in commit 1449032be1.

Without the patch, I'd hit the corruption problem about
50-70% of the time.  With the patch, I executed the
script > 100 times with no corruption seen.

I also fixed a bug to make sure ext4_end_bio() doesn't
dereference the bio after the bio_put() call.

Reported-by: Jon Nelson <jnelson@jamponi.net>
Reported-by: Matthias Bayer <jackdachef@gmail.com>
Signed-off-by: Curt Wohlgemuth <curtw@google.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/page-io.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -193,6 +193,7 @@ static void ext4_end_bio(struct bio *bio
 	struct inode *inode;
 	unsigned long flags;
 	int i;
+	sector_t bi_sector = bio->bi_sector;
 
 	BUG_ON(!io_end);
 	bio->bi_private = NULL;
@@ -210,9 +211,7 @@ static void ext4_end_bio(struct bio *bio
 		if (error)
 			SetPageError(page);
 		BUG_ON(!head);
-		if (head->b_size == PAGE_CACHE_SIZE)
-			clear_buffer_dirty(head);
-		else {
+		if (head->b_size != PAGE_CACHE_SIZE) {
 			loff_t offset;
 			loff_t io_end_offset = io_end->offset + io_end->size;
 
@@ -224,7 +223,6 @@ static void ext4_end_bio(struct bio *bio
 					if (error)
 						buffer_io_error(bh);
 
-					clear_buffer_dirty(bh);
 				}
 				if (buffer_delay(bh))
 					partial_write = 1;
@@ -260,7 +258,7 @@ static void ext4_end_bio(struct bio *bio
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
 			     (unsigned long long)
-			     bio->bi_sector >> (inode->i_blkbits - 9));
+			     bi_sector >> (inode->i_blkbits - 9));
 	}
 
 	/* Add the io_end to per-inode completed io list*/
@@ -383,6 +381,7 @@ int ext4_bio_write_page(struct ext4_io_s
 
 	blocksize = 1 << inode->i_blkbits;
 
+	BUG_ON(!PageLocked(page));
 	BUG_ON(PageWriteback(page));
 	set_page_writeback(page);
 	ClearPageError(page);
@@ -400,12 +399,14 @@ int ext4_bio_write_page(struct ext4_io_s
 	for (bh = head = page_buffers(page), block_start = 0;
 	     bh != head || !block_start;
 	     block_start = block_end, bh = bh->b_this_page) {
+
 		block_end = block_start + blocksize;
 		if (block_start >= len) {
 			clear_buffer_dirty(bh);
 			set_buffer_uptodate(bh);
 			continue;
 		}
+		clear_buffer_dirty(bh);
 		ret = io_submit_add_bh(io, io_page, inode, wbc, bh);
 		if (ret) {
 			/*


