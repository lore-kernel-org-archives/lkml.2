Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0GNKdR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 06:33:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56642 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754627Ab0GNKdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 06:33:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=IQqIl1QRZccnAPzim38sQrnrSMR7w40EaNpwDGjpHacyOPLm1sI/OOgG6EuD3e/TPx
         U0H/fRlIa1xng4faIc/7nN4Mc9u2GB0Xy26XsoxdYRiRZ08SB0z6i4K+ujGECXoqlvBx
         gt1uDHHhxmW45O6XDvwViKfVXe30Xh88wLyAw=
Date: Wed, 14 Jul 2010 14:33:08 +0400
From: Dan Kruchinin <dkruchinin@acm.org>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Added sysfs primitives to padata subsystem
Message-ID: <20100714143308.6a10b9d5@leibniz>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added sysfs primitives to padata subsystem. Now API user may
embedded kobject each padata instance contains into any sysfs
hierarchy. For now padata sysfs interface provides only
two objects:
    serial_cpumask   [RW] - cpumask for serial workers
    parallel_cpumask [RW] - cpumask for parallel workers


Signed-off-by: Dan Kruchinin <dkruchinin@acm.org>
---
 include/linux/padata.h |    5 +-
 kernel/padata.c        |  155 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 150 insertions(+), 10 deletions(-)

diff --git a/include/linux/padata.h b/include/linux/padata.h
index 621e773..293ad46 100644
--- a/include/linux/padata.h
+++ b/include/linux/padata.h
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/timer.h>
 #include <linux/notifier.h>
+#include <linux/kobject.h>
 
 #define PADATA_CPU_SERIAL   0x01
 #define PADATA_CPU_PARALLEL 0x02
