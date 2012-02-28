Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030388Ab2B1TqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:46:13 -0500
Received: from www.linutronix.de ([62.245.132.108]:52213 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966065Ab2B1TqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:46:05 -0500
Message-Id: <20120228194508.563213629@linutronix.de>
User-Agent: quilt/0.48-1
Date: Tue, 28 Feb 2012 19:46:04 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>
Subject: [patch 3/4] x86: vdso: Use seqcount instead of seqlock
References: <20120228194200.180923135@linutronix.de>
Content-Disposition: inline; filename=x86-vdso-use-seqcount.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The update of the vdso data happens under xtime_lock, so adding a
nested lock is pointless. Just use a seqcount to sync the readers.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/vgtod.h   |    2 +-
 arch/x86/kernel/vsyscall_64.c  |   11 +++--------
 arch/x86/vdso/vclock_gettime.c |   16 ++++++++--------
 3 files changed, 12 insertions(+), 17 deletions(-)

Index: linux-2.6/arch/x86/include/asm/vgtod.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/vgtod.h
+++ linux-2.6/arch/x86/include/asm/vgtod.h
@@ -5,7 +5,7 @@
 #include <linux/clocksource.h>
 
 struct vsyscall_gtod_data {
-	seqlock_t	lock;
+	seqcount_t	seq;
 
 	/* open coded 'struct timespec' */
 	time_t		wall_time_sec;
Index: linux-2.6/arch/x86/kernel/vsyscall_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vsyscall_64.c
+++ linux-2.6/arch/x86/kernel/vsyscall_64.c
@@ -52,10 +52,7 @@
 #include "vsyscall_trace.h"
 
 DEFINE_VVAR(int, vgetcpu_mode);
-DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data) =
-{
-	.lock = __SEQLOCK_UNLOCKED(__vsyscall_gtod_data.lock),
-};
+DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
 
 static enum { EMULATE, NATIVE, NONE } vsyscall_mode = EMULATE;
 
@@ -86,9 +83,7 @@ void update_vsyscall_tz(void)
 void update_vsyscall(struct timespec *wall_time, struct timespec *wtm,
 			struct clocksource *clock, u32 mult)
 {
-	unsigned long flags;
-
-	write_seqlock_irqsave(&vsyscall_gtod_data.lock, flags);
+	write_seqcount_begin(&vsyscall_gtod_data.seq);
 
 	/* copy vsyscall data */
 	vsyscall_gtod_data.clock.vclock_mode	= clock->archdata.vclock_mode;
@@ -101,7 +96,7 @@ void update_vsyscall(struct timespec *wa
 	vsyscall_gtod_data.wall_to_monotonic	= *wtm;
 	vsyscall_gtod_data.wall_time_coarse	= __current_kernel_time();
 
-	write_sequnlock_irqrestore(&vsyscall_gtod_data.lock, flags);
+	write_seqcount_end(&vsyscall_gtod_data.seq);
 }
 
 static void warn_bad_vsyscall(const char *level, struct pt_regs *regs,
Index: linux-2.6/arch/x86/vdso/vclock_gettime.c
===================================================================
--- linux-2.6.orig/arch/x86/vdso/vclock_gettime.c
+++ linux-2.6/arch/x86/vdso/vclock_gettime.c
@@ -86,11 +86,11 @@ notrace static noinline int do_realtime(
 {
 	unsigned long seq, ns;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_sec;
 		ts->tv_nsec = gtod->wall_time_nsec;
 		ns = vgetns();
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	timespec_add_ns(ts, ns);
 	return 0;
 }
@@ -99,12 +99,12 @@ notrace static noinline int do_monotonic
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_seqcount_begin(&gtod->seq);
 		secs = gtod->wall_time_sec;
 		ns = gtod->wall_time_nsec + vgetns();
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
 	/* wall_time_nsec, vgetns(), and wall_to_monotonic.tv_nsec
 	 * are all guaranteed to be nonnegative.
@@ -123,10 +123,10 @@ notrace static noinline int do_realtime_
 {
 	unsigned long seq;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_seqcount_begin(&gtod->seq);
 		ts->tv_sec = gtod->wall_time_coarse.tv_sec;
 		ts->tv_nsec = gtod->wall_time_coarse.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 	return 0;
 }
 
@@ -134,12 +134,12 @@ notrace static noinline int do_monotonic
 {
 	unsigned long seq, ns, secs;
 	do {
-		seq = read_seqbegin(&gtod->lock);
+		seq = read_seqcount_begin(&gtod->seq);
 		secs = gtod->wall_time_coarse.tv_sec;
 		ns = gtod->wall_time_coarse.tv_nsec;
 		secs += gtod->wall_to_monotonic.tv_sec;
 		ns += gtod->wall_to_monotonic.tv_nsec;
-	} while (unlikely(read_seqretry(&gtod->lock, seq)));
+	} while (unlikely(read_seqcount_retry(&gtod->seq, seq)));
 
 	/* wall_time_nsec and wall_to_monotonic.tv_nsec are
 	 * guaranteed to be between 0 and NSEC_PER_SEC.


