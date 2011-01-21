Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab1AUXip (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 18:38:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50685 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722Ab1AUXio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 18:38:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P+m/XIWqIafK4Z3YxUz2AMhiXN4U7YeoUDLKmJ7TQGRoEshmouzLW4QG6/y0SXJeLr
         RvV6MtQUwS8+9OwFOd0HyIgg3VRfDQ8Ct7WvrP/wuQbh08Pz+Tm0XxeZopG8Su/yRUsd
         Yku62aWvT6ZnxGxHRj9vcJUdD0n3v0wXafDyk=
Date: Fri, 21 Jan 2011 15:38:37 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] leds: Fix warnings when PM is disabled for BD2802
Message-ID: <20110121233837.GC27943@core.coreip.homeip.net>
References: <1295631217-19591-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110121141402.30aac149.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110121141402.30aac149.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 02:14:02PM -0800, Andrew Morton wrote:
> On Fri, 21 Jan 2011 17:33:37 +0000
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > The suspend and resume functions will only be referenced when PM is
> > enabled so they generate warnings due to being unreferenced and
> > unexported.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> > 
> > This is the more usual idiom for fixing this than the patch you added.
> > 
> >  drivers/leds/leds-bd2802.c |   30 ++++++++++++++++--------------
> >  1 files changed, 16 insertions(+), 14 deletions(-)
> > 
> > diff --git a/drivers/leds/leds-bd2802.c b/drivers/leds/leds-bd2802.c
> > index 22152a2..ef0b868 100644
> > --- a/drivers/leds/leds-bd2802.c
> > +++ b/drivers/leds/leds-bd2802.c
> > @@ -319,20 +319,6 @@ static void bd2802_turn_off(struct bd2802_led *led, enum led_ids id,
> >  	bd2802_update_state(led, id, color, BD2802_OFF);
> >  }
> >  
> > -static void bd2802_restore_state(struct bd2802_led *led)
> > -{
> > -	int i;
> > -
> > -	for (i = 0; i < LED_NUM; i++) {
> > -		if (led->led[i].r)
> > -			bd2802_turn_on(led, i, RED, led->led[i].r);
> > -		if (led->led[i].g)
> > -			bd2802_turn_on(led, i, GREEN, led->led[i].g);
> > -		if (led->led[i].b)
> > -			bd2802_turn_on(led, i, BLUE, led->led[i].b);
> > -	}
> > -}
> > -
> >  #define BD2802_SET_REGISTER(reg_addr, reg_name)				\
> >  static ssize_t bd2802_store_reg##reg_addr(struct device *dev,		\
> >  	struct device_attribute *attr, const char *buf, size_t count)	\
> > @@ -761,6 +747,7 @@ static int __exit bd2802_remove(struct i2c_client *client)
> >  	return 0;
> >  }
> >  
> > +#ifdef CONFIG_PM_SLEEP
> >  static int bd2802_suspend(struct device *dev)
> >  {
> >  	struct i2c_client *client = to_i2c_client(dev);
> > @@ -771,6 +758,20 @@ static int bd2802_suspend(struct device *dev)
> >  	return 0;
> >  }
> >  
> > +static void bd2802_restore_state(struct bd2802_led *led)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < LED_NUM; i++) {
> > +		if (led->led[i].r)
> > +			bd2802_turn_on(led, i, RED, led->led[i].r);
> > +		if (led->led[i].g)
> > +			bd2802_turn_on(led, i, GREEN, led->led[i].g);
> > +		if (led->led[i].b)
> > +			bd2802_turn_on(led, i, BLUE, led->led[i].b);
> > +	}
> > +}
> > +
> >  static int bd2802_resume(struct device *dev)
> >  {
> >  	struct i2c_client *client = to_i2c_client(dev);
> > @@ -783,6 +784,7 @@ static int bd2802_resume(struct device *dev)
> >  
> >  	return 0;
> >  }
> > +#endif
> >  
> 
> That rather sucks.  It leaves an all-zeroes instance of dev_pm_ops
> uselessly bloating the driver.

It is per-driver, not per device so do we really care?

>  And it leaves
> bd2802_i2c_driver.driver.pm pointing at that all-zeroes instance of
> dev_pm_ops, which is rather dangerous.

Nothing dagerous here - PM core deals with half-filled pm_ops just fine.

> 
> If CONFIG_PM_SLEEP=n, the .driver.pm field shouldn't exist at all.

Meh, we have _waaay_ too many config options, I'd rather see CONFIG_PM
and possibly CONFIG_PM_SLEEP go, maybe leaving us with
CONFIG_PM_RUNTIME and maybe not. How many devices out there do not want
PM?

-- 
Dmitry
