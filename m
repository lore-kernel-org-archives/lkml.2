Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab2GYWrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 18:47:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34761 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751206Ab2GYWrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 18:47:33 -0400
X-Sasl-enc: IjTTaOYtF+6+N3910sbv1Wy2pN7SWUcvxO2e6pCpYA4k 1343256452
Date: Wed, 25 Jul 2012 15:47:31 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
Message-ID: <20120725224731.GA14020@kroah.com>
References: <20120720150237.af0d271624511fc18705f287@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120720150237.af0d271624511fc18705f287@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 03:02:37PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/usb/serial/console.c: In function 'usb_console_setup':
> drivers/usb/serial/console.c:168:16: error: invalid type argument of '->' (have 'struct ktermios')
> drivers/usb/serial/console.c:169:4: error: incompatible type for argument 1 of 'tty_termios_encode_baud_rate'
> include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument is of type 'struct ktermios'
> 
> Caused by commit adc8d746caa6 ("tty: move the termios object into the
> tty").  Hopefully this is the last of them.
> 
> I have added the following fix patch for today:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 20 Jul 2012 14:58:31 +1000
> Subject: [PATCH] tty: fix up usb serial console for termios change.
> 
> fixes these errors:
> 
> drivers/usb/serial/console.c: In function 'usb_console_setup':
> drivers/usb/serial/console.c:168:16: error: invalid type argument of '->' (have 'struct ktermios')
> drivers/usb/serial/console.c:169:4: error: incompatible type for argument 1 of 'tty_termios_encode_baud_rate'
> include/linux/tty.h:449:13: note: expected 'struct ktermios *' but argument is of type 'struct ktermios'
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/usb/serial/console.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/serial/console.c b/drivers/usb/serial/console.c
> index b9cca6d..9a56428 100644
> --- a/drivers/usb/serial/console.c
> +++ b/drivers/usb/serial/console.c
> @@ -165,8 +165,8 @@ static int usb_console_setup(struct console *co, char *options)
>  		}
>  
>  		if (serial->type->set_termios) {
> -			tty->termios->c_cflag = cflag;
> -			tty_termios_encode_baud_rate(tty->termios, baud, baud);
> +			tty->termios.c_cflag = cflag;
> +			tty_termios_encode_baud_rate(&tty->termios, baud, baud);
>  			memset(&dummy, 0, sizeof(struct ktermios));
>  			serial->type->set_termios(tty, port, &dummy);
>  

Alan, any objection to this?

greg k-h
