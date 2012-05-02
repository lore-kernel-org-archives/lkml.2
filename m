Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab2EBUEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 16:04:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33185 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab2EBUEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 16:04:01 -0400
Date: Wed, 2 May 2012 13:03:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Preston Fick <pffick@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, preston.fick@silabs.com
Subject: Re: [PATCH 3/3] usb: cp210x: Add ioctl for GPIO support
Message-ID: <20120502200356.GA25915@kroah.com>
References: <1335845210-5147-1-git-send-email-preston.fick@silabs.com>
 <1335845210-5147-3-git-send-email-preston.fick@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335845210-5147-3-git-send-email-preston.fick@silabs.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:06:50PM -0500, Preston Fick wrote:
> This patch adds support for GPIO for CP210x devices that support it through two
> IOCTLs to get or set the GPIO latch on a CP210x device. The specification for
> this can be found in Silicon Labs AN571 document on section 5.27.1-4.
> 
> Signed-off-by: Preston Fick <preston.fick@silabs.com>
> ---
>  drivers/usb/serial/cp210x.c |   98 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 98 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
> index b3646b8..9d1e542 100644
> --- a/drivers/usb/serial/cp210x.c
> +++ b/drivers/usb/serial/cp210x.c
> @@ -35,6 +35,8 @@
>   */
>  static int cp210x_open(struct tty_struct *tty, struct usb_serial_port *);
>  static void cp210x_close(struct usb_serial_port *);
> +static int cp210x_ioctl(struct tty_struct *tty,
> +	unsigned int cmd, unsigned long arg);
>  static void cp210x_get_termios(struct tty_struct *,
>  	struct usb_serial_port *port);
>  static void cp210x_get_termios_port(struct usb_serial_port *port,
> @@ -175,6 +177,7 @@ static struct usb_serial_driver cp210x_device = {
>  	.bulk_out_size		= 256,
>  	.open			= cp210x_open,
>  	.close			= cp210x_close,
> +	.ioctl			= cp210x_ioctl,
>  	.break_ctl		= cp210x_break_ctl,
>  	.set_termios		= cp210x_set_termios,
>  	.tiocmget 		= cp210x_tiocmget,
> @@ -195,6 +198,10 @@ static struct usb_serial_driver * const serial_drivers[] = {
>  #define CP2104_PARTNUM		0x04
>  #define CP2105_PARTNUM		0x05
>  
> +/* IOCTLs */
> +#define IOCTL_GPIOGET		0x8000
> +#define IOCTL_GPIOSET		0x8001

As Alan pointed out, we can't just add random ioctls for individual
drivers for this type of thing.  We need to standardize on this.

Actually, why can't you use the GPIO subsystem for something like this?
Can't you export your device as both a usb-serial device and a gpio
device and have things work properly that way?

thanks,

greg k-h
