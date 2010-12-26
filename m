Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0LZSnv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 13:43:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab0LZSnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 13:43:49 -0500
Date: Sun, 26 Dec 2010 10:41:24 -0800
From: Greg KH <gregkh@suse.de>
To: Tsozik <tsozik@yahoo.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] mct_u232: IOCTL implementation
Message-ID: <20101226184124.GA29774@suse.de>
References: <985550.24725.qm@web65704.mail.ac4.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <985550.24725.qm@web65704.mail.ac4.yahoo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 09:39:39PM -0800, Tsozik wrote:
> From: Vadim Tsozik <tsozik@yahoo.com>
> 
> Added mct_u232_ioctl function and implemented TIOCMIWAIT and TIOCGICOUNT commands. MCT u232 p9 is one of a few usb to serail adapters which converts USB +/-5v voltage levels to COM +/-15 voltages. So it can also power COM interfaced devices. This makes it very usable for legacy COM interfaced data-acquisition hardware. I tested new implementation with AWARE Electronics RM-60 radiation meter, which sends pulse via RNG COM line whenever new particle is registered.
> 
> Patch below is based on linux-2.6.35.10-72.fc14.x86_64.

Care to make sure this applies on a kernel that we can actually apply
patches to (i.e 2.6.37-rc6?)  The .35 kernel was a long time ago.

> 
> Signed-off-by: Vadim Tsozik <tsozik@yahoo.com>
> 
> ---
> --- original/mct_u232.c 2010-12-25 21:31:13.744174626 -0500
> +++ mct_u232.c  2010-12-25 21:44:57.714640343 -0500

Care to read over Documentation/SubmittingPatches which shows you the
proper patch level to make a patch against?

> @@ -24,6 +24,12 @@
>   *   Basic tests have been performed with minicom/zmodem transfers and
>   *   modem dialing under Linux 2.4.0-test10 (for me it works fine).
>   *
> + * 24-Apr-2010 Vadim Tsozik <tsozik@yahoo.com>
> + *   - Added implementation of 'TIOCMIWAIT' and 'TIOCGICOUNT' ioctls.
> + *     This routines are necessary if you use mct u232 p9 as data
> + *     acquisition interface. These routines were tested with RM-60 AWARE
> + *     Electronics Radiation Monitor.
> + *

No need to ever add an entry here, your changelog information is now
stored in git,  not in the files themselves.

>   * 04-Nov-2003 Bill Marr <marr at flex dot com>
>   *   - Mimic Windows driver by sending 2 USB 'device request' messages
>   *     following normal 'baud rate change' message.  This allows data to be
> @@ -78,6 +84,8 @@
>  #include <asm/unaligned.h>
>  #include <linux/usb.h>
>  #include <linux/usb/serial.h>
> +#include <linux/serial.h>
> +#include <linux/ioctl.h>
>  #include "mct_u232.h"
> 
>  /*
> @@ -104,6 +112,8 @@ static void mct_u232_break_ctl(struct tt
>  static int  mct_u232_tiocmget(struct tty_struct *tty, struct file *file);
>  static int  mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
>                         unsigned int set, unsigned int clear);
> +static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
> +                        unsigned int cmd, unsigned long arg);
>  static void mct_u232_throttle(struct tty_struct *tty);
>  static void mct_u232_unthrottle(struct tty_struct *tty);
> 
> @@ -150,6 +160,7 @@ static struct usb_serial_driver mct_u232
>         .tiocmset =          mct_u232_tiocmset,
>         .attach =            mct_u232_startup,
>         .release =           mct_u232_release,
> +       .ioctl =             mct_u232_ioctl,

Your email client converted the tabs to spaces, making this patch
unable to apply.  Please fix your email client and also run your patch
through the scripts/checkpatch.pl script before sending it to fix up the
formatting errors that are in it.

Care to try again after doing this, and addressing Pete's concerns?

thanks,

greg k-h
