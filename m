Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0IQPgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:36:40 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53522 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304Ab0IQPgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:36:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Zea0P5qZGU7Rdjb1X80RHV/HZJ9v4akvCX5VD0nGizW2GyVFpzeU1Rn6GHyJw6VZVK
         Sjh4v6m6F/lSBZO7xuJku4oTho6LxOwmbQmIwrB9m97RETBn7Eg4+wYmtHscAVjdj1ym
         vajnE3Ton9YeDfSdU3/avuDIDfWNiLEYVM9ug=
Date: Fri, 17 Sep 2010 18:02:54 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 2/3] x86, k8-gart: Decouple handling of garts and
 northbridges
Message-ID: <20100917160254.GC4958@loge.amd.com>
References: <20100917155904.GA4958@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917155904.GA4958@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

So far we only provide num_k8_northbridges. This is required in
different areas (e.g. L3 cache index disable, GART). But not all AMD
CPUs provide a GART. Thus it is useful to split off the GART handling
from the generic caching of AMD northbridge misc devices.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/k8.h             |   13 +++++---
 arch/x86/kernel/cpu/intel_cacheinfo.c |    4 +-
 arch/x86/kernel/k8.c                  |   52 +++++++++++++++++++--------------
 arch/x86/kernel/pci-gart_64.c         |   27 +++++++++++------
 drivers/char/agp/amd64-agp.c          |   33 ++++++++++++++------
 drivers/edac/amd64_edac.c             |    2 +-
 6 files changed, 82 insertions(+), 49 deletions(-)

diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index af00bd1..9cee145 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -7,24 +7,27 @@ extern struct pci_device_id k8_nb_ids[];
 struct bootnode;
 
 extern int early_is_k8_nb(u32 value);
-extern struct pci_dev **k8_northbridges;
-extern int num_k8_northbridges;
 extern int cache_k8_northbridges(void);
 extern void k8_flush_garts(void);
 extern int k8_get_nodes(struct bootnode *nodes);
 extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
 extern int k8_scan_nodes(void);
 
+struct k8_northbridge_info {
+	u16 num;
+	u8 gart_supported;
+	struct pci_dev **nb_misc;
+};
+extern struct k8_northbridge_info k8_northbridges;
+
 #ifdef CONFIG_K8_NB
-extern int num_k8_northbridges;
 
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
-	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
+	return (node < k8_northbridges.num) ? k8_northbridges.nb_misc[node] : NULL;
 }
 
 #else
