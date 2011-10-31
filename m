Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab1JaRIW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:08:22 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:44788 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732Ab1JaRIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:08:20 -0400
Subject: [RFC PATCH v3 03/10] fadump: Register for firmware assisted dump.
To: linuxppc-dev <linuxppc-dev@ozlabs.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
From: Mahesh J Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Haren Myneni <hbabu@us.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Amerigo Wang <amwang@redhat.com>, Milton Miller <miltonm@bga.com>,
        Anton Blanchard <anton@samba.org>
Date: Mon, 31 Oct 2011 22:37:24 +0530
Message-ID: <20111031170724.12259.3927.stgit@mars.in.ibm.com>
In-Reply-To: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
References: <20111031170200.12259.27663.stgit@mars.in.ibm.com>
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

Change in v3:
- Re-factored the implementation to work with kdump service start/stop.
  Introduce fadump_registered sysfs control file which will be used by
  kdump init scripts to start/stop firmware assisted dump. echo 1 to
  /sys/kernel/fadump_registered file for fadump registration and
  echo 0 to /sys/kernel/fadump_registered file for fadump un-registration.
- Introduced the locking mechanism to handle simultaneous writes to
  /sys/kernel/fadump_registered file.

Change in v2:
- Removed few debug print statements.
- Moved the setup_fadump() call from setup_system() and now calling it
  subsys_initcall.
- Moved fadump_region attribute under debugfs.
- Clear the TCE entries if firmware assisted dump is active.

Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
---
 arch/powerpc/include/asm/fadump.h |   57 ++++++
 arch/powerpc/kernel/fadump.c      |  352 +++++++++++++++++++++++++++++++++++++
 arch/powerpc/kernel/iommu.c       |    8 +
 arch/powerpc/mm/hash_utils_64.c   |   11 +
 4 files changed, 424 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
index 0b040c1..3b2f8cc 100644
--- a/arch/powerpc/include/asm/fadump.h
+++ b/arch/powerpc/include/asm/fadump.h
@@ -42,6 +42,58 @@
 #define FADUMP_HPTE_REGION	0x0002
 #define FADUMP_REAL_MODE_REGION	0x0011
 
