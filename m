Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0EQV0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 17:26:41 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747Ab0EQV0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 17:26:39 -0400
Date: Mon, 17 May 2010 23:25:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Avi Kivity <avi@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/iommu changes for v2.6.35
Message-ID: <20100517212549.GA23860@elte.hu>
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

Please pull the latest core-iommu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-iommu-for-linus

 Thanks,

	Ingo

------------------>
Joerg Roedel (11):
      iommu-api: Rename ->{un}map function pointers to ->{un}map_range
      iommu-api: Add iommu_map and iommu_unmap functions
      iommu-api: Add ->{un}map callbacks to iommu_ops
      VT-d: Change {un}map_range functions to implement {un}map interface
      kvm: Change kvm_iommu_map_pages to map large pages
      x86/amd-iommu: Make iommu_map_page and alloc_pte aware of page sizes
      x86/amd-iommu: Make iommu_unmap_page and fetch_pte aware of page sizes
      x86/amd-iommu: Make amd_iommu_iova_to_phys aware of multiple page sizes
      x86/amd-iommu: Implement ->{un}map callbacks for iommu-api
      iommu-api: Remove iommu_{un}map_range functions
      x86/amd-iommu: Add amd_iommu=off command line option


 Documentation/kernel-parameters.txt    |    2 +
 arch/x86/include/asm/amd_iommu_types.h |   34 ++++++
 arch/x86/kernel/amd_iommu.c            |  197 ++++++++++++++++++++------------
 arch/x86/kernel/amd_iommu_init.c       |    6 +
 drivers/base/iommu.c                   |   43 +++++---
 drivers/pci/intel-iommu.c              |   22 ++--
 include/linux/iommu.h                  |   24 ++--
 virt/kvm/iommu.c                       |  113 +++++++++++++++----
 8 files changed, 312 insertions(+), 129 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 839b21b..0c6c560 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -324,6 +324,8 @@ and is between 256 and 4096 characters. It is defined in the file
 				    they are unmapped. Otherwise they are
 				    flushed before they will be reused, which
 				    is a lot of faster
+			off	  - do not initialize any AMD IOMMU found in
+				    the system
 
 	amijoy.map=	[HW,JOY] Amiga joystick support
 			Map of devices attached to JOY0DAT and JOY1DAT
diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 86a0ff0..7014e88 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -174,6 +174,40 @@
 				(~((1ULL << (12 + ((lvl) * 9))) - 1)))
 #define PM_ALIGNED(lvl, addr)	((PM_MAP_MASK(lvl) & (addr)) == (addr))
 