-#define num_k8_northbridges 0
 
 static inline struct pci_dev *node_to_k8_nb_misc(int node)
 {
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 2521cdc..6fdfb0b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -369,7 +369,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 			return;
 
 	/* not in virtualized environments */
-	if (num_k8_northbridges == 0)
+	if (k8_northbridges.num == 0)
 		return;
 
 	/*
@@ -377,7 +377,7 @@ static void __cpuinit amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf,
 	 * never freed but this is done only on shutdown so it doesn't matter.
 	 */
 	if (!l3_caches) {
-		int size = num_k8_northbridges * sizeof(struct amd_l3_cache *);
+		int size = k8_northbridges.num * sizeof(struct amd_l3_cache *);
 
 		l3_caches = kzalloc(size, GFP_ATOMIC);
 		if (!l3_caches)
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
index 0f7bc20..5de1b6b 100644
--- a/arch/x86/kernel/k8.c
+++ b/arch/x86/kernel/k8.c
@@ -10,9 +10,6 @@
 #include <linux/spinlock.h>
 #include <asm/k8.h>
 
-int num_k8_northbridges;
-EXPORT_SYMBOL(num_k8_northbridges);
-
 static u32 *flush_words;
 
 struct pci_device_id k8_nb_ids[] = {
@@ -22,7 +19,7 @@ struct pci_device_id k8_nb_ids[] = {
 };
 EXPORT_SYMBOL(k8_nb_ids);
 
-struct pci_dev **k8_northbridges;
+struct k8_northbridge_info k8_northbridges;
 EXPORT_SYMBOL(k8_northbridges);
 
 static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
@@ -40,36 +37,44 @@ int cache_k8_northbridges(void)
 	int i;
 	struct pci_dev *dev;
 
-	if (num_k8_northbridges)
+	if (k8_northbridges.num)
 		return 0;
 
 	dev = NULL;
 	while ((dev = next_k8_northbridge(dev)) != NULL)
-		num_k8_northbridges++;
+		k8_northbridges.num++;
+
+	/* some CPU families (e.g. family 0x11) do not support GART */
+	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10)
+		k8_northbridges.gart_supported = 1;
 
-	k8_northbridges = kmalloc((num_k8_northbridges + 1) * sizeof(void *),
-				  GFP_KERNEL);
-	if (!k8_northbridges)
+	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
+					  sizeof(void *), GFP_KERNEL);
+	if (!k8_northbridges.nb_misc)
 		return -ENOMEM;
 
-	if (!num_k8_northbridges) {
-		k8_northbridges[0] = NULL;
+	if (!k8_northbridges.num) {
+		k8_northbridges.nb_misc[0] = NULL;
 		return 0;
 	}
 
-	flush_words = kmalloc(num_k8_northbridges * sizeof(u32), GFP_KERNEL);
-	if (!flush_words) {
-		kfree(k8_northbridges);
-		return -ENOMEM;
+	if (k8_northbridges.gart_supported) {
+		flush_words = kmalloc(k8_northbridges.num * sizeof(u32),
+				      GFP_KERNEL);
+		if (!flush_words) {
+			kfree(k8_northbridges.nb_misc);
+			return -ENOMEM;
+		}
 	}
 
 	dev = NULL;
 	i = 0;
 	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges[i] = dev;
-		pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
+		k8_northbridges.nb_misc[i] = dev;
+		if (k8_northbridges.gart_supported)
+			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
 	}
-	k8_northbridges[i] = NULL;
+	k8_northbridges.nb_misc[i] = NULL;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(cache_k8_northbridges);
@@ -93,22 +98,25 @@ void k8_flush_garts(void)
 	unsigned long flags;
 	static DEFINE_SPINLOCK(gart_lock);
 
+	if (!k8_northbridges.gart_supported)
+		return;
+
 	/* Avoid races between AGP and IOMMU. In theory it's not needed
 	   but I'm not sure if the hardware won't lose flush requests
 	   when another is pending. This whole thing is so expensive anyways
 	   that it doesn't matter to serialize more. -AK */
 	spin_lock_irqsave(&gart_lock, flags);
 	flushed = 0;
-	for (i = 0; i < num_k8_northbridges; i++) {
-		pci_write_config_dword(k8_northbridges[i], 0x9c,
+	for (i = 0; i < k8_northbridges.num; i++) {
+		pci_write_config_dword(k8_northbridges.nb_misc[i], 0x9c,
 				       flush_words[i]|1);
 		flushed++;
 	}
-	for (i = 0; i < num_k8_northbridges; i++) {
+	for (i = 0; i < k8_northbridges.num; i++) {
 		u32 w;
 		/* Make sure the hardware actually executed the flush*/
 		for (;;) {
-			pci_read_config_dword(k8_northbridges[i],
+			pci_read_config_dword(k8_northbridges.nb_misc[i],
 					      0x9c, &w);
 			if (!(w & 1))
 				break;
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index a0ccf0e..aad583f 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -561,8 +561,11 @@ static void enable_gart_translations(void)
 {
 	int i;
 
-	for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 
 		enable_gart_translation(dev, __pa(agp_gatt_table));
 	}
@@ -593,10 +596,13 @@ static void gart_fixup_northbridges(struct sys_device *dev)
 	if (!fix_up_north_bridges)
 		return;
 
+	if (!k8_northbridges.gart_supported)
+		return;
+
 	pr_info("PCI-DMA: Restoring GART aperture settings\n");
 
-	for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 
 		/*
 		 * Don't enable translations just yet.  That is the next
@@ -650,8 +656,8 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
 
 	aper_size = aper_base = info->aper_size = 0;
 	dev = NULL;
-	for (i = 0; i < num_k8_northbridges; i++) {
-		dev = k8_northbridges[i];
+	for (i = 0; i < k8_northbridges.num; i++) {
+		dev = k8_northbridges.nb_misc[i];
 		new_aper_base = read_aperture(dev, &new_aper_size);
 		if (!new_aper_base)
 			goto nommu;
@@ -719,10 +725,13 @@ static void gart_iommu_shutdown(void)
 	if (!no_agp)
 		return;
 
-	for (i = 0; i < num_k8_northbridges; i++) {
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	for (i = 0; i < k8_northbridges.num; i++) {
 		u32 ctl;
 
-		dev = k8_northbridges[i];
+		dev = k8_northbridges.nb_misc[i];
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &ctl);
 
 		ctl &= ~GARTEN;
@@ -740,7 +749,7 @@ int __init gart_iommu_init(void)
 	unsigned long scratch;
 	long i;
 
-	if (num_k8_northbridges == 0)
+	if (!k8_northbridges.gart_supported)
 		return 0;
 
 #ifndef CONFIG_AGP_AMD64
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index 564808a..b7bff9d 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -124,7 +124,7 @@ static int amd64_fetch_size(void)
 	u32 temp;
 	struct aper_size_info_32 *values;
 
-	dev = k8_northbridges[0];
+	dev = k8_northbridges.nb_misc[0];
 	if (dev==NULL)
 		return 0;
 
@@ -181,10 +181,14 @@ static int amd_8151_configure(void)
 	unsigned long gatt_bus = virt_to_phys(agp_bridge->gatt_table_real);
 	int i;
 
+	if (!k8_northbridges.gart_supported)
+		return 0;
+
 	/* Configure AGP regs in each x86-64 host bridge. */
-        for (i = 0; i < num_k8_northbridges; i++) {
+	for (i = 0; i < k8_northbridges.num; i++) {
 		agp_bridge->gart_bus_addr =
-				amd64_configure(k8_northbridges[i], gatt_bus);
+				amd64_configure(k8_northbridges.nb_misc[i],
+						gatt_bus);
 	}
 	k8_flush_garts();
 	return 0;
@@ -195,8 +199,12 @@ static void amd64_cleanup(void)
 {
 	u32 tmp;
 	int i;
-        for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 		/* disable gart translation */
 		pci_read_config_dword(dev, AMD64_GARTAPERTURECTL, &tmp);
 		tmp &= ~GARTEN;
@@ -319,16 +327,19 @@ static __devinit int fix_northbridge(struct pci_dev *nb, struct pci_dev *agp,
 	return 0;
 }
 
-static __devinit int cache_nbs (struct pci_dev *pdev, u32 cap_ptr)
+static __devinit int cache_nbs(struct pci_dev *pdev, u32 cap_ptr)
 {
 	int i;
 
 	if (cache_k8_northbridges() < 0)
 		return -ENODEV;
 
+	if (!k8_northbridges.gart_supported)
+		return -ENODEV;
+
 	i = 0;
-	for (i = 0; i < num_k8_northbridges; i++) {
-		struct pci_dev *dev = k8_northbridges[i];
+	for (i = 0; i < k8_northbridges.num; i++) {
+		struct pci_dev *dev = k8_northbridges.nb_misc[i];
 		if (fix_northbridge(dev, pdev, cap_ptr) < 0) {
 			dev_err(&dev->dev, "no usable aperture found\n");
 #ifdef __x86_64__
@@ -405,7 +416,8 @@ static int __devinit uli_agp_init(struct pci_dev *pdev)
 	}
 
 	/* shadow x86-64 registers into ULi registers */
-	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &httfea);
+	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+			       &httfea);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ((httfea & 0x7fff) >> (32 - 25)) {
@@ -472,7 +484,8 @@ static int nforce3_agp_init(struct pci_dev *pdev)
 	pci_write_config_dword(dev1, NVIDIA_X86_64_1_APSIZE, tmp);
 
 	/* shadow x86-64 registers into NVIDIA registers */
-	pci_read_config_dword (k8_northbridges[0], AMD64_GARTAPERTUREBASE, &apbase);
+	pci_read_config_dword (k8_northbridges.nb_misc[0], AMD64_GARTAPERTUREBASE,
+			       &apbase);
 
 	/* if x86-64 aperture base is beyond 4G, exit here */
 	if ( (apbase & 0x7fff) >> (32 - 25) ) {
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e7d5d6b..5babf6f 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2927,7 +2927,7 @@ static int __init amd64_edac_init(void)
 	 * to finish initialization of the MC instances.
 	 */
 	err = -ENODEV;
-	for (nb = 0; nb < num_k8_northbridges; nb++) {
+	for (nb = 0; nb < k8_northbridges.num; nb++) {
 		if (!pvt_lookup[nb])
 			continue;
 
-- 
1.6.4.4

