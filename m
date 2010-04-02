Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab0DBUpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:45:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51205 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754535Ab0DBUpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:45:06 -0400
Date: Fri, 2 Apr 2010 21:45:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
       lm-sensors <lm-sensors@lm-sensors.org>, linux-kernel@vger.kernel.org,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [lm-sensors] regulator: regulator_get behaviour without
	CONFIG_REGULATOR set
Message-ID: <20100402204503.GA15237@opensource.wolfsonmicro.com>
References: <2122967437.461270223106350.JavaMail.root@mail.savoirfairelinux.com> <1779783481.621270223270264.JavaMail.root@mail.savoirfairelinux.com> <20100402160058.GE27613@sirena.org.uk> <20100402184403.2ea1263e@hyperion.delvare> <20100402185138.GA12817@opensource.wolfsonmicro.com> <20100402213010.4a64e50f@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100402213010.4a64e50f@hyperion.delvare>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 02, 2010 at 09:30:10PM +0200, Jean Delvare wrote:
> On Fri, 2 Apr 2010 19:51:38 +0100, Mark Brown wrote:

> > It's zero volts which is a reasonable out of range value for a
> > regulator.  We could change the API to return a signed value but I'm
> > having a hard time summoning the enthusiasm to do that myself.

> Sorry for playing the devil's advocate here, but deciding that 0V is an
> error is pretty arbitrary, and deciding that a negative voltage value
> is an error is just as arbitrary. Just because these are not common
> cases, doesn't mean they can't happen today or tomorrow for very
> specific setups. I'd rather see a more robust way to notifier the
> caller that an error happened.

Yes, you could pass a pointer to the value or similar.  OTOH that'd mean
managing the transition :/

> OK, I get it. This indeed rules out ERR_PTR(-ENODEV). But what about
> NULL? IS_ERR() doesn't catch NULL, so this wouldn't affect the current
> users, as you never dereference the struct regulator pointer in the
> stubs anyway. And at least it would let drivers that need it cleanly
> differentiate between the cases of availability or unavailability of
> the real regulator API. Something like (from the hwmon/sht15 driver):

I'm not sure there's actually much win from this information since we do
have cases with things like functionally limited regulators and error
conditions which mean that drivers end up having to cope with pretty
much all this stuff anyway.  But yes, NULL should be just as good as a
stub.

> looks much better than

> /* If a regulator is available, query what the supply voltage actually is!*/
> 	data->reg = regulator_get(data->dev, "vcc");
> 	if (!IS_ERR(data->reg)) {
> 		int voltage = regulator_get_voltage(data->reg);
> 		if (voltage) {
> 			data->supply_uV = voltage;
> 			regulator_enable(data->reg);
> 			/* setup a notifier block to update this if
> 			 *  another device causes the voltage to change */
> 			data->nb.notifier_call = &sht15_invalidate_voltage;
> 			ret = regulator_register_notifier(data->reg, &data->nb);
> 		}
> 	}

In this case you don't need the if (voltage) check - the code that uses
supply_uV is going to have to cope with it being set to 0 if the driver
doesn't just give up, and the enable wants to happen anyway (perhaps
we've got a switchable supply we can't read the voltage of).  It should
never make any odds if the notifier never gets called since the supply
could be invariant.

> > The expectation is that users which have a strong requirement that the 
> > regulator API does more than this will need to depend on the regulator
> > API in Kconfig or have ifdefs and so never see the stubs though they
> > should still error check since individual operations may fail or not be
> > supported.

> I guess we could have ifdefs in hwmon/sht15, yes. But OTOH it looks
> weird to have a complete stub API for the CONFIG_REGULATOR=n case, and
> still require ifdefs from times to times. This is what make me believe
> the stub API isn't good enough.

The regulator API is kind of odd here in that there's a lot of users
that are able to do things using it but which are largely indifferent to
if they're happening or not since the results are optimisations of
benefit to the system as a whole rather than directly used
functionality.  The stubs are only attempting to cater for them and
don't cater for the other users that do care about what happens.

I agree that it's unusual but don't see any great alternatives that
don't involve things like pushing some stuff for the stub users more
into the core APIs (like how some platforms are integrating their clock
management into the PM framework) and I don't think we're anywhere near
the point where we know enough to say that's a good idea at the minute.

> > Looking again at the stubs we should remove the stubs for at least
> > setting voltages and current limits from the API since they don't
> > currently do the right thing and I can't think of any useful stub
> > behaviour.  The get operations are more useful as stubs since some
> > analogue parts can usefully have their configuration optimised if we
> > know their supply voltages but it's just a nice to have and not a
> > requirement.

> I second that. The stub API should only contain the minimum set of
> functions that is required to keep drivers which don't depend on
> CONFIG_REGULATOR ifdef-free. This will make its intended use case
> clearer.

Actually having thought about that one a bit more I'm not so sure for
set_voltage() - the DVFS style drivers are in a similar position to the
basic power switching ones, they'd like to be able to lower the supplies
to save power but don't actually need that to happen.  Needs a bit more
thought.

There are currently some functions that don't get stubbed, like
regulator_get_exclusive().
