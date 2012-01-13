Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759478Ab2AMX2O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:28:14 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:44139 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145Ab2AMX2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:28:11 -0500
Message-ID: <4F10BDF7.8030306@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 04:57:51 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ming Lei <tom.leiming@gmail.com>, Djalal Harouni <tixxdz@opendz.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Tony Luck <tony.luck@intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>,
        gouders@et.bocholt.fh-gelsenkirchen.de,
        Marcos Souza <marcos.mage@gmail.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "tglx@linutronix.de" <tglx@linutronix.de>, prasad@linux.vnet.ibm.com,
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>,
        Suresh B Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Mel Gorman <mgorman@suse.de>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
In-Reply-To: <CA+55aFzGZ_eSTChemYczKr3-0zQ3J3MJ3TfGtxh9wkhSKrrfCA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011313-9264-0000-0000-0000009EB0F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 04:32 AM, Linus Torvalds wrote:

> On Fri, Jan 13, 2012 at 12:22 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>>
>> Fundamentally, this warning is triggered during CPU Offline, which is done
>> during poweroff, suspend, hibernate etc. IOW, even a simple
>> # echo 0 > /sys/devices/system/cpu/cpuX/online will trigger it.
> 
> There is definitely something wrong with CPU hotplug and MCE.
> 
> I seem to be able to trigger not only warnings, but some oopses, by doing:
> 
>  - enable list debugging, slab debugging, and kobject debugging in the
> kernel (I've got some other things enabled too, but I think those are
> the main ones)
> 
>  - do
> 
>      echo 0 > /sys/devices/system/cpu/cpuX/online
> 
>    this gets a few warnings
> 
>  - then do
> 
>      echo 1 > /sys/devices/system/cpu/cpuX/online
> 
> where bringing it up again will crash the machine entirely.
> 


I observed this too; and it is very easy to reproduce.
Here is the log:

# echo 0 > /sys/devices/system/cpu/cpu1/online

