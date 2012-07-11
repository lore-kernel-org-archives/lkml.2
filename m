Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477Ab2GKMg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:36:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:59017 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab2GKMgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:36:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="175988082"
Date: Wed, 11 Jul 2012 20:36:16 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120711123616.GA27086@localhost>
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <20120711074924.GD3819@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > Hi Paul,
> > 
> > Fortunately this bug is bisectable and the first bad commit is:
> > 
> >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > 
> >             rcu: Track idleness independent of idle tasks
> 
> OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> traces while in idle.  The confusion on my part was that in TREE_RCU,
> the nesting and dyntick-idle indication are different, while in
> TINY_RCU they are one and the same.
> 
> Does the following patch help?

Not exactly, but the error message is now changed to:

[    2.320411] Testing tracer wakeup: [    2.632565] ftrace-test (15) used greatest stack depth: 7284 bytes left
PASSED
[    2.634231] Testing tracer wakeup_rt: [    2.716312] ------------[ cut here ]------------
[    2.717208] WARNING: at /c/wfg/linux/kernel/rcutiny.c:92 rcu_idle_enter+0xf0/0x244()
[    2.718549] Hardware name: Bochs

[    2.719136] Modules linked in:
[    2.719754] 
[    2.720022] Pid: 0, comm: swapper Not tainted 3.5.0-rc6+ #55
[    2.720290] Call Trace:
[    2.720290]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.720290]  [<c11057f5>] ? rcu_idle_enter+0xf0/0x244
[    2.720290]  [<c11057f5>] ? rcu_idle_enter+0xf0/0x244
[    2.720290]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.720290]  [<c11057f5>] rcu_idle_enter+0xf0/0x244
[    2.720290]  [<c100fbdb>] cpu_idle+0x159/0x220
[    2.720290]  [<c141615f>] rest_init+0x2db/0x2ef
[    2.720290]  [<c1415e84>] ? reciprocal_value+0x64/0x64
[    2.720290]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.720290]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.720290]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.720290] ---[ end trace 44593438a59a9533 ]---
[    2.732372] ------------[ cut here ]------------
[    2.733235] WARNING: at /c/wfg/linux/kernel/rcutiny.c:113 rcu_irq_exit+0x100/0x217()
[    2.734613] Hardware name: Bochs
[    2.735204] Modules linked in:
[    2.735817] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc6+ #55
[    2.736366] Call Trace:
[    2.736366]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.736366]  [<c11055ee>] ? rcu_irq_exit+0x100/0x217
[    2.736366]  [<c11055ee>] ? rcu_irq_exit+0x100/0x217
[    2.736366]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.736366]  [<c11055ee>] rcu_irq_exit+0x100/0x217
[    2.736366]  [<c104697f>] irq_exit+0x117/0x14d
[    2.736366]  [<c1005d31>] do_IRQ+0xe5/0x106
[    2.736366]  [<c10b9fea>] ? trace_hardirqs_off_caller+0x97/0x167
[    2.736366]  [<c1045eb2>] ? local_bh_enable+0x3c/0x3c
[    2.736366]  [<c1437575>] common_interrupt+0x35/0x3c
[    2.736366]  [<c1045eb2>] ? local_bh_enable+0x3c/0x3c
[    2.736366]  [<c104007b>] ? do_wait+0x453/0x4f5
[    2.736366]  [<c104007b>] ? do_wait+0x453/0x4f5
[    2.736366]  [<c10b00e0>] ? do_timer+0xc1e/0xc77
[    2.736366]  [<c1044284>] ? arch_local_irq_enable+0x13/0x27
[    2.736366]  [<c1045f4f>] __do_softirq+0x9d/0x4fd
[    2.736366]  [<c1045eb2>] ? local_bh_enable+0x3c/0x3c
[    2.736366]  <IRQ>  [<c10468fa>] ? irq_exit+0x92/0x14d
[    2.736366]  [<c1005d31>] ? do_IRQ+0xe5/0x106
[    2.736366]  [<c10b9fea>] ? trace_hardirqs_off_caller+0x97/0x167
[    2.736366]  [<c1437575>] ? common_interrupt+0x35/0x3c
[    2.736366]  [<c10b00e0>] ? do_timer+0xc1e/0xc77
[    2.736366]  [<c1025c7b>] ? native_safe_halt+0x13/0x23
[    2.736366]  [<c100e52a>] ? default_idle+0xac/0x14a
[    2.736366]  [<c100fbef>] ? cpu_idle+0x16d/0x220
[    2.736366]  [<c141615f>] ? rest_init+0x2db/0x2ef
[    2.736366]  [<c1415e84>] ? reciprocal_value+0x64/0x64
[    2.736366]  [<c171d456>] ? start_kernel+0x8eb/0x8ff
[    2.736366]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.736366]  [<c171c342>] ? i386_start_kernel+0xf8/0x10b
[    2.736366] ---[ end trace 44593438a59a9534 ]---
[    2.765933] ------------[ cut here ]------------
[    2.766811] WARNING: at /c/wfg/linux/kernel/rcutiny.c:149 rcu_idle_exit+0xfa/0x266()
[    2.768173] Hardware name: Bochs
[    2.768927] Modules linked in:
[    2.769514] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc6+ #55
[    2.769920] Call Trace:
[    2.769920]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.769920]  [<c11033be>] ? rcu_idle_exit+0xfa/0x266
[    2.769920]  [<c11033be>] ? rcu_idle_exit+0xfa/0x266
[    2.769920]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.769920]  [<c11033be>] rcu_idle_exit+0xfa/0x266
[    2.769920]  [<c100fc02>] cpu_idle+0x180/0x220
[    2.769920]  [<c141615f>] rest_init+0x2db/0x2ef
[    2.769920]  [<c1415e84>] ? reciprocal_value+0x64/0x64
[    2.769920]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.769920]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.769920]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.769920] ---[ end trace 44593438a59a9535 ]---
[    2.988523] PASSED

