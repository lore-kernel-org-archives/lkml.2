Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab2JMKPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 06:15:05 -0400
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:44233 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745Ab2JMKPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 06:15:03 -0400
X-Greylist: delayed 931 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Oct 2012 06:15:02 EDT
From: Michael Cree <mcree@orcon.net.nz>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] task_work: Add local_irq_enable() into task_work_run()
Date: Sat, 13 Oct 2012 22:59:25 +1300
User-Agent: KMail/1.13.7 (Linux/3.2.0-3-amd64; KDE/4.8.4; x86_64; ; )
Cc: Oleg Nesterov <oleg@redhat.com>, dl8bcu@dl8bcu.de, peterz@infradead.org,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org
References: <20121006204736.GA1830@ds20.borg.net> <20121012160359.GB30881@redhat.com> <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
In-Reply-To: <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_9tTeQA7JyxOMAQW"
Message-Id: <201210132259.25791.mcree@orcon.net.nz>
X-DSPAM-Check: by mx3.orcon.net.nz on Sat, 13 Oct 2012 22:59:26 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sat Oct 13 22:59:27 2012
X-DSPAM-Confidence: 0.8518
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.50] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=G2; city=Porirua; latitude=-41.1333; longitude=174.8500; http://maps.google.com/maps?q=-41.1333,174.8500&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05Iay2805 - 3ce2cef25543 - 20121013
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_9tTeQA7JyxOMAQW
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Sat 13 October 2012 14:09:36 Linus Torvalds wrote:
> On Sat, Oct 13, 2012 at 1:03 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > arch/alpha and probably some other architectures call
> > do_notify_resume()->task_work_run() with irqs disabled.
> 
> I'm going to ignore this patch because I *hope* it is unnecessary
> after the pull from Al that I just did.
> 
> But if that turns out to be not the case, please holler. Torsten, you
> seem to be the one who reported this, can you check the current git
> tree?

I thought I might step in and run some tests.  Current git compiled for SMP 
generic Alpha and running on a 3-CPU ES45.  I have just managed to compile and 
run the test of eglibc without any RCU CPU task lockups!!  This is the first 
time in a couple or so years that I have seen a build of eglibc complete under 
an SMP kernel built for generic Alpha.

So, Al, you have made my day!

Any chance that we could have the fixes backported to the stable queue, in 
particular to the 3,2 kernel?  We should then be able to run the Debian built 
SMP kernel on the autobuilders at Debian-Ports rather than having to run a 
specially built kernel or a UP kernel.

BTW, the WARNING: at kernel/softirq.c:139 __local_bh_enable+0xe8/0x110() still 
occurs when bringing up the CPUs.  Actually it happens twice now.  I've 
attached my dmesg dump should you wish to check.

Cheers
Michael.

--Boundary-00=_9tTeQA7JyxOMAQW
Content-Type: text/plain;
  charset="UTF-8";
  name="dmesg-3.6.0-generic-10664-g4e21fc1-startup.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg-3.6.0-generic-10664-g4e21fc1-startup.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-generic-10664-g4e21fc1 (mjc@electro) (gcc version 4.5.4 (Debian 4.5.4-1+alpha) ) #1 SMP Sat Oct 13 19:29:26 NZDT 2012
