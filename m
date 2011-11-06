Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab1KFTH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 14:07:57 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52558 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084Ab1KFTH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 14:07:56 -0500
MIME-Version: 1.0
In-Reply-To: <1320593057.14081.107.camel@deneb.redhat.com>
References: <1320179267.14825.107.camel@deneb.redhat.com> <CA+55aFxXVwX6Y8Nw+V6k0niZ==fxAGfE=-FDYz8nCV4Pw9HEyw@mail.gmail.com>
 <1320529182.14081.78.camel@deneb.redhat.com> <CA+55aFyypNAZAk0LQU7pFf+W2+6sdZwqQx5X8DLy0gWbfvjVsw@mail.gmail.com>
 <1320593057.14081.107.camel@deneb.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 6 Nov 2011 11:07:34 -0800
X-Google-Sender-Auth: r9ianV4eg_oQMqrmGbiBVY1eVV8
Message-ID: <CA+55aFwodK9Z7cUu4bdhmOcR2L3R_fBYdTyJv6iQKcYFrH2Xew@mail.gmail.com>
Subject: Re: [PULL] Add support for Texas Instruments C6X architecture
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 6, 2011 at 7:24 AM, Mark Salter <msalter@redhat.com> wrote:
>
> I think the best counter argument is that it leads to paddr != vaddr
> in the case of NOMMU with a non-zero memory base. My view is that in
> all NOMMU cases, physical and virtual addresses should be the same.
> Otherwise, you end up breaking drivers which need to pass physical
> addresses to devices.

That's a totally insane argument.

Quite frankly, if this is what things rest on, I really *really* don't
want to take the change.

It's a broken argument. It's stupid.

AND IT ISN'T EVEN TRUE!

The "device view" of memory need not at all be the same as the CPU
view, and that has absolutely nothing to do with CPU MMU remapping.

There is a very good reason why we consider "virtual" != "physical" !=
"bus dma" address, and it's very simple: they aren't the same things
at all.

I think some 32-bit PowerPC chips, for example, will see "physical
address zero" at zero (for the CPU), but the devices on the PCI bus
consider "address zero" to be the PCI memory mapping. The devices see
physical RAM starting at DMA address 0x80000000, while for the CPU,
thats's where PCI MMIO lives.

Dammit, if a driver needs to pass a DMA address, that driver will
absolutely need to translate virtual (*or* physical) addresses to
"bus" addresses. End of story. Trying to even *imply* anything else is
pure and utter garbage, and saying that virtual addresses have to
match physical ones in order to not break drivers is drivel that I am
not at all interested in hearing.

Of course, reality is even more complicated than that, and the "bus
address" may well depend on the particular bus the device lives on. So
these days we don't even really encourage the simple mappings like
"virt_to_bus()" any more, we use bus-specific DMA helper functions to
allocate and map the DMA addresses

I suggest you sit down with some other embedded developers and think
about it, and if you all can come up with a good argument for why
things should work a particular way, we can do it that way (regardless
of what that way is). The PowerPC people have seen all the craziness
there is, they would be good to talk to. They also tend to have some
of the more complicated setups.

I'm not saying that <asm-generic/page.h> should necessarily be the
most generic and complicated model out there (perhaps the reverse -
complicated models can use their own arch-specific ones), but I do
think that it should *not* be based on broken assumptions like "dma ==
physical == virtual" address, and encourage a model where simple
architectures don't need any mapping at all. Because that is NOT TRUE,
and has nothing to do with MMU or not-MMU.

So right now I'm not going to merge this, especially when the
arguments for the change are not ones I consider
to be even remotely valid.

And my gut feel is that architectures should *aim* at "pfn's" starting
basically at zero. I'm not saying it's a requirement, and I can be
convinced otherwise, but you should strive to think of pfn's as
"physical page indexes". If memory fundamentally starts at some
specific offset, and there cannot be RAM below that offset, then my
gut feel is that the right define for virt_to_pfn() on such an
architecture would be to subtract the offset and then shift by the
page size.

(Btw, that's not what PPC32 does - it has some "MEMORY_START" logic
which is actually fairly complex. Maybe they had reasons for their
choice, and maybe they are historical. But I want more discussion
about what the "asm-generic/page.h" implementation should be, and I
think the C6x changes are counter-intuitive)

                             Linus
