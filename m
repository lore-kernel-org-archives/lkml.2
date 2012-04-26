Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193Ab2DZU3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 16:29:20 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40953 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2DZU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 16:29:18 -0400
Date: Thu, 26 Apr 2012 13:28:28 -0700
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
Message-ID: <20120426202828.GK2407@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120423164159.GA13819@linux.vnet.ibm.com>
 <1335199347-13926-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335199347-13926-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <1335444707.13683.14.camel@twins>
 <20120426141213.GB2407@linux.vnet.ibm.com>
 <1335454137.13683.95.camel@twins>
 <20120426161509.GE2407@linux.vnet.ibm.com>
 <1335469319.2463.97.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335469319.2463.97.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042620-4242-0000-0000-0000017838C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 09:41:59PM +0200, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 09:15 -0700, Paul E. McKenney wrote:
> > On Thu, Apr 26, 2012 at 05:28:57PM +0200, Peter Zijlstra wrote:
> > > On Thu, 2012-04-26 at 07:12 -0700, Paul E. McKenney wrote:
> > > > On Thu, Apr 26, 2012 at 02:51:47PM +0200, Peter Zijlstra wrote:
> > > 
> > > > > Wouldn't it be much better to match the rcu fanout tree to the physical
> > > > > topology of the machine?
> > > > 
> > > > From what I am hearing, doing so requires me to morph the rcu_node tree
> > > > at run time.  I might eventually become courageous/inspired/senile
> > > > enough to try this, but not yet.  ;-)
> > > 
> > > Yes, boot time with possibly some hotplug hooks.
> > 
> > Has anyone actually measured any slowdown due to the rcu_node structure
> > not matching the topology?  (But see also below.)
> 
> Nope, I'm just whinging ;-)

Hmmm, I suppose that I am whinging as well...

> > > > Actually, some of this topology shifting seems to me like a firmware
> > > > bug.  Why not arrange the Linux-visible numbering in a way to promote
> > > > locality for code sequencing through the CPUs?
> > > 
> > > I'm not sure.. but it seems well established on x86 to first enumerate
> > > the cores (thread 0) and then the sibling threads (thread 1) -- one
> > > 'advantage' is that if you boot with max_cpus=$half you get all cores
> > > instead of half the cores.
> > > 
> > > OTOH it does make linear iteration of the cpus 'funny' :-)
> > 
> > Like I said, firmware bug.  Seems like the fix should be there as well.
> > Perhaps there needs to be two CPU numberings, one for people wanting
> > whole cores and another for people who want cache locality.  Yes, this
> > could be confusing, but keep in mind that you are asking every kernel
> > subsystem to keep its own version of the cache-locality numbering,
> > and that will be even more confusing.
> 
> I really don't see why it would matter, as far I care they're completely
> randomized on boot, its all done using cpu-bitmasks anyway.
> 
> Suppose the linear thing would have threads/cores/cache continuity like
> you want, that still leaves the node interconnects, and we all know
> people love to be creative with those, no way you're going to fold that
> into a linear scheme :-)
> 
> Anyway, as it currently stands I can offer you: cpus_share_cache(),
> which will return true/false depending on if the two cpus do indeed
> share a cache.
> 
> On top of that there's node_distance(), which will (hopefully) reflect
> the interconnect topology between nodes.
> 
> Using these you can construct enough of the topology layout to be
> useful. NOTE: node topologies don't need to be symmetric!

One difference between RCU and the scheduler is that scheduler needs
to worry not just about its own accesses, but also those of the user
processes.  If RCU chooses a suboptimal mapping for the rcu_node tree,
it matter only a few times per grace period per CPU.  On the other hand,
if the scheduler chooses a suboptimal migration for a task, or suboptimal
placement for a pair of tasks, a potentially very large number of access
by those tasks are affected.

