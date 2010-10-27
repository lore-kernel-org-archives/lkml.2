Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0J0T76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 15:59:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0J0T7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 15:59:54 -0400
Date: Wed, 27 Oct 2010 17:58:16 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: markus@trippelsdorf.de, john stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        Ingo Molnar <mingo@elte.hu>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        heiko.carstens@de.ibm.com, avi@redhat.com
Subject: Re: [bisected] Clocksource tsc unstable git
Message-ID: <20101027195816.GA11248@amt.cnet>
References: <20101026112052.GA1672@arch.trippelsdorf.de>
 <20101026131843.GC17852@aftab>
 <20101026135808.GB1672@arch.trippelsdorf.de>
 <alpine.LFD.2.00.1010261747250.3115@localhost6.localdomain6>
 <1288120736.2645.9.camel@localhost>
 <20101027142622.GA1555@arch.trippelsdorf.de>
 <20101027182608.GA1580@arch.trippelsdorf.de>
 <1288208215.3673.16.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <1288208215.3673.16.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 27, 2010 at 09:36:55PM +0200, Peter Zijlstra wrote:
> On Wed, 2010-10-27 at 20:26 +0200, markus@trippelsdorf.de wrote:
> > 
> > 34f971f6f7988be4d014eec3e3526bee6d007ffa is the first bad commit
> > commit 34f971f6f7988be4d014eec3e3526bee6d007ffa
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Wed Sep 22 13:53:15 2010 +0200
> > 
> >     sched: Create special class for stop/migrate work
> > 
> >     In order to separate the stop/migrate work thread from the SCHED_FIFO
> >     implementation, create a special class for it that is of higher priority than
> >     SCHED_FIFO itself.
> > 
> >     This currently solves a problem where cpu-hotplug consumes so much cpu-time
> >     that the SCHED_FIFO class gets throttled, but has the bandwidth replenishment
> >     timer pending on the now dead cpu.
> > 
> >     It is also required for when we add the planned deadline scheduling class above
> >     SCHED_FIFO, as the stop/migrate thread still needs to transcent those tasks.
> > 
> >     Tested-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     LKML-Reference: <1285165776.2275.1022.camel@laptop>
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > 
> > Reverting the commit solves the kvm hang issue.
> > (If this issue is related to my original tsc problem is of course open for
> > debate, but I have a strong hunch it is.) 
> 
> Too weird,.. what does the hang look like?
> 
> Can you generate a sysrq-t dump? The thing I'm looking for is the
> migration/# thread being runnable but not being current.
> 
> How can I reproduce this?

I can reproduce it reliably here (requires kvm-autotest setup, its
difficult to reproduce manually).

