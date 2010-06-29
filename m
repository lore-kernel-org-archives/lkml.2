Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab0F2Qjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 12:39:55 -0400
Received: from office.altell.ru ([80.246.246.162]:53489 "EHLO office.altell.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755849Ab0F2Qjx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 12:39:53 -0400
Date: Tue, 29 Jun 2010 20:39:39 +0400
From: Dan Kruchinin <kruchinin@altell.ru>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>
Subject: [PATCH 2/2] pcrypt:  sysfs interface
Message-ID: <20100629203939.29a0b4ff@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Altell-MailScanner-ID: 3AFEA53E4.4A520
X-Altell-MailScanner: Found to be clean
X-Altell-MailScanner-From: kruchinin@altell.ru
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sysfs interface for pcrypt: /sys/kernel/pcrypt/pencrypt and /sys/kernel/pcrypt/pencrypt
padata_instance now contains a kobject with common operations that may be embedded by the user to
a kset or can be made a child of any other kobject.
Padata sysfs interface adds the following files:
serial_cpumask [RW] - cpumask for callback CPUs and hence serial workers
parallel_cpumask [RW] - cpumask for parallel workers
serial_objecs [RO] - number of objects waiting for serialization
reorder_objects [RO] - number of objects waiting in reorder queues
parallel_objects [RO] - number of objects waiting for parallelization

--
diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 20f3e47..ec146b2 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -24,12 +24,14 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/kobject.h>
 #include <crypto/pcrypt.h>
 
 static struct padata_instance *pcrypt_enc_padata;
 static struct padata_instance *pcrypt_dec_padata;
 static struct workqueue_struct *encwq;
 static struct workqueue_struct *decwq;
+static struct kset             *pcrypt_kset;
 
 struct pcrypt_instance_ctx {
 	struct crypto_spawn spawn;
@@ -364,6 +366,41 @@ static void pcrypt_free(struct crypto_instance *inst)
 	kfree(inst);
 }
 
+static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
+{
+    int ret;
+
+    pinst->kobj.kset = pcrypt_kset;
+    ret = kobject_add(&pinst->kobj, NULL, name);
+    if (!ret)
+        kobject_uevent(&pinst->kobj, KOBJ_ADD);
+
+    return ret;
+}
+
+static int pcrypt_init_sysfs(void)
+{
+    int ret;
+
+    pcrypt_kset = kset_create_and_add("pcrypt", NULL, kernel_kobj);
+    if (!pcrypt_kset)
+        return -ENOMEM;
+
+    ret = pcrypt_sysfs_add(pcrypt_enc_padata, "pencrypt");
+    if (ret)
+        goto err;
+
+    ret = pcrypt_sysfs_add(pcrypt_dec_padata, "pdecrypt");
+    if (ret)
+        goto err;
+
+    return ret;
+
+err:
+    kset_unregister(pcrypt_kset);
+    return ret;
+}
+
 static struct crypto_template pcrypt_tmpl = {
 	.name = "pcrypt",
 	.alloc = pcrypt_alloc,
@@ -390,6 +427,9 @@ static int __init pcrypt_init(void)
 	if (!pcrypt_dec_padata)
 		goto err_free_padata;
 
+	if (pcrypt_init_sysfs() != 0)
+		goto err_free_padata;
+
 	padata_start(pcrypt_enc_padata);
 	padata_start(pcrypt_dec_padata);
 
@@ -416,6 +456,7 @@ static void __exit pcrypt_exit(void)
 	destroy_workqueue(encwq);
 	destroy_workqueue(decwq);
 
+	kset_unregister(pcrypt_kset);
 	padata_free(pcrypt_enc_padata);
 	padata_free(pcrypt_dec_padata);
 
diff --git a/include/linux/padata.h b/include/linux/padata.h
index ff73114..2f001f7 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -24,6 +24,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>
+#include <linux/kobject.h>
 #include <linux/timer.h>
 
 #define PADATA_CPU_SERIAL   0x01
@@ -41,13 +42,13 @@
  * @serial: Serial complete function.
  */
 struct padata_priv {
-	struct list_head	list;
-	struct parallel_data	*pd;
-	int			cb_cpu;
-	int			seq_nr;
-	int			info;
-	void                    (*parallel)(struct padata_priv *padata);
-	void                    (*serial)(struct padata_priv *padata);
+	struct list_head      list;
+	struct parallel_data *pd;
+	int                   cb_cpu;
+	int                   seq_nr;
+	int                   info;
+	void                  (*parallel)(struct padata_priv *padata);
+	void                  (*serial)(struct padata_priv *padata);
 };
 
 /**
@@ -114,7 +115,6 @@ struct parallel_data {
 	struct padata_parallel_queue *pqueue;
 	struct padata_serial_queue   *squeue;
 	atomic_t                      seq_nr;
-	atomic_t                      reorder_objects;
 	atomic_t                      refcnt;
 	unsigned int                  max_seq_nr;
 	struct {
@@ -126,11 +126,27 @@ struct parallel_data {
 };
 
 /**
+ * struct padata_stat - Parallel data statistics
+ *
+ * @serial_objs: Number of objects waiting for serialization
+ * @parallel_objs: Number of objects waiting in the parallel queues
+ * @reorder_objs: Number of objects waiting in the reorder queues
+ * @handled_objs: Total number of handled pbjects.
+ */
+struct padata_stat {
+	atomic_t serial_objs;
+	atomic_t parallel_objs;
+	atomic_t reorder_objs;
+	atomic_t handled_objs;
+};
+
+/**
  * struct padata_instance - The overall control structure.
  *
  * @cpu_notifier: cpu hotplug notifier.
  * @wq: The workqueue in use.
  * @pd: The internal control structure.
+ * @stat: padata statistics.
  * @cpumask: User supplied cpumask. Contains two cpumasks: pcpu and
  *           cbcpu for parallel and serial works.
  * @lock: padata instance lock.
@@ -139,15 +155,17 @@ struct parallel_data {
 struct padata_instance {
 	struct notifier_block   cpu_notifier;
 	struct workqueue_struct *wq;
-	struct parallel_data	*pd;
+	struct parallel_data    *pd;
+	struct padata_stat       stat;
 	struct {
 		cpumask_var_t        pcpu;
 		cpumask_var_t        cbcpu;
 	} cpumask;
-	struct mutex		lock;
-	u8			flags;
-#define	PADATA_INIT		1
-#define	PADATA_RESET		2
+	struct kobject           kobj;
+	struct mutex             lock;
+	u8                       flags;
+#define	PADATA_INIT  1
+#define	PADATA_RESET 2
 };
 
 extern struct padata_instance *padata_alloc(struct workqueue_struct *wq);
diff --git a/kernel/padata.c b/kernel/padata.c
index 3936837..42fca11 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 #include <linux/rcupdate.h>
 
 #define MAX_SEQ_NR (INT_MAX - NR_CPUS)
@@ -107,6 +108,7 @@ static void padata_parallel_worker(struct work_struct *parallel_work)
 				    struct padata_priv, list);
 
 		list_del_init(&padata->list);
+		atomic_dec(&pinst->stat.parallel_objs);
 
 		padata->parallel(padata);
 	}
@@ -166,6 +168,7 @@ int padata_do_parallel(struct padata_instance *pinst,
 	pqueue = per_cpu_ptr(pd->pqueue, target_cpu);
 
 	spin_lock(&pqueue->parallel.lock);
+	atomic_inc(&pinst->stat.parallel_objs);
 	list_add_tail(&padata->list, &pqueue->parallel.list);
 	spin_unlock(&pqueue->parallel.lock);
 
@@ -202,6 +205,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 	struct padata_parallel_queue *queue, *next_queue;
 	struct padata_priv *padata;
 	struct padata_list *reorder;
+	struct padata_stat *stat = &pd->pinst->stat;
 
 	empty = 0;
 	next_nr = -1;
@@ -266,7 +270,7 @@ static struct padata_priv *padata_get_next(struct parallel_data *pd)
 
 		spin_lock(&reorder->lock);
 		list_del_init(&padata->list);
-		atomic_dec(&pd->reorder_objects);
+		atomic_dec(&stat->reorder_objs);
 		spin_unlock(&reorder->lock);
 
 		atomic_inc(&next_queue->num_obj);
@@ -330,6 +334,7 @@ static void padata_reorder(struct parallel_data *pd)
 		squeue = per_cpu_ptr(pd->squeue, padata->cb_cpu);
 
 		spin_lock(&squeue->serial.lock);
+        atomic_inc(&pinst->stat.serial_objs);
 		list_add_tail(&padata->list, &squeue->serial.list);
 		spin_unlock(&squeue->serial.lock);
 
@@ -343,7 +348,7 @@ static void padata_reorder(struct parallel_data *pd)
      * the reorder queues in the meantime, we will be called again
      * from the timer function if noone else cares for it.
      */
-	if (atomic_read(&pd->reorder_objects)
+	if (atomic_read(&pinst->stat.reorder_objs)
 			&& !(pinst->flags & PADATA_RESET))
 		mod_timer(&pd->timer, jiffies + HZ);
 	else
@@ -363,11 +368,13 @@ static void padata_serial_worker(struct work_struct *serial_work)
 {
 	struct padata_serial_queue *squeue;
 	struct parallel_data *pd;
+	struct padata_stat *stat;
 	LIST_HEAD(local_list);
 
 	local_bh_disable();
 	squeue = container_of(serial_work, struct padata_serial_queue, work);
 	pd = squeue->pd;
+	stat = &pd->pinst->stat;
 
 	spin_lock(&squeue->serial.lock);
 	list_replace_init(&squeue->serial.list, &local_list);
@@ -380,6 +387,7 @@ static void padata_serial_worker(struct work_struct *serial_work)
                             struct padata_priv, list);
 
 		list_del_init(&padata->list);
+		atomic_dec(&stat->serial_objs);
 
 		padata->serial(padata);
 		atomic_dec(&pd->refcnt);
@@ -400,14 +408,16 @@ void padata_do_serial(struct padata_priv *padata)
 	int cpu;
 	struct padata_parallel_queue *queue;
 	struct parallel_data *pd;
+	struct padata_stat *stat;
 
 	pd = padata->pd;
+	stat = &pd->pinst->stat;
 
 	cpu = get_cpu();
 	queue = per_cpu_ptr(pd->pqueue, cpu);
 
 	spin_lock(&queue->reorder.lock);
-	atomic_inc(&pd->reorder_objects);
+	atomic_inc(&stat->reorder_objs);
 	list_add_tail(&padata->list, &queue->reorder.list);
 	spin_unlock(&queue->reorder.lock);
 
@@ -502,7 +512,9 @@ static struct parallel_data *padata_alloc_pd(struct padata_instance *pinst,
 
 	setup_timer(&pd->timer, padata_reorder_timer, (unsigned long)pd);
 	atomic_set(&pd->seq_nr, -1);
-	atomic_set(&pd->reorder_objects, 0);
+	atomic_set(&pinst->stat.reorder_objs, 0);
+	atomic_set(&pinst->stat.serial_objs, 0);
+	atomic_set(&pinst->stat.parallel_objs, 0);
 	atomic_set(&pd->refcnt, 0);
 	pd->pinst = pinst;
 	spin_lock_init(&pd->lock);
@@ -542,7 +554,7 @@ static void padata_flush_queues(struct parallel_data *pd)
 
 	del_timer_sync(&pd->timer);
 
-	if (atomic_read(&pd->reorder_objects))
+	if (atomic_read(&pd->pinst->stat.reorder_objs))
 		padata_reorder(pd);
 
 	for_each_cpu(cpu, pd->cpumask.cbcpu) {
@@ -824,6 +836,177 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 }
 #endif
 
+static void __padata_free(struct padata_instance *pinst)
+{
+	padata_stop(pinst);
+	synchronize_rcu();
+
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_hotcpu_notifier(&pinst->cpu_notifier);
+#endif
+
+	get_online_cpus();
+	padata_flush_queues(pinst->pd);
+	put_online_cpus();
+
+	padata_free_pd(pinst->pd);
+	free_cpumask_var(pinst->cpumask.pcpu);
+	free_cpumask_var(pinst->cpumask.cbcpu);
+
+	kfree(pinst);
+}
+
+#define kobj2pinst(_kobj)  \
+	container_of(_kobj, struct padata_instance, kobj)
+#define attr2pentry(_attr) \
+	container_of(_attr, struct padata_sysfs_entry, attr)
+
+static void padata_sysfs_release(struct kobject *kobj)
+{
+	struct padata_instance *pinst = kobj2pinst(kobj);
+	__padata_free(pinst);
+}
+
+struct padata_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct padata_instance *, struct attribute *, char *);
+	ssize_t (*store)(struct padata_instance *, struct attribute *,
+                     const char *, size_t);
+};
+
+static ssize_t show_cpumask(struct padata_instance *pinst,
+                            struct attribute *attr,  char *buf)
+{
+	struct cpumask *cpumask;
+	ssize_t len;
+
+	mutex_lock(&pinst->lock);
+	if (!strcmp(attr->name, "serial_cpumask"))
+		cpumask = pinst->cpumask.cbcpu;
+	else
+		cpumask = pinst->cpumask.pcpu;
+
+	len = bitmap_scnprintf(buf, PAGE_SIZE, cpumask_bits(cpumask),
+                           nr_cpu_ids);
+	if (PAGE_SIZE - len < 2)
+		len = -EINVAL;
+	else
+		len += sprintf(buf + len, "\n");
+
+	mutex_unlock(&pinst->lock);
+	return len;
+}
+
+static ssize_t show_pstat_field(struct padata_instance *pinst,
+                                struct attribute *attr, char *buf)
+{
+	struct padata_stat *pstat = &pinst->stat;
+	atomic_t *field;
+
+	if (!strcmp(attr->name, "reorder_objects"))
+		field = &pstat->reorder_objs;
+	else if (!strcmp(attr->name, "serial_objects"))
+		field = &pstat->serial_objs;
+	else if (!strcmp(attr->name, "parallel_objects"))
+		field = &pstat->parallel_objs;
+	else
+		field = &pstat->handled_objs;
+
+	return sprintf(buf, "%d\n", atomic_read(field));
+}
+
+static ssize_t store_cpumask(struct padata_instance *pinst,
+                             struct attribute *attr,
+                             const char *buf, size_t count)
+{
+	cpumask_var_t new_cpumask;
+	ssize_t ret;
+
+	if (!alloc_cpumask_var(&new_cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = bitmap_parse(buf, count, cpumask_bits(new_cpumask), nr_cpumask_bits);
+	if (ret < 0)
+		goto out;
+
+	if (!strcmp(attr->name, "serial_cpumask"))
+		ret = padata_set_serial_cpumask(pinst, new_cpumask);
+	else
+		ret = padata_set_parallel_cpumask(pinst, new_cpumask);
+	if (!ret)
+		ret = count;
+
+  out:
+	free_cpumask_var(new_cpumask);
+	return ret;
+}
+
+#define PADATA_ATTR_RW(_name, _show_name, _store_name) \
+	static struct padata_sysfs_entry _name##_attr =    \
+	__ATTR(_name, 0644, _show_name, _store_name)
+#define PADATA_ATTR_RO(_name, _show_name)           \
+	static struct padata_sysfs_entry _name##_attr = \
+	__ATTR(_name, 0400, _show_name, NULL)
+
+PADATA_ATTR_RW(serial_cpumask, show_cpumask, store_cpumask);
+PADATA_ATTR_RW(parallel_cpumask, show_cpumask, store_cpumask);
+PADATA_ATTR_RO(parallel_objects, show_pstat_field);
+PADATA_ATTR_RO(reorder_objects, show_pstat_field);
+PADATA_ATTR_RO(serial_objects, show_pstat_field);
+PADATA_ATTR_RO(handled_objects, show_pstat_field);
+
+static struct attribute *padata_default_attrs[] = {
+		&serial_cpumask_attr.attr,
+		&parallel_cpumask_attr.attr,
+		&reorder_objects_attr.attr,
+		&serial_objects_attr.attr,
+		&parallel_objects_attr.attr,
+		&handled_objects_attr.attr,
+		NULL,
+};
+
+static ssize_t padata_sysfs_show(struct kobject *kobj,
+                                 struct attribute *attr, char *buf)
+{
+	struct padata_instance *pinst;
+	struct padata_sysfs_entry *pentry;
+	ssize_t ret = -EIO;
+
+	pinst = kobj2pinst(kobj);
+	pentry = attr2pentry(attr);
+	if (pentry->show)
+		ret = pentry->show(pinst, attr, buf);
+
+	return ret;
+}
+
+static ssize_t padata_sysfs_store(struct kobject *kobj, struct attribute *attr,
+		const char *buf, size_t count)
+{
+	struct padata_instance *pinst;
+	struct padata_sysfs_entry *pentry;
+	ssize_t ret = -EIO;
+
+	pinst = kobj2pinst(kobj);
+	pentry = attr2pentry(attr);
+	if (pentry->show) {
+		ret = pentry->store(pinst, attr, buf, count);
+	}
+
+	return ret;
+}
+
+static struct sysfs_ops padata_sysfs_ops = {
+		.show = padata_sysfs_show,
+		.store = padata_sysfs_store,
+};
+
+static struct kobj_type padata_attr_type = {
+		.sysfs_ops = &padata_sysfs_ops,
+		.default_attrs = padata_default_attrs,
+		.release = padata_sysfs_release,
+};
+
 /**
  * __padata_alloc - allocate and initialize a padata instance
  *                  and specify cpumasks for serial and parallel workers.
@@ -843,7 +1026,7 @@ struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
 	if (!pinst)
 		goto err;
 
-   get_online_cpus();
+	get_online_cpus();
 
 	pd = padata_alloc_pd(pinst, pcpumask, cbcpumask);
 	if (!pd)
@@ -864,6 +1047,7 @@ struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
 	cpumask_copy(pinst->cpumask.cbcpu, cbcpumask);
 
 	pinst->flags = 0;
+	atomic_set(&pinst->stat.handled_objs, 0);
 
 #ifdef CONFIG_HOTPLUG_CPU
 	pinst->cpu_notifier.notifier_call = padata_cpu_callback;
@@ -871,6 +1055,7 @@ struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
 	register_hotcpu_notifier(&pinst->cpu_notifier);
 #endif
 
+	kobject_init(&pinst->kobj, &padata_attr_type);
 	put_online_cpus();
 
 	mutex_init(&pinst->lock);
@@ -907,20 +1092,6 @@ EXPORT_SYMBOL(padata_alloc);
  */
 void padata_free(struct padata_instance *pinst)
 {
-	padata_stop(pinst);
-
-	synchronize_rcu();
-
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_hotcpu_notifier(&pinst->cpu_notifier);
-#endif
-	get_online_cpus();
-	padata_flush_queues(pinst->pd);
-	put_online_cpus();
-
-	padata_free_pd(pinst->pd);
-	free_cpumask_var(pinst->cpumask.pcpu);
-	free_cpumask_var(pinst->cpumask.cbcpu);
-	kfree(pinst);
+	kobject_put(&pinst->kobj);
 }
 EXPORT_SYMBOL(padata_free);


-- 
W.B.R.
Dan Kruchinin
