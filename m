Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1BFVq2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 16:46:28 -0500
Received: from www.tglx.de ([62.245.132.106]:45939 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1BFVqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 16:46:05 -0500
Message-Id: <20110206214534.857993623@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 06 Feb 2011 21:45:51 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch 5/7] mn10300: Convert ipi irq_chip to new functions
References: <20110206214441.438777646@linutronix.de>
Content-Disposition: inline; filename=mn10300-convert-ip-chip.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/smp.c |   30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

Index: linux-next/arch/mn10300/kernel/smp.c
===================================================================
--- linux-next.orig/arch/mn10300/kernel/smp.c
+++ linux-next/arch/mn10300/kernel/smp.c
@@ -113,15 +113,17 @@ static void init_ipi(void);
  */
 static void mn10300_ipi_disable(unsigned int irq);
 static void mn10300_ipi_enable(unsigned int irq);
-static void mn10300_ipi_ack(unsigned int irq);
-static void mn10300_ipi_nop(unsigned int irq);
+static void mn10300_ipi_chip_disable(struct irq_data *d);
+static void mn10300_ipi_chip_enable(struct irq_data *d);
+static void mn10300_ipi_ack(struct irq_data *d);
+static void mn10300_ipi_nop(struct irq_data *d);
 
 static struct irq_chip mn10300_ipi_type = {
 	.name		= "cpu_ipi",
-	.disable	= mn10300_ipi_disable,
-	.enable		= mn10300_ipi_enable,
-	.ack		= mn10300_ipi_ack,
-	.eoi		= mn10300_ipi_nop
+	.irq_disable	= mn10300_ipi_chip_disable,
+	.irq_enable	= mn10300_ipi_chip_enable,
+	.irq_ack	= mn10300_ipi_ack,
+	.irq_eoi	= mn10300_ipi_nop
 };
 
 static irqreturn_t smp_reschedule_interrupt(int irq, void *dev_id);
@@ -236,6 +238,11 @@ static void mn10300_ipi_enable(unsigned 
 	arch_local_irq_restore(flags);
 }
 
+static void mn10300_ipi_chip_enable(struct irq_data *d)
+{
+	mn10300_ipi_enable(d->irq);
+}
+
 /**
  * mn10300_ipi_disable - Disable an IPI
  * @irq: The IPI to be disabled.
@@ -254,6 +261,12 @@ static void mn10300_ipi_disable(unsigned
 	arch_local_irq_restore(flags);
 }
 
+static void mn10300_ipi_chip_disable(struct irq_data *d)
+{
+	mn10300_ipi_disable(d->irq);
+}
+
+
 /**
  * mn10300_ipi_ack - Acknowledge an IPI interrupt in the PIC
  * @irq: The IPI to be acknowledged.
@@ -261,8 +274,9 @@ static void mn10300_ipi_disable(unsigned
  * Clear the interrupt detection flag for the IPI on the appropriate interrupt
  * channel in the PIC.
  */
-static void mn10300_ipi_ack(unsigned int irq)
+static void mn10300_ipi_ack(struct irq_data *d)
 {
+	unsigned int irq = d->irq;
 	unsigned long flags;
 	u16 tmp;
 
@@ -276,7 +290,7 @@ static void mn10300_ipi_ack(unsigned int
  * mn10300_ipi_nop - Dummy IPI action
  * @irq: The IPI to be acted upon.
  */
-static void mn10300_ipi_nop(unsigned int irq)
+static void mn10300_ipi_nop(struct irq_data *d)
 {
 }
 


