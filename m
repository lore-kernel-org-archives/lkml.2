Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab1JHSou (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 14:44:50 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.95]:55190 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab1JHSot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 14:44:49 -0400
Date: Sat, 8 Oct 2011 14:37:23 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <htejun@gmail.com>, rjw@sisk.pl, paul@paulmenage.org,
        lizf@cn.fujitsu.com, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        fweisbec@gmail.com, matthltc@us.ibm.com, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Paul Menage <menage@google.com>,
        Ben Blum <bblum@andrew.cmu.edu>
Subject: Re: [PATCH 3/4] threadgroup: extend threadgroup_lock() to cover
 exit and exec
Message-ID: <20111008183723.GA8941@ghc17.ghc.andrew.cmu.edu>
References: <1315159280-25032-1-git-send-email-htejun@gmail.com>
 <1315159280-25032-4-git-send-email-htejun@gmail.com>
 <20110918173723.GA2384@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110918173723.GA2384@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.5.19.222118
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, INFO_TLD 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CP_URI_IN_BODY 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also sorry for my late reply. Some thoughts.

On Sun, Sep 18, 2011 at 07:37:23PM +0200, Oleg Nesterov wrote:
> Hello,
> 
> Sorry for the late reply.
> 
> Of course I am in no position to ack the changes in this code, I do not
> fell I understand it enough. But afaics this series is fine.
> 
> A couple of questions.
> 
> On 09/05, Tejun Heo wrote:
> >
> > For exec, threadgroup_[un]lock() are updated to also grab and release
> > cred_guard_mutex.
> 
> OK, this means that we do not need
> 
> 	cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch
> 	http://marc.info/?l=linux-mm-commits&m=131491135428326&w=2
> 
> Ben, what do you think?

Hmm. So now threadgroup_lock() protects the ->thread_group list in all
situations (exit protected by the diff below, and exec protected by the
cred_guard_mutex)?

I'm not sure if I like the pattern of "you can take either these
high-level locks or take this spinlock to protect the list". But it
seems safe enough, so it's fine by me.

Just to be clear, I think we still need the "double-check and possibly
try again" behaviour, right?

Considering that the cred_guard_mutex critical section is hard to find
(it is unlocked in install_exec_creds, which is defined in fs/exec.c and
called in fs/binfmt_*.c) I would probably like to see an assert of
mutex_is_locked(cred_guard_mutex) in de_thread, with this change.

Thanks for working on this, Tejun.

-- Ben

> 
> > With this change, threadgroup_lock() guarantees that the target
> > threadgroup will remain stable - no new task will be added, no new
> > PF_EXITING will be set and exec won't happen.
> 
> To me, this is the only "contradictory" change,
> 
> > --- a/kernel/exit.c
> > +++ b/kernel/exit.c
> > @@ -936,6 +936,12 @@ NORET_TYPE void do_exit(long code)
> >  		schedule();
> >  	}
> >
> > +	/*
> > +	 * @tsk's threadgroup is going through changes - lock out users
> > +	 * which expect stable threadgroup.
> > +	 */
> > +	threadgroup_change_begin(tsk);
> > +
> >  	exit_irq_thread();
> >
> >  	exit_signals(tsk);  /* sets PF_EXITING */
> > @@ -1018,10 +1024,6 @@ NORET_TYPE void do_exit(long code)
> >  		kfree(current->pi_state_cache);
> >  #endif
> >  	/*
> > -	 * Make sure we are holding no locks:
> > -	 */
> > -	debug_check_no_locks_held(tsk);
> > -	/*
> >  	 * We can do this unlocked here. The futex code uses this flag
> >  	 * just to verify whether the pi state cleanup has been done
> >  	 * or not. In the worst case it loops once more.
> > @@ -1039,6 +1041,12 @@ NORET_TYPE void do_exit(long code)
> >  	preempt_disable();
> >  	exit_rcu();
> >
> > +	/*
> > +	 * Release threadgroup and make sure we are holding no locks.
> > +	 */
> > +	threadgroup_change_done(tsk);
> 
> I am wondering, can't we narrow the scope of threadgroup_change_begin/done
> in do_exit() path?
> 
> The code after 4/4 still has to check PF_EXITING, this is correct. And yes,
> with this patch PF_EXITING becomes stable under ->group_rwsem. But, it seems,
> we do not really need this?
> 
> I mean, can't we change cgroup_exit() to do threadgroup_change_begin/done
> instead? We do not really care about PF_EXITING, we only need to ensure that
> we can't race with cgroup_exit(), right?

That sounds right to me. After all, in the fork bailout path where
cgroup_exit is also called is just before the lock is dropped.

> 
> Say, cgroup_attach_proc() does
> 
> 	do {
> 		if (tsk->flags & PF_EXITING)
> 			continue;
> 
> 		flex_array_put_ptr(group, tsk);
> 	} while_each_thread();
> 
> Yes, this tsk can call do_exit() and set PF_EXITING right after the check
> but this is fine. The only guarantee we need is: if it has already called
> cgroup_exit() we can not miss PF_EXITING, and if cgroup_exit() takes the
> same sem this should be true. And, otoh, if we do not see PF_EXITING then
> we can not race with cgroup_exit(), it should block on ->group_rwsem hold
> by us.

Right.

> 
> If I am right, afaics the only change 4/4 needs is that it should not add
> WARN_ON_ONCE(tsk->flags & PF_EXITING) into cgroup_task_migrate().
> 
> What do you think?
> 
> Oleg.
> 
> 

This bit looks suspicious (but only stylistically):

 		retval = cgroup_task_migrate(cgrp, oldcgrp, tsk, true);
-		BUG_ON(retval != 0 && retval != -ESRCH);
+		BUG_ON(retval != 0);

Is this also the case for the other callsite to cgroup_task_migrate? If
so, maybe change cgroup_task_migrate to return void, and have the BUG_ON
inside of it.

Cheers,
Ben

