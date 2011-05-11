Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1EKUOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:14:25 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1EKUOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:14:22 -0400
Subject: [PATCH v6 4/5] arm/dt: probe for platforms via the device tree
To: linaro-dev@lists.linaro.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 May 2011 22:14:17 +0200
Message-ID: <20110511201417.21615.94279.stgit@localhost6.localdomain6>
In-Reply-To: <20110511201401.21615.38893.stgit@localhost6.localdomain6>
References: <20110511201401.21615.38893.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a dtb is passed to the kernel then the kernel needs to iterate
through compiled-in mdescs looking for one that matches and move the
dtb data to a safe location before it gets accidentally overwritten by
the kernel.

This patch creates a new function, setup_machine_fdt() which is
analogous to the setup_machine_atags() created in the previous patch.
It does all the early setup needed to use a device tree machine
description.

v5: - Print warning with neither dtb nor atags are passed to the kernel
    - Fix bug in setting of __machine_arch_type to the selected machine,
      not just the last machine in the list.
      Reported-by: Tixy <tixy@yxit.co.uk>
    - Copy command line directly into boot_command_line instead of cmd_line
v4: - Dump some output when a matching machine_desc cannot be found
v3: - Added processing of reserved list.
    - Backed out the v2 change that copied instead of reserved the
      dtb.  dtb is reserved again and the real problem was fixed by
      using alloc_bootmem_align() for early allocation of RAM for
      unflattening the tree.
    - Moved cmd_line and initrd changes to earlier patch to make series
      bisectable.
v2: Changed to save the dtb by copying into an allocated buffer.
    - Since the dtb will very likely be passed in the first 16k of ram
      where the interrupt vectors live, memblock_reserve() is
      insufficient to protect the dtb data.

[based on work originally written by Jeremy Kerr <jeremy.kerr@canonical.com>]
Tested-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/mach/arch.h |    2 +
 arch/arm/include/asm/prom.h      |   12 +++++
 arch/arm/include/asm/setup.h     |    2 +
 arch/arm/kernel/devtree.c        |   98 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c          |   23 +++++++--
 arch/arm/mm/init.c               |    2 +
 6 files changed, 135 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 4764e67..946f4d7 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -18,6 +18,8 @@ struct machine_desc {
 	unsigned int		nr;		/* architecture number	*/
 	const char		*name;		/* architecture name	*/
 	unsigned long		boot_params;	/* tagged list		*/
+	const char		**dt_compat;	/* array of device tree
+						 * 'compatible' strings	*/
 
 	unsigned int		nr_irqs;	/* number of IRQs */
 
diff --git a/arch/arm/include/asm/prom.h b/arch/arm/include/asm/prom.h
index 8f1037f..11b8708 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -21,5 +21,17 @@ static inline void irq_dispose_mapping(unsigned int virq)
 	return;
 }
 
+extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
+extern void arm_dt_memblock_reserve(void);
+
+#else /* CONFIG_OF */
+
+static inline struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
+{
+	return NULL;
+}
+
+static inline void arm_dt_memblock_reserve(void) { }
+
 #endif /* CONFIG_OF */
 #endif /* ASMARM_PROM_H */
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 93b4702..ee2ad8a 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -218,6 +218,8 @@ extern struct meminfo meminfo;
 #define bank_phys_size(bank)	(bank)->size
 
 extern int arm_add_memory(phys_addr_t start, unsigned long size);
+extern void early_print(const char *str, ...);
+extern void dump_machine_table(void);
 
 #endif  /*  __KERNEL__  */
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 75e3df8..a701e42 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -21,6 +21,8 @@
 
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/mach/arch.h>
+#include <asm/mach-types.h>
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
@@ -32,6 +34,102 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
 	return alloc_bootmem_align(size, align);
 }
 
