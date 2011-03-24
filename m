Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab1CXO0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 10:26:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49097 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab1CXOZ7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 24 Mar 2011 10:25:59 -0400
Date: Thu, 24 Mar 2011 10:25:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Hellstrom <thomas@shipmail.org>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be
 passed in for DMA API calls.
Message-ID: <20110324142509.GA32416@dumpdata.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
 <4D769726.2030307@shipmail.org>
 <20110322143137.GA25113@dumpdata.com>
 <4D89AB8F.6020500@shipmail.org>
 <20110323125105.GA6599@dumpdata.com>
 <4D89F2DE.7020209@shipmail.org>
 <20110323145246.GA7546@dumpdata.com>
 <4D8AF834.8040700@shipmail.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8AF834.8040700@shipmail.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D8B5448.0012,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:52:20AM +0100, Thomas Hellstrom wrote:
> On 03/23/2011 03:52 PM, Konrad Rzeszutek Wilk wrote:
> >On Wed, Mar 23, 2011 at 02:17:18PM +0100, Thomas Hellstrom wrote:
> >>On 03/23/2011 01:51 PM, Konrad Rzeszutek Wilk wrote:
> >>>>>I was thinking about this a bit after I found that the PowerPC requires
> >>>>>the 'struct dev'. But I got a question first, what do you with pages
> >>>>>that were allocated to a device that can do 64-bit DMA and then
> >>>>>move it to a device than can 32-bit DMA? Obviously the 32-bit card would
> >>>>>set the TTM_PAGE_FLAG_DMA32 flag, but the 64-bit would not. What is the
> >>>>>process then? Allocate a new page from the 32-bit device and then copy over the
> >>>>>page from the 64-bit TTM and put the 64-bit TTM page?
> >>>>Yes, in certain situations we need to copy, and if it's necessary in
> >>>>some cases to use coherent memory with a struct device assoicated
> >>>>with it, I agree it may be reasonable to do a copy in that case as
> >>>>well. I'm against, however, to make that the default case when
> >>>>running on bare metal.
> >>>This situation could occur on native/baremetal. When you say 'default
> >>>case' you mean for every type of page without consulting whether it
> >>>had the TTM_PAGE_FLAG_DMA32?
> >>No, Basically I mean a device that runs perfectly fine with
> >>alloc_pages(DMA32) on bare metal shouldn't need to be using
> >>dma_alloc_coherent() on bare metal, because that would mean we'd need
> >>to take the copy path above.
> >I think we got the scenarios confused (or I did at least).
> >The scenario I used ("I was thinking.."), the 64-bit device would do
> >alloc_page(GFP_HIGHUSER) and if you were to move it to a 32-bit device
> >it would have to make a copy of the page as it could not reach the page
> >from GFP_HIGUSER.
> >
> >The other scenario, which I think is what you are using, is that
> >we have a 32-bit device allocating a page, so TTM_PAGE_FLAG_DMA32 is set
> >and then we if we were to move it a 64-bit device it would need to
> >copied. But I don't think that is the case - the page would be
> >reachable by the 64-bit device. Help me out please if I am misunderstanding this.
> 
> Yes, this is completely correct.
> 
> Now, with a struct dev attached to each page in a 32-bit system
> (coherent memory)
> we would need to always copy in the 32-bit case, since you can't
> hand over pages
> belonging to other physical devices.
> But on bare metal you don't need coherent memory, but in this case you
> need to copy anyway becase you choose to allocate coherent memory.

Ok, can we go back one more step back. I am unclear about one other
thing. Lets think on this in terms of 2.6.38 code.

When a page in the TTM pool is being moved back and forth and also changes
the caching model, what happens on the free part? Is the original caching
state put back on it? Say I allocated a DMA32 page (GFP_DMA32), and move it
to another pool for another radeon device. I also do some cache changes:
make it write-back, then  un-cached, then writeback, and when I am done, I
return it back to the pool (DMA32). Once that is done I want to unload
the DRM/TTM driver. Does that page get its caching state reverted
back to what it originally had (probably un-cached)? And where is this done?


> 
> I see a sort of a hackish way around these problems.
> 
> Let's say ttm were trying to detect a hypervisor dummy virtual
> device sitting on the pci bus. That device would perhaps provide pci
> information detailing what GFP masks needing to
> allocate coherent memory. The TTM page pool could then grab that
> device and create a struct dev to use for allocating "anonymous" TTM
> BO memory.
> 
> Could that be a way forward? The struct dev would then be private to
> the page pool code, bare metal wouldn't need to allocate coherent
> memory, since the virtual device wouldn't be present. The page pool
> code would need to be updated to be able to cache also coherent
> pages.
> 
> Xen would need to create such a device in the guest with a suitable
> PCI ID that it would be explicitly willing to share with other
> hypervisor suppliers....
> 
> It's ugly, I know, but it might work...

Or just create a phantom 'struct device' that is used with
the TTM layer. And it has the lowest common denominator of the
different graphic cards that exist. But that is a bit strange b/c
for some machines (IBM boxes), you have per-device DMA API specific
calls. This depends on what PCI bus you have the card as some of these
boxes have multiple IOMMUs. So that wouldn't work that nicely..

How about a backend TTM alloc API? So the calls to 'ttm_get_page'
and 'ttm_put_page' call to a TTM-alloc API to do allocation.

The default one is the native, and it would have those 'dma_alloc_coherent'
removed.  When booting under virtualized
environment a virtualisation "friendly" backend TTM alloc would
register and all calls to 'put/get/probe' would be diverted to it.
'probe' would obviously check whether it should use this backend or not.

It would mean two new files: drivers/gpu/drm/ttm/ttm-memory-xen.c and
a ttm-memory-generic.c and some header work.

It would still need to keep the 'dma_address[i]' around so that
those can be passed to the radeon/nouveau GTT, but for native it
could just contain BAD_DMA_ADDRESS - and the code in the radeon/nouveau
GTT binding is smart to figure out to do 'pci_map_single' if the
dma_addr_t has BAD_DMA_ADDRESS.

The issuer here is with the caching I had a question about. We
would need to reset the caching state back to the original one
before free-ing it. So does the TTM pool de-alloc code deal with this?
