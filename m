Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727Ab2HYGbB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 02:31:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:2798 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732Ab2HYGat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 02:30:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,309,1344236400"; 
   d="scan'208";a="211205971"
Date: Sat, 25 Aug 2012 14:30:39 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org
Subject: test_power_init BUG: unable to handle kernel paging request at
 853a92a8
Message-ID: <20120825063039.GA20566@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
User-Agent: Heirloom mailx 12.5 6/20/10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Greetings,

This is an aged bug and happens also in 3.4:

[   28.015694] bus: 'platform': add driver wm831x-backup
[   28.015762] device: 'test_ac': device_add
[   28.015896] BUG: unable to handle kernel paging request at 853a92a8
[   28.015936] IP: [<817735c1>] strcmp+0x1c/0x3e
[   28.015943] *pde = 0530f067 *pte = 053a9160 
[   28.015952] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   28.015965] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc3-04525-ge838580 #605  
[   28.015968] EIP: 0060:[<817735c1>] EFLAGS: 00010246 CPU: 0
[   28.015972] EIP is at strcmp+0x1c/0x3e
[   28.015975] EAX: 853a92a8 EBX: 86bf0420 ECX: 8111a623 EDX: 860ff8f0
[   28.015979] ESI: 853a92a8 EDI: 860ff8f0 EBP: 8b43bf50 ESP: 8b43bf48
[   28.015982]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   28.015986] CR0: 8005003b CR2: 853a92a8 CR3: 043e4000 CR4: 00000690
[   28.015996] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   28.016000] DR6: ffff0ff0 DR7: 00000400
[   28.016007] Process swapper/0 (pid: 1, ti=8b43a000 task=8b440000 task.ti=8b43a000)
[   28.016009] Stack:
[   28.016025]  869a1de0 83c75a1c 8b43bf64 8260c2ee 86bf0420 860ff8f0 83c75a1c 8b43bf7c
[   28.016040]  8260c7a3 00000000 83c759a4 00000001 00000000 8b43bf8c 825bba00 83c759a4
[   28.016055]  85344400 8b43bfa0 825bb2ad 00000000 84224a0f 83c759a4 8b43bfb4 84224a48
[   28.016057] Call Trace:
[   28.016084]  [<8260c2ee>] led_trigger_register+0x70/0x242
[   28.016092]  [<8260c7a3>] led_trigger_register_simple+0x5a/0x10b
[   28.016102]  [<825bba00>] power_supply_create_triggers+0x31e/0x34a
[   28.016108]  [<825bb2ad>] power_supply_register+0x2a2/0x351
[   28.016187]  [<84224a0f>] ? wm831x_backup_driver_init+0x2b/0x2b
[   28.016196]  [<84224a48>] test_power_init+0x39/0xee
[   28.016202]  [<84224a0f>] ? wm831x_backup_driver_init+0x2b/0x2b
[   28.016216]  [<8419c998>] do_one_initcall+0xf7/0x305
[   28.016222]  [<8419cf33>] kernel_init+0x38d/0x52e
[   28.016229]  [<8419cba6>] ? do_one_initcall+0x305/0x305
[   28.016248]  [<82cc3c82>] kernel_thread_helper+0x6/0x10
[   28.016345] Code: 89 d8 83 15 84 b6 bf 84 00 5e 5b 5e 5f 5d c3 55 89 e5 57 56 e8 dd 06 55 01 83 05 88 b6 bf 84 01 83 15 8c b6 bf 84 00 89 c6 89 d7 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 83 05 90 b6 bf
[   28.016352] EIP: [<817735c1>] strcmp+0x1c/0x3e SS:ESP 0068:8b43bf48
[   28.016355] CR2: 00000000853a92a8

source line for led_trigger_register+0x70/0x242 is:

        156 int led_trigger_register(struct led_trigger *trigger)
        157 {   
        158         struct led_classdev *led_cdev;
        159         struct led_trigger *trig;
        160 
        161         rwlock_init(&trigger->leddev_list_lock);
        162         INIT_LIST_HEAD(&trigger->led_cdevs);
        163 
        164         down_write(&triggers_list_lock);
        165         /* Make sure the trigger's name isn't already in use */
        166         list_for_each_entry(trig, &trigger_list, next_trig) {
>       167                 if (!strcmp(trig->name, trigger->name)) {
        168                         up_write(&triggers_list_lock);
        169                         return -EEXIST;
        170                 }
        171         }

The bisected first bad commit seems to be an innocent one..

commit 32efe08d77f5902ce7315fc9003c010ffffb8268
Merge: da19431 b01543d
Author:     David S. Miller <davem@davemloft.net>
AuthorDate: Sun Feb 19 16:03:15 2012 -0500
Commit:     David S. Miller <davem@davemloft.net>
CommitDate: Sun Feb 19 16:03:15 2012 -0500

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
    
    Conflicts:
        drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
    
    Small minor conflict in bnx2x, wherein one commit changed how
    statistics were stored in software, and another commit
    fixed endianness bugs wrt. reading the values provided by
    the chip in memory.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

Thanks,
Fengguang

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg-kvm-fat-3563-2012-08-23-14-38-44-3.6.0-rc3-04525-ge838580-605"
Content-Transfer-Encoding: quoted-printable

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.6.0-rc3-04525-ge838580 (kbuild@bee) (gcc ver=
sion 4.7.1 (Debian 4.7.1-6) ) #605 SMP PREEMPT Thu Aug 23 14:35:55 CST 2012
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000] CPU: vendor_id 'GenuineIntel' unknown, using generic init.
[    0.000000] CPU: Your system may be unstable.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000093bff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000093c00-0x000000000009ffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000000fffdfff] usable
[    0.000000] BIOS-e820: [mem 0x000000000fffe000-0x000000000fffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reser=
ved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reser=
ved
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: n=
on-PAE kernel!
[    0.000000] Hypervisor detected: KVM
[    0.000000] e820: update [mem 0x00000000-0x0000ffff] usable =3D=3D> rese=
rved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn =3D 0xfffe max_arch_pfn =3D 0x100000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000fdab0-0x000fdabf] mapped at =
[800fdab0]
[    0.000000]   mpc: fdac0-fdbe4
[    0.000000] initial memory mapped: [mem 0x00000000-0x057fffff]
[    0.000000] Base memory trampoline at [8008f000] 8f000 size 16384
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffdfff]
[    0.000000]  [mem 0x00000000-0x0fffdfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffdfff @ [mem 0x057bd0=
00-0x057fffff]
[    0.000000] cma: dma_contiguous_reserve(limit 00000000)
[    0.000000] cma: dma_contiguous_reserve: reserving 25 MiB for global area
[    0.000000] cma: dma_declare_contiguous(size 198c000, base 00000000, lim=
it 00000000)
[    0.000000] cma: CMA: reserved 32 MiB at 0c000000
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128584(98%)
[    0.000000] RAMDISK: [mem 0x0e73f000-0x0ffeffff]
[    0.000000] ACPI: RSDP 000fd920 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0fffe550 00038 (v01 BOCHS  BXPCRSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: FACP 0fffff80 00074 (v01 BOCHS  BXPCFACP 00000001 BXPC=
 00000001)
[    0.000000] ACPI: DSDT 0fffe590 01121 (v01   BXPC   BXDSDT 00000001 INTL=
 20100528)
[    0.000000] ACPI: FACS 0fffff40 00040
[    0.000000] ACPI: SSDT 0ffffe40 000FF (v01 BOCHS  BXPCSSDT 00000001 BXPC=
 00000001)
[    0.000000] ACPI: APIC 0ffffd50 00080 (v01 BOCHS  BXPCAPIC 00000001 BXPC=
 00000001)
[    0.000000] ACPI: HPET 0ffffd10 00038 (v01 BOCHS  BXPCHPET 00000001 BXPC=
 00000001)
[    0.000000] ACPI: SSDT 0ffff6c0 00644 (v01   BXPC BXSSDTPC 00000001 INTL=
 20100528)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] 0MB HIGHMEM available.
[    0.000000] 255MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 0fffe000
[    0.000000]   low ram: 0 - 0fffe000
[    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
[    0.000000] kvm-clock: cpu 0, msr 0:43db781, boot clock
[    0.000000] Zone ranges:
[    0.000000]   Normal   [mem 0x00010000-0x0fffdfff]
[    0.000000]   HighMem  empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x00092fff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffdfff]
[    0.000000] On node 0 totalpages: 65409
[    0.000000] free_area_init_node: node 0, pgdat 83d44600, node_mem_map 8e=
4bf280
[    0.000000]   Normal zone: 640 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000]   Normal zone: 64769 pages, LIFO batch:15
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] mapped APIC to         ffffb000 (        fee00000)
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-=
23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC =
INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 05, APIC ID 2, APIC =
INT 05
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC =
INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0a, APIC ID 2, APIC =
INT 0a
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 0b, APIC ID 2, APIC =
INT 0b
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC =
INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC =
INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC =
INT 04
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC =
INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC =
INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC =
INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC =
INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC =
INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0e, APIC ID 2, APIC =
INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0f, APIC ID 2, APIC =
INT 0f
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfeffbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:2 nr_cpu_ids:2 nr_no=
de_ids:1
[    0.000000] PERCPU: Embedded 331 pages/cpu @8e229000 s1343208 r0 d12568 =
u1355776
[    0.000000] pcpu-alloc: s1343208 r0 d12568 u1355776 alloc=3D331*4096
[    0.000000] pcpu-alloc: [0] 0 [0] 1=20
[    0.000000] kvm-clock: cpu 0, msr 0:e370781, primary cpu clock
[    0.000000] KVM setup async PF for cpu 0
[    0.000000] kvm-stealtime: cpu 0, msr e22b740
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Tota=
l pages: 64769
[    0.000000] Kernel command line: trinity=3D2m hung_task_panic=3D1 branch=
=3Dnext/akpm log_buf_len=3D8M ignore_loglevel debug sched_debug apic=3Ddebu=
g dynamic_printk sysrq_always_enabled panic=3D10  prompt_ramdisk=3D0 consol=
e=3DttyS0,115200 console=3Dtty0 vga=3Dnormal  root=3D/dev/ram0 rw link=3Dvm=
linuz-2012-08-23-14-37-15-next:akpm:9115c05-e838580-i386-randconfig-b860-1-=
fat BOOT_IMAGE=3Dkernel-tests/kernels/i386-randconfig-b860/e838580/vmlinuz-=
3.6.0-rc3-04525-ge838580
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 0, 4096 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 5, 131072 byt=
es)
[    0.000000] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Initializing CPU#0
[    0.000000] Initializing HighMem for node 0 (00000000:00000000)
[    0.000000] Memory: 121104k/262136k available (29457k kernel code, 14053=
2k reserved, 21323k data, 2308k init, 0k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xffe6e000 - 0xfffff000   (1604 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0x907fe000 - 0xff7fe000   (1776 MB)
[    0.000000]     lowmem  : 0x80000000 - 0x8fffe000   ( 255 MB)
[    0.000000]       .init : 0x8419b000 - 0x843dc000   (2308 kB)
[    0.000000]       .data : 0x82cc4658 - 0x841975c0   (21323 kB)
[    0.000000]       .text : 0x81000000 - 0x82cc4658   (29457 kB)
[    0.000000] Checking if this processor honours the WP bit even in superv=
isor mode...Ok.
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjects=
=3D0, CPUs=3D2, Nodes=3D1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]=20
[    0.000000]=20
[    0.000000]=20
[    0.000000] NR_IRQS:2304 nr_irqs:512 16
[    0.000000] CPU 0 irqstacks, hard=3D8b404000 soft=3D8b406000
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc.,=
 Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 3823 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] ------------------------
[    0.000000] | Locking API testsuite:
[    0.000000] ------------------------------------------------------------=
----------------
[    0.000000]                                  | spin |wlock |rlock |mutex=
 | wsem | rsem |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]                      A-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  A-B-B-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-B-C-C-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]              A-B-C-A-B-C deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-B-C-C-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-D-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]          A-B-C-D-B-C-D-A deadlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                     double unlock:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                   initialize held:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]                  bad unlock order:  ok  |  ok  |  ok  |  ok =
 |  ok  |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]               recursive read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]            recursive read-lock #2:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed read-write-lock:             |  ok  |     =
        |  ok  |
[    0.000000]             mixed write-read-lock:             |  ok  |     =
        |  ok  |
[    0.000000]   ----------------------------------------------------------=
----------------
[    0.000000]      hard-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/12:  ok  |  ok  |  ok  |
[    0.000000]      hard-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]      soft-irqs-on + irq-safe-A/21:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/12:  ok  |  ok  |  ok  |
[    0.000000]        sirq-safe-A =3D> hirqs-on/21:  ok  |  ok  |  ok  |
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
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3200.098 MHz processor
[    0.000000] tsc: Marking TSC unstable due to TSCs unsynchronized
[    0.004000] Calibrating delay loop (skipped) preset value.. 6400.19 Bogo=
MIPS (lpj=3D12800392)
[    0.004000] pid_max: default: 4096 minimum: 301
[    0.004000] Mount-cache hash table entries: 512
[    0.006344] Initializing cgroup subsys debug
[    0.006885] Initializing cgroup subsys cpuacct
[    0.007493] Initializing cgroup subsys freezer
[    0.008032] Initializing cgroup subsys net_prio
[    0.008852] mce: CPU supports 10 MCE banks
[    0.009320] mce: unknown CPU type - not enabling MCE support
[    0.009964] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009964] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.009964] tlb_flushall_shift: -1
[    0.016691] debug: unmapping init [mem 0x843dc000-0x843e0fff]
[    0.017398] ACPI: Core revision 20120711
[    0.033722] Getting VERSION: 50014
[    0.034107] Getting VERSION: 50014
[    0.034489] Getting ID: 0
[    0.034789] Getting ID: f000000
[    0.035136] Getting LVT0: 8700
[    0.035477] Getting LVT1: 8400
[    0.035816] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.036116] enabled ExtINT on CPU#0
[    0.037734] ENABLING IO-APIC IRQs
[    0.038128] init IO_APIC IRQs
[    0.038466]  apic 2 pin 0 not connected
[    0.038966] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:1)
[    0.040064] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Ac=
tive:0 Dest:1)
[    0.040988] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Ac=
tive:0 Dest:1)
[    0.041906] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:1)
[    0.042832] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:1 Ac=
tive:0 Dest:1)
[    0.044073] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:1)
[    0.048055] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:1)
[    0.048929] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:1)
[    0.049797] IOAPIC[0]: Set routing entry (2-9 -> 0x39 -> IRQ 9 Mode:1 Ac=
tive:0 Dest:1)
[    0.050664] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:1)
[    0.051549] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:1)
[    0.052066] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:1)
[    0.053002] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 =
Active:0 Dest:1)
[    0.053948] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 =
Active:0 Dest:1)
[    0.054898] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 =
Active:0 Dest:1)
[    0.056049]  apic 2 pin 16 not connected
[    0.056473]  apic 2 pin 17 not connected
[    0.056897]  apic 2 pin 18 not connected
[    0.057318]  apic 2 pin 19 not connected
[    0.057749]  apic 2 pin 20 not connected
[    0.058168]  apic 2 pin 21 not connected
[    0.058580]  apic 2 pin 22 not connected
[    0.059011]  apic 2 pin 23 not connected
[    0.060174] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D=
-1
[    0.060803] smpboot: CPU0: GenuineIntel Common KVM processor stepping 01
[    0.061563] Using local APIC timer interrupts.
[    0.061563] calibrating APIC timer ...
[    0.064004] ... lapic delta =3D 8487515
[    0.064004] ... PM-Timer delta =3D 486101
[    0.064004] APIC calibration not consistent with PM-Timer: 135ms instead=
 of 100ms
[    0.064004] APIC delta adjusted to PM-Timer: 6250017 (8487515)
[    0.064004] TSC delta adjusted to PM-Timer: 320009329 (434572194)
[    0.064004] ..... delta 6250017
[    0.064004] ..... mult: 268419409
[    0.064004] ..... calibration result: 4000010
[    0.064004] ..... CPU clock speed is 3200.0373 MHz.
[    0.064004] ..... host bus clock speed is 1000.0010 MHz.
[    0.064115] Performance Events:=20
[    0.077464] Testing tracer nop: PASSED
[    0.079839] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.084740] SMP alternatives: lockdep: fixing up alternatives
[    0.085797] CPU 1 irqstacks, hard=3D8b48e000 soft=3D8b498000
[    0.086996] smpboot: Booting Node   0, Processors  #1 OK
[    0.004000] Initializing CPU#1
[    0.004000] kvm-clock: cpu 1, msr 0:e4bb781, secondary cpu clock
[    0.004000] masked ExtINT on CPU#1
[    0.120554] Brought up 2 CPUs
[    0.120595] ----------------
[    0.120965] | NMI testsuite:
[    0.121361] --------------------
[    0.124025]   remote IPI:[    0.132036] KVM setup async PF for cpu 1
[    0.132559] kvm-stealtime: cpu 1, msr e376740
  ok  |
[    0.156284]    local IPI:  ok  |
[    0.204088] --------------------
[    0.204550] Good, all   2 testcases passed! |
[    0.205156] ---------------------------------
[    0.205726] smpboot: Total of 2 processors activated (12800.39 BogoMIPS)
[    0.207207] CPU0 attaching sched-domain:
[    0.207735]  domain 0: span 0-1 level CPU
[    0.208268]   groups: 0 (cpu_power =3D 1023) 1
[    0.209395] CPU1 attaching sched-domain:
[    0.209899]  domain 0: span 0-1 level CPU
[    0.210433]   groups: 1 0 (cpu_power =3D 1023)
[    0.216881] devtmpfs: initialized
[    0.216881] device: 'platform': device_add
[    0.217210] bus: 'platform': registered
[    0.217720] bus: 'cpu': registered
[    0.218164] device: 'cpu': device_add
[    0.232605] atomic64 test passed for i586+ platform with CX8 and with SSE
[    0.233573] bus: 'virtio': registered
[    0.234045] cma: cma_init_reserved_areas()
[    0.234679] cma: cma_create_area(base 0000c000, count 2000)
[    0.237968] cma: cma_create_area: returned 8fff6440
[    0.239327] NET: Registered protocol family 16
[    0.241590] device class 'bdi': registering
[    0.242687] device class 'pci_bus': registering
[    0.243370] bus: 'pci': registered
[    0.243832] device: 'rapidio': device_add
[    0.244063] bus: 'rapidio': registered
[    0.244546] device class 'lcd': registering
[    0.245178] device class 'backlight': registering
[    0.245785] device class 'video_output': registering
[    0.246431] device class 'tty': registering
[    0.247063] bus: 'hsi': registered
[    0.247532] bus: 'i2c': registered
[    0.248036] bus: 'i2c': add driver dummy
[    0.314228] ACPI: bus type pci registered
[    0.314770] device class 'dma': registering
[    0.321090] PCI: PCI BIOS revision 2.10 entry at 0xfc78c, last bus=3D0
[    0.324049] PCI: Using configuration type 1 for base access
[    0.326429] device: 'cpu0': device_add
[    0.326910] bus: 'cpu': add device cpu0
[    0.328047] device: 'cpu1': device_add
[    0.328541] bus: 'cpu': add device cpu1
[    0.329161] device: 'default': device_add
[    0.330409] bio: create slab <bio-0> at 0
[    0.331122] device class 'block': registering
[    0.332492] bus: 'i2c': add driver max732x
[    0.333067] bus: 'i2c': add driver mcp230xx
[    0.336101] bus: 'platform': add driver rc5t583-gpio
[    0.336780] bus: 'i2c': add driver sx150x
[    0.337330] bus: 'platform': add driver wm831x-gpio
[    0.337971] bus: 'platform': add driver wm8994-gpio
[    0.338685] device class 'graphics': registering
[    0.339298] bus: 'platform': add driver aat2870-backlight
[    0.340160] ACPI: Added _OSI(Module Device)
[    0.340720] ACPI: Added _OSI(Processor Device)
[    0.341292] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.341888] ACPI: Added _OSI(Processor Aggregator Device)
[    0.354056] ACPI: EC: Look up EC in DSDT
[    0.388381] ACPI: Interpreter enabled
[    0.388795] ACPI: (supports S0 S5)
[    0.389225] ACPI: Using IOAPIC for interrupt routing
[    0.389804] bus: 'acpi': registered
[    0.390188] bus: 'acpi': add driver power
[    0.390764] device: 'LNXSYSTM:00': device_add
[    0.391270] bus: 'acpi': add device LNXSYSTM:00
[    0.392300] device: 'device:00': device_add
[    0.396049] bus: 'acpi': add device device:00
[    0.400329] device: 'PNP0A03:00': device_add
[    0.400809] bus: 'acpi': add device PNP0A03:00
[    0.405284] device: 'device:01': device_add
[    0.405759] bus: 'acpi': add device device:01
[    0.406590] device: 'device:02': device_add
[    0.407046] bus: 'acpi': add device device:02
[    0.407778] device: 'PNP0B00:00': device_add
[    0.408044] bus: 'acpi': add device PNP0B00:00
[    0.408930] device: 'PNP0303:00': device_add
[    0.412047] bus: 'acpi': add device PNP0303:00
[    0.412899] device: 'PNP0F13:00': device_add
[    0.416044] bus: 'acpi': add device PNP0F13:00
[    0.416899] device: 'PNP0700:00': device_add
[    0.417395] bus: 'acpi': add device PNP0700:00
[    0.418476] device: 'PNP0400:00': device_add
[    0.418971] bus: 'acpi': add device PNP0400:00
[    0.420243] device: 'PNP0501:00': device_add
[    0.420729] bus: 'acpi': add device PNP0501:00
[    0.421647] device: 'device:03': device_add
[    0.422094] bus: 'acpi': add device device:03
[    0.424460] device: 'device:04': device_add
[    0.424937] bus: 'acpi': add device device:04
[    0.428347] device: 'device:05': device_add
[    0.428820] bus: 'acpi': add device device:05
[    0.429647] device: 'device:06': device_add
[    0.430144] bus: 'acpi': add device device:06
[    0.430922] device: 'device:07': device_add
[    0.431374] bus: 'acpi': add device device:07
[    0.432348] device: 'device:08': device_add
[    0.432811] bus: 'acpi': add device device:08
[    0.433634] device: 'device:09': device_add
[    0.434113] bus: 'acpi': add device device:09
[    0.434932] device: 'device:0a': device_add
[    0.435422] bus: 'acpi': add device device:0a
[    0.436389] device: 'device:0b': device_add
[    0.436901] bus: 'acpi': add device device:0b
[    0.437723] device: 'device:0c': device_add
[    0.438179] bus: 'acpi': add device device:0c
[    0.444408] device: 'device:0d': device_add
[    0.444967] bus: 'acpi': add device device:0d
[    0.448454] device: 'device:0e': device_add
[    0.449031] bus: 'acpi': add device device:0e
[    0.450046] device: 'device:0f': device_add
[    0.450628] bus: 'acpi': add device device:0f
[    0.451483] device: 'device:10': device_add
[    0.452049] bus: 'acpi': add device device:10
[    0.452906] device: 'device:11': device_add
[    0.453381] bus: 'acpi': add device device:11
[    0.454208] device: 'device:12': device_add
[    0.454674] bus: 'acpi': add device device:12
[    0.455573] device: 'device:13': device_add
[    0.456047] bus: 'acpi': add device device:13
[    0.456847] device: 'device:14': device_add
[    0.457301] bus: 'acpi': add device device:14
[    0.458070] device: 'device:15': device_add
[    0.458549] bus: 'acpi': add device device:15
[    0.464205] device: 'device:16': device_add
[    0.464800] bus: 'acpi': add device device:16
[    0.468334] device: 'device:17': device_add
[    0.468931] bus: 'acpi': add device device:17
[    0.469941] device: 'device:18': device_add
[    0.470550] bus: 'acpi': add device device:18
[    0.471590] device: 'device:19': device_add
[    0.472053] bus: 'acpi': add device device:19
[    0.473083] device: 'device:1a': device_add
[    0.473683] bus: 'acpi': add device device:1a
[    0.474704] device: 'device:1b': device_add
[    0.476029] bus: 'acpi': add device device:1b
[    0.476413] device: 'device:1c': device_add
[    0.476896] bus: 'acpi': add device device:1c
[    0.477741] device: 'device:1d': device_add
[    0.478217] bus: 'acpi': add device device:1d
[    0.480111] device: 'device:1e': device_add
[    0.480594] bus: 'acpi': add device device:1e
[    0.481437] device: 'device:1f': device_add
[    0.482005] bus: 'acpi': add device device:1f
[    0.484455] device: 'device:20': device_add
[    0.484943] bus: 'acpi': add device device:20
[    0.485782] device: 'device:21': device_add
[    0.486263] bus: 'acpi': add device device:21
[    0.487105] device: 'device:22': device_add
[    0.488051] bus: 'acpi': add device device:22
[    0.489367] device: 'PNP0103:00': device_add
[    0.489852] bus: 'acpi': add device PNP0103:00
[    0.491085] device: 'PNP0C0F:00': device_add
[    0.491580] bus: 'acpi': add device PNP0C0F:00
[    0.492648] device: 'PNP0C0F:01': device_add
[    0.493136] bus: 'acpi': add device PNP0C0F:01
[    0.494231] device: 'PNP0C0F:02': device_add
[    0.494820] bus: 'acpi': add device PNP0C0F:02
[    0.496368] device: 'PNP0C0F:03': device_add
[    0.500057] bus: 'acpi': add device PNP0C0F:03
[    0.504126] device: 'PNP0C0F:04': device_add
[    0.504621] bus: 'acpi': add device PNP0C0F:04
[    0.505541] device: 'LNXCPU:00': device_add
[    0.506013] bus: 'acpi': add device LNXCPU:00
[    0.506829] device: 'LNXCPU:01': device_add
[    0.507307] bus: 'acpi': add device LNXCPU:01
[    0.508281] device: 'device:23': device_add
[    0.508789] bus: 'acpi': add device device:23
[    0.509473] device: 'LNXPWRBN:00': device_add
[    0.509965] bus: 'acpi': add device LNXPWRBN:00
[    0.510712] bus: 'acpi': add driver ec
[    0.511327] PCI: Using host bridge windows from ACPI; if necessary, use =
"pci=3Dnocrs" and report a bug
[    0.512050] bus: 'acpi': add driver pci_root
[    0.512553] bus: 'acpi': driver_probe_device: matched device PNP0A03:00 =
with driver pci_root
[    0.513479] bus: 'acpi': really_probe: probing driver pci_root with devi=
ce PNP0A03:00
[    0.516128] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.520279] pci_root PNP0A03:00: fail to add MMCONFIG information, can't=
 access extended PCI configuration space under this bridge.
[    0.521542] device: 'pci0000:00': device_add
[    0.522097] device: '0000:00': device_add
[    0.522692] PCI host bridge to bus 0000:00
[    0.523282] pci_bus 0000:00: busn_res: [bus 00-ff] is inserted under dom=
ain [bus 00-ff]
[    0.524049] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.524868] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.528051] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.532224] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bfff=
f]
[    0.536054] pci_bus 0000:00: root bus resource [mem 0xe0000000-0xfebffff=
f]
[    0.540222] pci 0000:00:00.0: [8086:1237] type 00 class 0x060000
[    0.548417] pci 0000:00:01.0: [8086:7000] type 00 class 0x060100
[    0.550038] pci 0000:00:01.1: [8086:7010] type 00 class 0x010180
[    0.553094] pci 0000:00:01.1: reg 20: [io  0xc1c0-0xc1cf]
[    0.555452] pci 0000:00:01.3: [8086:7113] type 00 class 0x068000
[    0.556784] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by PIIX=
4 ACPI
[    0.559834] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by PIIX=
4 SMB
[    0.560575] pci 0000:00:02.0: [1013:00b8] type 00 class 0x030000
[    0.564244] pci 0000:00:02.0: reg 10: [mem 0xfc000000-0xfdffffff pref]
[    0.569112] pci 0000:00:02.0: reg 14: [mem 0xfebf4000-0xfebf4fff]
[    0.578413] pci 0000:00:02.0: reg 30: [mem 0xfebe0000-0xfebeffff pref]
[    0.580513] pci 0000:00:03.0: [8086:100e] type 00 class 0x020000
[    0.581791] pci 0000:00:03.0: reg 10: [mem 0xfeba0000-0xfebbffff]
[    0.583515] pci 0000:00:03.0: reg 14: [io  0xc000-0xc03f]
[    0.588538] pci 0000:00:03.0: reg 30: [mem 0xfebc0000-0xfebdffff pref]
[    0.590014] pci 0000:00:04.0: [8086:2668] type 00 class 0x040300
[    0.591137] pci 0000:00:04.0: reg 10: [mem 0xfebf0000-0xfebf3fff]
[    0.595792] pci 0000:00:05.0: [1af4:1001] type 00 class 0x010000
[    0.596620] pci 0000:00:05.0: reg 10: [io  0xc040-0xc07f]
[    0.598196] pci 0000:00:05.0: reg 14: [mem 0xfebf5000-0xfebf5fff]
[    0.605033] pci 0000:00:06.0: [1af4:1001] type 00 class 0x010000
[    0.606362] pci 0000:00:06.0: reg 10: [io  0xc080-0xc0bf]
[    0.608100] pci 0000:00:06.0: reg 14: [mem 0xfebf6000-0xfebf6fff]
[    0.613978] pci 0000:00:07.0: [1af4:1001] type 00 class 0x010000
[    0.615305] pci 0000:00:07.0: reg 10: [io  0xc0c0-0xc0ff]
[    0.616952] pci 0000:00:07.0: reg 14: [mem 0xfebf7000-0xfebf7fff]
[    0.623222] pci 0000:00:08.0: [1af4:1001] type 00 class 0x010000
[    0.624629] pci 0000:00:08.0: reg 10: [io  0xc100-0xc13f]
[    0.626204] pci 0000:00:08.0: reg 14: [mem 0xfebf8000-0xfebf8fff]
[    0.632583] pci 0000:00:09.0: [1af4:1001] type 00 class 0x010000
[    0.633968] pci 0000:00:09.0: reg 10: [io  0xc140-0xc17f]
[    0.635542] pci 0000:00:09.0: reg 14: [mem 0xfebf9000-0xfebf9fff]
[    0.641458] pci 0000:00:0a.0: [1af4:1001] type 00 class 0x010000
[    0.642778] pci 0000:00:0a.0: reg 10: [io  0xc180-0xc1bf]
[    0.644586] pci 0000:00:0a.0: reg 14: [mem 0xfebfa000-0xfebfafff]
[    0.650764] pci 0000:00:0b.0: [8086:25ab] type 00 class 0x088000
[    0.651824] pci 0000:00:0b.0: reg 10: [mem 0xfebfb000-0xfebfb00f]
[    0.656496] pci_bus 0000:00: on NUMA node 0
[    0.657142] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.662725]  pci0000:00: ACPI _OSC support notification failed, disablin=
g PCIe ASPM
[    0.663747]  pci0000:00: Unable to request _OSC control (_OSC support ma=
sk: 0x08)
[    0.664089] device: '0000:00:00.0': device_add
[    0.671067] bus: 'pci': add device 0000:00:00.0
[    0.671873] device: '0000:00:01.0': device_add
[    0.677985] bus: 'pci': add device 0000:00:01.0
[    0.678617] device: '0000:00:01.1': device_add
[    0.684518] bus: 'pci': add device 0000:00:01.1
[    0.685151] device: '0000:00:01.3': device_add
[    0.691088] bus: 'pci': add device 0000:00:01.3
[    0.692112] device: '0000:00:02.0': device_add
[    0.698314] bus: 'pci': add device 0000:00:02.0
[    0.698946] device: '0000:00:03.0': device_add
[    0.704108] bus: 'pci': add device 0000:00:03.0
[    0.704739] device: '0000:00:04.0': device_add
[    0.711728] bus: 'pci': add device 0000:00:04.0
[    0.712136] device: '0000:00:05.0': device_add
[    0.717574] bus: 'pci': add device 0000:00:05.0
[    0.718197] device: '0000:00:06.0': device_add
[    0.723233] bus: 'pci': add device 0000:00:06.0
[    0.723930] device: '0000:00:07.0': device_add
[    0.729042] bus: 'pci': add device 0000:00:07.0
[    0.729679] device: '0000:00:08.0': device_add
[    0.734794] bus: 'pci': add device 0000:00:08.0
[    0.735422] device: '0000:00:09.0': device_add
[    0.740513] bus: 'pci': add device 0000:00:09.0
[    0.741135] device: '0000:00:0a.0': device_add
[    0.746729] bus: 'pci': add device 0000:00:0a.0
[    0.747909] device: '0000:00:0b.0': device_add
[    0.753039] bus: 'pci': add device 0000:00:0b.0
[    0.754134] driver: 'PNP0A03:00': driver_bound: bound to device 'pci_roo=
t'
[    0.755091] bus: 'acpi': really_probe: bound device PNP0A03:00 to driver=
 pci_root
[    0.756300] bus: 'acpi': add driver pci_link
[    0.756998] bus: 'acpi': driver_probe_device: matched device PNP0C0F:00 =
with driver pci_link
[    0.758047] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:00
[    0.759388] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.760339] driver: 'PNP0C0F:00': driver_bound: bound to device 'pci_lin=
k'
[    0.761207] bus: 'acpi': really_probe: bound device PNP0C0F:00 to driver=
 pci_link
[    0.762899] bus: 'acpi': driver_probe_device: matched device PNP0C0F:01 =
with driver pci_link
[    0.764069] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:01
[    0.765258] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.766207] driver: 'PNP0C0F:01': driver_bound: bound to device 'pci_lin=
k'
[    0.767069] bus: 'acpi': really_probe: bound device PNP0C0F:01 to driver=
 pci_link