+void __init arm_dt_memblock_reserve(void)
+{
+	u64 *reserve_map, base, size;
+
+	if (!initial_boot_params)
+		return;
+
+	/* Reserve the dtb region */
+	memblock_reserve(virt_to_phys(initial_boot_params),
+			 be32_to_cpu(initial_boot_params->totalsize));
+
+	/*
+	 * Process the reserve map.  This will probably overlap the initrd
+	 * and dtb locations which are already reserved, but overlaping
+	 * doesn't hurt anything
+	 */
+	reserve_map = ((void*)initial_boot_params) +
+			be32_to_cpu(initial_boot_params->off_mem_rsvmap);
+	while (1) {
+		base = be64_to_cpup(reserve_map++);
+		size = be64_to_cpup(reserve_map++);
+		if (!size)
+			break;
+		memblock_reserve(base, size);
+	}
+}
+
+/**
+ * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
+ * @dt_phys: physical address of dt blob
+ *
+ * If a dtb was passed to the kernel in r2, then use it to choose the
+ * correct machine_desc and to setup the system.
+ */
+struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
+{
+	struct boot_param_header *devtree;
+	struct machine_desc *mdesc, *mdesc_best = NULL;
+	unsigned int score, mdesc_score = ~1;
+	unsigned long dt_root;
+	const char *model;
+
+	devtree = phys_to_virt(dt_phys);
+
+	/* check device tree validity */
+	if (be32_to_cpu(devtree->magic) != OF_DT_HEADER)
+		return NULL;
+
+	/* Search the mdescs for the 'best' compatible value match */
+	initial_boot_params = devtree;
+	dt_root = of_get_flat_dt_root();
+	for_each_machine_desc(mdesc) {
+		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
+		if (score > 0 && score < mdesc_score) {
+			mdesc_best = mdesc;
+			mdesc_score = score;
+		}
+	}
+	if (!mdesc_best) {
+		const char *prop;
+		long size;
+
+		early_print("\nError: unrecognized/unsupported "
+			    "device tree compatible list:\n[ ");
+
+		prop = of_get_flat_dt_prop(dt_root, "compatible", &size);
+		while (size > 0) {
+			early_print("'%s' ", prop);
+			size -= strlen(prop) + 1;
+			prop += strlen(prop) + 1;
+		}
+		early_print("]\n\n");
+
+		dump_machine_table(); /* does not return */
+	}
+
+	model = of_get_flat_dt_prop(dt_root, "model", NULL);
+	if (!model)
+		model = of_get_flat_dt_prop(dt_root, "compatible", NULL);
+	if (!model)
+		model = "<unknown>";
+	pr_info("Machine: %s, model: %s\n", mdesc_best->name, model);
+
+	/* Retrieve various information from the /chosen node */
+	of_scan_flat_dt(early_init_dt_scan_chosen, boot_command_line);
+	/* Initialize {size,address}-cells info */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	/* Setup memory, calling early_init_dt_add_memory_arch */
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+
+	/* Change machine number to match the mdesc we're using */
+	__machine_arch_type = mdesc_best->nr;
+
+	return mdesc_best;
+}
+
 /**
  * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
  *
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 42c2f0c..05db25e 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -20,6 +20,7 @@
 #include <linux/screen_info.h>
 #include <linux/init.h>
 #include <linux/kexec.h>
+#include <linux/of_fdt.h>
 #include <linux/crash_dump.h>
 #include <linux/root_dev.h>
 #include <linux/cpu.h>
@@ -42,6 +43,7 @@
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
 
+#include <asm/prom.h>
 #include <asm/mach/arch.h>
 #include <asm/mach/irq.h>
 #include <asm/mach/time.h>
@@ -309,7 +311,7 @@ static void __init cacheid_init(void)
  */
 extern struct proc_info_list *lookup_processor_type(unsigned int);
 
-static void __init early_print(const char *str, ...)
+void __init early_print(const char *str, ...)
 {
 	extern void printascii(const char *);
 	char buf[256];
@@ -439,7 +441,7 @@ void cpu_init(void)
 	    : "r14");
 }
 
-static void __init dump_machine_table(void)
+void __init dump_machine_table(void)
 {
 	struct machine_desc *p;
 
@@ -837,8 +839,17 @@ static struct machine_desc * __init setup_machine_tags(unsigned int nr)
 	if (tags->hdr.tag != ATAG_CORE)
 		convert_to_tag_list(tags);
 #endif
-	if (tags->hdr.tag != ATAG_CORE)
+
+	if (tags->hdr.tag != ATAG_CORE) {
+#if defined(CONFIG_OF)
+		/*
+		 * If CONFIG_OF is set, then assume this is a reasonably
+		 * modern system that should pass boot parameters
+		 */
+		early_print("Warning: Neither atags nor dtb found\n");
+#endif
 		tags = (struct tag *)&init_tags;
+	}
 
 	if (mdesc->fixup)
 		mdesc->fixup(mdesc, tags, &from, &meminfo);
@@ -864,7 +875,9 @@ void __init setup_arch(char **cmdline_p)
 	unwind_init();
 
 	setup_processor();
-	mdesc = setup_machine_tags(machine_arch_type);
+	mdesc = setup_machine_fdt(__atags_pointer);
+	if (!mdesc)
+		mdesc = setup_machine_tags(machine_arch_type);
 	machine_desc = mdesc;
 	machine_name = mdesc->name;
 
@@ -887,6 +900,8 @@ void __init setup_arch(char **cmdline_p)
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
+	unflatten_device_tree();
+
 #ifdef CONFIG_SMP
 	if (is_smp())
 		smp_init_cpus();
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 26c4054..b265975 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -22,6 +22,7 @@
 #include <linux/sort.h>
 
 #include <asm/mach-types.h>
+#include <asm/prom.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/sizes.h>
@@ -322,6 +323,7 @@ void __init arm_memblock_init(struct meminfo *mi, struct machine_desc *mdesc)
 #endif
 
 	arm_mm_memblock_reserve();
+	arm_dt_memblock_reserve();
 
 	/* reserve any platform specific memblock areas */
 	if (mdesc->reserve)

