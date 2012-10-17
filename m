Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621Ab2JQLco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:32:44 -0400
Received: from smtp.citrix.com ([66.165.176.89]:52386 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756255Ab2JQLcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:32:16 -0400
X-IronPort-AV: E=Sophos;i="4.80,600,1344211200"; 
   d="scan'208";a="41487905"
From: Ian Campbell <ian.campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <stefano.stabellini@citrix.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org, Ian Campbell <ian.campbell@citrix.com>
Subject: [PATCH 5/6] xen: arm: implement remap interfaces needed for privcmd mappings.
Date: Wed, 17 Oct 2012 12:32:11 +0100
Message-ID: <1350473532-15863-5-git-send-email-ian.campbell@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
References: <1350473518.2460.58.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use XENMEM_add_to_physmap_range which is the preferred interface
for foreign mappings.

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/arm/include/asm/xen/interface.h |    1 +
 arch/arm/xen/enlighten.c             |  100 +++++++++++++++++++++++++++++++++-
 arch/x86/include/asm/xen/interface.h |    1 +
 include/xen/interface/memory.h       |   18 ++++++
 4 files changed, 117 insertions(+), 3 deletions(-)

diff --git a/arch/arm/include/asm/xen/interface.h b/arch/arm/include/asm/xen/interface.h
index 1d6ef9c..007e6da 100644
--- a/arch/arm/include/asm/xen/interface.h
+++ b/arch/arm/include/asm/xen/interface.h
@@ -43,6 +43,7 @@ DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
 DEFINE_GUEST_HANDLE(xen_pfn_t);
+DEFINE_GUEST_HANDLE(xen_ulong_t);
 
 /* Maximum number of virtual CPUs in multi-processor guests. */
 #define MAX_VIRT_CPUS 1
diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index ba5cc13..6bb4630 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -9,6 +9,7 @@
 #include <xen/platform_pci.h>
 #include <xen/xenbus.h>
 #include <xen/page.h>
+#include <xen/xen-ops.h>
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
 #include <linux/interrupt.h>
@@ -18,6 +19,8 @@
 #include <linux/of_irq.h>
 #include <linux/of_address.h>
 
+#include <linux/mm.h>
+
 struct start_info _xen_start_info;
 struct start_info *xen_start_info = &_xen_start_info;
 EXPORT_SYMBOL_GPL(xen_start_info);
@@ -43,15 +46,106 @@ EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 
 static __read_mostly int xen_events_irq = -1;
 
+/* map fgmfn of domid to lpfn in the current domain */
+static int map_foreign_page(unsigned long lpfn, unsigned long fgmfn,
+			    unsigned int domid)
+{
+	int rc;
+	struct xen_add_to_physmap_range xatp = {
+		.domid = DOMID_SELF,
+		.foreign_domid = domid,
+		.size = 1,
+		.space = XENMAPSPACE_gmfn_foreign,
+	};
+	xen_ulong_t idx = fgmfn;
+	xen_pfn_t gpfn = lpfn;
+
+	set_xen_guest_handle(xatp.idxs, &idx);
+	set_xen_guest_handle(xatp.gpfns, &gpfn);
+
+	rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap_range, &xatp);
+	if (rc) {
+		pr_warn("Failed to map pfn to mfn rc:%d pfn:%lx mfn:%lx\n",
+			rc, lpfn, fgmfn);
+		return 1;
+	}
+	return 0;
+}
+
+struct remap_data {
+	xen_pfn_t fgmfn; /* foreign domain's gmfn */
+	pgprot_t prot;
+	domid_t  domid;
+	struct vm_area_struct *vma;
+	int index;
+	struct page **pages;
+	struct xen_remap_mfn_info *info;
+};
+
+static int remap_pte_fn(pte_t *ptep, pgtable_t token, unsigned long addr,
+			void *data)
+{
+	struct remap_data *info = data;
+	struct page *page = info->pages[info->index++];
+	unsigned long pfn = page_to_pfn(page);
+	pte_t pte = pfn_pte(pfn, info->prot);
+
+	if (map_foreign_page(pfn, info->fgmfn, info->domid))
+		return -EFAULT;
+	set_pte_at(info->vma->vm_mm, addr, ptep, pte);
+
+	return 0;
+}
+
 int xen_remap_domain_mfn_range(struct vm_area_struct *vma,
 			       unsigned long addr,
-			       unsigned long mfn, int nr,
-			       pgprot_t prot, unsigned domid)
+			       xen_pfn_t mfn, int nr,
+			       pgprot_t prot, unsigned domid,
+			       struct page **pages)
 {
-	return -ENOSYS;
+	int err;
+	struct remap_data data;
+
+	/* TBD: Batching, current sole caller only does page at a time */
+	if (nr > 1)
+		return -EINVAL;
+
+	data.fgmfn = mfn;
+	data.prot = prot;
+	data.domid = domid;
+	data.vma = vma;
+	data.index = 0;
+	data.pages = pages;
+	err = apply_to_page_range(vma->vm_mm, addr, nr << PAGE_SHIFT,
+				  remap_pte_fn, &data);
+	return err;
 }
 EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
 
