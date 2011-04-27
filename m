Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab1D0Oe0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:34:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:60982 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755888Ab1D0OeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:34:24 -0400
Date: Wed, 27 Apr 2011 16:34:23 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        Grant Likely <grant.likely@secretlab.ca>,
        Torben Hohn <torbenh@linutronix.de>,
        Florian Fainelli <florian@openwrt.org>
Subject: [PATCH 1/2] x86/dtb: make irq host list accessible
Message-ID: <20110427143423.GB15211@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Torben Hohn <torbenh@linutronix.de>

There is an gpio irq chip comming which needs this from the outside.
There is no EXPORT_SYMBOL because this does not yet work in modules.

Signed-off-by: Torben Hohn <torbenh@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/irq_controller.h |    2 ++
 arch/x86/kernel/devicetree.c          |   15 +++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
index 423bbbd..04fecc0 100644
--- a/arch/x86/include/asm/irq_controller.h
+++ b/arch/x86/include/asm/irq_controller.h
@@ -9,4 +9,6 @@ struct irq_domain {
 	struct list_head l;
 };
 
+extern void irq_add_of_interrupt_host(struct irq_domain *ih);
+extern void irq_remove_of_interrupt_host(struct irq_domain *ih);
 #endif
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index e90f084..58c4208 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -26,8 +26,7 @@ static DEFINE_RAW_SPINLOCK(big_irq_lock);
 
 int __initdata of_ioapic;
 
-#ifdef CONFIG_X86_IO_APIC
-static void add_interrupt_host(struct irq_domain *ih)
+void irq_add_of_interrupt_host(struct irq_domain *ih)
 {
 	unsigned long flags;
 
@@ -35,7 +34,15 @@ static void add_interrupt_host(struct irq_domain *ih)
 	list_add(&ih->l, &irq_domains);
 	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
 }
-#endif
+
+void irq_remove_of_interrupt_host(struct irq_domain *ih)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&big_irq_lock, flags);
+	list_del(&ih->l);
+	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
+}
 
 static struct irq_domain *get_ih_from_node(struct device_node *controller)
 {
@@ -415,7 +422,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 			id->controller = np;
 			id->xlate = ioapic_xlate;
 			id->priv = (void *)i;
-			add_interrupt_host(id);
+			irq_add_of_interrupt_host(id);
 			return;
 		}
 	}
-- 
1.7.4.4

