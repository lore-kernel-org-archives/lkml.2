Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab0G0FLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:11:36 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45553 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0G0FLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:11:34 -0400
Date: Tue, 27 Jul 2010 07:15:06 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] padata: Rearrange set_cpumask functions
Message-ID: <20100727051506.GK11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:11:30.0823 (UTC) FILETIME=[2C898170:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

padata_set_cpumask needs to be protected by a lock. We make
__padata_set_cpumasks unlocked and static. So this function
can be used by the exported and locked padata_set_cpumask and
padata_set_cpumasks functions.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |    6 +-
 kernel/padata.c        |  117 +++++++++++++++++++++++++++--------------------
 2 files changed, 70 insertions(+), 53 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 71dfc9d..bb0fc5d 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -178,9 +178,9 @@ extern int padata_get_cpumask(struct padata_instance *pinst,
 			      int cpumask_type, struct cpumask *out_mask);
 extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
-extern int __padata_set_cpumasks(struct padata_instance *pinst,
-				 cpumask_var_t pcpumask,
-				 cpumask_var_t cbcpumask);
+extern int padata_set_cpumasks(struct padata_instance *pinst,
+			       cpumask_var_t pcpumask,
+			       cpumask_var_t cbcpumask);
 extern int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
 extern int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 extern int padata_start(struct padata_instance *pinst);
diff --git a/kernel/padata.c b/kernel/padata.c
index 12860bc..4987203 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -623,6 +623,66 @@ int padata_get_cpumask(struct padata_instance *pinst,
 }
 EXPORT_SYMBOL(padata_get_cpumask);
 
+static int __padata_set_cpumasks(struct padata_instance *pinst,
+				 cpumask_var_t pcpumask,
+				 cpumask_var_t cbcpumask)
+{
+	int valid;
+	struct parallel_data *pd;
+
+	valid = padata_validate_cpumask(pinst, pcpumask);
+	if (!valid) {
+		__padata_stop(pinst);
+		goto out_replace;
+	}
+
+	valid = padata_validate_cpumask(pinst, cbcpumask);
+	if (!valid)
+		__padata_stop(pinst);
+
+out_replace:
+	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
+	if (!pd)
+		return -ENOMEM;
+
+	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
+	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
+
+	padata_replace(pinst, pd);
+
+	if (valid)
+		__padata_start(pinst);
+
+	return 0;
+}
+
+/**
+ * padata_set_cpumasks - Set both parallel and serial cpumasks. The first
+ *                       one is used by parallel workers and the second one
+ *                       by the wokers doing serialization.
+ *
+ * @pinst: padata instance
+ * @pcpumask: the cpumask to use for parallel workers
+ * @cbcpumask: the cpumsak to use for serial workers
+ */
+int padata_set_cpumasks(struct padata_instance *pinst, cpumask_var_t pcpumask,
+			cpumask_var_t cbcpumask)
+{
+	int err;
+
+	mutex_lock(&pinst->lock);
+	get_online_cpus();
+
+	err = __padata_set_cpumasks(pinst, pcpumask, cbcpumask);
+
+	put_online_cpus();
+	mutex_unlock(&pinst->lock);
+
+	return err;
+
+}
+EXPORT_SYMBOL(padata_set_cpumasks);
+
 /**
  * padata_set_cpumask: Sets specified by @cpumask_type cpumask to the value
  *                     equivalent to @cpumask.
@@ -636,6 +696,10 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 		       cpumask_var_t cpumask)
 {
 	struct cpumask *serial_mask, *parallel_mask;
+	int err = -EINVAL;
+
+	mutex_lock(&pinst->lock);
+	get_online_cpus();
 
 	switch (cpumask_type) {
 	case PADATA_CPU_PARALLEL:
@@ -647,65 +711,18 @@ int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 		serial_mask = cpumask;
 		break;
 	default:
-		return -EINVAL;
+		 goto out;
 	}
 
-	return __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
-}
-EXPORT_SYMBOL(padata_set_cpumask);
-
-/**
- * __padata_set_cpumasks - Set both parallel and serial cpumasks. The first
- *                         one is used by parallel workers and the second one
- *                         by the wokers doing serialization.
- *
- * @pinst: padata instance
- * @pcpumask: the cpumask to use for parallel workers
- * @cbcpumask: the cpumsak to use for serial workers
- */
-int __padata_set_cpumasks(struct padata_instance *pinst,
-			  cpumask_var_t pcpumask, cpumask_var_t cbcpumask)
-{
-	int valid;
-	int err = 0;
-	struct parallel_data *pd = NULL;
-
-	mutex_lock(&pinst->lock);
-	get_online_cpus();
-
-	valid = padata_validate_cpumask(pinst, pcpumask);
-	if (!valid) {
-		__padata_stop(pinst);
-		goto out_replace;
-	}
-
-	valid = padata_validate_cpumask(pinst, cbcpumask);
-	if (!valid)
-		__padata_stop(pinst);
-
-out_replace:
-	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
-	if (!pd) {
-		err = -ENOMEM;
-		goto out;
-	}
-
-	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
-	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
-
-	padata_replace(pinst, pd);
-
-	if (valid)
-		__padata_start(pinst);
+	err =  __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
 
 out:
 	put_online_cpus();
 	mutex_unlock(&pinst->lock);
 
 	return err;
-
 }
-EXPORT_SYMBOL(__padata_set_cpumasks);
+EXPORT_SYMBOL(padata_set_cpumask);
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
-- 
1.5.6.5

