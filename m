Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab2KUIkS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:40:18 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39163 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2KUIkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:40:16 -0500
From: Daniel J Blueman <daniel@numascale-asia.com>
To: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bjorn Helgaas <bhelgaas@google.com>, Steffen Persvold <sp@numascale.com>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH v2 RESEND] Add NumaChip remote PCI support
Date: Wed, 21 Nov 2012 16:39:56 +0800
Message-Id: <1353487196-10204-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add NumaChip-specific PCI access mechanism via MMCONFIG cycles, but
preventing access to AMD Northbridges which shouldn't respond.

v2: Use PCI_DEVFN in precomputed constant limit; drop unneeded includes

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/numachip/numachip.h |   20 +++++
 arch/x86/kernel/apic/apic_numachip.c     |    2 +
 arch/x86/pci/Makefile                    |    1 +
 arch/x86/pci/numachip.c                  |  134 ++++++++++++++++++++++++++++++
 4 files changed, 157 insertions(+)
 create mode 100644 arch/x86/include/asm/numachip/numachip.h
 create mode 100644 arch/x86/pci/numachip.c

diff --git a/arch/x86/include/asm/numachip/numachip.h b/arch/x86/include/asm/numachip/numachip.h
new file mode 100644
index 0000000..d35e71a
--- /dev/null
+++ b/arch/x86/include/asm/numachip/numachip.h
@@ -0,0 +1,20 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-specific header file
+ *
+ * Copyright (C) 2012 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ */
+
+#ifndef _ASM_X86_NUMACHIP_NUMACHIP_H
+#define _ASM_X86_NUMACHIP_NUMACHIP_H
+
+extern int __init pci_numachip_init(void);
+
+#endif /* _ASM_X86_NUMACHIP_NUMACHIP_H */
+
diff --git a/arch/x86/kernel/apic/apic_numachip.c b/arch/x86/kernel/apic/apic_numachip.c
index a65829a..9c2aa89 100644
--- a/arch/x86/kernel/apic/apic_numachip.c
+++ b/arch/x86/kernel/apic/apic_numachip.c
@@ -22,6 +22,7 @@
 #include <linux/hardirq.h>
 #include <linux/delay.h>
 
+#include <asm/numachip/numachip.h>
 #include <asm/numachip/numachip_csr.h>
 #include <asm/smp.h>
 #include <asm/apic.h>
@@ -179,6 +180,7 @@ static int __init numachip_system_init(void)
 		return 0;
 
 	x86_cpuinit.fixup_cpu_id = fixup_cpu_id;
+	x86_init.pci.arch_init = pci_numachip_init;
 
 	map_csrs();
 
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 3af5a1e..ee0af58 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_STA2X11)           += sta2x11-fixup.o
 obj-$(CONFIG_X86_VISWS)		+= visws.o
 
 obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
+obj-$(CONFIG_X86_NUMACHIP)	+= numachip.o
 
 obj-$(CONFIG_X86_INTEL_MID)	+= mrst.o
 
diff --git a/arch/x86/pci/numachip.c b/arch/x86/pci/numachip.c
new file mode 100644
index 0000000..3773e05
--- /dev/null
+++ b/arch/x86/pci/numachip.c
@@ -0,0 +1,129 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Numascale NumaConnect-specific PCI code
+ *
+ * Copyright (C) 2012 Numascale AS. All rights reserved.
+ *
+ * Send feedback to <support@numascale.com>
+ *
+ * PCI accessor functions derived from mmconfig_64.c
+ *
+ */
+
+#include <linux/pci.h>
+#include <asm/pci_x86.h>
+
+static u8 limit __read_mostly;
+
+static inline char __iomem *pci_dev_base(unsigned int seg, unsigned int bus, unsigned int devfn)
+{
+	struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
+
+	if (cfg && cfg->virt)
+		return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn << 12));
+	return NULL;
+}
+
+static int pci_mmcfg_read_numachip(unsigned int seg, unsigned int bus,
+			  unsigned int devfn, int reg, int len, u32 *value)
+{
+	char __iomem *addr;
+
+	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
+	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095))) {
+err:		*value = -1;
+		return -EINVAL;
+	}
+
+	/* Ensure AMD Northbridges don't decode reads to other devices */
+	if (unlikely(bus == 0 && devfn >= limit)) {
+		*value = -1;
+		return 0;
+	}
+
+	rcu_read_lock();
+	addr = pci_dev_base(seg, bus, devfn);
+	if (!addr) {
+		rcu_read_unlock();
+		goto err;
+	}
+
+	switch (len) {
+	case 1:
+		*value = mmio_config_readb(addr + reg);
+		break;
+	case 2:
+		*value = mmio_config_readw(addr + reg);
+		break;
+	case 4:
+		*value = mmio_config_readl(addr + reg);
+		break;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+static int pci_mmcfg_write_numachip(unsigned int seg, unsigned int bus,
+			   unsigned int devfn, int reg, int len, u32 value)
+{
+	char __iomem *addr;
+
+	/* Why do we have this when nobody checks it. How about a BUG()!? -AK */
+	if (unlikely((bus > 255) || (devfn > 255) || (reg > 4095)))
+		return -EINVAL;
+
+	/* Ensure AMD Northbridges don't decode writes to other devices */
+	if (unlikely(bus == 0 && devfn >= limit))
+		return 0;
+
+	rcu_read_lock();
+	addr = pci_dev_base(seg, bus, devfn);
+	if (!addr) {
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+
+	switch (len) {
+	case 1:
+		mmio_config_writeb(addr + reg, value);
+		break;
+	case 2:
+		mmio_config_writew(addr + reg, value);
+		break;
+	case 4:
+		mmio_config_writel(addr + reg, value);
+		break;
+	}
+	rcu_read_unlock();
+
+	return 0;
+}
+
+const struct pci_raw_ops pci_mmcfg_numachip = {
+	.read = pci_mmcfg_read_numachip,
+	.write = pci_mmcfg_write_numachip,
+};
+
+int __init pci_numachip_init(void)
+{
+	int ret = 0;
+	u32 val;
+
+	/* For remote I/O, restrict bus 0 access to the actual number of AMD
+	   Northbridges, which starts at device number 0x18 */
+	ret = raw_pci_read(0, 0, PCI_DEVFN(0x18, 0), 0x60, sizeof(val), &val);
+	if (ret)
+		goto out;
+
+	/* HyperTransport fabric size in bits 6:4 */
+	limit = PCI_DEVFN(0x18 + ((val >> 4) & 7) + 1, 0);
+
+	/* Use NumaChip PCI accessors for non-extended and extended access */
+	raw_pci_ops = raw_pci_ext_ops = &pci_mmcfg_numachip;
+out:
+	return ret;
+}
-- 
1.7.9.5

