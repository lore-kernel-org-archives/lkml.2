Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab0FVTtY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 15:49:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51713 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab0FVTqp (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 22 Jun 2010 15:46:45 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
       iommu@lists.linux-foundation.org, albert_herranz@yahoo.es,
       x86@kernel.org
Cc: Alex Nixon <alex.nixon@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Ian Campbell <ian.campbell@citrix.com>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 04/19] xen: Add xen_create_contiguous_region
Date: Tue, 22 Jun 2010 15:42:37 -0400
Message-Id: <1277235772-26757-5-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
References: <1277235772-26757-1-git-send-email-konrad.wilk@oracle.com>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C2112CE.023B:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>

A memory region must be physically contiguous in order to be accessed
through DMA.  This patch adds xen_create_contiguous_region, which
ensures a region of contiguous virtual memory is also physically
contiguous.

Based on Stephen Tweedie's port of the 2.6.18-xen version.

Remove contiguous_bitmap[] as it's no longer needed.

Ported from linux-2.6.18-xen.hg 707:e410857fd83c

[ Impact: add Xen-internal API to make pages phys-contig ]

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c             |  201 ++++++++++++++++++++++++++++++++++++++++
 include/xen/interface/memory.h |   42 ++++++++
 include/xen/xen-ops.h          |    6 +
 3 files changed, 249 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 9e0d82f..eb51402 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -53,6 +53,7 @@
 #include <asm/paravirt.h>
 #include <asm/e820.h>
 #include <asm/linkage.h>
+#include <asm/page.h>
 
 #include <asm/xen/hypercall.h>
 #include <asm/xen/hypervisor.h>
@@ -2027,6 +2028,206 @@ void __init xen_init_mmu_ops(void)
 	pv_mmu_ops = xen_mmu_ops;
 }
 
+/* Protected by xen_reservation_lock. */
+#define MAX_CONTIG_ORDER 9 /* 2MB */
+static unsigned long discontig_frames[1<<MAX_CONTIG_ORDER];
+
+#define VOID_PTE (mfn_pte(0, __pgprot(0)))
+static void xen_zap_pfn_range(unsigned long vaddr, unsigned int order,
+				unsigned long *in_frames,
+				unsigned long *out_frames)
+{
+	int i;
+	struct multicall_space mcs;
+
+	xen_mc_batch();
+	for (i = 0; i < (1UL<<order); i++, vaddr += PAGE_SIZE) {
+		mcs = __xen_mc_entry(0);
+
+		if (in_frames)
+			in_frames[i] = virt_to_mfn(vaddr);
+
+		MULTI_update_va_mapping(mcs.mc, vaddr, VOID_PTE, 0);
+		set_phys_to_machine(virt_to_pfn(vaddr), INVALID_P2M_ENTRY);
+
+		if (out_frames)
+			out_frames[i] = virt_to_pfn(vaddr);
+	}
+	xen_mc_issue(0);
+}
+
+/*
+ * Update the pfn-to-mfn mappings for a virtual address range, either to
+ * point to an array of mfns, or contiguously from a single starting
+ * mfn.
+ */
+static void xen_remap_exchanged_ptes(unsigned long vaddr, int order,
+				     unsigned long *mfns,
+				     unsigned long first_mfn)
+{
+	unsigned i, limit;
+	unsigned long mfn;
+
+	xen_mc_batch();
+
+	limit = 1u << order;
+	for (i = 0; i < limit; i++, vaddr += PAGE_SIZE) {
+		struct multicall_space mcs;
+		unsigned flags;
+
+		mcs = __xen_mc_entry(0);
+		if (mfns)
+			mfn = mfns[i];
+		else
+			mfn = first_mfn + i;
+
+		if (i < (limit - 1))
+			flags = 0;
+		else {
+			if (order == 0)
+				flags = UVMF_INVLPG | UVMF_ALL;
+			else
+				flags = UVMF_TLB_FLUSH | UVMF_ALL;
+		}
+
+		MULTI_update_va_mapping(mcs.mc, vaddr,
+				mfn_pte(mfn, PAGE_KERNEL), flags);
+
+		set_phys_to_machine(virt_to_pfn(vaddr), mfn);
+	}
+
+	xen_mc_issue(0);
+}
+
+/*
+ * Perform the hypercall to exchange a region of our pfns to point to
+ * memory with the required contiguous alignment.  Takes the pfns as
+ * input, and populates mfns as output.
+ *
+ * Returns a success code indicating whether the hypervisor was able to
+ * satisfy the request or not.
+ */
+static int xen_exchange_memory(unsigned long extents_in, unsigned int order_in,
+			       unsigned long *pfns_in,
+			       unsigned long extents_out,
+			       unsigned int order_out,
+			       unsigned long *mfns_out,
+			       unsigned int address_bits)
+{
+	long rc;
+	int success;
+
+	struct xen_memory_exchange exchange = {
+		.in = {
+			.nr_extents   = extents_in,
+			.extent_order = order_in,
+			.extent_start = pfns_in,
+			.domid        = DOMID_SELF
+		},
+		.out = {
+			.nr_extents   = extents_out,
+			.extent_order = order_out,
+			.extent_start = mfns_out,
+			.address_bits = address_bits,
+			.domid        = DOMID_SELF
+		}
+	};
+
+	BUG_ON(extents_in << order_in != extents_out << order_out);
+
+	rc = HYPERVISOR_memory_op(XENMEM_exchange, &exchange);
+	success = (exchange.nr_exchanged == extents_in);
+
+	BUG_ON(!success && ((exchange.nr_exchanged != 0) || (rc == 0)));
+	BUG_ON(success && (rc != 0));
+
+	return success;
+}
+
+int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+				 unsigned int address_bits)
+{
+	unsigned long *in_frames = discontig_frames, out_frame;
+	unsigned long  flags;
+	int            success;
+
+	/*
+	 * Currently an auto-translated guest will not perform I/O, nor will
+	 * it require PAE page directories below 4GB. Therefore any calls to
+	 * this function are redundant and can be ignored.
+	 */
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return 0;
+
+	if (unlikely(order > MAX_CONTIG_ORDER))
+		return -ENOMEM;
+
+	memset((void *) vstart, 0, PAGE_SIZE << order);
+
+	vm_unmap_aliases();
+
+	spin_lock_irqsave(&xen_reservation_lock, flags);
+
+	/* 1. Zap current PTEs, remembering MFNs. */
+	xen_zap_pfn_range(vstart, order, in_frames, NULL);
+
+	/* 2. Get a new contiguous memory extent. */
+	out_frame = virt_to_pfn(vstart);
+	success = xen_exchange_memory(1UL << order, 0, in_frames,
+				      1, order, &out_frame,
+				      address_bits);
+
+	/* 3. Map the new extent in place of old pages. */
+	if (success)
+		xen_remap_exchanged_ptes(vstart, order, NULL, out_frame);
+	else
+		xen_remap_exchanged_ptes(vstart, order, in_frames, 0);
+
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
+
+	return success ? 0 : -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(xen_create_contiguous_region);
+
+void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order)
+{
+	unsigned long *out_frames = discontig_frames, in_frame;
+	unsigned long  flags;
+	int success;
+
+	if (xen_feature(XENFEAT_auto_translated_physmap))
+		return;
+
+	if (unlikely(order > MAX_CONTIG_ORDER))
+		return;
+
+	memset((void *) vstart, 0, PAGE_SIZE << order);
+
+	vm_unmap_aliases();
+
+	spin_lock_irqsave(&xen_reservation_lock, flags);
+
+	/* 1. Find start MFN of contiguous extent. */
+	in_frame = virt_to_mfn(vstart);
+
+	/* 2. Zap current PTEs. */
+	xen_zap_pfn_range(vstart, order, NULL, out_frames);
+
+	/* 3. Do the exchange for non-contiguous MFNs. */
+	success = xen_exchange_memory(1, order, &in_frame, 1UL << order,
+					0, out_frames, 0);
+
+	/* 4. Map new pages in place of old pages. */
+	if (success)
+		xen_remap_exchanged_ptes(vstart, order, out_frames, 0);
+	else
+		xen_remap_exchanged_ptes(vstart, order, NULL, in_frame);
+
+	spin_unlock_irqrestore(&xen_reservation_lock, flags);
+}
+EXPORT_SYMBOL_GPL(xen_destroy_contiguous_region);
+
 #ifdef CONFIG_XEN_DEBUG_FS
 
 static struct dentry *d_mmu_debug;
diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
index e6adce6..d3938d3 100644
--- a/include/xen/interface/memory.h
+++ b/include/xen/interface/memory.h
@@ -55,6 +55,48 @@ struct xen_memory_reservation {
 DEFINE_GUEST_HANDLE_STRUCT(xen_memory_reservation);
 
 /*
+ * An atomic exchange of memory pages. If return code is zero then
+ * @out.extent_list provides GMFNs of the newly-allocated memory.
+ * Returns zero on complete success, otherwise a negative error code.
+ * On complete success then always @nr_exchanged == @in.nr_extents.
+ * On partial success @nr_exchanged indicates how much work was done.
+ */
+#define XENMEM_exchange             11
+struct xen_memory_exchange {
+    /*
+     * [IN] Details of memory extents to be exchanged (GMFN bases).
+     * Note that @in.address_bits is ignored and unused.
+     */
+    struct xen_memory_reservation in;
+
+    /*
+     * [IN/OUT] Details of new memory extents.
+     * We require that:
+     *  1. @in.domid == @out.domid
+     *  2. @in.nr_extents  << @in.extent_order ==
+     *     @out.nr_extents << @out.extent_order
+     *  3. @in.extent_start and @out.extent_start lists must not overlap
+     *  4. @out.extent_start lists GPFN bases to be populated
+     *  5. @out.extent_start is overwritten with allocated GMFN bases
+     */
+    struct xen_memory_reservation out;
+
+    /*
+     * [OUT] Number of input extents that were successfully exchanged:
+     *  1. The first @nr_exchanged input extents were successfully
+     *     deallocated.
+     *  2. The corresponding first entries in the output extent list correctly
+     *     indicate the GMFNs that were successfully exchanged.
+     *  3. All other input and output extents are untouched.
+     *  4. If not all input exents are exchanged then the return code of this
+     *     command will be non-zero.
+     *  5. THIS FIELD MUST BE INITIALISED TO ZERO BY THE CALLER!
+     */
+    unsigned long nr_exchanged;
+};
+
+DEFINE_GUEST_HANDLE_STRUCT(xen_memory_exchange);
+/*
  * Returns the maximum machine frame number of mapped RAM in this system.
  * This command always succeeds (it never returns an error code).
  * arg == NULL.
diff --git a/include/xen/xen-ops.h b/include/xen/xen-ops.h
index 883a21b..d789c93 100644
--- a/include/xen/xen-ops.h
+++ b/include/xen/xen-ops.h
@@ -14,4 +14,10 @@ void xen_mm_unpin_all(void);
 void xen_timer_resume(void);
 void xen_arch_resume(void);
 
+extern unsigned long *xen_contiguous_bitmap;
+int xen_create_contiguous_region(unsigned long vstart, unsigned int order,
+				unsigned int address_bits);
+
+void xen_destroy_contiguous_region(unsigned long vstart, unsigned int order);
+
 #endif /* INCLUDE_XEN_OPS_H */
-- 
1.7.0.1

