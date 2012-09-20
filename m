Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab2ITSxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:53:36 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:42860 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab2ITStE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:49:04 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 19/23] rcu: Eliminate signed overflow in synchronize_rcu_expedited()
Date: Thu, 20 Sep 2012 11:48:15 -0700
Message-Id: <1348166900-18716-19-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120920184751.GA18657@linux.vnet.ibm.com>
 <1348166900-18716-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092018-5518-0000-0000-000007CEF4A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

In the C language, signed overflow is undefined.  It is true that
twos-complement arithmetic normally comes to the rescue, but if the
compiler can subvert this any time it has any information about the values
being compared.  For example, given "if (a - b > 0)", if the compiler
has enough information to realize that (for example) the value of "a"
is positive and that of "b" is negative, the compiler is within its
rights to optimize to a simple "if (1)", which might not be what you want.

This commit therefore converts synchronize_rcu_expedited()'s work-done
detection counter from signed to unsigned.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree_plugin.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index eb8dcd1..cb58793 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -677,7 +677,7 @@ void synchronize_rcu(void)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
 static DECLARE_WAIT_QUEUE_HEAD(sync_rcu_preempt_exp_wq);
-static long sync_rcu_preempt_exp_count;
+static unsigned long sync_rcu_preempt_exp_count;
 static DEFINE_MUTEX(sync_rcu_preempt_exp_mutex);
 
 /*
@@ -792,7 +792,7 @@ void synchronize_rcu_expedited(void)
 	unsigned long flags;
 	struct rcu_node *rnp;
 	struct rcu_state *rsp = &rcu_preempt_state;
-	long snap;
+	unsigned long snap;
 	int trycount = 0;
 
 	smp_mb(); /* Caller's modifications seen first by other CPUs. */
@@ -811,10 +811,10 @@ void synchronize_rcu_expedited(void)
 			synchronize_rcu();
 			return;
 		}
-		if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+		if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count)))
 			goto mb_ret; /* Others did our work for us. */
 	}
-	if ((ACCESS_ONCE(sync_rcu_preempt_exp_count) - snap) > 0)
+	if (ULONG_CMP_LT(snap, ACCESS_ONCE(sync_rcu_preempt_exp_count)))
 		goto unlock_mb_ret; /* Others did our work for us. */
 
 	/* force all RCU readers onto ->blkd_tasks lists. */
-- 
1.7.8

