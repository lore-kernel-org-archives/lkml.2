Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab1HZHJq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 03:09:46 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:50890
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750867Ab1HZHJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 03:09:45 -0400
Message-ID: <4E5746B5.5090408@compulab.co.il>
Date: Fri, 26 Aug 2011 10:09:41 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Kunze <thommycheck@gmx.de>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] power_supply: collie_battery: simplify collie_bat_probe
 error handling
References: <1314328469.4571.1.camel@phoenix>
In-Reply-To: <1314328469.4571.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mailer problem, sorry, sending once again...


Hi Axel,



On 08/26/11 06:14, Axel Lin wrote:
> I think this change is better in readability.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---

May be just convert it to use struct gpio and gpio_<request|free>_array() calls?
Because right now it uses the same concept, but really awkward...

>  drivers/power/collie_battery.c |   12 +++++-------
>  1 files changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/power/collie_battery.c b/drivers/power/collie_battery.c
> index 548d263..89d6fcd 100644
> --- a/drivers/power/collie_battery.c
> +++ b/drivers/power/collie_battery.c
> @@ -322,10 +322,8 @@ static int __devinit collie_bat_probe(struct ucb1x00_dev *dev)
>  
>  	for (i = 0; i < ARRAY_SIZE(gpios); i++) {
>  		ret = gpio_request(gpios[i].gpio, gpios[i].name);
> -		if (ret) {
> -			i--;
> +		if (ret)
>  			goto err_gpio;
> -		}
>  
>  		if (gpios[i].output)
>  			ret = gpio_direction_output(gpios[i].gpio,
> @@ -333,8 +331,10 @@ static int __devinit collie_bat_probe(struct ucb1x00_dev *dev)
>  		else
>  			ret = gpio_direction_input(gpios[i].gpio);
>  
> -		if (ret)
> +		if (ret) {
> +			gpio_free(gpios[i].gpio);
>  			goto err_gpio;
> +		}
>  	}
>  
>  	mutex_init(&collie_bat_main.work_lock);
> @@ -363,10 +363,8 @@ err_psy_reg_main:
>  
>  	/* see comment in collie_bat_remove */
>  	cancel_work_sync(&bat_work);
> -
> -	i--;
>  err_gpio:
> -	for (; i >= 0; i--)
> +	while (--i >= 0)
>  		gpio_free(gpios[i].gpio);
>  
>  	return ret;

-- 
Regards,
Igor.