[    0.768082] bus: 'acpi': driver_probe_device: matched device PNP0C0F:02 =
with driver pci_link
[    0.769123] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:02
[    0.770297] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.771243] driver: 'PNP0C0F:02': driver_bound: bound to device 'pci_lin=
k'
[    0.772073] bus: 'acpi': really_probe: bound device PNP0C0F:02 to driver=
 pci_link
[    0.773026] bus: 'acpi': driver_probe_device: matched device PNP0C0F:03 =
with driver pci_link
[    0.774681] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:03
[    0.775896] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.776459] driver: 'PNP0C0F:03': driver_bound: bound to device 'pci_lin=
k'
[    0.777729] bus: 'acpi': really_probe: bound device PNP0C0F:03 to driver=
 pci_link
[    0.779442] bus: 'acpi': driver_probe_device: matched device PNP0C0F:04 =
with driver pci_link
[    0.780071] bus: 'acpi': really_probe: probing driver pci_link with devi=
ce PNP0C0F:04
[    0.781264] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.784135] driver: 'PNP0C0F:04': driver_bound: bound to device 'pci_lin=
k'
[    0.788078] bus: 'acpi': really_probe: bound device PNP0C0F:04 to driver=
 pci_link
[    0.789106] bus: 'pnp': registered
[    0.789615] device class 'misc': registering
[    0.790296] device: 'vga_arbiter': device_add
[    0.792421] vgaarb: device added: PCI:0000:00:02.0,decodes=3Dio+mem,owns=
=3Dio+mem,locks=3Dnone
[    0.793461] vgaarb: loaded
[    0.793821] vgaarb: bridge control possible 0000:00:02.0
[    0.796097] bus: 'i2c': add driver 88PM860x
[    0.796678] bus: 'i2c': add driver stmpe-i2c
[    0.797254] bus: 'i2c': add driver wm831x
[    0.797811] tps65010: version 2 May 2005
[    0.798317] bus: 'i2c': add driver tps65010
[    0.798960] bus: 'i2c': remove driver tps65010
[    0.799548] driver: 'tps65010': driver_release
[    0.816127] bus: 'i2c': add driver tps65010
[    0.816749] bus: 'i2c': remove driver tps65010
[    0.817327] driver: 'tps65010': driver_release
[    0.832126] bus: 'i2c': add driver tps65010
[    0.832749] bus: 'i2c': remove driver tps65010
[    0.833335] driver: 'tps65010': driver_release
[    0.833899] tps65010: no chip?
[    0.834295] bus: 'i2c': add driver tps65217
[    0.834873] bus: 'i2c': add driver mc13xxx
[    0.835428] bus: 'i2c': add driver da903x
[    0.835986] bus: 'i2c': add driver da9052
[    0.836109] bus: 'i2c': add driver max77693
[    0.836679] bus: 'i2c': add driver max8925
[    0.837243] bus: 'i2c': add driver max8997
[    0.837799] bus: 'i2c': add driver max8998
[    0.838362] bus: 'i2c': add driver aat2870
[    0.838921] bus: 'i2c': add driver palmas
[    0.840108] bus: 'i2c': add driver rc5t583
[    0.841166] device class 'scsi_host': registering
[    0.841856] bus: 'scsi': registered
[    0.842309] device class 'scsi_device': registering
[    0.843081] SCSI subsystem initialized
[    0.844091] device class 'ata_link': registering
[    0.844711] device class 'ata_port': registering
[    0.845307] device class 'ata_device': registering
[    0.846004] libata version 3.00 loaded.
[    0.846514] device class 'mdio_bus': registering
[    0.847163] bus: 'mdio_bus': registered
[    0.847667] bus: 'mdio_bus': add driver Generic PHY
[    0.848107] device class 'pcmcia_socket': registering
[    0.848796] bus: 'serio': registered
[    0.852114] bus: 'gameport': registered
[    0.852624] device class 'input': registering
[    0.853287] device class 'rtc': registering
[    0.853878] bus: 'platform': add driver i2c-gpio
[    0.854502] bus: 'platform': add driver pxa2xx-i2c
[    0.855151] device class 'power_supply': registering
[    0.855855] device class 'hwmon': registering
[    0.856097] device class 'leds': registering
[    0.856696] bus: 'acpi': add driver vmbus
[    5.856451] bus: 'acpi': remove driver vmbus
[    5.857062] driver: 'vmbus': driver_release
[    5.857603] device class 'devfreq': registering
[    5.858235] bus: 'iio': registered
[    5.858774] PCI: Using ACPI for IRQ routing
[    5.859325] PCI: pci_cache_line_size set to 64 bytes
[    5.860889] e820: reserve RAM buffer [mem 0x00093c00-0x0009ffff]
[    5.861649] e820: reserve RAM buffer [mem 0x0fffe000-0x0fffffff]
[    5.862602] device class 'net': registering
[    5.863401] device: 'lo': device_add
[    5.864666] Sangoma WANPIPE Router v1.1 (c) 1995-2000 Sangoma Technologi=
es Inc.
[    5.865659] device class 'ieee80211': registering
[    5.866765] Registering platform device 'regulatory.0'. Parent at platfo=
rm
[    5.867624] device: 'regulatory.0': device_add
[    5.868195] bus: 'platform': add device regulatory.0
[    5.873663] cfg80211: Calling CRDA to update world regulatory domain
[    5.874686] device class 'ieee802154': registering
[    5.878458] HPET: 3 timers in total, 0 timers will be used for per-cpu t=
imer
[    5.879388] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    5.880602] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    5.888607] Switching to clocksource kvm-clock
[    5.891267] Warning: could not register all branches stats
[    5.891785] Warning: could not register annotated branches stats
[    6.229113] FS-Cache: Loaded
[    6.229534] device: 'cachefiles': device_add
[    6.230618] CacheFiles: Loaded
[    6.231121] bus: 'pnp': add driver system
[    6.231659] pnp: PnP ACPI init
[    6.232155] device: 'pnp0': device_add
[    6.232648] ACPI: bus type pnp registered
[    6.233313] pnp 00:00: [bus 00-ff]
[    6.233758] pnp 00:00: [io  0x0cf8-0x0cff]
[    6.234272] pnp 00:00: [io  0x0000-0x0cf7 window]
[    6.234867] pnp 00:00: [io  0x0d00-0xffff window]
[    6.235456] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    6.236189] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    6.236886] device: '00:00': device_add
[    6.237823] bus: 'pnp': add device 00:00
[    6.238443] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    6.239401] pnp 00:01: [io  0x0070-0x0071]
[    6.239988] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Ac=
tive:0 Dest:3)
[    6.241088] pnp 00:01: [irq 8]
[    6.241490] pnp 00:01: [io  0x0072-0x0077]
[    6.242023] device: '00:01': device_add
[    6.242576] bus: 'pnp': add device 00:01
[    6.243119] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (active)
[    6.244183] pnp 00:02: [io  0x0060]
[    6.244638] pnp 00:02: [io  0x0064]
[    6.245105] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Ac=
tive:0 Dest:3)
[    6.246122] pnp 00:02: [irq 1]
[    6.246527] device: '00:02': device_add
[    6.247097] bus: 'pnp': add device 00:02
[    6.247631] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (active)
[    6.248699] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 =
Active:0 Dest:3)
[    6.249746] pnp 00:03: [irq 12]
[    6.250161] device: '00:03': device_add
[    6.250735] bus: 'pnp': add device 00:03
[    6.251273] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (active)
[    6.259364] pnp 00:04: [io  0x03f2-0x03f5]
[    6.259900] pnp 00:04: [io  0x03f7]
[    6.260463] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Ac=
tive:0 Dest:3)
[    6.261492] pnp 00:04: [irq 6]
[    6.261896] pnp 00:04: [dma 2]
[    6.262301] device: '00:04': device_add
[    6.262884] bus: 'pnp': add device 00:04
[    6.263428] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (active)
[    6.264588] pnp 00:05: [io  0x0378-0x037f]
[    6.265136] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Ac=
tive:0 Dest:3)
[    6.266151] pnp 00:05: [irq 7]
[    6.266558] device: '00:05': device_add
[    6.267149] bus: 'pnp': add device 00:05
[    6.267686] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (active)
[    6.274228] pnp 00:06: [io  0x03f8-0x03ff]
[    6.274772] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Ac=
tive:0 Dest:3)
[    6.275789] pnp 00:06: [irq 4]
[    6.276238] device: '00:06': device_add
[    6.276836] bus: 'pnp': add device 00:06
[    6.277371] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (active)
[    6.279667] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    6.280340] device: '00:07': device_add
[    6.281185] bus: 'pnp': add device 00:07
[    6.281767] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
[    6.283477] pnp: PnP ACPI: found 8 devices
[    6.284104] ACPI: ACPI bus type pnp unregistered
[    6.284729] bus: 'pci': add driver Intel MID DMA
[    6.285576] device class 'mem': registering
[    6.286170] device: 'mem': device_add
[    6.295890] device: 'null': device_add
[    6.299815] device: 'port': device_add
[    6.300659] device: 'zero': device_add
[    6.301379] device: 'full': device_add
[    6.302052] device: 'random': device_add
[    6.302733] device: 'urandom': device_add
[    6.303397] device: 'kmsg': device_add
[    6.304121] device: 'oldmem': device_add
[    6.304812] device: 'tty': device_add
[    6.308842] device: 'console': device_add
[    6.309530] device class 'firmware': registering
[    6.310082] bus: 'pcmcia': registered
[    6.310539] device class 'thermal': registering
[    6.345821] bus: 'ssb': registered
[    6.346331] bus: 'pci': add driver b43-pci-bridge
[    6.347053] bus: 'bcma': registered
[    6.347698] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    6.348451] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    6.349157] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    6.349937] pci_bus 0000:00: resource 7 [mem 0xe0000000-0xfebfffff]
[    6.350967] NET: Registered protocol family 2
[    6.354496] TCP established hash table entries: 8192 (order: 4, 65536 by=
tes)
[    6.355527] TCP bind hash table entries: 8192 (order: 6, 360448 bytes)
[    6.357646] TCP: Hash tables configured (established 8192 bind 8192)
[    6.358410] TCP: reno registered
[    6.358790] UDP hash table entries: 128 (order: 1, 12288 bytes)
[    6.359468] UDP-Lite hash table entries: 128 (order: 1, 12288 bytes)
[    6.360649] NET: Registered protocol family 1
[    6.365320] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    6.366321] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    6.367129] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    6.368008] pci 0000:00:02.0: Boot video device
[    6.368946] PCI: CLS 0 bytes, default 64
[    6.370560] Unpacking initramfs...
[   12.178145] debug: unmapping init [mem 0x8e73f000-0x8ffeffff]
[   12.227816] DMA-API: preallocated 32768 debug entries
[   12.228525] DMA-API: debugging enabled by kernel config
[   12.231111] Machine check injector initialized
[   12.231722] device class 'msr': registering
[   12.232336] device: 'msr0': device_add
[   12.233462] device: 'msr1': device_add
[   12.234394] device class 'cpuid': registering
[   12.234981] device: 'cpu0': device_add
[   12.235735] device: 'cpu1': device_add
[   12.236618] microcode: no support for this CPU vendor
[   12.261596] cryptomgr_test (30) used greatest stack depth: 7096 bytes le=
ft
[   12.263478] cryptomgr_test (31) used greatest stack depth: 6920 bytes le=
ft
[   12.264555] NatSemi SCx200 Driver
[   12.265000] bus: 'pci': add driver scx200
[   12.265854] bus: 'platform': add driver alarmtimer
[   12.266497] Registering platform device 'alarmtimer'. Parent at platform
[   12.267337] device: 'alarmtimer': device_add
[   12.267887] bus: 'platform': add device alarmtimer
[   12.276288] bus: 'platform': driver_probe_device: matched device alarmti=
mer with driver alarmtimer
[   12.277406] bus: 'platform': really_probe: probing driver alarmtimer wit=
h device alarmtimer
[   12.278433] driver: 'alarmtimer': driver_bound: bound to device 'alarmti=
mer'
[   12.279319] bus: 'platform': really_probe: bound device alarmtimer to dr=
iver alarmtimer
[   12.280584] audit: initializing netlink socket (disabled)
[   12.281403] type=3D2000 audit(1345703905.264:1): initialized
[   12.282346] rcu-torture:--- Start of test: nreaders=3D4 nfakewriters=3D4=
 stat_interval=3D60 verbose=3D0 test_no_idle_hz=3D1 shuffle_interval=3D3 st=
utter=3D5 irqreader=3D1 fqs_duration=3D0 fqs_holdoff=3D0 fqs_stutter=3D3 te=
st_boost=3D1/1 test_boost_interval=3D7 test_boost_duration=3D4 shutdown_sec=
s=3D0 onoff_interval=3D0 onoff_holdoff=3D0
[   12.405249] Testing tracer function: PASSED
[   12.623628] Testing ftrace regs(no arch support): PASSED
[   12.784355] Testing tracer preemptoff: PASSED
[   13.104314] Testing tracer wakeup: PASSED
[   13.613926] Testing tracer wakeup_rt: PASSED
[   14.375730] bus: 'event_source': registered
[   14.376312] device: 'breakpoint': device_add
[   14.376871] bus: 'event_source': add device breakpoint
[   14.377645] device: 'tracepoint': device_add
[   14.378190] bus: 'event_source': add device tracepoint
[   14.378858] device: 'software': device_add
[   14.379374] bus: 'event_source': add device software
[   14.405408] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[   14.408522] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[   14.411153] QNX6 filesystem 1.0.0 registered.
[   14.411731] device: 'autofs': device_add
[   14.412929] JFS: nTxBlock =3D 1202, nTxLock =3D 9617
[   14.429852] SGI XFS with ACLs, security attributes, realtime, debug enab=
led
[   14.434417] 9p: Installing v9fs 9p2000 file system support
[   14.435229] FS-Cache: Netfs '9p' registered for caching
[   14.435905] BeFS version: 0.9.3
[   14.436702] ceph: loaded (mds proto 32)
[   14.437227] msgmni has been set to 300
[   14.455213] alg: No test for cipher_null (cipher_null-generic)
[   14.456798] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   14.474734] alg: No test for compress_null (compress_null-generic)
[   14.476365] alg: No test for digest_null (digest_null-generic)
[   14.480869] cryptomgr_test (67) used greatest stack depth: 6808 bytes le=
ft
[   14.495362] cryptomgr_test (68) used greatest stack depth: 6748 bytes le=
ft
[   14.497325] cryptomgr_test (69) used greatest stack depth: 6556 bytes le=
ft
[   14.521921] cryptomgr_test (70) used greatest stack depth: 6460 bytes le=
ft
[   14.571185] alg: No test for stdrng (krng)
[   14.571849] NET: Registered protocol family 38
[   14.572828] device class 'bsg': registering
[   14.573388] Block layer SCSI generic (bsg) driver version 0.4 loaded (ma=
jor 252)
[   14.574291] io scheduler noop registered
[   14.574775] io scheduler deadline registered (default)
[   14.575437] io scheduler cfq registered
[   14.576533] bus: 'pci': add driver langwell_gpio
[   14.577309] bus: 'platform': add driver wp_gpio
[   14.577945] bus: 'pci': add driver ml_ioh_gpio
[   14.578680] bus: 'platform': add driver rdc321x-gpio
[   14.579940] bus: 'i2c': add driver lp855x
[   14.580687] bus: 'platform': add driver cr_backlight
[   14.581351] Registering platform device 'cr_backlight'. Parent at platfo=
rm
[   14.582192] device: 'cr_backlight': device_add
[   14.582748] bus: 'platform': add device cr_backlight
[   14.583410] bus: 'platform': driver_probe_device: matched device cr_back=
light with driver cr_backlight
[   14.584538] bus: 'platform': really_probe: probing driver cr_backlight w=
ith device cr_backlight
[   14.585580] cr_bllcd: INTEL CARILLO RANCH LPC not found.
[   14.586255] cr_backlight: probe of cr_backlight rejects match -19
[   14.586980] cr_bllcd: Carillo Ranch Backlight Driver Initialized.
[   14.587689] bus: 'platform': add driver da903x-backlight
[   14.588681] bus: 'platform': add driver max8925-backlight
[   14.589349] bus: 'platform': add driver adp5520-backlight
[   14.590009] bus: 'i2c': add driver adp8860_bl
[   14.590542] i2c-core: driver [adp8860_bl] using legacy suspend method
[   14.591321] i2c-core: driver [adp8860_bl] using legacy resume method
[   14.593601] bus: 'i2c': add driver adp8870_bl
[   14.594196] i2c-core: driver [adp8870_bl] using legacy suspend method
[   14.594981] i2c-core: driver [adp8870_bl] using legacy resume method
[   14.595782] bus: 'platform': add driver 88pm860x-backlight
[   14.596804] bus: 'pci': add driver pm2fb
[   14.597596] rivafb_setup START
[   14.598007] bus: 'pci': add driver rivafb
[   14.598704] nvidiafb_setup START
[   14.599129] bus: 'pci': add driver nvidiafb
[   14.599853] bus: 'pci': add driver aty128fb
[   14.600960] bus: 'pci': add driver gx1fb
[   14.601653] bus: 'pci': add driver gxfb
[   14.602303] bus: 'pci': add driver neofb
[   14.602947] vmlfb: initializing
[   14.603337] bus: 'pci': add driver vmlfb
[   14.603891] bus: 'pci': add driver s3fb
[   14.604503] bus: 'platform': add driver hgafb
[   14.605052] Registering platform device 'hgafb.0'. Parent at platform
[   14.605804] device: 'hgafb.0': device_add
[   14.606283] bus: 'platform': add device hgafb.0
[   14.606887] bus: 'platform': driver_probe_device: matched device hgafb.0=
 with driver hgafb
[   14.607889] bus: 'platform': really_probe: probing driver hgafb with dev=
ice hgafb.0
[   14.608936] hgafb: HGA card not detected.
[   14.609442] hgafb: probe of hgafb.0 failed with error -22
[   14.610141] bus: 'pci': add driver cirrusfb
[   14.610706] bus: 'pci': driver_probe_device: matched device 0000:00:02.0=
 with driver cirrusfb
[   14.611742] bus: 'pci': really_probe: probing driver cirrusfb with devic=
e 0000:00:02.0
[   14.617217] cirrusfb 0000:00:02.0: Cirrus Logic chipset on PCI bus, RAM =
(4096 kB) at 0xfc000000
[   14.618420] device: 'fb0': device_add
[   14.619664] driver: '0000:00:02.0': driver_bound: bound to device 'cirru=
sfb'
[   14.620745] bus: 'pci': really_probe: bound device 0000:00:02.0 to drive=
r cirrusfb
[   14.621828] bus: 'pci': add driver asiliantfb
[   14.622635] bus: 'platform': add driver s1d13xxxfb
[   14.623280] bus: 'pci': add driver carminefb
[   14.624257] bus: 'acpi': add driver button
[   14.625048] bus: 'acpi': driver_probe_device: matched device LNXPWRBN:00=
 with driver button
[   14.626011] bus: 'acpi': really_probe: probing driver button with device=
 LNXPWRBN:00
[   14.626924] device: 'input0': device_add
[   14.627556] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/inpu=
t/input0
[   14.628595] ACPI: Power Button [PWRF]
[   14.629104] driver: 'LNXPWRBN:00': driver_bound: bound to device 'button'
[   14.629896] bus: 'acpi': really_probe: bound device LNXPWRBN:00 to drive=
r button
[   14.630941] bus: 'acpi': add driver video
[   14.631599] bus: 'acpi': add driver processor
[   14.632319] bus: 'acpi': driver_probe_device: matched device LNXCPU:00 w=
ith driver processor
[   14.633346] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:00
[   14.634943] device: 'cooling_device0': device_add
[   14.635769] driver: 'LNXCPU:00': driver_bound: bound to device 'processo=
r'
[   14.636654] bus: 'acpi': really_probe: bound device LNXCPU:00 to driver =
processor
[   14.637580] bus: 'acpi': driver_probe_device: matched device LNXCPU:01 w=
ith driver processor
[   14.638605] bus: 'acpi': really_probe: probing driver processor with dev=
ice LNXCPU:01
[   14.640761] device: 'cooling_device1': device_add
[   14.641408] driver: 'LNXCPU:01': driver_bound: bound to device 'processo=
r'
[   14.642221] bus: 'acpi': really_probe: bound device LNXCPU:01 to driver =
processor
[   14.643258] bus: 'platform': add driver virtio-mmio
[   14.643909] bus: 'pci': add driver virtio-pci
[   14.644771] bus: 'pci': driver_probe_device: matched device 0000:00:05.0=
 with driver virtio-pci
[   14.645841] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:05.0
[   14.647813] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[   14.648914] IOAPIC[0]: Set routing entry (2-10 -> 0x3a -> IRQ 10 Mode:1 =
Active:0 Dest:3)
[   14.650113] virtio-pci 0000:00:05.0: setting latency timer to 64
[   14.651411] device: 'virtio0': device_add
[   14.651925] bus: 'virtio': add device virtio0
[   14.652639] driver: '0000:00:05.0': driver_bound: bound to device 'virti=
o-pci'
[   14.653530] bus: 'pci': really_probe: bound device 0000:00:05.0 to drive=
r virtio-pci
[   14.654479] bus: 'pci': driver_probe_device: matched device 0000:00:06.0=
 with driver virtio-pci
[   14.655521] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:06.0
[   14.657190] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[   14.657921] IOAPIC[0]: Set routing entry (2-11 -> 0x3b -> IRQ 11 Mode:1 =
Active:0 Dest:3)
[   14.658998] virtio-pci 0000:00:06.0: setting latency timer to 64
[   14.660069] device: 'virtio1': device_add
[   14.660579] bus: 'virtio': add device virtio1
[   14.661170] driver: '0000:00:06.0': driver_bound: bound to device 'virti=
o-pci'
[   14.662059] bus: 'pci': really_probe: bound device 0000:00:06.0 to drive=
r virtio-pci
[   14.663013] bus: 'pci': driver_probe_device: matched device 0000:00:07.0=
 with driver virtio-pci
[   14.664102] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:07.0
[   14.666099] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[   14.666892] virtio-pci 0000:00:07.0: setting latency timer to 64
[   14.667855] device: 'virtio2': device_add
[   14.668802] bus: 'virtio': add device virtio2
[   14.669398] driver: '0000:00:07.0': driver_bound: bound to device 'virti=
o-pci'
[   14.670250] bus: 'pci': really_probe: bound device 0000:00:07.0 to drive=
r virtio-pci
[   14.671166] bus: 'pci': driver_probe_device: matched device 0000:00:08.0=
 with driver virtio-pci
[   14.672456] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:08.0
[   14.674344] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[   14.675098] virtio-pci 0000:00:08.0: setting latency timer to 64
[   14.676351] device: 'virtio3': device_add
[   14.676877] bus: 'virtio': add device virtio3
[   14.677498] driver: '0000:00:08.0': driver_bound: bound to device 'virti=
o-pci'
[   14.678391] bus: 'pci': really_probe: bound device 0000:00:08.0 to drive=
r virtio-pci
[   14.679351] bus: 'pci': driver_probe_device: matched device 0000:00:09.0=
 with driver virtio-pci
[   14.680472] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:09.0
[   14.681697] virtio-pci 0000:00:09.0: setting latency timer to 64
[   14.682689] device: 'virtio4': device_add
[   14.683207] bus: 'virtio': add device virtio4
[   14.683796] driver: '0000:00:09.0': driver_bound: bound to device 'virti=
o-pci'
[   14.684726] bus: 'pci': really_probe: bound device 0000:00:09.0 to drive=
r virtio-pci
[   14.685635] bus: 'pci': driver_probe_device: matched device 0000:00:0a.0=
 with driver virtio-pci
