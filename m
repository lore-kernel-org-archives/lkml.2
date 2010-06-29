Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab0F2Qeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:34:36 -0400
Received: from office.altell.ru ([80.246.246.162]:11143 "EHLO office.altell.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663Ab0F2Qe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:34:26 -0400
Date: Tue, 29 Jun 2010 20:34:15 +0400
From: Dan Kruchinin <kruchinin@altell.ru>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
       Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 1/2] padata: Separate cpumasks for cb_cpus and parallel
 workers
Message-ID: <20100629203415.01c953e4@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Altell-MailScanner-ID: E513353E2.5D08C
X-Altell-MailScanner: Found to be clean
X-Altell-MailScanner-From: kruchinin@altell.ru
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Two separate cpumasks for parallel and serial workers
2) padata_alloc does not takes cpumask as its argument, instead
it uses a default one. __padata_alloc takes two cpumasks as its
arguments: one for parallel workers and another one for serial.
3) I made padata_cpu_hash a public function to reduce code size(in
several places in pcrypt.c there is near the same code(for getting cpu
hash) as in padata_cpu_hash)

--
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 247178c..20f3e47 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -33,33 +33,29 @@ static struct workqueue_struct *decwq;
 
 struct pcrypt_instance_ctx {
 	struct crypto_spawn spawn;
-	unsigned int tfm_count;
 };
 
 struct pcrypt_aead_ctx {
 	struct crypto_aead *child;
-	unsigned int cb_cpu;
+	int cb_cpu;
+	unsigned int tfm_count;
 };
 
-static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
-			      struct padata_instance *pinst)
+static int pcrypt_do_parallel(struct padata_priv *padata,
+                              struct pcrypt_aead_ctx *ctx,
+                              struct padata_instance *pinst)
 {
-	unsigned int cpu_index, cpu, i;
-
-	cpu = *cb_cpu;
-
-	if (cpumask_test_cpu(cpu, cpu_active_mask))
-			goto out;
-
-	cpu_index = cpu % cpumask_weight(cpu_active_mask);
+	int cpu;
 
-	cpu = cpumask_first(cpu_active_mask);
-	for (i = 0; i < cpu_index; i++)
-		cpu = cpumask_next(cpu, cpu_active_mask);
+	cpu = ctx->cb_cpu;
+	if (cpu < 0) {
+		struct cpumask mask;
 
-	*cb_cpu = cpu;
+		padata_get_cb_cpumask(pinst, &mask);
+		cpu = padata_cpu_hash(&mask, ctx->tfm_count);
+		ctx->cb_cpu = cpu;
+	}
 
-out:
 	return padata_do_parallel(pinst, padata, cpu);
 }
 
@@ -142,7 +138,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_assoc(creq, req->assoc, req->assoclen);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
+	err = pcrypt_do_parallel(padata, ctx, pcrypt_enc_padata);
 	if (err)
 		return err;
 	else
@@ -186,7 +182,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_assoc(creq, req->assoc, req->assoclen);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_dec_padata);
+	err = pcrypt_do_parallel(padata, ctx, pcrypt_dec_padata);
 	if (err)
 		return err;
 	else
@@ -232,7 +228,7 @@ static int pcrypt_aead_givencrypt(struct aead_givcrypt_request *req)
 	aead_givcrypt_set_assoc(creq, areq->assoc, areq->assoclen);
 	aead_givcrypt_set_giv(creq, req->giv, req->seq);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
+	err = pcrypt_do_parallel(padata, ctx, pcrypt_enc_padata);
 	if (err)
 		return err;
 	else
