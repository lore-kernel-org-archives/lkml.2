Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757547Ab2IUTMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 15:12:47 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58504 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab2IUTMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 15:12:44 -0400
Date: Fri, 21 Sep 2012 21:12:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20120921191239.GA24527@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: ec145babe754f9ea1079034a108104b6001e001c time: Fix timeekeping_get_ns overflow on 32bit systems

One more timekeeping fix for v3.6.

 Thanks,

	Ingo

------------------>
John Stultz (1):
      time: Fix timeekeping_get_ns overflow on 32bit systems


 kernel/time/timekeeping.c | 19 ++++++++++++-------
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
 

