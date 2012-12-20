Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2LTLBQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 06:01:16 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:37877 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab2LTLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 06:01:09 -0500
Date: Thu, 20 Dec 2012 12:00:58 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [PATCH v2] linux/kernel.h: Fix DIV_ROUND_CLOSEST with unsigned
 divisors
Message-ID: <20121220120058.48fb7c28@endymion.delvare>
In-Reply-To: <201212201130.39235.jbe@pengutronix.de>
References: <1355928015-26212-1-git-send-email-linux@roeck-us.net>
	<20121219224122.GA26863@roeck-us.net>
	<20121220112202.3ead1fe1@endymion.delvare>
	<201212201130.39235.jbe@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juergen,

On Thu, 20 Dec 2012 11:30:38 +0100, Juergen Beisert wrote:
> Hi Jean,
> 
> Jean Delvare wrote:
> > On Wed, 19 Dec 2012 14:41:22 -0800, Guenter Roeck wrote:
> > > One observed effect is that the s2c_hwmon driver reports a value of
> > > 4198403 instead of 0 if the ADC reads 0.
> > >
> > > Other impact is unpredictable. Problem is seen if the divisor is an
> > > unsigned variable or constant and the dividend is less than (divisor/2).
> >
> > Really? In my own testing, the problem only shows with dividend == 0,
> > and even then, only when dividend is signed and divisor is not.
> > DIV_ROUND_CLOSEST(5, 20U) returns 0 as expected, and so do
> > DIV_ROUND_CLOSEST(0 / 20), DIV_ROUND_CLOSEST(0U / 20) and
> > DIV_ROUND_CLOSEST(0U / 20U).
> >
> > Are your observations different?
> 
> I tried it with this simple user-land program to get an idea what's going 
> wrong in the s3c_hwmon.c ADC driver:
> 
> #define DIV_ROUND_CLOSEST(x, divisor)(			\
> {							\
> 	typeof(x) __x = x;				\
> 	typeof(divisor) __d = divisor;			\
> 	(((typeof(x))-1) > 0 || (__x) > 0) ?		\
> 		(((__x) + ((__d) / 2)) / (__d)) :	\
> 		(((__x) - ((__d) / 2)) / (__d));	\
> }							\
> )
> 
> int main(int argc, char *argv[])
> {
> 	int x;
> 	unsigned y;
> 
> 	printf("Constants\n");
> 
> 	printf("-1 -> %d\n", DIV_ROUND_CLOSEST(-1, 2));
> 	printf("-1 -> %d\n", DIV_ROUND_CLOSEST(-1, 1023));
> 	printf("0 -> %d\n", DIV_ROUND_CLOSEST(0, 1023));
> 	printf("0 -> %d\n", DIV_ROUND_CLOSEST(0, 2));
> 	printf("1 -> %d\n", DIV_ROUND_CLOSEST(1, 2));
> 	printf("1 -> %d\n", DIV_ROUND_CLOSEST(3300, 1023));
> 	printf("2 -> %d\n", DIV_ROUND_CLOSEST(6600, 1023));

This all works properly, because everything is signed here.
 
> 	printf("Variables\n");
> 
> 	x = -1; y = 2;
> 	printf("-1 -> %d\n", DIV_ROUND_CLOSEST(x, y));
> 	x = -1; y = 1023;
> 	printf("-1 -> %d\n", DIV_ROUND_CLOSEST(x, y));
> 	x = 0; y = 1023;
> 	printf("0 -> %d\n", DIV_ROUND_CLOSEST(x, y));
> 	x = 3300; y = 1023;
> 	printf("3300 -> %d\n", DIV_ROUND_CLOSEST(3300, 1023));
> 	x = 6600; y = 1023;
> 	printf("6600 -> %d\n", DIV_ROUND_CLOSEST(6600, 1023));

I don't think variables vs. constants make any difference. What makes a
difference is signed vs. unsigned. You see failures here because y is
unsigned. You'd see the same with the constants above by changing 2 to
2U and 1023 to 1023U.

> 
> 	return 0;
> }
> 
> Result is on my x86 host (same on my ARM target):
> 
> Constants
> -1 -> -1
> -1 -> 0
> 0 -> 0
> 0 -> 0
> 1 -> 1
> 1 -> 3
> 2 -> 6
> Variables
> -1 -> 2147483647
> -1 -> 4198403
> 0 -> 4198403
> 3300 -> 3
> 6600 -> 6

I see the same here with your test program.

-- 
Jean Delvare
