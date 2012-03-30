Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761234Ab2C3Sqa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 14:46:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:44484 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761078Ab2C3SqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 14:46:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="135792291"
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 02/10] iommu/vt-d: Make intr-remapping initialization generic
Date: Fri, 30 Mar 2012 11:47:00 -0700
Message-Id: <1333133228-3134-3-git-send-email-suresh.b.siddha@intel.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
References: <1333133228-3134-1-git-send-email-suresh.b.siddha@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

This patch introduces irq_remap_ops to hold implementation
specific function pointer to handle interrupt remapping. As
the first part the initialization functions for VT-d are
converted to these ops.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 arch/ia64/include/asm/intr_remapping.h |    4 ++
 arch/x86/include/asm/intr_remapping.h  |   45 +++++++++++++++++++
 arch/x86/kernel/apic/apic.c            |   14 ++++--
 arch/x86/kernel/apic/io_apic.c         |    1 +
 drivers/iommu/Makefile                 |    2 +-
 drivers/iommu/dmar.c                   |    1 +
 drivers/iommu/intel-iommu.c            |    1 +
 drivers/iommu/intel_intr_remapping.c   |   52 +++++-----------------
 drivers/iommu/intr_remapping.c         |   76 ++++++++++++++++++++++++++++++++
 drivers/iommu/intr_remapping.h         |   46 +++++++++++++++++++
 include/linux/dmar.h                   |    3 -
 11 files changed, 196 insertions(+), 49 deletions(-)
 create mode 100644 arch/ia64/include/asm/intr_remapping.h
 create mode 100644 arch/x86/include/asm/intr_remapping.h
 create mode 100644 drivers/iommu/intr_remapping.c
 create mode 100644 drivers/iommu/intr_remapping.h

diff --git a/arch/ia64/include/asm/intr_remapping.h b/arch/ia64/include/asm/intr_remapping.h
new file mode 100644
index 0000000..095aa0d
--- /dev/null
+++ b/arch/ia64/include/asm/intr_remapping.h
@@ -0,0 +1,4 @@
+#ifndef __IA64_INTR_REMAPPING_H
+#define __IA64_INTR_REMAPPING_H
+#define intr_remapping_enabled 0
+#endif
diff --git a/arch/x86/include/asm/intr_remapping.h b/arch/x86/include/asm/intr_remapping.h
new file mode 100644
index 0000000..207c605
--- /dev/null
+++ b/arch/x86/include/asm/intr_remapping.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2012 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * This header file contains the interface of the interrupt remapping code to
+ * the x86 interrupt management code.
+ */
+
+#ifndef __X86_INTR_REMAPPING_H
+#define __X86_INTR_REMAPPING_H
+
+#ifdef CONFIG_IRQ_REMAP
+
+extern int intr_remapping_enabled;
+
+extern void setup_intr_remapping(void);
+extern int intr_remapping_supported(void);
+extern int intr_hardware_init(void);
+extern int intr_hardware_enable(void);
+
+#else  /* CONFIG_IRQ_REMAP */
+
+#define intr_remapping_enabled	0
+
+static inline void setup_intr_remapping(void) { }
+static inline int intr_remapping_supported(void) { return 0; }
+static inline int intr_hardware_init(void) { return -ENODEV; }
+static inline int intr_hardware_enable(void) { return -ENODEV; }
+
+#endif /* CONFIG_IRQ_REMAP */
+
+#endif /* __X86_INTR_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 11544d8..7fbeaa7 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -35,6 +35,7 @@
 #include <linux/smp.h>
 #include <linux/mm.h>
 
+#include <asm/intr_remapping.h>
 #include <asm/perf_event.h>
 #include <asm/x86_init.h>
 #include <asm/pgalloc.h>
@@ -1528,7 +1529,7 @@ int __init enable_IR(void)
 		return -1;
 	}
 
-	return enable_intr_remapping();
+	return intr_hardware_enable();
 #endif
 	return -1;
 }
@@ -1537,10 +1538,13 @@ void __init enable_IR_x2apic(void)
 {
 	unsigned long flags;
 	int ret, x2apic_enabled = 0;
-	int dmar_table_init_ret;
+	int hardware_init_ret;
 
-	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret && !x2apic_supported())
+	/* Make sure irq_remap_ops are initialized */
+	setup_intr_remapping();
+
+	hardware_init_ret = intr_hardware_init();
+	if (hardware_init_ret && !x2apic_supported())
 		return;
 
 	ret = save_ioapic_entries();
@@ -1556,7 +1560,7 @@ void __init enable_IR_x2apic(void)
 	if (x2apic_preenabled && nox2apic)
 		disable_x2apic();
 
