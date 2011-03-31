Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902Ab1CaGzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:55:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9550 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769Ab1CaGzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:55:06 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6301"; a="83104986"
From: David Brown <davidb@codeaurora.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Gatliff <bgat@billgatliff.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-Reply-To: <AANLkTi=fSUizM38SkBhPAzSbArgoNQxbV8JrC51x_RDf@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 30 Mar 2011 20:24:30 -0700")
References: <20110317183048.GW7258@atomide.com>
	<AANLkTimWbb5DWiiCW821H6pRicbk1fS3PYcnGyUMznvM@mail.gmail.com>
	<20110318101512.GA15375@n2100.arm.linux.org.uk>
	<201103301906.42429.arnd@arndb.de>
	<AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
	<20110331001502.GB6680@n2100.arm.linux.org.uk>
	<AANLkTinE7EDbV8hrYZWBxgvwOxdPMLoS0Y57PSm04rvM@mail.gmail.com>
	<AANLkTik-BFTzyPLuYVdhCJPocc0wPY0rKvO7BQS4Fg1S@mail.gmail.com>
	<AANLkTikd_JRxmB_OWZqq178=K3bnxhdDqcNbgFNRtTyU@mail.gmail.com>
	<AANLkTimS_8BnBz9MSdxYJVL6oreEpH=W61BsyuX2G+Xz@mail.gmail.com>
	<AANLkTimtO7vR2AQvJj1hHMqHCDqtoiJX_eENE9o3dPpV@mail.gmail.com>
	<AANLkTimPJCiaUyTfcR1NSPivJ2YjSwazhiWRC-CPLy6J@mail.gmail.com>
	<AANLkTi=fSUizM38SkBhPAzSbArgoNQxbV8JrC51x_RDf@mail.gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Wed, 30 Mar 2011 23:56:15 -0700
Message-ID: <8yaipuzrd68.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30 2011, Linus Torvalds wrote:

> And most GPIO drivers I've ever seen are actually basically "turn this
> bit on or off in this register to turn it into an Input or Output"
> along with "read/write this other bit to actually see/set the value".
> Repeat that for 'nr' bits, where 'nr' is just some small value,
> usually in single digits.

A few hundred is more typical.

At least with the MSMs, it's even messier.  The chip has a moderate
number of pins, and a large number of peripherals, more than can
actually be connected to these pins at a time.  Multiple devices, and a
general GPIO are frequently muxed.  This has to be configured, in
addition to input or output.  Even for just GPIO, there may be multiple
types of pullups, drive strengths.  Different devices will need
different configurations to handle low power, etc.

Of the 145 files with 'gpio' in the name, 50 or so of them seem to
actually be GPIO drivers.  At least of the more common platforms, these
are quite different, and seem to deal with fairly complex devices.  Many
at least use the gpiolib.

The rest of the files seem to be more concerned with what the different
GPIOs are connected to.  This seems like the place to focus on
generalizing.  Maybe device tree.

> Now, not all of them are that, by all means, and the details are often
> slightly different. Sometimes the read register is the same as the
> write register, sometimes it isn't. Sometimes you have a "clear
> register" and a "set register" instead of a register you write the
> value to. And I haven't checked what those 145 files do, but I bet a
> _lot_ of them could be described by having a single generic gpio
> driver, and then just using devicetree to give that common driver a
> few values to describe where the IO ports are, which bits they are,
> and which type of gpio it is.

If we can come up with a general way to describe the diverse things a
GPIO can be used for.  Even something like drive strength can have
widely differing possibilities, and may need different settings for low
power modes (which means it can't just be the boot loader setting it).

> And then when you have another ARM SoC, instead of writing yet another
> mindless board driver for the gpio's on it, just add the <nr> entries
> for the GPIO's to the device tree. NOT A SINGLE LINE OF CODE.

Agree, at least in theory.

> Yes, yes, there are always exceptions. Many GPIO's are actually behind
> some i2c bus or something. Others can do pulsing or are just generally
> more complex than an array of single bits. So I'm sure we couldn't
> replace all those 145 gpio files under arch/arm with a single driver
> and some devicetree entries, but maybe half of them match the simple
> pattern. I bet the SoC case it's more than half, it would be silly to
> do i2c on an SoC. But I dunno. I really didn't look.

At least one MSM has GPIOs behind i2c.  Too many pins, otherwise.

> PowerPC does exactly the above, btw. So I'm not just talking about
> some magical theoretical thing. I seriously think every ARM person who
> has ever written any of those "gpio" files should look at powerpc.
> Now, I suspect that most powerpc SoC's tend to share more IP blocks
> than the crazy ARM situation, but even so, please just check it out.
> Check out the device tree files (*.dts) and do that same
>
>    git ls-files arch/arm/ | grep gpio
>
> except do it on powerpc.
>
> See the difference?

Yeah, powerpc doesn't seem to have as complex of a use of gpios.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
