Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1KVO3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 09:29:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756233Ab1KVO3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 09:29:15 -0500
Subject: [patch 3/7] sched: set skip_clock_update in yield_task_fair()
From: Mike Galbraith <mgalbraith@suse.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321971445.6855.14.camel@marge.simson.net>
References: <1321350377.1421.55.camel@twins>
	 <1321406062.16760.60.camel@sbsiddha-desk.sc.intel.com>
	 <1321435455.5072.64.camel@marge.simson.net>
	 <1321468646.11680.2.camel@sbsiddha-desk.sc.intel.com>
	 <1321495153.5100.7.camel@marge.simson.net>
	 <1321544313.6308.25.camel@marge.simson.net>
	 <1321545376.2495.1.camel@laptop>
	 <1321547917.6308.48.camel@marge.simson.net>
	 <1321551381.15339.21.camel@sbsiddha-desk.sc.intel.com>
	 <1321629267.7080.13.camel@marge.simson.net>
	 <1321629441.7080.15.camel@marge.simson.net>
	 <1321630552.2197.15.camel@twins>
	 <1321971445.6855.14.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Nov 2011 15:21:26 +0100
Message-ID: <1321971686.6855.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is another case where we are on our way to schedule(),
so can save a useless clock update and resulting microscopic
vruntime update.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched/core.c |    8 +++++++-
 kernel/sched/fair.c |    6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-3.0-tip/kernel/sched/core.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/core.c
+++ linux-3.0-tip/kernel/sched/core.c
@@ -4547,7 +4547,13 @@ again:
 		 */
 		if (preempt && rq != p_rq)
 			resched_task(p_rq->curr);
-	}
+	} else
+		/*
+		 * We might have set it in task_yield_fair(), but are
+		 * not going to schedule(), so don't want to skip
+		 * the next update.
+		 */
+		rq->skip_clock_update = 0;
 
 out:
 	double_rq_unlock(rq, p_rq);
Index: linux-3.0-tip/kernel/sched/fair.c
===================================================================
--- linux-3.0-tip.orig/kernel/sched/fair.c
+++ linux-3.0-tip/kernel/sched/fair.c
@@ -3062,6 +3062,12 @@ static void yield_task_fair(struct rq *r
 		 * Update run-time statistics of the 'current'.
 		 */
 		update_curr(cfs_rq);
+		/*
+		 * Tell update_rq_clock() that we've just updated,
+		 * so we don't do microscopic update in schedule()
+		 * and double the fastpath cost.
+		 */
+		 rq->skip_clock_update = 1;
 	}
 
 	set_skip_buddy(se);


