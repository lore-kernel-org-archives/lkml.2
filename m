Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0GNKcJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:32:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53681 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab0GNKcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:32:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=OWx766V4xO2Eh6pvzlSVdnx762vq7SmCR1FuoiYpyQDXDcYr6UK+e/dIzIxNu0K7Qt
         4LfhKfmNT61/kEwb5kE6Q10oiZCYC/HQgZ4F1NasrHDIaG2y6c4viZnVW64bjf8on+ep
         6BjtyK1O8Ekd37AY/Ewf+lW+sO4uKx0bSz/fg=
Date: Wed, 14 Jul 2010 14:31:57 +0400
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] The aim of this patch is to make two separate cpumasks
Message-ID: <20100714143157.467684dd@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim of this patch is to make two separate cpumasks
for padata parallel and serial workers respectively.
It allows user to make more thin and sophisticated configurations
of padata framework. For example user may bind parallel and serial workers to non-intersecting
CPU groups to gain better performance. Also each padata instance has notifiers chain for its
cpumasks now. If either parallel or serial or both masks were changed all
interested subsystems will get notification about that. It's especially useful
if padata user uses algorithm for callback CPU selection according to serial cpumask.


Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
---
 crypto/pcrypt.c        |  191 ++++++++++++++------
 include/linux/padata.h |  116 ++++++++----
 kernel/padata.c        |  471 +++++++++++++++++++++++++++++++++++-------------
 3 files changed, 564 insertions(+), 214 deletions(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 6036b6d..c9662e2 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -24,12 +24,38 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/notifier.h>
 #include <crypto/pcrypt.h>
 
-static struct padata_instance *pcrypt_enc_padata;
-static struct padata_instance *pcrypt_dec_padata;
-static struct workqueue_struct *encwq;
-static struct workqueue_struct *decwq;
+struct pcrypt_instance {
+	struct padata_instance *pinst;
+	struct workqueue_struct *wq;
+
+	/*
+	 * Cpumask for callback CPUs. It should be
+	 * equal to serial cpumask of corresponding padata instance,
+	 * so it is updated when padata notifies us about serial
+	 * cpumask change.
+	 *
+	 * cb_cpumask is protected by RCU. This fact prevents us from
+	 * using cpumask_var_t directly because the actual type of
+	 * cpumsak_var_t depends on kernel configuration(particularly on
+	 * CONFIG_CPUMASK_OFFSTACK macro). Depending on the configuration
+	 * cpumask_var_t may be either a pointer to the struct cpumask
+	 * or a variable allocated on the stack. Thus we can not safely use
+	 * cpumask_var_t with RCU operations such as rcu_assign_pointer or
+	 * rcu_dereference. So cpumask_var_t is wrapped with struct
+	 * pcrypt_cpumask which makes possible to use it with RCU.
+	 */
+	struct pcrypt_cpumask {
+		cpumask_var_t mask;
+	} *cb_cpumask;
+	struct notifier_block nblock;
+};
+
+static struct pcrypt_instance pencrypt;
+static struct pcrypt_instance pdecrypt;
+
 
 struct pcrypt_instance_ctx {
 	struct crypto_spawn spawn;
@@ -42,25 +68,29 @@ struct pcrypt_aead_ctx {
 };
 
 static int pcrypt_do_parallel(struct padata_priv *padata, unsigned int *cb_cpu,
-			      struct padata_instance *pinst)
+			      struct pcrypt_instance *pcrypt)
 {
 	unsigned int cpu_index, cpu, i;
+	struct pcrypt_cpumask *cpumask;
 
 	cpu = *cb_cpu;
 
-	if (cpumask_test_cpu(cpu, cpu_active_mask))
+	rcu_read_lock_bh();
+	cpumask = rcu_dereference(pcrypt->cb_cpumask);
+	if (cpumask_test_cpu(cpu, cpumask->mask))
 			goto out;
 
-	cpu_index = cpu % cpumask_weight(cpu_active_mask);
+	cpu_index = cpu % cpumask_weight(cpumask->mask);
 
-	cpu = cpumask_first(cpu_active_mask);
+	cpu = cpumask_first(cpumask->mask);
 	for (i = 0; i < cpu_index; i++)
-		cpu = cpumask_next(cpu, cpu_active_mask);
+		cpu = cpumask_next(cpu, cpumask->mask);
 
 	*cb_cpu = cpu;
 
 out:
-	return padata_do_parallel(pinst, padata, cpu);
+	rcu_read_unlock_bh();
+	return padata_do_parallel(pcrypt->pinst, padata, cpu);
 }
 
 static int pcrypt_aead_setkey(struct crypto_aead *parent,
@@ -142,7 +172,7 @@ static int pcrypt_aead_encrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_assoc(creq, req->assoc, req->assoclen);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
+	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -184,7 +214,7 @@ static int pcrypt_aead_decrypt(struct aead_request *req)
 			       req->cryptlen, req->iv);
 	aead_request_set_assoc(creq, req->assoc, req->assoclen);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_dec_padata);
+	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pdecrypt);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -228,7 +258,7 @@ static int pcrypt_aead_givencrypt(struct aead_givcrypt_request *req)
 	aead_givcrypt_set_assoc(creq, areq->assoc, areq->assoclen);
 	aead_givcrypt_set_giv(creq, req->giv, req->seq);
 
-	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, pcrypt_enc_padata);
+	err = pcrypt_do_parallel(padata, &ctx->cb_cpu, &pencrypt);
 	if (!err)
 		return -EINPROGRESS;
 
