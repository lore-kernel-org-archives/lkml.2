Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab1EZSXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755482Ab1EZSXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:23:33 -0400
Date: Thu, 26 May 2011 14:23:21 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, jrbarnette@chromium.org,
        Neil Brown <neilb@suse.de>, Jens Axboe <jaxboe@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: dm: pass up rotational flag
Message-ID: <20110526182321.GA26219@redhat.com>
References: <1306356648-30730-1-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306356648-30730-1-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25 2011 at  4:50pm -0400,
Mandeep Singh Baines <msb@chromium.org> wrote:

> Allow the NONROT flag to be passed through to linear mappings if all
> underlying device are non-rotational. Tools like ureadahead will
> schedule IOs differently based on the rotational flag.
> 
> With this patch, I see boot time go from 7.75 s to 7.46 s on my device.
> 
> Suggested-by: J. Richard Barnette <jrbarnette@chromium.org>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Mike Snitzer <snitzer@redhat.com>
> Cc: Jens Axboe <jaxboe@fusionio.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: dm-devel@redhat.com

Thanks for doing this, looks good in general.

Just a few small nits:
 - rename device_nonrot to device_is_nonrot
 - rename dm_table_all_nonrot to dm_table_is_nonrot
 - add missing whitespace in dm_table_set_restrictions
 - move ti declaration outside of dm_table_is_nonrot's while loop
 - dm doesn't use 'true' or 'false' bool returns even though we have
   functions that return bool -- odd but best to keep consistent for now

I'll respond with v2 that folds these changes in and my Signed-off-by
---
 drivers/md/dm-table.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 40c6071..a173828 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1177,28 +1177,29 @@ static void dm_table_set_integrity(struct dm_table *t)
 			       blk_get_integrity(template_disk));
 }
 
-static int device_nonrot(struct dm_target *ti, struct dm_dev *dev,
-			       sector_t start, sector_t len, void *data)
+static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
+			    sector_t start, sector_t len, void *data)
 {
 	struct request_queue *q = bdev_get_queue(dev->bdev);
 
 	return q && blk_queue_nonrot(q);
 }
 
-static bool dm_table_all_nonrot(struct dm_table *t)
+static bool dm_table_is_nonrot(struct dm_table *t)
 {
+	struct dm_target *ti;
 	unsigned i = 0;
 
 	/* Ensure that all underlying device are non rotational. */
 	while (i < dm_table_get_num_targets(t)) {
-		struct dm_target *ti = dm_table_get_target(t, i++);
+		ti = dm_table_get_target(t, i++);
 
 		if (!ti->type->iterate_devices ||
-		    !ti->type->iterate_devices(ti, device_nonrot, NULL))
-			return false;
+		    !ti->type->iterate_devices(ti, device_is_nonrot, NULL))
+			return 0;
 	}
 
-	return true;
+	return 1;
 }
 
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
@@ -1213,7 +1214,8 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
-	if (!dm_table_all_nonrot(t))
+
+	if (!dm_table_is_nonrot(t))
 		queue_flag_clear_unlocked(QUEUE_FLAG_NONROT, q);
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
