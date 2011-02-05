Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab1BEUJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:09:04 -0500
Received: from www.tglx.de ([62.245.132.106]:44508 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1BEUJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:09:00 -0500
Message-Id: <20110205200703.925495018@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sat, 05 Feb 2011 20:08:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 2/4] xen: Switch to new irq_chip functions
References: <20110205200108.921707839@linutronix.de>
Content-Disposition: inline; filename=xen-switch-to-new-irq-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert Xen to the new irq_chip functions. Brings us closer to enable
CONFIG_GENERIC_HARDIRQS_NO_DEPRECATED

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/xen/events.c |   97 +++++++++++++++++++++++++++------------------------
 1 file changed, 52 insertions(+), 45 deletions(-)

Index: linux-next/drivers/xen/events.c
===================================================================
--- linux-next.orig/drivers/xen/events.c
+++ linux-next/drivers/xen/events.c
@@ -277,7 +277,7 @@ static void bind_evtchn_to_cpu(unsigned 
 
 	BUG_ON(irq == -1);
 #ifdef CONFIG_SMP
-	cpumask_copy(irq_to_desc(irq)->affinity, cpumask_of(cpu));
+	cpumask_copy(irq_to_desc(irq)->irq_data.affinity, cpumask_of(cpu));
 #endif
 
 	clear_bit(chn, cpu_evtchn_mask(cpu_from_irq(irq)));
@@ -294,7 +294,7 @@ static void init_evtchn_cpu_bindings(voi
 
 	/* By default all event channels notify CPU#0. */
 	for_each_irq_desc(i, desc) {
-		cpumask_copy(desc->affinity, cpumask_of(0));
+		cpumask_copy(desc->irq_data.affinity, cpumask_of(0));
 	}
 #endif
 
@@ -470,7 +470,7 @@ static bool probing_irq(int irq)
 	return desc && desc->action == NULL;
 }
 
-static unsigned int startup_pirq(unsigned int irq)
+static unsigned int __startup_pirq(unsigned int irq)
 {
 	struct evtchn_bind_pirq bind_pirq;
 	struct irq_info *info = info_for_irq(irq);
@@ -508,9 +508,15 @@ out:
 	return 0;
 }
 
-static void shutdown_pirq(unsigned int irq)
+static unsigned int startup_pirq(struct irq_data *data)
+{
+	return __startup_pirq(data->irq);
+}
+
+static void shutdown_pirq(struct irq_data *data)
 {
 	struct evtchn_close close;
+	unsigned int irq = data->irq;
 	struct irq_info *info = info_for_irq(irq);
 	int evtchn = evtchn_from_irq(irq);
 
@@ -530,20 +536,20 @@ static void shutdown_pirq(unsigned int i
 	info->evtchn = 0;
 }
 
-static void enable_pirq(unsigned int irq)
+static void enable_pirq(struct irq_data *data)
 {
-	startup_pirq(irq);
+	startup_pirq(data);
 }
 
-static void disable_pirq(unsigned int irq)
+static void disable_pirq(struct irq_data *data)
 {
 }
 
-static void ack_pirq(unsigned int irq)
+static void ack_pirq(struct irq_data *data)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(data->irq);
 
-	move_native_irq(irq);
+	irq_move_irq(data);
 
 	if (VALID_EVTCHN(evtchn)) {
 		mask_evtchn(evtchn);
@@ -1211,11 +1217,12 @@ static int rebind_irq_to_cpu(unsigned ir
 	return 0;
 }
 
-static int set_affinity_irq(unsigned irq, const struct cpumask *dest)
+static int set_affinity_irq(struct irq_data *data, const struct cpumask *dest,
+			    bool force)
 {
 	unsigned tcpu = cpumask_first(dest);
 
-	return rebind_irq_to_cpu(irq, tcpu);
+	return rebind_irq_to_cpu(data->irq, tcpu);
 }
 
 int resend_irq_on_evtchn(unsigned int irq)
@@ -1234,35 +1241,35 @@ int resend_irq_on_evtchn(unsigned int ir
 	return 1;
 }
 
-static void enable_dynirq(unsigned int irq)
+static void enable_dynirq(struct irq_data *data)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(data->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static void disable_dynirq(unsigned int irq)
+static void disable_dynirq(struct irq_data *data)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(data->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		mask_evtchn(evtchn);
 }
 
-static void ack_dynirq(unsigned int irq)
+static void ack_dynirq(struct irq_data *data)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(data->irq);
 
-	move_masked_irq(irq);
+	move_masked_irq(data->irq);
 
 	if (VALID_EVTCHN(evtchn))
 		unmask_evtchn(evtchn);
 }
 
-static int retrigger_dynirq(unsigned int irq)
+static int retrigger_dynirq(struct irq_data *data)
 {
-	int evtchn = evtchn_from_irq(irq);
+	int evtchn = evtchn_from_irq(data->irq);
 	struct shared_info *sh = HYPERVISOR_shared_info;
 	int ret = 0;
 
@@ -1311,7 +1318,7 @@ static void restore_cpu_pirqs(void)
 
 		printk(KERN_DEBUG "xen: --> irq=%d, pirq=%d\n", irq, map_irq.pirq);
 
-		startup_pirq(irq);
+		__startup_pirq(irq);
 	}
 }
 
@@ -1463,44 +1470,44 @@ void xen_irq_resume(void)
 }
 
 static struct irq_chip xen_dynamic_chip __read_mostly = {
-	.name		= "xen-dyn",
+	.name			= "xen-dyn",
 
-	.disable	= disable_dynirq,
-	.mask		= disable_dynirq,
-	.unmask		= enable_dynirq,
-
-	.eoi		= ack_dynirq,
-	.set_affinity	= set_affinity_irq,
-	.retrigger	= retrigger_dynirq,
+	.irq_disable		= disable_dynirq,
+	.irq_mask		= disable_dynirq,
+	.irq_unmask		= enable_dynirq,
+
+	.irq_eoi		= ack_dynirq,
+	.irq_set_affinity	= set_affinity_irq,
+	.irq_retrigger		= retrigger_dynirq,
 };
 
 static struct irq_chip xen_pirq_chip __read_mostly = {
-	.name		= "xen-pirq",
+	.name			= "xen-pirq",
 
-	.startup	= startup_pirq,
-	.shutdown	= shutdown_pirq,
+	.irq_startup		= startup_pirq,
+	.irq_shutdown		= shutdown_pirq,
 
-	.enable		= enable_pirq,
-	.unmask		= enable_pirq,
+	.irq_enable		= enable_pirq,
+	.irq_unmask		= enable_pirq,
 
-	.disable	= disable_pirq,
-	.mask		= disable_pirq,
+	.irq_disable		= disable_pirq,
+	.irq_mask		= disable_pirq,
 
-	.ack		= ack_pirq,
+	.irq_ack		= ack_pirq,
 
-	.set_affinity	= set_affinity_irq,
+	.irq_set_affinity	= set_affinity_irq,
 
-	.retrigger	= retrigger_dynirq,
+	.irq_retrigger		= retrigger_dynirq,
 };
 
 static struct irq_chip xen_percpu_chip __read_mostly = {
-	.name		= "xen-percpu",
+	.name			= "xen-percpu",
 
-	.disable	= disable_dynirq,
-	.mask		= disable_dynirq,
-	.unmask		= enable_dynirq,
+	.irq_disable		= disable_dynirq,
+	.irq_mask		= disable_dynirq,
+	.irq_unmask		= enable_dynirq,
 
-	.ack		= ack_dynirq,
+	.irq_ack		= ack_dynirq,
 };
 
 int xen_set_callback_via(uint64_t via)


