Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab0FCE6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 00:58:07 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:49933 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab0FCE6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 00:58:04 -0400
Date: Thu, 3 Jun 2010 00:56:29 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, akpm@linux-foundation.org,
       ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
       menage@google.com
Subject: Re: [RFC] [PATCH 2/2] cgroups: make procs file writable
Message-ID: <20100603045629.GC21006@ghc02.ghc.andrew.cmu.edu>
References: <20100530013002.GA762@ghc01.ghc.andrew.cmu.edu>
 <20100530013303.GC762@ghc01.ghc.andrew.cmu.edu>
 <20100531175242.GA14691@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531175242.GA14691@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.6.3.43914
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_3000_3999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 07:52:42PM +0200, Oleg Nesterov wrote:
> I only glanced into one function, cgroup_attach_proc(), and some things
> look "obviously wrong". Sorry, I can't really read these patches now,
> most probably I misunderstood the code...
> 
> > +int cgroup_attach_proc(struct cgroup *cgrp, struct task_struct *leader)
> > +{
> > +	int retval;
> > +	struct cgroup_subsys *ss, *failed_ss = NULL;
> > +	struct cgroup *oldcgrp;
> > +	struct css_set *oldcg;
> > +	struct cgroupfs_root *root = cgrp->root;
> > +	/* threadgroup list cursor */
> > +	struct task_struct *tsk;
> > +	/*
> > +	 * we need to make sure we have css_sets for all the tasks we're
> > +	 * going to move -before- we actually start moving them, so that in
> > +	 * case we get an ENOMEM we can bail out before making any changes.
> > +	 */
> > +	struct list_head newcg_list;
> > +	struct cg_list_entry *cg_entry, *temp_nobe;
> > +
> > +	/*
> > +	 * Note: Because of possible races with de_thread(), we can't
> > +	 * distinguish between the case where the user gives a non-leader tid
> > +	 * and the case where it changes out from under us. So both are allowed.
> > +	 */
> 
> OK, the caller has a reference to the argument, leader,
> 
> > +	leader = leader->group_leader;
> 
> But why it is safe to use leader->group_leader if we race with exec?

This line means "let's try to find who the leader is", since
attach_task_by_pid doesn't grab it for us. It's not "safe", and we still
check if it's really the leader later (just before the 'commit point').
Note that before this line 'leader' doesn't really mean the leader -
perhaps i should rename the variables :P

But maybe I also want to grab a reference on the new task? I can't
remember whether I need to or not. I'm not sure whether or not I need to
grab an rcu lock, but it doesn't seem necessary because of the commit
point check later on. Plus can_attach takes the rcu lock itself for
iterating if it needs it.

> 
> > +	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {
> 
> Even if we didn't change "leader" above, this is not safe in theory.
> We already discussed this, list_for_each_rcu(head) is only safe when
> we know that "head" itself is valid.
> 
> Suppose that this leader exits, then leader->thread_group.next exits
> too before we take rcu_read_lock().

Why is that a problem? I thought leader->thread_group is supposed to
stay sane as long as leader is the leader.

This looks like it needs a check to see if 'leader' is still really the
leader, but nothing more.

> 
> > +	oldcgrp = task_cgroup_from_root(leader, root);
> > +	if (cgrp != oldcgrp) {
> > +		retval = cgroup_task_migrate(cgrp, oldcgrp, leader, true);
> > +		BUG_ON(retval != 0 && retval != -ESRCH);
> > +	}
> > +	/* Now iterate over each thread in the group. */
> > +	list_for_each_entry_rcu(tsk, &leader->thread_group, thread_group) {
> > +		BUG_ON(tsk->signal != leader->signal);
> > +		/* leave current thread as it is if it's already there */
> > +		oldcgrp = task_cgroup_from_root(tsk, root);
> > +		if (cgrp == oldcgrp)
> > +			continue;
> > +		/* we don't care whether these threads are exiting */
> > +		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
> > +		BUG_ON(retval != 0 && retval != -ESRCH);
> > +	}
> 
> This looks strange. Why do we move leader outside of the loop ?
> Of course, list_for_each_entry() can't work to move all sub-threads,
> but "do while_each_thread()" can.

do/while_each_thread oves over all threads in the system, rather than
just the threadgroup... this isn't supposed to be a fast operation, but
that seems like overkill.

> 
> From 0/2:
> >
> > recentish changes to signal_struct's lifetime rules (which don't seem to
> > appear when I check out mmotm with git clone,
> 
> already in Linus's tree.
> 
> Oleg.
> 

-- Ben
