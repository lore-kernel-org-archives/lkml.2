Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab1ATTIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 14:08:52 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35300 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab1ATTIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 14:08:51 -0500
Date: Thu, 20 Jan 2011 19:08:22 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Zhao <linuxzsc@gmail.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        linux-sh <linux-sh@vger.kernel.org>,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: Locking in the clk API
Message-ID: <20110120190822.GK6335@n2100.arm.linux.org.uk>
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk> <201101111744.59712.jeremy.kerr@canonical.com> <20110111103929.GN24920@pengutronix.de> <AANLkTinHL9X_bqMPR=W8Va01O4xngUnpGCkCiE3xEdiQ@mail.gmail.com> <4D386ABF.9060908@fluff.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D386ABF.9060908@fluff.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 05:02:55PM +0000, Ben Dooks wrote:
> If you want to make it so that each low-power mode has to work
> out what PLLs need to be disabled and then re-enabled makes me
> want to be sick. Hiding this stuff behind specific implementations
> is a recipe for disaster.

Why should systems which don't suffer from such problems be prevented
from gaining power saving from turning off their clocks when devices
are not being used (eg, the console serial port.)

One solution to your root PLL issue would be to have a separate set of
enable/disable API calls which get called at setup/release time (or
whatever you'd like to call it) which can only be called from non-atomic
context.  Maybe clk_prepare() and clk_unprepare().  These functions
should perform whatever is necessary to ensure that the clock source
is available for use atomically when clk_enable() is called.

So, in your case, clk_prepare() ensures that the root PLL is enabled,
clk_unprepare() allows it to be turned off.

In the case of a console driver, clk_prepare() can be called when we
know the port will be used as a console.  clk_enable() is then called
before writing out the string, and clk_disable() after we've completely
sent the last character.

This allows the best of both worlds.  We now have a clk_enable() which
can be used to turn the clocks off through the clock tree up to the first
non-atomic clock, and we also have a way to deal with those which need
to sleep.  So not only do "sleeping clock" implementations become possible
but these "sleeping clock" implementations also get the opportunity to
shutdown some of their clock tree with minimal latency for doing so.