[   14.686627] bus: 'pci': really_probe: probing driver virtio-pci with dev=
ice 0000:00:0a.0
[   14.687780] virtio-pci 0000:00:0a.0: setting latency timer to 64
[   14.688754] device: 'virtio5': device_add
[   14.689232] bus: 'virtio': add device virtio5
[   14.689779] driver: '0000:00:0a.0': driver_bound: bound to device 'virti=
o-pci'
[   14.690607] bus: 'pci': really_probe: bound device 0000:00:0a.0 to drive=
r virtio-pci
[   14.691729] device: 'ptyp0': device_add
[   14.693027] device: 'ptyp1': device_add
[   14.693891] device: 'ptyp2': device_add
[   14.694729] device: 'ptyp3': device_add
[   14.695561] device: 'ptyp4': device_add
[   14.696588] device: 'ptyp5': device_add
[   14.697419] device: 'ptyp6': device_add
[   14.698244] device: 'ptyp7': device_add
[   14.699071] device: 'ptyp8': device_add
[   14.699903] device: 'ptyp9': device_add
[   14.700921] device: 'ptypa': device_add
[   14.701737] device: 'ptypb': device_add
[   14.702558] device: 'ptypc': device_add
[   14.703378] device: 'ptypd': device_add
[   14.717434] device: 'ptype': device_add
[   14.718294] device: 'ptypf': device_add
[   14.719142] device: 'ptyq0': device_add
[   14.719990] device: 'ptyq1': device_add
[   14.721028] device: 'ptyq2': device_add
[   14.721858] device: 'ptyq3': device_add
[   14.722678] device: 'ptyq4': device_add
[   14.723536] device: 'ptyq5': device_add
[   14.724539] device: 'ptyq6': device_add
[   14.725355] device: 'ptyq7': device_add
[   14.743930] device: 'ptyq8': device_add
[   14.751142] device: 'ptyq9': device_add
[   14.773375] device: 'ptyqa': device_add
[   14.774190] device: 'ptyqb': device_add
[   14.774981] device: 'ptyqc': device_add
[   14.788869] device: 'ptyqd': device_add
[   14.798371] device: 'ptyqe': device_add
[   14.799193] device: 'ptyqf': device_add
[   14.799991] device: 'ptyr0': device_add
[   14.822466] device: 'ptyr1': device_add
[   14.823300] device: 'ptyr2': device_add
[   14.833407] device: 'ptyr3': device_add
[   14.834208] device: 'ptyr4': device_add
[   14.856002] device: 'ptyr5': device_add
[   14.857899] device: 'ptyr6': device_add
[   14.858682] device: 'ptyr7': device_add
[   14.859476] device: 'ptyr8': device_add
[   14.860492] device: 'ptyr9': device_add
[   14.874286] device: 'ptyra': device_add
[   14.875197] device: 'ptyrb': device_add
[   14.876219] device: 'ptyrc': device_add
[   14.877077] device: 'ptyrd': device_add
[   14.877912] device: 'ptyre': device_add
[   14.878746] device: 'ptyrf': device_add
[   14.879584] device: 'ptys0': device_add
[   14.880643] device: 'ptys1': device_add
[   14.881489] device: 'ptys2': device_add
[   14.882305] device: 'ptys3': device_add
[   14.883132] device: 'ptys4': device_add
[   14.883959] device: 'ptys5': device_add
[   14.885062] device: 'ptys6': device_add
[   14.885900] device: 'ptys7': device_add
[   14.886718] device: 'ptys8': device_add
[   14.900396] device: 'ptys9': device_add
[   14.901236] device: 'ptysa': device_add
[   14.902075] device: 'ptysb': device_add
[   14.902918] device: 'ptysc': device_add
[   14.903742] device: 'ptysd': device_add
[   14.904863] device: 'ptyse': device_add
[   14.905694] device: 'ptysf': device_add
[   14.906518] device: 'ptyt0': device_add
[   14.907365] device: 'ptyt1': device_add
[   14.909164] device: 'ptyt2': device_add
[   14.909992] device: 'ptyt3': device_add
[   14.910817] device: 'ptyt4': device_add
[   14.911627] device: 'ptyt5': device_add
[   14.912703] device: 'ptyt6': device_add
[   14.926366] device: 'ptyt7': device_add
[   14.927214] device: 'ptyt8': device_add
[   14.928313] device: 'ptyt9': device_add
[   14.929203] device: 'ptyta': device_add
[   14.930030] device: 'ptytb': device_add
[   14.930906] device: 'ptytc': device_add
[   14.931750] device: 'ptytd': device_add
[   14.932832] device: 'ptyte': device_add
[   14.933638] device: 'ptytf': device_add
[   14.934429] device: 'ptyu0': device_add
[   14.935259] device: 'ptyu1': device_add
[   14.936246] device: 'ptyu2': device_add
[   14.937061] device: 'ptyu3': device_add
[   14.937895] device: 'ptyu4': device_add
[   14.938717] device: 'ptyu5': device_add
[   14.952574] device: 'ptyu6': device_add
[   14.953389] device: 'ptyu7': device_add
[   14.954202] device: 'ptyu8': device_add
[   14.955002] device: 'ptyu9': device_add
[   14.955811] device: 'ptyua': device_add
[   14.956786] device: 'ptyub': device_add
[   14.957610] device: 'ptyuc': device_add
[   14.958433] device: 'ptyud': device_add
[   14.959260] device: 'ptyue': device_add
[   14.960246] device: 'ptyuf': device_add
[   14.962086] device: 'ptyv0': device_add
[   14.962950] device: 'ptyv1': device_add
[   14.963835] device: 'ptyv2': device_add
[   14.978172] device: 'ptyv3': device_add
[   14.979056] device: 'ptyv4': device_add
[   14.979892] device: 'ptyv5': device_add
[   14.981008] device: 'ptyv6': device_add
[   14.981840] device: 'ptyv7': device_add
[   14.982667] device: 'ptyv8': device_add
[   14.983487] device: 'ptyv9': device_add
[   14.985346] device: 'ptyva': device_add
[   14.986165] device: 'ptyvb': device_add
[   14.986987] device: 'ptyvc': device_add
[   14.987837] device: 'ptyvd': device_add
[   14.988969] device: 'ptyve': device_add
[   14.989796] device: 'ptyvf': device_add
[   14.990602] device: 'ptyw0': device_add
[   15.007050] device: 'ptyw1': device_add
[   15.007907] device: 'ptyw2': device_add
[   15.009068] device: 'ptyw3': device_add
[   15.009911] device: 'ptyw4': device_add
[   15.010744] device: 'ptyw5': device_add
[   15.011569] device: 'ptyw6': device_add
[   15.012569] device: 'ptyw7': device_add
[   15.013425] device: 'ptyw8': device_add
[   15.014252] device: 'ptyw9': device_add
[   15.015126] device: 'ptywa': device_add
[   15.028976] device: 'ptywb': device_add
[   15.029865] device: 'ptywc': device_add
[   15.030694] device: 'ptywd': device_add
[   15.031530] device: 'ptywe': device_add
[   15.032903] device: 'ptywf': device_add
[   15.033748] device: 'ptyx0': device_add
[   15.034612] device: 'ptyx1': device_add
[   15.035442] device: 'ptyx2': device_add
[   15.036507] device: 'ptyx3': device_add
[   15.051011] device: 'ptyx4': device_add
[   15.051859] device: 'ptyx5': device_add
[   15.052994] device: 'ptyx6': device_add
[   15.053821] device: 'ptyx7': device_add
[   15.054648] device: 'ptyx8': device_add
[   15.055481] device: 'ptyx9': device_add
[   15.056624] device: 'ptyxa': device_add
[   15.057446] device: 'ptyxb': device_add
[   15.058281] device: 'ptyxc': device_add
[   15.059123] device: 'ptyxd': device_add
[   15.059961] device: 'ptyxe': device_add
[   15.061040] device: 'ptyxf': device_add
[   15.061886] device: 'ptyy0': device_add
[   15.062747] device: 'ptyy1': device_add
[   15.076634] device: 'ptyy2': device_add
[   15.077443] device: 'ptyy3': device_add
[   15.078248] device: 'ptyy4': device_add
[   15.079047] device: 'ptyy5': device_add
[   15.079832] device: 'ptyy6': device_add
[   15.081771] device: 'ptyy7': device_add
[   15.082569] device: 'ptyy8': device_add
[   15.083360] device: 'ptyy9': device_add
[   15.084947] device: 'ptyya': device_add
[   15.085789] device: 'ptyyb': device_add
[   15.086624] device: 'ptyyc': device_add
[   15.087471] device: 'ptyyd': device_add
[   15.102259] device: 'ptyye': device_add
[   15.103108] device: 'ptyyf': device_add
[   15.103936] device: 'ptyz0': device_add
[   15.105223] device: 'ptyz1': device_add
[   15.106047] device: 'ptyz2': device_add
[   15.106891] device: 'ptyz3': device_add
[   15.107730] device: 'ptyz4': device_add
[   15.108760] device: 'ptyz5': device_add
[   15.109577] device: 'ptyz6': device_add
[   15.110410] device: 'ptyz7': device_add
[   15.111246] device: 'ptyz8': device_add
[   15.112232] device: 'ptyz9': device_add
[   15.126082] device: 'ptyza': device_add
[   15.126920] device: 'ptyzb': device_add
[   15.127780] device: 'ptyzc': device_add
[   15.128915] device: 'ptyzd': device_add
[   15.129760] device: 'ptyze': device_add
[   15.130585] device: 'ptyzf': device_add
[   15.131416] device: 'ptya0': device_add
[   15.149746] device: 'ptya1': device_add
[   15.150588] device: 'ptya2': device_add
[   15.151421] device: 'ptya3': device_add
[   15.152562] device: 'ptya4': device_add
[   15.153391] device: 'ptya5': device_add
[   15.154281] device: 'ptya6': device_add
[   15.155128] device: 'ptya7': device_add
[   15.176503] device: 'ptya8': device_add
[   15.177317] device: 'ptya9': device_add
[   15.178094] device: 'ptyaa': device_add
[   15.198011] device: 'ptyab': device_add
[   15.198865] device: 'ptyac': device_add
[   15.199702] device: 'ptyad': device_add
[   15.200790] device: 'ptyae': device_add
[   15.201610] device: 'ptyaf': device_add
[   15.217048] device: 'ptyb0': device_add
[   15.225761] device: 'ptyb1': device_add
[   15.226661] device: 'ptyb2': device_add
[   15.227490] device: 'ptyb3': device_add
[   15.245729] device: 'ptyb4': device_add
[   15.246562] device: 'ptyb5': device_add
[   15.247382] device: 'ptyb6': device_add
[   15.249517] device: 'ptyb7': device_add
[   15.250345] device: 'ptyb8': device_add
[   15.251190] device: 'ptyb9': device_add
[   15.252335] device: 'ptyba': device_add
[   15.253174] device: 'ptybb': device_add
[   15.267992] device: 'ptybc': device_add
[   15.269371] device: 'ptybd': device_add
[   15.284893] device: 'ptybe': device_add
[   15.285759] device: 'ptybf': device_add
[   15.286456] device: 'ptyc0': device_add
[   15.287190] device: 'ptyc1': device_add
[   15.287923] device: 'ptyc2': device_add
[   15.288824] device: 'ptyc3': device_add
[   15.289677] device: 'ptyc4': device_add
[   15.293268] device: 'ptyc5': device_add
[   15.298601] device: 'ptyc6': device_add
[   15.299246] device: 'ptyc7': device_add
[   15.299878] device: 'ptyc8': device_add
[   15.301355] device: 'ptyc9': device_add
[   15.302033] device: 'ptyca': device_add
[   15.302673] device: 'ptycb': device_add
[   15.303331] device: 'ptycc': device_add
[   15.303973] device: 'ptycd': device_add
[   15.304869] device: 'ptyce': device_add
[   15.305550] device: 'ptycf': device_add
[   15.306195] device: 'ptyd0': device_add
[   15.306862] device: 'ptyd1': device_add
[   15.307501] device: 'ptyd2': device_add
[   15.308433] device: 'ptyd3': device_add
[   15.309070] device: 'ptyd4': device_add
[   15.309708] device: 'ptyd5': device_add
[   15.310377] device: 'ptyd6': device_add
[   15.311014] device: 'ptyd7': device_add
[   15.311658] device: 'ptyd8': device_add
[   15.312691] device: 'ptyd9': device_add
[   15.313331] device: 'ptyda': device_add
[   15.313998] device: 'ptydb': device_add
[   15.314672] device: 'ptydc': device_add
[   15.315363] device: 'ptydd': device_add
[   15.317058] device: 'ptyde': device_add
[   15.317739] device: 'ptydf': device_add
[   15.318428] device: 'ptye0': device_add
[   15.327016] device: 'ptye1': device_add
[   15.327784] device: 'ptye2': device_add
[   15.328846] device: 'ptye3': device_add
[   15.329574] device: 'ptye4': device_add
[   15.330290] device: 'ptye5': device_add
[   15.331006] device: 'ptye6': device_add
[   15.331718] device: 'ptye7': device_add
[   15.334757] device: 'ptye8': device_add
[   15.335467] device: 'ptye9': device_add
[   15.354464] device: 'ptyea': device_add
[   15.368344] device: 'ptyeb': device_add
[   15.377717] device: 'ptyec': device_add
[   15.393898] device: 'ptyed': device_add
[   15.396421] device: 'ptyee': device_add
[   15.397158] device: 'ptyef': device_add
[   15.397907] device: 'ttyp0': device_add
[   15.412525] device: 'ttyp1': device_add
[   15.413242] device: 'ttyp2': device_add
[   15.413935] device: 'ttyp3': device_add
[   15.414650] device: 'ttyp4': device_add
[   15.415351] device: 'ttyp5': device_add
[   15.416166] device: 'ttyp6': device_add
[   15.416878] device: 'ttyp7': device_add
[   15.441880] device: 'ttyp8': device_add
[   15.466025] device: 'ttyp9': device_add
[   15.466641] device: 'ttypa': device_add
[   15.467212] device: 'ttypb': device_add
[   15.467794] device: 'ttypc': device_add
[   15.469528] device: 'ttypd': device_add
[   15.470099] device: 'ttype': device_add
[   15.470672] device: 'ttypf': device_add
[   15.471251] device: 'ttyq0': device_add
[   15.471846] device: 'ttyq1': device_add
[   15.472606] device: 'ttyq2': device_add
[   15.473179] device: 'ttyq3': device_add
[   15.473746] device: 'ttyq4': device_add
[   15.474312] device: 'ttyq5': device_add
[   15.474912] device: 'ttyq6': device_add
[   15.475481] device: 'ttyq7': device_add
[   15.476369] device: 'ttyq8': device_add
[   15.476940] device: 'ttyq9': device_add
[   15.477507] device: 'ttyqa': device_add
[   15.478075] device: 'ttyqb': device_add
[   15.478645] device: 'ttyqc': device_add
[   15.479219] device: 'ttyqd': device_add
[   15.479787] device: 'ttyqe': device_add
[   15.480688] device: 'ttyqf': device_add
[   15.481245] device: 'ttyr0': device_add
[   15.481821] device: 'ttyr1': device_add
[   15.482408] device: 'ttyr2': device_add
[   15.482965] device: 'ttyr3': device_add
[   15.483539] device: 'ttyr4': device_add
[   15.484428] device: 'ttyr5': device_add
[   15.484996] device: 'ttyr6': device_add
[   15.485562] device: 'ttyr7': device_add
[   15.486131] device: 'ttyr8': device_add
[   15.486699] device: 'ttyr9': device_add
[   15.487262] device: 'ttyra': device_add
[   15.487830] device: 'ttyrb': device_add
[   15.489314] device: 'ttyrc': device_add
[   15.489901] device: 'ttyrd': device_add
[   15.490502] device: 'ttyre': device_add
[   15.491073] device: 'ttyrf': device_add
[   15.491638] device: 'ttys0': device_add
[   15.492568] device: 'ttys1': device_add
[   15.493136] device: 'ttys2': device_add
[   15.493705] device: 'ttys3': device_add
[   15.494271] device: 'ttys4': device_add
[   15.494837] device: 'ttys5': device_add
[   15.495404] device: 'ttys6': device_add
[   15.495973] device: 'ttys7': device_add
[   15.496872] device: 'ttys8': device_add
[   15.497439] device: 'ttys9': device_add
[   15.498036] device: 'ttysa': device_add
[   15.498599] device: 'ttysb': device_add
[   15.499187] device: 'ttysc': device_add
[   15.499752] device: 'ttysd': device_add
[   15.538889] device: 'ttyse': device_add
[   15.548988] device: 'ttysf': device_add
[   15.549557] device: 'ttyt0': device_add
[   15.550161] device: 'ttyt1': device_add
[   15.550725] device: 'ttyt2': device_add
[   15.551287] device: 'ttyt3': device_add
[   15.551854] device: 'ttyt4': device_add
[   15.553661] device: 'ttyt5': device_add
[   15.554262] device: 'ttyt6': device_add
[   15.554826] device: 'ttyt7': device_add
[   15.555390] device: 'ttyt8': device_add
[   15.555954] device: 'ttyt9': device_add
[   15.557359] device: 'ttyta': device_add
[   15.557928] device: 'ttytb': device_add
[   15.558498] device: 'ttytc': device_add
[   15.559081] device: 'ttytd': device_add
[   15.559652] device: 'ttyte': device_add
[   15.560572] device: 'ttytf': device_add
[   15.561136] device: 'ttyu0': device_add
[   15.561729] device: 'ttyu1': device_add
[   15.562331] device: 'ttyu2': device_add
[   15.562895] device: 'ttyu3': device_add
[   15.563477] device: 'ttyu4': device_add
[   15.565153] device: 'ttyu5': device_add
[   15.565725] device: 'ttyu6': device_add
[   15.566292] device: 'ttyu7': device_add
[   15.566856] device: 'ttyu8': device_add
[   15.567424] device: 'ttyu9': device_add
[   15.567993] device: 'ttyua': device_add
[   15.568901] device: 'ttyub': device_add
[   15.569472] device: 'ttyuc': device_add
[   15.570043] device: 'ttyud': device_add
[   15.570640] device: 'ttyue': device_add
[   15.571210] device: 'ttyuf': device_add
[   15.571775] device: 'ttyv0': device_add
[   15.572751] device: 'ttyv1': device_add
[   15.573320] device: 'ttyv2': device_add
[   15.573888] device: 'ttyv3': device_add
[   15.574458] device: 'ttyv4': device_add
[   15.575027] device: 'ttyv5': device_add
[   15.575593] device: 'ttyv6': device_add
[   15.593800] device: 'ttyv7': device_add
[   15.597592] device: 'ttyv8': device_add
[   15.598170] device: 'ttyv9': device_add
[   15.598772] device: 'ttyva': device_add
[   15.599344] device: 'ttyvb': device_add
[   15.599925] device: 'ttyvc': device_add
[   15.600684] device: 'ttyvd': device_add
[   15.601257] device: 'ttyve': device_add
[   15.601825] device: 'ttyvf': device_add
[   15.602393] device: 'ttyw0': device_add
[   15.602991] device: 'ttyw1': device_add
[   15.603563] device: 'ttyw2': device_add
[   15.604333] device: 'ttyw3': device_add
[   15.604903] device: 'ttyw4': device_add
[   15.605469] device: 'ttyw5': device_add
[   15.606068] device: 'ttyw6': device_add
[   15.606633] device: 'ttyw7': device_add
[   15.607205] device: 'ttyw8': device_add
[   15.607775] device: 'ttyw9': device_add
[   15.617319] device: 'ttywa': device_add
[   15.619289] device: 'ttywb': device_add
[   15.620416] device: 'ttywc': device_add
[   15.621230] device: 'ttywd': device_add
[   15.622033] device: 'ttywe': device_add
[   15.630061] device: 'ttywf': device_add
[   15.630774] device: 'ttyx0': device_add
[   15.631515] device: 'ttyx1': device_add
[   15.633148] device: 'ttyx2': device_add
[   15.633859] device: 'ttyx3': device_add
[   15.634583] device: 'ttyx4': device_add
[   15.635296] device: 'ttyx5': device_add
[   15.636126] device: 'ttyx6': device_add
[   15.636936] device: 'ttyx7': device_add
[   15.637640] device: 'ttyx8': device_add
[   15.638352] device: 'ttyx9': device_add
[   15.639061] device: 'ttyxa': device_add
[   15.639766] device: 'ttyxb': device_add
[   15.641617] device: 'ttyxc': device_add
[   15.642346] device: 'ttyxd': device_add
[   15.643097] device: 'ttyxe': device_add
[   15.643811] device: 'ttyxf': device_add
[   15.645887] device: 'ttyy0': device_add
[   15.646620] device: 'ttyy1': device_add
[   15.647333] device: 'ttyy2': device_add
[   15.648377] device: 'ttyy3': device_add
[   15.649086] device: 'ttyy4': device_add
[   15.649790] device: 'ttyy5': device_add
[   15.650491] device: 'ttyy6': device_add
[   15.651201] device: 'ttyy7': device_add
[   15.651911] device: 'ttyy8': device_add
[   15.653079] device: 'ttyy9': device_add
[   15.653822] device: 'ttyya': device_add
[   15.654527] device: 'ttyyb': device_add
[   15.655253] device: 'ttyyc': device_add
[   15.655961] device: 'ttyyd': device_add
[   15.657045] device: 'ttyye': device_add
[   15.657756] device: 'ttyyf': device_add
[   15.658454] device: 'ttyz0': device_add
[   15.659196] device: 'ttyz1': device_add
[   15.659904] device: 'ttyz2': device_add
[   15.661411] device: 'ttyz3': device_add
[   15.662123] device: 'ttyz4': device_add
[   15.662830] device: 'ttyz5': device_add
[   15.663568] device: 'ttyz6': device_add
[   15.664681] device: 'ttyz7': device_add
[   15.665388] device: 'ttyz8': device_add
[   15.666098] device: 'ttyz9': device_add
[   15.666811] device: 'ttyza': device_add
[   15.667513] device: 'ttyzb': device_add
[   15.706920] device: 'ttyzc': device_add
[   15.733118] device: 'ttyzd': device_add
[   15.746048] device: 'ttyze': device_add
[   15.746765] device: 'ttyzf': device_add
[   15.747468] device: 'ttya0': device_add
[   15.749190] device: 'ttya1': device_add
[   15.749940] device: 'ttya2': device_add
[   15.750645] device: 'ttya3': device_add
[   15.751383] device: 'ttya4': device_add
[   15.764808] device: 'ttya5': device_add
[   15.768462] device: 'ttya6': device_add
[   15.769287] device: 'ttya7': device_add
[   15.770104] device: 'ttya8': device_add
[   15.770923] device: 'ttya9': device_add
[   15.771835] device: 'ttyaa': device_add
[   15.772894] device: 'ttyab': device_add
[   15.778038] device: 'ttyac': device_add
[   15.778753] device: 'ttyad': device_add
[   15.779492] device: 'ttyae': device_add
[   15.782376] device: 'ttyaf': device_add
[   15.783093] device: 'ttyb0': device_add
[   15.783833] device: 'ttyb1': device_add
[   15.784772] device: 'ttyb2': device_add
[   15.785473] device: 'ttyb3': device_add
[   15.786183] device: 'ttyb4': device_add
[   15.786893] device: 'ttyb5': device_add
[   15.787596] device: 'ttyb6': device_add
[   15.788657] device: 'ttyb7': device_add
[   15.789365] device: 'ttyb8': device_add
[   15.790071] device: 'ttyb9': device_add
[   15.790816] device: 'ttyba': device_add
[   15.791518] device: 'ttybb': device_add
[   15.792641] device: 'ttybc': device_add
[   15.793366] device: 'ttybd': device_add
[   15.794076] device: 'ttybe': device_add
[   15.794784] device: 'ttybf': device_add
[   15.795484] device: 'ttyc0': device_add
[   15.797530] device: 'ttyc1': device_add
[   15.798242] device: 'ttyc2': device_add
[   15.798947] device: 'ttyc3': device_add
[   15.799647] device: 'ttyc4': device_add
[   15.800774] device: 'ttyc5': device_add
[   15.801513] device: 'ttyc6': device_add
[   15.802225] device: 'ttyc7': device_add
[   15.802932] device: 'ttyc8': device_add
[   15.803630] device: 'ttyc9': device_add
[   15.804955] device: 'ttyca': device_add
[   15.805658] device: 'ttycb': device_add
[   15.806367] device: 'ttycc': device_add
[   15.807072] device: 'ttycd': device_add
[   15.807781] device: 'ttyce': device_add
[   15.836958] device: 'ttycf': device_add
[   15.862063] device: 'ttyd0': device_add
[   15.862816] device: 'ttyd1': device_add
[   15.863560] device: 'ttyd2': device_add
[   15.865234] device: 'ttyd3': device_add
[   15.865964] device: 'ttyd4': device_add
[   15.866667] device: 'ttyd5': device_add
[   15.867377] device: 'ttyd6': device_add
[   15.868281] device: 'ttyd7': device_add
[   15.868993] device: 'ttyd8': device_add
[   15.869703] device: 'ttyd9': device_add
[   15.870407] device: 'ttyda': device_add
[   15.871116] device: 'ttydb': device_add
[   15.871823] device: 'ttydc': device_add
[   15.872806] device: 'ttydd': device_add
[   15.873545] device: 'ttyde': device_add
[   15.874258] device: 'ttydf': device_add
[   15.874967] device: 'ttye0': device_add
[   15.875700] device: 'ttye1': device_add
[   15.876788] device: 'ttye2': device_add
[   15.877488] device: 'ttye3': device_add
[   15.878198] device: 'ttye4': device_add
[   15.878909] device: 'ttye5': device_add
[   15.879611] device: 'ttye6': device_add
[   15.880728] device: 'ttye7': device_add
[   15.881432] device: 'ttye8': device_add
[   15.882139] device: 'ttye9': device_add
[   15.882879] device: 'ttyea': device_add
[   15.883581] device: 'ttyeb': device_add
[   15.885049] device: 'ttyec': device_add
[   15.885761] device: 'ttyed': device_add
[   15.886464] device: 'ttyee': device_add
[   15.887176] device: 'ttyef': device_add
[   15.889266] r3964: Philips r3964 Driver $Revision: 1.10 $
[   15.889968] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   15.890809] Registering platform device 'serial8250'. Parent at platform
[   15.891628] device: 'serial8250': device_add
[   15.892537] bus: 'platform': add device serial8250
[   15.915622] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[   15.916718] device: 'ttyS0': device_add
[   15.917710] device: 'ttyS1': device_add
[   15.918480] device: 'ttyS2': device_add
[   15.919260] device: 'ttyS3': device_add
[   15.919969] bus: 'platform': add driver serial8250
[   15.921842] bus: 'platform': driver_probe_device: matched device serial8=
250 with driver serial8250
[   15.922972] bus: 'platform': really_probe: probing driver serial8250 wit=
h device serial8250
[   15.924385] driver: 'serial8250': driver_bound: bound to device 'serial8=
250'
[   15.925286] bus: 'platform': really_probe: bound device serial8250 to dr=
iver serial8250
[   15.926338] bus: 'pci': add driver serial
[   15.927053] bus: 'platform': add driver dw-apb-uart
[   15.927738] bus: 'platform': add driver timb-uart
[   15.928754] bus: 'platform': add driver altera_jtaguart
[   15.929989] bus: 'pci': add driver HSU serial
[   15.930650] Initializing Nozomi driver 2.1d
[   15.931258] bus: 'pci': add driver nozomi
[   15.931960] bus: 'pcmcia': add driver ipwireless
[   15.933024] device: 'ttyprintk': device_add
[   15.933908] device class 'virtio-ports': registering
[   15.934623] bus: 'virtio': add driver virtio_console
[   15.935341] device class 'raw': registering
[   15.935909] device: 'rawctl': device_add
[   15.937324] device class 'printer': registering
[   15.938004] lp: driver loaded but no devices found
[   15.938610] Applicom driver: $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 =
Exp $
[   15.939556] ac.o: No PCI boards found.
[   15.941223] ac.o: For an ISA board you must supply memory and irq parame=
ters.
[   15.942240] device: 'hpet': device_add
[   15.942983] bus: 'acpi': add driver hpet
[   15.943618] bus: 'acpi': driver_probe_device: matched device PNP0103:00 =
with driver hpet
[   15.946841] bus: 'acpi': really_probe: probing driver hpet with device P=
NP0103:00
[   15.948270] hpet: probe of PNP0103:00 rejects match -19
[   15.949039] device: 'nvram': device_add
[   15.949913] Non-volatile memory driver v1.3
[   15.950469] scx200_gpio: no SCx200 gpio present
[   15.951067] Registering platform device 'pc8736x_gpio.0'. Parent at plat=
form
[   15.952009] device: 'pc8736x_gpio.0': device_add
[   15.952878] bus: 'platform': add device pc8736x_gpio.0
[   15.953757] platform pc8736x_gpio.0: NatSemi pc8736x GPIO Driver Initial=
izing
[   15.954711] platform pc8736x_gpio.0: no device found
[   15.955378] bus: 'platform': remove device pc8736x_gpio.0
[   15.956333] nsc_gpio initializing
[   15.956840] telclk_interrupt =3D 0xf non-mcpbl0010 hw.
[   15.957600] smapi::smapi_init, ERROR invalid usSmapiID
[   15.958274] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is=
 not available on this machine
[   15.959435] mwave: mwavedd::mwave_init: Error: Failed to initialize boar=
d data
[   15.960602] mwave: mwavedd::mwave_init: Error: Failed to initialize
[   15.961426] Linux agpgart interface v0.103
[   15.962025] bus: 'pci': add driver agpgart-ali
[   15.962804] bus: 'pci': add driver agpgart-amdk7
[   15.963624] bus: 'pci': add driver agpgart-intel
[   15.964480] bus: 'pci': driver_probe_device: matched device 0000:00:00.0=
 with driver agpgart-intel
[   15.965614] bus: 'pci': really_probe: probing driver agpgart-intel with =
device 0000:00:00.0
[   15.975663] agpgart-intel: probe of 0000:00:00.0 rejects match -19
[   15.976885] bus: 'pci': add driver agpgart-sis
[   15.977670] bus: 'pci': add driver agpgart-via
[   15.978522] bus: 'pcmcia': add driver synclink_cs
[   15.979146] SyncLink PC Card driver $Revision: 4.34 $, tty major#248
[   15.979991] device class 'drm': registering
[   15.980961] [drm] Initialized drm 1.1.0 20060810
[   15.981589] device: 'ttm': device_add
[   15.985766] [drm] radeon defaulting to userspace modesetting.
[   16.051455] bus: 'pci': add driver mgag200
[   16.052496] bus: 'pci': add driver cirrus
[   16.053269] bus: 'pci': add driver ast
[   16.053986] bus: 'i2c': add driver ch7006
[   16.054561] i2c-core: driver [ch7006] using legacy suspend method
[   16.055333] i2c-core: driver [ch7006] using legacy resume method
[   16.056309] bus: 'i2c': add driver sil164
[   16.056920] bus: 'pci': add driver poulsbo
[   16.057681] bus: 'pci': add driver i810fb
[   16.058486] bus: 'platform': add driver parport_pc
[   16.060723] bus: 'pnp': add driver parport_pc
[   16.061366] bus: 'pnp': driver_probe_device: matched device 00:05 with d=
river parport_pc
[   16.062444] bus: 'pnp': really_probe: probing driver parport_pc with dev=
ice 00:05
[   16.063457] parport_pc 00:05: reported by Plug and Play ACPI
[   16.064545] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[   16.066128] device: 'lp0': device_add
[   16.067381] lp0: using parport0 (interrupt-driven).
[   16.068254] driver: '00:05': driver_bound: bound to device 'parport_pc'
[   16.069102] bus: 'pnp': really_probe: bound device 00:05 to driver parpo=
rt_pc
[   16.070103] Registering platform device 'parport_pc.956'. Parent at plat=
form
[   16.071022] device: 'parport_pc.956': device_add
[   16.071633] bus: 'platform': add device parport_pc.956
[   16.072709] bus: 'platform': driver_probe_device: matched device parport=
_pc.956 with driver parport_pc
[   16.073919] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.956
[   16.075035] driver: 'parport_pc.956': driver_bound: bound to device 'par=
port_pc'
[   16.075987] bus: 'platform': really_probe: bound device parport_pc.956 t=
o driver parport_pc
[   16.077494] bus: 'platform': remove device parport_pc.956
[   16.078349] Registering platform device 'parport_pc.888'. Parent at plat=
form
[   16.079246] device: 'parport_pc.888': device_add
[   16.079870] bus: 'platform': add device parport_pc.888
[   16.080918] bus: 'platform': driver_probe_device: matched device parport=
_pc.888 with driver parport_pc
[   16.082151] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.888
[   16.083252] driver: 'parport_pc.888': driver_bound: bound to device 'par=
port_pc'
[   16.084428] bus: 'platform': really_probe: bound device parport_pc.888 t=
o driver parport_pc
[   16.085580] bus: 'platform': remove device parport_pc.888
[   16.086384] Registering platform device 'parport_pc.632'. Parent at plat=
form
[   16.087298] device: 'parport_pc.632': device_add
[   16.087922] bus: 'platform': add device parport_pc.632
[   16.088923] bus: 'platform': driver_probe_device: matched device parport=
_pc.632 with driver parport_pc
[   16.090123] bus: 'platform': really_probe: probing driver parport_pc wit=
h device parport_pc.632
[   16.091241] driver: 'parport_pc.632': driver_bound: bound to device 'par=
port_pc'
[   16.092460] bus: 'platform': really_probe: bound device parport_pc.632 t=
o driver parport_pc
[   16.093759] bus: 'platform': remove device parport_pc.632
[   16.094563] bus: 'pci': add driver parport_pc
[   16.095416] HP CISS Driver (v 3.6.26)
[   16.096361] bus: 'cciss': registered
[   16.097164] bus: 'pci': add driver cciss
[   16.097857] bus: 'pci': add driver DAC960
[   16.098571] device: 'dac960_gam': device_add
[   16.099129] bus: 'platform': add driver floppy
[   16.099299] bus: 'pci': add driver umem
[   16.099404] MM: desc_per_page =3D 128
[   16.099437] bus: 'virtio': add driver virtio_blk
[   16.099454] bus: 'virtio': driver_probe_device: matched device virtio0 w=
ith driver virtio_blk
[   16.099461] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio0
[   16.100192] virtio-pci 0000:00:05.0: irq 40 for MSI/MSI-X
[   16.100275] virtio-pci 0000:00:05.0: irq 41 for MSI/MSI-X
[   16.123984] device: '253:0': device_add
[   16.124394] device: 'vda': device_add
[   16.126578]  vda: unknown partition table
[   16.127062] driver: 'virtio0': driver_bound: bound to device 'virtio_blk'
[   16.127076] bus: 'virtio': really_probe: bound device virtio0 to driver =
virtio_blk
[   16.127099] bus: 'virtio': driver_probe_device: matched device virtio1 w=
ith driver virtio_blk
[   16.127107] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio1
[   16.127574] virtio-pci 0000:00:06.0: irq 42 for MSI/MSI-X
[   16.127665] virtio-pci 0000:00:06.0: irq 43 for MSI/MSI-X
[   16.149430] device: '253:16': device_add
[   16.149589] device: 'vdb': device_add
[   16.150263]  vdb: unknown partition table
[   16.150664] driver: 'virtio1': driver_bound: bound to device 'virtio_blk'
[   16.150682] bus: 'virtio': really_probe: bound device virtio1 to driver =
virtio_blk
[   16.150713] bus: 'virtio': driver_probe_device: matched device virtio2 w=
ith driver virtio_blk
[   16.150720] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio2
[   16.151252] virtio-pci 0000:00:07.0: irq 44 for MSI/MSI-X
[   16.151349] virtio-pci 0000:00:07.0: irq 45 for MSI/MSI-X
[   16.164555] device: '253:32': device_add
[   16.164719] device: 'vdc': device_add
[   16.165523]  vdc: unknown partition table
[   16.165921] driver: 'virtio2': driver_bound: bound to device 'virtio_blk'
[   16.165935] bus: 'virtio': really_probe: bound device virtio2 to driver =
virtio_blk
[   16.165955] bus: 'virtio': driver_probe_device: matched device virtio3 w=
ith driver virtio_blk
[   16.165962] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio3
[   16.166412] virtio-pci 0000:00:08.0: irq 46 for MSI/MSI-X
[   16.166511] virtio-pci 0000:00:08.0: irq 47 for MSI/MSI-X
[   16.177316] device: '253:48': device_add
[   16.177454] device: 'vdd': device_add
[   16.180760]  vdd: unknown partition table
[   16.181149] driver: 'virtio3': driver_bound: bound to device 'virtio_blk'
[   16.181161] bus: 'virtio': really_probe: bound device virtio3 to driver =
virtio_blk
[   16.181181] bus: 'virtio': driver_probe_device: matched device virtio4 w=
ith driver virtio_blk
[   16.181187] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio4
[   16.181552] virtio-pci 0000:00:09.0: irq 48 for MSI/MSI-X
[   16.181633] virtio-pci 0000:00:09.0: irq 49 for MSI/MSI-X
[   16.196779] device: '253:64': device_add
[   16.196917] device: 'vde': device_add
[   16.197462]  vde: unknown partition table
[   16.197841] driver: 'virtio4': driver_bound: bound to device 'virtio_blk'
[   16.197855] bus: 'virtio': really_probe: bound device virtio4 to driver =
virtio_blk
[   16.197875] bus: 'virtio': driver_probe_device: matched device virtio5 w=
ith driver virtio_blk
[   16.197881] bus: 'virtio': really_probe: probing driver virtio_blk with =
device virtio5
[   16.198347] virtio-pci 0000:00:0a.0: irq 50 for MSI/MSI-X
[   16.198428] virtio-pci 0000:00:0a.0: irq 51 for MSI/MSI-X
[   16.213345] device: '253:80': device_add
[   16.213527] device: 'vdf': device_add
[   16.215066]  vdf: unknown partition table
[   16.215445] driver: 'virtio5': driver_bound: bound to device 'virtio_blk'
[   16.215458] bus: 'virtio': really_probe: bound device virtio5 to driver =
virtio_blk
[   16.215503] bus: 'pci': add driver sx8
[   16.215606] device: 'rbd': device_add
[   16.215646] bus: 'rbd': registered
[   16.215648] rbd: loaded rbd (rados block device)
[   16.215769] lkdtm: No crash points registered, enable through debugfs
[   16.215774] device class 'phantom': registering
[   16.215810] bus: 'pci': add driver phantom
[   16.215900] Phantom Linux Driver, version n0.9.8, init OK
[   16.215913] bus: 'i2c': add driver bh1770glc
[   16.215946] bus: 'i2c': add driver apds990x
[   16.215979] device class 'enclosure': registering
[   16.216002] bus: 'i2c': add driver apds9802als
[   16.216121] i2c-core: driver [apds9802als] using legacy suspend method
[   16.216124] i2c-core: driver [apds9802als] using legacy resume method
[   16.216142] bus: 'i2c': add driver isl29020
[   16.216174] bus: 'i2c': add driver ds1682
[   16.216206] Silicon Labs C2 port support v. 0.51.0 - (C) 2007 Rodolfo Gi=
ometti
[   16.216209] device class 'c2port': registering
[   16.216240] bus: 'i2c': add driver hmc6352
[   16.216272] bus: 'i2c': add driver max6875
[   16.216305] bus: 'pci': add driver cb710
[   16.216399] bus: 'pci': add driver pch_phub
[   16.216501] bus: 'platform': add driver kim
[   16.216550] bus: 'i2c': add driver lis3lv02d_i2c
[   16.216586] bus: 'platform': add driver pasic3
[   16.216634] bus: 'platform': remove driver pasic3
[   16.216653] driver: 'pasic3': driver_release
[   16.216661] bus: 'i2c': add driver htcpld-chip
[   16.216700] bus: 'platform': add driver i2c-htcpld
[   16.216747] bus: 'platform': remove driver i2c-htcpld
[   16.216766] driver: 'i2c-htcpld': driver_release
[   16.216774] bus: 'i2c': add driver wm8994
[   16.216810] bus: 'i2c': add driver adp5520
[   16.216843] bus: 'pci': add driver lpc_sch
[   16.216934] bus: 'pci': add driver RDC321x Southbridge
[   16.217027] bus: 'pci': add driver cs5535-mfd
[   16.217374] device: 'tgt': device_add
[   16.217565] device class 'raid_devices': registering
[   16.217594] device class 'spi_transport': registering
[   16.217618] device class 'spi_host': registering
[   16.217662] device class 'fc_host': registering
[   16.217684] device class 'fc_vports': registering
[   16.217710] device class 'fc_remote_ports': registering
[   16.217729] device class 'fc_transport': registering
[   16.217751] Loading iSCSI transport class v2.0-870.
[   16.217758] device class 'iscsi_transport': registering
[   16.217779] device class 'iscsi_endpoint': registering
[   16.217798] device class 'iscsi_iface': registering
[   16.217816] device class 'iscsi_host': registering
[   16.217834] device class 'iscsi_connection': registering
[   16.217852] device class 'iscsi_session': registering
[   16.218153] device class 'sas_host': registering
[   16.218179] device class 'sas_phy': registering
[   16.218198] device class 'sas_port': registering
[   16.218215] device class 'sas_device': registering
[   16.218233] device class 'sas_end_device': registering
[   16.218269] device class 'sas_expander': registering
[   16.218302] device class 'srp_host': registering
[   16.218323] device class 'srp_remote_ports': registering
[   16.218394] emc: device handler registered
[   16.218889] bus: 'fcoe': registered
[   16.218897] fnic: Cisco FCoE HBA Driver, ver 1.5.0.2
[   16.219217] bus: 'pci': add driver fnic
[   16.221099] bus: 'pci': add driver arcmsr
[   16.221278] bus: 'pci': add driver aic7xxx
[   16.221447] bus: 'pci': add driver aic79xx
[   16.221590] Adaptec aacraid driver 1.2-0[29800]-ms
[   16.221598] bus: 'pci': add driver aacraid
[   16.224637] aic94xx: Adaptec aic94xx SAS/SATA driver version 1.0.3 loaded
[   16.224712] bus: 'pci': add driver aic94xx
[   16.224812] isci: Intel(R) C600 SAS Controller Driver - version 1.1.0
[   16.224849] bus: 'pci': add driver isci
[   16.225065] qla2xxx [0000:00:00.0]-0005: : QLogic Fibre Channel HBA Driv=
er: 8.04.00.03-k.
[   16.225074] bus: 'pci': add driver qla2xxx
[   16.225173] Brocade BFA FC/FCOE SCSI driver - version: 3.0.23.0
[   16.225234] bus: 'pci': add driver bfa
[   16.225337] bus: 'pci': add driver hpsa
[   16.225533] DC390: clustering now enabled by default. If you get problem=
s load
[   16.225536]        with "disable_clustering=3D1" and report to maintaine=
rs
[   16.225545] bus: 'pci': add driver tmscsim
[   16.225673] bus: 'pci': add driver megaraid_legacy
[   16.225793] mpt2sas version 14.100.00.00 loaded
[   16.225854] device: 'mpt2ctl': device_add
[   16.226052] bus: 'pci': add driver mpt2sas
[   16.226160] bus: 'pci': add driver atp870u
[   16.226256] 3ware Storage Controller device driver for Linux v1.26.02.00=
3.
[   16.226267] bus: 'pci': add driver 3w-xxxx
[   16.226358] LSI 3ware SAS/SATA-RAID Controller device driver for Linux v=
3.26.02.000.
[   16.226366] bus: 'pci': add driver 3w-sas
[   16.226458] stex: Promise SuperTrak EX Driver version: 4.6.0000.4
[   16.226468] bus: 'pci': add driver stex
[   16.226605] bus: 'pci': add driver mvsas
[   16.226723] bus: 'pci': add driver mvumi
[   16.226821] libcxgbi:libcxgbi_init_module: tag itt 0x1fff, 13 bits, age =
0xf, 4 bits.
[   16.226832] libcxgbi:ddp_setup_host_page_size: system PAGE 4096, ddp idx=
 0.
