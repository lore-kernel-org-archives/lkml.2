Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab0CZUWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:22:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:54877 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751937Ab0CZUWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:22:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19QOqYupYBQtllzv14+xFB5zTXWvJApEPrEP8buuf
	QmuQQsRNeNiNB1
Subject: Re: [BUG] perf: hard lockup when using perf-sched
From: Mike Galbraith <efault@gmx.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <20100326192712.GA7166@nowhere>
References: <4BA082EC.8030101@cn.fujitsu.com>
	 <4BA9A885.9050105@cn.fujitsu.com>
	 <1269415964.6530.25.camel@marge.simson.net>
	 <1269418671.6465.6.camel@marge.simson.net>
	 <4BAB1924.4060304@cn.fujitsu.com>
	 <1269509241.8438.30.camel@marge.simson.net>
	 <1269598293.6174.8.camel@marge.simson.net> <20100326172350.GC5188@nowhere>
	 <1269630640.6331.18.camel@marge.simson.net> <20100326192712.GA7166@nowhere>
Content-Type: text/plain
Date: Fri, 26 Mar 2010 21:22:04 +0100
Message-Id: <1269634924.6488.6.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-26 at 20:27 +0100, Frederic Weisbecker wrote: 
> On Fri, Mar 26, 2010 at 08:10:40PM +0100, Mike Galbraith wrote:
> > On Fri, 2010-03-26 at 18:23 +0100, Frederic Weisbecker wrote:
> > > On Fri, Mar 26, 2010 at 11:11:33AM +0100, Mike Galbraith wrote:
> > 
> > > > perf: fix perf sched record forkbomb deadlock
> > > > 
> > > > perf sched record can deadlock a box should the holder of handle->data->lock
> > > > take an interrupt, and then attempt to acquire an rq lock held by a CPU trying
> > > > to acquire the same lock.  Disable interrupts.
> > > 
> > > 
> > > 
> > > Aah.
> > > 
> > > So the scenario is the following inversion?
> > > 
> > > 	CPU0				CPU1
> > > sched event with rq->lock held
> > > 				grab handle->data->lock
> > > spin on handle->data->lock
> > > 				interrupt
> > > 				try to grab rq->lock
> > 
> > Yeah, handle->data->lock holder dare not try to grab any rq lock because
> > of sched event with rq->lock held.
> > 
> 
> 
> But if that happens with perf sched, there is something weird.
> perf sched only use sched events, which have interrupt disabled
> from the trace event handler, so this is not supposed to happen.
> 
> But if there is another kind of event involved, something that has
> interrupts enabled, may be some software events, then it may
> happen indeed.

Hm.  Last trace I took is below.

