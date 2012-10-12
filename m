Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab2JLBXJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 21:23:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752890Ab2JLBV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 21:21:27 -0400
X-Authority-Analysis: v=2.0 cv=a96yBDuF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XLHUghm2YIoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=4NeZhUYj7XsA:10 a=VwQbUJbxAAAA:8 a=jQ7QLwwa_tqRxytmtO8A:9 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-Id: <20121012012125.771525547@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Oct 2012 21:20:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 1/8] random: Make it work on rt
References: <20121012012024.056658930@goodmis.org>
Content-Disposition: inline; filename=0001-random-Make-it-work-on-rt.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

Delegate the random insertion to the forced threaded interrupt
handler. Store the return IP of the hard interrupt handler in the irq
descriptor and feed it into the random generator as a source of
entropy.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/char/random.c   |   10 ++++++----
 include/linux/irqdesc.h |    1 +
 include/linux/random.h  |    2 +-
 kernel/irq/handle.c     |    7 +++++--
 kernel/irq/manage.c     |    6 ++++++
 5 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d38af32..66c8a0f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -767,18 +767,16 @@ EXPORT_SYMBOL_GPL(add_input_randomness);
 
 static DEFINE_PER_CPU(struct fast_pool, irq_randomness);
 
-void add_interrupt_randomness(int irq, int irq_flags)
+void add_interrupt_randomness(int irq, int irq_flags, __u64 ip)
 {
 	struct entropy_store	*r;
 	struct fast_pool	*fast_pool = &__get_cpu_var(irq_randomness);
-	struct pt_regs		*regs = get_irq_regs();
 	unsigned long		now = jiffies;
 	__u32			input[4], cycles = get_cycles();
 
 	input[0] = cycles ^ jiffies;
 	input[1] = irq;
-	if (regs) {
-		__u64 ip = instruction_pointer(regs);
+	if (ip) {
 		input[2] = ip;
 		input[3] = ip >> 32;
 	}
@@ -792,7 +790,11 @@ void add_interrupt_randomness(int irq, int irq_flags)
 	fast_pool->last = now;
 
 	r = nonblocking_pool.initialized ? &input_pool : &nonblocking_pool;
+#ifndef CONFIG_PREEMPT_RT_FULL
 	__mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+#else
+	mix_pool_bytes(r, &fast_pool->pool, sizeof(fast_pool->pool), NULL);
+#endif
 	/*
 	 * If we don't have a valid cycle counter, and we see
 	 * back-to-back timer interrupts, then skip giving credit for
diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
index f1e2527..5f4f091 100644
--- a/include/linux/irqdesc.h
+++ b/include/linux/irqdesc.h
@@ -53,6 +53,7 @@ struct irq_desc {
 	unsigned int		irq_count;	/* For detecting broken IRQs */
 	unsigned long		last_unhandled;	/* Aging timer for unhandled count */
 	unsigned int		irqs_unhandled;
+	u64			random_ip;
 	raw_spinlock_t		lock;
 	struct cpumask		*percpu_enabled;
 #ifdef CONFIG_SMP
diff --git a/include/linux/random.h b/include/linux/random.h
index 29e217a..3995b33 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -53,7 +53,7 @@ extern void rand_initialize_irq(int irq);
 extern void add_device_randomness(const void *, unsigned int);
 extern void add_input_randomness(unsigned int type, unsigned int code,
 				 unsigned int value);
-extern void add_interrupt_randomness(int irq, int irq_flags);
+extern void add_interrupt_randomness(int irq, int irq_flags, __u64 ip);
 
 extern void get_random_bytes(void *buf, int nbytes);
 extern void get_random_bytes_arch(void *buf, int nbytes);
diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index a768885..f6b91bc 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -116,6 +116,8 @@ static void irq_wake_thread(struct irq_desc *desc, struct irqaction *action)
 irqreturn_t
 handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 {
+	struct pt_regs *regs = get_irq_regs();
+	u64 ip = regs ? instruction_pointer(regs) : 0;
 	irqreturn_t retval = IRQ_NONE;
 	unsigned int flags = 0, irq = desc->irq_data.irq;
 
@@ -157,8 +159,9 @@ handle_irq_event_percpu(struct irq_desc *desc, struct irqaction *action)
 	} while (action);
 
 #ifndef CONFIG_PREEMPT_RT_FULL
-	/* FIXME: Can we unbreak that ? */
-	add_interrupt_randomness(irq, flags);
+	add_interrupt_randomness(irq, flags, ip);
+#else
+	desc->random_ip = ip;
 #endif
 
 	if (!noirqdebug)
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 87dc053..2204340 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -816,6 +816,12 @@ static int irq_thread(void *data)
 			action_ret = handler_fn(desc, action);
 			if (!noirqdebug)
 				note_interrupt(action->irq, desc, action_ret);
+#ifdef CONFIG_PREEMPT_RT_FULL
+			migrate_disable();
+			add_interrupt_randomness(action->irq, 0,
+						 desc->random_ip ^ (u64) action);
+			migrate_enable();
+#endif
 		}
 
 		wake = atomic_dec_and_test(&desc->threads_active);
-- 
1.7.10.4


