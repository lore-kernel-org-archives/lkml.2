Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754913Ab1DTMkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 08:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab1DTMkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 08:40:03 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, jmoyer@redhat.com,
        Lukas Czerner <lczerner@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 2/2] blkdev: Simple cleanup in blkdev_issue_zeroout()
Date: Wed, 20 Apr 2011 14:39:32 +0200
Message-Id: <1303303172-22404-2-git-send-email-lczerner@redhat.com>
In-Reply-To: <1303303172-22404-1-git-send-email-lczerner@redhat.com>
References: <1303303172-22404-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In blkdev_issue_zeroout() we are submitting regular WRITE bios, so we do
not need to check for -EOPNOTSUPP specifically in case of error. Also
there is no need to have label submit: because there is no way to jump
out from the while cycle without an error and we really want to exit,
rather than try again.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
CC: Jens Axboe <jens.axboe@oracle.com>
---
 block/blk-lib.c |   11 -----------
 1 files changed, 0 insertions(+), 11 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9260cb0..6165a15 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -140,7 +140,6 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
 
-submit:
 	ret = 0;
 	while (nr_sects != 0) {
 		bio = bio_alloc(gfp_mask,
@@ -179,16 +178,6 @@ submit:
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

