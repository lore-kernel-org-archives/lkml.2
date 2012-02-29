Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594Ab2B2MqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:46:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932430Ab2B2MqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:46:09 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: RFC: what do we do with system controllers?
Date: Wed, 29 Feb 2012 12:45:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Paul Walmsley <paul@pwsan.com>, linux-arm-kernel@lists.infradead.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Mattias NILSSON <mattias.i.nilsson@stericsson.com>,
        Rickard ANDERSSON <rickard.andersson@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
References: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com>
In-Reply-To: <CACRpkdY1W-RGE0JL4Sx5UcPY-EGieu8vo7H0fp9xyXtegpaaKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202291245.54038.arnd@arndb.de>
X-Provags-ID: V02:K0:i03dkmFzJiW2ergdXmDmMy8lQhDVhPuLziDfLbyhd3O
 v4+FQ6gbfiUZPQUNImBOkPf4A5ZiWjZvkC5fMGSZoeaINqpkes
 5ggWTVvJ7kk0OZgnokk1BFxlPPHcagWYk1gMHPusEiSk2f4XWR
 z4OI/OAE4mSDYQdsprjDkP4l1ctiHYWlHHIL8RUP1zEmFlL2Mq
 CZ+wXWaHBrpNLA6wN7QnCySudJAPKm1QCrSPLrHj7UC+8ihZWm
 vuy0efCR+xe1lqGaj1k4b7zfGGhgkN6VuFBLXvUV1hPmrivKqF
 tTgFza1eEH4/7FcdC7+RAPGcadSucFLxEL+gllJ9xfaApjloT5
 KswwhwK2LSCTATniMDNM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 February 2012, Linus Walleij wrote:

> 
> * Reset or shut down the system
> * Reset individual ASIC blocks
> * Control some core voltage domains
> * Control system frequency
> * Select clocking of indvidual ASIC IP blocks:
> * Provide some versioning numbers for the entire system
> * Enable and reset external buses such as PCI
> * (De)protect flash memory
> * Provide a communication channel to another control unit
> * Set some clock divisors for misc units
> * LEDs, GPIO etc communication channel
> * USB transciever control:
> * Get OTP (one-time-programmable) bits:
> * Set up DDR control registers:
> * Pin control:

Nice list, thanks for putting that together.

> The current way to split this problem is to:
> 
> - Push each subfunctionality into a specialized subsystem
>   PLL and clocks to drivers/clk using the new framework
>   RealSoonNow for example, pin control we have in place
>   regulators can handle domain switches...
> 
> - Put in place an arbitration hub-like mechanism using MFD

Right.

> This can be done in two ways:
> 
> - Permanently map the register range and let subdrivers
>   poke directly into the registers they're interested in.
> 
> - Map the register range in a hub driver (often MFD) and
>   write accessor functions for all subfunctionality.

Generally, I would always prefer the second of these ways,
because it allows one to keep the necessary locking local to
the implementation of the system controller driver.

> As far as the drivers are small and nice the heterogeneous
> character of these device register ranges are not much
> of a problem. Some will argue to not fix what ain't broken
> and not move these out of arch/arm/* at all.

That argument certainly has its merits, after all the way that
the system controller works is one of the central aspects
of a platform/subarchitecture.

> What we need to discuss is if this is how we go about
> taking care of these devices going forward - what shall be
> the preferred design pattern?
> 
> My current assumption is that we need to get these things
> out of arch/arm/* and into proper subsystems, using
> drivers/mfd/* as an arbitration point. However I am not
> sure that everyone really agrees on this. Right now it's
> more a modus operandi and following what someone else
> does than a conscious decision to do this.
> 
> We have discussed creating drivers/scm/* (system controller
> modules) but I'm pretty unsure of what the definition of
> such creatures would be, and the border toward MFD
> would be pretty blurred.

Agreed.

> x86 have conveniently put some of their equivalents under
> drivers/platform/x86 but if I understood Arnd correctly
> creating drivers/platform/arm would break the intentions
> of that directory.

The problem I have with using drivers/platform for this is that
it encourages grouping of drivers by their host-side connection
rather than by their functionality. We're moving away from
that model in most other places in the kernel, and we should
try to discourage it for new code. The drivers/platform/x86
directory contains stuff like rfkill, input, backlight, etc
drivers, all of which have (or should have) other places for
them to live in already.

I don't mind having a new location for system controllers
outside of (or below) drivers/mfd, but I would try to avoid
naming it "platform" because I fear that leads people to stuff
all sorts of drivers in there because they happen to be
implemented as 'platform_driver'.

	Arnd
