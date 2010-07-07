Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0GGNal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:30:41 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:47355 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755531Ab0GGNaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:30:39 -0400
Date: Wed, 7 Jul 2010 15:32:39 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Dan Kruchinin <dkruchinin@acm.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] padata: simplify serialization mechanism
Message-ID: <20100707133239.GA10072@secunet.com>
References: <20100707132915.GV10072@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100707132915.GV10072@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 07 Jul 2010 13:30:37.0341 (UTC) FILETIME=[95CA84D0:01CB1DD8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We count the number of processed objects on a percpu basis,
so we need to go through all the percpu reorder queues to calculate
the sequence number of the next object that needs serialization.
This patch changes this to count the number of processed objects
global. So we can calculate the sequence number and the percpu
reorder queue of the next object that needs serialization without
searching through the percpu reorder queues. This avoids some
accesses to memory of foreign cpus.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |    6 ++--
 kernel/padata.c        |   71 +++++++++++++-----------------------------------
 2 files changed, 22 insertions(+), 55 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index e4c17f9..8844b85 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -67,7 +67,6 @@ struct padata_list {
  * @pwork: work struct for parallelization.
  * @swork: work struct for serialization.
  * @pd: Backpointer to the internal control structure.
- * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
  */
 struct padata_queue {
@@ -77,7 +76,6 @@ struct padata_queue {
 	struct work_struct	pwork;
 	struct work_struct	swork;
 	struct parallel_data    *pd;
-	atomic_t		num_obj;
 	int			cpu_index;
 };
 
@@ -93,6 +91,7 @@ struct padata_queue {
  * @max_seq_nr:  Maximal used sequence number.
  * @cpumask: cpumask in use.
  * @lock: Reorder lock.
+ * @processed: Number of already processed objects.
  * @timer: Reorder timer.
  */
 struct parallel_data {
@@ -103,7 +102,8 @@ struct parallel_data {
 	atomic_t                refcnt;
 	unsigned int		max_seq_nr;
 	cpumask_var_t		cpumask;
-	spinlock_t              lock;
+	spinlock_t              lock ____cacheline_aligned;
+	unsigned int            processed;
 	struct timer_list       timer;
 };
 
diff --git a/kernel/padata.c b/kernel/padata.c
index ae8defc..450d67d 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -170,79 +170,47 @@ EXPORT_SYMBOL(padata_do_parallel);
  */
 static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
-	int cpu, num_cpus, empty, calc_seq_nr;
-	int seq_nr, next_nr, overrun, next_overrun;
+	int cpu, num_cpus;
+	int next_nr, next_index;
 	struct padata_queue *queue, *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
 
-	empty = 0;
-	next_nr = -1;
-	next_overrun = 0;
-	next_queue = NULL;
-
 	num_cpus = cpumask_weight(pd->cpumask);
 
-	for_each_cpu(cpu, pd->cpumask) {
-		queue = per_cpu_ptr(pd->queue, cpu);
-		reorder = &queue->reorder;
-
-		/*
-		 * Calculate the seq_nr of the object that should be
-		 * next in this reorder queue.
-		 */
-		overrun = 0;
-		calc_seq_nr = (atomic_read(&queue->num_obj) * num_cpus)
-			       + queue->cpu_index;
-
-		if (unlikely(calc_seq_nr > pd->max_seq_nr)) {
-			calc_seq_nr = calc_seq_nr - pd->max_seq_nr - 1;
-			overrun = 1;
-		}
-
-		if (!list_empty(&reorder->list)) {
-			padata = list_entry(reorder->list.next,
-					    struct padata_priv, list);
-
-			seq_nr  = padata->seq_nr;
-			BUG_ON(calc_seq_nr != seq_nr);
-		} else {
-			seq_nr = calc_seq_nr;
-			empty++;
-		}
-
-		if (next_nr < 0 || seq_nr < next_nr
-		    || (next_overrun && !overrun)) {
-			next_nr = seq_nr;
-			next_overrun = overrun;
-			next_queue = queue;
-		}
+	/*
+	 * Calculate the percpu reorder queue and the sequence
+	 * number of the next object.
+	 */
+	next_nr = pd->processed;
+	next_index = next_nr % num_cpus;
+	cpu = padata_index_to_cpu(pd, next_index);
+	next_queue = per_cpu_ptr(pd->queue, cpu);
+
+	if (unlikely(next_nr > pd->max_seq_nr)) {
+		next_nr = next_nr - pd->max_seq_nr - 1;
+		next_index = next_nr % num_cpus;
+		cpu = padata_index_to_cpu(pd, next_index);
+		next_queue = per_cpu_ptr(pd->queue, cpu);
+		pd->processed = 0;
 	}
 
 	padata = NULL;
 
-	if (empty == num_cpus)
-		goto out;
-
 	reorder = &next_queue->reorder;
 
 	if (!list_empty(&reorder->list)) {
 		padata = list_entry(reorder->list.next,
 				    struct padata_priv, list);
 
-		if (unlikely(next_overrun)) {
-			for_each_cpu(cpu, pd->cpumask) {
-				queue = per_cpu_ptr(pd->queue, cpu);
-				atomic_set(&queue->num_obj, 0);
-			}
-		}
+		BUG_ON(next_nr != padata->seq_nr);
 
 		spin_lock(&reorder->lock);
 		list_del_init(&padata->list);
 		atomic_dec(&pd->reorder_objects);
 		spin_unlock(&reorder->lock);
 
-		atomic_inc(&next_queue->num_obj);
+		pd->processed++;
 
 		goto out;
 	}
@@ -430,7 +398,6 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 
 		INIT_WORK(&queue->pwork, padata_parallel_worker);
 		INIT_WORK(&queue->swork, padata_serial_worker);
-		atomic_set(&queue->num_obj, 0);
 	}
 
 	num_cpus = cpumask_weight(pd->cpumask);
-- 
1.5.6.5

