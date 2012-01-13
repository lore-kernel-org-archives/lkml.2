Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab2AMUxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 15:53:49 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:52179 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2AMUxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 15:53:46 -0500
Message-ID: <4F1099CA.7090209@linux.vnet.ibm.com>
Date: Sat, 14 Jan 2012 02:23:30 +0530
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
        justinmattock@gmail.com, Jeff Chua <jeff.chua.linux@gmail.com>
Subject: Re: x86/mce: machine check warning during poweroff
References: <20120111000051.GA28874@dztty> <CACVXFVMZhVFZajbZxng9dJqicy1XCK5n_QZLoefvkLkXvMsSZg@mail.gmail.com> <4F10929E.8070007@linux.vnet.ibm.com> <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com>
In-Reply-To: <CA+55aFwcOgEbnYhs7z+jc-Jq+fWxV3vfSRdfLXBEUC_40BRK0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011310-9264-0000-0000-0000009E8312
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2012 02:07 AM, Linus Torvalds wrote:

> On Fri, Jan 13, 2012 at 12:22 PM, Srivatsa S. Bhat
> <srivatsa.bhat@linux.vnet.ibm.com> wrote:
>> However, it is to be noted that, technically this warning (machinecheck1
>> not having a release() function) is not all that new. Just that people
>> didn't probably notice it earlier (reason explained below).
> 
> .. but there really is some semantic issue going on here. I'm not the
> only one for whom suspend/resume simply does not work with MCE
> enabled, and that "not work" coincides with the switch-over from
> sysdev to struct device.
> 


True. Even Marcos Souza reported that suspend/resume doesn't work with
MCE enabled.

> I suspect it is some subtle difference in sysdev_unregister() vs
> device_unregister(). The message change is just a symptom of the fact
> that we go through different paths.
> 
> For me MCE hangs only on the *second* suspend, but it sounds like
> others see it on the first one.
> 


Wait a minute, did you mention "second attempt"? I think I have something
interesting..

I was trying out the pm_test framework (Documentation/power/basic-pm-
debugging.txt) at the processors level (in which CPUs are offlined).
First attempt succeeded. Second attempt was reproducibly problematic.
And this was with MCE enabled.

Here is the log (covers both first and second attempts at processors level):

[   71.427970] PM: Hibernation mode set to 'reboot'

[  109.588229] PM: Marking nosave pages: 000000000009c000 - 0000000000100000

[  109.595195] PM: Marking nosave pages: 000000007ce5e000 - 000000007cf22000

[  109.602154] PM: Marking nosave pages: 000000007d6ae000 - 000000007d75e000

[  109.609111] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000

[  109.616075] PM: Marking nosave pages: 000000007f800000 - 0000000100000000

[  109.626743] PM: Basic memory bitmaps created

[  109.631179] PM: Syncing filesystems ... done.

[  109.662279] Freezing user space processes ... (elapsed 0.01 seconds) done.

[  109.687212] PM: Preallocating image memory... done (allocated 506656 pages)

[  112.056392] PM: Allocated 2026624 kbytes in 2.36 seconds (858.73 MB/s)

[  112.063046] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.

8.796863] ioatdma 0000:00:16.6: setting latency timer to 64

[  118.796866] uhci_hcd 0000:00:1a.0: setting latency timer to 64

[  118.796870] ioatdma 0000:00:16.7: setting latency timer to 64

[  118.796891] ehci_hcd 0000:00:1a.7: setting latency timer to 64

[  118.796916] uhci_hcd 0000:00:1d.0: setting latency timer to 64

[  118.796932] usb usb3: root hub lost power or was reset

[  118.796952] usb usb4: root hub lost power or was reset

[  118.796954] uhci_hcd 0000:00:1d.1: setting latency timer to 64

[  118.796975] uhci_hcd 0000:00:1d.2: setting latency timer to 64

[  118.796988] usb usb5: root hub lost power or was reset

[  118.797011] ehci_hcd 0000:00:1d.7: setting latency timer to 64

[  118.797014] usb usb6: root hub lost power or was reset

[  118.797035] pci 0000:00:1e.0: setting latency timer to 64

[  118.797055] mptbase: ioc0: pci-resume: pdev=0xffff8808ca39b000, slot=0000:0b:00.0, Previous operating state [D0]

[  118.797069] mptsas 0000:0b:00.0: PCI INT A -> GSI 28 (level, low) -> IRQ 28

