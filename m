Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759004Ab2KWJNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 04:13:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49574 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab2KWJNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 04:13:17 -0500
Message-ID: <50AF3E21.4000009@ti.com>
Date: Fri, 23 Nov 2012 10:13:05 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121105 Thunderbird/16.0.1
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linus Walleij <linus.walleij@linaro.org>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost>
In-Reply-To: <20121123075537.A14713E0A91@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 11/23/2012 08:55 AM, Grant Likely wrote:
> Ugh. and this is why I wanted the PWM and GPIO subsystems to use the
> same namespace and binding. <grumble, mutter> But that's not your fault.
> 
> It's pretty horrible to have a separate translator node to convert a PWM
> into a GPIO (with output only of course). The gpio properties should
> appear directly in the PWM node itself and the translation code should
> be in either the pwm or the gpio core. I don't think it should look like
> a separate device.

Let me see if I understand your suggestion correctly. In the DT you suggest
something like this:

twl_pwmled: pwmled {
	compatible = "ti,twl4030-pwmled";
	#pwm-cells = <2>;
	#gpio-cells = <2>;
	gpio-controller;
};

led_user {
	compatible = "pwm-leds";
	pwms = <&twl_pwmled 1 7812500>; /* PWMB/LEDB from twl4030 */
	pwm-names = "PMU_STAT LED";

	label = "beagleboard::pmu_stat";
	max-brightness = <127>;
};

vdd_usbhost: fixedregulator-vdd-usbhost {
	compatible = "regulator-fixed";
	regulator-name = "USBHOST_POWER";
	regulator-min-microvolt = <5000000>;
	regulator-max-microvolt = <5000000>;
	gpio = <&twl_pwmled 0 7812500>; /* PWMA/LEDA from twl4030 */
	enable-active-high;
	regulator-boot-on;
};

With this I think this is what should happen in code level:
- the "pwm-gpo" driver does not have of_match_table at all.
- the driver for the "ti,twl4030-pwmled" is loaded.
- it prepares and calls pwmchip_add() to add the PWM chip.
- the of_pwmchip_add() will look for gpio-controller property of the node
 - if it is found it prepares the pdata (based on the PWM chip information)
for the "pwm-gpo" driver and registers the platform_device for it.
 - the "pwm-gpo" driver will use:
    priv->gpio_chip.of_node = pdev->dev.parent->of_node;

In DT boot we are fine with this I think.

When it comes to legacy boot (boot without DT) I think we should still have
the two layers to avoid big changes which would affect all existing pwm
drivers. Something like this in the board files:

static struct pwm_lookup pwm_lookup[] = {
	/* LEDA ->  nUSBHOST_PWR_EN */
	PWM_LOOKUP("twl-pwmled", 0, "pwm-gpo", "nUSBHOST_PWR_EN"),
	/* LEDB -> PMU_STAT */
	PWM_LOOKUP("twl-pwmled", 1, "leds_pwm", "beagleboard::pmu_stat"),
};

/* for the LED user of PWM */
static struct led_pwm pwm_leds[] = {
	{
		.name		= "beagleboard::pmu_stat",
		.max_brightness	= 127,
		.pwm_period_ns	= 7812500,
	},
};

static struct led_pwm_platform_data pwm_data = {
	.num_leds	= ARRAY_SIZE(pwm_leds),
	.leds		= pwm_leds,
};

static struct platform_device leds_pwm = {
	.name	= "leds_pwm",
	.id	= -1,
	.dev	= {
		.platform_data = &pwm_data,
	},
};

/* for the GPIO user of PWM */
static struct gpio_pwm pwm_gpios[] = {
	{
		.name		= "nUSBHOST_PWR_EN",
		.pwm_period_ns	= 7812500,
	},
};

static struct gpio_pwm_pdata pwm_gpio_data = {
	.num_gpos	= ARRAY_SIZE(pwm_gpios),
	.gpos		= pwm_gpios,
	.setup		= beagle_pwm_gpio_setup, /*to get the gpio base	*/
};

static struct platform_device gpos_pwm = {
	.name	= "pwm-gpo",
	.id	= -1,
	.dev	= {
		.platform_data = &pwm_gpio_data,
	},
};

static int beagle_pwm_gpio_setup(struct device *dev, unsigned gpio,
				 unsigned ngpio)
{
	beagle_usbhub_pdata.gpio = gpio; /* fixed_voltage_config struct */

	platform_device_register(&beagle_usbhub);
	return 0;
}

What do you think?

-- 
Péter
