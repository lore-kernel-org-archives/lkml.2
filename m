Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234Ab0HFLPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 07:15:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50258 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab0HFLPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 07:15:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=cGEIH8mOL+jdEeOYzjzDs3K69gnD0W8x/YRXPM1tsAslSXJBsOSRxYOIPVBqhHqW+g
         zQ0fxy/Z/VsAzQUnVQLoaL4coLD3NIqT6H0N+Odh0Ti3go2gg59XbGQ+r2LSFiA2G9aB
         2v6jOn3UuX41IrH65kzePWRLNk9U0J09pMEK0=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Resend: [PATCH] blkdev: fix blkdev_issue_zeroout return value
References: <87vd7o2f9z.fsf@dmon-lap.sw.ru> <4C5BEA4E.4070107@kernel.dk>
Date: Fri, 06 Aug 2010 15:15:42 +0400
In-Reply-To: <4C5BEA4E.4070107@kernel.dk> (Jens Axboe's message of "Fri, 06
	Aug 2010 12:56:14 +0200")
Message-ID: <87mxt02dr5.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=

Jens Axboe <axboe@kernel.dk> writes:

> On 2010-08-06 12:42, Dmitry Monakhov wrote:
>> Hi Jens,
>> Seems that my first mail was missed somewhere.  
>> I've found couple of trivial issues in blkdev_issue_zeroout()
>> implementation. Unfortunately I've miss during initial testing phase
>> because always called it with BARRIER|WAIT flags.
>
> BTW, this:
>
> @@ -218,15 +222,18 @@ submit:
>  		/* One of bios in the batch was completed with error.*/
>  		ret = -EIO;
>  
> -	if (ret)
> +	if (ret && ret != -ENOMEM)
>  		goto out;
>  
>  	if (test_bit(BIO_EOPNOTSUPP, &bb.flags)) {
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
> -	if (nr_sects != 0)
> +	if (nr_sects != 0) {
> +		if (ret == -ENOMEM)
> +			io_schedule();
>  		goto submit;
> +	}
>  out:
>  	return ret;
>  }
>
> is broken. Either the caller sets __GFP_WAIT and then bio_alloc() will
> not fail, or GFP_ATOMIC is used knowing that the call can fail and
> return ENOMEM. Don't code in retry logic like this.
Ok, my fault and in fact i've done in explicitly. I just thought
that blk-layer is some times an exception from general GFP_ATOMIC rule
because in some places in blk-layer we stick to GFP_NOFAIL semantics
regardless to actual gfp flags.

New version attached.

--=-=-=
Content-Disposition: inline;
 filename=0001-blkdev-fix-blkdev_issue_zeroout-return-value.patch

>From 32236cd453f070807a91631a2de12478f872edd3 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Fri, 6 Aug 2010 15:06:01 +0400
Subject: [PATCH] blkdev: fix blkdev_issue_zeroout return value

- If function called without barrier option retvalue is incorrect

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5d793e1..c1fc55a 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -145,7 +145,7 @@ static void bio_batch_end_io(struct bio *bio, int err)
 int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
 {
-	int ret = 0;
+	int ret;
 	struct bio *bio;
 	struct bio_batch bb;
 	unsigned int sz, issued = 0;
@@ -163,11 +163,14 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
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
@@ -186,6 +189,7 @@ submit:
 			if (ret < (sz << 9))
 				break;
 		}
+		ret = 0;
 		issued++;
 		submit_bio(WRITE, bio);
 	}
-- 
1.6.6.1


--=-=-=--
