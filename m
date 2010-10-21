Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0JUPh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 11:37:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45064 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578Ab0JUPhZ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 21 Oct 2010 11:37:25 -0400
Date: Thu, 21 Oct 2010 11:05:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, jeremy@goop.org,
        stefano.stabellini@eu.citrix.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] stable/xen-pcifront-0.8.2 for 2.6.37
Message-ID: <20101021150533.GA32607@dumpdata.com>
References: <alpine.LFD.2.00.1010211628010.2418@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010211628010.2418@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Hey Thomas: replaying to your e-mail thread as my patchset depends on your
sparse-irq work]

Hello Linus,

Please pull from:
git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/xen-pcifront-0.8.2

for patches since git commit 032fa36091a925f555158f4e80f8a09d951cdb10
Thomas Gleixner (1):
    arm: Use ARCH_IRQ_INIT_FLAGS

[also known as "irq-core-for-linus"]. My patchset has been rebased on top of Thomas's
sparse_irq work, but if you prefer to have it based off your tree (v2.6.36-rc7),
there is stable/xen-pcifront-0.8.1 branch which has no sparse_irq work. If you
choose that route, the patch "x86: xen: Sanitse irq handling (part two)"
would have to be applied after tip/irq/core had been merged in after my patchset.
I can follow up with that patch if you would like.

(Thomas merged the latest v2.6.36-rc8 in his "irq-core-for-linus",
and to my pleasant surprise a rebase on top of his "irq-core-for-linus" shows
no conflict feast, and merge of his tree and mine is clean-free - I can do this if
you would like, but thought it best to keep it as is so there would not be churn).

Back to this patch set:

This patch set contains the supporting patches and the driver itself for
Xen Paravirtualized (PV) domains to use PCI pass-through devices.
This patch-set is also utilized in Stefano's PV on HVM MSI/MSI-X patchset, and
his initial domain support [1]. The impact of this patchset is that
domU guests can utilize PCI devices.

The Xen PCI frontend driver can be used by PV guests on IOMMU hardware
(or IOMMU-less). Without the hardware IOMMU you have a potential security
hole wherein a guest domain can use the hardware to map pages outside its
memory range and slurp pages up. As such, this is more restricted to a
Privileged PV domain, aka - device driver domain (similar to Qubes but a
poor-man mechanism [2]).

The first set of patches are specific to the Xen subsystem, where
we introduce an IRQ chip for Physical IRQs, along with the supporting
harness code:
 xen: Don't disable the I/O space
 xen: define BIOVEC_PHYS_MERGEABLE()
 xen: implement pirq type event channels
 xen: identity map gsi->irqs
 xen: dynamically allocate irq & event structures
 xen: set pirq name to something useful.
 xen: statically initialize cpu_evtchn_mask_p
 xen: Find an unbound irq number in reverse order (high to low).
 xen: Provide a variant of xen_poll_irq with timeout.
 xen: fix shared irq device passthrough

The next set of patches expose functionality for module drivers to be able to
enumerate and iomap (using the _PAGE_IOMAP flag) PCI devices.

 x86/io_apic: add get_nr_irqs_gsi()
 x86/PCI: Clean up pci_cache_line_size
 x86/PCI: make sure _PAGE_IOMAP it set on pci mappings
 x86/PCI: Export pci_walk_bus function.

The next two patches abstract the MSI/MSI-X architecture calls so that the
default native one (used on bare-metal) can be overwritten when running
in virtualized mode (right now on Xen). The implementation is a simple
function pointer structure.

 msi: Introduce default_[teardown|setup]_msi_irqs with fallback.
 x86: Introduce x86_msi_ops

Next, the Xen PCI stub driver. I've put it in the same location
where other sub-platform PCI drivers are. It hooks up to the
PCI legacy IRQ setup ('pcibios_enable_irq'), and MSI/MSI-X
allocation/de-allocation (via the x86_msi_ops introduced in earlier patches).

 xen/x86/PCI: Add support for the Xen PCI subsystem

Lastly, the Xen PCI front-end driver which is responsible for hooking up
to the PCI configuration read/write methods via the 'pci_scan_bus_parented' call.
In essence all pci_conf_read/write in the guest will be tunneled via
pcifront_bus_[read|write] methods. The MSI/MSI-X calls will be handled
by the Xen-PCI front-end driver as well. We also need to add a new
state so updating the XenBus:

 xenbus: Xen paravirtualised PCI hotplug support.
 xenbus: prevent warnings on unhandled enumeration values
 xen-pcifront: Xen PCI frontend driver.

Then various fixes and updating the MAINTAINERs file with my name:

 xen/pci: Request ACS when Xen-SWIOTLB is activated.
 MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
 swiotlb-xen: On x86-32 builts, select SWIOTLB instead of depending on it.

And rebasing on top of sparse_irq required to use the new framework:
 x86: xen: Sanitse irq handling (part two)

The rest of the patches are due to compile/merge fallout in linux-next/mmotm:
 xen: Update Makefile with CONFIG_BLOCK dependency for biomerge.c
 MAINTAINERS: Add myself to the Xen Hypervisor Interface and remove Chris Wright.
 X86/PCI: Remove the dependency on isapnp_disable.

The change log:
Changelog since v8.0.1 [inclusion of this patches in linux-next/mmotm]
  - Rebase on top tip/irq/core to use sparse_irq
  - Fix fallout issues from linux-next/mmotm