The test is carried out on top of 2.5-rc6. The kvm command line is:

        kvm -cpu kvm64 -enable-kvm \
                -kernel $vmlinuz \
                -append "$APPEND BOOT_IMAGE=$BOOT_IMAGE" \
                $initrd \
                -m $mem \
                -smp 2 \
                -net nic,vlan=0,macaddr=$mac,model=e1000  \
                -net user,vlan=0,hostfwd=tcp::$port-:22 \
                -boot order=nc \
                -no-reboot \
                -watchdog i6300esb \
                $(qemu_drives) \
                -pidfile $pidfile \
                -serial file:$dmesg \
                $(test "$DISPLAY" = ":0" || echo -daemonize -nographic -monitor null)

Thanks,
Fengguang

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm_bisect-waimea-24095-2012-07-11-20-29-10

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc6+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #55 PREEMPT Wed Jul 11 20:26:20 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.4 present.
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x100000
[    0.000000] initial memory mapped: [mem 0x00000000-0x023fffff]
[    0.000000] Base memory trampoline at [c009b000] 9b000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x003fffff] page 4k
[    0.000000]  [mem 0x00400000-0x0fbfffff] page 2M
[    0.000000]  [mem 0x0fc00000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x023fa000-0x023fffff]
[    0.000000] cma: CMA: reserved 16 MiB at 0d000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 129056(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffd000
[    0.000000]   low ram: 0 - 0fffd000
[    0.000000] kvm-clock: cpu 0, msr 0:1634b41, boot clock
[    0.000000] Zone ranges:
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000] free_area_init_node: node 0, pgdat c16fc524, node_mem_map ce53f200
[    0.000000]   Normal zone: 512 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64908 pages, LIFO batch:15
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64908
[    0.000000] Kernel command line: bisect-reboot i386-randconfig auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 194544k/262132k available (4319k kernel code, 67136k reserved, 2956k data, 420k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcf000 - 0xfffff000   ( 192 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fd000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffd000   ( 255 MB)
[    0.000000]       .init : 0xc171c000 - 0xc1785000   ( 420 kB)
[    0.000000]       .data : 0xc1437db5 - 0xc171b140   (2956 kB)
[    0.000000]       .text : 0xc1000000 - 0xc1437db5   (4319 kB)
[    0.000000] NR_IRQS:16 nr_irqs:16 16
[    0.000000] CPU 0 irqstacks, hard=ce002000 soft=ce004000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3567 kB
[    0.000000]  per task-struct memory footprint: 1152 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ----------------------------------------------------------------------------
[    0.000000]                                  | spin |wlock |rlock |mutex | wsem | rsem |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok  |  ok  |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]               recursive read-lock:             |  ok  |             |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |             |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |             |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |             |  ok  |
[    0.000000]   --------------------------------------------------------------------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A => hirqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]          hard-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]          soft-safe-A + irqs-on/21:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000000]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000000]       hard-irq read-recursion/123:  ok  |
[    0.000000]       soft-irq read-recursion/123:  ok  |
[    0.000000]       hard-irq read-recursion/132:  ok  |
[    0.000000]       soft-irq read-recursion/132:  ok  |
[    0.000000]       hard-irq read-recursion/213:  ok  |
[    0.000000]       soft-irq read-recursion/213:  ok  |
[    0.000000]       hard-irq read-recursion/231:  ok  |
[    0.000000]       soft-irq read-recursion/231:  ok  |
[    0.000000]       hard-irq read-recursion/312:  ok  |
[    0.000000]       soft-irq read-recursion/312:  ok  |
[    0.000000]       hard-irq read-recursion/321:  ok  |
[    0.000000]       soft-irq read-recursion/321:  ok  |
[    0.000000] -------------------------------------------------------
[    0.000000] Good, all 218 testcases passed! |
[    0.000000] ---------------------------------
[    0.000000] kmemleak: Kernel memory leak detector disabled
[    0.000000] ODEBUG: 9 of 9 active objects replaced
[    0.000000] ODEBUG: selftest passed
[    0.000000] kmemleak: Early log buffer exceeded (585), please increase DEBUG_KMEMLEAK_EARLY_LOG_SIZE
[    0.000000] Detected 3299.986 MHz processor.
[    0.004000] Calibrating delay loop (skipped) preset value.. 6599.97 BogoMIPS (lpj=13199944)
[    0.004000] pid_max: default: 4096 minimum: 301
[    0.004192] Security Framework initialized
[    0.005224] AppArmor: AppArmor initialized
[    0.006179] Mount-cache hash table entries: 512
[    0.011832] Initializing cgroup subsys debug
[    0.012027] Initializing cgroup subsys devices
[    0.013057] Initializing cgroup subsys freezer
[    0.014084] Initializing cgroup subsys perf_event
[    0.016301] mce: CPU supports 10 MCE banks
[    0.017249] MCE: unknown CPU type - not enabling MCE support.
[    0.018604] CPU: GenuineIntel Common KVM processor stepping 01
[    0.021880] Performance Events: 
[    0.024565] Testing tracer nop: 
[    0.025418] PASSED
[    0.028375] EVM: security.capability
[    0.034447] dummy: 
[    0.041228] NET: Registered protocol family 16
[    0.047067] bio: create slab <bio-0> at 0
[    0.050800] Switching to clocksource kvm-clock
[    0.050800] Warning: could not register annotated branches stats
[    0.169191] AppArmor: AppArmor Filesystem Enabled
[    0.171843] NET: Registered protocol family 1
[    0.174312] Unpacking initramfs...
[    1.802599] Freeing initrd memory: 25284k freed
[    2.186490] DMA-API: preallocated 32768 debug entries
[    2.187366] DMA-API: debugging enabled by kernel config
[    2.188599] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    2.192453] audit: initializing netlink socket (disabled)
[    2.193520] type=2000 audit(1342009738.192:1): initialized
[    2.204262] Testing tracer function: PASSED
[    2.316842] Testing tracer irqsoff: PASSED
[    2.317985] Testing tracer preemptoff: PASSED
[    2.318984] Testing tracer preemptirqsoff: PASSED
[    2.320411] Testing tracer wakeup: [    2.632565] ftrace-test (15) used greatest stack depth: 7284 bytes left
PASSED
[    2.634231] Testing tracer wakeup_rt: [    2.716312] ------------[ cut here ]------------
[    2.717208] WARNING: at /c/wfg/linux/kernel/rcutiny.c:92 rcu_idle_enter+0xf0/0x244()
[    2.718549] Hardware name: Bochs

