Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab0G2QHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 12:07:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57690 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757959Ab0G2QHL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 29 Jul 2010 12:07:11 -0400
Date: Thu, 29 Jul 2010 12:05:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hpa@zytor.com, jeremy@goop.org, Ian.Campbell@citrix.com,
        albert_herranz@yahoo.es, x86@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
Message-ID: <20100729160557.GA4403@phenom.dumpdata.com>
References: <20100728095157I.fujita.tomonori@lab.ntt.co.jp>
 <20100728223816.GB32739@phenom.dumpdata.com>
 <4C50B4C2.2070807@zytor.com>
 <20100729161653G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729161653G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C51A6F5.00BA:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Long term I think the driverization is the way to go, and..
> > > 
> > > I think the flow a). check if we need SWIOTLB b), check all IOMMUs, c).
> > > recheck SWIOTLB in case no IOMMUs volunteered MUST be preserved
> > > irregardless if we driverize the IOMMUs/SWIOTLB or not.
.. snip..
> > I don't understand point (a) here.  (c) simply seems like the fallback

The way it works right now is that if user specifies swiotlb=force we would
use _only_ SWIOTLB and nothing else.

> > case, and in the case we are actively forcing swiotlb we simply skip
> > step (b).
> 
> Looks like (a) is too simplified. The actual XEN code (a) is:
> 
> +int __init pci_xen_swiotlb_detect(void)
> +{
> +
> +	/* If running as PV guest, either iommu=soft, or swiotlb=force will
> +	 * activate this IOMMU. If running as PV privileged, activate it
> +	 * irregardlesss.
> +	 */
> +	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
> +	    (xen_pv_domain()))
> +		xen_swiotlb = 1;
> +
> +	/* If we are running under Xen, we MUST disable the native SWIOTLB.
> +	 * Don't worry about swiotlb_force flag activating the native, as
> +	 * the 'swiotlb' flag is the only one turning it on. */
> +	if (xen_pv_domain())
> +		swiotlb = 0;
> +
> +	return xen_swiotlb;
> 
> It does things more complicated than checking if swiotlb usage is
> forced.
> 
> Looks like we need to call Xen specific code twice, (a) and (c), I
> dislike it though.

I can eliminate step c) by making a) 'pci_xen_swiotlb_detect' do
what it does now and also utilize the x86_init.iommu.iommu_init.
In essence making it an IOMMU-type-ish.

The patch is on top of the other patches and the only reason I am calling
in 'pci_iommu_alloc' the 'pci_xen_swiotlb_detect' before 'pci_swiotlb_detect'
is because a user could specify 'swiotlb=force' and that would bypass the
Xen SWIOTLB detection code and end up using the wrong dma_ops (under Xen
of course). Oh, and I added a check in gart_iommu_hole_init() to stop it
from setting the iommu_init to its own.

What do you guys think?

Another option would be in 'pci_xen_swiotlb_detect' to coalesce
it with 'pci_xen_swiotlb_init' and right there do the deed.

diff --git a/arch/x86/include/asm/xen/swiotlb-xen.h b/arch/x86/include/asm/xen/swiotlb-xen.h
index 1be1ab7..07ed055 100644
--- a/arch/x86/include/asm/xen/swiotlb-xen.h
+++ b/arch/x86/include/asm/xen/swiotlb-xen.h
@@ -4,11 +4,9 @@
 #ifdef CONFIG_SWIOTLB_XEN
 extern int xen_swiotlb;
 extern int __init pci_xen_swiotlb_detect(void);
-extern void __init pci_xen_swiotlb_init(void);
 #else
 #define xen_swiotlb (0)
 static inline int __init pci_xen_swiotlb_detect(void) { return 0; }
-static inline void __init pci_xen_swiotlb_init(void) { }
 #endif
 
 #endif /* _ASM_X86_SWIOTLB_XEN_H */
diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
index b5d8b0b..7a3ea9a 100644
--- a/arch/x86/kernel/aperture_64.c
+++ b/arch/x86/kernel/aperture_64.c
@@ -379,6 +379,9 @@ void __init gart_iommu_hole_init(void)
 	int fix, slot, valid_agp = 0;
 	int i, node;
 
+	if (iommu_detected)
+		return;
+
 	if (gart_iommu_aperture_disabled || !fix_aperture ||
 	    !early_pci_allowed())
 		return;
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9f07cfc..ef1de8e 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -133,7 +133,9 @@ void __init pci_iommu_alloc(void)
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
+	pci_xen_swiotlb_detect();
+
+	if (pci_swiotlb_detect())
 		goto out;
 
 	gart_iommu_hole_init();
@@ -145,8 +147,6 @@ void __init pci_iommu_alloc(void)
 	/* needs to be called after gart_iommu_hole_init */
 	amd_iommu_detect();
 out:
-	pci_xen_swiotlb_init();
-
 	pci_swiotlb_init();
 }
 
@@ -299,7 +299,7 @@ static int __init pci_iommu_init(void)
 #endif
 	x86_init.iommu.iommu_init();
 
-	if (swiotlb || xen_swiotlb) {
+	if (swiotlb) {
 		printk(KERN_INFO "PCI-DMA: "
 		       "Using software bounce buffering for IO (SWIOTLB)\n");
 		swiotlb_print_info();
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index a013ec9..8722a37 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -1,30 +1,21 @@
 /* Glue code to lib/swiotlb-xen.c */
 
 #include <linux/dma-mapping.h>
-#include <xen/swiotlb-xen.h>
 
+#include <asm/iommu.h>
+#include <asm/x86_init.h>
 #include <asm/xen/hypervisor.h>
+#include <asm/dma.h>
+
+#include <xen/swiotlb-xen.h>
 #include <xen/xen.h>
 
 int xen_swiotlb __read_mostly;
 
-static struct dma_map_ops xen_swiotlb_dma_ops = {
-	.mapping_error = xen_swiotlb_dma_mapping_error,
-	.alloc_coherent = xen_swiotlb_alloc_coherent,
-	.free_coherent = xen_swiotlb_free_coherent,
-	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
-	.sync_single_for_device = xen_swiotlb_sync_single_for_device,
-	.sync_sg_for_cpu = xen_swiotlb_sync_sg_for_cpu,
-	.sync_sg_for_device = xen_swiotlb_sync_sg_for_device,
-	.map_sg = xen_swiotlb_map_sg_attrs,
-	.unmap_sg = xen_swiotlb_unmap_sg_attrs,
-	.map_page = xen_swiotlb_map_page,
-	.unmap_page = xen_swiotlb_unmap_page,
-	.dma_supported = xen_swiotlb_dma_supported,
-};
-
 /*
- * pci_xen_swiotlb_detect - set xen_swiotlb to 1 if necessary
+ * xen_swiotlb_init - detect if we are running under Xen and set
+ * the dma_ops appropiately. Also terminate the baremetal swiotlb if
+ * it has been enabled.
  *
  * This returns non-zero if we are forced to use xen_swiotlb (by the boot
  * option).
@@ -37,22 +28,26 @@ int __init pci_xen_swiotlb_detect(void)
 	 * irregardlesss.
 	 */
 	if ((xen_initial_domain() || swiotlb || swiotlb_force) &&
-	    (xen_pv_domain()))
+	    (xen_pv_domain())) {
 		xen_swiotlb = 1;
+		/* We MUST turn off other IOMMU detection engines. */
+		iommu_detected = 1;
+		x86_init.iommu.iommu_init = xen_swiotlb_init;
+	}
 
-	/* If we are running under Xen, we MUST disable the native SWIOTLB.
-	 * Don't worry about swiotlb_force flag activating the native, as
-	 * the 'swiotlb' flag is the only one turning it on. */
-	if (xen_pv_domain())
+	/* If we are running under PV Xen, we MUST disable the native SWIOTLB
+	 * and the command line overrides - otherwise baremetal SWIOTLB might
+	 * get turned on and BOOM! */
+	if (xen_pv_domain()) {
 		swiotlb = 0;
+		swiotlb_force = 0;
+#ifdef CONFIG_X86_64
+		/* SWIOTLB has a check like this. MUST disable it. */
+		if (!no_iommu && max_pfn > MAX_DMA32_PFN)
+			no_iommu = 1;
+#endif
+	}
 
-	return xen_swiotlb;
-}
 
