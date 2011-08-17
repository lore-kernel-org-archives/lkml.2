Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1HQKmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 06:42:35 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab1HQKmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 06:42:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
Date: Wed, 17 Aug 2011 12:42:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Kenneth Heitke <kheitke@codeaurora.org>, sdharia@codeaurora.org,
        David Brown <davidb@codeaurora.org>, bryanh@codeaurora.org,
        linux-arm-msm@vger.kernel.org, rdunlap@xenotime.net,
        rmk+kernel@arm.linux.org.uk, john.stultz@linaro.org,
        akpm@linux-foundation.org, ohad@wizery.com, gregkh@suse.de,
        stefanr@s5r6.in-berlin.de, lethal@linux-sh.org, linville@tuxdriver.com,
        zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org> <1772239.ndMLD9ec3r@wuerfel> <20110817080327.GD13460@opensource.wolfsonmicro.com>
In-Reply-To: <20110817080327.GD13460@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108171242.24918.arnd@arndb.de>
X-Provags-ID: V02:K0:vhq6sl/A2gpKQw5gzXeid4ekMGoArdmsk9Mu5hbHk0H
 MCBm2t82vdW3LtlRZYJf3tuwT8kcJlt1TsrLfMqtwfu7YACD3B
 sIE4A7l7XCrw2WNaTq0/dVIDbzvjbMKhtTdyQu+/i+Hh8V/XBZ
 0Ko9tyXmKAUFq0UCjkciCHgIjiz4XJxWQU46lNusfhg1P5KbY1
 gZFKdxpssIYxjXqn5NnVg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 August 2011, Mark Brown wrote:
> On Wed, Aug 17, 2011 at 09:09:44AM +0200, Arnd Bergmann wrote:
> 
> > * Move the logic for enabling and disabling devices into a host specific
> >   driver that takes care of powering the devices up initially, identifying
> >   them and putting them into run-time PM disabled state when no driver was
> >   found or the device is unused.
> 
> > This will make it possible to reuse the same driver for multiple machines
> > that have the same endpoint devices, while moving all the board specific
> > clock and reset logic into a separate driver, which can be very small in
> > many cases.
> 
> There should be no more need for this with slimbus than there is with
> any of our other buses - this sort of dynamic enable and disable is
> already standard practice for devices in embedded systems.  There's some
> stuff it'd be good to do here but it shouldn't be driver specific, it
> should be a generic device model thing.  The main problem cases right
> now are things like USB which currently assume there's no magic going on
> outside of the bus.

My main point here is not how the enable/disable is handled but how
the bus is probed. It's a bit unfortunate that the initial slimbus
code was modeled after i2c and spi, when it's really more like USB
in the sense that devices can (and should) actually be discovered
using methods provided by the bus spec.

> One thing I've wanted to do for a while but never quite got the time to
> look at yet is to add support for automatically enabling and disabling
> regulators along with the probe, remove, suspend and runtime suspend
> paths.  If there's sufficient hooks for that they should also be usable
> for anything that is suitably board specific.

Yes, that would be nice.

> > I would guess that in many cases, the logic for enabling the devices
> > fits into the slimbus host driver. If that is not the case, e.g. when
> > a lot of machines have the same host controller but each of them uses
> > a different way to get the devices out of reset, you can turn the host
> 
> I'd expect that bringing the device out of reset is going to be largely
> unrelated to the host controller, it's going to be GPIOs, clocks and
> regulators.  The individual drivers are going to want to manage this
> stuff dynamically at runtime too.

But it's even less related to the individual driver than to the host.
Clearly, the code for starting up the device has to live somewhere, but
I think that should not be the device driver that is responsible
for talking to the slimbus device itself, because that each board
will do that slightly differently and the slimbus_driver should not
need to know about the device before it has been found on the bus.

The way I see this working is that something outside of the driver
should provide a way to enable each device in order for it to get
probed, and the driver's ->probe callback does a pm_runtime_get()
call when it wants to keep the device enabled.

	Arnd
