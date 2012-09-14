Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758436Ab2INMSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 08:18:54 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35910 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab2INMSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 08:18:52 -0400
Message-ID: <5053208C.4060205@linux.vnet.ibm.com>
Date: Fri, 14 Sep 2012 17:48:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: paulmck@linux.vnet.ibm.com, jack@suse.cz,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Michael Wang <wangyun@linux.vnet.ibm.com>
Subject: Re: WARNING: at kernel/rcutree.c:1558 rcu_do_batch+0x386/0x3a0(),
 during CPU hotplug
References: <5007F8FA.7000203@linux.vnet.ibm.com> <20120719171550.GL2507@linux.vnet.ibm.com> <505081C4.2050600@linux.vnet.ibm.com> <50519AC5.9060102@linux.vnet.ibm.com> <20120914114752.GA20349@localhost>
In-Reply-To: <20120914114752.GA20349@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12091412-8256-0000-0000-0000042C7FC1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2012 05:17 PM, Fengguang Wu wrote:
> On Thu, Sep 13, 2012 at 02:05:17PM +0530, Srivatsa S. Bhat wrote:
>> On 09/12/2012 06:06 PM, Srivatsa S. Bhat wrote:
>>> On 07/19/2012 10:45 PM, Paul E. McKenney wrote:
>>>> On Thu, Jul 19, 2012 at 05:39:30PM +0530, Srivatsa S. Bhat wrote:
>>>>> Hi Paul,
>>>>>
>>>>> While running a CPU hotplug stress test on v3.5-rc7+
>>>>> (mainline commit 8a7298b7805ab) I hit this warning.
>>>>> I haven't tried to debug this yet...
>>>>>
>>>>> Line number 1550 maps to:
>>>>>
>>>>> WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
>>>>>
>>>>> inside rcu_do_batch().
>>>>
>>>> Hello, Srivatsa,
>>>>
>>>> I believe that you need commit a16b7a69 (Prevent __call_rcu() from
>>>> invoking RCU core on offline CPUs), which is currently in -tip, queued
>>>> for 3.6.  Please see below for the patch.
>>>>
>>>> Does this help?
>>>>
>>>
>>> Hi Paul,
>>>
>>> I am hitting the cpu_is_offline() warning in rcu_do_batch() (see 2 of the
>>> examples below) occasionally while testing CPU hotplug on Thomas' smp/hotplug
>>> branch in -tip. It does contain the commit that you had mentioned above.
>>>
>>
>> I also hit some writeback related problems during some of these runs. But I was
>> not able to reproduce them after that occurrence. (Adding relevant people to CC.)
>>
>> I hit the divide error shown below during the CPU hotplug test run, and the general
> 
> I've hit the divide error before. And I'm not luckier than you in
> reproducing the bug. I tempt to add a test as the workaround:
> 

Hi Fengguang,
First of all, thanks for taking a look!

I just hit it today during my testing again! See below for the stack-traces..

> +       if (WARN_ON(!denominator))
> +               return dirty;

Yep, I am going to try this out next and see if the denominator really became 0.
I went through the code and I didn't find anything wrong with it. It looks pretty
good (the denominator sanity checking part). Hmm...

> 
> btw, any chance you may share the CPU hotplug test scripts?
> It'd be a valuable addition to my 0day boot test system.
> 

Sure, I was using a very simple script that does offline/online in sequence. That's all.
Please find it below. Note that adding a breather between the hotplug operations (like
adding sleep as shown below) has the potential to expose different bugs than the normal
stress test (no sleeps between subsequent operations). So both cases are useful to test.
For example, with the sleep, I hit this divide error with higher probability, whereas
without the sleep (stress test) I hit the rcu_do_batch warning more often.