[  118.797086] usb usb1: root hub lost power or was reset

[  118.797132] usb usb2: root hub lost power or was reset

[  118.797155] mptbase: ioc0: pci-resume: ioc-state=0x1,doorbell=0x10000000

[  118.797487] pci 0000:06:00.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20

[  118.797498] pci 0000:06:00.0: setting latency timer to 

	SOL session is temporarily not available.

	Attempting to re-establish your session ...



	SOL connection is re-established. SOL session is now active.

[  135.087886] mptbase: ioc0: pci-resume: success

[  135.093612] Extended CMOS year: 2000

[  135.097667] PM: restore of devices complete after 16301.354 msecs

[  135.105915] PM: Image restored successfully.

[  135.110467] Restarting tasks ... done.

[  135.116548] PM: Basic memory bitmaps freed

[  169.935234] PM: Marking nosave pages: 000000000009c000 - 0000000000100000

[  169.942263] PM: Marking nosave pages: 000000007ce5e000 - 000000007cf22000

[  169.949252] PM: Marking nosave pages: 000000007d6ae000 - 000000007d75e000

[  169.956228] PM: Marking nosave pages: 000000007f68f000 - 000000007f7ff000

[  169.963215] PM: Marking nosave pages: 000000007f800000 - 0000000100000000

[  169.973855] PM: Basic memory bitmaps created

[  169.978314] PM: Syncing filesystems ... done.

[  170.045487] Freezing user space processes ... (elapsed 0.01 seconds) done.

[  170.067268] PM: Preallocating image memory... done (allocated 505915 pages)

[  172.421628] PM: Allocated 2023660 kbytes in 2.34 seconds (864.81 MB/s)

[  172.428334] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.

[  172.453631] ------------[ cut here ]------------

[  172.456007] WARNING: at kernel/lockdep.c:956 __bfs+0x1f5/0x270()

[  172.456007] Hardware name: IBM System x -[7870C4Q]-

[  172.456007] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod shpchp i7core_edac cdc_ether i2c_i801 ioatdma bnx2 usbnet iTCO_wdt edac_core pci_hotplug dca i2c_core tpm_tis pcspkr serio_raw tpm mii sg rtc_cmos button iTCO_vendor_support tpm_bios uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon

[  172.456007] Pid: 6166, comm: bash Tainted: G        W    3.2.0-33-default #3

[  172.456007] Call Trace:

[  172.456007]  [<ffffffff81095415>] ? __bfs+0x1f5/0x270

[  172.456007]  [<ffffffff8103ceca>] warn_slowpath_common+0x7a/0xb0

[  172.456007]  [<ffffffff81492bab>] ? _raw_spin_unlock_irq+0x2b/0x50

[  172.456007]  [<ffffffff8103cf15>] warn_slowpath_null+0x15/0x20

[  172.456007]  [<ffffffff81095415>] __bfs+0x1f5/0x270

[  172.456007]  [<ffffffff81095100>] ? noop_count+0x10/0x10

[  172.456007]  [<ffffffff8109892b>] check_usage_backwards+0x6b/0xf0

[  172.456007]  [<ffffffff81496d66>] ? notifier_call_chain+0x26/0x110

[  172.456007]  [<ffffffff810988c0>] ? check_usage_forwards+0x110/0x110

[  172.456007]  [<ffffffff8109930a>] mark_lock_irq+0x9a/0x200

[  172.456007]  [<ffffffff8109957c>] mark_lock+0x10c/0x1b0

[  172.456007]  [<ffffffff81099740>] mark_irqflags+0x120/0x190

[  172.456007]  [<ffffffff8109ae60>] __lock_acquire+0x460/0x520

[  172.456007]  [<ffffffff8109b041>] lock_acquire+0x121/0x190

[  172.456007]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  172.456007]  [<ffffffff81099830>] ? mark_held_locks+0x80/0x120

[  172.456007]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  172.456007]  [<ffffffff814922cc>] _raw_spin_lock+0x3c/0x50

[  172.456007]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  172.456007]  [<ffffffff81473fc0>] klist_next+0x30/0x110

[  172.456007]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  172.456007]  [<ffffffff81336d12>] device_for_each_child+0x52/0x70

[  172.456007]  [<ffffffff81342241>] __device_suspend+0x31/0x2e0

[  172.456007]  [<ffffffff81342550>] dpm_suspend+0x60/0x260

