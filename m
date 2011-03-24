Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab1CXHI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:08:58 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:46230 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933258Ab1CXHIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:08:53 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 4/5] x86 idle floppy: delete disable_hlt()/enable_hlt()
Date: Thu, 24 Mar 2011 03:08:27 -0400
Message-id: <fb07f62522099f5d3f2b7aa6014329d716081b62.1300950095.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-reply-to: <1300950508-22746-1-git-send-email-lenb@kernel.org>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
In-reply-to: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1300950095.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The X86_32-only disable_hlt/enable_hlt mechanism was used
by the 32-bit floppy driver.  Its effect was to replace
the use of the HLT instruction inside default_idle() with
cpu_relax().

Unlcear why this workaround was ever needed, it was commented:

floppy.c said:

"disable hlt during certain critical i/o operations"

x86/kernel/process.c said:

"This halt magic was a workaround for ancient floppy DMA
 wreckage. It should be safe to remove."

So remove it, as it allows us to simplify the x86 idle code.

Signed-off-by: Len Brown <len.brown@intel.com>
---
 arch/x86/include/asm/system.h |    7 -------
 arch/x86/kernel/process.c     |   24 ------------------------
 drivers/block/floppy.c        |   35 -----------------------------------
 3 files changed, 0 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 33ecc3e..013dd42 100644
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
 #define __SAVE(reg, offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
 #define __RESTORE(reg, offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
@@ -337,9 +333,6 @@ static inline void clflush(volatile void *__p)
 
 #define nop() asm volatile ("nop")
 
-void disable_hlt(void);
-void enable_hlt(void);
-
 void cpu_idle_wait(void);
 
 extern unsigned long arch_align_stack(unsigned long sp);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index cd461c3..8688ade 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -342,34 +342,10 @@ EXPORT_SYMBOL(boot_option_idle_override);
 void (*pm_idle)(void);
 EXPORT_SYMBOL(pm_idle);
 
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
-	return (!hlt_counter);
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
index 77fc76f..9a4e006 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1032,36 +1032,6 @@ static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
 	return 0;
 }
 
-static DEFINE_SPINLOCK(floppy_hlt_lock);
-static int hlt_disabled;
-static void floppy_disable_hlt(void)
-{
-	unsigned long flags;
-
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
@@ -1106,7 +1076,6 @@ static void setup_DMA(void)
 	fd_enable_dma();
 	release_dma_lock(f);
 #endif
-	floppy_disable_hlt();
 }
 
 static void show_floppy(void);
@@ -1708,7 +1677,6 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	fd_disable_dma();
 	release_dma_lock(f);
 
-	floppy_enable_hlt();
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
@@ -1857,8 +1825,6 @@ static void floppy_shutdown(unsigned long data)
 		show_floppy();
 	cancel_activity();
 
-	floppy_enable_hlt();
-
 	flags = claim_dma_lock();
 	fd_disable_dma();
 	release_dma_lock(flags);
@@ -4503,7 +4469,6 @@ static void floppy_release_irq_and_dma(void)
 #if N_FDC > 1
 	set_dor(1, ~8, 0);
 #endif
-	floppy_enable_hlt();
 
 	if (floppy_track_buffer && max_buffer_sectors) {
 		tmpsize = max_buffer_sectors * 1024;
-- 
1.7.4.1.343.ga91df

