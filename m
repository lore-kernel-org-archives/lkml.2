Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016Ab2D0LUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 07:20:15 -0400
Received: from nasmtp01.atmel.com ([192.199.1.245]:52301 "EHLO
	nasmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab2D0LUN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 07:20:13 -0400
From: "Chen, Bo" <Bo.Chen@atmel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        "rick@efn.org" <rick@efn.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Query] serial: AT91:  Add SIM Driver
Thread-Topic: [Query] serial: AT91:  Add SIM Driver
Thread-Index: AQHNIT97IHJvDx2tRsOQLbzjAsUm2pauW71w
Date: Fri, 27 Apr 2012 11:19:18 +0000
Message-ID: <7AD597EA49E297498E79AFA326C986BB0D31A5CE@penmbx02>
References: <7AD597EA49E297498E79AFA326C986BB0D317277@penmbx01>
 <20120423115440.5bb1c7eb@pyramind.ukuu.org.uk>
In-Reply-To: <20120423115440.5bb1c7eb@pyramind.ukuu.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.217.3.106]
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> One way would be to make ISO7816 a line discipline (the layer which sits about the tty).

>Your user space interface would then be

>	int ldisc = N_ISO7816;
>	ioctl(tty_fd, TIOCSETD, &ldisc);

Make ISO7816 a line discipline would register it in driver(atmel_serial.c or a new named driver) via tty_register_ldisc(N_ISO7816, &tty_ldisc_ops)
If I use ioctl(tty_fd, TIOCSETD, &ldisc), it will close current line discipline and open a new line discipline related to ISO7816 (tty_register_ldisc(N_ISO7816, &tty_ldisc_ops))?

> at which point the read/write/ioctl etc calls on your tty will also be    > routed via your ldisc so you can manage them and provide ISO7816 sensible > interfaces

Does it mean when I call read/write/ioctl in user space, it will call tty_ldisc_ops functions (ISO7816 line discipline has been opened) such as gsmld_read/gsmld_write/gsmld_ioctl in N_gsm.c? What I need to do is to implement the interface in tty_ldisc_ops?


> Take a look at the gsmld_ parts of drivers/tty/n_gsm.c for a fairly full  > example of a line discipline. You can ignore most of the rest of the code  > there, the rest is implementing GSM mux and virtual ttys.

What is the reasonable way to add this line discipline, in atmel_serial.c or create a new driver (build as a module and dynamically load)? Would it be accepted by kernel mainline?

Thanks,
Bo Chen





-----Original Message-----
From: Alan Cox [mailto:alan@lxorguk.ukuu.org.uk] 
Sent: 2012年4月23日 18:55
To: Chen, Bo
Cc: alan@linux.intel.com; rick@efn.org; linux-serial@vger.kernel.org; linux-arm-kernel@lists.arm.linux.org.uk; linux-kernel@vger.kernel.org
Subject: Re: [Query] serial: AT91: Add SIM Driver

> I mean to create a char driver which contains ioctl interface to control GPIOs connected to SIM card VCC and RESET.

We have a GPIO layer and existing GPIO interface support so the gpio side
if they are kept independent ought to be easy. However I wonder if the
separate gpio control will make the userspace side harder ?

> Thirdly, I want to use usual tty function (read / write) to implement the ATR / send or receive command / PPS.
> That means tty usual driver read or write will be called by user space application such as openct or else to realize the ATR and PPS.
> Openct may also call above char driver to realize the power or reset function.

That may be difficult to get right because of the tty object lifetime
and the locking rules. One way would be to make ISO7816 a line discipline
(the layer which sits about the tty).

Your user space interface would then be

	int ldisc = N_ISO7816;
	ioctl(tty_fd, TIOCSETD, &ldisc);

at which point the read/write/ioctl etc calls on your tty will also be
routed via your ldisc so you can manage them and provide ISO7816 sensible
interfaces.

You'd still need a way for the ldisc to ask the tty device to manage the
GPIO lines but I don't think that is too tricky to add.

That way it would at least keep everything in one place and avoid adding
new strange paths calling into the tty layer code via non tty devices.


Take a look at the gsmld_ parts of drivers/tty/n_gsm.c for a fairly full
example of a line discipline. You can ignore most of the rest of the code
there, the rest is implementing GSM mux and virtual ttys.

The two thing s it doesn't use are

tty_set_termios(tty, &whatever)

which is a helper for the ldisc or similar to set the terminal state
itself. 

and

tty->driver->ops->tiocmget/tiocmset/etc

for doing things like modem lines. One way to handle the gpios
transparently might be to map them to the nearest equivalent 'modem' line
when in ISO7816 mode.

The tty also sees the ldisc change via tty->ops->set_ldisc(). This is
used by some drivers already for things like automatically selecting IRDA
FIR mode when in IRDA modes.

In your case the driver would set/exit ISO7816 mode when it saw this.

Alan