Changelog since v8 [http://lkml.org/lkml/2010/10/12/207] posting:
 - Added Acked-by on Xen PCI frontend driver
Changelog since v7 [http://lwn.net/Articles/408418/] posting:
 - Added Reviewed-by/Acked-by on some of the patches.
 - Fleshed out comments.
 - Ditched the io_apic.c idea and used Thomas Gleixner idea.

The shortlog and the diffstat:

Alex Nixon (3):
      xen: Don't disable the I/O space
      x86/PCI: Clean up pci_cache_line_size
      xen/x86/PCI: Add support for the Xen PCI subsystem

Gerd Hoffmann (1):
      xen: set pirq name to something useful.

Jeremy Fitzhardinge (6):
      xen: define BIOVEC_PHYS_MERGEABLE()
      xen: implement pirq type event channels
      x86/io_apic: add get_nr_irqs_gsi()
      xen: dynamically allocate irq & event structures
      xen: statically initialize cpu_evtchn_mask_p
      x86/PCI: make sure _PAGE_IOMAP it set on pci mappings

Konrad Rzeszutek Wilk (12):
      xen: identity map gsi->irqs
      xen: Find an unbound irq number in reverse order (high to low).
      xen: Provide a variant of xen_poll_irq with timeout.
      xen: fix shared irq device passthrough
      x86/PCI: Export pci_walk_bus function.
      xen/pci: Request ACS when Xen-SWIOTLB is activated.
      MAINTAINERS: Add myself for Xen PCI and Xen SWIOTLB maintainer.
      swiotlb-xen: On x86-32 builts, select SWIOTLB instead of depending on it.
      x86: xen: Sanitse irq handling (part two)
      MAINTAINERS: Add myself to the Xen Hypervisor Interface and remove Chris Wright.
      xen: Update Makefile with CONFIG_BLOCK dependency for biomerge.c
      X86/PCI: Remove the dependency on isapnp_disable.

Noboru Iwamatsu (1):
      xenbus: prevent warnings on unhandled enumeration values

Ryan Wilson (1):
      xen-pcifront: Xen PCI frontend driver.

Stefano Stabellini (1):
      x86: Introduce x86_msi_ops

Thomas Gleixner (1):
      msi: Introduce default_[teardown|setup]_msi_irqs with fallback.

Yosuke Iwamatsu (1):
      xenbus: Xen paravirtualised PCI hotplug support.

 MAINTAINERS                        |   20 +-
 arch/x86/Kconfig                   |    5 +
 arch/x86/include/asm/io.h          |   13 +
 arch/x86/include/asm/io_apic.h     |    1 +
 arch/x86/include/asm/pci.h         |   33 +-
 arch/x86/include/asm/pci_x86.h     |    1 +
 arch/x86/include/asm/x86_init.h    |    9 +
 arch/x86/include/asm/xen/pci.h     |   53 ++
 arch/x86/kernel/apic/io_apic.c     |    9 +-
 arch/x86/kernel/x86_init.c         |    7 +
 arch/x86/pci/Makefile              |    1 +
 arch/x86/pci/common.c              |   17 +-
 arch/x86/pci/i386.c                |    2 +
 arch/x86/pci/xen.c                 |  142 +++++
 arch/x86/xen/enlighten.c           |    3 +
 arch/x86/xen/pci-swiotlb-xen.c     |    4 +
 arch/x86/xen/setup.c               |    2 -
 drivers/block/xen-blkfront.c       |    2 +
 drivers/input/xen-kbdfront.c       |    2 +
 drivers/net/xen-netfront.c         |    2 +
 drivers/pci/Kconfig                |   21 +
 drivers/pci/Makefile               |    2 +
 drivers/pci/bus.c                  |    1 +
 drivers/pci/msi.c                  |   14 +-
 drivers/pci/xen-pcifront.c         | 1148 ++++++++++++++++++++++++++++++++++++
 drivers/video/xen-fbfront.c        |    2 +
 drivers/xen/Kconfig                |    3 +-
 drivers/xen/Makefile               |    1 +
 drivers/xen/biomerge.c             |   13 +
 drivers/xen/events.c               |  344 ++++++++++-
 drivers/xen/xenbus/xenbus_client.c |    2 +
 include/xen/events.h               |   18 +
 include/xen/interface/io/pciif.h   |  112 ++++
 include/xen/interface/io/xenbus.h  |    8 +-
 34 files changed, 1981 insertions(+), 36 deletions(-)

P.S.
[1]. git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.36-rc8-initial-domain-v5

[2]: http://qubes-os.org/ which utilizes hardware IOMMU to run seperate domains wherein
each has specific access to hardware.

[3] Some of the authors of the patches have moved on, so their e-mails
are bouncing. The git tree contains their proper old email addresses.

diff --git a/MAINTAINERS b/MAINTAINERS
index 62c0ace..59e9999 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6492,11 +6492,25 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.
 S:	Maintained
 F:	drivers/platform/x86
 
+XEN PCI SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xensource.com
+S:	Supported
+F:	arch/x86/pci/*xen*
+F:	drivers/pci/*xen*
+
+XEN SWIOTLB SUBSYSTEM
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xensource.com
+S:	Supported
+F:	arch/x86/xen/*swiotlb*
+F:	drivers/xen/*swiotlb*
+
 XEN HYPERVISOR INTERFACE
-M:	Jeremy Fitzhardinge <jeremy@xensource.com>
-M:	Chris Wright <chrisw@sous-sol.org>
+M:	Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
+M:	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
+L:	xen-devel@lists.xen.org
 L:	virtualization@lists.osdl.org
-L:	xen-devel@lists.xensource.com
 S:	Supported
 F:	arch/x86/xen/
 F:	drivers/*/xen-*front.c
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8cc5108..74ea59d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1898,6 +1898,11 @@ config PCI_OLPC
 	def_bool y
 	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
+config PCI_XEN
+	def_bool y
+	depends on PCI && XEN
+	select SWIOTLB_XEN
+
 config PCI_DOMAINS
 	def_bool y
 	depends on PCI
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 30a3e97..0ad29d4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -41,6 +41,8 @@
 #include <asm-generic/int-ll64.h>
 #include <asm/page.h>
 
+#include <xen/xen.h>
+
 #define build_mmio_read(name, size, type, reg, barrier) \
 static inline type name(const volatile void __iomem *addr) \
 { type ret; asm volatile("mov" size " %1,%0":reg (ret) \
@@ -349,6 +351,17 @@ extern void __iomem *early_memremap(resource_size_t phys_addr,
 extern void early_iounmap(void __iomem *addr, unsigned long size);
 extern void fixup_early_ioremap(void);
 
+#ifdef CONFIG_XEN
+struct bio_vec;
+
+extern bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+				      const struct bio_vec *vec2);
+
+#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)				\
+	(__BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&				\
+	 (!xen_domain() || xen_biovec_phys_mergeable(vec1, vec2)))
+#endif	/* CONFIG_XEN */
+
 #define IO_SPACE_LIMIT 0xffff
 
 #endif /* _ASM_X86_IO_H */
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index c8be456..a6b28d0 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -169,6 +169,7 @@ extern void mask_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 extern int restore_IO_APIC_setup(struct IO_APIC_route_entry **ioapic_entries);
 
 extern void probe_nr_irqs_gsi(void);
+extern int get_nr_irqs_gsi(void);
 
 extern void setup_ioapic_ids_from_mpc(void);
 
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d395540..ca0437c 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <asm/scatterlist.h>
 #include <asm/io.h>
+#include <asm/x86_init.h>
 
 #ifdef __KERNEL__
 
@@ -94,8 +95,36 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
-/* MSI arch hook */
-#define arch_setup_msi_irqs arch_setup_msi_irqs
+#ifdef CONFIG_PCI_MSI
+/* MSI arch specific hooks */
+static inline int x86_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	return x86_msi.setup_msi_irqs(dev, nvec, type);
+}
+
+static inline void x86_teardown_msi_irqs(struct pci_dev *dev)
+{
+	x86_msi.teardown_msi_irqs(dev);
+}
+
+static inline void x86_teardown_msi_irq(unsigned int irq)
+{
+	x86_msi.teardown_msi_irq(irq);
+}
+#define arch_setup_msi_irqs x86_setup_msi_irqs
+#define arch_teardown_msi_irqs x86_teardown_msi_irqs
+#define arch_teardown_msi_irq x86_teardown_msi_irq
+/* implemented in arch/x86/kernel/apic/io_apic. */
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+void native_teardown_msi_irq(unsigned int irq);
+/* default to the implementation in drivers/lib/msi.c */
+#define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev);
+#else
+#define native_setup_msi_irqs		NULL
+#define native_teardown_msi_irq		NULL
+#define default_teardown_msi_irqs	NULL
+#endif
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index 49c7219..7045267 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -47,6 +47,7 @@ enum pci_bf_sort_state {
 extern unsigned int pcibios_max_latency;
 
 void pcibios_resource_survey(void);
+void pcibios_set_cache_line_size(void);
 
 /* pci-pc.c */
 
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index baa579c..64642ad 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -154,9 +154,18 @@ struct x86_platform_ops {
 	int (*i8042_detect)(void);
 };
 
+struct pci_dev;
+
+struct x86_msi_ops {
+	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
+	void (*teardown_msi_irq)(unsigned int irq);
+	void (*teardown_msi_irqs)(struct pci_dev *dev);
+};
+
 extern struct x86_init_ops x86_init;
 extern struct x86_cpuinit_ops x86_cpuinit;
 extern struct x86_platform_ops x86_platform;
+extern struct x86_msi_ops x86_msi;
 
 extern void x86_init_noop(void);
 extern void x86_init_uint_noop(unsigned int unused);
diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
new file mode 100644
index 0000000..449c82f
--- /dev/null
+++ b/arch/x86/include/asm/xen/pci.h
@@ -0,0 +1,53 @@
+#ifndef _ASM_X86_XEN_PCI_H
+#define _ASM_X86_XEN_PCI_H
+
+#if defined(CONFIG_PCI_XEN)
+extern int __init pci_xen_init(void);
+#define pci_xen 1
+#else
+#define pci_xen 0
+#define pci_xen_init (0)
+#endif
+
+#if defined(CONFIG_PCI_MSI)
+#if defined(CONFIG_PCI_XEN)
+/* The drivers/pci/xen-pcifront.c sets this structure to
+ * its own functions.
+ */
+struct xen_pci_frontend_ops {
+	int (*enable_msi)(struct pci_dev *dev, int **vectors);
+	void (*disable_msi)(struct pci_dev *dev);
+	int (*enable_msix)(struct pci_dev *dev, int **vectors, int nvec);
+	void (*disable_msix)(struct pci_dev *dev);
+};
+
+extern struct xen_pci_frontend_ops *xen_pci_frontend;
+
+static inline int xen_pci_frontend_enable_msi(struct pci_dev *dev,
+					      int **vectors)
+{
+	if (xen_pci_frontend && xen_pci_frontend->enable_msi)
+		return xen_pci_frontend->enable_msi(dev, vectors);
+	return -ENODEV;
+}
+static inline void xen_pci_frontend_disable_msi(struct pci_dev *dev)
+{
+	if (xen_pci_frontend && xen_pci_frontend->disable_msi)
+			xen_pci_frontend->disable_msi(dev);
+}
+static inline int xen_pci_frontend_enable_msix(struct pci_dev *dev,
+					       int **vectors, int nvec)
+{
+	if (xen_pci_frontend && xen_pci_frontend->enable_msix)
+		return xen_pci_frontend->enable_msix(dev, vectors, nvec);
+	return -ENODEV;
+}
+static inline void xen_pci_frontend_disable_msix(struct pci_dev *dev)
+{
+	if (xen_pci_frontend && xen_pci_frontend->disable_msix)
+			xen_pci_frontend->disable_msix(dev);
+}
+#endif /* CONFIG_PCI_XEN */
+#endif /* CONFIG_PCI_MSI */
+
+#endif	/* _ASM_X86_XEN_PCI_H */
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 20e47e0..0885a41 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3330,7 +3330,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	int node, ret, sub_handle, index = 0;
 	unsigned int irq, irq_want;
@@ -3388,7 +3388,7 @@ error:
 	return ret;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
@@ -3649,6 +3649,11 @@ void __init probe_nr_irqs_gsi(void)
 	printk(KERN_DEBUG "nr_irqs_gsi: %d\n", nr_irqs_gsi);
 }
 
+int get_nr_irqs_gsi(void)
+{
+	return nr_irqs_gsi;
+}
+
 #ifdef CONFIG_SPARSE_IRQ
 int __init arch_probe_nr_irqs(void)
 {
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index cd6da6b..ceb2911 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -6,10 +6,12 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
+#include <linux/pci.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
 #include <asm/pci_x86.h>
+#include <asm/pci.h>
 #include <asm/mpspec.h>
 #include <asm/setup.h>
 #include <asm/apic.h>
@@ -99,3 +101,8 @@ struct x86_platform_ops x86_platform = {
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);
+struct x86_msi_ops x86_msi = {
+	.setup_msi_irqs = native_setup_msi_irqs,
+	.teardown_msi_irq = native_teardown_msi_irq,
+	.teardown_msi_irqs = default_teardown_msi_irqs,
+};
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index a0207a7..effd96e 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
 obj-$(CONFIG_PCI_MMCONFIG)	+= mmconfig_$(BITS).o direct.o mmconfig-shared.o
 obj-$(CONFIG_PCI_DIRECT)	+= direct.o
 obj-$(CONFIG_PCI_OLPC)		+= olpc.o
+obj-$(CONFIG_PCI_XEN)		+= xen.o
 
 obj-y				+= fixup.o
 obj-$(CONFIG_ACPI)		+= acpi.o
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index a0772af..f7c8a39 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -421,16 +421,10 @@ struct pci_bus * __devinit pcibios_scan_root(int busnum)
 
 	return bus;
 }
-
-int __init pcibios_init(void)
+void __init pcibios_set_cache_line_size(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	if (!raw_pci_ops) {
-		printk(KERN_WARNING "PCI: System does not support PCI\n");
-		return 0;
-	}
-
 	/*
 	 * Set PCI cacheline size to that of the CPU if the CPU has reported it.
 	 * (For older CPUs that don't support cpuid, we se it to 32 bytes
@@ -445,7 +439,16 @@ int __init pcibios_init(void)
  		pci_dfl_cache_line_size = 32 >> 2;
 		printk(KERN_DEBUG "PCI: Unknown cacheline size. Setting to 32 bytes\n");
 	}
+}
+
+int __init pcibios_init(void)
+{
+	if (!raw_pci_ops) {
+		printk(KERN_WARNING "PCI: System does not support PCI\n");
+		return 0;
+	}
 
+	pcibios_set_cache_line_size();
 	pcibios_resource_survey();
 
 	if (pci_bf_sort >= pci_force_bf)
diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 5525309..8379c2c 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -311,6 +311,8 @@ int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
 		 */
 		prot |= _PAGE_CACHE_UC_MINUS;
 
+	prot |= _PAGE_IOMAP;	/* creating a mapping for IO */
+
 	vma->vm_page_prot = __pgprot(prot);
 
 	if (io_remap_pfn_range(vma, vma->vm_start, vma->vm_pgoff,
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
new file mode 100644
index 0000000..4e37106
--- /dev/null
+++ b/arch/x86/pci/xen.c
@@ -0,0 +1,142 @@
+/*
+ * Xen PCI Frontend Stub - puts some "dummy" functions in to the Linux
+ *			   x86 PCI core to support the Xen PCI Frontend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/acpi.h>
+
+#include <linux/io.h>
+#include <asm/pci_x86.h>
+
+#include <asm/xen/hypervisor.h>
+
+#include <xen/events.h>
+#include <asm/xen/pci.h>
+
+#if defined(CONFIG_PCI_MSI)
+#include <linux/msi.h>
+
+struct xen_pci_frontend_ops *xen_pci_frontend;
+EXPORT_SYMBOL_GPL(xen_pci_frontend);
+
+/*
+ * For MSI interrupts we have to use drivers/xen/event.s functions to
+ * allocate an irq_desc and setup the right */
+
+
+static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+{
+	int irq, ret, i;
+	struct msi_desc *msidesc;
+	int *v;
+
+	v = kzalloc(sizeof(int) * max(1, nvec), GFP_KERNEL);
+	if (!v)
+		return -ENOMEM;
+
+	if (!xen_initial_domain()) {
+		if (type == PCI_CAP_ID_MSIX)
+			ret = xen_pci_frontend_enable_msix(dev, &v, nvec);
+		else
+			ret = xen_pci_frontend_enable_msi(dev, &v);
+		if (ret)
+			goto error;
+	}
+	i = 0;
+	list_for_each_entry(msidesc, &dev->msi_list, list) {
+		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
+			(type == PCI_CAP_ID_MSIX) ?
+			"pcifront-msi-x" : "pcifront-msi");
+		if (irq < 0)
+			return -1;
+
+		ret = set_irq_msi(irq, msidesc);
+		if (ret)
+			goto error_while;
+		i++;
+	}
+	kfree(v);
+	return 0;
+
+error_while:
+	unbind_from_irqhandler(irq, NULL);
+error:
+	if (ret == -ENODEV)
+		dev_err(&dev->dev, "Xen PCI frontend has not registered" \
+			" MSI/MSI-X support!\n");
+
+	kfree(v);
+	return ret;
+}
+
+static void xen_teardown_msi_irqs(struct pci_dev *dev)
+{
+	/* Only do this when were are in non-privileged mode.*/
+	if (!xen_initial_domain()) {
+		struct msi_desc *msidesc;
+
+		msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
+		if (msidesc->msi_attrib.is_msix)
+			xen_pci_frontend_disable_msix(dev);
+		else
+			xen_pci_frontend_disable_msi(dev);
+	}
+
+}
+
+static void xen_teardown_msi_irq(unsigned int irq)
+{
+	xen_destroy_irq(irq);
+}
+#endif
+
+static int xen_pcifront_enable_irq(struct pci_dev *dev)
+{
+	int rc;
+	int share = 1;
+
+	dev_info(&dev->dev, "Xen PCI enabling IRQ: %d\n", dev->irq);
+
+	if (dev->irq < 0)
+		return -EINVAL;
+
+	if (dev->irq < NR_IRQS_LEGACY)
+		share = 0;
+
+	rc = xen_allocate_pirq(dev->irq, share, "pcifront");
+	if (rc < 0) {
+		dev_warn(&dev->dev, "Xen PCI IRQ: %d, failed to register:%d\n",
+			 dev->irq, rc);
+		return rc;
+	}
+	return 0;
+}
+
+int __init pci_xen_init(void)
+{
+	if (!xen_pv_domain() || xen_initial_domain())
+		return -ENODEV;
+
+	printk(KERN_INFO "PCI: setting up Xen PCI frontend stub\n");
+
+	pcibios_set_cache_line_size();
+
+	pcibios_enable_irq = xen_pcifront_enable_irq;
+	pcibios_disable_irq = NULL;
+
+#ifdef CONFIG_ACPI
+	/* Keep ACPI out of the picture */
+	acpi_noirq = 1;
+#endif
+
+#ifdef CONFIG_PCI_MSI
+	x86_msi.setup_msi_irqs = xen_setup_msi_irqs;
+	x86_msi.teardown_msi_irq = xen_teardown_msi_irq;
+	x86_msi.teardown_msi_irqs = xen_teardown_msi_irqs;
+#endif
+	return 0;
+}
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 7d46c84..1ccfa1b 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -45,6 +45,7 @@
 #include <asm/paravirt.h>
 #include <asm/apic.h>
 #include <asm/page.h>
+#include <asm/xen/pci.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/fixmap.h>
@@ -1220,6 +1221,8 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
+		if (pci_xen)
+			x86_init.pci.arch_init = pci_xen_init;
 	} else {
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index a013ec9..be4d80a 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -1,6 +1,7 @@
 /* Glue code to lib/swiotlb-xen.c */
 
 #include <linux/dma-mapping.h>
+#include <linux/pci.h>
 #include <xen/swiotlb-xen.h>
 
 #include <asm/xen/hypervisor.h>
@@ -54,5 +55,8 @@ void __init pci_xen_swiotlb_init(void)
 	if (xen_swiotlb) {
 		xen_swiotlb_init(1);
 		dma_ops = &xen_swiotlb_dma_ops;
+
+		/* Make sure ACS will be enabled */
+		pci_request_acs();
 	}
 }
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 328b003..c413132 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -260,7 +260,5 @@ void __init xen_arch_setup(void)
 
 	pm_idle = xen_idle;
 
-	paravirt_disable_iospace();
-
 	fiddle_vdso();
 }
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index ab735a6..c4e9d81 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1125,6 +1125,8 @@ static void blkback_changed(struct xenbus_device *dev,
 	case XenbusStateInitialising:
 	case XenbusStateInitWait:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
diff --git a/drivers/input/xen-kbdfront.c b/drivers/input/xen-kbdfront.c
index ebb1190..e0c024d 100644
--- a/drivers/input/xen-kbdfront.c
+++ b/drivers/input/xen-kbdfront.c
@@ -276,6 +276,8 @@ static void xenkbd_backend_changed(struct xenbus_device *dev,
 	switch (backend_state) {
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b50fedc..cb6e112 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1610,6 +1610,8 @@ static void backend_changed(struct xenbus_device *dev,
 	switch (backend_state) {
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateConnected:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 34ef70d..5b1630e 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -40,6 +40,27 @@ config PCI_STUB
 
 	  When in doubt, say N.
 
+config XEN_PCIDEV_FRONTEND
+        tristate "Xen PCI Frontend"
+        depends on PCI && X86 && XEN
+        select HOTPLUG
+        select PCI_XEN
+        default y
+        help
+          The PCI device frontend driver allows the kernel to import arbitrary
+          PCI devices from a PCI backend to support PCI driver domains.
+
+config XEN_PCIDEV_FE_DEBUG
+        bool "Xen PCI Frontend debugging"
+        depends on XEN_PCIDEV_FRONTEND && PCI_DEBUG
+	help
+	  Say Y here if you want the Xen PCI frontend to produce a bunch of debug
+	  messages to the system log.  Select this if you are having a
+	  problem with Xen PCI frontend support and want to see more of what is
+	  going on.
+
+	  When in doubt, say N.
+
 config HT_IRQ
 	bool "Interrupts on hypertransport devices"
 	default y
diff --git a/drivers/pci/Makefile b/drivers/pci/Makefile
index dc1aa09..d5e2705 100644
--- a/drivers/pci/Makefile
+++ b/drivers/pci/Makefile
@@ -65,6 +65,8 @@ obj-$(CONFIG_PCI_SYSCALL) += syscall.o
 
 obj-$(CONFIG_PCI_STUB) += pci-stub.o
 
+obj-$(CONFIG_XEN_PCIDEV_FRONTEND) += xen-pcifront.o
+
 ifeq ($(CONFIG_PCI_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
 endif
diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
index 7f0af0e..69546e9 100644
--- a/drivers/pci/bus.c
+++ b/drivers/pci/bus.c
@@ -299,6 +299,7 @@ void pci_walk_bus(struct pci_bus *top, int (*cb)(struct pci_dev *, void *),
 	}
 	up_read(&pci_bus_sem);
 }
+EXPORT_SYMBOL_GPL(pci_walk_bus);
 
 EXPORT_SYMBOL(pci_bus_alloc_resource);
 EXPORT_SYMBOL_GPL(pci_bus_add_device);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5fcf5ae..7c24dce 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -35,7 +35,12 @@ int arch_msi_check_device(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_setup_msi_irqs
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+# define arch_setup_msi_irqs default_setup_msi_irqs
+# define HAVE_DEFAULT_MSI_SETUP_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_SETUP_IRQS
+int default_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	struct msi_desc *entry;
 	int ret;
@@ -60,7 +65,12 @@ int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 #endif
 
 #ifndef arch_teardown_msi_irqs
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+# define arch_teardown_msi_irqs default_teardown_msi_irqs
+# define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+void default_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
new file mode 100644
index 0000000..a87c498
--- /dev/null
+++ b/drivers/pci/xen-pcifront.c
@@ -0,0 +1,1148 @@
+/*
+ * Xen PCI Frontend.
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <xen/xenbus.h>
+#include <xen/events.h>
+#include <xen/grant_table.h>
+#include <xen/page.h>
+#include <linux/spinlock.h>
+#include <linux/pci.h>
+#include <linux/msi.h>
+#include <xen/xenbus.h>
+#include <xen/interface/io/pciif.h>
+#include <asm/xen/pci.h>
+#include <linux/interrupt.h>
+#include <asm/atomic.h>
+#include <linux/workqueue.h>
+#include <linux/bitops.h>
+#include <linux/time.h>
+
+#define INVALID_GRANT_REF (0)
+#define INVALID_EVTCHN    (-1)
+
+struct pci_bus_entry {
+	struct list_head list;
+	struct pci_bus *bus;
+};
+
+#define _PDEVB_op_active		(0)
+#define PDEVB_op_active			(1 << (_PDEVB_op_active))
+
+struct pcifront_device {
+	struct xenbus_device *xdev;
+	struct list_head root_buses;
+
+	int evtchn;
+	int gnt_ref;
+
+	int irq;
+
+	/* Lock this when doing any operations in sh_info */
+	spinlock_t sh_info_lock;
+	struct xen_pci_sharedinfo *sh_info;
+	struct work_struct op_work;
+	unsigned long flags;
+
+};
+
+struct pcifront_sd {
+	int domain;
+	struct pcifront_device *pdev;
+};
+
+static inline struct pcifront_device *
+pcifront_get_pdev(struct pcifront_sd *sd)
+{
+	return sd->pdev;
+}
+
+static inline void pcifront_init_sd(struct pcifront_sd *sd,
+				    unsigned int domain, unsigned int bus,
+				    struct pcifront_device *pdev)
+{
+	sd->domain = domain;
+	sd->pdev = pdev;
+}
+
+static DEFINE_SPINLOCK(pcifront_dev_lock);
+static struct pcifront_device *pcifront_dev;
+
+static int verbose_request;
+module_param(verbose_request, int, 0644);
+
+static int errno_to_pcibios_err(int errno)
+{
+	switch (errno) {
+	case XEN_PCI_ERR_success:
+		return PCIBIOS_SUCCESSFUL;
+
+	case XEN_PCI_ERR_dev_not_found:
+		return PCIBIOS_DEVICE_NOT_FOUND;
+
+	case XEN_PCI_ERR_invalid_offset:
+	case XEN_PCI_ERR_op_failed:
+		return PCIBIOS_BAD_REGISTER_NUMBER;
+
+	case XEN_PCI_ERR_not_implemented:
+		return PCIBIOS_FUNC_NOT_SUPPORTED;
+
+	case XEN_PCI_ERR_access_denied:
+		return PCIBIOS_SET_FAILED;
+	}
+	return errno;
+}
+
+static inline void schedule_pcifront_aer_op(struct pcifront_device *pdev)
+{
+	if (test_bit(_XEN_PCIB_active, (unsigned long *)&pdev->sh_info->flags)
+		&& !test_and_set_bit(_PDEVB_op_active, &pdev->flags)) {
+		dev_dbg(&pdev->xdev->dev, "schedule aer frontend job\n");
+		schedule_work(&pdev->op_work);
+	}
+}
+
+static int do_pci_op(struct pcifront_device *pdev, struct xen_pci_op *op)
+{
+	int err = 0;
+	struct xen_pci_op *active_op = &pdev->sh_info->op;
+	unsigned long irq_flags;
+	evtchn_port_t port = pdev->evtchn;
+	unsigned irq = pdev->irq;
+	s64 ns, ns_timeout;
+	struct timeval tv;
+
+	spin_lock_irqsave(&pdev->sh_info_lock, irq_flags);
+
+	memcpy(active_op, op, sizeof(struct xen_pci_op));
+
+	/* Go */
+	wmb();
+	set_bit(_XEN_PCIF_active, (unsigned long *)&pdev->sh_info->flags);
+	notify_remote_via_evtchn(port);
+
+	/*
+	 * We set a poll timeout of 3 seconds but give up on return after
+	 * 2 seconds. It is better to time out too late rather than too early
+	 * (in the latter case we end up continually re-executing poll() with a
+	 * timeout in the past). 1s difference gives plenty of slack for error.
+	 */
+	do_gettimeofday(&tv);
+	ns_timeout = timeval_to_ns(&tv) + 2 * (s64)NSEC_PER_SEC;
+
+	xen_clear_irq_pending(irq);
+
+	while (test_bit(_XEN_PCIF_active,
+			(unsigned long *)&pdev->sh_info->flags)) {
+		xen_poll_irq_timeout(irq, jiffies + 3*HZ);
+		xen_clear_irq_pending(irq);
+		do_gettimeofday(&tv);
+		ns = timeval_to_ns(&tv);
+		if (ns > ns_timeout) {
+			dev_err(&pdev->xdev->dev,
+				"pciback not responding!!!\n");
+			clear_bit(_XEN_PCIF_active,
+				  (unsigned long *)&pdev->sh_info->flags);
+			err = XEN_PCI_ERR_dev_not_found;
+			goto out;
+		}
+	}
+
+	/*
+	* We might lose backend service request since we
+	* reuse same evtchn with pci_conf backend response. So re-schedule
+	* aer pcifront service.
+	*/
+	if (test_bit(_XEN_PCIB_active,
+			(unsigned long *)&pdev->sh_info->flags)) {
+		dev_err(&pdev->xdev->dev,
+			"schedule aer pcifront service\n");
+		schedule_pcifront_aer_op(pdev);
+	}
+
+	memcpy(op, active_op, sizeof(struct xen_pci_op));
+
+	err = op->err;
+out:
+	spin_unlock_irqrestore(&pdev->sh_info_lock, irq_flags);
+	return err;
+}
+
+/* Access to this function is spinlocked in drivers/pci/access.c */
+static int pcifront_bus_read(struct pci_bus *bus, unsigned int devfn,
+			     int where, int size, u32 *val)
+{
+	int err = 0;
+	struct xen_pci_op op = {
+		.cmd    = XEN_PCI_OP_conf_read,
+		.domain = pci_domain_nr(bus),
+		.bus    = bus->number,
+		.devfn  = devfn,
+		.offset = where,
+		.size   = size,
+	};
+	struct pcifront_sd *sd = bus->sysdata;
+	struct pcifront_device *pdev = pcifront_get_pdev(sd);
+
+	if (verbose_request)
+		dev_info(&pdev->xdev->dev,
+			 "read dev=%04x:%02x:%02x.%01x - offset %x size %d\n",
+			 pci_domain_nr(bus), bus->number, PCI_SLOT(devfn),
+			 PCI_FUNC(devfn), where, size);
+
+	err = do_pci_op(pdev, &op);
+
+	if (likely(!err)) {
+		if (verbose_request)
+			dev_info(&pdev->xdev->dev, "read got back value %x\n",
+				 op.value);
+
+		*val = op.value;
+	} else if (err == -ENODEV) {
+		/* No device here, pretend that it just returned 0 */
+		err = 0;
+		*val = 0;
+	}
+
+	return errno_to_pcibios_err(err);
+}
+
+/* Access to this function is spinlocked in drivers/pci/access.c */
+static int pcifront_bus_write(struct pci_bus *bus, unsigned int devfn,
+			      int where, int size, u32 val)
+{
+	struct xen_pci_op op = {
+		.cmd    = XEN_PCI_OP_conf_write,
+		.domain = pci_domain_nr(bus),
+		.bus    = bus->number,
+		.devfn  = devfn,
+		.offset = where,
+		.size   = size,
+		.value  = val,
+	};
+	struct pcifront_sd *sd = bus->sysdata;
+	struct pcifront_device *pdev = pcifront_get_pdev(sd);
+
+	if (verbose_request)
+		dev_info(&pdev->xdev->dev,
+			 "write dev=%04x:%02x:%02x.%01x - "
+			 "offset %x size %d val %x\n",
+			 pci_domain_nr(bus), bus->number,
+			 PCI_SLOT(devfn), PCI_FUNC(devfn), where, size, val);
+
+	return errno_to_pcibios_err(do_pci_op(pdev, &op));
+}
+
+struct pci_ops pcifront_bus_ops = {
+	.read = pcifront_bus_read,
+	.write = pcifront_bus_write,
+};
+
+#ifdef CONFIG_PCI_MSI
+static int pci_frontend_enable_msix(struct pci_dev *dev,
+				    int **vector, int nvec)
+{
+	int err;
+	int i;
+	struct xen_pci_op op = {
+		.cmd    = XEN_PCI_OP_enable_msix,
+		.domain = pci_domain_nr(dev->bus),
+		.bus = dev->bus->number,
+		.devfn = dev->devfn,
+		.value = nvec,
+	};
+	struct pcifront_sd *sd = dev->bus->sysdata;
+	struct pcifront_device *pdev = pcifront_get_pdev(sd);
+	struct msi_desc *entry;
+
+	if (nvec > SH_INFO_MAX_VEC) {
+		dev_err(&dev->dev, "too much vector for pci frontend: %x."
+				   " Increase SH_INFO_MAX_VEC.\n", nvec);
+		return -EINVAL;
+	}
+
+	i = 0;
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		op.msix_entries[i].entry = entry->msi_attrib.entry_nr;
+		/* Vector is useless at this point. */
+		op.msix_entries[i].vector = -1;
+		i++;
+	}
+
+	err = do_pci_op(pdev, &op);
+
+	if (likely(!err)) {
+		if (likely(!op.value)) {
+			/* we get the result */
+			for (i = 0; i < nvec; i++)
+				*(*vector+i) = op.msix_entries[i].vector;
+			return 0;
+		} else {
+			printk(KERN_DEBUG "enable msix get value %x\n",
+				op.value);
+			return op.value;
+		}
+	} else {
+		dev_err(&dev->dev, "enable msix get err %x\n", err);
+		return err;
+	}
+}
+
+static void pci_frontend_disable_msix(struct pci_dev *dev)
+{
+	int err;
+	struct xen_pci_op op = {
+		.cmd    = XEN_PCI_OP_disable_msix,
+		.domain = pci_domain_nr(dev->bus),
+		.bus = dev->bus->number,
+		.devfn = dev->devfn,
+	};
+	struct pcifront_sd *sd = dev->bus->sysdata;
+	struct pcifront_device *pdev = pcifront_get_pdev(sd);
+
+	err = do_pci_op(pdev, &op);
+
+	/* What should do for error ? */
+	if (err)
+		dev_err(&dev->dev, "pci_disable_msix get err %x\n", err);
+}
+
+static int pci_frontend_enable_msi(struct pci_dev *dev, int **vector)
+{
+	int err;
+	struct xen_pci_op op = {
+		.cmd    = XEN_PCI_OP_enable_msi,
+		.domain = pci_domain_nr(dev->bus),
+		.bus = dev->bus->number,
+		.devfn = dev->devfn,
+	};
+	struct pcifront_sd *sd = dev->bus->sysdata;
+	struct pcifront_device *pdev = pcifront_get_pdev(sd);
+
+	err = do_pci_op(pdev, &op);
+	if (likely(!err)) {
+		*(*vector) = op.value;
+	} else {
+		dev_err(&dev->dev, "pci frontend enable msi failed for dev "
+				    "%x:%x\n", op.bus, op.devfn);
+		err = -EINVAL;
+	}
+	return err;
+}
+
+static void pci_frontend_disable_msi(struct pci_dev *dev)
+{
+	int err;
+	struct xen_pci_op op = {
+		.cmd    = XEN_PCI_OP_disable_msi,
+		.domain = pci_domain_nr(dev->bus),
+		.bus = dev->bus->number,
+		.devfn = dev->devfn,
+	};
+	struct pcifront_sd *sd = dev->bus->sysdata;
+	struct pcifront_device *pdev = pcifront_get_pdev(sd);
+
+	err = do_pci_op(pdev, &op);
+	if (err == XEN_PCI_ERR_dev_not_found) {
+		/* XXX No response from backend, what shall we do? */
+		printk(KERN_DEBUG "get no response from backend for disable MSI\n");
+		return;
+	}
+	if (err)
+		/* how can pciback notify us fail? */
+		printk(KERN_DEBUG "get fake response frombackend\n");
+}
+
+static struct xen_pci_frontend_ops pci_frontend_ops = {
+	.enable_msi = pci_frontend_enable_msi,
+	.disable_msi = pci_frontend_disable_msi,
+	.enable_msix = pci_frontend_enable_msix,
+	.disable_msix = pci_frontend_disable_msix,
+};
+
+static void pci_frontend_registrar(int enable)
+{
+	if (enable)
+		xen_pci_frontend = &pci_frontend_ops;
+	else
+		xen_pci_frontend = NULL;
+};
+#else
+static inline void pci_frontend_registrar(int enable) { };
+#endif /* CONFIG_PCI_MSI */
+
+/* Claim resources for the PCI frontend as-is, backend won't allow changes */
+static int pcifront_claim_resource(struct pci_dev *dev, void *data)
+{
+	struct pcifront_device *pdev = data;
+	int i;
+	struct resource *r;
+
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		r = &dev->resource[i];
+
+		if (!r->parent && r->start && r->flags) {
+			dev_info(&pdev->xdev->dev, "claiming resource %s/%d\n",
+				pci_name(dev), i);
+			if (pci_claim_resource(dev, i)) {
+				dev_err(&pdev->xdev->dev, "Could not claim "
+					"resource %s/%d! Device offline. Try "
+					"giving less than 4GB to domain.\n",
+					pci_name(dev), i);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int __devinit pcifront_scan_bus(struct pcifront_device *pdev,
+				unsigned int domain, unsigned int bus,
+				struct pci_bus *b)
+{
+	struct pci_dev *d;
+	unsigned int devfn;
+
+	/* Scan the bus for functions and add.
+	 * We omit handling of PCI bridge attachment because pciback prevents
+	 * bridges from being exported.
+	 */
+	for (devfn = 0; devfn < 0x100; devfn++) {
+		d = pci_get_slot(b, devfn);
+		if (d) {
+			/* Device is already known. */
+			pci_dev_put(d);
+			continue;
+		}
+
+		d = pci_scan_single_device(b, devfn);
+		if (d)
+			dev_info(&pdev->xdev->dev, "New device on "
+				 "%04x:%02x:%02x.%02x found.\n", domain, bus,
+				 PCI_SLOT(devfn), PCI_FUNC(devfn));
+	}
+
+	return 0;
+}
+
+static int __devinit pcifront_scan_root(struct pcifront_device *pdev,
+				 unsigned int domain, unsigned int bus)
+{
+	struct pci_bus *b;
+	struct pcifront_sd *sd = NULL;
+	struct pci_bus_entry *bus_entry = NULL;
+	int err = 0;
+
+#ifndef CONFIG_PCI_DOMAINS
+	if (domain != 0) {
+		dev_err(&pdev->xdev->dev,
+			"PCI Root in non-zero PCI Domain! domain=%d\n", domain);
+		dev_err(&pdev->xdev->dev,
+			"Please compile with CONFIG_PCI_DOMAINS\n");
+		err = -EINVAL;
+		goto err_out;
+	}
+#endif
+
+	dev_info(&pdev->xdev->dev, "Creating PCI Frontend Bus %04x:%02x\n",
+		 domain, bus);
+
+	bus_entry = kmalloc(sizeof(*bus_entry), GFP_KERNEL);
+	sd = kmalloc(sizeof(*sd), GFP_KERNEL);
+	if (!bus_entry || !sd) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+	pcifront_init_sd(sd, domain, bus, pdev);
+
+	b = pci_scan_bus_parented(&pdev->xdev->dev, bus,
+				  &pcifront_bus_ops, sd);
+	if (!b) {
+		dev_err(&pdev->xdev->dev,
+			"Error creating PCI Frontend Bus!\n");
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	bus_entry->bus = b;
+
+	list_add(&bus_entry->list, &pdev->root_buses);
+
+	/* pci_scan_bus_parented skips devices which do not have a have
+	* devfn==0. The pcifront_scan_bus enumerates all devfn. */
+	err = pcifront_scan_bus(pdev, domain, bus, b);
+
+	/* Claim resources before going "live" with our devices */
+	pci_walk_bus(b, pcifront_claim_resource, pdev);
+
+	/* Create SysFS and notify udev of the devices. Aka: "going live" */
+	pci_bus_add_devices(b);
+
+	return err;
+
+err_out:
+	kfree(bus_entry);
+	kfree(sd);
+
+	return err;
+}
+
+static int __devinit pcifront_rescan_root(struct pcifront_device *pdev,
+				   unsigned int domain, unsigned int bus)
+{
+	int err;
+	struct pci_bus *b;
+
+#ifndef CONFIG_PCI_DOMAINS
+	if (domain != 0) {
+		dev_err(&pdev->xdev->dev,
+			"PCI Root in non-zero PCI Domain! domain=%d\n", domain);
+		dev_err(&pdev->xdev->dev,
+			"Please compile with CONFIG_PCI_DOMAINS\n");
+		return -EINVAL;
+	}
+#endif
+
+	dev_info(&pdev->xdev->dev, "Rescanning PCI Frontend Bus %04x:%02x\n",
+		 domain, bus);
+
+	b = pci_find_bus(domain, bus);
+	if (!b)
+		/* If the bus is unknown, create it. */
+		return pcifront_scan_root(pdev, domain, bus);
+
+	err = pcifront_scan_bus(pdev, domain, bus, b);
+
+	/* Claim resources before going "live" with our devices */
+	pci_walk_bus(b, pcifront_claim_resource, pdev);
+
+	/* Create SysFS and notify udev of the devices. Aka: "going live" */
+	pci_bus_add_devices(b);
+
+	return err;
+}
+
+static void free_root_bus_devs(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+
+	while (!list_empty(&bus->devices)) {
+		dev = container_of(bus->devices.next, struct pci_dev,
+				   bus_list);
+		dev_dbg(&dev->dev, "removing device\n");
+		pci_remove_bus_device(dev);
+	}
+}
+
+static void pcifront_free_roots(struct pcifront_device *pdev)
+{
+	struct pci_bus_entry *bus_entry, *t;
+
+	dev_dbg(&pdev->xdev->dev, "cleaning up root buses\n");
+
+	list_for_each_entry_safe(bus_entry, t, &pdev->root_buses, list) {
+		list_del(&bus_entry->list);
+
+		free_root_bus_devs(bus_entry->bus);
+
+		kfree(bus_entry->bus->sysdata);
+
+		device_unregister(bus_entry->bus->bridge);
+		pci_remove_bus(bus_entry->bus);
+
+		kfree(bus_entry);
+	}
+}
+
+static pci_ers_result_t pcifront_common_process(int cmd,
+						struct pcifront_device *pdev,
+						pci_channel_state_t state)
+{
+	pci_ers_result_t result;
+	struct pci_driver *pdrv;
+	int bus = pdev->sh_info->aer_op.bus;
+	int devfn = pdev->sh_info->aer_op.devfn;
+	struct pci_dev *pcidev;
+	int flag = 0;
+
+	dev_dbg(&pdev->xdev->dev,
+		"pcifront AER process: cmd %x (bus:%x, devfn%x)",
+		cmd, bus, devfn);
+	result = PCI_ERS_RESULT_NONE;
+
+	pcidev = pci_get_bus_and_slot(bus, devfn);
+	if (!pcidev || !pcidev->driver) {
+		dev_err(&pcidev->dev,
+			"device or driver is NULL\n");
+		return result;
+	}
+	pdrv = pcidev->driver;
+
+	if (get_driver(&pdrv->driver)) {
+		if (pdrv->err_handler && pdrv->err_handler->error_detected) {
+			dev_dbg(&pcidev->dev,
+				"trying to call AER service\n");
+			if (pcidev) {
+				flag = 1;
+				switch (cmd) {
+				case XEN_PCI_OP_aer_detected:
+					result = pdrv->err_handler->
+						 error_detected(pcidev, state);
+					break;
+				case XEN_PCI_OP_aer_mmio:
+					result = pdrv->err_handler->
+						 mmio_enabled(pcidev);
+					break;
+				case XEN_PCI_OP_aer_slotreset:
+					result = pdrv->err_handler->
+						 slot_reset(pcidev);
+					break;
+				case XEN_PCI_OP_aer_resume:
+					pdrv->err_handler->resume(pcidev);
+					break;
+				default:
+					dev_err(&pdev->xdev->dev,
+						"bad request in aer recovery "
+						"operation!\n");
+
+				}
+			}
+		}
+		put_driver(&pdrv->driver);
+	}
+	if (!flag)
+		result = PCI_ERS_RESULT_NONE;
+
+	return result;
+}
+
+
+static void pcifront_do_aer(struct work_struct *data)
+{
+	struct pcifront_device *pdev =
+		container_of(data, struct pcifront_device, op_work);
+	int cmd = pdev->sh_info->aer_op.cmd;
+	pci_channel_state_t state =
+		(pci_channel_state_t)pdev->sh_info->aer_op.err;
+
+	/*If a pci_conf op is in progress,
+		we have to wait until it is done before service aer op*/
+	dev_dbg(&pdev->xdev->dev,
+		"pcifront service aer bus %x devfn %x\n",
+		pdev->sh_info->aer_op.bus, pdev->sh_info->aer_op.devfn);
+
+	pdev->sh_info->aer_op.err = pcifront_common_process(cmd, pdev, state);
+
+	/* Post the operation to the guest. */
+	wmb();
+	clear_bit(_XEN_PCIB_active, (unsigned long *)&pdev->sh_info->flags);
+	notify_remote_via_evtchn(pdev->evtchn);
+
+	/*in case of we lost an aer request in four lines time_window*/
+	smp_mb__before_clear_bit();
+	clear_bit(_PDEVB_op_active, &pdev->flags);
+	smp_mb__after_clear_bit();
+
+	schedule_pcifront_aer_op(pdev);
+
+}
+
+static irqreturn_t pcifront_handler_aer(int irq, void *dev)
+{
+	struct pcifront_device *pdev = dev;
+	schedule_pcifront_aer_op(pdev);
+	return IRQ_HANDLED;
+}
+static int pcifront_connect(struct pcifront_device *pdev)
+{
+	int err = 0;
+
+	spin_lock(&pcifront_dev_lock);
+
+	if (!pcifront_dev) {
+		dev_info(&pdev->xdev->dev, "Installing PCI frontend\n");
+		pcifront_dev = pdev;
+	} else {
+		dev_err(&pdev->xdev->dev, "PCI frontend already installed!\n");
+		err = -EEXIST;
+	}
+
+	spin_unlock(&pcifront_dev_lock);
+
+	return err;
+}
+
+static void pcifront_disconnect(struct pcifront_device *pdev)
+{
+	spin_lock(&pcifront_dev_lock);
+
+	if (pdev == pcifront_dev) {
+		dev_info(&pdev->xdev->dev,
+			 "Disconnecting PCI Frontend Buses\n");
+		pcifront_dev = NULL;
+	}
+
+	spin_unlock(&pcifront_dev_lock);
+}
+static struct pcifront_device *alloc_pdev(struct xenbus_device *xdev)
+{
+	struct pcifront_device *pdev;
+
+	pdev = kzalloc(sizeof(struct pcifront_device), GFP_KERNEL);
+	if (pdev == NULL)
+		goto out;
+
+	pdev->sh_info =
+	    (struct xen_pci_sharedinfo *)__get_free_page(GFP_KERNEL);
+	if (pdev->sh_info == NULL) {
+		kfree(pdev);
+		pdev = NULL;
+		goto out;
+	}
+	pdev->sh_info->flags = 0;
+
+	/*Flag for registering PV AER handler*/
+	set_bit(_XEN_PCIB_AERHANDLER, (void *)&pdev->sh_info->flags);
+
+	dev_set_drvdata(&xdev->dev, pdev);
+	pdev->xdev = xdev;
+
+	INIT_LIST_HEAD(&pdev->root_buses);
+
+	spin_lock_init(&pdev->sh_info_lock);
+
+	pdev->evtchn = INVALID_EVTCHN;
+	pdev->gnt_ref = INVALID_GRANT_REF;
+	pdev->irq = -1;
+
+	INIT_WORK(&pdev->op_work, pcifront_do_aer);
+
+	dev_dbg(&xdev->dev, "Allocated pdev @ 0x%p pdev->sh_info @ 0x%p\n",
+		pdev, pdev->sh_info);
+out:
+	return pdev;
+}
+
+static void free_pdev(struct pcifront_device *pdev)
+{
+	dev_dbg(&pdev->xdev->dev, "freeing pdev @ 0x%p\n", pdev);
+
+	pcifront_free_roots(pdev);
+
+	/*For PCIE_AER error handling job*/
+	flush_scheduled_work();
+
+	if (pdev->irq >= 0)
+		unbind_from_irqhandler(pdev->irq, pdev);
+
+	if (pdev->evtchn != INVALID_EVTCHN)
+		xenbus_free_evtchn(pdev->xdev, pdev->evtchn);
+
+	if (pdev->gnt_ref != INVALID_GRANT_REF)
+		gnttab_end_foreign_access(pdev->gnt_ref, 0 /* r/w page */,
+					  (unsigned long)pdev->sh_info);
+	else
+		free_page((unsigned long)pdev->sh_info);
+
+	dev_set_drvdata(&pdev->xdev->dev, NULL);
+
+	kfree(pdev);
+}
+
+static int pcifront_publish_info(struct pcifront_device *pdev)
+{
+	int err = 0;
+	struct xenbus_transaction trans;
+
+	err = xenbus_grant_ring(pdev->xdev, virt_to_mfn(pdev->sh_info));
+	if (err < 0)
+		goto out;
+
+	pdev->gnt_ref = err;
+
+	err = xenbus_alloc_evtchn(pdev->xdev, &pdev->evtchn);
+	if (err)
+		goto out;
+
+	err = bind_evtchn_to_irqhandler(pdev->evtchn, pcifront_handler_aer,
+		0, "pcifront", pdev);
+
+	if (err < 0)
+		return err;
+
+	pdev->irq = err;
+
+do_publish:
+	err = xenbus_transaction_start(&trans);
+	if (err) {
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error writing configuration for backend "
+				 "(start transaction)");
+		goto out;
+	}
+
+	err = xenbus_printf(trans, pdev->xdev->nodename,
+			    "pci-op-ref", "%u", pdev->gnt_ref);
+	if (!err)
+		err = xenbus_printf(trans, pdev->xdev->nodename,
+				    "event-channel", "%u", pdev->evtchn);
+	if (!err)
+		err = xenbus_printf(trans, pdev->xdev->nodename,
+				    "magic", XEN_PCI_MAGIC);
+
+	if (err) {
+		xenbus_transaction_end(trans, 1);
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error writing configuration for backend");
+		goto out;
+	} else {
+		err = xenbus_transaction_end(trans, 0);
+		if (err == -EAGAIN)
+			goto do_publish;
+		else if (err) {
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error completing transaction "
+					 "for backend");
+			goto out;
+		}
+	}
+
+	xenbus_switch_state(pdev->xdev, XenbusStateInitialised);
+
+	dev_dbg(&pdev->xdev->dev, "publishing successful!\n");
+
+out:
+	return err;
+}
+
+static int __devinit pcifront_try_connect(struct pcifront_device *pdev)
+{
+	int err = -EFAULT;
+	int i, num_roots, len;
+	char str[64];
+	unsigned int domain, bus;
+
+
+	/* Only connect once */
+	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	    XenbusStateInitialised)
+		goto out;
+
+	err = pcifront_connect(pdev);
+	if (err) {
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error connecting PCI Frontend");
+		goto out;
+	}
+
+	err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend,
+			   "root_num", "%d", &num_roots);
+	if (err == -ENOENT) {
+		xenbus_dev_error(pdev->xdev, err,
+				 "No PCI Roots found, trying 0000:00");
+		err = pcifront_scan_root(pdev, 0, 0);
+		num_roots = 0;
+	} else if (err != 1) {
+		if (err == 0)
+			err = -EINVAL;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error reading number of PCI roots");
+		goto out;
+	}
+
+	for (i = 0; i < num_roots; i++) {
+		len = snprintf(str, sizeof(str), "root-%d", i);
+		if (unlikely(len >= (sizeof(str) - 1))) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend, str,
+				   "%x:%x", &domain, &bus);
+		if (err != 2) {
+			if (err >= 0)
+				err = -EINVAL;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error reading PCI root %d", i);
+			goto out;
+		}
+
+		err = pcifront_scan_root(pdev, domain, bus);
+		if (err) {
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error scanning PCI root %04x:%02x",
+					 domain, bus);
+			goto out;
+		}
+	}
+
+	err = xenbus_switch_state(pdev->xdev, XenbusStateConnected);
+
+out:
+	return err;
+}
+
+static int pcifront_try_disconnect(struct pcifront_device *pdev)
+{
+	int err = 0;
+	enum xenbus_state prev_state;
+
+
+	prev_state = xenbus_read_driver_state(pdev->xdev->nodename);
+
+	if (prev_state >= XenbusStateClosing)
+		goto out;
+
+	if (prev_state == XenbusStateConnected) {
+		pcifront_free_roots(pdev);
+		pcifront_disconnect(pdev);
+	}
+
+	err = xenbus_switch_state(pdev->xdev, XenbusStateClosed);
+
+out:
+
+	return err;
+}
+
+static int __devinit pcifront_attach_devices(struct pcifront_device *pdev)
+{
+	int err = -EFAULT;
+	int i, num_roots, len;
+	unsigned int domain, bus;
+	char str[64];
+
+	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	    XenbusStateReconfiguring)
+		goto out;
+
+	err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend,
+			   "root_num", "%d", &num_roots);
+	if (err == -ENOENT) {
+		xenbus_dev_error(pdev->xdev, err,
+				 "No PCI Roots found, trying 0000:00");
+		err = pcifront_rescan_root(pdev, 0, 0);
+		num_roots = 0;
+	} else if (err != 1) {
+		if (err == 0)
+			err = -EINVAL;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error reading number of PCI roots");
+		goto out;
+	}
+
+	for (i = 0; i < num_roots; i++) {
+		len = snprintf(str, sizeof(str), "root-%d", i);
+		if (unlikely(len >= (sizeof(str) - 1))) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend, str,
+				   "%x:%x", &domain, &bus);
+		if (err != 2) {
+			if (err >= 0)
+				err = -EINVAL;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error reading PCI root %d", i);
+			goto out;
+		}
+
+		err = pcifront_rescan_root(pdev, domain, bus);
+		if (err) {
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error scanning PCI root %04x:%02x",
+					 domain, bus);
+			goto out;
+		}
+	}
+
+	xenbus_switch_state(pdev->xdev, XenbusStateConnected);
+
+out:
+	return err;
+}
+
+static int pcifront_detach_devices(struct pcifront_device *pdev)
+{
+	int err = 0;
+	int i, num_devs;
+	unsigned int domain, bus, slot, func;
+	struct pci_bus *pci_bus;
+	struct pci_dev *pci_dev;
+	char str[64];
+
+	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	    XenbusStateConnected)
+		goto out;
+
+	err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend, "num_devs", "%d",
+			   &num_devs);
+	if (err != 1) {
+		if (err >= 0)
+			err = -EINVAL;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error reading number of PCI devices");
+		goto out;
+	}
+
+	/* Find devices being detached and remove them. */
+	for (i = 0; i < num_devs; i++) {
+		int l, state;
+		l = snprintf(str, sizeof(str), "state-%d", i);
+		if (unlikely(l >= (sizeof(str) - 1))) {
+			err = -ENOMEM;
+			goto out;
+		}
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend, str, "%d",
+				   &state);
+		if (err != 1)
+			state = XenbusStateUnknown;
+
+		if (state != XenbusStateClosing)
+			continue;
+
+		/* Remove device. */
+		l = snprintf(str, sizeof(str), "vdev-%d", i);
+		if (unlikely(l >= (sizeof(str) - 1))) {
+			err = -ENOMEM;
+			goto out;
+		}
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->otherend, str,
+				   "%x:%x:%x.%x", &domain, &bus, &slot, &func);
+		if (err != 4) {
+			if (err >= 0)
+				err = -EINVAL;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error reading PCI device %d", i);
+			goto out;
+		}
+
+		pci_bus = pci_find_bus(domain, bus);
+		if (!pci_bus) {
+			dev_dbg(&pdev->xdev->dev, "Cannot get bus %04x:%02x\n",
+				domain, bus);
+			continue;
+		}
+		pci_dev = pci_get_slot(pci_bus, PCI_DEVFN(slot, func));
+		if (!pci_dev) {
+			dev_dbg(&pdev->xdev->dev,
+				"Cannot get PCI device %04x:%02x:%02x.%02x\n",
+				domain, bus, slot, func);
+			continue;
+		}
+		pci_remove_bus_device(pci_dev);
+		pci_dev_put(pci_dev);
+
+		dev_dbg(&pdev->xdev->dev,
+			"PCI device %04x:%02x:%02x.%02x removed.\n",
+			domain, bus, slot, func);
+	}
+
+	err = xenbus_switch_state(pdev->xdev, XenbusStateReconfiguring);
+
+out:
+	return err;
+}
+
+static void __init_refok pcifront_backend_changed(struct xenbus_device *xdev,
+						  enum xenbus_state be_state)
+{
+	struct pcifront_device *pdev = dev_get_drvdata(&xdev->dev);
+
+	switch (be_state) {
+	case XenbusStateUnknown:
+	case XenbusStateInitialising:
+	case XenbusStateInitWait:
+	case XenbusStateInitialised:
+	case XenbusStateClosed:
+		break;
+
+	case XenbusStateConnected:
+		pcifront_try_connect(pdev);
+		break;
+
+	case XenbusStateClosing:
+		dev_warn(&xdev->dev, "backend going away!\n");
+		pcifront_try_disconnect(pdev);
+		break;
+
+	case XenbusStateReconfiguring:
+		pcifront_detach_devices(pdev);
+		break;
+
+	case XenbusStateReconfigured:
+		pcifront_attach_devices(pdev);
+		break;
+	}
+}
+
+static int pcifront_xenbus_probe(struct xenbus_device *xdev,
+				 const struct xenbus_device_id *id)
+{
+	int err = 0;
+	struct pcifront_device *pdev = alloc_pdev(xdev);
+
+	if (pdev == NULL) {
+		err = -ENOMEM;
+		xenbus_dev_fatal(xdev, err,
+				 "Error allocating pcifront_device struct");
+		goto out;
+	}
+
+	err = pcifront_publish_info(pdev);
+	if (err)
+		free_pdev(pdev);
+
+out:
+	return err;
+}
+
+static int pcifront_xenbus_remove(struct xenbus_device *xdev)
+{
+	struct pcifront_device *pdev = dev_get_drvdata(&xdev->dev);
+	if (pdev)
+		free_pdev(pdev);
+
+	return 0;
+}
+
+static const struct xenbus_device_id xenpci_ids[] = {
+	{"pci"},
+	{""},
+};
+
+static struct xenbus_driver xenbus_pcifront_driver = {
+	.name			= "pcifront",
+	.owner			= THIS_MODULE,
+	.ids			= xenpci_ids,
+	.probe			= pcifront_xenbus_probe,
+	.remove			= pcifront_xenbus_remove,
+	.otherend_changed	= pcifront_backend_changed,
+};
+
+static int __init pcifront_init(void)
+{
+	if (!xen_pv_domain() || xen_initial_domain())
+		return -ENODEV;
+
+	pci_frontend_registrar(1 /* enable */);
+
+	return xenbus_register_frontend(&xenbus_pcifront_driver);
+}
+
+static void __exit pcifront_cleanup(void)
+{
+	xenbus_unregister_driver(&xenbus_pcifront_driver);
+	pci_frontend_registrar(0 /* disable */);
+}
+module_init(pcifront_init);
+module_exit(pcifront_cleanup);
+
+MODULE_DESCRIPTION("Xen PCI passthrough frontend.");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("xen:pci");
diff --git a/drivers/video/xen-fbfront.c b/drivers/video/xen-fbfront.c
index 7c7f42a..428d273 100644
--- a/drivers/video/xen-fbfront.c
+++ b/drivers/video/xen-fbfront.c
@@ -631,6 +631,8 @@ static void xenfb_backend_changed(struct xenbus_device *dev,
 	switch (backend_state) {
 	case XenbusStateInitialising:
 	case XenbusStateInitialised:
+	case XenbusStateReconfiguring:
+	case XenbusStateReconfigured:
 	case XenbusStateUnknown:
 	case XenbusStateClosed:
 		break;
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 60d71e9..6e6180c 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -74,6 +74,7 @@ config XEN_PLATFORM_PCI
 
 config SWIOTLB_XEN
 	def_bool y
-	depends on SWIOTLB
+	depends on PCI
+	select SWIOTLB
 
 endmenu
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index fcaf838..b978645 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -4,6 +4,7 @@ obj-y	+= xenbus/
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
+obj-$(CONFIG_BLOCK)		+= biomerge.o
 obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
diff --git a/drivers/xen/biomerge.c b/drivers/xen/biomerge.c
new file mode 100644
index 0000000..ba6eda4
--- /dev/null
+++ b/drivers/xen/biomerge.c
@@ -0,0 +1,13 @@
+#include <linux/bio.h>
+#include <linux/io.h>
+#include <xen/page.h>
+
+bool xen_biovec_phys_mergeable(const struct bio_vec *vec1,
+			       const struct bio_vec *vec2)
+{
+	unsigned long mfn1 = pfn_to_mfn(page_to_pfn(vec1->bv_page));
+	unsigned long mfn2 = pfn_to_mfn(page_to_pfn(vec2->bv_page));
+
+	return __BIOVEC_PHYS_MERGEABLE(vec1, vec2) &&
+		((mfn1 == mfn2) || ((mfn1+1) == mfn2));
+}
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 7d24b0d..3df53de 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -16,7 +16,7 @@
  *    (typically dom0).
  * 2. VIRQs, typically used for timers.  These are per-cpu events.
  * 3. IPIs.
- * 4. Hardware interrupts. Not supported at present.
+ * 4. PIRQs - Hardware interrupts.
  *
  * Jeremy Fitzhardinge <jeremy@xensource.com>, XenSource Inc, 2007
  */
@@ -28,11 +28,13 @@
 #include <linux/string.h>
 #include <linux/bootmem.h>
 #include <linux/slab.h>
+#include <linux/irqnr.h>
 
 #include <asm/desc.h>
 #include <asm/ptrace.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/io_apic.h>
 #include <asm/sync_bitops.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -89,20 +91,26 @@ struct irq_info
 		enum ipi_vector ipi;
 		struct {
 			unsigned short gsi;
-			unsigned short vector;
+			unsigned char vector;
+			unsigned char flags;
 		} pirq;
 	} u;
 };