+/* Dump request flag */
+#define FADUMP_REQUEST_FLAG	0x00000001
+
+/* FAD commands */
+#define FADUMP_REGISTER		1
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
@@ -56,10 +108,15 @@ struct fw_dump {
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
+#else	/* CONFIG_FA_DUMP */
+static inline int is_fadump_active(void) { return 0; }
 #endif
 #endif
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 05dffc0..ed38f86 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -29,6 +29,9 @@
 
 #include <linux/string.h>
 #include <linux/memblock.h>
+#include <linux/delay.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <asm/page.h>
 #include <asm/prom.h>
@@ -46,6 +49,10 @@ struct dump_section {
 } __packed;
 
 static struct fw_dump fw_dump;
+static struct fadump_mem_struct fdm;
+static const struct fadump_mem_struct *fdm_active;
+
+static DEFINE_MUTEX(fadump_mutex);
 
 /* Scan the Firmware Assisted dump configuration details. */
 int __init early_init_dt_scan_fw_dump(unsigned long node,
@@ -74,7 +81,8 @@ int __init early_init_dt_scan_fw_dump(unsigned long node,
 	 * The 'ibm,kernel-dump' rtas node is present only if there is
 	 * dump data waiting for us.
 	 */
-	if (of_get_flat_dt_prop(node, "ibm,kernel-dump", NULL))
+	fdm_active = of_get_flat_dt_prop(node, "ibm,kernel-dump", NULL);
+	if (fdm_active)
 		fw_dump.dump_active = 1;
 
 	/* Get the sizes required to store dump data for the firmware provided
@@ -101,6 +109,85 @@ int __init early_init_dt_scan_fw_dump(unsigned long node,
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
+	pr_debug("Support for firmware-assisted dump (fadump): %s\n",
+			(fw_dump.fadump_supported ? "present" : "no support"));
+
+	if (!fw_dump.fadump_supported)
+		return;
+
+	pr_debug("Fadump enabled    : %s\n",
+				(fw_dump.fadump_enabled ? "yes" : "no"));
+	pr_debug("Dump Active       : %s\n",
+				(fw_dump.dump_active ? "yes" : "no"));
+	pr_debug("Dump section sizes:\n");
+	pr_debug("    CPU state data size: %lx\n", fw_dump.cpu_state_data_size);
+	pr_debug("    HPTE region size   : %lx\n", fw_dump.hpte_region_size);
+	pr_debug("Boot memory size  : %lx\n", fw_dump.boot_memory_size);
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
+	return addr;
+}
+
 /**
  * calculate_reserve_size() - reserve variable boot area 5% of System RAM
  *
@@ -170,8 +257,15 @@ int __init fadump_reserve_mem(void)
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
@@ -248,3 +342,255 @@ static int __init early_fadump_reserve_mem(char *p)
 	return 0;
 }
 early_param("fadump_reserve_mem", early_fadump_reserve_mem);
+
+static void register_fw_dump(struct fadump_mem_struct *fdm)
+{
+	int rc;
+	unsigned int wait_time;
+
+	pr_debug("Registering for firmware-assisted kernel dump...\n");
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
+	/* register the future kernel dump with firmware. */
+	register_fw_dump(&fdm);
+}
+
+static int fadump_unregister_dump(struct fadump_mem_struct *fdm)
+{
+	int rc = 0;
+	unsigned int wait_time;
+
+	pr_debug("Un-register firmware-assisted dump\n");
+
+	/* TODO: Add upper time limit for the delay */
+	do {
+		rc = rtas_call(fw_dump.ibm_configure_kernel_dump, 3, 1, NULL,
+			FADUMP_UNREGISTER, fdm,
+			sizeof(struct fadump_mem_struct));
+
+		wait_time = rtas_busy_delay_time(rc);
+		if (wait_time)
+			mdelay(wait_time);
+	} while (wait_time);
+
+	if (rc) {
+		printk(KERN_ERR "Failed to un-register firmware-assisted dump."
+			" unexpected error(%d).\n", rc);
+		return rc;
+	}
+	fw_dump.dump_registered = 0;
+	return 0;
+}
+
+static ssize_t fadump_enabled_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", fw_dump.fadump_enabled);
+}
+
+static ssize_t fadump_register_show(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					char *buf)
+{
+	return sprintf(buf, "%d\n", fw_dump.dump_registered);
+}
+
+static ssize_t fadump_register_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t count)
+{
+	int ret = 0;
+
+	if (!fw_dump.fadump_enabled || fdm_active)
+		return -EPERM;
+
+	mutex_lock(&fadump_mutex);
+
+	switch (buf[0]) {
+	case '0':
+		if (fw_dump.dump_registered == 0) {
+			ret = -EINVAL;
+			goto unlock_out;
+		}
+		/* Un-register Firmware-assisted dump */
+		fadump_unregister_dump(&fdm);
+		break;
+	case '1':
+		if (fw_dump.dump_registered == 1) {
+			ret = -EINVAL;
+			goto unlock_out;
+		}
+		/* Register Firmware-assisted dump */
+		register_fadump();
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+unlock_out:
+	mutex_unlock(&fadump_mutex);
+	return ret < 0 ? ret : count;
+}
+
+static int fadump_region_show(struct seq_file *m, void *private)
+{
+	const struct fadump_mem_struct *fdm_ptr;
+
+	if (!fw_dump.fadump_enabled)
+		return 0;
+
+	if (fdm_active)
+		fdm_ptr = fdm_active;
+	else
+		fdm_ptr = &fdm;
+
+	seq_printf(m,
+			"CPU : [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			fdm_ptr->cpu_state_data.destination_address,
+			fdm_ptr->cpu_state_data.destination_address +
+			fdm_ptr->cpu_state_data.source_len - 1,
+			fdm_ptr->cpu_state_data.source_len,
+			fdm_ptr->cpu_state_data.bytes_dumped);
+	seq_printf(m,
+			"HPTE: [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			fdm_ptr->hpte_region.destination_address,
+			fdm_ptr->hpte_region.destination_address +
+			fdm_ptr->hpte_region.source_len - 1,
+			fdm_ptr->hpte_region.source_len,
+			fdm_ptr->hpte_region.bytes_dumped);
+	seq_printf(m,
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
+		return 0;
+
+	/* Dump is active. Show reserved memory region. */
+	seq_printf(m,
+			"    : [%#016llx-%#016llx] %#llx bytes, "
+			"Dumped: %#llx\n",
+			(unsigned long long)fw_dump.reserve_dump_area_start,
+			fdm_ptr->cpu_state_data.destination_address - 1,
+			fdm_ptr->cpu_state_data.destination_address -
+			fw_dump.reserve_dump_area_start,
+			fdm_ptr->cpu_state_data.destination_address -
+			fw_dump.reserve_dump_area_start);
+	return 0;
+}
+
+static struct kobj_attribute fadump_attr = __ATTR(fadump_enabled,
+						0444, fadump_enabled_show,
+						NULL);
+static struct kobj_attribute fadump_register_attr = __ATTR(fadump_registered,
+						0644, fadump_register_show,
+						fadump_register_store);
+
+static int fadump_region_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, fadump_region_show, inode->i_private);
+}
+
+static const struct file_operations fadump_region_fops = {
+	.open    = fadump_region_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = single_release,
+};
+
+static void fadump_init_files(void)
+{
+	struct dentry *debugfs_file;
+	int rc = 0;
+
+	rc = sysfs_create_file(kernel_kobj, &fadump_attr.attr);
+	if (rc)
+		printk(KERN_ERR "fadump: unable to create sysfs file"
+			" fadump_enabled (%d)\n", rc);
+
+	rc = sysfs_create_file(kernel_kobj, &fadump_register_attr.attr);
+	if (rc)
+		printk(KERN_ERR "fadump: unable to create sysfs file"
+			" fadump_registered (%d)\n", rc);
+
+	debugfs_file = debugfs_create_file("fadump_region", 0444,
+					powerpc_debugfs_root, NULL,
+					&fadump_region_fops);
+	if (!debugfs_file)
+		printk(KERN_ERR "fadump: unable to create debugfs file"
+				" fadump_region\n");
+	return;
+}
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
+	/* Initialize the kernel dump memory structure for FAD registration. */
+	if (fw_dump.reserve_dump_area_size)
+		init_fadump_mem_struct(&fdm, fw_dump.reserve_dump_area_start);
+	fadump_init_files();
+
+	return 1;
+}
+subsys_initcall(setup_fadump);
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 961bb03..2549b53 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -39,6 +39,7 @@
 #include <asm/pci-bridge.h>
 #include <asm/machdep.h>
 #include <asm/kdump.h>
+#include <asm/fadump.h>
 
 #define DBG(...)
 
@@ -445,7 +446,12 @@ void iommu_unmap_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 
 static void iommu_table_clear(struct iommu_table *tbl)
 {
-	if (!is_kdump_kernel()) {
+	/*
+	 * In case of firmware assisted dump system goes through clean
+	 * reboot process at the time of system crash. Hence it's safe to
+	 * clear the TCE entries if firmware assisted dump is active.
+	 */
+	if (!is_kdump_kernel() || is_fadump_active()) {
 		/* Clear the table in case firmware left allocations in it */
 		ppc_md.tce_free(tbl, tbl->it_offset, tbl->it_size);
 		return;
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