[   16.226838] Chelsio T3 iSCSI Driver cxgb3i v2.0.0 (Jun. 2010)
[   16.226890] device: 'cxgb3i': device_add
[   16.227017] iscsi: registered transport (cxgb3i)
[   16.227080] Chelsio T4 iSCSI Driver cxgb4i v0.9.1 (Aug. 2010)
[   16.227096] device: 'cxgb4i': device_add
[   16.227144] iscsi: registered transport (cxgb4i)
[   16.227202] Broadcom NetXtreme II iSCSI Driver bnx2i v2.7.2.2 (Apr 25, 2=
012)
[   16.227218] device: 'bnx2i': device_add
[   16.227267] iscsi: registered transport (bnx2i)
[   16.235997] device: 'be2iscsi': device_add
[   16.236194] iscsi: registered transport (be2iscsi)
[   16.236210] bus: 'pci': add driver be2iscsi
[   16.236320] device class 'pmcsas': registering
[   16.236376] bus: 'pci': add driver PMC MaxRAID
[   16.236547] bus: 'virtio': add driver virtio_scsi
[   16.236596] hv_vmbus: registering driver hv_storvsc
[   16.236604] osst :I: Tape driver with OnStream support version 0.99.4
[   16.236604] osst :I: $Id: osst.c,v 1.73 2005/01/01 21:13:34 wriede Exp $
[   16.236608] device class 'onstream_tape': registering
[   16.236651] bus: 'scsi': add driver osst
[   16.236755] device class 'scsi_disk': registering
[   16.236778] bus: 'scsi': add driver sd
[   16.236826] bus: 'scsi': add driver sr
[   16.236862] device class 'scsi_generic': registering
[   16.254038] device: 'pseudo_0': device_add
[   16.254093] bus: 'pseudo': registered
[   16.254100] bus: 'pseudo': add driver scsi_debug
[   16.254302] device: 'adapter0': device_add
[   16.254312] bus: 'pseudo': add device adapter0
[   16.254342] bus: 'pseudo': driver_probe_device: matched device adapter0 =
with driver scsi_debug
[   16.254351] bus: 'pseudo': really_probe: probing driver scsi_debug with =
device adapter0
[   16.254844] scsi_debug: host protection
[   16.254850] scsi0 : scsi_debug, version 1.82 [20100324], dev_size_mb=3D8=
, opts=3D0x0
[   16.254990] device: 'host0': device_add
[   16.255003] bus: 'scsi': add device host0
[   16.255173] device: 'host0': device_add
[   16.256868] scsi 0:0:0:0: Direct-Access     Linux    scsi_debug       00=
04 PQ: 0 ANSI: 5
[   16.256890] device: 'target0:0:0': device_add
[   16.256957] bus: 'scsi': add device target0:0:0
[   16.257191] device: '0:0:0:0': device_add
[   16.257201] bus: 'scsi': add device 0:0:0:0
[   16.257271] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver osst
[   16.257278] bus: 'scsi': really_probe: probing driver osst with device 0=
:0:0:0
[   16.257297] osst: probe of 0:0:0:0 rejects match -19
[   16.257311] bus: 'scsi': driver_probe_device: matched device 0:0:0:0 wit=
h driver sd
[   16.257318] bus: 'scsi': really_probe: probing driver sd with device 0:0=
:0:0
[   16.257724] device: '0:0:0:0': device_add
[   16.258041] driver: '0:0:0:0': driver_bound: bound to device 'sd'
[   16.258056] bus: 'scsi': really_probe: bound device 0:0:0:0 to driver sd
[   16.259892] device: '0:0:0:0': device_add
[   16.260586] device: 'sg0': device_add
[   16.261292] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.261628] device: '0:0:0:0': device_add
[   16.262620] driver: 'adapter0': driver_bound: bound to device 'scsi_debu=
g'
[   16.262631] bus: 'pseudo': really_probe: bound device adapter0 to driver=
 scsi_debug
[   16.262731] bus: 'pci': add driver ahci
[   16.262891] bus: 'pci': add driver acard-ahci
[   16.262988] bus: 'platform': add driver ahci
[   16.263040] bus: 'platform': remove driver ahci
[   16.263059] driver: 'ahci': driver_release
[   16.263067] bus: 'pci': add driver sata_inic162x
[   16.263171] bus: 'hsi': add driver hsi_char
[   16.263194] HSI/SSI char device loaded
[   16.263327] device: 'dummy0': device_add
[   16.263545] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S.=
 Miller (davem@redhat.com)
[   16.263582] device: 'eql': device_add
[   16.264758] D-Link DE-620 pocket adapter io 0x378, which is busy.
[   16.264782] bus: 'mdio_bus': add driver Marvell 88E1101
[   16.264812] bus: 'mdio_bus': add driver Marvell 88E1112
[   16.264837] bus: 'mdio_bus': add driver Marvell 88E1111
[   16.264866] bus: 'mdio_bus': add driver Marvell 88E1118
[   16.264894] bus: 'mdio_bus': add driver Marvell 88E1121R
[   16.264920] bus: 'mdio_bus': add driver Marvell 88E1318S
[   16.264945] bus: 'mdio_bus': add driver Marvell 88E1145
[   16.264971] bus: 'mdio_bus': add driver Marvell 88E1149R
[   16.264997] bus: 'mdio_bus': add driver Marvell 88E1240
[   16.265026] bus: 'mdio_bus': add driver Davicom DM9161E
[   16.265064] bus: 'mdio_bus': add driver Davicom DM9161A
[   16.265090] bus: 'mdio_bus': add driver Davicom DM9131
[   16.265116] bus: 'mdio_bus': add driver Cicada Cis8201
[   16.265142] bus: 'mdio_bus': add driver Cicada Cis8204
[   16.265168] bus: 'mdio_bus': add driver LXT970
[   16.265193] bus: 'mdio_bus': add driver LXT971
[   16.265218] bus: 'mdio_bus': add driver LXT973
[   16.265243] bus: 'mdio_bus': add driver SMSC LAN83C185
[   16.265270] bus: 'mdio_bus': add driver SMSC LAN8187
[   16.265296] bus: 'mdio_bus': add driver SMSC LAN8700
[   16.265322] bus: 'mdio_bus': add driver SMSC LAN911x Internal PHY
[   16.265348] bus: 'mdio_bus': add driver SMSC LAN8710/LAN8720
[   16.265377] bus: 'mdio_bus': add driver Vitesse VSC8244
[   16.265402] bus: 'mdio_bus': add driver Vitesse VSC8221
[   16.265433] bus: 'mdio_bus': add driver ICPlus IP175C
[   16.265460] bus: 'mdio_bus': add driver ICPlus IP1001
[   16.265485] bus: 'mdio_bus': add driver ICPlus IP101A/G
[   16.265515] bus: 'mdio_bus': add driver RTL821x Gigabit Ethernet
[   16.265542] bus: 'mdio_bus': add driver STe101p
[   16.265569] bus: 'mdio_bus': add driver STe100p
[   16.265594] bus: 'mdio_bus': add driver Micrel KS8737
[   16.265620] bus: 'mdio_bus': add driver Micrel KS8041
[   16.265645] bus: 'mdio_bus': add driver Micrel KS8051
[   16.265673] bus: 'mdio_bus': add driver Micrel KS8001 or KS8721
[   16.265706] bus: 'mdio_bus': add driver Micrel KSZ9021 Gigabit PHY
[   16.265735] bus: 'platform': add driver mdio-mux-gpio
[   16.265912] bus: 'virtio': add driver virtio_net
[   16.265981] ipddp.c:v0.01 8/28/97 Bradford W. Johnson <johns393@maroon.t=
c.umn.edu>
[   16.266012] device: 'ipddp0': device_add
[   16.267979] ipddp0: Appletalk-IP Encap. mode by Bradford W. Johnson <joh=
ns393@maroon.tc.umn.edu>
[   16.268182] bus: 'pci': add driver ne2k-pci
[   16.268316] bus: 'pcmcia': add driver axnet_cs
[   16.268351] bus: 'pci': add driver acenic
[   16.268456] bus: 'pcmcia': add driver nmclan_cs
[   16.268491] Atheros(R) L2 Ethernet Driver - version 2.2.3
[   16.268494] Copyright (c) 2007 Atheros Corporation.
[   16.268502] bus: 'pci': add driver atl2
[   16.268603] bus: 'pci': add driver ATL1E
[   16.268708] bus: 'pci': add driver atl1c
[   16.268813] bus: 'pci': add driver b44
[   16.268915] bus: 'ssb': add driver b44
[   16.268949] bus: 'pci': add driver bnx2
[   16.269047] cnic: Broadcom NetXtreme II CNIC Driver cnic v2.5.12 (June 2=
9, 2012)
[   16.269279] bnx2x: Broadcom NetXtreme II 5771x/578xx 10/20-Gigabit Ether=
net Driver bnx2x 1.72.51-0 (2012/06/18)
[   16.269525] bus: 'pci': add driver bnx2x
[   16.269634] bus: 'platform': add driver calxedaxgmac
[   16.269682] bus: 'pci': add driver cxgb
[   16.269796] bus: 'pci': add driver cxgb3
[   16.270153] bus: 'pci': add driver cxgb4
[   16.270365] bus: 'pci': add driver cxgb4vf
[   16.270465] enic: Cisco VIC Ethernet NIC Driver, ver 2.1.1.39
[   16.270475] bus: 'pci': add driver enic
[   16.270575] bus: 'platform': add driver dnet
[   16.270641] DE600: port 0x378 busy
[   16.270659] e100: Intel(R) PRO/100 Network Driver, 3.5.24-k2-NAPI
[   16.270662] e100: Copyright(c) 1999-2006 Intel Corporation
[   16.270670] bus: 'pci': add driver e100
[   16.270787] e1000: Intel(R) PRO/1000 Network Driver - version 7.3.21-k8-=
NAPI
[   16.270790] e1000: Copyright (c) 1999-2006 Intel Corporation.
[   16.270841] bus: 'pci': add driver e1000
[   16.270894] bus: 'pci': driver_probe_device: matched device 0000:00:03.0=
 with driver e1000
[   16.270902] bus: 'pci': really_probe: probing driver e1000 with device 0=
000:00:03.0
[   16.271085] e1000 0000:00:03.0: setting latency timer to 64
[   16.426712] Floppy drive(s): fd0 is 1.44M
[   16.437162] sd 0:0:0:0: [sda] 16384 512-byte logical blocks: (8.38 MB/8.=
00 MiB)
[   16.440209] sd 0:0:0:0: [sda] Write Protect is off
[   16.440880] sd 0:0:0:0: [sda] Mode Sense: 73 00 10 08
[   16.442616] FDC 0 is a S82078B
[   16.443646] Registering platform device 'floppy.0'. Parent at platform
[   16.444922] device: 'floppy.0': device_add
[   16.445510] bus: 'platform': add device floppy.0
[   16.446294] bus: 'platform': driver_probe_device: matched device floppy.=
0 with driver floppy
[   16.447409] bus: 'platform': really_probe: probing driver floppy with de=
vice floppy.0
[   16.448656] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 supports DPO and FUA
[   16.449899] device: '259:0': device_add
[   16.450706] device: 'sda': device_add
[   16.452142] driver: 'floppy.0': driver_bound: bound to device 'floppy'
[   16.453039] bus: 'platform': really_probe: bound device floppy.0 to driv=
er floppy
[   16.454120] device: '2:0': device_add
[   16.454799] device: 'fd0': device_add
[   16.485428]  sda: unknown partition table
[   16.509678] sd 0:0:0:0: [sda] Attached SCSI disk
[   16.761157] device: 'eth0': device_add
[   16.762155] e1000 0000:00:03.0: eth0: (PCI:33MHz:32-bit) 52:54:00:12:34:=
56
[   16.763160] e1000 0000:00:03.0: eth0: Intel(R) PRO/1000 Network Connecti=
on
[   16.764313] driver: '0000:00:03.0': driver_bound: bound to device 'e1000'
[   16.765184] bus: 'pci': really_probe: bound device 0000:00:03.0 to drive=
r e1000
[   16.768166] e1000e: Intel(R) PRO/1000 Network Driver - 2.0.0-k
[   16.768905] e1000e: Copyright(c) 1999 - 2012 Intel Corporation.
[   16.769649] bus: 'pci': add driver e1000e
[   16.770285] igbvf: Intel(R) Gigabit Virtual Function Network Driver - ve=
rsion 2.0.1-k
[   16.771243] igbvf: Copyright (c) 2009 - 2012 Intel Corporation.
[   16.772161] bus: 'pci': add driver igbvf
[   16.773095] jme: JMicron JMC2XX ethernet driver version 1.0.8
[   16.773824] bus: 'pci': add driver jme
[   16.776483] myri10ge: Version 1.5.3-1.534
[   16.777025] bus: 'pci': add driver myri10ge
[   16.777777] bus: 'pci': add driver natsemi
[   16.778513] bus: 'pci': add driver forcedeth
[   16.779281] pch_gbe: EG20T PCH Gigabit Ethernet Driver - version 1.01
[   16.780308] bus: 'pci': add driver pch_gbe
[   16.781056] bus: 'pci': add driver qla3xxx
[   16.781858] QLogic 1/10 GbE Converged/Intelligent Ethernet Driver v5.0.29
[   16.795908] bus: 'pci': add driver qlcnic
[   16.796659] QLogic/NetXen Network Driver v4.0.80
[   16.797276] bus: 'pci': add driver netxen_nic
[   16.797938] bus: 'pci': add driver 8139cp
[   16.800588] atp.c:v1.09=3Dac 2002/10/01 Donald Becker <becker@scyld.com>
[   16.801532] bus: 'pci': add driver r8169
[   16.802336] bus: 'pci': add driver sc92031
[   16.803074] tlan: ThunderLAN driver v1.17
[   16.803601] bus: 'pci': add driver tlan
[   16.804592] tlan: 0 devices installed, PCI: 0  EISA: 0
[   16.805276] bus: 'pci': remove driver tlan
[   16.805836] driver: 'tlan': driver_release
[   16.809829] mkiss: AX.25 Multikiss, Hans Albas PE1AYX
[   16.810484] YAM driver version 0.8 by F1OAT/F6FBB
[   16.811195] device: 'yam0': device_add
[   16.819112] device: 'yam1': device_add
[   16.819902] device: 'yam2': device_add
[   16.820782] device: 'yam3': device_add
[   16.821602] baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   16.821602] baycom_ser_fdx: version 0.10
[   16.823173] device: 'bcsf0': device_add
[   16.823971] device: 'bcsf1': device_add
[   16.824861] device: 'bcsf2': device_add
[   16.825650] device: 'bcsf3': device_add
[   16.826401] hdlcdrv: (C) 1996-2000 Thomas Sailer HB9JNX/AE4WA
[   16.827258] hdlcdrv: version 0.8
[   16.827752] baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA
[   16.827752] baycom_par: version 0.9
[   16.829362] device: 'bcp0': device_add
[   16.839324] device: 'bcp1': device_add
[   16.840241] device: 'bcp2': device_add
[   16.840923] device: 'bcp3': device_add
[   16.841652] PPP generic driver version 2.4.2
[   16.842445] device class 'ppp': registering
[   16.843112] device: 'ppp': device_add
[   16.852232] PPP BSD Compression module registered
[   16.852850] PPP MPPE Compression module registered
[   16.853523] NET: Registered protocol family 24
[   16.854258] PPTP driver version 0.8.5
[   16.855494] cycx_drv: Cyclom 2X Support Module v0.6 (c) 1998-2003 Arnald=
o Carvalho de Melo <acme@conectiva.com.br>
[   16.866131] cyclomx: CYCLOM 2X(tm) Sync Card Driver v0.11 (c) 1998-2003 =
Arnaldo Carvalho de Melo <acme@conectiva.com.br>
[   16.867446] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2=
=2E2kmprq
[   16.868286] ipw2200: Copyright(c) 2003-2006 Intel Corporation
[   16.868913] bus: 'pci': add driver ipw2200
[   16.880397] libipw: 802.11 data/management/control stack, git-1.1.13
[   16.881340] libipw: Copyright (C) 2004-2005 Intel Corporation <jketreno@=
linux.intel.com>
[   16.882518] orinoco 0.15 (David Gibson <hermes@gibson.dropbear.id.au>, P=
avel Roskin <proski@gnu.org>, et al)
[   16.883959] orinoco_pci 0.15 (Pavel Roskin <proski@gnu.org>, David Gibso=
n <hermes@gibson.dropbear.id.au> & Jean Tourrilhes <jt@hpl.hp.com>)
[   16.898820] bus: 'pci': add driver orinoco_pci
[   16.899423] airo(): Probing for PCI adapters
[   16.899885] bus: 'pci': add driver airo
[   16.900452] airo(): Finished probing for PCI adapters
[   16.900988] Loaded prism54 driver, version 1.2
[   16.901465] bus: 'pci': add driver prism54
[   16.902037] bus: 'bcma': add driver b43
[   16.902476] bus: 'ssb': add driver b43
[   16.902897] Broadcom 43xx driver loaded [ Features: PNL ]
[   16.903466] bus: 'ssb': add driver b43legacy
[   16.903942] Broadcom 43xx-legacy driver loaded [ Features: PLI ]
[   16.904744] bus: 'pci': add driver rtl8192ce
[   16.905272] bus: 'pci': add driver rtl8192se
[   16.905861] bus: 'pci': add driver rtl8192de
[   16.906499] bus: 'pcmcia': add driver wl3501_cs
[   16.919856] bus: 'pci': add driver mwl8k
[   16.920451] iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection=
 driver for Linux, in-tree:s
[   16.921391] iwl3945: Copyright(c) 2003-2011 Intel Corporation
[   16.922018] bus: 'pci': add driver iwl3945
[   16.922537] device class 'mac80211_hwsim': registering
[   16.923098] mac80211_hwsim: Initializing radio 0
[   16.923721] device: 'hwsim0': device_add
[   16.924346] device: 'phy0': device_add
[   16.924962] cfg80211: Updating information on frequency 2412 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.926021] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.926800] cfg80211: Updating information on frequency 2417 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.927849] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.928733] cfg80211: Updating information on frequency 2422 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.930066] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.931152] cfg80211: Updating information on frequency 2427 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.933055] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.934155] cfg80211: Updating information on frequency 2432 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.935636] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.936751] cfg80211: Updating information on frequency 2437 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.938245] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.939341] cfg80211: Updating information on frequency 2442 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.947185] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.948161] cfg80211: Updating information on frequency 2447 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.949220] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.950001] cfg80211: Updating information on frequency 2452 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.951051] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   16.951826] cfg80211: Updating information on frequency 2457 MHz for a 2=
0 MHz width channel with regulatory rule:
[   16.952964] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.036965] cfg80211: Updating information on frequency 2462 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.038041] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.038820] cfg80211: Updating information on frequency 2467 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.039870] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, =
2000 mBm)
[   17.054543] cfg80211: Updating information on frequency 2472 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.055648] cfg80211: 2457000 KHz - 2482000 KHz @ 20000 KHz), (600 mBi, =
2000 mBm)
[   17.056501] cfg80211: Updating information on frequency 2484 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.057604] cfg80211: 2474000 KHz - 2494000 KHz @ 20000 KHz), (600 mBi, =
2000 mBm)
[   17.058413] cfg80211: Updating information on frequency 5180 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.059512] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.060358] cfg80211: Updating information on frequency 5200 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.061410] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.062180] cfg80211: Updating information on frequency 5220 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.063227] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.064049] cfg80211: Updating information on frequency 5240 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.065113] cfg80211: 5170000 KHz - 5250000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.065893] cfg80211: Disabling freq 5260 MHz
[   17.066354] cfg80211: Disabling freq 5280 MHz
[   17.066972] cfg80211: Disabling freq 5300 MHz
[   17.067441] cfg80211: Disabling freq 5320 MHz
[   17.067901] cfg80211: Disabling freq 5500 MHz
[   17.069025] cfg80211: Disabling freq 5520 MHz
[   17.069495] cfg80211: Disabling freq 5540 MHz
[   17.069953] cfg80211: Disabling freq 5560 MHz
[   17.070413] cfg80211: Disabling freq 5580 MHz
[   17.070872] cfg80211: Disabling freq 5600 MHz
[   17.071333] cfg80211: Disabling freq 5620 MHz
[   17.071801] cfg80211: Disabling freq 5640 MHz
[   17.084905] cfg80211: Disabling freq 5660 MHz
[   17.085396] cfg80211: Disabling freq 5680 MHz
[   17.085880] cfg80211: Disabling freq 5700 MHz
[   17.086362] cfg80211: Updating information on frequency 5745 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.087451] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.088290] cfg80211: Updating information on frequency 5765 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.089425] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.090194] cfg80211: Updating information on frequency 5785 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.091253] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.092068] cfg80211: Updating information on frequency 5805 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.093138] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.093924] cfg80211: Updating information on frequency 5825 MHz for a 2=
0 MHz width channel with regulatory rule:
[   17.094979] cfg80211: 5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, =
2000 mBm)
[   17.096315] ieee80211 phy0: Failed to select rate control algorithm
[   17.096986] ieee80211 phy0: Failed to initialize rate control algorithm
[   17.208265] mac80211_hwsim: ieee80211_register_hw failed (-2)
[   17.208892] device: 'hwsim0': device_unregister
[   17.209420] device: 'hwsim0': device_create_release
[   17.210020] device class 'mac80211_hwsim': unregistering
[   17.210595] class 'mac80211_hwsim': release.
[   17.211045] class_create_release called for mac80211_hwsim
[   17.211708] bus: 'pci': add driver mwifiex_pcie
[   17.213145] VMware vmxnet3 virtual NIC driver - version 1.1.29.0-k-NAPI
[   17.213856] bus: 'pci': add driver vmxnet3
[   17.214560] bus: 'bcma': add driver brcmsmac
[   17.215246] bus: 'firewire': registered
[   17.215793] bus: 'pci': add driver firewire_ohci
[   17.216572] bus: 'firewire': add driver firewire_net
[   17.218598] bus: 'pci': add driver nosy
[   17.219095] device class 'uio': registering
[   17.219572] bus: 'pci': add driver hilscher
[   17.220261] bus: 'platform': add driver uio_pdrv_genirq
[   17.220974] bus: 'pci': add driver aectc
[   17.221481] bus: 'pci': add driver sercos3
[   17.221997] bus: 'pci': add driver netx
[   17.222537] bus: 'pci': add driver yenta_cardbus
[   17.223120] device class 'aoe': registering
[   17.223593] device: 'err': device_add
[   17.225565] device: 'discover': device_add
[   17.226221] device: 'interfaces': device_add
[   17.226906] device: 'revalidate': device_add
[   17.227621] device: 'flush': device_add
[   17.228496] aoe: AoE v47 initialised.
[   17.229087] paride: bpck registered as protocol 0
[   17.229586] paride: comm registered as protocol 1
[   17.230080] paride: epat registered as protocol 2
[   17.230576] paride: frpw registered as protocol 3
[   17.231066] paride: friq registered as protocol 4
[   17.231561] paride: fit2 registered as protocol 5
[   17.232194] paride: fit3 registered as protocol 6
[   17.232752] paride: on26 registered as protocol 7
[   17.233265] bpck6: BACKPACK Protocol Driver V2.0.2
[   17.233797] bpck6: Copyright 2001 by Micro Solutions, Inc., DeKalb IL. U=
SA
[   17.234540] paride: bpck6 registered as protocol 8
[   17.235207] pd: pd version 1.05, major 45, cluster 64, nice 0
[   19.962468] pda: Autoprobe failed
[   19.962935] pd: no valid drive found
[   19.963929] pcd: pcd version 1.07, major 46, nice 0
[   23.845739] pcd0: Autoprobe failed
[   23.846231] pcd: No CD-ROM drive found
[   23.847036] pf: pf version 1.04, major 47, cluster 64, nice 0
[   23.847805] pf: No ATAPI disk detected
[   23.848566] pg: pg version 1.02, major 97
[   27.777868] pga: Autoprobe failed
[   27.778380] pg: No ATAPI device detected
[   27.778885] bus: 'pnp': add driver i8042 kbd
[   27.779535] bus: 'pnp': driver_probe_device: matched device 00:02 with d=
river i8042 kbd
[   27.781102] bus: 'pnp': really_probe: probing driver i8042 kbd with devi=
ce 00:02
[   27.782277] driver: '00:02': driver_bound: bound to device 'i8042 kbd'
[   27.783199] bus: 'pnp': really_probe: bound device 00:02 to driver i8042=
 kbd
[   27.784683] bus: 'pnp': add driver i8042 aux
[   27.785351] bus: 'pnp': driver_probe_device: matched device 00:03 with d=
river i8042 aux
[   27.786469] bus: 'pnp': really_probe: probing driver i8042 aux with devi=
ce 00:03
[   27.787509] driver: '00:03': driver_bound: bound to device 'i8042 aux'
[   27.788913] bus: 'pnp': really_probe: bound device 00:03 to driver i8042=
 aux
[   27.789948] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x6=
0,0x64 irq 1,12
[   27.791178] Registering platform device 'i8042'. Parent at platform
[   27.792583] device: 'i8042': device_add
[   27.793166] bus: 'platform': add device i8042
[   27.793877] bus: 'platform': add driver i8042
[   27.794550] bus: 'platform': driver_probe_device: matched device i8042 w=
ith driver i8042
[   27.795667] bus: 'platform': really_probe: probing driver i8042 with dev=
ice i8042
[   27.812875] serio: i8042 KBD port at 0x60,0x64 irq 1
[   27.813965] device: 'serio0': device_add
[   27.814602] bus: 'serio': add device serio0
[   27.815482] serio: i8042 AUX port at 0x60,0x64 irq 12
[   27.816586] device: 'serio1': device_add
[   27.817184] bus: 'serio': add device serio1
[   27.817823] driver: 'i8042': driver_bound: bound to device 'i8042'
[   27.818694] bus: 'platform': really_probe: bound device i8042 to driver =
i8042
[   27.819733] parport0: cannot grant exclusive access for device parkbd
[   27.821239] bus: 'pci': add driver pcips2
[   27.821968] bus: 'serio': add driver serio_raw
[   27.822661] bus: 'pci': add driver FM801_gameport
[   27.823488] bus: 'pnp': add driver ns558
[   27.902445] device: 'event0': device_add
[   27.903561] evbug: Connected device: input0 (Power Button at LNXPWRBN/bu=
tton/input0)
[   27.905212] bus: 'serio': add driver atkbd
[   27.905895] bus: 'serio': driver_probe_device: matched device serio0 wit=
h driver atkbd
[   27.907000] bus: 'serio': really_probe: probing driver atkbd with device=
 serio0
[   27.909589] device: 'input1': device_add
[   27.910456] input: AT Translated Set 2 keyboard as /devices/platform/i80=
42/serio0/input/input1
[   27.911805] device: 'event1': device_add
[   27.912214] I2O subsystem v1.325
[   27.912223] i2o: max drivers =3D 8
[   27.912257] bus: 'i2o': registered
[   27.927805] evbug: Connected device: input1 (AT Translated Set 2 keyboar=
d at isa0060/serio0/input0)
[   27.928373] bus: 'i2o': add driver exec-osm
[   27.928424] bus: 'pci': add driver PCI_I2O
[   27.928519] I2O ProcFS OSM v1.316
[   27.928530] bus: 'i2o': add driver proc-osm
[   27.928585] bus: 'platform': add driver 88pm860x-rtc
[   27.928636] bus: 'platform': add driver da9052-rtc
[   27.928684] bus: 'platform': add driver rtc-ds1286
[   27.928742] bus: 'i2c': add driver rtc-ds1307
[   27.928782] bus: 'i2c': add driver rtc-ds1374
[   27.928815] bus: 'platform': add driver rtc-ds1742
[   27.928859] bus: 'i2c': add driver rtc-ds3232
[   27.928896] bus: 'i2c': add driver rtc-em3027
[   27.928930] bus: 'i2c': add driver rtc-fm3130
[   27.928966] bus: 'i2c': add driver rtc-m41t80
[   27.929029] bus: 'platform': add driver rtc-m48t86
[   27.929075] bus: 'i2c': add driver rtc-max6900
[   27.929107] bus: 'platform': add driver max8925-rtc
[   27.930220] bus: 'i2c': add driver rtc-pcf8563
[   27.930254] bus: 'i2c': add driver pcf8583
[   27.930291] bus: 'i2c': add driver rtc-rs5c372
[   27.930328] bus: 'i2c': add driver rtc-rv3029c2
[   27.930361] bus: 'i2c': add driver rtc-rx8581
[   27.930397] bus: 'i2c': add driver rtc-s35390a
[   27.930430] bus: 'platform': add driver rtc-test
[   27.930483] Registering platform device 'rtc-test.0'. Parent at platform
[   27.930488] device: 'rtc-test.0': device_add
[   27.930498] bus: 'platform': add device rtc-test.0
[   27.930617] bus: 'platform': driver_probe_device: matched device rtc-tes=
t.0 with driver rtc-test
[   27.930624] bus: 'platform': really_probe: probing driver rtc-test with =
device rtc-test.0
[   27.930907] device: 'rtc0': device_add
[   27.965543] driver: 'serio0': driver_bound: bound to device 'atkbd'
[   27.966413] rtc-test rtc-test.0: rtc core: registered test as rtc0
[   27.966418] driver: 'rtc-test.0': driver_bound: bound to device 'rtc-tes=
t'
[   27.966429] bus: 'platform': really_probe: bound device rtc-test.0 to dr=
iver rtc-test
[   27.966458] Registering platform device 'rtc-test.1'. Parent at platform
[   27.966463] device: 'rtc-test.1': device_add
[   27.966475] bus: 'platform': add device rtc-test.1
[   27.966597] bus: 'platform': driver_probe_device: matched device rtc-tes=
t.1 with driver rtc-test
[   27.966604] bus: 'platform': really_probe: probing driver rtc-test with =
device rtc-test.1
[   27.966647] device: 'rtc1': device_add
[   27.985532] bus: 'serio': really_probe: bound device serio0 to driver at=
kbd
[   27.986323] rtc-test rtc-test.1: rtc core: registered test as rtc1
[   27.986328] driver: 'rtc-test.1': driver_bound: bound to device 'rtc-tes=
t'
[   27.986338] bus: 'platform': really_probe: bound device rtc-test.1 to dr=
iver rtc-test
[   27.986373] bus: 'platform': add driver v3020
[   27.986437] bus: 'i2c': add driver smbus_alert
[   27.986471] i2c /dev entries driver
[   27.986487] device class 'i2c-dev': registering
[   27.986537] bus: 'pci': add driver ali1535_smbus
[   27.986635] bus: 'pci': add driver ali15x3_smbus
[   27.986741] bus: 'pci': add driver amd8111_smbus2
[   27.986840] bus: 'pci': add driver i801_smbus
[   27.986944] bus: 'pci': add driver piix4_smbus
[   27.986976] bus: 'pci': driver_probe_device: matched device 0000:00:01.3=
 with driver piix4_smbus
[   27.986984] bus: 'pci': really_probe: probing driver piix4_smbus with de=
vice 0000:00:01.3
[   27.987100] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0xb100, r=
evision 0
[   27.989195] device: 'i2c-0': device_add
[   27.989208] bus: 'i2c': add device i2c-0
[   27.989418] device: 'i2c-0': device_add
[   28.013711] bus: 'serio': driver_probe_device: matched device serio1 wit=
h driver atkbd
[   28.014234] driver: '0000:00:01.3': driver_bound: bound to device 'piix4=
_smbus'
[   28.014250] bus: 'pci': really_probe: bound device 0000:00:01.3 to drive=
r piix4_smbus
[   28.014347] bus: 'pci': add driver sis5595_smbus
[   28.014450] bus: 'pci': add driver sis630_smbus
[   28.014542] bus: 'pci': add driver vt596_smbus
[   28.014637] bus: 'pci': add driver i2c_eg20t
[   28.014739] bus: 'pci': add driver i2c-intel-mid
[   28.014839] bus: 'platform': add driver ocores-i2c
[   28.014926] bus: 'pci': add driver ce4100_i2c
[   28.015016] bus: 'platform': add driver simtec-i2c
[   28.015067] i2c-parport: adapter type unspecified
[   28.015070] i2c-parport-light: adapter type unspecified
[   28.015080] bus: 'serio': add driver taos-evm
[   28.015184] bus: 'platform': add driver i2c-mux-gpio
[   28.015234] Driver for 1-wire Dallas network protocol.
[   28.015264] bus: 'w1': registered
[   28.015270] bus: 'w1': add driver w1_master_driver
[   28.015296] bus: 'w1': add driver w1_slave_driver
[   28.015332] bus: 'pci': add driver matrox_w1
[   28.015423] bus: 'platform': add driver w1-gpio
[   28.015480] bus: 'platform': remove driver w1-gpio
[   28.015498] driver: 'w1-gpio': driver_release
[   28.015617] 1-Wire driver for the DS2760 battery monitor  chip  - (c) 20=
04-2005, Szabolcs Gyurko
[   28.015643] bus: 'platform': add driver pda-power
[   28.015694] bus: 'platform': add driver wm831x-backup
[   28.015762] device: 'test_ac': device_add
[   28.015896] BUG: unable to handle kernel paging request at 853a92a8
[   28.015936] IP: [<817735c1>] strcmp+0x1c/0x3e
[   28.015943] *pde =3D 0530f067 *pte =3D 053a9160=20
[   28.015952] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   28.015965] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc3-04525-ge838580=
 #605 =20
