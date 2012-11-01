Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268Ab2KAI4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 04:56:53 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:63802 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2KAI4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 04:56:50 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
References: <1350911580-20307-1-git-send-email-sourav.poddar@ti.com>
	<20121024161429.GA16350@core.coreip.homeip.net>
	<CACRpkdai3NocZQnW6YRF+k6GXUSx3P_Ge=F-tkuivrFm6tBbLg@mail.gmail.com>
	<4099134.xWUIfbbahk@dtor-d630.eng.vmware.com>
	<CACRpkdaiLXVeUg1quuw3XPTenbKOjn+aWbGQezpcyvzQCtCWow@mail.gmail.com>
	<20121030113407.GA24335@sirena.org.uk>
	<CACRpkdapQJY0aoam741O0fb8EeM9BLk_Psq5TaPG84J7wEvCLw@mail.gmail.com>
	<87obji8kta.fsf@deeprootsystems.com>
	<CACRpkdbCk9+HSBPtfT-1dO8paSRYJ5VXX_0SxiyxgrObnJEvmQ@mail.gmail.com>
Date: Thu, 1 Nov 2012 09:56:48 +0100
Message-ID: <CACRpkdaBmg7wtX0WsaxMw=n1sKDN5YphK=y8tzAx_CF=JnUqvw@mail.gmail.com>
Subject: Fwd: [PATCHv2] Input: omap4-keypad: Add pinctrl support
From: Linus Walleij <linus.walleij@linaro.org>
To: Kevin Hilman <khilman@deeprootsystems.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Felipe Balbi <balbi@ti.com>, Benoit Cousson <b-cousson@ti.com>,
        Sourav Poddar <sourav.poddar@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 9:10 PM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:

> Linus Walleij <linus.walleij@linaro.org> writes:


>
> > piece of hardware, this would be the right thing to do,
> > and I think the in-kernel examples are all "simple",
> > e.g. arch/arm/mach-omap2/powerdomain* is all about
> > power domains and nothing else,
>
> FYI... that code isn't the same as PM domain.


This sort of points to a core problem here. Our terminologies are
ambiguous that we cannot understand each others code. As long
as <linux/pm_domain.h> begins:

/*
 * pm_domain.h - Definitions and headers related to device power domains.
 *

But arguably that should just be patched (I think there are a few
remnants in the code still implying that these things are only about
power).

>
>  That code is for the
> *hardware* powerdomains, not the software concept of "PM domain."  In
> OMAP, PM domain is implmented at the omap_device level.  And omap_device
> is the abstraction of an IP block that knows about all the PM related
> register settings, clocks, HW powerdomain, voltage domain, PM related
> pin-muxing etc. etc.    All of these things are abstracted in an
> omap_device, so that the PM domain implementation for OMAP looks rather
> simple (c.f. omap_device_pm_domain in arch/arm/plat-omap/omap_device.c.)


OK following now...

>
> > I think the lesser of two evils is the distributed approach,
>
> The pinctrl examples I've seen mentioned so far are all PM related
>
> (sleep, idle, wakeup, etc.) so to me I think they still belong in
> PM domains (and that's how we handle the PM related pins in OMAP.)


Well, the pinctrl grabbers in these drivers are using these states also
for platforms that do not even select CONFIG_PM.  For example
mach-nomadik is quite happy that the PL011 driver is thusly
muxing in its pins. And would require refactoring to use PM
domains.

So basically this requirement comes down to:

- When dealing with a SoC IP block driver

- That need to multiplex pins

- Then your SoC must select CONFIG_PM and
  CONFIG_PM_RUNTIME and
  CONFIG_PM_GENERIC_DOMAINS and implement
  proper domain handling hooks.

Is this correct? And for Mark, Dmitry, does this correspond to
your view?

It's actually something that needs to be acknowledged by the
ARM SoC maintainers, because they will be the ones telling
all subarch maintainers to go implement full PM handling
with these three frameworks whenever an SoC driver want
to handle pins.

Bascially all subsystem maintainers dealing with embedded
SoCs need to be aligned on this as well...

And IIUC not only pins but also silicon block clocks?

I can surely fix these for "my" systems, but it really needs
to be enforced widely or it will be a mess.

>
> > I worry that the per-SoC power domain implementation
> > which will live in arch/arm/mach-* as of today will become
> > the new board file problem, overburdening the arch/* tree.
> > Maybe I'm mistaken as to the size of these things,
> > but just doing ls arch/arm/mach-omap2/powerdomain*
> > makes me start worrying.
>
> Yes, I agree that this means more code/data in arch/arm/mach-*, but
> IMO, that's really where it belongs.  It really is SoC integration
> details, and driver should really not know about it.


OK we need feedback from ARM SoC on this.

Yours,
Linus Walleij
