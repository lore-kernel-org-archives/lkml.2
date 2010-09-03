Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208Ab0ICKbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:31:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:35784 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097Ab0ICKbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:25 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 38/41] swap: do not send discards as barriers
Date: Fri,  3 Sep 2010 12:29:53 +0200
Message-Id: <1283509796-1510-39-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@infradead.org>

The swap code already uses synchronous discards, no need to add I/O barriers.

tj: superflous newlines removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Nigel Cunningham <nigel@tuxonice.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 mm/swapfile.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1f3f9c5..68cda16 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -141,8 +141,7 @@ static int discard_swap(struct swap_info_struct *si)
 	nr_blocks = ((sector_t)se->nr_pages - 1) << (PAGE_SHIFT - 9);
 	if (nr_blocks) {
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			return err;
 		cond_resched();
@@ -153,8 +152,7 @@ static int discard_swap(struct swap_info_struct *si)
 		nr_blocks = (sector_t)se->nr_pages << (PAGE_SHIFT - 9);
 
 		err = blkdev_issue_discard(si->bdev, start_block,
-				nr_blocks, GFP_KERNEL,
-				BLKDEV_IFL_WAIT | BLKDEV_IFL_BARRIER);
+				nr_blocks, GFP_KERNEL, BLKDEV_IFL_WAIT);
 		if (err)
 			break;
 
@@ -193,8 +191,7 @@ static void discard_swap_cluster(struct swap_info_struct *si,
 			start_block <<= PAGE_SHIFT - 9;
 			nr_blocks <<= PAGE_SHIFT - 9;
 			if (blkdev_issue_discard(si->bdev, start_block,
-				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT |
-							BLKDEV_IFL_BARRIER))
+				    nr_blocks, GFP_NOIO, BLKDEV_IFL_WAIT))
 				break;
 		}
 
-- 
1.7.1

