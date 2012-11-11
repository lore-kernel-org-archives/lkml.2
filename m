Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab2KKMum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:50:42 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56079 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab2KKMuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:50:37 -0500
From: Jonas Gorski <jonas.gorski@gmail.com>
To: linux-mips@linux-mips.org
Cc: Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RFC] MIPS: BCM63XX: add support for loading DTB
Date: Sun, 11 Nov 2012 13:50:35 +0100
Message-Id: <1352638249-29298-2-git-send-email-jonas.gorski@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
References: <1352638249-29298-1-git-send-email-jonas.gorski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for loading DTBs embedded into the kernel. Iterate through
all embedded ones until a match is found and use that.

Use the NVRAM provided board name for constructing the compatible
property for selecting the appropriate in-kernel DTB.

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 arch/mips/Kconfig              |    1 +
 arch/mips/bcm63xx/Kconfig      |    2 +
 arch/mips/bcm63xx/Makefile     |    1 +
 arch/mips/bcm63xx/dts/Kconfig  |    3 +
 arch/mips/bcm63xx/dts/Makefile |    2 +
 arch/mips/bcm63xx/setup.c      |   80 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 89 insertions(+), 0 deletions(-)
 create mode 100644 arch/mips/bcm63xx/dts/Kconfig
 create mode 100644 arch/mips/bcm63xx/dts/Makefile

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 9934a46..168b0fc 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -132,6 +132,7 @@ config BCM63XX
 	select SWAP_IO_SPACE
 	select ARCH_REQUIRE_GPIOLIB
 	select HAVE_CLK
+	select USE_OF
 	help
 	 Support for BCM63XX based boards
 
diff --git a/arch/mips/bcm63xx/Kconfig b/arch/mips/bcm63xx/Kconfig
index d03e879..03d693b 100644
--- a/arch/mips/bcm63xx/Kconfig
+++ b/arch/mips/bcm63xx/Kconfig
@@ -31,3 +31,5 @@ config BCM63XX_CPU_6368
 endmenu
 
 source "arch/mips/bcm63xx/boards/Kconfig"
+
+source "arch/mips/bcm63xx/dts/Kconfig"
diff --git a/arch/mips/bcm63xx/Makefile b/arch/mips/bcm63xx/Makefile
index ac28073..30971a7 100644
--- a/arch/mips/bcm63xx/Makefile
+++ b/arch/mips/bcm63xx/Makefile
@@ -5,3 +5,4 @@ obj-y		+= clk.o cpu.o cs.o gpio.o irq.o nvram.o prom.o reset.o \
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 
 obj-y		+= boards/
+obj-y		+= dts/
diff --git a/arch/mips/bcm63xx/dts/Kconfig b/arch/mips/bcm63xx/dts/Kconfig
new file mode 100644
index 0000000..919f3f6
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/Kconfig
@@ -0,0 +1,3 @@
+menu "Built-in Device Tree support"
+
+endmenu
diff --git a/arch/mips/bcm63xx/dts/Makefile b/arch/mips/bcm63xx/dts/Makefile
new file mode 100644
index 0000000..69c374b
--- /dev/null
+++ b/arch/mips/bcm63xx/dts/Makefile
@@ -0,0 +1,2 @@
+$(obj)/%.dtb: $(obj)/%.dts
+	$(call if_changed,dtc)
diff --git a/arch/mips/bcm63xx/setup.c b/arch/mips/bcm63xx/setup.c
index 314231b..8712354 100644
--- a/arch/mips/bcm63xx/setup.c
+++ b/arch/mips/bcm63xx/setup.c
@@ -4,6 +4,7 @@
  * for more details.
  *
  * Copyright (C) 2008 Maxime Bizon <mbizon@freebox.fr>
+ * Copyright (C) 2012 Jonas Gorski <jonas.gorski@gmail.com>
  */
 
 #include <linux/init.h>
@@ -12,6 +13,8 @@
 #include <linux/bootmem.h>
 #include <linux/ioport.h>
 #include <linux/pm.h>
+#include <linux/of_fdt.h>
+#include <linux/of_platform.h>
 #include <asm/bootinfo.h>
 #include <asm/time.h>
 #include <asm/reboot.h>
@@ -20,6 +23,7 @@
 #include <bcm63xx_cpu.h>
 #include <bcm63xx_regs.h>
 #include <bcm63xx_io.h>
+#include <bcm963xx_tag.h>
 
 void bcm63xx_machine_halt(void)
 {
@@ -152,6 +156,82 @@ void __init plat_mem_setup(void)
 	board_setup();
 }
 
+extern struct boot_param_header __dtb_start;
+extern struct boot_param_header __dtb_end;
+
+int __init bcm63xx_is_compatible(struct boot_param_header *devtree,
+				   const char *compat)
+{
+	unsigned long dt_root;
+	struct boot_param_header *old_ibp = initial_boot_params;
+	int ret;
+
+	initial_boot_params = devtree;
+
+	dt_root = of_get_flat_dt_root();
+	ret = of_flat_dt_is_compatible(dt_root, compat);
+
+	initial_boot_params = old_ibp;
+
+	return ret;
+}
+
+static struct of_device_id of_ids[] = {
+	{ /* will be filled at runtime */ },
+	{ .compatible = "simple-bus" },
+	{ },
+};
+
+static struct boot_param_header *find_compatible_tree(const char *compat)
+{
+	struct boot_param_header *curr = &__dtb_start;
+
+	while (curr < &__dtb_end) {
+		if (be32_to_cpu(curr->magic) != OF_DT_HEADER)
+			continue;
+
+		if (bcm63xx_is_compatible(curr, compat))
+			return curr;
+
+		/* in-kernel dtbs are aligned to 32 bytes */
+		curr = (void *)curr + roundup(be32_to_cpu(curr->totalsize), 32);
+	}
+
+	return NULL;
+}
+
+void __init device_tree_init(void)
+{
+	struct boot_param_header *devtree = NULL;
+	const char *name = board_get_name();
+
+	strncpy(of_ids[0].compatible, name, BOARDID_LEN);
+
+	devtree = find_compatible_tree(of_ids[0].compatible);
+	if (!devtree) {
+		pr_warn("no compatible device tree found for board %s\n"
+			of_ids[0].compatible);
+		return;
+	}
+
+	__dt_setup_arch(devtree);
+	reserve_bootmem(virt_to_phys(devtree), be32_to_cpu(devtree->totalsize),
+			BOOTMEM_DEFAULT);
+
+	unflatten_device_tree();
+}
+
+int __init bcm63xx_populate_device_tree(void)
+{
+	if (!of_have_populated_dt()) {
+		pr_warn("device tree not available\n");
+		return -ENODEV;
+	}
+
+	return of_platform_populate(NULL, of_ids, NULL, NULL);
+}
+arch_initcall(bcm63xx_populate_device_tree);
+
 int __init bcm63xx_register_devices(void)
 {
 	return board_register_devices();
-- 
1.7.2.5

