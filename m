Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab2IMIf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 04:35:58 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51781 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2IMIfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 04:35:52 -0400
Message-ID: <50519AC5.9060102@linux.vnet.ibm.com>
Date: Thu, 13 Sep 2012 14:05:17 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, fengguang.wu@intel.com, jack@suse.cz
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: Re: WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0(),
 during CPU hotplug
References: <5007F8FA.7000203@linux.vnet.ibm.com> <20120719171550.GL2507@linux.vnet.ibm.com> <505081C4.2050600@linux.vnet.ibm.com>
In-Reply-To: <505081C4.2050600@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12091308-0260-0000-0000-000001D78780
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 06:06 PM, Srivatsa S. Bhat wrote:
> On 07/19/2012 10:45 PM, Paul E. McKenney wrote:
>> On Thu, Jul 19, 2012 at 05:39:30PM +0530, Srivatsa S. Bhat wrote:
>>> Hi Paul,
>>>
>>> While running a CPU hotplug stress test on v3.5-rc7+
>>> (mainline commit 8a7298b7805ab) I hit this warning.
>>> I haven't tried to debug this yet...
>>>
>>> Line number 1550 maps to:
>>>
>>> WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
>>>
>>> inside rcu_do_batch().
>>
>> Hello, Srivatsa,
>>
>> I believe that you need commit a16b7a69 (Prevent __call_rcu() from
>> invoking RCU core on offline CPUs), which is currently in -tip, queued
>> for 3.6.  Please see below for the patch.
>>
>> Does this help?
>>
> 
> Hi Paul,
> 
> I am hitting the cpu_is_offline() warning in rcu_do_batch() (see 2 of the
> examples below) occasionally while testing CPU hotplug on Thomas' smp/hotplug
> branch in -tip. It does contain the commit that you had mentioned above.
> 

I also hit some writeback related problems during some of these runs. But I was
not able to reproduce them after that occurrence. (Adding relevant people to CC.)

I hit the divide error shown below during the CPU hotplug test run, and the general
protection fault subsequently, while trying to shutdown the machine after the test.

Regards,
Srivatsa S. Bhat

[  522.987310] SMP alternatives: switching to SMP code
[  522.999101] smpboot: Booting Node 1 Processor 7 APIC 0x16
[  524.083872] SMP alternatives: lockdep: fixing up alternatives
[  524.090053] smpboot: Booting Node 0 Processor 8 APIC 0x1
[  525.148720] SMP alternatives: lockdep: fixing up alternatives
[  525.154970] smpboot: Booting Node 0 Processor 9 APIC 0x3
[  526.024180] divide error: 0000 [#1] SMP 
[  526.028144] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether pcspkr usbnet shpchp pci_hotplug i2c_i801 i2c_core ioatdma mii crc32c_intel serio_raw microcode lpc_ich mfd_core i7core_edac bnx2 dca edac_core tpm_tis tpm sg tpm_bios rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[  526.028145] CPU 9 
[  526.028145] Pid: 2235, comm: flush-8:0 Not tainted 3.6.0-rc1-tglx-hotplug-0.0.0.28.36b5ec9-default #1 IBM IBM System x -[7870C4Q]-/68Y8033     
[  526.028145] RIP: 0010:[<ffffffff811276f6>]  [<ffffffff811276f6>] bdi_dirty_limit+0x66/0xc0
[  526.028145] RSP: 0018:ffff8811530bfcc0  EFLAGS: 00010206
[  526.028145] RAX: 0000000000b9877e RBX: 00000000001a8112 RCX: 28f5c28f5c28f5c3
[  526.028145] RDX: 0000000000000000 RSI: 0000000000b9877e RDI: 0000000000000000
[  526.028145] RBP: ffff8811530bfce0 R08: 0000000000000010 R09: 0000000000000000
[  526.028145] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8808d4408e20
[  526.028145] R13: ffff8808d4408e20 R14: ffff8808d44091a0 R15: 0000000000000000
[  526.028145] FS:  0000000000000000(0000) GS:ffff8808ddd40000(0000) knlGS:0000000000000000
[  526.028145] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  526.028145] CR2: 00007fa35dd4eb60 CR3: 0000000001a0c000 CR4: 00000000000007e0
[  526.028145] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  526.028145] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  526.028145] Process flush-8:0 (pid: 2235, threadinfo ffff8811530be000, task ffff88115315c5e0)
[  526.028145] Stack:
[  526.028145]  0400000000000000 0000000000000007 ffff8808d4408e20 ffffffffffffffee
[  526.028145]  ffff8811530bfd10 ffffffff811ae95c 0000000000350225 00000000001a8112
[  526.028145]  0000000000000000 0000000000000002 ffff8811530bfdc0 ffffffff811b0620
[  526.028145] Call Trace:
[  526.209272] SMP alternatives: lockdep: fixing up alternatives
[  526.209275] smpboot: Booting Node 0 Processor 10 APIC 0x5
[  526.220012]  [<ffffffff811ae95c>] over_bground_thresh+0x7c/0x90
[  526.220012]  [<ffffffff811b0620>] wb_do_writeback+0x170/0x310
[  526.220012]  [<ffffffff811b08eb>] bdi_writeback_thread+0x12b/0x420
[  526.220012]  [<ffffffff811b07c0>] ? wb_do_writeback+0x310/0x310
[  526.220012]  [<ffffffff8106deae>] kthread+0xde/0xf0
[  526.220012]  [<ffffffff814c6184>] kernel_thread_helper+0x4/0x10
[  526.220012]  [<ffffffff814bc1f0>] ? retint_restore_args+0x13/0x13
[  526.220012]  [<ffffffff8106ddd0>] ? __init_kthread_worker+0x70/0x70
[  526.220012]  [<ffffffff814c6180>] ? gs_change+0x13/0x13
[  526.220012] Code: 28 5c 8f c2 f5 28 8b 7d e0 48 89 c6 48 0f af f3 48 c1 ee 02 48 89 f0 48 f7 e1 48 89 d6 31 d2 48 c1 ee 02 48 0f af 75 e8 48 89 f0 <48> f7 f7 41 8b 94 24 74 02 00 00 48 0f af d3 48 89 c7 48 c1 ea 
[  526.220012] RIP  [<ffffffff811276f6>] bdi_dirty_limit+0x66/0xc0
[  526.220012]  RSP <ffff8811530bfcc0>
[  526.304469] ---[ end trace bcfc7ab74bdb11a5 ]---
[  527.330948] SMP alternatives: lockdep: fixing up alternatives


