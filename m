Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2BBKAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 05:00:47 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53421 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778Ab2BBKAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 05:00:43 -0500
Date: Thu, 2 Feb 2012 11:00:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120202100024.GA4160@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 45179fec946dd554f74e950d2278dabd5ad23fd3 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

 Thanks,

	Ingo

------------------>
Dan Carpenter (1):
      x86/dumpstack: Remove unneeded check in dump_trace()

David Daney (1):
      perf tools: Fix broken build by defining _GNU_SOURCE in Makefile

Stephane Eranian (3):
      perf: Fix broken interrupt rate throttling
      perf tools: Fix strlen() bug in perf_event__synthesize_event_type()
      perf top: Fix number of samples displayed


 arch/x86/kernel/dumpstack_64.c      |    2 +-
 include/linux/perf_event.h          |    1 +
 kernel/events/core.c                |  104 ++++++++++++++++++++++-------------
 tools/perf/Makefile                 |    7 +--
 tools/perf/builtin-probe.c          |    2 -
 tools/perf/builtin-top.c            |   13 +++-
 tools/perf/util/header.c            |    2 +-
 tools/perf/util/probe-event.c       |    2 -
 tools/perf/util/symbol.c            |    1 -
 tools/perf/util/trace-event-parse.c |    3 +-
 tools/perf/util/ui/browsers/hists.c |    2 -
 tools/perf/util/ui/helpline.c       |    1 -
 tools/perf/util/util.h              |    1 -
 13 files changed, 82 insertions(+), 59 deletions(-)

diff --git a/arch/x86/kernel/dumpstack_64.c b/arch/x86/kernel/dumpstack_64.c
index 6d728d9..af7785f 100644
--- a/arch/x86/kernel/dumpstack_64.c
+++ b/arch/x86/kernel/dumpstack_64.c
@@ -129,7 +129,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 	if (!stack) {
 		if (regs)
 			stack = (unsigned long *)regs->sp;
-		else if (task && task != current)
+		else if (task != current)
 			stack = (unsigned long *)task->thread.sp;
 		else
 			stack = &dummy;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 0885561..abb2776 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -587,6 +587,7 @@ struct hw_perf_event {
 	u64				sample_period;
 	u64				last_period;
 	local64_t			period_left;
+	u64                             interrupts_seq;
 	u64				interrupts;
 
 	u64				freq_time_stamp;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 32b48c8..ba36013 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2300,6 +2300,9 @@ do {					\
 	return div64_u64(dividend, divisor);
 }
 
+static DEFINE_PER_CPU(int, perf_throttled_count);
+static DEFINE_PER_CPU(u64, perf_throttled_seq);
+
 static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -2325,16 +2328,29 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	}
 }
 
-static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
+/*
+ * combine freq adjustment with unthrottling to avoid two passes over the
+ * events. At the same time, make sure, having freq events does not change
+ * the rate of unthrottling as that would introduce bias.
+ */
+static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
+					   int needs_unthr)
 {
 	struct perf_event *event;
 	struct hw_perf_event *hwc;
-	u64 interrupts, now;
+	u64 now, period = TICK_NSEC;
 	s64 delta;
 
-	if (!ctx->nr_freq)
+	/*
+	 * only need to iterate over all events iff:
+	 * - context have events in frequency mode (needs freq adjust)
+	 * - there are events to unthrottle on this cpu
+	 */
+	if (!(ctx->nr_freq || needs_unthr))
 		return;
 
+	raw_spin_lock(&ctx->lock);
+
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
 			continue;
@@ -2344,13 +2360,8 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 
 		hwc = &event->hw;
 
-		interrupts = hwc->interrupts;
-		hwc->interrupts = 0;
-
-		/*
-		 * unthrottle events on the tick
-		 */
-		if (interrupts == MAX_INTERRUPTS) {
+		if (needs_unthr && hwc->interrupts == MAX_INTERRUPTS) {
+			hwc->interrupts = 0;
 			perf_log_throttle(event, 1);
 			event->pmu->start(event, 0);
 		}
@@ -2358,14 +2369,26 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 		if (!event->attr.freq || !event->attr.sample_freq)
 			continue;
 
-		event->pmu->read(event);
+		/*
+		 * stop the event and update event->count
+		 */
+		event->pmu->stop(event, PERF_EF_UPDATE);
+
 		now = local64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
 		hwc->freq_count_stamp = now;
 
+		/*
+		 * restart the event
+		 * reload only if value has changed
+		 */
 		if (delta > 0)
 			perf_adjust_period(event, period, delta);
+
+		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
 	}
+
+	raw_spin_unlock(&ctx->lock);
 }
 
 /*
@@ -2388,16 +2411,13 @@ static void rotate_ctx(struct perf_event_context *ctx)
  */
 static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 {
-	u64 interval = (u64)cpuctx->jiffies_interval * TICK_NSEC;
 	struct perf_event_context *ctx = NULL;
-	int rotate = 0, remove = 1, freq = 0;
+	int rotate = 0, remove = 1;
 
 	if (cpuctx->ctx.nr_events) {
 		remove = 0;
 		if (cpuctx->ctx.nr_events != cpuctx->ctx.nr_active)
 			rotate = 1;
-		if (cpuctx->ctx.nr_freq)
-			freq = 1;
 	}
 
 	ctx = cpuctx->task_ctx;
@@ -2405,37 +2425,26 @@ static void perf_rotate_context(struct perf_cpu_context *cpuctx)
 		remove = 0;
 		if (ctx->nr_events != ctx->nr_active)
 			rotate = 1;
-		if (ctx->nr_freq)
-			freq = 1;
 	}
 
