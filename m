Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab2LUOLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 09:11:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab2LUOLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 09:11:31 -0500
Date: Fri, 21 Dec 2012 15:11:33 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 07/11] pidns: Wait in zap_pid_ns_processes until
	pid_ns->nr_hashed == 1
Message-ID: <20121221141133.GA13805@redhat.com>
References: <8739097bkk.fsf@xmission.com> <1353083750-3621-1-git-send-email-ebiederm@xmission.com> <1353083750-3621-7-git-send-email-ebiederm@xmission.com> <20121219184757.GB22991@redhat.com> <87bodourqt.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bodourqt.fsf@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, Eric W. Biederman wrote:
>
> Oleg Nesterov <oleg@redhat.com> writes:
>
> > On 11/16, Eric W. Biederman wrote:
> >>
> >> @@ -216,22 +216,15 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
> >>
> >>  	/*
> >>  	 * sys_wait4() above can't reap the TASK_DEAD children.
> >> -	 * Make sure they all go away, see __unhash_process().
> >> +	 * Make sure they all go away, see free_pid().
> >>  	 */
> >>  	for (;;) {
> >> -		bool need_wait = false;
> >> -
> >> -		read_lock(&tasklist_lock);
> >> -		if (!list_empty(&current->children)) {
> >> -			__set_current_state(TASK_UNINTERRUPTIBLE);
> >> -			need_wait = true;
> >> -		}
> >> -		read_unlock(&tasklist_lock);
> >> -
> >> -		if (!need_wait)
> >> +		set_current_state(TASK_UNINTERRUPTIBLE);
> >> +		if (pid_ns->nr_hashed == 1)
> >>  			break;
> >>  		schedule();
> >>  	}
> >
> > I agree, the patch itself looks fine.
> >
> > But, with all other changes I do not understand this part at all.
> >
> > A task from the parent namespace can do setns + fork at any time
> > (until nr_hashed >= 0). So ->nr_hashed can be incremented again
> > after zap_pid_ns_processes() returns.

XXX: this creates the new pid P in this ns. Please see below...

> I want to talk about how alloc_pid and free_pid prevent nr_hashed
> from increasing once the last processes has exited the pid namespace
> but that doesn't apply here.

Not sure I understand, but it seems you agree this can happen.

> > Or, we can sleep in TASK_UNINTERRUPTIBLE "forever" if this happens
> > after kill-them-all.
>
> Sleeping forever should be prevented by this chunk in free_pid:

Note that I said "forever", not forever ;)

>
> 		switch(--ns->nr_hashed) {
> 		case 1:
> 			/* When all that is left in the pid namespace
> 			 * is the reaper wake up the reaper.  The reaper
> 			 * may be sleeping in zap_pid_ns_processes().
> 			 */
> 			wake_up_process(ns->child_reaper);
>
>
> I admit it continues to be true that if an injected process or a
> debugged process does not exit we can block waiting for all of the
> processes to be reaped indefinitely.

Yes, I meant until the injected process exits.

> > Could you explain why do we need to wait at all? I can be easily
> > wrong, but at first glance the original reason for this wait has
> > gone away?
>
> It is very nice to know that when you do waitpid for the init process of
> a pid namespace that there are no other processes in the pid namespace.

OK, and I agree. But my point was, at least this _looks_ strange, because
ns->nr_hashed == 1 is not stable.

And in fact I think this is not strange, but simply wrong.

Please consider the XXX case above. Suppose that free_pid(P) happens
after ns->child_reaper exits and thus this pointer points to nowhere.
Suppose also that there is another injected pid so nr_hashed == 2.
In this case wake_up_process(ns->child_reaper) means use-after-free,
no?

Oleg.

