Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab0FBLtp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 07:49:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39132 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677Ab0FBLtn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 07:49:43 -0400
Date: Wed, 2 Jun 2010 13:49:32 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20100602114932.GA4884@elte.hu>
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

 Thanks,

	Ingo

------------------>
Akinobu Mita (1):
      x86/mm: Remove unused DBG() macro

Borislav Petkov (1):
      x86, smpboot: Fix cores per node printing on boot

Joerg Roedel (2):
      x86/amd-iommu: Fix crash when request_mem_region fails
      x86/amd-iommu: Fall back to GART if initialization fails

Julia Lawall (1):
      arch/x86/kernel: Add missing spin_unlock


 arch/x86/kernel/amd_iommu.c      |   16 +++++++++-------
 arch/x86/kernel/amd_iommu_init.c |   20 +++++++++++++++++---
 arch/x86/kernel/setup_percpu.c   |    6 ------
 arch/x86/kernel/smpboot.c        |    2 +-
 arch/x86/mm/numa.c               |    6 ------
 5 files changed, 27 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index fa5a147..0d20286 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1487,6 +1487,7 @@ static int __attach_device(struct device *dev,
 			   struct protection_domain *domain)
 {
 	struct iommu_dev_data *dev_data, *alias_data;
+	int ret;
 
 	dev_data   = get_dev_data(dev);
 	alias_data = get_dev_data(dev_data->alias);
@@ -1498,13 +1499,14 @@ static int __attach_device(struct device *dev,
 	spin_lock(&domain->lock);
 
 	/* Some sanity checks */
+	ret = -EBUSY;
 	if (alias_data->domain != NULL &&
 	    alias_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	if (dev_data->domain != NULL &&
 	    dev_data->domain != domain)
-		return -EBUSY;
+		goto out_unlock;
 
 	/* Do real assignment */
 	if (dev_data->alias != dev) {
@@ -1520,10 +1522,14 @@ static int __attach_device(struct device *dev,
 
 	atomic_inc(&dev_data->bind);
 
+	ret = 0;
+
+out_unlock:
+
 	/* ready */
 	spin_unlock(&domain->lock);
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -2324,10 +2330,6 @@ int __init amd_iommu_init_dma_ops(void)
 
 	iommu_detected = 1;
 	swiotlb = 0;
-#ifdef CONFIG_GART_IOMMU
-	gart_iommu_aperture_disabled = 1;
-	gart_iommu_aperture = 0;
-#endif
 
 	/* Make the driver finally visible to the drivers */
 	dma_ops = &amd_iommu_dma_ops;
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 3bacb4d..3cc63e2 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -287,8 +287,12 @@ static u8 * __init iommu_map_mmio_space(u64 address)
 {
 	u8 *ret;
 
-	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu"))
+	if (!request_mem_region(address, MMIO_REGION_LENGTH, "amd_iommu")) {
+		pr_err("AMD-Vi: Can not reserve memory region %llx for mmio\n",
+			address);
+		pr_err("AMD-Vi: This is a BIOS bug. Please contact your hardware vendor\n");
 		return NULL;
+	}
 
 	ret = ioremap_nocache(address, MMIO_REGION_LENGTH);
 	if (ret != NULL)
@@ -1314,7 +1318,7 @@ static int __init amd_iommu_init(void)
 		ret = amd_iommu_init_dma_ops();
 
 	if (ret)
-		goto free;
+		goto free_disable;
 
 	amd_iommu_init_api();
 
@@ -1332,9 +1336,10 @@ static int __init amd_iommu_init(void)
 out:
 	return ret;
 
-free:
+free_disable:
 	disable_iommus();
 
+free:
 	amd_iommu_uninit_devices();
 
 	free_pages((unsigned long)amd_iommu_pd_alloc_bitmap,
@@ -1353,6 +1358,15 @@ free:
 
 	free_unity_maps();
 
+#ifdef CONFIG_GART_IOMMU
+	/*
+	 * We failed to initialize the AMD IOMMU - try fallback to GART
+	 * if possible.
+	 */
+	gart_iommu_init();
+
+#endif
+
 	goto out;
 }
 
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index a867940..401ff10 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -21,12 +21,6 @@
 #include <asm/cpu.h>
 #include <asm/stackprotector.h>
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(fmt, ...) pr_dbg(fmt, ##__VA_ARGS__)
-#else
-# define DBG(fmt, ...) do { if (0) pr_dbg(fmt, ##__VA_ARGS__); } while (0)
-#endif
-
 DEFINE_PER_CPU(int, cpu_number);
 EXPORT_PER_CPU_SYMBOL(cpu_number);
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 37462f1..c4f33b2 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -686,7 +686,7 @@ static void __cpuinit do_fork_idle(struct work_struct *work)
 static void __cpuinit announce_cpu(int cpu, int apicid)
 {
 	static int current_node = -1;
-	int node = cpu_to_node(cpu);
+	int node = early_cpu_to_node(cpu);
 
 	if (system_state == SYSTEM_BOOTING) {
 		if (node != current_node) {
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 550df48..787c52c 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -3,12 +3,6 @@
 #include <linux/module.h>
 #include <linux/bootmem.h>
 
-#ifdef CONFIG_DEBUG_PER_CPU_MAPS
-# define DBG(x...) printk(KERN_DEBUG x)
-#else
-# define DBG(x...)
-#endif
-
 /*
  * Which logical CPUs are on which nodes
  */
