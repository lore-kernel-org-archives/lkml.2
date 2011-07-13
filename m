Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757346Ab1GMSHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 14:07:18 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34522 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757254Ab1GMSHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 14:07:12 -0400
Subject: [RFC PATCH 03/10] fadump: Register for firmware assisted dump.
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Michael Ellerman <michael@ellerman.id.au>, Haren Myneni <hbabu@us.ibm.com>,
        Anton Blanchard <anton@samba.org>, Milton Miller <miltonm@bga.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 13 Jul 2011 23:37:07 +0530
Message-ID: <20110713180705.6210.44160.stgit@mars.in.ibm.com>
In-Reply-To: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
References: <20110713180252.6210.34810.stgit@mars.in.ibm.com>
User-Agent: StGit/0.15-1-ged5e-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>

This patch registers for firmware-assisted dump using rtas token
ibm,configure-kernel-dump. During registration firmware is informed about
the reserved area where it saves the CPU state data, HPTE table and contents
of RMR region at the time of kernel crash. Apart from this, firmware also
preserves the contents of entire partition memory even if it is not specified
during registration.

This patch also populates sysfs files under /sys/kernel to display
fadump status and reserved memory regions.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/fadump.h |   55 ++++++
 arch/powerpc/kernel/fadump.c      |  336 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/setup_64.c    |    8 +
 arch/powerpc/mm/hash_utils_64.c   |   11 +
 4 files changed, 407 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
index 08ef997..5568789 100644
--- a/arch/powerpc/include/asm/fadump.h
+++ b/arch/powerpc/include/asm/fadump.h
@@ -36,6 +36,58 @@
 #define FADUMP_HPTE_REGION	0x0002
 #define FADUMP_REAL_MODE_REGION	0x0011
 
