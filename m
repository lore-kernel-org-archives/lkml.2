Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0IQPh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 11:37:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:54040 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753874Ab0IQPh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 11:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=khweEJWaK9BeuxcZJqLQ+aKGBJ7x853m41PjArC+loGc2WKYVC3ajd1M/nRyuSNw34
         GWS7PK8aMuxxy4oOcpvqyo4QMzMQVzTaf/xlYSLDkFxxPgB3IBkzIGbMsxFIwrIXze9m
         U1KQJdrXgjES0KUUV4VEvIhrpavFHXild0yPk=
Date: Fri, 17 Sep 2010 18:03:43 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <borislav.petkov@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>
Subject: [PATCH 3/3] x86, k8: Rename k8.[ch] to amd_nb.[ch] and
 CONFIG_K8_NB to CONFIG_AMD_NB
Message-ID: <20100917160343.GD4958@loge.amd.com>
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

The file names are somehow misleading as the code is not specific to
AMD K8 CPUs anymore. The files accomodate code for other AMD CPU
northbridges as well.

Same is true for the config option which is valid for AMD CPU
northbridges in general and not specific to K8.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/Kconfig                      |    4 +-
 arch/x86/include/asm/amd_nb.h         |   39 +++++++++
 arch/x86/include/asm/k8.h             |   39 ---------
 arch/x86/kernel/Makefile              |    2 +-
 arch/x86/kernel/amd_nb.c              |  145 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/aperture_64.c         |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |   10 +-
 arch/x86/kernel/k8.c                  |  145 ---------------------------------
 arch/x86/kernel/pci-gart_64.c         |    2 +-
 arch/x86/kernel/setup.c               |    2 +-
 arch/x86/mm/k8topology_64.c           |    2 +-
 arch/x86/mm/numa_64.c                 |    2 +-
 drivers/char/agp/Kconfig              |    2 +-
 drivers/char/agp/amd64-agp.c          |    2 +-
 drivers/edac/Kconfig                  |    2 +-
 drivers/edac/amd64_edac.c             |    2 +-
 16 files changed, 201 insertions(+), 201 deletions(-)
 create mode 100644 arch/x86/include/asm/amd_nb.h
 delete mode 100644 arch/x86/include/asm/k8.h
 create mode 100644 arch/x86/kernel/amd_nb.c
 delete mode 100644 arch/x86/kernel/k8.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0c14369..308b9fb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -640,7 +640,7 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	depends on X86_64 && PCI && K8_NB
+	depends on X86_64 && PCI && AMD_NB
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -2055,7 +2055,7 @@ config OLPC_OPENFIRMWARE
 
 endif # X86_32
 
