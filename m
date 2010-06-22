Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876Ab0FVTrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:47:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33029 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab0FVTrs (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:47:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 18/19] pci-swiotlb-xen: Add glue code to setup dma_ops utilizing xen_swiotlb_* functions.
Date: Tue, 22 Jun 2010 15:42:51 -0400
Message-Id: <1277235772-26757-19-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4C2112F5.019F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We add the glue code that sets up a dma_ops structure with the
xen_swiotlb_* functions. The code turns on xen_swiotlb flag
when it detects it is running under Xen and it is either
in privileged mode or the iommu=soft flag was passed in.

It also disables the bare-metal SWIOTLB if the Xen-SWIOTLB has
been enabled.

Note: The Xen-SWIOTLB is only built when CONFIG_XEN is enabled.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/swiotlb-xen.h |   14 ++++++++
 arch/x86/xen/Makefile                  |    1 +
 arch/x86/xen/pci-swiotlb-xen.c         |   58 ++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/xen/swiotlb-xen.h
 create mode 100644 arch/x86/xen/pci-swiotlb-xen.c

diff --git a/arch/x86/include/asm/xen/swiotlb-xen.h b/arch/x86/include/asm/xen/swiotlb-xen.h
new file mode 100644
index 0000000..c2bc047
--- /dev/null
+++ b/arch/x86/include/asm/xen/swiotlb-xen.h
@@ -0,0 +1,14 @@
+#ifndef _ASM_X86_SWIOTLB_XEN_H
+#define _ASM_X86_SWIOTLB_XEN_H
+
+#ifdef CONFIG_SWIOTLB_XEN
+extern int xen_swiotlb;
+extern int __init pci_xen_swiotlb_detect(void);
+extern void __init pci_xen_swiotlb_init(void);
+#else
+#define xen_swiotlb 0
+static inline int __init pci_xen_swiotlb_detect(void) { return 0; }
+static inline void __init pci_xen_swiotlb_init(void) { }
+#endif
+
+#endif /* _ASM_X86_SWIOTLB_XEN_H */
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3bb4fc2..32af238 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_SMP)		+= smp.o
 obj-$(CONFIG_PARAVIRT_SPINLOCKS)+= spinlock.o
 obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
 
+obj-$(CONFIG_SWIOTLB_XEN)	+= pci-swiotlb-xen.o
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
new file mode 100644
index 0000000..fc3169d
--- /dev/null
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -0,0 +1,58 @@
+/* Glue code to lib/swiotlb-xen.c */
+
+#include <linux/dma-mapping.h>
+#include <linux/swiotlb-xen.h>
+
+#include <asm/xen/hypervisor.h>
+#include <xen/xen.h>
+
+int xen_swiotlb __read_mostly;
+
+static const struct dma_map_ops xen_swiotlb_dma_ops = {
+	.mapping_error = xen_swiotlb_dma_mapping_error,
+	.alloc_coherent = xen_swiotlb_alloc_coherent,
+	.free_coherent = xen_swiotlb_free_coherent,
+	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = xen_swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = xen_swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = xen_swiotlb_sync_sg_for_device,
+	.map_sg = xen_swiotlb_map_sg_attrs,
+	.unmap_sg = xen_swiotlb_unmap_sg_attrs,
+	.map_page = xen_swiotlb_map_page,
+	.unmap_page = xen_swiotlb_unmap_page,
+	.dma_supported = xen_swiotlb_dma_supported,
+};
+
+/*
+ * pci_xen_swiotlb_detect - set xen_swiotlb to 1 if necessary
+ *
+ * This returns non-zero if we are forced to use xen_swiotlb (by the boot
+ * option).
+ */
+int __init pci_xen_swiotlb_detect(void)
+{
+
+	/* If running as PV guest, either iommu=soft, or swiotlb=force will
+	 * activate this IOMMU. If running as PV privileged, activate it
+	 * irregardlesss.
+	 */
+	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
+	    (xen_pv_domain()))
+		xen_swiotlb = 1;
+
+	/* If we are running under Xen, we MUST disable the native SWIOTLB.
+	 * Don't worry about swiotlb_force flag activating the native, as
+	 * the 'swiotlb' flag is the only one turning it on. */
+	if (xen_pv_domain())
+		swiotlb = 0;
+
+	return xen_swiotlb;
+}
+
+void __init pci_xen_swiotlb_init(void)
+{
+	if (xen_swiotlb) {
+		xen_swiotlb_init(1);
+		dma_ops = &xen_swiotlb_dma_ops;
+	}
+}
-- 
1.7.0.1

