Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759678Ab1LPQNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:13:05 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:57994
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752088Ab1LPQMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:12:45 -0500
X-SpamScore: 3
X-BigFish: VPS3(zz853kzz1202hzz8275bhz2dh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LWB111-02-2GV-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <mingo@elte.hu>
CC: <hpa@zytor.com>, <tglx@linutronix.de>, <suresh.b.siddha@intel.com>,
        <eranian@google.com>, <brgerst@gmail.com>, <robert.richter@amd.com>,
        <Andreas.Herrmann3@amd.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bebl@mageta.org>,
        Benjamin Block <benjamin.block@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [RFC 5/5] x86, perf: adds support for the LWP threshold-int
Date: Fri, 16 Dec 2011 17:12:23 +0100
Message-ID: <1324051943-21112-5-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
References: <20111216160757.GL665@escobedo.osrc.amd.com>
 <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Block <benjamin.block@amd.com>

This patch adds support for the LWP threshold-interrupt into the
LWP-integration into perf. For each LWP-event that is written into the
buffer a interrupt is generated and a overflow is reported to perf. If
requested, the LWP-event is also reported as raw-event.

The perf-sample_rate is used as interval for the corresponding
LWP-event. The current implementation restricts the sample_rate to be
between 0xF and 0x1FFFFFF, because we couldn't report raw-LWP-event for
each overflow if the sample_rate would be bigger (period-calculation
could cause a overflow although there was no interrupt).

The interrupt is currently only available to the kernel and not to
userland-software that wants to use LWP without the in-kernel
implementation.

Signed-off-by: Benjamin Block <benjamin.block@amd.com>
Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/irq_vectors.h       |    8 +-
 arch/x86/kernel/cpu/Makefile             |    4 +-
 arch/x86/kernel/cpu/perf_event_amd_lwp.c |  318 +++++++++++++++++++++++-------
 arch/x86/kernel/entry_64.S               |    2 +
 4 files changed, 253 insertions(+), 79 deletions(-)

diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 7e50f06..c5447f5 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -119,6 +119,12 @@
  */
 #define LOCAL_TIMER_VECTOR		0xef
 
+/*
+ * Vector-Nr. used by the threshold-interrupt.
+ * Has to be initialized before it is written to MSR_AMD64_LWP_CFG.
+ */
+#define LWP_THRESHOLD_VECTOR		0xee
+
 /* up to 32 vectors used for spreading out TLB flushes: */
 #if NR_CPUS <= 32
 # define NUM_INVALIDATE_TLB_VECTORS	(NR_CPUS)
@@ -126,7 +132,7 @@
 # define NUM_INVALIDATE_TLB_VECTORS	(32)
 #endif
 
-#define INVALIDATE_TLB_VECTOR_END	(0xee)
+#define INVALIDATE_TLB_VECTOR_END	(0xed)
 #define INVALIDATE_TLB_VECTOR_START	\
 	(INVALIDATE_TLB_VECTOR_END-NUM_INVALIDATE_TLB_VECTORS+1)
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 9973465..6d87bac 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
-obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o perf_event_amd_lwp.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
@@ -31,7 +31,7 @@ obj-$(CONFIG_PERF_EVENTS)		+= perf_event.o
 obj-$(CONFIG_X86_MCE)			+= mcheck/
 obj-$(CONFIG_MTRR)			+= mtrr/
 
-obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o
+obj-$(CONFIG_X86_LOCAL_APIC)		+= perfctr-watchdog.o perf_event_amd_lwp.o
 
 quiet_cmd_mkcapflags = MKCAP   $@
       cmd_mkcapflags = $(PERL) $(srctree)/$(src)/mkcapflags.pl $< $@
diff --git a/arch/x86/kernel/cpu/perf_event_amd_lwp.c b/arch/x86/kernel/cpu/perf_event_amd_lwp.c
index afc6c8d..205245d 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_lwp.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_lwp.c
@@ -10,6 +10,9 @@
 #include <linux/highmem.h>
 #include <linux/bitops.h>
 
+#include <asm/idle.h>
+#include <asm/desc.h>
+#include <asm/irq_vectors.h>
 #include <asm/xsave.h>
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
@@ -250,6 +253,7 @@ struct lwp_struct {
 
 	/* Cached events that have been read from buffer */
 	u64				*event_counter;
+	struct perf_event		**registered_events;
 	/*
 	 * Cached xsave-values, to prevent lose of already counted but not
 	 * submitted events.
@@ -270,6 +274,8 @@ static inline int vector_test(unsigned int bit_nr, u32 vector)
 static struct lwp_capabilities	lwp_caps;
 static struct pmu		perf_lwp_pmu;
 
+static DEFINE_PER_CPU(struct lwp_struct *, active_lwp_struct) = 0;
+
 static u16 get_filter_mask_for(u32 eventnr)
 {
 	/*
@@ -735,6 +741,16 @@ static struct lwp_struct *lwpcb_new(void)
 	}
 	memset(l->event_counter, 0, l->eventmax * sizeof(*l->event_counter));
 
+	l->registered_events =
+		kmalloc(l->eventmax * sizeof(*l->registered_events),
+			GFP_ATOMIC);
+	if(!l->registered_events) {
+		err = -ENOENT;
+		goto err_event_counter_alloc;
+	}
+	memset(l->registered_events, 0,
+			l->eventmax * sizeof(*l->registered_events));
+
 	l->userspace.mm = get_task_mm(current);
 
 	err = get_userspace_mapping(&l->userspace.lwpcb, l->userspace.mm,
@@ -747,8 +763,11 @@ static struct lwp_struct *lwpcb_new(void)
 	if (err)
 		goto err_ulwpcb;
 
-	/* modified on event-start */
-	l->lwpcb.head->flags = 0;
+	/*
+	 * Activate only the threshold interrupt,
+	 * all other events are activated on pmu-start() off the specific event
+	 */
+	l->lwpcb.head->flags = (1U << LWP_CAPS_THRESHOLD);
 	l->lwpcb.head->buffer_size = l->buffer.size;
 	l->lwpcb.head->buffer_base = (u64) l->userspace.buffer.addr;
 	/* currently not supported by this pmu */
@@ -779,6 +798,8 @@ err_ulwpcb:
 err_mm:
 	mmput(l->userspace.mm);
 
+	kfree(l->registered_events);
+err_event_counter_alloc:
 	kfree(l->event_counter);
 err_lwpcbbuffer_alloc:
 	kfree(l->buffer.buffer_base);
@@ -809,6 +830,7 @@ static void lwpcb_destory(struct kref *kref)
 	free_userspace_mapping(&l->userspace.buffer, l->userspace.mm);
 	mmput(l->userspace.mm);
 
+	kfree(l->registered_events);
 	kfree(l->event_counter);
 	kfree(l->buffer.buffer_base);
 	kfree(l->lwpcb.lwpcb_base);
@@ -840,57 +862,46 @@ static void lwpcb_remove_event(struct lwp_struct *lwps, u32 eventnr)
 	lwps->lwpcb.events[eventnr-1].counter = 0;
 }
 
-static int lwpcb_read_buffer(struct lwp_struct *l)
+static int
+lwpcb_update_period(struct lwp_struct *lwps, struct perf_event *event,
+		    u64 period, u64 new_period)
 {
-	u32 bho, bto, bz;
-	int count, i;
-	char *buffer = l->buffer.buffer_base;
-	struct lwp_event *event;
-
-	bz = l->lwpcb.head->buffer_size;
-
-	bto = l->lwpcb.head->buffer_tail_offset;
-	buffer += bto;
-
-	/*
-	 * the last two checks are to prevent user-manipulations that could
-	 * cause damage
-	 */
-	if (lwp_read_head_offset(l, &bho) || (bho > bz) || (bho % l->eventsize))
-		BUG();
-
-	count = (((bho - bto) % bz) / l->eventsize);
-	if(count <= 0)
-		return 0;
-
-	/* todo read only needed chunks */
-	if (userread_buffer(l, bto, bho))
-		BUG();
+	struct hw_perf_event *hwc = &event->hw;
+	u32 event_idx = lwp_config_event_get(event->attr.config) - 1;
+	u64 sample_period = hwc->sample_period;
+	u64 last_period = period;
+	u64 left = local64_read(&hwc->period_left);
+	s64 sleft;
+	int overflow = 0;
 
-	for (i = 0; i < count; i++) {
-		event = (struct lwp_event *) (buffer + bto);
+	hwc->last_period = last_period;
+	sleft = (new_period - sample_period);
 
-		/*
-		 * The opposite COULD be a programmed lwp-event (id=255), but we
-		 * ignore them for now.
-		 */
-		if ((event->event_id > LWP_EVENT_INVALID) ||
-				(event->event_id < LWP_EVENT_MAX)) {
-			l->event_counter[event->event_id - 1] +=
-				l->lwpcb.events[event->event_id - 1].interval;
-		}
-
-		bto += l->eventsize;
-		if (bto >= bz)
-			bto = 0;
+	/* lets test if the change was already enough to trigger a overflow */
+	if (left < -sleft) {
+		overflow = 1;
+		left = new_period + (left + sleft);
+	}
+	else {
+		left += sleft;
 	}
 
-	l->lwpcb.head->buffer_tail_offset = bto;
+	if (left <= last_period) {
+		overflow = 1;
+		left = new_period + (left - last_period);
+		local64_set(&hwc->period_left, left);
+	} else {
+		left -= last_period;
+		local64_set(&hwc->period_left, left);
+	}
 
-	if (userwrite_buffer_tail_offset(l))
-		BUG();
+	/*
+	 * if new_period != hwc->sample_period, then this change
+	 * has also to be promoted to lwp via userwrite_lwpcb
+	 */
+	lwps->lwpcb.events[event_idx].interval = new_period;
 
-	return 0;
+	return overflow;
 }
 
 static void perf_lwp_event_destroy(struct perf_event *event)
@@ -907,6 +918,9 @@ static void perf_lwp_event_destroy(struct perf_event *event)
 
 	raw_spin_lock_irqsave(&l->lock, flags);
 
+	if(l->registered_events[eventnr-1] != event)
+		goto not_registered;
+
 	if (lwp_stop(l))
 		BUG();
 
@@ -917,10 +931,12 @@ static void perf_lwp_event_destroy(struct perf_event *event)
 
 	l->event_counter[eventnr-1] = 0;
 	l->xstate_counter[eventnr-1] = 0;
+	l->registered_events[eventnr-1] = 0;
 
 	if ((l->lwpcb.head->flags & LWP_EVENT_MASK) && lwp_start(l, 1))
 		BUG();
 
+not_registered:
 	raw_spin_unlock_irqrestore(&l->lock, flags);
 
 	/* for future with cross-lwp-creation this needs to be locked */
@@ -1009,7 +1025,6 @@ perf_lwp_event_init_for(struct perf_event *event, int cpu,
 		 * maybe we would better introduce a lwp-field in the
 		 * event-context to prevent two events racing this
 		 */
-
 		rcu_read_unlock();
 
 		lwpcb = lwpcb_new();
@@ -1029,7 +1044,7 @@ perf_lwp_event_init_for(struct perf_event *event, int cpu,
 
 	raw_spin_lock_irqsave(&lwpcb->lock, flags);
 
-	if (lwpcb->lwpcb.events[eventnr-1].interval) {
+	if (lwpcb->registered_events[eventnr-1]) {
 		err = -EINVAL;
 		goto err_add_failed;
 	}
@@ -1045,6 +1060,7 @@ perf_lwp_event_init_for(struct perf_event *event, int cpu,
 
 	lwpcb->event_counter[eventnr-1] = 0;
 	lwpcb->xstate_counter[eventnr-1] = 0;
+	lwpcb->registered_events[eventnr-1] = event;
 
 	event->destroy = perf_lwp_event_destroy;
 
@@ -1073,25 +1089,15 @@ static void perf_lwp_start(struct perf_event *event, int flags)
 	struct lwp_struct *l = (struct lwp_struct *) event->hw.config;
 	u32 eventnr = lwp_config_event_get(event->attr.config);
 	u32 lwpflags;
+	int overflow;
 	unsigned long lockflags = 0;
 
-	/* update cached values, before updating freq */
-	raw_spin_lock_irqsave(&l->lock, lockflags);
-	lwpcb_read_buffer(l);
-	raw_spin_unlock_irqrestore(&l->lock, lockflags);
-
-	lockflags = 0;
 	raw_spin_lock_irqsave(&l->lock, lockflags);
 
 	/* TODO: need a good way to handle takeovers of lwp by current */
 	if (lwp_stop(l))
 		BUG();
 
-	hwc->state = 0;
-
-	/* counters get reloaded every lwp_start
-	if (flags & PERF_EF_RELOAD) { DEBUG("reload counter"); }	*/
-
 	/* This implies that we currently not support 64 Bit-Counter */
 	if (hwc->sample_period < LWP_EVENT_MIN_PERIOD) {
 		__WARN();
@@ -1100,7 +1106,24 @@ static void perf_lwp_start(struct perf_event *event, int flags)
 		__WARN();
 		hwc->sample_period = LWP_EVENT_MAX_PERIOD;
 	}
-	l->lwpcb.events[eventnr-1].interval = hwc->sample_period;
+
+	/* Set the (maybe) new period.
+	 *
+	 * A Overflow is theo. possible, as the new sample_rate could be smaller
+	 * than the old, and thus some already counted events can be enough the
+	 * trigger an overflow.
+	 * This would be difficult, because there is not lwp-event to report.
+	 * We would have to wait for the next interrupt, which should trigger
+	 * immediately after the start.
+	 *
+	 * (left_period + (new_period - old_period)) <= 0
+	 */
+	overflow = lwpcb_update_period(l, event, 0, hwc->sample_period);
+
+	hwc->state = 0;
+
+	/* counters get reloaded every lwp_start
+	if (flags & PERF_EF_RELOAD) { }	*/
 
 	lwpflags = l->lwpcb.head->flags;
 	lwpflags |= (1U << eventnr);
@@ -1110,6 +1133,8 @@ static void perf_lwp_start(struct perf_event *event, int flags)
 	if (userwrite_lwpcb(l))
 		BUG();
 
+	percpu_write(active_lwp_struct, l);
+
 	if (lwp_start(l, 1))
 		BUG();
 
@@ -1138,22 +1163,31 @@ static void perf_lwp_stop(struct perf_event *event, int flags)
 	lwpflags &= ~(1U << eventnr);
 	l->lwpcb.head->flags = lwpflags;
 
+	/*
+	 * We could/should update update the period here but in the case of a
+	 * overflow we wouldn't have a lwp-event report to report.
+	 * Also, there should be no sample_period-changed between start and
+	 * stop, thus there are no overflows as in perf_lwp_start. All other
+	 * overflows should have been reported already (by the interrupt).
+	 *
+	 * overflow = lwpcb_update_period(l, hwc, l->xstate_counter[eventnr-1],
+	 *		l->events[eventnr-1].interval);
+	 *
+	 * l->xstate_counter[eventnr-1] = 0;
+	 */
+
 	if (userwrite_lwpcb(l))
 		BUG();
 
 	if (lwpflags & LWP_EVENT_MASK) {
 		if (lwp_start(l, 1))
 			BUG();
+	} else {
+		percpu_write(active_lwp_struct, 0);
 	}
 
 	raw_spin_unlock_irqrestore(&l->lock, lockflags);
 
-	/* update cached values */
-	lockflags = 0;
-	raw_spin_lock_irqsave(&l->lock, lockflags);
-	lwpcb_read_buffer(l);
-	raw_spin_unlock_irqrestore(&l->lock, lockflags);
-
 	perf_event_update_userpage(event);
 }
 
@@ -1170,16 +1204,148 @@ static void perf_lwp_del(struct perf_event *event, int flags)
 	perf_lwp_stop(event, flags);
 }
 
+static int
+lwpcb_report_event(struct lwp_struct *lwps, struct lwp_event *lwp_event,
+		struct pt_regs *regs)
+{
+	u64 period;
+	int overflow, event_idx, ret = 0;
+	struct perf_event *perf_event;
+	struct perf_sample_data data;
+	struct perf_raw_record raw;
+
+	event_idx = lwp_event->event_id - 1;
+	perf_event = lwps->registered_events[event_idx];
+
+	/*
+	 * The opposite COULD be a programmed lwp-event (id=255), but we
+	 * ignore them for now.
+	 */
+	if ((lwp_event->event_id <= LWP_EVENT_INVALID) ||
+			(lwp_event->event_id > lwps->eventmax) ||
+			(!perf_event))
+		return -EINVAL;
+
+	/* update lwps-event-counter */
+	period = lwps->lwpcb.events[event_idx].interval;
+	lwps->event_counter[event_idx] += period;
+
+	/* update sample_period */
+	overflow = lwpcb_update_period(lwps, perf_event, period, period);
+
+	if(overflow) {
+		memset(&data, 0, sizeof(data));
+		perf_sample_data_init(&data, lwp_event->inst_adr);
+
+		if (perf_event->attr.sample_type & PERF_SAMPLE_RAW) {
+			raw.size = sizeof(*lwp_event);
+			raw.data = lwp_event;
+			data.raw = &raw;
+		}
+
+		/* disable event eventually */
+		ret = perf_event_overflow(perf_event, &data, regs);
+	}
+
+	perf_event_update_userpage(perf_event);
+
+	return ret;
+}
+
+static int lwpcb_read_buffer(struct lwp_struct *lwps, struct pt_regs *regs)
+{
+	u32 bho, bto, bz;
+	int count, i;
+	char *buffer = lwps->buffer.buffer_base;
+	size_t eventsize = lwps->eventsize;
+	struct lwp_event *lwp_event;
+
+	bz = lwps->lwpcb.head->buffer_size;
+	bto = lwps->lwpcb.head->buffer_tail_offset;
+
+	/*
+	 * the last two checks are to prevent user-manipulations that could
+	 * cause damage
+	 */
+	if (lwp_read_head_offset(lwps, &bho) || (bho > bz) || (bho % eventsize))
+		BUG();
+
+	count = (((bho - bto) % bz) / eventsize);
+
+	if (userread_buffer(lwps, bto, bho))
+		BUG();
+
+	for (i = 0; i < count; i++) {
+		lwp_event = (struct lwp_event *) (buffer + bto);
+
+		/*
+		 * TODO: if lwpcb_report_event returns x > 0, then this event
+		 * should be stopped. But this is difficult because we are in
+		 * a interrupt. We would have to run perf_lwp_stop and this
+		 * function uses xsave/xrestore and other expensive operations.
+		 */
+		lwpcb_report_event(lwps, lwp_event, regs);
+
+		bto += eventsize;
+		if (bto >= bz)
+			bto = 0;
+	}
+
+	lwps->lwpcb.head->buffer_tail_offset = bto;
+
+	if (userwrite_buffer_tail_offset(lwps))
+		BUG();
+
+	return 0;
+}
+
 static void perf_lwp_read(struct perf_event *event)
 {
-	struct lwp_struct *l = (struct lwp_struct *) event->hw.config;
-	unsigned long flags;
+	/*
+	 * TODO: report current counter-states.
+	 *
+	 * Could be difficult because in the case of a overflow we wouldn't
+	 * have a lwp-event to report
+	 */
+}
 
-	raw_spin_lock_irqsave(&l->lock, flags);
+static void
+lwp_threshold_handler(struct lwp_struct *lwps, struct pt_regs *regs)
+{
+	unsigned long flags = 0;
 
-	lwpcb_read_buffer(l);
+	raw_spin_lock_irqsave(&lwps->lock, flags);
 
-	raw_spin_unlock_irqrestore(&l->lock, flags);
+	lwpcb_read_buffer(lwps, regs);
+
+	raw_spin_unlock_irqrestore(&lwps->lock, flags);
+}
+
+extern void lwp_threshold_intr1(void);
+
+void lwp_threshold_interrupt(struct pt_regs *regs)
+{
+	struct pt_regs *old_regs = set_irq_regs(regs);
+	struct lwp_struct *lwps = percpu_read(active_lwp_struct);
+
+	ack_APIC_irq();
+
+	exit_idle();
+
+	/* Has to be done, to update timers and for locking. */
+	irq_enter();
+	if(lwps)
+		lwp_threshold_handler(lwps, regs);
+	/*
+	 * else {
+	 *	This is likely a threshold-int triggert by a userspace-
+	 *	activated lwp.
+	 * }
+	 */
+
+	irq_exit();
+
+	set_irq_regs(old_regs);
 }
 
 static struct pmu perf_lwp_pmu = {
@@ -1239,12 +1405,10 @@ static void lwp_start_cpu(void *c)
 	msr.cfg.core_id = (u8) smp_processor_id();
 
 	/*
-	 * We currently do not support the threshold-interrupt so
-	 * bit 31 and [40..47] of msr.msr_value keep 0
-	 *
-	 * msr.cfg.allowed_events |= (1U << 31);
-	 * msr.cfg.interrupt_vector = xxx;
+	 * Threshold-Interrrupt-Setup.
 	 */
+	msr.cfg.allowed_events |= (1U << LWP_CAPS_THRESHOLD);
+	msr.cfg.interrupt_vector = LWP_THRESHOLD_VECTOR;
 
 	wrmsrl(MSR_AMD64_LWP_CFG, msr.msr_value);
 }
@@ -1280,6 +1444,8 @@ static __init int amd_lwp_init(void)
 	if (!test_bit(LWP_CAPS_THRESHOLD, &lwp_caps.supported_events))
 		return -ENODEV;
 
+	alloc_intr_gate(LWP_THRESHOLD_VECTOR, lwp_threshold_intr1);
+
 	get_online_cpus();
 
 	/*
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6419bb0..03d47b1 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -966,6 +966,8 @@ apicinterrupt REBOOT_VECTOR \
 apicinterrupt UV_BAU_MESSAGE \
 	uv_bau_message_intr1 uv_bau_message_interrupt
 #endif
+apicinterrupt LWP_THRESHOLD_VECTOR \
+	lwp_threshold_intr1 lwp_threshold_interrupt
 apicinterrupt LOCAL_TIMER_VECTOR \
 	apic_timer_interrupt smp_apic_timer_interrupt
 apicinterrupt X86_PLATFORM_IPI_VECTOR \
-- 
1.7.7


