Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab1ESVQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:16:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56145 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932606Ab1ESVQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:16:30 -0400
Date: Thu, 19 May 2011 23:16:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/platform changes for v2.6.40
Message-ID: <20110519211614.GA19748@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-platform-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-platform-for-linus

 Thanks,

	Ingo

------------------>
Dan Williams (1):
      x86: Introduce pci_map_biosrom()

Daniel Drake (1):
      x86, olpc: Use device tree for platform identification


 arch/x86/Kconfig                  |    2 +-
 arch/x86/include/asm/olpc_ofw.h   |    9 +-
 arch/x86/include/asm/probe_roms.h |    8 +
 arch/x86/include/asm/setup.h      |    2 +-
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/head32.c          |    1 -
 arch/x86/kernel/probe_roms.c      |  267 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/probe_roms_32.c   |  166 -----------------------
 arch/x86/kernel/x86_init.c        |    2 +-
 arch/x86/platform/olpc/Makefile   |    4 +-
 arch/x86/platform/olpc/olpc.c     |   51 ++++----
 arch/x86/platform/olpc/olpc_dt.c  |   19 +++
 12 files changed, 329 insertions(+), 204 deletions(-)
 create mode 100644 arch/x86/include/asm/probe_roms.h
 create mode 100644 arch/x86/kernel/probe_roms.c
 delete mode 100644 arch/x86/kernel/probe_roms_32.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b4c2e9c..471221b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2071,7 +2071,7 @@ config OLPC
 	depends on !X86_PAE
 	select GPIOLIB
 	select OF
-	select OF_PROMTREE if PROC_DEVICETREE
+	select OF_PROMTREE
 	---help---
 	  Add support for detecting the unique features of the OLPC
 	  XO hardware.
diff --git a/arch/x86/include/asm/olpc_ofw.h b/arch/x86/include/asm/olpc_ofw.h
index c5d3a5a..2448771 100644
--- a/arch/x86/include/asm/olpc_ofw.h
+++ b/arch/x86/include/asm/olpc_ofw.h
@@ -26,15 +26,12 @@ extern void setup_olpc_ofw_pgd(void);
 /* check if OFW was detected during boot */
 extern bool olpc_ofw_present(void);
 
+extern void olpc_dt_build_devicetree(void);
+
 #else /* !CONFIG_OLPC */
 static inline void olpc_ofw_detect(void) { }
 static inline void setup_olpc_ofw_pgd(void) { }
-#endif /* !CONFIG_OLPC */
-
-#ifdef CONFIG_OF_PROMTREE
-extern void olpc_dt_build_devicetree(void);
-#else
 static inline void olpc_dt_build_devicetree(void) { }
-#endif
+#endif /* !CONFIG_OLPC */
 
 #endif /* _ASM_X86_OLPC_OFW_H */
diff --git a/arch/x86/include/asm/probe_roms.h b/arch/x86/include/asm/probe_roms.h
new file mode 100644
index 0000000..4950a0b
--- /dev/null
+++ b/arch/x86/include/asm/probe_roms.h
@@ -0,0 +1,8 @@
+#ifndef _PROBE_ROMS_H_
+#define _PROBE_ROMS_H_
+struct pci_dev;
+
+extern void __iomem *pci_map_biosrom(struct pci_dev *pdev);
+extern void pci_unmap_biosrom(void __iomem *rom);
+extern size_t pci_biosrom_size(struct pci_dev *pdev);
+#endif
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index db8aa19..03d3a32 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -104,10 +104,10 @@ void *extend_brk(size_t size, size_t align);
 	type *name;					\
 	RESERVE_BRK(name, sizeof(type) * entries)
 
+extern void probe_roms(void);
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
-extern void probe_roms(void);
 
 #else
 void __init x86_64_start_kernel(char *real_mode);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 62445ba..f33d738 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -36,7 +36,7 @@ obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o jump_label.o
 obj-$(CONFIG_IRQ_WORK)  += irq_work.o
