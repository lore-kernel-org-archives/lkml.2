Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab1CPABR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 20:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:50451 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755125Ab1CPABP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 20:01:15 -0400
Date: Wed, 16 Mar 2011 00:00:56 GMT
From: tip-bot for Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        dan.j.williams@intel.com, dave.jiang@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, dave.jiang@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <20110308183226.6246.90354.stgit@localhost6.localdomain6>
References: <20110308183226.6246.90354.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: Introduce pci_map_biosrom()
Message-ID: <tip-5d94e81f69d4b1d1102d3ab557ce0a817c11fbbb@git.kernel.org>
Git-Commit-ID: 5d94e81f69d4b1d1102d3ab557ce0a817c11fbbb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Mar 2011 00:00:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d94e81f69d4b1d1102d3ab557ce0a817c11fbbb
Gitweb:     http://git.kernel.org/tip/5d94e81f69d4b1d1102d3ab557ce0a817c11fbbb
Author:     Dan Williams <dan.j.williams@intel.com>
AuthorDate: Tue, 8 Mar 2011 10:36:19 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 15 Mar 2011 15:34:15 -0700

x86: Introduce pci_map_biosrom()

The isci driver needs to retrieve its preboot OROM image which contains
necessary runtime parameters like platform specific sas addresses and
phy configuration.  There is no ROM BAR associated with this area,
instead we will need to scan legacy expansion ROM space.

1/ Promote the probe_roms_32 implementation to x86-64
2/ Add a facility to find and map an adapter rom by pci device (according to
   PCI Firmware Specification Revision 3.0)

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
LKML-Reference: <20110308183226.6246.90354.stgit@localhost6.localdomain6>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/probe_roms.h |    8 +
 arch/x86/include/asm/setup.h      |    2 +-
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/head32.c          |    1 -
 arch/x86/kernel/probe_roms.c      |  267 +++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/probe_roms_32.c   |  166 -----------------------
 arch/x86/kernel/x86_init.c        |    2 +-
 7 files changed, 278 insertions(+), 170 deletions(-)

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
