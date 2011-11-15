Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545Ab1KOVcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:32:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:37777 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab1KOVcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:32:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        x86@kernel.org, hpa@zytor.com, len.brown@intel.com,
        joseph.cihula@intel.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 4/7] x86: Expand the x86_msi_ops to have a restore MSIs.
Date: Tue, 15 Nov 2011 16:31:08 -0500
Message-Id: <1321392671-9128-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
References: <1321392671-9128-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EC2DA45.006B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MSI restore function will become a function pointer in an
x86_msi_ops struct. It defaults to the implementation in the
io_apic.c and msi.c. We piggyback on the indirection mechanism
introduced by "x86: Introduce x86_msi_ops".

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/pci.h      |    9 +++++++++
 arch/x86/include/asm/x86_init.h |    1 +
 arch/x86/kernel/x86_init.c      |    1 +
 drivers/pci/msi.c               |   29 +++++++++++++++++++++++++++--
 4 files changed, 38 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d498943..df75d07 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -112,19 +112,28 @@ static inline void x86_teardown_msi_irq(unsigned int irq)
 {
 	x86_msi.teardown_msi_irq(irq);
 }
+static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	x86_msi.restore_msi_irqs(dev, irq);
+}
 #define arch_setup_msi_irqs x86_setup_msi_irqs
 #define arch_teardown_msi_irqs x86_teardown_msi_irqs
 #define arch_teardown_msi_irq x86_teardown_msi_irq
+#define arch_restore_msi_irqs x86_restore_msi_irqs
 /* implemented in arch/x86/kernel/apic/io_apic. */
 int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
 void native_teardown_msi_irq(unsigned int irq);
+void native_restore_msi_irqs(struct pci_dev *dev, int irq);
 /* default to the implementation in drivers/lib/msi.c */
 #define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
+#define HAVE_DEFAULT_MSI_RESTORE_IRQS
 void default_teardown_msi_irqs(struct pci_dev *dev);
+void default_restore_msi_irqs(struct pci_dev *dev, int irq);
 #else
 #define native_setup_msi_irqs		NULL
 #define native_teardown_msi_irq		NULL
 #define default_teardown_msi_irqs	NULL
+#define default_restore_msi_irqs	NULL
 #endif
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index d3d8590..7af18be 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -174,6 +174,7 @@ struct x86_msi_ops {
 	int (*setup_msi_irqs)(struct pci_dev *dev, int nvec, int type);
 	void (*teardown_msi_irq)(unsigned int irq);
 	void (*teardown_msi_irqs)(struct pci_dev *dev);
+	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
 };
 
 extern struct x86_init_ops x86_init;
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index 6f164bd..bd1fe10 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -110,4 +110,5 @@ struct x86_msi_ops x86_msi = {
 	.setup_msi_irqs = native_setup_msi_irqs,
 	.teardown_msi_irq = native_teardown_msi_irq,
 	.teardown_msi_irqs = default_teardown_msi_irqs,
+	.restore_msi_irqs = default_restore_msi_irqs,
 };
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 0e6d04d..ba2ea4e 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -86,6 +86,31 @@ void default_teardown_msi_irqs(struct pci_dev *dev)
 }
 #endif
 
+#ifndef arch_restore_msi_irqs
+# define arch_restore_msi_irqs default_restore_msi_irqs
+# define HAVE_DEFAULT_MSI_RESTORE_IRQS
+#endif
+
+#ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
+void default_restore_msi_irqs(struct pci_dev *dev, int irq)
+{
+	struct msi_desc *entry;
+
+	entry = NULL;
+	if (dev->msix_enabled) {
+		list_for_each_entry(entry, &dev->msi_list, list) {
+			if (irq == entry->irq)
+				break;
+		}
+	} else if (dev->msi_enabled)  {
+		entry = irq_get_msi_desc(irq);
+	}
+
+	if (entry)
+		write_msi_msg(irq, &entry->msg);
+}
+#endif
+
 static void msi_set_enable(struct pci_dev *dev, int pos, int enable)
 {
 	u16 control;
@@ -360,7 +385,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 
 	pci_intx_for_msi(dev, 0);
 	msi_set_enable(dev, pos, 0);
-	write_msi_msg(dev->irq, &entry->msg);
+	arch_restore_msi_irqs(dev, dev->irq);
 
 	pci_read_config_word(dev, pos + PCI_MSI_FLAGS, &control);
 	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
@@ -388,7 +413,7 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 	pci_write_config_word(dev, pos + PCI_MSIX_FLAGS, control);
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
-		write_msi_msg(entry->irq, &entry->msg);
+		arch_restore_msi_irqs(dev, entry->irq);
 		msix_mask_irq(entry, entry->masked);
 	}
 
-- 
1.7.7.1

