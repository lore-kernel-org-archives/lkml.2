Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0KGTni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 14:43:38 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48115 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750834Ab0KGTng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 14:43:36 -0500
Date: Sun, 7 Nov 2010 11:43:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: sergey.senozhatsky@gmail.com, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] rcu_read_lock/unlock protect find_task_by_vpid call
Message-ID: <20101107194330.GE15561@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20101029125550.GA3932@swordfish.minsk.epam.com>
 <20101029201648.GK2367@linux.vnet.ibm.com>
 <20101030093234.GK3932@swordfish.minsk.epam.com>
 <201010302214.DDF98906.MSFJOFtFHOLQVO@I-love.SAKURA.ne.jp>
 <20101030210244.GE2664@linux.vnet.ibm.com>
 <201010310833.CCE89052.FtQFHSOFLOOJMV@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010310833.CCE89052.FtQFHSOFLOOJMV@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 08:33:35AM +0900, Tetsuo Handa wrote:
> Paul E. McKenney wrote:
> > So we should remove the lockdep_tasklist_lock_is_held() and then
> > apply Sergey's patch, correct?
> 
> Yes. rcu_lockdep_assert(rcu_read_lock_held()) in find_task_by_pid_ns()
> is correct and callers need to use rcu_read_lock().
> 
> As of 2.6.32, there are 20+ users who missed rcu_read_lock().
> So, similar reports will be posted like popcorn.
> http://kerneltrap.org/mailarchive/linux-kernel/2009/12/11/4518016

OK, let's see how these are in 2.6.36...   The summary is that almost
all of the popcorn kernels have already popped.

> Users missing read_lock(&tasklist_lock) when calling find_task_by_vpid():
> 
>   get_net_ns_by_pid() in net/core/net_namespace.c

	Fixed with rcu_read_lock().

>   seq_print_userip_objs() in kernel/trace/trace_output.c

	Fixed with rcu_read_lock().

>   fill_pid() in kernel/taskstats.c

	This one seems to be named fill_stats_for_pid(), and it
	is fixed with rcu_read_lock().

>   fill_tgid() in kernel/taskstats.c

	This one seems to be named fill_stats_for_tgid(), and it
	is fixed with rcu_read_lock().

>   futex_find_get_task() in kernel/futex.c

	Fixed with rcu_read_lock().

>   SYSCALL_DEFINE3(get_robust_list) in kernel/futex.c

	Fixed with rcu_read_lock().

>   compat_sys_get_robust_list() in kernel/futex_compat.c

	Fixed with rcu_read_lock().

>   ptrace_get_task_struct() in kernel/ptrace.c

	Fixed with rcu_read_lock().

>   do_send_specific() in kernel/signal.c

	Fixed with rcu_read_lock().

>   find_get_context() in kernel/perf_event.c

	Fixed with rcu_read_lock() plus code motion.

>   posix_cpu_clock_get() in kernel/posix-cpu-timers.c

	Fixed with rcu_read_lock().

>   good_sigevent() in kernel/posix-timers.c

	Fixed with rcu_read_lock() in caller.

>   attach_task_by_pid() in kernel/cgroup.c

	Fixed with rcu_read_lock().

>   SYSCALL_DEFINE1(getpgid) in kernel/sys.c

	Fixed with rcu_read_lock().

>   SYSCALL_DEFINE1(getsid) in kernel/sys.c

	Fixed with rcu_read_lock().

>   do_sched_setscheduler() in kernel/sched.c

	Fixed with rcu_read_lock().

> 
> Users missing rcu_read_lock() when calling find_task_by_vpid():
> 
>   SYSCALL_DEFINE3(ioprio_set) in fs/ioprio.c

	Patches in flight.

>   SYSCALL_DEFINE2(ioprio_get) in fs/ioprio.c

	Patches in flight.

>   cap_get_target_pid() in kernel/capability.c

	Fixed with rcu_read_lock().

>   audit_prepare_user_tty() in kernel/audit.c

	Fixed with rcu_read_lock().

>   audit_receive_msg() in kernel/audit.c

	Fixed with rcu_read_lock(), two instances.

