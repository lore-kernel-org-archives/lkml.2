Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0KYRnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:43:19 -0500
Received: from www.tglx.de ([62.245.132.106]:50856 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab0KYRnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:43:13 -0500
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-kernel@vger.kernel.org
Cc: sodaville@linutronix.de, x86@kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 04/11] x86/dtb: add irq host abstraction
Date: Thu, 25 Nov 2010 18:39:54 +0100
Message-Id: <1290706801-7323-5-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The here introduced irq_host abstraction represents a generic irq_host.
The xlate callback is resposible to parse irq informations like irq type
and number and returns the hardware irq number which is reported by the
hardware as active.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: x86@kernel.org
Cc: devicetree-discuss@lists.ozlabs.org
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 arch/x86/include/asm/irq_controller.h |   12 ++++++++
 arch/x86/include/asm/prom.h           |    2 +
 arch/x86/kernel/prom.c                |   47 ++++++++++++++++++++++++++++++++-
 3 files changed, 60 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/include/asm/irq_controller.h

diff --git a/arch/x86/include/asm/irq_controller.h b/arch/x86/include/asm/irq_controller.h
new file mode 100644
index 0000000..1cbbfd0
--- /dev/null
+++ b/arch/x86/include/asm/irq_controller.h
@@ -0,0 +1,12 @@
+#ifndef __IRQ_CONTROLLER__
+#define __IRQ_CONTROLLER__
+
+struct irq_host {
+	int (*xlate)(struct irq_host *h, const u32 *intspec, u32 intsize,
+			u32 *out_hwirq, u32 *out_type);
+	void *priv;
+	struct device_node *controller;
+	struct list_head l;
+};
+
+#endif
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 8fdb0d2..6c80e53 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -20,10 +20,12 @@
 #include <asm/irq.h>
 #include <asm/atomic.h>
 #include <asm/setup.h>
+#include <asm/irq_controller.h>
 
 #ifdef CONFIG_OF
 extern void init_dtb(void);
 extern void add_dtb(u64 data);
+void add_interrupt_host(struct irq_host *ih);
 #else
 static inline void init_dtb(void) { }
 static inline void add_dtb(u64 data) { }
diff --git a/arch/x86/kernel/prom.c b/arch/x86/kernel/prom.c
index ba9a096..996fd05 100644
--- a/arch/x86/kernel/prom.c
+++ b/arch/x86/kernel/prom.c
@@ -3,18 +3,63 @@
  */
 
 #include <linux/io.h>
+#include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
 #include <linux/slab.h>
 
+#include <asm/irq_controller.h>
+
 char __initdata cmd_line[COMMAND_LINE_SIZE];
+static LIST_HEAD(irq_hosts);
+static DEFINE_RAW_SPINLOCK(big_irq_lock);
+
+void add_interrupt_host(struct irq_host *ih)
+{
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&big_irq_lock, flags);
+	list_add(&ih->l, &irq_hosts);
+	raw_spin_unlock_irqrestore(&big_irq_lock, flags);
+}
+
+static struct irq_host *get_ih_from_node(struct device_node *controller)
+{
+	struct irq_host *ih, *found = NULL;
+	unsigned long flags;
+
+	raw_spin_lock_irqsave(&big_irq_lock, flags);
+	list_for_each_entry(ih, &irq_hosts, l) {
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
+	struct irq_host *ih;
+	u32 virq;
+	u32 type;
+	int ret;
 
+	ih = get_ih_from_node(controller);
+	if (!ih)
+		return -ENODEV;
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

