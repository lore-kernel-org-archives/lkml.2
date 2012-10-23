Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933384Ab2JWS0A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:26:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39131 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933271Ab2JWSYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:24:32 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        stefano.stabellini@eu.citrix.com, Ian.Campbell@citrix.com,
        mukesh.rathor@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 08/10] xen/e820: Coalesce the PVH release/populate logic in the generic case.
Date: Tue, 23 Oct 2012 14:12:09 -0400
Message-Id: <1351015931-16991-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
References: <1351015931-16991-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Squash the PVH specific case in xen_set_identity_and_release_chunk
and make the 'if (PVH..)' case within xen_do_chunk and
xen_set_identity_and_release_chunk function.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: Remove the extra xlated_phys since it is no longer in use]
---
 arch/x86/xen/setup.c |   60 +++++++++++++++++++------------------------------
 1 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 8cce47b..78c5622 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -114,9 +114,15 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 
 		if (release) {
 			/* Make sure pfn exists to start with */
-			if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
+			if (mfn == INVALID_P2M_ENTRY || (!xlated_phys && (mfn_to_pfn(mfn) != pfn)))
 				continue;
 			frame = mfn;
+			/* The hypercall PHYSDEVOP_map_iomem to release memory has already
+			 * happend, so we just do a nop here. */
+			if (xlated_phys) {
+				len++;
+				continue;
+			}
 		} else {
 			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
 				continue;
@@ -219,15 +225,24 @@ static void __init xen_set_identity_and_release_chunk(
 {
 	unsigned long pfn;
 
+	/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
+	 * are released as part of this 1:1 mapping hypercall back to the dom heap.
+	 * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
+	 */
+	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
+
 	/*
 	 * If the PFNs are currently mapped, the VA mapping also needs
 	 * to be updated to be 1:1.
 	 */
-	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++)
-		(void)HYPERVISOR_update_va_mapping(
-			(unsigned long)__va(pfn << PAGE_SHIFT),
-			mfn_pte(pfn, PAGE_KERNEL_IO), 0);
-
+	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {
+		if (xlated_phys)
+			xen_set_clr_mmio_pvh_pte(pfn, pfn, 1 /* one pfn */, 1 /* add mapping */);
+		else
+			(void)HYPERVISOR_update_va_mapping(
+				(unsigned long)__va(pfn << PAGE_SHIFT),
+				mfn_pte(pfn, PAGE_KERNEL_IO), 0);
+	}
 	if (start_pfn < nr_pages)
 		*released += xen_release_chunk(
 			start_pfn, min(end_pfn, nr_pages));
@@ -235,27 +250,6 @@ static void __init xen_set_identity_and_release_chunk(
 	*identity += set_phys_range_identity(start_pfn, end_pfn);
 }
 
-/* For PVH, the pfns [0..MAX] are mapped to mfn's in the EPT/NPT. The mfns
- * are released as part of this 1:1 mapping hypercall back to the dom heap.
- * Also, we map the entire IO space, ie, beyond max_pfn_mapped.
- */
-static void __init xen_pvh_identity_map_chunk(unsigned long start_pfn,
-		unsigned long end_pfn, unsigned long *released,
-		unsigned long *identity, unsigned long max_pfn)
-{
-	unsigned long pfn;
-	int numpfns = 1, add_mapping = 1;
-
-	for (pfn = start_pfn; pfn < end_pfn; pfn++)
-		xen_set_clr_mmio_pvh_pte(pfn, pfn, numpfns, add_mapping);
-
-	if (start_pfn <= max_pfn) {
-		unsigned long end = min(max_pfn_mapped, end_pfn);
-		*released += end - start_pfn;
-	}
-	*identity += end_pfn - start_pfn;
-}
-
 static unsigned long __init xen_set_identity_and_release(
 	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
 {
@@ -264,7 +258,6 @@ static unsigned long __init xen_set_identity_and_release(
 	unsigned long identity = 0;
 	const struct e820entry *entry;
 	int i;
-	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
 
 	/*
 	 * Combine non-RAM regions and gaps until a RAM region (or the
@@ -286,17 +279,10 @@ static unsigned long __init xen_set_identity_and_release(
 			if (entry->type == E820_RAM)
 				end_pfn = PFN_UP(entry->addr);
 
-			if (start_pfn < end_pfn) {
-				if (xlated_phys) {
-					xen_pvh_identity_map_chunk(start_pfn,
-						end_pfn, &released, &identity,
-						nr_pages);
-				} else {
-					xen_set_identity_and_release_chunk(
+			if (start_pfn < end_pfn)
+				xen_set_identity_and_release_chunk(
 						start_pfn, end_pfn, nr_pages,
 						&released, &identity);
-				}
-			}
 			start = end;
 		}
 	}
-- 
1.7.7.6

