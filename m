Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2I1Hhc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 03:37:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:56985 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2I1HhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 03:37:11 -0400
Date: Fri, 28 Sep 2012 15:36:55 +0800
From: Shaohua Li <shli@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: NeilBrown <neilb@suse.de>, Shaohua Li <shli@fusionio.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: makes bio_split support bio without data
Message-ID: <20120928073655.GA24681@kernel.org>
References: <20120924145639.3b65fd8b@notabene.brown>
 <5061A8EA.6040702@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061A8EA.6040702@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 02:51:54PM +0200, Jens Axboe wrote:
> On 09/24/2012 06:56 AM, NeilBrown wrote:
> > 
> > Hi Jens,
> >  this patch has been sitting in my -next tree for a little while and I was
> >  hoping for it to go in for the next merge window.
> >  It simply allows bio_split() to be used on bios without a payload, such as
> >  'discard'.
> >  Are you happy with it going in though my 'md' tree, or would you rather take
> >  it though your 'block' tree?
> 
> It should go through my tree, especially since we've got conflicts with
> other changes. In other words, your patch does not apply to for-3.7/core
> as-is...
> 
> Shaohua, could you resend an updated variant?
Here is the one applied to for-3.7/core


Subject: block: makes bio_split support bio without data

discard bio hasn't data attached. We hit a BUG_ON with such bio. This makes
bio_split works for such bio.

Signed-off-by: Shaohua Li <shli@fusionio.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/bio.c |   28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: linux/fs/bio.c
===================================================================
--- linux.orig/fs/bio.c	2012-09-28 15:09:38.000000000 +0800
+++ linux/fs/bio.c	2012-09-28 15:25:38.955252846 +0800
@@ -1475,7 +1475,7 @@ struct bio_pair *bio_split(struct bio *b
 	trace_block_split(bdev_get_queue(bi->bi_bdev), bi,
 				bi->bi_sector + first_sectors);
 
-	BUG_ON(bi->bi_vcnt != 1);
+	BUG_ON(bi->bi_vcnt != 1 && bi->bi_vcnt != 0);
 	BUG_ON(bi->bi_idx != 0);
 	atomic_set(&bp->cnt, 3);
 	bp->error = 0;
@@ -1485,20 +1485,22 @@ struct bio_pair *bio_split(struct bio *b
 	bp->bio2.bi_size -= first_sectors << 9;
 	bp->bio1.bi_size = first_sectors << 9;
 
-	bp->bv1 = bi->bi_io_vec[0];
-	bp->bv2 = bi->bi_io_vec[0];
+	if (bi->bi_vcnt != 0) {
+		bp->bv1 = bi->bi_io_vec[0];
+		bp->bv2 = bi->bi_io_vec[0];
+
+		if (bio_is_rw(bi)) {
+			bp->bv2.bv_offset += first_sectors << 9;
+			bp->bv2.bv_len -= first_sectors << 9;
+			bp->bv1.bv_len = first_sectors << 9;
+		}
 
-	if (bio_is_rw(bi)) {
-		bp->bv2.bv_offset += first_sectors << 9;
-		bp->bv2.bv_len -= first_sectors << 9;
-		bp->bv1.bv_len = first_sectors << 9;
-	}
-
-	bp->bio1.bi_io_vec = &bp->bv1;
-	bp->bio2.bi_io_vec = &bp->bv2;
+		bp->bio1.bi_io_vec = &bp->bv1;
+		bp->bio2.bi_io_vec = &bp->bv2;
 
-	bp->bio1.bi_max_vecs = 1;
-	bp->bio2.bi_max_vecs = 1;
+		bp->bio1.bi_max_vecs = 1;
+		bp->bio2.bi_max_vecs = 1;
+	}
 
 	bp->bio1.bi_end_io = bio_pair_end_1;
 	bp->bio2.bi_end_io = bio_pair_end_2;
