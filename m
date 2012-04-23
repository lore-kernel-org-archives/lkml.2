Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2DWUMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37457 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754093Ab2DWUL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:11:59 -0400
Date: Mon, 23 Apr 2012 16:11:31 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Ravi Kumar V <kumarrav@codeaurora.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Anssi Hannula <anssi.hannula@iki.fi>,
        "Juan J. Garcia de Soria" <skandalfo@gmail.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        tsoni@codeaurora.org, davidb@codeaurora.org, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/1] rc: Add support for GPIO based IR Receiver driver.
Message-ID: <20120423201131.GG31244@redhat.com>
References: <1330408300-21939-1-git-send-email-kumarrav@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330408300-21939-1-git-send-email-kumarrav@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 11:21:40AM +0530, Ravi Kumar V wrote:
> Adds GPIO based IR Receiver driver. It decodes signals using decoders
> available in rc framework.

Been meaning to look at this, but it looks like its already merged
upstream. Just one question though, inlined below.

> --- /dev/null
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -0,0 +1,205 @@
> +/* Copyright (c) 2012, Code Aurora Forum. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 and
> + * only version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/interrupt.h>
> +#include <linux/gpio.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/irq.h>
> +#include <media/rc-core.h>
> +#include <media/gpio-ir-recv.h>
> +
> +#define GPIO_IR_DRIVER_NAME	"gpio-rc-recv"
> +#define GPIO_IR_DEVICE_NAME	"gpio_ir_recv"
> +
> +struct gpio_rc_dev {
> +	struct rc_dev *rcdev;
> +	unsigned int gpio_nr;
> +	bool active_low;
> +};
> +
> +static irqreturn_t gpio_ir_recv_irq(int irq, void *dev_id)
> +{
> +	struct gpio_rc_dev *gpio_dev = dev_id;
> +	unsigned int gval;
> +	int rc = 0;
> +	enum raw_event_type type = IR_SPACE;
> +
> +	gval = gpio_get_value_cansleep(gpio_dev->gpio_nr);
> +
> +	if (gval < 0)
> +		goto err_get_value;
> +
> +	if (gpio_dev->active_low)
> +		gval = !gval;
> +
> +	if (gval == 1)
> +		type = IR_PULSE;

What happens if gval is > 1?

> +	rc = ir_raw_event_store_edge(gpio_dev->rcdev, type);
> +	if (rc < 0)
> +		goto err_get_value;
> +
> +	ir_raw_event_handle(gpio_dev->rcdev);
> +
> +err_get_value:
> +	return IRQ_HANDLED;
> +}

Looks like you'll store a space any time you get gval > 1, which may or
may not be intended here...


-- 
Jarod Wilson
jarod@redhat.com

