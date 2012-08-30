Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2H3Vpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 17:45:43 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:53119 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2H3Vnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 17:43:46 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, patches@linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/15] rcu: Avoid rcu_print_detail_task_stall_rnp() segfault
Date: Thu, 30 Aug 2012 11:56:22 -0700
Message-Id: <1346352988-32444-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.8
In-Reply-To: <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20120830185607.GA32148@linux.vnet.ibm.com>
 <1346352988-32444-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12083021-7282-0000-0000-00000C76A007
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_print_detail_task_stall_rnp() function invokes
rcu_preempt_blocked_readers_cgp() to verify that there are some preempted
RCU readers blocking the current grace period outside of the protection
of the rcu_node structure's ->lock.  This means that the last blocked
reader might exit its RCU read-side critical section and remove itself
from the ->blkd_tasks list before the ->lock is acquired, resulting in
a segmentation fault when the subsequent code attempts to dereference
the now-NULL gp_tasks pointer.

This commit therefore moves the test under the lock.  This will not
have measurable effect on lock contention because this code is invoked
only when printing RCU CPU stall warnings, in other words, in the common
case, never.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree_plugin.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 139a803..c02dc1d 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -422,9 +422,11 @@ static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
 	unsigned long flags;
 	struct task_struct *t;
 
-	if (!rcu_preempt_blocked_readers_cgp(rnp))
-		return;
 	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (!rcu_preempt_blocked_readers_cgp(rnp)) {
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
 	t = list_entry(rnp->gp_tasks,
 		       struct task_struct, rcu_node_entry);
 	list_for_each_entry_continue(t, &rnp->blkd_tasks, rcu_node_entry)
-- 
1.7.8