-obj-$(CONFIG_X86_32)	+= probe_roms_32.o
+obj-y			+= probe_roms.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 7f138b3..eab4940 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -23,7 +23,6 @@
 static void __init i386_default_early_setup(void)
 {
 	/* Initialize 32bit specific setup functions */
-	x86_init.resources.probe_roms = probe_roms;
 	x86_init.resources.reserve_resources = i386_reserve_resources;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
new file mode 100644
index 0000000..ba0a4cc
--- /dev/null
+++ b/arch/x86/kernel/probe_roms.c
@@ -0,0 +1,267 @@
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <linux/mmzone.h>
+#include <linux/ioport.h>
+#include <linux/seq_file.h>
+#include <linux/console.h>
+#include <linux/init.h>
+#include <linux/edd.h>
+#include <linux/dmi.h>
+#include <linux/pfn.h>
+#include <linux/pci.h>
+#include <asm/pci-direct.h>
+
+
+#include <asm/e820.h>
+#include <asm/mmzone.h>
+#include <asm/setup.h>
+#include <asm/sections.h>
+#include <asm/io.h>
+#include <asm/setup_arch.h>
+
+static struct resource system_rom_resource = {
+	.name	= "System ROM",
+	.start	= 0xf0000,
+	.end	= 0xfffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+};
+
+static struct resource extension_rom_resource = {
+	.name	= "Extension ROM",
+	.start	= 0xe0000,
+	.end	= 0xeffff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+};
+
+static struct resource adapter_rom_resources[] = { {
+	.name 	= "Adapter ROM",
+	.start	= 0xc8000,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+}, {
+	.name 	= "Adapter ROM",
+	.start	= 0,
+	.end	= 0,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+} };
+
+static struct resource video_rom_resource = {
+	.name 	= "Video ROM",
+	.start	= 0xc0000,
+	.end	= 0xc7fff,
+	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
+};
+
+/* does this oprom support the given pci device, or any of the devices
+ * that the driver supports?
+ */
+static bool match_id(struct pci_dev *pdev, unsigned short vendor, unsigned short device)
+{
+	struct pci_driver *drv = pdev->driver;
+	const struct pci_device_id *id;
+
+	if (pdev->vendor == vendor && pdev->device == device)
+		return true;
+
+	for (id = drv ? drv->id_table : NULL; id && id->vendor; id++)
+		if (id->vendor == vendor && id->device == device)
+			break;
+
+	return id && id->vendor;
+}
+
+static bool probe_list(struct pci_dev *pdev, unsigned short vendor,
+		       const unsigned char *rom_list)
+{
+	unsigned short device;
+
+	do {
+		if (probe_kernel_address(rom_list, device) != 0)
+			device = 0;
+
+		if (device && match_id(pdev, vendor, device))
+			break;
+
+		rom_list += 2;
+	} while (device);
+
+	return !!device;
+}
+
+static struct resource *find_oprom(struct pci_dev *pdev)
+{
+	struct resource *oprom = NULL;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources); i++) {
+		struct resource *res = &adapter_rom_resources[i];
+		unsigned short offset, vendor, device, list, rev;
+		const unsigned char *rom;
+
+		if (res->end == 0)
+			break;
+
+		rom = isa_bus_to_virt(res->start);
+		if (probe_kernel_address(rom + 0x18, offset) != 0)
+			continue;
+
+		if (probe_kernel_address(rom + offset + 0x4, vendor) != 0)
+			continue;
+
+		if (probe_kernel_address(rom + offset + 0x6, device) != 0)
+			continue;
+
+		if (match_id(pdev, vendor, device)) {
+			oprom = res;
+			break;
+		}
+
+		if (probe_kernel_address(rom + offset + 0x8, list) == 0 &&
+		    probe_kernel_address(rom + offset + 0xc, rev) == 0 &&
+		    rev >= 3 && list &&
+		    probe_list(pdev, vendor, rom + offset + list)) {
+			oprom = res;
+			break;
+		}
+	}
+
+	return oprom;
+}
+
+void *pci_map_biosrom(struct pci_dev *pdev)
+{
+	struct resource *oprom = find_oprom(pdev);
+
+	if (!oprom)
+		return NULL;
+
+	return ioremap(oprom->start, resource_size(oprom));
+}
+EXPORT_SYMBOL(pci_map_biosrom);
+
+void pci_unmap_biosrom(void __iomem *image)
+{
+	iounmap(image);
+}
+EXPORT_SYMBOL(pci_unmap_biosrom);
+
+size_t pci_biosrom_size(struct pci_dev *pdev)
+{
+	struct resource *oprom = find_oprom(pdev);
+
+	return oprom ? resource_size(oprom) : 0;
+}
+EXPORT_SYMBOL(pci_biosrom_size);
+
+#define ROMSIGNATURE 0xaa55
+
+static int __init romsignature(const unsigned char *rom)
+{
+	const unsigned short * const ptr = (const unsigned short *)rom;
+	unsigned short sig;
+
+	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
+}
+
+static int __init romchecksum(const unsigned char *rom, unsigned long length)
+{
+	unsigned char sum, c;
+
+	for (sum = 0; length && probe_kernel_address(rom++, c) == 0; length--)
+		sum += c;
+	return !length && !sum;
+}
+
+void __init probe_roms(void)
+{
+	const unsigned char *rom;
+	unsigned long start, length, upper;
+	unsigned char c;
+	int i;
+
+	/* video rom */
+	upper = adapter_rom_resources[0].start;
+	for (start = video_rom_resource.start; start < upper; start += 2048) {
+		rom = isa_bus_to_virt(start);
+		if (!romsignature(rom))
+			continue;
+
+		video_rom_resource.start = start;
+
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
+		/* 0 < length <= 0x7f * 512, historically */
+		length = c * 512;
+
+		/* if checksum okay, trust length byte */
+		if (length && romchecksum(rom, length))
+			video_rom_resource.end = start + length - 1;
+
+		request_resource(&iomem_resource, &video_rom_resource);
+		break;
+	}
+
+	start = (video_rom_resource.end + 1 + 2047) & ~2047UL;
+	if (start < upper)
+		start = upper;
+
+	/* system rom */
+	request_resource(&iomem_resource, &system_rom_resource);
+	upper = system_rom_resource.start;
+
+	/* check for extension rom (ignore length byte!) */
+	rom = isa_bus_to_virt(extension_rom_resource.start);
+	if (romsignature(rom)) {
+		length = extension_rom_resource.end - extension_rom_resource.start + 1;
+		if (romchecksum(rom, length)) {
+			request_resource(&iomem_resource, &extension_rom_resource);
+			upper = extension_rom_resource.start;
+		}
+	}
+
+	/* check for adapter roms on 2k boundaries */
+	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 2048) {
+		rom = isa_bus_to_virt(start);
+		if (!romsignature(rom))
+			continue;
+
+		if (probe_kernel_address(rom + 2, c) != 0)
+			continue;
+
+		/* 0 < length <= 0x7f * 512, historically */
+		length = c * 512;
+
+		/* but accept any length that fits if checksum okay */
+		if (!length || start + length > upper || !romchecksum(rom, length))
+			continue;
+
+		adapter_rom_resources[i].start = start;
+		adapter_rom_resources[i].end = start + length - 1;
+		request_resource(&iomem_resource, &adapter_rom_resources[i]);
+
+		start = adapter_rom_resources[i++].end & ~2047UL;
+	}
+}
+
diff --git a/arch/x86/kernel/probe_roms_32.c b/arch/x86/kernel/probe_roms_32.c
deleted file mode 100644
index 071e7fe..0000000
--- a/arch/x86/kernel/probe_roms_32.c
+++ /dev/null
@@ -1,166 +0,0 @@
-#include <linux/sched.h>
-#include <linux/mm.h>
-#include <linux/uaccess.h>
-#include <linux/mmzone.h>
-#include <linux/ioport.h>
-#include <linux/seq_file.h>
-#include <linux/console.h>
-#include <linux/init.h>
-#include <linux/edd.h>
-#include <linux/dmi.h>
-#include <linux/pfn.h>
-#include <linux/pci.h>
-#include <asm/pci-direct.h>
-
-
-#include <asm/e820.h>
-#include <asm/mmzone.h>
-#include <asm/setup.h>
-#include <asm/sections.h>
-#include <asm/io.h>
-#include <asm/setup_arch.h>
-
-static struct resource system_rom_resource = {
-	.name	= "System ROM",
-	.start	= 0xf0000,
-	.end	= 0xfffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-};
-
-static struct resource extension_rom_resource = {
-	.name	= "Extension ROM",
-	.start	= 0xe0000,
-	.end	= 0xeffff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-};
-
-static struct resource adapter_rom_resources[] = { {
-	.name 	= "Adapter ROM",
-	.start	= 0xc8000,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-}, {
-	.name 	= "Adapter ROM",
-	.start	= 0,
-	.end	= 0,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-} };
-
-static struct resource video_rom_resource = {
-	.name 	= "Video ROM",
-	.start	= 0xc0000,
-	.end	= 0xc7fff,
-	.flags	= IORESOURCE_BUSY | IORESOURCE_READONLY | IORESOURCE_MEM
-};
-
-#define ROMSIGNATURE 0xaa55
-
-static int __init romsignature(const unsigned char *rom)
-{
-	const unsigned short * const ptr = (const unsigned short *)rom;
-	unsigned short sig;
-
-	return probe_kernel_address(ptr, sig) == 0 && sig == ROMSIGNATURE;
-}
-
-static int __init romchecksum(const unsigned char *rom, unsigned long length)
-{
-	unsigned char sum, c;
-
-	for (sum = 0; length && probe_kernel_address(rom++, c) == 0; length--)
-		sum += c;
-	return !length && !sum;
-}
-
-void __init probe_roms(void)
-{
-	const unsigned char *rom;
-	unsigned long start, length, upper;
-	unsigned char c;
-	int i;
-
-	/* video rom */
-	upper = adapter_rom_resources[0].start;
-	for (start = video_rom_resource.start; start < upper; start += 2048) {
-		rom = isa_bus_to_virt(start);
-		if (!romsignature(rom))
-			continue;
-
-		video_rom_resource.start = start;
-
-		if (probe_kernel_address(rom + 2, c) != 0)
-			continue;
-
-		/* 0 < length <= 0x7f * 512, historically */
-		length = c * 512;
-
-		/* if checksum okay, trust length byte */
-		if (length && romchecksum(rom, length))
-			video_rom_resource.end = start + length - 1;
-
-		request_resource(&iomem_resource, &video_rom_resource);
-		break;
-	}
-
-	start = (video_rom_resource.end + 1 + 2047) & ~2047UL;
-	if (start < upper)
-		start = upper;
-
-	/* system rom */
-	request_resource(&iomem_resource, &system_rom_resource);
-	upper = system_rom_resource.start;
-
-	/* check for extension rom (ignore length byte!) */
-	rom = isa_bus_to_virt(extension_rom_resource.start);
-	if (romsignature(rom)) {
-		length = extension_rom_resource.end - extension_rom_resource.start + 1;
-		if (romchecksum(rom, length)) {
-			request_resource(&iomem_resource, &extension_rom_resource);
-			upper = extension_rom_resource.start;
-		}
-	}
-
-	/* check for adapter roms on 2k boundaries */
-	for (i = 0; i < ARRAY_SIZE(adapter_rom_resources) && start < upper; start += 2048) {
-		rom = isa_bus_to_virt(start);
-		if (!romsignature(rom))
-			continue;
-
-		if (probe_kernel_address(rom + 2, c) != 0)
-			continue;
-
-		/* 0 < length <= 0x7f * 512, historically */
-		length = c * 512;
-
-		/* but accept any length that fits if checksum okay */
-		if (!length || start + length > upper || !romchecksum(rom, length))
-			continue;
-
-		adapter_rom_resources[i].start = start;
-		adapter_rom_resources[i].end = start + length - 1;
-		request_resource(&iomem_resource, &adapter_rom_resources[i]);
-
-		start = adapter_rom_resources[i++].end & ~2047UL;
-	}
-}
-
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index c11514e..6eee082 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -35,7 +35,7 @@ void iommu_shutdown_noop(void) { }
 struct x86_init_ops x86_init __initdata = {
 
 	.resources = {
-		.probe_roms		= x86_init_noop,
+		.probe_roms		= probe_roms,
 		.reserve_resources	= reserve_standard_io_resources,
 		.memory_setup		= default_machine_specific_memory_setup,
 	},
diff --git a/arch/x86/platform/olpc/Makefile b/arch/x86/platform/olpc/Makefile
index c2a8cab..81c5e21 100644
--- a/arch/x86/platform/olpc/Makefile
+++ b/arch/x86/platform/olpc/Makefile
@@ -1,4 +1,2 @@
-obj-$(CONFIG_OLPC)		+= olpc.o
+obj-$(CONFIG_OLPC)		+= olpc.o olpc_ofw.o olpc_dt.o
 obj-$(CONFIG_OLPC_XO1)		+= olpc-xo1.o
-obj-$(CONFIG_OLPC)		+= olpc_ofw.o
-obj-$(CONFIG_OF_PROMTREE)	+= olpc_dt.o
diff --git a/arch/x86/platform/olpc/olpc.c b/arch/x86/platform/olpc/olpc.c
index edaf3fe..0060fd5 100644
--- a/arch/x86/platform/olpc/olpc.c
+++ b/arch/x86/platform/olpc/olpc.c
@@ -18,6 +18,7 @@
 #include <linux/io.h>
 #include <linux/string.h>
 #include <linux/platform_device.h>
+#include <linux/of.h>
 
 #include <asm/geode.h>
 #include <asm/setup.h>
@@ -187,41 +188,43 @@ err:
 }
 EXPORT_SYMBOL_GPL(olpc_ec_cmd);
 