-void __init pci_xen_swiotlb_init(void)
-{
-	if (xen_swiotlb) {
-		xen_swiotlb_init(1);
-		dma_ops = &xen_swiotlb_dma_ops;
-	}
+	return xen_swiotlb;
 }
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 54469c3..93a0d58 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -38,6 +38,23 @@
 #include <xen/swiotlb-xen.h>
 #include <xen/page.h>
 #include <xen/xen-ops.h>
+
+
+static struct dma_map_ops xen_swiotlb_dma_ops = {
+	.mapping_error = xen_swiotlb_dma_mapping_error,
+	.alloc_coherent = xen_swiotlb_alloc_coherent,
+	.free_coherent = xen_swiotlb_free_coherent,
+	.sync_single_for_cpu = xen_swiotlb_sync_single_for_cpu,
+	.sync_single_for_device = xen_swiotlb_sync_single_for_device,
+	.sync_sg_for_cpu = xen_swiotlb_sync_sg_for_cpu,
+	.sync_sg_for_device = xen_swiotlb_sync_sg_for_device,
+	.map_sg = xen_swiotlb_map_sg_attrs,
+	.unmap_sg = xen_swiotlb_unmap_sg_attrs,
+	.map_page = xen_swiotlb_map_page,
+	.unmap_page = xen_swiotlb_unmap_page,
+	.dma_supported = xen_swiotlb_dma_supported,
+};
+
 /*
  * Used to do a quick range check in swiotlb_tbl_unmap_single and
  * swiotlb_tbl_sync_single_*, to see if the memory was in fact allocated by this
@@ -143,7 +160,7 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 	return 0;
 }
 
-void __init xen_swiotlb_init(int verbose)
+int __init xen_swiotlb_init(void)
 {
 	unsigned long bytes;
 	int rc;
@@ -153,13 +170,15 @@ void __init xen_swiotlb_init(int verbose)
 
 	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
 
+
 	/*
 	 * Get IO TLB memory from any location.
 	 */
 	xen_io_tlb_start = alloc_bootmem(bytes);
-	if (!xen_io_tlb_start)
-		panic("Cannot allocate SWIOTLB buffer");
-
+	if (!xen_io_tlb_start) {
+		printk(KERN_ERR "PCI-DMA: Cannot allocate Xen-SWIOTLB buffer!");
+		return -ENOMEM;
+	}
 	xen_io_tlb_end = xen_io_tlb_start + bytes;
 	/*
 	 * And replace that memory with pages under 4GB.
@@ -171,13 +190,22 @@ void __init xen_swiotlb_init(int verbose)
 		goto error;
 
 	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
-	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
+	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, 1);
+
+	printk(KERN_INFO "PCI-DMA: Xen-SWIOTLB has %luMbytes.\n", bytes);
 
-	return;
+	/* Yup, we are re-enabling it.. WHY? Because in pci-dma.c where the
+	 * code gets called we have if (swiotlb) { .. } else { swiotlb_free();}
+	 * and the swiotlb_free() would effectivly demolish us. */
+	swiotlb = 1;
+	dma_ops = &xen_swiotlb_dma_ops;
+
+	return 0;
 error:
-	panic("DMA(%d): Failed to exchange pages allocated for DMA with Xen! "\
-	      "We either don't have the permission or you do not have enough"\
-	      "free memory under 4GB!\n", rc);
+	printk(KERN_ERR "PCI-DMA: %d: Failed to exchange pages allocated for "\
+	      "DMA with Xen! We either don't have the permission or you do "\
+	      "not have enough free memory under 4GB!\n", rc);
+	return rc;
 }
 
 void *
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index 2ea2fdc..57ec7ef 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -3,7 +3,7 @@
 
 #include <linux/swiotlb.h>
 
