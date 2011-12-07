Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab1LGNcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:32:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34070 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab1LGNcq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:32:46 -0500
Message-ID: <1323264728.32012.107.camel@twins>
Subject: Re: [BUG -tip/sched] INFO: suspicious RCU usage
From: Peter Zijlstra <peterz@infradead.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Suresh Siddha <suresh.b.siddha@intel.com>
Date: Wed, 07 Dec 2011 14:32:08 +0100
In-Reply-To: <1323264485.32012.106.camel@twins>
References: <20111207073942.GA12029@zhy> <1323264485.32012.106.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I made that

---
Subject: sched, nohz: Fix missing RCU read lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Wed Dec 07 14:28:44 CET 2011

Yong Zhang reported:

> [ INFO: suspicious RCU usage. ]
> kernel/sched/fair.c:5091 suspicious rcu_dereference_check() usage!

This is due to the sched_domain stuff being RCU protected and commit
0b005cf5 ("sched, nohz: Implement sched group, domain
aware nohz idle load balancing") overlooking this fact.

The sd variable only lives inside the for_each_domain() block, so we
only need to wrap that.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Reported-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-gt616u9aetdzgb1oc4m6uydr@git.kernel.org
---
Index: linux-2.6/kernel/sched/fair.c
===================================================================
--- linux-2.6.orig/kernel/sched/fair.c
+++ linux-2.6/kernel/sched/fair.c
@@ -5088,23 +5088,28 @@ static inline int nohz_kick_needed(struc
 	if (rq->nr_running >= 2)
 		goto need_kick;
 
+	rcu_read_lock();
 	for_each_domain(cpu, sd) {
 		struct sched_group *sg = sd->groups;
 		struct sched_group_power *sgp = sg->sgp;
 		int nr_busy = atomic_read(&sgp->nr_busy_cpus);
 
 		if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
-			goto need_kick;
+			goto need_kick_unlock;
 
 		if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
 		    && (cpumask_first_and(nohz.idle_cpus_mask,
 					  sched_domain_span(sd)) < cpu))
-			goto need_kick;
+			goto need_kick_unlock;
 
 		if (!(sd->flags & (SD_SHARE_PKG_RESOURCES | SD_ASYM_PACKING)))
 			break;
 	}
+	rcu_read_unlock();
 	return 0;
+
+need_kick_unlock:
+	rcu_read_unlock();
 need_kick:
 	return 1;
 }