+#define PIRQ_NEEDS_EOI	(1 << 0)
+#define PIRQ_SHAREABLE	(1 << 1)
 
-static struct irq_info irq_info[NR_IRQS];
+static struct irq_info *irq_info;
 
-static int evtchn_to_irq[NR_EVENT_CHANNELS] = {
-	[0 ... NR_EVENT_CHANNELS-1] = -1
-};
+static int *evtchn_to_irq;
 struct cpu_evtchn_s {
 	unsigned long bits[NR_EVENT_CHANNELS/BITS_PER_LONG];
 };
-static struct cpu_evtchn_s *cpu_evtchn_mask_p;
+
+static __initdata struct cpu_evtchn_s init_evtchn_mask = {
+	.bits[0 ... (NR_EVENT_CHANNELS/BITS_PER_LONG)-1] = ~0ul,
+};
+static struct cpu_evtchn_s *cpu_evtchn_mask_p = &init_evtchn_mask;
+
 static inline unsigned long *cpu_evtchn_mask(int cpu)
 {
 	return cpu_evtchn_mask_p[cpu].bits;
@@ -113,6 +121,7 @@ static inline unsigned long *cpu_evtchn_mask(int cpu)
 
 static struct irq_chip xen_dynamic_chip;
 static struct irq_chip xen_percpu_chip;
+static struct irq_chip xen_pirq_chip;
 
 /* Constructor for packed IRQ information. */
 static struct irq_info mk_unbound_info(void)
@@ -225,6 +234,15 @@ static unsigned int cpu_from_evtchn(unsigned int evtchn)
 	return ret;
 }
 
