Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1AFJh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:37:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48079 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1AFJhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:37:53 -0500
Date: Thu, 6 Jan 2011 10:37:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/amd-nb changes for v2.6.38
Message-ID: <20110106093732.GA17230@elte.hu>
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

Please pull the latest x86-amd-nb-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-amd-nb-for-linus


out-of-topic modifications in x86-amd-nb-for-linus:
---------------------------------------------------
drivers/char/agp/amd64-agp.c       # 9653a5c: x86, amd-nb: Cleanup AMD northbri
                                   # eec1d4f: x86, amd-nb: Complete the rename 
drivers/edac/amd64_edac.c          # 9653a5c: x86, amd-nb: Cleanup AMD northbri
                                   # eec1d4f: x86, amd-nb: Complete the rename 

 Thanks,

	Ingo

------------------>
Hans Rosenfeld (3):
      x86, amd-nb: Complete the rename of AMD NB and related code
      x86, amd-nb: Cleanup AMD northbridge caching code
      x86, cacheinfo: Cleanup L3 cache index disable support


 arch/x86/Kconfig                                  |   12 +-
 arch/x86/include/asm/amd_nb.h                     |   49 +++++---
 arch/x86/kernel/amd_nb.c                          |  135 +++++++++++--------
 arch/x86/kernel/aperture_64.c                     |   10 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c             |  147 +++++++++------------
 arch/x86/kernel/pci-gart_64.c                     |   34 +++---
 arch/x86/kernel/setup.c                           |    8 +-
 arch/x86/mm/Makefile                              |    2 +-
 arch/x86/mm/{k8topology_64.c => amdtopology_64.c} |   12 +-
 arch/x86/mm/numa_64.c                             |   22 ++--
 drivers/char/agp/amd64-agp.c                      |   33 +++---
 drivers/edac/amd64_edac.c                         |    4 +-
 12 files changed, 244 insertions(+), 224 deletions(-)
 rename arch/x86/mm/{k8topology_64.c => amdtopology_64.c} (94%)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..08993a3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1141,16 +1141,16 @@ config NUMA
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
index c8517f8..6aee50d 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -3,36 +3,53 @@
 
 #include <linux/pci.h>
 
-extern struct pci_device_id k8_nb_ids[];
+extern struct pci_device_id amd_nb_misc_ids[];
 struct bootnode;
 
-extern int early_is_k8_nb(u32 value);
-extern int cache_k8_northbridges(void);
-extern void k8_flush_garts(void);
-extern int k8_get_nodes(struct bootnode *nodes);
-extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
-extern int k8_scan_nodes(void);
+extern int early_is_amd_nb(u32 value);
+extern int amd_cache_northbridges(void);
+extern void amd_flush_garts(void);
+extern int amd_get_nodes(struct bootnode *nodes);
+extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
+extern int amd_scan_nodes(void);
 
