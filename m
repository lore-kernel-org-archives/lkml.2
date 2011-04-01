Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1DAX2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:28:46 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63204 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab1DAX2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:28:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6303"; a="83330746"
Message-ID: <4D965F9D.3060907@codeaurora.org>
Date: Fri, 01 Apr 2011 16:28:29 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, Samuel Ortiz <sameo@linux.intel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: pm8921-regulator: Add regulator driver
 for PM8921
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org> <1301523432-6017-1-git-send-email-collinsd@codeaurora.org> <20110330234613.GA21487@opensource.wolfsonmicro.com> <4D93DAD2.5080501@codeaurora.org> <20110331234359.GD21726@opensource.wolfsonmicro.com>
In-Reply-To: <20110331234359.GD21726@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2011 04:44 PM, Mark Brown wrote:
> Without actually knowing what the pin control implementation you have
> does and how it's used it's hard to suggest something specific.  I
> still don't have a good handle on what is voting, what is actually being
> controlled or how it interacts with software control by Linux.  We've
> jumped to discussion of the implementation without understanding the
> problem.  Could you perhaps go back to square one and explain what
> exactly you mean when you say "pin control"?

The PMIC 8921 has 4 pin control input pins named: A0, A1, D0, D1 (as noted
in pm8921-regulator.h from my patch).  Each regulator has a pin control
register which provides 8 configuration bits.  4 of these bits correspond
to transitioning the regulator from off to on when the corresponding pin
control input(s) is/are active.  The physical enable state of the
regulator thus becomes the logical OR of the control register enable bit
and any pin control inputs that have been masked for use.

The other 4 bits in the pin control register for a given regulator decide
if the regulator should transition into high power mode (HPM) when the
selected pin control input is asserted.  Any combination of pin control
inputs may be masked for use.  The important use cases then become: OFF ->
ON (HPM) and ON (LPM) -> ON (HPM).  These correspond to
PM8921_VREG_PIN_FN_ENABLE and PM8921_VREG_PIN_FN_MODE respectively in the
header file.

Pin control is typically used by external chips (not the PMIC or the main
CPU) that need to have some say in the state of a regulator.  An example
would be a wifi chip that can enable and disable the regulator powering
its radio circuitry while the main processor is asleep.  It would then
wake the main processor up with an interrupt when new data was available
to processor.

There are cases in which multiple consumer devices are supplied by one
regulator where one consumer is controlled by a driver on the main
processor and another consumer is an independent chip that utilizes pin
control on the regulator.  The first consumer would desire the regulator
to be disabled during sleep because there is no way for it to respond to
the device while asleep.  However, the regulator would need to be
configured for pin control to ensure that it is enabled when the second
consumer expects it to be.  It is also normal to mask off pin control if
the second consumer is to be disabled.

The end result is that three quantities need to be controlled for the
regulator which aren't entirely orthogonal: enable/disable, LPM/HPM, pin
control ON/pin control OFF.  (It would also be useful if the type of pin
control (OFF/HPM or LPM/HPM) could be configured at runtime, but it is ok
if it is statically configured via platform data.)

Do you know of a generic (or specific it is ok to do so) API that I can
add to the regulator framework to support pin control?

>> Regulator registration needs to continue being based on which regulators
>> are configured via the board file platform data because there will be need
>> in our system in the near future to use a different (shared) regulator
>> driver to access some of the same physical regulators.
> 
>> We consider this to be the native PMIC 8921 regulator driver because it
>> accesses the PMIC directly.  There will be a subsequent PMIC 8921
>> regulator driver which issues requests to a separate processor which
>> aggregates our requests with those of other SOC processors.
> 
> That's not an issue - the regulator API won't write to the regulators
> unless the machine driver explicitly tells it that this is OK so all
> that will happen is that we'll be able to read back the state of the
> regulators directly.  If your driver is modifying the state of the
> regulators without the API telling it to then we should fix that as the
> no-write behaviour is an important safety feature.