-static bool __init check_ofw_architecture(void)
+static bool __init check_ofw_architecture(struct device_node *root)
 {
-	size_t propsize;
-	char olpc_arch[5];
-	const void *args[] = { NULL, "architecture", olpc_arch, (void *)5 };
-	void *res[] = { &propsize };
+	const char *olpc_arch;
+	int propsize;
 
-	if (olpc_ofw("getprop", args, res)) {
-		printk(KERN_ERR "ofw: getprop call failed!\n");
-		return false;
-	}
+	olpc_arch = of_get_property(root, "architecture", &propsize);
 	return propsize == 5 && strncmp("OLPC", olpc_arch, 5) == 0;
 }
 
-static u32 __init get_board_revision(void)
+static u32 __init get_board_revision(struct device_node *root)
 {
-	size_t propsize;
-	__be32 rev;
-	const void *args[] = { NULL, "board-revision-int", &rev, (void *)4 };
-	void *res[] = { &propsize };
-
-	if (olpc_ofw("getprop", args, res) || propsize != 4) {
-		printk(KERN_ERR "ofw: getprop call failed!\n");
-		return cpu_to_be32(0);
-	}
-	return be32_to_cpu(rev);
+	int propsize;
+	const __be32 *rev;
+
+	rev = of_get_property(root, "board-revision-int", &propsize);
+	if (propsize != 4)
+		return 0;
+
+	return be32_to_cpu(*rev);
 }
 
 static bool __init platform_detect(void)
 {
-	if (!check_ofw_architecture())
+	struct device_node *root = of_find_node_by_path("/");
+	bool success;
+
+	if (!root)
 		return false;
-	olpc_platform_info.flags |= OLPC_F_PRESENT;
-	olpc_platform_info.boardrev = get_board_revision();
-	return true;
+
+	success = check_ofw_architecture(root);
+	if (success) {
+		olpc_platform_info.boardrev = get_board_revision(root);
+		olpc_platform_info.flags |= OLPC_F_PRESENT;
+	}
+
+	of_node_put(root);
+	return success;
 }
 
 static int __init add_xo1_platform_devices(void)