-struct k8_northbridge_info {
+struct amd_northbridge {
+	struct pci_dev *misc;
+};
+
+struct amd_northbridge_info {
 	u16 num;
-	u8 gart_supported;
-	struct pci_dev **nb_misc;
+	u64 flags;
+	struct amd_northbridge *nb;
 };
-extern struct k8_northbridge_info k8_northbridges;
+extern struct amd_northbridge_info amd_northbridges;
+
+#define AMD_NB_GART			0x1
+#define AMD_NB_L3_INDEX_DISABLE		0x2
 
 #ifdef CONFIG_AMD_NB
 
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
+static inline int amd_nb_num(void)
 {
-	return (node < k8_northbridges.num) ? k8_northbridges.nb_misc[node] : NULL;
+	return amd_northbridges.num;
 }
 
-#else
+static inline int amd_nb_has_feature(int feature)
+{
+	return ((amd_northbridges.flags & feature) == feature);
+}
 
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
+static inline struct amd_northbridge *node_to_amd_nb(int node)
 {
-	return NULL;
+	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
+
+#else
+
+#define amd_nb_num(x)		0
+#define amd_nb_has_feature(x)	false
+#define node_to_amd_nb(x)	NULL
+
 #endif
 
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 8f6463d..affacb5 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -12,95 +12,116 @@
 
 static u32 *flush_words;
 
-struct pci_device_id k8_nb_ids[] = {
+struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
 	{}
 };
-EXPORT_SYMBOL(k8_nb_ids);
+EXPORT_SYMBOL(amd_nb_misc_ids);
 
-struct k8_northbridge_info k8_northbridges;
-EXPORT_SYMBOL(k8_northbridges);
+struct amd_northbridge_info amd_northbridges;
+EXPORT_SYMBOL(amd_northbridges);
 
-static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
+static struct pci_dev *next_northbridge(struct pci_dev *dev,
+					struct pci_device_id *ids)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
 		if (!dev)
 			break;
-	} while (!pci_match_id(&k8_nb_ids[0], dev));
+	} while (!pci_match_id(ids, dev));
 	return dev;
 }
 
-int cache_k8_northbridges(void)
+int amd_cache_northbridges(void)
 {
-	int i;
-	struct pci_dev *dev;
+	int i = 0;
+	struct amd_northbridge *nb;
+	struct pci_dev *misc;
 
-	if (k8_northbridges.num)
+	if (amd_nb_num())
 		return 0;
 
-	dev = NULL;
-	while ((dev = next_k8_northbridge(dev)) != NULL)
-		k8_northbridges.num++;
+	misc = NULL;
+	while ((misc = next_northbridge(misc, amd_nb_misc_ids)) != NULL)
+		i++;
 
-	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
-		k8_northbridges.gart_supported = 1;
+	if (i == 0)
+		return 0;
 
-	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
-					  sizeof(void *), GFP_KERNEL);
-	if (!k8_northbridges.nb_misc)
+	nb = kzalloc(i * sizeof(struct amd_northbridge), GFP_KERNEL);
+	if (!nb)
 		return -ENOMEM;
 
-	if (!k8_northbridges.num) {
-		k8_northbridges.nb_misc[0] = NULL;
-		return 0;
-	}
+	amd_northbridges.nb = nb;
+	amd_northbridges.num = i;
 
-	if (k8_northbridges.gart_supported) {
-		flush_words = kmalloc(k8_northbridges.num * sizeof(u32),
-				      GFP_KERNEL);
-		if (!flush_words) {
-			kfree(k8_northbridges.nb_misc);
-			return -ENOMEM;
-		}
-	}
+	misc = NULL;
+	for (i = 0; i != amd_nb_num(); i++) {
+		node_to_amd_nb(i)->misc = misc =
+			next_northbridge(misc, amd_nb_misc_ids);
+        }
+
+	/* some CPU families (e.g. family 0x11) do not support GART */
+	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
+	    boot_cpu_data.x86 == 0x15)
+		amd_northbridges.flags |= AMD_NB_GART;
+
+	/*
+	 * Some CPU families support L3 Cache Index Disable. There are some
+	 * limitations because of E382 and E388 on family 0x10.
+	 */
+	if (boot_cpu_data.x86 == 0x10 &&
+	    boot_cpu_data.x86_model >= 0x8 &&
+	    (boot_cpu_data.x86_model > 0x9 ||
+	     boot_cpu_data.x86_mask >= 0x1))
+		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
 
-	dev = NULL;
-	i = 0;
-	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges.nb_misc[i] = dev;
-		if (k8_northbridges.gart_supported)
-			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
-	}
-	k8_northbridges.nb_misc[i] = NULL;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cache_k8_northbridges);
+EXPORT_SYMBOL_GPL(amd_cache_northbridges);
 
 /* Ignores subdevice/subvendor but as far as I can figure out
    they're useless anyways */
