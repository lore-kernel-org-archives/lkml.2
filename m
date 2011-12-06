Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab1LFJuN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:50:13 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933026Ab1LFJuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:50:11 -0500
Date: Tue, 6 Dec 2011 01:49:38 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-77e81365e0b7d7479fc444a21cea0cd4def70b45@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com>
References: <1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Clean up domain traversal in select_idle_sibling()
Git-Commit-ID: 77e81365e0b7d7479fc444a21cea0cd4def70b45
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:49:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77e81365e0b7d7479fc444a21cea0cd4def70b45
Gitweb:     http://git.kernel.org/tip/77e81365e0b7d7479fc444a21cea0cd4def70b45
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Thu, 17 Nov 2011 11:08:23 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:51:25 +0100

sched: Clean up domain traversal in select_idle_sibling()

Instead of going through the scheduler domain hierarchy multiple times
(for giving priority to an idle core over an idle SMT sibling in a busy
core), start with the highest scheduler domain with the SD_SHARE_PKG_RESOURCES
flag and traverse the domain hierarchy down till we find an idle group.

This cleanup also addresses an issue reported by Mike where the recent
changes returned the busy thread even in the presence of an idle SMT
sibling in single socket platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Tested-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1321556904.15339.25.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c  |   38 +++++++++++++++++++++++++-------------
 kernel/sched/sched.h |    2 ++
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 7c62e2b..96a9ece 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2644,6 +2644,28 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
 	return idlest;
 }
 
+/**
+ * highest_flag_domain - Return highest sched_domain containing flag.
+ * @cpu:	The cpu whose highest level of sched domain is to
+ *		be returned.
+ * @flag:	The flag to check for the highest sched_domain
+ *		for the given cpu.
+ *
+ * Returns the highest sched_domain of a cpu which contains the given flag.
+ */
+static inline struct sched_domain *highest_flag_domain(int cpu, int flag)
+{
+	struct sched_domain *sd, *hsd = NULL;
+
+	for_each_domain(cpu, sd) {
+		if (!(sd->flags & flag))
+			break;
+		hsd = sd;
+	}
+
+	return hsd;
+}
+
 /*
  * Try and locate an idle CPU in the sched_domain.
  */
@@ -2653,7 +2675,7 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	int prev_cpu = task_cpu(p);
 	struct sched_domain *sd;
 	struct sched_group *sg;
-	int i, smt = 0;
+	int i;
 
 	/*
 	 * If the task is going to be woken-up on this cpu and if it is
@@ -2673,19 +2695,9 @@ static int select_idle_sibling(struct task_struct *p, int target)
 	 * Otherwise, iterate the domains and find an elegible idle cpu.
 	 */
 	rcu_read_lock();
-again:
-	for_each_domain(target, sd) {
-		if (!smt && (sd->flags & SD_SHARE_CPUPOWER))
-			continue;
-
-		if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
-			if (!smt) {
-				smt = 1;
-				goto again;
-			}
-			break;
-		}
 
+	sd = highest_flag_domain(target, SD_SHARE_PKG_RESOURCES);
+	for_each_lower_domain(sd) {
 		sg = sd->groups;
 		do {
 			if (!cpumask_intersects(sched_group_cpus(sg),
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c2e7802..8715055 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -501,6 +501,8 @@ DECLARE_PER_CPU(struct rq, runqueues);
 #define for_each_domain(cpu, __sd) \
 	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
+#define for_each_lower_domain(sd) for (; sd; sd = sd->child)
+
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
 #define task_rq(p)		cpu_rq(task_cpu(p))
