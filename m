Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab0KCDbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 23:31:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56869 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0KCDbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 23:31:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Eli Billauer <eli@billauer.co.il>
Subject: Re: open() on /dev/tty takes 30 seconds on 2.6.36
Date: Wed, 3 Nov 2010 04:32:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <4CCBCD8E.1020601@billauer.co.il> <201011012039.16312.arnd@arndb.de> <4CD0A988.4070204@billauer.co.il>
In-Reply-To: <4CD0A988.4070204@billauer.co.il>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011030432.15393.arnd@arndb.de>
X-Provags-ID: V02:K0:DVQIuSIbXn12yek7oATltS5pDUMuyGEvGCXft8rDlM2
 Pndtc1JAWjDHGNxmJfLgSvHcK29tZ7E9x5wcZCq/ZntVXiVrOX
 wwRJudvYgbleA04s1nAN5/M+HKjdqgpOuqmKr4d8vEXnozGBP9
 6vdP8dLxA6pzD1npWVM7mJB+yiLFFCbnTZw2sXeeie7Yvg5NWy
 PECexbXm/uInjJHKerYYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 November 2010, Eli Billauer wrote:
> Arnd Bergmann wrote:
> 
> > Ok, that's certainly modem-manager in the tty_release function, calling
> > uart_close, which has this code:
> >
> >         if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE) {
> >                 /*
> >                  * hack: open-coded tty_wait_until_sent to avoid
> >                  * recursive tty_lock
> >                  */
> >                 long timeout = msecs_to_jiffies(port->closing_wait);
> >                 if (wait_event_interruptible_timeout(tty->write_wait,
> >                                 !tty_chars_in_buffer(tty), timeout) >= 0)
> >                         __uart_wait_until_sent(uport, timeout);
> >         }
> >
> > port->closing_wait gets initialized to 30 seconds, which fits your
> > symptom.
> >   
> I lost you here. Maybe my version is outdated? The most similar thing I 
> have is this in tty_port.c, in tty_port_close_start():
> 
>     if (test_bit(ASYNCB_INITIALIZED, &port->flags) &&
>             port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
>         tty_wait_until_sent(tty, port->closing_wait);

The code I quoted is from uart_close() in drivers/serial/serial_core.c

> I put a printk on invocations of tty_wait_until_sent(), which was called 
> like crazy during bootup on behalf of tty1, and then never again after 
> boot was completed. I should point out, that during this session, all I 
> did was to wait a few minutes and then reboot the computer from the GUI 
> login console. So I never logged in. Anyhow, the ttySx ports were opened 
> and closed, the same 30 seconds delays, but no call to 
> tty_wait_until_sent() until kernel logging was stopped.

Right. The uart_close() function does not call tty_wait_until_sent,
it calls __uart_wait_until_sent directly.

> > What does "lspci -vvx" show about the
> > port? 
> It turns out, that the device, to which ttyS1-ttyS3 are attached is a 
> soft modem, which doesn't even have drivers for a 64 bits system. There 
> is no /dev/ttyS4, which is consistent with the "Couldn't register serial 
> port 0000:05:04.0: -28" message. Anyhow, I can't say I understand why 
> any serial port was allocated to this modem. But it's not like I 
> understand how it should work.
> 
> 05:04.0 Modem: ALi Corporation SmartLink SmartPCI563 56K Modem (prog-if 
> 00 [Generic])

It should actually be covered by the intel8x0m.c driver as far as I can tell,
but it's missing from the PCI IDs in that driver...

As Alan said, we need to sort out the locking though. One problem is that
we cannot just do tty_unlock/tty_lock around the sleeping call, because we
also hold &port->mutex there, which nests inside of tty_lock().

I hope Alan can figure out if it's either safe to drop both here, or if we
might be able to call uart_close without tty_lock() held in the first place.

	Arnd
