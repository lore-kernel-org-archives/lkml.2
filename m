Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758673Ab1BPEUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 23:20:24 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56418 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755158Ab1BPEUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 23:20:14 -0500
From: John Stultz <john.stultz@linaro.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Jamie Lokier <jamie@shareable.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Shishkin <virtuoso@slind.org>,
        =?UTF-8?q?Arve=20Hj=C3=83=C2=B8nnev=C3=83=C2=A5g?= 
	<arve@android.com>
Subject: [PATCH 3/5] time: Extend get_xtime_and_monotonic_offset() to also return sleep
Date: Tue, 15 Feb 2011 20:20:05 -0800
Message-Id: <1297830007-426-4-git-send-email-john.stultz@linaro.org>
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

Extend get_xtime_and_monotonic_offset to
get_xtime_and_monotonic_and_sleep_offset().

CC: Jamie Lokier <jamie@shareable.org>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Shishkin <virtuoso@slind.org>
CC: Arve HjÃ¸nnevÃ¥g <arve@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 include/linux/time.h      |    3 ++-
 kernel/hrtimer.c          |    9 +++++----
 kernel/time/timekeeping.c |    5 ++++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index fa39150..02d48fb 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -124,7 +124,8 @@ unsigned long get_seconds(void);
 struct timespec current_kernel_time(void);
 struct timespec __current_kernel_time(void); /* does not take xtime_lock */
 struct timespec get_monotonic_coarse(void);
-void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom);
+void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
+				struct timespec *wtom, struct timespec *sleep);
 
 #define CURRENT_TIME		(current_kernel_time())
 #define CURRENT_TIME_SEC	((struct timespec) { get_seconds(), 0 })
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ca99e24..e8bf3ad 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -91,9 +91,9 @@ static inline int hrtimer_clockid_to_base(clockid_t clock_id)
 static void hrtimer_get_softirq_time(struct hrtimer_cpu_base *base)
 {
 	ktime_t xtim, tomono;
-	struct timespec xts, tom;
+	struct timespec xts, tom, slp;
 
-	get_xtime_and_monotonic_offset(&xts, &tom);
+	get_xtime_and_monotonic_and_sleep_offset(&xts, &tom, &slp);
 
 	xtim = timespec_to_ktime(xts);
 	tomono = timespec_to_ktime(tom);
@@ -614,12 +614,13 @@ static int hrtimer_reprogram(struct hrtimer *timer,
 static void retrigger_next_event(void *arg)
 {
 	struct hrtimer_cpu_base *base;
-	struct timespec realtime_offset, wtm;
+	struct timespec realtime_offset, wtm, sleep;
 
 	if (!hrtimer_hres_active())
 		return;
 
-	get_xtime_and_monotonic_offset(&realtime_offset, &wtm);
+	get_xtime_and_monotonic_and_sleep_offset(&realtime_offset, &wtm,
+							&sleep);
 	set_normalized_timespec(&realtime_offset, -wtm.tv_sec, -wtm.tv_nsec);
 
 	base = &__get_cpu_var(hrtimer_bases);
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 5fbd9aa..29f75aa 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -1043,8 +1043,10 @@ void do_timer(unsigned long ticks)
  * get_xtime_and_monotonic_offset() - get xtime and wall_to_monotonic
  * @xtim:	pointer to timespec to be set with xtime
  * @wtom:	pointer to timespec to be set with wall_to_monotonic
+ * @sleep:	pointer to timespec to be set with time in suspend
  */
-void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom)
+void get_xtime_and_monotonic_and_sleep_offset(struct timespec *xtim,
+				struct timespec *wtom, struct timespec *sleep)
 {
 	unsigned long seq;
 
@@ -1052,6 +1054,7 @@ void get_xtime_and_monotonic_offset(struct timespec *xtim, struct timespec *wtom
 		seq = read_seqbegin(&xtime_lock);
 		*xtim = xtime;
 		*wtom = wall_to_monotonic;
+		*sleep = total_sleep_time;
 	} while (read_seqretry(&xtime_lock, seq));
 }
 
-- 
1.7.3.2.146.gca209

