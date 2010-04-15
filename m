Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191Ab0DOTL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:11:56 -0400
Received: from www.tglx.de ([62.245.132.106]:47386 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837Ab0DOTLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:11:55 -0400
Date: Thu, 15 Apr 2010 21:11:38 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT Pull] x86 fixes for 2.6.34
Message-ID: <alpine.LFD.2.00.1004152110160.3625@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
lib/dma-debug.c     # 39a37ce: dma-debug: Cleanup for copy-loop 

Thanks,

	tglx

------------------>
Chris Wright (5):
      x86/amd-iommu: Pt mode fix for domain_destroy
      x86/amd-iommu: enable iommu before attaching devices
      x86/amd-iommu: warn when issuing command to uninitialized cmd buffer
      Revert "x86: disable IOMMUs on kernel crash"
      x86/amd-iommu: use for_each_pci_dev

Dan Carpenter (1):
      dma-debug: Cleanup for copy-loop in filter_write()

Joerg Roedel (5):
      x86/amd-iommu: Protect IOMMU-API map/unmap path
      x86/amd-iommu: Report errors in acpi parsing functions upstream
      x86/amd-iommu: Use helper function to destroy domain
      x86/amd-iommu: Remove obsolete parameter documentation
      x86/gart: Disable GART explicitly before initialization

Julia Lawall (1):
      x86/amd-iommu: Remove double NULL check in check_device


 Documentation/kernel-parameters.txt    |    5 ---
 arch/x86/include/asm/amd_iommu_types.h |    3 ++
 arch/x86/kernel/amd_iommu.c            |   20 +++++++++----
 arch/x86/kernel/amd_iommu_init.c       |   48 ++++++++++++++++++++++----------
 arch/x86/kernel/aperture_64.c          |   15 +++++++++-
 arch/x86/kernel/crash.c                |    6 ----
 arch/x86/kernel/pci-gart_64.c          |    3 ++
 lib/dma-debug.c                        |    2 +-
 8 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e4cbca5..e2202e9 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -320,11 +320,6 @@ and is between 256 and 4096 characters. It is defined in the file
 	amd_iommu=	[HW,X86-84]
 			Pass parameters to the AMD IOMMU driver in the system.
 			Possible values are:
-			isolate - enable device isolation (each device, as far
-			          as possible, will get its own protection
-			          domain) [default]
-			share - put every device behind one IOMMU into the
-				same protection domain
 			fullflush - enable flushing of IO/TLB entries when
 				    they are unmapped. Otherwise they are
 				    flushed before they will be reused, which
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ba19ad4..86a0ff0 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -21,6 +21,7 @@
 #define _ASM_X86_AMD_IOMMU_TYPES_H
 
 #include <linux/types.h>
+#include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
@@ -140,6 +141,7 @@
 
 /* constants to configure the command buffer */
 #define CMD_BUFFER_SIZE    8192
+#define CMD_BUFFER_UNINITIALIZED 1
 #define CMD_BUFFER_ENTRIES 512
 #define MMIO_CMD_SIZE_SHIFT 56
 #define MMIO_CMD_SIZE_512 (0x9ULL << MMIO_CMD_SIZE_SHIFT)
@@ -237,6 +239,7 @@ struct protection_domain {
 	struct list_head list;  /* for list of all protection domains */
 	struct list_head dev_list; /* List of all devices in this domain */
 	spinlock_t lock;	/* mostly used to lock the page table*/
+	struct mutex api_lock;	/* protect page tables in the iommu-api path */
 	u16 id;			/* the domain id written to the device table */
 	int mode;		/* paging mode (0-6 levels) */
 	u64 *pt_root;		/* page table root pointer */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f3dadb5..f854d89 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -118,7 +118,7 @@ static bool check_device(struct device *dev)
 		return false;
 
 	/* No device or no PCI device */
-	if (!dev || dev->bus != &pci_bus_type)
+	if (dev->bus != &pci_bus_type)
 		return false;
 
 	devid = get_device_id(dev);
@@ -392,6 +392,7 @@ static int __iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 	u32 tail, head;
 	u8 *target;
 
+	WARN_ON(iommu->cmd_buf_size & CMD_BUFFER_UNINITIALIZED);
 	tail = readl(iommu->mmio_base + MMIO_CMD_TAIL_OFFSET);
 	target = iommu->cmd_buf + tail;
 	memcpy_toio(target, cmd, sizeof(*cmd));
@@ -2186,7 +2187,7 @@ static void prealloc_protection_domains(void)
 	struct dma_ops_domain *dma_dom;
 	u16 devid;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 
 		/* Do we handle this device? */
 		if (!check_device(&dev->dev))
@@ -2298,7 +2299,7 @@ static void cleanup_domain(struct protection_domain *domain)
 	list_for_each_entry_safe(dev_data, next, &domain->dev_list, list) {
 		struct device *dev = dev_data->dev;
 
-		do_detach(dev);
+		__detach_device(dev);
 		atomic_set(&dev_data->bind, 0);
 	}
 
@@ -2327,6 +2328,7 @@ static struct protection_domain *protection_domain_alloc(void)
 		return NULL;
 
 	spin_lock_init(&domain->lock);
+	mutex_init(&domain->api_lock);
 	domain->id = domain_id_alloc();
 	if (!domain->id)
 		goto out_err;
@@ -2379,9 +2381,7 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 
 	free_pagetable(domain);
 
-	domain_id_free(domain->id);
-
-	kfree(domain);
+	protection_domain_free(domain);
 
 	dom->priv = NULL;
 }
