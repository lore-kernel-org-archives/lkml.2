Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754897Ab2GJWo7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:44:59 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:43560 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2GJWn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:43:59 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org
Subject: [PATCH 6/6] hrtimer: Update hrtimer base offsets each hrtimer_interrupt
Date: Tue, 10 Jul 2012 18:43:25 -0400
Message-Id: <1341960205-56738-8-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071022-4242-0000-0000-000002474F67
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

CC: Ingo Molnar <mingo@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Prarit Bhargava <prarit@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: stable@vger.kernel.org
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 kernel/hrtimer.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 14a260a..669522b 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -657,6 +657,14 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 	return 0;
 }
 
+static inline ktime_t hrtimer_update_base(struct hrtimer_cpu_base *base)
+{
+	ktime_t *offs_real = &base->clock_base[HRTIMER_BASE_REALTIME].offset;
+	ktime_t *offs_boot = &base->clock_base[HRTIMER_BASE_BOOTTIME].offset;
+
+	return ktime_get_update_offsets(offs_real, offs_boot);
+}
+
 /*
  * Retrigger next event is called after clock was set
  *
@@ -665,22 +673,12 @@ static inline int hrtimer_enqueue_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base = &__get_cpu_var(hrtimer_bases);
-	struct timespec realtime_offset, xtim, wtm, sleep;
 
 	if (!hrtimer_hres_active())
 		return;
 
-	/* Optimized out for !HIGH_RES */
-	get_xtime_and_monotonic_and_sleep_offset(&xtim, &wtm, &sleep);
-	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
-
-	/* Adjust CLOCK_REALTIME offset */
 	raw_spin_lock(&base->lock);
-	base->clock_base[HRTIMER_BASE_REALTIME].offset =
-		timespec_to_ktime(realtime_offset);
-	base->clock_base[HRTIMER_BASE_BOOTTIME].offset =
-		timespec_to_ktime(sleep);
-
+	hrtimer_update_base(base);
 	hrtimer_force_reprogram(base, 0);
 	raw_spin_unlock(&base->lock);
 }
@@ -710,7 +708,6 @@ static int hrtimer_switch_to_hres(void)
 		base->clock_base[i].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
-
 	/* "Retrigger" the interrupt to get things going */
 	retrigger_next_event(NULL);
 	local_irq_restore(flags);
@@ -1264,7 +1261,7 @@ void hrtimer_interrupt(struct clock_event_device *dev)
 	dev->next_event.tv64 = KTIME_MAX;
 
 	raw_spin_lock(&cpu_base->lock);
-	entry_time = now = ktime_get();
+	entry_time = now = hrtimer_update_base(cpu_base);
 retry:
 	expires_next.tv64 = KTIME_MAX;
 	/*
@@ -1342,9 +1339,12 @@ retry:
 	 * We need to prevent that we loop forever in the hrtimer
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
+	 *
+	 * Acquire base lock for updating the offsets and retrieving
+	 * the current time.
 	 */
 	raw_spin_lock(&cpu_base->lock);
-	now = ktime_get();
+	now = hrtimer_update_base(cpu_base);
 	cpu_base->nr_retries++;
 	if (++retries < 3)
 		goto retry;
-- 
1.7.9.5

