Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932776Ab2FVDD5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 23:03:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38703 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2FVDDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 23:03:55 -0400
From: Huacai Chen <chenhuacai@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Fuxin Zhang <zhangfx@lemote.com>, Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhc@lemote.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Subject: =?UTF-8?q?=5BPATCH=20V3=2005/16=5D=20MIPS=3A=20Loongson=3A=20Add=20UEFI-like=20firmware=20interface=20support=2E?=
Date: Fri, 22 Jun 2012 11:01:02 +0800
Message-Id: <1340334073-17804-6-git-send-email-chenhc@lemote.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
References: <1340334073-17804-1-git-send-email-chenhc@lemote.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new UEFI-like firmware interface has 3 advantages:

1, Firmware export a physical memory map which is similar to X86's
   E820 map, so prom_init_memory() will be more elegant that #ifdef
   clauses can be removed.
2, Firmware export a pci irq routing table, we no longer need pci
   irq routing fixup in kernel's code.
3, Firmware has a built-in vga bios, and its address is exported,
   the linux kernel no longer need an embedded blob.

With the new interface, Loongson-3A/2G and all their successors can use
a unified kernel. All Loongson-based machines support this new interface
except 2E/2F series.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Hongliang Tao <taohl@lemote.com>
Signed-off-by: Hua Yan <yanh@lemote.com>
---
 arch/mips/include/asm/mach-loongson/boot_param.h |  151 ++++++++++++++++++++++
 arch/mips/include/asm/mach-loongson/loongson.h   |    4 +-
 arch/mips/loongson/common/env.c                  |   67 ++++++++--
 arch/mips/loongson/common/init.c                 |    9 +-
 arch/mips/loongson/common/mem.c                  |   42 ++++++
 arch/mips/loongson/common/pci.c                  |    6 +-
 arch/mips/loongson/common/reset.c                |   14 ++
 7 files changed, 273 insertions(+), 20 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-loongson/boot_param.h

