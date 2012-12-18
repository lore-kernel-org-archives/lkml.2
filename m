Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab2LRVH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:07:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58132 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab2LRVHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:07:51 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Strange results of DIV_ROUND_CLOSEST
Date: Tue, 18 Dec 2012 22:04:56 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201212181603.42094.jbe@pengutronix.de> <20121218171620.GA19972@roeck-us.net>
In-Reply-To: <20121218171620.GA19972@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212182204.56523.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Guenter Roeck wrote:
> On Tue, Dec 18, 2012 at 04:03:41PM +0100, Juergen Beisert wrote:
> > commit 263a523d18bca306016d75f5c8d5c57c37fe52fb changes the code of
> > DIV_ROUND_CLOSEST in include/linux/kernel.h to fix a compile time
> > warning.
> >
> > But now feeding in a zero into this macro results into 4198403. Tested
> > with gcc 4.4.3 and 4.7.2, on arch x86 and ARM.
> >
> > I can reproduce this behaviour, when my ADC delivers a '0' value in the
> > driver drivers/hwmon/s3c-hwmon.c in function s3c_hwmon_ch_show() with a
> > current 3.7.1 kernel. The value is correct again, when the ADC delivers
> > at least a '1'.
> >
> > Any ideas how to fix it correctly?
>
> Odd one. I ran the macro through a large number of values and divisors as
> well as various optimization options, with different compilers, and always
> get correct results.
>
> What are your compile options, and what are the channel multiplier and
> dividers set to ?

Refer the lines 177 to 182 in drivers/hwmon/s3c-hwmon.c. "cfg->mult" is '3300' 
in my case, and "cfg->div" is '1023'. And whenever s3c_hwmon_read_ch() 
returns '0' line 184 returns '4198403' since Linux-3.6. checked with my 
gcc-4.6.2 cross compiler for Linux-3.6 and with gcc-4.6.2 for Linux-3.7.

I did a quick test with this macro on my host with gcc-4.4.3 and a simple 
userland program and surprise, surprise:

result = DIV_ROUND_CLOSEST(0, 1023);

works as expected (result is 0), but

int x = 0;
unsigned y = 1023;
result = DIV_ROUND_CLOSEST(x, y);

gives me result = 4198403!

Strange.

Regards,
Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
