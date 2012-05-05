Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2EEAcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 20:32:13 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:36224 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758411Ab2EEAcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 20:32:12 -0400
Date: Fri, 4 May 2012 17:32:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120505003208.GA30718@kroah.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
 <20120503213456.77c55c51@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120503213456.77c55c51@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2012 at 09:34:56PM +0100, Alan Cox wrote:
> 
> Ok this is my suggestion based on GregKH comments and a couple of others
> plus some other driver and ldisc stuff that is pending
> 
> - register the gpio lines with the gpio layer dynamically
> - put them in the right place in the device tree (I'll let Greg advise on
>   the best way to do that bit), plus make them visible via the ioctls for
>   convenience and as they will be needed anyway in kernel

Hang them off of the USB-serial device?

> That provides the user space API
> 
> After that I'll add the hooks to the core tty layer code which allow an
> ldisc to adjust the gpio lines.
> 
> For that we'll need
> 
> struct tty_gpio {
> 	u32 base;
> 	u16 num;
> 	u16 reserved;
> #define NR_TTY_GPIOMAP 8
> 	u16 map[NR_TTY_GPIOMAP];
> 	u32 reserved2[4];
> };
> 
> and
> 
> tty->gpiomap
> 
> which will be NULL for most users.
> 
> 
> Plus
> 
> struct tty_gpio d;
> ioctl(tty, TIOCGPIO, &d)
> 
> and
> 
> ioctl(tty, TIOCSGPIO, &d)
> 
> where the only bits that can be updated will be the map.
> 
> 
> 
> So the normal use case from user space would be
> 
> struct tty_gpio d;
> int fd = open("/dev/ttyUSB0", O_RDWR);
> ioctl(tty, TIOCSGPIO, &d);
> 
> stuff using the gpio driver interfaces
> 
> close(fd);
> 
> 
> And setting up for a kernel ldisc something like
> 
> 
> /* Set a GPIO to LDISC signal mapping for ISO7816 */
> ioctl(tty, TIOCGPIO, &d);
> d.map[TTY_GPIO_ISO7816_RESET] = d.base;
> d.map]TTY_GPIO_ISO7816_VCC] = d.base + 1;
> ioctl(tty, TIOCSGPIO, &d);
> 
> /* Switch to the ldisc */
> ld = N_ISO7816;
> ioctl(tty, TCSETD, &ld);
> 
> 
> and we can then abstract all the wiring details away to keep the ldisc
> portable.
> 
> 
> Thoughts ?

Will the new ldisc mess with the tty stuff to prevent "normal" serial
data and line settings from being handled properly?  If not, that all
looks very good to me, thanks for working this out.

greg k-h
