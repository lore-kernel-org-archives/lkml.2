Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2BUSvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:51:22 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13796 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2BUSvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:51:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Feb 2012 10:50:59 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 21 Feb 2012 10:50:57 -0800
Subject: RE: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl
 interaction
Thread-Topic: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl
 interaction
Thread-Index: AczwhWB/+W+D3nuhQn6FOSeYUjmc4gAQ6pPw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC37D@HQMAIL01.nvidia.com>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
	<20120220073941.GC22562@n2100.arm.linux.org.uk>
 <CACRpkdbMFN3=XTSg1oE310eTHecrs6XaMz+DCNYJzwOg8JEEiQ@mail.gmail.com>
In-Reply-To: <CACRpkdbMFN3=XTSg1oE310eTHecrs6XaMz+DCNYJzwOg8JEEiQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote at Tuesday, February 21, 2012 3:42 AM:
> On Mon, Feb 20, 2012 at 8:39 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Sun, Feb 19, 2012 at 11:27:42PM -0700, Stephen Warren wrote:
> >> Update gpio.txt based on recent discussions regarding interaction with the
> >> pinctrl subsystem.
> >>
> >> Previously, gpio_request() was described as explicitly not performing any
> >> required mux setup operations etc.
> >>
> >> Now, gpio_request() is explicitly as explicitly performing any required mux
> >> setup operations where possible. In the case it isn't, platform code is
> >> required to have set up any required muxing or other configuration prior to
> >> gpio_request() being called, in order to maintain the same semantics.
> >
> > So what if you need to have the pin as a GPIO, manipulate it as a GPIO,
> > and then hand it off to a special function, and then take it back as
> > a GPIO before you shut the special function down ?
> 
> I remember this case very well and we designed for it, so it should be handled
> by pin control and GPIO thusly:
> 
> Example: use pins 1,2 as I2C, then convert them to GPIO for a while
> then back again:

The code below doesn't necessarily do exactly what Russell needs...

> // This call looks up a map containing pins 1,2 and reserve them
> p = pinctrl_get(dev, "i2c");
> if (IS_ERR(p))
>   ...
> pinctrl_enable(p);
> pinctrl_disable(p);

Here, the pinctrl core will call the pinctrl driver's pinmux_ops.free()
function. The whole point of this function is to change the pin's mux
selection to something that is guaranteed not to conflict with any other
pin's mux setting.

Now, if the HW only allows each signal to be routed to a specific pin
(or not routed), then free() might be a no-op.

However, if the HW allows the I2C module's signals to be routed to pins
A+B or X+Y, then free() on pins A/B would need to reprogram the mux to
route something else to pins A+B (or disable those pins or whatever the
HW needs) so that if I2C was later selected on pins X+Y, there would be
no conflict; it wouldn't be the case that both pins A+B and X+Y had I2C
mux'd on to them.

Hence, in general at least, pinctrl_disable() might glitch the output
signals.

As far as how to fix this; see my future responses to your future emails
:-)

> // This will free up the pins again
> pinctrl_put(p);
> // So now we can do this...
> // NB: the GPIO driver calls pinctr_request_gpio() to check
> // that it can take these pins
> gpio_request(1, "gpio1"):
> gpio_request(2, "gpio2");
> // This will trigger a reset or something
> gpio_direction_output(1, 1);
> gpio_direction_output(2, 1);
> // Release pins again
> gpio_free(1);
> gpio_free(2);
> // Take them back for this function
> p = pinctrl_get(dev, "i2c");
...

-- 
nvpublic

