Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2LRW7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 17:59:38 -0500
Received: from mail.active-venture.com ([67.228.131.205]:59658 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRW7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 17:59:37 -0500
X-Originating-IP: 108.223.40.66
Date: Tue, 18 Dec 2012 14:59:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Strange results of DIV_ROUND_CLOSEST
Message-ID: <20121218225944.GA23052@roeck-us.net>
References: <201212181603.42094.jbe@pengutronix.de>
 <20121218171620.GA19972@roeck-us.net>
 <201212182204.56523.jbe@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201212182204.56523.jbe@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 10:04:56PM +0100, Juergen Beisert wrote:
> Hi Guenter,
> 
> Guenter Roeck wrote:
> > On Tue, Dec 18, 2012 at 04:03:41PM +0100, Juergen Beisert wrote:
> > > commit 263a523d18bca306016d75f5c8d5c57c37fe52fb changes the code of
> > > DIV_ROUND_CLOSEST in include/linux/kernel.h to fix a compile time
> > > warning.
> > >
> > > But now feeding in a zero into this macro results into 4198403. Tested
> > > with gcc 4.4.3 and 4.7.2, on arch x86 and ARM.
> > >
> > > I can reproduce this behaviour, when my ADC delivers a '0' value in the
> > > driver drivers/hwmon/s3c-hwmon.c in function s3c_hwmon_ch_show() with a
> > > current 3.7.1 kernel. The value is correct again, when the ADC delivers
> > > at least a '1'.
> > >
> > > Any ideas how to fix it correctly?
> >
> > Odd one. I ran the macro through a large number of values and divisors as
> > well as various optimization options, with different compilers, and always
> > get correct results.
> >
> > What are your compile options, and what are the channel multiplier and
> > dividers set to ?
> 
> Refer the lines 177 to 182 in drivers/hwmon/s3c-hwmon.c. "cfg->mult" is '3300' 
> in my case, and "cfg->div" is '1023'. And whenever s3c_hwmon_read_ch() 
> returns '0' line 184 returns '4198403' since Linux-3.6. checked with my 
> gcc-4.6.2 cross compiler for Linux-3.6 and with gcc-4.6.2 for Linux-3.7.
> 
> I did a quick test with this macro on my host with gcc-4.4.3 and a simple 
> userland program and surprise, surprise:
> 
> result = DIV_ROUND_CLOSEST(0, 1023);
> 
> works as expected (result is 0), but
> 
> int x = 0;
> unsigned y = 1023;
> result = DIV_ROUND_CLOSEST(x, y);
> 
> gives me result = 4198403!
> 
> Strange.
> 
Yes. Try:
	printf("%d\n", -10 / 2U);

I am amazed. Apparently the compiler converts an expression to unsigned if the
divisor is unsigned. Which of course completely defeats the purpose of the
operation.

I'll try to come up with a fix. Let me know if you have an idea. Obviously this
does not only affect the "0" case, but all operations with negative dividend and
unsigned divisor.

Guenter

