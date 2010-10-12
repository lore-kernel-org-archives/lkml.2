Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab0JLJec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 05:34:32 -0400
Received: from ifrit.dereferenced.org ([66.212.21.15]:51998 "EHLO
	ifrit.dereferenced.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab0JLJeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 05:34:31 -0400
Date: Tue, 12 Oct 2010 13:34:26 +0400 (MSD)
From: William Pitcock <nenolod@dereferenced.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Message-ID: <3040100.1691286876066434.JavaMail.root@ifrit.dereferenced.org>
In-Reply-To: <29349823.1671286875856124.JavaMail.root@ifrit.dereferenced.org>
Subject: Re: [PATCH try 3] CFS: Add hierarchical tree-based penalty.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.202.104.35]
X-Mailer: Zimbra 6.0.0_BETA2_1547.UBUNTU8 (ZimbraWebClient - FF3.0 (Linux)/6.0.0_BETA2_1547.UBUNTU8)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- "Peter Zijlstra" <peterz@infradead.org> wrote:

> It's customary to CC people who work on the code you patch...

Please take a look at the revised patch I just sent to the list.

> 
> On Tue, 2010-10-12 at 00:32 -0500, William Pitcock wrote:
> > Inspired by the recent change to BFS by Con Kolivas, this patch
> causes
> > vruntime to be penalized based on parent depth from their root task
> > group.
> > 
> > I have, for the moment, decided to make it a default feature since
> the
> > design of CFS ensures that broken applications depending on task
> enqueue
> > behaviour behaving traditionally will continue to work.
> > 
> > My method for applying the penalty is different than that of BFS,
> it
> > divides the vruntime by the number of parents the process has.
> 
> Aside from the funny semantic error in your sentence there (every
> process can, by definition, only have one parent), the patch doesn't
> look quite right either.
> 
> 
> > Signed-off-by: William Pitcock <nenolod@dereferenced.org>
> > ---
> >  include/linux/sched.h   |    2 ++
> >  kernel/sched.c          |    4 ++++
> >  kernel/sched_fair.c     |    8 ++++++++
> >  kernel/sched_features.h |   12 ++++++++++++
> >  4 files changed, 26 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index 1e2a6db..7b44f98 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1494,6 +1494,8 @@ struct task_struct {
> >  		unsigned long memsw_bytes; /* uncharged mem+swap usage */
> >  	} memcg_batch;
> >  #endif
> > +
> > +	int parent_count;
> >  };
> 
> so copy_process() will make a child inherit the parent_count from the
> parent.
> 
> >  /* Future-safe accessor for struct task_struct's cpus_allowed. */
> > diff --git a/kernel/sched.c b/kernel/sched.c
> > index dc85ceb..16ad939 100644
> > --- a/kernel/sched.c
> > +++ b/kernel/sched.c
> > @@ -2621,6 +2621,10 @@ void wake_up_new_task(struct task_struct *p,
> unsigned long clone_flags)
> >  #endif
> >  
> >  	rq = task_rq_lock(p, &flags);
> > +
> > +	if (!(clone_flags & CLONE_THREAD))
> > +		p->parent_count++;
> > +
> 
> And we increment it for every new !THREAD child, so its basically a
> task
> depth counter, except it doesn't take re-parenting into account.

I renamed it to fork_depth, which is what BFS uses to describe this
variable.  It may be better to put this in sched_entity, however.

> 
> >  	activate_task(rq, p, 0);
> >  	trace_sched_wakeup_new(p, 1);
> >  	check_preempt_curr(rq, p, WF_FORK);
> > diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> > index db3f674..3f17ec1 100644
> > --- a/kernel/sched_fair.c
> > +++ b/kernel/sched_fair.c
> > @@ -737,6 +737,14 @@ place_entity(struct cfs_rq *cfs_rq, struct
> sched_entity *se, int initial)
> >  	if (initial && sched_feat(START_DEBIT))
> >  		vruntime += sched_vslice(cfs_rq, se);
> >  
> > +	if (sched_feat(HIERARCHICAL_PENALTY)) {
> > +		struct task_struct *tsk = task_of(se);
> > +
> 
> And here you have a bug,.. there is no guarantee se is actually a
> task.
> Which means you're dereferencing random memory here:

I am now checking this with entity_is_task() in the newest version.

> 
> > +		if (tsk->parent_count > 1)
> > +			vruntime = max_vruntime(vruntime,
> > +						vruntime / tsk->parent_count);
> 
> Aside from the wrap issue, that is a NOP statement.
> 
> x / y < x : y > 1, therefore, max(x, x/y) == x and you wrote, x = x;
> 
> Furthermore, vruntime here is an absolute measure of service,
> dividing
> that by anything reduces the total amount of service the task
> received
> during its history, doing so for y > 1 means at least halving it,
> which
> again means that you basically end up with:
> 
>   se->vruntime = se->vruntime;
> 
> Due to the final few statements in place_entity():
> 
>   se->vruntime = max_vruntime(se->vruntime, vruntime);
> 
> What I think you meant to do was proportionally decrease the relative
> placement of the new task by the task-depth, or something like that.

Yes, this should be a multiplication I believe, not a divide.  My original
code had this as a multiplication, not a division, as does the new patch.

However, I think:

    vruntime >>= tsk->fork_depth;

would do the job just as well and be faster.

I would be glad to know what you think about this.

William
