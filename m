Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2F0UJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:09:07 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:52676 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab2F0UJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:09:04 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtxTAANo609V5qg+PGdsb2JhbABFihWsFxkBAQEBHhkNJ4IYAQEEAScTHCMFCwgDDjgUJQoaE4gGCbg7FJBNYAOVMYVmg0GJPg
X-IronPort-AV: E=Sophos;i="4.77,487,1336341600"; 
   d="scan'208";a="147548866"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 27 Jun 2012 22:12:26 +0200
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        Iiro Valkonen <iiro.valkonen@atmel.com>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Olof Johansson <olofj@chromium.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/21 v5] Input: atmel_mxt_ts - use T9 reportid range to
 init number of mt slots
Message-ID: <20120627201226.GA22231@polaris.bitmath.org>
References: <1340693829-18665-1-git-send-email-djkurtz@chromium.org>
 <1340693829-18665-20-git-send-email-djkurtz@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340693829-18665-20-git-send-email-djkurtz@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

> Atmel mxt devices can report one finger for each T9 reportid.
> Therefore, this range can be used to report the max number of MT-B slots
> to userspace instead of assuming a fixed 10.
> 
> Note that mxt_initialized() must complete early, since the input_dev
> properties now depend on values in the object table.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/touchscreen/atmel_mxt_ts.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
> index 4da12a9..b218b5f 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -212,8 +212,6 @@
>  /* Touchscreen absolute values */
>  #define MXT_MAX_AREA		0xff
>  
> -#define MXT_MAX_FINGER		10
> -
>  struct mxt_info {
>  	u8 family_id;
>  	u8 variant_id;
> @@ -1074,6 +1072,7 @@ static int __devinit mxt_probe(struct i2c_client *client,
>  	struct mxt_data *data;
>  	struct input_dev *input_dev;
>  	int error;
> +	unsigned int num_mt_slots;
>  
>  	if (!pdata)
>  		return -EINVAL;
> @@ -1103,6 +1102,10 @@ static int __devinit mxt_probe(struct i2c_client *client,
>  
>  	mxt_calc_resolution(data);
>  
> +	error = mxt_initialize(data);
> +	if (error)
> +		goto err_free_object;
> +

The comment on the previous patch actually stems from problems in
mxt_initialize(); if a function fails, there should be no need to tear
down stuff created inside the failing function. IOW, it should be goto
err_free_mem here, and mxt_initialize() should be fixed accordingly.

>  	__set_bit(EV_ABS, input_dev->evbit);
>  	__set_bit(EV_KEY, input_dev->evbit);
>  	__set_bit(BTN_TOUCH, input_dev->keybit);
> @@ -1116,9 +1119,10 @@ static int __devinit mxt_probe(struct i2c_client *client,
>  			     0, 255, 0, 0);
>  
>  	/* For multi touch */
> -	error = input_mt_init_slots(input_dev, MXT_MAX_FINGER);
> +	num_mt_slots = data->T9_reportid_max - data->T9_reportid_min + 1;
> +	error = input_mt_init_slots(input_dev, num_mt_slots);
>  	if (error)
> -		goto err_free_mem;
> +		goto err_free_object;
>  	input_set_abs_params(input_dev, ABS_MT_TOUCH_MAJOR,
>  			     0, MXT_MAX_AREA, 0, 0);
>  	input_set_abs_params(input_dev, ABS_MT_POSITION_X,
> @@ -1131,10 +1135,6 @@ static int __devinit mxt_probe(struct i2c_client *client,
>  	input_set_drvdata(input_dev, data);
>  	i2c_set_clientdata(client, data);
>  
> -	error = mxt_initialize(data);
> -	if (error)
> -		goto err_free_object;
> -
>  	error = request_threaded_irq(client->irq, NULL, mxt_interrupt,
>  			pdata->irqflags, client->name, data);
>  	if (error) {
> -- 
> 1.7.7.3
> 

Thanks,
Henrik
