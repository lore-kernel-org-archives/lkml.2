Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2IUJa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:30:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60387 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab2IUJaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:30:19 -0400
Message-ID: <505C33B9.8000807@gmail.com>
Date: Fri, 21 Sep 2012 11:30:33 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <5050CCE0.4090403@gmail.com> <20120919153934.GB2455@linux.vnet.ibm.com> <5059F458.3000407@gmail.com> <20120919170648.GF2455@linux.vnet.ibm.com> <505AC6C8.9060706@linux.vnet.ibm.com> <505AC979.7000008@gmail.com> <20120920152341.GE2449@linux.vnet.ibm.com>
In-Reply-To: <20120920152341.GE2449@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 05:23 PM, Paul E. McKenney wrote:
> On Thu, Sep 20, 2012 at 09:44:57AM +0200, Sasha Levin wrote:
>> On 09/20/2012 09:33 AM, Michael Wang wrote:
>>> On 09/20/2012 01:06 AM, Paul E. McKenney wrote:
>>>> On Wed, Sep 19, 2012 at 06:35:36PM +0200, Sasha Levin wrote:
>>>>> On 09/19/2012 05:39 PM, Paul E. McKenney wrote:
>>>>>> On Wed, Sep 12, 2012 at 07:56:48PM +0200, Sasha Levin wrote:
>>>>>>>> Hi Paul,
>>>>>>>>
>>>>>>>> While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
>>>>>>>> "RCU used illegally from idle CPU!" warnings several times.
>>>>>>>>
>>>>>>>> There are a bunch of traces which seem to pop exactly at the same time and from
>>>>>>>> different places around the kernel. Here are several of them:
>>>>>> Hello, Sasha,
>>>>>>
>>>>>> OK, interesting.  Could you please try reproducing with the diagnostic
>>>>>> patch shown below?
>>>>>
>>>>> Sure - here are the results (btw, it reproduces very easily):
>>>>>
>>>>> [ 13.525119] ================================================
>>>>> [ 13.527165] [ BUG: lock held when returning to user space! ]
>>>>> [ 13.528752] 3.6.0-rc6-next-20120918-sasha-00002-g190c311-dirty #362 Tainted: GW
>>>>> [ 13.531314] ------------------------------------------------
>>>>> [ 13.532918] init/1 is leaving the kernel with locks still held!
>>>>> [ 13.534574] 1 lock held by init/1:
>>>>> [ 13.535533] #0: (rcu_idle){.+.+..}, at: [<ffffffff811c36d0>]
>>>>> rcu_eqs_enter_common+0x1a0/0x9a0
>>>>>
>>>>> I'm basically seeing lots of the above, so I can't even get to the point where I
>>>>> get the previous lockdep warnings.
>>>>
>>>> OK, that diagnostic patch was unhelpful.  Back to the drawing board...
>>>
>>> May be we could first make sure the cpu_idle() behave properly?
>>>
>>> Since according to the log, rcu think cpu is idle while current pid
>>> is not 0, that could happen if things broken in cpu_idle() which
>>> is very dependent on platform.
>>>
>>> So check it when idle thread was switched out may could be the first
>>> step? some thing like below.
>>>
>>> Regards,
>>> Michael Wang
>>>
>>> diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
>>> index b6baf37..f8c7354 100644
>>> --- a/kernel/sched/idle_task.c
>>> +++ b/kernel/sched/idle_task.c
>>> @@ -43,6 +43,7 @@ dequeue_task_idle(struct rq *rq, struct task_struct *p, int flags)
>>>  
>>>  static void put_prev_task_idle(struct rq *rq, struct task_struct *prev)
>>>  {
>>> +       WARN_ON(rcu_is_cpu_idle());
>>>  }
>>>  
>>>  static void task_tick_idle(struct rq *rq, struct task_struct *curr, int queued)
>>
>> Looks like you're on to something, with the small patch above applied:
>>
>> [   23.514223] ------------[ cut here ]------------
>> [   23.515496] WARNING: at kernel/sched/idle_task.c:46
>> put_prev_task_idle+0x1e/0x30()
>> [   23.517498] Pid: 0, comm: swapper/0 Tainted: G        W
>> 3.6.0-rc6-next-20120919-sasha-00001-gb54aafe-dirty #366
>> [   23.520393] Call Trace:
>> [   23.521882]  [<ffffffff8115167e>] ? put_prev_task_idle+0x1e/0x30
>> [   23.524220]  [<ffffffff81106736>] warn_slowpath_common+0x86/0xb0
>> [   23.524220]  [<ffffffff81106825>] warn_slowpath_null+0x15/0x20
>> [   23.524220]  [<ffffffff8115167e>] put_prev_task_idle+0x1e/0x30
>> [   23.524220]  [<ffffffff839ea61e>] __schedule+0x25e/0x8f0
>> [   23.524220]  [<ffffffff81175ebd>] ? tick_nohz_idle_exit+0x18d/0x1c0
>> [   23.524220]  [<ffffffff839ead05>] schedule+0x55/0x60
>> [   23.524220]  [<ffffffff81078540>] cpu_idle+0x90/0x160
>> [   23.524220]  [<ffffffff8383043c>] rest_init+0x130/0x144
>> [   23.524220]  [<ffffffff8383030c>] ? csum_partial_copy_generic+0x16c/0x16c
>> [   23.524220]  [<ffffffff858acc18>] start_kernel+0x38d/0x39a
>> [   23.524220]  [<ffffffff858ac5fe>] ? repair_env_string+0x5e/0x5e
>> [   23.524220]  [<ffffffff858ac326>] x86_64_start_reservations+0x101/0x105
>> [   23.524220]  [<ffffffff858ac472>] x86_64_start_kernel+0x148/0x157
>> [   23.524220] ---[ end trace 2c3061ab727afec2 ]---
> 
> It looks like someone is exiting the idle loop without telling RCU
> about it.  Architectures are supposed to invoke rcu_idle_exit() before
> they leave the idle loop.  This was in fact my guess yesterday, which is
> why I tried to enlist lockdep's help, forgetting that lockdep complains
> about holding a lock when entering the idle loop.
> 
> A couple of possible things to try:
> 
> 1.	Inspect the idle loop to see if it can invoke schedule() without
> 	invoking rcu_idle_exit().  This might happen indirectly, for
> 	example, by calling mutex_lock().
> 
> 2.	Bisect to see what caused the warning to appear -- perhaps when
> 	someone put a mutex_lock() or some such into the idle loop
> 	without protecting it with rcu_idle_exit() or RCU_NONIDLE().
> 
> Seem reasonable?