-	if (dmar_table_init_ret)
+	if (hardware_init_ret)
 		ret = -1;
 	else
 		ret = enable_IR();
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e88300d..1151fdc 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -57,6 +57,7 @@
 #include <asm/msidef.h>
 #include <asm/hypertransport.h>
 #include <asm/setup.h>
+#include <asm/intr_remapping.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
index 1533ebf..823e1cf 100644
--- a/drivers/iommu/Makefile
+++ b/drivers/iommu/Makefile
@@ -4,7 +4,7 @@ obj-$(CONFIG_AMD_IOMMU) += amd_iommu.o amd_iommu_init.o
 obj-$(CONFIG_AMD_IOMMU_V2) += amd_iommu_v2.o
 obj-$(CONFIG_DMAR_TABLE) += dmar.o
 obj-$(CONFIG_INTEL_IOMMU) += iova.o intel-iommu.o
-obj-$(CONFIG_IRQ_REMAP) += intel_intr_remapping.o
+obj-$(CONFIG_IRQ_REMAP) += intel_intr_remapping.o intr_remapping.o
 obj-$(CONFIG_OMAP_IOMMU) += omap-iommu.o
 obj-$(CONFIG_OMAP_IOVMM) += omap-iovmm.o
 obj-$(CONFIG_OMAP_IOMMU_DEBUG) += omap-iommu-debug.o
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 35c1e17..647e366 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -36,6 +36,7 @@
 #include <linux/tboot.h>
 #include <linux/dmi.h>
 #include <linux/slab.h>
+#include <asm/intr_remapping.h>
 #include <asm/iommu_table.h>
 
 #define PREFIX "DMAR: "
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 132f93b..86b69cf 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -42,6 +42,7 @@
 #include <linux/dmi.h>
 #include <linux/pci-ats.h>
 #include <linux/memblock.h>
+#include <asm/intr_remapping.h>
 #include <asm/cacheflush.h>
 #include <asm/iommu.h>
 
diff --git a/drivers/iommu/intel_intr_remapping.c b/drivers/iommu/intel_intr_remapping.c
index 212fff0..9c742fb 100644
--- a/drivers/iommu/intel_intr_remapping.c
+++ b/drivers/iommu/intel_intr_remapping.c
@@ -11,8 +11,11 @@
 #include <asm/cpu.h>
 #include <linux/intel-iommu.h>
 #include <acpi/acpi.h>
+#include <asm/intr_remapping.h>
 #include <asm/pci-direct.h>
 
