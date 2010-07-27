Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314Ab0G0FQJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:16:09 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:33236 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab0G0FQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:16:05 -0400
Date: Tue, 27 Jul 2010 07:19:27 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] padata: Remove padata_get_cpumask
Message-ID: <20100727051927.GO11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:15:51.0870 (UTC) FILETIME=[C8221DE0:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A function that copies the padata cpumasks to a user buffer
is a bit error prone. The cpumask can change any time so we
can't be sure to have the right cpumask when using this function.
A user who is interested in the padata cpumasks should register
to the padata cpumask notifier chain instead. Users of
padata_get_cpumask are already updated, so we can remove it.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |    2 --
 kernel/padata.c        |   35 -----------------------------------
 2 files changed, 0 insertions(+), 37 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 43db792..bdcd1e9 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -176,8 +176,6 @@ extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
 			      struct padata_priv *padata, int cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
-extern int padata_get_cpumask(struct padata_instance *pinst,
-			      int cpumask_type, struct cpumask *out_mask);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
 extern int padata_set_cpumasks(struct padata_instance *pinst,
diff --git a/kernel/padata.c b/kernel/padata.c
index 1c8c1d1..fd46792 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -589,41 +589,6 @@ static bool padata_validate_cpumask(struct padata_instance *pinst,
 	return true;
 }
 
-/**
- * padata_get_cpumask: Fetch serial or parallel cpumask from the
- *                     given padata instance and copy it to @out_mask
- *
- * @pinst: A pointer to padata instance
- * @cpumask_type: Specifies which cpumask will be copied.
- *                Possible values are PADATA_CPU_SERIAL *or* PADATA_CPU_PARALLEL
- *                corresponding to serial and parallel cpumask respectively.
- * @out_mask: A pointer to cpumask structure where selected
- *            cpumask will be copied.
- */
-int padata_get_cpumask(struct padata_instance *pinst,
-		       int cpumask_type, struct cpumask *out_mask)
-{
-	struct parallel_data *pd;
-	int ret = 0;
-
-	rcu_read_lock_bh();
-	pd = rcu_dereference(pinst->pd);
-	switch (cpumask_type) {
-	case PADATA_CPU_SERIAL:
-		cpumask_copy(out_mask, pd->cpumask.cbcpu);
-		break;
-	case PADATA_CPU_PARALLEL:
-		cpumask_copy(out_mask, pd->cpumask.pcpu);
-		break;
-	default:
-		ret = -EINVAL;
-	}
-
-	rcu_read_unlock_bh();
-	return ret;
-}
-EXPORT_SYMBOL(padata_get_cpumask);
-
 static int __padata_set_cpumasks(struct padata_instance *pinst,
 				 cpumask_var_t pcpumask,
 				 cpumask_var_t cbcpumask)
-- 
1.5.6.5

