Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab1AXTfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:35:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45347 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521Ab1AXTfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:35:42 -0500
Date: Mon, 24 Jan 2011 19:35:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Colin Cross <ccross@android.com>
Cc: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/28] ARM: tegra: cpufreq: Disable cpufreq during
 suspend
Message-ID: <20110124193539.GI29925@opensource.wolfsonmicro.com>
References: <1295834493-5019-1-git-send-email-ccross@android.com>
 <1295834493-5019-21-git-send-email-ccross@android.com>
 <20110124144142.GA16813@sirena.org.uk>
 <AANLkTikrUdLM8VmW5yCndf927E=drZF1gGBwXq6Dj5mW@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikrUdLM8VmW5yCndf927E=drZF1gGBwXq6Dj5mW@mail.gmail.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 24, 2011 at 10:50:53AM -0800, Colin Cross wrote:
> On Mon, Jan 24, 2011 at 6:41 AM, Mark Brown

> > Hrm, what's the situation where that happens and why does it cause
> > problems?  The regulator API doesn't care if suspend is going on, and
> > nor do any of the current drivers for regulators.  There is an issue
> > with keeping things like I2C alive until the bitter end of suspend so
> > you've got a control bus to the regulators but that's a generic issue
> > which crops up with other subsystems too so a regulator-specific
> > workaround seems dodgy.

> The end result is that the regulator driver calls the i2c driver after
> the i2c driver has been suspended.  On Tegra, this happens because of
> voltage scaling on the CPU regulator, which can be on the i2c bus.  A
> sleep in a suspend handler after the i2c bus has been suspended can
> cause the cpufreq governor to lower the frequency, and try to lower
> the voltage as well.

OK, that's a general problem - you need to ensure that the I2C and SPI
controllers are suspended really late.  The OMAP guys also have this
problem for some RTCs, though in their case things are slightly
different due to their use of runtime PM.  Looking at your I2C driver
(BTW, I'd suggest reminding Ben on a more regular basis about that) I
suspect that moving your suspend and resume callbacks to the _noirq
varaints will cover a lot of this.

> The problem isn't limited to i2c busses, there are some regulators on
> spi busses.  You would need to ensure that any driver that has a

For all practical purposes in this sort of discussion you can typically
do a s/I2C/I2C and SPI/ - in terms of system integration issues they're
very similar.

> regulator consumer suspends before the regulator driver it
> communicates with, and that still wouldn't fix cpufreq, which has a
> sysdev suspend handler.

So you actively need to push the processor into low power mode during
suspend?  I'm still not 100% clear what's triggering the issues you're
seeing and why this seems to be Tegra-only.  If there were a general
cpufreq/regulator interaction here I'd expect to see all ARM cpufreq
drivers needing to do the same thing (and probably some handling of this
in cpufreq core as a result).  If it's not such an issue I'd expect
there's also entertaining suspend ordering issues elsewhere.

Typically this stuff isn't a problem for regulators themselves since if
they're active by the time I2C is off they normally get suspended by
hardware handshakes from the CPU as that enters low power mode - right
now we have no regulators at all in mainline that do anything in
software on suspend.  We can get a long way by just ignoring what
happens to regulators over suspend (there is some work to do here but
it's orthogonal to this sort of issue).
