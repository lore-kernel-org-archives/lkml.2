Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab0J2PPH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:15:07 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:9601
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757969Ab0J2PPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:15:01 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h65h)
X-Spam-TCS-SCL: 4:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp02.amd.com;RD:ausb3extmailp02.amd.com;EFVD:NLI
X-WSS-ID: 0LB250C-02-7U4-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linuxtronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 1/3] complete the rename of AMD NB and related code
Date: Fri, 29 Oct 2010 17:14:30 +0200
Message-ID: <1288365272-214117-1-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not only the naming of the files was confusing, it was even more so for
the function and variable names.

Renamed the K8 NB and NUMA stuff that is also used on other AMD
platforms. This also renames the CONFIG_K8_NUMA option to
CONFIG_AMD_NUMA and the related file k8topology_64.c to
amdtopology_64.c. No functional changes intended.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/Kconfig                      |   12 +-
 arch/x86/include/asm/amd_nb.h         |   24 ++--
 arch/x86/kernel/amd_nb.c              |   72 +++++-----
 arch/x86/kernel/aperture_64.c         |   10 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +-
 arch/x86/kernel/pci-gart_64.c         |   34 +++---
 arch/x86/kernel/setup.c               |    8 +-
 arch/x86/mm/Makefile                  |    2 +-
 arch/x86/mm/amdtopology_64.c          |  237 +++++++++++++++++++++++++++++++++
 arch/x86/mm/k8topology_64.c           |  237 ---------------------------------
 arch/x86/mm/numa_64.c                 |   22 ++--
 drivers/char/agp/amd64-agp.c          |   32 +++---
 drivers/edac/amd64_edac.c             |    4 +-
 13 files changed, 350 insertions(+), 350 deletions(-)
 create mode 100644 arch/x86/mm/amdtopology_64.c
 delete mode 100644 arch/x86/mm/k8topology_64.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 299fbc8..88b8c38 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1144,16 +1144,16 @@ config NUMA
 comment "NUMA (Summit) requires SMP, 64GB highmem support, ACPI"
 	depends on X86_32 && X86_SUMMIT && (!HIGHMEM64G || !ACPI)
 
-config K8_NUMA
+config AMD_NUMA
 	def_bool y
 	prompt "Old style AMD Opteron NUMA detection"
 	depends on X86_64 && NUMA && PCI
 	---help---
-	  Enable K8 NUMA node topology detection.  You should say Y here if
-	  you have a multi processor AMD K8 system. This uses an old
-	  method to read the NUMA configuration directly from the builtin
-	  Northbridge of Opteron. It is recommended to use X86_64_ACPI_NUMA
-	  instead, which also takes priority if both are compiled in.
+	  Enable AMD NUMA node topology detection.  You should say Y here if
+	  you have a multi processor AMD system. This uses an old method to
+	  read the NUMA configuration directly from the builtin Northbridge
+	  of Opteron. It is recommended to use X86_64_ACPI_NUMA instead,
+	  which also takes priority if both are compiled in.
 
 config X86_64_ACPI_NUMA
 	def_bool y
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index c8517f8..35b17a8 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -3,33 +3,33 @@
 
 #include <linux/pci.h>
 
-extern struct pci_device_id k8_nb_ids[];
+extern struct pci_device_id amd_nb_ids[];
 struct bootnode;
 
-extern int early_is_k8_nb(u32 value);
-extern int cache_k8_northbridges(void);
-extern void k8_flush_garts(void);
-extern int k8_get_nodes(struct bootnode *nodes);
-extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
-extern int k8_scan_nodes(void);
+extern int early_is_amd_nb(u32 value);
+extern int cache_amd_northbridges(void);
+extern void amd_flush_garts(void);
+extern int amd_get_nodes(struct bootnode *nodes);
+extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
+extern int amd_scan_nodes(void);
 
