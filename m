Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154Ab2GQWBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:01:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37367 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab2GQV7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:59:30 -0400
Subject: Patch "hrtimer: Update hrtimer base offsets each hrtimer_interrupt" has been added to the 3.4-stable tree
To: johnstul@us.ibm.com, a.p.zijlstra@chello.nl, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, prarit@redhat.com,
        tglx@linutronix.de
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 17 Jul 2012 14:59:21 -0700
In-Reply-To: <1342507196-54327-7-git-send-email-johnstul@us.ibm.com>
Message-ID: <13425623612227@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    hrtimer: Update hrtimer base offsets each hrtimer_interrupt

to the 3.4-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
and it can be found in the queue-3.4 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From johnstul@us.ibm.com  Tue Jul 17 14:28:09 2012
From: John Stultz <johnstul@us.ibm.com>
Date: Tue, 17 Jul 2012 02:39:55 -0400
Subject: hrtimer: Update hrtimer base offsets each hrtimer_interrupt
To: stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Prarit Bhargava <prarit@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Message-ID: <1342507196-54327-7-git-send-email-johnstul@us.ibm.com>

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
Link: http://lkml.kernel.org/r/1341960205-56738-8-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/hrtimer.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -657,6 +657,14 @@ static inline int hrtimer_enqueue_reprog
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
@@ -665,22 +673,12 @@ static inline int hrtimer_enqueue_reprog
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
@@ -1264,7 +1261,7 @@ void hrtimer_interrupt(struct clock_even
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


Patches currently in stable-queue which might be from johnstul@us.ibm.com are

queue-3.4/timekeeping-fix-leapsecond-triggered-load-spike-issue.patch
queue-3.4/hrtimer-update-hrtimer-base-offsets-each-hrtimer_interrupt.patch
queue-3.4/timekeeping-add-missing-update-call-in-timekeeping_resume.patch
queue-3.4/hrtimers-move-lock-held-region-in-hrtimer_interrupt.patch
queue-3.4/hrtimer-provide-clock_was_set_delayed.patch
queue-3.4/timekeeping-provide-hrtimer-update-function.patch
queue-3.4/timekeeping-maintain-ktime_t-based-offsets-for-hrtimers.patch