[   28.015968] EIP: 0060:[<817735c1>] EFLAGS: 00010246 CPU: 0
[   28.015972] EIP is at strcmp+0x1c/0x3e
[   28.015975] EAX: 853a92a8 EBX: 86bf0420 ECX: 8111a623 EDX: 860ff8f0
[   28.015979] ESI: 853a92a8 EDI: 860ff8f0 EBP: 8b43bf50 ESP: 8b43bf48
[   28.015982]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   28.015986] CR0: 8005003b CR2: 853a92a8 CR3: 043e4000 CR4: 00000690
[   28.015996] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[   28.016000] DR6: ffff0ff0 DR7: 00000400
[   28.016007] Process swapper/0 (pid: 1, ti=3D8b43a000 task=3D8b440000 tas=
k.ti=3D8b43a000)
[   28.016009] Stack:
[   28.016025]  869a1de0 83c75a1c 8b43bf64 8260c2ee 86bf0420 860ff8f0 83c75=
a1c 8b43bf7c
[   28.016040]  8260c7a3 00000000 83c759a4 00000001 00000000 8b43bf8c 825bb=
a00 83c759a4
[   28.016055]  85344400 8b43bfa0 825bb2ad 00000000 84224a0f 83c759a4 8b43b=
fb4 84224a48
[   28.016057] Call Trace:
[   28.016084]  [<8260c2ee>] led_trigger_register+0x70/0x242
[   28.016092]  [<8260c7a3>] led_trigger_register_simple+0x5a/0x10b
[   28.016102]  [<825bba00>] power_supply_create_triggers+0x31e/0x34a
[   28.016108]  [<825bb2ad>] power_supply_register+0x2a2/0x351
[   28.016187]  [<84224a0f>] ? wm831x_backup_driver_init+0x2b/0x2b
[   28.016196]  [<84224a48>] test_power_init+0x39/0xee
[   28.016202]  [<84224a0f>] ? wm831x_backup_driver_init+0x2b/0x2b
[   28.016216]  [<8419c998>] do_one_initcall+0xf7/0x305
[   28.016222]  [<8419cf33>] kernel_init+0x38d/0x52e
[   28.016229]  [<8419cba6>] ? do_one_initcall+0x305/0x305
[   28.016248]  [<82cc3c82>] kernel_thread_helper+0x6/0x10
[   28.016345] Code: 89 d8 83 15 84 b6 bf 84 00 5e 5b 5e 5f 5d c3 55 89 e5 =
57 56 e8 dd 06 55 01 83 05 88 b6 bf 84 01 83 15 8c b6 bf 84 00 89 c6 89 d7 =
<ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 83 05 90 b6 bf
[   28.016352] EIP: [<817735c1>] strcmp+0x1c/0x3e SS:ESP 0068:8b43bf48
[   28.016355] CR2: 00000000853a92a8
[   28.016378] ---[ end trace 3e54bc74ba4f0207 ]---
[   28.016436] swapper/0 (1) used greatest stack depth: 5972 bytes left
[   28.016459] Kernel panic - not syncing: Attempted to kill init! exitcode=
=3D0x00000009
[   28.016459]=20
[   28.020402] Rebooting in 10 seconds..
--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="config-3.6.0-rc3-04525-ge838580"

#
# Automatically generated file; DO NOT EDIT.
# Linux/i386 3.6.0-rc3 Kernel Configuration
#
# CONFIG_64BIT is not set
CONFIG_X86_32=y
# CONFIG_X86_64 is not set
CONFIG_X86=y
CONFIG_INSTRUCTION_DECODER=y
CONFIG_OUTPUT_FORMAT="elf32-i386"
CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_HAVE_LATENCYTOP_SUPPORT=y
CONFIG_MMU=y
CONFIG_NEED_DMA_MAP_STATE=y
CONFIG_NEED_SG_DMA_LENGTH=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_GENERIC_GPIO=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
# CONFIG_RWSEM_GENERIC_SPINLOCK is not set
CONFIG_RWSEM_XCHGADD_ALGORITHM=y
CONFIG_GENERIC_CALIBRATE_DELAY=y
CONFIG_ARCH_HAS_CPU_RELAX=y
CONFIG_ARCH_HAS_DEFAULT_IDLE=y
CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
CONFIG_ARCH_HAS_CPU_AUTOPROBE=y
CONFIG_HAVE_SETUP_PER_CPU_AREA=y
CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
CONFIG_ARCH_HIBERNATION_POSSIBLE=y
CONFIG_ARCH_SUSPEND_POSSIBLE=y
# CONFIG_ZONE_DMA32 is not set
# CONFIG_AUDIT_ARCH is not set
CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_HAVE_INTEL_TXT=y
CONFIG_X86_32_SMP=y
CONFIG_X86_HT=y
CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
CONFIG_ARCH_SUPPORTS_UPROBES=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
CONFIG_CONSTRUCTORS=y
CONFIG_HAVE_IRQ_WORK=y
CONFIG_IRQ_WORK=y
CONFIG_BUILDTIME_EXTABLE_SORT=y

#
# General setup
#
CONFIG_EXPERIMENTAL=y
CONFIG_INIT_ENV_ARG_LIMIT=32
CONFIG_CROSS_COMPILE=""
CONFIG_LOCALVERSION=""
CONFIG_LOCALVERSION_AUTO=y
CONFIG_HAVE_KERNEL_GZIP=y
CONFIG_HAVE_KERNEL_BZIP2=y
CONFIG_HAVE_KERNEL_LZMA=y
CONFIG_HAVE_KERNEL_XZ=y
CONFIG_HAVE_KERNEL_LZO=y
# CONFIG_KERNEL_GZIP is not set
CONFIG_KERNEL_BZIP2=y
# CONFIG_KERNEL_LZMA is not set
# CONFIG_KERNEL_XZ is not set
# CONFIG_KERNEL_LZO is not set
CONFIG_DEFAULT_HOSTNAME="(none)"
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_SYSVIPC_SYSCTL=y
CONFIG_POSIX_MQUEUE=y
CONFIG_POSIX_MQUEUE_SYSCTL=y
# CONFIG_BSD_PROCESS_ACCT is not set
# CONFIG_FHANDLE is not set
CONFIG_TASKSTATS=y
CONFIG_TASK_DELAY_ACCT=y
# CONFIG_TASK_XACCT is not set
CONFIG_AUDIT=y
# CONFIG_AUDITSYSCALL is not set
# CONFIG_AUDIT_LOGINUID_IMMUTABLE is not set
CONFIG_HAVE_GENERIC_HARDIRQS=y

#
# IRQ subsystem
#
CONFIG_GENERIC_HARDIRQS=y
CONFIG_GENERIC_IRQ_PROBE=y
CONFIG_GENERIC_IRQ_SHOW=y
CONFIG_GENERIC_PENDING_IRQ=y
CONFIG_GENERIC_IRQ_CHIP=y
CONFIG_IRQ_DOMAIN=y
CONFIG_IRQ_DOMAIN_DEBUG=y
CONFIG_IRQ_FORCED_THREADING=y
CONFIG_SPARSE_IRQ=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_KTIME_SCALAR=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
CONFIG_GENERIC_CMOS_UPDATE=y

#
# Timers subsystem
#
CONFIG_TICK_ONESHOT=y
CONFIG_NO_HZ=y
CONFIG_HIGH_RES_TIMERS=y

#
# RCU Subsystem
#
CONFIG_TREE_PREEMPT_RCU=y
CONFIG_PREEMPT_RCU=y
CONFIG_RCU_FANOUT=32
CONFIG_RCU_FANOUT_LEAF=16
CONFIG_RCU_FANOUT_EXACT=y
# CONFIG_RCU_FAST_NO_HZ is not set
# CONFIG_TREE_RCU_TRACE is not set
CONFIG_RCU_BOOST=y
CONFIG_RCU_BOOST_PRIO=1
CONFIG_RCU_BOOST_DELAY=500
CONFIG_IKCONFIG=y
# CONFIG_IKCONFIG_PROC is not set
CONFIG_LOG_BUF_SHIFT=17
CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
CONFIG_CGROUPS=y
CONFIG_CGROUP_DEBUG=y
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CPUSETS=y
CONFIG_PROC_PID_CPUSET=y
CONFIG_CGROUP_CPUACCT=y
CONFIG_RESOURCE_COUNTERS=y
# CONFIG_MEMCG is not set
# CONFIG_CGROUP_HUGETLB is not set
# CONFIG_CGROUP_PERF is not set
CONFIG_CGROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_CFS_BANDWIDTH is not set
# CONFIG_RT_GROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set
CONFIG_CHECKPOINT_RESTORE=y
# CONFIG_NAMESPACES is not set
CONFIG_SCHED_AUTOGROUP=y
# CONFIG_RELAY is not set
CONFIG_BLK_DEV_INITRD=y
CONFIG_INITRAMFS_SOURCE=""
CONFIG_RD_GZIP=y
# CONFIG_RD_BZIP2 is not set
# CONFIG_RD_LZMA is not set
# CONFIG_RD_XZ is not set
# CONFIG_RD_LZO is not set
CONFIG_CC_OPTIMIZE_FOR_SIZE=y
CONFIG_SYSCTL=y
CONFIG_ANON_INODES=y
CONFIG_EXPERT=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_KALLSYMS=y
CONFIG_KALLSYMS_ALL=y
CONFIG_HOTPLUG=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
# CONFIG_PCSPKR_PLATFORM is not set
CONFIG_HAVE_PCSPKR_PLATFORM=y
# CONFIG_BASE_FULL is not set
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SIGNALFD=y
# CONFIG_TIMERFD is not set
CONFIG_EVENTFD=y
CONFIG_SHMEM=y
# CONFIG_AIO is not set
CONFIG_EMBEDDED=y
CONFIG_HAVE_PERF_EVENTS=y

#
# Kernel Performance Events And Counters
#
CONFIG_PERF_EVENTS=y
# CONFIG_DEBUG_PERF_USE_VMALLOC is not set
# CONFIG_VM_EVENT_COUNTERS is not set
CONFIG_PCI_QUIRKS=y
CONFIG_COMPAT_BRK=y
# CONFIG_SLAB is not set
CONFIG_SLUB=y
# CONFIG_SLOB is not set
# CONFIG_PROFILING is not set
CONFIG_TRACEPOINTS=y
CONFIG_HAVE_OPROFILE=y
CONFIG_OPROFILE_NMI_TIMER=y
# CONFIG_JUMP_LABEL is not set
CONFIG_UPROBES=y
CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
CONFIG_HAVE_IOREMAP_PROT=y
CONFIG_HAVE_KPROBES=y
CONFIG_HAVE_KRETPROBES=y
CONFIG_HAVE_OPTPROBES=y
CONFIG_HAVE_ARCH_TRACEHOOK=y
CONFIG_HAVE_DMA_ATTRS=y
CONFIG_HAVE_DMA_CONTIGUOUS=y
CONFIG_USE_GENERIC_SMP_HELPERS=y
CONFIG_GENERIC_SMP_IDLE_THREAD=y
CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_HAVE_HW_BREAKPOINT=y
CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
CONFIG_HAVE_USER_RETURN_NOTIFIER=y
CONFIG_HAVE_PERF_EVENTS_NMI=y
CONFIG_HAVE_PERF_REGS=y
CONFIG_HAVE_PERF_USER_STACK_DUMP=y
CONFIG_HAVE_ARCH_JUMP_LABEL=y
CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
CONFIG_HAVE_CMPXCHG_LOCAL=y
CONFIG_HAVE_CMPXCHG_DOUBLE=y
CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
CONFIG_MODULES_USE_ELF_REL=y

#
# GCOV-based kernel profiling
#
CONFIG_GCOV_KERNEL=y
CONFIG_GCOV_PROFILE_ALL=y
CONFIG_HAVE_GENERIC_DMA_COHERENT=y
CONFIG_RT_MUTEXES=y
CONFIG_BASE_SMALL=1
# CONFIG_MODULES is not set
CONFIG_STOP_MACHINE=y
CONFIG_BLOCK=y
# CONFIG_LBDAF is not set
CONFIG_BLK_DEV_BSG=y
CONFIG_BLK_DEV_BSGLIB=y
# CONFIG_BLK_DEV_INTEGRITY is not set

#
# Partition Types
#
CONFIG_PARTITION_ADVANCED=y
CONFIG_ACORN_PARTITION=y
CONFIG_ACORN_PARTITION_CUMANA=y
# CONFIG_ACORN_PARTITION_EESOX is not set
CONFIG_ACORN_PARTITION_ICS=y
CONFIG_ACORN_PARTITION_ADFS=y
CONFIG_ACORN_PARTITION_POWERTEC=y
CONFIG_ACORN_PARTITION_RISCIX=y
# CONFIG_OSF_PARTITION is not set
CONFIG_AMIGA_PARTITION=y
# CONFIG_ATARI_PARTITION is not set
# CONFIG_MAC_PARTITION is not set
# CONFIG_MSDOS_PARTITION is not set
CONFIG_LDM_PARTITION=y
# CONFIG_LDM_DEBUG is not set
CONFIG_SGI_PARTITION=y
# CONFIG_ULTRIX_PARTITION is not set
CONFIG_SUN_PARTITION=y
# CONFIG_KARMA_PARTITION is not set
# CONFIG_EFI_PARTITION is not set
CONFIG_SYSV68_PARTITION=y

#
# IO Schedulers
#
CONFIG_IOSCHED_NOOP=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_IOSCHED_CFQ=y
CONFIG_DEFAULT_DEADLINE=y
# CONFIG_DEFAULT_CFQ is not set
# CONFIG_DEFAULT_NOOP is not set
CONFIG_DEFAULT_IOSCHED="deadline"
# CONFIG_INLINE_SPIN_TRYLOCK is not set
# CONFIG_INLINE_SPIN_TRYLOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK is not set
# CONFIG_INLINE_SPIN_LOCK_BH is not set
# CONFIG_INLINE_SPIN_LOCK_IRQ is not set
# CONFIG_INLINE_SPIN_LOCK_IRQSAVE is not set
CONFIG_UNINLINE_SPIN_UNLOCK=y
# CONFIG_INLINE_SPIN_UNLOCK_BH is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQ is not set
# CONFIG_INLINE_SPIN_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_READ_TRYLOCK is not set
# CONFIG_INLINE_READ_LOCK is not set
# CONFIG_INLINE_READ_LOCK_BH is not set
# CONFIG_INLINE_READ_LOCK_IRQ is not set
# CONFIG_INLINE_READ_LOCK_IRQSAVE is not set
# CONFIG_INLINE_READ_UNLOCK is not set
# CONFIG_INLINE_READ_UNLOCK_BH is not set
# CONFIG_INLINE_READ_UNLOCK_IRQ is not set
# CONFIG_INLINE_READ_UNLOCK_IRQRESTORE is not set
# CONFIG_INLINE_WRITE_TRYLOCK is not set
# CONFIG_INLINE_WRITE_LOCK is not set
# CONFIG_INLINE_WRITE_LOCK_BH is not set
# CONFIG_INLINE_WRITE_LOCK_IRQ is not set
# CONFIG_INLINE_WRITE_LOCK_IRQSAVE is not set
# CONFIG_INLINE_WRITE_UNLOCK is not set
# CONFIG_INLINE_WRITE_UNLOCK_BH is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQ is not set
# CONFIG_INLINE_WRITE_UNLOCK_IRQRESTORE is not set
# CONFIG_MUTEX_SPIN_ON_OWNER is not set
CONFIG_FREEZER=y

#
# Processor type and features
#
# CONFIG_ZONE_DMA is not set
CONFIG_SMP=y
CONFIG_X86_MPPARSE=y
# CONFIG_X86_BIGSMP is not set
CONFIG_X86_EXTENDED_PLATFORM=y
CONFIG_X86_WANT_INTEL_MID=y
# CONFIG_X86_MDFLD is not set
CONFIG_X86_RDC321X=y
# CONFIG_X86_32_NON_STANDARD is not set
CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_X86_32_IRIS is not set
CONFIG_SCHED_OMIT_FRAME_POINTER=y
# CONFIG_KVMTOOL_TEST_ENABLE is not set
CONFIG_PARAVIRT_GUEST=y
CONFIG_PARAVIRT_TIME_ACCOUNTING=y
# CONFIG_XEN_PRIVILEGED_GUEST is not set
CONFIG_KVM_CLOCK=y
CONFIG_KVM_GUEST=y
# CONFIG_LGUEST_GUEST is not set
CONFIG_PARAVIRT=y
# CONFIG_PARAVIRT_SPINLOCKS is not set
CONFIG_PARAVIRT_CLOCK=y
# CONFIG_PARAVIRT_DEBUG is not set
CONFIG_NO_BOOTMEM=y
CONFIG_MEMTEST=y
# CONFIG_M386 is not set
# CONFIG_M486 is not set
# CONFIG_M586 is not set
# CONFIG_M586TSC is not set
# CONFIG_M586MMX is not set
CONFIG_M686=y
# CONFIG_MPENTIUMII is not set
# CONFIG_MPENTIUMIII is not set
# CONFIG_MPENTIUMM is not set
# CONFIG_MPENTIUM4 is not set
# CONFIG_MK6 is not set
# CONFIG_MK7 is not set
# CONFIG_MK8 is not set
# CONFIG_MCRUSOE is not set
# CONFIG_MEFFICEON is not set
# CONFIG_MWINCHIPC6 is not set
# CONFIG_MWINCHIP3D is not set
# CONFIG_MELAN is not set
# CONFIG_MGEODEGX1 is not set
# CONFIG_MGEODE_LX is not set
# CONFIG_MCYRIXIII is not set
# CONFIG_MVIAC3_2 is not set
# CONFIG_MVIAC7 is not set
# CONFIG_MCORE2 is not set
# CONFIG_MATOM is not set
# CONFIG_X86_GENERIC is not set
CONFIG_X86_INTERNODE_CACHE_SHIFT=5
CONFIG_X86_CMPXCHG=y
CONFIG_X86_L1_CACHE_SHIFT=5
CONFIG_X86_XADD=y
# CONFIG_X86_PPRO_FENCE is not set
CONFIG_X86_WP_WORKS_OK=y
CONFIG_X86_INVLPG=y
CONFIG_X86_BSWAP=y
CONFIG_X86_POPAD_OK=y
CONFIG_X86_USE_PPRO_CHECKSUM=y
CONFIG_X86_TSC=y
CONFIG_X86_CMPXCHG64=y
CONFIG_X86_CMOV=y
CONFIG_X86_MINIMUM_CPU_FAMILY=5
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PROCESSOR_SELECT=y
# CONFIG_CPU_SUP_INTEL is not set
CONFIG_CPU_SUP_CYRIX_32=y
CONFIG_CPU_SUP_AMD=y
CONFIG_CPU_SUP_CENTAUR=y
# CONFIG_CPU_SUP_TRANSMETA_32 is not set
# CONFIG_CPU_SUP_UMC_32 is not set
CONFIG_HPET_TIMER=y
# CONFIG_DMI is not set
# CONFIG_IOMMU_HELPER is not set
CONFIG_NR_CPUS=8
CONFIG_SCHED_SMT=y
CONFIG_SCHED_MC=y
# CONFIG_IRQ_TIME_ACCOUNTING is not set
# CONFIG_PREEMPT_NONE is not set
# CONFIG_PREEMPT_VOLUNTARY is not set
CONFIG_PREEMPT=y
CONFIG_PREEMPT_COUNT=y
CONFIG_X86_LOCAL_APIC=y
CONFIG_X86_IO_APIC=y
CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
CONFIG_X86_MCE=y
# CONFIG_X86_MCE_INTEL is not set
CONFIG_X86_MCE_AMD=y
CONFIG_X86_ANCIENT_MCE=y
CONFIG_X86_MCE_THRESHOLD=y
CONFIG_X86_MCE_INJECT=y
# CONFIG_VM86 is not set
# CONFIG_TOSHIBA is not set
# CONFIG_I8K is not set
CONFIG_X86_REBOOTFIXUPS=y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=y
# CONFIG_MICROCODE_AMD is not set
CONFIG_MICROCODE_OLD_INTERFACE=y
CONFIG_X86_MSR=y
CONFIG_X86_CPUID=y
# CONFIG_NOHIGHMEM is not set
CONFIG_HIGHMEM4G=y
# CONFIG_HIGHMEM64G is not set
# CONFIG_VMSPLIT_3G is not set
# CONFIG_VMSPLIT_3G_OPT is not set
CONFIG_VMSPLIT_2G=y
# CONFIG_VMSPLIT_2G_OPT is not set
# CONFIG_VMSPLIT_1G is not set
CONFIG_PAGE_OFFSET=0x80000000
CONFIG_HIGHMEM=y
# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
# CONFIG_ARCH_DMA_ADDR_T_64BIT is not set
CONFIG_ARCH_FLATMEM_ENABLE=y
CONFIG_ARCH_SPARSEMEM_ENABLE=y
CONFIG_ARCH_SELECT_MEMORY_MODEL=y
CONFIG_ILLEGAL_POINTER_VALUE=0
CONFIG_SELECT_MEMORY_MODEL=y
CONFIG_FLATMEM_MANUAL=y
# CONFIG_SPARSEMEM_MANUAL is not set
CONFIG_FLATMEM=y
CONFIG_FLAT_NODE_MEM_MAP=y
CONFIG_SPARSEMEM_STATIC=y
CONFIG_HAVE_MEMBLOCK=y
CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
CONFIG_ARCH_DISCARD_MEMBLOCK=y
CONFIG_MEMORY_ISOLATION=y
CONFIG_PAGEFLAGS_EXTENDED=y
CONFIG_SPLIT_PTLOCK_CPUS=999999
CONFIG_COMPACTION=y
CONFIG_MIGRATION=y
# CONFIG_PHYS_ADDR_T_64BIT is not set
CONFIG_ZONE_DMA_FLAG=0
CONFIG_BOUNCE=y
CONFIG_VIRT_TO_BUS=y
CONFIG_KSM=y
CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
# CONFIG_MEMORY_FAILURE is not set
# CONFIG_TRANSPARENT_HUGEPAGE is not set
CONFIG_CROSS_MEMORY_ATTACH=y
# CONFIG_CLEANCACHE is not set
# CONFIG_FRONTSWAP is not set
# CONFIG_HIGHPTE is not set
# CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
CONFIG_X86_RESERVE_LOW=64
CONFIG_MATH_EMULATION=y
# CONFIG_MTRR is not set
CONFIG_ARCH_RANDOM=y
# CONFIG_EFI is not set
# CONFIG_SECCOMP is not set
CONFIG_CC_STACKPROTECTOR=y
# CONFIG_HZ_100 is not set
CONFIG_HZ_250=y
# CONFIG_HZ_300 is not set
# CONFIG_HZ_1000 is not set
CONFIG_HZ=250
CONFIG_SCHED_HRTICK=y
CONFIG_KEXEC=y
CONFIG_CRASH_DUMP=y
CONFIG_PHYSICAL_START=0x1000000
# CONFIG_RELOCATABLE is not set
CONFIG_PHYSICAL_ALIGN=0x1000000
# CONFIG_HOTPLUG_CPU is not set
CONFIG_COMPAT_VDSO=y
# CONFIG_CMDLINE_BOOL is not set
CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y

#
# Power management and ACPI options
#
# CONFIG_SUSPEND is not set
# CONFIG_HIBERNATION is not set
CONFIG_PM_RUNTIME=y
CONFIG_PM=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_ACPI=y
# CONFIG_ACPI_PROCFS is not set
CONFIG_ACPI_PROCFS_POWER=y
# CONFIG_ACPI_EC_DEBUGFS is not set
CONFIG_ACPI_PROC_EVENT=y
# CONFIG_ACPI_AC is not set
# CONFIG_ACPI_BATTERY is not set
CONFIG_ACPI_BUTTON=y
CONFIG_ACPI_VIDEO=y
# CONFIG_ACPI_FAN is not set
# CONFIG_ACPI_DOCK is not set
CONFIG_ACPI_PROCESSOR=y
# CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
# CONFIG_ACPI_THERMAL is not set
CONFIG_ACPI_CUSTOM_DSDT_FILE=""
# CONFIG_ACPI_CUSTOM_DSDT is not set
CONFIG_ACPI_BLACKLIST_YEAR=0
# CONFIG_ACPI_DEBUG is not set
CONFIG_X86_PM_TIMER=y
# CONFIG_ACPI_CONTAINER is not set
# CONFIG_ACPI_SBS is not set
# CONFIG_ACPI_HED is not set
CONFIG_ACPI_CUSTOM_METHOD=y
# CONFIG_ACPI_BGRT is not set
# CONFIG_ACPI_APEI is not set
CONFIG_SFI=y

#
# CPU Frequency scaling
#
CONFIG_CPU_FREQ=y
CONFIG_CPU_FREQ_TABLE=y
# CONFIG_CPU_FREQ_STAT is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE=y
# CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
# CONFIG_CPU_FREQ_GOV_PERFORMANCE is not set
CONFIG_CPU_FREQ_GOV_POWERSAVE=y
CONFIG_CPU_FREQ_GOV_USERSPACE=y
# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set
# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set

#
# x86 CPU frequency scaling drivers
#
# CONFIG_X86_PCC_CPUFREQ is not set
CONFIG_X86_ACPI_CPUFREQ=y
CONFIG_X86_POWERNOW_K6=y
# CONFIG_X86_POWERNOW_K7 is not set
# CONFIG_X86_POWERNOW_K8 is not set
CONFIG_X86_GX_SUSPMOD=y
CONFIG_X86_SPEEDSTEP_CENTRINO=y
CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
CONFIG_X86_SPEEDSTEP_ICH=y
# CONFIG_X86_SPEEDSTEP_SMI is not set
CONFIG_X86_P4_CLOCKMOD=y
# CONFIG_X86_CPUFREQ_NFORCE2 is not set
# CONFIG_X86_LONGRUN is not set
# CONFIG_X86_LONGHAUL is not set
# CONFIG_X86_E_POWERSAVER is not set

#
# shared options
#
CONFIG_X86_SPEEDSTEP_LIB=y
# CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK is not set
CONFIG_CPU_IDLE=y
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
# CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set

#
# Bus options (PCI etc.)
#
CONFIG_PCI=y
# CONFIG_PCI_GOBIOS is not set
# CONFIG_PCI_GOMMCONFIG is not set
# CONFIG_PCI_GODIRECT is not set
# CONFIG_PCI_GOOLPC is not set
CONFIG_PCI_GOANY=y
CONFIG_PCI_BIOS=y
CONFIG_PCI_DIRECT=y
CONFIG_PCI_MMCONFIG=y
CONFIG_PCI_OLPC=y
CONFIG_PCI_DOMAINS=y
CONFIG_PCI_CNB20LE_QUIRK=y
# CONFIG_PCIEPORTBUS is not set
CONFIG_ARCH_SUPPORTS_MSI=y
CONFIG_PCI_MSI=y
# CONFIG_PCI_DEBUG is not set
# CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
# CONFIG_PCI_STUB is not set
# CONFIG_HT_IRQ is not set
CONFIG_PCI_ATS=y
# CONFIG_PCI_IOV is not set
CONFIG_PCI_PRI=y
# CONFIG_PCI_PASID is not set
# CONFIG_PCI_IOAPIC is not set
CONFIG_PCI_LABEL=y
CONFIG_ISA_DMA_API=y
# CONFIG_ISA is not set
CONFIG_SCx200=y
CONFIG_SCx200HR_TIMER=y
CONFIG_OLPC=y
# CONFIG_OLPC_XO15_SCI is not set
# CONFIG_ALIX is not set
# CONFIG_NET5501 is not set
CONFIG_AMD_NB=y
CONFIG_PCCARD=y
CONFIG_PCMCIA=y
CONFIG_PCMCIA_LOAD_CIS=y
CONFIG_CARDBUS=y

#
# PC-card bridges
#
CONFIG_YENTA=y
CONFIG_YENTA_O2=y
# CONFIG_YENTA_RICOH is not set
# CONFIG_YENTA_TI is not set
CONFIG_YENTA_TOSHIBA=y
# CONFIG_PD6729 is not set
# CONFIG_I82092 is not set
CONFIG_PCCARD_NONSTATIC=y
CONFIG_RAPIDIO=y
CONFIG_RAPIDIO_DISC_TIMEOUT=30
# CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS is not set
CONFIG_RAPIDIO_DMA_ENGINE=y
CONFIG_RAPIDIO_DEBUG=y
# CONFIG_RAPIDIO_TSI57X is not set
# CONFIG_RAPIDIO_CPS_XX is not set
# CONFIG_RAPIDIO_TSI568 is not set
CONFIG_RAPIDIO_CPS_GEN2=y
CONFIG_RAPIDIO_TSI500=y

#
# Executable file formats / Emulations
#
CONFIG_BINFMT_ELF=y
CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
CONFIG_HAVE_AOUT=y
CONFIG_BINFMT_AOUT=y
# CONFIG_BINFMT_MISC is not set
CONFIG_HAVE_ATOMIC_IOMAP=y
CONFIG_HAVE_TEXT_POKE_SMP=y
CONFIG_NET=y

#
# Networking options
#
# CONFIG_PACKET is not set
CONFIG_UNIX=y
CONFIG_UNIX_DIAG=y
CONFIG_XFRM=y
CONFIG_XFRM_ALGO=y
CONFIG_XFRM_USER=y
CONFIG_XFRM_SUB_POLICY=y
# CONFIG_XFRM_MIGRATE is not set
CONFIG_XFRM_STATISTICS=y
CONFIG_NET_KEY=y
# CONFIG_NET_KEY_MIGRATE is not set
CONFIG_INET=y
# CONFIG_IP_MULTICAST is not set
# CONFIG_IP_ADVANCED_ROUTER is not set
CONFIG_IP_ROUTE_CLASSID=y
CONFIG_IP_PNP=y
CONFIG_IP_PNP_DHCP=y
CONFIG_IP_PNP_BOOTP=y
# CONFIG_IP_PNP_RARP is not set
# CONFIG_NET_IPIP is not set
CONFIG_NET_IPGRE_DEMUX=y
CONFIG_NET_IPGRE=y
CONFIG_ARPD=y
CONFIG_SYN_COOKIES=y
# CONFIG_INET_AH is not set
CONFIG_INET_ESP=y
# CONFIG_INET_IPCOMP is not set
# CONFIG_INET_XFRM_TUNNEL is not set
CONFIG_INET_TUNNEL=y
CONFIG_INET_XFRM_MODE_TRANSPORT=y
# CONFIG_INET_XFRM_MODE_TUNNEL is not set
CONFIG_INET_XFRM_MODE_BEET=y
CONFIG_INET_LRO=y
# CONFIG_INET_DIAG is not set
CONFIG_TCP_CONG_ADVANCED=y
CONFIG_TCP_CONG_BIC=y
# CONFIG_TCP_CONG_CUBIC is not set
# CONFIG_TCP_CONG_WESTWOOD is not set
CONFIG_TCP_CONG_HTCP=y
CONFIG_TCP_CONG_HSTCP=y
# CONFIG_TCP_CONG_HYBLA is not set
# CONFIG_TCP_CONG_VEGAS is not set
CONFIG_TCP_CONG_SCALABLE=y
# CONFIG_TCP_CONG_LP is not set
CONFIG_TCP_CONG_VENO=y
# CONFIG_TCP_CONG_YEAH is not set
CONFIG_TCP_CONG_ILLINOIS=y
# CONFIG_DEFAULT_BIC is not set
CONFIG_DEFAULT_HTCP=y
# CONFIG_DEFAULT_VENO is not set
# CONFIG_DEFAULT_RENO is not set
CONFIG_DEFAULT_TCP_CONG="htcp"
CONFIG_TCP_MD5SIG=y
CONFIG_IPV6=y
# CONFIG_IPV6_PRIVACY is not set
# CONFIG_IPV6_ROUTER_PREF is not set
# CONFIG_IPV6_OPTIMISTIC_DAD is not set
CONFIG_INET6_AH=y
# CONFIG_INET6_ESP is not set
# CONFIG_INET6_IPCOMP is not set
CONFIG_IPV6_MIP6=y
# CONFIG_INET6_XFRM_TUNNEL is not set
# CONFIG_INET6_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_TRANSPORT is not set
# CONFIG_INET6_XFRM_MODE_TUNNEL is not set
# CONFIG_INET6_XFRM_MODE_BEET is not set
CONFIG_INET6_XFRM_MODE_ROUTEOPTIMIZATION=y
CONFIG_IPV6_SIT=y
# CONFIG_IPV6_SIT_6RD is not set
CONFIG_IPV6_NDISC_NODETYPE=y
# CONFIG_IPV6_TUNNEL is not set
# CONFIG_IPV6_GRE is not set
CONFIG_IPV6_MULTIPLE_TABLES=y
# CONFIG_IPV6_SUBTREES is not set
CONFIG_IPV6_MROUTE=y
# CONFIG_IPV6_MROUTE_MULTIPLE_TABLES is not set
# CONFIG_IPV6_PIMSM_V2 is not set
CONFIG_NETWORK_SECMARK=y
# CONFIG_NETWORK_PHY_TIMESTAMPING is not set
CONFIG_NETFILTER=y
CONFIG_NETFILTER_DEBUG=y
# CONFIG_NETFILTER_ADVANCED is not set

#
# Core Netfilter Configuration
#
CONFIG_NETFILTER_NETLINK=y
# CONFIG_NETFILTER_NETLINK_LOG is not set
CONFIG_NF_CONNTRACK=y
CONFIG_NF_CONNTRACK_SECMARK=y
CONFIG_NF_CONNTRACK_PROCFS=y
CONFIG_NF_CONNTRACK_FTP=y
CONFIG_NF_CONNTRACK_IRC=y
CONFIG_NF_CONNTRACK_BROADCAST=y
CONFIG_NF_CONNTRACK_NETBIOS_NS=y
# CONFIG_NF_CONNTRACK_SIP is not set
CONFIG_NF_CT_NETLINK=y
# CONFIG_NETFILTER_XTABLES is not set
# CONFIG_IP_SET is not set
# CONFIG_IP_VS is not set