[  172.456007]  [<ffffffff810ad107>] hibernation_snapshot+0xd7/0x1b0

[  172.456007]  [<ffffffff810ad497>] hibernate+0x137/0x260

[  172.456007]  [<ffffffff810aaea4>] state_store+0x114/0x140

[  172.456007]  [<ffffffff8126c3a7>] kobj_attr_store+0x17/0x20

[  172.456007]  [<ffffffff811e9214>] sysfs_write_file+0xd4/0x150

[  172.456007]  [<ffffffff81173aeb>] vfs_write+0xcb/0x130

[  172.456007]  [<ffffffff81173c40>] sys_write+0x50/0x90

[  172.456007]  [<ffffffff8149bc39>] system_call_fastpath+0x16/0x1b

[  172.456007] ---[ end trace b286a5fb903f51e7 ]---

[  172.456007] BUG: unable to handle kernel NULL pointer dereference at 0000000000000010

[  172.456007] IP: [<ffffffff81095309>] __bfs+0xe9/0x270

[  172.456007] PGD 1146b62067 PUD 1147c8b067 PMD 0 

[  172.456007] Oops: 0000 [#1] SMP 

[  172.456007] CPU 2 

[  172.456007] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod shpchp i7core_edac cdc_ether i2c_i801 ioatdma bnx2 usbnet iTCO_wdt edac_core pci_hotplug dca i2c_core tpm_tis pcspkr serio_raw tpm mii sg rtc_cmos button iTCO_vendor_support tpm_bios uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon

[  172.456007] 

[  172.456007] Pid: 6166, comm: bash Tainted: G        W    3.2.0-33-default #3 IBM IBM System x -[7870C4Q]-/68Y8033     

[  172.456007] RIP: 0010:[<ffffffff81095309>]  [<ffffffff81095309>] __bfs+0xe9/0x270

[  172.456007] RSP: 0018:ffff8808c6607ab8  EFLAGS: 00010096

[  172.456007] RAX: 0000000000000000 RBX: ffffffff820aa330 RCX: ffff8808c73b13c0

[  172.456007] RDX: ffff8808c73b13c0 RSI: 0000000000000001 RDI: 0000000000000009

[  172.456007] RBP: ffff8808c6607b18 R08: ffff8808c6607ae8 R09: 0000000000000000

[  172.456007] R10: 0000000000000000 R11: 0000000000000004 R12: 0000000000000000

[  172.456007] R13: 0000000001f87ca6 R14: ffff8808c73b13c0 R15: 0000000000000000

[  172.456007] FS:  00007f46e193a700(0000) GS:ffff8808ffc80000(0000) knlGS:0000000000000000

[  172.456007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033

[  172.456007] CR2: 0000000000000010 CR3: 00000011476b7000 CR4: 00000000000006e0

[  172.456007] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000

[  172.456007] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400

[  172.456007] Process bash (pid: 6166, threadinfo ffff8808c6606000, task ffff8808c73b13c0)

[  172.456007] Stack:

[  172.456007]  ffff8808c6607b18 ffff8808c6607ae8 ffff8808c6607b70 ffffffff81095100

[  172.456007]  0000000000000000 ffffffff816016d0 ffff8808c6607b28 ffff8808c6607b28

[  172.456007]  ffff8808c73b1cc8 ffffffff81779414 ffff8808c73b13c0 ffff8808c73b13c0

[  172.456007] Call Trace:

[  172.456007]  [<ffffffff81095100>] ? noop_count+0x10/0x10

[  172.456007]  [<ffffffff8109892b>] check_usage_backwards+0x6b/0xf0

[  172.456007]  [<ffffffff81496d66>] ? notifier_call_chain+0x26/0x110

[  172.456007]  [<ffffffff810988c0>] ? check_usage_forwards+0x110/0x110

[  172.456007]  [<ffffffff8109930a>] mark_lock_irq+0x9a/0x200

[  172.456007]  [<ffffffff8109957c>] mark_lock+0x10c/0x1b0

[  172.456007]  [<ffffffff81099740>] mark_irqflags+0x120/0x190

[  172.456007]  [<ffffffff8109ae60>] __lock_acquire+0x460/0x520

[  172.456007]  [<ffffffff8109b041>] lock_acquire+0x121/0x190

[  172.456007]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  172.456007]  [<ffffffff81099830>] ? mark_held_locks+0x80/0x120

[  172.456007]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  172.456007]  [<ffffffff814922cc>] _raw_spin_lock+0x3c/0x50