+static bool pirq_needs_eoi(unsigned irq)
+{
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	return info->u.pirq.flags & PIRQ_NEEDS_EOI;
+}
+
 static inline unsigned long active_evtchns(unsigned int cpu,
 					   struct shared_info *sh,
 					   unsigned int idx)
@@ -336,12 +354,28 @@ static void unmask_evtchn(int port)
 	put_cpu();
 }
 
+static int get_nr_hw_irqs(void)
+{
+	int ret = 1;
+
+#ifdef CONFIG_X86_IO_APIC
+	ret = get_nr_irqs_gsi();
+#endif
+
+	return ret;
+}
+
 static int find_unbound_irq(void)
 {
 	struct irq_data *data;
 	int irq, res;
+	int start = get_nr_hw_irqs();
 
-	for (irq = 0; irq < nr_irqs; irq++) {
+	if (start == nr_irqs)
+		goto no_irqs;
+
+	/* nr_irqs is a magic value. Must not use it.*/
+	for (irq = nr_irqs-1; irq > start; irq--) {
 		data = irq_get_irq_data(irq);
 		/* only 0->15 have init'd desc; handle irq > 16 */
 		if (!data)
@@ -354,8 +388,8 @@ static int find_unbound_irq(void)
 			return irq;
 	}
 
-	if (irq == nr_irqs)
-		panic("No available IRQ to bind to: increase nr_irqs!\n");
+	if (irq == start)
+		goto no_irqs;
 
 	res = irq_alloc_desc_at(irq, 0);
 
@@ -363,6 +397,252 @@ static int find_unbound_irq(void)
 		return -1;
 
 	return irq;
+
+no_irqs:
+	panic("No available IRQ to bind to: increase nr_irqs!\n");
+}
+
+static bool identity_mapped_irq(unsigned irq)
+{
+	/* identity map all the hardware irqs */
+	return irq < get_nr_hw_irqs();
+}
+
+static void pirq_unmask_notify(int irq)
+{
+	struct physdev_eoi eoi = { .irq = irq };
+
+	if (unlikely(pirq_needs_eoi(irq))) {
+		int rc = HYPERVISOR_physdev_op(PHYSDEVOP_eoi, &eoi);
+		WARN_ON(rc);
+	}
+}
+
+static void pirq_query_unmask(int irq)
+{
+	struct physdev_irq_status_query irq_status;
+	struct irq_info *info = info_for_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	irq_status.irq = irq;
+	if (HYPERVISOR_physdev_op(PHYSDEVOP_irq_status_query, &irq_status))
+		irq_status.flags = 0;
+
+	info->u.pirq.flags &= ~PIRQ_NEEDS_EOI;
+	if (irq_status.flags & XENIRQSTAT_needs_eoi)
+		info->u.pirq.flags |= PIRQ_NEEDS_EOI;
+}
+
+static bool probing_irq(int irq)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	return desc && desc->action == NULL;
+}
+
+static unsigned int startup_pirq(unsigned int irq)
+{
+	struct evtchn_bind_pirq bind_pirq;
+	struct irq_info *info = info_for_irq(irq);
+	int evtchn = evtchn_from_irq(irq);
+	int rc;
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	if (VALID_EVTCHN(evtchn))
+		goto out;
+
+	bind_pirq.pirq = irq;
+	/* NB. We are happy to share unless we are probing. */
+	bind_pirq.flags = info->u.pirq.flags & PIRQ_SHAREABLE ?
+					BIND_PIRQ__WILL_SHARE : 0;
+	rc = HYPERVISOR_event_channel_op(EVTCHNOP_bind_pirq, &bind_pirq);
+	if (rc != 0) {
+		if (!probing_irq(irq))
+			printk(KERN_INFO "Failed to obtain physical IRQ %d\n",
+			       irq);
+		return 0;
+	}
+	evtchn = bind_pirq.port;
+
+	pirq_query_unmask(irq);
+
+	evtchn_to_irq[evtchn] = irq;
+	bind_evtchn_to_cpu(evtchn, 0);
+	info->evtchn = evtchn;
+
+out:
+	unmask_evtchn(evtchn);
+	pirq_unmask_notify(irq);
+
+	return 0;
+}
+
+static void shutdown_pirq(unsigned int irq)
+{
+	struct evtchn_close close;
+	struct irq_info *info = info_for_irq(irq);
+	int evtchn = evtchn_from_irq(irq);
+
+	BUG_ON(info->type != IRQT_PIRQ);
+
+	if (!VALID_EVTCHN(evtchn))
+		return;
+
+	mask_evtchn(evtchn);
+
+	close.port = evtchn;
+	if (HYPERVISOR_event_channel_op(EVTCHNOP_close, &close) != 0)
+		BUG();
+
+	bind_evtchn_to_cpu(evtchn, 0);
+	evtchn_to_irq[evtchn] = -1;
+	info->evtchn = 0;
+}
+
+static void enable_pirq(unsigned int irq)
+{
+	startup_pirq(irq);
+}
+
+static void disable_pirq(unsigned int irq)
+{
+}
+
+static void ack_pirq(unsigned int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+
+	move_native_irq(irq);
+
+	if (VALID_EVTCHN(evtchn)) {
+		mask_evtchn(evtchn);
+		clear_evtchn(evtchn);
+	}
+}
+
+static void end_pirq(unsigned int irq)
+{
+	int evtchn = evtchn_from_irq(irq);
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	if (WARN_ON(!desc))
+		return;
+
+	if ((desc->status & (IRQ_DISABLED|IRQ_PENDING)) ==
+	    (IRQ_DISABLED|IRQ_PENDING)) {
+		shutdown_pirq(irq);
+	} else if (VALID_EVTCHN(evtchn)) {
+		unmask_evtchn(evtchn);
+		pirq_unmask_notify(irq);
+	}
+}
+
+static int find_irq_by_gsi(unsigned gsi)
+{
+	int irq;
+
+	for (irq = 0; irq < nr_irqs; irq++) {
+		struct irq_info *info = info_for_irq(irq);
+
+		if (info == NULL || info->type != IRQT_PIRQ)
+			continue;
+
+		if (gsi_from_irq(irq) == gsi)
+			return irq;
+	}
+
+	return -1;
+}
+
+/* xen_allocate_irq might allocate irqs from the top down, as a
+ * consequence don't assume that the irq number returned has a low value
+ * or can be used as a pirq number unless you know otherwise.
+ *
+ * One notable exception is when xen_allocate_irq is called passing an
+ * hardware gsi as argument, in that case the irq number returned
+ * matches the gsi number passed as first argument.
+
+ * Note: We don't assign an
+ * event channel until the irq actually started up.  Return an
+ * existing irq if we've already got one for the gsi.
+ */
+int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
+{
+	int irq;
+	struct physdev_irq irq_op;
+
+	spin_lock(&irq_mapping_update_lock);
+
+	irq = find_irq_by_gsi(gsi);
+	if (irq != -1) {
+		printk(KERN_INFO "xen_allocate_pirq: returning irq %d for gsi %u\n",
+		       irq, gsi);
+		goto out;	/* XXX need refcount? */
+	}
+
+	/* If we are a PV guest, we don't have GSIs (no ACPI passed). Therefore
+	 * we are using the !xen_initial_domain() to drop in the function.*/
+	if (identity_mapped_irq(gsi) || !xen_initial_domain()) {
+		irq = gsi;
+		irq_alloc_desc_at(irq, 0);
+	} else
+		irq = find_unbound_irq();
+
+	set_irq_chip_and_handler_name(irq, &xen_pirq_chip,
+				      handle_level_irq, name);
+
+	irq_op.irq = irq;
+	irq_op.vector = 0;
+
+	/* Only the privileged domain can do this. For non-priv, the pcifront
+	 * driver provides a PCI bus that does the call to do exactly
+	 * this in the priv domain. */
+	if (xen_initial_domain() &&
+	    HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
+		irq_free_desc(irq);
+		irq = -ENOSPC;
+		goto out;
+	}
+
+	irq_info[irq] = mk_pirq_info(0, gsi, irq_op.vector);
+	irq_info[irq].u.pirq.flags |= shareable ? PIRQ_SHAREABLE : 0;
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+
+	return irq;
+}
+
+int xen_destroy_irq(int irq)
+{
+	struct irq_desc *desc;
+	int rc = -ENOENT;
+
+	spin_lock(&irq_mapping_update_lock);
+
+	desc = irq_to_desc(irq);
+	if (!desc)
+		goto out;
+
+	irq_info[irq] = mk_unbound_info();
+
+	irq_free_desc(irq);
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+	return rc;
+}
+
+int xen_vector_from_irq(unsigned irq)
+{
+	return vector_from_irq(irq);
+}
+
+int xen_gsi_from_irq(unsigned irq)
+{
+	return gsi_from_irq(irq);
 }
 
 int bind_evtchn_to_irq(unsigned int evtchn)
