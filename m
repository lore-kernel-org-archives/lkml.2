Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2EXNR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 09:17:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:41222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632Ab2EXNRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 09:17:25 -0400
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on
 westmere
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mike Galbraith <efault@gmx.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
In-Reply-To: <1337857490.7300.19.camel@marge.simpson.net>
References: <1337857490.7300.19.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 May 2012 15:17:11 +0200
Message-ID: <1337865431.9783.148.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 13:04 +0200, Mike Galbraith wrote:
> sched: fix select_idle_sibling() induced bouncing
> 
> Traversing an entire package is not only expensive, it also leads to tasks
> bouncing all over a partially idle and possible quite large package.  Fix
> that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
> to motivate that one other CPU, if it's busy, tough, it may then try it's
> SMT sibling, but that's all this optimization is allowed to cost.
> 
> Sibling cache buddies are cross-wired to prevent bouncing.
> 
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> 
> ---
>  include/linux/sched.h |    1 +
>  kernel/sched/core.c   |   40 +++++++++++++++++++++++++++++++++++++++-
>  kernel/sched/fair.c   |   28 +++++++++-------------------
>  3 files changed, 49 insertions(+), 20 deletions(-)
> 
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -928,6 +928,7 @@ struct sched_domain {
>         struct sched_domain *parent;    /* top domain must be null terminated */
>         struct sched_domain *child;     /* bottom domain must be null terminated */
>         struct sched_group *groups;     /* the balancing groups of the domain */
> +       struct sched_group *sibling;    /* group assigned to select_idle_sibling() */

A better name would be idle_sibling, or possibly idle_buddy.

Sibling is oft times understood to mean SMT-sibling, confusion reigns.

Also, it looks like you're explicitly going down the sched_domains to a
single cpu group. If that's the exact purpose of this, to point to a
particular cpu, make it an int and do away with the group/cpumask bits.

>         unsigned long min_interval;     /* Minimum balance interval ms */
>         unsigned long max_interval;     /* Maximum balance interval ms */
>         unsigned int busy_factor;       /* less balancing by factor if busy */
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5888,9 +5888,47 @@ static void update_top_cache_domain(int
>         int id = cpu;
>  
>         sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> -       if (sd)
> +       if (sd) {
> +               struct sched_domain *tmp = sd;
> +               struct sched_group *sg = tmp->groups, *prev = sg;
> +               int smt = 0, right = 1;
> +
>                 id = cpumask_first(sched_domain_span(sd));
>  
> +               /*
> +                * Assign a 'buddy' CPU for select_idle_sibling()
> +                * to try to motivate.  These point at each other
> +                * at the MC level, and at own sibling at SIBLING
> +                * to prevent mad bouncing of tasks on a package
> +                * with many cores/siblings.
> +                */
> +               while (cpumask_first(sched_group_cpus(sg)) != id)
> +                       sg = sg->next;

ok, because we're staring at @cpu's sched domains, @id need not be in
the first group.

> +               /*
> +                * Ok, have first group, should we point right or left?
> +                * sg is tmp->groups again when done, ie our group.
> +                */
> +               while (!cpumask_test_cpu(cpu, sched_group_cpus(sg))) {
> +                       prev = sg;
> +                       sg = sg->next;
> +                       right = !right;
> +               }

Slightly confused by this.. So we find @id's group, then we iterate
until we find @cpu's group (sd->groups in fact), but need the iteration
count to find if its even or odd numbered.

Now couldn't you have used the iteration count on the first while()
loop?

> +               /* A CPU went down, never point back to package start. */
> +               if (right && cpumask_first(sched_group_cpus(sg->next)) == id)
> +                       right = 0;

Slightly more confusion, unplugged cpus aren't part of the sched_domain
structure...

> +               sg = right ? sg->next : prev;

So if it was odd we go one more, if it was even we go one back..

Suppose we have 6 cores sharing a cache and no smt, then cpu0 would have
no iterations and right == 1, so we pick cpu1. cpu1 will end up on cpu0
and we continue like 3-4 4-3 etc.

> +               do {
> +                       if (smt)
> +                               sg = tmp->groups->next;
> +                       rcu_assign_pointer(tmp->sibling, sg);
> +                       smt = 1;
> +               } while ((tmp = tmp->child));

Oh, wait we keep a ->sibling pointer for each level.. 

So here we go down, somehow always picking the second smt sibling:

   core0      core1

 smt0 smt1   smt0 smt1

So cpu0 would end up at smt1, cpu1 would end up at smt0, crossing them
nicely.

For power7 with 4 smt it would end up as 1230 I guess.

So if we then make it a 6 core 2 smt machine we get:

core 0->1, 1->0, 2->3, 3->2 etc..

but at the same time we get the smt stuff.. I suppose you mean to select
an SMT sibling from core1, however your tmp = tmp->child goes down the
topology on core0, selecting core0 threads instead.

Surely that's not the intention?

> +       }
> +
>         rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
>         per_cpu(sd_llc_id, cpu) = id;
>  }
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2655,29 +2655,19 @@ static int select_idle_sibling(struct ta
>                 return prev_cpu;
>  
>         /*
> +        * Otherwise, check assigned siblings to find an elegible idle cpu.
>          */
>         sd = rcu_dereference(per_cpu(sd_llc, target));
> +       for_each_lower_domain(sd) {
> +               sg = rcu_dereference(sd->sibling);
> +               for_each_cpu_and(i, sched_group_cpus(sg), tsk_cpus_allowed(p)) {
> +                       if (idle_cpu(i))
> +                               return i;
> +                       break;
> +               }

Ah, I think I see the smt thing..

So suppose cpu0 on our 6 core 2 thread system is doing its thing here,
the first round will try both threads from core1, the second level will
then try our own smt sibling.

>         }
> +
>         return target;
>  }

And I guess the performance improvement comes from simply doing less
work, right?

Did you do you numbers with the distro NR_CPUS=4096 bloat?

Somewhat related, Arjan recently told me we should try and avoid waking
an idle core for tasks that will run very short. Now currently we don't
have runtime estimation (anymore), but pjt's load tracking stuff would
re-introduce that.

Now if only pjt would re-surface... :-)

