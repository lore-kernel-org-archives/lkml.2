Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933318Ab2GCCQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 22:16:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42548 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139Ab2GCCQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 22:16:36 -0400
From: John Stultz <johnstul@us.ibm.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <johnstul@us.ibm.com>, Prarit Bhargava <prarit@redhat.com>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/3] [RFC] hrtimer: Update hrtimer base offsets each hrtimer_interrupt
Date: Mon,  2 Jul 2012 22:16:06 -0400
Message-Id: <1341281766-22722-4-git-send-email-johnstul@us.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com>
References: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070302-1780-0000-0000-0000070BB8A8
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000284; HX=3.00000191; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00153277; UDB=6.00034639; UTC=2012-07-03
 02:16:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces a new funciton which captures the
CLOCK_MONOTONIC time, along with the CLOCK_REALTIME and
CLOCK_BOOTTIME offsets at the same moment. This new function
is then used in place of ktime_get() when hrtimer_interrupt()
is expiring timers.

This ensures that any changes to realtime or boottime offsets
are noticed and stored into the per-cpu hrtimer base structures,
prior to doing any hrtimer expiration. This should ensure that
timers are not expired early if the offsets changes under us.

This is useful in the case where clock_was_set() is called from
atomic context and have to schedule the hrtimer base offset update
via a timer, as it provides extra robustness in the face of any
possible timer delay.

CC: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: John Stultz <johnstul@us.ibm.com>
---
 include/linux/hrtimer.h   |    3 +++
 kernel/hrtimer.c          |   14 +++++++++++---
 kernel/time/timekeeping.c |   35 +++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index fd0dc30..f6b2a74 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -320,6 +320,9 @@ extern ktime_t ktime_get(void);
 extern ktime_t ktime_get_real(void);
 extern ktime_t ktime_get_boottime(void);
 extern ktime_t ktime_get_monotonic_offset(void);
+extern void ktime_get_and_real_and_sleep_offset(ktime_t *monotonic,
+						ktime_t *real_offset,
+						ktime_t *sleep_offset);
 
 DECLARE_PER_CPU(struct tick_device, tick_cpu_device);
 
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 393fd4d..0e78b3e 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1260,18 +1260,26 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
 void hrtimer_interrupt(struct clock_event_device *dev)
 {
 	struct hrtimer_cpu_base *cpu_base = &__get_cpu_var(hrtimer_bases);
-	ktime_t expires_next, now, entry_time, delta;
+	ktime_t expires_next, now, entry_time, delta, real_offset, sleep_offset;
 	int i, retries = 0;
 
 	BUG_ON(!cpu_base->hres_active);
 	cpu_base->nr_events++;
 	dev->next_event.tv64 = KTIME_MAX;
 
-	entry_time = now = ktime_get();
+
+	ktime_get_and_real_and_sleep_offset(&now, &real_offset, &sleep_offset);
+
+	entry_time = now;
 retry:
 	expires_next.tv64 = KTIME_MAX;
 
 	raw_spin_lock(&cpu_base->lock);
+
+	/* Update base offsets, to avoid early wakeups */
+	cpu_base->clock_base[HRTIMER_BASE_REALTIME].offset = real_offset;
+	cpu_base->clock_base[HRTIMER_BASE_BOOTTIME].offset = sleep_offset;
+
 	/*
 	 * We set expires_next to KTIME_MAX here with cpu_base->lock
 	 * held to prevent that a timer is enqueued in our queue via
@@ -1348,7 +1356,7 @@ retry:
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
 	 */
-	now = ktime_get();
+	ktime_get_and_real_and_sleep_offset(&now, &real_offset, &sleep_offset);
 	cpu_base->nr_retries++;
 	if (++retries < 3)
 		goto retry;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cc2991d..c2ba132 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1250,6 +1250,41 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 	} while (read_seqretry(&timekeeper.lock, seq));
 }
 
+
+void ktime_get_and_real_and_sleep_offset(ktime_t *monotonic,
+						ktime_t *real_offset,
+						ktime_t *sleep_offset)
+{
+	unsigned long seq;
+	struct timespec wtom, sleep;
+	u64 secs, nsecs;
+
+	do {
+		seq = read_seqbegin(&timekeeper.lock);
+
+		secs = timekeeper.xtime.tv_sec +
+				timekeeper.wall_to_monotonic.tv_sec;
+		nsecs = timekeeper.xtime.tv_nsec +
+				timekeeper.wall_to_monotonic.tv_nsec;
+		nsecs += timekeeping_get_ns();
+		/* If arch requires, add in gettimeoffset() */
+		nsecs += arch_gettimeoffset();
+
+		wtom = timekeeper.wall_to_monotonic;
+		sleep = timekeeper.total_sleep_time;
+	} while (read_seqretry(&timekeeper.lock, seq));
+
+
+	*monotonic = ktime_add_ns(ktime_set(secs, 0), nsecs);
+	set_normalized_timespec(&wtom, -wtom.tv_sec, -wtom.tv_nsec);
+	*real_offset =	timespec_to_ktime(wtom);
+	*sleep_offset = timespec_to_ktime(sleep);
+}
+
+
+
+
+
 /**
  * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
  */
-- 
1.7.9.5

