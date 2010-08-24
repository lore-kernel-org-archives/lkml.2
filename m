Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0HXHkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 03:40:03 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:40111 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0HXHj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 03:39:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=h83+iNRW+LEWgmE1TQivmIim+EBrzk1x00BswgBJ1pnoNA080IEHhewtAenUzK7VJj
         C/CekF/Et0wDrI1QNjvRKCt+X4rwbGump5CYmfmnaIGIMWsubUVBz/mvgBrUozYmqv9r
         8ToBh9eiR73jQ1zwPZJpfumzIYj+RY67ns7JQ=
Date: Tue, 24 Aug 2010 15:39:31 +0800
From: Cong Meng <mcpacino@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] VFS buffer: calculate block-size correctly
Message-ID: <20100824073930.GA3198@zhongling.bej.apac.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the invocation of __getblk(bdev, block, size) will cause kernel stall if
the @size parameter is not equal to the block size of the block device
saved in the inode struct.

submit_bh() has the similar problem.

this patch calculates the blocksize by the value i_blkbits saved in the 
inode struct.

Signed-off-by: Cong Meng <mcpacino@gmail.com>
---
 fs/buffer.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 3e7dca2..f7f9d33 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1051,10 +1051,7 @@ grow_buffers(struct block_device *bdev, sector_t block, int size)
 	pgoff_t index;
 	int sizebits;
 
-	sizebits = -1;
-	do {
-		sizebits++;
-	} while ((size << sizebits) < PAGE_SIZE);
+	sizebits = PAGE_CACHE_SHIFT - bdev->bd_inode->i_blkbits;
 
 	index = block >> sizebits;
 
@@ -2924,7 +2921,7 @@ int submit_bh(int rw, struct buffer_head * bh)
 	 */
 	bio = bio_alloc(GFP_NOIO, 1);
 
-	bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
+	bio->bi_sector = bh->b_blocknr << (bh->b_bdev->bd_inode->i_blkbits - 9);
 	bio->bi_bdev = bh->b_bdev;
 	bio->bi_io_vec[0].bv_page = bh->b_page;
 	bio->bi_io_vec[0].bv_len = bh->b_size;
