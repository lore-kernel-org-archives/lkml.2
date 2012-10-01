Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655Ab2JAXi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:38:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35045 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459Ab2JAW7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:54 -0400
Message-Id: <20121001225158.336581751@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Willy Tarreau <w@1wt.eu>
Subject: [ 017/180] 2.6.32.x: hrtimer: Update hrtimer base offsets each hrtimer_interrupt
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <johnstul@us.ibm.com>

This is a backport of 5baefd6d84163443215f4a99f6a20f054ef11236

The update of the hrtimer base offsets on all cpus cannot be made
atomically from the timekeeper.lock held and interrupt disabled region
as smp function calls are not allowed there.

clock_was_set(), which enforces the update on all cpus, is called
either from preemptible process context in case of do_settimeofday()
or from the softirq context when the offset modification happened in
the timer interrupt itself due to a leap second.

In both cases there is a race window for an hrtimer interrupt between
dropping timekeeper lock, enabling interrupts and clock_was_set()
issuing the updates. Any interrupt which arrives in that window will
see the new time but operate on stale offsets.

So we need to make sure that an hrtimer interrupt always sees a
consistent state of time and offsets.

ktime_get_update_offsets() allows us to get the current monotonic time
and update the per cpu hrtimer base offsets from hrtimer_interrupt()
to capture a consistent state of monotonic time and the offsets. The
function replaces the existing ktime_get() calls in hrtimer_interrupt().

The overhead of the new function vs. ktime_get() is minimal as it just
adds two store operations.

This ensures that any changes to realtime or boottime offsets are
noticed and stored into the per-cpu hrtimer base structures, prior to
any hrtimer expiration and guarantees that timers are not expired early.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341960205-56738-8-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/hrtimer.c |   27 ++++++++++++---------------
 1 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 8ba6d31..2818422 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -603,6 +603,12 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 	return res;
 }
 
+static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
+{
+	ktime_t *offs_real = &base->clock_base[CLOCK_REALTIME].offset;
+
+	return ktime_get_update_offsets(offs_real);
+}
 
 /*
  * Retrigger next event is called after clock was set
@@ -612,26 +618,15 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset;
-	unsigned long seq;
 
 	if (!hrtimer_hres_active())
 		return;
 
-	do {
-		seq = read_seqbegin(&xtime_lock);
-		set_normalized_timespec(&realtime_offset,
-					-wall_to_monotonic.tv_sec,
-					-wall_to_monotonic.tv_nsec);
-	} while (read_seqretry(&xtime_lock, seq));
-
 	base = &__get_cpu_var(hrtimer_bases);
 
 	/* Adjust CLOCK_REALTIME offset */
 	spin_lock(&base->lock);
-	base->clock_base[CLOCK_REALTIME].offset =
-		timespec_to_ktime(realtime_offset);
-
+	hrtimer_update_base(base);
 	hrtimer_force_reprogram(base, 0);
 	spin_unlock(&base->lock);
 }
@@ -731,7 +726,6 @@ static int hrtimer_switch_to_hres(void)
 	base->clock_base[CLOCK_MONOTONIC].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
-
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
@@ -1264,7 +1258,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	dev->next_event.tv64 = KTIME_MAX;
 
 	spin_lock(&cpu_base->lock);
-	entry_time = now = ktime_get();
+	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
 	expires_next.tv64 = KTIME_MAX;
 	/*
@@ -1340,9 +1334,12 @@ retry:
 	 * We need to prevent that we loop forever in the hrtimer
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
+	 *
+	 * Acquire base lock for updating the offsets and retrieving
+	 * the current time.
 	 */
 	spin_lock(&cpu_base->lock);
-	now = ktime_get();
+	now = hrtimer_update_base(cpu_base);
 	cpu_base->nr_retries++;
 	if (++retries < 3)
 		goto retry;
-- 
1.7.2.1.45.g54fbc



