Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab1HJJ7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:59:12 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:47024 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab1HJJ7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <20110605062702.GA2034@cynthia.pants.nu>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
	<alpine.OSX.2.00.1106011300550.199@ibook.intranet>
	<20110605062702.GA2034@cynthia.pants.nu>
Date: Wed, 10 Aug 2011 11:59:08 +0200
X-Google-Sender-Auth: GRbxXk-5oAF_oat_bCylhmtoUkg
Message-ID: <CAMuHMdXVt5+nCaCSH3+z0fsL+vhOOTgbKsOAses8OudT-1OZGQ@mail.gmail.com>
Subject: Re: m68k: Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Brad Boyer <flar@allandria.com>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 08:27, Brad Boyer <flar@allandria.com> wrote:
> If we could really map all the interrupt controllers, we could probably
> cut down on the largest interrupt number. Most Macs really only have
> 20 or 30 actual interrupt sources. The problem is the two or three
> layers of cascaded mess. None of them have just a single layer. Just
> getting rid of the fixed global mapping could take us down to 64 since
> nothing has both Baboon and PSC, but we have unique numbers for them.
> We have 3 whole blocks of 8 just for PSC, even though that's just in
> two models. We don't even know what most of those do, if anything.

While looking into optimizing interrupts using chain handlers (which cannot
be shared), I noticed several of these cascades are hung on the same interrupt.
Hence we cannot use the optimization of chain handlers for them.

Knowing which are mutually exclusive helps a lot, but my Mac knowledge is
very limited.

I derived from the code this list of cascade handlers and the
interrupts they use:

baboon_irq
    IRQ_NUBUS_C

oss_irq
    OSS_IRQLEV_SCSI = IRQ_AUTO_2                conflict: via2_irq
    OSS_IRQLEV_SOUND = IRQ_AUTO_5               conflict: psc_irq

oss_nubus_irq
    OSS_IRQLEV_NUBUS = IRQ_AUTO_3               conflict: psc_irq

psc_irq
    IRQ_AUTO_3                                  conflict: oss_nubus_irq
    IRQ_AUTO_4
    IRQ_AUTO_5                                  conflict: oss_irq
    IRQ_AUTO_6                                  conflict: via1_irq

via1_irq
    OSS_IRQLEV_VIA1 = IRQ_AUTO_6 (on oss)       conflict: psc_irq

    IRQ_AUTO_1                                  conflict: iop_ism_irq
    IRQ_AUTO_6 (if via_alt_mapping)             conflict: psc_irq

via2_irq
    IRQ_AUTO_2                                  conflict: oss_irq

via_nubus_irq
    IRQ_MAC_NUBUS = IRQ_VIA2_1

These are other interrupts using in the Mac core code, which may use the same
interrupts as some of the cascades above:

iop_ism_irq
    OSS_IRQLEV_IOPISM = 1 = IRQ_AUTO_1 (on oss) conflict: via1_irq
    IRQ_VIA2_0 (on !oss)

mac_nmi_handler
    IRQ_AUTO_7

timer handler
    IRQ_MAC_TIMER_1 = IRQ_VIA1_6

So baboon and PSC are mutually exclusive? But they don't conflict w.r.t. to
interrupt lines anyway, so they're not an issue.

>From the code, OSS and VIA are also mutually exclusive (except for via1_irq)?

But PSC can coexist with OSS? That's where most of the conflicts are.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
