Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab1DBHCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 03:02:39 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:59186 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab1DBHCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 03:02:00 -0400
From: Len Brown <lenb@kernel.org>
To: linux-pm@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        x86@kernel.org
Subject: [PATCH 14/18] 2.6.40: x86 idle floppy: remove deprecated
 disable_hlt()/enable_hlt()
Date: Sat, 02 Apr 2011 02:22:56 -0400
Message-id: <a3bdf53d052bdf39539840eff4cd3dd515865945.1301724243.git.len.brown@intel.com>
X-Mailer: git-send-email 1.7.5.rc0
In-reply-to: <1301725380-10579-1-git-send-email-lenb@kernel.org>
References: <alpine.LFD.2.02.1104010020280.2797@x980>
 <1301725380-10579-1-git-send-email-lenb@kernel.org>
In-reply-to: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

The X86_32-only disable_hlt/enable_hlt mechanism was used
by the 32-bit floppy driver.  Its effect was to replace
the use of the HLT instruction inside default_idle() with
cpu_relax().

This workaround was commented:
"disable hlt during certain critical i/o operations"

"This halt magic was a workaround for ancient floppy DMA
 wreckage. It should be safe to remove."

Remove the workaround to simplify the idle loop.

cc: x86@kernel.org
Signed-off-by: Len Brown <len.brown@intel.com>
---
 Documentation/feature-removal-schedule.txt |    8 ------
 arch/x86/include/asm/system.h              |    7 -----
 arch/x86/kernel/process.c                  |   24 ------------------
 drivers/block/floppy.c                     |   36 ----------------------------
 4 files changed, 0 insertions(+), 75 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 720e698..e1e9bf8 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -6,14 +6,6 @@ be removed from this file.
 
 ---------------------------
 
-What:	x86 floppy disable_hlt
-When:	2.6.40
-Why:	ancient workaround of dubious utility clutters the
-	code used by everybody else.
-Who:	Len Brown <len.brown@intel.com>
-
----------------------------
-
 What:	CONFIG_APM_CPU_IDLE, and its ability to call APM BIOS in idle
 When:	2.6.40
 Why:	This optional sub-feature of APM is of dubious reliability,
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
index c485629..09bd118 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -344,34 +344,10 @@ void (*pm_idle)(void);
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
-	return !hlt_counter;
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
index 41ea03f..9a4e006 100644
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
-	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2.6.40");
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
1.7.5.rc0

