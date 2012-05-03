Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758689Ab2ECUcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 16:32:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58084 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab2ECUcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 16:32:13 -0400
Date: Thu, 3 May 2012 21:34:56 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Preston Fick <pffick@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120503213456.77c55c51@pyramind.ukuu.org.uk>
In-Reply-To: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok this is my suggestion based on GregKH comments and a couple of others
plus some other driver and ldisc stuff that is pending

- register the gpio lines with the gpio layer dynamically
- put them in the right place in the device tree (I'll let Greg advise on
  the best way to do that bit), plus make them visible via the ioctls for
  convenience and as they will be needed anyway in kernel

That provides the user space API

After that I'll add the hooks to the core tty layer code which allow an
ldisc to adjust the gpio lines.

For that we'll need

struct tty_gpio {
	u32 base;
	u16 num;
	u16 reserved;
#define NR_TTY_GPIOMAP 8
	u16 map[NR_TTY_GPIOMAP];
	u32 reserved2[4];
};

and

tty->gpiomap

which will be NULL for most users.


Plus

struct tty_gpio d;
ioctl(tty, TIOCGPIO, &d)

and

ioctl(tty, TIOCSGPIO, &d)

where the only bits that can be updated will be the map.



So the normal use case from user space would be

struct tty_gpio d;
int fd = open("/dev/ttyUSB0", O_RDWR);
ioctl(tty, TIOCSGPIO, &d);

stuff using the gpio driver interfaces

close(fd);


And setting up for a kernel ldisc something like


/* Set a GPIO to LDISC signal mapping for ISO7816 */
ioctl(tty, TIOCGPIO, &d);
d.map[TTY_GPIO_ISO7816_RESET] = d.base;
d.map]TTY_GPIO_ISO7816_VCC] = d.base + 1;
ioctl(tty, TIOCSGPIO, &d);

/* Switch to the ldisc */
ld = N_ISO7816;
ioctl(tty, TCSETD, &ld);


and we can then abstract all the wiring details away to keep the ldisc
portable.


Thoughts ?

Alan
