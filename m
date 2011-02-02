Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab1BBWG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 17:06:26 -0500
Received: from hera.kernel.org ([140.211.167.34]:50197 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755017Ab1BBWGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:06:24 -0500
Date: Wed, 2 Feb 2011 22:06:07 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, tglx@linutronix.de, richard.cochran@omicron.at
In-Reply-To: <alpine.LFD.2.00.1102021222240.31804@localhost6.localdomain6>
References: <alpine.LFD.2.00.1102021222240.31804@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix-timers: Cleanup namespace
Message-ID: <tip-527087374faa488776a789375a7d6ea74fda6f71@git.kernel.org>
Git-Commit-ID: 527087374faa488776a789375a7d6ea74fda6f71
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 02 Feb 2011 22:06:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  527087374faa488776a789375a7d6ea74fda6f71
Gitweb:     http://git.kernel.org/tip/527087374faa488776a789375a7d6ea74fda6f71
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 2 Feb 2011 12:10:09 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 2 Feb 2011 15:28:19 +0100

posix-timers: Cleanup namespace

Rename register_posix_clock() to posix_timers_register_clock(). That's
what the function really does. As a side effect this cleans up the
posix_clock namespace for the upcoming dynamic posix_clock
infrastructure.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Richard Cochran <richard.cochran@omicron.at>
Cc: John Stultz <johnstul@us.ibm.com>
LKML-Reference: <alpine.LFD.2.00.1102021222240.31804@localhost6.localdomain6>
---
 drivers/char/mmtimer.c       |    2 +-
 include/linux/posix-timers.h |    2 +-
 kernel/posix-cpu-timers.c    |    4 ++--
 kernel/posix-timers.c        |   15 ++++++++-------
 4 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/char/mmtimer.c b/drivers/char/mmtimer.c
index ff41eb3..33dc229 100644
--- a/drivers/char/mmtimer.c
+++ b/drivers/char/mmtimer.c
@@ -840,7 +840,7 @@ static int __init mmtimer_init(void)
 	}
 
 	sgi_clock_period = NSEC_PER_SEC / sn_rtc_cycles_per_second;
-	register_posix_clock(CLOCK_SGI_CYCLE, &sgi_clock);
+	posix_timers_register_clock(CLOCK_SGI_CYCLE, &sgi_clock);
 
 	printk(KERN_INFO "%s: v%s, %ld MHz\n", MMTIMER_DESC, MMTIMER_VERSION,
 	       sn_rtc_cycles_per_second/(unsigned long)1E6);
diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 88b9256..9d6ffe2 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -101,7 +101,7 @@ struct k_clock {
 
 extern struct k_clock clock_posix_cpu;
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock);
+void posix_timers_register_clock(const clockid_t clock_id, struct k_clock *new_clock);
 
 /* function to call to trigger timer event */
 int posix_timer_event(struct k_itimer *timr, int si_private);
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 609e187..67fea9d 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1618,8 +1618,8 @@ static __init int init_posix_cpu_timers(void)
 	};
 	struct timespec ts;
 
-	register_posix_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
-	register_posix_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
+	posix_timers_register_clock(CLOCK_PROCESS_CPUTIME_ID, &process);
+	posix_timers_register_clock(CLOCK_THREAD_CPUTIME_ID, &thread);
 
 	cputime_to_timespec(cputime_one_jiffy, &ts);
 	onecputick = ts.tv_nsec;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index df629d8..af936fd 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -253,11 +253,11 @@ static __init int init_posix_timers(void)
 		.clock_get	= posix_get_monotonic_coarse,
 	};
 
-	register_posix_clock(CLOCK_REALTIME, &clock_realtime);
-	register_posix_clock(CLOCK_MONOTONIC, &clock_monotonic);
-	register_posix_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
-	register_posix_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
-	register_posix_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
+	posix_timers_register_clock(CLOCK_REALTIME, &clock_realtime);
+	posix_timers_register_clock(CLOCK_MONOTONIC, &clock_monotonic);
+	posix_timers_register_clock(CLOCK_MONOTONIC_RAW, &clock_monotonic_raw);
+	posix_timers_register_clock(CLOCK_REALTIME_COARSE, &clock_realtime_coarse);
+	posix_timers_register_clock(CLOCK_MONOTONIC_COARSE, &clock_monotonic_coarse);
 
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
@@ -433,7 +433,8 @@ static struct pid *good_sigevent(sigevent_t * event)
 	return task_pid(rtn);
 }
 
-void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
+void posix_timers_register_clock(const clockid_t clock_id,
+				 struct k_clock *new_clock)
 {
 	if ((unsigned) clock_id >= MAX_CLOCKS) {
 		printk(KERN_WARNING "POSIX clock register failed for clock_id %d\n",
@@ -454,7 +455,7 @@ void register_posix_clock(const clockid_t clock_id, struct k_clock *new_clock)
 
 	posix_clocks[clock_id] = *new_clock;
 }
-EXPORT_SYMBOL_GPL(register_posix_clock);
+EXPORT_SYMBOL_GPL(posix_timers_register_clock);
 
 static struct k_itimer * alloc_posix_timer(void)
 {
