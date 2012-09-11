Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759298Ab2IKX0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 19:26:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:42843 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306Ab2IKX0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 19:26:20 -0400
From: John Stultz <john.stultz@linaro.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH] time: Fix timeekeping_get_ns overflow on 32bit systems
Date: Tue, 11 Sep 2012 19:26:03 -0400
Message-Id: <1347405963-35715-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091123-9360-0000-0000-00000A88CDC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas: Please queue this in tip/timers/urgent for 3.6.

Daniel Lezcano reported seeing multi-second stalls from
keyboard input on his T61 laptop when NOHZ and CPU_IDLE
were enabled on a 32bit kernel.

He bisected the problem down to
1e75fa8be9fb61e1af46b5b3b176347a4c958ca1 (time: Condense
timekeeper.xtime into xtime_sec).

After reproducing this issue, I narrowed the problem down
to the fact that timekeeping_get_ns() returns a 64bit
nsec value that hasn't been accumulated. In some cases
this value was being then stored in timespec.tv_nsec
(which is a long).

On 32bit systems, With idle times larger then 4 seconds
(or less, depending on the value of xtime_nsec), the
returned nsec value would overflow 32bits. This limited
kept time from increasing, causing timers to not expire.

The fix is to make sure we don't directly store the
result of timekeeping_get_ns() into a tv_nsec field,
instead using a 64bit nsec value which can then be
added into the timespec via timespec_add_ns().

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Reported-and-bisected-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 kernel/time/timekeeping.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index 34e5eac..d3b91e7 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -303,10 +303,11 @@ void getnstimeofday(struct timespec *ts)
 		seq = read_seqbegin(&tk->lock);
 
 		ts->tv_sec = tk->xtime_sec;
-		ts->tv_nsec = timekeeping_get_ns(tk);
+		nsecs = timekeeping_get_ns(tk);
 
 	} while (read_seqretry(&tk->lock, seq));
 
+	ts->tv_nsec = 0;
 	timespec_add_ns(ts, nsecs);
 }
 EXPORT_SYMBOL(getnstimeofday);
@@ -345,6 +346,7 @@ void ktime_get_ts(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct timespec tomono;
+	s64 nsec;
 	unsigned int seq;
 
 	WARN_ON(timekeeping_suspended);
@@ -352,13 +354,14 @@ void ktime_get_ts(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&tk->lock);
 		ts->tv_sec = tk->xtime_sec;
-		ts->tv_nsec = timekeeping_get_ns(tk);
+		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 
 	} while (read_seqretry(&tk->lock, seq));
 
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec,
-				ts->tv_nsec + tomono.tv_nsec);
+	ts->tv_sec += tomono.tv_sec;
+	ts->tv_nsec = 0;
+	timespec_add_ns(ts, nsec + tomono.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(ktime_get_ts);
 
@@ -1244,6 +1247,7 @@ void get_monotonic_boottime(struct timespec *ts)
 {
 	struct timekeeper *tk = &timekeeper;
 	struct timespec tomono, sleep;
+	s64 nsec;
 	unsigned int seq;
 
 	WARN_ON(timekeeping_suspended);
@@ -1251,14 +1255,15 @@ void get_monotonic_boottime(struct timespec *ts)
 	do {
 		seq = read_seqbegin(&tk->lock);
 		ts->tv_sec = tk->xtime_sec;
-		ts->tv_nsec = timekeeping_get_ns(tk);
+		nsec = timekeeping_get_ns(tk);
 		tomono = tk->wall_to_monotonic;
 		sleep = tk->total_sleep_time;
 
 	} while (read_seqretry(&tk->lock, seq));
 
-	set_normalized_timespec(ts, ts->tv_sec + tomono.tv_sec + sleep.tv_sec,
-			ts->tv_nsec + tomono.tv_nsec + sleep.tv_nsec);
+	ts->tv_sec += tomono.tv_sec + sleep.tv_sec;
+	ts->tv_nsec = 0;
+	timespec_add_ns(ts, nsec + tomono.tv_nsec + sleep.tv_nsec);
 }
 EXPORT_SYMBOL_GPL(get_monotonic_boottime);
 
-- 
1.7.9.5

