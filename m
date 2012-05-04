Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab2EDP1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:27:33 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:60024 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750813Ab2EDP1a convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:27:30 -0400
From: Preston Fick <Preston.Fick@silabs.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Preston Fick <pffick@gmail.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Date: Fri, 4 May 2012 10:27:09 -0500
Subject: RE: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Thread-Topic: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Thread-Index: Ac0pa9G+LhW06sy/QtO9VigJN9gCmAAnikTQ
Message-ID: <00374F755A5C474884D69FBCA77349D105227D97FB@EXCAUS002.silabs.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
 <20120503213456.77c55c51@pyramind.ukuu.org.uk>
In-Reply-To: <20120503213456.77c55c51@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan -

Thanks for this detailed explanation - I'll continue to look deeper into this, a lot of this is new to me. If Greg is in agreement here, then I will work on this as a solution to our GPIO support and submit a series of patches for this when it's ready and tested.

Kind Regards -
Preston

-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: Thursday, May 03, 2012 3:35 PM
To: Preston Fick
Cc: gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; linux-serial@vger.kernel.org; Preston Fick; linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)


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
This message (including any attachments) is intended only for the use of the individual or entity to which it is addressed and may contain information that is non-public, proprietary, privileged, confidential, and exempt from disclosure under applicable law or may constitute as attorney work product.  If you are not the intended recipient, you are hereby notified that any use, dissemination, distribution, or copying of this communication is strictly prohibited. If you have received this communication in error, notify us immediately by telephone and (i) destroy this message if a facsimile or (ii) delete this message immediately if this is an electronic communication.  

Thank you.


