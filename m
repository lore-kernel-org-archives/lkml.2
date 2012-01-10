Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab2AJWWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 17:22:43 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51232 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920Ab2AJWWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:22:41 -0500
Date: Tue, 10 Jan 2012 14:22:31 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: JJ Ding <jj_ding@emc.com.tw>, Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH TRIVIAL 1/5] Input: keyboard: use macro
 module_platform_driver()
Message-ID: <20120110222231.GA16702@core.coreip.homeip.net>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw>
 <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw>
 <CAMuHMdWVedppkaO5sF4WH78e8rdVJKXJknFVEZQo+VD2Rxmk=A@mail.gmail.com>
 <CAMuHMdU1fv-Qx1dRstFjBkqcKswWCu34Hkeusk1vW3ReXB7CDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdU1fv-Qx1dRstFjBkqcKswWCu34Hkeusk1vW3ReXB7CDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 09:57:08PM +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 10, 2012 at 21:47, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Tue, Nov 22, 2011 at 10:00, JJ Ding <jj_ding@emc.com.tw> wrote:
> >> From: JJ Ding <dgdunix@gmail.com>
> >>
> >> Commit 940ab88962bc1aff3273a8356d64577a6e386736 introduced a new macro to
> >> save some platform_driver boilerplate code. Use it.
> >
> >> diff --git a/drivers/input/keyboard/amikbd.c b/drivers/input/keyboard/amikbd.c
> >> index 79172af..6df5f6a 100644
> >> --- a/drivers/input/keyboard/amikbd.c
> >> +++ b/drivers/input/keyboard/amikbd.c
> >> @@ -259,19 +259,6 @@ static struct platform_driver amikbd_driver = {
> >>                .owner  = THIS_MODULE,
> >>        },
> >>  };
> >> -
> >> -static int __init amikbd_init(void)
> >> -{
> >> -       return platform_driver_probe(&amikbd_driver, amikbd_probe);
> >> -}
> >> -
> >> -module_init(amikbd_init);
> >> -
> >> -static void __exit amikbd_exit(void)
> >> -{
> >> -       platform_driver_unregister(&amikbd_driver);
> >> -}
> >> -
> >> -module_exit(amikbd_exit);
> >> +module_platform_driver(amikbd_driver);
> >>
> >>  MODULE_ALIAS("platform:amiga-keyboard");
> >
> > Sorry for not noticing before, but this is not correct.
> > Drivers using platform_driver_probe() typically don't fill in the
> > platform_driver.probe
> > method, as it's passed explicitly to platform_driver_probe() instead.
> > Hence amikbd_probe() is now referenced nowhere, and thus never called
> > (doesn't the compiler warn about amikbd_probe() being defined but unused?).
> >
> >> diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
> >> index 9d82b3a..4698252 100644
> >> --- a/drivers/input/keyboard/davinci_keyscan.c
> >> +++ b/drivers/input/keyboard/davinci_keyscan.c
> >> @@ -328,18 +328,7 @@ static struct platform_driver davinci_ks_driver = {
> >>        },
> >>        .remove = __devexit_p(davinci_ks_remove),
> >>  };
> >> -
> >> -static int __init davinci_ks_init(void)
> >> -{
> >> -       return platform_driver_probe(&davinci_ks_driver, davinci_ks_probe);
> >> -}
> >> -module_init(davinci_ks_init);
> >> -
> >> -static void __exit davinci_ks_exit(void)
> >> -{
> >> -       platform_driver_unregister(&davinci_ks_driver);
> >> -}
> >> -module_exit(davinci_ks_exit);
> >> +module_platform_driver(davinci_ks_driver);
> >>
> >>  MODULE_AUTHOR("Miguel Aguilar");
> >>  MODULE_DESCRIPTION("Texas Instruments DaVinci Key Scan Driver");
> >
> > Same here, I think.
> 
> And looking for platform_driver_probe() in recent changesets, I found
> a few more:
> 
> drivers/input/touchscreen/atmel-wm97xx.c atmel_wm97xx_probe
> drivers/input/touchscreen/mc13783_ts.c mc13783_ts_probe
> drivers/input/serio/at32psif.c psif_probe
> drivers/input/mouse/amimouse.c amimouse_probe
> 
> Interestingly, in drivers/input/misc/twl4030-pwrbutton.c you did make
> platform_driver.probe point to twl4030_pwrbutton_probe().
> But that one is also broken, as twl4030_pwrbutton_probe() is marked __init,
> which is no longer correct.
> 
> Still, setting up platform_driver.probe and removing __init from all probe
> functions is not the right thing to do, as this make (non-__init) kernel code
> size bigger, while none of these devices are hotpluggable and thus cannot
> appear after bootup. That's why we have platform_driver_probe() in the
> first place. So I think all of this should be reverted for non-hotpluggable
> drivers.

Crap, I didn't notice we messed up platform_driver_probe() users; I'll
revert changes to these drivers.

Thanks.

-- 
Dmitry