@@ -891,7 +1171,7 @@ void xen_clear_irq_pending(int irq)
 	if (VALID_EVTCHN(evtchn))
 		clear_evtchn(evtchn);
 }
-
+EXPORT_SYMBOL(xen_clear_irq_pending);
 void xen_set_irq_pending(int irq)
 {
 	int evtchn = evtchn_from_irq(irq);
@@ -911,9 +1191,9 @@ bool xen_test_irq_pending(int irq)
 	return ret;
 }
 
-/* Poll waiting for an irq to become pending.  In the usual case, the
-   irq will be disabled so it won't deliver an interrupt. */
-void xen_poll_irq(int irq)
+/* Poll waiting for an irq to become pending with timeout.  In the usual case,
+ * the irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq_timeout(int irq, u64 timeout)
 {
 	evtchn_port_t evtchn = evtchn_from_irq(irq);
 
@@ -921,13 +1201,20 @@ void xen_poll_irq(int irq)
 		struct sched_poll poll;
 
 		poll.nr_ports = 1;
-		poll.timeout = 0;
+		poll.timeout = timeout;
 		set_xen_guest_handle(poll.ports, &evtchn);
 
 		if (HYPERVISOR_sched_op(SCHEDOP_poll, &poll) != 0)
 			BUG();
 	}
 }
+EXPORT_SYMBOL(xen_poll_irq_timeout);
+/* Poll waiting for an irq to become pending.  In the usual case, the
+ * irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq(int irq)
+{
+	xen_poll_irq_timeout(irq, 0 /* no timeout */);
+}
 
 void xen_irq_resume(void)
 {
@@ -964,6 +1251,26 @@ static struct irq_chip xen_dynamic_chip __read_mostly = {
 	.retrigger	= retrigger_dynirq,
 };
 
+static struct irq_chip xen_pirq_chip __read_mostly = {
+	.name		= "xen-pirq",
+
+	.startup	= startup_pirq,
+	.shutdown	= shutdown_pirq,
+
+	.enable		= enable_pirq,
+	.unmask		= enable_pirq,
+
+	.disable	= disable_pirq,
+	.mask		= disable_pirq,
+
+	.ack		= ack_pirq,
+	.end		= end_pirq,
+
+	.set_affinity	= set_affinity_irq,
+
+	.retrigger	= retrigger_dynirq,
+};
+
 static struct irq_chip xen_percpu_chip __read_mostly = {
 	.name		= "xen-percpu",
 
@@ -1018,7 +1325,12 @@ void __init xen_init_IRQ(void)
 
 	cpu_evtchn_mask_p = kcalloc(nr_cpu_ids, sizeof(struct cpu_evtchn_s),
 				    GFP_KERNEL);
-	BUG_ON(cpu_evtchn_mask_p == NULL);
+	irq_info = kcalloc(nr_irqs, sizeof(*irq_info), GFP_KERNEL);
+
+	evtchn_to_irq = kcalloc(NR_EVENT_CHANNELS, sizeof(*evtchn_to_irq),
+				    GFP_KERNEL);
+	for (i = 0; i < NR_EVENT_CHANNELS; i++)
+		evtchn_to_irq[i] = -1;
 
 	init_evtchn_cpu_bindings();
 
diff --git a/drivers/xen/xenbus/xenbus_client.c b/drivers/xen/xenbus/xenbus_client.c
index 7e49527..cdacf92 100644
--- a/drivers/xen/xenbus/xenbus_client.c
+++ b/drivers/xen/xenbus/xenbus_client.c
@@ -50,6 +50,8 @@ const char *xenbus_strstate(enum xenbus_state state)
 		[ XenbusStateConnected    ] = "Connected",
 		[ XenbusStateClosing      ] = "Closing",
 		[ XenbusStateClosed	  ] = "Closed",
+		[XenbusStateReconfiguring] = "Reconfiguring",
+		[XenbusStateReconfigured] = "Reconfigured",
 	};
 	return (state < ARRAY_SIZE(name)) ? name[state] : "INVALID";
 }
