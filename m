Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab0DBTaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:30:19 -0400
Received: from bamako.nerim.net ([62.4.17.28]:50519 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab0DBTaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:30:15 -0400
Date: Fri, 2 Apr 2010 21:30:10 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without 
 CONFIG_REGULATOR set
Message-ID: <20100402213010.4a64e50f@hyperion.delvare>
In-Reply-To: <20100402185138.GA12817@opensource.wolfsonmicro.com>
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com>
	<1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com>
	<20100402160058.GE27613@sirena.org.uk>
	<20100402184403.2ea1263e@hyperion.delvare>
	<20100402185138.GA12817@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, 2 Apr 2010 19:51:38 +0100, Mark Brown wrote:
> On Fri, Apr 02, 2010 at 06:44:03PM +0200, Jean Delvare wrote:
> > On Fri, 2 Apr 2010 17:00:59 +0100, Mark Brown wrote:
> 
> > > Right, it's just returning something that won't match IS_ERR().
> 
> > Ugly design. You're casting a random pointer to struct regulator * and
> > just hope that the user won't make use of it. Right now, you're safe
> > because the definition of struct regulator is not public, but assuming
> > it will stay that way forever is somewhat risky.
> 
> If this changes we can always provide a more complex stub; for now we're
> OK.
> 
> > I've never seen any API doing things that way, and I can't think of a
> > sane reason for doing things that way. It's pretty error-prone.
> 
> All we're doing is stubbing out the API so that common case clients
> (which just want to switch on and off their supplies) don't need to
> either depend on it or include lots of conditional code which could
> easily end up masking error conditions.  The stub behaves as always
> on fixed voltage regulators which matches what most systems that do
> not use the regulator API actually have.

OK, I get the idea.

> > > You're asking the wrong question here.  The problem here is not that the
> > > regulator got stubbed out, the problem is that the sht15 driver is not
> > > checking the return value of regulator_get_voltage() and so is trying to
> > > use the error code that was returned as a voltage,
> 
> > Error code? regulator_get_voltage() returns 0, how is that supposed to
> > be an error code?
> 
> It's zero volts which is a reasonable out of range value for a
> regulator.  We could change the API to return a signed value but I'm
> having a hard time summoning the enthusiasm to do that myself.

Sorry for playing the devil's advocate here, but deciding that 0V is an
error is pretty arbitrary, and deciding that a negative voltage value
is an error is just as arbitrary. Just because these are not common
cases, doesn't mean they can't happen today or tomorrow for very
specific setups. I'd rather see a more robust way to notifier the
caller that an error happened.

> > > with predictably poor
> > > results.  It is this function that the driver needs to check, not
> > > regulator_get().
> 
> > This goes against the expectations. When I have to get a reference to
> > something and then use that something, I expect the former to fail is
> > the something is not available for whatever reason. I don't expect to
> > have to do the latter to realize that the former did not actually work.
> 
> Well, it did work in the sense that there's something there that
> satisfies the expectations of many users.  We could change things so
> that the consumers passed in a set of requirements for the regulator but
> that'd be a bit mroe work and at the minute we're mostly relying on
> silly combinations being filtered out at the hardware design stage.
> 
> > > There are a range of reasons why an error might be
> > > returned when querying the voltage, all of which would cause the same
> > > result.
> 
> > I don't quite follow you here.
> 
> Examples include failure to communicate with the hardware (so we don't
> know what state it's in), or hardware that isn't actually doing
> sufficient regulation to supply a voltage (many regulators support a
> more efficient passthrough mode, and sometimes devices are connected
> directly to unregulated supplies for efficiency reasons even if the
> system mostly uses regulators).
> 
> > > It is not sensible to check the return code of regulator_get() for
> > > anything other than IS_ERR().
> 
> > Why can't we have the stub form of regulator_get() return NULL or
> > ERR_PTR(-ENODEV)? This would be a much friendlier API.
> 
> Not really.  The overwhemling majority of users only do simple power
> control, they don't need to get or set voltages and are only interested
> in allowing the system to save some power when they're idle.  These
> drivers don't even need the power to actually get switched off, they
> just want to allow that possibility.  If we returned an error then all
> these consumers would need to conditionalise all their regulator API
> usage and find it hard to distinguish between not having any power and
> normal operation without the regulator API.  With the current approach
> these drivers can have a single code path which is used unconditionally
> and will do the right thing on systems with and without the regulator
> API.

OK, I get it. This indeed rules out ERR_PTR(-ENODEV). But what about
NULL? IS_ERR() doesn't catch NULL, so this wouldn't affect the current
users, as you never dereference the struct regulator pointer in the
stubs anyway. And at least it would let drivers that need it cleanly
differentiate between the cases of availability or unavailability of
the real regulator API. Something like (from the hwmon/sht15 driver):

/* If a regulator is available, query what the supply voltage actually is!*/
	data->reg = regulator_get(data->dev, "vcc");
	if (data->reg && !IS_ERR(data->reg)) {
		data->supply_uV = regulator_get_voltage(data->reg);
		regulator_enable(data->reg);
		/* setup a notifier block to update this if another device
		 *  causes the voltage to change */
		data->nb.notifier_call = &sht15_invalidate_voltage;
		ret = regulator_register_notifier(data->reg, &data->nb);
	}

looks much better than

/* If a regulator is available, query what the supply voltage actually is!*/
	data->reg = regulator_get(data->dev, "vcc");
	if (!IS_ERR(data->reg)) {
		int voltage = regulator_get_voltage(data->reg);
		if (voltage) {
			data->supply_uV = voltage;
			regulator_enable(data->reg);
			/* setup a notifier block to update this if
			 *  another device causes the voltage to change */
			data->nb.notifier_call = &sht15_invalidate_voltage;
			ret = regulator_register_notifier(data->reg, &data->nb);
		}
	}

IMHO. One less level of indentation, and one less intermediate
variable, too. What do you think?

> The expectation is that users which have a strong requirement that the 
> regulator API does more than this will need to depend on the regulator
> API in Kconfig or have ifdefs and so never see the stubs though they
> should still error check since individual operations may fail or not be
> supported.

I guess we could have ifdefs in hwmon/sht15, yes. But OTOH it looks
weird to have a complete stub API for the CONFIG_REGULATOR=n case, and
still require ifdefs from times to times. This is what make me believe
the stub API isn't good enough.

> Looking again at the stubs we should remove the stubs for at least
> setting voltages and current limits from the API since they don't
> currently do the right thing and I can't think of any useful stub
> behaviour.  The get operations are more useful as stubs since some
> analogue parts can usefully have their configuration optimised if we
> know their supply voltages but it's just a nice to have and not a
> requirement.

I second that. The stub API should only contain the minimum set of
functions that is required to keep drivers which don't depend on
CONFIG_REGULATOR ifdef-free. This will make its intended use case
clearer.

Thanks,
-- 
Jean Delvare
