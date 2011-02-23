Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932764Ab1BWVum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:50:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:57055 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932713Ab1BWVuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:50:40 -0500
Date: Wed, 23 Feb 2011 21:50:27 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-5-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-5-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: dtb: Add irq domain abstraction
Message-ID: <tip-19c4f5f7f7e9c5db89a91627af2a426cfb5568de@git.kernel.org>
Git-Commit-ID: 19c4f5f7f7e9c5db89a91627af2a426cfb5568de
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:50:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  19c4f5f7f7e9c5db89a91627af2a426cfb5568de
Gitweb:     http://git.kernel.org/tip/19c4f5f7f7e9c5db89a91627af2a426cfb5568de
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:39 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:53 +0100

x86: dtb: Add irq domain abstraction

The here introduced irq_domain abstraction represents a generic irq
controller. It is a subset of powerpc's irq_host which is going to be
renamed to irq_domain and then become generic. This implementation will
be removed once it is generic.

The xlate callback is resposible to parse irq informations like irq type
and number and returns the hardware irq number which is reported by the
hardware as active.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Tested-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1298405266-1624-5-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_controller.h |   12 ++++++++
 arch/x86/include/asm/prom.h           |    2 +
 arch/x86/kernel/devicetree.c          |   46 ++++++++++++++++++++++++++++++++-
 3 files changed, 59 insertions(+), 1 deletions(-)

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
index e46f2a2..83833ac 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -20,9 +20,11 @@
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
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 0b8f0da..ef98e4e 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -3,19 +3,63 @@
  */
 #include <linux/bootmem.h>
 #include <linux/io.h>
+#include <linux/interrupt.h>
 #include <linux/list.h>
 #include <linux/of.h>
 #include <linux/of_fdt.h>
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
+	u32 virq, type;
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
 
