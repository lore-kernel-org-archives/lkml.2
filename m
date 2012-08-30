Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2H3Vo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:44:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40586 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672Ab2H3Vnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:47 -0400
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
Subject: [PATCH tip/core/rcu 05/15] rcu: Improve boost selection when moving tasks to root rcu_node
Date: Thu, 30 Aug 2012 11:56:18 -0700
Message-Id: <1346352988-32444-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-4242-0000-0000-000002BA0738
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paul.mckenney@linaro.org>

The rcu_preempt_offline_tasks() moves all tasks queued on a given leaf
rcu_node structure to the root rcu_node, which is done when the last CPU
corresponding the the leaf rcu_node structure goes offline.  Now that
RCU-preempt's synchronize_rcu_expedited() implementation blocks CPU-hotplug
operations during the initialization of each rcu_node structure's
->boost_tasks pointer, rcu_preempt_offline_tasks() can do a better job
of setting the root rcu_node's ->boost_tasks pointer.

The key point is that rcu_preempt_offline_tasks() runs as part of the
CPU-hotplug process, so that a concurrent synchronize_rcu_expedited() is
guaranteed to either have not started on the one hand (in which case there
is no boosting on behalf of the expedited grace period) to be completely
initialized on the other (in which case, in absence of other priority
boosting, all ->boost_tasks pointers will be initialized).  Therefore,
if rcu_preempt_offline_tasks() finds that the ->boost_tasks pointer is
equal to the ->exp_tasks pointer, it can be sure that it is correcty
placed.

The case where there was boosting ongoing at the time that the
synchronize_rcu_expedited() function started, different nodes might
start boosting the tasks blocking the expedited grace period at different
times.  In this mixed case, the root node will either be boosting tasks
for the expedited grace period already, or it will start as soon as it
gets done boosting for the normal grace period -- but in this latter
case, the root node's tasks needed to be boosted in any case.

This commit therefore adds a check of the ->boost_tasks pointer against
the ->exp_tasks pointer to the list that prevents updating ->boost_tasks.

Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index b1b4851..c930a47 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -591,7 +591,8 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 	/* In case root is being boosted and leaf was not. */
 	raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
 	if (rnp_root->boost_tasks != NULL &&
-	    rnp_root->boost_tasks != rnp_root->gp_tasks)
+	    rnp_root->boost_tasks != rnp_root->gp_tasks &&
+	    rnp_root->boost_tasks != rnp_root->exp_tasks)
 		rnp_root->boost_tasks = rnp_root->gp_tasks;
 	raw_spin_unlock(&rnp_root->lock); /* irqs still disabled */
 #endif /* #ifdef CONFIG_RCU_BOOST */
-- 
1.7.8

