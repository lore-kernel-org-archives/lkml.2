Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab1LLOee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:34:34 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:58326 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab1LLOec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:34:32 -0500
Date: Mon, 12 Dec 2011 15:34:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 4/4] PM / input / touchscreen: Make st1232 use device
 PM QoS constraints
In-Reply-To: <201112100046.32206.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.1112121508410.10378@axis700.grange>
References: <201112100042.45168.rjw@sisk.pl> <201112100046.32206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:dl8+0uS0h90OcUYkITe2MZ+eoIjwlHcUdjXggtemgQx
 HrbnCZlONh/OAfzLFK5FPryl/+1ia51jG0sMxZhbJlWLQksztY
 tyNb5U6oxOsIMZ3HHxqfCYcPZrEHQ95uJXueMF4dbOYdlBYErB
 +bNMGLYl38DWU7KJu8lYcLlcjPba3L4/HVuUhWG08czsiCW2af
 BlBm3MEm6rBoVURP6c566wSMTgzIpHkIQkUn5GO9//lB/WrGjO
 l2jFDcYy5zfi7I1OAiLYFjFw9hvd+Myd/usZKYVyY4J+4Ham8v
 KuvULHI9TaoNqktXmfHW9y+5b+YZ8RMROxsp5gAC9bQLohX111
 g1z8iaz/vXTzSPbOElG58jkDSG9vjiTd9hKzgzSan/+uIct/9z
 hxPjt6530S2rA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael

On Sat, 10 Dec 2011, Rafael J. Wysocki wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Make the st1232 driver use dev_pm_qos_add_ancestor_request() to
> add a device PM QoS latency constraint for the I2C controller it
> depends on, so that the controller won't go into an overly deep
> low-power state when the touchscreen has to be particularly
> responsive (e.g. when the user moves his or her finger on it)
> and allow the A4R domain to be turned off if that doesn't violate
> the PM QoS latency constraints.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/arm/mach-shmobile/pm-sh7372.c |   28 +++++++++++++++++++++++++++-
>  drivers/input/touchscreen/st1232.c |   14 +++++++++++++-

I don't think you wanted to put these two files in one patch.

>  2 files changed, 40 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
> ===================================================================
> --- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
> +++ linux/arch/arm/mach-shmobile/pm-sh7372.c

[snip]

> Index: linux/drivers/input/touchscreen/st1232.c
> ===================================================================
> --- linux.orig/drivers/input/touchscreen/st1232.c
> +++ linux/drivers/input/touchscreen/st1232.c

After you have separated this file, you might as well notice, that it is 
almost identical to my version, that we discussed privately previously. 
Your changes include:

> @@ -25,6 +25,7 @@
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/types.h>
> +#include <linux/pm_qos.h>

in my version I preserved the alphabetic order of include files, you break 
it

>  
>  #define ST1232_TS_NAME	"st1232-ts"
>  
> @@ -46,6 +47,8 @@ struct st1232_ts_data {
>  	struct i2c_client *client;
>  	struct input_dev *input_dev;
>  	struct st1232_ts_finger finger[MAX_FINGERS];
> +	struct dev_pm_qos_request low_latency_req;
> +	bool pen_down;
>  };
>  
>  static int st1232_ts_read_data(struct st1232_ts_data *ts)
> @@ -118,8 +121,17 @@ static irqreturn_t st1232_ts_irq_handler
>  	}
>  
>  	/* SYN_MT_REPORT only if no contact */
> -	if (!count)
> +	if (!count) {
>  		input_mt_sync(input_dev);
> +		if (ts->pen_down) {
> +			dev_pm_qos_remove_request(&ts->low_latency_req);
> +			ts->pen_down = false;
> +		}
> +	} else if (!ts->pen_down) {
> +		/* First contact, request 100 mcs latency. */
> +		dev_pm_qos_add_ancestor_request(&ts->client->dev,
> +						&ts->low_latency_req, 100);

in my version I also was actually setting pen_down to true, which you seem 
to have dropped, so, your version just wouldn't work. Of course, I wasn't 
using the "ancestor" version of the above call, because it didn't exist 
back then.

You also removed my debugging, which is, of course, correct - thanks for 
doing that.

Given the above, I would appreciate it, if you split this patch into two 
and make the st1232 part of it

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

after which you can add your

[rjw@sisk.pl: use dev_pm_qos_add_ancestor_request() to reach the correct ancestor]

and your Sob.

Thanks
Guennadi

> +	}
>  
>  	/* SYN_REPORT */
>  	input_sync(input_dev);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
