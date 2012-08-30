Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2H3VrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:47:03 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54727 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab2H3Vnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:40 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/15] rcu: Apply for_each_rcu_flavor() to increment_cpu_stall_ticks()
Date: Thu, 30 Aug 2012 11:56:21 -0700
Message-Id: <1346352988-32444-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-9360-0000-0000-00000A06A247
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The increment_cpu_stall_ticks() function listed each RCU flavor
explicitly, with an ifdef to handle preemptible RCU.  This commit
therefore applies for_each_rcu_flavor() to save a line of code.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 3ea60c9..139a803 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2196,11 +2196,10 @@ static void zero_cpu_stall_ticks(struct rcu_data *rdp)
 /* Increment ->ticks_this_gp for all flavors of RCU. */
 static void increment_cpu_stall_ticks(void)
 {
-	__get_cpu_var(rcu_sched_data).ticks_this_gp++;
-	__get_cpu_var(rcu_bh_data).ticks_this_gp++;
-#ifdef CONFIG_TREE_PREEMPT_RCU
-	__get_cpu_var(rcu_preempt_data).ticks_this_gp++;
-#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	struct rcu_state *rsp;
+
+	for_each_rcu_flavor(rsp)
+		__this_cpu_ptr(rsp->rda)->ticks_this_gp++;
 }
 
 #else /* #ifdef CONFIG_RCU_CPU_STALL_INFO */
-- 
1.7.8

