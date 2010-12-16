Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab0LPAnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:43:22 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48987 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab0LPAnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:43:21 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=F8nnev=E5g?= <arve@android.com>
Subject: =?UTF-8?q?=5BPATCH=201/2=5D=5BRFC=5D=20hrtimers=3A=20extend=20hrtimer=20base=20code=20to=20handle=20more=20then=202=20clockids?=
Date: Wed, 15 Dec 2010 16:43:15 -0800
Message-Id: <1292460195-30536-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1292460048-28035-1-git-send-email-john.stultz@linaro.org>
References: <1292460048-28035-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resending, as I left off CCs before sending]

The hrtimer code is written mainly with CLOCK_REALTIME and CLOCK_MONOTONIC
in mind. These are clockids 0 and 1 resepctively. However, if we are
to introduce any new hrtimer bases, using new clockids, we have to skip
the cputimers (clockids 2,3) as well as other clockids that may not impelement
timers.

This patch adds a little bit of indirection between the clockid and
the base, so that we can extend the base by one when we add
a new clockid at number 7 or so.

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve Hjønnevåg <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/hrtimer.h |   18 +++++++++++++++++-
 kernel/hrtimer.c        |   30 ++++++++++++++++--------------
 2 files changed, 33 insertions(+), 15 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 330586f..e41b64b 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -149,7 +149,23 @@ struct hrtimer_clock_base {
 #endif
 };
 
-#define HRTIMER_MAX_CLOCK_BASES 2
+enum  hrtimer_base_type {
+	HRTIMER_BASE_REALTIME,
+	HRTIMER_BASE_MONOTONIC,
+	HRTIMER_MAX_CLOCK_BASES,
+};
+
+static inline int hrtimer_clockid_to_base(clockid_t clock_id)
+{
+	switch(clock_id) {
+		case CLOCK_REALTIME:
+			return HRTIMER_BASE_REALTIME;
+		case CLOCK_MONOTONIC:
+			return HRTIMER_BASE_MONOTONIC;
+	}
+	WARN_ON(1); /* Unknown clock_id */
+	return 0;
+}
 
 /*
  * struct hrtimer_cpu_base - the per cpu clock bases
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index 7a7a206..a6642c7 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -53,11 +53,10 @@
 /*
  * The timer bases:
  *
- * Note: If we want to add new timer bases, we have to skip the two
- * clock ids captured by the cpu-timers. We do this by holding empty
- * entries rather than doing math adjustment of the clock ids.
- * This ensures that we capture erroneous accesses to these clock ids
- * rather than moving them into the range of valid clock id's.
+ * There are more clockids then hrtimer bases. Thus, we index
+ * into the timer bases by the hrtimer_base_type enum. When trying
+ * to reach a base using a clockid, hrtimer_clockid_to_base() 
+ * is used to convert from clockid to the proper hrtimer_base_type.
  */
 DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 {
@@ -95,8 +94,8 @@ static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(tom);
-	base->clock_base[CLOCK_REALTIME].softirq_time = xtim;
-	base->clock_base[CLOCK_MONOTONIC].softirq_time =
+	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
+	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time =
 		ktime_add(xtim, tomono);
 }
 
@@ -184,10 +183,11 @@ switch_hrtimer_base(struct hrtimer *timer, struct hrtimer_clock_base *base,
 	struct hrtimer_cpu_base *new_cpu_base;
 	int this_cpu = smp_processor_id();
 	int cpu = hrtimer_get_target(this_cpu, pinned);
+	int basenum = hrtimer_clockid_to_base(base->index);
 
 again:
 	new_cpu_base = &per_cpu(hrtimer_bases, cpu);
-	new_base = &new_cpu_base->clock_base[base->index];
+	new_base = &new_cpu_base->clock_base[basenum];
 
 	if (base != new_base) {
 		/*
@@ -627,7 +627,7 @@ static void retrigger_next_event(void *arg)
 
 	/* Adjust CLOCK_REALTIME offset */
 	raw_spin_lock(&base->lock);
-	base->clock_base[CLOCK_REALTIME].offset =
+	base->clock_base[HRTIMER_BASE_REALTIME].offset =
 		timespec_to_ktime(realtime_offset);
 
 	hrtimer_force_reprogram(base, 0);
@@ -725,8 +725,8 @@ static int hrtimer_switch_to_hres(void)
 		return 0;
 	}
 	base->hres_active = 1;
-	base->clock_base[CLOCK_REALTIME].resolution = KTIME_HIGH_RES;
-	base->clock_base[CLOCK_MONOTONIC].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_REALTIME].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_MONOTONIC].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
 
@@ -1116,7 +1116,7 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 			   enum hrtimer_mode mode)
 {
 	struct hrtimer_cpu_base *cpu_base;
-
+	int base;
 	memset(timer, 0, sizeof(struct hrtimer));
 
 	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
@@ -1124,7 +1124,8 @@ static void __hrtimer_init(struct hrtimer *timer, clockid_t clock_id,
 	if (clock_id == CLOCK_REALTIME && mode != HRTIMER_MODE_ABS)
 		clock_id = CLOCK_MONOTONIC;
 
-	timer->base = &cpu_base->clock_base[clock_id];
+	base = hrtimer_clockid_to_base(clock_id);
+	timer->base = &cpu_base->clock_base[base];
 	hrtimer_init_timer_hres(timer);
 	timerqueue_init(&timer->node);
 
@@ -1160,9 +1161,10 @@ EXPORT_SYMBOL_GPL(hrtimer_init);
 int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
 {
 	struct hrtimer_cpu_base *cpu_base;
+	int base = hrtimer_clockid_to_base(which_clock);
 
 	cpu_base = &__raw_get_cpu_var(hrtimer_bases);
-	*tp = ktime_to_timespec(cpu_base->clock_base[which_clock].resolution);
+	*tp = ktime_to_timespec(cpu_base->clock_base[base].resolution);
 
 	return 0;
 }
-- 
1.7.3.2.146.gca209

