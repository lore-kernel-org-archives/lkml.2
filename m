Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab2KFRCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 12:02:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab2KFRCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 12:02:36 -0500
Date: Tue, 6 Nov 2012 18:02:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Stone <jistone@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: uprobes && pre-filtering
Message-ID: <20121106170243.GA32311@redhat.com>
References: <20121105190446.GA6188@redhat.com> <20121106090525.GB27055@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106090525.GB27055@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Srikar Dronamraju wrote:
>
> > Hello.
> >
> > There is a known (and by design) problem with uprobes. They act
> > systemwide, there is no pre-filtering. Just some random thoughts
> > to provoke the discussion.
> >
> > - I think that the current uprobe_consumer->filter(task) should die.
> >
> >   It buys nothing. It is called right before ->handler() and this is
> >   pointless, ->handler() can call it itself.
> >
>
> I think it helps to call filter before handler.

How? The hanlder can simply call this function at the start.

But this is minor. I think this can double the work sometimes. If ->handler
needs to do something nontrivial, it will probably look into my_traced_tasks
database anyway to find the additional info which represents the tracee.
And most probably ->filter() will do the same lookup unnecessary.

> When a tracer has specified a filter condition and then we run a handler
> for cases that dont fit the handler looks a little odd.
>
> Another reason for having the filters in the current way was to have a
> set of standard filters in uprobes code so that all users dont need to
> recreate these filters.

IOW, you mean that both register_for_each_vma() and handler_chain() should
use the same ->filter() method? Personally I do not think they should.

Because the semantics is different imo. register_for_each_vma() needs
to know if we should modify mm and insert the breakpoint. handler_chain()
just tries to skip ->handler() (and for no reason, imho).

> >   And more importantly, I do not think this hook (with the same
> >   semantics) can/should be used by both register and handler_chain().
> >
> > - We should change register_ and and mmap to filter out the tasks
> >   which we do not want to trace. To simplify, lets forget about
> >   multiple consumers first.
> >
> >   Everything is simple, install_breakpoint() callers should simply
> >   call consumer->filter(args) and do nothing if it returns false.
> >
> >   The main problem is, what should be passed as "args". I think it is
> >   pointless to use task_struct as an argument. And not because there
> >   is no simple way to find all tasks which use this particular mm in
> >   register_for_each_vma(), even if it was possible I think this makes
> >   no sense.
> >
>
> Having mm instead of task is fine with me. But this would mostly mean
> that the prefilter, i.e filter at the time of registration and the
> filter at the time of handling should be different

Yes, I think they should be different, please see above.

We need the pre-filtering to avoid the unnecessary traps, not to avoid
the function call when the task already hit the breakpoint.

> or we remove the
> handling time filtering and expect the handler to do the filtering.

Yes. But once again, if ->handler() wants to use the same function it
can simply call it.

> Having a task instead of mm helps in having the same filter run at both
> places.

And this is where we start to disagree. Namely, I do not think that
register_for_each_vma() should even try to find mm user(s).

Because once again, a) whater register_for_each_vma() can do to iterate
the tasks can be done by ->filter, b) right now I do not see any potential
user who will need this so we should not overdesign this.

> >   If 2 tasks/threads share the same mm they will share int3 as well,
> >   so I think we need
> >
> >   	enum filter_mode {
> >   		UPROBE_FILTER_REGISTER,
> >   		UPROBE_FILTER_MMAP,
> >   		/* more */
> >   	};
> >
> >   	consumer->filter(enum filter_mode mode, struct mm_struct *mm);
>
> what would a tracing session having filter_mode == UPROBE_FILTER_REGISTER mean?
> 	Does that mean it can trace only instances in currently mapped vmas?
> 	Would it handle a probe instance in a process that is already running but has not yet mapped a vma?
>
> Also would a tracing session having filter_mode == UPROBE_FILTER_MMAP
> mean that it would only handle probepoints in only vmas that are going
> to be mapped in future?

No, no, you misunderstood. Sorry I was unclear and yes, the naming I used
was confusing.

I meant that both register_for_each_vma() and uprobe_mmap() (lets ignore
other callers and other modes) call the same ->filter() method but with
the different "mode" argument, UPROBE_FILTER_REGISTER or UPROBE_FILTER_MMAP.
This is only the hint, for example UPROBE_FILTER_MMAP can use current
but UPROBE_FILTER_REGISTER obviously can't.

> > - Perhaps we should extend the API. We can add
> >
> > 	uprobe_apply(consumer, task, bool add_remove);
> >
> >   which adds/removes breakpoints to task->mm.
> >
> >   This way consumer can probe every task it wants to trace after
> >   uprobe_register().
> >
> >   Its ->filter(UPROBE_FILTER_REGISTER) should simply return false. Or,
> >   better, we can split uprobe_register() into 2 functions,
> >   __uprobe_register() and uprobe_apply_all() which actually does
> >   register_for_each_vma().
> >
> >   ***** QUESTION *****: perhaps this is all systemtap needs? ignoring
> >   UPROBE_FILTER_MMAP.
> >
> > - Multiple consumers. uprobe_register/uprobe_unregister should be
> >   modified so that register_for_each_vma() is called every time when
> >   the new consumer comes or consumer goes away.
> >
> >   uprobe_apply(add_remove => false) should obviously consult other
> >   consumers too.
>
>
> So in this case, would uprobe_register() just add a consumer to a
> new/existing uprobe. The actual probe insertion is done by the
> uprobe_apply()/uprobe_apply_all().