@@ -2456,6 +2456,8 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	iova  &= PAGE_MASK;
 	paddr &= PAGE_MASK;
 
+	mutex_lock(&domain->api_lock);
+
 	for (i = 0; i < npages; ++i) {
 		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
 		if (ret)
@@ -2465,6 +2467,8 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 		paddr += PAGE_SIZE;
 	}
 
+	mutex_unlock(&domain->api_lock);
+
 	return 0;
 }
 
@@ -2477,12 +2481,16 @@ static void amd_iommu_unmap_range(struct iommu_domain *dom,
 
 	iova  &= PAGE_MASK;
 
+	mutex_lock(&domain->api_lock);
+
 	for (i = 0; i < npages; ++i) {
 		iommu_unmap_page(domain, iova, PM_MAP_4k);
 		iova  += PAGE_SIZE;
 	}
 
 	iommu_flush_tlb_pde(domain);
+
+	mutex_unlock(&domain->api_lock);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 42f5350..6360abf 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -138,9 +138,9 @@ int amd_iommus_present;
 bool amd_iommu_np_cache __read_mostly;
 
 /*
- * Set to true if ACPI table parsing and hardware intialization went properly
+ * The ACPI table parsing functions set this variable on an error
  */
-static bool amd_iommu_initialized;
+static int __initdata amd_iommu_init_err;
 
 /*
  * List of protection domains - used during resume
@@ -391,9 +391,11 @@ static int __init find_last_devid_acpi(struct acpi_table_header *table)
 	 */
 	for (i = 0; i < table->length; ++i)
 		checksum += p[i];
-	if (checksum != 0)
+	if (checksum != 0) {
 		/* ACPI table corrupt */
-		return -ENODEV;
+		amd_iommu_init_err = -ENODEV;
+		return 0;
+	}
 
 	p += IVRS_HEADER_LENGTH;
 
@@ -436,7 +438,7 @@ static u8 * __init alloc_command_buffer(struct amd_iommu *iommu)
 	if (cmd_buf == NULL)
 		return NULL;
 
-	iommu->cmd_buf_size = CMD_BUFFER_SIZE;
+	iommu->cmd_buf_size = CMD_BUFFER_SIZE | CMD_BUFFER_UNINITIALIZED;
 
 	return cmd_buf;
 }
@@ -472,12 +474,13 @@ static void iommu_enable_command_buffer(struct amd_iommu *iommu)
 		    &entry, sizeof(entry));
 
 	amd_iommu_reset_cmd_buffer(iommu);
+	iommu->cmd_buf_size &= ~(CMD_BUFFER_UNINITIALIZED);
 }
 
 static void __init free_command_buffer(struct amd_iommu *iommu)
 {
 	free_pages((unsigned long)iommu->cmd_buf,
-		   get_order(iommu->cmd_buf_size));
+		   get_order(iommu->cmd_buf_size & ~(CMD_BUFFER_UNINITIALIZED)));
 }
 
 /* allocates the memory where the IOMMU will log its events to */
@@ -920,11 +923,16 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 				    h->mmio_phys);
 
 			iommu = kzalloc(sizeof(struct amd_iommu), GFP_KERNEL);
-			if (iommu == NULL)
-				return -ENOMEM;
+			if (iommu == NULL) {
+				amd_iommu_init_err = -ENOMEM;
+				return 0;
+			}
+
 			ret = init_iommu_one(iommu, h);
