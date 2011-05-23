Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab1EWTbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:31:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58263 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756143Ab1EWTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:30:58 -0400
Date: Mon, 23 May 2011 21:30:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] more x86/apic changes for v2.6.40
Message-ID: <20110523193035.GA9170@elte.hu>
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

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

These arrived early in the merge window so i delayed them - but they are 
looking good and it would be nice to have them in v2.6.40.

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (3):
      x86, x2apic: Track the x2apic cluster sibling map
      x86, x2apic: Minimize IPI register writes using cluster groups
      x86, x2apic: Move the common bits to x2apic.h

Daniel J Blueman (1):
      x86, ioapic: Fix potential resume deadlock

Randy Dunlap (1):
      x86, apic: Include module.h header in apic_flat_64.c

Suresh Siddha (14):
      x86, ioapic: Allocate ioapic_saved_data early
      x86, ioapic: Use ioapic_saved_data while enabling intr-remapping
      x86, ioapic: Remove duplicate code for saving/restoring RTEs
      x86, ioapic: Add struct ioapic
      x86, ioapic: Consolidate ioapic_saved_data[] into 'struct ioapic'
      x86, ioapic: Consolidate mp_ioapics[] into 'struct ioapic'
      x86, ioapic: Consolidate gsi routing info into 'struct ioapic'
      x86, ioapic: Consolidate mp_ioapic_routing[] into 'struct ioapic'
      x86, apic: Use probe routines to simplify apic selection
      x86, x2apic: Remove duplicate code for IPI mask routines
      x86, apic: Introduce .apicdrivers section to find the list of apic drivers
      x86, apic: Use .apicdrivers section for the apic drivers list
      x86, apic: Clean up bigsmp apic selection code
      x86, apic: Make apic drivers static


 arch/x86/include/asm/apic.h           |   29 +++-
 arch/x86/include/asm/io_apic.h        |   28 +--
 arch/x86/include/asm/x2apic.h         |   62 +++++++
 arch/x86/kernel/acpi/boot.c           |    8 +-
 arch/x86/kernel/apic/Makefile         |   17 ++-
 arch/x86/kernel/apic/apic.c           |   48 ++----
 arch/x86/kernel/apic/apic_flat_64.c   |   26 +++-
 arch/x86/kernel/apic/bigsmp_32.c      |   12 ++-
 arch/x86/kernel/apic/es7000_32.c      |   10 +-
 arch/x86/kernel/apic/io_apic.c        |  309 ++++++++++++++-------------------
 arch/x86/kernel/apic/numaq_32.c       |    6 +-
 arch/x86/kernel/apic/probe_32.c       |  117 +++++--------
 arch/x86/kernel/apic/probe_64.c       |   61 ++-----
 arch/x86/kernel/apic/summit_32.c      |    4 +-
 arch/x86/kernel/apic/x2apic_cluster.c |  222 +++++++++++++-----------
 arch/x86/kernel/apic/x2apic_phys.c    |  115 +++---------
 arch/x86/kernel/apic/x2apic_uv_x.c    |   13 ++-
 arch/x86/kernel/devicetree.c          |    6 +-
 arch/x86/kernel/mpparse.c             |    2 +-
 arch/x86/kernel/vmlinux.lds.S         |    7 +
 20 files changed, 539 insertions(+), 563 deletions(-)
 create mode 100644 arch/x86/include/asm/x2apic.h

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index a0c46f0..4a0b7c7 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -381,6 +381,26 @@ struct apic {
 extern struct apic *apic;
 
 /*
+ * APIC drivers are probed based on how they are listed in the .apicdrivers
+ * section. So the order is important and enforced by the ordering
+ * of different apic driver files in the Makefile.
+ *
+ * For the files having two apic drivers, we use apic_drivers()
+ * to enforce the order with in them.
+ */
+#define apic_driver(sym)					\
+	static struct apic *__apicdrivers_##sym __used		\
+	__aligned(sizeof(struct apic *))			\
+	__section(.apicdrivers) = { &sym }
+
+#define apic_drivers(sym1, sym2)					\
+	static struct apic *__apicdrivers_##sym1##sym2[2] __used	\
+	__aligned(sizeof(struct apic *))				\
+	__section(.apicdrivers) = { &sym1, &sym2 }
+
+extern struct apic *__apicdrivers[], *__apicdrivers_end[];
+
+/*
  * APIC functionality to boot other CPUs - only used on SMP:
  */
 #ifdef CONFIG_SMP
@@ -458,15 +478,10 @@ static inline unsigned default_get_apic_id(unsigned long x)
 #define DEFAULT_TRAMPOLINE_PHYS_HIGH		0x469
 
 #ifdef CONFIG_X86_64
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2apic_cluster;
-extern struct apic apic_x2apic_phys;
 extern int default_acpi_madt_oem_check(char *, char *);
 
 extern void apic_send_IPI_self(int vector);
 
-extern struct apic apic_x2apic_uv_x;
 DECLARE_PER_CPU(int, x2apic_extra_bits);
 
 extern int default_cpu_present_to_apicid(int mps_cpu);
@@ -480,7 +495,7 @@ static inline void default_wait_for_init_deassert(atomic_t *deassert)
 	return;
 }
 
-extern void generic_bigsmp_probe(void);
+extern struct apic *generic_bigsmp_probe(void);
 
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -516,8 +531,6 @@ extern struct apic apic_noop;
 
 #ifdef CONFIG_X86_32
 
-extern struct apic apic_default;
-
 static inline int noop_x86_32_early_logical_apicid(int cpu)
 {
 	return BAD_APICID;
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index a97a240..690d1cc 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -105,12 +105,12 @@ struct IR_IO_APIC_route_entry {
  * # of IO-APICs and # of IRQ routing registers
  */
 extern int nr_ioapics;
-extern int nr_ioapic_registers[MAX_IO_APICS];
 
-#define MP_MAX_IOAPIC_PIN 127
+extern int mpc_ioapic_id(int ioapic);
+extern unsigned int mpc_ioapic_addr(int ioapic);
+extern struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int ioapic);
 
-/* I/O APIC entries */
-extern struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
+#define MP_MAX_IOAPIC_PIN 127
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
@@ -152,11 +152,9 @@ extern void ioapic_insert_resources(void);
 
 int io_apic_setup_irq_pin_once(unsigned int irq, int node, struct io_apic_irq_attr *attr);
 
-extern struct IO_APIC_route_entry **alloc_ioapic_entries(void);
-extern void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries);
-extern int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
-extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
+extern int save_ioapic_entries(void);
+extern void mask_ioapic_entries(void);
+extern int restore_ioapic_entries(void);
 
 extern int get_nr_irqs_gsi(void);
 
@@ -192,19 +190,13 @@ struct io_apic_irq_attr;
 static inline int io_apic_set_pci_routing(struct device *dev, int irq,
 		 struct io_apic_irq_attr *irq_attr) { return 0; }
 
-static inline struct IO_APIC_route_entry **alloc_ioapic_entries(void)
-{
-	return NULL;
-}
-
-static inline void free_ioapic_entries(struct IO_APIC_route_entry **ent) { }
-static inline int save_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+static inline int save_ioapic_entries(void)
 {
 	return -ENOMEM;
 }
 
-static inline void mask_IO_APIC_setup(struct IO_APIC_route_entry **ent) { }
-static inline int restore_IO_APIC_setup(struct IO_APIC_route_entry **ent)
+static inline void mask_ioapic_entries(void) { }
+static inline int restore_ioapic_entries(void)
 {
 	return -ENOMEM;
 }
