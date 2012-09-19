Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550Ab2ISW1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 18:27:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47969 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab2ISW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 18:27:21 -0400
Message-ID: <505A46D5.2020409@gmail.com>
Date: Thu, 20 Sep 2012 00:27:33 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <5050CCE0.4090403@gmail.com> <20120919153934.GB2455@linux.vnet.ibm.com> <5059F458.3000407@gmail.com> <20120919170648.GF2455@linux.vnet.ibm.com>
In-Reply-To: <20120919170648.GF2455@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2012 07:06 PM, Paul E. McKenney wrote:
> On Wed, Sep 19, 2012 at 06:35:36PM +0200, Sasha Levin wrote:
>> On 09/19/2012 05:39 PM, Paul E. McKenney wrote:
>>> On Wed, Sep 12, 2012 at 07:56:48PM +0200, Sasha Levin wrote:
>>>>> Hi Paul,
>>>>>
>>>>> While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
>>>>> "RCU used illegally from idle CPU!" warnings several times.
>>>>>
>>>>> There are a bunch of traces which seem to pop exactly at the same time and from
>>>>> different places around the kernel. Here are several of them:
>>> Hello, Sasha,
>>>
>>> OK, interesting.  Could you please try reproducing with the diagnostic
>>> patch shown below?
>>
>> Sure - here are the results (btw, it reproduces very easily):
>>
>> [ 13.525119] ================================================
>> [ 13.527165] [ BUG: lock held when returning to user space! ]
>> [ 13.528752] 3.6.0-rc6-next-20120918-sasha-00002-g190c311-dirty #362 Tainted: GW
>> [ 13.531314] ------------------------------------------------
>> [ 13.532918] init/1 is leaving the kernel with locks still held!
>> [ 13.534574] 1 lock held by init/1:
>> [ 13.535533] #0: (rcu_idle){.+.+..}, at: [<ffffffff811c36d0>]
>> rcu_eqs_enter_common+0x1a0/0x9a0
>>
>> I'm basically seeing lots of the above, so I can't even get to the point where I
>> get the previous lockdep warnings.
> 
> OK, that diagnostic patch was unhelpful.  Back to the drawing board...

Not sure if it's related, but I'm seeing this during guest shutdown:

