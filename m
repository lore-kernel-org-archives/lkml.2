Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2BUMkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 07:40:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57294 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab2BUMkF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 07:40:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.179.8 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <20120221110618.GJ22562@n2100.arm.linux.org.uk>
References: <1329719263-18971-1-git-send-email-swarren@nvidia.com>
	<20120220073941.GC22562@n2100.arm.linux.org.uk>
	<CACRpkdbMFN3=XTSg1oE310eTHecrs6XaMz+DCNYJzwOg8JEEiQ@mail.gmail.com>
	<20120221110618.GJ22562@n2100.arm.linux.org.uk>
Date: Tue, 21 Feb 2012 13:40:05 +0100
Message-ID: <CACRpkdYzRu4VPKPgxuttuvSDCpfHjvBGGq1rFEDExv1PsoLG=w@mail.gmail.com>
Subject: Re: [PATCH 1/2] Documentation/gpio.txt: Explain expected pinctrl interaction
From: Linus Walleij <linus.walleij@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Olof Johansson <olof@lixom.net>,
        Colin Cross <ccross@android.com>, linux-doc@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 12:06 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:

>> It's a bit kludgy but works and makes sure the pins are only used
>> for one thing at a time.
>
> No.  The case which I'm thinking of is for the Assabet audio, where
> we have the following situation.

OK... (thanks for the explanation!)

> The solution is to wait for SSP to finish, and while SSP is still enabled,
> switch the pins from the SSP block to the GPIO block and toggle the SFRM
> signal to flip the WS output before removing power.  When starting up,
> with the pins under control of GPIO, power up and them toggle hte SFRM
> signal to restore the WS state before giving it back to the SSP block.
>
> However, here's the thing: SSP must be enabled at the point in time when
> the pins are given or taken away from it, otherwise SFRM is indeterminant.
> We can't allow gpio_request() to fail at the points where we toggle this
> pin - failure is not really an option where causing hardware stress is
> involved.  We can't allow the GPIO block to have the state of these pins
> change state while the pins are given back to the GPIO block before the
> GPIOs have been requested (glitches on the SFRM line will cause the state
> of the FIFO to change.)

This can probably be done, mainly I'd say that control over the pins
need not mean that they are decoupled from some specific hardware, or
that the hardware is disabled or so, the semantics of doing say
pinctrl_get/enable/disable/put aren't set in stone, it's just callbacks into
the device driver so it could avoid doing anything in this case, keep
the pins muxed for the SSP if the transition goes from SSP->GPIO
and back.

However I guess it would be conceptually closer if say the pins could
be used for a device and GPIO at the *same time*.

I had this similar example where a pin on U300 could be in GPIO mode
and "spy" on the peripheral using that pin, by just sampling the value
or triggering on edge transitions.

Since each pin has a pin descriptor, we could solve this by marking
pins as "gpio dualmode", i.e. add some bool dualmode to the
descriptor and augment the core to allow pins with this property to be in
GPIO and "for device X" mode at the same time. So in
pin_request() in pinmux.c we check for this property and allow
dual-mode on a case-by-case basis (assuming this will be pretty rare,
so the default is not to use it).

Of course it assumes the SA1100 being converted to use pin control,
I looked at it a bit and it seems simple enough since the GAFR
register is a single "GPIO or something else"-switch for the GPIOs.
(It'd probably need the SA1100 to be a bit more strict in using
gpiolib in place for the direct assignments though, else the
abstractions get a bit pointless anyway.)

> Another case where this kind of run-time switching needs to occur is the
> PXA IrDA driver, where the pins need to be switched between their FIR and
> SIR modes.

This sounds more mutually exclusive and should be possible to support
with a get/enable/disable/put sequence AFAICT.

Yours,
Linus Walleij
