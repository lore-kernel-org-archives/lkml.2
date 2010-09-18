Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab0IRTPa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:15:30 -0400
Received: from kroah.org ([198.145.64.141]:43531 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab0IRTPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:25 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:02 2010
Message-Id: <20100918191302.833274002@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:42 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>,
        Hugh Dickins <hughd@google.com>, Jens Axboe <jaxboe@fusionio.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [064/129] swap: do not send discards as barriers
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Christoph Hellwig <hch@infradead.org>

commit 8f2ae0faa3a119158c4dcfe89926d6fad5f5332c upstream.

The swap code already uses synchronous discards, no need to add I/O
barriers.

This fixes the worst of the terrible slowdown in swap allocation for
hibernation, reported on 2.6.35 by Nigel Cunningham; but does not entirely
eliminate that regression.

[tj@kernel.org: superflous newlines removed]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/swapfile.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -139,8 +139,7 @@ static int discard_swap(struct swap_info
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			return err;
 		cond_resched();
@@ -151,8 +150,7 @@ static int discard_swap(struct swap_info
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			break;
 
@@ -191,8 +189,7 @@ static void discard_swap_cluster(struct
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT |
-							BLKDEV_IFL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT))
 				break;
 		}
 