+int xen_unmap_domain_mfn_range(struct vm_area_struct *vma,
+			       struct page **pages, int nr)
+{
+	int i;
+
+	for (i=0; i<nr; i++) {
+		struct xen_remove_from_physmap xrp;
+		unsigned long rc, pfn;
+
+		pfn = page_to_pfn(pages[i]);
+
+		xrp.domid = DOMID_SELF;
+		xrp.gpfn = pfn;
+		rc = HYPERVISOR_memory_op(XENMEM_remove_from_physmap, &xrp);
+		if (rc) {
+			pr_warn("Failed to unmap pfn:%lx rc:%ld\n",
+				pfn, rc);
+			return rc;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xen_unmap_domain_mfn_range);
+
 /*
  * see Documentation/devicetree/bindings/arm/xen.txt for the
  * documentation of the Xen Device Tree format.
diff --git a/arch/x86/include/asm/xen/interface.h b/arch/x86/include/asm/xen/interface.h
index 25669c3..6246d80 100644
--- a/arch/x86/include/asm/xen/interface.h
+++ b/arch/x86/include/asm/xen/interface.h
@@ -63,6 +63,7 @@ DEFINE_GUEST_HANDLE(void);
 DEFINE_GUEST_HANDLE(uint64_t);
 DEFINE_GUEST_HANDLE(uint32_t);
 DEFINE_GUEST_HANDLE(xen_pfn_t);
+DEFINE_GUEST_HANDLE(xen_ulong_t);
 #endif
 
 #ifndef HYPERVISOR_VIRT_START
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index 91bdc2a..eb2d3e5 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -190,6 +190,24 @@ DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap);
 /*** REMOVED ***/
 /*#define XENMEM_translate_gpfn_list  8*/
 
+#define XENMEM_add_to_physmap_range 23
+struct xen_add_to_physmap_range {
+    /* Which domain to change the mapping for. */
+    domid_t domid;
+    uint16_t space; /* => enum phys_map_space */
+
+    /* Number of pages to go through */
+    uint16_t size;
+    domid_t foreign_domid; /* IFF gmfn_foreign */
+
+    /* Indexes into space being mapped. */
+    GUEST_HANDLE(xen_ulong_t) idxs;
+
+    /* GPFN in domid where the source mapping page should appear. */
+    GUEST_HANDLE(xen_pfn_t) gpfns;
+};
+DEFINE_GUEST_HANDLE_STRUCT(xen_add_to_physmap_range);
+
 /*
  * Returns the pseudo-physical memory map as it was when the domain
  * was started (specified by XENMEM_set_memory_map).
-- 
1.7.2.5

