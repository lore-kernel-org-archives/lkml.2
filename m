Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab2JQTQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 15:16:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40073 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932475Ab2JQTQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 15:16:12 -0400
MIME-Version: 1.0
In-Reply-To: <1350488704-3711-3-git-send-email-will.deacon@arm.com>
References: <1350488704-3711-1-git-send-email-will.deacon@arm.com>
	<1350488704-3711-3-git-send-email-will.deacon@arm.com>
Date: Wed, 17 Oct 2012 21:16:10 +0200
X-Google-Sender-Auth: M7_rdqBrACR452gBdK5H-C2prUk
Message-ID: <CAMuHMdXcQjDyen+o5aH=1zUOkNX-cfT3aXBOgCpyop=V67jk7w@mail.gmail.com>
Subject: Re: [RESEND PATCH 2/4] asm-generic: io: don't perform swab during
 {in,out} string functions
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 5:45 PM, Will Deacon <will.deacon@arm.com> wrote:
> The {in,out}s{b,w,l} functions are designed to operate on a stream of
> bytes and therefore should not perform any byte-swapping, regardless of
> the CPU byte order.

Euh?

They transfer a stream of bytes between memory and PCI/ISA I/O space by
reading from/writing to a single I/O port of width 8, 16, or 32 bits.
On big endian machines, I/O port accesses may need to be swapped.

> This patch fixes the generic IO header so that {in,out}s{b,w,l} call
> the __raw_{read,write} functions directly rather than going via the
> endian-correcting accessors.

Furthermore __raw_*() has different semantics besides endianness, like
ordering barriers. So you can't just change one for the other.

> Cc: Mike Frysinger <vapier@gentoo.org>
> Cc: Ben Herrenschmidt <benh@kernel.crashing.org>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  include/asm-generic/io.h |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index 3607921..403b861 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -148,7 +148,7 @@ static inline void insb(unsigned long addr, void *buffer, int count)

The "addr" parameter is actually a misnomer. Probably it should be "port".
Oops, inb() and friends also use "addr".

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
