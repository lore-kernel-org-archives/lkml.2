Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1BUQKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:10:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50022 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1BUQKb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:10:31 -0500
MIME-Version: 1.0
In-Reply-To: <1298290059-9552-1-git-send-email-monstr@monstr.eu>
References: <1298290059-9552-1-git-send-email-monstr@monstr.eu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 21 Feb 2011 09:10:11 -0700
X-Google-Sender-Auth: XQ2i4mzfWMfqMqi9hlvkgu_M6hc
Message-ID: <AANLkTi=czAa6TQsVvGRg+Uz0BMnriUL5==6ehEym8e3b@mail.gmail.com>
Subject: Re: [PATCH] i2c: xiic: Add OF support for Xilinx i2c bus interface
To: Michal Simek <monstr@monstr.eu>
Cc: devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, John.Linn@xilinx.com,
        Linux I2C <linux-i2c@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 5:07 AM, Michal Simek <monstr@monstr.eu> wrote:
> Add OF support to Xilinx i2c bus interface.
> It is used on Microblaze systems.
>
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Hi Michal,

Don't forget to cc: linux-i2c@vger.kernel.org for i2c driver changes.

The majority of this patch isn't needed.  Platform drivers can easily
handle both dt and non-dt usage at runtime using the same .probe and
.remove hooks.  All you should need to do is add an of_match_table to
the existing platform driver and set the of node pointer like this:
i2c->adap.dev.of_node = of_node_get(op->dev.of_node);  You'll also
need to fix the probe routine to *not* bail if it doesn't get a
platform data pointer.  The dt support code takes care of populating
the platform_device resource structure so that the normal method of
obtaining base address and irq works.

g.


> ---
>  drivers/i2c/busses/i2c-xiic.c |  111 ++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 109 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
> index a9c419e..22951a3 100644
> --- a/drivers/i2c/busses/i2c-xiic.c
> +++ b/drivers/i2c/busses/i2c-xiic.c
> @@ -2,6 +2,8 @@
>  * i2c-xiic.c
>  * Copyright (c) 2002-2007 Xilinx Inc.
>  * Copyright (c) 2009-2010 Intel Corporation
> + * Copyright (c) 2010-2011 Michal Simek <monstr@monstr.eu>
> + * Copyright (c) 2010-2011 PetaLogix
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
> @@ -41,6 +43,13 @@
>  #include <linux/io.h>
>  #include <linux/slab.h>
>
> +#ifdef CONFIG_OF
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/of_i2c.h>
> +#include <linux/of_address.h>
> +#endif

#ifdef CONFIG_OF should no longer needed around the device tree
headers (if you find that it is, then it is a bug that should be
reported and fixed)

> +
>  #define DRIVER_NAME "xiic-i2c"
>
>  enum xilinx_i2c_state {
> @@ -426,7 +435,7 @@ static void xiic_process(struct xiic_i2c *i2c)
>                        xiic_wakeup(i2c, STATE_ERROR);
>
>        } else if (pend & (XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK)) {
> -               /* Transmit register/FIFO is empty or ½ empty */
> +               /* Transmit register/FIFO is empty or 1/2 empty */
>
>                clr = pend &
>                        (XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK);
> @@ -687,7 +696,7 @@ static struct i2c_adapter xiic_adapter = {
>        .algo           = &xiic_algorithm,
>  };
>
> -
> +#ifndef CONFIG_OF
>  static int __devinit xiic_i2c_probe(struct platform_device *pdev)
>  {
>        struct xiic_i2c *i2c;
> @@ -808,6 +817,104 @@ static struct platform_driver xiic_i2c_driver = {
>        },
>  };
>
> +#else
> +static int __devinit xiic_i2c_of_probe(struct platform_device *op)
> +{
> +       struct xiic_i2c *i2c;
> +       int result = 0;
> +
> +       i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
> +       if (!i2c)
> +               return -ENOMEM;
> +
> +       i2c->dev = &op->dev; /* for debug and error output */
> +
> +       spin_lock_init(&i2c->lock);
> +       init_waitqueue_head(&i2c->wait);
> +
> +       i2c->base = of_iomap(op->dev.of_node, 0);
> +       if (!i2c->base) {
> +               dev_err(i2c->dev, "failed to map controller\n");
> +               result = -ENOMEM;
> +               goto fail_map;
> +       }
> +
> +       i2c->irq = irq_of_parse_and_map(op->dev.of_node, 0);
> +       if (i2c->irq) { /* no i2c->irq implies polling */
> +               result = request_irq(i2c->irq, xiic_isr,
> +                                    0, op->name, i2c);
> +               if (result < 0) {
> +                       dev_err(i2c->dev, "failed to attach interrupt\n");
> +                       goto fail_request;
> +               }
> +       }
> +
> +       dev_set_drvdata(&op->dev, i2c);
> +       i2c->adap = xiic_adapter;
> +       i2c_set_adapdata(&i2c->adap, i2c);
> +       i2c->adap.dev.parent = &op->dev;
> +       i2c->adap.dev.of_node = of_node_get(op->dev.of_node);
> +
> +       result = i2c_add_adapter(&i2c->adap);
> +       if (result < 0) {
> +               dev_err(i2c->dev, "failed to add adapter\n");
> +               goto fail_add;
> +       }
> +
> +       dev_info(i2c->dev, "mapped to 0x%08X, irq=%d\n",
> +                                       (unsigned int)i2c->base, i2c->irq);
> +
> +       xiic_reinit(i2c);
> +       of_i2c_register_devices(&i2c->adap);
> +
> +       return result;
> +
> +fail_add:
> +       dev_set_drvdata(&op->dev, NULL);
> +       free_irq(i2c->irq, i2c);
> +fail_request:
> +       irq_dispose_mapping(i2c->irq);
> +       iounmap(i2c->base);
> +fail_map:
> +       kfree(i2c);
> +       return result;
> +}
> +
> +static int __devexit xiic_i2c_of_remove(struct platform_device *op)
> +{
> +       struct xiic_i2c *i2c = dev_get_drvdata(&op->dev);
> +
> +       i2c_del_adapter(&i2c->adap);
> +       xiic_deinit(i2c);
> +       dev_set_drvdata(&op->dev, NULL);
> +
> +       if (i2c->irq)
> +               free_irq(i2c->irq, i2c);
> +
> +       irq_dispose_mapping(i2c->irq);
> +       iounmap(i2c->base);
> +       kfree(i2c);
> +       return 0;
> +}
> +
> +/* Match table for of_platform binding */
> +static struct of_device_id __devinitdata xilinx_iic_of_match[] = {
> +       { .compatible = "xlnx,xps-iic-2.00.a", },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, xilinx_iic_of_match);
> +
> +static struct platform_driver xiic_i2c_driver = {
> +       .probe   = xiic_i2c_of_probe,
> +       .remove  = __devexit_p(xiic_i2c_of_remove),
> +       .driver  = {
> +               .owner = THIS_MODULE,
> +               .name = DRIVER_NAME,
> +               .of_match_table = xilinx_iic_of_match,
> +       },
> +};
> +#endif

> +
>  static int __init xiic_i2c_init(void)
>  {
>        return platform_driver_register(&xiic_i2c_driver);
> --
> 1.5.5.6
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
