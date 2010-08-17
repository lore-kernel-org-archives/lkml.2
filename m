Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab0HQUon (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 16:44:43 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58316 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0HQUoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 16:44:37 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6077"; a="51220838"
Message-ID: <4C6AF4B4.4060004@codeaurora.org>
Date: Tue, 17 Aug 2010 13:44:36 -0700
From: Bobby Crabtree <bobbyc@codeaurora.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
References: <4C6ACF92.7050506@codeaurora.org> <20100817181557.GA5755@opensource.wolfsonmicro.com> <4C6AE40D.7090206@codeaurora.org> <20100817195008.GC5755@opensource.wolfsonmicro.com>
In-Reply-To: <20100817195008.GC5755@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown wrote:
> On Tue, Aug 17, 2010 at 12:33:33PM -0700, Bobby Crabtree wrote:
>> Mark Brown wrote:
> 
>>> It's unlikely that the highest voltage would ever be the best choice...
> 
>> We do need the highest voltage. Let's say we have two consumers
>> (A and B). Both require 1.3V for "normal" operations. Then let's
>> say that consumer A can save power by reducing the voltage to 1.1V
>> (but it doesn't require 1.1V). If the core were to immediately apply
>> 1.1V, then the 1.3V requirement of consumer B would not be satisfied.
> 
> That's not the highest voltage, that's the minimum voltage that
> satisfies all the requests that the consumers have made.  The consumer
> which requires 1.1V will have requested 1.1V up to, say, 3.3V.  The
> consumer that requested 1.3V will have requested, say, 1.3-1.8V and
> let's say the machine constraints will allow at least these ranges.
> 1.3V is the lowest voltage that hits all the constraints, but it's still
> lower than any of the maxima.
> 
Aah. I get it now.

>>> This was actually a feature of the regulator API when originally
>>> proposed, it got dropped for ease of review but there's some remanants
>>> of this in the code so it shouldn't be hard to resurrect.  Whenever a
>>> voltage was set the code stored the range on the consumer then iterated
>>> over all consumers applying their ranges plus the machine constraints
>>> rather than just using the immediate value.
> 
>> I noticed some of the remnants. But I'm not sure I follow what you
>> are saying. What range would the core actually propagate to the
>> driver? The minimum min_uV and the maximum max_uV? We need the core
>> to propagate the maximum min_uV and the maximum max_uV.
> 
> No, it'd be the maximum min_uV and the minimum max_uV - this is already
> happening when the constraints from the machine are applied, it'd just
> be applying a wider set of constraints.  In principle all we need to do
> is remember the voltage constraints that individual consumers set and
> then iterate over all the enabled consumers when one of them changes its
> range (or is enabled/disabled) instead of just taking the immediate
> values from the consumer.

Got it.

Only remaining question I have is if the aggregation of
multiple consumer constraints should be the default (and only)
behavior. Or should we introduce a new flag to the
regulator_constraints structure that tells the core to aggregate
consumer voltages constraints?
