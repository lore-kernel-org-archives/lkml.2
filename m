Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab0IWUP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:15:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab0IWUP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:15:57 -0400
Date: Thu, 23 Sep 2010 16:15:48 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: hch@lst.de
Subject: Re: [PATCH 2/2] atari floppy: Stop sharing request queue across
 multiple gendisks
Message-ID: <20100923201548.GJ20338@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <1285271646-2768-3-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285271646-2768-3-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 03:54:06PM -0400, Vivek Goyal wrote:
> o Use one request queue per gendisk instead of sharing the queue.
> 
> o Don't have hardware. No compile testing or run time testing done. Completely
>   untested.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  drivers/block/ataflop.c |   50 ++++++++++++++++++++++++++++++++++++----------
>  1 files changed, 39 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
> index aceb964..bad514cb 100644
> --- a/drivers/block/ataflop.c
> +++ b/drivers/block/ataflop.c
> @@ -79,8 +79,8 @@
>  
>  #undef DEBUG
>  
> -static struct request_queue *floppy_queue;
>  static struct request *fd_request;
> +static int fdc_queue;
>  
>  /* Disk types: DD, HD, ED */
>  static struct atari_disk_type {
> @@ -1391,6 +1391,29 @@ static void setup_req_params( int drive )
>  			ReqTrack, ReqSector, (unsigned long)ReqData ));
>  }
>  
> +/*
> + * Round-robin between our available drives, doing one request from each
> + */
> +static int set_next_request(void)

While scanning the patch found one bug. set_next_request() should be 
returning "struct request *". Second version of patch is attached.


o Use one request queue per gendisk instead of sharing the queue.

o Don't have hardware. No compile testing or run time testing done. Completely
  untested.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/ataflop.c |   50 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 11 deletions(-)

Index: linux-2.6-block/drivers/block/ataflop.c
===================================================================
--- linux-2.6-block.orig/drivers/block/ataflop.c	2010-09-21 15:56:35.000000000 -0400
+++ linux-2.6-block/drivers/block/ataflop.c	2010-09-23 16:12:35.826001335 -0400
@@ -79,8 +79,8 @@
 
 #undef DEBUG
 
-static struct request_queue *floppy_queue;
 static struct request *fd_request;
+static int fdc_queue;
 
 /* Disk types: DD, HD, ED */
 static struct atari_disk_type {
@@ -1391,6 +1391,29 @@ static void setup_req_params( int drive 
 			ReqTrack, ReqSector, (unsigned long)ReqData ));
 }
 
+/*
+ * Round-robin between our available drives, doing one request from each
+ */
+static struct request *set_next_request(void)
+{
+	struct request_queue *q;
+	int old_pos = fdc_queue;
+	struct request *rq;
+
+	do {
+		q = unit[fdc_queue].disk->queue;
+		if (++fdc_queue == FD_MAX_UNITS)
+			fdc_queue = 0;
+		if (q) {
+			rq = blk_fetch_request(q);
+			if (rq)
+				break;
+		}
+	} while (fdc_queue != old_pos);
+
+	return rq;
+}
+
 
 static void redo_fd_request(void)
 {
@@ -1405,7 +1428,7 @@ static void redo_fd_request(void)
 
 repeat:
 	if (!fd_request) {
-		fd_request = blk_fetch_request(floppy_queue);
+		fd_request = set_next_request();
 		if (!fd_request)
 			goto the_end;
 	}
@@ -1932,10 +1955,6 @@ static int __init atari_floppy_init (voi
 	PhysTrackBuffer = virt_to_phys(TrackBuffer);
 	BufferDrive = BufferSide = BufferTrack = -1;
 
-	floppy_queue = blk_init_queue(do_fd_request, &ataflop_lock);
-	if (!floppy_queue)
-		goto Enomem;
-
 	for (i = 0; i < FD_MAX_UNITS; i++) {
 		unit[i].track = -1;
 		unit[i].flags = 0;
@@ -1944,7 +1963,10 @@ static int __init atari_floppy_init (voi
 		sprintf(unit[i].disk->disk_name, "fd%d", i);
 		unit[i].disk->fops = &floppy_fops;
 		unit[i].disk->private_data = &unit[i];
-		unit[i].disk->queue = floppy_queue;
+		unit[i].disk->queue = blk_init_queue(do_fd_request,
+					&ataflop_lock);
+		if (!unit[i].disk->queue)
+			goto Enomem;
 		set_capacity(unit[i].disk, MAX_DISK_SIZE * 2);
 		add_disk(unit[i].disk);
 	}
@@ -1959,10 +1981,14 @@ static int __init atari_floppy_init (voi
 
 	return 0;
 Enomem:
-	while (i--)
+	while (i--) {
+		struct request_queue *q = unit[i].disk->queue;
+
 		put_disk(unit[i].disk);
-	if (floppy_queue)
-		blk_cleanup_queue(floppy_queue);
+		if (q)
+			blk_cleanup_queue(q);
+	}
+
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 	return -ENOMEM;
 }
@@ -2011,12 +2037,14 @@ static void __exit atari_floppy_exit(voi
 	int i;
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
 	for (i = 0; i < FD_MAX_UNITS; i++) {
+		struct request_queue *q = unit[i].disk->queue;
+
 		del_gendisk(unit[i].disk);
 		put_disk(unit[i].disk);
+		blk_cleanup_queue(q);
 	}
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 
-	blk_cleanup_queue(floppy_queue);
 	del_timer_sync(&fd_timer);
 	atari_stram_free( DMABuffer );
 }
