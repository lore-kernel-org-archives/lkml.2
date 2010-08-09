Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0HIQEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 12:04:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53631 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab0HIQEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 12:04:21 -0400
Date: Mon, 9 Aug 2010 09:04:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl
Subject: Re: 2.6.35-rc3-git4 - kernel/sched.c:616 invoked
 rcu_dereference_check() 	without protection!
Message-ID: <20100809160400.GB3026@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTini6hz2LFeZi8CMUmY3xw1MU7NxmyesuxZ4oCdo@mail.gmail.com>
 <20100701221810.GI2345@linux.vnet.ibm.com>
 <AANLkTikGJCbX8Rp9ghh63oMc5p9raQtpg7ZWc7pJ8yFq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikGJCbX8Rp9ghh63oMc5p9raQtpg7ZWc7pJ8yFq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 01:31:10PM -0400, Ilia Mirkin wrote:
> On Thu, Jul 1, 2010 at 6:18 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Jul 01, 2010 at 08:21:43AM -0400, Miles Lane wrote:
> >> [ INFO: suspicious rcu_dereference_check() usage. ]
> >> ---------------------------------------------------
> >> kernel/sched.c:616 invoked rcu_dereference_check() without protection!
> >>
> >> other info that might help us debug this:
> >>
> >> rcu_scheduler_active = 1, debug_locks = 1
> >> 3 locks held by swapper/1:
> >>   #0:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff81042914>]
> >> cpu_maps_update_begin+0x12/0x14
> >>   #1:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8104294f>]
> >> cpu_hotplug_begin+0x27/0x4e
> >>   #2:  (&rq->lock){-.-...}, at: [<ffffffff812f8502>] init_idle+0x2b/0x114
> >
> > Hello, Miles!
> >
> > I believe that this one is fixed by commit dc61b1d6 in -tip.
> 
> Hi Paul,
> 
> Looks like that commit made it into 2.6.35:
> 
> git tag -l --contains dc61b1d65e353d638b2445f71fb8e5b5630f2415 v2.6.35*
> v2.6.35
> v2.6.35-rc4
> v2.6.35-rc5
> v2.6.35-rc6
> 
> However I still get:
> 
> [    0.051203] CPU0: AMD QEMU Virtual CPU version 0.12.4 stepping 03
> [    0.052999] lockdep: fixing up alternatives.
> [    0.054105]
> [    0.054106] ===================================================
> [    0.054999] [ INFO: suspicious rcu_dereference_check() usage. ]
> [    0.054999] ---------------------------------------------------
> [    0.054999] kernel/sched.c:616 invoked rcu_dereference_check()
> without protection
> !
> [    0.054999]
> [    0.054999] other info that might help us debug this:
> [    0.054999]
> [    0.054999]
> [    0.054999] rcu_scheduler_active = 1, debug_locks = 1
> [    0.054999] 3 locks held by swapper/1:
> [    0.054999]  #0:  (cpu_add_remove_lock){+.+.+.}, at:
> [<ffffffff814be933>] cpu_up+
> 0x42/0x6a
> [    0.054999]  #1:  (cpu_hotplug.lock){+.+.+.}, at:
> [<ffffffff810400d8>] cpu_hotplu
> g_begin+0x2a/0x51
> [    0.054999]  #2:  (&rq->lock){-.-...}, at: [<ffffffff814be2f7>]
> init_idle+0x2f/0x
> 113
> [    0.054999]
> [    0.054999] stack backtrace:
> [    0.054999] Pid: 1, comm: swapper Not tainted 2.6.35 #1
> [    0.054999] Call Trace:
> [    0.054999]  [<ffffffff81068054>] lockdep_rcu_dereference+0x9b/0xa3
> [    0.054999]  [<ffffffff810325c3>] task_group+0x7b/0x8a
> [    0.054999]  [<ffffffff810325e5>] set_task_rq+0x13/0x40
> [    0.054999]  [<ffffffff814be39a>] init_idle+0xd2/0x113
> [    0.054999]  [<ffffffff814be78a>] fork_idle+0xb8/0xc7
> [    0.054999]  [<ffffffff81068717>] ? mark_held_locks+0x4d/0x6b
> [    0.054999]  [<ffffffff814bcebd>] do_fork_idle+0x17/0x2b
> [    0.054999]  [<ffffffff814bc89b>] native_cpu_up+0x1c1/0x724
> [    0.054999]  [<ffffffff814bcea6>] ? do_fork_idle+0x0/0x2b
> [    0.054999]  [<ffffffff814be876>] _cpu_up+0xac/0x127
> [    0.054999]  [<ffffffff814be946>] cpu_up+0x55/0x6a
> [    0.054999]  [<ffffffff81ab562a>] kernel_init+0xe1/0x1ff
> [    0.054999]  [<ffffffff81003854>] kernel_thread_helper+0x4/0x10
> [    0.054999]  [<ffffffff814c353c>] ? restore_args+0x0/0x30
> [    0.054999]  [<ffffffff81ab5549>] ? kernel_init+0x0/0x1ff
> [    0.054999]  [<ffffffff81003850>] ? kernel_thread_helper+0x0/0x10
> [    0.056074] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
> [    0.130045]  #2lockdep: fixing up alternatives.
> [    0.203089]  #3 Ok.
> [    0.275286] Brought up 4 CPUs
> [    0.276005] Total of 4 processors activated (16017.17 BogoMIPS).

This does look like a new one, thank you for reporting it!

Here is my analysis, which should at least provide some humor value to
those who understand the code better than I do.  ;-)

So the corresponding rcu_dereference_check() is in
task_subsys_state_check(), and is fetching the cpu_cgroup_subsys_id
element of the newly created task's task->cgroups->subsys[] array.
The "git grep" command finds only three uses of cpu_cgroup_subsys_id,
but no definition.

Now, fork_idle() invokes copy_process(), which invokes cgroup_fork(),
which sets the child process's ->cgroups pointer to that of the parent,
also invoking get_css_set(), which increments the corresponding reference
count, doing both operations under task_lock() protection (->alloc_lock).
Because fork_idle() does not specify any of CLONE_NEWNS, CLONE_NEWUTS,
CLONE_NEWIPC, CLONE_NEWPID, or CLONE_NEWNET, copy_namespaces() should
not create a new namespace, and so there should be no ns_cgroup_clone().
We should thus retain the parent's ->cgroups pointer.  And copy_process()
installs the new task in the various lists, so that the task is externally
accessible upon return.

After a non-error return from copy_process(), fork_init() invokes
init_idle_pid(), which does not appear to affect the task's cgroup
state.  Next fork_init() invokes init_idle(), which in turn invokes
__set_task_cpu(), which invokes set_task_rq(), which calls task_group()
several times, which calls task_subsys_state_check(), which calls the
rcu_dereference_check() that complained above.

However, the result returns by rcu_dereference_check() is stored into
the task structure:

	p->se.cfs_rq = task_group(p)->cfs_rq[cpu];
	p->se.parent = task_group(p)->se[cpu];

This means that the corresponding structure must have been tied down with
a reference count or some such.  If such a reference has been taken, then
this complaint is a false positive, and could be suppressed by putting
rcu_read_lock() and rcu_read_unlock() around the call to init_idle()
from fork_idle().  However, although, reference to the enclosing ->cgroups
struct css_set is held, it is not clear to me that this reference applies
to the structures pointed to by the ->subsys[] array, especially given
that the cgroup_subsys_state structures referenced by this array have
their own reference count, which does not appear to me to be acquired
by this code path.

Or are the cgroup_subsys_state structures referenced by idle tasks
never freed or some such?

							Thanx, Paul
