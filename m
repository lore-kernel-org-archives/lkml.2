Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab0KNA4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 19:56:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:23891 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0KNA4G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 19:56:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,193,1288594800"; 
   d="scan'208";a="677257513"
Date: Sun, 14 Nov 2010 08:55:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [BUG 2.6.27-rc1] find_busiest_group() LOCKUP
Message-ID: <20101114005558.GA13264@localhost>
References: <20101111124015.GA9706@localhost>
 <1289480656.2084.80.camel@laptop>
 <20101113084018.GA23098@localhost>
 <1289644224.2084.521.camel@laptop>
 <20101113120030.GA31517@localhost>
 <1289653078.2084.675.camel@laptop>
 <20101113131042.GA5522@localhost>
 <4CDEE314.6090107@kernel.org>
 <20101113235746.GA9458@localhost>
 <4CDF2AF3.20902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDF2AF3.20902@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> [PATCH] x86, acpi: Handle all SRAT cpu entries even have cpu num limitaion
> 
> Recent Intel new system have different order in MADT, aka will list all thread0
> at first, then all thread1.
> But SRAT table still old order, it will list cpus in one socket all together.
> 
> If the user have compiled limited NR_CPUS or boot with nr_cpus=, could have missed
> to put some cpus apic id to node mapping into apicid_to_node[].
> 
> for example for 4 sockets system with 64 cpus with nr_cpus=32 will get crash...
> 
> [    9.106288] Total of 32 processors activated (136190.88 BogoMIPS).
> [    9.235021] divide error: 0000 [#1] SMP
> [    9.235315] last sysfs file:
> [    9.235481] CPU 1
> [    9.235592] Modules linked in:
> [    9.245398]
> [    9.245478] Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-tip-yh-01782-ge92ef79-dirty #274      /Sun Fire x4800
> [    9.265415] RIP: 0010:[<ffffffff81075a8f>]  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
> [    9.265835] RSP: 0000:ffff88103f8d1c40  EFLAGS: 00010046
> [    9.285550] RAX: 0000000000000000 RBX: ffff88103f887de0 RCX: 0000000000000000
> [    9.305356] RDX: 0000000000000000 RSI: 0000000000000200 RDI: 0000000000000200
> [    9.305711] RBP: ffff88103f8d1d10 R08: 0000000000000200 R09: ffff88103f887e38
> [    9.325709] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [    9.326038] R13: ffff88107e80dfb0 R14: 0000000000000001 R15: ffff88103f887e40
> [    9.345655] FS:  0000000000000000(0000) GS:ffff88107e800000(0000) knlGS:0000000000000000
> [    9.365503] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    9.365776] CR2: 0000000000000000 CR3: 0000000002417000 CR4: 00000000000006e0
> [    9.385583] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    9.405368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    9.405713] Process kthreadd (pid: 2, threadinfo ffff88103f8d0000, task ffff88305c8aa2d0)
> [    9.425563] Stack:
> [    9.425668]  ffff88103f8d1cb0 0000000000000046 0000000000000000 0000000200000000
> [    9.445509]  0000000000000000 0000000100000000 0000000000000046 ffffffff82bd1ce0
> [    9.465350]  000000015c8aa2d0 00000000001d2540 00000000001d2540 0000007d3f8d1d28
> [    9.465763] Call Trace:
> [    9.465875]  [<ffffffff810747c3>] wake_up_new_task+0x3c/0x10e
> [    9.485486]  [<ffffffff8107b2e3>] do_fork+0x28c/0x35f
> [    9.485753]  [<ffffffff810ab832>] ? __lock_acquire+0x1801/0x1813
> [    9.505474]  [<ffffffff8106f2bd>] ? finish_task_switch+0x80/0xf4
> [    9.525264]  [<ffffffff8106f286>] ? finish_task_switch+0x49/0xf4
> [    9.525575]  [<ffffffff8109da72>] ? local_clock+0x2b/0x3c
> [    9.545281]  [<ffffffff8103da76>] kernel_thread+0x70/0x72
> [    9.545544]  [<ffffffff81097c83>] ? kthread+0x0/0xa8
> [    9.545797]  [<ffffffff81037990>] ? kernel_thread_helper+0x0/0x10
> [    9.565519]  [<ffffffff81098099>] kthreadd+0xe8/0x12b
> [    9.585185]  [<ffffffff81037994>] kernel_thread_helper+0x4/0x10
> [    9.585485]  [<ffffffff81cd793c>] ? restore_args+0x0/0x30
> [    9.605192]  [<ffffffff81097fb1>] ? kthreadd+0x0/0x12b
> [    9.605479]  [<ffffffff81037990>] ? kernel_thread_helper+0x0/0x10
> [    9.625295] Code: a0 be 00 02 00 00 ff c2 48 63 d2 e8 f8 67 3b 00 3b 05 86 8e 52 01 48 89 c7 89 45 c8 7c c1 48 8b 45 b0 8b 4b 08 31 d2 48 c1 e0 0a <48> f7 f1 45 85 e4 75 08 48 3b 45 b8 72 08 eb 0d 48 89 45 a8 eb
> [    9.645938] RIP  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
> [    9.665356]  RSP <ffff88103f8d1c40>
> [    9.665568] ---[ end trace 2296156d35fdfc87 ]---
> 
> So let just parse all cpu entries in SRAT.
> 
> Also add apicid checking with MAX_LOCAL_APIC, in case We could out of boundaries of
> apicid_to_node[].
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Tested-by: Wu Fengguang <fengguang.wu@intel.com>

Both boxes boot OK with CONFIG_NR_CPUS=8 and CONFIG_NR_CPUS=64.

Thanks,
Fengguang
---

dmesg with CONFIG_NR_CPUS=8

