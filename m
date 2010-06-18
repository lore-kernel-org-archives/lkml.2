Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409Ab0FRSRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:17:33 -0400
Received: from mga01.intel.com ([192.55.52.88]:12444 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761393Ab0FRSRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:17:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,440,1272870000"; 
   d="scan'208";a="809357610"
Date: Fri, 18 Jun 2010 20:17:11 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: ab3100-otp: fix memory leak in ab3100_otp_probe
Message-ID: <20100618181710.GD3582@sortiz.org>
References: <1274770191.6998.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274770191.6998.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, May 25, 2010 at 02:49:51PM +0800, Axel Lin wrote:
> In current implementation, there is a memory leak if ab3100_otp_read fail.
> And in the case of ab3100_otp_init_debugfs fail, it does not properly remove
> sysfs entries.
> This patch properly handle above failure cases.
Patch applied, thanks a lot.

Cheers,
Samuel.


> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/ab3100-otp.c |   16 ++++++++--------
>  1 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mfd/ab3100-otp.c b/drivers/mfd/ab3100-otp.c
> index 2d14655..939b876 100644
> --- a/drivers/mfd/ab3100-otp.c
> +++ b/drivers/mfd/ab3100-otp.c
> @@ -202,7 +202,7 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
>  
>  	err = ab3100_otp_read(otp);
>  	if (err)
> -		return err;
> +		goto err_otp_read;
>  
>  	dev_info(&pdev->dev, "AB3100 OTP readout registered\n");
>  
> @@ -211,21 +211,21 @@ static int __init ab3100_otp_probe(struct platform_device *pdev)
>  		err = device_create_file(&pdev->dev,
>  					 &ab3100_otp_attrs[i]);
>  		if (err)
> -			goto out_no_sysfs;
> +			goto err_create_file;
>  	}
>  
>  	/* debugfs entries */
>  	err = ab3100_otp_init_debugfs(&pdev->dev, otp);
>  	if (err)
> -		goto out_no_debugfs;
> +		goto err_init_debugfs;
>  
>  	return 0;
>  
> -out_no_sysfs:
> -	for (i = 0; i < ARRAY_SIZE(ab3100_otp_attrs); i++)
> -		device_remove_file(&pdev->dev,
> -				   &ab3100_otp_attrs[i]);
> -out_no_debugfs:
> +err_init_debugfs:
> +err_create_file:
> +	while (--i >= 0)
> +		device_remove_file(&pdev->dev, &ab3100_otp_attrs[i]);
> +err_otp_read:
>  	kfree(otp);
>  	return err;
>  }
> -- 
> 1.5.4.3
> 
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
