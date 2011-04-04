Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1DDXTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 19:19:34 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41005 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755591Ab1DDXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 19:19:30 -0400
Date: Tue, 5 Apr 2011 08:19:37 +0900
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
Message-ID: <20110404231935.GB4609@opensource.wolfsonmicro.com>
References: <1301523361-5982-1-git-send-email-collinsd@codeaurora.org>
 <1301523432-6017-1-git-send-email-collinsd@codeaurora.org>
 <20110330234613.GA21487@opensource.wolfsonmicro.com>
 <4D93DAD2.5080501@codeaurora.org>
 <20110331234359.GD21726@opensource.wolfsonmicro.com>
 <4D965F9D.3060907@codeaurora.org>
 <20110402025012.GD25424@opensource.wolfsonmicro.com>
 <4D99FC24.4060007@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D99FC24.4060007@codeaurora.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 10:13:08AM -0700, David Collins wrote:

> as long as it isn't confusing for consumers to utilize.  However, I will
> definitely only register pin control regulators which are marked for use
> with pin control via some of the platform data values.  Otherwise the
> number of regulators registered would double unnecessarily.

That's what I'd expect - in a very real sense the extra regulators don't
exist unless a pin is assigned to them.

> Also, while conceptually pin control should be independent of other
> regulator features, it becomes nonorthogonal in practice.  For instance,
> some regulators have finer voltage stepping available in advanced
> operating mode, but pin control cannot be used in this advanced mode.  The
> result is that set_voltage becomes tried to pin control for these
> regulators.  The outcome is that the new pin control semi-virtual
> regulator would be tightly coupled to its real sibling regulator.
> Implementing it in this manner may get complicated.

The pin and non-pin control are tied together anyway.

> I suppose there is also a question of what regulator_disable should mean
> in terms of outcome regulator state.  Thus far, I have interpreted it to
> mean that the regulator is definitely turned off physically.  As such, pin
> control must be disabled if it was previously enabled.  Do you think this
> is the best approach to take, or should the concepts of regulator enable
> and regulator pin control enable be orthogonal?

I'd keep them orthogonal - regulator_disable() doesn't mean disable the
regulator, it means that the consumer no longer requires that the
regulator be enabled.  Constraints or other consumers may still keep it
enabled.  Ensuring that the consumer can actually power the regulator
off is a system design issue that'd apply either way.

> > That just sounds like platform data which could just work in the same
> > way as the regulator core - no platform data would mean nothing gets
> > changed.

> That is more or less how the patch already works.  If platform data for a
> given regulator is not passed to the pm8921-core, then that regulator is
> never probed (via platform device) and the regulator_dev is not created
> for it (in the platform driver probe).  The loop in pm8921_add_subdevices
> which adds the pm8921-regulator devices is important because it must
> iterate in topological order with respect to the regulator supply chain.
> This ordering is arbitrary and unknown to either the pm8921-core or the
> pm8921-regulator.  If there is no strong requirement for this to change, I
> would prefer to keep it as is.

It does correlate with drivers that feel fragile, usually to do with
neither the MFD core nor the regulator driver being sure quite which
regulators actually exist.

> >> enable.  I'm not sure if this could be moved into an init_data
> >> regulator_init callback because that pointer would need to be specified in
> >> the board file where the function would be unknown.

> > I'm sorry, I don't understand what you're saying here.  Could you
> > clarify?

> struct regulator_init_data has a member: regulator_init.  However, I don't
> think there is a good way to make use of it for this system because that
> function pointer must be specified statically in a board file, but the
> regulator register init function is private to the pm8921-regulator driver.

I don't follow how this is connected to the above - why would one wish
to configure this with a callback rather than data?

> > Depends if you view it as pollution or not; also note that the devices
> > aren't totally unusuable as you can still use them for readback.

> They wouldn't be useful for readback either because register values are
> only read during initialization.  The remainder of the regulator usage is
> write-only.  This works under the assumption that PMIC registers will not
> be modified by any other writers.  This assumption is true except in the
> case of a regulator managed via the shared interface.

Is this enforced in hardware?
