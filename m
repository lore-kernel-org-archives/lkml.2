Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932998Ab1CXRtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:49:06 -0400
Received: from flusers.ccur.com ([173.221.59.2]:58124 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756575Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:04 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 22/24] jrcu: precise vs sloppy sample timing
Message-ID: <20110324174804.GA18958@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: test harness: increase sampling period precision.

Normally, jrcu tries to 'catch a ride' with any other
local timer interrupt happening on the monitoring cpu.
It does this through the hrtimer 'slop' mechanism.
Such sloppiness, though, defeats attempts to stress-test
jrcu via shortened sampling periods.

The precise/sloppy state is changeable at runtime:

    echo precise=1 >/sys/kernel/debug/rcu/rcudata
    echo precise=0 >/sys/kernel/debug/rcu/rcudata

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -137,6 +137,8 @@ static int rcu_hz = RCU_HZ;
 static int rcu_hz_period_us = RCU_HZ_PERIOD_US;
 static int rcu_hz_delta_us = RCU_HZ_DELTA_US;
 
+static int rcu_hz_precise;
+
 int rcu_scheduler_active __read_mostly;
 int rcu_nmi_seen __read_mostly;
 
@@ -436,7 +438,8 @@ static enum hrtimer_restart rcu_timer_fu
 	raise_softirq(RCU_SOFTIRQ);
 
 	next = ktime_add_ns(ktime_get(), rcu_hz_period_ns);
-	hrtimer_set_expires_range_ns(&rcu_timer, next, rcu_hz_delta_ns);
+	hrtimer_set_expires_range_ns(&rcu_timer, next,
+		rcu_hz_precise ? 0 : rcu_hz_delta_ns);
 	return HRTIMER_RESTART;
 }
 
@@ -539,7 +542,13 @@ static int jrcud_func(void *arg)
 	pr_info("JRCU: daemon started. Will operate at ~%d Hz.\n", rcu_hz);
 
 	while (!kthread_should_stop()) {
-		usleep_range(rcu_hz_period_us, rcu_hz_period_us + rcu_hz_delta_us);
+		if (rcu_hz_precise) {
+			usleep_range(rcu_hz_period_us,
+				rcu_hz_period_us);
+		} else {
+			usleep_range(rcu_hz_period_us,
+				rcu_hz_period_us + rcu_hz_delta_us);
+		}
 		rcu_delimit_batches();
 	}
 
@@ -576,7 +585,9 @@ static int rcu_debugfs_show(struct seq_f
 {
 	int cpu, q;
 
-	seq_printf(m, "%14u: hz\n", rcu_hz);
+	seq_printf(m, "%14u: hz, %s\n",
+		rcu_hz,
+		rcu_hz_precise ? "precise" : "sloppy");
 
 	seq_printf(m, "%14u: watchdog (secs)\n", rcu_wdog_lim / (int)USEC_PER_SEC);
 	seq_printf(m, "%14d: #secs left on watchdog\n",
@@ -686,6 +697,8 @@ next:
 			return -EINVAL;
 		rcu_hz = rcu_hz_wanted;
 		rcu_hz_period_us = USEC_PER_SEC / rcu_hz;
+	} else if (!strncmp(token, "precise=", 8)) {
+		sscanf(&token[8], "%d", &rcu_hz_precise);
 	} else if (!strncmp(token, "wdog=", 5)) {
 		int wdog = -1;
 		sscanf(&token[5], "%d", &wdog);
