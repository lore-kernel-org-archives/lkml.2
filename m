Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab0C0AHs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 20:07:48 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:51976 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0C0AHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 20:07:45 -0400
Date: Sat, 27 Mar 2010 01:07:23 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 02/24] x86: Make sure free_init_pages() free pages in boundary
Message-ID: <20100327000723.GF29222@cmpxchg.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org> <1269642114-16588-3-git-send-email-yinghai@kernel.org> <20100326230615.GB29222@cmpxchg.org> <4BAD4734.8020503@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAD4734.8020503@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 04:45:56PM -0700, Yinghai Lu wrote:
> On 03/26/2010 04:06 PM, Johannes Weiner wrote:
> > On Fri, Mar 26, 2010 at 03:21:32PM -0700, Yinghai Lu wrote:
> >> diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
> >> index adedeef..fe3d953 100644
> >> --- a/arch/x86/kernel/head32.c
> >> +++ b/arch/x86/kernel/head32.c
> >> @@ -47,6 +47,7 @@ void __init i386_start_kernel(void)
> >>  		u64 ramdisk_image = boot_params.hdr.ramdisk_image;
> >>  		u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
> >>  		u64 ramdisk_end   = ramdisk_image + ramdisk_size;
> >> +		ramdisk_end = PFN_UP(ramdisk_end) << PAGE_SHIFT;
> > 
> > Why not PAGE_ALIGN()?
> 
> looks like PFN_UP is more clear.

Why would you convert to a pfn just to go back to a physical address,
when all you wanted is align at the next page boundary?  It looks
rather clumsy.

PAGE_ALIGN() is pretty wide spread and I think it's clear to most
people what it does.

> >> +	size_aligned = ramdisk_end - ramdisk_image;
> >> +
> >>  	/* We need to move the initrd down into lowmem */
> >> -	ramdisk_here = find_e820_area(0, end_of_lowmem, ramdisk_size,
> >> +	ramdisk_here = find_e820_area(0, end_of_lowmem, size_aligned,
> >>  					 PAGE_SIZE);
> >>  
> >>  	if (ramdisk_here == -1ULL)
> >>  		panic("Cannot find place for new RAMDISK of size %lld\n",
> >> -			 ramdisk_size);
> >> +			 size_aligned);
> >>  
> >>  	/* Note: this includes all the lowmem currently occupied by
> >>  	   the initrd, we rely on that fact to keep the data intact. */
> >> -	reserve_early(ramdisk_here, ramdisk_here + ramdisk_size,
> >> +	reserve_early(ramdisk_here, ramdisk_here + size_aligned,
> >>  			 "NEW RAMDISK");
> >>  	initrd_start = ramdisk_here + PAGE_OFFSET;
> >>  	initrd_end   = initrd_start + ramdisk_size;
> >>  	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
> >> -			 ramdisk_here, ramdisk_here + ramdisk_size);
> >> +			 ramdisk_here, ramdisk_here + size_aligned);
> >>  
> >>  	q = (char *)initrd_start;
> >>  
> >>  	/* Copy any lowmem portion of the initrd */
> >> -	if (ramdisk_image < end_of_lowmem) {
> >> -		clen = end_of_lowmem - ramdisk_image;
> >> -		p = (char *)__va(ramdisk_image);
> >> +	image = ramdisk_image;
> >> +	if (image < end_of_lowmem) {
> >> +		clen = end_of_lowmem - image;
> >> +		p = (char *)__va(image);
> >>  		memcpy(q, p, clen);
> >>  		q += clen;
> >> -		ramdisk_image += clen;
> >> -		ramdisk_size  -= clen;
> >> +		image += clen;
> >> +		size_aligned  -= clen;
> >>  	}
> >>  
> >>  	/* Copy the highmem portion of the initrd */
> >> -	while (ramdisk_size) {
> >> -		slop = ramdisk_image & ~PAGE_MASK;
> >> -		clen = ramdisk_size;
> >> +	while (size_aligned) {
> >> +		slop = image & ~PAGE_MASK;
> >> +		clen = size_aligned;
> >>  		if (clen > MAX_MAP_CHUNK-slop)
> >>  			clen = MAX_MAP_CHUNK-slop;
> >> -		mapaddr = ramdisk_image & PAGE_MASK;
> >> +		mapaddr = image & PAGE_MASK;
> >>  		p = early_memremap(mapaddr, clen+slop);
> >>  		memcpy(q, p+slop, clen);
> >>  		early_iounmap(p, clen+slop);
> >>  		q += clen;
> >> -		ramdisk_image += clen;
> >> -		ramdisk_size  -= clen;
> >> +		image += clen;
> >> +		size_aligned  -= clen;
> > 
> > Those appear to be a lot of spurious changes.  We don't need to
> > copy the alignment padding as well, so it only matters that the
> > arguments to find_e820_area() and reserve_early() are aligned, no?
> 
> we need to reserve that whole page, otherwise other user may use the same page.

I know that.  And you would know that I know that, if you actually
read what I wrote.

> >> --- a/arch/x86/mm/init.c
> >> +++ b/arch/x86/mm/init.c
> >> @@ -332,6 +332,16 @@ int devmem_is_allowed(unsigned long pagenr)
> >>  void free_init_pages(char *what, unsigned long begin, unsigned long end)
> >>  {
> >>  	unsigned long addr = begin;
> >> +	unsigned long addr_aligned, end_aligned;
> >> +
> >> +	/* Make sure boundaries are page aligned */
> >> +	addr_aligned = PFN_UP(addr) << PAGE_SHIFT;
> >> +	end_aligned = PFN_DOWN(end) << PAGE_SHIFT;
> >> +
> >> +	if (WARN(addr_aligned != addr || end_aligned != end, "free_init_pages: range [%#lx, %#lx] is not aligned\n", addr, end)) {
> >> +		addr = addr_aligned;
> >> +		end = end_aligned;
> >> +	}
> > 
> > Maybe realign only for when it is not aligned?  So to keep the fixup
> > out of line.
> > 
> > I suppose WARN_ON() is enough as it will print a stack trace which
> > should be enough clue of what went wrong.
> 
> we need to PFN_DOWN the end, and don't free the partial page.
> otherwise could crash the system.

Dito.

	if (WARN_ON(not_aligned)) {
		align
	}

is what I meant.

> So just print out the trace, and system still can be used. reporter to get dmesg if
> he don't have serial console.

/me goes arguing with M-x doctor, that thing actually acts on the
supplied input.
