Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab2FLM43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:56:29 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2931 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2FLM41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:56:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6739"; a="200164542"
Message-ID: <4FD73C65.3050409@codeaurora.org>
Date: Tue, 12 Jun 2012 18:26:05 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jarod Wilson <jarod@redhat.com>
CC: tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>, bryanh@codeaurora.org,
        Anssi Hannula <anssi.hannula@iki.fi>, davidb@codeaurora.org,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>
Subject: Re: [PATCH v3 1/1] rc: Add support for GPIO based IR Receiver driver.
References: <1330408300-21939-1-git-send-email-kumarrav@codeaurora.org> <20120423201131.GG31244@redhat.com>
In-Reply-To: <20120423201131.GG31244@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/24/2012 1:41 AM, Jarod Wilson wrote:
> On Tue, Feb 28, 2012 at 11:21:40AM +0530, Ravi Kumar V wrote:
>> Adds GPIO based IR Receiver driver. It decodes signals using decoders
>> available in rc framework.
>
> Been meaning to look at this, but it looks like its already merged
> upstream. Just one question though, inlined below.
>
>> --- /dev/null
>> +++ b/drivers/media/rc/gpio-ir-recv.c
>> @@ -0,0 +1,205 @@
>> +/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2 and
>> + * only version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include<linux/kernel.h>
>> +#include<linux/init.h>
>> +#include<linux/module.h>
>> +#include<linux/interrupt.h>
>> +#include<linux/gpio.h>
>> +#include<linux/slab.h>
>> +#include<linux/platform_device.h>
>> +#include<linux/irq.h>
>> +#include<media/rc-core.h>
>> +#include<media/gpio-ir-recv.h>
>> +
>> +#define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
>> +#define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
>> +
>> +struct gpio_rc_dev {
>> +	struct rc_dev *rcdev;
>> +	unsigned int gpio_nr;
>> +	bool active_low;
>> +};
>> +
>> +static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
>> +{
>> +	struct gpio_rc_dev *gpio_dev = dev_id;
>> +	unsigned int gval;
>> +	int rc = 0;
>> +	enum raw_event_type type = IR_SPACE;
>> +
>> +	gval = gpio_get_value_cansleep(gpio_dev->gpio_nr);
>> +
>> +	if (gval<  0)
>> +		goto err_get_value;
>> +
>> +	if (gpio_dev->active_low)
>> +		gval = !gval;
>> +
>> +	if (gval == 1)
>> +		type = IR_PULSE;
>
> What happens if gval is>  1?

gpio_get_value_cansleep() can return
bool for low/high.
negative for error.

so i think we dont get value> 1

>
>> +	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
>> +	if (rc<  0)
>> +		goto err_get_value;
>> +
>> +	ir_raw_event_handle(gpio_dev->rcdev);
>> +
>> +err_get_value:
>> +	return IRQ_HANDLED;
>> +}
>
> Looks like you'll store a space any time you get gval>  1, which may or
> may not be intended here...
>
>


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
