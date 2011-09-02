Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1IBTxn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:53:43 -0400
Received: from www.linutronix.de ([62.245.132.108]:36761 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105Ab1IBTxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:53:40 -0400
Date: Fri, 2 Sep 2011 21:53:36 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Finn Thain <fthain@telegraphics.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: m68k: [v5] Convert to genirq (WIP)
In-Reply-To: <CAMuHMdVmNAOSK+M9z-ySOR-oA4LwuS_N0SZ8XxzQ9_pYqM_vdQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1109022152210.2723@ionos>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com> <alpine.OSX.2.00.1108271506320.190@ibook.local> <alpine.OSX.2.00.1108300148040.435@ibook.local> <CAMuHMdVmNAOSK+M9z-ySOR-oA4LwuS_N0SZ8XxzQ9_pYqM_vdQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1902576084-1314993217=:2723"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1902576084-1314993217=:2723
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 2 Sep 2011, Geert Uytterhoeven wrote:

> On Fri, Sep 2, 2011 at 14:14, Finn Thain <fthain@telegraphics.com.au> wrote:
> > On Sun, 28 Aug 2011, I wrote:
> > However, I found another problem. pmac_zilog oopses when its TTY is closed
> > (see below). And macsonic does the same when the NIC is closed. The trace
> > says that irq_shutdown() died trying to call the chip irq_mask routine,
> > when desc->irq_data.chip (in a0) was NULL. Any ideas?
> 
> > Unable to handle kernel NULL pointer dereference at virtual address   (null)
> > Oops: 00000000
> > Modules linked in:
> > PC: [<00000000>]   (null)
> 
> No, it calls a function pointer that's NULL.
> 
> void irq_shutdown(struct irq_desc *desc)
> {
>         irq_state_set_disabled(desc);
>         desc->depth = 1;
>         if (desc->irq_data.chip->irq_shutdown)
>                 desc->irq_data.chip->irq_shutdown(&desc->irq_data);
>         if (desc->irq_data.chip->irq_disable)
>                 desc->irq_data.chip->irq_disable(&desc->irq_data);
>         else
>                 desc->irq_data.chip->irq_mask(&desc->irq_data);
>         irq_state_set_masked(desc);
> }
> 
> Oops, seems I misread the code and assumed the second "if" was an "else if",

I think that was supposed to be an "else if". Lemme look at the code
before the overhaul to be sure.

> as I wrote down in my notes that it calls only one of the 3 functions :-(
> But it does need either .irq_disable() or .irq_mask().
> 
> The following irq_chip structs have both .irq_disable() and .irq_mask() NULL:
>   - arch/m68k/apollo/dn_ints.c:apollo_irq_chip
>   - arch/m68k/kernel/ints.c:auto_irq_chip
>   - arch/m68k/kernel/ints.c:user_irq_chip
> 
> Since this is on Mac and mac_irq_chip is OK, I guess this is a non-PSC Mac,
> i.e. the IRQ number is IRQ_MAC_SCC == IRQ_AUTO_4?
> 
> Thomas: As we cannot disable or mask autovector interrupts at the
> autovector level,
> IMHO it doesn't make much sense do add a dummy .irq_mask() function.
> Can we add an extra check in irq_shutdown() to not call .irq_mask() if
> it's NULL?

Yes.

Thanks,

	tglx
--8323328-1902576084-1314993217=:2723--