diff --git a/arch/mips/include/asm/mach-loongson/boot_param.h b/arch/mips/include/asm/mach-loongson/boot_param.h
new file mode 100644
index 0000000..9ab243c
--- /dev/null
+++ b/arch/mips/include/asm/mach-loongson/boot_param.h
@@ -0,0 +1,151 @@
+#ifndef __ASM_MACH_LOONGSON_BOOT_PARAM_H_
+#define __ASM_MACH_LOONGSON_BOOT_PARAM_H_
+
+#define SYSTEM_RAM_LOW		1
+#define SYSTEM_RAM_HIGH		2
+#define MEM_RESERVED		3
+#define PCI_IO			4
+#define PCI_MEM			5
+#define LOONGSON_CFG_REG	6
+#define VIDEO_ROM		7
+#define ADAPTER_ROM		8
+#define ACPI_TABLE		9
+#define MAX_MEMORY_TYPE		10
+
+#define LOONGSON3_BOOT_MEM_MAP_MAX 128
+struct efi_memory_map_loongson{
+	u16 vers;	/* version of efi_memory_map */
+	u32 nr_map;	/* number of memory_maps */
+	u32 mem_freq;	/* memory frequence */
+	struct mem_map{
+		u32 node_id;	/* node_id which memory attached to */
+		u32 mem_type;	/* system memory, pci memory, pci io, etc. */
+		u64 mem_start;	/* memory map start address */
+		u32 mem_size;	/* each memory_map size, not the total size */
+	}map[LOONGSON3_BOOT_MEM_MAP_MAX];
+}__attribute__((packed));
+
+enum loongson_cpu_type
+{
+	Loongson_2E,
+	Loongson_2F,
+	Loongson_3A,
+	Loongson_3B,
+	Loongson_1A,
+	Loongson_1B
+};
+
+/*
+ * Capability and feature descriptor structure for MIPS CPU
+ */
+struct efi_cpuinfo_loongson {
+	u16 vers;     /* version of efi_cpuinfo_loongson */
+	u32 processor_id; /* PRID, e.g. 6305, 6306 */
+	enum loongson_cpu_type cputype; /* 3A, 3B, etc. */
+	u32 total_node;   /* num of total numa nodes */
+	u32 cpu_startup_core_id; /* Core id: */
+	u32 cpu_clock_freq; /* cpu_clock */
+	u32 nr_cpus;
+}__attribute__((packed));
+
+struct system_loongson{
+	u16 vers;     /* version of system_loongson */
+	u32 ccnuma_smp; /* 0:no numa; 1: has numa */
+	u32 sing_double_channel; /* 1:single; 2:double */
+}__attribute__((packed));
+
+struct irq_source_routing_table {
+	u16 vers;
+	u16 size;
+	u16 rtr_bus;
+	u16 rtr_devfn;
+	u32 vendor;
+	u32 device;
+	u32 PIC_type;   /* conform use HT or PCI to route to CPU-PIC */
+	u64 ht_int_bit; /* 3A: 1<<24; 3B:1<<16 */
+	u64 ht_enable;  /* irqs used in this PIC.eg:3a-0x0000d17a */
+	u32 node_id;    /* node id, 0x0—0, 0x1—1; 0x10—2；0x11—3；0x100—4 */
+	u64 pci_mem_start_addr;
+	u64 pci_mem_end_addr;
+	u64 pci_io_start_addr;
+	u64 pci_io_end_addr;
+	u64 pci_config_addr;
+}__attribute__((packed));
+
+struct interface_info{
+	u16 vers; /* version of the specificition */
+	u16 size;
+	u8  flag;
+	char description[64];
+}__attribute__((packed));
+
+#define MAX_RESOURCE_NUMBER 128
+struct resource_loongson {
+	u64 start; /* resource start address */
+	u64 end;   /* resource end address */
+	char name[64];
+	u32 flags;
+};
+
+struct archdev_data {};  /* arch specific additions */
+
+struct board_devices{
+	char name[64];    /* hold the device name */
+	u32 num_resources; /* number of device_resource */
+	struct resource_loongson resource[MAX_RESOURCE_NUMBER]; /* for each device's resource */
+	/* arch specific additions */
+	struct archdev_data archdata;
+};
+
+struct loongson_special_attribute{
+	u16 vers;     /* version of this special */
+	char special_name[64]; /* special_atribute_name */
+	u32 loongson_special_type; /* type of special device */
+	struct resource_loongson resource[MAX_RESOURCE_NUMBER]; /* for each device's resource */
+};
+
+struct loongson_params{
+	u64 memory_offset;	/* efi_memory_map_loongson struct offset */
+	u64 cpu_offset;		/* efi_cpuinfo_loongson struct offset */
+	u64 system_offset;  	/* system_loongson struct offset */
+	u64 irq_offset;  	/* irq_source_routing_table struct offset */
+	u64 interface_offset;  	/* interface_info struct offset */
+	u64 special_offset;  	/* loongson_special_attribute struct offset */
+	u64 boarddev_table_offset;  /* board_devices offset */
+};
+
+struct smbios_tables {
+	u16 vers;     /* version of smbios */
+	u64 vga_bios; /* vga_bios address */
+	struct loongson_params lp;
+};
+
+struct efi_reset_system_t{
+	u64 ResetCold;
+	u64 ResetWarm;
+	u64 ResetType;
+	u64 Shutdown;
+};
+
+struct efi_loongson {
+	u64 mps;	/* MPS table */
+	u64 acpi;	/* ACPI table (IA64 ext 0.71) */
+	u64 acpi20;	/* ACPI table (ACPI 2.0) */
+	struct smbios_tables smbios;	/* SM BIOS table */
+	u64 sal_systab;	/* SAL system table */
+	u64 boot_info;	/* boot info table */
+};
+
+struct boot_params{
+	struct efi_loongson efi;
+	struct efi_reset_system_t reset_system;
+};
+
+extern u32 nr_cpus_loongson;
+extern enum loongson_cpu_type cputype;
+extern struct efi_memory_map_loongson *emap;
+extern u64 ht_control_base;
+extern u64 pci_mem_start_addr, pci_mem_end_addr;
+extern u64 loongson_pciio_base;
+extern u64 vgabios_addr;
+#endif
diff --git a/arch/mips/include/asm/mach-loongson/loongson.h b/arch/mips/include/asm/mach-loongson/loongson.h
index 1e29b9d..7efb911 100644
--- a/arch/mips/include/asm/mach-loongson/loongson.h
+++ b/arch/mips/include/asm/mach-loongson/loongson.h
@@ -23,8 +23,8 @@ extern void mach_prepare_reboot(void);
 extern void mach_prepare_shutdown(void);
 
 /* environment arguments from bootloader */
