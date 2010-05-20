Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205Ab0ETOff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 10:35:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754826Ab0ETOfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 10:35:34 -0400
Date: Thu, 20 May 2010 07:32:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Barry Song <21cnbao@gmail.com>
cc: Chris Metcalf <cmetcalf@tilera.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
In-Reply-To: <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005200723210.23538@i5.linux-foundation.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <AANLkTilpV71K2L2N1B85yRnlTc302KbMUz2P5kuvktyl@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Barry Song wrote:

> On Thu, May 20, 2010 at 1:43 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> >
> >  static __always_inline void *lowmem_page_address(struct page *page)
> >  {
> > -       return __va(page_to_pfn(page) << PAGE_SHIFT);
> > +       return __va((phys_addr_t)page_to_pfn(page) << PAGE_SHIFT);
> 
> Here doesn't make sense. you give a u64 type cast, but change the
> meaning of pfn. Is pfn phys_addr_t? Anyway, page_to_pfn can be
> re-fulfilled in your arch, but not change it in common code.

No, it actually makes a lot of sense.

The PFN may well be 32-bit, but then shifting it by PAGE_SHIFT turns the 
PFN from a PFN to a physical address. So the cast makes sense as a way to 
make sure that the code allows a 32-bit PFN with a 64-bit physical 
address.

So I don't thionk there's anything tile-specific about it, and it looks 
like a sane patch. If anything, it might make some sense to make this an 
explicit thing, ie have a "pfn_to_phys()" helper, because there's a _lot_ 
of these things open-coded.

And some of them actually have the cast already. See for example

	#define pfn_to_nid(pfn)	pa_to_nid(((u64)(pfn) << PAGE_SHIFT))

in the alpha <asm/mmzone.h>. Also:

	resource_size_t offset = ((resource_size_t)pfn) << PAGE_SHIFT;

in the powerpc PCI code, of

	#define page_to_phys(page)  ((dma_addr_t)page_to_pfn(page) << PAGE_SHIFT)

in the x86 io code.

In fact, UM has that "pfn_to_phys()" helper already (and has a (phys_t) 
cast).

So we do already have a lot of casts (just grep for "pfn.*<<.*SHIFT" and 
you'll see them in generic code already, and the new one for tile makes 
100% sense. In fact, we should clean up the existing ones.

		Linus
