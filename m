Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab0IHNIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:08:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40952 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab0IHNIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:08:43 -0400
Date: Wed, 8 Sep 2010 15:08:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100908130834.GA7592@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/linux/io-mapping.h         # 29bc17e: io-mapping: Fix the address space

 Thanks,

	Ingo

------------------>
Andreas Herrmann (1):
      x86, mcheck: Avoid duplicate sysfs links/files for thresholding banks

Francisco Jerez (2):
      x86: Fix the address space annotations of iomap_atomic_prot_pfn()
      io-mapping: Fix the address space annotations

Hugh Dickins (1):
      x86, mm: Fix CONFIG_VMSPLIT_1G and 2G_OPT trampoline

Sergey Senozhatsky (1):
      x86, hwmon: Fix unsafe smp_processor_id() in thermal_throttle_add_dev


 arch/x86/include/asm/iomap.h             |    4 ++--
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |    4 ++--
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    9 +++++----
 arch/x86/kernel/trampoline.c             |    3 +--
 arch/x86/mm/iomap_32.c                   |    6 +++---
 include/linux/io-mapping.h               |   24 ++++++++++++------------
 6 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/iomap.h b/arch/x86/include/asm/iomap.h
index f35eb45..c4191b3 100644
--- a/arch/x86/include/asm/iomap.h
+++ b/arch/x86/include/asm/iomap.h
@@ -26,11 +26,11 @@
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 
-void *
+void __iomem *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 
 void
-iounmap_atomic(void *kvaddr, enum km_type type);
+iounmap_atomic(void __iomem *kvaddr, enum km_type type);
 
 int
 iomap_create_wc(resource_size_t base, unsigned long size, pgprot_t *prot);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
index 224392d..5e97529 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd.c
@@ -530,7 +530,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 		err = -ENOMEM;
 		goto out;
 	}
