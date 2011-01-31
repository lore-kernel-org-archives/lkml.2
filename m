Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797Ab1AaXKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 18:10:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:22832 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab1AaXJS (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 31 Jan 2011 18:09:18 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Xen-devel@lists.xensource.com,
        konrad@kernel.org, jeremy@goop.org
Cc: hpa@zytor.com, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@eu.citrix.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 01/11] xen: Mark all initial reserved pages for the balloon as INVALID_P2M_ENTRY.
Date: Mon, 31 Jan 2011 17:44:26 -0500
Message-Id: <1296513876-31415-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
References: <1296513876-31415-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this patch, we diligently set regions that will be used by the
balloon driver to be INVALID_P2M_ENTRY and under the ownership
of the balloon driver. We are OK using the __set_phys_to_machine
as we do not expect to be allocating any P2M middle or entries pages.
The set_phys_to_machine has the side-effect of potentially allocating
new pages and we do not want that at this stage.

We can do this because xen_build_mfn_list_list will have already
allocated all such pages up to xen_max_p2m_pfn.

We also move the check for auto translated physmap down the
stack so it is present in __set_phys_to_machine.

[v2: Rebased with mmu->p2m code split]
Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/mmu.c              |    2 +-
 arch/x86/xen/p2m.c              |    9 ++++-----
 arch/x86/xen/setup.c            |    7 ++++++-
 drivers/xen/balloon.c           |    2 +-
 5 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index f25bdf2..8ea9772 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -41,6 +41,7 @@ extern unsigned int   machine_to_phys_order;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
 extern int m2p_add_override(unsigned long mfn, struct page *page);
 extern int m2p_remove_override(struct page *page);
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 5e92b61..0180ae8 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -2074,7 +2074,7 @@ static void xen_zap_pfn_range(unsigned long vaddr, unsigned int order,
 			in_frames[i] = virt_to_mfn(vaddr);
 
 		MULTI_update_va_mapping(mcs.mc, vaddr, VOID_PTE, 0);
-		set_phys_to_machine(virt_to_pfn(vaddr), INVALID_P2M_ENTRY);
+		__set_phys_to_machine(virt_to_pfn(vaddr), INVALID_P2M_ENTRY);
 
 		if (out_frames)
 			out_frames[i] = virt_to_pfn(vaddr);
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index ddc81a0..df4e367 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -365,6 +365,10 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	unsigned topidx, mididx, idx;
 
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return true;
+	}
 	if (unlikely(pfn >= MAX_P2M_PFN)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
 		return true;
@@ -384,11 +388,6 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
 bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
-	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
-		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
-		return true;
-	}
-
 	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
 		if (!alloc_p2m(pfn))
 			return false;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b5a7f92..7201800 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -52,6 +52,8 @@ phys_addr_t xen_extra_mem_start, xen_extra_mem_size;
 
 static __init void xen_add_extra_mem(unsigned long pages)
 {
+	unsigned long pfn;
+
 	u64 size = (u64)pages * PAGE_SIZE;
 	u64 extra_start = xen_extra_mem_start + xen_extra_mem_size;
 
@@ -66,6 +68,9 @@ static __init void xen_add_extra_mem(unsigned long pages)
 	xen_extra_mem_size += size;
 
 	xen_max_p2m_pfn = PFN_DOWN(extra_start + size);
+
+	for (pfn = PFN_DOWN(extra_start); pfn <= xen_max_p2m_pfn; pfn++)
+		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 }
 
 static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
@@ -104,7 +109,7 @@ static unsigned long __init xen_release_chunk(phys_addr_t start_addr,
 		WARN(ret != 1, "Failed to release memory %lx-%lx err=%d\n",
 		     start, end, ret);
 		if (ret == 1) {
-			set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 			len++;
 		}
 	}
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 43f9f02..b1661cd 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -296,7 +296,7 @@ static int decrease_reservation(unsigned long nr_pages)
 	/* No more mappings: invalidate P2M and add to balloon. */
 	for (i = 0; i < nr_pages; i++) {
 		pfn = mfn_to_pfn(frame_list[i]);
-		set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
+		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 		balloon_append(pfn_to_page(pfn));
 	}
 
-- 
1.7.1

