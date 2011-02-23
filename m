Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050Ab1BWCW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 21:22:29 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51792 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756022Ab1BWCW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 21:22:28 -0500
Subject: [PATCH v4 4/7] arm/dt: probe for platforms via the device tree
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Tue, 22 Feb 2011 19:22:24 -0700
Message-ID: <20110223022224.18318.22797.stgit@localhost6.localdomain6>
In-Reply-To: <20110223021524.18318.71902.stgit@localhost6.localdomain6>
References: <20110223021524.18318.71902.stgit@localhost6.localdomain6>
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
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/mach/arch.h |    2 +
 arch/arm/include/asm/prom.h      |   12 +++++
 arch/arm/include/asm/setup.h     |    2 +
 arch/arm/kernel/devtree.c        |  100 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c          |   12 +++--
 arch/arm/mm/init.c               |    2 +
 6 files changed, 127 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index ed9a10c..d7b12ad 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -22,6 +22,8 @@ struct machine_desc {
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
index 1cec82a..207f911 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -223,6 +223,8 @@ extern struct meminfo meminfo;
 
 extern int arm_add_memory(unsigned long start, unsigned long size);
 extern char cmd_line[COMMAND_LINE_SIZE];
+extern void early_print(const char *str, ...);
+extern void dump_machine_table(void);
 
 #endif  /*  __KERNEL__  */
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index 75e3df8..4dd725a 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -21,6 +21,8 @@
 
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/mach/arch.h>
+#include <asm/mach-types.h>
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
@@ -32,6 +34,33 @@ void * __init early_init_dt_alloc_memory_arch(u64 size, u64 align)
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
 /**
  * irq_create_of_mapping - Hook to resolve OF irq specifier into a Linux irq#
  *
@@ -45,3 +74,74 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	return intspec[0];
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
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
+	of_scan_flat_dt(early_init_dt_scan_chosen, NULL);
+	/* Initialize {size,address}-cells info */
+	of_scan_flat_dt(early_init_dt_scan_root, NULL);
+	/* Setup memory, calling early_init_dt_add_memory_arch */
+	of_scan_flat_dt(early_init_dt_scan_memory, NULL);
+	/* Save command line for /proc/cmdline  */
+	strlcpy(boot_command_line, cmd_line, COMMAND_LINE_SIZE);
+
+	/* Change machine number to match the mdesc we're using */
+	__machine_arch_type = mdesc->nr;
+
+	return mdesc_best;
+}
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index e420565..8734716 100644
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
 
@@ -873,7 +875,9 @@ void __init setup_arch(char **cmdline_p)
 	unwind_init();
 
 	setup_processor();
-	mdesc = setup_machine_tags(machine_arch_type);
+	mdesc = setup_machine_fdt(__atags_pointer);
+	if (!mdesc)
+		mdesc = setup_machine_tags(machine_arch_type);
 	machine_desc = mdesc;
 	machine_name = mdesc->name;
 
@@ -894,6 +898,8 @@ void __init setup_arch(char **cmdline_p)
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
+	unflatten_device_tree();
+
 #ifdef CONFIG_SMP
 	if (is_smp())
 		smp_init_cpus();
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index a2ba1d1..8e3387c 100644
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

