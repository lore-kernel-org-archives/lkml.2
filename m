Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933249Ab2HVTFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:05:31 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64201 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab2HVTFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:05:24 -0400
Date: Wed, 22 Aug 2012 14:55:19 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Q:pt_base in COMPAT mode offset by two pages.
 Was:Re: [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
Message-ID: <20120822185519.GA29609@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
 <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com>
 <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com>
 <20120821190317.GA13035@phenom.dumpdata.com>
 <50351DEF020000780009702A@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50351DEF020000780009702A@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 04:59:11PM +0100, Jan Beulich wrote:
> >>> On 21.08.12 at 21:03, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > On Tue, Aug 21, 2012 at 01:27:32PM -0400, Konrad Rzeszutek Wilk wrote:
> >> On Mon, Aug 20, 2012 at 10:13:05AM -0400, Konrad Rzeszutek Wilk wrote:
> >> > On Fri, Aug 17, 2012 at 06:35:12PM +0100, Stefano Stabellini wrote:
> >> > > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> >> > > > instead of a big memblock_reserve. This way we can be more
> >> > > > selective in freeing regions (and it also makes it easier
> >> > > > to understand where is what).
> >> > > > 
> >> > > > [v1: Move the auto_translate_physmap to proper line]
> >> > > > [v2: Per Stefano suggestion add more comments]
> >> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> > > 
> >> > > much better now!
> >> > 
> >> > Thought interestingly enough it breaks 32-bit dom0s (and only dom0s).
> >> > Will have a revised patch posted shortly.
> >> 
> >> Jan, I thought something odd. Part of this code replaces this:
> >> 
> >> 	memblock_reserve(__pa(xen_start_info->mfn_list),
> >> 		xen_start_info->pt_base - xen_start_info->mfn_list);
> >> 
> >> with a more region-by-region area. What I found out that if I boot this
> >> as 32-bit guest with a 64-bit hypervisor the xen_start_info->pt_base is
> >> actually wrong.
> >> 
> >> Specifically this is what bootup says:
> >> 
> >> (good working case - 32bit hypervisor with 32-bit dom0):
> >> (XEN)  Loaded kernel: c1000000->c1a23000
> >> (XEN)  Init. ramdisk: c1a23000->cf730e00
> >> (XEN)  Phys-Mach map: cf731000->cf831000
> >> (XEN)  Start info:    cf831000->cf83147c
> >> (XEN)  Page tables:   cf832000->cf8b5000
> >> (XEN)  Boot stack:    cf8b5000->cf8b6000
> >> (XEN)  TOTAL:         c0000000->cfc00000
> >> 
> >> [    0.000000] PT: cf832000 (f832000)
> >> [    0.000000] Reserving PT: f832000->f8b5000
> >> 
> >> And with a 64-bit hypervisor:
> >> 
> >> XEN) VIRTUAL MEMORY ARRANGEMENT:
> >> (XEN)  Loaded kernel: 00000000c1000000->00000000c1a23000
> >> (XEN)  Init. ramdisk: 00000000c1a23000->00000000cf730e00
> >> (XEN)  Phys-Mach map: 00000000cf731000->00000000cf831000
> >> (XEN)  Start info:    00000000cf831000->00000000cf8314b4
> >> (XEN)  Page tables:   00000000cf832000->00000000cf8b6000
> >> (XEN)  Boot stack:    00000000cf8b6000->00000000cf8b7000
> >> (XEN)  TOTAL:         00000000c0000000->00000000cfc00000
> >> (XEN)  ENTRY ADDRESS: 00000000c16bb22c
> >> 
> >> [    0.000000] PT: cf834000 (f834000)
> >> [    0.000000] Reserving PT: f834000->f8b8000
> >> 
> >> So the pt_base is offset by two pages. And looking at c/s 13257
> >> its not clear to me why this two page offset was added?
> 
> Actually, the adjustment turns out to be correct: The page
> tables for a 32-on-64 dom0 get allocated in the order "first L1",
> "first L2", "first L3", so the offset to the page table base is
> indeed 2. When reading xen/include/public/xen.h's comment
> very strictly, this is not a violation (since there nothing is said
> that the first thing in the page table space is pointed to by
> pt_base; I admit that this seems to be implied though, namely
> do I think that it is implied that the page table space is the
> range [pt_base, pt_base + nt_pt_frames), whereas that
> range here indeed is [pt_base - 2, pt_base - 2 + nt_pt_frames),
> which - without a priori knowledge - the kernel would have
> difficulty to figure out).
> 
> Below is a debugging patch I used to see the full picture, if you
> want to double check.

