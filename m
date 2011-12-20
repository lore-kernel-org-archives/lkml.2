Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1LTSGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:06:22 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39703 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514Ab1LTSGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:06:18 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199bECePigb4uAPZcGJUZm9
Date: Tue, 20 Dec 2011 10:06:11 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 1/7][RESEND] ARM: OMAP1: ams-delta: register latch
 dependent devices later
Message-ID: <20111220180610.GB24444@atomide.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <83e934adfc691b347534edb7788a67ab2e6bd7e1.1324331816.git.jkrzyszt@tis.icnet.pl>
 <201112200028.32947.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112200028.32947.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111219 14:57]:
> Resending because of a typo in the Cc: list, sorry.
> 
> 8<--------------------------
> 
> In preparation to converting Amstrad Delta on-board latches to
> basic_mmio_gpio devices, registration of platform devices which depend
> on latches and will require initialization of their GPIO pins first,
> should be moved out of .machine_init down to late_initcall level, as the
> gpio-generic driver is not available until device_initcall time.  The
> latch reset operation, which will be replaced with GPIO initialization,
> must also be moved to late_initcall for the same reason.
> 
> Since there was already another, separate arch_initcall function for
> setting up one of those latch dependent devices, the on-board modem
> device, reuse that function, i.e., rename it to a name that matches the
> new purpose, extend with other device setup relocated from
> .machine_init, and move down to the late_initcall level.
> 
> While being at it, add missing gpio_free() in case the modem platform
> device registration fails.
> 
> In addition, defer registration of the Amstrad Delta ASoC and serio
> devices, done from their device driver files, until late_initcall time,
> as those drivers will depend on their GPIO pins already requested from
> the board late_init() function until updated to register their GPIO pins
> themselves.
> 
> Thanks to Tony Lindgren <tony@atomide.com> who suggested this approach
> instead of shifting up the gpio-generic driver initialization.
...
 
> --- a/drivers/input/serio/ams_delta_serio.c
> +++ b/drivers/input/serio/ams_delta_serio.c
> @@ -165,6 +165,9 @@ serio:
>  	kfree(ams_delta_serio);
>  	return err;
>  }
> +#ifndef MODULE
> +late_initcall(ams_delta_serio_init);
> +#else
>  module_init(ams_delta_serio_init);
>  
>  static void __exit ams_delta_serio_exit(void)
> @@ -175,3 +178,4 @@ static void __exit ams_delta_serio_exit(void)
>  	gpio_free(AMS_DELTA_GPIO_PIN_KEYBRD_DATA);
>  }
>  module_exit(ams_delta_serio_exit);
> +#endif
> diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
> index ccb8a6a..1764a3b 100644
> --- a/sound/soc/omap/ams-delta.c
> +++ b/sound/soc/omap/ams-delta.c
> @@ -636,6 +636,9 @@ err:
>  	platform_device_put(ams_delta_audio_platform_device);
>  	return ret;
>  }
> +#ifndef MODULE
> +late_initcall(ams_delta_module_init);
> +#else
>  module_init(ams_delta_module_init);
>  
>  static void __exit ams_delta_module_exit(void)
> @@ -657,6 +660,7 @@ static void __exit ams_delta_module_exit(void)
>  	platform_device_unregister(ams_delta_audio_platform_device);
>  }
>  module_exit(ams_delta_module_exit);
> +#endif
>  
>  MODULE_AUTHOR("Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>");
>  MODULE_DESCRIPTION("ALSA SoC driver for Amstrad E3 (Delta) videophone");

This looks a bit odd.. I think these drivers should be converted to
a proper platform_driver so you can get rid of the machine_is_ams_delta
check in the init. Then you can rely on the probe to match the
device. To deal with the init order issues, you can pass a set_power
function pointer in platform_data that the driver can use. Or
set up a fixed regulator for it.

Regards,

Tony