+/* Dump request flag */
+#define FADUMP_REQUEST_FLAG	0x00000001
+
+/* FAD commands */
+#define FADUMP_REGISTER	1
+#define FADUMP_UNREGISTER	2
+#define FADUMP_INVALIDATE	3
+
+/* Kernel Dump section info */
+struct fadump_section {
+	u32	request_flag;
+	u16	source_data_type;
+	u16	error_flags;
+	u64	source_address;
+	u64	source_len;
+	u64	bytes_dumped;
+	u64	destination_address;
+};
+
+/* ibm,configure-kernel-dump header. */
+struct fadump_section_header {
+	u32	dump_format_version;
+	u16	dump_num_sections;
+	u16	dump_status_flag;
+	u32	offset_first_dump_section;
+
+	/* Fields for disk dump option. */
+	u32	dd_block_size;
+	u64	dd_block_offset;
+	u64	dd_num_blocks;
+	u32	dd_offset_disk_path;
+
+	/* Maximum time allowed to prevent an automatic dump-reboot. */
+	u32	max_time_auto;
+};
+
+/*
+ * Firmware Assisted dump memory structure. This structure is required for
+ * registering future kernel dump with power firmware through rtas call.
+ *
+ * No disk dump option. Hence disk dump path string section is not included.
+ */
+struct fadump_mem_struct {
+	struct fadump_section_header	header;
+
+	/* Kernel dump sections */
+	struct fadump_section		cpu_state_data;
+	struct fadump_section		hpte_region;
+	struct fadump_section		rmr_region;
+};
+
+/* Firmware-assisted dump configuration details. */
 struct fw_dump {
 	unsigned long	cpu_state_data_size;
 	unsigned long	hpte_region_size;
@@ -47,10 +99,13 @@ struct fw_dump {
 	unsigned long	fadump_enabled:1;
 	unsigned long	fadump_supported:1;
 	unsigned long	dump_active:1;
+	unsigned long	dump_registered:1;
 };
 
 extern int early_init_dt_scan_fw_dump(unsigned long node,
 		const char *uname, int depth, void *data);
 extern int fadump_reserve_mem(void);
+extern int setup_fadump(void);
+extern int is_fadump_active(void);
 #endif
 #endif
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 446dcdc..0130ed7 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -28,6 +28,7 @@
 
 #include <linux/string.h>
 #include <linux/memblock.h>
+#include <linux/delay.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -55,6 +56,8 @@ struct dump_section {
 
 /* Global variable to hold firmware assisted dump configuration info. */
 static struct fw_dump fw_dump;
+static struct fadump_mem_struct fdm;
+static const struct fadump_mem_struct *fdm_active;
 
 /* Scan the Firmware Assisted dump configuration details. */
 int __init early_init_dt_scan_fw_dump(unsigned long node,
@@ -82,7 +85,8 @@ int __init early_init_dt_scan_fw_dump(unsigned long node,
 	 * The 'ibm,kernel-dump' rtas node is present only if there is
 	 * dump data waiting for us.
 	 */
-	if (of_get_flat_dt_prop(node, "ibm,kernel-dump", NULL))
+	fdm_active = of_get_flat_dt_prop(node, "ibm,kernel-dump", NULL);
+	if (fdm_active)
 		fw_dump.dump_active = 1;
 
 	/* Get the sizes required to store dump data for the firmware provided
@@ -107,6 +111,163 @@ int __init early_init_dt_scan_fw_dump(unsigned long node,
 	return 1;
 }
 
+int is_fadump_active(void)
+{
+	return fw_dump.dump_active;
+}
+
+/* Print firmware assisted dump configurations for debugging purpose. */
+static void fadump_show_config(void)
+{
+	DBG("Support for firmware-assisted dump (fadump): %s\n",
+			(fw_dump.fadump_supported ? "present" : "no support"));
+
+	if (!fw_dump.fadump_supported)
+		return;
+
+	DBG("Fadump enabled    : %s\n",
+				(fw_dump.fadump_enabled ? "yes" : "no"));
+	DBG("Dump Active       : %s\n", (fw_dump.dump_active ? "yes" : "no"));
+	DBG("Dump section sizes:\n");
+	DBG("	CPU state data size: %lx\n", fw_dump.cpu_state_data_size);
+	DBG("	HPTE region size   : %lx\n", fw_dump.hpte_region_size);
+	DBG("Boot memory size  : %lx\n", fw_dump.boot_memory_size);
+	DBG("Reserve area start: %lx\n", fw_dump.reserve_dump_area_start);
+	DBG("Reserve area size : %lx\n", fw_dump.reserve_dump_area_size);
+}
+
+static void show_fadump_mem_struct(const struct fadump_mem_struct *fdm)
+{
+	if (!fdm)
+		return;
+
+	DBG("--------Firmware-assisted dump memory structure---------\n");
+	DBG("header.dump_format_version        : 0x%08x\n",
+					fdm->header.dump_format_version);
+	DBG("header.dump_num_sections          : %d\n",
+					fdm->header.dump_num_sections);
+	DBG("header.dump_status_flag           : 0x%04x\n",
+					fdm->header.dump_status_flag);
+	DBG("header.offset_first_dump_section  : 0x%x\n",
+					fdm->header.offset_first_dump_section);
+
+	DBG("header.dd_block_size              : %d\n",
+					fdm->header.dd_block_size);
+	DBG("header.dd_block_offset            : 0x%Lx\n",
+					fdm->header.dd_block_offset);
+	DBG("header.dd_num_blocks              : %Lx\n",
+					fdm->header.dd_num_blocks);
+	DBG("header.dd_offset_disk_path        : 0x%x\n",
+					fdm->header.dd_offset_disk_path);
+
+	DBG("header.max_time_auto              : %d\n",
+					fdm->header.max_time_auto);
+
+	/* Kernel dump sections */
+	DBG("cpu_state_data.request_flag       : 0x%08x\n",
+					fdm->cpu_state_data.request_flag);
+	DBG("cpu_state_data.source_data_type   : 0x%04x\n",
+					fdm->cpu_state_data.source_data_type);
+	DBG("cpu_state_data.error_flags        : 0x%04x\n",
+					fdm->cpu_state_data.error_flags);
+	DBG("cpu_state_data.source_address     : 0x%016Lx\n",
+					fdm->cpu_state_data.source_address);
+	DBG("cpu_state_data.source_len         : 0x%Lx\n",
+					fdm->cpu_state_data.source_len);
+	DBG("cpu_state_data.bytes_dumped       : 0x%Lx\n",
+					fdm->cpu_state_data.bytes_dumped);
+	DBG("cpu_state_data.destination_address: 0x%016Lx\n",
+				fdm->cpu_state_data.destination_address);
+
+	DBG("hpte_region.request_flag          : 0x%08x\n",
+					fdm->hpte_region.request_flag);
+	DBG("hpte_region.source_data_type      : 0x%04x\n",
+					fdm->hpte_region.source_data_type);
+	DBG("hpte_region.error_flags           : 0x%04x\n",
+					fdm->hpte_region.error_flags);
+	DBG("hpte_region.source_address        : 0x%016Lx\n",
+					fdm->hpte_region.source_address);
+	DBG("hpte_region.source_len            : 0x%Lx\n",
+					fdm->hpte_region.source_len);
+	DBG("hpte_region.bytes_dumped          : 0x%Lx\n",
+					fdm->hpte_region.bytes_dumped);
+	DBG("hpte_region.destination_address   : 0x%016Lx\n",
+				fdm->hpte_region.destination_address);
+
+	DBG("rmr_region.request_flag           : 0x%08x\n",
+					fdm->rmr_region.request_flag);
+	DBG("rmr_region.source_data_type       : 0x%04x\n",
+					fdm->rmr_region.source_data_type);
+	DBG("rmr_region.error_flags            : 0x%04x\n",
+					fdm->rmr_region.error_flags);
+	DBG("rmr_region.source_address         : 0x%016Lx\n",
+					fdm->rmr_region.source_address);
+	DBG("rmr_region.source_len             : 0x%Lx\n",
+					fdm->rmr_region.source_len);
+	DBG("rmr_region.bytes_dumped           : 0x%Lx\n",
+					fdm->rmr_region.bytes_dumped);
+	DBG("rmr_region.destination_address    : 0x%016Lx\n",
+				fdm->rmr_region.destination_address);
+
+	DBG("--------Firmware-assisted dump memory structure---------\n");
+}
+
+static unsigned long init_fadump_mem_struct(struct fadump_mem_struct *fdm,
+				unsigned long addr)
+{
+	if (!fdm)
+		return 0;
+
+	memset(fdm, 0, sizeof(struct fadump_mem_struct));
+	addr = addr & PAGE_MASK;
+
+	fdm->header.dump_format_version = 0x00000001;
+	fdm->header.dump_num_sections = 3;
+	fdm->header.dump_status_flag = 0;
+	fdm->header.offset_first_dump_section =
+		(u32)offsetof(struct fadump_mem_struct, cpu_state_data);
+
+	/*
+	 * Fields for disk dump option.
+	 * We are not using disk dump option, hence set these fields to 0.
+	 */
+	fdm->header.dd_block_size = 0;
+	fdm->header.dd_block_offset = 0;
+	fdm->header.dd_num_blocks = 0;
+	fdm->header.dd_offset_disk_path = 0;
+
+	/* set 0 to disable an automatic dump-reboot. */
+	fdm->header.max_time_auto = 0;
+
+	/* Kernel dump sections */
+	/* cpu state data section. */
+	fdm->cpu_state_data.request_flag = FADUMP_REQUEST_FLAG;
+	fdm->cpu_state_data.source_data_type = FADUMP_CPU_STATE_DATA;
+	fdm->cpu_state_data.source_address = 0;
+	fdm->cpu_state_data.source_len = fw_dump.cpu_state_data_size;
+	fdm->cpu_state_data.destination_address = addr;
+	addr += fw_dump.cpu_state_data_size;
+
+	/* hpte region section */
+	fdm->hpte_region.request_flag = FADUMP_REQUEST_FLAG;
+	fdm->hpte_region.source_data_type = FADUMP_HPTE_REGION;
+	fdm->hpte_region.source_address = 0;
+	fdm->hpte_region.source_len = fw_dump.hpte_region_size;
+	fdm->hpte_region.destination_address = addr;
+	addr += fw_dump.hpte_region_size;
+
+	/* RMR region section */
+	fdm->rmr_region.request_flag = FADUMP_REQUEST_FLAG;
+	fdm->rmr_region.source_data_type = FADUMP_REAL_MODE_REGION;
+	fdm->rmr_region.source_address = RMR_START;
+	fdm->rmr_region.source_len = fw_dump.boot_memory_size;
+	fdm->rmr_region.destination_address = addr;
+	addr += fw_dump.boot_memory_size;
+
+	show_fadump_mem_struct(fdm);
+	return addr;
+}
+
 /**
  * calculate_reserve_size() - reserve variable boot area 5% of System RAM
  *
@@ -169,8 +330,15 @@ int __init fadump_reserve_mem(void)
 		fw_dump.fadump_enabled = 0;
 		return 0;
 	}
-	/* Initialize boot memory size */
-	fw_dump.boot_memory_size = calculate_reserve_size();
+	/*
+	 * Initialize boot memory size
+	 * If dump is active then we have already calculated the size during
+	 * first kernel.
+	 */
+	if (fdm_active)
+		fw_dump.boot_memory_size = fdm_active->rmr_region.source_len;
+	else
+		fw_dump.boot_memory_size = calculate_reserve_size();
 
 	/*
 	 * Calculate the memory boundary.
@@ -238,3 +406,165 @@ static int __init early_fadump_param(char *p)
 	return 0;
 }
 early_param("fadump", early_fadump_param);
+
+static void register_fw_dump(struct fadump_mem_struct *fdm)
+{
+	int rc;
+	unsigned int wait_time;
+
+	DBG("Registering for firmware-assisted kernel dump...\n");
+
+	/* TODO: Add upper time limit for the delay */
+	do {
+		rc = rtas_call(fw_dump.ibm_configure_kernel_dump, 3, 1, NULL,
+			FADUMP_REGISTER, fdm,
+			sizeof(struct fadump_mem_struct));
+
+		wait_time = rtas_busy_delay_time(rc);
+		if (wait_time)
+			mdelay(wait_time);
+
+	} while (wait_time);
+
+	switch (rc) {
+	case -1:
+		printk(KERN_ERR "Failed to register firmware-assisted kernel"
+			" dump. Hardware Error(%d).\n", rc);
+		break;
+	case -3:
+		printk(KERN_ERR "Failed to register firmware-assisted kernel"
+			" dump. Parameter Error(%d).\n", rc);
+		break;
+	case -9:
+		printk(KERN_ERR "firmware-assisted kernel dump is already "
+			" registered.");
+		fw_dump.dump_registered = 1;
+		break;
+	case 0:
+		printk(KERN_INFO "firmware-assisted kernel dump registration"
+			" is successful\n");
+		fw_dump.dump_registered = 1;
+		break;
+	}
+}
+
+static void register_fadump(void)
+{
+	/*
+	 * If no memory is reserved then we can not register for firmware-
+	 * assisted dump.
+	 */
+	if (!fw_dump.reserve_dump_area_size)
+		return;
+
+	/* Initialize the kernel dump memory structure for FAD registration. */
+	init_fadump_mem_struct(&fdm, fw_dump.reserve_dump_area_start);
+
+	/* register the future kernel dump with firmware. */
+	register_fw_dump(&fdm);
+}
+
+static ssize_t fadump_enabled_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", fw_dump.fadump_enabled);
+}
+
+static ssize_t fadump_region_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	const struct fadump_mem_struct *fdm_ptr;
+	ssize_t n = 0;
+
+	if (!fw_dump.fadump_enabled)
+		return n;
+
+	if (fdm_active)
+		fdm_ptr = fdm_active;
+	else
+		fdm_ptr = &fdm;
+
+	n += sprintf(buf,
+			"CPU : [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			fdm_ptr->cpu_state_data.destination_address,
+			fdm_ptr->cpu_state_data.destination_address +
+			fdm_ptr->cpu_state_data.source_len - 1,
+			fdm_ptr->cpu_state_data.source_len,
+			fdm_ptr->cpu_state_data.bytes_dumped);
+	n += sprintf(buf + n,
+			"HPTE: [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			fdm_ptr->hpte_region.destination_address,
+			fdm_ptr->hpte_region.destination_address +
+			fdm_ptr->hpte_region.source_len - 1,
+			fdm_ptr->hpte_region.source_len,
+			fdm_ptr->hpte_region.bytes_dumped);
+	n += sprintf(buf + n,
+			"DUMP: [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			fdm_ptr->rmr_region.destination_address,
+			fdm_ptr->rmr_region.destination_address +
+			fdm_ptr->rmr_region.source_len - 1,
+			fdm_ptr->rmr_region.source_len,
+			fdm_ptr->rmr_region.bytes_dumped);
+
+	if (!fdm_active ||
+		(fw_dump.reserve_dump_area_start ==
+		fdm_ptr->cpu_state_data.destination_address))
+		return n;
+
+	/* Dump is active. Show reserved memory region. */
+	n += sprintf(buf + n,
+			"    : [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			(unsigned long long)fw_dump.reserve_dump_area_start,
+			fdm_ptr->cpu_state_data.destination_address - 1,
+			fdm_ptr->cpu_state_data.destination_address -
+			fw_dump.reserve_dump_area_start,
+			fdm_ptr->cpu_state_data.destination_address -
+			fw_dump.reserve_dump_area_start);
+	return n;
+}
+
+static struct kobj_attribute fadump_attr = __ATTR(fadump_enabled,
+						0444, fadump_enabled_show,
+						NULL);
+static struct kobj_attribute fadump_region_attr = __ATTR(fadump_region,
+						0444, fadump_region_show, NULL);
+
+static int fadump_init_sysfs(void)
+{
+	int rc = 0;
+
+	rc = sysfs_create_file(kernel_kobj, &fadump_attr.attr);
+	if (rc)
+		printk(KERN_ERR "fadump: unable to create sysfs file"
+			" (%d)\n", rc);
+
+	rc = sysfs_create_file(kernel_kobj, &fadump_region_attr.attr);
+	if (rc)
+		printk(KERN_ERR "fadump: unable to create sysfs file"
+			" (%d)\n", rc);
+	return rc;
+}
+subsys_initcall(fadump_init_sysfs);
+
+/*
+ * Prepare for firmware-assisted dump.
+ */
+int __init setup_fadump(void)
+{
+	if (!fw_dump.fadump_supported) {
+		printk(KERN_ERR "Firmware-assisted dump is not supported on"
+			" this hardware\n");
+		return 0;
+	}
+
+	fadump_show_config();
+	register_fadump();
+
+	return 1;
+}
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index a88bf27..3031ea7 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -63,6 +63,7 @@
 #include <asm/kexec.h>
 #include <asm/mmu_context.h>
 #include <asm/code-patching.h>
