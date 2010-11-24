Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab0KXTzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:55:48 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34236 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab0KXTzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:55:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Nmfd8d6OOCmoSePIP2V2NaeHf7os4dAy4a53+/9r6oT5x0VxlyJZdzPz8Nh5pr2/XN
         LFbVFVuhoSdFrdYgdeA2bPY6DDlAxSJLv0TazVz4usDZap4XB9EKMVLUwe7uOaEl+a4T
         arC4KGcreKFe2tmUupOgzvO40Pb8Ri9BbA8+Y=
Date: Wed, 24 Nov 2010 11:55:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Fabien Marteau <fabien.marteau@armadeus.com>
Cc: Scott Moreau <oreaus@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: joystick:   Adding Austria Microsystem AS5011
 joystick driver
Message-ID: <20101124195523.GF27368@core.coreip.homeip.net>
References: <4CEBED7E.7010101@armadeus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEBED7E.7010101@armadeus.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabien,

On Tue, Nov 23, 2010 at 05:36:14PM +0100, Fabien Marteau wrote:
> Driver for EasyPoint AS5011 2 axis joystick chip. This chip is plugged
> on an I2C bus. It as been tested on ARM processor (i.MX27).
> 

Thank you for the patch. In addiitoon to comments you got from the other
reviewers I'd recommend switching to threaded IRQ instead of using a
separate workqueue, it greatly simplifies the code.

> +
> +static irqreturn_t button_interrupt(int irq, void *dev_id)
> +{
> +	struct as5011_platform_data *plat_dat =
> +		(struct as5011_platform_data *)dev_id;
> +	int ret;
> +
> +	ret = gpio_get_value(plat_dat->button_gpio);
> +	if (ret)
> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 0);
> +	else
> +		input_report_key(plat_dat->input_dev, BTN_JOYSTICK, 1);
> +	input_sync(plat_dat->input_dev);
> +	return IRQ_HANDLED;

That appears to be a hard IRQ; are you sure that gpio_get_value will not
sleep?

> +
> +	plat_dat->input_dev->name = "Austria Microsystem as5011 joystick";
> +	plat_dat->input_dev->uniq = "Austria0";
> +	plat_dat->input_dev->id.bustype = BUS_I2C;
> +	plat_dat->input_dev->phys = "/dev/input/event0";

Phys is not the path in device tree but rather physical device
connection path within the system. If there is not known connection path
it is better just leave it as NULL.

> +	plat_dat->input_dev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +	plat_dat->input_dev->keybit[BIT_WORD(BTN_JOYSTICK)] =
> +					BIT_MASK(BTN_JOYSTICK);
> +
> +	input_set_abs_params(plat_dat->input_dev,
> +			     ABS_X,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +	input_set_abs_params(plat_dat->input_dev,
> +			     ABS_Y,
> +			     AS5011_MIN_AXIS,
> +			     AS5011_MAX_AXIS,
> +			     AS5011_FUZZ,
> +			     AS5011_FLAT);
> +
> +	plat_dat->button_irq_name =
> +		kmalloc(sizeof(unsigned char)*SIZE_NAME,
> +					 GFP_KERNEL);

Just why does it have to be separately allocated? I'd even stick with
"as5011" for all IRQ names.

> +
> +	queue_work(plat_dat->workqueue, &plat_dat->update_axes_work);
> +

The device is quite likely not opened here so why do you want to send
events?

Thanks.

-- 
Dmitry