diff --git a/arch/x86/platform/olpc/olpc_dt.c b/arch/x86/platform/olpc/olpc_dt.c
index dab8746..4ce208f 100644
--- a/arch/x86/platform/olpc/olpc_dt.c
+++ b/arch/x86/platform/olpc/olpc_dt.c
@@ -19,7 +19,9 @@
 #include <linux/kernel.h>
 #include <linux/bootmem.h>
 #include <linux/of.h>
+#include <linux/of_platform.h>
 #include <linux/of_pdt.h>
+#include <asm/olpc.h>
 #include <asm/olpc_ofw.h>
 
 static phandle __init olpc_dt_getsibling(phandle node)
@@ -181,3 +183,20 @@ void __init olpc_dt_build_devicetree(void)
 	pr_info("PROM DT: Built device tree with %u bytes of memory.\n",
 			prom_early_allocated);
 }
+
+/* A list of DT node/bus matches that we want to expose as platform devices */
+static struct of_device_id __initdata of_ids[] = {
+	{ .compatible = "olpc,xo1-battery" },
+	{ .compatible = "olpc,xo1-dcon" },
+	{ .compatible = "olpc,xo1-rtc" },
+	{},
+};
+
+static int __init olpc_create_platform_devices(void)
+{
+	if (machine_is_olpc())
+		return of_platform_bus_probe(NULL, of_ids, NULL);
+	else
+		return 0;
+}
+device_initcall(olpc_create_platform_devices);
