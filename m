Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846Ab0J2PPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 11:15:03 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:52456
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757923Ab0J2PPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 11:15:00 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i2a8h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3extmailp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LB250C-01-49S-02
X-M-MSG: 
From: Hans Rosenfeld <hans.rosenfeld@amd.com>
To: <hpa@zytor.com>, <tglx@linuxtronix.de>, <mingo@elte.hu>
CC: <linux-kernel@vger.kernel.org>, <andreas.herrmann3@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 2/3] Cleanup AMD northbridge caching code
Date: Fri, 29 Oct 2010 17:14:31 +0200
Message-ID: <1288365272-214117-2-git-send-email-hans.rosenfeld@amd.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1288365272-214117-1-git-send-email-hans.rosenfeld@amd.com>
References: <1288365272-214117-1-git-send-email-hans.rosenfeld@amd.com>
Organization: Advanced Micro Devices GmbH, Einsteinring 24, 85609 Dornach b. Muenchen; Geschaeftsfuehrer: Andrew Bowd, Alberto Bozzo; Sitz: Dornach, Gemeinde Aschheim, Landkreis Muenchen; Registergericht Muenchen, HRB Nr. 43632
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support more than just the "Misc Control" part of the Northbridges.
Support more flags by turning "gart_supported" into a single bit flag
that is stored in a flags member. Clean up related code by using
a set of functions (amd_nb_num(), amd_nb_has_feature() and
node_to_amd_nb()) instead of accessing the NB data structures directly.
Reorder the initialization code and put the GART flush words caching in
a separate function.

Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
---
 arch/x86/include/asm/amd_nb.h         |   34 ++++++++---
 arch/x86/kernel/amd_nb.c              |  109 +++++++++++++++++++--------------
 arch/x86/kernel/cpu/intel_cacheinfo.c |    6 +-
 arch/x86/kernel/pci-gart_64.c         |   24 ++++----
 drivers/char/agp/amd64-agp.c          |   29 ++++-----
 drivers/edac/amd64_edac.c             |    4 +-
 6 files changed, 118 insertions(+), 88 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 35b17a8..4d7ec7d 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -3,36 +3,52 @@
 
 #include <linux/pci.h>
 
-extern struct pci_device_id amd_nb_ids[];
+extern struct pci_device_id amd_nb_misc_ids[];
 struct bootnode;
 
 extern int early_is_amd_nb(u32 value);
-extern int cache_amd_northbridges(void);
+extern int amd_cache_northbridges(void);
 extern void amd_flush_garts(void);
 extern int amd_get_nodes(struct bootnode *nodes);
 extern int amd_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int amd_scan_nodes(void);
 
+struct amd_northbridge {
+	struct pci_dev *misc;
+};
+
 struct amd_northbridge_info {
 	u16 num;
-	u8 gart_supported;
-	struct pci_dev **nb_misc;
+	u64 flags;
+	struct amd_northbridge *nb;
 };
 extern struct amd_northbridge_info amd_northbridges;
 
+#define AMD_NB_GART			0x1
+
 #ifdef CONFIG_AMD_NB
 
-static inline struct pci_dev *node_to_amd_nb_misc(int node)
+static inline int amd_nb_num(void)
 {
-	return (node < amd_northbridges.num) ? amd_northbridges.nb_misc[node] : NULL;
+	return amd_northbridges.num;
 }
 
-#else
+static inline int amd_nb_has_feature(int feature)
+{
+	return ((amd_northbridges.flags & feature) == feature);
+}
 
-static inline struct pci_dev *node_to_amd_nb_misc(int node)
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
index c46df40..63c8b4f 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -12,74 +12,65 @@
 
 static u32 *flush_words;
 
-struct pci_device_id amd_nb_ids[] = {
+struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
 	{}
 };
-EXPORT_SYMBOL(amd_nb_ids);
+EXPORT_SYMBOL(amd_nb_misc_ids);
 
 struct amd_northbridge_info amd_northbridges;
 EXPORT_SYMBOL(amd_northbridges);
 
-static struct pci_dev *next_amd_northbridge(struct pci_dev *dev)
+static struct pci_dev *next_northbridge(struct pci_dev *dev,
+					struct pci_device_id *ids)
 {
 	do {
 		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
 		if (!dev)
 			break;
-	} while (!pci_match_id(&amd_nb_ids[0], dev));
+	} while (!pci_match_id(ids, dev));
 	return dev;
 }
 
