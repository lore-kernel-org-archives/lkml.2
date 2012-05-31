Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab2EaLqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 07:46:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab2EaLqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 07:46:01 -0400
Date: Thu, 31 May 2012 13:45:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] tty: add lockdep annotations
In-Reply-To: <1338456918.2760.1318.camel@edumazet-glaptop>
Message-ID: <alpine.LRH.2.00.1205311343080.14604@twin.jikos.cz>
References: <4FC6189B.9080909@fusionio.com>  <1338402812.2760.413.camel@edumazet-glaptop>  <4FC66D3D.6080509@fusionio.com>  <1338404902.2760.451.camel@edumazet-glaptop>  <1338410107.2760.544.camel@edumazet-glaptop>
 <1338456918.2760.1318.camel@edumazet-glaptop>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012, Eric Dumazet wrote:

> From: Eric Dumazet <edumazet@google.com>
> 
> tty_lock_pair() do the right thing to avoid deadlocks, but should
> instruct LOCKDEP of this to avoid a splat. 

I have submitted very similar patch to Greg/Alan already 3 days ago[1], 
but have been told that this is already fixed. Apparently it wasn't?

[1] https://lkml.org/lkml/2012/5/28/226

> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
> Latest Linus tree still hang on my machine, at least this patch removes
> the lockdep problem...
> 
>  drivers/tty/tty_mutex.c |   19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
> index 69adc80..67feac9 100644
> --- a/drivers/tty/tty_mutex.c
> +++ b/drivers/tty/tty_mutex.c
> @@ -6,11 +6,17 @@
>  
>  /* Legacy tty mutex glue */
>  
> +enum {
> +	TTY_MUTEX_NORMAL,
> +	TTY_MUTEX_NESTED,
> +};
> +
>  /*
>   * Getting the big tty mutex.
>   */
>  
> -void __lockfunc tty_lock(struct tty_struct *tty)
> +static void __lockfunc tty_lock_nested(struct tty_struct *tty,
> +				       unsigned int subclass)
>  {
>  	if (tty->magic != TTY_MAGIC) {
>  		printk(KERN_ERR "L Bad %p\n", tty);
> @@ -18,7 +24,12 @@ void __lockfunc tty_lock(struct tty_struct *tty)
>  		return;
>  	}
>  	tty_kref_get(tty);
> -	mutex_lock(&tty->legacy_mutex);
> +	mutex_lock_nested(&tty->legacy_mutex, subclass);
> +}
> +
> +void __lockfunc tty_lock(struct tty_struct *tty)
> +{
> +	return tty_lock_nested(tty, TTY_MUTEX_NORMAL);
>  }
>  EXPORT_SYMBOL(tty_lock);
>  
> @@ -43,11 +54,11 @@ void __lockfunc tty_lock_pair(struct tty_struct *tty,
>  {
>  	if (tty < tty2) {
>  		tty_lock(tty);
> -		tty_lock(tty2);
> +		tty_lock_nested(tty2, TTY_MUTEX_NESTED);
>  	} else {
>  		if (tty2 && tty2 != tty)
>  			tty_lock(tty2);
> -		tty_lock(tty);
> +		tty_lock_nested(tty, TTY_MUTEX_NESTED);
>  	}
>  }
>  EXPORT_SYMBOL(tty_lock_pair);
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Jiri Kosina
SUSE Labs

