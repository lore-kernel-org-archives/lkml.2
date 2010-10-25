Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871Ab0JYQTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 12:19:06 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41444 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755259Ab0JYQTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:19:04 -0400
Subject: Re: [RFC PATCH 06/18] ARM: LPAE: Introduce the 3-level page table
 format definitions
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <201010251525.09002.arnd@arndb.de>
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com>
	 <201010251315.53304.arnd@arndb.de>
	 <1288007977.14756.41.camel@e102109-lin.cambridge.arm.com>
	 <201010251525.09002.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Organization: ARM Limited
Date: Mon, 25 Oct 2010 17:18:54 +0100
Message-ID: <1288023534.14756.109.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Oct 2010 16:18:54.0243 (UTC) FILETIME=[5173FF30:01CB7460]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-25 at 14:25 +0100, Arnd Bergmann wrote:
> On Monday 25 October 2010, Catalin Marinas wrote:
> > On Mon, 2010-10-25 at 12:15 +0100, Arnd Bergmann wrote:
> > > On Monday 25 October 2010, Catalin Marinas wrote:
> > >
> > > Since the PGD is so extremely small, would it be possible to fold it
> > > into the mm_context_t in order to save an allocation?
> > > Or does the PGD still require page alignment?
> >
> > There are alignment restrictions, though not to a page size. Given the
> > TTBR0 access range of the full 4GB (TTBCR.T0SZ = 0), the alignment
> > required is 64 (2^6). We get this for the slab allocator anyway when the
> > L1_CACHE_SHIFT is 6 but I could make this requirement explicit by
> > creating a kmem_cache with the required alignment.
> 
> I think you only need to set ARCH_MIN_TASKALIGN for that, which
> also defaults to L1_CACHE_SHIFT.

The mm_context_t is part of mm_struct, so I'm not sure how
ARCH_MIN_TASKALIGN would affect this (unless I misunderstood your
point).

> > > Do you also have patches to allow 40-bit virtual space? I suppose we
> > > will need that for KVM support in the future.
> >
> > I'm not sure how these would look like since the architecture is 32-bit
> > (and I'm not familiar with KVM). With the MMU disabled, you can't access
> > beyond the 4GB space anyway. KVM could use something like the pfn but in
> > the virtual space.
> >
> > Cortex-A15 comes with both LPAE and Virtualisation Extensions, so the
> > latter could be used for something like KVM. There is another stage of
> > page table translations, so the one set up by Linux actually generates
> > an intermediate physical address (IPA) which gets translated to the real
> > PA in the second stage. The IPA is 40-bit wide.
> 
> I was only talking about the Virtualization Extensions, my impression from
> the information that is publically available was that you'd only need
> to set some mode bits differently in order to make the virtual address
> space (I suppose that's what you call IPA) up to 40 bits instead of 32,
> and you'd be able to have the guest use a 40 bit physical address space
> from that.

You can look at the IPA as the virtual address translation set up by the
hypervisor (stage 2 translation). The guest OS only sets up stage 1
translations but can use 40-bit physical addresses (via stage 1) with or
without the hypervisor. The input to the stage 1 translations is always
32-bit.

> Are there any significant differences to Linux between setting up page
> tables for a 32 bit VA space or a 40 bit IPA space, other than the
> size of the PGD?

I think I get what you were asking :).

>From KVM you could indeed set up stage 2 translations that a guest OS
can use (you need some code running in hypervisor mode to turn this on).
The format is pretty close to the stage 1 tables, so the Linux macros
could be reused. The PGD size would be different (depending on whether
you want to emulate 40-bit physical address space or a 32-bit one).
There are also a few bits (memory attributes) that may differ but you
could handle them in KVM.

If KVM would reuse the existing pgd/pmd/pte Linux macros, it would
indeed be restricted to 32-bit IPA (sizeof(long)). You may need to
define different macros to use either a pfn or long long as address
input.

But if KVM uses qemu for platform emulation, this may only support
32-bit physical address space so the guest OS could only generate 32-bit
IPA.

Catalin

