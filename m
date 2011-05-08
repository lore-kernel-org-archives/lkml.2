Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab1EHPfo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 11:35:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab1EHPfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 11:35:40 -0400
Date: Sun, 8 May 2011 17:34:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ptrace] ptrace: fix signal->wait_chldexit usage in
	task_clear_group_stop_trapping()
Message-ID: <20110508153435.GA11046@redhat.com>
References: <20110506095222.GB8824@htj.dyndns.org> <20110508133543.GA4820@redhat.com> <20110508140221.GA29783@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110508140221.GA29783@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08, Tejun Heo wrote:
>
> Hello, Oleg.
>
> On Sun, May 08, 2011 at 03:35:43PM +0200, Oleg Nesterov wrote:
> > > Given the relative low frequency of ptrace use, we would be much
> > > better off leaving already complex wait_chldexit alone and using bit
> > > waitqueue.
> >
> > Well, I don't think so. wait_on_bit() looks as unnecessary complication
> > to me. See below.
>
> Why is wait_on_bit() a complication?  It's a well defined event
> construct.

Sure, but in this case wait_chldexit or wake_up_process() looks more
simple and natural to me. OK, this is subjective.

> > But. Why do we need signal->wait_chldexit or bit waitqueue at all?
> > Previously this was needed because wait_event(!GROUP_STOP_TRAPPING)
> > was called from ptrace_check_attach(), and the tracer can do anything
> > after ptrace_attach() which sets GROUP_STOP_TRAPPING.
> >
> > With the current code we know that GROUP_STOP_TRAPPING means: the
> > tracer can't go away from ptrace_attach() until we clear this bit.
>
> Several reasons.
>
> * Because I'm gonna use TRAPPING for end of group stop notification
>   too and move TRAPPING waiting to ptrace_check_attach() and
>   wait_task_stopped().

Hmm. Right now this is not clear to me... OK, nevermind.

> * I dislike adding unqualified wake_up_process() unless the
>   interlocked behavior with the waiter is very obvious.

Imho this is what we currently have.

But this is subjective too, and I agree that the future patches can
change the current trivial contract. So:

Reviewed-by: Oleg Nesterov <oleg@redhat.com>

I'll add this fix to my tree.


> > Hmm. This is minor and off-topic, but perhaps it makes sense to move
> > the code which sets/waits GROUP_STOP_TRAPPING from ptrace_attach() to
> > the separate function, it can be called outside of tasklist_lock and
> > cred_guard_mutex.
>
> I'm confused.  It should be set while siglock is held.  Which place
> are you suggesting?

Of course, we should take siglock. I meant, we could probably make

	static void ptrace_s_stopped_traced(struct task_struct *task)
	{
		bool wait_trap = false;

		spin_lock(&task->sighand->siglock);
		/*
		 * If the task is already STOPPED, set GROUP_STOP_PENDING and
		 * TRAPPING, and kick it so that it transits to TRACED.  TRAPPING
		 * will be cleared if the child completes the transition or any
		 * event which clears the group stop states happens.  We'll wait
		 * for the transition to complete before returning from this
		 * function.
		 *
		 * This hides STOPPED -> RUNNING -> TRACED transition from the
		 * attaching thread but a different thread in the same group can
		 * still observe the transient RUNNING state.  IOW, if another
		 * thread's WNOHANG wait(2) on the stopped tracee races against
		 * ATTACH, the wait(2) may fail due to the transient RUNNING.
		 *
		 * The following task_is_stopped() test is safe as both transitions
		 * in and out of STOPPED are protected by siglock.
		 */
		if (task_is_stopped(task)) {
			task->group_stop |= GROUP_STOP_PENDING | GROUP_STOP_TRAPPING;
			signal_wake_up(task, 1);
			wait_trap = true;
		}
		spin_unlock(&task->sighand->siglock);

		if (wait_trap)
			wait_event(current->signal->wait_chldexit,
				   !(task->group_stop & GROUP_STOP_TRAPPING));
		return retval;
	}

called by ptrace_attach() at the end.

> > And. Could you remind why ptrace_attach() does signal_wake_up() instead
> > of wake_up_state(TASK_STOPPED) ? OK, in general we shouldn't set
> > GROUP_STOP_PENDING without TIF_SIGPENDING, but in this case?
>
> I don't know.  I can't find any good reason there.  Feel free to
> change it to wake_up_state(TASK_STOPPED)

No, I agree signal_wake_up() looks more consistent. Just I wanted to
ensure I didn't miss something which makes it strictly necessary.

Oleg.

