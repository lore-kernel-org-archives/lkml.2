Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0ECJy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 05:54:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:58163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0ECJy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 05:54:57 -0400
Date: Mon, 3 May 2010 09:54:36 GMT
From: tip-bot for Peter P Waskiewicz Jr 
	<peter.p.waskiewicz.jr@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       peter.p.waskiewicz.jr@intel.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       peter.p.waskiewicz.jr@intel.com, tglx@linutronix.de
In-Reply-To: <20100430214445.3992.41647.stgit@ppwaskie-hc2.jf.intel.com>
References: <20100430214445.3992.41647.stgit@ppwaskie-hc2.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] genirq: Add CPU mask affinity hint
Message-ID: <tip-e7a297b0d7d6049bd4e423ac1e17da31e4c401b8@git.kernel.org>
Git-Commit-ID: e7a297b0d7d6049bd4e423ac1e17da31e4c401b8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 03 May 2010 09:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e7a297b0d7d6049bd4e423ac1e17da31e4c401b8
Gitweb:     http://git.kernel.org/tip/e7a297b0d7d6049bd4e423ac1e17da31e4c401b8
Author:     Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
AuthorDate: Fri, 30 Apr 2010 14:44:50 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 3 May 2010 11:50:57 +0200

genirq: Add CPU mask affinity hint

This patch adds a cpumask affinity hint to the irq_desc structure,
along with a registration function and a read-only proc entry for each
interrupt.

This affinity_hint handle for each interrupt can be used by underlying
drivers that need a better mechanism to control interrupt affinity.
The underlying driver can register a cpumask for the interrupt, which
will allow the driver to provide the CPU mask for the interrupt to
anything that requests it.  The intent is to extend the userspace
daemon, irqbalance, to help hint to it a preferred CPU mask to balance
the interrupt into.

[ tglx: Fixed compile warnings, added WARN_ON, made SMP only ]

Signed-off-by: Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: davem@davemloft.net
Cc: arjan@linux.jf.intel.com
Cc: bhutchings@solarflare.com
LKML-Reference: <20100430214445.3992.41647.stgit@ppwaskie-hc2.jf.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    6 ++++++
 include/linux/irq.h       |    1 +
 kernel/irq/manage.c       |   22 ++++++++++++++++++++++
 kernel/irq/proc.c         |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+), 0 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index e6d2f44..5137db3 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -233,6 +233,7 @@ extern int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask);
 extern int irq_can_set_affinity(unsigned int irq);
 extern int irq_select_affinity(unsigned int irq);
 
+extern int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m);
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -247,6 +248,11 @@ static inline int irq_can_set_affinity(unsigned int irq)
 
 static inline int irq_select_affinity(unsigned int irq)  { return 0; }
 
+static inline int irq_set_affinity_hint(unsigned int irq,
+                                        const struct cpumask *m)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_SMP && CONFIG_GENERIC_HARDIRQS */
 
 #ifdef CONFIG_GENERIC_HARDIRQS
diff --git a/include/linux/irq.h b/include/linux/irq.h
index 707ab12..c03243a 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -195,6 +195,7 @@ struct irq_desc {
 	raw_spinlock_t		lock;
 #ifdef CONFIG_SMP
 	cpumask_var_t		affinity;
+	const struct cpumask	*affinity_hint;
 	unsigned int		node;
 #ifdef CONFIG_GENERIC_PENDING_IRQ
 	cpumask_var_t		pending_mask;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 444d5a8..3164ba7 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -138,6 +138,22 @@ int irq_set_affinity(unsigned int irq, const struct cpumask *cpumask)
 	return 0;
 }
 
+int irq_set_affinity_hint(unsigned int irq, const struct cpumask *m)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+	unsigned long flags;
+
+	if (!desc)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	desc->affinity_hint = m;
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity_hint);
+
 #ifndef CONFIG_AUTO_IRQ_AFFINITY
 /*
  * Generic version of the affinity autoselector.
@@ -906,6 +922,12 @@ static struct irqaction *__free_irq(unsigned int irq, void *dev_id)
 			desc->chip->disable(irq);
 	}
 
+#ifdef CONFIG_SMP
+	/* make sure affinity_hint is cleaned up */
+	if (WARN_ON_ONCE(desc->affinity_hint))
+		desc->affinity_hint = NULL;
+#endif
+
 	raw_spin_unlock_irqrestore(&desc->lock, flags);
 
 	unregister_handler_proc(irq, action);
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index fe92dc5..4f9427a 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -32,6 +32,29 @@ static int irq_affinity_proc_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+static int irq_affinity_hint_proc_show(struct seq_file *m, void *v)
+{
+	struct irq_desc *desc = irq_to_desc((long)m->private);
+	unsigned long flags;
+	cpumask_var_t mask;
+
+	if (!alloc_cpumask_var(&mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	raw_spin_lock_irqsave(&desc->lock, flags);
+	if (desc->affinity_hint)
+		cpumask_copy(mask, desc->affinity_hint);
+	else
+		cpumask_setall(mask);
+	raw_spin_unlock_irqrestore(&desc->lock, flags);
+
+	seq_cpumask(m, mask);
+	seq_putc(m, '\n');
+	free_cpumask_var(mask);
+
+	return 0;
+}
+
 #ifndef is_affinity_mask_valid
 #define is_affinity_mask_valid(val) 1
 #endif
@@ -84,6 +107,11 @@ static int irq_affinity_proc_open(struct inode *inode, struct file *file)
 	return single_open(file, irq_affinity_proc_show, PDE(inode)->data);
 }
 
+static int irq_affinity_hint_proc_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, irq_affinity_hint_proc_show, PDE(inode)->data);
+}
+
 static const struct file_operations irq_affinity_proc_fops = {
 	.open		= irq_affinity_proc_open,
 	.read		= seq_read,
@@ -92,6 +120,13 @@ static const struct file_operations irq_affinity_proc_fops = {
 	.write		= irq_affinity_proc_write,
 };
 
+static const struct file_operations irq_affinity_hint_proc_fops = {
+	.open		= irq_affinity_hint_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
 static int default_affinity_show(struct seq_file *m, void *v)
 {
 	seq_cpumask(m, irq_default_affinity);
@@ -252,6 +287,10 @@ void register_irq_proc(unsigned int irq, struct irq_desc *desc)
 	proc_create_data("smp_affinity", 0600, desc->dir,
 			 &irq_affinity_proc_fops, (void *)(long)irq);
 
+	/* create /proc/irq/<irq>/affinity_hint */
+	proc_create_data("affinity_hint", 0400, desc->dir,
+			 &irq_affinity_hint_proc_fops, (void *)(long)irq);
+
 	proc_create_data("node", 0444, desc->dir,
 			 &irq_node_proc_fops, (void *)(long)irq);
 #endif
