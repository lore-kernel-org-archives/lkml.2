Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab2BVJPG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 04:15:06 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65299 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab2BVJPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 04:15:02 -0500
MIME-Version: 1.0
In-Reply-To: <1329417828-6005-1-git-send-email-linus.walleij@linaro.org>
References: <1329417828-6005-1-git-send-email-linus.walleij@linaro.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 22 Feb 2012 17:14:40 +0800
Message-ID: <CAGsJ_4yLTPhLJEf9GHw694U9iYmtLgYPvYe3VGdyKKKcuX6pUA@mail.gmail.com>
Subject: Re: [PATCH] serial/sirf: fixup for changes to pin control
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Tony Lindgren <tony@atomide.com>, linux-serial@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/17 Linus Walleij <linus.walleij@linaro.org>:
> We changed the signature of the pin multiplexing functions to
> handle any pin business, so fix up the Sirf driver to call this
> new interface and rename some variables to make the semantics
> understandable.
>
> Cc: linux-serial@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Barry Song <Baohua.Song@csr.com>

> ---
>  drivers/tty/serial/sirfsoc_uart.c |   20 ++++++++++----------
>  drivers/tty/serial/sirfsoc_uart.h |    2 +-
>  2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/tty/serial/sirfsoc_uart.c b/drivers/tty/serial/sirfsoc_uart.c
> index a60523f..c1a871e 100644
> --- a/drivers/tty/serial/sirfsoc_uart.c
> +++ b/drivers/tty/serial/sirfsoc_uart.c
> @@ -22,7 +22,7 @@
>  #include <linux/io.h>
>  #include <asm/irq.h>
>  #include <asm/mach/irq.h>
> -#include <linux/pinctrl/pinmux.h>
> +#include <linux/pinctrl/consumer.h>
>
>  #include "sirfsoc_uart.h"
>
> @@ -673,12 +673,12 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
>        port->irq = res->start;
>
>        if (sirfport->hw_flow_ctrl) {
> -               sirfport->pmx = pinmux_get(&pdev->dev, NULL);
> -               ret = IS_ERR(sirfport->pmx);
> +               sirfport->p = pinctrl_get(&pdev->dev, NULL);
> +               ret = IS_ERR(sirfport->p);
>                if (ret)
> -                       goto pmx_err;
> +                       goto pin_err;
>
> -               pinmux_enable(sirfport->pmx);
> +               pinctrl_enable(sirfport->p);
>        }
>
>        port->ops = &sirfsoc_uart_ops;
> @@ -696,10 +696,10 @@ int sirfsoc_uart_probe(struct platform_device *pdev)
>  port_err:
>        platform_set_drvdata(pdev, NULL);
>        if (sirfport->hw_flow_ctrl) {
> -               pinmux_disable(sirfport->pmx);
> -               pinmux_put(sirfport->pmx);
> +               pinctrl_disable(sirfport->p);
> +               pinctrl_put(sirfport->p);
>        }
> -pmx_err:
> +pin_err:
>  irq_err:
>        devm_iounmap(&pdev->dev, port->membase);
>  err:
> @@ -712,8 +712,8 @@ static int sirfsoc_uart_remove(struct platform_device *pdev)
>        struct uart_port *port = &sirfport->port;
>        platform_set_drvdata(pdev, NULL);
>        if (sirfport->hw_flow_ctrl) {
> -               pinmux_disable(sirfport->pmx);
> -               pinmux_put(sirfport->pmx);
> +               pinctrl_disable(sirfport->p);
> +               pinctrl_put(sirfport->p);
>        }
>        devm_iounmap(&pdev->dev, port->membase);
>        uart_remove_one_port(&sirfsoc_uart_drv, port);
> diff --git a/drivers/tty/serial/sirfsoc_uart.h b/drivers/tty/serial/sirfsoc_uart.h
> index fc64260..6e207fd 100644
> --- a/drivers/tty/serial/sirfsoc_uart.h
> +++ b/drivers/tty/serial/sirfsoc_uart.h
> @@ -162,7 +162,7 @@ struct sirfsoc_uart_port {
>        unsigned char                   ms_enabled;
>
>        struct uart_port                port;
> -       struct pinmux                   *pmx;
> +       struct pinctrl                  *p;
>  };
>
>  /* Hardware Flow Control */
> --
> 1.7.7.6
>
