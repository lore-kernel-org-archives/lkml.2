Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1IBRYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:24:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43611 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab1IBRYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:24:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.OSX.2.00.1108300148040.435@ibook.local>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
	<alpine.OSX.2.00.1108271506320.190@ibook.local>
	<alpine.OSX.2.00.1108300148040.435@ibook.local>
Date: Fri, 2 Sep 2011 19:24:34 +0200
X-Google-Sender-Auth: Yb3DCi0wdTdxc7M3fQ_3eJI0rG0
Message-ID: <CAMuHMdVmNAOSK+M9z-ySOR-oA4LwuS_N0SZ8XxzQ9_pYqM_vdQ@mail.gmail.com>
Subject: Re: m68k: [v5] Convert to genirq (WIP)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Finn Thain <fthain@telegraphics.com.au>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 2, 2011 at 14:14, Finn Thain <fthain@telegraphics.com.au> wrote:
> On Sun, 28 Aug 2011, I wrote:
> However, I found another problem. pmac_zilog oopses when its TTY is closed
> (see below). And macsonic does the same when the NIC is closed. The trace
> says that irq_shutdown() died trying to call the chip irq_mask routine,
> when desc->irq_data.chip (in a0) was NULL. Any ideas?

> Unable to handle kernel NULL pointer dereference at virtual address   (null)
> Oops: 00000000
> Modules linked in:
> PC: [<00000000>]   (null)

No, it calls a function pointer that's NULL.

void irq_shutdown(struct irq_desc *desc)
{
        irq_state_set_disabled(desc);
        desc->depth = 1;
        if (desc->irq_data.chip->irq_shutdown)
                desc->irq_data.chip->irq_shutdown(&desc->irq_data);
        if (desc->irq_data.chip->irq_disable)
                desc->irq_data.chip->irq_disable(&desc->irq_data);
        else
                desc->irq_data.chip->irq_mask(&desc->irq_data);
        irq_state_set_masked(desc);
}

Oops, seems I misread the code and assumed the second "if" was an "else if",
as I wrote down in my notes that it calls only one of the 3 functions :-(
But it does need either .irq_disable() or .irq_mask().

The following irq_chip structs have both .irq_disable() and .irq_mask() NULL:
  - arch/m68k/apollo/dn_ints.c:apollo_irq_chip
  - arch/m68k/kernel/ints.c:auto_irq_chip
  - arch/m68k/kernel/ints.c:user_irq_chip

Since this is on Mac and mac_irq_chip is OK, I guess this is a non-PSC Mac,
i.e. the IRQ number is IRQ_MAC_SCC == IRQ_AUTO_4?

Thomas: As we cannot disable or mask autovector interrupts at the
autovector level,
IMHO it doesn't make much sense do add a dummy .irq_mask() function.
Can we add an extra check in irq_shutdown() to not call .irq_mask() if
it's NULL?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
