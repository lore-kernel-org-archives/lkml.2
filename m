Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759526Ab2DZWBh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 18:01:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:60159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755408Ab2DZWBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 18:01:33 -0400
Subject: Re: [PATCH RFC tip/core/rcu 6/6] rcu: Reduce cache-miss
 initialization latencies for large systems
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
In-Reply-To: <20120426202828.GK2407@linux.vnet.ibm.com>
References: <20120423164159.GA13819@linux.vnet.ibm.com>
	 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1335444707.13683.14.camel@twins>
	 <20120426141213.GB2407@linux.vnet.ibm.com>
	 <1335454137.13683.95.camel@twins>
	 <20120426161509.GE2407@linux.vnet.ibm.com>
	 <1335469319.2463.97.camel@laptop>
	 <20120426202828.GK2407@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Apr 2012 00:01:25 +0200
Message-ID: <1335477685.2463.128.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 13:28 -0700, Paul E. McKenney wrote:
> Interesting!  A few probably clueless questions and comments below.

Thanks, shows me where to put comments in :-)

> > +static void sched_init_numa(void)
> > +{
> > +     int next_distance, curr_distance = node_distance(0, 0);
> > +     struct sched_domain_topology_level *tl;
> > +     int level = 0;
> > +     int i, j, k;
> > +
> > +     sched_domains_numa_scale = curr_distance;
> > +     sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
> > +     if (!sched_domains_numa_distance)
> > +             return;
> > +
> > +     next_distance = curr_distance;
> > +     for (i = 0; i < nr_node_ids; i++) {
> > +             for (j = 0; j < nr_node_ids; j++) {
> > +                     int distance = node_distance(0, j);
> 
> Shouldn't this be "node_distance(i, j)"?
> 
> Actually, I don't see any use of "i" in this loop anywhere, which seems
> strange.

It assumes all distances in node_distance(i,j) occur in
node_distance(0,j). This to avoid a cubic loop.
             
> > +                     if (distance > curr_distance &&
> > +                                     (distance < next_distance ||
> > +                                      next_distance == curr_distance))
> > +                             next_distance = distance;
> > +             }
> > +             if (next_distance != curr_distance) {
> > +                     sched_domains_numa_distance[level++] = next_distance;
> > +                     sched_domains_numa_levels = level;
> 
> I don't understand the intent here.  One approach would be to have
> one sched_domains_numa_distance[] array per node, with distances
> in each array sorted by increasing distance from the array's node.
> 
> As it is, I believe you get N copies of the sorted distances from
> node 0 in an array that is only guaranteed to be big enough for 1 copy.
> Unless you know something about the node_distance() matrix that limits
> the number of distinct values.

Note this is in the 'i' loop, not in the nested i,j loop. The nested
loop finds the next smallest distance, the outer loop records it.

> > +                     curr_distance = next_distance;
> > +             } else break;
> > +     }
> 
> The above loop seems to be doing a selection sort eliminating duplicates.

Correct, and leaving out the identity distance, see below.

> Would it make sense to put a real sort implementation into lib/?

There's a heapsort in lib/sort.c. And I guess we could write the whole
lot in 3 stages, 1) dump node_distance(0,i) in an array, 2) sort array,
3) remove duplicates from array, but I was lazy and did the O(n^2)
thing.

So we have 'level' be the number of unique distances larger than the
identity distance node_distance(i,i) -- in specific (0,0). And
sched_domains_numa_distance[0..level-1] be the array recording the
specific distance numbers.

> > +
> > +     sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
> > +     if (!sched_domains_numa_masks)
> > +             return;
> > +
> > +     for (i = 0; i < level; i++) {
> > +             sched_domains_numa_masks[i] = alloc_percpu(cpumask_t);
> > +             if (!sched_domains_numa_masks[i])
> > +                     return;
> > +
> > +             for_each_possible_cpu(j) {
> > +                     struct cpumask *mask =
> > +                             per_cpu_ptr(sched_domains_numa_masks[i], j);
> > +
> > +                     for (k = 0; k < nr_node_ids; k++) {
> > +                             if (node_distance(cpu_to_node(j), k) >
> > +                                             sched_domains_numa_distance[i])
> > +                                     continue;
> > +
> > +                             cpumask_or(mask, mask, cpumask_of_node(k));
> > +                     }
> > +             }
> > +     }
> 
> OK, if we can assume that the node distances are symmetric, so that
> node_distance(i, j) == node_distance(j, i), 

Yeah, I do assume that, not quite sure this is true, but we'll see. I'll
have to ask someone at SGI/HP/etc. for node_distance() tables for
'interesting' hardware.

> I think I see what you
> are getting at, though I am having a hard time seeing how to pack
> it into a linear array.

Yeah, I'm not sure you can either. Hence me building a tree ;-) But you
too have a tree, its tree-rcu after all.

> The idea seems to be to compute a per-CPU list of CPU masks, with the first
> entry having bits set for the CPUs closest to the CPU corresponding to
> the list, and subsequent entries adding more-distant CPUs.  The last
> CPU mask would presumably have bits set for all CPUs.

Indeed. So the scheduler already knows about nodes (included in the
default_topology thing), here we're constructing masks spanning nodes
based on distance.

So the first level is all nodes that are directly connected, the second
level are all nodes that have one intermediate hop, etc.. with indeed
the last level being the entire machine.

> I take it that there is no data structure listing per-node CPU masks,
> indicating which CPUs are members of a given node?  Or is something else
> going on here?

There is, its cpumask_of_node(), you'll find it used in the above
code :-) We do the for_each_cpu loop because we need the mask per-node
and there's no such thing as per-node memory so we fudge it using
per-cpu memory.

This could be optimized to reduce overhead if this all turns out to work
well.

So in short: for every 'i < level', for every cpu, we build a mask of
which cpus are '<= i' hops away from our current node.

> > +
> > +     tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
> > +                     sizeof(struct sched_domain_topology_level), GFP_KERNEL);
> > +     if (!tl)
> > +             return;
> > +
> > +     for (i = 0; default_topology[i].init; i++)
> > +             tl[i] = default_topology[i];
> > +
> > +     for (j = 0; j < level; i++, j++) {
> > +             tl[i] = (struct sched_domain_topology_level){
> 
> tl[j]?

No, [i]. See how we allocate an array of ARRAY_SIZE(default_topology) +
level, then copy the default topology array then continue i by j
additional levels.

> > +                     .init = sd_init_NUMA,
> > +                     .mask = sd_numa_mask,
> > +                     .flags = SDTL_OVERLAP,
> > +                     .numa_level = j,
> > +             };
> > +     }
> > +
> > +     sched_domain_topology = tl;
> > +} 

