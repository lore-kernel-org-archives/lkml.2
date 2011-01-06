Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1AFMP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 07:15:26 -0500
Received: from dan.rpsys.net ([93.97.175.187]:60460 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab1AFMPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 07:15:25 -0500
X-Greylist: delayed 655 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jan 2011 07:15:24 EST
Subject: Re: [RESEND #2] [PATCH v2] LEDS: Add output invertion option to
 backlight trigger
From: Richard Purdie <richard.purdie@linuxfoundation.org>
To: Paul Mundt <lethal@linux-sh.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
In-Reply-To: <20110106070816.GA15914@linux-sh.org>
References: <201012091441.51846.jkrzyszt@tis.icnet.pl>
	 <20110106070816.GA15914@linux-sh.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 12:02:49 +0000
Message-ID: <1294315369.17519.24297.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 16:08 +0900, Paul Mundt wrote:
> (Trying an alternate address for Richard, and adding Andrew to Cc..)
> 
> On Thu, Dec 09, 2010 at 02:41:50PM +0100, Janusz Krzysztofik wrote:
> > This patch extends the LED backlight tirgger driver with an option that allows 
> > for inverting the trigger output polarity.
> > 
> > With the invertion option provided, I (ab)use the backlight trigger for 
> > driving a LED that indicates LCD display blank condtition on my Amstrad Delta 
> > videophone. Since the machine has no dedicated power LED, it was not possible 
> > to distinguish if the display was blanked, or the machine was turned off, 
> > without touching it.
> > 
> > The invert sysfs control is patterned after a similiar function of the GPIO 
> > trigger driver.
> > 
> > Created and tested against linux-2.6.36-rc5 on Amstrad Delta.
> > Retested on linux-2.6.37-rc4.
> > 
> > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > Cc: Richard Purdie <rpurdie@rpsys.net>

Acked-by: Richard Purdie <richard.purdie@linuxfoundation.org>

I'll let Andrew take the patch though.

> > ---
> > 
> > Resent because I still can't see any response received, while yet another 
> > merge window is going to pass away soon.
> > 
> > Applies cleanly on top of 2.6.37-rc4, so no need for yet another refresh. Only 
> > tried to clean up the commit message slightly - maybe my English is not good 
> > enough to bother with, if not the code?
> > 
> > v1 -> v2 changes:
> > - improve some conditional expressions to be more readable; thanks to Ralph 
> >   Corderoy (from e3-hacking) and Lars-Peter Clausen for their suggestions,
> > - refresh against linux-2.6.36-rc5.
> > 
> >  drivers/leds/ledtrig-backlight.c |   60 
> > ++++++++++++++++++++++++++++++++++++---
> >  1 file changed, 56 insertions(+), 4 deletions(-)
> > 
> > diff -upr linux-2.6.36-rc5.orig/drivers/leds/ledtrig-backlight.c linux-2.6.36-rc5/drivers/leds/ledtrig-backlight.c
> > --- linux-2.6.36-rc5.orig/drivers/leds/ledtrig-backlight.c	2010-09-24 15:35:13.000000000 +0200
> > +++ linux-2.6.36-rc5/drivers/leds/ledtrig-backlight.c	2010-10-03 15:59:49.000000000 +0200
> > @@ -26,6 +26,7 @@ struct bl_trig_notifier {
> >  	int brightness;
> >  	int old_status;
> >  	struct notifier_block notifier;
> > +	unsigned invert;
> >  };
> >  
> >  static int fb_notifier_callback(struct notifier_block *p,
> > @@ -36,23 +37,63 @@ static int fb_notifier_callback(struct n
> >  	struct led_classdev *led = n->led;
> >  	struct fb_event *fb_event = data;
> >  	int *blank = fb_event->data;
> > +	int new_status = *blank ? BLANK : UNBLANK;
> >  
> >  	switch (event) {
> >  	case FB_EVENT_BLANK :
> > -		if (*blank && n->old_status == UNBLANK) {
> > +		if (new_status == n->old_status)
> > +			break;
> > +
> > +		if ((n->old_status == UNBLANK) ^ n->invert) {
> >  			n->brightness = led->brightness;
> >  			led_set_brightness(led, LED_OFF);
> > -			n->old_status = BLANK;
> > -		} else if (!*blank && n->old_status == BLANK) {
> > +		} else {
> >  			led_set_brightness(led, n->brightness);
> > -			n->old_status = UNBLANK;
> >  		}
> > +
> > +		n->old_status = new_status;
> > +
> >  		break;
> >  	}
> >  
> >  	return 0;
> >  }
> >  
> > +static ssize_t bl_trig_invert_show(struct device *dev,
> > +		struct device_attribute *attr, char *buf)
> > +{
> > +	struct led_classdev *led = dev_get_drvdata(dev);
> > +	struct bl_trig_notifier *n = led->trigger_data;
> > +
> > +	return sprintf(buf, "%s\n", n->invert ? "yes" : "no");
> > +}
> > +
> > +static ssize_t bl_trig_invert_store(struct device *dev,
> > +		struct device_attribute *attr, const char *buf, size_t num)
> > +{
> > +	struct led_classdev *led = dev_get_drvdata(dev);
> > +	struct bl_trig_notifier *n = led->trigger_data;
> > +	unsigned invert;
> > +	int ret;
> > +
> > +	ret = sscanf(buf, "%u", &invert);
> > +	if (ret < 1) {
> > +		dev_err(dev, "invalid value\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	n->invert = !!invert;
> > +
> > +	/* After inverting, we need to update the LED. */
> > +	if ((n->old_status == BLANK) ^ n->invert)
> > +		led_set_brightness(led, LED_OFF);
> > +	else
> > +		led_set_brightness(led, n->brightness);
> > +
> > +	return num;
> > +}
> > +static DEVICE_ATTR(invert, 0644, bl_trig_invert_show, bl_trig_invert_store);
> > +
> >  static void bl_trig_activate(struct led_classdev *led)
> >  {
> >  	int ret;
> > @@ -66,6 +107,10 @@ static void bl_trig_activate(struct led_
> >  		return;
> >  	}
> >  
> > +	ret = device_create_file(led->dev, &dev_attr_invert);
> > +	if (ret)
> > +		goto err_invert;
> > +
> >  	n->led = led;
> >  	n->brightness = led->brightness;
> >  	n->old_status = UNBLANK;
> > @@ -74,6 +119,12 @@ static void bl_trig_activate(struct led_
> >  	ret = fb_register_client(&n->notifier);
> >  	if (ret)
> >  		dev_err(led->dev, "unable to register backlight trigger\n");
> > +
> > +	return;
> > +
> > +err_invert:
> > +	led->trigger_data = NULL;
> > +	kfree(n);
> >  }
> >  
> >  static void bl_trig_deactivate(struct led_classdev *led)
> > @@ -82,6 +133,7 @@ static void bl_trig_deactivate(struct le
> >  		(struct bl_trig_notifier *) led->trigger_data;
> >  
> >  	if (n) {
> > +		device_remove_file(led->dev, &dev_attr_invert);
> >  		fb_unregister_client(&n->notifier);
> >  		kfree(n);
> >  	}
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


