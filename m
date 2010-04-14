Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408Ab0DNE2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:28:39 -0400
Received: from ozlabs.org ([203.10.76.45]:46919 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab0DNE2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:28:38 -0400
From: Michael Neuling <mikey@neuling.org>
To: Peter Zijlstra <peterz@infradead.org>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/5] sched: fix capacity calculations for SMT4
In-reply-to: <1271161766.4807.1280.camel@twins>
References: <20100409062118.D4096CBB6C@localhost.localdomain> <1271161766.4807.1280.camel@twins>
Comments: In-reply-to Peter Zijlstra <peterz@infradead.org>
   message dated "Tue, 13 Apr 2010 14:29:26 +0200."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Wed, 14 Apr 2010 14:28:37 +1000
Message-ID: <2906.1271219317@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1271161766.4807.1280.camel@twins> you wrote:
> On Fri, 2010-04-09 at 16:21 +1000, Michael Neuling wrote:
> > When calculating capacity we use the following calculation:
> >=20
> >        capacity =3D DIV_ROUND_CLOSEST(power, SCHED_LOAD_SCALE);
> >=20
> > In SMT2, power will be 1178/2 (provided we are not scaling power with
> > freq say) and SCHED_LOAD_SCALE will be 1024, resulting in capacity
> > being 1.
> >=20
> > With SMT4 however, power will be 1178/4, hence capacity will end up as
> > 0.
> >=20
> > Fix this by ensuring capacity is always at least 1 after this
> > calculation.
> >=20
> > Signed-off-by: Michael Neuling <mikey@neuling.org>
> > ---
> > I'm not sure this is the correct fix but this works for me. =20
> 
> Right, so I suspect this will indeed break some things.
> 
> We initially allowed 0 capacity for when a cpu is consumed by an RT task
> and there simply isn't much capacity left, in that case you really want
> to try and move load to your sibling cpus if possible.

Changing the CPU power based on what tasks are running on them seems a
bit wrong to me.  Shouldn't we keep those concepts separate?

> However you're right that this goes awry in your case.
> 
> One thing to look at is if that 15% increase is indeed representative
> for the power7 cpu, it having 4 SMT threads seems to suggest there was
> significant gains, otherwise they'd not have wasted the silicon.

There are certainly, for most workloads, per core gains for SMT4 over
SMT2 on P7.  My kernels certainly compile faster and that's the only
workload anyone who matters cares about.... ;-)

> (The broken x86 code was meant to actually compute the SMT gain, so that
> we'd not have to guess the 15%)
> 
> Now, increasing this will only marginally fix the issue, since if you
> end up with 512 per thread it only takes a very tiny amount of RT
> workload to drop below and end up at 0 again.

I tried initialled to make smt_gain programmable and at 2048 per core
(512 per thread), the packing became unstable, as you intimated.

> One thing we could look at is using the cpu base power to compute
> capacity from. We'd have to add another field to sched_group and store
> power before we do the scale_rt_power() stuff.

Separating capacity from what RT tasks are running seems like a good
idea to me.

This would fix the RT issue, but it's not clear to me how you are
suggesting fixing the rounding down to 0 SMT4 issue.  Are you suggesting
we bump smt_gain to say 2048 + 15%?  Or are you suggesting we separate
the RT tasks out from capacity and keep the max(1, capacity) that I've
added?  Or something else?

Would another possibility be changing capacity a scaled value (like
cpu_power is now) rather than a small integer as it is now.  For
example, a scaled capacity of 1024 would be equivalent to a capacity of
1 now.  This might enable us to handle partial capacities better?  We'd
probably have to scale a bunch of nr_running too.  

Mikey

