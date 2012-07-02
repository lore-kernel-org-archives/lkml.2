Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab2GBHQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 03:16:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8028 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab2GBHQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 03:16:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 02 Jul 2012 00:16:40 -0700
Message-ID: <4FF14B4A.3050101@nvidia.com>
Date: Mon, 2 Jul 2012 16:18:34 +0900
From: Alexandre Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Stephen Warren <swarren@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Mitch Bradley <wmb@firmworks.com>
Subject: Re: [PATCH] pwm-backlight: add regulator and GPIO support
References: <1340976167-27298-1-git-send-email-acourbot@nvidia.com> <20120630183742.GE23990@avionic-0098.adnet.avionic-design.de> <4FF116F0.5070602@nvidia.com> <20120702064624.GA8683@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120702064624.GA8683@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2012 03:46 PM, Thierry Reding wrote:
>> So instead of having fixed "power-supply" and "enable-gpio"
>> properties, how about having properties describing the power-on and
>> power-off sequences which odd cells alternate between phandles to
>> regulators/gpios/pwm and delays in microseconds before continuing
>> the sequence. For example:
>>
>> power-on = <&pwm 2 5000000
>> 	    10000
>> 	    &backlight_reg
>> 	    0
>> 	    &gpio 28 0>;
>> power-off = <&gpio 28 0
>> 	     0
>> 	     &backlight_reg
>> 	     10000
>> 	     &pwm 2 0>;
>>
>> Here the power-on sequence would translate to, power on the second
>> PWM with a duty-cycle of 5ms, wait 10ms, then enable the backlight
>> regulator and GPIO 28 without delay. Power-off is the exact
>> opposite. The nice thing with this scheme is that you can reorder
>> the sequence at will and support the weirdest setups.
>
> I generally like the idea. I'm Cc'ing the devicetree-discuss mailing
> list, let's see what people there think about it. I've also added Mitch
> Bradley who already helped a lot with the initial binding.

Cool, thanks. I am aware that this idea probably needs to be refined, 
but ideally we would end up with something as simple as this example.

>> What I don't know (device tree newbie here!) is:
>> 1) Is it legal to refer the same phandle several times in the same node?
>> 2) Is it ok to mix phandles of different types with integer values?
>> The DT above compiled, but can you e.g. resolve a regulator phandle
>> in the middle of a property?
>
> I believe these shouldn't be a problem.

Nice, I'll try to see how I can parse it then.

>> 3) Can you "guess" the type of a phandle before parsing it? Here the
>> first phandle is a GPIO, but it could as well be the regulator. Do
>> we have means to know that in the driver code?
>
> That isn't possible. But you could for instance use a cell to specify
> the type of the following phandle.

That sounds reasonnable, although we would also need to bind values to 
phandle types. That would make the DT a little bit more cryptic, 
although nothing too bad I think.

>> Sorry for the long explanation, but I really wonder if doing this is
>> possible at all. If it is, then I think that's the way to do for
>> backlight initialization.
>
> OTOH we basically end up describing a code sequence in the DT. But as
> you mention above sometimes the hardware requires specific timing
> parameters so this might actually be a kind of valid sequence to
> describe in the DT.

Yes, the power on/power off sequences are part of the board/panel 
specification - they are a hardware description and thus fits within the 
purpose of the device tree IMHO. One could argue that initialization 
sequences are usually coded inside drivers, but that only works when the 
driver has a single initialization sequence to handle. With 
pwm-backlight we try to handle something much more general, and so far 
these sequences were performed by board-specific functions.

All in all, adding timings & ordering is not so different from the 
original patch which accepted one optional regulator and GPIO.

Also, if someone knows of anything else besides PWM/GPIO/regulators that 
may need to be controlled by a backlight power sequence, please let me know.

Alex.
