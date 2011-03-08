Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab1CHRlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 12:41:12 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:7651 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629Ab1CHRlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 12:41:11 -0500
X-IronPort-AV: E=Sophos;i="4.62,285,1297036800"; 
   d="scan'208";a="4679213"
Date: Tue, 8 Mar 2011 17:40:51 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: "x86-64, mm: Put early page table high" causes crash on Xen
In-Reply-To: <AANLkTikmiKvdgzE_G1-w7PBqBf=kD5R5k5QZChHeiDCd@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1103081728300.2968@kaball-desktop>
References: <alpine.DEB.2.00.1103011517280.2917@kaball-desktop> <4D6D6980.7060304@kernel.org> <alpine.DEB.2.00.1103071527500.2968@kaball-desktop> <AANLkTi=aUGdjvtvy81FimMZB5PZNzASXHN0BZHWHUuLs@mail.gmail.com> <alpine.DEB.2.00.1103081203260.2968@kaball-desktop>
 <AANLkTikmiKvdgzE_G1-w7PBqBf=kD5R5k5QZChHeiDCd@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="8323329-1027710972-1299605541=:2968"
Content-ID: <alpine.DEB.2.00.1103081732320.2968@kaball-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--8323329-1027710972-1299605541=:2968
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.1103081732321.2968@kaball-desktop>

On Tue, 8 Mar 2011, Yinghai Lu wrote:
> On Tue, Mar 8, 2011 at 4:14 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> >> > [    0.000000] DEBUG alloc low page(cf965000, 00001000)
> >>
> >> these are not mapped yet, and need to use early_ioremap.
> >
> > In fact we are mapping them inside alloc_low_page. No need for
> > map_low_page, right?
> 
> alloc_low_page return virtual address, but it can not be used to
> access that position right away.
> so in that case map_low_page is used to convert that virtual address
> to phy address and then to early map address.
 
Are you sure?
I am looking at this piece of code under kernel_physical_mapping_init:


---
        pud = alloc_low_page(&pud_phys);
		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
						 page_size_mask);
		unmap_low_page(pud);
---

and the implementaion of alloc_low_page is:

---
static __ref void *alloc_low_page(unsigned long *phys)
{
	unsigned long pfn = pgt_buf_end++;
	void *adr;

	if (after_bootmem) {
		adr = (void *)get_zeroed_page(GFP_ATOMIC | __GFP_NOTRACK);
		*phys = __pa(adr);

		return adr;
	}

	if (pfn >= pgt_buf_top)
		panic("alloc_low_page: ran out of memory");

	adr = early_memremap(pfn * PAGE_SIZE, PAGE_SIZE);
	clear_page(adr);
	*phys  = pfn * PAGE_SIZE;
	return adr;
}
---

It looks to me that map_low_page is never called in this code path.
If I read the code correctly map_low_page is only used to map pagetable
pages that are already mapped (see the debug logging I posted in the
previous email) so it is not useful.
--8323329-1027710972-1299605541=:2968--
