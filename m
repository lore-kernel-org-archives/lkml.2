Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab2IQQT2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 12:19:28 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:54444 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2IQQT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 12:19:26 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Am5RAIBMV1BV5h1yPGdsb2JhbABEhR6FI64Wgz4ZAQEBATc0giABAQQBOhwjBQsIA0YUJQoaiA0Kul4UkRVgA5VhhXCNGg
X-IronPort-AV: E=Sophos;i="4.80,437,1344204000"; 
   d="scan'208";a="413603248"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 17 Sep 2012 18:27:05 +0200
To: Parag Warudkar <parag.lkml@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120917162705.GA2854@polaris.bitmath.org>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu>
 <20120915225841.GA3816@roeck-us.net>
 <alpine.DEB.2.02.1209151918210.2271@ubuntu>
 <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
 <20120916093520.GA5623@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161712070.14838@ubuntu>
 <20120916223003.GA2160@polaris.bitmath.org>
 <alpine.DEB.2.02.1209161957490.2808@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1209161957490.2808@ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > If a), that is very valuable information, and the patch can be
> > simplified further. If b), just crank up the wait time and be done
> > with it. If c), well, then we don't have a case for a patch.
> > 
> I initially experimented with different max wait values and came to the 
> conclusion that 0x20000 was good enough to reduce the errors to zero. But 
> then Guenter pointed out that the original loop terminated too early - 
> that means it only waited 16 ms instead of 32.

This is actually by construction; The total wait time after the loop
is done is roughly 2^MAX_WAIT_TIME.

> I then corrected the loop 
> termination but kept the original 32ms max wait and used usleep_range() 
> instead of udelay() - testing with this gave me no errors whereas earlier 
> the errors were readily reproducible and significant in quanity.
> 
> So I guess actually sleeping for 32ms along with the upward variability 
> introduced by usleep_range() is helping with the fix.

The current patch does exactly the same sleeps, the only difference is
that the test is also done before the first sleep. Thus, the increased
delay, if any, comes from the sleep range.

> > Also, it is not enough to test this on one machine, for fairly obvious
> > reasons. I don't mind testing on a couple of machines close by (MBA3,1
> > MBP10,1), once the comments have been addressed. However, a machine
> > from around 2008 should be tested as well, since they behave
> > differently.
> 
> Since we are keeping the changes minimal and using the same 32 ms max wait 
> as originally intended I think this patch can only make things better. It 
> sure does make things better on my machine but it will not hurt to test it 
> on other models.

The MBP10,1 experiences a lot of write errors with this patch.

> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 2827088..a168a8f 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c
> @@ -169,12 +169,13 @@ static int wait_read(void)
>  {
>  	u8 status;
>  	int us;
> -	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
> -		udelay(us);
> +	for (us = APPLESMC_MIN_WAIT; us <= APPLESMC_MAX_WAIT; us <<= 1) {
>  		status = inb(APPLESMC_CMD_PORT);
>  		/* read: wait for smc to settle */
>  		if (status & 0x01)
>  			return 0;
> +		if (us < APPLESMC_MAX_WAIT)
> +			usleep_range(us, us << 1);

Net result: new delay function and one more status test.

>  	}
>  
>  	pr_warn("wait_read() fail: 0x%02x\n", status);
> @@ -192,7 +193,7 @@ static int send_byte(u8 cmd, u16 port)
>  
>  	outb(cmd, port);
>  	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
> -		udelay(us);
> +		usleep_range(us, us << 1);
>  		status = inb(APPLESMC_CMD_PORT);
>  		/* write: wait for smc to settle */
>  		if (status & 0x02)
> @@ -204,7 +205,7 @@ static int send_byte(u8 cmd, u16 port)
>  		if (us << 1 == APPLESMC_MAX_WAIT)
>  			break;
>  		/* busy: long wait and resend */
> -		udelay(APPLESMC_RETRY_WAIT);
> +		usleep_range(APPLESMC_RETRY_WAIT, APPLESMC_RETRY_WAIT << 1);
>  		outb(cmd, port);
>  	}
>  

Causes (lots of) write errors on MBP10,1.

Henrik