-config K8_NB
+config AMD_NB
 	def_bool y
 	depends on CPU_SUP_AMD && PCI
 
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
new file mode 100644
index 0000000..c8517f8
--- /dev/null
+++ b/arch/x86/include/asm/amd_nb.h
@@ -0,0 +1,39 @@
+#ifndef _ASM_X86_AMD_NB_H
+#define _ASM_X86_AMD_NB_H
+
+#include <linux/pci.h>
+
+extern struct pci_device_id k8_nb_ids[];
+struct bootnode;
+
+extern int early_is_k8_nb(u32 value);
+extern int cache_k8_northbridges(void);
+extern void k8_flush_garts(void);
+extern int k8_get_nodes(struct bootnode *nodes);
+extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
+extern int k8_scan_nodes(void);
+
+struct k8_northbridge_info {
+	u16 num;
+	u8 gart_supported;
+	struct pci_dev **nb_misc;
+};
+extern struct k8_northbridge_info k8_northbridges;
+
+#ifdef CONFIG_AMD_NB
+
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return (node < k8_northbridges.num) ? k8_northbridges.nb_misc[node] : NULL;
+}
+
+#else
+
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return NULL;
+}
+#endif
+
+
+#endif /* _ASM_X86_AMD_NB_H */
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
deleted file mode 100644
index 9cee145..0000000
--- a/arch/x86/include/asm/k8.h
+++ /dev/null
@@ -1,39 +0,0 @@
-#ifndef _ASM_X86_K8_H
-#define _ASM_X86_K8_H
-
-#include <linux/pci.h>
-
-extern struct pci_device_id k8_nb_ids[];
-struct bootnode;
-
-extern int early_is_k8_nb(u32 value);
-extern int cache_k8_northbridges(void);
-extern void k8_flush_garts(void);
-extern int k8_get_nodes(struct bootnode *nodes);
-extern int k8_numa_init(unsigned long start_pfn, unsigned long end_pfn);
-extern int k8_scan_nodes(void);
-
-struct k8_northbridge_info {
-	u16 num;
-	u8 gart_supported;
-	struct pci_dev **nb_misc;
-};
-extern struct k8_northbridge_info k8_northbridges;
-
-#ifdef CONFIG_K8_NB
-
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
-{
-	return (node < k8_northbridges.num) ? k8_northbridges.nb_misc[node] : NULL;
-}
-
-#else
-
-static inline struct pci_dev *node_to_k8_nb_misc(int node)
-{
-	return NULL;
-}
-#endif
-
-
-#endif /* _ASM_X86_K8_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 11a9925..ec7882e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -88,7 +88,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
-obj-$(CONFIG_K8_NB)		+= k8.o
+obj-$(CONFIG_AMD_NB)		+= amd_nb.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
new file mode 100644
index 0000000..4ffc38d
--- /dev/null
+++ b/arch/x86/kernel/amd_nb.c
@@ -0,0 +1,145 @@
+/*
+ * Shared support code for AMD K8 northbridges and derivates.
+ * Copyright 2006 Andi Kleen, SUSE Labs. Subject to GPLv2.
+ */
+#include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <asm/amd_nb.h>
+
+static u32 *flush_words;
+
+struct pci_device_id k8_nb_ids[] = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{}
+};
+EXPORT_SYMBOL(k8_nb_ids);
+
+struct k8_northbridge_info k8_northbridges;
+EXPORT_SYMBOL(k8_northbridges);
+
+static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
+{
+	do {
+		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
+		if (!dev)
+			break;
+	} while (!pci_match_id(&k8_nb_ids[0], dev));
+	return dev;
+}
+
+int cache_k8_northbridges(void)
+{
+	int i;
+	struct pci_dev *dev;
+
+	if (k8_northbridges.num)
+		return 0;
+
+	dev = NULL;
+	while ((dev = next_k8_northbridge(dev)) != NULL)
+		k8_northbridges.num++;
+
+	/* some CPU families (e.g. family 0x11) do not support GART */
+	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10)
+		k8_northbridges.gart_supported = 1;
+
+	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
+					  sizeof(void *), GFP_KERNEL);
+	if (!k8_northbridges.nb_misc)
+		return -ENOMEM;
+
+	if (!k8_northbridges.num) {
+		k8_northbridges.nb_misc[0] = NULL;
+		return 0;
+	}
+
+	if (k8_northbridges.gart_supported) {
+		flush_words = kmalloc(k8_northbridges.num * sizeof(u32),
+				      GFP_KERNEL);
+		if (!flush_words) {
+			kfree(k8_northbridges.nb_misc);
+			return -ENOMEM;
+		}
+	}
+
+	dev = NULL;
+	i = 0;
+	while ((dev = next_k8_northbridge(dev)) != NULL) {
+		k8_northbridges.nb_misc[i] = dev;
+		if (k8_northbridges.gart_supported)
+			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
+	}
+	k8_northbridges.nb_misc[i] = NULL;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cache_k8_northbridges);
+
+/* Ignores subdevice/subvendor but as far as I can figure out
+   they're useless anyways */
+int __init early_is_k8_nb(u32 device)
+{
+	struct pci_device_id *id;
+	u32 vendor = device & 0xffff;
+	device >>= 16;
+	for (id = k8_nb_ids; id->vendor; id++)
+		if (vendor == id->vendor && device == id->device)
+			return 1;
+	return 0;
+}
+
+void k8_flush_garts(void)
+{
+	int flushed, i;
+	unsigned long flags;
+	static DEFINE_SPINLOCK(gart_lock);
+
+	if (!k8_northbridges.gart_supported)
+		return;
+
+	/* Avoid races between AGP and IOMMU. In theory it's not needed
+	   but I'm not sure if the hardware won't lose flush requests
+	   when another is pending. This whole thing is so expensive anyways
+	   that it doesn't matter to serialize more. -AK */
+	spin_lock_irqsave(&gart_lock, flags);
+	flushed = 0;
+	for (i = 0; i < k8_northbridges.num; i++) {
+		pci_write_config_dword(k8_northbridges.nb_misc[i], 0x9c,
+				       flush_words[i]|1);
+		flushed++;
+	}
+	for (i = 0; i < k8_northbridges.num; i++) {
+		u32 w;
+		/* Make sure the hardware actually executed the flush*/
+		for (;;) {
+			pci_read_config_dword(k8_northbridges.nb_misc[i],
+					      0x9c, &w);
+			if (!(w & 1))
+				break;
+			cpu_relax();
+		}
+	}
+	spin_unlock_irqrestore(&gart_lock, flags);
+	if (!flushed)
+		printk("nothing to flush?\n");
+}
+EXPORT_SYMBOL_GPL(k8_flush_garts);
+
+static __init int init_k8_nbs(void)
+{
+	int err = 0;
+
+	err = cache_k8_northbridges();
+
+	if (err < 0)
+		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
+
+	return err;
+}
+
+/* This has to go after the PCI subsystem */
+fs_initcall(init_k8_nbs);
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index 18dfa68..b3a16e8 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -27,7 +27,7 @@
 #include <asm/gart.h>
 #include <asm/pci-direct.h>
 #include <asm/dma.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/x86_init.h>
 
 int gart_iommu_aperture;
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 6fdfb0b..12cd823 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -17,7 +17,7 @@
 
 #include <asm/processor.h>
 #include <linux/smp.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/smp.h>
 
 #define LVL_1_INST	1
