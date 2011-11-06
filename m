Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753125Ab1KFPYT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 10:24:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616Ab1KFPYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 10:24:18 -0500
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sun, 06 Nov 2011 10:24:16 -0500
In-Reply-To: <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
References: <1320179267.14825.107.camel@deneb.redhat.com>
	 <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
	 <1320529182.14081.78.camel@deneb.redhat.com>
	 <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1320593057.14081.107.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-11-05 at 15:38 -0700, Linus Torvalds wrote:
> On Sat, Nov 5, 2011 at 2:39 PM, Mark Salter <msalter@redhat.com> wrote:
> >
> > Okay, first of all, it doesn't break any old ones. There is one arch
> > that currently uses asm-generic/page.h (blackfin) and that one uses a
> > PAGE_OFFSET of 0x0 and has physical RAM starting at 0x0. My patch (wrong
> > as it may otherwise be) won't break blackfin.
> 
> Ok. And I didn't notice that when you added the PFN_OFFSET, you did
> actually remove the subtraction of PAGE_OFFSET from the
> virtual->physical translation.
> 
> But I don't really understand why you did that. It makes very little sense.
> 
> > Are you saying that PAGE_OFFSET should always be zero in the NOMMU case?
> > Or that ARCH_PFN_OFFSET shouldn't use PAGE_OFFSET (five existing arches
> > use that same definition)?
> 
> So If the memory is mapped at some non-zero offset, what would make
> *sense* to me is have the old
> 
>    #define __pa(x) ((unsigned long)(x) -- PAGE_OFFSET)
> 
> and that should already make sure that then the PFN is in the right
> range, and doesn't need any fixups.
> 
> That's what the old version of the file did, and that seems to be a
> sensible model. Why isn't it?
> 

I think the best counter argument is that it leads to paddr != vaddr
in the case of NOMMU with a non-zero memory base. My view is that in
all NOMMU cases, physical and virtual addresses should be the same.
Otherwise, you end up breaking drivers which need to pass physical
addresses to devices.

Additionally, I think it is perfectly reasonable to have a non-zero
PAGE_OFFSET in the NOMMU case. PAGE_OFFSET is the base of kernel
virtual memory and in the NOMMU case this would match the physical
base of RAM which may be non-zero.

As for PFNs, there seems to be a number of places in the kernel where
the assumption is that PADDR == (PFN << PAGE_SHIFT). For this to hold
true, PFNs cannot be zero-based if RAM is physically based at a non-zero
address. Non zero-based PFNs is what ARCH_PFN_OFFSET is all about. Even
in the MMU case, PFNs are non zero-based for arm, mips, and a few
others. That's how I ended up with ARCH_PFN_OFFSET in the generic
definition of pfn_valid().

After thinking about it some more, the only thing I'd change in that
patch would be the default ARCH_PFN_OFFSET definition. It should either
default to (0), in which case arches would have to define their own, or
I'd use __pa(PAGE_OFFSET) instead of just PAGE_OFFSET so that it is
clear that it is dealing with a physical address.

--Mark


