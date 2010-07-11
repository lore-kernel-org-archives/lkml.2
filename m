Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab0GKJBf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 05:01:35 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51621 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab0GKJBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 05:01:34 -0400
Message-ID: <4C398866.8050304@cs.helsinki.fi>
Date: Sun, 11 Jul 2010 12:01:26 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       David Teigland <teigland@redhat.com>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] edd: fix possible memory leak in edd_init() error path
References: <1278672607.1335.3.camel@mola>
In-Reply-To: <1278672607.1335.3.camel@mola>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin wrote:
> The error may happen at any iteration of the for loop,
> this patch properly unregisters already registed edd_devices in error path.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good to me.

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>

> ---
>  drivers/firmware/edd.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
> index 110e24e..b75082c 100644
> --- a/drivers/firmware/edd.c
> +++ b/drivers/firmware/edd.c
> @@ -744,7 +744,7 @@ static inline int edd_num_devices(void)
>  static int __init
>  edd_init(void)
>  {
> -	unsigned int i;
> +	int i;
>  	int rc=0;
>  	struct edd_device *edev;
>  
> @@ -760,21 +760,30 @@ edd_init(void)
>  	if (!edd_kset)
>  		return -ENOMEM;
>  
> -	for (i = 0; i < edd_num_devices() && !rc; i++) {
> +	for (i = 0; i < edd_num_devices(); i++) {
>  		edev = kzalloc(sizeof (*edev), GFP_KERNEL);
> -		if (!edev)
> -			return -ENOMEM;
> +		if (!edev) {
> +			rc = -ENOMEM;
> +			goto out;
> +		}
>  
>  		rc = edd_device_register(edev, i);
>  		if (rc) {
>  			kfree(edev);
> -			break;
> +			goto out;
>  		}
>  		edd_devices[i] = edev;
>  	}
>  
> -	if (rc)
> -		kset_unregister(edd_kset);
> +	return 0;
> +
> +out:
> +	while (--i >= 0) {
> +		edev = edd_devices[i];
> +		if (edev)
> +			edd_device_unregister(edev);
> +	}
> +	kset_unregister(edd_kset);
>  	return rc;
>  }
>  