[  172.456007]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  172.456007]  [<ffffffff81473fc0>] klist_next+0x30/0x110

[  172.456007]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  172.456007]  [<ffffffff81336d12>] device_for_each_child+0x52/0x70

[  172.456007]  [<ffffffff81342241>] __device_suspend+0x31/0x2e0

[  172.456007]  [<ffffffff81342550>] dpm_suspend+0x60/0x260

[  172.456007]  [<ffffffff810ad107>] hibernation_snapshot+0xd7/0x1b0

[  172.456007]  [<ffffffff810ad497>] hibernate+0x137/0x260

[  172.456007]  [<ffffffff810aaea4>] state_store+0x114/0x140

[  172.456007]  [<ffffffff8126c3a7>] kobj_attr_store+0x17/0x20

[  172.456007]  [<ffffffff811e9214>] sysfs_write_file+0xd4/0x150

[  172.456007]  [<ffffffff81173aeb>] vfs_write+0xcb/0x130

[  172.456007]  [<ffffffff81173c40>] sys_write+0x50/0x90

[  172.456007]  [<ffffffff8149bc39>] system_call_fastpath+0x16/0x1b

[  172.456007] Code: 00 45 85 ff 48 0f 44 d8 4c 8b 23 49 39 dc 74 aa 4d 89 e5 49 81 ed 80 d6 e0 81 49 c1 fd 06 4c 3b 2d 05 83 d7 00 0f 83 f7 00 00 00 <49> 8b 54 24 10 8b 42 2c 3b 05 d1 01 43 01 0f 84 88 00 00 00 4c 

[  172.456007] RIP  [<ffffffff81095309>] __bfs+0xe9/0x270

[  172.456007]  RSP <ffff8808c6607ab8>

[  172.456007] CR2: 0000000000000010

[  172.456007] ---[ end trace b286a5fb903f51e8 ]---

[  172.456007] BUG: sleeping function called from invalid context at kernel/rwsem.c:21

[  172.456007] in_atomic(): 1, irqs_disabled(): 1, pid: 6166, name: bash

[  172.456007] INFO: lockdep is turned off.

[  172.456007] irq event stamp: 4430551

[  172.456007] hardirqs last  enabled at (4430551): [<ffffffff8148f5ff>] __mutex_unlock_slowpath+0xef/0x180

[  172.456007] hardirqs last disabled at (4430550): [<ffffffff8148f559>] __mutex_unlock_slowpath+0x49/0x180

[  172.456007] softirqs last  enabled at (4424302): [<ffffffff810451be>] __do_softirq+0x21e/0x3a0

[  172.456007] softirqs last disabled at (4424285): [<ffffffff8149d16c>] call_softirq+0x1c/0x30

[  172.456007] Pid: 6166, comm: bash Tainted: G      D W    3.2.0-33-default #3

[  172.456007] Call Trace:

[  172.456007]  [<ffffffff81072992>] __might_sleep+0x152/0x1f0

[  172.456007]  [<ffffffff8149013f>] down_read+0x1f/0x60

[  172.456007]  [<ffffffff810550ff>] exit_signals+0x1f/0x140

[  172.456007]  [<ffffffff8106c411>] ? blocking_notifier_call_chain+0x11/0x20

[  172.456007]  [<ffffffff81042742>] do_exit+0xb2/0x480

[  172.456007]  [<ffffffff81493db4>] oops_end+0xe4/0xf0

[  172.456007]  [<ffffffff8102f609>] no_context+0x119/0x200

[  172.456007]  [<ffffffff8102f83d>] __bad_area_nosemaphore+0x14d/0x220

[  172.456007]  [<ffffffff8102f91e>] bad_area_nosemaphore+0xe/0x10

[  172.456007]  [<ffffffff81496c0e>] do_page_fault+0x38e/0x4c0

[  172.456007]  [<ffffffff8109650d>] ? trace_hardirqs_off+0xd/0x10

[  172.456007]  [<ffffffff8103df92>] ? vprintk+0x362/0x530

[  172.456007]  [<ffffffff8127725d>] ? trace_hardirqs_off_thunk+0x3a/0x3c

[  172.456007]  [<ffffffff814931c5>] page_fault+0x25/0x30