Thinking of just sticking this patch then:

>From 9aa58784b163ee435ff5596cf3ec059b57ab85e1 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 22 Aug 2012 13:00:10 -0400
Subject: [PATCH] Revert "xen/x86: Workaround 64-bit hypervisor and 32-bit
 initial domain." and "xen/x86: Use memblock_reserve for
 sensitive areas."

This reverts commit 806c312e50f122c47913145cf884f53dd09d9199 and
commit 59b294403e9814e7c1154043567f0d71bac7a511.

And also documents setup.c and why we want to do it that way, which
is that we tried to make the the memblock_reserve more selective so
that it would be clear what region is reserved. Sadly we ran
in the problem wherein on a 64-bit hypervisor with a 32-bit
initial domain, the pt_base has the cr3 value which is not
neccessarily where the pagetable starts! As Jan put it: "
Actually, the adjustment turns out to be correct: The page
tables for a 32-on-64 dom0 get allocated in the order "first L1",
"first L2", "first L3", so the offset to the page table base is
indeed 2. When reading xen/include/public/xen.h's comment
very strictly, this is not a violation (since there nothing is said
that the first thing in the page table space is pointed to by
pt_base; I admit that this seems to be implied though, namely
do I think that it is implied that the page table space is the
range [pt_base, pt_base + nt_pt_frames), whereas that
range here indeed is [pt_base - 2, pt_base - 2 + nt_pt_frames),
which - without a priori knowledge - the kernel would have
difficulty to figure out)." - so lets just fall back to the
easy way and reserve the whole region.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |   60 ----------------------------------------------
 arch/x86/xen/p2m.c       |    5 ----
 arch/x86/xen/setup.c     |   27 ++++++++++++++++++++
 3 files changed, 27 insertions(+), 65 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index c1e940d..d87a038 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -998,66 +998,7 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
 
 	return ret;
 }
