Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759510Ab1CaXoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 19:44:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34784 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751809Ab1CaXn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 19:43:59 -0400
Date: Fri, 1 Apr 2011 08:44:02 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: pm8921-regulator: Add regulator driver
 for PM8921
Message-ID: <20110331234359.GD21726@opensource.wolfsonmicro.com>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
 <1301523432-6017-1-git-send-email-collinsd@codeaurora.org>
 <20110330234613.GA21487@opensource.wolfsonmicro.com>
 <4D93DAD2.5080501@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D93DAD2.5080501@codeaurora.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 06:37:22PM -0700, David Collins wrote:
> On 03/30/11 16:46, Mark Brown wrote:

> > Don't do this.  There's two problems with it.  One is that you're
> > abusing a standard API for an unrelated purpose which will confuse
> > anything that tries to use the API as normal, the other is that this
> > sounds like a fairly widely supported feature (although normally one
> > that is used with a GPIO on the CPU, there's a few examples of this in
> > mainline).

> Could you point out an example of a better way to handle pin control?  I
> agree that regulator_set_mode is not the way to do it.  Could some new
> regulator framework API be created to handle it?  I'm not sure about the
> best way to generalize the interface.

The wm831x DCDCs and several of the Maxim PMICs have GPIO based control,
though as indicated it's currently set up for CPU control rather than
for control from an external device.  In the case of the wm831x this
could be switched to and from hardware control at runtime though that's
not a feature that's currently used.  There's also some devices which
have seperate controls for different users that do contention control in
hardware.

Without actually knowing what the pin control implementation you have
does and how it's used it's hard to suggest something specific.  I
still don't have a good handle on what is voting, what is actually being
controlled or how it interacts with software control by Linux.  We've
jumped to discussion of the implementation without understanding the
problem.  Could you perhaps go back to square one and explain what
exactly you mean when you say "pin control"?

> >> REGULATOR_MODE_NORMAL  - remove a vote for pin control
> >> REGULATOR_MODE_IDLE    - vote for pin control (ref-counted)

> > What is the voting that's been referred to here?

> Voting here means calling regulator_set_mode(reg, REGULATOR_MODE_IDLE).
> These calls into the pm8921-regulator driver set_mode call back function
> are ref-counted to decide when to actually set pin control mode.

OK, that's definitely not going to work well with set_mode() - it relies
on nothing except drivers that know about your reference counting scheme
ever calling set_mode() and the core code never learning how to do
things like suppress duplicate sets.

> > I know some devices do follow this pattern but it's simpler to just
> > register the regulators that are physically present on the device
> > unconditionally.

> Regulator registration needs to continue being based on which regulators
> are configured via the board file platform data because there will be need
> in our system in the near future to use a different (shared) regulator
> driver to access some of the same physical regulators.

> We consider this to be the native PMIC 8921 regulator driver because it
> accesses the PMIC directly.  There will be a subsequent PMIC 8921
> regulator driver which issues requests to a separate processor which
> aggregates our requests with those of other SOC processors.

That's not an issue - the regulator API won't write to the regulators
unless the machine driver explicitly tells it that this is OK so all
that will happen is that we'll be able to read back the state of the
regulators directly.  If your driver is modifying the state of the
regulators without the API telling it to then we should fix that as the
no-write behaviour is an important safety feature.

> > This needs locking if any registers are shared between multiple
> > regulators.

> There are no registers shared between multiple regulators.  The mutex
> locks held inside of the regulator framework should be sufficient.

OK, a comment would help - this is a very common error in regulator
drivers as many regulators put all the enable bits for the system in a
single register.

> >> +	if (min_uV < PLDO_LOW_UV_MIN || min_uV > PLDO_HIGH_UV_MAX) {
> >> +		vreg_err(vreg, "requested voltage %d is outside of allowed "
> >> +				"range.\n", min_uV);

> > Don't split text over multiple lines, it's not helpful when grepping.

> I can change this, I'll just have to be ready to ignore checkpatch.pl errors.

checkpatch isn't always right on style issues.  In this particular case
having the string on a line by itself will probably avoid the issue.

> >> +	/* Round down for set points in the gaps between bands. */
> >> +	if (uV > FTSMPS_BAND1_UV_MAX && uV < FTSMPS_BAND2_UV_MIN)
> >> +		uV = FTSMPS_BAND1_UV_MAX;
> >> +	else if (uV > FTSMPS_BAND2_UV_MAX
> >> +			&& uV < FTSMPS_BAND3_UV_SETPOINT_MIN)
> >> +		uV = FTSMPS_BAND2_UV_MAX;

> > That seems broken - it means you'll go under voltage on what was
> > requested.  You should ensure that you're always within the requested
> > range so if the higher band minimum is in the range you should select
> > that, otherwise you should error out.

> This rounding is done to ensure that the calculations below always yield a
> register program voltage that is valid.  I could change this to pick the
> minimum of the higher band instead.

Note the thing about rechecking against the bounds - you need to look at
*both* limits.

> In this example, consider the second condition which is checking for
> min_uV in the range (1400000, 1500000).  What should the correct result be
> if a consumer calls regulator_set_voltage(reg, 1450000, 1450000) (assuming
> that it is the only consumer so far and that the constraints step for the
> regulator allow the value)?  As the driver is written, it would set the
> voltage to 1.4V.  However, I think that 1.5V is more reasonable.
> Returning an error for this seems counter productive.

The driver should return an error.  If the consumer wanted exactly 1.45V
then that's what the system should deliver, if the consumer is happy
with other voltages then it should say so.  The specification by range
is there because some consumers are sensitive to particular voltages and
need to get what they asked for, or they may have much more flexibility
in one direction or the other (like DVFS where it's usually no problem
to be overvoltage but being undervoltage will usually fail).  By
allowing the consumer to specify a range we allow the consumer to
control this, having the API or the drivers take guesses on behalf of
the consumer means it's hard for a consumer driver to reliably
interoperate with different regulators.

The API provides a mechanism for enumerating the set of supported
voltages (which IIRC you're not implementing - you should) which
consumers can use to ensure good interoperation.

> > This function is just a switch statement per regulator, may aswell expan
> > ithere.  Or restructure things so that you've got a driver per regulator
> > type - that would also mean you'd be able to get the device IDs to
> > correspond to the regulator numbers which would probably be clearer.

> I separated out the type specific init functions because they are
> relatively lengthy and independent.  Wouldn't putting that code directly
> into a switch statement in the probe function be hard to follow?

Right, but the _init() function is basically just a switch statement
which calls these functions AFAIR - inlining the switch statement
doesn't mean inlining the functions too.
