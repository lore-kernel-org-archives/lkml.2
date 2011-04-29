Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab1D2P37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:29:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46165 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199Ab1D2P3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=uwzXW9lgw5o3KVxH6c82GZlHEuVmUy/5Bl6tLsTMPLscDm7778fTy480cm1pQdL9pC
         Pf7Js0ICN/99oV3jWMDKKLuu2FZqb+6FrjYWgnNR6853Ko+62y7BsT2zHvHfLe1xgjN1
         G/N3wUW/4Ej7xq2daXkR4IBwxMzmKz5JeCa8Y=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 23/25] x86, NUMA: Rename amdtopology_64.c to amdtopology.c
Date: Fri, 29 Apr 2011 17:28:42 +0200
Message-Id: <1304090924-8197-24-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

amdtopology is going to be used by 32bit too drop _64 suffix.  This is
pure rename.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/Makefile         |    2 +-
 arch/x86/mm/amdtopology.c    |  196 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/amdtopology_64.c |  196 ------------------------------------------
 3 files changed, 197 insertions(+), 197 deletions(-)
 create mode 100644 arch/x86/mm/amdtopology.c
 delete mode 100644 arch/x86/mm/amdtopology_64.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 62997be..3d11327 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -23,7 +23,7 @@ mmiotrace-y			:= kmmio.o pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
