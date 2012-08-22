Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab2HVKtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:49:33 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:47106 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab2HVKta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:49:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,808,1336348800"; 
   d="scan'208";a="14122906"
Date: Wed, 22 Aug 2012 11:48:40 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "JBeulich@suse.com" <JBeulich@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: Q:pt_base in COMPAT mode offset by two pages. Was:Re: [Xen-devel]
 [PATCH 02/11] xen/x86: Use memblock_reserve for sensitive areas.
In-Reply-To: <20120821190317.GA13035@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208221146230.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-3-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1208171835010.15568@kaball.uk.xensource.com> <20120820141305.GA2713@phenom.dumpdata.com>
 <20120821172732.GA23715@phenom.dumpdata.com> <20120821190317.GA13035@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Tue, Aug 21, 2012 at 01:27:32PM -0400, Konrad Rzeszutek Wilk wrote:
> > On Mon, Aug 20, 2012 at 10:13:05AM -0400, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Aug 17, 2012 at 06:35:12PM +0100, Stefano Stabellini wrote:
> > > > On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> > > > > instead of a big memblock_reserve. This way we can be more
> > > > > selective in freeing regions (and it also makes it easier
> > > > > to understand where is what).
> > > > > 
> > > > > [v1: Move the auto_translate_physmap to proper line]
> > > > > [v2: Per Stefano suggestion add more comments]
> > > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > 
> > > > much better now!
> > > 
> > > Thought interestingly enough it breaks 32-bit dom0s (and only dom0s).
> > > Will have a revised patch posted shortly.
> > 
> > Jan, I thought something odd. Part of this code replaces this:
> > 
> > 	memblock_reserve(__pa(xen_start_info->mfn_list),
> > 		xen_start_info->pt_base - xen_start_info->mfn_list);
> > 
> > with a more region-by-region area. What I found out that if I boot this
> > as 32-bit guest with a 64-bit hypervisor the xen_start_info->pt_base is
> > actually wrong.
> > 
> > Specifically this is what bootup says:
> > 
> > (good working case - 32bit hypervisor with 32-bit dom0):
> > (XEN)  Loaded kernel: c1000000->c1a23000
> > (XEN)  Init. ramdisk: c1a23000->cf730e00
> > (XEN)  Phys-Mach map: cf731000->cf831000
> > (XEN)  Start info:    cf831000->cf83147c
> > (XEN)  Page tables:   cf832000->cf8b5000
> > (XEN)  Boot stack:    cf8b5000->cf8b6000
> > (XEN)  TOTAL:         c0000000->cfc00000
> > 
> > [    0.000000] PT: cf832000 (f832000)
> > [    0.000000] Reserving PT: f832000->f8b5000
> > 
> > And with a 64-bit hypervisor:
> > 
> > XEN) VIRTUAL MEMORY ARRANGEMENT:
> > (XEN)  Loaded kernel: 00000000c1000000->00000000c1a23000
> > (XEN)  Init. ramdisk: 00000000c1a23000->00000000cf730e00
> > (XEN)  Phys-Mach map: 00000000cf731000->00000000cf831000
> > (XEN)  Start info:    00000000cf831000->00000000cf8314b4
> > (XEN)  Page tables:   00000000cf832000->00000000cf8b6000
> > (XEN)  Boot stack:    00000000cf8b6000->00000000cf8b7000
> > (XEN)  TOTAL:         00000000c0000000->00000000cfc00000
> > (XEN)  ENTRY ADDRESS: 00000000c16bb22c
> > 
> > [    0.000000] PT: cf834000 (f834000)
> > [    0.000000] Reserving PT: f834000->f8b8000
> > 
> > So the pt_base is offset by two pages. And looking at c/s 13257
> > its not clear to me why this two page offset was added?
> > 
> > The toolstack works fine - so launching 32-bit guests either
> > under a 32-bit hypervisor or 64-bit works fine:
> > ] domainbuilder: detail: xc_dom_alloc_segment:   page tables  : 0xcf805000 -> 0xcf885000  (pfn 0xf805 + 0x80 pages)
> > [    0.000000] PT: cf805000 (f805000)
> > 
> 
> And this patch on top of the others fixes this..
> 
> 
> >From 806c312e50f122c47913145cf884f53dd09d9199 Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Tue, 21 Aug 2012 14:31:24 -0400
> Subject: [PATCH] xen/x86: Workaround 64-bit hypervisor and 32-bit initial
>  domain.
> 
> If a 64-bit hypervisor is booted with a 32-bit initial domain,
> the hypervisor deals with the initial domain as "compat" and
> does some extra adjustments (like pagetables are 4 bytes instead
> of 8). It also adjusts the xen_start_info->pt_base incorrectly.
> 
> When booted with a 32-bit hypervisor (32-bit initial domain):
> ..
> (XEN)  Start info:    cf831000->cf83147c
> (XEN)  Page tables:   cf832000->cf8b5000
> ..
> [    0.000000] PT: cf832000 (f832000)
> [    0.000000] Reserving PT: f832000->f8b5000
> 
> And with a 64-bit hypervisor:
> (XEN)  Start info:    00000000cf831000->00000000cf8314b4
> (XEN)  Page tables:   00000000cf832000->00000000cf8b6000
> 
> [    0.000000] PT: cf834000 (f834000)
> [    0.000000] Reserving PT: f834000->f8b8000
> 
> To deal with this, we keep keep track of the highest physical
> address we have reserved via memblock_reserve. If that address
> does not overlap with pt_base, we have a gap which we reserve.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |   30 +++++++++++++++++++++---------
>  1 files changed, 21 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e532eb5..511f92d 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1002,19 +1002,24 @@ static int xen_write_msr_safe(unsigned int msr, unsigned low, unsigned high)
>   * If the MFN is not in the m2p (provided to us by the hypervisor) this
>   * function won't do anything. In practice this means that the XenBus
>   * MFN won't be available for the initial domain. */
> -static void __init xen_reserve_mfn(unsigned long mfn)
> +static unsigned long __init xen_reserve_mfn(unsigned long mfn)
>  {
> -	unsigned long pfn;
> +	unsigned long pfn, end_pfn = 0;
>  
>  	if (!mfn)
> -		return;
> +		return end_pfn;
> +
>  	pfn = mfn_to_pfn(mfn);
> -	if (phys_to_machine_mapping_valid(pfn))
> -		memblock_reserve(PFN_PHYS(pfn), PAGE_SIZE);
> +	if (phys_to_machine_mapping_valid(pfn)) {
> +		end_pfn = PFN_PHYS(pfn) + PAGE_SIZE;
> +		memblock_reserve(PFN_PHYS(pfn), end_pfn);
> +	}
> +	return end_pfn;
>  }
>  static void __init xen_reserve_internals(void)
>  {
>  	unsigned long size;
> +	unsigned long last_phys = 0;
>  
>  	if (!xen_pv_domain())
>  		return;
> @@ -1022,12 +1027,13 @@ static void __init xen_reserve_internals(void)
>  	/* xen_start_info does not exist in the M2P, hence can't use
>  	 * xen_reserve_mfn. */
>  	memblock_reserve(__pa(xen_start_info), PAGE_SIZE);
> +	last_phys = __pa(xen_start_info) + PAGE_SIZE;
>  
> -	xen_reserve_mfn(PFN_DOWN(xen_start_info->shared_info));
> -	xen_reserve_mfn(xen_start_info->store_mfn);
> +	last_phys = max(xen_reserve_mfn(PFN_DOWN(xen_start_info->shared_info)), last_phys);
> +	last_phys = max(xen_reserve_mfn(xen_start_info->store_mfn), last_phys);
>  
>  	if (!xen_initial_domain())
> -		xen_reserve_mfn(xen_start_info->console.domU.mfn);
> +		last_phys = max(xen_reserve_mfn(xen_start_info->console.domU.mfn), last_phys);
>  
>  	if (xen_feature(XENFEAT_auto_translated_physmap))
>  		return;
> @@ -1043,8 +1049,14 @@ static void __init xen_reserve_internals(void)
>  	 * a lot (and call memblock_reserve for each PAGE), so lets just use
>  	 * the easy way and reserve it wholesale. */
>  	memblock_reserve(__pa(xen_start_info->mfn_list), size);
> -
> +	last_phys = max(__pa(xen_start_info->mfn_list) + size, last_phys);
>  	/* The pagetables are reserved in mmu.c */
> +
> +	/* Under 64-bit hypervisor with a 32-bit domain, the hypervisor
> +	 * offsets the pt_base by two pages. Hence the reservation that is done
> +	 * in mmu.c misses two pages. We correct it here if we detect this. */
> +	if (last_phys < __pa(xen_start_info->pt_base))
> +		memblock_reserve(last_phys, __pa(xen_start_info->pt_base) - last_phys);
>  }

What are these two pages used for? They are not documented in xen.h, why
should we reserve them?

After all we still have:

memblock_reserve(PFN_PHYS(pt_base), (pt_end - pt_base) * PAGE_SIZE);

that should protect what we are interested in anyway...