+/*
+ * Returns the page table level to use for a given page size
+ * Pagesize is expected to be a power-of-two
+ */
+#define PAGE_SIZE_LEVEL(pagesize) \
+		((__ffs(pagesize) - 12) / 9)
+/*
+ * Returns the number of ptes to use for a given page size
+ * Pagesize is expected to be a power-of-two
+ */
+#define PAGE_SIZE_PTE_COUNT(pagesize) \
+		(1ULL << ((__ffs(pagesize) - 12) % 9))
+
+/*
+ * Aligns a given io-virtual address to a given page size
+ * Pagesize is expected to be a power-of-two
+ */
+#define PAGE_SIZE_ALIGN(address, pagesize) \
+		((address) & ~((pagesize) - 1))
+/*
+ * Creates an IOMMU PTE for an address an a given pagesize
+ * The PTE has no permission bits set
+ * Pagesize is expected to be a power-of-two larger than 4096
+ */
+#define PAGE_SIZE_PTE(address, pagesize)		\
+		(((address) | ((pagesize) - 1)) &	\
+		 (~(pagesize >> 1)) & PM_ADDR_MASK)
+
+/*
+ * Takes a PTE value with mode=0x07 and returns the page size it maps
+ */
+#define PTE_PAGE_SIZE(pte) \
+	(1ULL << (1 + ffz(((pte) | 0xfffULL))))
+
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index f854d89..fa5a147 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -731,18 +731,22 @@ static bool increase_address_space(struct protection_domain *domain,
 
 static u64 *alloc_pte(struct protection_domain *domain,
 		      unsigned long address,
-		      int end_lvl,
+		      unsigned long page_size,
 		      u64 **pte_page,
 		      gfp_t gfp)
 {
+	int level, end_lvl;
 	u64 *pte, *page;
-	int level;
+
+	BUG_ON(!is_power_of_2(page_size));
 
 	while (address > PM_LEVEL_SIZE(domain->mode))
 		increase_address_space(domain, gfp);
 
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	level   = domain->mode - 1;
+	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	address = PAGE_SIZE_ALIGN(address, page_size);
+	end_lvl = PAGE_SIZE_LEVEL(page_size);
 
 	while (level > end_lvl) {
 		if (!IOMMU_PTE_PRESENT(*pte)) {
@@ -752,6 +756,10 @@ static u64 *alloc_pte(struct protection_domain *domain,
 			*pte = PM_LEVEL_PDE(level, virt_to_phys(page));
 		}
 
+		/* No level skipping support yet */
+		if (PM_PTE_LEVEL(*pte) != level)
+			return NULL;
+
 		level -= 1;
 
 		pte = IOMMU_PTE_PAGE(*pte);
@@ -769,28 +777,47 @@ static u64 *alloc_pte(struct protection_domain *domain,
  * This function checks if there is a PTE for a given dma address. If
  * there is one, it returns the pointer to it.
  */
-static u64 *fetch_pte(struct protection_domain *domain,
-		      unsigned long address, int map_size)
+static u64 *fetch_pte(struct protection_domain *domain, unsigned long address)
 {
 	int level;
 	u64 *pte;
 
-	level =  domain->mode - 1;
-	pte   = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
+	if (address > PM_LEVEL_SIZE(domain->mode))
+		return NULL;
+
+	level   =  domain->mode - 1;
+	pte     = &domain->pt_root[PM_LEVEL_INDEX(level, address)];
 
-	while (level > map_size) {
+	while (level > 0) {
+
+		/* Not Present */
 		if (!IOMMU_PTE_PRESENT(*pte))
 			return NULL;
 
+		/* Large PTE */
+		if (PM_PTE_LEVEL(*pte) == 0x07) {
+			unsigned long pte_mask, __pte;
+
+			/*
+			 * If we have a series of large PTEs, make
+			 * sure to return a pointer to the first one.
+			 */
+			pte_mask = PTE_PAGE_SIZE(*pte);
+			pte_mask = ~((PAGE_SIZE_PTE_COUNT(pte_mask) << 3) - 1);
+			__pte    = ((unsigned long)pte) & pte_mask;
+
+			return (u64 *)__pte;
+		}
+
+		/* No level skipping support yet */
+		if (PM_PTE_LEVEL(*pte) != level)
+			return NULL;
+
 		level -= 1;
 
+		/* Walk to the next level */
 		pte = IOMMU_PTE_PAGE(*pte);
 		pte = &pte[PM_LEVEL_INDEX(level, address)];
-
-		if ((PM_PTE_LEVEL(*pte) == 0) && level != map_size) {
-			pte = NULL;
-			break;
-		}
 	}
 
 	return pte;
@@ -807,44 +834,84 @@ static int iommu_map_page(struct protection_domain *dom,
 			  unsigned long bus_addr,
 			  unsigned long phys_addr,
 			  int prot,
-			  int map_size)
+			  unsigned long page_size)
 {
 	u64 __pte, *pte;
-
-	bus_addr  = PAGE_ALIGN(bus_addr);
-	phys_addr = PAGE_ALIGN(phys_addr);
-
-	BUG_ON(!PM_ALIGNED(map_size, bus_addr));
-	BUG_ON(!PM_ALIGNED(map_size, phys_addr));
+	int i, count;
 
 	if (!(prot & IOMMU_PROT_MASK))
 		return -EINVAL;
 
-	pte = alloc_pte(dom, bus_addr, map_size, NULL, GFP_KERNEL);
+	bus_addr  = PAGE_ALIGN(bus_addr);
+	phys_addr = PAGE_ALIGN(phys_addr);
+	count     = PAGE_SIZE_PTE_COUNT(page_size);
+	pte       = alloc_pte(dom, bus_addr, page_size, NULL, GFP_KERNEL);
+
+	for (i = 0; i < count; ++i)
+		if (IOMMU_PTE_PRESENT(pte[i]))
+			return -EBUSY;
 
-	if (IOMMU_PTE_PRESENT(*pte))
-		return -EBUSY;
+	if (page_size > PAGE_SIZE) {
+		__pte = PAGE_SIZE_PTE(phys_addr, page_size);
+		__pte |= PM_LEVEL_ENC(7) | IOMMU_PTE_P | IOMMU_PTE_FC;
+	} else
+		__pte = phys_addr | IOMMU_PTE_P | IOMMU_PTE_FC;
 
-	__pte = phys_addr | IOMMU_PTE_P;
 	if (prot & IOMMU_PROT_IR)
 		__pte |= IOMMU_PTE_IR;
 	if (prot & IOMMU_PROT_IW)
 		__pte |= IOMMU_PTE_IW;
 
-	*pte = __pte;
+	for (i = 0; i < count; ++i)
+		pte[i] = __pte;
 
 	update_domain(dom);
 
 	return 0;
 }
 
-static void iommu_unmap_page(struct protection_domain *dom,
-			     unsigned long bus_addr, int map_size)
+static unsigned long iommu_unmap_page(struct protection_domain *dom,
+				      unsigned long bus_addr,
+				      unsigned long page_size)
 {
-	u64 *pte = fetch_pte(dom, bus_addr, map_size);
+	unsigned long long unmap_size, unmapped;
+	u64 *pte;
+
+	BUG_ON(!is_power_of_2(page_size));
+
+	unmapped = 0;
 
-	if (pte)
-		*pte = 0;
+	while (unmapped < page_size) {
+
+		pte = fetch_pte(dom, bus_addr);
+
+		if (!pte) {
+			/*
+			 * No PTE for this address
+			 * move forward in 4kb steps
+			 */
+			unmap_size = PAGE_SIZE;
+		} else if (PM_PTE_LEVEL(*pte) == 0) {
+			/* 4kb PTE found for this address */
+			unmap_size = PAGE_SIZE;
+			*pte       = 0ULL;
+		} else {
+			int count, i;
+
+			/* Large PTE found which maps this address */
+			unmap_size = PTE_PAGE_SIZE(*pte);
+			count      = PAGE_SIZE_PTE_COUNT(unmap_size);
+			for (i = 0; i < count; i++)
+				pte[i] = 0ULL;
+		}
+
+		bus_addr  = (bus_addr & ~(unmap_size - 1)) + unmap_size;
+		unmapped += unmap_size;
+	}
+
+	BUG_ON(!is_power_of_2(unmapped));
+
+	return unmapped;
 }
 
 /*
@@ -878,7 +945,7 @@ static int dma_ops_unity_map(struct dma_ops_domain *dma_dom,
 	for (addr = e->address_start; addr < e->address_end;
 	     addr += PAGE_SIZE) {
 		ret = iommu_map_page(&dma_dom->domain, addr, addr, e->prot,
-				     PM_MAP_4k);
+				     PAGE_SIZE);
 		if (ret)
 			return ret;
 		/*
@@ -1006,7 +1073,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 		u64 *pte, *pte_page;
 
 		for (i = 0; i < num_ptes; ++i) {
-			pte = alloc_pte(&dma_dom->domain, address, PM_MAP_4k,
+			pte = alloc_pte(&dma_dom->domain, address, PAGE_SIZE,
 					&pte_page, gfp);
 			if (!pte)
 				goto out_free;
@@ -1042,7 +1109,7 @@ static int alloc_new_range(struct dma_ops_domain *dma_dom,
 	for (i = dma_dom->aperture[index]->offset;
 	     i < dma_dom->aperture_size;
 	     i += PAGE_SIZE) {
-		u64 *pte = fetch_pte(&dma_dom->domain, i, PM_MAP_4k);
+		u64 *pte = fetch_pte(&dma_dom->domain, i);
 		if (!pte || !IOMMU_PTE_PRESENT(*pte))
 			continue;
 
@@ -1712,7 +1779,7 @@ static u64* dma_ops_get_pte(struct dma_ops_domain *dom,
 
 	pte = aperture->pte_pages[APERTURE_PAGE_INDEX(address)];
 	if (!pte) {
-		pte = alloc_pte(&dom->domain, address, PM_MAP_4k, &pte_page,
+		pte = alloc_pte(&dom->domain, address, PAGE_SIZE, &pte_page,
 				GFP_ATOMIC);
 		aperture->pte_pages[APERTURE_PAGE_INDEX(address)] = pte_page;
 	} else
@@ -2439,12 +2506,11 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 	return ret;
 }
 
-static int amd_iommu_map_range(struct iommu_domain *dom,
-			       unsigned long iova, phys_addr_t paddr,
-			       size_t size, int iommu_prot)
+static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
+			 phys_addr_t paddr, int gfp_order, int iommu_prot)
 {
+	unsigned long page_size = 0x1000UL << gfp_order;
 	struct protection_domain *domain = dom->priv;
-	unsigned long i,  npages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	int prot = 0;
 	int ret;
 
@@ -2453,61 +2519,50 @@ static int amd_iommu_map_range(struct iommu_domain *dom,
 	if (iommu_prot & IOMMU_WRITE)
 		prot |= IOMMU_PROT_IW;
 
-	iova  &= PAGE_MASK;
-	paddr &= PAGE_MASK;
-
 	mutex_lock(&domain->api_lock);
-
-	for (i = 0; i < npages; ++i) {
-		ret = iommu_map_page(domain, iova, paddr, prot, PM_MAP_4k);
-		if (ret)
-			return ret;
-
-		iova  += PAGE_SIZE;
-		paddr += PAGE_SIZE;
-	}
-
+	ret = iommu_map_page(domain, iova, paddr, prot, page_size);
 	mutex_unlock(&domain->api_lock);
 
-	return 0;
+	return ret;
 }
 
-static void amd_iommu_unmap_range(struct iommu_domain *dom,
-				  unsigned long iova, size_t size)
+static int amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
+			   int gfp_order)
 {
-
 	struct protection_domain *domain = dom->priv;
-	unsigned long i,  npages = iommu_num_pages(iova, size, PAGE_SIZE);
+	unsigned long page_size, unmap_size;
 
-	iova  &= PAGE_MASK;
+	page_size  = 0x1000UL << gfp_order;
 
 	mutex_lock(&domain->api_lock);
-
-	for (i = 0; i < npages; ++i) {
-		iommu_unmap_page(domain, iova, PM_MAP_4k);
-		iova  += PAGE_SIZE;
-	}
+	unmap_size = iommu_unmap_page(domain, iova, page_size);
+	mutex_unlock(&domain->api_lock);
 
 	iommu_flush_tlb_pde(domain);
 
-	mutex_unlock(&domain->api_lock);
+	return get_order(unmap_size);
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  unsigned long iova)
 {
 	struct protection_domain *domain = dom->priv;
-	unsigned long offset = iova & ~PAGE_MASK;
+	unsigned long offset_mask;
 	phys_addr_t paddr;
-	u64 *pte;
+	u64 *pte, __pte;
 
-	pte = fetch_pte(domain, iova, PM_MAP_4k);
+	pte = fetch_pte(domain, iova);
 
 	if (!pte || !IOMMU_PTE_PRESENT(*pte))
 		return 0;
 
-	paddr  = *pte & IOMMU_PAGE_MASK;
-	paddr |= offset;
+	if (PM_PTE_LEVEL(*pte) == 0)
+		offset_mask = PAGE_SIZE - 1;
+	else
+		offset_mask = PTE_PAGE_SIZE(*pte) - 1;
+
+	__pte = *pte & PM_ADDR_MASK;
+	paddr = (__pte & ~offset_mask) | (iova & offset_mask);
 
 	return paddr;
 }
@@ -2523,8 +2578,8 @@ static struct iommu_ops amd_iommu_ops = {
 	.domain_destroy = amd_iommu_domain_destroy,
 	.attach_dev = amd_iommu_attach_device,
 	.detach_dev = amd_iommu_detach_device,
-	.map = amd_iommu_map_range,
-	.unmap = amd_iommu_unmap_range,
+	.map = amd_iommu_map,
+	.unmap = amd_iommu_unmap,
 	.iova_to_phys = amd_iommu_iova_to_phys,
 	.domain_has_cap = amd_iommu_domain_has_cap,
 };
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 6360abf..3bacb4d 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -120,6 +120,7 @@ struct ivmd_header {
 bool amd_iommu_dump;
 
 static int __initdata amd_iommu_detected;
+static bool __initdata amd_iommu_disabled;
 
 u16 amd_iommu_last_bdf;			/* largest PCI device id we have
 					   to handle */
@@ -1372,6 +1373,9 @@ void __init amd_iommu_detect(void)
 	if (no_iommu || (iommu_detected && !gart_iommu_aperture))
 		return;
 
+	if (amd_iommu_disabled)
+		return;
+
 	if (acpi_table_parse("IVRS", early_amd_iommu_detect) == 0) {
 		iommu_detected = 1;
 		amd_iommu_detected = 1;
@@ -1401,6 +1405,8 @@ static int __init parse_amd_iommu_options(char *str)
 	for (; *str; ++str) {
 		if (strncmp(str, "fullflush", 9) == 0)
 			amd_iommu_unmap_flush = true;
+		if (strncmp(str, "off", 3) == 0)
+			amd_iommu_disabled = true;
 	}
 
 	return 1;
diff --git a/drivers/base/iommu.c b/drivers/base/iommu.c
index 8ad4ffe..6e6b6a1 100644
--- a/drivers/base/iommu.c
+++ b/drivers/base/iommu.c
@@ -80,20 +80,6 @@ void iommu_detach_device(struct iommu_domain *domain, struct device *dev)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_device);
 
-int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
-		    phys_addr_t paddr, size_t size, int prot)
-{
-	return iommu_ops->map(domain, iova, paddr, size, prot);
-}
-EXPORT_SYMBOL_GPL(iommu_map_range);
-
-void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
-		      size_t size)
-{
-	iommu_ops->unmap(domain, iova, size);
-}
-EXPORT_SYMBOL_GPL(iommu_unmap_range);
-
 phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 			       unsigned long iova)
 {
@@ -107,3 +93,32 @@ int iommu_domain_has_cap(struct iommu_domain *domain,
 	return iommu_ops->domain_has_cap(domain, cap);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
+
+int iommu_map(struct iommu_domain *domain, unsigned long iova,
+	      phys_addr_t paddr, int gfp_order, int prot)
+{
+	unsigned long invalid_mask;
+	size_t size;
+
+	size         = 0x1000UL << gfp_order;
+	invalid_mask = size - 1;
+
+	BUG_ON((iova | paddr) & invalid_mask);
+
+	return iommu_ops->map(domain, iova, paddr, gfp_order, prot);
+}
+EXPORT_SYMBOL_GPL(iommu_map);
+
+int iommu_unmap(struct iommu_domain *domain, unsigned long iova, int gfp_order)
+{
+	unsigned long invalid_mask;
+	size_t size;
+
+	size         = 0x1000UL << gfp_order;
+	invalid_mask = size - 1;
+
+	BUG_ON(iova & invalid_mask);
+
+	return iommu_ops->unmap(domain, iova, gfp_order);
+}
+EXPORT_SYMBOL_GPL(iommu_unmap);
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 4173125..371dc56 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3626,14 +3626,15 @@ static void intel_iommu_detach_device(struct iommu_domain *domain,
 	domain_remove_one_dev_info(dmar_domain, pdev);
 }
 
-static int intel_iommu_map_range(struct iommu_domain *domain,
-				 unsigned long iova, phys_addr_t hpa,
-				 size_t size, int iommu_prot)
+static int intel_iommu_map(struct iommu_domain *domain,
+			   unsigned long iova, phys_addr_t hpa,
+			   int gfp_order, int iommu_prot)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	u64 max_addr;
 	int addr_width;
 	int prot = 0;
+	size_t size;
 	int ret;
 
 	if (iommu_prot & IOMMU_READ)
@@ -3643,6 +3644,7 @@ static int intel_iommu_map_range(struct iommu_domain *domain,
 	if ((iommu_prot & IOMMU_CACHE) && dmar_domain->iommu_snooping)
 		prot |= DMA_PTE_SNP;
 
+	size     = PAGE_SIZE << gfp_order;
 	max_addr = iova + size;
 	if (dmar_domain->max_addr < max_addr) {
 		int min_agaw;
@@ -3669,19 +3671,19 @@ static int intel_iommu_map_range(struct iommu_domain *domain,
 	return ret;
 }
 
-static void intel_iommu_unmap_range(struct iommu_domain *domain,
-				    unsigned long iova, size_t size)
+static int intel_iommu_unmap(struct iommu_domain *domain,
+			     unsigned long iova, int gfp_order)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
-
-	if (!size)
-		return;
+	size_t size = PAGE_SIZE << gfp_order;
 
 	dma_pte_clear_range(dmar_domain, iova >> VTD_PAGE_SHIFT,
 			    (iova + size - 1) >> VTD_PAGE_SHIFT);
 
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
+
+	return gfp_order;
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
@@ -3714,8 +3716,8 @@ static struct iommu_ops intel_iommu_ops = {
 	.domain_destroy = intel_iommu_domain_destroy,
 	.attach_dev	= intel_iommu_attach_device,
 	.detach_dev	= intel_iommu_detach_device,
-	.map		= intel_iommu_map_range,
-	.unmap		= intel_iommu_unmap_range,
+	.map		= intel_iommu_map,
+	.unmap		= intel_iommu_unmap,
 	.iova_to_phys	= intel_iommu_iova_to_phys,
 	.domain_has_cap = intel_iommu_domain_has_cap,
 };
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 3af4ffd..be22ad8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -37,9 +37,9 @@ struct iommu_ops {
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
 	void (*detach_dev)(struct iommu_domain *domain, struct device *dev);
 	int (*map)(struct iommu_domain *domain, unsigned long iova,
-		   phys_addr_t paddr, size_t size, int prot);
-	void (*unmap)(struct iommu_domain *domain, unsigned long iova,
-		      size_t size);
+		   phys_addr_t paddr, int gfp_order, int prot);
+	int (*unmap)(struct iommu_domain *domain, unsigned long iova,
+		     int gfp_order);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
@@ -56,10 +56,10 @@ extern int iommu_attach_device(struct iommu_domain *domain,
 			       struct device *dev);
 extern void iommu_detach_device(struct iommu_domain *domain,
 				struct device *dev);
-extern int iommu_map_range(struct iommu_domain *domain, unsigned long iova,
-			   phys_addr_t paddr, size_t size, int prot);
-extern void iommu_unmap_range(struct iommu_domain *domain, unsigned long iova,
-			      size_t size);
+extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
+		     phys_addr_t paddr, int gfp_order, int prot);
+extern int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+		       int gfp_order);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
@@ -96,16 +96,16 @@ static inline void iommu_detach_device(struct iommu_domain *domain,
 {
 }
 
-static inline int iommu_map_range(struct iommu_domain *domain,
-				  unsigned long iova, phys_addr_t paddr,
-				  size_t size, int prot)
+static inline int iommu_map(struct iommu_domain *domain, unsigned long iova,
+			    phys_addr_t paddr, int gfp_order, int prot)
 {
 	return -ENODEV;
 }
 
-static inline void iommu_unmap_range(struct iommu_domain *domain,
-				     unsigned long iova, size_t size)
+static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
+			      int gfp_order)
 {
+	return -ENODEV;
 }
 
 static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 80fd3ad..11692b9 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -32,12 +32,30 @@ static int kvm_iommu_unmap_memslots(struct kvm *kvm);
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages);
 
+static pfn_t kvm_pin_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
+			   gfn_t gfn, unsigned long size)
+{
+	gfn_t end_gfn;
+	pfn_t pfn;
+
+	pfn     = gfn_to_pfn_memslot(kvm, slot, gfn);
+	end_gfn = gfn + (size >> PAGE_SHIFT);
+	gfn    += 1;
+
+	if (is_error_pfn(pfn))
+		return pfn;
+
+	while (gfn < end_gfn)
+		gfn_to_pfn_memslot(kvm, slot, gfn++);
+
+	return pfn;
+}
+
 int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 {
-	gfn_t gfn = slot->base_gfn;
-	unsigned long npages = slot->npages;
+	gfn_t gfn, end_gfn;
 	pfn_t pfn;
-	int i, r = 0;
+	int r = 0;
 	struct iommu_domain *domain = kvm->arch.iommu_domain;
 	int flags;
 
@@ -45,31 +63,62 @@ int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot)
 	if (!domain)
 		return 0;
 
+	gfn     = slot->base_gfn;
+	end_gfn = gfn + slot->npages;
+
 	flags = IOMMU_READ | IOMMU_WRITE;
 	if (kvm->arch.iommu_flags & KVM_IOMMU_CACHE_COHERENCY)
 		flags |= IOMMU_CACHE;
 
-	for (i = 0; i < npages; i++) {
-		/* check if already mapped */
-		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn)))
+
+	while (gfn < end_gfn) {
+		unsigned long page_size;
+
+		/* Check if already mapped */
+		if (iommu_iova_to_phys(domain, gfn_to_gpa(gfn))) {
+			gfn += 1;
+			continue;
+		}
+
+		/* Get the page size we could use to map */
+		page_size = kvm_host_page_size(kvm, gfn);
+
+		/* Make sure the page_size does not exceed the memslot */
+		while ((gfn + (page_size >> PAGE_SHIFT)) > end_gfn)
+			page_size >>= 1;
+
+		/* Make sure gfn is aligned to the page size we want to map */
+		while ((gfn << PAGE_SHIFT) & (page_size - 1))
+			page_size >>= 1;
+
+		/*
+		 * Pin all pages we are about to map in memory. This is
+		 * important because we unmap and unpin in 4kb steps later.
+		 */
+		pfn = kvm_pin_pages(kvm, slot, gfn, page_size);
+		if (is_error_pfn(pfn)) {
+			gfn += 1;
 			continue;
+		}
 
-		pfn = gfn_to_pfn_memslot(kvm, slot, gfn);
-		r = iommu_map_range(domain,
-				    gfn_to_gpa(gfn),
-				    pfn_to_hpa(pfn),
-				    PAGE_SIZE, flags);
+		/* Map into IO address space */
+		r = iommu_map(domain, gfn_to_gpa(gfn), pfn_to_hpa(pfn),
+			      get_order(page_size), flags);
 		if (r) {
 			printk(KERN_ERR "kvm_iommu_map_address:"
 			       "iommu failed to map pfn=%lx\n", pfn);
 			goto unmap_pages;
 		}
-		gfn++;
+
+		gfn += page_size >> PAGE_SHIFT;
+
+
 	}
+
 	return 0;
 
 unmap_pages:
-	kvm_iommu_put_pages(kvm, slot->base_gfn, i);
+	kvm_iommu_put_pages(kvm, slot->base_gfn, gfn);
 	return r;
 }
 
