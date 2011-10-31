Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab1JaRHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:07:25 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42640 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab1JaRHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:07:24 -0400
Subject: [RFC PATCH v3 02/10] fadump: Reserve the memory for firmware assisted
	dump.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Amerigo Wang <amwang@redhat.com>, Milton Miller <miltonm@bga.com>,
        Anton Blanchard <anton@samba.org>
Date: Mon, 31 Oct 2011 22:36:25 +0530
Message-ID: <20111031170625.12259.60783.stgit@mars.in.ibm.com>
In-Reply-To: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
References: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11103107-5140-0000-0000-00000023C426
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

Reserve the memory during early boot to preserve CPU state data, HPTE region
and RMR region data in case of kernel crash. At the time of crash, powerpc
firmware will store CPU state data, HPTE region data and move RMR region
data to the reserved memory area.

If the firmware-assisted dump fails to reserve the memory, then fallback
to existing kexec-based kdump.

The most of the code implementation to reserve memory has been
adapted from phyp assisted dump implementation written by Linas Vepstas
and Manish Ahuja

Change in v2:
- Modified to use standard pr_debug() macro.
- Modified early_init_dt_scan_fw_dump() to get the size of
  "ibm,configure-kernel-dump-sizes" property and use it to iterate through
  an array of dump sections.
- Introduced boot option 'fadump_reserve_mem=' to let user specify the
  fadump boot memory to be reserved.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/fadump.h |   65 ++++++++++
 arch/powerpc/kernel/Makefile      |    1 
 arch/powerpc/kernel/fadump.c      |  250 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/prom.c        |   15 ++
 4 files changed, 330 insertions(+), 1 deletions(-)
 create mode 100644 arch/powerpc/include/asm/fadump.h
 create mode 100644 arch/powerpc/kernel/fadump.c

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
new file mode 100644
index 0000000..0b040c1
--- /dev/null
+++ b/arch/powerpc/include/asm/fadump.h
@@ -0,0 +1,65 @@
+/*
+ * Firmware Assisted dump header file.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright 2011 IBM Corporation
+ * Author: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
+ */
+
+#ifndef __PPC64_FA_DUMP_H__
+#define __PPC64_FA_DUMP_H__
+
+#ifdef CONFIG_FA_DUMP
+
+/*
+ * The RMR region will be saved for later dumping when kernel crashes.
+ * Set this to 256MB.
+ */
+#define RMR_START	0x0
+#define RMR_END		(ppc64_rma_size)
+
+/*
+ * On some Power systems where RMO is 128MB, it still requires minimum of
+ * 256MB for kernel to boot successfully.
+ */
+#define MIN_BOOT_MEM	((RMR_END < (0x1UL << 28)) ? (0x1UL << 28) : RMR_END)
+
+/* Firmware provided dump sections */
+#define FADUMP_CPU_STATE_DATA	0x0001
+#define FADUMP_HPTE_REGION	0x0002
+#define FADUMP_REAL_MODE_REGION	0x0011
+
+struct fw_dump {
+	unsigned long	cpu_state_data_size;
+	unsigned long	hpte_region_size;
+	unsigned long	boot_memory_size;
+	unsigned long	reserve_dump_area_start;
+	unsigned long	reserve_dump_area_size;
+	/* cmd line option during boot */
+	unsigned long	reserve_bootvar;
+
+	int		ibm_configure_kernel_dump;
+
+	unsigned long	fadump_enabled:1;
+	unsigned long	fadump_supported:1;
+	unsigned long	dump_active:1;
+};
+
+extern int early_init_dt_scan_fw_dump(unsigned long node,
+		const char *uname, int depth, void *data);
+extern int fadump_reserve_mem(void);
+#endif
+#endif
diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
index ce4f7f1..59b549c 100644
--- a/arch/powerpc/kernel/Makefile
+++ b/arch/powerpc/kernel/Makefile
@@ -60,6 +60,7 @@ obj-$(CONFIG_IBMVIO)		+= vio.o
 obj-$(CONFIG_IBMEBUS)           += ibmebus.o
 obj-$(CONFIG_GENERIC_TBSYNC)	+= smp-tbsync.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
