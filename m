Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1LCS4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 13:56:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59008 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1LCS4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 13:56:10 -0500
MIME-Version: 1.0
In-Reply-To: <20111202232243.6af6f1e2@lxorguk.ukuu.org.uk>
References: <20111110151852.GA7465@oksana.dev.rtsoft.ru>
	<20111110152606.GB3207@oksana.dev.rtsoft.ru>
	<20111110153816.239af1d7@lxorguk.ukuu.org.uk>
	<20111110162859.GA7088@oksana.dev.rtsoft.ru>
	<20111202191917.GB3037@localhost.localdomain>
	<20111202232243.6af6f1e2@lxorguk.ukuu.org.uk>
Date: Sat, 3 Dec 2011 19:56:08 +0100
X-Google-Sender-Auth: ocl7CKQ6YtW4QkD5QEcCShYsGCc
Message-ID: <CAMuHMdXvwJ4f6a5Y2+TXn1X3CAg2Ok51f2+n4ye0uTfAVgBC1Q@mail.gmail.com>
Subject: Re: [PATCH] ata: Don't use NO_IRQ in pata_of_platform driver
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        devicetree-discuss@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeff Garzik <jgarzik@redhat.com>, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 3, 2011 at 00:22, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> This is now broken on ARM where, for good or bad, NO_IRQ currently is
>> used and is -1.
>
> Good.
>
> ARM developers have been told to change this for several years. The nice
> approach hasn't worked, the patient approach hasn't worked so now finally
> ARM is going to be dragged kicking and screaming into doing the work
> everyone else did several years ago.
>
> I have so little sympathy over this that you'll need a quantum physicist
> to measure it.
>
>> Half-removing NO_IRQ is going to be problematic, though...
>> I really don't care whether the "no irq" value is 0 or -1, but it is
>> abundantly clear that choosing different values to mean the same thing
>> on opposite sides of an interface does not work.
>
> You've had years to fix it. If I were you I'd delete NO_IRQ from your
> tree, type make and get it done. It's not even a big job to clean it out.
>
> At that point various other drivers will also start working properly on
> ARM because they use 0 for polled mode.

Not just ARM:

arch/arm/include/asm/irq.h:#ifndef
NO_IRQarch/arm/include/asm/irq.h:#define NO_IRQ       ((unsigned
int)(-1))arch/microblaze/include/asm/irq.h:#define NO_IRQ
(-1)arch/mn10300/include/asm/irq.h:#define NO_IRQ
INT_MAXarch/openrisc/include/asm/irq.h:#define NO_IRQ
(-1)arch/parisc/include/asm/irq.h:#define NO_IRQ
(-1)arch/powerpc/include/asm/irq.h:#define NO_IRQ
(0)arch/powerpc/include/asm/machdep.h:     /* Return an irq, or NO_IRQ
to indicate arch/powerpc/include/asm/parport.h:             if (virq
== NO_IRQ)arch/powerpc/include/asm/qe_ic.h:       if (cascade_irq !=
NO_IRQ)arch/powerpc/include/asm/qe_ic.h:       if (cascade_irq !=
NO_IRQ)arch/powerpc/include/asm/qe_ic.h:       if (cascade_irq !=
NO_IRQ)arch/powerpc/include/asm/qe_ic.h:       if (cascade_irq !=
NO_IRQ)arch/powerpc/include/asm/qe_ic.h:       if (cascade_irq ==
NO_IRQ)arch/powerpc/include/asm/qe_ic.h:       if (cascade_irq !=
NO_IRQ)arch/sparc/include/asm/irq_32.h:#define NO_IRQ
0xffffffffarch/sparc/include/asm/irq_64.h:#define NO_IRQ
0xffffffff

And it's not just definitions of NO_IRQ. These are easy to find.
On some archs (notably ARM) zero still seems to be a valid IRQ number,
e.g. IRQ_LOCOMO_KEY and IRQ_DMA0C0.

Also, UML has TIMER_IRQ being zero.

A quick grep found many more IRQ definitions being zero, but
surprisingly the few
I looked into were definitions without users (e.g. SE7343_FPGA_IRQ_MRSHPC0,
ROUTE_VIA_IRQ0 aka IRQ_MB93493_VDC_ROUTE).

Perhaps request_irq() should just reject zero to find all of them?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