#
# IP: Netfilter Configuration
#
# CONFIG_NF_DEFRAG_IPV4 is not set
# CONFIG_NF_CONNTRACK_IPV4 is not set
# CONFIG_IP_NF_IPTABLES is not set

#
# IPv6: Netfilter Configuration
#
CONFIG_NF_DEFRAG_IPV6=y
CONFIG_NF_CONNTRACK_IPV6=y
# CONFIG_IP6_NF_IPTABLES is not set
# CONFIG_BRIDGE_NF_EBTABLES is not set
CONFIG_IP_DCCP=y

#
# DCCP CCIDs Configuration (EXPERIMENTAL)
#
# CONFIG_IP_DCCP_CCID2_DEBUG is not set
# CONFIG_IP_DCCP_CCID3 is not set

#
# DCCP Kernel Hacking
#
# CONFIG_IP_DCCP_DEBUG is not set
# CONFIG_IP_SCTP is not set
# CONFIG_RDS is not set
CONFIG_TIPC=y
CONFIG_TIPC_ADVANCED=y
CONFIG_TIPC_PORTS=8191
# CONFIG_ATM is not set
CONFIG_L2TP=y
CONFIG_L2TP_DEBUGFS=y
CONFIG_L2TP_V3=y
CONFIG_L2TP_IP=y
CONFIG_L2TP_ETH=y
CONFIG_STP=y
CONFIG_BRIDGE=y
# CONFIG_BRIDGE_IGMP_SNOOPING is not set
CONFIG_NET_DSA=y
CONFIG_NET_DSA_TAG_DSA=y
CONFIG_NET_DSA_TAG_EDSA=y
# CONFIG_NET_DSA_TAG_TRAILER is not set
# CONFIG_VLAN_8021Q is not set
# CONFIG_DECNET is not set
CONFIG_LLC=y
# CONFIG_LLC2 is not set
# CONFIG_IPX is not set
CONFIG_ATALK=y
CONFIG_DEV_APPLETALK=y
CONFIG_IPDDP=y
CONFIG_IPDDP_ENCAP=y
# CONFIG_IPDDP_DECAP is not set
# CONFIG_X25 is not set
# CONFIG_LAPB is not set
CONFIG_WAN_ROUTER=y
CONFIG_PHONET=y
CONFIG_IEEE802154=y
# CONFIG_IEEE802154_6LOWPAN is not set
# CONFIG_MAC802154 is not set
CONFIG_NET_SCHED=y

#
# Queueing/Scheduling
#
CONFIG_NET_SCH_CBQ=y
CONFIG_NET_SCH_HTB=y
CONFIG_NET_SCH_HFSC=y
CONFIG_NET_SCH_PRIO=y
# CONFIG_NET_SCH_MULTIQ is not set
CONFIG_NET_SCH_RED=y
CONFIG_NET_SCH_SFB=y
# CONFIG_NET_SCH_SFQ is not set
CONFIG_NET_SCH_TEQL=y
CONFIG_NET_SCH_TBF=y
# CONFIG_NET_SCH_GRED is not set
# CONFIG_NET_SCH_DSMARK is not set
# CONFIG_NET_SCH_NETEM is not set
CONFIG_NET_SCH_DRR=y
# CONFIG_NET_SCH_MQPRIO is not set
# CONFIG_NET_SCH_CHOKE is not set
CONFIG_NET_SCH_QFQ=y
# CONFIG_NET_SCH_CODEL is not set
# CONFIG_NET_SCH_FQ_CODEL is not set
CONFIG_NET_SCH_INGRESS=y
CONFIG_NET_SCH_PLUG=y

#
# Classification
#
CONFIG_NET_CLS=y
CONFIG_NET_CLS_BASIC=y
# CONFIG_NET_CLS_TCINDEX is not set
CONFIG_NET_CLS_ROUTE4=y
CONFIG_NET_CLS_FW=y
# CONFIG_NET_CLS_U32 is not set
CONFIG_NET_CLS_RSVP=y
CONFIG_NET_CLS_RSVP6=y
CONFIG_NET_CLS_FLOW=y
# CONFIG_NET_CLS_CGROUP is not set
# CONFIG_NET_EMATCH is not set
CONFIG_NET_CLS_ACT=y
CONFIG_NET_ACT_POLICE=y
CONFIG_NET_ACT_GACT=y
# CONFIG_GACT_PROB is not set
# CONFIG_NET_ACT_MIRRED is not set
# CONFIG_NET_ACT_NAT is not set
CONFIG_NET_ACT_PEDIT=y
CONFIG_NET_ACT_SIMP=y
CONFIG_NET_ACT_SKBEDIT=y
CONFIG_NET_ACT_CSUM=y
# CONFIG_NET_CLS_IND is not set
CONFIG_NET_SCH_FIFO=y
CONFIG_DCB=y
CONFIG_DNS_RESOLVER=y
# CONFIG_BATMAN_ADV is not set
# CONFIG_OPENVSWITCH is not set
CONFIG_NETPRIO_CGROUP=y

#
# Network testing
#
CONFIG_NET_PKTGEN=y
CONFIG_NET_DROP_MONITOR=y
CONFIG_HAMRADIO=y

#
# Packet Radio protocols
#
CONFIG_AX25=y
CONFIG_AX25_DAMA_SLAVE=y
CONFIG_NETROM=y
CONFIG_ROSE=y

#
# AX.25 network device drivers
#
CONFIG_MKISS=y
# CONFIG_6PACK is not set
# CONFIG_BPQETHER is not set
CONFIG_BAYCOM_SER_FDX=y
# CONFIG_BAYCOM_SER_HDX is not set
CONFIG_BAYCOM_PAR=y
# CONFIG_BAYCOM_EPP is not set
CONFIG_YAM=y
# CONFIG_CAN is not set
# CONFIG_IRDA is not set
# CONFIG_BT is not set
CONFIG_AF_RXRPC=y
# CONFIG_AF_RXRPC_DEBUG is not set
# CONFIG_RXKAD is not set
CONFIG_FIB_RULES=y
CONFIG_WIRELESS=y
CONFIG_WIRELESS_EXT=y
CONFIG_WEXT_CORE=y
CONFIG_WEXT_PROC=y
CONFIG_WEXT_SPY=y
CONFIG_WEXT_PRIV=y
CONFIG_CFG80211=y
# CONFIG_NL80211_TESTMODE is not set
# CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
CONFIG_CFG80211_REG_DEBUG=y
# CONFIG_CFG80211_CERTIFICATION_ONUS is not set
# CONFIG_CFG80211_DEFAULT_PS is not set
CONFIG_CFG80211_DEBUGFS=y
# CONFIG_CFG80211_INTERNAL_REGDB is not set
CONFIG_CFG80211_WEXT=y
CONFIG_LIB80211=y
CONFIG_LIB80211_CRYPT_WEP=y
CONFIG_LIB80211_CRYPT_CCMP=y
CONFIG_LIB80211_CRYPT_TKIP=y
# CONFIG_LIB80211_DEBUG is not set
CONFIG_MAC80211=y
# CONFIG_MAC80211_RC_PID is not set
# CONFIG_MAC80211_RC_MINSTREL is not set
CONFIG_MAC80211_RC_DEFAULT=""

#
# Some wireless drivers require a rate control algorithm
#
# CONFIG_MAC80211_MESH is not set
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_MESSAGE_TRACING is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_WIMAX=y
CONFIG_WIMAX_DEBUG_LEVEL=8
# CONFIG_RFKILL is not set
CONFIG_NET_9P=y
CONFIG_NET_9P_VIRTIO=y
# CONFIG_NET_9P_RDMA is not set
# CONFIG_NET_9P_DEBUG is not set
# CONFIG_CAIF is not set
CONFIG_CEPH_LIB=y
CONFIG_CEPH_LIB_PRETTYDEBUG=y
# CONFIG_CEPH_LIB_USE_DNS_RESOLVER is not set
# CONFIG_NFC is not set

#
# Device Drivers
#

#
# Generic Driver Options
#
CONFIG_UEVENT_HELPER_PATH=""
CONFIG_DEVTMPFS=y
# CONFIG_DEVTMPFS_MOUNT is not set
# CONFIG_STANDALONE is not set
# CONFIG_PREVENT_FIRMWARE_BUILD is not set
CONFIG_FW_LOADER=y
CONFIG_FIRMWARE_IN_KERNEL=y
CONFIG_EXTRA_FIRMWARE=""
CONFIG_DEBUG_DRIVER=y
CONFIG_DEBUG_DEVRES=y
# CONFIG_SYS_HYPERVISOR is not set
# CONFIG_GENERIC_CPU_DEVICES is not set
CONFIG_REGMAP=y
CONFIG_REGMAP_I2C=y
CONFIG_REGMAP_IRQ=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_CMA=y
# CONFIG_CMA_DEBUG is not set

#
# Default contiguous memory area size:
#
CONFIG_CMA_SIZE_MBYTES=16
CONFIG_CMA_SIZE_PERCENTAGE=10
# CONFIG_CMA_SIZE_SEL_MBYTES is not set
# CONFIG_CMA_SIZE_SEL_PERCENTAGE is not set
# CONFIG_CMA_SIZE_SEL_MIN is not set
CONFIG_CMA_SIZE_SEL_MAX=y
CONFIG_CMA_ALIGNMENT=8
CONFIG_CMA_AREAS=7

#
# Bus devices
#
# CONFIG_OMAP_OCP2SCP is not set
# CONFIG_CONNECTOR is not set
# CONFIG_MTD is not set
CONFIG_OF=y

#
# Device Tree and Open Firmware support
#
CONFIG_PROC_DEVICETREE=y
# CONFIG_OF_SELFTEST is not set
CONFIG_OF_PROMTREE=y
CONFIG_OF_ADDRESS=y
CONFIG_OF_IRQ=y
CONFIG_OF_DEVICE=y
CONFIG_OF_I2C=y
CONFIG_OF_NET=y
CONFIG_OF_MDIO=y
CONFIG_OF_PCI=y
CONFIG_OF_PCI_IRQ=y
CONFIG_PARPORT=y
CONFIG_PARPORT_PC=y
# CONFIG_PARPORT_SERIAL is not set
# CONFIG_PARPORT_PC_FIFO is not set
CONFIG_PARPORT_PC_SUPERIO=y
# CONFIG_PARPORT_PC_PCMCIA is not set
# CONFIG_PARPORT_GSC is not set
# CONFIG_PARPORT_AX88796 is not set
# CONFIG_PARPORT_1284 is not set
CONFIG_PNP=y
CONFIG_PNP_DEBUG_MESSAGES=y

#
# Protocols
#
CONFIG_PNPACPI=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_FD=y
CONFIG_PARIDE=y

#
# Parallel IDE high-level drivers
#
CONFIG_PARIDE_PD=y
CONFIG_PARIDE_PCD=y
CONFIG_PARIDE_PF=y
# CONFIG_PARIDE_PT is not set
CONFIG_PARIDE_PG=y

#
# Parallel IDE protocol modules
#
# CONFIG_PARIDE_ATEN is not set
CONFIG_PARIDE_BPCK=y
CONFIG_PARIDE_BPCK6=y
CONFIG_PARIDE_COMM=y
# CONFIG_PARIDE_DSTR is not set
CONFIG_PARIDE_FIT2=y
CONFIG_PARIDE_FIT3=y
CONFIG_PARIDE_EPAT=y
CONFIG_PARIDE_EPATC8=y
# CONFIG_PARIDE_EPIA is not set
CONFIG_PARIDE_FRIQ=y
CONFIG_PARIDE_FRPW=y
# CONFIG_PARIDE_KBIC is not set
# CONFIG_PARIDE_KTTI is not set
# CONFIG_PARIDE_ON20 is not set
CONFIG_PARIDE_ON26=y
# CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
# CONFIG_BLK_CPQ_DA is not set
CONFIG_BLK_CPQ_CISS_DA=y
# CONFIG_CISS_SCSI_TAPE is not set
CONFIG_BLK_DEV_DAC960=y
CONFIG_BLK_DEV_UMEM=y
# CONFIG_BLK_DEV_COW_COMMON is not set
# CONFIG_BLK_DEV_LOOP is not set

#
# DRBD disabled because PROC_FS, INET or CONNECTOR not selected
#
# CONFIG_BLK_DEV_NBD is not set
# CONFIG_BLK_DEV_NVME is not set
CONFIG_BLK_DEV_SX8=y
# CONFIG_BLK_DEV_RAM is not set
# CONFIG_CDROM_PKTCDVD is not set
CONFIG_ATA_OVER_ETH=y
CONFIG_VIRTIO_BLK=y
# CONFIG_BLK_DEV_HD is not set
CONFIG_BLK_DEV_RBD=y

#
# Misc devices
#
CONFIG_SENSORS_LIS3LV02D=y
# CONFIG_IBM_ASM is not set
CONFIG_PHANTOM=y
# CONFIG_INTEL_MID_PTI is not set
# CONFIG_SGI_IOC4 is not set
# CONFIG_TIFM_CORE is not set
# CONFIG_ICS932S401 is not set
CONFIG_ENCLOSURE_SERVICES=y
# CONFIG_CS5535_MFGPT is not set
# CONFIG_HP_ILO is not set
CONFIG_APDS9802ALS=y
CONFIG_ISL29020=y
CONFIG_SENSORS_BH1770=y
CONFIG_SENSORS_APDS990X=y
CONFIG_HMC6352=y
CONFIG_DS1682=y
CONFIG_VMWARE_BALLOON=y
CONFIG_PCH_PHUB=y
# CONFIG_USB_SWITCH_FSA9480 is not set
CONFIG_C2PORT=y
# CONFIG_C2PORT_DURAMAR_2150 is not set

#
# EEPROM support
#
CONFIG_EEPROM_MAX6875=y
CONFIG_EEPROM_93CX6=y
CONFIG_CB710_CORE=y
# CONFIG_CB710_DEBUG is not set
CONFIG_CB710_DEBUG_ASSUMPTIONS=y

#
# Texas Instruments shared transport line discipline
#
CONFIG_TI_ST=y
CONFIG_SENSORS_LIS3_I2C=y

#
# Altera FPGA firmware download module
#
CONFIG_ALTERA_STAPL=y
CONFIG_HAVE_IDE=y
# CONFIG_IDE is not set

#
# SCSI device support
#
CONFIG_SCSI_MOD=y
CONFIG_RAID_ATTRS=y
CONFIG_SCSI=y
CONFIG_SCSI_DMA=y
CONFIG_SCSI_TGT=y
CONFIG_SCSI_NETLINK=y
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set
CONFIG_CHR_DEV_OSST=y
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set
# CONFIG_SCSI_ENCLOSURE is not set
# CONFIG_SCSI_MULTI_LUN is not set
# CONFIG_SCSI_CONSTANTS is not set
CONFIG_SCSI_LOGGING=y
# CONFIG_SCSI_SCAN_ASYNC is not set

#
# SCSI Transports
#
CONFIG_SCSI_SPI_ATTRS=y
CONFIG_SCSI_FC_ATTRS=y
CONFIG_SCSI_FC_TGT_ATTRS=y
CONFIG_SCSI_ISCSI_ATTRS=y
CONFIG_SCSI_SAS_ATTRS=y
CONFIG_SCSI_SAS_LIBSAS=y
# CONFIG_SCSI_SAS_ATA is not set
# CONFIG_SCSI_SAS_HOST_SMP is not set
CONFIG_SCSI_SRP_ATTRS=y
CONFIG_SCSI_SRP_TGT_ATTRS=y
CONFIG_SCSI_LOWLEVEL=y
# CONFIG_ISCSI_TCP is not set
CONFIG_ISCSI_BOOT_SYSFS=y
CONFIG_SCSI_CXGB3_ISCSI=y
CONFIG_SCSI_CXGB4_ISCSI=y
CONFIG_SCSI_BNX2_ISCSI=y
# CONFIG_SCSI_BNX2X_FCOE is not set
CONFIG_BE2ISCSI=y
CONFIG_BLK_DEV_3W_XXXX_RAID=y
CONFIG_SCSI_HPSA=y
# CONFIG_SCSI_3W_9XXX is not set
CONFIG_SCSI_3W_SAS=y
CONFIG_SCSI_ACARD=y
CONFIG_SCSI_AACRAID=y
CONFIG_SCSI_AIC7XXX=y
CONFIG_AIC7XXX_CMDS_PER_DEVICE=32
CONFIG_AIC7XXX_RESET_DELAY_MS=5000
# CONFIG_AIC7XXX_BUILD_FIRMWARE is not set
CONFIG_AIC7XXX_DEBUG_ENABLE=y
CONFIG_AIC7XXX_DEBUG_MASK=0
# CONFIG_AIC7XXX_REG_PRETTY_PRINT is not set
CONFIG_SCSI_AIC7XXX_OLD=y
CONFIG_SCSI_AIC79XX=y
CONFIG_AIC79XX_CMDS_PER_DEVICE=32
CONFIG_AIC79XX_RESET_DELAY_MS=5000
# CONFIG_AIC79XX_BUILD_FIRMWARE is not set
# CONFIG_AIC79XX_DEBUG_ENABLE is not set
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_AIC79XX_REG_PRETTY_PRINT=y
CONFIG_SCSI_AIC94XX=y
CONFIG_AIC94XX_DEBUG=y
CONFIG_SCSI_MVSAS=y
CONFIG_SCSI_MVSAS_DEBUG=y
CONFIG_SCSI_MVSAS_TASKLET=y
CONFIG_SCSI_MVUMI=y
# CONFIG_SCSI_DPT_I2O is not set
# CONFIG_SCSI_ADVANSYS is not set
CONFIG_SCSI_ARCMSR=y
# CONFIG_MEGARAID_NEWGEN is not set
CONFIG_MEGARAID_LEGACY=y
# CONFIG_MEGARAID_SAS is not set
CONFIG_SCSI_MPT2SAS=y
CONFIG_SCSI_MPT2SAS_MAX_SGE=128
CONFIG_SCSI_MPT2SAS_LOGGING=y
# CONFIG_SCSI_UFSHCD is not set
# CONFIG_SCSI_HPTIOP is not set
CONFIG_SCSI_BUSLOGIC=y
CONFIG_SCSI_FLASHPOINT=y
# CONFIG_VMWARE_PVSCSI is not set
CONFIG_HYPERV_STORAGE=y
CONFIG_LIBFC=y
CONFIG_LIBFCOE=y
# CONFIG_FCOE is not set
CONFIG_FCOE_FNIC=y
# CONFIG_SCSI_DMX3191D is not set
CONFIG_SCSI_EATA=y
# CONFIG_SCSI_EATA_TAGGED_QUEUE is not set
CONFIG_SCSI_EATA_LINKED_COMMANDS=y
CONFIG_SCSI_EATA_MAX_TAGS=16
# CONFIG_SCSI_FUTURE_DOMAIN is not set
# CONFIG_SCSI_GDTH is not set
CONFIG_SCSI_ISCI=y
# CONFIG_SCSI_IPS is not set
# CONFIG_SCSI_INITIO is not set
# CONFIG_SCSI_INIA100 is not set
# CONFIG_SCSI_PPA is not set
# CONFIG_SCSI_IMM is not set
CONFIG_SCSI_STEX=y
# CONFIG_SCSI_SYM53C8XX_2 is not set
# CONFIG_SCSI_IPR is not set
# CONFIG_SCSI_QLOGIC_1280 is not set
CONFIG_SCSI_QLA_FC=y
# CONFIG_SCSI_QLA_ISCSI is not set
# CONFIG_SCSI_LPFC is not set
# CONFIG_SCSI_DC395x is not set
CONFIG_SCSI_DC390T=y
# CONFIG_SCSI_NSP32 is not set
CONFIG_SCSI_DEBUG=y
CONFIG_SCSI_PMCRAID=y
# CONFIG_SCSI_PM8001 is not set
# CONFIG_SCSI_SRP is not set
CONFIG_SCSI_BFA_FC=y
CONFIG_SCSI_VIRTIO=y
CONFIG_SCSI_LOWLEVEL_PCMCIA=y
CONFIG_SCSI_DH=y
# CONFIG_SCSI_DH_RDAC is not set
# CONFIG_SCSI_DH_HP_SW is not set
CONFIG_SCSI_DH_EMC=y
# CONFIG_SCSI_DH_ALUA is not set
# CONFIG_SCSI_OSD_INITIATOR is not set
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
# CONFIG_ATA_VERBOSE_ERROR is not set
# CONFIG_ATA_ACPI is not set
# CONFIG_SATA_PMP is not set

#
# Controllers with non-SFF native interface
#
CONFIG_SATA_AHCI=y
CONFIG_SATA_AHCI_PLATFORM=y
CONFIG_SATA_INIC162X=y
CONFIG_SATA_ACARD_AHCI=y
# CONFIG_SATA_SIL24 is not set
# CONFIG_ATA_SFF is not set
CONFIG_MD=y
# CONFIG_BLK_DEV_MD is not set
# CONFIG_BLK_DEV_DM is not set
# CONFIG_TARGET_CORE is not set
# CONFIG_FUSION is not set

#
# IEEE 1394 (FireWire) support
#
CONFIG_FIREWIRE=y
CONFIG_FIREWIRE_OHCI=y
# CONFIG_FIREWIRE_SBP2 is not set
CONFIG_FIREWIRE_NET=y
CONFIG_FIREWIRE_NOSY=y
CONFIG_I2O=y
# CONFIG_I2O_LCT_NOTIFY_ON_CHANGES is not set
# CONFIG_I2O_EXT_ADAPTEC is not set
# CONFIG_I2O_CONFIG is not set
# CONFIG_I2O_BUS is not set
# CONFIG_I2O_BLOCK is not set
# CONFIG_I2O_SCSI is not set
CONFIG_I2O_PROC=y
CONFIG_MACINTOSH_DRIVERS=y
# CONFIG_MAC_EMUMOUSEBTN is not set
CONFIG_NETDEVICES=y
CONFIG_NET_CORE=y
# CONFIG_BONDING is not set
CONFIG_DUMMY=y
CONFIG_EQUALIZER=y
# CONFIG_NET_FC is not set
CONFIG_MII=y
CONFIG_IEEE802154_DRIVERS=y
CONFIG_IEEE802154_FAKEHARD=y
# CONFIG_IFB is not set
CONFIG_NET_TEAM=y
# CONFIG_NET_TEAM_MODE_BROADCAST is not set
# CONFIG_NET_TEAM_MODE_ROUNDROBIN is not set
CONFIG_NET_TEAM_MODE_ACTIVEBACKUP=y
# CONFIG_NET_TEAM_MODE_LOADBALANCE is not set
# CONFIG_MACVLAN is not set
CONFIG_NETCONSOLE=y
CONFIG_NETPOLL=y
# CONFIG_NETPOLL_TRAP is not set
CONFIG_NET_POLL_CONTROLLER=y
# CONFIG_RIONET is not set
# CONFIG_TUN is not set
# CONFIG_VETH is not set
CONFIG_VIRTIO_NET=y
# CONFIG_ARCNET is not set

#
# CAIF transport drivers
#

#
# Distributed Switch Architecture drivers
#
CONFIG_NET_DSA_MV88E6XXX=y
# CONFIG_NET_DSA_MV88E6060 is not set
CONFIG_NET_DSA_MV88E6XXX_NEED_PPU=y
CONFIG_NET_DSA_MV88E6131=y
CONFIG_NET_DSA_MV88E6123_61_65=y
CONFIG_ETHERNET=y
CONFIG_MDIO=y
# CONFIG_NET_VENDOR_3COM is not set
# CONFIG_NET_VENDOR_ADAPTEC is not set
CONFIG_NET_VENDOR_ALTEON=y
CONFIG_ACENIC=y
CONFIG_ACENIC_OMIT_TIGON_I=y
CONFIG_NET_VENDOR_AMD=y
# CONFIG_AMD8111_ETH is not set
# CONFIG_PCNET32 is not set
CONFIG_PCMCIA_NMCLAN=y
CONFIG_NET_VENDOR_ATHEROS=y
CONFIG_ATL2=y
# CONFIG_ATL1 is not set
CONFIG_ATL1E=y
CONFIG_ATL1C=y
CONFIG_NET_VENDOR_BROADCOM=y
CONFIG_B44=y
CONFIG_B44_PCI_AUTOSELECT=y
CONFIG_B44_PCICORE_AUTOSELECT=y
CONFIG_B44_PCI=y
CONFIG_BNX2=y
CONFIG_CNIC=y
# CONFIG_TIGON3 is not set
CONFIG_BNX2X=y
CONFIG_NET_VENDOR_BROCADE=y
# CONFIG_BNA is not set
CONFIG_NET_CALXEDA_XGMAC=y
CONFIG_NET_VENDOR_CHELSIO=y
CONFIG_CHELSIO_T1=y
# CONFIG_CHELSIO_T1_1G is not set
CONFIG_CHELSIO_T3=y
CONFIG_CHELSIO_T4=y
CONFIG_CHELSIO_T4VF=y
CONFIG_NET_VENDOR_CISCO=y
CONFIG_ENIC=y
CONFIG_DNET=y
CONFIG_NET_VENDOR_DEC=y
# CONFIG_NET_TULIP is not set
CONFIG_NET_VENDOR_DLINK=y
CONFIG_DE600=y
CONFIG_DE620=y
# CONFIG_DL2K is not set
# CONFIG_SUNDANCE is not set
# CONFIG_NET_VENDOR_EMULEX is not set
# CONFIG_NET_VENDOR_EXAR is not set
# CONFIG_NET_VENDOR_FUJITSU is not set
CONFIG_NET_VENDOR_HP=y
# CONFIG_HP100 is not set
CONFIG_NET_VENDOR_INTEL=y
CONFIG_E100=y
CONFIG_E1000=y
CONFIG_E1000E=y
# CONFIG_IGB is not set
CONFIG_IGBVF=y
# CONFIG_IXGB is not set
# CONFIG_IXGBE is not set
# CONFIG_IXGBEVF is not set
CONFIG_NET_VENDOR_I825XX=y
CONFIG_ZNET=y
# CONFIG_IP1000 is not set
CONFIG_JME=y
# CONFIG_NET_VENDOR_MARVELL is not set
# CONFIG_NET_VENDOR_MELLANOX is not set
# CONFIG_NET_VENDOR_MICREL is not set
CONFIG_NET_VENDOR_MYRI=y
CONFIG_MYRI10GE=y
# CONFIG_FEALNX is not set
CONFIG_NET_VENDOR_NATSEMI=y
CONFIG_NATSEMI=y
# CONFIG_NS83820 is not set
CONFIG_NET_VENDOR_8390=y
CONFIG_PCMCIA_AXNET=y
CONFIG_NE2K_PCI=y
# CONFIG_PCMCIA_PCNET is not set
CONFIG_NET_VENDOR_NVIDIA=y
CONFIG_FORCEDETH=y
CONFIG_NET_VENDOR_OKI=y
CONFIG_PCH_GBE=y
# CONFIG_ETHOC is not set
# CONFIG_NET_PACKET_ENGINE is not set
CONFIG_NET_VENDOR_QLOGIC=y
CONFIG_QLA3XXX=y
CONFIG_QLCNIC=y
# CONFIG_QLGE is not set
CONFIG_NETXEN_NIC=y
CONFIG_NET_VENDOR_REALTEK=y
CONFIG_ATP=y
CONFIG_8139CP=y
# CONFIG_8139TOO is not set
CONFIG_R8169=y
# CONFIG_NET_VENDOR_RDC is not set
CONFIG_NET_VENDOR_SEEQ=y
CONFIG_SEEQ8005=y
CONFIG_NET_VENDOR_SILAN=y
CONFIG_SC92031=y
# CONFIG_NET_VENDOR_SIS is not set
# CONFIG_SFC is not set
# CONFIG_NET_VENDOR_SMSC is not set
# CONFIG_NET_VENDOR_STMICRO is not set
# CONFIG_NET_VENDOR_SUN is not set
CONFIG_NET_VENDOR_TEHUTI=y
# CONFIG_TEHUTI is not set
CONFIG_NET_VENDOR_TI=y
CONFIG_TLAN=y
# CONFIG_NET_VENDOR_VIA is not set
# CONFIG_NET_VENDOR_WIZNET is not set
# CONFIG_NET_VENDOR_XIRCOM is not set
# CONFIG_FDDI is not set
CONFIG_HIPPI=y
# CONFIG_ROADRUNNER is not set
# CONFIG_NET_SB1000 is not set
CONFIG_PHYLIB=y

#
# MII PHY device drivers
#
# CONFIG_AMD_PHY is not set
CONFIG_MARVELL_PHY=y
CONFIG_DAVICOM_PHY=y
# CONFIG_QSEMI_PHY is not set
CONFIG_LXT_PHY=y
CONFIG_CICADA_PHY=y
CONFIG_VITESSE_PHY=y
CONFIG_SMSC_PHY=y
# CONFIG_BROADCOM_PHY is not set
# CONFIG_BCM87XX_PHY is not set
CONFIG_ICPLUS_PHY=y
CONFIG_REALTEK_PHY=y
# CONFIG_NATIONAL_PHY is not set
CONFIG_STE10XP=y
# CONFIG_LSI_ET1011C_PHY is not set
CONFIG_MICREL_PHY=y
# CONFIG_FIXED_PHY is not set
# CONFIG_MDIO_BITBANG is not set
CONFIG_MDIO_BUS_MUX=y
CONFIG_MDIO_BUS_MUX_GPIO=y
# CONFIG_PLIP is not set
CONFIG_PPP=y
CONFIG_PPP_BSDCOMP=y
# CONFIG_PPP_DEFLATE is not set
CONFIG_PPP_FILTER=y
CONFIG_PPP_MPPE=y
CONFIG_PPP_MULTILINK=y
CONFIG_PPPOE=y
CONFIG_PPTP=y
CONFIG_PPPOL2TP=y
CONFIG_PPP_ASYNC=y
# CONFIG_PPP_SYNC_TTY is not set
# CONFIG_SLIP is not set
CONFIG_SLHC=y
CONFIG_WLAN=y
# CONFIG_PCMCIA_RAYCS is not set
CONFIG_LIBERTAS_THINFIRM=y
# CONFIG_LIBERTAS_THINFIRM_DEBUG is not set
CONFIG_AIRO=y
# CONFIG_ATMEL is not set
# CONFIG_AIRO_CS is not set
CONFIG_PCMCIA_WL3501=y
CONFIG_PRISM54=y
# CONFIG_RTL8180 is not set
# CONFIG_ADM8211 is not set
CONFIG_MAC80211_HWSIM=y
CONFIG_MWL8K=y
# CONFIG_ATH_COMMON is not set
CONFIG_B43=y
CONFIG_B43_BCMA=y
# CONFIG_B43_BCMA_EXTRA is not set
CONFIG_B43_SSB=y
CONFIG_B43_PCI_AUTOSELECT=y
CONFIG_B43_PCICORE_AUTOSELECT=y
# CONFIG_B43_PCMCIA is not set
CONFIG_B43_BCMA_PIO=y
CONFIG_B43_PIO=y
CONFIG_B43_PHY_N=y
# CONFIG_B43_PHY_LP is not set
CONFIG_B43_PHY_HT=y
CONFIG_B43_LEDS=y
CONFIG_B43_DEBUG=y
CONFIG_B43LEGACY=y
CONFIG_B43LEGACY_PCI_AUTOSELECT=y
CONFIG_B43LEGACY_PCICORE_AUTOSELECT=y
CONFIG_B43LEGACY_LEDS=y
# CONFIG_B43LEGACY_DEBUG is not set
CONFIG_B43LEGACY_PIO=y
# CONFIG_B43LEGACY_DMA_AND_PIO_MODE is not set
# CONFIG_B43LEGACY_DMA_MODE is not set
CONFIG_B43LEGACY_PIO_MODE=y
CONFIG_BRCMUTIL=y
CONFIG_BRCMSMAC=y
CONFIG_BRCMFMAC=y
# CONFIG_BRCMDBG is not set
# CONFIG_HOSTAP is not set
# CONFIG_IPW2100 is not set
CONFIG_IPW2200=y
CONFIG_IPW2200_MONITOR=y
CONFIG_IPW2200_RADIOTAP=y
CONFIG_IPW2200_PROMISCUOUS=y
CONFIG_IPW2200_QOS=y
# CONFIG_IPW2200_DEBUG is not set
CONFIG_LIBIPW=y
CONFIG_LIBIPW_DEBUG=y
# CONFIG_IWLWIFI is not set
CONFIG_IWLEGACY=y
# CONFIG_IWL4965 is not set
CONFIG_IWL3945=y

#
# iwl3945 / iwl4965 Debugging Options
#
# CONFIG_IWLEGACY_DEBUG is not set
# CONFIG_LIBERTAS is not set
CONFIG_HERMES=y
CONFIG_HERMES_PRISM=y
# CONFIG_HERMES_CACHE_FW_ON_INIT is not set
# CONFIG_PLX_HERMES is not set
# CONFIG_TMD_HERMES is not set
# CONFIG_NORTEL_HERMES is not set
CONFIG_PCI_HERMES=y
# CONFIG_PCMCIA_HERMES is not set
# CONFIG_PCMCIA_SPECTRUM is not set
CONFIG_P54_COMMON=y
# CONFIG_P54_PCI is not set
CONFIG_P54_LEDS=y
# CONFIG_RT2X00 is not set
CONFIG_RTL8192CE=y
CONFIG_RTL8192SE=y
CONFIG_RTL8192DE=y
CONFIG_RTLWIFI=y
# CONFIG_RTLWIFI_DEBUG is not set
CONFIG_RTL8192C_COMMON=y
# CONFIG_WL_TI is not set
CONFIG_MWIFIEX=y
CONFIG_MWIFIEX_PCIE=y

#
# WiMAX Wireless Broadband devices
#

