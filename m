Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0DBSvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:51:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58023 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752147Ab0DBSvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:51:40 -0400
Date: Fri, 2 Apr 2010 19:51:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without
	CONFIG_REGULATOR set
Message-ID: <20100402185138.GA12817@opensource.wolfsonmicro.com>
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com> <1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com> <20100402160058.GE27613@sirena.org.uk> <20100402184403.2ea1263e@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402184403.2ea1263e@hyperion.delvare>
X-Cookie: You will outgrow your usefulness.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 06:44:03PM +0200, Jean Delvare wrote:
> On Fri, 2 Apr 2010 17:00:59 +0100, Mark Brown wrote:

> > Right, it's just returning something that won't match IS_ERR().

> Ugly design. You're casting a random pointer to struct regulator * and
> just hope that the user won't make use of it. Right now, you're safe
> because the definition of struct regulator is not public, but assuming
> it will stay that way forever is somewhat risky.

If this changes we can always provide a more complex stub; for now we're
OK.

> I've never seen any API doing things that way, and I can't think of a
> sane reason for doing things that way. It's pretty error-prone.

All we're doing is stubbing out the API so that common case clients
(which just want to switch on and off their supplies) don't need to
either depend on it or include lots of conditional code which could
easily end up masking error conditions.  The stub behaves as always
on fixed voltage regulators which matches what most systems that do
not use the regulator API actually have.

> > You're asking the wrong question here.  The problem here is not that the
> > regulator got stubbed out, the problem is that the sht15 driver is not
> > checking the return value of regulator_get_voltage() and so is trying to
> > use the error code that was returned as a voltage,

> Error code? regulator_get_voltage() returns 0, how is that supposed to
> be an error code?

It's zero volts which is a reasonable out of range value for a
regulator.  We could change the API to return a signed value but I'm
having a hard time summoning the enthusiasm to do that myself.

> > with predictably poor
> > results.  It is this function that the driver needs to check, not
> > regulator_get().

> This goes against the expectations. When I have to get a reference to
> something and then use that something, I expect the former to fail is
> the something is not available for whatever reason. I don't expect to
> have to do the latter to realize that the former did not actually work.

Well, it did work in the sense that there's something there that
satisfies the expectations of many users.  We could change things so
that the consumers passed in a set of requirements for the regulator but
that'd be a bit mroe work and at the minute we're mostly relying on
silly combinations being filtered out at the hardware design stage.

> > There are a range of reasons why an error might be
> > returned when querying the voltage, all of which would cause the same
> > result.

> I don't quite follow you here.

Examples include failure to communicate with the hardware (so we don't
know what state it's in), or hardware that isn't actually doing
sufficient regulation to supply a voltage (many regulators support a
more efficient passthrough mode, and sometimes devices are connected
directly to unregulated supplies for efficiency reasons even if the
system mostly uses regulators).

> > It is not sensible to check the return code of regulator_get() for
> > anything other than IS_ERR().

> Why can't we have the stub form of regulator_get() return NULL or
> ERR_PTR(-ENODEV)? This would be a much friendlier API.

Not really.  The overwhemling majority of users only do simple power
control, they don't need to get or set voltages and are only interested
in allowing the system to save some power when they're idle.  These
drivers don't even need the power to actually get switched off, they
just want to allow that possibility.  If we returned an error then all
these consumers would need to conditionalise all their regulator API
usage and find it hard to distinguish between not having any power and
normal operation without the regulator API.  With the current approach
these drivers can have a single code path which is used unconditionally
and will do the right thing on systems with and without the regulator
API.

The expectation is that users which have a strong requirement that the 
regulator API does more than this will need to depend on the regulator
API in Kconfig or have ifdefs and so never see the stubs though they
should still error check since individual operations may fail or not be
supported.

Looking again at the stubs we should remove the stubs for at least
setting voltages and current limits from the API since they don't
currently do the right thing and I can't think of any useful stub
behaviour.  The get operations are more useful as stubs since some
analogue parts can usefully have their configuration optimised if we
know their supply voltages but it's just a nice to have and not a
requirement.
