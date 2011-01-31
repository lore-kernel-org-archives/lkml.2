Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756427Ab1AaVER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 16:04:17 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56870 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756414Ab1AaVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 16:04:14 -0500
Subject: [PATCH v2 4/6] arm/dt: probe for platforms via the device tree
To: nicolas.pitre@linaro.org, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        buytenh@wantstofly.org, Olof Johansson <olof@lixom.net>,
        john.linn@xilinx.com, linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 14:04:11 -0700
Message-ID: <20110131210410.15105.63595.stgit@localhost6.localdomain6>
In-Reply-To: <20110131203626.15105.64302.stgit@localhost6.localdomain6>
References: <20110131203626.15105.64302.stgit@localhost6.localdomain6>
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
description.  It also creates arm_unflatten_device_tree() which copies
the dtb into an allocated buffer and unflattens it into the live-tree
representation.

v2: Changed to save the dtb by copying into an allocated buffer.
    - Since the dtb will very likely be passed in the first 16k of ram
      where the interrupt vectors live, memblock_reserve() is
      insufficient to protect the dtb data.
[based on work originally written by Jeremy Kerr <jeremy.kerr@canonical.com>]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/mach/arch.h |    2 +
 arch/arm/include/asm/prom.h      |   11 +++++
 arch/arm/include/asm/setup.h     |    1 
 arch/arm/kernel/devtree.c        |   87 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c          |   10 +++-
 arch/arm/mm/init.c               |    8 +++
 6 files changed, 117 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 3a0893a..2ed24e7 100644
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
index 8f1037f..6ba62a8 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -21,5 +21,16 @@ static inline void irq_dispose_mapping(unsigned int virq)
 	return;
 }
 
+extern void arm_unflatten_device_tree(void);
+extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
+
+#else /* CONFIG_OF */
+
+static void arm_unflatten_device_tree(void) { }
+static inline struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF */
 #endif /* ASMARM_PROM_H */
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 06c4d0e..1cec82a 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -222,6 +222,7 @@ extern struct meminfo meminfo;
 #define bank_phys_size(bank)	(bank)->size
 
 extern int arm_add_memory(unsigned long start, unsigned long size);
+extern char cmd_line[COMMAND_LINE_SIZE];
 
 #endif  /*  __KERNEL__  */
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index ac48da2..07b75bb 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -21,6 +21,7 @@
 
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/mach/arch.h>
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
@@ -45,3 +46,89 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	return intspec[0];
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+extern struct machine_desc __arch_info_begin, __arch_info_end;
+
+/**
+ * arm_unflatten_device_tree - Copy dtb into a safe area and unflatten it.
+ *
+ * Copies the dtb out of initial memory and into an allocated block so that
+ * it doesn't get overwritten by the kernel and then unflatten it into the
+ * live tree representation.
+ */
+void __init arm_unflatten_device_tree(void)
+{
+	struct boot_param_header *devtree;
+	u32 dtb_size;
+
+	if (!initial_boot_params)
+		return;
+
+	/* Save the dtb to an allocated buffer */
+	dtb_size = be32_to_cpu(initial_boot_params->totalsize);
+	devtree = early_init_dt_alloc_memory_arch(dtb_size, SZ_4K);
+	if (!devtree) {
+		printk("Unable to allocate memory for device tree\n");
+		while(1);
+	}
+	pr_info("relocating device tree from 0x%p to 0x%p, length 0x%x\n",
+		initial_boot_params, devtree, dtb_size);
+	memmove(devtree, initial_boot_params, dtb_size);
+	initial_boot_params = devtree;
+
+	unflatten_device_tree();
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
+	struct boot_param_header *devtree = phys_to_virt(dt_phys);
+	struct machine_desc *mdesc, *mdesc_best = NULL;
+	unsigned int score, mdesc_score = ~1;
+	unsigned long dt_root;
+	const char *model;
+
+	/* check device tree validity */
+	if (!dt_phys || be32_to_cpu(devtree->magic) != OF_DT_HEADER)
+		return NULL;
+
+	/* Search the mdescs for the 'best' compatible value match */
+	initial_boot_params = devtree;
+
+	dt_root = of_get_flat_dt_root();
+	for (mdesc = &__arch_info_begin; mdesc < &__arch_info_end; mdesc++) {
+		score = of_flat_dt_match(dt_root, mdesc->dt_compat);
+		if (score > 0 && score < mdesc_score) {
+			mdesc_best = mdesc;
+			mdesc_score = score;
+		}
+	}
+	if (!mdesc_best) {
+		printk("Machine not supported, unable to continue.\n");
+		while (1);
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
+	return mdesc_best;
+}
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index cbc1836..68e0204 100644
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
@@ -125,7 +127,7 @@ EXPORT_SYMBOL(elf_platform);
 
 static const char *cpu_name;
 static const char *machine_name;
-static char __initdata cmd_line[COMMAND_LINE_SIZE];
+char cmd_line[COMMAND_LINE_SIZE];
 struct machine_desc *machine_desc __initdata;
 
 static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
@@ -838,7 +840,9 @@ void __init setup_arch(char **cmdline_p)
 	unwind_init();
 
 	setup_processor();
-	mdesc = setup_machine_tags(machine_arch_type);
+	mdesc = setup_machine_fdt(__atags_pointer);
+	if (!mdesc)
+		mdesc = setup_machine_tags(machine_arch_type);
 	machine_desc = mdesc;
 	machine_name = mdesc->name;
 
@@ -859,6 +863,8 @@ void __init setup_arch(char **cmdline_p)
 	paging_init(mdesc);
 	request_standard_resources(mdesc);
 
+	arm_unflatten_device_tree();
+
 #ifdef CONFIG_SMP
 	if (is_smp())
 		smp_init_cpus();
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 5164069..62ff2e8 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -71,6 +71,14 @@ static int __init parse_tag_initrd2(const struct tag *tag)
 
 __tagtable(ATAG_INITRD2, parse_tag_initrd2);
 
+#ifdef CONFIG_OF_FLATTREE
+void __init early_init_dt_setup_initrd_arch(unsigned long start, unsigned long end)
+{
+	phys_initrd_start = start;
+	phys_initrd_size = end - start + 1;
+}
+#endif /* CONFIG_OF_FLATTREE */
+
 /*
  * This keeps memory configuration data used by a couple memory
  * initialization functions, as well as show_mem() for the skipping

