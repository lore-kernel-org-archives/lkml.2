Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0I3XXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:23:15 -0400
Received: from www.tglx.de ([62.245.132.106]:52672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755695Ab0I3XQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:16:49 -0400
Message-Id: <20100930221740.736729370@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:25 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 23/47] x86: Cleanup visws interrupt handling
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-cleanup-visws.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the open coded access to irq_desc and convert to the new irq
chip functions. Change the mask function of piix4_virtual_irq_type so
we can use the generic irq handling function for the virtual interrupt
instead of open coding it.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/visws_quirks.c |  136 ++++++++++++-----------------------------
 1 file changed, 42 insertions(+), 94 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/visws_quirks.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/visws_quirks.c
+++ linux-2.6-tip/arch/x86/kernel/visws_quirks.c
@@ -66,10 +66,7 @@ static void __init visws_time_init(void)
 }
 
 /* Replaces the default init_ISA_irqs in the generic setup */
-static void __init visws_pre_intr_init(void)
-{
-	init_VISWS_APIC_irqs();
-}
+static void __init visws_pre_intr_init(void);
 
 /* Quirk for machine specific memory setup. */
 
@@ -429,67 +426,34 @@ static int is_co_apic(unsigned int irq)
 /*
  * This is the SGI Cobalt (IO-)APIC:
  */
-
-static void enable_cobalt_irq(unsigned int irq)
+static void enable_cobalt_irq(struct irq_data *data)
 {
-	co_apic_set(is_co_apic(irq), irq);
+	co_apic_set(is_co_apic(data->irq), data->irq);
 }
 
-static void disable_cobalt_irq(unsigned int irq)
+static void disable_cobalt_irq(struct irq_data *data)
 {
-	int entry = is_co_apic(irq);
+	int entry = is_co_apic(data->irq);
 
 	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
 	co_apic_read(CO_APIC_LO(entry));
 }
 
