Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab1LUUHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:07:53 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:20652 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751456Ab1LUUHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:07:50 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/ckfHVMJyW7i4ajIJRrDwB
Date: Wed, 21 Dec 2011 12:07:29 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v2 1/7 v2] ARM: OMAP1: ams-delta: register latch
 dependent devices later
Message-ID: <20111221200728.GG24444@atomide.com>
References: <201112200028.32947.jkrzyszt@tis.icnet.pl>
 <1324418058-30905-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <20111221190815.GC24444@atomide.com>
 <201112212051.13113.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112212051.13113.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111221 11:20]:
> On Wednesday 21 of December 2011 at 20:08:15, Tony Lindgren wrote:
> > * Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111220 13:23]:
> > > In preparation to converting Amstrad Delta on-board latches to
> > > basic_mmio_gpio devices, registration of platform devices which depend
> > > on latches and will require initialization of their GPIO pins first,
> > > should be moved out of .machine_init down to late_initcall level, as the
> > > gpio-generic driver is not available until device_initcall time.  The
> > > latch reset operation, which will be replaced with GPIO initialization,
> > > must also be moved to late_initcall for the same reason.
> > > 
> > > Since there was already another, separate arch_initcall function for
> > > setting up one of those latch dependent devices, the on-board modem
> > > device, reuse that function, i.e., rename it to a name that matches the
> > > new purpose, extend with other device setup relocated from
> > > .machine_init, and move down to the late_initcall level.
> > > 
> > > While being at it, add missing gpio_free() in case the modem platform
> > > device registration fails.
> > > 
> > > Thanks to Tony Lindgren <tony@atomide.com> who suggested this approach
> > > instead of shifting up the gpio-generic driver initialization.
> > > 
> > > In addition, defer registration of the Amstrad Delta ASoC and serio
> > > devices, done from their device driver files, until late_initcall time,
> > > as those drivers will depend on their GPIO pins already requested from
> > > the board late_init() function until updated to register their GPIO pins
> > > themselves.
> > > 
> > > Created and tested against linux-3.2-rc6.
> > > 
> > > Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> > 
> > Planning to apply this series. Dmitry, care to ack the drivers/input/serio/
> > related change?
> 
> Don't we need Jarkko's or Mark's or Liam's ack as well for the change to 
> the sound/soc/omap/ams-delta.c file?

Yes, you're right.

Tony

