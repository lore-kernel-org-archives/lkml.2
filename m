Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608Ab1JaJdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:33:45 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:40763 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab1JaJdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:33:43 -0400
Date: Mon, 31 Oct 2011 02:32:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com, shaohua.li@intel.com,
        ak@linux.intel.com, mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
Message-ID: <20111031093256.GI6160@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111003161335.GA2403@linux.vnet.ibm.com>
 <20111004074637.GA14061@elte.hu>
 <20111024100501.GA24913@linux.vnet.ibm.com>
 <20111024114806.GA3340@linux.vnet.ibm.com>
 <20111026203020.GA10285@elte.hu>
 <20111027075901.GB2313@linux.vnet.ibm.com>
 <20111027080016.GA16885@elte.hu>
 <4EAA14A1.5060204@cn.fujitsu.com>
 <20111029182710.GG6160@linux.vnet.ibm.com>
 <4EAE57AF.1060706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAE57AF.1060706@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11103109-8974-0000-0000-000001432399
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 04:09:19PM +0800, Li Zefan wrote:
> (Let's cc Peter and Paul Turner for this perf cgroup issue.)
> 
> > Thank you for the analysis.  Does the following patch fix this problem?
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > fs: Add RCU protection in set_task_comm()
> > 
> > Running "perf stat true" results in the following RCU-lockdep splat:
> > 
> > ===============================
> > [ INFO: suspicious RCU usage. ]
> > -------------------------------
> > include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
> > 
> > other info that might help us debug this:
> > 
> > rcu_scheduler_active = 1, debug_locks = 0
> > 1 lock held by true/655:
> > #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<810d1bd7>] prepare_bprm_creds+0x27/0x70
> > 
> > stack backtrace:
> > Pid: 655, comm: true Not tainted 3.1.0-tip-01868-g1271bd2-dirty #161079
> > Call Trace:
> > [<81abe239>] ? printk+0x18/0x1a
> > [<81064920>] lockdep_rcu_suspicious+0xc0/0xd0
> > [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
> > [<81063764>] ? __lock_release+0x54/0xb0
> > [<8108cca8>] perf_event_comm+0x18/0x60
> > [<810d1abd>] ? set_task_comm+0x5d/0x80
> > [<81af622d>] ? _raw_spin_unlock+0x1d/0x40
> > [<810d1ac4>] set_task_comm+0x64/0x80
> > [<810d25fd>] setup_new_exec+0xbd/0x1d0
> > [<810d1b61>] ? flush_old_exec+0x81/0xa0
> > [<8110753e>] load_elf_binary+0x28e/0xa00
> > [<810d2101>] ? search_binary_handler+0xd1/0x1d0
> > [<81063764>] ? __lock_release+0x54/0xb0
> > [<811072b0>] ? load_elf_library+0x260/0x260
> > [<810d2108>] search_binary_handler+0xd8/0x1d0
> > [<810d2060>] ? search_binary_handler+0x30/0x1d0
> > [<810d242f>] do_execve_common+0x22f/0x2a0
> > [<810d24b2>] do_execve+0x12/0x20
> > [<81009592>] sys_execve+0x32/0x70
> > [<81af7752>] ptregs_execve+0x12/0x20
> > [<81af76d4>] ? sysenter_do_call+0x12/0x36
> > 
> > Li Zefan noted that this is due to set_task_comm() dropping the task
> > lock before invoking perf_event_comm(), which could in fact result in
> > the task being freed up before perf_event_comm() completed tracing in
> > the case where one task invokes set_task_comm() on another task -- which
> > actually does occur via comm_write(), which can be invoked via /proc.
> > 
> 
> This is not true. The caller should ensure @tsk is valid during
> set_task_comm().
> 
> The warning comes from perf_cgroup_from_task(). We can trigger this warning
> in some other cases where perf cgroup is used, for example:

I must defer to your greater knowledge of this situation.  What patch
would you propose?

							Thanx, Paul

> # mount -t cgroup -o perf_event xxx /mnt
> # ./perf record -a -e 'sched:*' -G / true
> 
> [  171.603171] ===============================
> [  171.603173] [ INFO: suspicious RCU usage. ]
> [  171.603175] -------------------------------
> [  171.603178] include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
> [  171.603180] 
> [  171.603181] other info that might help us debug this:
> [  171.603182] 
> [  171.603184] 
> [  171.603185] rcu_scheduler_active = 1, debug_locks = 0
> [  171.603188] 2 locks held by perf/2899:
> [  171.603190]  #0:  (&cpuctx_mutex){+.+...}, at: [<c04b2fe7>] sys_perf_event_open+0x4ed/0x62a
> [  171.603201]  #1:  (&cpuctx_lock){......}, at: [<c04ac4bc>] perf_ctx_lock+0xe/0x1d
> [  171.603210] 
> [  171.603211] stack backtrace:
> [  171.603214] Pid: 2899, comm: perf Not tainted 3.1.0+ #12
> [  171.603216] Call Trace:
> [  171.603222]  [<c07e7234>] ? printk+0x25/0x29
> [  171.603227]  [<c046279d>] lockdep_rcu_suspicious+0x90/0x9b
> [  171.603232]  [<c04ac688>] perf_cgroup_from_task+0x5e/0x64
> [  171.603236]  [<c04adfe7>] update_cgrp_time_from_event.clone.18+0x16/0x25
> [  171.603240]  [<c04b01a1>] __perf_install_in_context+0xa0/0xcf
> [  171.603244]  [<c04ac355>] ? pmu_dev_release+0xa/0xa
> [  171.603248]  [<c04ac386>] remote_function+0x31/0x37
> [  171.603253]  [<c0468aaa>] smp_call_function_single+0x7d/0xf5
> [  171.603257]  [<c04ac41d>] cpu_function_call+0x29/0x2e
> [  171.603261]  [<c04b0101>] ? perf_pm_suspend_cpu+0x9f/0x9f
> [  171.603264]  [<c04ae85b>] perf_install_in_context+0x53/0x9f
> [  171.603268]  [<c04b3033>] sys_perf_event_open+0x539/0x62a
> [  171.603273]  [<c04566f5>] ? up_read+0x1b/0x2e
> [  171.603277]  [<c07ec856>] ? do_page_fault+0x2e6/0x314
> [  171.603283]  [<c07ef2df>] sysenter_do_call+0x12/0x38
> 
> > This commit fixes this problem by entering an RCU read-side critical
> > section before acquiring the task lock and exiting this critical section
> > after perf_event_comm() returns.
> > 
> > Reported-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 25dcbe5..fb928d3 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1056,6 +1056,7 @@ EXPORT_SYMBOL_GPL(get_task_comm);
> >  
> >  void set_task_comm(struct task_struct *tsk, char *buf)
> >  {
> > +	rcu_read_lock(); /* protect task pointer through tracing. */
> >  	task_lock(tsk);
> >  
> >  	/*
> > @@ -1069,6 +1070,7 @@ void set_task_comm(struct task_struct *tsk, char *buf)
> >  	strlcpy(tsk->comm, buf, sizeof(tsk->comm));
> >  	task_unlock(tsk);
> >  	perf_event_comm(tsk);
> > +	rcu_read_unlock();
> >  }
> >  
> >  int flush_old_exec(struct linux_binprm * bprm)
> > 
> 

