Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253Ab0HFKm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 06:42:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55134 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab0HFKmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 06:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:cc:date:message-id:user-agent:mime-version
         :content-type;
        b=cG1x8oF3DeUffvMEIQ7oTCmRZhIy/Q+/2842ONHlKsR8zEwcw8Qtj13Mxa+sKCDloD
         Z5f92aTyGnCI2LHxW9+xLDt9VL+wxk6svhZeKIIma/7EEomxIxnAeyWM2mIEdBsVJnKX
         pNecRtyrYwEEX5hpEL1Gn6zTUvhhcda4hPIQ8=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: axboe@kernel.dk
Subject: Resend: [PATCH] blkdev: fix blkdev_issue_zeroout return value
CC: linux-kernel@vger.kernel.org
Date: Fri, 06 Aug 2010 14:42:48 +0400
Message-ID: <87vd7o2f9z.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Hi Jens,
Seems that my first mail was missed somewhere.  
I've found couple of trivial issues in blkdev_issue_zeroout()
implementation. Unfortunately I've miss during initial testing phase
because always called it with BARRIER|WAIT flags.


--=-=-=
Content-Disposition: inline; filename=patch-1

>From 5eb4d762ad8fe146ee638fb1b2d7730db3e3ca4b Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 27 Jul 2010 17:12:27 +0400
Subject: [PATCH] blkdev: fix blkdev_issue_zeroout return value

- If function called without barrier option retvalue is incorrect
- Add io_schedule() between loops


 diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..a8d6a21 100644

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d0216b9..a8d6a21 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -157,7 +157,7 @@ static void bio_batch_end_io(struct bio *bio, int err)
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 {
-	int ret = 0;
+	int ret;
 	struct bio *bio;
 	struct bio_batch bb;
 	unsigned int sz, issued = 0;
@@ -175,11 +175,14 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			return ret;
 	}
 submit:
+	ret = 0;
 	while (nr_sects != 0) {
 		bio = bio_alloc(gfp_mask,
 				min(nr_sects, (sector_t)BIO_MAX_PAGES));
-		if (!bio)
+		if (!bio) {
+			ret = -ENOMEM;
 			break;
+		}
 
 		bio->bi_sector = sector;
 		bio->bi_bdev   = bdev;
@@ -198,6 +201,7 @@ submit:
 			if (ret < (sz << 9))
 				break;
 		}
+		ret = 0;
 		issued++;
 		submit_bio(WRITE, bio);
 	}
@@ -218,15 +222,18 @@ submit:
 		/* One of bios in the batch was completed with error.*/
 		ret = -EIO;
 
-	if (ret)
+	if (ret && ret != -ENOMEM)
 		goto out;
 
 	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
-	if (nr_sects != 0)
+	if (nr_sects != 0) {
+		if (ret == -ENOMEM)
+			io_schedule();
 		goto submit;
+	}
 out:
 	return ret;
 }
-- 
1.6.6.1

--=-=-=--
