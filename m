Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab0GVQpB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 12:45:01 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23946 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab0GVQo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 12:44:58 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6051"; a="48160028"
Date: Thu, 22 Jul 2010 09:44:56 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
Message-ID: <20100722164454.GF10255@codeaurora.org>
References: <20100720221959.GC12250@codeaurora.org>
 <20100721104356S.fujita.tomonori@lab.ntt.co.jp>
 <20100722043034.GC22559@codeaurora.org>
 <20100722134253B.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722134253B.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:43:26PM +0900, FUJITA Tomonori wrote:
> On Wed, 21 Jul 2010 21:30:34 -0700
> Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> 
> > On Wed, Jul 21, 2010 at 10:44:37AM +0900, FUJITA Tomonori wrote:
> > > On Tue, 20 Jul 2010 15:20:01 -0700
> > > Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> > > 
> > > > > I'm not saying that it's reasonable to pass (or even allocate) a 1MB
> > > > > buffer via the DMA API.
> > > > 
> > > > But given a bunch of large chunks of memory, is there any API that can
> > > > manage them (asked this on the other thread as well)?
> > > 
> > > What is the problem about mapping a 1MB buffer with the DMA API?
> > > 
> > > Possibly, an IOMMU can't find space for 1MB but it's not the problem
> > > of the DMA API.
> > 
> > This goes to the nub of the issue. We need a lot of 1 MB physically
> > contiguous chunks. The system is going to fragment and we'll never get
> > our 12 1 MB chunks that we'll need, since the DMA API allocator uses
> > the system pool it will never succeed. For this reason we reserve a
> > pool of 1 MB chunks (and 16 MB, 64 KB etc...) to satisfy our
> > requests. This same use case is seen on most embedded "media" engines
> > that are getting built today.
> 
> We don't need a new abstraction to reserve some memory.
> 
> If you want pre-allocated memory pool per device (and share them with
> some), the DMA API can for coherent memory (see
> dma_alloc_from_coherent). You can extend the DMA API if necessary.

That function won't work for us. We can't use
bitmap_find_free_region(), we need to use our own allocator. If
anything we need a dma_alloc_from_custom(my_allocator). Take a look
at:

mm: iommu: A physical allocator for the VCMM
vcm_alloc_max_munch() 