[    0.000000] Booting GENERIC on Titan variation Privateer using machine vector PRIVATEER from SRM
[    0.000000] Major Options: SMP VERBOSE_MCHECK MAGIC_SYSRQ 
[    0.000000] Command line: ro root=/dev/sdb3 console=ttyS0
[    0.000000] memcluster 0, usage 1, start        0, end      630
[    0.000000] memcluster 1, usage 0, start      630, end   524279
[    0.000000] memcluster 2, usage 1, start   524279, end   524288
[    0.000000] freeing pages 630:2048
[    0.000000] freeing pages 3961:524279
[    0.000000] reserving pages 3961:3969
[    0.000000] SMP: 3 CPUs probed -- cpu_present_mask = 7
[    0.000000] On node 0 totalpages: 524279
[    0.000000] free_area_init_node: node 0, pgdat fffffc0001e7b100, node_mem_map fffffc0001f02000
[    0.000000]   DMA zone: 3584 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 520695 pages, LIFO batch:15
[    0.000000] PERCPU: Embedded 5 pages/cpu @fffffc0003b14000 s9216 r8192 d23552 u40960
[    0.000000] pcpu-alloc: s9216 r8192 d23552 u40960 alloc=5*8192
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520695
[    0.000000] Kernel command line: ro root=/dev/sdb3 console=ttyS0
[    0.000000] PID hash table entries: 4096 (order: 2, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 524288 (order: 9, 4194304 bytes)
[    0.000000] Inode-cache hash table entries: 262144 (order: 8, 2097152 bytes)
[    0.000000] Memory: 4134648k/4194232k available (4616k kernel code, 54544k reserved, 8571k data, 400k init)
[    0.000000] SLUB: Genslabs=16, HWalign=64, Order=0-3, MinObjects=0, CPUs=3, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=4 to nr_cpu_ids=3.
[    0.000000] NR_IRQS:32784
[    0.000000] Using epoch = 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [ttyS0] enabled
[    1.896483] Calibrating delay loop... 2492.28 BogoMIPS (lpj=1216512)
[    1.980467] pid_max: default: 32768 minimum: 301
[    2.035155] Mount-cache hash table entries: 512
[    2.090819] Initializing cgroup subsys cpuacct
[    2.145506] Initializing cgroup subsys devices
[    2.198241] Initializing cgroup subsys freezer
[    2.250975] SMP starting up secondaries.
[    2.298826] Performance events: Supported CPU type!
[    2.375975] Brought up 3 CPUs
[    2.412108] SMP: Total of 3 processors activated (7471.73 BogoMIPS).
[    2.488279] ------------[ cut here ]------------
[    2.488279] ------------[ cut here ]------------
[    2.488279] WARNING: at kernel/softirq.c:139 __local_bh_enable+0xe8/0x110()
[    2.488279] Modules linked in:
[    2.488279] fffffc00ff123b60 fffffc0001e597e8 fffffc0001041848 0000000000000200 
[    2.488279]        fffffc0001e817e8 fffffc0001e7db85 0000000000000001 0000000000000040 
[    2.488279]        fffffc00010426d8 fffffc0001edbaa0 fffffc0001645940 fffffc000164c040 
[    2.488279]        fffffc000106ca00 fffffc0001eb0cc0 fffffc000101bd38 0000000000000001 
[    2.488279]        0000000000000001 0000000000000000 fffffc000101617c 0000000000000001 
[    2.488279]        0000000000000001 fffffc00016348d8 0000000000000002 fffffc00ff097bd0 
[    2.488279] Trace:
[    2.488279] [<fffffc0001041848>] __local_bh_enable+0xe8/0x110
[    2.488279] [<fffffc00010426d8>] irq_enter+0x68/0x90
[    2.488279] [<fffffc000106ca00>] scheduler_ipi+0x50/0xf0
[    2.488279] [<fffffc000101bd38>] handle_ipi+0xe8/0x340
[    2.488279] [<fffffc000101617c>] do_entInt+0x1ac/0x2d0
[    2.488279] [<fffffc0001010f80>] ret_from_sys_call+0x0/0x10
[    2.488279] [<fffffc0001075c10>] find_busiest_group+0x8e0/0xbb0
[    2.488279] [<fffffc0001012f6c>] cpu_idle+0x2c/0x90
[    2.488279] [<fffffc00010a8150>] rcu_idle_enter+0x0/0x110
[    2.488279] [<fffffc0001012f90>] cpu_idle+0x50/0x90
[    2.488279] [<fffffc0001010044>] __smp_callin+0x24/0x28
[    2.488279] [<fffffc000112e400>] dup_fd+0x50/0x410
[    2.488279] [<fffffc00010369c4>] copy_process+0x774/0x12b0
[    2.488279] [<fffffc0001036b40>] copy_process+0x8f0/0x12b0
[    2.488279] [<fffffc00010112d0>] ret_from_fork+0x0/0x10
[    2.488279] 
[    2.488279] ---[ end trace cb7d145bb41e7784 ]---
[    2.490233] NET: Registered protocol family 16
[    2.491209] EISA bus registered
[    2.492186] PCI host bridge to bus 0000:00
[    2.492186] pci_bus 0000:00: root bus resource [io  0x0000-0x1ffffff]
[    2.492186] pci_bus 0000:00: root bus resource [mem 0x00000000-0x7fffffff]
[    2.492186] pci_bus 0000:00: No busn resource found for root bus, will use [bus 00-ff]
[    2.492186] pci 0000:00:07.0: [10b9:1533] type 00 class 0x060100
[    2.492186] pci 0000:00:0a.0: [9005:00c0] type 00 class 0x010000
[    2.492186] pci 0000:00:0a.0: reg 10: [io  0x1000-0x10ff]
[    2.492186] pci 0000:00:0a.0: reg 14: [mem 0x01450000-0x01450fff 64bit]
[    2.492186] pci 0000:00:0a.0: reg 30: [mem 0x01400000-0x0141ffff pref]
[    2.492186] pci 0000:00:0a.1: [9005:00c0] type 00 class 0x010000
[    2.492186] pci 0000:00:0a.1: reg 10: [io  0x1100-0x11ff]
[    2.492186] pci 0000:00:0a.1: reg 14: [mem 0x01451000-0x01451fff 64bit]
[    2.492186] pci 0000:00:0a.1: reg 30: [mem 0x01420000-0x0143ffff pref]
[    2.492186] pci 0000:00:0b.0: [114f:0004] type 00 class 0x078000
[    2.492186] pci 0000:00:0b.0: reg 10: [mem 0x01000000-0x013fffff]
[    2.492186] pci 0000:00:0b.0: reg 30: [mem 0x01440000-0x0144ffff pref]
[    2.492186] pci 0000:00:0c.0: [0e11:a0f7] type 00 class 0x080400
[    2.492186] pci 0000:00:0c.0: reg 10: [mem 0x01452000-0x014520ff]
[    2.492186] pci 0000:00:10.0: [10b9:5229] type 00 class 0x0101fa
[    2.492186] pci 0000:00:10.0: reg 10: [io  0x01f0-0x01ff]
[    2.492186] pci 0000:00:10.0: reg 14: [io  0x03f4-0x03f7]
[    2.493162] pci 0000:00:10.0: reg 18: [io  0x0170-0x017f]
[    2.493162] pci 0000:00:10.0: reg 1c: [io  0x0374-0x0377]
[    2.493162] pci 0000:00:10.0: reg 20: [io  0x10010-0x1001f]
[    2.493162] pci_bus 0000:00: busn_res: [bus 00-ff] end is updated to 00
[    2.493162] PCI host bridge to bus 0001:01
[    2.493162] pci_bus 0001:01: root bus resource [io  0x200000000-0x201ffffff] (bus address [0x0000-0x1ffffff])
[    2.494139] pci_bus 0001:01: root bus resource [mem 0x200000000-0x27fffffff] (bus address [0x00000000-0x7fffffff])
[    2.494139] pci_bus 0001:01: No busn resource found for root bus, will use [bus 01-ff]
[    2.494139] pci 0001:01:02.0: [8086:b154] type 01 class 0x060400
[    2.494139] pci 0001:01:06.0: [0e11:a0f7] type 00 class 0x080400
[    2.494139] pci 0001:01:06.0: reg 10: [mem 0x201300000-0x2013000ff]
[    2.494139] pci 0001:01:02.0: Primary bus is hard wired to 0
[    2.494139] pci 0001:02:04.0: [8086:1229] type 00 class 0x020000
[    2.494139] pci 0001:02:04.0: reg 10: [mem 0x201200000-0x201200fff]
[    2.494139] pci 0001:02:04.0: reg 14: [io  0x200010000-0x20001003f]
[    2.494139] pci 0001:02:04.0: reg 18: [mem 0x201000000-0x2010fffff]
[    2.494139] pci 0001:02:04.0: supports D1 D2
[    2.494139] pci 0001:02:04.0: PME# supported from D0 D1 D2 D3hot
[    2.494139] pci 0001:02:05.0: [8086:1229] type 00 class 0x020000
[    2.494139] pci 0001:02:05.0: reg 10: [mem 0x201201000-0x201201fff]
[    2.494139] pci 0001:02:05.0: reg 14: [io  0x200010040-0x20001007f]
[    2.494139] pci 0001:02:05.0: reg 18: [mem 0x201100000-0x2011fffff]
[    2.494139] pci 0001:02:05.0: supports D1 D2
[    2.494139] pci 0001:02:05.0: PME# supported from D0 D1 D2 D3hot
[    2.494139] pci 0001:01:02.0: PCI bridge to [bus 02-ff]
[    2.494139] pci 0001:01:02.0:   bridge window [io  0x200010000-0x200010fff]
[    2.494139] pci 0001:01:02.0:   bridge window [mem 0x201000000-0x2012fffff]
[    2.494139] pci_bus 0001:02: busn_res: [bus 02-ff] end is updated to 02
[    2.494139] pci_bus 0001:01: busn_res: [bus 01-ff] end is updated to 02
[    2.495115] PCI host bridge to bus 0002:03
[    2.495115] pci_bus 0002:03: root bus resource [io  0x400000000-0x401ffffff] (bus address [0x0000-0x1ffffff])
[    2.495115] pci_bus 0002:03: root bus resource [mem 0x400000000-0x47fffffff] (bus address [0x00000000-0x7fffffff])
[    2.495115] pci_bus 0002:03: No busn resource found for root bus, will use [bus 03-ff]
[    2.495115] pci_bus 0002:03: busn_res: [bus 03-ff] end is updated to 03
[    2.495115] PCI host bridge to bus 0003:04
[    2.495115] pci_bus 0003:04: root bus resource [io  0x600000000-0x601ffffff] (bus address [0x0000-0x1ffffff])
[    2.495115] pci_bus 0003:04: root bus resource [mem 0x600000000-0x67fffffff] (bus address [0x00000000-0x7fffffff])
[    2.495115] pci_bus 0003:04: No busn resource found for root bus, will use [bus 04-ff]
[    2.495115] pci 0003:04:01.0: [9005:00c0] type 00 class 0x010000
[    2.495115] pci 0003:04:01.0: reg 10: [io  0x600001000-0x6000010ff]
[    2.495115] pci 0003:04:01.0: reg 14: [mem 0x601340000-0x601340fff 64bit]
[    2.495115] pci 0003:04:01.0: reg 30: [mem 0x601300000-0x60131ffff pref]
[    2.495115] pci 0003:04:01.1: [9005:00c0] type 00 class 0x010000
[    2.495115] pci 0003:04:01.1: reg 10: [io  0x600001100-0x6000011ff]
[    2.495115] pci 0003:04:01.1: reg 14: [mem 0x601341000-0x601341fff 64bit]
[    2.495115] pci 0003:04:01.1: reg 30: [mem 0x601320000-0x60133ffff pref]
[    2.495115] pci 0003:04:02.0: [8086:b154] type 01 class 0x060400
[    2.495115] pci 0003:04:06.0: [0e11:a0f7] type 00 class 0x080400
[    2.495115] pci 0003:04:06.0: reg 10: [mem 0x601342000-0x6013420ff]
[    2.495115] pci 0003:04:02.0: Primary bus is hard wired to 0
[    2.495115] pci 0003:04:02.0: bridge configuration invalid ([bus 02-02]), reconfiguring
[    2.495115] pci 0003:05:04.0: [8086:1229] type 00 class 0x020000
[    2.495115] pci 0003:05:04.0: reg 10: [mem 0x601200000-0x601200fff]
[    2.495115] pci 0003:05:04.0: reg 14: [io  0x600010000-0x60001003f]
[    2.495115] pci 0003:05:04.0: reg 18: [mem 0x601000000-0x6010fffff]
[    2.496092] pci 0003:05:04.0: supports D1 D2
[    2.496092] pci 0003:05:04.0: PME# supported from D0 D1 D2 D3hot
[    2.496092] pci 0003:05:05.0: [8086:1229] type 00 class 0x020000
[    2.496092] pci 0003:05:05.0: reg 10: [mem 0x601201000-0x601201fff]
[    2.496092] pci 0003:05:05.0: reg 14: [io  0x600010040-0x60001007f]
[    2.496092] pci 0003:05:05.0: reg 18: [mem 0x601100000-0x6011fffff]
[    2.496092] pci 0003:05:05.0: supports D1 D2
[    2.496092] pci 0003:05:05.0: PME# supported from D0 D1 D2 D3hot
[    2.496092] pci 0003:04:02.0: PCI bridge to [bus 05-ff]
[    2.496092] pci 0003:04:02.0:   bridge window [io  0x600010000-0x600010fff]
[    2.496092] pci 0003:04:02.0:   bridge window [mem 0x601000000-0x6012fffff]
[    2.496092] pci_bus 0003:05: busn_res: [bus 05-ff] end is updated to 05
[    2.496092] pci_bus 0003:04: busn_res: [bus 04-ff] end is updated to 05
[    2.497069] pci 0001:01:02.0: PCI bridge to [bus 02]
[    2.497069] pci 0001:01:02.0:   bridge window [io  0x200010000-0x200010fff]
[    2.497069] pci 0001:01:02.0:   bridge window [mem 0x201000000-0x2012fffff]
[    2.497069] pci 0003:04:02.0: PCI bridge to [bus 05]
[    2.497069] pci 0003:04:02.0:   bridge window [io  0x600010000-0x600010fff]
[    2.497069] pci 0003:04:02.0:   bridge window [mem 0x601000000-0x6012fffff]
[    2.497069] pci_bus 0000:00: resource 4 [io  0x0000-0x1ffffff]
[    2.497069] pci_bus 0000:00: resource 5 [mem 0x00000000-0x7fffffff]
[    2.497069] pci_bus 0001:01: resource 4 [io  0x200000000-0x201ffffff]
[    2.497069] pci_bus 0001:01: resource 5 [mem 0x200000000-0x27fffffff]
[    2.497069] pci_bus 0001:02: resource 0 [io  0x200010000-0x200010fff]
[    2.497069] pci_bus 0001:02: resource 1 [mem 0x201000000-0x2012fffff]
[    2.497069] pci_bus 0002:03: resource 4 [io  0x400000000-0x401ffffff]
[    2.497069] pci_bus 0002:03: resource 5 [mem 0x400000000-0x47fffffff]
[    2.497069] pci_bus 0003:04: resource 4 [io  0x600000000-0x601ffffff]
[    2.497069] pci_bus 0003:04: resource 5 [mem 0x600000000-0x67fffffff]
[    2.497069] pci_bus 0003:05: resource 0 [io  0x600010000-0x600010fff]
[    2.497069] pci_bus 0003:05: resource 1 [mem 0x601000000-0x6012fffff]
[    2.505858] bio: create slab <bio-0> at 0
[    2.506834] vgaarb: loaded
[    2.506834] SCSI subsystem initialized
[    2.507811] libata version 3.00 loaded.
[    2.517576] NET: Registered protocol family 2
[    2.518553] TCP established hash table entries: 524288 (order: 10, 8388608 bytes)
[    2.527342] TCP bind hash table entries: 65536 (order: 7, 1048576 bytes)
[    2.529295] TCP: Hash tables configured (established 524288 bind 65536)
[    2.529295] TCP: reno registered
[    2.529295] UDP hash table entries: 2048 (order: 3, 65536 bytes)
[    2.529295] UDP-Lite hash table entries: 2048 (order: 3, 65536 bytes)
[    2.530272] NET: Registered protocol family 1
[    2.530272] pci 0000:00:07.0: Activating ISA DMA hang workarounds
[    2.530272] pci 0001:02:04.0: Firmware left e100 interrupts enabled; disabling
[    2.530272] pci 0001:02:05.0: Firmware left e100 interrupts enabled; disabling
[    2.530272] pci 0003:05:04.0: Firmware left e100 interrupts enabled; disabling
[    2.530272] pci 0003:05:05.0: Firmware left e100 interrupts enabled; disabling
[    2.530272] PCI: CLS 64 bytes, default 64
[    2.531248] srm_env: version 0.0.6 loaded successfully
[    2.543944] msgmni has been set to 8075
[    2.546873] alg: No test for stdrng (krng)
[    2.546873] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    2.546873] io scheduler noop registered
[    2.546873] io scheduler deadline registered
[    2.547850] io scheduler cfq registered (default)
[    8.172847] WARNING: at kernel/softirq.c:139 __local_bh_enable+0xe8/0x110()
[    8.172847] Modules linked in:
[    8.172847] fffffc00ff127b60 fffffc0001e597e8 fffffc0001041848 0000000000000200 
[    8.172847]        fffffc0001e817e8 fffffc0001e7db85 0000000000000002 0000000000000080 
[    8.172847]        fffffc00010426d8 fffffc0001edbaa0 fffffc0001645940 fffffc000164c080 
[    8.172847]        fffffc000106ca00 fffffc0001eb0d00 fffffc000101bd38 0000000000000001 
[    8.172847]        0000000000000001 0000000000000000 fffffc000101617c 0000000000000002 
[    8.172847]        0000000000000002 fffffc00016348d8 0000000000000004 fffffc00ff09bbd0 
[    8.172847] Trace:
[    8.172847] [<fffffc0001041848>] __local_bh_enable+0xe8/0x110
[    8.172847] [<fffffc00010426d8>] irq_enter+0x68/0x90
[    8.172847] [<fffffc000106ca00>] scheduler_ipi+0x50/0xf0
[    8.172847] [<fffffc000101bd38>] handle_ipi+0xe8/0x340
[    8.172847] [<fffffc000101617c>] do_entInt+0x1ac/0x2d0
[    8.172847] [<fffffc000101bbf4>] smp_percpu_timer_interrupt+0xc4/0x110
[    8.172847] [<fffffc00010160b8>] do_entInt+0xe8/0x2d0
[    8.172847] [<fffffc0001010f80>] ret_from_sys_call+0x0/0x10
[    8.172847] [<fffffc0001064a28>] hrtimer_nanosleep+0xe8/0x150
[    8.172847] [<fffffc0001012f6c>] cpu_idle+0x2c/0x90
[    8.172847] [<fffffc00010a8150>] rcu_idle_enter+0x0/0x110
[    8.172847] [<fffffc0001012f90>] cpu_idle+0x50/0x90
[    8.172847] [<fffffc0001010044>] __smp_callin+0x24/0x28
[    8.172847] [<fffffc000112e400>] dup_fd+0x50/0x410
[    8.172847] [<fffffc00010369c4>] copy_process+0x774/0x12b0
[    8.172847] [<fffffc0001036b40>] copy_process+0x8f0/0x12b0
[    8.172847] [<fffffc00010112d0>] ret_from_fork+0x0/0x10
[    8.172847] 
[    8.172847] ---[ end trace cb7d145bb41e7785 ]---
[   10.041010] isapnp: Scanning for PnP cards...
[   10.448236] isapnp: No Plug & Play device found
[   10.502924] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[   10.598627] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   10.691400] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[   10.763666] Linux agpgart interface v0.103
[   10.812494] agpgart: Detected AGP on hose 2
[   10.863275]  (null): AGP aperture is 64M @ 0xc0000000
[   16.135733] scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   16.135733]         <Adaptec 3960D Ultra160 SCSI adapter>
[   16.135733]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   16.135733] 
[   16.384757] scsi 0:0:0:0: Direct-Access     COMPAQ   BF03688575       HPB2 PQ: 0 ANSI: 3
[   16.482413] scsi0:A:0:0: Tagged Queuing enabled.  Depth 32
[   16.547843] scsi target0:0:0: Beginning Domain Validation
[   16.616202] scsi target0:0:0: wide asynchronous
[   16.673819] scsi target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   16.771475] scsi target0:0:0: Ending Domain Validation
[   16.833975] scsi 0:0:1:0: Direct-Access     COMPAQ   BF03687B54       HPB1 PQ: 0 ANSI: 3
[   16.931631] scsi0:A:1:0: Tagged Queuing enabled.  Depth 32
[   16.997061] scsi target0:0:1: Beginning Domain Validation
[   17.063467] scsi target0:0:1: wide asynchronous
[   17.119131] scsi target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
[   17.214834] scsi target0:0:1: Ending Domain Validation
[   17.278311] scsi 0:0:2:0: Direct-Access     COMPAQ   BF03685A35       HPB3 PQ: 0 ANSI: 3
[   17.374991] scsi0:A:2:0: Tagged Queuing enabled.  Depth 32
[   17.441397] scsi target0:0:2: Beginning Domain Validation
[   17.508780] scsi target0:0:2: wide asynchronous
[   17.565420] scsi target0:0:2: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 63)
[   17.661123] scsi target0:0:2: Ending Domain Validation
[   21.614246] scsi1 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   21.614246]         <Adaptec 3960D Ultra160 SCSI adapter>
[   21.614246]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
[   21.614246] 
[   27.074204] scsi2 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   27.074204]         <Adaptec 3960D Ultra160 SCSI adapter>
[   27.074204]         aic7899: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
[   27.074204] 
[   32.534163] scsi3 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 7.0
[   32.534163]         <Adaptec 3960D Ultra160 SCSI adapter>
[   32.534163]         aic7899: Ultra160 Wide Channel B, SCSI Id=7, 32/253 SCBs
[   32.534163] 
[   32.783186] sd 0:0:0:0: [sda] 71132000 512-byte logical blocks: (36.4 GB/33.9 GiB)
[   32.783186] sd 0:0:1:0: [sdb] 71132000 512-byte logical blocks: (36.4 GB/33.9 GiB)
[   32.784162] sd 0:0:1:0: [sdb] Write Protect is off
[   32.784162] sd 0:0:1:0: [sdb] Mode Sense: cf 00 10 08
[   32.785139] sd 0:0:1:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   33.125959] sd 0:0:2:0: [sdc] 71132000 512-byte logical blocks: (36.4 GB/33.9 GiB)
[   33.126936] scsi4 : pata_ali
[   33.126936] scsi5 : pata_ali
[   33.127912] ata1: PATA max UDMA/33 cmd 0x1f0 ctl 0x3f6 bmdma 0x10010 irq 14
[   33.127912] ata2: PATA max UDMA/33 cmd 0x170 ctl 0x376 bmdma 0x10018 irq 15
[   33.127912] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   33.127912] e100: Copyright(c) 1999-2006 Intel Corporation
[   33.218732] e100 0001:02:04.0 eth0: addr 0x201200000, irq 48, MAC addr 00:0b:cd:4b:2e:34
[   33.284162] ata1.00: ATAPI: Compaq  CRD-8402B, 1.03, max MWDMA2
[   33.284162] ata1.00: WARNING: ATAPI DMA disabled for reliability issues.  It can be enabled
[   33.284162] ata1.00: WARNING: via pata_ali.atapi_dma modparam or corresponding sysfs node.
[   33.293928] ata1.00: configured for PIO4
[   33.310529] e100 0001:02:05.0 eth1: addr 0x201201000, irq 49, MAC addr 00:0b:cd:4b:2e:35
[   33.402326] e100 0003:05:04.0 eth2: addr 0x601200000, irq 56, MAC addr 00:0b:cd:4b:31:56
[   33.493146] e100 0003:05:05.0 eth3: addr 0x601201000, irq 57, MAC addr 00:0b:cd:4b:31:57
[   33.502912] serio: i8042 KBD port at 0x60,0x64 irq 1
[   33.502912] serio: i8042 AUX port at 0x60,0x64 irq 12
[   33.503889] mousedev: PS/2 mouse device common for all mice
[   33.504865] device-mapper: ioctl: 4.23.0-ioctl (2012-07-25) initialised: dm-devel@redhat.com
[   33.504865] TCP: cubic registered
[   33.504865] Initializing XFRM netlink socket
[   33.504865] NET: Registered protocol family 17
[   33.504865] NET: Registered protocol family 15
[   33.522443] atkbd serio0: keyboard reset failed on isa0060/serio0
[   33.571271] atkbd serio1: keyboard reset failed on isa0060/serio1
[   34.924786] sd 0:0:0:0: [sda] Write Protect is off
[   34.925763] sd 0:0:2:0: [sdc] Write Protect is off
[   34.925763] sd 0:0:2:0: [sdc] Mode Sense: d3 00 10 08
[   34.926739] sd 0:0:2:0: [sdc] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   34.931622]  sdb: sdb1 sdb2 sdb3 sdb4
[   34.935528] sd 0:0:1:0: [sdb] Attached SCSI disk
[   34.937482]  sdc: sdc1
[   34.941388] sd 0:0:2:0: [sdc] Attached SCSI disk
[   35.324200] sd 0:0:0:0: [sda] Mode Sense: cf 00 10 08
[   35.325177] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
[   35.434552]  sda: sda1
[   35.466778] sd 0:0:0:0: [sda] Attached SCSI disk
[   38.286113] scsi 4:0:0:0: CD-ROM            COMPAQ   CRD-8402B        1.03 PQ: 0 ANSI: 5
[   38.573222] kjournald starting.  Commit interval 5 seconds
[   38.573222] EXT3-fs (sdb3): mounted filesystem with writeback data mode
[   38.573222] VFS: Mounted root (ext3 filesystem) readonly on device 8:19.
[   38.573222] Freeing unused kernel memory: 400k freed
[   40.143534] sr0: scsi3-mmc drive: 40x/40x cd/rw xa/form2 cdda tray
[   40.220682] cdrom: Uniform CD-ROM driver Revision: 3.20
[   40.299784] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   40.328104] input: PC Speaker as /devices/platform/pcspkr/input/input0
[   40.468729] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   40.537088] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   40.610330] sd 0:0:2:0: Attached scsi generic sg2 type 0
[   40.673807] sr 4:0:0:0: Attached scsi generic sg3 type 5
[   41.267556] Adding 7993784k swap on /dev/sdb4.  Priority:-1 extents:1 across:7993784k 
[   41.706033] EXT3-fs (sdb3): using internal journal
[   44.062477] kjournald starting.  Commit interval 5 seconds
[   44.127907] EXT3-fs (sdc1): using internal journal
[   44.185524] EXT3-fs (sdc1): mounted filesystem with writeback data mode
[   44.308571] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[   45.182594] NET: Registered protocol family 10
[   45.582984] RPC: Registered named UNIX socket transport module.
[   45.654273] RPC: Registered udp transport module.
[   45.710914] RPC: Registered tcp transport module.
[   45.766578] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   45.889624] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   45.959937] e100 0001:02:04.0 eth0: NIC Link is Up 100 Mbps Full Duplex
[   46.039038] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   46.039038] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   46.200171] tty_init_dev: 151 callbacks suppressed
[   52.636691] tty_init_dev: 220 callbacks suppressed

--Boundary-00=_9tTeQA7JyxOMAQW--

