Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab2GLOLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:11:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:14414 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab2GLOLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:11:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="176489565"
Date: Thu, 12 Jul 2012 22:11:30 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: rcu_dyntick and suspicious RCU usage
Message-ID: <20120712141130.GA20195@localhost>
References: <20120709135637.GA26040@localhost>
 <20120709145724.GA27095@localhost>
 <20120710044700.GA9462@localhost>
 <20120711074924.GD3819@linux.vnet.ibm.com>
 <20120711123616.GA27086@localhost>
 <20120711125559.GA27383@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20120711125559.GA27383@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 11, 2012 at 08:55:59PM +0800, Fengguang Wu wrote:
> On Wed, Jul 11, 2012 at 08:36:16PM +0800, Fengguang Wu wrote:
> > On Wed, Jul 11, 2012 at 12:49:24AM -0700, Paul E. McKenney wrote:
> > > On Tue, Jul 10, 2012 at 12:47:00PM +0800, Fengguang Wu wrote:
> > > > Hi Paul,
> > > > 
> > > > Fortunately this bug is bisectable and the first bad commit is:
> > > > 
> > > >         commit 9b2e4f1880b789be1f24f9684f7a54b90310b5c0
> > > >         Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > >         Date:   Fri Sep 30 12:10:22 2011 -0700
> > > > 
> > > >             rcu: Track idleness independent of idle tasks
> > > 
> > > OK, there is a problem in TINY_RCU's handling of dyntick-idle: it
> > > traces while in idle.  The confusion on my part was that in TREE_RCU,
> > > the nesting and dyntick-idle indication are different, while in
> > > TINY_RCU they are one and the same.
> > > 
> > > Does the following patch help?
> > 
> > Not exactly, but the error message is now changed to:
> 
> Then I think it may help to test the linux-next tree that contains
> latest RCU fixes. And it somehow helped. There are no warnings in
> the linux-next tree 1 or 2 days ago; there is a maybe unrelated warning
> in today's linux-next tree.
> 
> [    0.013241] Performance Events: 
> [    0.014222] ------------[ cut here ]------------
> [    0.014975] WARNING: at /c/wfg/linux/kernel/workqueue.c:1217 worker_enter_idle+0x2fa/0x37c()

That's bisected to one of Tejun's workqueue commit..

> Both trees freeze after this point:
> 
> modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6-next-20120710+/modules.dep: No such file or directory
> ^M
> modprobe: FATAL: Could not load /lib/modules/3.5.0-rc6-next-20120710+/modules.dep: No such file or directory
> ^M

And that's bisected to Al's vfs work..

> So I'd better to base the test on one of your RCU branches..
> Which branch would your recommend?

And finally I tried the patch on top of rcu/next, and get the attached
dmesg and warnings:

[    1.776415] Testing tracer preemptirqsoff: PASSED
[    1.779383] Testing tracer wakeup: [    2.091320] ftrace-test (15) used greatest stack depth: 7284 bytes left
PASSED
[    2.094844] Testing tracer wakeup_rt: [    2.179052] ------------[ cut here ]------------
[    2.181087] WARNING: at /c/wfg/linux/kernel/rcutiny.c:92 rcu_idle_enter+0xf0/0x244()     
[    2.183023] Hardware name: Bochs

[    2.183023] Modules linked in:
[    2.183023]
[    2.183023] Pid: 0, comm: swapper Not tainted 3.5.0-rc5+ #59
[    2.183023] Call Trace:
[    2.183023]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.183023]  [<c1105d31>] ? rcu_idle_enter+0xf0/0x244    
[    2.183023]  [<c1105d31>] ? rcu_idle_enter+0xf0/0x244
[    2.183023]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.183023]  [<c1105d31>] rcu_idle_enter+0xf0/0x244   
[    2.183023]  [<c100fbdb>] cpu_idle+0x159/0x220     
[    2.183023]  [<c14165a3>] rest_init+0x2db/0x2ef
[    2.183023]  [<c14162c8>] ? reciprocal_value+0x64/0x64
[    2.183023]  [<c171d456>] start_kernel+0x8eb/0x8ff    
[    2.183023]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.183023]  [<c171c342>] i386_start_kernel+0xf8/0x10b 
[    2.183023] ---[ end trace 44593438a59a9533 ]---      
[    2.195679] ------------[ cut here ]------------
[    2.196428] WARNING: at /c/wfg/linux/kernel/rcutiny.c:113 rcu_irq_exit+0x100/0x217()
[    2.197633] Hardware name: Bochs
[    2.198183] Modules linked in:
[    2.198695] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc5+ #59
[    2.199671] Call Trace:
[    2.199671]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.199671]  [<c1105b2a>] ? rcu_irq_exit+0x100/0x217     
[    2.199671]  [<c1105b2a>] ? rcu_irq_exit+0x100/0x217
[    2.199671]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.199671]  [<c1105b2a>] rcu_irq_exit+0x100/0x217
[    2.199671]  [<c10469ae>] irq_exit+0x117/0x14d
[    2.199671]  [<c1005d31>] do_IRQ+0xe5/0x106
[    2.199671]  [<c10ba77e>] ? trace_hardirqs_off_caller+0x97/0x167
[    2.199671]  [<c1437975>] common_interrupt+0x35/0x3c            
[    2.199671]  [<c10c00e0>] ? trace_hardirqs_on_caller+0x1b8/0x38c
[    2.199671]  [<c1025c7b>] ? native_safe_halt+0x13/0x23                          

