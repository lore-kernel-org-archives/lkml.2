Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751895Ab2EZXRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 19:17:21 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:44012 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab2EZXRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 19:17:18 -0400
Date: Sun, 27 May 2012 01:18:10 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-leds@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH RESEND] leds: add oneshot blink functions
Message-ID: <20120526231809.GA1593@gmail.com>
References: <1337632274-2261-1-git-send-email-fabio.baltieri@gmail.com>
 <1337634929-2387-1-git-send-email-fabio.baltieri@gmail.com>
 <CAK5ve-LP5ieHVKaCuMahBi8gEEJv05BkCDd8PRdLJDrpCk2eaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ve-LP5ieHVKaCuMahBi8gEEJv05BkCDd8PRdLJDrpCk2eaQ@mail.gmail.com>
X-Operating-System: Linux balto-eee 3.4.0-balto-eee-07650-g85ec43e-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bryan,

On Fri, May 25, 2012 at 10:39:37PM +0800, Bryan Wu wrote:
> Hi Fabio,
> 
> Bacially I like this idea to extend the API and delete duplicate code.
> Could you please post some use case patches based on this API? I guess
> we can convert led ide-disk trigger to use it or your ledtrig-can
> patch.
> And please rebase this patch on top of my for-next branch.
> git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

Ok, I'll post a rebased version with additional patches for ide-disk and
a cleaned-up version of the trigger I'm using to test the function.

Regards,
Fabio

