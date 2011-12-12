Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab1LLR6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:58:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58720 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1LLR6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <1309427470-605-7-git-send-email-balbi@ti.com>
References: <1309427470-605-1-git-send-email-balbi@ti.com>
	<1309427470-605-7-git-send-email-balbi@ti.com>
Date: Mon, 12 Dec 2011 19:58:31 +0200
Message-ID: <CAMP44s1L99rPM_=puw9XgL8obeH3f46nUkSLuqvDyCNdSbbg7A@mail.gmail.com>
Subject: Re: [PATCH 6/7] mfd: twl4030-irq: set irq nested flag
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 12:51 PM, Felipe Balbi <balbi@ti.com> wrote:
> threads from twl4030's children will be called
> nested in the context of the demultiplexing
> handler on twl4030-irq.c.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/mfd/twl4030-irq.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/mfd/twl4030-irq.c b/drivers/mfd/twl4030-irq.c
> index 1b9ab2f..ff16e9c 100644
> --- a/drivers/mfd/twl4030-irq.c
> +++ b/drivers/mfd/twl4030-irq.c
> @@ -304,7 +304,7 @@ static irqreturn_t handle_twl4030_pih(int irq, void *devid)
>                        pih_isr;
>                        pih_isr >>= 1, module_irq++) {
>                if (pih_isr & 0x1)
> -                       generic_handle_irq(module_irq);
> +                       handle_nested_irq(module_irq);

But handle_nested_irq calls action->thread_fn, which is NULL for the
sih handlers that are set-up below; handle_twl4030_sih will never be
called.

>        }
>
>        return IRQ_HANDLED;
> @@ -596,9 +596,7 @@ static void handle_twl4030_sih(unsigned irq, struct irq_desc *desc)
>        int isr;
>
>        /* reading ISR acks the IRQs, using clear-on-read mode */
> -       local_irq_enable();
>        isr = sih_read_isr(sih);
> -       local_irq_disable();

But handle_twl4030_sih is still not nested.

Fortunately, Neil Brown already fixed the issues in this patch by
making handle_twl4030_sih truly nested:
http://article.gmane.org/gmane.linux.kernel/1220708

Cheers.

-- 
Felipe Contreras
