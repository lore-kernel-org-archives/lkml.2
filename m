Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439Ab0HDSU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:20:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56671 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab0HDSUu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:50 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Alex Nixon <alex.nixon@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Wilcox <willy@linux.intel.com>, Qing He <qing.he@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 17/20] xen/x86/PCI: Add support for the Xen PCI subsystem
Date: Wed,  4 Aug 2010 14:19:12 -0400
Message-Id: <1280945955-14229-18-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C59AF69.0273:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

The frontend stub lives in arch/x86/pci/xen.c, alongside other
sub-arch PCI init code (e.g. olpc.c).

It provides a mechanism for Xen PCI frontend to setup/destroy
legacy interrupts, MSI/MSI-X, and PCI configuration operations.

[ Impact: add core of Xen PCI support ]
[ v2: Removed the IOMMU code and only focusing on PCI. Dropping:
drivers/pci/Makefile, drivers/pci/xen-iommu.c, arch/x86/kernel/pci-dma.c
and arch/x86/include/asm/xen/iommu.h]
[ v3: removed usage of pci_scan_all_fns as that does not exist]
[ v4: introduced pci_xen value to fix compile warnings]
[ v5: squished fixes+features in one patch, changed Reviewed-by to Ccs]
Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Qing He <qing.he@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/Kconfig               |    5 ++
 arch/x86/include/asm/xen/pci.h |   53 ++++++++++++++
 arch/x86/pci/Makefile          |    1 +
 arch/x86/pci/xen.c             |  147 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/xen/enlighten.c       |    3 +
 drivers/xen/events.c           |   32 ++++++++-
 include/xen/events.h           |    3 +
 7 files changed, 242 insertions(+), 2 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/pci.h
 create mode 100644 arch/x86/pci/xen.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index dcb0593..108b2ab 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1922,6 +1922,11 @@ config PCI_OLPC
 	def_bool y
 	depends on PCI && OLPC && (PCI_GOOLPC || PCI_GOANY)
 
+config PCI_XEN
+	def_bool n
+	depends on XEN
+	select SWIOTLB_XEN
+
 config PCI_DOMAINS
 	def_bool y
 	depends on PCI
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
diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
new file mode 100644
index 0000000..b19c873
--- /dev/null
+++ b/arch/x86/pci/xen.c
@@ -0,0 +1,147 @@
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
+#ifdef CONFIG_ISAPNP
+	/* Stop isapnp from probing */
+	isapnp_disable = 1;
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
index 65d8d79..f7feba5 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -42,6 +42,7 @@
 #include <asm/paravirt.h>
 #include <asm/apic.h>
 #include <asm/page.h>
+#include <asm/xen/pci.h>
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/fixmap.h>
@@ -1189,6 +1190,8 @@ asmlinkage void __init xen_start_kernel(void)
 		add_preferred_console("xenboot", 0, NULL);
 		add_preferred_console("tty", 0, NULL);
 		add_preferred_console("hvc", 0, NULL);
+		if (pci_xen)
+			x86_init.pci.arch_init = pci_xen_init;
 	} else {
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 78c1525..249fbbd 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -561,7 +561,9 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 		goto out;	/* XXX need refcount? */
 	}
 
-	if (identity_mapped_irq(gsi)) {
+	/* If we are a PV guest, we don't have GSIs (no ACPI passed). Therefore
+	 * we are using the !xen_initial_domain() to drop in the function.*/
+	if (identity_mapped_irq(gsi) || !xen_initial_domain()) {
 		irq = gsi;
 		irq_to_desc_alloc_node(irq, 0);
 		dynamic_irq_init(irq);
@@ -572,7 +574,13 @@ int xen_allocate_pirq(unsigned gsi, int shareable, char *name)
 				      handle_level_irq, name);
 
 	irq_op.irq = irq;
-	if (HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
+	irq_op.vector = 0;
+
+	/* Only the privileged domain can do this. For non-priv, the pcifront
+	 * driver provides a PCI bus that does the call to do exactly
+	 * this in the priv domain. */
+	if (xen_initial_domain() &&
+	    HYPERVISOR_physdev_op(PHYSDEVOP_alloc_irq_vector, &irq_op)) {
 		dynamic_irq_cleanup(irq);
 		irq = -ENOSPC;
 		goto out;
@@ -587,6 +595,26 @@ out:
 	return irq;
 }
 
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
+	dynamic_irq_cleanup(irq);
+
+out:
+	spin_unlock(&irq_mapping_update_lock);
+	return rc;
+}
+
 int xen_vector_from_irq(unsigned irq)
 {
 	return vector_from_irq(irq);
diff --git a/include/xen/events.h b/include/xen/events.h
index 20e27c3..3ef6624 100644
--- a/include/xen/events.h
+++ b/include/xen/events.h
@@ -65,6 +65,9 @@ unsigned irq_from_evtchn(unsigned int evtchn);
    usual. */
 int xen_allocate_pirq(unsigned gsi, int shareable, char *name);
 
+/* De-allocates the above mentioned physical interrupt. */
+int xen_destroy_irq(int irq);
+
 /* Return vector allocated to pirq */
 int xen_vector_from_irq(unsigned pirq);
 
-- 
1.7.0.1

