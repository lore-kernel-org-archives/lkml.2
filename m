Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0J1ApI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:45:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35507 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757576Ab0J1ApF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:45:05 -0400
Date: Thu, 28 Oct 2010 11:45:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the ext4 tree with Linus' tree
Message-Id: <20101028114500.c9428a91.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ted,

Today's linux-next merge of the ext4 tree got a conflict in
fs/ext4/inode.c between commit ebdec241d509cf69f6ebf1ecdc036359d3dbe154
("fs: kill block_prepare_write") from Linus' tree and commits
dd26005ac2f8b62a18fa33cfe082e94ff6151a73 ("ext4: simplify ext4_writepage
()") and a848e44595e1dfe55c3e85432ab018c49674281f ("ext4: inline
ext4_writepage() into mpage_da_submit_io()") from the ext4 tree.

I fixed it up (see below) and can carry the fix as necessary.

(I do wish that all those commits had appeared in linux-next some time
before today ...)
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/ext4/inode.c
index 49635ef,45fc5bd..0000000
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@@ -2030,86 -2062,32 +2062,32 @@@ static int mpage_da_submit_io(struct mp
  			BUG_ON(!PageLocked(page));
  			BUG_ON(PageWriteback(page));
  
- 			pages_skipped = mpd->wbc->pages_skipped;
- 			err = mapping->a_ops->writepage(page, mpd->wbc);
- 			if (!err && (pages_skipped == mpd->wbc->pages_skipped))
- 				/*
- 				 * have successfully written the page
- 				 * without skipping the same
- 				 */
- 				mpd->pages_written++;
  			/*
- 			 * In error case, we have to continue because
- 			 * remaining pages are still locked
- 			 * XXX: unlock and re-dirty them?
+ 			 * If the page does not have buffers (for
+ 			 * whatever reason), try to create them using
 -			 * block_prepare_write.  If this fails,
++			 * __block_write_begin.  If this fails,
+ 			 * redirty the page and move on.
  			 */
- 			if (ret == 0)
- 				ret = err;
- 		}
- 		pagevec_release(&pvec);
- 	}
- 	return ret;
- }
- 
- /*
-  * mpage_put_bnr_to_bhs - walk blocks and assign them actual numbers
-  *
-  * the function goes through all passed space and put actual disk
-  * block numbers into buffer heads, dropping BH_Delay and BH_Unwritten
-  */
- static void mpage_put_bnr_to_bhs(struct mpage_da_data *mpd,
- 				 struct ext4_map_blocks *map)
- {
- 	struct inode *inode = mpd->inode;
- 	struct address_space *mapping = inode->i_mapping;
- 	int blocks = map->m_len;
- 	sector_t pblock = map->m_pblk, cur_logical;
- 	struct buffer_head *head, *bh;
- 	pgoff_t index, end;
- 	struct pagevec pvec;
- 	int nr_pages, i;
- 
- 	index = map->m_lblk >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
- 	end = (map->m_lblk + blocks - 1) >> (PAGE_CACHE_SHIFT - inode->i_blkbits);
- 	cur_logical = index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
- 
- 	pagevec_init(&pvec, 0);
- 
- 	while (index <= end) {
- 		/* XXX: optimize tail */
- 		nr_pages = pagevec_lookup(&pvec, mapping, index, PAGEVEC_SIZE);
- 		if (nr_pages == 0)
- 			break;
- 		for (i = 0; i < nr_pages; i++) {
- 			struct page *page = pvec.pages[i];
- 
- 			index = page->index;
- 			if (index > end)
- 				break;
- 			index++;
- 
- 			BUG_ON(!PageLocked(page));
- 			BUG_ON(PageWriteback(page));
- 			BUG_ON(!page_has_buffers(page));
- 
- 			bh = page_buffers(page);
- 			head = bh;
- 
- 			/* skip blocks out of the range */
- 			do {
- 				if (cur_logical >= map->m_lblk)
- 					break;
- 				cur_logical++;
- 			} while ((bh = bh->b_this_page) != head);
+ 			if (!page_has_buffers(page)) {
 -				if (block_prepare_write(page, 0, len,
++				if (__block_write_begin(page, 0, len,
+ 						noalloc_get_block_write)) {
+ 				redirty_page:
+ 					redirty_page_for_writepage(mpd->wbc,
+ 								   page);
+ 					unlock_page(page);
+ 					continue;
+ 				}
+ 				commit_write = 1;
+ 			}
  
+ 			bh = page_bufs = page_buffers(page);
+ 			block_start = 0;
  			do {
- 				if (cur_logical >= map->m_lblk + blocks)
- 					break;
- 
- 				if (buffer_delay(bh) || buffer_unwritten(bh)) {
- 
- 					BUG_ON(bh->b_bdev != inode->i_sb->s_bdev);
- 
+ 				if (!bh)
+ 					goto redirty_page;
+ 				if (map && (cur_logical >= map->m_lblk) &&
+ 				    (cur_logical <= (map->m_lblk +
+ 						     (map->m_len - 1)))) {
  					if (buffer_delay(bh)) {
  						clear_buffer_delay(bh);
  						bh->b_blocknr = pblock;
@@@ -2712,18 -2714,15 +2713,15 @@@ static int ext4_writepage(struct page *
  	else
  		len = PAGE_CACHE_SIZE;
  
- 	if (page_has_buffers(page)) {
- 		page_bufs = page_buffers(page);
- 		if (walk_page_buffers(NULL, page_bufs, 0, len, NULL,
- 					ext4_bh_delay_or_unwritten)) {
- 			/*
- 			 * We don't want to do  block allocation
- 			 * So redirty the page and return
- 			 * We may reach here when we do a journal commit
- 			 * via journal_submit_inode_data_buffers.
- 			 * If we don't have mapping block we just ignore
- 			 * them. We can also reach here via shrink_page_list
- 			 */
+ 	/*
+ 	 * If the page does not have buffers (for whatever reason),
 -	 * try to create them using block_prepare_write.  If this
++	 * try to create them using __block_write_begin.  If this
+ 	 * fails, redirty the page and move on.
+ 	 */
+ 	if (!page_buffers(page)) {
 -		if (block_prepare_write(page, 0, len,
++		if (__block_write_begin(page, 0, len,
+ 					noalloc_get_block_write)) {
+ 		redirty_page:
  			redirty_page_for_writepage(wbc, page);
  			unlock_page(page);
  			return 0;
