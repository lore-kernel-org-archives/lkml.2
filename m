Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab1DGMoM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 08:44:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:48161 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026Ab1DGMkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 08:40:53 -0400
Message-Id: <20110407122942.607287405@chello.nl>
User-Agent: quilt/0.48-1
Date: Thu, 07 Apr 2011 14:09:57 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 16/23] sched: Create persistent sched_domains_tmpmask
References: <20110407120941.400629539@chello.nl>
Content-Disposition: inline; filename=sched-foo15.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since sched domain creation is fully serialized by the
sched_domains_mutex we can create a single persistent tmpmask to use
during domain creation.

This removes the need for s_data::send_covered.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6791,7 +6791,6 @@ struct sd_data {
 };
 
 struct s_data {
-	cpumask_var_t		send_covered;
 	struct sched_domain ** __percpu sd;
 	struct sd_data 		sdd[SD_LV_MAX];
 	struct root_domain	*rd;
@@ -6801,7 +6800,6 @@ enum s_alloc {
 	sa_rootdomain,
 	sa_sd,
 	sa_sd_storage,
-	sa_send_covered,
 	sa_none,
 };
 
@@ -6822,6 +6820,8 @@ static int get_group(int cpu, struct sd_
 	return cpu;
 }
 
+static cpumask_var_t sched_domains_tmpmask; /* sched_domains_mutex */
+
 /*
  * build_sched_groups takes the cpumask we wish to span, and a pointer
  * to a function which identifies what group(along with sched group) a CPU
@@ -6833,13 +6833,17 @@ static int get_group(int cpu, struct sd_
  * and ->cpu_power to 0.
  */
 static void
-build_sched_groups(struct sched_domain *sd, struct cpumask *covered)
+build_sched_groups(struct sched_domain *sd)
 {
 	struct sched_group *first = NULL, *last = NULL;
 	struct sd_data *sdd = sd->private;
 	const struct cpumask *span = sched_domain_span(sd);
+	struct cpumask *covered;
 	int i;
 
+	lockdep_assert_held(&sched_domains_mutex);
+	covered = sched_domains_tmpmask;
+
 	cpumask_clear(covered);
 
 	for_each_cpu(i, span) {
@@ -6984,8 +6988,6 @@ static void __free_domain_allocs(struct 
 			free_percpu(d->sdd[i].sd);
 			free_percpu(d->sdd[i].sg);
 		} /* fall through */
-	case sa_send_covered:
-		free_cpumask_var(d->send_covered); /* fall through */
 	case sa_none:
 		break;
 	}
@@ -6998,8 +7000,6 @@ static enum s_alloc __visit_domain_alloc
 
 	memset(d, 0, sizeof(*d));
 
-	if (!alloc_cpumask_var(&d->send_covered, GFP_KERNEL))
-		return sa_none;
 	for (i = 0; i < SD_LV_MAX; i++) {
 		d->sdd[i].sd = alloc_percpu(struct sched_domain *);
 		if (!d->sdd[i].sd)
@@ -7188,7 +7188,7 @@ static int __build_sched_domains(const s
 			if (i != cpumask_first(sched_domain_span(sd)))
 				continue;
 
-			build_sched_groups(sd, d.send_covered);
+			build_sched_groups(sd);
 		}
 	}
 
@@ -7870,6 +7870,7 @@ void __init sched_init(void)
 
 	/* Allocate the nohz_cpu_mask if CONFIG_CPUMASK_OFFSTACK */
 	zalloc_cpumask_var(&nohz_cpu_mask, GFP_NOWAIT);
+	zalloc_cpumask_var(&sched_domains_tmpmask, GFP_NOWAIT);
 #ifdef CONFIG_SMP
 #ifdef CONFIG_NO_HZ
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);


