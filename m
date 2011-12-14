Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185Ab1LNVPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 16:15:45 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51548 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169Ab1LNVPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 16:15:41 -0500
MIME-Version: 1.0
In-Reply-To: <1323876538-20406-5-git-send-email-robherring2@gmail.com>
References: <1323876538-20406-1-git-send-email-robherring2@gmail.com> <1323876538-20406-5-git-send-email-robherring2@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 14 Dec 2011 14:15:19 -0700
X-Google-Sender-Auth: hL8UHV_PQiR44O1jIE7RK0xOqKE
Message-ID: <CACxGe6uAEUXe=7B5c0yDdRWpMx-_d=dwc5wofh3FYaUN=EZQQg@mail.gmail.com>
Subject: Re: [PATCH 4/9] gpio: pl061: use chained_irq_* functions in irq handler
To: Rob Herring <robherring2@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, shawn.guo@freescale.com,
        Kukjin Kim <kgene.kim@samsung.com>, Kevin Hilman <khilman@ti.com>,
        Tony Lindgren <tony@atomide.com>, Barry Song <baohua.song@csr.com>,
        Linus Walleij <linus.ml.walleij@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 8:28 AM, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Use chained_irq_enter/exit helper functions instead of direct pointer
> accesses. This is needed for generic irq chip conversion.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> Cc: Linus Walleij <linus.ml.walleij@gmail.com>
> ---
>  drivers/gpio/gpio-pl061.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/gpio/gpio-pl061.c b/drivers/gpio/gpio-pl061.c
> index 4102f63..0f718f9 100644
> --- a/drivers/gpio/gpio-pl061.c
> +++ b/drivers/gpio/gpio-pl061.c
> @@ -23,6 +23,7 @@
>  #include <linux/amba/bus.h>
>  #include <linux/amba/pl061.h>
>  #include <linux/slab.h>
> +#include <asm/mach/irq.h>
>
>  #define GPIODIR 0x400
>  #define GPIOIS  0x404
> @@ -211,8 +212,9 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
>        struct list_head *chip_list = irq_get_handler_data(irq);
>        struct list_head *ptr;
>        struct pl061_gpio *chip;
> +       struct irq_chip *irqchip = irq_desc_get_chip(desc);
>
> -       desc->irq_data.chip->irq_ack(&desc->irq_data);
> +       chained_irq_enter(irqchip, desc);
>        list_for_each(ptr, chip_list) {
>                unsigned long pending;
>                int offset;
> @@ -227,7 +229,7 @@ static void pl061_irq_handler(unsigned irq, struct irq_desc *desc)
>                for_each_set_bit(offset, &pending, PL061_GPIO_NR)
>                        generic_handle_irq(pl061_to_irq(&chip->gc, offset));
>        }
> -       desc->irq_data.chip->irq_unmask(&desc->irq_data);
> +       chained_irq_exit(irqchip, desc);
>  }
>
>  static int pl061_probe(struct amba_device *dev, const struct amba_id *id)
> --
> 1.7.5.4
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
