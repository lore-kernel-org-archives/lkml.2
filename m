Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596Ab1KGOYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 09:24:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46929 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab1KGOYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 09:24:37 -0500
MIME-Version: 1.0
In-Reply-To: <CABPqkBR=dB3E1ba-cR7L5A2uknidBJTMdMBNFzyr+zsmjuxacw@mail.gmail.com>
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
	<20111031093256.GI6160@linux.vnet.ibm.com>
	<4EAF5B68.8090005@cn.fujitsu.com>
	<CABPqkBS-fio57xePQ76LLxPxVMJRM1cKzU1DgXH7q9oNG54N8Q@mail.gmail.com>
	<4EB3A5DA.3080305@cn.fujitsu.com>
	<CABPqkBR=dB3E1ba-cR7L5A2uknidBJTMdMBNFzyr+zsmjuxacw@mail.gmail.com>
Date: Mon, 7 Nov 2011 14:24:36 +0000
Message-ID: <CABPqkBTbxBbRqvS-+L2ex3ZTPT+Xy-T_eqf3iTCpq+-tnOpbnw@mail.gmail.com>
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.1
From: Stephane Eranian <eranian@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        eric.dumazet@gmail.com, shaohua.li@intel.com, ak@linux.intel.com,
        mhocko@suse.cz, alex.shi@intel.com, efault@gmx.de,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some second thoughts on this.

We get the warning because:

#define task_subsys_state_check(task, subsys_id, __c)                   \
        rcu_dereference_check(task->cgroups->subsys[subsys_id],         \
                              lockdep_is_held(&task->alloc_lock) ||     \
                              cgroup_lock_is_held() || (__c))


In other words, we need the alloc_lock held.

What I don't quite understand in your patch in the connection
between rcu and this particular task lock. Unless holding
the rcu read lock implies you necessarily hold the alloc_lock.

Can you explain?



