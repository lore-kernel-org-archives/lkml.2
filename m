Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab1CaPuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:50:46 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:37782 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758424Ab1CaPup (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 31 Mar 2011 11:50:45 -0400
Date: Thu, 31 Mar 2011 11:49:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexdeucher@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be
 passed in for DMA API calls.
Message-ID: <20110331154954.GA7695@dumpdata.com>
References: <20110322143137.GA25113@dumpdata.com>
 <4D89AB8F.6020500@shipmail.org>
 <20110323125105.GA6599@dumpdata.com>
 <4D89F2DE.7020209@shipmail.org>
 <20110323145246.GA7546@dumpdata.com>
 <4D8AF834.8040700@shipmail.org>
 <20110324142509.GA32416@dumpdata.com>
 <AANLkTinUGjwTzMFbHHckkiuCQ8sF+i5iMQsXesG34f6U@mail.gmail.com>
 <20110324162135.GA835@dumpdata.com>
 <4D8CF46F.2070206@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8CF46F.2070206@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D94A2A6.00B4:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >I can start this next week if you guys are comfortable with this idea.
> >
> >
> 
> Konrad,
> 
> 1) A couple of questions first. Where are the memory pools going to
> end up in this design. Could you draft an API? How is page
> accounting going to be taken care of? How do we differentiate
> between running on bare metal and running on a hypervisor?

My thought was that the memory pool's wouldn't be affected. Instead
of all of the calls to alloc_page/__free_page (and dma_alloc_coherent/
dma_free_coherent) would go through this API calls.

What I thought off are three phases:

 1). Get in the patch that passed in 'struct dev' to the dma_alloc_coherent
  for 2.6.39 so that PowerPC folks can use the it with radeon cards. My
  understanding is that the work you plan on to isn't going in 2.6.39
  but rather in 2.6.40 - and if get my stuff ready (the other phases)
  we can work out the kinks together. This way also the 'struct dev'
  is passed in the TTM layer.

 2). Encapsulate the 'struct page *' and 'dma_addr_t *dma_address' from
   'struct ttm_tt' in its own structure ('struct ttm_tt_page'?) along
    with the a struct list_head (this is b/c most of the code in that
    layer uses the 'page->lru' to key off, but if we are using a tuple
    we could get un-sync with which dma_addr_t the page is associated with).

     During startup we would allocate this 'struct ttm_tt_page' the
     same way we create 'struct page **' and 'dma_addr_t *dma_address'
    (meaning in ttm_tt_alloc_page_directory utilize drm_calloc_large)

 3). Provide an 'struct ttm_page_alloc_ops' that has two implementors.
   The struct would look like this:

    struct ttm_page_alloc_ops {
	bool (*probe) (struct dev *dev);
        struct ttm_tt_page (*alloc) (struct dev *dev, gfp_t gfp_flags);
	void (*free) (struct ttm_tt_page *page);
    }
   The ttm_page_alloc.c would have these defined:

struct ttm_page_alloc_ops *alloc_backend = &ttm_page_alloc_generic;
static struct ttm_page_alloc_ops *alloc_backends[] = {
	&ttm_page_alloc_dma,
	&ttm_page_alloc_generic,
	NULL,
};


   And the ttm_page_alloc_init function would iterate over it
	 for (i = 0; alloc_backends[i]; ++i) {
		if (alloc_backends[i]->probe(dev)) {
			alloc_backend = alloc_backends[i];
			break;
		}
	}

  
   3.1). Implement the ttm_page_alloc_generic calls, which would:

	probe() would return 1, alloc() would return a struct ttm_tt_page
        with the 'page' pointing to what 'alloc_page()' returned. And 'dma_address'
        would contain DMA_ADDRESS_BAD. free() would just call __free_page.

   3.2). The ttm_page_alloc_dma would be more complex.

	probe() would squirell the 'struct dev' away. And if
	it detected it is running under Xen (if (xen_domain_pv())) return true.

	alloc_page() would pretty much do what ttm_put_pages() does right now
	and save on its own list the 'struct page *' address and as well
	with what 'struct dev' it is associated.

	The free() would use the list to figure out which 'struct dev' to use
	for the passed in 'struct ttm_page_tt' and use all of that data
	to call 'dma_free_coherent' with the right arguments.
	
   4). All of the calls in for alloc_page/__free_page would be
       swapped with alloc_backend->alloc, or alloc_backend->free.

   5). Test, test, test..
 
Ok, that is actually five phases. Please poke at it and see if there is
some other case I had forgotten.
 				      
> 
> 2) When a page changes caching policy, I guess that needs to be
> propagated to any physical hypervisor mappings of that page. We

Right, that is OK. the set_pages_wb and its friends end up modifying
the PTE's at some point. And right now, if you compile the kernel with
CONFIG_PVOPS (which you need to have it working under a Xen hypervisor
as a PV guest), the modifications to the PTE calls end up calling the
right hypervisors PTE modification code. In Xen it would be xen_make_pte
- which sets the right attributes.
 
> don't allow for different maps with different caching policies in
> the general case.
> 
> 3) TTM needs to be able to query the bo whether its pages can be
> a) moved between devices (I guess this is the case for coherent
> pages with a phony device).

The device wouldn't be phony anymore. It would be the real physical
device. So whatever code does it ought to work.

> b) inserted into the swap cache (I guess this is in general not the
> case for coherent pages).

It might still be the case. Under what conditions is this triggered?
How can I test this easily?
> 
> 4) We'll probably need to move ttm page alloc and put and the query
> in 3) to the ttm backend. The backend can then hide things like DMA
> address and device-specific memory to the rest of TTM as long as the
> query in 3) is exposed, so the rest of TTM doesn't need to care. The
> backend can then plug in whatever memory allocation utility function
> it wants.

<nods> I think the draft I mentioned covers that.
> 
> 5) For the future we should probably make TTM support non-coherent
> memory if needed, with appropriate flushes and sync for device /
> cpu. However, that's something we can look at later

OK. I am up for doing that when the time will come for it.
