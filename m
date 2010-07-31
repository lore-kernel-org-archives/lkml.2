Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab0GaBHS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:07:18 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:36108 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab0GaBHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:07:14 -0400
Date: Fri, 30 Jul 2010 21:07:06 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        ak@linux.intel.com, konrad.wilk@oracle.com, akataria@vmware.com
Subject: Re: [PATCH] swiotlb: enlarge iotlb buffer on demand
Message-ID: <20100731010706.GA30319@andromeda.dapyr.net>
References: <20100731003643E.fujita.tomonori@lab.ntt.co.jp> <20100730202724.GA920@andromeda.dapyr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100730202724.GA920@andromeda.dapyr.net>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took your patch and was trying to fit it over the
stable/swiotlb-0.8.4 branch and when I did so a found couple of things..


> > @@ -215,14 +222,14 @@ swiotlb_late_init_with_default_size(size_t default_size)
> >  	bytes = io_tlb_nslabs << IO_TLB_SHIFT;

You should also initialize the __io_tlb_start array first:

	__io_tlb_start = __get_free_pages(GFP_KERNEL,
                get_order((io_tlb_nslabs / IO_TLB_SEGSIZE) * sizeof(char *)));
        if (!__io_tlb_start)
                goto cleanup1;

> >  
> >  	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
> > -		io_tlb_start = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> > -							order);
> > -		if (io_tlb_start)
> > +		__io_tlb_start[0] = (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
> > +							     order);

Otherwise this will be a NULL pointer exception.
> > +		if (__io_tlb_start[0])
> >  			break;
> >  		order--;
> >  	}
> >  
> > -	if (!io_tlb_start)
> > +	if (!__io_tlb_start[0])
> >  		goto cleanup1;
> >  
> >  	if (order != get_order(bytes)) {
> > @@ -231,13 +238,12 @@ swiotlb_late_init_with_default_size(size_t default_size)
> >  		io_tlb_nslabs = SLABS_PER_PAGE << order;
> >  		bytes = io_tlb_nslabs << IO_TLB_SHIFT;
> >  	}
> > -	io_tlb_end = io_tlb_start + bytes;
> > -	memset(io_tlb_start, 0, bytes);
> > +	memset(__io_tlb_start[0], 0, bytes);
> >  
> >  	/*
> >  	 * Allocate and initialize the free list array.  This array is used
> >  	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
> > -	 * between io_tlb_start and io_tlb_end.
> > +	 * between io_tlb_start.
> >  	 */
> >  	io_tlb_list = (unsigned int *)__get_free_pages(GFP_KERNEL,
> >  	                              get_order(io_tlb_nslabs * sizeof(int)));
> > @@ -280,9 +286,8 @@ cleanup3:
> >  	                                                 sizeof(int)));
> >  	io_tlb_list = NULL;
> >  cleanup2:
> > -	io_tlb_end = NULL;
> > -	free_pages((unsigned long)io_tlb_start, order);
> > -	io_tlb_start = NULL;
> > +	free_pages((unsigned long)__io_tlb_start[0], order);
> > +	__io_tlb_start[0] = NULL;
> >  cleanup1:
> >  	io_tlb_nslabs = req_nslabs;
> >  	return -ENOMEM;
> > @@ -300,7 +305,7 @@ void __init swiotlb_free(void)
> >  			   get_order(io_tlb_nslabs * sizeof(phys_addr_t)));
> >  		free_pages((unsigned long)io_tlb_list, get_order(io_tlb_nslabs *
> >  								 sizeof(int)));
> > -		free_pages((unsigned long)io_tlb_start,
> > +		free_pages((unsigned long)__io_tlb_start[0],
> >  			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));

That isn't exactly right I think. You are de-allocating the first array,
which size is determined by 'order'. Probably 10. And you not freeing
the array, just the first entry.

> >  	} else {
> >  		free_bootmem_late(__pa(io_tlb_overflow_buffer),
> > @@ -309,15 +314,36 @@ void __init swiotlb_free(void)
> >  				  io_tlb_nslabs * sizeof(phys_addr_t));
> >  		free_bootmem_late(__pa(io_tlb_list),
> >  				  io_tlb_nslabs * sizeof(int));
> > -		free_bootmem_late(__pa(io_tlb_start),
> > +		free_bootmem_late(__pa(__io_tlb_start[0]),
> >  				  io_tlb_nslabs << IO_TLB_SHIFT);

I think you need this:

                free_bootmem_late(__pa(__io_tlb_start[0]),
                                  IO_TLB_SEGSIZE << IO_TLB_SHIFT);
                free_bootmem_late(__pa(__io_tlb_start),
                                  (io_tlb_nslabs / IO_TLB_SEGSIZE) * sizeof(char *));
