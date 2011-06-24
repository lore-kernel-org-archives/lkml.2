Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757245Ab1FXN7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 09:59:41 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55448 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542Ab1FXN7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 09:59:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Date: Fri, 24 Jun 2011 15:59:15 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20110618171946.GB3441@infomag.iguana.be> <201106182058.14702.arnd@arndb.de> <20110622195024.GA26745@infomag.iguana.be>
In-Reply-To: <20110622195024.GA26745@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106241559.16416.arnd@arndb.de>
X-Provags-ID: V02:K0:+QpYKBQvFjXv6/1WqdcW5rbrSRfC4XwZvTwmkh6KZ0t
 SlH/wHo7RnL77bKYkC9tKIssrWUBBIkQZEmpU79HleaHzZ4I4O
 0OzFaZ7o7vViUjdzx3WAwyhEpGmHMTmI5IdbgSftM/0drWuMGj
 jLDPmJIsdjbwLXzdIGDGSxMEQuZ9YckjwzGG3OP5yAKMhV6u8X
 G+bi8cIAkZofv12L5irYA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 21:50:24 Wim Van Sebroeck wrote:

> > I'm pretty sure you don't need bitops.h or uaccess.h here, because all the
> > code using those has moved into the core.
> 
> bitops will be used later on, but this can indeed be cleaned up.
> 
> > > +#include <linux/io.h>
> > 
> > This is also not needed here, although it will probably be needed in most
> > real drivers.
> 
> Same.

Nevermind then.

> > > +#include <linux/platform_device.h>
> > > +
> > > +/* Hardware heartbeat in seconds */
> > > +#define WDT_HW_HEARTBEAT 2
> > > +
> > > +/* Timer heartbeat (500ms) */
> > > +#define WDT_HEARTBEAT	(HZ/2)	/* should be <= ((WDT_HW_HEARTBEAT*HZ)/2) */
> > > +
> > > +/* User land timeout */
> > > +#define WDT_TIMEOUT 15
> > > +static int timeout = WDT_TIMEOUT;
> > > +module_param(timeout, int, 0);
> > > +MODULE_PARM_DESC(timeout, "Watchdog timeout in seconds. "
> > > +	"(default = " __MODULE_STRING(WDT_TIMEOUT) ")");
> > 
> > Should the module parameter really be part of each individual driver?
> > It would be nice if that can be moved into the core as well.
> 
> Yes, the module parameter is needed for each individual driver.
> If we go for supporting multiple watchdog devices, then we will have to support
> different timeout values. The timeout ranges also differ for different devices.

Ok, but you'd still have to worry about a single driver supporting multiple
distinct devices that each want a separate timeout, right?

OTOH, we can still find a solution when it ever gets to the point of
supporting multiple devices.

> > > +static void wdt_timer_tick(unsigned long data);
> > 
> > I usually recommend reordering all functions so that you don't need any forward
> > declarations, that makes the driver easier to read IMHO.
> > 
> > > +static DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> > > +					/* The timer that pings the watchdog */
> 
> Yes, I also tend to do that but it's used in the DEFINE_TIMER(timer, wdt_timer_tick, 0, 0);
> just under it. No clean way to do that better imho...

Ah, right. I missed that. You could get rid of the forward declaration
by dynamically initializing the timer struct, but that would be no
better than what you have now.

> > Is it common for watchdog these days to have both a kernel timer and
> > a user space timer?
> 
> No, it is only common for watchdog devices that
> 1) don't stop once started
> 2) device that have very small (mostly < 1second) heartbeat values.
> All other watchdog device timers don't need and use the kernel timer.

Ok, I hadn't thought of these.

> > If yes, that might be good to support in the core as well, instead of
> > having to implement it in each driver.
> > 
> > If no, it might not be ideal to have in an example driver.
> 
> As said, it's an example for a common exception. You should not look at this
> as a common example driver. I added it, because it's a common exception that
> people understand less.

ok.

> > > +struct watchdog_device {
> > > +	char *name;
> > > +	const struct watchdog_ops *ops;
> > > +	long status;
> > > +};
> > > +
> > > +It contains following fields:
> > > +* name: a pointer to the (preferably unique) name of the watchdog timer device.
> > > +* ops: a pointer to the list of watchdog operations that the watchdog supports.
> > > +* status: this field contains a number of status bits that give extra
> > > +  information about the status of the device (Like: is the device opened via
> > > +  the /dev/watchdog interface or not, ...)
> > 
> > I think this should really have a pointer to the struct device implementing the
> > watchdog, so that a driver that gets called with a struct watchdog_device can
> > find its own state from there. Alternatively, you could have struct device
> > embedded in struct watchdog_device and register it as a child of the hardware
> > device.
> 
> Would go for a pointer to private data then.

Ok.

	Arnd
