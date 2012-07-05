Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089Ab2GETsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:48:31 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37512 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab2GETs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:48:29 -0400
Date: Thu, 5 Jul 2012 21:48:28 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, linux-leds@vger.kernel.org,
        rpurdie@rpsys.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 25/25] leds: convert One-shot LED trigger driver to
 devm_kzalloc() and cleanup error exit path
Message-ID: <20120705194828.GA1563@gmail.com>
References: <1341378617-10386-1-git-send-email-bryan.wu@canonical.com>
 <1341378617-10386-26-git-send-email-bryan.wu@canonical.com>
 <1341506839.2605.11.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341506839.2605.11.camel@lorien2>
X-Operating-System: Linux balto-eee 3.5.0-rc2-balto-eee-00070-g4eb43e3
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 10:47:19AM -0600, Shuah Khan wrote:
> On Wed, 2012-07-04 at 13:10 +0800, Bryan Wu wrote:
> > Cc: Fabio Baltieri <fabio.baltieri@gmail.com>
> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> > ---
> >  drivers/leds/ledtrig-oneshot.c |    8 +++-----
> >  1 file changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/leds/ledtrig-oneshot.c b/drivers/leds/ledtrig-oneshot.c
> > index 2c029aa..6395a38 100644
> > --- a/drivers/leds/ledtrig-oneshot.c
> > +++ b/drivers/leds/ledtrig-oneshot.c
> > @@ -127,7 +127,8 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
> >  	struct oneshot_trig_data *oneshot_data;
> >  	int rc;
> >  
> > -	oneshot_data = kzalloc(sizeof(*oneshot_data), GFP_KERNEL);
> > +	oneshot_data = devm_kzalloc(led_cdev->dev, sizeof(*oneshot_data),
> > +				GFP_KERNEL);
> >  	if (!oneshot_data)
> >  		return;
> >  
> > @@ -135,7 +136,7 @@ static void oneshot_trig_activate(struct led_classdev *led_cdev)
> >  
> >  	rc = device_create_file(led_cdev->dev, &dev_attr_delay_on);
> >  	if (rc)
> > -		goto err_out_trig_data;
> > +		return;
> >  	rc = device_create_file(led_cdev->dev, &dev_attr_delay_off);
> >  	if (rc)
> >  		goto err_out_delayon;
> > @@ -159,8 +160,6 @@ err_out_delayoff:
> >  	device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> >  err_out_delayon:
> >  	device_remove_file(led_cdev->dev, &dev_attr_delay_on);
> > -err_out_trig_data:
> > -	kfree(led_cdev->trigger_data);
> >  }
> >  
> >  static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
> > @@ -172,7 +171,6 @@ static void oneshot_trig_deactivate(struct led_classdev *led_cdev)
> >  		device_remove_file(led_cdev->dev, &dev_attr_delay_off);
> >  		device_remove_file(led_cdev->dev, &dev_attr_invert);
> >  		device_remove_file(led_cdev->dev, &dev_attr_shot);
> > -		kfree(oneshot_data);
> >  		led_cdev->activated = false;
> >  	}
> >  
> Bryan,
> 
> I don't believe memory triggers allocate in their activate routine
> should be converted to devm_kzalloc(). Based on my understanding, the
> memory allocated using devm_kzalloc() us free'ed when driver is
> detached. In the case of led triggers, driver stays registered while the
> triggers it supports can be activated and deactivated many times. By
> converting these allocations into devm_kzalloc()s could lead to memory
> leaks. Please correct me if my understanding is incorrect.

Shuah,

I'm as the same opinion - as triggers are not really "driver", in the
sense that they are not using the driver structures, using devm_
functions doesn't seems to be really appropriate.

Specifically:

> > +	oneshot_data = devm_kzalloc(led_cdev->dev, sizeof(*oneshot_data),
> > +				GFP_KERNEL);

this one is registering the data on the relative LED's resources, so
that they are not freed until you unload the LED's driver itself.
I also think that this leads to memory leak if you keep activating
triggers, as the deactivate function is not actually freeing the
resources, so in that case the correct procedure should be the usual
kalloc/kfree.

Is this consistent with what your conclusions, Shuah?

Fabio

> If what I am saying makes sense, please take this as comment that is
> applicable to all led triggers, not just this one.
> 
> Thanks,
> -- Shuah
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-leds" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
