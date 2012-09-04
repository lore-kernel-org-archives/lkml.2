Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab2IDOWH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:22:07 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6675 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757157Ab2IDOWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:22:01 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, davej@redhat.com,
        ben@decadent.org.uk, a.p.zijlstra@chello.nl, pjt@google.com,
        lennart@poettering.net, kay.sievers@vrfy.org, tj@kernel.org,
        Glauber Costa <glommer@parallels.com>
Subject: [RFC 2/5] sched: adjust exec_clock to use it as cpu usage metric
Date: Tue,  4 Sep 2012 18:18:17 +0400
Message-Id: <1346768300-10282-3-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1346768300-10282-1-git-send-email-glommer@parallels.com>
References: <1346768300-10282-1-git-send-email-glommer@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

exec_clock already provides per-group cpu usage metrics, and can be
reused by cpuacct in case cpu and cpuacct are comounted.

However, it is only provided by tasks in fair class. Doing the same for
rt is easy, and can be done in an already existing hierarchy loop. This
is an improvement over the independent hierarchy walk executed by
cpuacct.

Signed-off-by: Glauber Costa <glommer@parallels.com>
CC: Dave Jones <davej@redhat.com>
CC: Ben Hutchings <ben@decadent.org.uk>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Paul Turner <pjt@google.com>
CC: Lennart Poettering <lennart@poettering.net>
CC: Kay Sievers <kay.sievers@vrfy.org>
CC: Tejun Heo <tj@kernel.org>
---
 kernel/sched/rt.c    | 1 +
 kernel/sched/sched.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 573e1ca..40ef6af 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -930,6 +930,7 @@ static void update_curr_rt(struct rq *rq)
 
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
+		schedstat_add(rt_rq, exec_clock, delta_exec);
 
 		if (sched_rt_runtime(rt_rq) != RUNTIME_INF) {
 			raw_spin_lock(&rt_rq->rt_runtime_lock);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 55844f2..8da579d 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -204,6 +204,7 @@ struct cfs_rq {
 	unsigned int nr_running, h_nr_running;
 
 	u64 exec_clock;
+	u64 prev_exec_clock;
 	u64 min_vruntime;
 #ifndef CONFIG_64BIT
 	u64 min_vruntime_copy;
@@ -295,6 +296,8 @@ struct rt_rq {
 	struct plist_head pushable_tasks;
 #endif
 	int rt_throttled;
+	u64 exec_clock;
+	u64 prev_exec_clock;
 	u64 rt_time;
 	u64 rt_runtime;
 	/* Nests inside the rq lock: */
-- 
1.7.11.4

