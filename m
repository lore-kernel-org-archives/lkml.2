Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab1CWX4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:56:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55106 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887Ab1CWX4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:56:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6294"; a="81500268"
Message-ID: <4D8A88AE.2000701@codeaurora.org>
Date: Wed, 23 Mar 2011 16:56:30 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dima@android.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] msm: Add gpio support for 8960
References: <1300402640-23995-1-git-send-email-rvaswani@codeaurora.org> <1300885151.6117.11.camel@m0nster>
In-Reply-To: <1300885151.6117.11.camel@m0nster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/2011 5:59 AM, Daniel Walker wrote:
> On Thu, 2011-03-17 at 15:57 -0700, Rohit Vaswani wrote:
>> This patch adds GPIO support for 8960. The board file includes the
>> gpiomux configs and we now use gpio-v2 for 8960.
>>
>> Signed-off-by: Rohit Vaswani<rvaswani@codeaurora.org>
>> ---
>>   arch/arm/mach-msm/Makefile                      |    4 +--
>>   arch/arm/mach-msm/board-msm8960.c               |   21 ++++++++++++
>>   arch/arm/mach-msm/gpio-v2.c                     |   13 ++++---
>>   arch/arm/mach-msm/include/mach/irqs-8960.h      |   38 +++++++++++-----------
>>   arch/arm/mach-msm/include/mach/irqs-8x60.h      |   24 +++++++-------
>>   arch/arm/mach-msm/include/mach/msm_iomap-8960.h |    3 ++
>>   arch/arm/mach-msm/include/mach/msm_iomap-8x60.h |    5 +--
>>   arch/arm/mach-msm/include/mach/msm_iomap.h      |    1 +
>>   arch/arm/mach-msm/io.c                          |    2 +
>>   9 files changed, 68 insertions(+), 43 deletions(-)
>>
>> diff --git a/arch/arm/mach-msm/Makefile b/arch/arm/mach-msm/Makefile
>> index 5ab09a1..a4f55ec 100644
>> --- a/arch/arm/mach-msm/Makefile
>> +++ b/arch/arm/mach-msm/Makefile
>> @@ -30,11 +30,9 @@ obj-$(CONFIG_ARCH_MSM8960) += board-msm8960.o devices-msm8960.o
>>   obj-$(CONFIG_ARCH_MSM7X30) += gpiomux-v1.o gpiomux.o
>>   obj-$(CONFIG_ARCH_QSD8X50) += gpiomux-v1.o gpiomux.o
>>   obj-$(CONFIG_ARCH_MSM8X60) += gpiomux-v2.o gpiomux.o
>> +obj-$(CONFIG_ARCH_MSM8960) += gpiomux-v2.o gpiomux.o
>>   ifdef CONFIG_MSM_V2_TLMM
>> -ifndef CONFIG_ARCH_MSM8960
>> -# TODO: TLMM Mapping issues need to be resolved
>>   obj-y	+= gpio-v2.o
>> -endif
>>   else
>>   obj-y	+= gpio.o
>>   endif
>> diff --git a/arch/arm/mach-msm/board-msm8960.c b/arch/arm/mach-msm/board-msm8960.c
>> index 052cb35..1f003ba 100644
>> --- a/arch/arm/mach-msm/board-msm8960.c
>> +++ b/arch/arm/mach-msm/board-msm8960.c
>> @@ -29,6 +29,25 @@
>>   #include<mach/msm_iomap.h>
>>
>>   #include "devices.h"
>> +#include "gpiomux.h"
>> +
>> +static struct msm_gpiomux_config msm8960_gpiomux_configs[NR_GPIO_IRQS] = {};
>> +
>> +static int __init gpiomux_init(void)
>> +{
>> +	int rc;
>> +
>> +	rc = msm_gpiomux_init(NR_GPIO_IRQS);
>> +	if (rc) {
>> +		printk(KERN_ERR "msm_gpiomux_init failed %d\n", rc);
>> +		return rc;
>> +	}
>> +
>> +	msm_gpiomux_install(msm8960_gpiomux_configs,
>> +			ARRAY_SIZE(msm8960_gpiomux_configs));
>> +
>> +	return 0;
>> +}
>>
>>   static void __init msm8960_map_io(void)
>>   {
>> @@ -68,12 +87,14 @@ static struct platform_device *rumi3_devices[] __initdata = {
>>   static void __init msm8960_sim_init(void)
>>   {
>>   	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
>> +	gpiomux_init();
>>   	platform_add_devices(sim_devices, ARRAY_SIZE(sim_devices));
>>   }
>>
>>   static void __init msm8960_rumi3_init(void)
>>   {
>>   	msm_clock_init(msm_clocks_8960, msm_num_clocks_8960);
>> +	gpiomux_init();
>>   	platform_add_devices(rumi3_devices, ARRAY_SIZE(rumi3_devices));
>>   }
>>
>> diff --git a/arch/arm/mach-msm/gpio-v2.c b/arch/arm/mach-msm/gpio-v2.c
>> index fb52d6d..6a37695 100644
>> --- a/arch/arm/mach-msm/gpio-v2.c
>> +++ b/arch/arm/mach-msm/gpio-v2.c
>> @@ -1,4 +1,4 @@
>> -/* Copyright (c) 2010, Code Aurora Forum. All rights reserved.
>> +/* Copyright (c) 2010-2011 Code Aurora Forum. All rights reserved.
>>    *
>>    * This program is free software; you can redistribute it and/or modify
>>    * it under the terms of the GNU General Public License version 2 and
>> @@ -326,6 +326,7 @@ static int msm_gpio_irq_set_type(unsigned int irq, unsigned int flow_type)
>>   static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>>   {
>>   	unsigned long i;
>> +	struct irq_chip *chip = get_irq_desc_chip(desc);
>>
>>   	for (i = find_first_bit(msm_gpio.enabled_irqs, NR_GPIO_IRQS);
>>   	     i<  NR_GPIO_IRQS;
>> @@ -334,7 +335,7 @@ static void msm_summary_irq_handler(unsigned int irq, struct irq_desc *desc)
>>   			generic_handle_irq(msm_gpio_to_irq(&msm_gpio.gpio_chip,
>>   							   i));
>>   	}
>> -	desc->chip->ack(irq);
>> +	chip->irq_ack(&desc->irq_data);
>>   }
> It looks like your fixing something above, but you've not spelled out
> what your doing in the commit text.
>
>>   static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
>> @@ -343,12 +344,12 @@ static int msm_gpio_irq_set_wake(unsigned int irq, unsigned int on)
>>
>>   	if (on) {
>>   		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
>> -			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 1);
>> +			set_irq_wake(TLMM_MSM_SUMMARY_IRQ, 1);
>>   		set_bit(gpio, msm_gpio.wake_irqs);
>>   	} else {
>>   		clear_bit(gpio, msm_gpio.wake_irqs);
>>   		if (bitmap_empty(msm_gpio.wake_irqs, NR_GPIO_IRQS))
>> -			set_irq_wake(TLMM_SCSS_SUMMARY_IRQ, 0);
>> +			set_irq_wake(TLMM_MSM_SUMMARY_IRQ, 0);
>>   	}
> Again looks like another fix, but your not telling us what your doing.
>
>>   	return 0;
>> @@ -382,7 +383,7 @@ static int __devinit msm_gpio_probe(struct platform_device *dev)
>>   		set_irq_flags(irq, IRQF_VALID);
>>   	}
>>
>> -	set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
>> +	set_irq_chained_handler(TLMM_MSM_SUMMARY_IRQ,
>>   				msm_summary_irq_handler);
> Ok, so looks like a rename. Can you add this to the commit text along
> with descriptions of everything else your doing?
Daniel,
Adding support for 8960 includes making sure that Gpio support remains 
meaningful and at the same time uniform across different boards. Should 
we enumerate the specific changes ?

Thanks,
Rohit Vaswani

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

