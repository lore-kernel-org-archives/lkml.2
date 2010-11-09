Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab0KIQDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:03:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792Ab0KIQDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:03:41 -0500
Date: Tue, 9 Nov 2010 16:57:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && event->owner
Message-ID: <20101109155714.GA1903@redhat.com>
References: <20101108145647.GA3426@redhat.com> <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108201108.GA6777@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Frederic Weisbecker wrote:
>
> On Mon, Nov 08, 2010 at 03:57:54PM +0100, Oleg Nesterov wrote:
> > Another thing I can't understand, event->owner/owner_entry.
> >
> > Say, some thread calls sys_perf_event_open() and creates the event.
> > It becomes its owner. Now this thread exits, but fd/event are still
> > here, and event->owner refers to the dead task_struct.
>
> Hmm, it seems to me that the last reference to the events are
> put in __perf_event_exit_task,

I think no, in this case sys_perf_event_open() owns the event. IOW,
perf_release() frees this perf_event. But this doesn't matter.

> and then free_event() is called
> there, which rcu queues the event to be released.
>
> Not sure where is the issue here.

I am not saying this is buggy. But it looks very strange to me.

If the creator of perf_event dies, nobody can use its ->perf_event_list
anyway. What is the point to keep the reference to the dead task_struct
and preserve this ->perf_event_list?

And why do we need ->owner at all? Afaics, it is _only_ needed to find
->perf_event_mutex in perf_event_release_kernel(). And this mutex only
protects ->perf_event_list (mostly for prctl).

Of course, I understand that it is not completely trivial to change this.
The exiting creator can clear its ->perf_event_list and set
event->owner = NULL, but then perf_event_release_kernel() should
avoid the races with do_exit() somehow.

> > ptrace looks even more strange. Debugger can attach the breakpoint
> > to the tracee and then exit/detach. ->ptrace_bps events still point
> > to the same (may be dead) task. Even if another debugger attaches
> > and reuses these events.
>
>
>
> Hmm, in this case ptrace_bps will continue to trigger on the task
> they were applied.
>
> On the other hand, you're right, I'm not sure that the debugger is
> the correct owner for the breakpoints.
> I think it works though, looking at perf_event_create_kernel_counter():
>
> 	event->owner = current;
> 	get_task_struct(current);
>
> (current is the debugger)
>
> On perf_event_release_kernel():
>
> 	put_task_struct(event->owner);
>
> So even if the debugger dies, we keep a valid owner, it works but just makes
> few sense as the debugger can change.

Yes, it works, but I am not sure about "valid" above ;) Even if the previous
debugger doesn't exit.

And. Suppose that the new debugger attaches and reuses ->ptrace_bps[],
everything works.

Now, the former debugger does prctl(PR_TASK_PERF_EVENTS_DISABLE) and
suddenly bps stop working.

Not to mention this looks racy. Can't prctl() doing perf_event_disable/enable
race with modify_user_hw_breakpoint/unregister_hw_breakpoint/etc ?

> Perhaps the real owner should be the task on which we attach our breakpoint.

Not sure... What for?

In any case, I don't think the tracee should "control" this event.

Oleg.

