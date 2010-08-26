Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab0HZHEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 03:04:14 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:52252 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239Ab0HZHEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 03:04:12 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Thu, 26 Aug 2010 10:01:52 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc2; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        akpm@linux-foundation.org
References: <201008201450.12585.mitov@issp.bas.bg> <201008260904.19973.mitov@issp.bas.bg> <20100826152333K.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100826152333K.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008261001.57678.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, August 26, 2010 09:24:19 am FUJITA Tomonori wrote:
> On Thu, 26 Aug 2010 09:04:14 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > On Thursday, August 26, 2010 08:40:47 am FUJITA Tomonori wrote:
> > > On Fri, 20 Aug 2010 14:50:12 +0300
> > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > 
> > > > On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> > > > > On Fri, 20 Aug 2010 11:13:45 +0300
> > > > > Marin Mitov <mitov@issp.bas.bg> wrote:
> > > > > 
> > > > > > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > > > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > > > > > 
> > > > > > > > Here proposed for general use by popular demand from video4linux folks.
> > > > > > > > Helps for videobuf-dma-contig framework.
> > > > > > > 
> > > > > > > What you guys exactly want to do? If you just want to pre-allocate
> > > > > > > coherent memory for latter usage,
> > > > > > 
> > > > > > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > > > > > We use coherent memory because it turns out to be contiguous.
> > > > > 
> > > > > Hmm, you don't care about coherency? You just need contiguous memory?
> > > > 
> > > > Yes. We just need contiguous memory. Coherency is important as far as when dma
> > > > transfer finishes user land is able to see the new data. Could be done by something like
> > > > dma_{,un}map_single()
> > > 
> > > Then, we should avoid using coherent memory as I exaplained before. In
> > > addition, dma_alloc_coherent can't provide large enough contigous
> > > memory for some drivers so this patch doesn't help much.
> > 
> > Please, look at drivers/media/video/videobuf-dma-contig.c. Using coherent memory
> > is inavoidable for now, there is no alternative for it for now. The two new functions,
> > which I propose are just helpers for those of us who already use coherent memory
> > (via videobuf-dma-contig API). May be adding these two functions to 
> > drivers/media/video/videobuf-dma-contig.c will be better solution?
> 
> If you add something to the videobuf-dma-contig API, that's fine by me
> because drivers/media/video/videobuf-dma-contig.c uses the own
> structure and plays with dma_alloc_coherent. As long as a driver
> doesn't touch device->dma_mem directly, it's fine, 

Why, my understanding is that device->dma_mem is designed exactly for keeping 
some chunk of coherent memory for device's private use via dma_alloc_from_coherent()
(and that is what dt3155v4l driver is using it for).

> I think (that is, dt3155v4l driver is broken). 

If you mean that allocating some coherent memory (4MB in case of dt3155v4l) during
pci probe() (during system booting) for device's latter use (that is dead for the rest
of the system) you are right. But this gives me at least 8 full size buffers warranted for 
latter use. Without this hack the hardware will not work on strongly fragmented system.
With this hack even if the system is strongly fragmented, this chunk of 4MB is available 
for use (though videobuf-dma-contig APIs and dma_alloc_from_coherent()) __transparently__
for users of videobuf-dma-contig (that is the gain - the transparency).

> There are already some workarounds for
> contigous memory in several drivers anyway.

Sure, can these workarounds be exposed as API for general use?

Thanks,

Marin Mitov

> 
> We will have the proper API for contiguous memory. I don't think that
> adding such workaround to the DMA API is a good idea.
> 
