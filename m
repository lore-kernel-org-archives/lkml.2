Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1KHSJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:09:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab1KHSJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:09:04 -0500
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
From: Mark Salter <msalter@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "JACQUIOT-XID, Aurelien" <a-jacquiot@ti.com>,
        Arnd Bergmann <arnd@arndb.de>
Date: Tue, 08 Nov 2011 13:08:56 -0500
In-Reply-To: <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
References: <1320179267.14825.107.camel@deneb.redhat.com>
	 <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
	 <1320529182.14081.78.camel@deneb.redhat.com>
	 <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1320775737.2382.42.camel@deneb.redhat.com>
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

Having a little time to think about this some more, I'm going to take
another crack at it. Defining __pa/__va with PAGE_OFFSET as they are
currently creates a physical space which doesn't match the hardware
when PAGE_OFFSET is non-zero.

For arches using device tree support, that means that the physical
addresses in the device tree are either linux-specific or early boot
code would have to go through the tree to fixup the "hardware physical"
addresses so that they are "linux physical" addresses for the kernel.

For arches not using device tree, the physical addresses used in headers
or printed out in log messages won't match the hardware documentation.
Not a huge problem, but a PITA for maintenance/debug.

--Mark


