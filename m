Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab1BDXLR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 18:11:17 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:42032 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582Ab1BDXLQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 18:11:16 -0500
Date: Fri, 4 Feb 2011 15:10:18 -0800
From: Andres Salomon <dilinger@queued.net>
To: Marek Belisko <marek.belisko@open-nandra.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        cjb@laptop.org, jon.nettleton@gmail.com
Subject: Re: [PATCH] staging: oplc_dcon: Fix compilation warning.
Message-ID: <20110204151018.667abf02@debxo>
In-Reply-To: <1296739328-11960-1-git-send-email-marek.belisko@open-nandra.com>
References: <1296739328-11960-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, looks good to me.  It should probably go in for 2.6.38.

Acked-by: Andres Salomon <dilinger@queued.net>


On Thu,  3 Feb 2011
14:22:08 +0100 Marek Belisko <marek.belisko@open-nandra.com> wrote:

> Fix compilation warning:
> drivers/staging/olpc_dcon/olpc_dcon.c: In function ‘dcon_probe’:
> drivers/staging/olpc_dcon/olpc_dcon.c:704:21: warning: ignoring
> return value of ‘device_create_file’, declared with attribute
> warn_unused_result
> 
> and add cleaning of created files when creation of one failed.
> 
> Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
> ---
>  drivers/staging/olpc_dcon/olpc_dcon.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/olpc_dcon/olpc_dcon.c
> b/drivers/staging/olpc_dcon/olpc_dcon.c index 56a283d..7221bb8 100644
> --- a/drivers/staging/olpc_dcon/olpc_dcon.c
> +++ b/drivers/staging/olpc_dcon/olpc_dcon.c
> @@ -674,7 +674,7 @@ static int dcon_detect(struct i2c_client *client,
> struct i2c_board_info *info) 
>  static int dcon_probe(struct i2c_client *client, const struct
> i2c_device_id *id) {
> -	int rc, i;
> +	int rc, i, j;
>  
>  	if (num_registered_fb >= 1)
>  		fbinfo = registered_fb[0];
> @@ -700,8 +700,14 @@ static int dcon_probe(struct i2c_client *client,
> const struct i2c_device_id *id) goto edev;
>  	}
>  
> -	for(i = 0; i < ARRAY_SIZE(dcon_device_files); i++)
> -		device_create_file(&dcon_device->dev,
> &dcon_device_files[i]);
> +	for(i = 0; i < ARRAY_SIZE(dcon_device_files); i++) {
> +		rc = device_create_file(&dcon_device->dev,
> +					&dcon_device_files[i]);
> +		if (rc) {
> +			dev_err(&dcon_device->dev, "Cannot create
> sysfs file\n");
> +			goto ecreate;
> +		}
> +	}
>  
>  	/* Add the backlight device for the DCON */
>  
> @@ -728,6 +734,9 @@ static int dcon_probe(struct i2c_client *client,
> const struct i2c_device_id *id) 
>  	return 0;
>  
> + ecreate:
> +	for (j = 0; j < i; j++)
> +		device_remove_file(&dcon_device->dev,
> &dcon_device_files[j]); edev:
>  	platform_device_unregister(dcon_device);
>  	dcon_device = NULL;