-	if (!alloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
+	if (!zalloc_cpumask_var(&b->cpus, GFP_KERNEL)) {
 		kfree(b);
 		err = -ENOMEM;
 		goto out;
@@ -543,7 +543,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 #ifndef CONFIG_SMP
 	cpumask_setall(b->cpus);
 #else
-	cpumask_copy(b->cpus, c->llc_shared_map);
+	cpumask_set_cpu(cpu, b->cpus);
 #endif
 
 	per_cpu(threshold_banks, cpu)[bank] = b;
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index c2a8b26..d9368ee 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -202,10 +202,11 @@ static int therm_throt_process(bool new_event, int event, int level)
 
 #ifdef CONFIG_SYSFS
 /* Add/Remove thermal_throttle interface for CPU device: */
-static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev)
+static __cpuinit int thermal_throttle_add_dev(struct sys_device *sys_dev,
+				unsigned int cpu)
 {
 	int err;
-	struct cpuinfo_x86 *c = &cpu_data(smp_processor_id());
+	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	err = sysfs_create_group(&sys_dev->kobj, &thermal_attr_group);
 	if (err)
@@ -251,7 +252,7 @@ thermal_throttle_cpu_callback(struct notifier_block *nfb,
 	case CPU_UP_PREPARE:
 	case CPU_UP_PREPARE_FROZEN:
 		mutex_lock(&therm_cpu_lock);
-		err = thermal_throttle_add_dev(sys_dev);
+		err = thermal_throttle_add_dev(sys_dev, cpu);
 		mutex_unlock(&therm_cpu_lock);
 		WARN_ON(err);
 		break;
@@ -287,7 +288,7 @@ static __init int thermal_throttle_init_device(void)
 #endif
 	/* connect live CPUs to sysfs */
 	for_each_online_cpu(cpu) {
-		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu));
+		err = thermal_throttle_add_dev(get_cpu_sysdev(cpu), cpu);
 		WARN_ON(err);
 	}
 #ifdef CONFIG_HOTPLUG_CPU
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a874495..e2a5952 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -45,8 +45,7 @@ void __init setup_trampoline_page_table(void)
 	/* Copy kernel address range */
 	clone_pgd_range(trampoline_pg_dir + KERNEL_PGD_BOUNDARY,
 			swapper_pg_dir + KERNEL_PGD_BOUNDARY,
-			min_t(unsigned long, KERNEL_PGD_PTRS,
-			      KERNEL_PGD_BOUNDARY));
+			KERNEL_PGD_PTRS);
 
 	/* Initialize low mappings */
 	clone_pgd_range(trampoline_pg_dir,
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index 84e236c..72fc70c 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -74,7 +74,7 @@ void *kmap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 /*
  * Map 'pfn' using fixed map 'type' and protections 'prot'
  */
-void *
+void __iomem *
 iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 {
 	/*
@@ -86,12 +86,12 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
 		prot = PAGE_KERNEL_UC_MINUS;
 
-	return kmap_atomic_prot_pfn(pfn, type, prot);
+	return (void __force __iomem *) kmap_atomic_prot_pfn(pfn, type, prot);
 }
 EXPORT_SYMBOL_GPL(iomap_atomic_prot_pfn);
 
 void
-iounmap_atomic(void *kvaddr, enum km_type type)
+iounmap_atomic(void __iomem *kvaddr, enum km_type type)
 {
 	unsigned long vaddr = (unsigned long) kvaddr & PAGE_MASK;
 	enum fixed_addresses idx = type + KM_TYPE_NR*smp_processor_id();
diff --git a/include/linux/io-mapping.h b/include/linux/io-mapping.h
index 0a6b3d5..7fb5927 100644
--- a/include/linux/io-mapping.h
+++ b/include/linux/io-mapping.h
@@ -79,7 +79,7 @@ io_mapping_free(struct io_mapping *mapping)
 }
 
 /* Atomic map/unmap */
-static inline void *
+static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset,
 			 int slot)
@@ -94,12 +94,12 @@ io_mapping_map_atomic_wc(struct io_mapping *mapping,
 }
 
 static inline void
-io_mapping_unmap_atomic(void *vaddr, int slot)
+io_mapping_unmap_atomic(void __iomem *vaddr, int slot)
 {
 	iounmap_atomic(vaddr, slot);
 }
 
-static inline void *
+static inline void __iomem *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
 	resource_size_t phys_addr;
@@ -111,7 +111,7 @@ io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 }
 
 static inline void
-io_mapping_unmap(void *vaddr)
+io_mapping_unmap(void __iomem *vaddr)
 {
 	iounmap(vaddr);
 }
@@ -125,38 +125,38 @@ struct io_mapping;
 static inline struct io_mapping *
 io_mapping_create_wc(resource_size_t base, unsigned long size)
 {
-	return (struct io_mapping *) ioremap_wc(base, size);
+	return (struct io_mapping __force *) ioremap_wc(base, size);
 }
 
 static inline void
 io_mapping_free(struct io_mapping *mapping)
 {
-	iounmap(mapping);
+	iounmap((void __force __iomem *) mapping);
 }
 
 /* Atomic map/unmap */
-static inline void *
+static inline void __iomem *
 io_mapping_map_atomic_wc(struct io_mapping *mapping,
 			 unsigned long offset,
 			 int slot)
 {
-	return ((char *) mapping) + offset;
+	return ((char __force __iomem *) mapping) + offset;
 }
 
 static inline void
-io_mapping_unmap_atomic(void *vaddr, int slot)
+io_mapping_unmap_atomic(void __iomem *vaddr, int slot)
 {
 }
 
 /* Non-atomic map/unmap */
-static inline void *
+static inline void __iomem *
 io_mapping_map_wc(struct io_mapping *mapping, unsigned long offset)
 {
-	return ((char *) mapping) + offset;
+	return ((char __force __iomem *) mapping) + offset;
 }
 
 static inline void
-io_mapping_unmap(void *vaddr)
+io_mapping_unmap(void __iomem *vaddr)
 {
 }
 
