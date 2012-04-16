Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab2DPRVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:21:49 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:17742 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab2DPRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:20:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/8] xen/setup: Combine the two hypercall functions - since they are quite similar.
Date: Mon, 16 Apr 2012 13:15:39 -0400
Message-Id: <1334596539-18172-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090208.4F8C54EC.0033,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They use the same set of arguments, so it is just the matter
of using the proper hypercall.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/setup.c |   81 ++++++++++++++++++-------------------------------
 1 files changed, 30 insertions(+), 51 deletions(-)

diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index b44d409..506a3e6 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -83,8 +83,8 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
 		__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
 }
 
-static unsigned long __init xen_release_chunk(unsigned long start,
-					      unsigned long end)
+static unsigned long __init xen_do_chunk(unsigned long start,
+					 unsigned long end, bool release)
 {
 	struct xen_memory_reservation reservation = {
 		.address_bits = 0,
@@ -95,60 +95,36 @@ static unsigned long __init xen_release_chunk(unsigned long start,
 	unsigned long pfn;
 	int ret;
 
-	for(pfn = start; pfn < end; pfn++) {
-		unsigned long mfn = pfn_to_mfn(pfn);
-
-		/* Make sure pfn exists to start with */
-		if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
-			continue;
-
-		set_xen_guest_handle(reservation.extent_start, &mfn);
-		reservation.nr_extents = 1;
-
-		ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-					   &reservation);
-		WARN(ret != 1, "Failed to release pfn %lx err=%d\n", pfn, ret);
-		if (ret == 1) {
-			__set_phys_to_machine(pfn, INVALID_P2M_ENTRY);
-			len++;
-		}
-	}
-	if (len)
-		printk(KERN_INFO "Freeing  %lx-%lx pfn range: %lu pages freed\n",
-		       start, end, len);
-
-	return len;
-}
-static unsigned long __init xen_populate_physmap(unsigned long start,
-						 unsigned long end)
-{
-	struct xen_memory_reservation reservation = {
-		.address_bits = 0,
-		.extent_order = 0,
-		.domid        = DOMID_SELF
-	};
-	unsigned long len = 0;
-	int ret;
-
 	for (pfn = start; pfn < end; pfn++) {
 		unsigned long frame;
+		unsigned long mfn = pfn_to_mfn(pfn);
 
-		/* Make sure pfn does not exists to start with */
-		if (pfn_to_mfn(pfn) != INVALID_P2M_ENTRY)
-			continue;
-
-		frame = pfn;
+		if (release) {
+			/* Make sure pfn exists to start with */
+			if (mfn == INVALID_P2M_ENTRY || mfn_to_pfn(mfn) != pfn)
+				continue;
+			frame = mfn;
+		} else {
+			if (mfn != INVALID_P2M_ENTRY)
+				continue;
+			frame = pfn;
+		}
 		set_xen_guest_handle(reservation.extent_start, &frame);
 		reservation.nr_extents = 1;
 
-		ret = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
-		WARN(ret != 1, "Failed to populate pfn %lx err=%d\n", pfn, ret);
+		ret = HYPERVISOR_memory_op(release ? XENMEM_decrease_reservation : XENMEM_populate_physmap,
+					   &reservation);
+		WARN(ret != 1, "Failed to %s pfn %lx err=%d\n",
+		     release ? "release" : "populate", pfn, ret);
+
 		if (ret == 1) {
-			if (!early_set_phys_to_machine(pfn, frame)) {
+			if (!early_set_phys_to_machine(pfn, release ? INVALID_P2M_ENTRY : frame)) {
+				if (release)
+					break;
 				set_xen_guest_handle(reservation.extent_start, &frame);
 				reservation.nr_extents = 1;
 				ret = HYPERVISOR_memory_op(XENMEM_decrease_reservation,
-							&reservation);
+							   &reservation);
 				break;
 			}
 			len++;
@@ -156,8 +132,11 @@ static unsigned long __init xen_populate_physmap(unsigned long start,
 			break;
 	}
 	if (len)
-		printk(KERN_INFO "Populated %lx-%lx pfn range: %lu pages added\n",
-		       start, end, len);
+		printk(KERN_INFO "%s %lx-%lx pfn range: %lu pages %s\n",
+		       release ? "Freeing" : "Populating",
+		       start, end, len,
+		       release ? "freed" : "added");
+
 	return len;
 }
 static unsigned long __init xen_populate_chunk(
@@ -211,7 +190,7 @@ static unsigned long __init xen_populate_chunk(
 		if (credits > capacity)
 			credits = capacity;
 
-		pfns = xen_populate_physmap(dest_pfn, dest_pfn + credits);
+		pfns = xen_do_chunk(dest_pfn, dest_pfn + credits, false);
 		done += pfns;
 		credits_left -= pfns;
 		*last_pfn = (dest_pfn + pfns);
@@ -249,8 +228,8 @@ static unsigned long __init xen_set_identity_and_release(
 
 			if (start_pfn < end_pfn) {
 				if (start_pfn < nr_pages)
-					released += xen_release_chunk(
-						start_pfn, min(end_pfn, nr_pages));
+					released += xen_do_chunk(
+						start_pfn, min(end_pfn, nr_pages), true);
 
 				identity += set_phys_range_identity(
 					start_pfn, end_pfn);
-- 
1.7.7.5

