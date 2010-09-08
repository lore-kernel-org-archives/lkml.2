Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758285Ab0IHKH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 06:07:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45825 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab0IHKH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 06:07:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=mIE5KaAuwULCndpOGSjJrj+m6Y1dU1mi3L5G9NmHmA+Lq8hMj06UnyBMe4KAbfI1Yk
         aKNPNfCotT8NnJz0hYcGT2LeFGYUtMeLqtT7qUHmPpru0UKPyk1kBRABhwMUJxWMHUzA
         3d9KzzgLCxx3rJf0dTXyR3Y7nilFlQRsuQRXs=
Date: Wed, 8 Sep 2010 18:07:10 +0800
From: Cong Meng <mcpacino@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: calculate block-size correctly
Message-ID: <20100908100710.GA26365@zhongling.bej.apac.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent this patch half mount ago, but no response at all. If anything is
wrong, please tell me. Thanks a lots. This is my first time to send patch
to linux kernel.

The invocation of __getblk(bdev, block, size) will cause kernel stall if
the @size parameter is not equal to the blockr-size of @bdev, which is saved
in bdev->bd_inode->i_blkbits.

submit_bh() has the similar problem.

This patch calculates the block-size using i_blkbits.
So that, for example, __getblk() can get a 4K buffer head while the
block-size of @bdev is 1K.

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
