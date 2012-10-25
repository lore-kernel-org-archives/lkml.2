Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2JYIdO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:33:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56098 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab2JYIdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:33:10 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH v3] Add support for AMD64 EDAC on multiple PCI domains
Date: Thu, 25 Oct 2012 16:32:52 +0800
Message-Id: <1351153972-14019-1-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
are contiguous, which no longer holds on federated systems with multiple
HyperTransport fabrics and multiple PCI domains, eg on Numascale's
Numaconnect systems with NumaChip.

Address this assumption by searching the Northbridge ID array, rather than
directly indexing it, using the upper bits for the PCI domain.

RFC->v2: Correct array initialisation
v2->v3: Add Boris's neater linked list approach

Todo:
1. fix kobject/sysfs oops (see http://quora.org/2012/16-server-boot.txt later)
2. reorder amd64_edac.c or add amd64_per_family_init/pci_get_related_function
   forward declarations, based on feedback

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h            |   63 +++++++++++++++-
 arch/x86/include/asm/numachip/numachip.h |   22 ++++++
 arch/x86/kernel/amd_gart_64.c            |    8 +-
 arch/x86/kernel/amd_nb.c                 |   85 ++++++++++++---------
 arch/x86/pci/numachip.c                  |  121 ++++++++++++++++++++++++++++++
 drivers/char/agp/amd64-agp.c             |   12 +--
 drivers/edac/amd64_edac.c                |   34 +++++----
 drivers/edac/amd64_edac.h                |    6 --
 8 files changed, 283 insertions(+), 68 deletions(-)
 create mode 100644 arch/x86/include/asm/numachip/numachip.h
 create mode 100644 arch/x86/pci/numachip.c

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9..6a27226 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -4,6 +4,8 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
+#define NUM_POSSIBLE_NBS	8
+
 struct amd_nb_bus_dev_range {
 	u8 bus;
 	u8 dev_base;
@@ -51,12 +53,22 @@ struct amd_northbridge {
 	struct pci_dev *link;
 	struct amd_l3_cache l3_cache;
 	struct threshold_bank *bank4;
+	u16 node;
+	struct list_head nbl;
 };
 
 struct amd_northbridge_info {
 	u16 num;
 	u64 flags;
-	struct amd_northbridge *nb;
+
+	/*
+	 * The first 8 elems are for fast lookup of NB descriptors on single-
+	 * system setups, i.e. "normal" boxes. The nb_list, OTOH, is list of
+	 * additional NB descriptors which exist on confederate systems
+	 * like using Numascale's Numaconnect/NumaChip.
+	 */
+	struct amd_northbridge *nbs[NUM_POSSIBLE_NBS];
+	struct list_head nb_list;
 };
 extern struct amd_northbridge_info amd_northbridges;
 
@@ -78,7 +90,54 @@ static inline bool amd_nb_has_feature(unsigned feature)
 
 static inline struct amd_northbridge *node_to_amd_nb(int node)
 {
-	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct amd_northbridge *nb;
+	int i;
+
+	/* Quick search for first domain */
+	if (node < NUM_POSSIBLE_NBS) {
+		if (node < nbi->num)
+			return nbi->nbs[node];
+		else
+			return NULL;
+	}
+
+	/* Search for NBs from later domains in array */
+	for (i = 0; i < NUM_POSSIBLE_NBS; i++)
+		if (nbi->nbs[i]->node == node)
+			return nbi->nbs[i];
+
+	list_for_each_entry(nb, &nbi->nb_list, nbl)
+		if (node == nb->node)
+			return nb;
+
+	return NULL;
+}
+
+static inline struct amd_northbridge *index_to_amd_nb(int index)
+{
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct amd_northbridge *nb;
+	int count = NUM_POSSIBLE_NBS;
+
+	if (index < NUM_POSSIBLE_NBS) {
+		if (index < nbi->num)
+			return nbi->nbs[index];
+		else
+			return NULL;
+	}
+
+	list_for_each_entry(nb, &nbi->nb_list, nbl) {
+		if (count++ == index)
+			return nb;
+	}
+
+	return NULL;
+}
+
+static inline u16 amd_get_node_id(struct pci_dev *pdev)
+{
+	return (pci_domain_nr(pdev->bus) << 3) | (PCI_SLOT(pdev->devfn) - 0x18);
 }
 
 #else
diff --git a/arch/x86/kernel/amd_gart_64.c b/arch/x86/kernel/amd_gart_64.c
index e663112..4f56487 100644
--- a/arch/x86/kernel/amd_gart_64.c
+++ b/arch/x86/kernel/amd_gart_64.c
@@ -573,7 +573,7 @@ static void enable_gart_translations(void)
 		return;
 
 	for (i = 0; i < amd_nb_num(); i++) {
-		struct pci_dev *dev = node_to_amd_nb(i)->misc;
+		struct pci_dev *dev = index_to_amd_nb(i)->misc;
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
@@ -610,7 +610,7 @@ static void gart_fixup_northbridges(void)
 	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
 	for (i = 0; i < amd_nb_num(); i++) {
-		struct pci_dev *dev = node_to_amd_nb(i)->misc;
+		struct pci_dev *dev = index_to_amd_nb(i)->misc;
 
 		/*
 		 * Don't enable translations just yet.  That is the next
@@ -652,7 +652,7 @@ static __init int init_amd_gatt(struct agp_kern_info *info)
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
 	for (i = 0; i < amd_nb_num(); i++) {
-		dev = node_to_amd_nb(i)->misc;
+		dev = index_to_amd_nb(i)->misc;
 		new_aper_base = read_aperture(dev, &new_aper_size);
 		if (!new_aper_base)
 			goto nommu;
@@ -721,7 +721,7 @@ static void gart_iommu_shutdown(void)
 	for (i = 0; i < amd_nb_num(); i++) {
 		u32 ctl;
 
-		dev = node_to_amd_nb(i)->misc;
+		dev = index_to_amd_nb(i)->misc;
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
 		ctl &= ~GARTEN;
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf335..e5e40ff 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -50,58 +50,70 @@ static struct pci_dev *next_northbridge(struct pci_dev *dev,
 	return dev;
 }
 
-int amd_cache_northbridges(void)
+static int _alloc_nb_desc(struct pci_dev *misc)
 {
-	u16 i = 0;
+	struct amd_northbridge_info *nbi = &amd_northbridges;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc, *link;
 
-	if (amd_nb_num())
-		return 0;
+	nb = kzalloc(sizeof(*nb), GFP_KERNEL);
+	if (!nb)
+		return -ENOMEM;
 
-	misc = NULL;
-	while ((misc = next_northbridge(misc, amd_nb_misc_ids)) != NULL)
-		i++;
+	nb->misc = misc;
+	nb->link = next_northbridge(nb->link, amd_nb_link_ids);
+	nb->node = amd_get_node_id(misc);
+
+	if (nbi->num < NUM_POSSIBLE_NBS) {
+		nbi->nbs[nbi->num] = nb;
+	} else {
+		INIT_LIST_HEAD(&nb->nbl);
+		list_add_tail(&nb->nbl, &nbi->nb_list);
+	}
+
+	nbi->num++;
+	return 0;
+}
 
-	if (i == 0)
+int amd_cache_northbridges(void)
+{
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	struct pci_dev *misc = NULL;
+
+	if (amd_nb_num())
 		return 0;
 
-	nb = kzalloc(i * sizeof(struct amd_northbridge), GFP_KERNEL);
-	if (!nb)
-		return -ENOMEM;
+	INIT_LIST_HEAD(&nbi->nb_list);
 
-	amd_northbridges.nb = nb;
-	amd_northbridges.num = i;
+	do {
+		misc = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, misc);
+		if (!misc)
+			break;
 
-	link = misc = NULL;
-	for (i = 0; i != amd_nb_num(); i++) {
-		node_to_amd_nb(i)->misc = misc =
-			next_northbridge(misc, amd_nb_misc_ids);
-		node_to_amd_nb(i)->link = link =
-			next_northbridge(link, amd_nb_link_ids);
-        }
+		if (pci_match_id(amd_nb_misc_ids, misc)) {
+			if (_alloc_nb_desc(misc) < 0)
+				return -ENOMEM;
+		}
+	} while (misc);
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_GART;
+	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x15)
+		nbi->flags |= AMD_NB_GART;
 
 	/*
 	 * Some CPU families support L3 Cache Index Disable. There are some
 	 * limitations because of E382 and E388 on family 0x10.
 	 */
-	if (boot_cpu_data.x86 == 0x10 &&
-	    boot_cpu_data.x86_model >= 0x8 &&
-	    (boot_cpu_data.x86_model > 0x9 ||
-	     boot_cpu_data.x86_mask >= 0x1))
-		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+	if (c->x86 == 0x10 && c->x86_model >= 0x8 &&
+	    (c->x86_model > 0x9 || c->x86_mask >= 0x1))
+		nbi->flags |= AMD_NB_L3_INDEX_DISABLE;
 
-	if (boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+	if (c->x86 == 0x15)
+		nbi->flags |= AMD_NB_L3_INDEX_DISABLE;
 
 	/* L3 cache partitioning is supported on family 0x15 */
-	if (boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
+	if (c->x86 == 0x15)
+		nbi->flags |= AMD_NB_L3_PARTITIONING;
 
 	return 0;
 }
@@ -223,8 +235,7 @@ static int amd_cache_gart(void)
        }
 
        for (i = 0; i != amd_nb_num(); i++)
-               pci_read_config_dword(node_to_amd_nb(i)->misc, 0x9c,
-                                     &flush_words[i]);
+		pci_read_config_dword(index_to_amd_nb(i)->misc, 0x9c, &flush_words[i]);
 
        return 0;
 }
@@ -245,7 +256,7 @@ void amd_flush_garts(void)
 	spin_lock_irqsave(&gart_lock, flags);
 	flushed = 0;
 	for (i = 0; i < amd_nb_num(); i++) {
-		pci_write_config_dword(node_to_amd_nb(i)->misc, 0x9c,
+		pci_write_config_dword(index_to_amd_nb(i)->misc, 0x9c,
 				       flush_words[i] | 1);
 		flushed++;
 	}
@@ -253,7 +264,7 @@ void amd_flush_garts(void)
 		u32 w;
 		/* Make sure the hardware actually executed the flush*/
 		for (;;) {
-			pci_read_config_dword(node_to_amd_nb(i)->misc,
+			pci_read_config_dword(index_to_amd_nb(i)->misc,
 					      0x9c, &w);
 			if (!(w & 1))
 				break;
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 444f8b6..84d2cdd 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -124,7 +124,7 @@ static int amd64_fetch_size(void)
 	u32 temp;
 	struct aper_size_info_32 *values;
 
-	dev = node_to_amd_nb(0)->misc;
+	dev = index_to_amd_nb(0)->misc;
 	if (dev==NULL)
 		return 0;
 
@@ -187,7 +187,7 @@ static int amd_8151_configure(void)
 	/* Configure AGP regs in each x86-64 host bridge. */
 	for (i = 0; i < amd_nb_num(); i++) {
 		agp_bridge->gart_bus_addr =
-			amd64_configure(node_to_amd_nb(i)->misc, gatt_bus);
+			amd64_configure(index_to_amd_nb(i)->misc, gatt_bus);
 	}
 	amd_flush_garts();
 	return 0;
@@ -203,7 +203,7 @@ static void amd64_cleanup(void)
 		return;
 
 	for (i = 0; i < amd_nb_num(); i++) {
-		struct pci_dev *dev = node_to_amd_nb(i)->misc;
+		struct pci_dev *dev = index_to_amd_nb(i)->misc;
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~GARTEN;
@@ -338,7 +338,7 @@ static __devinit int cache_nbs(struct pci_dev *pdev, u32 cap_ptr)
 
 	i = 0;
 	for (i = 0; i < amd_nb_num(); i++) {
-		struct pci_dev *dev = node_to_amd_nb(i)->misc;
+		struct pci_dev *dev = index_to_amd_nb(i)->misc;
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
 			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
@@ -415,7 +415,7 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	}
 
 	/* shadow x86-64 registers into ULi registers */
-	pci_read_config_dword (node_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword(index_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
 			       &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -483,7 +483,7 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, tmp);
 
 	/* shadow x86-64 registers into NVIDIA registers */
-	pci_read_config_dword (node_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword(index_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
 			       &apbase);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5a297a2..07df95d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -945,7 +945,8 @@ static u64 get_error_address(struct mce *m)
 		struct amd64_pvt *pvt;
 		u64 cc6_base, tmp_addr;
 		u32 tmp;
-		u8 mce_nid, intlv_en;
+		u16 mce_nid;
+		u8 intlv_en;
 
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
@@ -1004,11 +1005,17 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 
 	/* Factor in CC6 save area by reading dst node's limit reg */
 	if (c->x86 == 0x15) {
-		struct pci_dev *f1 = NULL;
-		u8 nid = dram_dst_node(pvt, range);
+		struct pci_dev *misc, *f1 = NULL;
+		struct amd64_family_type *fam_type;
+		u16 nid = dram_dst_node(pvt, range);
 		u32 llim;
 
-		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
+		misc = node_to_amd_nb(nid)->misc;
+		fam_type = amd64_per_family_init(pvt);
+		if (WARN_ON(!f1))
+			return;
+
+		f1 = pci_get_related_function(misc->vendor, fam_type->f1_id, misc);
 		if (WARN_ON(!f1))
 			return;
 
@@ -1493,7 +1500,7 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
 	u8 channel;
 	bool high_range = false;
 
-	u8 node_id    = dram_dst_node(pvt, range);
+	u16 node_id    = dram_dst_node(pvt, range);
 	u8 intlv_en   = dram_intlv_en(pvt, range);
 	u32 intlv_sel = dram_intlv_sel(pvt, range);
 
@@ -1723,7 +1730,8 @@ static struct pci_dev *pci_get_related_function(unsigned int vendor,
 
 	dev = pci_get_device(vendor, device, dev);
 	while (dev) {
-		if ((dev->bus->number == related->bus->number) &&
+		if (pci_domain_nr(dev->bus) == pci_domain_nr(related->bus) &&
+		    (dev->bus->number == related->bus->number) &&
 		    (PCI_SLOT(dev->devfn) == PCI_SLOT(related->devfn)))
 			break;
 		dev = pci_get_device(vendor, device, dev);
@@ -2299,7 +2307,7 @@ out:
 	return ret;
 }
 
-static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
+static int toggle_ecc_err_reporting(struct ecc_settings *s, u16 nid, bool on)
 {
 	cpumask_var_t cmask;
 	int cpu;
@@ -2337,7 +2345,7 @@ static int toggle_ecc_err_reporting(struct ecc_settings *s, u8 nid, bool on)
 	return 0;
 }
 
-static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static bool enable_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 				       struct pci_dev *F3)
 {
 	bool ret = true;
@@ -2389,7 +2397,7 @@ static bool enable_ecc_error_reporting(struct ecc_settings *s, u8 nid,
 	return ret;
 }
 
-static void restore_ecc_error_reporting(struct ecc_settings *s, u8 nid,
+static void restore_ecc_error_reporting(struct ecc_settings *s, u16 nid,
 					struct pci_dev *F3)
 {
 	u32 value, mask = 0x3;		/* UECC/CECC enable */
@@ -2428,7 +2436,7 @@ static const char *ecc_msg =
 	"'ecc_enable_override'.\n"
 	" (Note that use of the override may cause unknown side effects.)\n";
 
-static bool ecc_enabled(struct pci_dev *F3, u8 nid)
+static bool ecc_enabled(struct pci_dev *F3, u16 nid)
 {
 	u32 value;
 	u8 ecc_en = 0;
@@ -2549,7 +2557,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u8 nid = get_node_id(F2);
+	u16 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2640,7 +2648,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2690,7 +2698,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u8 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 8d48047..90cae61 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -290,12 +290,6 @@
 /* MSRs */
 #define MSR_MCGCTL_NBE			BIT(4)
 
-/* AMD sets the first MC device at device ID 0x18. */
-static inline u8 get_node_id(struct pci_dev *pdev)
-{
-	return PCI_SLOT(pdev->devfn) - 0x18;
-}
-
 enum amd_families {
 	K8_CPUS = 0,
 	F10_CPUS,
-- 
1.7.9.5

