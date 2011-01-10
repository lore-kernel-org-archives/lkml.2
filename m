Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562Ab1AJRTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 12:19:14 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52674 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1AJRTM (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 Jan 2011 12:19:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        hpa@zytor.com, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>, xen-devel@lists.xensource.com,
        Jan Beulich <JBeulich@novell.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/7] xen: Mark all initial reserved pages for the balloon as INVALID_P2M_ENTRY.
Date: Mon, 10 Jan 2011 12:17:33 -0500
Message-Id: <1294679859-30029-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1294679859-30029-1-git-send-email-konrad.wilk@oracle.com>
References: <1294679859-30029-1-git-send-email-konrad.wilk@oracle.com>
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

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/mmu.c              |   12 ++++++------
 arch/x86/xen/setup.c            |    7 ++++++-
 drivers/xen/balloon.c           |    2 +-
 4 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 8760cc6..be671f6 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -41,6 +41,7 @@ extern unsigned int   machine_to_phys_order;
 
 extern unsigned long get_phys_to_machine(unsigned long pfn);
 extern bool set_phys_to_machine(unsigned long pfn, unsigned long mfn);
+extern bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn);
 
 static inline unsigned long pfn_to_mfn(unsigned long pfn)
 {
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 44924e5..8e9c669 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -503,6 +503,11 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	unsigned topidx, mididx, idx;
 
+	if (unlikely(xen_feature(XENFEAT_auto_translated_physmap))) {
+		BUG_ON(pfn != mfn && mfn != INVALID_P2M_ENTRY);
+		return true;
+	}
+
 	if (unlikely(pfn >= MAX_P2M_PFN)) {
 		BUG_ON(mfn != INVALID_P2M_ENTRY);
 		return true;
@@ -522,11 +527,6 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 
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
@@ -2438,7 +2438,7 @@ static void xen_zap_pfn_range(unsigned long vaddr, unsigned int order,
 			in_frames[i] = virt_to_mfn(vaddr);
 
 		MULTI_update_va_mapping(mcs.mc, vaddr, VOID_PTE, 0);
-		set_phys_to_machine(virt_to_pfn(vaddr), INVALID_P2M_ENTRY);
+		__set_phys_to_machine(virt_to_pfn(vaddr), INVALID_P2M_ENTRY);
 
 		if (out_frames)
 			out_frames[i] = virt_to_pfn(vaddr);
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

