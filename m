Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab2CPUPC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:15:02 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42191 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757580Ab2CPUOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:14:49 -0400
Date: Fri, 16 Mar 2012 13:14:45 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Tu, Xiaobing" <xiaobing.tu@intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Du, Alek" <alek.du@intel.com>, "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH v2] tty: hold lock across tty buffer finding and buffer
 filling
Message-ID: <20120316201445.GA1240@kroah.com>
References: <EE928378561BF1449699C96571234A740FCC5EC3@SHSMSX102.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EE928378561BF1449699C96571234A740FCC5EC3@SHSMSX102.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri,

Do you have any objections to me applying the patch below?

thanks,

greg k-h

On Fri, Mar 16, 2012 at 03:00:26AM +0000, Tu, Xiaobing wrote:
> From: Xiaobing Tu <xiaobing.tu@intel.com>
> 
> tty_buffer_request_room is well protected, but while after it returns,
>  it releases the port->lock. tty->buf.tail might be modified
> by either irq handler or other threads. The patch adds more protection
> by holding the lock across tty buffer finding and buffer filling.
> Signed-off-by: Alek Du <alek.du@intel.com>
> Signed-off-by: Xiaobing Tu <xiaobing.tu@intel.com>
> ---
>  drivers/tty/tty_buffer.c |   85 +++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 65 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
> index 6c9b7cd..91e326f 100644
> --- a/drivers/tty/tty_buffer.c
> +++ b/drivers/tty/tty_buffer.c
> @@ -185,25 +185,19 @@ static struct tty_buffer *tty_buffer_find(struct tty_struct *tty, size_t size)
>  	/* Should possibly check if this fails for the largest buffer we
>  	   have queued and recycle that ? */
>  }
> -
>  /**
> - *	tty_buffer_request_room		-	grow tty buffer if needed
> + *	__tty_buffer_request_room		-	grow tty buffer if needed
>   *	@tty: tty structure
>   *	@size: size desired
>   *
>   *	Make at least size bytes of linear space available for the tty
>   *	buffer. If we fail return the size we managed to find.
> - *
> - *	Locking: Takes tty->buf.lock
> + *      Locking: Caller must hold tty->buf.lock
>   */
> -int tty_buffer_request_room(struct tty_struct *tty, size_t size)
> +static int __tty_buffer_request_room(struct tty_struct *tty, size_t size)
>  {
>  	struct tty_buffer *b, *n;
>  	int left;
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&tty->buf.lock, flags);
> -
>  	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
>  	   remove this conditional if its worth it. This would be invisible
>  	   to the callers */
> @@ -225,9 +219,30 @@ int tty_buffer_request_room(struct tty_struct *tty, size_t size)
>  			size = left;
>  	}
>  
> -	spin_unlock_irqrestore(&tty->buf.lock, flags);
>  	return size;
>  }
> +
> +
> +/**
> + *	tty_buffer_request_room		-	grow tty buffer if needed
> + *	@tty: tty structure
> + *	@size: size desired
> + *
> + *	Make at least size bytes of linear space available for the tty
> + *	buffer. If we fail return the size we managed to find.
> + *
> + *	Locking: Takes tty->buf.lock
> + */
> +int tty_buffer_request_room(struct tty_struct *tty, size_t size)
> +{
> +	unsigned long flags;
> +	int length;
> +
> +	spin_lock_irqsave(&tty->buf.lock, flags);
> +	length = __tty_buffer_request_room(tty, size);
> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
> +	return length;
> +}
>  EXPORT_SYMBOL_GPL(tty_buffer_request_room);
>  
>  /**
> @@ -249,14 +264,22 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
>  	int copied = 0;
>  	do {
>  		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
> -		int space = tty_buffer_request_room(tty, goal);
> -		struct tty_buffer *tb = tty->buf.tail;
> +		int space;
> +		unsigned long flags;
> +		struct tty_buffer *tb;
> +
> +		spin_lock_irqsave(&tty->buf.lock, flags);
> +		space = __tty_buffer_request_room(tty, goal);
> +		tb = tty->buf.tail;
>  		/* If there is no space then tb may be NULL */
> -		if (unlikely(space == 0))
> +		if (unlikely(space == 0)) {
> +			spin_unlock_irqrestore(&tty->buf.lock, flags);
>  			break;
> +		}
>  		memcpy(tb->char_buf_ptr + tb->used, chars, space);
>  		memset(tb->flag_buf_ptr + tb->used, flag, space);
>  		tb->used += space;
> +		spin_unlock_irqrestore(&tty->buf.lock, flags);
>  		copied += space;
>  		chars += space;
>  		/* There is a small chance that we need to split the data over
> @@ -286,14 +309,22 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
>  	int copied = 0;
>  	do {
>  		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
> -		int space = tty_buffer_request_room(tty, goal);
> -		struct tty_buffer *tb = tty->buf.tail;
> +		int space;
> +		unsigned long __flags;
> +		struct tty_buffer *tb;
> +
> +		spin_lock_irqsave(&tty->buf.lock, __flags);
> +		space = __tty_buffer_request_room(tty, goal);
> +		tb = tty->buf.tail;
>  		/* If there is no space then tb may be NULL */
> -		if (unlikely(space == 0))
> +		if (unlikely(space == 0)) {
> +			spin_unlock_irqrestore(&tty->buf.lock, __flags);
>  			break;
> +		}
>  		memcpy(tb->char_buf_ptr + tb->used, chars, space);
>  		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
>  		tb->used += space;
> +		spin_unlock_irqrestore(&tty->buf.lock, __flags);
>  		copied += space;
>  		chars += space;
>  		flags += space;
> @@ -344,13 +375,20 @@ EXPORT_SYMBOL(tty_schedule_flip);
>  int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars,
>  								size_t size)
>  {
> -	int space = tty_buffer_request_room(tty, size);
> +	int space;
> +	unsigned long flags;
> +	struct tty_buffer *tb;
> +
> +	spin_lock_irqsave(&tty->buf.lock, flags);
> +	space = __tty_buffer_request_room(tty, size);
> +
> +	tb = tty->buf.tail;
>  	if (likely(space)) {
> -		struct tty_buffer *tb = tty->buf.tail;
>  		*chars = tb->char_buf_ptr + tb->used;
>  		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
>  		tb->used += space;
>  	}
> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
>  	return space;
>  }
>  EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
> @@ -374,13 +412,20 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
>  int tty_prepare_flip_string_flags(struct tty_struct *tty,
>  			unsigned char **chars, char **flags, size_t size)
>  {
> -	int space = tty_buffer_request_room(tty, size);
> +	int space;
> +	unsigned long __flags;
> +	struct tty_buffer *tb;
> +
> +	spin_lock_irqsave(&tty->buf.lock, __flags);
> +	space = __tty_buffer_request_room(tty, size);
> +
> +	tb = tty->buf.tail;
>  	if (likely(space)) {
> -		struct tty_buffer *tb = tty->buf.tail;
>  		*chars = tb->char_buf_ptr + tb->used;
>  		*flags = tb->flag_buf_ptr + tb->used;
>  		tb->used += space;
>  	}
> +	spin_unlock_irqrestore(&tty->buf.lock, __flags);
>  	return space;
>  }
>  EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
> -- 
> 1.7.4.1
