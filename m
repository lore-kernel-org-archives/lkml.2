Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965107Ab2J3Rev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 13:34:51 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60437 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965076Ab2J3Rc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 13:32:27 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 08/14] rcu: Fix tracing formatting
Date: Tue, 30 Oct 2012 10:05:07 -0700
Message-Id: <1351616713-26930-8-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20121030170454.GA25712@linux.vnet.ibm.com>
 <1351616713-26930-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12103017-5518-0000-0000-000008D73850
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_state structure's ->completed field is unsigned long, so this
commit adjusts show_one_rcugp()'s printf() format to suit.  Also add
the required ACCESS_ONCE() directives while we are in this function.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c       |    4 ++--
 kernel/rcutree_trace.c |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index b966d56..8ed9c48 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -68,8 +68,8 @@ static struct lock_class_key rcu_fqs_class[RCU_NUM_LVLS];
 	.level = { &sname##_state.node[0] }, \
 	.call = cr, \
 	.fqs_state = RCU_GP_IDLE, \
-	.gpnum = -300, \
-	.completed = -300, \
+	.gpnum = 0UL - 300UL, \
+	.completed = 0UL - 300UL, \
 	.orphan_lock = __RAW_SPIN_LOCK_UNLOCKED(&sname##_state.orphan_lock), \
 	.orphan_nxttail = &sname##_state.orphan_nxtlist, \
 	.orphan_donetail = &sname##_state.orphan_donelist, \
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index bcc4865..209e696 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -301,15 +301,15 @@ static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
 	struct rcu_node *rnp = &rsp->node[0];
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
-	completed = rsp->completed;
-	gpnum = rsp->gpnum;
-	if (rsp->completed == rsp->gpnum)
+	completed = ACCESS_ONCE(rsp->completed);
+	gpnum = ACCESS_ONCE(rsp->gpnum);
+	if (completed == gpnum)
 		gpage = 0;
 	else
 		gpage = jiffies - rsp->gp_start;
 	gpmax = rsp->gp_max;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
-	seq_printf(m, "%s: completed=%ld  gpnum=%lu  age=%ld  max=%ld\n",
+	seq_printf(m, "%s: completed=%lu  gpnum=%lu  age=%ld  max=%ld\n",
 		   rsp->name, completed, gpnum, gpage, gpmax);
 }
 
-- 
1.7.8

