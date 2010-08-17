Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142Ab0HQSP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 14:15:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53148 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758097Ab0HQSP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 14:15:58 -0400
Date: Tue, 17 Aug 2010 19:15:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bobby Crabtree <bobbyc@codeaurora.org>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
Message-ID: <20100817181557.GA5755@opensource.wolfsonmicro.com>
References: <4C6ACF92.7050506@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6ACF92.7050506@codeaurora.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:06:10AM -0700, Bobby Crabtree wrote:
> I'm looking to upstream a new feature in which the regulator core
> aggregates voltage requests from multiple consumers and applies the best
> fitting voltage (e.g. max voltage) to a shared supply. The core would

It's unlikely that the highest voltage would ever be the best choice...

> recompute the best fitting voltage when a consumer requests a voltage
> change or requests to enable/disable the regulator (similar logic to
> DRMS).

> The reason we need this feature is for power savings. It would allow two
> or more consumers to "vote" on a voltage that's lower than the normal
> operating voltage.

This was actually a feature of the regulator API when originally
proposed, it got dropped for ease of review but there's some remanants
of this in the code so it shouldn't be hard to resurrect.  Whenever a
voltage was set the code stored the range on the consumer then iterated
over all consumers applying their ranges plus the machine constraints
rather than just using the immediate value.

> 1. Introduce a new API:

> int regulator_set_optimum_voltage(struct regulator *regulator,
>                 int min_uV, int max_uV);

Why would you want to do this?  This is just the same arguments as the
standard regulator_set_voltage() call and if we're ever setting anything
other than the optimal voltage we probably ought to just stop doing
that.

> 2. Add a flag to the regulation_constraints structure and reuse the
> existing regulator_set_voltage API.

> struct regulation_constraints {
>         ...
>         unsigned aggregate_uV:1;
>         ...
> };

> Does this sound like a reasonable feature? And if so, are there any
> preferences as to how the feature is implemented and exposed?

If we were going to add something for this it should be a capability,
however I don't think there's any need to add anything to the API since
this is the only sane interpretation of allowing voltage changes on a
regulator with more than one consumer.
