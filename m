Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096Ab1LFJ5p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:57:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933018Ab1LFJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:57:43 -0500
Date: Tue, 6 Dec 2011 01:57:17 -0800
From: tip-bot for Glauber Costa <glommer@parallels.com>
Message-ID: <tip-44252e421ad81e711c5a9db158fad7f433f70665@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, lizf@cn.fujitsu.com, glommer@parallels.com,
        pjt@google.com, tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        glommer@parallels.com, lizf@cn.fujitsu.com, a.p.zijlstra@chello.nl,
        pjt@google.com, tglx@linutronix.de, kamezawa.hiroyu@jp.fujitsu.com,
        mingo@elte.hu
In-Reply-To: <1322498719-2255-3-git-send-email-glommer@parallels.com>
References: <1322498719-2255-3-git-send-email-glommer@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/accounting, cgroups: Reuse cgroup's parent pointer
Git-Commit-ID: 44252e421ad81e711c5a9db158fad7f433f70665
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:57:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  44252e421ad81e711c5a9db158fad7f433f70665
Gitweb:     http://git.kernel.org/tip/44252e421ad81e711c5a9db158fad7f433f70665
Author:     Glauber Costa <glommer@parallels.com>
AuthorDate: Mon, 28 Nov 2011 14:45:18 -0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:40 +0100

sched/accounting, cgroups: Reuse cgroup's parent pointer

We already have a pointer to the cgroup parent (whose data is more likely
to be in the cache than this, anyway), so there is no need to have this one
in cpuacct.

This patch makes the underlying cgroup be used instead.

Signed-off-by: Glauber Costa <glommer@parallels.com>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Tuner <pjt@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1322498719-2255-3-git-send-email-glommer@parallels.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dbbe35f..a727c4e 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7849,7 +7849,6 @@ struct cpuacct {
 	/* cpuusage holds pointer to a u64-type object on every cpu */
 	u64 __percpu *cpuusage;
 	struct percpu_counter cpustat[CPUACCT_STAT_NSTATS];
-	struct cpuacct *parent;
 };
 
 struct cgroup_subsys cpuacct_subsys;
@@ -7868,6 +7867,13 @@ static inline struct cpuacct *task_ca(struct task_struct *tsk)
 			    struct cpuacct, css);
 }
 
+static inline struct cpuacct *parent_ca(struct cpuacct *ca)
+{
+	if (!ca || !ca->css.cgroup->parent)
+		return NULL;
+	return cgroup_ca(ca->css.cgroup->parent);
+}
+
 /* create a new cpu accounting group */
 static struct cgroup_subsys_state *cpuacct_create(
 	struct cgroup_subsys *ss, struct cgroup *cgrp)
@@ -7886,9 +7892,6 @@ static struct cgroup_subsys_state *cpuacct_create(
 		if (percpu_counter_init(&ca->cpustat[i], 0))
 			goto out_free_counters;
 
-	if (cgrp->parent)
-		ca->parent = cgroup_ca(cgrp->parent);
-
 	return &ca->css;
 
 out_free_counters:
@@ -8055,7 +8058,7 @@ void cpuacct_charge(struct task_struct *tsk, u64 cputime)
 
 	ca = task_ca(tsk);
 
-	for (; ca; ca = ca->parent) {
+	for (; ca; ca = parent_ca(ca)) {
 		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 		*cpuusage += cputime;
 	}
@@ -8097,7 +8100,7 @@ void cpuacct_update_stats(struct task_struct *tsk,
 
 	do {
 		__percpu_counter_add(&ca->cpustat[idx], val, batch);
-		ca = ca->parent;
+		ca = parent_ca(ca);
 	} while (ca);
 	rcu_read_unlock();
 }
