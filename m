Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab1AXE3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 23:29:41 -0500
Received: from www.tglx.de ([62.245.132.106]:55559 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1AXE3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 23:29:31 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH TIP 04/14] x86/dtb: add irq domain abstraction
Date: Mon, 24 Jan 2011 09:58:52 +0530
Message-Id: <1295843342-1122-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
References: <1295843342-1122-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The here introduced irq_domain abstraction represents a generic irq
controller. It is a subset of powerpc's irq_host which is going to be
renamed to irq_domain and then become generic. This implementation will
be removed once it is generic.

The xlate callback is resposible to parse irq informations like irq type
and number and returns the hardware irq number which is reported by the
hardware as active.

Cc: devicetree-discuss@lists.ozlabs.org
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/irq_controller.h |   12 ++++++++
 arch/x86/include/asm/prom.h           |    2 +
 arch/x86/kernel/prom.c                |   47 ++++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/irq_controller.h

diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
new file mode 100644
index 0000000..423bbbd
--- /dev/null
+++ b/arch/x86/include/asm/irq_controller.h
@@ -0,0 +1,12 @@
+#ifndef __IRQ_CONTROLLER__
+#define __IRQ_CONTROLLER__
+
+struct irq_domain {
+	int (*xlate)(struct irq_domain *h, const u32 *intspec, u32 intsize,
+			u32 *out_hwirq, u32 *out_type);
+	void *priv;
+	struct device_node *controller;
+	struct list_head l;
+};
+
+#endif
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index b227ba7..ed7bb62 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -19,9 +19,11 @@
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/setup.h>
+#include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
 extern void add_dtb(u64 data);
+void add_interrupt_host(struct irq_domain *ih);
 #else
 static inline void add_dtb(u64 data) { }
 #endif
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index 4969ffa..95f9551 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -3,18 +3,63 @@
  */
 #include <linux/bootmem.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
+#include <asm/irq_controller.h>
+
 char __initdata cmd_line[COMMAND_LINE_SIZE];
+static LIST_HEAD(irq_domains);
+static DEFINE_RAW_SPINLOCK(big_irq_lock);
+
+void add_interrupt_host(struct irq_domain *ih)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&big_irq_lock, flags);
+	list_add(&ih->l, &irq_domains);
+	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
+}
+
+static struct irq_domain *get_ih_from_node(struct device_node *controller)
+{
+	struct irq_domain *ih, *found = NULL;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&big_irq_lock, flags);
+	list_for_each_entry(ih, &irq_domains, l) {
+		if (ih->controller ==  controller) {
+			found = ih;
+			break;
+		}
+	}
+	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
+	return found;
+}
 
 unsigned int irq_create_of_mapping(struct device_node *controller,
 		const u32 *intspec, unsigned int intsize)
 {
-	return intspec[0];
+	struct irq_domain *ih;
+	u32 virq;
+	u32 type;
+	int ret;
 
+	ih = get_ih_from_node(controller);
+	if (!ih)
+		return 0;
+	ret = ih->xlate(ih, intspec, intsize, &virq, &type);
+	if (ret)
+		return ret;
+	if (type == IRQ_TYPE_NONE)
+		return virq;
+	/* set the mask if it is different from current */
+	if (type == (irq_to_desc(virq)->status & IRQF_TRIGGER_MASK))
+		set_irq_type(virq, type);
+	return virq;
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
 
-- 
1.7.3.2