-extern unsigned long cpu_clock_freq;
-extern unsigned long memsize, highmemsize;
+extern u32 cpu_clock_freq;
+extern u32 memsize, highmemsize;
 
 /* loongson-specific command line, env and memory initialization */
 extern void __init prom_init_memory(void);
diff --git a/arch/mips/loongson/common/env.c b/arch/mips/loongson/common/env.c
index d93830a..d2d8613 100644
--- a/arch/mips/loongson/common/env.c
+++ b/arch/mips/loongson/common/env.c
@@ -18,37 +18,53 @@
  * option) any later version.
  */
 #include <linux/module.h>
-
 #include <asm/bootinfo.h>
-
 #include <loongson.h>
+#include <boot_param.h>
+
+struct boot_params *boot_p;
+struct loongson_params *loongson_p;
+
+struct efi_cpuinfo_loongson *ecpu;
+struct efi_memory_map_loongson *emap;
+struct system_loongson *esys;
+struct irq_source_routing_table *eirq_source;
+
+u64 ht_control_base;
+u64 pci_mem_start_addr, pci_mem_end_addr;
+u64 loongson_pciio_base;
+u64 vgabios_addr;
+u64 poweroff_addr, restart_addr;
 
-unsigned long cpu_clock_freq;
+enum loongson_cpu_type cputype;
+unsigned int nr_cpus_loongson = NR_CPUS;
+
+u32 cpu_clock_freq;
 EXPORT_SYMBOL(cpu_clock_freq);
