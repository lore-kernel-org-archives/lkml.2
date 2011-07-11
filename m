Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab1GKRt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:49:58 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:42571 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab1GKRtq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:49:46 -0400
X-ASG-Debug-ID: 1310406586-03d6a510a9147fb0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1B37B1.9030608@fusionio.com>
Date: Mon, 11 Jul 2011 19:49:37 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Muthu Kumar <muthu.lkml@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
  bio_add can make use of it.
References: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com>
X-ASG-Orig-Subj: Re: [PATCH]: block: try-2 (modified): Initialize bi_rw in mpage so
  bio_add can make use of it.
In-Reply-To: <CAFR8uec5MxvHEWS=hgRXo1eunjQqWrpPCVXthdGMfWR+Yitw_A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310406586
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68630
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-11 19:31, Muthu Kumar wrote:
> Jens et al,
> 
> do_mpage_readpage()/__mpage_writepage(): When they allocate a new bio,
> bi_rw is not initialized. So later when they call __bio_add_page(),
> struct bvec_merge_data bvm's .bi_rw will not be initialized with right
> direction.
> It will be useful for some merge functions if they know the direction
> of transfer.
> 
> Let me know if this looks good. There are few more places like this
> (e.g blkdev_issue_zeroout()). Would it make sense to send patch for
> these cases also?

For this particular case, doing it when the bio is allocated makes more
sense. That will avoid a similar error in there in the future.

Something ala the below.

diff --git a/fs/mpage.c b/fs/mpage.c
index fdfae9f..a2b8604 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -80,7 +80,7 @@ static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 
 static struct bio *
 mpage_alloc(struct block_device *bdev,
-		sector_t first_sector, int nr_vecs,
+		sector_t first_sector, int nr_vecs, int rw,
 		gfp_t gfp_flags)
 {
 	struct bio *bio;
@@ -93,8 +93,9 @@ mpage_alloc(struct block_device *bdev,
 	}
 
 	if (bio) {
-		bio->bi_bdev = bdev;
 		bio->bi_sector = first_sector;
+		bio->bi_bdev = bdev;
+		bio->bi_rw = rw;
 	}
 	return bio;
 }
@@ -288,7 +289,7 @@ alloc_new:
 	if (bio == NULL) {
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
 			  	min_t(int, nr_pages, bio_get_nr_vecs(bdev)),
-				GFP_KERNEL);
+				READ, GFP_KERNEL);
 		if (bio == NULL)
 			goto confused;
 	}
@@ -580,7 +581,8 @@ page_is_mapped:
 alloc_new:
 	if (bio == NULL) {
 		bio = mpage_alloc(bdev, blocks[0] << (blkbits - 9),
-				bio_get_nr_vecs(bdev), GFP_NOFS|__GFP_HIGH);
+				bio_get_nr_vecs(bdev), WRITE,
+				GFP_NOFS|__GFP_HIGH);
 		if (bio == NULL)
 			goto confused;
 	}

-- 
Jens Axboe