[  172.456007]  [<ffffffff81095309>] ? __bfs+0xe9/0x270

[  172.456007]  [<ffffffff81095415>] ? __bfs+0x1f5/0x270

[  172.456007]  [<ffffffff81095100>] ? noop_count+0x10/0x10

[  172.456007]  [<ffffffff8109892b>] check_usage_backwards+0x6b/0xf0

[  172.456007]  [<ffffffff81496d66>] ? notifier_call_chain+0x26/0x110

[  172.456007]  [<ffffffff810988c0>] ? check_usage_forwards+0x110/0x110

[  172.456007]  [<ffffffff8109930a>] mark_lock_irq+0x9a/0x200

[  172.456007]  [<ffffffff8109957c>] mark_lock+0x10c/0x1b0

[  172.456007]  [<ffffffff81099740>] mark_irqflags+0x120/0x190

[  172.456007]  [<ffffffff8109ae60>] __lock_acquire+0x460/0x520

[  172.456007]  [<ffffffff8109b041>] lock_acquire+0x121/0x190

[  172.456007]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  172.456007]  [<ffffffff81099830>] ? mark_held_locks+0x80/0x120

[  172.456007]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  172.456007]  [<ffffffff814922cc>] _raw_spin_lock+0x3c/0x50

[  172.456007]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  172.456007]  [<ffffffff81473fc0>] klist_next+0x30/0x110

[  172.456007]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  172.456007]  [<ffffffff81336d12>] device_for_each_child+0x52/0x70

[  172.456007]  [<ffffffff81342241>] __device_suspend+0x31/0x2e0

[  172.456007]  [<ffffffff81342550>] dpm_suspend+0x60/0x260

[  172.456007]  [<ffffffff810ad107>] hibernation_snapshot+0xd7/0x1b0

[  172.456007]  [<ffffffff810ad497>] hibernate+0x137/0x260

[  172.456007]  [<ffffffff810aaea4>] state_store+0x114/0x140

[  172.456007]  [<ffffffff8126c3a7>] kobj_attr_store+0x17/0x20

[  172.456007]  [<ffffffff811e9214>] sysfs_write_file+0xd4/0x150

[  172.456007]  [<ffffffff81173aeb>] vfs_write+0xcb/0x130

[  172.456007]  [<ffffffff81173c40>] sys_write+0x50/0x90

[  172.456007]  [<ffffffff8149bc39>] system_call_fastpath+0x16/0x1b

[  172.456007] note: bash[6166] exited with preempt_count 1

[  173.455156] BUG: scheduling while atomic: bash/6166/0x10000002

[  173.461156] INFO: lockdep is turned off.

[  173.465253] Modules linked in: ipv6 cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf microcode fuse loop dm_mod shpchp i7core_edac cdc_ether i2c_i801 ioatdma bnx2 usbnet iTCO_wdt edac_core pci_hotplug dca i2c_core tpm_tis pcspkr serio_raw tpm mii sg rtc_cmos button iTCO_vendor_support tpm_bios uhci_hcd ehci_hcd usbcore usb_common sd_mod crc_t10dif edd ext3 mbcache jbd fan processor mptsas mptscsih mptbase scsi_transport_sas scsi_mod thermal thermal_sys hwmon

[  173.513250] Pid: 6166, comm: bash Tainted: G      D W    3.2.0-33-default #3

[  173.523507] Call Trace:

[  173.526124]  [<ffffffff81073157>] __schedule_bug+0x97/0xa0

[  173.531777]  [<ffffffff814910b5>] __schedule+0x705/0x9a0

[  173.537268]  [<ffffffff8116a8c8>] ? mem_cgroup_update_page_stat+0x148/0x250

[  173.544396]  [<ffffffff8116a7d1>] ? mem_cgroup_update_page_stat+0x51/0x250

[  173.551451]  [<ffffffff81150eba>] ? alloc_pages_current+0xaa/0x120

[  173.557801]  [<ffffffff81492c76>] ? _raw_spin_unlock+0x26/0x40

[  173.563806]  [<ffffffff811336c4>] ? zap_pte_range+0x84/0x3b0

[  173.569634]  [<ffffffff811337f5>] ? zap_pte_range+0x1b5/0x3b0

[  173.575547]  [<ffffffff81496ef6>] ? __atomic_notifier_call_chain+0xa6/0x130

[  173.582689]  [<ffffffff81078af5>] __cond_resched+0x25/0x40

