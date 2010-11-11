Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757112Ab0KKXus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 18:50:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42634 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0KKXur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 18:50:47 -0500
Date: Thu, 11 Nov 2010 23:49:58 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Alexey Charkov <alchark@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v5] ARM: Add basic architecture support for
	VIA/WonderMedia 85xx SoC's
Message-ID: <20101111234957.GA28735@n2100.arm.linux.org.uk>
References: <1289147348-31969-1-git-send-email-alchark@gmail.com> <20101107165745.GB1759@n2100.arm.linux.org.uk> <AANLkTimFJ=Brx4pDiUqZOKDfABaDg0s_yFC7EkZGi7D8@mail.gmail.com> <20101107171726.GF1759@n2100.arm.linux.org.uk> <20101108171930.GA1471@alchark-u3s.lan> <20101111212322.GA15533@alchark-u3s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101111212322.GA15533@alchark-u3s.lan>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The good news is that it's getting harder to find things wrong...
Only three points follow below.

On Fri, Nov 12, 2010 at 12:23:22AM +0300, Alexey Charkov wrote:
> diff --git a/arch/arm/mach-vt8500/bv07.c b/arch/arm/mach-vt8500/bv07.c
> new file mode 100644
> index 0000000..25aea3d
> --- /dev/null
> +++ b/arch/arm/mach-vt8500/bv07.c
> @@ -0,0 +1,81 @@
> +/*
> + *  arch/arm/mach-vt8500/bv07.c
> + *
> + *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
> + */
> +
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <linux/io.h>
> +#include <linux/pm.h>

asm/ includes after linux/ includes please (applies to multiple files).

> diff --git a/arch/arm/mach-vt8500/gpio.c b/arch/arm/mach-vt8500/gpio.c
> new file mode 100644
> index 0000000..f533ff0
> --- /dev/null
> +++ b/arch/arm/mach-vt8500/gpio.c
> @@ -0,0 +1,230 @@
> +/* linux/arch/arm/mach-vt8500/gpio.c
> + *
> + * Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#include <linux/init.h>
> +#include <linux/irq.h>
> +#include <linux/io.h>
> +
> +#include <mach/gpio.h>

linux/gpio.h please.

> +static int vt8500_irq_set_type(unsigned int irq, unsigned int flow_type)
> +{
> +	void __iomem *base = ic_regbase;
> +	unsigned int orig_irq = irq;
> +	if (irq >= 64) {
> +		base = sic_regbase;
> +		irq -= 64;
> +	}
> +	switch (flow_type) {
> +	case IRQF_TRIGGER_LOW:
> +		return -EINVAL;
> +	case IRQF_TRIGGER_HIGH:
> +		writeb((readb(base
> +			+ VT8500_IC_DCTR + irq) & ~(3 << 4))
> +			| VT8500_TRIGGER_HIGH, base
> +			+ VT8500_IC_DCTR + irq);
> +		set_irq_handler(orig_irq, handle_level_irq);
> +		break;
> +	case IRQF_TRIGGER_FALLING:
> +		writeb((readb(base
> +			+ VT8500_IC_DCTR + irq) & ~(3 << 4))
> +			| VT8500_TRIGGER_FALLING, base
> +			+ VT8500_IC_DCTR + irq);
> +		set_irq_handler(orig_irq, handle_edge_irq);
> +		break;
> +	case IRQF_TRIGGER_RISING:
> +		writeb((readb(base
> +			+ VT8500_IC_DCTR + irq) & ~(3 << 4))
> +			| VT8500_TRIGGER_RISING, base
> +			+ VT8500_IC_DCTR + irq);
> +		set_irq_handler(orig_irq, handle_edge_irq);

These set_irq_handler's probably warn if you have spinlock debugging
enabled.
