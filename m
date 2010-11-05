Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0KEQG6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:06:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48560 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719Ab0KEQG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:06:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Fj74+BUl/pkxTKyMGr+ompzcwNsFOoE7T3ivaAiS8U4TtGxsJmualt43gcxbazz1Nh
         i4YFzv9/ouSMz4W0WsSvi5H7Ft53dizLkfBRN6cocr+A0fXyh6dmmpRNswXZbYxp48Cp
         5Jupavl5wPpGAwzFMiV2zR66s7MCPKNMk13Oc=
Subject: [PATCH v2] irq: use per_cpu kstat_irqs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1288892908.2659.175.camel@edumazet-laptop>
References: <1288892908.2659.175.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 17:06:50 +0100
Message-ID: <1288973210.2882.733.camel@edumazet-laptop>
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

In the !CONFIG_SPARSE_IRQ case, remove the huge, NUMA/cache unfriendly
kstat_irqs_all[NR_IRQS][NR_CPUS] array.

Note : we still populate kstats_irq for all possible irqs in
early_irq_init(). We probably could use on-demand allocations.
(Code included in alloc_descs()).
Problem is not all IRQS are used with a prior alloc_descs() call.

kstat_irqs_this_cpu() is not used anymore, remove it.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
V2: support for !CONFIG_SPARSE_IRQ
    No white space changes.

Question : Is dynamic percpu allocator ready at this stage for all
arches ? The need is NR_IRQS*4 bytes of percpu memory for 
!CONFIG_SPARSE_IRQ


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
index ad54c84..0cce2db 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -46,16 +46,14 @@ DECLARE_PER_CPU(struct kernel_stat, kstat);
 extern unsigned long long nr_context_switches(void);
 
 #ifndef CONFIG_GENERIC_HARDIRQS
-#define kstat_irqs_this_cpu(irq) \
-	(kstat_this_cpu.irqs[irq])
 
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
@@ -65,17 +63,18 @@ static inline unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 #else
 #include <linux/irq.h>
 extern unsigned int kstat_irqs_cpu(unsigned int irq, int cpu);
-#define kstat_irqs_this_cpu(DESC) \
-	((DESC)->kstat_irqs[smp_processor_id()])
-#define kstat_incr_irqs_this_cpu(irqno, DESC) do {\
-	((DESC)->kstat_irqs[smp_processor_id()]++);\
-	kstat_this_cpu.irqs_sum++; } while (0)
+
+#define kstat_incr_irqs_this_cpu(irqno, DESC)		\
+do {							\
+	__this_cpu_inc(*(DESC)->kstat_irqs);		\
+	__this_cpu_inc(kstat.irqs_sum);			\
+} while (0)
 
 #endif
 
 static inline void kstat_incr_softirqs_this_cpu(unsigned int irq)
 {
-	kstat_this_cpu.softirqs[irq]++;
+	__this_cpu_inc(kstat.softirqs[irq]);
 }
 
 static inline unsigned int kstat_softirqs_cpu(unsigned int irq, int cpu)
diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index 9988d03..a789a22 100644
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
+		*per_cpu_ptr(desc->kstat_irqs, cpu) = 0;
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
 
@@ -234,7 +236,6 @@ struct irq_desc irq_desc[NR_IRQS] __cacheline_aligned_in_smp = {
 	}
 };
 
-static unsigned int kstat_irqs_all[NR_IRQS][NR_CPUS];
 int __init early_irq_init(void)
 {
 	int count, i, node = first_online_node;
@@ -250,7 +251,8 @@ int __init early_irq_init(void)
 	for (i = 0; i < count; i++) {
 		desc[i].irq_data.irq = i;
 		desc[i].irq_data.chip = &no_irq_chip;
-		desc[i].kstat_irqs = kstat_irqs_all[i];
+		/* TODO : do this allocation on-demand ... */
+		desc[i].kstat_irqs = alloc_percpu(unsigned int);
 		alloc_masks(desc + i, GFP_KERNEL, node);
 		desc_smp_init(desc + i, node);
 		lockdep_set_class(&desc[i].lock, &irq_desc_lock_class);
@@ -275,6 +277,22 @@ static void free_desc(unsigned int irq)
 
 static inline int alloc_descs(unsigned int start, unsigned int cnt, int node)
 {
+#if defined(CONFIG_KSTAT_IRQS_ONDEMAND)
+	struct irq_desc *desc;
+	unsigned int i;
+	
+	for (i = 0; i < cnt; i++) {
+		desc = irq_to_desc(start + i);
+		if (desc && !desc->kstat_irqs) {
+			unsigned int __percpu *stats = alloc_percpu(unsigned int);
+
+			if (!stats)
+				return -1;
+			if (cmpxchg(&desc->kstat_irqs, NULL, stats) != NULL)
+				free_percpu(stats);
+		}
+	}
+#endif
 	return start;
 }
 #endif /* !CONFIG_SPARSE_IRQ */
@@ -391,7 +409,9 @@ void dynamic_irq_cleanup(unsigned int irq)
 unsigned int kstat_irqs_cpu(unsigned int irq, int cpu)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
-	return desc ? desc->kstat_irqs[cpu] : 0;
+
+	return desc && desc->kstat_irqs ?
+			*per_cpu_ptr(desc->kstat_irqs, cpu) : 0;
 }
 
 #ifdef CONFIG_GENERIC_HARDIRQS
@@ -401,10 +421,10 @@ unsigned int kstat_irqs(unsigned int irq)
 	int cpu;
 	int sum = 0;
 
-	if (!desc)
+	if (!desc || !desc->kstat_irqs)
 		return 0;
 	for_each_possible_cpu(cpu)
-		sum += desc->kstat_irqs[cpu];
+		sum += *per_cpu_ptr(desc->kstat_irqs, cpu);
 	return sum;
 }
 #endif /* CONFIG_GENERIC_HARDIRQS */