@@ -243,20 +239,12 @@ static int pcrypt_aead_givencrypt(struct aead_givcrypt_request *req)
 
 static int pcrypt_aead_init_tfm(struct crypto_tfm *tfm)
 {
-	int cpu, cpu_index;
 	struct crypto_instance *inst = crypto_tfm_alg_instance(tfm);
-	struct pcrypt_instance_ctx *ictx = crypto_instance_ctx(inst);
 	struct pcrypt_aead_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypto_aead *cipher;
 
-	ictx->tfm_count++;
-
-	cpu_index = ictx->tfm_count % cpumask_weight(cpu_active_mask);
-
-	ctx->cb_cpu = cpumask_first(cpu_active_mask);
-	for (cpu = 0; cpu < cpu_index; cpu++)
-		ctx->cb_cpu = cpumask_next(ctx->cb_cpu, cpu_active_mask);
-
+	ctx->tfm_count++;
+	ctx->cb_cpu = -1;
 	cipher = crypto_spawn_aead(crypto_instance_ctx(inst));
 
 	if (IS_ERR(cipher))
@@ -394,11 +382,11 @@ static int __init pcrypt_init(void)
 		goto err_destroy_encwq;
 
 
-	pcrypt_enc_padata = padata_alloc(cpu_possible_mask, encwq);
+	pcrypt_enc_padata = padata_alloc(encwq);
 	if (!pcrypt_enc_padata)
 		goto err_destroy_decwq;
 
-	pcrypt_dec_padata = padata_alloc(cpu_possible_mask, decwq);
+	pcrypt_dec_padata = padata_alloc(decwq);
 	if (!pcrypt_dec_padata)
 		goto err_free_padata;
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 8d84062..ff73114 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -26,6 +26,9 @@
 #include <linux/list.h>
 #include <linux/timer.h>
 
+#define PADATA_CPU_SERIAL   0x01
+#define PADATA_CPU_PARALLEL 0x02
+
 /**
  * struct padata_priv -  Embedded to the users data structure.
  *
@@ -59,26 +62,35 @@ struct padata_list {
 };
 
 /**
- * struct padata_queue - The percpu padata queues.
+ * struct padata_serial_queue - The percpu padata serial queue
+ *
+ * @serial: List to wait for serialization after reordering.
+ * @work: work struct for serialization.
+ * @pd: Backpointer to the internal control structure.
+ */
+struct padata_serial_queue {
+	struct padata_list    serial;
+	struct work_struct    work;
+	struct parallel_data *pd;
+};
+
+/**
+ * struct padata_parallel_queue - The percpu padata parallel queue
  *
  * @parallel: List to wait for parallelization.
  * @reorder: List to wait for reordering after parallel processing.
- * @serial: List to wait for serialization after reordering.
- * @pwork: work struct for parallelization.
- * @swork: work struct for serialization.
  * @pd: Backpointer to the internal control structure.
+ * @work: work struct for parallelization.
  * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
  */
-struct padata_queue {
-	struct padata_list	parallel;
-	struct padata_list	reorder;
-	struct padata_list	serial;
-	struct work_struct	pwork;
-	struct work_struct	swork;
-	struct parallel_data    *pd;
-	atomic_t		num_obj;
-	int			cpu_index;
+struct padata_parallel_queue {
+	struct padata_list    parallel;
+	struct padata_list    reorder;
+	struct parallel_data *pd;
+	struct work_struct    work;
+	atomic_t              num_obj;
+	int                   cpu_index;
 };
 
 /**
@@ -86,25 +98,31 @@ struct padata_queue {
  * that depends on the cpumask in use.
  *
  * @pinst: padata instance.
- * @queue: percpu padata queues.
+ * @pqueue: percpu padata queues used for parallelization.
+ * @squeeu: percpu padata queues used for serialuzation.
  * @seq_nr: The sequence number that will be attached to the next object.
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
- * @cpumask: cpumask in use.
+ * @cpumask: Contains two cpumasks: pcpu and cbcpu for
+ *           parallel and serial workers respectively.
  * @lock: Reorder lock.
  * @timer: Reorder timer.
  */
 struct parallel_data {
-	struct padata_instance	*pinst;
-	struct padata_queue	*queue;
-	atomic_t		seq_nr;
-	atomic_t		reorder_objects;
-	atomic_t                refcnt;
-	unsigned int		max_seq_nr;
-	cpumask_var_t		cpumask;
-	spinlock_t              lock;
-	struct timer_list       timer;
+	struct padata_instance       *pinst;
+	struct padata_parallel_queue *pqueue;
+	struct padata_serial_queue   *squeue;
+	atomic_t                      seq_nr;
+	atomic_t                      reorder_objects;
+	atomic_t                      refcnt;
+	unsigned int                  max_seq_nr;
+	struct {
+		cpumask_var_t             pcpu;
+		cpumask_var_t             cbcpu;
+	} cpumask;
+	spinlock_t                    lock;
+	struct timer_list             timer;
 };
 
 /**
@@ -113,7 +131,8 @@ struct parallel_data {
  * @cpu_notifier: cpu hotplug notifier.
  * @wq: The workqueue in use.
  * @pd: The internal control structure.
- * @cpumask: User supplied cpumask.
+ * @cpumask: User supplied cpumask. Contains two cpumasks: pcpu and
+ *           cbcpu for parallel and serial works.
  * @lock: padata instance lock.
  * @flags: padata flags.
  */
@@ -121,23 +140,35 @@ struct padata_instance {
 	struct notifier_block   cpu_notifier;
 	struct workqueue_struct *wq;
 	struct parallel_data	*pd;
-	cpumask_var_t           cpumask;
+	struct {
+		cpumask_var_t        pcpu;
+		cpumask_var_t        cbcpu;
+	} cpumask;
 	struct mutex		lock;
 	u8			flags;
 #define	PADATA_INIT		1
 #define	PADATA_RESET		2
 };
 
-extern struct padata_instance *padata_alloc(const struct cpumask *cpumask,
-					    struct workqueue_struct *wq);
+extern struct padata_instance *padata_alloc(struct workqueue_struct *wq);
+struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
+                                       const struct cpumask *pcpumask,
+                                       const struct cpumask *cbcpumask);
+extern int padata_cpu_hash(const struct cpumask *mask, int seq_nr);
+extern void padata_get_cb_cpumask(struct padata_instance *pinst,
+                                  struct cpumask *mask);
 extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
 			      struct padata_priv *padata, int cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
 extern int padata_set_cpumask(struct padata_instance *pinst,
+		          cpumask_var_t pcpumask, cpumask_var_t cbcpumask);
+extern int padata_set_serial_cpumask(struct padata_instance *pinst,
 			      cpumask_var_t cpumask);
-extern int padata_add_cpu(struct padata_instance *pinst, int cpu);
-extern int padata_remove_cpu(struct padata_instance *pinst, int cpu);
+extern int padata_set_parallel_cpumask(struct padata_instance *pinst,
+		          cpumask_var_t cpumask);
+extern int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
+extern int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 extern void padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index ff8de1b..3936837 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -31,48 +31,74 @@
 #define MAX_SEQ_NR (INT_MAX - NR_CPUS)
 #define MAX_OBJ_NUM 1000
 
-static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
+static int padata_index_to_cpu(const struct cpumask *mask, int cpu_index)
 {
 	int cpu, target_cpu;
 
-	target_cpu = cpumask_first(pd->cpumask);
+	target_cpu = cpumask_first(mask);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-		target_cpu = cpumask_next(target_cpu, pd->cpumask);
+		target_cpu = cpumask_next(target_cpu, mask);
 
 	return target_cpu;
 }
 
-static int padata_cpu_hash(struct padata_priv *padata)
+/**
+ * padata_cpu_hash: Select cpu from cpumask @mask using simple
+ *                         hash function by integer @seq_nr.
+ *
+ * @mask: A pointer to cpumask that will be used for cpu selection.
+ * @seq_nr: An integer to hash.
+ */
+int padata_cpu_hash(const struct cpumask *mask, int seq_nr)
 {
 	int cpu_index;
-	struct parallel_data *pd;
 
-	pd =  padata->pd;
 
 	/*
 	 * Hash the sequence numbers to the cpus by taking
 	 * seq_nr mod. number of cpus in use.
 	 */
-	cpu_index =  padata->seq_nr % cpumask_weight(pd->cpumask);
+	cpu_index =  seq_nr % cpumask_weight(mask);
 
-	return padata_index_to_cpu(pd, cpu_index);
+	return padata_index_to_cpu(mask, cpu_index);
 }
+EXPORT_SYMBOL(padata_cpu_hash);
 
-static void padata_parallel_worker(struct work_struct *work)
+/**
+ * padata_get_cb_cpumask: Fetch cpumask containing cpus that may be used for
+ *                        serialization callback from parallel data and copy it
+ *                        into the @mask.
+ *
+ * @pinst: A pointer to padata instance
+ * @mask: A pointer to cpumask structure where
+ *        cpumask for callbacks will be copied.
+ */
+void padata_get_cb_cpumask(struct padata_instance *pinst, struct cpumask *mask)
 {
-	struct padata_queue *queue;
+	struct parallel_data *pd;
+
+	rcu_read_lock_bh();
+	pd = rcu_dereference(pinst->pd);
+	cpumask_copy(mask, pd->cpumask.cbcpu);
+	rcu_read_unlock_bh();
+}
+EXPORT_SYMBOL(padata_get_cb_cpumask);
+
+static void padata_parallel_worker(struct work_struct *parallel_work)
+{
+	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
 	struct padata_instance *pinst;
 	LIST_HEAD(local_list);
 
 	local_bh_disable();
-	queue = container_of(work, struct padata_queue, pwork);
-	pd = queue->pd;
+	pqueue = container_of(parallel_work, struct padata_parallel_queue, work);
+	pd = pqueue->pd;
 	pinst = pd->pinst;
 
-	spin_lock(&queue->parallel.lock);
-	list_replace_init(&queue->parallel.list, &local_list);
-	spin_unlock(&queue->parallel.lock);
+	spin_lock(&pqueue->parallel.lock);
+	list_replace_init(&pqueue->parallel.list, &local_list);
+	spin_unlock(&pqueue->parallel.lock);
 
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
@@ -93,18 +119,18 @@ static void padata_parallel_worker(struct work_struct *work)
  *
  * @pinst: padata instance
  * @padata: object to be parallelized
- * @cb_cpu: cpu the serialization callback function will run on,
- *          must be in the cpumask of padata.
+ * @cb_cpu: cpu the serialization callback function will run on.
+ *          NOTE: @cb_cpu *must* be in serial cpumask(i.e. pinst->cpumask.cbcpu)
  *
  * The parallelization callback function will run with BHs off.
  * Note: Every object which is parallelized by padata_do_parallel
  * must be seen by padata_do_serial.
  */
 int padata_do_parallel(struct padata_instance *pinst,
-		       struct padata_priv *padata, int cb_cpu)
+                       struct padata_priv *padata, int cb_cpu)
 {
 	int target_cpu, err;
-	struct padata_queue *queue;
+	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
 
 	rcu_read_lock_bh();
@@ -123,27 +149,27 @@ int padata_do_parallel(struct padata_instance *pinst,
 		goto out;
 
 	err = -EINVAL;
-	if (!cpumask_test_cpu(cb_cpu, pd->cpumask))
+	if (!cpumask_test_cpu(cb_cpu, pd->cpumask.cbcpu))
 		goto out;
 
 	err = -EINPROGRESS;
 	atomic_inc(&pd->refcnt);
 	padata->pd = pd;
-	padata->cb_cpu = cb_cpu;
 
 	if (unlikely(atomic_read(&pd->seq_nr) == pd->max_seq_nr))
 		atomic_set(&pd->seq_nr, -1);
 
+	padata->cb_cpu = cb_cpu;
 	padata->seq_nr = atomic_inc_return(&pd->seq_nr);
 
-	target_cpu = padata_cpu_hash(padata);
-	queue = per_cpu_ptr(pd->queue, target_cpu);
+	target_cpu = padata_cpu_hash(pd->cpumask.pcpu, padata->seq_nr);
+	pqueue = per_cpu_ptr(pd->pqueue, target_cpu);
 
-	spin_lock(&queue->parallel.lock);
-	list_add_tail(&padata->list, &queue->parallel.list);
-	spin_unlock(&queue->parallel.lock);
+	spin_lock(&pqueue->parallel.lock);
+	list_add_tail(&padata->list, &pqueue->parallel.list);
+	spin_unlock(&pqueue->parallel.lock);
 
-	queue_work_on(target_cpu, pinst->wq, &queue->pwork);
+	queue_work_on(target_cpu, pinst->wq, &pqueue->work);
 
 out:
 	rcu_read_unlock_bh();
@@ -173,7 +199,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
 	int cpu, num_cpus, empty, calc_seq_nr;
 	int seq_nr, next_nr, overrun, next_overrun;
-	struct padata_queue *queue, *next_queue;
+	struct padata_parallel_queue *queue, *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
 
@@ -182,10 +208,10 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 	next_overrun = 0;
 	next_queue = NULL;
 
-	num_cpus = cpumask_weight(pd->cpumask);
+	num_cpus = cpumask_weight(pd->cpumask.pcpu);
 
-	for_each_cpu(cpu, pd->cpumask) {
-		queue = per_cpu_ptr(pd->queue, cpu);
+	for_each_cpu(cpu, pd->cpumask.pcpu) {
+		queue = per_cpu_ptr(pd->pqueue, cpu);
 		reorder = &queue->reorder;
 
 		/*
@@ -232,8 +258,8 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 				    struct padata_priv, list);
 
 		if (unlikely(next_overrun)) {
-			for_each_cpu(cpu, pd->cpumask) {
-				queue = per_cpu_ptr(pd->queue, cpu);
+			for_each_cpu(cpu, pd->cpumask.pcpu) {
+				queue = per_cpu_ptr(pd->pqueue, cpu);
 				atomic_set(&queue->num_obj, 0);
 			}
 		}
@@ -248,7 +274,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	queue = per_cpu_ptr(pd->queue, smp_processor_id());
+	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
 	if (queue->cpu_index == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
@@ -262,7 +288,7 @@ out:
 static void padata_reorder(struct parallel_data *pd)
 {
 	struct padata_priv *padata;
-	struct padata_queue *queue;
+	struct padata_serial_queue *squeue;
 	struct padata_instance *pinst = pd->pinst;
 
 	/*
@@ -301,22 +327,22 @@ static void padata_reorder(struct parallel_data *pd)
 			return;
 		}
 
-		queue = per_cpu_ptr(pd->queue, padata->cb_cpu);
+		squeue = per_cpu_ptr(pd->squeue, padata->cb_cpu);
 
-		spin_lock(&queue->serial.lock);
-		list_add_tail(&padata->list, &queue->serial.list);
-		spin_unlock(&queue->serial.lock);
+		spin_lock(&squeue->serial.lock);
+		list_add_tail(&padata->list, &squeue->serial.list);
+		spin_unlock(&squeue->serial.lock);
 
-		queue_work_on(padata->cb_cpu, pinst->wq, &queue->swork);
+		queue_work_on(padata->cb_cpu, pinst->wq, &squeue->work);
 	}
 
 	spin_unlock_bh(&pd->lock);
 
 	/*
-	 * The next object that needs serialization might have arrived to
-	 * the reorder queues in the meantime, we will be called again
-	 * from the timer function if noone else cares for it.
-	 */
+     * The next object that needs serialization might have arrived to
+     * the reorder queues in the meantime, we will be called again
+     * from the timer function if noone else cares for it.
+     */
 	if (atomic_read(&pd->reorder_objects)
 			&& !(pinst->flags & PADATA_RESET))
 		mod_timer(&pd->timer, jiffies + HZ);
@@ -333,25 +359,25 @@ static void padata_reorder_timer(unsigned long arg)
 	padata_reorder(pd);
 }
 
-static void padata_serial_worker(struct work_struct *work)
+static void padata_serial_worker(struct work_struct *serial_work)
 {
-	struct padata_queue *queue;
+	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
 	LIST_HEAD(local_list);
 
 	local_bh_disable();
-	queue = container_of(work, struct padata_queue, swork);
-	pd = queue->pd;
+	squeue = container_of(serial_work, struct padata_serial_queue, work);
+	pd = squeue->pd;
 
-	spin_lock(&queue->serial.lock);
-	list_replace_init(&queue->serial.list, &local_list);
-	spin_unlock(&queue->serial.lock);
+	spin_lock(&squeue->serial.lock);
+	list_replace_init(&squeue->serial.list, &local_list);
+	spin_unlock(&squeue->serial.lock);
 
 	while (!list_empty(&local_list)) {
 		struct padata_priv *padata;
 
 		padata = list_entry(local_list.next,
-				    struct padata_priv, list);
+                            struct padata_priv, list);
 
 		list_del_init(&padata->list);
 
@@ -372,13 +398,13 @@ static void padata_serial_worker(struct work_struct *work)
 void padata_do_serial(struct padata_priv *padata)
 {
 	int cpu;
-	struct padata_queue *queue;
+	struct padata_parallel_queue *queue;
 	struct parallel_data *pd;
 
 	pd = padata->pd;
 
 	cpu = get_cpu();
-	queue = per_cpu_ptr(pd->queue, cpu);
+	queue = per_cpu_ptr(pd->pqueue, cpu);
 
 	spin_lock(&queue->reorder.lock);
 	atomic_inc(&pd->reorder_objects);
@@ -391,51 +417,88 @@ void padata_do_serial(struct padata_priv *padata)
 }
 EXPORT_SYMBOL(padata_do_serial);
 
-/* Allocate and initialize the internal cpumask dependend resources. */
-static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
-					     const struct cpumask *cpumask)
+static int padata_setup_cpumasks(struct parallel_data *pd,
+                                 const struct cpumask *pcpumask,
+                                 const struct cpumask *cbcpumask)
 {
-	int cpu, cpu_index, num_cpus;
-	struct padata_queue *queue;
-	struct parallel_data *pd;
-
-	cpu_index = 0;
+	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
+		return -ENOMEM;
 
-	pd = kzalloc(sizeof(struct parallel_data), GFP_KERNEL);
-	if (!pd)
-		goto err;
+	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_active_mask);
+	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL)) {
+		free_cpumask_var(pd->cpumask.pcpu);
+		return -ENOMEM;
+	}
 
-	pd->queue = alloc_percpu(struct padata_queue);
-	if (!pd->queue)
-		goto err_free_pd;
+	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_active_mask);
+	return 0;
+}
 