@@ -189,27 +238,47 @@ out_unmap:
 	return r;
 }
 
+static void kvm_unpin_pages(struct kvm *kvm, pfn_t pfn, unsigned long npages)
+{
+	unsigned long i;
+
+	for (i = 0; i < npages; ++i)
+		kvm_release_pfn_clean(pfn + i);
+}
+
 static void kvm_iommu_put_pages(struct kvm *kvm,
 				gfn_t base_gfn, unsigned long npages)
 {
-	gfn_t gfn = base_gfn;
+	struct iommu_domain *domain;
+	gfn_t end_gfn, gfn;
 	pfn_t pfn;
-	struct iommu_domain *domain = kvm->arch.iommu_domain;
-	unsigned long i;
 	u64 phys;
 
+	domain  = kvm->arch.iommu_domain;
+	end_gfn = base_gfn + npages;
+	gfn     = base_gfn;
+
 	/* check if iommu exists and in use */
 	if (!domain)
 		return;
 
-	for (i = 0; i < npages; i++) {
+	while (gfn < end_gfn) {
+		unsigned long unmap_pages;
+		int order;
+
+		/* Get physical address */
 		phys = iommu_iova_to_phys(domain, gfn_to_gpa(gfn));
-		pfn = phys >> PAGE_SHIFT;
-		kvm_release_pfn_clean(pfn);
-		gfn++;
-	}
+		pfn  = phys >> PAGE_SHIFT;
+
+		/* Unmap address from IO address space */
+		order       = iommu_unmap(domain, gfn_to_gpa(gfn), PAGE_SIZE);
+		unmap_pages = 1ULL << order;
 
-	iommu_unmap_range(domain, gfn_to_gpa(base_gfn), PAGE_SIZE * npages);
+		/* Unpin all pages we just unmapped to not leak any memory */
+		kvm_unpin_pages(kvm, pfn, unmap_pages);
+
+		gfn += unmap_pages;
+	}
 }
 
 static int kvm_iommu_unmap_memslots(struct kvm *kvm)
