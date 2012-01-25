Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199Ab2AYQ5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 11:57:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:50904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab2AYQ5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 11:57:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] serial/efm32: add new driver
Date: Wed, 25 Jan 2012 16:56:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        devicetree-discuss@lists.ozlabs.org,
        "Greg Kroah-Hartman" <gregkh@suse.de>, kernel@pengutronix.de,
        linux-serial@vger.kernel.org
References: <20111221202847.4ffeba10@bob.linux.org.uk> <20111223204428.GI24496@pengutronix.de> <20120109103458.GD14252@pengutronix.de>
In-Reply-To: <20120109103458.GD14252@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201201251656.55514.arnd@arndb.de>
X-Provags-ID: V02:K0:i3OOd9yXtBphorJfdd+7PMaiRegEqR7QwKug+70HfbA
 o9TbkNvlMJOtz76fLsP3CDZEykl9VOsb/OPUNg4iNVvnjp1TNV
 zw4dUWAt39VZ6SYcp9UVfZD6YpScWdppgw0KiqiPr3qaDMVmKD
 XVD8VhgTutal72/P/1O8/KxbUrKnqEx/BXYe+J1KJ+nCrDEtJ9
 3G6iGYgGU6YwjFP1VDJ/yDSG4Lay5YfoZ5fU2VpW8gen7Dx4FT
 iCnVY70xGS68DamhqYVaYQPsVwtXxUUyGecvWPu2V/AX6LmUcw
 ApmhGxOmZQt6NX20HXtbCBIbQAsp5J+Hq1ruvaleANA52MBN2y
 Zi8KfSmEovzmAfkyQ1k4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 January 2012, Uwe Kleine-König wrote:
> On Fri, Dec 23, 2011 at 09:44:28PM +0100, Uwe Kleine-König wrote:
>  
> > > I would suggest that you also support the "clock-frequency" and/or
> > > "current-speed" properties that are defined for serial ports, see the
> > > of_serial driver.
> > I will have a look to find out what they mean and update the patch
> > accordingly.
> I took that look and I don't understand what they are good for in my
> case.
> clock-frequency is used to initialize port->uartclk (and helps setting
> up port->custom_divisor if current-speed is given). The driver I posted
> uses the clk API to determine the clock frequency. So shouldn't the frequency
> better be specified in the clk part of the dt? (I don't know yet how a
> dt binding for clks should/can look like, so this is a bit speculative,
> but I'd expect to have nothing more clk related in a device
> specification but a reference to a clk definition.)

The binding for 8250 serial ports is documented at
http://www.openfirmware.org/1275/bindings/devices/html/serial.html

If you can always use the clk API to find out the base clock rate,
that's probably fine, I was mostly trying to make sure we don't
introduce another duplicate API for this.

The "current-speed" property is used to describe the baud rate that
should be used by the kernel for this port in order to talk to
devices connected to the port. This is very useful if you need to
connect the boot console to a fixed-rate device, and would get
used instead of the 115200 default you have when nothing else
is configured on the command line. I don't really know why
there is no respective option to set parity or flow control

> Independant of my driver I wonder if defining current-speed should also
> result in
> 
> 	port->flags |= UPF_SPD_CUST;
> 
> (in of_platform_serial_setup()).

I believe that is not needed because you don't call uart_get_divisor,
which would be the only place that looks at this flag.

> Having said that and taking into account that my driver doesn't use
> port->custom_divisor, do you keep suggesting that I should use
> "clock-frequency" and/or "current-speed"?

clock-frequency seems to be unnecessary, but current-speed would
still make sense. custom_divisor is simply the method that of_serial
uses to communicate the bit rate to the 8250 base driver, but you
could set the divisor directly.

	Arnd
