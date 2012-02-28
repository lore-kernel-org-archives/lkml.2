Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030399Ab2B1TqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:46:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:52220 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310Ab2B1TqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:46:06 -0500
Message-Id: <20120228194508.624811514@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 28 Feb 2012 19:46:05 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch 4/4] ia64: vsyscall: Use seqcount instead of seqlock
References: <20120228194200.180923135@linutronix.de>
Content-Disposition: inline; filename=ia64-vdso-use-seqcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update of the vdso data happens under xtime_lock, so adding a
nested lock is pointless. Just use a seqcount to sync the readers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
---
 arch/ia64/kernel/asm-offsets.c        |    4 ++--
 arch/ia64/kernel/fsys.S               |    2 +-
 arch/ia64/kernel/fsyscall_gtod_data.h |    2 +-
 arch/ia64/kernel/time.c               |   10 +++-------
 4 files changed, 7 insertions(+), 11 deletions(-)

Index: linux-2.6/arch/ia64/kernel/asm-offsets.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/asm-offsets.c
+++ linux-2.6/arch/ia64/kernel/asm-offsets.c
@@ -269,8 +269,8 @@ void foo(void)
 	BLANK();
 
 	/* used by fsys_gettimeofday in arch/ia64/kernel/fsys.S */
-	DEFINE(IA64_GTOD_LOCK_OFFSET,
-		offsetof (struct fsyscall_gtod_data_t, lock));
+	DEFINE(IA64_GTOD_SEQ_OFFSET,
+		offsetof (struct fsyscall_gtod_data_t, seq);
 	DEFINE(IA64_GTOD_WALL_TIME_OFFSET,
 		offsetof (struct fsyscall_gtod_data_t, wall_time));
 	DEFINE(IA64_GTOD_MONO_TIME_OFFSET,
Index: linux-2.6/arch/ia64/kernel/fsys.S
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/fsys.S
+++ linux-2.6/arch/ia64/kernel/fsys.S
@@ -174,7 +174,7 @@ ENTRY(fsys_set_tid_address)
 	FSYS_RETURN
 END(fsys_set_tid_address)
 
-#if IA64_GTOD_LOCK_OFFSET !=0
+#if IA64_GTOD_SEQ_OFFSET !=0
 #error fsys_gettimeofday incompatible with changes to struct fsyscall_gtod_data_t
 #endif
 #if IA64_ITC_JITTER_OFFSET !=0
Index: linux-2.6/arch/ia64/kernel/fsyscall_gtod_data.h
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/fsyscall_gtod_data.h
+++ linux-2.6/arch/ia64/kernel/fsyscall_gtod_data.h
@@ -6,7 +6,7 @@
  */
 
 struct fsyscall_gtod_data_t {
-	seqlock_t	lock;
+	seqcount_t	seq;
 	struct timespec	wall_time;
 	struct timespec monotonic_time;
 	cycle_t		clk_mask;
Index: linux-2.6/arch/ia64/kernel/time.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/time.c
+++ linux-2.6/arch/ia64/kernel/time.c
@@ -35,9 +35,7 @@
 
 static cycle_t itc_get_cycles(struct clocksource *cs);
 
-struct fsyscall_gtod_data_t fsyscall_gtod_data = {
-	.lock = __SEQLOCK_UNLOCKED(fsyscall_gtod_data.lock),
-};
+struct fsyscall_gtod_data_t fsyscall_gtod_data;
 
 struct itc_jitter_data_t itc_jitter_data;
 
@@ -460,9 +458,7 @@ void update_vsyscall_tz(void)
 void update_vsyscall(struct timespec *wall, struct timespec *wtm,
 			struct clocksource *c, u32 mult)
 {
-        unsigned long flags;
-
-        write_seqlock_irqsave(&fsyscall_gtod_data.lock, flags);
+	write_seqcount_begin(&fsyscall_gtod_data.seq);
 
         /* copy fsyscall clock data */
         fsyscall_gtod_data.clk_mask = c->mask;
@@ -485,6 +481,6 @@ void update_vsyscall(struct timespec *wa
 		fsyscall_gtod_data.monotonic_time.tv_sec++;
 	}
 
-        write_sequnlock_irqrestore(&fsyscall_gtod_data.lock, flags);
+	write_seqcount_end(&fsyscall_gtod_data.seq);
 }
 


