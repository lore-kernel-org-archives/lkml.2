Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab1GWKtv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 06:49:51 -0400
Received: from www.linutronix.de ([62.245.132.108]:53145 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608Ab1GWKtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 06:49:45 -0400
Date: Sat, 23 Jul 2011 12:49:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Jens Axboe <jaxboe@fusionio.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Carsten Emde <C.Emde@osadl.org>
Subject: floppy: Use del_timer_sync() in init cleanup
Message-ID: <alpine.LFD.2.02.1107231247350.2702@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Carsten Emde <C.Emde@osadl.org>

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

---
 drivers/block/floppy.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-3.0/drivers/block/floppy.c
===================================================================
--- linux-3.0.orig/drivers/block/floppy.c
+++ linux-3.0/drivers/block/floppy.c
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
