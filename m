Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab1D2PdR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 11:33:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54924 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab1D2P3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 11:29:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qX2Z7T/tcVEqJ4EH7kdi5jYnXbVAolyYdUW5MFvwWrPTJ+gavm89zlL+IGwvr+C4yh
         Zxn5tGGcAkvKui2VBDCc+rPAwMvWYvoCm6WLPurUlMJRhJlVghy+SuXuugbuTb3ki5ks
         fULHyMKvgXZLUtUjulMup1UGfnIKIKGj4Zmw8=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, yinghai@kernel.org, rientjes@google.com,
        tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 09/25] x86, NUMA: rename srat_64.c to srat.c
Date: Fri, 29 Apr 2011 17:28:28 +0200
Message-Id: <1304090924-8197-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1304090924-8197-1-git-send-email-tj@kernel.org>
References: <1304090924-8197-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename srat_64.c to srat.c.  This is to prepare for unification of
NUMA init paths between 32 and 64bit.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/mm/Makefile  |    5 +-
 arch/x86/mm/srat.c    |  184 +++++++++++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/srat_64.c |  184 -------------------------------------------------
 3 files changed, 188 insertions(+), 185 deletions(-)
 create mode 100644 arch/x86/mm/srat.c
 delete mode 100644 arch/x86/mm/srat_64.c

diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 3e608ed..37e7043 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -24,7 +24,10 @@ obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
 obj-$(CONFIG_AMD_NUMA)		+= amdtopology_64.o
-obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
+ifeq ($(CONFIG_ACPI_NUMA),y)
+obj-$(CONFIG_X86_64)		+= srat.o
+obj-$(CONFIG_X86_32)		+= srat_32.o
+endif
 obj-$(CONFIG_NUMA_EMU)		+= numa_emulation.o
 
 obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
