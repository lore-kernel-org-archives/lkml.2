Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2J3OC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 10:02:27 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65170 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab2J3OCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 10:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <20121030113407.GA24335@sirena.org.uk>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121024161429.GA16350@core.coreip.homeip.net>
	<CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
	<4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
	<CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
	<20121030113407.GA24335@sirena.org.uk>
Date: Tue, 30 Oct 2012 15:02:23 +0100
Message-ID: <CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Felipe Balbi <balbi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        Kevin Hilman <khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 12:34 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Sun, Oct 28, 2012 at 09:12:52PM +0100, Linus Walleij wrote:

>> Moving this handling to bus code or anywhere else
>> invariably implies that resource acquisition/release order
>> does not matter, and my point is that it does.
>
> Doing this in the buses is definitely wrong, as you say it's not bus
> specific.  I do however think we can usefully do this stuff in a SoC
> specific place like a power domain, keeping the SoC integration code
> together and out of the drivers.  IME the SoCs where you need to do
> different things for different IPs shoudl mostly still get some reuse
> out of such an approach.

Talking to Kevin Hilman today he was also stressing that
power domains is a good thing for handling resources, especially
when replacing prior hacks in the custom clk code. However
he pointed specifically to clocks and voltages, which may
be true.

What worries me is when knowledge of the hardware which
is traditionally a concern for the device driver start to
bubble up to the power domain (or better renamed resource
domain if use like this, as Felipe points out).

I worry that we will end up with power/resource domain
code that start to look like this:

suspend()
switch (device.id) {
case DEV_FOO:
  clk_disable();
  pinctrl_set_state();
  power_domain_off();
case DEV_BAR:
  pinctrl_set_state();
  clk_disable();
  // Always-on domain
case DEV_BAZ:
  pinctrl_set_state();
  clk_disable();
  power_domain_off();
case ...

Mutate the above with silicon errata, specific tweaks etc that
Felipe was mentioning.

What is happening is that device-specific behaviour which
traditionally handled in the driver is now inside the
power/resource domain.

I agree that if the domain was doing the same thing for each
piece of hardware, this would be the right thing to do,
and I think the in-kernel examples are all "simple",
e.g. arch/arm/mach-omap2/powerdomain* is all about
power domains and nothing else, and the notifiers used
by SHmobile is all about clock gating and nothing else.

Another effect is that moving all resource handling to
power domains is that if we do that for a widely shared
device driver like the PL011 that mandates that power
domains need to be implemented for U300, Ux500,
Nomadik, SPEAr 13xx, 3xx, 6xx, Versatile, Versatile
Express, Integrator (AP & CP) and BCM2835. Probably
more.

None of which has power domains (upstream) as
of today. Some of which (U300, Ux500, Nomadik,
SPEAr, Integrator, BCM2835) implement pin control.

Basically power (resource) domains have the side-effect
of in this light not doing one thing (power domains) but
instead imposing all-or-nothing imperialistic characteristics.

While avoiding a set of distributed, optional pinctrl hooks,
it mandates a central piece of upfront powerdomain
boilerplate to be present in each and every platform that
wants to control its pins.

I think the lesser of two evils is the distributed approach,
and then I'm talking about pinctrl only, disregarding the
fact that clocks and power domains are basically subject to
the same kind of argument. I still buy into the concept of
using power domains for exactly power domains only.
Arguably this is an elegance opinion...

I worry that the per-SoC power domain implementation
which will live in arch/arm/mach-* as of today will become
the new board file problem, overburdening the arch/* tree.
Maybe I'm mistaken as to the size of these things,
but just doing ls arch/arm/mach-omap2/powerdomain*
makes me start worrying.

Yours,
Linus Walleij