> > > Also, a fanout of 16 is nice when your machine doesn't have HT and has a
> > > 2^n core count, but some popular machines these days have 6/10 cores per
> > > socket, resulting in your fanout splitting caches.
> > 
> > That is easy.  Such systems can set CONFIG_RCU_FANOUT to 6, 12, 10,
> > or 20, depending on preference.  With a patch intended for 3.6, they
> > could set the smallest reasonable value at build time and adjust to
> > the hardware using the boot parameter.
> > 
> > http://www.gossamer-threads.com/lists/linux/kernel/1524864
> > 
> > I expect to make other similar changes over time, but will be proceeding
> > cautiously.
> 
> I can very easily give you the size (nr cpus in) a node, still as long
> as you iterate the cpu space linearly that's not going to be much help.

Grace-period setup and quiescent-state forcing does iterate linearly.

> I can also offer you access to the scheduler topology if you want.. I've
> got the below patch pending which should (hopefully) improve the
> scheduler's node topology -- it implements that detection based on
> node_distance().
> 
> I've tested it using some fake-numa hacks to feed it the distance table
> of an AMD quad-socket Magny-Cours:
> 
>  "numa=fake=8:10,16,16,22,16,22,16,22,
>               16,10,22,16,22,16,22,16,
>               16,22,10,16,16,22,16,22,
>               22,16,16,10,22,16,22,16,
>               16,22,16,22,10,16,16,22,
>               22,16,22,16,16,10,22,16,
>               16,22,16,22,16,22,10,16,
>               22,16,22,16,22,16,16,10"

Interesting!  A few probably clueless questions and comments below.

							Thanx, Paul

