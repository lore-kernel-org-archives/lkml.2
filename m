Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0G0FLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 01:11:00 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:45546 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab0G0FK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 01:10:56 -0400
Date: Tue, 27 Jul 2010 07:14:28 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] padata: Rename padata_alloc functions
Message-ID: <20100727051428.GJ11081@secunet.com>
References: <20100727051347.GI11081@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100727051347.GI11081@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 27 Jul 2010 05:10:52.0308 (UTC) FILETIME=[15949540:01CB2D4A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We rename padata_alloc to padata_alloc_possible because this
function allocates a padata_instance and uses the cpu_possible
mask for parallel and serial workers. Also we rename __padata_alloc
to padata_alloc to avoid to export underlined functions. Underlined
functions are considered to be private to padata. Users are updated
accordingly.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 crypto/pcrypt.c        |    2 +-
 include/linux/padata.h |    9 +++++----
 kernel/padata.c        |   24 ++++++++++++------------
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 794c172..5546083 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -457,7 +457,7 @@ static int __pcrypt_init_instance(struct pcrypt_instance *pcrypt,
 	if (!pcrypt->wq)
 		goto err;
 
-	pcrypt->pinst = padata_alloc(pcrypt->wq);
+	pcrypt->pinst = padata_alloc_possible(pcrypt->wq);
 	if (!pcrypt->pinst)
 		goto err_destroy_workqueue;
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 293ad46..71dfc9d 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -165,10 +165,11 @@ struct padata_instance {
 #define	PADATA_INVALID	4
 };
 
-extern struct padata_instance *padata_alloc(struct workqueue_struct *wq);
-extern struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
-					      const struct cpumask *pcpumask,
-					      const struct cpumask *cbcpumask);
+extern struct padata_instance *padata_alloc_possible(
+					struct workqueue_struct *wq);
+extern struct padata_instance *padata_alloc(struct workqueue_struct *wq,
+					    const struct cpumask *pcpumask,
+					    const struct cpumask *cbcpumask);
 extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
 			      struct padata_priv *padata, int cb_cpu);
diff --git a/kernel/padata.c b/kernel/padata.c
index 7f895e2..12860bc 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -1060,29 +1060,29 @@ static struct kobj_type padata_attr_type = {
 };
 
 /**
- * padata_alloc - Allocate and initialize padata instance.
- *                Use default cpumask(cpu_possible_mask)
- *                for serial and parallel workes.
+ * padata_alloc_possible - Allocate and initialize padata instance.
+ *                         Use the cpu_possible_mask for serial and
+ *                         parallel workers.
  *
  * @wq: workqueue to use for the allocated padata instance
  */
-struct padata_instance *padata_alloc(struct workqueue_struct *wq)
+struct padata_instance *padata_alloc_possible(struct workqueue_struct *wq)
 {
-	return __padata_alloc(wq, cpu_possible_mask, cpu_possible_mask);
+	return padata_alloc(wq, cpu_possible_mask, cpu_possible_mask);
 }
-EXPORT_SYMBOL(padata_alloc);
+EXPORT_SYMBOL(padata_alloc_possible);
 
 /**
- * __padata_alloc - allocate and initialize a padata instance
- *                  and specify cpumasks for serial and parallel workers.
+ * padata_alloc - allocate and initialize a padata instance and specify
+ *                cpumasks for serial and parallel workers.
  *
  * @wq: workqueue to use for the allocated padata instance
  * @pcpumask: cpumask that will be used for padata parallelization
  * @cbcpumask: cpumask that will be used for padata serialization
  */
-struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
-				       const struct cpumask *pcpumask,
-				       const struct cpumask *cbcpumask)
+struct padata_instance *padata_alloc(struct workqueue_struct *wq,
+				     const struct cpumask *pcpumask,
+				     const struct cpumask *cbcpumask)
 {
 	struct padata_instance *pinst;
 	struct parallel_data *pd = NULL;
@@ -1138,7 +1138,7 @@ err_free_inst:
 err:
 	return NULL;
 }
-EXPORT_SYMBOL(__padata_alloc);
+EXPORT_SYMBOL(padata_alloc);
 
 /**
  * padata_free - free a padata instance
-- 
1.5.6.5

