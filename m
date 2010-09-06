Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0IFXie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 19:38:34 -0400
Received: from relay3.sgi.com ([192.48.152.1]:42417 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751657Ab0IFXia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 19:38:30 -0400
Date: Mon, 6 Sep 2010 16:38:27 -0700
From: Arthur Kepner <akepner@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Subject: [RFC/PATCH] kernel/irq: allow more precise irq affinity policies
Message-ID: <20100906233827.GB12956@sgi.com>
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
number of CPUS, and because of how the default irq affinity is used.

The following patch allows for a more precise policy about how irq 
affinities are assigned by the kernel (though it doesn't implement 
any new policy, except for a practically useless example).

This is a work in progress. I know that it needs several additional 
things, including:

	- redistribute interrupts when the 'current_irq_policy' is 
	  updated (for now it only affects irqs allocated after the 
	  policy is changed)

	- a means to notify drivers about irq_policy changes (so 
	  they can adjust network queues, etc.)

Would appreciate comments.

---

 include/linux/irq_policy.h |   21 +++++++++++
 init/Kconfig               |    8 ++++
 kernel/irq/Makefile        |    2 -
 kernel/irq/handle.c        |    5 ++
 kernel/irq/manage.c        |    3 +
 kernel/irq/policy.c        |   84 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/irq/proc.c          |   52 +++++++++++++++++++++++++++
 7 files changed, 173 insertions(+), 2 deletions(-)
diff --git a/include/linux/irq_policy.h b/include/linux/irq_policy.h
new file mode 100644
index 0000000..5708088
--- /dev/null
+++ b/include/linux/irq_policy.h
@@ -0,0 +1,21 @@
+#ifndef _LINUX_IRQ_POLICY_H
+#define _LINUX_IRQ_POLICY_H
+
+struct irq_policy {
+	char *name;
+	void (*apply) (struct cpumask *); /* apply the policy */
+};
+
+extern struct irq_policy *current_irq_policy;
+extern struct mutex irq_policy_mutex; /* protect current_irq_policy */
+
+void __init init_irq_policy(void);
+void irq_policy_select(char *str);
+void irq_policy_apply(struct cpumask *dest);
+
+void apply_default(struct cpumask *dest);
+#ifdef CONFIG_IRQ_POLICY_1
+void apply_policy1(struct cpumask *dest);
+#endif /* CONFIG_IRQ_POLICY_1 */
+
+#endif /* _LINUX_IRQ_POLICY_H */
diff --git a/init/Kconfig b/init/Kconfig
index 2de5b1c..d38f18b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1263,4 +1263,12 @@ config PADATA
 	depends on SMP
 	bool
 
+config IRQ_POLICY_1
+	bool
+	default n
+	depends on SMP
+	help
+	  Silly example - place all interrupts on CPU1. Not intended for
+	  real use. Say N.
+
 source "kernel/Kconfig.locks"
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
index c3003e9..06533e3 100644
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
+	irq_policy_apply(desc->affinity);
 set_affinity:
 	desc->chip->set_affinity(irq, desc->affinity);
 
diff --git a/kernel/irq/policy.c b/kernel/irq/policy.c
new file mode 100644
index 0000000..45a186b
--- /dev/null
+++ b/kernel/irq/policy.c
@@ -0,0 +1,84 @@
+
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+#include <linux/proc_fs.h>
+#include <linux/string.h>
+#include <linux/interrupt.h>
+#include <linux/irq_policy.h>
+
+struct irq_policy *current_irq_policy;
+DEFINE_MUTEX(irq_policy_mutex); /* protect current_irq_policy */
+
+#define IRQ_POLICY_DEFAULT 0
+
+struct irq_policy irq_policies[] = {
+	{
+		.name = "default",
+		.apply = apply_default,
+	},
+#ifdef CONFIG_IRQ_POLICY_1
+	{
+		.name = "policy1",
+		.apply = apply_policy1,
+	},
+#endif /* CONFIG_IRQ_POLICY_1 */
+};
+
+void irq_policy_select(char *str)
+{
+	int i, imax = sizeof(irq_policies) / sizeof(irq_policies[0]);
+
+	for (i = 0; i < imax; i++)
+		if (!strcmp(irq_policies[i].name, str))
+			break;
+
+	if (i < imax) {
+		mutex_lock(&irq_policy_mutex);
+		current_irq_policy = &irq_policies[i];
+		mutex_unlock(&irq_policy_mutex);
+	}
+}
+EXPORT_SYMBOL(irq_policy_select);
+
+#ifdef CONFIG_IRQ_POLICY_1
+void apply_policy1(struct cpumask *dest)
+{
+	struct cpumask tmp;
+	cpumask_clear(&tmp);
+	cpumask_set_cpu(1, &tmp);
+	cpumask_and(dest, cpu_online_mask, &tmp);
+}
+#endif /* CONFIG_IRQ_POLICY_1 */
+
+void apply_default(struct cpumask *dest)
+{
+	cpumask_and(dest, cpu_online_mask, irq_default_affinity);
+}
+
+void irq_policy_apply(struct cpumask *dest)
+{
+	mutex_lock(&irq_policy_mutex);
+	current_irq_policy->apply(dest);
+	mutex_unlock(&irq_policy_mutex);
+}
+EXPORT_SYMBOL_GPL(irq_policy_apply);
+
+void __init init_irq_policy(void)
+{
+	if (current_irq_policy == NULL)
+		current_irq_policy = &irq_policies[IRQ_POLICY_DEFAULT];
+}
+
+
+static int __init irq_policy_setup(char* str)
+{
+	irq_policy_select(str);
+	return 1;
+}
+
+__setup("irq_policy=", irq_policy_setup);
+
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 09a2ee5..bef45ea 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -11,6 +11,7 @@
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/interrupt.h>
+#include <linux/irq_policy.h>
 
 #include "internals.h"
 
@@ -181,6 +182,48 @@ static const struct file_operations default_affinity_proc_fops = {
 	.write		= default_affinity_write,
 };
 
+static int irq_policy_show(struct seq_file *m, void *v)
+{
+	mutex_lock(&irq_policy_mutex);
+	seq_printf(m, "%s\n", current_irq_policy->name);
+	mutex_unlock(&irq_policy_mutex);
+	return 0;
+}
+
+static ssize_t irq_policy_write(struct file *file, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	char lbuf[32];
+	size_t ret = count;
+
+	if (count >= sizeof(lbuf))
+		count = sizeof(lbuf) - 1;
+
+	if (buf[count-1] == '\n')
+		count--;
+
+	if (copy_from_user(lbuf, buf, count))
+		return -EFAULT;
+	lbuf[count] = '\0';
+
+	irq_policy_select(lbuf);
+
+	return ret;
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
 static int irq_node_proc_show(struct seq_file *m, void *v)
 {
 	struct irq_desc *desc = irq_to_desc((long) m->private);
@@ -316,6 +359,13 @@ static void register_default_affinity_proc(void)
 #endif
 }
 
+static void register_policy_proc(void)
+{
+#ifdef CONFIG_SMP
+	proc_create("irq/irq_policy", 0600, NULL, &irq_policy_proc_fops);
+#endif
+}
+
 void init_irq_proc(void)
 {
 	unsigned int irq;
@@ -328,6 +378,8 @@ void init_irq_proc(void)
 
 	register_default_affinity_proc();
 
+	register_policy_proc();
+
 	/*
 	 * Create entries for all existing IRQs.
 	 */