The same rcu/next HEAD w/o patch, the warning is:

[    4.456093] Testing event rcu_dyntick: [    4.458251] 
[    4.458941] ===============================
[    4.459352] [ INFO: suspicious RCU usage. ]
[    4.459352] 3.5.0-rc5+ #60 Not tainted
[    4.459352] -------------------------------
[    4.459352] /c/wfg/linux/include/trace/events/rcu.h:275 suspicious rcu_dereference_check() usage!
[    4.459352] 
[    4.459352] other info that might help us debug this:
[    4.459352] 
[    4.459352] 
[    4.459352] RCU used illegally from idle CPU!
[    4.459352] rcu_scheduler_active = 1, debug_locks = 0
[    4.459352] RCU used illegally from extended quiescent state!
[    4.459352] no locks held by swapper/0.
[    4.459352] 
[    4.459352] stack backtrace:
[    4.459352] Pid: 0, comm: swapper Not tainted 3.5.0-rc5+ #60
[    4.459352] Call Trace:

[    4.459352] 
[    4.459352]  [<c10bbb36>] lockdep_rcu_suspicious+0x1de/0x1f4
[    4.459352]  [<c1103171>] trace_rcu_dyntick+0xd9/0x167
[    4.459352]  [<c1105865>] rcu_idle_enter_common+0x84/0x22d
[    4.459352]  [<c10ba77e>] ? trace_hardirqs_off_caller+0x97/0x167
[    4.459352]  [<c1105d98>] rcu_idle_enter+0x16d/0x274
[    4.459352]  [<c100fbdb>] cpu_idle+0x159/0x220
[    4.459352]  [<c14165c3>] rest_init+0x2db/0x2ef
[    4.459352]  [<c14162e8>] ? reciprocal_value+0x64/0x64
[    4.459352]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    4.459352]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    4.459352]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    4.481163] OK 
[    4.481437] Testing event rcu_prep_idle: OK

That's a great kconfig (from the testing respective)! :-P

Thanks,
Fengguang

