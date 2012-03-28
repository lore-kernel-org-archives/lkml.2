Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013Ab2C1PDQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 11:03:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755458Ab2C1PDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 11:03:15 -0400
Date: Wed, 28 Mar 2012 11:03:00 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Ingo Molnar <mingo@kernel.org>, Len Brown <len.brown@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH v3] x86: Remove deprecated disable_hlt and enable_hlt
Message-ID: <20120328150300.GH1997@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <lenb@intel.com>

The X86_32-only disable_hlt/enable_hlt mechanism was used by the 32-bit
floppy driver. Its effect was to replace the use of the HLT instruction
inside default_idle() with cpu_relax().

This workaround was commented:
"disable hlt during certain critical i/o operations"

"This halt magic was a workaround for ancient floppy DMA wreckage. It should
be safe to remove."

H. Peter Anvin additionally adds:

"To the best of my knowledge, no-hlt only existed because of flaky power
distributions on 386/486 systems which were sold to run DOS.  Since DOS
did no power management of any kind, including HLT, the power draw was
fairly uniform; when exposed to the much hhigher noise levels you got
when Linux used HLT caused some of these systems to fail.

They were by far in the minority even back then."

Alan Cox further says:

"Also for the Cyrix 5510 which tended to go castors up if a HLT occurred
during a DMA cycle and on a few other boxes HLT during DMA tended to go
astray.

Do we care ? I doubt it. The 5510 was pretty obscure, the 5520 fixed it,
the 5530 is probably the oldest still in any kind of use."

So, let's finally drop this.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

Rebased to 3.4-rc0

 Documentation/feature-removal-schedule.txt |    8 -------
 arch/x86/include/asm/system.h              |    7 ------
 arch/x86/kernel/process.c                  |   24 -------------------
 drivers/block/floppy.c                     |   36 ----------------------------
 4 files changed, 75 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 0cad480..7c950d4 100644
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
diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 2d2f01c..d75adff 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -93,10 +93,6 @@ do {									\
 			"memory");					\
 } while (0)
 
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
 #else
 
 /* frame pointer must be last for get_wchan */
@@ -392,9 +388,6 @@ static inline void clflush(volatile void *__p)
 
 #define nop() asm volatile ("nop")
 
-void disable_hlt(void);
-void enable_hlt(void);
-
 void cpu_idle_wait(void);
 
 extern unsigned long arch_align_stack(unsigned long sp);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 14baf78..7f9cecf 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -342,34 +342,10 @@ void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 #endif
 
-#ifdef CONFIG_X86_32
-/*
- * This halt magic was a workaround for ancient floppy DMA
- * wreckage. It should be safe to remove.
- */
-static int hlt_counter;
-void disable_hlt(void)
-{
-	hlt_counter++;
-}
-EXPORT_SYMBOL(disable_hlt);
-
-void enable_hlt(void)
-{
-	hlt_counter--;
-}
-EXPORT_SYMBOL(enable_hlt);
-
-static inline int hlt_use_halt(void)
-{
-	return (!hlt_counter && boot_cpu_data.hlt_works_ok);
-}
-#else
 static inline int hlt_use_halt(void)
 {
 	return 1;
 }
-#endif
 
 /*
  * We use this if we don't have any better
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 744f078..fd14862 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1031,37 +1031,6 @@ static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
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
@@ -1106,7 +1075,6 @@ static void setup_DMA(void)
 	fd_enable_dma();
 	release_dma_lock(f);
 #endif
-	floppy_disable_hlt();
 }
 
 static void show_floppy(void);
@@ -1708,7 +1676,6 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	fd_disable_dma();
 	release_dma_lock(f);
 
-	floppy_enable_hlt();
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
@@ -1857,8 +1824,6 @@ static void floppy_shutdown(unsigned long data)
 		show_floppy();
 	cancel_activity();
 
-	floppy_enable_hlt();
-
 	flags = claim_dma_lock();
 	fd_disable_dma();
 	release_dma_lock(flags);
@@ -4509,7 +4474,6 @@ static void floppy_release_irq_and_dma(void)
 #if N_FDC > 1
 	set_dor(1, ~8, 0);
 #endif
-	floppy_enable_hlt();
 
 	if (floppy_track_buffer && max_buffer_sectors) {
 		tmpsize = max_buffer_sectors * 1024;
-- 
1.7.9.3

