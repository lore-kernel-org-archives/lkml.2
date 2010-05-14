Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999Ab0ENLsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:48:22 -0400
Received: from a.mx.secunet.com ([195.81.216.161]:56863 "EHLO a.mx.secunet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671Ab0ENLsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:48:20 -0400
Date: Fri, 14 May 2010 13:46:06 +0200
From: Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH 3/4] padata: Add some code comments
Message-ID: <20100514114606.GD2184@secunet.com>
References: <20100514114336.GB2184@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514114336.GB2184@secunet.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 14 May 2010 11:48:17.0961 (UTC) FILETIME=[5820F990:01CAF35B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/padata.h |   53 ++++++++++++++++++++++++++++++++++++++++++++++++
 kernel/padata.c        |   50 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 101 insertions(+), 2 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 64836a6..e8aac0f 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -26,6 +26,17 @@
 #include <linux/list.h>
 #include <linux/timer.h>
 
+/*
+ * struct padata_priv -  Embedded to the users data structure.
+ *
+ * @list: List entry, to attach to the padata lists.
+ * @pd: Pointer to the internal control structure.
+ * @cb_cpu: Callback cpu for serializatioon.
+ * @seq_nr: Sequence number of the parallelized data object.
+ * @info: Used to pass information from the parallel to the serial function.
+ * @parallel: Parallel execution function.
+ * @serial: Serial complete function.
+ */
 struct padata_priv {
 	struct list_head	list;
 	struct parallel_data	*pd;
@@ -36,11 +47,29 @@ struct padata_priv {
 	void                    (*serial)(struct padata_priv *padata);
 };
 
+/*
+ * struct padata_list
+ *
+ * @list: List head.
+ * @lock: List lock.
+ */
 struct padata_list {
 	struct list_head        list;
 	spinlock_t              lock;
 };
 
+/*
+ * struct padata_queue - The percpu padata queues.
+ *
+ * @parallel: List to wait for parallelization.
+ * @reorder: List to wait for reordering after parallel processing.
+ * @serial: List to wait for serialization after reordering.
+ * @pwork: work struct for parallelization.
+ * @swork: work struct for serialization.
+ * @pd: Backpointer to the internal control structure.
+ * @num_obj: Number of objects that are processed by this cpu.
+ * @cpu_index: Index of the cpu.
+ */
 struct padata_queue {
 	struct padata_list	parallel;
 	struct padata_list	reorder;
@@ -52,6 +81,20 @@ struct padata_queue {
 	int			cpu_index;
 };
 
+/*
+ * struct parallel_data - Internal control structure, covers everything
+ * that depends on the cpumask in use.
+ *
+ * @pinst: padata instance.
+ * @queue: percpu padata queues.
+ * @seq_nr: The sequence number that will be attached to the next object.
+ * @reorder_objects: Number of objects waiting in the reorder queues.
+ * @refcnt: Number of objects holding a reference on this parallel_data.
+ * @max_seq_nr:  Maximal used sequence number.
+ * @cpumask: cpumask in use.
+ * @lock: Reorder lock.
+ * @timer: Reorder timer.
+ */
 struct parallel_data {
 	struct padata_instance	*pinst;
 	struct padata_queue	*queue;
@@ -64,6 +107,16 @@ struct parallel_data {
 	struct timer_list       timer;
 };
 
+/*
+ * struct padata_instance - The overall control structure.
+ *
+ * @cpu_notifier: cpu hotplug notifier.
+ * @wq: The workqueue in use.
+ * @pd: The internal control structure.
+ * @cpumask: User supplied cpumask.
+ * @lock: padata instance lock.
+ * @flags: padata flags.
+ */
 struct padata_instance {
 	struct notifier_block   cpu_notifier;
 	struct workqueue_struct *wq;
diff --git a/kernel/padata.c b/kernel/padata.c
index ec6b8b7..629bef3 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -152,6 +152,23 @@ out:
 }
 EXPORT_SYMBOL(padata_do_parallel);
 
+/*
+ * padata_get_next - Get the next object that needs serialization.
+ *
+ * Return values are:
+ *
+ * A pointer to the control struct of the next object that needs
+ * serialization, if present in one of the percpu reorder queues.
+ *
+ * NULL, if all percpu reorder queues are empty.
+ *
+ * -EINPROGRESS, if the next object that needs serialization will
+ *  be parallel processed by another cpu and is not yet present in
+ *  the cpu's reorder queue.
+ *
+ * -ENODATA, if this cpu has to do the parallel processing for
+ *  the next object.
+ */
 static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
 	int cpu, num_cpus, empty, calc_seq_nr;
@@ -173,7 +190,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 
 		/*
 		 * Calculate the seq_nr of the object that should be
-		 * next in this queue.
+		 * next in this reorder queue.
 		 */
 		overrun = 0;
 		calc_seq_nr = (atomic_read(&queue->num_obj) * num_cpus)
@@ -248,15 +265,36 @@ static void padata_reorder(struct parallel_data *pd)
 	struct padata_queue *queue;
 	struct padata_instance *pinst = pd->pinst;
 
+	/*
+	 * We need to ensure that only one cpu can work on dequeueing of
+	 * the reorder queue the time. Calculating in which percpu reorder
+	 * queue the next object will arrive takes some time. A spinlock
+	 * would be highly contended. Also it is not clear in which order
+	 * the objects arrive to the reorder queues. So a cpu could wait to
+	 * get the lock just to notice that there is nothing to do at the
+	 * moment. Therefore we use a trylock and let the holder of the lock
+	 * care for all the objects enqueued during the holdtime of the lock.
+	 */
 	if (!spin_trylock_bh(&pd->lock))
 		return;
 
 	while (1) {
 		padata = padata_get_next(pd);
 
+		/*
+		 * All reorder queues are empty, or the next object that needs
+		 * serialization is parallel processed by another cpu and is
+		 * still on it's way to the cpu's reorder queue, nothing to
+		 * do for now.
+		 */
 		if (!padata || PTR_ERR(padata) == -EINPROGRESS)
 			break;
 
+		/*
+		 * This cpu has to do the parallel processing of the next
+		 * object. It's waiting in the cpu's parallelization queue,
+		 * so exit imediately.
+		 */
 		if (PTR_ERR(padata) == -ENODATA) {
 			del_timer(&pd->timer);
 			spin_unlock_bh(&pd->lock);
@@ -274,6 +312,11 @@ static void padata_reorder(struct parallel_data *pd)
 
 	spin_unlock_bh(&pd->lock);
 
+	/*
+	 * The next object that needs serialization might have arrived to
+	 * the reorder queues in the meantime, we will be called again
+	 * from the timer function if noone else cares for it.
+	 */
 	if (atomic_read(&pd->reorder_objects)
 			&& !(pinst->flags & PADATA_RESET))
 		mod_timer(&pd->timer, jiffies + HZ);
@@ -348,6 +391,7 @@ void padata_do_serial(struct padata_priv *padata)
 }
 EXPORT_SYMBOL(padata_do_serial);
 
+/* Allocate and initialize the internal cpumask dependend resources. */
 static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 					     const struct cpumask *cpumask)
 {
@@ -417,6 +461,7 @@ static void padata_free_pd(struct parallel_data *pd)
 	kfree(pd);
 }
 
+/* Flush all objects out of the padata queues. */
 static void padata_flush_queues(struct parallel_data *pd)
 {
 	int cpu;
@@ -440,6 +485,7 @@ static void padata_flush_queues(struct parallel_data *pd)
 	BUG_ON(atomic_read(&pd->refcnt) != 0);
 }
 
+/* Replace the internal control stucture with a new one. */
 static void padata_replace(struct padata_instance *pinst,
 			   struct parallel_data *pd_new)
 {
@@ -706,7 +752,7 @@ EXPORT_SYMBOL(padata_alloc);
 /*
  * padata_free - free a padata instance
  *
- * @ padata_inst: padata instance to free
+ * @padata_inst: padata instance to free
  */
 void padata_free(struct padata_instance *pinst)
 {
-- 
1.5.6.5

