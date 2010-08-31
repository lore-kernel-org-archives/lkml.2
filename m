Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0HaExT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:53:19 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56115 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab0HaExP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SB+Qse6NlXoyqkzNNlJWoA0mV1hfjhH3TPy95Ni2vZcMTeNvckpVRqhw274/TfvGdS
         jRqc5jT8AYwPixw3zYmTALYd2gBv2EyW3+PhZM6i1/vLy05kI9yPQmmRojiemnnluJuf
         /M/QXZC/EdG2P6d72TOIZ0H59DZ/eP7uWE7sg=
MIME-Version: 1.0
In-Reply-To: <1282814339-10934-5-git-send-email-mark.brown314@gmail.com>
References: <1282814339-10934-1-git-send-email-mark.brown314@gmail.com>
	<1282814339-10934-5-git-send-email-mark.brown314@gmail.com>
Date: Tue, 31 Aug 2010 12:53:12 +0800
Message-ID: <AANLkTimvudYv4fwyGWjL5c10QrM9GtC2SXjPZzcV20_s@mail.gmail.com>
Subject: Re: [PATCH 4/5] ARM: pxa168: added special case handler for keypad interrupts
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 5:18 PM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-mmp/irq-pxa168.c |   23 ++++++++++++++++++++++-
>  1 files changed, 22 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-mmp/irq-pxa168.c b/arch/arm/mach-mmp/irq-pxa168.c
> index 52ff2f0..bfb0984 100644
> --- a/arch/arm/mach-mmp/irq-pxa168.c
> +++ b/arch/arm/mach-mmp/irq-pxa168.c
> @@ -17,6 +17,8 @@
>  #include <linux/io.h>
>
>  #include <mach/regs-icu.h>
> +#include <mach/regs-apmu.h>
> +#include <mach/cputype.h>
>
>  #include "common.h"
>
> @@ -42,6 +44,19 @@ static struct irq_chip icu_irq_chip = {
>        .unmask = icu_unmask_irq,
>  };
>
> +void handle_pxa168_keypad_irq(unsigned int irq, struct irq_desc *desc)
> +{
> +       uint32_t val;
> +       uint32_t mask = APMU_PXA168_KP_WAKE_CLR;
> +
> +       /* clear keypad wake event */
> +       val = __raw_readl(APMU_WAKE_CLR);
> +       __raw_writel(val |  mask, APMU_WAKE_CLR);
> +
> +       /* handle irq */
> +       handle_level_irq(irq, desc);
> +}
> +

Why should you clear wakeup event status in IRQ handler? If system is
resumed by keypad event, you should clear this wakeup source in resume
code. I think that IRQ code should not be binded with wakeup event at
here.

>  void __init icu_init_irq(void)
>  {
>        int irq;
> @@ -49,7 +64,13 @@ void __init icu_init_irq(void)
>        for (irq = 0; irq < 64; irq++) {
>                icu_mask_irq(irq);
>                set_irq_chip(irq, &icu_irq_chip);
> -               set_irq_handler(irq, handle_level_irq);
> +
> +               /* special handler for keypad */
> +               if (cpu_is_pxa168() && irq == IRQ_PXA168_KEYPAD)
> +                       set_irq_handler(irq, handle_pxa168_keypad_irq);
> +               else
> +                       set_irq_handler(irq, handle_level_irq);
> +
>                set_irq_flags(irq, IRQF_VALID);
>        }
>  }
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