@@ -370,6 +400,88 @@ static void pcrypt_free(struct crypto_instance *inst)
 	kfree(inst);
 }
 
+static int pcrypt_cpumask_change_notify(struct notifier_block *self,
+					unsigned long val, void *data)
+{
+	struct pcrypt_instance *pcrypt;
+	struct pcrypt_cpumask *new_mask, *old_mask;
+
+	if (!(val & PADATA_CPU_SERIAL))
+		return 0;
+
+	pcrypt = container_of(self, struct pcrypt_instance, nblock);
+	new_mask = kmalloc(sizeof(*new_mask), GFP_KERNEL);
+	if (!new_mask)
+		return -ENOMEM;
+	if (!alloc_cpumask_var(&new_mask->mask, GFP_KERNEL)) {
+		kfree(new_mask);
+		return -ENOMEM;
+	}
+
+	old_mask = pcrypt->cb_cpumask;
+
+	padata_get_cpumask(pcrypt->pinst, PADATA_CPU_SERIAL, new_mask->mask);
+	rcu_assign_pointer(pcrypt->cb_cpumask, new_mask);
+	synchronize_rcu_bh();
+
+	free_cpumask_var(old_mask->mask);
+	kfree(old_mask);
+	return 0;
+}
+
+static int __pcrypt_init_instance(struct pcrypt_instance *pcrypt,
+				  const char *name)
+{
+	int ret = -ENOMEM;
+	struct pcrypt_cpumask *mask;
+
+	pcrypt->wq = create_workqueue(name);
+	if (!pcrypt->wq)
+		goto err;
+
+	pcrypt->pinst = padata_alloc(pcrypt->wq);
+	if (!pcrypt->pinst)
+		goto err_destroy_workqueue;
+
+	mask = kmalloc(sizeof(*mask), GFP_KERNEL);
+	if (!mask)
+		goto err_free_padata;
+	if (!alloc_cpumask_var(&mask->mask, GFP_KERNEL)) {
+		kfree(mask);
+		goto err_free_padata;
+	}
+
+	padata_get_cpumask(pcrypt->pinst, PADATA_CPU_SERIAL, mask->mask);
+	rcu_assign_pointer(pcrypt->cb_cpumask, mask);
+
+	pcrypt->nblock.notifier_call = pcrypt_cpumask_change_notify;
+	ret = padata_register_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
+	if (ret)
+		goto err_free_cpumask;
+
+	return ret;
+err_free_cpumask:
+	free_cpumask_var(mask->mask);
+	kfree(mask);
+err_free_padata:
+	padata_free(pcrypt->pinst);
+err_destroy_workqueue:
+	destroy_workqueue(pcrypt->wq);
+err:
+	return ret;
+}
+
+static void __pcrypt_deinit_instance(struct pcrypt_instance *pcrypt)
+{
+	free_cpumask_var(pcrypt->cb_cpumask->mask);
+	kfree(pcrypt->cb_cpumask);
+
+	padata_stop(pcrypt->pinst);
+	padata_unregister_cpumask_notifier(pcrypt->pinst, &pcrypt->nblock);
+	destroy_workqueue(pcrypt->wq);
+	padata_free(pcrypt->pinst);
+}
+
 static struct crypto_template pcrypt_tmpl = {
 	.name = "pcrypt",
 	.alloc = pcrypt_alloc,
@@ -379,60 +491,31 @@ static struct crypto_template pcrypt_tmpl = {
 
 static int __init pcrypt_init(void)
 {
-	int err = -ENOMEM;
-	encwq = create_workqueue("pencrypt");
-	if (!encwq)
-		goto err;
-
-	decwq = create_workqueue("pdecrypt");
-	if (!decwq)
-		goto err_destroy_encwq;
-
-
-	pcrypt_enc_padata = padata_alloc(cpu_possible_mask, encwq);
-	if (!pcrypt_enc_padata)
-		goto err_destroy_decwq;
-
-	pcrypt_dec_padata = padata_alloc(cpu_possible_mask, decwq);
-	if (!pcrypt_dec_padata)
-		goto err_free_enc_padata;
+	int err;
 
-	err = padata_start(pcrypt_enc_padata);
+	err = __pcrypt_init_instance(&pencrypt, "pencrypt");
 	if (err)
-		goto err_free_dec_padata;
+		goto err;
 
-	err = padata_start(pcrypt_dec_padata);
+	err = __pcrypt_init_instance(&pdecrypt, "pdecrypt");
 	if (err)
-		goto err_free_dec_padata;
-
-	return crypto_register_template(&pcrypt_tmpl);
-
-err_free_dec_padata:
-	padata_free(pcrypt_dec_padata);
+		goto err_deinit_pencrypt;
 
-err_free_enc_padata:
-	padata_free(pcrypt_enc_padata);
+	padata_start(pencrypt.pinst);
+	padata_start(pdecrypt.pinst);
 
-err_destroy_decwq:
-	destroy_workqueue(decwq);
-
-err_destroy_encwq:
-	destroy_workqueue(encwq);
+	return crypto_register_template(&pcrypt_tmpl);
 
+err_deinit_pencrypt:
+	__pcrypt_deinit_instance(&pencrypt);
 err:
 	return err;
 }
 
 static void __exit pcrypt_exit(void)
 {
-	padata_stop(pcrypt_enc_padata);
-	padata_stop(pcrypt_dec_padata);
-
-	destroy_workqueue(encwq);
-	destroy_workqueue(decwq);
-
-	padata_free(pcrypt_enc_padata);
-	padata_free(pcrypt_dec_padata);
+	__pcrypt_deinit_instance(&pencrypt);
+	__pcrypt_deinit_instance(&pdecrypt);
 
 	crypto_unregister_template(&pcrypt_tmpl);
 }
diff --git a/include/linux/padata.h b/include/linux/padata.h
index 8844b85..621e773 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -25,6 +25,10 @@
 #include <linux/spinlock.h>
 #include <linux/list.h>
 #include <linux/timer.h>
+#include <linux/notifier.h>
+
+#define PADATA_CPU_SERIAL   0x01
+#define PADATA_CPU_PARALLEL 0x02
 
 /**
  * struct padata_priv -  Embedded to the users data structure.
@@ -59,7 +63,20 @@ struct padata_list {
 };
 
 /**
- * struct padata_queue - The percpu padata queues.
+* struct padata_serial_queue - The percpu padata serial queue
+*
+* @serial: List to wait for serialization after reordering.
+* @work: work struct for serialization.
+* @pd: Backpointer to the internal control structure.
+*/
+struct padata_serial_queue {
+       struct padata_list    serial;
+       struct work_struct    work;
+       struct parallel_data *pd;
+};
+
+/**
+ * struct padata_parallel_queue - The percpu padata parallel queue
  *
  * @parallel: List to wait for parallelization.
  * @reorder: List to wait for reordering after parallel processing.
@@ -67,44 +84,52 @@ struct padata_list {
  * @pwork: work struct for parallelization.
  * @swork: work struct for serialization.
  * @pd: Backpointer to the internal control structure.
+ * @work: work struct for parallelization.
+ * @num_obj: Number of objects that are processed by this cpu.
  * @cpu_index: Index of the cpu.
  */
-struct padata_queue {
-	struct padata_list	parallel;
-	struct padata_list	reorder;
-	struct padata_list	serial;
-	struct work_struct	pwork;
-	struct work_struct	swork;
-	struct parallel_data    *pd;
-	int			cpu_index;
+struct padata_parallel_queue {
+       struct padata_list    parallel;
+       struct padata_list    reorder;
+       struct parallel_data *pd;
+       struct work_struct    work;
+       atomic_t              num_obj;
+       int                   cpu_index;
 };
 
+
 /**
  * struct parallel_data - Internal control structure, covers everything
  * that depends on the cpumask in use.
  *
  * @pinst: padata instance.
- * @queue: percpu padata queues.
+ * @pqueue: percpu padata queues used for parallelization.
+ * @squeue: percpu padata queues used for serialuzation.
  * @seq_nr: The sequence number that will be attached to the next object.
  * @reorder_objects: Number of objects waiting in the reorder queues.
  * @refcnt: Number of objects holding a reference on this parallel_data.
  * @max_seq_nr:  Maximal used sequence number.
- * @cpumask: cpumask in use.
+ * @cpumask: Contains two cpumasks: pcpu and cbcpu for
+ *           parallel and serial workers respectively.
  * @lock: Reorder lock.
  * @processed: Number of already processed objects.
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
-	spinlock_t              lock ____cacheline_aligned;
-	unsigned int            processed;
-	struct timer_list       timer;
+	struct padata_instance		*pinst;
+	struct padata_parallel_queue	*pqueue;
+	struct padata_serial_queue	*squeue;
+	atomic_t			 seq_nr;
+	atomic_t			 reorder_objects;
+	atomic_t			 refcnt;
+	unsigned int			 max_seq_nr;
+	struct {
+		cpumask_var_t		 pcpu;
+		cpumask_var_t		 cbcpu;
+	} cpumask;
+	spinlock_t                       lock ____cacheline_aligned;
+	unsigned int			 processed;
+	struct timer_list		 timer;
 };
 
 /**
@@ -113,32 +138,51 @@ struct parallel_data {
  * @cpu_notifier: cpu hotplug notifier.
  * @wq: The workqueue in use.
  * @pd: The internal control structure.
- * @cpumask: User supplied cpumask.
+ * @cpumask: User supplied cpumask. Contains two cpumasks: pcpu and
+ *           cbcpu for parallel and serial works respectivly.
+ * @cpumask_change_notifier: Notifiers chain for user-defined notify
+ *            callbacks that will be called when either @pcpu or @cbcpu
+ *             or both cpumasks change.
  * @lock: padata instance lock.
  * @flags: padata flags.
  */
 struct padata_instance {
-	struct notifier_block   cpu_notifier;
-	struct workqueue_struct *wq;
-	struct parallel_data	*pd;
-	cpumask_var_t           cpumask;
-	struct mutex		lock;
-	u8			flags;
-#define	PADATA_INIT		1
-#define	PADATA_RESET		2
-#define	PADATA_INVALID		4
+	struct notifier_block		 cpu_notifier;
+	struct workqueue_struct		*wq;
+	struct parallel_data		*pd;
+	struct {
+		cpumask_var_t		 pcpu;
+		cpumask_var_t		 cbcpu;
+	} cpumask;
+	struct blocking_notifier_head	 cpumask_change_notifier;
+	struct mutex			 lock;
+	u8				 flags;
+#define	PADATA_INIT	1
+#define	PADATA_RESET	2
+#define	PADATA_INVALID	4
 };
 
-extern struct padata_instance *padata_alloc(const struct cpumask *cpumask,
-					    struct workqueue_struct *wq);
+extern struct padata_instance *padata_alloc(struct workqueue_struct *wq);
+extern struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
+					      const struct cpumask *pcpumask,
+					      const struct cpumask *cbcpumask);
 extern void padata_free(struct padata_instance *pinst);
 extern int padata_do_parallel(struct padata_instance *pinst,
 			      struct padata_priv *padata, int cb_cpu);
 extern void padata_do_serial(struct padata_priv *padata);
-extern int padata_set_cpumask(struct padata_instance *pinst,
+extern int padata_get_cpumask(struct padata_instance *pinst,
+			      int cpumask_type, struct cpumask *out_mask);
+extern int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
 			      cpumask_var_t cpumask);
-extern int padata_add_cpu(struct padata_instance *pinst, int cpu);
-extern int padata_remove_cpu(struct padata_instance *pinst, int cpu);
+extern int __padata_set_cpumasks(struct padata_instance *pinst,
+				 cpumask_var_t pcpumask,
+				 cpumask_var_t cbcpumask);
+extern int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask);
+extern int padata_remove_cpu(struct padata_instance *pinst, int cpu, int mask);
 extern int padata_start(struct padata_instance *pinst);
 extern void padata_stop(struct padata_instance *pinst);
+extern int padata_register_cpumask_notifier(struct padata_instance *pinst,
+					    struct notifier_block *nblock);
+extern int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
+					      struct notifier_block *nblock);
 #endif