+obj-$(CONFIG_FA_DUMP)		+= fadump.o
 ifeq ($(CONFIG_PPC32),y)
 obj-$(CONFIG_E500)		+= idle_e500.o
 endif
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
new file mode 100644
index 0000000..05dffc0
--- /dev/null
+++ b/arch/powerpc/kernel/fadump.c
@@ -0,0 +1,250 @@
+/*
+ * Firmware Assisted dump: A robust mechanism to get reliable kernel crash
+ * dump with assistance from firmware. This approach does not use kexec,
+ * instead firmware assists in booting the kdump kernel while preserving
+ * memory contents. The most of the code implementation has been adapted
+ * from phyp assisted dump implementation written by Linas Vepstas and
+ * Manish Ahuja
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright 2011 IBM Corporation
+ * Author: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
+ */
+
+#undef DEBUG
+#define pr_fmt(fmt) "fadump: " fmt
+
+#include <linux/string.h>
+#include <linux/memblock.h>
+
+#include <asm/page.h>
+#include <asm/prom.h>
+#include <asm/rtas.h>
+#include <asm/fadump.h>
+
+/*
+ * The RTAS property "ibm,configure-kernel-dump-sizes" returns dump
+ * sizes for the firmware provided dump sections (cpu state data
+ * and hpte region).
+ */
+struct dump_section {
+	u32		dump_section;
+	unsigned long	section_size;
+} __packed;
+
+static struct fw_dump fw_dump;
+
+/* Scan the Firmware Assisted dump configuration details. */
+int __init early_init_dt_scan_fw_dump(unsigned long node,
+			const char *uname, int depth, void *data)
+{
+	const struct dump_section *sections;
+	int i, num_sections;
+	unsigned long size;
+	const int *token;
+
+	if (depth != 1 || strcmp(uname, "rtas") != 0)
+		return 0;
+
+	/*
+	 * Check if Firmware Assisted dump is supported. if yes, check
+	 * if dump has been initiated on last reboot.
+	 */
+	token = of_get_flat_dt_prop(node, "ibm,configure-kernel-dump", NULL);
+	if (!token)
+		return 0;
+
+	fw_dump.fadump_supported = 1;
+	fw_dump.ibm_configure_kernel_dump = *token;
+
+	/*
+	 * The 'ibm,kernel-dump' rtas node is present only if there is
+	 * dump data waiting for us.
+	 */
+	if (of_get_flat_dt_prop(node, "ibm,kernel-dump", NULL))
+		fw_dump.dump_active = 1;
+
+	/* Get the sizes required to store dump data for the firmware provided
+	 * dump sections.
+	 */
+	sections = of_get_flat_dt_prop(node, "ibm,configure-kernel-dump-sizes",
+					&size);
+
+	if (!sections)
+		return 0;
+
+	num_sections = size / sizeof(struct dump_section);
+
+	for (i = 0; i < num_sections; i++) {
+		switch (sections[i].dump_section) {
+		case FADUMP_CPU_STATE_DATA:
+			fw_dump.cpu_state_data_size = sections[i].section_size;
+			break;
+		case FADUMP_HPTE_REGION:
+			fw_dump.hpte_region_size = sections[i].section_size;
+			break;
+		}
+	}
+	return 1;
+}
+
+/**
+ * calculate_reserve_size() - reserve variable boot area 5% of System RAM
+ *
+ * Function to find the largest memory size we need to reserve during early
+ * boot process. This will be the size of the memory that is required for a
+ * kernel to boot successfully.
+ *
+ * This function has been taken from phyp-assisted dump feature implementation.
+ *
+ * returns larger of 256MB or 5% rounded down to multiples of 256MB.
+ *
+ * TODO: Come up with better approach to find out more accurate memory size
+ * that is required for a kernel to boot successfully.
+ *
+ */
+static inline unsigned long calculate_reserve_size(void)
+{
+	unsigned long size;
+
+	/*
+	 * Check if the size is specified through fadump_reserve_mem= cmdline
+	 * option. If yes, then use that.
+	 */
+	if (fw_dump.reserve_bootvar)
+		return fw_dump.reserve_bootvar;
+
+	/* divide by 20 to get 5% of value */
+	size = memblock_end_of_DRAM();
+	do_div(size, 20);
+
+	/* round it down in multiples of 256 */
+	size = size & ~0x0FFFFFFFUL;
+
+	/* Truncate to memory_limit. We don't want to over reserve the memory.*/
+	if (memory_limit && size > memory_limit)
+		size = memory_limit;
+
+	return (size > MIN_BOOT_MEM ? size : MIN_BOOT_MEM);
+}
+
+/*
+ * Calculate the total memory size required to be reserved for
+ * firmware-assisted dump registration.
+ */
+static unsigned long get_dump_area_size(void)
+{
+	unsigned long size = 0;
+
+	size += fw_dump.cpu_state_data_size;
+	size += fw_dump.hpte_region_size;
+	size += fw_dump.boot_memory_size;
+
+	size = PAGE_ALIGN(size);
+	return size;
+}
+
+int __init fadump_reserve_mem(void)
+{
+	unsigned long base, size, memory_boundary;
+
+	if (!fw_dump.fadump_enabled)
+		return 0;
+
+	if (!fw_dump.fadump_supported) {
+		printk(KERN_ERR "Firmware-assisted dump is not supported on"
+				" this hardware\n");
+		fw_dump.fadump_enabled = 0;
+		return 0;
+	}
+	/* Initialize boot memory size */
+	fw_dump.boot_memory_size = calculate_reserve_size();
+
+	/*
+	 * Calculate the memory boundary.
+	 * If memory_limit is less than actual memory boundary then reserve
+	 * the memory for fadump beyond the memory_limit and adjust the
+	 * memory_limit accordingly, so that the running kernel can run with
+	 * specified memory_limit.
+	 */
+	if (memory_limit && memory_limit < memblock_end_of_DRAM()) {
+		size = get_dump_area_size();
+		if ((memory_limit + size) < memblock_end_of_DRAM())
+			memory_limit += size;
+		else
+			memory_limit = memblock_end_of_DRAM();
+		printk(KERN_INFO "Adjusted memory_limit for firmware-assisted"
+				" dump, now %#016llx\n",
+				(unsigned long long)memory_limit);
+	}
+	if (memory_limit)
+		memory_boundary = memory_limit;
+	else
+		memory_boundary = memblock_end_of_DRAM();
+
+	if (fw_dump.dump_active) {
+		printk(KERN_INFO "Firmware-assisted dump is active.\n");
+		/*
+		 * If last boot has crashed then reserve all the memory
+		 * above boot_memory_size so that we don't touch it until
+		 * dump is written to disk by userspace tool. This memory
+		 * will be released for general use once the dump is saved.
+		 */
+		base = fw_dump.boot_memory_size;
+		size = memory_boundary - base;
+		memblock_reserve(base, size);
+		printk(KERN_INFO "Reserved %ldMB of memory at %ldMB "
+				"for saving crash dump\n",
+				(unsigned long)(size >> 20),
+				(unsigned long)(base >> 20));
+	} else {
+		/* Reserve the memory at the top of memory. */
+		size = get_dump_area_size();
+		base = memory_boundary - size;
+		memblock_reserve(base, size);
+		printk(KERN_INFO "Reserved %ldMB of memory at %ldMB "
+				"for firmware-assisted dump\n",
+				(unsigned long)(size >> 20),
+				(unsigned long)(base >> 20));
+	}
+	fw_dump.reserve_dump_area_start = base;
+	fw_dump.reserve_dump_area_size = size;
+	return 1;
+}
+
+/* Look for fadump= cmdline option. */
+static int __init early_fadump_param(char *p)
+{
+	if (!p)
+		return 1;
+
+	if (p[0] == '1')
+		fw_dump.fadump_enabled = 1;
+	else if (p[0] == '0')
+		fw_dump.fadump_enabled = 0;
+
+	return 0;
+}
+early_param("fadump", early_fadump_param);
+
+/* Look for fadump_reserve_mem= cmdline option */
+static int __init early_fadump_reserve_mem(char *p)
+{
+	if (p)
+		fw_dump.reserve_bootvar = memparse(p, &p);
+	return 0;
+}
+early_param("fadump_reserve_mem", early_fadump_reserve_mem);
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 174e1e9..3fe75eb 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -54,6 +54,7 @@
 #include <asm/pci-bridge.h>
 #include <asm/phyp_dump.h>
 #include <asm/kexec.h>