new file mode 100644
index 0000000..9994d2c
--- /dev/null
+++ b/arch/x86/mm/srat.c
@@ -0,0 +1,184 @@
+/*
+ * ACPI 3.0 based NUMA setup
+ * Copyright 2004 Andi Kleen, SuSE Labs.
+ *
+ * Reads the ACPI SRAT table to figure out what memory belongs to which CPUs.
+ *
+ * Called from acpi_numa_init while reading the SRAT and SLIT tables.
+ * Assumes all memory regions belonging to a single proximity domain
+ * are in one chunk. Holes between them will be included in the node.
+ */
+
+#include <linux/kernel.h>
+#include <linux/acpi.h>
+#include <linux/mmzone.h>
+#include <linux/bitmap.h>
+#include <linux/module.h>
+#include <linux/topology.h>
+#include <linux/bootmem.h>
+#include <linux/memblock.h>
+#include <linux/mm.h>
+#include <asm/proto.h>
+#include <asm/numa.h>
+#include <asm/e820.h>
+#include <asm/apic.h>
+#include <asm/uv/uv.h>
+
+int acpi_numa __initdata;
+
+static __init int setup_node(int pxm)
+{
+	return acpi_map_pxm_to_node(pxm);
+}
+
+static __init void bad_srat(void)
+{
+	printk(KERN_ERR "SRAT: SRAT not used.\n");
+	acpi_numa = -1;
+}
+
+static __init inline int srat_disabled(void)
+{
+	return acpi_numa < 0;
+}
+
+/* Callback for SLIT parsing */
+void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
+{
+	int i, j;
+
+	for (i = 0; i < slit->locality_count; i++)
+		for (j = 0; j < slit->locality_count; j++)
+			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
+				slit->entry[slit->locality_count * i + j]);
+}
+
+/* Callback for Proximity Domain -> x2APIC mapping */
+void __init
+acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
+{
+	int pxm, node;
+	int apic_id;
+
+	if (srat_disabled())
+		return;
+	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
+		bad_srat();
+		return;
+	}
+	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
+		return;
+	pxm = pa->proximity_domain;
+	node = setup_node(pxm);
+	if (node < 0) {
+		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		bad_srat();
+		return;
+	}
+
+	apic_id = pa->apic_id;
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
+	set_apicid_to_node(apic_id, node);
+	node_set(node, numa_nodes_parsed);
+	acpi_numa = 1;
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
+	       pxm, apic_id, node);
+}
+
+/* Callback for Proximity Domain -> LAPIC mapping */
+void __init
+acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
+{
+	int pxm, node;
+	int apic_id;
+
+	if (srat_disabled())
+		return;
+	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
+		bad_srat();
+		return;
+	}
+	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
+		return;
+	pxm = pa->proximity_domain_lo;
+	node = setup_node(pxm);
+	if (node < 0) {
+		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
+		bad_srat();
+		return;
+	}
+
+	if (get_uv_system_type() >= UV_X2APIC)
+		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
+	else
+		apic_id = pa->apic_id;
+
+	if (apic_id >= MAX_LOCAL_APIC) {
+		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
+		return;
+	}
+
+	set_apicid_to_node(apic_id, node);
+	node_set(node, numa_nodes_parsed);
+	acpi_numa = 1;
+	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
+	       pxm, apic_id, node);
+}
+
+#ifdef CONFIG_MEMORY_HOTPLUG
+static inline int save_add_info(void) {return 1;}
+#else
+static inline int save_add_info(void) {return 0;}
+#endif
+
+/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
+void __init
+acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
+{
+	unsigned long start, end;
+	int node, pxm;
+
+	if (srat_disabled())
+		return;
+	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
+		bad_srat();
+		return;
+	}
+	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
+		return;
+
+	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
+		return;
+	start = ma->base_address;
+	end = start + ma->length;
+	pxm = ma->proximity_domain;
+	node = setup_node(pxm);
+	if (node < 0) {
+		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
+		bad_srat();
+		return;
+	}
+
+	if (numa_add_memblk(node, start, end) < 0) {
+		bad_srat();
+		return;
+	}
+
+	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
+	       start, end);
+}
+
+void __init acpi_numa_arch_fixup(void) {}
+
+int __init x86_acpi_numa_init(void)
+{
+	int ret;
+
+	ret = acpi_numa_init();
+	if (ret < 0)
+		return ret;
+	return srat_disabled() ? -EINVAL : 0;
+}
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
deleted file mode 100644
index 9994d2c..0000000
--- a/arch/x86/mm/srat_64.c
+++ /dev/null
@@ -1,184 +0,0 @@
-/*
- * ACPI 3.0 based NUMA setup
- * Copyright 2004 Andi Kleen, SuSE Labs.
- *
- * Reads the ACPI SRAT table to figure out what memory belongs to which CPUs.
- *
- * Called from acpi_numa_init while reading the SRAT and SLIT tables.
- * Assumes all memory regions belonging to a single proximity domain
- * are in one chunk. Holes between them will be included in the node.
- */
-
-#include <linux/kernel.h>
-#include <linux/acpi.h>
-#include <linux/mmzone.h>
-#include <linux/bitmap.h>
-#include <linux/module.h>
-#include <linux/topology.h>
-#include <linux/bootmem.h>
-#include <linux/memblock.h>
-#include <linux/mm.h>
-#include <asm/proto.h>
-#include <asm/numa.h>
-#include <asm/e820.h>
-#include <asm/apic.h>
-#include <asm/uv/uv.h>
-
-int acpi_numa __initdata;
-
-static __init int setup_node(int pxm)
-{
-	return acpi_map_pxm_to_node(pxm);
-}
-
-static __init void bad_srat(void)
-{
-	printk(KERN_ERR "SRAT: SRAT not used.\n");
-	acpi_numa = -1;
-}
-
-static __init inline int srat_disabled(void)
-{
-	return acpi_numa < 0;
-}
-
-/* Callback for SLIT parsing */
-void __init acpi_numa_slit_init(struct acpi_table_slit *slit)
-{
-	int i, j;
-
-	for (i = 0; i < slit->locality_count; i++)
-		for (j = 0; j < slit->locality_count; j++)
-			numa_set_distance(pxm_to_node(i), pxm_to_node(j),
-				slit->entry[slit->locality_count * i + j]);
-}
-
-/* Callback for Proximity Domain -> x2APIC mapping */
-void __init
-acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
-{
-	int pxm, node;
-	int apic_id;
-
-	if (srat_disabled())
-		return;
-	if (pa->header.length < sizeof(struct acpi_srat_x2apic_cpu_affinity)) {
-		bad_srat();
-		return;
-	}
-	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
-		return;
-	pxm = pa->proximity_domain;
-	node = setup_node(pxm);
-	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
-		bad_srat();
-		return;
-	}
-
-	apic_id = pa->apic_id;
-	if (apic_id >= MAX_LOCAL_APIC) {
-		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
-		return;
-	}
-	set_apicid_to_node(apic_id, node);
-	node_set(node, numa_nodes_parsed);
-	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
-	       pxm, apic_id, node);
-}
-
-/* Callback for Proximity Domain -> LAPIC mapping */
-void __init
-acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
-{
-	int pxm, node;
-	int apic_id;
-
-	if (srat_disabled())
-		return;
-	if (pa->header.length != sizeof(struct acpi_srat_cpu_affinity)) {
-		bad_srat();
-		return;
-	}
-	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
-		return;
-	pxm = pa->proximity_domain_lo;
-	node = setup_node(pxm);
-	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
-		bad_srat();
-		return;
-	}
-
-	if (get_uv_system_type() >= UV_X2APIC)
-		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
-	else
-		apic_id = pa->apic_id;
-
-	if (apic_id >= MAX_LOCAL_APIC) {
-		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
-		return;
-	}
-
-	set_apicid_to_node(apic_id, node);
-	node_set(node, numa_nodes_parsed);
-	acpi_numa = 1;
-	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
-	       pxm, apic_id, node);
-}
-
-#ifdef CONFIG_MEMORY_HOTPLUG
-static inline int save_add_info(void) {return 1;}
-#else
-static inline int save_add_info(void) {return 0;}
-#endif
-
-/* Callback for parsing of the Proximity Domain <-> Memory Area mappings */
-void __init
-acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
-{
-	unsigned long start, end;
-	int node, pxm;
-
-	if (srat_disabled())
-		return;
-	if (ma->header.length != sizeof(struct acpi_srat_mem_affinity)) {
-		bad_srat();
-		return;
-	}
-	if ((ma->flags & ACPI_SRAT_MEM_ENABLED) == 0)
-		return;
-
-	if ((ma->flags & ACPI_SRAT_MEM_HOT_PLUGGABLE) && !save_add_info())
-		return;
-	start = ma->base_address;
-	end = start + ma->length;
-	pxm = ma->proximity_domain;
-	node = setup_node(pxm);
-	if (node < 0) {
-		printk(KERN_ERR "SRAT: Too many proximity domains.\n");
-		bad_srat();
-		return;
-	}
-
-	if (numa_add_memblk(node, start, end) < 0) {
-		bad_srat();
-		return;
-	}
-
-	printk(KERN_INFO "SRAT: Node %u PXM %u %lx-%lx\n", node, pxm,
-	       start, end);
-}
-
-void __init acpi_numa_arch_fixup(void) {}
-
-int __init x86_acpi_numa_init(void)
-{
-	int ret;
-
-	ret = acpi_numa_init();
-	if (ret < 0)
-		return ret;
-	return srat_disabled() ? -EINVAL : 0;
-}
-- 
1.7.1

