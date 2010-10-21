Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab0JUOGs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 10:06:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36786 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758407Ab0JUOGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 10:06:46 -0400
Date: Thu, 21 Oct 2010 16:06:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/olpc for v2.6.37
Message-ID: <20101021140639.GA9272@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-olpc-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-olpc-for-linus

 Thanks,

	Ingo

------------------>
Daniel Drake (4):
      x86, olpc: Only enable PCI configuration type override on XO-1
      x86, olpc: Rework BIOS signature check
      x86, olpc: Add XO-1 poweroff support
      x86, olpc: Register XO-1 platform devices

Paul Fox (1):
      x86, olpc: Don't retry EC commands forever

Randy Dunlap (1):
      x86, olpc: XO-1 uses/depends on PCI


 arch/x86/Kconfig                |   11 +++-
 arch/x86/include/asm/olpc_ofw.h |    4 +
 arch/x86/kernel/Makefile        |    1 +
 arch/x86/kernel/olpc-xo1.c      |  140 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/olpc.c          |   89 +++++++++++++++----------
 arch/x86/kernel/olpc_ofw.c      |    6 ++
 arch/x86/pci/olpc.c             |    2 +-
 7 files changed, 216 insertions(+), 37 deletions(-)
 create mode 100644 arch/x86/kernel/olpc-xo1.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..c010b8d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1900,7 +1900,7 @@ config PCI_GODIRECT
 	bool "Direct"
 
 config PCI_GOOLPC
-	bool "OLPC"
+	bool "OLPC XO-1"
 	depends on OLPC
 
 config PCI_GOANY
@@ -2061,14 +2061,21 @@ config SCx200HR_TIMER
 config OLPC
 	bool "One Laptop Per Child support"
 	select GPIOLIB
+	select OLPC_OPENFIRMWARE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
 
+config OLPC_XO1
+	tristate "OLPC XO-1 support"
+	depends on OLPC && PCI
+	---help---
+	  Add support for non-essential features of the OLPC XO-1 laptop.
+
 config OLPC_OPENFIRMWARE
 	bool "Support for OLPC's Open Firmware"
 	depends on !X86_64 && !X86_PAE
-	default y if OLPC
+	default n
 	help
 	  This option adds support for the implementation of Open Firmware
 	  that is used on the OLPC XO-1 Children's Machine.
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index 08fde47..2a84781 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -21,10 +21,14 @@ extern void olpc_ofw_detect(void);
 /* install OFW's pde permanently into the kernel's pgtable */
 extern void setup_olpc_ofw_pgd(void);
 
+/* check if OFW was detected during boot */
+extern bool olpc_ofw_present(void);
+
 #else /* !CONFIG_OLPC_OPENFIRMWARE */
 
 static inline void olpc_ofw_detect(void) { }
 static inline void setup_olpc_ofw_pgd(void) { }
+static inline bool olpc_ofw_present(void) { return false; }
 
 #endif /* !CONFIG_OLPC_OPENFIRMWARE */
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..e977779 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_SCx200)		+= scx200.o
 scx200-y			+= scx200_32.o
 
 obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
 obj-$(CONFIG_OLPC_OPENFIRMWARE)	+= olpc_ofw.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
