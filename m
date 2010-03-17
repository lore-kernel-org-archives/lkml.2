Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756342Ab0CQWsg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 18:48:36 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:19382 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756221Ab0CQWse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 18:48:34 -0400
Subject: Re: [LKML] Re: [LKML] Re: swiotlb detection should be memory
	hotplug aware ?
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       "ak@linux.intel.com" <ak@linux.intel.com>,
       "lenb@kernel.org" <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Petr Vandrovec <petr@vmware.com>
In-Reply-To: <20100316124556.GA25340@phenom.dumpdata.com>
References: <1268446032.13691.69.camel@ank32>
	 <4B9B01F5.3000807@linux.intel.com>
	 <20100316005140.GB7622@phenom.dumpdata.com>
	 <20100316103259E.fujita.tomonori@lab.ntt.co.jp>
	 <20100316124556.GA25340@phenom.dumpdata.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Wed, 17 Mar 2010 15:48:33 -0700
Message-Id: <1268866113.20507.26.camel@ank32>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2010-03-16 at 05:45 -0700, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 16, 2010 at 10:33:20AM +0900, FUJITA Tomonori wrote:
> > On Mon, 15 Mar 2010 20:51:40 -0400
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > On Fri, Mar 12, 2010 at 07:09:41PM -0800, Andi Kleen wrote:
> > > > , Alok Kataria wrote:
> > > >
> > > > Hi Alok,
> > > >
> > > >> Hi,
> > > >>
> > > >> Looking at the current code swiotlb is initialized for 64bit kernels
> > > >> only when the max_pfn value is greater than 4G (MAX_DMA32_PFN value).
> > > >> So in cases when the initial memory is less than 4GB the kernel boots
> > > >> without enabling swiotlb, when we hotadd memory to such a kernel and go
> > > >> beyond the 4G limit, swiotlb is still disabled. As a result when any
> > > >> 32bit devices start using this newly added memory beyond 4G, the kernel
> > > >> starts spitting error messages like below or in some cases it causes
> > > >> kernel panics.
> > > >
> > > > Yes seems like a real problem.
> > > >
> > > >>
> > > >> 1. Enable swiotlb for all 64bit kernels which have memory hot-add
> > > >> support.
> > > >
> > > > I don't think that's a good idea. It would enable it everywhere on
> > > > distributions which compile with hotadd. Need (2)
> > > >
> > > >> 2. Instead of checking the max_pfn value in pci_swiotlb_detect, check
> > > >> for max_hotpluggable_pfn (or some such) value. Though I don't see such a
> > > >> value readily available. I could parse the SRAT and get hotplug memory
> > > >> information but that will make swiotlb detection logic a little too
> > > >> complex. A quick look around srat_xx.c files and the acpi_memhotplug
> > > >> module didn't find any useful API that could be used directly either.
> > > >> So was wondering if any of you are aware of an easy way to get such
> > > >> information ?
> > > >
> > > > I have a patchkit to revamp the SRAT parsing to store the hotadd information
> > > 

Andi...ping any pointers to the patchkit. 

> > > There is a late mechanism to do kickoff the SWIOTLB. Perhaps the hot-add
> > > could use swiotlb_init_late and start up the SWIOTLB?

I don't see why we need to do this via late_init, swiotlb detection that
happens through pci_swiotlb_detect, is already late enough that SRAT is
already parsed. Or am I missing something ?
> > 
> > I guess that you are talking about
> > swiotlb_late_init_with_default_size(), which IA64 uses. However, you
> > can use swiotlb_late_init_with_default_size() only before we
> > initialize devices. Making it work after initializing devices is not
> > so easy, I think (that is, we need to change dma_ops).

> That is a good point. Especially if we have some outstanding DMA pages
> allocated via dma_alloc_coherent.
> 
> I thought that the machines that have hot-add memory they have their
> own fancy IOMMU. For example the IBM x3955 (and its family) utilize the
> Calgary IOMMU. The HP boxes utilize the Intel VT-D (or the AMD
> equivalant).
> So is this mostly specialized in the areas of virtualized guests? (Xen
> PV guests with PCI passthrough suffer the same problem, btw).


I am assuming that there were Intel based servers which supported memory
hot-add before VT-d too. So, IMO this is not specialized to
virtualization, though might be hard to prove if there are actual
physical machines out there which have similar constraints (no HWIOMMU +
MEMHOT add support)

Thanks,
Alok

