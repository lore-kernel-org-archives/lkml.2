Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab2GBDdV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:33:21 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15131 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab2GBDdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:33:19 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 01 Jul 2012 20:33:18 -0700
Message-ID: <4FF116F0.5070602@nvidia.com>
Date: Mon, 2 Jul 2012 12:35:12 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@nvidia.com>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120630183742.GE23990@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120630183742.GE23990@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 03:37 AM, Thierry Reding wrote:>> +	ret = 
of_get_named_gpio(node, "enable-gpios", 0);
 >> +	if (ret >= 0) {
 >> +		data->enable_gpio = of_get_named_gpio(node, "enable-gpios", 0);
 >
 > Can't you just reuse the value of ret here?

Yes, definitely.

 >> +	pb->enable_gpio = -EINVAL;
 >
 > Perhaps initialize this to -1? Assigning standard error codes to a GPIO
 > doesn't make much sense.

Documentation/gpio.txt states the following:

"If you want to initialize a structure with an invalid GPIO number, use
some negative number (perhaps "-EINVAL"); that will never be valid."

gpio_is_valid() seems to be happy with any negative value, but -EINVAL 
seems to be a convention here.

 >> +	/* optional GPIO that enables/disables the backlight */
 >> +	int enable_gpio;
 >> +	/* 0 (default initialization value) is a valid GPIO number. Make 
use of
 >> +	 * control gpio explicit to avoid bad surprises. */
 >> +	bool use_enable_gpio;
 >
 > It's a shame we have to add workarounds like this...

Yeah, I hate that too. :/ I see nothing better to do unfortunately.

Other remarks from Stephen made me realize that this patch has two major 
flaws:

1) The GPIO and regulator are fixed, optional entites ; this should 
cover most cases but is not very flexible.
2) Some (most?) backlight specify timings between turning power 
on/enabling PWM/enabling backlight. Even the order of things may be 
different. This patch totally ignores that.

So instead of having fixed "power-supply" and "enable-gpio" properties, 
how about having properties describing the power-on and power-off 
sequences which odd cells alternate between phandles to 
regulators/gpios/pwm and delays in microseconds before continuing the 
sequence. For example:

power-on = <&pwm 2 5000000
	    10000
	    &backlight_reg
	    0
	    &gpio 28 0>;
power-off = <&gpio 28 0
	     0
	     &backlight_reg
	     10000
	     &pwm 2 0>;

Here the power-on sequence would translate to, power on the second PWM 
with a duty-cycle of 5ms, wait 10ms, then enable the backlight regulator 
and GPIO 28 without delay. Power-off is the exact opposite. The nice 
thing with this scheme is that you can reorder the sequence at will and 
support the weirdest setups.

What I don't know (device tree newbie here!) is:
1) Is it legal to refer the same phandle several times in the same node?
2) Is it ok to mix phandles of different types with integer values? The 
DT above compiled, but can you e.g. resolve a regulator phandle in the 
middle of a property?
3) Can you "guess" the type of a phandle before parsing it? Here the 
first phandle is a GPIO, but it could as well be the regulator. Do we 
have means to know that in the driver code?

Sorry for the long explanation, but I really wonder if doing this is 
possible at all. If it is, then I think that's the way to do for 
backlight initialization.

Alex.