-/*
- * If the MFN is not in the m2p (provided to us by the hypervisor) this
- * function won't do anything. In practice this means that the XenBus
- * MFN won't be available for the initial domain. */
-static unsigned long __init xen_reserve_mfn(unsigned long mfn)
-{
-	unsigned long pfn, end_pfn = 0;
-
-	if (!mfn)
-		return end_pfn;
-
-	pfn = mfn_to_pfn(mfn);
-	if (phys_to_machine_mapping_valid(pfn)) {
-		end_pfn = PFN_PHYS(pfn) + PAGE_SIZE;
-		memblock_reserve(PFN_PHYS(pfn), end_pfn);
-	}
-	return end_pfn;
-}
-static void __init xen_reserve_internals(void)
-{
-	unsigned long size;
-	unsigned long last_phys = 0;
-
-	if (!xen_pv_domain())
-		return;
-
-	/* xen_start_info does not exist in the M2P, hence can't use
-	 * xen_reserve_mfn. */
-	memblock_reserve(__pa(xen_start_info), PAGE_SIZE);
-	last_phys = __pa(xen_start_info) + PAGE_SIZE;
-
-	last_phys = max(xen_reserve_mfn(PFN_DOWN(xen_start_info->shared_info)), last_phys);
-	last_phys = max(xen_reserve_mfn(xen_start_info->store_mfn), last_phys);
 
-	if (!xen_initial_domain())
-		last_phys = max(xen_reserve_mfn(xen_start_info->console.domU.mfn), last_phys);
-
-	if (xen_feature(XENFEAT_auto_translated_physmap))
-		return;
-
-	/*
-	 * ALIGN up to compensate for the p2m_page pointing to an array that
-	 * can partially filled (look in xen_build_dynamic_phys_to_machine).
-	 */
-
-	size = PAGE_ALIGN(xen_start_info->nr_pages * sizeof(unsigned long));
-
-	/* We could use xen_reserve_mfn here, but would end up looping quite
-	 * a lot (and call memblock_reserve for each PAGE), so lets just use
-	 * the easy way and reserve it wholesale. */
-	memblock_reserve(__pa(xen_start_info->mfn_list), size);
-	last_phys = max(__pa(xen_start_info->mfn_list) + size, last_phys);
-	/* The pagetables are reserved in mmu.c */
-
-	/* Under 64-bit hypervisor with a 32-bit domain, the hypervisor
-	 * offsets the pt_base by two pages. Hence the reservation that is done
-	 * in mmu.c misses two pages. We correct it here if we detect this. */
-	if (last_phys < __pa(xen_start_info->pt_base))
-		memblock_reserve(last_phys, __pa(xen_start_info->pt_base) - last_phys);
-}
 void xen_setup_shared_info(void)
 {
 	if (!xen_feature(XENFEAT_auto_translated_physmap)) {
@@ -1418,7 +1359,6 @@ asmlinkage void __init xen_start_kernel(void)
 	xen_raw_console_write("mapping kernel into physical memory\n");
 	xen_setup_kernel_pagetable((pgd_t *)xen_start_info->pt_base, xen_start_info->nr_pages);
 
-	xen_reserve_internals();
 	/* Allocate and initialize top and mid mfn levels for p2m structure */
 	xen_build_mfn_list_list();
 
diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 95c3ea2..c3e9291 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -388,11 +388,6 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	}
 
 	m2p_override_init();
-
-	/* NOTE: We cannot call memblock_reserve here for the mfn_list as there
-	 * isn't enough pieces to make it work (for one - we are still using the
-	 * Xen provided pagetable). Do it later in xen_reserve_internals.
-	 */
 }
 #ifdef CONFIG_X86_64
 #include <linux/bootmem.h>
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 9efca75..740517b 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -424,6 +424,33 @@ char * __init xen_memory_setup(void)
 	e820_add_region(ISA_START_ADDRESS, ISA_END_ADDRESS - ISA_START_ADDRESS,
 			E820_RESERVED);
 
+	/*
+	 * Reserve Xen bits:
+	 *  - mfn_list
+	 *  - xen_start_info
+	 * See comment above "struct start_info" in <xen/interface/xen.h>
+	 * We tried to make the the memblock_reserve more selective so
+	 * that it would be clear what region is reserved. Sadly we ran
+	 * in the problem wherein on a 64-bit hypervisor with a 32-bit
+	 * initial domain, the pt_base has the cr3 value which is not
+	 * neccessarily where the pagetable starts! As Jan put it: "
+	 * Actually, the adjustment turns out to be correct: The page
+	 * tables for a 32-on-64 dom0 get allocated in the order "first L1",
+	 * "first L2", "first L3", so the offset to the page table base is
+	 * indeed 2. When reading xen/include/public/xen.h's comment
+	 * very strictly, this is not a violation (since there nothing is said
+	 * that the first thing in the page table space is pointed to by
+	 * pt_base; I admit that this seems to be implied though, namely
+	 * do I think that it is implied that the page table space is the
+	 * range [pt_base, pt_base + nt_pt_frames), whereas that
+	 * range here indeed is [pt_base - 2, pt_base - 2 + nt_pt_frames),
+	 * which - without a priori knowledge - the kernel would have
+	 * difficulty to figure out)." - so lets just fall back to the
+	 * easy way and reserve the whole region.
+	 */
+	memblock_reserve(__pa(xen_start_info->mfn_list),
+			 xen_start_info->pt_base - xen_start_info->mfn_list);
+
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 
 	return "Xen";
-- 
1.7.7.6

