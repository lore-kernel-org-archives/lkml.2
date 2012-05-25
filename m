Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2EYGIg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 02:08:36 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:58432 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751283Ab2EYGIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 02:08:35 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19nhD0/P5tn8GNoZULHvkfEplAX2cj8FlEcaftZ/K
	8gYvVV2RP75fnA
Message-ID: <1337926109.5415.43.camel@marge.simpson.net>
Subject: Re: [rfc][patch] select_idle_sibling() inducing bouncing on westmere
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Paul Turner <pjt@google.com>, Arjan Van De Ven <arjan@linux.intel.com>
Date: Fri, 25 May 2012 08:08:29 +0200
In-Reply-To: <1337865431.9783.148.camel@laptop>
References: <1337857490.7300.19.camel@marge.simpson.net>
	 <1337865431.9783.148.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-24 at 15:17 +0200, Peter Zijlstra wrote:
> On Thu, 2012-05-24 at 13:04 +0200, Mike Galbraith wrote:
> > sched: fix select_idle_sibling() induced bouncing
> > 
> > Traversing an entire package is not only expensive, it also leads to tasks
> > bouncing all over a partially idle and possible quite large package.  Fix
> > that up by assigning a 'buddy' CPU to try to motivate.  Each buddy may try
> > to motivate that one other CPU, if it's busy, tough, it may then try it's
> > SMT sibling, but that's all this optimization is allowed to cost.
> > 
> > Sibling cache buddies are cross-wired to prevent bouncing.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > 
> > ---
> >  include/linux/sched.h |    1 +
> >  kernel/sched/core.c   |   40 +++++++++++++++++++++++++++++++++++++++-
> >  kernel/sched/fair.c   |   28 +++++++++-------------------
> >  3 files changed, 49 insertions(+), 20 deletions(-)
> > 
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -928,6 +928,7 @@ struct sched_domain {
> >         struct sched_domain *parent;    /* top domain must be null terminated */
> >         struct sched_domain *child;     /* bottom domain must be null terminated */
> >         struct sched_group *groups;     /* the balancing groups of the domain */
> > +       struct sched_group *sibling;    /* group assigned to select_idle_sibling() */
> 
> A better name would be idle_sibling, or possibly idle_buddy.

I'll give it a better name.

> Sibling is oft times understood to mean SMT-sibling, confusion reigns.

Yeah, select_idle_sibling() itself is misnamed.

> Also, it looks like you're explicitly going down the sched_domains to a
> single cpu group. If that's the exact purpose of this, to point to a
> particular cpu, make it an int and do away with the group/cpumask bits.

I did that, but it didn't seem to make any measurable difference.
There's also the SMT siblings > 2 you mentioned below, which may want
the pointer, dunno, so I went back to the group pointer.  Besides, then
I think I need barriers, which make my ears emit black smoke :)

> > +               /*
> > +                * Ok, have first group, should we point right or left?
> > +                * sg is tmp->groups again when done, ie our group.
> > +                */
> > +               while (!cpumask_test_cpu(cpu, sched_group_cpus(sg))) {
> > +                       prev = sg;
> > +                       sg = sg->next;
> > +                       right = !right;
> > +               }
> 
> Slightly confused by this.. So we find @id's group, then we iterate
> until we find @cpu's group (sd->groups in fact), but need the iteration
> count to find if its even or odd numbered.
> 
> Now couldn't you have used the iteration count on the first while()
> loop?

Mmm, maybe.

> > +               /* A CPU went down, never point back to package start. */
> > +               if (right && cpumask_first(sched_group_cpus(sg->next)) == id)
> > +                       right = 0;
> 
> Slightly more confusion, unplugged cpus aren't part of the sched_domain
> structure...

Drop a core, you end up with an odd man out.  Thought was, the last
thing you want is anyone pointing around the bend.  Maybe odd man should
be a dead end instead, did that first, but it didn't feel right.

