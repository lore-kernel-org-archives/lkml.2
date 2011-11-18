Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab1KRPXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 10:23:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:48549 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757856Ab1KRPXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 10:23:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX195WDodD4956P88GGZjcCTagpu5tShB7h+ZXtGKi6
	7jbpLn1piQo3w5
Subject: [patch 6/6] sched: set skip_clock_update in yield_task_fair()
From: Mike Galbraith <efault@gmx.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Paul Turner <pjt@google.com>
In-Reply-To: <1321629267.7080.13.camel@marge.simson.net>
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
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 16:23:26 +0100
Message-ID: <1321629806.7080.23.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is another case where we are on our way to schedule(),
so can save a useless clock update and resulting microscopic
vruntime update.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched.c      |    8 +++++++-
 kernel/sched_fair.c |    6 ++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

Index: linux-3.2.git/kernel/sched.c
===================================================================
--- linux-3.2.git.orig/kernel/sched.c
+++ linux-3.2.git/kernel/sched.c
@@ -5838,7 +5838,13 @@ again:
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
Index: linux-3.2.git/kernel/sched_fair.c
===================================================================
--- linux-3.2.git.orig/kernel/sched_fair.c
+++ linux-3.2.git/kernel/sched_fair.c
@@ -2688,6 +2688,12 @@ static void yield_task_fair(struct rq *r
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