+#include <asm/fadump.h>
 
 #include "setup.h"
 
@@ -371,6 +372,13 @@ void __init setup_system(void)
 	rtas_initialize();
 #endif /* CONFIG_PPC_RTAS */
 
+#ifdef CONFIG_FA_DUMP
+	/*
+	 * Setup Firmware-assisted dump.
+	 */
+	setup_fadump();
+#endif
+
 	/*
 	 * Check if we have an initrd provided via the device-tree
 	 */
diff --git a/arch/powerpc/mm/hash_utils_64.c b/arch/powerpc/mm/hash_utils_64.c
index 26b2872..ba64f1a 100644
--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -54,6 +54,7 @@
 #include <asm/spu.h>
 #include <asm/udbg.h>
 #include <asm/code-patching.h>
+#include <asm/fadump.h>
 
 #ifdef DEBUG
 #define DBG(fmt...) udbg_printf(fmt)
@@ -627,6 +628,16 @@ static void __init htab_initialize(void)
 		/* Using a hypervisor which owns the htab */
 		htab_address = NULL;
 		_SDR1 = 0; 
+#ifdef CONFIG_FA_DUMP
+		/*
+		 * If firmware assisted dump is active firmware preserves
+		 * the contents of htab along with entire partition memory.
+		 * Clear the htab if firmware assisted dump is active so
+		 * that we dont end up using old mappings.
+		 */
+		if (is_fadump_active() && ppc_md.hpte_clear_all)
+			ppc_md.hpte_clear_all();
+#endif
 	} else {
 		/* Find storage for the HPT.  Must be contiguous in
 		 * the absolute address space. On cell we want it to be

