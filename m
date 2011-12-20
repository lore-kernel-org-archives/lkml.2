Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1LTUfn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:35:43 -0500
Received: from d1.icnet.pl ([212.160.220.21]:38257 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1LTUff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:35:35 -0500
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH v2 1/7][RESEND] ARM: OMAP1: ams-delta: register latch dependent devices later
Date: Tue, 20 Dec 2011 21:34:36 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; i686; ; )
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl> <201112200028.32947.jkrzyszt@tis.icnet.pl> <20111220180610.GB24444@atomide.com>
In-Reply-To: <20111220180610.GB24444@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201112202134.36802.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 of December 2011 at 19:06:11, Tony Lindgren wrote:
> * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 14:57]:
> > Resending because of a typo in the Cc: list, sorry.
> > 
> > 8<--------------------------
> > 
> > In preparation to converting Amstrad Delta on-board latches to
> > basic_mmio_gpio devices, registration of platform devices which depend
> > on latches and will require initialization of their GPIO pins first,
> > should be moved out of .machine_init down to late_initcall level, as the
> > gpio-generic driver is not available until device_initcall time.  The
> > latch reset operation, which will be replaced with GPIO initialization,
> > must also be moved to late_initcall for the same reason.
> > 
> > Since there was already another, separate arch_initcall function for
> > setting up one of those latch dependent devices, the on-board modem
> > device, reuse that function, i.e., rename it to a name that matches the
> > new purpose, extend with other device setup relocated from
> > .machine_init, and move down to the late_initcall level.
> > 
> > While being at it, add missing gpio_free() in case the modem platform
> > device registration fails.
> > 
> > In addition, defer registration of the Amstrad Delta ASoC and serio
> > devices, done from their device driver files, until late_initcall time,
> > as those drivers will depend on their GPIO pins already requested from
> > the board late_init() function until updated to register their GPIO pins
> > themselves.
> > 
> > Thanks to Tony Lindgren <tony@atomide.com> who suggested this approach
> > instead of shifting up the gpio-generic driver initialization.
> ...
>  
> > --- a/drivers/input/serio/ams_delta_serio.c
> > +++ b/drivers/input/serio/ams_delta_serio.c
> > @@ -165,6 +165,9 @@ serio:
> >  	kfree(ams_delta_serio);
> >  	return err;
> >  }
> > +#ifndef MODULE
> > +late_initcall(ams_delta_serio_init);
> > +#else
> >  module_init(ams_delta_serio_init);
> >  
> >  static void __exit ams_delta_serio_exit(void)
> > @@ -175,3 +178,4 @@ static void __exit ams_delta_serio_exit(void)
> >  	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
> >  }
> >  module_exit(ams_delta_serio_exit);
> > +#endif
> > diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
> > index ccb8a6a..1764a3b 100644
> > --- a/sound/soc/omap/ams-delta.c
> > +++ b/sound/soc/omap/ams-delta.c
> > @@ -636,6 +636,9 @@ err:
> >  	platform_device_put(ams_delta_audio_platform_device);
> >  	return ret;
> >  }
> > +#ifndef MODULE
> > +late_initcall(ams_delta_module_init);
> > +#else
> >  module_init(ams_delta_module_init);
> >  
> >  static void __exit ams_delta_module_exit(void)
> > @@ -657,6 +660,7 @@ static void __exit ams_delta_module_exit(void)
> >  	platform_device_unregister(ams_delta_audio_platform_device);
> >  }
> >  module_exit(ams_delta_module_exit);
> > +#endif
> >  
> >  MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
> >  MODULE_DESCRIPTION("ALSA SoC driver for Amstrad E3 (Delta) videophone");
> 
> This looks a bit odd.. I think these drivers should be converted to
> a proper platform_driver so you can get rid of the machine_is_ams_delta
> check in the init. Then you can rely on the probe to match the
> device.

Mostly true, but first of all, I don't pretend to solve all problems 
with all Amstrad Delta specific drivers in this patch series. I'm 
concentrating on converting latches to GPIO pins, and updating those 
drivers to access those pins with gpiolib API instead of accessing the 
latches with the board specific API. Nothing more.

Now, regarding the serio driver, you are absolutely right, the device 
registration could be better moved out of the driver file to the board 
file. I'll probably do this some time in the future, once I'm ready with 
the latches related stuff, i.e. the ams_delta_latch_write() is finally 
removed from the board file as no longer used by any driver, and find 
some spare time again. For now, I'm moving that serio device/driver 
initialization to late_initcall with patch 2/7, and back to 
device_initcall once converted to gpiolib (patch 7/7). Is this 
acceptable? If not, let's drop those forward and back moves, and the 
driver will get broken with 2/7, but get repaired with 7/7, OK?

Regarding the sound card: the sound/soc/omap/ams-delta.c file is not a 
device driver per se, but rather a piece of code which sets up a 
platform device representing the sound card, i.e., provides platform 
device description and platform data, including device specific 
callbacks, to be used by the generic 'soc-audio' driver. There is no 
single platform_driver_register() called from that file, only 
platform_device_register() or alike. That code seems to belong logically 
to the board setup, but was always maintained, among 12 others, and for 
reasons not known to me with my relatively short experience as a kernel 
developer, inside the sound/soc/omap/ subtree, not under arch/arm/mach-
omap1/. Like all those 12 others, including sdp4430 which is quite 
recent I guess, it makes use of the machine_is_* function as if it was a 
part of a board files set. Then, the only way I can see to defer the 
device initialization until late_initcall time, with the soc-audio 
driver already loaded at the device_initcall level, is to move with that 
sound card platform device setup code, found in sound/soc/omap/ams-
delta.c, to the late_initcall. Am I missing something?

> To deal with the init order issues, you can pass a set_power
> function pointer in platform_data that the driver can use. Or
> set up a fixed regulator for it.

I'm already working on the follow up patch series mentioned in the cover 
letter, and yes, I'm using the fixed regulator. Be patient, please, as 
my resources are somehow limited.

Thanks,
Janusz
