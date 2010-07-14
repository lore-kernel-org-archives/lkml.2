Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab0GNUON (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:14:13 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42174 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756815Ab0GNUKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:10:17 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 25/30] rcutorture: add random preemption
Date: Wed, 14 Jul 2010 13:09:59 -0700
Message-Id: <1279138204-12849-25-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.0.6
In-Reply-To: <20100714200945.GA10535@linux.vnet.ibm.com>
References: <20100714200945.GA10535@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Add random preemption to help we to torture the preemptable rcu.

srcu_read_delay() also calls rcu_read_delay() for shorter delays.

Added comment to preempt_schedule() call indicating that no quiescent
states happen if preemption is disabled.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutorture.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 6535ac8..430cb7f 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -304,6 +304,10 @@ static void rcu_read_delay(struct rcu_random_state *rrsp)
 		mdelay(longdelay_ms);
 	if (!(rcu_random(rrsp) % (nrealreaders * 2 * shortdelay_us)))
 		udelay(shortdelay_us);
+#ifdef CONFIG_PREEMPT
+	if (!preempt_count() && !(rcu_random(rrsp) % (nrealreaders * 20000)))
+		preempt_schedule();  /* No QS if preempt_disable() in effect */
+#endif
 }
 
 static void rcu_torture_read_unlock(int idx) __releases(RCU)
@@ -537,6 +541,8 @@ static void srcu_read_delay(struct rcu_random_state *rrsp)
 	delay = rcu_random(rrsp) % (nrealreaders * 2 * longdelay * uspertick);
 	if (!delay)
 		schedule_timeout_interruptible(longdelay);
+	else
+		rcu_read_delay(rrsp);
 }
 
 static void srcu_torture_read_unlock(int idx) __releases(&srcu_ctl)
-- 
1.7.0.6

