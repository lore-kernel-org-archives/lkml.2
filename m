Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751355Ab2IEEf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:35:57 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41616 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab2IEEfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:35:55 -0400
Message-ID: <5046D69F.9000705@linux.vnet.ibm.com>
Date: Wed, 05 Sep 2012 12:35:43 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: WARNING: cpu_is_offline() at native_smp_send_reschedule()
References: <20120905011152.GA19853@localhost>
In-Reply-To: <20120905011152.GA19853@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090504-9574-0000-0000-0000044522C5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Feng Guang

On 09/05/2012 09:11 AM, Fengguang Wu wrote:
> Hi,
> 
> Here is an old problem that happens also in 3.4. It's very unreliable:
> it may only happen once per 3000 boots..
> 
> [   10.968565] reboot: machine restart
> [   10.983510] ------------[ cut here ]------------
> [   10.984218] WARNING: at /c/kernel-tests/src/stable/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
> [   10.985880] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-00005-gb374aa1 #10
> [   10.987185] Call Trace:
> [   10.987506]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
> [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> [   10.987506]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
> [   10.987506]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50

So this cpu try to fire a nohz balance kick ipi to an offline cpu?

May be we are choosing a wrong cpu to kick but that's not the point,
what I can't understand is why this cpu could do this kick.

We have nohz_kick_needed() to check whether current cpu should do kick ,
and the first condition we need to match is that current cpu should be
idle, but the trace show current pid is 88 not 0.

We should add Peter to cc list, may be he will be interested on what
happened.

Regards,
Michael Wang

> [   10.987506]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
> [   10.987506]  [<79056d14>] scheduler_tick+0xd4/0x100
> [   10.987506]  [<7903bde5>] update_process_times+0x55/0x70
> [   10.987506]  [<79071187>] tick_sched_timer+0x57/0xb0
> [   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [   10.987506]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
> [   10.987506]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
> [   10.987506]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
> [   10.987506]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
> [   10.987506]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
> [   10.987506]  [<79882631>] apic_timer_interrupt+0x31/0x40
> [   10.987506]  [<7905007b>] ? call_srcu+0x2b/0x70
> [   10.987506]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
> [   10.987506]  [<7988194f>] ? _raw_spin_unlock_irq+0x1f/0x40
> [   10.987506]  [<7905307f>] finish_task_switch+0x7f/0xd0
> [   10.987506]  [<79053038>] ? finish_task_switch+0x38/0xd0
> [   10.987506]  [<7988044a>] __schedule+0x38a/0x770
> [   10.987506]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
> [   10.987506]  [<7987ea40>] ? schedule_timeout+0x100/0x1b0
> [   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [   10.987506]  [<7988084e>] schedule+0x1e/0x50
> [   10.987506]  [<7987ea45>] schedule_timeout+0x105/0x1b0
> [   10.987506]  [<7903adb0>] ? __internal_add_timer+0xb0/0xb0
> [   10.987506]  [<796842f2>] pktgen_thread_worker+0x1342/0x1390
> [   10.987506]  [<7988044a>] ? __schedule+0x38a/0x770
> [   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [   10.987506]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [   10.987506]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
> [   10.987506]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
> [   10.987506]  [<79682fb0>] ? pktgen_if_write+0x2210/0x2210
> [   10.987506]  [<79049ff8>] kthread+0x78/0x80
> [   10.987506]  [<79880000>] ? __up.isra.0+0xd/0x2d
> [   10.987506]  [<79049f80>] ? insert_kthread_work+0x70/0x70
> [   10.987506]  [<798830c6>] kernel_thread_helper+0x6/0xd
> 
> Here are all the oops messages I collected in the past days:
> 
> [    4.815145] Restarting system.
> [    4.815644] reboot: machine restart
> [    4.824591] ------------[ cut here ]------------
> [    4.825423] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
> [    4.826881] Pid: 18, comm: kworker/0:1 Not tainted 3.6.0-rc3-bisect-00007-g6320675 #25
> [    4.828116] Call Trace:
> [    4.828533]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
> [    4.828585]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> [    4.828585]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> [    4.828585]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
> [    4.828585]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
> [    4.828585]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
> [    4.828585]  [<79056d14>] scheduler_tick+0xd4/0x100
> [    4.828585]  [<7903bde5>] update_process_times+0x55/0x70
> [    4.828585]  [<79071187>] tick_sched_timer+0x57/0xb0
> [    4.828585]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [    4.828585]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
> [    4.828585]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
> [    4.828585]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
> [    4.828585]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
> [    4.828585]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
> [    4.828585]  [<79882401>] apic_timer_interrupt+0x31/0x40
> [    4.828585]  [<7905007b>] ? call_srcu+0x2b/0x70
> [    4.828585]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
> [    4.828585]  [<7988171f>] ? _raw_spin_unlock_irq+0x1f/0x40
> [    4.828585]  [<7905307f>] finish_task_switch+0x7f/0xd0
> [    4.828585]  [<79053038>] ? finish_task_switch+0x38/0xd0
> [    4.828585]  [<7988021a>] __schedule+0x38a/0x770
> [    4.828585]  [<79045529>] ? worker_thread+0x1a9/0x380
> [    4.828585]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [    4.828585]  [<7988061e>] schedule+0x1e/0x50
> [    4.828585]  [<7904552e>] worker_thread+0x1ae/0x380
> [    4.828585]  [<79056ed9>] ? complete+0x49/0x60
> [    4.828585]  [<79045380>] ? manage_workers.isra.23+0x250/0x250
> [    4.828585]  [<79049ff8>] kthread+0x78/0x80
> [    4.828585]  [<79880000>] ? __schedule+0x170/0x770
> [    4.828585]  [<79049f80>] ? insert_kthread_work+0x70/0x70
> [    4.828585]  [<79882e86>] kernel_thread_helper+0x6/0xd
> [    4.828585] ---[ end trace ae11d0bb45464df2 ]---
> --
> [    9.195595] Restarting system.
> [    9.196142] reboot: machine restart
> [    9.228474] ------------[ cut here ]------------
> [    9.229329] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
> [    9.230890] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-bisect #28
> [    9.232034] Call Trace:
> [    9.232468]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
> [    9.232468]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> [    9.232468]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> [    9.232468]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
> [    9.232468]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
> [    9.232468]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
> [    9.232468]  [<79056d14>] scheduler_tick+0xd4/0x100
> [    9.232468]  [<7903bde5>] update_process_times+0x55/0x70
> [    9.232468]  [<79071187>] tick_sched_timer+0x57/0xb0
> [    9.232468]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [    9.232468]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
> [    9.232468]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
> [    9.232468]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
> [    9.232468]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
> [    9.232468]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
> [    9.232468]  [<79882401>] apic_timer_interrupt+0x31/0x40
> [    9.232468]  [<7905007b>] ? call_srcu+0x2b/0x70
> [    9.232468]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
> [    9.232468]  [<7988171f>] ? _raw_spin_unlock_irq+0x1f/0x40
> [    9.232468]  [<7905307f>] finish_task_switch+0x7f/0xd0
> [    9.232468]  [<79053038>] ? finish_task_switch+0x38/0xd0
> [    9.232468]  [<7988021a>] __schedule+0x38a/0x770
> [    9.232468]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
> [    9.232468]  [<7987e810>] ? schedule_timeout+0x100/0x1b0
> [    9.232468]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [    9.232468]  [<7988061e>] schedule+0x1e/0x50
> [    9.232468]  [<7987e815>] schedule_timeout+0x105/0x1b0
> [    9.232468]  [<7903adb0>] ? __internal_add_timer+0xb0/0xb0
> [    9.232468]  [<796840c2>] pktgen_thread_worker+0x1342/0x1390
> [    9.232468]  [<7988021a>] ? __schedule+0x38a/0x770
> [    9.232468]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
> [    9.232468]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
> [    9.232468]  [<7904aa40>] ? abort_exclusive_wait+0x80/0x80
> [    9.232468]  [<79682d80>] ? pktgen_if_write+0x2210/0x2210
> [    9.232468]  [<79049ff8>] kthread+0x78/0x80
> [    9.232468]  [<79880000>] ? __schedule+0x170/0x770
> [    9.232468]  [<79049f80>] ? insert_kthread_work+0x70/0x70
> [    9.232468]  [<79882e86>] kernel_thread_helper+0x6/0xd
> [    9.232468] ---[ end trace 4b6a1d80f6ec28ef ]---
> --
> [    4.665800] Restarting system.
> [    4.666537] machine restart
> [    4.682180] ------------[ cut here ]------------
> [    4.683044] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x46/0x50()
> [    4.684515] Pid: 115, comm: reboot Not tainted 3.4.0-bisect #30
> [    4.685459] Call Trace:
> [    4.685919]  [<7984acc5>] ? printk+0x18/0x1a
> [    4.686173]  [<7902ab6a>] warn_slowpath_common+0x5a/0x80
> [    4.686173]  [<7901ac46>] ? native_smp_send_reschedule+0x46/0x50
> [    4.686173]  [<7901ac46>] ? native_smp_send_reschedule+0x46/0x50
> [    4.686173]  [<7902ac3d>] warn_slowpath_null+0x1d/0x20
> [    4.686173]  [<7901ac46>] native_smp_send_reschedule+0x46/0x50
> [    4.686173]  [<79058885>] trigger_load_balance+0x295/0x340
> [    4.686173]  [<7904f43f>] scheduler_tick+0xcf/0x100
> [    4.686173]  [<79035985>] update_process_times+0x55/0x70
> [    4.686173]  [<7906979b>] tick_sched_timer+0x5b/0xc0
> [    4.686173]  [<7939794e>] ? do_raw_spin_unlock+0x4e/0x90
> [    4.686173]  [<79047167>] __run_hrtimer.isra.29+0x57/0x100
> [    4.686173]  [<79069740>] ? tick_nohz_handler+0xe0/0xe0
> [    4.686173]  [<79047dd5>] hrtimer_interrupt+0xd5/0x240
> [    4.686173]  [<7901b844>] smp_apic_timer_interrupt+0x54/0x90
> [    4.686173]  [<79858e31>] apic_timer_interrupt+0x31/0x40
> [    4.686173]  [<793877be>] ? delay_tsc+0x3e/0xa0
> [    4.686173]  [<7938785b>] __const_udelay+0x1b/0x20
> [    4.686173]  [<7901adff>] native_nmi_stop_other_cpus+0xaf/0xe0
> [    4.686173]  [<7901a237>] native_machine_shutdown+0x57/0x80
> [    4.686173]  [<79021c79>] kvm_shutdown+0x19/0x20
> [    4.686173]  [<7901a1c2>] native_machine_restart+0x22/0x40
> [    4.686173]  [<7901a3f9>] machine_restart+0x9/0x10
> [    4.686173]  [<7903a643>] kernel_restart+0x33/0x50
> [    4.686173]  [<7903a86d>] sys_reboot+0x13d/0x1e0
> [    4.686173]  [<79052cd7>] ? sched_clock_cpu+0xc7/0x150
> [    4.686173]  [<7902409f>] ? do_page_fault+0x19f/0x3e0
> [    4.686173]  [<79021b60>] ? kvm_read_and_reset_pf_reason+0x40/0x40
> [    4.686173]  [<79048466>] ? up_read+0x16/0x30
> [    4.686173]  [<7902409f>] ? do_page_fault+0x19f/0x3e0
> [    4.686173]  [<790c805b>] ? iterate_supers+0xab/0xd0
> [    4.686173]  [<7939794e>] ? do_raw_spin_unlock+0x4e/0x90
> [    4.686173]  [<79857eed>] ? _raw_spin_unlock+0x1d/0x30
> [    4.686173]  [<790c805b>] ? iterate_supers+0xab/0xd0
> [    4.686173]  [<790e9bd0>] ? __sync_filesystem+0xa0/0xa0
> [    4.686173]  [<79859327>] sysenter_do_call+0x12/0x37
> [    4.686173] ---[ end trace 9d854ed5f523a273 ]---
> --
> [    5.815913] Restarting system.
> [    5.816485] machine restart
> [    5.824887] ------------[ cut here ]------------
> [    5.825679] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
> [    5.827263] Pid: 16, comm: kworker/0:1 Not tainted 3.5.0-bisect #29
> [    5.828336] Call Trace:
> [    5.828793]  [<7902bb2a>] warn_slowpath_common+0x5a/0x80
> [    5.828882]  [<7901ba16>] ? native_smp_send_reschedule+0x46/0x50
> [    5.828882]  [<7901ba16>] ? native_smp_send_reschedule+0x46/0x50
> [    5.828882]  [<7902bbfd>] warn_slowpath_null+0x1d/0x20
> [    5.828882]  [<7901ba16>] native_smp_send_reschedule+0x46/0x50
> [    5.828882]  [<7905bc0d>] trigger_load_balance+0x1bd/0x250
> [    5.828882]  [<790529e4>] scheduler_tick+0xd4/0x100
> [    5.828882]  [<79038245>] update_process_times+0x55/0x70
> [    5.828882]  [<7906cc4b>] tick_sched_timer+0x5b/0xc0
> [    5.828882]  [<7939fcce>] ? do_raw_spin_unlock+0x4e/0x90
> [    5.828882]  [<79049f37>] __run_hrtimer.isra.29+0x57/0x100
> [    5.828882]  [<7906cbf0>] ? tick_nohz_handler+0xe0/0xe0
> [    5.828882]  [<7904abc5>] hrtimer_interrupt+0xe5/0x280
> [    5.828882]  [<7901c5a4>] smp_apic_timer_interrupt+0x54/0x90
> [    5.828882]  [<79870351>] apic_timer_interrupt+0x31/0x40
> [    5.828882]  [<7904007b>] ? start_worker+0x2b/0x30
> [    5.828882]  [<793900e0>] ? insn_get_prefixes+0x150/0x240
> [    5.828882]  [<7986f46f>] ? _raw_spin_unlock_irq+0x1f/0x40
> [    5.828882]  [<7904edcf>] finish_task_switch+0x7f/0xd0
> [    5.828882]  [<7904ed88>] ? finish_task_switch+0x38/0xd0
> [    5.828882]  [<7986df6a>] __schedule+0x38a/0x770
> [    5.828882]  [<790415fc>] ? worker_thread+0x16c/0x270
> [    5.828882]  [<7939fcce>] ? do_raw_spin_unlock+0x4e/0x90
> [    5.828882]  [<7986e36e>] schedule+0x1e/0x50
> [    5.828882]  [<79041601>] worker_thread+0x171/0x270
> [    5.828882]  [<79052ba9>] ? complete+0x49/0x60
> [    5.828882]  [<79041490>] ? manage_workers.isra.26+0x1c0/0x1c0
> [    5.828882]  [<79045f18>] kthread+0x78/0x80
> [    5.828882]  [<79860000>] ? ip_vs_control_net_cleanup+0xc0/0xd0
> [    5.828882]  [<79045ea0>] ? kthread_flush_work_fn+0x10/0x10
> [    5.828882]  [<79870dc6>] kernel_thread_helper+0x6/0xd
> [    5.828882] ---[ end trace df77608ce627a14d ]---
> 
> Thanks,
> Fengguang
> 

