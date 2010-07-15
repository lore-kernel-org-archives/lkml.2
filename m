Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab0GOBl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:41:57 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65363 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab0GOBlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:41:55 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47365523"
Date: Wed, 14 Jul 2010 18:41:48 -0700
From: Zach Pfeffer <zpfeffer@codeaurora.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux@arm.linux.org.uk, ebiederm@xmission.com, linux-arch@vger.kernel.org,
        dwalker@codeaurora.org, mel@csn.ul.ie, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 1/3 v3] mm: iommu: An API to unify IOMMU, CPU and device
 memory management
Message-ID: <20100715014148.GC2239@codeaurora.org>
References: <20100713121420.GB4263@codeaurora.org>
 <20100714104353B.fujita.tomonori@lab.ntt.co.jp>
 <20100714201149.GA14008@codeaurora.org>
 <20100715080710T.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715080710T.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 08:07:28AM +0900, FUJITA Tomonori wrote:
> On Wed, 14 Jul 2010 13:11:49 -0700
> Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> 
> > On Wed, Jul 14, 2010 at 10:59:38AM +0900, FUJITA Tomonori wrote:
> > > On Tue, 13 Jul 2010 05:14:21 -0700
> > > Zach Pfeffer <zpfeffer@codeaurora.org> wrote:
> > > 
> > > > > You mean that you want to specify this alignment attribute every time
> > > > > you create an IOMMU mapping? Then you can set segment_boundary_mask
> > > > > every time you create an IOMMU mapping. It's odd but it should work.
> > > > 
> > > > Kinda. I want to forget about IOMMUs, devices and CPUs. I just want to
> > > > create a mapping that has the alignment I specify, regardless of the
> > > > mapper. The mapping is created on a VCM and the VCM is associated with
> > > > a mapper: a CPU, an IOMMU'd device or a direct mapped device.
> > > 
> > > Sounds like you can do the above with the combination of the current
> > > APIs, create a virtual address and then an I/O address.
> > > 
> > 
> > Yes, and that's what the implementation does - and all the other
> > implementations that need to do this same thing. Why not solve the
> > problem once?
> 
> Why we we need a new abstraction layer to solve the problem that the
> current API can handle?

The current API can't really handle it because the DMA API doesn't
separate buffer allocation from buffer mapping. To use the DMA API a
scatterlist would need to be synthesized from the physical buffers
that we've allocated. 

For instance: I need 10, 1 MB physical buffers and a 64 KB physical
buffer. With the DMA API I need to allocate 10*1MB/PAGE_SIZE + 64
KB/PAGE_SIZE scatterlist elements, fix them all up to follow the
chaining specification and then go through all of them again to fix up
their virtual mappings for the mapper that's mapping the physical
buffer. If I want to share the buffer with another device I have to
make a copy of the entire thing then fix up the virtual mappings for
the other device I'm sharing with. The VCM splits the two things up so
that I do a physical allocation, then 2 virtual allocations and then
map both.

> 
> The above two operations don't sound too complicated. The combination
> of the current API sounds much simpler than your new abstraction.
> 
> Please show how the combination of the current APIs doesn't
> work. Otherwise, we can't see what's the benefit of your new
> abstraction.

See above.
