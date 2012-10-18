Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2JRGuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 02:50:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41560 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2JRGuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 02:50:09 -0400
Date: Wed, 17 Oct 2012 23:50:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mischa Jonker <mischa.jonker@synopsys.com>
Cc: m.d.s.x.jonker@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, arc-linux-dev@synopsys.com
Subject: Re: [PATCH] Input: serio - Add ARC PS/2 driver
Message-ID: <20121018065004.GA12838@core.coreip.homeip.net>
References: <1350468619-4813-1-git-send-email-mischa.jonker@synopsys.com>
 <1350468619-4813-2-git-send-email-mischa.jonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350468619-4813-2-git-send-email-mischa.jonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mischa,

On Wed, Oct 17, 2012 at 12:10:19PM +0200, Mischa Jonker wrote:
> This adds support for the PS/2 block that is used in various ARC FPGA
> platforms.
> 

Thank you for making changes. A few more comments below.

> Signed-off-by: Mischa Jonker <mischa.jonker@synopsys.com>
> ---
>  drivers/input/serio/Kconfig   |    9 ++
>  drivers/input/serio/Makefile  |    1 +
>  drivers/input/serio/arc_ps2.c |  275 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 285 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/input/serio/arc_ps2.c
> 
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index 55f2c22..4a4e182 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -234,4 +234,13 @@ config SERIO_PS2MULT
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called ps2mult.
>  
> +config SERIO_ARC_PS2
> +	tristate "ARC PS/2 support"
> +	help
> +	  Say Y here if you have an ARC FPGA platform with a PS/2
> +	  controller in it.
> +
> +	  To compile this driver as a module, choose M here; the module
> +	  will be called arc_ps2.
> +
>  endif
> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
> index dbbe376..4b0c8f8 100644
> --- a/drivers/input/serio/Makefile
> +++ b/drivers/input/serio/Makefile
> @@ -25,3 +25,4 @@ obj-$(CONFIG_SERIO_RAW)		+= serio_raw.o
>  obj-$(CONFIG_SERIO_AMS_DELTA)	+= ams_delta_serio.o
>  obj-$(CONFIG_SERIO_XILINX_XPS_PS2)	+= xilinx_ps2.o
>  obj-$(CONFIG_SERIO_ALTERA_PS2)	+= altera_ps2.o
> +obj-$(CONFIG_SERIO_ARC_PS2)	+= arc_ps2.o
> diff --git a/drivers/input/serio/arc_ps2.c b/drivers/input/serio/arc_ps2.c
> new file mode 100644
> index 0000000..c952685
> --- /dev/null
> +++ b/drivers/input/serio/arc_ps2.c
> @@ -0,0 +1,275 @@
> +/*
> + * Copyright (C) 2004, 2007-2010, 2011-2012 Synopsys, Inc. (www.synopsys.com)
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Driver is originally developed by Pavel Sokolov <psokolov@synopsys.com>
> + */
> +
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/input.h>
> +#include <linux/serio.h>
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +
> +#define ARC_PS2_PORTS                   (2)
> +
> +#define ARC_ARC_PS2_ID                  (0x0001f609)
> +
> +#define STAT_TIMEOUT                    (128)
> +
> +#define PS2_STAT_RX_FRM_ERR             (1)
> +#define PS2_STAT_RX_BUF_OVER            (1 << 1)
> +#define PS2_STAT_RX_INT_EN              (1 << 2)
> +#define PS2_STAT_RX_VAL                 (1 << 3)
> +#define PS2_STAT_TX_ISNOT_FUL           (1 << 4)
> +#define PS2_STAT_TX_INT_EN              (1 << 5)
> +
> +struct arc_ps2_port {
> +	void *data, *status;

These 2 should be annotated as __iomem. May I also suggest calling them
data_addt and status_addr?

> +	struct serio *io;
> +};
> +
> +struct arc_ps2_data {
> +	struct arc_ps2_port port[ARC_PS2_PORTS];
> +	struct resource *iomem_res;
> +	int irq;
> +	void *addr;

void __iomem *

> +	unsigned frame_error;

Prefer "unsigned int".

> +	unsigned buf_overflow;
> +	unsigned total_int;
> +};
> +
> +static void arc_ps2_check_rx(struct arc_ps2_data *arc_ps2,
> +			     struct arc_ps2_port *port)
> +{
> +	unsigned flag, status;
> +	unsigned char data;
> +
> +	while (1) {
> +		status = ioread32(port->status);
> +		if (!(status & PS2_STAT_RX_VAL))
> +			break;
> +		flag = 0;
> +
> +		arc_ps2->total_int++;
> +		if (status & PS2_STAT_RX_FRM_ERR) {
> +			arc_ps2->frame_error++;
> +			flag |= SERIO_PARITY;
> +		} else if (status & PS2_STAT_RX_BUF_OVER) {
> +			arc_ps2->buf_overflow++;
> +			flag |= SERIO_FRAME;
> +		}
> +		data = ioread32(port->data) & 0xff;
> +
> +		serio_interrupt(port->io, data, flag);
> +	}
> +}
> +
> +static irqreturn_t arc_ps2_interrupt(int irq, void *dev)
> +{
> +	struct arc_ps2_data *arc_ps2 = dev;
> +	int i;
> +
> +	for (i = 0; i < ARC_PS2_PORTS; i++)
> +		arc_ps2_check_rx(arc_ps2, &arc_ps2->port[i]);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int arc_ps2_write(struct serio *io, unsigned char val)
> +{
> +	unsigned status;
> +	struct arc_ps2_port *port = io->port_data;
> +	int timeout = STAT_TIMEOUT;
> +
> +	do {
> +		status = ioread32(port->status);
> +		cpu_relax();
> +		timeout--;
> +	} while (!(status & PS2_STAT_TX_ISNOT_FUL) && timeout);
> +
> +	if (timeout)

Curly braces on this branch too please - the rule is that all branches
should have or not have braces. This overrides the single-statement
rule.

> +		iowrite32(val & 0xff, port->data);
> +	else {
> +		dev_err(&io->dev, "write timeout\n");
> +		return -ETIMEDOUT;
> +	}
> +
> +	return 0;
> +}
> +
> +static int arc_ps2_open(struct serio *io)
> +{
> +	struct arc_ps2_port *port = io->port_data;
> +	iowrite32(PS2_STAT_RX_INT_EN, port->status);
> +	return 0;
> +}
> +
> +static void arc_ps2_close(struct serio *io)
> +{
> +	struct arc_ps2_port *port = io->port_data;
> +
> +	iowrite32(ioread32(port->status) & ~PS2_STAT_RX_INT_EN, port->status);
> +}
> +
> +static int __devinit arc_ps2_allocate_port(struct platform_device *pdev,
> +					   struct arc_ps2_port *port,
> +					   int index, void *base)
> +{
> +	struct serio *io;
> +
> +	io = kzalloc(sizeof(struct serio), GFP_KERNEL);
> +	if (!io)
> +		return -ENOMEM;
> +
> +	io->id.type = SERIO_8042;
> +	io->write = arc_ps2_write;
> +	io->open = arc_ps2_open;
> +	io->close = arc_ps2_close;
> +	snprintf(io->name, sizeof(io->name), "ARC PS/2 port%d", index);
> +	snprintf(io->phys, sizeof(io->phys), "arc/serio%d", index);
> +	io->port_data = port;
> +
> +	port->io = io;
> +
> +	port->data = base + 4 + index * 4;
> +	port->status = base + 4 + ARC_PS2_PORTS * 4 + index * 4;
> +
> +	dev_dbg(&pdev->dev, "port%d is allocated (data = 0x%p, status = 0x%p)\n",
> +		index, port->data, port->status);
> +
> +	return 0;
> +}
> +
> +static int __devinit arc_ps2_probe(struct platform_device *pdev)
> +{
> +	struct arc_ps2_data *arc_ps2;
> +	int ret, id, i;
> +
> +	arc_ps2 = kzalloc(sizeof(struct arc_ps2_data), GFP_KERNEL);
> +	if (!arc_ps2) {
> +		dev_err(&pdev->dev, "out of memory\n");
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	arc_ps2->iomem_res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!arc_ps2->iomem_res) {
> +		dev_err(&pdev->dev, "no IO memory defined\n");
> +		ret = -ENODEV;

-EINVAL

> +		goto out_free;
> +	}
> +
> +	arc_ps2->irq = platform_get_irq_byname(pdev, "arc_ps2_irq");
> +	if (arc_ps2->irq < 0) {
> +		dev_err(&pdev->dev, "no IRQ defined\n");
> +		ret = -ENODEV;

-EINVAL

> +		goto out_free;
> +	}
> +
> +	if (!request_mem_region(arc_ps2->iomem_res->start,
> +	    resource_size(arc_ps2->iomem_res), pdev->name)) {
> +		dev_err(&pdev->dev, "memory allocation failed cannot get the I/O addr 0x%x\n",
> +			(unsigned int)arc_ps2->iomem_res->start);

I think we have a format specifier for resources.

> +
> +		ret = -EBUSY;
> +		goto out_free;
> +	}
> +
> +	arc_ps2->addr = ioremap_nocache(arc_ps2->iomem_res->start,
> +					resource_size(arc_ps2->iomem_res));
> +	if (!arc_ps2->addr) {
> +		dev_err(&pdev->dev, "memory mapping failed\n");
> +		ret = -ENOMEM;
> +		goto out_release_region;
> +	}
> +
> +	dev_info(&pdev->dev, "irq = %d, address = 0x%p, ports = %i\n",
> +		 arc_ps2->irq, arc_ps2->addr, ARC_PS2_PORTS);
> +
> +	id = ioread32(arc_ps2->addr);
> +	if (id != ARC_ARC_PS2_ID) {
> +		dev_err(&pdev->dev, "device id does not match\n");
> +		ret = ENXIO;

-ENXIO

> +		goto out_unmap;
> +	}
> +
> +	platform_set_drvdata(pdev, arc_ps2);
> +
> +	for (i = 0; i < ARC_PS2_PORTS; i++) {
> +		ret = arc_ps2_allocate_port(pdev, &arc_ps2->port[i], i,
> +					    arc_ps2->addr);
> +		if (ret)
> +			goto release;

Can we rename 'ret' to 'error'?

> +		serio_register_port(arc_ps2->port[i].io);
> +	}
> +
> +	ret = request_irq(arc_ps2->irq, arc_ps2_interrupt, 0,
> +			  "arc_ps2", arc_ps2);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Could not allocate IRQ\n");
> +		goto release;
> +	}
> +
> +	return 0;
> +
> +release:
> +	for (i = 0; i < ARC_PS2_PORTS; i++) {
> +		if (arc_ps2->port[i].io)
> +			serio_unregister_port(arc_ps2->port[i].io);
> +	}
> +out_unmap:
> +	iounmap((void __iomem *) arc_ps2->addr);

No need to cast to __iomem here.

> +out_release_region:
> +	release_mem_region(arc_ps2->iomem_res->start,
> +			   resource_size(arc_ps2->iomem_res));
> +out_free:
> +	kfree(arc_ps2);
> +out:
> +	return ret;
> +}
> +
> +static int __devexit arc_ps2_remove(struct platform_device *pdev)
> +{
> +	struct arc_ps2_data *arc_ps2;
> +	int i;
> +
> +	arc_ps2 = platform_get_drvdata(pdev);
> +	for (i = 0; i < ARC_PS2_PORTS; i++)
> +		serio_unregister_port(arc_ps2->port[i].io);
> +
> +	free_irq(arc_ps2->irq, arc_ps2);
> +	iounmap((void __iomem *) arc_ps2->addr);

No need to cast to __iomem here.

> +	release_mem_region(arc_ps2->iomem_res->start,
> +			   resource_size(arc_ps2->iomem_res));
> +
> +	dev_dbg(&pdev->dev, "interrupt count = %i\n", arc_ps2->total_int);
> +	dev_dbg(&pdev->dev, "frame error count = %i\n", arc_ps2->frame_error);
> +	dev_dbg(&pdev->dev, "buffer overflow count = %i\n",
> +		arc_ps2->buf_overflow);
> +
> +	kfree(arc_ps2);
> +
> +	return 0;
> +}
> +
> +static struct platform_driver arc_ps2_driver = {
> +	.driver = {
> +		   .name = "arc_ps2",
> +		   .owner = THIS_MODULE,
> +		   },
> +	.probe = arc_ps2_probe,
> +	.remove = __devexit_p(arc_ps2_remove),
> +};
> +
> +module_platform_driver(arc_ps2_driver);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Pavel Sokolov <psokolov@synopsys.com>");
> +MODULE_DESCRIPTION("ARC PS/2 Driver");
> -- 
> 1.7.0.4
> 

-- 
Dmitry
