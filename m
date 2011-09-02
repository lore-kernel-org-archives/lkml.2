Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1IBSY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 14:24:29 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52399 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab1IBSY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 14:24:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVmNAOSK+M9z-ySOR-oA4LwuS_N0SZ8XxzQ9_pYqM_vdQ@mail.gmail.com>
References: <CAMuHMdUZe0Y55ZPee+umJdEsmY5X-EB-KoC-w-SGEtbPMAcf3g@mail.gmail.com>
	<alpine.OSX.2.00.1108271506320.190@ibook.local>
	<alpine.OSX.2.00.1108300148040.435@ibook.local>
	<CAMuHMdVmNAOSK+M9z-ySOR-oA4LwuS_N0SZ8XxzQ9_pYqM_vdQ@mail.gmail.com>
Date: Fri, 2 Sep 2011 20:24:25 +0200
X-Google-Sender-Auth: t0M2QquGV7206ex9exNX0knYsQs
Message-ID: <CAMuHMdXj-YDFPcsQFdaWzMU8w=2VQkpBpJGmjxsXT1Y+55W43g@mail.gmail.com>
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

On Fri, Sep 2, 2011 at 19:24, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Fri, Sep 2, 2011 at 14:14, Finn Thain <fthain@telegraphics.com.au> wrote:
>> On Sun, 28 Aug 2011, I wrote:
>> However, I found another problem. pmac_zilog oopses when its TTY is closed
>> (see below). And macsonic does the same when the NIC is closed. The trace
>> says that irq_shutdown() died trying to call the chip irq_mask routine,
>> when desc->irq_data.chip (in a0) was NULL. Any ideas?
>
>> Unable to handle kernel NULL pointer dereference at virtual address   (null)
>> Oops: 00000000
>> Modules linked in:
>> PC: [<00000000>]   (null)
>
> No, it calls a function pointer that's NULL.
>
> void irq_shutdown(struct irq_desc *desc)
> {
>        irq_state_set_disabled(desc);
>        desc->depth = 1;
>        if (desc->irq_data.chip->irq_shutdown)
>                desc->irq_data.chip->irq_shutdown(&desc->irq_data);
>        if (desc->irq_data.chip->irq_disable)
>                desc->irq_data.chip->irq_disable(&desc->irq_data);
>        else
>                desc->irq_data.chip->irq_mask(&desc->irq_data);
>        irq_state_set_masked(desc);
> }
>
> Oops, seems I misread the code and assumed the second "if" was an "else if",
> as I wrote down in my notes that it calls only one of the 3 functions :-(
> But it does need either .irq_disable() or .irq_mask().

However, include/linux/irq.h says:

 * @irq_shutdown:       shut down the interrupt (defaults to ->disable if NULL)

which gives me the impression the original intention was to have an "else if",
and don't require .irq_disable() or .irq_mask() if .irq_shutdown() is available.

That's also what  __free_irq() used to do, cfr.
3b56f0585fd4c02d047dc406668cb40159b2d340

"genirq: Remove bogus conditional

 The if (chip->irq_shutdown) check will always evaluate to true, as we
 fill in chip->irq_shutdown with default_shutdown in
 irq_chip_set_defaults() if the chip does not provide its own function."

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 33a6ee0..30bc8de 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1057,10 +1057,7 @@ static struct irqaction *__free_irq(unsigned int irq, voi
        /* If this was the last handler, shut down the IRQ line: */
        if (!desc->action) {
                desc->status |= IRQ_DISABLED;
-               if (desc->irq_data.chip->irq_shutdown)
-                       desc->irq_data.chip->irq_shutdown(&desc->irq_data);
-               else
-                       desc->irq_data.chip->irq_disable(&desc->irq_data);
+               desc->irq_data.chip->irq_shutdown(&desc->irq_data);
        }

 #ifdef CONFIG_SMP

(at that time the check had become bogus, as .irq_shutdown() was always set to
.irq_disable() if it was NULL).

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