diff --git a/arch/x86/include/asm/x2apic.h b/arch/x86/include/asm/x2apic.h
new file mode 100644
index 0000000..6bf5b8e
--- /dev/null
+++ b/arch/x86/include/asm/x2apic.h
@@ -0,0 +1,62 @@
+/*
+ * Common bits for X2APIC cluster/physical modes.
+ */
+
+#ifndef _ASM_X86_X2APIC_H
+#define _ASM_X86_X2APIC_H
+
+#include <asm/apic.h>
+#include <asm/ipi.h>
+#include <linux/cpumask.h>
+
+/*
+ * Need to use more than cpu 0, because we need more vectors
+ * when MSI-X are used.
+ */
+static const struct cpumask *x2apic_target_cpus(void)
+{
+	return cpu_online_mask;
+}
+
+static int x2apic_apic_id_registered(void)
+{
+	return 1;
+}
+
+/*
+ * For now each logical cpu is in its own vector allocation domain.
+ */
+static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
+{
+	cpumask_clear(retmask);
+	cpumask_set_cpu(cpu, retmask);
+}
+
+static void
+__x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+{
+	unsigned long cfg = __prepare_ICR(0, vector, dest);
+	native_x2apic_icr_write(cfg, apicid);
+}
+
+static unsigned int x2apic_get_apic_id(unsigned long id)
+{
+	return id;
+}
+
+static unsigned long x2apic_set_apic_id(unsigned int id)
+{
+	return id;
+}
+
+static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
+{
+	return initial_apicid >> index_msb;
+}
+
+static void x2apic_send_IPI_self(int vector)
+{
+	apic_write(APIC_SELF_IPI, vector);
+}
+
+#endif /* _ASM_X86_X2APIC_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 9a966c5..4558f0d 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -970,7 +970,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	mp_irq.irqflag = (trigger << 2) | polarity;
 	mp_irq.srcbus = MP_ISA_BUS;
 	mp_irq.srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
+	mp_irq.dstapic = mpc_ioapic_id(ioapic); /* APIC ID */
 	mp_irq.dstirq = pin;	/* INTIN# */
 
 	mp_save_irq(&mp_irq);
@@ -1021,7 +1021,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 		if (ioapic < 0)
 			continue;
 		pin = mp_find_ioapic_pin(ioapic, gsi);
-		dstapic = mp_ioapics[ioapic].apicid;
+		dstapic = mpc_ioapic_id(ioapic);
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
 			struct mpc_intsrc *irq = mp_irqs + idx;
