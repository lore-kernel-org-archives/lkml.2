Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab0IUONn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 10:13:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:46444 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647Ab0IUONm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 10:13:42 -0400
Date: Tue, 21 Sep 2010 14:13:01 GMT
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
References: <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix nohz balance kick
Message-ID: <tip-f6c3f1686e7ec1dd8725a9a3dcb857dfd0c7a5bf@git.kernel.org>
Git-Commit-ID: f6c3f1686e7ec1dd8725a9a3dcb857dfd0c7a5bf
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Sep 2010 14:13:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f6c3f1686e7ec1dd8725a9a3dcb857dfd0c7a5bf
Gitweb:     http://git.kernel.org/tip/f6c3f1686e7ec1dd8725a9a3dcb857dfd0c7a5bf
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Mon, 13 Sep 2010 11:02:21 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Sep 2010 13:50:50 +0200

sched: Fix nohz balance kick

There's a situation where the nohz balancer will try to wake itself:

cpu-x is idle which is also ilb_cpu
got a scheduler tick during idle
and the nohz_kick_needed() in trigger_load_balance() checks for
rq_x->nr_running which might not be zero (because of someone waking a
task on this rq etc) and this leads to the situation of the cpu-x
sending a kick to itself.

And this can cause a lockup.

Avoid this by not marking ourself eligible for kicking.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1284400941.2684.19.camel@sbsiddha-MOBL3.sc.intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index a171138..db3f674 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -3630,7 +3630,7 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
 	if (time_before(now, nohz.next_balance))
 		return 0;
 
-	if (!rq->nr_running)
+	if (rq->idle_at_tick)
 		return 0;
 
 	first_pick_cpu = atomic_read(&nohz.first_pick_cpu);
