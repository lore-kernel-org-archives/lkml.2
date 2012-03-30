Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240Ab2C3I4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:56:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759611Ab2C3I4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:56:39 -0400
Date: Fri, 30 Mar 2012 01:56:09 -0700
From: tip-bot for Len Brown <len.brown@intel.com>
Message-ID: <tip-3rhk9bzf0x9rljkv488tloib@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        jwboyer@redhat.com, akpm@linux-foundation.org, stable@kernel.org,
        tglx@linutronix.de, len.brown@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, jwboyer@redhat.com,
        torvalds@linux-foundation.org, stable@kernel.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk, len.brown@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  Remove the ancient and deprecated disable_hlt() and enable_hlt() facility
Git-Commit-ID: f6365201d8a21fb347260f89d6e9b3e718d63c70
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 30 Mar 2012 01:56:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6365201d8a21fb347260f89d6e9b3e718d63c70
Gitweb:     http://git.kernel.org/tip/f6365201d8a21fb347260f89d6e9b3e718d63c70
Author:     Len Brown <len.brown@intel.com>
AuthorDate: Thu, 29 Mar 2012 14:49:17 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 30 Mar 2012 08:50:27 +0200

x86: Remove the ancient and deprecated disable_hlt() and enable_hlt() facility

The X86_32-only disable_hlt/enable_hlt mechanism was used by the
32-bit floppy driver. Its effect was to replace the use of the
HLT instruction inside default_idle() with cpu_relax() - essentially
it turned off the use of HLT.

This workaround was commented in the code as:

 "disable hlt during certain critical i/o operations"

 "This halt magic was a workaround for ancient floppy DMA
  wreckage. It should be safe to remove."

H. Peter Anvin additionally adds:

 "To the best of my knowledge, no-hlt only existed because of
  flaky power distributions on 386/486 systems which were sold to
  run DOS.  Since DOS did no power management of any kind,
  including HLT, the power draw was fairly uniform; when exposed
  to the much hhigher noise levels you got when Linux used HLT
  caused some of these systems to fail.

  They were by far in the minority even back then."

Alan Cox further says:

 "Also for the Cyrix 5510 which tended to go castors up if a HLT
  occurred during a DMA cycle and on a few other boxes HLT during
  DMA tended to go astray.

  Do we care ? I doubt it. The 5510 was pretty obscure, the 5520
  fixed it, the 5530 is probably the oldest still in any kind of
  use."

So, let's finally drop this.

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: "H. Peter Anvin" <hpa@zytor.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Hemminger <shemminger@vyatta.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/n/tip-3rhk9bzf0x9rljkv488tloib@git.kernel.org
[ If anyone cares then alternative instruction patching could be
  used to replace HLT with a one-byte NOP instruction. Much simpler. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/feature-removal-schedule.txt |    8 ------
 arch/x86/include/asm/processor.h           |   10 -------
 arch/x86/kernel/process.c                  |   24 ------------------
 drivers/block/floppy.c                     |   36 ----------------------------
 4 files changed, 0 insertions(+), 78 deletions(-)

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
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7284c9a..4fa7dcc 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -974,16 +974,6 @@ extern bool cpu_has_amd_erratum(const int *);
 #define cpu_has_amd_erratum(x)	(false)
 #endif /* CONFIG_CPU_SUP_AMD */
 
-#ifdef CONFIG_X86_32
-/*
- * disable hlt during certain critical i/o operations
- */
-#define HAVE_DISABLE_HLT
-#endif
-
-void disable_hlt(void);
-void enable_hlt(void);
-
 void cpu_idle_wait(void);
 
 extern unsigned long arch_align_stack(unsigned long sp);
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index a33afaa..1d92a5a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -362,34 +362,10 @@ void (*pm_idle)(void);
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
 
 #ifndef CONFIG_SMP
 static inline void play_dead(void)
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 76a0823..b0b00d7 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -1030,37 +1030,6 @@ static int fd_wait_for_completion(unsigned long delay, timeout_fn function)
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
@@ -1105,7 +1074,6 @@ static void setup_DMA(void)
 	fd_enable_dma();
 	release_dma_lock(f);
 #endif
-	floppy_disable_hlt();
 }
 
 static void show_floppy(void);
@@ -1707,7 +1675,6 @@ irqreturn_t floppy_interrupt(int irq, void *dev_id)
 	fd_disable_dma();
 	release_dma_lock(f);
 
-	floppy_enable_hlt();
 	do_floppy = NULL;
 	if (fdc >= N_FDC || FDCS->address == -1) {
 		/* we don't even know which FDC is the culprit */
@@ -1856,8 +1823,6 @@ static void floppy_shutdown(unsigned long data)
 		show_floppy();
 	cancel_activity();
 
-	floppy_enable_hlt();
-
 	flags = claim_dma_lock();
 	fd_disable_dma();
 	release_dma_lock(flags);
@@ -4508,7 +4473,6 @@ static void floppy_release_irq_and_dma(void)
 #if N_FDC > 1
 	set_dor(1, ~8, 0);
 #endif
-	floppy_enable_hlt();
 
 	if (floppy_track_buffer && max_buffer_sectors) {
 		tmpsize = max_buffer_sectors * 1024;
