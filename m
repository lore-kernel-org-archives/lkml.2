Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071Ab1FPVKM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 17:10:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43294 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab1FPVKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 17:10:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Jxt8BWLHVYGwZ4eZHnTdrYO82Pbc7BUm6aJZhhOrTK8G3Ccq5Z6PcE7d4gIeYzQhZU
         PfyUEvczzHAQXdIdUmEVDa2ge6IidpyqjYM50yeVEhYrzdSgpho9pnnMqRcDMisp0LiV
         nN3vkDNIwTTNrycAIw+PQJIp3H2uCTUvbFVZ4=
MIME-Version: 1.0
In-Reply-To: <BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<BANLkTinDvLqHChPUpG9v1AXp0E=iRLteDg@mail.gmail.com>
Date: Fri, 17 Jun 2011 09:10:08 +1200
Message-ID: <BANLkTi=3L3+3UzAwcybqvNxQXSKf7DERYQ@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Michael Schmitz <schmitzmic@googlemail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 17, 2011 at 7:45 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
Hi Geert,

> This is the WARN_ONCE(!irqs_disabled()) check.
>
> static inline bool arch_irqs_disabled_flags(unsigned long flags)
> {
>        return (flags & ~ALLOWINT) != 0;
> }
>
> with flags = 0x2300. Due to the "special" value of ALLOWINT on Atari:
>
> #if defined(MACH_ATARI_ONLY)
>        /* block out HSYNC on the atari */
> #define ALLOWINT        (~0x400)
> #define MAX_NOINT_IPL   3
> #else
>        /* portable version */
> #define ALLOWINT        (~0x700)
> #define MAX_NOINT_IPL   0
> #endif /* machine compilation types */
>
> the test fails.
>
> Would it harm to always use the "portable" version?
> That one is used on multi-platform kernels anyway?
> Or would it cause too many HBLANK interrupts?

I'd say it would cause too many unnecessary interrupts. At least with
the original Falcon hardware that was a problem (haven't ever tried
this on the CT60). Not sure I tried multi platform kernels in a long
time, either. For these, it would probably required to male ALLOWINT a
runtime optiion in order to avoid this problem (I seem to recall we
used the corresponding hbl interrrupt handler for this originally
since it only was a problem on Falcon, not on TT. Does the TT use IPL
1 and 2, Andreas?).

MAX_NOINT_IPL may not needed any longer because all interrupt and
signal return is now done from assembler code in entry.S, I guess.

Probably best to ignore the two lowest IRQ bits on Atari for the
purpose of this test since these are always going to be disabled.

Cheers,

  Michael


> BTW, MAX_NOINT_IPL is no longer used.
>
> Gr{oetje,eeting}s,
>
>                         Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
>