INFO: task qemu:1872 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
qemu          D ffff88007f44f1c0     0  1872      1 0x00000084
ffff88006522dbb8 0000000000000086 ffff8800ffffffff ffff88006522dfd8
0000000000013580 ffff880078dd0000 ffff880078dd0380 ffff880078dd0378
ffff88006522c000 ffff88006522dfd8 0000000000013580 0000000000013580
Call Trace:
[<ffffffff8143c919>] ? _raw_spin_unlock_irq+0x12/0x3c
[<ffffffff8143b111>] schedule_timeout+0x27/0xc0
[<ffffffff8143fc50>] ? sub_preempt_count+0xe/0xab
[<ffffffff810414e0>] ? get_parent_ip+0x11/0x41
[<ffffffff810414e0>] ? get_parent_ip+0x11/0x41
[<ffffffff8143fcd9>] ? sub_preempt_count+0x97/0xab
[<ffffffff8143a6e8>] wait_for_common+0xa3/0x110
[<ffffffff81046f02>] ? default_wake_function+0x0/0x14
[<ffffffff81039e92>] ? synchronize_sched_expedited_cpu_stop+0x0/0x10
[<ffffffff8143a80d>] wait_for_completion+0x1d/0x1f
[<ffffffff81091d90>] __stop_cpus+0xf5/0x112
[<ffffffff81091ded>] try_stop_cpus+0x40/0x59
[<ffffffff81039e92>] ? synchronize_sched_expedited_cpu_stop+0x0/0x10
[<ffffffff81040f50>] synchronize_sched_expedited+0x7e/0x98
[<ffffffff81040ed2>] ? synchronize_sched_expedited+0x0/0x98
[<ffffffff8106b707>] __synchronize_srcu+0x31/0x70
[<ffffffff8106b75b>] synchronize_srcu_expedited+0x15/0x17
[<ffffffffa0206b5c>] kvm_vm_ioctl_get_dirty_log+0x104/0x19b [kvm]
[<ffffffff8120c3e4>] ? rb_insert_color+0x68/0xe5
[<ffffffffa01f6e0b>] kvm_vm_ioctl+0x239/0x353 [kvm]
[<ffffffff8143c8fc>] ? _raw_spin_unlock_irqrestore+0x37/0x42
[<ffffffff8106affc>] ? __hrtimer_start_range_ns+0x329/0x33b
[<ffffffff8143c6ae>] ? _raw_spin_lock_irqsave+0x2a/0x46
[<ffffffff81117563>] do_vfs_ioctl+0x46a/0x4b9
[<ffffffff8143c8fc>] ? _raw_spin_unlock_irqrestore+0x37/0x42
[<ffffffff81117608>] sys_ioctl+0x56/0x79
[<ffffffff8143d48a>] ? do_device_not_available+0xe/0x10
[<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b


 cpu#0, 2660.055 MHz

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime
sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------
 R    kworker/0:0     4   3424836.020475 183681301   120 3424836.020475   3423901.420588   2685682.072677
     migration/0     6       124.991395    297339     0       124.991395 0.001706         0.000000

Full log attached. 



--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="nehalem-dmesg.txt"

 [<ffffffff810e1928>] ? handle_mm_fault+0x8f4/0x921
 [<ffffffff8128a1c7>] tty_ioctl+0x914/0x97c
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 console-kit-d S ffff880077111700     0  1105      1 0x00000080
 ffff880078295c88 0000000000000082 0000000000000000 000280da003fffff
 ffff880078295fd8 ffff880077111700 ffff880078295fd8 ffff880077111a80
 ffff880077111a78 ffff880078294000 ffff880078294000 0000000000013580
 Call Trace:
 [<ffffffff8106706b>] ? prepare_to_wait+0x76/0x81
 [<ffffffff81291f99>] vt_event_wait+0xc7/0x12d
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81439581>] ? schedule+0x6aa/0x6c4
 [<ffffffff81292030>] vt_waitactive+0x31/0x4e
 [<ffffffff81293523>] vt_ioctl+0x11b0/0x18c3
 [<ffffffff810ce80a>] ? lru_cache_add_lru+0x41/0x43
 [<ffffffff810e9492>] ? page_add_new_anon_rmap+0x60/0x72
 [<ffffffff810de880>] ? spin_unlock+0xe/0x10
 [<ffffffff810e1928>] ? handle_mm_fault+0x8f4/0x921
 [<ffffffff8128a1c7>] tty_ioctl+0x914/0x97c
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff8120f6a7>] ? call_rwsem_wake+0x17/0x30
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 console-kit-d S ffff880077112e00     0  1106      1 0x00000080
 ffff880078297c88 0000000000000082 0000000000002937 000280da77112e38
 ffff880078297fd8 ffff880077112e00 ffff880078297fd8 ffff880077113180
 ffff880077113178 ffff880078296000 ffff880078296000 0000000000013580
 Call Trace:
 [<ffffffff8106706b>] ? prepare_to_wait+0x76/0x81
 [<ffffffff81291f99>] vt_event_wait+0xc7/0x12d
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81439581>] ? schedule+0x6aa/0x6c4
 [<ffffffff81292030>] vt_waitactive+0x31/0x4e
 [<ffffffff81293523>] vt_ioctl+0x11b0/0x18c3
 [<ffffffff810ce80a>] ? lru_cache_add_lru+0x41/0x43
 [<ffffffff810e9492>] ? page_add_new_anon_rmap+0x60/0x72
 [<ffffffff810de880>] ? spin_unlock+0xe/0x10
 [<ffffffff810e1928>] ? handle_mm_fault+0x8f4/0x921
 [<ffffffff8128a1c7>] tty_ioctl+0x914/0x97c
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 console-kit-d S ffff880077114500     0  1107      1 0x00000080
 ffff880077895c88 0000000000000082 0000000000000000 000280da003fffff
 ffff880077895fd8 ffff880077114500 ffff880077895fd8 ffff880077114880
 ffff880077114878 ffff880077894000 ffff880077894000 0000000000013580
 Call Trace:
 [<ffffffff8106706b>] ? prepare_to_wait+0x76/0x81
 [<ffffffff81291f99>] vt_event_wait+0xc7/0x12d
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81439581>] ? schedule+0x6aa/0x6c4
 [<ffffffff81292030>] vt_waitactive+0x31/0x4e
 [<ffffffff81293523>] vt_ioctl+0x11b0/0x18c3
 [<ffffffff810ce80a>] ? lru_cache_add_lru+0x41/0x43
 [<ffffffff810e9492>] ? page_add_new_anon_rmap+0x60/0x72
 [<ffffffff810de880>] ? spin_unlock+0xe/0x10
 [<ffffffff810e1928>] ? handle_mm_fault+0x8f4/0x921
 [<ffffffff8128a1c7>] tty_ioctl+0x914/0x97c
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 console-kit-d S ffff880077115c00     0  1108      1 0x00000080
 ffff880077897c88 0000000000000082 0000000000000000 000280da003fffff
 ffff880077897fd8 ffff880077115c00 ffff880077897fd8 ffff880077115f80
 ffff880077115f78 ffff880077896000 ffff880077896000 0000000000013580
 Call Trace:
 [<ffffffff8106706b>] ? prepare_to_wait+0x76/0x81
 [<ffffffff81291f99>] vt_event_wait+0xc7/0x12d
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81292030>] vt_waitactive+0x31/0x4e
 [<ffffffff81293523>] vt_ioctl+0x11b0/0x18c3
 [<ffffffff810ce80a>] ? lru_cache_add_lru+0x41/0x43
 [<ffffffff810e9492>] ? page_add_new_anon_rmap+0x60/0x72
 [<ffffffff810de880>] ? spin_unlock+0xe/0x10
 [<ffffffff810e1928>] ? handle_mm_fault+0x8f4/0x921
 [<ffffffff8128a1c7>] tty_ioctl+0x914/0x97c
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 console-kit-d S ffff880078291ce8     0  1110      1 0x00000080
 ffff880078291cd8 0000000000000082 ffff880078291c78 ffffffff81036a1f
 ffff880078291fd8 ffff880077954500 ffff880078291fd8 ffff880077954880
 ffff880077954878 ffff880078290000 ffff880078290000 0000000000013580
 Call Trace:
 [<ffffffff81036a1f>] ? native_flush_tlb_others+0xd6/0xe5
 [<ffffffff8106706b>] ? prepare_to_wait+0x76/0x81
 [<ffffffff81110649>] pipe_wait+0x63/0x7f
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81110dee>] pipe_read+0x336/0x3b7
 [<ffffffff810e1905>] ? handle_mm_fault+0x8d1/0x921
 [<ffffffff81108aa4>] do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff81109c96>] ? fget_light+0xa5/0xb0
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 hald-runner   S 0000000000000000     0  1046   1042 0x00000080
 ffff880078e33a58 0000000000000082 ffff88007f413580 ffff880000000000
 ffff880078e33fd8 ffff880078ad0000 ffff880078e33fd8 ffff880078ad0380
 ffff880078ad0378 ffff880078e32000 ffff880078e32000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81380b38>] ? sock_aio_write+0x0/0xd4
 [<ffffffff81380bf8>] ? sock_aio_write+0xc0/0xd4
 [<ffffffff81108892>] ? do_sync_readv_writev+0xc1/0x100
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81108776>] ? fsnotify_modify+0x66/0x6e
 [<ffffffff81109646>] ? do_readv_writev+0x110/0x129
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 hald-addon-in S 0000000000000000     0  1138   1046 0x00000080
 ffff88007810fa58 0000000000000082 00ff880000000000 ffff880000000000
 ffff88007810ffd8 ffff880078354500 ffff88007810ffd8 ffff880078354880
 ffff880078354878 ffff88007810e000 ffff88007810e000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff81387619>] ? __alloc_skb+0x83/0x141
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81108892>] ? do_sync_readv_writev+0xc1/0x100
 [<ffffffff811078d1>] ? nameidata_to_filp+0x3f/0x50
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81109646>] ? do_readv_writev+0x110/0x129
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 hald-addon-st S 0000000000000000     0  1155   1046 0x00000080
 ffff8800788b1a58 0000000000000086 ffff8800788b19b8 ffffffff8143ae48
 ffff8800788b1fd8 ffff880077951700 ffff8800788b1fd8 ffff880077951a80
 ffff880077951a78 ffff8800788b0000 ffff8800788b0000 0000000000013580
 Call Trace:
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff812cd878>] ? scsi_execute+0x137/0x148
 [<ffffffff810fbc63>] ? virt_to_head_page+0xe/0x31
 [<ffffffff812cd92e>] ? scsi_execute_req+0xa5/0xb7
 [<ffffffff812c7bc1>] ? ioctl_internal_command.clone.0+0x6b/0x163
 [<ffffffff812da25d>] ? sr_drive_status+0x5f/0xa8
 [<ffffffff812c7d05>] ? scsi_set_medium_removal+0x4c/0x71
 [<ffffffff81207bba>] ? kobject_put+0x47/0x4b
 [<ffffffff812b40a8>] ? put_device+0x17/0x19
 [<ffffffff812c5ddc>] ? scsi_device_put+0x42/0x47
 [<ffffffff8111c33f>] ? iput+0x35/0x249
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff810a1952>] ? rcu_start_gp+0x20f/0x218
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 hald-addon-ac S 0000000000000000     0  1156   1046 0x00000080
 ffff880077a3fb08 0000000000000086 ffff880077a3fa78 ffffea0000000000
 ffff880077a3ffd8 ffff880077955c00 ffff880077a3ffd8 ffff880077955f80
 ffff880077955f78 ffff880077a3e000 ffff880077a3e000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8106706b>] ? prepare_to_wait+0x76/0x81
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff8140fbc1>] unix_stream_recvmsg+0x2f1/0x56b
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] __sock_recvmsg+0x4e/0x59
 [<ffffffff81380cd3>] sock_aio_read+0xc7/0xdb
 [<ffffffff81108aa4>] do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff811090f4>] vfs_read+0xbe/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 NetworkManage S ffff88007f44f1c0     0  1170      1 0x00000080
 ffff88007813ba58 0000000000000082 ffff88007813b9b8 ffffffffffffffff
 ffff88007813bfd8 ffff880078352e00 ffff88007813bfd8 ffff880078353180
 ffff880078353178 ffff88007813a000 ffff88007813a000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8137ec1c>] ? __sys_recvmsg+0x184/0x223
 [<ffffffff8137efed>] ? fput_light+0x12/0x14
 [<ffffffff8137f53c>] ? sys_sendto+0xef/0x105
 [<ffffffff81109c96>] ? fget_light+0xa5/0xb0
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 NetworkManage S 0000000000000000     0  1282      1 0x00000080
 ffff8800778c7cd8 0000000000000082 ffff8800778c7c78 ffff880000000000
 ffff8800778c7fd8 ffff880077b1ae00 ffff8800778c7fd8 ffff880077b1b180
 ffff880077b1b178 ffff8800778c6000 ffff8800778c6000 0000000000013580
 Call Trace:
 [<ffffffff81110649>] pipe_wait+0x63/0x7f
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81110dee>] pipe_read+0x336/0x3b7
 [<ffffffff81108aa4>] do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff81109c96>] ? fget_light+0xa5/0xb0
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 modem-manager S 0000000000000000     0  1177      1 0x00000080
 ffff8800795afa58 0000000000000082 ffff88007f77c700 ffff880000000000
 ffff8800795affd8 ffff880078a22e00 ffff8800795affd8 ffff880078a23180
 ffff880078a23178 ffff8800795ae000 ffff8800795ae000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8110cc00>] ? vfs_fstatat+0x37/0x62
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sshd          S 0000000000000000     0  1187      1 0x00000080
 ffff880078047928 0000000000000086 ffff88007c5e8f08 0000000000000000
 ffff880078047fd8 ffff880078351700 ffff880078047fd8 ffff880078351a80
 ffff880078351a78 ffff880078046000 ffff880078046000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810ca021>] ? zone_watermark_ok+0x29/0xba
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81205cfd>] ? cpumask_any_but+0x29/0x36
 [<ffffffff81036b24>] ? flush_tlb_page+0x73/0xb2
 [<ffffffff81035a49>] ? ptep_set_access_flags+0x44/0x52
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff810de880>] ? spin_unlock+0xe/0x10
 [<ffffffff810dfc45>] ? do_wp_page+0x63b/0x6e4
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff810fbc63>] ? virt_to_head_page+0xe/0x31
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81118900>] ? d_free+0x37/0x4d
 [<ffffffff81118a68>] ? d_kill+0x60/0x68
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 wpa_supplican S 0000000000000000     0  1221      1 0x00000080
 ffff880078af3928 0000000000000086 ffff880078af3888 ffffffff00000000
 ffff880078af3fd8 ffff880078a25c00 ffff880078af3fd8 ffff880078a25f80
 ffff880078a25f78 ffff880078af2000 ffff880078af2000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8140e482>] ? scm_recv+0x3f/0xca
 [<ffffffff81385b0d>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8140fe1b>] ? unix_stream_recvmsg+0x54b/0x56b
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff8110116c>] ? unlock_page_cgroup+0x2a/0x35
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff810c5885>] ? unlock_page+0x17/0x19
 [<ffffffff810df32a>] ? __do_fault+0x414/0x44a
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 abrtd         S 0000000000000000     0  1222      1 0x00000080
 ffff880078ac9a58 0000000000000086 ffff880078ac99b8 ffffffff00000000
 ffff880078ac9fd8 ffff8800781fae00 ffff880078ac9fd8 ffff8800781fb180
 ffff8800781fb178 ffff880078ac8000 ffff880078ac8000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111b8d2>] ? touch_atime+0x87/0x12a
 [<ffffffff810c5202>] ? file_accessed+0x1c/0x1e
 [<ffffffff810c6fcc>] ? generic_file_aio_read+0x535/0x58d
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff810a1952>] ? rcu_start_gp+0x20f/0x218
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gpm           S 0000000000000000     0  1241      1 0x00000080
 ffff880077267928 0000000000000082 ffff880077267888 ffffffff00000000
 ffff880077267fd8 ffff8800781f9700 ffff880077267fd8 ffff8800781f9a80
 ffff8800781f9a78 ffff880077266000 ffff880077266000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8110174d>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff81103e3b>] ? __mem_cgroup_try_charge+0x13d/0x456
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff810c5ecd>] ? filemap_fault+0xb4/0x31c
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff810c5885>] ? unlock_page+0x17/0x19
 [<ffffffff810df32a>] ? __do_fault+0x414/0x44a
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8143b30f>] ? tty_unlock+0x43/0x45
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 ksmtuned      S 0000000000000000     0  1251      1 0x00000080
 ffff880077ba3e58 0000000000000086 ffffffff8104538d ffff880000000000
 ffff880077ba3fd8 ffff880078cd8000 ffff880077ba3fd8 ffff880078cd8380
 ffff880078cd8378 ffff880077ba2000 ffff880077ba2000 0000000000013580
 Call Trace:
 [<ffffffff8104538d>] ? enqueue_task_fair+0x2e6/0x339
 [<ffffffff8104f221>] do_wait+0x1d9/0x24d
 [<ffffffff8104f333>] sys_wait4+0x9e/0xc1
 [<ffffffff8104d90d>] ? child_wait_callback+0x0/0x58
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 crond         S ffff88007f50f1c0     0  1260      1 0x00000080
 ffff880079b65e68 0000000000000086 ffff880079b65dc8 ffffffffffffffff
 ffff880079b65fd8 ffff88007a301700 ffff880079b65fd8 ffff88007a301a80
 ffff88007a301a78 ffff880079b64000 ffff880079b64000 0000000000013580
 Call Trace:
 [<ffffffff81439ff5>] do_nanosleep+0x75/0xb7
 [<ffffffff8106ac5c>] hrtimer_nanosleep+0xb0/0x11d
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff8106ad22>] sys_nanosleep+0x59/0x69
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 atd           S 0000000000000000     0  1271      1 0x00000080
 ffff880077b0fe68 0000000000000082 ffff880077b0fdc8 ffffffff00000000
 ffff880077b0ffd8 ffff880078df4500 ffff880077b0ffd8 ffff880078df4880
 ffff880078df4878 ffff880077b0e000 ffff880077b0e000 0000000000013580
 Call Trace:
 [<ffffffff81439ff5>] do_nanosleep+0x75/0xb7
 [<ffffffff8106ac5c>] hrtimer_nanosleep+0xb0/0x11d
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff8106ad22>] sys_nanosleep+0x59/0x69
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 dhclient      S 0000000000000000     0  1281   1170 0x00000080
 ffff88007723b928 0000000000000082 ffff88007723b888 ffffffff00000000
 ffff88007723bfd8 ffff8800778b9700 ffff88007723bfd8 ffff8800778b9a80
 ffff8800778b9a78 ffff88007723a000 ffff88007723a000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810c53ba>] ? find_get_pages_tag+0xbf/0xeb
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8103ce9b>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff810fbc63>] ? virt_to_head_page+0xe/0x31
 [<ffffffff81205cfd>] ? cpumask_any_but+0x29/0x36
 [<ffffffff81036b24>] ? flush_tlb_page+0x73/0xb2
 [<ffffffff81035a49>] ? ptep_set_access_flags+0x44/0x52
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff810de880>] ? spin_unlock+0xe/0x10
 [<ffffffff810dfc45>] ? do_wp_page+0x63b/0x6e4
 [<ffffffff810cae09>] ? __pagevec_free+0x95/0xad
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 libvirtd      S 0000000000000000     0  1285      1 0x00000080
 ffff880078a5da58 0000000000000086 ffff880078a5da68 0000000000000000
 ffff880078a5dfd8 ffff880077298000 ffff880078a5dfd8 ffff880077298380
 ffff880077298378 ffff880078a5c000 ffff880078a5c000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 libvirtd      S 0000000000000000     0  1477      1 0x00000080
 ffff880079785c38 0000000000000086 20244c8d48fffffe 358d482800000000
 ffff880079785fd8 ffff880078cdc500 ffff880079785fd8 ffff880078cdc880
 ffff880078cdc878 ffff880079784000 ffff880079784000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81046dd0>] ? wake_up_state+0x10/0x12
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff81075441>] ? spin_unlock+0xe/0x10
 [<ffffffff81075b90>] ? futex_wake+0xe3/0xf5
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff811118a3>] ? path_put+0x22/0x26
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 libvirtd      S 0000000000000000     0  1478      1 0x00000080
 ffff880079787c38 0000000000000086 0000000000000002 ffff880000000000
 ffff880079787fd8 ffff880078cdae00 ffff880079787fd8 ffff880078cdb180
 ffff880078cdb178 ffff880079786000 ffff880079786000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81046dd0>] ? wake_up_state+0x10/0x12
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff81075441>] ? spin_unlock+0xe/0x10
 [<ffffffff81075b90>] ? futex_wake+0xe3/0xf5
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff811118a3>] ? path_put+0x22/0x26
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 libvirtd      S 0000000000000000     0  1479      1 0x00000080
 ffff880079759c38 0000000000000086 08344c834b002fc2 8349067400000000
 ffff880079759fd8 ffff880078355c00 ffff880079759fd8 ffff880078355f80
 ffff880078355f78 ffff880079758000 ffff880079758000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff81075441>] ? spin_unlock+0xe/0x10
 [<ffffffff81075b90>] ? futex_wake+0xe3/0xf5
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff811118a3>] ? path_put+0x22/0x26
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 libvirtd      S 0000000000000000     0  1480      1 0x00000080
 ffff88007975bc38 0000000000000086 358d48002f855b3d 48ea894c00000000
 ffff88007975bfd8 ffff880072f79700 ffff88007975bfd8 ffff880072f79a80
 ffff880072f79a78 ffff88007975a000 ffff88007975a000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff811118a3>] ? path_put+0x22/0x26
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 libvirtd      S ffff880078e5aa00     0  1481      1 0x00000080
 ffff88007975dc38 0000000000000086 4808738948d86753 1874c08500000001
 ffff88007975dfd8 ffff880072f7c500 ffff88007975dfd8 ffff880072f7c880
 ffff880072f7c878 ffff88007975c000 ffff88007975c000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff811118a3>] ? path_put+0x22/0x26
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gdm-binary    S ffff88007f4cf1c0     0  1304      1 0x00000080
 ffff880072d3da58 0000000000000082 ffff880072d3d9b8 ffffffffffffffff
 ffff880072d3dfd8 ffff88007729ae00 ffff880072d3dfd8 ffff88007729b180
 ffff88007729b178 ffff880072d3c000 ffff880072d3c000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] ? __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] ? __sock_recvmsg+0x4e/0x59
 [<ffffffff81380cd3>] ? sock_aio_read+0xc7/0xdb
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 mingetty      S 7fffffffffffffff     0  1305      1 0x00000080
 ffff880072d3fd08 0000000000000082 0000000000000000 ffffffffffffffff
 ffff880072d3ffd8 ffff88007729c500 ffff880072d3ffd8 ffff88007729c880
 ffff88007729c878 ffff880072d3e000 ffff880072d3e000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8104c46a>] ? release_console_sem+0x197/0x1c7
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 mingetty      S 7fffffffffffffff     0  1306      1 0x00000080
 ffff880078a71d08 0000000000000082 0000000000000000 ffffffffffffffff
 ffff880078a71fd8 ffff880077299700 ffff880078a71fd8 ffff880077299a80
 ffff880077299a78 ffff880078a70000 ffff880078a70000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8104c46a>] ? release_console_sem+0x197/0x1c7
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 mingetty      S 7fffffffffffffff     0  1307      1 0x00000080
 ffff880078a73d08 0000000000000086 ffff880078a73c78 ffffffff8103c26a
 ffff880078a73fd8 ffff88007a304500 ffff880078a73fd8 ffff88007a304880
 ffff88007a304878 ffff880078a72000 ffff880078a72000 0000000000013580
 Call Trace:
 [<ffffffff8103c26a>] ? resched_task+0x3b/0x72
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8104c46a>] ? release_console_sem+0x197/0x1c7
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 mingetty      S 7fffffffffffffff     0  1308      1 0x00000080
 ffff880078a75d08 0000000000000086 ffff880078a75c78 ffffffff8103c21f
 ffff880078a75fd8 ffff880077b1c500 ffff880078a75fd8 ffff880077b1c880
 ffff880077b1c878 ffff880078a74000 ffff880078a74000 0000000000013580
 Call Trace:
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8104c46a>] ? release_console_sem+0x197/0x1c7
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 mingetty      S 7fffffffffffffff     0  1309      1 0x00000080
 ffff880078a77d08 0000000000000086 ffff880078a77c78 ffffffff8103c26a
 ffff880078a77fd8 ffff8800781fdc00 ffff880078a77fd8 ffff8800781fdf80
 ffff8800781fdf78 ffff880078a76000 ffff880078a76000 0000000000013580
 Call Trace:
 [<ffffffff8103c26a>] ? resched_task+0x3b/0x72
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8104c46a>] ? release_console_sem+0x197/0x1c7
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gdm-simple-sl S ffff88007f44f1c0     0  1352   1304 0x00000080
 ffff8800789ada58 0000000000000082 ffff88007f553580 ffff8800ffffffff
 ffff8800789adfd8 ffff880079365c00 ffff8800789adfd8 ffff880079365f80
 ffff880079365f78 ffff8800789ac000 ffff8800789ac000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81108892>] ? do_sync_readv_writev+0xc1/0x100
 [<ffffffff810ce5c0>] ? release_pages+0x179/0x18b
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81109646>] ? do_readv_writev+0x110/0x129
 [<ffffffff810fbc63>] ? virt_to_head_page+0xe/0x31
 [<ffffffff810e519c>] ? remove_vma+0x69/0x71
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 Xorg          S ffff88007f5cf1c0     0  1353   1352 0x00400080
 ffff880079a8b928 0000000000000082 ffff88007f4d35f0 ffff8800ffffffff
 ffff880079a8bfd8 ffff880078cd9700 ffff880079a8bfd8 ffff880078cd9a80
 ffff880078cd9a78 ffff880079a8a000 ffff880079a8a000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81117105>] ? zero_fd_set+0x1a/0x1e
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff81108776>] ? fsnotify_modify+0x66/0x6e
 [<ffffffff81069d14>] ? __remove_hrtimer+0x7d/0x8a
 [<ffffffff81069d76>] ? remove_hrtimer+0x55/0x61
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 dnsmasq       S 0000000000000000     0  1368      1 0x00000080
 ffff880072f53928 0000000000000086 ffff88005e040780 ffffffff00000000
 ffff880072f53fd8 ffff880079688000 ffff880072f53fd8 ffff880079688380
 ffff880079688378 ffff880072f52000 ffff880072f52000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff811117d9>] ? path_to_nameidata+0x1b/0x3e
 [<ffffffff81112607>] ? link_path_walk+0x55e/0x563
 [<ffffffff81111744>] ? mntput+0x1d/0x1f
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff8117d1dd>] ? spin_unlock+0xe/0x10
 [<ffffffff8117d94a>] ? ext4_getattr+0x49/0x6b
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff8110ca1a>] ? cp_new_stat+0xe3/0xef
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sendmail      S 0000000000000000     0  1423      1 0x00000080
 ffff880072da7928 0000000000000086 ffff880072da7888 ffffffff00000000
 ffff880072da7fd8 ffff880072f78000 ffff880072da7fd8 ffff880072f78380
 ffff880072f78378 ffff880072da6000 ffff880072da6000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81153593>] ? proc_alloc_inode+0x20/0x93
 [<ffffffff8143b40e>] ? common_interrupt+0xe/0x13
 [<ffffffff8143b40e>] ? common_interrupt+0xe/0x13
 [<ffffffff81122757>] ? seq_open+0x3e/0xb1
 [<ffffffff8112274a>] ? seq_open+0x31/0xb1
 [<ffffffff8120c24f>] ? put_dec+0x20/0x3c
 [<ffffffff8120c3b3>] ? number+0x148/0x248
 [<ffffffff8112280a>] ? __seq_open_private+0x40/0x60
 [<ffffffff81118948>] ? spin_unlock+0xe/0x10
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff811537ed>] ? spin_unlock+0xe/0x10
 [<ffffffff81153fac>] ? proc_reg_open+0x1b9/0x1cd
 [<ffffffff8120ddd2>] ? vsnprintf+0x84/0x42a
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff810fbc63>] ? virt_to_head_page+0xe/0x31
 [<ffffffff810fbc63>] ? virt_to_head_page+0xe/0x31
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff810a1952>] ? rcu_start_gp+0x20f/0x218
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sendmail      S 0000000000000000     0  1425      1 0x00000080
 ffff880072f99f68 0000000000000082 ffff880072f7ae00 ffff880000000000
 ffff880072f99fd8 ffff880072f7ae00 ffff880072f99fd8 ffff880072f7b180
 ffff880072f7b178 ffff880072f98000 ffff880072f98000 0000000000013580
 Call Trace:
 [<ffffffff8105a834>] sys_pause+0x1e/0x27
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 dbus-launch   S 0000000000000000     0  1443      1 0x00000080
 ffff880078361928 0000000000000082 000000000ed3c8e8 ffff880078df0038
 ffff880078361fd8 ffff880078df0000 ffff880078361fd8 ffff880078df0380
 ffff880078df0378 ffff880078360000 ffff880078360000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8140e482>] ? scm_recv+0x3f/0xca
 [<ffffffff81385b0d>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8140fe1b>] ? unix_stream_recvmsg+0x54b/0x56b
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] ? __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] ? __sock_recvmsg+0x4e/0x59
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 dbus-daemon   S 0000000000000000     0  1444      1 0x00000080
 ffff8800771e3a58 0000000000000082 ffff88007f453580 ffff88007f453580
 ffff8800771e3fd8 ffff880078bc9700 ffff8800771e3fd8 ffff880078bc9a80
 ffff880078bc9a78 ffff8800771e2000 ffff8800771e2000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gnome-session S ffff88007f44f1c0     0  1445   1352 0x00000080
 ffff880072f03a58 0000000000000082 ffff880072f039d8 ffffffffffffffff
 ffff880072f03fd8 ffff880072f7dc00 ffff880072f03fd8 ffff880072f7df80
 ffff880072f7df78 ffff880072f02000 ffff880072f02000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gnome-session S 0000000000000000     0  1469   1352 0x00000080
 ffff880079615cd8 0000000000000082 ffff880079615c78 ffffffff00000000
 ffff880079615fd8 ffff880078cddc00 ffff880079615fd8 ffff880078cddf80
 ffff880078cddf78 ffff880079614000 ffff880079614000 0000000000013580
 Call Trace:
 [<ffffffff81110649>] pipe_wait+0x63/0x7f
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81110dee>] pipe_read+0x336/0x3b7
 [<ffffffff810e1905>] ? handle_mm_fault+0x8d1/0x921
 [<ffffffff81108aa4>] do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff81109c96>] ? fget_light+0xa5/0xb0
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 devkit-power- S 0000000000000000     0  1448      1 0x00000080
 ffff8800789bfa58 0000000000000086 ffff8800789bf9b8 ffffffff81046dbe
 ffff8800789bffd8 ffff880078bcdc00 ffff8800789bffd8 ffff880078bcdf80
 ffff880078bcdf78 ffff8800789be000 ffff8800789be000 0000000000013580
 Call Trace:
 [<ffffffff81046dbe>] ? default_wake_function+0x12/0x14
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] ? __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] ? __sock_recvmsg+0x4e/0x59
 [<ffffffff81380cd3>] ? sock_aio_read+0xc7/0xdb
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gconfd-2      S ffff880079206c80     0  1452      1 0x00000080
 ffff880072d91a58 0000000000000082 ffff880072d919b8 ffffffff8143ae48
 ffff880072d91fd8 ffff880078350000 ffff880072d91fd8 ffff880078350380
 ffff880078350378 ffff880072d90000 ffff880072d90000 0000000000013580
 Call Trace:
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gnome-setting S 0000000000000000     0  1470      1 0x00000080
 ffff880072ff7a58 0000000000000082 ffff880072ff79b8 ffffffff00000000
 ffff880072ff7fd8 ffff880078bcc500 ffff880072ff7fd8 ffff880078bcc880
 ffff880078bcc878 ffff880072ff6000 ffff880072ff6000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gnome-setting S 0000000000000000     0  1475      1 0x00000080
 ffff880079745cd8 0000000000000082 ffff880079745c78 ffffffff00000000
 ffff880079745fd8 ffff880077808000 ffff880079745fd8 ffff880077808380
 ffff880077808378 ffff880079744000 ffff880079744000 0000000000013580
 Call Trace:
 [<ffffffff81110649>] pipe_wait+0x63/0x7f
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff81110dee>] pipe_read+0x336/0x3b7
 [<ffffffff810e1905>] ? handle_mm_fault+0x8d1/0x921
 [<ffffffff81108aa4>] do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff81109c96>] ? fget_light+0xa5/0xb0
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gvfsd         S 0000000000000000     0  1483      1 0x00000080
 ffff880079727a58 0000000000000082 ffff88007f413580 ffff880000000000
 ffff880079727fd8 ffff8800778bae00 ffff880079727fd8 ffff8800778bb180
 ffff8800778bb178 ffff880079726000 ffff880079726000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81380b38>] ? sock_aio_write+0x0/0xd4
 [<ffffffff81380bf8>] ? sock_aio_write+0xc0/0xd4
 [<ffffffff81108892>] ? do_sync_readv_writev+0xc1/0x100
 [<ffffffff810ce80a>] ? lru_cache_add_lru+0x41/0x43
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81108776>] ? fsnotify_modify+0x66/0x6e
 [<ffffffff81109646>] ? do_readv_writev+0x110/0x129
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 metacity      S 0000000000000000     0  1484   1445 0x00000080
 ffff880072cb9a58 0000000000000082 ffff88007f453580 ffff88007f453580
 ffff880072cb9fd8 ffff8800781fc500 ffff880072cb9fd8 ffff8800781fc880
 ffff8800781fc878 ffff880072cb8000 ffff880072cb8000 0000000000013580
 Call Trace:
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 plymouth-log- S ffff88007a355080     0  1485   1445 0x00000080
 ffff88007977ba58 0000000000000082 ffff88007977b9b8 ffffffff8143ae48
 ffff88007977bfd8 ffff880077950000 ffff88007977bfd8 ffff880077950380
 ffff880077950378 ffff88007977a000 ffff88007977a000 0000000000013580
 Call Trace:
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] ? __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] ? __sock_recvmsg+0x4e/0x59
 [<ffffffff81380cd3>] ? sock_aio_read+0xc7/0xdb
 [<ffffffff81111744>] ? mntput+0x1d/0x1f
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gnome-power-m S 0000000000000000     0  1486   1445 0x00000080
 ffff88007905ba58 0000000000000086 ffff88007905b9b8 ffffffff00000000
 ffff88007905bfd8 ffff880079689700 ffff88007905bfd8 ffff880079689a80
 ffff880079689a78 ffff88007905a000 ffff88007905a000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gdm-simple-gr S ffff88007f50f1c0     0  1487   1445 0x00000080
 ffff880072e11a58 0000000000000086 ffff880072e119b8 ffffffffffffffff
 ffff880072e11fd8 ffff880078a20000 ffff880072e11fd8 ffff880078a20380
 ffff880078a20378 ffff880072e10000 ffff880072e10000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 polkit-gnome- S 0000000000000000     0  1488   1445 0x00000080
 ffff880072e53a58 0000000000000086 ffff880072e53a68 0000000000000000
 ffff880072e53fd8 ffff880078bc8000 ffff880072e53fd8 ffff880078bc8380
 ffff880078bc8378 ffff880072e52000 ffff880072e52000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] ? __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] ? __sock_recvmsg+0x4e/0x59
 [<ffffffff81380cd3>] ? sock_aio_read+0xc7/0xdb
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 polkitd       S 0000000000000000     0  1492      1 0x00000080
 ffff8800773dfa58 0000000000000082 ffff8800773df9b8 ffffffff00000000
 ffff8800773dffd8 ffff8800778bc500 ffff8800773dffd8 ffff8800778bc880
 ffff8800778bc878 ffff8800773de000 ffff8800773de000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff81382105>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8137d7bf>] ? __sock_recvmsg_nosec+0x6a/0x73
 [<ffffffff8137ea04>] ? __sock_recvmsg+0x4e/0x59
 [<ffffffff81380cd3>] ? sock_aio_read+0xc7/0xdb
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 notification- S ffff88007f50f1c0     0  1494      1 0x00000080
 ffff8800773eba58 0000000000000082 ffff8800773eb9b8 ffffffffffffffff
 ffff8800773ebfd8 ffff880079484500 ffff8800773ebfd8 ffff880079484880
 ffff880079484878 ffff8800773ea000 ffff8800773ea000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81108aa4>] ? do_sync_read+0xcb/0x108
 [<ffffffff811cff6e>] ? fsnotify_perm+0x4a/0x50
 [<ffffffff811cffd5>] ? security_file_permission+0x2e/0x33
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 pulseaudio    S ffff88007f50f1c0     0  1501      1 0x00000080
 ffff880069161a08 0000000000000086 ffff880069161a58 ffffffffffffffff
 ffff880069161fd8 ffff8800773b8000 ffff880069161fd8 ffff8800773b8380
 ffff8800773b8378 ffff880069160000 ffff880069160000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff810e5126>] ? tlb_finish_mmu+0x5b/0x68
 [<ffffffff811182a1>] sys_ppoll+0xc0/0x149
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 pulseaudio    S 0000000000000000     0  1509      1 0x00000080
 ffff88006932fa08 0000000000000086 ffff88006932fa18 0000000000000000
 ffff88006932ffd8 ffff8800773e5c00 ffff88006932ffd8 ffff8800773e5f80
 ffff8800773e5f78 ffff88006932e000 ffff88006932e000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8103e24b>] ? select_task_rq_fair+0x658/0x65d
 [<ffffffff8103e2cb>] ? __enqueue_entity+0x7b/0x7d
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c26a>] ? resched_task+0x3b/0x72
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81045582>] ? ttwu_post_activation+0x74/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffff81046d91>] ? try_to_wake_up+0x23a/0x255
 [<ffffffff81046dd0>] ? wake_up_state+0x10/0x12
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff81075441>] ? spin_unlock+0xe/0x10
 [<ffffffff81075b90>] ? futex_wake+0xe3/0xf5
 [<ffffffffa00ddaf5>] ? snd_card_file_remove+0x10d/0x11e [snd]
 [<ffffffff810773f9>] ? do_futex+0xba/0x860
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff811182a1>] sys_ppoll+0xc0/0x149
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 pulseaudio    S 0000000000000000     0  1510      1 0x00000080
 ffff88006933ba08 0000000000000086 ffff88006933ba18 0000000000000000
 ffff88006933bfd8 ffff880069219700 ffff88006933bfd8 ffff880069219a80
 ffff880069219a78 ffff88006933a000 ffff88006933a000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8103e24b>] ? select_task_rq_fair+0x658/0x65d
 [<ffffffff8103e2cb>] ? __enqueue_entity+0x7b/0x7d
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c26a>] ? resched_task+0x3b/0x72
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81045582>] ? ttwu_post_activation+0x74/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffff81046d91>] ? try_to_wake_up+0x23a/0x255
 [<ffffffff81046dd0>] ? wake_up_state+0x10/0x12
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff81075441>] ? spin_unlock+0xe/0x10
 [<ffffffff81075b90>] ? futex_wake+0xe3/0xf5
 [<ffffffff810773f9>] ? do_futex+0xba/0x860
 [<ffffffffa00ddaf5>] ? snd_card_file_remove+0x10d/0x11e [snd]
 [<ffffffff811182a1>] sys_ppoll+0xc0/0x149
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 pulseaudio    S 0000000000000000     0  1511      1 0x00000080
 ffff88006933da08 0000000000000086 ffff88006933da18 0000000000000000
 ffff88006933dfd8 ffff88006921ae00 ffff88006933dfd8 ffff88006921b180
 ffff88006921b178 ffff88006933c000 ffff88006933c000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8103e24b>] ? select_task_rq_fair+0x658/0x65d
 [<ffffffff8103e2cb>] ? __enqueue_entity+0x7b/0x7d
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c26a>] ? resched_task+0x3b/0x72
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81045582>] ? ttwu_post_activation+0x74/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffff81046d91>] ? try_to_wake_up+0x23a/0x255
 [<ffffffff81046dd0>] ? wake_up_state+0x10/0x12
 [<ffffffff8143ae0d>] ? _raw_spin_unlock+0x23/0x2e
 [<ffffffff81075441>] ? spin_unlock+0xe/0x10
 [<ffffffff81075b90>] ? futex_wake+0xe3/0xf5
 [<ffffffff810773f9>] ? do_futex+0xba/0x860
 [<ffffffffa00ddaf5>] ? snd_card_file_remove+0x10d/0x11e [snd]
 [<ffffffff811182a1>] sys_ppoll+0xc0/0x149
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 rtkit-daemon  S 0000000000000000     0  1503      1 0x00000080
 ffff8800691c3a58 0000000000000082 ffff88007f493580 ffff88007f493580
 ffff8800691c3fd8 ffff8800773bc500 ffff8800691c3fd8 ffff8800773bc880
 ffff8800773bc878 ffff8800691c2000 ffff8800691c2000 0000000000013580
 Call Trace:
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81117882>] ? __pollwait+0xc3/0xcc
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81380b38>] ? sock_aio_write+0x0/0xd4
 [<ffffffff81380bf8>] ? sock_aio_write+0xc0/0xd4
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81108892>] ? do_sync_readv_writev+0xc1/0x100
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81108776>] ? fsnotify_modify+0x66/0x6e
 [<ffffffff81109646>] ? do_readv_writev+0x110/0x129
 [<ffffffff811ce6f6>] ? cap_safe_nice+0x41/0x5e
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 rtkit-daemon  S 0000000000000000     0  1504      1 0x00000080
 ffff8800773b5a58 0000000000000082 ffff8800773b59b8 ffffffff00000000
 ffff8800773b5fd8 ffff8800773bdc00 ffff8800773b5fd8 ffff8800773bdf80
 ffff8800773bdf78 ffff8800773b4000 ffff8800773b4000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff81069e33>] ? enqueue_hrtimer+0xb1/0xc1
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8106ab6a>] ? __hrtimer_start_range_ns+0x310/0x322
 [<ffffffff81040984>] ? enqueue_pushable_task+0x6c/0x74
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c26a>] ? resched_task+0x3b/0x72
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff81045c9e>] ? task_woken_rt+0x23/0x72
 [<ffffffff810455a0>] ? ttwu_post_activation+0x92/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffff81046d91>] ? try_to_wake_up+0x23a/0x255
 [<ffffffff81046dbe>] ? default_wake_function+0x12/0x14
 [<ffffffff811178dd>] ? pollwake+0x52/0x54
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 rtkit-daemon  S 0000000000000000     0  1505      1 0x00000080
 ffff8800691e3a58 0000000000000082 ffff8800691e39b8 ffffffff00000000
 ffff8800691e3fd8 ffff8800773b9700 ffff8800691e3fd8 ffff8800773b9a80
 ffff8800773b9a78 ffff8800691e2000 ffff8800691e2000 0000000000013580
 Call Trace:
 [<ffffffff81439f24>] schedule_hrtimeout_range_clock+0xde/0x111
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff8137ef7f>] ? sock_sendmsg+0xa8/0xc1
 [<ffffffff810d06b1>] ? page_evictable+0x17/0x7a
 [<ffffffff810ce80a>] ? lru_cache_add_lru+0x41/0x43
 [<ffffffff810e9492>] ? page_add_new_anon_rmap+0x60/0x72
 [<ffffffff8143b40e>] ? common_interrupt+0xe/0x13
 [<ffffffff8143b40e>] ? common_interrupt+0xe/0x13
 [<ffffffff8113aee7>] ? eventfd_read+0x0/0x63
 [<ffffffff8143aac1>] ? _raw_spin_lock_irq+0x1/0x35
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff810101b6>] ? read_tsc+0x9/0x1b
 [<ffffffff8106f097>] ? timekeeping_get_ns+0x1b/0x3d
 [<ffffffff8106f8e3>] ? ktime_get_ts+0x85/0x8e
 [<ffffffff8111716f>] ? poll_select_set_timeout+0x66/0x81
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 gdm-session-w S 0000000000000000     0  1506   1352 0x00000080
 ffff880069203a58 0000000000000082 ffff8800692039b8 ffffffff81046dbe
 ffff880069203fd8 ffff8800773e4500 ffff880069203fd8 ffff8800773e4880
 ffff8800773e4878 ffff880069202000 ffff880069202000 0000000000013580
 Call Trace:
 [<ffffffff81046dbe>] ? default_wake_function+0x12/0x14
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff810c5ecd>] ? filemap_fault+0xb4/0x31c
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff810c5885>] ? unlock_page+0x17/0x19
 [<ffffffff810df32a>] ? __do_fault+0x414/0x44a
 [<ffffffff810e148b>] ? handle_mm_fault+0x457/0x921
 [<ffffffff8111beae>] ? alloc_inode+0x30/0x7b
 [<ffffffff81110e82>] ? kzalloc.clone.0+0x13/0x15
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff8105a86b>] ? spin_unlock_irq+0xe/0x10
 [<ffffffff8105af59>] ? do_sigaction+0x171/0x189
 [<ffffffff8111837f>] sys_poll+0x55/0xbf
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sshd          S ffff88007f44f1c0     0  1593   1187 0x00000080
 ffff880069065928 0000000000000086 ffff8800690658d8 ffffffffffffffff
 ffff880069065fd8 ffff88007729dc00 ffff880069065fd8 ffff88007729df80
 ffff88007729df78 ffff880069064000 ffff880069064000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8103c1ed>] ? test_tsk_need_resched+0x17/0x21
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81045582>] ? ttwu_post_activation+0x74/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffff81046d91>] ? try_to_wake_up+0x23a/0x255
 [<ffffffff81046dbe>] ? default_wake_function+0x12/0x14
 [<ffffffff81039df2>] ? __wake_up_common+0x4e/0x84
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff8103d062>] ? __wake_up+0x44/0x4d
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          R  running task        0  1596   1593 0x00000080
 ffff880069275d88 0000000000000014 00000000ffffffff ffff880069275c98
 ffff880069275d08 0000000000000002 ffff880069275c88 ffffffff8106b43e
 ffff880069275c98 0000000000000002 ffff880069275ca8 ffffffff8104bfac
 Call Trace:
 [<ffffffff8100c9e4>] ? dump_trace+0x307/0x337
 [<ffffffff8100d4e0>] show_trace_log_lvl+0x54/0x5d
 [<ffffffff8100c4b0>] show_stack_log_lvl+0x13e/0x14d
 [<ffffffff8100d48a>] show_stack+0x1c/0x1e
 [<ffffffff810421a4>] sched_show_task+0xb1/0xb6
 [<ffffffff81042205>] show_state_filter+0x5c/0xba
 [<ffffffff8129e6be>] sysrq_handle_showstate+0x10/0x12
 [<ffffffff8129ea96>] __handle_sysrq+0xbf/0x15c
 [<ffffffff8129eb33>] ? write_sysrq_trigger+0x0/0x3b
 [<ffffffff8129eb66>] write_sysrq_trigger+0x33/0x3b
 [<ffffffff81153c6e>] proc_reg_write+0x92/0xb1
 [<ffffffff81108ef6>] vfs_write+0xae/0x10a
 [<ffffffff81109012>] sys_write+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 udevd         S ffff8800771f5080     0  1631    170 0x00000080
 ffff880077383a08 0000000000000082 0000000000002e8c ffff8800793edc00
 ffff880077383fd8 ffff8800792c2e00 ffff880077383fd8 ffff8800792c3180
 ffff8800792c3178 ffff880077382000 ffff880077382000 0000000000013580
 Call Trace:
 [<ffffffff8103e2cb>] ? __enqueue_entity+0x7b/0x7d
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81045582>] ? ttwu_post_activation+0x74/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8140e320>] ? scm_destroy_cred+0x2e/0x3b
 [<ffffffff8140e343>] ? scm_destroy+0x16/0x2f
 [<ffffffff8140f4d8>] ? unix_dgram_sendmsg+0x3d3/0x418
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff8137ef7f>] ? sock_sendmsg+0xa8/0xc1
 [<ffffffff8137ed04>] ? move_addr_to_kernel+0x49/0x4e
 [<ffffffff81388652>] ? copy_from_user+0xe/0x10
 [<ffffffff81388a23>] ? verify_iovec+0x57/0x98
 [<ffffffff8137f78a>] ? sys_sendmsg+0x222/0x241
 [<ffffffff8137f00f>] ? sockfd_lookup_light+0x20/0x58
 [<ffffffff8137f53c>] ? sys_sendto+0xef/0x105
 [<ffffffff81069d76>] ? remove_hrtimer+0x55/0x61
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff811182a1>] sys_ppoll+0xc0/0x149
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 kvm-irqfd-cle S 0000000000000000     0  1634      2 0x00000080
 ffff880065d61e60 0000000000000046 ffff88007f593580 ffff880000000000
 ffff880065d61fd8 ffff8800792c5c00 ffff880065d61fd8 ffff8800792c5f80
 ffff8800792c5f78 ffff880065d60000 ffff880065d60000 0000000000013580
 Call Trace:
 [<ffffffff81062484>] rescuer_thread+0x1a5/0x1aa
 [<ffffffff810622df>] ? rescuer_thread+0x0/0x1aa
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 screen        S 0000000000000000     0  1638      1 0x00000080
 ffff880069223928 0000000000000086 ffff8800692238d8 ffffffff812cc6e8
 ffff880069223fd8 ffff88006921c500 ffff880069223fd8 ffff88006921c880
 ffff88006921c878 ffff880069222000 ffff880069222000 0000000000013580
 Call Trace:
 [<ffffffff812cc6e8>] ? scsi_request_fn+0x3ab/0x469
 [<ffffffff8106224a>] ? flush_work+0x1f/0x39
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810c574c>] ? __lock_page+0x66/0x6d
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff8110116c>] ? unlock_page_cgroup+0x2a/0x35
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff810c5885>] ? unlock_page+0x17/0x19
 [<ffffffff810df32a>] ? __do_fault+0x414/0x44a
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S 0000000000000000     0  1639   1638 0x00000080
 ffff880065e47d08 0000000000000082 ffff880065e47c78 ffffffff00000000
 ffff880065e47fd8 ffff880069218000 ffff880065e47fd8 ffff880069218380
 ffff880069218378 ffff880065e46000 ffff880065e46000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8128970e>] ? tty_wakeup+0x5b/0x60
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 kworker/u:0   S 0000000000000000     0  1924      2 0x00000080
 ffff88001c6afe80 0000000000000046 ffff88001c6afe00 0000000000000000
 ffff88001c6affd8 ffff880079362e00 ffff88001c6affd8 ffff880079363180
 ffff880079363178 ffff88001c6ae000 ffff88001c6ae000 0000000000013580
 Call Trace:
 [<ffffffff81063162>] worker_thread+0x255/0x25a
 [<ffffffff81062f0d>] ? worker_thread+0x0/0x25a
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 kworker/u:1   S ffff88007f44f1c0     0  2062      2 0x00000080
 ffff880018f7fe80 0000000000000046 ffff88007a0e64f8 ffff8800ffffffff
 ffff880018f7ffd8 ffff8800692a2e00 ffff880018f7ffd8 ffff8800692a3180
 ffff8800692a3178 ffff880018f7e000 ffff880018f7e000 0000000000013580
 Call Trace:
 [<ffffffff81063162>] worker_thread+0x255/0x25a
 [<ffffffff81062f0d>] ? worker_thread+0x0/0x25a
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 sshd          S 0000000000000000     0  2144   1187 0x00000080
 ffff88001badf928 0000000000000086 ffff88001badf8c8 ffffffff00000000
 ffff88001badffd8 ffff8800778bdc00 ffff88001badffd8 ffff8800778bdf80
 ffff8800778bdf78 ffff88001bade000 ffff88001bade000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff813ce580>] ? tcp_sendmsg+0x786/0x879
 [<ffffffff813ea747>] ? inet_sendmsg+0x66/0x6f
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8110899c>] ? do_sync_write+0xcb/0x108
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S 0000000000000000     0  2147   2144 0x00000080
 ffff8800225e7d08 0000000000000086 ffff8800225e7c68 0000000000000000
 ffff8800225e7fd8 ffff880079482e00 ffff8800225e7fd8 ffff880079483180
 ffff880079483178 ffff8800225e6000 ffff8800225e6000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8128970e>] ? tty_wakeup+0x5b/0x60
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 udevd         S ffff880078e5e580     0  2235    170 0x00000080
 ffff8800691bfa08 0000000000000082 0000003bb1a12475 ffff88007f453580
 ffff8800691bffd8 ffff88005bc6ae00 ffff8800691bffd8 ffff88005bc6b180
 ffff88005bc6b178 ffff8800691be000 ffff8800691be000 0000000000013580
 Call Trace:
 [<ffffffff81044bc4>] ? check_preempt_wakeup+0x111/0x18c
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff8103c21f>] ? check_preempt_curr+0x28/0x38
 [<ffffffff81045582>] ? ttwu_post_activation+0x74/0x10d
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81067158>] ? add_wait_queue+0x44/0x4c
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81118156>] do_sys_poll+0x35f/0x3ea
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8140e320>] ? scm_destroy_cred+0x2e/0x3b
 [<ffffffff8140e343>] ? scm_destroy+0x16/0x2f
 [<ffffffff8140f4d8>] ? unix_dgram_sendmsg+0x3d3/0x418
 [<ffffffff810c55f9>] ? find_get_page+0x7d/0x90
 [<ffffffff810c5ecd>] ? filemap_fault+0xb4/0x31c
 [<ffffffff810c5827>] ? wake_up_page+0x25/0x2a
 [<ffffffff810c5885>] ? unlock_page+0x17/0x19
 [<ffffffff810df32a>] ? __do_fault+0x414/0x44a
 [<ffffffff810e148b>] ? handle_mm_fault+0x457/0x921
 [<ffffffff8137f78a>] ? sys_sendmsg+0x222/0x241
 [<ffffffff8143e244>] ? do_page_fault+0x33d/0x377
 [<ffffffff81069d76>] ? remove_hrtimer+0x55/0x61
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff811182a1>] sys_ppoll+0xc0/0x149
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sshd          S 0000000000000000     0  2247   1187 0x00000080
 ffff880072f11928 0000000000000086 ffff88007974e2f0 ffff880000000000
 ffff880072f11fd8 ffff880079480000 ffff880072f11fd8 ffff880079480380
 ffff880079480378 ffff880072f10000 ffff880072f10000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff813ce580>] ? tcp_sendmsg+0x786/0x879
 [<ffffffff813ea747>] ? inet_sendmsg+0x66/0x6f
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8110899c>] ? do_sync_write+0xcb/0x108
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S 0000000000000000     0  2249   2247 0x00000080
 ffff880022587d08 0000000000000086 ffff880022587c78 ffffffff00000000
 ffff880022587fd8 ffff880079481700 ffff880022587fd8 ffff880079481a80
 ffff880079481a78 ffff880022586000 ffff880022586000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8128970e>] ? tty_wakeup+0x5b/0x60
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sshd          S ffff88007f44f1c0     0  2466   1187 0x00000080
 ffff88005dc7d928 0000000000000086 ffff88005dc7d8d8 ffffffffffffffff
 ffff88005dc7dfd8 ffff880072c62e00 ffff88005dc7dfd8 ffff880072c63180
 ffff880072c63178 ffff88005dc7c000 ffff88005dc7c000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff813ce580>] ? tcp_sendmsg+0x786/0x879
 [<ffffffff813ea747>] ? inet_sendmsg+0x66/0x6f
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8110899c>] ? do_sync_write+0xcb/0x108
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S 0000000000000000     0  2469   2466 0x00000080
 ffff88005e0ebe58 0000000000000086 ffff88005e0ebdb8 ffffffff00000000
 ffff88005e0ebfd8 ffff880078ad5c00 ffff88005e0ebfd8 ffff880078ad5f80
 ffff880078ad5f78 ffff88005e0ea000 ffff88005e0ea000 0000000000013580
 Call Trace:
 [<ffffffff8104f221>] do_wait+0x1d9/0x24d
 [<ffffffff8104f333>] sys_wait4+0x9e/0xc1
 [<ffffffff8104d90d>] ? child_wait_callback+0x0/0x58
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 sshd          S 0000000000000000     0  2502   1187 0x00000080
 ffff88005e147928 0000000000000082 ffff88005e1478d8 ffffffff00000000
 ffff88005e147fd8 ffff8800778b8000 ffff88005e147fd8 ffff8800778b8380
 ffff8800778b8378 ffff88005e146000 ffff88005e146000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff813ce580>] ? tcp_sendmsg+0x786/0x879
 [<ffffffff813ea747>] ? inet_sendmsg+0x66/0x6f
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8110899c>] ? do_sync_write+0xcb/0x108
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S ffff880079361700     0  2505   2502 0x00000080
 ffff880065fa3e58 0000000000000086 ffff880065fa3db8 ffffffff812879fb
 ffff880065fa3fd8 ffff880079361700 ffff880065fa3fd8 ffff880079361a80
 ffff880079361a78 ffff880065fa2000 ffff880065fa2000 0000000000013580
 Call Trace:
 [<ffffffff812879fb>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8104f221>] do_wait+0x1d9/0x24d
 [<ffffffff8104f333>] sys_wait4+0x9e/0xc1
 [<ffffffff8104d90d>] ? child_wait_callback+0x0/0x58
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 kworker/0:2   S 0000000000000000     0  2607      2 0x00000080
 ffff880065c99e80 0000000000000046 ffff880065c99e00 0000000000000286
 ffff880065c99fd8 ffff8800692a1700 ffff880065c99fd8 ffff8800692a1a80
 ffff8800692a1a78 ffff880065c98000 ffff880065c98000 0000000000013580
 Call Trace:
 [<ffffffff81063162>] worker_thread+0x255/0x25a
 [<ffffffff81062f0d>] ? worker_thread+0x0/0x25a
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 sshd          S 0000000000000000     0  2679   1187 0x00000080
 ffff880077395928 0000000000000086 ffff8800773958d8 ffffffff00000000
 ffff880077395fd8 ffff880014810000 ffff880077395fd8 ffff880014810380
 ffff880014810378 ffff880077394000 ffff880077394000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff813ce580>] ? tcp_sendmsg+0x786/0x879
 [<ffffffff813ea747>] ? inet_sendmsg+0x66/0x6f
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8110899c>] ? do_sync_write+0xcb/0x108
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S 0000000000000000     0  2681   2679 0x00000080
 ffff88005a27fd08 0000000000000086 ffff88005a27fc78 ffffffff00000000
 ffff88005a27ffd8 ffff88005e1d1700 ffff88005a27ffd8 ffff88005e1d1a80
 ffff88005e1d1a78 ffff88005a27e000 ffff88005a27e000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8128970e>] ? tty_wakeup+0x5b/0x60
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 kworker/1:2   S ffff88007f44f1c0     0  2729      2 0x00000080
 ffff88005a327e80 0000000000000046 ffff88002f488564 ffff8800ffffffff
 ffff88005a327fd8 ffff88005e192e00 ffff88005a327fd8 ffff88005e193180
 ffff88005e193178 ffff88005a326000 ffff88005a326000 0000000000013580
 Call Trace:
 [<ffffffff81063162>] worker_thread+0x255/0x25a
 [<ffffffff81062f0d>] ? worker_thread+0x0/0x25a
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 sshd          S 0000000000000000     0  2732   1187 0x00000080
 ffff88002241d928 0000000000000086 ffff88002241d8d8 ffffffff00000000
 ffff88002241dfd8 ffff88005e1d5c00 ffff88002241dfd8 ffff88005e1d5f80
 ffff88005e1d5f78 ffff88002241c000 ffff88002241c000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff813ce580>] ? tcp_sendmsg+0x786/0x879
 [<ffffffff813ea747>] ? inet_sendmsg+0x66/0x6f
 [<ffffffff8137e9aa>] ? __sock_sendmsg+0x6b/0x77
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8110899c>] ? do_sync_write+0xcb/0x108
 [<ffffffff811358f1>] ? fsnotify+0x211/0x230
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 bash          S 0000000000000000     0  2734   2732 0x00000080
 ffff88007a279d08 0000000000000086 ffff88007a279c78 0000000000000000
 ffff88007a279fd8 ffff88005e1d0000 ffff88007a279fd8 ffff88005e1d0380
 ffff88005e1d0378 ffff88007a278000 ffff88007a278000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8105894b>] ? del_timer_sync+0x19/0x25
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff8128caa3>] n_tty_read+0x4dc/0x823
 [<ffffffff8128970e>] ? tty_wakeup+0x5b/0x60
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81288014>] tty_read+0x86/0xca
 [<ffffffff811090e1>] vfs_read+0xab/0x107
 [<ffffffff811091fd>] sys_read+0x4a/0x6e
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 vim           S 0000000000000000     0  3201   2505 0x00000080
 ffff88005e143928 0000000000000086 0000000000011210 0000000000000000
 ffff88005e143fd8 ffff880072c60000 ffff88005e143fd8 ffff880072c60380
 ffff880072c60378 ffff88005e142000 ffff88005e142000 0000000000013580
 Call Trace:
 [<ffffffff81439e88>] schedule_hrtimeout_range_clock+0x42/0x111
 [<ffffffff810622ad>] ? flush_delayed_work+0x49/0x4e
 [<ffffffff81290136>] ? tty_flush_to_ldisc+0x15/0x17
 [<ffffffff8128bc3b>] ? input_available_p+0x17/0x54
 [<ffffffff81439f6a>] schedule_hrtimeout_range+0x13/0x15
 [<ffffffff811171d2>] poll_schedule_timeout+0x48/0x64
 [<ffffffff81117781>] do_select+0x4f9/0x537
 [<ffffffff811177bf>] ? __pollwait+0x0/0xcc
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff8111788b>] ? pollwake+0x0/0x54
 [<ffffffff810087eb>] ? __switch_to+0x215/0x227
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff81042868>] ? finish_task_switch+0x86/0xa5
 [<ffffffff8103cdc7>] ? rcu_read_unlock+0xe/0x10
 [<ffffffff8103ce24>] ? cpuacct_charge+0x5b/0x64
 [<ffffffff8103da13>] ? __dequeue_entity+0x33/0x38
 [<ffffffff810087eb>] ? __switch_to+0x215/0x227
 [<ffffffff8143ae7d>] ? _raw_spin_unlock_irq+0x2a/0x35
 [<ffffffff81117af5>] core_sys_select+0x185/0x21b
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff81066e75>] ? spin_unlock_irqrestore+0xe/0x10
 [<ffffffff81066f6d>] ? finish_wait+0x66/0x6e
 [<ffffffff8143aef7>] ? _raw_read_unlock+0x24/0x2f
 [<ffffffff811b6fc2>] ? jbd2_log_wait_commit+0x15c/0x183
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffff8143afee>] ? _raw_write_unlock+0x28/0x33
 [<ffffffff81117dcf>] sys_select+0x96/0xbe
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 flush-253:1   S ffff88007f44f1c0     0  3329      2 0x00000080
 ffff88005beb1dd0 0000000000000046 0000000000000000 ffff8800ffffffff
 ffff88005beb1fd8 ffff88005be1c500 ffff88005beb1fd8 ffff88005be1c880
 ffff88005be1c878 ffff88005beb0000 ffff88005beb0000 0000000000013580
 Call Trace:
 [<ffffffff814397f6>] schedule_timeout+0x9c/0xc0
 [<ffffffff810589d9>] ? process_timeout+0x0/0x10
 [<ffffffff811271ef>] bdi_writeback_thread+0x1bc/0x24a
 [<ffffffff81127033>] ? bdi_writeback_thread+0x0/0x24a
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 flush-8:0     S 0000000000000000     0  3335      2 0x00000080
 ffff880079b59e50 0000000000000046 000000010058bd20 ffff880000000000
 ffff880079b59fd8 ffff88005be18000 ffff880079b59fd8 ffff88005be18380
 ffff88005be18378 ffff880079b58000 ffff880079b58000 0000000000013580
 Call Trace:
 [<ffffffff811271f6>] bdi_writeback_thread+0x1c3/0x24a
 [<ffffffff81127033>] ? bdi_writeback_thread+0x0/0x24a
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 sh            S 0000000000000000     0  3360   2469 0x00000080
 ffff88005a24fe58 0000000000000086 ffffffff8104538d ffff880000000000
 ffff88005a24ffd8 ffff880014814500 ffff88005a24ffd8 ffff880014814880
 ffff880014814878 ffff88005a24e000 ffff88005a24e000 0000000000013580
 Call Trace:
 [<ffffffff8104538d>] ? enqueue_task_fair+0x2e6/0x339
 [<ffffffff8104f221>] do_wait+0x1d9/0x24d
 [<ffffffff8104f333>] sys_wait4+0x9e/0xc1
 [<ffffffff8104d90d>] ? child_wait_callback+0x0/0x58
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 qemu-system-x D 7fffffffffffffff     0  3361   3360 0x00000080
 ffff8800224b9bb8 0000000000000086 ffff88005e190000 ffff880014815c00
 ffff8800224b9fd8 ffff880014815c00 ffff8800224b9fd8 ffff880014815f80
 ffff880014815f78 ffff8800224b8000 ffff8800224b8000 0000000000013580
 Call Trace:
 [<ffffffff81439781>] schedule_timeout+0x27/0xc0
 [<ffffffff8103c3d8>] ? need_resched+0x23/0x2d
 [<ffffffff81439581>] ? schedule+0x6aa/0x6c4
 [<ffffffff81438d40>] wait_for_common+0xa3/0x110
 [<ffffffff81046dac>] ? default_wake_function+0x0/0x14
 [<ffffffff81039f4c>] ? synchronize_sched_expedited_cpu_stop+0x0/0x10
 [<ffffffff81438e65>] wait_for_completion+0x1d/0x1f
 [<ffffffff810916fe>] __stop_cpus+0xf6/0x113
 [<ffffffff8109175b>] try_stop_cpus+0x40/0x59
 [<ffffffff81039f4c>] ? synchronize_sched_expedited_cpu_stop+0x0/0x10
 [<ffffffff81040e45>] synchronize_sched_expedited+0x7e/0x97
 [<ffffffff81040dc7>] ? synchronize_sched_expedited+0x0/0x97
 [<ffffffff8106b273>] __synchronize_srcu+0x31/0x70
 [<ffffffff8106b2c7>] synchronize_srcu_expedited+0x15/0x17
 [<ffffffffa03319d9>] kvm_vm_ioctl_get_dirty_log+0x104/0x19b [kvm]
 [<ffffffffa0321d2d>] kvm_vm_ioctl+0x239/0x353 [kvm]
 [<ffffffff8143ae48>] ? _raw_spin_unlock_irqrestore+0x30/0x3b
 [<ffffffff8106ab6a>] ? __hrtimer_start_range_ns+0x310/0x322
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff8106f94a>] ? ktime_get+0x5e/0x98
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff8143ba4a>] ? do_device_not_available+0xe/0x10
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 qemu-system-x S 0000000000000000     0  3370   3360 0x00000080
 ffff88007a011c38 0000000000000086 ffff88007a011bc8 ffffffff00000000
 ffff88007a011fd8 ffff88005e195c00 ffff88007a011fd8 ffff88005e195f80
 ffff88005e195f78 ffff88007a010000 ffff88007a010000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffffa034327c>] ? apic_update_ppr+0x32/0x7f [kvm]
 [<ffffffffa00ef20b>] ? __vmx_load_host_state+0x111/0x11c [kvm_intel]
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffffa032151c>] ? kvm_vcpu_ioctl+0x4aa/0x4ea [kvm]
 [<ffffffff81116523>] ? do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff810c4696>] ? fire_user_return_notifiers+0x3f/0x69
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 qemu-system-x S ffffffffa031fbf9     0  3371   3360 0x00000080
 ffff88007906fcc8 0000000000000086 0000000000000000 ffffffffffffffff
 ffff88007906ffd8 ffff88005e191700 ffff88007906ffd8 ffff88005e191a80
 ffff88005e191a78 ffff88007906e000 ffff88007906e000 0000000000013580
 Call Trace:
 [<ffffffffa031fd57>] kvm_vcpu_block+0x93/0xae [kvm]
 [<ffffffff81066dfb>] ? autoremove_wake_function+0x0/0x39
 [<ffffffffa00f1764>] ? vmx_handle_exit+0x232/0x264 [kvm_intel]
 [<ffffffffa032eeee>] kvm_arch_vcpu_ioctl_run+0xa0f/0xc71 [kvm]
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffffa00f344b>] ? vmx_vcpu_load+0x33/0x172 [kvm_intel]
 [<ffffffffa0321184>] kvm_vcpu_ioctl+0x112/0x4ea [kvm]
 [<ffffffff81116523>] do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff811165c8>] sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 qemu-system-x R  running task        0  3372   3360 0x00000880
 ffff88006929bc78 ffffffff00000000 ffff880017b80000 ffff880017b80000
 0000000000000000 ffffffffff5fc380 ffff88006929bca8 ffffffffa03375f6
 ffff880017b80000 ffffffffff5fc380 000000000000000b 000000008000030e
 Call Trace:
 [<ffffffffa03375f6>] kvm_mmu_page_fault+0x4b/0x77 [kvm]
 [<ffffffffa00f13d7>] handle_exception+0x171/0x2cc [kvm_intel]
 [<ffffffffa034327c>] ? apic_update_ppr+0x32/0x7f [kvm]
 [<ffffffffa00f186c>] ? vmx_vcpu_run+0x96/0x1ac [kvm_intel]
 [<ffffffffa032ee09>] ? kvm_arch_vcpu_ioctl_run+0x92a/0xc71 [kvm]
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffffa00f344b>] ? vmx_vcpu_load+0x33/0x172 [kvm_intel]
 [<ffffffffa0321184>] ? kvm_vcpu_ioctl+0x112/0x4ea [kvm]
 [<ffffffff81116523>] ? do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff811165c8>] ? sys_ioctl+0x56/0x79
 [<ffffffff81009cf2>] ? system_call_fastpath+0x16/0x1b
 qemu-system-x S ffff88007f50f1c0     0  3373   3360 0x00000080
 ffff880077977c38 0000000000000086 ffff880077977bc8 ffffffffffffffff
 ffff880077977fd8 ffff88005e190000 ffff880077977fd8 ffff88005e190380
 ffff88005e190378 ffff880077976000 ffff880077976000 0000000000013580
 Call Trace:
 [<ffffffff81075681>] futex_wait_queue_me+0x87/0x9f
 [<ffffffff810757d1>] futex_wait+0x138/0x2c3
 [<ffffffffa034327c>] ? apic_update_ppr+0x32/0x7f [kvm]
 [<ffffffff8103ce8b>] ? task_rq_unlock+0x11/0x13
 [<ffffffffa00ef20b>] ? __vmx_load_host_state+0x111/0x11c [kvm_intel]
 [<ffffffff810773d9>] do_futex+0x9a/0x860
 [<ffffffffa032151c>] ? kvm_vcpu_ioctl+0x4aa/0x4ea [kvm]
 [<ffffffff81116523>] ? do_vfs_ioctl+0x46a/0x4b9
 [<ffffffff81077cc6>] sys_futex+0x127/0x141
 [<ffffffff810c4696>] ? fire_user_return_notifiers+0x3f/0x69
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 kvm-pit-wq    S 0000000000000000     0  3362      2 0x00000080
 ffff88005e0ede60 0000000000000046 ffff88007f5d3580 ffff880000000000
 ffff88005e0edfd8 ffff88005be19700 ffff88005e0edfd8 ffff88005be19a80
 ffff88005be19a78 ffff88005e0ec000 ffff88005e0ec000 0000000000013580
 Call Trace:
 [<ffffffff81062484>] rescuer_thread+0x1a5/0x1aa
 [<ffffffff810622df>] ? rescuer_thread+0x0/0x1aa
 [<ffffffff81066902>] kthread+0x82/0x8a
 [<ffffffff8100aae4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81066880>] ? kthread+0x0/0x8a
 [<ffffffff8100aae0>] ? kernel_thread_helper+0x0/0x10
 sleep         S 0000000000000000     0  3417   1251 0x00000080
 ffff88005bd49e68 0000000000000086 ffff88005bd49dc8 ffffffff00000000
 ffff88005bd49fd8 ffff88005be1dc00 ffff88005bd49fd8 ffff88005be1df80
 ffff88005be1df78 ffff88005bd48000 ffff88005bd48000 0000000000013580
 Call Trace:
 [<ffffffff81439ff5>] do_nanosleep+0x75/0xb7
 [<ffffffff8106ac5c>] hrtimer_nanosleep+0xb0/0x11d
 [<ffffffff81069eea>] ? hrtimer_wakeup+0x0/0x26
 [<ffffffff8106abaa>] ? hrtimer_start_range_ns+0x14/0x16
 [<ffffffff81098867>] ? audit_syscall_entry+0x11e/0x14a
 [<ffffffff8106ad22>] sys_nanosleep+0x59/0x69
 [<ffffffff81009cf2>] system_call_fastpath+0x16/0x1b
 Sched Debug Version: v0.09, 2.6.36+ #34
 now at 6127331.929107 msecs
  .jiffies                                 : 4300794627
  .sysctl_sched_latency                    : 24.000000
  .sysctl_sched_min_granularity            : 3.000000
  .sysctl_sched_wakeup_granularity         : 4.000000
  .sysctl_sched_child_runs_first           : 0
  .sysctl_sched_features                   : 31855
  .sysctl_sched_tunable_scaling            : 1 (logaritmic)

 cpu#0, 2660.055 MHz
  .nr_running                    : 2
  .load                          : 1024
  .nr_switches                   : 367585120
  .nr_load_updates               : 2823701
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794717
  .curr->pid                     : 4
  .clock                         : 6112404.277207
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 842
  .cpu_load[2]                   : 643
  .cpu_load[3]                   : 531
  .cpu_load[4]                   : 478
  .yld_count                     : 96
  .sched_switch                  : 0
  .sched_count                   : 367593934
  .sched_goidle                  : 183487125
  .avg_idle                      : 14139
  .ttwu_count                    : 183828830
  .ttwu_local                    : 60288
  .bkl_count                     : 0

 cfs_rq[0]:
  .exec_clock                    : 3427951.406584
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 3424836.020475
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : 0.000000
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

 rt_rq[0]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------
 R    kworker/0:0     4   3424836.020475 183681301   120   3424836.020475   3423901.420588   2685682.072677
     migration/0     6       124.991395    297339     0       124.991395         0.001706         0.000000

 cpu#1, 2660.055 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 8237096
  .nr_load_updates               : 523891
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794619
  .curr->pid                     : 0
  .clock                         : 6112403.389317
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 224
  .sched_switch                  : 0
  .sched_count                   : 8257278
  .sched_goidle                  : 3723734
  .avg_idle                      : 915358
  .ttwu_count                    : 4202826
  .ttwu_local                    : 3355584
  .bkl_count                     : 0

 cfs_rq[1]:
  .exec_clock                    : 341879.002271
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 329830.097078
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -3095005.952663
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 3

 rt_rq[1]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------
 Rqemu-system-x86  3371    329830.097078     79054   120    329830.097078     15536.739524    262721.038000

 cpu#2, 2660.055 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 1549643
  .nr_load_updates               : 653413
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794619
  .curr->pid                     : 1596
  .clock                         : 6112393.374517
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 219
  .sched_switch                  : 0
  .sched_count                   : 1773538
  .sched_goidle                  : 731639
  .avg_idle                      : 1000000
  .ttwu_count                    : 777483
  .ttwu_local                    : 188952
  .bkl_count                     : 0

 cfs_rq[2]:
  .exec_clock                    : 523765.802874
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 521576.144535
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -2903259.919699
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 0

 rt_rq[2]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------
 R           bash  1596    521565.344293       192   120    521565.344293        37.790398   5542690.671971

 cpu#3, 2660.055 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 2260658
  .nr_load_updates               : 464910
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794619
  .curr->pid                     : 0
  .clock                         : 6111076.698090
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 375
  .sched_switch                  : 0
  .sched_count                   : 2474753
  .sched_goidle                  : 1114816
  .avg_idle                      : 947021
  .ttwu_count                    : 1130888
  .ttwu_local                    : 526961
  .bkl_count                     : 0

 cfs_rq[3]:
  .exec_clock                    : 358477.223045
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 357104.014391
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -3067732.078847
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 0

 rt_rq[3]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------

 cpu#4, 2660.055 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 1059754
  .nr_load_updates               : 245783
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794621
  .curr->pid                     : 0
  .clock                         : 6112197.718863
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 866
  .sched_switch                  : 0
  .sched_count                   : 1073459
  .sched_goidle                  : 493357
  .avg_idle                      : 1000000
  .ttwu_count                    : 535445
  .ttwu_local                    : 192916
  .bkl_count                     : 0

 cfs_rq[4]:
  .exec_clock                    : 54383.952007
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 53882.247178
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -3370953.874914
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 2

 rt_rq[4]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------

 cpu#5, 2660.055 MHz
  .nr_running                    : 1
  .load                          : 1024
  .nr_switches                   : 5375905
  .nr_load_updates               : 927931
  .nr_uninterruptible            : 1
  .next_balance                  : 4300.794720
  .curr->pid                     : 3372
  .clock                         : 6112404.339340
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 1024
  .cpu_load[2]                   : 1024
  .cpu_load[3]                   : 1024
  .cpu_load[4]                   : 1024
  .yld_count                     : 75
  .sched_switch                  : 0
  .sched_count                   : 5385091
  .sched_goidle                  : 2515995
  .avg_idle                      : 1000000
  .ttwu_count                    : 2810228
  .ttwu_local                    : 1909712
  .bkl_count                     : 0

 cfs_rq[5]:
  .exec_clock                    : 766998.263190
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 759364.561098
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -2665471.575489
  .nr_running                    : 1
  .load                          : 1024
  .nr_spread_over                : 5

 rt_rq[5]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------
 Rqemu-system-x86  3372    759364.561098     23286   120    759364.561098     49699.461327    228580.154535

 cpu#6, 2660.055 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 1221131
  .nr_load_updates               : 492591
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794619
  .curr->pid                     : 0
  .clock                         : 6111761.992260
  .cpu_load[0]                   : 1024
  .cpu_load[1]                   : 512
  .cpu_load[2]                   : 256
  .cpu_load[3]                   : 128
  .cpu_load[4]                   : 64
  .yld_count                     : 882
  .sched_switch                  : 0
  .sched_count                   : 1261732
  .sched_goidle                  : 592047
  .avg_idle                      : 1000000
  .ttwu_count                    : 615417
  .ttwu_local                    : 267776
  .bkl_count                     : 0

 cfs_rq[6]:
  .exec_clock                    : 125402.413319
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 138155.462923
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -3286680.702708
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 3

 rt_rq[6]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------

 cpu#7, 2660.055 MHz
  .nr_running                    : 0
  .load                          : 0
  .nr_switches                   : 2293330
  .nr_load_updates               : 547519
  .nr_uninterruptible            : 0
  .next_balance                  : 4300.794619
  .curr->pid                     : 0
  .clock                         : 6111627.759502
  .cpu_load[0]                   : 0
  .cpu_load[1]                   : 0
  .cpu_load[2]                   : 0
  .cpu_load[3]                   : 0
  .cpu_load[4]                   : 0
  .yld_count                     : 194
  .sched_switch                  : 0
  .sched_count                   : 2306912
  .sched_goidle                  : 1136351
  .avg_idle                      : 1000000
  .ttwu_count                    : 1147579
  .ttwu_local                    : 789619
  .bkl_count                     : 0

 cfs_rq[7]:
  .exec_clock                    : 45096.875353
  .MIN_vruntime                  : 0.000001
  .min_vruntime                  : 50922.066321
  .max_vruntime                  : 0.000001
  .spread                        : 0.000000
  .spread0                       : -3373914.113755
  .nr_running                    : 0
  .load                          : 0
  .nr_spread_over                : 2

 rt_rq[7]:
  .rt_nr_running                 : 0
  .rt_throttled                  : 0
  .rt_time                       : 0.000000
  .rt_runtime                    : 950.000000

 runnable tasks:
            task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
 ----------------------------------------------------------------------------------------------------------

--X1bOJ3K7DJ5YkBrT--
