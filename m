Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab2JXROA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 13:14:00 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37600 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab2JXRN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 13:13:58 -0400
MIME-Version: 1.0
In-Reply-To: <20121024165215.GA32220@arwen.pp.htv.fi>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121022155028.GA13791@core.coreip.homeip.net>
	<508660D4.9030507@ti.com>
	<20121023200249.GA2712@core.coreip.homeip.net>
	<20121024083704.GF5665@arwen.pp.htv.fi>
	<20121024161429.GA16350@core.coreip.homeip.net>
	<20121024165215.GA32220@arwen.pp.htv.fi>
Date: Wed, 24 Oct 2012 19:13:57 +0200
Message-ID: <CACRpkdYVAgO25s2RRYvt-KLS_4=NDJNfxQ+ThJuyWtksg27dhA@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: balbi@ti.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 6:52 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Oct 24, 2012 at 09:14:29AM -0700, Dmitry Torokhov wrote:

>> All of _their_ resources, exactly. They do not own nor control pins so
>> they should not be bothered with them either. Look, when you see that
>
> except that they *own* the pins. Now that the muxer has been setup
> properly, this particular IP owns the pins.

This is true. It is then also reflected in the device model.
And in debugfs, which is very helpful when debugging. If I
cat
/sys/kernel/debug/pinctrl/pinctrl-db8500/pins

I can see a list of all pins on this ASIC and what device
is using it. It is all due to the fact that each driver use
[devm_]pinctrl_get(&dev) ad the struct device * pointer
is used with dev_name() to print the corresponding
device name.

When using hogs it just says the name of the pin
controller and the pins aren't really connected to their
real consumers :-P

Example:

Pinmux settings per pin
Format: pin (name): mux_owner gpio_owner hog?
pin 0 (GPIO0_AJ5): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 1 (GPIO1_AJ3): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 2 (GPIO2_AH4): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 3 (GPIO3_AH3): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 4 (GPIO4_AH6): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 5 (GPIO5_AG6): (MUX UNCLAIMED) DB8500:5
pin 6 (GPIO6_AF6): pinctrl-db8500 (GPIO UNCLAIMED) function ipgpio
group ipgpio0_c_1
pin 7 (GPIO7_AG5): pinctrl-db8500 (GPIO UNCLAIMED) function ipgpio
group ipgpio1_c_1
pin 8 (GPIO8_AD5): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 9 (GPIO9_AE4): (MUX UNCLAIMED) (GPIO UNCLAIMED)
pin 10 (GPIO10_AF5): nmk-i2c.2 (GPIO UNCLAIMED) function i2c2 group i2c2_b_2
pin 11 (GPIO11_AG4): nmk-i2c.2 (GPIO UNCLAIMED) function i2c2 group i2c2_b_2
pin 12 (GPIO12_AC4): pinctrl-db8500 (GPIO UNCLAIMED) function msp0
group msp0txrx_a_1
pin 13 (GPIO13_AF3): pinctrl-db8500 (GPIO UNCLAIMED) function msp0
group msp0tfstck_a_1
pin 14 (GPIO14_AE3): pinctrl-db8500 (GPIO UNCLAIMED) function msp0
group msp0tfstck_a_1
pin 15 (GPIO15_AC3): pinctrl-db8500 (GPIO UNCLAIMED) function msp0
group msp0txrx_a_1
pin 16 (GPIO16_AD3): nmk-i2c.1 (GPIO UNCLAIMED) function i2c1 group i2c1_b_2
pin 17 (GPIO17_AD4): nmk-i2c.1 (GPIO UNCLAIMED) function i2c1 group i2c1_b_2

As you can see pins 6,7,12-15 are using hogs. Sure I can see
the name of the function but that is just a string albeit
helpful.

Pins 10,11,16,17 are requested directly from the i2c driver
and shows up connected to its device.

Yours,
Linus Walleij