-			if (ret)
-				return ret;
+			if (ret) {
+				amd_iommu_init_err = ret;
+				return 0;
+			}
 			break;
 		default:
 			break;
@@ -934,8 +942,6 @@ static int __init init_iommu_all(struct acpi_table_header *table)
 	}
 	WARN_ON(p != end);
 
-	amd_iommu_initialized = true;
-
 	return 0;
 }
 
@@ -1211,6 +1217,10 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", find_last_devid_acpi) != 0)
 		return -ENODEV;
 
+	ret = amd_iommu_init_err;
+	if (ret)
+		goto out;
+
 	dev_table_size     = tbl_size(DEV_TABLE_ENTRY_SIZE);
 	alias_table_size   = tbl_size(ALIAS_TABLE_ENTRY_SIZE);
 	rlookup_table_size = tbl_size(RLOOKUP_TABLE_ENTRY_SIZE);
@@ -1270,12 +1280,19 @@ static int __init amd_iommu_init(void)
 	if (acpi_table_parse("IVRS", init_iommu_all) != 0)
 		goto free;
 
-	if (!amd_iommu_initialized)
+	if (amd_iommu_init_err) {
+		ret = amd_iommu_init_err;
 		goto free;
+	}
 
 	if (acpi_table_parse("IVRS", init_memory_definitions) != 0)
 		goto free;
 
+	if (amd_iommu_init_err) {
+		ret = amd_iommu_init_err;
+		goto free;
+	}
+
 	ret = sysdev_class_register(&amd_iommu_sysdev_class);
 	if (ret)
 		goto free;
@@ -1288,6 +1305,8 @@ static int __init amd_iommu_init(void)
 	if (ret)
 		goto free;
 
+	enable_iommus();
+
 	if (iommu_pass_through)
 		ret = amd_iommu_init_passthrough();
 	else
@@ -1300,8 +1319,6 @@ static int __init amd_iommu_init(void)
 
 	amd_iommu_init_notifier();
 
-	enable_iommus();
-
 	if (iommu_pass_through)
 		goto out;
 
@@ -1315,6 +1332,7 @@ out:
 	return ret;
 
 free:
+	disable_iommus();
 
 	amd_iommu_uninit_devices();
 
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 3704997..b5d8b0b 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -393,6 +393,7 @@ void __init gart_iommu_hole_init(void)
 	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
 		int bus;
 		int dev_base, dev_limit;
+		u32 ctl;
 
 		bus = bus_dev_ranges[i].bus;
 		dev_base = bus_dev_ranges[i].dev_base;
@@ -406,7 +407,19 @@ void __init gart_iommu_hole_init(void)
 			gart_iommu_aperture = 1;
 			x86_init.iommu.iommu_init = gart_iommu_init;
 
-			aper_order = (read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL) >> 1) & 7;
+			ctl = read_pci_config(bus, slot, 3,
+					      AMD64_GARTAPERTURECTL);
+
+			/*
+			 * Before we do anything else disable the GART. It may
+			 * still be enabled if we boot into a crash-kernel here.
+			 * Reconfiguring the GART while it is enabled could have
+			 * unknown side-effects.
+			 */
+			ctl &= ~GARTEN;
+			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
+
+			aper_order = (ctl >> 1) & 7;
 			aper_size = (32 * 1024 * 1024) << aper_order;
 			aper_base = read_pci_config(bus, slot, 3, AMD64_GARTAPERTUREBASE) & 0x7fff;
 			aper_base <<= 25;
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index a4849c1..ebd4c51 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,7 +27,6 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
-#include <asm/x86_init.h>
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
 
@@ -103,10 +102,5 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
-
-#ifdef CONFIG_X86_64
-	x86_platform.iommu_shutdown();
-#endif
-
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 68cd24f..0f7f130 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -565,6 +565,9 @@ static void enable_gart_translations(void)
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
+
+	/* Flush the GART-TLB to remove stale entries */
+	k8_flush_garts();
 }
 
 /*
diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index ba8b670..01e6427 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -570,7 +570,7 @@ static ssize_t filter_write(struct file *file, const char __user *userbuf,
 	 * Now parse out the first token and use it as the name for the
 	 * driver to filter for.
 	 */
-	for (i = 0; i < NAME_MAX_LEN; ++i) {
+	for (i = 0; i < NAME_MAX_LEN - 1; ++i) {
 		current_driver_name[i] = buf[i];
 		if (isspace(buf[i]) || buf[i] == ' ' || buf[i] == 0)
 			break;
