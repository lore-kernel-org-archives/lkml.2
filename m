Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686Ab2JaUKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 16:10:20 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43708 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760350Ab2JaUKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 16:10:17 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCHv2] Input: omap4-keypad: Add pinctrl support
Organization: Deep Root Systems, LLC
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121024161429.GA16350@core.coreip.homeip.net>
	<CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
	<4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
	<CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
	<20121030113407.GA24335@sirena.org.uk>
	<CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
Date: Wed, 31 Oct 2012 21:10:09 +0100
In-Reply-To: <CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
	(Linus Walleij's message of "Tue, 30 Oct 2012 15:02:23 +0100")
Message-ID: <87obji8kta.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij <linus.walleij@linaro.org> writes:

> On Tue, Oct 30, 2012 at 12:34 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
>> On Sun, Oct 28, 2012 at 09:12:52PM +0100, Linus Walleij wrote:
>
>>> Moving this handling to bus code or anywhere else
>>> invariably implies that resource acquisition/release order
>>> does not matter, and my point is that it does.
>>
>> Doing this in the buses is definitely wrong, as you say it's not bus
>> specific.  I do however think we can usefully do this stuff in a SoC
>> specific place like a power domain, keeping the SoC integration code
>> together and out of the drivers.  IME the SoCs where you need to do
>> different things for different IPs shoudl mostly still get some reuse
>> out of such an approach.
>
> Talking to Kevin Hilman today he was also stressing that
> power domains is a good thing for handling resources, especially
> when replacing prior hacks in the custom clk code. However
> he pointed specifically to clocks and voltages, which may
> be true.
>
> What worries me is when knowledge of the hardware which
> is traditionally a concern for the device driver start to
> bubble up to the power domain (or better renamed resource
> domain if use like this, as Felipe points out).
>
> I worry that we will end up with power/resource domain
> code that start to look like this:
>
> suspend()
> switch (device.id) {
> case DEV_FOO:
>   clk_disable();
>   pinctrl_set_state();
>   power_domain_off();
> case DEV_BAR:
>   pinctrl_set_state();
>   clk_disable();
>   // Always-on domain
> case DEV_BAZ:
>   pinctrl_set_state();
>   clk_disable();
>   power_domain_off();
> case ...
>
> Mutate the above with silicon errata, specific tweaks etc that
> Felipe was mentioning.


like this, as well as a bunch more.  This is why we have a generic
description of IP blocks (omap_hwmod) which abstracts all of these
differences and keeps the PM domain layer rather simple.

I agree with Mark.  Either you have to take care of this with
conditional code in the driver, and the drivers become bloated with a
mess of SoC integration details, or you hide it away in SoC-specific
code that can handle this, and keep the drivers portable. 

Now that we have PM domains (PM domains didn't exist when we created
omap_device/omap_hwmod), I suspect the cleanest way to do this is to
create separate PM domains for each "class" of devices that have
different set of behavior.

> What is happening is that device-specific behaviour which
> traditionally handled in the driver is now inside the
> power/resource domain.
>
> piece of hardware, this would be the right thing to do,
> and I think the in-kernel examples are all "simple",
> e.g. arch/arm/mach-omap2/powerdomain* is all about
> power domains and nothing else, 

FYI... that code isn't the same as PM domain.  That code is for the
*hardware* powerdomains, not the software concept of "PM domain."  In
OMAP, PM domain is implmented at the omap_device level.  And omap_device
is the abstraction of an IP block that knows about all the PM related
register settings, clocks, HW powerdomain, voltage domain, PM related
pin-muxing etc. etc.    All of these things are abstracted in an
omap_device, so that the PM domain implementation for OMAP looks rather
simple (c.f. omap_device_pm_domain in arch/arm/plat-omap/omap_device.c.)

Note that the callbacks just call omap_device_enable(),
omap_device_disable() and all the HW ugliness, SoC-specific integration
mess is hidden away.

[...]

> I think the lesser of two evils is the distributed approach,
> and then I'm talking about pinctrl only, disregarding the
> fact that clocks and power domains are basically subject to
> the same kind of argument. I still buy into the concept of
> using power domains for exactly power domains only.
> Arguably this is an elegance opinion...

The pinctrl examples I've seen mentioned so far are all PM related
(sleep, idle, wakeup, etc.) so to me I think they still belong in
PM domains (and that's how we handle the PM related pins in OMAP.)

> I worry that the per-SoC power domain implementation
> which will live in arch/arm/mach-* as of today will become
> the new board file problem, overburdening the arch/* tree.
> Maybe I'm mistaken as to the size of these things,
> but just doing ls arch/arm/mach-omap2/powerdomain*
> makes me start worrying.

Yes, I agree that this means more code/data in arch/arm/mach-*, but
IMO, that's really where it belongs.  It really is SoC integration
details, and driver should really not know about it.

Kevin