[   65.091045] CPU 1 is now offline
[   65.097267] ------------[ cut here ]------------
[   65.102045] WARNING: at drivers/base/core.c:194 device_release+0x82/0x90()
[   65.109137] Hardware name: IBM System x -[7870C4Q]-
[   65.109139] Device 'machinecheck1' does not have a release() function, it is broken and must be fixed.
[   65.109141] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod cdc_ether usbnet i7core_edac edac_core mii serio_raw i2c_i801 shpchp ioatdma iTCO_wdt iTCO_vendor_support dca pci_hotplug pcspkr bnx2 i2c_core tpm_tis tpm tpm_bios sg rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[   65.109195] Pid: 6631, comm: bash Not tainted 3.2.0-debugkernel-0.0.0.28.36b5ec9-default #4
[   65.109197] Call Trace:
[   65.109202]  [<ffffffff8133b462>] ? device_release+0x82/0x90
[   65.109208]  [<ffffffff8103cc2a>] warn_slowpath_common+0x7a/0xb0
[   65.109212]  [<ffffffff8103cd01>] warn_slowpath_fmt+0x41/0x50
[   65.109216]  [<ffffffff8133b462>] device_release+0x82/0x90
[   65.109223]  [<ffffffff8127051e>] ? kobj_kset_leave+0x1e/0x60
[   65.109228]  [<ffffffff8127060d>] kobject_cleanup+0x6d/0x1b0
[   65.109233]  [<ffffffff8127075d>] kobject_release+0xd/0x10
[   65.109237]  [<ffffffff812704ab>] kobject_put+0x2b/0x60
[   65.109241]  [<ffffffff8133ab42>] put_device+0x12/0x20
[   65.109245]  [<ffffffff8133bfc5>] device_unregister+0x25/0x60
[   65.109252]  [<ffffffff8148a22f>] mce_cpu_callback+0x149/0x1a5
[   65.109257]  [<ffffffff8149b4a2>] notifier_call_chain+0x72/0x110
[   65.109263]  [<ffffffff8106bf19>] __raw_notifier_call_chain+0x9/0x10
[   65.109270]  [<ffffffff8147b9b6>] _cpu_down+0x1c6/0x320
[   65.109274]  [<ffffffff8147bb4b>] cpu_down+0x3b/0x60
[   65.109279]  [<ffffffff8147db1d>] store_online+0x6d/0xc8
[   65.109283]  [<ffffffff8133a70b>] dev_attr_store+0x1b/0x20
[   65.109288]  [<ffffffff811ecb04>] sysfs_write_file+0xd4/0x150
[   65.109295]  [<ffffffff81176d1b>] vfs_write+0xcb/0x130
[   65.109299]  [<ffffffff81176e70>] sys_write+0x50/0x90
[   65.109304]  [<ffffffff814a0379>] system_call_fastpath+0x16/0x1b
[   65.109307] ---[ end trace dafb3fda8041063e ]---
[   65.112016] ------------[ cut here ]------------
[   65.112024] WARNING: at arch/x86/kernel/smp.c:120 native_smp_send_reschedule+0x59/0x60()
[   65.112027] Hardware name: IBM System x -[7870C4Q]-
[   65.112028] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod cdc_ether usbnet i7core_edac edac_core mii serio_raw i2c_i801 shpchp ioatdma iTCO_wdt iTCO_vendor_support dca pci_hotplug pcspkr bnx2 i2c_core tpm_tis tpm tpm_bios sg rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[   65.112067] Pid: 2277, comm: udevd Tainted: G        W    3.2.0-debugkernel-0.0.0.28.36b5ec9-default #4
[   65.112070] Call Trace:
[   65.112071]  <IRQ>  [<ffffffff81021349>] ? native_smp_send_reschedule+0x59/0x60
[   65.112079]  [<ffffffff8103cc2a>] warn_slowpath_common+0x7a/0xb0
[   65.112083]  [<ffffffff8103cc75>] warn_slowpath_null+0x15/0x20
[   65.112086]  [<ffffffff81021349>] native_smp_send_reschedule+0x59/0x60
[   65.112092]  [<ffffffff810825f5>] trigger_load_balance+0x185/0x4f0
[   65.112096]  [<ffffffff8108262b>] ? trigger_load_balance+0x1bb/0x4f0
[   65.112101]  [<ffffffff81073617>] scheduler_tick+0x107/0x170
[   65.112107]  [<ffffffff8104e057>] update_process_times+0x67/0x80
[   65.112113]  [<ffffffff8109353f>] tick_sched_timer+0x5f/0xc0
[   65.112117]  [<ffffffff810934e0>] ? tick_nohz_handler+0x100/0x100
[   65.112122]  [<ffffffff8106a05e>] __run_hrtimer+0x12e/0x330
[   65.112126]  [<ffffffff8106a4a7>] hrtimer_interrupt+0xc7/0x1f0
[   65.112131]  [<ffffffff81022f64>] smp_apic_timer_interrupt+0x64/0xa0
[   65.112135]  [<ffffffff814a0eb3>] apic_timer_interrupt+0x73/0x80
[   65.112137]  <EOI>  [<ffffffff8115f788>] ? __slab_alloc+0x228/0x4e0
[   65.112145]  [<ffffffff810654f0>] ? __wake_up_bit+0x10/0x30
[   65.112150]  [<ffffffff8110b7e5>] unlock_page+0x25/0x30
[   65.112157]  [<ffffffff81135f75>] do_wp_page+0x4f5/0x7b0
[   65.112161]  [<ffffffff8113708d>] handle_pte_fault+0x19d/0x1e0
[   65.112165]  [<ffffffff81137248>] handle_mm_fault+0x178/0x2e0
[   65.112169]  [<ffffffff8149b171>] do_page_fault+0x201/0x4c0
[   65.112173]  [<ffffffff8103c109>] ? do_fork+0x179/0x350
[   65.112177]  [<ffffffff8119900e>] ? mntput+0x1e/0x30
[   65.112182]  [<ffffffff811786ef>] ? __fput+0x16f/0x210
[   65.112187]  [<ffffffff8127ae3d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[   65.112192]  [<ffffffff81497905>] page_fault+0x25/0x30
[   65.112195] ---[ end trace dafb3fda8041063f ]---
[   65.541793] CPU 9 MCA banks CMCI:2 CMCI:3 CMCI:5
[   75.472229] lockdep: fixing up alternatives.

The above warning is related to the reschedule IPI sent to an offline cpu.
I guess this is due to the recent changes done to nohz_balancer_kick() and
find_new_ilb() in kernel/sched/fair.c. I had never seen this warning before
3.3 merge window, even during CPU Hotplug stress tests. Now this warning
is seen pretty often during CPU offline.

[Adding Suresh Siddha and Peter Zijlstra to Cc.]

# echo 1 > /sys/devices/system/cpu/cpu1/online

[   75.476772] Booting Node 0 Processor 1 APIC 0x2
[   75.481495] smpboot cpu 1: start_ip = 97000
[   75.492927] Calibrating delay loop (skipped) already calibrated this CPU
[   75.508449] NMI watchdog enabled, takes one hw-pmu counter.
[   75.515402] general protection fault: 0000 [#1] SMP 
[   75.518940] CPU 7 
[   75.518940] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod cdc_ether usbnet i7core_edac edac_core mii serio_raw i2c_i801 shpchp ioatdma iTCO_wdt iTCO_vendor_support dca pci_hotplug pcspkr bnx2 i2c_core tpm_tis tpm tpm_bios sg rtc_cmos button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon
[   75.518940] 
[   75.518940] Pid: 6631, comm: bash Tainted: G        W    3.2.0-debugkernel-0.0.0.28.36b5ec9-default #4 IBM IBM System x -[7870C4Q]-/68Y8033     
[   75.518940] RIP: 0010:[<ffffffff81270779>]  [<ffffffff81270779>] kobject_get+0x19/0x60
[   75.518940] RSP: 0018:ffff8808c6cc7c18  EFLAGS: 00010206
[   75.518940] RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6b7b RCX: 0000000000000006
[   75.518940] RDX: ffffffff81e98ae0 RSI: ffff8808ccc93080 RDI: 6b6b6b6b6b6b6b7b
[   75.518940] RBP: ffff8808c6cc7c28 R08: 5ff145670d8e439e R09: 0000000000000000
[   75.518940] R10: 0000000000000005 R11: 0000000000000001 R12: ffff88114ded3608
[   75.518940] R13: ffffffff81a13440 R14: ffff8808ddc4cb60 R15: 0000000000000001
[   75.518940] FS:  00007f9a3218e700(0000) GS:ffff88117fcc0000(0000) knlGS:0000000000000000
[   75.518940] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   75.518940] CR2: 000000000068a2a0 CR3: 000000114bd59000 CR4: 00000000000006e0
[   75.518940] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   75.518940] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   75.518940] Process bash (pid: 6631, threadinfo ffff8808c6cc6000, task ffff8808c6d9c600)
[   75.518940] Stack:
[   75.518940]  ffff8808ccc93080 ffff88114ded3608 ffff8808c6cc7c38 ffffffff8133ab14
[   75.518940]  ffff8808c6cc7c48 ffffffff8133ddad ffff8808c6cc7c68 ffffffff81478b82
[   75.518940]  ffff88114ded3608 ffff8808ccc93080 ffff8808c6cc7c88 ffffffff81479062
[   75.518940] Call Trace:
[   75.518940]  [<ffffffff8133ab14>] get_device+0x14/0x20
[   75.518940]  [<ffffffff8133ddad>] klist_devices_get+0xd/0x10
[   75.518940]  [<ffffffff81478b82>] klist_node_init+0x42/0x70
[   75.518940]  [<ffffffff81479062>] klist_add_tail+0x22/0x60
[   75.518940]  [<ffffffff8133e76b>] bus_add_device+0x1bb/0x200
[   75.518940]  [<ffffffff8133c7c7>] device_add+0x2e7/0x570
[   75.518940]  [<ffffffff813479e0>] ? device_pm_init+0x70/0xa0
[   75.518940]  [<ffffffff8133ca69>] device_register+0x19/0x20
[   75.518940]  [<ffffffff81489fe6>] mce_device_create+0x8b/0x18b
[   75.518940]  [<ffffffff8148a26d>] mce_cpu_callback+0x187/0x1a5
[   75.518940]  [<ffffffff8149b4a2>] notifier_call_chain+0x72/0x110
[   75.518940]  [<ffffffff8106bf19>] __raw_notifier_call_chain+0x9/0x10
[   75.518940]  [<ffffffff8148db41>] _cpu_up+0x124/0x12a
[   75.518940]  [<ffffffff8148dc03>] cpu_up+0xbc/0x114
[   75.518940]  [<ffffffff8147db45>] store_online+0x95/0xc8
[   75.518940]  [<ffffffff8133a70b>] dev_attr_store+0x1b/0x20
[   75.518940]  [<ffffffff811ecb04>] sysfs_write_file+0xd4/0x150
[   75.518940]  [<ffffffff81176d1b>] vfs_write+0xcb/0x130
[   75.518940]  [<ffffffff81176e70>] sys_write+0x50/0x90
[   75.518940]  [<ffffffff814a0379>] system_call_fastpath+0x16/0x1b
[   75.518940] Code: ff ff 55 48 83 ef 38 48 89 e5 e8 43 fe ff ff c9 c3 90 55 48 89 e5 48 83 ec 10 48 85 ff 48 89 1c 24 4c 89 64 24 08 48 89 fb 74 0f <8b> 47 38 4c 8d 67 38 85 c0 74 1c f0 ff 43 38 48 89 d8 4c 8b 64 
[   75.518940] RIP  [<ffffffff81270779>] kobject_get+0x19/0x60
[   75.518940]  RSP <ffff8808c6cc7c18>
[   75.856395] ---[ end trace dafb3fda80410640 ]---