[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 167772160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2799.940 MHz processor.
[    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5599.88 BogoMIPS (lpj=2799940)
[    0.010819] pid_max: default: 32768 minimum: 301
[    0.021732] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.035635] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.044541] Mount-cache hash table entries: 256
[    0.049461] Initializing cgroup subsys debug
[    0.053828] Initializing cgroup subsys ns
[    0.057931] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.066961] Initializing cgroup subsys cpuacct
[    0.071510] Initializing cgroup subsys memory
[    0.075988] Initializing cgroup subsys devices
[    0.080527] Initializing cgroup subsys freezer
[    0.085106] CPU: Physical Processor ID: 0
[    0.089210] CPU: Processor Core ID: 0
[    0.092975] mce: CPU supports 9 MCE banks
[    0.097097] CPU0: Thermal monitoring enabled (TM1)
[    0.101989] using mwait in idle threads.
[    0.106006] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.113534] ... version:                3
[    0.117641] ... bit width:              48
[    0.121826] ... generic registers:      4
[    0.125927] ... value mask:             0000ffffffffffff
[    0.131328] ... max period:             000000007fffffff
[    0.136733] ... fixed-purpose events:   3
[    0.140840] ... event mask:             000000070000000f
[    0.147296] ACPI: Core revision 20101013
[    0.175763] ftrace: allocating 24175 entries in 95 pages
[    0.191023] Setting APIC routing to flat
[    0.195686] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.211760] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
[    0.325235] lockdep: fixing up alternatives.
[    0.330234] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.430133]  #2lockdep: fixing up alternatives.
[    0.526952]  #3lockdep: fixing up alternatives.
[    0.623746]  #4lockdep: fixing up alternatives.
[    0.720587]  #5lockdep: fixing up alternatives.
[    0.817387]  Ok.
[    0.819325] Booting Node   1, Processors  #6
[    0.914091] TSC synchronization [CPU#0 -> CPU#6]:
[    0.919156] Measured 972 cycles TSC warp between CPUs, turning off TSC clock.
[    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.556039] lockdep: fixing up alternatives.
[    0.557053]  #7 Ok.
[    0.629167] Brought up 8 CPUs
[    0.630006] Total of 8 processors activated (44799.04 BogoMIPS).
[    0.631048] Testing NMI watchdog ... OK.
[    0.654090] CPU0 attaching sched-domain:
[    0.655007]  domain 0: span 0-5 level MC
[    0.658004]   groups: 0 1 2 3 4 5
[    0.660489]   domain 1: span 0-7 level NODE
[    0.662006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.665289] CPU1 attaching sched-domain:
[    0.666006]  domain 0: span 0-5 level MC
[    0.668006]   groups: 1 2 3 4 5 0
[    0.671503]   domain 1: span 0-7 level NODE
[    0.673006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.676287] CPU2 attaching sched-domain:
[    0.677006]  domain 0: span 0-5 level MC
[    0.679005]   groups: 2 3 4 5 0 1
[    0.682288]   domain 1: span 0-7 level NODE
[    0.684006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.689285] CPU3 attaching sched-domain:
[    0.690004]  domain 0: span 0-5 level MC
[    0.692003]   groups: 3 4 5 0 1 2
[    0.695004]   domain 1: span 0-7 level NODE
[    0.697006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.703007] CPU4 attaching sched-domain:
[    0.704004]  domain 0: span 0-5 level MC
[    0.706003]   groups: 4 5 0 1 2 3
[    0.708926]   domain 1: span 0-7 level NODE
[    0.710003]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.713284] CPU5 attaching sched-domain:
[    0.714006]  domain 0: span 0-5 level MC
[    0.716005]   groups: 5 0 1 2 3 4
[    0.718718]   domain 1: span 0-7 level NODE
[    0.720004]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.723285] CPU6 attaching sched-domain:
[    0.724006]  domain 0: span 6-7 level MC
[    0.726005]   groups: 6 7
[    0.727714]   domain 1: span 0-7 level NODE
[    0.729005]    groups: 6-7 (cpu_power = 2048) 0-5 (cpu_power = 6144)
[    0.732287] CPU7 attaching sched-domain:
[    0.733006]  domain 0: span 6-7 level MC
[    0.735005]   groups: 7 6
[    0.737496]   domain 1: span 0-7 level NODE
[    0.739006]    groups: 6-7 (cpu_power = 2048) 0-5 (cpu_power = 6144)
[    0.743198] kworker/u:0 used greatest stack depth: 6256 bytes left
[    0.749763] kworker/u:0 used greatest stack depth: 6072 bytes left
[    0.781489] Time:  8:41:28  Date: 11/14/10
[    0.782100] NET: Registered protocol family 16
[    0.785102] ACPI: bus type pci registered
[    0.787495] dca service started, version 1.12.1
[    0.788092] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    0.790007] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    0.885600] PCI: Using configuration type 1 for base access
[    0.944365] ACPI: EC: Look up EC in DSDT
[    0.947813] \_SB_:_OSC evaluation returned wrong type
[    0.948007] _OSC request data:1 6
[    0.955612] ACPI: Executed 1 blocks of module-level executable AML code
[    0.989443] ACPI: SSDT 00000000bf416018 01494 (v01    AMI      IST 00000001 MSFT 03000001)
[    0.998909] ACPI: Dynamic OEM Table Load:
[    1.001004] ACPI: SSDT           (null) 01494 (v01    AMI      IST 00000001 MSFT 03000001)
[    1.012963] ACPI: Interpreter enabled
[    1.013008] ACPI: (supports S0 S5)
[    1.015371] ACPI: Using IOAPIC for interrupt routing
[    1.025532] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.082704] ACPI: No dock devices found.
[    1.083009] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.085104] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.087316] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.088009] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.089009] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.090007] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    1.091028] pci 0000:00:00.0: [8086:3406] type 0 class 0x000600
[    1.092066] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.093009] pci 0000:00:00.0: PME# disabled
[    1.094038] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    1.095063] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.096008] pci 0000:00:01.0: PME# disabled
[    1.097034] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    1.099024] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.100006] pci 0000:00:03.0: PME# disabled
[    1.101037] pci 0000:00:05.0: [8086:340c] type 1 class 0x000604
[    1.102066] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.103008] pci 0000:00:05.0: PME# disabled
[    1.104038] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    1.105063] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.106006] pci 0000:00:07.0: PME# disabled
[    1.107037] pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
[    1.108066] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.109009] pci 0000:00:09.0: PME# disabled
[    1.110036] pci 0000:00:13.0: [8086:342d] type 0 class 0x000800
[    1.111017] pci 0000:00:13.0: reg 10: [mem 0xfbe24000-0xfbe24fff]
[    1.112063] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.113009] pci 0000:00:13.0: PME# disabled
[    1.114036] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    1.115086] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    1.116088] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    1.117088] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    1.118088] pci 0000:00:16.0: [8086:3430] type 0 class 0x000880
[    1.119021] pci 0000:00:16.0: reg 10: [mem 0xfbe1c000-0xfbe1ffff 64bit]
[    1.120085] pci 0000:00:16.1: [8086:3431] type 0 class 0x000880
[    1.121018] pci 0000:00:16.1: reg 10: [mem 0xfbe18000-0xfbe1bfff 64bit]
[    1.122095] pci 0000:00:16.2: [8086:3432] type 0 class 0x000880
[    1.123019] pci 0000:00:16.2: reg 10: [mem 0xfbe14000-0xfbe17fff 64bit]
[    1.125055] pci 0000:00:16.3: [8086:3433] type 0 class 0x000880
[    1.126029] pci 0000:00:16.3: reg 10: [mem 0xfbe10000-0xfbe13fff 64bit]
[    1.127090] pci 0000:00:16.4: [8086:3429] type 0 class 0x000880
[    1.128021] pci 0000:00:16.4: reg 10: [mem 0xfbe0c000-0xfbe0ffff 64bit]
[    1.129087] pci 0000:00:16.5: [8086:342a] type 0 class 0x000880
[    1.130021] pci 0000:00:16.5: reg 10: [mem 0xfbe08000-0xfbe0bfff 64bit]
[    1.131090] pci 0000:00:16.6: [8086:342b] type 0 class 0x000880
[    1.132021] pci 0000:00:16.6: reg 10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    1.133088] pci 0000:00:16.7: [8086:342c] type 0 class 0x000880
[    1.134021] pci 0000:00:16.7: reg 10: [mem 0xfbe00000-0xfbe03fff 64bit]
[    1.135092] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    1.136057] pci 0000:00:1a.0: reg 20: [io  0xf0c0-0xf0df]
[    1.137064] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    1.139003] pci 0000:00:1a.2: reg 20: [io  0xf0a0-0xf0bf]
[    1.140085] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    1.141031] pci 0000:00:1a.7: reg 10: [mem 0xfbe23000-0xfbe233ff]
[    1.142095] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.143007] pci 0000:00:1a.7: PME# disabled
[    1.144030] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    1.145077] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.146009] pci 0000:00:1c.0: PME# disabled
[    1.147040] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    1.148095] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.149007] pci 0000:00:1c.4: PME# disabled
[    1.150037] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    1.151059] pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
[    1.152065] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    1.153056] pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
[    1.154062] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    1.156009] pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
[    1.157078] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    1.158030] pci 0000:00:1d.7: reg 10: [mem 0xfbe22000-0xfbe223ff]
[    1.159095] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.160008] pci 0000:00:1d.7: PME# disabled
[    1.161029] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    1.162089] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    1.163097] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.164009] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.165009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    1.166009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    1.167009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    1.168006] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    1.169054] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    1.171028] pci 0000:00:1f.2: reg 10: [io  0xf110-0xf117]
[    1.172015] pci 0000:00:1f.2: reg 14: [io  0xf100-0xf103]
[    1.173015] pci 0000:00:1f.2: reg 18: [io  0xf0f0-0xf0f7]
[    1.174015] pci 0000:00:1f.2: reg 1c: [io  0xf0e0-0xf0e3]
[    1.175015] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    1.176014] pci 0000:00:1f.2: reg 24: [mem 0xfbe21000-0xfbe217ff]
[    1.177048] pci 0000:00:1f.2: PME# supported from D3hot
[    1.178007] pci 0000:00:1f.2: PME# disabled
[    1.179033] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    1.180024] pci 0000:00:1f.3: reg 10: [mem 0xfbe20000-0xfbe200ff 64bit]
[    1.181029] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    1.182105] pci 0000:01:00.0: [8086:10c9] type 0 class 0x000200
[    1.183021] pci 0000:01:00.0: reg 10: [mem 0xfbaa0000-0xfbabffff]
[    1.184014] pci 0000:01:00.0: reg 14: [mem 0xfba80000-0xfba9ffff]
[    1.185014] pci 0000:01:00.0: reg 18: [io  0xe020-0xe03f]
[    1.186015] pci 0000:01:00.0: reg 1c: [mem 0xfbb44000-0xfbb47fff]
[    1.187034] pci 0000:01:00.0: reg 30: [mem 0xfba60000-0xfba7ffff pref]
[    1.188042] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.189009] pci 0000:01:00.0: PME# disabled
[    1.190054] pci 0000:01:00.1: [8086:10c9] type 0 class 0x000200
[    1.191018] pci 0000:01:00.1: reg 10: [mem 0xfba40000-0xfba5ffff]
[    1.192016] pci 0000:01:00.1: reg 14: [mem 0xfba20000-0xfba3ffff]
[    1.193014] pci 0000:01:00.1: reg 18: [io  0xe000-0xe01f]
[    1.194015] pci 0000:01:00.1: reg 1c: [mem 0xfbb40000-0xfbb43fff]
[    1.196028] pci 0000:01:00.1: reg 30: [mem 0xfba00000-0xfba1ffff pref]
[    1.197042] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    1.198009] pci 0000:01:00.1: PME# disabled
[    1.199023] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.200009] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.201009] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    1.202011] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.204037] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    1.205007] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.206008] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.207013] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.208054] pci 0000:00:05.0: PCI bridge to [bus 04-04]
[    1.209006] pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.210006] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.211008] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.212054] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    1.213009] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.214007] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.215010] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.216063] pci 0000:06:00.0: [8086:0329] type 1 class 0x000604
[    1.217026] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.218066] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.219009] pci 0000:06:00.0: PME# disabled
[    1.221036] pci 0000:06:00.2: [8086:032a] type 1 class 0x000604
[    1.222028] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    1.223084] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    1.224007] pci 0000:06:00.2: PME# disabled
[    1.225024] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    1.226009] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    1.227006] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    1.228011] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.229094] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    1.230009] pci 0000:06:00.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.231009] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.232011] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.233060] pci 0000:08:01.0: [8086:1229] type 0 class 0x000200
[    1.234022] pci 0000:08:01.0: reg 10: [mem 0xfb900000-0xfb900fff]
[    1.235016] pci 0000:08:01.0: reg 14: [io  0xd000-0xd03f]
[    1.236018] pci 0000:08:01.0: reg 18: [mem 0xfb800000-0xfb8fffff]
[    1.237042] pci 0000:08:01.0: reg 30: [mem 0xfb700000-0xfb7fffff pref]
[    1.238026] pci 0000:08:01.0: supports D1 D2
[    1.239004] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.240010] pci 0000:08:01.0: PME# disabled
[    1.241056] pci 0000:06:00.2: PCI bridge to [bus 08-08]
[    1.242009] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    1.243009] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    1.244011] pci 0000:06:00.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.245089] pci 0000:09:00.0: [1000:0058] type 0 class 0x000100
[    1.246020] pci 0000:09:00.0: reg 10: [io  0xc000-0xc0ff]
[    1.247023] pci 0000:09:00.0: reg 14: [mem 0xfb610000-0xfb613fff 64bit]
[    1.248024] pci 0000:09:00.0: reg 1c: [mem 0xfb600000-0xfb60ffff 64bit]
[    1.249026] pci 0000:09:00.0: reg 30: [mem 0xfb400000-0xfb5fffff pref]
[    1.250043] pci 0000:09:00.0: supports D1 D2
[    1.251023] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    1.252009] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.253009] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    1.254011] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.255094] pci 0000:0a:00.0: [197b:2368] type 0 class 0x000101
[    1.256025] pci 0000:0a:00.0: reg 10: [io  0xb040-0xb047]
[    1.257020] pci 0000:0a:00.0: reg 14: [io  0xb030-0xb033]
[    1.258018] pci 0000:0a:00.0: reg 18: [io  0xb020-0xb027]
[    1.259020] pci 0000:0a:00.0: reg 1c: [io  0xb010-0xb013]
[    1.260018] pci 0000:0a:00.0: reg 20: [io  0xb000-0xb00f]
[    1.261034] pci 0000:0a:00.0: reg 30: [mem 0xfbd00000-0xfbd0ffff pref]
[    1.262073] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    1.263009] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    1.264009] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    1.265011] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.266053] pci 0000:0b:01.0: [1002:515e] type 0 class 0x000300
[    1.267024] pci 0000:0b:01.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    1.269005] pci 0000:0b:01.0: reg 14: [io  0xa000-0xa0ff]
[    1.270017] pci 0000:0b:01.0: reg 18: [mem 0xfbc20000-0xfbc2ffff]
[    1.271046] pci 0000:0b:01.0: reg 30: [mem 0xfbc00000-0xfbc1ffff pref]
[    1.272026] pci 0000:0b:01.0: supports D1 D2
[    1.273060] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    1.274009] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    1.275007] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.276012] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    1.278007] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.279010] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.280006] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.281008] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    1.282052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.285609] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    1.286405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.288229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    1.289305] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    1.290273] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHA._PRT]
[    1.291353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHB._PRT]
[    1.385410] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.390082] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.394630] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.398216] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    1.403037] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    1.407798] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    1.411487] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    1.415492] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.420107] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    1.421009] vgaarb: loaded
[    1.423486] usbcore: registered new interface driver usbfs
[    1.424058] usbcore: registered new interface driver hub
[    1.426138] usbcore: registered new device driver usb
[    1.429088] wmi: Mapper loaded
[    1.430140] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    1.431006] PCI: Using ACPI for IRQ routing
[    1.432008] PCI: pci_cache_line_size set to 64 bytes
[    1.434021] reserve RAM buffer: 000000000009c400 - 000000000009ffff
[    1.435007] reserve RAM buffer: 00000000bf30b000 - 00000000bfffffff
[    1.436024] reserve RAM buffer: 00000000bf3de000 - 00000000bfffffff
[    1.437016] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
[    1.439222] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.442287] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.445007] Switching to clocksource hpet
[    1.446911] Warning: could not register all branches stats
[    1.452510] Warning: could not register annotated branches stats
[    1.498386] pnp: PnP ACPI init
[    1.501583] ACPI: bus type pnp registered
[    1.505953] pnp 00:00: [bus 00-ff]
[    1.509464] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.513665] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.518468] pnp 00:00: [io  0x0d00-0xffff window]
[    1.523278] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.528783] pnp 00:00: [mem 0x00000000 window]
[    1.533331] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    1.539342] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.546775] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    1.551680] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    1.556584] pnp 00:01: [mem 0xfe000000-0xfe9fffff]
[    1.561490] pnp 00:01: [mem 0xfea00000-0xfea0001f]
[    1.566394] pnp 00:01: [mem 0xfeb00000-0xfebfffff]
[    1.571301] pnp 00:01: [mem 0xfed00400-0xfed3ffff]
[    1.576207] pnp 00:01: [mem 0xfed45000-0xfedfffff]
[    1.581592] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.589088] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.595136] pnp 00:02: [io  0x0290-0x029f]
[    1.599345] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.605445] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.611486] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.618080] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.624831] pnp 00:03: [io  0x0060]
[    1.628429] pnp 00:03: [io  0x0064]
[    1.632044] pnp 00:03: [irq 1]
[    1.635579] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.643182] pnp 00:04: [irq 12]
[    1.646715] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    1.659113] pnp 00:05: [io  0x03f8-0x03ff]
[    1.663418] pnp 00:05: [irq 4]
[    1.666591] pnp 00:05: [dma 0 disabled]
[    1.671198] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.680838] pnp 00:06: [io  0x02f8-0x02ff]
[    1.685061] pnp 00:06: [irq 3]
[    1.688228] pnp 00:06: [dma 0 disabled]
[    1.692621] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.700579] pnp 00:07: [dma 4]
[    1.703745] pnp 00:07: [io  0x0000-0x000f]
[    1.707947] pnp 00:07: [io  0x0081-0x0083]
[    1.713737] pnp 00:07: [io  0x0087]
[    1.717333] pnp 00:07: [io  0x0089-0x008b]
[    1.721535] pnp 00:07: [io  0x008f]
[    1.725132] pnp 00:07: [io  0x00c0-0x00df]
[    1.729742] pnp 00:07: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.736422] pnp 00:08: [io  0x0070-0x0071]
[    1.740638] pnp 00:08: [irq 8]
[    1.744286] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.750967] pnp 00:09: [io  0x0061]
[    1.754921] pnp 00:09: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.761634] pnp 00:0a: [io  0x0010-0x001f]
[    1.765843] pnp 00:0a: [io  0x0022-0x003f]
[    1.770054] pnp 00:0a: [io  0x0044-0x005f]
[    1.774257] pnp 00:0a: [io  0x0062-0x0063]
[    1.778460] pnp 00:0a: [io  0x0065-0x006f]
[    1.782665] pnp 00:0a: [io  0x0072-0x007f]
[    1.786876] pnp 00:0a: [io  0x0080]
[    1.790462] pnp 00:0a: [io  0x0084-0x0086]
[    1.794659] pnp 00:0a: [io  0x0088]
[    1.798246] pnp 00:0a: [io  0x008c-0x008e]
[    1.802443] pnp 00:0a: [io  0x0090-0x009f]
[    1.806635] pnp 00:0a: [io  0x00a2-0x00bf]
[    1.810832] pnp 00:0a: [io  0x00e0-0x00ef]
[    1.815035] pnp 00:0a: [io  0x04d0-0x04d1]
[    1.819726] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.826404] pnp 00:0b: [io  0x00f0-0x00ff]
[    1.830616] pnp 00:0b: [irq 13]
[    1.834296] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.842492] pnp 00:0c: [io  0x0400-0x047f]
[    1.846704] pnp 00:0c: [io  0x1180-0x119f]
[    1.850916] pnp 00:0c: [io  0x0500-0x057f]
[    1.855129] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    1.860035] pnp 00:0c: [mem 0xfec00000-0xfecfffff]
[    1.864930] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    1.870501] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.877732] pnp 00:0d: [mem 0xfed00000-0xfed003ff]
[    1.883130] pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.890606] pnp: PnP ACPI: found 14 devices
[    1.894899] ACPI: ACPI bus type pnp unregistered
[    1.899642] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    1.906371] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    1.913100] system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
[    1.919830] system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
[    1.926557] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
[    1.933286] system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    1.940356] system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
[    1.947080] system 00:02: [io  0x0290-0x029f] has been reserved
[    1.953113] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    1.959142] system 00:0c: [io  0x0400-0x047f] has been reserved
[    1.965166] system 00:0c: [io  0x1180-0x119f] has been reserved
[    1.971190] system 00:0c: [io  0x0500-0x057f] could not be reserved
[    1.977561] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.984279] system 00:0c: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.991343] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    2.033870] pci 0000:00:1c.0: BAR 9: assigned [mem 0xfee00000-0xfeffffff 64bit pref]
[    2.041811] pci 0000:00:1c.4: BAR 9: assigned [mem 0xfb200000-0xfb3fffff 64bit pref]
[    2.049742] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.055088] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.061308] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    2.068223] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    2.074439] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    2.079786] pci 0000:00:03.0:   bridge window [io  disabled]
[    2.085573] pci 0000:00:03.0:   bridge window [mem disabled]
[    2.091353] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    2.097562] pci 0000:00:05.0: PCI bridge to [bus 04-04]
[    2.102887] pci 0000:00:05.0:   bridge window [io  disabled]
[    2.108653] pci 0000:00:05.0:   bridge window [mem disabled]
[    2.114414] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    2.120616] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    2.125941] pci 0000:00:07.0:   bridge window [io  disabled]
[    2.131707] pci 0000:00:07.0:   bridge window [mem disabled]
[    2.137469] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    2.143669] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    2.148994] pci 0000:06:00.0:   bridge window [io  disabled]
[    2.154760] pci 0000:06:00.0:   bridge window [mem disabled]
[    2.160522] pci 0000:06:00.0:   bridge window [mem pref disabled]
[    2.166723] pci 0000:06:00.2: PCI bridge to [bus 08-08]
[    2.172049] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    2.178250] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    2.185140] pci 0000:06:00.2:   bridge window [mem pref disabled]
[    2.191338] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    2.196663] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    2.202863] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    2.209753] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    2.215951] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    2.221276] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    2.227476] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    2.234366] pci 0000:00:1c.0:   bridge window [mem 0xfee00000-0xfeffffff 64bit pref]
[    2.242280] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    2.247605] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    2.253807] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.260697] pci 0000:00:1c.4:   bridge window [mem 0xfb200000-0xfb3fffff 64bit pref]
[    2.268613] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    2.273945] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    2.280149] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    2.287044] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    2.294982] pci 0000:00:01.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    2.301788] pci 0000:00:01.0: setting latency timer to 64
[    2.307311] pci 0000:00:03.0: PCI INT A -> GSI 72 (level, low) -> IRQ 72
[    2.314120] pci 0000:00:03.0: setting latency timer to 64
[    2.319642] pci 0000:00:05.0: PCI INT A -> GSI 74 (level, low) -> IRQ 74
[    2.326452] pci 0000:00:05.0: setting latency timer to 64
[    2.331967] pci 0000:00:07.0: PCI INT A -> GSI 78 (level, low) -> IRQ 78
[    2.338777] pci 0000:00:07.0: setting latency timer to 64
[    2.344291] pci 0000:00:09.0: PCI INT A -> GSI 80 (level, low) -> IRQ 80
[    2.351100] pci 0000:00:09.0: setting latency timer to 64
[    2.356610] pci 0000:06:00.0: setting latency timer to 64
[    2.362120] pci 0000:06:00.2: setting latency timer to 64
[    2.367639] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.374449] pci 0000:00:1c.0: setting latency timer to 64
[    2.379957] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.386763] pci 0000:00:1c.4: setting latency timer to 64
[    2.392270] pci 0000:00:1e.0: setting latency timer to 64
[    2.397775] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.403451] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.409128] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.415499] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    2.421868] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    2.427543] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    2.433917] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    2.439591] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    2.445963] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    2.451637] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    2.458012] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    2.463685] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    2.470056] pci_bus 0000:09: resource 2 [mem 0xfee00000-0xfeffffff 64bit pref]
[    2.477448] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    2.483125] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    2.489496] pci_bus 0000:0a: resource 2 [mem 0xfb200000-0xfb3fffff 64bit pref]
[    2.496887] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    2.502564] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    2.508936] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    2.516326] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    2.522010] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    2.527680] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    2.534052] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    2.540468] NET: Registered protocol family 2
[    2.546640] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    2.558372] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.569565] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    2.578550] TCP: Hash tables configured (established 524288 bind 65536)
[    2.585277] TCP reno registered
[    2.589146] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    2.596645] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    2.604388] NET: Registered protocol family 1
[    2.609457] RPC: Registered udp transport module.
[    2.614289] RPC: Registered tcp transport module.
[    2.619098] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.625723] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x003f
[    2.632351] pci 0000:00:1a.0: Performing full reset
[    2.637348] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x003f
[    2.643982] pci 0000:00:1a.2: Performing full reset
[    2.649044] pci 0000:00:1a.7: EHCI: BIOS handoff
[    2.675080] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x103f
[    2.681712] pci 0000:00:1d.0: Performing full reset
[    2.686706] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x003f
[    2.693340] pci 0000:00:1d.1: Performing full reset
[    2.698336] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x003f
[    2.704971] pci 0000:00:1d.2: Performing full reset
[    2.710019] pci 0000:00:1d.7: EHCI: BIOS handoff
[    2.736196] pci 0000:0b:01.0: Boot video device
[    2.740838] PCI: CLS 64 bytes, default 64
[    2.745118] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.751673] Placing 64MB software IO TLB between ffff8800b8400000 - ffff8800bc400000
[    2.759588] software IO TLB at phys 0xb8400000 - 0xbc400000
[    2.782679] Machine check injector initialized
[    2.795756] microcode: CPU0 sig=0x206c1, pf=0x1, revision=0x3
[    2.801628] microcode: CPU1 sig=0x206c1, pf=0x1, revision=0x3
[    2.807489] microcode: CPU2 sig=0x206c1, pf=0x1, revision=0x3
[    2.814935] microcode: CPU3 sig=0x206c1, pf=0x1, revision=0x3
[    2.820793] microcode: CPU4 sig=0x206c1, pf=0x1, revision=0x3
[    2.826649] microcode: CPU5 sig=0x206c1, pf=0x1, revision=0x3
[    2.832512] microcode: CPU6 sig=0x206c1, pf=0x1, revision=0x3
[    2.838384] microcode: CPU7 sig=0x206c1, pf=0x1, revision=0x3
[    2.844635] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.853600] Scanning for low memory corruption every 60 seconds
[    2.863689] Initializing RT-Tester: OK
[    2.867598] audit: initializing netlink socket (disabled)
[    2.873170] type=2000 audit(1289724087.872:1): initialized
[    2.888369] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.896483] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.907826] fuse init (API version 7.15)
[    2.912297] msgmni has been set to 32003
[    2.922514] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1c
[    2.929083] pcieport 0000:00:01.0: setting latency timer to 64
[    2.935093] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[    2.943229] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1c
[    2.949795] pcieport 0000:00:03.0: setting latency timer to 64
[    2.955795] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[    2.964420] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1c
[    2.970993] pcieport 0000:00:05.0: setting latency timer to 64
[    2.976991] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[    2.985580] pcieport 0000:00:07.0: ACPI _OSC control granted for 0x1c
[    2.992161] pcieport 0000:00:07.0: setting latency timer to 64
[    2.998162] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[    3.006384] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1c
[    3.012949] pcieport 0000:00:09.0: setting latency timer to 64
[    3.018948] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[    3.027334] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    3.033905] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.039910] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[    3.048224] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1c
[    3.054791] pcieport 0000:00:1c.4: setting latency timer to 64
[    3.060796] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[    3.067621] aer 0000:00:01.0:pcie02: service driver aer loaded
[    3.073753] aer 0000:00:03.0:pcie02: service driver aer loaded
[    3.079764] aer 0000:00:05.0:pcie02: service driver aer loaded
[    3.085766] aer 0000:00:07.0:pcie02: service driver aer loaded
[    3.091896] aer 0000:00:09.0:pcie02: service driver aer loaded
[    3.098270] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.106750] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    3.115122] ACPI: Sleep Button [SLPB]
[    3.119574] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.127950] ACPI: Power Button [PWRB]
[    3.132257] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    3.139841] ACPI: Power Button [PWRF]
[    3.145532] ACPI: acpi_idle registered with cpuidle
[    3.151903] Monitor-Mwait will be used to enter C-3 state
[    3.157552] Monitor-Mwait will be used to enter C-3 state
[    3.482280] Initializing Nozomi driver 2.1d (build date: Nov 14 2010 08:33:37)
[    3.493205] Non-volatile memory driver v1.3
[    3.498085] Linux agpgart interface v0.103
[    3.502559] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    3.511696] Hangcheck: Using getrawmonotonic().
[    3.516600] [drm] Initialized drm 1.1.0 20060810
[    3.521330] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    3.528988] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.556138] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.599526] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.676935] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.719337] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.755706] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    3.762870] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.768988] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    3.775020] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    3.781424] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[    3.788149] Copyright (c) 2007-2009 Intel Corporation.
[    3.793450] igb 0000:01:00.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    3.800269] igb 0000:01:00.0: setting latency timer to 64
[    3.806145] igb 0000:01:00.0: irq 119 for MSI/MSI-X
[    3.811137] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    3.816127] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    3.821120] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    3.826108] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    3.831094] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    3.836084] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    3.841068] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    3.846059] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    4.032880] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[    4.039869] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[    4.047190] igb 0000:01:00.0: eth0: PBA No: 0010ff-0ff
[    4.052437] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    4.060214] igb 0000:01:00.1: PCI INT B -> GSI 88 (level, low) -> IRQ 88
[    4.067034] igb 0000:01:00.1: setting latency timer to 64
[    4.072855] igb 0000:01:00.1: irq 128 for MSI/MSI-X
[    4.077847] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[    4.082841] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[    4.087829] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[    4.092819] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[    4.097803] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[    4.102788] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[    4.107778] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[    4.112762] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[    4.287620] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[    4.294612] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:27
[    4.301930] igb 0000:01:00.1: eth1: PBA No: 0010ff-0ff
[    4.307171] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    4.315162] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[    4.321881] Copyright (c) 2009 Intel Corporation.
[    4.326917] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.84-k2
[    4.334923] ixgbe: Copyright (c) 1999-2010 Intel Corporation.
[    4.341038] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    4.348283] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.357054] jme: JMicron JMC2XX ethernet driver version 1.0.7
[    4.364060] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.370261] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.375930] e100 0000:08:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[    4.407640] e100 0000:08:01.0: PME# disabled
[    4.413952] e100 0000:08:01.0: eth2: addr 0xfb900000, irq 48, MAC addr 00:0e:0c:7f:c7:3e
[    4.423944] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    4.432257] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.6 (Oct 12, 2010)
[    4.440151] sky2: driver version 1.28
[    4.449112] tun: Universal TUN/TAP device driver, 1.6
[    4.454274] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.462759] usbcore: registered new interface driver catc
[    4.468262] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    4.474507] usbcore: registered new interface driver kaweth
[    4.480189] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    4.488401] usbcore: registered new interface driver pegasus
[    4.494168] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    4.501910] usbcore: registered new interface driver rtl8150
[    4.507885] usbcore: registered new interface driver asix
[    4.513603] usbcore: registered new interface driver cdc_ether
[    4.519998] usbcore: registered new interface driver cdc_eem
[    4.525981] usbcore: registered new interface driver dm9601
[    4.532146] usbcore: registered new interface driver smsc75xx
[    4.538245] usbcore: registered new interface driver smsc95xx
[    4.544309] usbcore: registered new interface driver gl620a
[    4.550478] usbcore: registered new interface driver net1080
[    4.557412] usbcore: registered new interface driver plusb
[    4.563246] usbcore: registered new interface driver rndis_host
[    4.569497] usbcore: registered new interface driver cdc_subset
[    4.576399] usbcore: registered new interface driver zaurus
[    4.582290] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.590084] usbcore: registered new interface driver int51x1
[    4.595859] netconsole: local port 6665
[    4.599804] netconsole: local IP 10.0.0.0
[    4.603916] netconsole: interface 'eth0'
[    4.607940] netconsole: remote port 6666
[    4.611970] netconsole: remote IP 10.239.51.110
[    4.616610] netconsole: remote ethernet address 00:30:48:fe:19:94
[    4.622809] netconsole: device eth0 not up yet, forcing it
[    6.936737] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.37-rc1+ (wfg@bee) (gcc version 4.5.0 (GCC) ) #116 SMP PREEMPT Sun Nov 14 08:35:19 CST 2010
[    0.000000] Command line: ip=::::wfg-ws02::dhcp netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94 panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=tty0 console=ttyS0,115200 earlyprintk=vga sched_debug nfsroot=10.239.51.240:/nfsroot/wfg,tcp,v3,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009c400 (usable)
[    0.000000]  BIOS-e820: 000000000009c400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf30b000 (usable)
[    0.000000]  BIOS-e820: 00000000bf30b000 - 00000000bf38b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf38b000 - 00000000bf3a1000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3a1000 - 00000000bf3a2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3a2000 - 00000000bf3b3000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3b3000 - 00000000bf3b6000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3b6000 - 00000000bf3dd000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf3dd000 - 00000000bf3de000 (usable)
[    0.000000]  BIOS-e820: 00000000bf3de000 - 00000000bf3df000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3df000 - 00000000bf414000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf414000 - 00000000bf416000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf416000 - 00000000bf418000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf418000 - 00000000bf420000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf420000 - 00000000bf421000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf421000 - 00000000bf423000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf423000 - 00000000bf42b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf42b000 - 00000000bf454000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf454000 - 00000000bf657000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf657000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000c0000000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000440000000 (usable)
[    0.000000] bootconsole [earlyvga0] enabled
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: X8DTN/X8DTN, BIOS 4.6.3 01/06/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0x440000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FC00000000 write-back
[    0.000000]   1 base 0400000000 mask FFC0000000 write-back
[    0.000000]   2 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcf20] fcf20
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 4k
[    0.000000] kernel direct mapping tables up to bf800000 @ 1fa00000-20000000
[    0.000000] init_memory_mapping: 0000000100000000-0000000440000000
[    0.000000]  0100000000 - 0440000000 page 4k
[    0.000000] kernel direct mapping tables up to 440000000 @ bd0f9000-bf30b000
[    0.000000] ACPI: RSDP 00000000000f0410 00024 (v02  A M I)
[    0.000000] ACPI: XSDT 00000000bf421e18 0008C (v01  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: FACP 00000000bf41fd98 000F4 (v04  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20101013/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xBF420F40/0x00000000BF420E40, using 32 (20101013/tbfadt-486)
[    0.000000] ACPI: DSDT 00000000bf418018 06059 (v01  A M I   ALASKA 00000001 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf420f40 00040
[    0.000000] ACPI: APIC 00000000bf41fc18 00130 (v02  A M I   ALASKA 01072009 MSFT 00010013)
[    0.000000] ACPI: SSDT 00000000bf415798 006EE (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bf422f18 0003C (v01 A M I  OEMMCFG  01072009 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf414c98 00228 (v01 A M I  AMI SRAT 00000001 AMI. 00000000)
[    0.000000] ACPI: SLIT 00000000bf422e98 00030 (v01 A M I  AMI SLIT 00000000 AMI. 00000000)
[    0.000000] ACPI: HPET 00000000bf422e18 00038 (v01 A M I  ICH7HPET 01072009 AMI. 00000003)
[    0.000000] ACPI: SPMI 00000000bf422d98 00040 (v05 A M I   OEMSPMI 00000000 AMI. 00000000)
[    0.000000] ACPI: EINJ 00000000bf41fa98 00130 (v01    AMI AMI EINJ 00000000      00000000)
[    0.000000] ACPI: ERST 00000000bf414a18 00210 (v01  AMIER AMI ERST 00000000      00000000)
[    0.000000] ACPI: HEST 00000000bf414f18 000A8 (v01    AMI AMI HEST 00000000      00000000)
[    0.000000] ACPI: BERT 00000000bf422d18 00030 (v01    AMI AMI BERT 00000000      00000000)
[    0.000000] ACPI: DMAR 00000000bf415f18 000D4 (v01 A M I   OEMDMAR 00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] SRAT: PXM 0 -> APIC 0x00 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x01 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x02 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x03 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x04 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x05 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x10 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x11 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x12 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x13 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x14 -> Node 0
[    0.000000] SRAT: PXM 0 -> APIC 0x15 -> Node 0
[    0.000000] SRAT: PXM 1 -> APIC 0x20 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x21 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x22 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x23 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x24 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x25 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x30 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x31 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x32 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x33 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x34 -> Node 1
[    0.000000] SRAT: PXM 1 -> APIC 0x35 -> Node 1
[    0.000000] SRAT: Node 0 PXM 0 0-c0000000
[    0.000000] SRAT: Node 0 PXM 0 100000000-240000000
[    0.000000] SRAT: Node 1 PXM 1 240000000-440000000
[    0.000000] SRAT: Node 0 [0,c0000000) + [100000000,240000000) -> [0,240000000)
[    0.000000] NUMA: Using 30 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000240000000
[    0.000000]   NODE_DATA [000000023fffb000 - 000000023fffffff]
[    0.000000] Initmem setup node 1 0000000240000000-0000000440000000
[    0.000000]   NODE_DATA [000000043fffa000 - 000000043fffefff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880237e00000-ffff88023edfffff] on node 0
[    0.000000]  [ffffea0007e00000-ffffea000edfffff] PMD -> [ffff880437e00000-ffff88043edfffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00440000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009c
[    0.000000]     0: 0x00000100 -> 0x000bf30b
[    0.000000]     0: 0x000bf3dd -> 0x000bf3de
[    0.000000]     0: 0x000bf657 -> 0x000bf800
[    0.000000]     0: 0x00100000 -> 0x00240000
[    0.000000]     1: 0x00240000 -> 0x00440000
[    0.000000] On node 0 totalpages: 2094145
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3918 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765165 pages, LIFO batch:31
[    0.000000]   Normal zone: 17920 pages used for memmap
[    0.000000]   Normal zone: 1292800 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 2097152
[    0.000000]   Normal zone: 28672 pages used for memmap
[    0.000000]   Normal zone: 2068480 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x10] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x12] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x14] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x20] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x22] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x24] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 8/0x24 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x30] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 9/0x30 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x32] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 10/0x32 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x34] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 11/0x34 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x01] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 12/0x1 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x03] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 13/0x3 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x05] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 14/0x5 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x11] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 15/0x11 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x13] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 16/0x13 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x15] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 17/0x15 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x21] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 18/0x21 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x23] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 19/0x23 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x25] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 20/0x25 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x31] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 21/0x31 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x33] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 22/0x33 ignored.
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x35] enabled)
[    0.000000] ACPI: NR_CPUS/possible_cpus limit of 8 reached.  Processor 23/0x35 ignored.
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec01000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 2, version 32, address 0xfec01000, GSI 24-47
[    0.000000] ACPI: IOAPIC (id[0x03] address[0xfec02000] gsi_base[48])
[    0.000000] IOAPIC[2]: apic_id 3, version 32, address 0xfec02000, GSI 48-71
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec90000] gsi_base[72])
[    0.000000] IOAPIC[3]: apic_id 4, version 32, address 0xfec90000, GSI 72-95
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] 24 Processors exceeds NR_CPUS limit of 8
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 112
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ed1c000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:2
[    0.000000] PERCPU: Embedded 475 pages/cpu @ffff8800bc400000 s1915520 r8192 d21888 u2097152
[    0.000000] pcpu-alloc: s1915520 r8192 d21888 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 [0] 4 [0] 5 [1] 6 [1] 7
[    0.000000] Built 2 zonelists in Zone order, mobility grouping on.  Total pages: 4130363
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: ip=::::wfg-ws02::dhcp netconsole=@:/eth0,6666@10.239.51.110/00:30:48:fe:19:94 panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic load_ramdisk=2 prompt_ramdisk=0 console=tty0 console=ttyS0,115200 earlyprintk=vga sched_debug nfsroot=10.239.51.240:/nfsroot/wfg,tcp,v3,rsize=524288,wsize=524288 rw BOOT_IMAGE=x86_64/vmlinuz
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Memory: 16385840k/17825792k available (9918k kernel code, 1060604k absent, 379348k reserved, 10845k data, 2720k init)
[    0.000000] ------------[ cut here ]------------
[    0.000000] WARNING: at /home/wfg/cc/linux-2.6/kernel/lockdep.c:2481 lockdep_trace_alloc+0xed/0x100()
[    0.000000] Hardware name: X8DTN
[    0.000000] Modules linked in:
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.37-rc1+ #116
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff810bc51d>] warn_slowpath_common+0xad/0xf0
[    0.000000]  [<ffffffff810bc57a>] warn_slowpath_null+0x1a/0x20
[    0.000000]  [<ffffffff8110debd>] lockdep_trace_alloc+0xed/0x100
[    0.000000]  [<ffffffff81201df0>] __kmalloc_node+0x30/0x340
[    0.000000]  [<ffffffff8110abf8>] ? lock_release_holdtime+0xb8/0x160
[    0.000000]  [<ffffffff811d0b5a>] pcpu_mem_alloc+0x16a/0x1b0
[    0.000000]  [<ffffffff82641c3b>] percpu_init_late+0x48/0xc2
[    0.000000]  [<ffffffff8261cd2f>] start_kernel+0x1d4/0x473
[    0.000000]  [<ffffffff8261c35c>] x86_64_start_reservations+0x163/0x167
[    0.000000]  [<ffffffff8261c498>] x86_64_start_kernel+0x138/0x147
[    0.000000] ---[ end trace 4eaa2a86a8e2da22 ]---
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000]  RCU debugfs-based tracing is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000]  Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1968 16
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled, bootconsole disabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6367 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 167772160 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] ODEBUG: 15 of 15 active objects replaced
[    0.000000] hpet clockevent registered
[    0.001000] Fast TSC calibration using PIT
[    0.002000] Detected 2799.940 MHz processor.
[    0.000010] Calibrating delay loop (skipped), value calculated using timer frequency.. 5599.88 BogoMIPS (lpj=2799940)
[    0.010819] pid_max: default: 32768 minimum: 301
[    0.021732] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.035635] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.044541] Mount-cache hash table entries: 256
[    0.049461] Initializing cgroup subsys debug
[    0.053828] Initializing cgroup subsys ns
[    0.057931] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.066961] Initializing cgroup subsys cpuacct
[    0.071510] Initializing cgroup subsys memory
[    0.075988] Initializing cgroup subsys devices
[    0.080527] Initializing cgroup subsys freezer
[    0.085106] CPU: Physical Processor ID: 0
[    0.089210] CPU: Processor Core ID: 0
[    0.092975] mce: CPU supports 9 MCE banks
[    0.097097] CPU0: Thermal monitoring enabled (TM1)
[    0.101989] using mwait in idle threads.
[    0.106006] Performance Events: PEBS fmt1+, Westmere events, Intel PMU driver.
[    0.113534] ... version:                3
[    0.117641] ... bit width:              48
[    0.121826] ... generic registers:      4
[    0.125927] ... value mask:             0000ffffffffffff
[    0.131328] ... max period:             000000007fffffff
[    0.136733] ... fixed-purpose events:   3
[    0.140840] ... event mask:             000000070000000f
[    0.147296] ACPI: Core revision 20101013
[    0.175763] ftrace: allocating 24175 entries in 95 pages
[    0.191023] Setting APIC routing to flat
[    0.195686] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.211760] CPU0: Intel(R) Xeon(R) CPU           X5660  @ 2.80GHz stepping 01
[    0.325235] lockdep: fixing up alternatives.
[    0.330234] Booting Node   0, Processors  #1lockdep: fixing up alternatives.
[    0.430133]  #2lockdep: fixing up alternatives.
[    0.526952]  #3lockdep: fixing up alternatives.
[    0.623746]  #4lockdep: fixing up alternatives.
[    0.720587]  #5lockdep: fixing up alternatives.
[    0.817387]  Ok.
[    0.819325] Booting Node   1, Processors  #6
[    0.914091] TSC synchronization [CPU#0 -> CPU#6]:
[    0.919156] Measured 972 cycles TSC warp between CPUs, turning off TSC clock.
[    0.003999] Marking TSC unstable due to check_tsc_sync_source failed
[    0.556039] lockdep: fixing up alternatives.
[    0.557053]  #7 Ok.
[    0.629167] Brought up 8 CPUs
[    0.630006] Total of 8 processors activated (44799.04 BogoMIPS).
[    0.631048] Testing NMI watchdog ... OK.
[    0.654090] CPU0 attaching sched-domain:
[    0.655007]  domain 0: span 0-5 level MC
[    0.658004]   groups: 0 1 2 3 4 5
[    0.660489]   domain 1: span 0-7 level NODE
[    0.662006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.665289] CPU1 attaching sched-domain:
[    0.666006]  domain 0: span 0-5 level MC
[    0.668006]   groups: 1 2 3 4 5 0
[    0.671503]   domain 1: span 0-7 level NODE
[    0.673006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.676287] CPU2 attaching sched-domain:
[    0.677006]  domain 0: span 0-5 level MC
[    0.679005]   groups: 2 3 4 5 0 1
[    0.682288]   domain 1: span 0-7 level NODE
[    0.684006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.689285] CPU3 attaching sched-domain:
[    0.690004]  domain 0: span 0-5 level MC
[    0.692003]   groups: 3 4 5 0 1 2
[    0.695004]   domain 1: span 0-7 level NODE
[    0.697006]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.703007] CPU4 attaching sched-domain:
[    0.704004]  domain 0: span 0-5 level MC
[    0.706003]   groups: 4 5 0 1 2 3
[    0.708926]   domain 1: span 0-7 level NODE
[    0.710003]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.713284] CPU5 attaching sched-domain:
[    0.714006]  domain 0: span 0-5 level MC
[    0.716005]   groups: 5 0 1 2 3 4
[    0.718718]   domain 1: span 0-7 level NODE
[    0.720004]    groups: 0-5 (cpu_power = 6144) 6-7 (cpu_power = 2048)
[    0.723285] CPU6 attaching sched-domain:
[    0.724006]  domain 0: span 6-7 level MC
[    0.726005]   groups: 6 7
[    0.727714]   domain 1: span 0-7 level NODE
[    0.729005]    groups: 6-7 (cpu_power = 2048) 0-5 (cpu_power = 6144)
[    0.732287] CPU7 attaching sched-domain:
[    0.733006]  domain 0: span 6-7 level MC
[    0.735005]   groups: 7 6
[    0.737496]   domain 1: span 0-7 level NODE
[    0.739006]    groups: 6-7 (cpu_power = 2048) 0-5 (cpu_power = 6144)
[    0.743198] kworker/u:0 used greatest stack depth: 6256 bytes left
[    0.749763] kworker/u:0 used greatest stack depth: 6072 bytes left
[    0.781489] Time:  8:41:28  Date: 11/14/10
[    0.782100] NET: Registered protocol family 16
[    0.785102] ACPI: bus type pci registered
[    0.787495] dca service started, version 1.12.1
[    0.788092] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xc0000000-0xcfffffff] (base 0xc0000000)
[    0.790007] PCI: MMCONFIG at [mem 0xc0000000-0xcfffffff] reserved in E820
[    0.885600] PCI: Using configuration type 1 for base access
[    0.944365] ACPI: EC: Look up EC in DSDT
[    0.947813] \_SB_:_OSC evaluation returned wrong type
[    0.948007] _OSC request data:1 6
[    0.955612] ACPI: Executed 1 blocks of module-level executable AML code
[    0.989443] ACPI: SSDT 00000000bf416018 01494 (v01    AMI      IST 00000001 MSFT 03000001)
[    0.998909] ACPI: Dynamic OEM Table Load:
[    1.001004] ACPI: SSDT           (null) 01494 (v01    AMI      IST 00000001 MSFT 03000001)
[    1.012963] ACPI: Interpreter enabled
[    1.013008] ACPI: (supports S0 S5)
[    1.015371] ACPI: Using IOAPIC for interrupt routing
[    1.025532] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.082704] ACPI: No dock devices found.
[    1.083009] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.085104] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    1.087316] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.088009] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.089009] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.090007] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    1.091028] pci 0000:00:00.0: [8086:3406] type 0 class 0x000600
[    1.092066] pci 0000:00:00.0: PME# supported from D0 D3hot D3cold
[    1.093009] pci 0000:00:00.0: PME# disabled
[    1.094038] pci 0000:00:01.0: [8086:3408] type 1 class 0x000604
[    1.095063] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.096008] pci 0000:00:01.0: PME# disabled
[    1.097034] pci 0000:00:03.0: [8086:340a] type 1 class 0x000604
[    1.099024] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.100006] pci 0000:00:03.0: PME# disabled
[    1.101037] pci 0000:00:05.0: [8086:340c] type 1 class 0x000604
[    1.102066] pci 0000:00:05.0: PME# supported from D0 D3hot D3cold
[    1.103008] pci 0000:00:05.0: PME# disabled
[    1.104038] pci 0000:00:07.0: [8086:340e] type 1 class 0x000604
[    1.105063] pci 0000:00:07.0: PME# supported from D0 D3hot D3cold
[    1.106006] pci 0000:00:07.0: PME# disabled
[    1.107037] pci 0000:00:09.0: [8086:3410] type 1 class 0x000604
[    1.108066] pci 0000:00:09.0: PME# supported from D0 D3hot D3cold
[    1.109009] pci 0000:00:09.0: PME# disabled
[    1.110036] pci 0000:00:13.0: [8086:342d] type 0 class 0x000800
[    1.111017] pci 0000:00:13.0: reg 10: [mem 0xfbe24000-0xfbe24fff]
[    1.112063] pci 0000:00:13.0: PME# supported from D0 D3hot D3cold
[    1.113009] pci 0000:00:13.0: PME# disabled
[    1.114036] pci 0000:00:14.0: [8086:342e] type 0 class 0x000800
[    1.115086] pci 0000:00:14.1: [8086:3422] type 0 class 0x000800
[    1.116088] pci 0000:00:14.2: [8086:3423] type 0 class 0x000800
[    1.117088] pci 0000:00:14.3: [8086:3438] type 0 class 0x000800
[    1.118088] pci 0000:00:16.0: [8086:3430] type 0 class 0x000880
[    1.119021] pci 0000:00:16.0: reg 10: [mem 0xfbe1c000-0xfbe1ffff 64bit]
[    1.120085] pci 0000:00:16.1: [8086:3431] type 0 class 0x000880
[    1.121018] pci 0000:00:16.1: reg 10: [mem 0xfbe18000-0xfbe1bfff 64bit]
[    1.122095] pci 0000:00:16.2: [8086:3432] type 0 class 0x000880
[    1.123019] pci 0000:00:16.2: reg 10: [mem 0xfbe14000-0xfbe17fff 64bit]
[    1.125055] pci 0000:00:16.3: [8086:3433] type 0 class 0x000880
[    1.126029] pci 0000:00:16.3: reg 10: [mem 0xfbe10000-0xfbe13fff 64bit]
[    1.127090] pci 0000:00:16.4: [8086:3429] type 0 class 0x000880
[    1.128021] pci 0000:00:16.4: reg 10: [mem 0xfbe0c000-0xfbe0ffff 64bit]
[    1.129087] pci 0000:00:16.5: [8086:342a] type 0 class 0x000880
[    1.130021] pci 0000:00:16.5: reg 10: [mem 0xfbe08000-0xfbe0bfff 64bit]
[    1.131090] pci 0000:00:16.6: [8086:342b] type 0 class 0x000880
[    1.132021] pci 0000:00:16.6: reg 10: [mem 0xfbe04000-0xfbe07fff 64bit]
[    1.133088] pci 0000:00:16.7: [8086:342c] type 0 class 0x000880
[    1.134021] pci 0000:00:16.7: reg 10: [mem 0xfbe00000-0xfbe03fff 64bit]
[    1.135092] pci 0000:00:1a.0: [8086:3a37] type 0 class 0x000c03
[    1.136057] pci 0000:00:1a.0: reg 20: [io  0xf0c0-0xf0df]
[    1.137064] pci 0000:00:1a.2: [8086:3a39] type 0 class 0x000c03
[    1.139003] pci 0000:00:1a.2: reg 20: [io  0xf0a0-0xf0bf]
[    1.140085] pci 0000:00:1a.7: [8086:3a3c] type 0 class 0x000c03
[    1.141031] pci 0000:00:1a.7: reg 10: [mem 0xfbe23000-0xfbe233ff]
[    1.142095] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    1.143007] pci 0000:00:1a.7: PME# disabled
[    1.144030] pci 0000:00:1c.0: [8086:3a40] type 1 class 0x000604
[    1.145077] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.146009] pci 0000:00:1c.0: PME# disabled
[    1.147040] pci 0000:00:1c.4: [8086:3a48] type 1 class 0x000604
[    1.148095] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    1.149007] pci 0000:00:1c.4: PME# disabled
[    1.150037] pci 0000:00:1d.0: [8086:3a34] type 0 class 0x000c03
[    1.151059] pci 0000:00:1d.0: reg 20: [io  0xf080-0xf09f]
[    1.152065] pci 0000:00:1d.1: [8086:3a35] type 0 class 0x000c03
[    1.153056] pci 0000:00:1d.1: reg 20: [io  0xf060-0xf07f]
[    1.154062] pci 0000:00:1d.2: [8086:3a36] type 0 class 0x000c03
[    1.156009] pci 0000:00:1d.2: reg 20: [io  0xf040-0xf05f]
[    1.157078] pci 0000:00:1d.7: [8086:3a3a] type 0 class 0x000c03
[    1.158030] pci 0000:00:1d.7: reg 10: [mem 0xfbe22000-0xfbe223ff]
[    1.159095] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.160008] pci 0000:00:1d.7: PME# disabled
[    1.161029] pci 0000:00:1e.0: [8086:244e] type 1 class 0x000604
[    1.162089] pci 0000:00:1f.0: [8086:3a16] type 0 class 0x000601
[    1.163097] pci 0000:00:1f.0: quirk: [io  0x0400-0x047f] claimed by ICH6 ACPI/GPIO/TCO
[    1.164009] pci 0000:00:1f.0: quirk: [io  0x0500-0x053f] claimed by ICH6 GPIO
[    1.165009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 00ff)
[    1.166009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    1.167009] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0290 (mask 001f)
[    1.168006] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 4 PIO at 0ca0 (mask 000f)
[    1.169054] pci 0000:00:1f.2: [8086:3a22] type 0 class 0x000106
[    1.171028] pci 0000:00:1f.2: reg 10: [io  0xf110-0xf117]
[    1.172015] pci 0000:00:1f.2: reg 14: [io  0xf100-0xf103]
[    1.173015] pci 0000:00:1f.2: reg 18: [io  0xf0f0-0xf0f7]
[    1.174015] pci 0000:00:1f.2: reg 1c: [io  0xf0e0-0xf0e3]
[    1.175015] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    1.176014] pci 0000:00:1f.2: reg 24: [mem 0xfbe21000-0xfbe217ff]
[    1.177048] pci 0000:00:1f.2: PME# supported from D3hot
[    1.178007] pci 0000:00:1f.2: PME# disabled
[    1.179033] pci 0000:00:1f.3: [8086:3a30] type 0 class 0x000c05
[    1.180024] pci 0000:00:1f.3: reg 10: [mem 0xfbe20000-0xfbe200ff 64bit]
[    1.181029] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    1.182105] pci 0000:01:00.0: [8086:10c9] type 0 class 0x000200
[    1.183021] pci 0000:01:00.0: reg 10: [mem 0xfbaa0000-0xfbabffff]
[    1.184014] pci 0000:01:00.0: reg 14: [mem 0xfba80000-0xfba9ffff]
[    1.185014] pci 0000:01:00.0: reg 18: [io  0xe020-0xe03f]
[    1.186015] pci 0000:01:00.0: reg 1c: [mem 0xfbb44000-0xfbb47fff]
[    1.187034] pci 0000:01:00.0: reg 30: [mem 0xfba60000-0xfba7ffff pref]
[    1.188042] pci 0000:01:00.0: PME# supported from D0 D3hot D3cold
[    1.189009] pci 0000:01:00.0: PME# disabled
[    1.190054] pci 0000:01:00.1: [8086:10c9] type 0 class 0x000200
[    1.191018] pci 0000:01:00.1: reg 10: [mem 0xfba40000-0xfba5ffff]
[    1.192016] pci 0000:01:00.1: reg 14: [mem 0xfba20000-0xfba3ffff]
[    1.193014] pci 0000:01:00.1: reg 18: [io  0xe000-0xe01f]
[    1.194015] pci 0000:01:00.1: reg 1c: [mem 0xfbb40000-0xfbb43fff]
[    1.196028] pci 0000:01:00.1: reg 30: [mem 0xfba00000-0xfba1ffff pref]
[    1.197042] pci 0000:01:00.1: PME# supported from D0 D3hot D3cold
[    1.198009] pci 0000:01:00.1: PME# disabled
[    1.199023] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    1.200009] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    1.201009] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    1.202011] pci 0000:00:01.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.204037] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    1.205007] pci 0000:00:03.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.206008] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.207013] pci 0000:00:03.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.208054] pci 0000:00:05.0: PCI bridge to [bus 04-04]
[    1.209006] pci 0000:00:05.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.210006] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.211008] pci 0000:00:05.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.212054] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    1.213009] pci 0000:00:07.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.214007] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.215010] pci 0000:00:07.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.216063] pci 0000:06:00.0: [8086:0329] type 1 class 0x000604
[    1.217026] pci 0000:06:00.0: PXH quirk detected; SHPC device MSI disabled
[    1.218066] pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
[    1.219009] pci 0000:06:00.0: PME# disabled
[    1.221036] pci 0000:06:00.2: [8086:032a] type 1 class 0x000604
[    1.222028] pci 0000:06:00.2: PXH quirk detected; SHPC device MSI disabled
[    1.223084] pci 0000:06:00.2: PME# supported from D0 D3hot D3cold
[    1.224007] pci 0000:06:00.2: PME# disabled
[    1.225024] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    1.226009] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    1.227006] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    1.228011] pci 0000:00:09.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.229094] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    1.230009] pci 0000:06:00.0:   bridge window [io  0xf000-0x0000] (disabled)
[    1.231009] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    1.232011] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.233060] pci 0000:08:01.0: [8086:1229] type 0 class 0x000200
[    1.234022] pci 0000:08:01.0: reg 10: [mem 0xfb900000-0xfb900fff]
[    1.235016] pci 0000:08:01.0: reg 14: [io  0xd000-0xd03f]
[    1.236018] pci 0000:08:01.0: reg 18: [mem 0xfb800000-0xfb8fffff]
[    1.237042] pci 0000:08:01.0: reg 30: [mem 0xfb700000-0xfb7fffff pref]
[    1.238026] pci 0000:08:01.0: supports D1 D2
[    1.239004] pci 0000:08:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.240010] pci 0000:08:01.0: PME# disabled
[    1.241056] pci 0000:06:00.2: PCI bridge to [bus 08-08]
[    1.242009] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    1.243009] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    1.244011] pci 0000:06:00.2:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.245089] pci 0000:09:00.0: [1000:0058] type 0 class 0x000100
[    1.246020] pci 0000:09:00.0: reg 10: [io  0xc000-0xc0ff]
[    1.247023] pci 0000:09:00.0: reg 14: [mem 0xfb610000-0xfb613fff 64bit]
[    1.248024] pci 0000:09:00.0: reg 1c: [mem 0xfb600000-0xfb60ffff 64bit]
[    1.249026] pci 0000:09:00.0: reg 30: [mem 0xfb400000-0xfb5fffff pref]
[    1.250043] pci 0000:09:00.0: supports D1 D2
[    1.251023] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    1.252009] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.253009] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    1.254011] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.255094] pci 0000:0a:00.0: [197b:2368] type 0 class 0x000101
[    1.256025] pci 0000:0a:00.0: reg 10: [io  0xb040-0xb047]
[    1.257020] pci 0000:0a:00.0: reg 14: [io  0xb030-0xb033]
[    1.258018] pci 0000:0a:00.0: reg 18: [io  0xb020-0xb027]
[    1.259020] pci 0000:0a:00.0: reg 1c: [io  0xb010-0xb013]
[    1.260018] pci 0000:0a:00.0: reg 20: [io  0xb000-0xb00f]
[    1.261034] pci 0000:0a:00.0: reg 30: [mem 0xfbd00000-0xfbd0ffff pref]
[    1.262073] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    1.263009] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    1.264009] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    1.265011] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    1.266053] pci 0000:0b:01.0: [1002:515e] type 0 class 0x000300
[    1.267024] pci 0000:0b:01.0: reg 10: [mem 0xf0000000-0xf7ffffff pref]
[    1.269005] pci 0000:0b:01.0: reg 14: [io  0xa000-0xa0ff]
[    1.270017] pci 0000:0b:01.0: reg 18: [mem 0xfbc20000-0xfbc2ffff]
[    1.271046] pci 0000:0b:01.0: reg 30: [mem 0xfbc00000-0xfbc1ffff pref]
[    1.272026] pci 0000:0b:01.0: supports D1 D2
[    1.273060] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b] (subtractive decode)
[    1.274009] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    1.275007] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    1.276012] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    1.278007] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.279010] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.280006] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.281008] pci 0000:00:1e.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    1.282052] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.285609] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    1.286405] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    1.288229] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    1.289305] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9._PRT]
[    1.290273] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHA._PRT]
[    1.291353] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.NPE9.PXHB._PRT]
[    1.385410] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.390082] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.394630] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    1.398216] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    1.403037] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    1.407798] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    1.411487] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 11 12 14 15) *0
[    1.415492] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *10 11 12 14 15)
[    1.420107] vgaarb: device added: PCI:0000:0b:01.0,decodes=io+mem,owns=io+mem,locks=none
[    1.421009] vgaarb: loaded
[    1.423486] usbcore: registered new interface driver usbfs
[    1.424058] usbcore: registered new interface driver hub
[    1.426138] usbcore: registered new device driver usb
[    1.429088] wmi: Mapper loaded
[    1.430140] Advanced Linux Sound Architecture Driver Version 1.0.23.
[    1.431006] PCI: Using ACPI for IRQ routing
[    1.432008] PCI: pci_cache_line_size set to 64 bytes
[    1.434021] reserve RAM buffer: 000000000009c400 - 000000000009ffff
[    1.435007] reserve RAM buffer: 00000000bf30b000 - 00000000bfffffff
[    1.436024] reserve RAM buffer: 00000000bf3de000 - 00000000bfffffff
[    1.437016] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
[    1.439222] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    1.442287] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    1.445007] Switching to clocksource hpet
[    1.446911] Warning: could not register all branches stats
[    1.452510] Warning: could not register annotated branches stats
[    1.498386] pnp: PnP ACPI init
[    1.501583] ACPI: bus type pnp registered
[    1.505953] pnp 00:00: [bus 00-ff]
[    1.509464] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.513665] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.518468] pnp 00:00: [io  0x0d00-0xffff window]
[    1.523278] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.528783] pnp 00:00: [mem 0x00000000 window]
[    1.533331] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    1.539342] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.546775] pnp 00:01: [mem 0xfc000000-0xfcffffff]
[    1.551680] pnp 00:01: [mem 0xfd000000-0xfdffffff]
[    1.556584] pnp 00:01: [mem 0xfe000000-0xfe9fffff]
[    1.561490] pnp 00:01: [mem 0xfea00000-0xfea0001f]
[    1.566394] pnp 00:01: [mem 0xfeb00000-0xfebfffff]
[    1.571301] pnp 00:01: [mem 0xfed00400-0xfed3ffff]
[    1.576207] pnp 00:01: [mem 0xfed45000-0xfedfffff]
[    1.581592] pnp 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.589088] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.595136] pnp 00:02: [io  0x0290-0x029f]
[    1.599345] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.605445] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.611486] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    1.618080] pnp 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.624831] pnp 00:03: [io  0x0060]
[    1.628429] pnp 00:03: [io  0x0064]
[    1.632044] pnp 00:03: [irq 1]
[    1.635579] pnp 00:03: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    1.643182] pnp 00:04: [irq 12]
[    1.646715] pnp 00:04: Plug and Play ACPI device, IDs PNP0f03 PNP0f13 (active)
[    1.659113] pnp 00:05: [io  0x03f8-0x03ff]
[    1.663418] pnp 00:05: [irq 4]
[    1.666591] pnp 00:05: [dma 0 disabled]
[    1.671198] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.680838] pnp 00:06: [io  0x02f8-0x02ff]
[    1.685061] pnp 00:06: [irq 3]
[    1.688228] pnp 00:06: [dma 0 disabled]
[    1.692621] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    1.700579] pnp 00:07: [dma 4]
[    1.703745] pnp 00:07: [io  0x0000-0x000f]
[    1.707947] pnp 00:07: [io  0x0081-0x0083]
[    1.713737] pnp 00:07: [io  0x0087]
[    1.717333] pnp 00:07: [io  0x0089-0x008b]
[    1.721535] pnp 00:07: [io  0x008f]
[    1.725132] pnp 00:07: [io  0x00c0-0x00df]
[    1.729742] pnp 00:07: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.736422] pnp 00:08: [io  0x0070-0x0071]
[    1.740638] pnp 00:08: [irq 8]
[    1.744286] pnp 00:08: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.750967] pnp 00:09: [io  0x0061]
[    1.754921] pnp 00:09: Plug and Play ACPI device, IDs PNP0800 (active)
[    1.761634] pnp 00:0a: [io  0x0010-0x001f]
[    1.765843] pnp 00:0a: [io  0x0022-0x003f]
[    1.770054] pnp 00:0a: [io  0x0044-0x005f]
[    1.774257] pnp 00:0a: [io  0x0062-0x0063]
[    1.778460] pnp 00:0a: [io  0x0065-0x006f]
[    1.782665] pnp 00:0a: [io  0x0072-0x007f]
[    1.786876] pnp 00:0a: [io  0x0080]
[    1.790462] pnp 00:0a: [io  0x0084-0x0086]
[    1.794659] pnp 00:0a: [io  0x0088]
[    1.798246] pnp 00:0a: [io  0x008c-0x008e]
[    1.802443] pnp 00:0a: [io  0x0090-0x009f]
[    1.806635] pnp 00:0a: [io  0x00a2-0x00bf]
[    1.810832] pnp 00:0a: [io  0x00e0-0x00ef]
[    1.815035] pnp 00:0a: [io  0x04d0-0x04d1]
[    1.819726] pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.826404] pnp 00:0b: [io  0x00f0-0x00ff]
[    1.830616] pnp 00:0b: [irq 13]
[    1.834296] pnp 00:0b: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.842492] pnp 00:0c: [io  0x0400-0x047f]
[    1.846704] pnp 00:0c: [io  0x1180-0x119f]
[    1.850916] pnp 00:0c: [io  0x0500-0x057f]
[    1.855129] pnp 00:0c: [mem 0xfed1c000-0xfed1ffff]
[    1.860035] pnp 00:0c: [mem 0xfec00000-0xfecfffff]
[    1.864930] pnp 00:0c: [mem 0xff000000-0xffffffff]
[    1.870501] pnp 00:0c: Plug and Play ACPI device, IDs PNP0c01 (active)
[    1.877732] pnp 00:0d: [mem 0xfed00000-0xfed003ff]
[    1.883130] pnp 00:0d: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.890606] pnp: PnP ACPI: found 14 devices
[    1.894899] ACPI: ACPI bus type pnp unregistered
[    1.899642] system 00:01: [mem 0xfc000000-0xfcffffff] has been reserved
[    1.906371] system 00:01: [mem 0xfd000000-0xfdffffff] has been reserved
[    1.913100] system 00:01: [mem 0xfe000000-0xfe9fffff] has been reserved
[    1.919830] system 00:01: [mem 0xfea00000-0xfea0001f] has been reserved
[    1.926557] system 00:01: [mem 0xfeb00000-0xfebfffff] has been reserved
[    1.933286] system 00:01: [mem 0xfed00400-0xfed3ffff] could not be reserved
[    1.940356] system 00:01: [mem 0xfed45000-0xfedfffff] has been reserved
[    1.947080] system 00:02: [io  0x0290-0x029f] has been reserved
[    1.953113] system 00:0a: [io  0x04d0-0x04d1] has been reserved
[    1.959142] system 00:0c: [io  0x0400-0x047f] has been reserved
[    1.965166] system 00:0c: [io  0x1180-0x119f] has been reserved
[    1.971190] system 00:0c: [io  0x0500-0x057f] could not be reserved
[    1.977561] system 00:0c: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.984279] system 00:0c: [mem 0xfec00000-0xfecfffff] could not be reserved
[    1.991343] system 00:0c: [mem 0xff000000-0xffffffff] has been reserved
[    2.033870] pci 0000:00:1c.0: BAR 9: assigned [mem 0xfee00000-0xfeffffff 64bit pref]
[    2.041811] pci 0000:00:1c.4: BAR 9: assigned [mem 0xfb200000-0xfb3fffff 64bit pref]
[    2.049742] pci 0000:00:01.0: PCI bridge to [bus 01-02]
[    2.055088] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    2.061308] pci 0000:00:01.0:   bridge window [mem 0xfba00000-0xfbbfffff]
[    2.068223] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    2.074439] pci 0000:00:03.0: PCI bridge to [bus 03-03]
[    2.079786] pci 0000:00:03.0:   bridge window [io  disabled]
[    2.085573] pci 0000:00:03.0:   bridge window [mem disabled]
[    2.091353] pci 0000:00:03.0:   bridge window [mem pref disabled]
[    2.097562] pci 0000:00:05.0: PCI bridge to [bus 04-04]
[    2.102887] pci 0000:00:05.0:   bridge window [io  disabled]
[    2.108653] pci 0000:00:05.0:   bridge window [mem disabled]
[    2.114414] pci 0000:00:05.0:   bridge window [mem pref disabled]
[    2.120616] pci 0000:00:07.0: PCI bridge to [bus 05-05]
[    2.125941] pci 0000:00:07.0:   bridge window [io  disabled]
[    2.131707] pci 0000:00:07.0:   bridge window [mem disabled]
[    2.137469] pci 0000:00:07.0:   bridge window [mem pref disabled]
[    2.143669] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    2.148994] pci 0000:06:00.0:   bridge window [io  disabled]
[    2.154760] pci 0000:06:00.0:   bridge window [mem disabled]
[    2.160522] pci 0000:06:00.0:   bridge window [mem pref disabled]
[    2.166723] pci 0000:06:00.2: PCI bridge to [bus 08-08]
[    2.172049] pci 0000:06:00.2:   bridge window [io  0xd000-0xdfff]
[    2.178250] pci 0000:06:00.2:   bridge window [mem 0xfb700000-0xfb9fffff]
[    2.185140] pci 0000:06:00.2:   bridge window [mem pref disabled]
[    2.191338] pci 0000:00:09.0: PCI bridge to [bus 06-08]
[    2.196663] pci 0000:00:09.0:   bridge window [io  0xd000-0xdfff]
[    2.202863] pci 0000:00:09.0:   bridge window [mem 0xfb700000-0xfb9fffff]
[    2.209753] pci 0000:00:09.0:   bridge window [mem pref disabled]
[    2.215951] pci 0000:00:1c.0: PCI bridge to [bus 09-09]
[    2.221276] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    2.227476] pci 0000:00:1c.0:   bridge window [mem 0xfb400000-0xfb6fffff]
[    2.234366] pci 0000:00:1c.0:   bridge window [mem 0xfee00000-0xfeffffff 64bit pref]
[    2.242280] pci 0000:00:1c.4: PCI bridge to [bus 0a-0a]
[    2.247605] pci 0000:00:1c.4:   bridge window [io  0xb000-0xbfff]
[    2.253807] pci 0000:00:1c.4:   bridge window [mem 0xfbd00000-0xfbdfffff]
[    2.260697] pci 0000:00:1c.4:   bridge window [mem 0xfb200000-0xfb3fffff 64bit pref]
[    2.268613] pci 0000:00:1e.0: PCI bridge to [bus 0b-0b]
[    2.273945] pci 0000:00:1e.0:   bridge window [io  0xa000-0xafff]
[    2.280149] pci 0000:00:1e.0:   bridge window [mem 0xfbc00000-0xfbcfffff]
[    2.287044] pci 0000:00:1e.0:   bridge window [mem 0xf0000000-0xf7ffffff 64bit pref]
[    2.294982] pci 0000:00:01.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    2.301788] pci 0000:00:01.0: setting latency timer to 64
[    2.307311] pci 0000:00:03.0: PCI INT A -> GSI 72 (level, low) -> IRQ 72
[    2.314120] pci 0000:00:03.0: setting latency timer to 64
[    2.319642] pci 0000:00:05.0: PCI INT A -> GSI 74 (level, low) -> IRQ 74
[    2.326452] pci 0000:00:05.0: setting latency timer to 64
[    2.331967] pci 0000:00:07.0: PCI INT A -> GSI 78 (level, low) -> IRQ 78
[    2.338777] pci 0000:00:07.0: setting latency timer to 64
[    2.344291] pci 0000:00:09.0: PCI INT A -> GSI 80 (level, low) -> IRQ 80
[    2.351100] pci 0000:00:09.0: setting latency timer to 64
[    2.356610] pci 0000:06:00.0: setting latency timer to 64
[    2.362120] pci 0000:06:00.2: setting latency timer to 64
[    2.367639] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.374449] pci 0000:00:1c.0: setting latency timer to 64
[    2.379957] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.386763] pci 0000:00:1c.4: setting latency timer to 64
[    2.392270] pci 0000:00:1e.0: setting latency timer to 64
[    2.397775] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.403451] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.409128] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.415499] pci_bus 0000:00: resource 7 [mem 0xc0000000-0xffffffff]
[    2.421868] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    2.427543] pci_bus 0000:01: resource 1 [mem 0xfba00000-0xfbbfffff]
[    2.433917] pci_bus 0000:06: resource 0 [io  0xd000-0xdfff]
[    2.439591] pci_bus 0000:06: resource 1 [mem 0xfb700000-0xfb9fffff]
[    2.445963] pci_bus 0000:08: resource 0 [io  0xd000-0xdfff]
[    2.451637] pci_bus 0000:08: resource 1 [mem 0xfb700000-0xfb9fffff]
[    2.458012] pci_bus 0000:09: resource 0 [io  0xc000-0xcfff]
[    2.463685] pci_bus 0000:09: resource 1 [mem 0xfb400000-0xfb6fffff]
[    2.470056] pci_bus 0000:09: resource 2 [mem 0xfee00000-0xfeffffff 64bit pref]
[    2.477448] pci_bus 0000:0a: resource 0 [io  0xb000-0xbfff]
[    2.483125] pci_bus 0000:0a: resource 1 [mem 0xfbd00000-0xfbdfffff]
[    2.489496] pci_bus 0000:0a: resource 2 [mem 0xfb200000-0xfb3fffff 64bit pref]
[    2.496887] pci_bus 0000:0b: resource 0 [io  0xa000-0xafff]
[    2.502564] pci_bus 0000:0b: resource 1 [mem 0xfbc00000-0xfbcfffff]
[    2.508936] pci_bus 0000:0b: resource 2 [mem 0xf0000000-0xf7ffffff 64bit pref]
[    2.516326] pci_bus 0000:0b: resource 4 [io  0x0000-0x0cf7]
[    2.522010] pci_bus 0000:0b: resource 5 [io  0x0d00-0xffff]
[    2.527680] pci_bus 0000:0b: resource 6 [mem 0x000a0000-0x000bffff]
[    2.534052] pci_bus 0000:0b: resource 7 [mem 0xc0000000-0xffffffff]
[    2.540468] NET: Registered protocol family 2
[    2.546640] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    2.558372] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    2.569565] TCP bind hash table entries: 65536 (order: 10, 5242880 bytes)
[    2.578550] TCP: Hash tables configured (established 524288 bind 65536)
[    2.585277] TCP reno registered
[    2.589146] UDP hash table entries: 8192 (order: 8, 1572864 bytes)
[    2.596645] UDP-Lite hash table entries: 8192 (order: 8, 1572864 bytes)
[    2.604388] NET: Registered protocol family 1
[    2.609457] RPC: Registered udp transport module.
[    2.614289] RPC: Registered tcp transport module.
[    2.619098] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    2.625723] pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x003f
[    2.632351] pci 0000:00:1a.0: Performing full reset
[    2.637348] pci 0000:00:1a.2: uhci_check_and_reset_hc: legsup = 0x003f
[    2.643982] pci 0000:00:1a.2: Performing full reset
[    2.649044] pci 0000:00:1a.7: EHCI: BIOS handoff
[    2.675080] pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x103f
[    2.681712] pci 0000:00:1d.0: Performing full reset
[    2.686706] pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x003f
[    2.693340] pci 0000:00:1d.1: Performing full reset
[    2.698336] pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x003f
[    2.704971] pci 0000:00:1d.2: Performing full reset
[    2.710019] pci 0000:00:1d.7: EHCI: BIOS handoff
[    2.736196] pci 0000:0b:01.0: Boot video device
[    2.740838] PCI: CLS 64 bytes, default 64
[    2.745118] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    2.751673] Placing 64MB software IO TLB between ffff8800b8400000 - ffff8800bc400000
[    2.759588] software IO TLB at phys 0xb8400000 - 0xbc400000
[    2.782679] Machine check injector initialized
[    2.795756] microcode: CPU0 sig=0x206c1, pf=0x1, revision=0x3
[    2.801628] microcode: CPU1 sig=0x206c1, pf=0x1, revision=0x3
[    2.807489] microcode: CPU2 sig=0x206c1, pf=0x1, revision=0x3
[    2.814935] microcode: CPU3 sig=0x206c1, pf=0x1, revision=0x3
[    2.820793] microcode: CPU4 sig=0x206c1, pf=0x1, revision=0x3
[    2.826649] microcode: CPU5 sig=0x206c1, pf=0x1, revision=0x3
[    2.832512] microcode: CPU6 sig=0x206c1, pf=0x1, revision=0x3
[    2.838384] microcode: CPU7 sig=0x206c1, pf=0x1, revision=0x3
[    2.844635] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    2.853600] Scanning for low memory corruption every 60 seconds
[    2.863689] Initializing RT-Tester: OK
[    2.867598] audit: initializing netlink socket (disabled)
[    2.873170] type=2000 audit(1289724087.872:1): initialized
[    2.888369] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    2.896483] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    2.907826] fuse init (API version 7.15)
[    2.912297] msgmni has been set to 32003
[    2.922514] pcieport 0000:00:01.0: ACPI _OSC control granted for 0x1c
[    2.929083] pcieport 0000:00:01.0: setting latency timer to 64
[    2.935093] pcieport 0000:00:01.0: irq 112 for MSI/MSI-X
[    2.943229] pcieport 0000:00:03.0: ACPI _OSC control granted for 0x1c
[    2.949795] pcieport 0000:00:03.0: setting latency timer to 64
[    2.955795] pcieport 0000:00:03.0: irq 113 for MSI/MSI-X
[    2.964420] pcieport 0000:00:05.0: ACPI _OSC control granted for 0x1c
[    2.970993] pcieport 0000:00:05.0: setting latency timer to 64
[    2.976991] pcieport 0000:00:05.0: irq 114 for MSI/MSI-X
[    2.985580] pcieport 0000:00:07.0: ACPI _OSC control granted for 0x1c
[    2.992161] pcieport 0000:00:07.0: setting latency timer to 64
[    2.998162] pcieport 0000:00:07.0: irq 115 for MSI/MSI-X
[    3.006384] pcieport 0000:00:09.0: ACPI _OSC control granted for 0x1c
[    3.012949] pcieport 0000:00:09.0: setting latency timer to 64
[    3.018948] pcieport 0000:00:09.0: irq 116 for MSI/MSI-X
[    3.027334] pcieport 0000:00:1c.0: ACPI _OSC control granted for 0x1c
[    3.033905] pcieport 0000:00:1c.0: setting latency timer to 64
[    3.039910] pcieport 0000:00:1c.0: irq 117 for MSI/MSI-X
[    3.048224] pcieport 0000:00:1c.4: ACPI _OSC control granted for 0x1c
[    3.054791] pcieport 0000:00:1c.4: setting latency timer to 64
[    3.060796] pcieport 0000:00:1c.4: irq 118 for MSI/MSI-X
[    3.067621] aer 0000:00:01.0:pcie02: service driver aer loaded
[    3.073753] aer 0000:00:03.0:pcie02: service driver aer loaded
[    3.079764] aer 0000:00:05.0:pcie02: service driver aer loaded
[    3.085766] aer 0000:00:07.0:pcie02: service driver aer loaded
[    3.091896] aer 0000:00:09.0:pcie02: service driver aer loaded
[    3.098270] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    3.106750] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input0
[    3.115122] ACPI: Sleep Button [SLPB]
[    3.119574] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    3.127950] ACPI: Power Button [PWRB]
[    3.132257] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    3.139841] ACPI: Power Button [PWRF]
[    3.145532] ACPI: acpi_idle registered with cpuidle
[    3.151903] Monitor-Mwait will be used to enter C-3 state
[    3.157552] Monitor-Mwait will be used to enter C-3 state
[    3.482280] Initializing Nozomi driver 2.1d (build date: Nov 14 2010 08:33:37)
[    3.493205] Non-volatile memory driver v1.3
[    3.498085] Linux agpgart interface v0.103
[    3.502559] Hangcheck: starting hangcheck timer 0.9.1 (tick is 180 seconds, margin is 60 seconds).
[    3.511696] Hangcheck: Using getrawmonotonic().
[    3.516600] [drm] Initialized drm 1.1.0 20060810
[    3.521330] [drm:i915_init] *ERROR* drm/i915 can't work without intel_agp module!
[    3.528988] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    3.556138] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.599526] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.676935] 00:05: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.719337] 00:06: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    3.755706] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k6-NAPI
[    3.762870] e1000: Copyright (c) 1999-2006 Intel Corporation.
[    3.768988] e1000e: Intel(R) PRO/1000 Network Driver - 1.2.7-k2
[    3.775020] e1000e: Copyright (c) 1999 - 2010 Intel Corporation.
[    3.781424] Intel(R) Gigabit Ethernet Network Driver - version 2.1.0-k2
[    3.788149] Copyright (c) 2007-2009 Intel Corporation.
[    3.793450] igb 0000:01:00.0: PCI INT A -> GSI 76 (level, low) -> IRQ 76
[    3.800269] igb 0000:01:00.0: setting latency timer to 64
[    3.806145] igb 0000:01:00.0: irq 119 for MSI/MSI-X
[    3.811137] igb 0000:01:00.0: irq 120 for MSI/MSI-X
[    3.816127] igb 0000:01:00.0: irq 121 for MSI/MSI-X
[    3.821120] igb 0000:01:00.0: irq 122 for MSI/MSI-X
[    3.826108] igb 0000:01:00.0: irq 123 for MSI/MSI-X
[    3.831094] igb 0000:01:00.0: irq 124 for MSI/MSI-X
[    3.836084] igb 0000:01:00.0: irq 125 for MSI/MSI-X
[    3.841068] igb 0000:01:00.0: irq 126 for MSI/MSI-X
[    3.846059] igb 0000:01:00.0: irq 127 for MSI/MSI-X
[    4.032880] igb 0000:01:00.0: Intel(R) Gigabit Ethernet Network Connection
[    4.039869] igb 0000:01:00.0: eth0: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:26
[    4.047190] igb 0000:01:00.0: eth0: PBA No: 0010ff-0ff
[    4.052437] igb 0000:01:00.0: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    4.060214] igb 0000:01:00.1: PCI INT B -> GSI 88 (level, low) -> IRQ 88
[    4.067034] igb 0000:01:00.1: setting latency timer to 64
[    4.072855] igb 0000:01:00.1: irq 128 for MSI/MSI-X
[    4.077847] igb 0000:01:00.1: irq 129 for MSI/MSI-X
[    4.082841] igb 0000:01:00.1: irq 130 for MSI/MSI-X
[    4.087829] igb 0000:01:00.1: irq 131 for MSI/MSI-X
[    4.092819] igb 0000:01:00.1: irq 132 for MSI/MSI-X
[    4.097803] igb 0000:01:00.1: irq 133 for MSI/MSI-X
[    4.102788] igb 0000:01:00.1: irq 134 for MSI/MSI-X
[    4.107778] igb 0000:01:00.1: irq 135 for MSI/MSI-X
[    4.112762] igb 0000:01:00.1: irq 136 for MSI/MSI-X
[    4.287620] igb 0000:01:00.1: Intel(R) Gigabit Ethernet Network Connection
[    4.294612] igb 0000:01:00.1: eth1: (PCIe:2.5Gb/s:Width x4) 00:30:48:cf:17:27
[    4.301930] igb 0000:01:00.1: eth1: PBA No: 0010ff-0ff
[    4.307171] igb 0000:01:00.1: Using MSI-X interrupts. 8 rx queue(s), 8 tx queue(s)
[    4.315162] Intel(R) Virtual Function Network Driver - version 1.0.0-k0
[    4.321881] Copyright (c) 2009 Intel Corporation.
[    4.326917] ixgbe: Intel(R) 10 Gigabit PCI Express Network Driver - version 2.0.84-k2
[    4.334923] ixgbe: Copyright (c) 1999-2010 Intel Corporation.
[    4.341038] ixgb: Intel(R) PRO/10GbE Network Driver - version 1.0.135-k2-NAPI
[    4.348283] ixgb: Copyright (c) 1999-2008 Intel Corporation.
[    4.357054] jme: JMicron JMC2XX ethernet driver version 1.0.7
[    4.364060] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[    4.370261] e100: Copyright(c) 1999-2006 Intel Corporation
[    4.375930] e100 0000:08:01.0: PCI INT A -> GSI 48 (level, low) -> IRQ 48
[    4.407640] e100 0000:08:01.0: PME# disabled
[    4.413952] e100 0000:08:01.0: eth2: addr 0xfb900000, irq 48, MAC addr 00:0e:0c:7f:c7:3e
[    4.423944] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    4.432257] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.2.6 (Oct 12, 2010)
[    4.440151] sky2: driver version 1.28
[    4.449112] tun: Universal TUN/TAP device driver, 1.6
[    4.454274] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.462759] usbcore: registered new interface driver catc
[    4.468262] catc: v2.8:CATC EL1210A NetMate USB Ethernet driver
[    4.474507] usbcore: registered new interface driver kaweth
[    4.480189] pegasus: v0.6.14 (2006/09/27), Pegasus/Pegasus II USB Ethernet driver
[    4.488401] usbcore: registered new interface driver pegasus
[    4.494168] rtl8150: v0.6.2 (2004/08/27):rtl8150 based usb-ethernet driver
[    4.501910] usbcore: registered new interface driver rtl8150
[    4.507885] usbcore: registered new interface driver asix
[    4.513603] usbcore: registered new interface driver cdc_ether
[    4.519998] usbcore: registered new interface driver cdc_eem
[    4.525981] usbcore: registered new interface driver dm9601
[    4.532146] usbcore: registered new interface driver smsc75xx
[    4.538245] usbcore: registered new interface driver smsc95xx
[    4.544309] usbcore: registered new interface driver gl620a
[    4.550478] usbcore: registered new interface driver net1080
[    4.557412] usbcore: registered new interface driver plusb
[    4.563246] usbcore: registered new interface driver rndis_host
[    4.569497] usbcore: registered new interface driver cdc_subset
[    4.576399] usbcore: registered new interface driver zaurus
[    4.582290] usbcore: registered new interface driver MOSCHIP usb-ethernet driver
[    4.590084] usbcore: registered new interface driver int51x1
[    4.595859] netconsole: local port 6665
[    4.599804] netconsole: local IP 10.0.0.0
[    4.603916] netconsole: interface 'eth0'
[    4.607940] netconsole: remote port 6666
[    4.611970] netconsole: remote IP 10.239.51.110
[    4.616610] netconsole: remote ethernet address 00:30:48:fe:19:94
[    4.622809] netconsole: device eth0 not up yet, forcing it
[    6.936737] igb: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   12.706549] console [netcon0] enabled
[   12.710634] netconsole: network logging started
[   12.716492] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   12.723143] ehci_hcd: block sizes: qh 104 qtd 96 itd 192 sitd 96
[   12.729335] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   12.736647] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[   12.742608] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   12.747984] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file 'devices'
[   12.755922] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   12.763526] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   12.775026] ehci_hcd 0000:00:1a.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   12.784178] ehci_hcd 0000:00:1a.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   12.793805] ehci_hcd 0000:00:1a.7: debug port 1
[   12.798457] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   12.811478] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[   12.818383] ehci_hcd 0000:00:1a.7: supports USB remote wakeup
[   12.824588] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfbe23000
[   12.830373] ehci_hcd 0000:00:1a.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   12.843395] ehci_hcd 0000:00:1a.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   12.857029] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[   12.862996] usb usb1: default language 0x0409
[   12.867493] usb usb1: udev 1, busnum 1, minor = 0
[   12.872312] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   12.879217] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.886623] usb usb1: Product: EHCI Host Controller
[   12.891617] usb usb1: Manufacturer: Linux 2.6.37-rc1+ ehci_hcd
[   12.897561] usb usb1: SerialNumber: 0000:00:1a.7
[   12.903451] usb usb1: usb_probe_device
[   12.907323] usb usb1: configuration #1 chosen from 1 choice
[   12.913057] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   12.919608] hub 1-0:1.0: usb_probe_interface
[   12.923996] hub 1-0:1.0: usb_probe_interface - got id
[   12.929164] hub 1-0:1.0: USB hub found
[   12.934633] hub 1-0:1.0: 6 ports detected
[   12.938763] hub 1-0:1.0: standalone hub
[   12.942709] hub 1-0:1.0: no power switching (usb 1.0)
[   12.947882] hub 1-0:1.0: individual port over-current protection
[   12.954017] hub 1-0:1.0: power on to power good time: 20ms
[   12.959626] hub 1-0:1.0: local power source is good
[   12.964628] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   12.972105] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   12.980261] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   12.987567] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   12.993523] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   12.998881] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '002'
[   13.006465] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   13.018024] ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
[   13.027176] ehci_hcd 0000:00:1d.7: reset hcc_params 16871 thresh 7 uframes 1024 64 bit addr hw prefetch
[   13.036794] ehci_hcd 0000:00:1d.7: debug port 1
[   13.041449] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   13.054487] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   13.061393] ehci_hcd 0000:00:1d.7: supports USB remote wakeup
[   13.067293] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfbe22000
[   13.073138] ehci_hcd 0000:00:1d.7: reset command 0080002 (park)=0 ithresh=8 period=1024 Reset HALT
[   13.073145] hub 1-0:1.0: state 7 ports 6 chg 0000 evt 0000
[   13.091744] ehci_hcd 0000:00:1d.7: init command 0010001 (park)=0 ithresh=1 period=1024 RUN
[   13.106028] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   13.112037] usb usb2: default language 0x0409
[   13.116550] usb usb2: udev 1, busnum 2, minor = 128
[   13.121547] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   13.128456] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.135864] usb usb2: Product: EHCI Host Controller
[   13.140862] usb usb2: Manufacturer: Linux 2.6.37-rc1+ ehci_hcd
[   13.146809] usb usb2: SerialNumber: 0000:00:1d.7
[   13.152725] usb usb2: usb_probe_device
[   13.156594] usb usb2: configuration #1 chosen from 1 choice
[   13.162298] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   13.168835] hub 2-0:1.0: usb_probe_interface
[   13.173224] hub 2-0:1.0: usb_probe_interface - got id
[   13.178393] hub 2-0:1.0: USB hub found
[   13.182273] hub 2-0:1.0: 6 ports detected
[   13.186400] hub 2-0:1.0: standalone hub
[   13.190346] hub 2-0:1.0: no power switching (usb 1.0)
[   13.195517] hub 2-0:1.0: individual port over-current protection
[   13.201646] hub 2-0:1.0: power on to power good time: 20ms
[   13.207263] hub 2-0:1.0: local power source is good
[   13.212260] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   13.219717] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   13.228116] uhci_hcd: USB Universal Host Controller Interface driver
[   13.234672] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.241934] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[   13.247883] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   13.253240] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '003'
[   13.260828] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   13.272024] uhci_hcd 0000:00:1a.0: detected 2 ports
[   13.277026] uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
[   13.283843] uhci_hcd 0000:00:1a.0: Performing full reset
[   13.289285] uhci_hcd 0000:00:1a.0: supports USB remote wakeup
[   13.295185] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000f0c0
[   13.301772] usb usb3: default language 0x0409
[   13.307614] usb usb3: udev 1, busnum 3, minor = 256
[   13.312919] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   13.320492] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[   13.329478] hub 2-0:1.0: port 1: status 0501 change 0001
[   13.336261] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.343980] usb usb3: Product: UHCI Host Controller
[   13.350358] usb usb3: Manufacturer: Linux 2.6.37-rc1+ uhci_hcd
[   13.356621] usb usb3: SerialNumber: 0000:00:1a.0
[   13.362773] usb usb3: usb_probe_device
[   13.366642] usb usb3: configuration #1 chosen from 1 choice
[   13.372344] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   13.378871] hub 3-0:1.0: usb_probe_interface
[   13.383266] hub 3-0:1.0: usb_probe_interface - got id
[   13.388431] hub 3-0:1.0: USB hub found
[   13.392302] hub 3-0:1.0: 2 ports detected
[   13.396428] hub 3-0:1.0: standalone hub
[   13.400377] hub 3-0:1.0: no power switching (usb 1.0)
[   13.405549] hub 3-0:1.0: individual port over-current protection
[   13.411677] hub 3-0:1.0: power on to power good time: 2ms
[   13.417209] hub 3-0:1.0: local power source is good
[   13.422204] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   13.429639] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   13.437323] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.0
[   13.443518] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[   13.451113] hub 2-0:1.0: state 7 ports 6 chg 0002 evt 0000
[   13.451137] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[   13.451143] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[   13.451546] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '004'
[   13.451558] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 4
[   13.483121] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[   13.490025] uhci_hcd 0000:00:1a.2: detected 2 ports
[   13.495029] uhci_hcd 0000:00:1a.2: uhci_check_and_reset_hc: cmd = 0x0000
[   13.501847] uhci_hcd 0000:00:1a.2: Performing full reset
[   13.507287] uhci_hcd 0000:00:1a.2: supports USB remote wakeup
[   13.513190] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000f0a0
[   13.519149] usb usb4: default language 0x0409
[   13.523647] usb usb4: udev 1, busnum 4, minor = 384
[   13.528640] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   13.535575] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.540277] ehci_hcd 0000:00:1d.7: port 1 full speed --> companion
[   13.540283] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003801 0  ACK POWER OWNER sig=j CONNECT
[   13.540292] hub 2-0:1.0: port 1 not reset yet, waiting 50ms
[   13.564067] usb usb4: Product: UHCI Host Controller
[   13.569064] usb usb4: Manufacturer: Linux 2.6.37-rc1+ uhci_hcd
[   13.575020] usb usb4: SerialNumber: 0000:00:1a.2
[   13.581230] usb usb4: usb_probe_device
[   13.585093] usb usb4: configuration #1 chosen from 1 choice
[   13.590800] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   13.591039] ehci_hcd 0000:00:1d.7: GetStatus port:1 status 003002 0  ACK POWER OWNER sig=se0 CSC
[   13.591080] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   13.591085] hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0002
[   13.617747] hub 4-0:1.0: usb_probe_interface
[   13.622142] hub 4-0:1.0: usb_probe_interface - got id
[   13.627314] hub 4-0:1.0: USB hub found
[   13.631193] hub 4-0:1.0: 2 ports detected
[   13.635320] hub 4-0:1.0: standalone hub
[   13.639267] hub 4-0:1.0: no power switching (usb 1.0)
[   13.644439] hub 4-0:1.0: individual port over-current protection
[   13.650560] hub 4-0:1.0: power on to power good time: 2ms
[   13.656091] hub 4-0:1.0: local power source is good
[   13.661087] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   13.668133] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   13.676230] ehci_hcd 0000:00:1a.7: HS companion for 0000:00:1a.2
[   13.682412] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   13.689691] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   13.695646] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.701000] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '005'
[   13.708628] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   13.720023] uhci_hcd 0000:00:1d.0: detected 2 ports
[   13.725028] uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
[   13.731848] uhci_hcd 0000:00:1d.0: Performing full reset
[   13.737289] uhci_hcd 0000:00:1d.0: supports USB remote wakeup
[   13.743168] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000f080
[   13.749100] usb usb5: default language 0x0409
[   13.753599] usb usb5: udev 1, busnum 5, minor = 512
[   13.758595] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   13.765500] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.772940] usb usb5: Product: UHCI Host Controller
[   13.772950] hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   13.783517] usb usb5: Manufacturer: Linux 2.6.37-rc1+ uhci_hcd
[   13.789468] usb usb5: SerialNumber: 0000:00:1d.0
[   13.795392] usb usb5: usb_probe_device
[   13.799261] usb usb5: configuration #1 chosen from 1 choice
[   13.804965] usb usb5: adding 5-0:1.0 (config #1, interface 0)
[   13.811512] hub 5-0:1.0: usb_probe_interface
[   13.815902] hub 5-0:1.0: usb_probe_interface - got id
[   13.821069] hub 5-0:1.0: USB hub found
[   13.824947] hub 5-0:1.0: 2 ports detected
[   13.829074] hub 5-0:1.0: standalone hub
[   13.833025] hub 5-0:1.0: no power switching (usb 1.0)
[   13.838195] hub 5-0:1.0: individual port over-current protection
[   13.844321] hub 5-0:1.0: power on to power good time: 2ms
[   13.849842] hub 5-0:1.0: local power source is good
[   13.854841] hub 5-0:1.0: trying to enable port power on non-switchable hub
[   13.862289] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   13.870025] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.0
[   13.876192] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.883456] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   13.890998] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   13.896350] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '006'
[   13.903941] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   13.915024] uhci_hcd 0000:00:1d.1: detected 2 ports
[   13.920023] uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
[   13.926839] uhci_hcd 0000:00:1d.1: Performing full reset
[   13.932281] uhci_hcd 0000:00:1d.1: supports USB remote wakeup
[   13.938161] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000f060
[   13.945795] usb usb6: default language 0x0409
[   13.951628] usb usb6: udev 1, busnum 6, minor = 640
[   13.956951] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[   13.964515] uhci_hcd 0000:00:1d.0: port 1 portsc 009b,00
[   13.969957] hub 5-0:1.0: port 1: status 0101 change 0003
[   13.976754] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   13.984537] usb usb6: Product: UHCI Host Controller
[   13.989844] usb usb6: Manufacturer: Linux 2.6.37-rc1+ uhci_hcd
[   13.996099] usb usb6: SerialNumber: 0000:00:1d.1
[   14.002234] usb usb6: usb_probe_device
[   14.006101] usb usb6: configuration #1 chosen from 1 choice
[   14.011804] usb usb6: adding 6-0:1.0 (config #1, interface 0)
[   14.018357] hub 6-0:1.0: usb_probe_interface
[   14.022742] hub 6-0:1.0: usb_probe_interface - got id
[   14.027910] hub 6-0:1.0: USB hub found
[   14.031791] hub 6-0:1.0: 2 ports detected
[   14.035914] hub 6-0:1.0: standalone hub
[   14.039863] hub 6-0:1.0: no power switching (usb 1.0)
[   14.045035] hub 6-0:1.0: individual port over-current protection
[   14.051164] hub 6-0:1.0: power on to power good time: 2ms
[   14.056694] hub 6-0:1.0: local power source is good
[   14.061692] hub 6-0:1.0: trying to enable port power on non-switchable hub
[   14.069140] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   14.076751] hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0000
[   14.076916] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.1
[   14.077392] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   14.077426] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   14.077431] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   14.077446] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '007'
[   14.077456] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   14.122087] hub 5-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
[   14.129024] uhci_hcd 0000:00:1d.2: detected 2 ports
[   14.134021] uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
[   14.140839] uhci_hcd 0000:00:1d.2: Performing full reset
[   14.146281] uhci_hcd 0000:00:1d.2: supports USB remote wakeup
[   14.152159] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000f040
[   14.158093] usb usb7: default language 0x0409
[   14.162594] usb usb7: udev 1, busnum 7, minor = 768
[   14.167589] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[   14.174525] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   14.181936] usb usb7: Product: UHCI Host Controller
[   14.186934] usb usb7: Manufacturer: Linux 2.6.37-rc1+ uhci_hcd
[   14.192881] usb usb7: SerialNumber: 0000:00:1d.2
[   14.198429] usb usb7: usb_probe_device
[   14.202607] usb usb7: configuration #1 chosen from 1 choice
[   14.208655] usb usb7: adding 7-0:1.0 (config #1, interface 0)
[   14.215524] hub 7-0:1.0: usb_probe_interface
[   14.220219] hub 7-0:1.0: usb_probe_interface - got id
[   14.225700] hub 7-0:1.0: USB hub found
[   14.229883] hub 7-0:1.0: 2 ports detected
[   14.230040] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   14.241389] hub 7-0:1.0: standalone hub
[   14.245344] hub 7-0:1.0: no power switching (usb 1.0)
[   14.250516] hub 7-0:1.0: individual port over-current protection
[   14.256645] hub 7-0:1.0: power on to power good time: 2ms
[   14.262181] hub 7-0:1.0: local power source is good
[   14.267181] hub 7-0:1.0: trying to enable port power on non-switchable hub
[   14.274617] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '001'
[   14.282706] ehci_hcd 0000:00:1d.7: HS companion for 0000:00:1d.2
[   14.290209] usbcore: registered new interface driver libusual
[   14.302840] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[   14.313701] serio: i8042 KBD port at 0x60,0x64 irq 1
[   14.318796] serio: i8042 AUX port at 0x60,0x64 irq 12
[   14.326534] mice: PS/2 mouse device common for all mice
[   14.337596] rtc_cmos 00:08: RTC can wake from S4
[   14.348457] rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
[   14.352057] usb 5-1: ep0 maxpacket = 8
[   14.358546] rtc0: alarms up to one year, y3k, 114 bytes nvram, hpet irqs
[   14.365568] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.06
[   14.369124] usb 5-1: udev 2, busnum 5, minor = 513
[   14.369128] usb 5-1: New USB device found, idVendor=0557, idProduct=8021
[   14.369132] usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[   14.370341] usb 5-1: usb_probe_device
[   14.370347] usb 5-1: configuration #1 chosen from 1 choice
[   14.373122] usb 5-1: adding 5-1:1.0 (config #1, interface 0)
[   14.373816] hub 5-1:1.0: usb_probe_interface
[   14.373820] hub 5-1:1.0: usb_probe_interface - got id
[   14.373824] hub 5-1:1.0: USB hub found
[   14.375135] hub 5-1:1.0: 4 ports detected
[   14.375139] hub 5-1:1.0: standalone hub
[   14.375142] hub 5-1:1.0: individual port power switching
[   14.375145] hub 5-1:1.0: individual port over-current protection
[   14.375148] hub 5-1:1.0: power on to power good time: 100ms
[   14.377122] hub 5-1:1.0: local power source is good
[   14.377127] hub 5-1:1.0: enabling power on all ports
[   14.381583] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '002'
[   14.381664] hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.381669] hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
[   14.454049] usb usb3: suspend_rh (auto-stop)
[   14.482130] hub 5-1:1.0: port 1: status 0301 change 0001
[   14.489920] iTCO_wdt: Found a ICH10R TCO device (Version=2, TCOBASE=0x0460)
[   14.497649] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   14.503779] iTCO_vendor_support: vendor-support=0
[   14.508603] SoftDog: cannot register miscdev on minor=130 (err=-16)
[   14.530572] cpuidle: using governor ladder
[   14.554190] cpuidle: using governor menu
[   14.558237] ioatdma: Intel(R) QuickData Technology Driver 4.00
[   14.564228] ioatdma 0000:00:16.0: can't derive routing for PCI INT A
[   14.570702] ioatdma 0000:00:16.0: PCI INT A: no GSI
[   14.575852] ioatdma 0000:00:16.0: setting latency timer to 64
[   14.581859] ioatdma 0000:00:16.0: irq 137 for MSI/MSI-X
[   14.586080] uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 128, phase 0, 12 us
[   14.586103] hub 5-1:1.0: state 7 ports 4 chg 0002 evt 0000
[   14.588137] hub 5-1:1.0: port 1, status 0301, change 0000, 1.5 Mb/s
[   14.608905] igb 0000:01:00.0: DCA enabled
[   14.614415] igb 0000:01:00.1: DCA enabled
[   14.618592] ioatdma 0000:00:16.1: can't derive routing for PCI INT B
[   14.625066] ioatdma 0000:00:16.1: PCI INT B: no GSI
[   14.630152] ioatdma 0000:00:16.1: setting latency timer to 64
[   14.636171] ioatdma 0000:00:16.1: irq 138 for MSI/MSI-X
[   14.644551] ioatdma 0000:00:16.2: can't derive routing for PCI INT C
[   14.651047] ioatdma 0000:00:16.2: PCI INT C: no GSI
[   14.653132] usb 5-1.1: new low speed USB device using uhci_hcd and address 3
[   14.663246]
[   14.664880] ioatdma 0000:00:16.2: setting latency timer to 64
[   14.670873] ioatdma 0000:00:16.2: irq 139 for MSI/MSI-X
[   14.678473] ioatdma 0000:00:16.3: can't derive routing for PCI INT D
[   14.684949] ioatdma 0000:00:16.3: PCI INT D: no GSI
[   14.690059] ioatdma 0000:00:16.3: setting latency timer to 64
[   14.696101] ioatdma 0000:00:16.3: irq 140 for MSI/MSI-X
[   14.703729] ioatdma 0000:00:16.4: can't derive routing for PCI INT A
[   14.704067] usb usb4: suspend_rh (auto-stop)
[   14.714581] ioatdma 0000:00:16.4: PCI INT A: no GSI
[   14.719655] ioatdma 0000:00:16.4: setting latency timer to 64
[   14.726442] ioatdma 0000:00:16.4: irq 141 for MSI/MSI-X
[   14.734333] ioatdma 0000:00:16.5: can't derive routing for PCI INT B
[   14.740805] ioatdma 0000:00:16.5: PCI INT B: no GSI
[   14.745882] ioatdma 0000:00:16.5: setting latency timer to 64
[   14.751881] ioatdma 0000:00:16.5: irq 142 for MSI/MSI-X
[   14.759787] ioatdma 0000:00:16.6: can't derive routing for PCI INT C
[   14.766259] ioatdma 0000:00:16.6: PCI INT C: no GSI
[   14.771345] ioatdma 0000:00:16.6: setting latency timer to 64
[   14.777345] ioatdma 0000:00:16.6: irq 143 for MSI/MSI-X
[   14.782142] usb 5-1.1: skipped 1 descriptor after interface
[   14.782148] usb 5-1.1: skipped 1 descriptor after interface
[   14.782153] usb 5-1.1: skipped 1 descriptor after interface
[   14.789133] usb 5-1.1: default language 0x0409
[   14.807884] ioatdma 0000:00:16.7: can't derive routing for PCI INT D
[   14.814361] ioatdma 0000:00:16.7: PCI INT D: no GSI
[   14.819131] usb 5-1.1: udev 3, busnum 5, minor = 514
[   14.819135] usb 5-1.1: New USB device found, idVendor=0557, idProduct=2261
[   14.819139] usb 5-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   14.819142] usb 5-1.1: Product: CS1716A V1.0.098
[   14.819145] usb 5-1.1: Manufacturer: ATEN International Co. Ltd
[   14.820327] usb 5-1.1: usb_probe_device
[   14.820332] usb 5-1.1: configuration #1 chosen from 1 choice
[   14.824139] usb 5-1.1: adding 5-1.1:1.0 (config #1, interface 0)
[   14.824961] usb 5-1.1: adding 5-1.1:1.1 (config #1, interface 1)
[   14.826595] usb 5-1.1: adding 5-1.1:1.2 (config #1, interface 2)
[   14.827439] /home/wfg/cc/linux-2.6/drivers/usb/core/inode.c: creating file '003'
[   14.827929] hub 5-1:1.0: state 7 ports 4 chg 0000 evt 0002
[   14.892189] ioatdma 0000:00:16.7: setting latency timer to 64
[   14.898205] ioatdma 0000:00:16.7: irq 144 for MSI/MSI-X
[   14.908792] usbhid 5-1.1:1.0: usb_probe_interface
[   14.913617] usbhid 5-1.1:1.0: usb_probe_interface - got id
[   14.948129] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.0/input/input3
[   14.960602] uhci_hcd 0000:00:1d.0: reserve dev 3 ep81-INT, period 8, phase 4, 118 us
[   14.971516] generic-usb 0003:0557:2261.0001: input: USB HID v1.00 Keyboard [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input0
[   14.985322] usbhid 5-1.1:1.1: usb_probe_interface
[   14.990149] usbhid 5-1.1:1.1: usb_probe_interface - got id
[   15.029320] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.1/input/input4
[   15.041787] uhci_hcd 0000:00:1d.0: reserve dev 3 ep82-INT, period 8, phase 4, 118 us
[   15.050477] generic-usb 0003:0557:2261.0002: input: USB HID v1.00 Device [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input1
[   15.064085] usbhid 5-1.1:1.2: usb_probe_interface
[   15.068907] usbhid 5-1.1:1.2: usb_probe_interface - got id
[   15.096550] input: ATEN International Co. Ltd CS1716A V1.0.098 as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.2/input/input5
[   15.110496] generic-usb 0003:0557:2261.0003: input: USB HID v1.10 Mouse [ATEN International Co. Ltd CS1716A V1.0.098] on usb-0000:00:1d.0-1.1/input2
[   15.124263] usbcore: registered new interface driver usbhid
[   15.129949] usbhid: USB HID core driver
[   15.135826] dell-wmi: No known WMI GUID found
[   15.140304] acer-wmi: Acer Laptop ACPI-WMI Extras
[   15.145141] acer-wmi: No or unsupported WMI interface, unable to load
[   15.153828] ALSA device list:
[   15.157240]   No soundcards found.
[   15.162629] oprofile: using NMI interrupt.
[   15.166893] netem: version 1.2
[   15.170070] Netfilter messages via NETLINK v0.30.
[   15.174946] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   15.181767] ctnetlink v0.93: registering with nfnetlink.
[   15.187252] NF_TPROXY: Transparent proxy support initialized, version 4.1.0
[   15.194331] NF_TPROXY: Copyright (c) 2006-2007 BalaBit IT Ltd.
[   15.201986] xt_time: kernel timezone is -0000
[   15.204082] usb usb6: suspend_rh (auto-stop)
[   15.212491] ip_tables: (C) 2000-2006 Netfilter Core Team
[   15.219285] ipt_CLUSTERIP: ClusterIP Version 0.8 loaded successfully
[   15.226570] arp_tables: (C) 2002 David S. Miller
[   15.231776] TCP bic registered
[   15.234950] TCP cubic registered
[   15.238289] TCP westwood registered
[   15.241884] TCP highspeed registered
[   15.245568] TCP hybla registered
[   15.248906] TCP htcp registered
[   15.252155] TCP vegas registered
[   15.255490] TCP veno registered
[   15.258742] TCP scalable registered
[   15.262338] TCP lp registered
[   15.265414] TCP yeah registered
[   15.268665] TCP illinois registered
[   15.272264] Initializing XFRM netlink socket
[   15.276675] NET: Registered protocol family 17
[   15.281246] NET: Registered protocol family 15
[   15.285887] Bridge firewalling registered
[   15.290017] Ebtables v2.0 registered
[   15.315382] registered taskstats version 1
[   15.322696]   Magic number: 2:63:675
[   15.326610] vtconsole vtcon0: hash matches
[   15.330895] rtc_cmos 00:08: setting system clock to 2010-11-14 08:41:44 UTC (1289724104)
[   15.454071] usb usb7: suspend_rh (auto-stop)
[   76.768351] e100 0000:08:01.0: eth2: Failed to load firmware "e100/d101m_ucode.bin": -2
[   76.777166] IP-Config: Failed to open eth2
[   77.782223] Sending DHCP requests ., OK
[   77.797024] IP-Config: Got DHCP answer from 192.168.1.209, my address is 192.168.1.149
[   77.979558] IP-Config: Complete:
[   77.982701]      device=eth0, addr=192.168.1.149, mask=255.255.255.0, gw=192.168.1.1,
[   77.990851]      host=lkp-ws02, domain=tsp.org, nis-domain=(none),
[   77.997202]      bootserver=192.168.1.209, rootserver=10.239.51.240, rootpath=
[   78.030166] VFS: Mounted root (nfs filesystem) on device 0:14.
[   78.036181] debug: unmapping init memory ffffffff82448000..ffffffff826f0000
INIT: version 2.86 booting