-int cache_amd_northbridges(void)
+int amd_cache_northbridges(void)
 {
-	int i;
-	struct pci_dev *dev;
+	int i = 0;
+	struct amd_northbridge *nb;
+	struct pci_dev *misc;
 
-	if (amd_northbridges.num)
+	if (amd_nb_num())
 		return 0;
 
-	dev = NULL;
-	while ((dev = next_amd_northbridge(dev)) != NULL)
-		amd_northbridges.num++;
+	misc = NULL;
+	while ((misc = next_northbridge(misc, amd_nb_misc_ids)) != NULL)
+		i++;
 
-	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
-		amd_northbridges.gart_supported = 1;
+	if (i == 0)
+		return 0;
 
-	amd_northbridges.nb_misc = kmalloc((amd_northbridges.num + 1) *
-					  sizeof(void *), GFP_KERNEL);
-	if (!amd_northbridges.nb_misc)
+	nb = kzalloc(i * sizeof(struct amd_northbridge), GFP_KERNEL);
+	if (!nb)
 		return -ENOMEM;
 
-	if (!amd_northbridges.num) {
-		amd_northbridges.nb_misc[0] = NULL;
-		return 0;
-	}
+	amd_northbridges.nb = nb;
+	amd_northbridges.num = i;
 
-	if (amd_northbridges.gart_supported) {
-		flush_words = kmalloc(amd_northbridges.num * sizeof(u32),
-				      GFP_KERNEL);
-		if (!flush_words) {
-			kfree(amd_northbridges.nb_misc);
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
 
-	dev = NULL;
-	i = 0;
-	while ((dev = next_amd_northbridge(dev)) != NULL) {
-		amd_northbridges.nb_misc[i] = dev;
-		if (amd_northbridges.gart_supported)
-			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
-	}
-	amd_northbridges.nb_misc[i] = NULL;
 	return 0;
 }
-EXPORT_SYMBOL_GPL(cache_amd_northbridges);
+EXPORT_SYMBOL_GPL(amd_cache_northbridges);
 
 /* Ignores subdevice/subvendor but as far as I can figure out
    they're useless anyways */
@@ -88,19 +79,39 @@ int __init early_is_amd_nb(u32 device)
 	struct pci_device_id *id;
 	u32 vendor = device & 0xffff;
 	device >>= 16;
-	for (id = amd_nb_ids; id->vendor; id++)
+	for (id = amd_nb_misc_ids; id->vendor; id++)
 		if (vendor == id->vendor && device == id->device)
 			return 1;
 	return 0;
 }
 
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
 void amd_flush_garts(void)
 {
 	int flushed, i;
 	unsigned long flags;
 	static DEFINE_SPINLOCK(gart_lock);
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
 	/* Avoid races between AGP and IOMMU. In theory it's not needed
@@ -109,16 +120,16 @@ void amd_flush_garts(void)
 	   that it doesn't matter to serialize more. -AK */
 	spin_lock_irqsave(&gart_lock, flags);
 	flushed = 0;
-	for (i = 0; i < amd_northbridges.num; i++) {
-		pci_write_config_dword(amd_northbridges.nb_misc[i], 0x9c,
-				       flush_words[i]|1);
+	for (i = 0; i < amd_nb_num(); i++) {
+		pci_write_config_dword(node_to_amd_nb(i)->misc, 0x9c,
+				       flush_words[i] | 1);
 		flushed++;
 	}
-	for (i = 0; i < amd_northbridges.num; i++) {
+	for (i = 0; i < amd_nb_num(); i++) {
 		u32 w;
 		/* Make sure the hardware actually executed the flush*/
 		for (;;) {
-			pci_read_config_dword(amd_northbridges.nb_misc[i],
+			pci_read_config_dword(node_to_amd_nb(i)->misc,
 					      0x9c, &w);
 			if (!(w & 1))
 				break;
@@ -135,11 +146,15 @@ static __init int init_amd_nbs(void)
 {
 	int err = 0;
 
-	err = cache_amd_northbridges();
+	err = amd_cache_northbridges();
 
 	if (err < 0)
 		printk(KERN_NOTICE "AMD NB: Cannot enumerate AMD northbridges.\n");
 
+	if (amd_cache_gart() < 0)
+		printk(KERN_NOTICE "AMD NB: Cannot initialize GART flush words, "
+		       "GART support disabled.\n");
+
 	return err;
 }
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 92512ed..6b8ea74 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -333,7 +333,7 @@ static void __cpuinit amd_calc_l3_indices(struct amd_l3_cache *l3)
 static struct amd_l3_cache * __cpuinit amd_init_l3_cache(int node)
 {
 	struct amd_l3_cache *l3;
-	struct pci_dev *dev = node_to_amd_nb_misc(node);
+	struct pci_dev *dev = node_to_amd_nb(node)->misc;
 
 	l3 = kzalloc(sizeof(struct amd_l3_cache), GFP_ATOMIC);
 	if (!l3) {
@@ -370,7 +370,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 			return;
 
 	/* not in virtualized environments */
-	if (amd_northbridges.num == 0)
+	if (amd_nb_num() == 0)
 		return;
 
 	/*
@@ -378,7 +378,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 	 * never freed but this is done only on shutdown so it doesn't matter.
 	 */
 	if (!l3_caches) {
-		int size = amd_northbridges.num * sizeof(struct amd_l3_cache *);
+		int size = amd_nb_num() * sizeof(struct amd_l3_cache *);
 
 		l3_caches = kzalloc(size, GFP_ATOMIC);
 		if (!l3_caches)
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 63317c5..c01ffa5 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -561,11 +561,11 @@ static void enable_gart_translations(void)
 {
 	int i;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
-	for (i = 0; i < amd_northbridges.num; i++) {
-		struct pci_dev *dev = amd_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
@@ -596,13 +596,13 @@ static void gart_fixup_northbridges(struct sys_device *dev)
 	if (!fix_up_north_bridges)
 		return;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
 	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-	for (i = 0; i < amd_northbridges.num; i++) {
-		struct pci_dev *dev = amd_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 
 		/*
 		 * Don't enable translations just yet.  That is the next
@@ -656,8 +656,8 @@ static __init int init_amd_gatt(struct agp_kern_info *info)
 
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
-	for (i = 0; i < amd_northbridges.num; i++) {
-		dev = amd_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		dev = node_to_amd_nb(i)->misc;
 		new_aper_base = read_aperture(dev, &new_aper_size);
 		if (!new_aper_base)
 			goto nommu;
@@ -725,13 +725,13 @@ static void gart_iommu_shutdown(void)
 	if (!no_agp)
 		return;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
-	for (i = 0; i < amd_northbridges.num; i++) {
+	for (i = 0; i < amd_nb_num(); i++) {
 		u32 ctl;
 
-		dev = amd_northbridges.nb_misc[i];
+		dev = node_to_amd_nb(i)->misc;
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
 		ctl &= ~GARTEN;
@@ -749,7 +749,7 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index b1f8bb5..9252e85 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -124,7 +124,7 @@ static int amd64_fetch_size(void)
 	u32 temp;
 	struct aper_size_info_32 *values;
 
-	dev = amd_northbridges.nb_misc[0];
+	dev = node_to_amd_nb(0)->misc;
 	if (dev==NULL)
 		return 0;
 
@@ -181,14 +181,13 @@ static int amd_8151_configure(void)
 	unsigned long gatt_bus = virt_to_phys(agp_bridge->gatt_table_real);
 	int i;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return 0;
 
 	/* Configure AGP regs in each x86-64 host bridge. */
-	for (i = 0; i < amd_northbridges.num; i++) {
+	for (i = 0; i < amd_nb_num(); i++) {
 		agp_bridge->gart_bus_addr =
-				amd64_configure(amd_northbridges.nb_misc[i],
-						gatt_bus);
+			amd64_configure(node_to_amd_nb(i)->misc, gatt_bus);
 	}
 	amd_flush_garts();
 	return 0;
@@ -200,11 +199,11 @@ static void amd64_cleanup(void)
 	u32 tmp;
 	int i;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return;
 
-	for (i = 0; i < amd_northbridges.num; i++) {
-		struct pci_dev *dev = amd_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~GARTEN;
@@ -331,15 +330,15 @@ static __devinit int cache_nbs(struct pci_dev *pdev, u32 cap_ptr)
 {
 	int i;
 
-	if (cache_amd_northbridges() < 0)
+	if (amd_cache_northbridges() < 0)
 		return -ENODEV;
 
-	if (!amd_northbridges.gart_supported)
+	if (!amd_nb_has_feature(AMD_NB_GART))
 		return -ENODEV;
 
 	i = 0;
-	for (i = 0; i < amd_northbridges.num; i++) {
-		struct pci_dev *dev = amd_northbridges.nb_misc[i];
+	for (i = 0; i < amd_nb_num(); i++) {
+		struct pci_dev *dev = node_to_amd_nb(i)->misc;
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
 			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
@@ -416,7 +415,7 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	}
 
 	/* shadow x86-64 registers into ULi registers */
-	pci_read_config_dword (amd_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword (node_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
 			       &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -484,7 +483,7 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, tmp);
 
 	/* shadow x86-64 registers into NVIDIA registers */
-	pci_read_config_dword (amd_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+	pci_read_config_dword (node_to_amd_nb(0)->misc, AMD64_GARTAPERTUREBASE,
 			       &apbase);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
@@ -778,7 +777,7 @@ int __init agp_amd64_init(void)
 		}
 
 		/* First check that we have at least one AMD64 NB */
-		if (!pci_dev_present(amd_nb_ids))
+		if (!pci_dev_present(amd_nb_misc_ids))
 			return -ENODEV;
 
 		/* Look for any AGP bridge */
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 8b144cc..774f950 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2917,7 +2917,7 @@ static int __init amd64_edac_init(void)
 
 	opstate_init();
 
-	if (cache_amd_northbridges() < 0)
+	if (amd_cache_northbridges() < 0)
 		goto err_ret;
 
 	msrs = msrs_alloc();
@@ -2934,7 +2934,7 @@ static int __init amd64_edac_init(void)
 	 * to finish initialization of the MC instances.
 	 */
 	err = -ENODEV;
-	for (nb = 0; nb < amd_northbridges.num; nb++) {
+	for (nb = 0; nb < amd_nb_num(); nb++) {
 		if (!pvt_lookup[nb])
 			continue;
 
-- 
1.5.6.5