>   check_clock() in kernel/posix-cpu-timers.c

	This one has read_lock(&tasklist_lock).

>   posix_cpu_timer_create() in kernel/posix-cpu-timers.c

	This one has read_lock(&tasklist_lock).

>   SYSCALL_DEFINE3(setpriority) in kernel/sys.c

	This one has both read_lock(&tasklist_lock) and rcu_read_lock().
	Both belt -and- suspenders...

>   SYSCALL_DEFINE2(getpriority) in kernel/sys.c

	Ditto.

>   SYSCALL_DEFINE2(setpgid) in kernel/sys.c

	This one has both write_lock_irq(&tasklist_lock) and
	rcu_read_lock().  -Serious- belt along with the suspenders...

>   SYSCALL_DEFINE1(sched_getscheduler) in kernel/sched.c

	Fixed with rcu_read_lock().

>   SYSCALL_DEFINE2(sched_getparam) in kernel/sched.c

	Fixed with rcu_read_lock().

>   sched_setaffinity() in kernel/sched.c

	Fixed with rcu_read_lock().

>   sched_getaffinity() in kernel/sched.c

	Fixed with rcu_read_lock().

>   SYSCALL_DEFINE2(sched_rr_get_interval) in kernel/sched.c

	Fixed with rcu_read_lock().

>   tomoyo_is_select_one() in security/tomoyo/common.c

	This one has both read_lock(&tasklist_lock) and rcu_read_lock().
	Both belt -and- suspenders...  (Also renamed to tomoyo_select_one().)

>   tomoyo_read_pid() in security/tomoyo/common.c

	This one has both read_lock(&tasklist_lock) and rcu_read_lock().
	Both belt -and- suspenders...

>   SYSCALL_DEFINE6(move_pages) in mm/migrate.c

	This one does read_lock(&tasklist_lock).

>   SYSCALL_DEFINE4(migrate_pages) in mm/mempolicy.c

	No call to find_task_by_vpid() in migrate_pages() anymore,
	but there is one protected by read_lock(&tasklist_lock) in
	move_pages().

>   find_process_by_pid() in arch/mips/kernel/mips-mt-fpaff.c

	No change, so let's check the callers:

	mipsmt_sys_sched_setaffinity(): rcu_read_lock().
	mipsmt_sys_sched_getaffinity(): read_lock(&tasklist_lock).
	do_sched_setscheduler(): rcu_read_lock().
	sched_getscheduler(): rcu_read_lock().
	sched_getparam(): rcu_read_lock().
	sched_setaffinity(): rcu_read_lock().
	sched_getaffinity(); rcu_read_lock().
	sched_rr_get_interval(): rcu_read_lock().

	So all of these are protected.

>   pfm_get_task() in arch/ia64/kernel/perfmon.c

	This one does read_lock(&tasklist_lock).

>   cxn_pin_by_pid() in arch/frv/mm/mmu-context.c

	This one does read_lock(&tasklist_lock).

> 
> Users missing read_lock(&tasklist_lock) when calling find_task_by_pid_ns():
> 
>   rest_init() in init/main.c

	Fixed with rcu_read_lock().

>   proc_pid_lookup() in fs/proc/base.c

	Fixed with rcu_read_lock().

>   proc_task_lookup() in fs/proc/base.c

	Fixed with rcu_read_lock().

>   first_tid() in fs/proc/base.c

	Fixed with rcu_read_lock().

>   getthread() in kernel/kgdb.c

	This is now in kernel/debug/gdbstub.c...  It looks to need
	an rcu_read_lock().  It has a comment, but...

>   mconsole_stack() in arch/um/drivers/mconsole_kern.c

	This one still needs help.

> 
> Users missing rcu_read_lock() when calling find_task_by_pid_ns():
> 
>   rest_init() in init/main.c

	Fixed with rcu_read_lock().

>   getthread() in kernel/kgdb.c

	This one still needs help.

>   mconsole_stack() in arch/um/drivers/mconsole_kern.c

	This one still needs help.

So mostly there...

							Thanx, Paul
