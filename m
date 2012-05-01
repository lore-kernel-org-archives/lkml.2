Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758440Ab2EATsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 15:48:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:43190 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab2EATse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 15:48:34 -0400
Date: Tue, 1 May 2012 15:42:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mingo@kernel.org
Cc: suresh.b.siddha@intel.com, mlin@ss.pku.edu.cn
Subject: [GIT PULL] stable/for-ingo-v3.5 of IOAPIC abstraction (and then some
 users) for v3.5
Message-ID: <20120501194240.GA15237@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ingo,

Please git pull the following branch for v3.5:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-ingo-v3.5

It has the proper fix for the IO-APIC having 0xfdfdfd... contents when booting
under Xen. It also abstracts the IO-APIC in a different layer allowing for re-using
of the generic code.

Compared to the patch you have already in the tree
(136d249ef7dbf0fefa292082cc40be1ea864cbd6 x86/ioapic: Add io_apic_ops driver
layer to allow interception) it does four things:

 1) Exposes the io_apic baremetal functions and uses the x86_io_apic_ops
    function table instead of keeping it in the io_apic. This makes the code fit
    within the rest of x86_ops functions.
 2) Use the x86_io_apic_ops to re-direct the (*read) to the Xen emulated one.
 3) Removes the work-around.
 4) Implements a read hypercall to get the contents of the IOAPIC. Note:
    There is no (*write) as it is not needed.

With these patches, this is what we end up seeing (for Xen):

 ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
-IOAPIC[0]: apic_id 0, version 253, address 0xfec00000, GSI 0-253
+IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
 ACPI: IOAPIC (id[0x01] address[0xfec3f000] gsi_base[24])
-IOAPIC[1]: apic_id 1, version 253, address 0xfec3f000, GSI 24-277
+IOAPIC[1]: apic_id 1, version 32, address 0xfec3f000, GSI 24-47
 ACPI: IOAPIC (id[0x02] address[0xfec7f000] gsi_base[48])
-IOAPIC[2]: apic_id 2, version 253, address 0xfec7f000, GSI 48-301
+IOAPIC[2]: apic_id 2, version 32, address 0xfec7f000, GSI 48-71

for baremetal - there is no change in the output or functionality.

Please pull!

 arch/x86/include/asm/io_apic.h  |   35 +++++++++++++++++++----------
 arch/x86/include/asm/x86_init.h |    9 ++++++-
 arch/x86/kernel/apic/io_apic.c  |   46 +++-----------------------------------
 arch/x86/kernel/setup.c         |    2 +-
 arch/x86/kernel/x86_init.c      |    8 ++++++
 arch/x86/xen/Makefile           |    2 +-
 arch/x86/xen/apic.c             |   30 +++++++++++++++++++++++++
 arch/x86/xen/enlighten.c        |    2 +
 arch/x86/xen/mmu.c              |    4 +--
 arch/x86/xen/xen-ops.h          |    4 +++
 10 files changed, 82 insertions(+), 60 deletions(-)

Konrad Rzeszutek Wilk (3):
      x86/apic: Replace io_apic_ops with x86_io_apic_ops.
      xen/x86: Implement x86_apic_ops
      Revert "xen/x86: Workaround 'x86/ioapic: Add register level checks to detect bogus io-apic entries'"

Lin Ming (1):
      xen/apic: implement io apic read with hypercall

And the full diff.

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
index 764b66a..c090af1 100644
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
index 9cf71d0..35c5e54 100644
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
@@ -119,3 +120,10 @@ struct x86_msi_ops x86_msi = {
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
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index add2c2d..96ab2c0 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -20,5 +20,5 @@ obj-$(CONFIG_EVENT_TRACING) += trace.o
 obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
-obj-$(CONFIG_XEN_DOM0)		+= vga.o
+obj-$(CONFIG_XEN_DOM0)		+= apic.o vga.o
 obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
new file mode 100644
index 0000000..1913bf2
--- /dev/null
+++ b/arch/x86/xen/apic.c
@@ -0,0 +1,30 @@
+#include <linux/init.h>
+#include <asm/x86_init.h>
+#include <asm/apic.h>
+#include <xen/interface/physdev.h>
+#include <asm/xen/hypercall.h>
+
+unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
+{
+	struct physdev_apic apic_op;
+	int ret;
+
+	apic_op.apic_physbase = mpc_ioapic_addr(apic);
+	apic_op.reg = reg;
+	ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
+	if (!ret)
+		return apic_op.value;
+
+	/* fallback to return an emulated IO_APIC values */
+	if (reg == 0x1)
+		return 0x00170020;
+	else if (reg == 0x0)
+		return apic << 24;
+
+	return 0xfd;
+}
+
+void __init xen_init_apic(void)
+{
+	x86_io_apic_ops.read = xen_io_apic_read;
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a8f8844..c2ea9e9 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1362,6 +1362,8 @@ asmlinkage void __init xen_start_kernel(void)
 		xen_start_info->console.domU.mfn = 0;
 		xen_start_info->console.domU.evtchn = 0;
 
+		xen_init_apic();
+
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b8e2794..988828b 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1859,7 +1859,6 @@ pgd_t * __init xen_setup_kernel_pagetable(pgd_t *pgd,
 #endif	/* CONFIG_X86_64 */
 
 static unsigned char dummy_mapping[PAGE_SIZE] __page_aligned_bss;
-static unsigned char fake_ioapic_mapping[PAGE_SIZE] __page_aligned_bss;
 
 static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 {
@@ -1900,7 +1899,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 		 * We just don't map the IO APIC - all access is via
 		 * hypercalls.  Keep the address in the pte for reference.
 		 */
-		pte = pfn_pte(PFN_DOWN(__pa(fake_ioapic_mapping)), PAGE_KERNEL);
+		pte = pfn_pte(PFN_DOWN(__pa(dummy_mapping)), PAGE_KERNEL);
 		break;
 #endif
 
@@ -2065,7 +2064,6 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 
 	memset(dummy_mapping, 0xff, PAGE_SIZE);
-	memset(fake_ioapic_mapping, 0xfd, PAGE_SIZE);
 }
 
 /* Protected by xen_reservation_lock. */
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index b095739..45c0c06 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -92,11 +92,15 @@ struct dom0_vga_console_info;
 
 #ifdef CONFIG_XEN_DOM0
 void __init xen_init_vga(const struct dom0_vga_console_info *, size_t size);
+void __init xen_init_apic(void);
 #else
 static inline void __init xen_init_vga(const struct dom0_vga_console_info *info,
 				       size_t size)
 {
 }
+static inline void __init xen_init_apic(void)
+{
+}
 #endif
 
 /* Declare an asm function, along with symbols needed to make it
