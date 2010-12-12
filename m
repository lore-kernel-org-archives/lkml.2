Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0LLNCd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:02:33 -0500
Received: from mail-iw0-f170.google.com ([209.85.214.170]:34684 "EHLO
	mail-iw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0LLNCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:02:31 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Dec 2010 08:02:30 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=kKeOlchWTI4XZIxPklk7BED/srLrgcYYrT9tnEw91DgWF09sevHhBEQvWv4IprfUjf
         GK4seWlezzV/KxYxmWEzPuBfTp0MSKmwoaHlh+hFQaXy6/vvIIeZKX4UIGGDmQxPljHi
         q0ow2aHkwyCaAKqfWdazF3kUinqaNHyqgJQNs=
MIME-Version: 1.0
In-Reply-To: <1292157244-21679-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292157244-21679-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Ian Molton <ian@mnementh.co.uk>
Date: Sun, 12 Dec 2010 12:55:00 +0000
X-Google-Sender-Auth: ucvyHzRb53x9RfxQ6ajhkoWrUWc
Message-ID: <AANLkTikYJq2RjRZGhq7k6oeybZYoQ0PHJ3n3pv51jAYF@mail.gmail.com>
Subject: Re: [PATCH] mfd: Convert tc6393xb driver to new irq_ APIs
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Marek Vasut <marek.vasut@gmail.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can add my:

Acked-by: Ian Molton <ian.molton@collabora.co.uk>

To this and the TMIO and ASIC3 drivers :)

-- 
Ian Molton
Linux, Automotive, and other hacking:
http://www.mnementh.co.uk/



On 12 December 2010 12:34, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> The genirq core is being update to pass struct irq_data to irq_chip rather
> than an irq number to operations. Update tc6393 to the new API.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/tc6393xb.c |   22 +++++++++++-----------
>  1 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/mfd/tc6393xb.c b/drivers/mfd/tc6393xb.c
> index 1ea80d8a..9a23863 100644
> --- a/drivers/mfd/tc6393xb.c
> +++ b/drivers/mfd/tc6393xb.c
> @@ -527,41 +527,41 @@ tc6393xb_irq(unsigned int irq, struct irq_desc *desc)
>                }
>  }
>
> -static void tc6393xb_irq_ack(unsigned int irq)
> +static void tc6393xb_irq_ack(struct irq_data *data)
>  {
>  }
>
> -static void tc6393xb_irq_mask(unsigned int irq)
> +static void tc6393xb_irq_mask(struct irq_data *data)
>  {
> -       struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
> +       struct tc6393xb *tc6393xb = irq_data_get_irq_chip_data(data);
>        unsigned long flags;
>        u8 imr;
>
>        spin_lock_irqsave(&tc6393xb->lock, flags);
>        imr = tmio_ioread8(tc6393xb->scr + SCR_IMR);
> -       imr |= 1 << (irq - tc6393xb->irq_base);
> +       imr |= 1 << (data->irq - tc6393xb->irq_base);
>        tmio_iowrite8(imr, tc6393xb->scr + SCR_IMR);
>        spin_unlock_irqrestore(&tc6393xb->lock, flags);
>  }
>
> -static void tc6393xb_irq_unmask(unsigned int irq)
> +static void tc6393xb_irq_unmask(struct irq_data *data)
>  {
> -       struct tc6393xb *tc6393xb = get_irq_chip_data(irq);
> +       struct tc6393xb *tc6393xb = irq_data_get_irq_chip_data(data);
>        unsigned long flags;
>        u8 imr;
>
>        spin_lock_irqsave(&tc6393xb->lock, flags);
>        imr = tmio_ioread8(tc6393xb->scr + SCR_IMR);
> -       imr &= ~(1 << (irq - tc6393xb->irq_base));
> +       imr &= ~(1 << (data->irq - tc6393xb->irq_base));
>        tmio_iowrite8(imr, tc6393xb->scr + SCR_IMR);
>        spin_unlock_irqrestore(&tc6393xb->lock, flags);
>  }
>
>  static struct irq_chip tc6393xb_chip = {
> -       .name   = "tc6393xb",
> -       .ack    = tc6393xb_irq_ack,
> -       .mask   = tc6393xb_irq_mask,
> -       .unmask = tc6393xb_irq_unmask,
> +       .name           = "tc6393xb",
> +       .irq_ack        = tc6393xb_irq_ack,
> +       .irq_mask       = tc6393xb_irq_mask,
> +       .irq_unmask     = tc6393xb_irq_unmask,
>  };
>
>  static void tc6393xb_attach_irq(struct platform_device *dev)
> --
> 1.7.2.3
>
>
