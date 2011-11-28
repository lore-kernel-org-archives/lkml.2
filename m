Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab1K1OKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 09:10:25 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:23542 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab1K1OKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 09:10:23 -0500
Date: Mon, 28 Nov 2011 18:03:56 +0400
From: Andrew Vagin <avagin@openvz.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Matt Helsley <matthltc@us.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111128140356.GA27395@dhcp-10-30-18-117.sw.ru>
References: <20111128120813.GK1775@moon>
 <CANaxB-wrRd94OJifpYJ=kibx_48oJ=GE51f9GWjZ3np2nCQYsA@mail.gmail.com>
 <20111128133828.GL1775@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111128133828.GL1775@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +static int freezer_can_attach_task(struct cgroup *cgroup, struct task_struct *task)
> > > +{
> > > + š š š struct freezer *old_freezer;
> > > + š š š struct freezer *freezer;
> > > +
> > > + š š š int goal_state, orig_state;
> > > + š š š int retval = 0;
> > > +
> > > + š š š old_freezer = task_freezer(task);
> > > + š š š freezer = cgroup_freezer(cgroup);
> > > +
> > > + š š š spin_lock_irq(&freezer->lock);
> > > +
> > > + š š š if (!spin_trylock_irq(&old_freezer->lock)) {
> > > + š š š š š š š retval = -EBUSY;
> > 
> > I think EBUSY is not a good idea in this place.  We can do something
> > like double_rq_lock.
> > 
> 
> Could you please elaborate? freezers are guarded with spinlocks so I think
> we should stick with them instead of poking rq (or whatever) directly.

It's misunderstanding. I want to say that we can avoid dead lock if we
will take a lock with a smaller address at first.

if (&freezer->lock > &old_freezer->lock) {
	spin_lock_irq(&old_freezer->lock)
	spin_lock_irq(&freezer->lock);
} else {
	spin_lock_irq(&freezer->lock);
	spin_lock_irq(&old_freezer->lock)
}

> 
> > 
> > > +
> > > +static void freezer_cancel_attach(struct cgroup_subsys *ss,
> > > + š š š š š š š š š š š š š š š š struct cgroup *cgroup,
> > > + š š š š š š š š š š š š š š š š struct cgroup *old_cgroup,
> > > + š š š š š š š š š š š š š š š š struct task_struct *task)
> > > +{
> > > + š š š struct freezer *freezer = cgroup_freezer(old_cgroup);
> > > + š š š int retval = 0;
> > > +
> > > + š š š spin_lock_irq(&freezer->lock);
> > > + š š š retval = freezer_task_transition(task, freezer->state);
> > > + š š š if (retval)
> > > + š š š š š š š pr_warning("freezer: Can't move task (pid %d) to %s state\n",
> > > + š š š š š š š š š š š š štask_pid_nr(task),
> > > + š š š š š š š š š š š š šfreezer_state_strs[freezer->state]);
> > 
> > It's strange. A rollback can't fail. We have three situations:
> > 
> > frozen -> frozen
> > thawed -> frozen
> > frozen -> thawed
> > 
> > In first and second cases cancel_request can't fail.
> > In the third we have a problem, which may be solved if we will call
> > thaw_process(task) from attach_task(), we can do that, because
> > thaw_process() can't fail. It solves a problem, because
> > freezer_cancel_attach will be executed for the first and second cases
> > only.
> > 
> > If my suggestion is correct, we can replace pr_warning on BUG_ON
> > 
> 
> Yes, the case which can fail is
> 
>    frozen->(can_attach_task)->thawed
>      (cgroup_task_migrate failure)
>    thawed->(cancel_attach)->frozen
> 
> and we should never fail here since otherwise we would not have
> a "frozen" state before. But I think placing BUG_ON is too severe
> here, maybe WARN_ON_ONCE(1) would fit better?

It's true, if a task is not being executed between thaw_process() and
freeze_task().
