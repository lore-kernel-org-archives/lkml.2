Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab2KFLM7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 06:12:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56398 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750772Ab2KFLM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 06:12:58 -0500
Date: Tue, 6 Nov 2012 11:12:56 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: avoid memory access after freeing it
Message-ID: <20121106111256.GA2512@opensource.wolfsonmicro.com>
References: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352198049-5941-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 04:04:09PM +0530, Laxman Dewangan wrote:
> When regulator_register() failed due to non availability of
>  	mutex_unlock(&regulator_list_mutex);
...
>  }
>  EXPORT_SYMBOL_GPL(regulator_put);
> @@ -3453,11 +3460,10 @@ scrub:
>  		gpio_free(rdev->ena_gpio);
>  	kfree(rdev->constraints);
>  wash:
> +	if (rdev->supply)
> +		__regulator_put_locked(rdev->supply);
>  	device_unregister(&rdev->dev);
> -
>  	mutex_unlock(&regulator_list_mutex);
> -	if (rdev->supply)
> -		regulator_put(rdev->supply);
>  
>  	/* device core frees rdev */
>  	rdev = ERR_PTR(ret);

Here would it not make sense to go slightly further and basically
revert my original change. This feels sensible as it keeps it at
only one location where the mutex is unlocked and removes the
second exit point I added. This would effectively make the code
look like:

scrub:
	if (rdev->supply)
		__regulator_put_locked(rdev->supply);
	if (rdev->ena_gpio)
		gpio_free(rdev->ena_gpio);
	kfree(rdev->constraints);
	device_unregister(&rdev->dev);
	/* device core frees rdev */
	rdev = ERR_PTR(ret);
	goto out;

Otherwise the change looks great to me.

> -- 
> 1.7.1.1
> 
