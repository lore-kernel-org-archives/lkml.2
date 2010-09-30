Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0I3XST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:18:19 -0400
Received: from www.tglx.de ([62.245.132.106]:53041 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756680Ab0I3XSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:13 -0400
Message-Id: <20100930221742.225366306@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:52 -0000
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
Subject: [patch 38/47] x86: Use sane enumeration
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-use-sane-enumeration.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of looping through all interrupts, use the bitmap lookup to
find the next.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -1179,7 +1179,7 @@ void __setup_vector_irq(int cpu)
 	 */
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
-	for_each_irq_nr(irq) {
+	for_each_active_irq(irq) {
 		cfg = get_irq_chip_data(irq);
 		if (!cfg)
 			continue;
@@ -1537,7 +1537,6 @@ __apicdebuginit(void) print_IO_APIC(void
 	union IO_APIC_reg_03 reg_03;
 	unsigned long flags;
 	struct irq_cfg *cfg;
-	struct irq_desc *desc;
 	unsigned int irq;
 
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
@@ -1624,10 +1623,10 @@ __apicdebuginit(void) print_IO_APIC(void
 	}
 	}
 	printk(KERN_DEBUG "IRQ to pin mappings:\n");
-	for_each_irq_desc(irq, desc) {
+	for_each_active_irq(irq) {
 		struct irq_pin_list *entry;
 
-		cfg = get_irq_desc_chip_data(desc);
+		cfg = get_irq_chip_data(irq);
 		if (!cfg)
 			continue;
 		entry = cfg->irq_2_pin;
@@ -2596,9 +2595,8 @@ static struct irq_chip ir_ioapic_chip __
 
 static inline void init_IO_APIC_traps(void)
 {
-	int irq;
-	struct irq_desc *desc;
 	struct irq_cfg *cfg;
+	unsigned int irq;
 
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -2611,8 +2609,8 @@ static inline void init_IO_APIC_traps(vo
 	 * Also, we've got to be careful not to trash gate
 	 * 0x80, because int 0x80 is hm, kind of importantish. ;)
 	 */
-	for_each_irq_desc(irq, desc) {
-		cfg = get_irq_desc_chip_data(desc);
+	for_each_active_irq(irq) {
+		cfg = get_irq_chip_data(irq);
 		if (IO_APIC_IRQ(irq) && cfg && !cfg->vector) {
 			/*
 			 * Hmm.. We don't have an entry for this,
@@ -2623,7 +2621,7 @@ static inline void init_IO_APIC_traps(vo
 				legacy_pic->make_irq(irq);
 			else
 				/* Strange. Oh, well.. */
-				desc->chip = &no_irq_chip;
+				set_irq_chip(irq, &no_irq_chip);
 		}
 	}
 }


