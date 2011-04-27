Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab1D0Oaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 10:30:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:42199 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193Ab1D0Oax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 10:30:53 -0400
Date: Wed, 27 Apr 2011 16:30:52 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de
Subject: [PATCH] x86/devicetree: configure APIC pin only once
Message-ID: <20110427143052.GA15211@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use io_apic_setup_irq_pin() in order to configure pin's interrupt
number polarity and type. This is done on every irq_create_of_mapping()
which happens for instance during pci enable calls. Level typed
interrupts are masked by default, edge are unmasked.

Now the problem: On the first ->xlate() call the level interrupt is
configured and masked. The driver calls request_irq() and the line is
unmasked. Lets assume the interrupt line is shared with another device
and we call pci_enable_device() for this device. The ->xlate()
configures the pin again and it is masked. request_irq() does not unmask
the line because it _is_ already unmasked according to its internal
state. So the interrupt will never be unmasked again.

This patch is based on an earlier work by Torben Hohn
<torbenh@linutronix.de> and solves the problem by configuring the pin
only once. Since all devices must agree on the same type and polarity
there is point in writting the same value >1 times to the register.

This also solves another mystery: The USB device did not work if it was
configured as level but it worked as edge. I've been told that USB and
SATA is interally configured as edge and not as level. The
miss-understanding on my side was that I assumed that the actuall device
(within the SoC) was generating edge interrupts instead of level. What
they've been trying to tell me (probably) was that the boot-loader was
using them as edge and I have to change it.

Cc: Torben Hohn <torbenh@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 arch/x86/include/asm/io_apic.h           |    3 ++-
 arch/x86/kernel/apic/io_apic.c           |    8 ++++----
 arch/x86/kernel/devicetree.c             |    2 +-
 arch/x86/platform/ce4100/falconfalls.dts |    6 +++---
 4 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c4bd267..046f128 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,7 +150,8 @@ void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
-int io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr);
+int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+		struct io_apic_irq_attr *attr);
 
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 68df09b..1bace4b 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -128,7 +128,7 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+static int io_apic_setup_irq_pin(unsigned int irq, int node,
 				      struct io_apic_irq_attr *attr);
 
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
@@ -3570,8 +3570,8 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 }
 #endif /* CONFIG_HT_IRQ */
 
-int
-io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
+static int io_apic_setup_irq_pin(unsigned int irq, int node,
+		struct io_apic_irq_attr *attr)
 {
 	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
 	int ret;
@@ -3585,7 +3585,7 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 				      struct io_apic_irq_attr *attr)
 {
 	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index 706a9fb..e90f084 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -391,7 +391,7 @@ static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
 
 	set_io_apic_irq_attr(&attr, idx, line, it->trigger, it->polarity);
 
-	return io_apic_setup_irq_pin(*out_hwirq, cpu_to_node(0), &attr);
+	return io_apic_setup_irq_pin_once(*out_hwirq, cpu_to_node(0), &attr);
 }
 
 static void __init ioapic_add_ofnode(struct device_node *np)
diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
index 2d6d226..e70be38 100644
--- a/arch/x86/platform/ce4100/falconfalls.dts
+++ b/arch/x86/platform/ce4100/falconfalls.dts
@@ -347,7 +347,7 @@
 						   "pciclass0c03";
 
 					reg = <0x16800 0x0 0x0 0x0 0x0>;
-					interrupts = <22 3>;
+					interrupts = <22 1>;
 				};
 
 				usb@d,1 {
@@ -357,7 +357,7 @@
 						   "pciclass0c03";
 
 					reg = <0x16900 0x0 0x0 0x0 0x0>;
-					interrupts = <22 3>;
+					interrupts = <22 1>;
 				};
 
 				sata@e,0 {
@@ -367,7 +367,7 @@
 						   "pciclass0106";
 
 					reg = <0x17000 0x0 0x0 0x0 0x0>;
-					interrupts = <23 3>;
+					interrupts = <23 1>;
 				};
 
 				flash@f,0 {
-- 
1.7.4.4

