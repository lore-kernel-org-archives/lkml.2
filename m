Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab2J2MIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 08:08:37 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:59243
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754978Ab2J2MIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 08:08:36 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.45;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC01.kpit.com;RD:59.163.77.45.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz98dI936eI148cI1432Izz1202h1d1ah1d2ahzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537hbe9i1155h)
Subject: Re: [Patch v3 2/7] Regulator: DA9055 Regulator driver
From: Ashish Jangam <ashish.jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        David Dajun Chen <dchen@diasemi.com>, <linux-kernel@vger.kernel.org>
In-Reply-To: <20121027215850.GI4564@opensource.wolfsonmicro.com>
References: <1349950164.7957.23.camel@dhruva>
	 <20121027215850.GI4564@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 17:37:58 +0530
Message-ID: <1351512478.17695.14.camel@dhruva>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.38.47]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-10-27 at 22:59 +0100, Mark Brown wrote:
> On Thu, Oct 11, 2012 at 03:39:24PM +0530, Ashish Jangam wrote:
> 
> > This is the Regulator patch for the DA9055 PMIC and has got dependency on
> > the DA9055 MFD core.
> 
> Always submit patches with subject lines appropriate for the subsystem,
> this helps get your patch noticed.  People do things like search their
> mailboxes for subsystem prefixes when looking for things they need to
> review.
In subject line apart from "regulator" I will introduce "next" too. 
> 
> > This patch support all of the DA9055 regulators. The output voltages are
> > fully programmable through I2C interface only. The platform data with regulation
> > constraints is passed down from the board to the regulator.
> > 
> > +	switch (mode) {
> > +	case REGULATOR_MODE_FAST:
> > +		val = DA9055_BUCK_MODE_SYNC << info->mode.shift;
> > +		break;
> > +	case REGULATOR_MODE_NORMAL:
> > +		val = DA9055_BUCK_MODE_AUTO << info->mode.shift;
> > +		break;
> > +	case REGULATOR_MODE_IDLE:
> > +	case REGULATOR_MODE_STANDBY:
> > +		val = DA9055_BUCK_MODE_SLEEP << info->mode.shift;
> > +		break;
> 
> _IDLE and _STANDBY should have different effects if they're both
> implemented; pick one.  From the rest of the code it looks like it
> should be _STANDBY.
Yes, _STANDBY should be picked only.  
> 
> > +	switch (mode) {
> > +	case REGULATOR_MODE_NORMAL:
> > +	case REGULATOR_MODE_FAST:
> > +		val = DA9055_LDO_MODE_SYNC;
> > +		break;
> > +	case REGULATOR_MODE_IDLE:
> > +	case REGULATOR_MODE_STANDBY:
> > +		val = DA9055_LDO_MODE_SLEEP;
> > +	}
> 
> Similarly here.  You're also missing a break;
Ok, will fix this.
> 
> > +	/* Get the voltage for the activer register set A/B */
> > +	if (ret == DA9055_REGUALTOR_SET_A)
> > +		ret = da9055_reg_read(regulator->da9055, volt.reg_a);
> > +	else
> > +		ret = da9055_reg_read(regulator->da9055, volt.reg_b);
> > +
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	sel = ((ret & volt.v_mask) - volt.v_offset);
> 
> Why not just use the register values directly and refuse to write ones
> That are too low?  This would simplify things a little as you'd only
> need to check 
If I understood it correctly, v_offset should be used to check register
values as seen in the below sample code snippet
sel = ret & mask;
if (sel <= v_offset)
	return 0;
else
	return sel
> 
> > +	/* Set the voltage */
> > +	if (ret == DA9055_REGUALTOR_SET_A)
> > +		return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_a,
> > +							 selector);
> > +
> > +	return da9055_regulator_set_voltage_bits(rdev, info->volt.reg_b,
> > +						 selector);
> 
> This is confusingly written - it should be either a switch or an if/else
> really.
if/else seems to be sensible here.
> 
> > +	/* Select register set B for suspend voltage ramping. */
> > +	ret = da9055_reg_update(regulator->da9055, info->conf.reg,
> > +				info->conf.sel_mask, DA9055_SEL_REG_B);
> > +	if (ret < 0)
> > +		return ret;
> 
> This doesn't seem like it plays nicely with the GPIO selection in normal
> set_voltage() - does it need to check to see if register set B might be
> used in normal operation and refuse to run if it could?
Thanks for catching this. Need to add condition to check if GPIO is
selected. 
> 
> > +	for (i = 0; i < ARRAY_SIZE(da9055_regulator_info); i++) {
> > +		info = &da9055_regulator_info[i];
> > +		if (info->reg_desc.id == id)
> > +			return info;
> > +		}
> > +
> 
> The indentation here is *very* messed up.  I'd suggest not omitting any
> braces.
Ok, will fix indentation and put braces around if condition.


