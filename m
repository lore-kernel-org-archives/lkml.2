Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937360Ab0CPBiD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:38:03 -0400
Received: from sh.osrg.net ([192.16.179.4]:56802 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932833Ab0CPBh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:37:58 -0400
Date: Tue, 16 Mar 2010 10:33:20 +0900
To: konrad.wilk@oracle.com
Cc: ak@linux.intel.com, akataria@vmware.com, lenb@kernel.org, x86@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       petr@vmware.com
Subject: Re: [LKML] Re: swiotlb detection should be memory hotplug aware ?
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100316005140.GB7622@phenom.dumpdata.com>
References: <1268446032.13691.69.camel@ank32>
	<4B9B01F5.3000807@linux.intel.com>
	<20100316005140.GB7622@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100316103259E.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 16 Mar 2010 10:33:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Mar 2010 20:51:40 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Fri, Mar 12, 2010 at 07:09:41PM -0800, Andi Kleen wrote:
> > , Alok Kataria wrote:
> >
> > Hi Alok,
> >
> >> Hi,
> >>
> >> Looking at the current code swiotlb is initialized for 64bit kernels
> >> only when the max_pfn value is greater than 4G (MAX_DMA32_PFN value).
> >> So in cases when the initial memory is less than 4GB the kernel boots
> >> without enabling swiotlb, when we hotadd memory to such a kernel and go
> >> beyond the 4G limit, swiotlb is still disabled. As a result when any
> >> 32bit devices start using this newly added memory beyond 4G, the kernel
> >> starts spitting error messages like below or in some cases it causes
> >> kernel panics.
> >
> > Yes seems like a real problem.
> >
> >>
> >> 1. Enable swiotlb for all 64bit kernels which have memory hot-add
> >> support.
> >
> > I don't think that's a good idea. It would enable it everywhere on
> > distributions which compile with hotadd. Need (2)
> >
> >> 2. Instead of checking the max_pfn value in pci_swiotlb_detect, check
> >> for max_hotpluggable_pfn (or some such) value. Though I don't see such a
> >> value readily available. I could parse the SRAT and get hotplug memory
> >> information but that will make swiotlb detection logic a little too
> >> complex. A quick look around srat_xx.c files and the acpi_memhotplug
> >> module didn't find any useful API that could be used directly either.
> >> So was wondering if any of you are aware of an easy way to get such
> >> information ?
> >
> > I have a patchkit to revamp the SRAT parsing to store the hotadd information
> 
> There is a late mechanism to do kickoff the SWIOTLB. Perhaps the hot-add
> could use swiotlb_init_late and start up the SWIOTLB?

I guess that you are talking about
swiotlb_late_init_with_default_size(), which IA64 uses. However, you
can use swiotlb_late_init_with_default_size() only before we
initialize devices. Making it work after initializing devices is not
so easy, I think (that is, we need to change dma_ops).
