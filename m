Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab0DVUDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:03:33 -0400
Received: from kroah.org ([198.145.64.141]:60088 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758057Ab0DVUB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:58 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:17 2010
Message-Id: <20100422195417.905924281@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       NeilBrown <neilb@suse.de>
Subject: [125/139] md: deal with merge_bvec_fn in component devices better.
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit 627a2d3c29427637f4c5d31ccc7fcbd8d312cd71 upstream.

If a component device has a merge_bvec_fn then as we never call it
we must ensure we never need to.  Currently this is done by setting
max_sector to 1 PAGE, however this does not stop a bio being created
with several sub-page iovecs that would violate the merge_bvec_fn.

So instead set max_phys_segments to 1 and set the segment boundary to the
same as a page boundary to ensure there is only ever one single-page
segment of IO requested at a time.

This can particularly be an issue when 'xen' is used as it is
known to submit multiple small buffers in a single bio.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/linear.c    |   12 +++++++-----
 drivers/md/multipath.c |   20 ++++++++++++--------
 drivers/md/raid0.c     |   13 +++++++------
 drivers/md/raid10.c    |   28 +++++++++++++++++-----------
 4 files changed, 43 insertions(+), 30 deletions(-)

--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -172,12 +172,14 @@ static linear_conf_t *linear_conf(mddev_
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
+		 * violating it, so limit max_phys_segments to 1 lying within
+		 * a single page.
 		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
+			blk_queue_max_phys_segments(mddev->queue, 1);
+			blk_queue_segment_boundary(mddev->queue,
+						   PAGE_CACHE_SIZE - 1);
+		}
 
 		conf->array_sectors += rdev->sectors;
 		cnt++;
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -301,14 +301,16 @@ static int multipath_add_disk(mddev_t *m
 					  rdev->data_offset << 9);
 
 		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
+		 * violating it, so limit ->max_phys_segments to one, lying
+		 * within a single page.
 		 * (Note: it is very unlikely that a device with
 		 * merge_bvec_fn will be involved in multipath.)
 		 */
-			if (q->merge_bvec_fn &&
-			    queue_max_sectors(q) > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			if (q->merge_bvec_fn) {
+				blk_queue_max_phys_segments(mddev->queue, 1);
+				blk_queue_segment_boundary(mddev->queue,
+							   PAGE_CACHE_SIZE - 1);
+			}
 
 			conf->working_disks++;
 			mddev->degraded--;
@@ -476,9 +478,11 @@ static int multipath_run (mddev_t *mddev
 		/* as we don't honour merge_bvec_fn, we must never risk
 		 * violating it, not that we ever expect a device with
 		 * a merge_bvec_fn to be involved in multipath */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
+			blk_queue_max_phys_segments(mddev->queue, 1);
+			blk_queue_segment_boundary(mddev->queue,
+						   PAGE_CACHE_SIZE - 1);
+		}
 
 		if (!test_bit(Faulty, &rdev->flags))
 			conf->working_disks++;
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -176,14 +176,15 @@ static int create_strip_zones(mddev_t *m
 		disk_stack_limits(mddev->gendisk, rdev1->bdev,
 				  rdev1->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
+		 * violating it, so limit ->max_phys_segments to 1, lying within
+		 * a single page.
 		 */
 
-		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
-		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
-
+		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn) {
+			blk_queue_max_phys_segments(mddev->queue, 1);
+			blk_queue_segment_boundary(mddev->queue,
+						   PAGE_CACHE_SIZE - 1);
+		}
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
 		cnt++;
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1155,13 +1155,17 @@ static int raid10_add_disk(mddev_t *mdde
 
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
-			/* as we don't honour merge_bvec_fn, we must never risk
-			 * violating it, so limit ->max_sector to one PAGE, as
-			 * a one page request is never in violation.
+			/* as we don't honour merge_bvec_fn, we must
+			 * never risk violating it, so limit
+			 * ->max_phys_segments to one lying with a single
+			 * page, as a one page request is never in
+			 * violation.
 			 */
-			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-			    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
+				blk_queue_max_phys_segments(mddev->queue, 1);
+				blk_queue_segment_boundary(mddev->queue,
+							   PAGE_CACHE_SIZE - 1);
+			}
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -2255,12 +2259,14 @@ static int run(mddev_t *mddev)
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);
 		/* as we don't honour merge_bvec_fn, we must never risk
-		 * violating it, so limit ->max_sector to one PAGE, as
-		 * a one page request is never in violation.
+		 * violating it, so limit max_phys_segments to 1 lying
+		 * within a single page.
 		 */
-		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
-		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+		if (rdev->bdev->bd_disk->queue->merge_bvec_fn) {
+			blk_queue_max_phys_segments(mddev->queue, 1);
+			blk_queue_segment_boundary(mddev->queue,
+						   PAGE_CACHE_SIZE - 1);
+		}
 
 		disk->head_position = 0;
 	}


