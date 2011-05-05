Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1EEPNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:13:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab1EEPNB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:13:01 -0400
From: Lukas Czerner <lczerner@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>,
        Jens Axboe <jaxboe@fusionio.com>, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] blkdev: Do not return -EOPNOTSUPP if discard is supported
Date: Thu,  5 May 2011 17:12:45 +0200
Message-Id: <1304608365-17199-1-git-send-email-lczerner@redhat.com>
In-Reply-To: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
References: <1304345841-20063-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we return -EOPNOTSUPP in blkdev_issue_discard() if any of the
bio fails due to underlying device not supporting discard request.
However, if the device is for example dm device composed of devices
which some of them support discard and some of them does not, it is ok
for some bios to fail with EOPNOTSUPP, but it does not mean that discard
is not supported at all.

This commit removes the check for bios failed with EOPNOTSUPP and change
blkdev_issue_discard() to return operation not supported if and only if
the device does not actually supports it, not just part of the device as
some bios might indicate.

This change also fixes problem with BLKDISCARD ioctl() which now works
correctly on such dm devices.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
CC: Jens Axboe <jaxboe@fusionio.com>
CC: Jeff Moyer <jmoyer@redhat.com>
---
 block/blk-lib.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d7a98d3..78e627e 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -19,11 +19,8 @@ static void bio_batch_end_io(struct bio *bio, int err)
 {
 	struct bio_batch *bb = bio->bi_private;
 
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bb->flags);
+	if (err && (err != -EOPNOTSUPP))
 		clear_bit(BIO_UPTODATE, &bb->flags);
-	}
 	if (atomic_dec_and_test(&bb->done))
 		complete(bb->wait);
 	bio_put(bio);
@@ -107,9 +104,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion(&wait);
 
-	if (test_bit(BIO_EOPNOTSUPP, &bb.flags))
-		ret = -EOPNOTSUPP;
-	else if (!test_bit(BIO_UPTODATE, &bb.flags))
+	if (!test_bit(BIO_UPTODATE, &bb.flags))
 		ret = -EIO;
 
 	return ret;
-- 
1.7.4.4