diff --git a/arch/x86/kernel/olpc-xo1.c b/arch/x86/kernel/olpc-xo1.c
new file mode 100644
index 0000000..f5442c0
--- /dev/null
+++ b/arch/x86/kernel/olpc-xo1.c
@@ -0,0 +1,140 @@
+/*
+ * Support for features of the OLPC XO-1 laptop
+ *
+ * Copyright (C) 2010 One Laptop per Child
+ * Copyright (C) 2006 Red Hat, Inc.
+ * Copyright (C) 2006 Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+
+#include <asm/io.h>
+#include <asm/olpc.h>
+
+#define DRV_NAME "olpc-xo1"
+
+#define PMS_BAR		4
+#define ACPI_BAR	5
+
+/* PMC registers (PMS block) */
+#define PM_SCLK		0x10
+#define PM_IN_SLPCTL	0x20
+#define PM_WKXD		0x34
+#define PM_WKD		0x30
+#define PM_SSC		0x54
+
+/* PM registers (ACPI block) */
+#define PM1_CNT		0x08
+#define PM_GPE0_STS	0x18
+
+static unsigned long acpi_base;
+static unsigned long pms_base;
+
+static void xo1_power_off(void)
+{
+	printk(KERN_INFO "OLPC XO-1 power off sequence...\n");
+
+	/* Enable all of these controls with 0 delay */
+	outl(0x40000000, pms_base + PM_SCLK);
+	outl(0x40000000, pms_base + PM_IN_SLPCTL);
+	outl(0x40000000, pms_base + PM_WKXD);
+	outl(0x40000000, pms_base + PM_WKD);
+
+	/* Clear status bits (possibly unnecessary) */
+	outl(0x0002ffff, pms_base  + PM_SSC);
+	outl(0xffffffff, acpi_base + PM_GPE0_STS);
+
+	/* Write SLP_EN bit to start the machinery */
+	outl(0x00002000, acpi_base + PM1_CNT);
+}
+
+/* Read the base addresses from the PCI BAR info */
+static int __devinit setup_bases(struct pci_dev *pdev)
+{
+	int r;
+
+	r = pci_enable_device_io(pdev);
+	if (r) {
+		dev_err(&pdev->dev, "can't enable device IO\n");
+		return r;
+	}
+
+	r = pci_request_region(pdev, ACPI_BAR, DRV_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", ACPI_BAR);
+		return r;
+	}
+
+	r = pci_request_region(pdev, PMS_BAR, DRV_NAME);
+	if (r) {
+		dev_err(&pdev->dev, "can't alloc PCI BAR #%d\n", PMS_BAR);
+		pci_release_region(pdev, ACPI_BAR);
+		return r;
+	}
+
+	acpi_base = pci_resource_start(pdev, ACPI_BAR);
+	pms_base = pci_resource_start(pdev, PMS_BAR);
+
+	return 0;
+}
+
+static int __devinit olpc_xo1_probe(struct platform_device *pdev)
+{
+	struct pci_dev *pcidev;
+	int r;
+
+	pcidev = pci_get_device(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_CS5536_ISA,
+				NULL);
+	if (!pdev)
+		return -ENODEV;
+
+	r = setup_bases(pcidev);
+	if (r)
+		return r;
+
+	pm_power_off = xo1_power_off;
+
+	printk(KERN_INFO "OLPC XO-1 support registered\n");
+	return 0;
+}
+
+static int __devexit olpc_xo1_remove(struct platform_device *pdev)
+{
+	pm_power_off = NULL;
+	return 0;
+}
+
+static struct platform_driver olpc_xo1_driver = {
+	.driver = {
+		.name = DRV_NAME,
+		.owner = THIS_MODULE,
+	},
+	.probe = olpc_xo1_probe,
+	.remove = __devexit_p(olpc_xo1_remove),
+};
+
+static int __init olpc_xo1_init(void)
+{
+	return platform_driver_register(&olpc_xo1_driver);
+}
+
+static void __exit olpc_xo1_exit(void)
+{
+	platform_driver_unregister(&olpc_xo1_driver);
+}
+
+MODULE_AUTHOR("Daniel Drake <dsd@laptop.org>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:olpc-xo1");
+
+module_init(olpc_xo1_init);
+module_exit(olpc_xo1_exit);
diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
index 0e0cdde..edaf3fe 100644
--- a/arch/x86/kernel/olpc.c
+++ b/arch/x86/kernel/olpc.c
@@ -17,6 +17,7 @@
 #include <linux/spinlock.h>
 #include <linux/io.h>
 #include <linux/string.h>
+#include <linux/platform_device.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -114,6 +115,7 @@ int olpc_ec_cmd(unsigned char cmd, unsigned char *inbuf, size_t inlen,
 	unsigned long flags;
 	int ret = -EIO;
 	int i;
+	int restarts = 0;
 
 	spin_lock_irqsave(&ec_lock, flags);
 
@@ -169,7 +171,9 @@ restart:
 			if (wait_on_obf(0x6c, 1)) {
 				printk(KERN_ERR "olpc-ec:  timeout waiting for"
 						" EC to provide data!\n");
-				goto restart;
+				if (restarts++ < 10)
+					goto restart;
+				goto err;
 			}
 			outbuf[i] = inb(0x68);
 			pr_devel("olpc-ec:  received 0x%x\n", outbuf[i]);
@@ -183,8 +187,21 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-#ifdef CONFIG_OLPC_OPENFIRMWARE
-static void __init platform_detect(void)
+static bool __init check_ofw_architecture(void)
+{
+	size_t propsize;
+	char olpc_arch[5];
+	const void *args[] = { NULL, "architecture", olpc_arch, (void *)5 };
+	void *res[] = { &propsize };
+
+	if (olpc_ofw("getprop", args, res)) {
+		printk(KERN_ERR "ofw: getprop call failed!\n");
+		return false;
+	}
+	return propsize == 5 && strncmp("OLPC", olpc_arch, 5) == 0;
+}
+
+static u32 __init get_board_revision(void)
 {
 	size_t propsize;
 	__be32 rev;
@@ -193,45 +210,43 @@ static void __init platform_detect(void)
 
 	if (olpc_ofw("getprop", args, res) || propsize != 4) {
 		printk(KERN_ERR "ofw: getprop call failed!\n");
-		rev = cpu_to_be32(0);
+		return cpu_to_be32(0);
 	}
-	olpc_platform_info.boardrev = be32_to_cpu(rev);
+	return be32_to_cpu(rev);
 }