> > > Changes since the initial version of this patch:
> > > * use late_initcall() unconditionally in modules, requested by Russell
> > >   King (thanks!); an updated patch 7/7 will follow,
> > > * in the changelog message, move credits to Tony up a bit, since the
> > >   person responsible for other changes (he might not necessarily like)
> > >   is me, not him ;).
> > > 
> > > Comments copied from this patch initial submission:
> > > This patch was not present in the initial submission, it replaces the
> > > old patch 1/10, providing an alternative solution not touching the
> > > gpio-generic driver.
> > > 
> > >  arch/arm/mach-omap1/board-ams-delta.c |   28 ++++++++++++++++++++--------
> > >  drivers/input/serio/ams_delta_serio.c |    2 +-
> > >  sound/soc/omap/ams-delta.c            |    2 +-
> > >  3 files changed, 22 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/arch/arm/mach-omap1/board-ams-delta.c b/arch/arm/mach-omap1/board-ams-delta.c
> > > index b0f15d2..50987c9 100644
> > > --- a/arch/arm/mach-omap1/board-ams-delta.c
> > > +++ b/arch/arm/mach-omap1/board-ams-delta.c
> > > @@ -275,11 +275,14 @@ static struct omap1_cam_platform_data ams_delta_camera_platform_data = {
> > >  };
> > >  
> > >  static struct platform_device *ams_delta_devices[] __initdata = {
> > > -	&ams_delta_nand_device,
> > >  	&ams_delta_kp_device,
> > > +	&ams_delta_camera_device,
> > > +};
> > > +
> > > +static struct platform_device *late_devices[] __initdata = {
> > > +	&ams_delta_nand_device,
> > >  	&ams_delta_lcd_device,
> > >  	&ams_delta_led_device,
> > > -	&ams_delta_camera_device,
> > >  };
> > >  
> > >  static void __init ams_delta_init(void)
> > > @@ -307,9 +310,6 @@ static void __init ams_delta_init(void)
> > >  	omap_serial_init();
> > >  	omap_register_i2c_bus(1, 100, NULL, 0);
> > >  
> > > -	/* Clear latch2 (NAND, LCD, modem enable) */
> > > -	ams_delta_latch2_write(~0, 0);
> > > -
> > >  	omap1_usb_init(&ams_delta_usb_config);
> > >  	omap1_set_camera_info(&ams_delta_camera_platform_data);
> > >  #ifdef CONFIG_LEDS_TRIGGERS
> > > @@ -345,13 +345,18 @@ static struct platform_device ams_delta_modem_device = {
> > >  	},
> > >  };
> > >  
> > > -static int __init ams_delta_modem_init(void)
> > > +static int __init late_init(void)
> > >  {
> > >  	int err;
> > >  
> > >  	if (!machine_is_ams_delta())
> > >  		return -ENODEV;
> > >  
> > > +	/* Clear latch2 (NAND, LCD, modem enable) */
> > > +	ams_delta_latch2_write(~0, 0);
> > > +
> > > +	platform_add_devices(late_devices, ARRAY_SIZE(late_devices));
> > > +
> > >  	omap_cfg_reg(M14_1510_GPIO2);
> > >  	ams_delta_modem_ports[0].irq =
> > >  			gpio_to_irq(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
> > > @@ -367,9 +372,16 @@ static int __init ams_delta_modem_init(void)
> > >  		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC,
> > >  		AMS_DELTA_LATCH2_MODEM_NRESET | AMS_DELTA_LATCH2_MODEM_CODEC);
> > >  
> > > -	return platform_device_register(&ams_delta_modem_device);
> > > +	err = platform_device_register(&ams_delta_modem_device);
> > > +	if (err)
> > > +		goto gpio_free;
> > > +	return 0;
> > > +
> > > +gpio_free:
> > > +	gpio_free(AMS_DELTA_GPIO_PIN_MODEM_IRQ);
> > > +	return err;
> > >  }
> > > -arch_initcall(ams_delta_modem_init);
> > > +late_initcall(late_init);
> > >  
> > >  static void __init ams_delta_map_io(void)
> > >  {
> > > diff --git a/drivers/input/serio/ams_delta_serio.c b/drivers/input/serio/ams_delta_serio.c
> > > index d4d08bd..835d37a 100644
> > > --- a/drivers/input/serio/ams_delta_serio.c
> > > +++ b/drivers/input/serio/ams_delta_serio.c
> > > @@ -165,7 +165,7 @@ serio:
> > >  	kfree(ams_delta_serio);
> > >  	return err;
> > >  }
> > > -module_init(ams_delta_serio_init);
> > > +late_initcall(ams_delta_serio_init);
> > >  
> > >  static void __exit ams_delta_serio_exit(void)
> > >  {
> > > diff --git a/sound/soc/omap/ams-delta.c b/sound/soc/omap/ams-delta.c
> > > index ccb8a6a..be81bc7 100644
> > > --- a/sound/soc/omap/ams-delta.c
> > > +++ b/sound/soc/omap/ams-delta.c
> > > @@ -636,7 +636,7 @@ err:
> > >  	platform_device_put(ams_delta_audio_platform_device);
> > >  	return ret;
> > >  }
> > > -module_init(ams_delta_module_init);
> > > +late_initcall(ams_delta_module_init);
> > >  
> > >  static void __exit ams_delta_module_exit(void)
> > >  {
> > 
