Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab1DKOoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 10:44:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:50450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab1DKOoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 10:44:05 -0400
Date: Mon, 11 Apr 2011 14:43:17 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-60495e7760d8ee364695006af37309b0755e0e17@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110407122942.969433965@chello.nl>
References: <20110407122942.969433965@chello.nl>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/domains] sched: Dynamic sched_domain::level
Git-Commit-ID: 60495e7760d8ee364695006af37309b0755e0e17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Apr 2011 14:43:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60495e7760d8ee364695006af37309b0755e0e17
Gitweb:     http://git.kernel.org/tip/60495e7760d8ee364695006af37309b0755e0e17
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 7 Apr 2011 14:10:04 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 Apr 2011 14:09:32 +0200

sched: Dynamic sched_domain::level

Remove the SD_LV_ enum and use dynamic level assignments.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/20110407122942.969433965@chello.nl
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |   23 +++--------------------
 kernel/cpuset.c       |    2 +-
 kernel/sched.c        |    9 ++++++---
 3 files changed, 10 insertions(+), 24 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 09d9e02..e43e5b0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -892,25 +892,6 @@ static inline struct cpumask *sched_group_cpus(struct sched_group *sg)
 	return to_cpumask(sg->cpumask);
 }
 
-enum sched_domain_level {
-	SD_LV_NONE = 0,
-#ifdef CONFIG_SCHED_SMT
-	SD_LV_SIBLING,
-#endif
-#ifdef CONFIG_SCHED_MC
-	SD_LV_MC,
-#endif
-#ifdef CONFIG_SCHED_BOOK
-	SD_LV_BOOK,
-#endif
-	SD_LV_CPU,
-#ifdef CONFIG_NUMA
-	SD_LV_NODE,
-	SD_LV_ALLNODES,
-#endif
-	SD_LV_MAX
-};
-
 struct sched_domain_attr {
 	int relax_domain_level;
 };
@@ -919,6 +900,8 @@ struct sched_domain_attr {
 	.relax_domain_level = -1,			\
 }
 
+extern int sched_domain_level_max;
+
 struct sched_domain {
 	/* These fields must be setup */
 	struct sched_domain *parent;	/* top domain must be null terminated */
@@ -936,7 +919,7 @@ struct sched_domain {
 	unsigned int forkexec_idx;
 	unsigned int smt_gain;
 	int flags;			/* See SD_* */
-	enum sched_domain_level level;
+	int level;
 
 	/* Runtime fields. */
 	unsigned long last_balance;	/* init to jiffies. units in jiffies */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 33eee16..2bb8c2e 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1159,7 +1159,7 @@ int current_cpuset_is_being_rebound(void)
 static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
 #ifdef CONFIG_SMP
-	if (val < -1 || val >= SD_LV_MAX)
+	if (val < -1 || val >= sched_domain_level_max)
 		return -EINVAL;
 #endif
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 3231e19..506cb81 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -6966,7 +6966,6 @@ sd_init_##type(struct sched_domain_topology_level *tl, int cpu) 	\
 {									\
 	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);	\
 	*sd = SD_##type##_INIT;						\
-	sd->level = SD_LV_##type;					\
 	SD_INIT_NAME(sd, type);						\
 	sd->private = &tl->data;					\
 	return sd;							\
@@ -6988,13 +6987,14 @@ SD_INIT_FUNC(CPU)
 #endif
 
 static int default_relax_domain_level = -1;
+int sched_domain_level_max;
 
 static int __init setup_relax_domain_level(char *str)
 {
 	unsigned long val;
 
 	val = simple_strtoul(str, NULL, 0);
-	if (val < SD_LV_MAX)
+	if (val < sched_domain_level_max)
 		default_relax_domain_level = val;
 
 	return 1;
@@ -7173,8 +7173,11 @@ struct sched_domain *build_sched_domain(struct sched_domain_topology_level *tl,
 
 	set_domain_attribute(sd, attr);
 	cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
-	if (child)
+	if (child) {
+		sd->level = child->level + 1;
+		sched_domain_level_max = max(sched_domain_level_max, sd->level);
 		child->parent = sd;
+	}
 	sd->child = child;
 
 	return sd;
