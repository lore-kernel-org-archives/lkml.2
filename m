Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424196Ab2LGBKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 20:10:35 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:64094 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422954Ab2LGAzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:55:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "George Spelvin" <linux@horizon.com>, NeilBrown <neilb@suse.de>
Subject: [ 11/20] md/raid10: close race that lose writes lost when replacement completes.
Date: Thu,  6 Dec 2012 16:54:26 -0800
Message-Id: <20121207005235.942443092@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121207005232.756641002@linuxfoundation.org>
References: <20121207005232.756641002@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit e7c0c3fa29280d62aa5e11101a674bb3064bd791 upstream.

When a replacement operation completes there is a small window
when the original device is marked 'faulty' and the replacement
still looks like a replacement.  The faulty should be removed and
the replacement moved in place very quickly, bit it isn't instant.

So the code write out to the array must handle the possibility that
the only working device for some slot in the replacement - but it
doesn't.  If the primary device is faulty it just gives up.  This
can lead to corruption.

So make the code more robust: if either  the primary or the
replacement is present and working, write to them.  Only when
neither are present do we give up.

This bug has been present since replacement was introduced in
3.3, so it is suitable for any -stable kernel since then.

Reported-by: "George Spelvin" <linux@horizon.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |  104 +++++++++++++++++++++++++++-------------------------
 1 file changed, 55 insertions(+), 49 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1182,18 +1182,21 @@ retry_write:
 			blocked_rdev = rrdev;
 			break;
 		}
+		if (rdev && (test_bit(Faulty, &rdev->flags)
+			     || test_bit(Unmerged, &rdev->flags)))
+			rdev = NULL;
 		if (rrdev && (test_bit(Faulty, &rrdev->flags)
 			      || test_bit(Unmerged, &rrdev->flags)))
 			rrdev = NULL;
 
 		r10_bio->devs[i].bio = NULL;
 		r10_bio->devs[i].repl_bio = NULL;
-		if (!rdev || test_bit(Faulty, &rdev->flags) ||
-		    test_bit(Unmerged, &rdev->flags)) {
+
+		if (!rdev && !rrdev) {
 			set_bit(R10BIO_Degraded, &r10_bio->state);
 			continue;
 		}
-		if (test_bit(WriteErrorSeen, &rdev->flags)) {
+		if (rdev && test_bit(WriteErrorSeen, &rdev->flags)) {
 			sector_t first_bad;
 			sector_t dev_sector = r10_bio->devs[i].addr;
 			int bad_sectors;
@@ -1235,8 +1238,10 @@ retry_write:
 					max_sectors = good_sectors;
 			}
 		}
-		r10_bio->devs[i].bio = bio;
-		atomic_inc(&rdev->nr_pending);
+		if (rdev) {
+			r10_bio->devs[i].bio = bio;
+			atomic_inc(&rdev->nr_pending);
+		}
 		if (rrdev) {
 			r10_bio->devs[i].repl_bio = bio;
 			atomic_inc(&rrdev->nr_pending);
@@ -1292,51 +1297,52 @@ retry_write:
 	for (i = 0; i < conf->copies; i++) {
 		struct bio *mbio;
 		int d = r10_bio->devs[i].devnum;
-		if (!r10_bio->devs[i].bio)
-			continue;
-
-		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
-		r10_bio->devs[i].bio = mbio;
-
-		mbio->bi_sector	= (r10_bio->devs[i].addr+
-				   conf->mirrors[d].rdev->data_offset);
-		mbio->bi_bdev = conf->mirrors[d].rdev->bdev;
-		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
-		mbio->bi_private = r10_bio;
-
-		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
-
-		if (!r10_bio->devs[i].repl_bio)
-			continue;
+		if (r10_bio->devs[i].bio) {
+			struct md_rdev *rdev = conf->mirrors[d].rdev;
+			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+				    max_sectors);
+			r10_bio->devs[i].bio = mbio;
+
+			mbio->bi_sector	= (r10_bio->devs[i].addr+
+					   rdev->data_offset);
+			mbio->bi_bdev = rdev->bdev;
+			mbio->bi_end_io	= raid10_end_write_request;
+			mbio->bi_rw = WRITE | do_sync | do_fua;
+			mbio->bi_private = r10_bio;
+
+			atomic_inc(&r10_bio->remaining);
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		}
 
-		mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
-		md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
-			    max_sectors);
-		r10_bio->devs[i].repl_bio = mbio;
-
-		/* We are actively writing to the original device
-		 * so it cannot disappear, so the replacement cannot
-		 * become NULL here
-		 */
-		mbio->bi_sector	= (r10_bio->devs[i].addr+
-				   conf->mirrors[d].replacement->data_offset);
-		mbio->bi_bdev = conf->mirrors[d].replacement->bdev;
-		mbio->bi_end_io	= raid10_end_write_request;
-		mbio->bi_rw = WRITE | do_sync | do_fua;
-		mbio->bi_private = r10_bio;
-
-		atomic_inc(&r10_bio->remaining);
-		spin_lock_irqsave(&conf->device_lock, flags);
-		bio_list_add(&conf->pending_bio_list, mbio);
-		conf->pending_count++;
-		spin_unlock_irqrestore(&conf->device_lock, flags);
+		if (r10_bio->devs[i].repl_bio) {
+			struct md_rdev *rdev = conf->mirrors[d].replacement;
+			if (rdev == NULL) {
+				/* Replacement just got moved to main 'rdev' */
+				smp_mb();
+				rdev = conf->mirrors[d].rdev;
+			}
+			mbio = bio_clone_mddev(bio, GFP_NOIO, mddev);
+			md_trim_bio(mbio, r10_bio->sector - bio->bi_sector,
+				    max_sectors);
+			r10_bio->devs[i].repl_bio = mbio;
+
+			mbio->bi_sector	= (r10_bio->devs[i].addr+
+					   rdev->data_offset);
+			mbio->bi_bdev = rdev->bdev;
+			mbio->bi_end_io	= raid10_end_write_request;
+			mbio->bi_rw = WRITE | do_sync | do_fua;
+			mbio->bi_private = r10_bio;
+
+			atomic_inc(&r10_bio->remaining);
+			spin_lock_irqsave(&conf->device_lock, flags);
+			bio_list_add(&conf->pending_bio_list, mbio);
+			conf->pending_count++;
+			spin_unlock_irqrestore(&conf->device_lock, flags);
+		}
 	}
 
 	/* Don't remove the bias on 'remaining' (one_write_done) until


