Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab1K1PBB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 10:01:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46361 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1K1PBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 10:01:00 -0500
Date: Mon, 28 Nov 2011 19:00:54 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Vagin <avagin@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111128150054.GM1775@moon>
References: <20111128120813.GK1775@moon>
 <CANaxB-wrRd94OJifpYJ=kibx_48oJ=GE51f9GWjZ3np2nCQYsA@mail.gmail.com>
 <20111128133828.GL1775@moon>
 <20111128140356.GA27395@dhcp-10-30-18-117.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111128140356.GA27395@dhcp-10-30-18-117.sw.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 06:03:56PM +0400, Andrew Vagin wrote:
> > > > +static int freezer_can_attach_task(struct cgroup *cgroup, struct task_struct *task)
> > > > +{
> > > > +       struct freezer *old_freezer;
> > > > +       struct freezer *freezer;
> > > > +
> > > > +       int goal_state, orig_state;
> > > > +       int retval = 0;
> > > > +
> > > > +       old_freezer = task_freezer(task);
> > > > +       freezer = cgroup_freezer(cgroup);
> > > > +
> > > > +       spin_lock_irq(&freezer->lock);
> > > > +
> > > > +       if (!spin_trylock_irq(&old_freezer->lock)) {
> > > > +               retval = -EBUSY;
> > > 
> > > I think EBUSY is not a good idea in this place.  We can do something
> > > like double_rq_lock.
> > > 
> > 
> > Could you please elaborate? freezers are guarded with spinlocks so I think
> > we should stick with them instead of poking rq (or whatever) directly.
> 
> It's misunderstanding. I want to say that we can avoid dead lock if we
> will take a lock with a smaller address at first.
> 
> if (&freezer->lock > &old_freezer->lock) {
> 	spin_lock_irq(&old_freezer->lock)
> 	spin_lock_irq(&freezer->lock);
> } else {
> 	spin_lock_irq(&freezer->lock);
> 	spin_lock_irq(&old_freezer->lock)
> }
> 

This is not applicable here as far as I see. It works for rq because of
per-cpu address allocation, but not for freezers which are allocated via
kzalloc. The second try_lock (note I've overdid with irq disabling, plain
spin_trylock would be enough) is not for escaping deadlock but rather for
not waiting much if target freezer is handling state transition for all
task it has.

I think the better approach would to make this code even less lock contended,
ie something like

	local_irq_disable
	spin_trylock(new_freezer)
	spin_trylock(old_freezer)
	...
	local_irq_enable

so if both freezers are not handling anything we attach the task then.
Or I miss something obvious?

> > > 
> > > It's strange. A rollback can't fail. We have three situations:
> > > 
> > > frozen -> frozen
> > > thawed -> frozen
> > > frozen -> thawed
> > > 
> > > In first and second cases cancel_request can't fail.
> > > In the third we have a problem, which may be solved if we will call
> > > thaw_process(task) from attach_task(), we can do that, because
> > > thaw_process() can't fail. It solves a problem, because
> > > freezer_cancel_attach will be executed for the first and second cases
> > > only.
> > > 
> > > If my suggestion is correct, we can replace pr_warning on BUG_ON
> > > 
> > 
> > Yes, the case which can fail is
> > 
> >    frozen->(can_attach_task)->thawed
> >      (cgroup_task_migrate failure)
> >    thawed->(cancel_attach)->frozen
> > 
> > and we should never fail here since otherwise we would not have
> > a "frozen" state before. But I think placing BUG_ON is too severe
> > here, maybe WARN_ON_ONCE(1) would fit better?
> 
> It's true, if a task is not being executed between thaw_process() and
> freeze_task().

Hmm... But what the problem it might be if a task get executed between
those stages even for some time?
