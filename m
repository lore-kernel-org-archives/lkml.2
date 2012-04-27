Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760373Ab2D0PDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:03:36 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:39638 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760161Ab2D0PDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:03:34 -0400
Date: Fri, 27 Apr 2012 07:17:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
Message-ID: <20120427141700.GA12854@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335444707.13683.14.camel@twins>
 <20120426141213.GB2407@linux.vnet.ibm.com>
 <1335454137.13683.95.camel@twins>
 <20120426161509.GE2407@linux.vnet.ibm.com>
 <1335469319.2463.97.camel@laptop>
 <20120426202828.GK2407@linux.vnet.ibm.com>
 <1335477685.2463.128.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335477685.2463.128.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042715-4242-0000-0000-0000017A7FFB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 12:01:25AM +0200, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 13:28 -0700, Paul E. McKenney wrote:

[ . . . ]

> > I think I see what you
> > are getting at, though I am having a hard time seeing how to pack
> > it into a linear array.
> 
> Yeah, I'm not sure you can either. Hence me building a tree ;-) But you
> too have a tree, its tree-rcu after all.
> 
> > The idea seems to be to compute a per-CPU list of CPU masks, with the first
> > entry having bits set for the CPUs closest to the CPU corresponding to
> > the list, and subsequent entries adding more-distant CPUs.  The last
> > CPU mask would presumably have bits set for all CPUs.
> 
> Indeed. So the scheduler already knows about nodes (included in the
> default_topology thing), here we're constructing masks spanning nodes
> based on distance.
> 
> So the first level is all nodes that are directly connected, the second
> level are all nodes that have one intermediate hop, etc.. with indeed
> the last level being the entire machine.
> 
> > I take it that there is no data structure listing per-node CPU masks,
> > indicating which CPUs are members of a given node?  Or is something else
> > going on here?
> 
> There is, its cpumask_of_node(), you'll find it used in the above
> code :-) We do the for_each_cpu loop because we need the mask per-node
> and there's no such thing as per-node memory so we fudge it using
> per-cpu memory.
> 
> This could be optimized to reduce overhead if this all turns out to work
> well.
> 
> So in short: for every 'i < level', for every cpu, we build a mask of
> which cpus are '<= i' hops away from our current node.

So this information could be used to create a cache-friendly CPU ordering,
such that CPU i and CPU i+1 tend to be electrically close to each other.
One could solve the traveling salesmans problem, but doing a traveral
of the CPUs following the node tree should be much simpler and come
pretty close.

If someone were to show significant performance degradation due to
RCU's using the smp_processor_id() ordering for its rcu_node tree,
I would try this ordering.  It would cause the rcu_node tree performance
to be much less sensitive to the rcu_node tree's geometry.

> > > +
> > > +     tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
> > > +                     sizeof(struct sched_domain_topology_level), GFP_KERNEL);
> > > +     if (!tl)
> > > +             return;
> > > +
> > > +     for (i = 0; default_topology[i].init; i++)
> > > +             tl[i] = default_topology[i];
> > > +
> > > +     for (j = 0; j < level; i++, j++) {
> > > +             tl[i] = (struct sched_domain_topology_level){
> > 
> > tl[j]?
> 
> No, [i]. See how we allocate an array of ARRAY_SIZE(default_topology) +
> level, then copy the default topology array then continue i by j
> additional levels.

OK, good thing I correctly characterized my comments.  ;-)

							Thanx, Paul

> > > +                     .init = sd_init_NUMA,
> > > +                     .mask = sd_numa_mask,
> > > +                     .flags = SDTL_OVERLAP,
> > > +                     .numa_level = j,
> > > +             };
> > > +     }
> > > +
> > > +     sched_domain_topology = tl;
> > > +} 
> 