> And I think this patch missed this 3.5-rc1 merge window, but we can
> make out for next one.
> 
> -Bryan
> 
> On Tue, May 22, 2012 at 5:15 AM, Fabio Baltieri
> <fabio.baltieri@gmail.com> wrote:
> > Add two new functions, led_blink_set_oneshot and
> > led_trigger_blink_oneshot, to be used by triggers for one-shot blink of
> > led devices.
> >
> > This is implemented extending the existing software-blink code, and uses
> > the same timer and handler function.
> >
> > The behavior of the code is to do a blink-on, blink-off sequence when
> > the function is called, ignoring other calls until the sequence is
> > completed so that the leds keep blinking at constant rate if the
> > functions are called repeatedly.
> >
> > This is meant to be used by drivers which needs to trigger on sporadic
> > events, but doesn't have clear busy/idle trigger points.
> >
> > After the blink sequence the led remains off. This behavior can be
> > inverted setting the "invert" argument, blinking the led off, than on
> > and leaving the led on after the sequence.
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> > Cc: Bryan Wu <bryan.wu@canonical.com>
> > Cc: Richard Purdie <rpurdie@rpsys.net>
> > Cc: linux-leds@vger.kernel.org
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > Resend with new maintainer and new list in Cc - thanks Shuah.
> >
> > Hi all!
> >
> > Since merge window is open I'm resending this PATCH/RFC. First mail was a bit
> > long so I'll try to make a long story short.
> >
> > This is a proposal to add a LED-class one-shot library function, to be used by
> > one-shot event triggers, like ide-disk or xt_LED, which currently implements
> > framework-specific led control code.
> >
> > This implementation have been developed after a discussion on the linux-can list
> > on a patch I proposed which used another framework-specific implementation of a
> > one-shot trigger.
> >
> > That's the link of the linux-can patch where the discussion started:
> > http://article.gmane.org/gmane.linux.can/1085
> >
> > And that's my original post of this one with a more detailed description:
> > https://lkml.org/lkml/2012/5/8/41
> >
> > So, my question is, what do you think is better between framework-specific
> > implementation (simple/light) and generic led-class level trigger - like this
> > patch - (less code duplication, useful in other frameworks) for one-shot event
> > triggers?
> >
> > Personally, I'm voting for the first version, as in my patch in linux-can,
> > because the implementation is cleaner, but some other opinion would be
> > valuable.
> >
> > If we'll get to a point, I'll post a v3 of my canbus-led-triggers patch for
> > proposed integration, based either on the original version or on this patch.
> >
> > Regards,
> > Fabio
> >
> >  drivers/leds/led-class.c    | 19 +++++++++++++++++
> >  drivers/leds/led-core.c     | 50 ++++++++++++++++++++++++++++++++++-----------
> >  drivers/leds/led-triggers.c | 30 +++++++++++++++++++++++----
> >  include/linux/leds.h        | 25 +++++++++++++++++++++++
> >  4 files changed, 108 insertions(+), 16 deletions(-)
> >
> > diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> > index 5bff843..42d9359 100644
> > --- a/drivers/leds/led-class.c
> > +++ b/drivers/leds/led-class.c
> > @@ -91,6 +91,11 @@ static void led_timer_function(unsigned long data)
> >                return;
> >        }
> >
> > +       if (led_cdev->flags & LED_BLINK_ONESHOT_STOP) {
> > +               led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> > +               return;
> > +       }
> > +
> >        brightness = led_get_brightness(led_cdev);
> >        if (!brightness) {
> >                /* Time to switch the LED on. */
> > @@ -107,6 +112,20 @@ static void led_timer_function(unsigned long data)
> >
> >        led_set_brightness(led_cdev, brightness);
> >
> > +       /* Return in next iteration if led is in one-shot mode and we are in
> > +        * the final blink state so that the led is toggled each delay_on +
> > +        * delay_off milliseconds in worst case.
> > +        */
> > +       if (led_cdev->flags & LED_BLINK_ONESHOT) {
> > +               if (led_cdev->flags & LED_BLINK_INVERT) {
> > +                       if (brightness)
> > +                               led_cdev->flags |= LED_BLINK_ONESHOT_STOP;
> > +               } else {
> > +                       if (!brightness)
> > +                               led_cdev->flags |= LED_BLINK_ONESHOT_STOP;
> > +               }
> > +       }
> > +
> >        mod_timer(&led_cdev->blink_timer, jiffies + msecs_to_jiffies(delay));
> >  }
> >
> > diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> > index d686004..579eb78 100644
> > --- a/drivers/leds/led-core.c
> > +++ b/drivers/leds/led-core.c
> > @@ -27,7 +27,6 @@ EXPORT_SYMBOL_GPL(leds_list);
> >  static void led_stop_software_blink(struct led_classdev *led_cdev)
> >  {
> >        /* deactivate previous settings */
> > -       del_timer_sync(&led_cdev->blink_timer);
> >        led_cdev->blink_delay_on = 0;
> >        led_cdev->blink_delay_off = 0;
> >  }
> > @@ -44,11 +43,6 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
> >        if (!led_cdev->blink_brightness)
> >                led_cdev->blink_brightness = led_cdev->max_brightness;
> >
> > -       if (led_get_trigger_data(led_cdev) &&
> > -           delay_on == led_cdev->blink_delay_on &&
> > -           delay_off == led_cdev->blink_delay_off)
> > -               return;
> > -
> >        led_stop_software_blink(led_cdev);
> >
> >        led_cdev->blink_delay_on = delay_on;
> > @@ -68,13 +62,12 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
> >  }
> >
> >
> > -void led_blink_set(struct led_classdev *led_cdev,
> > -                  unsigned long *delay_on,
> > -                  unsigned long *delay_off)
> > +void led_blink_setup(struct led_classdev *led_cdev,
> > +                    unsigned long *delay_on,
> > +                    unsigned long *delay_off)
> >  {
> > -       del_timer_sync(&led_cdev->blink_timer);
> > -
> > -       if (led_cdev->blink_set &&
> > +       if (!(led_cdev->flags & LED_BLINK_ONESHOT) &&
> > +           led_cdev->blink_set &&
> >            !led_cdev->blink_set(led_cdev, delay_on, delay_off))
> >                return;
> >
> > @@ -84,8 +77,41 @@ void led_blink_set(struct led_classdev *led_cdev,
> >
> >        led_set_software_blink(led_cdev, *delay_on, *delay_off);
> >  }
> > +
> > +void led_blink_set(struct led_classdev *led_cdev,
> > +                  unsigned long *delay_on,
> > +                  unsigned long *delay_off)
> > +{
> > +       del_timer_sync(&led_cdev->blink_timer);
> > +
> > +       led_cdev->flags &= ~LED_BLINK_ONESHOT;
> > +       led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> > +
> > +       led_blink_setup(led_cdev, delay_on, delay_off);
> > +}
> >  EXPORT_SYMBOL(led_blink_set);
> >
> > +void led_blink_set_oneshot(struct led_classdev *led_cdev,
> > +                          unsigned long *delay_on,
> > +                          unsigned long *delay_off,
> > +                          int invert)
> > +{
> > +       if ((led_cdev->flags & LED_BLINK_ONESHOT) &&
> > +            timer_pending(&led_cdev->blink_timer))
> > +               return;
> > +
> > +       led_cdev->flags |= LED_BLINK_ONESHOT;
> > +       led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> > +
> > +       if (invert)
> > +               led_cdev->flags |= LED_BLINK_INVERT;
> > +       else
> > +               led_cdev->flags &= ~LED_BLINK_INVERT;
> > +
> > +       led_blink_setup(led_cdev, delay_on, delay_off);
> > +}
> > +EXPORT_SYMBOL(led_blink_set_oneshot);
> > +
> >  void led_brightness_set(struct led_classdev *led_cdev,
> >                        enum led_brightness brightness)
> >  {
> > diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> > index 46b4c76..351cbde 100644
> > --- a/drivers/leds/led-triggers.c
> > +++ b/drivers/leds/led-triggers.c
> > @@ -230,9 +230,11 @@ void led_trigger_event(struct led_trigger *trigger,
> >  }
> >  EXPORT_SYMBOL_GPL(led_trigger_event);
> >
> > -void led_trigger_blink(struct led_trigger *trigger,
> > -                      unsigned long *delay_on,
> > -                      unsigned long *delay_off)
> > +void led_trigger_blink_setup(struct led_trigger *trigger,
> > +                            unsigned long *delay_on,
> > +                            unsigned long *delay_off,
> > +                            int oneshot,
> > +                            int invert)
> >  {
> >        struct list_head *entry;
> >
> > @@ -244,12 +246,32 @@ void led_trigger_blink(struct led_trigger *trigger,
> >                struct led_classdev *led_cdev;
> >
> >                led_cdev = list_entry(entry, struct led_classdev, trig_list);
> > -               led_blink_set(led_cdev, delay_on, delay_off);
> > +               if (oneshot)
> > +                       led_blink_set_oneshot(led_cdev, delay_on, delay_off,
> > +                                             invert);
> > +               else
> > +                       led_blink_set(led_cdev, delay_on, delay_off);
> >        }
> >        read_unlock(&trigger->leddev_list_lock);
> >  }
> > +
> > +void led_trigger_blink(struct led_trigger *trigger,
> > +                      unsigned long *delay_on,
> > +                      unsigned long *delay_off)
> > +{
> > +       led_trigger_blink_setup(trigger, delay_on, delay_off, 0, 0);
> > +}
> >  EXPORT_SYMBOL_GPL(led_trigger_blink);
> >
> > +void led_trigger_blink_oneshot(struct led_trigger *trigger,
> > +                              unsigned long *delay_on,
> > +                              unsigned long *delay_off,
> > +                              int invert)
> > +{
> > +       led_trigger_blink_setup(trigger, delay_on, delay_off, 1, invert);
> > +}
> > +EXPORT_SYMBOL_GPL(led_trigger_blink_oneshot);
> > +
> >  void led_trigger_register_simple(const char *name, struct led_trigger **tp)
> >  {
> >        struct led_trigger *trigger;
> > diff --git a/include/linux/leds.h b/include/linux/leds.h
> > index 5884def..f252438 100644
> > --- a/include/linux/leds.h
> > +++ b/include/linux/leds.h
> > @@ -38,6 +38,9 @@ struct led_classdev {
> >  #define LED_SUSPENDED          (1 << 0)
> >        /* Upper 16 bits reflect control information */
> >  #define LED_CORE_SUSPENDRESUME (1 << 16)
> > +#define LED_BLINK_ONESHOT      (1 << 17)
> > +#define LED_BLINK_ONESHOT_STOP (1 << 18)
> > +#define LED_BLINK_INVERT       (1 << 19)
> >
> >        /* Set LED brightness level */
> >        /* Must not sleep, use a workqueue if needed */
> > @@ -101,6 +104,24 @@ extern void led_blink_set(struct led_classdev *led_cdev,
> >                          unsigned long *delay_on,
> >                          unsigned long *delay_off);
> >  /**
> > + * led_blink_set_oneshot - do a oneshot software blink
> > + * @led_cdev: the LED to start blinking
> > + * @delay_on: the time it should be on (in ms)
> > + * @delay_off: the time it should ble off (in ms)
> > + * @invert: blink off, then on, leaving the led on
> > + *
> > + * This function makes the LED blink one time for delay_on +
> > + * delay_off time, ignoring the request if another one-shot
> > + * blink is already in progress.
> > + *
> > + * If invert is set, led blinks for delay_off first, then for
> > + * delay_on and leave the led on after the on-off cycle.
> > + */
> > +extern void led_blink_set_oneshot(struct led_classdev *led_cdev,
> > +                                 unsigned long *delay_on,
> > +                                 unsigned long *delay_off,
> > +                                 int invert);
> > +/**
> >  * led_brightness_set - set LED brightness
> >  * @led_cdev: the LED to set
> >  * @brightness: the brightness to set it to
> > @@ -148,6 +169,10 @@ extern void led_trigger_event(struct led_trigger *trigger,
> >  extern void led_trigger_blink(struct led_trigger *trigger,
> >                              unsigned long *delay_on,
> >                              unsigned long *delay_off);
> > +extern void led_trigger_blink_oneshot(struct led_trigger *trigger,
> > +                                     unsigned long *delay_on,
> > +                                     unsigned long *delay_off,
> > +                                     int invert);
> >
> >  #else
> >
> > --
> > 1.7.10.2.520.g6a4a482.dirty
> >
> 
> 
> 
> -- 
> Bryan Wu <bryan.wu@canonical.com>
> Kernel Developer    +86.186-168-78255 Mobile
> Canonical Ltd.      www.canonical.com
> Ubuntu - Linux for human beings | www.ubuntu.com
