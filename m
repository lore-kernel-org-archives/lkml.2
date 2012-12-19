Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2LSHfz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:35:55 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab2LSHfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:35:50 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: Strange results of DIV_ROUND_CLOSEST
Date: Wed, 19 Dec 2012 08:32:53 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201212181603.42094.jbe@pengutronix.de> <201212182204.56523.jbe@pengutronix.de> <20121219014556.GA17257@roeck-us.net>
In-Reply-To: <20121219014556.GA17257@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212190832.54104.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

Guenter Roeck wrote:
> On Tue, Dec 18, 2012 at 10:04:56PM +0100, Juergen Beisert wrote:
> > Guenter Roeck wrote:
> > > On Tue, Dec 18, 2012 at 04:03:41PM +0100, Juergen Beisert wrote:
> > > > commit 263a523d18bca306016d75f5c8d5c57c37fe52fb changes the code of
> > > > DIV_ROUND_CLOSEST in include/linux/kernel.h to fix a compile time
> > > > warning.
> > > >
> > > > But now feeding in a zero into this macro results into 4198403.
> > > > Tested with gcc 4.4.3 and 4.7.2, on arch x86 and ARM.
> > > >
> > > > I can reproduce this behaviour, when my ADC delivers a '0' value in
> > > > the driver drivers/hwmon/s3c-hwmon.c in function s3c_hwmon_ch_show()
> > > > with a current 3.7.1 kernel. The value is correct again, when the ADC
> > > > delivers at least a '1'.
> > > >
> > > > Any ideas how to fix it correctly?
> > >
> > > Odd one. I ran the macro through a large number of values and divisors
> > > as well as various optimization options, with different compilers, and
> > > always get correct results.
> > >
> > > What are your compile options, and what are the channel multiplier and
> > > dividers set to ?
> >
> > Refer the lines 177 to 182 in drivers/hwmon/s3c-hwmon.c. "cfg->mult" is
> > '3300' in my case, and "cfg->div" is '1023'. And whenever
> > s3c_hwmon_read_ch() returns '0' line 184 returns '4198403' since
> > Linux-3.6. checked with my gcc-4.6.2 cross compiler for Linux-3.6 and
> > with gcc-4.6.2 for Linux-3.7.
> >
> > I did a quick test with this macro on my host with gcc-4.4.3 and a simple
> > userland program and surprise, surprise:
> >
> > result = DIV_ROUND_CLOSEST(0, 1023);
> >
> > works as expected (result is 0), but
> >
> > int x = 0;
> > unsigned y = 1023;
> > result = DIV_ROUND_CLOSEST(x, y);
> >
> > gives me result = 4198403!
>
> Can you test the following patch ?
>
> From d4a639c6ace7cb0de247f59c38abac72d671f135 Mon Sep 17 00:00:00 2001
> From: Guenter Roeck <linux@roeck-us.net>
> Date: Tue, 18 Dec 2012 15:48:44 -0800
> Subject: [PATCH] linux/kernel.h: Fix DIV_ROUND_CLOSEST for unsigned
> divisors
>
> Commit 263a523 fixes a warning seen with W=1 due to change in
> DIV_ROUND_CLOSEST. Unfortunately, the C compiler converts divide operations
> with unsigned divisors to unsigned, even if the dividend is signed and
> negative (-10 / 5U = 858993457). As a result, DIV_ROUND_CLOSEST(0, 2U)
> and similar operations now return bad data.
>
> Fix by checking for the divisor variable type when deciding which operation
> to perform. This fixes DIV_ROUND_CLOSEST(0, 2U), but still returns bad data
> for negative dividends divided by unsigned divisors. Mark the latter case
> as unsupported.
>
> Reported-by: Juergen Beisert <jbe@pengutronix.de>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
> An alternative would be to always convert divisors to signed:
>  	int __d = (int)divisor;			\
> Not sure if that would be better.
>
>  include/linux/kernel.h |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index d97ed58..45726dc 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -77,13 +77,15 @@
>
>  /*
>   * Divide positive or negative dividend by positive divisor and round
> - * to closest integer. Result is undefined for negative divisors.
> + * to closest integer. Result is undefined for negative divisors and
> + * for negative dividends if the divisor variable type is unsigned.
>   */
>  #define DIV_ROUND_CLOSEST(x, divisor)(			\
>  {							\
>  	typeof(x) __x = x;				\
>  	typeof(divisor) __d = divisor;			\
> -	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
> +	(((typeof(x))-1) > 0 ||				\
> +	 ((typeof(divisor))-1) > 0 || (__x) > 0) ?	\
>  		(((__x) + ((__d) / 2)) / (__d)) :	\
>  		(((__x) - ((__d) / 2)) / (__d));	\
>  }							\

You can add my "tested-by: Juergen Beisert <jbe@pengutronix.de>". With this 
patch at least my S3C2440 ADC driver reports correct values again. Keep in 
mind it should also be fixed in the stable 3.6/3.7 kernel.

Regards,
Juergen
-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | http://www.pengutronix.de/  |
