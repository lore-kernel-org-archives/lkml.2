Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab0DZWHF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:07:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63831 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754837Ab0DZWG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:06:58 -0400
Message-ID: <4BD60E02.6090708@oracle.com>
Date: Mon, 26 Apr 2010 15:04:50 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: [PATCH -v5 2/3] x86: Remove probe_roms for 32bit
References: <4BC4E55B.7000103@oracle.com>	<20100426183436.GV11130@hexapodia.org>	<20100426123135.5d095d2f@virtuousgeek.org>	<201004261427.57229.bjorn.helgaas@hp.com>	<20100426133757.3e1d0a75@virtuousgeek.org>	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com> <20100426142546.2e77b1ba@virtuousgeek.org> <4BD60CD5.4060601@oracle.com> <4BD60CD4.9020708@oracle.com>
In-Reply-To: <4BD60CD4.9020708@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4BD60E5E.00E8:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



That is not needed, because whole range is reserved already

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/setup.h    |    2 
 arch/x86/include/asm/x86_init.h |    4 
 arch/x86/kernel/Makefile        |    1 
 arch/x86/kernel/head32.c        |    1 
 arch/x86/kernel/mrst.c          |    2 
 arch/x86/kernel/probe_roms_32.c |  166 ----------------------------------------
 arch/x86/kernel/setup.c         |    6 -
 arch/x86/kernel/x86_init.c      |    2 
 8 files changed, 7 insertions(+), 177 deletions(-)

Index: linux-2.6/arch/x86/include/asm/setup.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/setup.h
+++ linux-2.6/arch/x86/include/asm/setup.h
@@ -43,6 +43,7 @@ static inline void visws_early_detect(vo
 
 extern unsigned long saved_video_mode;
 
+void trim_bios_range(void);
 extern void reserve_standard_io_resources(void);
 extern void setup_default_timer_irq(void);
 
@@ -95,7 +96,6 @@ void *extend_brk(size_t size, size_t ali
 #ifdef __i386__
 
 void __init i386_start_kernel(void);
-extern void probe_roms(void);
 
 #else
 void __init x86_64_start_kernel(char *real_mode);
Index: linux-2.6/arch/x86/include/asm/x86_init.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/x86_init.h
+++ linux-2.6/arch/x86/include/asm/x86_init.h
@@ -32,14 +32,14 @@ struct x86_init_mpparse {
 
 /**
  * struct x86_init_resources - platform specific resource related ops
- * @probe_roms:			probe BIOS roms
+ * @trim_bios_range:		trim BIOS related range in E820
  * @reserve_resources:		reserve the standard resources for the
  *				platform
  * @memory_setup:		platform specific memory setup
  *
  */
 struct x86_init_resources {
-	void (*probe_roms)(void);
+	void (*trim_bios_range)(void);
 	void (*reserve_resources)(void);
 	char *(*memory_setup)(void);
 };
Index: linux-2.6/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/Makefile
+++ linux-2.6/arch/x86/kernel/Makefile
@@ -34,7 +34,6 @@ obj-y			+= traps.o irq.o irq_$(BITS).o d
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o
 obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
-obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-$(CONFIG_X86_64)	+= syscall_64.o vsyscall_64.o
Index: linux-2.6/arch/x86/kernel/head32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/head32.c
+++ linux-2.6/arch/x86/kernel/head32.c
@@ -21,7 +21,6 @@
 static void __init i386_default_early_setup(void)
 {
 	/* Initilize 32bit specific setup functions */
-	x86_init.resources.probe_roms = probe_roms;
 	x86_init.mpparse.setup_ioapic_ids = setup_ioapic_ids_from_mpc;
 
 	reserve_ebda_region();
Index: linux-2.6/arch/x86/kernel/mrst.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mrst.c
+++ linux-2.6/arch/x86/kernel/mrst.c
@@ -222,7 +222,7 @@ static void __init mrst_setup_boot_clock
  */
 void __init x86_mrst_early_setup(void)
 {
-	x86_init.resources.probe_roms = x86_init_noop;
+	x86_init.resources.trim_bios_range = x86_init_noop;
 	x86_init.resources.reserve_resources = x86_init_noop;
 
 	x86_init.timers.timer_init = mrst_time_init;
Index: linux-2.6/arch/x86/kernel/probe_roms_32.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/probe_roms_32.c
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
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -680,7 +680,7 @@ static struct dmi_system_id __initdata b
 	{}
 };
 
-static void __init trim_bios_range(void)
+void __init trim_bios_range(void)
 {
 	/*
 	 * A special case is the first 4Kb of memory;
@@ -853,14 +853,12 @@ void __init setup_arch(char **cmdline_p)
 	 */
 	init_hypervisor_platform();
 
-	x86_init.resources.probe_roms();
-
 	/* after parse_early_param, so could debug it */
 	insert_resource(&iomem_resource, &code_resource);
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	trim_bios_range();
+	x86_init.resources.trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
Index: linux-2.6/arch/x86/kernel/x86_init.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/x86_init.c
+++ linux-2.6/arch/x86/kernel/x86_init.c
@@ -32,7 +32,7 @@ void iommu_shutdown_noop(void) { }
 struct x86_init_ops x86_init __initdata = {
 
 	.resources = {
-		.probe_roms		= x86_init_noop,
+		.trim_bios_range	= trim_bios_range,
 		.reserve_resources	= reserve_standard_io_resources,
 		.memory_setup		= default_machine_specific_memory_setup,
 	},