#
# Enable USB support to see WiMAX USB drivers
#
CONFIG_WAN=y
# CONFIG_HDLC is not set
# CONFIG_DLCI is not set
CONFIG_WAN_ROUTER_DRIVERS=y
CONFIG_CYCLADES_SYNC=y
CONFIG_CYCLOMX_X25=y
CONFIG_SBNI=y
# CONFIG_SBNI_MULTILINE is not set
CONFIG_VMXNET3=y
# CONFIG_HYPERV_NET is not set
# CONFIG_ISDN is not set

#
# Input device support
#
CONFIG_INPUT=y
# CONFIG_INPUT_FF_MEMLESS is not set
CONFIG_INPUT_POLLDEV=y
# CONFIG_INPUT_SPARSEKMAP is not set
# CONFIG_INPUT_MATRIXKMAP is not set

#
# Userland interfaces
#
# CONFIG_INPUT_MOUSEDEV is not set
CONFIG_INPUT_JOYDEV=y
CONFIG_INPUT_EVDEV=y
CONFIG_INPUT_EVBUG=y

#
# Input Device Drivers
#
CONFIG_INPUT_KEYBOARD=y
# CONFIG_KEYBOARD_ADP5520 is not set
# CONFIG_KEYBOARD_ADP5588 is not set
# CONFIG_KEYBOARD_ADP5589 is not set
CONFIG_KEYBOARD_ATKBD=y
# CONFIG_KEYBOARD_QT1070 is not set
# CONFIG_KEYBOARD_QT2160 is not set
# CONFIG_KEYBOARD_LKKBD is not set
# CONFIG_KEYBOARD_GPIO is not set
# CONFIG_KEYBOARD_GPIO_POLLED is not set
# CONFIG_KEYBOARD_TCA6416 is not set
# CONFIG_KEYBOARD_TCA8418 is not set
# CONFIG_KEYBOARD_MATRIX is not set
# CONFIG_KEYBOARD_LM8323 is not set
# CONFIG_KEYBOARD_LM8333 is not set
# CONFIG_KEYBOARD_MAX7359 is not set
# CONFIG_KEYBOARD_MCS is not set
# CONFIG_KEYBOARD_MPR121 is not set
# CONFIG_KEYBOARD_NEWTON is not set
# CONFIG_KEYBOARD_OPENCORES is not set
# CONFIG_KEYBOARD_STOWAWAY is not set
# CONFIG_KEYBOARD_SUNKBD is not set
# CONFIG_KEYBOARD_STMPE is not set
# CONFIG_KEYBOARD_OMAP4 is not set
# CONFIG_KEYBOARD_XTKBD is not set
# CONFIG_INPUT_MOUSE is not set
# CONFIG_INPUT_JOYSTICK is not set
CONFIG_INPUT_TABLET=y
# CONFIG_TABLET_USB_ACECAD is not set
# CONFIG_TABLET_USB_AIPTEK is not set
# CONFIG_TABLET_USB_HANWANG is not set
# CONFIG_TABLET_USB_KBTAB is not set
# CONFIG_TABLET_USB_WACOM is not set
# CONFIG_INPUT_TOUCHSCREEN is not set
# CONFIG_INPUT_MISC is not set

#
# Hardware I/O ports
#
CONFIG_SERIO=y
CONFIG_SERIO_I8042=y
CONFIG_SERIO_SERPORT=y
CONFIG_SERIO_CT82C710=y
CONFIG_SERIO_PARKBD=y
CONFIG_SERIO_PCIPS2=y
CONFIG_SERIO_LIBPS2=y
CONFIG_SERIO_RAW=y
# CONFIG_SERIO_ALTERA_PS2 is not set
# CONFIG_SERIO_PS2MULT is not set
CONFIG_GAMEPORT=y
CONFIG_GAMEPORT_NS558=y
CONFIG_GAMEPORT_L4=y
# CONFIG_GAMEPORT_EMU10K1 is not set
CONFIG_GAMEPORT_FM801=y

#
# Character devices
#
# CONFIG_VT is not set
# CONFIG_UNIX98_PTYS is not set
CONFIG_LEGACY_PTYS=y
CONFIG_LEGACY_PTY_COUNT=256
# CONFIG_SERIAL_NONSTANDARD is not set
CONFIG_NOZOMI=y
CONFIG_N_GSM=y
# CONFIG_TRACE_SINK is not set
# CONFIG_DEVKMEM is not set

#
# Serial drivers
#
CONFIG_SERIAL_8250=y
CONFIG_SERIAL_8250_CONSOLE=y
CONFIG_FIX_EARLYCON_MEM=y
CONFIG_SERIAL_8250_PCI=y
# CONFIG_SERIAL_8250_PNP is not set
# CONFIG_SERIAL_8250_CS is not set
CONFIG_SERIAL_8250_NR_UARTS=4
CONFIG_SERIAL_8250_RUNTIME_UARTS=4
# CONFIG_SERIAL_8250_EXTENDED is not set
CONFIG_SERIAL_8250_DW=y

#
# Non-8250 serial port support
#
CONFIG_SERIAL_MFD_HSU=y
# CONFIG_SERIAL_MFD_HSU_CONSOLE is not set
CONFIG_SERIAL_CORE=y
CONFIG_SERIAL_CORE_CONSOLE=y
CONFIG_CONSOLE_POLL=y
# CONFIG_SERIAL_JSM is not set
# CONFIG_SERIAL_OF_PLATFORM is not set
CONFIG_SERIAL_TIMBERDALE=y
CONFIG_SERIAL_ALTERA_JTAGUART=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS=y
# CONFIG_SERIAL_ALTERA_UART is not set
# CONFIG_SERIAL_PCH_UART is not set
# CONFIG_SERIAL_XILINX_PS_UART is not set
CONFIG_TTY_PRINTK=y
CONFIG_PRINTER=y
# CONFIG_LP_CONSOLE is not set
# CONFIG_PPDEV is not set
CONFIG_HVC_DRIVER=y
CONFIG_VIRTIO_CONSOLE=y
# CONFIG_IPMI_HANDLER is not set
# CONFIG_HW_RANDOM is not set
CONFIG_NVRAM=y
CONFIG_R3964=y
CONFIG_APPLICOM=y
# CONFIG_SONYPI is not set

#
# PCMCIA character devices
#
CONFIG_SYNCLINK_CS=y
# CONFIG_CARDMAN_4000 is not set
# CONFIG_CARDMAN_4040 is not set
CONFIG_IPWIRELESS=y
CONFIG_MWAVE=y
CONFIG_SCx200_GPIO=y
CONFIG_PC8736x_GPIO=y
CONFIG_NSC_GPIO=y
CONFIG_RAW_DRIVER=y
CONFIG_MAX_RAW_DEVS=256
CONFIG_HPET=y
# CONFIG_HPET_MMAP is not set
# CONFIG_HANGCHECK_TIMER is not set
# CONFIG_TCG_TPM is not set
CONFIG_TELCLOCK=y
CONFIG_DEVPORT=y
CONFIG_I2C=y
CONFIG_I2C_BOARDINFO=y
# CONFIG_I2C_COMPAT is not set
CONFIG_I2C_CHARDEV=y
CONFIG_I2C_MUX=y

#
# Multiplexer I2C Chip support
#
CONFIG_I2C_MUX_GPIO=y
# CONFIG_I2C_MUX_PCA9541 is not set
# CONFIG_I2C_MUX_PCA954x is not set
CONFIG_I2C_HELPER_AUTO=y
CONFIG_I2C_SMBUS=y
CONFIG_I2C_ALGOBIT=y

#
# I2C Hardware Bus support
#

#
# PC SMBus host controller drivers
#
CONFIG_I2C_ALI1535=y
# CONFIG_I2C_ALI1563 is not set
CONFIG_I2C_ALI15X3=y
# CONFIG_I2C_AMD756 is not set
CONFIG_I2C_AMD8111=y
CONFIG_I2C_I801=y
# CONFIG_I2C_ISCH is not set
CONFIG_I2C_PIIX4=y
# CONFIG_I2C_NFORCE2 is not set
CONFIG_I2C_SIS5595=y
CONFIG_I2C_SIS630=y
# CONFIG_I2C_SIS96X is not set
# CONFIG_I2C_VIA is not set
CONFIG_I2C_VIAPRO=y

#
# ACPI drivers
#
# CONFIG_I2C_SCMI is not set

#
# I2C system bus drivers (mostly embedded / system-on-chip)
#
# CONFIG_I2C_DESIGNWARE_PCI is not set
CONFIG_I2C_EG20T=y
CONFIG_I2C_GPIO=y
CONFIG_I2C_INTEL_MID=y
CONFIG_I2C_OCORES=y
# CONFIG_I2C_PCA_PLATFORM is not set
CONFIG_I2C_PXA=y
CONFIG_I2C_PXA_PCI=y
CONFIG_I2C_SIMTEC=y
# CONFIG_I2C_XILINX is not set

#
# External I2C/SMBus adapter drivers
#
CONFIG_I2C_PARPORT=y
CONFIG_I2C_PARPORT_LIGHT=y
CONFIG_I2C_TAOS_EVM=y

#
# Other I2C/SMBus bus drivers
#
# CONFIG_SCx200_I2C is not set
# CONFIG_SCx200_ACB is not set
# CONFIG_I2C_DEBUG_CORE is not set
CONFIG_I2C_DEBUG_ALGO=y
# CONFIG_I2C_DEBUG_BUS is not set
# CONFIG_SPI is not set
CONFIG_HSI=y
CONFIG_HSI_BOARDINFO=y

#
# HSI clients
#
CONFIG_HSI_CHAR=y

#
# PPS support
#
# CONFIG_PPS is not set

#
# PPS generators support
#

#
# PTP clock support
#

#
# Enable Device Drivers -> PPS to see the PTP clock options.
#
CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
CONFIG_GPIOLIB=y
CONFIG_OF_GPIO=y
CONFIG_DEBUG_GPIO=y

#
# Memory mapped GPIO drivers:
#
# CONFIG_GPIO_GENERIC_PLATFORM is not set
CONFIG_GPIO_IT8761E=y
# CONFIG_GPIO_SCH is not set
# CONFIG_GPIO_ICH is not set
# CONFIG_GPIO_VX855 is not set

#
# I2C GPIO expanders:
#
# CONFIG_GPIO_MAX7300 is not set
CONFIG_GPIO_MAX732X=y
CONFIG_GPIO_MAX732X_IRQ=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_GPIO_PCF857X is not set
CONFIG_GPIO_RC5T583=y
CONFIG_GPIO_SX150X=y
# CONFIG_GPIO_STMPE is not set
CONFIG_GPIO_WM831X=y
CONFIG_GPIO_WM8994=y
# CONFIG_GPIO_ADP5520 is not set
# CONFIG_GPIO_ADP5588 is not set

#
# PCI GPIO expanders:
#
# CONFIG_GPIO_CS5535 is not set
# CONFIG_GPIO_BT8XX is not set
# CONFIG_GPIO_AMD8111 is not set
CONFIG_GPIO_LANGWELL=y
# CONFIG_GPIO_PCH is not set
CONFIG_GPIO_ML_IOH=y
# CONFIG_GPIO_SODAVILLE is not set
CONFIG_GPIO_RDC321X=y

#
# SPI GPIO expanders:
#
CONFIG_GPIO_MCP23S08=y

#
# AC97 GPIO expanders:
#

#
# MODULbus GPIO expanders:
#
CONFIG_W1=y

#
# 1-wire Bus Masters
#
CONFIG_W1_MASTER_MATROX=y
# CONFIG_W1_MASTER_DS2482 is not set
# CONFIG_W1_MASTER_DS1WM is not set
CONFIG_W1_MASTER_GPIO=y
# CONFIG_HDQ_MASTER_OMAP is not set

#
# 1-wire Slaves
#
CONFIG_W1_SLAVE_THERM=y
# CONFIG_W1_SLAVE_SMEM is not set
CONFIG_W1_SLAVE_DS2408=y
# CONFIG_W1_SLAVE_DS2423 is not set
# CONFIG_W1_SLAVE_DS2431 is not set
# CONFIG_W1_SLAVE_DS2433 is not set
CONFIG_W1_SLAVE_DS2760=y
# CONFIG_W1_SLAVE_DS2780 is not set
CONFIG_W1_SLAVE_DS2781=y
# CONFIG_W1_SLAVE_DS28E04 is not set
# CONFIG_W1_SLAVE_BQ27000 is not set
CONFIG_POWER_SUPPLY=y
# CONFIG_POWER_SUPPLY_DEBUG is not set
CONFIG_PDA_POWER=y
# CONFIG_MAX8925_POWER is not set
CONFIG_WM831X_BACKUP=y
# CONFIG_WM831X_POWER is not set
CONFIG_TEST_POWER=y
# CONFIG_BATTERY_DS2760 is not set
# CONFIG_BATTERY_DS2780 is not set
CONFIG_BATTERY_DS2781=y
# CONFIG_BATTERY_DS2782 is not set
CONFIG_BATTERY_OLPC=y
# CONFIG_BATTERY_SBS is not set
CONFIG_BATTERY_BQ27x00=y
# CONFIG_BATTERY_BQ27X00_I2C is not set
# CONFIG_BATTERY_BQ27X00_PLATFORM is not set
# CONFIG_BATTERY_DA9030 is not set
CONFIG_BATTERY_MAX17040=y
# CONFIG_BATTERY_MAX17042 is not set
# CONFIG_CHARGER_MAX8903 is not set
# CONFIG_CHARGER_LP8727 is not set
# CONFIG_CHARGER_GPIO is not set
# CONFIG_CHARGER_SMB347 is not set
# CONFIG_POWER_AVS is not set
CONFIG_HWMON=y
CONFIG_HWMON_VID=y
# CONFIG_HWMON_DEBUG_CHIP is not set

#
# Native drivers
#
CONFIG_SENSORS_AD7414=y
# CONFIG_SENSORS_AD7418 is not set
# CONFIG_SENSORS_ADM1021 is not set
# CONFIG_SENSORS_ADM1025 is not set
# CONFIG_SENSORS_ADM1026 is not set
CONFIG_SENSORS_ADM1029=y
CONFIG_SENSORS_ADM1031=y
# CONFIG_SENSORS_ADM9240 is not set
# CONFIG_SENSORS_ADT7410 is not set
CONFIG_SENSORS_ADT7411=y
# CONFIG_SENSORS_ADT7462 is not set
# CONFIG_SENSORS_ADT7470 is not set
CONFIG_SENSORS_ADT7475=y
# CONFIG_SENSORS_ASC7621 is not set
CONFIG_SENSORS_K8TEMP=y
CONFIG_SENSORS_K10TEMP=y
# CONFIG_SENSORS_FAM15H_POWER is not set
CONFIG_SENSORS_ASB100=y
# CONFIG_SENSORS_ATXP1 is not set
# CONFIG_SENSORS_DS620 is not set
CONFIG_SENSORS_DS1621=y
# CONFIG_SENSORS_DA9052_ADC is not set
CONFIG_SENSORS_I5K_AMB=y
# CONFIG_SENSORS_F71805F is not set
CONFIG_SENSORS_F71882FG=y
# CONFIG_SENSORS_F75375S is not set
# CONFIG_SENSORS_FSCHMD is not set
# CONFIG_SENSORS_G760A is not set
CONFIG_SENSORS_GL518SM=y
# CONFIG_SENSORS_GL520SM is not set
# CONFIG_SENSORS_GPIO_FAN is not set
# CONFIG_SENSORS_HIH6130 is not set
# CONFIG_SENSORS_CORETEMP is not set
# CONFIG_SENSORS_IT87 is not set
CONFIG_SENSORS_JC42=y
# CONFIG_SENSORS_LINEAGE is not set
CONFIG_SENSORS_LM63=y
# CONFIG_SENSORS_LM73 is not set
# CONFIG_SENSORS_LM75 is not set
CONFIG_SENSORS_LM77=y
CONFIG_SENSORS_LM78=y
# CONFIG_SENSORS_LM80 is not set
# CONFIG_SENSORS_LM83 is not set
# CONFIG_SENSORS_LM85 is not set
# CONFIG_SENSORS_LM87 is not set
CONFIG_SENSORS_LM90=y
# CONFIG_SENSORS_LM92 is not set
CONFIG_SENSORS_LM93=y
# CONFIG_SENSORS_LTC4151 is not set
# CONFIG_SENSORS_LTC4215 is not set
# CONFIG_SENSORS_LTC4245 is not set
CONFIG_SENSORS_LTC4261=y
CONFIG_SENSORS_LM95241=y
CONFIG_SENSORS_LM95245=y
CONFIG_SENSORS_MAX16065=y
# CONFIG_SENSORS_MAX1619 is not set
# CONFIG_SENSORS_MAX1668 is not set
CONFIG_SENSORS_MAX6639=y
CONFIG_SENSORS_MAX6642=y
CONFIG_SENSORS_MAX6650=y
CONFIG_SENSORS_MCP3021=y
CONFIG_SENSORS_NTC_THERMISTOR=y
CONFIG_SENSORS_PC87360=y
CONFIG_SENSORS_PC87427=y
# CONFIG_SENSORS_PCF8591 is not set
# CONFIG_PMBUS is not set
CONFIG_SENSORS_SHT15=y
CONFIG_SENSORS_SHT21=y
# CONFIG_SENSORS_SIS5595 is not set
CONFIG_SENSORS_SMM665=y
# CONFIG_SENSORS_DME1737 is not set
# CONFIG_SENSORS_EMC1403 is not set
# CONFIG_SENSORS_EMC2103 is not set
CONFIG_SENSORS_EMC6W201=y
# CONFIG_SENSORS_SMSC47M1 is not set
# CONFIG_SENSORS_SMSC47M192 is not set
CONFIG_SENSORS_SMSC47B397=y
# CONFIG_SENSORS_SCH56XX_COMMON is not set
CONFIG_SENSORS_ADS1015=y
CONFIG_SENSORS_ADS7828=y
CONFIG_SENSORS_AMC6821=y
# CONFIG_SENSORS_INA2XX is not set
# CONFIG_SENSORS_THMC50 is not set
# CONFIG_SENSORS_TMP102 is not set
CONFIG_SENSORS_TMP401=y
CONFIG_SENSORS_TMP421=y
# CONFIG_SENSORS_VIA_CPUTEMP is not set
# CONFIG_SENSORS_VIA686A is not set
CONFIG_SENSORS_VT1211=y
# CONFIG_SENSORS_VT8231 is not set
# CONFIG_SENSORS_W83781D is not set
# CONFIG_SENSORS_W83791D is not set
CONFIG_SENSORS_W83792D=y
CONFIG_SENSORS_W83793=y
CONFIG_SENSORS_W83795=y
CONFIG_SENSORS_W83795_FANCTRL=y
CONFIG_SENSORS_W83L785TS=y
CONFIG_SENSORS_W83L786NG=y
# CONFIG_SENSORS_W83627HF is not set
# CONFIG_SENSORS_W83627EHF is not set
CONFIG_SENSORS_WM831X=y
# CONFIG_SENSORS_APPLESMC is not set
CONFIG_SENSORS_MC13783_ADC=y

#
# ACPI drivers
#
# CONFIG_SENSORS_ACPI_POWER is not set
CONFIG_SENSORS_ATK0110=y
CONFIG_THERMAL=y
CONFIG_THERMAL_HWMON=y
# CONFIG_CPU_THERMAL is not set
# CONFIG_WATCHDOG is not set
CONFIG_SSB_POSSIBLE=y

#
# Sonics Silicon Backplane
#
CONFIG_SSB=y
CONFIG_SSB_SPROM=y
CONFIG_SSB_BLOCKIO=y
CONFIG_SSB_PCIHOST_POSSIBLE=y
CONFIG_SSB_PCIHOST=y
CONFIG_SSB_B43_PCI_BRIDGE=y
CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
CONFIG_SSB_PCMCIAHOST=y
CONFIG_SSB_SILENT=y
CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
CONFIG_SSB_DRIVER_PCICORE=y
CONFIG_BCMA_POSSIBLE=y

#
# Broadcom specific AMBA
#
CONFIG_BCMA=y
CONFIG_BCMA_BLOCKIO=y
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
# CONFIG_BCMA_HOST_PCI is not set
# CONFIG_BCMA_DRIVER_GMAC_CMN is not set
# CONFIG_BCMA_DEBUG is not set

#
# Multifunction device drivers
#
CONFIG_MFD_CORE=y
CONFIG_MFD_88PM860X=y
# CONFIG_MFD_88PM800 is not set
# CONFIG_MFD_88PM805 is not set
# CONFIG_MFD_SM501 is not set
CONFIG_HTC_PASIC3=y
CONFIG_HTC_I2CPLD=y
# CONFIG_MFD_LM3533 is not set
# CONFIG_TPS6105X is not set
CONFIG_TPS65010=y
# CONFIG_TPS6507X is not set
CONFIG_MFD_TPS65217=y
# CONFIG_MFD_TPS65910 is not set
# CONFIG_MFD_TPS65912_I2C is not set
# CONFIG_TWL4030_CORE is not set
# CONFIG_TWL6040_CORE is not set
CONFIG_MFD_STMPE=y

#
# STMPE Interface Drivers
#
CONFIG_STMPE_I2C=y
# CONFIG_MFD_TC3589X is not set
# CONFIG_MFD_TMIO is not set
CONFIG_PMIC_DA903X=y
CONFIG_PMIC_DA9052=y
CONFIG_MFD_DA9052_I2C=y
CONFIG_PMIC_ADP5520=y
# CONFIG_MFD_MAX77686 is not set
CONFIG_MFD_MAX77693=y
CONFIG_MFD_MAX8925=y
CONFIG_MFD_MAX8997=y
CONFIG_MFD_MAX8998=y
# CONFIG_MFD_SEC_CORE is not set
# CONFIG_MFD_ARIZONA_I2C is not set
# CONFIG_MFD_WM8400 is not set
CONFIG_MFD_WM831X=y
CONFIG_MFD_WM831X_I2C=y
# CONFIG_MFD_WM8350_I2C is not set
CONFIG_MFD_WM8994=y
# CONFIG_MFD_PCF50633 is not set
CONFIG_MFD_MC13783=y
CONFIG_MFD_MC13XXX=y
CONFIG_MFD_MC13XXX_I2C=y
CONFIG_ABX500_CORE=y
# CONFIG_AB3100_CORE is not set
CONFIG_MFD_CS5535=y
# CONFIG_MFD_TIMBERDALE is not set
CONFIG_LPC_SCH=y
# CONFIG_LPC_ICH is not set
CONFIG_MFD_RDC321X=y
# CONFIG_MFD_JANZ_CMODIO is not set
# CONFIG_MFD_VX855 is not set
CONFIG_MFD_WL1273_CORE=y
# CONFIG_MFD_TPS65090 is not set
CONFIG_MFD_AAT2870_CORE=y
CONFIG_MFD_RC5T583=y
CONFIG_MFD_PALMAS=y
# CONFIG_REGULATOR is not set
CONFIG_MEDIA_SUPPORT=y

#
# Multimedia core support
#
# CONFIG_MEDIA_CAMERA_SUPPORT is not set
# CONFIG_MEDIA_ANALOG_TV_SUPPORT is not set
# CONFIG_MEDIA_DIGITAL_TV_SUPPORT is not set
# CONFIG_MEDIA_RADIO_SUPPORT is not set
# CONFIG_MEDIA_RC_SUPPORT is not set
# CONFIG_VIDEO_ADV_DEBUG is not set
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set

#
# Media drivers
#
# CONFIG_MEDIA_PCI_SUPPORT is not set

#
# Supported MMC/SDIO adapters
#

#
# Media ancillary drivers (tuners, sensors, i2c, frontends)
#

#
# Customise DVB Frontends
#
CONFIG_DVB_TUNER_DIB0070=y
CONFIG_DVB_TUNER_DIB0090=y

#
# Tools to develop new frontends
#
# CONFIG_DVB_DUMMY_FE is not set

#
# Graphics support
#
CONFIG_AGP=y
CONFIG_AGP_ALI=y
# CONFIG_AGP_ATI is not set
CONFIG_AGP_AMD=y
# CONFIG_AGP_AMD64 is not set
CONFIG_AGP_INTEL=y
# CONFIG_AGP_NVIDIA is not set
CONFIG_AGP_SIS=y
# CONFIG_AGP_SWORKS is not set
CONFIG_AGP_VIA=y
# CONFIG_AGP_EFFICEON is not set
CONFIG_VGA_ARB=y
CONFIG_VGA_ARB_MAX_GPUS=16
# CONFIG_VGA_SWITCHEROO is not set
CONFIG_DRM=y
CONFIG_DRM_KMS_HELPER=y
# CONFIG_DRM_LOAD_EDID_FIRMWARE is not set
CONFIG_DRM_TTM=y
# CONFIG_DRM_TDFX is not set
CONFIG_DRM_R128=y
CONFIG_DRM_RADEON=y
# CONFIG_DRM_RADEON_KMS is not set
# CONFIG_DRM_NOUVEAU is not set

#
# I2C encoder or helper chips
#
CONFIG_DRM_I2C_CH7006=y
CONFIG_DRM_I2C_SIL164=y
CONFIG_DRM_I915=y
# CONFIG_DRM_I915_KMS is not set
CONFIG_DRM_MGA=y
# CONFIG_DRM_SIS is not set
# CONFIG_DRM_VIA is not set
# CONFIG_DRM_SAVAGE is not set
# CONFIG_DRM_VMWGFX is not set
# CONFIG_DRM_GMA500 is not set
# CONFIG_DRM_UDL is not set
CONFIG_DRM_AST=y
CONFIG_DRM_MGAG200=y
CONFIG_DRM_CIRRUS_QEMU=y
CONFIG_STUB_POULSBO=y
CONFIG_VGASTATE=y
CONFIG_VIDEO_OUTPUT_CONTROL=y
CONFIG_FB=y
# CONFIG_FIRMWARE_EDID is not set
CONFIG_FB_DDC=y
# CONFIG_FB_BOOT_VESA_SUPPORT is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_FB_CFB_COPYAREA=y
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
CONFIG_FB_SYS_FILLRECT=y
CONFIG_FB_SYS_COPYAREA=y
CONFIG_FB_SYS_IMAGEBLIT=y
# CONFIG_FB_FOREIGN_ENDIAN is not set
CONFIG_FB_SYS_FOPS=y
# CONFIG_FB_WMT_GE_ROPS is not set
CONFIG_FB_SVGALIB=y
# CONFIG_FB_MACMODES is not set
CONFIG_FB_BACKLIGHT=y
CONFIG_FB_MODE_HELPERS=y
CONFIG_FB_TILEBLITTING=y

#
# Frame buffer hardware drivers
#
CONFIG_FB_CIRRUS=y
CONFIG_FB_PM2=y
CONFIG_FB_PM2_FIFO_DISCONNECT=y
# CONFIG_FB_CYBER2000 is not set
CONFIG_FB_ARC=y
CONFIG_FB_ASILIANT=y
# CONFIG_FB_IMSTT is not set
# CONFIG_FB_VGA16 is not set
# CONFIG_FB_VESA is not set
# CONFIG_FB_N411 is not set
CONFIG_FB_HGA=y
CONFIG_FB_S1D13XXX=y
CONFIG_FB_NVIDIA=y
CONFIG_FB_NVIDIA_I2C=y
CONFIG_FB_NVIDIA_DEBUG=y
# CONFIG_FB_NVIDIA_BACKLIGHT is not set
CONFIG_FB_RIVA=y
CONFIG_FB_RIVA_I2C=y
CONFIG_FB_RIVA_DEBUG=y
CONFIG_FB_RIVA_BACKLIGHT=y
# CONFIG_FB_I740 is not set
CONFIG_FB_I810=y
CONFIG_FB_I810_GTF=y
CONFIG_FB_I810_I2C=y
CONFIG_FB_LE80578=y
# CONFIG_FB_CARILLO_RANCH is not set
# CONFIG_FB_MATROX is not set
# CONFIG_FB_RADEON is not set
CONFIG_FB_ATY128=y
# CONFIG_FB_ATY128_BACKLIGHT is not set
# CONFIG_FB_ATY is not set
CONFIG_FB_S3=y
# CONFIG_FB_S3_DDC is not set
# CONFIG_FB_SAVAGE is not set
# CONFIG_FB_SIS is not set
# CONFIG_FB_VIA is not set
CONFIG_FB_NEOMAGIC=y
# CONFIG_FB_KYRO is not set
# CONFIG_FB_3DFX is not set
# CONFIG_FB_VOODOO1 is not set
# CONFIG_FB_VT8623 is not set
# CONFIG_FB_TRIDENT is not set
# CONFIG_FB_ARK is not set
# CONFIG_FB_PM3 is not set
CONFIG_FB_CARMINE=y
# CONFIG_FB_CARMINE_DRAM_EVAL is not set
CONFIG_CARMINE_DRAM_CUSTOM=y
CONFIG_FB_GEODE=y
# CONFIG_FB_GEODE_LX is not set
CONFIG_FB_GEODE_GX=y
CONFIG_FB_GEODE_GX1=y
# CONFIG_FB_TMIO is not set
CONFIG_FB_VIRTUAL=y
# CONFIG_FB_METRONOME is not set
# CONFIG_FB_MB862XX is not set
# CONFIG_FB_BROADSHEET is not set
# CONFIG_FB_AUO_K190X is not set
# CONFIG_EXYNOS_VIDEO is not set
CONFIG_BACKLIGHT_LCD_SUPPORT=y
CONFIG_LCD_CLASS_DEVICE=y
# CONFIG_LCD_PLATFORM is not set
CONFIG_BACKLIGHT_CLASS_DEVICE=y
# CONFIG_BACKLIGHT_GENERIC is not set
# CONFIG_BACKLIGHT_PROGEAR is not set
CONFIG_BACKLIGHT_CARILLO_RANCH=y
CONFIG_BACKLIGHT_DA903X=y
# CONFIG_BACKLIGHT_DA9052 is not set
CONFIG_BACKLIGHT_MAX8925=y
# CONFIG_BACKLIGHT_APPLE is not set
# CONFIG_BACKLIGHT_SAHARA is not set
# CONFIG_BACKLIGHT_WM831X is not set
CONFIG_BACKLIGHT_ADP5520=y
CONFIG_BACKLIGHT_ADP8860=y
CONFIG_BACKLIGHT_ADP8870=y
CONFIG_BACKLIGHT_88PM860X=y
CONFIG_BACKLIGHT_AAT2870=y
CONFIG_BACKLIGHT_LP855X=y
CONFIG_LOGO=y
# CONFIG_LOGO_LINUX_MONO is not set
# CONFIG_LOGO_LINUX_VGA16 is not set
# CONFIG_LOGO_LINUX_CLUT224 is not set
# CONFIG_SOUND is not set

#
# HID support
#
# CONFIG_HID is not set
CONFIG_USB_ARCH_HAS_OHCI=y
CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_ARCH_HAS_XHCI=y
CONFIG_USB_SUPPORT=y
CONFIG_USB_ARCH_HAS_HCD=y
# CONFIG_USB is not set
# CONFIG_USB_OTG_WHITELIST is not set
# CONFIG_USB_OTG_BLACKLIST_HUB is not set
# CONFIG_USB_HCD_BCMA is not set
# CONFIG_USB_HCD_SSB is not set

#
# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
#
# CONFIG_USB_GADGET is not set

#
# OTG and related infrastructure
#
# CONFIG_UWB is not set
# CONFIG_MMC is not set
# CONFIG_MEMSTICK is not set
CONFIG_NEW_LEDS=y
CONFIG_LEDS_CLASS=y

#
# LED drivers
#
# CONFIG_LEDS_88PM860X is not set
# CONFIG_LEDS_LM3530 is not set
CONFIG_LEDS_NET48XX=y
# CONFIG_LEDS_WRAP is not set
# CONFIG_LEDS_PCA9532 is not set
CONFIG_LEDS_GPIO=y
# CONFIG_LEDS_LP3944 is not set
# CONFIG_LEDS_LP5521 is not set
CONFIG_LEDS_LP5523=y
# CONFIG_LEDS_PCA955X is not set
# CONFIG_LEDS_PCA9633 is not set
# CONFIG_LEDS_WM831X_STATUS is not set
CONFIG_LEDS_DA903X=y
# CONFIG_LEDS_DA9052 is not set
# CONFIG_LEDS_BD2802 is not set
CONFIG_LEDS_LT3593=y
CONFIG_LEDS_ADP5520=y
# CONFIG_LEDS_MC13783 is not set
CONFIG_LEDS_TCA6507=y
CONFIG_LEDS_MAX8997=y
# CONFIG_LEDS_LM3556 is not set
CONFIG_LEDS_OT200=y
# CONFIG_LEDS_BLINKM is not set
CONFIG_LEDS_TRIGGERS=y

#
# LED Triggers
#
CONFIG_LEDS_TRIGGER_TIMER=y
# CONFIG_LEDS_TRIGGER_ONESHOT is not set
# CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
CONFIG_LEDS_TRIGGER_BACKLIGHT=y
# CONFIG_LEDS_TRIGGER_CPU is not set
# CONFIG_LEDS_TRIGGER_GPIO is not set
CONFIG_LEDS_TRIGGER_DEFAULT_ON=y

#
# iptables trigger is under Netfilter config (LED target)
#
CONFIG_LEDS_TRIGGER_TRANSIENT=y
# CONFIG_ACCESSIBILITY is not set
CONFIG_INFINIBAND=y
CONFIG_INFINIBAND_USER_MAD=y
# CONFIG_INFINIBAND_USER_ACCESS is not set
CONFIG_INFINIBAND_ADDR_TRANS=y
CONFIG_INFINIBAND_MTHCA=y
# CONFIG_INFINIBAND_MTHCA_DEBUG is not set
CONFIG_INFINIBAND_AMSO1100=y
CONFIG_INFINIBAND_AMSO1100_DEBUG=y
CONFIG_INFINIBAND_CXGB3=y
CONFIG_INFINIBAND_CXGB3_DEBUG=y
CONFIG_INFINIBAND_CXGB4=y
# CONFIG_MLX4_INFINIBAND is not set
# CONFIG_INFINIBAND_NES is not set
# CONFIG_INFINIBAND_OCRDMA is not set
# CONFIG_INFINIBAND_IPOIB is not set
# CONFIG_INFINIBAND_SRP is not set
# CONFIG_INFINIBAND_ISER is not set
CONFIG_EDAC=y