-int __init early_is_k8_nb(u32 device)
+int __init early_is_amd_nb(u32 device)
 {
 	struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
 	device >>= 16;
-	for (id = k8_nb_ids; id->vendor; id++)
+	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
 			return 1;
 	return 0;
 }
 
-void k8_flush_garts(void)
+int amd_cache_gart(void)
+{
+       int i;
+
+       if (!amd_nb_has_feature(AMD_NB_GART))
+               return 0;
+
+       flush_words = kmalloc(amd_nb_num() * sizeof(u32), GFP_KERNEL);
+       if (!flush_words) {
+               amd_northbridges.flags &= ~AMD_NB_GART;
+               return -ENOMEM;
+       }
+
+       for (i = 0; i != amd_nb_num(); i++)
+               pci_read_config_dword(node_to_amd_nb(i)->misc, 0x9c,
+                                     &flush_words[i]);
+
+       return 0;
+}
+
+void amd_flush_garts(void)
 {
 	int flushed, i;
 	unsigned long flags;
 	static DEFINE_SPINLOCK(gart_lock);
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
 	/* Avoid races between AGP and IOMMU. In theory it's not needed
@@ -109,16 +130,16 @@ void k8_flush_garts(void)
 	   that it doesn't matter to serialize more. -AK */
 	spin_lock_irqsave(&gart_lock, flags);
 	flushed = 0;
-	for (i = 0; i < k8_northbridges.num; i++) {
-		pci_write_config_dword(k8_northbridges.nb_misc[i], 0x9c,
-				       flush_words[i]|1);
+	for (i = 0; i < amd_nb_num(); i++) {
+		pci_write_config_dword(node_to_amd_nb(i)->misc, 0x9c,
+				       flush_words[i] | 1);
 		flushed++;
 	}
-	for (i = 0; i < k8_northbridges.num; i++) {
+	for (i = 0; i < amd_nb_num(); i++) {
 		u32 w;
 		/* Make sure the hardware actually executed the flush*/
 		for (;;) {
-			pci_read_config_dword(k8_northbridges.nb_misc[i],
+			pci_read_config_dword(node_to_amd_nb(i)->misc,
 					      0x9c, &w);
 			if (!(w & 1))
 				break;
@@ -129,19 +150,23 @@ void k8_flush_garts(void)
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
+	err = amd_cache_northbridges();
 
 	if (err < 0)
-		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
+		printk(KERN_NOTICE "AMD NB: Cannot enumerate AMD northbridges.\n");
+
+	if (amd_cache_gart() < 0)
+		printk(KERN_NOTICE "AMD NB: Cannot initialize GART flush words, "
+		       "GART support disabled.\n");
 
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
index 17ad033..9ecf81f 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -149,8 +149,7 @@ union _cpuid4_leaf_ecx {
 };
 
 struct amd_l3_cache {
-	struct	 pci_dev *dev;
-	bool	 can_disable;
+	struct	 amd_northbridge *nb;
 	unsigned indices;
 	u8	 subcaches[4];
 };
@@ -311,14 +310,12 @@ struct _cache_attr {
 /*
  * L3 cache descriptors
  */
-static struct amd_l3_cache **__cpuinitdata l3_caches;
-
 static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 {
 	unsigned int sc0, sc1, sc2, sc3;
 	u32 val = 0;
 
-	pci_read_config_dword(l3->dev, 0x1C4, &val);
+	pci_read_config_dword(l3->nb->misc, 0x1C4, &val);
 
 	/* calculate subcache sizes */
 	l3->subcaches[0] = sc0 = !(val & BIT(0));
@@ -330,47 +327,14 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 	l3->indices = (max(max3(sc0, sc1, sc2), sc3) << 10) - 1;
 }
 
-static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
-{
-	struct amd_l3_cache *l3;
-	struct pci_dev *dev = node_to_k8_nb_misc(node);
-
-	l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
-	if (!l3) {
-		printk(KERN_WARNING "Error allocating L3 struct\n");
-		return NULL;
-	}
-
-	l3->dev = dev;
-
-	amd_calc_l3_indices(l3);
-
-	return l3;
-}
-
-static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
-					   int index)
+static void __cpuinit amd_init_l3_cache(struct _cpuid4_info_regs *this_leaf,
+					int index)
 {
+	static struct amd_l3_cache *__cpuinitdata l3_caches;
 	int node;
 
-	if (boot_cpu_data.x86 != 0x10)
-		return;
-
-	if (index < 3)
-		return;
-
-	/* see errata #382 and #388 */
-	if (boot_cpu_data.x86_model < 0x8)
-		return;
-
-	if ((boot_cpu_data.x86_model == 0x8 ||
-	     boot_cpu_data.x86_model == 0x9)
-		&&
-	     boot_cpu_data.x86_mask < 0x1)
-			return;
-
-	/* not in virtualized environments */
-	if (k8_northbridges.num == 0)
+	/* only for L3, and not in virtualized environments */
+	if (index < 3 || amd_nb_num() == 0)
 		return;
 
 	/*
@@ -378,7 +342,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 	 * never freed but this is done only on shutdown so it doesn't matter.
 	 */
 	if (!l3_caches) {
-		int size = k8_northbridges.num * sizeof(struct amd_l3_cache *);
+		int size = amd_nb_num() * sizeof(struct amd_l3_cache);
 
 		l3_caches = kzalloc(size, GFP_ATOMIC);
 		if (!l3_caches)
@@ -387,14 +351,12 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 
 	node = amd_get_nb_id(smp_processor_id());
 
-	if (!l3_caches[node]) {
-		l3_caches[node] = amd_init_l3_cache(node);
-		l3_caches[node]->can_disable = true;
+	if (!l3_caches[node].nb) {
+		l3_caches[node].nb = node_to_amd_nb(node);
+		amd_calc_l3_indices(&l3_caches[node]);
 	}
 
-	WARN_ON(!l3_caches[node]);
-
-	this_leaf->l3 = l3_caches[node];
+	this_leaf->l3 = &l3_caches[node];
 }
 
 /*
@@ -408,7 +370,7 @@ int amd_get_l3_disable_slot(struct amd_l3_cache *l3, unsigned slot)
 {
 	unsigned int reg = 0;
 
-	pci_read_config_dword(l3->dev, 0x1BC + slot * 4, &reg);
+	pci_read_config_dword(l3->nb->misc, 0x1BC + slot * 4, &reg);
 
 	/* check whether this slot is activated already */
 	if (reg & (3UL << 30))
@@ -422,7 +384,8 @@ static ssize_t show_cache_disable(struct _cpuid4_info *this_leaf, char *buf,
 {
 	int index;
 
-	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
+	if (!this_leaf->l3 ||
+	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
 	index = amd_get_l3_disable_slot(this_leaf->l3, slot);
@@ -457,7 +420,7 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
 		if (!l3->subcaches[i])
 			continue;
 
-		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
+		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
 
 		/*
 		 * We need to WBINVD on a core on the node containing the L3
@@ -467,7 +430,7 @@ static void amd_l3_disable_index(struct amd_l3_cache *l3, int cpu,
 		wbinvd_on_cpu(cpu);
 
 		reg |= BIT(31);
-		pci_write_config_dword(l3->dev, 0x1BC + slot * 4, reg);
+		pci_write_config_dword(l3->nb->misc, 0x1BC + slot * 4, reg);
 	}
 }
 
@@ -524,7 +487,8 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!this_leaf->l3 || !this_leaf->l3->can_disable)
+	if (!this_leaf->l3 ||
+	    !amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
 		return -EINVAL;
 
 	cpu = cpumask_first(to_cpumask(this_leaf->shared_cpu_map));
@@ -545,7 +509,7 @@ static ssize_t store_cache_disable(struct _cpuid4_info *this_leaf,
 #define STORE_CACHE_DISABLE(slot)					\
 static ssize_t								\
 store_cache_disable_##slot(struct _cpuid4_info *this_leaf,		\
-			    const char *buf, size_t count)		\
+			   const char *buf, size_t count)		\
 {									\
 	return store_cache_disable(this_leaf, buf, count, slot);	\
 }
@@ -558,10 +522,7 @@ static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
 #else	/* CONFIG_AMD_NB */
-static void __cpuinit
-amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
-{
-};
+#define amd_init_l3_cache(x, y)
 #endif /* CONFIG_AMD_NB */
 
 static int
@@ -575,7 +536,7 @@ __cpuinit cpuid4_cache_lookup_regs(int index,
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD) {
 		amd_cpuid4(index, &eax, &ebx, &ecx);
-		amd_check_l3_disable(this_leaf, index);
+		amd_init_l3_cache(this_leaf, index);
 	} else {
 		cpuid_count(4, index, &eax.full, &ebx.full, &ecx.full, &edx);
 	}
@@ -983,30 +944,48 @@ define_one_ro(size);
 define_one_ro(shared_cpu_map);
 define_one_ro(shared_cpu_list);
 
-#define DEFAULT_SYSFS_CACHE_ATTRS	\
-	&type.attr,			\
-	&level.attr,			\
-	&coherency_line_size.attr,	\
-	&physical_line_partition.attr,	\
-	&ways_of_associativity.attr,	\
-	&number_of_sets.attr,		\
-	&size.attr,			\
-	&shared_cpu_map.attr,		\
-	&shared_cpu_list.attr
-
 static struct attribute *default_attrs[] = {
-	DEFAULT_SYSFS_CACHE_ATTRS,
+	&type.attr,
+	&level.attr,
+	&coherency_line_size.attr,
+	&physical_line_partition.attr,
+	&ways_of_associativity.attr,
+	&number_of_sets.attr,
+	&size.attr,
+	&shared_cpu_map.attr,
+	&shared_cpu_list.attr,
 	NULL
 };
 
-static struct attribute *default_l3_attrs[] = {
-	DEFAULT_SYSFS_CACHE_ATTRS,
 #ifdef CONFIG_AMD_NB
-	&cache_disable_0.attr,
-	&cache_disable_1.attr,
+static struct attribute ** __cpuinit amd_l3_attrs(void)
+{
+	static struct attribute **attrs;
+	int n;
+
+	if (attrs)
+		return attrs;
+
+	n = sizeof (default_attrs) / sizeof (struct attribute *);
+
+	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE))
+		n += 2;
+
+	attrs = kzalloc(n * sizeof (struct attribute *), GFP_KERNEL);
+	if (attrs == NULL)
+		return attrs = default_attrs;
+
+	for (n = 0; default_attrs[n]; n++)
+		attrs[n] = default_attrs[n];
+
+	if (amd_nb_has_feature(AMD_NB_L3_INDEX_DISABLE)) {
+		attrs[n++] = &cache_disable_0.attr;
+		attrs[n++] = &cache_disable_1.attr;
+	}
+
+	return attrs;
+}
 #endif
-	NULL
-};
 
 static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 {
@@ -1117,11 +1096,11 @@ static int __cpuinit cache_add_dev(struct sys_device * sys_dev)
 
 		this_leaf = CPUID4_INFO_IDX(cpu, i);
 
-		if (this_leaf->l3 && this_leaf->l3->can_disable)
-			ktype_cache.default_attrs = default_l3_attrs;
-		else
-			ktype_cache.default_attrs = default_attrs;
-
+		ktype_cache.default_attrs = default_attrs;
+#ifdef CONFIG_AMD_NB
+		if (this_leaf->l3)
+			ktype_cache.default_attrs = amd_l3_attrs();
+#endif
 		retval = kobject_init_and_add(&(this_object->kobj),
 					      &ktype_cache,
 					      per_cpu(ici_cache_kobject, cpu),
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index ba0f0ca..c01ffa5 100644
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
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 
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
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
 	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 
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
+	for (i = 0; i < amd_nb_num(); i++) {
+		dev = node_to_amd_nb(i)->misc;
 		new_aper_base = read_aperture(dev, &new_aper_size);
 		if (!new_aper_base)
 			goto nommu;
@@ -725,13 +725,13 @@ static void gart_iommu_shutdown(void)
 	if (!no_agp)
 		return;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
-	for (i = 0; i < k8_northbridges.num; i++) {
+	for (i = 0; i < amd_nb_num(); i++) {
 		u32 ctl;
 
-		dev = k8_northbridges.nb_misc[i];
+		dev = node_to_amd_nb(i)->misc;
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
 		ctl &= ~GARTEN;
@@ -749,14 +749,14 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
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
index 21c6746..df172c1 100644
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
@@ -981,12 +981,12 @@ void __init setup_arch(char **cmdline_p)
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
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/amdtopology_64.c
similarity index 94%
rename from arch/x86/mm/k8topology_64.c
rename to arch/x86/mm/amdtopology_64.c
index 804a3b6..51fae9c 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/amdtopology_64.c
@@ -1,8 +1,8 @@
 /*
- * AMD K8 NUMA support.
+ * AMD NUMA support.
  * Discover the memory map and associated nodes.
  *
- * This version reads it directly from the K8 northbridge.
+ * This version reads it directly from the AMD northbridge.
  *
  * Copyright 2002,2003 Andi Kleen, SuSE Labs.
  */
@@ -57,7 +57,7 @@ static __init void early_get_boot_cpu_id(void)
 {
 	/*
 	 * need to get the APIC ID of the BSP so can use that to
-	 * create apicid_to_node in k8_scan_nodes()
+	 * create apicid_to_node in amd_scan_nodes()
 	 */
 #ifdef CONFIG_X86_MPPARSE
 	/*
@@ -69,7 +69,7 @@ static __init void early_get_boot_cpu_id(void)
 	early_init_lapic_mapping();
 }
 
-int __init k8_get_nodes(struct bootnode *physnodes)
+int __init amd_get_nodes(struct bootnode *physnodes)
 {
 	int i;
 	int ret = 0;
@@ -82,7 +82,7 @@ int __init k8_get_nodes(struct bootnode *physnodes)
 	return ret;
 }
 
-int __init k8_numa_init(unsigned long start_pfn, unsigned long end_pfn)
+int __init amd_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 {
 	unsigned long start = PFN_PHYS(start_pfn);
 	unsigned long end = PFN_PHYS(end_pfn);
@@ -194,7 +194,7 @@ int __init k8_numa_init(unsigned long start_pfn, unsigned long end_pfn)
 	return 0;
 }
 
-int __init k8_scan_nodes(void)
+int __init amd_scan_nodes(void)
 {
 	unsigned int bits;
 	unsigned int cores;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 7ffc9b7..7762a51 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -264,7 +264,7 @@ static struct bootnode physnodes[MAX_NUMNODES] __initdata;
 static char *cmdline __initdata;
 
 static int __init setup_physnodes(unsigned long start, unsigned long end,
-					int acpi, int k8)
+					int acpi, int amd)
 {
 	int nr_nodes = 0;
 	int ret = 0;
@@ -274,13 +274,13 @@ static int __init setup_physnodes(unsigned long start, unsigned long end,
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
@@ -549,7 +549,7 @@ static int __init split_nodes_size_interleave(u64 addr, u64 max_addr, u64 size)
  * numa=fake command-line option.
  */
 static int __init numa_emulation(unsigned long start_pfn,
-			unsigned long last_pfn, int acpi, int k8)
+			unsigned long last_pfn, int acpi, int amd)
 {
 	u64 addr = start_pfn << PAGE_SHIFT;
 	u64 max_addr = last_pfn << PAGE_SHIFT;
@@ -557,7 +557,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 	int num_nodes;
 	int i;
 
-	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, k8);
+	num_phys_nodes = setup_physnodes(addr, max_addr, acpi, amd);
 	/*
 	 * If the numa=fake command-line contains a 'M' or 'G', it represents
 	 * the fixed node size.  Otherwise, if it is just a single number N,
@@ -602,7 +602,7 @@ static int __init numa_emulation(unsigned long start_pfn,
 #endif /* CONFIG_NUMA_EMU */
 
 void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
-				int acpi, int k8)
+				int acpi, int amd)
 {
 	int i;
 
@@ -610,7 +610,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
 	nodes_clear(node_online_map);
 
 #ifdef CONFIG_NUMA_EMU
-	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
+	if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, amd))
 		return;
 	nodes_clear(node_possible_map);
 	nodes_clear(node_online_map);
@@ -624,8 +624,8 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
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
index 42396df..9252e85 100644
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
+	dev = node_to_amd_nb(0)->misc;
 	if (dev==NULL)
 		return 0;
 
@@ -181,16 +181,15 @@ static int amd_8151_configure(void)
 	unsigned long gatt_bus = virt_to_phys(agp_bridge->gatt_table_real);
 	int i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return 0;
 
 	/* Configure AGP regs in each x86-64 host bridge. */
-	for (i = 0; i < k8_northbridges.num; i++) {
+	for (i = 0; i < amd_nb_num(); i++) {
 		agp_bridge->gart_bus_addr =
-				amd64_configure(k8_northbridges.nb_misc[i],
-						gatt_bus);
+			amd64_configure(node_to_amd_nb(i)->misc, gatt_bus);
 	}
-	k8_flush_garts();
+	amd_flush_garts();
 	return 0;
 }
 
@@ -200,11 +199,11 @@ static void amd64_cleanup(void)
 	u32 tmp;
 	int i;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~GARTEN;
@@ -331,15 +330,15 @@ static __devinit int cache_nbs(struct pci_dev *pdev, u32 cap_ptr)
 {
 	int i;
 
-	if (cache_k8_northbridges() < 0)
+	if (amd_cache_northbridges() < 0)
 		return -ENODEV;
 
-	if (!k8_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return -ENODEV;
 
 	i = 0;
-	for (i = 0; i < k8_northbridges.num; i++) {
-		struct pci_dev *dev = k8_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
 			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
@@ -416,7 +415,7 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	}
 
 	/* shadow x86-64 registers into ULi registers */
-	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword (node_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
 			       &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -484,7 +483,7 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, tmp);
 
 	/* shadow x86-64 registers into NVIDIA registers */
-	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword (node_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
 			       &apbase);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -778,7 +777,7 @@ int __init agp_amd64_init(void)
 		}
 
 		/* First check that we have at least one AMD64 NB */
-		if (!pci_dev_present(k8_nb_ids))
+		if (!pci_dev_present(amd_nb_misc_ids))
 			return -ENODEV;
 
 		/* Look for any AGP bridge */
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8521401..774f950 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2917,7 +2917,7 @@ static int __init amd64_edac_init(void)
 
 	opstate_init();
 
-	if (cache_k8_northbridges() < 0)
+	if (amd_cache_northbridges() < 0)
 		goto err_ret;
 
 	msrs = msrs_alloc();
@@ -2934,7 +2934,7 @@ static int __init amd64_edac_init(void)
 	 * to finish initialization of the MC instances.
 	 */
 	err = -ENODEV;
-	for (nb = 0; nb < k8_northbridges.num; nb++) {
+	for (nb = 0; nb < amd_nb_num(); nb++) {
 		if (!pvt_lookup[nb])
 			continue;
 