diff --git a/include/xen/events.h b/include/xen/events.h
index a15d932..c1717ca 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -53,6 +53,10 @@ bool xen_test_irq_pending(int irq);
    irq will be disabled so it won't deliver an interrupt. */
 void xen_poll_irq(int irq);
 
+/* Poll waiting for an irq to become pending with a timeout.  In the usual case,
+ * the irq will be disabled so it won't deliver an interrupt. */
+void xen_poll_irq_timeout(int irq, u64 timeout);
+
 /* Determine the IRQ which is bound to an event channel */
 unsigned irq_from_evtchn(unsigned int evtchn);
 
@@ -63,4 +67,18 @@ int xen_set_callback_via(uint64_t via);
 void xen_evtchn_do_upcall(struct pt_regs *regs);
 void xen_hvm_evtchn_do_upcall(void);
 
+/* Allocate an irq for a physical interrupt, given a gsi.  "Legacy"
+ * GSIs are identity mapped; others are dynamically allocated as
+ * usual. */
+int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
+
+/* De-allocates the above mentioned physical interrupt. */
+int xen_destroy_irq(int irq);
+
+/* Return vector allocated to pirq */
+int xen_vector_from_irq(unsigned pirq);
+
+/* Return gsi allocated to pirq */
+int xen_gsi_from_irq(unsigned pirq);
+
 #endif	/* _XEN_EVENTS_H */
