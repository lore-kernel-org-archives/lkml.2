Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab0GVLpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 07:45:09 -0400
Received: from daytona.panasas.com ([67.152.220.89]:43511 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754184Ab0GVLpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 07:45:05 -0400
Message-ID: <4C482F35.6000004@panasas.com>
Date: Thu, 22 Jul 2010 14:44:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>, Christoph Hellwig <hch@infradead.org>
CC: Jiri Slaby <jirislaby@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: [PATCH] md: bitwise operations might not fit in a "bool"
References: <4C47ED7B.1050709@gmail.com> <20100722173716.66264bef@notabene> <4C481FD5.4070509@gmail.com>
In-Reply-To: <4C481FD5.4070509@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Jul 2010 11:45:03.0041 (UTC) FILETIME=[52734B10:01CB2993]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when taking a resolute of a bit-wise AND as true false. Better / faster
to make it a boolean operation.

This fixes a bug and a crash because the flags field did not fit into
the bool operands.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
git diff --stat -p -M drivers/md/raid1.c
 drivers/md/raid1.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 73cc74f..67a9159 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -787,7 +787,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	struct bio_list bl;
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
-	const bool do_sync = (bio->bi_rw & REQ_SYNC);
+	const bool do_sync = (bio->bi_rw & REQ_SYNC) != 0;
 	bool do_barriers;
 	mdk_rdev_t *blocked_rdev;
 
@@ -959,7 +959,7 @@ static int make_request(mddev_t *mddev, struct bio * bio)
 	atomic_set(&r1_bio->remaining, 0);
 	atomic_set(&r1_bio->behind_remaining, 0);
 
-	do_barriers = bio->bi_rw & REQ_HARDBARRIER;
+	do_barriers = (bio->bi_rw & REQ_HARDBARRIER) != 0;
 	if (do_barriers)
 		set_bit(R1BIO_Barrier, &r1_bio->state);
 
@@ -1640,7 +1640,8 @@ static void raid1d(mddev_t *mddev)
 			 * We already have a nr_pending reference on these rdevs.
 			 */
 			int i;
-			const bool do_sync = (r1_bio->master_bio->bi_rw & REQ_SYNC);
+			const bool do_sync =
+				(r1_bio->master_bio->bi_rw & REQ_SYNC) != 0;
 			clear_bit(R1BIO_BarrierRetry, &r1_bio->state);
 			clear_bit(R1BIO_Barrier, &r1_bio->state);
 			for (i=0; i < conf->raid_disks; i++)
@@ -1696,7 +1697,9 @@ static void raid1d(mddev_t *mddev)
 				       (unsigned long long)r1_bio->sector);
 				raid_end_bio_io(r1_bio);
 			} else {
-				const bool do_sync = r1_bio->master_bio->bi_rw & REQ_SYNC;
+				const bool do_sync =
+					(r1_bio->master_bio->bi_rw & REQ_SYNC)
+					!= 0;
 				r1_bio->bios[r1_bio->read_disk] =
 					mddev->ro ? IO_BLOCKED : NULL;
 				r1_bio->read_disk = disk;