./forkbomb&
[1] 5990
marge:/root/tmp # perf sched record
[  427.931717] BUG: NMI Watchdog detected LOCKUP on CPU1, ip ffffffff810853f7, registers:
[  427.931717] CPU 1 
[  427.931717] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc snd_pcm_oss snd_mixer_oss exportfs snd_seq snd_seq_device cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm firewire_ohci usbmouse firewire_core snd_timer crc_itu_t snd usbhid usb_storage rtc_cmos hid soundcore ohci1394 usb_libusual rtc_core sr_mod thermal snd_page_alloc ieee1394 i2c_i801 button processor rtc_lib cdrom e1000e sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  427.931717] 
[  427.931717] Pid: 0, comm: swapper Tainted: G        W  2.6.34-smpx #1500 MS-7502/MS-7502
[  427.931717] RIP: 0010:[<ffffffff810853f7>]  [<ffffffff810853f7>] perf_output_lock+0x30/0x5a
[  427.931717] RSP: 0018:ffff880002083910  EFLAGS: 00000082
[  427.931717] RAX: 0000000000000002 RBX: ffff8800020839d0 RCX: ffff8800bc91c000
[  427.931717] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8800020839d0
[  427.931717] RBP: ffff880002083920 R08: 0000000000000001 R09: 0000000000000001
[  427.931717] R10: 0000000000000000 R11: ffff8800bf845940 R12: ffff8800bc91c000
[  427.931717] R13: ffff8800bc36a400 R14: 0000000000000060 R15: 0000000000000001
[  427.931717] FS:  0000000000000000(0000) GS:ffff880002080000(0000) knlGS:0000000000000000
[  427.931717] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  427.931717] CR2: 00007ff8e6f464a8 CR3: 000000000146e000 CR4: 00000000000006e0
[  427.931717] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  427.931717] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  427.931717] Process swapper (pid: 0, threadinfo ffff8800bf888000, task ffff8800bf845940)
[  427.931717] Stack:
[  427.931717]  0000000100000060 00000002ffffffff ffff8800020839c0 ffffffff81089409
[  427.931717] <0> ffffffff810892f9 ffffffff8105a90d ffff880002083970 ffffffff81052cff
[  427.931717] <0> ffff880002083bb0 0000000000000001 ffff880002083a00 ffff880002083bb0
[  427.931717] Call Trace:
[  427.931717]  <IRQ> 
[  427.931717]  [<ffffffff81089409>] perf_output_begin+0x110/0x24d
[  427.931717]  [<ffffffff810892f9>] ? perf_output_begin+0x0/0x24d
[  427.931717]  [<ffffffff8105a90d>] ? trace_hardirqs_off+0xd/0xf
[  427.931717]  [<ffffffff81052cff>] ? cpu_clock+0x2d/0x40
[  427.931717]  [<ffffffff8108a37c>] ? perf_prepare_sample+0xb5/0x1d3
[  427.931717]  [<ffffffff8108a4e2>] perf_event_output+0x48/0x74
[  427.931717]  [<ffffffff8108a655>] __perf_event_overflow+0x147/0x168
[  427.931717]  [<ffffffff8108a6ce>] perf_swevent_overflow+0x58/0x75
[  427.931717]  [<ffffffff8108a731>] perf_swevent_add+0x46/0x48
[  427.931717]  [<ffffffff8108a7a0>] perf_swevent_ctx_event+0x6d/0x95
[  427.931717]  [<ffffffff8108a844>] do_perf_sw_event+0x7c/0x103
[  427.931717]  [<ffffffff8108a8fc>] perf_tp_event+0x31/0x33
[  427.931717]  [<ffffffff81028475>] ? dequeue_task_fair+0x4c/0x10a
[  427.931717]  [<ffffffff810811af>] ? perf_trace_buf_prepare+0x93/0xcf
[  427.931717]  [<ffffffff81025356>] perf_trace_sched_stat_runtime+0xc4/0xf4
[  427.931717]  [<ffffffff81026ed9>] update_curr+0xbb/0x101
[  427.931717]  [<ffffffff81028475>] dequeue_task_fair+0x4c/0x10a
[  427.931717]  [<ffffffff8102a841>] dequeue_task+0x3d/0x4d
[  427.931717]  [<ffffffff8102a879>] deactivate_task+0x28/0x31
[  427.931717]  [<ffffffff81028849>] ? double_rq_lock+0x48/0x4d
[  427.931717]  [<ffffffff8102d433>] pull_task+0x1d/0x69
[  427.931717]  [<ffffffff8102f07b>] load_balance+0x253/0x496
[  427.931717]  [<ffffffff8102f398>] rebalance_domains+0xda/0x150
[  427.931717]  [<ffffffff8102f452>] run_rebalance_domains+0x44/0xd4
[  427.931717]  [<ffffffff81039670>] __do_softirq+0x11d/0x220
[  427.931717]  [<ffffffff81002e0c>] call_softirq+0x1c/0x28
[  427.931717]  [<ffffffff81004b73>] do_softirq+0x38/0x81
[  427.931717]  [<ffffffff8103983a>] irq_exit+0x45/0x87
[  427.931717]  [<ffffffff81016f86>] smp_apic_timer_interrupt+0x88/0x96
[  427.931717]  [<ffffffff810028d3>] apic_timer_interrupt+0x13/0x20
[  427.931717]  <EOI> 
[  427.931717]  [<ffffffff810097d7>] ? mwait_idle+0xd4/0xe9
[  427.931717]  [<ffffffff810097e0>] ? mwait_idle+0xdd/0xe9
[  427.931717]  [<ffffffff810097d7>] ? mwait_idle+0xd4/0xe9
[  427.931717]  [<ffffffff8100073b>] cpu_idle+0x57/0x74
[  427.931717]  [<ffffffff812d695a>] start_secondary+0x1bd/0x1c1
[  427.931717] Code: 83 ec 10 c7 47 28 00 00 00 00 48 8b 4f 08 65 8b 14 25 88 d1 00 00 c7 45 f8 ff ff ff ff 89 55 f4 8b 75 f4 8b 45 f8 f0 0f b1 71 38 <89> 45 fc 8b 45 fc 83 f8 ff 75 10 c7 47 28 01 00 00 00 c7 47 2c 
[  427.931717] ---[ end trace 4ede7d64a7e7ec98 ]---
[  427.931717] BUG: NMI Watchdog detected LOCKUP on CPU2, ip ffffffff811404b9, registers:
[  427.931717] CPU 2 
[  427.931717] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc snd_pcm_oss snd_mixer_oss exportfs snd_seq snd_seq_device cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm firewire_ohci usbmouse firewire_core snd_timer crc_itu_t snd usbhid usb_storage rtc_cmos hid soundcore ohci1394 usb_libusual rtc_core sr_mod thermal snd_page_alloc ieee1394 i2c_i801 button processor rtc_lib cdrom e1000e sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  427.931717] 
[  427.931717] Pid: 5990, comm: forkbomb Tainted: G      D W  2.6.34-smpx #1500 MS-7502/MS-7502
[  427.931717] RIP: 0010:[<ffffffff811404b9>]  [<ffffffff811404b9>] delay_tsc+0x14/0x52
[  427.931717] RSP: 0018:ffff880002103da0  EFLAGS: 00000006
[  427.931717] RAX: 000000007cca47f2 RBX: ffff8800021130c0 RCX: 0000000000002d00
[  427.931717] RDX: 0000000000000102 RSI: 0000000000000002 RDI: 0000000000000001
[  427.931717] RBP: ffff880002103da0 R08: 0000000000000002 R09: 0000000000000001
[  427.931717] R10: 0000000000000000 R11: ffff880002103ee8 R12: ffff8800bbdc8000
[  427.931717] R13: 000000008e9adbdc R14: ffff8800bbdc8360 R15: 000000000432710f
[  427.931717] FS:  00007ff8e711e700(0000) GS:ffff880002100000(0000) knlGS:0000000000000000
[  427.931717] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  427.931717] CR2: 00007ff8e6f47e04 CR3: 000000003736f000 CR4: 00000000000006e0
[  427.931717] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  427.931717] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  427.931717] Process forkbomb (pid: 5990, threadinfo ffff8800bdb70000, task ffff8800bbdc8000)
[  427.931717] Stack:
[  427.931717]  ffff880002103db0 ffffffff811403f4 ffff880002103e00 ffffffff81143e42
[  427.931717] <0> 0000000000000000 ffff880000000001 ffff8800abfa2c00 ffff8800021130c0
[  427.931717] <0> ffff8800021130c0 00000000000130c0 ffff880002103e78 000000000000000f
[  427.931717] Call Trace:
[  427.931717]  <IRQ> 
[  427.931717]  [<ffffffff811403f4>] __delay+0xa/0xc
[  427.931717]  [<ffffffff81143e42>] do_raw_spin_lock+0xd2/0x13c
[  427.931717]  [<ffffffff812dbc18>] _raw_spin_lock+0x34/0x3b
[  427.931717]  [<ffffffff81026e03>] ? task_rq_lock+0x7c/0x97
[  427.931717]  [<ffffffff8105f2b1>] ? trace_hardirqs_on+0xd/0xf
[  427.931717]  [<ffffffff81026e03>] task_rq_lock+0x7c/0x97
[  427.931717]  [<ffffffff8102d4a5>] try_to_wake_up+0x26/0x266
[  427.931717]  [<ffffffff8102d704>] wake_up_process+0x10/0x12
[  427.931717]  [<ffffffff810392f4>] wakeup_softirqd+0x2a/0x2c
[  427.931717]  [<ffffffff81039771>] __do_softirq+0x21e/0x220
[  427.931717]  [<ffffffff8104b6a0>] ? __task_pid_nr_ns+0x0/0xad
[  427.931717]  [<ffffffff81002e0c>] call_softirq+0x1c/0x28
[  427.931717]  [<ffffffff81004b73>] do_softirq+0x38/0x81
[  427.931717]  [<ffffffff8103983a>] irq_exit+0x45/0x87
[  427.931717]  [<ffffffff81016f86>] smp_apic_timer_interrupt+0x88/0x96
[  427.931717]  [<ffffffff810028d3>] apic_timer_interrupt+0x13/0x20
[  427.931717]  <EOI> 
[  427.931717]  [<ffffffff8105eae6>] ? lock_acquire+0x108/0x117
[  427.931717]  [<ffffffff8104b6a0>] ? __task_pid_nr_ns+0x0/0xad
[  427.931717]  [<ffffffff810892f9>] ? perf_output_begin+0x0/0x24d
[  427.931717]  [<ffffffff8104b6dc>] __task_pid_nr_ns+0x3c/0xad
[  427.931717]  [<ffffffff8104b6a0>] ? __task_pid_nr_ns+0x0/0xad
[  427.931717]  [<ffffffff8108668a>] perf_event_tid+0x26/0x28
[  427.931717]  [<ffffffff8108960f>] perf_event_task_output+0x74/0x9f
[  427.931717]  [<ffffffff81089675>] perf_event_task_ctx+0x3b/0x5b
[  427.931717]  [<ffffffff810896e8>] perf_event_task_event+0x53/0xca
[  427.931717]  [<ffffffff81089695>] ? perf_event_task_event+0x0/0xca
[  427.931717]  [<ffffffff810897da>] perf_event_task+0x7b/0x86
[  427.931717]  [<ffffffff8108a90e>] perf_event_fork+0x10/0x12
[  427.931717]  [<ffffffff810328e7>] copy_process+0xf0c/0x1068
[  427.931717]  [<ffffffff81032bdd>] do_fork+0x176/0x31e
[  427.931717]  [<ffffffff8105192a>] ? up_read+0x1e/0x38
[  427.931717]  [<ffffffff812dbaaa>] ? lockdep_sys_exit_thunk+0x35/0x67
[  427.931717]  [<ffffffff81009ed1>] sys_clone+0x23/0x25
[  427.931717]  [<ffffffff81002253>] stub_clone+0x13/0x20
[  427.931717]  [<ffffffff81001f6b>] ? system_call_fastpath+0x16/0x1b
[  427.931717] Code: 81 48 6b 94 0a 98 00 00 00 3e f7 e2 48 8d 7a 01 e8 47 ff ff ff c9 c3 55 48 89 e5 65 8b 34 25 88 d1 00 00 0f 1f 00 0f ae e8 0f 31 <89> c1 0f 1f 00 0f ae e8 0f 31 89 c0 48 89 c2 48 29 ca 48 39 fa 
[  427.931717] ---[ end trace 4ede7d64a7e7ec99 ]---
[  427.931715] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff810853f7, registers:
[  427.931715] CPU 0 
[  427.931715] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc snd_pcm_oss snd_mixer_oss exportfs snd_seq snd_seq_device cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm firewire_ohci usbmouse firewire_core snd_timer crc_itu_t snd usbhid usb_storage rtc_cmos hid soundcore ohci1394 usb_libusual rtc_core sr_mod thermal snd_page_alloc ieee1394 i2c_i801 button processor rtc_lib cdrom e1000e sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  427.931715] 
[  427.931715] Pid: 19553, comm: forkbomb Tainted: G      D W  2.6.34-smpx #1500 MS-7502/MS-7502
[  427.931715] RIP: 0010:[<ffffffff810853f7>]  [<ffffffff810853f7>] perf_output_lock+0x30/0x5a
[  427.931715] RSP: 0018:ffff880002003b18  EFLAGS: 00000082
[  427.931715] RAX: 0000000000000002 RBX: ffff880002003bd8 RCX: ffff8800bc91c000
[  427.931715] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880002003bd8
[  427.931715] RBP: ffff880002003b28 R08: 0000000000000001 R09: 0000000000000001
[  427.931715] R10: 0000000000000001 R11: ffff8800bf35ca60 R12: ffff8800bc91c000
[  427.931715] R13: ffff8800bc36a400 R14: 0000000000000060 R15: 0000000000000001
[  427.931715] FS:  0000000000000000(0000) GS:ffff880002000000(0000) knlGS:0000000000000000
[  427.931715] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  427.931715] CR2: 00007ff8e6f464a8 CR3: 00000000bc892000 CR4: 00000000000006f0
[  427.931715] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  427.931715] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  427.931715] Process forkbomb (pid: 19553, threadinfo ffff8800bcc58000, task ffff8800bf35ca60)
[  427.931715] Stack:
[  427.931715]  0000000000000060 00000002ffffffff ffff880002003bc8 ffffffff81089409
[  427.931715] <0> ffffffff810892f9 ffffffff8105a90d ffff880002003b78 ffffffff81052cff
[  427.931715] <0> ffff880002003db8 0000000000000000 ffff880002003c08 ffff880002003db8
[  427.931715] Call Trace:
[  427.931715]  <IRQ> 
[  427.931715]  [<ffffffff81089409>] perf_output_begin+0x110/0x24d
[  427.931715]  [<ffffffff810892f9>] ? perf_output_begin+0x0/0x24d
[  427.931715]  [<ffffffff8105a90d>] ? trace_hardirqs_off+0xd/0xf
[  427.931715]  [<ffffffff81052cff>] ? cpu_clock+0x2d/0x40
[  427.931715]  [<ffffffff8108a37c>] ? perf_prepare_sample+0xb5/0x1d3
[  427.931715]  [<ffffffff8108a4e2>] perf_event_output+0x48/0x74
[  427.931715]  [<ffffffffa014ac59>] ? uhci_urb_enqueue+0x87f/0x8a5 [uhci_hcd]
[  427.931715]  [<ffffffff8108a655>] __perf_event_overflow+0x147/0x168
[  427.931715]  [<ffffffff8108a6ce>] perf_swevent_overflow+0x58/0x75
[  427.931715]  [<ffffffff8108a731>] perf_swevent_add+0x46/0x48
[  427.931715]  [<ffffffff8108a7a0>] perf_swevent_ctx_event+0x6d/0x95
[  427.931715]  [<ffffffff8108a844>] do_perf_sw_event+0x7c/0x103
[  427.931715]  [<ffffffff812dbc18>] ? _raw_spin_lock+0x34/0x3b
[  427.931715]  [<ffffffff8108a8fc>] perf_tp_event+0x31/0x33
[  427.931715]  [<ffffffff81027075>] ? task_tick_fair+0x4a/0x110
[  427.931715]  [<ffffffff810811af>] ? perf_trace_buf_prepare+0x93/0xcf
[  427.931715]  [<ffffffff81025356>] perf_trace_sched_stat_runtime+0xc4/0xf4
[  427.931715]  [<ffffffff81026ed9>] update_curr+0xbb/0x101
[  427.931715]  [<ffffffff81027075>] task_tick_fair+0x4a/0x110
[  427.931715]  [<ffffffff8102fe9f>] scheduler_tick+0xdc/0x1f0
[  427.931715]  [<ffffffff810417da>] update_process_times+0x4b/0x5b
[  427.931715]  [<ffffffff810584a3>] tick_periodic+0x63/0x65
[  427.931715]  [<ffffffff81058508>] tick_handle_periodic+0x21/0x6e
[  427.931715]  [<ffffffff81016f81>] smp_apic_timer_interrupt+0x83/0x96
[  427.931715]  [<ffffffff810028d3>] apic_timer_interrupt+0x13/0x20
[  427.931715]  <EOI> 
[  427.931715]  [<ffffffff810a1b01>] ? unmap_vmas+0x2bd/0x766
[  427.931715]  [<ffffffff810a1fa5>] ? unmap_vmas+0x761/0x766
[  427.931715]  [<ffffffff81092113>] ? __alloc_pages_nodemask+0x120/0x63e
[  427.931715]  [<ffffffff810a6b12>] exit_mmap+0xb3/0x139
[  427.931715]  [<ffffffff8103122e>] mmput+0x30/0xd7
[  427.931715]  [<ffffffff81035272>] exit_mm+0x101/0x10e
[  427.931715]  [<ffffffff8106b226>] ? acct_collect+0x174/0x181
[  427.931715]  [<ffffffff810368b2>] do_exit+0x1bc/0x69f
[  427.931715]  [<ffffffff812dbaaa>] ? lockdep_sys_exit_thunk+0x35/0x67
[  427.931715]  [<ffffffff810a16b2>] ? do_wp_page+0x4b3/0x645
[  427.931715]  [<ffffffff8103701b>] do_group_exit+0x72/0x9b
[  427.931715]  [<ffffffff81037056>] sys_exit_group+0x12/0x16
[  427.931715]  [<ffffffff81001f6b>] system_call_fastpath+0x16/0x1b
[  427.931715] Code: 83 ec 10 c7 47 28 00 00 00 00 48 8b 4f 08 65 8b 14 25 88 d1 00 00 c7 45 f8 ff ff ff ff 89 55 f4 8b 75 f4 8b 45 f8 f0 0f b1 71 38 <89> 45 fc 8b 45 fc 83 f8 ff 75 10 c7 47 28 01 00 00 00 c7 47 2c 
[  427.931715] ---[ end trace 4ede7d64a7e7ec9a ]---
[  433.367734] BUG: NMI Watchdog detected LOCKUP on CPU3, ip ffffffff810853f7, registers:
[  433.367734] CPU 3 
[  433.367734] Modules linked in: nfsd lockd nfs_acl auth_rpcgss sunrpc snd_pcm_oss snd_mixer_oss exportfs snd_seq snd_seq_device cpufreq_conservative microcode cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm firewire_ohci usbmouse firewire_core snd_timer crc_itu_t snd usbhid usb_storage rtc_cmos hid soundcore ohci1394 usb_libusual rtc_core sr_mod thermal snd_page_alloc ieee1394 i2c_i801 button processor rtc_lib cdrom e1000e sg uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  433.367734] 
[  433.367734] Pid: 0, comm: swapper Tainted: G      D W  2.6.34-smpx #1500 MS-7502/MS-7502
[  433.367734] RIP: 0010:[<ffffffff810853f7>]  [<ffffffff810853f7>] perf_output_lock+0x30/0x5a
[  433.367734] RSP: 0018:ffff880002183958  EFLAGS: 00000082
[  433.367734] RAX: 0000000000000002 RBX: ffff880002183a18 RCX: ffff8800bc91c000
[  433.367734] RDX: 0000000000000003 RSI: 0000000000000003 RDI: ffff880002183a18
[  433.367734] RBP: ffff880002183968 R08: 0000000000000001 R09: 0000000000000001
[  433.367734] R10: ffff8800bf8a5e48 R11: ffff8800bc91c000 R12: ffff8800bc91c000
[  433.367734] R13: ffff8800bc36a400 R14: 0000000000000058 R15: 0000000000000001
[  433.367734] FS:  0000000000000000(0000) GS:ffff880002180000(0000) knlGS:0000000000000000
[  433.367734] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  433.367734] CR2: 00007ff8e6f464a8 CR3: 000000000146e000 CR4: 00000000000006e0
[  433.367734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  433.367734] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  433.367734] Process swapper (pid: 0, threadinfo ffff8800bf8a4000, task ffff8800bf893b80)
[  433.367734] Stack:
[  433.367734]  0000000300000058 00000002ffffffff ffff880002183a08 ffffffff81089409
[  433.367734] <0> ffffffff810892f9 ffffffff8105a90d ffff8800021839b8 ffffffff81052cff
[  433.367734] <0> ffff880002183bf8 0000000000000003 ffff880002183a48 ffff880002183bf8
[  433.367734] Call Trace:
[  433.367734]  <IRQ> 
[  433.367734]  [<ffffffff81089409>] perf_output_begin+0x110/0x24d
[  433.367734]  [<ffffffff810892f9>] ? perf_output_begin+0x0/0x24d
[  433.367734]  [<ffffffff8105a90d>] ? trace_hardirqs_off+0xd/0xf
[  433.367734]  [<ffffffff81052cff>] ? cpu_clock+0x2d/0x40
[  433.367734]  [<ffffffff8108a37c>] ? perf_prepare_sample+0xb5/0x1d3
[  433.367734]  [<ffffffff8108a4e2>] perf_event_output+0x48/0x74
[  433.367734]  [<ffffffff8108a655>] __perf_event_overflow+0x147/0x168
[  433.367734]  [<ffffffff810892f9>] ? perf_output_begin+0x0/0x24d
[  433.367734]  [<ffffffff8108a6ce>] perf_swevent_overflow+0x58/0x75
[  433.367734]  [<ffffffff8108a731>] perf_swevent_add+0x46/0x48
[  433.367734]  [<ffffffff8108a7a0>] perf_swevent_ctx_event+0x6d/0x95
[  433.367734]  [<ffffffff8108a844>] do_perf_sw_event+0x7c/0x103
[  433.367734]  [<ffffffff8108a8fc>] perf_tp_event+0x31/0x33
[  433.367734]  [<ffffffff8102d61d>] ? try_to_wake_up+0x19e/0x266
[  433.367734]  [<ffffffff810811af>] ? perf_trace_buf_prepare+0x93/0xcf
[  433.367734]  [<ffffffff81024bf1>] perf_trace_templ_sched_wakeup_template+0xca/0xf8
[  433.367734]  [<ffffffff81024c2e>] perf_trace_sched_wakeup+0xf/0x11
[  433.367734]  [<ffffffff8102d61d>] try_to_wake_up+0x19e/0x266
[  433.367734]  [<ffffffff81050847>] ? hrtimer_wakeup+0x0/0x21
[  433.367734]  [<ffffffff8102d704>] wake_up_process+0x10/0x12
[  433.367734]  [<ffffffff81050864>] hrtimer_wakeup+0x1d/0x21
[  433.367734]  [<ffffffff8105097d>] __run_hrtimer+0x115/0x1a5
[  433.367734]  [<ffffffff81051593>] hrtimer_run_queues+0x126/0x15c
[  433.367734]  [<ffffffff81041783>] run_local_timers+0x9/0x15
[  433.367734]  [<ffffffff810417c0>] update_process_times+0x31/0x5b
[  433.367734]  [<ffffffff810584a3>] tick_periodic+0x63/0x65
[  433.367734]  [<ffffffff81058508>] tick_handle_periodic+0x21/0x6e
[  433.367734]  [<ffffffff8105897f>] tick_do_broadcast+0x3b/0x6d
[  433.367734]  [<ffffffff810589e5>] tick_do_periodic_broadcast+0x34/0x42
[  433.367734]  [<ffffffff81058b07>] tick_handle_periodic_broadcast+0xf/0x46
[  433.367734]  [<ffffffff81005231>] timer_interrupt+0x19/0x20
[  433.367734]  [<ffffffff8106d61f>] handle_IRQ_event+0x83/0x176
[  433.367734]  [<ffffffff8106f4dd>] handle_edge_irq+0xee/0x136
[  433.367734]  [<ffffffff81004b33>] handle_irq+0x1f/0x27
[  433.367734]  [<ffffffff81004837>] do_IRQ+0x57/0xbe
[  433.367734]  [<ffffffff812dc553>] ret_from_intr+0x0/0xf
[  433.367734]  <EOI> 
[  433.367734]  [<ffffffff810097d7>] ? mwait_idle+0xd4/0xe9
[  433.367734]  [<ffffffff810097e0>] ? mwait_idle+0xdd/0xe9
[  433.367734]  [<ffffffff810097d7>] ? mwait_idle+0xd4/0xe9
[  433.367734]  [<ffffffff8100073b>] cpu_idle+0x57/0x74
[  433.367734]  [<ffffffff812d695a>] start_secondary+0x1bd/0x1c1
[  433.367734] Code: 83 ec 10 c7 47 28 00 00 00 00 48 8b 4f 08 65 8b 14 25 88 d1 00 00 c7 45 f8 ff ff ff ff 89 55 f4 8b 75 f4 8b 45 f8 f0 0f b1 71 38 <89> 45 fc 8b 45 fc 83 f8 ff 75 10 c7 47 28 01 00 00 00 c7 47 2c 
[  433.367734] ---[ end trace 4ede7d64a7e7ec9b ]---
[  433.367734] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  433.367734] Pid: 0, comm: swapper Tainted: G      D W  2.6.34-smpx #1500
[  433.367734] Call Trace:
[  433.367734]  <NMI>  [<ffffffff812d90dd>] panic+0x73/0xe6
[  433.367734]  [<ffffffff8105200c>] ? notifier_call_chain+0x32/0x5e
[  433.367734]  [<ffffffff81052129>] ? __atomic_notifier_call_chain+0x74/0x86
[  433.367734]  [<ffffffff810520b5>] ? __atomic_notifier_call_chain+0x0/0x86
[  433.367734]  [<ffffffff8105214a>] ? atomic_notifier_call_chain+0xf/0x11
[  433.367734]  [<ffffffff81052537>] ? notify_die+0x2e/0x33
[  433.367734]  [<ffffffff81017d89>] ? nmi_watchdog_tick+0x41/0x1a3
[  433.367734]  [<ffffffff81003931>] ? do_nmi+0x24a/0x274
[  433.367734]  [<ffffffff811cf234>] ? serial8250_console_putchar+0x0/0x27
[  433.367734]  [<ffffffff812dcaea>] ? nmi+0x1a/0x2c
[  433.367734]  [<ffffffff811cf234>] ? serial8250_console_putchar+0x0/0x27
[  433.367734]  [<ffffffff811404c1>] ? delay_tsc+0x1c/0x52
[  433.367734]  <<EOE>> 