-unsigned long memsize, highmemsize;
 
 #define parse_even_earlier(res, option, p)				\
 do {									\
 	unsigned int tmp __maybe_unused;				\
 									\
 	if (strncmp(option, (char *)p, strlen(option)) == 0)		\
-		tmp = strict_strtol((char *)p + strlen(option"="), 10, &res); \
+		tmp = kstrtou32((char *)p + strlen(option"="), 10, &res); \
 } while (0)
 
 void __init prom_init_env(void)
 {
 	/* pmon passes arguments in 32bit pointers */
-	int *_prom_envp;
-	unsigned long bus_clock;
 	unsigned int processor_id;
+
+#ifndef CONFIG_UEFI_FIRMWARE_INTERFACE
+	int *_prom_envp;
 	long l;
+	extern u32 memsize, highmemsize;
 
 	/* firmware arguments are initialized in head.S */
 	_prom_envp = (int *)fw_arg2;
 
 	l = (long)*_prom_envp;
 	while (l != 0) {
-		parse_even_earlier(bus_clock, "busclock", l);
 		parse_even_earlier(cpu_clock_freq, "cpuclock", l);
 		parse_even_earlier(memsize, "memsize", l);
 		parse_even_earlier(highmemsize, "highmemsize", l);
@@ -57,8 +73,32 @@ void __init prom_init_env(void)
 	}
 	if (memsize == 0)
 		memsize = 256;
-	if (bus_clock == 0)
-		bus_clock = 66000000;
+#else
+	/* firmware arguments are initialized in head.S */
+	boot_p = (struct boot_params *)fw_arg2;
+	loongson_p = &(boot_p->efi.smbios.lp);
+
+	ecpu	= (struct efi_cpuinfo_loongson *)((u64)loongson_p + loongson_p->cpu_offset);
+	emap 	= (struct efi_memory_map_loongson *)((u64)loongson_p + loongson_p->memory_offset);
+	eirq_source = (struct irq_source_routing_table *)((u64)loongson_p + loongson_p->irq_offset);
+
+	cputype = ecpu->cputype;
+	nr_cpus_loongson = ecpu->nr_cpus;
+	cpu_clock_freq = ecpu->cpu_clock_freq;
+	if (nr_cpus_loongson > NR_CPUS || nr_cpus_loongson == 0)
+		nr_cpus_loongson = NR_CPUS;
+
+	pci_mem_start_addr = eirq_source->pci_mem_start_addr;
+	pci_mem_end_addr = eirq_source->pci_mem_end_addr;
+	loongson_pciio_base = eirq_source->pci_io_start_addr;
+
+	poweroff_addr = boot_p->reset_system.Shutdown;
+	restart_addr = boot_p->reset_system.ResetWarm;
+	pr_info("Shutdown Addr: %llx Reset Addr: %llx\n", poweroff_addr, restart_addr);
+
+	ht_control_base = 0x90000EFDFB000000; /* has no interface now */
+	vgabios_addr = boot_p->efi.smbios.vga_bios;
+#endif
 	if (cpu_clock_freq == 0) {
 		processor_id = (&current_cpu_data)->processor_id;
 		switch (processor_id & PRID_REV_MASK) {
@@ -68,12 +108,13 @@ void __init prom_init_env(void)
 		case PRID_REV_LOONGSON2F:
 			cpu_clock_freq = 797000000;
 			break;
+		case PRID_REV_LOONGSON3A:
+			cpu_clock_freq = 900000000;
+			break;
 		default:
 			cpu_clock_freq = 100000000;
 			break;
 		}
 	}
-
-	pr_info("busclock=%ld, cpuclock=%ld, memsize=%ld, highmemsize=%ld\n",
-		bus_clock, cpu_clock_freq, memsize, highmemsize);
+	pr_info("CpuClock = %u\n", cpu_clock_freq);
 }
