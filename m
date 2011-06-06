Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758032Ab1FFUsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:48:51 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:43092 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757042Ab1FFUss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:48:48 -0400
Date: Mon, 6 Jun 2011 16:48:34 -0400
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-serial@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [RFC 3/5] serial: add support for Technologic Systems TS-5500
 RS-485 serial port
Message-ID: <20110606164834.5894deda@v0nbox>
In-Reply-To: <20110430111753.69466ae5@lxorguk.ukuu.org.uk>
References: <1304115712-5299-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1304115712-5299-4-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110430111753.69466ae5@lxorguk.ukuu.org.uk>
Organization: Savoir-faire Linux Inc.
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Sorry for the late reply to this comment.

On Sat, 30 Apr 2011 11:17:53
+0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote :
> > --- a/drivers/tty/serial/8250.c
> > +++ b/drivers/tty/serial/8250.c
> > @@ -109,6 +109,13 @@ static unsigned int skip_txen_test; /* force
> > skip of txen test at init time */
> >  #define CONFIG_HUB6 1
> >
> >  #include <asm/serial.h>
> > +
> > +/* TS-5500 related stuff */
> > +#ifdef CONFIG_SERIAL_8250_TS5500_485_TIMER
> > +#define TS5500_TIMER2_SPEED_ADDR        0x42
> > +#define TS5500_485_SERIAL_PORT                0x02
> > +#endif
> > +
> >  /*
> >   * SERIAL_PORT_DFNS tells us about built-in ports that have no
> >   * standard enumeration mechanism.   Platforms that can find all
> > @@ -437,6 +444,25 @@ static void au_serial_out(struct uart_port *p,
> > int offset, int value)
> >          __raw_writel(value, p->membase + offset);
> >  }
> >
> > +#ifdef CONFIG_SERIAL_8250_TS5500_485_TIMER
> > +void serial8250_ts5500_set_termios(struct uart_port *port,
> > +                                   struct ktermios *new,
> > +                                   struct ktermios *old)
> > +{
> > +        u16 speed;
> > +
> > +        if (new->c_ospeed >= 9600 && port->line ==
> > TS5500_485_SERIAL_PORT) {
> > +                speed = ((115200 * 2) / new->c_ospeed);
> > +
> > +                /* This should be written by low byte followed by
> > high byte */
> > +                spin_lock_irq(&port->lock);
> > +                outb((speed & 0x0F), TS5500_TIMER2_SPEED_ADDR);
> > +                outb((speed >> 8), TS5500_TIMER2_SPEED_ADDR);
> > +                spin_unlock_irq(&port->lock);
> > +        }
> > +}
> > +#endif
>
> Please don't put board specific magic in this file, we are desperately
> trying to get rid of it.
>
> > +
> >  static unsigned int tsi_serial_in(struct uart_port *p, int offset)
> >  {
> >          unsigned int tmp;
> > @@ -2464,6 +2490,10 @@ serial8250_do_set_termios(struct uart_port
> > *port, struct ktermios *termios,
> >          /* Don't rewrite B0 */
> >          if (tty_termios_baud_rate(termios))
> >                  tty_termios_encode_baud_rate(termios, baud, baud);
> > +
> > +#ifdef CONFIG_SERIAL_8250_TS5500_485_TIMER
> > +        serial8250_ts5500_set_termios(port, termios, old);
> > +#endif
> >  }
> >  EXPORT_SYMBOL(serial8250_do_set_termios);
>
> Provide your own set_termios method and then call into this one (which
> is why it is exported)

I don't really understand how to do this. I've written my own
ts5500_serial8250_set_termios() function, which first makes a call to
serial8250_do_set_termios(), but I don't know how to make the platform
uses this one now. I've seen the plat_serial8250_port structure which
has a set_termios field, but I didn't find an example of usage of this
structure with this field. Maybe that's not the good way to "hook" the
serial8250_do_set_termios() function.
Could you please explain how to do this?

Regards,
Vivien.
