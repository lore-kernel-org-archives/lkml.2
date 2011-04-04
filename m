Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1DDRNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 13:13:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37839 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab1DDRNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 13:13:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6306"; a="83679807"
Message-ID: <4D99FC24.4060007@codeaurora.org>
Date: Mon, 04 Apr 2011 10:13:08 -0700
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
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org> <1301523432-6017-1-git-send-email-collinsd@codeaurora.org> <20110330234613.GA21487@opensource.wolfsonmicro.com> <4D93DAD2.5080501@codeaurora.org> <20110331234359.GD21726@opensource.wolfsonmicro.com> <4D965F9D.3060907@codeaurora.org> <20110402025012.GD25424@opensource.wolfsonmicro.com>
In-Reply-To: <20110402025012.GD25424@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 07:50 PM, Mark Brown wrote:
> This all seems fairly standard and like many other regulators except for
> the the masking off the pin control.  The only unusual thing is that the
> hardware control is being managed by software at runtime, usually it's
> set up and then left alone by software.
> 
> The first thing I'm thinking here is that this maps fairly well onto a
> semi-virtual regulator where the operations map onto the control for the
> hardware mode.  The enable/disable control via the pin is totally
> orthogonal to the control via the regular register interface, and it
> sounds like the mode control is too though that was less clear to me.
> Enabling would then translate into turning pin control on rather than
> actually enabling but that seems OK.  Does that sound like it'd work?

So what you are suggesting is that two regulators are registered for a
single physical regulator.  The first operates normally with respect to
enable, set mode, set voltage, etc.  The second will be used exclusively
for pin control in which regulator_enable and regulator_disable will map
to enabling and disabling pin control.  I suppose that this should be ok
as long as it isn't confusing for consumers to utilize.  However, I will
definitely only register pin control regulators which are marked for use
with pin control via some of the platform data values.  Otherwise the
number of regulators registered would double unnecessarily.

Also, while conceptually pin control should be independent of other
regulator features, it becomes nonorthogonal in practice.  For instance,
some regulators have finer voltage stepping available in advanced
operating mode, but pin control cannot be used in this advanced mode.  The
result is that set_voltage becomes tried to pin control for these
regulators.  The outcome is that the new pin control semi-virtual
regulator would be tightly coupled to its real sibling regulator.
Implementing it in this manner may get complicated.

I suppose there is also a question of what regulator_disable should mean
in terms of outcome regulator state.  Thus far, I have interpreted it to
mean that the regulator is definitely turned off physically.  As such, pin
control must be disabled if it was previously enabled.  Do you think this
is the best approach to take, or should the concepts of regulator enable
and regulator pin control enable be orthogonal?

>> The regulator probe function reads the regulator register values to figure
>> out the initial hardware state.  It also sets some regulator controls not
>> handled by other regulator framework callback functions; e.g.: pull down
> 
> That just sounds like platform data which could just work in the same
> way as the regulator core - no platform data would mean nothing gets
> changed.

That is more or less how the patch already works.  If platform data for a
given regulator is not passed to the pm8921-core, then that regulator is
never probed (via platform device) and the regulator_dev is not created
for it (in the platform driver probe).  The loop in pm8921_add_subdevices
which adds the pm8921-regulator devices is important because it must
iterate in topological order with respect to the regulator supply chain.
This ordering is arbitrary and unknown to either the pm8921-core or the
pm8921-regulator.  If there is no strong requirement for this to change, I
would prefer to keep it as is.

>> enable.  I'm not sure if this could be moved into an init_data
>> regulator_init callback because that pointer would need to be specified in
>> the board file where the function would be unknown.
> 
> I'm sorry, I don't understand what you're saying here.  Could you
> clarify?

struct regulator_init_data has a member: regulator_init.  However, I don't
think there is a good way to make use of it for this system because that
function pointer must be specified statically in a board file, but the
regulator register init function is private to the pm8921-regulator driver.

>> Also, it would pollute the system with unusable devices if all natively
>> controlled regulator devices were registered if the shared driver was
>> being used for many regulators.
> 
> Depends if you view it as pollution or not; also note that the devices
> aren't totally unusuable as you can still use them for readback.

They wouldn't be useful for readback either because register values are
only read during initialization.  The remainder of the regulator usage is
write-only.  This works under the assumption that PMIC registers will not
be modified by any other writers.  This assumption is true except in the
case of a regulator managed via the shared interface.

- David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