@@ -1082,7 +1082,7 @@ static int mp_config_acpi_gsi(struct device *dev, u32 gsi, int trigger,
 	mp_irq.srcbus = number;
 	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.dstapic = mp_ioapics[ioapic].apicid;
+	mp_irq.dstapic = mpc_ioapic_id(ioapic);
 	mp_irq.dstirq = mp_find_ioapic_pin(ioapic, gsi);
 
 	mp_save_irq(&mp_irq);
@@ -1113,7 +1113,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 
 	if (ioapic_pin > MP_MAX_IOAPIC_PIN) {
 		printk(KERN_ERR "Invalid reference to IOAPIC pin "
-		       "%d-%d\n", mp_ioapics[ioapic].apicid,
+		       "%d-%d\n", mpc_ioapic_id(ioapic),
 		       ioapic_pin);
 		return gsi;
 	}
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index 3966b56..767fd04 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,20 +2,25 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
-obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o probe_$(BITS).o ipi.o
+obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o
 obj-y				+= hw_nmi.o
 
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
 
 ifeq ($(CONFIG_X86_64),y)
-obj-y				+= apic_flat_64.o
-obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
-obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
+# APIC probe will depend on the listing order here
 obj-$(CONFIG_X86_UV)		+= x2apic_uv_x.o
+obj-$(CONFIG_X86_X2APIC)	+= x2apic_phys.o
+obj-$(CONFIG_X86_X2APIC)	+= x2apic_cluster.o
+obj-y				+= apic_flat_64.o
 endif
 
-obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
+# APIC probe will depend on the listing order here
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
-obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
 obj-$(CONFIG_X86_SUMMIT)	+= summit_32.o
+obj-$(CONFIG_X86_BIGSMP)	+= bigsmp_32.o
+obj-$(CONFIG_X86_ES7000)	+= es7000_32.o
+
+# For 32bit, probe_32 need to be listed last
+obj-$(CONFIG_X86_LOCAL_APIC)	+= probe_$(BITS).o
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index f92a8e5..b961af8 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1461,7 +1461,6 @@ int __init enable_IR(void)
 void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
-	struct IO_APIC_route_entry **ioapic_entries;
 	int ret, x2apic_enabled = 0;
 	int dmar_table_init_ret;
 
@@ -1469,13 +1468,7 @@ void __init enable_IR_x2apic(void)
 	if (dmar_table_init_ret && !x2apic_supported())
 		return;
 
-	ioapic_entries = alloc_ioapic_entries();
-	if (!ioapic_entries) {
-		pr_err("Allocate ioapic_entries failed\n");
-		goto out;
-	}
-
-	ret = save_IO_APIC_setup(ioapic_entries);
+	ret = save_ioapic_entries();
 	if (ret) {
 		pr_info("Saving IO-APIC state failed: %d\n", ret);
 		goto out;
@@ -1483,7 +1476,7 @@ void __init enable_IR_x2apic(void)
 
 	local_irq_save(flags);
 	legacy_pic->mask_all();
-	mask_IO_APIC_setup(ioapic_entries);
+	mask_ioapic_entries();
 
 	if (dmar_table_init_ret)
 		ret = 0;
@@ -1514,14 +1507,11 @@ void __init enable_IR_x2apic(void)
 
 nox2apic:
 	if (!ret) /* IR enabling failed */
-		restore_IO_APIC_setup(ioapic_entries);
+		restore_ioapic_entries();
 	legacy_pic->restore_mask();
 	local_irq_restore(flags);
 
 out:
-	if (ioapic_entries)
-		free_ioapic_entries(ioapic_entries);
-
 	if (x2apic_enabled)
 		return;
 
@@ -2095,28 +2085,20 @@ static void lapic_resume(void)
 {
 	unsigned int l, h;
 	unsigned long flags;
-	int maxlvt, ret;
-	struct IO_APIC_route_entry **ioapic_entries = NULL;
+	int maxlvt;
 
 	if (!apic_pm_state.active)
 		return;
 
 	local_irq_save(flags);
 	if (intr_remapping_enabled) {
-		ioapic_entries = alloc_ioapic_entries();
-		if (!ioapic_entries) {
-			WARN(1, "Alloc ioapic_entries in lapic resume failed.");
-			goto restore;
-		}
-
-		ret = save_IO_APIC_setup(ioapic_entries);
-		if (ret) {
-			WARN(1, "Saving IO-APIC state failed: %d\n", ret);
-			free_ioapic_entries(ioapic_entries);
-			goto restore;
-		}
-
-		mask_IO_APIC_setup(ioapic_entries);
+		/*
+		 * IO-APIC and PIC have their own resume routines.
+		 * We just mask them here to make sure the interrupt
+		 * subsystem is completely quiet while we enable x2apic
+		 * and interrupt-remapping.
+		 */
+		mask_ioapic_entries();
 		legacy_pic->mask_all();
 	}
 
@@ -2159,13 +2141,9 @@ static void lapic_resume(void)
 	apic_write(APIC_ESR, 0);
 	apic_read(APIC_ESR);
 
-	if (intr_remapping_enabled) {
+	if (intr_remapping_enabled)
 		reenable_intr_remapping(x2apic_mode);
-		legacy_pic->restore_mask();
-		restore_IO_APIC_setup(ioapic_entries);
-		free_ioapic_entries(ioapic_entries);
-	}
-restore:
+
 	local_irq_restore(flags);
 }
 
diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 5652d31..f7a41e4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -16,6 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/hardirq.h>
+#include <linux/module.h>
 #include <asm/smp.h>
 #include <asm/apic.h>
 #include <asm/ipi.h>
@@ -24,6 +25,12 @@
 #include <acpi/acpi_bus.h>
 #endif
 
+static struct apic apic_physflat;
+static struct apic apic_flat;
+
+struct apic __read_mostly *apic = &apic_flat;
+EXPORT_SYMBOL_GPL(apic);
+
 static int flat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return 1;
@@ -164,7 +171,7 @@ static int flat_phys_pkg_id(int initial_apic_id, int index_msb)
 	return initial_apic_id >> index_msb;
 }
 
-struct apic apic_flat =  {
+static struct apic apic_flat =  {
 	.name				= "flat",
 	.probe				= NULL,
 	.acpi_madt_oem_check		= flat_acpi_madt_oem_check,
@@ -312,10 +319,18 @@ physflat_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
-struct apic apic_physflat =  {
+static int physflat_probe(void)
+{
+	if (apic == &apic_physflat || num_possible_cpus() > 8)
+		return 1;
+
+	return 0;
+}
+
+static struct apic apic_physflat =  {
 
 	.name				= "physical flat",
-	.probe				= NULL,
+	.probe				= physflat_probe,
 	.acpi_madt_oem_check		= physflat_acpi_madt_oem_check,
 	.apic_id_registered		= flat_apic_id_registered,
 
@@ -369,3 +384,8 @@ struct apic apic_physflat =  {
 	.wait_icr_idle			= native_apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_apic_wait_icr_idle,
 };
+
+/*
+ * We need to check for physflat first, so this order is important.
+ */
+apic_drivers(apic_physflat, apic_flat);
diff --git a/arch/x86/kernel/apic/bigsmp_32.c b/arch/x86/kernel/apic/bigsmp_32.c
index d84ac5a5..efd737e 100644
--- a/arch/x86/kernel/apic/bigsmp_32.c
+++ b/arch/x86/kernel/apic/bigsmp_32.c
@@ -193,7 +193,7 @@ static int probe_bigsmp(void)
 	return dmi_bigsmp;
 }
 
-struct apic apic_bigsmp = {
+static struct apic apic_bigsmp = {
 
 	.name				= "bigsmp",
 	.probe				= probe_bigsmp,
@@ -254,3 +254,13 @@ struct apic apic_bigsmp = {
 
 	.x86_32_early_logical_apicid	= bigsmp_early_logical_apicid,
 };
+
+struct apic * __init generic_bigsmp_probe(void)
+{
+	if (probe_bigsmp())
+		return &apic_bigsmp;
+
+	return NULL;
+}
+
+apic_driver(apic_bigsmp);
diff --git a/arch/x86/kernel/apic/es7000_32.c b/arch/x86/kernel/apic/es7000_32.c
index 70533de..9536b3f 100644
--- a/arch/x86/kernel/apic/es7000_32.c
+++ b/arch/x86/kernel/apic/es7000_32.c
@@ -620,7 +620,7 @@ static int es7000_mps_oem_check_cluster(struct mpc_table *mpc, char *oem,
 }
 
 /* We've been warned by a false positive warning.Use __refdata to keep calm. */
-struct apic __refdata apic_es7000_cluster = {
+static struct apic __refdata apic_es7000_cluster = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
@@ -685,7 +685,7 @@ struct apic __refdata apic_es7000_cluster = {
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
 
-struct apic __refdata apic_es7000 = {
+static struct apic __refdata apic_es7000 = {
 
 	.name				= "es7000",
 	.probe				= probe_es7000,
@@ -747,3 +747,9 @@ struct apic __refdata apic_es7000 = {
 
 	.x86_32_early_logical_apicid	= es7000_early_logical_apicid,
 };
+
+/*
+ * Need to check for es7000 followed by es7000_cluster, so this order
+ * in apic_drivers is important.
+ */
+apic_drivers(apic_es7000, apic_es7000_cluster);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 45fd33d..9488dcf 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -76,17 +76,40 @@ int sis_apic_bug = -1;
 static DEFINE_RAW_SPINLOCK(ioapic_lock);
 static DEFINE_RAW_SPINLOCK(vector_lock);
 
-/*
- * # of IRQ routing registers
- */
-int nr_ioapic_registers[MAX_IO_APICS];
+static struct ioapic {
+	/*
+	 * # of IRQ routing registers
+	 */
+	int nr_registers;
+	/*
+	 * Saved state during suspend/resume, or while enabling intr-remap.
+	 */
+	struct IO_APIC_route_entry *saved_registers;
+	/* I/O APIC config */
+	struct mpc_ioapic mp_config;
+	/* IO APIC gsi routing info */
+	struct mp_ioapic_gsi  gsi_config;
+	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
+} ioapics[MAX_IO_APICS];
 
-/* I/O APIC entries */
-struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
-int nr_ioapics;
+#define mpc_ioapic_ver(id)		ioapics[id].mp_config.apicver
+
+int mpc_ioapic_id(int id)
+{
+	return ioapics[id].mp_config.apicid;
+}
 
-/* IO APIC gsi routing info */
-struct mp_ioapic_gsi  mp_gsi_routing[MAX_IO_APICS];
+unsigned int mpc_ioapic_addr(int id)
+{
+	return ioapics[id].mp_config.apicaddr;
+}
+
+struct mp_ioapic_gsi *mp_ioapic_gsi_routing(int id)
+{
+	return &ioapics[id].gsi_config;
+}
+
+int nr_ioapics;
 
 /* The one past the highest gsi number used */
 u32 gsi_top;
@@ -179,6 +202,14 @@ int __init arch_early_irq_init(void)
 		io_apic_irqs = ~0UL;
 	}
 
+	for (i = 0; i < nr_ioapics; i++) {
+		ioapics[i].saved_registers =
+			kzalloc(sizeof(struct IO_APIC_route_entry) *
+				ioapics[i].nr_registers, GFP_KERNEL);
+		if (!ioapics[i].saved_registers)
+			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
+	}
+
 	cfg = irq_cfgx;
 	count = ARRAY_SIZE(irq_cfgx);
 	node = cpu_to_node(0);
@@ -297,7 +328,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].apicaddr & ~PAGE_MASK);
+		+ (mpc_ioapic_addr(idx) & ~PAGE_MASK);
 }
 
 static inline void io_apic_eoi(unsigned int apic, unsigned int vector)
@@ -573,7 +604,7 @@ static void clear_IO_APIC (void)
 	int apic, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++)
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			clear_IO_APIC_pin(apic, pin);
 }
 
@@ -615,74 +646,43 @@ static int __init ioapic_pirq_setup(char *str)
 __setup("pirq=", ioapic_pirq_setup);
 #endif /* CONFIG_X86_32 */
 
-struct IO_APIC_route_entry **alloc_ioapic_entries(void)
-{
-	int apic;
-	struct IO_APIC_route_entry **ioapic_entries;
-
-	ioapic_entries = kzalloc(sizeof(*ioapic_entries) * nr_ioapics,
-				GFP_KERNEL);
-	if (!ioapic_entries)
-		return 0;
-
-	for (apic = 0; apic < nr_ioapics; apic++) {
-		ioapic_entries[apic] =
-			kzalloc(sizeof(struct IO_APIC_route_entry) *
-				nr_ioapic_registers[apic], GFP_KERNEL);
-		if (!ioapic_entries[apic])
-			goto nomem;
-	}
-
-	return ioapic_entries;
-
-nomem:
-	while (--apic >= 0)
-		kfree(ioapic_entries[apic]);
-	kfree(ioapic_entries);
-
-	return 0;
-}
-
 /*
  * Saves all the IO-APIC RTE's
  */
-int save_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+int save_ioapic_entries(void)
 {
 	int apic, pin;
-
-	if (!ioapic_entries)
-		return -ENOMEM;
+	int err = 0;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			return -ENOMEM;
+		if (!ioapics[apic].saved_registers) {
+			err = -ENOMEM;
+			continue;
+		}
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
-			ioapic_entries[apic][pin] =
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
+			ioapics[apic].saved_registers[pin] =
 				ioapic_read_entry(apic, pin);
 	}
 
-	return 0;
+	return err;
 }
 
 /*
  * Mask all IO APIC entries.
  */
-void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+void mask_ioapic_entries(void)
 {
 	int apic, pin;
 
-	if (!ioapic_entries)
-		return;
-
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			break;
+		if (ioapics[apic].saved_registers)
+			continue;
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 
-			entry = ioapic_entries[apic][pin];
+			entry = ioapics[apic].saved_registers[pin];
 			if (!entry.mask) {
 				entry.mask = 1;
 				ioapic_write_entry(apic, pin, entry);
@@ -692,36 +692,23 @@ void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
 }
 
 /*
- * Restore IO APIC entries which was saved in ioapic_entries.
+ * Restore IO APIC entries which was saved in the ioapic structure.
  */
-int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries)
+int restore_ioapic_entries(void)
 {
 	int apic, pin;
 
-	if (!ioapic_entries)
-		return -ENOMEM;
-
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		if (!ioapic_entries[apic])
-			return -ENOMEM;
+		if (ioapics[apic].saved_registers)
+			continue;
 
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++)
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++)
 			ioapic_write_entry(apic, pin,
-					ioapic_entries[apic][pin]);
+					   ioapics[apic].saved_registers[pin]);
 	}
 	return 0;
 }
 
-void free_ioapic_entries(struct IO_APIC_route_entry **ioapic_entries)
-{
-	int apic;
-
-	for (apic = 0; apic < nr_ioapics; apic++)
-		kfree(ioapic_entries[apic]);
-
-	kfree(ioapic_entries);
-}
-
 /*
  * Find the IRQ entry number of a certain pin.
  */
