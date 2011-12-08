Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1LHPR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:17:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260Ab1LHPRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:17:24 -0500
Date: Thu, 8 Dec 2011 07:16:48 -0800
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-067491b7313c41f49607fce782d29344d1472587@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, peterz@infradead.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, peterz@infradead.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, yong.zhang0@gmail.com,
        mingo@elte.hu
In-Reply-To: <1323264728.32012.107.camel@twins>
References: <1323264728.32012.107.camel@twins>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Fix missing RCU read lock
Git-Commit-ID: 067491b7313c41f49607fce782d29344d1472587
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 08 Dec 2011 07:16:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  067491b7313c41f49607fce782d29344d1472587
Gitweb:     http://git.kernel.org/tip/067491b7313c41f49607fce782d29344d1472587
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 7 Dec 2011 14:32:08 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 8 Dec 2011 05:45:48 +0100

sched, nohz: Fix missing RCU read lock

Yong Zhang reported:

 > [ INFO: suspicious RCU usage. ]
 > kernel/sched/fair.c:5091 suspicious rcu_dereference_check() usage!

This is due to the sched_domain stuff being RCU protected and
commit 0b005cf5 ("sched, nohz: Implement sched group, domain
aware nohz idle load balancing") overlooking this fact.

The sd variable only lives inside the for_each_domain() block,
so we only need to wrap that.

Reported-by: Yong Zhang <yong.zhang0@gmail.com>
Tested-by: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1323264728.32012.107.camel@twins
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6482136..a4d2b7a 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5088,23 +5088,28 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
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
