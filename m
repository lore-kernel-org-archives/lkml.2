Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab1BPEUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:20:18 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:56316 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638Ab1BPEUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:20:13 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=83=C2=B8nnev=C3=83=C2=A5g?= 
	<arve@android.com>
Subject: [PATCH 4/5] timers: Add CLOCK_BOOTTIME hrtimer base
Date: Tue, 15 Feb 2011 20:20:06 -0800
Message-Id: <1297830007-426-5-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
References: <1297830007-426-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CLOCK_MONOTONIC stops while the system is in suspend. This is because
to applications system suspend is invisible. However, there is a
growing set of applications that are wanting to be suspend-aware,
but do not want to deal with the complications of CLOCK_REALTIME
(which might jump around if settimeofday is called).

For these applications, I propose a new clockid: CLOCK_BOOTTIME.
CLOCK_BOOTTIME is idential to CLOCK_MONOTONIC, except it also
includes any time spent in suspend.

This patch add hrtimer base for CLOCK_BOOTTIME, using
get_monotonic_boottime/ktime_get_boottime, to allow
in kernel users to set timers against.

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve HjÃ¸nnevÃ¥g <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/hrtimer.h |    1 +
 include/linux/time.h    |    1 +
 kernel/hrtimer.c        |   16 ++++++++++++----
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
index 7a9e7ee..6bc1804 100644
--- a/include/linux/hrtimer.h
+++ b/include/linux/hrtimer.h
@@ -151,6 +151,7 @@ struct hrtimer_clock_base {
 enum  hrtimer_base_type {
 	HRTIMER_BASE_REALTIME,
 	HRTIMER_BASE_MONOTONIC,
+	HRTIMER_BASE_BOOTTIME,
 	HRTIMER_MAX_CLOCK_BASES,
 };
 
diff --git a/include/linux/time.h b/include/linux/time.h
index 02d48fb..454a262 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -293,6 +293,7 @@ struct itimerval {
 #define CLOCK_MONOTONIC_RAW		4
 #define CLOCK_REALTIME_COARSE		5
 #define CLOCK_MONOTONIC_COARSE		6
+#define CLOCK_BOOTTIME			7
 
 /*
  * The IDs of various hardware clocks:
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index e8bf3ad..4c53af1 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -73,6 +73,11 @@ DEFINE_PER_CPU(struct hrtimer_cpu_base, hrtimer_bases) =
 			.get_time = &ktime_get,
 			.resolution = KTIME_LOW_RES,
 		},
+		{
+			.index = CLOCK_BOOTTIME,
+			.get_time = &ktime_get_boottime,
+			.resolution = KTIME_LOW_RES,
+		},
 	}
 };
 
@@ -90,16 +95,17 @@ static inline int hrtimer_clockid_to_base(clockid_t clock_id)
  */
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
-	ktime_t xtim, tomono;
+	ktime_t xtim, mono, boot;
 	struct timespec xts, tom, slp;
 
 	get_xtime_and_monotonic_and_sleep_offset(&xts, &tom, &slp);
 
 	xtim = timespec_to_ktime(xts);
-	tomono = timespec_to_ktime(tom);
+	mono = ktime_add(xtim, timespec_to_ktime(tom));
+	boot = ktime_add(mono, timespec_to_ktime(slp));
 	base->clock_base[HRTIMER_BASE_REALTIME].softirq_time = xtim;
-	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time =
-		ktime_add(xtim, tomono);
+	base->clock_base[HRTIMER_BASE_MONOTONIC].softirq_time = mono;
+	base->clock_base[HRTIMER_BASE_BOOTTIME].softirq_time = boot;
 }
 
 /*
@@ -727,6 +733,7 @@ static int hrtimer_switch_to_hres(void)
 	base->hres_active = 1;
 	base->clock_base[HRTIMER_BASE_REALTIME].resolution = KTIME_HIGH_RES;
 	base->clock_base[HRTIMER_BASE_MONOTONIC].resolution = KTIME_HIGH_RES;
+	base->clock_base[HRTIMER_BASE_BOOTTIME].resolution = KTIME_HIGH_RES;
 
 	tick_setup_sched_timer();
 
@@ -1719,6 +1726,7 @@ void __init hrtimers_init(void)
 {
 	hrtimer_clock_to_base_table[CLOCK_REALTIME] = HRTIMER_BASE_REALTIME;
 	hrtimer_clock_to_base_table[CLOCK_MONOTONIC] = HRTIMER_BASE_MONOTONIC;
+	hrtimer_clock_to_base_table[CLOCK_BOOTTIME] = HRTIMER_BASE_BOOTTIME;
 
 	hrtimer_cpu_notify(&hrtimers_nb, (unsigned long)CPU_UP_PREPARE,
 			  (void *)(long)smp_processor_id());
-- 
1.7.3.2.146.gca209