And in a separate try, I got this during cpu online operation:
(Pretty much the same as above, but with the BUG description present.)

[   83.491328] Booting Node 1 Processor 6 APIC 0x14^M
[   83.496135] smpboot cpu 6: start_ip = 97000^M
[   72.494772] Calibrating delay loop (skipped) already calibrated this CPU^M 
[   83.522491] NMI watchdog enabled, takes one hw-pmu counter.^M
[   83.529016] BUG: unable to handle kernel paging request at 000000350000004a^M
[   83.532868] IP: [<ffffffff8126cac9>] kobject_get+0x19/0x60^M
[   83.532868] PGD 8c7909067 PUD 0 ^M
[   83.532868] Oops: 0000 [#1] SMP ^M
[   83.532868] CPU 0 ^M
[   83.532868] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod ioatdma cdc_ether usbnet bnx2 shpchp mii tpm_tis tpm i7core_edac rtc_cmos serio_raw i2c_i801 dca pcspkr pci_hotplug edac_core i2c_core iTCO_wdt iTCO_vendor_support sg tpm_bios button uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon^M
[   83.532868] ^M
[   83.532868] Pid: 6347, comm: allon_cpu_statu Tainted: G        W    3.2.0-33-default #3 IBM IBM System x -[7870C4Q]-/68Y8033     ^M
[   83.532868] RIP: 0010:[<ffffffff8126cac9>]  [<ffffffff8126cac9>] kobject_get+0x19/0x60^M
[   83.532868] RSP: 0018:ffff8808c78c1c18  EFLAGS: 00010206^M
[   83.532868] RAX: 0000000000000000 RBX: 0000003500000012 RCX: 0000000000000006^M
[   83.532868] RDX: ffffffff81f0f180 RSI: ffff8808c7f01118 RDI: 0000003500000012^M
[   83.532868] RBP: ffff8808c78c1c28 R08: 543148780dbe0391 R09: 0000000000000000^M
[   83.532868] R10: 0000000000000005 R11: 0000000000000001 R12: ffff8808c9f37d38^M
[   83.532868] R13: ffffffff81a13440 R14: ffff88117fc8cb60 R15: 0000000000000006^M
[   83.532868] FS:  00007f7043861700(0000) GS:ffff8808ffc00000(0000) knlGS:0000000000000000^M
[   83.532868] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b^M
[   83.532868] CR2: 000000350000004a CR3: 00000008c7ee9000 CR4: 00000000000006f0^M
[   83.532868] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000^M
[   83.532868] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400^M
[   83.532868] Process allon_cpu_statu (pid: 6347, threadinfo ffff8808c78c0000, task ffff8808ca7c8bc0)^M
[   83.532868] Stack:^M
[   83.532868]  ffff8808c7f01118 ffff8808c9f37d38 ffff8808c78c1c38 ffffffff813362e4^M
[   83.532868]  ffff8808c78c1c48 ffffffff8133951d ffff8808c78c1c68 ffffffff81473db2^M
[   83.532868]  ffff8808c9f37d38 ffff8808c7f01118 ffff8808c78c1c88 ffffffff81474292^M
[   83.532868] Call Trace:^M
[   83.532868]  [<ffffffff813362e4>] get_device+0x14/0x20^M
[   83.532868]  [<ffffffff8133951d>] klist_devices_get+0xd/0x10^M
[   83.532868]  [<ffffffff81473db2>] klist_node_init+0x42/0x70^M
[   83.532868]  [<ffffffff81474292>] klist_add_tail+0x22/0x60^M
[   83.532868]  [<ffffffff81339edb>] bus_add_device+0x1bb/0x200^M
[   83.532868]  [<ffffffff81337f77>] device_add+0x2e7/0x570^M
[   83.532868]  [<ffffffff81343080>] ? device_pm_init+0x70/0xa0^M
[   83.532868]  [<ffffffff81338219>] device_register+0x19/0x20^M
[   83.532868]  [<ffffffff8148537f>] mce_device_create+0x8b/0x18b^M
[   83.532868]  [<ffffffff81485606>] mce_cpu_callback+0x187/0x1a5^M
[   83.532868]  [<ffffffff81496db2>] notifier_call_chain+0x72/0x110^M
[   83.532868]  [<ffffffff8106c1c9>] __raw_notifier_call_chain+0x9/0x10^M
[   83.532868]  [<ffffffff81488dc1>] _cpu_up+0x124/0x12a^M
[   83.532868]  [<ffffffff81488e83>] cpu_up+0xbc/0x114^M
[   83.532868]  [<ffffffff81479065>] store_online+0x95/0xc8^M
[   83.532868]  [<ffffffff81335edb>] dev_attr_store+0x1b/0x20^M
[   83.532868]  [<ffffffff811e9214>] sysfs_write_file+0xd4/0x150^M
[   83.532868]  [<ffffffff81173aeb>] vfs_write+0xcb/0x130^M
[   83.532868]  [<ffffffff81173c40>] sys_write+0x50/0x90^M
[   83.532868]  [<ffffffff8149bc39>] system_call_fastpath+0x16/0x1b^M
[   83.532868] Code: ff ff 55 48 83 ef 38 48 89 e5 e8 43 fe ff ff c9 c3 90 55 48 89 e5 48 83 ec 10 48 85 ff 48 89 1c 24 4c 89 64 24 08 48 89 fb 74 0f <8b> 47 38 4c 8d 67 38 85 c0 74 1c f0 ff 43 38 48 89 d8 4c 8b 64 ^M
[   83.532868] RIP  [<ffffffff8126cac9>] kobject_get+0x19/0x60^M
[   83.532868]  RSP <ffff8808c78c1c18>^M
[   83.532868] CR2: 000000350000004a^M
[   83.890209] ---[ end trace fab5021066ee998d ]---^M


> so it's definitely something bad in MCE device handling, and probably
> something to do with reusing a 'struct device' after freeign it, or
> after not having completely cleaned it up.
> 
> I didn't see if I could spot the problem, but I think this is entirely
> reproducible, so hopefully somebody who knows the MCE code can
> trivially see this and fix it.
> 
>                    Linus
> 

 
Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

