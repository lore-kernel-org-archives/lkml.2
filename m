Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab0CXHcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 03:32:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:35938 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754974Ab0CXHcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 03:32:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Csq5sysFCHuziuDaYz/JzIb9NYK9ZguQcXJcEIG
	IoHCIsSj0IKXe8
Subject: Re: [BUG] perf: hard lockup when using perf-sched
From: Mike Galbraith <efault@gmx.de>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4BA9A885.9050105@cn.fujitsu.com>
References: <4BA082EC.8030101@cn.fujitsu.com>
	 <4BA9A885.9050105@cn.fujitsu.com>
Content-Type: text/plain
Date: Wed, 24 Mar 2010 08:32:44 +0100
Message-Id: <1269415964.6530.25.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 13:52 +0800, Li Zefan wrote:
> Anyone have a look at this bug ?
> 
> Li Zefan wrote:
> > An idea came to me that running perf-sched with a fork "bomb" might
> > reveal some bug.
> > 
> > So I wrote a program (attached), and did the following test:
> > 
> > # gcc fork.c
> > # ./a.out &
> > # perf sched record
> > 
> > After a few seconds, the machine froze, without printing any message.
> > 
> > I've tried the test both on v2.6.34-rc1 and v2.6.34-rc1-tip+.
> > 
> > I'll send you any other information you need.

I just saw this, hunted down your testcase and tried it here.  Looks
like perf_output_lock() wedged box.

