Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab2DPSqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 14:46:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46193 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab2DPSqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 14:46:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: xen-devel@lists.xensource.com, suresh.b.siddha@intel.com, hpa@zytor.com,
        hpa@zytor.co, tglx@linutronix.de,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/3] x86/apic: Replace io_apic_ops with x86_io_apic_ops.
Date: Mon, 16 Apr 2012 14:40:14 -0400
Message-Id: <1334601616-25309-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
References: <1334601616-25309-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A020204.4F8C68E8.009A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Which makes the code fit within the rest of the x86_ops functions.

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
[v1: Changed x86_apic -> x86_ioapic per Yinghai Lu <yinghai@kernel.org> suggestion]
[v2: Rebased on tip/x86/urgent and redid to match Ingo's syntax style]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/io_apic.h  |   35 +++++++++++++++++++----------
 arch/x86/include/asm/x86_init.h |    9 ++++++-
 arch/x86/kernel/apic/io_apic.c  |   46 +++-----------------------------------
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/x86_init.c      |    8 ++++++
 5 files changed, 44 insertions(+), 56 deletions(-)

diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 2c4943d..73d8c53 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -5,7 +5,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/irq_vectors.h>
-
+#include <asm/x86_init.h>
 /*
  * Intel IO-APIC support for SMP and UP systems.
  *
@@ -21,15 +21,6 @@
 #define IO_APIC_REDIR_LEVEL_TRIGGER	(1 << 15)
 #define IO_APIC_REDIR_MASKED		(1 << 16)
 
-struct io_apic_ops {
-	void		(*init)  (void);
-	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
-	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
-	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
-};
-
-void __init set_io_apic_ops(const struct io_apic_ops *);
-
 /*
  * The structure of the IO-APIC:
  */
@@ -156,7 +147,6 @@ struct io_apic_irq_attr;
 extern int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr);
 void setup_IO_APIC_irq_extra(u32 gsi);
-extern void ioapic_and_gsi_init(void);
 extern void ioapic_insert_resources(void);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
@@ -185,12 +175,29 @@ extern void mp_save_irq(struct mpc_intsrc *m);
 
 extern void disable_ioapic_support(void);
 
+extern void __init native_io_apic_init_mappings(void);
+extern unsigned int native_io_apic_read(unsigned int apic, unsigned int reg);
+extern void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int val);
+extern void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
+
+static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
+{
+	return x86_io_apic_ops.read(apic, reg);
+}
+
+static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	x86_io_apic_ops.write(apic, reg, value);
+}
+static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+{
+	x86_io_apic_ops.modify(apic, reg, value);
+}
 #else  /* !CONFIG_X86_IO_APIC */
 
 #define io_apic_assign_pci_irqs 0
 #define setup_ioapic_ids_from_mpc x86_init_noop
 static const int timer_through_8259 = 0;
-static inline void ioapic_and_gsi_init(void) { }
 static inline void ioapic_insert_resources(void) { }
 #define gsi_top (NR_IRQS_LEGACY)
 static inline int mp_find_ioapic(u32 gsi) { return 0; }
@@ -212,6 +219,10 @@ static inline int restore_ioapic_entries(void)
 
 static inline void mp_save_irq(struct mpc_intsrc *m) { };
 static inline void disable_ioapic_support(void) { }
+#define native_io_apic_init_mappings	NULL
+#define native_io_apic_read		NULL
+#define native_io_apic_write		NULL
+#define native_io_apic_modify		NULL
 #endif
 
 #endif /* _ASM_X86_IO_APIC_H */
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baaca8d..1101580 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -188,11 +188,18 @@ struct x86_msi_ops {
 	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
 };
 
+struct x86_io_apic_ops {
+	void		(*init)  (void);
+	unsigned int	(*read)  (unsigned int apic, unsigned int reg);
+	void		(*write) (unsigned int apic, unsigned int reg, unsigned int value);
+	void		(*modify)(unsigned int apic, unsigned int reg, unsigned int value);
+};
+
 extern struct x86_init_ops x86_init;
 extern struct x86_cpuinit_ops x86_cpuinit;
 extern struct x86_platform_ops x86_platform;
 extern struct x86_msi_ops x86_msi;
