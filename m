Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab2DARWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 13:22:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52233 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2DARWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 13:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <1333294181-27653-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333294181-27653-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Sun, 1 Apr 2012 19:22:46 +0200
Message-ID: <CACRpkdb6+2SLm1Ojw2jNkK9ejW66fw2Pcit-b3AL67wP4Hr_ow@mail.gmail.com>
Subject: Re: [PATCH/RFC] ARM: amba: Remove AMBA level regulator support
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 5:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> The AMBA bus regulator support is being used to model on/off switches
> for power domains which isn't terribly idiomatic for modern kernels with
> the generic power domain code and creates integration problems on platforms
> which don't use regulators for their power domains as it's hard to tell
> the difference between a regulator that is needed but failed to be provided
> and one that isn't supposed to be there (though DT does make that easier).
>
> Platforms that wish to use the regulator API to manage their power domains
> can indirect via the power domain interface.

I don't see how this solves the problem of AMBA PrimeCell probing.

If you look at the code in bus.c, you can see that it acquires and
enables the regulator - as it does with the clock.

The reason is that is does this *before* the device can probe,
since it needs to map up the memory to read out some magic
values at the end to figure out what device it is in the first place.

We need the current code replaced with something that
enables a power domain before probe instead, then implement
these power domains for the in-kernel AMBA devices that need it.

Is the default behaviour of power domains such that they will
be enabled as soon as devices are registered but before
any buses probe()? Because that is what is needed in this case.

(AMBA devices are special in this way: no other ARM things
support auto-detection of devices using magic numbers,
basically the DT stuff came about because noone was using
a thing like this.)

> The impact should be minimal since currently there are no mainline
> systems which actually provide a vcore regulator so none need updating.

Oh yes there are:
drivers/mfd/db8500-prcmu.c

This driver registers a number of voltage domain regulators,
among those:

static struct regulator_consumer_supply db8500_vape_consumers[] = {
       (...)
        REGULATOR_SUPPLY("vcore", "sdi0"),
        REGULATOR_SUPPLY("vcore", "sdi1"),
        REGULATOR_SUPPLY("vcore", "sdi2"),
        REGULATOR_SUPPLY("vcore", "sdi3"),
        REGULATOR_SUPPLY("vcore", "sdi4"),
        (...)
        REGULATOR_SUPPLY("vcore", "uart0"),
        REGULATOR_SUPPLY("vcore", "uart1"),
        REGULATOR_SUPPLY("vcore", "uart2"),

(I know the supplies should probably be moved up to the
platform but there they are.) The first array is MMC controllers
and the second is a number of UARTs.

IIRC the machine will not boot (i.e. these drivers cannot even
probe) without these regulators in place, so they get enabled by
the AMBA bus code.

So we need something that not just removes stuff from the
AMBA bus, but also adds a better power domain mechanism
and fixes up taking the above regulators.

That said I'm all for replacing it - but I'd need to figure out the
details on how to do that.

We do have code for ux500 power domains. If it will will be
enough to handle this I can try to hack it up and submit it.

Yours,
Linus Walleij
