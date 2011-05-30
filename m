Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1E3GQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:16:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41030 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1E3GQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:16:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KL+/2m39yKZkcNKo6tMPfIBMGAodpwdXXDyu6D4LXpmzEV2k19jwI7i+55uPw/nmDA
         Y8lR1GjvCK1PEJUqsiDBDdXMzlPGat9ZfCzVhM6+l+d6bQeSJBqH+CKihnC7AD4Zr8j2
         cvwf1Eyb6X+VLBTFC3hoYArzYb9zr8Wv5mr5U=
Date: Mon, 30 May 2011 08:16:40 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Dan Carpenter <error27@gmail.com>
Cc: Richard Cochran <richard.cochran@omicron.at>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 2/2] ptp: fix some locking bugs in ptp_read()
Message-ID: <20110530061640.GB3166@riccoc20.at.omicron.at>
References: <20110529195407.GB3099@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110529195407.GB3099@shale.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 10:54:07PM +0300, Dan Carpenter wrote:
> There was an unlock missing on an error path, and a double unlock on
> another error path.
 
Sloppy, sloppy me.

Again, please take this for 3.0-rc2.

Thanks,
Richard

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 93fa22d..e7f301da2 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -130,8 +130,10 @@ ssize_t ptp_read(struct posix_clock *pc,
>  		return -ERESTARTSYS;
>  	}
>  
> -	if (ptp->defunct)
> +	if (ptp->defunct) {
> +		mutex_unlock(&ptp->tsevq_mux);
>  		return -ENODEV;
> +	}
>  
>  	spin_lock_irqsave(&queue->lock, flags);
>  
> @@ -151,10 +153,8 @@ ssize_t ptp_read(struct posix_clock *pc,
>  
>  	mutex_unlock(&ptp->tsevq_mux);
>  
> -	if (copy_to_user(buf, event, cnt)) {
> -		mutex_unlock(&ptp->tsevq_mux);
> +	if (copy_to_user(buf, event, cnt))
>  		return -EFAULT;
> -	}
>  
>  	return cnt;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