diff --git a/kernel/padata.c b/kernel/padata.c
index 450d67d..84d0ca9 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -35,9 +35,9 @@ static int padata_index_to_cpu(struct parallel_data *pd, int cpu_index)
 {
 	int cpu, target_cpu;
 
-	target_cpu = cpumask_first(pd->cpumask);
+	target_cpu = cpumask_first(pd->cpumask.pcpu);
 	for (cpu = 0; cpu < cpu_index; cpu++)
-		target_cpu = cpumask_next(target_cpu, pd->cpumask);
+		target_cpu = cpumask_next(target_cpu, pd->cpumask.pcpu);
 
 	return target_cpu;
 }
@@ -53,26 +53,27 @@ static int padata_cpu_hash(struct padata_priv *padata)
 	 * Hash the sequence numbers to the cpus by taking
 	 * seq_nr mod. number of cpus in use.
 	 */
-	cpu_index =  padata->seq_nr % cpumask_weight(pd->cpumask);
+	cpu_index =  padata->seq_nr % cpumask_weight(pd->cpumask.pcpu);
 
 	return padata_index_to_cpu(pd, cpu_index);
 }
 
-static void padata_parallel_worker(struct work_struct *work)
+static void padata_parallel_worker(struct work_struct *parallel_work)
 {
-	struct padata_queue *queue;
+	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
 	struct padata_instance *pinst;
 	LIST_HEAD(local_list);
 
 	local_bh_disable();
-	queue = container_of(work, struct padata_queue, pwork);
-	pd = queue->pd;
+	pqueue = container_of(parallel_work,
+			      struct padata_parallel_queue, work);
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
@@ -94,7 +95,7 @@ static void padata_parallel_worker(struct work_struct *work)
  * @pinst: padata instance
  * @padata: object to be parallelized
  * @cb_cpu: cpu the serialization callback function will run on,
- *          must be in the cpumask of padata.
+ *          must be in the serial cpumask of padata(i.e. cpumask.cbcpu).
  *
  * The parallelization callback function will run with BHs off.
  * Note: Every object which is parallelized by padata_do_parallel
@@ -104,7 +105,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 		       struct padata_priv *padata, int cb_cpu)
 {
 	int target_cpu, err;
-	struct padata_queue *queue;
+	struct padata_parallel_queue *queue;
 	struct parallel_data *pd;
 
 	rcu_read_lock_bh();
@@ -115,7 +116,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	if (!(pinst->flags & PADATA_INIT))
 		goto out;
 
-	if (!cpumask_test_cpu(cb_cpu, pd->cpumask))
+	if (!cpumask_test_cpu(cb_cpu, pd->cpumask.cbcpu))
 		goto out;
 
 	err =  -EBUSY;
@@ -136,13 +137,13 @@ int padata_do_parallel(struct padata_instance *pinst,
 	padata->seq_nr = atomic_inc_return(&pd->seq_nr);
 
 	target_cpu = padata_cpu_hash(padata);
-	queue = per_cpu_ptr(pd->queue, target_cpu);
+	queue = per_cpu_ptr(pd->pqueue, target_cpu);
 
 	spin_lock(&queue->parallel.lock);
 	list_add_tail(&padata->list, &queue->parallel.list);
 	spin_unlock(&queue->parallel.lock);
 
-	queue_work_on(target_cpu, pinst->wq, &queue->pwork);
+	queue_work_on(target_cpu, pinst->wq, &queue->work);
 
 out:
 	rcu_read_unlock_bh();
@@ -172,11 +173,11 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 {
 	int cpu, num_cpus;
 	int next_nr, next_index;
-	struct padata_queue *queue, *next_queue;
+	struct padata_parallel_queue *queue, *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
 
-	num_cpus = cpumask_weight(pd->cpumask);
+	num_cpus = cpumask_weight(pd->cpumask.pcpu);
 
 	/*
 	 * Calculate the percpu reorder queue and the sequence
@@ -185,13 +186,13 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 	next_nr = pd->processed;
 	next_index = next_nr % num_cpus;
 	cpu = padata_index_to_cpu(pd, next_index);
-	next_queue = per_cpu_ptr(pd->queue, cpu);
+	next_queue = per_cpu_ptr(pd->pqueue, cpu);
 
 	if (unlikely(next_nr > pd->max_seq_nr)) {
 		next_nr = next_nr - pd->max_seq_nr - 1;
 		next_index = next_nr % num_cpus;
 		cpu = padata_index_to_cpu(pd, next_index);
-		next_queue = per_cpu_ptr(pd->queue, cpu);
+		next_queue = per_cpu_ptr(pd->pqueue, cpu);
 		pd->processed = 0;
 	}
 
@@ -215,7 +216,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 		goto out;
 	}
 
-	queue = per_cpu_ptr(pd->queue, smp_processor_id());
+	queue = per_cpu_ptr(pd->pqueue, smp_processor_id());
 	if (queue->cpu_index == next_queue->cpu_index) {
 		padata = ERR_PTR(-ENODATA);
 		goto out;
@@ -229,7 +230,7 @@ out:
 static void padata_reorder(struct parallel_data *pd)
 {
 	struct padata_priv *padata;
-	struct padata_queue *queue;
+	struct padata_serial_queue *squeue;
 	struct padata_instance *pinst = pd->pinst;
 
 	/*
@@ -268,13 +269,13 @@ static void padata_reorder(struct parallel_data *pd)
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
@@ -300,19 +301,19 @@ static void padata_reorder_timer(unsigned long arg)
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
@@ -339,18 +340,18 @@ static void padata_serial_worker(struct work_struct *work)
 void padata_do_serial(struct padata_priv *padata)
 {
 	int cpu;
-	struct padata_queue *queue;
+	struct padata_parallel_queue *pqueue;
 	struct parallel_data *pd;
 
 	pd = padata->pd;
 
 	cpu = get_cpu();
-	queue = per_cpu_ptr(pd->queue, cpu);
+	pqueue = per_cpu_ptr(pd->pqueue, cpu);
 
-	spin_lock(&queue->reorder.lock);
+	spin_lock(&pqueue->reorder.lock);
 	atomic_inc(&pd->reorder_objects);
-	list_add_tail(&padata->list, &queue->reorder.list);
-	spin_unlock(&queue->reorder.lock);
+	list_add_tail(&padata->list, &pqueue->reorder.list);
+	spin_unlock(&pqueue->reorder.lock);
 
 	put_cpu();
 
@@ -358,51 +359,88 @@ void padata_do_serial(struct padata_priv *padata)
 }
 EXPORT_SYMBOL(padata_do_serial);
 
-/* Allocate and initialize the internal cpumask dependend resources. */
-static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
-					     const struct cpumask *cpumask)
+static int padata_setup_cpumasks(struct parallel_data *pd,
+				 const struct cpumask *pcpumask,
+				 const struct cpumask *cbcpumask)
 {
-	int cpu, cpu_index, num_cpus;
-	struct padata_queue *queue;
-	struct parallel_data *pd;
+	if (!alloc_cpumask_var(&pd->cpumask.pcpu, GFP_KERNEL))
+		return -ENOMEM;
 
-	cpu_index = 0;
+	cpumask_and(pd->cpumask.pcpu, pcpumask, cpu_active_mask);
+	if (!alloc_cpumask_var(&pd->cpumask.cbcpu, GFP_KERNEL)) {
+		free_cpumask_var(pd->cpumask.cbcpu);
+		return -ENOMEM;
+	}
 
-	pd = kzalloc(sizeof(struct parallel_data), GFP_KERNEL);
-	if (!pd)
-		goto err;
+	cpumask_and(pd->cpumask.cbcpu, cbcpumask, cpu_active_mask);
+	return 0;
+}
 
-	pd->queue = alloc_percpu(struct padata_queue);
-	if (!pd->queue)
-		goto err_free_pd;
+static void __padata_list_init(struct padata_list *pd_list)
+{
+	INIT_LIST_HEAD(&pd_list->list);
+	spin_lock_init(&pd_list->lock);
+}
 
-	if (!alloc_cpumask_var(&pd->cpumask, GFP_KERNEL))
-		goto err_free_queue;
+/* Initialize all percpu queues used by serial workers */
+static void padata_init_squeues(struct parallel_data *pd)
+{
+	int cpu;
+	struct padata_serial_queue *squeue;
 
-	cpumask_and(pd->cpumask, cpumask, cpu_active_mask);
+	for_each_cpu(cpu, pd->cpumask.cbcpu) {
+		squeue = per_cpu_ptr(pd->squeue, cpu);
+		squeue->pd = pd;
+		__padata_list_init(&squeue->serial);
+		INIT_WORK(&squeue->work, padata_serial_worker);
+	}
+}
 
-	for_each_cpu(cpu, pd->cpumask) {
-		queue = per_cpu_ptr(pd->queue, cpu);
+/* Initialize all percpu queues used by parallel workers */
+static void padata_init_pqueues(struct parallel_data *pd)
+{
+	int cpu_index, num_cpus, cpu;
+	struct padata_parallel_queue *pqueue;
 
-		queue->pd = pd;
+	cpu_index = 0;
+	for_each_cpu(cpu, pd->cpumask.pcpu) {
+		pqueue = per_cpu_ptr(pd->pqueue, cpu);
+		pqueue->pd = pd;
+		pqueue->cpu_index = cpu_index;
+
+		__padata_list_init(&pqueue->reorder);
+		__padata_list_init(&pqueue->parallel);
+		INIT_WORK(&pqueue->work, padata_parallel_worker);
+		atomic_set(&pqueue->num_obj, 0);
+	}
 
-		queue->cpu_index = cpu_index;
-		cpu_index++;
+	num_cpus = cpumask_weight(pd->cpumask.pcpu);
+	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
+}
 
-		INIT_LIST_HEAD(&queue->reorder.list);
-		INIT_LIST_HEAD(&queue->parallel.list);
-		INIT_LIST_HEAD(&queue->serial.list);
-		spin_lock_init(&queue->reorder.lock);
-		spin_lock_init(&queue->parallel.lock);
-		spin_lock_init(&queue->serial.lock);
+/* Allocate and initialize the internal cpumask dependend resources. */
+static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
+					     const struct cpumask *pcpumask,
+					     const struct cpumask *cbcpumask)
+{
+	struct parallel_data *pd;
 
-		INIT_WORK(&queue->pwork, padata_parallel_worker);
-		INIT_WORK(&queue->swork, padata_serial_worker);
-	}
+	pd = kzalloc(sizeof(struct parallel_data), GFP_KERNEL);
+	if (!pd)
+		goto err;
 
-	num_cpus = cpumask_weight(pd->cpumask);
-	pd->max_seq_nr = (MAX_SEQ_NR / num_cpus) * num_cpus - 1;
+	pd->pqueue = alloc_percpu(struct padata_parallel_queue);
+	if (!pd->pqueue)
+		goto err_free_pd;
+
+	pd->squeue = alloc_percpu(struct padata_serial_queue);
+	if (!pd->squeue)
+		goto err_free_pqueue;
+	if (padata_setup_cpumasks(pd, pcpumask, cbcpumask) < 0)
+		goto err_free_squeue;
 
+	padata_init_pqueues(pd);
+	padata_init_squeues(pd);
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
 	atomic_set(&pd->reorder_objects, 0);
@@ -412,8 +450,10 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 
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
@@ -422,8 +462,10 @@ err:
 
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
 
@@ -431,11 +473,12 @@ static void padata_free_pd(struct parallel_data *pd)
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
@@ -443,9 +486,9 @@ static void padata_flush_queues(struct parallel_data *pd)
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
@@ -475,21 +518,63 @@ static void padata_replace(struct padata_instance *pinst,
 			   struct parallel_data *pd_new)
 {
 	struct parallel_data *pd_old = pinst->pd;
+	int notification_mask = 0;
 
 	pinst->flags |= PADATA_RESET;
 
 	rcu_assign_pointer(pinst->pd, pd_new);
 
 	synchronize_rcu();
+	if (!pd_old)
+		goto out;
 
-	if (pd_old) {
-		padata_flush_queues(pd_old);
-		padata_free_pd(pd_old);
-	}
+	padata_flush_queues(pd_old);
+	if (!cpumask_equal(pd_old->cpumask.pcpu, pd_new->cpumask.pcpu))
+		notification_mask |= PADATA_CPU_PARALLEL;
+	if (!cpumask_equal(pd_old->cpumask.cbcpu, pd_new->cpumask.cbcpu))
+		notification_mask |= PADATA_CPU_SERIAL;
+
+	padata_free_pd(pd_old);
+	if (notification_mask)
+		blocking_notifier_call_chain(&pinst->cpumask_change_notifier,
+					     notification_mask, pinst);
 
+out:
 	pinst->flags &= ~PADATA_RESET;
 }
 
+/**
+ * padata_register_cpumask_notifier - Registers a notifier that will be called
+ *                             if either pcpu or cbcpu or both cpumasks change.
+ *
+ * @pinst: A poineter to padata instance
+ * @nblock: A pointer to notifier block.
+ */
+int padata_register_cpumask_notifier(struct padata_instance *pinst,
+				     struct notifier_block *nblock)
+{
+	return blocking_notifier_chain_register(&pinst->cpumask_change_notifier,
+						nblock);
+}
+EXPORT_SYMBOL(padata_register_cpumask_notifier);
+
+/**
+ * padata_unregister_cpumask_notifier - Unregisters cpumask notifier
+ *        registered earlier  using padata_register_cpumask_notifier
+ *
+ * @pinst: A pointer to data instance.
+ * @nlock: A pointer to notifier block.
+ */
+int padata_unregister_cpumask_notifier(struct padata_instance *pinst,
+				       struct notifier_block *nblock)
+{
+	return blocking_notifier_chain_unregister(
+		&pinst->cpumask_change_notifier,
+		nblock);
+}
+EXPORT_SYMBOL(padata_unregister_cpumask_notifier);
+
+
 /* If cpumask contains no active cpu, we mark the instance as invalid. */
 static bool padata_validate_cpumask(struct padata_instance *pinst,
 				    const struct cpumask *cpumask)
@@ -504,13 +589,82 @@ static bool padata_validate_cpumask(struct padata_instance *pinst,
 }
 
 /**
- * padata_set_cpumask - set the cpumask that padata should use
+ * padata_get_cpumask: Fetch serial or parallel cpumask from the
+ *                     given padata instance and copy it to @out_mask
+ *
+ * @pinst: A pointer to padata instance
+ * @cpumask_type: Specifies which cpumask will be copied.
+ *                Possible values are PADATA_CPU_SERIAL *or* PADATA_CPU_PARALLEL
+ *                corresponding to serial and parallel cpumask respectively.
+ * @out_mask: A pointer to cpumask structure where selected
+ *            cpumask will be copied.
+ */
+int padata_get_cpumask(struct padata_instance *pinst,
+		       int cpumask_type, struct cpumask *out_mask)
+{
+	struct parallel_data *pd;
+	int ret = 0;
+
+	rcu_read_lock_bh();
+	pd = rcu_dereference(pinst->pd);
+	switch (cpumask_type) {
+	case PADATA_CPU_SERIAL:
+		cpumask_copy(out_mask, pd->cpumask.cbcpu);
+		break;
+	case PADATA_CPU_PARALLEL:
+		cpumask_copy(out_mask, pd->cpumask.pcpu);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	rcu_read_unlock_bh();
+	return ret;
+}
+EXPORT_SYMBOL(padata_get_cpumask);
+
+/**
+ * padata_set_cpumask: Sets specified by @cpumask_type cpumask to the value
+ *                     equivalent to @cpumask.
  *
  * @pinst: padata instance
+ * @cpumask_type: PADATA_CPU_SERIAL or PADATA_CPU_PARALLEL corresponding
+ *                to parallel and serial cpumasks respectively.
  * @cpumask: the cpumask to use
  */
-int padata_set_cpumask(struct padata_instance *pinst,
-			cpumask_var_t cpumask)
+int padata_set_cpumask(struct padata_instance *pinst, int cpumask_type,
+		       cpumask_var_t cpumask)
+{
+	struct cpumask *serial_mask, *parallel_mask;
+
+	switch (cpumask_type) {
+	case PADATA_CPU_PARALLEL:
+		serial_mask = pinst->cpumask.cbcpu;
+		parallel_mask = cpumask;
+		break;
+	case PADATA_CPU_SERIAL:
+		parallel_mask = pinst->cpumask.pcpu;
+		serial_mask = cpumask;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return __padata_set_cpumasks(pinst, parallel_mask, serial_mask);
+}
+EXPORT_SYMBOL(padata_set_cpumask);
+
+/**
+ * __padata_set_cpumasks - Set both parallel and serial cpumasks. The first
+ *                         one is used by parallel workers and the second one
+ *                         by the wokers doing serialization.
+ *
+ * @pinst: padata instance
+ * @pcpumask: the cpumask to use for parallel workers
+ * @cbcpumask: the cpumsak to use for serial workers
+ */
+int __padata_set_cpumasks(struct padata_instance *pinst,
+			  cpumask_var_t pcpumask, cpumask_var_t cbcpumask)
 {
 	int valid;
 	int err = 0;
@@ -518,7 +672,13 @@ int padata_set_cpumask(struct padata_instance *pinst,
 
 	mutex_lock(&pinst->lock);
 
-	valid = padata_validate_cpumask(pinst, cpumask);
+	valid = padata_validate_cpumask(pinst, pcpumask);
+	if (!valid) {
+		__padata_stop(pinst);
+		goto out_replace;
+	}
+
+	valid = padata_validate_cpumask(pinst, cbcpumask);
 	if (!valid) {
 		__padata_stop(pinst);
 		goto out_replace;
@@ -526,14 +686,15 @@ int padata_set_cpumask(struct padata_instance *pinst,
 
 	get_online_cpus();
 
-	pd = padata_alloc_pd(pinst, cpumask);
+	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
 	if (!pd) {
 		err = -ENOMEM;
 		goto out;
 	}
 
 out_replace:
-	cpumask_copy(pinst->cpumask, cpumask);
+	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
+	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
 	padata_replace(pinst, pd);
 
@@ -546,41 +707,57 @@ out:
 	mutex_unlock(&pinst->lock);
 
 	return err;
+
 }
-EXPORT_SYMBOL(padata_set_cpumask);
+EXPORT_SYMBOL(__padata_set_cpumasks);
 
 static int __padata_add_cpu(struct padata_instance *pinst, int cpu)
 {
 	struct parallel_data *pd;
 
 	if (cpumask_test_cpu(cpu, cpu_active_mask)) {
-		pd = padata_alloc_pd(pinst, pinst->cpumask);
+		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
+				     pinst->cpumask.cbcpu);
 		if (!pd)
 			return -ENOMEM;
 
 		padata_replace(pinst, pd);
 
-		if (padata_validate_cpumask(pinst, pinst->cpumask))
+		if (padata_validate_cpumask(pinst, pinst->cpumask.pcpu) &&
+		    padata_validate_cpumask(pinst, pinst->cpumask.cbcpu))
 			__padata_start(pinst);
 	}
 
 	return 0;
 }
 
-/**
- * padata_add_cpu - add a cpu to the padata cpumask
+ /**
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
+
+int padata_add_cpu(struct padata_instance *pinst, int cpu, int mask)
 {
 	int err;
 
+	if (!(mask & (PADATA_CPU_SERIAL | PADATA_CPU_PARALLEL)))
+		return -EINVAL;
+
 	mutex_lock(&pinst->lock);
 
 	get_online_cpus();
-	cpumask_set_cpu(cpu, pinst->cpumask);
+	if (mask & PADATA_CPU_SERIAL)
+		cpumask_set_cpu(cpu, pinst->cpumask.cbcpu);
+	if (mask & PADATA_CPU_PARALLEL)
+		cpumask_set_cpu(cpu, pinst->cpumask.pcpu);
+
 	err = __padata_add_cpu(pinst, cpu);
 	put_online_cpus();
 
@@ -596,13 +773,15 @@ static int __padata_remove_cpu(struct padata_instance *pinst, int cpu)
 
 	if (cpumask_test_cpu(cpu, cpu_online_mask)) {
 
-		if (!padata_validate_cpumask(pinst, pinst->cpumask)) {
+		if (!padata_validate_cpumask(pinst, pinst->cpumask.pcpu) ||
+		    !padata_validate_cpumask(pinst, pinst->cpumask.cbcpu)) {
 			__padata_stop(pinst);
 			padata_replace(pinst, pd);
 			goto out;
 		}
 
-		pd = padata_alloc_pd(pinst, pinst->cpumask);
+		pd = padata_alloc_pd(pinst, pinst->cpumask.pcpu,
+				     pinst->cpumask.cbcpu);
 		if (!pd)
 			return -ENOMEM;
 
@@ -613,20 +792,32 @@ out:
 	return 0;
 }
 
-/**
- * padata_remove_cpu - remove a cpu from the padata cpumask
+ /**
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
+		cpumask_clear_cpu(cpu, pinst->cpumask.cbcpu);
+	if (mask & PADATA_CPU_PARALLEL)
+		cpumask_clear_cpu(cpu, pinst->cpumask.pcpu);
+
 	err = __padata_remove_cpu(pinst, cpu);
 	put_online_cpus();
 
@@ -672,6 +863,14 @@ void padata_stop(struct padata_instance *pinst)
 EXPORT_SYMBOL(padata_stop);
 
 #ifdef CONFIG_HOTPLUG_CPU
+
+static inline int pinst_has_cpu(struct padata_instance *pinst, int cpu)
+{
+	return cpumask_test_cpu(cpu, pinst->cpumask.pcpu) ||
+		cpumask_test_cpu(cpu, pinst->cpumask.cbcpu);
+}
+
+
 static int padata_cpu_callback(struct notifier_block *nfb,
 			       unsigned long action, void *hcpu)
 {
@@ -684,7 +883,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		err = __padata_add_cpu(pinst, cpu);
@@ -695,7 +894,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		err = __padata_remove_cpu(pinst, cpu);
@@ -706,7 +905,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_UP_CANCELED:
 	case CPU_UP_CANCELED_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		__padata_remove_cpu(pinst, cpu);
@@ -714,7 +913,7 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
-		if (!cpumask_test_cpu(cpu, pinst->cpumask))
+		if (!pinst_has_cpu(pinst, cpu))
 			break;
 		mutex_lock(&pinst->lock);
 		__padata_add_cpu(pinst, cpu);
@@ -726,13 +925,29 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 #endif
 
 /**
- * padata_alloc - allocate and initialize a padata instance
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
+EXPORT_SYMBOL(padata_alloc);
+
+/**
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
+				       const struct cpumask *pcpumask,
+				       const struct cpumask *cbcpumask)
 {
 	struct padata_instance *pinst;
 	struct parallel_data *pd = NULL;
@@ -742,21 +957,26 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 		goto err;
 
 	get_online_cpus();
-
-	if (!alloc_cpumask_var(&pinst->cpumask, GFP_KERNEL))
+	if (!alloc_cpumask_var(&pinst->cpumask.pcpu, GFP_KERNEL))
+		goto err_free_inst;
+	if (!alloc_cpumask_var(&pinst->cpumask.cbcpu, GFP_KERNEL)) {
+		free_cpumask_var(pinst->cpumask.pcpu);
 		goto err_free_inst;
-
-	if (padata_validate_cpumask(pinst, cpumask)) {
-		pd = padata_alloc_pd(pinst, cpumask);
-		if (!pd)
-			goto err_free_mask;
 	}
+	if (!padata_validate_cpumask(pinst, pcpumask) ||
+	    !padata_validate_cpumask(pinst, cbcpumask))
+		goto err_free_masks;
+
+	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
+	if (!pd)
+		goto err_free_masks;
 
 	rcu_assign_pointer(pinst->pd, pd);
 
 	pinst->wq = wq;
 
-	cpumask_copy(pinst->cpumask, cpumask);
+	cpumask_copy(pinst->cpumask.pcpu, pcpumask);
+	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
 	pinst->flags = 0;
 
@@ -768,19 +988,21 @@ struct padata_instance *padata_alloc(const struct cpumask *cpumask,
 
 	put_online_cpus();
 
+	BLOCKING_INIT_NOTIFIER_HEAD(&pinst->cpumask_change_notifier);
 	mutex_init(&pinst->lock);
 
 	return pinst;
 
-err_free_mask:
-	free_cpumask_var(pinst->cpumask);
+err_free_masks:
+	free_cpumask_var(pinst->cpumask.pcpu);
+	free_cpumask_var(pinst->cpumask.cbcpu);
 err_free_inst:
 	kfree(pinst);
 	put_online_cpus();
 err:
 	return NULL;
 }
-EXPORT_SYMBOL(padata_alloc);
+EXPORT_SYMBOL(__padata_alloc);
 
 /**
  * padata_free - free a padata instance
@@ -795,7 +1017,8 @@ void padata_free(struct padata_instance *pinst)
 
 	padata_stop(pinst);
 	padata_free_pd(pinst->pd);
-	free_cpumask_var(pinst->cpumask);
+	free_cpumask_var(pinst->cpumask.pcpu);
+	free_cpumask_var(pinst->cpumask.cbcpu);
 	kfree(pinst);
 }
 EXPORT_SYMBOL(padata_free);
-- 
1.7.1



-- 
W.B.R.
Dan Kruchinin
