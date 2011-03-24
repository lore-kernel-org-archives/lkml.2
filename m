Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1CXQWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 12:22:22 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23654 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932660Ab1CXQWU convert rfc822-to-8bit (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 24 Mar 2011 12:22:20 -0400
Date: Thu, 24 Mar 2011 12:21:35 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Thomas Hellstrom <thomas@shipmail.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Alex Deucher <alexdeucher@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be
 passed in for DMA API calls.
Message-ID: <20110324162135.GA835@dumpdata.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
 <4D769726.2030307@shipmail.org>
 <20110322143137.GA25113@dumpdata.com>
 <4D89AB8F.6020500@shipmail.org>
 <20110323125105.GA6599@dumpdata.com>
 <4D89F2DE.7020209@shipmail.org>
 <20110323145246.GA7546@dumpdata.com>
 <4D8AF834.8040700@shipmail.org>
 <20110324142509.GA32416@dumpdata.com>
 <AANLkTinUGjwTzMFbHHckkiuCQ8sF+i5iMQsXesG34f6U@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTinUGjwTzMFbHHckkiuCQ8sF+i5iMQsXesG34f6U@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D8B6F90.0145,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > When a page in the TTM pool is being moved back and forth and also changes
> > the caching model, what happens on the free part? Is the original caching
> > state put back on it? Say I allocated a DMA32 page (GFP_DMA32), and move it
> > to another pool for another radeon device. I also do some cache changes:
> > make it write-back, then  un-cached, then writeback, and when I am done, I
> > return it back to the pool (DMA32). Once that is done I want to unload
> > the DRM/TTM driver. Does that page get its caching state reverted
> > back to what it originally had (probably un-cached)? And where is this done?
> 
> When ultimately being free all the page are set to write back again as
> it's default of all allocated page (see ttm_pages_put). ttm_put_pages
> will add page to the correct pool (uc or wc).

OK.

.. snip ..
> > How about a backend TTM alloc API? So the calls to 'ttm_get_page'
> > and 'ttm_put_page' call to a TTM-alloc API to do allocation.
> >
> > The default one is the native, and it would have those 'dma_alloc_coherent'
> > removed.  When booting under virtualized
> > environment a virtualisation "friendly" backend TTM alloc would
> > register and all calls to 'put/get/probe' would be diverted to it.
> > 'probe' would obviously check whether it should use this backend or not.
> >
> > It would mean two new files: drivers/gpu/drm/ttm/ttm-memory-xen.c and
> > a ttm-memory-generic.c and some header work.
> >
> > It would still need to keep the 'dma_address[i]' around so that
> > those can be passed to the radeon/nouveau GTT, but for native it
> > could just contain BAD_DMA_ADDRESS - and the code in the radeon/nouveau
> > GTT binding is smart to figure out to do 'pci_map_single' if the
> > dma_addr_t has BAD_DMA_ADDRESS.
> >
> > The issuer here is with the caching I had a question about. We
> > would need to reset the caching state back to the original one
> > before free-ing it. So does the TTM pool de-alloc code deal with this?
> >
> 
> Sounds doable. Thought i don't understand why you want virtualized

Thomas, Jerome, Dave,

I can start this next week if you guys are comfortable with this idea.

> guest to be able to use hw directly. From my point of view all device
> in a virtualized guest should be virtualized device that talks to the
> host system driver.

That "virtualized guest" in this case is the first Linux kernel that
is booted under a hypervisor. It serves as the "driver domain"
so that it can drive the network, storage, and graphics. To get the
graphics working right the patchset that introduced using the PCI DMA
in the TTM layer allows us to program the GTT with the bus address 
instead of programming the bus address of a bounce buffer. The first
set of patches have a great lengthy explanation of this :-)

https://lkml.org/lkml/2010/12/6/516

> 
> Cheers,
> Jerome
