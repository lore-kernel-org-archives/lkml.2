Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229Ab0JUTh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 15:37:28 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:26625 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753380Ab0JUTh1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 15:37:27 -0400
X-SpamScore: -30
X-BigFish: VS-30(zz542N1432N98dN4015L9371Pzz1202hzz8275bhz2dh2a8h)
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCHv4 2/2] ARM: imx: Add wake functionality to GPIO
Date: Thu, 21 Oct 2010 12:37:43 -0700
Message-ID: <86A0E76937111F4C92FABEC0A2098851051D5EDD@az33exm21>
In-Reply-To: <20101021191441.GY19834@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCHv4 2/2] ARM: imx: Add wake functionality to GPIO
Thread-Index: ActxVE0AXea74Th6SWiw8rbfdUB/YQAAdwPw
References: <1287687324-6101-1-git-send-email-Dinh.Nguyen@freescale.com> <1287687324-6101-2-git-send-email-Dinh.Nguyen@freescale.com> <20101021191441.GY19834@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <s.hauer@pengutronix.de>,
        <valentin.longchamp@epfl.ch>, <daniel@caiaq.de>,
        <grant.likely@secretlab.ca>, <bryan.wu@canonical.com>,
        <amit.kucheria@canonical.com>,
        Zhang Lily-R58066 <R58066@freescale.com>
X-Reverse-DNS: az33egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

>-----Original Message-----
>From: Uwe Kleine-König [mailto:u.kleine-koenig@pengutronix.de]
>Sent: Thursday, October 21, 2010 2:15 PM
>To: Nguyen Dinh-R00091
>Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; linux@arm.linux.org.uk;
>s.hauer@pengutronix.de; valentin.longchamp@epfl.ch; daniel@caiaq.de; grant.likely@secretlab.ca;
>bryan.wu@canonical.com; amit.kucheria@canonical.com; Zhang Lily-R58066
>Subject: Re: [PATCHv4 2/2] ARM: imx: Add wake functionality to GPIO
>
>On Thu, Oct 21, 2010 at 01:55:24PM -0500, Dinh.Nguyen@freescale.com wrote:
>> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>>
>> Add function definition for irq_chip.set_wake to enable GPIO to
>> wake-up the system.
>>
>> This patch is based on Sascha Hauer's imx/linux-2.6 for-rmk tree.
>>
>> This patch has been tested on a MX51 Babbage system that had suspend
>> code implemented. The set_wake implementation is necessary for a
>> GPIO to wake up a system from suspend.
>>
>> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
>> ---
>>  arch/arm/plat-mxc/gpio.c |   32 ++++++++++++++++++++++++++++++++
>>  1 files changed, 32 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/arm/plat-mxc/gpio.c b/arch/arm/plat-mxc/gpio.c
>> index 9d38da0..9c3e362 100644
>> --- a/arch/arm/plat-mxc/gpio.c
>> +++ b/arch/arm/plat-mxc/gpio.c
>> @@ -20,6 +20,7 @@
>>   */
>>
>>  #include <linux/init.h>
>> +#include <linux/interrupt.h>
>>  #include <linux/io.h>
>>  #include <linux/irq.h>
>>  #include <linux/gpio.h>
>> @@ -201,11 +202,42 @@ static void mx2_gpio_irq_handler(u32 irq, struct irq_desc *desc)
>>  	}
>>  }
>>
>> +/*
>> + * Set interrupt number "irq" in the GPIO as a wake-up source.
>> + * While system is running, all registered GPIO interrupts need to have
>> + * wake-up enabled. When system is suspended, only selected GPIO interrupts
>> + * need to have wake-up enabled.
>> + * @param  irq          interrupt source number
>> + * @param  enable       enable as wake-up if equal to non-zero
>> + * @return       This function returns 0 on success.
>> + */
>> +static int gpio_set_wake_irq(u32 irq, u32 enable)
>> +{
>> +	u32 gpio = irq_to_gpio(irq);
>> +	u32 gpio_idx = gpio & 0x1F;
>> +	struct mxc_gpio_port *port = &mxc_gpio_ports[gpio / 32];
>> +
>> +	if (enable) {
>> +		if (port->irq_high && (gpio_idx >= 16))
>> +			enable_irq_wake(port->irq_high);
>> +		else
>> +			enable_irq_wake(port->irq);
>> +	} else {
>> +		if (port->irq_high && (gpio_idx >= 16))
>> +			disable_irq_wake(port->irq_high);
>> +		else
>> +			disable_irq_wake(port->irq);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>Is this really enough to let the CPU wake up?  Is this implementation
>correct for all i.MX SoCs?

I tested the code to wakeup from suspend on my MX51 Babbage board, without this code the power button on the Babbage board will not wakeup the system. It appears that in the gpio-keys.c, gpio_keys_suspend() will call the enable_irq_wake, which then will call the GPIO's set_wake function on the GPIO pin. This implementation should be correct for all i.MX SoCs.

>
>Best regards
>Uwe
>
>>  static struct irq_chip gpio_irq_chip = {
>>  	.ack = gpio_ack_irq,
>>  	.mask = gpio_mask_irq,
>>  	.unmask = gpio_unmask_irq,
>>  	.set_type = gpio_set_irq_type,
>> +	.set_wake = gpio_set_wake_irq,
>>  };
>>
>>  static void _set_gpio_direction(struct gpio_chip *chip, unsigned offset,
>> --
>> 1.6.0.4
>>
>>
>>
>
>--
>Pengutronix e.K.                           | Uwe Kleine-König            |
>Industrial Linux Solutions                 | http://www.pengutronix.de/  |

Thanks,
Dinh