+#include <asm/fadump.h>
 #include <mm/mmu_decl.h>
 
 #ifdef DEBUG
@@ -712,6 +713,11 @@ void __init early_init_devtree(void *params)
 	of_scan_flat_dt(early_init_dt_scan_phyp_dump, NULL);
 #endif
 
+#ifdef CONFIG_FA_DUMP
+	/* scan tree to see if dump is active during last boot */
+	of_scan_flat_dt(early_init_dt_scan_fw_dump, NULL);
+#endif
+
 	/* Retrieve various informations from the /chosen node of the
 	 * device-tree, including the platform type, initrd location and
 	 * size, TCE reserve, and more ...
@@ -735,7 +741,14 @@ void __init early_init_devtree(void *params)
 	if (PHYSICAL_START > MEMORY_START)
 		memblock_reserve(MEMORY_START, 0x8000);
 	reserve_kdump_trampoline();
-	reserve_crashkernel();
+#ifdef CONFIG_FA_DUMP
+	/*
+	 * If we fail to reserve memory for firmware-assisted dump then
+	 * fallback to kexec based kdump.
+	 */
+	if (fadump_reserve_mem() == 0)
+#endif
+		reserve_crashkernel();
 	early_reserve_mem();
 	phyp_dump_reserve_mem();
 

