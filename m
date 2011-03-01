Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193Ab1CAVsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 16:48:01 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:55372 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab1CAVsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 16:48:00 -0500
Message-ID: <4D6D6980.7060304@kernel.org>
Date: Tue, 01 Mar 2011 13:47:44 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4D6D6989.0048,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2011 09:21 AM, Stefano Stabellini wrote:
> Yinghai Lu,
> while testing tip/x86/mm on Xen I found out that the commit "x86-64, mm:
> Put early page table high" reliably crashes Linux at boot.
> The reason is well explained by the commit message of
> fef5ba797991f9335bcfc295942b684f9bf613a1:
> 
> "Xen requires that all pages containing pagetable entries to be mapped
> read-only.  If pages used for the initial pagetable are already mapped
> then we can change the mapping to RO.  However, if they are initially
> unmapped, we need to make sure that when they are later mapped, they
> are also mapped RO.
> 
> We do this by knowing that the kernel pagetable memory is pre-allocated
> in the range e820_table_start - e820_table_end, so any pfn within this
> range should be mapped read-only.  However, the pagetable setup code
> early_ioremaps the pages to write their entries, so we must make sure
> that mappings created in the early_ioremap fixmap area are mapped RW.
> (Those mappings are removed before the pages are presented to Xen
> as pagetable pages.)"
> 
> In other words mask_rw_pte (called by xen_set_pte_init) should mark RO
> the already existing pagetable pages (like the ones belonging to the
> initial mappings), while it should mark RW the new pages not yet hooked
> into the pagetable.  This is what the following lines used to achieve,
> but don't anymore:
> 
>     /*
> 	 * If the new pfn is within the range of the newly allocated
> 	 * kernel pagetable, and it isn't being mapped into an
> 	 * early_ioremap fixmap slot, make sure it is RO.
> 	 */
>     if (!is_early_ioremap_ptep(ptep) &&
> 	    pfn >= pgt_buf_start && pfn < pgt_buf_end)
> 		pte = pte_wrprotect(pte);
> 
> Unfortunately now we map the already existing initial pagetable pages a
> second time and the new zeroed pages using map_low_page, so we are
> unable to distinguish between the two.
> 
> Can we go back to the previous way of accessing pagetable pages from
> kernel_physical_mapping_init, while keeping the new pagetable allocation
> strategy? It seems to me that the introduction of map_low_page is not
> actually required, is it? In that case we could just revert that bit...
> (appended partial revert example).

We do need map_low_page ( BTW, that name is totally misleading...)

the reason is we put page_table high and at that time is not under max_pfn_mapped. (aka not mapped).

So have to use 
	adr = early_memremap(phys & PAGE_MASK, PAGE_SIZE);
to early map it and Read/Write to it.

Thanks

Yinghai