+#include "intr_remapping.h"
+
 struct ioapic_scope {
 	struct intel_iommu *iommu;
 	unsigned int id;
@@ -32,42 +35,6 @@ struct hpet_scope {
 static struct ioapic_scope ir_ioapic[MAX_IO_APICS];
 static struct hpet_scope ir_hpet[MAX_HPET_TBS];
 static int ir_ioapic_num, ir_hpet_num;
-int intr_remapping_enabled;
-
-static int disable_intremap;
-static int disable_sourceid_checking;
-static int no_x2apic_optout;
-
-static __init int setup_nointremap(char *str)
-{
-	disable_intremap = 1;
-	return 0;
-}
-early_param("nointremap", setup_nointremap);
-
-static __init int setup_intremap(char *str)
-{
-	if (!str)
-		return -EINVAL;
-
-	while (*str) {
-		if (!strncmp(str, "on", 2))
-			disable_intremap = 0;
-		else if (!strncmp(str, "off", 3))
-			disable_intremap = 1;
-		else if (!strncmp(str, "nosid", 5))
-			disable_sourceid_checking = 1;
-		else if (!strncmp(str, "no_x2apic_optout", 16))
-			no_x2apic_optout = 1;
-
-		str += strcspn(str, ",");
-		while (*str == ',')
-			str++;
-	}
-
-	return 0;
-}
-early_param("intremap", setup_intremap);
 
 static DEFINE_RAW_SPINLOCK(irq_2_ir_lock);
 
@@ -465,7 +432,7 @@ static void iommu_set_intr_remapping(struct intel_iommu *iommu, int mode)
 }
 
 
-static int setup_intr_remapping(struct intel_iommu *iommu, int mode)
+static int intel_setup_intr_remapping(struct intel_iommu *iommu, int mode)
 {
 	struct ir_table *ir_table;
 	struct page *pages;
@@ -534,7 +501,7 @@ static int __init dmar_x2apic_optout(void)
 	return dmar->flags & DMAR_X2APIC_OPT_OUT;
 }
 
-int __init intr_remapping_supported(void)
+static int __init intel_intr_remapping_supported(void)
 {
 	struct dmar_drhd_unit *drhd;
 
@@ -554,7 +521,7 @@ int __init intr_remapping_supported(void)
 	return 1;
 }
 
-int __init enable_intr_remapping(void)
+static int __init intel_enable_intr_remapping(void)
 {
 	struct dmar_drhd_unit *drhd;
 	int setup = 0;
@@ -638,7 +605,7 @@ int __init enable_intr_remapping(void)
 		if (!ecap_ir_support(iommu->ecap))
 			continue;
 
-		if (setup_intr_remapping(iommu, eim))
+		if (intel_setup_intr_remapping(iommu, eim))
 			goto error;
 
 		setup = 1;
@@ -847,3 +814,8 @@ error:
 	return -1;
 }
 
+struct irq_remap_ops intel_irq_remap_ops = {
+	.supported		= intel_intr_remapping_supported,
+	.hardware_init		= dmar_table_init,
+	.hardware_enable	= intel_enable_intr_remapping,
+};
diff --git a/drivers/iommu/intr_remapping.c b/drivers/iommu/intr_remapping.c
new file mode 100644
index 0000000..670c69a
--- /dev/null
+++ b/drivers/iommu/intr_remapping.c
@@ -0,0 +1,76 @@
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+
+#include "intr_remapping.h"
+
+int intr_remapping_enabled;
+
+int disable_intremap;
+int disable_sourceid_checking;
+int no_x2apic_optout;
+
+static struct irq_remap_ops *remap_ops;
+
+static __init int setup_nointremap(char *str)
+{
+	disable_intremap = 1;
+	return 0;
+}
+early_param("nointremap", setup_nointremap);
+
+static __init int setup_intremap(char *str)
+{
+	if (!str)
+		return -EINVAL;
+
+	while (*str) {
+		if (!strncmp(str, "on", 2))
+			disable_intremap = 0;
+		else if (!strncmp(str, "off", 3))
+			disable_intremap = 1;
+		else if (!strncmp(str, "nosid", 5))
+			disable_sourceid_checking = 1;
+		else if (!strncmp(str, "no_x2apic_optout", 16))
+			no_x2apic_optout = 1;
+
+		str += strcspn(str, ",");
+		while (*str == ',')
+			str++;
+	}
+
+	return 0;
+}
+early_param("intremap", setup_intremap);
+
+void __init setup_intr_remapping(void)
+{
+	remap_ops = &intel_irq_remap_ops;
+}
+
+int intr_remapping_supported(void)
+{
+	if (disable_intremap)
+		return 0;
+
+	if (!remap_ops || !remap_ops->supported)
+		return 0;
+
+	return remap_ops->supported();
+}
+
+int __init intr_hardware_init(void)
+{
+	if (!remap_ops || !remap_ops->hardware_init)
+		return -ENODEV;
+
+	return remap_ops->hardware_init();
+}
+
+int __init intr_hardware_enable(void)
+{
+	if (!remap_ops || !remap_ops->hardware_enable)
+		return -ENODEV;
+
+	return remap_ops->hardware_enable();
+}
diff --git a/drivers/iommu/intr_remapping.h b/drivers/iommu/intr_remapping.h
new file mode 100644
index 0000000..d6df732
--- /dev/null
+++ b/drivers/iommu/intr_remapping.h
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2012 Advanced Micro Devices, Inc.
+ * Author: Joerg Roedel <joerg.roedel@amd.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
+ *
+ * This header file contains stuff that is shared between different interrupt
+ * remapping drivers but with no need to be visible outside of the IOMMU layer.
+ */
+
+#ifndef __INTR_REMAPPING_H
+#define __INTR_REMAPPING_H
+
+#ifdef CONFIG_IRQ_REMAP
+
+extern int disable_intremap;
+extern int disable_sourceid_checking;
+extern int no_x2apic_optout;
+
+struct irq_remap_ops {
+	/* Check whether Interrupt Remapping is supported */
+	int (*supported)(void);
+
+	/* Initializes hardware and makes it ready for remapping interrupts */
+	int  (*hardware_init)(void);
+
+	/* Enables the remapping hardware */
+	int  (*hardware_enable)(void);
+};
+
+extern struct irq_remap_ops intel_irq_remap_ops;
+
+#endif /* CONFIG_IRQ_REMAP */
+
+#endif /* __INTR_REMAPPING_H */
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 731a609..6d66c9c 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -115,9 +115,6 @@ struct irte {
 };
 
 #ifdef CONFIG_IRQ_REMAP
-extern int intr_remapping_enabled;
-extern int intr_remapping_supported(void);
-extern int enable_intr_remapping(void);
 extern void disable_intr_remapping(void);
 extern int reenable_intr_remapping(int);
 
-- 
1.7.6.5

