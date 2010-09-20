Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab0ITWaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 18:30:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22385 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab0ITWaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 18:30:03 -0400
Date: Mon, 20 Sep 2010 18:30:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] floppy: switch to one queue per drive instead of sharing a
 queue (Was: Re: cgq vs bdi names, was "cfq-iosched: fix a kernel OOPs when
 usb key  is inserted")
Message-ID: <20100920223001.GJ6138@redhat.com>
References: <20100920130318.GA29565@lst.de>
 <4C975DCC.9050902@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C975DCC.9050902@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 03:12:44PM +0200, Jens Axboe wrote:
> On 2010-09-20 15:03, Christoph Hellwig wrote:
> > Hi Vivek, hi Jens,
> > 
> > where was http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff_plain;h=44c74d6292e97f8bd9adfa6b0df3cb4f3c42a6dc posted  on the mailinglist?
> > 
> > I can't find it in my lkml or fsdevel inboxes.  Either way I don't think
> > just papering over the underlying issue like this is a good idea.  
> > 
> > The big issue is that cfq tries to scanf the textual representation of
> > the dev_t from the request_queue by abusing the bdi.  But the reason why
> > we don't have a dev_t in the request_queue is that it's still not
> > unique.  If it was we could easily add a dev_t into the request_queue
> > and be done with it.
> > 
> > So the fix is either to get rid of the last remaining users of shared
> > request_queues (IIRC the various floppy drivers) and just add a dev_t
> > in the request_queue for the bdi, tracing and cfq, or add a dev_t into
> > the request_queue and add a flag for shared request queues that the
> > floppy driver and whoever needs it set and let the bdi sysfs code, cfq
> > and blocktrace ignore theis request_queue.  This will also allow to
> > get rid of the crap about ignoring failures due to already register
> > or prematurely unregistered bdis and actually add real error handling
> > to that code.
> 
> I did this one 15 months ago (according to git), but I never got it
> tested:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=7a0ebc7ea1db42a71841df6a15be9fd420fae980
> 
> IIRC, the mtd stuff also uses a shared queue. But I think that is it.
> Would indeed be VERY nice to finally get rid of that crap, it has
> technically been outlawed since 2.5.1.

Hi Jens,

I have refreshed your patch to apply on latest tree. I did testing with
one floppy controller and it was hanging because we were taking
floppy_lock both inside and outside of function set_next_request(). I got
rid of that and now atleast with one flopply controller this patch is
working fine.

I tried connecting another floppy controller to see if I see two request
queues being registered, but somehow my BIOS does not recognize two 
floppy controllers and only makes one of these operational.

Thanks
Vivek


Pretty straight forward conversion. Note that we do round-robin
between the drives that have available requests, before we simply
used the drive that the IO scheduler told us to. Since the IO
scheduler doesn't care about multiple devices per queue, the resulting
sort would not have made sense.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/floppy.c |   66 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/block/floppy.c
===================================================================
--- linux-2.6.orig/drivers/block/floppy.c	2010-09-20 13:20:18.000000000 -0400
+++ linux-2.6/drivers/block/floppy.c	2010-09-20 15:39:46.406861152 -0400
@@ -258,8 +258,8 @@ static int irqdma_allocated;
 #include <linux/completion.h>
 
 static struct request *current_req;
-static struct request_queue *floppy_queue;
 static void do_fd_request(struct request_queue *q);
+static int set_next_request(void);
 
 #ifndef fd_get_dma_residue
 #define fd_get_dma_residue() get_dma_residue(FLOPPY_DMA)
@@ -413,6 +413,7 @@ static struct gendisk *disks[N_DRIVE];
 static struct block_device *opened_bdev[N_DRIVE];
 static DEFINE_MUTEX(open_lock);
 static struct floppy_raw_cmd *raw_cmd, default_raw_cmd;
+static int fdc_queue;
 
 /*
  * This struct defines the different floppy types.
@@ -890,8 +891,8 @@ static void unlock_fdc(void)
 	del_timer(&fd_timeout);
 	cont = NULL;
 	clear_bit(0, &fdc_busy);
-	if (current_req || blk_peek_request(floppy_queue))
-		do_fd_request(floppy_queue);
+	if (current_req || set_next_request())
+		do_fd_request(current_req->q);
 	spin_unlock_irqrestore(&floppy_lock, flags);
 	wake_up(&fdc_wait);
 }
@@ -2243,8 +2244,8 @@ static void floppy_end_request(struct re
  * logical buffer */
 static void request_done(int uptodate)
 {
-	struct request_queue *q = floppy_queue;
 	struct request *req = current_req;
+	struct request_queue *q;
 	unsigned long flags;
 	int block;
 	char msg[sizeof("request done ") + sizeof(int) * 3];
@@ -2258,6 +2259,8 @@ static void request_done(int uptodate)
 		return;
 	}
 
+	q = req->q;
+
 	if (uptodate) {
 		/* maintain values for invalidation on geometry
 		 * change */
@@ -2811,6 +2814,28 @@ static int make_raw_rw_request(void)
 	return 2;
 }
 
+/*
+ * Round-robin between our available drives, doing one request from each
+ */
+static int set_next_request(void)
+{
+	struct request_queue *q;
+	int old_pos = fdc_queue;
+
+	do {
+		q = disks[fdc_queue]->queue;
+		if (++fdc_queue == N_DRIVE)
+			fdc_queue = 0;
+		if (q) {
+			current_req = blk_fetch_request(q);
+			if (current_req)
+				break;
+		}
+	} while (fdc_queue != old_pos);
+
+	return current_req != NULL;
+}
+
 static void redo_fd_request(void)
 {
 	int drive;
@@ -2822,17 +2847,17 @@ static void redo_fd_request(void)
 
 do_request:
 	if (!current_req) {
-		struct request *req;
+		int pending;
+
+		spin_lock_irq(&floppy_lock);
+		pending = set_next_request();
+		spin_unlock_irq(&floppy_lock);
 
-		spin_lock_irq(floppy_queue->queue_lock);
-		req = blk_fetch_request(floppy_queue);
-		spin_unlock_irq(floppy_queue->queue_lock);
-		if (!req) {
+		if (!pending) {
 			do_floppy = NULL;
 			unlock_fdc();
 			return;
 		}
-		current_req = req;
 	}
 	drive = (long)current_req->rq_disk->private_data;
 	set_fdc(drive);
@@ -4165,6 +4190,13 @@ static int __init floppy_init(void)
 			goto out_put_disk;
 		}
 
+		disks[dr]->queue = blk_init_queue(do_fd_request, &floppy_lock);
+		if (!disks[dr]->queue) {
+			err = -ENOMEM;
+			goto out_put_disk;
+		}
+
+		blk_queue_max_hw_sectors(disks[dr]->queue, 64);
 		disks[dr]->major = FLOPPY_MAJOR;
 		disks[dr]->first_minor = TOMINOR(dr);
 		disks[dr]->fops = &floppy_fops;
@@ -4183,13 +4215,6 @@ static int __init floppy_init(void)
 	if (err)
 		goto out_unreg_blkdev;
 
-	floppy_queue = blk_init_queue(do_fd_request, &floppy_lock);
-	if (!floppy_queue) {
-		err = -ENOMEM;
-		goto out_unreg_driver;
-	}
-	blk_queue_max_hw_sectors(floppy_queue, 64);
-
 	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
 			    floppy_find, NULL, NULL);
 
@@ -4317,7 +4342,6 @@ static int __init floppy_init(void)
 
 		/* to be cleaned up... */
 		disks[drive]->private_data = (void *)(long)drive;
-		disks[drive]->queue = floppy_queue;
 		disks[drive]->flags |= GENHD_FL_REMOVABLE;
 		disks[drive]->driverfs_dev = &floppy_device[drive].dev;
 		add_disk(disks[drive]);
@@ -4333,8 +4357,6 @@ out_flush_work:
 		floppy_release_irq_and_dma();
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
-	blk_cleanup_queue(floppy_queue);
-out_unreg_driver:
 	platform_driver_unregister(&floppy_driver);
 out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
@@ -4342,6 +4364,8 @@ out_put_disk:
 	while (dr--) {
 		del_timer(&motor_off_timer[dr]);
 		put_disk(disks[dr]);
+		if (disks[dr]->queue)
+			blk_cleanup_queue(disks[dr]->queue);
 	}
 	return err;
 }
@@ -4550,11 +4574,11 @@ static void __exit floppy_module_exit(vo
 			platform_device_unregister(&floppy_device[drive]);
 		}
 		put_disk(disks[drive]);
+		blk_cleanup_queue(disks[drive]->queue);
 	}
 
 	del_timer_sync(&fd_timeout);
 	del_timer_sync(&fd_timer);
-	blk_cleanup_queue(floppy_queue);
 
 	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
