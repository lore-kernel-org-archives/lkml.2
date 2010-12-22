Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab0LVVud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 16:50:33 -0500
Received: from mail.bluewatersys.com ([202.124.120.130]:15561 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751637Ab0LVVuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 16:50:32 -0500
Message-ID: <4D12730B.2030909@bluewatersys.com>
Date: Thu, 23 Dec 2010 10:52:11 +1300
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Alexey Charkov <alchark@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Eric Miao <eric.y.miao@gmail.com>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6 v10] ARM: Add basic architecture support for VIA/WonderMedia
 85xx SoC's
References: <20101220195423.GA14509@alchark-u3s> <4D0FC1AE.2050708@bluewatersys.com> <AANLkTin4XqbGwznp56Xjt_zest6rxNmir0QDJWTySY4+@mail.gmail.com> <4D0FD747.9020700@bluewatersys.com> <AANLkTikAWjK7ACyt=LedhyyrhsCk1WCiyWz182CXMe9C@mail.gmail.com> <4D0FE546.7050302@bluewatersys.com> <AANLkTinyYKrhTcBMMCE4A2oFQHm11cqSZQozytGu+d6o@mail.gmail.com> <4D1011CF.9080800@bluewatersys.com> <AANLkTi=7O-HwQRcybnLSt+r+A64g=D7rZY7NbdEMFys3@mail.gmail.com> <4D110269.9030805@bluewatersys.com> <20101222211815.GA31054@alchark-u3s>
In-Reply-To: <20101222211815.GA31054@alchark-u3s>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2010 10:18 AM, Alexey Charkov wrote:
> This adds support for the family of Systems-on-Chip produced initially
> by VIA and now its subsidiary WonderMedia that have recently become
> widespread in lower-end Chinese ARM-based tablets and netbooks.
> 
> Support is included for both VT8500 and WM8505, selectable by a
> configuration switch at kernel build time.
> 
> Included are basic machine initialization files, register and
> interrupt definitions, support for the on-chip interrupt controller,
> high-precision OS timer, GPIO lines, necessary macros for early debug,
> pulse-width-modulated outputs control, as well as platform device
> configurations for the specific drivers implemented elsewhere.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
> 
> Welcome the jubilee tenth revision of this patch ;-)
> 
> I've tried to incorporate the suggestions by Ryan and Arnd, hope that
> there is nothing left out. There was a massive reorganization of code
> to remove less-than-obvious magic with MMIO registers and irqs being
> held in huge structs, now they are again macro definitions. Those
> macros are, however, only included in single isolated files, and
> actual values to use are chosen at runtime by calling the respective
> routines at machine initialization. There are also stylistic changes
> all around, where Ryan suggested.
> 
> As a result, i8042 should again be adjusted a bit to reflect the new
> place to find respective register/irq definitions, that one will be
> sent in the respective thread shortly.
> 
> Best regards,
> Alexey

<snip>

> --- /dev/null
> +++ b/arch/arm/mach-vt8500/devices-vt8500.c
> @@ -0,0 +1,117 @@
> +/* linux/arch/arm/mach-vt8500/devices-vt8500.c
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
> +#include <linux/platform_device.h>
> +
> +#include <mach/vt8500_regs.h>
> +#include <mach/vt8500_irqs.h>
> +#include <mach/i8042.h>
> +#include "devices.h"
> +
> +static inline struct resource WMT_MMIO_RES(u32 start, u32 size)
> +{
> +	struct resource tmp = {
> +		.flags = IORESOURCE_MEM,
> +		.start = start,
> +		.end = start + size - 1,
> +	};
> +
> +	return tmp;
> +}

These functions can be marked __init (though I guess they already are if
marked inline?). They should also have lower case names since they are
proper functions.

Do these functions generate warnings about returning temporary values
off the stack? If so, they could be rewritten as:

static __init void wmt_mmio_res(struct resource *res,
				u32 start, u32 size)
{
	res->flags = IORESOURCE_MEM;
	res->start = start;
	res->end   = start + size - 1;
}

You could also make these functions static inline in devices.h to avoid
having to define them for each board.

> +
> +static inline struct resource WMT_IRQ_RES(int irq)
> +{
> +	struct resource tmp = {
> +		.flags = IORESOURCE_IRQ,
> +		.start = irq,
> +		.end = irq,
> +	};
> +
> +	return tmp;
> +}
> +
> +#define WMT_RES_ADD(__device, __resource, __num) \
> +if (platform_device_add_resources(__device, __resource, __num)) \
> +	pr_err("Failed to assign resources to __device##\n");

This could be written as a proper function. The resource add is unlikely
to fail. Maybe keep the warning but don't worry about printing the
device name?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
