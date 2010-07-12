Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0GLTti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 15:49:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417Ab0GLTtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 15:49:36 -0400
Date: Mon, 12 Jul 2010 12:49:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jens Axboe <jens.axboe@oracle.com>,
        David Teigland <teigland@redhat.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH] edd: fix possible memory leak in edd_init() error path
Message-Id: <20100712124904.d05242d2.akpm@linux-foundation.org>
In-Reply-To: <1278672607.1335.3.camel@mola>
References: <1278672607.1335.3.camel@mola>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Jul 2010 18:50:07 +0800
Axel Lin <axel.lin@gmail.com> wrote:

> The error may happen at any iteration of the for loop,
> this patch properly unregisters already registed edd_devices in error path.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
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

This test is unneeded?

> +			edd_device_unregister(edev);
> +	}
> +	kset_unregister(edd_kset);
>  	return rc;
>  }

