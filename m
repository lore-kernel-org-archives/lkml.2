Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab1C2QIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:08:17 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10527 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583Ab1C2QIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:08:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82721165"
Message-ID: <4D9203EF.4060303@codeaurora.org>
Date: Tue, 29 Mar 2011 09:08:15 -0700
From: David Collins <collinsd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm-owner@vger.kernel.org
Subject: Re: [PATCH v2 2/2] regulator: Propagate uA_load requirements up supply
 chain
References: <1301356355-7546-1-git-send-email-collinsd@codeaurora.org> <1301356432-7586-2-git-send-email-collinsd@codeaurora.org> <20110329084458.GD29330@opensource.wolfsonmicro.com>
In-Reply-To: <20110329084458.GD29330@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 01:44 AM, Mark Brown wrote:
>> Add code to handle uA_load propagation up through the regulator
>> supply chain in both regulator_set_optimum_mode and drms_uA_update.
> 
> So, my main concern here is essentially the same thing I said with
> regard to your original posting about the locking - this all seems
> like it's the wrong approach and if we just treated supplies the same as
> other consumers life would get a lot simpler.  This is adding a lot more
> special cases for supplies which feels like it's making the code more
> complicated.  Supplied regulators are essentially just consumers and
> this is adding more code that diverges the two and makes it hard to
> follow what's going on - ideally when dealing with the parent regulator
> you shouldn't have to worry about child regulators at all, they should
> just look like all the other consumers.

I agree that it would be beneficial to change regulator_dev.supply from
type struct regulator_dev * to type struct regulator *.  However, I think
that going that route will be a major undertaking with a lot of details to
work out and more room for deadlocking scenarios to get introduced.  Who
would be responsible for making such a change?

>> Add a new regulator operation callback function named
>> get_current_required to struct regulator_ops to assist in this
>> propagation.  get_current_required will return the input current
>> required for a given regulator based on input voltage, output
>> voltage, and output current.  It should be able to capture all
>> hardware specific current characteristics of a regulator.
>> The input current required for a typical linear and switching
>> regulator would be simple to describe in this callback.
> 
> The other issue here is that I'm concerned about the direction this
> appears to be heading given that it seems like in order for this to do
> something useful we'd need to start supplying current drain information
> from consumers.  We're not doing that at the minute and I'm not terribly
> optimistic that we'd ever get enough useful information to make it
> generally worthwhile.

The regulator framework does have a mechanism for consumers to specify
their current drain information: regulator_set_optimum_mode.  Systems that
do not wish to take advantage of the current propagation API are under no
obligation to use it.

> Besides, the interesting stuff tends to be around response to sudden
> changes in load and that's basically all been pushed down into hardware
> as there's no way for software to propagate the information fast enough.
> For software you tend to have to assume the worst case load but that
> will usually be a massive overestimate, and of course transients will be
> absorbed by the passives to a certain extent which complicates matters
> further.
> 
> Perhaps if you could explain your use case for this things might become
> clearer?

The system that I am working with utilizes a PMIC containing 8 switching
regulators (SMPS) and 26 LDO regulators.  Many of the LDO's are
subregulated from the SMPS's.  The system state at the beginning of boot
will have all non-essential regulators disabled and in low power mode (LPM
signified with REGULATOR_MODE_STANDBY).  Consumer drivers will then be
responsible for setting up the regulators that their peripheral devices
require.  Most of the LDO regulators have a LPM threshold of 10mA and high
power mode (HPM signified with REGULATOR_MODE_FAST) threshold of 50-1200mA
depending upon type.  Thus, consumers will need to call
regulator_set_optimum_mode with their peak load current in order to change
their supply regulator from LPM to HPM.  It is also worth noting that many
of the regulators are shared between different consumers so it is
important that regulator_set_optimum_mode is used instead of
regulator_set_mode to ensure that all consumer needs are met.

The regulator framework will already handle enabling the regulators
further up the supply chain.  In this case, enabling an LDO will also
enable its parent SMPS.  However, changing the mode of a regulator based
on current draw will not affect the mode of its supply regulator at the
moment.  This is a problem in the system I am working on because the SMPS
regulators will also be in LPM by default.  The max LPM output of the SMPS
regulators is 100mA and the max HPM output is 1500 or 2000mA (depending
upon type).  Consumer drivers will not be aware of the regulator supply
chain; nor should they need to be.  Therefore, it is critical for system
functionality that changing the load of a child regulator will also change
the load of its parent regulator.

One could solve this problem by using HPM at all times, but there is a
design requirement that system use the smallest amount of power possible.
 Do you have thoughts about a different solution?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
