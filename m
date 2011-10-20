Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1JTR3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:29:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:59420 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab1JTR3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:29:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,380,1315206000"; 
   d="scan'208";a="75869872"
Subject: Re: [Patch] Idle balancer: cache align nohz structure to improve
 idle load balancing scalability
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Venki Pallipadi <venki@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 20 Oct 2011 10:31:40 -0700
In-Reply-To: <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
References: <1319060737.2604.38.camel@schen9-DESK>
	 <m2wrc0xpbg.fsf@firstfloor.org>
	 <CABeCy1a20npBt=4ee38zLH+6Fi7nfASd0dL3od6pOccV=LJDkA@mail.gmail.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1319131900.5622.25.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-20 at 05:26 -0700, Venki Pallipadi wrote:
> On Wed, Oct 19, 2011 at 9:24 PM, Andi Kleen <andi@firstfloor.org> wrote:
> > Tim Chen <tim.c.chen@linux.intel.com> writes:
> >>   */
> >>  static struct {
> >> -     atomic_t load_balancer;
> >> -     atomic_t first_pick_cpu;
> >> -     atomic_t second_pick_cpu;
> >> -     cpumask_var_t idle_cpus_mask;
> >> +     atomic_t load_balancer ____cacheline_aligned;
> >> +     atomic_t first_pick_cpu ____cacheline_aligned;
> >> +     atomic_t second_pick_cpu ____cacheline_aligned;
> >> +     cpumask_var_t idle_cpus_mask ____cacheline_aligned;
> >
> > On large configs idle_cpu_masks may be allocated.  May need
> > more changes to tell the allocator to cache align/pad too?
> >
> 
> An alternate approach is to split this struct per node/socket and do
> the nohz idle balancing logic at that level. That should be more
> scalable in terms of nohz balancing (ensure one CPU wont be doing nohz
> balancing for huge number of idle CPUs). I had looked at that approach
> couple of years earlier and couldn't measure that much of a gain. May
> be it is time to revisit that with increased core count.

I am actually looking at it. This is a quick fix for the meantime.

Even with this cacheline aligned, the first_pick_cpu and second_pick_cpu
cacheline bouncing is still causing ~8% more performance impact on this
synthetic lat_ctx heavy workload. For this experiment to measure the
potential scope we have here, We left the cacheline bouncing associated
with the  nohz.idle_cpus_mask update in place.

thanks,
suresh

