Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1ARU3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:29:32 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:53031 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab1ARU33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:29:29 -0500
Subject: [PATCH 5/8] arm/dt: probe for platforms via the device tree
To: linux-arm-kernel@lists.infradead.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        John Linn <John.Linn@xilinx.com>,
        Lennert Buijtenhek <buytenh@wantstofly.org>
Date: Tue, 18 Jan 2011 13:29:23 -0700
Message-ID: <20110118202922.13011.84005.stgit@localhost6.localdomain6>
In-Reply-To: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
References: <20110118195933.13011.56098.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a macro to define a device-tree-probable machine
(DT_MACHINE_START/DT_MACHINE_END), and iterate through compiled-in
mdescs once we have the DT.  This patch creates a new function,
setup_machine_fdt() which is analogous to the setup_machine_atags()
created in the previous patch.  It does all the early setup needed to
use a device tree machine description.

[based on work originally written by Jeremy Kerr <jeremy.kerr@canonical.com>]
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/include/asm/mach/arch.h |    2 +
 arch/arm/include/asm/prom.h      |    9 ++++++
 arch/arm/include/asm/setup.h     |    1 +
 arch/arm/kernel/devtree.c        |   60 ++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/setup.c          |   10 +++++-
 5 files changed, 80 insertions(+), 2 deletions(-)

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
index 8f1037f..b692f41 100644
--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -21,5 +21,14 @@ static inline void irq_dispose_mapping(unsigned int virq)
 	return;
 }
 
+extern struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
+
+#else /* CONFIG_OF */
+
+static inline struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_OF */
 #endif /* ASMARM_PROM_H */
diff --git a/arch/arm/include/asm/setup.h b/arch/arm/include/asm/setup.h
index 0809235..b46d320 100644
--- a/arch/arm/include/asm/setup.h
+++ b/arch/arm/include/asm/setup.h
@@ -223,6 +223,7 @@ extern struct meminfo meminfo;
 
 extern void arm_reserve_devtree(unsigned long start, unsigned long size);
 extern int arm_add_memory(unsigned long start, unsigned long size);
+extern char cmd_line[COMMAND_LINE_SIZE];
 
 #endif  /*  __KERNEL__  */
 
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index ac48da2..f7788be 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -21,6 +21,7 @@
 
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/mach/arch.h>
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
@@ -45,3 +46,62 @@ unsigned int irq_create_of_mapping(struct device_node *controller,
 	return intspec[0];
 }
 EXPORT_SYMBOL_GPL(irq_create_of_mapping);
+
+extern struct machine_desc __arch_info_begin, __arch_info_end;
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
+	arm_reserve_devtree(dt_phys, be32_to_cpu(devtree->totalsize));
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
index cbc1836..3db0cbb 100644
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
 
+	unflatten_device_tree();
+
 #ifdef CONFIG_SMP
 	if (is_smp())
 		smp_init_cpus();

