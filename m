Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2BICDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:03:22 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757004Ab2BICCC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:02:02 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UBy9sU4F98IA:10 a=wPM5aPaKJEIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=J8QeD3RCaqlNv1uLYfMA:9 a=2uZ1pyZOtoIJlK_bGWsA:7 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120209020200.293883108@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 08 Feb 2012 20:59:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, stable-rt@vger.kernel.org
Subject: [PATCH RT 6/8] genirq: Allow disabling of softirq processing in irq thread context
References: <20120209015926.851312665@goodmis.org>
Content-Disposition: inline; filename=0006-genirq-Allow-disabling-of-softirq-processing-in-irq-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

The processing of softirqs in irq thread context is a performance gain
for the non-rt workloads of a system, but it's counterproductive for
interrupts which are explicitely related to the realtime
workload. Allow such interrupts to prevent softirq processing in their
thread context.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/interrupt.h |    2 ++
 include/linux/irq.h       |    4 +++-
 kernel/irq/manage.c       |   13 ++++++++++++-
 kernel/irq/settings.h     |   12 ++++++++++++
 kernel/softirq.c          |    7 +++++++
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 3142442..71c2c0b 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -61,6 +61,7 @@
  * IRQF_NO_THREAD - Interrupt cannot be threaded
  * IRQF_EARLY_RESUME - Resume IRQ early during syscore instead of at device
  *                resume time.
+ * IRQF_NO_SOFTIRQ_CALL - Do not process softirqs in the irq thread context (RT)
  */
 #define IRQF_DISABLED		0x00000020
 #define IRQF_SAMPLE_RANDOM	0x00000040
@@ -75,6 +76,7 @@
 #define IRQF_FORCE_RESUME	0x00008000
 #define IRQF_NO_THREAD		0x00010000
 #define IRQF_EARLY_RESUME	0x00020000
+#define IRQF_NO_SOFTIRQ_CALL	0x00040000
 
 #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND | IRQF_NO_THREAD)
 
diff --git a/include/linux/irq.h b/include/linux/irq.h
index baa397e..2df0acc 100644
--- a/include/linux/irq.h
+++ b/include/linux/irq.h
@@ -65,6 +65,7 @@ typedef	void (*irq_preflow_handler_t)(struct irq_data *data);
  * IRQ_NO_BALANCING		- Interrupt cannot be balanced (affinity set)
  * IRQ_MOVE_PCNTXT		- Interrupt can be migrated from process context
  * IRQ_NESTED_TRHEAD		- Interrupt nests into another thread
+ * IRQ_NO_SOFTIRQ_CALL		- No softirq processing in the irq thread context (RT)
  */
 enum {
 	IRQ_TYPE_NONE		= 0x00000000,
@@ -87,12 +88,13 @@ enum {
 	IRQ_MOVE_PCNTXT		= (1 << 14),
 	IRQ_NESTED_THREAD	= (1 << 15),
 	IRQ_NOTHREAD		= (1 << 16),
+	IRQ_NO_SOFTIRQ_CALL	= (1 << 18),
 };
 
 #define IRQF_MODIFY_MASK	\
 	(IRQ_TYPE_SENSE_MASK | IRQ_NOPROBE | IRQ_NOREQUEST | \
 	 IRQ_NOAUTOEN | IRQ_MOVE_PCNTXT | IRQ_LEVEL | IRQ_NO_BALANCING | \
-	 IRQ_PER_CPU | IRQ_NESTED_THREAD)
+	 IRQ_PER_CPU | IRQ_NESTED_THREAD | IRQ_NO_SOFTIRQ_CALL)
 
 #define IRQ_NO_BALANCING_MASK	(IRQ_PER_CPU | IRQ_NO_BALANCING)
 
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 3eb233e..cd98592 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -739,7 +739,15 @@ irq_forced_thread_fn(struct irq_desc *desc, struct irqaction *action)
 	local_bh_disable();
 	ret = action->thread_fn(action->irq, action->dev_id);
 	irq_finalize_oneshot(desc, action, false);
-	local_bh_enable();
+	/*
+	 * Interrupts which have real time requirements can be set up
+	 * to avoid softirq processing in the thread handler. This is
+	 * safe as these interrupts do not raise soft interrupts.
+	 */
+	if (irq_settings_no_softirq_call(desc))
+		_local_bh_enable();
+	else
+		local_bh_enable();
 	return ret;
 }
 
@@ -1031,6 +1039,9 @@ __setup_irq(unsigned int irq, struct irq_desc *desc, struct irqaction *new)
 			irqd_set(&desc->irq_data, IRQD_NO_BALANCING);
 		}
 
+		if (new->flags & IRQF_NO_SOFTIRQ_CALL)
+			irq_settings_set_no_softirq_call(desc);
+
 		/* Set default affinity mask once everything is setup */
 		setup_affinity(irq, desc, mask);
 
diff --git a/kernel/irq/settings.h b/kernel/irq/settings.h
index f166783..e1f617f 100644
--- a/kernel/irq/settings.h
+++ b/kernel/irq/settings.h
@@ -13,6 +13,7 @@ enum {
 	_IRQ_MOVE_PCNTXT	= IRQ_MOVE_PCNTXT,
 	_IRQ_NO_BALANCING	= IRQ_NO_BALANCING,
 	_IRQ_NESTED_THREAD	= IRQ_NESTED_THREAD,
+	_IRQ_NO_SOFTIRQ_CALL	= IRQ_NO_SOFTIRQ_CALL,
 	_IRQF_MODIFY_MASK	= IRQF_MODIFY_MASK,
 };
 
@@ -24,6 +25,7 @@ enum {
 #define IRQ_NOTHREAD		GOT_YOU_MORON
 #define IRQ_NOAUTOEN		GOT_YOU_MORON
 #define IRQ_NESTED_THREAD	GOT_YOU_MORON
+#define IRQ_NO_SOFTIRQ_CALL	GOT_YOU_MORON
 #undef IRQF_MODIFY_MASK
 #define IRQF_MODIFY_MASK	GOT_YOU_MORON
 
@@ -34,6 +36,16 @@ irq_settings_clr_and_set(struct irq_desc *desc, u32 clr, u32 set)
 	desc->status_use_accessors |= (set & _IRQF_MODIFY_MASK);
 }
 
+static inline bool irq_settings_no_softirq_call(struct irq_desc *desc)
+{
+	return desc->status_use_accessors & _IRQ_NO_SOFTIRQ_CALL;
+}
+
+static inline void irq_settings_set_no_softirq_call(struct irq_desc *desc)
+{
+	desc->status_use_accessors |= _IRQ_NO_SOFTIRQ_CALL;
+}
+
 static inline bool irq_settings_is_per_cpu(struct irq_desc *desc)
 {
 	return desc->status_use_accessors & _IRQ_PER_CPU;
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 3489d06..729cd0c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -431,6 +431,13 @@ void local_bh_enable_ip(unsigned long ip)
 }
 EXPORT_SYMBOL(local_bh_enable_ip);
 
+void _local_bh_enable(void)
+{
+	current->softirq_nestcnt--;
+	migrate_enable();
+}
+EXPORT_SYMBOL(_local_bh_enable);
+
 /* For tracing */
 int notrace __in_softirq(void)
 {
-- 
1.7.8.3


