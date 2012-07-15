Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2GOJAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 05:00:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab2GOJAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 05:00:04 -0400
Date: Sun, 15 Jul 2012 01:59:45 -0700
From: tip-bot for John Stultz <john.stultz@linaro.org>
Message-ID: <tip-f2a5a0854efc62abe7f69e9947842cb135837f9a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, johnstul@us.ibm.com, richardcochran@gmail.com,
        john.stultz@linaro.org, tglx@linutronix.de, prarit@redhat.com
Reply-To: john.stultz@linaro.org, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, johnstul@us.ibm.com,
        a.p.zijlstra@chello.nl, richardcochran@gmail.com, tglx@linutronix.de,
        prarit@redhat.com
In-Reply-To: <1342156917-25092-7-git-send-email-john.stultz@linaro.org>
References: <1342156917-25092-7-git-send-email-john.stultz@linaro.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Move arch_gettimeoffset()
  usage into timekeeping_get_ns()
Git-Commit-ID: f2a5a0854efc62abe7f69e9947842cb135837f9a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Jul 2012 01:59:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f2a5a0854efc62abe7f69e9947842cb135837f9a
Gitweb:     http://git.kernel.org/tip/f2a5a0854efc62abe7f69e9947842cb135837f9a
Author:     John Stultz <john.stultz@linaro.org>
AuthorDate: Fri, 13 Jul 2012 01:21:55 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Sun, 15 Jul 2012 10:39:06 +0200

time: Move arch_gettimeoffset() usage into timekeeping_get_ns()

Since we call arch_gettimeoffset() in all the accessor
functions, move arch_gettimeoffset() calls into
timekeeping_get_ns() and timekeeping_get_ns_raw() to simplify
the code.

This also makes the code easier to maintain as we don't have to
worry about forgetting the arch_gettimeoffset() as has happened
in the past.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Reviewed-by: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-7-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/timekeeping.c |   29 ++++++++++-------------------
 1 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index cb4a433ba..e43289d 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -191,13 +191,17 @@ static inline s64 timekeeping_get_ns(void)
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
 	nsec = cycle_delta * timekeeper.mult + timekeeper.xtime_nsec;
-	return nsec >> timekeeper.shift;
+	nsec >>= timekeeper.shift;
+
+	/* If arch requires, add in gettimeoffset() */
+	return nsec + arch_gettimeoffset();
 }
 
 static inline s64 timekeeping_get_ns_raw(void)
 {
 	cycle_t cycle_now, cycle_delta;
 	struct clocksource *clock;
+	s64 nsec;
 
 	/* read clocksource: */
 	clock = timekeeper.clock;
@@ -206,8 +210,11 @@ static inline s64 timekeeping_get_ns_raw(void)
 	/* calculate the delta since the last update_wall_time: */
 	cycle_delta = (cycle_now - clock->cycle_last) & clock->mask;
 
-	/* return delta convert to nanoseconds. */
-	return clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+	/* convert delta to nanoseconds. */
+	nsec = clocksource_cyc2ns(cycle_delta, clock->mult, clock->shift);
+
+	/* If arch requires, add in gettimeoffset() */
+	return nsec + arch_gettimeoffset();
 }
 
 static void update_rt_offset(void)
@@ -282,9 +289,6 @@ void getnstimeofday(struct timespec *ts)
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
 
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
-
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts, nsecs);
@@ -304,8 +308,6 @@ ktime_t ktime_get(void)
 				timekeeper.wall_to_monotonic.tv_sec;
 		nsecs = timekeeping_get_ns() +
 				timekeeper.wall_to_monotonic.tv_nsec;
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
 
 	} while (read_seqretry(&timekeeper.lock, seq));
 	/*
@@ -336,8 +338,6 @@ void ktime_get_ts(struct timespec *ts)
 		ts->tv_sec = timekeeper.xtime_sec;
 		ts->tv_nsec = timekeeping_get_ns();
 		tomono = timekeeper.wall_to_monotonic;
-		/* If arch requires, add in gettimeoffset() */
-		ts->tv_nsec += arch_gettimeoffset();
 
 	} while (read_seqretry(&timekeeper.lock, seq));
 
@@ -365,8 +365,6 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 	WARN_ON_ONCE(timekeeping_suspended);
 
 	do {
-		u32 arch_offset;
-
 		seq = read_seqbegin(&timekeeper.lock);
 
 		*ts_raw = timekeeper.raw_time;
@@ -376,11 +374,6 @@ void getnstime_raw_and_real(struct timespec *ts_raw, struct timespec *ts_real)
 		nsecs_raw = timekeeping_get_ns_raw();
 		nsecs_real = timekeeping_get_ns();
 
-		/* If arch requires, add in gettimeoffset() */
-		arch_offset = arch_gettimeoffset();
-		nsecs_raw += arch_offset;
-		nsecs_real += arch_offset;
-
 	} while (read_seqretry(&timekeeper.lock, seq));
 
 	timespec_add_ns(ts_raw, nsecs_raw);
@@ -1338,8 +1331,6 @@ ktime_t ktime_get_update_offsets(ktime_t *offs_real, ktime_t *offs_boot)
 
 		secs = timekeeper.xtime_sec;
 		nsecs = timekeeping_get_ns();
-		/* If arch requires, add in gettimeoffset() */
-		nsecs += arch_gettimeoffset();
 
 		*offs_real = timekeeper.offs_real;
 		*offs_boot = timekeeper.offs_boot;
