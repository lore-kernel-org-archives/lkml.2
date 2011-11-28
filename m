Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1K1Nie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:38:34 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56762 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab1K1Nid (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:38:33 -0500
Date: Mon, 28 Nov 2011 17:38:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111128133828.GL1775@moon>
References: <20111128120813.GK1775@moon>
 <CANaxB-wrRd94OJifpYJ=kibx_48oJ=GE51f9GWjZ3np2nCQYsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANaxB-wrRd94OJifpYJ=kibx_48oJ=GE51f9GWjZ3np2nCQYsA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 05:10:00PM +0400, Andrey Vagin wrote:
> >        void (*cancel_attach)(struct cgroup_subsys *ss, struct cgroup *cgrp,
> > -                             struct task_struct *tsk);
> > +                             struct cgroup *old_cgrp, struct task_struct *tsk);
> 
> I'm not shure, that we need old_cgrp, because when cancel_attach is
> executed, a task is in old cgroup and old_cgrp = task_cgroup(tsk);
> 
> ...
> 

Yup, thanks for the point. Indeed old_cgrp is redundant and task_cgroup
helper will provide all additional information we need.

> > +
> > +static int freezer_can_attach_task(struct cgroup *cgroup, struct task_struct *task)
> > +{
> > +       struct freezer *old_freezer;
> > +       struct freezer *freezer;
> > +
> > +       int goal_state, orig_state;
> > +       int retval = 0;
> > +
> > +       old_freezer = task_freezer(task);
> > +       freezer = cgroup_freezer(cgroup);
> > +
> > +       spin_lock_irq(&freezer->lock);
> > +
> > +       if (!spin_trylock_irq(&old_freezer->lock)) {
> > +               retval = -EBUSY;
> 
> I think EBUSY is not a good idea in this place.  We can do something
> like double_rq_lock.
> 

Could you please elaborate? freezers are guarded with spinlocks so I think
we should stick with them instead of poking rq (or whatever) directly.

> 
> > +
> > +static void freezer_cancel_attach(struct cgroup_subsys *ss,
> > +                                 struct cgroup *cgroup,
> > +                                 struct cgroup *old_cgroup,
> > +                                 struct task_struct *task)
> > +{
> > +       struct freezer *freezer = cgroup_freezer(old_cgroup);
> > +       int retval = 0;
> > +
> > +       spin_lock_irq(&freezer->lock);
> > +       retval = freezer_task_transition(task, freezer->state);
> > +       if (retval)
> > +               pr_warning("freezer: Can't move task (pid %d) to %s state\n",
> > +                          task_pid_nr(task),
> > +                          freezer_state_strs[freezer->state]);
> 
> It's strange. A rollback can't fail. We have three situations:
> 
> frozen -> frozen
> thawed -> frozen
> frozen -> thawed
> 
> In first and second cases cancel_request can't fail.
> In the third we have a problem, which may be solved if we will call
> thaw_process(task) from attach_task(), we can do that, because
> thaw_process() can't fail. It solves a problem, because
> freezer_cancel_attach will be executed for the first and second cases
> only.
> 
> If my suggestion is correct, we can replace pr_warning on BUG_ON
> 

Yes, the case which can fail is

   frozen->(can_attach_task)->thawed
     (cgroup_task_migrate failure)
   thawed->(cancel_attach)->frozen

and we should never fail here since otherwise we would not have
a "frozen" state before. But I think placing BUG_ON is too severe
here, maybe WARN_ON_ONCE(1) would fit better?
