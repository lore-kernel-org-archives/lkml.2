Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937919Ab0CPPkJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:40:09 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:28210 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab0CPPkH (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 16 Mar 2010 11:40:07 -0400
Date: Tue, 16 Mar 2010 08:45:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: ak@linux.intel.com, akataria@vmware.com, lenb@kernel.org, x86@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       petr@vmware.com
Subject: Re: [LKML] Re: [LKML] Re: swiotlb detection should be memory
	hotplug aware ?
Message-ID: <20100316124556.GA25340@phenom.dumpdata.com>
References: <1268446032.13691.69.camel@ank32> <4B9B01F5.3000807@linux.intel.com> <20100316005140.GB7622@phenom.dumpdata.com> <20100316103259E.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100316103259E.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B9FA644.0047:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 10:33:20AM +0900, FUJITA Tomonori wrote:
> On Mon, 15 Mar 2010 20:51:40 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Fri, Mar 12, 2010 at 07:09:41PM -0800, Andi Kleen wrote:
> > > , Alok Kataria wrote:
> > >
> > > Hi Alok,
> > >
> > >> Hi,
> > >>
> > >> Looking at the current code swiotlb is initialized for 64bit kernels
> > >> only when the max_pfn value is greater than 4G (MAX_DMA32_PFN value).
> > >> So in cases when the initial memory is less than 4GB the kernel boots
> > >> without enabling swiotlb, when we hotadd memory to such a kernel and go
> > >> beyond the 4G limit, swiotlb is still disabled. As a result when any
> > >> 32bit devices start using this newly added memory beyond 4G, the kernel
> > >> starts spitting error messages like below or in some cases it causes
> > >> kernel panics.
> > >
> > > Yes seems like a real problem.
> > >
> > >>
> > >> 1. Enable swiotlb for all 64bit kernels which have memory hot-add
> > >> support.
> > >
> > > I don't think that's a good idea. It would enable it everywhere on
> > > distributions which compile with hotadd. Need (2)
> > >
> > >> 2. Instead of checking the max_pfn value in pci_swiotlb_detect, check
> > >> for max_hotpluggable_pfn (or some such) value. Though I don't see such a
> > >> value readily available. I could parse the SRAT and get hotplug memory
> > >> information but that will make swiotlb detection logic a little too
> > >> complex. A quick look around srat_xx.c files and the acpi_memhotplug
> > >> module didn't find any useful API that could be used directly either.
> > >> So was wondering if any of you are aware of an easy way to get such
> > >> information ?
> > >
> > > I have a patchkit to revamp the SRAT parsing to store the hotadd information
> > 
> > There is a late mechanism to do kickoff the SWIOTLB. Perhaps the hot-add
> > could use swiotlb_init_late and start up the SWIOTLB?
> 
> I guess that you are talking about
> swiotlb_late_init_with_default_size(), which IA64 uses. However, you
> can use swiotlb_late_init_with_default_size() only before we
> initialize devices. Making it work after initializing devices is not
> so easy, I think (that is, we need to change dma_ops).

That is a good point. Especially if we have some outstanding DMA pages
allocated via dma_alloc_coherent.

I thought that the machines that have hot-add memory they have their
own fancy IOMMU. For example the IBM x3955 (and its family) utilize the
Calgary IOMMU. The HP boxes utilize the Intel VT-D (or the AMD
equivalant).

So is this mostly specialized in the areas of virtualized guests? (Xen
PV guests with PCI passthrough suffer the same problem, btw).
