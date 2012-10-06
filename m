Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab2JFHjz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:39:55 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:55342 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab2JFHjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:39:53 -0400
Date: Sat, 6 Oct 2012 09:39:47 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Ben Segall <bsegall@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: sched: per-entity load-tracking
Message-ID: <20121006073947.GA26538@gmail.com>
References: <CAPM31R+mT+g0qTGOVgC1QYJk3Ju-u06UpkBwx-4tHxeh89kD3w@mail.gmail.com>
 <CAPM31RLKEZ0xzPXYQc-pMGUesfkviQ5i0LZaJipWC8oY=J5-kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPM31RLKEZ0xzPXYQc-pMGUesfkviQ5i0LZaJipWC8oY=J5-kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Turner <pjt@google.com> wrote:

> Peter:
> The rebase to tip/master made interdiff angry enough that it wasn't
> producing the right relative diffs for your stack.  Sorry :(

Find below the diff between the two series, using 'quilt 
snapshot' and 'quilt diff --snapshot'.

One quick stylistic note: instead of putting the 
update_cfs_rq_blocked_load() in the middle of the file, order 
functions naturally so that no prototypes are needed.

Thanks,

	Ingo
--
 tip/kernel/sched/fair.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

Index: tip/kernel/sched/fair.c
===================================================================
--- tip.orig/kernel/sched/fair.c
+++ tip/kernel/sched/fair.c
@@ -262,6 +262,9 @@ static inline struct cfs_rq *group_cfs_r
 	return grp->my_q;
 }
 
+static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq,
+				       int force_update);
+
 static inline void list_add_leaf_cfs_rq(struct cfs_rq *cfs_rq)
 {
 	if (!cfs_rq->on_list) {
@@ -281,6 +284,8 @@ static inline void list_add_leaf_cfs_rq(
 		}
 
 		cfs_rq->on_list = 1;
+		/* We should have no load, but we need to update last_decay. */
+		update_cfs_rq_blocked_load(cfs_rq, 0);
 	}
 }
 
@@ -1151,7 +1156,7 @@ static inline void update_cfs_shares(str
  * Note: The tables below are dependent on this value.
  */
 #define LOAD_AVG_PERIOD 32
-#define LOAD_AVG_MAX 47765 /* maximum possible load avg */
+#define LOAD_AVG_MAX 47742 /* maximum possible load avg */
 #define LOAD_AVG_MAX_N 345 /* number of full periods to produce LOAD_MAX_AVG */
 
 /* Precomputed fixed inverse multiplies for multiplication by y^n */
@@ -1203,7 +1208,8 @@ static __always_inline u64 decay_load(u6
 	}
 
 	val *= runnable_avg_yN_inv[local_n];
-	return SRR(val, 32);
+	/* We don't use SRR here since we always want to round down. */
+	return val >> 32;
 }
 
 /*
@@ -4236,13 +4242,15 @@ static void __update_blocked_averages_cp
 	if (se) {
 		update_entity_load_avg(se, 1);
 		/*
-		 * We can pivot on the runnable average decaying to zero for
-		 * list removal since the parent average will always be >=
-		 * child.
+		 * We pivot on our runnable average having decayed to zero for
+		 * list removal.  This generally implies that all our children
+		 * have also been removed (modulo rounding error or bandwidth
+		 * control); however, such cases are rare and we can fix these
+		 * at enqueue.
+		 *
+		 * TODO: fix up out-of-order children on enqueue.
 		 */
-		if (se->avg.runnable_avg_sum)
-			update_cfs_shares(cfs_rq);
-		else
+		if (!se->avg.runnable_avg_sum && !cfs_rq->nr_running)
 			list_del_leaf_cfs_rq(cfs_rq);
 	} else {
 		struct rq *rq = rq_of(cfs_rq);
@@ -6013,10 +6021,10 @@ static void task_tick_fair(struct rq *rq
 		entity_tick(cfs_rq, se, queued);
 	}
 
-	update_rq_runnable_avg(rq, 1);
-
 	if (sched_feat_numa(NUMA))
 		task_tick_numa(rq, curr);
+
+	update_rq_runnable_avg(rq, 1);
 }
 
 /*
