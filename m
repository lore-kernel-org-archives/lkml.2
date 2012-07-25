Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2GYNb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:31:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64563 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756316Ab2GYNb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:31:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: Re: [PATCH] misc/pch_phub: Enable UART clock setting by module parameter
Date: Wed, 25 Jul 2012 13:31:52 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
References: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com> <CANKRQni4SU=876iPtHJ2WC3Ub7QProJqHZ53Ru-n-njsdg8D5A@mail.gmail.com> <CANKRQnhcFr+e1H5p==UUTWfYb2nzdt8aVnOn2NvmYAXFiDxqew@mail.gmail.com>
In-Reply-To: <CANKRQnhcFr+e1H5p==UUTWfYb2nzdt8aVnOn2NvmYAXFiDxqew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207251331.52883.arnd@arndb.de>
X-Provags-ID: V02:K0:9Hcx0rB+7yX59NgVHwBufvdQWyV1Ew9gZ+dipqMGXoM
 9snX0jeViUY7/MhAmhnnEGmXzSlYf71qaaV1djEZwdCf7lT0SI
 Fz7ZzhefBpojAXtyz2xPjhLsTZ2N069W9GxvmMa0ubXlNGrBTQ
 xOqUpcGfjuBIBQFXIPT6Yl9G2vxwzoKFMDbKyeT8s100wam8YJ
 mg4C+iU0SJFjRLwHhrPhGiGrDHJNGEalc4PRSThJ79A+++4KmZ
 Mphz/TJguK+c1+PkolmQL8z9c2Hy95WC2puCWw2T0RQJuw3agw
 jVzD2l9eyyN6PGV6+xvy86XkV82fTFtWyDzYQBKVsR6EQdLBsO
 /pNdjck9QzY/JuAFbnc8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomoya,

On Tuesday 24 July 2012, Tomoya MORINAGA wrote:
> Let me know this patch status.
> If you have still any concern, let me know.

Sorry for the late reply.

> BTW, now I remember, Did you take part in LinuxConJapan last month ?
> I also took part in this event as volunteer staff.
> Additionally, I took charge of your session as time keeper.
> 
> Thanks in advance.
> -- 
> ROHM Co., Ltd.
> tomoya
> 
> On Thu, Jul 12, 2012 at 9:54 AM, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> > On Wed, Jul 11, 2012 at 7:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> This looks like a rather nonscalable solution if you get to systems
> >> with lots of clocks.
> >
> > This "clock" is internal clock, not external clock.
> > This PacketHub provides clock to the UART module
> > Both the PacketHub and the UART is in 1 chip LSI which is EG20T.
> > So, selectable clock 1.8432MHz or 48MHz or 64MHz or 192MHz are enough.

Right, I got this part.

> >> Given that you are doing it for the uart clock, shouldn't that be
> >> set from the uart driver using an ioctl like other serial ports do?
> > PacketHub is not serial driver but special driver. So, ioctl doesn't
> > suit PacketHub.
> >
> >> What would be the use case for an end user to override the module
> >> parameter? Is it about platform specific settings or policy?
> > I show use case.
> > Currently, UART works with 1.8432MHz.
> > Using this clock, as you know, maximum speed is 115k.
> > A user wants to use 4M speed, the user need to modify pch_phun.c by hand.
> > If this patch is applied, a user can specify uart_clock via a modules
> > parameter and use 4M speed.
> >
> > My reference driver for this patch is drivers/tty/serial/pch_uart.c
> > This driver can set uart_clock via a module parameter(user_uartclk).

It's clear that modifying the source code is not a good solution, so
I agree something should be done about it.

What I think should work better here would be to use the clk API,
so that the phub driver registers a 'struct clk' using 
(I assume) clk_register_divider_table().
The UART driver would then call clk_get() to find that clk for
the uart device and call clk_set_rate when it needs to change
that clock in order to set a different baud rate.

Does this make sense?

	Arnd
