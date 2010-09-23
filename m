Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423Ab0IWTyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:54:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756270Ab0IWTyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:54:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, hch@lst.de
Subject: [PATCH 1/2] amiga floppy: Stop sharing request queue across multiple gendisks
Date: Thu, 23 Sep 2010 15:54:05 -0400
Message-Id: <1285271646-2768-2-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Use one request queue per gendisk instead of sharing request queue

o Don't have hardware. No compile testing or run time testing done. Completely
  untested.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 drivers/block/amiflop.c |   59 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 76f114f..ead8b77 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -114,8 +114,6 @@ static unsigned long int fd_def_df0 = FD_DD_3;     /* default for df0 if it does
 module_param(fd_def_df0, ulong, 0);
 MODULE_LICENSE("GPL");
 
-static struct request_queue *floppy_queue;
-
 /*
  *  Macros
  */
@@ -164,6 +162,7 @@ static volatile int selected = -1;	/* currently selected drive */
 static int writepending;
 static int writefromint;
 static char *raw_buf;
+static int fdc_queue;
 
 static DEFINE_SPINLOCK(amiflop_lock);
 
@@ -1334,6 +1333,42 @@ static int get_track(int drive, int track)
 	return -1;
 }
 
+/*
+ * Round-robin between our available drives, doing one request from each
+ */
+static struct request *set_next_request(void)
+{
+	struct request_queue *q;
+	int cnt = FD_MAX_UNITS;
+	struct request *rq;
+
+	/* Find next queue we can dispatch from */
+	fdc_queue = fdc_queue + 1;
+	if (fdc_queue == FD_MAX_UNITS)
+		fdc_queue = 0;
+
+	for(cnt = FD_MAX_UNITS; cnt > 0, cnt--) {
+
+		if (unit[fdc_queue].type->code == FD_NODRIVE) {
+			if (++fdc_queue == FD_MAX_UNITS)
+				fdc_queue = 0;
+			cotinue;
+		}
+
+		q = unit[fdc_queue].gendisk->queue;
+		if (q) {
+			rq = blk_fetch_request(q);
+			if (rq)
+				break;
+		}
+
+		if (++fdc_queue == FD_MAX_UNITS)
+			fdc_queue = 0;
+	}
+
+	return rq;
+}
+
 static void redo_fd_request(void)
 {
 	struct request *rq;
@@ -1345,7 +1380,7 @@ static void redo_fd_request(void)
 	int err;
 
 next_req:
-	rq = blk_fetch_request(floppy_queue);
+	rq = set_next_request();
 	if (!rq) {
 		/* Nothing left to do */
 		return;
@@ -1682,6 +1717,13 @@ static int __init fd_probe_drives(void)
 			continue;
 		}
 		unit[drive].gendisk = disk;
+
+		disk->queue = blk_init_queue(do_fd_request, &amiflop_lock);
+		if (!disk->queue) {
+			unit[drive].type->code = FD_NODRIVE;
+			continue;
+		}
+
 		drives++;
 		if ((unit[drive].trackbuf = kmalloc(FLOPPY_MAX_SECTORS * 512, GFP_KERNEL)) == NULL) {
 			printk("no mem for ");
@@ -1695,7 +1737,6 @@ static int __init fd_probe_drives(void)
 		disk->fops = &floppy_fops;
 		sprintf(disk->disk_name, "fd%d", drive);
 		disk->private_data = &unit[drive];
-		disk->queue = floppy_queue;
 		set_capacity(disk, 880*2);
 		add_disk(disk);
 	}
@@ -1743,11 +1784,6 @@ static int __init amiga_floppy_probe(struct platform_device *pdev)
 		goto out_irq2;
 	}
 
-	ret = -ENOMEM;
-	floppy_queue = blk_init_queue(do_fd_request, &amiflop_lock);
-	if (!floppy_queue)
-		goto out_queue;
-
 	ret = -ENODEV;
 	if (fd_probe_drives() < 1) /* No usable drives */
 		goto out_probe;
@@ -1791,7 +1827,6 @@ static int __init amiga_floppy_probe(struct platform_device *pdev)
 	return 0;
 
 out_probe:
-	blk_cleanup_queue(floppy_queue);
 out_queue:
 	free_irq(IRQ_AMIGA_CIAA_TB, NULL);
 out_irq2:
@@ -1810,9 +1845,12 @@ static int __exit amiga_floppy_remove(struct platform_device *pdev)
 
 	for( i = 0; i < FD_MAX_UNITS; i++) {
 		if (unit[i].type->code != FD_NODRIVE) {
+			struct request_queue *q = unit[i].gendisk->queue;
 			del_gendisk(unit[i].gendisk);
 			put_disk(unit[i].gendisk);
 			kfree(unit[i].trackbuf);
+			if (q)
+				blk_cleanup_queue(q);
 		}
 	}
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
@@ -1820,7 +1858,6 @@ static int __exit amiga_floppy_remove(struct platform_device *pdev)
 	free_irq(IRQ_AMIGA_DSKBLK, NULL);
 	custom.dmacon = DMAF_DISK; /* disable DMA */
 	amiga_chip_free(raw_buf);
-	blk_cleanup_queue(floppy_queue);
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 }
 #endif
-- 
1.7.2.3