This might be unrelated, but I got the following dump as well when trinity
decided it's time to reboot my guest:

[ 122.627815] rcutorture thread rcu_torture_stats parking due to system shutdown
[ 168.790150] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 168.792799] (detected by 2, t=6502 jiffies)
[ 168.793814] INFO: Stall ended before state dump start
[ 242.600309] INFO: task init:1 blocked for more than 120 seconds.
[ 242.602151] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.603665] init D ffff88000d618000 3232 1 0 0x00000000
[ 242.604824] ffff88000d5b9a48 0000000000000002 ffff88000d5b9a18 ffffffff810a2d96
[ 242.606415] ffff88000d5b9fd8 ffff88000d5b9fd8 ffff88000d5b9fd8 ffff88000d5b9fd8
[ 242.607977] ffff88000d618000 ffff88000d5b0000 ffff88000d5b9a28 ffff88000d5b9be0
[ 242.609311] Call Trace:
[ 242.609767] [<ffffffff810a2d96>] ? kvm_clock_read+0x46/0x80
[ 242.610836] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.611372] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.612377] [<ffffffff8117a393>] ? mark_held_locks+0x113/0x130
[ 242.613407] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.614487] [<ffffffff839ef2db>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 242.615449] [<ffffffff839ee2a8>] wait_for_common+0x138/0x180
[ 242.616440] [<ffffffff8114cc10>] ? try_to_wake_up+0x360/0x360
[ 242.617460] [<ffffffff811c3850>] ? __call_rcu+0x6b0/0x6b0
[ 242.618408] [<ffffffff839ee398>] wait_for_completion+0x18/0x20
[ 242.619389] [<ffffffff81132eef>] wait_rcu_gp+0x6f/0xa0
[ 242.620227] [<ffffffff81130a90>] ? perf_trace_rcu_utilization+0xe0/0xe0
[ 242.621341] [<ffffffff839ee1b4>] ? wait_for_common+0x44/0x180
[ 242.622321] [<ffffffff811c91a6>] synchronize_rcu+0x86/0x90
[ 242.623252] [<ffffffff811fa745>] padata_replace+0x35/0xd0
[ 242.624166] [<ffffffff811fa8a6>] __padata_remove_cpu+0xc6/0x160
[ 242.625171] [<ffffffff811faccc>] padata_cpu_callback+0x2bc/0x350
[ 242.626184] [<ffffffff8113e01e>] notifier_call_chain+0xee/0x130
[ 242.627139] [<ffffffff8113e5f9>] __raw_notifier_call_chain+0x9/0x10
[ 242.628191] [<ffffffff8110a5fb>] __cpu_notify+0x1b/0x40
[ 242.629080] [<ffffffff8383584e>] _cpu_down+0xae/0x350
[ 242.629849] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.630662] [<ffffffff8110aa36>] disable_nonboot_cpus+0x86/0x1c0
[ 242.631687] [<ffffffff81124206>] kernel_restart+0x16/0x60
[ 242.632605] [<ffffffff81124481>] sys_reboot+0x151/0x2a0
[ 242.633495] [<ffffffff811c2b73>] ? rcu_cleanup_after_idle+0x23/0x170
[ 242.634565] [<ffffffff811c67c4>] ? rcu_eqs_exit_common+0x64/0x3a0
[ 242.635526] [<ffffffff811c6eb5>] ? rcu_user_exit+0xa5/0xd0
[ 242.636454] [<ffffffff8117a5ed>] ? trace_hardirqs_on+0xd/0x10
[ 242.637414] [<ffffffff8107cba0>] ? syscall_trace_enter+0x20/0x2e0
[ 242.638417] [<ffffffff839f0ce8>] tracesys+0xe1/0xe6
[ 242.639278] 4 locks held by init/1:
[ 242.639871] #0: (reboot_mutex){+.+.+.}, at: [<ffffffff81124406>]
sys_reboot+0xd6/0x2a0
[ 242.641265] #1: (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8110a6d2>]
cpu_maps_update_begin+0x12/0x20
[ 242.642780] #2: (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a68a>]
cpu_hotplug_begin+0x2a/0x60
[ 242.644272] #3: (&pinst->lock){+.+.+.}, at: [<ffffffff811facc1>]
padata_cpu_callback+0x2b1/0x350
[ 242.645805] INFO: task kworker/u:0:6 blocked for more than 120 seconds.
[ 242.646901] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.648199] kworker/u:0 D ffff88000d620000 4288 6 2 0x00000000
[ 242.649405] ffff88000d5dba38 0000000000000002 ffff88000d5dba08 ffffffff810a2d96
[ 242.650659] ffff88000d5dbfd8 ffff88000d5dbfd8 ffff88000d5dbfd8 ffff88000d5dbfd8
[ 242.651887] ffff88000d620000 ffff88000d5d3000 ffff88000d5dba18 ffff88000d5dbbd0
[ 242.653083] Call Trace:
[ 242.653468] [<ffffffff810a2d96>] ? kvm_clock_read+0x46/0x80
[ 242.654274] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.655107] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.656037] [<ffffffff8117a393>] ? mark_held_locks+0x113/0x130
[ 242.656970] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.658012] [<ffffffff839ef2db>] ? _raw_spin_unlock_irq+0x2b/0x80
[ 242.658977] [<ffffffff839ee2a8>] wait_for_common+0x138/0x180
[ 242.659931] [<ffffffff8114cc10>] ? try_to_wake_up+0x360/0x360
[ 242.660846] [<ffffffff811c3850>] ? __call_rcu+0x6b0/0x6b0
[ 242.661721] [<ffffffff839ee398>] wait_for_completion+0x18/0x20
[ 242.662590] [<ffffffff81132eef>] wait_rcu_gp+0x6f/0xa0
[ 242.663470] [<ffffffff81130a90>] ? perf_trace_rcu_utilization+0xe0/0xe0
[ 242.664553] [<ffffffff839ee1b4>] ? wait_for_common+0x44/0x180
[ 242.665547] [<ffffffff811c91a6>] synchronize_rcu+0x86/0x90
[ 242.666473] [<ffffffff8336d305>] synchronize_net+0x35/0x40
[ 242.667368] [<ffffffff834f97d5>] xfrm_user_net_exit+0x25/0x80
[ 242.668313] [<ffffffff83360625>] ops_exit_list.isra.0+0x65/0x70
[ 242.669285] [<ffffffff83360fe0>] cleanup_net+0x130/0x1b0
[ 242.670166] [<ffffffff8112a7a9>] process_one_work+0x3b9/0x770
[ 242.671094] [<ffffffff8112a658>] ? process_one_work+0x268/0x770
[ 242.672064] [<ffffffff81177a52>] ? get_lock_stats+0x22/0x70
[ 242.672984] [<ffffffff83360eb0>] ? net_drop_ns+0x40/0x40
[ 242.673818] [<ffffffff8112b12a>] worker_thread+0x2ba/0x3f0
[ 242.674711] [<ffffffff8112ae70>] ? rescuer_thread+0x2d0/0x2d0
[ 242.675643] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.676402] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.677384] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.678333] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.679253] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.680226] 3 locks held by kworker/u:0/6:
[ 242.680898] #0: (netns){.+.+.+}, at: [<ffffffff8112a658>]
process_one_work+0x268/0x770
[ 242.682206] #1: (net_cleanup_work){+.+.+.}, at: [<ffffffff8112a658>]
process_one_work+0x268/0x770
[ 242.683681] #2: (net_mutex){+.+.+.}, at: [<ffffffff83360f30>]
cleanup_net+0x80/0x1b0
[ 242.684978] INFO: task rcu_preempt:11 blocked for more than 120 seconds.
[ 242.686061] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.687290] rcu_preempt D ffff88000d618000 5520 11 2 0x00000000
[ 242.688393] ffff88000d5f5c38 0000000000000002 0000000000000006 ffff88000d5f8000
[ 242.689629] ffff88000d5f5fd8 ffff88000d5f5fd8 ffff88000d5f5fd8 ffff88000d5f5fd8
[ 242.690884] ffff88000d618000 ffff88000d5f8000 ffffffff839ec3c5 ffffffff84c50948
[ 242.692184] Call Trace:
[ 242.692598] [<ffffffff839ec3c5>] ? __mutex_lock_common+0x335/0x5a0
[ 242.693652] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.694485] [<ffffffff839edb53>] schedule_preempt_disabled+0x13/0x20
[ 242.695549] [<ffffffff839ec3fd>] __mutex_lock_common+0x36d/0x5a0
[ 242.696555] [<ffffffff8110a737>] ? get_online_cpus+0x37/0x50
[ 242.697537] [<ffffffff811501a8>] ? sched_clock_cpu+0xf8/0x110
[ 242.698479] [<ffffffff8110a737>] ? get_online_cpus+0x37/0x50
[ 242.699379] [<ffffffff839ec66f>] mutex_lock_nested+0x3f/0x50
[ 242.700254] [<ffffffff8110a737>] get_online_cpus+0x37/0x50
[ 242.701120] [<ffffffff811c731a>] rcu_gp_kthread+0x27a/0xeb0
[ 242.702066] [<ffffffff839eda0d>] ? __schedule+0x81d/0x8f0
[ 242.702945] [<ffffffff81137180>] ? abort_exclusive_wait+0xb0/0xb0
[ 242.703884] [<ffffffff811c70a0>] ? rcu_gp_fqs+0x80/0x80
[ 242.704701] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.705476] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.706512] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.707512] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.708456] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.709709] 1 lock held by rcu_preempt/11:
[ 242.710610] #0: (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a737>]
get_online_cpus+0x37/0x50
[ 242.712078] INFO: task rcu_torture_wri:2723 blocked for more than 120 seconds.
[ 242.713270] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.714533] rcu_torture_wri D ffff88000cdb8000 5696 2723 2 0x00000000
[ 242.715552] ffff88000cf0dce8 0000000000000002 ffff88000cf0dc98 ffffffff819e89d8
[ 242.716769] ffff88000cf0dfd8 ffff88000cf0dfd8 ffff88000cf0dfd8 ffff88000cf0dfd8
[ 242.717983] ffff88000cdb8000 ffff88000cd93000 0000000000000043 ffffffff845bb016
[ 242.719188] Call Trace:
[ 242.719598] [<ffffffff819e89d8>] ? do_raw_spin_unlock+0xc8/0xe0
[ 242.720599] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.721397] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.722322] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.723162] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.724250] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.725276] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.726214] [<ffffffff811be3ac>] rcu_torture_writer+0x1cc/0x240
[ 242.727267] [<ffffffff811be1e0>] ? cpumask_next+0x80/0x80
[ 242.728175] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.728961] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.729922] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.730949] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.731920] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.732970] no locks held by rcu_torture_wri/2723.
[ 242.733733] INFO: task rcu_torture_fak:2724 blocked for more than 120 seconds.
[ 242.734912] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.736208] rcu_torture_fak D ffff88000d61b000 5664 2724 2 0x00000000
[ 242.737342] ffff88000ce19ce8 0000000000000002 0000000010000000 ffffffff839f01f4
[ 242.738551] ffff88000ce19fd8 ffff88000ce19fd8 ffff88000ce19fd8 ffff88000ce19fd8
[ 242.739748] ffff88000d61b000 ffff88000cd90000 ffff88000cd90000 ffffffff845baf2b
[ 242.740974] Call Trace:
[ 242.741359] [<ffffffff839f01f4>] ? retint_restore_args+0x13/0x13
[ 242.742404] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.743479] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.744222] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.745178] [<ffffffff811c3850>] ? __call_rcu+0x6b0/0x6b0
[ 242.746094] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.747171] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.747946] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.748985] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.750141] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.751192] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.752130] [<ffffffff811bd53f>] rcu_torture_fakewriter+0xef/0x160
[ 242.753112] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.753922] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.754866] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.755675] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.756630] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.757585] no locks held by rcu_torture_fak/2724.
[ 242.758384] INFO: task rcu_torture_fak:2725 blocked for more than 120 seconds.
[ 242.759566] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.760850] rcu_torture_fak D ffffffff84c2e420 5664 2725 2 0x00000000
[ 242.761958] ffff88000ce1dce8 0000000000000002 ffff88000ce1dc98 ffffffff819e89d8
[ 242.763130] ffff88000ce1dfd8 ffff88000ce1dfd8 ffff88000ce1dfd8 ffff88000ce1dfd8
[ 242.764332] ffffffff84c2e420 ffff88000cdbb000 0000000000000047 ffffffff845baf2b
[ 242.765544] Call Trace:
[ 242.765968] [<ffffffff819e89d8>] ? do_raw_spin_unlock+0xc8/0xe0
[ 242.766934] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.767980] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.768821] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.769766] [<ffffffff811c3850>] ? __call_rcu+0x6b0/0x6b0
[ 242.770687] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.771804] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.772593] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.773693] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.774831] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.775775] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.776626] [<ffffffff811bd53f>] rcu_torture_fakewriter+0xef/0x160
[ 242.777667] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.778480] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.779459] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.780477] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.781425] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.782415] no locks held by rcu_torture_fak/2725.
[ 242.783161] INFO: task rcu_torture_fak:2726 blocked for more than 120 seconds.
[ 242.784285] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.785547] rcu_torture_fak D ffff88000ce53000 5456 2726 2 0x00000000
[ 242.786678] ffff88000ce1fce8 0000000000000002 ffff88000ce1fc98 ffffffff819e89d8
[ 242.787915] ffff88000ce1ffd8 ffff88000ce1ffd8 ffff88000ce1ffd8 ffff88000ce1ffd8
[ 242.789090] ffff88000ce53000 ffff88000cdb8000 0000000000000047 ffffffff845baf2b
[ 242.790363] Call Trace:
[ 242.790746] [<ffffffff819e89d8>] ? do_raw_spin_unlock+0xc8/0xe0
[ 242.791737] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.792741] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.793554] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.794479] [<ffffffff811c3850>] ? __call_rcu+0x6b0/0x6b0
[ 242.795335] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.796348] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.797184] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.798273] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.799395] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.800481] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.801419] [<ffffffff811bd53f>] rcu_torture_fakewriter+0xef/0x160
[ 242.802428] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.803252] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.804223] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.805139] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.806090] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.807048] no locks held by rcu_torture_fak/2726.
[ 242.807751] INFO: task rcu_torture_fak:2727 blocked for more than 120 seconds.
[ 242.808900] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.810177] rcu_torture_fak D ffff88000ce50000 5664 2727 2 0x00000000
[ 242.811315] ffff88000cc9dce8 0000000000000002 ffff88000cc9dc98 ffffffff819e89d8
[ 242.812595] ffff88000cc9dfd8 ffff88000cc9dfd8 ffff88000cc9dfd8 ffff88000cc9dfd8
[ 242.813887] ffff88000ce50000 ffff88000ce13000 0000000000000047 ffffffff845baf2b
[ 242.815161] Call Trace:
[ 242.815570] [<ffffffff819e89d8>] ? do_raw_spin_unlock+0xc8/0xe0
[ 242.816465] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.817562] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.818330] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.819220] [<ffffffff811c3850>] ? __call_rcu+0x6b0/0x6b0
[ 242.820109] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.821110] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.821902] [<ffffffff811bd450>] ? rcu_torture_barrier_cbs+0x210/0x210
[ 242.822994] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.824162] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.825153] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.826093] [<ffffffff811bd53f>] rcu_torture_fakewriter+0xef/0x160
[ 242.827131] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.827878] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.828894] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.829907] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.830870] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.831850] no locks held by rcu_torture_fak/2727.
[ 242.832651] INFO: task rcu_torture_rea:2728 blocked for more than 120 seconds.
[ 242.833865] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.835127] rcu_torture_rea D ffff88000d5d3000 5520 2728 2 0x00000000
[ 242.836253] ffff88000cc9fc38 0000000000000002 ffff88000cc9fbe8 ffffffff819e89d8
[ 242.837537] ffff88000cc9ffd8 ffff88000cc9ffd8 ffff88000cc9ffd8 ffff88000cc9ffd8
[ 242.838749] ffff88000d5d3000 ffff88000ce10000 0000000000000043 ffffffff845bb084
[ 242.839942] Call Trace:
[ 242.840382] [<ffffffff819e89d8>] ? do_raw_spin_unlock+0xc8/0xe0
[ 242.841376] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.842157] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.843051] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.843842] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.845005] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.846087] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.847034] [<ffffffff811bf67e>] rcu_torture_reader+0x34e/0x450
[ 242.848038] [<ffffffff8114418a>] ? finish_task_switch+0x3a/0x110
[ 242.849022] [<ffffffff811bf780>] ? rcu_torture_reader+0x450/0x450
[ 242.850058] [<ffffffff811bf330>] ? rcutorture_trace_dump+0x40/0x40
[ 242.851044] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.851859] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.852922] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.853941] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.854928] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.855942] no locks held by rcu_torture_rea/2728.
[ 242.856700] INFO: task rcu_torture_rea:2729 blocked for more than 120 seconds.
[ 242.857862] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[ 242.859116] rcu_torture_rea D ffff88001b64b000 5520 2729 2 0x00000000
[ 242.860295] ffff88000ce59c38 0000000000000002 ffff88000ce59be8 ffffffff819e89d8
[ 242.861549] ffff88000ce59fd8 ffff88000ce59fd8 ffff88000ce59fd8 ffff88000ce59fd8
[ 242.862732] ffff88001b64b000 ffff88000ce53000 0000000000000043 ffffffff845bb084
[ 242.863969] Call Trace:
[ 242.864385] [<ffffffff819e89d8>] ? do_raw_spin_unlock+0xc8/0xe0
[ 242.865388] [<ffffffff839edb35>] schedule+0x55/0x60
[ 242.866224] [<ffffffff839ebab5>] schedule_timeout+0x45/0x360
[ 242.867201] [<ffffffff83992a98>] ? printk+0x5c/0x5e
[ 242.868030] [<ffffffff839ebe29>] schedule_timeout_uninterruptible+0x19/0x20
[ 242.869170] [<ffffffff811bc63f>] rcutorture_shutdown_absorb+0x2f/0x40
[ 242.870280] [<ffffffff811bc94a>] rcu_stutter_wait+0x4a/0x70
[ 242.871204] [<ffffffff811bf67e>] rcu_torture_reader+0x34e/0x450
[ 242.872168] [<ffffffff8114418a>] ? finish_task_switch+0x3a/0x110
[ 242.873061] [<ffffffff811bf780>] ? rcu_torture_reader+0x450/0x450
[ 242.874059] [<ffffffff811bf330>] ? rcutorture_trace_dump+0x40/0x40
[ 242.875162] [<ffffffff81135db3>] kthread+0xe3/0xf0
[ 242.876017] [<ffffffff81177ade>] ? put_lock_stats.isra.16+0xe/0x40
[ 242.877081] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.878076] [<ffffffff839f1e85>] kernel_thread_helper+0x5/0x10
[ 242.879034] [<ffffffff81135cd0>] ? insert_kthread_work+0x90/0x90
[ 242.880089] no locks held by rcu_torture_rea/2729.

