Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863Ab0JLPwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 11:52:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32158 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab0JLPw0 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 11:52:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 16/23] x86: Introduce x86_msi_ops
Date: Tue, 12 Oct 2010 11:44:24 -0400
Message-Id: <1286898271-32018-17-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
References: <1286898271-32018-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Introduce an x86 specific indirect mechanism to setup MSIs.
The MSI setup functions become function pointers in an x86_msi_ops
struct, that defaults to the implementation in io_apic.c and msi.c.

[v2: Use HAVE_DEFAULT_* knobs]
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/include/asm/pci.h      |   33 +++++++++++++++++++++++++++++++--
 arch/x86/include/asm/x86_init.h |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c  |    4 ++--
 arch/x86/kernel/x86_init.c      |    7 +++++++
 4 files changed, 49 insertions(+), 4 deletions(-)

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
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4c9b2b9..1bfc6d1 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3533,7 +3533,7 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
 	int ret, sub_handle;
@@ -3594,7 +3594,7 @@ error:
 	return ret;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
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
-- 
1.7.0.4