#
# Reporting subsystems
#
CONFIG_EDAC_LEGACY_SYSFS=y
CONFIG_EDAC_DEBUG=y
CONFIG_EDAC_DECODE_MCE=y
CONFIG_EDAC_MCE_INJ=y
# CONFIG_EDAC_MM_EDAC is not set
CONFIG_RTC_LIB=y
CONFIG_RTC_CLASS=y
# CONFIG_RTC_HCTOSYS is not set
# CONFIG_RTC_DEBUG is not set

#
# RTC interfaces
#
CONFIG_RTC_INTF_PROC=y
CONFIG_RTC_INTF_DEV=y
CONFIG_RTC_INTF_DEV_UIE_EMUL=y
CONFIG_RTC_DRV_TEST=y

#
# I2C RTC drivers
#
CONFIG_RTC_DRV_88PM860X=y
CONFIG_RTC_DRV_DS1307=y
CONFIG_RTC_DRV_DS1374=y
# CONFIG_RTC_DRV_DS1672 is not set
CONFIG_RTC_DRV_DS3232=y
CONFIG_RTC_DRV_MAX6900=y
CONFIG_RTC_DRV_MAX8925=y
# CONFIG_RTC_DRV_MAX8998 is not set
CONFIG_RTC_DRV_RS5C372=y
# CONFIG_RTC_DRV_ISL1208 is not set
# CONFIG_RTC_DRV_ISL12022 is not set
# CONFIG_RTC_DRV_X1205 is not set
CONFIG_RTC_DRV_PCF8563=y
CONFIG_RTC_DRV_PCF8583=y
CONFIG_RTC_DRV_M41T80=y
# CONFIG_RTC_DRV_M41T80_WDT is not set
# CONFIG_RTC_DRV_BQ32K is not set
CONFIG_RTC_DRV_S35390A=y
CONFIG_RTC_DRV_FM3130=y
CONFIG_RTC_DRV_RX8581=y
# CONFIG_RTC_DRV_RX8025 is not set
CONFIG_RTC_DRV_EM3027=y
CONFIG_RTC_DRV_RV3029C2=y

#
# SPI RTC drivers
#

#
# Platform RTC drivers
#
# CONFIG_RTC_DRV_CMOS is not set
CONFIG_RTC_DRV_DS1286=y
# CONFIG_RTC_DRV_DS1511 is not set
# CONFIG_RTC_DRV_DS1553 is not set
CONFIG_RTC_DRV_DS1742=y
CONFIG_RTC_DRV_DA9052=y
# CONFIG_RTC_DRV_STK17TA8 is not set
CONFIG_RTC_DRV_M48T86=y
# CONFIG_RTC_DRV_M48T35 is not set
# CONFIG_RTC_DRV_M48T59 is not set
# CONFIG_RTC_DRV_MSM6242 is not set
# CONFIG_RTC_DRV_BQ4802 is not set
# CONFIG_RTC_DRV_RP5C01 is not set
CONFIG_RTC_DRV_V3020=y
# CONFIG_RTC_DRV_WM831X is not set

#
# on-CPU RTC drivers
#
# CONFIG_RTC_DRV_MC13XXX is not set
CONFIG_DMADEVICES=y
# CONFIG_DMADEVICES_DEBUG is not set

#
# DMA Devices
#
CONFIG_INTEL_MID_DMAC=y
# CONFIG_INTEL_IOATDMA is not set
# CONFIG_TIMB_DMA is not set
# CONFIG_PCH_DMA is not set
CONFIG_DMA_ENGINE=y

#
# DMA Clients
#
CONFIG_NET_DMA=y
CONFIG_ASYNC_TX_DMA=y
CONFIG_DMATEST=y
CONFIG_AUXDISPLAY=y
# CONFIG_KS0108 is not set
CONFIG_UIO=y
CONFIG_UIO_CIF=y
# CONFIG_UIO_PDRV is not set
CONFIG_UIO_PDRV_GENIRQ=y
CONFIG_UIO_AEC=y
CONFIG_UIO_SERCOS3=y
# CONFIG_UIO_PCI_GENERIC is not set
CONFIG_UIO_NETX=y
# CONFIG_VFIO is not set
CONFIG_VIRTIO=y
CONFIG_VIRTIO_RING=y

#
# Virtio drivers
#
CONFIG_VIRTIO_PCI=y
# CONFIG_VIRTIO_BALLOON is not set
CONFIG_VIRTIO_MMIO=y
CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES=y

#
# Microsoft Hyper-V guest support
#
CONFIG_HYPERV=y
CONFIG_STAGING=y
CONFIG_ET131X=y
# CONFIG_SLICOSS is not set
CONFIG_ECHO=y
CONFIG_FB_OLPC_DCON=y
CONFIG_FB_OLPC_DCON_1_5=y
CONFIG_PANEL=y
CONFIG_PANEL_PARPORT=0
CONFIG_PANEL_PROFILE=5
# CONFIG_PANEL_CHANGE_MESSAGE is not set
# CONFIG_RTS_PSTOR is not set
CONFIG_DX_SEP=y

#
# IIO staging drivers
#
# CONFIG_IIO_ST_HWMON is not set
CONFIG_IIO_SW_RING=y

#
# Accelerometers
#

#
# Analog to digital converters
#
CONFIG_AD7291=y
# CONFIG_AD7606 is not set
# CONFIG_AD799X is not set
CONFIG_ADT7410=y
CONFIG_MAX1363=y
CONFIG_MAX1363_RING_BUFFER=y

#
# Analog digital bi-direction converters
#
# CONFIG_ADT7316 is not set

#
# Capacitance to digital converters
#
# CONFIG_AD7150 is not set
# CONFIG_AD7152 is not set
CONFIG_AD7746=y

#
# Direct Digital Synthesis
#

#
# Digital gyroscope sensors
#

#
# Network Analyzer, Impedance Converters
#
# CONFIG_AD5933 is not set

#
# Inertial measurement units
#

#
# Light sensors
#
CONFIG_SENSORS_ISL29018=y
CONFIG_SENSORS_ISL29028=y
CONFIG_SENSORS_TSL2563=y
# CONFIG_TSL2583 is not set
# CONFIG_TSL2x7x is not set

#
# Magnetometer sensors
#
CONFIG_SENSORS_AK8975=y
# CONFIG_SENSORS_HMC5843 is not set

#
# Active energy metering IC
#
CONFIG_ADE7854=y
CONFIG_ADE7854_I2C=y

#
# Resolver to digital converters
#

#
# Triggers - standalone
#
# CONFIG_IIO_PERIODIC_RTC_TRIGGER is not set
CONFIG_IIO_GPIO_TRIGGER=y
CONFIG_IIO_DUMMY_EVGEN=y
CONFIG_IIO_SIMPLE_DUMMY=y
CONFIG_IIO_SIMPLE_DUMMY_EVENTS=y
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=y
CONFIG_ZSMALLOC=y
CONFIG_WLAGS49_H2=y
CONFIG_WLAGS49_H25=y
CONFIG_FB_SM7XX=y
# CONFIG_CRYSTALHD is not set
# CONFIG_FB_XGI is not set
# CONFIG_ACPI_QUICKSTART is not set
# CONFIG_FT1000 is not set

#
# Speakup console speech
#
# CONFIG_TOUCHSCREEN_CLEARPAD_TM1217 is not set
CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4=y
# CONFIG_STAGING_MEDIA is not set

#
# Android
#
# CONFIG_ANDROID is not set
# CONFIG_PHONE is not set
CONFIG_IPACK_BUS=y
# CONFIG_BOARD_TPCI200 is not set
# CONFIG_SERIAL_IPOCTAL is not set
# CONFIG_WIMAX_GDM72XX is not set
# CONFIG_X86_PLATFORM_DEVICES is not set

#
# Hardware Spinlock drivers
#
CONFIG_CLKSRC_I8253=y
CONFIG_CLKEVT_I8253=y
CONFIG_CLKBLD_I8253=y
CONFIG_IOMMU_API=y
CONFIG_IOMMU_SUPPORT=y
CONFIG_OF_IOMMU=y
CONFIG_DMAR_TABLE=y
CONFIG_INTEL_IOMMU=y
CONFIG_INTEL_IOMMU_DEFAULT_ON=y
CONFIG_INTEL_IOMMU_FLOPPY_WA=y

#
# Remoteproc drivers (EXPERIMENTAL)
#

#
# Rpmsg drivers (EXPERIMENTAL)
#
CONFIG_VIRT_DRIVERS=y
CONFIG_PM_DEVFREQ=y

#
# DEVFREQ Governors
#
# CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND is not set
# CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
CONFIG_DEVFREQ_GOV_POWERSAVE=y
# CONFIG_DEVFREQ_GOV_USERSPACE is not set

#
# DEVFREQ Drivers
#
# CONFIG_EXTCON is not set
CONFIG_MEMORY=y
CONFIG_IIO=y
CONFIG_IIO_BUFFER=y
CONFIG_IIO_KFIFO_BUF=y
CONFIG_IIO_TRIGGER=y
CONFIG_IIO_CONSUMERS_PER_TRIGGER=2

#
# Analog to digital converters
#

#
# Amplifiers
#

#
# Light sensors
#
# CONFIG_ADJD_S311 is not set
# CONFIG_VCNL4000 is not set

#
# Frequency Synthesizers DDS/PLL
#

#
# Clock Generator/Distribution
#

#
# Phase-Locked Loop (PLL) frequency synthesizers
#

#
# Digital to analog converters
#
# CONFIG_AD5064 is not set
CONFIG_AD5380=y
CONFIG_MAX517=y
# CONFIG_MCP4725 is not set
CONFIG_VME_BUS=y

#
# VME Bridge Drivers
#
CONFIG_VME_CA91CX42=y
CONFIG_VME_TSI148=y

#
# VME Board Drivers
#
# CONFIG_VMIVME_7805 is not set

#
# VME Device Drivers
#
# CONFIG_VME_USER is not set
CONFIG_VME_PIO2=y
# CONFIG_PWM is not set

#
# Firmware Drivers
#
CONFIG_EDD=y
# CONFIG_EDD_OFF is not set
CONFIG_FIRMWARE_MEMMAP=y
# CONFIG_DELL_RBU is not set
# CONFIG_DCDBAS is not set
CONFIG_ISCSI_IBFT_FIND=y
# CONFIG_ISCSI_IBFT is not set
# CONFIG_GOOGLE_FIRMWARE is not set

#
# File systems
#
CONFIG_DCACHE_WORD_ACCESS=y
# CONFIG_EXT2_FS is not set
CONFIG_EXT3_FS=y
CONFIG_EXT3_DEFAULTS_TO_ORDERED=y
# CONFIG_EXT3_FS_XATTR is not set
# CONFIG_EXT4_FS is not set
CONFIG_JBD=y
# CONFIG_JBD_DEBUG is not set
CONFIG_REISERFS_FS=y
CONFIG_REISERFS_CHECK=y
# CONFIG_REISERFS_PROC_INFO is not set
# CONFIG_REISERFS_FS_XATTR is not set
CONFIG_JFS_FS=y
CONFIG_JFS_POSIX_ACL=y
# CONFIG_JFS_SECURITY is not set
# CONFIG_JFS_DEBUG is not set
# CONFIG_JFS_STATISTICS is not set
CONFIG_XFS_FS=y
CONFIG_XFS_QUOTA=y
CONFIG_XFS_POSIX_ACL=y
CONFIG_XFS_RT=y
CONFIG_XFS_DEBUG=y
# CONFIG_BTRFS_FS is not set
# CONFIG_NILFS2_FS is not set
CONFIG_FS_POSIX_ACL=y
CONFIG_EXPORTFS=y
# CONFIG_FILE_LOCKING is not set
CONFIG_FSNOTIFY=y
CONFIG_DNOTIFY=y
# CONFIG_INOTIFY_USER is not set
CONFIG_FANOTIFY=y
# CONFIG_QUOTA is not set
# CONFIG_QUOTA_NETLINK_INTERFACE is not set
CONFIG_QUOTACTL=y
CONFIG_AUTOFS4_FS=y
# CONFIG_FUSE_FS is not set

#
# Caches
#
CONFIG_FSCACHE=y
# CONFIG_FSCACHE_STATS is not set
# CONFIG_FSCACHE_HISTOGRAM is not set
CONFIG_FSCACHE_DEBUG=y
# CONFIG_FSCACHE_OBJECT_LIST is not set
CONFIG_CACHEFILES=y
# CONFIG_CACHEFILES_DEBUG is not set
# CONFIG_CACHEFILES_HISTOGRAM is not set

#
# CD-ROM/DVD Filesystems
#
# CONFIG_ISO9660_FS is not set
# CONFIG_UDF_FS is not set

#
# DOS/FAT/NT Filesystems
#
CONFIG_FAT_FS=y
CONFIG_MSDOS_FS=y
CONFIG_VFAT_FS=y
CONFIG_FAT_DEFAULT_CODEPAGE=437
CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
# CONFIG_NTFS_FS is not set

#
# Pseudo filesystems
#
CONFIG_PROC_FS=y
# CONFIG_PROC_KCORE is not set
# CONFIG_PROC_VMCORE is not set
CONFIG_PROC_SYSCTL=y
CONFIG_PROC_PAGE_MONITOR=y
# CONFIG_SYSFS is not set
CONFIG_TMPFS=y
# CONFIG_TMPFS_POSIX_ACL is not set
# CONFIG_TMPFS_XATTR is not set
CONFIG_HUGETLBFS=y
CONFIG_HUGETLB_PAGE=y
# CONFIG_CONFIGFS_FS is not set
CONFIG_MISC_FILESYSTEMS=y
# CONFIG_ADFS_FS is not set
# CONFIG_AFFS_FS is not set
# CONFIG_ECRYPT_FS is not set
CONFIG_HFS_FS=y
CONFIG_HFSPLUS_FS=y
CONFIG_BEFS_FS=y
# CONFIG_BEFS_DEBUG is not set
CONFIG_BFS_FS=y
# CONFIG_EFS_FS is not set
CONFIG_LOGFS=y
CONFIG_CRAMFS=y
CONFIG_SQUASHFS=y
CONFIG_SQUASHFS_XATTR=y
# CONFIG_SQUASHFS_ZLIB is not set
CONFIG_SQUASHFS_LZO=y
CONFIG_SQUASHFS_XZ=y
# CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
# CONFIG_SQUASHFS_EMBEDDED is not set
CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
CONFIG_VXFS_FS=y
CONFIG_MINIX_FS=y
CONFIG_OMFS_FS=y
# CONFIG_HPFS_FS is not set
# CONFIG_QNX4FS_FS is not set
CONFIG_QNX6FS_FS=y
CONFIG_QNX6FS_DEBUG=y
# CONFIG_ROMFS_FS is not set
# CONFIG_PSTORE is not set
# CONFIG_SYSV_FS is not set
CONFIG_UFS_FS=y
# CONFIG_UFS_FS_WRITE is not set
# CONFIG_UFS_DEBUG is not set
CONFIG_NETWORK_FILESYSTEMS=y
CONFIG_CEPH_FS=y
# CONFIG_CIFS is not set
CONFIG_NCP_FS=y
# CONFIG_NCPFS_PACKET_SIGNING is not set
# CONFIG_NCPFS_IOCTL_LOCKING is not set
CONFIG_NCPFS_STRONG=y
# CONFIG_NCPFS_NFS_NS is not set
# CONFIG_NCPFS_OS2_NS is not set
# CONFIG_NCPFS_SMALLDOS is not set
CONFIG_NCPFS_NLS=y
CONFIG_NCPFS_EXTRAS=y
# CONFIG_CODA_FS is not set
CONFIG_AFS_FS=y
CONFIG_AFS_DEBUG=y
CONFIG_AFS_FSCACHE=y
CONFIG_9P_FS=y
CONFIG_9P_FSCACHE=y
# CONFIG_9P_FS_POSIX_ACL is not set
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="iso8859-1"
# CONFIG_NLS_CODEPAGE_437 is not set
# CONFIG_NLS_CODEPAGE_737 is not set
CONFIG_NLS_CODEPAGE_775=y
CONFIG_NLS_CODEPAGE_850=y
# CONFIG_NLS_CODEPAGE_852 is not set
CONFIG_NLS_CODEPAGE_855=y
CONFIG_NLS_CODEPAGE_857=y
# CONFIG_NLS_CODEPAGE_860 is not set
CONFIG_NLS_CODEPAGE_861=y
# CONFIG_NLS_CODEPAGE_862 is not set
# CONFIG_NLS_CODEPAGE_863 is not set
# CONFIG_NLS_CODEPAGE_864 is not set
CONFIG_NLS_CODEPAGE_865=y
CONFIG_NLS_CODEPAGE_866=y
# CONFIG_NLS_CODEPAGE_869 is not set
# CONFIG_NLS_CODEPAGE_936 is not set
CONFIG_NLS_CODEPAGE_950=y
CONFIG_NLS_CODEPAGE_932=y
CONFIG_NLS_CODEPAGE_949=y
CONFIG_NLS_CODEPAGE_874=y
CONFIG_NLS_ISO8859_8=y
# CONFIG_NLS_CODEPAGE_1250 is not set
# CONFIG_NLS_CODEPAGE_1251 is not set
CONFIG_NLS_ASCII=y
# CONFIG_NLS_ISO8859_1 is not set
# CONFIG_NLS_ISO8859_2 is not set
CONFIG_NLS_ISO8859_3=y
CONFIG_NLS_ISO8859_4=y
# CONFIG_NLS_ISO8859_5 is not set
CONFIG_NLS_ISO8859_6=y
# CONFIG_NLS_ISO8859_7 is not set
# CONFIG_NLS_ISO8859_9 is not set
# CONFIG_NLS_ISO8859_13 is not set
CONFIG_NLS_ISO8859_14=y
# CONFIG_NLS_ISO8859_15 is not set
CONFIG_NLS_KOI8_R=y
CONFIG_NLS_KOI8_U=y
# CONFIG_NLS_MAC_ROMAN is not set
CONFIG_NLS_MAC_CELTIC=y
CONFIG_NLS_MAC_CENTEURO=y
CONFIG_NLS_MAC_CROATIAN=y
# CONFIG_NLS_MAC_CYRILLIC is not set
CONFIG_NLS_MAC_GAELIC=y
CONFIG_NLS_MAC_GREEK=y
CONFIG_NLS_MAC_ICELAND=y
CONFIG_NLS_MAC_INUIT=y
# CONFIG_NLS_MAC_ROMANIAN is not set
# CONFIG_NLS_MAC_TURKISH is not set
CONFIG_NLS_UTF8=y

#
# Kernel hacking
#
CONFIG_TRACE_IRQFLAGS_SUPPORT=y
CONFIG_PRINTK_TIME=y
CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
CONFIG_ENABLE_WARN_DEPRECATED=y
# CONFIG_ENABLE_MUST_CHECK is not set
CONFIG_FRAME_WARN=1024
CONFIG_MAGIC_SYSRQ=y
# CONFIG_STRIP_ASM_SYMS is not set
# CONFIG_READABLE_ASM is not set
CONFIG_UNUSED_SYMBOLS=y
CONFIG_DEBUG_FS=y
# CONFIG_HEADERS_CHECK is not set
CONFIG_DEBUG_SECTION_MISMATCH=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_LOCKUP_DETECTOR=y
CONFIG_HARDLOCKUP_DETECTOR=y
# CONFIG_BOOTPARAM_HARDLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE=0
# CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
# CONFIG_PANIC_ON_OOPS is not set
CONFIG_PANIC_ON_OOPS_VALUE=0
# CONFIG_DETECT_HUNG_TASK is not set
CONFIG_SCHED_DEBUG=y
# CONFIG_SCHEDSTATS is not set
# CONFIG_TIMER_STATS is not set
# CONFIG_DEBUG_OBJECTS is not set
# CONFIG_DEBUG_KMEMLEAK is not set
CONFIG_DEBUG_PREEMPT=y
# CONFIG_DEBUG_RT_MUTEXES is not set
# CONFIG_RT_MUTEX_TESTER is not set
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_LOCK_ALLOC=y
CONFIG_PROVE_LOCKING=y
# CONFIG_PROVE_RCU is not set
# CONFIG_PROVE_RCU_DELAY is not set
# CONFIG_SPARSE_RCU_POINTER is not set
CONFIG_LOCKDEP=y
CONFIG_LOCK_STAT=y
CONFIG_DEBUG_LOCKDEP=y
CONFIG_TRACE_IRQFLAGS=y
CONFIG_DEBUG_ATOMIC_SLEEP=y
CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
CONFIG_STACKTRACE=y
CONFIG_DEBUG_STACK_USAGE=y
# CONFIG_DEBUG_KOBJECT is not set
CONFIG_DEBUG_HIGHMEM=y
CONFIG_DEBUG_BUGVERBOSE=y
# CONFIG_DEBUG_INFO is not set
# CONFIG_DEBUG_VM is not set
CONFIG_DEBUG_VIRTUAL=y
# CONFIG_DEBUG_WRITECOUNT is not set
# CONFIG_DEBUG_MEMORY_INIT is not set
# CONFIG_DEBUG_LIST is not set
# CONFIG_TEST_LIST_SORT is not set
# CONFIG_DEBUG_SG is not set
# CONFIG_DEBUG_NOTIFIERS is not set
CONFIG_DEBUG_CREDENTIALS=y
CONFIG_ARCH_WANT_FRAME_POINTERS=y
CONFIG_FRAME_POINTER=y
# CONFIG_BOOT_PRINTK_DELAY is not set
CONFIG_RCU_TORTURE_TEST=y
CONFIG_RCU_TORTURE_TEST_RUNNABLE=y
CONFIG_RCU_CPU_STALL_TIMEOUT=60
CONFIG_RCU_CPU_STALL_VERBOSE=y
# CONFIG_RCU_CPU_STALL_INFO is not set
# CONFIG_RCU_TRACE is not set
# CONFIG_BACKTRACE_SELF_TEST is not set
CONFIG_DEBUG_BLOCK_EXT_DEVT=y
CONFIG_DEBUG_FORCE_WEAK_PER_CPU=y
CONFIG_DEBUG_PER_CPU_MAPS=y
CONFIG_LKDTM=y
# CONFIG_NOTIFIER_ERROR_INJECTION is not set
CONFIG_FAULT_INJECTION=y
# CONFIG_FAILSLAB is not set
# CONFIG_FAIL_PAGE_ALLOC is not set
CONFIG_FAIL_MAKE_REQUEST=y
# CONFIG_FAIL_IO_TIMEOUT is not set
# CONFIG_LATENCYTOP is not set
CONFIG_DEBUG_PAGEALLOC=y
CONFIG_WANT_PAGE_DEBUG_FLAGS=y
CONFIG_PAGE_GUARD=y
CONFIG_USER_STACKTRACE_SUPPORT=y
CONFIG_NOP_TRACER=y
CONFIG_HAVE_FUNCTION_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
CONFIG_HAVE_DYNAMIC_FTRACE=y
CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
CONFIG_HAVE_C_RECORDMCOUNT=y
CONFIG_TRACER_MAX_TRACE=y
CONFIG_RING_BUFFER=y
CONFIG_EVENT_TRACING=y
CONFIG_EVENT_POWER_TRACING_DEPRECATED=y
CONFIG_CONTEXT_SWITCH_TRACER=y
CONFIG_RING_BUFFER_ALLOW_SWAP=y
CONFIG_TRACING=y
CONFIG_GENERIC_TRACER=y
CONFIG_TRACING_SUPPORT=y
CONFIG_FTRACE=y
CONFIG_FUNCTION_TRACER=y
# CONFIG_IRQSOFF_TRACER is not set
CONFIG_PREEMPT_TRACER=y
CONFIG_SCHED_TRACER=y
CONFIG_FTRACE_SYSCALLS=y
CONFIG_TRACE_BRANCH_PROFILING=y
# CONFIG_BRANCH_PROFILE_NONE is not set
# CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
CONFIG_PROFILE_ALL_BRANCHES=y
# CONFIG_BRANCH_TRACER is not set
CONFIG_STACK_TRACER=y
CONFIG_UPROBE_EVENT=y
CONFIG_PROBE_EVENTS=y
# CONFIG_DYNAMIC_FTRACE is not set
# CONFIG_FUNCTION_PROFILER is not set
CONFIG_FTRACE_SELFTEST=y
CONFIG_FTRACE_STARTUP_TEST=y
CONFIG_EVENT_TRACE_TEST_SYSCALLS=y
# CONFIG_MMIOTRACE is not set
# CONFIG_RING_BUFFER_BENCHMARK is not set
# CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
# CONFIG_FIREWIRE_OHCI_REMOTE_DMA is not set
# CONFIG_DYNAMIC_DEBUG is not set
CONFIG_DMA_API_DEBUG=y
CONFIG_ATOMIC64_SELFTEST=y
# CONFIG_SAMPLES is not set
CONFIG_HAVE_ARCH_KGDB=y
CONFIG_KGDB=y
CONFIG_KGDB_SERIAL_CONSOLE=y
# CONFIG_KGDB_TESTS is not set
# CONFIG_KGDB_LOW_LEVEL_TRAP is not set
CONFIG_KGDB_KDB=y
CONFIG_HAVE_ARCH_KMEMCHECK=y
CONFIG_TEST_KSTRTOX=y
CONFIG_STRICT_DEVMEM=y
# CONFIG_X86_VERBOSE_BOOTUP is not set
CONFIG_EARLY_PRINTK=y
# CONFIG_EARLY_PRINTK_DBGP is not set
# CONFIG_DEBUG_STACKOVERFLOW is not set
CONFIG_X86_PTDUMP=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
# CONFIG_DOUBLEFAULT is not set
# CONFIG_DEBUG_TLBFLUSH is not set
CONFIG_IOMMU_STRESS=y
CONFIG_HAVE_MMIOTRACE_SUPPORT=y
CONFIG_IO_DELAY_TYPE_0X80=0
CONFIG_IO_DELAY_TYPE_0XED=1
CONFIG_IO_DELAY_TYPE_UDELAY=2
CONFIG_IO_DELAY_TYPE_NONE=3
# CONFIG_IO_DELAY_0X80 is not set
# CONFIG_IO_DELAY_0XED is not set
# CONFIG_IO_DELAY_UDELAY is not set
CONFIG_IO_DELAY_NONE=y
CONFIG_DEFAULT_IO_DELAY_TYPE=3
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_CPA_DEBUG=y
CONFIG_OPTIMIZE_INLINING=y
CONFIG_DEBUG_NMI_SELFTEST=y

#
# Security options
#
CONFIG_KEYS=y
CONFIG_ENCRYPTED_KEYS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
# CONFIG_SECURITY_DMESG_RESTRICT is not set
CONFIG_SECURITYFS=y
CONFIG_INTEL_TXT=y
CONFIG_DEFAULT_SECURITY_DAC=y
CONFIG_DEFAULT_SECURITY=""
CONFIG_CRYPTO=y

#
# Crypto core or helper
#
CONFIG_CRYPTO_ALGAPI=y
CONFIG_CRYPTO_ALGAPI2=y
CONFIG_CRYPTO_AEAD=y
CONFIG_CRYPTO_AEAD2=y
CONFIG_CRYPTO_BLKCIPHER=y
CONFIG_CRYPTO_BLKCIPHER2=y
CONFIG_CRYPTO_HASH=y
CONFIG_CRYPTO_HASH2=y
CONFIG_CRYPTO_RNG=y
CONFIG_CRYPTO_RNG2=y
CONFIG_CRYPTO_PCOMP2=y
CONFIG_CRYPTO_MANAGER=y
CONFIG_CRYPTO_MANAGER2=y
CONFIG_CRYPTO_USER=y
# CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
CONFIG_CRYPTO_GF128MUL=y
CONFIG_CRYPTO_NULL=y
# CONFIG_CRYPTO_PCRYPT is not set
CONFIG_CRYPTO_WORKQUEUE=y
CONFIG_CRYPTO_CRYPTD=y
CONFIG_CRYPTO_AUTHENC=y
CONFIG_CRYPTO_ABLK_HELPER_X86=y

#
# Authenticated Encryption with Associated Data
#
CONFIG_CRYPTO_CCM=y
# CONFIG_CRYPTO_GCM is not set
CONFIG_CRYPTO_SEQIV=y

#
# Block modes
#
CONFIG_CRYPTO_CBC=y
CONFIG_CRYPTO_CTR=y
CONFIG_CRYPTO_CTS=y
CONFIG_CRYPTO_ECB=y
CONFIG_CRYPTO_LRW=y
# CONFIG_CRYPTO_PCBC is not set
CONFIG_CRYPTO_XTS=y

#
# Hash modes
#
CONFIG_CRYPTO_HMAC=y
# CONFIG_CRYPTO_XCBC is not set
# CONFIG_CRYPTO_VMAC is not set

#
# Digest
#
CONFIG_CRYPTO_CRC32C=y
CONFIG_CRYPTO_CRC32C_INTEL=y
# CONFIG_CRYPTO_GHASH is not set
# CONFIG_CRYPTO_MD4 is not set
CONFIG_CRYPTO_MD5=y
CONFIG_CRYPTO_MICHAEL_MIC=y
# CONFIG_CRYPTO_RMD128 is not set
# CONFIG_CRYPTO_RMD160 is not set
CONFIG_CRYPTO_RMD256=y
# CONFIG_CRYPTO_RMD320 is not set
CONFIG_CRYPTO_SHA1=y
CONFIG_CRYPTO_SHA256=y
CONFIG_CRYPTO_SHA512=y
CONFIG_CRYPTO_TGR192=y
CONFIG_CRYPTO_WP512=y

#
# Ciphers
#
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_586=y
CONFIG_CRYPTO_AES_NI_INTEL=y
CONFIG_CRYPTO_ANUBIS=y
CONFIG_CRYPTO_ARC4=y
# CONFIG_CRYPTO_BLOWFISH is not set
CONFIG_CRYPTO_CAMELLIA=y
CONFIG_CRYPTO_CAST5=y
# CONFIG_CRYPTO_CAST6 is not set
CONFIG_CRYPTO_DES=y
# CONFIG_CRYPTO_FCRYPT is not set
CONFIG_CRYPTO_KHAZAD=y
CONFIG_CRYPTO_SALSA20=y
# CONFIG_CRYPTO_SALSA20_586 is not set
# CONFIG_CRYPTO_SEED is not set
CONFIG_CRYPTO_SERPENT=y
# CONFIG_CRYPTO_SERPENT_SSE2_586 is not set
CONFIG_CRYPTO_TEA=y
# CONFIG_CRYPTO_TWOFISH is not set
CONFIG_CRYPTO_TWOFISH_COMMON=y
CONFIG_CRYPTO_TWOFISH_586=y

#
# Compression
#
# CONFIG_CRYPTO_DEFLATE is not set
# CONFIG_CRYPTO_ZLIB is not set
# CONFIG_CRYPTO_LZO is not set

#
# Random Number Generation
#
# CONFIG_CRYPTO_ANSI_CPRNG is not set
CONFIG_CRYPTO_USER_API=y
# CONFIG_CRYPTO_USER_API_HASH is not set
CONFIG_CRYPTO_USER_API_SKCIPHER=y
# CONFIG_CRYPTO_HW is not set
CONFIG_HAVE_KVM=y
CONFIG_VIRTUALIZATION=y
# CONFIG_KVM is not set
CONFIG_VHOST_NET=y
CONFIG_LGUEST=y
CONFIG_BINARY_PRINTF=y

#
# Library routines
#
CONFIG_BITREVERSE=y
CONFIG_GENERIC_STRNCPY_FROM_USER=y
CONFIG_GENERIC_STRNLEN_USER=y
CONFIG_GENERIC_FIND_FIRST_BIT=y
CONFIG_GENERIC_PCI_IOMAP=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_IO=y
CONFIG_CRC_CCITT=y
CONFIG_CRC16=y
CONFIG_CRC_T10DIF=y
CONFIG_CRC_ITU_T=y
CONFIG_CRC32=y
# CONFIG_CRC32_SELFTEST is not set
# CONFIG_CRC32_SLICEBY8 is not set
# CONFIG_CRC32_SLICEBY4 is not set
# CONFIG_CRC32_SARWATE is not set
CONFIG_CRC32_BIT=y
# CONFIG_CRC7 is not set
CONFIG_LIBCRC32C=y
CONFIG_CRC8=y
CONFIG_AUDIT_GENERIC=y
CONFIG_ZLIB_INFLATE=y
CONFIG_ZLIB_DEFLATE=y
CONFIG_LZO_COMPRESS=y
CONFIG_LZO_DECOMPRESS=y
CONFIG_XZ_DEC=y
CONFIG_XZ_DEC_X86=y
# CONFIG_XZ_DEC_POWERPC is not set
# CONFIG_XZ_DEC_IA64 is not set
# CONFIG_XZ_DEC_ARM is not set
CONFIG_XZ_DEC_ARMTHUMB=y
# CONFIG_XZ_DEC_SPARC is not set
CONFIG_XZ_DEC_BCJ=y
# CONFIG_XZ_DEC_TEST is not set
CONFIG_DECOMPRESS_GZIP=y
CONFIG_GENERIC_ALLOCATOR=y
CONFIG_BTREE=y
CONFIG_HAS_IOMEM=y
CONFIG_HAS_IOPORT=y
CONFIG_HAS_DMA=y
CONFIG_CHECK_SIGNATURE=y
CONFIG_CPUMASK_OFFSTACK=y
CONFIG_NLATTR=y
CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
CONFIG_AVERAGE=y
CONFIG_CORDIC=y
# CONFIG_DDR is not set

--6TrnltStXW4iwmi0--
