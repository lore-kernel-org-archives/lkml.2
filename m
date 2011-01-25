Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1AYMbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:31:15 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63578 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1AYMbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:31:14 -0500
Message-ID: <4D3EC24B.2040302@mvista.com>
Date: Tue, 25 Jan 2011 15:30:03 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Anoop P.A" <anoop.pa@gmail.com>
CC: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 5/6] Platform support for On-chip MSP ethernet devices.
References: <1295943763-20392-1-git-send-email-anoop.pa@gmail.com> <1295951309-4444-1-git-send-email-anoop.pa@gmail.com>
In-Reply-To: <1295951309-4444-1-git-send-email-anoop.pa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 25-01-2011 13:28, Anoop P.A wrote:

> From: Anoop P A<anoop.pa@gmail.com>

> Previous version of patch was line wrapped and had some style issues. correcting it.

    Such remarks should folow the --- tear line.

> Some of MSP family SoC's come with legacy 100Mbps mspeth while some comes with
> newer Gigabit TSMAC.Following patch adds platform support for both types of MAC's.
> If TSMAC is not selected assume platform having legacy mspeth.This patch will add
> gpio_macros as well which is required for resetting phy

> Signed-off-by: Anoop P A<anoop.pa@gmail.com>
[...]

> diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
> new file mode 100644
> index 0000000..d83d78f
> --- /dev/null
> +++ b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
> @@ -0,0 +1,343 @@
> +/*
> + *
> + * Macros for external SMP-safe access to the PMC MSP71xx reference
> + * board GPIO pins
> + *
> + * Copyright 2010 PMC-Sierra, Inc.
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + *
> + *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
> + *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
> + *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
> + *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
> + *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
> + *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
> + *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
> + *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
> + *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
> + *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
> + *
> + *  You should have received a copy of the  GNU General Public License along
> + *  with this program; if not, write  to the Free Software Foundation, Inc.,
> + *  675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef __MSP_GPIO_MACROS_H__
> +#define __MSP_GPIO_MACROS_H__
> +
> +#include <msp_regops.h>
> +#include <msp_regs.h>
> +
> +#ifdef CONFIG_PMC_MSP7120_GW
> +#define MSP_NUM_GPIOS		(20)

    Useless parens.

> +#else
> +#define MSP_NUM_GPIOS		(28)

    Here too.

[...]

> +/* -- Bit masks -- */
> +
> +/* This gives you the 'register relative offlet gpio' number */

    Offlet?

> +#define OFFSET_GPIO_NUMBER(gpio)	(gpio - MSP_GPIO_OFFSET[gpio])
> +
> +/* These take the 'register relative offset gpio' number */
> +#define BASIC_DATA_REG_MASK(ogpio)	\
> +	(1 << ogpio)


> +#define BASIC_MODE_REG_VALUE(mode, ogpio)	\
> +	(mode << BASIC_MODE_REG_SHIFT(ogpio))
> +#define BASIC_MODE_REG_MASK(ogpio)		\
> +	BASIC_MODE_REG_VALUE(0xf, ogpio)
> +#define BASIC_MODE_REG_SHIFT(ogpio)	\
> +	(ogpio * 4)

    Why break the lines if there's enough space for the definition on the 
first line?

> +/* Sets the specified pin to the specified value */
> +static inline void msp_gpio_pin_set(msp_gpio_data_t data, unsigned int gpio)
> +{
> +	if (gpio>= MSP_NUM_GPIOS)
> +		return;
> +
> +	if (gpio < 16) {
> +		if (data == MSP_GPIO_TOGGLE)
> +			toggle_reg32(MSP_GPIO_DATA_REGISTER[gpio],
> +					BASIC_DATA_MASK(gpio));
> +		else if (data == MSP_GPIO_HI)
> +			set_reg32(MSP_GPIO_DATA_REGISTER[gpio],
> +					BASIC_DATA_MASK(gpio));
> +		else
> +			clear_reg32(MSP_GPIO_DATA_REGISTER[gpio],
> +					BASIC_DATA_MASK(gpio));
> +	} else {
> +		if (data == MSP_GPIO_TOGGLE) {
> +			/* Special ugly case:
> +			 *   We have to read the CLR bit.
> +			 *   If set, we write the CLR bit.
> +			 *   If not, we write the SET bit.
> +			 */
> +			u32 tmpdata;

    Empty line wouldn't hurt here.

> +			custom_read_reg32(MSP_GPIO_DATA_REGISTER[gpio],
> +								tmpdata);
> +			if (tmpdata & EXTENDED_CLR(gpio))
> +				tmpdata = EXTENDED_CLR(gpio);
> +			else
> +				tmpdata = EXTENDED_SET(gpio);
> +			custom_write_reg32(MSP_GPIO_DATA_REGISTER[gpio],
> +								tmpdata);
> +		} else {
> +			u32 newdata;

    Here too.

> +			if (data == MSP_GPIO_HI)
> +				newdata = EXTENDED_SET(gpio);
> +			else
> +				newdata = EXTENDED_CLR(gpio);
> +			set_value_reg32(MSP_GPIO_DATA_REGISTER[gpio],
> +						EXTENDED_FULL_MASK, newdata);
> +		}
> +	}
> +}

[...]

> diff --git a/arch/mips/pmc-sierra/msp71xx/msp_eth.c b/arch/mips/pmc-sierra/msp71xx/msp_eth.c
> new file mode 100644
> index 0000000..fa510ca
> --- /dev/null
> +++ b/arch/mips/pmc-sierra/msp71xx/msp_eth.c
> @@ -0,0 +1,188 @@
> +int __init msp_eth_setup(void)
> +{
> +	int i, ret = 0;
> +
> +	/* Configure the GPIO and take the ethernet PHY out of reset */
> +	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO0);
> +	msp_gpio_pin_hi(MSP_ETHERNET_GPIO0);
> +
> +#ifdef CONFIG_MSP_HAS_TSMAC
> +	/* 3 phys on boards with TSMAC */
> +	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO1);
> +	msp_gpio_pin_hi(MSP_ETHERNET_GPIO1);
> +
> +	msp_gpio_pin_mode(MSP_GPIO_OUTPUT, MSP_ETHERNET_GPIO2);
> +	msp_gpio_pin_hi(MSP_ETHERNET_GPIO2);
> +#endif
> +	for (i = 0; i<  ARRAY_SIZE(msp_eth_devs); i++) {
> +		ret = platform_device_register(&msp_eth_devs[i]);
> +		printk(KERN_INFO"device: %d, return value = %d\n", i, ret);
                                 ^
    Space wouldn't hurt here.

> +		if (ret) {
> +			while (--i >= 0)
> +				platform_device_unregister(&msp_eth_devs[i]);

    Why unregister all devices if one registration fails?

> +			break;
> +		}
> +	}
> +
> +	if (ret)
> +		printk(KERN_WARNING "Could not initialize \
> +						MSPETH device structures.\n");

    String literals are not broken up like this, instead use:


		printk(KERN_WARNING "Could not initialize "
					"MSPETH device structures.\n");

WBR, Sergei