diff --git a/arch/mips/loongson/common/init.c b/arch/mips/loongson/common/init.c
index 19d3415..1c29b19 100644
--- a/arch/mips/loongson/common/init.c
+++ b/arch/mips/loongson/common/init.c
@@ -17,10 +17,6 @@ unsigned long __maybe_unused _loongson_addrwincfg_base;
 
 void __init prom_init(void)
 {
-	/* init base address of io space */
-	set_io_port_base((unsigned long)
-		ioremap(LOONGSON_PCIIO_BASE, LOONGSON_PCIIO_SIZE));
-
 #ifdef CONFIG_CPU_SUPPORTS_ADDRWINCFG
 	_loongson_addrwincfg_base = (unsigned long)
 		ioremap(LOONGSON_ADDRWINCFG_BASE, LOONGSON_ADDRWINCFG_SIZE);
@@ -28,6 +24,11 @@ void __init prom_init(void)
 
 	prom_init_cmdline();
 	prom_init_env();
+
+	/* init base address of io space */
+	set_io_port_base((unsigned long)
+		ioremap(LOONGSON_PCIIO_BASE, LOONGSON_PCIIO_SIZE));
+
 	prom_init_memory();
 
 	/*init the uart base address */
diff --git a/arch/mips/loongson/common/mem.c b/arch/mips/loongson/common/mem.c
index 30eba60..8a24b04 100644
--- a/arch/mips/loongson/common/mem.c
+++ b/arch/mips/loongson/common/mem.c
@@ -11,9 +11,14 @@
 #include <asm/bootinfo.h>
 
 #include <loongson.h>
+#include <boot_param.h>
 #include <mem.h>
 #include <pci.h>
 
+#ifndef CONFIG_UEFI_FIRMWARE_INTERFACE
+
+u32 memsize, highmemsize;
+
 void __init prom_init_memory(void)
 {
 	add_memory_region(0x0, (memsize << 20), BOOT_MEM_RAM);
@@ -49,6 +54,43 @@ void __init prom_init_memory(void)
 #endif /* !CONFIG_64BIT */
 }
 
+#else /* CONFIG_UEFI_FIRMWARE_INTERFACE */
+
+void __init prom_init_memory(void)
+{
+	int i;
+	u32 node_id;
+	u32 mem_type;
+
+	/* parse memory information */
+	for (i = 0; i < emap->nr_map; i++){
+		node_id = emap->map[i].node_id;
+		mem_type = emap->map[i].mem_type;
+
+		if (node_id == 0) {
+			switch (mem_type) {
+			case SYSTEM_RAM_LOW:
+				add_memory_region(emap->map[i].mem_start,
+					emap->map[i].mem_size << 20,
+					BOOT_MEM_RAM);
+				break;
+			case SYSTEM_RAM_HIGH:
+				add_memory_region(emap->map[i].mem_start,
+					emap->map[i].mem_size << 20,
+					BOOT_MEM_RAM);
+				break;
+			case MEM_RESERVED:
+				add_memory_region(emap->map[i].mem_start,
+					emap->map[i].mem_size << 20,
+					BOOT_MEM_RESERVED);
+				break;
+			}
+		}
+	}
+}
+
+#endif /* CONFIG_UEFI_FIRMWARE_INTERFACE */
+
 /* override of arch/mips/mm/cache.c: __uncached_access */
 int __uncached_access(struct file *file, unsigned long addr)
 {
diff --git a/arch/mips/loongson/common/pci.c b/arch/mips/loongson/common/pci.c
index 31d8c5e..0da387a 100644
--- a/arch/mips/loongson/common/pci.c
+++ b/arch/mips/loongson/common/pci.c
@@ -11,6 +11,7 @@
 
 #include <pci.h>
 #include <loongson.h>
+#include <boot_param.h>
 
 static struct resource loongson_pci_mem_resource = {
 	.name   = "pci memory space",
@@ -82,7 +83,10 @@ static int __init pcibios_init(void)
 	setup_pcimap();
 
 	loongson_pci_controller.io_map_base = mips_io_port_base;
-
+#ifdef CONFIG_UEFI_FIRMWARE_INTERFACE
+	loongson_pci_mem_resource.start = pci_mem_start_addr;
+	loongson_pci_mem_resource.end = pci_mem_end_addr;
+#endif
 	register_pci_controller(&loongson_pci_controller);
 
 	return 0;
diff --git a/arch/mips/loongson/common/reset.c b/arch/mips/loongson/common/reset.c
index 9e10d62..55c666b 100644
--- a/arch/mips/loongson/common/reset.c
+++ b/arch/mips/loongson/common/reset.c
@@ -36,17 +36,31 @@ static inline void loongson_reboot(void)
 
 static void loongson_restart(char *command)
 {
+#ifndef CONFIG_UEFI_FIRMWARE_INTERFACE
 	/* do preparation for reboot */
 	mach_prepare_reboot();
 
 	/* reboot via jumping to boot base address */
 	loongson_reboot();
+#else
+	extern u64 restart_addr;
+	void (*fw_restart)(void) = (void *)restart_addr;
+
+	fw_restart();
+#endif
 }
 
 static void loongson_poweroff(void)
 {
+#ifndef CONFIG_UEFI_FIRMWARE_INTERFACE
 	mach_prepare_shutdown();
 	unreachable();
+#else
+	extern u64 poweroff_addr;
+	void (*fw_poweroff)(void) = (void *)poweroff_addr;
+
+	fw_poweroff();
+#endif
 }
 
 static void loongson_halt(void)
-- 
1.7.7.3

