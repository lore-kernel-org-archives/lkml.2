Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab0GGITX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 04:19:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59150 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749Ab0GGITV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 04:19:21 -0400
Date: Wed, 7 Jul 2010 10:19:00 +0200
From: Borislav Petkov <bp@alien8.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] acerhdf: fix resource reclaim in error path
Message-ID: <20100707081900.GA5308@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Axel Lin <axel.lin@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <len.brown@intel.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	platform-driver-x86@vger.kernel.org
References: <1278469339.12801.27.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1278469339.12801.27.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Wed, Jul 07, 2010 at 10:22:19AM +0800

Good, I like it. Go down for comments :)

> This patch fix resource reclaim in below cases:
> 1. acerhdf_register_platform() does not properly handle
>    platform_device_alloc() failure and platform_device_add() failure.
>    This patch adds error handling for acerhdf_register_platform().
> 2. acerhdf_register_platform() return err with acerhdf_dev == NULL.
>    as a result, acerhdf_unregister_platform() does not do resource
>    reclaim in acerhdf_init() error path.
>    This patch adds error handing for acerhdf_register_platform(),
>    thus correct the error handing path in acerhdf_init().
>    goto out_err instead of err_unreg if acerhdf_register_platform() fail.
> 3. platform_device_del() should be only used in error handling.
>    Current implementation missed a platform_device_put() in acerhdf_exit.
>    This patch fixes it by using platform_device_unregister() instead of
>    platform_device_del() in acerhdf_unregister_platform().
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/acerhdf.c |   20 ++++++++++++++++----
>  1 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 7b2384d..e938a86 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -579,9 +579,21 @@ static int acerhdf_register_platform(void)
>  		return err;
>  
>  	acerhdf_dev = platform_device_alloc("acerhdf", -1);
> -	platform_device_add(acerhdf_dev);
> +	if (!acerhdf_dev) {
> +		err = -ENOMEM;
> +		goto err_device_alloc;
> +	}
> +	err = platform_device_add(acerhdf_dev);
> +	if (err)
> +		goto err_device_add;
>  
>  	return 0;
> +
> +err_device_add:
> +	platform_device_put(acerhdf_dev);
> +err_device_alloc:
> +	platform_driver_unregister(&acerhdf_driver);
> +	return err;
>  }
>  
>  static void acerhdf_unregister_platform(void)
> @@ -589,7 +601,7 @@ static void acerhdf_unregister_platform(void)
>  	if (!acerhdf_dev)
>  		return;

while you're at it, you can remove the above check since
platform_device_del() does that anyway and with your error checking,
acerhdf_dev won't be unitialized in this path.

>  
> -	platform_device_del(acerhdf_dev);
> +	platform_device_unregister(acerhdf_dev);
>  	platform_driver_unregister(&acerhdf_driver);
>  }
>  
> @@ -633,7 +645,7 @@ static int __init acerhdf_init(void)
>  
>  	err = acerhdf_register_platform();
>  	if (err)
> -		goto err_unreg;
> +		goto out_err;
>  
>  	err = acerhdf_register_thermal();
>  	if (err)
> @@ -646,7 +658,7 @@ err_unreg:
>  	acerhdf_unregister_platform();
>  
>  out_err:
> -	return -ENODEV;
> +	return err;
>  }
>  
>  static void __exit acerhdf_exit(void)
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Regards/Gruss,
    Boris.
