Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab0KDRsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 13:48:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab0KDRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 13:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wOrKqWPp7fHtQI8mmU7GJAzvdGPc8z19p73SUS6+jrHVk2zQxnXigm6o4wCUMLIA1V
         0H68GCCdLgGxDSPYvU8JipsAXk3zHR+S+cCk4CzrikLvNpeVl+fyCKWAVim0VyVbbYHM
         xIBOwyRrZMKLaOaNr9vjSx9/rnMy9xKAmfqJc=
Subject: [PATCH] irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Nov 2010 18:48:28 +0100
Message-ID: <1288892908.2659.175.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use modern per_cpu API to increment {soft|hard}irq counters, and
use per_cpu allocation for (struct irq_desc)->kstats_irq instead of an
array.

This gives better SMP/NUMA locality and saves few instructions per irq.

With small nr_cpuids values (8 for example), kstats_irq was a small
array (less than L1_CACHE_BYTES), potentially source of false sharing.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/irqdesc.h     |    2 +-
 include/linux/kernel_stat.h |   21 ++++++++++-----------
 kernel/irq/irqdesc.c        |   16 +++++++++-------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index 979c68c..6a64c6f 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -57,7 +57,7 @@ struct irq_desc {
 #endif
 
 	struct timer_rand_state *timer_rand_state;
-	unsigned int		*kstat_irqs;
+	unsigned int __percpu	*kstat_irqs;
 	irq_flow_handler_t	handle_irq;
 	struct irqaction	*action;	/* IRQ action list */
 	unsigned int		status;		/* IRQ status */
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index ad54c84..acd97a3 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -31,7 +31,7 @@ struct cpu_usage_stat {
 struct kernel_stat {
 	struct cpu_usage_stat	cpustat;
 #ifndef CONFIG_GENERIC_HARDIRQS
-       unsigned int irqs[NR_IRQS];
+	unsigned int irqs[NR_IRQS];
 #endif
 	unsigned long irqs_sum;
 	unsigned int softirqs[NR_SOFTIRQS];
@@ -46,41 +46,40 @@ DECLARE_PER_CPU(struct kernel_stat, kstat);
 extern unsigned long long nr_context_switches(void);
 
 #ifndef CONFIG_GENERIC_HARDIRQS
-#define kstat_irqs_this_cpu(irq) \
-	(kstat_this_cpu.irqs[irq])
+#define kstat_irqs_this_cpu(irq) __this_cpu_read(kstat.irqs[irq])
 
 struct irq_desc;
 
 static inline void kstat_incr_irqs_this_cpu(unsigned int irq,
 					    struct irq_desc *desc)
 {
-	kstat_this_cpu.irqs[irq]++;
-	kstat_this_cpu.irqs_sum++;
+	__this_cpu_inc(kstat.irqs[irq]);
+	__this_cpu_inc(kstat.irqs_sum);
 }
 
 static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
-       return kstat_cpu(cpu).irqs[irq];
+	return kstat_cpu(cpu).irqs[irq];
 }
 #else
 #include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
 #define kstat_irqs_this_cpu(DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()])
+	__this_cpu_read((DESC)->kstat_irqs)
 #define kstat_incr_irqs_this_cpu(irqno, DESC) do {\
-	((DESC)->kstat_irqs[smp_processor_id()]++);\
-	kstat_this_cpu.irqs_sum++; } while (0)
+	__this_cpu_inc((DESC)->kstat_irqs);\
+	__this_cpu_inc(kstat.irqs_sum); } while (0)
 
 #endif
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
-	kstat_this_cpu.softirqs[irq]++;
+	__this_cpu_inc(kstat.softirqs[irq]);
 }
 
 static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
 {
-       return kstat_cpu(cpu).softirqs[irq];
+	return kstat_cpu(cpu).softirqs[irq];
 }
 
 /*
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9988d03..7683422 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -72,6 +72,8 @@ static inline int desc_node(struct irq_desc *desc) { return 0; }
 
 static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 {
+	int cpu;
+
 	desc->irq_data.irq = irq;
 	desc->irq_data.chip = &no_irq_chip;
 	desc->irq_data.chip_data = NULL;
@@ -83,7 +85,8 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node)
 	desc->irq_count = 0;
 	desc->irqs_unhandled = 0;
 	desc->name = NULL;
-	memset(desc->kstat_irqs, 0, nr_cpu_ids * sizeof(*(desc->kstat_irqs)));
+	for_each_possible_cpu(cpu)
+			*per_cpu_ptr(desc->kstat_irqs, cpu) = 0;
 	desc_smp_init(desc, node);
 }
 
@@ -133,8 +136,7 @@ static struct irq_desc *alloc_desc(int irq, int node)
 	if (!desc)
 		return NULL;
 	/* allocate based on nr_cpu_ids */
-	desc->kstat_irqs = kzalloc_node(nr_cpu_ids * sizeof(*desc->kstat_irqs),
-					 gfp, node);
+	desc->kstat_irqs = alloc_percpu(unsigned int);
 	if (!desc->kstat_irqs)
 		goto err_desc;
 
@@ -149,7 +151,7 @@ static struct irq_desc *alloc_desc(int irq, int node)
 	return desc;
 
 err_kstat:
-	kfree(desc->kstat_irqs);
+	free_percpu(desc->kstat_irqs);
 err_desc:
 	kfree(desc);
 	return NULL;
@@ -166,7 +168,7 @@ static void free_desc(unsigned int irq)
 	mutex_unlock(&sparse_irq_lock);
 
 	free_masks(desc);
-	kfree(desc->kstat_irqs);
+	free_percpu(desc->kstat_irqs);
 	kfree(desc);
 }
 
@@ -391,7 +393,7 @@ void dynamic_irq_cleanup(unsigned int irq)
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	return desc ? desc->kstat_irqs[cpu] : 0;
+	return desc ? *per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
 }
 
 #ifdef CONFIG_GENERIC_HARDIRQS
@@ -404,7 +406,7 @@ unsigned int kstat_irqs(unsigned int irq)
 	if (!desc)
 		return 0;
 	for_each_possible_cpu(cpu)
-		sum += desc->kstat_irqs[cpu];
+		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
 	return sum;
 }
 #endif /* CONFIG_GENERIC_HARDIRQS */


