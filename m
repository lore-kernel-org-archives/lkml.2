Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912Ab0IZIi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 04:38:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36738 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab0IZIiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 04:38:54 -0400
Date: Sun, 26 Sep 2010 10:38:28 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20100926083828.GA26678@elte.hu>
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
	[score: 0.0025]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Jeremy Fitzhardinge (1):
      tracing/x86: Don't use mcount in pvclock.c

Robert Richter (1):
      perf, x86: Catch spurious interrupts after disabling counters

Steven Rostedt (1):
      tracing/x86: Don't use mcount in kvmclock.c


 arch/x86/kernel/Makefile         |    2 ++
 arch/x86/kernel/cpu/perf_event.c |   12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..fedf32a 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -11,6 +11,8 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_tsc.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 CFLAGS_REMOVE_paravirt-spinlocks.o = -pg
+CFLAGS_REMOVE_pvclock.o = -pg
+CFLAGS_REMOVE_kvmclock.o = -pg
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3efdf28..03a5b03 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -102,6 +102,7 @@ struct cpu_hw_events {
 	 */
 	struct perf_event	*events[X86_PMC_IDX_MAX]; /* in counter order */
 	unsigned long		active_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
+	unsigned long		running[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
 	int			enabled;
 
 	int			n_events;
@@ -1010,6 +1011,7 @@ static int x86_pmu_start(struct perf_event *event)
 	x86_perf_event_set_period(event);
 	cpuc->events[idx] = event;
 	__set_bit(idx, cpuc->active_mask);
+	__set_bit(idx, cpuc->running);
 	x86_pmu.enable(event);
 	perf_event_update_userpage(event);
 
@@ -1141,8 +1143,16 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
-		if (!test_bit(idx, cpuc->active_mask))
+		if (!test_bit(idx, cpuc->active_mask)) {
+			/*
+			 * Though we deactivated the counter some cpus
+			 * might still deliver spurious interrupts still
+			 * in flight. Catch them:
+			 */
+			if (__test_and_clear_bit(idx, cpuc->running))
+				handled++;
 			continue;
+		}
 
 		event = cpuc->events[idx];
 		hwc = &event->hw;
