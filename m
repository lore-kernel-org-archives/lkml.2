Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab0IBK15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 06:27:57 -0400
Received: from trinity.fluff.org ([89.16.178.74]:57014 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0IBK1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 06:27:55 -0400
Date: Thu, 2 Sep 2010 11:27:52 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Gregory Bean <gbean@codeaurora.org>
Cc: dwalker@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2 v2] msm: Install the Google-Android gpio driver.
Message-ID: <20100902102752.GB20737@trinity.fluff.org>
References: <1283384380-24997-1-git-send-email-gbean@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283384380-24997-1-git-send-email-gbean@codeaurora.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 04:39:39PM -0700, Gregory Bean wrote:
> As part of the ongoing effort to converge on a common code base,
> adopt the Google-Android msmgpio driver, as it has a stronger pedigree
> than the previous submission from codeaurora.
> Based on work by folks at Google, including Brian Swetland and Arve Hjønnevåg.
> 
> Cc: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: Gregory Bean <gbean@codeaurora.org>
> ---
>  arch/arm/mach-msm/Makefile  |    3 +
>  arch/arm/mach-msm/gpio.c    |  479 +++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/mach-msm/gpio_hw.h |  278 +++++++++++++++++++++++++
>  3 files changed, 760 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/gpio.c
>  create mode 100644 arch/arm/mach-msm/gpio_hw.h
> 
> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
> index 2263b8f..c95d19a 100644
> --- a/arch/arm/mach-msm/Makefile
> +++ b/arch/arm/mach-msm/Makefile
> @@ -22,3 +22,6 @@ obj-$(CONFIG_ARCH_QSD8X50) += board-qsd8x50.o devices-qsd8x50.o
>  obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-7x30.o gpiomux-v1.o gpiomux.o
>  obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-8x50.o gpiomux-v1.o gpiomux.o
>  obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-8x60.o gpiomux-v2.o gpiomux.o
> +ifndef CONFIG_MSM_V2_TLMM
> +obj-y	+= gpio.o
> +endif
> diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
> new file mode 100644
> index 0000000..89c857b
> --- /dev/null
> +++ b/arch/arm/mach-msm/gpio.c
> @@ -0,0 +1,479 @@
> +/* linux/arch/arm/mach-msm/gpio.c
> + *
> + * Copyright (C) 2007 Google, Inc.
> + * Copyright (c) 2009-2010, Code Aurora Forum. All rights reserved.
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
> +#include <linux/bitops.h>
> +#include <linux/gpio.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/irq.h>
> +#include <linux/module.h>
> +#include "gpio_hw.h"
> +#include "proc_comm.h"
> +#include "smd_private.h"
> +
> +#define FIRST_GPIO_IRQ MSM_GPIO_TO_INT(0)
> +
> +#define MSM_GPIO_BANK(bank, first, last)				\
> +	{								\
> +		.regs = {						\
> +			.out =         MSM_GPIO_OUT_##bank,		\
> +			.in =          MSM_GPIO_IN_##bank,		\
> +			.int_status =  MSM_GPIO_INT_STATUS_##bank,	\
> +			.int_clear =   MSM_GPIO_INT_CLEAR_##bank,	\
> +			.int_en =      MSM_GPIO_INT_EN_##bank,		\
> +			.int_edge =    MSM_GPIO_INT_EDGE_##bank,	\
> +			.int_pos =     MSM_GPIO_INT_POS_##bank,		\
> +			.oe =          MSM_GPIO_OE_##bank,		\
> +		},							\
> +		.chip = {						\
> +			.base = (first),				\
> +			.ngpio = (last) - (first) + 1,			\
> +			.get = msm_gpio_get,				\
> +			.set = msm_gpio_set,				\
> +			.direction_input = msm_gpio_direction_input,	\
> +			.direction_output = msm_gpio_direction_output,	\
> +			.to_irq = msm_gpio_to_irq,			\

if you're stuffing things like this into macros, maybe you should just
set them at initialisation time, it will make the macro smaller.

[snip]

> +static int msm_gpio_write(struct msm_gpio_chip *msm_chip,
> +			  unsigned offset, unsigned on)
> +{
> +	unsigned b = 1U << offset;
> +	unsigned v;

how about making these a bit more descrptive? change b for bit, and v
for val?

> diff --git a/arch/arm/mach-msm/gpio_hw.h b/arch/arm/mach-msm/gpio_hw.h
> new file mode 100644
> index 0000000..6b50660
> --- /dev/null
> +++ b/arch/arm/mach-msm/gpio_hw.h
> @@ -0,0 +1,278 @@
> +/* arch/arm/mach-msm/gpio_hw.h
> + *
> + * Copyright (C) 2007 Google, Inc.
> + * Author: Brian Swetland <swetland@google.com>
> + * Copyright (c) 2008-2010, Code Aurora Forum. All rights reserved.
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
> +#ifndef __ARCH_ARM_MACH_MSM_GPIO_HW_H
> +#define __ARCH_ARM_MACH_MSM_GPIO_HW_H
> +
> +#include <mach/msm_iomap.h>
> +
> +/* see 80-VA736-2 Rev C pp 695-751
> +**
> +** These are actually the *shadow* gpio registers, since the
> +** real ones (which allow full access) are only available to the
> +** ARM9 side of the world.
> +**
> +** Since the _BASE need to be page-aligned when we're mapping them
> +** to virtual addresses, adjust for the additional offset in these
> +** macros.
> +*/
> +
> +#if defined(CONFIG_ARCH_MSM7X30)
> +#define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + (off))
> +#define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0x400 + (off))
> +#else
> +#define MSM_GPIO1_REG(off) (MSM_GPIO1_BASE + 0x800 + (off))
> +#define MSM_GPIO2_REG(off) (MSM_GPIO2_BASE + 0xC00 + (off))
> +#endif
> +
> +#if defined(CONFIG_ARCH_MSM7X00A) || defined(CONFIG_ARCH_MSM7X25) ||\
> +    defined(CONFIG_ARCH_MSM7X27)
> +
> +/* output value */
> +#define MSM_GPIO_OUT_0         MSM_GPIO1_REG(0x00)  /* gpio  15-0  */
> +#define MSM_GPIO_OUT_1         MSM_GPIO2_REG(0x00)  /* gpio  42-16 */
> +#define MSM_GPIO_OUT_2         MSM_GPIO1_REG(0x04)  /* gpio  67-43 */
> +#define MSM_GPIO_OUT_3         MSM_GPIO1_REG(0x08)  /* gpio  94-68 */
> +#define MSM_GPIO_OUT_4         MSM_GPIO1_REG(0x0C)  /* gpio 106-95 */
> +#define MSM_GPIO_OUT_5         MSM_GPIO1_REG(0x50)  /* gpio 107-121 */
> +
> +/* same pin map as above, output enable */
> +#define MSM_GPIO_OE_0          MSM_GPIO1_REG(0x10)
> +#define MSM_GPIO_OE_1          MSM_GPIO2_REG(0x08)
> +#define MSM_GPIO_OE_2          MSM_GPIO1_REG(0x14)
> +#define MSM_GPIO_OE_3          MSM_GPIO1_REG(0x18)
> +#define MSM_GPIO_OE_4          MSM_GPIO1_REG(0x1C)
> +#define MSM_GPIO_OE_5          MSM_GPIO1_REG(0x54)

do we need each and every register defined in the header? would simply
the base of each gpio bank make this header file much smaller? or
turn it into MSM_GPIO_OE(x) ?

> +#if defined(CONFIG_ARCH_QSD8X50)

this sort of #ifdef makes me want to punch people repeatedly until they
do a better job of designing these things in the first place. It makes
it so hard to get multiple different SoCs compiling into the kernel.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

