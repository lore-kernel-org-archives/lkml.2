Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0JYUFw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 16:05:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41096 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757607Ab0JYUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 16:05:51 -0400
Date: Mon, 25 Oct 2010 13:05:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Fulghum <paulkf@microgate.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] n_hdlc fix read and write locking
Message-Id: <20101025130502.77685ac1.akpm@linux-foundation.org>
In-Reply-To: <1288030959.19909.28.camel@x2.microgate.com>
References: <1288030959.19909.28.camel@x2.microgate.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010 13:22:39 -0500
Paul Fulghum <paulkf@microgate.com> wrote:

> Fix locking in read and write code of n_hdlc line discipline.

Missing a couple of cc's here...

> 2.6.36 replaced lock_kernel() with tty_lock().
> The tty mutex is not dropped automatically when the thread
> sleeps like the BKL. This results in a blocked read or write holding
> the tty mutex and stalling operations by other devices that use
> the tty mutex.
> 
> A review of n_hdlc read and write code shows:
> 1. neither BKL or tty mutex are required for correct operation
> 2. read can block while read data is available if data is posted
>    between availability check and call to interruptible_sleep_on()
> 3. write does not set process state to TASK_INTERRUPTIBLE
>    on each pass through the processing loop which can cause
>    unneeded scheduling of the thread
> 
> The unnecessary tty mutex references have been removed.
> 
> Read changed to use same code as n_tty read
> for completing reads and blocking.
> 
> Write corrected to set process state to
> TASK_INTERRUPTIBLE on each pass through processing loop.
> 

And a signed-off-by:, please.

> --- a/drivers/char/n_hdlc.c	2010-10-22 14:22:22.000000000 -0500
> +++ b/drivers/char/n_hdlc.c	2010-10-25 12:36:12.000000000 -0500
> @@ -581,8 +581,9 @@ static ssize_t n_hdlc_tty_read(struct tt
>  			   __u8 __user *buf, size_t nr)
>  {
>  	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
> -	int ret;
> +	int ret = 0;
>  	struct n_hdlc_buf *rbuf;
> +	DECLARE_WAITQUEUE(wait, current);
>  
>  	if (debuglevel >= DEBUG_LEVEL_INFO)	
>  		printk("%s(%d)n_hdlc_tty_read() called\n",__FILE__,__LINE__);
> @@ -598,57 +599,55 @@ static ssize_t n_hdlc_tty_read(struct tt
>  		return -EFAULT;
>  	}
>  
> -	tty_lock();
> +	add_wait_queue(&tty->read_wait, &wait);
>  
>  	for (;;) {
>  		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
> -			tty_unlock();
> -			return -EIO;
> +			ret = -EIO;
> +			break;
>  		}
> +		if (tty_hung_up_p(file))
> +			break;
>  
> -		n_hdlc = tty2n_hdlc (tty);
> -		if (!n_hdlc || n_hdlc->magic != HDLC_MAGIC ||
> -			 tty != n_hdlc->tty) {
> -			tty_unlock();
> -			return 0;
> -		}
> +		set_current_state(TASK_INTERRUPTIBLE);
>  
>  		rbuf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
> -		if (rbuf)
> +		if (rbuf) {
> +			if (rbuf->count > nr) {
> +				/* too large for caller's buffer */
> +				ret = -EOVERFLOW;
> +			} else {
> +				if (copy_to_user(buf, rbuf->buf, rbuf->count))

It's not a bug afaict, but beware that a copy_to_user() will
unconditionally flip this task back into TASK_RUNNING state if it takes
a pagefault.  This means that the below schedule() will fall straight
through.  It looks like the code will handle this correctly?  If so,
it's just a little suboptimal.

> +					ret = -EFAULT;
> +				else
> +					ret = rbuf->count;
> +			}
> +
> +			if (n_hdlc->rx_free_buf_list.count >
> +			    DEFAULT_RX_BUF_COUNT)
> +				kfree(rbuf);
> +			else
> +				n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, rbuf);
>  			break;
> +		}
>  			
>  		/* no data */
>  		if (file->f_flags & O_NONBLOCK) {
> -			tty_unlock();
> -			return -EAGAIN;
> +			ret = -EAGAIN;
> +			break;
>  		}
> -			
> -		interruptible_sleep_on (&tty->read_wait);
> +
> +		schedule();
> +
>  		if (signal_pending(current)) {
> -			tty_unlock();
> -			return -EINTR;
> +			ret = -EINTR;
> +			break;
>  		}
>  	}
> -		
> -	if (rbuf->count > nr)
> -		/* frame too large for caller's buffer (discard frame) */
> -		ret = -EOVERFLOW;
> -	else {
> -		/* Copy the data to the caller's buffer */
> -		if (copy_to_user(buf, rbuf->buf, rbuf->count))
> -			ret = -EFAULT;
> -		else
> -			ret = rbuf->count;
> -	}
> -	
> -	/* return HDLC buffer to free list unless the free list */
> -	/* count has exceeded the default value, in which case the */
> -	/* buffer is freed back to the OS to conserve memory */
> -	if (n_hdlc->rx_free_buf_list.count > DEFAULT_RX_BUF_COUNT)
> -		kfree(rbuf);
> -	else	
> -		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,rbuf);
> -	tty_unlock();
> +
> +	remove_wait_queue(&tty->read_wait, &wait);
> +	set_current_state(TASK_RUNNING);

We normally use __set_current_state() here - it saves a few cycles.

>  	return ret;
>  	
>  }	/* end of n_hdlc_tty_read() */
>
> ...
>