[  173.588345]  [<ffffffff814913dd>] _cond_resched+0x2d/0x40

[  173.593914]  [<ffffffff811342ce>] unmap_page_range+0x25e/0x300

[  173.599921]  [<ffffffff8113443c>] unmap_vmas+0xcc/0x150

[  173.605319]  [<ffffffff81139dbd>] exit_mmap+0x8d/0x120

[  173.610633]  [<ffffffff8103ac3c>] mmput+0x6c/0x150

[  173.615595]  [<ffffffff8103ffca>] exit_mm+0x10a/0x140

[  173.620812]  [<ffffffff81492bab>] ? _raw_spin_unlock_irq+0x2b/0x50

[  173.627168]  [<ffffffff8130f413>] ? tty_audit_exit+0x23/0xa0

[  173.633001]  [<ffffffff810427e3>] do_exit+0x153/0x480

[  173.638224]  [<ffffffff81493db4>] oops_end+0xe4/0xf0

[  173.643358]  [<ffffffff8102f609>] no_context+0x119/0x200

[  173.648848]  [<ffffffff8102f83d>] __bad_area_nosemaphore+0x14d/0x220

[  173.655371]  [<ffffffff8102f91e>] bad_area_nosemaphore+0xe/0x10

[  173.661462]  [<ffffffff81496c0e>] do_page_fault+0x38e/0x4c0

[  173.667204]  [<ffffffff8109650d>] ? trace_hardirqs_off+0xd/0x10

[  173.673291]  [<ffffffff8103df92>] ? vprintk+0x362/0x530

[  173.678684]  [<ffffffff8127725d>] ? trace_hardirqs_off_thunk+0x3a/0x3c

[  173.685385]  [<ffffffff814931c5>] page_fault+0x25/0x30

[  173.690696]  [<ffffffff81095309>] ? __bfs+0xe9/0x270

[  173.695837]  [<ffffffff81095415>] ? __bfs+0x1f5/0x270

[  173.701060]  [<ffffffff81095100>] ? noop_count+0x10/0x10

[  173.706542]  [<ffffffff8109892b>] check_usage_backwards+0x6b/0xf0

[  173.712811]  [<ffffffff81496d66>] ? notifier_call_chain+0x26/0x110

[  173.719141]  [<ffffffff810988c0>] ? check_usage_forwards+0x110/0x110

[  173.725672]  [<ffffffff8109930a>] mark_lock_irq+0x9a/0x200

[  173.731324]  [<ffffffff8109957c>] mark_lock+0x10c/0x1b0

[  173.736723]  [<ffffffff81099740>] mark_irqflags+0x120/0x190

[  173.742466]  [<ffffffff8109ae60>] __lock_acquire+0x460/0x520

[  173.748297]  [<ffffffff8109b041>] lock_acquire+0x121/0x190

[  173.753956]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  173.759523]  [<ffffffff81099830>] ? mark_held_locks+0x80/0x120

[  173.765528]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  173.772079]  [<ffffffff814922cc>] _raw_spin_lock+0x3c/0x50

[  173.777748]  [<ffffffff81473fc0>] ? klist_next+0x30/0x110

[  173.783317]  [<ffffffff81473fc0>] klist_next+0x30/0x110

[  173.788738]  [<ffffffff81341700>] ? device_pm_wait_for_dev+0x40/0x40

[  173.795264]  [<ffffffff81336d12>] device_for_each_child+0x52/0x70

[  173.801534]  [<ffffffff81342241>] __device_suspend+0x31/0x2e0

[  173.807451]  [<ffffffff81342550>] dpm_suspend+0x60/0x260

[  173.812938]  [<ffffffff810ad107>] hibernation_snapshot+0xd7/0x1b0

[  173.819201]  [<ffffffff810ad497>] hibernate+0x137/0x260

[  173.824598]  [<ffffffff810aaea4>] state_store+0x114/0x140

[  173.830168]  [<ffffffff8126c3a7>] kobj_attr_store+0x17/0x20

[  173.835915]  [<ffffffff811e9214>] sysfs_write_file+0xd4/0x150

[  173.841833]  [<ffffffff81173aeb>] vfs_write+0xcb/0x130

[  173.847147]  [<ffffffff81173c40>] sys_write+0x50/0x90

[  173.852376]  [<ffffffff8149bc39>] system_call_fastpath+0x16/0x1b


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center

