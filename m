Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2ECPPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 11:15:49 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:32867 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751167Ab2ECPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 11:15:47 -0400
Message-ID: <4FA2A11E.1060907@cantab.net>
Date: Thu, 03 May 2012 16:15:42 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH] auto balloon initial domain and fix dom0_mem=X
 inconsistencies (v5).
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>	<20120501163707.GA8741@phenom.dumpdata.com> <4FA27084.4030005@citrix.com>
In-Reply-To: <4FA27084.4030005@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/12 12:48, David Vrabel wrote:
> On 01/05/12 17:37, Konrad Rzeszutek Wilk wrote:
>> On Mon, Apr 16, 2012 at 01:15:31PM -0400, Konrad Rzeszutek Wilk wrote:
>>> Changelog v5 [since v4]:
>>>  - used populate_physmap, fixed bugs.
>>> [v2-v4: not posted]
>>>  - reworked the code in setup.c to work properly.
>>> [v1: https://lkml.org/lkml/2012/3/30/492]
>>>  - initial patchset
>>
>> One bug I found was that with 'dom0_mem=max:1G' (with and without these
>> patches) I would get a bunch of
>>
>> (XEN) page_alloc.c:1148:d0 Over-allocation for domain 0: 2097153 > 2097152
>> (XEN) memory.c:133:d0 Could not allocate order=0 extent: id=0 memflags=0 (0 of 17)
>>
>> where the (0 of X), sometimes was 1, 2,3,4 or 17 -depending on the machine
>> I ran on it. I figured it out that the difference was in the ACPI tables
>> that are allocated - and that those regions - even though are returned
>> back to the hypervisor, cannot be repopulated. I can't find the actual
>> exact piece of code in the hypervisor to pin-point and say "Aha".
> 
> It was tricky to track down what is going here but I think I see what's
> happening.
> 
> The problem pages (on the system I looked at) were located just before
> the ISA memory region (so PFN < a0) and so they are mapped in the
> bootstrap page tables and have an additional ref so are not immediately
> freed when the page is released.  They do get freed later on, presumably
> when the page tables are swapped over.

It's not the bootstrap page tables but those constructed in
xen_setup_kernel_pagetable() but this has the same effect.

> I think the mapping needs to be removed with
> HYPERVISOR_update_va_mapping() before releasing the page.  This is
> already done for the ISA region in xen_ident_map_ISA().

And here's a patch that does this.  I've not given it a lot of testing.

This is on top of your 8/8 patch and your "xen/setup: Cap amount to
populate based on current tot_pages count." patch is no longer needed.

David

8<---------------------
>From 17900ce942ed34ccc85b8e6fbce392118d95d9d3 Mon Sep 17 00:00:00 2001
From: David Vrabel <david.vrabel@citrix.com>
Date: Thu, 3 May 2012 15:57:00 +0100
Subject: [PATCH] xen: update VA mapping when releasing memory during setup

In xen_memory_setup(), if a page that is being released has a VA
mapping this must also be updated.  Otherwise, the page will be not
released completely -- it will still be referenced in Xen and won't be
freed util the mapping is removed and this prevents it from being
reallocated at a different PFN.

This was already being done for the ISA memory region in
xen_ident_map_ISA() but on many systems this was omitting a few pages
as many systems marked a few pages below the ISA memory region as
reserved in the e820 map.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
---
 arch/x86/xen/enlighten.c |    1 -
 arch/x86/xen/mmu.c       |   23 -----------------------
 arch/x86/xen/setup.c     |   41 ++++++++++++++++++++++++++++++++++-------
 arch/x86/xen/xen-ops.h   |    1 -
 4 files changed, 34 insertions(+), 32 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index a8f8844..ff9a20a 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1306,7 +1306,6 @@ asmlinkage void __init xen_start_kernel(void)
 
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	pgd = xen_setup_kernel_pagetable(pgd, xen_start_info->nr_pages);
-	xen_ident_map_ISA();
 
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index b8e2794..b756d8c 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1929,29 +1929,6 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
 #endif
 }
 
-void __init xen_ident_map_ISA(void)
-{
-	unsigned long pa;
-
-	/*
-	 * If we're dom0, then linear map the ISA machine addresses into
-	 * the kernel's address space.
-	 */
-	if (!xen_initial_domain())
-		return;
-
-	xen_raw_printk("Xen: setup ISA identity maps\n");
-
-	for (pa = ISA_START_ADDRESS; pa < ISA_END_ADDRESS; pa += PAGE_SIZE) {
-		pte_t pte = mfn_pte(PFN_DOWN(pa), PAGE_KERNEL_IO);
-
-		if (HYPERVISOR_update_va_mapping(PAGE_OFFSET + pa, pte, 0))
-			BUG();
-	}
-
-	xen_flush_tlb();
-}
-
 static void __init xen_post_allocator_init(void)
 {
 	pv_mmu_ops.set_pte = xen_set_pte;
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 506a3e6..d5f8714 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -139,6 +139,13 @@ static unsigned long __init xen_do_chunk(unsigned long start,
 
 	return len;
 }
+
+static unsigned long __init xen_release_chunk(unsigned long start,
+					      unsigned long end)
+{
+	return xen_do_chunk(start, end, true);
+}
+
 static unsigned long __init xen_populate_chunk(
 	const struct e820entry *list, size_t map_size,
 	unsigned long max_pfn, unsigned long *last_pfn,
@@ -197,6 +204,29 @@ static unsigned long __init xen_populate_chunk(
 	}
 	return done;
 }
+
+static void __init xen_set_identity_and_release_chunk(
+	unsigned long start_pfn, unsigned long end_pfn, unsigned long nr_pages,
+	unsigned long *released, unsigned long *identity)
+{
+	unsigned long pfn;
+
+	/*
+	 * If the PFNs are currently mapped, the VA mapping also needs
+	 * to be updated to be 1:1.
+	 */
+	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++)
+		(void)HYPERVISOR_update_va_mapping(
+			(unsigned long)__va(pfn << PAGE_SHIFT),
+			mfn_pte(pfn, PAGE_KERNEL_IO), 0);
+
+	if (start_pfn < nr_pages)
+		*released += xen_release_chunk(
+			start_pfn, min(end_pfn, nr_pages));
+
+	*identity += set_phys_range_identity(start_pfn, end_pfn);
+}
+
 static unsigned long __init xen_set_identity_and_release(
 	const struct e820entry *list, size_t map_size, unsigned long nr_pages)
 {
@@ -226,14 +256,11 @@ static unsigned long __init xen_set_identity_and_release(
 			if (entry->type == E820_RAM)
 				end_pfn = PFN_UP(entry->addr);
 
-			if (start_pfn < end_pfn) {
-				if (start_pfn < nr_pages)
-					released += xen_do_chunk(
-						start_pfn, min(end_pfn, nr_pages), true);
+			if (start_pfn < end_pfn)
+				xen_set_identity_and_release_chunk(
+					start_pfn, end_pfn, nr_pages,
+					&released, &identity);
 
-				identity += set_phys_range_identity(
-					start_pfn, end_pfn);
-			}
 			start = end;
 		}
 	}
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index b095739..506fa08 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -28,7 +28,6 @@ void xen_setup_shared_info(void);
 void xen_build_mfn_list_list(void);
 void xen_setup_machphys_mapping(void);
 pgd_t *xen_setup_kernel_pagetable(pgd_t *pgd, unsigned long max_pfn);
-void xen_ident_map_ISA(void);
 void xen_reserve_top(void);
 extern unsigned long xen_max_p2m_pfn;
 
-- 
1.7.2.5
