Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758416Ab0FCI5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 04:57:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:48116 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758219Ab0FCI47 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 04:56:59 -0400
Subject: Re: [PATCH 1/5] sched: fix capacity calculations for SMT4
From: Peter Zijlstra <peterz@infradead.org>
To: svaidy@linux.vnet.ibm.com
Cc: Michael Neuling <mikey@neuling.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <20100601225250.GA7764@dirshya.in.ibm.com>
References: <20100409062118.D4096CBB6C@localhost.localdomain>
	 <1271161766.4807.1280.camel@twins> <2906.1271219317@neuling.org>
	 <1271426308.1674.429.camel@laptop> <1275294796.27810.21554.camel@twins>
	 <20100601225250.GA7764@dirshya.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Jun 2010 10:56:55 +0200
Message-ID: <1275555415.27810.35119.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-02 at 04:22 +0530, Vaidyanathan Srinivasan wrote:

> > If the group were a core group, the total would be much higher and we'd
> > likely end up assigning 1 to each before we'd run out of capacity.
> 
> This is a tricky case because we are depending upon the
> DIV_ROUND_CLOSEST to decide whether to flag capacity to 0 or 1.  We
> will not have any task movement until capacity is depleted to quite
> low value due to RT task.  Having a threshold to flag 0/1 instead of
> DIV_ROUND_CLOSEST just like you have suggested in the power savings
> case may help here as well to move tasks to other idle cores.

Right, well we could put the threshold higher than the 50%, say 90% or
so.

> > For power savings, we can lower the threshold and maybe use the maximal
> > individual cpu_power in the group to base 1 capacity from.
> > 
> > So, suppose the second example, where sibling0 has 50 and the others
> > have 294, you'd end up with a capacity distribution of: {0,1,1,1}.
> 
> One challenge here is that if RT tasks run on more that one thread in
> this group, we will have slightly different cpu powers.  Arranging
> them from max to min and having a cutoff threshold should work.

Right, like the 90% above.

> Should we keep the RT scaling as a separate entity along with
> cpu_power to simplify these thresholds.  Whenever we need to scale
> group load with cpu power can take the product of cpu_power and
> scale_rt_power but in these cases where we compute capacity, we can
> mark a 0 or 1 just based on whether scale_rt_power was less than
> SCHED_LOAD_SCALE or not.  Alternatively we can keep cpu_power as
> a product of all scaling factors as it is today but save the component
> scale factors also like scale_rt_power() and arch_scale_freq_power()
> so that it can be used in load balance decisions.

Right, so the question is, do we only care about RT or should capacity
reflect the full asymmetric MP case.

I don't quite see why RT is special from any of the other scale factors,
if someone pegged one core at half the frequency of the others you'd
still want it to get 0 capacity so that we only try to populate it on
overload.

> Basically in power save balance we would give all threads a capacity
> '1' unless the cpu_power was reduced due to RT task.  Similarly in
> the non-power save case, we can have flag 1,0,0,0 unless first thread
> had a RT scaling during the last interval.
> 
> I am suggesting to distinguish the reduction is cpu_power due to
> architectural (hardware DVFS) reasons from RT tasks so that it is easy
> to decide if moving tasks to sibling thread or core can help or not.

For power savings such a special heuristic _might_ make sense.
