Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab1DLRXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 13:23:13 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60643 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1DLRXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 13:23:11 -0400
Message-ID: <4DA489F0.4000003@kernel.org>
Date: Tue, 12 Apr 2011 10:20:48 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: [PATCH -v2] x86: Remove dma32_reserve_bootmem
References: <4D90CBE5.6090706@kernel.org> <20110412091145.2bc5e6a9@jbarnes-desktop>
In-Reply-To: <20110412091145.2bc5e6a9@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4DA48A6D.00ED,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


That is workaround for holding dma32 buf when early bootmem could use up
those range on system that have lots of RAM.

Now x86 is using memblock, and even nobootmem wrapper do top-down allocation.

So We could remove those not needed code now.

-v2: rebase on pci-next

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
  arch/x86/include/asm/pci.h |    2 -
  arch/x86/kernel/pci-dma.c  |   64 ---------------------------------------------
  arch/x86/kernel/setup.c    |    1
  3 files changed, 67 deletions(-)

Index: linux-2.6/arch/x86/include/asm/pci.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/pci.h
+++ linux-2.6/arch/x86/include/asm/pci.h
@@ -135,8 +135,6 @@ void default_teardown_msi_irqs(struct pc
  #include "pci_64.h"
  #endif
  
-void dma32_reserve_bootmem(void);
-
  /* implement the pci_ DMA API in terms of the generic device dma_ one */
  #include <asm-generic/pci-dma-compat.h>
  
Index: linux-2.6/arch/x86/kernel/pci-dma.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/pci-dma.c
+++ linux-2.6/arch/x86/kernel/pci-dma.c
@@ -68,74 +68,10 @@ int dma_set_mask(struct device *dev, u64
  }
  EXPORT_SYMBOL(dma_set_mask);
  
-#if defined(CONFIG_X86_64) && !defined(CONFIG_NUMA)
-static __initdata void *dma32_bootmem_ptr;
-static unsigned long dma32_bootmem_size __initdata = (128ULL<<20);
-
-static int __init parse_dma32_size_opt(char *p)
-{
-	if (!p)
-		return -EINVAL;
-	dma32_bootmem_size = memparse(p, &p);
-	return 0;
-}
-early_param("dma32_size", parse_dma32_size_opt);
-
-void __init dma32_reserve_bootmem(void)
-{
-	unsigned long size, align;
-	if (max_pfn <= MAX_DMA32_PFN)
-		return;
-
-	/*
-	 * check aperture_64.c allocate_aperture() for reason about
-	 * using 512M as goal
-	 */
-	align = 64ULL<<20;
-	size = roundup(dma32_bootmem_size, align);
-	dma32_bootmem_ptr = __alloc_bootmem_nopanic(size, align,
-				 512ULL<<20);
-	/*
-	 * Kmemleak should not scan this block as it may not be mapped via the
-	 * kernel direct mapping.
-	 */
-	kmemleak_ignore(dma32_bootmem_ptr);
-	if (dma32_bootmem_ptr)
-		dma32_bootmem_size = size;
-	else
-		dma32_bootmem_size = 0;
-}
-static void __init dma32_free_bootmem(void)
-{
-
-	if (max_pfn <= MAX_DMA32_PFN)
-		return;
-
-	if (!dma32_bootmem_ptr)
-		return;
-
-	free_bootmem(__pa(dma32_bootmem_ptr), dma32_bootmem_size);
-
-	dma32_bootmem_ptr = NULL;
-	dma32_bootmem_size = 0;
-}
-#else
-void __init dma32_reserve_bootmem(void)
-{
-}
-static void __init dma32_free_bootmem(void)
-{
-}
-
-#endif
-
  void __init pci_iommu_alloc(void)
  {
  	struct iommu_table_entry *p;
  
-	/* free the range so iommu could get some range less than 4G */
-	dma32_free_bootmem();
-
  	sort_iommu_table(__iommu_table, __iommu_table_end);
  	check_iommu_entries(__iommu_table, __iommu_table_end);
  
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -966,7 +966,6 @@ void __init setup_arch(char **cmdline_p)
  
  	initmem_init();
  	memblock_find_dma_reserve();
-	dma32_reserve_bootmem();
  
  #ifdef CONFIG_KVM_CLOCK
  	kvmclock_init();