@@ -731,7 +718,7 @@ static int find_irq_entry(int apic, int pin, int type)
 
 	for (i = 0; i < mp_irq_entries; i++)
 		if (mp_irqs[i].irqtype == type &&
-		    (mp_irqs[i].dstapic == mp_ioapics[apic].apicid ||
+		    (mp_irqs[i].dstapic == mpc_ioapic_id(apic) ||
 		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
 		    mp_irqs[i].dstirq == pin)
 			return i;
@@ -773,7 +760,7 @@ static int __init find_isa_irq_apic(int irq, int type)
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic)
+			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic)
 				return apic;
 		}
 	}
@@ -942,6 +929,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq;
 	int bus = mp_irqs[idx].srcbus;
+	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(apic);
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
@@ -952,7 +940,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 	if (test_bit(bus, mp_bus_not_pci)) {
 		irq = mp_irqs[idx].srcbusirq;
 	} else {
-		u32 gsi = mp_gsi_routing[apic].gsi_base + pin;
+		u32 gsi = gsi_cfg->gsi_base + pin;
 
 		if (gsi >= NR_IRQS_LEGACY)
 			irq = gsi;
@@ -1003,7 +991,7 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin,
 		int lbus = mp_irqs[i].srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			if (mpc_ioapic_id(apic) == mp_irqs[i].dstapic ||
 			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
@@ -1222,7 +1210,7 @@ static inline int IO_APIC_irq_trigger(int irq)
 	int apic, idx, pin;
 
 	for (apic = 0; apic < nr_ioapics; apic++) {
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			idx = find_irq_entry(apic, pin, mp_INT);
 			if ((idx != -1) && (irq == pin_2_irq(idx, apic, pin)))
 				return irq_trigger(idx);
@@ -1350,14 +1338,14 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic_id, mp_ioapics[apic_id].apicid, pin, cfg->vector,
+		    apic_id, mpc_ioapic_id(apic_id), pin, cfg->vector,
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic_id].apicid, irq, &entry,
+	if (setup_ioapic_entry(mpc_ioapic_id(apic_id), irq, &entry,
 			       dest, trigger, polarity, cfg->vector, pin)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic_id].apicid, pin);
+		       mpc_ioapic_id(apic_id), pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1369,17 +1357,13 @@ static void setup_ioapic_irq(int apic_id, int pin, unsigned int irq,
 	ioapic_write_entry(apic_id, pin, entry);
 }
 
-static struct {
-	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
-} mp_ioapic_routing[MAX_IO_APICS];
-
 static bool __init io_apic_pin_not_connected(int idx, int apic_id, int pin)
 {
 	if (idx != -1)
 		return false;
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG " apic %d pin %d not connected\n",
-		    mp_ioapics[apic_id].apicid, pin);
+		    mpc_ioapic_id(apic_id), pin);
 	return true;
 }
 
@@ -1389,7 +1373,7 @@ static void __init __io_apic_setup_irqs(unsigned int apic_id)
 	struct io_apic_irq_attr attr;
 	unsigned int pin, irq;
 
-	for (pin = 0; pin < nr_ioapic_registers[apic_id]; pin++) {
+	for (pin = 0; pin < ioapics[apic_id].nr_registers; pin++) {
 		idx = find_irq_entry(apic_id, pin, mp_INT);
 		if (io_apic_pin_not_connected(idx, apic_id, pin))
 			continue;
@@ -1511,7 +1495,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
+		       mpc_ioapic_id(i), ioapics[i].nr_registers);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1531,7 +1515,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mpc_ioapic_id(apic));
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -1825,7 +1809,7 @@ void __init enable_IO_APIC(void)
 	for(apic = 0; apic < nr_ioapics; apic++) {
 		int pin;
 		/* See if any of the pins is in ExtINT mode */
-		for (pin = 0; pin < nr_ioapic_registers[apic]; pin++) {
+		for (pin = 0; pin < ioapics[apic].nr_registers; pin++) {
 			struct IO_APIC_route_entry entry;
 			entry = ioapic_read_entry(apic, pin);
 
@@ -1949,14 +1933,14 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		reg_00.raw = io_apic_read(apic_id, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mp_ioapics[apic_id].apicid;
+		old_id = mpc_ioapic_id(apic_id);
 
-		if (mp_ioapics[apic_id].apicid >= get_physical_broadcast()) {
+		if (mpc_ioapic_id(apic_id) >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic_id, mp_ioapics[apic_id].apicid);
+				apic_id, mpc_ioapic_id(apic_id));
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic_id].apicid = reg_00.bits.ID;
+			ioapics[apic_id].mp_config.apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -1965,9 +1949,9 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (apic->check_apicid_used(&phys_id_present_map,
-					mp_ioapics[apic_id].apicid)) {
+					    mpc_ioapic_id(apic_id))) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic_id, mp_ioapics[apic_id].apicid);
+				apic_id, mpc_ioapic_id(apic_id));
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -1976,13 +1960,14 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic_id].apicid = i;
+			ioapics[apic_id].mp_config.apicid = i;
 		} else {
 			physid_mask_t tmp;
-			apic->apicid_to_cpu_present(mp_ioapics[apic_id].apicid, &tmp);
+			apic->apicid_to_cpu_present(mpc_ioapic_id(apic_id),
+						    &tmp);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic_id].apicid);
+					mpc_ioapic_id(apic_id));
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -1990,24 +1975,24 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic_id].apicid)
+		if (old_id != mpc_ioapic_id(apic_id))
 			for (i = 0; i < mp_irq_entries; i++)
 				if (mp_irqs[i].dstapic == old_id)
 					mp_irqs[i].dstapic
-						= mp_ioapics[apic_id].apicid;
+						= mpc_ioapic_id(apic_id);
 
 		/*
 		 * Update the ID register according to the right value
 		 * from the MPC table if they are different.
 		 */
-		if (mp_ioapics[apic_id].apicid == reg_00.bits.ID)
+		if (mpc_ioapic_id(apic_id) == reg_00.bits.ID)
 			continue;
 
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic_id].apicid);
+			mpc_ioapic_id(apic_id));
 
-		reg_00.bits.ID = mp_ioapics[apic_id].apicid;
+		reg_00.bits.ID = mpc_ioapic_id(apic_id);
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic_id, 0, reg_00.raw);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -2018,7 +2003,7 @@ void __init setup_ioapic_ids_from_mpc_nocheck(void)
 		raw_spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic_id, 0);
 		raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic_id].apicid)