-#else
-static void __init platform_detect(void)
+
+static bool __init platform_detect(void)
 {
-	/* stopgap until OFW support is added to the kernel */
-	olpc_platform_info.boardrev = olpc_board(0xc2);
+	if (!check_ofw_architecture())
+		return false;
+	olpc_platform_info.flags |= OLPC_F_PRESENT;
+	olpc_platform_info.boardrev = get_board_revision();
+	return true;
 }
-#endif
 
-static int __init olpc_init(void)
+static int __init add_xo1_platform_devices(void)
 {
-	unsigned char *romsig;
+	struct platform_device *pdev;
 
-	/* The ioremap check is dangerous; limit what we run it on */
-	if (!is_geode() || cs5535_has_vsa2())
-		return 0;
+	pdev = platform_device_register_simple("xo1-rfkill", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
 
-	spin_lock_init(&ec_lock);
+	pdev = platform_device_register_simple("olpc-xo1", -1, NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
 
-	romsig = ioremap(0xffffffc0, 16);
-	if (!romsig)
-		return 0;
+	return 0;
+}
 
-	if (strncmp(romsig, "CL1   Q", 7))
-		goto unmap;
-	if (strncmp(romsig+6, romsig+13, 3)) {
-		printk(KERN_INFO "OLPC BIOS signature looks invalid.  "
-				"Assuming not OLPC\n");
-		goto unmap;
-	}
+static int __init olpc_init(void)
+{
+	int r = 0;
 
-	printk(KERN_INFO "OLPC board with OpenFirmware %.16s\n", romsig);
-	olpc_platform_info.flags |= OLPC_F_PRESENT;
+	if (!olpc_ofw_present() || !platform_detect())
+		return 0;
 
-	/* get the platform revision */
-	platform_detect();
+	spin_lock_init(&ec_lock);
 
 	/* assume B1 and above models always have a DCON */
 	if (olpc_board_at_least(olpc_board(0xb1)))
@@ -242,8 +257,10 @@ static int __init olpc_init(void)
 			(unsigned char *) &olpc_platform_info.ecver, 1);
 
 #ifdef CONFIG_PCI_OLPC
-	/* If the VSA exists let it emulate PCI, if not emulate in kernel */
-	if (!cs5535_has_vsa2())
+	/* If the VSA exists let it emulate PCI, if not emulate in kernel.
+	 * XO-1 only. */
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0) &&
+			!cs5535_has_vsa2())
 		x86_init.pci.arch_init = pci_olpc_init;
 #endif
 
@@ -252,8 +269,12 @@ static int __init olpc_init(void)
 			olpc_platform_info.boardrev >> 4,
 			olpc_platform_info.ecver);
 
-unmap:
-	iounmap(romsig);
+	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) { /* XO-1 */
+		r = add_xo1_platform_devices();
+		if (r)
+			return r;
+	}
+
 	return 0;
 }
 
diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
index 3218aa7..7873204 100644
--- a/arch/x86/kernel/olpc_ofw.c
+++ b/arch/x86/kernel/olpc_ofw.c
@@ -74,6 +74,12 @@ int __olpc_ofw(const char *name, int nr_args, const void **args, int nr_res,
 }
 EXPORT_SYMBOL_GPL(__olpc_ofw);
 
+bool olpc_ofw_present(void)
+{
+	return olpc_ofw_cif != NULL;
+}
+EXPORT_SYMBOL_GPL(olpc_ofw_present);
+
 /* OFW cif _should_ be above this address */
 #define OFW_MIN 0xff000000
 
diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
index b348154..13700ec 100644
--- a/arch/x86/pci/olpc.c
+++ b/arch/x86/pci/olpc.c
@@ -304,7 +304,7 @@ static struct pci_raw_ops pci_olpc_conf = {
 
 int __init pci_olpc_init(void)
 {
-	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
+	printk(KERN_INFO "PCI: Using configuration type OLPC XO-1\n");
 	raw_pci_ops = &pci_olpc_conf;
 	is_lx = is_geode_lx();
 	return 0;