-extern void xen_swiotlb_init(int verbose);
+extern int __init xen_swiotlb_init(void);
 
 extern void
 *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,


Making Xen-SWIOTLB be an IOMMU means no more alloc_bootmem. So
this also precipates:
 - Splitting swiotlb_late_init_with_default_size in two functions, one
   that allocates the io_tlb and the other ('swiotlb_late_init_with_tbl')
   for allocation of the other structs.
 - Exporting swiotlb_late_init_with_tbl, IO_TLB_MIN_SLABS and
   SLABS_PER_PAGE
 - Using swiotlb_late_init_with_tbl in Xen-SWIOTLB instead of
   'swiotlb_init_with_tbl'

Here is the patch for that:

diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 93a0d58..367fda2 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -163,6 +163,7 @@ xen_swiotlb_fixup(void *buf, size_t size, unsigned long nslabs)
 int __init xen_swiotlb_init(void)
 {
 	unsigned long bytes;
+	unsigned int order;
 	int rc;
 
 	xen_io_tlb_nslabs = (64 * 1024 * 1024 >> IO_TLB_SHIFT);
@@ -170,15 +171,32 @@ int __init xen_swiotlb_init(void)
 
 	bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
 
+	order = get_order(xen_io_tlb_nslabs << IO_TLB_SHIFT);
 
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-	xen_io_tlb_start = alloc_bootmem(bytes);
+	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
+		xen_io_tlb_start = (void *)__get_free_pages(GFP_DMA |
+							__GFP_NOWARN,
+							order);
+		if (xen_io_tlb_start)
+			break;
+		order--;
+	}
+
 	if (!xen_io_tlb_start) {
 		printk(KERN_ERR "PCI-DMA: Cannot allocate Xen-SWIOTLB buffer!");
 		return -ENOMEM;
 	}
+
+	if (order != get_order(bytes)) {
+		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
+		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
+		xen_io_tlb_nslabs = SLABS_PER_PAGE << order;
+		bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
+	}
+
 	xen_io_tlb_end = xen_io_tlb_start + bytes;
 	/*
 	 * And replace that memory with pages under 4GB.
@@ -190,9 +208,7 @@ int __init xen_swiotlb_init(void)
 		goto error;
 
 	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
-	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, 1);
-
-	printk(KERN_INFO "PCI-DMA: Xen-SWIOTLB has %luMbytes.\n", bytes);
+	swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
 
 	/* Yup, we are re-enabling it.. WHY? Because in pci-dma.c where the
 	 * code gets called we have if (swiotlb) { .. } else { swiotlb_free();}
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 8c0e349..3d263c6 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -22,9 +22,18 @@ extern int swiotlb_force;
  */
 #define IO_TLB_SHIFT 11
 
+#define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
+
+/*
+ * Minimum IO TLB size to bother booting with.  Systems with mainly
+ * 64bit capable cards will only lightly use the swiotlb.  If we can't
+ * allocate a contiguous 1MB, we're probably in trouble anyway.
+ */
+#define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
+
 extern void swiotlb_init(int verbose);
 extern void swiotlb_init_with_tbl(char *tlb, unsigned long nslabs, int verbose);
-
+extern int swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs);
 /*
  * Enumeration for sync targets
  */
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 34e3082..3b6f23b 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -41,15 +41,6 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
-
-/*
- * Minimum IO TLB size to bother booting with.  Systems with mainly
- * 64bit capable cards will only lightly use the swiotlb.  If we can't
- * allocate a contiguous 1MB, we're probably in trouble anyway.
- */
-#define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
-
 int swiotlb_force;
 
 /*
@@ -195,46 +186,15 @@ swiotlb_init(int verbose)
 	swiotlb_init_with_default_size(64 * (1<<20), verbose);	/* default to 64MB */
 }
 
