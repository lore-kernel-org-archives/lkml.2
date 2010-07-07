Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab0GGM3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 08:29:53 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43493 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab0GGM3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 08:29:51 -0400
Date: Wed, 7 Jul 2010 14:29:32 +0200
From: Borislav Petkov <bp@alien8.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <petkovbb@gmail.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH v2] acerhdf: fix resource reclaim in error path
Message-ID: <20100707122932.GA3115@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Axel Lin <axel.lin@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Peter Feuerer <peter@piie.net>, Matthew Garrett <mjg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Borislav Petkov <petkovbb@gmail.com>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	platform-driver-x86@vger.kernel.org
References: <1278491971.12801.36.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1278491971.12801.36.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@gmail.com>
Date: Wed, Jul 07, 2010 at 04:39:31PM +0800

> This patch fix resource reclaim in below cases:
> 1. acerhdf_register_platform() does not properly handle
>    platform_device_alloc() failure and platform_device_add() failure
>    This patch adds error handing for acerhdf_register_platform().
> 2. acerhdf_register_platform() return err with acerhdf_dev == NULL.
>    as a result, acerhdf_unregister_platform() does not do resource
>    reclaim in acerhdf_init() error path.
>    This patch adds error handing for acerhdf_register_platform(),
>    thus correct the error handing path in acerhdf_init().
>    goto out_err instead of err_unreg if acerhdf_register_platform() fail.
> 3. platform_device_del() should only used in error handling.
>    Current implementation missed a platform_device_put() in acerhdf_exit.
>    This patch fixes it by using platform_device_unregister() instead of
>    platform_device_del() in acerhdf_unregister_platform.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Ok, I just gave it a run and it looks good. Just a minor nitpick: when
writing your commit messages you don't have to explain what the code
does since we can see it in the patch itself. Rather, your commit
message should explain why you do this.

See http://userweb.kernel.org/~akpm/stuff/tpp.txt for further info on
how to create your patches.

Other than that:

Acked-by: Borislav Petkov <bp@alien8.de>

> ---
>  drivers/platform/x86/acerhdf.c |   23 ++++++++++++++++-------
>  1 files changed, 16 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/platform/x86/acerhdf.c b/drivers/platform/x86/acerhdf.c
> index 7b2384d..d9f5ebb 100644
> --- a/drivers/platform/x86/acerhdf.c
> +++ b/drivers/platform/x86/acerhdf.c
> @@ -579,17 +579,26 @@ static int acerhdf_register_platform(void)
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
>  {
> -	if (!acerhdf_dev)
> -		return;
> -
> -	platform_device_del(acerhdf_dev);
> +	platform_device_unregister(acerhdf_dev);
>  	platform_driver_unregister(&acerhdf_driver);
>  }
>  
> @@ -633,7 +642,7 @@ static int __init acerhdf_init(void)
>  
>  	err = acerhdf_register_platform();
>  	if (err)
> -		goto err_unreg;
> +		goto out_err;
>  
>  	err = acerhdf_register_thermal();
>  	if (err)
> @@ -646,7 +655,7 @@ err_unreg:
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
