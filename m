Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab2JRFsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:48:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:44197 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2JRFsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:48:17 -0400
MIME-Version: 1.0
In-Reply-To: <1350518655.4678.120.camel@pasglop>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
	<1350488704-3711-3-git-send-email-will.deacon@arm.com>
	<CAMuHMdXcQjDyen+o5aH=1zUOkNX-cfT3aXBOgCpyop=V67jk7w@mail.gmail.com>
	<1350518655.4678.120.camel@pasglop>
Date: Thu, 18 Oct 2012 07:48:16 +0200
X-Google-Sender-Auth: dtFM8yD2GBcfNMFQ1otY-_ZZg84
Message-ID: <CAMuHMdWH3GXJ_dW-FCAX=LAkBuQmQtwRUtNpcqg_afm-UFK_2g@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/4] asm-generic: io: don't perform swab during
 {in,out} string functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, Oct 18, 2012 at 2:04 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Wed, 2012-10-17 at 21:16 +0200, Geert Uytterhoeven wrote:
>> On Wed, Oct 17, 2012 at 5:45 PM, Will Deacon <will.deacon@arm.com> wrote:
>> > The {in,out}s{b,w,l} functions are designed to operate on a stream of
>> > bytes and therefore should not perform any byte-swapping, regardless of
>> > the CPU byte order.
>>
>> Euh?
>
> Will is perfectly right :-)
>
>> They transfer a stream of bytes between memory and PCI/ISA I/O space by
>> reading from/writing to a single I/O port of width 8, 16, or 32 bits.
>> On big endian machines, I/O port accesses may need to be swapped.
>
> No. Not for streams. I suggest you watch the recording of my Plumbers
> talk :-)

I will. But as email text on lkml is easier to refer to than videos, I
will continue below,
so yo can refute me in plain text ;-)

> The sort story is that endianness is not a property of the IO port but
> of the information that transit through it. If you're just going to copy
> it into memory, you want to preserve it's format and so do not byteswap.
>
> The byteswap we do on standard accessors is a "helper" because we assume
> that underneath those IO ports are registers that are Little Endian. But
> when using one as a window to a byte stream, we must not arbitrarily
> swap the byte stream. We copy it as-is to memory, and then one can work
> at interpreting the various fields that might or might not be present in
> that stream with the appropriate accessors for memory accesses.

So assume you have the bytestream "Hello, world!\n" in memory on the
PCI device.I.e.

00000000  48 65 6c 6c 6f 2c 20 77  6f 72 6c 64 21 0a        |Hello, world!.|

You want to copy it to system RAM using readsl(), which does:

               u32 *buf = buffer;
               do {
                       u32 x = __raw_readl(addr + PCI_IOBASE);
                       *buf++ = x;
                } while (--count);

On little endian, the first __raw_readl() should return "0x6c6c6548", so
it is stored correctly by "*buf = x ".
On big endian, the first __raw_readl() should return "0x48656c6c" instead,
else it's stored incorrectly by "*buf = x ".
But the PCI bus is little endian, so I expect __raw_readl() would return
"0x6c6c6548", and thus needs swapping?

On m68k (classic with MMU), the situation is a bit more complicated, as some ISA
(or PCMCIA) busses are physically wired swapped. But inw() and insw() always do
either both swapping, or both no swapping. The state of support for ISA drivers
is a bit vague, though.

Now, on m68k without MMU, inw() doesn't do swapping, but insw() does.
This agrees more or less with you and Will, except that the bus seems to be
physically swapped?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