-	if (!rotate && !freq)
+	if (!rotate)
 		goto done;
 
 	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
 	perf_pmu_disable(cpuctx->ctx.pmu);
 
-	if (freq) {
-		perf_ctx_adjust_freq(&cpuctx->ctx, interval);
-		if (ctx)
-			perf_ctx_adjust_freq(ctx, interval);
-	}
-
-	if (rotate) {
-		cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
-		if (ctx)
-			ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
+	cpu_ctx_sched_out(cpuctx, EVENT_FLEXIBLE);
+	if (ctx)
+		ctx_sched_out(ctx, cpuctx, EVENT_FLEXIBLE);
 
-		rotate_ctx(&cpuctx->ctx);
-		if (ctx)
-			rotate_ctx(ctx);
+	rotate_ctx(&cpuctx->ctx);
+	if (ctx)
+		rotate_ctx(ctx);
 
-		perf_event_sched_in(cpuctx, ctx, current);
-	}
+	perf_event_sched_in(cpuctx, ctx, current);
 
 	perf_pmu_enable(cpuctx->ctx.pmu);
 	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
-
 done:
 	if (remove)
 		list_del_init(&cpuctx->rotation_list);
@@ -2445,10 +2454,22 @@ void perf_event_task_tick(void)
 {
 	struct list_head *head = &__get_cpu_var(rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
+	struct perf_event_context *ctx;
+	int throttled;
 
 	WARN_ON(!irqs_disabled());
 
+	__this_cpu_inc(perf_throttled_seq);
+	throttled = __this_cpu_xchg(perf_throttled_count, 0);
+
 	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
+		ctx = &cpuctx->ctx;
+		perf_adjust_freq_unthr_context(ctx, throttled);
+
+		ctx = cpuctx->task_ctx;
+		if (ctx)
+			perf_adjust_freq_unthr_context(ctx, throttled);
+
 		if (cpuctx->jiffies_interval == 1 ||
 				!(jiffies % cpuctx->jiffies_interval))
 			perf_rotate_context(cpuctx);
@@ -4509,6 +4530,7 @@ static int __perf_event_overflow(struct perf_event *event,
 {
 	int events = atomic_read(&event->event_limit);
 	struct hw_perf_event *hwc = &event->hw;
+	u64 seq;
 	int ret = 0;
 
 	/*
@@ -4518,14 +4540,20 @@ static int __perf_event_overflow(struct perf_event *event,
 	if (unlikely(!is_sampling_event(event)))
 		return 0;
 
-	if (unlikely(hwc->interrupts >= max_samples_per_tick)) {
-		if (throttle) {
+	seq = __this_cpu_read(perf_throttled_seq);
+	if (seq != hwc->interrupts_seq) {
+		hwc->interrupts_seq = seq;
+		hwc->interrupts = 1;
+	} else {
+		hwc->interrupts++;
+		if (unlikely(throttle
+			     && hwc->interrupts >= max_samples_per_tick)) {
+			__this_cpu_inc(perf_throttled_count);
 			hwc->interrupts = MAX_INTERRUPTS;
 			perf_log_throttle(event, 0);
 			ret = 1;
 		}
-	} else
-		hwc->interrupts++;
+	}
 
 	if (event->attr.freq) {
 		u64 now = perf_clock();
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..7c12650 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -104,7 +104,7 @@ endif
 
 CFLAGS = -fno-omit-frame-pointer -ggdb3 -Wall -Wextra -std=gnu99 $(CFLAGS_WERROR) $(CFLAGS_OPTIMIZE) -D_FORTIFY_SOURCE=2 $(EXTRA_WARNINGS) $(EXTRA_CFLAGS)
 EXTLIBS = -lpthread -lrt -lelf -lm
-ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
+ALL_CFLAGS = $(CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 ALL_LDFLAGS = $(LDFLAGS)
 STRIP ?= strip
 
@@ -168,10 +168,7 @@ endif
 
 ### --- END CONFIGURATION SECTION ---
 
-# Those must not be GNU-specific; they are shared with perl/ which may
-# be built by a different compiler. (Note that this is an artifact now
-# but it still might be nice to keep that distinction.)
-BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include
+BASIC_CFLAGS = -Iutil/include -Iarch/$(ARCH)/include -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 BASIC_LDFLAGS =
 
 # Guard against environment variables
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 59d43ab..fb85661 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -20,7 +20,6 @@
  * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  */
-#define _GNU_SOURCE
 #include <sys/utsname.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -31,7 +30,6 @@
 #include <stdlib.h>
 #include <string.h>
 
-#undef _GNU_SOURCE
 #include "perf.h"
 #include "builtin.h"
 #include "util/util.h"
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 8f80df8..dd162aa 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -89,8 +89,6 @@ void get_term_dimensions(struct winsize *ws)
 
 static void perf_top__update_print_entries(struct perf_top *top)
 {
-	top->print_entries = top->winsize.ws_row;
-
 	if (top->print_entries > 9)
 		top->print_entries -= 9;
 }
@@ -100,6 +98,13 @@ static void perf_top__sig_winch(int sig __used, siginfo_t *info __used, void *ar
 	struct perf_top *top = arg;
 
 	get_term_dimensions(&top->winsize);
+	if (!top->print_entries
+	    || (top->print_entries+4) > top->winsize.ws_row) {
+		top->print_entries = top->winsize.ws_row;
+	} else {
+		top->print_entries += 4;
+		top->winsize.ws_row = top->print_entries;
+	}
 	perf_top__update_print_entries(top);
 }
 
@@ -453,8 +458,10 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 				};
 				perf_top__sig_winch(SIGWINCH, NULL, top);
 				sigaction(SIGWINCH, &act, NULL);
-			} else
+			} else {
+				perf_top__sig_winch(SIGWINCH, NULL, top);
 				signal(SIGWINCH, SIG_DFL);
+			}
 			break;
 		case 'E':
 			if (top->evlist->nr_entries > 1) {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e7e0b0..ecd7f4d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2105,7 +2105,7 @@ int perf_event__synthesize_event_type(struct perf_tool *tool,
 	strncpy(ev.event_type.event_type.name, name, MAX_EVENT_NAME - 1);
 
 	ev.event_type.header.type = PERF_RECORD_HEADER_EVENT_TYPE;
-	size = strlen(name);
+	size = strlen(ev.event_type.event_type.name);
 	size = ALIGN(size, sizeof(u64));
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index eb25900..29cb654 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -19,7 +19,6 @@
  *
  */
 
-#define _GNU_SOURCE
 #include <sys/utsname.h>
 #include <sys/types.h>
 #include <sys/stat.h>
@@ -33,7 +32,6 @@
 #include <limits.h>
 #include <elf.h>
 
-#undef _GNU_SOURCE
 #include "util.h"
 #include "event.h"
 #include "string.h"
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 215d50f..0975438 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1,4 +1,3 @@
-#define _GNU_SOURCE
 #include <ctype.h>
 #include <dirent.h>
 #include <errno.h>
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 6c164dc..1a8d4dc 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -21,14 +21,13 @@
  *  The parts for function graph printing was taken and modified from the
  *  Linux Kernel that were written by Frederic Weisbecker.
  */
-#define _GNU_SOURCE
+
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 #include <errno.h>
 
-#undef _GNU_SOURCE
 #include "../perf.h"
 #include "util.h"
 #include "trace-event.h"
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 1212a38..e81aef1 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -1,6 +1,4 @@
-#define _GNU_SOURCE
 #include <stdio.h>
-#undef _GNU_SOURCE
 #include "../libslang.h"
 #include <stdlib.h>
 #include <string.h>
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index 6ef3c56..4f48f59 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -1,4 +1,3 @@
-#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b9c530c..ecf9898 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -40,7 +40,6 @@
 #define decimal_length(x)	((int)(sizeof(x) * 2.56 + 0.5) + 1)
 
 #define _ALL_SOURCE 1
-#define _GNU_SOURCE 1
 #define _BSD_SOURCE 1
 #define HAS_BOOL
 
