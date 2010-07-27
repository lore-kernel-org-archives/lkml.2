Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab0G0IYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 04:24:45 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:35370 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab0G0IYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 04:24:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABczTkx5LclT/2dsb2JhbACfZHLAfYU2BA
Date: Tue, 27 Jul 2010 18:24:39 +1000
From: Nick Piggin <npiggin@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] vmap: add flag to allow lazy unmap to be disabled at
 runtime
Message-ID: <20100727082439.GB6332@amd>
References: <4C4DEF13.1030403@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4DEF13.1030403@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 01:24:51PM -0700, Jeremy Fitzhardinge wrote:
> 
> 
> [ Nick, I forget if I sent this to you before.  Could you Ack it if it looks OK? Thanks, J ]
> 
> Add a flag to force lazy_max_pages() to zero to prevent any outstanding
> mapped pages.  We'll need this for Xen.

You have sent this to me before, probably several times, and I always
forget about it right as you send it again.

It's no problem merging something like this for Xen, although as you
know I would love to see an approach where Xen would benefit from
delayed flushing as well :)

You will need to disable lazy flushing from the per-cpu allocator
(vm_map_ram/vm_unmap_ram, which are used by XFS now). That's not
tied to the lazy_max stuff (which it should be, arguably)

That code basically allocates per-cpu chunks of va from the global
allocator, uses them, then frees them back to the global allocator
all without doing any TLB flushing.

If you have to do global TLB flushing there, then it's probably not
much value in per-cpu locking of the address allocator anyway, so
you could just add a test for vmap_lazy_unmap in these branches:

  if (likely(count <= VMAP_MAX_ALLOC) && !vmap_lazy_unmap)

Thanks,
Nick

> 
> Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>
> 
> diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
> index 227c2a5..b840fda 100644
> --- a/include/linux/vmalloc.h
> +++ b/include/linux/vmalloc.h
> @@ -7,6 +7,8 @@
> 
>  struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
> 
> +extern bool vmap_lazy_unmap;
> +
>  /* bits in flags of vmalloc's vm_struct below */
>  #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
>  #define VM_ALLOC	0x00000002	/* vmalloc() */
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ae00746..7f35fe2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -31,6 +31,7 @@
>  #include<asm/tlbflush.h>
>  #include<asm/shmparam.h>
> 
> +bool vmap_lazy_unmap __read_mostly = true;
> 
>  /*** Page table manipulation functions ***/
> 
> @@ -502,6 +503,9 @@ static unsigned long lazy_max_pages(void)
>  {
>  	unsigned int log;
> 
> +	if (!vmap_lazy_unmap)
> +		return 0;
> +
>  	log = fls(num_online_cpus());
> 
>  	return log * (32UL * 1024 * 1024 / PAGE_SIZE);
> 
