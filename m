Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0LVKLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 05:11:45 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37488 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab0LVKLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 05:11:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NRX8/H8QF2sRtWsNZVbL65nVVnQs+n601sowTaq/LJ44gysU5YPe3S1VBMSXwhiQto
         Prhaxn/Ey9Rk+tiuhyj3ih4qUqovBVhQe9mI363inHLNHEPwdE/B5q8sRIEmK6jT60Lm
         777lH3GMUlDcN5CwYA1FhFtAobpdCEaboh6Fk=
Date: Wed, 22 Dec 2010 02:11:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: dd diasemi <dd.diasemi@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 11/11] INPUT/MISC/ONKEY: OnKey module of DA9052 device
 driver
Message-ID: <20101222101136.GA22590@core.coreip.homeip.net>
References: <AANLkTikGnwuxS4-uvtMt6mJZM42049cQ4uoUveORy4NO@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikGnwuxS4-uvtMt6mJZM42049cQ4uoUveORy4NO@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Dec 21, 2010 at 07:04:19PM +0100, dd diasemi wrote:
> Onkey module for DA9052 PMIC device from Dialog Semiconductor.
> 
> Changes made since last submission:
> . sorted Kconfig entries.
> 
> Linux Kernel Version: 2.6.34
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>

Looks pretty nice, just a couple of comments.

> ---
> diff -Naur linux-2.6.34-orig/drivers/input/misc/da9052_onkey.c
> linux-2.6.34/drivers/input/misc/da9052_onkey.c
> --- linux-2.6.34-orig/drivers/input/misc/da9052_onkey.c	1970-01-01
> 05:00:00.000000000 +0500
> +++ linux-2.6.34/drivers/input/misc/da9052_onkey.c	2010-10-12
> 10:53:04.000000000 +0500
> @@ -0,0 +1,130 @@
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/input.h>
> +#include <linux/platform_device.h>
> +
> +#include <linux/mfd/da9052/da9052.h>
> +#include <linux/mfd/da9052/reg.h>
> +
> +#define DRIVER_NAME "da9052-onkey"
> +
> +struct da9052_onkey_data {
> +	struct da9052 *da9052;
> +	struct da9052_eh_nb eh_data;
> +	struct input_dev *input;
> +};
> +
> +static void da9052_onkey_report_event(struct da9052_eh_nb *eh_data,
> +				unsigned int event)
> +{
> +	struct da9052_onkey_data *da9052_onkey =
> +		container_of(eh_data, struct da9052_onkey_data, eh_data);
> +	struct da9052_ssc_msg msg;
> +	unsigned int ret;
> +
> +	msg.addr = DA9052_EVENTB_REG;
> +	da9052_lock(da9052_onkey->da9052);
> +	ret = da9052_onkey->da9052->read(da9052_onkey->da9052, &msg);
> +	if (ret) {
> +		da9052_unlock(da9052_onkey->da9052);
> +		return;
> +	}
> +	da9052_unlock(da9052_onkey->da9052);
> +	msg.data = msg.data & DA9052_EVENTB_ENONKEY;
> +
> +	input_report_key(da9052_onkey->input, KEY_POWER, msg.data);
> +	input_sync(da9052_onkey->input);

Can we have only one da9052_unlock() instead of exiting in the middle of
the function? Also, have you considered provifing da9052_read() helper
which would do the locking?

> +}
> +
> +static int __devinit da9052_onkey_probe(struct platform_device *pdev)
> +{
> +	struct da9052_onkey_data *da9052_onkey;
> +	int error;
> +
> +	da9052_onkey = kzalloc(sizeof(*da9052_onkey), GFP_KERNEL);

You need to chek whether memory allocation succeeded here.

> +	da9052_onkey->input = input_allocate_device();
> +	if (!da9052_onkey->input) {
> +		dev_err(&pdev->dev, "failed to allocate data device\n");
> +		error = -ENOMEM;
> +		goto fail1;
> +	}
> +	da9052_onkey->da9052 = dev_get_drvdata(pdev->dev.parent);
> +
> +	if (!da9052_onkey->input) {
> +		dev_err(&pdev->dev, "failed to allocate input device\n");
> +		error = -ENOMEM;
> +		goto fail2;
> +	}
> +
> +	da9052_onkey->input->evbit[0] = BIT_MASK(EV_KEY);
> +	da9052_onkey->input->keybit[BIT_WORD(KEY_POWER)] = BIT_MASK(KEY_POWER);

__set_bit() is prefered way now.

> +	da9052_onkey->input->name = "da9052-onkey";
> +	da9052_onkey->input->phys = "da9052-onkey/input0";
> +	da9052_onkey->input->dev.parent = &pdev->dev;
> +
> +	da9052_onkey->eh_data.eve_type = ONKEY_EVE;
> +	da9052_onkey->eh_data.call_back = &da9052_onkey_report_event;
> +	error = da9052_onkey->da9052->register_event_notifier(
> +				da9052_onkey->da9052,
> +				&da9052_onkey->eh_data);
> +	if (error)
> +		goto fail2;
> +
> +	error = input_register_device(da9052_onkey->input);
> +	if (error) {
> +		dev_err(&pdev->dev, "Unable to register input\
> +				device,error: %d\n", error);
> +		goto fail3;
> +	}
> +
> +	platform_set_drvdata(pdev, da9052_onkey);
> +
> +	return 0;
> +
> +fail3:
> +	da9052_onkey->da9052->unregister_event_notifier(da9052_onkey->da9052,
> +					&da9052_onkey->eh_data);
> +fail2:
> +	input_free_device(da9052_onkey->input);
> +fail1:
> +	kfree(da9052_onkey);
> +	return error;
> +}
> +
> +static int __devexit da9052_onkey_remove(struct platform_device *pdev)
> +{
> +	struct da9052_onkey_data *da9052_onkey = pdev->dev.platform_data;

You are referencing wrong thing, you need to use platform_get_drvdata().

Thanks.

-- 
Dmitry
