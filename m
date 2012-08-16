Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab2HPSbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:31:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41484 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab2HPSbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:31:20 -0400
Date: Thu, 16 Aug 2012 11:31:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Milo(Woogyom) Kim'" <milo.kim@ti.com>
Subject: Re: [PATCH v2 3/3] backlight: lp855x: remove goto err_sysfs and
 goto err_dev
Message-Id: <20120816113119.85222ba7.akpm@linux-foundation.org>
In-Reply-To: <000701cd747e$9ec822f0$dc5868d0$%han@samsung.com>
References: <000701cd747e$9ec822f0$dc5868d0$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2012 18:25:44 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> This patch removes goto err_sysfs and goto err_dev, which makes code
> a bit smaller.
> 
> ...
>
> --- a/drivers/video/backlight/lp855x_bl.c
> +++ b/drivers/video/backlight/lp855x_bl.c
> @@ -272,29 +272,25 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
>  	if (ret) {
>  		dev_err(lp->dev, "i2c communication err: %d", ret);
>  		if (mode == REGISTER_BASED)
> -			goto err_dev;
> +			return ret;
>  	}
>  
>  	ret = lp855x_backlight_register(lp);
>  	if (ret) {
>  		dev_err(lp->dev,
>  			"failed to register backlight. err: %d\n", ret);
> -		goto err_dev;
> +		return ret;
>  	}
>  
>  	ret = sysfs_create_group(&lp->dev->kobj, &lp855x_attr_group);
>  	if (ret) {
>  		dev_err(lp->dev, "failed to register sysfs. err: %d\n", ret);
> -		goto err_sysfs;
> +		lp855x_backlight_unregister(lp);
> +		return ret;
>  	}
>  
>  	backlight_update_status(lp->bl);
>  	return 0;
> -
> -err_sysfs:
> -	lp855x_backlight_unregister(lp);
> -err_dev:
> -	return ret;
>  }
>  
>  static int __devexit lp855x_remove(struct i2c_client *cl)

err, no.  We've learned from hard experience that having multiple return
points from a non-trivial function easily leads to resource leaks and
missed unlocks.  For this reason, kernel code frequently uses the "goto
out" technique, providing a single site where deallocation and
unlocking occurs.


