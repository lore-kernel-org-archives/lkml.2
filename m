Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933324Ab1CXRv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:51:58 -0400
Received: from flusers.ccur.com ([173.221.59.2]:33546 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756004Ab1CXRs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:48:57 -0400
Date: Thu, 24 Mar 2011 13:48:02 -0400
From: Joe Korty <joe.korty@ccur.com>
To: paulmck@linux.vnet.ibm.com
Cc: fweisbec@gmail.com, peterz@infradead.org, laijs@cn.fujitsu.com,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org, houston.jim@comcast.net, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 13/24] jrcu: tuneable watchdog
Message-ID: <20110324174802.GA18893@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jrcu: Make the watchdog value a tuneable.

Also increase the default to 30 seconds.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: b/kernel/jrcu.c
===================================================================
--- a/kernel/jrcu.c
+++ b/kernel/jrcu.c
@@ -139,6 +139,8 @@ int rcu_scheduler_active __read_mostly;
 int rcu_nmi_seen __read_mostly;
 static u64 rcu_timestamp;
 
+int rcu_wdog = 30;		/* rcu watchdog interval, in seconds */
+
 /*
  * Return our CPU id or zero if we are too early in the boot process to
  * know what that is.  For RCU to work correctly, a cpu named '0' must
@@ -327,7 +329,7 @@ static void __rcu_delimit_batches(struct
 	 */
 	rcu_now = sched_clock();
 	if (!eob && !rcu_timestamp
-	&& ((rcu_now - rcu_timestamp) > 3LL * NSEC_PER_SEC)) {
+	&& ((rcu_now - rcu_timestamp) > (s64)rcu_wdog * NSEC_PER_SEC)) {
 		rcu_stats.nforced++;
 		WARN_ON_ONCE(1);
 		eob = 1;
@@ -576,6 +578,7 @@ static int rcu_debugfs_show(struct seq_f
 	raw_local_irq_enable();
 
 	seq_printf(m, "%14u: hz\n", rcu_hz);
+	seq_printf(m, "%14u: watchdog (secs)\n", rcu_wdog);
 #ifdef CONFIG_JRCU_DAEMON
 	if (rcu_daemon)
 		seq_printf(m, "%14u: daemon priority\n", rcu_priority);
@@ -671,6 +674,12 @@ static ssize_t rcu_debugfs_write(struct 
 			return -EINVAL;
 		rcu_hz = rcu_hz_wanted;
 		rcu_hz_period_us = USEC_PER_SEC / rcu_hz;
+	} else if (!strncmp(token, "wdog=", 5)) {
+		int wdog = -1;
+		sscanf(&token[5], "%d", &wdog);
+		if (wdog < 3 || wdog > 1000)
+			return -EINVAL;
+		rcu_wdog = wdog;
 	} else
 		return -EINVAL;
 
