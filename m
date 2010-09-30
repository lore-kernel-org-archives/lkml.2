Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988Ab0I3XVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:21:04 -0400
Received: from www.tglx.de ([62.245.132.106]:52983 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756358Ab0I3XSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:18:00 -0400
Message-Id: <20100930221741.916507277@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:17:34 -0000
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
Subject: [patch 35/47] x86: ioapic: Cleanup some more
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=x86-ioapic-clenaup-some-more.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup after the irq_chip conversion a bit.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/apic/io_apic.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -131,13 +131,9 @@ struct irq_pin_list {
 	struct irq_pin_list *next;
 };
 
-static struct irq_pin_list *get_one_free_irq_2_pin(int node)
+static struct irq_pin_list *alloc_irq_pin_list(int node)
 {
-	struct irq_pin_list *pin;
-
-	pin = kzalloc_node(sizeof(*pin), GFP_ATOMIC, node);
-
-	return pin;
+	return kzalloc_node(sizeof(struct irq_pin_list), GFP_ATOMIC, node);
 }
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
@@ -232,7 +228,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_
 	if (!old_entry)
 		return;
 
-	entry = get_one_free_irq_2_pin(node);
+	entry = alloc_irq_pin_list(node);
 	if (!entry)
 		return;
 
@@ -242,7 +238,7 @@ init_copy_irq_2_pin(struct irq_cfg *old_
 	tail		= entry;
 	old_entry	= old_entry->next;
 	while (old_entry) {
-		entry = get_one_free_irq_2_pin(node);
+		entry = alloc_irq_pin_list(node);
 		if (!entry) {
 			entry = head;
 			while (entry) {
@@ -471,7 +467,7 @@ static void ioapic_mask_entry(int apic, 
  * fast in the common case, and fast for shared ISA-space IRQs.
  */
 static int
-add_pin_to_irq_node_nopanic(struct irq_cfg *cfg, int node, int apic, int pin)
+__add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
 	struct irq_pin_list **last, *entry;
 
@@ -483,7 +479,7 @@ add_pin_to_irq_node_nopanic(struct irq_c
 		last = &entry->next;
 	}
 
-	entry = get_one_free_irq_2_pin(node);
+	entry = alloc_irq_pin_list(node);
 	if (!entry) {
 		printk(KERN_ERR "can not alloc irq_pin_list (%d,%d,%d)\n",
 				node, apic, pin);
@@ -498,7 +494,7 @@ add_pin_to_irq_node_nopanic(struct irq_c
 
 static void add_pin_to_irq_node(struct irq_cfg *cfg, int node, int apic, int pin)
 {
-	if (add_pin_to_irq_node_nopanic(cfg, node, apic, pin))
+	if (__add_pin_to_irq_node(cfg, node, apic, pin))
 		panic("IO-APIC: failed to add irq-pin. Can not proceed\n");
 }
 
@@ -3823,7 +3819,7 @@ static int __io_apic_set_pci_routing(str
 	 * IRQs < 16 are already in the irq_2_pin[] map
 	 */
 	if (irq >= legacy_pic->nr_legacy_irqs) {
-		if (add_pin_to_irq_node_nopanic(cfg, node, ioapic, pin)) {
+		if (__add_pin_to_irq_node(cfg, node, ioapic, pin)) {
 			printk(KERN_INFO "can not add pin %d for irq %d\n",
 				pin, irq);
 			return 0;


