Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab0HQTuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:50:17 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35788 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752535Ab0HQTuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:50:10 -0400
Date: Tue, 17 Aug 2010 20:50:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Bobby Crabtree <bobbyc@codeaurora.org>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: regulator voltage aggregation
Message-ID: <20100817195008.GC5755@opensource.wolfsonmicro.com>
References: <4C6ACF92.7050506@codeaurora.org> <20100817181557.GA5755@opensource.wolfsonmicro.com> <4C6AE40D.7090206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C6AE40D.7090206@codeaurora.org>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 12:33:33PM -0700, Bobby Crabtree wrote:
> Mark Brown wrote:

> > It's unlikely that the highest voltage would ever be the best choice...

> We do need the highest voltage. Let's say we have two consumers
> (A and B). Both require 1.3V for "normal" operations. Then let's
> say that consumer A can save power by reducing the voltage to 1.1V
> (but it doesn't require 1.1V). If the core were to immediately apply
> 1.1V, then the 1.3V requirement of consumer B would not be satisfied.

That's not the highest voltage, that's the minimum voltage that
satisfies all the requests that the consumers have made.  The consumer
which requires 1.1V will have requested 1.1V up to, say, 3.3V.  The
consumer that requested 1.3V will have requested, say, 1.3-1.8V and
let's say the machine constraints will allow at least these ranges.
1.3V is the lowest voltage that hits all the constraints, but it's still
lower than any of the maxima.  When you've got multiple things
specifying a voltage constraint you need to apply the most restrictive
combination of constraints but it still makes sense to pick the minimum
voltage we can deliver from the range that's left after doing that.

> > This was actually a feature of the regulator API when originally
> > proposed, it got dropped for ease of review but there's some remanants
> > of this in the code so it shouldn't be hard to resurrect.  Whenever a
> > voltage was set the code stored the range on the consumer then iterated
> > over all consumers applying their ranges plus the machine constraints
> > rather than just using the immediate value.

> I noticed some of the remnants. But I'm not sure I follow what you
> are saying. What range would the core actually propagate to the
> driver? The minimum min_uV and the maximum max_uV? We need the core
> to propagate the maximum min_uV and the maximum max_uV.

No, it'd be the maximum min_uV and the minimum max_uV - this is already
happening when the constraints from the machine are applied, it'd just
be applying a wider set of constraints.  In principle all we need to do
is remember the voltage constraints that individual consumers set and
then iterate over all the enabled consumers when one of them changes its
range (or is enabled/disabled) instead of just taking the immediate
values from the consumer.
