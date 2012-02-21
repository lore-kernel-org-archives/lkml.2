Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461Ab2BUSdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:33:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10832 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2BUSdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:33:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Feb 2012 10:33:38 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: Grant Likely <grant.likely@secretlab.ca>, Barry Song <21cnbao@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Tue, 21 Feb 2012 10:33:34 -0800
Subject: RE: [PATCH] pinctrl: spawn U300 pinctrl from the COH901 GPIO
Thread-Topic: [PATCH] pinctrl: spawn U300 pinctrl from the COH901 GPIO
Thread-Index: AczwnaAXhjsOSnbETlGlrhpQ5tdIYgAKKiiw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC368@HQMAIL01.nvidia.com>
References: <1329831275-21769-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1329831275-21769-1-git-send-email-linus.walleij@stericsson.com>
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

Linus Walleij wrote at Tuesday, February 21, 2012 6:35 AM:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> This solves the riddle on how the U300 pin controller shall be
> able to reference the struct gpio_chip even though these are
> two separate drivers: spawn the pinctrl child from the GPIO
> driver and pass in the struct gpio_chip as platform data.
> In the process we rename the U300 "pinmux-u300" to
> "pinctrl-u300" so as not to confuse.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

That's quite a neat solution, but it's not going to work very well with
device tree, if U300 is being converted to it. The reason is that the
two (GPIO, pinctrl) platform devices would be instantiated directly from
DT by the core DT code. I guess your DT board file does have the option
to explicitly override the platform data passed to your devices to
achieve the same effect, but perhaps there's a different way of making
this work, that doesn't require platform data...

I'd thought about doing the following for Tegra, where we're cheating a
little with the gpio range base value:

When GPIO driver is probed, call a function in the pinctrl driver to
tell it what the "struct gpio_chip *" value is.

When pinctrl is probed, if that call has happened, go ahead and register
the GPIO range, else don't.

In the call from GPIO to pinctrl, if the pinctrl driver has already
probed, register the GPIO range, else just save the gpio_chip value for
later use in the pinctrl driver's probe.

This way, the communication is explicit in code in the drivers, works
whichever order the drivers probe, etc.

Does that sound like a reasonable solution?

It's plausible that with deferred probe, this could be reworked to use
that, but this way might still be better for this case?

-- 
nvpublic