-	if (!alloc_cpumask_var(&pd->cpumask, GFP_KERNEL))
-		goto err_free_queue;
+static void __padata_list_init(struct padata_list *pd_list)
+{
+	INIT_LIST_HEAD(&pd_list->list);
+	spin_lock_init(&pd_list->lock);
+}
 
-	cpumask_and(pd->cpumask, cpumask, cpu_active_mask);
+/* Initialize all percpu queues used by serial workers */
+static void padata_init_squeues(struct parallel_data *pd)
+{
+	int cpu;
+	struct padata_serial_queue *squeue;
 
-	for_each_cpu(cpu, pd->cpumask) {
-		queue = per_cpu_ptr(pd->queue, cpu);
+	for_each_cpu(cpu, pd->cpumask.cbcpu) {
+		squeue = per_cpu_ptr(pd->squeue, cpu);
+		squeue->pd = pd;
+		__padata_list_init(&squeue->serial);
+		INIT_WORK(&squeue->work, padata_serial_worker);
+	}
+}
 
-		queue->pd = pd;
+/* Initialize all percpu queues used by parallel workers */
+static void padata_init_pqueues(struct parallel_data *pd)
+{
+	int cpu_index, num_cpus, cpu;
+	struct padata_parallel_queue *pqueue;
 
-		queue->cpu_index = cpu_index;
+	cpu_index = 0;
+	for_each_cpu(cpu, pd->cpumask.pcpu) {
+		pqueue = per_cpu_ptr(pd->pqueue, cpu);
+		pqueue->pd = pd;
+		pqueue->cpu_index = cpu_index;
 		cpu_index++;
-
-		INIT_LIST_HEAD(&queue->reorder.list);
-		INIT_LIST_HEAD(&queue->parallel.list);
-		INIT_LIST_HEAD(&queue->serial.list);
-		spin_lock_init(&queue->reorder.lock);
-		spin_lock_init(&queue->parallel.lock);
-		spin_lock_init(&queue->serial.lock);
-
-		INIT_WORK(&queue->pwork, padata_parallel_worker);
-		INIT_WORK(&queue->swork, padata_serial_worker);
-		atomic_set(&queue->num_obj, 0);
+		__padata_list_init(&pqueue->reorder);
+		__padata_list_init(&pqueue->parallel);
+		INIT_WORK(&pqueue->work, padata_parallel_worker);
+		atomic_set(&pqueue->num_obj, 0);
 	}
 
-	num_cpus = cpumask_weight(pd->cpumask);
+	num_cpus = cpumask_weight(pd->cpumask.pcpu);
 	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
+}
+
+/* Allocate and initialize the internal cpumask dependend resources. */
+static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
+                                             const struct cpumask *pcpumask,
+                                             const struct cpumask *cbcpumask)
+{
+	struct parallel_data *pd;
+
+	pd = kzalloc(sizeof(struct parallel_data), GFP_KERNEL);
+	if (!pd)
+		goto err;
+
+	pd->pqueue = alloc_percpu(struct padata_parallel_queue);
+	if (!pd->pqueue)
+		goto err_free_pd;
+
+	pd->squeue = alloc_percpu(struct padata_serial_queue);
+	if (!pd->squeue)
+		goto err_free_pqueue;
+	if (padata_setup_cpumasks(pd, pcpumask, cbcpumask))
+		goto err_free_squeue;
+
+	padata_init_pqueues(pd);
+	padata_init_squeues(pd);
 
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
@@ -446,8 +509,10 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 
 	return pd;
 
-err_free_queue:
-	free_percpu(pd->queue);
+err_free_squeue:
+	free_percpu(pd->squeue);
+err_free_pqueue:
+	free_percpu(pd->pqueue);
 err_free_pd:
 	kfree(pd);
 err:
@@ -456,8 +521,10 @@ err:
 
 static void padata_free_pd(struct parallel_data *pd)
 {
-	free_cpumask_var(pd->cpumask);
-	free_percpu(pd->queue);
+	free_cpumask_var(pd->cpumask.pcpu);
+	free_cpumask_var(pd->cpumask.cbcpu);
+	free_percpu(pd->pqueue);
+	free_percpu(pd->squeue);
 	kfree(pd);
 }
 
@@ -465,11 +532,12 @@ static void padata_free_pd(struct parallel_data *pd)
 static void padata_flush_queues(struct parallel_data *pd)
 {
 	int cpu;
-	struct padata_queue *queue;
+	struct padata_parallel_queue *pqueue;
+	struct padata_serial_queue *squeue;
 
-	for_each_cpu(cpu, pd->cpumask) {
-		queue = per_cpu_ptr(pd->queue, cpu);
-		flush_work(&queue->pwork);
+	for_each_cpu(cpu, pd->cpumask.pcpu) {
+		pqueue = per_cpu_ptr(pd->pqueue, cpu);
+		flush_work(&pqueue->work);
 	}
 
 	del_timer_sync(&pd->timer);
@@ -477,9 +545,9 @@ static void padata_flush_queues(struct parallel_data *pd)
 	if (atomic_read(&pd->reorder_objects))
 		padata_reorder(pd);
 
-	for_each_cpu(cpu, pd->cpumask) {
-		queue = per_cpu_ptr(pd->queue, cpu);
-		flush_work(&queue->swork);
+	for_each_cpu(cpu, pd->cpumask.cbcpu) {
+		squeue = per_cpu_ptr(pd->squeue, cpu);
+		flush_work(&squeue->work);
 	}
 
 	BUG_ON(atomic_read(&pd->refcnt) != 0);
@@ -487,7 +555,7 @@ static void padata_flush_queues(struct parallel_data *pd)
 
 /* Replace the internal control stucture with a new one. */
 static void padata_replace(struct padata_instance *pinst,
-			   struct parallel_data *pd_new)
+                           struct parallel_data *pd_new)
 {
 	struct parallel_data *pd_old = pinst->pd;
 
@@ -504,13 +572,15 @@ static void padata_replace(struct padata_instance *pinst,
 }
 
 /**
- * padata_set_cpumask - set the cpumask that padata should use
+ * padata_set_cpumask - set the cpumask that both padata serial and
+ *                      parallel workers should use.
  *
  * @pinst: padata instance
- * @cpumask: the cpumask to use
+ * @pcpumask: the cpumask to use for parallel workers
+ * @cbcpumask: the cpumsak to use for serial workers
  */
 int padata_set_cpumask(struct padata_instance *pinst,
-			cpumask_var_t cpumask)
+			cpumask_var_t pcpumask, cpumask_var_t cbcpumask)
 {
 	struct parallel_data *pd;
 	int err = 0;
@@ -519,13 +589,14 @@ int padata_set_cpumask(struct padata_instance *pinst,
 
 	get_online_cpus();
 
-	pd = padata_alloc_pd(pinst, cpumask);
+	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
 	if (!pd) {
 		err = -ENOMEM;
 		goto out;
 	}
 
-	cpumask_copy(pinst->cpumask, cpumask);
+	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
+	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
 	padata_replace(pinst, pd);
 
@@ -538,35 +609,75 @@ out:
 }
 EXPORT_SYMBOL(padata_set_cpumask);
 
+/**
+ * padata_set_parallel_cpumask - set the cpumask that will be used by
+ *                               padata parallel workers.
+ *
+ * @pinst: padata instance
+ * @cpumask: the cpumask to use for parallel workers
+ */
+int padata_set_parallel_cpumask(struct padata_instance *pinst,
+		cpumask_var_t cpumask)
+{
+	return padata_set_cpumask(pinst, cpumask, pinst->cpumask.cbcpu);
+}
+EXPORT_SYMBOL(padata_set_parallel_cpumask);
+
+/**
+ * padata_set_serial_cpumask - set the cpumask that will be used by
+ *                             padata serial workers.
+ *
+ * @pinst: padata instance
+ * @cpumask: the cpumask to use for serial workers;
+ */
+int padata_set_serial_cpumask(struct padata_instance *pinst,
+		cpumask_var_t cpumask)
+{
+	return padata_set_cpumask(pinst, pinst->cpumask.pcpu, cpumask);
+}
+EXPORT_SYMBOL(padata_set_serial_cpumask);
+
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
-	struct parallel_data *pd;
+	struct parallel_data *pd = NULL;
 
 	if (cpumask_test_cpu(cpu, cpu_active_mask)) {
-		pd = padata_alloc_pd(pinst, pinst->cpumask);
+		pd = padata_alloc_pd(pinst,
+				pinst->cpumask.pcpu, pinst->cpumask.cbcpu);
 		if (!pd)
 			return -ENOMEM;
-
-		padata_replace(pinst, pd);
 	}
 
+	padata_replace(pinst, pd);
 	return 0;
 }
 
 /**
- * padata_add_cpu - add a cpu to the padata cpumask
+ * padata_add_cpu - add a cpu to one or both(parallel and serial)
+ *                  padata cpumasks.
  *
  * @pinst: padata instance
  * @cpu: cpu to add
+ * @mask: bitmask of flags specifying to which cpumask @cpu shuld be added.
+ *        The @mask may be any combination of the following flags:
+ *          PADATA_CPU_SERIAL   - serial cpumask
+ *          PADATA_CPU_PARALLEL - parallel cpumask
  */
-int padata_add_cpu(struct padata_instance *pinst, int cpu)
+int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask)
 {
-	int err;
+	int err = 0;
+
+	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
+		return -EINVAL;
 
 	mutex_lock(&pinst->lock);
 
 	get_online_cpus();
-	cpumask_set_cpu(cpu, pinst->cpumask);
+	if (mask & PADATA_CPU_SERIAL)
+		cpumask_set_cpu(cpu, pinst->cpumask.pcpu);
+	if (mask & PADATA_CPU_PARALLEL)
+		cpumask_set_cpu(cpu, pinst->cpumask.cbcpu);
+
 	err = __padata_add_cpu(pinst, cpu);
 	put_online_cpus();
 
@@ -581,7 +692,8 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 	struct parallel_data *pd;
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
-		pd = padata_alloc_pd(pinst, pinst->cpumask);
+		pd = padata_alloc_pd(pinst,
+				pinst->cpumask.pcpu, pinst->cpumask.cbcpu);
 		if (!pd)
 			return -ENOMEM;
 
@@ -592,19 +704,31 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 }
 
 /**
- * padata_remove_cpu - remove a cpu from the padata cpumask
+ * padata_remove_cpu - remove a cpu from the one or both(serial and paralell)
+ *                     padata cpumasks.
  *
  * @pinst: padata instance
  * @cpu: cpu to remove
+ * @mask: bitmask specifying from which cpumask @cpu should be removed
+ *        The @mask may be any combination of the following flags:
+ *          PADATA_CPU_SERIAL   - serial cpumask
+ *          PADATA_CPU_PARALLEL - parallel cpumask
  */
-int padata_remove_cpu(struct padata_instance *pinst, int cpu)
+int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask)
 {
 	int err;
 
+	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
+		return -EINVAL;
+
 	mutex_lock(&pinst->lock);
 
 	get_online_cpus();
-	cpumask_clear_cpu(cpu, pinst->cpumask);
+	if (mask & PADATA_CPU_SERIAL)
+		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
+	if (mask & PADATA_CPU_PARALLEL)
+		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
+
 	err = __padata_remove_cpu(pinst, cpu);
 	put_online_cpus();
 
@@ -641,8 +765,14 @@ void padata_stop(struct padata_instance *pinst)
 EXPORT_SYMBOL(padata_stop);
 
 #ifdef CONFIG_HOTPLUG_CPU
+static inline int pinst_have_cpu(struct padata_instance *pinst, int cpu)
+{
+	return (cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
+			cpumask_test_cpu(cpu, pinst->cpumask.cbcpu));
+}
+
 static int padata_cpu_callback(struct notifier_block *nfb,
-			       unsigned long action, void *hcpu)
+                               unsigned long action, void *hcpu)
 {
 	int err;
 	struct padata_instance *pinst;
@@ -653,7 +783,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_have_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		err = __padata_add_cpu(pinst, cpu);
@@ -664,7 +794,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_have_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		err = __padata_remove_cpu(pinst, cpu);
@@ -675,7 +805,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_have_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		__padata_remove_cpu(pinst, cpu);
@@ -683,7 +813,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_have_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		__padata_add_cpu(pinst, cpu);
@@ -695,13 +825,16 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 #endif
 
 /**
- * padata_alloc - allocate and initialize a padata instance
+ * __padata_alloc - allocate and initialize a padata instance
+ *                  and specify cpumasks for serial and parallel workers.
  *
- * @cpumask: cpumask that padata uses for parallelization
  * @wq: workqueue to use for the allocated padata instance
+ * @pcpumask: cpumask that will be used for padata parallelization
+ * @cbcpumask: cpumask that will be used for padata serialization
  */
-struct padata_instance *padata_alloc(const struct cpumask *cpumask,
-				     struct workqueue_struct *wq)
+struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
+                                       const struct cpumask *pcpumask,
+                                       const struct cpumask *cbcpumask)
 {
 	struct padata_instance *pinst;
 	struct parallel_data *pd;
@@ -710,20 +843,25 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 	if (!pinst)
 		goto err;
 
-	get_online_cpus();
+   get_online_cpus();
 
-	pd = padata_alloc_pd(pinst, cpumask);
+	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
 	if (!pd)
 		goto err_free_inst;
 
-	if (!alloc_cpumask_var(&pinst->cpumask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
+		goto err_free_pd;
+	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
+		free_cpumask_var(pinst->cpumask.pcpu);
 		goto err_free_pd;
+	}
 
 	rcu_assign_pointer(pinst->pd, pd);
 
 	pinst->wq = wq;
 
-	cpumask_copy(pinst->cpumask, cpumask);
+	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
+	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
 	pinst->flags = 0;
 
@@ -747,6 +885,19 @@ err_free_inst:
 err:
 	return NULL;
 }
+EXPORT_SYMBOL(__padata_alloc);
+
+/**
+ * padata_alloc - Allocate and initialize padata instance.
+ *                Use default cpumask(cpu_possible_mask)
+ *                for serial and parallel workes.
+ *
+ * @wq: workqueue to use for the allocated padata instance
+ */
+struct padata_instance *padata_alloc(struct workqueue_struct *wq)
+{
+	return __padata_alloc(wq, cpu_possible_mask, cpu_possible_mask);
+}
 EXPORT_SYMBOL(padata_alloc);
 
 /**
@@ -768,7 +919,8 @@ void padata_free(struct padata_instance *pinst)
 	put_online_cpus();
 
 	padata_free_pd(pinst->pd);
-	free_cpumask_var(pinst->cpumask);
+	free_cpumask_var(pinst->cpumask.pcpu);
+	free_cpumask_var(pinst->cpumask.cbcpu);
 	kfree(pinst);
 }
 EXPORT_SYMBOL(padata_free);


-- 
W.B.R.
Dan Kruchinin
