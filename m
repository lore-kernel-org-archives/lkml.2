Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563Ab1BVQDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:03:44 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:50705 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab1BVQDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:03:43 -0500
Date: Tue, 22 Feb 2011 17:03:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110222160318.GA14165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      perf, x86: P4 PMU: Fix spurious NMI messages

Peter Zijlstra (1):
      perf: Fix throttle logic


 arch/x86/include/asm/perf_event_p4.h |    1 +
 arch/x86/kernel/cpu/perf_event_p4.c  |   11 ++++++++---
 kernel/perf_event.c                  |   19 +++++++++++++++----
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/perf_event_p4.h b/arch/x86/include/asm/perf_event_p4.h
index e2f6a99..cc29086 100644
--- a/arch/x86/include/asm/perf_event_p4.h
+++ b/arch/x86/include/asm/perf_event_p4.h
@@ -22,6 +22,7 @@
 
 #define ARCH_P4_CNTRVAL_BITS	(40)
 #define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
+#define ARCH_P4_UNFLAGGED_BIT	((1ULL) << (ARCH_P4_CNTRVAL_BITS - 1))
 
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index f7a0993..ff751a9 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -770,9 +770,14 @@ static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 		return 1;
 	}
 
-	/* it might be unflagged overflow */
-	rdmsrl(hwc->event_base + hwc->idx, v);
-	if (!(v & ARCH_P4_CNTRVAL_MASK))
+	/*
+	 * In some circumstances the overflow might issue an NMI but did
+	 * not set P4_CCCR_OVF bit. Because a counter holds a negative value
+	 * we simply check for high bit being set, if it's cleared it means
+	 * the counter has reached zero value and continued counting before
+	 * real NMI signal was received:
+	 */
+	if (!(v & ARCH_P4_UNFLAGGED_BIT))
 		return 1;
 
 	return 0;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 999835b..656222f 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -782,6 +782,10 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+#define MAX_INTERRUPTS (~0ULL)
+
+static void perf_log_throttle(struct perf_event *event, int enable);
+
 static int
 event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
@@ -794,6 +798,17 @@ event_sched_in(struct perf_event *event,
 
 	event->state = PERF_EVENT_STATE_ACTIVE;
 	event->oncpu = smp_processor_id();
+
+	/*
+	 * Unthrottle events, since we scheduled we might have missed several
+	 * ticks already, also for a heavily scheduling task there is little
+	 * guarantee it'll get a tick in a timely manner.
+	 */
+	if (unlikely(event->hw.interrupts == MAX_INTERRUPTS)) {
+		perf_log_throttle(event, 1);
+		event->hw.interrupts = 0;
+	}
+
 	/*
 	 * The new state must be visible before we turn it on in the hardware:
 	 */
@@ -1596,10 +1611,6 @@ void __perf_event_task_sched_in(struct task_struct *task)
 	}
 }
 
-#define MAX_INTERRUPTS (~0ULL)
-
-static void perf_log_throttle(struct perf_event *event, int enable);
-
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	u64 frequency = event->attr.sample_freq;
