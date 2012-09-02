Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2IBCON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 22:14:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58430 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755808Ab2IBCOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 22:14:11 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 1 Sep 2012 19:14:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v4] linux/kernel.h: Fix DIV_ROUND_CLOSEST to support
 negative dividends
Message-ID: <20120902021410.GA1578@roeck-us.net>
References: <1346425339-17138-1-git-send-email-linux@roeck-us.net>
 <20120831123812.62729e1c.akpm@linux-foundation.org>
 <20120901190254.108e3f6b@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120901190254.108e3f6b@endymion.delvare>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 07:02:54PM +0200, Jean Delvare wrote:
> Hi Andrew, Guenter,
> 
> On Fri, 31 Aug 2012 12:38:12 -0700, Andrew Morton wrote:
> > On Fri, 31 Aug 2012 08:02:19 -0700
> > Guenter Roeck <linux@roeck-us.net> wrote:
> > 
> > > DIV_ROUND_CLOSEST returns a bad result for negative dividends:
> > > 	DIV_ROUND_CLOSEST(-2, 2) = 0
> > > 
> > > Most of the time this does not matter. However, in the hardware monitoring
> > > subsystem, DIV_ROUND_CLOSEST is sometimes used on integers which can be
> > > negative (such as temperatures).
> > > 
> > > ...
> > >
> > > +
> > > +/*
> > > + * Divide positive or negative dividend by positive divisor and round
> > > + * to closest integer. Result is undefined for negative divisors.
> > > + */
> > >  #define DIV_ROUND_CLOSEST(x, divisor)(			\
> > >  {							\
> > > -	typeof(divisor) __divisor = divisor;		\
> > > -	(((x) + ((__divisor) / 2)) / (__divisor));	\
> > > +	typeof(x) __x = x;				\
> > > +	typeof(divisor) __d = divisor;			\
> > > +	(((typeof(x))-1) >= 0 || (__x) >= 0) ?		\
> > > +		(((__x) + ((__d) / 2)) / (__d)) :	\
> > > +		(((__x) - ((__d) / 2)) / (__d));	\
> > >  }							\
> > 
> > Looks good to me.
> 
> My testing looks good too.
> 
> Acked-by: Jean Delvare <khali@linux-fr.org>
> 
Thanks a lot!

> > The patch causes no change in text size for
> > kernel/sched/fair.o and drivers/cpuidle/governors/menu.o, so it seems
> > that the cc trickery is working.
> 
> Indeed. I looked for test size increase, and for my config, besides
> hwmon, I only spotted the following ones:
> 
> drivers/media/rc/mceusb.o
> drivers/gpu/drm/i915/intel_pm.o
> drivers/tty/serial/pch_uart.o
> 
> These don't look like hot paths, so I'd say we don't care. Plus the
> intel_pm one can probably be solved by using an unsigned int, I don't
> see why/how ia_freq could be negative (negative frequency anyone?) And
> for mceusb it can be solved easily by changing "1" to "1U".
> 
Yes, it helps a lot that the C trickery optimizes the changes away most of the time.

I'll let the patch rest in -next for a few more days before I send it to Linus.

Guenter