@@ -142,7 +143,8 @@ struct parallel_data {
  *           cbcpu for parallel and serial works respectivly.
  * @cpumask_change_notifier: Notifiers chain for user-defined notify
  *            callbacks that will be called when either @pcpu or @cbcpu
- *             or both cpumasks change.
+ *            or both cpumasks change.
+ * @kobj: padata instance kernel object.
  * @lock: padata instance lock.
  * @flags: padata flags.
  */
@@ -155,6 +157,7 @@ struct padata_instance {
 		cpumask_var_t		 cbcpu;
 	} cpumask;
 	struct blocking_notifier_head	 cpumask_change_notifier;
+	struct kobject                   kobj;
 	struct mutex			 lock;
 	u8				 flags;
 #define	PADATA_INIT	1
diff --git a/kernel/padata.c b/kernel/padata.c
index 84d0ca9..526f9ea 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -26,6 +26,7 @@
 #include <linux/mutex.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 #include <linux/rcupdate.h>
 
 #define MAX_SEQ_NR (INT_MAX - NR_CPUS)
@@ -924,6 +925,149 @@ static int padata_cpu_callback(struct notifier_block *nfb,
 }
 #endif
 
+static void __padata_free(struct padata_instance *pinst)
+{
+#ifdef CONFIG_HOTPLUG_CPU
+	unregister_hotcpu_notifier(&pinst->cpu_notifier);
+#endif
+
+	padata_stop(pinst);
+	padata_free_pd(pinst->pd);
+	free_cpumask_var(pinst->cpumask.pcpu);
+	free_cpumask_var(pinst->cpumask.cbcpu);
+	kfree(pinst);
+}
+
+#define kobj2pinst(_kobj)					\
+	container_of(_kobj, struct padata_instance, kobj)
+#define attr2pentry(_attr)					\
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
+			 const char *, size_t);
+};
+
+static ssize_t show_cpumask(struct padata_instance *pinst,
+			    struct attribute *attr,  char *buf)
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
+			       nr_cpu_ids);
+	if (PAGE_SIZE - len < 2)
+		len = -EINVAL;
+	else
+		len += sprintf(buf + len, "\n");
+
+	mutex_unlock(&pinst->lock);
+	return len;
+}
+
+static ssize_t store_cpumask(struct padata_instance *pinst,
+			     struct attribute *attr,
+			     const char *buf, size_t count)
+{
+	cpumask_var_t new_cpumask;
+	ssize_t ret;
+	int mask_type;
+
+	if (!alloc_cpumask_var(&new_cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = bitmap_parse(buf, count, cpumask_bits(new_cpumask),
+			   nr_cpumask_bits);
+	if (ret < 0)
+		goto out;
+
+	mask_type = !strcmp(attr->name, "serial_cpumask") ?
+		PADATA_CPU_SERIAL : PADATA_CPU_PARALLEL;
+	ret = padata_set_cpumask(pinst, mask_type, new_cpumask);
+	if (!ret)
+		ret = count;
+
+out:
+	free_cpumask_var(new_cpumask);
+	return ret;
+}
+
+#define PADATA_ATTR_RW(_name, _show_name, _store_name)		\
+	static struct padata_sysfs_entry _name##_attr =		\
+		__ATTR(_name, 0644, _show_name, _store_name)
+#define PADATA_ATTR_RO(_name, _show_name)		\
+	static struct padata_sysfs_entry _name##_attr = \
+		__ATTR(_name, 0400, _show_name, NULL)
+
+PADATA_ATTR_RW(serial_cpumask, show_cpumask, store_cpumask);
+PADATA_ATTR_RW(parallel_cpumask, show_cpumask, store_cpumask);
+
+/*
+ * Padata sysfs provides the following objects:
+ * serial_cpumask   [RW] - cpumask for serial workers
+ * parallel_cpumask [RW] - cpumask for parallel workers
+ */
+static struct attribute *padata_default_attrs[] = {
+	&serial_cpumask_attr.attr,
+	&parallel_cpumask_attr.attr,
+	NULL,
+};
+
+static ssize_t padata_sysfs_show(struct kobject *kobj,
+				 struct attribute *attr, char *buf)
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
+				  const char *buf, size_t count)
+{
+	struct padata_instance *pinst;
+	struct padata_sysfs_entry *pentry;
+	ssize_t ret = -EIO;
+
+	pinst = kobj2pinst(kobj);
+	pentry = attr2pentry(attr);
+	if (pentry->show)
+		ret = pentry->store(pinst, attr, buf, count);
+
+	return ret;
+}
+
+static const struct sysfs_ops padata_sysfs_ops = {
+	.show = padata_sysfs_show,
+	.store = padata_sysfs_store,
+};
+
+static struct kobj_type padata_attr_type = {
+	.sysfs_ops = &padata_sysfs_ops,
+	.default_attrs = padata_default_attrs,
+	.release = padata_sysfs_release,
+};
+
 /**
  * padata_alloc - Allocate and initialize padata instance.
  *                Use default cpumask(cpu_possible_mask)
@@ -989,6 +1133,7 @@ struct padata_instance *__padata_alloc(struct workqueue_struct *wq,
 	put_online_cpus();
 
 	BLOCKING_INIT_NOTIFIER_HEAD(&pinst->cpumask_change_notifier);
+	kobject_init(&pinst->kobj, &padata_attr_type);
 	mutex_init(&pinst->lock);
 
 	return pinst;
@@ -1011,14 +1156,6 @@ EXPORT_SYMBOL(__padata_alloc);
  */
 void padata_free(struct padata_instance *pinst)
 {
-#ifdef CONFIG_HOTPLUG_CPU
-	unregister_hotcpu_notifier(&pinst->cpu_notifier);
-#endif
-
-	padata_stop(pinst);
-	padata_free_pd(pinst->pd);
-	free_cpumask_var(pinst->cpumask.pcpu);
-	free_cpumask_var(pinst->cpumask.cbcpu);
-	kfree(pinst);
+	kobject_put(&pinst->kobj);
 }
 EXPORT_SYMBOL(padata_free);
-- 
1.7.1



-- 
W.B.R.
Dan Kruchinin