On Fri, Nov 4, 2011 at 9:02 AM, Stephane Eranian <eranian@google.com> wrote:
> On Fri, Nov 4, 2011 at 8:44 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Stephane Eranian wrote:
>>> Paul,
>>>
>>> On Tue, Nov 1, 2011 at 2:37 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>> (I shoud have cced Stephane Eranian instead of Turner..)
>>>>
>>>> Paul E. McKenney wrote:
>>>>> On Mon, Oct 31, 2011 at 04:09:19PM +0800, Li Zefan wrote:
>>>>>> (Let's cc Peter and Paul Turner for this perf cgroup issue.)
>>>>>>
>>>>>>> Thank you for the analysis.  Does the following patch fix this problem?
>>>>>>>
>>>>>>>                                                     Thanx, Paul
>>>>>>>
>>>>>>> ------------------------------------------------------------------------
>>>>>>>
>>>>>>> fs: Add RCU protection in set_task_comm()
>>>>>>>
>>>>>>> Running "perf stat true" results in the following RCU-lockdep splat:
>>>>>>>
>>>>>>> ===============================
>>>>>>> [ INFO: suspicious RCU usage. ]
>>>>>>> -------------------------------
>>>>>>> include/linux/cgroup.h:548 suspicious rcu_dereference_check() usage!
>>>>>>>
>>>>>>> other info that might help us debug this:
>>>>>>>
>>>>>>> rcu_scheduler_active = 1, debug_locks = 0
>>>>>>> 1 lock held by true/655:
>>>>>>> #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<810d1bd7>] prepare_bprm_creds+0x27/0x70
>>>>>>>
>>>>>>> stack backtrace:
>>>>>>> Pid: 655, comm: true Not tainted 3.1.0-tip-01868-g1271bd2-dirty #161079
>>>>>>> Call Trace:
>>>>>>> [<81abe239>] ? printk+0x18/0x1a
>>>>>>> [<81064920>] lockdep_rcu_suspicious+0xc0/0xd0
>>>>>>> [<8108aa02>] perf_event_enable_on_exec+0x1d2/0x1e0
>>>>>>> [<81063764>] ? __lock_release+0x54/0xb0
>>>>>>> [<8108cca8>] perf_event_comm+0x18/0x60
>>>>>>> [<810d1abd>] ? set_task_comm+0x5d/0x80
>>>>>>> [<81af622d>] ? _raw_spin_unlock+0x1d/0x40
>>>>>>> [<810d1ac4>] set_task_comm+0x64/0x80
>>>>>>> [<810d25fd>] setup_new_exec+0xbd/0x1d0
>>>>>>> [<810d1b61>] ? flush_old_exec+0x81/0xa0
>>>>>>> [<8110753e>] load_elf_binary+0x28e/0xa00
>>>>>>> [<810d2101>] ? search_binary_handler+0xd1/0x1d0
>>>>>>> [<81063764>] ? __lock_release+0x54/0xb0
>>>>>>> [<811072b0>] ? load_elf_library+0x260/0x260
>>>>>>> [<810d2108>] search_binary_handler+0xd8/0x1d0
>>>>>>> [<810d2060>] ? search_binary_handler+0x30/0x1d0
>>>>>>> [<810d242f>] do_execve_common+0x22f/0x2a0
>>>>>>> [<810d24b2>] do_execve+0x12/0x20
>>>>>>> [<81009592>] sys_execve+0x32/0x70
>>>>>>> [<81af7752>] ptregs_execve+0x12/0x20
>>>>>>> [<81af76d4>] ? sysenter_do_call+0x12/0x36
>>>>>>>
>>>>>>> Li Zefan noted that this is due to set_task_comm() dropping the task
>>>>>>> lock before invoking perf_event_comm(), which could in fact result in
>>>>>>> the task being freed up before perf_event_comm() completed tracing in
>>>>>>> the case where one task invokes set_task_comm() on another task -- which
>>>>>>> actually does occur via comm_write(), which can be invoked via /proc.
>>>>>>>
>>>>>>
>>>>>> This is not true. The caller should ensure @tsk is valid during
>>>>>> set_task_comm().
>>>>>>
>>>>>> The warning comes from perf_cgroup_from_task(). We can trigger this warning
>>>>>> in some other cases where perf cgroup is used, for example:
>>>>>
>>>>> I must defer to your greater knowledge of this situation.  What patch
>>>>> would you propose?
>>>>>
>>>>
>>>> With the following patch, we should see no rcu warning from perf, but as I
>>>> don't know the internel of perf, I guess we have to defer to Peter and
>>>> Stephane. ;)
>>>>
>>>> I have two doubts:
>>>>
>>>> - in perf_cgroup_sched_out/in(), we retrieve the task's cgroup twice in the function
>>>> and it's callee perf_cgroup_switch(), but the task can move to another cgroup between
>>>> two calls, so they might return two different cgroup pointers. Does it matter?
>>>>
>>> We don't retrieve the task cgroup twice. We retrieve the cgroup for
>>> each of the two
>>> tasks: current and prev or next.
>>>
>>> I don't understand what you mean by 'between two calls'. Two calls of
>>> which function?
>>>
>>
>> perf_cgroup_sched_out(task, next)
>> {
>>        cgrp1 = perf_cgroup_from_task(task);
>>        ...
>>        perf_cgroup_switch(task, PERF_CGROUP_SWOUT);
>> }
>>
>> perf_cgroup_switch(task)
>> {
>>        ...
>>        cpuctx->cgrp = perf_cgroup_from_task(task);
>> }
>>
> Ok, yes it may happen that we call it twice.
>
> I tested your patch and it looks good to me. I would make the
> following adjustments though:
> - perf_cgroup_set_timestamp(), move rcu_read_unlock() before
> info->timestamp = as it is not needed
>  for this statement.
>
>
>> So we call perf_cgroup_from_task() twice on @task. Just want to be sure the code
>> is not problematic.
>>
>>>> - in perf_cgroup_switch():
>>>>
>>>>         cpuctx->cgrp = perf_cgroup_from_task(task);
>>>>
>>>> but seems the cgroup is not pinned, so cpuctx->cgrp can be invalid in later use.
>>>>
>>> What do you mean by cgroup pinning?
>>>
>>> If a task migrates from one cgroup to another, the cgroup code calls
>>> ss->attach_task
>>> which ends up in perf_cgroup_attach_task() if the task is currently
>>> running on a CPU.
>>> If so perf_cgroup_switch() is eventually called and it will update
>>> cpuctx->cgrp. If the
>>> tasks is not running anywhere, then there is nothing to do, state will
>>> be updated when
>>> the task is scheduled back in.
>>>
>>
>> Thanks for clarification!
>>
>
