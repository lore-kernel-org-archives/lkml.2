Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2GIJpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:45:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52400 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab2GIJpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:45:06 -0400
Date: Mon, 9 Jul 2012 02:44:52 -0700
From: tip-bot for John Stultz <johnstul@us.ibm.com>
Message-ID: <tip-d7e2e7fef1f0f4e1e614353a6c5eef4e18d98d2d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, prarit@redhat.com
In-Reply-To: <1341515538-5100-4-git-send-email-johnstul@us.ibm.com>
References: <1341515538-5100-4-git-send-email-johnstul@us.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] hrtimer:
  Update hrtimer base offsets each hrtimer_interrupt
Git-Commit-ID: d7e2e7fef1f0f4e1e614353a6c5eef4e18d98d2d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 09 Jul 2012 02:44:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7e2e7fef1f0f4e1e614353a6c5eef4e18d98d2d
Gitweb:     http://git.kernel.org/tip/d7e2e7fef1f0f4e1e614353a6c5eef4e18d98d2d
Author:     John Stultz <johnstul@us.ibm.com>
AuthorDate: Thu, 5 Jul 2012 15:12:18 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 9 Jul 2012 11:35:38 +0200

hrtimer: Update hrtimer base offsets each hrtimer_interrupt

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

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Prarit Bhargava <prarit@redhat.com>
CC: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1341515538-5100-4-git-send-email-johnstul@us.ibm.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/hrtimer.h   |    3 +++
 kernel/hrtimer.c          |   14 +++++++++++---
 kernel/time/timekeeping.c |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 3 deletions(-)

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
index d730678..56600c4 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -1258,18 +1258,26 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
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
@@ -1346,7 +1354,7 @@ retry:
 	 * interrupt routine. We give it 3 attempts to avoid
 	 * overreacting on some spurious event.
 	 */
-	now = ktime_get();
+	ktime_get_and_real_and_sleep_offset(&now, &real_offset, &sleep_offset);
 	cpu_base->nr_retries++;
 	if (++retries < 3)
 		goto retry;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cc2991d..b3404cf 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1251,6 +1251,40 @@ void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
 }
 
 /**
+ * ktime_get_and_real_and_sleep_offset() - hrtimer helper, gets monotonic ktime,
+ *	realtime offset, and sleep offsets.
+ */
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
+	*monotonic = ktime_add_ns(ktime_set(secs, 0), nsecs);
+	set_normalized_timespec(&wtom, -wtom.tv_sec, -wtom.tv_nsec);
+	*real_offset =	timespec_to_ktime(wtom);
+	*sleep_offset = timespec_to_ktime(sleep);
+}
+
+
+/**
  * ktime_get_monotonic_offset() - get wall_to_monotonic in ktime_t format
  */
 ktime_t ktime_get_monotonic_offset(void)
