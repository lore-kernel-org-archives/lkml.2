Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325Ab0I3XRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:11 -0400
Received: from www.tglx.de ([62.245.132.106]:52753 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab0I3XRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:07 -0400
Message-Id: <20100930221741.032185985@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:42 -0000
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
Subject: [patch 26/47] x86: io_apic: Convert startup to new irq_chip function
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-convert-startup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -2232,11 +2232,10 @@ static int __init timer_irq_works(void)
  * an edge even if it isn't on the 8259A...
  */
 
-static unsigned int startup_ioapic_irq(unsigned int irq)
+static unsigned int startup_ioapic_irq(struct irq_data *data)
 {
-	int was_pending = 0;
+	int was_pending = 0, irq = data->irq;
 	unsigned long flags;
-	struct irq_cfg *cfg;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	if (irq < legacy_pic->nr_legacy_irqs) {
@@ -2244,8 +2243,7 @@ static unsigned int startup_ioapic_irq(u
 		if (legacy_pic->irq_pending(irq))
 			was_pending = 1;
 	}
-	cfg = irq_cfg(irq);
-	__unmask_ioapic(cfg);
+	__unmask_ioapic(data->chip_data);
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	return was_pending;
@@ -2709,7 +2707,7 @@ static void ir_ack_apic_level(unsigned i
 
 static struct irq_chip ioapic_chip __read_mostly = {
 	.name		= "IO-APIC",
-	.startup	= startup_ioapic_irq,
+	.irq_startup	= startup_ioapic_irq,
 	.mask		= mask_ioapic_irq,
 	.unmask		= unmask_ioapic_irq,
 	.ack		= ack_apic_edge,
@@ -2722,7 +2720,7 @@ static struct irq_chip ioapic_chip __rea
 
 static struct irq_chip ir_ioapic_chip __read_mostly = {
 	.name		= "IR-IO-APIC",
-	.startup	= startup_ioapic_irq,
+	.irq_startup	= startup_ioapic_irq,
 	.mask		= mask_ioapic_irq,
 	.unmask		= unmask_ioapic_irq,
 #ifdef CONFIG_INTR_REMAP