----

[ 1941.614775] SMP alternatives: lockdep: fixing up alternatives
[ 1941.620614] smpboot: Booting Node 1 Processor 5 APIC 0x12
[ 1941.657424] SMP alternatives: lockdep: fixing up alternatives
[ 1941.663215] smpboot: Booting Node 1 Processor 6 APIC 0x14

[ 1992.721819] general protection fault: 0000 [#2] SMP 
[ 1992.724844] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm cdc_ether pcspkr usbnet shpchp pci_hotplug i2c_i801 i2c_core ioatdma mii crc32c_intel serio_raw microcode lpc_ich mfd_core i7core_edac bnx2 dca edac_core tpm_tis tpm sg tpm_bios rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase
scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[ 1992.726995] CPU 8 
[ 1992.726995] Pid: 19654, comm: shutdown Tainted: G      D      3.6.0-rc1-tglx-hotplug-0.0.0.28.36b5ec9-default #1 IBM IBM System x -[7870C4Q]-/68Y8033     
[ 1992.726995] RIP: 0010:[<ffffffff810843d7>]  [<ffffffff810843d7>] try_to_wake_up+0x57/0x2f0
[ 1992.726995] RSP: 0018:ffff8808d47e5e58  EFLAGS: 00010002
[ 1992.726995] RAX: 6b6b6b6b6b6b6b6b RBX: 000000000000000f RCX: 000000006b6b6b6b
[ 1992.726995] RDX: 000000006b6c6b6b RSI: ffffffff817a7fbf RDI: ffff88115315cdd0
[ 1992.726995] RBP: ffff8808d47e5e98 R08: 0000000000000002 R09: 0000000000000001
[ 1992.726995] R10: 0000000000000000 R11: 0000000000000001 R12: ffff88115315c5e0
[ 1992.726995] R13: 000000006b6b6b6b R14: ffff8808d44091a0 R15: 0000000000000000
[ 1992.726995] FS:  00007f32b1beb700(0000) GS:ffff8808ddd00000(0000) knlGS:0000000000000000
[ 1992.726995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1992.726995] CR2: 00007f32b173d1a0 CR3: 0000001153bd0000 CR4: 00000000000007e0
[ 1992.726995] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1992.726995] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1992.726995] Process shutdown (pid: 19654, threadinfo ffff8808d47e4000, task ffff8808d4b045e0)
[ 1992.726995] Stack:
[ 1992.726995]  0000000000000246 ffff88115315cdd0 0000000000000286 0000000000000000
[ 1992.726995]  ffff8808d4408e20 ffff8808d5433288 ffff8808d44091a0 00746c6168206d65
[ 1992.726995]  ffff8808d47e5ea8 ffffffff810846a0 ffff8808d47e5ed8 ffffffff811adce1
[ 1992.726995] Call Trace:
[ 1992.726995]  [<ffffffff810846a0>] wake_up_process+0x10/0x20
[ 1992.726995]  [<ffffffff811adce1>] bdi_queue_work+0xd1/0x1f0
[ 1992.726995]  [<ffffffff811ae7d9>] __bdi_start_writeback+0x79/0x160
[ 1992.726995]  [<ffffffff811af1b0>] wakeup_flusher_threads+0x120/0x1e0
[ 1992.726995]  [<ffffffff811af0ca>] ? wakeup_flusher_threads+0x3a/0x1e0
[ 1992.726995]  [<ffffffff811b45b2>] sys_sync+0x22/0x90
[ 1992.726995]  [<ffffffff814c4fb9>] system_call_fastpath+0x16/0x1b
[ 1992.726995] Code: 31 ed 48 89 c7 48 89 45 c8 e8 46 72 43 00 48 89 45 d0 49 8b 04 24 85 c3 0f 84 02 02 00 00 45 8b 6c 24 2c 49 8b 44 24 08 45 85 ed <44> 8b 70 18 74 75 8b 1d dd ea 9d 00 85 db 0f 85 2d 02 00 00 49  
[ 1992.726995] RIP  [<ffffffff810843d7>] try_to_wake_up+0x57/0x2f0
[ 1992.726995]  RSP <ffff8808d47e5e58>
[ 1992.726995] ---[ end trace bcfc7ab74bdb11a6 ]---
[ 1992.726995] Kernel panic - not syncing: Fatal exception in interrupt