@@ -306,7 +306,7 @@ struct _cache_attr {
 	ssize_t (*store)(struct _cpuid4_info *, const char *, size_t count);
 };
 
-#ifdef CONFIG_K8_NB
+#ifdef CONFIG_AMD_NB
 
 /*
  * L3 cache descriptors
@@ -556,12 +556,12 @@ static struct _cache_attr cache_disable_0 = __ATTR(cache_disable_0, 0644,
 static struct _cache_attr cache_disable_1 = __ATTR(cache_disable_1, 0644,
 		show_cache_disable_1, store_cache_disable_1);
 
-#else	/* CONFIG_K8_NB */
+#else	/* CONFIG_AMD_NB */
 static void __cpuinit
 amd_check_l3_disable(struct _cpuid4_info_regs *this_leaf, int index)
 {
 };
-#endif /* CONFIG_K8_NB */
+#endif /* CONFIG_AMD_NB */
 
 static int
 __cpuinit cpuid4_cache_lookup_regs(int index,
@@ -1000,7 +1000,7 @@ static struct attribute *default_attrs[] = {
 
 static struct attribute *default_l3_attrs[] = {
 	DEFAULT_SYSFS_CACHE_ATTRS,
-#ifdef CONFIG_K8_NB
+#ifdef CONFIG_AMD_NB
 	&cache_disable_0.attr,
 	&cache_disable_1.attr,
 #endif
diff --git a/arch/x86/kernel/k8.c b/arch/x86/kernel/k8.c
deleted file mode 100644
index 5de1b6b..0000000
--- a/arch/x86/kernel/k8.c
+++ /dev/null
@@ -1,145 +0,0 @@
-/*
- * Shared support code for AMD K8 northbridges and derivates.
- * Copyright 2006 Andi Kleen, SUSE Labs. Subject to GPLv2.
- */
-#include <linux/types.h>
-#include <linux/slab.h>
-#include <linux/init.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <asm/k8.h>
-
-static u32 *flush_words;
-
-struct pci_device_id k8_nb_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
-	{}
-};
-EXPORT_SYMBOL(k8_nb_ids);
-
-struct k8_northbridge_info k8_northbridges;
-EXPORT_SYMBOL(k8_northbridges);
-
-static struct pci_dev *next_k8_northbridge(struct pci_dev *dev)
-{
-	do {
-		dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev);
-		if (!dev)
-			break;
-	} while (!pci_match_id(&k8_nb_ids[0], dev));
-	return dev;
-}
-
-int cache_k8_northbridges(void)
-{
-	int i;
-	struct pci_dev *dev;
-
-	if (k8_northbridges.num)
-		return 0;
-
-	dev = NULL;
-	while ((dev = next_k8_northbridge(dev)) != NULL)
-		k8_northbridges.num++;
-
-	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10)
-		k8_northbridges.gart_supported = 1;
-
-	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
-					  sizeof(void *), GFP_KERNEL);
-	if (!k8_northbridges.nb_misc)
-		return -ENOMEM;
-
-	if (!k8_northbridges.num) {
-		k8_northbridges.nb_misc[0] = NULL;
-		return 0;
-	}
-
-	if (k8_northbridges.gart_supported) {
-		flush_words = kmalloc(k8_northbridges.num * sizeof(u32),
-				      GFP_KERNEL);
-		if (!flush_words) {
-			kfree(k8_northbridges.nb_misc);
-			return -ENOMEM;
-		}
-	}
-
-	dev = NULL;
-	i = 0;
-	while ((dev = next_k8_northbridge(dev)) != NULL) {
-		k8_northbridges.nb_misc[i] = dev;
-		if (k8_northbridges.gart_supported)
-			pci_read_config_dword(dev, 0x9c, &flush_words[i++]);
-	}
-	k8_northbridges.nb_misc[i] = NULL;
-	return 0;
-}
-EXPORT_SYMBOL_GPL(cache_k8_northbridges);
-
-/* Ignores subdevice/subvendor but as far as I can figure out
-   they're useless anyways */
-int __init early_is_k8_nb(u32 device)
-{
-	struct pci_device_id *id;
-	u32 vendor = device & 0xffff;
-	device >>= 16;
-	for (id = k8_nb_ids; id->vendor; id++)
-		if (vendor == id->vendor && device == id->device)
-			return 1;
-	return 0;
-}
-
-void k8_flush_garts(void)
-{
-	int flushed, i;
-	unsigned long flags;
-	static DEFINE_SPINLOCK(gart_lock);
-
-	if (!k8_northbridges.gart_supported)
-		return;
-
-	/* Avoid races between AGP and IOMMU. In theory it's not needed
-	   but I'm not sure if the hardware won't lose flush requests
-	   when another is pending. This whole thing is so expensive anyways
-	   that it doesn't matter to serialize more. -AK */
-	spin_lock_irqsave(&gart_lock, flags);
-	flushed = 0;
-	for (i = 0; i < k8_northbridges.num; i++) {
-		pci_write_config_dword(k8_northbridges.nb_misc[i], 0x9c,
-				       flush_words[i]|1);
-		flushed++;
-	}
-	for (i = 0; i < k8_northbridges.num; i++) {
-		u32 w;
-		/* Make sure the hardware actually executed the flush*/
-		for (;;) {
-			pci_read_config_dword(k8_northbridges.nb_misc[i],
-					      0x9c, &w);
-			if (!(w & 1))
-				break;
-			cpu_relax();
-		}
-	}
-	spin_unlock_irqrestore(&gart_lock, flags);
-	if (!flushed)
-		printk("nothing to flush?\n");
-}
-EXPORT_SYMBOL_GPL(k8_flush_garts);
-
-static __init int init_k8_nbs(void)
-{
-	int err = 0;
-
-	err = cache_k8_northbridges();
-
-	if (err < 0)
-		printk(KERN_NOTICE "K8 NB: Cannot enumerate AMD northbridges.\n");
-
-	return err;
-}
-
-/* This has to go after the PCI subsystem */
-fs_initcall(init_k8_nbs);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index aad583f..ba0f0ca 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -39,7 +39,7 @@
 #include <asm/cacheflush.h>
 #include <asm/swiotlb.h>
 #include <asm/dma.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/x86_init.h>
 #include <asm/iommu_table.h>
 
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 1427c36..85b02b6 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -107,7 +107,7 @@
 #include <asm/percpu.h>
 #include <asm/topology.h>
 #include <asm/apicdef.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #ifdef CONFIG_X86_64
 #include <asm/numa_64.h>
 #endif
