Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab1CGPsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:48:06 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:4326 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1CGPsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:48:01 -0500
X-IronPort-AV: E=Sophos;i="4.62,277,1297036800"; 
   d="scan'208";a="4653898"
Date: Mon, 7 Mar 2011 15:47:43 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
In-Reply-To: <4D6D6980.7060304@kernel.org>
Message-ID: <alpine.DEB.2.00.1103071527500.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop> <4D6D6980.7060304@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Yinghai Lu wrote:
> On 03/01/2011 09:21 AM, Stefano Stabellini wrote:
> > Yinghai Lu,
> > while testing tip/x86/mm on Xen I found out that the commit "x86-64, mm:
> > Put early page table high" reliably crashes Linux at boot.
> > The reason is well explained by the commit message of
> > fef5ba797991f9335bcfc295942b684f9bf613a1:
> > 
> > "Xen requires that all pages containing pagetable entries to be mapped
> > read-only.  If pages used for the initial pagetable are already mapped
> > then we can change the mapping to RO.  However, if they are initially
> > unmapped, we need to make sure that when they are later mapped, they
> > are also mapped RO.
> > 
> > We do this by knowing that the kernel pagetable memory is pre-allocated
> > in the range e820_table_start - e820_table_end, so any pfn within this
> > range should be mapped read-only.  However, the pagetable setup code
> > (Those mappings are removed before the pages are presented to Xen
> > as pagetable pages.)"
> > 
> > In other words mask_rw_pte (called by xen_set_pte_init) should mark RO
> > the already existing pagetable pages (like the ones belonging to the
> > initial mappings), while it should mark RW the new pages not yet hooked
> > into the pagetable.  This is what the following lines used to achieve,
> > but don't anymore:
> > 
> >     /*
> > 	 * If the new pfn is within the range of the newly allocated
> > 	 * kernel pagetable, and it isn't being mapped into an
> > 	 */
> > 	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
> > 		pte = pte_wrprotect(pte);
> > 
> > Unfortunately now we map the already existing initial pagetable pages a
> > second time and the new zeroed pages using map_low_page, so we are
> > unable to distinguish between the two.
> > 
> > Can we go back to the previous way of accessing pagetable pages from
> > kernel_physical_mapping_init, while keeping the new pagetable allocation
> > strategy? It seems to me that the introduction of map_low_page is not
> > actually required, is it? In that case we could just revert that bit...
> > (appended partial revert example).
> 
> We do need map_low_page ( BTW, that name is totally misleading...)
> 
> the reason is we put page_table high and at that time is not under max_pfn_mapped. (aka not mapped).
> 
> So have to use 
> 	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
> to early map it and Read/Write to it.

As you might already know from my other email few days ago, I have found
a solution to this problem modifying only Xen specific code.
However I went back to this because I want to be sure that the patch is
the correct solution rather than a workaround.

It seems to me that only pagetable pages freshly allocated with
alloc_low_page needs to be mapped because initial pagetable pages are
under max_pfn_mapped.
Considering that kernel_physical_mapping_init doesn't go through the
same pagetable page twice, it is never the case that we map_low_page
anything but initial pagetable pages that are under max_pfn_mapped
anyway.
For example this is what happens on my machine:


[    0.000000] initial memory mapped : 0 - 024be000
[    0.000000] init_memory_mapping: 0000000000000000-00000000cffc2000
[    0.000000]  0000000000 - 00cffc2000 page 4k
[    0.000000] kernel direct mapping tables up to cffc2000 @ cf93d000-cffc2000
[    0.000000] DEBUG map low page(2004000, 00001000)
[    0.000000] DEBUG map low page(2008000, 00001000)
[    0.000000] DEBUG map low page(2c62000, 00001000)
[    0.000000] DEBUG map low page(2c65000, 00001000)
[    0.000000] DEBUG map low page(2c66000, 00001000)
[    0.000000] DEBUG map low page(2c67000, 00001000)
[    0.000000] DEBUG map low page(2c68000, 00001000)
[    0.000000] DEBUG map low page(2c69000, 00001000)
[    0.000000] DEBUG map low page(2c6a000, 00001000)
[    0.000000] DEBUG map low page(2c6b000, 00001000)
[    0.000000] DEBUG map low page(2c6c000, 00001000)
[    0.000000] DEBUG map low page(2c6d000, 00001000)
[    0.000000] DEBUG map low page(2c6e000, 00001000)
[    0.000000] DEBUG map low page(2c6f000, 00001000)
[    0.000000] DEBUG map low page(2c70000, 00001000)
[    0.000000] DEBUG map low page(2c71000, 00001000)
[    0.000000] DEBUG map low page(2c72000, 00001000)
[    0.000000] DEBUG map low page(2c73000, 00001000)
[    0.000000] DEBUG map low page(2c74000, 00001000)
[    0.000000] DEBUG map low page(2c75000, 00001000)
[    0.000000] DEBUG map low page(2c76000, 00001000)
[    0.000000] DEBUG map low page(2c77000, 00001000)
[    0.000000] DEBUG map low page(2c78000, 00001000)
[    0.000000] DEBUG map low page(2c79000, 00001000)
[    0.000000] DEBUG map low page(2c7a000, 00001000)
[    0.000000] DEBUG map low page(2c7b000, 00001000)
[    0.000000] DEBUG map low page(239a000, 00001000)
[    0.000000] DEBUG map low page(239b000, 00001000)
[    0.000000] DEBUG map low page(239c000, 00001000)
[    0.000000] DEBUG map low page(239d000, 00001000)
[    0.000000] DEBUG alloc low page(cf93d000, 00001000)
[    0.000000] DEBUG alloc low page(cf93e000, 00001000)
[    0.000000] DEBUG alloc low page(cf93f000, 00001000)
[    0.000000] DEBUG alloc low page(cf940000, 00001000)
[    0.000000] DEBUG alloc low page(cf941000, 00001000)
[    0.000000] DEBUG alloc low page(cf942000, 00001000)
[    0.000000] DEBUG alloc low page(cf943000, 00001000)
[    0.000000] DEBUG alloc low page(cf944000, 00001000)
[    0.000000] DEBUG alloc low page(cf945000, 00001000)
[    0.000000] DEBUG alloc low page(cf946000, 00001000)
[    0.000000] DEBUG alloc low page(cf947000, 00001000)
[    0.000000] DEBUG alloc low page(cf948000, 00001000)
[    0.000000] DEBUG alloc low page(cf949000, 00001000)
[    0.000000] DEBUG alloc low page(cf94a000, 00001000)
[    0.000000] DEBUG alloc low page(cf94b000, 00001000)
[    0.000000] DEBUG alloc low page(cf94c000, 00001000)
[    0.000000] DEBUG alloc low page(cf94d000, 00001000)
[    0.000000] DEBUG alloc low page(cf94e000, 00001000)
[    0.000000] DEBUG alloc low page(cf94f000, 00001000)
[    0.000000] DEBUG alloc low page(cf950000, 00001000)
[    0.000000] DEBUG alloc low page(cf951000, 00001000)
[    0.000000] DEBUG alloc low page(cf952000, 00001000)
[    0.000000] DEBUG alloc low page(cf953000, 00001000)
[    0.000000] DEBUG alloc low page(cf954000, 00001000)
[    0.000000] DEBUG alloc low page(cf955000, 00001000)
[    0.000000] DEBUG alloc low page(cf956000, 00001000)
[    0.000000] DEBUG alloc low page(cf957000, 00001000)
[    0.000000] DEBUG alloc low page(cf958000, 00001000)
[    0.000000] DEBUG alloc low page(cf959000, 00001000)
[    0.000000] DEBUG alloc low page(cf95a000, 00001000)
[    0.000000] DEBUG alloc low page(cf95b000, 00001000)
[    0.000000] DEBUG alloc low page(cf95c000, 00001000)
[    0.000000] DEBUG alloc low page(cf95d000, 00001000)
[    0.000000] DEBUG alloc low page(cf95e000, 00001000)
[    0.000000] DEBUG alloc low page(cf95f000, 00001000)
[    0.000000] DEBUG alloc low page(cf960000, 00001000)
[    0.000000] DEBUG alloc low page(cf961000, 00001000)
[    0.000000] DEBUG alloc low page(cf962000, 00001000)
[    0.000000] DEBUG alloc low page(cf963000, 00001000)
[    0.000000] DEBUG alloc low page(cf964000, 00001000)
[    0.000000] DEBUG alloc low page(cf965000, 00001000)


if this is the case the introduction of map_low_page is unnecessary and
actually makes the kernel map pages that are already mapped anyway.
Am I correct?
