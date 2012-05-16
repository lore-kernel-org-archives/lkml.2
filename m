Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2EPXmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 19:42:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51596 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760765Ab2EPXli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 19:41:38 -0400
Date: Wed, 16 May 2012 16:41:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120516234128.GB2641@kroah.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
 <20120503213456.77c55c51@pyramind.ukuu.org.uk>
 <20120505003208.GA30718@kroah.com>
 <20120516163347.1721406e@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120516163347.1721406e@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 04:33:47PM +0100, Alan Cox wrote:
> So the patch looks like this, which seems nice and compact (UNTESTED)
> 
> commit 4164f9b7074e682fe71dad3b57e78521ef9df492
> Author: Alan Cox <alan@linux.intel.com>
> Date:   Wed May 16 15:13:02 2012 +0100
> 
>     tty: Add a gpio helper set
>     
>     Various tty devices have additional control lines which are sometimes used
>     as GPIO pins and sometimes also tied with the serial port to implement
>     protocols such as ISO7816.
>     
>     This code provides a kernel interface for querying the GPIO range of a tty,
>     and to describe the mapping between GPIO pins and control lines. The latter
>     will be needed for some upcoming line discipline support.
>     
>     [Proposal do not merge yet]
>     
>     Not-Signed-off-by: Alan Cox <alan@linux.intel.com>

Wow, that looks really nice and tiny, if that's all that is needed in
the core, that's great.

> diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
> index a1b9a2f..60550e7 100644
> --- a/drivers/tty/tty_ioctl.c
> +++ b/drivers/tty/tty_ioctl.c
> @@ -1071,6 +1071,39 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
>  	case TCSETXF:
>  		return set_termiox(real_tty, p, TERMIOS_FLUSH);
>  #endif		
> +#ifdef TCGGPIO
> +	case TCGGPIO: {
> +		struct tcgpio gpio;
> +
> +		if (tty->gpio == NULL)
> +			return -EOPNOTSUPP;
> +		mutex_lock(&real_tty->termios_mutex);
> +		memset(&gpio, 0, sizeof(gpio));
> +		gpio.base = tty->gpio->base;
> +		gpio.num = tty->gpio->num;
> +		memcpy(gpio.map, tty->gpio->map, sizeof(gpio.map));
> +		mutex_unlock(&real_tty->termios_mutex);
> +		if (copy_to_user(p, &gpio, sizeof(gpio)))
> +			return -EFAULT;
> +		return 0;
> +	}
> +	case TCSGPIO:
> +        {
> +		struct tcgpio gpio;
> +
> +		if (tty->gpio == NULL)
> +			return -EOPNOTSUPP;
> +		if (copy_from_user(&gpio, p, sizeof(gpio)))
> +			return -EFAULT;
> +		mutex_lock(&real_tty->termios_mutex);
> +		memcpy(tty->gpio->map, gpio.map, sizeof(tty->gpio->map));
> +		/* An ldisc can see this by watching the ioctl go through
> +		but we may want to add a hook */
> +		mutex_unlock(&real_tty->termios_mutex);
> +                return 0;

So how would the lower tty driver get the ioctl to know to now set these
values to the hardware?  I think we at least need a hook for that,
right?  Or would that go through the ldisc?


> +        }
> +                
> +#endif
>  	case TIOCGSOFTCAR:
>  		copy_termios(real_tty, &kterm);
>  		ret = put_user((kterm.c_cflag & CLOCAL) ? 1 : 0,
> diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
> index 199975f..fee17d3 100644
> --- a/include/asm-generic/ioctls.h
> +++ b/include/asm-generic/ioctls.h
> @@ -74,6 +74,8 @@
>  #define TCSETXW		0x5435
>  #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
>  #define TIOCVHANGUP	0x5437
> +#define TCGGPIO		_IOR('T', 0x38, struct tcgpio)
> +#define TCSGPIO		_IOW('T', 0x39, struct tcgpio)
>  
>  #define FIONCLEX	0x5450
>  #define FIOCLEX		0x5451
> diff --git a/include/asm-generic/termios.h b/include/asm-generic/termios.h
> index d0922ad..3adda38 100644
> --- a/include/asm-generic/termios.h
> +++ b/include/asm-generic/termios.h
> @@ -18,6 +18,18 @@ struct winsize {
>  	unsigned short ws_ypixel;
>  };
>  
> +
> +/* GPIO handling */
> +#define NR_TTY_GPIOMAP	8
> +struct tcgpio			/* User copied version */
> +{
> +	u32 base;
> +	u16 num;
> +	u16 reserved;
> +	u32 map[NR_TTY_GPIOMAP];
> +	u32 reserved2[6];
> +};

__u32 and friends instead?

greg k-h
