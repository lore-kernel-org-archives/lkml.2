Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab2KETEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 14:04:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5644 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506Ab2KETEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 14:04:09 -0500
Date: Mon, 5 Nov 2012 20:04:46 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Josh Stone <jistone@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: uprobes && pre-filtering
Message-ID: <20121105190446.GA6188@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

There is a known (and by design) problem with uprobes. They act
systemwide, there is no pre-filtering. Just some random thoughts
to provoke the discussion.

- I think that the current uprobe_consumer->filter(task) should die.

  It buys nothing. It is called right before ->handler() and this is
  pointless, ->handler() can call it itself.

  And more importantly, I do not think this hook (with the same
  semantics) can/should be used by both register and handler_chain().

- We should change register_ and and mmap to filter out the tasks
  which we do not want to trace. To simplify, lets forget about
  multiple consumers first.

  Everything is simple, install_breakpoint() callers should simply
  call consumer->filter(args) and do nothing if it returns false.

  The main problem is, what should be passed as "args". I think it is
  pointless to use task_struct as an argument. And not because there
  is no simple way to find all tasks which use this particular mm in
  register_for_each_vma(), even if it was possible I think this makes
  no sense.

  If 2 tasks/threads share the same mm they will share int3 as well,
  so I think we need

  	enum filter_mode {
  		UPROBE_FILTER_REGISTER,
  		UPROBE_FILTER_MMAP,
  		/* more */
  	};

  	consumer->filter(enum filter_mode mode, struct mm_struct *mm);

  Sure, this does not allow to, say, probe the tasks with the given uid.
  But once again, currently we do not have for_each_mm_user(task, mm)
  and even if we implement it

  	a) ->filter(mm) can use it itself)

  	b) I do not think register_for_each_vma() should call it.

  	   Suppose that a consumer wants to track the task with the
  	   given pid PID. In this case ->filter() can simply check
  	   find_task_by_vpid(PID)->mm = mm. This is fast and simple.

  	   Or you want to probe all instances of /bin/ls. In this case
  	   filter() can check mm->exe_file->f_path == saved_path, this
  	   is very cheap.

  	   But if we add for_each_mm_user() into register_for_each_vma()
  	   it will be called even if the filtering is simple.

  So. If filter(UPROBE_FILTER_REGISTER) needs to check task_uid(task) == UID
  it has to do for_each_process() until we have (if ever) for_each_mm_user().

  Or it should always return true and remove the unnecessary breakpoints
  later, or use another API (see below).

  Also. Who needs the "nontrivial" filtering? I do not see any potential
  in-kernel user. And the tools like systemtap can take another approach
  (perhaps).

- Perhaps we should extend the API. We can add

	uprobe_apply(consumer, task, bool add_remove);

  which adds/removes breakpoints to task->mm.

  This way consumer can probe every task it wants to trace after
  uprobe_register().

  Its ->filter(UPROBE_FILTER_REGISTER) should simply return false. Or,
  better, we can split uprobe_register() into 2 functions,
  __uprobe_register() and uprobe_apply_all() which actually does
  register_for_each_vma().

  ***** QUESTION *****: perhaps this is all systemtap needs? ignoring
  UPROBE_FILTER_MMAP.

- Multiple consumers. uprobe_register/uprobe_unregister should be
  modified so that register_for_each_vma() is called every time when
  the new consumer comes or consumer goes away.

  uprobe_apply(add_remove => false) should obviously consult other
  consumers too.

- Perhaps we should teach handle_swbp() to remove the unwanted breakpoints.

  If every ->handler() returns, say, UPROBE_GO_AWAY handle_swbp() should
  remove this breakpoint. Of course, a consumer must be sure that if it
  returns UPROBE_GO_AWAY this task can't share ->mm with another task it
  wants to trace.

  Or consumer->handler() can do uprobe_apply(add_remove => false) itself,
  but this needs more discussion.

  The point is that if the filtering at UPROBE_FILTER_REGISTER time is
  not possible, ->filter(UPROBE_FILTER_REGISTER) can return true. A
  "wrong" int3 doesn't hurt until the task actually hits the breakpoint,
  and I think that a single bp-hit is fine performance-wise.

- fork(). The child inherits all breakpoints from parent, and uprobes
  can't control this. What can we do?

	* We can add another uprobe hook which does something like

	  	for_each_uprobe_in_each_vma(child_mm) {
	  		if (filter(UPROBE_FILTER_FORK))
	  			install_breakoint();
	  		else
	  			remove_breakpoint();
	  	}


	  But is is not clear where can we add this hook. dup_mmap()
	  looks appealing, but at this time the child is still under
	  construction, consumer->filter() can't look at task_struct.

	  And of course, it is not nice to slow down fork().

	* If we only care about the unwanted breakpoints, perhaps it
	  would be better to rely on UPROBE_GO_AWAY above?

	* Finally, do we care at all? Again, who can ever need to
	  re-install breakpoints after fork?

	  systemtap (iiuc) doesn't need this. And even if it does
	  or will need, I guess it can hook fork itself and use
	  uprobe_apply() ?

Please comment.

Oleg.

