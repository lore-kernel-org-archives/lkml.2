Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2LTSkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:40:05 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54474 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2LTSjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:39:42 -0500
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Dec 2012 13:39:42 EST
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 15/24] sched: Update rq clock earlier in unthrottle_cfs_rq
Date: Thu, 20 Dec 2012 19:33:02 +0100
Message-Id: <1356028391-14427-16-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
References: <1356028391-14427-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In this function we are making use of rq->clock right before the
update of the rq clock, let's just call update_rq_clock() just
before that to avoid using a stale rq clock value.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alessio Igor Bogani <abogani@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avi Kivity <avi@redhat.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Geoff Levand <geoff@infradead.org>
Cc: Gilad Ben Yossef <gilad@benyossef.com>
Cc: Hakan Akkan <hakanakkan@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a6ddc1e..b31f7ca 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2051,14 +2051,15 @@ void unthrottle_cfs_rq(struct cfs_rq *cfs_rq)
 	long task_delta;
 
 	se = cfs_rq->tg->se[cpu_of(rq_of(cfs_rq))];
-
 	cfs_rq->throttled = 0;
+
+	update_rq_clock(rq);
+
 	raw_spin_lock(&cfs_b->lock);
 	cfs_b->throttled_time += rq->clock - cfs_rq->throttled_clock;
 	list_del_rcu(&cfs_rq->throttled_list);
 	raw_spin_unlock(&cfs_b->lock);
 
-	update_rq_clock(rq);
 	/* update hierarchical throttle state */
 	walk_tg_tree_from(cfs_rq->tg, tg_nop, tg_unthrottle_up, (void *)rq);
 
-- 
1.7.5.4

