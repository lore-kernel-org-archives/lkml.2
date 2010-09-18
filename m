Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab0IRTIu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:08:50 -0400
Received: from kroah.org ([198.145.64.141]:51844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab0IRTCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:23 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:02 2010
Message-Id: <20100918190002.162956113@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:59:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [109/123] sched: Pre-compute cpumask_weight(sched_domain_span(sd))
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-pre-compute-cpumask_weight-sched_domain_span-sd.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 669c55e9f99b90e46eaa0f98a67ec53d46dc969a upstream

Dave reported that his large SPARC machines spend lots of time in
hweight64(), try and optimize some of those needless cpumask_weight()
invocations (esp. with the large offstack cpumasks these are very
expensive indeed).

Reported-by: David Miller <davem@davemloft.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |    7 +++++--
 kernel/sched_fair.c   |    8 +++-----
 3 files changed, 9 insertions(+), 7 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1000,6 +1000,7 @@ struct sched_domain {
 	char *name;
 #endif
 
+	unsigned int span_weight;
 	/*
 	 * Span of all CPUs in this domain.
 	 *
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -3678,7 +3678,7 @@ unsigned long __weak arch_scale_freq_pow
 
 unsigned long default_scale_smt_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long smt_gain = sd->smt_gain;
 
 	smt_gain /= weight;
@@ -3711,7 +3711,7 @@ unsigned long scale_rt_power(int cpu)
 
 static void update_cpu_power(struct sched_domain *sd, int cpu)
 {
-	unsigned long weight = cpumask_weight(sched_domain_span(sd));
+	unsigned long weight = sd->span_weight;
 	unsigned long power = SCHED_LOAD_SCALE;
 	struct sched_group *sdg = sd->groups;
 
@@ -8166,6 +8166,9 @@ cpu_attach_domain(struct sched_domain *s
 	struct rq *rq = cpu_rq(cpu);
 	struct sched_domain *tmp;
 
+	for (tmp = sd; tmp; tmp = tmp->parent)
+		tmp->span_weight = cpumask_weight(sched_domain_span(tmp));
+
 	/* Remove the sched domains which do not contribute to scheduling. */
 	for (tmp = sd; tmp; ) {
 		struct sched_domain *parent = tmp->parent;
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1520,9 +1520,7 @@ select_task_rq_fair(struct rq *rq, struc
 		 * Pick the largest domain to update shares over
 		 */
 		tmp = sd;
-		if (affine_sd && (!tmp ||
-				  cpumask_weight(sched_domain_span(affine_sd)) >
-				  cpumask_weight(sched_domain_span(sd))))
+		if (affine_sd && (!tmp || affine_sd->span_weight > sd->span_weight))
 			tmp = affine_sd;
 
 		if (tmp) {
@@ -1566,10 +1564,10 @@ select_task_rq_fair(struct rq *rq, struc
 
 		/* Now try balancing at a lower domain level of new_cpu */
 		cpu = new_cpu;
-		weight = cpumask_weight(sched_domain_span(sd));
+		weight = sd->span_weight;
 		sd = NULL;
 		for_each_domain(cpu, tmp) {
-			if (weight <= cpumask_weight(sched_domain_span(tmp)))
+			if (weight <= tmp->span_weight)
 				break;
 			if (tmp->flags & sd_flag)
 				sd = tmp;