-/*
- * "irq" really just serves to identify the device.  Here is where we
- * map this to the Cobalt APIC entry where it's physically wired.
- * This is called via request_irq -> setup_irq -> irq_desc->startup()
- */
-static unsigned int startup_cobalt_irq(unsigned int irq)
-{
-	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	if ((desc->status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
-		desc->status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
-	enable_cobalt_irq(irq);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-	return 0;
-}
-
-static void ack_cobalt_irq(unsigned int irq)
+static void ack_cobalt_irq(struct irq_data *data)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(irq);
+	disable_cobalt_irq(data);
 	apic_write(APIC_EOI, APIC_EIO_ACK);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
-static void end_cobalt_irq(unsigned int irq)
-{
-	unsigned long flags;
-	struct irq_desc *desc = irq_to_desc(irq);
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	if (!(desc->status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_cobalt_irq(irq);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-}
-
 static struct irq_chip cobalt_irq_type = {
-	.name =		"Cobalt-APIC",
-	.startup =	startup_cobalt_irq,
-	.shutdown =	disable_cobalt_irq,
-	.enable =	enable_cobalt_irq,
-	.disable =	disable_cobalt_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_cobalt_irq,
+	.name		= "Cobalt-APIC",
+	.irq_enable	= enable_cobalt_irq,
+	.irq_disable	= disable_cobalt_irq,
+	.irq_ack	= ack_cobalt_irq,
 };
 
 
@@ -503,35 +467,34 @@ static struct irq_chip cobalt_irq_type =
  * interrupt controller type, and through a special virtual interrupt-
  * controller. Device drivers only see the virtual interrupt sources.
  */
-static unsigned int startup_piix4_master_irq(unsigned int irq)
+static unsigned int startup_piix4_master_irq(struct irq_data *data)
 {
 	legacy_pic->init(0);
-
-	return startup_cobalt_irq(irq);
+	enable_cobalt_irq(data);
 }
 
-static void end_piix4_master_irq(unsigned int irq)
+static void end_piix4_master_irq(struct irq_data *data)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(irq);
+	enable_cobalt_irq(data);
 	spin_unlock_irqrestore(&cobalt_lock, flags);
 }
 
 static struct irq_chip piix4_master_irq_type = {
-	.name =		"PIIX4-master",
-	.startup =	startup_piix4_master_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_piix4_master_irq,
+	.name		= "PIIX4-master",
+	.irq_startup	= startup_piix4_master_irq,
+	.irq_ack	= ack_cobalt_irq,
 };
 
+static void pii4_mask(struct irq_data *data) { }
 
 static struct irq_chip piix4_virtual_irq_type = {
-	.name =		"PIIX4-virtual",
+	.name		= "PIIX4-virtual",
+	.mask		= pii4_mask,
 };
 
-
 /*
  * PIIX4-8259 master/virtual functions to handle interrupt requests
  * from legacy devices: floppy, parallel, serial, rtc.
@@ -549,9 +512,8 @@ static struct irq_chip piix4_virtual_irq
  */
 static irqreturn_t piix4_master_intr(int irq, void *dev_id)
 {
-	int realirq;
-	struct irq_desc *desc;
 	unsigned long flags;
+	int realirq;
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
@@ -592,18 +554,10 @@ static irqreturn_t piix4_master_intr(int
 
 	raw_spin_unlock_irqrestore(&i8259A_lock, flags);
 
-	desc = irq_to_desc(realirq);
-
 	/*
 	 * handle this 'virtual interrupt' as a Cobalt one now.
 	 */
-	kstat_incr_irqs_this_cpu(realirq, desc);
-
-	if (likely(desc->action != NULL))
-		handle_IRQ_event(realirq, desc->action);
-
-	if (!(desc->status & IRQ_DISABLED))
-		legacy_pic->chip->unmask(realirq);
+	generic_handle_irq(realirq);
 
 	return IRQ_HANDLED;
 
@@ -624,41 +578,35 @@ static struct irqaction cascade_action =
 
 static inline void set_piix4_virtual_irq_type(void)
 {
-	piix4_virtual_irq_type.shutdown = i8259A_chip.mask;
 	piix4_virtual_irq_type.enable =	i8259A_chip.unmask;
 	piix4_virtual_irq_type.disable = i8259A_chip.mask;
+	piix4_virtual_irq_type.unmask =	i8259A_chip.unmask;
 }
 
-void init_VISWS_APIC_irqs(void)
+static void __init visws_pre_intr_init(void)
 {
 	int i;
 
+	set_piix4_virtual_irq_type();
+
 	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		struct irq_desc *desc = irq_to_desc(i);
+		struct irq_chip *chip = NULL;
 
-		desc->status = IRQ_DISABLED;
-		desc->action = 0;
-		desc->depth = 1;
+		if (i == 0)
+			chip = &cobalt_irq_type;
+		else if (i == CO_IRQ_IDE0)
+			chip = &cobalt_irq_type;
+		else if (i == CO_IRQ_IDE1)
+			>chip = &cobalt_irq_type;
+		else if (i == CO_IRQ_8259)
+			chip = &piix4_master_irq_type;
+		else if (i < CO_IRQ_APIC0)
+			chip = &piix4_virtual_irq_type;
+		else if (IS_CO_APIC(i))
+			chip = &cobalt_irq_type;
 
-		if (i == 0) {
-			desc->chip = &cobalt_irq_type;
-		}
-		else if (i == CO_IRQ_IDE0) {
-			desc->chip = &cobalt_irq_type;
-		}
-		else if (i == CO_IRQ_IDE1) {
-			desc->chip = &cobalt_irq_type;
-		}
-		else if (i == CO_IRQ_8259) {
-			desc->chip = &piix4_master_irq_type;
-		}
-		else if (i < CO_IRQ_APIC0) {
-			set_piix4_virtual_irq_type();
-			desc->chip = &piix4_virtual_irq_type;
-		}
-		else if (IS_CO_APIC(i)) {
-			desc->chip = &cobalt_irq_type;
-		}
+		if (chip)
+			set_irq_chip(i, chip);
 	}
 
 	setup_irq(CO_IRQ_8259, &master_action);


