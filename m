Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1BWVwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 16:52:35 -0500
Received: from hera.kernel.org ([140.211.167.34]:57124 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753399Ab1BWVwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 16:52:33 -0500
Date: Wed, 23 Feb 2011 21:52:16 GMT
From: tip-bot for Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, grant.likely@secretlab.ca, hpa@zytor.com,
        mingo@redhat.com, dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, dirk.brandewie@gmail.com,
        tglx@linutronix.de, bigeasy@linutronix.de
In-Reply-To: <1298405266-1624-10-git-send-email-bigeasy@linutronix.de>
References: <1298405266-1624-10-git-send-email-bigeasy@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: ioapic: Add OF bindings for IO_APIC
Message-ID: <tip-bcc7c1244fcfd852b9f4590935491057e1cab9dd@git.kernel.org>
Git-Commit-ID: bcc7c1244fcfd852b9f4590935491057e1cab9dd
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Feb 2011 21:52:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bcc7c1244fcfd852b9f4590935491057e1cab9dd
Gitweb:     http://git.kernel.org/tip/bcc7c1244fcfd852b9f4590935491057e1cab9dd
Author:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
AuthorDate: Tue, 22 Feb 2011 21:07:44 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 23 Feb 2011 22:27:54 +0100

x86: ioapic: Add OF bindings for IO_APIC

ioapic_xlate provides a translation from the information in device tree
to ioapic related informations. This includes
- obtaining hw irq which is the vector number "=> pin number + gsi"
- obtaining type (level/edge/..)
- programming this information into ioapic

ioapic_add_ofnode adds an irq_domain based on informations from the device
tree. This information (irq_domain) is required in order to map a device to
its proper interrupt controller.

[ tglx: Adapted to the io_apic changes, which let us move that whole code
  	to devicetree.c ]

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Cc: sodaville@linutronix.de
Cc: devicetree-discuss@lists.ozlabs.org
LKML-Reference: <1298405266-1624-10-git-send-email-bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/prom.h  |    2 +
 arch/x86/kernel/devicetree.c |  104 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/irqinit.c    |    6 ++
 3 files changed, 112 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index 8fcd519..ae50131 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -27,6 +27,7 @@
 extern int of_ioapic;
 extern u64 initial_dtb;
 extern void add_dtb(u64 data);
+extern void x86_add_irq_domains(void);
 void x86_dtb_find_config(void);
 void x86_dtb_get_config(unsigned int unused);
 void add_interrupt_host(struct irq_domain *ih);
@@ -44,6 +45,7 @@ static inline struct device_node *pci_bus_to_OF_node(struct pci_bus *bus)
 
 #else
 static inline void add_dtb(u64 data) { }
+static inline void x86_add_irq_domains(void) { }
 static inline void x86_of_pci_init(void) { }
 #define x86_dtb_find_config x86_init_noop
 #define x86_dtb_get_config x86_init_uint_noop
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 0bc83bf..2d65897 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -320,3 +320,107 @@ void __init x86_dtb_get_config(unsigned int unused)
 	dtb_setup_hpet();
 	dtb_apic_setup();
 }
+
+#ifdef CONFIG_X86_IO_APIC
+
+struct of_ioapic_type {
+	u32 out_type;
+	u32 trigger;
+	u32 polarity;
+};
+
+static struct of_ioapic_type of_ioapic_type[] =
+{
+	{
+		.out_type	= IRQ_TYPE_EDGE_RISING,
+		.trigger	= IOAPIC_EDGE,
+		.polarity	= 1,
+	},
+	{
+		.out_type	= IRQ_TYPE_LEVEL_LOW,
+		.trigger	= IOAPIC_LEVEL,
+		.polarity	= 0,
+	},
+	{
+		.out_type	= IRQ_TYPE_LEVEL_HIGH,
+		.trigger	= IOAPIC_LEVEL,
+		.polarity	= 1,
+	},
+	{
+		.out_type	= IRQ_TYPE_EDGE_FALLING,
+		.trigger	= IOAPIC_EDGE,
+		.polarity	= 0,
+	},
+};
+
+static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
+			u32 *out_hwirq, u32 *out_type)
+{
+	struct io_apic_irq_attr attr;
+	struct of_ioapic_type *it;
+	u32 line, idx, type;
+
+	if (intsize < 2)
+		return -EINVAL;
+
+	line = *intspec;
+	idx = (u32) id->priv;
+	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
+
+	intspec++;
+	type = *intspec;
+
+	if (type >= ARRAY_SIZE(of_ioapic_type))
+		return -EINVAL;
+
+	it = of_ioapic_type + type;
+	*out_type = it->out_type;
+
+	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
+
+	return io_apic_setup_irq_pin(*out_hwirq, cpu_to_node(0), &attr);
+}
+
+static void __init ioapic_add_ofnode(struct device_node *np)
+{
+	struct resource r;
+	int i, ret;
+
+	ret = of_address_to_resource(np, 0, &r);
+	if (ret) {
+		printk(KERN_ERR "Failed to obtain address for %s\n",
+				np->full_name);
+		return;
+	}
+
+	for (i = 0; i < nr_ioapics; i++) {
+		if (r.start == mp_ioapics[i].apicaddr) {
+			struct irq_domain *id;
+
+			id = kzalloc(sizeof(*id), GFP_KERNEL);
+			BUG_ON(!id);
+			id->controller = np;
+			id->xlate = ioapic_xlate;
+			id->priv = (void *)i;
+			add_interrupt_host(id);
+			return;
+		}
+	}
+	printk(KERN_ERR "IOxAPIC at %s is not registered.\n", np->full_name);
+}
+
+void __init x86_add_irq_domains(void)
+{
+	struct device_node *dp;
+
+	if (!initial_boot_params)
+		return;
+
+	for_each_node_with_property(dp, "interrupt-controller") {
+		if (of_device_is_compatible(dp, "intel,ce4100-ioapic"))
+			ioapic_add_ofnode(dp);
+	}
+}
+#else
+void __init x86_add_irq_domains(void) { }
+#endif
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index 4cadf86..9f76f89 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -119,6 +119,12 @@ void __init init_IRQ(void)
 	int i;
 
 	/*
+	 * We probably need a better place for this, but it works for
+	 * now ...
+	 */
+	x86_add_irq_domains();
+
+	/*
 	 * On cpu 0, Assign IRQ0_VECTOR..IRQ15_VECTOR's to IRQ 0..15.
 	 * If these IRQ's are handled by legacy interrupt-controllers like PIC,
 	 * then this configuration will likely be static after the boot. If
