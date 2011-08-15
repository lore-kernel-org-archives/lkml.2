Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab1HOKKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 06:10:09 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:46959 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750937Ab1HOKKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 06:10:05 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/GezEyt0zG+zdZJXRtOuDfeCtZDRGy25zZKoQnvr
	rikgeijd/MQ8s5
Subject: Re: [ANNOUNCE] 3.0.1-rt11
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <20110813162735.GA2650@linux.vnet.ibm.com>
References: <1313232790.25267.7.camel@twins>
	 <1313236135.4486.10.camel@marge.simson.net>
	 <1313236713.25267.10.camel@twins>
	 <1313243965.4486.36.camel@marge.simson.net>
	 <20110813162735.GA2650@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 12:09:58 +0200
Message-ID: <1313402998.3658.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-08-13 at 09:27 -0700, Paul E. McKenney wrote:
> On Sat, Aug 13, 2011 at 03:59:25PM +0200, Mike Galbraith wrote:
> > On Sat, 2011-08-13 at 13:58 +0200, Peter Zijlstra wrote:
> > > On Sat, 2011-08-13 at 13:48 +0200, Mike Galbraith wrote:
> > > > On Sat, 2011-08-13 at 12:53 +0200, Peter Zijlstra wrote:
> > > > > Whee, I can skip release announcements too!
> > > > > 
> > > > > So no the subject ain't no mistake its not, 3.0.1-rt11 is there for the
> > > > > grabs.
> > > > > 
> > > > > Changes include (including the missing -rt10):
> > > > > 
> > > > >   - hrtimer fix that should make RT_GROUP work again
> > > > >   - RCU fixes that should make the RCU stalls go away
> > > > 
> > > > Oh goodie, I was just looking at some of those.
> > > > 
> > > > coverdale:/abuild/mike/linux-3.0-rt/:[1]# wget http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
> > > > --2011-08-13 13:38:13--  http://www.kernel.org/pub/linux/kernel/projects/rt/patches-3.0.1-rt11.tar.bz2
> > > > Resolving www.kernel.org... 130.239.17.5, 199.6.1.165, 2001:6b0:e:4017:1994:313:1:0, ...
> > > > Connecting to www.kernel.org|130.239.17.5|:80... connected.
> > > > HTTP request sent, awaiting response... 404 Not Found
> > > > 2011-08-13 13:38:13 ERROR 404: Not Found.
> > > > 
> > > > Aw poo.  Darn mirrors. 
> > > 
> > > Try -rt10, except for an SMP=n build fix its identical.. kernel.org
> > > seems to experience some trouble atm..
> > 
> > Hohum.  rt10 did change the symptom.  Box no longer gripes at some
> > random point while just idling along, now it gripes (and dies as well)
> > during boot.
> > 
> > First boot, it choked on sr0 a wee bit later, second boot here.
> > 
> > [   40.582256] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
> > [   40.582260] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 08:00:69:15:c1:d5
> > [   40.582335] igb 0000:01:00.1: eth1: PBA No: FFFFFF-0FF
> > [   40.582338] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
> > [  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)
> > 
> > Guess I should try x3550 M3 or Q6600.  They were griping the same way UV
> > box did earlier this morning (with an earlier -rt though), and they make
> > much smaller gripes.
> > 
> > Gripe attached.  Looks a lot like the old gripes to me, just earlier and
> > deadlier.  But I don't speak rcu.
> 
> Strange.  By the time it got around to printing the stall, no one was
> stalling:
> 
> [  100.409012] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 21, t=60002 jiffies)
> 
> Now it -is- possible for the stall to end just as we get ready to detect
> it, but that window is really really small.  The most recent occurrence
> of this sort of thing was due misconfigured timekeeping, but I don't see
> any sign of that in the trace.
> 
> This happens repeatedly?

The "just idling along" stalls seem to be a thing of the past on Q6600
and x3550 M3 boxes.

UV box has other illnesses yet.  I found another lock that needs to be
raw, and it has a bad case of scsi-itis that may or may not lock it up
during boot, so ignore it.

Running ltp realtime testcases on x3550 box brought rcu gripes back to
life.  In this case, it's the busted jitter testcase, but others will
trip it up as well. 

