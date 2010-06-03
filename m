Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab0FCL5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 07:57:34 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:47151 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0FCL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 07:57:33 -0400
Date: Thu, 3 Jun 2010 13:57:27 +0200
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Johan Hovold <jhovold@gmail.com>,
       Alan Cox <alan@linux.intel.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Message-ID: <20100603115727.GY2695@buzzloop.caiaq.de>
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 01:55:02PM +0200, Daniel Mack wrote:
> Call set_mctrl() and clear_mctrl() according to the flow control mode
> selected. This makes serial communication for FT232 connected devices
> work when CRTSCTS is not set.
> 
> This fixes a regression introduced by 4175f3e31 ("tty_port: If we are
> opened non blocking we still need to raise the carrier"). This patch
> calls the low-level driver's dtr_rts() function which consequently sets
> TIOCM_DTR | TIOCM_RTS. A later call to set_termios() without CRTSCTS in
> cflags, however, does not reset these bits, and so data is not actually
> sent out on the serial wire.
> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Johan Hovold <jhovold@gmail.com>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: linux-usb@vger.kernel.org

Oops. I forgot to Cc: stable@kernel.org.
This is in fact broken since 2.6.31-something.




> ---
>  drivers/usb/serial/ftdi_sio.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
> index 050211a..79dd1ae 100644
> --- a/drivers/usb/serial/ftdi_sio.c
> +++ b/drivers/usb/serial/ftdi_sio.c
> @@ -2005,6 +2005,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
>  				"urb failed to set to rts/cts flow control\n");
>  		}
>  
> +		/* raise DTR/RTS */
> +		set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>  	} else {
>  		/*
>  		 * Xon/Xoff code
> @@ -2052,6 +2054,8 @@ static void ftdi_set_termios(struct tty_struct *tty,
>  			}
>  		}
>  
> +		/* lower DTR/RTS */
> +		clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
>  	}
>  	return;
>  }
> -- 
> 1.7.1
> 