(And on a slightly different note, when x86 supports CPU 0 hotplug (today it doesn't),
you can use i = 0 instead of i = 1 in the loop. I believe that code is already in -tip).


CPU hotplug test script
-----------------------
#! /bin/bash

NUMBER_OF_CPUS=`ls -d /sys/devices/system/cpu/cpu[0-9]* | wc -l`

cd /sys/devices/system/cpu

while [ 1 ]
do
        for ((i=1; i < NUMBER_OF_CPUS; i++))
        do
                sleep 1;
                state=`cat cpu$i/online`
                if [ $state -eq 0 ]
                then
                        echo 1 > cpu$i/online
                else
                        echo 0 > cpu$i/online
                fi
        done
done


>> protection fault subsequently, while trying to shutdown the machine after the test.
> 

Dumps from the divide error and general protection fault in today's testing:


[ 4831.353623] SMP alternatives: lockdep: fixing up alternatives
[ 4831.359465] smpboot: Booting Node 1 Processor 13 APIC 0x13
[ 4833.028342] SMP alternatives: lockdep: fixing up alternatives
[ 4833.034188] smpboot: Booting Node 1 Processor 14 APIC 0x15
[ 4835.693836] SMP alternatives: lockdep: fixing up alternatives
[ 4835.699609] smpboot: Booting Node 1 Processor 15 APIC 0x17
[ 4843.142309] Broke affinity for irq 77
[ 4843.147605] smpboot: CPU 1 is now offline
[ 4843.155885] CPU 9 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4844.379459] Broke affinity for irq 80
[ 4844.384569] smpboot: CPU 2 is now offline
[ 4844.392111] CPU 10 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4845.810713] smpboot: CPU 3 is now offline
[ 4845.821409] CPU 11 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4848.710692] Broke affinity for irq 74
[ 4848.716063] smpboot: CPU 4 is now offline
[ 4848.721781] CPU 5 MCA banks CMCI:6 CMCI:8
[ 4848.726440] CPU 12 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4855.990349] smpboot: CPU 5 is now offline
[ 4855.997251] CPU 6 MCA banks CMCI:6 CMCI:8
[ 4856.002002] CPU 13 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4859.198420] smpboot: CPU 6 is now offline
[ 4859.205217] CPU 7 MCA banks CMCI:6 CMCI:8
[ 4859.209858] CPU 14 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4861.202261] smpboot: CPU 7 is now offline
[ 4861.211009] CPU 12 MCA banks CMCI:6 CMCI:8
[ 4861.215403] CPU 15 MCA banks CMCI:2 CMCI:3 CMCI:5
[ 4863.210557] smpboot: CPU 8 is now offline
[ 4890.536087] divide error: 0000 [#1] SMP 
[ 4890.540047] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode cdc_ether usbnet i2c_i801 mii tpm_tis pcspkr ioatdma i7core_edac tpm serio_raw i2c_core bnx2 shpchp lpc_ich mfd_core edac_core pci_hotplug dca tpm_bios sg rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[ 4890.540047] CPU 9 
[ 4890.540047] Pid: 2243, comm: flush-8:0 Not tainted 3.6.0-rc1-tglx-hotplug-0.0.0.28.36b5ec9-default #1 IBM IBM System x -[7870C4Q]-/68Y8033     
[ 4890.540047] RIP: 0010:[<ffffffff811276f6>]  [<ffffffff811276f6>] bdi_dirty_limit+0x66/0xc0
[ 4890.540047] RSP: 0018:ffff8808d3e1fcc0  EFLAGS: 00010202
[ 4890.540047] RAX: 0000000000000000 RBX: 00000000001a80c4 RCX: 28f5c28f5c28f5c3
[ 4890.540047] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 4890.540047] RBP: ffff8808d3e1fce0 R08: 0000000000000010 R09: 0000000000000000
[ 4890.540047] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8808d3d80e20
[ 4890.540047] R13: ffff8808d3d80e20 R14: ffff8808d3d811a0 R15: 0000000000000000
[ 4890.540047] FS:  0000000000000000(0000) GS:ffff8808ddd40000(0000) knlGS:0000000000000000
[ 4890.540047] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4890.540047] CR2: ffffffffff600400 CR3: 0000000001a0c000 CR4: 00000000000007e0
[ 4890.540047] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4890.540047] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4890.540047] Process flush-8:0 (pid: 2243, threadinfo ffff8808d3e1e000, task ffff8808d4060000)
[ 4890.540047] Stack:
[ 4890.540047]  0001000000000000 0000000000000000 ffff8808d3d80e20 fffffffffffffff7
[ 4890.540047]  ffff8808d3e1fd10 ffffffff811ae95c 0000000000350189 00000000001a80c4
[ 4890.540047]  0000000000000000 0000000000000000 ffff8808d3e1fdc0 ffffffff811b0620
[ 4890.540047] Call Trace:
[ 4890.540047]  [<ffffffff811ae95c>] over_bground_thresh+0x7c/0x90
[ 4890.540047]  [<ffffffff811b0620>] wb_do_writeback+0x170/0x310
[ 4890.540047]  [<ffffffff811b08eb>] bdi_writeback_thread+0x12b/0x420
[ 4890.540047]  [<ffffffff811b07c0>] ? wb_do_writeback+0x310/0x310
[ 4890.540047]  [<ffffffff8106deae>] kthread+0xde/0xf0
[ 4890.540047]  [<ffffffff814c6184>] kernel_thread_helper+0x4/0x10
[ 4890.540047]  [<ffffffff814bc1f0>] ? retint_restore_args+0x13/0x13
[ 4890.540047]  [<ffffffff8106ddd0>] ? __init_kthread_worker+0x70/0x70
[ 4890.540047]  [<ffffffff814c6180>] ? gs_change+0x13/0x13
[ 4890.540047] Code: 28 5c 8f c2 f5 28 8b 7d e0 48 89 c6 48 0f af f3 48 c1 ee 02 48 89 f0 48 f7 e1 48 89 d6 31 d2 48 c1 ee 02 48 0f af 75 e8 48 89 f0 <48> f7 f7 41 8b 94 24 74 02 00 00 48 0f af d3 48 89 c7 48 c1 ea 
[ 4890.540047] RIP  [<ffffffff811276f6>] bdi_dirty_limit+0x66/0xc0
[ 4890.540047]  RSP <ffff8808d3e1fcc0>
[ 4890.805627] ---[ end trace 3bdb61d99b220aeb ]---
[ 4890.818925] Broke affinity for irq 76
[ 4890.823921] smpboot: CPU 9 is now offline
[ 4900.238238] general protection fault: 0000 [#2] SMP 
[ 4900.242203] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod iTCO_wdt iTCO_vendor_support coretemp kvm_intel kvm crc32c_intel microcode cdc_ether usbnet i2c_i801 mii tpm_tis pcspkr ioatdma i7core_edac tpm serio_raw i2c_core bnx2 shpchp lpc_ich mfd_core edac_core pci_hotplug dca tpm_bios sg rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[ 4900.248087] CPU 13 
[ 4900.248087] Pid: 0, comm: swapper/13 Tainted: G      D      3.6.0-rc1-tglx-hotplug-0.0.0.28.36b5ec9-default #1 IBM IBM System x -[7870C4Q]-/68Y8033     
[ 4900.248087] RIP: 0010:[<ffffffff810843d7>]  [<ffffffff810843d7>] try_to_wake_up+0x57/0x2f0
[ 4900.248087] RSP: 0018:ffff88117fd43d30  EFLAGS: 00010002
[ 4900.248087] RAX: 6b6b6b6b6b6b6b6b RBX: 000000000000000f RCX: 000000006b6b6b6b
[ 4900.248087] RDX: 000000006b6c6b6b RSI: ffffffff817a7fbf RDI: ffff8808d40607f0
[ 4900.248087] RBP: ffff88117fd43d70 R08: 0000000000000002 R09: 0000000000000001
[ 4900.248087] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8808d4060000
[ 4900.248087] R13: 000000006b6b6b6b R14: ffff8808d3d80e20 R15: 0000000000000000
[ 4900.248087] FS:  0000000000000000(0000) GS:ffff88117fd40000(0000) knlGS:0000000000000000
[ 4900.248087] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 4900.248087] CR2: 00007f472ef5f068 CR3: 0000000001a0c000 CR4: 00000000000007e0
[ 4900.248087] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 4900.248087] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 4900.248087] Process swapper/13 (pid: 0, threadinfo ffff8808d762e000, task ffff8808d7630000)
[ 4900.248087] Stack:
[ 4900.248087]  0000000000000246 ffff8808d40607f0 0000000000000286 ffff8808d762ffd8
[ 4900.248087]  ffff8808d3d80e20 ffff8808d3d811a0 ffff8808d3d80e20 ffffffff8113d970
[ 4900.248087]  ffff88117fd43d80 ffffffff810846a0 ffff88117fd43db0 ffffffff8113da22
[ 4900.248087] Call Trace:
[ 4900.248087]  <IRQ> 
[ 4900.248087]  [<ffffffff8113d970>] ? bdi_init+0x270/0x270
[ 4900.248087]  [<ffffffff810846a0>] wake_up_process+0x10/0x20
[ 4900.248087]  [<ffffffff8113da22>] wakeup_timer_fn+0xb2/0x1c0
[ 4900.248087]  [<ffffffff810557db>] call_timer_fn+0xcb/0x240
[ 4900.248087]  [<ffffffff81055710>] ? detach_if_pending+0x150/0x150
[ 4900.248087]  [<ffffffff8113d970>] ? bdi_init+0x270/0x270
[ 4900.248087]  [<ffffffff81056f75>] run_timer_softirq+0x1c5/0x2c0
[ 4900.248087]  [<ffffffff8104dc79>] __do_softirq+0x159/0x400
[ 4900.248087]  [<ffffffff814c627c>] call_softirq+0x1c/0x30
[ 4900.248087]  [<ffffffff810044f5>] do_softirq+0x95/0xd0
[ 4900.248087]  [<ffffffff8104d745>] irq_exit+0xe5/0x100
[ 4900.248087]  [<ffffffff81028df9>] smp_apic_timer_interrupt+0x69/0xa0
[ 4900.248087]  [<ffffffff814c5aef>] apic_timer_interrupt+0x6f/0x80
[ 4900.248087]  <EOI> 
[ 4900.248087]  [<ffffffff812db3d3>] ? intel_idle+0xc3/0x170
[ 4900.248087]  [<ffffffff812db3d7>] ? intel_idle+0xc7/0x170
[ 4900.248087]  [<ffffffff812db3d3>] ? intel_idle+0xc3/0x170
[ 4900.248087]  [<ffffffff813b1937>] cpuidle_enter+0x17/0x20
[ 4900.248087]  [<ffffffff813b1952>] cpuidle_enter_state+0x12/0x50
[ 4900.248087]  [<ffffffff813b2403>] cpuidle_idle_call+0x133/0x260
[ 4900.248087]  [<ffffffff8100b1f5>] cpu_idle+0x95/0xf0
[ 4900.248087]  [<ffffffff814b1819>] start_secondary+0x85/0x8c
[ 4900.248087] Code: 31 ed 48 89 c7 48 89 45 c8 e8 46 72 43 00 48 89 45 d0 49 8b 04 24 85 c3 0f 84 02 02 00 00 45 8b 6c 24 2c 49 8b 44 24 08 45 85 ed <44> 8b 70 18 74 75 8b 1d dd ea 9d 00 85 db 0f 85 2d 02 00 00 49 
[ 4900.248087] RIP  [<ffffffff810843d7>] try_to_wake_up+0x57/0x2f0
[ 4900.248087]  RSP <ffff88117fd43d30>
[ 4900.248087] ---[ end trace 3bdb61d99b220aec ]---
[ 4900.248087] Kernel panic - not syncing: Fatal exception in interrupt



