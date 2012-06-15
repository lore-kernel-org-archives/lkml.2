Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2FOWLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 18:11:42 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:40886 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2FOWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 18:11:41 -0400
Date: Fri, 15 Jun 2012 15:10:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH tip/core/rcu 01/15] rcu: Control RCU_FANOUT_LEAF from
 boot-time parameter
Message-ID: <20120615221053.GN2389@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120615210550.GA27506@linux.vnet.ibm.com>
 <1339794370-28119-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20120615214309.GS31184@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615214309.GS31184@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061522-6148-0000-0000-000006BDD53F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 02:43:09PM -0700, Josh Triplett wrote:
> On Fri, Jun 15, 2012 at 02:05:56PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > Although making RCU_FANOUT_LEAF a kernel configuration parameter rather
> > than a fixed constant makes it easier for people to decrease cache-miss
> > overhead for large systems, it is of little help for people who must
> > run a single pre-built kernel binary.
> > 
> > This commit therefore allows the value of RCU_FANOUT_LEAF to be
> > increased (but not decreased!) via a boot-time parameter named
> > rcutree.rcu_fanout_leaf.
> > 
> > Reported-by: Mike Galbraith <efault@gmx.de>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  Documentation/kernel-parameters.txt |    4 ++
> >  kernel/rcutree.c                    |   97 ++++++++++++++++++++++++++++++-----
> >  kernel/rcutree.h                    |   23 +++++----
> >  kernel/rcutree_plugin.h             |    4 +-
> >  kernel/rcutree_trace.c              |    2 +-
> >  5 files changed, 104 insertions(+), 26 deletions(-)
> > 
> > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> > index c45513d..88bd3ef 100644
> > --- a/Documentation/kernel-parameters.txt
> > +++ b/Documentation/kernel-parameters.txt
> > @@ -2367,6 +2367,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >  			Set maximum number of finished RCU callbacks to process
> >  			in one batch.
> >  
> > +	rcutree.fanout_leaf=	[KNL,BOOT]
> > +			Set maximum number of finished RCU callbacks to process
> > +			in one batch.
> 
> Copy-paste problem.

Indeed!  Good catch!

> >  	rcutree.qhimark=	[KNL,BOOT]
> >  			Set threshold of queued
> >  			RCU callbacks over which batch limiting is disabled.
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index 0da7b88..a151184 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -60,17 +60,10 @@
> >  
> >  /* Data structures. */
> >  
> > -static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
> > +static struct lock_class_key rcu_node_class[RCU_NUM_LVLS];
> 
> I assume that the requirement to only increase the fanout and never
> decrease it comes from the desire to not increase the sizes of all of
> these arrays to MAX_RCU_LVLS?

Actually, it is the node[] array in the rcu_state structure that is
of concern.

> > +/*
> > + * Compute the rcu_node tree geometry from kernel parameters.  This cannot
> > + * replace the definitions in rcutree.h because those are needed to size
> > + * the ->node array in the rcu_state structure.
> > + */
> > +static void __init rcu_init_geometry(void)
> > +{
> > +	int i;
> > +	int j;
> > +	int n = NR_CPUS;
> > +	int rcu_capacity[MAX_RCU_LVLS + 1];
> > +
> > +	/* If the compile-time values are accurate, just leave. */
> > +	if (rcu_fanout_leaf == CONFIG_RCU_FANOUT_LEAF)
> > +		return;
> > +
> > +	/*
> > +	 * Compute number of nodes that can be handled an rcu_node tree
> > +	 * with the given number of levels.  Setting rcu_capacity[0] makes
> > +	 * some of the arithmetic easier.
> > +	 */
> > +	rcu_capacity[0] = 1;
> > +	rcu_capacity[1] = rcu_fanout_leaf;
> > +	for (i = 2; i <= MAX_RCU_LVLS; i++)
> > +		rcu_capacity[i] = rcu_capacity[i - 1] * CONFIG_RCU_FANOUT;
> > +
> > +	/*
> > +	 * The boot-time rcu_fanout_leaf parameter is only permitted
> > +	 * to increase the leaf-level fanout, not decrease it.  Of course,
> > +	 * the leaf-level fanout cannot exceed the number of bits in
> > +	 * the rcu_node masks.  Finally, the tree must be able to accommodate
> > +	 * the configured number of CPUs.  Complain and fall back to the
> > +	 * compile-timer values if these limits are exceeded.
> 
> Typo: s/timer/time/

Good catch!

> > +	 */
> > +	if (rcu_fanout_leaf < CONFIG_RCU_FANOUT_LEAF ||
> > +	    rcu_fanout_leaf > sizeof(unsigned long) * 8 ||
> > +	    n > rcu_capacity[4]) {
> 
> 4 seems like a magic number here; did you mean MAX_RCU_LVLS or similar?

I believe so, good catch!  That would have been painful if another
level of the hierarchy were needed...

> Also, why have n as a variable when it never changes?

Will propagate the value unless I can come up with a good reason.  ;-)

> > --- a/kernel/rcutree.h
> > +++ b/kernel/rcutree.h
> > @@ -42,28 +42,28 @@
> >  #define RCU_FANOUT_4	      (RCU_FANOUT_3 * CONFIG_RCU_FANOUT)
> >  
> >  #if NR_CPUS <= RCU_FANOUT_1
> > -#  define NUM_RCU_LVLS	      1
> > +#  define RCU_NUM_LVLS	      1
> 
> I assume you made this change to make it easier to track down all the
> uses of the macro to change them; however, having now done so, the
> change itself seems rather gratuitous, and inconsistent with the other
> macros.  Would you consider changing it back?
> 
> > +extern int rcu_num_lvls;
> > +extern int rcu_num_nodes;
> 
> Given the above, you might also want to change these for consistency.

This might make sense.  If I run into too many conflicts, I may defer
the change to the join of the topic trees.

> Also, have you checked the various loops using these variables to figure
> out if GCC emits less optimal code now that it can't rely on a
> compile-time constant?  I don't expect it to make much of a difference,
> but it seems worth checking.

I am sure that it generates worse code, but the uses are on slowpaths,
so I really am not worried about it.

> You might also consider marking these as __read_mostly, at a minimum.

This sounds quite sensible, will do.

> > diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
> > index 2411000..e9b44c3 100644
> > --- a/kernel/rcutree_plugin.h
> > +++ b/kernel/rcutree_plugin.h
> > @@ -68,8 +68,10 @@ static void __init rcu_bootup_announce_oddness(void)
> >  	printk(KERN_INFO "\tAdditional per-CPU info printed with stalls.\n");
> >  #endif
> >  #if NUM_RCU_LVL_4 != 0
> > -	printk(KERN_INFO "\tExperimental four-level hierarchy is enabled.\n");
> > +	printk(KERN_INFO "\tFour-level hierarchy is enabled.\n");
> 
> This change seems entirely unrelated to this patch.  Seems simple enough
> to split it into a separate one-line patch ("Mark four-level hierarchy
> as no longer experimental").

Can't see why not...

> >  #endif
> > +	if (rcu_fanout_leaf != CONFIG_RCU_FANOUT_LEAF)
> > +		printk(KERN_INFO "\tExperimental boot-time adjustment of leaf fanout.\n");
> 
> You might consider printing rcu_fanout_leaf in this message.

Ouch!  Good point, will fix.

							Thanx, Paul

