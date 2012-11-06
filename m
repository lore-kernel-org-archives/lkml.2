Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752472Ab2KFJDG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 04:03:06 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:47485 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2KFJC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 04:02:58 -0500
Date: Tue, 6 Nov 2012 14:35:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Stone <jistone@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: uprobes && pre-filtering
Message-ID: <20121106090525.GB27055@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20121105190446.GA6188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121105190446.GA6188@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110609-4834-0000-0000-0000002C871F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hello.
> 
> There is a known (and by design) problem with uprobes. They act
> systemwide, there is no pre-filtering. Just some random thoughts
> to provoke the discussion.
> 
> - I think that the current uprobe_consumer->filter(task) should die.
> 
>   It buys nothing. It is called right before ->handler() and this is
>   pointless, ->handler() can call it itself.
> 

I think it helps to call filter before handler.

When a tracer has specified a filter condition and then we run a handler
for cases that dont fit the handler looks a little odd.

Another reason for having the filters in the current way was to have a
set of standard filters in uprobes code so that all users dont need to
recreate these filters. 

Also please see below.

>   And more importantly, I do not think this hook (with the same
>   semantics) can/should be used by both register and handler_chain().
> 
> - We should change register_ and and mmap to filter out the tasks
>   which we do not want to trace. To simplify, lets forget about
>   multiple consumers first.
> 
>   Everything is simple, install_breakpoint() callers should simply
>   call consumer->filter(args) and do nothing if it returns false.
> 
>   The main problem is, what should be passed as "args". I think it is
>   pointless to use task_struct as an argument. And not because there
>   is no simple way to find all tasks which use this particular mm in
>   register_for_each_vma(), even if it was possible I think this makes
>   no sense.
> 

Having mm instead of task is fine with me. But this would mostly mean 
that the prefilter, i.e filter at the time of registration and the
filter at the time of handling should be different or we remove the
handling time filtering and expect the handler to do the filtering.

Having a task instead of mm helps in having the same filter run at both
places.

>   If 2 tasks/threads share the same mm they will share int3 as well,
>   so I think we need
> 
>   	enum filter_mode {
>   		UPROBE_FILTER_REGISTER,
>   		UPROBE_FILTER_MMAP,
>   		/* more */
>   	};
> 
>   	consumer->filter(enum filter_mode mode, struct mm_struct *mm);

what would a tracing session having filter_mode == UPROBE_FILTER_REGISTER mean?
	Does that mean it can trace only instances in currently mapped vmas? 
	Would it handle a probe instance in a process that is already running but has not yet mapped a vma?

Also would a tracing session having filter_mode == UPROBE_FILTER_MMAP
mean that it would only handle probepoints in only vmas that are going
to be mapped in future?

> 
>   Sure, this does not allow to, say, probe the tasks with the given uid.
>   But once again, currently we do not have for_each_mm_user(task, mm)
>   and even if we implement it
> 
>   	a) ->filter(mm) can use it itself)
> 
>   	b) I do not think register_for_each_vma() should call it.
> 
>   	   Suppose that a consumer wants to track the task with the
>   	   given pid PID. In this case ->filter() can simply check
>   	   find_task_by_vpid(PID)->mm = mm. This is fast and simple.
> 
>   	   Or you want to probe all instances of /bin/ls. In this case
>   	   filter() can check mm->exe_file->f_path == saved_path, this
>   	   is very cheap.
> 
>   	   But if we add for_each_mm_user() into register_for_each_vma()
>   	   it will be called even if the filtering is simple.
> 
>   So. If filter(UPROBE_FILTER_REGISTER) needs to check task_uid(task) == UID
>   it has to do for_each_process() until we have (if ever) for_each_mm_user().
> 
>   Or it should always return true and remove the unnecessary breakpoints
>   later, or use another API (see below).
> 
>   Also. Who needs the "nontrivial" filtering? I do not see any potential
>   in-kernel user. And the tools like systemtap can take another approach
>   (perhaps).
> 
> - Perhaps we should extend the API. We can add
> 
> 	uprobe_apply(consumer, task, bool add_remove);
> 
>   which adds/removes breakpoints to task->mm.
> 
>   This way consumer can probe every task it wants to trace after
>   uprobe_register().
> 
>   Its ->filter(UPROBE_FILTER_REGISTER) should simply return false. Or,
>   better, we can split uprobe_register() into 2 functions,
>   __uprobe_register() and uprobe_apply_all() which actually does
>   register_for_each_vma().
> 
>   ***** QUESTION *****: perhaps this is all systemtap needs? ignoring
>   UPROBE_FILTER_MMAP.
> 
> - Multiple consumers. uprobe_register/uprobe_unregister should be
>   modified so that register_for_each_vma() is called every time when
>   the new consumer comes or consumer goes away.
> 
>   uprobe_apply(add_remove => false) should obviously consult other
>   consumers too.


