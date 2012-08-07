Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031396Ab2HGWtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:49:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58394 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031321Ab2HGWtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:49:43 -0400
Date: Tue, 7 Aug 2012 19:49:35 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Vivek Goyal <vgoyal@redhat.com>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [ 02/70] floppy: Cleanup disk->queue before caling put_disk() if
 add_disk() was never called
Message-ID: <20120807224935.GA1008@herton-Z68MA-D2H-B3>
References: <20120807032755.803571133@decadent.org.uk>
 <20120807032756.478538531@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807032756.478538531@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 04:27:57AM +0100, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Vivek Goyal <vgoyal@redhat.com>
> 
> commit 3f9a5aabd0a9fe0e0cd308506f48963d79169aa7 upstream.
> 
> add_disk() takes gendisk reference on request queue. If driver failed during
> initialization and never called add_disk() then that extra reference is not
> taken. That reference is put in put_disk(). floppy driver allocates the
> disk, allocates queue, sets disk->queue and then relizes that floppy
> controller is not present. It tries to tear down everything and tries to
> put a reference down in put_disk() which was never taken.
> 
> In such error cases cleanup disk->queue before calling put_disk() so that
> we never try to put down a reference which was never taken in first place.
> 
> Reported-and-tested-by: Suresh Jayaraman <sjayaraman@suse.com>
> Tested-by: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/block/floppy.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 510fb10..401ba78 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -4368,8 +4368,14 @@ out_unreg_blkdev:
>  out_put_disk:
>  	while (dr--) {
>  		del_timer_sync(&motor_off_timer[dr]);
> -		if (disks[dr]->queue)
> +		if (disks[dr]->queue) {
>  			blk_cleanup_queue(disks[dr]->queue);
> +			/*
> +			 * put_disk() is not paired with add_disk() and
> +			 * will put queue reference one extra time. fix it.
> +			 */
> +			disks[dr]->queue = NULL;
> +		}
>  		put_disk(disks[dr]);
>  	}
>  	return err;

I was taking a look at this, and noticed some issues with the error
handling:
* missing cleanup (put_disk) if blk_init_queue fails, dr is decremented
  first in the error handling loop
* if something fails in the add_disk loop, there is no cleanup of
  previous iterations in the error handling.
* if (disks[dr]->queue) check is bogus, when reaching there for each dr
  should exist an queue allocated, and it doesn't take into account
  iterations where add_disk wasn't done, if failure happens in add_disk
  loop.
* floppy_module_exit doesn't reset queue pointer if add_disk wasn't
  done.

I think the more complete diff below (not build tested) is needed, comments?

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c864add..bcde217 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4178,6 +4178,7 @@ static int __init floppy_init(void)
 {
 	int i, unit, drive;
 	int err, dr;
+	int drive_cnt = -1;
 
 	set_debugt();
 	interruptjiffies = resultjiffies = jiffies;
@@ -4198,6 +4199,7 @@ static int __init floppy_init(void)
 
 		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
 		if (!disks[dr]->queue) {
+			put_disk(disks[dr]);
 			err = -ENOMEM;
 			goto out_put_disk;
 		}
@@ -4357,7 +4359,16 @@ static int __init floppy_init(void)
 
 out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
+	drive_cnt = drive - 1;
 out_flush_work:
+        while (drive--) {
+                if ((allowed_drive_mask & (1 << drive)) &&
+                    fdc_state[FDC(drive)].version != FDC_NONE) {
+                        del_gendisk(disks[drive]);
+                        device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
+                        platform_device_unregister(&floppy_device[drive]);
+                }
+        }
 	flush_work_sync(&floppy_work);
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
@@ -4369,14 +4380,14 @@ out_unreg_blkdev:
 out_put_disk:
 	while (dr--) {
 		del_timer_sync(&motor_off_timer[dr]);
-		if (disks[dr]->queue) {
-			blk_cleanup_queue(disks[dr]->queue);
-			/*
-			 * put_disk() is not paired with add_disk() and
-			 * will put queue reference one extra time. fix it.
-			 */
+		blk_cleanup_queue(disks[dr]->queue);
+		/*
+		 * put_disk() may not be paired with add_disk() and
+		 * will put queue reference one extra time. fix it.
+		 */
+		if (dr > drive_cnt || !(allowed_drive_mask & (1 << dr)) ||
+		    fdc_state[FDC(dr)].version == FDC_NONE)
 			disks[dr]->queue = NULL;
-		}
 		put_disk(disks[dr]);
 	}
 	return err;
@@ -4584,8 +4595,15 @@ static void __exit floppy_module_exit(void)
 			del_gendisk(disks[drive]);
 			device_remove_file(&floppy_device[drive].dev, &dev_attr_cmos);
 			platform_device_unregister(&floppy_device[drive]);
+			blk_cleanup_queue(disks[drive]->queue);
+		} else {
+			blk_cleanup_queue(disks[drive]->queue);
+			/*
+			 * put_disk() is not paired with add_disk() and
+			 * will put queue reference one extra time. fix it.
+			 */
+			disks[drive]->queue = NULL;
 		}
-		blk_cleanup_queue(disks[drive]->queue);
 		put_disk(disks[drive]);
 	}
 

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
[]'s
Herton