+		if (reg_00.bits.ID != mpc_ioapic_id(apic_id))
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -2404,7 +2389,7 @@ static void eoi_ioapic_irq(unsigned int irq, struct irq_cfg *cfg)
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	for_each_irq_pin(entry, cfg->irq_2_pin) {
-		if (mp_ioapics[entry->apic].apicver >= 0x20) {
+		if (mpc_ioapic_ver(entry->apic) >= 0x20) {
 			/*
 			 * Intr-remapping uses pin number as the virtual vector
 			 * in the RTE. Actual vector is programmed in
@@ -2918,49 +2903,19 @@ static int __init io_apic_bug_finalize(void)
 
 late_initcall(io_apic_bug_finalize);
 
-static struct IO_APIC_route_entry *ioapic_saved_data[MAX_IO_APICS];
-
-static void suspend_ioapic(int ioapic_id)
+static void resume_ioapic_id(int ioapic_id)
 {
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
-	int i;
-
-	if (!saved_data)
-		return;
-
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		saved_data[i] = ioapic_read_entry(ioapic_id, i);
-}
-
-static int ioapic_suspend(void)
-{
-	int ioapic_id;
-
-	for (ioapic_id = 0; ioapic_id < nr_ioapics; ioapic_id++)
-		suspend_ioapic(ioapic_id);
-
-	return 0;
-}
-
-static void resume_ioapic(int ioapic_id)
-{
-	struct IO_APIC_route_entry *saved_data = ioapic_saved_data[ioapic_id];
 	unsigned long flags;
 	union IO_APIC_reg_00 reg_00;
-	int i;
 
-	if (!saved_data)
-		return;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(ioapic_id, 0);
-	if (reg_00.bits.ID != mp_ioapics[ioapic_id].apicid) {
-		reg_00.bits.ID = mp_ioapics[ioapic_id].apicid;
+	if (reg_00.bits.ID != mpc_ioapic_id(ioapic_id)) {
+		reg_00.bits.ID = mpc_ioapic_id(ioapic_id);
 		io_apic_write(ioapic_id, 0, reg_00.raw);
 	}
 	raw_spin_unlock_irqrestore(&ioapic_lock, flags);
-	for (i = 0; i < nr_ioapic_registers[ioapic_id]; i++)
-		ioapic_write_entry(ioapic_id, i, saved_data[i]);
 }
 
 static void ioapic_resume(void)
@@ -2968,28 +2923,18 @@ static void ioapic_resume(void)
 	int ioapic_id;
 
 	for (ioapic_id = nr_ioapics - 1; ioapic_id >= 0; ioapic_id--)
-		resume_ioapic(ioapic_id);
+		resume_ioapic_id(ioapic_id);
+
+	restore_ioapic_entries();
 }
 
 static struct syscore_ops ioapic_syscore_ops = {
-	.suspend = ioapic_suspend,
+	.suspend = save_ioapic_entries,
 	.resume = ioapic_resume,
 };
 
 static int __init ioapic_init_ops(void)
 {
-	int i;
-
-	for (i = 0; i < nr_ioapics; i++) {
-		unsigned int size;
-
-		size = nr_ioapic_registers[i]
-			* sizeof(struct IO_APIC_route_entry);
-		ioapic_saved_data[i] = kzalloc(size, GFP_KERNEL);
-		if (!ioapic_saved_data[i])
-			pr_err("IOAPIC %d: suspend/resume impossible!\n", i);
-	}
-
 	register_syscore_ops(&ioapic_syscore_ops);
 
 	return 0;
@@ -3592,14 +3537,14 @@ int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 	int ret;
 
 	/* Avoid redundant programming */
-	if (test_bit(pin, mp_ioapic_routing[id].pin_programmed)) {
+	if (test_bit(pin, ioapics[id].pin_programmed)) {
 		pr_debug("Pin %d-%d already programmed\n",
-			 mp_ioapics[id].apicid, pin);
+			 mpc_ioapic_id(id), pin);
 		return 0;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
-		set_bit(pin, mp_ioapic_routing[id].pin_programmed);
+		set_bit(pin, ioapics[id].pin_programmed);
 	return ret;
 }
 
@@ -3764,8 +3709,7 @@ static u8 __init io_apic_unique_id(u8 id)
 
 	bitmap_zero(used, 256);
 	for (i = 0; i < nr_ioapics; i++) {
-		struct mpc_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->apicid, used);
+		__set_bit(mpc_ioapic_id(i), used);
 	}
 	if (!test_bit(id, used))
 		return id;
@@ -3825,7 +3769,7 @@ void __init setup_ioapic_dest(void)
 		return;
 
 	for (ioapic = 0; ioapic < nr_ioapics; ioapic++)
-	for (pin = 0; pin < nr_ioapic_registers[ioapic]; pin++) {
+	for (pin = 0; pin < ioapics[ioapic].nr_registers; pin++) {
 		irq_entry = find_irq_entry(ioapic, pin, mp_INT);
 		if (irq_entry == -1)
 			continue;
@@ -3896,7 +3840,7 @@ void __init ioapic_and_gsi_init(void)
 	ioapic_res = ioapic_setup_resources(nr_ioapics);
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].apicaddr;
+			ioapic_phys = mpc_ioapic_addr(i);
 #ifdef CONFIG_X86_32
 			if (!ioapic_phys) {
 				printk(KERN_ERR
@@ -3956,8 +3900,9 @@ int mp_find_ioapic(u32 gsi)
 
 	/* Find the IOAPIC that manages this GSI. */
 	for (i = 0; i < nr_ioapics; i++) {
-		if ((gsi >= mp_gsi_routing[i].gsi_base)
-		    && (gsi <= mp_gsi_routing[i].gsi_end))
+		struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(i);
+		if ((gsi >= gsi_cfg->gsi_base)
+		    && (gsi <= gsi_cfg->gsi_end))
 			return i;
 	}
 
@@ -3967,12 +3912,16 @@ int mp_find_ioapic(u32 gsi)
 
 int mp_find_ioapic_pin(int ioapic, u32 gsi)
 {
+	struct mp_ioapic_gsi *gsi_cfg;
+
 	if (WARN_ON(ioapic == -1))
 		return -1;
-	if (WARN_ON(gsi > mp_gsi_routing[ioapic].gsi_end))
+
+	gsi_cfg = mp_ioapic_gsi_routing(ioapic);
+	if (WARN_ON(gsi > gsi_cfg->gsi_end))
 		return -1;
 
-	return gsi - mp_gsi_routing[ioapic].gsi_base;
+	return gsi - gsi_cfg->gsi_base;
 }
 
 static __init int bad_ioapic(unsigned long address)
@@ -3994,40 +3943,42 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 {
 	int idx = 0;
 	int entries;
+	struct mp_ioapic_gsi *gsi_cfg;
 
 	if (bad_ioapic(address))
 		return;
 
 	idx = nr_ioapics;
 
-	mp_ioapics[idx].type = MP_IOAPIC;
-	mp_ioapics[idx].flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].apicaddr = address;
+	ioapics[idx].mp_config.type = MP_IOAPIC;
+	ioapics[idx].mp_config.flags = MPC_APIC_USABLE;
+	ioapics[idx].mp_config.apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].apicid = io_apic_unique_id(id);
-	mp_ioapics[idx].apicver = io_apic_get_version(idx);
+	ioapics[idx].mp_config.apicid = io_apic_unique_id(id);
+	ioapics[idx].mp_config.apicver = io_apic_get_version(idx);
 
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
 	entries = io_apic_get_redir_entries(idx);
-	mp_gsi_routing[idx].gsi_base = gsi_base;
-	mp_gsi_routing[idx].gsi_end = gsi_base + entries - 1;
+	gsi_cfg = mp_ioapic_gsi_routing(idx);
+	gsi_cfg->gsi_base = gsi_base;
+	gsi_cfg->gsi_end = gsi_base + entries - 1;
 
 	/*
 	 * The number of IO-APIC IRQ registers (== #pins):
 	 */
-	nr_ioapic_registers[idx] = entries;
+	ioapics[idx].nr_registers = entries;
 
-	if (mp_gsi_routing[idx].gsi_end >= gsi_top)
-		gsi_top = mp_gsi_routing[idx].gsi_end + 1;
+	if (gsi_cfg->gsi_end >= gsi_top)
+		gsi_top = gsi_cfg->gsi_end + 1;
 
 	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
-	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
-	       mp_gsi_routing[idx].gsi_base, mp_gsi_routing[idx].gsi_end);
+	       "GSI %d-%d\n", idx, mpc_ioapic_id(idx),
+	       mpc_ioapic_ver(idx), mpc_ioapic_addr(idx),
+	       gsi_cfg->gsi_base, gsi_cfg->gsi_end);
 
 	nr_ioapics++;
 }
diff --git a/arch/x86/kernel/apic/numaq_32.c b/arch/x86/kernel/apic/numaq_32.c
index 30f1331..c4a61ca 100644
--- a/arch/x86/kernel/apic/numaq_32.c
+++ b/arch/x86/kernel/apic/numaq_32.c
@@ -472,8 +472,8 @@ static void numaq_setup_portio_remap(void)
 		(u_long) xquad_portio, (u_long) num_quads*XQUAD_PORTIO_QUAD);
 }
 
-/* Use __refdata to keep false positive warning calm.	*/
-struct apic __refdata apic_numaq = {
+/* Use __refdata to keep false positive warning calm.  */
+static struct apic __refdata apic_numaq = {
 
 	.name				= "NUMAQ",
 	.probe				= probe_numaq,
@@ -537,3 +537,5 @@ struct apic __refdata apic_numaq = {
 	.x86_32_early_logical_apicid	= noop_x86_32_early_logical_apicid,
 	.x86_32_numa_cpu_node		= numaq_numa_cpu_node,
 };
+
+apic_driver(apic_numaq);
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 6541e47..b5254ad 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -52,31 +52,6 @@ static int __init print_ipi_mode(void)
 }
 late_initcall(print_ipi_mode);
 
-void __init default_setup_apic_routing(void)
-{
-	int version = apic_version[boot_cpu_physical_apicid];
-
-	if (num_possible_cpus() > 8) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (!APIC_XAPIC(version)) {
-				def_to_bigsmp = 0;
-				break;
-			}
-			/* If P4 and above fall through */
-		case X86_VENDOR_AMD:
-			def_to_bigsmp = 1;
-		}
-	}
-
-#ifdef CONFIG_X86_BIGSMP
-	generic_bigsmp_probe();
-#endif
-
-	if (apic->setup_apic_routing)
-		apic->setup_apic_routing();
-}
-
 static int default_x86_32_early_logical_apicid(int cpu)
 {
 	return 1 << cpu;
@@ -112,7 +87,7 @@ static int probe_default(void)
 	return 1;
 }
 
