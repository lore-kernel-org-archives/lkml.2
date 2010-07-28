Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0G1Tyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:54:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53665 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875Ab0G1Tyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:54:43 -0400
Date: Wed, 28 Jul 2010 12:53:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 3/3 V2] alpha: Implement HW performance events on the
 EV67 and later CPUs.
Message-Id: <20100728125330.af75e63c.akpm@linux-foundation.org>
In-Reply-To: <1280226579-6117-2-git-send-email-mcree@orcon.net.nz>
References: <1272958808.5605.126.camel@twins>
	<1280226579-6117-2-git-send-email-mcree@orcon.net.nz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 22:29:39 +1200
Michael Cree <mcree@orcon.net.nz> wrote:

> This implements hardware performance events for the EV67 and later
> CPUs within the Linux performance events subsystem.  Only using the
> performance monitoring unit in HP/Compaq's so called "Aggregrate
> mode" is supported.
> 
> The code has been implemented in a manner that makes extension to
> other older Alpha CPUs relatively straightforward should some mug
> wish to indulge his or herself.

Below is the incremental diff.

I have a note here that Peter had issues with the earlier version of
this patch.  But I see no info here regarding what those issues were,
nor whether or how they were addressed.



 arch/alpha/kernel/perf_event.c |   32 ++++++++++++++++++-------------
 arch/alpha/kernel/time.c       |   26 +++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 13 deletions(-)

diff -puN arch/alpha/kernel/perf_event.c~a arch/alpha/kernel/perf_event.c
--- a/arch/alpha/kernel/perf_event.c~a
+++ a/arch/alpha/kernel/perf_event.c
@@ -517,8 +517,10 @@ static void alpha_pmu_read(struct perf_e
 static void alpha_pmu_unthrottle(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 
-	wrperfmon(PERFMON_CMD_ENABLE, (1<<hwc->idx));
+	cpuc->idx_mask |= 1UL<<hwc->idx;
+	wrperfmon(PERFMON_CMD_ENABLE, (1UL<<hwc->idx));
 }
 
 
@@ -756,12 +758,19 @@ static void alpha_perf_event_irq_handler
 	__get_cpu_var(irq_pmi_count)++;
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
-	/* la_ptr is the counter that overflowed. */
+	/* Completely counting through the PMC's period to trigger a new PMC
+	 * overflow interrupt while in this interrupt routine is utterly
+	 * disastrous!  The EV6 and EV67 counters are sufficiently large to
+	 * prevent this but to be really sure disable the PMCs.
+	 */
+	wrperfmon(PERFMON_CMD_DISABLE, cpuc->idx_mask);
 
-	if (la_ptr >= perf_max_events) {
+	/* la_ptr is the counter that overflowed. */
+	if (unlikely(la_ptr >= perf_max_events)) {
 		/* This should never occur! */
 		irq_err_count++;
 		pr_warning("PMI: silly index %ld\n", la_ptr);
+		wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 		return;
 	}
 
@@ -773,17 +782,19 @@ static void alpha_perf_event_irq_handler
 			break;
 	}
 
-	if (j == cpuc->n_events) {
+	if (unlikely(j == cpuc->n_events)) {
 		/* This can occur if the event is disabled right on a PMC overflow. */
+		wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 		return;
 	}
 
 	event = cpuc->event[j];
 
-	if (!event) {
+	if (unlikely(!event)) {
 		/* This should never occur! */
 		irq_err_count++;
 		pr_warning("PMI: No event at index %d!\n", idx);
+		wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 		return;
 	}
 
@@ -792,24 +803,19 @@ static void alpha_perf_event_irq_handler
 	data.period = event->hw.last_period;
 
 	if (alpha_perf_event_set_period(event, hwc, idx)) {
-		if (perf_event_overflow(event, 0, &data, regs)) {
+		if (perf_event_overflow(event, 1, &data, regs)) {
 			/* Interrupts coming too quickly; "throttle" the
 			 * counter, i.e., disable it for a little while.
 			 */
-			wrperfmon(PERFMON_CMD_DISABLE, 1<<idx);
+			cpuc->idx_mask &= ~(1UL<<idx);
 		}
 	}
+	wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);
 
 	return;
 }
 
 
-/* I wonder what this is for ??? */
-void set_perf_event_pending(void)
-{
-}
-
-
 
 /*
  * Init call to initialise performance events at kernel startup.
diff -puN arch/alpha/kernel/time.c~a arch/alpha/kernel/time.c
--- a/arch/alpha/kernel/time.c~a
+++ a/arch/alpha/kernel/time.c
@@ -41,6 +41,7 @@
 #include <linux/init.h>
 #include <linux/bcd.h>
 #include <linux/profile.h>
+#include <linux/perf_event.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -82,6 +83,26 @@ static struct {
 
 unsigned long est_cycle_freq;
 
+#ifdef CONFIG_PERF_EVENTS
+
+DEFINE_PER_CPU(u8, perf_event_pending);
+
+#define set_perf_event_pending_flag()  __get_cpu_var(perf_event_pending) = 1
+#define test_perf_event_pending()      __get_cpu_var(perf_event_pending)
+#define clear_perf_event_pending()     __get_cpu_var(perf_event_pending) = 0
+
+void set_perf_event_pending(void)
+{
+	set_perf_event_pending_flag();
+}
+
+#else  /* CONFIG_PERF_EVENTS */
+
+#define test_perf_event_pending()      0
+#define clear_perf_event_pending()
+
+#endif /* CONFIG_PERF_EVENTS */
+
 
 static inline __u32 rpcc(void)
 {
@@ -175,6 +196,11 @@ irqreturn_t timer_interrupt(int irq, voi
 		update_process_times(user_mode(get_irq_regs()));
 #endif
 
+	if (test_perf_event_pending()) {
+		clear_perf_event_pending();
+		perf_event_do_pending();
+	}
+
 	return IRQ_HANDLED;
 }
 
_

