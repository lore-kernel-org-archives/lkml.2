Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab1J3I11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 04:27:27 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:44119 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab1J3I1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 04:27:25 -0400
Date: Sat, 29 Oct 2011 11:27:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com, shaohua.li@intel.com,
        ak@linux.intel.com, mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
Message-ID: <20111029182710.GG6160@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111001152514.GA16930@elte.hu>
 <20111003055302.GA23527@elte.hu>
 <20111003161335.GA2403@linux.vnet.ibm.com>
 <20111004074637.GA14061@elte.hu>
 <20111024100501.GA24913@linux.vnet.ibm.com>
 <20111024114806.GA3340@linux.vnet.ibm.com>
 <20111026203020.GA10285@elte.hu>
 <20111027075901.GB2313@linux.vnet.ibm.com>
 <20111027080016.GA16885@elte.hu>
 <4EAA14A1.5060204@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAA14A1.5060204@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11103008-3534-0000-0000-0000010AA511
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 10:34:09AM +0800, Li Zefan wrote:
> >>>>
> >>>> And I cannot reproduce after merging into 3.1.  :-(
> >>>
> >>> Here's another one i just got with latest -tip:
> >>>
> >>> PM: Adding info for No Bus:vcsa2
> >>>
> >>> ===============================
> >>> [ INFO: suspicious RCU usage. ]
> >>> -------------------------------
> >>> include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
> >>>
> >>> other info that might help us debug this:
> >>>
> >>>
> >>> rcu_scheduler_active = 1, debug_locks = 0
> >>> 1 lock held by true/655:
> >>>  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<810d1bd7>] prepare_bprm_creds+0x27/0x70
> >>>
> >>> stack backtrace:
> >>> Pid: 655, comm: true Not tainted 3.1.0-tip-01868-g1271bd2-dirty #161079
> >>> Call Trace:
> >>>  [<81abe239>] ? printk+0x18/0x1a
> >>>  [<81064920>] lockdep_rcu_suspicious+0xc0/0xd0
> >>>  [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
> >>>  [<81063764>] ? __lock_release+0x54/0xb0
> >>>  [<8108cca8>] perf_event_comm+0x18/0x60
> >>>  [<810d1abd>] ? set_task_comm+0x5d/0x80
> 
> void set_task_comm(struct task_struct *tsk, char *buf)
> {
>         task_lock(tsk);
> 	...
>         task_unlock(tsk);
>         perf_event_comm(tsk);
> }
> 
> see, perf_event_comm() is called after releasing task_lock.
> 
> perf_event_comm()
>   perf_event_enable_on_exec()
>     perf_cgroup_sched_out()
>       perf_cgroup_from_task()
>         task_subsys_state()
> 
> No proper lock is held, hence the warning.

Thank you for the analysis.  Does the following patch fix this problem?

							Thanx, Paul

------------------------------------------------------------------------

fs: Add RCU protection in set_task_comm()

Running "perf stat true" results in the following RCU-lockdep splat:

===============================
[ INFO: suspicious RCU usage. ]
-------------------------------
include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!

other info that might help us debug this:

rcu_scheduler_active = 1, debug_locks = 0
1 lock held by true/655:
#0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<810d1bd7>] prepare_bprm_creds+0x27/0x70

stack backtrace:
Pid: 655, comm: true Not tainted 3.1.0-tip-01868-g1271bd2-dirty #161079
Call Trace:
[<81abe239>] ? printk+0x18/0x1a
[<81064920>] lockdep_rcu_suspicious+0xc0/0xd0
[<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
[<81063764>] ? __lock_release+0x54/0xb0
[<8108cca8>] perf_event_comm+0x18/0x60
[<810d1abd>] ? set_task_comm+0x5d/0x80
[<81af622d>] ? _raw_spin_unlock+0x1d/0x40
[<810d1ac4>] set_task_comm+0x64/0x80
[<810d25fd>] setup_new_exec+0xbd/0x1d0
[<810d1b61>] ? flush_old_exec+0x81/0xa0
[<8110753e>] load_elf_binary+0x28e/0xa00
[<810d2101>] ? search_binary_handler+0xd1/0x1d0
[<81063764>] ? __lock_release+0x54/0xb0
[<811072b0>] ? load_elf_library+0x260/0x260
[<810d2108>] search_binary_handler+0xd8/0x1d0
[<810d2060>] ? search_binary_handler+0x30/0x1d0
[<810d242f>] do_execve_common+0x22f/0x2a0
[<810d24b2>] do_execve+0x12/0x20
[<81009592>] sys_execve+0x32/0x70
[<81af7752>] ptregs_execve+0x12/0x20
[<81af76d4>] ? sysenter_do_call+0x12/0x36

Li Zefan noted that this is due to set_task_comm() dropping the task
lock before invoking perf_event_comm(), which could in fact result in
the task being freed up before perf_event_comm() completed tracing in
the case where one task invokes set_task_comm() on another task -- which
actually does occur via comm_write(), which can be invoked via /proc.

This commit fixes this problem by entering an RCU read-side critical
section before acquiring the task lock and exiting this critical section
after perf_event_comm() returns.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/fs/exec.c b/fs/exec.c
index 25dcbe5..fb928d3 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1056,6 +1056,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
 
 void set_task_comm(struct task_struct *tsk, char *buf)
 {
+	rcu_read_lock(); /* protect task pointer through tracing. */
 	task_lock(tsk);
 
 	/*
@@ -1069,6 +1070,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
 	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
 	task_unlock(tsk);
 	perf_event_comm(tsk);
+	rcu_read_unlock();
 }
 
 int flush_old_exec(struct linux_binprm * bprm)

