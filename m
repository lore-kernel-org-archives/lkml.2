Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab2IPJ1y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 05:27:54 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:33685 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab2IPJ1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 05:27:52 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhpaALKaVVBV5h1yPGdsb2JhbABFhR6FI7FOGQEBAQE3NIIgAQEFOhwjEAgDDgouFA0YChoTh3EDELA4DYlTFIoqY4YIYAOUDYFUhXCFKIdy
X-IronPort-AV: E=Sophos;i="4.80,430,1344204000"; 
   d="scan'208";a="193787163"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sun, 16 Sep 2012 11:35:20 +0200
To: Guenter Roeck <linux@roeck-us.net>
Cc: Parag Warudkar <parag.lkml@gmail.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] applesmc: Bump max wait and rearrange udelay
Message-ID: <20120916093520.GA5623@polaris.bitmath.org>
References: <alpine.DEB.2.02.1209151834120.2271@ubuntu>
 <20120915225841.GA3816@roeck-us.net>
 <alpine.DEB.2.02.1209151918210.2271@ubuntu>
 <alpine.DEB.2.02.1209152323490.2088@ubuntu>
 <20120916043116.GA4477@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120916043116.GA4477@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 15, 2012 at 09:31:16PM -0700, Guenter Roeck wrote:
> On Sat, Sep 15, 2012 at 11:29:58PM -0400, Parag Warudkar wrote:
> > 
> > 
> > On Sat, 15 Sep 2012, Parag Warudkar wrote:
> > 
> > > 
> > > 
> > > On Sat, 15 Sep 2012, Guenter Roeck wrote:
> > > > 
> > > > Also, since the delay time can get quite large, would it make sense to replace
> > > > udelay with usleep_range() ?
> > > > 
> > > 
> > > Yes, I think that would be a good thing to do. We could sleep in range of 
> > > us<<=1 and us<<1 and if usleep_range() returns actual sleep time we can 
> > > factor that in for next loop iteration if necessary. Gotta think a bit on 
> > > that one.
> > > 
> > > I will rework the patch to fix the loop termination and keep the bump to 
> > > 0x10000 in place and possibly also experiment with usleep_range().
> > > 
> > 
> > Below is what I am experimenting with right now. I chose to keep the 
> > APPLESMC_MAX_WAIT to current 0x8000 (32ms). With the fixed loop 
> > termination and use of usleep_range() instead of udelay - I will try to 
> > run this a couple days and see if I can recreate the failure within 32ms.
> > 
> > Does this look ok? (I haven't yet changed send_byte to use usleep_range - 
> > if this approach looks ok I can change that as well.)
> > 
> > Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> > 
> > diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> > index 2827088..6610037 100644
> > --- a/drivers/hwmon/applesmc.c
> > +++ b/drivers/hwmon/applesmc.c
> > @@ -168,15 +168,20 @@ static struct workqueue_struct *applesmc_led_wq;
> >  static int wait_read(void)
> >  {
> >  	u8 status;
> > -	int us;
> > -	for (us = APPLESMC_MIN_WAIT; us < APPLESMC_MAX_WAIT; us <<= 1) {
> > -		udelay(us);
> > +	unsigned long r1_us = APPLESMC_MIN_WAIT;
> > +	unsigned long r2_us;
> > +	do {
> >  		status = inb(APPLESMC_CMD_PORT);
> >  		/* read: wait for smc to settle */
> >  		if (status & 0x01)
> >  			return 0;
> > -	}
> > -
> > +		r2_us = r1_us << 2;
> > +		if (r2_us > APPLESMC_MAX_WAIT)
> > +			goto fail;
> > +		usleep_range(r1_us, r2_us);
> > +		r1_us = r2_us;
> 
> That looks terribly complicated. Better keep the loop, and just replace
> 	udelay(us);
> with something like
> 	usleep_range(us, us << 1);
> 
> Alternatively, just use a constant such as
> 	usleep_range(us, us + APPLESMC_MIN_WAIT);

It would be worthwhile to check if there are other bits in status that
encodes a busy state, similar to what we now have in send_byte(). This
is what has finally made almost all machines error-free. Increasing
the max wait is possible, of course, but it only kills the symptoms.

So, Parag, would it be possible for you to print the status field as
you go through one of those long waits? If you find a bit that seems
to change occasionally, you could try to use it as a busy indicator,
and use the APPLESMC_RETRY_WAIT for that case.

As for the rearrangement to remove the initial wait time, it is quite
possible that we can simply reduce APPLESMC_MIN_WAIT to zero-ish,
provided we understand the status bits that tell us when to actually
wait.

Thanks,
Henrik