-struct apic apic_default = {
+static struct apic apic_default = {
 
 	.name				= "default",
 	.probe				= probe_default,
@@ -174,44 +149,22 @@ struct apic apic_default = {
 	.x86_32_early_logical_apicid	= default_x86_32_early_logical_apicid,
 };
 
-extern struct apic apic_numaq;
-extern struct apic apic_summit;
-extern struct apic apic_bigsmp;
-extern struct apic apic_es7000;
-extern struct apic apic_es7000_cluster;
+apic_driver(apic_default);
 
 struct apic *apic = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
 
-static struct apic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_NUMAQ
-	&apic_numaq,
-#endif
-#ifdef CONFIG_X86_SUMMIT
-	&apic_summit,
-#endif
-#ifdef CONFIG_X86_BIGSMP
-	&apic_bigsmp,
-#endif
-#ifdef CONFIG_X86_ES7000
-	&apic_es7000,
-	&apic_es7000_cluster,
-#endif
-	&apic_default,	/* must be last */
-	NULL,
-};
-
 static int cmdline_apic __initdata;
 static int __init parse_apic(char *arg)
 {
-	int i;
+	struct apic **drv;
 
 	if (!arg)
 		return -EINVAL;
 
-	for (i = 0; apic_probe[i]; i++) {
-		if (!strcmp(apic_probe[i]->name, arg)) {
-			apic = apic_probe[i];
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!strcmp((*drv)->name, arg)) {
+			apic = *drv;
 			cmdline_apic = 1;
 			return 0;
 		}
@@ -222,38 +175,58 @@ static int __init parse_apic(char *arg)
 }
 early_param("apic", parse_apic);
 
-void __init generic_bigsmp_probe(void)
+void __init default_setup_apic_routing(void)
 {
+	int version = apic_version[boot_cpu_physical_apicid];
+
+	if (num_possible_cpus() > 8) {
+		switch (boot_cpu_data.x86_vendor) {
+		case X86_VENDOR_INTEL:
+			if (!APIC_XAPIC(version)) {
+				def_to_bigsmp = 0;
+				break;
+			}
+			/* If P4 and above fall through */
+		case X86_VENDOR_AMD:
+			def_to_bigsmp = 1;
+		}
+	}
+
 #ifdef CONFIG_X86_BIGSMP
 	/*
-	 * This routine is used to switch to bigsmp mode when
+	 * This is used to switch to bigsmp mode when
 	 * - There is no apic= option specified by the user
 	 * - generic_apic_probe() has chosen apic_default as the sub_arch
 	 * - we find more than 8 CPUs in acpi LAPIC listing with xAPIC support
 	 */
 
 	if (!cmdline_apic && apic == &apic_default) {
-		if (apic_bigsmp.probe()) {
-			apic = &apic_bigsmp;
+		struct apic *bigsmp = generic_bigsmp_probe();
+		if (bigsmp) {
+			apic = bigsmp;
 			printk(KERN_INFO "Overriding APIC driver with %s\n",
 			       apic->name);
 		}
 	}
 #endif
+
+	if (apic->setup_apic_routing)
+		apic->setup_apic_routing();
 }
 
 void __init generic_apic_probe(void)
 {
 	if (!cmdline_apic) {
-		int i;
-		for (i = 0; apic_probe[i]; i++) {
-			if (apic_probe[i]->probe()) {
-				apic = apic_probe[i];
+		struct apic **drv;
+
+		for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+			if ((*drv)->probe()) {
+				apic = *drv;
 				break;
 			}
 		}
 		/* Not visible without early console */
-		if (!apic_probe[i])
+		if (drv == __apicdrivers_end)
 			panic("Didn't find an APIC driver");
 	}
 	printk(KERN_INFO "Using APIC driver %s\n", apic->name);
@@ -264,16 +237,16 @@ void __init generic_apic_probe(void)
 int __init
 generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->mps_oem_check)
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!((*drv)->mps_oem_check))
 			continue;
-		if (!apic_probe[i]->mps_oem_check(mpc, oem, productid))
+		if (!(*drv)->mps_oem_check(mpc, oem, productid))
 			continue;
 
 		if (!cmdline_apic) {
-			apic = apic_probe[i];
+			apic = *drv;
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
@@ -284,16 +257,16 @@ generic_mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (!apic_probe[i]->acpi_madt_oem_check)
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if (!(*drv)->acpi_madt_oem_check)
 			continue;
-		if (!apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id))
+		if (!(*drv)->acpi_madt_oem_check(oem_id, oem_table_id))
 			continue;
 
 		if (!cmdline_apic) {
-			apic = apic_probe[i];
+			apic = *drv;
 			printk(KERN_INFO "Switched to APIC driver `%s'.\n",
 			       apic->name);
 		}
diff --git a/arch/x86/kernel/apic/probe_64.c b/arch/x86/kernel/apic/probe_64.c
index d8c4a6f..3fe9866 100644
--- a/arch/x86/kernel/apic/probe_64.c
+++ b/arch/x86/kernel/apic/probe_64.c
@@ -23,27 +23,6 @@
 #include <asm/ipi.h>
 #include <asm/setup.h>
 
-extern struct apic apic_flat;
-extern struct apic apic_physflat;
-extern struct apic apic_x2xpic_uv_x;
-extern struct apic apic_x2apic_phys;
-extern struct apic apic_x2apic_cluster;
-
-struct apic __read_mostly *apic = &apic_flat;
-EXPORT_SYMBOL_GPL(apic);
-
-static struct apic *apic_probe[] __initdata = {
-#ifdef CONFIG_X86_UV
-	&apic_x2apic_uv_x,
-#endif
-#ifdef CONFIG_X86_X2APIC
-	&apic_x2apic_phys,
-	&apic_x2apic_cluster,
-#endif
-	&apic_physflat,
-	NULL,
-};
-
 static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
 {
 	return hard_smp_processor_id() >> index_msb;
@@ -54,26 +33,20 @@ static int apicid_phys_pkg_id(int initial_apic_id, int index_msb)
  */
 void __init default_setup_apic_routing(void)
 {
+	struct apic **drv;
 
 	enable_IR_x2apic();
 
-#ifdef CONFIG_X86_X2APIC
-	if (x2apic_mode
-#ifdef CONFIG_X86_UV
-		       && apic != &apic_x2apic_uv_x
-#endif
-		       ) {
-		if (x2apic_phys)
-			apic = &apic_x2apic_phys;
-		else
-			apic = &apic_x2apic_cluster;
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->probe && (*drv)->probe()) {
+			if (apic != *drv) {
+				apic = *drv;
+				pr_info("Switched APIC routing to %s.\n",
+					apic->name);
+			}
+			break;
+		}
 	}
-#endif
-
-	if (apic == &apic_flat && num_possible_cpus() > 8)
-			apic = &apic_physflat;
-
-	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 
 	if (is_vsmp_box()) {
 		/* need to update phys_pkg_id */
@@ -90,13 +63,15 @@ void apic_send_IPI_self(int vector)
 
 int __init default_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-	int i;
+	struct apic **drv;
 
-	for (i = 0; apic_probe[i]; ++i) {
-		if (apic_probe[i]->acpi_madt_oem_check(oem_id, oem_table_id)) {
-			apic = apic_probe[i];
-			printk(KERN_INFO "Setting APIC routing to %s.\n",
-				apic->name);
+	for (drv = __apicdrivers; drv < __apicdrivers_end; drv++) {
+		if ((*drv)->acpi_madt_oem_check(oem_id, oem_table_id)) {
+			if (apic != *drv) {
+				apic = *drv;
+				pr_info("Setting APIC routing to %s.\n",
+					apic->name);
+			}
 			return 1;
 		}
 	}
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 35bcd7d..1911442 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -491,7 +491,7 @@ void setup_summit(void)
 }
 #endif
 
-struct apic apic_summit = {
+static struct apic apic_summit = {
 
 	.name				= "summit",
 	.probe				= probe_summit,
@@ -552,3 +552,5 @@ struct apic apic_summit = {
 
 	.x86_32_early_logical_apicid	= summit_early_logical_apicid,
 };
+
+apic_driver(apic_summit);
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 90949bb..5007958 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -5,118 +5,95 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/dmar.h>
+#include <linux/cpu.h>
 
 #include <asm/smp.h>
-#include <asm/apic.h>
-#include <asm/ipi.h>
+#include <asm/x2apic.h>
 
 static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(cpumask_var_t, cpus_in_cluster);
+static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
 	return x2apic_enabled();
 }
 
-/*
- * need to use more than cpu 0, because we need more vectors when
- * MSI-X are used.
- */
-static const struct cpumask *x2apic_target_cpus(void)
+static inline u32 x2apic_cluster(int cpu)
 {
-	return cpu_online_mask;
-}
-
-/*
- * for now each logical cpu is in its own vector allocation domain.
- */
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
+	return per_cpu(x86_cpu_to_logical_apicid, cpu) >> 16;
 }
 
 static void
- __x2apic_send_IPI_dest(unsigned int apicid, int vector, unsigned int dest)
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
-	unsigned long cfg;
+	struct cpumask *cpus_in_cluster_ptr;
+	struct cpumask *ipi_mask_ptr;
+	unsigned int cpu, this_cpu;
+	unsigned long flags;
+	u32 dest;
+
+	x2apic_wrmsr_fence();
+
+	local_irq_save(flags);
 
-	cfg = __prepare_ICR(0, vector, dest);
+	this_cpu = smp_processor_id();
 
 	/*
-	 * send the IPI.
+	 * We are to modify mask, so we need an own copy
+	 * and be sure it's manipulated with irq off.
 	 */
-	native_x2apic_icr_write(cfg, apicid);
-}
+	ipi_mask_ptr = __raw_get_cpu_var(ipi_mask);
+	cpumask_copy(ipi_mask_ptr, mask);
 
-/*
- * for now, we send the IPI's one by one in the cpumask.
- * TBD: Based on the cpu mask, we can send the IPI's to the cluster group
- * at once. We have 16 cpu's in a cluster. This will minimize IPI register
- * writes.
- */
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
-{
-	unsigned long query_cpu;
-	unsigned long flags;
+	/*
+	 * The idea is to send one IPI per cluster.
+	 */
+	for_each_cpu(cpu, ipi_mask_ptr) {
+		unsigned long i;
 
-	x2apic_wrmsr_fence();
+		cpus_in_cluster_ptr = per_cpu(cpus_in_cluster, cpu);
+		dest = 0;
 
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		__x2apic_send_IPI_dest(
-			per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-			vector, apic->dest_logical);
+		/* Collect cpus in cluster. */
+		for_each_cpu_and(i, ipi_mask_ptr, cpus_in_cluster_ptr) {
+			if (apic_dest == APIC_DEST_ALLINC || i != this_cpu)
+				dest |= per_cpu(x86_cpu_to_logical_apicid, i);
+		}
+
+		if (!dest)
+			continue;
+
+		__x2apic_send_IPI_dest(dest, vector, apic->dest_logical);
+		/*
+		 * Cluster sibling cpus should be discared now so
+		 * we would not send IPI them second time.
+		 */
+		cpumask_andnot(ipi_mask_ptr, ipi_mask_ptr, cpus_in_cluster_ptr);
 	}
+
 	local_irq_restore(flags);
 }
 
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_logical_apicid, query_cpu),
-				vector, apic->dest_logical);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
-}
-
-static int x2apic_apic_id_registered(void)
-{
-	return 1;
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
@@ -151,43 +128,90 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return per_cpu(x86_cpu_to_logical_apicid, cpu);
 }
 
-static unsigned int x2apic_cluster_phys_get_apic_id(unsigned long x)
+static void init_x2apic_ldr(void)
 {
-	unsigned int id;
+	unsigned int this_cpu = smp_processor_id();
+	unsigned int cpu;
 
-	id = x;
-	return id;
+	per_cpu(x86_cpu_to_logical_apicid, this_cpu) = apic_read(APIC_LDR);
+
+	__cpu_set(this_cpu, per_cpu(cpus_in_cluster, this_cpu));
+	for_each_online_cpu(cpu) {
+		if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+			continue;
+		__cpu_set(this_cpu, per_cpu(cpus_in_cluster, cpu));
+		__cpu_set(cpu, per_cpu(cpus_in_cluster, this_cpu));
+	}
 }
 
-static unsigned long set_apic_id(unsigned int id)
+ /*
+  * At CPU state changes, update the x2apic cluster sibling info.
+  */
+static int __cpuinit
+update_clusterinfo(struct notifier_block *nfb, unsigned long action, void *hcpu)
 {
-	unsigned long x;
+	unsigned int this_cpu = (unsigned long)hcpu;
+	unsigned int cpu;
+	int err = 0;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+		if (!zalloc_cpumask_var(&per_cpu(cpus_in_cluster, this_cpu),
+					GFP_KERNEL)) {
+			err = -ENOMEM;
+		} else if (!zalloc_cpumask_var(&per_cpu(ipi_mask, this_cpu),
+					       GFP_KERNEL)) {
+			free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+			err = -ENOMEM;
+		}
+		break;
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+	case CPU_DEAD:
+		for_each_online_cpu(cpu) {
+			if (x2apic_cluster(this_cpu) != x2apic_cluster(cpu))
+				continue;
+			__cpu_clear(this_cpu, per_cpu(cpus_in_cluster, cpu));
+			__cpu_clear(cpu, per_cpu(cpus_in_cluster, this_cpu));
+		}
+		free_cpumask_var(per_cpu(cpus_in_cluster, this_cpu));
+		free_cpumask_var(per_cpu(ipi_mask, this_cpu));
+		break;
+	}
 
-	x = id;
-	return x;
+	return notifier_from_errno(err);
 }
 
-static int x2apic_cluster_phys_pkg_id(int initial_apicid, int index_msb)
-{
-	return initial_apicid >> index_msb;
-}
+static struct notifier_block __refdata x2apic_cpu_notifier = {
+	.notifier_call = update_clusterinfo,
+};
 
-static void x2apic_send_IPI_self(int vector)
+static int x2apic_init_cpu_notifier(void)
 {
-	apic_write(APIC_SELF_IPI, vector);
+	int cpu = smp_processor_id();
+
+	zalloc_cpumask_var(&per_cpu(cpus_in_cluster, cpu), GFP_KERNEL);
+	zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL);
+
+	BUG_ON(!per_cpu(cpus_in_cluster, cpu) || !per_cpu(ipi_mask, cpu));
+
+	__cpu_set(cpu, per_cpu(cpus_in_cluster, cpu));
+	register_hotcpu_notifier(&x2apic_cpu_notifier);
+	return 1;
 }
 