> ---
> Subject: sched: Rewrite the CONFIG_NUMA sched domain support.
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Apr 17 15:49:36 CEST 2012
> 
> The current code groups up to 16 nodes in a level and then puts an
> ALLNODES domain spanning the entire tree on top of that. This doesn't
> reflect the numa topology and esp for the smaller not-fully-connected
> machines out there today this might make a difference.
> 
> Therefore, build a proper numa topology based on node_distance().
> 
> TODO: figure out a way to set SD_flags based on distance such that
>       we disable various expensive load-balancing features at some
>       point and increase the balance interval prop. to the distance.
> 
> Cc: Anton Blanchard <anton@samba.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: linux-alpha@vger.kernel.org
> Cc: linux-ia64@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-mips@linux-mips.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: linux-sh@vger.kernel.org
> Cc: Matt Turner <mattst88@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: sparclinux@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: x86@kernel.org
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-fgj6245hxj61qe8vy7c6cmjj@git.kernel.org
> ---
>  arch/powerpc/include/asm/topology.h |    6 
>  arch/x86/include/asm/topology.h     |   38 -----
>  include/linux/topology.h            |   36 -----
>  kernel/sched/core.c                 |  253 ++++++++++++++++++++++--------------
>  4 files changed, 158 insertions(+), 175 deletions(-)
> 
> Index: linux-2.6/include/linux/topology.h
> ===================================================================
> --- linux-2.6.orig/include/linux/topology.h
> +++ linux-2.6/include/linux/topology.h
> @@ -176,48 +176,12 @@ int arch_update_cpu_topology(void);
>  }
>  #endif
> 
> -/* sched_domains SD_ALLNODES_INIT for NUMA machines */
> -#define SD_ALLNODES_INIT (struct sched_domain) {			\
> -	.min_interval		= 64,					\
> -	.max_interval		= 64*num_online_cpus(),			\
> -	.busy_factor		= 128,					\
> -	.imbalance_pct		= 133,					\
> -	.cache_nice_tries	= 1,					\
> -	.busy_idx		= 3,					\
> -	.idle_idx		= 3,					\
> -	.flags			= 1*SD_LOAD_BALANCE			\
> -				| 1*SD_BALANCE_NEWIDLE			\
> -				| 0*SD_BALANCE_EXEC			\
> -				| 0*SD_BALANCE_FORK			\
> -				| 0*SD_BALANCE_WAKE			\
> -				| 0*SD_WAKE_AFFINE			\
> -				| 0*SD_SHARE_CPUPOWER			\
> -				| 0*SD_POWERSAVINGS_BALANCE		\
> -				| 0*SD_SHARE_PKG_RESOURCES		\
> -				| 1*SD_SERIALIZE			\
> -				| 0*SD_PREFER_SIBLING			\
> -				,					\
> -	.last_balance		= jiffies,				\
> -	.balance_interval	= 64,					\
> -}
> -
> -#ifndef SD_NODES_PER_DOMAIN
> -#define SD_NODES_PER_DOMAIN 16
> -#endif
> -
>  #ifdef CONFIG_SCHED_BOOK
>  #ifndef SD_BOOK_INIT
>  #error Please define an appropriate SD_BOOK_INIT in include/asm/topology.h!!!
>  #endif
>  #endif /* CONFIG_SCHED_BOOK */
> 
> -#ifdef CONFIG_NUMA
> -#ifndef SD_NODE_INIT
> -#error Please define an appropriate SD_NODE_INIT in include/asm/topology.h!!!
> -#endif
> -
> -#endif /* CONFIG_NUMA */
> -
>  #ifdef CONFIG_USE_PERCPU_NUMA_NODE_ID
>  DECLARE_PER_CPU(int, numa_node);
> 
> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -5560,7 +5560,8 @@ static int sched_domain_debug_one(struct
>  			break;
>  		}
> 
> -		if (cpumask_intersects(groupmask, sched_group_cpus(group))) {
> +		if (!(sd->flags & SD_OVERLAP) &&
> +		    cpumask_intersects(groupmask, sched_group_cpus(group))) {
>  			printk(KERN_CONT "\n");
>  			printk(KERN_ERR "ERROR: repeated CPUs\n");
>  			break;
> @@ -5898,92 +5899,6 @@ static int __init isolated_cpu_setup(cha
> 
>  __setup("isolcpus=", isolated_cpu_setup);
> 
> -#ifdef CONFIG_NUMA
> -
> -/**
> - * find_next_best_node - find the next node to include in a sched_domain
> - * @node: node whose sched_domain we're building
> - * @used_nodes: nodes already in the sched_domain
> - *
> - * Find the next node to include in a given scheduling domain. Simply
> - * finds the closest node not already in the @used_nodes map.
> - *
> - * Should use nodemask_t.
> - */
> -static int find_next_best_node(int node, nodemask_t *used_nodes)
> -{
> -	int i, n, val, min_val, best_node = -1;
> -
> -	min_val = INT_MAX;
> -
> -	for (i = 0; i < nr_node_ids; i++) {
> -		/* Start at @node */
> -		n = (node + i) % nr_node_ids;
> -
> -		if (!nr_cpus_node(n))
> -			continue;
> -
> -		/* Skip already used nodes */
> -		if (node_isset(n, *used_nodes))
> -			continue;
> -
> -		/* Simple min distance search */
> -		val = node_distance(node, n);
> -
> -		if (val < min_val) {
> -			min_val = val;
> -			best_node = n;
> -		}
> -	}
> -
> -	if (best_node != -1)
> -		node_set(best_node, *used_nodes);
> -	return best_node;
> -}
> -
> -/**
> - * sched_domain_node_span - get a cpumask for a node's sched_domain
> - * @node: node whose cpumask we're constructing
> - * @span: resulting cpumask
> - *
> - * Given a node, construct a good cpumask for its sched_domain to span. It
> - * should be one that prevents unnecessary balancing, but also spreads tasks
> - * out optimally.
> - */
> -static void sched_domain_node_span(int node, struct cpumask *span)
> -{
> -	nodemask_t used_nodes;
> -	int i;
> -
> -	cpumask_clear(span);
> -	nodes_clear(used_nodes);
> -
> -	cpumask_or(span, span, cpumask_of_node(node));
> -	node_set(node, used_nodes);
> -
> -	for (i = 1; i < SD_NODES_PER_DOMAIN; i++) {
> -		int next_node = find_next_best_node(node, &used_nodes);
> -		if (next_node < 0)
> -			break;
> -		cpumask_or(span, span, cpumask_of_node(next_node));
> -	}
> -}
> -
> -static const struct cpumask *cpu_node_mask(int cpu)
> -{
> -	lockdep_assert_held(&sched_domains_mutex);
> -
> -	sched_domain_node_span(cpu_to_node(cpu), sched_domains_tmpmask);
> -
> -	return sched_domains_tmpmask;
> -}
> -
> -static const struct cpumask *cpu_allnodes_mask(int cpu)
> -{
> -	return cpu_possible_mask;
> -}
> -#endif /* CONFIG_NUMA */
> -
>  static const struct cpumask *cpu_cpu_mask(int cpu)
>  {
>  	return cpumask_of_node(cpu_to_node(cpu));
> @@ -6020,6 +5935,7 @@ struct sched_domain_topology_level {
>  	sched_domain_init_f init;
>  	sched_domain_mask_f mask;
>  	int		    flags;
> +	int		    numa_level;
>  	struct sd_data      data;
>  };
> 
> @@ -6211,10 +6127,6 @@ sd_init_##type(struct sched_domain_topol
>  }
> 
>  SD_INIT_FUNC(CPU)
> -#ifdef CONFIG_NUMA
> - SD_INIT_FUNC(ALLNODES)
> - SD_INIT_FUNC(NODE)
> -#endif
>  #ifdef CONFIG_SCHED_SMT
>   SD_INIT_FUNC(SIBLING)
>  #endif
> @@ -6336,15 +6248,164 @@ static struct sched_domain_topology_leve
>  	{ sd_init_BOOK, cpu_book_mask, },
>  #endif
>  	{ sd_init_CPU, cpu_cpu_mask, },
> -#ifdef CONFIG_NUMA
> -	{ sd_init_NODE, cpu_node_mask, SDTL_OVERLAP, },
> -	{ sd_init_ALLNODES, cpu_allnodes_mask, },
> -#endif
>  	{ NULL, },
>  };
> 
>  static struct sched_domain_topology_level *sched_domain_topology = default_topology;
> 
> +#ifdef CONFIG_NUMA
> +
> +static int sched_domains_numa_levels;
> +static int sched_domains_numa_scale;
> +static int *sched_domains_numa_distance;
> +static struct cpumask ** __percpu sched_domains_numa_masks;
> +static int sched_domains_curr_level;
> +
> +#define NUMA_SCALE(x, level)	\
> +
> +static inline unsigned long numa_scale(unsigned long x, int level)
> +{
> +	return x * sched_domains_numa_distance[level] / sched_domains_numa_scale;
> +}
> +
> +static inline int sd_local_flags(int level)
> +{
> +	if (sched_domains_numa_distance[level] > REMOTE_DISTANCE)
> +		return 0;
> +
> +	return SD_BALANCE_EXEC | SD_BALANCE_FORK | SD_WAKE_AFFINE;
> +}
> +
> +static struct sched_domain *
> +sd_init_NUMA(struct sched_domain_topology_level *tl, int cpu)
> +{
> +	struct sched_domain *sd = *per_cpu_ptr(tl->data.sd, cpu);
> +	int level = tl->numa_level;
> +	int sd_weight = cpumask_weight(per_cpu_ptr(
> +				sched_domains_numa_masks[level],
> +				cpu));
> +
> +	*sd = (struct sched_domain){
> +		.min_interval		= sd_weight,
> +		.max_interval		= 2*sd_weight,
> +		.busy_factor		= 32,
> +		.imbalance_pct		= 100 + numa_scale(25, level),
> +		.cache_nice_tries	= 2,
> +		.busy_idx		= 3,
> +		.idle_idx		= 2,
> +		.newidle_idx		= 0,
> +		.wake_idx		= 0,
> +		.forkexec_idx		= 0,
> +
> +		.flags			= 1*SD_LOAD_BALANCE
> +					| 1*SD_BALANCE_NEWIDLE
> +					| 0*SD_BALANCE_EXEC
> +					| 0*SD_BALANCE_FORK
> +					| 0*SD_BALANCE_WAKE
> +					| 0*SD_WAKE_AFFINE
> +					| 0*SD_PREFER_LOCAL
> +					| 0*SD_SHARE_CPUPOWER
> +					| 0*SD_POWERSAVINGS_BALANCE
> +					| 0*SD_SHARE_PKG_RESOURCES
> +					| 1*SD_SERIALIZE
> +					| 0*SD_PREFER_SIBLING
> +					| sd_local_flags(level)
> +					,
> +		.last_balance		= jiffies,
> +		.balance_interval	= sd_weight,
> +	};
> +	SD_INIT_NAME(sd, NUMA);
> +	sd->private = &tl->data;
> +
> +	/*
> +	 * Ugly hack to pass state to sd_numa_mask()...
> +	 */
> +	sched_domains_curr_level = tl->numa_level;
> +
> +	return sd;
> +}
> +
> +static const struct cpumask *sd_numa_mask(int cpu)
> +{
> +	return per_cpu_ptr(sched_domains_numa_masks[sched_domains_curr_level], cpu);
> +}
> +
> +static void sched_init_numa(void)
> +{
> +	int next_distance, curr_distance = node_distance(0, 0);
> +	struct sched_domain_topology_level *tl;
> +	int level = 0;
> +	int i, j, k;
> +
> +	sched_domains_numa_scale = curr_distance;
> +	sched_domains_numa_distance = kzalloc(sizeof(int) * nr_node_ids, GFP_KERNEL);
> +	if (!sched_domains_numa_distance)
> +		return;
> +
> +	next_distance = curr_distance;
> +	for (i = 0; i < nr_node_ids; i++) {
> +		for (j = 0; j < nr_node_ids; j++) {
> +			int distance = node_distance(0, j);

Shouldn't this be "node_distance(i, j)"?

Actually, I don't see any use of "i" in this loop anywhere, which seems
strange.

> +			if (distance > curr_distance &&
> +					(distance < next_distance ||
> +					 next_distance == curr_distance))
> +				next_distance = distance;
> +		}
> +		if (next_distance != curr_distance) {
> +			sched_domains_numa_distance[level++] = next_distance;
> +			sched_domains_numa_levels = level;

I don't understand the intent here.  One approach would be to have
one sched_domains_numa_distance[] array per node, with distances
in each array sorted by increasing distance from the array's node.

As it is, I believe you get N copies of the sorted distances from
node 0 in an array that is only guaranteed to be big enough for 1 copy.
Unless you know something about the node_distance() matrix that limits
the number of distinct values.

> +			curr_distance = next_distance;
> +		} else break;
> +	}

The above loop seems to be doing a selection sort eliminating duplicates.
Would it make sense to put a real sort implementation into lib/?

> +
> +	sched_domains_numa_masks = kzalloc(sizeof(void *) * level, GFP_KERNEL);
> +	if (!sched_domains_numa_masks)
> +		return;
> +
> +	for (i = 0; i < level; i++) {
> +		sched_domains_numa_masks[i] = alloc_percpu(cpumask_t);
> +		if (!sched_domains_numa_masks[i])
> +			return;
> +
> +		for_each_possible_cpu(j) {
> +			struct cpumask *mask =
> +				per_cpu_ptr(sched_domains_numa_masks[i], j);
> +
> +			for (k = 0; k < nr_node_ids; k++) {
> +				if (node_distance(cpu_to_node(j), k) >
> +						sched_domains_numa_distance[i])
> +					continue;
> +
> +				cpumask_or(mask, mask, cpumask_of_node(k));
> +			}
> +		}
> +	}

OK, if we can assume that the node distances are symmetric, so that
node_distance(i, j) == node_distance(j, i), I think I see what you
are getting at, though I am having a hard time seeing how to pack
it into a linear array.

The idea seems to be to compute a per-CPU list of CPU masks, with the first
entry having bits set for the CPUs closest to the CPU corresponding to
the list, and subsequent entries adding more-distant CPUs.  The last
CPU mask would presumably have bits set for all CPUs.

I take it that there is no data structure listing per-node CPU masks,
indicating which CPUs are members of a given node?  Or is something else
going on here?

> +
> +	tl = kzalloc((ARRAY_SIZE(default_topology) + level) *
> +			sizeof(struct sched_domain_topology_level), GFP_KERNEL);
> +	if (!tl)
> +		return;
> +
> +	for (i = 0; default_topology[i].init; i++)
> +		tl[i] = default_topology[i];
> +
> +	for (j = 0; j < level; i++, j++) {
> +		tl[i] = (struct sched_domain_topology_level){

tl[j]?

> +			.init = sd_init_NUMA,
> +			.mask = sd_numa_mask,
> +			.flags = SDTL_OVERLAP,
> +			.numa_level = j,
> +		};
> +	}
> +
> +	sched_domain_topology = tl;
> +}
> +#else
> +static inline void sched_init_numa(void)
> +{
> +}
> +#endif /* CONFIG_NUMA */
> +
>  static int __sdt_alloc(const struct cpumask *cpu_map)
>  {
>  	struct sched_domain_topology_level *tl;
> @@ -6828,6 +6889,8 @@ void __init sched_init_smp(void)
>  	alloc_cpumask_var(&non_isolated_cpus, GFP_KERNEL);
>  	alloc_cpumask_var(&fallback_doms, GFP_KERNEL);
> 
> +	sched_init_numa();
> +
>  	get_online_cpus();
>  	mutex_lock(&sched_domains_mutex);
>  	init_sched_domains(cpu_active_mask);
> Index: linux-2.6/arch/powerpc/include/asm/topology.h
> ===================================================================
> --- linux-2.6.orig/arch/powerpc/include/asm/topology.h
> +++ linux-2.6/arch/powerpc/include/asm/topology.h
> @@ -18,12 +18,6 @@ struct device_node;
>   */
>  #define RECLAIM_DISTANCE 10
> 
> -/*
> - * Avoid creating an extra level of balancing (SD_ALLNODES) on the largest
> - * POWER7 boxes which have a maximum of 32 nodes.
> - */
> -#define SD_NODES_PER_DOMAIN 32
> -
>  #include <asm/mmzone.h>
> 
>  static inline int cpu_to_node(int cpu)
> Index: linux-2.6/arch/x86/include/asm/topology.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/topology.h
> +++ linux-2.6/arch/x86/include/asm/topology.h
> @@ -92,44 +92,6 @@ extern void setup_node_to_cpumask_map(vo
> 
>  #define pcibus_to_node(bus) __pcibus_to_node(bus)
> 
> -#ifdef CONFIG_X86_32
> -# define SD_CACHE_NICE_TRIES	1
> -# define SD_IDLE_IDX		1
> -#else
> -# define SD_CACHE_NICE_TRIES	2
> -# define SD_IDLE_IDX		2
> -#endif
> -
> -/* sched_domains SD_NODE_INIT for NUMA machines */
> -#define SD_NODE_INIT (struct sched_domain) {				\
> -	.min_interval		= 8,					\
> -	.max_interval		= 32,					\
> -	.busy_factor		= 32,					\
> -	.imbalance_pct		= 125,					\
> -	.cache_nice_tries	= SD_CACHE_NICE_TRIES,			\
> -	.busy_idx		= 3,					\
> -	.idle_idx		= SD_IDLE_IDX,				\
> -	.newidle_idx		= 0,					\
> -	.wake_idx		= 0,					\
> -	.forkexec_idx		= 0,					\
> -									\
> -	.flags			= 1*SD_LOAD_BALANCE			\
> -				| 1*SD_BALANCE_NEWIDLE			\
> -				| 1*SD_BALANCE_EXEC			\
> -				| 1*SD_BALANCE_FORK			\
> -				| 0*SD_BALANCE_WAKE			\
> -				| 1*SD_WAKE_AFFINE			\
> -				| 0*SD_PREFER_LOCAL			\
> -				| 0*SD_SHARE_CPUPOWER			\
> -				| 0*SD_POWERSAVINGS_BALANCE		\
> -				| 0*SD_SHARE_PKG_RESOURCES		\
> -				| 1*SD_SERIALIZE			\
> -				| 0*SD_PREFER_SIBLING			\
> -				,					\
> -	.last_balance		= jiffies,				\
> -	.balance_interval	= 1,					\
> -}
> -
>  extern int __node_distance(int, int);
>  #define node_distance(a, b) __node_distance(a, b)
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

