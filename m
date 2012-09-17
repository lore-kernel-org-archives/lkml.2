Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab2IQRNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:13:22 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20101 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755639Ab2IQRNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:13:20 -0400
Date: Mon, 17 Sep 2012 13:02:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 10/10] xen/swiotlb: Depending on after_bootmem is not
 correct.
Message-ID: <20120917170221.GA15783@phenom.dumpdata.com>
References: <1347306367-28669-1-git-send-email-konrad.wilk@oracle.com>
 <1347306367-28669-11-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1209141709580.29232@kaball.uk.xensource.com>
 <20120917142315.GA12541@phenom.dumpdata.com>
 <alpine.DEB.2.02.1209171550570.29232@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209171550570.29232@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 03:52:20PM +0100, Stefano Stabellini wrote:
> On Mon, 17 Sep 2012, Konrad Rzeszutek Wilk wrote:
> > > >  	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
> > > > -	if (!after_bootmem)
> > > > +	rc = 0;
> > >      ^
> > > why does this change belong to this patch?
> > > 
> > > 
> > 
> > I took that out of the this patch, so it is now:
> > 
> > 
> > >From c5bc5502abc0f70b682c0f2a70d08e6319825163 Mon Sep 17 00:00:00 2001
> > From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Date: Wed, 5 Sep 2012 13:35:47 -0400
> > Subject: [PATCH 1/2] xen/swiotlb: Depending on after_bootmem is not correct.
> > 
> > When PCI IOMMUs are initialized it is after after_bootmem but
> > before a lot of "other" subsystems are initialized. As such
> > the check for after_bootmem is incorrect and we should
> > just use a parameter to define whether we are early or late.
> 
> Given that the after_bootmem checks are introduced by patch 6/10, I
> would just merge the two.
> In any case, it looks OK now.

Squashed it in:

>From b82776005369899c1c7ca2e4b2414bb64b538d2c Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 23 Aug 2012 14:36:15 -0400
Subject: [PATCH] xen/swiotlb: Use the swiotlb_late_init_with_tbl to init
 Xen-SWIOTLB late when PV PCI is used.

With this patch we provide the functionality to initialize the
Xen-SWIOTLB late in the bootup cycle - specifically for
Xen PCI-frontend. We still will work if the user had
supplied 'iommu=soft' on the Linux command line.

Note: We cannot depend on after_bootmem to automatically
determine whether this is early or not. This is because
when PCI IOMMUs are initialized it is after after_bootmem but
before a lot of "other" subsystems are initialized.

CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
[v1: Fix smatch warnings]
[v2: Added check for xen_swiotlb]
[v3: Rebased with new xen-swiotlb changes]
[v4: squashed xen/swiotlb: Depending on after_bootmem is not correct in]
Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/swiotlb-xen.h |    2 +
 arch/x86/xen/pci-swiotlb-xen.c         |   24 ++++++++++++++-
 drivers/xen/swiotlb-xen.c              |   48 +++++++++++++++++++++++++------
 include/xen/swiotlb-xen.h              |    2 +-
 4 files changed, 63 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/xen/swiotlb-xen.h b/arch/x86/include/asm/xen/swiotlb-xen.h
index 1be1ab7..ee52fca 100644
--- a/arch/x86/include/asm/xen/swiotlb-xen.h
+++ b/arch/x86/include/asm/xen/swiotlb-xen.h
@@ -5,10 +5,12 @@
 extern int xen_swiotlb;
 extern int __init pci_xen_swiotlb_detect(void);
 extern void __init pci_xen_swiotlb_init(void);
+extern int pci_xen_swiotlb_init_late(void);
 #else
 #define xen_swiotlb (0)
 static inline int __init pci_xen_swiotlb_detect(void) { return 0; }
 static inline void __init pci_xen_swiotlb_init(void) { }
+static inline int pci_xen_swiotlb_init_late(void) { return -ENXIO; }
 #endif
 
 #endif /* _ASM_X86_SWIOTLB_XEN_H */
diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
index 1c17227..b152640 100644
--- a/arch/x86/xen/pci-swiotlb-xen.c
+++ b/arch/x86/xen/pci-swiotlb-xen.c
@@ -12,7 +12,7 @@
 #include <asm/iommu.h>
 #include <asm/dma.h>
 #endif
