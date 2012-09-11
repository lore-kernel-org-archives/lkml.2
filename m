Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab2IKS2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 14:28:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38297 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757980Ab2IKS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 14:28:29 -0400
Date: Tue, 11 Sep 2012 11:28:25 -0700
From: Kent Overstreet <koverstreet@google.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org
Subject: Re: [PATCH v2 12/26] raid1: use bio_reset()
Message-ID: <20120911182825.GG19739@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-13-git-send-email-koverstreet@google.com>
 <20120911145913.3f8a0a30@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911145913.3f8a0a30@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 02:59:13PM +1000, NeilBrown wrote:
> On Mon, 10 Sep 2012 17:22:23 -0700 Kent Overstreet <koverstreet@google.com>
> wrote:
> 
> > I couldn't figure out what sbio->bi_end_io in process_checks() was
> > supposed to be, so I took the easy way out.
> 
> Almost.
> You save 'sbio->bi_end_io' to 'bi_end_io', then do nothing with it...

Whoops :) I think I must've gotten distracted and forgot to finish with
that patch, I wasn't setting bi_private either.

> 
> A little way above the 'fixup the bio for reuse' comment you'll find:
> 
> 		struct bio *sbio = r1_bio->bios[i];
> ....
> 		if (r1_bio->bios[i]->bi_end_io != end_sync_read)
> 			continue;
> 
> which implies that if we don't 'continue', then sbio->bi_end_io ==
> end_sync_read.

Ahh. I remember reading that, but I missed that that was sbio that was
being checked.

> 
> So I suspect you want to add
>     sbio->bi_end_io = end_sync_read;
> somewhere after the 'bio_reset()'.
> 
> If you happened to also fix that 'if' that I quoted so that it reads:
> 
>      if (sbio->bi_end_io != end_sync_read)
>            continue;

Will do! How's this look?


commit 40a4645a4346edd040066baedcf2184ac4211ba7
Author: Kent Overstreet <koverstreet@google.com>
Date:   Tue Sep 11 11:26:12 2012 -0700

    raid1: use bio_reset()
    
    Signed-off-by: Kent Overstreet <koverstreet@google.com>
    CC: Jens Axboe <axboe@kernel.dk>
    CC: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ee85154..df68691 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1851,7 +1851,7 @@ static int process_checks(struct r1bio *r1_bio)
 		struct bio *sbio = r1_bio->bios[i];
 		int size;
 
-		if (r1_bio->bios[i]->bi_end_io != end_sync_read)
+		if (sbio->bi_end_io != end_sync_read)
 			continue;
 
 		if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
@@ -1876,16 +1876,15 @@ static int process_checks(struct r1bio *r1_bio)
 			continue;
 		}
 		/* fixup the bio for reuse */
+		bio_reset(sbio);
 		sbio->bi_vcnt = vcnt;
 		sbio->bi_size = r1_bio->sectors << 9;
-		sbio->bi_idx = 0;
-		sbio->bi_phys_segments = 0;
-		sbio->bi_flags &= ~(BIO_POOL_MASK - 1);
-		sbio->bi_flags |= 1 << BIO_UPTODATE;
-		sbio->bi_next = NULL;
 		sbio->bi_sector = r1_bio->sector +
 			conf->mirrors[i].rdev->data_offset;
 		sbio->bi_bdev = conf->mirrors[i].rdev->bdev;
+		sbio->bi_end_io = end_sync_read;
+		sbio->bi_private = r1_bio;
+
 		size = sbio->bi_size;
 		for (j = 0; j < vcnt ; j++) {
 			struct bio_vec *bi;
@@ -2426,18 +2425,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr, int *skipp
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		struct md_rdev *rdev;
 		bio = r1_bio->bios[i];
-
-		/* take from bio_init */
-		bio->bi_next = NULL;
-		bio->bi_flags &= ~(BIO_POOL_MASK-1);
-		bio->bi_flags |= 1 << BIO_UPTODATE;
-		bio->bi_rw = READ;
-		bio->bi_vcnt = 0;
-		bio->bi_idx = 0;
-		bio->bi_phys_segments = 0;
-		bio->bi_size = 0;
-		bio->bi_end_io = NULL;
-		bio->bi_private = NULL;
+		bio_reset(bio);
 
 		rdev = rcu_dereference(conf->mirrors[i].rdev);
 		if (rdev == NULL ||