So in this case, would uprobe_register() just add a consumer to a
new/existing uprobe. The actual probe insertion is done by the
uprobe_apply()/uprobe_apply_all().  Also in this case, there is no
filter element in the uprobe_consumer. Right?

I am just wondering if people could use/misuse this 
for example: - somebody could keep modifying and reusing the consumers
but one probe registration,  with subsequent uprobe_apply(). 
Unlike now we could have lots of uprobes but all with defunct consumers.

> 
> - Perhaps we should teach handle_swbp() to remove the unwanted breakpoints.
> 
>   If every ->handler() returns, say, UPROBE_GO_AWAY handle_swbp() should
>   remove this breakpoint. Of course, a consumer must be sure that if it
>   returns UPROBE_GO_AWAY this task can't share ->mm with another task it
>   wants to trace.

Its a good idea to remove redundant probepoints from the breakpoint hit
context. However,

- even from the handlers() perspective, if we have to identify that this
  consumer isnt looking at this mm, we need something like
  for_each_mm_user(). No? 

- also if we are looking for removing a breakpoint, I would think its
  better done in common code, i.e uprobe code rather than keeping it in
  every handler. So I think keeping the filter logic before the handler
  is good.

> 
>   Or consumer->handler() can do uprobe_apply(add_remove => false) itself,
>   but this needs more discussion.
> 
>   The point is that if the filtering at UPROBE_FILTER_REGISTER time is
>   not possible, ->filter(UPROBE_FILTER_REGISTER) can return true. A
>   "wrong" int3 doesn't hurt until the task actually hits the breakpoint,
>   and I think that a single bp-hit is fine performance-wise.
> 

Agree. Also the reason why we inserted this probe in the current mm
might have changed and we might no more need the probe.
For example, traced thread in a multithreaded process actually died and
all other threads may not be interested

> - fork(). The child inherits all breakpoints from parent, and uprobes
>   can't control this. What can we do?
> 
> 	* We can add another uprobe hook which does something like
> 
> 	  	for_each_uprobe_in_each_vma(child_mm) {
> 	  		if (filter(UPROBE_FILTER_FORK))
> 	  			install_breakoint();
> 	  		else
> 	  			remove_breakpoint();
> 	  	}
> 
> 
> 	  But is is not clear where can we add this hook. dup_mmap()
> 	  looks appealing, but at this time the child is still under
> 	  construction, consumer->filter() can't look at task_struct.
> 
> 	  And of course, it is not nice to slow down fork().
> 
> 	* If we only care about the unwanted breakpoints, perhaps it
> 	  would be better to rely on UPROBE_GO_AWAY above?
> 
> 	* Finally, do we care at all? Again, who can ever need to
> 	  re-install breakpoints after fork?
> 
> 	  systemtap (iiuc) doesn't need this. And even if it does
> 	  or will need, I guess it can hook fork itself and use
> 	  uprobe_apply() ?


I was thinking if we can implement for_each_mm_user() using additional
mm->flags. 

Would something like this work?
- Set a new MMF_REPARENTED flag for a mm, when its thread either gets
  reparented or is called with CLONE_PARENT.

- for_each_mm_users would only be needed during uprobe_register /
  uprobe_mmap() if and only if there are filters.

- for_each_mm_users would mostly boil down to searching in children,
  siblings unless MMF_REPARENTED flag is set.
 
- If MMF_REPARENTED flag is set for a mm, and probe needs filtering,
  then we look at do_each_thread ..for_each_thread. This would mostly
  not be the common case. So I hope this should be okay. Not sure if we
  could look at further optimizing like looking at parent's children,
  init's children to see if any of them refer to mm.

-- 
Thanks and Regards
Srikar