Yes. Not sure we really need this, but to me this extension looks natural.

Frank, Josh, do you think it can help systemtap ?


Suppose that the consumer no longer wants to trace the task T but it
has other tasks to trace. If we only rely on ->filter, the tracer should
do unregister + register, this doesn't look good. Or it wants to add
the new task to its trace-list...

> Also in this case, there is no
> filter element in the uprobe_consumer. Right?

Why? it could be there.

> I am just wondering if people could use/misuse this
> for example: - somebody could keep modifying and reusing the consumers
> but one probe registration,  with subsequent uprobe_apply().

Yes, exactly.

> Unlike now we could have lots of uprobes but all with defunct consumers.

sorry, can't understand...

> > - Perhaps we should teach handle_swbp() to remove the unwanted breakpoints.
> >
> >   If every ->handler() returns, say, UPROBE_GO_AWAY handle_swbp() should
> >   remove this breakpoint. Of course, a consumer must be sure that if it
> >   returns UPROBE_GO_AWAY this task can't share ->mm with another task it
> >   wants to trace.
>
> Its a good idea to remove redundant probepoints from the breakpoint hit
> context. However,
>
> - even from the handlers() perspective, if we have to identify that this
>   consumer isnt looking at this mm, we need something like
>   for_each_mm_user(). No?

Yes and no, I think.

Yes, _in general_ it is needed. (although once again, where is potential
users?).

But in the simple case - no. For example, filter-by-pid should return
UPROBE_GO_AWAY if current->mm != find_task_by_vpid(PID)->mm.

> - also if we are looking for removing a breakpoint, I would think its
>   better done in common code, i.e uprobe code rather than keeping it in
>   every handler. So I think keeping the filter logic before the handler
>   is good.

Again, I do not understand why do you think so. OK, I won't really insist,
we can add UBPROBE_FILTER_BP_HIT or whatever. Still I do not understand
why should we mix remove-this-breakpoint and do-not-call-hanlder. And
note that ->handler() has to do addtional checks anyway.

Anyway. Do you agree that filter's arguments should be changed? If yes,
then we should remove handler_chain()->filter(), then discuss why we
should add it back and which semantics it should have. Agreed?

> >   Or consumer->handler() can do uprobe_apply(add_remove => false) itself,
> >   but this needs more discussion.
> >
> >   The point is that if the filtering at UPROBE_FILTER_REGISTER time is
> >   not possible, ->filter(UPROBE_FILTER_REGISTER) can return true. A
> >   "wrong" int3 doesn't hurt until the task actually hits the breakpoint,
> >   and I think that a single bp-hit is fine performance-wise.
> >
>
> Agree. Also the reason why we inserted this probe in the current mm
> might have changed and we might no more need the probe.
> For example, traced thread in a multithreaded process actually died and
> all other threads may not be interested

Yes.

> > - fork(). The child inherits all breakpoints from parent, and uprobes
> >   can't control this. What can we do?
> >
> > 	* We can add another uprobe hook which does something like
> >
> > 	  	for_each_uprobe_in_each_vma(child_mm) {
> > 	  		if (filter(UPROBE_FILTER_FORK))
> > 	  			install_breakoint();
> > 	  		else
> > 	  			remove_breakpoint();
> > 	  	}
> >
> >
> > 	  But is is not clear where can we add this hook. dup_mmap()
> > 	  looks appealing, but at this time the child is still under
> > 	  construction, consumer->filter() can't look at task_struct.
> >
> > 	  And of course, it is not nice to slow down fork().
> >
> > 	* If we only care about the unwanted breakpoints, perhaps it
> > 	  would be better to rely on UPROBE_GO_AWAY above?
> >
> > 	* Finally, do we care at all? Again, who can ever need to
> > 	  re-install breakpoints after fork?
> >
> > 	  systemtap (iiuc) doesn't need this. And even if it does
> > 	  or will need, I guess it can hook fork itself and use
> > 	  uprobe_apply() ?
>
>
> I was thinking if we can implement for_each_mm_user() using additional
> mm->flags.

(I guess you didn't meant it can help to solve the problem with fork)

I do not know if we can (or should) implement for_each_mm_user().

My main point was, the core uprobes should not care. Once again,
who do you think will need it? systemtap doesn't afaics, neither
debug/tracing/uprobe_events.

And once again, even if we have to implement it for some new tricky
tracer, why its ->filter can not do for_each_mm_user() itself?

>  Would something like this work?
>  ...
>
> - for_each_mm_users would mostly boil down to searching in children,
>   siblings unless MMF_REPARENTED flag is set.

Whose children? I don't think mm->owner is always the root of the
tree. And what about the locking? I do not think we want to call
->filter under (say) tasklist.



But again, again. Why do you think register_for_each_vma() should do
this? IOW, why should we think about for_each_mm_user() at all (at
least right now) ?

Oleg.

