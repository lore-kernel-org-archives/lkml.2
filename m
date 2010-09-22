Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab0IVXwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:52:11 -0400
Received: from relay3.sgi.com ([192.48.152.1]:56593 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730Ab0IVXwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:52:10 -0400
Date: Wed, 22 Sep 2010 16:52:08 -0700
From: Arthur Kepner <akepner@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [RFC/PATCHv2] kernel/irq: allow more precise irq affinity policies
Message-ID: <20100922235208.GC19058@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


SGI has encountered situations where particular CPUs run out of 
interrupt vectors on systems with many (several hundred or more) 
CPUs. This happens because some drivers (particularly the mlx4_core 
driver) select the number of interrupts they allocate based on the 
number of CPUs, and because of how the default irq affinity is used.

The following patch allows for a more precise policy about how irq 
affinities are assigned by the kernel.

Changes from version 1:

	- IRQ_POLICY_NUMA is implemented

	- The 'irq_policy' can be changed at runtime, and interrupts 
	  redistributed according to the new policy. Notifications are 
	  sent when this happens.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 arch/x86/Kconfig           |   11 +
 include/linux/irq_policy.h |   21 +++
 kernel/irq/Makefile        |    2 
 kernel/irq/handle.c        |    5 
 kernel/irq/manage.c        |    3 
 kernel/irq/policy.c        |  291 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/proc.c          |   61 +++++++++
 7 files changed, 392 insertions(+), 2 deletions(-)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..8fa7f52 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -313,6 +313,17 @@ config NUMA_IRQ_DESC
 	def_bool y
 	depends on SPARSE_IRQ && NUMA
 
+config IRQ_POLICY_NUMA
+	bool "Assign default interrupt affinities in a NUMA-friendly way"
+	def_bool y
+	depends on SPARSE_IRQ && NUMA
+	---help---
+	   When a device requests an interrupt, the default CPU used to
+	   service the interrupt will be selected from a node 'near by'
+	   the device. Also, interrupt affinities will be spread around
+	   the node so as to prevent any single CPU from running out of
+	   interrupt vectors.
+
 config X86_MPPARSE
 	bool "Enable MPS table" if ACPI
 	default y
diff --git a/include/linux/irq_policy.h b/include/linux/irq_policy.h
new file mode 100644
index 0000000..f009757
--- /dev/null
+++ b/include/linux/irq_policy.h
@@ -0,0 +1,21 @@
+#ifndef _LINUX_IRQ_POLICY_H
+#define _LINUX_IRQ_POLICY_H
+
+#include <linux/notifier.h>
+#include <linux/seq_file.h>
+#include <linux/irq.h>
+
+int available_irq_policy_show(struct seq_file *m, void *v);
+int irq_policy_show(struct seq_file *m, void *v);
+
+void __init init_irq_policy(void);
+int irq_policy_change(char *str);
+void irq_policy_apply(struct irq_desc *desc);
+
+enum irq_policy_notifiers {
+	IRQ_POLICY_REDISTRIBUTED,
+};
+
+int irq_policy_notify(struct notifier_block *nb);
+
+#endif /* _LINUX_IRQ_POLICY_H */
diff --git a/kernel/irq/Makefile b/kernel/irq/Makefile
index 7d04780..0532082 100644
--- a/kernel/irq/Makefile
+++ b/kernel/irq/Makefile
@@ -1,5 +1,5 @@
 
-obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o
+obj-y := handle.o manage.o spurious.o resend.o chip.o devres.o policy.o
 obj-$(CONFIG_GENERIC_IRQ_PROBE) += autoprobe.o
 obj-$(CONFIG_PROC_FS) += proc.o
 obj-$(CONFIG_GENERIC_PENDING_IRQ) += migration.o
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 27e5c69..a4f1087 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -21,6 +21,7 @@
 #include <linux/hash.h>
 #include <linux/radix-tree.h>
 #include <trace/events/irq.h>
+#include <linux/irq_policy.h>
 
 #include "internals.h"
 
@@ -171,6 +172,8 @@ int __init early_irq_init(void)
 
 	init_irq_default_affinity();
 
+	init_irq_policy();
+
 	 /* initialize nr_irqs based on nr_cpu_ids */
 	arch_probe_nr_irqs();
 	printk(KERN_INFO "NR_IRQS:%d nr_irqs:%d\n", NR_IRQS, nr_irqs);
@@ -258,6 +261,8 @@ int __init early_irq_init(void)
 
 	init_irq_default_affinity();
 
+	init_irq_policy();
+
 	printk(KERN_INFO "NR_IRQS:%d\n", NR_IRQS);
 
 	desc = irq_desc;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index c3003e9..9141adc 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -14,6 +14,7 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/sched.h>
+#include <linux/irq_policy.h>
 
 #include "internals.h"
 
@@ -175,7 +176,7 @@ static int setup_affinity(unsigned int irq, struct irq_desc *desc)
 			desc->status &= ~IRQ_AFFINITY_SET;
 	}
 
