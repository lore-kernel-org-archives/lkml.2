Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485Ab1D1UCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 16:02:18 -0400
Received: from waste.org ([173.11.57.241]:52473 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933419Ab1D1UCP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 16:02:15 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Apr 2011 16:02:15 EDT
Subject: Re: [PATCH 1/2] hwrng: manage resource allocation in amd driver
From: Matt Mackall <mpm@selenic.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>
In-Reply-To: <1303932076-7428-1-git-send-email-dbaryshkov@gmail.com>
References: <1303932076-7428-1-git-send-email-dbaryshkov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Apr 2011 14:51:53 -0500
Message-ID: <1304020313.20288.1.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 23:21 +0400, Dmitry Eremin-Solenikov wrote:
> As amd driver doesn't bind to PCI device, we'd better manage reource
> allocation on our own to disallow (possible) conflicts.

These two look good to me.

Acked-by: Matt Mackall <mpm@selenic.com>

> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> ---
>  drivers/char/hw_random/amd-rng.c |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/hw_random/amd-rng.c b/drivers/char/hw_random/amd-rng.c
> index 0d8c578..c6af038 100644
> --- a/drivers/char/hw_random/amd-rng.c
> +++ b/drivers/char/hw_random/amd-rng.c
> @@ -133,6 +133,12 @@ found:
>  	pmbase &= 0x0000FF00;
>  	if (pmbase == 0)
>  		goto out;
> +	if (!request_region(pmbase + 0xF0, 8, "AMD HWRNG")) {
> +		dev_err(&pdev->dev, "AMD HWRNG region 0x%x already in use!\n",
> +			pmbase + 0xF0);
> +		err = -EBUSY;
> +		goto out;
> +	}
>  	amd_rng.priv = (unsigned long)pmbase;
>  	amd_pdev = pdev;
>  
> @@ -141,6 +147,7 @@ found:
>  	if (err) {
>  		printk(KERN_ERR PFX "RNG registering failed (%d)\n",
>  		       err);
> +		release_region(pmbase + 0xF0, 8);
>  		goto out;
>  	}
>  out:
> @@ -149,6 +156,8 @@ out:
>  
>  static void __exit mod_exit(void)
>  {
> +	u32 pmbase = (unsigned long)amd_rng.priv;
> +	release_region(pmbase + 0xF0, 8);
>  	hwrng_unregister(&amd_rng);
>  }
>  


-- 
Mathematics is the supreme nostalgia of our time.


