Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab2CIGVA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:21:00 -0500
Received: from a.mx.secunet.com ([195.81.216.161]:56909 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2CIGU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:20:58 -0500
Date: Fri, 9 Mar 2012 07:20:49 +0100
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] padata: Fix race on sequence number wrap
Message-ID: <20120309062049.GK15404@secunet.com>
References: <20120309061828.GI15404@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309061828.GI15404@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 09 Mar 2012 06:20:49.0398 (UTC) FILETIME=[C55FF160:01CCFDBC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When padata_do_parallel() is called from multiple cpus for the same
padata instance, we can get object reordering on sequence number wrap
because testing for sequence number wrap and reseting the sequence
number must happen atomically but is implemented with two atomic
operations. This patch fixes this by converting the sequence number
from atomic_t to an unsigned int and protect the access with a
spin_lock. As a side effect, we get rid of the sequence number wrap
handling because the seqence number wraps back to null now without
the need to do anything.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |    6 ++----
 kernel/padata.c        |   38 ++++++++++----------------------------
 2 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 4633b2f..86292be 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -46,7 +46,6 @@ struct padata_priv {
 	struct list_head	list;
 	struct parallel_data	*pd;
 	int			cb_cpu;
-	int			seq_nr;
 	int			info;
 	void                    (*parallel)(struct padata_priv *padata);
 	void                    (*serial)(struct padata_priv *padata);
@@ -116,7 +115,6 @@ struct padata_cpumask {
  * @pinst: padata instance.
  * @pqueue: percpu padata queues used for parallelization.
  * @squeue: percpu padata queues used for serialuzation.
- * @seq_nr: The sequence number that will be attached to the next object.
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
@@ -129,12 +127,12 @@ struct parallel_data {
 	struct padata_instance		*pinst;
 	struct padata_parallel_queue	__percpu *pqueue;
 	struct padata_serial_queue	__percpu *squeue;
-	atomic_t			seq_nr;
 	atomic_t			reorder_objects;
 	atomic_t			refcnt;
-	unsigned int			max_seq_nr;
 	struct padata_cpumask		cpumask;
 	spinlock_t                      lock ____cacheline_aligned;
+	spinlock_t                      seq_lock;
+	unsigned int			seq_nr;
 	unsigned int			processed;
 	struct timer_list		timer;
 };
diff --git a/kernel/padata.c b/kernel/padata.c
index aa99295..6f10eb2 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -29,7 +29,6 @@
 #include <linux/sysfs.h>
 #include <linux/rcupdate.h>
 
-#define MAX_SEQ_NR (INT_MAX - NR_CPUS)
 #define MAX_OBJ_NUM 1000
 
 static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
@@ -43,18 +42,19 @@ static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 	return target_cpu;
 }
 
-static int padata_cpu_hash(struct padata_priv *padata)
+static int padata_cpu_hash(struct parallel_data *pd)
 {
 	int cpu_index;
-	struct parallel_data *pd;
-
-	pd =  padata->pd;
 
 	/*
 	 * Hash the sequence numbers to the cpus by taking
 	 * seq_nr mod. number of cpus in use.
 	 */
-	cpu_index =  padata->seq_nr % cpumask_weight(pd->cpumask.pcpu);
+
+	spin_lock(&pd->seq_lock);
+	cpu_index =  pd->seq_nr % cpumask_weight(pd->cpumask.pcpu);
+	pd->seq_nr++;
+	spin_unlock(&pd->seq_lock);
 
 	return padata_index_to_cpu(pd, cpu_index);
 }
@@ -132,12 +132,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	padata->pd = pd;
 	padata->cb_cpu = cb_cpu;
 
-	if (unlikely(atomic_read(&pd->seq_nr) == pd->max_seq_nr))
-		atomic_set(&pd->seq_nr, -1);
-
-	padata->seq_nr = atomic_inc_return(&pd->seq_nr);
-
-	target_cpu = padata_cpu_hash(padata);
+	target_cpu = padata_cpu_hash(pd);
 	queue = per_cpu_ptr(pd->pqueue, target_cpu);
 
 	spin_lock(&queue->parallel.lock);
@@ -173,7 +168,7 @@ EXPORT_SYMBOL(padata_do_parallel);
 static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
 	int cpu, num_cpus;
-	int next_nr, next_index;
+	unsigned int next_nr, next_index;
 	struct padata_parallel_queue *queue, *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
@@ -189,14 +184,6 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 	cpu = padata_index_to_cpu(pd, next_index);
 	next_queue = per_cpu_ptr(pd->pqueue, cpu);
 
-	if (unlikely(next_nr > pd->max_seq_nr)) {
-		next_nr = next_nr - pd->max_seq_nr - 1;
-		next_index = next_nr % num_cpus;
-		cpu = padata_index_to_cpu(pd, next_index);
-		next_queue = per_cpu_ptr(pd->pqueue, cpu);
-		pd->processed = 0;
-	}
-
 	padata = NULL;
 
 	reorder = &next_queue->reorder;
@@ -205,8 +192,6 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		padata = list_entry(reorder->list.next,
 				    struct padata_priv, list);
 
-		BUG_ON(next_nr != padata->seq_nr);
-
 		spin_lock(&reorder->lock);
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
@@ -402,7 +387,7 @@ static void padata_init_squeues(struct parallel_data *pd)
 /* Initialize all percpu queues used by parallel workers */
 static void padata_init_pqueues(struct parallel_data *pd)
 {
-	int cpu_index, num_cpus, cpu;
+	int cpu_index, cpu;
 	struct padata_parallel_queue *pqueue;
 
 	cpu_index = 0;
@@ -417,9 +402,6 @@ static void padata_init_pqueues(struct parallel_data *pd)
 		INIT_WORK(&pqueue->work, padata_parallel_worker);
 		atomic_set(&pqueue->num_obj, 0);
 	}
-
-	num_cpus = cpumask_weight(pd->cpumask.pcpu);
-	pd->max_seq_nr = num_cpus ? (MAX_SEQ_NR / num_cpus) * num_cpus - 1 : 0;
 }
 
 /* Allocate and initialize the internal cpumask dependend resources. */
@@ -446,7 +428,7 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 	padata_init_pqueues(pd);
 	padata_init_squeues(pd);
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
-	atomic_set(&pd->seq_nr, -1);
+	pd->seq_nr = 0;
 	atomic_set(&pd->reorder_objects, 0);
 	atomic_set(&pd->refcnt, 0);
 	pd->pinst = pinst;
-- 
1.7.0.4

