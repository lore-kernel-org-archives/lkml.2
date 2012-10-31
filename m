Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934936Ab2JaDqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 23:46:43 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53942 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab2JaDql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 23:46:41 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        joe.korty@ccur.com, "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 2/2] rcu: Separate accounting of callbacks from callback-free CPUs
Date: Tue, 30 Oct 2012 20:46:31 -0700
Message-Id: <1351655191-2648-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351655191-2648-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121031034552.GA1999@linux.vnet.ibm.com>
 <1351655191-2648-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103103-7606-0000-0000-000004F21D2B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

Currently, callback invocations from callback-free CPUs are accounted to
the CPU that registered the callback, but using the same field that is
used for normal callbacks.  This makes it impossible to determine from
debugfs output whether callbacks are in fact being diverted.  This commit
therefore adds a separate ->n_nocbs_invoked field in the rcu_data structure
in which diverted callback invocations are counted.  RCU's debugfs tracing
still displays normal callback invocations using ci=, but displayed
diverted callbacks with nci=.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.h        |    1 +
 kernel/rcutree_plugin.h |    2 +-
 kernel/rcutree_trace.c  |    5 +++--
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 79954bb..db9bec8 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -287,6 +287,7 @@ struct rcu_data {
 	long		qlen_last_fqs_check;
 					/* qlen at last check for QS forcing */
 	unsigned long	n_cbs_invoked;	/* count of RCU cbs invoked. */
+	unsigned long	n_nocbs_invoked; /* count of no-CBs RCU cbs invoked. */
 	unsigned long   n_cbs_orphaned; /* RCU cbs orphaned by dying CPU */
 	unsigned long   n_cbs_adopted;  /* RCU cbs adopted from dying CPU */
 	unsigned long	n_force_qs_snap;
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index ea960c4..31d3a95 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -2406,7 +2406,7 @@ static int rcu_nocb_kthread(void *arg)
 		trace_rcu_batch_end(rdp->rsp->name, c, !!list, 0, 0, 1);
 		ACCESS_ONCE(rdp->nocb_p_count) -= c;
 		ACCESS_ONCE(rdp->nocb_p_count_lazy) -= cl;
-		rdp->n_cbs_invoked += c;
+		rdp->n_nocbs_invoked += c;
 	}
 	return 0;
 }
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 5e9ca3e..167375d 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -146,8 +146,9 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 		   per_cpu(rcu_cpu_kthread_loops, rdp->cpu) & 0xffff);
 #endif /* #ifdef CONFIG_RCU_BOOST */
 	seq_printf(m, " b=%ld", rdp->blimit);
-	seq_printf(m, " ci=%lu co=%lu ca=%lu\n",
-		   rdp->n_cbs_invoked, rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
+	seq_printf(m, " ci=%lu nci=%lu co=%lu ca=%lu\n",
+		   rdp->n_cbs_invoked, rdp->n_nocbs_invoked,
+		   rdp->n_cbs_orphaned, rdp->n_cbs_adopted);
 }
 
 static int show_rcudata(struct seq_file *m, void *v)
-- 
1.7.8

