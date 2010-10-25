Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356Ab0JYSZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 14:25:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59737 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab0JYSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 14:25:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 06/18] ARM: LPAE: Introduce the 3-level page table format definitions
Date: Mon, 25 Oct 2010 20:25:24 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36+; KDE/4.5.1; x86_64; ; )
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org
References: <20101025085812.25275.55757.stgit@e102109-lin.cambridge.arm.com> <201010251525.09002.arnd@arndb.de> <1288023534.14756.109.camel@e102109-lin.cambridge.arm.com>
In-Reply-To: <1288023534.14756.109.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010252025.24128.arnd@arndb.de>
X-Provags-ID: V02:K0:7AWMATjM3kEZyoXYbGb1KBzHUqvtdzjoiUCLBE5fwLd
 U4O4hJHj4cC50wZUOHFwXx9S+895YCl0lyYZrjfX07hAb0jD0P
 3OD1Hx85d2khRBumJnyJGO3mW00DH1M351Jc4eZEPQfD2M3Tey
 VOX3UD1h6tB3ClfsNh7rU/4l65zb6xOSM1YvLPHdeceMv5qDI2
 XOg85VjNQbl134/tBtLuQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 October 2010 18:18:54 Catalin Marinas wrote:
> On Mon, 2010-10-25 at 14:25 +0100, Arnd Bergmann wrote:
> > On Monday 25 October 2010, Catalin Marinas wrote:
> > > On Mon, 2010-10-25 at 12:15 +0100, Arnd Bergmann wrote:
> > > > On Monday 25 October 2010, Catalin Marinas wrote:
> > > >
> > > > Since the PGD is so extremely small, would it be possible to fold it
> > > > into the mm_context_t in order to save an allocation?
> > > > Or does the PGD still require page alignment?
> > >
> > > There are alignment restrictions, though not to a page size. Given the
> > > TTBR0 access range of the full 4GB (TTBCR.T0SZ = 0), the alignment
> > > required is 64 (2^6). We get this for the slab allocator anyway when the
> > > L1_CACHE_SHIFT is 6 but I could make this requirement explicit by
> > > creating a kmem_cache with the required alignment.
> > 
> > I think you only need to set ARCH_MIN_TASKALIGN for that, which
> > also defaults to L1_CACHE_SHIFT.
> 
> The mm_context_t is part of mm_struct, so I'm not sure how
> ARCH_MIN_TASKALIGN would affect this (unless I misunderstood your
> point).

Sorry about that, I was following the wrong code path. It should
be ARCH_MIN_MMSTRUCT_ALIGN, which is normally zero.

> > I was only talking about the Virtualization Extensions, my impression from
> > the information that is publically available was that you'd only need
> > to set some mode bits differently in order to make the virtual address
> > space (I suppose that's what you call IPA) up to 40 bits instead of 32,
> > and you'd be able to have the guest use a 40 bit physical address space
> > from that.
> 
> You can look at the IPA as the virtual address translation set up by the
> hypervisor (stage 2 translation). The guest OS only sets up stage 1
> translations but can use 40-bit physical addresses (via stage 1) with or
> without the hypervisor. The input to the stage 1 translations is always
> 32-bit.


Right, that's what I thought.

> > Are there any significant differences to Linux between setting up page
> > tables for a 32 bit VA space or a 40 bit IPA space, other than the
> > size of the PGD?
> 
> I think I get what you were asking :).
> 
> >From KVM you could indeed set up stage 2 translations that a guest OS
> can use (you need some code running in hypervisor mode to turn this on).
> The format is pretty close to the stage 1 tables, so the Linux macros
> could be reused. The PGD size would be different (depending on whether
> you want to emulate 40-bit physical address space or a 32-bit one).
> There are also a few bits (memory attributes) that may differ but you
> could handle them in KVM.
> 
> If KVM would reuse the existing pgd/pmd/pte Linux macros, it would
> indeed be restricted to 32-bit IPA (sizeof(long)). You may need to
> define different macros to use either a pfn or long long as address
> input.

Ok.

> But if KVM uses qemu for platform emulation, this may only support
> 32-bit physical address space so the guest OS could only generate 32-bit
> IPA.

Good point. At the very least, qemu would need a way to get at the highmem
portion of the guest that is not normally part of the qemu virtual address
space. In fact this would already be required without LPAE in order to run
a VM with 4GB guest physical addressing.

There are probable (slow) ways of doing that, e.g. remap_file_pages or
a new syscall for accessing high guest memory. It's not entirely clear
to me how useful that is, the most sensible way to start here is certainly
to start out with a 32-bit IPA as you suggested and see how badly that
limits guests in real-world setups.

	Arnd