-static void init_x2apic_ldr(void)
+static int x2apic_cluster_probe(void)
 {
-	int cpu = smp_processor_id();
-
-	per_cpu(x86_cpu_to_logical_apicid, cpu) = apic_read(APIC_LDR);
+	if (x2apic_mode)
+		return x2apic_init_cpu_notifier();
+	else
+		return 0;
 }
 
-struct apic apic_x2apic_cluster = {
+static struct apic apic_x2apic_cluster = {
 
 	.name				= "cluster x2apic",
-	.probe				= NULL,
+	.probe				= x2apic_cluster_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
@@ -211,11 +235,11 @@ struct apic apic_x2apic_cluster = {
 	.setup_portio_remap		= NULL,
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
-	.phys_pkg_id			= x2apic_cluster_phys_pkg_id,
+	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= x2apic_cluster_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
@@ -240,3 +264,5 @@ struct apic apic_x2apic_cluster = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_cluster);
diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
index c7e6d66..f5373df 100644
--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -7,11 +7,12 @@
 #include <linux/dmar.h>
 
 #include <asm/smp.h>
-#include <asm/apic.h>
-#include <asm/ipi.h>
+#include <asm/x2apic.h>
 
 int x2apic_phys;
 
+static struct apic apic_x2apic_phys;
+
 static int set_x2apic_phys_mode(char *arg)
 {
 	x2apic_phys = 1;
@@ -27,94 +28,46 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 		return 0;
 }
 
-/*
- * need to use more than cpu 0, because we need more vectors when
- * MSI-X are used.
- */
-static const struct cpumask *x2apic_target_cpus(void)
-{
-	return cpu_online_mask;
-}
-
-static void x2apic_vector_allocation_domain(int cpu, struct cpumask *retmask)
-{
-	cpumask_clear(retmask);
-	cpumask_set_cpu(cpu, retmask);
-}
-
-static void __x2apic_send_IPI_dest(unsigned int apicid, int vector,
-				   unsigned int dest)
-{
-	unsigned long cfg;
-
-	cfg = __prepare_ICR(0, vector, dest);
-
-	/*
-	 * send the IPI.
-	 */
-	native_x2apic_icr_write(cfg, apicid);
-}
-
-static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+static void
+__x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 {
 	unsigned long query_cpu;
+	unsigned long this_cpu;
 	unsigned long flags;
 
 	x2apic_wrmsr_fence();
 
 	local_irq_save(flags);
+
+	this_cpu = smp_processor_id();
 	for_each_cpu(query_cpu, mask) {
+		if (apic_dest == APIC_DEST_ALLBUT && this_cpu == query_cpu)
+			continue;
 		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
 				       vector, APIC_DEST_PHYSICAL);
 	}
 	local_irq_restore(flags);
 }
 
+static void x2apic_send_IPI_mask(const struct cpumask *mask, int vector)
+{
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLINC);
+}
+
 static void
  x2apic_send_IPI_mask_allbutself(const struct cpumask *mask, int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_cpu(query_cpu, mask) {
-		if (query_cpu != this_cpu)
-			__x2apic_send_IPI_dest(
-				per_cpu(x86_cpu_to_apicid, query_cpu),
-				vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_allbutself(int vector)
 {
-	unsigned long this_cpu = smp_processor_id();
-	unsigned long query_cpu;
-	unsigned long flags;
-
-	x2apic_wrmsr_fence();
-
-	local_irq_save(flags);
-	for_each_online_cpu(query_cpu) {
-		if (query_cpu == this_cpu)
-			continue;
-		__x2apic_send_IPI_dest(per_cpu(x86_cpu_to_apicid, query_cpu),
-				       vector, APIC_DEST_PHYSICAL);
-	}
-	local_irq_restore(flags);
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLBUT);
 }
 
 static void x2apic_send_IPI_all(int vector)
 {
-	x2apic_send_IPI_mask(cpu_online_mask, vector);
-}
-
-static int x2apic_apic_id_registered(void)
-{
-	return 1;
+	__x2apic_send_IPI_mask(cpu_online_mask, vector, APIC_DEST_ALLINC);
 }
 
 static unsigned int x2apic_cpu_mask_to_apicid(const struct cpumask *cpumask)
@@ -149,34 +102,22 @@ x2apic_cpu_mask_to_apicid_and(const struct cpumask *cpumask,
 	return per_cpu(x86_cpu_to_apicid, cpu);
 }
 
-static unsigned int x2apic_phys_get_apic_id(unsigned long x)
-{
-	return x;
-}
-
-static unsigned long set_apic_id(unsigned int id)
-{
-	return id;
-}
-
-static int x2apic_phys_pkg_id(int initial_apicid, int index_msb)
+static void init_x2apic_ldr(void)
 {
-	return initial_apicid >> index_msb;
 }
 
-static void x2apic_send_IPI_self(int vector)
+static int x2apic_phys_probe(void)
 {
-	apic_write(APIC_SELF_IPI, vector);
-}
+	if (x2apic_mode && x2apic_phys)
+		return 1;
 
-static void init_x2apic_ldr(void)
-{
+	return apic == &apic_x2apic_phys;
 }
 
-struct apic apic_x2apic_phys = {
+static struct apic apic_x2apic_phys = {
 
 	.name				= "physical x2apic",
-	.probe				= NULL,
+	.probe				= x2apic_phys_probe,
 	.acpi_madt_oem_check		= x2apic_acpi_madt_oem_check,
 	.apic_id_registered		= x2apic_apic_id_registered,
 
@@ -203,8 +144,8 @@ struct apic apic_x2apic_phys = {
 	.phys_pkg_id			= x2apic_phys_pkg_id,
 	.mps_oem_check			= NULL,
 
-	.get_apic_id			= x2apic_phys_get_apic_id,
-	.set_apic_id			= set_apic_id,
+	.get_apic_id			= x2apic_get_apic_id,
+	.set_apic_id			= x2apic_set_apic_id,
 	.apic_id_mask			= 0xFFFFFFFFu,
 
 	.cpu_mask_to_apicid		= x2apic_cpu_mask_to_apicid,
@@ -229,3 +170,5 @@ struct apic apic_x2apic_phys = {
 	.wait_icr_idle			= native_x2apic_wait_icr_idle,
 	.safe_wait_icr_idle		= native_safe_x2apic_wait_icr_idle,
 };
+
+apic_driver(apic_x2apic_phys);
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 7acd2d2..f450b68 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -58,6 +58,8 @@ unsigned int uv_apicid_hibits;
 EXPORT_SYMBOL_GPL(uv_apicid_hibits);
 static DEFINE_SPINLOCK(uv_nmi_lock);
 
+static struct apic apic_x2apic_uv_x;
+
 static unsigned long __init uv_early_read_mmr(unsigned long addr)
 {
 	unsigned long val, *mmr;
@@ -326,10 +328,15 @@ static void uv_send_IPI_self(int vector)
 	apic_write(APIC_SELF_IPI, vector);
 }
 
-struct apic __refdata apic_x2apic_uv_x = {
+static int uv_probe(void)
+{
+	return apic == &apic_x2apic_uv_x;
+}
+
+static struct apic __refdata apic_x2apic_uv_x = {
 
 	.name				= "UV large system",
-	.probe				= NULL,
+	.probe				= uv_probe,
 	.acpi_madt_oem_check		= uv_acpi_madt_oem_check,
 	.apic_id_registered		= uv_apic_id_registered,
 
@@ -859,3 +866,5 @@ void __init uv_system_init(void)
 	if (is_kdump_kernel())
 		reboot_type = BOOT_ACPI;
 }
+
+apic_driver(apic_x2apic_uv_x);
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index e90f084..690bc84 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -369,6 +369,7 @@ static struct of_ioapic_type of_ioapic_type[] =
 static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
 			u32 *out_hwirq, u32 *out_type)
 {
+	struct mp_ioapic_gsi *gsi_cfg;
 	struct io_apic_irq_attr attr;
 	struct of_ioapic_type *it;
 	u32 line, idx, type;
@@ -378,7 +379,8 @@ static int ioapic_xlate(struct irq_domain *id, const u32 *intspec, u32 intsize,
 
 	line = *intspec;
 	idx = (u32) id->priv;
-	*out_hwirq = line + mp_gsi_routing[idx].gsi_base;
+	gsi_cfg = mp_ioapic_gsi_routing(idx);
+	*out_hwirq = line + gsi_cfg->gsi_base;
 
 	intspec++;
 	type = *intspec;
@@ -407,7 +409,7 @@ static void __init ioapic_add_ofnode(struct device_node *np)
 	}
 
 	for (i = 0; i < nr_ioapics; i++) {
-		if (r.start == mp_ioapics[i].apicaddr) {
+		if (r.start == mpc_ioapic_addr(i)) {
 			struct irq_domain *id;
 
 			id = kzalloc(sizeof(*id), GFP_KERNEL);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6f9bfff..9103b89 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -285,7 +285,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	intsrc.type = MP_INTSRC;
 	intsrc.irqflag = 0;	/* conforming */
 	intsrc.srcbus = 0;
-	intsrc.dstapic = mp_ioapics[0].apicid;
+	intsrc.dstapic = mpc_ioapic_id(0);
 
 	intsrc.irqtype = mp_INT;
 
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 624a201..49927a8 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -306,6 +306,13 @@ SECTIONS
 	}
 
 	. = ALIGN(8);
+	.apicdrivers : AT(ADDR(.apicdrivers) - LOAD_OFFSET) {
+		__apicdrivers = .;
+		*(.apicdrivers);
+		__apicdrivers_end = .;
+	}
+
+	. = ALIGN(8);
 	/*
 	 * .exit.text is discard at runtime, not link time, to deal with
 	 *  references from .altinstructions and .eh_frame
