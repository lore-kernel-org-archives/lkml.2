Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab0HLAFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:05:09 -0400
Received: from kroah.org ([198.145.64.141]:60399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759308Ab0HLAEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:48 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:28 2010
Message-Id: <20100812000128.219189622@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:01:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        NeilBrown <neilb@suse.de>
Subject: [54/54] md/raid1: delay reads that could overtake behind-writes.
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: NeilBrown <neilb@suse.de>

commit e555190d82c0f58e825e3cbd9e6ebe2e7ac713bd upstream.

When a raid1 array is configured to support write-behind
on some devices, it normally only reads from other devices.
If all devices are write-behind (because the rest have failed)
it is possible for a read request to be serviced before a
behind-write request, which would appear as data corruption.

So when forced to read from a WriteMostly device, wait for any
write-behind to complete, and don't start any more behind-writes.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/md/bitmap.c |    4 +++-
 drivers/md/bitmap.h |    1 +
 drivers/md/raid1.c  |   25 ++++++++++++++++++-------
 3 files changed, 22 insertions(+), 8 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1351,7 +1351,8 @@ void bitmap_endwrite(struct bitmap *bitm
 {
 	if (!bitmap) return;
 	if (behind) {
-		atomic_dec(&bitmap->behind_writes);
+		if (atomic_dec_and_test(&bitmap->behind_writes))
+			wake_up(&bitmap->behind_wait);
 		PRINTK(KERN_DEBUG "dec write-behind count %d/%d\n",
 		  atomic_read(&bitmap->behind_writes), bitmap->max_write_behind);
 	}
@@ -1675,6 +1676,7 @@ int bitmap_create(mddev_t *mddev)
 	atomic_set(&bitmap->pending_writes, 0);
 	init_waitqueue_head(&bitmap->write_wait);
 	init_waitqueue_head(&bitmap->overflow_wait);
+	init_waitqueue_head(&bitmap->behind_wait);
 
 	bitmap->mddev = mddev;
 
--- a/drivers/md/bitmap.h
+++ b/drivers/md/bitmap.h
@@ -239,6 +239,7 @@ struct bitmap {
 	atomic_t pending_writes; /* pending writes to the bitmap file */
 	wait_queue_head_t write_wait;
 	wait_queue_head_t overflow_wait;
+	wait_queue_head_t behind_wait;
 
 	struct sysfs_dirent *sysfs_can_clear;
 };
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -866,6 +866,15 @@ static int make_request(struct request_q
 		}
 		mirror = conf->mirrors + rdisk;
 
+		if (test_bit(WriteMostly, &mirror->rdev->flags) &&
+		    bitmap) {
+			/* Reading from a write-mostly device must
+			 * take care not to over-take any writes
+			 * that are 'behind'
+			 */
+			wait_event(bitmap->behind_wait,
+				   atomic_read(&bitmap->behind_writes) == 0);
+		}
 		r1_bio->read_disk = rdisk;
 
 		read_bio = bio_clone(bio, GFP_NOIO);
@@ -943,10 +952,14 @@ static int make_request(struct request_q
 		set_bit(R1BIO_Degraded, &r1_bio->state);
 	}
 
-	/* do behind I/O ? */
+	/* do behind I/O ?
+	 * Not if there are too many, or cannot allocate memory,
+	 * or a reader on WriteMostly is waiting for behind writes
+	 * to flush */
 	if (bitmap &&
 	    (atomic_read(&bitmap->behind_writes)
 	     < mddev->bitmap_info.max_write_behind) &&
+	    !waitqueue_active(&bitmap->behind_wait) &&
 	    (behind_pages = alloc_behind_pages(bio)) != NULL)
 		set_bit(R1BIO_BehindIO, &r1_bio->state);
 
@@ -2153,15 +2166,13 @@ static int stop(mddev_t *mddev)
 {
 	conf_t *conf = mddev->private;
 	struct bitmap *bitmap = mddev->bitmap;
-	int behind_wait = 0;
 
 	/* wait for behind writes to complete */
-	while (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
-		behind_wait++;
-		printk(KERN_INFO "raid1: behind writes in progress on device %s, waiting to stop (%d)\n", mdname(mddev), behind_wait);
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		schedule_timeout(HZ); /* wait a second */
+	if (bitmap && atomic_read(&bitmap->behind_writes) > 0) {
+		printk(KERN_INFO "raid1: behind writes in progress on device %s, waiting to stop.\n", mdname(mddev));
 		/* need to kick something here to make sure I/O goes? */
+		wait_event(bitmap->behind_wait,
+			   atomic_read(&bitmap->behind_writes) == 0);
 	}
 
 	raise_barrier(conf);


