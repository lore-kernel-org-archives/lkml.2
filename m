Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2FFLIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:08:34 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:63057 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2FFLId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:08:33 -0400
Date: Wed, 6 Jun 2012 13:10:08 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH v2] leds: fix led_brightness_set when soft-blinking
Message-ID: <20120606111007.GA1311@gmail.com>
References: <20120606070008.GA1494@gmail.com>
 <1338967142-6249-1-git-send-email-fabio.baltieri@gmail.com>
 <CAK5ve-+gv=83MLAttiq8NYK0d_242UWRjJZftyKHONqMkxWTxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ve-+gv=83MLAttiq8NYK0d_242UWRjJZftyKHONqMkxWTxQ@mail.gmail.com>
X-Operating-System: Linux balto-eee 3.5.0-rc1-balto-eee-00009-g5268df1-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On Wed, Jun 06, 2012 at 04:19:05PM +0800, Bryan Wu wrote:
> On Wed, Jun 6, 2012 at 3:19 PM, Fabio Baltieri <fabio.baltieri@gmail.com> wrote:
> > Put del_timer_sync() back into led_stop_software_blink() and move the
> > call earlier into led_blink_set() to ensure software blink timer is
> > stopped when changing trigger.  Also use led_set_brightness() instead of
> > calling led_cdev->brightness_set() directly to ensure
> > led_cdev->brightness is always consistent with current LED status.
> >
> > This ensure proper cleaning when changing triggers, as without this fix
> > a LED may be turned off while leaving it's led_cdev->brightness = 1,
> > leading to an erratic software-blink behaviour.
> >
> > The problem was easy to reproduce by changing the trigger from "timer"
> > to "oneshot".
> >
> > Signed-off-by: Fabio Baltieri <fabio.baltieri@gmail.com>
> > Cc: Bryan Wu <bryan.wu@canonical.com>
> 
> Looks fine and actually a patch fixed similar issue before in my
> fixes-for-3.5 branch.
> http://git.kernel.org/?p=linux/kernel/git/cooloney/linux-leds.git;a=commitdiff;h=b2f819714f40a6593c1ed20b69573d5fef71f392
> I plan to send out these fixes soon.
> 
> I have to rebase all patches in for-next on top of fixes, then I met
> some conflicts. After fixing conflicts, I rebuilt the for-next tree
> which contains 3 patches from you. Please grab it and test, I will try
> that on my hardware.
> http://git.kernel.org/?p=linux/kernel/git/cooloney/linux-leds.git;a=shortlog;h=refs/heads/for-next

I see the rebase but it looks like Rafal's patch was lost and that
condition in led_set_software_blink() re-appeared as the line removal
vanished from my patch but Rafal's one was not applied.

Can you check the rebase? I think that putting 

http://git.kernel.org/?p=linux/kernel/git/cooloney/linux-leds.git;a=commitdiff;h=b2f819714f40a6593c1ed20b69573d5fef71f392

before my "addoneshot blink functions" should fix the code.

Fabio

> 
> Thanks,
> -Bryan
> 
> > ---
> >
> > ...maybe that version makes more sense.
> >
> > Fabio
> >
> >  drivers/leds/led-core.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> > index 579eb78..2477109 100644
> > --- a/drivers/leds/led-core.c
> > +++ b/drivers/leds/led-core.c
> > @@ -27,6 +27,7 @@ EXPORT_SYMBOL_GPL(leds_list);
> >  static void led_stop_software_blink(struct led_classdev *led_cdev)
> >  {
> >        /* deactivate previous settings */
> > +       del_timer_sync(&led_cdev->blink_timer);
> >        led_cdev->blink_delay_on = 0;
> >        led_cdev->blink_delay_off = 0;
> >  }
> > @@ -43,8 +44,6 @@ static void led_set_software_blink(struct led_classdev *led_cdev,
> >        if (!led_cdev->blink_brightness)
> >                led_cdev->blink_brightness = led_cdev->max_brightness;
> >
> > -       led_stop_software_blink(led_cdev);
> > -
> >        led_cdev->blink_delay_on = delay_on;
> >        led_cdev->blink_delay_off = delay_off;
> >
> > @@ -82,7 +81,7 @@ void led_blink_set(struct led_classdev *led_cdev,
> >                   unsigned long *delay_on,
> >                   unsigned long *delay_off)
> >  {
> > -       del_timer_sync(&led_cdev->blink_timer);
> > +       led_stop_software_blink(led_cdev);
> >
> >        led_cdev->flags &= ~LED_BLINK_ONESHOT;
> >        led_cdev->flags &= ~LED_BLINK_ONESHOT_STOP;
> > @@ -116,6 +115,6 @@ void led_brightness_set(struct led_classdev *led_cdev,
> >                        enum led_brightness brightness)
> >  {
> >        led_stop_software_blink(led_cdev);
> > -       led_cdev->brightness_set(led_cdev, brightness);
> > +       led_set_brightness(led_cdev, brightness);
> >  }
> >  EXPORT_SYMBOL(led_brightness_set);
> > --
> > 1.7.11.rc1.9.gf623ca1.dirty
> >
> 
> 
> 
> -- 
> Bryan Wu <bryan.wu@canonical.com>
> Kernel Developer    +86.186-168-78255 Mobile
> Canonical Ltd.      www.canonical.com
> Ubuntu - Linux for human beings | www.ubuntu.com