-struct k8_northbridge_info {
+struct amd_northbridge_info {
 	u16 num;
 	u8 gart_supported;
 	struct pci_dev **nb_misc;
 };
-extern struct k8_northbridge_info k8_northbridges;
+extern struct amd_northbridge_info amd_northbridges;
 
 #ifdef CONFIG_AMD_NB
 
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
+static inline struct pci_dev *node_to_amd_nb_misc(int node)
 {
-	return (node < k8_northbridges.num) ? k8_northbridges.nb_misc[node] : NULL;
+	return (node < amd_northbridges.num) ? amd_northbridges.nb_misc[node] : NULL;
 }
 
 #else
 
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
+static inline struct pci_dev *node_to_amd_nb_misc(int node)
 {
 	return NULL;
 }
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 8f6463d..c46df40 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -12,95 +12,95 @@
 
 static u32 *flush_words;
 
-struct pci_device_id k8_nb_ids[] = {
+struct pci_device_id amd_nb_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
 	{}
 };
-EXPORT_SYMBOL(k8_nb_ids);
+EXPORT_SYMBOL(amd_nb_ids);
 
-struct k8_northbridge_info k8_northbridges;
-EXPORT_SYMBOL(k8_northbridges);
+struct amd_northbridge_info amd_northbridges;
+EXPORT_SYMBOL(amd_northbridges);
 
-static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
+static struct pci_dev *next_amd_northbridge(struct pci_dev *dev)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
 		if (!dev)
 			break;
-	} while (!pci_match_id(&k8_nb_ids[0], dev));
+	} while (!pci_match_id(&amd_nb_ids[0], dev));
 	return dev;
 }
 
-int cache_k8_northbridges(void)
+int cache_amd_northbridges(void)
 {
 	int i;
 	struct pci_dev *dev;
 
-	if (k8_northbridges.num)
+	if (amd_northbridges.num)
 		return 0;
 
 	dev = NULL;
-	while ((dev = next_k8_northbridge(dev)) != NULL)
-		k8_northbridges.num++;
+	while ((dev = next_amd_northbridge(dev)) != NULL)
+		amd_northbridges.num++;
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
 	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
 	    boot_cpu_data.x86 == 0x15)
-		k8_northbridges.gart_supported = 1;
+		amd_northbridges.gart_supported = 1;
 
-	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
+	amd_northbridges.nb_misc = kmalloc((amd_northbridges.num + 1) *
 					  sizeof(void *), GFP_KERNEL);
-	if (!k8_northbridges.nb_misc)
+	if (!amd_northbridges.nb_misc)
 		return -ENOMEM;
 
