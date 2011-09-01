Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab1IALaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:30:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49567 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab1IALaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:30:52 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF04B3279BEB@HQMAIL01.nvidia.com>
References: <1314315824-9687-1-git-send-email-swarren@nvidia.com>
	<1314315824-9687-11-git-send-email-swarren@nvidia.com>
	<CACRpkdaTiWEtgjVOhUKeXhpiESvrWyz97p5j_PHe3MvEM4UaCw@mail.gmail.com>
	<74CDBE0F657A3D45AFBB94109FB122FF04B3279BEB@HQMAIL01.nvidia.com>
Date: Thu, 1 Sep 2011 13:30:51 +0200
Message-ID: <CACRpkdaEQaM31SkuSEOzkA8neyF21CcDOc1yQQc3NqOXVSmB=g@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] of: add a generic pinmux helper
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Colin Cross <ccross@android.com>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        Jamie Iles <jamie@jamieiles.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 11:46 PM, Stephen Warren <swarren@nvidia.com> wrote:

>> > +EXPORT_SYMBOL_GPL(of_pinmux_parse);
>>
>> Renamed of_pinctrl_parse I'm happier with it.
>
> Well, it's not just that; the struct contains the function field to
> select for each pingroup, so it's not just pinctrl either.

OK as of my thinking in the v6 pin control patch set groups
are an abstract concept that is part of pin control and pin
definitions (does not need to be used for muxing, could be
anything you want to do with pins) so that sorts it out I guess?

So in line with that terminology I think this should be
named pinctrl.

>> The current pinctrl patch set would probably want an unsigned
>> "position" attribute too. (If we should build on that.)
>
> This does beg the question I asked previously:
>
> The intent of this patch was to provide a way for devicetree to set the
> complete initial state of the pinmux, in a SoC-specific fashion, without
> interaction with the pinmux API.
>
> However, I'm guessing you see the pinmux driver as not touching HW at
> boot at all, and never programming anything except in response to a
> driver calling pinmux_get()/pinmux_enable()?

Since the pin control driver is (supposedly) the only driver that knows
about the register range dealing with muxing, all kind of fiddling
with these registers that are *necessary* on boot (e.g. to get the
thing up in a known state) need to be in the pincontrol driver.

So it may touch hardware on boot, i.e. write default values,
even though one may argue that the boot loader should have
taken care about such things, it's now always the case in
practice.

> In the former case, this code and related bindings wouldn't be influenced
> by the pinmux API at all (and indeed arguably never should be, since DT
> is supposed to be oriented purely at HW, and not influenced by driver
> design). This approach might make the pinmux API mostly relevant only
> for drivers that actively change between configurations at run-time, and
> not for drivers that don't need dynamic muxing.

Platforms that do not need dynamic muxing should be using it
if they need to configure default states of the pins at boot I think.

> However, in the latter case, this code should be part of the pinmux core,
> and my patches to Tegra's pinmux driver dropped. It'd be difficult to
> define a pinmux binding that wasn't influenced by the pinmux API's needs
> in this case.

Well that depends on what you want to do.

The patch subject seems to suggest that all SoCs should use this,
not just the Tegra driver. If it had the subject "of: add a tegra
pinmux helper" and functions named of_tegra_pinmux_parse() and
so on I wouldn't have any objections whatsoever.

If however you want to create a DT binding that should be used by
anyone (as indicated by the subject) it must use abstract concepts of
some kind and then I have opinions on how to name things and
some idea that I'd like them to correspond to what the pin control
subsystem will call things.

For example not call things dealing with biasing as part of
something called "pinmux", since in the pin controller
subsystem I'm envisioning I'm striving to separation of
concerns to the point where biasing and muxing are
completely orthogonal concepts, though they might be
using the same abstract concept of pin groups...

I don't know if I'm getting across properly, I'm trying
my best.

Thanks,
Linus Walleij
