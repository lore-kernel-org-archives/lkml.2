Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946Ab0GGN33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:29:29 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47332 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290Ab0GGN30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:29:26 -0400
Date: Wed, 7 Jul 2010 15:31:26 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] padata: Handle empty padata cpumasks
Message-ID: <20100707133126.GY10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:29:24.0044 (UTC) FILETIME=[6A1A48C0:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a bug when the padata cpumask does not
intersect with the active cpumask. In this case we get a
division by zero in padata_alloc_pd and we end up with a
useless padata instance. Padata can end up with an empty
cpumask for two reasons:

1. A user removed the last cpu that belongs to the padata
cpumask and the active cpumask.

2. The last cpu that belongs to the padata cpumask and the
active cpumask goes offline.

We introduce a function padata_validate_cpumask to check if the padata
cpumask does intersect with the active cpumask. If the cpumasks do not
intersect we mark the instance as invalid, so it can't be used. We do not
allocate the cpumask dependend recources in this case. This fixes the
division by zero and keeps the padate instance in a consistent state.

It's not possible to trigger this bug by now because the only padata user,
pcrypt uses always the possible cpumask.

Reported-by: Dan Kruchinin <dkruchinin@acm.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   61 +++++++++++++++++++++++++++++++++++++++++++++----------
 1 files changed, 50 insertions(+), 11 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 9e18dfa..57ec4eb 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -516,12 +516,27 @@ static void padata_replace(struct padata_instance *pinst,
 
 	synchronize_rcu();
 
-	padata_flush_queues(pd_old);
-	padata_free_pd(pd_old);
+	if (pd_old) {
+		padata_flush_queues(pd_old);
+		padata_free_pd(pd_old);
+	}
 
 	pinst->flags &= ~PADATA_RESET;
 }
 
+/* If cpumask contains no active cpu, we mark the instance as invalid. */
+static bool padata_validate_cpumask(struct padata_instance *pinst,
+				    const struct cpumask *cpumask)
+{
+	if (!cpumask_intersects(cpumask, cpu_active_mask)) {
+		pinst->flags |= PADATA_INVALID;
+		return false;
+	}
+
+	pinst->flags &= ~PADATA_INVALID;
+	return true;
+}
+
 /**
  * padata_set_cpumask - set the cpumask that padata should use
  *
@@ -531,11 +546,18 @@ static void padata_replace(struct padata_instance *pinst,
 int padata_set_cpumask(struct padata_instance *pinst,
 			cpumask_var_t cpumask)
 {
-	struct parallel_data *pd;
+	int valid;
 	int err = 0;
+	struct parallel_data *pd = NULL;
 
 	mutex_lock(&pinst->lock);
 
+	valid = padata_validate_cpumask(pinst, cpumask);
+	if (!valid) {
+		__padata_stop(pinst);
+		goto out_replace;
+	}
+
 	get_online_cpus();
 
 	pd = padata_alloc_pd(pinst, cpumask);
@@ -544,10 +566,14 @@ int padata_set_cpumask(struct padata_instance *pinst,
 		goto out;
 	}
 
+out_replace:
 	cpumask_copy(pinst->cpumask, cpumask);
 
 	padata_replace(pinst, pd);
 
+	if (valid)
+		__padata_start(pinst);
+
 out:
 	put_online_cpus();
 
@@ -567,6 +593,9 @@ static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 			return -ENOMEM;
 
 		padata_replace(pinst, pd);
+
+		if (padata_validate_cpumask(pinst, pinst->cpumask))
+			__padata_start(pinst);
 	}
 
 	return 0;
@@ -597,9 +626,16 @@ EXPORT_SYMBOL(padata_add_cpu);
 
 static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 {
-	struct parallel_data *pd;
+	struct parallel_data *pd = NULL;
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
+
+		if (!padata_validate_cpumask(pinst, pinst->cpumask)) {
+			__padata_stop(pinst);
+			padata_replace(pinst, pd);
+			goto out;
+		}
+
 		pd = padata_alloc_pd(pinst, pinst->cpumask);
 		if (!pd)
 			return -ENOMEM;
@@ -607,6 +643,7 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 		padata_replace(pinst, pd);
 	}
 
+out:
 	return 0;
 }
 
@@ -732,7 +769,7 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 				     struct workqueue_struct *wq)
 {
 	struct padata_instance *pinst;
-	struct parallel_data *pd;
+	struct parallel_data *pd = NULL;
 
 	pinst = kzalloc(sizeof(struct padata_instance), GFP_KERNEL);
 	if (!pinst)
@@ -740,12 +777,14 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 
 	get_online_cpus();
 
-	pd = padata_alloc_pd(pinst, cpumask);
-	if (!pd)
+	if (!alloc_cpumask_var(&pinst->cpumask, GFP_KERNEL))
 		goto err_free_inst;
 
-	if (!alloc_cpumask_var(&pinst->cpumask, GFP_KERNEL))
-		goto err_free_pd;
+	if (padata_validate_cpumask(pinst, cpumask)) {
+		pd = padata_alloc_pd(pinst, cpumask);
+		if (!pd)
+			goto err_free_mask;
+	}
 
 	rcu_assign_pointer(pinst->pd, pd);
 
@@ -767,8 +806,8 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 
 	return pinst;
 
-err_free_pd:
-	padata_free_pd(pd);
+err_free_mask:
+	free_cpumask_var(pinst->cpumask);
 err_free_inst:
 	kfree(pinst);
 	put_online_cpus();
-- 
1.5.6.5

