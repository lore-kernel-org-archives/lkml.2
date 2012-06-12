Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab2FLHOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:14:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65363 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab2FLHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:14:52 -0400
Date: Tue, 12 Jun 2012 09:16:49 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Shuah Khan <shuahkhan@gmail.com>
Cc: Bryan Wu <bryan.wu@canonical.com>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: use led_brightness_set in led_trigger_event
Message-ID: <20120612071649.GA1306@gmail.com>
References: <1339448260-1733-1-git-send-email-fabio.baltieri@gmail.com>
 <1339450705.23857.16.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339450705.23857.16.camel@lorien2>
X-Operating-System: Linux balto-eee 3.5.0-rc1-balto-eee-00012-g1f35d37
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 03:38:25PM -0600, Shuah Khan wrote:
> On Mon, 2012-06-11 at 22:57 +0200, Fabio Baltieri wrote:
> > Fix led_trigger_event() to use led_brightness_set() instead of
> > led_set_brightness(), so that any pending blink timer is stopped before
> > setting the new brightness value.  Without this fix LED status may be
> > overridden by a pending timer.
> > 
> > This allows a trigger to use a mix of led_trigger_event(),
> > led_trigger_blink() and led_trigger_blink_oneshot() without races.
> > 
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> > Cc: Bryan Wu <bryan.wu@canonical.com>
> > ---
> > Hi Bryan,
> > 
> > I found this one while working on another patch but I think it's also needed by
> > other drivers which mixes led_trigger_blink() and led_trigger_event(), such as
> > power_supply_leds.
> > 
> > Without this a led don't stop blinking as it should when calling
> > led_trigger_event().
> 
> Good find. This is very subtle race though because both timer and
> oneshot triggers call led_brightness_set() from their deactivate
> routines. Is this when these events triggered using oneshot trigger? 

Actually that was when mixing blink (both timer and oneshot, they use
the same timer) and standard trigger-event-set. It should be safe if
only internal (core) functions call set_brightness.

> > 
> > Should not cause any harm on other drivers.
> > 
> > (I'm starting to find the whole led_set_brightness/led_brightness_set thing a
> > bit confusing BTW...)
> 
> I agree with the names are confusing. :) It found it confusing as well.
> Probably why we have this bug hiding until led_trigger_blink() came
> along.
> 
> led_brightness_set() calls led_set_brightness(). led_set_brightness()
> takes cares about whether the driver is in suspend state and invokes
> driver's brightness_set interface. Maybe led_clear_blink_timer() would
> be a better name for this led_brightness_set() routine.

I think maybe we should just rename the function to led_set_brightness()
for the safe one (the one whichh also deactivate the time) and
_led_set_brightness() for the internal one, to put some emphasis to the
"internal" nature of the second.

> I can volunteer to make this change if we agree that this will be a good
> one to clear this naming confusion.

That would save some headache in the future! :-)

Fabio

> 
> -- Shuah
> 
> > 
> > Fabio
> > 
> >  drivers/leds/led-triggers.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> > index fa0b9be..b88d3b9 100644
> > --- a/drivers/leds/led-triggers.c
> > +++ b/drivers/leds/led-triggers.c
> > @@ -224,7 +224,7 @@ void led_trigger_event(struct led_trigger *trig,
> >  		struct led_classdev *led_cdev;
> >  
> >  		led_cdev = list_entry(entry, struct led_classdev, trig_list);
> > -		led_set_brightness(led_cdev, brightness);
> > +		led_brightness_set(led_cdev, brightness);
> 
> This is in-line with led_trigger_set() which is calling
> led_bightness_set() correctly. Also led_classdev_unregister() calls it I
> think for the same reason so the blink timer can be stopped.
> 
> >  	}
> >  	read_unlock(&trig->leddev_list_lock);
> >  }
> 
> 
