Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab2KASd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:33:58 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61264 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab2KASd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <20121101101233.17ffcf5a@skate>
References: <1351719113-30880-1-git-send-email-linus.walleij@linaro.org>
	<5091CA18.7020905@gmail.com>
	<CACRpkda06BbFOiX1WSqNLM-R5Es-Nd6btUNq2mMDuH7s3jA2cw@mail.gmail.com>
	<20121101101233.17ffcf5a@skate>
Date: Thu, 1 Nov 2012 19:33:55 +0100
Message-ID: <CACRpkdaYyoYRg+ZnK1z4n39eO2c+U0uL=Ttsa83S2e6h6=XJag@mail.gmail.com>
Subject: Re: [PATCH] ARM: plat-versatile: move FPGA irq driver to drivers/irqchip
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Rob Herring <robherring2@gmail.com>, linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>, arm@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 1, 2012 at 10:12 AM, Thomas Petazzoni
<thomas.petazzoni@free-electrons.com> wrote:
> On Thu, 1 Nov 2012 10:00:19 +0100, Linus Walleij wrote:
>
>> Sounds like a separate patch but surely we can do this. Is Thomas'
>> stuff on a branch somewhere that I can then rebase upon to get
>> it upstream? I was planning to get this series as such to the
>> ARM SoC maintainers soon-ish.
>
> Not at the moment. But do you want me to put that in a branch, and
> agglomerate all the related patches (posted by Rob for GIC/VIC and by
> you for the FPGA IRQ controller), and then later send a pull request to
> Arnd with those changes?

Whatever I can base on ... I would just push the stuff you consider
stable to ARM SoC as quickly as possible so we can grab it
from there and base development on it. Then each of us can
just request the ARM SoC people to pull it and state that it
is based on that branch so they need to pull it into the same
place.

> Also, again, the whole point of the initial infrastructure in
> drivers/irqchip/ was to avoid adding per-driver header files in
> include/linux/irqchip/, so there should at least be a long term plan on
> how to remove those headers file, either by moving more platforms to
> DT, or my extending the irqchip infrastructure to cover more features.

So the header in this case looks like this:

#ifndef PLAT_FPGA_IRQ_H
#define PLAT_FPGA_IRQ_H

struct device_node;
struct pt_regs;

void fpga_handle_irq(struct pt_regs *regs);
void fpga_irq_init(void __iomem *, const char *, int, int, u32,
                struct device_node *node);
int fpga_irq_of_init(struct device_node *node,
                     struct device_node *parent);

#endif

So this is the stuff that needs to be called from the machine
descriptor, nothing else.

Example:

MACHINE_START(INTEGRATOR, "ARM-Integrator")
        /* Maintainer: ARM Ltd/Deep Blue Solutions Ltd */
        .atag_offset    = 0x100,
        .reserve        = integrator_reserve,
        .map_io         = ap_map_io,
        .init_early     = ap_init_early,
        .init_irq       = ap_init_irq,
        .handle_irq     = fpga_handle_irq,
        .timer          = &ap_timer,
        .init_machine   = ap_init,
        .restart        = integrator_restart,
MACHINE_END

The .init_irq hooks above contain some other stuff apart from just
calling these directly, but the problem remains: how to cross-call
these functions from the machine start since the IRQs are needed
by say the timer and everything else.

include/linux/irqchip/bcm2835.h look exactly the same (just one
function instead of separete DT/non-DT versions) so
there isn't exactly a precedent on how to solve this in an
elegant way.

But maybe your patch set contains the silver bullet that will decouple
this and fix everything?

Then I can do a patch to convert this and the BCM2835 too
probably...

Yours,
Linus Walleij
