Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977Ab2IZKtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 06:49:55 -0400
Received: from [213.199.154.209] ([213.199.154.209]:27164 "EHLO
	am1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab2IZKq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 06:46:27 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MAYDV2-02-54D-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <x86@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 03/19] x86, io_apic: Introduce x86_io_apic_ops.disable()
Date: Wed, 26 Sep 2012 12:44:35 +0200
Message-ID: <1348656291-10375-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
References: <1348656291-10375-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function pointer is used to call a system-specific
function for disabling the IO-APIC. Currently this is used
for IRQ remapping which has its own disable routine.

Also introduce the necessary infrastructure in the interrupt
remapping code to overwrite this and other function pointers
as necessary by interrupt remapping.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/io_apic.h  |    2 ++
 arch/x86/include/asm/x86_init.h |    9 +++++----
 arch/x86/kernel/apic/io_apic.c  |   41 ++++++++++++++++++---------------------
 arch/x86/kernel/x86_init.c      |    9 +++++----
 drivers/iommu/irq_remapping.c   |   31 ++++++++++++++++++++++++++++-
 5 files changed, 61 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 73d8c53..d59e172 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -179,6 +179,7 @@ extern void __init native_io_apic_init_mappings(void);
 extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
 extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
 extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
+extern void native_disable_io_apic(void);
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
 {
@@ -223,6 +224,7 @@ static inline void disable_ioapic_support(void) { }
 #define native_io_apic_read		NULL
 #define native_io_apic_write		NULL
 #define native_io_apic_modify		NULL
+#define native_disable_io_apic		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 38155f6..8e1b44c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -189,10 +189,11 @@ struct x86_msi_ops {
 };
 
 struct x86_io_apic_ops {
-	void		(*init)  (void);
-	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
-	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*init)   (void);
+	unsigned int	(*read)   (unsigned int apic, unsigned int reg);
+	void		(*write)  (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*modify) (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*disable)(void);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index c265593..c28c991 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1935,30 +1935,14 @@ void __init enable_IO_APIC(void)
 	clear_IO_APIC();
 }
 
-/*
- * Not an __init, needed by the reboot code
- */
-void disable_IO_APIC(void)
+void native_disable_io_apic(void)
 {
 	/*
-	 * Clear the IO-APIC before rebooting:
-	 */
-	clear_IO_APIC();
-
-	if (!legacy_pic->nr_legacy_irqs)
-		return;
-
-	/*
 	 * If the i8259 is routed through an IOAPIC
 	 * Put that IOAPIC in virtual wire mode
 	 * so legacy interrupts can be delivered.
-	 *
-	 * With interrupt-remapping, for now we will use virtual wire A mode,
-	 * as virtual wire B is little complex (need to configure both
-	 * IOAPIC RTE as well as interrupt-remapping table entry).
-	 * As this gets called during crash dump, keep this simple for now.
 	 */
-	if (ioapic_i8259.pin != -1 && !irq_remapping_enabled) {
+	if (ioapic_i8259.pin != -1) {
 		struct IO_APIC_route_entry entry;
 
 		memset(&entry, 0, sizeof(entry));
@@ -1978,12 +1962,25 @@ void disable_IO_APIC(void)
 		ioapic_write_entry(ioapic_i8259.apic, ioapic_i8259.pin, entry);
 	}
 
+	if (cpu_has_apic || apic_from_smp_config())
+		disconnect_bsp_APIC(ioapic_i8259.pin != -1);
+
+}
+
+/*
+ * Not an __init, needed by the reboot code
+ */
+void disable_IO_APIC(void)
+{
 	/*
-	 * Use virtual wire A mode when interrupt remapping is enabled.
+	 * Clear the IO-APIC before rebooting:
 	 */
-	if (cpu_has_apic || apic_from_smp_config())
-		disconnect_bsp_APIC(!irq_remapping_enabled &&
-				ioapic_i8259.pin != -1);
+	clear_IO_APIC();
+
+	if (!legacy_pic->nr_legacy_irqs)
+		return;
+
+	x86_io_apic_ops.disable();
 }
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 9f3167e..3ea56c2 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -120,8 +120,9 @@ struct x86_msi_ops x86_msi = {
 };
 
 struct x86_io_apic_ops x86_io_apic_ops = {
-	.init	= native_io_apic_init_mappings,
-	.read	= native_io_apic_read,
-	.write	= native_io_apic_write,
-	.modify	= native_io_apic_modify,
+	.init			= native_io_apic_init_mappings,
+	.read			= native_io_apic_read,
+	.write			= native_io_apic_write,
+	.modify			= native_io_apic_modify,
+	.disable		= native_disable_io_apic,
 };
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 283a43f..f72a5e8 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -1,3 +1,4 @@
+#include <linux/cpumask.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/cpumask.h>
@@ -6,6 +7,9 @@
 
 #include <asm/hw_irq.h>
 #include <asm/irq_remapping.h>
+#include <asm/processor.h>
+#include <asm/x86_init.h>
+#include <asm/apic.h>
 
 #include "irq_remapping.h"
 
@@ -17,6 +21,24 @@ int no_x2apic_optout;
 
 static struct irq_remap_ops *remap_ops;
 
+static void irq_remapping_disable_io_apic(void)
+{
+	/*
+	 * With interrupt-remapping, for now we will use virtual wire A
+	 * mode, as virtual wire B is little complex (need to configure
+	 * both IOAPIC RTE as well as interrupt-remapping table entry).
+	 * As this gets called during crash dump, keep this simple for
+	 * now.
+	 */
+	if (cpu_has_apic || apic_from_smp_config())
+		disconnect_bsp_APIC(0);
+}
+
+static void __init irq_remapping_modify_x86_ops(void)
+{
+	x86_io_apic_ops.disable	=	irq_remapping_disable_io_apic;
+}
+
 static __init int setup_nointremap(char *str)
 {
 	disable_irq_remap = 1;
@@ -74,10 +96,17 @@ int __init irq_remapping_prepare(void)
 
 int __init irq_remapping_enable(void)
 {
+	int ret;
+
 	if (!remap_ops || !remap_ops->enable)
 		return -ENODEV;
 
-	return remap_ops->enable();
+	ret = remap_ops->enable();
+
+	if (irq_remapping_enabled)
+		irq_remapping_modify_x86_ops();
+
+	return ret;
 }
 
 void irq_remapping_disable(void)
-- 
1.7.9.5


