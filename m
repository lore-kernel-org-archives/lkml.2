Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759247Ab2EXXw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 19:52:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32974 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab2EXXwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 19:52:55 -0400
Date: Thu, 24 May 2012 16:52:41 -0700
From: tip-bot for Mike Galbraith <mgalbraith@suse.de>
Message-ID: <tip-5307c9556bc17e3cd26d4e94fc3b2565921834de@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mgalbraith@suse.de, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mgalbraith@suse.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1336472458.21924.78.camel@marge.simpson.net>
References: <1336472458.21924.78.camel@marge.simpson.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] tick: Add tick skew boot option
Git-Commit-ID: 5307c9556bc17e3cd26d4e94fc3b2565921834de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 16:52:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5307c9556bc17e3cd26d4e94fc3b2565921834de
Gitweb:     http://git.kernel.org/tip/5307c9556bc17e3cd26d4e94fc3b2565921834de
Author:     Mike Galbraith <mgalbraith@suse.de>
AuthorDate: Tue, 8 May 2012 12:20:58 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 25 May 2012 01:44:50 +0200

tick: Add tick skew boot option

Let the user decide whether power consumption or jitter is the
more important consideration for their machines.

Quoting removal commit af5ab277ded04bd9bc6b048c5a2f0e7d70ef0867:

"Historically, Linux has tried to make the regular timer tick on the
 various CPUs not happen at the same time, to avoid contention on
 xtime_lock.
    
 Nowadays, with the tickless kernel, this contention no longer happens
 since time keeping and updating are done differently. In addition,
 this skew is actually hurting power consumption in a measurable way on
 many-core systems."

Problems:

- Contrary to the above, systems do encounter contention on both
  xtime_lock and RCU structure locks when the tick is synchronized.
  
- Moderate sized RT systems suffer intolerable jitter due to the tick
  being synchronized.

- SGI reports the same for their large systems.

- Fully utilized systems reap no power saving benefit from skew removal,
  but do suffer from resulting induced lock contention.

- 0209f649 rcu: limit rcu_node leaf-level fanout
  This patch was born to combat lock contention which testing showed
  to have been _induced by_ skew removal.  Skew the tick, contention
  disappeared virtually completely.

Signed-off-by: Mike Galbraith <mgalbraith@suse.de>
Link: http://lkml.kernel.org/r/1336472458.21924.78.camel@marge.simpson.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 Documentation/kernel-parameters.txt |    9 +++++++++
 kernel/time/tick-sched.c            |   18 ++++++++++++++++++
 2 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b69cfdc12..ea38cd1 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2532,6 +2532,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	sched_debug	[KNL] Enables verbose scheduler debug messages.
 
+	skew_tick=	[KNL] Offset the periodic timer tick per cpu to mitigate
+			xtime_lock contention on larger systems, and/or RCU lock
+			contention on all systems with CONFIG_MAXSMP set.
+			Format: { "0" | "1" }
+			0 -- disable. (may be 1 via CONFIG_CMDLINE="skew_tick=1"
+			1 -- enable.
+			Note: increases power consumption, thus should only be
+			enabled if running jitter sensitive (HPC/RT) workloads.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 6a3a5b9..4eddbb5 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -814,6 +814,8 @@ static enum hrtimer_restart tick_sched_timer(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
+static int sched_skew_tick;
+
 /**
  * tick_setup_sched_timer - setup the tick emulation timer
  */
@@ -831,6 +833,14 @@ void tick_setup_sched_timer(void)
 	/* Get the next period (per cpu) */
 	hrtimer_set_expires(&ts->sched_timer, tick_init_jiffy_update());
 
+	/* Offset the tick to avert xtime_lock contention. */
+	if (sched_skew_tick) {
+		u64 offset = ktime_to_ns(tick_period) >> 1;
+		do_div(offset, num_possible_cpus());
+		offset *= smp_processor_id();
+		hrtimer_add_expires_ns(&ts->sched_timer, offset);
+	}
+
 	for (;;) {
 		hrtimer_forward(&ts->sched_timer, now, tick_period);
 		hrtimer_start_expires(&ts->sched_timer,
@@ -910,3 +920,11 @@ int tick_check_oneshot_change(int allow_nohz)
 	tick_nohz_switch_to_nohz();
 	return 0;
 }
+
+static int __init skew_tick(char *str)
+{
+	get_option(&str, &sched_skew_tick);
+
+	return 0;
+}
+early_param("skew_tick", skew_tick);