-	if (!k8_northbridges.num) {
-		k8_northbridges.nb_misc[0] = NULL;
+	if (!amd_northbridges.num) {
+		amd_northbridges.nb_misc[0] = NULL;
 		return 0;
 	}
 
-	if (k8_northbridges.gart_supported) {
-		flush_words = kmalloc(k8_northbridges.num * sizeof(u32),
+	if (amd_northbridges.gart_supported) {
+		flush_words = kmalloc(amd_northbridges.num * sizeof(u32),
 				      GFP_KERNEL);
 		if (!flush_words) {
-			kfree(k8_northbridges.nb_misc);
+			kfree(amd_northbridges.nb_misc);
 			return -ENOMEM;
 		}
 	}
 
 	dev = NULL;
 	i = 0;
-	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges.nb_misc[i] = dev;
-		if (k8_northbridges.gart_supported)
+	while ((dev = next_amd_northbridge(dev)) != NULL) {
+		amd_northbridges.nb_misc[i] = dev;
+		if (amd_northbridges.gart_supported)
 			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
-	k8_northbridges.nb_misc[i] = NULL;
+	amd_northbridges.nb_misc[i] = NULL;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cache_k8_northbridges);
+EXPORT_SYMBOL_GPL(cache_amd_northbridges);
 
 /* Ignores subdevice/subvendor but as far as I can figure out
    they're useless anyways */
-int __init early_is_k8_nb(u32 device)
+int __init early_is_amd_nb(u32 device)
 {
 	struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
 	device >>= 16;
-	for (id = k8_nb_ids; id->vendor; id++)
+	for (id = amd_nb_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
 			return 1;
 	return 0;
 }
 
-void k8_flush_garts(void)
+void amd_flush_garts(void)
 {
 	int flushed, i;
 	unsigned long flags;
 	static DEFINE_SPINLOCK(gart_lock);
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return;
 
 	/* Avoid races between AGP and IOMMU. In theory it's not needed
@@ -109,16 +109,16 @@ void k8_flush_garts(void)
 	   that it doesn't matter to serialize more. -AK */
 	spin_lock_irqsave(&gart_lock, flags);
 	flushed = 0;
-	for (i = 0; i < k8_northbridges.num; i++) {
-		pci_write_config_dword(k8_northbridges.nb_misc[i], 0x9c,
+	for (i = 0; i < amd_northbridges.num; i++) {
+		pci_write_config_dword(amd_northbridges.nb_misc[i], 0x9c,
 				       flush_words[i]|1);
 		flushed++;
 	}
-	for (i = 0; i < k8_northbridges.num; i++) {
+	for (i = 0; i < amd_northbridges.num; i++) {
 		u32 w;
 		/* Make sure the hardware actually executed the flush*/
 		for (;;) {
-			pci_read_config_dword(k8_northbridges.nb_misc[i],
+			pci_read_config_dword(amd_northbridges.nb_misc[i],
 					      0x9c, &w);
 			if (!(w & 1))
 				break;
@@ -129,19 +129,19 @@ void k8_flush_garts(void)
 	if (!flushed)
 		printk("nothing to flush?\n");
 }
-EXPORT_SYMBOL_GPL(k8_flush_garts);
+EXPORT_SYMBOL_GPL(amd_flush_garts);
 
-static __init int init_k8_nbs(void)
+static __init int init_amd_nbs(void)
 {
 	int err = 0;
 
-	err = cache_k8_northbridges();
+	err = cache_amd_northbridges();
 
 	if (err < 0)
-		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
+		printk(KERN_NOTICE "AMD NB: Cannot enumerate AMD northbridges.\n");
 
 	return err;
 }
 
 /* This has to go after the PCI subsystem */
-fs_initcall(init_k8_nbs);
+fs_initcall(init_amd_nbs);
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index b3a16e8..dcd7c83 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -206,7 +206,7 @@ static u32 __init read_agp(int bus, int slot, int func, int cap, u32 *order)
  * Do an PCI bus scan by hand because we're running before the PCI
  * subsystem.
  *
- * All K8 AGP bridges are AGPv3 compliant, so we can do this scan
+ * All AMD AGP bridges are AGPv3 compliant, so we can do this scan
  * generically. It's probably overkill to always scan all slots because
  * the AGP bridges should be always an own bus on the HT hierarchy,
  * but do it here for future safety.
@@ -303,7 +303,7 @@ void __init early_gart_iommu_check(void)
 		dev_limit = bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
-			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
 
 			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
@@ -358,7 +358,7 @@ void __init early_gart_iommu_check(void)
 		dev_limit = bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
-			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
 
 			ctl = read_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL);
@@ -400,7 +400,7 @@ int __init gart_iommu_hole_init(void)
 		dev_limit = bus_dev_ranges[i].dev_limit;
 
 		for (slot = dev_base; slot < dev_limit; slot++) {
-			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
 
 			iommu_detected = 1;
@@ -518,7 +518,7 @@ out:
 		dev_base = bus_dev_ranges[i].dev_base;
 		dev_limit = bus_dev_ranges[i].dev_limit;
 		for (slot = dev_base; slot < dev_limit; slot++) {
-			if (!early_is_k8_nb(read_pci_config(bus, slot, 3, 0x00)))
+			if (!early_is_amd_nb(read_pci_config(bus, slot, 3, 0x00)))
 				continue;
 
 			write_pci_config(bus, slot, 3, AMD64_GARTAPERTURECTL, ctl);
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 17ad033..92512ed 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -333,7 +333,7 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
 {
 	struct amd_l3_cache *l3;
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
+	struct pci_dev *dev = node_to_amd_nb_misc(node);
 
 	l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
 	if (!l3) {
@@ -370,7 +370,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 			return;
 
 	/* not in virtualized environments */
-	if (k8_northbridges.num == 0)
+	if (amd_northbridges.num == 0)
 		return;
 
 	/*
@@ -378,7 +378,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 	 * never freed but this is done only on shutdown so it doesn't matter.
 	 */
 	if (!l3_caches) {
-		int size = k8_northbridges.num * sizeof(struct amd_l3_cache *);
+		int size = amd_northbridges.num * sizeof(struct amd_l3_cache *);
 
 		l3_caches = kzalloc(size, GFP_ATOMIC);
 		if (!l3_caches)
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index ba0f0ca..63317c5 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -143,7 +143,7 @@ static void flush_gart(void)
 
 	spin_lock_irqsave(&iommu_bitmap_lock, flags);
 	if (need_flush) {
-		k8_flush_garts();
+		amd_flush_garts();
 		need_flush = false;
 	}
 	spin_unlock_irqrestore(&iommu_bitmap_lock, flags);
@@ -561,17 +561,17 @@ static void enable_gart_translations(void)
 {
 	int i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return;
 
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_northbridges.num; i++) {
+		struct pci_dev *dev = amd_northbridges.nb_misc[i];
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
 
 	/* Flush the GART-TLB to remove stale entries */
-	k8_flush_garts();
+	amd_flush_garts();
 }
 
 /*
@@ -596,13 +596,13 @@ static void gart_fixup_northbridges(struct sys_device *dev)
 	if (!fix_up_north_bridges)
 		return;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return;
 
 	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_northbridges.num; i++) {
+		struct pci_dev *dev = amd_northbridges.nb_misc[i];
 
 		/*
 		 * Don't enable translations just yet.  That is the next
@@ -644,7 +644,7 @@ static struct sys_device device_gart = {
  * Private Northbridge GATT initialization in case we cannot use the
  * AGP driver for some reason.
  */
-static __init int init_k8_gatt(struct agp_kern_info *info)
+static __init int init_amd_gatt(struct agp_kern_info *info)
 {
 	unsigned aper_size, gatt_size, new_aper_size;
 	unsigned aper_base, new_aper_base;
@@ -656,8 +656,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
-	for (i = 0; i < k8_northbridges.num; i++) {
-		dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_northbridges.num; i++) {
+		dev = amd_northbridges.nb_misc[i];
 		new_aper_base = read_aperture(dev, &new_aper_size);
 		if (!new_aper_base)
 			goto nommu;
@@ -725,13 +725,13 @@ static void gart_iommu_shutdown(void)
 	if (!no_agp)
 		return;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return;
 
-	for (i = 0; i < k8_northbridges.num; i++) {
+	for (i = 0; i < amd_northbridges.num; i++) {
 		u32 ctl;
 
-		dev = k8_northbridges.nb_misc[i];
+		dev = amd_northbridges.nb_misc[i];
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
 		ctl &= ~GARTEN;
@@ -749,14 +749,14 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
 	no_agp = 1;
 #else
 	/* Makefile puts PCI initialization via subsys_initcall first. */
-	/* Add other K8 AGP bridge drivers here */
+	/* Add other AMD AGP bridge drivers here */
 	no_agp = no_agp ||
 		(agp_amd64_init() < 0) ||
 		(agp_copy_info(agp_bridge, &info) < 0);
@@ -765,7 +765,7 @@ int __init gart_iommu_init(void)
 	if (no_iommu ||
 	    (!force_iommu && max_pfn <= MAX_DMA32_PFN) ||
 	    !gart_iommu_aperture ||
-	    (no_agp && init_k8_gatt(&info) < 0)) {
+	    (no_agp && init_amd_gatt(&info) < 0)) {
 		if (max_pfn > MAX_DMA32_PFN) {
 			pr_warning("More than 4GB of memory but GART IOMMU not available.\n");
 			pr_warning("falling back to iommu=soft.\n");
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0ac571d..05b12a2 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -694,7 +694,7 @@ static u64 __init get_max_mapped(void)
 void __init setup_arch(char **cmdline_p)
 {
 	int acpi = 0;
-	int k8 = 0;
+	int amd = 0;
 	unsigned long flags;
 
 #ifdef CONFIG_X86_32
@@ -979,12 +979,12 @@ void __init setup_arch(char **cmdline_p)
 	acpi = acpi_numa_init();
 #endif
 
-#ifdef CONFIG_K8_NUMA
+#ifdef CONFIG_AMD_NUMA
 	if (!acpi)
-		k8 = !k8_numa_init(0, max_pfn);
+		amd = !amd_numa_init(0, max_pfn);
 #endif
 
-	initmem_init(0, max_pfn, acpi, k8);
+	initmem_init(0, max_pfn, acpi, amd);
 	memblock_find_dma_reserve();
 	dma32_reserve_bootmem();
 
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index 5554339..09df2f9 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -23,7 +23,7 @@ mmiotrace-y			:= kmmio.o pf_in.o mmio-mod.o
 obj-$(CONFIG_MMIOTRACE_TEST)	+= testmmiotrace.o
 
 obj-$(CONFIG_NUMA)		+= numa.o numa_$(BITS).o
-obj-$(CONFIG_K8_NUMA)		+= k8topology_64.o
+obj-$(CONFIG_AMD_NUMA)		+= amdtopology_64.o
 obj-$(CONFIG_ACPI_NUMA)		+= srat_$(BITS).o
 
 obj-$(CONFIG_HAVE_MEMBLOCK)		+= memblock.o
diff --git a/arch/x86/mm/amdtopology_64.c b/arch/x86/mm/amdtopology_64.c
new file mode 100644
index 0000000..51fae9c
--- /dev/null
+++ b/arch/x86/mm/amdtopology_64.c
@@ -0,0 +1,237 @@
+/*
+ * AMD NUMA support.
+ * Discover the memory map and associated nodes.
+ *
+ * This version reads it directly from the AMD northbridge.
+ *
+ * Copyright 2002,2003 Andi Kleen, SuSE Labs.
+ */
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <linux/nodemask.h>
+#include <linux/memblock.h>
+
+#include <asm/io.h>
+#include <linux/pci_ids.h>
+#include <linux/acpi.h>
+#include <asm/types.h>
+#include <asm/mmzone.h>
+#include <asm/proto.h>
+#include <asm/e820.h>
+#include <asm/pci-direct.h>
+#include <asm/numa.h>
+#include <asm/mpspec.h>
+#include <asm/apic.h>
+#include <asm/amd_nb.h>
+
+static struct bootnode __initdata nodes[8];
+static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
+
+static __init int find_northbridge(void)
+{
+	int num;
+
+	for (num = 0; num < 32; num++) {
+		u32 header;
+
+		header = read_pci_config(0, num, 0, 0x00);
+		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)))
+			continue;
+
+		header = read_pci_config(0, num, 1, 0x00);
+		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
+			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)))
+			continue;
+		return num;
+	}
+
+	return -1;
+}
+
+static __init void early_get_boot_cpu_id(void)
+{
+	/*
+	 * need to get the APIC ID of the BSP so can use that to
+	 * create apicid_to_node in amd_scan_nodes()
+	 */
+#ifdef CONFIG_X86_MPPARSE
+	/*
+	 * get boot-time SMP configuration:
+	 */
+	if (smp_found_config)
+		early_get_smp_config();
+#endif
+	early_init_lapic_mapping();
+}
+
+int __init amd_get_nodes(struct bootnode *physnodes)
+{
+	int i;
+	int ret = 0;
+
+	for_each_node_mask(i, nodes_parsed) {
+		physnodes[ret].start = nodes[i].start;
+		physnodes[ret].end = nodes[i].end;
+		ret++;
+	}
+	return ret;
+}
+
+int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
+{
+	unsigned long start = PFN_PHYS(start_pfn);
+	unsigned long end = PFN_PHYS(end_pfn);
+	unsigned numnodes;
+	unsigned long prevbase;
+	int i, nb, found = 0;
+	u32 nodeid, reg;
+
+	if (!early_pci_allowed())
+		return -1;
+
+	nb = find_northbridge();
+	if (nb < 0)
+		return nb;
+
+	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
+
+	reg = read_pci_config(0, nb, 0, 0x60);
+	numnodes = ((reg >> 4) & 0xF) + 1;
+	if (numnodes <= 1)
+		return -1;
+
+	pr_info("Number of physical nodes %d\n", numnodes);
+
+	prevbase = 0;
+	for (i = 0; i < 8; i++) {
+		unsigned long base, limit;
+
+		base = read_pci_config(0, nb, 1, 0x40 + i*8);
+		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
+
+		nodeid = limit & 7;
+		if ((base & 3) == 0) {
+			if (i < numnodes)
+				pr_info("Skipping disabled node %d\n", i);
+			continue;
+		}
+		if (nodeid >= numnodes) {
+			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
+				base, limit);
+			continue;
+		}
+
+		if (!limit) {
+			pr_info("Skipping node entry %d (base %lx)\n",
+				i, base);
+			continue;
+		}
+		if ((base >> 8) & 3 || (limit >> 8) & 3) {
+			pr_err("Node %d using interleaving mode %lx/%lx\n",
+			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
+			return -1;
+		}
+		if (node_isset(nodeid, nodes_parsed)) {
+			pr_info("Node %d already present, skipping\n",
+				nodeid);
+			continue;
+		}
+
+		limit >>= 16;
+		limit <<= 24;
+		limit |= (1<<24)-1;
+		limit++;
+
+		if (limit > end)
+			limit = end;
+		if (limit <= base)
+			continue;
+
+		base >>= 16;
+		base <<= 24;
+
+		if (base < start)
+			base = start;
+		if (limit > end)
+			limit = end;
+		if (limit == base) {
+			pr_err("Empty node %d\n", nodeid);
+			continue;
+		}
+		if (limit < base) {
+			pr_err("Node %d bogus settings %lx-%lx.\n",
+			       nodeid, base, limit);
+			continue;
+		}
+
+		/* Could sort here, but pun for now. Should not happen anyroads. */
+		if (prevbase > base) {
+			pr_err("Node map not sorted %lx,%lx\n",
+			       prevbase, base);
+			return -1;
+		}
+
+		pr_info("Node %d MemBase %016lx Limit %016lx\n",
+			nodeid, base, limit);
+
+		found++;
+
+		nodes[nodeid].start = base;
+		nodes[nodeid].end = limit;
+
+		prevbase = base;
+
+		node_set(nodeid, nodes_parsed);
+	}
+
+	if (!found)
+		return -1;
+	return 0;
+}
+
+int __init amd_scan_nodes(void)
+{
+	unsigned int bits;
+	unsigned int cores;
+	unsigned int apicid_base;
+	int i;
+
+	BUG_ON(nodes_empty(nodes_parsed));
+	node_possible_map = nodes_parsed;
+	memnode_shift = compute_hash_shift(nodes, 8, NULL);
+	if (memnode_shift < 0) {
+		pr_err("No NUMA node hash function found. Contact maintainer\n");
+		return -1;
+	}
+	pr_info("Using node hash shift of %d\n", memnode_shift);
+
+	/* use the coreid bits from early_identify_cpu */
+	bits = boot_cpu_data.x86_coreid_bits;
+	cores = (1<<bits);
+	apicid_base = 0;
+	/* get the APIC ID of the BSP early for systems with apicid lifting */
+	early_get_boot_cpu_id();
+	if (boot_cpu_physical_apicid > 0) {
+		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
+		apicid_base = boot_cpu_physical_apicid;
+	}
+
+	for_each_node_mask(i, node_possible_map) {
+		int j;
+
+		memblock_x86_register_active_regions(i,
+				nodes[i].start >> PAGE_SHIFT,
+				nodes[i].end >> PAGE_SHIFT);
+		for (j = apicid_base; j < cores + apicid_base; j++)
+			apicid_to_node[(i << bits) + j] = i;
+		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
+	}
+
+	numa_init_array();
+	return 0;
+}
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
deleted file mode 100644
index 804a3b6..0000000
--- a/arch/x86/mm/k8topology_64.c
+++ /dev/null
@@ -1,237 +0,0 @@
-/*
- * AMD K8 NUMA support.
- * Discover the memory map and associated nodes.
- *
- * This version reads it directly from the K8 northbridge.
- *
- * Copyright 2002,2003 Andi Kleen, SuSE Labs.
- */
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/string.h>
-#include <linux/module.h>
-#include <linux/nodemask.h>
-#include <linux/memblock.h>
-
-#include <asm/io.h>
-#include <linux/pci_ids.h>
-#include <linux/acpi.h>
-#include <asm/types.h>
-#include <asm/mmzone.h>
-#include <asm/proto.h>
-#include <asm/e820.h>
-#include <asm/pci-direct.h>
-#include <asm/numa.h>
-#include <asm/mpspec.h>
-#include <asm/apic.h>
-#include <asm/amd_nb.h>
-
-static struct bootnode __initdata nodes[8];
-static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
-
-static __init int find_northbridge(void)
-{
-	int num;
-
-	for (num = 0; num < 32; num++) {
-		u32 header;
-
-		header = read_pci_config(0, num, 0, 0x00);
-		if (header != (PCI_VENDOR_ID_AMD | (0x1100<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1200<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1300<<16)))
-			continue;
-
-		header = read_pci_config(0, num, 1, 0x00);
-		if (header != (PCI_VENDOR_ID_AMD | (0x1101<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1201<<16)) &&
-			header != (PCI_VENDOR_ID_AMD | (0x1301<<16)))
-			continue;
-		return num;
-	}
-
-	return -1;
-}
-
-static __init void early_get_boot_cpu_id(void)
-{
-	/*
-	 * need to get the APIC ID of the BSP so can use that to
-	 * create apicid_to_node in k8_scan_nodes()
-	 */
-#ifdef CONFIG_X86_MPPARSE
-	/*
-	 * get boot-time SMP configuration:
-	 */
-	if (smp_found_config)
-		early_get_smp_config();
-#endif
-	early_init_lapic_mapping();
-}
-
-int __init k8_get_nodes(struct bootnode *physnodes)
-{
-	int i;
-	int ret = 0;
-
-	for_each_node_mask(i, nodes_parsed) {
-		physnodes[ret].start = nodes[i].start;
-		physnodes[ret].end = nodes[i].end;
-		ret++;
-	}
-	return ret;
-}
-
-int __init k8_numa_init(unsigned long start_pfn, unsigned long end_pfn)
-{
-	unsigned long start = PFN_PHYS(start_pfn);
-	unsigned long end = PFN_PHYS(end_pfn);
-	unsigned numnodes;
-	unsigned long prevbase;
-	int i, nb, found = 0;
-	u32 nodeid, reg;
-
-	if (!early_pci_allowed())
-		return -1;
-
-	nb = find_northbridge();
-	if (nb < 0)
-		return nb;
-
-	pr_info("Scanning NUMA topology in Northbridge %d\n", nb);
-
-	reg = read_pci_config(0, nb, 0, 0x60);
-	numnodes = ((reg >> 4) & 0xF) + 1;
-	if (numnodes <= 1)
-		return -1;
-
-	pr_info("Number of physical nodes %d\n", numnodes);
-
-	prevbase = 0;
-	for (i = 0; i < 8; i++) {
-		unsigned long base, limit;
-
-		base = read_pci_config(0, nb, 1, 0x40 + i*8);
-		limit = read_pci_config(0, nb, 1, 0x44 + i*8);
-
-		nodeid = limit & 7;
-		if ((base & 3) == 0) {
-			if (i < numnodes)
-				pr_info("Skipping disabled node %d\n", i);
-			continue;
-		}
-		if (nodeid >= numnodes) {
-			pr_info("Ignoring excess node %d (%lx:%lx)\n", nodeid,
-				base, limit);
-			continue;
-		}
-
-		if (!limit) {
-			pr_info("Skipping node entry %d (base %lx)\n",
-				i, base);
-			continue;
-		}
-		if ((base >> 8) & 3 || (limit >> 8) & 3) {
-			pr_err("Node %d using interleaving mode %lx/%lx\n",
-			       nodeid, (base >> 8) & 3, (limit >> 8) & 3);
-			return -1;
-		}
-		if (node_isset(nodeid, nodes_parsed)) {
-			pr_info("Node %d already present, skipping\n",
-				nodeid);
-			continue;
-		}
-
-		limit >>= 16;
-		limit <<= 24;
-		limit |= (1<<24)-1;
-		limit++;
-
-		if (limit > end)
-			limit = end;
-		if (limit <= base)
-			continue;
-
-		base >>= 16;
-		base <<= 24;
-
-		if (base < start)
-			base = start;
-		if (limit > end)
-			limit = end;
-		if (limit == base) {
-			pr_err("Empty node %d\n", nodeid);
-			continue;
-		}
-		if (limit < base) {
-			pr_err("Node %d bogus settings %lx-%lx.\n",
-			       nodeid, base, limit);
-			continue;
-		}
-
-		/* Could sort here, but pun for now. Should not happen anyroads. */
-		if (prevbase > base) {
-			pr_err("Node map not sorted %lx,%lx\n",
-			       prevbase, base);
-			return -1;
-		}
-
-		pr_info("Node %d MemBase %016lx Limit %016lx\n",
-			nodeid, base, limit);
-
-		found++;
-
-		nodes[nodeid].start = base;
-		nodes[nodeid].end = limit;
-
-		prevbase = base;
-
-		node_set(nodeid, nodes_parsed);
-	}
-
-	if (!found)
-		return -1;
-	return 0;
-}
-
-int __init k8_scan_nodes(void)
-{
-	unsigned int bits;
-	unsigned int cores;
-	unsigned int apicid_base;
-	int i;
-
-	BUG_ON(nodes_empty(nodes_parsed));
-	node_possible_map = nodes_parsed;
-	memnode_shift = compute_hash_shift(nodes, 8, NULL);
-	if (memnode_shift < 0) {
-		pr_err("No NUMA node hash function found. Contact maintainer\n");
-		return -1;
-	}
-	pr_info("Using node hash shift of %d\n", memnode_shift);
-
-	/* use the coreid bits from early_identify_cpu */
-	bits = boot_cpu_data.x86_coreid_bits;
-	cores = (1<<bits);
-	apicid_base = 0;
-	/* get the APIC ID of the BSP early for systems with apicid lifting */
-	early_get_boot_cpu_id();
-	if (boot_cpu_physical_apicid > 0) {
-		pr_info("BSP APIC ID: %02x\n", boot_cpu_physical_apicid);
-		apicid_base = boot_cpu_physical_apicid;
-	}
-
-	for_each_node_mask(i, node_possible_map) {
-		int j;
-
-		memblock_x86_register_active_regions(i,
-				nodes[i].start >> PAGE_SHIFT,
-				nodes[i].end >> PAGE_SHIFT);
-		for (j = apicid_base; j < cores + apicid_base; j++)
-			apicid_to_node[(i << bits) + j] = i;
-		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
-	}
-
-	numa_init_array();
-	return 0;
-}
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 60f4985..701a598 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -267,7 +267,7 @@ static struct bootnode physnodes[MAX_NUMNODES] __initdata;
 static char *cmdline __initdata;
 
 static int __init setup_physnodes(unsigned long start, unsigned long end,
-					int acpi, int k8)
+					int acpi, int amd)
 {
 	int nr_nodes = 0;
 	int ret = 0;
@@ -277,13 +277,13 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
 	if (acpi)
 		nr_nodes = acpi_get_nodes(physnodes);
 #endif
-#ifdef CONFIG_K8_NUMA
-	if (k8)
-		nr_nodes = k8_get_nodes(physnodes);
+#ifdef CONFIG_AMD_NUMA
+	if (amd)
+		nr_nodes = amd_get_nodes(physnodes);
 #endif
 	/*
 	 * Basic sanity checking on the physical node map: there may be errors
-	 * if the SRAT or K8 incorrectly reported the topology or the mem=
+	 * if the SRAT or AMD code incorrectly reported the topology or the mem=
 	 * kernel parameter is used.
 	 */
 	for (i = 0; i < nr_nodes; i++) {
@@ -552,7 +552,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
  * numa=fake command-line option.
  */
 static int __init numa_emulation(unsigned long start_pfn,
-			unsigned long last_pfn, int acpi, int k8)
+			unsigned long last_pfn, int acpi, int amd)
 {
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
@@ -560,7 +560,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 	int num_nodes;
 	int i;
 
-	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
+	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, amd);
 	/*
 	 * If the numa=fake command-line contains a 'M' or 'G', it represents
 	 * the fixed node size.  Otherwise, if it is just a single number N,
@@ -605,7 +605,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 #endif /* CONFIG_NUMA_EMU */
 
 void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
-				int acpi, int k8)
+				int acpi, int amd)
 {
 	int i;
 
@@ -613,7 +613,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
+	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, amd))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
@@ -627,8 +627,8 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 #endif
 
-#ifdef CONFIG_K8_NUMA
-	if (!numa_off && k8 && !k8_scan_nodes())
+#ifdef CONFIG_AMD_NUMA
+	if (!numa_off && amd && !amd_scan_nodes())
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 42396df..b1f8bb5 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -38,7 +38,7 @@ static int agp_bridges_found;
 
 static void amd64_tlbflush(struct agp_memory *temp)
 {
-	k8_flush_garts();
+	amd_flush_garts();
 }
 
 static int amd64_insert_memory(struct agp_memory *mem, off_t pg_start, int type)
@@ -124,7 +124,7 @@ static int amd64_fetch_size(void)
 	u32 temp;
 	struct aper_size_info_32 *values;
 
-	dev = k8_northbridges.nb_misc[0];
+	dev = amd_northbridges.nb_misc[0];
 	if (dev==NULL)
 		return 0;
 
@@ -181,16 +181,16 @@ static int amd_8151_configure(void)
 	unsigned long gatt_bus = virt_to_phys(agp_bridge->gatt_table_real);
 	int i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return 0;
 
 	/* Configure AGP regs in each x86-64 host bridge. */
-	for (i = 0; i < k8_northbridges.num; i++) {
+	for (i = 0; i < amd_northbridges.num; i++) {
 		agp_bridge->gart_bus_addr =
-				amd64_configure(k8_northbridges.nb_misc[i],
+				amd64_configure(amd_northbridges.nb_misc[i],
 						gatt_bus);
 	}
-	k8_flush_garts();
+	amd_flush_garts();
 	return 0;
 }
 
@@ -200,11 +200,11 @@ static void amd64_cleanup(void)
 	u32 tmp;
 	int i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return;
 
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_northbridges.num; i++) {
+		struct pci_dev *dev = amd_northbridges.nb_misc[i];
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~GARTEN;
@@ -331,15 +331,15 @@ static __devinit int cache_nbs(struct pci_dev *pdev, u32 cap_ptr)
 {
 	int i;
 
-	if (cache_k8_northbridges() < 0)
+	if (cache_amd_northbridges() < 0)
 		return -ENODEV;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_northbridges.gart_supported)
 		return -ENODEV;
 
 	i = 0;
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_northbridges.num; i++) {
+		struct pci_dev *dev = amd_northbridges.nb_misc[i];
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
 			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
@@ -416,7 +416,7 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	}
 
 	/* shadow x86-64 registers into ULi registers */
-	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword (amd_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
 			       &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -484,7 +484,7 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, tmp);
 
 	/* shadow x86-64 registers into NVIDIA registers */
-	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword (amd_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
 			       &apbase);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -778,7 +778,7 @@ int __init agp_amd64_init(void)
 		}
 
 		/* First check that we have at least one AMD64 NB */
-		if (!pci_dev_present(k8_nb_ids))
+		if (!pci_dev_present(amd_nb_ids))
 			return -ENODEV;
 
 		/* Look for any AGP bridge */
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8521401..8b144cc 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2917,7 +2917,7 @@ static int __init amd64_edac_init(void)
 
 	opstate_init();
 
-	if (cache_k8_northbridges() < 0)
+	if (cache_amd_northbridges() < 0)
 		goto err_ret;
 
 	msrs = msrs_alloc();
@@ -2934,7 +2934,7 @@ static int __init amd64_edac_init(void)
 	 * to finish initialization of the MC instances.
 	 */
 	err = -ENODEV;
-	for (nb = 0; nb < k8_northbridges.num; nb++) {
+	for (nb = 0; nb < amd_northbridges.num; nb++) {
 		if (!pvt_lookup[nb])
 			continue;
 
-- 
1.5.6.5


