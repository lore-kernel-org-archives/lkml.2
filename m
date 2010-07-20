Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0GTGqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 02:46:22 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:36852 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab0GTGqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 02:46:20 -0400
Date: Tue, 20 Jul 2010 08:49:20 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] padata: Allocate cpumask dependend recources in any
 case
Message-ID: <20100720064920.GD11081@secunet.com>
References: <20100714142951.22817d0c@leibniz>
 <20100719060426.GA19696@gondor.apana.org.au>
 <20100719064050.GA11081@secunet.com>
 <20100719073255.GA20403@gondor.apana.org.au>
 <20100720064736.GB11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100720064736.GB11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jul 2010 06:46:18.0158 (UTC) FILETIME=[418FB4E0:01CB27D7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cpumask separation work assumes the cpumask dependend recources
present regardless of valid or invalid cpumasks. With this patch
we allocate the cpumask dependend recources in any case. This fixes
two NULL pointer dereference crashes in padata_replace and in
padata_get_cpumask.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 kernel/padata.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 4287868..6a51945 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -417,7 +417,7 @@ static void padata_init_pqueues(struct parallel_data *pd)
 	}
 
 	num_cpus = cpumask_weight(pd->cpumask.pcpu);
-	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
+	pd->max_seq_nr = num_cpus ? (MAX_SEQ_NR / num_cpus) * num_cpus - 1 : 0;
 }
 
 /* Allocate and initialize the internal cpumask dependend resources. */
@@ -527,21 +527,19 @@ static void padata_replace(struct padata_instance *pinst,
 	rcu_assign_pointer(pinst->pd, pd_new);
 
 	synchronize_rcu();
-	if (!pd_old)
-		goto out;
 
-	padata_flush_queues(pd_old);
 	if (!cpumask_equal(pd_old->cpumask.pcpu, pd_new->cpumask.pcpu))
 		notification_mask |= PADATA_CPU_PARALLEL;
 	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
 		notification_mask |= PADATA_CPU_SERIAL;
 
+	padata_flush_queues(pd_old);
 	padata_free_pd(pd_old);
+
 	if (notification_mask)
 		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
 					     notification_mask, pinst);
 
-out:
 	pinst->flags &= ~PADATA_RESET;
 }
 
@@ -673,6 +671,7 @@ int __padata_set_cpumasks(struct padata_instance *pinst,
 	struct parallel_data *pd = NULL;
 
 	mutex_lock(&pinst->lock);
+	get_online_cpus();
 
 	valid = padata_validate_cpumask(pinst, pcpumask);
 	if (!valid) {
@@ -681,20 +680,16 @@ int __padata_set_cpumasks(struct padata_instance *pinst,
 	}
 
 	valid = padata_validate_cpumask(pinst, cbcpumask);
-	if (!valid) {
+	if (!valid)
 		__padata_stop(pinst);
-		goto out_replace;
-	}
-
-	get_online_cpus();
 
+out_replace:
 	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
 	if (!pd) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-out_replace:
 	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
@@ -705,7 +700,6 @@ out_replace:
 
 out:
 	put_online_cpus();
-
 	mutex_unlock(&pinst->lock);
 
 	return err;
@@ -776,11 +770,8 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
 
 		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
-		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu)) {
+		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
 			__padata_stop(pinst);
-			padata_replace(pinst, pd);
-			goto out;
-		}
 
 		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
 				     pinst->cpumask.cbcpu);
@@ -790,7 +781,6 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 		padata_replace(pinst, pd);
 	}
 
-out:
 	return 0;
 }
 
-- 
1.5.6.5