The regulator probe function reads the regulator register values to figure
out the initial hardware state.  It also sets some regulator controls not
handled by other regulator framework callback functions; e.g.: pull down
enable.  I'm not sure if this could be moved into an init_data
regulator_init callback because that pointer would need to be specified in
the board file where the function would be unknown.

Also, it would pollute the system with unusable devices if all natively
controlled regulator devices were registered if the shared driver was
being used for many regulators.

>>> This needs locking if any registers are shared between multiple
>>> regulators.
> 
>> There are no registers shared between multiple regulators.  The mutex
>> locks held inside of the regulator framework should be sufficient.
> 
> OK, a comment would help - this is a very common error in regulator
> drivers as many regulators put all the enable bits for the system in a
> single register.

I'll add a comment.

>>>> +	/* Round down for set points in the gaps between bands. */
>>>> +	if (uV > FTSMPS_BAND1_UV_MAX && uV < FTSMPS_BAND2_UV_MIN)
>>>> +		uV = FTSMPS_BAND1_UV_MAX;
>>>> +	else if (uV > FTSMPS_BAND2_UV_MAX
>>>> +			&& uV < FTSMPS_BAND3_UV_SETPOINT_MIN)
>>>> +		uV = FTSMPS_BAND2_UV_MAX;
> 
>>> That seems broken - it means you'll go under voltage on what was
>>> requested.  You should ensure that you're always within the requested
>>> range so if the higher band minimum is in the range you should select
>>> that, otherwise you should error out.
> 
>> This rounding is done to ensure that the calculations below always yield a
>> register program voltage that is valid.  I could change this to pick the
>> minimum of the higher band instead.
> 
> Note the thing about rechecking against the bounds - you need to look at
> *both* limits.
> 
>> In this example, consider the second condition which is checking for
>> min_uV in the range (1400000, 1500000).  What should the correct result be
>> if a consumer calls regulator_set_voltage(reg, 1450000, 1450000) (assuming
>> that it is the only consumer so far and that the constraints step for the
>> regulator allow the value)?  As the driver is written, it would set the
>> voltage to 1.4V.  However, I think that 1.5V is more reasonable.
>> Returning an error for this seems counter productive.
> 
> The driver should return an error.  If the consumer wanted exactly 1.45V
> then that's what the system should deliver, if the consumer is happy
> with other voltages then it should say so.  The specification by range
> is there because some consumers are sensitive to particular voltages and
> need to get what they asked for, or they may have much more flexibility
> in one direction or the other (like DVFS where it's usually no problem
> to be overvoltage but being undervoltage will usually fail).  By
> allowing the consumer to specify a range we allow the consumer to
> control this, having the API or the drivers take guesses on behalf of
> the consumer means it's hard for a consumer driver to reliably
> interoperate with different regulators.

I guess I will change the set voltage callbacks so that they round up the
vprog value:
	vprog = (min_uV - band_min_uV + step_size - 1) / step_size
instead of
	vprog = (min_uV - band_min_uV) / step_size
It will also check that the resulting output voltage is <= max_uV.

> The API provides a mechanism for enumerating the set of supported
> voltages (which IIRC you're not implementing - you should) which
> consumers can use to ensure good interoperation.

I should be able to provide a list_voltage callback in the driver.

>>> This function is just a switch statement per regulator, may aswell expan
>>> ithere.  Or restructure things so that you've got a driver per regulator
>>> type - that would also mean you'd be able to get the device IDs to
>>> correspond to the regulator numbers which would probably be clearer.
> 
>> I separated out the type specific init functions because they are
>> relatively lengthy and independent.  Wouldn't putting that code directly
>> into a switch statement in the probe function be hard to follow?
> 
> Right, but the _init() function is basically just a switch statement
> which calls these functions AFAIR - inlining the switch statement
> doesn't mean inlining the functions too.

I misunderstood before.  I will move the switch statement.

- David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
