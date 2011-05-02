Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab1EBOSa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758549Ab1EBOS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:18:28 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [PATCH 2/3] blkdev: Simple cleanup in blkdev_issue_zeroout()
Date: Mon,  2 May 2011 16:17:20 +0200
Message-Id: <1304345841-20063-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blkdev_issue_zeroout() we are submitting regular WRITE bios, so we do
not need to check for -EOPNOTSUPP specifically in case of error. Also
there is no need to have label submit: because there is no way to jump
out from the while cycle without an error and we really want to exit,
rather than try again. And also remove the check for (sz == 0) since at
that point sz can never be zero.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
CC: Jens Axboe <jaxboe@fusionio.com>
---
 block/blk-lib.c |   14 --------------
 1 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9260cb0..d7a98d3 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -140,7 +140,6 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
 
-submit:
 	ret = 0;
 	while (nr_sects != 0) {
 		bio = bio_alloc(gfp_mask,
@@ -157,9 +156,6 @@ submit:
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
-			if (sz == 0)
-				/* bio has maximum size possible */
-				break;
 			ret = bio_add_page(bio, ZERO_PAGE(0), sz << 9, 0);
 			nr_sects -= ret >> 9;
 			sector += ret >> 9;
@@ -179,16 +175,6 @@ submit:
 		/* One of bios in the batch was completed with error.*/
 		ret = -EIO;
 
-	if (ret)
-		goto out;
-
-	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
-	if (nr_sects != 0)
-		goto submit;
-out:
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
-- 
1.7.4.4

