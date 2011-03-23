Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab1CWQTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:19:42 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:33583 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1CWQTk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ST+lv/NhJNW42mv54+P4tklkw7IzZ0e9yjXz52xE54CkFX4lumoQXj/qg0oGNhzhT5
         tFp4Ya8D6KUzDpJHGUajHUD034MYv3hJCeHyPsR031XlaIKmupJuBu8ZJeJfsa2zlqFU
         8brJm8nx2CqNvgHzyvvrnEOQIUcAmf+wotvNo=
MIME-Version: 1.0
In-Reply-To: <20110323125105.GA6599@dumpdata.com>
References: <1299598789-20402-1-git-send-email-konrad.wilk@oracle.com>
	<4D769726.2030307@shipmail.org>
	<20110322143137.GA25113@dumpdata.com>
	<4D89AB8F.6020500@shipmail.org>
	<20110323125105.GA6599@dumpdata.com>
Date: Wed, 23 Mar 2011 12:19:38 -0400
Message-ID: <AANLkTimoghOjqOa3T4EN0qUrRuZuBQ0V-BMyqH9MV85a@mail.gmail.com>
Subject: Re: [PATCH] cleanup: Add 'struct dev' in the TTM layer to be passed
 in for DMA API calls.
From: Alex Deucher <alexdeucher@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Hellstrom <thomas@shipmail.org>, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>, dri-devel@lists.freedesktop.org,
        Jerome Glisse <j.glisse@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:51 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>> >I was thinking about this a bit after I found that the PowerPC requires
>> >the 'struct dev'. But I got a question first, what do you with pages
>> >that were allocated to a device that can do 64-bit DMA and then
>> >move it to a device than can 32-bit DMA? Obviously the 32-bit card would
>> >set the TTM_PAGE_FLAG_DMA32 flag, but the 64-bit would not. What is the
>> >process then? Allocate a new page from the 32-bit device and then copy over the
>> >page from the 64-bit TTM and put the 64-bit TTM page?
>>
>> Yes, in certain situations we need to copy, and if it's necessary in
>> some cases to use coherent memory with a struct device assoicated
>> with it, I agree it may be reasonable to do a copy in that case as
>> well. I'm against, however, to make that the default case when
>> running on bare metal.
>
> This situation could occur on native/baremetal. When you say 'default
> case' you mean for every type of page without consulting whether it
> had the TTM_PAGE_FLAG_DMA32?
>>
>> However, I've looked a bit deeper into all this, and it looks like
>> we already have other problems that need to be addressed, and that
>> exists with the code already in git:
>>
>> Consider a situation where you allocate a cached DMA32 page from the
>> ttm page allocator. You'll end up with a coherent page. Then you
>> make it uncached and finally you return it to the ttm page
>> allocator. Since it's uncached, it will not be freed by the dma api,
>> but kept in the uncached pool, and later the incorrect page free
>> function will be called.
>
> Let me look in details in the code, but I thought it would check the
> TTM_PAGE_FLAG_DMA32 and direct the page to the correct pool?
>
> We could piggyback on the idea of the struct I had and have these
> values:
>
> struct ttm_page {
>        struct page *page;
>        dma_addr_t      *bus_addr;
>        struct *ttm_pool        *origin;
> }
>
> And the origin would point to the correct pool so that on de-allocate
> it would divert it to the original one. Naturally there would
> be some thinking to be done on the de-alloc path so that
> the *origin isn't pointing to something htat has already been free-d.
>
>>
>> I think we might need to take a few steps back and rethink this whole idea:
>>
>> 1) How does this work in the AGP case? Let's say you allocate
>> write-combined DMA32 pages from the ttm page pool (in this case you
>> won't get coherent memory) and then use them in an AGP gart? Why is
>> it that we don't need coherent pages then in the Xen case?
>
> Hehe.. So I had posted a set of patches to carry the 'dma_addr_t' through
> the AGP API and then to its backends to program that. And also the frontends
> (so DRM, TTM) Here is the
> patchset I posted some time ago:
>
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-12/msg02382.html
> and the discussion:
>
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-12/msg02411.html
>
> Dave recommended I skip AGP and just concentrate on PCIe since not to many
> folks use AGP anymore. Thought I realized that server boards use PCI
> cards (ATI ES1000), which do utilize the AGP API. So there is breakage there
> and I have a set of patches for this that I was in process of rebasing
> on 2.6.39-rcX.

Actually the PCI gart mechanism uses cached pages rather than uncached
on the pre-pcie asics.  On pcie asics, the on-board gart can use both
cached and uncached pages.  There is a flag in the gpu's page table to
specify whether the pages need a snooped cycle or not.  At the moment
we only use cached pages for the onboard gart, but there are
performance advantages for using uncached pages for certain types of
buffers (pretty much everything that doesn't require CPU reads).  That
may be something we want to take advantage of in the future.  FWIW,
all AGP radeons can use the onboard gart instead of or in addition to
AGP.

Alex

>
>>
>> 2) http://www.mjmwired.net/kernel/Documentation/DMA-API.txt, line 33
>> makes me scared.
>> We should identify what platforms may have problems with this.
>
> Right.. I think nobody much thought about this in context of TTM since
> that was only used on X86. I can take a look at the DMA API's of the
> other two major platforms: IA64 and PPC and see what lurks there.
>
>>
>> 3) When hacking on the unichrome DMA engine it wasn't that hard to
>> use the synchronization functions of the DMA api correctly:
>>
>>  When binding a TTM, the backend calls dma_map_page() on pages, When
>> unbinding, the backend calls dma_unmap_page(), If we need cpu access
>> when bound, we need to call dma_sync_single_for_[cpu|device]. If
>> this is done, it will be harder to implement user-space
>> sub-allocation, but possible. There will be a performance loss on
>> some platforms, though.
>
> Yup. That was my other suggestion about this. But I had no idea
> where to sprinkle those 'dma_sync_single_[*]' calls, as they would
> have been done in the drivers. Probably on its DMA paths, right before
> telling the GPU to process the CP, and when receiving an interrupt
> when the CP has been completed.
>