-
+#include <linux/export.h>
 int xen_swiotlb __read_mostly;
 
 static struct dma_map_ops xen_swiotlb_dma_ops = {
@@ -69,13 +69,33 @@ int __init pci_xen_swiotlb_detect(void)
 void __init pci_xen_swiotlb_init(void)
 {
 	if (xen_swiotlb) {
-		xen_swiotlb_init(1);
+		xen_swiotlb_init(1, true /* early */);
 		dma_ops = &xen_swiotlb_dma_ops;
 
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
 	}
 }
+
+int pci_xen_swiotlb_init_late(void)
+{
+	int rc;
+
+	if (xen_swiotlb)
+		return 0;
+
+	rc = xen_swiotlb_init(1, false /* late */);
+	if (rc)
+		return rc;
+
+	dma_ops = &xen_swiotlb_dma_ops;
+	/* Make sure ACS will be enabled */
+	pci_request_acs();
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(pci_xen_swiotlb_init_late);
+
 IOMMU_INIT_FINISH(pci_xen_swiotlb_detect,
 		  0,
 		  pci_xen_swiotlb_init,
diff --git a/drivers/xen/swiotlb-xen.c b/drivers/xen/swiotlb-xen.c
index 701b103..7461edb 100644
--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -176,9 +176,9 @@ static const char *xen_swiotlb_error(enum xen_swiotlb_err err)
 	}
 	return "";
 }
-void __init xen_swiotlb_init(int verbose)
+int __ref xen_swiotlb_init(int verbose, bool early)
 {
-	unsigned long bytes;
+	unsigned long bytes, order;
 	int rc = -ENOMEM;
 	enum xen_swiotlb_err m_ret = XEN_SWIOTLB_UNKNOWN;
 	unsigned int repeat = 3;
@@ -186,10 +186,28 @@ void __init xen_swiotlb_init(int verbose)
 	xen_io_tlb_nslabs = swiotlb_nr_tbl();
 retry:
 	bytes = xen_set_nslabs(xen_io_tlb_nslabs);
+	order = get_order(xen_io_tlb_nslabs << IO_TLB_SHIFT);
 	/*
 	 * Get IO TLB memory from any location.
 	 */
-	xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
+	if (early)
+		xen_io_tlb_start = alloc_bootmem_pages(PAGE_ALIGN(bytes));
+	else {
+#define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
+#define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
+		while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
+			xen_io_tlb_start = (void *)__get_free_pages(__GFP_NOWARN, order);
+			if (xen_io_tlb_start)
+				break;
+			order--;
+		}
+		if (order != get_order(bytes)) {
+			pr_warn("Warning: only able to allocate %ld MB "
+				"for software IO TLB\n", (PAGE_SIZE << order) >> 20);
+			xen_io_tlb_nslabs = SLABS_PER_PAGE << order;
+			bytes = xen_io_tlb_nslabs << IO_TLB_SHIFT;
+		}
+	}
 	if (!xen_io_tlb_start) {
 		m_ret = XEN_SWIOTLB_ENOMEM;
 		goto error;
@@ -202,14 +220,21 @@ retry:
 			       bytes,
 			       xen_io_tlb_nslabs);
 	if (rc) {
-		free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
+		if (early)
+			free_bootmem(__pa(xen_io_tlb_start), PAGE_ALIGN(bytes));
+		else {
+			free_pages((unsigned long)xen_io_tlb_start, order);
+			xen_io_tlb_start = NULL;
+		}
 		m_ret = XEN_SWIOTLB_EFIXUP;
 		goto error;
 	}
 	start_dma_addr = xen_virt_to_bus(xen_io_tlb_start);
-	swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
-
-	return;
+	if (early)
+		swiotlb_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs, verbose);
+	else
+		rc = swiotlb_late_init_with_tbl(xen_io_tlb_start, xen_io_tlb_nslabs);
+	return rc;
 error:
 	if (repeat--) {
 		xen_io_tlb_nslabs = max(1024UL, /* Min is 2MB */
@@ -218,10 +243,13 @@ error:
 		      (xen_io_tlb_nslabs << IO_TLB_SHIFT) >> 20);
 		goto retry;
 	}
-	xen_raw_printk("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
-	panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
+	pr_err("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
+	if (early)
+		panic("%s (rc:%d)", xen_swiotlb_error(m_ret), rc);
+	else
+		free_pages((unsigned long)xen_io_tlb_start, order);
+	return rc;
 }
-
 void *
 xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			   dma_addr_t *dma_handle, gfp_t flags,
diff --git a/include/xen/swiotlb-xen.h b/include/xen/swiotlb-xen.h
index 4f4d449..289ee50 100644
--- a/include/xen/swiotlb-xen.h
+++ b/include/xen/swiotlb-xen.h
@@ -3,7 +3,7 @@
 
 #include <linux/swiotlb.h>
 
-extern void xen_swiotlb_init(int verbose);
+extern int xen_swiotlb_init(int verbose, bool early);
 
 extern void
 *xen_swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-- 
1.7.7.6