diff --git a/arch/x86/mm/k8topology_64.c b/arch/x86/mm/k8topology_64.c
index 5ecf03c..804a3b6 100644
--- a/arch/x86/mm/k8topology_64.c
+++ b/arch/x86/mm/k8topology_64.c
@@ -24,7 +24,7 @@
 #include <asm/numa.h>
 #include <asm/mpspec.h>
 #include <asm/apic.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 
 static struct bootnode __initdata nodes[8];
 static nodemask_t __initdata nodes_parsed = NODE_MASK_NONE;
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index aef0ff7..60f4985 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -19,7 +19,7 @@
 #include <asm/dma.h>
 #include <asm/numa.h>
 #include <asm/acpi.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 4b66c69..5ddf67e 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -57,7 +57,7 @@ config AGP_AMD
 
 config AGP_AMD64
 	tristate "AMD Opteron/Athlon64 on-CPU GART support"
-	depends on AGP && X86 && K8_NB
+	depends on AGP && X86 && AMD_NB
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
diff --git a/drivers/char/agp/amd64-agp.c b/drivers/char/agp/amd64-agp.c
index b7bff9d..42396df 100644
--- a/drivers/char/agp/amd64-agp.c
+++ b/drivers/char/agp/amd64-agp.c
@@ -15,7 +15,7 @@
 #include <linux/mmzone.h>
 #include <asm/page.h>		/* PAGE_SIZE */
 #include <asm/e820.h>
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 #include <asm/gart.h>
 #include "agp.h"
 
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 70bb350..734e2e0 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -66,7 +66,7 @@ config EDAC_MCE
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && EDAC_DECODE_MCE
+	depends on EDAC_MM_EDAC && AMD_NB && X86_64 && PCI && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction on the AMD 64
 	  Families of Memory Controllers (K8, F10h and F11h)
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 5babf6f..09fcc52 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1,5 +1,5 @@
 #include "amd64_edac.h"
-#include <asm/k8.h>
+#include <asm/amd_nb.h>
 
 static struct edac_pci_ctl_info *amd64_ctl_pci;
 
-- 
1.6.4.4

