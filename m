Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab1AaOEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 09:04:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:46418 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493Ab1AaOEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 09:04:11 -0500
Date: Mon, 31 Jan 2011 14:03:49 GMT
From: tip-bot for Torben Hohn <torbenh@gmx.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torbenh@gmx.de, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20110127145855.23248.56933.stgit@localhost>
References: <20110127145855.23248.56933.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] time: Move do_timer() to kernel/time/timekeeping.c
Message-ID: <tip-871cf1e5f2a17702f58539a3af8b18fc8666ad4c@git.kernel.org>
Git-Commit-ID: 871cf1e5f2a17702f58539a3af8b18fc8666ad4c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 Jan 2011 14:03:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  871cf1e5f2a17702f58539a3af8b18fc8666ad4c
Gitweb:     http://git.kernel.org/tip/871cf1e5f2a17702f58539a3af8b18fc8666ad4c
Author:     Torben Hohn <torbenh@gmx.de>
AuthorDate: Thu, 27 Jan 2011 15:58:55 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 31 Jan 2011 14:55:41 +0100

time: Move do_timer() to kernel/time/timekeeping.c

do_timer() is primary timekeeping related. calc_global_load() is
called from do_timer() as well, but that's more for historical
reasons.

[ tglx: Fixed up the calc_global_load() reject andmassaged changelog ]

Signed-off-by: Torben Hohn <torbenh@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: johnstul@us.ibm.com
Cc: yong.zhang0@gmail.com
Cc: hch@infradead.org
LKML-Reference: <20110127145855.23248.56933.stgit@localhost>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/time.h      |    1 -
 kernel/time/timekeeping.c |   14 +++++++++++++-
 kernel/timer.c            |   13 -------------
 3 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/include/linux/time.h b/include/linux/time.h
index 1e6d3b5..86a9c48 100644
--- a/include/linux/time.h
+++ b/include/linux/time.h
@@ -166,7 +166,6 @@ extern void monotonic_to_bootbased(struct timespec *ts);
 extern struct timespec timespec_trunc(struct timespec t, unsigned gran);
 extern int timekeeping_valid_for_hres(void);
 extern u64 timekeeping_max_deferment(void);
-extern void update_wall_time(void);
 extern void timekeeping_leap_insert(int leapsecond);
 
 struct tms;
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index d27c756..c1a178c 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -779,7 +779,7 @@ static cycle_t logarithmic_accumulation(cycle_t offset, int shift)
  *
  * Called from the timer interrupt, must hold a write on xtime_lock.
  */
-void update_wall_time(void)
+static void update_wall_time(void)
 {
 	struct clocksource *clock;
 	cycle_t offset;
@@ -946,3 +946,15 @@ struct timespec get_monotonic_coarse(void)
 				now.tv_nsec + mono.tv_nsec);
 	return now;
 }
+
+/*
+ * The 64-bit jiffies value is not atomic - you MUST NOT read it
+ * without sampling the sequence number in xtime_lock.
+ * jiffies is defined in the linker script...
+ */
+void do_timer(unsigned long ticks)
+{
+	jiffies_64 += ticks;
+	update_wall_time();
+	calc_global_load(ticks);
+}
diff --git a/kernel/timer.c b/kernel/timer.c
index 43ca993..87f656c 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1293,19 +1293,6 @@ void run_local_timers(void)
 	raise_softirq(TIMER_SOFTIRQ);
 }
 
-/*
- * The 64-bit jiffies value is not atomic - you MUST NOT read it
- * without sampling the sequence number in xtime_lock.
- * jiffies is defined in the linker script...
- */
-
-void do_timer(unsigned long ticks)
-{
-	jiffies_64 += ticks;
-	update_wall_time();
-	calc_global_load(ticks);
-}
-
 #ifdef __ARCH_WANT_SYS_ALARM
 
 /*
