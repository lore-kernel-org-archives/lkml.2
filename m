Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154Ab2FGEVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:21:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab2FGEVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:21:42 -0400
Message-Id: <20120607040347.933458983@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:04:54 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>,
        NeilBrown <neilb@suse.de>
Subject: [ 78/82] md: raid1/raid10: fix problem with merge_bvec_fn
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit aba336bd1d46d6b0404b06f6915ed76150739057 upstream.

The new merge_bvec_fn which calls the corresponding function
in subsidiary devices requires that mddev->merge_check_needed
be set if any child has a merge_bvec_fn.

However were were only setting that when a device was hot-added,
not when a device was present from the start.

This bug was introduced in 3.4 so patch is suitable for 3.4.y
kernels.  However that are conflicts in raid10.c so a separate
patch will be needed for 3.4.y.

Reported-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid1.c  |    4 ++++
 drivers/md/raid10.c |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2548,6 +2548,7 @@ static struct r1conf *setup_conf(struct
 	err = -EINVAL;
 	spin_lock_init(&conf->device_lock);
 	rdev_for_each(rdev, mddev) {
+		struct request_queue *q;
 		int disk_idx = rdev->raid_disk;
 		if (disk_idx >= mddev->raid_disks
 		    || disk_idx < 0)
@@ -2560,6 +2561,9 @@ static struct r1conf *setup_conf(struct
 		if (disk->rdev)
 			goto abort;
 		disk->rdev = rdev;
+		q = bdev_get_queue(rdev->bdev);
+		if (q->merge_bvec_fn)
+			mddev->merge_check_needed = 1;
 
 		disk->head_position = 0;
 	}
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3311,7 +3311,7 @@ static int run(struct mddev *mddev)
 				 (conf->raid_disks / conf->near_copies));
 
 	rdev_for_each(rdev, mddev) {
-
+		struct request_queue *q;
 		disk_idx = rdev->raid_disk;
 		if (disk_idx >= conf->raid_disks
 		    || disk_idx < 0)
@@ -3327,6 +3327,9 @@ static int run(struct mddev *mddev)
 				goto out_free_conf;
 			disk->rdev = rdev;
 		}
+		q = bdev_get_queue(rdev->bdev);
+		if (q->merge_bvec_fn)
+			mddev->merge_check_needed = 1;
 
 		disk_stack_limits(mddev->gendisk, rdev->bdev,
 				  rdev->data_offset << 9);


