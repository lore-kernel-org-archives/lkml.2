Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab1LHPaj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 10:30:39 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:64047 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751654Ab1LHPah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 10:30:37 -0500
X-Greylist: delayed 1640 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 10:30:37 EST
Message-ID: <1323356570.5309.25.camel@ted>
Subject: Re: [PATCH] leds: kill CONFIG_LEDS_CLASS option
From: Richard Purdie <rpurdie@rpsys.net>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Date: Thu, 08 Dec 2011 15:02:50 +0000
In-Reply-To: <CAK5ve-LcUabPS2EGAPD7q3-_thS4XhmGyhafmRkOCUAAriaXSw@mail.gmail.com>
References: <1314647628-21707-1-git-send-email-bryan.wu@canonical.com>
	 <alpine.LFD.2.00.1108291630020.20358@xanadu.home>
	 <1314653699.5939.299.camel@rex>
	 <CAK5ve-+J3hzVB=_b0AOJ-Q1LYewahVraMti=y=6AaQy3+iy+rg@mail.gmail.com>
	 <1314791341.5939.464.camel@rex>
	 <CAK5ve-LcUabPS2EGAPD7q3-_thS4XhmGyhafmRkOCUAAriaXSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-08 at 19:53 +0800, Bryan Wu wrote:
> On Wed, Aug 31, 2011 at 7:49 PM, Richard Purdie <rpurdie@rpsys.net> wrote:
> > On Wed, 2011-08-31 at 10:45 +0800, Bryan Wu wrote:
> >> On Tue, Aug 30, 2011 at 5:34 AM, Richard Purdie <rpurdie@rpsys.net> wrote:
> >> > On Mon, 2011-08-29 at 16:34 -0400, Nicolas Pitre wrote:
> >> >> On Tue, 30 Aug 2011, Bryan Wu wrote:
> >> >>
> >> >> > Almost all the new leds driver and trigger driver are depends on
> >> >> > CONFIG_LED_CLASS, so there is no such user with CONFIG_NEW_LEDS=y
> >> >> > and CONFIG_LED_CLASS=n. Moreover, lots of API functions in led-class.c
> >> >> > are very common and should be built-in when CONFIG_NEW_LEDS=y.
> >> >> >
> >> >> > Obviously, CONFIG_LEDS_CLASS is pointless. This patch kills it and
> >> >> > also updates defconfigs which contains CONFIG_LEDS_CLASS.
> >> >> >
> >> >> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> >> >> > ---
> >> >
> >> > Looking at the code I'm a little concerned to see the direction this is
> >> > going. There was originally a reason that there were two options, it was
> >> > related to being able to compile as much of the LED code as a module as
> >> > possible.
> >> >
> >>
> >> I quite understand the original reason for 2 options, but I failed to
> >> see any user of CONFIG_NEW_LEDS=y and CONFIG_LEDS_CLASS=n.
> >
> > Right, the intent was to support CONFIG_NEW_LEDS=y and
> > CONFIG_LEDS_CLASS=m and I believe that still should be possible.
> >
> >> > It looks like commit 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad changed
> >> > the tristate to a bool at which point the separate option obviously
> >> > becomes pointless.
> >>
> >> Exactly, this patch added some function API which are used very widely
> >> as default LEDS driver behavior in some drivers.
> >
> > Looking at that commit, its adds the code to leds-class.c and shouldn't
> > have needed to change the tristate to a bool. I know we discussed that
> > at the time and I think that part might have been unnecessary and just
> > accidentally committed. It could well be we can just revert that piece
> > of the patch.
> >
> 
> Richard,
> 
> Sorry for bringing up this topic so late. I was occupied by other
> stuff for a while.
> 
> I'm trying to make leds-class.c as a module, but found APIs exported
> from led-class.c are widely used in kernel.
> 
> For example: led_classdev_register()
> --
> linux-2.6$ grep -r led_classdev_register .
> ./include/linux/leds.h:extern int led_classdev_register(struct device *parent,
> ./drivers/mmc/host/au1xmmc.c:		ret = led_classdev_register(mmc_dev(mmc), led);

If there are users of the LED API compiled in, then the config code
should be handling this so the led class code is compiled in too.

That shouldn't make it impossible to have the class code as a module, if
the users are also modules.

> When CONFIG_NEW_LEDS=y, CONFIG_LEDS_CLASS=m and CONFIG_LEDS_TRIGGER=y,
> I got following error for building omap2plus_defconfig
> --
> arch/arm/plat-omap/built-in.o: In function `newled_init':
> /opt/git/linux-2.6/arch/arm/plat-omap/debug-leds.c:248: undefined
> reference to `led_classdev_register'

So this is a dependency issues as far as I can see,

> drivers/built-in.o: In function `led_trigger_blink':
> /opt/git/linux-2.6/drivers/leds/led-triggers.c:248: undefined
> reference to `led_blink_set'
> drivers/built-in.o: In function `led_trigger_set':
> /opt/git/linux-2.6/drivers/leds/led-triggers.c:116: undefined
> reference to `led_brightness_set'

but I agree these are more problematic.

> The commit 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad "led-class: always
> implement blinking" added 2 API (led_blink_set and
> `led_brightness_set'), which are used by led-trigger.c
> 
> For this kind of errors, I think it's quite hard to set led-class.c as
> a module now and suggest we merge NEW_LEDS and LEDS_CLASS together.

I still don't believe this is necessary. 

How about moving led_timer_function(), led_set_software_blink()
led_blink_set() and to led-triggers.c, putting #ifdef
CONFIG_LEDS_TRIGGERS around the appropriate pieces of leds-class.c. We'd
then move led_brightness_set() and led_stop_software_blink() to
led-core.c since those are the real problem.

It means there is a slightly higher always loaded footprint but its
better than giving up and making it all always loaded.

Cheers,

Richard