[    2.719136] Modules linked in:
[    2.719754] 
[    2.720022] Pid: 0, comm: swapper Not tainted 3.5.0-rc6+ #55
[    2.720290] Call Trace:
[    2.720290]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.720290]  [<c11057f5>] ? rcu_idle_enter+0xf0/0x244
[    2.720290]  [<c11057f5>] ? rcu_idle_enter+0xf0/0x244
[    2.720290]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.720290]  [<c11057f5>] rcu_idle_enter+0xf0/0x244
[    2.720290]  [<c100fbdb>] cpu_idle+0x159/0x220
[    2.720290]  [<c141615f>] rest_init+0x2db/0x2ef
[    2.720290]  [<c1415e84>] ? reciprocal_value+0x64/0x64
[    2.720290]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.720290]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.720290]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.720290] ---[ end trace 44593438a59a9533 ]---
[    2.732372] ------------[ cut here ]------------
[    2.733235] WARNING: at /c/wfg/linux/kernel/rcutiny.c:113 rcu_irq_exit+0x100/0x217()
[    2.734613] Hardware name: Bochs
[    2.735204] Modules linked in:
[    2.735817] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc6+ #55
[    2.736366] Call Trace:
[    2.736366]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.736366]  [<c11055ee>] ? rcu_irq_exit+0x100/0x217
[    2.736366]  [<c11055ee>] ? rcu_irq_exit+0x100/0x217
[    2.736366]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.736366]  [<c11055ee>] rcu_irq_exit+0x100/0x217
[    2.736366]  [<c104697f>] irq_exit+0x117/0x14d
[    2.736366]  [<c1005d31>] do_IRQ+0xe5/0x106
[    2.736366]  [<c10b9fea>] ? trace_hardirqs_off_caller+0x97/0x167
[    2.736366]  [<c1045eb2>] ? local_bh_enable+0x3c/0x3c
[    2.736366]  [<c1437575>] common_interrupt+0x35/0x3c
[    2.736366]  [<c1045eb2>] ? local_bh_enable+0x3c/0x3c
[    2.736366]  [<c104007b>] ? do_wait+0x453/0x4f5
[    2.736366]  [<c104007b>] ? do_wait+0x453/0x4f5
[    2.736366]  [<c10b00e0>] ? do_timer+0xc1e/0xc77
[    2.736366]  [<c1044284>] ? arch_local_irq_enable+0x13/0x27
[    2.736366]  [<c1045f4f>] __do_softirq+0x9d/0x4fd
[    2.736366]  [<c1045eb2>] ? local_bh_enable+0x3c/0x3c
[    2.736366]  <IRQ>  [<c10468fa>] ? irq_exit+0x92/0x14d
[    2.736366]  [<c1005d31>] ? do_IRQ+0xe5/0x106
[    2.736366]  [<c10b9fea>] ? trace_hardirqs_off_caller+0x97/0x167
[    2.736366]  [<c1437575>] ? common_interrupt+0x35/0x3c
[    2.736366]  [<c10b00e0>] ? do_timer+0xc1e/0xc77
[    2.736366]  [<c1025c7b>] ? native_safe_halt+0x13/0x23
[    2.736366]  [<c100e52a>] ? default_idle+0xac/0x14a
[    2.736366]  [<c100fbef>] ? cpu_idle+0x16d/0x220
[    2.736366]  [<c141615f>] ? rest_init+0x2db/0x2ef
[    2.736366]  [<c1415e84>] ? reciprocal_value+0x64/0x64
[    2.736366]  [<c171d456>] ? start_kernel+0x8eb/0x8ff
[    2.736366]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.736366]  [<c171c342>] ? i386_start_kernel+0xf8/0x10b
[    2.736366] ---[ end trace 44593438a59a9534 ]---
[    2.765933] ------------[ cut here ]------------
[    2.766811] WARNING: at /c/wfg/linux/kernel/rcutiny.c:149 rcu_idle_exit+0xfa/0x266()
[    2.768173] Hardware name: Bochs
[    2.768927] Modules linked in:
[    2.769514] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc6+ #55
[    2.769920] Call Trace:
[    2.769920]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.769920]  [<c11033be>] ? rcu_idle_exit+0xfa/0x266
[    2.769920]  [<c11033be>] ? rcu_idle_exit+0xfa/0x266
[    2.769920]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.769920]  [<c11033be>] rcu_idle_exit+0xfa/0x266
[    2.769920]  [<c100fc02>] cpu_idle+0x180/0x220
[    2.769920]  [<c141615f>] rest_init+0x2db/0x2ef
[    2.769920]  [<c1415e84>] ? reciprocal_value+0x64/0x64
[    2.769920]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.769920]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.769920]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.769920] ---[ end trace 44593438a59a9535 ]---
[    2.988523] PASSED
[    2.989074] Testing tracer branch: PASSED
[    3.098361] msgmni has been set to 461
[    3.100578] cryptomgr_test (20) used greatest stack depth: 7276 bytes left
[    3.105178] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    3.106622] io scheduler noop registered (default)
[    3.107538] start plist test
[    3.114204] end plist test
[    3.115307] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    3.116361] crc32: self tests passed, processed 225944 bytes in 224426 nsec
[    3.117948] crc32c: CRC_LE_BITS = 32
[    3.118602] crc32c: self tests passed, processed 225944 bytes in 113842 nsec
[    3.240336] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    3.267021] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.031895] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.033648] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.038039] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.042997] Running tests on trace events:
[    4.043787] Testing event kfree_skb: OK
[    4.053003] Testing event consume_skb: OK
[    4.060772] Testing event skb_copy_datagram_iovec: OK
[    4.068784] Testing event net_dev_xmit: OK
[    4.076749] Testing event net_dev_queue: OK
[    4.084757] Testing event netif_receive_skb: OK
[    4.092773] Testing event netif_rx: OK
[    4.100746] Testing event napi_poll: OK
[    4.108793] Testing event sock_rcvqueue_full: OK
[    4.116759] Testing event sock_exceed_buf_limit: OK
[    4.124761] Testing event udp_fail_queue_rcv_skb: OK
[    4.132823] Testing event regmap_reg_write: OK
[    4.140755] Testing event regmap_reg_read: OK
[    4.148872] Testing event regmap_reg_read_cache: OK
[    4.156762] Testing event regmap_hw_read_start: OK
[    4.164772] Testing event regmap_hw_read_done: OK
[    4.172771] Testing event regmap_hw_write_start: OK
[    4.180811] Testing event regmap_hw_write_done: OK
[    4.188781] Testing event regcache_sync: OK
[    4.196804] Testing event regmap_cache_only: OK
[    4.204779] Testing event regmap_cache_bypass: OK
[    4.212765] Testing event regulator_enable: OK
[    4.220779] Testing event regulator_enable_delay: OK
[    4.228805] Testing event regulator_enable_complete: OK
[    4.236788] Testing event regulator_disable: OK
[    4.244793] Testing event regulator_disable_complete: OK
[    4.252753] Testing event regulator_set_voltage: OK
[    4.260805] Testing event regulator_set_voltage_complete: OK
[    4.268826] Testing event gpio_direction: OK
[    4.276906] Testing event gpio_value: OK
[    4.284918] Testing event block_rq_abort: OK
[    4.292905] Testing event block_rq_requeue: OK
[    4.300914] Testing event block_rq_complete: OK
[    4.308929] Testing event block_rq_insert: OK
[    4.316926] Testing event block_rq_issue: OK
[    4.324930] Testing event block_bio_bounce: OK
[    4.333003] Testing event block_bio_complete: OK
[    4.340927] Testing event block_bio_backmerge: OK
[    4.348945] Testing event block_bio_frontmerge: OK
[    4.356871] Testing event block_bio_queue: OK
[    4.364948] Testing event block_getrq: OK
[    4.372879] Testing event block_sleeprq: OK
[    4.380922] Testing event block_plug: OK
[    4.388915] Testing event block_unplug: OK
[    4.396932] Testing event block_split: OK
[    4.404914] Testing event block_bio_remap: OK
[    4.412935] Testing event block_rq_remap: OK
[    4.420910] Testing event writeback_nothread: OK
[    4.428974] Testing event writeback_queue: OK
[    4.436899] Testing event writeback_exec: OK
[    4.444942] Testing event writeback_start: OK
[    4.452954] Testing event writeback_written: OK
[    4.460927] Testing event writeback_wait: OK
[    4.468951] Testing event writeback_pages_written: OK
[    4.476938] Testing event writeback_nowork: OK
[    4.484896] Testing event writeback_wake_background: OK
[    4.492960] Testing event writeback_wake_thread: OK
[    4.500892] Testing event writeback_wake_forker_thread: OK
[    4.508894] Testing event writeback_bdi_register: OK
[    4.516878] Testing event writeback_bdi_unregister: OK
[    4.524881] Testing event writeback_thread_start: OK
[    4.532916] Testing event writeback_thread_stop: OK
[    4.540911] Testing event wbc_writepage: OK
[    4.548914] Testing event writeback_queue_io: OK
[    4.556898] Testing event global_dirty_state: OK
[    4.564896] Testing event bdi_dirty_ratelimit: OK
[    4.572932] Testing event balance_dirty_pages: OK
[    4.580898] Testing event writeback_sb_inodes_requeue: OK
[    4.588921] Testing event writeback_congestion_wait: OK
[    4.596887] Testing event writeback_wait_iff_congested: OK
[    4.604906] Testing event writeback_single_inode: OK
[    4.612959] Testing event mm_compaction_isolate_migratepages: OK
[    4.620909] Testing event mm_compaction_isolate_freepages: OK
[    4.628905] Testing event mm_compaction_migratepages: OK
[    4.636882] Testing event kmalloc: OK
[    4.644898] Testing event kmem_cache_alloc: OK
[    4.652894] Testing event kmalloc_node: OK
[    4.660951] Testing event kmem_cache_alloc_node: OK
[    4.668941] Testing event kfree: OK
[    4.676920] Testing event kmem_cache_free: OK
[    4.684945] Testing event mm_page_free: OK
[    4.693001] Testing event mm_page_free_batched: OK
[    4.700893] Testing event mm_page_alloc: OK
[    4.708920] Testing event mm_page_alloc_zone_locked: OK
[    4.716904] Testing event mm_page_pcpu_drain: OK
[    4.724921] Testing event mm_page_alloc_extfrag: OK
[    4.732899] Testing event mm_vmscan_kswapd_sleep: OK
[    4.740918] Testing event mm_vmscan_kswapd_wake: OK
[    4.748932] Testing event mm_vmscan_wakeup_kswapd: OK
[    4.756896] Testing event mm_vmscan_direct_reclaim_begin: OK
[    4.764918] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    4.772886] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    4.780888] Testing event mm_vmscan_direct_reclaim_end: OK
[    4.788944] Testing event mm_vmscan_memcg_reclaim_end: OK
[    4.796695] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    4.804699] Testing event mm_shrink_slab_start: OK
[    4.812704] Testing event mm_shrink_slab_end: OK
[    4.820703] Testing event mm_vmscan_lru_isolate: OK
[    4.828801] Testing event mm_vmscan_memcg_isolate: OK
[    4.836704] Testing event mm_vmscan_writepage: OK
[    4.844782] Testing event mm_vmscan_lru_shrink_inactive: OK
[    4.852730] Testing event oom_score_adj_update: OK
[    4.860787] Testing event cpu_idle: OK
[    4.868741] Testing event cpu_frequency: OK
[    4.876920] Testing event machine_suspend: OK
[    4.884796] Testing event wakeup_source_activate: OK
[    4.892773] Testing event wakeup_source_deactivate: OK
[    4.900773] Testing event clock_enable: OK
[    4.908769] Testing event clock_disable: OK
[    4.916766] Testing event clock_set_rate: OK
[    4.924801] Testing event power_domain_target: OK
[    4.932781] Testing event ftrace_test_filter: OK
[    4.940779] Testing event module_load: OK
[    4.948792] Testing event module_free: OK
[    4.956770] Testing event module_get: OK
[    4.964780] Testing event module_put: OK
[    4.972778] Testing event module_request: OK
[    4.980771] Testing event lock_acquire: [    4.981675] test-events (142) used greatest stack depth: 7248 bytes left
OK
[    4.988903] Testing event lock_release: [    4.989831] test-events (143) used greatest stack depth: 7164 bytes left
OK
[    4.996841] Testing event sched_kthread_stop: OK
[    5.004796] Testing event sched_kthread_stop_ret: OK
[    5.012798] Testing event sched_wakeup: OK
[    5.020767] Testing event sched_wakeup_new: OK
[    5.028823] Testing event sched_switch: OK
[    5.036784] Testing event sched_migrate_task: OK
[    5.044808] Testing event sched_process_free: OK
[    5.052824] Testing event sched_process_exit: OK
[    5.060788] Testing event sched_wait_task: OK
[    5.068798] Testing event sched_process_wait: OK
[    5.076794] Testing event sched_process_fork: OK
[    5.084794] Testing event sched_process_exec: OK
[    5.092796] Testing event sched_stat_wait: OK
[    5.100788] Testing event sched_stat_sleep: OK
[    5.108809] Testing event sched_stat_iowait: OK
[    5.116771] Testing event sched_stat_blocked: OK
[    5.124795] Testing event sched_stat_runtime: OK
[    5.132792] Testing event sched_pi_setprio: [    5.133751] test-events (161) used greatest stack depth: 7084 bytes left
OK
[    5.140790] Testing event rcu_utilization: OK
[    5.148798] Testing event rcu_dyntick: OK
[    5.156792] Testing event rcu_prep_idle: OK
[    5.164809] Testing event rcu_callback: OK
[    5.172807] Testing event rcu_kfree_callback: OK
[    5.180813] Testing event rcu_batch_start: OK
[    5.188797] Testing event rcu_invoke_callback: OK
[    5.196807] Testing event rcu_invoke_kfree_callback: OK
[    5.204783] Testing event rcu_batch_end: OK
[    5.212792] Testing event rcu_torture_read: OK
[    5.220773] Testing event workqueue_queue_work: OK
[    5.228780] Testing event workqueue_activate_work: OK
[    5.236760] Testing event workqueue_execute_start: OK
[    5.244803] Testing event workqueue_execute_end: OK
[    5.252791] Testing event signal_generate: OK
[    5.260767] Testing event signal_deliver: OK
[    5.268774] Testing event timer_init: OK
[    5.276760] Testing event timer_start: OK
[    5.284780] Testing event timer_expire_entry: OK
[    5.292779] Testing event timer_expire_exit: OK
[    5.300765] Testing event timer_cancel: OK
[    5.308836] Testing event hrtimer_init: OK
[    5.316761] Testing event hrtimer_start: OK
[    5.324771] Testing event hrtimer_expire_entry: OK
[    5.332859] Testing event hrtimer_expire_exit: OK
[    5.340817] Testing event hrtimer_cancel: OK
[    5.348863] Testing event itimer_state: OK
[    5.356809] Testing event itimer_expire: OK
[    5.364829] Testing event irq_handler_entry: OK
[    5.372831] Testing event irq_handler_exit: OK
[    5.380825] Testing event softirq_entry: OK
[    5.388793] Testing event softirq_exit: OK
[    5.396746] Testing event softirq_raise: OK
[    5.404812] Testing event console: OK
[    5.412730] Testing event task_newtask: OK
[    5.420791] Testing event task_rename: OK
[    5.428817] Testing event mce_record: OK
[    5.436884] Testing event sys_enter: OK
[    5.444825] Testing event sys_exit: OK
[    5.452837] Running tests on trace event systems:
[    5.453704] Testing event system skb: OK
[    5.460932] Testing event system net: OK
[    5.469099] Testing event system napi: OK
[    5.476931] Testing event system sock: OK
[    5.485014] Testing event system udp: OK
[    5.492972] Testing event system regmap: OK
[    5.501298] Testing event system regulator: OK
[    5.509195] Testing event system gpio: OK
[    5.517002] Testing event system block: OK
[    5.525734] Testing event system writeback: OK
[    5.533615] Testing event system compaction: OK
[    5.541130] Testing event system kmem: OK
[    5.549072] Testing event system vmscan: OK
[    5.557475] Testing event system oom: OK
[    5.564955] Testing event system power: OK
[    5.573075] Testing event system test: OK
[    5.580776] Testing event system module: OK
[    5.588946] Testing event system lock: OK
[    5.596943] Testing event system sched: OK
[    5.605240] Testing event system rcu: OK
[    5.613041] Testing event system workqueue: OK
[    5.620961] Testing event system signal: OK
[    5.628885] Testing event system timer: OK
[    5.637122] Testing event system irq: OK
[    5.645015] Testing event system printk: OK
[    5.652898] Testing event system task: OK
[    5.660894] Testing event system syscalls: OK
[    5.670033] Testing event system mce: OK
[    5.676815] Testing event system raw_syscalls: OK
[    5.684941] Running tests on all trace events:
[    5.685799] Testing all events: OK
[    5.714055] Running tests again, along with the function tracer
[    5.715374] Running tests on trace events:
[    5.716270] Testing event kfree_skb: OK
[    5.725996] Testing event consume_skb: [    5.728175] test-events (232) used greatest stack depth: 7016 bytes left
OK
[    5.738183] Testing event skb_copy_datagram_iovec: OK
[    5.750090] Testing event net_dev_xmit: OK
[    5.762196] Testing event net_dev_queue: OK
[    5.773921] Testing event netif_receive_skb: OK
[    5.786013] Testing event netif_rx: OK
[    5.794184] Testing event napi_poll: OK
[    5.805915] Testing event sock_rcvqueue_full: OK
[    5.818165] Testing event sock_exceed_buf_limit: OK
[    5.830027] Testing event udp_fail_queue_rcv_skb: OK
[    5.842170] Testing event regmap_reg_write: OK
[    5.853930] Testing event regmap_reg_read: OK
[    5.866189] Testing event regmap_reg_read_cache: OK
[    5.880124] Testing event regmap_hw_read_start: OK
[    5.890047] Testing event regmap_hw_read_done: OK
[    5.902187] Testing event regmap_hw_write_start: OK
[    5.914021] Testing event regmap_hw_write_done: OK
[    5.926217] Testing event regcache_sync: OK
[    5.937989] Testing event regmap_cache_only: OK
[    5.950211] Testing event regmap_cache_bypass: OK
[    5.962016] Testing event regulator_enable: OK
[    5.974206] Testing event regulator_enable_delay: OK
[    5.986063] Testing event regulator_enable_complete: OK
[    5.998204] Testing event regulator_disable: OK
[    6.010044] Testing event regulator_disable_complete: OK
[    6.022201] Testing event regulator_set_voltage: OK
[    6.034041] Testing event regulator_set_voltage_complete: OK
[    6.046391] Testing event gpio_direction: OK
[    6.058126] Testing event gpio_value: OK
[    6.070376] Testing event block_rq_abort: OK
[    6.082099] Testing event block_rq_requeue: OK
[    6.094342] Testing event block_rq_complete: OK
[    6.106138] Testing event block_rq_insert: OK
[    6.118333] Testing event block_rq_issue: OK
[    6.130143] Testing event block_bio_bounce: OK
[    6.142346] Testing event block_bio_complete: OK
[    6.154102] Testing event block_bio_backmerge: OK
[    6.166404] Testing event block_bio_frontmerge: OK
[    6.178099] Testing event block_bio_queue: OK
[    6.190366] Testing event block_getrq: OK
[    6.202157] Testing event block_sleeprq: OK
[    6.214310] Testing event block_plug: OK
[    6.226122] Testing event block_unplug: OK
[    6.238375] Testing event block_split: OK
[    6.250133] Testing event block_bio_remap: OK
[    6.262334] Testing event block_rq_remap: OK
[    6.274101] Testing event writeback_nothread: OK
[    6.286346] Testing event writeback_queue: OK
[    6.298130] Testing event writeback_exec: OK
[    6.310345] Testing event writeback_start: OK
[    6.323280] Testing event writeback_written: OK
[    6.335281] Testing event writeback_wait: OK
[    6.346145] Testing event writeback_pages_written: OK
[    6.359686] Testing event writeback_nowork: OK
[    6.375047] Testing event writeback_wake_background: OK
[    6.387264] Testing event writeback_wake_thread: OK
[    6.399336] Testing event writeback_wake_forker_thread: OK
[    6.415139] Testing event writeback_bdi_register: OK
[    6.427320] Testing event writeback_bdi_unregister: OK
[    6.443158] Testing event writeback_thread_start: OK
[    6.455272] Testing event writeback_thread_stop: OK
[    6.467271] Testing event wbc_writepage: OK
[    6.479069] Testing event writeback_queue_io: OK
[    6.490076] Testing event global_dirty_state: [    6.493193] test-events (295) used greatest stack depth: 7008 bytes left
OK
[    6.503629] Testing event bdi_dirty_ratelimit: OK
[    6.519152] Testing event balance_dirty_pages: OK
[    6.531327] Testing event writeback_sb_inodes_requeue: OK
[    6.547182] Testing event writeback_congestion_wait: OK
[    6.559350] Testing event writeback_wait_iff_congested: OK
[    6.574086] Testing event writeback_single_inode: OK
[    6.586525] Testing event mm_compaction_isolate_migratepages: OK
[    6.598267] Testing event mm_compaction_isolate_freepages: OK
[    6.610351] Testing event mm_compaction_migratepages: OK
[    6.622322] Testing event kmalloc: OK
[    6.634557] Testing event kmem_cache_alloc: OK
[    6.646441] Testing event kmalloc_node: OK
[    6.658317] Testing event kmem_cache_alloc_node: OK
[    6.670349] Testing event kfree: OK
[    6.682590] Testing event kmem_cache_free: OK
[    6.694269] Testing event mm_page_free: OK
[    6.706547] Testing event mm_page_free_batched: OK
[    6.718277] Testing event mm_page_alloc: OK
[    6.730653] Testing event mm_page_alloc_zone_locked: OK
[    6.742624] Testing event mm_page_pcpu_drain: OK
[    6.754289] Testing event mm_page_alloc_extfrag: OK
[    6.766321] Testing event mm_vmscan_kswapd_sleep: OK
[    6.778323] Testing event mm_vmscan_kswapd_wake: OK
[    6.790334] Testing event mm_vmscan_wakeup_kswapd: OK
[    6.802296] Testing event mm_vmscan_direct_reclaim_begin: OK
[    6.814359] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    6.826756] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    6.838856] Testing event mm_vmscan_direct_reclaim_end: OK
[    6.850325] Testing event mm_vmscan_memcg_reclaim_end: OK
[    6.862257] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    6.874262] Testing event mm_shrink_slab_start: OK
[    6.886265] Testing event mm_shrink_slab_end: OK
[    6.898266] Testing event mm_vmscan_lru_isolate: OK
[    6.910293] Testing event mm_vmscan_memcg_isolate: OK
[    6.922247] Testing event mm_vmscan_writepage: OK
[    6.935110] Testing event mm_vmscan_lru_shrink_inactive: OK
[    6.947397] Testing event oom_score_adj_update: OK
[    6.962147] Testing event cpu_idle: [    6.964499] test-events (333) used greatest stack depth: 6932 bytes left
OK
[    6.974284] Testing event cpu_frequency: OK
[    6.987360] Testing event machine_suspend: OK
[    6.999852] Testing event wakeup_source_activate: OK
[    7.014087] Testing event wakeup_source_deactivate: OK
[    7.026173] Testing event clock_enable: OK
[    7.033921] Testing event clock_disable: OK
[    7.042091] Testing event clock_set_rate: OK
[    7.049919] Testing event power_domain_target: OK
[    7.058033] Testing event ftrace_test_filter: OK
[    7.066393] Testing event module_load: OK
[    7.078499] Testing event module_free: OK
[    7.090146] Testing event module_get: OK
[    7.102362] Testing event module_put: OK
[    7.114336] Testing event module_request: OK
[    7.126614] Testing event lock_acquire: OK
[    7.138518] Testing event lock_release: OK
[    7.150531] Testing event sched_kthread_stop: OK
[    7.162368] Testing event sched_kthread_stop_ret: OK
[    7.174373] Testing event sched_wakeup: OK
[    7.186567] Testing event sched_wakeup_new: OK
[    7.198283] Testing event sched_switch: OK
[    7.210533] Testing event sched_migrate_task: OK
[    7.222314] Testing event sched_process_free: OK
[    7.234586] Testing event sched_process_exit: OK
[    7.246361] Testing event sched_wait_task: OK
[    7.258333] Testing event sched_process_wait: OK
[    7.270372] Testing event sched_process_fork: OK
[    7.282374] Testing event sched_process_exec: OK
[    7.294382] Testing event sched_stat_wait: OK
[    7.306572] Testing event sched_stat_sleep: OK
[    7.318341] Testing event sched_stat_iowait: OK
[    7.330392] Testing event sched_stat_blocked: OK
[    7.342406] Testing event sched_stat_runtime: OK
[    7.354388] Testing event sched_pi_setprio: OK
[    7.366380] Testing event rcu_utilization: OK
[    7.378518] Testing event rcu_dyntick: OK
[    7.390366] Testing event rcu_prep_idle: OK
[    7.402093] Testing event rcu_callback: OK
[    7.410104] Testing event rcu_kfree_callback: OK
[    7.423154] Testing event rcu_batch_start: OK
[    7.434009] Testing event rcu_invoke_callback: OK
[    7.446316] Testing event rcu_invoke_kfree_callback: OK
[    7.458660] Testing event rcu_batch_end: OK
[    7.470578] Testing event rcu_torture_read: OK
[    7.482259] Testing event workqueue_queue_work: OK
[    7.494704] Testing event workqueue_activate_work: OK
[    7.506768] Testing event workqueue_execute_start: OK
[    7.518510] Testing event workqueue_execute_end: OK
[    7.530065] Testing event signal_generate: OK
[    7.542154] Testing event signal_deliver: OK
[    7.549942] Testing event timer_init: OK
[    7.558084] Testing event timer_start: OK
[    7.565923] Testing event timer_expire_entry: OK
[    7.574104] Testing event timer_expire_exit: OK
[    7.581919] Testing event timer_cancel: OK
[    7.589932] Testing event hrtimer_init: OK
[    7.598132] Testing event hrtimer_start: OK
[    7.606082] Testing event hrtimer_expire_entry: OK
[    7.618083] Testing event hrtimer_expire_exit: OK
[    7.626270] Testing event hrtimer_cancel: OK
[    7.638548] Testing event itimer_state: OK
[    7.650410] Testing event itimer_expire: OK
[    7.662375] Testing event irq_handler_entry: OK
[    7.674363] Testing event irq_handler_exit: OK
[    7.686353] Testing event softirq_entry: OK
[    7.698536] Testing event softirq_exit: OK
[    7.710363] Testing event softirq_raise: OK
[    7.722540] Testing event console: OK
[    7.734287] Testing event task_newtask: OK
[    7.746551] Testing event task_rename: OK
[    7.758294] Testing event mce_record: OK
[    7.770625] Testing event sys_enter: OK
[    7.782375] Testing event sys_exit: OK
[    7.794597] Running tests on trace event systems:
[    7.795748] Testing event system skb: OK
[    7.807346] Testing event system net: OK
[    7.819750] Testing event system napi: OK
[    7.830875] Testing event system sock: OK
[    7.843065] Testing event system udp: OK
[    7.854420] Testing event system regmap: OK
[    7.869213] Testing event system regulator: OK
[    7.883852] Testing event system gpio: OK
[    7.894669] Testing event system block: OK
[    7.914486] Testing event system writeback: OK
[    7.937341] Testing event system compaction: OK
[    7.950846] Testing event system kmem: OK
[    7.969644] Testing event system vmscan: OK
[    7.990296] Testing event system oom: OK
[    8.002618] Testing event system power: OK
[    8.016018] Testing event system test: OK
[    8.026286] Testing event system module: OK
[    8.039572] Testing event system lock: OK
[    8.051139] Testing event system sched: OK
[    8.071301] Testing event system rcu: OK
[    8.089198] Testing event system workqueue: OK
[    8.103250] Testing event system signal: OK
[    8.114780] Testing event system timer: OK
[    8.133559] Testing event system irq: OK
[    8.147881] Testing event system printk: OK
[    8.158611] Testing event system task: OK
[    8.171287] Testing event system syscalls: OK
[    8.205510] Testing event system mce: OK
[    8.219449] Testing event system raw_syscalls: OK
[    8.230635] Running tests on all trace events:
[    8.231621] Testing all events: OK
[    8.553931] Testing ftrace filter: OK
[    8.557989] Testing kprobe tracing: OK
modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


[    8.577448] modprobe (440) used greatest stack depth: 6432 bytes left
modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


[    8.584867] Key type encrypted registered
modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


[    8.599191] IMA: No TPM chip found, activating TPM-bypass!
[    8.601935] ### of_selftest(): No testcase data in device tree; not running tests
[    8.604474] Freeing unused kernel memory: 420k freed
modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


libudev: udev_monitor_new_from_netlink_fd: error getting socket: Protocol not supported
mountall:mountall.c:3801: Assertion failed in main: udev_monitor = udev_monitor_new_from_netlink (udev, "udev")
modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6+/modules.dep: No such file or directory


General error mounting filesystems.
A maintenance shell will now be started.
CONTROL-D will terminate this shell and reboot the system.
wfg: rebooting
[    8.872159] Restarting system.
[    8.872838] machine restart

--KsGdsel6WgEHnImy--
