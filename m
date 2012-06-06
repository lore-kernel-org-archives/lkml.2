Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2FFG6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 02:58:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53194 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2FFG63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 02:58:29 -0400
Date: Wed, 6 Jun 2012 09:00:08 +0200
From: Fabio Baltieri <fabio.baltieri@gmail.com>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-leds@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH 2/2] leds: fix led_brightness_set when soft-blinking
Message-ID: <20120606070008.GA1494@gmail.com>
References: <1338932339-1660-1-git-send-email-fabio.baltieri@gmail.com>
 <1338932339-1660-2-git-send-email-fabio.baltieri@gmail.com>
 <CAK5ve-J1Oo3Xkr=LMxVkG0F-in3VDbB+RfB1O835vPKVzpGu6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK5ve-J1Oo3Xkr=LMxVkG0F-in3VDbB+RfB1O835vPKVzpGu6A@mail.gmail.com>
X-Operating-System: Linux balto-eee 3.5.0-rc1-balto-eee-00008-g4a25fe7-dirty
 GNU/Linux
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 11:58:10AM +0800, Bryan Wu wrote:
> On Wed, Jun 6, 2012 at 5:38 AM, Fabio Baltieri <fabio.baltieri@gmail.com> wrote:
> > Change led_brightness_set to ensure software blink timer is stopped
> > before calling led_stop_software_blink() and use led_set_brightness()
> > instead of calling led_cdev->brightness_set() directly to ensure
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
> > ---
> >  drivers/leds/led-core.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
> > index 579eb78..3e9f934 100644
> > --- a/drivers/leds/led-core.c
> > +++ b/drivers/leds/led-core.c
> > @@ -115,7 +115,8 @@ EXPORT_SYMBOL(led_blink_set_oneshot);
> >  void led_brightness_set(struct led_classdev *led_cdev,
> >                        enum led_brightness brightness)
> >  {
> > +       del_timer_sync(&led_cdev->blink_timer);
> 
> This is not necessary, since led_stop_software_blink() will call
> del_timer_sync() as you want.

Actually I removed it in the oneshot patch because it was only needed in
the non-oneshot variant of led_blink_set, but I may put it back where it
was and move led_stop_software_blink earlier into led_blink_set... do
you think it's better?

> 
> >        led_stop_software_blink(led_cdev);
> > -       led_cdev->brightness_set(led_cdev, brightness);
> > +       led_set_brightness(led_cdev, brightness);
> >  }
> >  EXPORT_SYMBOL(led_brightness_set);
> > --
> > 1.7.10.2.520.g6a4a482.dirty
> >
> 
> Thanks,
> -- 
> Bryan Wu <bryan.wu@canonical.com>
> Kernel Developer    +86.186-168-78255 Mobile
> Canonical Ltd.      www.canonical.com
> Ubuntu - Linux for human beings | www.ubuntu.com
