Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2DWQn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:43:26 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40202 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2DWQnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:43:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 1/6] rcu: Stabilize use of num_online_cpus() for GP short circuit
Date: Mon, 23 Apr 2012 09:42:22 -0700
Message-Id: <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <20120423164159.GA13819@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042316-1780-0000-0000-000004FB12C8
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000271; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00133427; UDB=6.00031285; UTC=2012-04-23
 16:43:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The rcu_blocking_is_gp() function tests to see if there is only one
online CPU, and if so, synchronize_sched() and friends become no-ops.
However, for larger systems, num_online_cpus() scans a large vector,
and might be preempted while doing so.  While preempted, any number
of CPUs might come online and go offline, potentially resulting in
num_online_cpus() returning 1 when there never had only been one
CPU online.  This would result in a too-short RCU grace period, which
could in turn result in total failure.

This commit therefore protects the num_online_cpus() with preempt_disable().

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcutree.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index e8ee5dd..997179f 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -101,8 +101,13 @@ extern void rcu_sched_force_quiescent_state(void);
 /* A context switch is a grace period for RCU-sched and RCU-bh. */
 static inline int rcu_blocking_is_gp(void)
 {
+	int ret;
+
 	might_sleep();  /* Check for RCU read-side critical section. */
-	return num_online_cpus() == 1;
+	preempt_disable();  /* Prevent CPU hotplug from confusing us. */
+	ret = num_online_cpus() == 1;
+	preempt_enable();
+	return ret;
 }
 
 extern void rcu_scheduler_starting(void);
-- 
1.7.8