[  212.439223] BUG: NMI Watchdog detected LOCKUP on CPU2, ip ffffffff81078ca2, registers:
[  212.439223] CPU 2 
[  212.439223] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer firewire_ohci firewire_core crc_itu_t usb_storage snd ohci1394 soundcore snd_page_alloc usb_libusual rtc_cmos ieee1394 thermal button processor rtc_core sr_mod rtc_lib e1000e i2c_i801 cdrom sg usbhid hid uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  212.439223] 
[  212.439223] Pid: 0, comm: swapper Not tainted 2.6.34-smpx #1475 MS-7502/MS-7502
[  212.439223] RIP: 0010:[<ffffffff81078ca2>]  [<ffffffff81078ca2>] perf_output_begin+0x81/0x191
[  212.439223] RSP: 0018:ffff880001703af0  EFLAGS: 00000086
[  212.439223] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000002
[  212.439223] RDX: 0000000000000058 RSI: ffff88003715c000 RDI: ffff880001703b40
[  212.439223] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8800bb81fc00
[  212.439223] R10: 0000000000000200 R11: 0000000000000000 R12: 0000000000000001
[  212.439223] R13: ffff88000170f9e0 R14: ffff880001703c90 R15: ffff880001703b70
[  212.439223] FS:  0000000000000000(0000) GS:ffff880001700000(0000) knlGS:0000000000000000
[  212.439223] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  212.439223] CR2: 00007f1b2e3aa4a8 CR3: 0000000001420000 CR4: 00000000000006e0
[  212.439223] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  212.439223] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  212.439223] Process swapper (pid: 0, threadinfo ffff8800bf892000, task ffff8800bf843450)
[  212.439223] Stack:
[  212.439223]  ffff880001703b70 ffffffff810797a3 ffff8800bf843450 ffff880000000000
[  212.439223] <0> 00000000ffffffff 0000000000000002 ffff88000170f9e0 ffff8800bfb1c800
[  212.439223] <0> 0000000000000000 ffffffff81079a14 ffff8800bb81fc00 ffff88003715c000
[  212.439223] Call Trace:
[  212.439223]  <IRQ> 
[  212.439223]  [<ffffffff810797a3>] ? perf_prepare_sample+0xa6/0x1ba
[  212.439223]  [<ffffffff81079a14>] ? __perf_event_overflow+0x15d/0x199
[  212.439223]  [<ffffffff81079a9e>] ? perf_swevent_overflow+0x4e/0x68
[  212.439223]  [<ffffffff81079be1>] ? perf_swevent_ctx_event+0xda/0xeb
[  212.439223]  [<ffffffff81079c3b>] ? do_perf_sw_event+0x49/0x85
[  212.439223]  [<ffffffff81079ca8>] ? perf_tp_event+0x31/0x36
[  212.439223]  [<ffffffff81023332>] ? perf_trace_templ_sched_wakeup_template+0xbe/0xd1
[  212.439223]  [<ffffffff8102b366>] ? try_to_wake_up+0x160/0x21f
[  212.439223]  [<ffffffff8102cde5>] ? load_balance+0x3b8/0x467
[  212.439223]  [<ffffffff8110cad1>] ? __blk_run_queue+0x77/0x133
[  212.439223]  [<ffffffffa00056e7>] ? scsi_run_queue+0x2d0/0x367 [scsi_mod]
[  212.439223]  [<ffffffff8102cf6a>] ? rebalance_domains+0xd6/0x144
[  212.439223]  [<ffffffff8102d013>] ? run_rebalance_domains+0x3b/0xc6
[  212.439223]  [<ffffffff81036270>] ? __do_softirq+0xd6/0x193
[  212.439223]  [<ffffffff810791cb>] ? perf_ctx_adjust_freq+0x10/0xec
[  212.439223]  [<ffffffff81002d0c>] ? call_softirq+0x1c/0x28
[  212.439223]  [<ffffffff81004942>] ? do_softirq+0x31/0x67
[  212.439223]  [<ffffffff810363bb>] ? irq_exit+0x36/0x7f
[  212.439223]  [<ffffffff81015e92>] ? smp_apic_timer_interrupt+0x87/0x97
[  212.439223]  [<ffffffff810027d3>] ? apic_timer_interrupt+0x13/0x20
[  212.439223]  <EOI> 
[  212.439223]  [<ffffffff810090b1>] ? mwait_idle+0x9a/0x9f
[  212.439223]  [<ffffffff81000747>] ? cpu_idle+0x4f/0x6b
[  212.439223] Code: c7 47 28 00 00 00 00 0f 45 d0 65 8b 0c 25 58 d1 00 00 c7 44 24 20 ff ff ff ff 89 4c 24 28 8b 5c 24 28 8b 44 24 20 f0 0f b1 5e 38 <89> 44 24 18 8b 44 24 18 83 f8 ff 75 09 c7 47 28 01 00 00 00 eb 
[  212.439223] ---[ end trace f8a4ceb8268dbe33 ]---
[  212.439228] BUG: NMI Watchdog detected LOCKUP on CPU1, ip ffffffff81078ca2, registers:
[  212.439228] CPU 1 
[  212.439228] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer firewire_ohci firewire_core crc_itu_t usb_storage snd ohci1394 soundcore snd_page_alloc usb_libusual rtc_cmos ieee1394 thermal button processor rtc_core sr_mod rtc_lib e1000e i2c_i801 cdrom sg usbhid hid uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  212.439228] 
[  212.439228] Pid: 9149, comm: forkbomb Tainted: G      D    2.6.34-smpx #1475 MS-7502/MS-7502
[  212.439228] RIP: 0010:[<ffffffff81078ca2>]  [<ffffffff81078ca2>] perf_output_begin+0x81/0x191
[  212.439228] RSP: 0018:ffff880001683c68  EFLAGS: 00000086
[  212.439228] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000001
[  212.439228] RDX: 0000000000000060 RSI: ffff88003715c000 RDI: ffff880001683cb8
[  212.439228] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8800bb81fc00
[  212.439228] R10: dead000000100100 R11: 0000000000000000 R12: 0000000000000001
[  212.439228] R13: ffff88000168f9e0 R14: ffff880001683e08 R15: ffff880001683ce8
[  212.439228] FS:  00007f1b2e582700(0000) GS:ffff880001680000(0000) knlGS:0000000000000000
[  212.439228] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  212.439228] CR2: 00007f1b2e3abe04 CR3: 00000000bc5a7000 CR4: 00000000000006e0
[  212.439228] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  212.439228] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  212.439228] Process forkbomb (pid: 9149, threadinfo ffff8800b839a000, task ffff8800b9719170)
[  212.439228] Stack:
[  212.439228]  ffff880001683ce8 ffffffff810797a3 ffffffff81079a31 ffff880000000000
[  212.439228] <0> 00000000ffffffff 0000000000000001 ffff88000168f9e0 ffff8800ba313000
[  212.439228] <0> 0000000000000000 ffffffff81079a14 ffff8800bb81fc00 ffff88003715c000
[  212.439228] Call Trace:
[  212.439228]  <IRQ> 
[  212.439228]  [<ffffffff810797a3>] ? perf_prepare_sample+0xa6/0x1ba
[  212.439228]  [<ffffffff81079a31>] ? __perf_event_overflow+0x17a/0x199
[  212.439228]  [<ffffffff81079a14>] ? __perf_event_overflow+0x15d/0x199
[  212.439228]  [<ffffffff81079a9e>] ? perf_swevent_overflow+0x4e/0x68
[  212.439228]  [<ffffffff81079a9e>] ? perf_swevent_overflow+0x4e/0x68
[  212.439228]  [<ffffffff81079be1>] ? perf_swevent_ctx_event+0xda/0xeb
[  212.439228]  [<ffffffff81079c3b>] ? do_perf_sw_event+0x49/0x85
[  212.439228]  [<ffffffff81079c3b>] ? do_perf_sw_event+0x49/0x85
[  212.439228]  [<ffffffff81079ca8>] ? perf_tp_event+0x31/0x36
[  212.439228]  [<ffffffff81079ca8>] ? perf_tp_event+0x31/0x36
[  212.439228]  [<ffffffff810239ab>] ? perf_trace_sched_stat_runtime+0xbb/0xd0
[  212.439228]  [<ffffffff8102539e>] ? update_curr+0x86/0xca
[  212.439228]  [<ffffffff81025522>] ? task_tick_fair+0x3d/0x107
[  212.439228]  [<ffffffff8102dba2>] ? scheduler_tick+0xd0/0x1d8
[  212.439228]  [<ffffffff8103d7dd>] ? update_process_times+0x40/0x4c
[  212.439228]  [<ffffffff81051e1d>] ? tick_handle_periodic+0x18/0x5f
[  212.439228]  [<ffffffff81015e8d>] ? smp_apic_timer_interrupt+0x82/0x97
[  212.439228]  [<ffffffff810027d3>] ? apic_timer_interrupt+0x13/0x20
[  212.439228]  <EOI> 
[  212.439228]  [<ffffffff811212b7>] ? clear_page_c+0x7/0x10
[  212.439228]  [<ffffffff81080c11>] ? get_page_from_freelist+0x373/0x3fc
[  212.439228]  [<ffffffff81080da9>] ? __alloc_pages_nodemask+0x10f/0x601
[  212.439228]  [<ffffffff8104c9b0>] ? sched_clock_local+0x10/0x75
[  212.439228]  [<ffffffff81080c11>] ? get_page_from_freelist+0x373/0x3fc
[  212.439228]  [<ffffffff810812ad>] ? __get_free_pages+0x12/0x52
[  212.439228]  [<ffffffff810905a7>] ? __pmd_alloc+0x14/0x71
[  212.439228]  [<ffffffff81091cfa>] ? copy_page_range+0x22a/0x6c4
[  212.439228]  [<ffffffff81079c3b>] ? do_perf_sw_event+0x49/0x85
[  212.439228]  [<ffffffff8102f17a>] ? dup_mm+0x2c0/0x44c
[  212.439228]  [<ffffffff8102faae>] ? copy_process+0x762/0xe05
[  212.439228]  [<ffffffff81090c6a>] ? handle_mm_fault+0x666/0x6ad
[  212.439228]  [<ffffffff810302cd>] ? do_fork+0x155/0x2ac
[  212.439228]  [<ffffffff8101c1da>] ? do_page_fault+0x264/0x282
[  212.439228]  [<ffffffff81002153>] ? stub_clone+0x13/0x20
[  212.439228]  [<ffffffff81001eeb>] ? system_call_fastpath+0x16/0x1b
[  212.439228] Code: c7 47 28 00 00 00 00 0f 45 d0 65 8b 0c 25 58 d1 00 00 c7 44 24 20 ff ff ff ff 89 4c 24 28 8b 5c 24 28 8b 44 24 20 f0 0f b1 5e 38 <89> 44 24 18 8b 44 24 18 83 f8 ff 75 09 c7 47 28 01 00 00 00 eb 
[  212.439228] ---[ end trace f8a4ceb8268dbe34 ]---
[  212.439219] BUG: NMI Watchdog detected LOCKUP on CPU3, ip ffffffff81078ca2, registers:
[  212.439219] CPU 3 
[  212.439219] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer firewire_ohci firewire_core crc_itu_t usb_storage snd ohci1394 soundcore snd_page_alloc usb_libusual rtc_cmos ieee1394 thermal button processor rtc_core sr_mod rtc_lib e1000e i2c_i801 cdrom sg usbhid hid uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  212.439219] 
[  212.439219] Pid: 7184, comm: forkbomb Tainted: G      D    2.6.34-smpx #1475 MS-7502/MS-7502
[  212.439219] RIP: 0010:[<ffffffff81078ca2>]  [<ffffffff81078ca2>] perf_output_begin+0x81/0x191
[  212.439219] RSP: 0000:ffff880001783b70  EFLAGS: 00000086
[  212.439219] RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000003
[  212.439219] RDX: 0000000000000060 RSI: ffff88003715c000 RDI: ffff880001783bc0
[  212.439219] RBP: 0000000000000000 R08: 0000000000000001 R09: ffff8800bb81fc00
[  212.439219] R10: 0000000000000034 R11: 0000000000000000 R12: 0000000000000001
[  212.439219] R13: ffff88000178f9e0 R14: ffff880001783d10 R15: ffff880001783bf0
[  212.439219] FS:  00007f1b2e582700(0000) GS:ffff880001780000(0000) knlGS:0000000000000000
[  212.439219] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  212.439219] CR2: 00007f1b2e5cf980 CR3: 00000000bb914000 CR4: 00000000000006e0
[  212.439219] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  212.439219] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  212.439219] Process forkbomb (pid: 7184, threadinfo ffff8800bbdb4000, task ffff8800b0097440)
[  212.439219] Stack:
[  212.439219]  ffff880001783bf0 ffffffff810797a3 ffffffff810796f2 ffff880000000000
[  212.439219] <0> 00000000ffffffff 0000000000000003 ffff88000178f9e0 ffff8800b0e00000
[  212.439219] <0> 0000000000000000 ffffffff81079a14 ffff8800bb81fc00 ffff88003715c000
[  212.439219] Call Trace:
[  212.439219]  <IRQ> 
[  212.439219]  [<ffffffff810797a3>] ? perf_prepare_sample+0xa6/0x1ba
[  212.439219]  [<ffffffff810796f2>] ? perf_output_sample+0x16f/0x17a
[  212.439219]  [<ffffffff81079a14>] ? __perf_event_overflow+0x15d/0x199
[  212.439219]  [<ffffffff81079a9e>] ? perf_swevent_overflow+0x4e/0x68
[  212.439219]  [<ffffffff81079be1>] ? perf_swevent_ctx_event+0xda/0xeb
[  212.439219]  [<ffffffff81079be1>] ? perf_swevent_ctx_event+0xda/0xeb
[  212.439219]  [<ffffffff81079c3b>] ? do_perf_sw_event+0x49/0x85
[  212.439219]  [<ffffffff81079ca8>] ? perf_tp_event+0x31/0x36
[  212.439219]  [<ffffffff810239ab>] ? perf_trace_sched_stat_runtime+0xbb/0xd0
[  212.439219]  [<ffffffff8102539e>] ? update_curr+0x86/0xca
[  212.439219]  [<ffffffff8102695b>] ? enqueue_task_fair+0x82/0x180
[  212.439219]  [<ffffffff81028b04>] ? enqueue_task+0x42/0x52
[  212.439219]  [<ffffffff81028b36>] ? activate_task+0x22/0x28
[  212.439219]  [<ffffffff8102b344>] ? try_to_wake_up+0x13e/0x21f
[  212.439219]  [<ffffffff8103632b>] ? __do_softirq+0x191/0x193
[  212.439219]  [<ffffffff81052413>] ? tick_handle_periodic_broadcast+0xe/0x44
[  212.439219]  [<ffffffff810362e4>] ? __do_softirq+0x14a/0x193
[  212.439219]  [<ffffffff8105f82b>] ? handle_IRQ_event+0x53/0x102
[  212.439219]  [<ffffffff81002d0c>] ? call_softirq+0x1c/0x28
[  212.439219]  [<ffffffff81004942>] ? do_softirq+0x31/0x67
[  212.439219]  [<ffffffff810363bb>] ? irq_exit+0x36/0x7f
[  212.439219]  [<ffffffff8100469e>] ? do_IRQ+0xa3/0xbc
[  212.439219]  [<ffffffff812a3dd3>] ? ret_from_intr+0x0/0xa
[  212.439219]  <EOI> 
[  212.439219]  [<ffffffff8101bff4>] ? do_page_fault+0x7e/0x282
[  212.439219]  [<ffffffff8101c1da>] ? do_page_fault+0x264/0x282
[  212.439219]  [<ffffffff81121b6d>] ? __put_user_4+0x1d/0x30
[  212.439219]  [<ffffffff812a3fdf>] ? page_fault+0x1f/0x30
[  212.439219] Code: c7 47 28 00 00 00 00 0f 45 d0 65 8b 0c 25 58 d1 00 00 c7 44 24 20 ff ff ff ff 89 4c 24 28 8b 5c 24 28 8b 44 24 20 f0 0f b1 5e 38 <89> 44 24 18 8b 44 24 18 83 f8 ff 75 09 c7 47 28 01 00 00 00 eb 
[  212.439219] ---[ end trace f8a4ceb8268dbe35 ]---
[  212.439228] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff812a3a29, registers:
[  212.439228] CPU 0 
[  212.439228] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer firewire_ohci firewire_core crc_itu_t usb_storage snd ohci1394 soundcore snd_page_alloc usb_libusual rtc_cmos ieee1394 thermal button processor rtc_core sr_mod rtc_lib e1000e i2c_i801 cdrom sg usbhid hid uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  212.439228] 
[  212.439228] Pid: 7183, comm: forkbomb Tainted: G      D    2.6.34-smpx #1475 MS-7502/MS-7502
[  212.439228] RIP: 0010:[<ffffffff812a3a29>]  [<ffffffff812a3a29>] _raw_spin_lock+0x10/0x15
[  212.439228] RSP: 0018:ffff880001603e68  EFLAGS: 00000097
[  212.439228] RAX: 0000000000000504 RBX: ffff8800bf841170 RCX: ffffffffffffd809
[  212.439228] RDX: 0000000000000000 RSI: ffff880001603ea8 RDI: ffff880001612e40
[  212.439228] RBP: ffff880001612e40 R08: 00000000242d7b68 R09: 0000000000000034
[  212.439228] R10: 0000000000000034 R11: ffff88003715c000 R12: 0000000000012e40
[  212.439228] R13: ffff880001603ea8 R14: 0000000000000000 R15: 000000000000e200
[  212.439228] FS:  0000000000000000(0000) GS:ffff880001600000(0000) knlGS:0000000000000000
[  212.439228] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  212.439228] CR2: 00007f1b2e3aa4a8 CR3: 0000000001420000 CR4: 00000000000006f0
[  212.439228] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  212.439228] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  212.439228] Process forkbomb (pid: 7183, threadinfo ffff8800b774a000, task ffff8800b0097a10)
[  212.439228] Stack:
[  212.439228]  ffffffff810252fe ffffffff81432580 ffff8800bf841170 0000000000000000
[  212.439228] <0> 000000000000000f 0000000000000100 ffffffff8102b227 ffff8800b774bfd8
[  212.439228] <0> 0000000000000083 ffffffff8140c0c8 ffff8800b774bfd8 0000000000000009
[  212.439228] Call Trace:
[  212.439228]  <IRQ> 
[  212.439228]  [<ffffffff810252fe>] ? task_rq_lock+0x7a/0x94
[  212.439228]  [<ffffffff8102b227>] ? try_to_wake_up+0x21/0x21f
[  212.439228]  [<ffffffff8103632b>] ? __do_softirq+0x191/0x193
[  212.439228]  [<ffffffff810791cb>] ? perf_ctx_adjust_freq+0x10/0xec
[  212.439228]  [<ffffffff81002d0c>] ? call_softirq+0x1c/0x28
[  212.439228]  [<ffffffff81004942>] ? do_softirq+0x31/0x67
[  212.439228]  [<ffffffff810363bb>] ? irq_exit+0x36/0x7f
[  212.439228]  [<ffffffff81015e92>] ? smp_apic_timer_interrupt+0x87/0x97
[  212.439228]  [<ffffffff810027d3>] ? apic_timer_interrupt+0x13/0x20
[  212.439228]  <EOI> 
[  212.439228]  [<ffffffff810788dc>] ? perf_output_unlock+0x3d/0x12e
[  212.439228]  [<ffffffff81078ea2>] ? perf_event_task_ctx+0xb1/0x101
[  212.439228]  [<ffffffff81078f81>] ? perf_event_task+0x8f/0xbd
[  212.439228]  [<ffffffff81033a03>] ? do_exit+0x261/0x664
[  212.439228]  [<ffffffff8101c1da>] ? do_page_fault+0x264/0x282
[  212.439228]  [<ffffffff81121b6d>] ? __put_user_4+0x1d/0x30
[  212.439228]  [<ffffffff81034083>] ? do_group_exit+0x6c/0x93
[  212.439228]  [<ffffffff810340bc>] ? sys_exit_group+0x12/0x19
[  212.439228]  [<ffffffff81001eeb>] ? system_call_fastpath+0x16/0x1b
[  212.439228] Code: 90 00 01 00 00 75 05 f0 66 0f b1 17 0f 94 c2 0f b6 c2 85 c0 0f 95 c0 0f b6 c0 c3 b8 00 01 00 00 f0 66 0f c1 07 38 e0 74 06 f3 90 <8a> 07 eb f6 c3 9c 58 fa ba 00 01 00 00 f0 66 0f c1 17 38 f2 74 
[  212.439228] ---[ end trace f8a4ceb8268dbe36 ]---
[  212.439223] Kernel panic - not syncing: Aiee, killing interrupt handler!
[  212.439223] Pid: 0, comm: swapper Tainted: G      D    2.6.34-smpx #1475
[  212.439223] Call Trace:
[  212.439223]  <NMI>  [<ffffffff812a1956>] ? panic+0x77/0xe5
[  212.439223]  [<ffffffff8104bfe1>] ? notifier_call_chain+0x2e/0x5b
[  212.439223]  [<ffffffff8104c416>] ? notify_die+0x2d/0x33
[  212.439223]  [<ffffffff81016b73>] ? nmi_watchdog_tick+0x38/0x191
[  212.439223]  [<ffffffff810037d3>] ? do_nmi+0x215/0x23c
[  212.439223]  [<ffffffff811a9ba4>] ? serial8250_console_putchar+0x0/0x28
[  212.439223]  [<ffffffff812a423a>] ? nmi+0x1a/0x20
[  212.439223]  [<ffffffff811a9ba4>] ? serial8250_console_putchar+0x0/0x28
[  212.439223]  [<ffffffff81121881>] ? delay_tsc+0x32/0x4d
[  212.439223]  <<EOE>> 
[  212.439228] BUG: NMI Watchdog detected LOCKUP on CPU0, ip ffffffff812a3a29, registers:
[  212.439228] CPU 0 
[  212.439228] Modules linked in: cpufreq_conservative cpufreq_ondemand cpufreq_userspace cpufreq_powersave acpi_cpufreq snd_pcm_oss snd_mixer_oss microcode snd_seq snd_seq_device fuse loop dm_mod snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer firewire_ohci firewire_core crc_itu_t usb_storage snd ohci1394 soundcore snd_page_alloc usb_libusual rtc_cmos ieee1394 thermal button processor rtc_core sr_mod rtc_lib e1000e i2c_i801 cdrom sg usbhid hid uhci_hcd ehci_hcd sd_mod usbcore edd fan ext3 ext2 mbcache jbd ahci libata scsi_mod
[  212.439228] 
[  212.439228] Pid: 7183, comm: forkbomb Tainted: G      D    2.6.34-smpx #1475 MS-7502/MS-7502
[  212.439228] RIP: 0010:[<ffffffff812a3a29>]  [<ffffffff812a3a29>] _raw_spin_lock+0x10/0x15
[  212.439228] RSP: 0018:ffff8800016077b8  EFLAGS: 00000093
[  212.439228] RAX: 0000000000000604 RBX: ffff8800bf8a0000 RCX: 0000000000000000
[  212.439228] RDX: 0000000000000000 RSI: ffff8800016077f8 RDI: ffff880001612e40
[  212.439228] RBP: ffff880001612e40 R08: 0000000000000000 R09: 000000000000007f
[  212.439228] R10: 00000000003604e2 R11: ffffffff815658d8 R12: 0000000000012e40
[  212.439228] R13: ffff8800016077f8 R14: 0000000000000000 R15: ffff880001615ae0
[  212.439228] FS:  0000000000000000(0000) GS:ffff880001600000(0000) knlGS:0000000000000000
[  212.439228] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  212.439228] CR2: 00007f1b2e3aa4a8 CR3: 0000000001420000 CR4: 00000000000006f0
[  212.439228] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  212.439228] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  212.439228] Process forkbomb (pid: 7183, threadinfo ffff8800b774a000, task ffff8800b0097a10)
[  212.439228] Stack:
[  212.439228]  ffffffff810252fe 0000000000000000 ffff8800bf8a0000 0000000000000000
[  212.439228] <0> 0000000000000003 0000000000000000 ffffffff8102b227 0000000000000000
[  212.439228] <0> 0000000000000083 ffff8800bf89fe80 0000000000000003 ffff880001615ac8
[  212.439228] Call Trace:
[  212.439228]  <NMI> 
[  212.439228]  [<ffffffff810252fe>] ? task_rq_lock+0x7a/0x94
[  212.439228]  [<ffffffff8102b227>] ? try_to_wake_up+0x21/0x21f
[  212.439228]  [<ffffffff810482ee>] ? autoremove_wake_function+0x9/0x2a
[  212.439228]  [<ffffffff810220bf>] ? __wake_up_common+0x41/0x78
[  212.439228]  [<ffffffff8114f42e>] ? bit_putcs+0x4de/0x55c
[  212.439228]  [<ffffffff81120aef>] ? vsnprintf+0x413/0x44c
[  212.439228]  [<ffffffff8114ef32>] ? bit_cursor+0x4c7/0x4e5
[  212.439228]  [<ffffffff8114f704>] ? soft_cursor+0x19c/0x1b0
[  212.439228]  [<ffffffff8114ef32>] ? bit_cursor+0x4c7/0x4e5
[  212.439228]  [<ffffffff8114ef50>] ? bit_putcs+0x0/0x55c
[  212.439228]  [<ffffffff8114c5de>] ? fbcon_scroll+0x5bd/0xad8
[  212.439228]  [<ffffffff811a9b59>] ? wait_for_xmitr+0x3d/0x88
[  212.439228]  [<ffffffff811a9bb9>] ? serial8250_console_putchar+0x15/0x28
[  212.439228]  [<ffffffff811a9b59>] ? wait_for_xmitr+0x3d/0x88
[  212.439228]  [<ffffffff81030ed4>] ? __call_console_drivers+0x64/0x78
[  212.439228]  [<ffffffff8104be0a>] ? up+0xe/0x39
[  212.439228]  [<ffffffff81031886>] ? release_console_sem+0x177/0x195
[  212.439228]  [<ffffffff81031886>] ? release_console_sem+0x177/0x195
[  212.439228]  [<ffffffff812a1a04>] ? printk+0x40/0x4c
[  212.439228]  [<ffffffff81058810>] ? __module_text_address+0x9/0x55
[  212.439228]  [<ffffffff81058810>] ? __module_text_address+0x9/0x55
[  212.439228]  [<ffffffff81046388>] ? __kernel_text_address+0x1f/0x45
[  212.439228]  [<ffffffff810059ed>] ? print_context_stack+0xa1/0xbd
[  212.439228]  [<ffffffff810059ed>] ? print_context_stack+0xa1/0xbd
[  212.439228]  [<ffffffff81004af5>] ? dump_trace+0x17d/0x23e
[  212.439228]  [<ffffffff81004cc2>] ? show_stack_log_lvl+0x10c/0x11b
[  212.439228]  [<ffffffff81004d84>] ? show_registers+0xb3/0x213
[  212.439228]  [<ffffffff81005da9>] ? die_nmi+0x7a/0xdd
[  212.439228]  [<ffffffff81016c60>] ? nmi_watchdog_tick+0x125/0x191
[  212.439228]  [<ffffffff81003661>] ? do_nmi+0xa3/0x23c
[  212.439228]  [<ffffffff812a423a>] ? nmi+0x1a/0x20
[  212.439228]  [<ffffffff812a3a29>] ? _raw_spin_lock+0x10/0x15
[  212.439228]  <<EOE>> 
[  212.439228] Code: 90 00 01 00 00 75 05 f0 66 0f b1 17 0f 94 c2 0f b6 c2 85 c0 0f 95 c0 0f b6 c0 c3 b8 00 01 00 00 f0 66 0f c1 07 38 e0 74 06 f3 90 <8a> 07 eb f6 c3 9c 58 fa ba 00 01 00 00 f0 66 0f c1 17 38 f2 74 
[  212.439228] ---[ end trace f8a4ceb8268dbe37 ]---


