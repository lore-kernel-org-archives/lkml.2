Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab0JDSPz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:15:55 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31610 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab0JDSOF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:14:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 16/22] x86: Introduce x86_msi_ops
Date: Mon,  4 Oct 2010 14:13:29 -0400
Message-Id: <1286216015-9710-17-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Introduce an x86 specific indirect mechanism to setup MSIs.
The MSI setup functions become function pointers in an x86_msi_ops
struct, that defaults to the implementation in io_apic.c

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/include/asm/pci.h      |   26 +++++++++++++++++++++++---
 arch/x86/include/asm/x86_init.h |    9 +++++++++
 arch/x86/kernel/apic/io_apic.c  |    8 ++++----
 arch/x86/kernel/x86_init.c      |    6 ++++++
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 79d6ada..5b0f853 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -7,6 +7,7 @@
 #include <linux/string.h>
 #include <asm/scatterlist.h>
 #include <asm/io.h>
+#include <asm/x86_init.h>
 
 #ifdef __KERNEL__
 
@@ -94,9 +95,28 @@ static inline void early_quirks(void) { }
 
 extern void pci_iommu_alloc(void);
 
-/* MSI arch hook */
-#define arch_setup_msi_irqs arch_setup_msi_irqs
-#define arch_teardown_msi_irqs arch_teardown_msi_irqs
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
+
+#define arch_setup_msi_irqs x86_setup_msi_irqs
+#define arch_teardown_msi_irqs x86_teardown_msi_irqs
+#define arch_teardown_msi_irq x86_teardown_msi_irq
+int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
+void native_teardown_msi_irq(unsigned int irq);
+void native_teardown_msi_irqs(struct pci_dev *dev);
 
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
index 4132eea..af80132 100644
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
@@ -3594,12 +3594,12 @@ error:
 	return ret;
 }
 
-void arch_teardown_msi_irq(unsigned int irq)
+void native_teardown_msi_irq(unsigned int irq)
 {
 	destroy_irq(irq);
 }
 
-void arch_teardown_msi_irqs(struct pci_dev *dev)
+void native_teardown_msi_irqs(struct pci_dev *dev)
 {
 	struct msi_desc *entry;
 
@@ -3609,7 +3609,7 @@ void arch_teardown_msi_irqs(struct pci_dev *dev)
 			continue;
 		nvec = 1 << entry->msi_attrib.multiple;
 		for (i = 0; i < nvec; i++)
-			arch_teardown_msi_irq(entry->irq + i);
+			x86_msi.teardown_msi_irq(entry->irq + i);
 	}
 }
 
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index cd6da6b..91b5209 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -6,6 +6,7 @@
 #include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/module.h>
+#include <linux/pci.h>
 
 #include <asm/bios_ebda.h>
 #include <asm/paravirt.h>
@@ -99,3 +100,8 @@ struct x86_platform_ops x86_platform = {
 };
 
 EXPORT_SYMBOL_GPL(x86_platform);
+struct x86_msi_ops x86_msi = {
+	.setup_msi_irqs = native_setup_msi_irqs,
+	.teardown_msi_irq = native_teardown_msi_irq,
+	.teardown_msi_irqs = native_teardown_msi_irqs,
+};
-- 
1.7.0.4

