Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab2DDM33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 08:29:29 -0400
Received: from sncsmrelay2.nai.com ([67.97.80.206]:19827 "EHLO
	sncsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2DDM31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 08:29:27 -0400
Message-ID: <4F7C3DBE.2050606@snapgear.com>
Date: Wed, 4 Apr 2012 22:25:34 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: <gregkh@linuxfoundation.org>, <alan@linux.intel.com>,
        <linux-kernel@vger.kernel.org>, <jirislaby@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 62/69] TTY: 68328serial, use tty_port_block_til_ready
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz> <1333367693-3244-63-git-send-email-jslaby@suse.cz>
In-Reply-To: <1333367693-3244-63-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 04/02/2012 09:54 PM, Jiri Slaby wrote:
> Since the code is identical, use the tty_port_block_til_ready helper
> instead of re-implemented variant.
>
> The code does not perform rtsdts handling, hence we do not need to
> provide tty port hooks for them. The default ones will be used
> instead. The only necessary thing is to provide tty_port_operations.
> It is empty, but has to be there...
>
> Signed-off-by: Jiri Slaby<jslaby@suse.cz>
> Cc: Geert Uytterhoeven<geert@linux-m68k.org>
> Cc: linux-m68k@lists.linux-m68k.org

I have no problem with any of the 12 patches that work on 68328serial.
So for me:

Acked-by: Greg Ungerer <gerg@uclinux.org>

I myself have nothing to test it on though.

Really the only thing remaining is to convert it to a new style serial
driver. Don't suppose you want to take that on :-)

Regards
Greg



> ---
>   drivers/tty/serial/68328serial.c |   96 ++------------------------------------
>   1 file changed, 5 insertions(+), 91 deletions(-)
>
> diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
> index 77e10bb..3ed20e4 100644
> --- a/drivers/tty/serial/68328serial.c
> +++ b/drivers/tty/serial/68328serial.c
> @@ -1104,96 +1104,6 @@ void rs_hangup(struct tty_struct *tty)
>   }
>
>   /*
> - * ------------------------------------------------------------
> - * rs_open() and friends
> - * ------------------------------------------------------------
> - */
> -static int block_til_ready(struct tty_struct *tty, struct file * filp,
> -			   struct m68k_serial *info)
> -{
> -	struct tty_port *port =&info->tport;
> -	DECLARE_WAITQUEUE(wait, current);
> -	int		retval;
> -	int		do_clocal = 0;
> -
> -	/*
> -	 * If the device is in the middle of being closed, then block
> -	 * until it's done, and then try again.
> -	 */
> -	if (port->flags&  ASYNC_CLOSING) {
> -		interruptible_sleep_on(&port->close_wait);
> -#ifdef SERIAL_DO_RESTART
> -		if (port->flags&  ASYNC_HUP_NOTIFY)
> -			return -EAGAIN;
> -		else
> -			return -ERESTARTSYS;
> -#else
> -		return -EAGAIN;
> -#endif
> -	}
> -	
> -	/*
> -	 * If non-blocking mode is set, or the port is not enabled,
> -	 * then make the check up front and then exit.
> -	 */
> -	if ((filp->f_flags&  O_NONBLOCK) ||
> -	    (tty->flags&  (1<<  TTY_IO_ERROR))) {
> -		port->flags |= ASYNC_NORMAL_ACTIVE;
> -		return 0;
> -	}
> -
> -	if (tty->termios->c_cflag&  CLOCAL)
> -		do_clocal = 1;
> -
> -	/*
> -	 * Block waiting for the carrier detect and the line to become
> -	 * free (i.e., not in use by the callout).  While we are in
> -	 * this loop, port->count is dropped by one, so that
> -	 * rs_close() knows when to free things.  We restore it upon
> -	 * exit, either normal or abnormal.
> -	 */
> -	retval = 0;
> -	add_wait_queue(&port->open_wait,&wait);
> -
> -	port->count--;
> -	port->blocked_open++;
> -	while (1) {
> -		current->state = TASK_INTERRUPTIBLE;
> -		if (tty_hung_up_p(filp) ||
> -		    !(port->flags&  ASYNC_INITIALIZED)) {
> -#ifdef SERIAL_DO_RESTART
> -			if (port->flags&  ASYNC_HUP_NOTIFY)
> -				retval = -EAGAIN;
> -			else
> -				retval = -ERESTARTSYS;	
> -#else
> -			retval = -EAGAIN;
> -#endif
> -			break;
> -		}
> -		if (!(port->flags&  ASYNC_CLOSING)&&  do_clocal)
> -			break;
> -                if (signal_pending(current)) {
> -			retval = -ERESTARTSYS;
> -			break;
> -		}
> -		tty_unlock();
> -		schedule();
> -		tty_lock();
> -	}
> -	current->state = TASK_RUNNING;
> -	remove_wait_queue(&port->open_wait,&wait);
> -	if (!tty_hung_up_p(filp))
> -		port->count++;
> -	port->blocked_open--;
> -
> -	if (retval)
> -		return retval;
> -	port->flags |= ASYNC_NORMAL_ACTIVE;
> -	return 0;
> -}	
> -
> -/*
>    * This routine is called whenever a serial port is opened.  It
>    * enables interrupts for a serial port, linking in its S structure into
>    * the IRQ chain.   It also performs the serial-specific
> @@ -1220,7 +1130,7 @@ int rs_open(struct tty_struct *tty, struct file * filp)
>   	if (retval)
>   		return retval;
>
> -	return block_til_ready(tty, filp, info);
> +	return tty_port_block_til_ready(&info->tport, tty, filp);
>   }
>
>   /* Finally, routines used to initialize the serial driver. */
> @@ -1248,6 +1158,9 @@ static const struct tty_operations rs_ops = {
>   	.set_ldisc = rs_set_ldisc,
>   };
>
> +static const struct tty_port_operations rs_port_ops = {
> +};
> +
>   /* rs_init inits the driver */
>   static int __init
>   rs68328_init(void)
> @@ -1288,6 +1201,7 @@ rs68328_init(void)
>
>   	    info =&m68k_soft[i];
>   	    tty_port_init(&info->tport);
> +	    info->tport.ops =&rs_port_ops;
>   	    info->magic = SERIAL_MAGIC;
>   	    info->port = (int)&uart_addr[i];
>   	    info->irq = uart_irqs[i];


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
