Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603Ab1GIFyQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:54:16 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:49244 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752214Ab1GIFyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:04 -0400
X-Sasl-enc: 1NnUG1ghek+N7es98hblbXqnPEOigo+GJuF91eoEZuIT 1310190843
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:19 2011
Message-Id: <20110708225119.130655530@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:49:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [03/35] xen: partially revert "xen: set max_pfn_mapped to the last pfn mapped"
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

commit a91d92875ee94e4703fd017ccaadb48cfb344994 upstream.

We only need to set max_pfn_mapped to the last pfn mapped on x86_64 to
make sure that cleanup_highmap doesn't remove important mappings at
_end.

We don't need to do this on x86_32 because cleanup_highmap is not called
on x86_32. Besides lowering max_pfn_mapped on x86_32 has the unwanted
side effect of limiting the amount of memory available for the 1:1
kernel pagetable allocation.

This patch reverts the x86_32 part of the original patch.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1658,6 +1658,11 @@ static __init void xen_map_identity_earl
 		for (pteidx = 0; pteidx < PTRS_PER_PTE; pteidx++, pfn++) {
 			pte_t pte;
 
+#ifdef CONFIG_X86_32
+			if (pfn > max_pfn_mapped)
+				max_pfn_mapped = pfn;
+#endif
+
 			if (!pte_none(pte_page[pteidx]))
 				continue;
 
@@ -1770,7 +1775,9 @@ __init pgd_t *xen_setup_kernel_pagetable
 {
 	pmd_t *kernel_pmd;
 
-	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->mfn_list));
+	max_pfn_mapped = PFN_DOWN(__pa(xen_start_info->pt_base) +
+				  xen_start_info->nr_pt_frames * PAGE_SIZE +
+				  512*1024);
 
 	kernel_pmd = m2v(pgd[KERNEL_PGD_BOUNDARY].pgd);
 	memcpy(level2_kernel_pgt, kernel_pmd, sizeof(pmd_t) * PTRS_PER_PMD);