-/*
- * Systems with larger DMA zones (those that don't support ISA) can
- * initialize the swiotlb later using the slab allocator if needed.
- * This should be just like above, but with some error catching.
- */
-int
-swiotlb_late_init_with_default_size(size_t default_size)
+int __init swiotlb_late_init_with_tbl(char *tlb, unsigned long nslabs)
 {
-	unsigned long i, bytes, req_nslabs = io_tlb_nslabs;
+	unsigned long i, bytes;
 	unsigned int order;
 
-	if (!io_tlb_nslabs) {
-		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
-		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
-	}
-
-	/*
-	 * Get IO TLB memory from the low pages
-	 */
+	io_tlb_nslabs = nslabs;
 	order = get_order(io_tlb_nslabs << IO_TLB_SHIFT);
-	io_tlb_nslabs = SLABS_PER_PAGE << order;
+	io_tlb_start = tlb;
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-
-	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-							order);
-		if (io_tlb_start)
-			break;
-		order--;
-	}
-
-	if (!io_tlb_start)
-		goto cleanup1;
-
-	if (order != get_order(bytes)) {
-		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
-		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
-		io_tlb_nslabs = SLABS_PER_PAGE << order;
-		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
-	}
 	io_tlb_end = io_tlb_start + bytes;
 	memset(io_tlb_start, 0, bytes);
 
@@ -287,6 +247,49 @@ cleanup2:
 	io_tlb_end = NULL;
 	free_pages((unsigned long)io_tlb_start, order);
 	io_tlb_start = NULL;
+	return -ENOMEM;
+}
+/*
+ * Systems with larger DMA zones (those that don't support ISA) can
+ * initialize the swiotlb later using the slab allocator if needed.
+ * This should be just like above, but with some error catching.
+ */
+int
+swiotlb_late_init_with_default_size(size_t default_size)
+{
+	unsigned long bytes, req_nslabs = io_tlb_nslabs;
+	unsigned int order;
+
+	if (!io_tlb_nslabs) {
+		io_tlb_nslabs = (default_size >> IO_TLB_SHIFT);
+		io_tlb_nslabs = ALIGN(io_tlb_nslabs, IO_TLB_SEGSIZE);
+	}
+
+	/*
+	 * Get IO TLB memory from the low pages
+	 */
+	order = get_order(io_tlb_nslabs << IO_TLB_SHIFT);
+	io_tlb_nslabs = SLABS_PER_PAGE << order;
+	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
+
+	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
+		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
+							order);
+		if (io_tlb_start)
+			break;
+		order--;
+	}
+
+	if (!io_tlb_start)
+		goto cleanup1;
+
+	if (order != get_order(bytes)) {
+		printk(KERN_WARNING "Warning: only able to allocate %ld MB "
+		       "for software IO TLB\n", (PAGE_SIZE << order) >> 20);
+		io_tlb_nslabs = SLABS_PER_PAGE << order;
+	}
+
+	return swiotlb_late_init_with_tbl(io_tlb_start, io_tlb_nslabs);
 cleanup1:
 	io_tlb_nslabs = req_nslabs;
 	return -ENOMEM;


I don't have an IA64 to actually test that patch for regression. Under
Xen I keep on getting:


[    0.431357] Warning: only able to allocate 4 MB for software IO TLB
[    0.435386] Placing 4MB software IO TLB between ffff880000c00000 -
ffff880001000000
[    0.435404] software IO TLB at phys 0xc00000 - 0x1000000


Adding in a bit of printks does show we try 14,13,12,11, and 10 order
pages and succed at the last order. Is that just b/c I am asking for
such huge pages? (the guest BTW, has 2GB allocated to it)


> 
> 
> btw, (c) is not the fallback case (i.e. if we can't find hardware
> IOMMU, we enable swiotlb). We use both hardware IOMMU and swiotlb on
> some systems.

Ooops. Yes, that was an oversimplication.