-obj-$(CONFIG_AMD_NUMA)		+= amdtopology_64.o
+obj-$(CONFIG_AMD_NUMA)		+= amdtopology.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat.o
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
diff --git a/arch/x86/mm/amdtopology.c b/arch/x86/mm/amdtopology.c
new file mode 100644
index 0000000..0919c26
--- /dev/null
+++ b/arch/x86/mm/amdtopology.c
@@ -0,0 +1,196 @@
+/*
+ * AMD NUMA support.
+ * Discover the memory map and associated nodes.
+ *
+ * This version reads it directly from the AMD northbridge.
+ *
+ * Copyright 2002,2003 Andi Kleen, SuSE Labs.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/nodemask.h>
+#include <linux/memblock.h>
+
+#include <asm/io.h>
+#include <linux/pci_ids.h>
+#include <linux/acpi.h>
+#include <asm/types.h>
+#include <asm/mmzone.h>
+#include <asm/proto.h>
+#include <asm/e820.h>
+#include <asm/pci-direct.h>
+#include <asm/numa.h>
+#include <asm/mpspec.h>
+#include <asm/apic.h>
+#include <asm/amd_nb.h>
+
+static unsigned char __initdata nodeids[8];
+
+static __init int find_northbridge(void)
+{
+	int num;
+
+	for (num = 0; num < 32; num++) {
+		u32 header;
+
+		header = read_pci_config(0, num, 0, 0x00);
+		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)))
+			continue;
+
+		header = read_pci_config(0, num, 1, 0x00);
+		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)))
+			continue;
+		return num;
+	}
+
+	return -ENOENT;
+}
+
+static __init void early_get_boot_cpu_id(void)
+{
+	/*
+	 * need to get the APIC ID of the BSP so can use that to
+	 * create apicid_to_node in amd_scan_nodes()
+	 */
+#ifdef CONFIG_X86_MPPARSE
+	/*
+	 * get boot-time SMP configuration:
+	 */
+	if (smp_found_config)
+		early_get_smp_config();
+#endif
+}
+
+int __init amd_numa_init(void)
+{
+	unsigned long start = PFN_PHYS(0);
+	unsigned long end = PFN_PHYS(max_pfn);
+	unsigned numnodes;
+	unsigned long prevbase;
+	int i, j, nb;
+	u32 nodeid, reg;
+	unsigned int bits, cores, apicid_base;
+
+	if (!early_pci_allowed())
+		return -EINVAL;
+
+	nb = find_northbridge();
+	if (nb < 0)
+		return nb;
+
+	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
+
+	reg = read_pci_config(0, nb, 0, 0x60);
+	numnodes = ((reg >> 4) & 0xF) + 1;
+	if (numnodes <= 1)
+		return -ENOENT;
+
+	pr_info("Number of physical nodes %d\n", numnodes);
+
+	prevbase = 0;
+	for (i = 0; i < 8; i++) {
+		unsigned long base, limit;
+
+		base = read_pci_config(0, nb, 1, 0x40 + i*8);
+		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
+
+		nodeids[i] = nodeid = limit & 7;
+		if ((base & 3) == 0) {
+			if (i < numnodes)
+				pr_info("Skipping disabled node %d\n", i);
+			continue;
+		}
+		if (nodeid >= numnodes) {
+			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+				base, limit);
+			continue;
+		}
+
+		if (!limit) {
+			pr_info("Skipping node entry %d (base %lx)\n",
+				i, base);
+			continue;
+		}
+		if ((base >> 8) & 3 || (limit >> 8) & 3) {
+			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
+			return -EINVAL;
+		}
+		if (node_isset(nodeid, numa_nodes_parsed)) {
+			pr_info("Node %d already present, skipping\n",
+				nodeid);
+			continue;
+		}
+
+		limit >>= 16;
+		limit <<= 24;
+		limit |= (1<<24)-1;
+		limit++;
+
+		if (limit > end)
+			limit = end;
+		if (limit <= base)
+			continue;
+
+		base >>= 16;
+		base <<= 24;
+
+		if (base < start)
+			base = start;
+		if (limit > end)
+			limit = end;
+		if (limit == base) {
+			pr_err("Empty node %d\n", nodeid);
+			continue;
+		}
+		if (limit < base) {
+			pr_err("Node %d bogus settings %lx-%lx.\n",
+			       nodeid, base, limit);
+			continue;
+		}
+
+		/* Could sort here, but pun for now. Should not happen anyroads. */
+		if (prevbase > base) {
+			pr_err("Node map not sorted %lx,%lx\n",
+			       prevbase, base);
+			return -EINVAL;
+		}
+
+		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+			nodeid, base, limit);
+
+		prevbase = base;
+		numa_add_memblk(nodeid, base, limit);
+		node_set(nodeid, numa_nodes_parsed);
+	}
+
+	if (!nodes_weight(numa_nodes_parsed))
+		return -ENOENT;
+
+	/*
+	 * We seem to have valid NUMA configuration.  Map apicids to nodes
+	 * using the coreid bits from early_identify_cpu.
+	 */
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = 1 << bits;
+	apicid_base = 0;
+
+	/* get the APIC ID of the BSP early for systems with apicid lifting */
+	early_get_boot_cpu_id();
+	if (boot_cpu_physical_apicid > 0) {
+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
+		apicid_base = boot_cpu_physical_apicid;
+	}
+
+	for_each_node_mask(i, numa_nodes_parsed)
+		for (j = apicid_base; j < cores + apicid_base; j++)
+			set_apicid_to_node((i << bits) + j, i);
+
+	return 0;
+}
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
deleted file mode 100644
index 0919c26..0000000
--- a/arch/x86/mm/amdtopology_64.c
+++ /dev/null
@@ -1,196 +0,0 @@
-/*
- * AMD NUMA support.
- * Discover the memory map and associated nodes.
- *
- * This version reads it directly from the AMD northbridge.
- *
- * Copyright 2002,2003 Andi Kleen, SuSE Labs.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/nodemask.h>
-#include <linux/memblock.h>
-
-#include <asm/io.h>
-#include <linux/pci_ids.h>
-#include <linux/acpi.h>
-#include <asm/types.h>
-#include <asm/mmzone.h>
-#include <asm/proto.h>
-#include <asm/e820.h>
-#include <asm/pci-direct.h>
-#include <asm/numa.h>
-#include <asm/mpspec.h>
-#include <asm/apic.h>
-#include <asm/amd_nb.h>
-
-static unsigned char __initdata nodeids[8];
-
-static __init int find_northbridge(void)
-{
-	int num;
-
-	for (num = 0; num < 32; num++) {
-		u32 header;
-
-		header = read_pci_config(0, num, 0, 0x00);
-		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)))
-			continue;
-
-		header = read_pci_config(0, num, 1, 0x00);
-		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)))
-			continue;
-		return num;
-	}
-
-	return -ENOENT;
-}
-
-static __init void early_get_boot_cpu_id(void)
-{
-	/*
-	 * need to get the APIC ID of the BSP so can use that to
-	 * create apicid_to_node in amd_scan_nodes()
-	 */
-#ifdef CONFIG_X86_MPPARSE
-	/*
-	 * get boot-time SMP configuration:
-	 */
-	if (smp_found_config)
-		early_get_smp_config();
-#endif
-}
-
-int __init amd_numa_init(void)
-{
-	unsigned long start = PFN_PHYS(0);
-	unsigned long end = PFN_PHYS(max_pfn);
-	unsigned numnodes;
-	unsigned long prevbase;
-	int i, j, nb;
-	u32 nodeid, reg;
-	unsigned int bits, cores, apicid_base;
-
-	if (!early_pci_allowed())
-		return -EINVAL;
-
-	nb = find_northbridge();
-	if (nb < 0)
-		return nb;
-
-	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
-
-	reg = read_pci_config(0, nb, 0, 0x60);
-	numnodes = ((reg >> 4) & 0xF) + 1;
-	if (numnodes <= 1)
-		return -ENOENT;
-
-	pr_info("Number of physical nodes %d\n", numnodes);
-
-	prevbase = 0;
-	for (i = 0; i < 8; i++) {
-		unsigned long base, limit;
-
-		base = read_pci_config(0, nb, 1, 0x40 + i*8);
-		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
-
-		nodeids[i] = nodeid = limit & 7;
-		if ((base & 3) == 0) {
-			if (i < numnodes)
-				pr_info("Skipping disabled node %d\n", i);
-			continue;
-		}
-		if (nodeid >= numnodes) {
-			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
-				base, limit);
-			continue;
-		}
-
-		if (!limit) {
-			pr_info("Skipping node entry %d (base %lx)\n",
-				i, base);
-			continue;
-		}
-		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			pr_err("Node %d using interleaving mode %lx/%lx\n",
-			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
-			return -EINVAL;
-		}
-		if (node_isset(nodeid, numa_nodes_parsed)) {
-			pr_info("Node %d already present, skipping\n",
-				nodeid);
-			continue;
-		}
-
-		limit >>= 16;
-		limit <<= 24;
-		limit |= (1<<24)-1;
-		limit++;
-
-		if (limit > end)
-			limit = end;
-		if (limit <= base)
-			continue;
-
-		base >>= 16;
-		base <<= 24;
-
-		if (base < start)
-			base = start;
-		if (limit > end)
-			limit = end;
-		if (limit == base) {
-			pr_err("Empty node %d\n", nodeid);
-			continue;
-		}
-		if (limit < base) {
-			pr_err("Node %d bogus settings %lx-%lx.\n",
-			       nodeid, base, limit);
-			continue;
-		}
-
-		/* Could sort here, but pun for now. Should not happen anyroads. */
-		if (prevbase > base) {
-			pr_err("Node map not sorted %lx,%lx\n",
-			       prevbase, base);
-			return -EINVAL;
-		}
-
-		pr_info("Node %d MemBase %016lx Limit %016lx\n",
-			nodeid, base, limit);
-
-		prevbase = base;
-		numa_add_memblk(nodeid, base, limit);
-		node_set(nodeid, numa_nodes_parsed);
-	}
-
-	if (!nodes_weight(numa_nodes_parsed))
-		return -ENOENT;
-
-	/*
-	 * We seem to have valid NUMA configuration.  Map apicids to nodes
-	 * using the coreid bits from early_identify_cpu.
-	 */
-	bits = boot_cpu_data.x86_coreid_bits;
-	cores = 1 << bits;
-	apicid_base = 0;
-
-	/* get the APIC ID of the BSP early for systems with apicid lifting */
-	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0) {
-		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
-		apicid_base = boot_cpu_physical_apicid;
-	}
-
-	for_each_node_mask(i, numa_nodes_parsed)
-		for (j = apicid_base; j < cores + apicid_base; j++)
-			set_apicid_to_node((i << bits) + j, i);
-
-	return 0;
-}
-- 
1.7.1

