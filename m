Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab1C1VpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 17:45:10 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:45521 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1C1VpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 17:45:09 -0400
Date: Mon, 28 Mar 2011 23:45:05 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] uio: fix allocating minor id for uio device
Message-ID: <20110328214504.GC2786@local>
References: <AANLkTikKNOPi1ALD0vWiwPKDzUJSseuis63qYJKYkj6=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikKNOPi1ALD0vWiwPKDzUJSseuis63qYJKYkj6=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 04:00:39PM +0800, Hillf Danton wrote:

(Added Greg KH to Cc:)

> The number of uio devices that could be used should be less than
> UIO_MAX_DEVICES by design,
> and this work guards any cases in which id more than UIO_MAX_DEVICES
> is utilized.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- a/drivers/uio/uio.c	2011-01-05 08:50:20.000000000 +0800
> +++ b/drivers/uio/uio.c	2011-03-27 15:05:26.000000000 +0800
> @@ -381,7 +381,13 @@ static int uio_get_minor(struct uio_devi
>  			retval = -ENOMEM;
>  		goto exit;
>  	}
> -	idev->minor = id & MAX_ID_MASK;
> +	if (id < UIO_MAX_DEVICES)
> +		idev->minor = id;
> +	else {
> +		printk(KERN_ERR "uio: too many uio devices\n");

No printk(), please. Use dev_err().
Otherwise, it looks good to me.

Thanks,
Hans

> +		retval = -EINVAL;
> +		idr_remove(&uio_idr, id);
> +	}
>  exit:
>  	mutex_unlock(&minor_lock);
>  	return retval;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
