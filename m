Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743Ab1I1Woy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:44:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54354 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932642Ab1I1Wov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:44:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:40 2011
Message-Id: <20110928220140.301474940@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:01:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Carsten Emde <C.Emde@osadl.org>, Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [142/244] floppy: use del_timer_sync() in init cleanup
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Carsten Emde <C.Emde@osadl.org>

commit 6c4867f6469964e34c5f4ee229a2a7f71a34c7ff upstream.

When no floppy is found the module code can be released while a timer
function is pending or about to be executed.

CPU0                                  CPU1
				      floppy_init()
timer_softirq()
   spin_lock_irq(&base->lock);
   detach_timer();
   spin_unlock_irq(&base->lock);
   -> Interrupt
					del_timer();
				        return -ENODEV;
                                      module_cleanup();
   <- EOI
   call_timer_fn();
   OOPS

Use del_timer_sync() to prevent this.

Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/floppy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4250,7 +4250,7 @@ static int __init floppy_init(void)
 	use_virtual_dma = can_use_virtual_dma & 1;
 	fdc_state[0].address = FDC1;
 	if (fdc_state[0].address == -1) {
-		del_timer(&fd_timeout);
+		del_timer_sync(&fd_timeout);
 		err = -ENODEV;
 		goto out_unreg_region;
 	}
@@ -4261,7 +4261,7 @@ static int __init floppy_init(void)
 	fdc = 0;		/* reset fdc in case of unexpected interrupt */
 	err = floppy_grab_irq_and_dma();
 	if (err) {
-		del_timer(&fd_timeout);
+		del_timer_sync(&fd_timeout);
 		err = -EBUSY;
 		goto out_unreg_region;
 	}
@@ -4318,7 +4318,7 @@ static int __init floppy_init(void)
 		user_reset_fdc(-1, FD_RESET_ALWAYS, false);
 	}
 	fdc = 0;
-	del_timer(&fd_timeout);
+	del_timer_sync(&fd_timeout);
 	current_drive = 0;
 	initialized = true;
 	if (have_no_fdc) {
@@ -4368,7 +4368,7 @@ out_unreg_blkdev:
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
 out_put_disk:
 	while (dr--) {
-		del_timer(&motor_off_timer[dr]);
+		del_timer_sync(&motor_off_timer[dr]);
 		if (disks[dr]->queue)
 			blk_cleanup_queue(disks[dr]->queue);
 		put_disk(disks[dr]);