diff --git a/include/xen/interface/io/pciif.h b/include/xen/interface/io/pciif.h
new file mode 100644
index 0000000..d9922ae
--- /dev/null
+++ b/include/xen/interface/io/pciif.h
@@ -0,0 +1,112 @@
+/*
+ * PCI Backend/Frontend Common Data Structures & Macros
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#ifndef __XEN_PCI_COMMON_H__
+#define __XEN_PCI_COMMON_H__
+
+/* Be sure to bump this number if you change this file */
+#define XEN_PCI_MAGIC "7"
+
+/* xen_pci_sharedinfo flags */
+#define	_XEN_PCIF_active		(0)
+#define	XEN_PCIF_active			(1<<_XEN_PCIF_active)
+#define	_XEN_PCIB_AERHANDLER		(1)
+#define	XEN_PCIB_AERHANDLER		(1<<_XEN_PCIB_AERHANDLER)
+#define	_XEN_PCIB_active		(2)
+#define	XEN_PCIB_active			(1<<_XEN_PCIB_active)
+
+/* xen_pci_op commands */
+#define	XEN_PCI_OP_conf_read		(0)
+#define	XEN_PCI_OP_conf_write		(1)
+#define	XEN_PCI_OP_enable_msi		(2)
+#define	XEN_PCI_OP_disable_msi		(3)
+#define	XEN_PCI_OP_enable_msix		(4)
+#define	XEN_PCI_OP_disable_msix		(5)
+#define	XEN_PCI_OP_aer_detected		(6)
+#define	XEN_PCI_OP_aer_resume		(7)
+#define	XEN_PCI_OP_aer_mmio		(8)
+#define	XEN_PCI_OP_aer_slotreset	(9)
+
+/* xen_pci_op error numbers */
+#define	XEN_PCI_ERR_success		(0)
+#define	XEN_PCI_ERR_dev_not_found	(-1)
+#define	XEN_PCI_ERR_invalid_offset	(-2)
+#define	XEN_PCI_ERR_access_denied	(-3)
+#define	XEN_PCI_ERR_not_implemented	(-4)
+/* XEN_PCI_ERR_op_failed - backend failed to complete the operation */
+#define XEN_PCI_ERR_op_failed		(-5)
+
+/*
+ * it should be PAGE_SIZE-sizeof(struct xen_pci_op))/sizeof(struct msix_entry))
+ * Should not exceed 128
+ */
+#define SH_INFO_MAX_VEC			128
+
+struct xen_msix_entry {
+	uint16_t vector;
+	uint16_t entry;
+};
+struct xen_pci_op {
+	/* IN: what action to perform: XEN_PCI_OP_* */
+	uint32_t cmd;
+
+	/* OUT: will contain an error number (if any) from errno.h */
+	int32_t err;
+
+	/* IN: which device to touch */
+	uint32_t domain; /* PCI Domain/Segment */
+	uint32_t bus;
+	uint32_t devfn;
+
+	/* IN: which configuration registers to touch */
+	int32_t offset;
+	int32_t size;
+
+	/* IN/OUT: Contains the result after a READ or the value to WRITE */
+	uint32_t value;
+	/* IN: Contains extra infor for this operation */
+	uint32_t info;
+	/*IN:  param for msi-x */
+	struct xen_msix_entry msix_entries[SH_INFO_MAX_VEC];
+};
+
+/*used for pcie aer handling*/
+struct xen_pcie_aer_op {
+	/* IN: what action to perform: XEN_PCI_OP_* */
+	uint32_t cmd;
+	/*IN/OUT: return aer_op result or carry error_detected state as input*/
+	int32_t err;
+
+	/* IN: which device to touch */
+	uint32_t domain; /* PCI Domain/Segment*/
+	uint32_t bus;
+	uint32_t devfn;
+};
+struct xen_pci_sharedinfo {
+	/* flags - XEN_PCIF_* */
+	uint32_t flags;
+	struct xen_pci_op op;
+	struct xen_pcie_aer_op aer_op;
+};
+
+#endif /* __XEN_PCI_COMMON_H__ */
diff --git a/include/xen/interface/io/xenbus.h b/include/xen/interface/io/xenbus.h
index 46508c7..9fda532 100644
--- a/include/xen/interface/io/xenbus.h
+++ b/include/xen/interface/io/xenbus.h
@@ -27,8 +27,14 @@ enum xenbus_state
 	XenbusStateClosing      = 5,  /* The device is being closed
 					 due to an error or an unplug
 					 event. */
-	XenbusStateClosed       = 6
+	XenbusStateClosed       = 6,
 
+	/*
+	* Reconfiguring: The device is being reconfigured.
+	*/
+	XenbusStateReconfiguring = 7,
+
+	XenbusStateReconfigured  = 8
 };
 
 #endif /* _XEN_PUBLIC_IO_XENBUS_H */
