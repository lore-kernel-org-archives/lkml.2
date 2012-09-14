Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2INGVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:21:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49071 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2INGVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:21:49 -0400
Date: Thu, 13 Sep 2012 23:21:34 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-ec145babe754f9ea1079034a108104b6001e001c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richardcochran@gmail.com, john.stultz@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, prarit@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com, john.stultz@linaro.org, tglx@linutronix.de,
        daniel.lezcano@linaro.org, prarit@redhat.com
In-Reply-To: <1347405963-35715-1-git-send-email-john.stultz@linaro.org>
References: <1347405963-35715-1-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] time:
  Fix timeekeping_get_ns overflow on 32bit systems
Git-Commit-ID: ec145babe754f9ea1079034a108104b6001e001c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:21:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ec145babe754f9ea1079034a108104b6001e001c
Gitweb:     http://git.kernel.org/tip/ec145babe754f9ea1079034a108104b6001e001c
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Tue, 11 Sep 2012 19:26:03 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:39:14 +0200

time: Fix timeekeping_get_ns overflow on 32bit systems

Daniel Lezcano reported seeing multi-second stalls from
keyboard input on his T61 laptop when NOHZ and CPU_IDLE
were enabled on a 32bit kernel.

He bisected the problem down to commit
1e75fa8be9fb6 ("time: Condense timekeeper.xtime into xtime_sec").

After reproducing this issue, I narrowed the problem down
to the fact that timekeeping_get_ns() returns a 64bit
nsec value that hasn't been accumulated. In some cases
this value was being then stored in timespec.tv_nsec
(which is a long).

On 32bit systems, with idle times larger then 4 seconds
(or less, depending on the value of xtime_nsec), the
returned nsec value would overflow 32bits. This limited
kept time from increasing, causing timers to not expire.

The fix is to make sure we don't directly store the
result of timekeeping_get_ns() into a tv_nsec field,
instead using a 64bit nsec value which can then be
added into the timespec via timespec_add_ns().

Reported-and-bisected-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Tested-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Acked-by: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Cochran <richardcochran@gmail.com>
Link: http://lkml.kernel.org/r/1347405963-35715-1-git-send-email-john.stultz@linaro.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/time/timekeeping.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

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
 