-	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
+	irq_policy_apply(desc);
 set_affinity:
 	desc->chip->set_affinity(irq, desc->affinity);
 
diff --git a/kernel/irq/policy.c b/kernel/irq/policy.c
new file mode 100644
index 0000000..bc3f719
--- /dev/null
+++ b/kernel/irq/policy.c
@@ -0,0 +1,291 @@
+
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/irq_policy.h>
+
+#include "internals.h"
+
+struct irq_policy *current_irq_policy;
+DEFINE_MUTEX(irq_policy_mutex); /* protect current_irq_policy */
+
+ATOMIC_NOTIFIER_HEAD(irq_policy_notify_list);
+
+int irq_policy_notify(struct notifier_block *nb)
+{
+	return atomic_notifier_chain_register(&irq_policy_notify_list, nb);
+}
+EXPORT_SYMBOL_GPL(irq_policy_notify);
+
+#ifdef CONFIG_IRQ_POLICY_NUMA
+
+static int irqs_per_cpu[NR_CPUS];
+
+void apply_numa(struct irq_desc *newdesc)
+{
+	struct irq_desc *desc;
+	int newnode = newdesc->node;
+	int cpu;
+	int irq;
+	int best;
+	unsigned int min = -1;
+	unsigned long flags;
+
+	if (newdesc->irq < NR_IRQS_LEGACY || newnode == -1) {
+		cpumask_and(newdesc->affinity, cpu_online_mask,
+			    irq_default_affinity);
+		return;
+	}
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+
+	memset(irqs_per_cpu, 0, sizeof(irqs_per_cpu));
+
+	for_each_irq_desc(irq, desc) {
+
+		int node = desc->node;
+
+		if (node != newnode)
+			continue;
+
+		if (cpumask_full(desc->affinity))
+			continue;
+
+		if (!cpumask_intersects(desc->affinity, cpumask_of_node(node)))
+			continue; /* is that possible? */
+
+		for_each_cpu(cpu, desc->affinity)
+			irqs_per_cpu[cpu]++;
+
+	}
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+
+	best = cpumask_first(cpumask_of_node(newnode));
+	for_each_cpu(cpu, cpumask_of_node(newnode))
+		if (irqs_per_cpu[cpu] < min) {
+			min = irqs_per_cpu[cpu];
+			best = cpu;
+		}
+
+	cpumask_clear(newdesc->affinity);
+	cpumask_set_cpu(best, newdesc->affinity);
+}
+
+void redistribute_numa(void)
+{
+	struct irq_desc *desc1, *desc2;
+	int irq1, irq2;
+	unsigned long flags;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC)) {
+		printk(KERN_NOTICE "%s cannot allocate cpumask\n", __func__);
+		return;
+	}
+
+	raw_spin_lock_irqsave(&sparse_irq_lock, flags);
+	for_each_irq_desc(irq1, desc1) {
+
+		int node1 = desc1->node;
+		int best;
+		int cpu;
+		unsigned int min = -1;
+
+		if (irq1 < NR_IRQS_LEGACY)
+			continue;
+
+		if (desc1->chip == NULL || desc1->chip->set_affinity == NULL)
+			continue;
+
+		if (node1 == -1) {
+			cpumask_and(desc1->affinity, cpu_online_mask,
+				    irq_default_affinity);
+			continue;
+		}
+
+		memset(irqs_per_cpu, 0, sizeof(irqs_per_cpu));
+		raw_spin_lock(&desc1->lock);
+
+		for_each_irq_desc(irq2, desc2) {
+
+			int node2 = desc2->node;
+
+			if (irq2 >= irq1)
+				break;
+
+			if (node2 != node1)
+				continue;
+
+			if (cpumask_full(desc2->affinity))
+				continue;
+
+			if (!cpumask_intersects(desc2->affinity,
+						cpumask_of_node(node2)))
+				continue; /* is that possible? */
+
+			for_each_cpu(cpu, desc2->affinity)
+				irqs_per_cpu[cpu]++;
+
+		}
+
+		best = cpumask_first(cpumask_of_node(node1));
+		for_each_cpu(cpu, cpumask_of_node(node1))
+			if (irqs_per_cpu[cpu] < min) {
+				min = irqs_per_cpu[cpu];
+				best = cpu;
+			}
+
+		cpumask_clear(mask);
+		cpumask_set_cpu(best, mask);
+		desc1->chip->set_affinity(irq1, mask);
+		raw_spin_unlock(&desc1->lock);
+	}
+	raw_spin_unlock_irqrestore(&sparse_irq_lock, flags);
+	free_cpumask_var(mask);
+}
+#endif /* CONFIG_IRQ_POLICY_NUMA */
+
+void apply_default(struct irq_desc *desc)
+{
+	cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
+}
+
+void redistribute_default(void)
+{
+	struct irq_desc *desc;
+	int irq;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_ATOMIC)) {
+		printk(KERN_NOTICE "%s cannot allocate cpumask\n", __func__);
+		return;
+	}
+
+	for_each_irq_desc(irq, desc) {
+		unsigned long flags;
+		if (irq < NR_IRQS_LEGACY)
+			continue;
+
+		if (desc->chip == NULL || desc->chip->set_affinity == NULL)
+			continue;
+
+		raw_spin_lock_irqsave(&desc->lock, flags);
+		cpumask_and(desc->affinity, cpu_online_mask, irq_default_affinity);
+		desc->chip->set_affinity(irq, desc->affinity);
+		raw_spin_unlock_irqrestore(&desc->lock, flags);
+	}
+
+	free_cpumask_var(mask);
+}
+
+#define IRQ_POLICY_DEFAULT 0
+
+struct irq_policy {
+	char *name;
+	void (*apply) (struct irq_desc *desc); /* apply the policy */
+	void (*redistribute) (void); /* redistribute all irqs */
+} irq_policies[] = {
+	{
+		.name = "default",
+		.apply = apply_default,
+		.redistribute = redistribute_default,
+	},
+#ifdef CONFIG_IRQ_POLICY_NUMA
+	{
+		.name = "numa",
+		.apply = apply_numa,
+		.redistribute = redistribute_numa,
+	},
+#endif /* CONFIG_IRQ_POLICY_NUMA */
+};
+
+int available_irq_policy_show(struct seq_file *m, void *v)
+{
+	int i, imax = sizeof(irq_policies) / sizeof(irq_policies[0]);
+
+	for (i = 0; i < imax; i++)
+		seq_printf(m, "%s%s", irq_policies[i].name,
+			   i == (imax - 1) ? "\n" : " ");
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(available_irq_policy_show);
+
+int irq_policy_show(struct seq_file *m, void *v)
+{
+	mutex_lock(&irq_policy_mutex);
+	seq_printf(m, "%s\n", current_irq_policy->name);
+	mutex_unlock(&irq_policy_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_policy_show);
+
+static int irq_policy_select(char *str)
+{
+	int changed = 0;
+	int i, imax = sizeof(irq_policies) / sizeof(irq_policies[0]);
+
+	for (i = 0; i < imax; i++)
+		if (!strcmp(irq_policies[i].name, str))
+			break;
+
+	if (i < imax) {
+		mutex_lock(&irq_policy_mutex);
+		if (current_irq_policy != &irq_policies[i]) {
+			current_irq_policy = &irq_policies[i];
+			changed = 1;
+		}
+		mutex_unlock(&irq_policy_mutex);
+		return changed;
+	} else {
+		printk(KERN_INFO "irq_policy %s is invalid\n", str);
+		return -EINVAL;
+	}
+}
+
+int irq_policy_change(char *str)
+{
+	int ret = irq_policy_select(str);
+	int changed = ret > 0;
+
+	if (changed) {
+		current_irq_policy->redistribute();
+		atomic_notifier_call_chain(&irq_policy_notify_list,
+					   IRQ_POLICY_REDISTRIBUTED,
+					   NULL);
+	}
+
+	return changed ? 0 : ret;
+}
+EXPORT_SYMBOL_GPL(irq_policy_change);
+
+void irq_policy_apply(struct irq_desc *desc)
+{
+	assert_raw_spin_locked(&desc->lock);
+	mutex_lock(&irq_policy_mutex);
+	current_irq_policy->apply(desc);
+	mutex_unlock(&irq_policy_mutex);
+}
+EXPORT_SYMBOL_GPL(irq_policy_apply);
+
+void __init init_irq_policy(void)
+{
+	mutex_lock(&irq_policy_mutex);
+	if (current_irq_policy == NULL)
+		current_irq_policy = &irq_policies[IRQ_POLICY_DEFAULT];
+	mutex_unlock(&irq_policy_mutex);
+}
+
+static int __init irq_policy_setup(char* str)
+{
+	if (irq_policy_select(str))
+		return 0;
+	return 1;
+}
+
+__setup("irq_policy=", irq_policy_setup);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 09a2ee5..64db2b8 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/irq_policy.h>
 
 #include "internals.h"
 
@@ -181,6 +182,55 @@ static const struct file_operations default_affinity_proc_fops = {
 	.write		= default_affinity_write,
 };
 
+#define MAX_IRQ_POLICY_WRITE	31
+
+static ssize_t irq_policy_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char lbuf[MAX_IRQ_POLICY_WRITE + 1], *tmp;
+	size_t ret;
+
+	if (count > MAX_IRQ_POLICY_WRITE)
+		return -EINVAL;
+	if (copy_from_user(lbuf, buf, count))
+		return -EFAULT;
+
+	 lbuf[MAX_IRQ_POLICY_WRITE] = '\0';
+
+	tmp = strchr(lbuf, '\n');
+	if (tmp)
+		*tmp = '\0';
+
+	ret = irq_policy_change(lbuf);
+
+	return ret ? ret : count;
+}
+
+static int irq_policy_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_policy_show, NULL);
+}
+
+static const struct file_operations irq_policy_proc_fops = {
+	.open		= irq_policy_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+	.write		= irq_policy_write,
+};
+
+static int available_irq_policy_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, available_irq_policy_show, NULL);
+}
+
+static const struct file_operations available_irq_policy_proc_fops = {
+	.open		= available_irq_policy_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int irq_node_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long) m->private);
@@ -316,6 +366,15 @@ static void register_default_affinity_proc(void)
 #endif
 }
 
+static void register_policy_proc(void)
+{
+#ifdef CONFIG_SMP
+	proc_create("irq/irq_policy", 0644, NULL, &irq_policy_proc_fops);
+	proc_create("irq/available_irq_policies", 0444, NULL,
+		    &available_irq_policy_proc_fops);
+#endif
+}
+
 void init_irq_proc(void)
 {
 	unsigned int irq;
@@ -328,6 +387,8 @@ void init_irq_proc(void)
 
 	register_default_affinity_proc();
 
+	register_policy_proc();
+
 	/*
 	 * Create entries for all existing IRQs.
 	 */