> > +               sg = right ? sg->next : prev;
> 
> So if it was odd we go one more, if it was even we go one back..
> 
> Suppose we have 6 cores sharing a cache and no smt, then cpu0 would have
> no iterations and right == 1, so we pick cpu1. cpu1 will end up on cpu0
> and we continue like 3-4 4-3 etc.

Yeah, keep waker/wakee pegged cross core, to convert overlap, and keep
their footprint intact instead of dragging it around.  'course for 100%
sync microbench like pipe-test, cross-core is a complete disaster on
westmere, but most real loads don't do nothing but schedule :)

> > +               do {
> > +                       if (smt)
> > +                               sg = tmp->groups->next;
> > +                       rcu_assign_pointer(tmp->sibling, sg);
> > +                       smt = 1;
> > +               } while ((tmp = tmp->child));
> 
> Oh, wait we keep a ->sibling pointer for each level.. 
> 
> So here we go down, somehow always picking the second smt sibling:
> 
>    core0      core1
> 
>  smt0 smt1   smt0 smt1
> 
> So cpu0 would end up at smt1, cpu1 would end up at smt0, crossing them
> nicely.

Yeah.

> For power7 with 4 smt it would end up as 1230 I guess.

I pondered >2*SMT, and what to do with way too many damn siblings but
left it for now, need a power box to play with.

> So if we then make it a 6 core 2 smt machine we get:
> 
> core 0->1, 1->0, 2->3, 3->2 etc..
> 
> but at the same time we get the smt stuff.. I suppose you mean to select
> an SMT sibling from core1, however your tmp = tmp->child goes down the
> topology on core0, selecting core0 threads instead.

printk() said I did it right.  Guess I'd better double check that.

> Surely that's not the intention?
> 
> > +       }
> > +
> >         rcu_assign_pointer(per_cpu(sd_llc, cpu), sd);
> >         per_cpu(sd_llc_id, cpu) = id;
> >  }
> > --- a/kernel/sched/fair.c
> > +++ b/kernel/sched/fair.c
> > @@ -2655,29 +2655,19 @@ static int select_idle_sibling(struct ta
> >                 return prev_cpu;
> >  
> >         /*
> > +        * Otherwise, check assigned siblings to find an elegible idle cpu.
> >          */
> >         sd = rcu_dereference(per_cpu(sd_llc, target));
> > +       for_each_lower_domain(sd) {
> > +               sg = rcu_dereference(sd->sibling);
> > +               for_each_cpu_and(i, sched_group_cpus(sg), tsk_cpus_allowed(p)) {
> > +                       if (idle_cpu(i))
> > +                               return i;
> > +                       break;
> > +               }
> 
> Ah, I think I see the smt thing..
> 
> So suppose cpu0 on our 6 core 2 thread system is doing its thing here,
> the first round will try both threads from core1, the second level will
> then try our own smt sibling.

Well, it breaks, only checks first thread of core1, but yeah.  Maybe
power7 wants it's siblings hard-wired too, dunno.

> >         }
> > +
> >         return target;
> >  }
> 
> And I guess the performance improvement comes from simply doing less
> work, right?

Not for mostly idle box, for mostly busy, yeah, should be, but I haven't
measured that.

> Did you do you numbers with the distro NR_CPUS=4096 bloat?

Yeah, I've created/destroyed more damn numbers than you can shake a
stick at.  The picture looks the same.  Plugging sibling avoidance
patches into enterprise to help compensate for lard intake 32->3.0 is
what inspired me.

> Somewhat related, Arjan recently told me we should try and avoid waking
> an idle core for tasks that will run very short. Now currently we don't
> have runtime estimation (anymore), but pjt's load tracking stuff would
> re-introduce that.

IMHO, this is the (rotten) meat.  Patchlet fixed up the bouncing pain,
but cores not getting off their lazy asses when we're explicitly telling
them to at high frequency is too horrible for words.  That little
ondemand gizmo needs a wrap upside the head.  Q6600 doesn't have this
problem, buddies are buddies all the way to the bone. 

	-Mike