-
+extern struct x86_io_apic_ops x86_io_apic_ops;
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
 extern void x86_default_fixup_cpu_id(struct cpuinfo_x86 *c, int node);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..973539c 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -68,24 +68,6 @@
 #define for_each_irq_pin(entry, head) \
 	for (entry = head; entry; entry = entry->next)
 
-static void		__init __ioapic_init_mappings(void);
-
-static unsigned int	__io_apic_read  (unsigned int apic, unsigned int reg);
-static void		__io_apic_write (unsigned int apic, unsigned int reg, unsigned int val);
-static void		__io_apic_modify(unsigned int apic, unsigned int reg, unsigned int val);
-
-static struct io_apic_ops io_apic_ops = {
-	.init	= __ioapic_init_mappings,
-	.read	= __io_apic_read,
-	.write	= __io_apic_write,
-	.modify = __io_apic_modify,
-};
-
-void __init set_io_apic_ops(const struct io_apic_ops *ops)
-{
-	io_apic_ops = *ops;
-}
-
 /*
  *      Is the SiS APIC rmw bug present ?
  *      -1 = don't know, 0 = no, 1 = yes
@@ -313,21 +295,6 @@ static void free_irq_at(unsigned int at, struct irq_cfg *cfg)
 	irq_free_desc(at);
 }
 
-static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
-{
-	return io_apic_ops.read(apic, reg);
-}
-
-static inline void io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	io_apic_ops.write(apic, reg, value);
-}
-
-static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
-{
-	io_apic_ops.modify(apic, reg, value);
-}
-
 
 struct io_apic {
 	unsigned int index;
@@ -349,14 +316,14 @@ static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
 	writel(vector, &io_apic->eoi);
 }
 
-static unsigned int __io_apic_read(unsigned int apic, unsigned int reg)
+unsigned int native_io_apic_read(unsigned int apic, unsigned int reg)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 	writel(reg, &io_apic->index);
 	return readl(&io_apic->data);
 }
 
-static void __io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
+void native_io_apic_write(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -370,7 +337,7 @@ static void __io_apic_write(unsigned int apic, unsigned int reg, unsigned int va
  *
  * Older SiS APIC requires we rewrite the index register
  */
-static void __io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
+void native_io_apic_modify(unsigned int apic, unsigned int reg, unsigned int value)
 {
 	struct io_apic __iomem *io_apic = io_apic_base(apic);
 
@@ -3931,12 +3898,7 @@ static struct resource * __init ioapic_setup_resources(int nr_ioapics)
 	return res;
 }
 
-void __init ioapic_and_gsi_init(void)
-{
-	io_apic_ops.init();
-}
-
-static void __init __ioapic_init_mappings(void)
+void __init native_io_apic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	struct resource *ioapic_res;
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1a29015..8526317 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -1012,7 +1012,7 @@ void __init setup_arch(char **cmdline_p)
 	init_cpu_to_node();
 
 	init_apic_mappings();
-	ioapic_and_gsi_init();
+	x86_io_apic_ops.init();
 
 	kvm_guest_init();
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index e9f265f..b108682 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -18,6 +18,7 @@
 #include <asm/e820.h>
 #include <asm/time.h>
 #include <asm/irq.h>
+#include <asm/io_apic.h>
 #include <asm/pat.h>
 #include <asm/tsc.h>
 #include <asm/iommu.h>
@@ -120,3 +121,10 @@ struct x86_msi_ops x86_msi = {
 	.teardown_msi_irqs = default_teardown_msi_irqs,
 	.restore_msi_irqs = default_restore_msi_irqs,
 };
+
+struct x86_io_apic_ops x86_io_apic_ops = {
+	.init	= native_io_apic_init_mappings,
+	.read	= native_io_apic_read,
+	.write	= native_io_apic_write,
+	.modify	= native_io_apic_modify,
+};
-- 
1.7.7.5

