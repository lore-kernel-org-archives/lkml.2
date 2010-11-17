Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305Ab0KQTG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:06:26 -0500
Received: from mx0a-000f4101.pphosted.com ([67.231.144.146]:54983 "EHLO
	mx0a-000f4101.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758687Ab0KQTGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:06:24 -0500
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 14:06:24 EST
Subject: [PATCH] md: Fix nr_pending race during raid10 recovery
From: Aniket Kulkarni <aniket@netezza.com>
Reply-To: <aniket@netezza.com>
To: Neil Brown <neilb@suse.de>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Netezza
Date: Wed, 17 Nov 2010 13:57:50 -0500
Message-ID: <1290020270.3055.12.camel@aniket-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-11-17_06:2010-11-17,2010-11-17,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a RAID10 rdev that is undergoing recovery is marked 'faulty', the rdev 
could get taken out of the array in spite of outstanding IOs leading to 
a kernel panic. There are two issues here -

1. The ref count (nr_pending) increment for sync or recovery leaves a lot of
open windows for concurrent rdev removals
2. raid10 sync thread continues to submit recovery IOs to faulty devices. These get
rejected at a later stage by management thread (raid10d).

Note - rd denotes the rdev from which we are reading, and wr the one we are
writing to

  Sync Thread                                Management Thread

sync_request
  ++rd.nr_pending
  bi_end_io = end_sync_read
  generic_make_request         -------> recovery_request_write
         |                    |             wr.nr_pending++
         |                    |             bi_end_io = end_sync_write
         V                    |             generic_make_request
end_sync_read    --------------                      |
  --rd.nr_pending                                    |
  reschedule_retry for write                         |
                                                     v
                                         end_sync_write
                                             --wr.nr_pending

So a set-faulty and remove on recovery rdev between sync_request and 
recovery_request_write is allowed and will lead to a panic.

The fix is -

1. Increment wr.nr_pending immediately after selecting a good target. Ofcourse
the decrements will be added to error paths in sync_request and end_sync_read.
2. Don't submit recovery IOs to faulty targets

Signed-off-by: Aniket Kulkarni <aniket@netezza.com>
---
 drivers/md/raid10.c |   46 +++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index c67aa54..ec1ea43 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1408,6 +1408,16 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 
 done:
 	if (atomic_dec_and_test(&r10_bio->remaining)) {
+		for (i = 0; i < conf->copies ; i++)  {
+			/* for any unsuccessful IOs give up the pending count on the
+			 * write device
+			 */
+			if (!test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags) &&
+				r10_bio->devs[i].bio->bi_end_io == end_sync_write) {
+				int d = r10_bio->devs[i].devnum;
+				rdev_dec_pending(conf->mirrors[d].rdev, mddev);
+			}
+		}
 		md_done_sync(mddev, r10_bio->sectors, 1);
 		put_buf(r10_bio);
 	}
@@ -1443,7 +1453,6 @@ static void recovery_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 	}
 	d = r10_bio->devs[1].devnum;
 
-	atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 	md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
 	if (test_bit(R10BIO_Uptodate, &r10_bio->state))
 		generic_make_request(wbio);
@@ -1906,14 +1915,24 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		int j, k;
 		r10_bio = NULL;
 
-		for (i=0 ; i<conf->raid_disks; i++)
+		for (i = 0; i < conf->raid_disks; i++)
 			if (conf->mirrors[i].rdev &&
 			    !test_bit(In_sync, &conf->mirrors[i].rdev->flags)) {
 				int still_degraded = 0;
 				/* want to reconstruct this device */
 				r10bio_t *rb2 = r10_bio;
-				sector_t sect = raid10_find_virt(conf, sector_nr, i);
+				sector_t sect;
 				int must_sync;
+
+				/* Skip over the faulty drives */
+				if (test_bit(Faulty, &conf->mirrors[i].rdev->flags))
+					continue;
+
+				/* up the nr_pending count; this will be decremented on
+				 * sync/recovery IO completion (success/erorr) to this dev
+				 */
+				atomic_inc(&conf->mirrors[i].rdev->nr_pending);
+				sect = raid10_find_virt(conf, sector_nr, i);
 				/* Unless we are doing a full sync, we only need
 				 * to recover the block if it is set in the bitmap
 				 */
@@ -1927,6 +1946,7 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 					 * that there will never be anything to do here
 					 */
 					chunks_skipped = -1;
+					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 					continue;
 				}
 
@@ -1997,6 +2017,10 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 				if (j == conf->copies) {
 					/* Cannot recover, so abort the recovery */
 					put_buf(r10_bio);
+					/* we wanted to write to 'i' but we didn't; so dec the
+					 * pending count
+					 */
+					rdev_dec_pending(conf->mirrors[i].rdev, mddev);
 					if (rb2)
 						atomic_dec(&rb2->remaining);
 					r10_bio = rb2;
@@ -2014,6 +2038,22 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 				r10_bio = (r10bio_t*) rb2->master_bio;
 				rb2->master_bio = NULL;
 				put_buf(rb2);
+				if (r10_bio)  {
+					int d;
+					/* Before throwing away the complete r10bio chain, decrement
+					 * the nr_pending ref counts incremented along the way
+					 * We do this only for our master_bio and then on because
+					 * if biolist == NULL no ref count was incremented in this
+					 * r10_bio
+					 */
+					for (d = 0; d < conf->copies; d++)  {
+						if (r10_bio->devs[d].bio &&
+							r10_bio->devs[d].bio->bi_end_io)	{
+							int dn = r10_bio->devs[d].devnum;
+							rdev_dec_pending(conf->mirrors[dn].rdev, mddev);
+						}
+					}
+				}
 			}
 			goto giveup;
 		}
-- 
1.7.1



