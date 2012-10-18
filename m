Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2JRAEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 20:04:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:57969 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab2JRAE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 20:04:29 -0400
Message-ID: <1350518655.4678.120.camel@pasglop>
Subject: Re: [RESEND PATCH 2/4] asm-generic: io: don't perform swab during
 {in,out} string functions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Date: Thu, 18 Oct 2012 11:04:15 +1100
In-Reply-To: <CAMuHMdXcQjDyen+o5aH=1zUOkNX-cfT3aXBOgCpyop=V67jk7w@mail.gmail.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
	 <1350488704-3711-3-git-send-email-will.deacon@arm.com>
	 <CAMuHMdXcQjDyen+o5aH=1zUOkNX-cfT3aXBOgCpyop=V67jk7w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 21:16 +0200, Geert Uytterhoeven wrote:
> On Wed, Oct 17, 2012 at 5:45 PM, Will Deacon <will.deacon@arm.com> wrote:
> > The {in,out}s{b,w,l} functions are designed to operate on a stream of
> > bytes and therefore should not perform any byte-swapping, regardless of
> > the CPU byte order.
> 
> Euh?

Will is perfectly right :-)

> They transfer a stream of bytes between memory and PCI/ISA I/O space by
> reading from/writing to a single I/O port of width 8, 16, or 32 bits.
> On big endian machines, I/O port accesses may need to be swapped.

No. Not for streams. I suggest you watch the recording of my Plumbers
talk :-)

The sort story is that endianness is not a property of the IO port but
of the information that transit through it. If you're just going to copy
it into memory, you want to preserve it's format and so do not byteswap.

The byteswap we do on standard accessors is a "helper" because we assume
that underneath those IO ports are registers that are Little Endian. But
when using one as a window to a byte stream, we must not arbitrarily
swap the byte stream. We copy it as-is to memory, and then one can work
at interpreting the various fields that might or might not be present in
that stream with the appropriate accessors for memory accesses. 

You will notice that all our stream IO functions are similarly
non-swapping on powerpc.

> > This patch fixes the generic IO header so that {in,out}s{b,w,l} call
> > the __raw_{read,write} functions directly rather than going via the
> > endian-correcting accessors.
> 
> Furthermore __raw_*() has different semantics besides endianness, like
> ordering barriers. So you can't just change one for the other.

This is asm-generic. If you need barriers, implement your own. As far as
I can tell, Will is perfectly correct.

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Cheers,
Ben.

> > Cc: Mike Frysinger <vapier@gentoo.org>
> > Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  include/asm-generic/io.h |   12 ++++++------
> >  1 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> > index 3607921..403b861 100644
> > --- a/include/asm-generic/io.h
> > +++ b/include/asm-generic/io.h
> > @@ -148,7 +148,7 @@ static inline void insb(unsigned long addr, void *buffer, int count)
> 
> The "addr" parameter is actually a misnomer. Probably it should be "port".
> Oops, inb() and friends also use "addr".
> 
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