[  602.020174] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.025010] Disabling non-boot CPUs ...
[  602.027180] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.780182] rcu-torture: rtc: ffffffff86480c00 ver: 745 tfle: 0 rta: 745
rtaf: 0 rtf: 744 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 5744 onoff:
0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
[  602.780182] rcu-torture: Reader Pipe:  805299 14 0 0 0 0 0 0 0 0 0
[  602.780182] rcu-torture: Reader Batch:  805307 6 0 0 0 0 0 0 0 0 0
[  602.780182] rcu-torture: Free-Block Circulation:  744 744 744 744 744 744 744
744 744 744 0
[  602.784782] rcutorture thread rcu_torture_stats parking due to system shutdown
[  602.850145] rcutorture thread rcu_torture_stutter parking due to system shutdown
[  602.950402] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.952262] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.953628] rcutorture thread rcu_torture_fakewriter parking due to system
shutdown
[  602.955100] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.956775] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.958121] rcutorture thread rcu_torture_fakewriter parking due to system
shutdown
[  602.959677] rcutorture thread rcu_torture_fakewriter parking due to system
shutdown
[  602.960213] rcutorture thread rcu_torture_reader parking due to system shutdown
[  602.960222] rcutorture thread rcu_torture_writer parking due to system shutdown
[  602.960263] rcutorture thread rcu_torture_fakewriter parking due to system
shutdown
[  602.960277] rcutorture thread rcu_torture_reader parking due to system shutdown
[  667.060185] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  667.062678] 	(detected by 1, t=6502 jiffies)
[  667.064549] INFO: Stall ended before state dump start
[  722.680332] INFO: task init:1 blocked for more than 120 seconds.
[  722.685077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  722.686542] init            D ffff880035600000  3528     1      0 0x00000000
[  722.687638]  ffff88000d5b3a48 0000000000000002 ffff88000d5b3a18 ffffffff810a2d96
[  722.688756]  ffff88000d5b3fd8 ffff88000d5b3fd8 ffff88000d5b3fd8 ffff88000d5b3fd8
[  722.690137]  ffff880035600000 ffff88000d5b8000 ffff88000d5b3a28 ffff88000d5b3be0
[  722.691487] Call Trace:
[  722.691926]  [<ffffffff810a2d96>] ? kvm_clock_read+0x46/0x80
[  722.692877]  [<ffffffff839eace5>] schedule+0x55/0x60
[  722.693716]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  722.694702]  [<ffffffff8117a1f3>] ? mark_held_locks+0x113/0x130
[  722.695654]  [<ffffffff8117793e>] ? put_lock_stats.isra.16+0xe/0x40
[  722.696757]  [<ffffffff839ec48b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  722.697796]  [<ffffffff839eb458>] wait_for_common+0x138/0x180
[  722.698778]  [<ffffffff8114ca70>] ? try_to_wake_up+0x360/0x360
[  722.699793]  [<ffffffff811c4650>] ? __call_rcu+0x6b0/0x6b0
[  722.700883]  [<ffffffff839eb548>] wait_for_completion+0x18/0x20
[  722.701832]  [<ffffffff81132d4f>] wait_rcu_gp+0x6f/0xa0
[  722.702675]  [<ffffffff811308f0>] ? perf_trace_rcu_utilization+0xe0/0xe0
[  722.703791]  [<ffffffff839eb364>] ? wait_for_common+0x44/0x180
[  722.704693]  [<ffffffff811c9026>] synchronize_rcu+0x86/0x90
[  722.705623]  [<ffffffff811fa3c5>] padata_replace+0x35/0xd0
[  722.706498]  [<ffffffff811fa526>] __padata_remove_cpu+0xc6/0x160
[  722.707486]  [<ffffffff811fa94c>] padata_cpu_callback+0x2bc/0x350
[  722.708534]  [<ffffffff8113de7e>] notifier_call_chain+0xee/0x130
[  722.709524]  [<ffffffff8113e459>] __raw_notifier_call_chain+0x9/0x10
[  722.710925]  [<ffffffff8110a4ab>] __cpu_notify+0x1b/0x40
[  722.711817]  [<ffffffff8383133e>] _cpu_down+0xae/0x350
[  722.712679]  [<ffffffff8398fc88>] ? printk+0x5c/0x5e
[  722.713516]  [<ffffffff8110a8e6>] disable_nonboot_cpus+0x86/0x1c0
[  722.714526]  [<ffffffff811240c6>] kernel_restart+0x16/0x60
[  722.715435]  [<ffffffff81124341>] sys_reboot+0x151/0x2a0
[  722.716316]  [<ffffffff811c5d13>] ? rcu_cleanup_after_idle+0x23/0x170
[  722.717415]  [<ffffffff811c6624>] ? rcu_eqs_exit_common+0x64/0x3a0
[  722.718453]  [<ffffffff811c6d15>] ? rcu_user_exit+0xa5/0xd0
[  722.719372]  [<ffffffff8117a44d>] ? trace_hardirqs_on+0xd/0x10
[  722.720531]  [<ffffffff8107c8f0>] ? syscall_trace_enter+0x20/0x2e0
[  722.721759]  [<ffffffff839edea8>] tracesys+0xe1/0xe6
[  722.722614] 4 locks held by init/1:
[  722.723123]  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff811242c6>]
sys_reboot+0xd6/0x2a0
[  722.724537]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8110a582>]
cpu_maps_update_begin+0x12/0x20
[  722.726129]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a53a>]
cpu_hotplug_begin+0x2a/0x60
[  722.727609]  #3:  (&pinst->lock){+.+.+.}, at: [<ffffffff811fa941>]
padata_cpu_callback+0x2b1/0x350
[  722.729133] INFO: task rcu_preempt:11 blocked for more than 120 seconds.
[  722.730370] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  722.731686] rcu_preempt     D ffff88000d620000  5480    11      2 0x00000000
[  722.732901]  ffff88000d5fbc20 0000000000000002 0000000000000006 ffff88000d600000
[  722.734177]  ffff88000d5fbfd8 ffff88000d5fbfd8 ffff88000d5fbfd8 ffff88000d5fbfd8
[  722.735456]  ffff88000d620000 ffff88000d600000 ffffffff839e9575 ffffffff84c50948
[  722.736707] Call Trace:
[  722.737122]  [<ffffffff839e9575>] ? __mutex_lock_common+0x335/0x5a0
[  722.738165]  [<ffffffff839eace5>] schedule+0x55/0x60
[  722.739001]  [<ffffffff839ead03>] schedule_preempt_disabled+0x13/0x20
[  722.740098]  [<ffffffff839e95ad>] __mutex_lock_common+0x36d/0x5a0
[  722.741410]  [<ffffffff8110a5e7>] ? get_online_cpus+0x37/0x50
[  722.742645]  [<ffffffff81150008>] ? sched_clock_cpu+0xf8/0x110
[  722.743627]  [<ffffffff8110a5e7>] ? get_online_cpus+0x37/0x50
[  722.744599]  [<ffffffff839e981f>] mutex_lock_nested+0x3f/0x50
[  722.745484]  [<ffffffff8110a5e7>] get_online_cpus+0x37/0x50
[  722.746418]  [<ffffffff811c718f>] rcu_gp_kthread+0x28f/0xed0
[  722.747314]  [<ffffffff839ec48b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  722.748350]  [<ffffffff81136fe0>] ? abort_exclusive_wait+0xb0/0xb0
[  722.749303]  [<ffffffff811c6f00>] ? rcu_gp_fqs+0x80/0x80
[  722.750358]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  722.751124]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  722.752048]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  722.753023]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  722.754006]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  722.754905] 1 lock held by rcu_preempt/11:
[  722.755590]  #0:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a5e7>]
get_online_cpus+0x37/0x50
[  722.757584] INFO: task rcu_torture_rea:2728 blocked for more than 120 seconds.
[  722.759393] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  722.761810] rcu_torture_rea D ffff88000d620000  5512  2728      2 0x00000000
[  722.763586]  ffff880034c3bc30 0000000000000002 0000000000000001 0000000010000000
[  722.765069]  ffff880034c3bfd8 ffff880034c3bfd8 ffff880034c3bfd8 ffff880034c3bfd8
[  722.766211]  ffff88000d620000 ffff8800356fb000 0000000000000000 ffffffff845c0398
[  722.767470] Call Trace:
[  722.767891]  [<ffffffff839eace5>] schedule+0x55/0x60
[  722.768707]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  722.769651]  [<ffffffff8398fc88>] ? printk+0x5c/0x5e
[  722.770441]  [<ffffffff839e8fd9>] schedule_timeout_uninterruptible+0x19/0x20
[  722.771624]  [<ffffffff811bc49f>] rcutorture_shutdown_absorb+0x2f/0x40
[  722.772695]  [<ffffffff811bc7aa>] rcu_stutter_wait+0x4a/0x70
[  722.773627]  [<ffffffff811bf4de>] rcu_torture_reader+0x34e/0x450
[  722.774626]  [<ffffffff81143fea>] ? finish_task_switch+0x3a/0x110
[  722.775649]  [<ffffffff811bf5e0>] ? rcu_torture_reader+0x450/0x450
[  722.776463]  [<ffffffff811bf190>] ? rcutorture_trace_dump+0x40/0x40
[  722.776964]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  722.777526]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  722.778543]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  722.779564]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  722.780552]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  722.781403] no locks held by rcu_torture_rea/2728.
[  722.782221] INFO: task rcu_torture_rea:2733 blocked for more than 120 seconds.
[  722.783478] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  722.784770] rcu_torture_rea D ffff88000d618000  5512  2733      2 0x00000000
[  722.785969]  ffff880034d09c30 0000000000000002 ffff880034d09be0 ffffffff819e6eb8
[  722.787240]  ffff880034d09fd8 ffff880034d09fd8 ffff880034d09fd8 ffff880034d09fd8
[  722.788486]  ffff88000d618000 ffff880035600000 0000000000000043 ffffffff845c0398
[  722.789640] Call Trace:
[  722.790159]  [<ffffffff819e6eb8>] ? do_raw_spin_unlock+0xc8/0xe0
[  722.791127]  [<ffffffff839eace5>] schedule+0x55/0x60
[  722.791979]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  722.792939]  [<ffffffff819d3bee>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  722.794014]  [<ffffffff8398fc88>] ? printk+0x5c/0x5e
[  722.794864]  [<ffffffff839e8fd9>] schedule_timeout_uninterruptible+0x19/0x20
[  722.796050]  [<ffffffff811bc49f>] rcutorture_shutdown_absorb+0x2f/0x40
[  722.797145]  [<ffffffff811bc7aa>] rcu_stutter_wait+0x4a/0x70
[  722.798091]  [<ffffffff811bf4de>] rcu_torture_reader+0x34e/0x450
[  722.799021]  [<ffffffff81143fea>] ? finish_task_switch+0x3a/0x110
[  722.799995]  [<ffffffff811bf5e0>] ? rcu_torture_reader+0x450/0x450
[  722.801154]  [<ffffffff811bf190>] ? rcutorture_trace_dump+0x40/0x40
[  722.802186]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  722.803007]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  722.803995]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  722.805015]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  722.806048]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  722.806931] no locks held by rcu_torture_rea/2733.
[  722.807754] INFO: task kworker/u:2:3994 blocked for more than 120 seconds.
[  722.808895] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  722.810090] kworker/u:2     D ffff8800356fb000  3144  3994      2 0x00000000
[  722.811344]  ffff880028de9a50 0000000000000002 0000000000000006 ffff88002973b000
[  722.812546]  ffff880028de9fd8 ffff880028de9fd8 ffff880028de9fd8 ffff880028de9fd8
[  722.813759]  ffff8800356fb000 ffff88002973b000 ffffffff839e9575 ffffffff84c50948
[  722.814970] Call Trace:
[  722.815363]  [<ffffffff839e9575>] ? __mutex_lock_common+0x335/0x5a0
[  722.816324]  [<ffffffff839eace5>] schedule+0x55/0x60
[  722.817126]  [<ffffffff839ead03>] schedule_preempt_disabled+0x13/0x20
[  722.818198]  [<ffffffff839e95ad>] __mutex_lock_common+0x36d/0x5a0
[  722.819261]  [<ffffffff8110a5e7>] ? get_online_cpus+0x37/0x50
[  722.820356]  [<ffffffff8110a5e7>] ? get_online_cpus+0x37/0x50
[  722.821328]  [<ffffffff839e981f>] mutex_lock_nested+0x3f/0x50
[  722.822292]  [<ffffffff8110a5e7>] get_online_cpus+0x37/0x50
[  722.823227]  [<ffffffff811c9053>] synchronize_rcu_expedited+0x23/0x250
[  722.824323]  [<ffffffff833698d5>] synchronize_net+0x25/0x40
[  722.825258]  [<ffffffff83369a05>] rollback_registered_many+0x115/0x240
[  722.826359]  [<ffffffff83369c34>] unregister_netdevice_many+0x14/0x60
[  722.827583]  [<ffffffff8355bdf3>] ip6gre_exit_net+0x273/0x290
[  722.828937]  [<ffffffff8355bb80>] ? ip6gre_tunnel_uninit+0x1b0/0x1b0
[  722.830323]  [<ffffffff8335cce5>] ops_exit_list.isra.0+0x45/0x70
[  722.831436]  [<ffffffff8335d6c0>] cleanup_net+0x130/0x1b0
[  722.832564]  [<ffffffff8112a039>] process_one_work+0x3b9/0x770
[  722.833577]  [<ffffffff81129ee8>] ? process_one_work+0x268/0x770
[  722.834683]  [<ffffffff811778b2>] ? get_lock_stats+0x22/0x70
[  722.835601]  [<ffffffff8335d590>] ? net_drop_ns+0x40/0x40
[  722.837311]  [<ffffffff8112a9ba>] worker_thread+0x2ba/0x3f0
[  722.838626]  [<ffffffff8112a700>] ? rescuer_thread+0x2d0/0x2d0
[  722.839750]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  722.840709]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  722.841761]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  722.842749]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  722.843734]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  722.844626] 5 locks held by kworker/u:2/3994:
[  722.845352]  #0:  (netns){.+.+.+}, at: [<ffffffff81129ee8>]
process_one_work+0x268/0x770
[  722.846585]  #1:  (net_cleanup_work){+.+.+.}, at: [<ffffffff81129ee8>]
process_one_work+0x268/0x770
[  722.848008]  #2:  (net_mutex){+.+.+.}, at: [<ffffffff8335d610>]
cleanup_net+0x80/0x1b0
[  722.849300]  #3:  (rtnl_mutex){+.+.+.}, at: [<ffffffff83376fc2>]
rtnl_lock+0x12/0x20
[  722.850678]  #4:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a5e7>]
get_online_cpus+0x37/0x50
[  722.852191] INFO: task trinity-child41:8464 blocked for more than 120 seconds.
[  722.853303] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  722.854599] trinity-child41 D ffff88000d5d0000  4912  8464      1 0x00000006
[  722.855746]  ffff8800306cb9d8 0000000000000002 ffff8800306cb9a8 ffffffff810a2d96
[  722.857062]  ffff8800306cbfd8 ffff8800306cbfd8 ffff8800306cbfd8 ffff8800306cbfd8
[  722.858324]  ffff88000d5d0000 ffff88002e9eb000 ffff8800306cb9b8 ffff8800306cbb70
[  722.859576] Call Trace:
[  722.860060]  [<ffffffff810a2d96>] ? kvm_clock_read+0x46/0x80
[  722.861428]  [<ffffffff839eace5>] schedule+0x55/0x60
[  722.862256]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  722.863207]  [<ffffffff8117a1f3>] ? mark_held_locks+0x113/0x130
[  722.864197]  [<ffffffff8117793e>] ? put_lock_stats.isra.16+0xe/0x40
[  722.865246]  [<ffffffff839ec48b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  722.866282]  [<ffffffff839eb458>] wait_for_common+0x138/0x180
[  722.867240]  [<ffffffff8114ca70>] ? try_to_wake_up+0x360/0x360
[  722.868213]  [<ffffffff811c4650>] ? __call_rcu+0x6b0/0x6b0
[  722.869165]  [<ffffffff839eb548>] wait_for_completion+0x18/0x20
[  722.870177]  [<ffffffff81132d4f>] wait_rcu_gp+0x6f/0xa0
[  722.871058]  [<ffffffff811308f0>] ? perf_trace_rcu_utilization+0xe0/0xe0
[  722.872176]  [<ffffffff839eb364>] ? wait_for_common+0x44/0x180
[  722.873152]  [<ffffffff811c9026>] synchronize_rcu+0x86/0x90
[  722.874046]  [<ffffffff82c135bd>] input_close_device+0x5d/0x80
[  722.875036]  [<ffffffff82c1a9e7>] evdev_release+0x77/0xa0
[  722.875982]  [<ffffffff81271bc2>] __fput+0x122/0x2d0
[  722.876818]  [<ffffffff81271d79>] ____fput+0x9/0x10
[  722.877748]  [<ffffffff8112ebae>] task_work_run+0xbe/0x100
[  722.878695]  [<ffffffff8110da92>] do_exit+0x322/0xa90
[  722.879556]  [<ffffffff811778b2>] ? get_lock_stats+0x22/0x70
[  722.880554]  [<ffffffff8117793e>] ? put_lock_stats.isra.16+0xe/0x40
[  722.881622]  [<ffffffff839ec48b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  722.882665]  [<ffffffff8110e2c4>] do_group_exit+0x84/0xd0
[  722.883610]  [<ffffffff811215a1>] get_signal_to_deliver+0x801/0x920
[  722.884701]  [<ffffffff819e9d2b>] ? debug_object_assert_init+0xbb/0x110
[  722.885831]  [<ffffffff8118445d>] ? do_futex+0xbd/0xa80
[  722.886736]  [<ffffffff8106cc47>] do_signal+0x27/0x100
[  722.887803]  [<ffffffff811c6624>] ? rcu_eqs_exit_common+0x64/0x3a0
[  722.888867]  [<ffffffff811c6d15>] ? rcu_user_exit+0xa5/0xd0
[  722.889803]  [<ffffffff8117a44d>] ? trace_hardirqs_on+0xd/0x10
[  722.890817]  [<ffffffff8106cd8f>] do_notify_resume+0x4f/0xa0
[  722.891801]  [<ffffffff839edfba>] int_signal+0x12/0x17
[  722.892679] 2 locks held by trinity-child41/8464:
[  722.893494]  #0:  (&evdev->mutex){+.+...}, at: [<ffffffff82c1a9d0>]
evdev_release+0x60/0xa0
[  722.894954]  #1:  (&dev->mutex){+.+...}, at: [<ffffffff82c1358d>]
input_close_device+0x2d/0x80
[  842.890317] INFO: task init:1 blocked for more than 120 seconds.
[  842.894043] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  842.895451] init            D ffff880035600000  3528     1      0 0x00000000
[  842.896619]  ffff88000d5b3a48 0000000000000002 ffff88000d5b3a18 ffffffff810a2d96
[  842.897942]  ffff88000d5b3fd8 ffff88000d5b3fd8 ffff88000d5b3fd8 ffff88000d5b3fd8
[  842.899168]  ffff880035600000 ffff88000d5b8000 ffff88000d5b3a28 ffff88000d5b3be0
[  842.900468] Call Trace:
[  842.900911]  [<ffffffff810a2d96>] ? kvm_clock_read+0x46/0x80
[  842.901884]  [<ffffffff839eace5>] schedule+0x55/0x60
[  842.902752]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  842.903751]  [<ffffffff8117a1f3>] ? mark_held_locks+0x113/0x130
[  842.904777]  [<ffffffff8117793e>] ? put_lock_stats.isra.16+0xe/0x40
[  842.905852]  [<ffffffff839ec48b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  842.906923]  [<ffffffff839eb458>] wait_for_common+0x138/0x180
[  842.907930]  [<ffffffff8114ca70>] ? try_to_wake_up+0x360/0x360
[  842.908939]  [<ffffffff811c4650>] ? __call_rcu+0x6b0/0x6b0
[  842.909888]  [<ffffffff839eb548>] wait_for_completion+0x18/0x20
[  842.910849]  [<ffffffff81132d4f>] wait_rcu_gp+0x6f/0xa0
[  842.911764]  [<ffffffff811308f0>] ? perf_trace_rcu_utilization+0xe0/0xe0
[  842.912921]  [<ffffffff839eb364>] ? wait_for_common+0x44/0x180
[  842.913932]  [<ffffffff811c9026>] synchronize_rcu+0x86/0x90
[  842.914899]  [<ffffffff811fa3c5>] padata_replace+0x35/0xd0
[  842.915847]  [<ffffffff811fa526>] __padata_remove_cpu+0xc6/0x160
[  842.916875]  [<ffffffff811fa94c>] padata_cpu_callback+0x2bc/0x350
[  842.917940]  [<ffffffff8113de7e>] notifier_call_chain+0xee/0x130
[  842.918980]  [<ffffffff8113e459>] __raw_notifier_call_chain+0x9/0x10
[  842.920152]  [<ffffffff8110a4ab>] __cpu_notify+0x1b/0x40
[  842.921172]  [<ffffffff8383133e>] _cpu_down+0xae/0x350
[  842.922072]  [<ffffffff8398fc88>] ? printk+0x5c/0x5e
[  842.922942]  [<ffffffff8110a8e6>] disable_nonboot_cpus+0x86/0x1c0
[  842.923860]  [<ffffffff811240c6>] kernel_restart+0x16/0x60
[  842.924842]  [<ffffffff81124341>] sys_reboot+0x151/0x2a0
[  842.925759]  [<ffffffff811c5d13>] ? rcu_cleanup_after_idle+0x23/0x170
[  842.926874]  [<ffffffff811c6624>] ? rcu_eqs_exit_common+0x64/0x3a0
[  842.927948]  [<ffffffff811c6d15>] ? rcu_user_exit+0xa5/0xd0
[  842.928919]  [<ffffffff8117a44d>] ? trace_hardirqs_on+0xd/0x10
[  842.929939]  [<ffffffff8107c8f0>] ? syscall_trace_enter+0x20/0x2e0
[  842.930903]  [<ffffffff839edea8>] tracesys+0xe1/0xe6
[  842.931755] 4 locks held by init/1:
[  842.932364]  #0:  (reboot_mutex){+.+.+.}, at: [<ffffffff811242c6>]
sys_reboot+0xd6/0x2a0
[  842.933713]  #1:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff8110a582>]
cpu_maps_update_begin+0x12/0x20
[  842.935390]  #2:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a53a>]
cpu_hotplug_begin+0x2a/0x60
[  842.936920]  #3:  (&pinst->lock){+.+.+.}, at: [<ffffffff811fa941>]
padata_cpu_callback+0x2b1/0x350
[  842.938362] INFO: task rcu_preempt:11 blocked for more than 120 seconds.
[  842.939476] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  842.940786] rcu_preempt     D ffff88000d620000  5480    11      2 0x00000000
[  842.941894]  ffff88000d5fbc20 0000000000000002 0000000000000006 ffff88000d600000
[  842.943104]  ffff88000d5fbfd8 ffff88000d5fbfd8 ffff88000d5fbfd8 ffff88000d5fbfd8
[  842.944349]  ffff88000d620000 ffff88000d600000 ffffffff839e9575 ffffffff84c50948
[  842.945571] Call Trace:
[  842.945994]  [<ffffffff839e9575>] ? __mutex_lock_common+0x335/0x5a0
[  842.947042]  [<ffffffff839eace5>] schedule+0x55/0x60
[  842.947815]  [<ffffffff839ead03>] schedule_preempt_disabled+0x13/0x20
[  842.948895]  [<ffffffff839e95ad>] __mutex_lock_common+0x36d/0x5a0
[  842.949917]  [<ffffffff8110a5e7>] ? get_online_cpus+0x37/0x50
[  842.950826]  [<ffffffff81150008>] ? sched_clock_cpu+0xf8/0x110
[  842.951753]  [<ffffffff8110a5e7>] ? get_online_cpus+0x37/0x50
[  842.952688]  [<ffffffff839e981f>] mutex_lock_nested+0x3f/0x50
[  842.953619]  [<ffffffff8110a5e7>] get_online_cpus+0x37/0x50
[  842.954558]  [<ffffffff811c718f>] rcu_gp_kthread+0x28f/0xed0
[  842.955500]  [<ffffffff839ec48b>] ? _raw_spin_unlock_irq+0x2b/0x80
[  842.956532]  [<ffffffff81136fe0>] ? abort_exclusive_wait+0xb0/0xb0
[  842.957563]  [<ffffffff811c6f00>] ? rcu_gp_fqs+0x80/0x80
[  842.958456]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  842.959227]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  842.960247]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  842.961260]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  842.962659]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  842.963949] 1 lock held by rcu_preempt/11:
[  842.964615]  #0:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff8110a5e7>]
get_online_cpus+0x37/0x50
[  842.966102] INFO: task rcu_torture_wri:2723 blocked for more than 120 seconds.
[  842.967302] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  842.968599] rcu_torture_wri D ffff880035543000  5672  2723      2 0x00000000
[  842.969792]  ffff880034d49ce0 0000000000000002 ffff880034d49c90 ffffffff819e6eb8
[  842.971057]  ffff880034d49fd8 ffff880034d49fd8 ffff880034d49fd8 ffff880034d49fd8
[  842.972245]  ffff880035543000 ffff880034d58000 0000000000000043 ffffffff845c032a
[  842.973504] Call Trace:
[  842.973930]  [<ffffffff819e6eb8>] ? do_raw_spin_unlock+0xc8/0xe0
[  842.974924]  [<ffffffff839eace5>] schedule+0x55/0x60
[  842.975759]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  842.976727]  [<ffffffff8398fc88>] ? printk+0x5c/0x5e
[  842.977575]  [<ffffffff839e8fd9>] schedule_timeout_uninterruptible+0x19/0x20
[  842.978753]  [<ffffffff811bc49f>] rcutorture_shutdown_absorb+0x2f/0x40
[  842.979850]  [<ffffffff811bc7aa>] rcu_stutter_wait+0x4a/0x70
[  842.980829]  [<ffffffff811be20c>] rcu_torture_writer+0x1cc/0x240
[  842.981841]  [<ffffffff811be040>] ? cpumask_next+0x80/0x80
[  842.982764]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  842.983585]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  842.984592]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  842.985610]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  842.986633]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  842.987511] no locks held by rcu_torture_wri/2723.
[  842.988316] INFO: task rcu_torture_fak:2724 blocked for more than 120 seconds.
[  842.989515] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  842.990934] rcu_torture_fak D ffff88000d620000  5416  2724      2 0x00000000
[  842.992218]  ffff880034d35ce0 0000000000000002 0000000000000001 0000000010000000
[  842.993508]  ffff880034d35fd8 ffff880034d35fd8 ffff880034d35fd8 ffff880034d35fd8
[  842.994677]  ffff88000d620000 ffff880034cf3000 0000000000000000 ffffffff845c023f
[  842.995848] Call Trace:
[  842.996275]  [<ffffffff811bd2b0>] ? rcu_torture_barrier_cbs+0x210/0x210
[  842.997348]  [<ffffffff839eace5>] schedule+0x55/0x60
[  842.998179]  [<ffffffff839e8c65>] schedule_timeout+0x45/0x360
[  842.999143]  [<ffffffff811c4650>] ? __call_rcu+0x6b0/0x6b0
[  843.000091]  [<ffffffff811bd2b0>] ? rcu_torture_barrier_cbs+0x210/0x210
[  843.001201]  [<ffffffff8398fc88>] ? printk+0x5c/0x5e
[  843.002031]  [<ffffffff811bd2b0>] ? rcu_torture_barrier_cbs+0x210/0x210
[  843.003131]  [<ffffffff839e8fd9>] schedule_timeout_uninterruptible+0x19/0x20
[  843.004316]  [<ffffffff811bc49f>] rcutorture_shutdown_absorb+0x2f/0x40
[  843.005405]  [<ffffffff811bc7aa>] rcu_stutter_wait+0x4a/0x70
[  843.006325]  [<ffffffff811bd39f>] rcu_torture_fakewriter+0xef/0x160
[  843.007370]  [<ffffffff81135c13>] kthread+0xe3/0xf0
[  843.008188]  [<ffffffff839ef044>] kernel_thread_helper+0x4/0x10
[  843.009138]  [<ffffffff839ed3b4>] ? retint_restore_args+0x13/0x13
[  843.010146]  [<ffffffff81135b30>] ? insert_kthread_work+0x90/0x90
[  843.011159]  [<ffffffff839ef040>] ? gs_change+0x13/0x13
[  843.011999] no locks held by rcu_torture_fak/2724.
[  862.110052] INFO: rcu_preempt detected stalls on CPUs/tasks:
[  862.111263] 	(detected by 0, t=26007 jiffies)
[  862.112099] INFO: Stall ended before state dump start
