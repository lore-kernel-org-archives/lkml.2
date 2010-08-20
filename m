Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab0HTLvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:51:31 -0400
Received: from mail.issp.bas.bg ([195.96.236.10]:57965 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431Ab0HTLv3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:51:29 -0400
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [RFC][PATCH] add dma_reserve_coherent_memory()/dma_free_reserved_memory() API
Date: Fri, 20 Aug 2010 14:50:12 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.36-rc1; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
References: <201008191818.36068.mitov@issp.bas.bg> <201008201113.46036.mitov@issp.bas.bg> <20100820173349E.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100820173349E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008201450.12585.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 20, 2010 11:35:06 am FUJITA Tomonori wrote:
> On Fri, 20 Aug 2010 11:13:45 +0300
> Marin Mitov <mitov@issp.bas.bg> wrote:
> 
> > > > This tric is already used in drivers/staging/dt3155v4l.c
> > > > dt3155_alloc_coherent()/dt3155_free_coherent()
> > > > 
> > > > Here proposed for general use by popular demand from video4linux folks.
> > > > Helps for videobuf-dma-contig framework.
> > > 
> > > What you guys exactly want to do? If you just want to pre-allocate
> > > coherent memory for latter usage,
> > 
> > Yes, just to preallocate not coherent, but rather contiguous memory for latter usage.
> > We use coherent memory because it turns out to be contiguous.
> 
> Hmm, you don't care about coherency? You just need contiguous memory?

Yes. We just need contiguous memory. Coherency is important as far as when dma
transfer finishes user land is able to see the new data. Could be done by something like
dma_{,un}map_single()

> 
> Then, I prefer to invent the API to allocate contiguous
> memory. Coherent memory is precious on some arches.

Sure, but in any case videobuf-dma-contig framework in drivers/media/video
is already built around dma-coherent (nevertheless it is precious), so the two new
functions are just a helpful extension to the existing use of dma-coherent memory.

In any case, as far as these two functions will be mainly used by media/video folks
they could be added not to the drivers/base/dma-coherent.c (where I see their place),
but to drivers/media/video/videobuf-dma-contig.c. In that case the disadvantage will be
that if someone out of the media tree will need this functionality he(she) will need to
compile media/videobuf-dma-contig.c
> 
> 
> > > why dma_pool API (mm/dmapool.c) doesn't work?
> > 
> > I do not know why dma_pool API doesn't work for frame grabber buffers.
> > May be they are too big ~400KB. I have tried dma_pool APIs without success 
> > some time ago, so I had to find some other way to solve my problem leading to 
> > the proposed dma_reserve_coherent_memory()/dma_free_reserved_memory().
> 
> I think that dma_pool API is for small coherent memory (smaller than
> PAGE_SIZE) 

Yes.

> so it might not work for you. However, the purpose of
> dma_pool API is exactly for what you want to do, creating a pool for
> coherent memory per device for drivers.
> 
> I don't see any reason why we can't extend the dma_pool API for your
> case. And it looks better to me rather than inventing the new API.

That will help. I will be happy if someone can do it. I am inpaciently waiting for 
alloc_huhepages()/free_hugepages() API - (transparent hugepages patches, may be)
That also could be a solution for media/video folks with hardware that cannot do 
scatter/gatter. Another solution will be an IOMMU that could present a scattered
user land buffer as contiguous dma address range (I have played in the past with 
AGP-GART without great success).

Thanks.

Marin Mitov

 