[  340.573912] INFO: rcu_preempt_state detected stalls on CPUs/tasks: {} (detected by 1, t=60002 jiffies)
[  340.573919] sending NMI to all CPUs:
[  340.573924] NMI backtrace for cpu 0
[  340.573927] CPU 0 
[  340.573929] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler edd nfsd lockd nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod ioatdma bnx2 cdc_ether usbnet shpchp pci_hotplug i2c_i801 serio_raw pcspkr tpm_tis tpm sg i7core_edac edac_core iTCO_wdt iTCO_vendor_support dca tpm_bios button usbhid uhci_hcd ehci_hcd usbcore fan processor ata_generic megaraid_sas thermal thermal_sys
[  340.573959] 
[  340.573961] Pid: 0, comm: swapper Not tainted 3.0.1-rt11 #15 IBM System x3550 M3 -[7944K3G]-/69Y5698     
[  340.573966] RIP: 0010:[<ffffffff8131a459>]  [<ffffffff8131a459>] intel_idle+0x99/0x120
[  340.573975] RSP: 0018:ffffffff81a01e48  EFLAGS: 00000046
[  340.573977] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[  340.573979] RDX: 0000000000000000 RSI: ffffffff81a01fd8 RDI: ffffffff81a11a80
[  340.573981] RBP: ffffffff81a01e98 R08: 0000000000000000 R09: 0000000000000001
[  340.573984] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
[  340.573986] R13: 123a20975d4305fe R14: 0000000000000000 R15: 0000000000000001
[  340.573989] FS:  0000000000000000(0000) GS:ffff88017aa00000(0000) knlGS:0000000000000000
[  340.573991] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  340.573994] CR2: 00007fffa4cadc8f CR3: 0000000175d9a000 CR4: 00000000000006f0
[  340.573996] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  340.573999] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  340.574002] Process swapper (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0e020)
[  340.574004] Stack:
[  340.574005]  ffffffff81a01fd8 000000000005fc40 000000000005d360 ffff88017aa67870
[  340.574009]  ffffffff81a01e98 00000000814224bc 00000000ffffffff ffff88017aa67870
[  340.574013]  ffffffff81b4dbc0 0000000000000001 ffffffff81a01ee8 ffffffff81421327
[  340.574017] Call Trace:
[  340.574024]  [<ffffffff81421327>] cpuidle_idle_call+0xa7/0x310
[  340.574030]  [<ffffffff810011fb>] cpu_idle+0x5b/0x90
[  340.574036]  [<ffffffff8153bfa5>] rest_init+0x85/0x90
[  340.574042]  [<ffffffff81bb6bc0>] start_kernel+0x37c/0x387
[  340.574045]  [<ffffffff81bb636c>] x86_64_start_reservations+0x132/0x136
[  340.574049]  [<ffffffff81bb6237>] ? zap_identity_mappings+0x3e/0x41
[  340.574053]  [<ffffffff81bb643c>] x86_64_start_kernel+0xcc/0xdb
[  340.574055] Code: c5 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 62 10 d7 ff 4c 29 e8 48 89 c7 e8 d7 74 d4 ff 4c 69 e0 40 42 
[  340.574077] Call Trace:
[  340.574081]  [<ffffffff81421327>] cpuidle_idle_call+0xa7/0x310
[  340.574085]  [<ffffffff810011fb>] cpu_idle+0x5b/0x90
[  340.574089]  [<ffffffff8153bfa5>] rest_init+0x85/0x90
[  340.574092]  [<ffffffff81bb6bc0>] start_kernel+0x37c/0x387
[  340.574096]  [<ffffffff81bb636c>] x86_64_start_reservations+0x132/0x136
[  340.574099]  [<ffffffff81bb6237>] ? zap_identity_mappings+0x3e/0x41
[  340.574102]  [<ffffffff81bb643c>] x86_64_start_kernel+0xcc/0xdb
[  340.574105] NMI backtrace for cpu 1
[  340.574106] CPU 1 
[  340.574108] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler edd nfsd lockd nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod ioatdma bnx2 cdc_ether usbnet shpchp pci_hotplug i2c_i801 serio_raw pcspkr tpm_tis tpm sg i7core_edac edac_core iTCO_wdt iTCO_vendor_support dca tpm_bios button usbhid uhci_hcd ehci_hcd usbcore fan processor ata_generic megaraid_sas thermal thermal_sys
[  340.574134] 
[  340.574136] Pid: 4982, comm: sched_jitter Not tainted 3.0.1-rt11 #15 IBM System x3550 M3 -[7944K3G]-/69Y5698     
[  340.574140] RIP: 0010:[<ffffffff81009f46>]  [<ffffffff81009f46>] native_read_tsc+0x6/0x20
[  340.574149] RSP: 0000:ffff88017aa83c78  EFLAGS: 00000002
[  340.574151] RAX: 00000000ebc877d2 RBX: 0000000000000000 RCX: 0000000000000000
[  340.574153] RDX: 0000000000000124 RSI: 0000000000000200 RDI: 0000000000000001
[  340.574155] RBP: ffff88017aa83c78 R08: ffffffff81b4dbc0 R09: 0000000000000000
[  340.574158] R10: 000000000000000a R11: 0000000000000001 R12: 0000000000001000
[  340.574160] R13: 000000000003a97b R14: 0000000000000001 R15: 0000000000000092
[  340.574163] FS:  00007f17a7136710(0000) GS:ffff88017aa80000(0000) knlGS:0000000000000000
[  340.574166] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  340.574168] CR2: 00007f17a7dfc430 CR3: 00000001732ed000 CR4: 00000000000006e0
[  340.574171] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  340.574173] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  340.574176] Process sched_jitter (pid: 4982, threadinfo ffff880173b16000, task ffff880173b4a480)
[  340.574178] Stack:
[  340.574179]  ffff88017aa83cb8 ffffffff812c8c86 0000000f00000001 0000000000000000
[  340.574183]  0000000000001000 ffffffff81b4dbc0 0000000000000400 0000000000000092
[  340.574187]  ffff88017aa83cc8 ffffffff812c8bed ffff88017aa83ce8 ffffffff81020e8a
[  340.574191] Call Trace:
[  340.574192]  <IRQ> 
[  340.574197]  [<ffffffff812c8c86>] delay_tsc+0x36/0x100
[  340.574201]  [<ffffffff812c8bed>] __const_udelay+0x2d/0x30
[  340.574206]  [<ffffffff81020e8a>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  340.574211]  [<ffffffff81021eff>] default_send_IPI_mask_sequence_phys+0xcf/0xe0
[  340.574217]  [<ffffffff81026f87>] physflat_send_IPI_all+0x17/0x20
[  340.574221]  [<ffffffff81022091>] arch_trigger_all_cpu_backtrace+0x61/0xa0
[  340.574226]  [<ffffffff810d5f2e>] print_other_cpu_stall+0x14e/0x1b0
[  340.574230]  [<ffffffff810d5ff2>] check_cpu_stall+0x62/0x100
[  340.574233]  [<ffffffff810d6590>] __rcu_pending+0x30/0x190
[  340.574237]  [<ffffffff810d6882>] rcu_check_callbacks+0x112/0x170
[  340.574242]  [<ffffffff8106d70d>] update_process_times+0x4d/0x70
[  340.574248]  [<ffffffff8109310c>] tick_sched_timer+0x5c/0xb0
[  340.574252]  [<ffffffff81084326>] __run_hrtimer+0x76/0x270
[  340.574256]  [<ffffffff810930b0>] ? tick_do_update_jiffies64+0xd0/0xd0
[  340.574261]  [<ffffffff81084d94>] hrtimer_interrupt+0x284/0x330
[  340.574265]  [<ffffffff81558b3d>] ? add_preempt_count+0x9d/0xd0
[  340.574269]  [<ffffffff8155e2a6>] smp_apic_timer_interrupt+0x66/0x98
[  340.574274]  [<ffffffff8155d273>] apic_timer_interrupt+0x13/0x20
[  340.574276]  <EOI> 
[  340.574278] Code: c3 90 90 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55 89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 31 
[  340.574294]  c1 48 89 d0 48 c1 e0 20 89 c9 48 09 c8 c9 c3 66 2e 0f 1f 84 
[  340.574302] Call Trace:
[  340.574303]  <IRQ>  [<ffffffff812c8c86>] delay_tsc+0x36/0x100
[  340.574309]  [<ffffffff812c8bed>] __const_udelay+0x2d/0x30
[  340.574313]  [<ffffffff81020e8a>] native_safe_apic_wait_icr_idle+0x1a/0x50
[  340.574317]  [<ffffffff81021eff>] default_send_IPI_mask_sequence_phys+0xcf/0xe0
[  340.574321]  [<ffffffff81026f87>] physflat_send_IPI_all+0x17/0x20
[  340.574325]  [<ffffffff81022091>] arch_trigger_all_cpu_backtrace+0x61/0xa0
[  340.574329]  [<ffffffff810d5f2e>] print_other_cpu_stall+0x14e/0x1b0
[  340.574333]  [<ffffffff810d5ff2>] check_cpu_stall+0x62/0x100
[  340.574336]  [<ffffffff810d6590>] __rcu_pending+0x30/0x190
[  340.574340]  [<ffffffff810d6882>] rcu_check_callbacks+0x112/0x170
[  340.574343]  [<ffffffff8106d70d>] update_process_times+0x4d/0x70
[  340.574347]  [<ffffffff8109310c>] tick_sched_timer+0x5c/0xb0
[  340.574351]  [<ffffffff81084326>] __run_hrtimer+0x76/0x270
[  340.574355]  [<ffffffff810930b0>] ? tick_do_update_jiffies64+0xd0/0xd0
[  340.574359]  [<ffffffff81084d94>] hrtimer_interrupt+0x284/0x330
[  340.574362]  [<ffffffff81558b3d>] ? add_preempt_count+0x9d/0xd0
[  340.574366]  [<ffffffff8155e2a6>] smp_apic_timer_interrupt+0x66/0x98
[  340.574369]  [<ffffffff8155d273>] apic_timer_interrupt+0x13/0x20
[  340.574371]  <EOI> 
[  340.574378] NMI backtrace for cpu 2
[  340.574380] CPU 2 
[  340.574381] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler edd nfsd lockd nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod ioatdma bnx2 cdc_ether usbnet shpchp pci_hotplug i2c_i801 serio_raw pcspkr tpm_tis tpm sg i7core_edac edac_core iTCO_wdt iTCO_vendor_support dca tpm_bios button usbhid uhci_hcd ehci_hcd usbcore fan processor ata_generic megaraid_sas thermal thermal_sys
[  340.574406] 
[  340.574409] Pid: 0, comm: kworker/0:1 Not tainted 3.0.1-rt11 #15 IBM System x3550 M3 -[7944K3G]-/69Y5698     
[  340.574413] RIP: 0010:[<ffffffff8131a459>]  [<ffffffff8131a459>] intel_idle+0x99/0x120
[  340.574419] RSP: 0018:ffff880179ec3e68  EFLAGS: 00000046
[  340.574421] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[  340.574424] RDX: 0000000000000000 RSI: ffff880179ec3fd8 RDI: ffffffff81a11a80
[  340.574426] RBP: ffff880179ec3eb8 R08: 0000000000000000 R09: 0000000000000001
[  340.574428] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
[  340.574430] R13: 123a20975d4304a0 R14: 0000000000000002 R15: 0000000000000001
[  340.574433] FS:  0000000000000000(0000) GS:ffff88017ab00000(0000) knlGS:0000000000000000
[  340.574436] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  340.574438] CR2: 00007f23a92ab000 CR3: 0000000174ecc000 CR4: 00000000000006e0
[  340.574441] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  340.574443] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  340.574446] Process kworker/0:1 (pid: 0, threadinfo ffff880179ec2000, task ffff880179ec06c0)
[  340.574448] Stack:
[  340.574449]  ffff880179ec3fd8 000000000005fc40 000000000005d360 ffff88017ab67870
[  340.574453]  ffff880179ec3eb8 00000002814224bc 00000000ffffffff ffff88017ab67870
[  340.574457]  ffffffff81b4dbc0 0000000000000001 ffff880179ec3f08 ffffffff81421327
[  340.574461] Call Trace:
[  340.574467]  [<ffffffff81421327>] cpuidle_idle_call+0xa7/0x310
[  340.574471]  [<ffffffff810011fb>] cpu_idle+0x5b/0x90
[  340.574477]  [<ffffffff8154bfbf>] start_secondary+0x99/0x9d
[  340.574479] Code: c5 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 62 10 d7 ff 4c 29 e8 48 89 c7 e8 d7 74 d4 ff 4c 69 e0 40 42 
[  340.574501] Call Trace:
[  340.574505]  [<ffffffff81421327>] cpuidle_idle_call+0xa7/0x310
[  340.574509]  [<ffffffff810011fb>] cpu_idle+0x5b/0x90
[  340.574513]  [<ffffffff8154bfbf>] start_secondary+0x99/0x9d
[  340.574517] NMI backtrace for cpu 3
[  340.574519] CPU 3 
[  340.574521] Modules linked in: ipmi_devintf ipmi_si ipmi_msghandler edd nfsd lockd nfs_acl auth_rpcgss sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod ioatdma bnx2 cdc_ether usbnet shpchp pci_hotplug i2c_i801 serio_raw pcspkr tpm_tis tpm sg i7core_edac edac_core iTCO_wdt iTCO_vendor_support dca tpm_bios button usbhid uhci_hcd ehci_hcd usbcore fan processor ata_generic megaraid_sas thermal thermal_sys
[  340.574545] 
[  340.574548] Pid: 0, comm: kworker/0:1 Not tainted 3.0.1-rt11 #15 IBM System x3550 M3 -[7944K3G]-/69Y5698     
[  340.574552] RIP: 0010:[<ffffffff8131a459>]  [<ffffffff8131a459>] intel_idle+0x99/0x120
[  340.574558] RSP: 0018:ffff880179f07e68  EFLAGS: 00000046
[  340.574560] RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000001
[  340.574562] RDX: 0000000000000000 RSI: ffff880179f07fd8 RDI: ffffffff81a11a80
[  340.574565] RBP: ffff880179f07eb8 R08: 0000000000000000 R09: 0000000000000001
[  340.574567] R10: 0000000000000000 R11: 0000000000000002 R12: 0000000000000000
[  340.574569] R13: 123a20975d4305bd R14: 0000000000000003 R15: 0000000000000001
[  340.574572] FS:  0000000000000000(0000) GS:ffff88017ab80000(0000) knlGS:0000000000000000
[  340.574575] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  340.574577] CR2: 00007f23a92ab000 CR3: 00000001732ed000 CR4: 00000000000006e0
[  340.574579] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  340.574582] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  340.574585] Process kworker/0:1 (pid: 0, threadinfo ffff880179f06000, task ffff880179f04080)
[  340.574587] Stack:
[  340.574588]  ffff880179f07fd8 000000000005fc40 000000000005d360 ffff88017abe7870
[  340.574592]  ffff880179f07eb8 00000003814224bc 00000000ffffffff ffff88017abe7870
[  340.574596]  ffffffff81b4dbc0 0000000000000001 ffff880179f07f08 ffffffff81421327
[  340.574599] Call Trace:
[  340.574605]  [<ffffffff81421327>] cpuidle_idle_call+0xa7/0x310
[  340.574609]  [<ffffffff810011fb>] cpu_idle+0x5b/0x90
[  340.574614]  [<ffffffff8154bfbf>] start_secondary+0x99/0x9d
[  340.574616] Code: c5 48 8d 86 38 e0 ff ff 83 e2 08 75 1e 31 d2 48 89 d1 0f 01 c8 0f ae f0 48 8b 86 38 e0 ff ff a8 08 75 08 b1 01 4c 89 e0 0f 01 c9 <e8> 62 10 d7 ff 4c 29 e8 48 89 c7 e8 d7 74 d4 ff 4c 69 e0 40 42 
[  340.574638] Call Trace:
[  340.574642]  [<ffffffff81421327>] cpuidle_idle_call+0xa7/0x310
[  340.574646]  [<ffffffff810011fb>] cpu_idle+0x5b/0x90
[  340.574650]  [<ffffffff8154bfbf>] start_secondary+0x99/0x9d


