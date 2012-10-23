Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2JWCRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 22:17:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:59822 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab2JWCRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 22:17:04 -0400
Message-ID: <1350955556.2728.18.camel@pasglop>
Subject: Re: [RESEND PATCH 2/4] asm-generic: io: don't perform swab during
 {in,out} string functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Date: Tue, 23 Oct 2012 12:25:56 +1100
In-Reply-To: <CAMuHMdWH3GXJ_dW-FCAX=LAkBuQmQtwRUtNpcqg_afm-UFK_2g@mail.gmail.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
	 <1350488704-3711-3-git-send-email-will.deacon@arm.com>
	 <CAMuHMdXcQjDyen+o5aH=1zUOkNX-cfT3aXBOgCpyop=V67jk7w@mail.gmail.com>
	 <1350518655.4678.120.camel@pasglop>
	 <CAMuHMdWH3GXJ_dW-FCAX=LAkBuQmQtwRUtNpcqg_afm-UFK_2g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-18 at 07:48 +0200, Geert Uytterhoeven wrote:

> So assume you have the bytestream "Hello, world!\n" in memory on the
> PCI device.I.e.
> 
> 00000000  48 65 6c 6c 6f 2c 20 77  6f 72 6c 64 21 0a        |Hello, world!.|
> 
> You want to copy it to system RAM using readsl(), which does:
> 
>                u32 *buf = buffer;
>                do {
>                        u32 x = __raw_readl(addr + PCI_IOBASE);
>                        *buf++ = x;
>                 } while (--count);
> 
> On little endian, the first __raw_readl() should return "0x6c6c6548", so
> it is stored correctly by "*buf = x ".

Right.

> On big endian, the first __raw_readl() should return "0x48656c6c" instead,
> else it's stored incorrectly by "*buf = x ".
> But the PCI bus is little endian, so I expect __raw_readl() would return
> "0x6c6c6548", and thus needs swapping?

No. The PCI bus will return 0x48656c6c.

This is due to how the PCI bus is wired to the CPU bus, which is called
"byte address invariant". When doing a read of your byte 0, the CPU will
effectively read 0 with byte enables picking 48. Since the CPU wants
the first byte in the MSB, the bus must be wired up to the CPU such that
the MSB is the first byte in address order.

This is how a BE CPU is normally wired to a LE bus. The fact that a
register needs to be swapped comes from the fact that the device will
put the MSB in the higher address byte, which then corresponds to the
LSB on the BE CPU -> needs swapping.

But for a byte stream, as you can see, no swapping is required.

To some extent, it looks as if the wiring is byte swapped, in order to
provide the byte address invariance (and thus causes registers to look
byteswapped) but it's really not, it's just a convention.

> On m68k (classic with MMU), the situation is a bit more complicated, as some ISA
> (or PCMCIA) busses are physically wired swapped. But inw() and insw() always do
> either both swapping, or both no swapping. The state of support for ISA drivers
> is a bit vague, though.

Then something is horribly wrong in those m68k setups :-) Either in the
way the busses are wired or in your implementation of either inw or
insw.

> Now, on m68k without MMU, inw() doesn't do swapping, but insw() does.
> This agrees more or less with you and Will, except that the bus seems to be
> physically swapped?

Yeah that's possible. In the early days people incorrectly thought it
would be smart to do that, thus avoiding a byteswap for register
accesses .... and causing all data (DMA or FIFO) to be all backward.

That's for example why the disks in the Tivo are byteswapped 16-bit by
16-bit on the platter (ie, all the data is).

I wouldn't be surprised if some 68k suffered from similar HW designer
stupidity.

But the "proper" generic rule is byte address invariance, and that
implies swap on register access and no swap on byte streams.

Cheers,
Ben.


> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arch" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


