Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0FISya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:54:30 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758232Ab0FISyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:22 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183625.577854857@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] floppy: use atomic type for usage_count
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-usage-atomic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage_count was being protected by a lock which
was only there to create an atomic counter.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


--- a/drivers/block/floppy.c	2010-06-08 23:08:20.846622833 -0700
+++ b/drivers/block/floppy.c	2010-06-08 23:08:23.326715957 -0700
@@ -578,7 +578,7 @@ static void reset_fdc(void);
 #define NEED_1_RECAL	-2
 #define NEED_2_RECAL	-3
 
-static int usage_count;
+static atomic_t usage_count = ATOMIC_INIT(0);
 
 /* buffer related variables */
 static int buffer_track = -1;
@@ -860,7 +860,7 @@ static void set_fdc(int drive)
 /* locks the driver */
 static int _lock_fdc(int drive, bool interruptible, int line)
 {
-	if (!usage_count) {
+	if (atomic_read(&usage_count) == 0) {
 		pr_err("Trying to lock fdc while usage count=0 at line %d\n",
 		       line);
 		return -1;
@@ -2941,7 +2941,7 @@ static void do_fd_request(struct request
 		return;
 	}
 
-	if (usage_count == 0) {
+	if (atomic_read(&usage_count) == 0) {
 		pr_info("warning: usage count=0, current_req=%p exiting\n",
 			current_req);
 		pr_info("sect=%ld type=%x flags=%x\n",
@@ -3858,7 +3858,7 @@ static int floppy_revalidate(struct gend
 	if (test_bit(FD_DISK_CHANGED_BIT, &UDRS->flags) ||
 	    test_bit(FD_VERIFY_BIT, &UDRS->flags) ||
 	    test_bit(drive, &fake_change) || NO_GEOM) {
-		if (usage_count == 0) {
+		if (atomic_read(&usage_count) == 0) {
 			pr_info("VFS: revalidate called on non-open device.\n");
 			return -EFAULT;
 		}
@@ -4357,7 +4357,7 @@ out_unreg_platform_dev:
 	platform_device_unregister(&floppy_device[drive]);
 out_flush_work:
 	flush_scheduled_work();
-	if (usage_count)
+	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 out_unreg_region:
 	blk_unregister_region(MKDEV(FLOPPY_MAJOR, 0), 256);
@@ -4374,8 +4374,6 @@ out_put_disk:
 	return err;
 }
 
-static DEFINE_SPINLOCK(floppy_usage_lock);
-
 static const struct io_region {
 	int offset;
 	int size;
@@ -4421,14 +4419,8 @@ static void floppy_release_regions(int f
 
 static int floppy_grab_irq_and_dma(void)
 {
-	unsigned long flags;
-
-	spin_lock_irqsave(&floppy_usage_lock, flags);
-	if (usage_count++) {
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
+	if (atomic_inc_return(&usage_count) > 1)
 		return 0;
-	}
-	spin_unlock_irqrestore(&floppy_usage_lock, flags);
 
 	/*
 	 * We might have scheduled a free_irq(), wait it to
@@ -4439,9 +4431,7 @@ static int floppy_grab_irq_and_dma(void)
 	if (fd_request_irq()) {
 		DPRINT("Unable to grab IRQ%d for the floppy driver\n",
 		       FLOPPY_IRQ);
-		spin_lock_irqsave(&floppy_usage_lock, flags);
-		usage_count--;
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
+		atomic_dec(&usage_count);
 		return -1;
 	}
 	if (fd_request_dma()) {
@@ -4451,9 +4441,7 @@ static int floppy_grab_irq_and_dma(void)
 			use_virtual_dma = can_use_virtual_dma = 1;
 		if (!(can_use_virtual_dma & 1)) {
 			fd_free_irq();
-			spin_lock_irqsave(&floppy_usage_lock, flags);
-			usage_count--;
-			spin_unlock_irqrestore(&floppy_usage_lock, flags);
+			atomic_dec(&usage_count);
 			return -1;
 		}
 	}
@@ -4488,9 +4476,7 @@ cleanup:
 	fd_free_dma();
 	while (--fdc >= 0)
 		floppy_release_regions(fdc);
-	spin_lock_irqsave(&floppy_usage_lock, flags);
-	usage_count--;
-	spin_unlock_irqrestore(&floppy_usage_lock, flags);
+	atomic_dec(&usage_count);
 	return -1;
 }
 
@@ -4502,14 +4488,10 @@ static void floppy_release_irq_and_dma(v
 #endif
 	long tmpsize;
 	unsigned long tmpaddr;
-	unsigned long flags;
 
-	spin_lock_irqsave(&floppy_usage_lock, flags);
-	if (--usage_count) {
-		spin_unlock_irqrestore(&floppy_usage_lock, flags);
+	if (!atomic_dec_and_test(&usage_count))
 		return;
-	}
-	spin_unlock_irqrestore(&floppy_usage_lock, flags);
+
 	if (irqdma_allocated) {
 		fd_disable_dma();
 		fd_free_dma();
@@ -4602,7 +4584,7 @@ static void __exit floppy_module_exit(vo
 	del_timer_sync(&fd_timer);
 	blk_cleanup_queue(floppy_queue);
 
-	if (usage_count)
+	if (atomic_read(&usage_count))
 		floppy_release_irq_and_dma();
 
 	/* eject disk, if any */