--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg-kvm_bisect-waimea-5209-2012-07-12-22-02-55

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.5.0-rc5+ (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #59 PREEMPT Thu Jul 12 21:54:52 CST 2012
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
[    0.000000] free_area_init_node: node 0, pgdat c16fc648, node_mem_map ce53f200
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
[    0.000000] Kernel command line: bisect-reboot i386-randconfig run_test= trinity=0 auth_hashtable_size=10 sunrpc.auth_hashtable_size=10 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=i386/vmlinuz-bisect
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 194540k/262132k available (4320k kernel code, 67140k reserved, 2956k data, 420k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfffcf000 - 0xfffff000   ( 192 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xd07fd000 - 0xff7fe000   ( 752 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xcfffd000   ( 255 MB)
[    0.000000]       .init : 0xc171c000 - 0xc1785000   ( 420 kB)
[    0.000000]       .data : 0xc14381b5 - 0xc171b2c0   (2956 kB)
[    0.000000]       .text : 0xc1000000 - 0xc14381b5   (4320 kB)
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
[    0.004000] Security Framework initialized
[    0.004000] AppArmor: AppArmor initialized
[    0.004081] Mount-cache hash table entries: 512
[    0.006958] Initializing cgroup subsys debug
[    0.007642] Initializing cgroup subsys devices
[    0.008012] Initializing cgroup subsys freezer
[    0.008728] Initializing cgroup subsys perf_event
[    0.009609] mce: CPU supports 10 MCE banks
[    0.010257] MCE: unknown CPU type - not enabling MCE support.
[    0.011220] CPU: GenuineIntel Common KVM processor stepping 01
[    0.013743] Performance Events: 
[    0.015155] Testing tracer nop: 
[    0.015751] PASSED
[    0.017134] EVM: security.capability
[    0.020734] dummy: 
[    0.023608] NET: Registered protocol family 16
[    0.026087] bio: create slab <bio-0> at 0
[    0.028472] Switching to clocksource kvm-clock
[    0.029925] Warning: could not register annotated branches stats
[    0.082912] AppArmor: AppArmor Filesystem Enabled
[    0.084341] NET: Registered protocol family 1
[    0.085851] Unpacking initramfs...
[    1.298131] Freeing initrd memory: 25284k freed
[    1.644753] DMA-API: preallocated 32768 debug entries
[    1.645575] DMA-API: debugging enabled by kernel config
[    1.647311] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.650616] audit: initializing netlink socket (disabled)
[    1.651587] type=2000 audit(1342101770.648:1): initialized
[    1.660363] Testing tracer function: PASSED
[    1.772155] Testing tracer irqsoff: PASSED
[    1.774336] Testing tracer preemptoff: PASSED
[    1.776415] Testing tracer preemptirqsoff: PASSED
[    1.779383] Testing tracer wakeup: [    2.091320] ftrace-test (15) used greatest stack depth: 7284 bytes left
PASSED
[    2.094844] Testing tracer wakeup_rt: [    2.179052] ------------[ cut here ]------------
[    2.181087] WARNING: at /c/wfg/linux/kernel/rcutiny.c:92 rcu_idle_enter+0xf0/0x244()
[    2.183023] Hardware name: Bochs

[    2.183023] Modules linked in:
[    2.183023] 
[    2.183023] Pid: 0, comm: swapper Not tainted 3.5.0-rc5+ #59
[    2.183023] Call Trace:
[    2.183023]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.183023]  [<c1105d31>] ? rcu_idle_enter+0xf0/0x244
[    2.183023]  [<c1105d31>] ? rcu_idle_enter+0xf0/0x244
[    2.183023]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.183023]  [<c1105d31>] rcu_idle_enter+0xf0/0x244
[    2.183023]  [<c100fbdb>] cpu_idle+0x159/0x220
[    2.183023]  [<c14165a3>] rest_init+0x2db/0x2ef
[    2.183023]  [<c14162c8>] ? reciprocal_value+0x64/0x64
[    2.183023]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.183023]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.183023]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.183023] ---[ end trace 44593438a59a9533 ]---
[    2.195679] ------------[ cut here ]------------
[    2.196428] WARNING: at /c/wfg/linux/kernel/rcutiny.c:113 rcu_irq_exit+0x100/0x217()
[    2.197633] Hardware name: Bochs
[    2.198183] Modules linked in:
[    2.198695] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc5+ #59
[    2.199671] Call Trace:
[    2.199671]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.199671]  [<c1105b2a>] ? rcu_irq_exit+0x100/0x217
[    2.199671]  [<c1105b2a>] ? rcu_irq_exit+0x100/0x217
[    2.199671]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.199671]  [<c1105b2a>] rcu_irq_exit+0x100/0x217
[    2.199671]  [<c10469ae>] irq_exit+0x117/0x14d
[    2.199671]  [<c1005d31>] do_IRQ+0xe5/0x106
[    2.199671]  [<c10ba77e>] ? trace_hardirqs_off_caller+0x97/0x167
[    2.199671]  [<c1437975>] common_interrupt+0x35/0x3c
[    2.199671]  [<c10c00e0>] ? trace_hardirqs_on_caller+0x1b8/0x38c
[    2.199671]  [<c1025c7b>] ? native_safe_halt+0x13/0x23
[    2.199671]  [<c100e52a>] default_idle+0xac/0x14a
[    2.199671]  [<c100fbef>] cpu_idle+0x16d/0x220
[    2.199671]  [<c14165a3>] rest_init+0x2db/0x2ef
[    2.199671]  [<c14162c8>] ? reciprocal_value+0x64/0x64
[    2.199671]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.199671]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.199671]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.199671] ---[ end trace 44593438a59a9534 ]---
[    2.215264] ------------[ cut here ]------------
[    2.216013] WARNING: at /c/wfg/linux/kernel/rcutiny.c:149 rcu_idle_exit+0xfa/0x266()
[    2.217199] Hardware name: Bochs
[    2.217716] Modules linked in:
[    2.218232] Pid: 0, comm: swapper Tainted: G        W    3.5.0-rc5+ #59
[    2.219255] Call Trace:
[    2.219255]  [<c103704c>] warn_slowpath_common+0xfc/0x13b
[    2.219255]  [<c1103b21>] ? rcu_idle_exit+0xfa/0x266
[    2.219255]  [<c1103b21>] ? rcu_idle_exit+0xfa/0x266
[    2.219255]  [<c10370c9>] warn_slowpath_null+0x3e/0x4e
[    2.219255]  [<c1103b21>] rcu_idle_exit+0xfa/0x266
[    2.219255]  [<c100fc02>] cpu_idle+0x180/0x220
[    2.219255]  [<c14165a3>] rest_init+0x2db/0x2ef
[    2.219255]  [<c14162c8>] ? reciprocal_value+0x64/0x64
[    2.219255]  [<c171d456>] start_kernel+0x8eb/0x8ff
[    2.219255]  [<c171c62f>] ? repair_env_string+0xd3/0xd3
[    2.219255]  [<c171c342>] i386_start_kernel+0xf8/0x10b
[    2.219255] ---[ end trace 44593438a59a9535 ]---
[    2.439202] PASSED
[    2.440272] Testing tracer branch: PASSED
[    2.552720] msgmni has been set to 461
[    2.555224] cryptomgr_test (20) used greatest stack depth: 7276 bytes left
[    2.556806] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    2.558009] io scheduler noop registered (default)
[    2.558771] start plist test
[    2.565269] end plist test
[    2.566156] crc32: CRC_LE_BITS = 32, CRC_BE BITS = 32
[    2.567072] crc32: self tests passed, processed 225944 bytes in 197792 nsec
[    2.568436] crc32c: CRC_LE_BITS = 32
[    2.569006] crc32c: self tests passed, processed 225944 bytes in 104239 nsec
[    2.656189] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    2.682074] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.447151] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.451261] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.455394] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    3.458286] Running tests on trace events:
[    3.458991] Testing event kfree_skb: OK
[    3.468175] Testing event consume_skb: OK
[    3.475825] Testing event skb_copy_datagram_iovec: OK
[    3.483917] Testing event net_dev_xmit: OK
[    3.491767] Testing event net_dev_queue: OK
[    3.499338] Testing event netif_receive_skb: OK
[    3.507871] Testing event netif_rx: OK
[    3.515348] Testing event napi_poll: OK
[    3.523841] Testing event sock_rcvqueue_full: OK
[    3.531939] Testing event sock_exceed_buf_limit: OK
[    3.539837] Testing event udp_fail_queue_rcv_skb: OK
[    3.547924] Testing event regmap_reg_write: OK
[    3.555276] Testing event regmap_reg_read: OK
[    3.563834] Testing event regmap_reg_read_cache: OK
[    3.571771] Testing event regmap_hw_read_start: OK
[    3.579956] Testing event regmap_hw_read_done: OK
[    3.587841] Testing event regmap_hw_write_start: OK
[    3.595275] Testing event regmap_hw_write_done: OK
[    3.603879] Testing event regcache_sync: OK
[    3.611959] Testing event regmap_cache_only: OK
[    3.619850] Testing event regmap_cache_bypass: OK
[    3.627951] Testing event regulator_enable: OK
[    3.635357] Testing event regulator_enable_delay: OK
[    3.643847] Testing event regulator_enable_complete: OK
[    3.652003] Testing event regulator_disable: OK
[    3.659912] Testing event regulator_disable_complete: OK
[    3.667958] Testing event regulator_set_voltage: OK
[    3.675342] Testing event regulator_set_voltage_complete: OK
[    3.683759] Testing event gpio_direction: OK
[    3.692005] Testing event gpio_value: OK
[    3.699942] Testing event block_rq_abort: OK
[    3.707630] Testing event block_rq_requeue: OK
[    3.715350] Testing event block_rq_complete: OK
[    3.723851] Testing event block_rq_insert: OK
[    3.731871] Testing event block_rq_issue: OK
[    3.740007] Testing event block_bio_bounce: OK
[    3.747672] Testing event block_bio_complete: OK
[    3.755289] Testing event block_bio_backmerge: OK
[    3.763882] Testing event block_bio_frontmerge: OK
[    3.771911] Testing event block_bio_queue: OK
[    3.779867] Testing event block_getrq: OK
[    3.787880] Testing event block_sleeprq: OK
[    3.795911] Testing event block_plug: OK
[    3.803865] Testing event block_unplug: OK
[    3.811883] Testing event block_split: OK
[    3.819947] Testing event block_bio_remap: OK
[    3.827670] Testing event block_rq_remap: OK
[    3.835335] Testing event writeback_nothread: OK
[    3.843876] Testing event writeback_queue: OK
[    3.851988] Testing event writeback_exec: OK
[    3.859889] Testing event writeback_start: OK
[    3.867733] Testing event writeback_written: OK
[    3.875295] Testing event writeback_wait: OK
[    3.883858] Testing event writeback_pages_written: OK
[    3.891917] Testing event writeback_nowork: OK
[    3.899870] Testing event writeback_wake_background: OK
[    3.907887] Testing event writeback_wake_thread: OK
[    3.915346] Testing event writeback_wake_forker_thread: OK
[    3.923881] Testing event writeback_bdi_register: OK
[    3.931984] Testing event writeback_bdi_unregister: OK
[    3.939882] Testing event writeback_thread_start: OK
[    3.947723] Testing event writeback_thread_stop: OK
[    3.955345] Testing event wbc_writepage: OK
[    3.963849] Testing event writeback_queue_io: OK
[    3.971883] Testing event global_dirty_state: OK
[    3.980020] Testing event bdi_dirty_ratelimit: OK
[    3.987908] Testing event balance_dirty_pages: OK
[    3.995336] Testing event writeback_sb_inodes_requeue: OK
[    4.003891] Testing event writeback_congestion_wait: OK
[    4.011961] Testing event writeback_wait_iff_congested: OK
[    4.019879] Testing event writeback_single_inode: OK
[    4.027987] Testing event mm_compaction_isolate_migratepages: OK
[    4.035318] Testing event mm_compaction_isolate_freepages: OK
[    4.043879] Testing event mm_compaction_migratepages: OK
[    4.051971] Testing event kmalloc: OK
[    4.059869] Testing event kmem_cache_alloc: OK
[    4.067864] Testing event kmalloc_node: OK
[    4.075353] Testing event kmem_cache_alloc_node: OK
[    4.083919] Testing event kfree: OK
[    4.091888] Testing event kmem_cache_free: OK
[    4.099916] Testing event mm_page_free: OK
[    4.107537] Testing event mm_page_free_batched: OK
[    4.115756] Testing event mm_page_alloc: OK
[    4.123930] Testing event mm_page_alloc_zone_locked: OK
[    4.131739] Testing event mm_page_pcpu_drain: OK
[    4.139909] Testing event mm_page_alloc_extfrag: OK
[    4.147743] Testing event mm_vmscan_kswapd_sleep: OK
[    4.155890] Testing event mm_vmscan_kswapd_wake: OK
[    4.163769] Testing event mm_vmscan_wakeup_kswapd: OK
[    4.171870] Testing event mm_vmscan_direct_reclaim_begin: OK
[    4.179893] Testing event mm_vmscan_memcg_reclaim_begin: OK
[    4.187759] Testing event mm_vmscan_memcg_softlimit_reclaim_begin: OK
[    4.195307] Testing event mm_vmscan_direct_reclaim_end: OK
[    4.203884] Testing event mm_vmscan_memcg_reclaim_end: OK
[    4.211938] Testing event mm_vmscan_memcg_softlimit_reclaim_end: OK
[    4.219886] Testing event mm_shrink_slab_start: OK
[    4.227972] Testing event mm_shrink_slab_end: OK
[    4.235928] Testing event mm_vmscan_lru_isolate: OK
[    4.243994] Testing event mm_vmscan_memcg_isolate: OK
[    4.251879] Testing event mm_vmscan_writepage: OK
[    4.259929] Testing event mm_vmscan_lru_shrink_inactive: OK
[    4.268071] Testing event oom_score_adj_update: OK
[    4.275333] Testing event cpu_idle: OK
[    4.283907] Testing event cpu_frequency: OK
[    4.291907] Testing event machine_suspend: OK
[    4.299991] Testing event wakeup_source_activate: OK
[    4.307923] Testing event wakeup_source_deactivate: OK
[    4.315383] Testing event clock_enable: OK
[    4.323883] Testing event clock_disable: OK
[    4.331934] Testing event clock_set_rate: OK
[    4.339902] Testing event power_domain_target: OK
[    4.347878] Testing event ftrace_test_filter: OK
[    4.355411] Testing event module_load: OK
[    4.363905] Testing event module_free: OK
[    4.371901] Testing event module_get: OK
[    4.379929] Testing event module_put: OK
[    4.387897] Testing event module_request: OK
[    4.395342] Testing event lock_acquire: [    4.396705] test-events (142) used greatest stack depth: 7248 bytes left
OK
[    4.408079] Testing event lock_release: [    4.410133] test-events (143) used greatest stack depth: 7164 bytes left
OK
[    4.420035] Testing event sched_kthread_stop: OK
[    4.427994] Testing event sched_kthread_stop_ret: OK
[    4.435331] Testing event sched_wakeup: OK
[    4.443906] Testing event sched_wakeup_new: OK
[    4.451884] Testing event sched_switch: OK
[    4.460043] Testing event sched_migrate_task: OK
[    4.467900] Testing event sched_process_free: OK
[    4.475353] Testing event sched_process_exit: OK
[    4.483926] Testing event sched_wait_task: OK
[    4.492012] Testing event sched_process_wait: OK
[    4.499900] Testing event sched_process_fork: OK
[    4.508076] Testing event sched_process_exec: OK
[    4.515332] Testing event sched_stat_wait: OK
[    4.523928] Testing event sched_stat_sleep: OK
[    4.531906] Testing event sched_stat_iowait: OK
[    4.539975] Testing event sched_stat_blocked: OK
[    4.547772] Testing event sched_stat_runtime: OK
[    4.555348] Testing event sched_pi_setprio: [    4.556867] test-events (161) used greatest stack depth: 7084 bytes left
OK
[    4.568058] Testing event rcu_utilization: OK
[    4.575903] Testing event rcu_dyntick: OK
[    4.584027] Testing event rcu_prep_idle: OK
[    4.591920] Testing event rcu_callback: OK
[    4.599849] Testing event rcu_kfree_callback: OK
[    4.607889] Testing event rcu_batch_start: OK
[    4.615376] Testing event rcu_invoke_callback: OK
[    4.623937] Testing event rcu_invoke_kfree_callback: OK
[    4.632026] Testing event rcu_batch_end: OK
[    4.639988] Testing event rcu_torture_read: OK
[    4.647760] Testing event rcu_barrier: OK
[    4.655726] Testing event workqueue_queue_work: OK
[    4.663863] Testing event workqueue_activate_work: OK
[    4.671955] Testing event workqueue_execute_start: OK
[    4.679707] Testing event workqueue_execute_end: OK
[    4.687664] Testing event signal_generate: OK
[    4.695705] Testing event signal_deliver: OK
[    4.703735] Testing event timer_init: OK
[    4.711654] Testing event timer_start: OK
[    4.719695] Testing event timer_expire_entry: OK
[    4.727923] Testing event timer_expire_exit: OK
[    4.735763] Testing event timer_cancel: OK
[    4.743679] Testing event hrtimer_init: OK
[    4.751949] Testing event hrtimer_start: OK
[    4.759762] Testing event hrtimer_expire_entry: OK
[    4.767987] Testing event hrtimer_expire_exit: OK
[    4.775677] Testing event hrtimer_cancel: OK
[    4.783948] Testing event itimer_state: OK
[    4.791865] Testing event itimer_expire: OK
[    4.799947] Testing event irq_handler_entry: OK
[    4.808012] Testing event irq_handler_exit: OK
[    4.815975] Testing event softirq_entry: OK
[    4.823930] Testing event softirq_exit: OK
[    4.832016] Testing event softirq_raise: OK
[    4.839873] Testing event console: OK
[    4.847936] Testing event task_newtask: OK
[    4.855412] Testing event task_rename: OK
[    4.863949] Testing event mce_record: OK
[    4.871928] Testing event sys_enter: OK
[    4.880023] Testing event sys_exit: OK
[    4.887959] Running tests on trace event systems:
[    4.889909] Testing event system skb: OK
[    4.900203] Testing event system net: OK
[    4.908238] Testing event system napi: OK
[    4.915990] Testing event system sock: OK
[    4.924143] Testing event system udp: OK
[    4.931945] Testing event system regmap: OK
[    4.940601] Testing event system regulator: OK
[    4.952281] Testing event system gpio: OK
[    4.959397] Testing event system block: OK
[    4.967765] Testing event system writeback: OK
[    4.980014] Testing event system compaction: OK
[    4.988194] Testing event system kmem: OK
[    4.999628] Testing event system vmscan: OK
[    5.012917] Testing event system oom: OK
[    5.020007] Testing event system power: OK
[    5.027583] Testing event system test: OK
[    5.035394] Testing event system module: OK
[    5.044244] Testing event system lock: OK
[    5.052396] Testing event system sched: OK
[    5.065102] Testing event system rcu: OK
[    5.076579] Testing event system workqueue: OK
[    5.087519] Testing event system signal: OK
[    5.096121] Testing event system timer: OK
[    5.108936] Testing event system irq: OK
[    5.120296] Testing event system printk: OK
[    5.128076] Testing event system task: OK
[    5.136102] Testing event system syscalls: OK
[    5.151487] Testing event system mce: OK
[    5.159934] Testing event system raw_syscalls: OK
[    5.168032] Running tests on all trace events:
[    5.169914] Testing all events: OK
[    5.199547] Running tests again, along with the function tracer
[    5.200609] Running tests on trace events:
[    5.201372] Testing event kfree_skb: OK
[    5.213573] Testing event consume_skb: [    5.215246] test-events (233) used greatest stack depth: 7016 bytes left
OK
[    5.226438] Testing event skb_copy_datagram_iovec: OK
[    5.242197] Testing event net_dev_xmit: OK
[    5.253518] Testing event net_dev_queue: OK
[    5.265407] Testing event netif_receive_skb: OK
[    5.282051] Testing event netif_rx: OK
[    5.293104] Testing event napi_poll: OK
[    5.306565] Testing event sock_rcvqueue_full: OK
[    5.321990] Testing event sock_exceed_buf_limit: OK
[    5.333108] Testing event udp_fail_queue_rcv_skb: OK
[    5.346575] Testing event regmap_reg_write: OK
[    5.361518] Testing event regmap_reg_read: OK
[    5.373500] Testing event regmap_reg_read_cache: OK
[    5.386362] Testing event regmap_hw_read_start: OK
[    5.401230] Testing event regmap_hw_read_done: OK
[    5.413178] Testing event regmap_hw_write_start: OK
[    5.425872] Testing event regmap_hw_write_done: OK
[    5.441825] Testing event regcache_sync: OK
[    5.453636] Testing event regmap_cache_only: OK
[    5.466317] Testing event regmap_cache_bypass: OK
[    5.481581] Testing event regulator_enable: OK
[    5.493136] Testing event regulator_enable_delay: OK
[    5.505738] Testing event regulator_enable_complete: OK
[    5.520358] Testing event regulator_disable: OK
[    5.533691] Testing event regulator_disable_complete: OK
[    5.544449] Testing event regulator_set_voltage: OK
[    5.552614] Testing event regulator_set_voltage_complete: OK
[    5.564353] Testing event gpio_direction: OK
[    5.572550] Testing event gpio_value: OK
[    5.580436] Testing event block_rq_abort: OK
[    5.588621] Testing event block_rq_requeue: OK
[    5.596480] Testing event block_rq_complete: OK
[    5.604649] Testing event block_rq_insert: OK
[    5.612427] Testing event block_rq_issue: OK
[    5.620461] Testing event block_bio_bounce: OK
[    5.628637] Testing event block_bio_complete: OK
[    5.636371] Testing event block_bio_backmerge: OK
[    5.644605] Testing event block_bio_frontmerge: OK
[    5.652388] Testing event block_bio_queue: OK
[    5.660562] Testing event block_getrq: OK
[    5.668418] Testing event block_sleeprq: OK
[    5.676453] Testing event block_plug: OK
[    5.684676] Testing event block_unplug: OK
[    5.692511] Testing event block_split: [    5.694498] test-events (276) used greatest stack depth: 7008 bytes left
OK
[    5.704530] Testing event block_bio_remap: OK
[    5.712506] Testing event block_rq_remap: OK
[    5.720534] Testing event writeback_nothread: OK
[    5.728491] Testing event writeback_queue: 
--/04w6evG8XlLl3ft--
