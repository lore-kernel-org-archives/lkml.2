Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab2K2MSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 07:18:31 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46323 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2K2MS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 07:18:29 -0500
Message-ID: <50B75283.6010207@ti.com>
Date: Thu, 29 Nov 2012 13:18:11 +0100
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Landley <rob@landley.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] gpio: New driver for GPO emulation using PWM generators
References: <1353591723-25233-1-git-send-email-peter.ujfalusi@ti.com> <20121123075537.A14713E0A91@localhost> <50AF3E21.4000009@ti.com> <50AF4584.7020604@ti.com> <20121126154600.765E03E1AFD@localhost> <50B5D161.6010200@ti.com> <20121128193006.GB23444@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121128193006.GB23444@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 08:30 PM, Thierry Reding wrote:
> I must say I'm not terribly thrilled to integrate something like this
> into the PWM subsystem.

I agree. I would not really want to add my name to something like this either...

> I wish hardware engineers wouldn't come up with such designs.

I have checked and rechecked the schematics and datasheets. Still can not
understand how anyone would come to this HW solution (when the twl4030 have at
least 4 unused GPIO line left unconnected).

> But since this seems to be a real use-case, if we want to
> support it we should try and find the "right" solution.
> 
> Reading the above sounds overly complicated. Couldn't we, instead of
> instantiating an extra driver, just register a GPIO chip if a chip wants
> to support this functionality? Where the GPIO chip's request callback
> requests the given PWM so that it cannot be used elsewhere? The
> direction_input callback would need to always fail and the set callback
> can configure the PWM either to 0% or 100% duty-cycle depending on the
> desired output value.

The original driver was doing exactly this. Basically I have added a GPO chip
(which was just a translator from PWM to GPO). In DT it looked like this:

twl_pwm: pwm {
	compatible = "ti,twl4030-pwmled";
	#pwm-cells = <2>;
};

pwm_gpo1: gpo1 {
	compatible = "pwm-gpo";
	#gpio-cells = <1>;
	gpio-controller;
	pwms = <&twl_pwm 0 7812500>;
	pwm-names = "nUSBHOST_PWR_EN";
};

user@1 {
	compatible = "example,testuser";
	gpios = <&pwm_gpo1 0>;
};

When we boot with DT the pwm_get() needs pwms phandle from the device you are
calling it in order to find the PWM in question. If we do not have DT entry
for the GPO driver, we need to build up a pwm_lookup table to ensure that the
pwm_get() will find the PWM we want to handle.

We could implement the GPIO related code under for example
drivers/pwm/pwm-as-gpo.c
But then I should merge the code from drivers/gpio/gpio-pwm.c inside.
This is not nice either since we will have a GPIO driver living under pwm/
directory and I'm not sure how this would use the pwm API when the GPO
functionality is requested.

-- 
Péter
