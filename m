Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266Ab1J1T6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 15:58:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932661Ab1J1T6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 15:58:43 -0400
Date: Fri, 28 Oct 2011 15:58:32 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>, Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] floppy: Remove _hlt related functions
Message-ID: <20111028195832.GC28833@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's close enough to 2012 and the WARN_ONCE is causing things like abrt to
auto-file bugs that aren't really bugs.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index d5ac362..df1e87c 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,14 +6,6 @@ be removed from this file.
 
 ---------------------------
 
-What:	x86 floppy disable_hlt
-When:	2012
-Why:	ancient workaround of dubious utility clutters the
-	code used by everybody else.
-Who:	Len Brown <len.brown@intel.com>
-
----------------------------
-
 What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
 When:	2012
 Why:	This optional sub-feature of APM is of dubious reliability,
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 9955a53..40bf4c2 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1032,37 +1032,6 @@ static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
 	return 0;
 }
 
-static DEFINE_SPINLOCK(floppy_hlt_lock);
-static int hlt_disabled;
-static void floppy_disable_hlt(void)
-{
-	unsigned long flags;
-
-	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
-	spin_lock_irqsave(&floppy_hlt_lock, flags);
-	if (!hlt_disabled) {
-		hlt_disabled = 1;
-#ifdef HAVE_DISABLE_HLT
-		disable_hlt();
-#endif
-	}
-	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
-}
-
-static void floppy_enable_hlt(void)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&floppy_hlt_lock, flags);
-	if (hlt_disabled) {
-		hlt_disabled = 0;
-#ifdef HAVE_DISABLE_HLT
-		enable_hlt();
-#endif
-	}
-	spin_unlock_irqrestore(&floppy_hlt_lock, flags);
-}
-
 static void setup_DMA(void)
 {
 	unsigned long f;
@@ -1107,7 +1076,6 @@ static void setup_DMA(void)
 	fd_enable_dma();
 	release_dma_lock(f);
 #endif
-	floppy_disable_hlt();
 }
 
 static void show_floppy(void);
@@ -1709,7 +1677,6 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	fd_disable_dma();
 	release_dma_lock(f);
 
-	floppy_enable_hlt();
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
@@ -1858,8 +1825,6 @@ static void floppy_shutdown(unsigned long data)
 		show_floppy();
 	cancel_activity();
 
-	floppy_enable_hlt();
-
 	flags = claim_dma_lock();
 	fd_disable_dma();
 	release_dma_lock(flags);
@@ -4504,7 +4469,6 @@ static void floppy_release_irq_and_dma(void)
 #if N_FDC > 1
 	set_dor(1, ~8, 0);
 #endif
-	floppy_enable_hlt();
 
 	if (floppy_track_buffer && max_buffer_sectors) {
 		tmpsize = max_buffer_sectors * 1024;
-- 
1.7.6.4

