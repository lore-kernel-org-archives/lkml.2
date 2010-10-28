Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab0J1NrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 09:47:07 -0400
Received: from shutemov.name ([188.40.19.243]:50979 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758796Ab0J1NrB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 09:47:01 -0400
Date: Thu, 28 Oct 2010 16:46:58 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Brian Gerst <brgerst@gmail.com>, David Howells <dhowells@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Venkatesh Pallipadi <venki@google.com>, x86@kernel.org
Subject: Re: [PATCH] preempt: fix kernel build with !CONFIG_BKL
Message-ID: <20101028134658.GA17769@shutemov.name>
References: <20101028095910.GA15970@shutemov.name>
 <201010281320.44765.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201010281320.44765.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Thu, Oct 28, 2010 at 01:20:44PM +0200, Arnd Bergmann wrote:
> The preempt count logic tries to take the BKL into account, which breaks
> when CONFIG_BKL is not set.
> 
> Use the same preempt_count offset that we use without CONFIG_PREEMPT
> when CONFIG_BKL is disabled.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>

Remove quotes, please.

> 
> ---
> > /home/kas/git/tmp/linux-2.6-local/arch/x86/include/asm/i387.h: In function ‘irq_ts_save’:
> > /home/kas/git/tmp/linux-2.6-local/arch/x86/include/asm/i387.h:324: error: implicit declaration of function ‘kernel_locked’
> > make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> > make: *** [prepare0] Error 2
> 
> Ah, found it. I had not considered or tested the case of CONFIG_BKL=n
> with CONFIG_PREEMPT=y.
> 
> Does this work? Ideally please test with LOCKDEP enabled to see if
> there are other problems in this configuration that I missed.

I've got a lot of __schedule_bug. Log attached.

Also reproducible with QEMU.

> --- a/include/linux/hardirq.h
> +++ b/include/linux/hardirq.h
> @@ -96,7 +96,7 @@
>   */
>  #define in_nmi()	(preempt_count() & NMI_MASK)
>  
> -#if defined(CONFIG_PREEMPT)
> +#if defined(CONFIG_PREEMPT) && defined(CONFIG_BKL)
>  # define PREEMPT_INATOMIC_BASE kernel_locked()
>  # define PREEMPT_CHECK_OFFSET 1
>  #else

-- 
 Kirill A. Shutemov

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii; name=log
Content-Disposition: attachment; filename=log

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.36+ (kas@t400.shutemov.name) (gcc version 4.4.5 20101001 (ALT Linux 4.4.5-alt1) (GCC) ) #60 SMP PREEMPT Thu Oct 28 16:07:47 EEST 2010
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 0000000007ffd000 (usable)
[    0.000000]  BIOS-e820: 0000000007ffd000 - 0000000008000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserved)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x7ffd max_arch_pfn = 0x100000
[    0.000000] init_memory_mapping: 0000000000000000-0000000007ffd000
[    0.000000] ACPI: RSDP 000fdbb0 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 07ffde30 00034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 07fffe70 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 07ffdfd0 01E22 (v01   BXPC   BXDSDT 00000001 INTL 20090123)
[    0.000000] ACPI: FACS 07fffe00 00040
[    0.000000] ACPI: SSDT 07ffdf90 00037 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 07ffdeb0 00072 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 07ffde70 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 127MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 07ffd000
[    0.000000]   low ram: 0 - 07ffd000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00007ffd
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x00007ffd
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 8000000 (gap: 8000000:f7fc0000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] converting mcount calls to 0f 1f 44 00 00
[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 332 pages/cpu @c7800000 s1339392 r0 d20480 u4194304
[    0.000000] pcpu-alloc: s1339392 r0 d20480 u4194304 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 32396
[    0.000000] Kernel command line: console=ttyS0,115200
[    0.000000] PID hash table entries: 512 (order: -1, 2048 bytes)
[    0.000000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] Inode-cache hash table entries: 8192 (order: 3, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 654980 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 115684k/131060k available (3188k kernel code, 14924k reserved, 1914k data, 1732k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff8e000 - 0xfffff000   ( 452 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xc87fd000 - 0xff7fe000   ( 880 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xc7ffd000   ( 127 MB)
[    0.000000]       .init : 0xc14fc000 - 0xc16ad000   (1732 kB)
[    0.000000]       .data : 0xc131d3e0 - 0xc14fbc18   (1914 kB)
[    0.000000]       .text : 0xc1000000 - 0xc131d3e0   (3188 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=32, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000000] Preemptable hierarchical RCU implementation.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:320
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3807 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2526.797 MHz processor.
[    0.006641] Calibrating delay loop (skipped), value calculated using timer frequency.. 5053.59 BogoMIPS (lpj=2526797)
[    0.008118] pid_max: default: 32768 minimum: 301
[    0.010339] Security Framework initialized
[    0.013338] Mount-cache hash table entries: 512
[    0.029644] Initializing cgroup subsys debug
[    0.030183] Initializing cgroup subsys ns
[    0.030705] ns_cgroup deprecated: consider using the 'clone_children' flag without the ns_cgroup.
[    0.031105] Initializing cgroup subsys cpuacct
[    0.032420] Initializing cgroup subsys memory
[    0.033812] Initializing cgroup subsys devices
[    0.034223] Initializing cgroup subsys freezer
[    0.035114] Initializing cgroup subsys blkio
[    0.039313] Performance Events: p6 PMU driver.
[    0.042813] ... version:                0
[    0.043078] ... bit width:              32
[    0.043338] ... generic registers:      2
[    0.043632] ... value mask:             00000000ffffffff
[    0.043946] ... max period:             000000007fffffff
[    0.043999] ... fixed-purpose events:   0
[    0.043999] ... event mask:             0000000000000003
[    0.043999] SMP alternatives: switching to UP code
[    0.106835] Freeing SMP alternatives: 16k freed
[    0.108407] ACPI: Core revision 20101013
[    0.165666] ftrace: allocating 17611 entries in 35 pages
[    0.179676] BUG: scheduling while atomic: swapper/0/0x00000001
[    0.180100] no locks held by swapper/0.
[    0.181072] Modules linked in:
[    0.181627] Pid: 0, comm: swapper Not tainted 2.6.36+ #60
[    0.182078] Call Trace:
[    0.182755]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.183072]  [<c13153d2>] schedule+0x77/0x624
[    0.183394]  [<c104efc1>] ? complete+0x39/0x43
[    0.183688]  [<c1306765>] rest_init+0xa1/0xb5
[    0.184069]  [<c14fc920>] start_kernel+0x354/0x35b
[    0.184693]  [<c14fc0cf>] i386_start_kernel+0xcf/0xd6
[    0.187489] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.187817] no locks held by kthreadd/2.
[    0.187999] Modules linked in:
[    0.188299] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.189074] Call Trace:
[    0.189252]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.189535]  [<c13153d2>] schedule+0x77/0x624
[    0.190084]  [<c1071287>] kthreadd+0x81/0xf1
[    0.190340]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.190679]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.192728] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.199999] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.211114] CPU0: Intel QEMU Virtual CPU version 0.13.0 stepping 03
[    0.213764] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.213999] no locks held by swapper/1.
[    0.214046] Modules linked in:
[    0.214663] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.214999] Call Trace:
[    0.214999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.214999]  [<c13153d2>] schedule+0x77/0x624
[    0.215078]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.215371]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.215661]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.215956]  [<c1071490>] kthread_create+0x72/0xd6
[    0.216085]  [<c105f47b>] ? run_ksoftirqd+0x0/0x155
[    0.217070]  [<c1312ebe>] cpu_callback+0x33/0x1db
[    0.218062]  [<c105f47b>] ? run_ksoftirqd+0x0/0x155
[    0.219064]  [<c1306f84>] ? register_cpu_notifier+0x27/0x2e
[    0.220138]  [<c150d62c>] spawn_ksoftirqd+0x1c/0x43
[    0.221066]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.221633]  [<c150d610>] ? spawn_ksoftirqd+0x0/0x43
[    0.222066]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.222340]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.222690]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.224451] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.224786] no locks held by kthreadd/2.
[    0.224999] Modules linked in:
[    0.225154] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.225451] Call Trace:
[    0.225844]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.226148]  [<c13153d2>] schedule+0x77/0x624
[    0.227090]  [<c1071287>] kthreadd+0x81/0xf1
[    0.227347]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.228055]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.228601] BUG: scheduling while atomic: kthreadd/3/0x00000001
[    0.228928] no locks held by kthreadd/3.
[    0.229050] Modules linked in:
[    0.229255] Pid: 3, comm: kthreadd Not tainted 2.6.36+ #60
[    0.229569] Call Trace:
[    0.230137]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.230443]  [<c13153d2>] schedule+0x77/0x624
[    0.230705]  [<c104efc1>] ? complete+0x39/0x43
[    0.231064]  [<c105f47b>] ? run_ksoftirqd+0x0/0x155
[    0.231421]  [<c10711f2>] kthread+0x63/0x77
[    0.232080]  [<c107118f>] ? kthread+0x0/0x77
[    0.232338]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.234068] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.234459] no locks held by swapper/1.
[    0.234673] Modules linked in:
[    0.235051] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.235410] Call Trace:
[    0.235579]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.235863]  [<c13153d2>] schedule+0x77/0x624
[    0.236065]  [<c1317e6d>] ? apic_timer_interrupt+0x31/0x38
[    0.237072]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.238077]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.238369]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.239062]  [<c1312f1d>] cpu_callback+0x92/0x1db
[    0.239414]  [<c1306f84>] ? register_cpu_notifier+0x27/0x2e
[    0.239737]  [<c150d644>] spawn_ksoftirqd+0x34/0x43
[    0.240132]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.240494]  [<c150d610>] ? spawn_ksoftirqd+0x0/0x43
[    0.241075]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.241416]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.241694]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.242217] BUG: scheduling while atomic: ksoftirqd/0/3/0x00000001
[    0.242564] no locks held by ksoftirqd/0/3.
[    0.242786] Modules linked in:
[    0.243077] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.36+ #60
[    0.243395] Call Trace:
[    0.243563]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.244062]  [<c13153d2>] schedule+0x77/0x624
[    0.244338]  [<c105f4d2>] run_ksoftirqd+0x57/0x155
[    0.244685]  [<c105f47b>] ? run_ksoftirqd+0x0/0x155
[    0.245074]  [<c1071201>] kthread+0x72/0x77
[    0.245343]  [<c107118f>] ? kthread+0x0/0x77
[    0.246062]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.247516] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.247834] no locks held by swapper/1.
[    0.248104] Modules linked in:
[    0.248330] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.248622] Call Trace:
[    0.249068]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.249419]  [<c13153d2>] schedule+0x77/0x624
[    0.249759]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.250131]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.250445]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.250730]  [<c1071490>] kthread_create+0x72/0xd6
[    0.251064]  [<c11aeec5>] ? ida_get_new_above+0x14c/0x166
[    0.251387]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.252068]  [<c106e1b7>] create_worker+0xa4/0x12e
[    0.252426]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.252782]  [<c150dafe>] init_workqueues+0x148/0x24b
[    0.253067]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.253373]  [<c150d9b6>] ? init_workqueues+0x0/0x24b
[    0.254064]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.254422]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.254702]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.255407] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.255740] no locks held by kthreadd/2.
[    0.256041] Modules linked in:
[    0.256325] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.256620] Call Trace:
[    0.256845]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.257073]  [<c13153d2>] schedule+0x77/0x624
[    0.257336]  [<c1071287>] kthreadd+0x81/0xf1
[    0.258063]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.258408]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.258758] BUG: scheduling while atomic: kthreadd/4/0x00000001
[    0.259118] no locks held by kthreadd/4.
[    0.259349] Modules linked in:
[    0.259547] Pid: 4, comm: kthreadd Not tainted 2.6.36+ #60
[    0.260041] Call Trace:
[    0.260279]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.260561]  [<c13153d2>] schedule+0x77/0x624
[    0.261065]  [<c104efc1>] ? complete+0x39/0x43
[    0.261392]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.261682]  [<c10711f2>] kthread+0x63/0x77
[    0.262067]  [<c107118f>] ? kthread+0x0/0x77
[    0.262392]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.263053] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.263381] no locks held by swapper/1.
[    0.263658] Modules linked in:
[    0.264081] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.264448] Call Trace:
[    0.264622]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.265065]  [<c13153d2>] schedule+0x77/0x624
[    0.265390]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    0.265729]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.266129]  [<c13175cc>] _raw_spin_unlock_irq+0x40/0x43
[    0.266454]  [<c150db23>] init_workqueues+0x16d/0x24b
[    0.267063]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.267445]  [<c150d9b6>] ? init_workqueues+0x0/0x24b
[    0.267746]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.268062]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.268451]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.269053] BUG: scheduling while atomic: kworker/0:0/4/0x00000001
[    0.269493] no locks held by kworker/0:0/4.
[    0.269724] Modules linked in:
[    0.270076] Pid: 4, comm: kworker/0:0 Not tainted 2.6.36+ #60
[    0.270453] Call Trace:
[    0.270624]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.271063]  [<c13153d2>] schedule+0x77/0x624
[    0.271385]  [<c1317e6d>] ? apic_timer_interrupt+0x31/0x38
[    0.271722]  [<c13175b0>] ? _raw_spin_unlock_irq+0x24/0x43
[    0.272129]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.272434]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.272719]  [<c1071201>] kthread+0x72/0x77
[    0.273068]  [<c107118f>] ? kthread+0x0/0x77
[    0.273357]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.274374] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.275046] no locks held by swapper/1.
[    0.275280] Modules linked in:
[    0.275480] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.276042] Call Trace:
[    0.276288]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.276570]  [<c13153d2>] schedule+0x77/0x624
[    0.277069]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.277422]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.277714]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.278062]  [<c1071490>] kthread_create+0x72/0xd6
[    0.279133]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.280085]  [<c106e1d2>] create_worker+0xbf/0x12e
[    0.280380]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.281067]  [<c150dafe>] init_workqueues+0x148/0x24b
[    0.281421]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.281713]  [<c150d9b6>] ? init_workqueues+0x0/0x24b
[    0.282121]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.282407]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.282684]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.283333] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.284044] no locks held by kthreadd/2.
[    0.284346] Modules linked in:
[    0.284543] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.285041] Call Trace:
[    0.285282]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.285564]  [<c13153d2>] schedule+0x77/0x624
[    0.286068]  [<c1071287>] kthreadd+0x81/0xf1
[    0.286411]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.286671]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.287156] BUG: scheduling while atomic: kthreadd/5/0x00000001
[    0.287497] no locks held by kthreadd/5.
[    0.287716] Modules linked in:
[    0.288125] Pid: 5, comm: kthreadd Not tainted 2.6.36+ #60
[    0.288435] Call Trace:
[    0.288604]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.289062]  [<c13153d2>] schedule+0x77/0x624
[    0.289403]  [<c104efc1>] ? complete+0x39/0x43
[    0.289670]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.290130]  [<c10711f2>] kthread+0x63/0x77
[    0.290393]  [<c107118f>] ? kthread+0x0/0x77
[    0.290644]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.291287] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.291606] no locks held by swapper/1.
[    0.292042] Modules linked in:
[    0.292293] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.292596] Call Trace:
[    0.292767]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.293065]  [<c13153d2>] schedule+0x77/0x624
[    0.293341]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.293631]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.294075]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.294369]  [<c13175cc>] _raw_spin_unlock_irq+0x40/0x43
[    0.295064]  [<c150db23>] init_workqueues+0x16d/0x24b
[    0.295487]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.295777]  [<c150d9b6>] ? init_workqueues+0x0/0x24b
[    0.296064]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.296421]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.297056]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.297455] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.297799] no locks held by kworker/u:0/5.
[    0.298041] Modules linked in:
[    0.298303] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.298611] Call Trace:
[    0.298779]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.299064]  [<c13153d2>] schedule+0x77/0x624
[    0.299358]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.300064]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.300411]  [<c1071201>] kthread+0x72/0x77
[    0.300666]  [<c107118f>] ? kthread+0x0/0x77
[    0.300984]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.306873] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.307065] no locks held by swapper/1.
[    0.307293] Modules linked in:
[    0.307493] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.308055] Call Trace:
[    0.308237]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.308522]  [<c13153d2>] schedule+0x77/0x624
[    0.309070]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.309372]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.310068]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.311063]  [<c1071490>] kthread_create+0x72/0xd6
[    0.311421]  [<c10992f8>] ? cpu_stopper_thread+0x0/0x18d
[    0.311733]  [<c1313cc0>] cpu_stop_cpu_callback+0x6a/0x14d
[    0.311999]  [<c10992f8>] ? cpu_stopper_thread+0x0/0x18d
[    0.312066]  [<c150f0ad>] cpu_stop_init+0x6d/0x98
[    0.313064]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.313415]  [<c150f040>] ? cpu_stop_init+0x0/0x98
[    0.313695]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.314065]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.314409]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.315453] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.316117] no locks held by kthreadd/2.
[    0.316346] Modules linked in:
[    0.316561] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.317044] Call Trace:
[    0.317292]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.317571]  [<c13153d2>] schedule+0x77/0x624
[    0.318069]  [<c1071287>] kthreadd+0x81/0xf1
[    0.318392]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.318664]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.319099] BUG: scheduling while atomic: kthreadd/6/0x00000001
[    0.319498] no locks held by kthreadd/6.
[    0.319720] Modules linked in:
[    0.320075] Pid: 6, comm: kthreadd Not tainted 2.6.36+ #60
[    0.320449] Call Trace:
[    0.320620]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.321063]  [<c13153d2>] schedule+0x77/0x624
[    0.321394]  [<c104efc1>] ? complete+0x39/0x43
[    0.321716]  [<c10992f8>] ? cpu_stopper_thread+0x0/0x18d
[    0.322127]  [<c10711f2>] kthread+0x63/0x77
[    0.322394]  [<c107118f>] ? kthread+0x0/0x77
[    0.322648]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.323386] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.323722] no locks held by swapper/1.
[    0.324040] Modules linked in:
[    0.324253] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.324545] Call Trace:
[    0.325064]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.325340]  [<c13153d2>] schedule+0x77/0x624
[    0.325672]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.326062]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.326428]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.326713]  [<c1313d07>] cpu_stop_cpu_callback+0xb1/0x14d
[    0.327130]  [<c150f0c6>] cpu_stop_init+0x86/0x98
[    0.327419]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.327709]  [<c150f040>] ? cpu_stop_init+0x0/0x98
[    0.328076]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.328348]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.329061]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.329601] BUG: scheduling while atomic: migration/0/6/0x00000001
[    0.330043] no locks held by migration/0/6.
[    0.330355] Modules linked in:
[    0.330616] Pid: 6, comm: migration/0 Not tainted 2.6.36+ #60
[    0.331033] Call Trace:
[    0.331269]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.331571]  [<c13153d2>] schedule+0x77/0x624
[    0.332059]  [<c1099473>] cpu_stopper_thread+0x17b/0x18d
[    0.332438]  [<c13175c3>] ? _raw_spin_unlock_irq+0x37/0x43
[    0.332753]  [<c1052b85>] ? finish_task_switch+0x63/0xc8
[    0.333055]  [<c1052b5b>] ? finish_task_switch+0x39/0xc8
[    0.333446]  [<c104e8b4>] ? need_resched+0x19/0x23
[    0.333724]  [<c131596f>] ? schedule+0x614/0x624
[    0.334058]  [<c10992f8>] ? cpu_stopper_thread+0x0/0x18d
[    0.334391]  [<c1071201>] kthread+0x72/0x77
[    0.334641]  [<c107118f>] ? kthread+0x0/0x77
[    0.335053]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.337953] NMI watchdog enabled, takes one hw-pmu counter.
[    0.339198] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.340057] no locks held by swapper/1.
[    0.340328] Modules linked in:
[    0.341089] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.341453] Call Trace:
[    0.341624]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.342075]  [<c13153d2>] schedule+0x77/0x624
[    0.342408]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.342707]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.343079]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.343440]  [<c1071490>] kthread_create+0x72/0xd6
[    0.343729]  [<c10a21d8>] ? watchdog+0x0/0xf4
[    0.344080]  [<c10a20ac>] watchdog_enable+0xc5/0x126
[    0.345073]  [<c10a21d8>] ? watchdog+0x0/0xf4
[    0.346143]  [<c1313e04>] cpu_callback+0x61/0x84
[    0.346433]  [<c150f59d>] spawn_watchdog_task+0x3c/0x5c
[    0.346732]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.347075]  [<c150f561>] ? spawn_watchdog_task+0x0/0x5c
[    0.347393]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.348073]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.348421]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.349157] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.349557] no locks held by kthreadd/2.
[    0.349775] Modules linked in:
[    0.350084] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.350456] Call Trace:
[    0.350621]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.351076]  [<c13153d2>] schedule+0x77/0x624
[    0.351413]  [<c1071287>] kthreadd+0x81/0xf1
[    0.351670]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.352075]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.352482] BUG: scheduling while atomic: kthreadd/7/0x00000001
[    0.352802] no locks held by kthreadd/7.
[    0.353056] Modules linked in:
[    0.353320] Pid: 7, comm: kthreadd Not tainted 2.6.36+ #60
[    0.353614] Call Trace:
[    0.353880]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.354087]  [<c13153d2>] schedule+0x77/0x624
[    0.354350]  [<c104efc1>] ? complete+0x39/0x43
[    0.355075]  [<c10a21d8>] ? watchdog+0x0/0xf4
[    0.355736]  [<c10711f2>] kthread+0x63/0x77
[    0.356082]  [<c107118f>] ? kthread+0x0/0x77
[    0.356413]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.357090] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.357471] no locks held by swapper/1.
[    0.357685] Modules linked in:
[    0.357885] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.358053] Call Trace:
[    0.358236]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.358526]  [<c13153d2>] schedule+0x77/0x624
[    0.359083]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.359386]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.359744]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.360105]  [<c10a20f9>] watchdog_enable+0x112/0x126
[    0.360400]  [<c1313e04>] cpu_callback+0x61/0x84
[    0.361075]  [<c150f59d>] spawn_watchdog_task+0x3c/0x5c
[    0.361452]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.361757]  [<c150f561>] ? spawn_watchdog_task+0x0/0x5c
[    0.362074]  [<c14fc2d1>] kernel_init+0x70/0x1a7
[    0.362360]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.362635]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.365239] BUG: scheduling while atomic: watchdog/0/7/0x00000001
[    0.366063] no locks held by watchdog/0/7.
[    0.366373] Modules linked in:
[    0.366571] Pid: 7, comm: watchdog/0 Not tainted 2.6.36+ #60
[    0.367059] Call Trace:
[    0.367285]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.367578]  [<c13153d2>] schedule+0x77/0x624
[    0.368085]  [<c10a2292>] watchdog+0xba/0xf4
[    0.368392]  [<c10a21d8>] ? watchdog+0x0/0xf4
[    0.368866]  [<c1071201>] kthread+0x72/0x77
[    0.369084]  [<c107118f>] ? kthread+0x0/0x77
[    0.369354]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.373821] Brought up 1 CPUs
[    0.374180] Total of 1 processors activated (5053.59 BogoMIPS).
[    0.377377] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.377709] no locks held by swapper/1.
[    0.377922] Modules linked in:
[    0.378148] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.378450] Call Trace:
[    0.378623]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.379077]  [<c13153d2>] schedule+0x77/0x624
[    0.379477]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.380076]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.380448]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.380734]  [<c1071490>] kthread_create+0x72/0xd6
[    0.381145]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.381456]  [<c106e77b>] __alloc_workqueue_key+0x1ce/0x2a3
[    0.382076]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.382435]  [<c150ef4d>] cpuset_init_smp+0x37/0x48
[    0.382720]  [<c14fc351>] kernel_init+0xf0/0x1a7
[    0.383075]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.383468]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.384255] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.384599] no locks held by kthreadd/2.
[    0.385052] Modules linked in:
[    0.385314] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.385621] Call Trace:
[    0.385791]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.386145]  [<c13153d2>] schedule+0x77/0x624
[    0.386423]  [<c1071287>] kthreadd+0x81/0xf1
[    0.386678]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.387143]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.387500] BUG: scheduling while atomic: kthreadd/8/0x00000001
[    0.388055] no locks held by kthreadd/8.
[    0.388356] Modules linked in:
[    0.388553] Pid: 8, comm: kthreadd Not tainted 2.6.36+ #60
[    0.389053] Call Trace:
[    0.389292]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.389593]  [<c13153d2>] schedule+0x77/0x624
[    0.389854]  [<c104efc1>] ? complete+0x39/0x43
[    0.390077]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.390376]  [<c10711f2>] kthread+0x63/0x77
[    0.391081]  [<c107118f>] ? kthread+0x0/0x77
[    0.391406]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.392112] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.392508] no locks held by swapper/1.
[    0.392721] Modules linked in:
[    0.393061] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.394053] Call Trace:
[    0.394311]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.394593]  [<c13153d2>] schedule+0x77/0x624
[    0.395082]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.395383]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.396077]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.396423]  [<c1071490>] kthread_create+0x72/0xd6
[    0.396705]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.397136]  [<c106e77b>] __alloc_workqueue_key+0x1ce/0x2a3
[    0.397467]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.397775]  [<c150d9a5>] usermodehelper_init+0x21/0x32
[    0.398074]  [<c14fc356>] kernel_init+0xf5/0x1a7
[    0.398358]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.399074]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.399866] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.400065] no locks held by kthreadd/2.
[    0.400286] Modules linked in:
[    0.400482] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.401054] Call Trace:
[    0.401260]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.401544]  [<c13153d2>] schedule+0x77/0x624
[    0.402134]  [<c1071287>] kthreadd+0x81/0xf1
[    0.402403]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.402663]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.403518] BUG: scheduling while atomic: cpuset/8/0x10000001
[    0.404090] no locks held by cpuset/8.
[    0.404320] Modules linked in:
[    0.404520] Pid: 8, comm: cpuset Not tainted 2.6.36+ #60
[    0.405056] Call Trace:
[    0.405308]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.405590]  [<c13153d2>] schedule+0x77/0x624
[    0.406078]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.406462]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.406780]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.407077]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.407428]  [<c1053808>] set_user_nice+0xf7/0x118
[    0.408078]  [<c106d3f0>] rescuer_thread+0x37/0x1b4
[    0.408451]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.408738]  [<c1071201>] kthread+0x72/0x77
[    0.408991]  [<c107118f>] ? kthread+0x0/0x77
[    0.409079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.410231] BUG: scheduling while atomic: cpuset/8/0x00000001
[    0.410560] no locks held by cpuset/8.
[    0.410768] Modules linked in:
[    0.411091] Pid: 8, comm: cpuset Not tainted 2.6.36+ #60
[    0.411458] Call Trace:
[    0.411628]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.412076]  [<c13153d2>] schedule+0x77/0x624
[    0.412405]  [<c1053808>] ? set_user_nice+0xf7/0x118
[    0.412707]  [<c106d568>] rescuer_thread+0x1af/0x1b4
[    0.413137]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.413440]  [<c1071201>] kthread+0x72/0x77
[    0.413692]  [<c107118f>] ? kthread+0x0/0x77
[    0.414076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.415114] BUG: scheduling while atomic: kthreadd/9/0x00000001
[    0.415540] no locks held by kthreadd/9.
[    0.415770] Modules linked in:
[    0.416154] Pid: 9, comm: kthreadd Not tainted 2.6.36+ #60
[    0.416474] Call Trace:
[    0.416654]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.417150]  [<c13153d2>] schedule+0x77/0x624
[    0.417465]  [<c104efc1>] ? complete+0x39/0x43
[    0.418094]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.418466]  [<c10711f2>] kthread+0x63/0x77
[    0.418733]  [<c107118f>] ? kthread+0x0/0x77
[    0.419107]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.420193] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.420520] no locks held by swapper/1.
[    0.421052] Modules linked in:
[    0.421331] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.421621] Call Trace:
[    0.421792]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.422088]  [<c13153d2>] schedule+0x77/0x624
[    0.422355]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.423074]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.423449]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.423736]  [<c106e79b>] __alloc_workqueue_key+0x1ee/0x2a3
[    0.424132]  [<c150d9a5>] usermodehelper_init+0x21/0x32
[    0.425074]  [<c14fc356>] kernel_init+0xf5/0x1a7
[    0.425524]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.426076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.426532] BUG: scheduling while atomic: khelper/9/0x10000001
[    0.427062] no locks held by khelper/9.
[    0.427343] Modules linked in:
[    0.427578] Pid: 9, comm: khelper Not tainted 2.6.36+ #60
[    0.428059] Call Trace:
[    0.428297]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.428606]  [<c13153d2>] schedule+0x77/0x624
[    0.428945]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.429095]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.429435]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.430140]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.430505]  [<c1053808>] set_user_nice+0xf7/0x118
[    0.431151]  [<c106d3f0>] rescuer_thread+0x37/0x1b4
[    0.431478]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.432082]  [<c1071201>] kthread+0x72/0x77
[    0.432441]  [<c107118f>] ? kthread+0x0/0x77
[    0.432709]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.433164] BUG: scheduling while atomic: khelper/9/0x00000001
[    0.433534] no locks held by khelper/9.
[    0.433757] Modules linked in:
[    0.434167] Pid: 9, comm: khelper Not tainted 2.6.36+ #60
[    0.434498] Call Trace:
[    0.434677]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.435081]  [<c13153d2>] schedule+0x77/0x624
[    0.435367]  [<c1053808>] ? set_user_nice+0xf7/0x118
[    0.436082]  [<c106d568>] rescuer_thread+0x1af/0x1b4
[    0.436395]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.436906]  [<c1071201>] kthread+0x72/0x77
[    0.437095]  [<c107118f>] ? kthread+0x0/0x77
[    0.437365]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.444781] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.445090] no locks held by swapper/1.
[    0.445307] Modules linked in:
[    0.446090] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.446461] Call Trace:
[    0.446633]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.447076]  [<c13153d2>] schedule+0x77/0x624
[    0.447399]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.447748]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.448130]  [<c106c56c>] queue_work+0x42/0x49
[    0.448412]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.449078]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.449453]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.449727]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.450122]  [<c1247f5b>] bus_register+0x8e/0x1d1
[    0.450446]  [<c152061b>] platform_bus_init+0x23/0x38
[    0.451077]  [<c1520687>] driver_init+0x1c/0x28
[    0.451417]  [<c14fc360>] kernel_init+0xff/0x1a7
[    0.451689]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.452076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.453078] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.453529] no locks held by kworker/u:0/5.
[    0.453760] Modules linked in:
[    0.454097] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.454474] Call Trace:
[    0.454667]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.455076]  [<c13153d2>] schedule+0x77/0x624
[    0.455425]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.455714]  [<c105ed85>] ? irq_exit+0x3e/0x6c
[    0.456131]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    0.456481]  [<c1317e6d>] ? apic_timer_interrupt+0x31/0x38
[    0.457068]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.457416]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.457732]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.458075]  [<c1071498>] kthread_create+0x7a/0xd6
[    0.458427]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.458719]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.459079]  [<c106e1d2>] create_worker+0xbf/0x12e
[    0.459372]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.460075]  [<c106e304>] manage_workers+0xc3/0x169
[    0.460433]  [<c106e477>] worker_thread+0xcd/0x203
[    0.460717]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.461075]  [<c1071201>] kthread+0x72/0x77
[    0.461450]  [<c107118f>] ? kthread+0x0/0x77
[    0.461708]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.463068] BUG: scheduling while atomic: kthreadd/2/0x10000001
[    0.463461] no locks held by kthreadd/2.
[    0.463679] Modules linked in:
[    0.464061] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.465052] Call Trace:
[    0.465430]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.465714]  [<c13153d2>] schedule+0x77/0x624
[    0.466155]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.466466]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.466790]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.467087]  [<c1317540>] _raw_spin_unlock+0x3a/0x3d
[    0.467379]  [<c1058a2b>] copy_process+0x54a/0xe20
[    0.468079]  [<c1059438>] do_fork+0x137/0x2db
[    0.468424]  [<c1076779>] ? sched_clock_cpu+0x134/0x144
[    0.468742]  [<c1081e06>] ? __lock_acquire+0x3c8/0x41f
[    0.469074]  [<c107118f>] ? kthread+0x0/0x77
[    0.469344]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.469623]  [<c107118f>] ? kthread+0x0/0x77
[    0.470077]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.471160]  [<c10712c1>] kthreadd+0xbb/0xf1
[    0.471417]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.472076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.473666] BUG: scheduling while atomic: khelper/9/0x00000001
[    0.474145] 2 locks held by khelper/9:
[    0.474395]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.475443]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.476064] Modules linked in:
[    0.476368] Pid: 9, comm: khelper Not tainted 2.6.36+ #60
[    0.476675] Call Trace:
[    0.477157]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.477470]  [<c13153d2>] schedule+0x77/0x624
[    0.477747]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.478101]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.478414]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.479154]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.479484]  [<c1059570>] do_fork+0x26f/0x2db
[    0.479826]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.480115]  [<c105ed85>] ? irq_exit+0x3e/0x6c
[    0.480395]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    0.481086]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.482084]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.482421]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.483151]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.483504]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.484086]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.484483]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.484817]  [<c106d532>] rescuer_thread+0x179/0x1b4
[    0.485101]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.485411]  [<c1071201>] kthread+0x72/0x77
[    0.486087]  [<c107118f>] ? kthread+0x0/0x77
[    0.486421]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.487116] BUG: scheduling while atomic: khelper/10/0x10000001
[    0.487507] no locks held by khelper/10.
[    0.487725] Modules linked in:
[    0.488089] Pid: 10, comm: khelper Not tainted 2.6.36+ #60
[    0.488480] Call Trace:
[    0.488650]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.489076]  [<c13153d2>] schedule+0x77/0x624
[    0.489409]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.489707]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.490134]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.490438]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.491073]  [<c1053808>] set_user_nice+0xf7/0x118
[    0.491441]  [<c106b2b5>] ____call_usermodehelper+0x54/0x7b
[    0.491766]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.492143]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.495098] BUG: scheduling while atomic: khelper/10/0x10000001
[    0.495490] 1 lock held by khelper/10:
[    0.495709]  #0:  (&sig->cred_guard_mutex){......}, at: [<c10ffc48>] prepare_bprm_creds+0x25/0x5a
[    0.497376] Modules linked in:
[    0.497593] Pid: 10, comm: khelper Not tainted 2.6.36+ #60
[    0.498054] Call Trace:
[    0.498274]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.498570]  [<c13153d2>] schedule+0x77/0x624
[    0.498833]  [<c1315b2e>] preempt_schedule_irq+0x3d/0x5c
[    0.499077]  [<c1317980>] need_resched+0x1b/0x1f
[    0.499369]  [<c1108ad0>] ? d_free+0x33/0x52
[    0.499667]  [<c1108bca>] ? d_kill+0x40/0x46
[    0.500119]  [<c11090fa>] ? dput+0x102/0x10e
[    0.500397]  [<c110280f>] ? path_put_conditional+0x16/0x25
[    0.501076]  [<c11044c5>] ? link_path_walk+0x323/0x35d
[    0.501472]  [<c11051c7>] ? do_filp_open+0xec/0x406
[    0.501769]  [<c1100594>] ? open_exec+0x1f/0x77
[    0.502076]  [<c1100d13>] ? do_execve+0xa2/0x24b
[    0.503077]  [<c10308c8>] ? sys_execve+0x31/0x54
[    0.503438]  [<c102b07a>] ? ptregs_execve+0x12/0x18
[    0.503724]  [<c13179d0>] ? syscall_call+0x7/0xb
[    0.504081]  [<c102dd45>] ? kernel_execve+0x19/0x20
[    0.504411]  [<c106b2d2>] ? ____call_usermodehelper+0x71/0x7b
[    0.505077]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.505473]  [<c102b53e>] ? kernel_thread_helper+0x6/0x10
[    0.506599] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.507055] no locks held by kthreadd/2.
[    0.507330] Modules linked in:
[    0.507535] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.507825] Call Trace:
[    0.508080]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.508447]  [<c13153d2>] schedule+0x77/0x624
[    0.508712]  [<c1071287>] kthreadd+0x81/0xf1
[    0.509078]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.509451]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.510152] BUG: scheduling while atomic: kthreadd/11/0x00000001
[    0.510597] no locks held by kthreadd/11.
[    0.510843] Modules linked in:
[    0.511092] Pid: 11, comm: kthreadd Not tainted 2.6.36+ #60
[    0.512106] Call Trace:
[    0.512317]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.512630]  [<c13153d2>] schedule+0x77/0x624
[    0.513151]  [<c104efc1>] ? complete+0x39/0x43
[    0.513458]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.514076]  [<c10711f2>] kthread+0x63/0x77
[    0.514428]  [<c107118f>] ? kthread+0x0/0x77
[    0.514722]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.515468] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.516056] no locks held by kworker/u:0/5.
[    0.516364] Modules linked in:
[    0.516596] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.517054] Call Trace:
[    0.517284]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.517587]  [<c13153d2>] schedule+0x77/0x624
[    0.518083]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.518438]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.518723]  [<c1071201>] kthread+0x72/0x77
[    0.519080]  [<c107118f>] ? kthread+0x0/0x77
[    0.519417]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.519999] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.521058] no locks held by swapper/1.
[    0.521338] Modules linked in:
[    0.521539] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.522054] Call Trace:
[    0.522241]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.522523]  [<c13153d2>] schedule+0x77/0x624
[    0.523138]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.523442]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.524066]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.524403]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.524730]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.525075]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.525470]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.525831]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.526091]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.526362]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.527077]  [<c1247f5b>] bus_register+0x8e/0x1d1
[    0.527432]  [<c152061b>] platform_bus_init+0x23/0x38
[    0.527727]  [<c1520687>] driver_init+0x1c/0x28
[    0.528127]  [<c14fc360>] kernel_init+0xff/0x1a7
[    0.528416]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.528693]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.529107] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.529494] no locks held by kworker/u:1/11.
[    0.530051] Modules linked in:
[    0.530330] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.530677] Call Trace:
[    0.531077]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.531477]  [<c13153d2>] schedule+0x77/0x624
[    0.531763]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.532079]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.532449]  [<c1071201>] kthread+0x72/0x77
[    0.533084]  [<c107118f>] ? kthread+0x0/0x77
[    0.533447]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.535690] BUG: scheduling while atomic: khelper/10/0x10000001
[    0.536257] no locks held by khelper/10.
[    0.537128] Modules linked in:
[    0.537354] Pid: 10, comm: khelper Not tainted 2.6.36+ #60
[    0.537648] Call Trace:
[    0.538125]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.538479]  [<c13153d2>] schedule+0x77/0x624
[    0.538741]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.539176]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.539514]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.540203]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.540555]  [<c104efc1>] complete+0x39/0x43
[    0.540812]  [<c1057d2e>] mm_release+0x57/0xb4
[    0.541078]  [<c105b718>] exit_mm+0x1d/0x110
[    0.541347]  [<c13175c3>] ? _raw_spin_unlock_irq+0x37/0x43
[    0.542105]  [<c105d153>] do_exit+0x1b4/0x66d
[    0.542458]  [<c102dd45>] ? kernel_execve+0x19/0x20
[    0.542741]  [<c106b2dc>] wait_for_helper+0x0/0x8e
[    0.543144]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.543491]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.544404] BUG: scheduling while atomic: khelper/9/0x00000001
[    0.544737] no locks held by khelper/9.
[    0.545130] Modules linked in:
[    0.545355] Pid: 9, comm: khelper Not tainted 2.6.36+ #60
[    0.545677] Call Trace:
[    0.546157]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.546480]  [<c13153d2>] schedule+0x77/0x624
[    0.546756]  [<c106d568>] rescuer_thread+0x1af/0x1b4
[    0.547118]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.548144]  [<c1071201>] kthread+0x72/0x77
[    0.548461]  [<c107118f>] ? kthread+0x0/0x77
[    0.548728]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.550063] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.550445] 1 lock held by swapper/1:
[    0.550651]  #0:  (sysfs_mutex){......}, at: [<c113adb4>] sysfs_addrm_start+0x25/0x29
[    0.551320] Modules linked in:
[    0.551527] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.551817] Call Trace:
[    0.552148]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.552442]  [<c13153d2>] schedule+0x77/0x624
[    0.552702]  [<c1315b2e>] preempt_schedule_irq+0x3d/0x5c
[    0.554080]  [<c1317980>] need_resched+0x1b/0x1f
[    0.555081]  [<c11b5c5f>] ? strcmp+0x12/0x22
[    0.555458]  [<c113a967>] ? sysfs_find_dirent+0x2d/0x3f
[    0.555761]  [<c113acf9>] ? __sysfs_add_one+0x1b/0x7b
[    0.556079]  [<c113b4ae>] ? sysfs_add_one+0x18/0xee
[    0.556381]  [<c113a70c>] ? sysfs_add_file_mode+0x64/0x8d
[    0.557078]  [<c113a748>] ? sysfs_add_file+0x13/0x18
[    0.557439]  [<c113a7e4>] ? sysfs_create_file+0x25/0x27
[    0.557744]  [<c1247ea9>] ? bus_create_file+0x2e/0x3e
[    0.558143]  [<c1247ff3>] ? bus_register+0x126/0x1d1
[    0.558457]  [<c152061b>] ? platform_bus_init+0x23/0x38
[    0.559066]  [<c1520687>] ? driver_init+0x1c/0x28
[    0.559404]  [<c14fc360>] ? kernel_init+0xff/0x1a7
[    0.559718]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.560076]  [<c102b53e>] ? kernel_thread_helper+0x6/0x10
[    0.560480] BUG: scheduling while atomic: khelper/9/0x00000001
[    0.560809] no locks held by khelper/9.
[    0.561058] Modules linked in:
[    0.561292] Pid: 9, comm: khelper Not tainted 2.6.36+ #60
[    0.561595] Call Trace:
[    0.562141]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.562448]  [<c13153d2>] schedule+0x77/0x624
[    0.562724]  [<c106d568>] rescuer_thread+0x1af/0x1b4
[    0.563087]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.563401]  [<c1071201>] kthread+0x72/0x77
[    0.564095]  [<c107118f>] ? kthread+0x0/0x77
[    0.564428]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.565404] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.566060] no locks held by swapper/1.
[    0.566298] Modules linked in:
[    0.566501] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.567107] Call Trace:
[    0.567298]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.567580]  [<c13153d2>] schedule+0x77/0x624
[    0.568078]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.568497]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.568787]  [<c106c56c>] queue_work+0x42/0x49
[    0.569088]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.569444]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.570136]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.571132]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.571424]  [<c12473df>] sysdev_class_register+0x55/0x6f
[    0.572078]  [<c152063d>] cpu_dev_init+0xd/0x1d
[    0.572398]  [<c1520691>] driver_init+0x26/0x28
[    0.572677]  [<c14fc360>] kernel_init+0xff/0x1a7
[    0.573075]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.573436]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.574333] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.574692] 2 locks held by kworker/u:1/11:
[    0.575055]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.575595]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.576330] Modules linked in:
[    0.576819] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.577056] Call Trace:
[    0.577244]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.577531]  [<c13153d2>] schedule+0x77/0x624
[    0.578086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.578404]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.579080]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.579473]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.579780]  [<c1059570>] do_fork+0x26f/0x2db
[    0.580160]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.580477]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.581077]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.581460]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.581791]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.582080]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.582492]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.583079]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.583498]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.583864]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.584090]  [<c1071201>] kthread+0x72/0x77
[    0.584351]  [<c107118f>] ? kthread+0x0/0x77
[    0.585079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.586213] khelper used greatest stack depth: 6412 bytes left
[    0.588622] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.589166] no locks held by kworker/u:1/11.
[    0.589422] Modules linked in:
[    0.589625] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.590071] Call Trace:
[    0.590261]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.590545]  [<c13153d2>] schedule+0x77/0x624
[    0.591150]  [<c1317e6d>] ? apic_timer_interrupt+0x31/0x38
[    0.591494]  [<c13175b0>] ? _raw_spin_unlock_irq+0x24/0x43
[    0.592092]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.593094]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.593457]  [<c1071201>] kthread+0x72/0x77
[    0.593717]  [<c107118f>] ? kthread+0x0/0x77
[    0.594094]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.600458] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.600785] no locks held by swapper/1.
[    0.601052] Modules linked in:
[    0.601312] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.601610] Call Trace:
[    0.601778]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.602081]  [<c13153d2>] schedule+0x77/0x624
[    0.603143]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.603459]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.604066]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.604406]  [<c1071490>] kthread_create+0x72/0xd6
[    0.604701]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.605083]  [<c106e77b>] __alloc_workqueue_key+0x1ce/0x2a3
[    0.605473]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.605769]  [<c152594d>] net_ns_init+0x41/0xd6
[    0.606134]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.606442]  [<c152590c>] ? net_ns_init+0x0/0xd6
[    0.606716]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.607078]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.607402]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.608400] BUG: scheduling while atomic: kthreadd/2/0x00000001
[    0.608735] no locks held by kthreadd/2.
[    0.609121] Modules linked in:
[    0.609339] Pid: 2, comm: kthreadd Not tainted 2.6.36+ #60
[    0.609664] Call Trace:
[    0.610078]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.610423]  [<c13153d2>] schedule+0x77/0x624
[    0.610686]  [<c1071287>] kthreadd+0x81/0xf1
[    0.611076]  [<c1071206>] ? kthreadd+0x0/0xf1
[    0.611403]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.611748] BUG: scheduling while atomic: kthreadd/13/0x00000001
[    0.612069] no locks held by kthreadd/13.
[    0.612294] Modules linked in:
[    0.612493] Pid: 13, comm: kthreadd Not tainted 2.6.36+ #60
[    0.613052] Call Trace:
[    0.613237]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.613541]  [<c13153d2>] schedule+0x77/0x624
[    0.614078]  [<c104efc1>] ? complete+0x39/0x43
[    0.614358]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.615074]  [<c10711f2>] kthread+0x63/0x77
[    0.615384]  [<c107118f>] ? kthread+0x0/0x77
[    0.615654]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.616220] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.616581] no locks held by swapper/1.
[    0.616796] Modules linked in:
[    0.617086] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.617685] Call Trace:
[    0.618079]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.618431]  [<c13153d2>] schedule+0x77/0x624
[    0.618697]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.619079]  [<c10569fe>] try_to_wake_up+0x214/0x21e
[    0.619450]  [<c1056a3f>] wake_up_process+0x14/0x16
[    0.619739]  [<c106e79b>] __alloc_workqueue_key+0x1ee/0x2a3
[    0.620078]  [<c152594d>] net_ns_init+0x41/0xd6
[    0.620362]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.621074]  [<c152590c>] ? net_ns_init+0x0/0xd6
[    0.621407]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.621693]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.622075]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.622531] BUG: scheduling while atomic: netns/13/0x10000001
[    0.622839] no locks held by netns/13.
[    0.623120] Modules linked in:
[    0.623340] Pid: 13, comm: netns Not tainted 2.6.36+ #60
[    0.623628] Call Trace:
[    0.624079]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.624484]  [<c13153d2>] schedule+0x77/0x624
[    0.624748]  [<c1080703>] ? put_lock_stats+0x19/0x1b
[    0.625076]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.625415]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.626077]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.626477]  [<c1053808>] set_user_nice+0xf7/0x118
[    0.626764]  [<c106d3f0>] rescuer_thread+0x37/0x1b4
[    0.627128]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.627432]  [<c1071201>] kthread+0x72/0x77
[    0.627690]  [<c107118f>] ? kthread+0x0/0x77
[    0.628086]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.628436] BUG: scheduling while atomic: netns/13/0x00000001
[    0.629056] no locks held by netns/13.
[    0.629336] Modules linked in:
[    0.629537] Pid: 13, comm: netns Not tainted 2.6.36+ #60
[    0.630052] Call Trace:
[    0.630273]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.630568]  [<c13153d2>] schedule+0x77/0x624
[    0.630830]  [<c1053808>] ? set_user_nice+0xf7/0x118
[    0.631077]  [<c106d568>] rescuer_thread+0x1af/0x1b4
[    0.631386]  [<c106d3b9>] ? rescuer_thread+0x0/0x1b4
[    0.632073]  [<c1071201>] kthread+0x72/0x77
[    0.632390]  [<c107118f>] ? kthread+0x0/0x77
[    0.632655]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.633921] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.634059] no locks held by swapper/1.
[    0.634277] Modules linked in:
[    0.635144] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.635449] Call Trace:
[    0.635621]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.636077]  [<c13153d2>] schedule+0x77/0x624
[    0.636408]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.636760]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.637087]  [<c106c56c>] queue_work+0x42/0x49
[    0.637395]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.638087]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.638489]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.638764]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.639078]  [<c12473df>] sysdev_class_register+0x55/0x6f
[    0.640140]  [<c1507479>] init_lapic_sysfs+0x1a/0x2a
[    0.640451]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.640743]  [<c150745f>] ? init_lapic_sysfs+0x0/0x2a
[    0.641080]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.641367]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.642076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.642812] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.643071] 2 locks held by kworker/u:1/11:
[    0.643311]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.644768]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.645495] Modules linked in:
[    0.646095] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.646493] Call Trace:
[    0.646666]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.647083]  [<c13153d2>] schedule+0x77/0x624
[    0.647421]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.647723]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.648136]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.648475]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.649077]  [<c1059570>] do_fork+0x26f/0x2db
[    0.649411]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.649715]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.650127]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.650442]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.651082]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.651474]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.651847]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.652079]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.652419]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.653084]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.653437]  [<c1071201>] kthread+0x72/0x77
[    0.653697]  [<c107118f>] ? kthread+0x0/0x77
[    0.655082]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.656320] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.657075] no locks held by swapper/1.
[    0.658112] Modules linked in:
[    0.659187] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.659511] Call Trace:
[    0.659683]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.660097]  [<c13153d2>] schedule+0x77/0x624
[    0.660382]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.661090]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.661498]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.661785]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.662092]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.662410]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.663159]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.663470]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.664085]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.665076]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.665432]  [<c12473df>] sysdev_class_register+0x55/0x6f
[    0.665756]  [<c1507479>] init_lapic_sysfs+0x1a/0x2a
[    0.666143]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.666446]  [<c150745f>] ? init_lapic_sysfs+0x0/0x2a
[    0.666743]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.667076]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.667370]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.668239] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.668596] no locks held by kworker/u:1/11.
[    0.668835] Modules linked in:
[    0.669148] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.669480] Call Trace:
[    0.669650]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.670390]  [<c13153d2>] schedule+0x77/0x624
[    0.670662]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.671079]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.671390]  [<c1071201>] kthread+0x72/0x77
[    0.672081]  [<c107118f>] ? kthread+0x0/0x77
[    0.672400]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.673336] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.673666] no locks held by swapper/1.
[    0.673941] Modules linked in:
[    0.674093] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.674396] Call Trace:
[    0.674564]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.675077]  [<c13153d2>] schedule+0x77/0x624
[    0.675371]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.676113]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.676422]  [<c106c56c>] queue_work+0x42/0x49
[    0.677077]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.677475]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.677803]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.678131]  [<c1247271>] sysdev_register+0xa9/0xb3
[    0.678431]  [<c1507487>] init_lapic_sysfs+0x28/0x2a
[    0.678722]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.679075]  [<c150745f>] ? init_lapic_sysfs+0x0/0x2a
[    0.679387]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.680074]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.680436]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.682075] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.682498] 2 locks held by kworker/u:1/11:
[    0.682732]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.683462]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.684056] Modules linked in:
[    0.684340] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.684657] Call Trace:
[    0.685140]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.685456]  [<c13153d2>] schedule+0x77/0x624
[    0.685816]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.686164]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.686656]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.687082]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.688078]  [<c1059570>] do_fork+0x26f/0x2db
[    0.689084]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.690088]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.691096]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.691383]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.692148]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.692492]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.693080]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.693453]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.693778]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.694136]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.694444]  [<c1071201>] kthread+0x72/0x77
[    0.694703]  [<c107118f>] ? kthread+0x0/0x77
[    0.695080]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.697266] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.697614] no locks held by swapper/1.
[    0.697829] Modules linked in:
[    0.698184] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.698487] Call Trace:
[    0.698659]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.699197]  [<c13153d2>] schedule+0x77/0x624
[    0.699483]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.700087]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.700510]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.700794]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.701098]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.701414]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.702167]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.702500]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.703095]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.703439]  [<c1247271>] sysdev_register+0xa9/0xb3
[    0.703728]  [<c1507487>] init_lapic_sysfs+0x28/0x2a
[    0.704231]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.704537]  [<c150745f>] ? init_lapic_sysfs+0x0/0x2a
[    0.705083]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.705446]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.705731]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.706220] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.706573] no locks held by kworker/u:1/11.
[    0.707052] Modules linked in:
[    0.707339] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.707658] Call Trace:
[    0.708078]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.708433]  [<c13153d2>] schedule+0x77/0x624
[    0.708703]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.709078]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.709435]  [<c1071201>] kthread+0x72/0x77
[    0.709694]  [<c107118f>] ? kthread+0x0/0x77
[    0.710145]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.724537] Time: 13:43:52  Date: 10/28/10
[    0.727793] NET: Registered protocol family 16
[    0.730158] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.730580] no locks held by swapper/1.
[    0.730799] Modules linked in:
[    0.731108] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.731406] Call Trace:
[    0.732070]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.732439]  [<c13153d2>] schedule+0x77/0x624
[    0.732708]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.733068]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.733438]  [<c106c56c>] queue_work+0x42/0x49
[    0.734077]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.734478]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.734791]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.735138]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.735433]  [<c124917f>] __class_register+0xb2/0x13d
[    0.735728]  [<c124924a>] __class_create+0x40/0x5e
[    0.736090]  [<c1511ec6>] bdi_class_init+0x14/0x40
[    0.736383]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.737076]  [<c1511eb2>] ? bdi_class_init+0x0/0x40
[    0.737440]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.737719]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.738076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.738777] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.739090] 2 locks held by kworker/u:1/11:
[    0.739329]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.740368]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.741055] Modules linked in:
[    0.741346] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.741675] Call Trace:
[    0.741848]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.742079]  [<c13153d2>] schedule+0x77/0x624
[    0.742417]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.743086]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.743452]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.743775]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.744079]  [<c1059570>] do_fork+0x26f/0x2db
[    0.744363]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.745081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.745473]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.745756]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.746137]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.746469]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.747079]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.747445]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.747772]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.748082]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.748383]  [<c1071201>] kthread+0x72/0x77
[    0.748637]  [<c107118f>] ? kthread+0x0/0x77
[    0.749079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.750435] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.750792] no locks held by kworker/u:1/11.
[    0.751125] Modules linked in:
[    0.751344] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.751660] Call Trace:
[    0.752128]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.752476]  [<c13153d2>] schedule+0x77/0x624
[    0.752747]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.753149]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.753449]  [<c1071201>] kthread+0x72/0x77
[    0.753999]  [<c107118f>] ? kthread+0x0/0x77
[    0.754160]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.758642] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.759058] no locks held by swapper/1.
[    0.759326] Modules linked in:
[    0.759538] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.760053] Call Trace:
[    0.760281]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.760577]  [<c13153d2>] schedule+0x77/0x624
[    0.761075]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.761457]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.761784]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.762143]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.762491]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.763077]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.763475]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.763773]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.764081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.764401]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.765076]  [<c124917f>] __class_register+0xb2/0x13d
[    0.765425]  [<c1315f6f>] ? mutex_unlock+0xd/0xf
[    0.765710]  [<c1519bac>] pcibus_class_init+0x12/0x14
[    0.766075]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.766449]  [<c1519b9a>] ? pcibus_class_init+0x0/0x14
[    0.766755]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.767075]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.767367]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.768427] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.768785] 2 locks held by kworker/u:1/11:
[    0.769060]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.769627]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.770429] Modules linked in:
[    0.770632] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.771055] Call Trace:
[    0.771278]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.771595]  [<c13153d2>] schedule+0x77/0x624
[    0.772086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.772453]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.772745]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.773082]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.773413]  [<c1059570>] do_fork+0x26f/0x2db
[    0.774079]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.774455]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.774786]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.775143]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.775497]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.776081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.776457]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.776760]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.777084]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.777393]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.778077]  [<c1071201>] kthread+0x72/0x77
[    0.778395]  [<c107118f>] ? kthread+0x0/0x77
[    0.778667]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.779682] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    0.780078] 2 locks held by kworker/u:1/11:
[    0.780348]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.781110]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.782067] Modules linked in:
[    0.782330] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.782664] Call Trace:
[    0.782840]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.783099]  [<c13153d2>] schedule+0x77/0x624
[    0.783386]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.784091]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.784504]  [<c104efc1>] complete+0x39/0x43
[    0.784766]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    0.785095]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.785410]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.786101]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.787089]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.788109]  [<c1071201>] kthread+0x72/0x77
[    0.788391]  [<c107118f>] ? kthread+0x0/0x77
[    0.788651]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.789364] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.790057] no locks held by swapper/1.
[    0.790338] Modules linked in:
[    0.790541] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.791054] Call Trace:
[    0.791279]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.791574]  [<c13153d2>] schedule+0x77/0x624
[    0.792082]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.792436]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.792766]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.793133]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.793487]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.794075]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.794402]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.794789]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.795082]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.795379]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.796077]  [<c1247f5b>] bus_register+0x8e/0x1d1
[    0.796416]  [<c12491fe>] ? __class_register+0x131/0x13d
[    0.796739]  [<c1519d98>] pci_driver_init+0xd/0xf
[    0.797078]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.797443]  [<c1519d8b>] ? pci_driver_init+0x0/0xf
[    0.797732]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.798130]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.798426]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.799075] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.800117] no locks held by kworker/u:0/5.
[    0.800350] Modules linked in:
[    0.801062] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.801466] Call Trace:
[    0.801637]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.802078]  [<c13153d2>] schedule+0x77/0x624
[    0.802400]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.802698]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.803078]  [<c1071201>] kthread+0x72/0x77
[    0.803402]  [<c107118f>] ? kthread+0x0/0x77
[    0.803660]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.804568] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.805112] 2 locks held by kworker/u:1/11:
[    0.805362]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.806054]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.806682] Modules linked in:
[    0.806878] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.807085] Call Trace:
[    0.807340]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.808151]  [<c13153d2>] schedule+0x77/0x624
[    0.808446]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.808748]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.809080]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.809416]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.810077]  [<c1059570>] do_fork+0x26f/0x2db
[    0.810414]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.810715]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.811078]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.811376]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.812081]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.813153]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.814080]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.814454]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.814780]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.815082]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.815383]  [<c1071201>] kthread+0x72/0x77
[    0.816082]  [<c107118f>] ? kthread+0x0/0x77
[    0.816413]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.817541] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    0.818076] 2 locks held by kworker/u:1/11:
[    0.818390]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.819109]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.820124] Modules linked in:
[    0.820342] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.820675] Call Trace:
[    0.821157]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.821456]  [<c13153d2>] schedule+0x77/0x624
[    0.821725]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.822092]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.822449]  [<c104efc1>] complete+0x39/0x43
[    0.823095]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    0.823480]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.823784]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.824100]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.824399]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.825175]  [<c1071201>] kthread+0x72/0x77
[    0.825789]  [<c107118f>] ? kthread+0x0/0x77
[    0.826080]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.827391] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.827728] no locks held by swapper/1.
[    0.828053] Modules linked in:
[    0.828315] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.828638] Call Trace:
[    0.828808]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.829078]  [<c13153d2>] schedule+0x77/0x624
[    0.829356]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.830078]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.830475]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.830763]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.831077]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.831396]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.832153]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.832453]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.833082]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.833394]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.834076]  [<c124917f>] __class_register+0xb2/0x13d
[    0.834448]  [<c124924a>] __class_create+0x40/0x5e
[    0.834725]  [<c151bb63>] backlight_class_init+0x14/0x4d
[    0.835148]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.835474]  [<c151bb4f>] ? backlight_class_init+0x0/0x4d
[    0.836076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.836405]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.836699]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.837166] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.837512] no locks held by kworker/u:0/5.
[    0.837740] Modules linked in:
[    0.838140] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.838463] Call Trace:
[    0.838633]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.839146]  [<c13153d2>] schedule+0x77/0x624
[    0.839426]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.839712]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.840074]  [<c1071201>] kthread+0x72/0x77
[    0.840369]  [<c107118f>] ? kthread+0x0/0x77
[    0.840625]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.841386] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.842116] 2 locks held by kworker/u:1/11:
[    0.842365]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.843054]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.843607] Modules linked in:
[    0.843806] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.843999] Call Trace:
[    0.845085]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.845439]  [<c13153d2>] schedule+0x77/0x624
[    0.845709]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.846140]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.846448]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.847077]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.847436]  [<c1059570>] do_fork+0x26f/0x2db
[    0.847713]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.848081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.848467]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.848750]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.849080]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.849411]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.849728]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.849999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.849999]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.850083]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.850373]  [<c1071201>] kthread+0x72/0x77
[    0.851084]  [<c107118f>] ? kthread+0x0/0x77
[    0.851361]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.852673] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    0.853139] 2 locks held by kworker/u:1/11:
[    0.853394]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.854167]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.854704] Modules linked in:
[    0.854905] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.854999] Call Trace:
[    0.854999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.854999]  [<c13153d2>] schedule+0x77/0x624
[    0.854999]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.854999]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.855156]  [<c104efc1>] complete+0x39/0x43
[    0.855434]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    0.856167]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.856492]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.857095]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.857434]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.857733]  [<c1071201>] kthread+0x72/0x77
[    0.858100]  [<c107118f>] ? kthread+0x0/0x77
[    0.858449]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.859301] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.860066] no locks held by swapper/1.
[    0.861052] Modules linked in:
[    0.861312] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.861618] Call Trace:
[    0.861789]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.862078]  [<c13153d2>] schedule+0x77/0x624
[    0.862360]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.863078]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.863476]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.863764]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.864078]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.864393]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.865087]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.865463]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.866147]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.866432]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.866709]  [<c124917f>] __class_register+0xb2/0x13d
[    0.867077]  [<c124924a>] __class_create+0x40/0x5e
[    0.867376]  [<c151e588>] tty_class_init+0x14/0x2f
[    0.868075]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.868428]  [<c151e574>] ? tty_class_init+0x0/0x2f
[    0.868724]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.869146]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.869442]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.870109] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.871055] no locks held by kworker/u:0/5.
[    0.871298] Modules linked in:
[    0.872090] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.872475] Call Trace:
[    0.872646]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.873075]  [<c13153d2>] schedule+0x77/0x624
[    0.873417]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.873713]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.874076]  [<c1071201>] kthread+0x72/0x77
[    0.874345]  [<c107118f>] ? kthread+0x0/0x77
[    0.874601]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.875415] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.875766] 2 locks held by kworker/u:1/11:
[    0.875999]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.875999]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.876469] Modules linked in:
[    0.876671] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.877055] Call Trace:
[    0.877244]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.877528]  [<c13153d2>] schedule+0x77/0x624
[    0.878084]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.878398]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.879081]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.879464]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.879771]  [<c1059570>] do_fork+0x26f/0x2db
[    0.880149]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.880472]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.880801]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.880999]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.880999]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.881078]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.881515]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.881818]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.882084]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.882394]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.883077]  [<c1071201>] kthread+0x72/0x77
[    0.883399]  [<c107118f>] ? kthread+0x0/0x77
[    0.883679]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.884649] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    0.885078] 2 locks held by kworker/u:1/11:
[    0.885328]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.886108]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.886642] Modules linked in:
[    0.886841] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.886999] Call Trace:
[    0.888099]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.888450]  [<c13153d2>] schedule+0x77/0x624
[    0.888720]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.889101]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.889463]  [<c104efc1>] complete+0x39/0x43
[    0.890223]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    0.890553]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.891094]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.891485]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.891772]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.892094]  [<c1071201>] kthread+0x72/0x77
[    0.892366]  [<c107118f>] ? kthread+0x0/0x77
[    0.892624]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.893081] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.894065] no locks held by swapper/1.
[    0.894311] Modules linked in:
[    0.895092] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.895452] Call Trace:
[    0.895625]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.896077]  [<c13153d2>] schedule+0x77/0x624
[    0.896403]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.896705]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.897115]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.897445]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.897763]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.899080]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.899480]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.899777]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.900081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.900371]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.901075]  [<c124917f>] __class_register+0xb2/0x13d
[    0.901424]  [<c124924a>] __class_create+0x40/0x5e
[    0.901720]  [<c151eb44>] vtconsole_class_init+0x15/0xa1
[    0.902133]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.902443]  [<c151eb2f>] ? vtconsole_class_init+0x0/0xa1
[    0.902754]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.903073]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.903366]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.903706] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.903999] no locks held by kworker/u:0/5.
[    0.903999] Modules linked in:
[    0.904141] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.904462] Call Trace:
[    0.904631]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.905134]  [<c13153d2>] schedule+0x77/0x624
[    0.905410]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.905696]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.906074]  [<c1071201>] kthread+0x72/0x77
[    0.906342]  [<c107118f>] ? kthread+0x0/0x77
[    0.906596]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.907380] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.908121] 2 locks held by kworker/u:1/11:
[    0.908382]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.908858]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.908999] Modules linked in:
[    0.909092] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.909467] Call Trace:
[    0.909638]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.910131]  [<c13153d2>] schedule+0x77/0x624
[    0.910415]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.910713]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.911081]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.911419]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.912078]  [<c1059570>] do_fork+0x26f/0x2db
[    0.912407]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.912717]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.913080]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.913379]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.913711]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.913999]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.913999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.913999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.914086]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.915136]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.915438]  [<c1071201>] kthread+0x72/0x77
[    0.916083]  [<c107118f>] ? kthread+0x0/0x77
[    0.916395]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.917484] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    0.917842] 2 locks held by kworker/u:1/11:
[    0.918073]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.918574]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.918999] Modules linked in:
[    0.919201] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.920070] Call Trace:
[    0.921102]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.921439]  [<c13153d2>] schedule+0x77/0x624
[    0.921722]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.922095]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.922508]  [<c104efc1>] complete+0x39/0x43
[    0.922769]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    0.923095]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.923407]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.924156]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.924472]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.924764]  [<c1071201>] kthread+0x72/0x77
[    0.924999]  [<c107118f>] ? kthread+0x0/0x77
[    0.924999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.927064] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.927443] no locks held by swapper/1.
[    0.927657] Modules linked in:
[    0.927859] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.928054] Call Trace:
[    0.928241]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.928524]  [<c13153d2>] schedule+0x77/0x624
[    0.929078]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.929441]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.930086]  [<c106c56c>] queue_work+0x42/0x49
[    0.930357]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.930706]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.930999]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.930999]  [<c12468e3>] device_add+0x2fc/0x45d
[    0.931082]  [<c124cdb7>] ? device_pm_init+0x60/0x65
[    0.932079]  [<c1246a5b>] device_register+0x17/0x1a
[    0.932423]  [<c1246ad5>] device_create_vargs+0x77/0x98
[    0.932817]  [<c1246b16>] device_create+0x20/0x22
[    0.933079]  [<c151eb90>] vtconsole_class_init+0x61/0xa1
[    0.933402]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.934077]  [<c151eb2f>] ? vtconsole_class_init+0x0/0xa1
[    0.934444]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.934722]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.935135]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.935488] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    0.936056] no locks held by kworker/u:0/5.
[    0.937136] Modules linked in:
[    0.937350] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    0.938109] Call Trace:
[    0.938283]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.938576]  [<c13153d2>] schedule+0x77/0x624
[    0.939083]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.939434]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.939719]  [<c1071201>] kthread+0x72/0x77
[    0.940135]  [<c107118f>] ? kthread+0x0/0x77
[    0.940406]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.940747] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.941055] no locks held by swapper/1.
[    0.941282] Modules linked in:
[    0.941480] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.942456] Call Trace:
[    0.942634]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.943077]  [<c13153d2>] schedule+0x77/0x624
[    0.943364]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.944080]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.944474]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.944761]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.945143]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.945459]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.946085]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.946445]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.946769]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.947130]  [<c12468e3>] device_add+0x2fc/0x45d
[    0.947430]  [<c124cdb7>] ? device_pm_init+0x60/0x65
[    0.947721]  [<c1246a5b>] device_register+0x17/0x1a
[    0.947999]  [<c1246ad5>] device_create_vargs+0x77/0x98
[    0.948079]  [<c1246b16>] device_create+0x20/0x22
[    0.949092]  [<c151eb90>] vtconsole_class_init+0x61/0xa1
[    0.949401]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.950077]  [<c151eb2f>] ? vtconsole_class_init+0x0/0xa1
[    0.950402]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.951074]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.951403]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.952274] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.952638] 2 locks held by kworker/u:1/11:
[    0.952878]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.953434]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.953948] Modules linked in:
[    0.953999] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.954056] Call Trace:
[    0.954281]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.954595]  [<c13153d2>] schedule+0x77/0x624
[    0.955086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.955473]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.955774]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.956138]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.956457]  [<c1059570>] do_fork+0x26f/0x2db
[    0.956727]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.957082]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.957425]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.958137]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.958489]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.958805]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.958999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.958999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.958999]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.959138]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.960080]  [<c1071201>] kthread+0x72/0x77
[    0.960405]  [<c107118f>] ? kthread+0x0/0x77
[    0.960664]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.961604] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.962084] no locks held by kworker/u:1/11.
[    0.962354] Modules linked in:
[    0.963141] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.963538] Call Trace:
[    0.963710]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.963999]  [<c13153d2>] schedule+0x77/0x624
[    0.963999]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    0.963999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.963999]  [<c1071201>] kthread+0x72/0x77
[    0.963999]  [<c107118f>] ? kthread+0x0/0x77
[    0.965092]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.966600] BUG: scheduling while atomic: swapper/1/0x00000001
[    0.967068] no locks held by swapper/1.
[    0.967354] Modules linked in:
[    0.967565] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.967895] Call Trace:
[    0.968151]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.968464]  [<c13153d2>] schedule+0x77/0x624
[    0.968728]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.969097]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    0.970160]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.970472]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.970831]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.971077]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    0.971421]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.972132]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.972461]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.972736]  [<c11afbb3>] kset_register+0x2e/0x34
[    0.973077]  [<c1247f5b>] bus_register+0x8e/0x1d1
[    0.973367]  [<c1521e4b>] i2c_init+0xe/0x57
[    0.973634]  [<c1001168>] do_one_initcall+0x76/0x121
[    0.973923]  [<c1521e3d>] ? i2c_init+0x0/0x57
[    0.973999]  [<c14fc387>] kernel_init+0x126/0x1a7
[    0.973999]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    0.973999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.975142] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    0.975548] 2 locks held by kworker/u:1/11:
[    0.976056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.976599]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.977366] Modules linked in:
[    0.977590] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.978056] Call Trace:
[    0.978283]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.978580]  [<c13153d2>] schedule+0x77/0x624
[    0.978848]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    0.979085]  [<c13151c2>] wait_for_common+0xa0/0xef
[    0.979388]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    0.979708]  [<c13152b0>] wait_for_completion+0x17/0x19
[    0.981081]  [<c1059570>] do_fork+0x26f/0x2db
[    0.981425]  [<c1315153>] ? wait_for_common+0x31/0xef
[    0.981740]  [<c105ed85>] ? irq_exit+0x3e/0x6c
[    0.982079]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    0.982480]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.982807]  [<c1030969>] kernel_thread+0x7e/0x86
[    0.983081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    0.983425]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    0.984081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    0.984465]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.984768]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.984999]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.984999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.984999]  [<c1071201>] kthread+0x72/0x77
[    0.984999]  [<c107118f>] ? kthread+0x0/0x77
[    0.984999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.985570] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    0.986136] 2 locks held by kworker/u:1/11:
[    0.986403]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.987167]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    0.987706] Modules linked in:
[    0.988157] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    0.988488] Call Trace:
[    0.988661]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.989153]  [<c13153d2>] schedule+0x77/0x624
[    0.989447]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.989742]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    0.989999]  [<c104efc1>] complete+0x39/0x43
[    0.989999]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    0.990095]  [<c106cb47>] process_one_work+0x1ff/0x334
[    0.990471]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    0.991153]  [<c106e4a6>] worker_thread+0xfc/0x203
[    0.991454]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    0.991741]  [<c1071201>] kthread+0x72/0x77
[    0.992107]  [<c107118f>] ? kthread+0x0/0x77
[    0.992380]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    0.994344] BUG: scheduling while atomic: swapper/1/0x10000001
[    0.994692] no locks held by swapper/1.
[    0.994909] Modules linked in:
[    0.994999] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    0.994999] Call Trace:
[    0.994999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    0.994999]  [<c13153d2>] schedule+0x77/0x624
[    0.995137]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    0.996086]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    0.996397]  [<c106c56c>] queue_work+0x42/0x49
[    0.997076]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    0.997474]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    0.997799]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    0.998130]  [<c124822c>] bus_add_driver+0x18e/0x1be
[    0.998438]  [<c1248942>] driver_register+0x81/0xe2
[    0.998725]  [<c1261e72>] i2c_register_driver+0x3d/0x7f
[    0.999076]  [<c1521e75>] i2c_init+0x38/0x57
[    0.999347]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.000075]  [<c1521e3d>] ? i2c_init+0x0/0x57
[    1.000387]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.000674]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.001078]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.002073] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.002491] no locks held by kworker/u:0/5.
[    1.002722] Modules linked in:
[    1.003089] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.003475] Call Trace:
[    1.003671]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.004077]  [<c13153d2>] schedule+0x77/0x624
[    1.004396]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.004708]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.005075]  [<c1071201>] kthread+0x72/0x77
[    1.005399]  [<c107118f>] ? kthread+0x0/0x77
[    1.005655]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.006317] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.006649] no locks held by swapper/1.
[    1.006861] Modules linked in:
[    1.006999] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.006999] Call Trace:
[    1.006999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.006999]  [<c13153d2>] schedule+0x77/0x624
[    1.006999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.006999]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.007081]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.007459]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.007776]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.008075]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.008419]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.009076]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.009446]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.009722]  [<c124822c>] bus_add_driver+0x18e/0x1be
[    1.010131]  [<c1248942>] driver_register+0x81/0xe2
[    1.010432]  [<c1261e72>] i2c_register_driver+0x3d/0x7f
[    1.010733]  [<c1521e75>] i2c_init+0x38/0x57
[    1.011074]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.011392]  [<c1521e3d>] ? i2c_init+0x0/0x57
[    1.011651]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.011926]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.011999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.012324] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.012683] 2 locks held by kworker/u:1/11:
[    1.013056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.013612]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.014368] Modules linked in:
[    1.014578] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.014893] Call Trace:
[    1.015136]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.015437]  [<c13153d2>] schedule+0x77/0x624
[    1.015706]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.016087]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.016390]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.017092]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.017412]  [<c1059570>] do_fork+0x26f/0x2db
[    1.018085]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.018401]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.019077]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.019432]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.019775]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.020080]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.020411]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.021078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.021464]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.021753]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.021999]  [<c1071201>] kthread+0x72/0x77
[    1.021999]  [<c107118f>] ? kthread+0x0/0x77
[    1.021999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.022235] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.023082] 2 locks held by kworker/u:1/11:
[    1.023320]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.024549]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.025386] Modules linked in:
[    1.025608] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.026072] Call Trace:
[    1.026298]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.026593]  [<c13153d2>] schedule+0x77/0x624
[    1.026936]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.027090]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.027492]  [<c104efc1>] complete+0x39/0x43
[    1.028152]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.028486]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.029109]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.029434]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.030091]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.030394]  [<c1071201>] kthread+0x72/0x77
[    1.030693]  [<c107118f>] ? kthread+0x0/0x77
[    1.031080]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.033137] ACPI: bus type pci registered
[    1.033729] BUG: scheduling while atomic: swapper/1/0x10000001
[    1.033999] no locks held by swapper/1.
[    1.033999] Modules linked in:
[    1.033999] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.033999] Call Trace:
[    1.033999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.034082]  [<c13153d2>] schedule+0x77/0x624
[    1.035133]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    1.035499]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.036075]  [<c106c56c>] queue_work+0x42/0x49
[    1.036392]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    1.036741]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.037135]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.037421]  [<c11afbb3>] kset_register+0x2e/0x34
[    1.037698]  [<c124917f>] __class_register+0xb2/0x13d
[    1.038075]  [<c1073f2b>] ? __mutex_init+0x44/0x49
[    1.038374]  [<c15223b7>] dma_bus_init+0x30/0x32
[    1.038701]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.038993]  [<c1522387>] ? dma_bus_init+0x0/0x32
[    1.038999]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.038999]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.039133]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.039479] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.040151] no locks held by kworker/u:0/5.
[    1.040400] Modules linked in:
[    1.040598] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.041109] Call Trace:
[    1.041281]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.041589]  [<c13153d2>] schedule+0x77/0x624
[    1.042083]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.042438]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.042721]  [<c1071201>] kthread+0x72/0x77
[    1.043133]  [<c107118f>] ? kthread+0x0/0x77
[    1.043403]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.043746] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.044055] no locks held by swapper/1.
[    1.044294] Modules linked in:
[    1.044489] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.044780] Call Trace:
[    1.044946]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.044999]  [<c13153d2>] schedule+0x77/0x624
[    1.044999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.045076]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.045408]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.046075]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.046457]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.046761]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.047084]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.047394]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.048080]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.048403]  [<c11afbb3>] kset_register+0x2e/0x34
[    1.048691]  [<c124917f>] __class_register+0xb2/0x13d
[    1.049077]  [<c1073f2b>] ? __mutex_init+0x44/0x49
[    1.049427]  [<c15223b7>] dma_bus_init+0x30/0x32
[    1.049699]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.050147]  [<c1522387>] ? dma_bus_init+0x0/0x32
[    1.050430]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.051075]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.051369]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.052440] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.052797] 2 locks held by kworker/u:1/11:
[    1.053056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.053626]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.054444] Modules linked in:
[    1.054645] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.054962] Call Trace:
[    1.054999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.054999]  [<c13153d2>] schedule+0x77/0x624
[    1.054999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.054999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.056084]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.056473]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.056874]  [<c1059570>] do_fork+0x26f/0x2db
[    1.057087]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.057404]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.058144]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.058443]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.059080]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.059452]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.059779]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.060078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.060400]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.061082]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.061411]  [<c1071201>] kthread+0x72/0x77
[    1.062137]  [<c107118f>] ? kthread+0x0/0x77
[    1.062411]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.063574] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.064078] 2 locks held by kworker/u:1/11:
[    1.064364]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.064860]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.065538] Modules linked in:
[    1.065739] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.065999] Call Trace:
[    1.065999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.065999]  [<c13153d2>] schedule+0x77/0x624
[    1.066099]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.066420]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.067165]  [<c104efc1>] complete+0x39/0x43
[    1.067442]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.067797]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.068091]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.068426]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.069148]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.069452]  [<c1071201>] kthread+0x72/0x77
[    1.069711]  [<c107118f>] ? kthread+0x0/0x77
[    1.070098]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.072142] BUG: scheduling while atomic: swapper/1/0x10000001
[    1.072520] no locks held by swapper/1.
[    1.072732] Modules linked in:
[    1.073142] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.073448] Call Trace:
[    1.073619]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.074079]  [<c13153d2>] schedule+0x77/0x624
[    1.074407]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    1.074756]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.075075]  [<c106c56c>] queue_work+0x42/0x49
[    1.075353]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    1.076086]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.076407]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.076689]  [<c11afbb3>] kset_register+0x2e/0x34
[    1.076974]  [<c124917f>] __class_register+0xb2/0x13d
[    1.076999]  [<c1522d8b>] dmi_id_init+0x207/0x2a6
[    1.076999]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.076999]  [<c1522b84>] ? dmi_id_init+0x0/0x2a6
[    1.077079]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.078131]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.078441]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.078780] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.079058] no locks held by kworker/u:0/5.
[    1.079325] Modules linked in:
[    1.080061] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.080422] Call Trace:
[    1.080605]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.080928]  [<c13153d2>] schedule+0x77/0x624
[    1.081084]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.081403]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.081690]  [<c1071201>] kthread+0x72/0x77
[    1.081945]  [<c107118f>] ? kthread+0x0/0x77
[    1.081999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.081999] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.082056] no locks held by swapper/1.
[    1.083050] Modules linked in:
[    1.083306] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.083609] Call Trace:
[    1.083845]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.084074]  [<c13153d2>] schedule+0x77/0x624
[    1.084349]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.085079]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.085467]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.085784]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.086078]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.086407]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.086738]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.086999]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.086999]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.086999]  [<c11afbb3>] kset_register+0x2e/0x34
[    1.086999]  [<c124917f>] __class_register+0xb2/0x13d
[    1.087078]  [<c1522d8b>] dmi_id_init+0x207/0x2a6
[    1.088093]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.088395]  [<c1522b84>] ? dmi_id_init+0x0/0x2a6
[    1.089132]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.089421]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.089698]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.090383] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.091062] 2 locks held by kworker/u:1/11:
[    1.091353]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.092065]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.092650] Modules linked in:
[    1.092850] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.093054] Call Trace:
[    1.093261]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.094096]  [<c13153d2>] schedule+0x77/0x624
[    1.094368]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.095087]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.095395]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.096081]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.096442]  [<c1059570>] do_fork+0x26f/0x2db
[    1.096724]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.097139]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.097478]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.097762]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.098083]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.098416]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.099079]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.099394]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.100109]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.101069]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.101435]  [<c1071201>] kthread+0x72/0x77
[    1.101706]  [<c107118f>] ? kthread+0x0/0x77
[    1.102079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.103133] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.103567] 2 locks held by kworker/u:1/11:
[    1.103801]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.104563]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.105343] Modules linked in:
[    1.105557] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.106074] Call Trace:
[    1.106306]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.107090]  [<c13153d2>] schedule+0x77/0x624
[    1.107418]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.107723]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.108151]  [<c104efc1>] complete+0x39/0x43
[    1.108428]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.109088]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.109441]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.109777]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.110146]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.110445]  [<c1071201>] kthread+0x72/0x77
[    1.110704]  [<c107118f>] ? kthread+0x0/0x77
[    1.111145]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.113480] BUG: scheduling while atomic: swapper/1/0x10000001
[    1.113822] no locks held by swapper/1.
[    1.114054] Modules linked in:
[    1.114310] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.114615] Call Trace:
[    1.115069]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.115405]  [<c13153d2>] schedule+0x77/0x624
[    1.115678]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    1.116083]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.116439]  [<c106c56c>] queue_work+0x42/0x49
[    1.116703]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    1.117087]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.117411]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.118075]  [<c12468e3>] device_add+0x2fc/0x45d
[    1.118414]  [<c124cdb7>] ? device_pm_init+0x60/0x65
[    1.118716]  [<c1246a5b>] device_register+0x17/0x1a
[    1.119130]  [<c1522e05>] dmi_id_init+0x281/0x2a6
[    1.119416]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.119706]  [<c1522b84>] ? dmi_id_init+0x0/0x2a6
[    1.120077]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.120366]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.121077]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.121468] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.121812] no locks held by kworker/u:0/5.
[    1.122054] Modules linked in:
[    1.122313] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.122633] Call Trace:
[    1.123080]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.123411]  [<c13153d2>] schedule+0x77/0x624
[    1.123687]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.124090]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.124379]  [<c1071201>] kthread+0x72/0x77
[    1.124646]  [<c107118f>] ? kthread+0x0/0x77
[    1.124901]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.124999] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.125054] no locks held by swapper/1.
[    1.126051] Modules linked in:
[    1.126337] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.126628] Call Trace:
[    1.127077]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.127409]  [<c13153d2>] schedule+0x77/0x624
[    1.127681]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.128079]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.128470]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.128758]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.129077]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.129395]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.130083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.130448]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.130771]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.130999]  [<c12468e3>] device_add+0x2fc/0x45d
[    1.130999]  [<c124cdb7>] ? device_pm_init+0x60/0x65
[    1.131079]  [<c1246a5b>] device_register+0x17/0x1a
[    1.132135]  [<c1522e05>] dmi_id_init+0x281/0x2a6
[    1.132430]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.133078]  [<c1522b84>] ? dmi_id_init+0x0/0x2a6
[    1.133428]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.133704]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.134076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.135107] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.135513] 2 locks held by kworker/u:1/11:
[    1.135748]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.136428]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.136981] Modules linked in:
[    1.136999] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.136999] Call Trace:
[    1.136999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.136999]  [<c13153d2>] schedule+0x77/0x624
[    1.136999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.136999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.136999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.137137]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.137469]  [<c1059570>] do_fork+0x26f/0x2db
[    1.138085]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.138461]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.138789]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.139081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.139424]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.140081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.140475]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.140778]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.141083]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.141384]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.142076]  [<c1071201>] kthread+0x72/0x77
[    1.142335]  [<c107118f>] ? kthread+0x0/0x77
[    1.142606]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.143413] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.144074] no locks held by kworker/u:1/11.
[    1.144324] Modules linked in:
[    1.144524] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.145101] Call Trace:
[    1.145291]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.146093]  [<c13153d2>] schedule+0x77/0x624
[    1.146415]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.146721]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.147150]  [<c1071201>] kthread+0x72/0x77
[    1.147427]  [<c107118f>] ? kthread+0x0/0x77
[    1.147697]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.150166] PCI: PCI BIOS revision 2.10 entry at 0xffe77, last bus=0
[    1.150566] PCI: Using configuration type 1 for base access
[    1.151426] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.152124] no locks held by swapper/1.
[    1.152355] Modules linked in:
[    1.152608] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.153054] Call Trace:
[    1.153230]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.153511]  [<c13153d2>] schedule+0x77/0x624
[    1.153786]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.153999]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.153999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.153999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.153999]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.153999]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.153999]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.153999]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.155066]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.155413]  [<c1247271>] sysdev_register+0xa9/0xb3
[    1.155704]  [<c1314af1>] register_cpu+0x2d/0x64
[    1.155999]  [<c13067ac>] arch_register_cpu+0x33/0x35
[    1.156082]  [<c150190f>] topology_init+0x17/0x36
[    1.157083]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.158077]  [<c15018f8>] ? topology_init+0x0/0x36
[    1.158414]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.159068]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.159443]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.161171] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.161597] 2 locks held by kworker/u:1/11:
[    1.161831]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.162447]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.163058] Modules linked in:
[    1.163275] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.163592] Call Trace:
[    1.164072]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.165082]  [<c13153d2>] schedule+0x77/0x624
[    1.167151]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.168087]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.169082]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.170083]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.171134]  [<c1059570>] do_fork+0x26f/0x2db
[    1.172135]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.173081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.173999]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.173999]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.173999]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.174104]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.174492]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.175079]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.176158]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.177081]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.178077]  [<c1071201>] kthread+0x72/0x77
[    1.179082]  [<c107118f>] ? kthread+0x0/0x77
[    1.180079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.181766] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.182081] 2 locks held by kworker/u:1/11:
[    1.182331]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.183639]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.184465] Modules linked in:
[    1.184690] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.185076] Call Trace:
[    1.186159]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.186466]  [<c13153d2>] schedule+0x77/0x624
[    1.186738]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.186999]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.187095]  [<c104efc1>] complete+0x39/0x43
[    1.188097]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.188498]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.188802]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.189091]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.189403]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.190132]  [<c1071201>] kthread+0x72/0x77
[    1.190561]  [<c107118f>] ? kthread+0x0/0x77
[    1.191080]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.193074] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.193535] no locks held by swapper/1.
[    1.193747] Modules linked in:
[    1.194088] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.194445] Call Trace:
[    1.194616]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.195077]  [<c13153d2>] schedule+0x77/0x624
[    1.195397]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.195705]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.196140]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.196442]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.196833]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.197077]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.197440]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.198146]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.198485]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.199080]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.199436]  [<c1006c65>] ? kvm_irqfd+0x107/0x251
[    1.199727]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.200078]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.200439]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.200740]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.201077]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.201373]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.202109] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.202505] no locks held by kworker/u:0/5.
[    1.202757] Modules linked in:
[    1.203086] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.203449] Call Trace:
[    1.203630]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.204074]  [<c13153d2>] schedule+0x77/0x624
[    1.204365]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.204723]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.205074]  [<c1071201>] kthread+0x72/0x77
[    1.205407]  [<c107118f>] ? kthread+0x0/0x77
[    1.205665]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.206464] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.207062] 2 locks held by kworker/u:1/11:
[    1.207348]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.207841]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.208526] Modules linked in:
[    1.208729] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.209053] Call Trace:
[    1.209238]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.209523]  [<c13153d2>] schedule+0x77/0x624
[    1.210086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.210423]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.210709]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.211097]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.211406]  [<c1059570>] do_fork+0x26f/0x2db
[    1.212084]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.212400]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.213078]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.213429]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.213770]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.214081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.214409]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.215078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.215473]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.215791]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.216077]  [<c1071201>] kthread+0x72/0x77
[    1.216349]  [<c107118f>] ? kthread+0x0/0x77
[    1.216675]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.217633] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.218079] 2 locks held by kworker/u:1/11:
[    1.219110]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.219660]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.220440] Modules linked in:
[    1.220653] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.221127] Call Trace:
[    1.221307]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.221606]  [<c13153d2>] schedule+0x77/0x624
[    1.222096]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.222462]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.222817]  [<c104efc1>] complete+0x39/0x43
[    1.223094]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.223427]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.224152]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.224512]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.224795]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.225089]  [<c1071201>] kthread+0x72/0x77
[    1.225368]  [<c107118f>] ? kthread+0x0/0x77
[    1.226078]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.227075] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.227452] no locks held by swapper/1.
[    1.227692] Modules linked in:
[    1.228061] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.228408] Call Trace:
[    1.228590]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.229077]  [<c13153d2>] schedule+0x77/0x624
[    1.229393]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.229712]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.230079]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.231087]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.232078]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.232443]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.232786]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.233083]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.233413]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.234077]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.234430]  [<c1006c65>] ? kvm_irqfd+0x107/0x251
[    1.234722]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.235077]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.235461]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.235762]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.236074]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.236364]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.237107] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.237526] no locks held by kworker/u:0/5.
[    1.237751] Modules linked in:
[    1.238086] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.238501] Call Trace:
[    1.238672]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.239076]  [<c13153d2>] schedule+0x77/0x624
[    1.239414]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.239704]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.240132]  [<c1071201>] kthread+0x72/0x77
[    1.240403]  [<c107118f>] ? kthread+0x0/0x77
[    1.240661]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.241390] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.242062] 2 locks held by kworker/u:1/11:
[    1.242350]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.243054]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.243643] Modules linked in:
[    1.243842] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.244054] Call Trace:
[    1.244239]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.244521]  [<c13153d2>] schedule+0x77/0x624
[    1.245087]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.245412]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.246137]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.246472]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.247078]  [<c1059570>] do_fork+0x26f/0x2db
[    1.247418]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.247736]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.248133]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.248431]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.248840]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.249092]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.249429]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.250138]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.250487]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.251076]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.251432]  [<c1071201>] kthread+0x72/0x77
[    1.251740]  [<c107118f>] ? kthread+0x0/0x77
[    1.252140]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.253394] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.254103] 2 locks held by kworker/u:1/11:
[    1.255145]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.257133]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.259068] Modules linked in:
[    1.260135] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.261064] Call Trace:
[    1.261263]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.261560]  [<c13153d2>] schedule+0x77/0x624
[    1.262085]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.262394]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.263134]  [<c104efc1>] complete+0x39/0x43
[    1.263406]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.263723]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.264079]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.264417]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.265080]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.265420]  [<c1071201>] kthread+0x72/0x77
[    1.265694]  [<c107118f>] ? kthread+0x0/0x77
[    1.266077]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.268647] BUG: scheduling while atomic: swapper/1/0x10000001
[    1.269060] no locks held by swapper/1.
[    1.269327] Modules linked in:
[    1.269542] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.270053] Call Trace:
[    1.270280]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.270575]  [<c13153d2>] schedule+0x77/0x624
[    1.270837]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    1.271081]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.271383]  [<c106c56c>] queue_work+0x42/0x49
[    1.272086]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    1.272489]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.272803]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.273077]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.274077]  [<c1006c65>] ? kvm_irqfd+0x107/0x251
[    1.274383]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.275078]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.275437]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.275740]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.276129]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.276424]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.277108] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.277491] no locks held by kworker/u:0/5.
[    1.277730] Modules linked in:
[    1.278059] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.278432] Call Trace:
[    1.278613]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.279074]  [<c13153d2>] schedule+0x77/0x624
[    1.279393]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.279692]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.280131]  [<c1071201>] kthread+0x72/0x77
[    1.281080]  [<c107118f>] ? kthread+0x0/0x77
[    1.281588]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.282178] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.282517] no locks held by swapper/1.
[    1.282732] Modules linked in:
[    1.283140] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.283448] Call Trace:
[    1.283618]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.284130]  [<c13153d2>] schedule+0x77/0x624
[    1.284409]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.284703]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.285077]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.285380]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.286078]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.287076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.287504]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.288080]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.288414]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.289079]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.289447]  [<c1006c65>] ? kvm_irqfd+0x107/0x251
[    1.289727]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.290078]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.290421]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.291075]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.291408]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.291698]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.292478] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.293061] 2 locks held by kworker/u:1/11:
[    1.293353]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.293863]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.294383] Modules linked in:
[    1.295064] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.295437] Call Trace:
[    1.295629]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.296081]  [<c13153d2>] schedule+0x77/0x624
[    1.296411]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.296727]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.297144]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.297481]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.297855]  [<c1059570>] do_fork+0x26f/0x2db
[    1.298084]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.298397]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.299123]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.299418]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.299828]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.300080]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.300405]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.301079]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.301416]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.302081]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.302428]  [<c1071201>] kthread+0x72/0x77
[    1.302701]  [<c107118f>] ? kthread+0x0/0x77
[    1.303078]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.304293] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.304670] 2 locks held by kworker/u:1/11:
[    1.305077]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.305631]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.306425] Modules linked in:
[    1.306660] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.307070] Call Trace:
[    1.307242]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.307698]  [<c13153d2>] schedule+0x77/0x624
[    1.308170]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.308489]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.309181]  [<c104efc1>] complete+0x39/0x43
[    1.309461]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.309779]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.310093]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.310432]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.311152]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.311455]  [<c1071201>] kthread+0x72/0x77
[    1.311714]  [<c107118f>] ? kthread+0x0/0x77
[    1.312087]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.313317] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.313651] no locks held by swapper/1.
[    1.313861] Modules linked in:
[    1.313999] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.314054] Call Trace:
[    1.314227]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.315135]  [<c13153d2>] schedule+0x77/0x624
[    1.315416]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.315713]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.316079]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.316384]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.317131]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.317452]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.318083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.318433]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.318770]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.319134]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.319450]  [<c1006c65>] ? kvm_irqfd+0x107/0x251
[    1.319731]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.320077]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.320377]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.321076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.321427]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.321729]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.322165] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.322516] no locks held by kworker/u:0/5.
[    1.322809] Modules linked in:
[    1.323153] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.323522] Call Trace:
[    1.323690]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.324076]  [<c13153d2>] schedule+0x77/0x624
[    1.324367]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.325077]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.325413]  [<c1071201>] kthread+0x72/0x77
[    1.326136]  [<c107118f>] ? kthread+0x0/0x77
[    1.326407]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.327404] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.327761] 2 locks held by kworker/u:1/11:
[    1.328056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.328610]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.329418] Modules linked in:
[    1.329628] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.330057] Call Trace:
[    1.330282]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.330580]  [<c13153d2>] schedule+0x77/0x624
[    1.331084]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.331445]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.331771]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.332081]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.332401]  [<c1059570>] do_fork+0x26f/0x2db
[    1.333083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.333444]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.333797]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.334135]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.334481]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.335080]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.335471]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.335775]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.336083]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.336385]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.337077]  [<c1071201>] kthread+0x72/0x77
[    1.338083]  [<c107118f>] ? kthread+0x0/0x77
[    1.338345]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.340133] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.340555] 2 locks held by kworker/u:1/11:
[    1.340790]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.341548]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.342122] Modules linked in:
[    1.342338] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.342675] Call Trace:
[    1.343164]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.343481]  [<c13153d2>] schedule+0x77/0x624
[    1.343751]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.344091]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.344468]  [<c104efc1>] complete+0x39/0x43
[    1.345094]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.345560]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.346097]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.346516]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.346805]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.347085]  [<c1071201>] kthread+0x72/0x77
[    1.347361]  [<c107118f>] ? kthread+0x0/0x77
[    1.347678]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.348397] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.349112] no locks held by swapper/1.
[    1.349329] Modules linked in:
[    1.349539] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.350052] Call Trace:
[    1.350281]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.350575]  [<c13153d2>] schedule+0x77/0x624
[    1.351081]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.351448]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.351777]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.352145]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.352485]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.353076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.353481]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.353781]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.354081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.354371]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.355077]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.355420]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.355753]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.356137]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.356445]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.356724]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.357107] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.357491] no locks held by kworker/u:0/5.
[    1.358051] Modules linked in:
[    1.358602] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.359107] Call Trace:
[    1.359280]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.359585]  [<c13153d2>] schedule+0x77/0x624
[    1.360084]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.360437]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.360721]  [<c1071201>] kthread+0x72/0x77
[    1.361134]  [<c107118f>] ? kthread+0x0/0x77
[    1.361405]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.362355] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.362723] 2 locks held by kworker/u:1/11:
[    1.363056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.364426]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.365548] Modules linked in:
[    1.365751] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.366055] Call Trace:
[    1.366249]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.366534]  [<c13153d2>] schedule+0x77/0x624
[    1.367085]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.367403]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.368080]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.368476]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.368794]  [<c1059570>] do_fork+0x26f/0x2db
[    1.369088]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.369401]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.370077]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.370445]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.370780]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.371080]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.371413]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.372132]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.372474]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.372833]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.373079]  [<c1071201>] kthread+0x72/0x77
[    1.373364]  [<c107118f>] ? kthread+0x0/0x77
[    1.374079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.375227] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.375603] 2 locks held by kworker/u:1/11:
[    1.375839]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.377387]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.378458] Modules linked in:
[    1.378676] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.379128] Call Trace:
[    1.379305]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.379604]  [<c13153d2>] schedule+0x77/0x624
[    1.380096]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.380457]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.380799]  [<c104efc1>] complete+0x39/0x43
[    1.381095]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.381424]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.382095]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.382485]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.382772]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.383084]  [<c1071201>] kthread+0x72/0x77
[    1.383354]  [<c107118f>] ? kthread+0x0/0x77
[    1.383611]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.384447] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.385057] no locks held by swapper/1.
[    1.385285] Modules linked in:
[    1.385485] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.386054] Call Trace:
[    1.386282]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.386574]  [<c13153d2>] schedule+0x77/0x624
[    1.387081]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.387432]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.387772]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.388147]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.388529]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.389076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.389483]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.389782]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.390080]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.390364]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.391078]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.391482]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.391776]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.392077]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.392369]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.393076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.393479] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.393815] no locks held by kworker/u:0/5.
[    1.394054] Modules linked in:
[    1.394259] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.394587] Call Trace:
[    1.395077]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.395423]  [<c13153d2>] schedule+0x77/0x624
[    1.395702]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.396133]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.396451]  [<c1071201>] kthread+0x72/0x77
[    1.396705]  [<c107118f>] ? kthread+0x0/0x77
[    1.397078]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.398469] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.399062] 2 locks held by kworker/u:1/11:
[    1.399350]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.400055]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.400651] Modules linked in:
[    1.400853] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.401054] Call Trace:
[    1.401240]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.401525]  [<c13153d2>] schedule+0x77/0x624
[    1.402086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.402404]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.403079]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.403488]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.403829]  [<c1059570>] do_fork+0x26f/0x2db
[    1.404083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.404526]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.405144]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.405448]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.406069]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.406464]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.406792]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.407135]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.407475]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.408081]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.408420]  [<c1071201>] kthread+0x72/0x77
[    1.408691]  [<c107118f>] ? kthread+0x0/0x77
[    1.409077]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.410216] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.410601] 2 locks held by kworker/u:1/11:
[    1.410833]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.411079]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.412436] Modules linked in:
[    1.412658] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.413071] Call Trace:
[    1.413314]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.413620]  [<c13153d2>] schedule+0x77/0x624
[    1.414102]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.414456]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.414808]  [<c104efc1>] complete+0x39/0x43
[    1.415094]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.415422]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.416092]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.416484]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.416773]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.417093]  [<c1071201>] kthread+0x72/0x77
[    1.417402]  [<c107118f>] ? kthread+0x0/0x77
[    1.417658]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.419072] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.419445] no locks held by swapper/1.
[    1.419670] Modules linked in:
[    1.420060] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.420405] Call Trace:
[    1.420588]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.420872]  [<c13153d2>] schedule+0x77/0x624
[    1.421082]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.421421]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.422080]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.422446]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.422766]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.423075]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.423424]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.424078]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.425081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.425377]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.426078]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.426415]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.426721]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.427133]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.427422]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.427701]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.428107] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.428456] no locks held by kworker/u:0/5.
[    1.429052] Modules linked in:
[    1.429304] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.429630] Call Trace:
[    1.429798]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.430074]  [<c13153d2>] schedule+0x77/0x624
[    1.430350]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.431076]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.431442]  [<c1071201>] kthread+0x72/0x77
[    1.431703]  [<c107118f>] ? kthread+0x0/0x77
[    1.432077]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.432753] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.433062] 2 locks held by kworker/u:1/11:
[    1.433321]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.434056]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.434590] Modules linked in:
[    1.435142] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.435484] Call Trace:
[    1.435655]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.437086]  [<c13153d2>] schedule+0x77/0x624
[    1.437358]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.438152]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.438464]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.439081]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.439458]  [<c1059570>] do_fork+0x26f/0x2db
[    1.439732]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.440082]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.440426]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.441085]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.441467]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.441795]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.442089]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.442411]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.443082]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.443431]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.443754]  [<c1071201>] kthread+0x72/0x77
[    1.444085]  [<c107118f>] ? kthread+0x0/0x77
[    1.444356]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.445632] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.446132] 2 locks held by kworker/u:1/11:
[    1.446370]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.447165]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.447707] Modules linked in:
[    1.448164] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.448490] Call Trace:
[    1.448723]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.449098]  [<c13153d2>] schedule+0x77/0x624
[    1.449386]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.450090]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.450517]  [<c104efc1>] complete+0x39/0x43
[    1.451166]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.451526]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.452155]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.452497]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.453089]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.453436]  [<c1071201>] kthread+0x72/0x77
[    1.453722]  [<c107118f>] ? kthread+0x0/0x77
[    1.454079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.455136] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.455530] no locks held by swapper/1.
[    1.455743] Modules linked in:
[    1.456086] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.456456] Call Trace:
[    1.456629]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.457078]  [<c13153d2>] schedule+0x77/0x624
[    1.457362]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.458078]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.458456]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.458754]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.459143]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.459460]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.460083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.460441]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.460764]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.461999]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.462078]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.463078]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.463431]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.463741]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.464136]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.464431]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.464857] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.465057] no locks held by kworker/u:0/5.
[    1.465302] Modules linked in:
[    1.466062] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.466442] Call Trace:
[    1.466624]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.466987]  [<c13153d2>] schedule+0x77/0x624
[    1.467081]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.467389]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.468128]  [<c1071201>] kthread+0x72/0x77
[    1.468393]  [<c107118f>] ? kthread+0x0/0x77
[    1.468675]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.469455] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.470062] 2 locks held by kworker/u:1/11:
[    1.470366]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.471056]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.471642] Modules linked in:
[    1.471845] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.472054] Call Trace:
[    1.472238]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.472523]  [<c13153d2>] schedule+0x77/0x624
[    1.473086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.473403]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.474078]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.474462]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.474778]  [<c1059570>] do_fork+0x26f/0x2db
[    1.475139]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.475450]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.476078]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.476415]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.476756]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.477085]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.477417]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.478078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.478456]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.478756]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.479144]  [<c1071201>] kthread+0x72/0x77
[    1.479414]  [<c107118f>] ? kthread+0x0/0x77
[    1.479673]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.480687] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.481077] 2 locks held by kworker/u:1/11:
[    1.481318]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.482482]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.483121] Modules linked in:
[    1.483327] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.483656] Call Trace:
[    1.484103]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.484447]  [<c13153d2>] schedule+0x77/0x624
[    1.484728]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.485151]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.485504]  [<c104efc1>] complete+0x39/0x43
[    1.485856]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.486094]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.486413]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.486739]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.486999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.486999]  [<c1071201>] kthread+0x72/0x77
[    1.487114]  [<c107118f>] ? kthread+0x0/0x77
[    1.487386]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.488579] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.489057] no locks held by swapper/1.
[    1.489287] Modules linked in:
[    1.489486] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.490052] Call Trace:
[    1.490226]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.490518]  [<c13153d2>] schedule+0x77/0x624
[    1.491149]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.491459]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.491780]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.491999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.491999]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.491999]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.491999]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.492081]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.493091]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.493368]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.494078]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.494378]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.495091]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.495444]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.495735]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.496131]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.496482] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.497055] no locks held by kworker/u:0/5.
[    1.497318] Modules linked in:
[    1.497524] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.497831] Call Trace:
[    1.497996]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.497999]  [<c13153d2>] schedule+0x77/0x624
[    1.497999]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.497999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.498075]  [<c1071201>] kthread+0x72/0x77
[    1.499131]  [<c107118f>] ? kthread+0x0/0x77
[    1.499390]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.500335] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.500714] 2 locks held by kworker/u:1/11:
[    1.501056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.501611]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.502379] Modules linked in:
[    1.502594] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.502910] Call Trace:
[    1.502999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.502999]  [<c13153d2>] schedule+0x77/0x624
[    1.502999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.502999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.502999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.503083]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.503472]  [<c1059570>] do_fork+0x26f/0x2db
[    1.503806]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.504084]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.504433]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.505146]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.505491]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.506124]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.506491]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.506808]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.507082]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.507383]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.508075]  [<c1071201>] kthread+0x72/0x77
[    1.508397]  [<c107118f>] ? kthread+0x0/0x77
[    1.508999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.510401] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.510761] 2 locks held by kworker/u:1/11:
[    1.511142]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.511642]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.512505] Modules linked in:
[    1.512710] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.513071] Call Trace:
[    1.513262]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.513547]  [<c13153d2>] schedule+0x77/0x624
[    1.513815]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.513999]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.513999]  [<c104efc1>] complete+0x39/0x43
[    1.513999]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.514099]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.515090]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.515433]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.516168]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.516470]  [<c1071201>] kthread+0x72/0x77
[    1.516787]  [<c107118f>] ? kthread+0x0/0x77
[    1.517097]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.518501] BUG: scheduling while atomic: swapper/1/0x10000001
[    1.518832] no locks held by swapper/1.
[    1.518999] Modules linked in:
[    1.518999] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.518999] Call Trace:
[    1.518999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.518999]  [<c13153d2>] schedule+0x77/0x624
[    1.518999]  [<c1317588>] ? _raw_spin_unlock_irqrestore+0x45/0x49
[    1.519086]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.519444]  [<c106c56c>] queue_work+0x42/0x49
[    1.519734]  [<c106b4c1>] call_usermodehelper_exec+0x94/0xf6
[    1.520088]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.520417]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.521076]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.521437]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.521733]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.522142]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.522455]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.522731]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.523086]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.523442] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.523779] no locks held by kworker/u:0/5.
[    1.523999] Modules linked in:
[    1.523999] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.523999] Call Trace:
[    1.524136]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.524484]  [<c13153d2>] schedule+0x77/0x624
[    1.525082]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.525382]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.526075]  [<c1071201>] kthread+0x72/0x77
[    1.526381]  [<c107118f>] ? kthread+0x0/0x77
[    1.526649]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.527165] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.527491] no locks held by swapper/1.
[    1.527703] Modules linked in:
[    1.528135] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.528453] Call Trace:
[    1.528621]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.528901]  [<c13153d2>] schedule+0x77/0x624
[    1.528999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.528999]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.528999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.529077]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.530074]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.530404]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.531084]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.531445]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.531769]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.532079]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.532395]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.533077]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.533429]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.533738]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.533999]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.533999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.533999] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.533999] 2 locks held by kworker/u:1/11:
[    1.534057]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.534606]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.535435] Modules linked in:
[    1.535652] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.536091] Call Trace:
[    1.536297]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.536595]  [<c13153d2>] schedule+0x77/0x624
[    1.537086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.537445]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.537748]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.538231]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.539078]  [<c1059570>] do_fork+0x26f/0x2db
[    1.539404]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.539734]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.540078]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.540374]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.541081]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.541449]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.541775]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.542078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.542415]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.543080]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.543375]  [<c1071201>] kthread+0x72/0x77
[    1.543645]  [<c107118f>] ? kthread+0x0/0x77
[    1.543904]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.545345] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.545702] 2 locks held by kworker/u:1/11:
[    1.546132]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.546632]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.547492] Modules linked in:
[    1.547696] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.548072] Call Trace:
[    1.548248]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.548538]  [<c13153d2>] schedule+0x77/0x624
[    1.549177]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.549534]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.549878]  [<c104efc1>] complete+0x39/0x43
[    1.549999]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.549999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.550093]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.550428]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.551096]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.551399]  [<c1071201>] kthread+0x72/0x77
[    1.552100]  [<c107118f>] ? kthread+0x0/0x77
[    1.552414]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.553546] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.553873] no locks held by swapper/1.
[    1.554109] Modules linked in:
[    1.554309] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.554614] Call Trace:
[    1.554782]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.554999]  [<c13153d2>] schedule+0x77/0x624
[    1.554999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.554999]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.555148]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.556077]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.556474]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.557076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.557483]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.557794]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.558080]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.558367]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.559077]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.559419]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.559723]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.560076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.561075]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.562075]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.562473] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.562817] no locks held by kworker/u:0/5.
[    1.563053] Modules linked in:
[    1.563253] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.563570] Call Trace:
[    1.564077]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.564429]  [<c13153d2>] schedule+0x77/0x624
[    1.564704]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.565143]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.565442]  [<c1071201>] kthread+0x72/0x77
[    1.565695]  [<c107118f>] ? kthread+0x0/0x77
[    1.565955]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.565999] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.565999] 2 locks held by kworker/u:1/11:
[    1.566056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.567056]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.567657] Modules linked in:
[    1.568090] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.568464] Call Trace:
[    1.568645]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.569080]  [<c13153d2>] schedule+0x77/0x624
[    1.569406]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.569742]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.570138]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.570476]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.571077]  [<c1059570>] do_fork+0x26f/0x2db
[    1.571398]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.571715]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.571999]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.571999]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.571999]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.572084]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.572421]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.573079]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.573418]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.574081]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.574427]  [<c1071201>] kthread+0x72/0x77
[    1.574697]  [<c107118f>] ? kthread+0x0/0x77
[    1.575133]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.576276] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.576684] 2 locks held by kworker/u:1/11:
[    1.576918]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.576999]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.576999] Modules linked in:
[    1.576999] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.577159] Call Trace:
[    1.577336]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.578128]  [<c13153d2>] schedule+0x77/0x624
[    1.578414]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.579163]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.579516]  [<c104efc1>] complete+0x39/0x43
[    1.579838]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.580098]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.580415]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.581161]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.581458]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.581768]  [<c1071201>] kthread+0x72/0x77
[    1.581999]  [<c107118f>] ? kthread+0x0/0x77
[    1.581999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.581999] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.583073] no locks held by swapper/1.
[    1.583361] Modules linked in:
[    1.583560] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.583861] Call Trace:
[    1.584096]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.584431]  [<c13153d2>] schedule+0x77/0x624
[    1.584710]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.585143]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.585478]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.586066]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.586433]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.586748]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.587140]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.587448]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.587775]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.587999]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.587999]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.587999]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.588077]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.588468]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.589147]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.589450]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.590060] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.590474] no locks held by kworker/u:0/5.
[    1.590713] Modules linked in:
[    1.591089] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.591453] Call Trace:
[    1.591635]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.591975]  [<c13153d2>] schedule+0x77/0x624
[    1.592080]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.592381]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.592679]  [<c1071201>] kthread+0x72/0x77
[    1.592934]  [<c107118f>] ? kthread+0x0/0x77
[    1.592999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.592999] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.593061] 2 locks held by kworker/u:1/11:
[    1.593352]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.594488]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.595384] Modules linked in:
[    1.595602] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.596056] Call Trace:
[    1.596304]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.596604]  [<c13153d2>] schedule+0x77/0x624
[    1.596873]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.597089]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.597451]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.598079]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.598396]  [<c1059570>] do_fork+0x26f/0x2db
[    1.598664]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.598966]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.598999]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.598999]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.598999]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.598999]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.599079]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.600078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.600420]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.601144]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.601448]  [<c1071201>] kthread+0x72/0x77
[    1.601710]  [<c107118f>] ? kthread+0x0/0x77
[    1.602079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.603454] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.603812] 2 locks held by kworker/u:1/11:
[    1.604142]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.604637]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.604999] Modules linked in:
[    1.604999] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.604999] Call Trace:
[    1.605190]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.605488]  [<c13153d2>] schedule+0x77/0x624
[    1.605763]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.606099]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.606457]  [<c104efc1>] complete+0x39/0x43
[    1.607167]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.607496]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.608090]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.608473]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.608773]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.609160]  [<c1071201>] kthread+0x72/0x77
[    1.609438]  [<c107118f>] ? kthread+0x0/0x77
[    1.609697]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.610769] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.610999] no locks held by swapper/1.
[    1.611061] Modules linked in:
[    1.612142] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.612436] Call Trace:
[    1.612617]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.613080]  [<c13153d2>] schedule+0x77/0x624
[    1.613411]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.613714]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.614080]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.614377]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.615078]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.615432]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.615784]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.616240]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.617081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.617439]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.617742]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.618079]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.618385]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.619076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.619401]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.619692]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.620211] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.620556] no locks held by kworker/u:0/5.
[    1.621052] Modules linked in:
[    1.621258] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.621574] Call Trace:
[    1.621741]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.621999]  [<c13153d2>] schedule+0x77/0x624
[    1.621999]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.621999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.621999]  [<c1071201>] kthread+0x72/0x77
[    1.621999]  [<c107118f>] ? kthread+0x0/0x77
[    1.622086]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.623444] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.623804] 2 locks held by kworker/u:1/11:
[    1.624126]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.624620]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.625532] Modules linked in:
[    1.625743] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.626122] Call Trace:
[    1.626297]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.626594]  [<c13153d2>] schedule+0x77/0x624
[    1.627148]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.627486]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.627779]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.628080]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.628393]  [<c1059570>] do_fork+0x26f/0x2db
[    1.629090]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.629468]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.629814]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.630081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.630425]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.631145]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.631478]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.632078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.632460]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.632761]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.633144]  [<c1071201>] kthread+0x72/0x77
[    1.633417]  [<c107118f>] ? kthread+0x0/0x77
[    1.633679]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.634165] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.635163] 2 locks held by kworker/u:1/11:
[    1.635415]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.636484]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.637137] Modules linked in:
[    1.637346] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.637671] Call Trace:
[    1.638098]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.638455]  [<c13153d2>] schedule+0x77/0x624
[    1.638735]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.639158]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.639525]  [<c104efc1>] complete+0x39/0x43
[    1.639785]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.639999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.639999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.639999]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.639999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.640093]  [<c1071201>] kthread+0x72/0x77
[    1.641164]  [<c107118f>] ? kthread+0x0/0x77
[    1.641435]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.642407] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.643057] no locks held by swapper/1.
[    1.643325] Modules linked in:
[    1.643538] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.643827] Call Trace:
[    1.644134]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.644419]  [<c13153d2>] schedule+0x77/0x624
[    1.644691]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.645078]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.645412]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.645722]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.645999]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.645999]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.645999]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.646080]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.647081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.647373]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.648077]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.648414]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.648717]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.649076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.649412]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.649713]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.650137] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.650497] no locks held by kworker/u:0/5.
[    1.650727] Modules linked in:
[    1.650922] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.650999] Call Trace:
[    1.650999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.650999]  [<c13153d2>] schedule+0x77/0x624
[    1.650999]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.650999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.651076]  [<c1071201>] kthread+0x72/0x77
[    1.651343]  [<c107118f>] ? kthread+0x0/0x77
[    1.652075]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.652748] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.653060] 2 locks held by kworker/u:1/11:
[    1.653318]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.654057]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.654598] Modules linked in:
[    1.656098] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.657055] Call Trace:
[    1.657233]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.657531]  [<c13153d2>] schedule+0x77/0x624
[    1.658154]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.658498]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.658877]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.659080]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.659416]  [<c1059570>] do_fork+0x26f/0x2db
[    1.660140]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.660456]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.660788]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.660999]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.660999]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.660999]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.660999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.660999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.661085]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.661452]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.662078]  [<c1071201>] kthread+0x72/0x77
[    1.662352]  [<c107118f>] ? kthread+0x0/0x77
[    1.662614]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.664079] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.664475] 2 locks held by kworker/u:1/11:
[    1.664722]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.665486]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.666067] Modules linked in:
[    1.667180] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.667523] Call Trace:
[    1.667699]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.668163]  [<c13153d2>] schedule+0x77/0x624
[    1.668438]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    1.669100]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.669452]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.669823]  [<c104efc1>] complete+0x39/0x43
[    1.670100]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.670430]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.671086]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.671476]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.671775]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.671999]  [<c1071201>] kthread+0x72/0x77
[    1.671999]  [<c107118f>] ? kthread+0x0/0x77
[    1.671999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.671999] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.673059] no locks held by swapper/1.
[    1.673330] Modules linked in:
[    1.673529] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.673832] Call Trace:
[    1.674079]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.674427]  [<c13153d2>] schedule+0x77/0x624
[    1.674707]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.675138]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.675473]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.676077]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.676454]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.676774]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.677153]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.677470]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.677782]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.678077]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.678444]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.679151]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.679459]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.679759]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.680076]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.680369]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.681164] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.681510] no locks held by kworker/u:0/5.
[    1.681740] Modules linked in:
[    1.682089] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.682452] Call Trace:
[    1.682634]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.683075]  [<c13153d2>] schedule+0x77/0x624
[    1.683396]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.683698]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.683982]  [<c1071201>] kthread+0x72/0x77
[    1.683999]  [<c107118f>] ? kthread+0x0/0x77
[    1.683999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.683999] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.684126] 2 locks held by kworker/u:1/11:
[    1.685055]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.685627]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.686423] Modules linked in:
[    1.686650] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.687057] Call Trace:
[    1.687288]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.687587]  [<c13153d2>] schedule+0x77/0x624
[    1.688086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.688457]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.688764]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.689080]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.689400]  [<c1059570>] do_fork+0x26f/0x2db
[    1.689669]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.689971]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.689999]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.689999]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.690082]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.690414]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.691134]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.691453]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.691823]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.692083]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.692387]  [<c1071201>] kthread+0x72/0x77
[    1.693082]  [<c107118f>] ? kthread+0x0/0x77
[    1.693399]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.694536] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.694898] 2 locks held by kworker/u:1/11:
[    1.694999]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.694999]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.694999] Modules linked in:
[    1.694999] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.696089] Call Trace:
[    1.696321]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.696630]  [<c13153d2>] schedule+0x77/0x624
[    1.697141]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.697492]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.697848]  [<c104efc1>] complete+0x39/0x43
[    1.698093]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.698425]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.699165]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.699505]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.699795]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.700087]  [<c1071201>] kthread+0x72/0x77
[    1.700357]  [<c107118f>] ? kthread+0x0/0x77
[    1.700617]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.701338] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.702127] no locks held by swapper/1.
[    1.702355] Modules linked in:
[    1.702547] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.703062] Call Trace:
[    1.703238]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.703539]  [<c13153d2>] schedule+0x77/0x624
[    1.704135]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.704472]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.705080]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.705460]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.705788]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.706077]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.706433]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.706731]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.706999]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.706999]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.706999]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.706999]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.707077]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.707442]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.708088]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.708370]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.709108] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.709458] no locks held by kworker/u:0/5.
[    1.710052] Modules linked in:
[    1.710311] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.710633] Call Trace:
[    1.710804]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.711075]  [<c13153d2>] schedule+0x77/0x624
[    1.711354]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.712077]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.712445]  [<c1071201>] kthread+0x72/0x77
[    1.712721]  [<c107118f>] ? kthread+0x0/0x77
[    1.713075]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.713749] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.714061] 2 locks held by kworker/u:1/11:
[    1.714336]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.715341]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.716053] Modules linked in:
[    1.716314] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.716653] Call Trace:
[    1.716824]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.717081]  [<c13153d2>] schedule+0x77/0x624
[    1.717366]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.718086]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.718435]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.718768]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.719079]  [<c1059570>] do_fork+0x26f/0x2db
[    1.719364]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.720081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.720468]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.720800]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.721081]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.721691]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.722080]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.723078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.723488]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.723778]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.724077]  [<c1071201>] kthread+0x72/0x77
[    1.724349]  [<c107118f>] ? kthread+0x0/0x77
[    1.724674]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.726079] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.726487] 2 locks held by kworker/u:1/11:
[    1.726745]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.727548]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.728095] Modules linked in:
[    1.728330] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.728649] Call Trace:
[    1.729089]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.729490]  [<c13153d2>] schedule+0x77/0x624
[    1.730081]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    1.730484]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.730792]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.731093]  [<c104efc1>] complete+0x39/0x43
[    1.731368]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.732097]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.732459]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.732793]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.733090]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.733428]  [<c1071201>] kthread+0x72/0x77
[    1.734081]  [<c107118f>] ? kthread+0x0/0x77
[    1.734395]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.735286] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.735616] no locks held by swapper/1.
[    1.735823] Modules linked in:
[    1.736092] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.736448] Call Trace:
[    1.736635]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.737076]  [<c13153d2>] schedule+0x77/0x624
[    1.737406]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.737714]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.738138]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.738449]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.739077]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.739432]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.739777]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.740081]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.740408]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.741076]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.741431]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.741754]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.742076]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.742750]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.743075]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.743376]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.744107] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.744496] no locks held by kworker/u:0/5.
[    1.744736] Modules linked in:
[    1.745088] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.745457] Call Trace:
[    1.745658]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.746075]  [<c13153d2>] schedule+0x77/0x624
[    1.746390]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.746691]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.747999]  [<c1071201>] kthread+0x72/0x77
[    1.748081]  [<c107118f>] ? kthread+0x0/0x77
[    1.749142]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.750075] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.750469] 2 locks held by kworker/u:1/11:
[    1.750717]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.751432]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.752053] Modules linked in:
[    1.752310] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.752635] Call Trace:
[    1.752809]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.753080]  [<c13153d2>] schedule+0x77/0x624
[    1.753362]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.754085]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.754435]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.754791]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.755077]  [<c1059570>] do_fork+0x26f/0x2db
[    1.756083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.756443]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.756787]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.757137]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.757485]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.758081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.758450]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.758765]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.759083]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.759383]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.760078]  [<c1071201>] kthread+0x72/0x77
[    1.760388]  [<c107118f>] ? kthread+0x0/0x77
[    1.760672]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.761659] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.762078] 2 locks held by kworker/u:1/11:
[    1.762400]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.763110]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.764067] Modules linked in:
[    1.764325] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.764654] Call Trace:
[    1.764827]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.765152]  [<c13153d2>] schedule+0x77/0x624
[    1.765436]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.766091]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.766482]  [<c104efc1>] complete+0x39/0x43
[    1.766767]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.767143]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.767460]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.768099]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.768445]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.768737]  [<c1071201>] kthread+0x72/0x77
[    1.769166]  [<c107118f>] ? kthread+0x0/0x77
[    1.769432]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.770393] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.770728] no locks held by swapper/1.
[    1.771053] Modules linked in:
[    1.771332] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.771635] Call Trace:
[    1.771806]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.772077]  [<c13153d2>] schedule+0x77/0x624
[    1.772360]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.773077]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.773462]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.773768]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.774210]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.774528]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.775096]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.776079]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.776446]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.776747]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.777133]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.777429]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.777724]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.778076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.778367]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.779075]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.779470] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.779822] no locks held by kworker/u:0/5.
[    1.779999] Modules linked in:
[    1.779999] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.779999] Call Trace:
[    1.781079]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.781423]  [<c13153d2>] schedule+0x77/0x624
[    1.781725]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.782083]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.782450]  [<c1071201>] kthread+0x72/0x77
[    1.782715]  [<c107118f>] ? kthread+0x0/0x77
[    1.783141]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.784114] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.784512] 2 locks held by kworker/u:1/11:
[    1.784757]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.785422]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.786053] Modules linked in:
[    1.786306] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.786634] Call Trace:
[    1.786873]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.787079]  [<c13153d2>] schedule+0x77/0x624
[    1.787361]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.788085]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.788432]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.788767]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.789079]  [<c1059570>] do_fork+0x26f/0x2db
[    1.789363]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.790081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.790463]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.790756]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.791082]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.791416]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.792079]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.792513]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.793082]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.793379]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.793678]  [<c1071201>] kthread+0x72/0x77
[    1.793938]  [<c107118f>] ? kthread+0x0/0x77
[    1.793999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.795168] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.795596] 2 locks held by kworker/u:1/11:
[    1.796075]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.796656]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.797512] Modules linked in:
[    1.797719] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.798067] Call Trace:
[    1.798243]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.798557]  [<c13153d2>] schedule+0x77/0x624
[    1.799104]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.799419]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.799761]  [<c104efc1>] complete+0x39/0x43
[    1.799999]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.799999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.799999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.799999]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.800094]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.801145]  [<c1071201>] kthread+0x72/0x77
[    1.801419]  [<c107118f>] ? kthread+0x0/0x77
[    1.802100]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.802780] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.803064] no locks held by swapper/1.
[    1.803293] Modules linked in:
[    1.803492] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.804052] Call Trace:
[    1.804226]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.804522]  [<c13153d2>] schedule+0x77/0x624
[    1.804792]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.804999]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.805156]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.806078]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.806411]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.807138]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.807489]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.807867]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.808081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.808373]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.809080]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.809439]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.809889]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.810078]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.810369]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.811076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.811475] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.811835] no locks held by kworker/u:0/5.
[    1.811999] Modules linked in:
[    1.811999] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.811999] Call Trace:
[    1.811999]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.811999]  [<c13153d2>] schedule+0x77/0x624
[    1.812066]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.812456]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.813074]  [<c1071201>] kthread+0x72/0x77
[    1.813344]  [<c107118f>] ? kthread+0x0/0x77
[    1.814074]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.814749] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.815060] 2 locks held by kworker/u:1/11:
[    1.815329]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.816057]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.816591] Modules linked in:
[    1.817156] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.817520] Call Trace:
[    1.817749]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.817999]  [<c13153d2>] schedule+0x77/0x624
[    1.817999]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.817999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.817999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.817999]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.818079]  [<c1059570>] do_fork+0x26f/0x2db
[    1.819083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.819401]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.820078]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.820422]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.820774]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.821081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.821421]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.822078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.822463]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.822763]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.823075]  [<c1071201>] kthread+0x72/0x77
[    1.823375]  [<c107118f>] ? kthread+0x0/0x77
[    1.823637]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.824077] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.825114] 2 locks held by kworker/u:1/11:
[    1.825365]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.826444]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.827142] Modules linked in:
[    1.827349] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.827679] Call Trace:
[    1.828163]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.828456]  [<c13153d2>] schedule+0x77/0x624
[    1.828730]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    1.829098]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.829413]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.829756]  [<c104efc1>] complete+0x39/0x43
[    1.829999]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.829999]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.829999]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.829999]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.830157]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.831149]  [<c1071201>] kthread+0x72/0x77
[    1.831428]  [<c107118f>] ? kthread+0x0/0x77
[    1.831688]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.832456] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.833057] no locks held by swapper/1.
[    1.833274] Modules linked in:
[    1.833494] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.834053] Call Trace:
[    1.834228]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.834522]  [<c13153d2>] schedule+0x77/0x624
[    1.835143]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.835464]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.835822]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.835999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.835999]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.835999]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.835999]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.835999]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.836144]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.836423]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.836745]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.837133]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.837437]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.837741]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.838074]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.838375]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.839109] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.839524] no locks held by kworker/u:0/5.
[    1.839755] Modules linked in:
[    1.840143] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.840471] Call Trace:
[    1.840650]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.840931]  [<c13153d2>] schedule+0x77/0x624
[    1.840999]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.840999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.840999]  [<c1071201>] kthread+0x72/0x77
[    1.840999]  [<c107118f>] ? kthread+0x0/0x77
[    1.841079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.842448] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.843064] 2 locks held by kworker/u:1/11:
[    1.843366]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.844055]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.844649] Modules linked in:
[    1.845062] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.845452] Call Trace:
[    1.845645]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.846080]  [<c13153d2>] schedule+0x77/0x624
[    1.846419]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.847086]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.847437]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.847777]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.848078]  [<c1059570>] do_fork+0x26f/0x2db
[    1.848370]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.849082]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.849468]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.849764]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.850081]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.850413]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.851078]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.851455]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.851792]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.852080]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.852379]  [<c1071201>] kthread+0x72/0x77
[    1.853080]  [<c107118f>] ? kthread+0x0/0x77
[    1.853395]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.854489] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.854858] 2 locks held by kworker/u:1/11:
[    1.855138]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.855640]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.856596] Modules linked in:
[    1.856816] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.857068] Call Trace:
[    1.857255]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.857544]  [<c13153d2>] schedule+0x77/0x624
[    1.858103]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.858414]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.859146]  [<c104efc1>] complete+0x39/0x43
[    1.859410]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.859736]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.860093]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.860439]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.861152]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.861442]  [<c1071201>] kthread+0x72/0x77
[    1.861709]  [<c107118f>] ? kthread+0x0/0x77
[    1.862153]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.863126] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.863495] no locks held by swapper/1.
[    1.863721] Modules linked in:
[    1.864061] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.864418] Call Trace:
[    1.864597]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.865076]  [<c13153d2>] schedule+0x77/0x624
[    1.865403]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.865705]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.866150]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.866443]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.866775]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.867076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.867423]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.868134]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.868469]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.868815]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.869079]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.869376]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.870077]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.870430]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.870731]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.870999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.870999] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.870999] no locks held by kworker/u:0/5.
[    1.870999] Modules linked in:
[    1.871085] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.872053] Call Trace:
[    1.872227]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.872526]  [<c13153d2>] schedule+0x77/0x624
[    1.873083]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.873391]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.874075]  [<c1071201>] kthread+0x72/0x77
[    1.874382]  [<c107118f>] ? kthread+0x0/0x77
[    1.874655]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.875434] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.875791] 2 locks held by kworker/u:1/11:
[    1.876111]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.876621]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.877422] Modules linked in:
[    1.877653] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.878056] Call Trace:
[    1.878230]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.878521]  [<c13153d2>] schedule+0x77/0x624
[    1.879150]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.879470]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.879765]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.880084]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.880407]  [<c1059570>] do_fork+0x26f/0x2db
[    1.881140]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.881445]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.881785]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.882081]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.882438]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.883127]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.883459]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.884078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.884466]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.884788]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.885136]  [<c1071201>] kthread+0x72/0x77
[    1.885399]  [<c107118f>] ? kthread+0x0/0x77
[    1.886144]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.887602] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.888078] 2 locks held by kworker/u:1/11:
[    1.888367]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.889111]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.889706] Modules linked in:
[    1.890078] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.890470] Call Trace:
[    1.890656]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.891097]  [<c13153d2>] schedule+0x77/0x624
[    1.891429]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.891735]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.892090]  [<c104efc1>] complete+0x39/0x43
[    1.892360]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.893101]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.893466]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.893802]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.894103]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.894403]  [<c1071201>] kthread+0x72/0x77
[    1.895091]  [<c107118f>] ? kthread+0x0/0x77
[    1.895407]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.896318] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.896650] no locks held by swapper/1.
[    1.896862] Modules linked in:
[    1.897140] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.898055] Call Trace:
[    1.898231]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.898527]  [<c13153d2>] schedule+0x77/0x624
[    1.899142]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.899438]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.900066]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.900402]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.900733]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.901136]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.901482]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.901785]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.902098]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.902396]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.902699]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.902984]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.902999]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.902999]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.903078]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.904076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.904431] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.905056] no locks held by kworker/u:0/5.
[    1.905346] Modules linked in:
[    1.905566] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.906053] Call Trace:
[    1.906275]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.906572]  [<c13153d2>] schedule+0x77/0x624
[    1.907067]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.907410]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.907716]  [<c1071201>] kthread+0x72/0x77
[    1.907976]  [<c107118f>] ? kthread+0x0/0x77
[    1.907999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.908064] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.908468] 2 locks held by kworker/u:1/11:
[    1.909055]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.909617]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.910420] Modules linked in:
[    1.910633] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.911056] Call Trace:
[    1.911287]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.911587]  [<c13153d2>] schedule+0x77/0x624
[    1.912096]  [<c1057095>] ? scheduler_tick+0xb0/0x1fb
[    1.912460]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.912768]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    1.912999]  [<c1317e6d>] ? apic_timer_interrupt+0x31/0x38
[    1.912999]  [<c13175b0>] ? _raw_spin_unlock_irq+0x24/0x43
[    1.912999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.912999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.913083]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.914078]  [<c1059570>] do_fork+0x26f/0x2db
[    1.914365]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.915082]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.915424]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.916080]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.916472]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.916804]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.917080]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.917398]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.918082]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.918371]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.919078]  [<c1071201>] kthread+0x72/0x77
[    1.920145]  [<c107118f>] ? kthread+0x0/0x77
[    1.920408]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.921601] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.922078] 2 locks held by kworker/u:1/11:
[    1.922366]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.923110]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.923721] Modules linked in:
[    1.924107] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.924510] Call Trace:
[    1.925101]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.925445]  [<c13153d2>] schedule+0x77/0x624
[    1.925728]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.926156]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.926512]  [<c104efc1>] complete+0x39/0x43
[    1.926776]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.927096]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.927414]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.928162]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.928463]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.928770]  [<c1071201>] kthread+0x72/0x77
[    1.928999]  [<c107118f>] ? kthread+0x0/0x77
[    1.928999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.929244] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.929575] no locks held by swapper/1.
[    1.929789] Modules linked in:
[    1.930142] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.930435] Call Trace:
[    1.930619]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.931151]  [<c13153d2>] schedule+0x77/0x624
[    1.931424]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.931728]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.932084]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.932385]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.933077]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.933444]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.933790]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.934078]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.934407]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.934683]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.934980]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.935078]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.936134]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.936438]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.936728]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.937076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.937434] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.938058] no locks held by kworker/u:0/5.
[    1.938345] Modules linked in:
[    1.938554] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.939053] Call Trace:
[    1.939277]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.939572]  [<c13153d2>] schedule+0x77/0x624
[    1.940079]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.940369]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.940664]  [<c1071201>] kthread+0x72/0x77
[    1.940916]  [<c107118f>] ? kthread+0x0/0x77
[    1.940999]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.942063] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.942459] 2 locks held by kworker/u:1/11:
[    1.942705]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.943486]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.944112] Modules linked in:
[    1.944320] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.944676] Call Trace:
[    1.945085]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.945429]  [<c13153d2>] schedule+0x77/0x624
[    1.945702]  [<c1057095>] ? scheduler_tick+0xb0/0x1fb
[    1.946140]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.946448]  [<c1040429>] ? smp_apic_timer_interrupt+0x73/0x81
[    1.946792]  [<c1317e6d>] ? apic_timer_interrupt+0x31/0x38
[    1.946999]  [<c13175b0>] ? _raw_spin_unlock_irq+0x24/0x43
[    1.946999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.946999]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.946999]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.947136]  [<c1059570>] do_fork+0x26f/0x2db
[    1.948083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.948453]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.949134]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.949421]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.949766]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.950081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.950404]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.951140]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.951478]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.951999]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.952135]  [<c1071201>] kthread+0x72/0x77
[    1.952427]  [<c107118f>] ? kthread+0x0/0x77
[    1.953080]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.954385] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.954745] 2 locks held by kworker/u:1/11:
[    1.955153]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.955652]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.956477] Modules linked in:
[    1.956693] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.957070] Call Trace:
[    1.957246]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.957594]  [<c13153d2>] schedule+0x77/0x624
[    1.958160]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.958491]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.959089]  [<c104efc1>] complete+0x39/0x43
[    1.959402]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.959792]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.960094]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.960435]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.961157]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.961458]  [<c1071201>] kthread+0x72/0x77
[    1.961719]  [<c107118f>] ? kthread+0x0/0x77
[    1.962090]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.963268] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.963616] no locks held by swapper/1.
[    1.963832] Modules linked in:
[    1.964140] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.964440] Call Trace:
[    1.964620]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.965076]  [<c13153d2>] schedule+0x77/0x624
[    1.965403]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.965733]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    1.965999]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.966078]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.967133]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.967455]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    1.968083]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.968438]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    1.968767]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    1.969131]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    1.969438]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    1.969735]  [<c1001168>] do_one_initcall+0x76/0x121
[    1.970078]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    1.970392]  [<c14fc387>] kernel_init+0x126/0x1a7
[    1.971073]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    1.971417]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.971769] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    1.972056] no locks held by kworker/u:0/5.
[    1.972296] Modules linked in:
[    1.972492] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    1.973053] Call Trace:
[    1.973244]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.973592]  [<c13153d2>] schedule+0x77/0x624
[    1.974081]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    1.974384]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.975075]  [<c1071201>] kthread+0x72/0x77
[    1.975383]  [<c107118f>] ? kthread+0x0/0x77
[    1.975656]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.976435] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    1.977062] 2 locks held by kworker/u:1/11:
[    1.977354]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.977850]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.978558] Modules linked in:
[    1.978767] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.979054] Call Trace:
[    1.979258]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.980109]  [<c13153d2>] schedule+0x77/0x624
[    1.980398]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    1.981086]  [<c13151c2>] wait_for_common+0xa0/0xef
[    1.981431]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    1.981768]  [<c13152b0>] wait_for_completion+0x17/0x19
[    1.982133]  [<c1059570>] do_fork+0x26f/0x2db
[    1.982405]  [<c1315153>] ? wait_for_common+0x31/0xef
[    1.982721]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.983078]  [<c1030969>] kernel_thread+0x7e/0x86
[    1.983377]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    1.984083]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    1.984458]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    1.984794]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.985081]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.985442]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.986131]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.986434]  [<c1071201>] kthread+0x72/0x77
[    1.986692]  [<c107118f>] ? kthread+0x0/0x77
[    1.987080]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.988442] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    1.988805] 2 locks held by kworker/u:1/11:
[    1.989151]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.989657]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    1.990598] Modules linked in:
[    1.990804] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    1.991072] Call Trace:
[    1.991264]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.991564]  [<c13153d2>] schedule+0x77/0x624
[    1.992104]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    1.992438]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    1.993149]  [<c104efc1>] complete+0x39/0x43
[    1.993417]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    1.994159]  [<c106cb47>] process_one_work+0x1ff/0x334
[    1.994483]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    1.995169]  [<c106e4a6>] worker_thread+0xfc/0x203
[    1.995464]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    1.995779]  [<c1071201>] kthread+0x72/0x77
[    1.996091]  [<c107118f>] ? kthread+0x0/0x77
[    1.996374]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    1.997533] BUG: scheduling while atomic: swapper/1/0x00000001
[    1.998057] no locks held by swapper/1.
[    1.998325] Modules linked in:
[    1.998535] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    1.998840] Call Trace:
[    1.999077]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    1.999420]  [<c13153d2>] schedule+0x77/0x624
[    1.999723]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.000083]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    2.001080]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.001435]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.001777]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.002077]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    2.002428]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.003079]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    2.003453]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    2.003741]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    2.004078]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    2.004380]  [<c1001168>] do_one_initcall+0x76/0x121
[    2.005077]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    2.005432]  [<c14fc387>] kernel_init+0x126/0x1a7
[    2.005725]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    2.006176]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.006554] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    2.007056] no locks held by kworker/u:0/5.
[    2.007599] Modules linked in:
[    2.007796] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    2.008053] Call Trace:
[    2.008227]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.008522]  [<c13153d2>] schedule+0x77/0x624
[    2.009082]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    2.009386]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.010075]  [<c1071201>] kthread+0x72/0x77
[    2.010385]  [<c107118f>] ? kthread+0x0/0x77
[    2.010654]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.011429] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    2.011790] 2 locks held by kworker/u:1/11:
[    2.012056]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.012554]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.013525] Modules linked in:
[    2.013756] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.014054] Call Trace:
[    2.014225]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.014655]  [<c13153d2>] schedule+0x77/0x624
[    2.015170]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.015487]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.016081]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.016477]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.016798]  [<c1059570>] do_fork+0x26f/0x2db
[    2.017085]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.017400]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.018078]  [<c1030969>] kernel_thread+0x7e/0x86
[    2.018416]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.018759]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    2.019079]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    2.019445]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.020077]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.020461]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.020788]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.021076]  [<c1071201>] kthread+0x72/0x77
[    2.021431]  [<c107118f>] ? kthread+0x0/0x77
[    2.022079]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.023122] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    2.023521] 2 locks held by kworker/u:1/11:
[    2.023766]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.024583]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.025337] Modules linked in:
[    2.025542] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.025869] Call Trace:
[    2.026147]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.026438]  [<c13153d2>] schedule+0x77/0x624
[    2.026716]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    2.027091]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    2.027469]  [<c104efc1>] complete+0x39/0x43
[    2.028098]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    2.028520]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.029097]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.029435]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.030088]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.030427]  [<c1071201>] kthread+0x72/0x77
[    2.030753]  [<c107118f>] ? kthread+0x0/0x77
[    2.031136]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.032261] BUG: scheduling while atomic: swapper/1/0x00000001
[    2.032602] no locks held by swapper/1.
[    2.032832] Modules linked in:
[    2.033134] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    2.033432] Call Trace:
[    2.033613]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.034141]  [<c13153d2>] schedule+0x77/0x624
[    2.034412]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.034740]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    2.035081]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.036132]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.036492]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.037076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    2.037459]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.037773]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    2.038139]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    2.038416]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    2.038727]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    2.039078]  [<c1001168>] do_one_initcall+0x76/0x121
[    2.039400]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    2.040074]  [<c14fc387>] kernel_init+0x126/0x1a7
[    2.040412]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    2.040700]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.041106] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    2.041449] no locks held by kworker/u:0/5.
[    2.042052] Modules linked in:
[    2.042342] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    2.042663] Call Trace:
[    2.042834]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.043075]  [<c13153d2>] schedule+0x77/0x624
[    2.043351]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    2.044077]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.044438]  [<c1071201>] kthread+0x72/0x77
[    2.044703]  [<c107118f>] ? kthread+0x0/0x77
[    2.045076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.045751] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    2.046062] 2 locks held by kworker/u:1/11:
[    2.046320]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.047111]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.047661] Modules linked in:
[    2.048141] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.048455] Call Trace:
[    2.048636]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.049080]  [<c13153d2>] schedule+0x77/0x624
[    2.049407]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.049723]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.050082]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.050419]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.051078]  [<c1059570>] do_fork+0x26f/0x2db
[    2.051401]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.051714]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.052078]  [<c1030969>] kernel_thread+0x7e/0x86
[    2.052388]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.053080]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    2.053456]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    2.053784]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.054078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.054438]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.054723]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.054999]  [<c1071201>] kthread+0x72/0x77
[    2.055085]  [<c107118f>] ? kthread+0x0/0x77
[    2.056135]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.057378] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    2.057741] 2 locks held by kworker/u:1/11:
[    2.058076]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.058645]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.059474] Modules linked in:
[    2.059699] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.060118] Call Trace:
[    2.060295]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.060591]  [<c13153d2>] schedule+0x77/0x624
[    2.061163]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    2.061497]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    2.061876]  [<c104efc1>] complete+0x39/0x43
[    2.062092]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    2.062431]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.063095]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.063432]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.064099]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.064437]  [<c1071201>] kthread+0x72/0x77
[    2.064710]  [<c107118f>] ? kthread+0x0/0x77
[    2.065087]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.066239] BUG: scheduling while atomic: swapper/1/0x00000001
[    2.066582] no locks held by swapper/1.
[    2.066800] Modules linked in:
[    2.067118] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    2.067441] Call Trace:
[    2.067645]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.068076]  [<c13153d2>] schedule+0x77/0x624
[    2.068408]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.068762]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    2.069080]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.070080]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.070412]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.071076]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    2.071469]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.071780]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    2.072081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    2.072371]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    2.073078]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    2.073423]  [<c1001168>] do_one_initcall+0x76/0x121
[    2.073725]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    2.074129]  [<c14fc387>] kernel_init+0x126/0x1a7
[    2.074410]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    2.074732]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.075110] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    2.075459] no locks held by kworker/u:0/5.
[    2.076052] Modules linked in:
[    2.076248] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    2.076638] Call Trace:
[    2.077085]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.077509]  [<c13153d2>] schedule+0x77/0x624
[    2.078085]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    2.078403]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.079129]  [<c1071201>] kthread+0x72/0x77
[    2.080082]  [<c107118f>] ? kthread+0x0/0x77
[    2.081078]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.083079] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    2.084068] 2 locks held by kworker/u:1/11:
[    2.085055]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.086694]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.089065] Modules linked in:
[    2.090173] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.090627] Call Trace:
[    2.091112]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.092147]  [<c13153d2>] schedule+0x77/0x624
[    2.093086]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.093408]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.094069]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.094466]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.095078]  [<c1059570>] do_fork+0x26f/0x2db
[    2.095401]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.095713]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.096146]  [<c1030969>] kernel_thread+0x7e/0x86
[    2.096441]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.097082]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    2.097456]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    2.097785]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.098078]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.100086]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.100450]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.100756]  [<c1071201>] kthread+0x72/0x77
[    2.101146]  [<c107118f>] ? kthread+0x0/0x77
[    2.101428]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.102701] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    2.103138] 2 locks held by kworker/u:1/11:
[    2.103375]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.104177]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.104726] Modules linked in:
[    2.105133] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.106141] Call Trace:
[    2.106340]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.107092]  [<c13153d2>] schedule+0x77/0x624
[    2.107431]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    2.107737]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    2.108094]  [<c104efc1>] complete+0x39/0x43
[    2.108376]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    2.109098]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.109457]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.109792]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.110089]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.110390]  [<c1071201>] kthread+0x72/0x77
[    2.111078]  [<c107118f>] ? kthread+0x0/0x77
[    2.111398]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.112560] BUG: scheduling while atomic: swapper/1/0x00000001
[    2.113058] no locks held by swapper/1.
[    2.113273] Modules linked in:
[    2.113490] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    2.114121] Call Trace:
[    2.114304]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.114600]  [<c13153d2>] schedule+0x77/0x624
[    2.115082]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.115442]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    2.115780]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.116077]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.116408]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.117094]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    2.117483]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.117805]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    2.118096]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    2.118396]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    2.119077]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    2.119491]  [<c1001168>] do_one_initcall+0x76/0x121
[    2.119794]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    2.120081]  [<c14fc387>] kernel_init+0x126/0x1a7
[    2.120374]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    2.121076]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.121540] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    2.121959] no locks held by kworker/u:0/5.
[    2.122053] Modules linked in:
[    2.122267] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    2.123051] Call Trace:
[    2.123278]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.123572]  [<c13153d2>] schedule+0x77/0x624
[    2.124080]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    2.124428]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.124723]  [<c1071201>] kthread+0x72/0x77
[    2.125079]  [<c107118f>] ? kthread+0x0/0x77
[    2.125401]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.125999] BUG: scheduling while atomic: kworker/u:1/11/0x00000001
[    2.126063] 2 locks held by kworker/u:1/11:
[    2.127120]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.127632]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.128435] Modules linked in:
[    2.128658] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.129057] Call Trace:
[    2.129233]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.129529]  [<c13153d2>] schedule+0x77/0x624
[    2.130139]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.130453]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.131067]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.131516]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.131895]  [<c1059570>] do_fork+0x26f/0x2db
[    2.132138]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.132446]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.133085]  [<c1030969>] kernel_thread+0x7e/0x86
[    2.133423]  [<c106b261>] ? ____call_usermodehelper+0x0/0x7b
[    2.133767]  [<c102b538>] ? kernel_thread_helper+0x0/0x10
[    2.134081]  [<c106b55b>] __call_usermodehelper+0x38/0x64
[    2.134412]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.135081]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.135461]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.135760]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.136077]  [<c1071201>] kthread+0x72/0x77
[    2.136360]  [<c107118f>] ? kthread+0x0/0x77
[    2.136687]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.138131] BUG: scheduling while atomic: kworker/u:1/11/0x10000001
[    2.138553] 2 locks held by kworker/u:1/11:
[    2.138818]  #0:  (khelper){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.139152]  #1:  ((&sub_info->work)){......}, at: [<c106cacb>] process_one_work+0x183/0x334
[    2.140385] Modules linked in:
[    2.140589] Pid: 11, comm: kworker/u:1 Not tainted 2.6.36+ #60
[    2.141075] Call Trace:
[    2.141306]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.141603]  [<c13153d2>] schedule+0x77/0x624
[    2.141873]  [<c1315b7b>] preempt_schedule+0x2e/0x47
[    2.142092]  [<c1317588>] _raw_spin_unlock_irqrestore+0x45/0x49
[    2.142446]  [<c104efc1>] complete+0x39/0x43
[    2.143162]  [<c106b583>] __call_usermodehelper+0x60/0x64
[    2.143482]  [<c106cb47>] process_one_work+0x1ff/0x334
[    2.143858]  [<c106b523>] ? __call_usermodehelper+0x0/0x64
[    2.144100]  [<c106e4a6>] worker_thread+0xfc/0x203
[    2.144400]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.145146]  [<c1071201>] kthread+0x72/0x77
[    2.145403]  [<c107118f>] ? kthread+0x0/0x77
[    2.145694]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.146413] BUG: scheduling while atomic: swapper/1/0x00000001
[    2.147058] no locks held by swapper/1.
[    2.147276] Modules linked in:
[    2.147487] Pid: 1, comm: swapper Not tainted 2.6.36+ #60
[    2.148115] Call Trace:
[    2.148307]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.148595]  [<c13153d2>] schedule+0x77/0x624
[    2.149083]  [<c1315be4>] schedule_timeout+0x27/0xb8
[    2.149449]  [<c10807dd>] ? lock_release_holdtime+0xd8/0xdd
[    2.149809]  [<c13151c2>] wait_for_common+0xa0/0xef
[    2.150077]  [<c1056a08>] ? default_wake_function+0x0/0x12
[    2.150409]  [<c13152b0>] wait_for_completion+0x17/0x19
[    2.151135]  [<c106b4ce>] call_usermodehelper_exec+0xa1/0xf6
[    2.151479]  [<c1315153>] ? wait_for_common+0x31/0xef
[    2.151871]  [<c11b05a5>] kobject_uevent_env+0x36b/0x3a5
[    2.152081]  [<c11b05e9>] kobject_uevent+0xa/0xc
[    2.152433]  [<c150de9c>] param_sysfs_init+0x19f/0x1d0
[    2.152758]  [<c1314af1>] ? register_cpu+0x2d/0x64
[    2.153079]  [<c1001168>] do_one_initcall+0x76/0x121
[    2.153384]  [<c150dcfd>] ? param_sysfs_init+0x0/0x1d0
[    2.154076]  [<c14fc387>] kernel_init+0x126/0x1a7
[    2.154410]  [<c14fc261>] ? kernel_init+0x0/0x1a7
[    2.154702]  [<c102b53e>] kernel_thread_helper+0x6/0x10
[    2.155172] BUG: scheduling while atomic: kworker/u:0/5/0x00000001
[    2.155525] no locks held by kworker/u:0/5.
[    2.155755] Modules linked in:
[    2.156152] Pid: 5, comm: kworker/u:0 Not tainted 2.6.36+ #60
[    2.156499] Call Trace:
[    2.157067]  [<c1052b1b>] __schedule_bug+0x5b/0x62
[    2.157410]  [<c13153d2>] schedule+0x77/0x624
[    2.157683]  [<c106e5a8>] worker_thread+0x1fe/0x203
[    2.158076]  [<c106e3aa>] ? worker_thread+0x0/0x203
[    2.158418]  [<c1071201>
--Q68bSM7Ycu6FN28Q--
