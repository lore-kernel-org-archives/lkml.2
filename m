Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760799Ab1D2SCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:02:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46228 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760735Ab1D2SCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:02:31 -0400
Date: Fri, 29 Apr 2011 20:02:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20110429180214.GA7305@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
H. Peter Anvin (1):
      x86, setup: When probing memory with e801, use ax/bx as a pair

Sebastian Andrzej Siewior (2):
      x86: devicetree: Configure IOAPIC pin only once
      x86: ce4100: Configure IOAPIC pins for USB and SATA to level type


 arch/x86/boot/memory.c                   |    2 +-
 arch/x86/include/asm/io_apic.h           |    2 +-
 arch/x86/kernel/apic/io_apic.c           |   10 +++++-----
 arch/x86/kernel/devicetree.c             |    2 +-
 arch/x86/platform/ce4100/falconfalls.dts |    6 +++---
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index cae3feb..db75d07 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -91,7 +91,7 @@ static int detect_memory_e801(void)
 	if (oreg.ax > 15*1024) {
 		return -1;	/* Bogus! */
 	} else if (oreg.ax == 15*1024) {
-		boot_params.alt_mem_k = (oreg.dx << 6) + oreg.ax;
+		boot_params.alt_mem_k = (oreg.bx << 6) + oreg.ax;
 	} else {
 		/*
 		 * This ignores memory above 16MB if we have a memory
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c4bd267..a97a240 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -150,7 +150,7 @@ void setup_IO_APIC_irq_extra(u32 gsi);
 extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
-int io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr);
+int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
 extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
 extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 68df09b..45fd33d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -128,8 +128,8 @@ static int __init parse_noapic(char *str)
 }
 early_param("noapic", parse_noapic);
 
-static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
-				      struct io_apic_irq_attr *attr);
+static int io_apic_setup_irq_pin(unsigned int irq, int node,
+				 struct io_apic_irq_attr *attr);
 
 /* Will be called in mpparse/acpi/sfi codes for saving IRQ info */
 void mp_save_irq(struct mpc_intsrc *m)
@@ -3570,7 +3570,7 @@ int arch_setup_ht_irq(unsigned int irq, struct pci_dev *dev)
 }
 #endif /* CONFIG_HT_IRQ */
 
-int
+static int
 io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 {
 	struct irq_cfg *cfg = alloc_irq_and_cfg_at(irq, node);
@@ -3585,8 +3585,8 @@ io_apic_setup_irq_pin(unsigned int irq, int node, struct io_apic_irq_attr *attr)
 	return ret;
 }
 
-static int io_apic_setup_irq_pin_once(unsigned int irq, int node,
-				      struct io_apic_irq_attr *attr)
+int io_apic_setup_irq_pin_once(unsigned int irq, int node,
+			       struct io_apic_irq_attr *attr)
 {
 	unsigned int id = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
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
