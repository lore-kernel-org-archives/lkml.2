Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab0CRX0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 19:26:33 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:55632 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014Ab0CRX0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 19:26:30 -0400
Message-ID: <4BA2B69D.3000309@oracle.com>
Date: Thu, 18 Mar 2010 16:26:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: 2.6.33 GP fault only when built with tracing
Content-Type: multipart/mixed;
 boundary="------------070909020602040903010907"
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BA2B6A1.0159:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070909020602040903010907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I can build/boot 2.6.33 with CONFIG_TRACE/TRACING disabled successfully,
but when I enable lots of tracing config options and then boot with
ftrace=nop on the kernel command line, I see a GP fault when the parport &
parport_pc modules are loading/initializing.

It happens in drivers/parport/share.c::parport_register_device(), when that
function calls try_module_get().

If I comment out the trace_module_get() calls in include/linux/module.h,
the kernel boots with no problems.

[   21.852829] general protection fault: 0000 [#1] SMP 
[   21.856321] last sysfs file: /sys/module/parport/initstate
[   21.856321] CPU 0 
[   21.856321] Pid: 2089, comm: modprobe Not tainted 2.6.33 #11 0HH807/OptiPlex GX620               
[   21.856321] RIP: 0010:[<ffffffffa0437671>]  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
[   21.856321] RSP: 0018:ffff8800765cba78  EFLAGS: 00010283
[   21.856321] RAX: ffff10007b04a3d0 RBX: ffff88007a6a5e30 RCX: 0000000000000000
[   21.856321] RDX: 0000000000000000 RSI: ffffffffa043d1de RDI: ffff88007a6a5e30
[   21.856321] RBP: ffff8800765cbad8 R08: 0000000000000000 R09: 0000000000000000
[   21.856321] R10: ffffffffa043dff8 R11: 0000000000000000 R12: ffffffffa043d1de
[   21.856321] R13: ffffffffa043d1de R14: ffffffffa045c940 R15: 0000000000000000
[   21.856321] FS:  00007f09cc3fb6f0(0000) GS:ffff880004a00000(0000) knlGS:0000000000000000
[   21.856321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.856321] CR2: 0000003fb5ad62c0 CR3: 00000000764f6000 CR4: 00000000000006f0
[   21.856321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.856321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.856321] Process modprobe (pid: 2089, threadinfo ffff8800765ca000, task ffff88007664a3d0)
[   21.856321] Stack:
[   21.856321]  ffff8800765cbab8 0000000000000206 0000000000000000 ffffffff812abaf2
[   21.856321] <0> 0000000000000000 0000000000000000 ffffffffa043d1de 00000000ffffffff
[   21.856321] <0> ffff88007a6a5e30 ffffffffa043d1de 0000000000000000 0000000000000378
[   21.856321] Call Trace:
[   21.856321]  [<ffffffff812abaf2>] ? do_raw_spin_unlock+0xd7/0xe7
[   21.856321]  [<ffffffffa043b385>] parport_open+0x12d/0x14d [parport]
[   21.856321]  [<ffffffffa043bccf>] parport_device_id+0x2e/0xa00 [parport]
[   21.856321]  [<ffffffff8117ab73>] ? __slab_alloc+0x560/0x5f7
[   21.856321]  [<ffffffffa043bb06>] ? parport_daisy_init+0x55f/0x665 [parport]
[   21.856321]  [<ffffffffa043bb06>] ? parport_daisy_init+0x55f/0x665 [parport]
[   21.856321]  [<ffffffffa043bb53>] parport_daisy_init+0x5ac/0x665 [parport]
[   21.856321]  [<ffffffffa0436f6d>] parport_announce_port+0x1a/0x201 [parport]
[   21.856321]  [<ffffffffa0456848>] parport_pc_probe_port+0x13a5/0x1478 [parport_pc]
[   21.856321]  [<ffffffffa0456c36>] parport_pc_pnp_probe+0x31b/0x358 [parport_pc]
[   21.856321]  [<ffffffff81323b1f>] pnp_device_probe+0x11a/0x15e
[   21.856321]  [<ffffffff81376f15>] ? driver_sysfs_add+0x61/0x9b
[   21.856321]  [<ffffffff81377223>] driver_probe_device+0x1bc/0x339
[   21.856321]  [<ffffffff8137743e>] __driver_attach+0x9e/0xde
[   21.856321]  [<ffffffff813773a0>] ? __driver_attach+0x0/0xde
[   21.856321]  [<ffffffff81376038>] bus_for_each_dev+0x83/0xdb
[   21.856321]  [<ffffffff81376e26>] driver_attach+0x25/0x2e
[   21.856321]  [<ffffffff81376823>] bus_add_driver+0x14c/0x367
[   21.856321]  [<ffffffff813778e7>] driver_register+0xf8/0x1b2
[   21.856321]  [<ffffffff81323771>] pnp_register_driver+0x28/0x31
[   21.856321]  [<ffffffffa046380b>] parport_pc_init+0x708/0x7fa [parport_pc]
[   21.856321]  [<ffffffffa0463103>] ? parport_pc_init+0x0/0x7fa [parport_pc]
[   21.856321]  [<ffffffff810020d6>] do_one_initcall+0x9c/0x223
[   21.856321]  [<ffffffff810bcfd9>] sys_init_module+0x139/0x32b
[   21.856321]  [<ffffffff8100c732>] system_call_fastpath+0x16/0x1b
[   21.856321] Code: 65 8b 14 25 d8 e3 00 00 41 83 3e 02 0f 84 80 00 00 00 48 ff 05 09 72 00 00 48 63 d2 49 8b 86 28 02 00 00 48 03 04 d5 b0 97 b9 81 <48> ff 00 49 8b 86 28 02 00 00 48 03 04 d5 b0 97 b9 81 48 8b 00 
[   21.856321] RIP  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
[   21.856321]  RSP <ffff8800765cba78>
[   22.192206] ---[ end trace 892b5882bd1f8c3e ]---


Full kernel boot log is attached.

Is this perhaps already fixed after 2.6.33?

thanks,
-- 
~Randy

--------------070909020602040903010907
Content-Type: text/plain;
 name="2633-tracenop.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename="2633-tracenop.txt"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.33 (rdunlap@control.site) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #11 SMP Wed Mar 17 14:28:17 PDT 2010
[    0.000000] Command line: ro root=/dev/sda6 selinux=0 debug ignore_loglevel initcall_debug printk.time=1 print_fatal_signals=1 kern=2633t console=ttyS0,115200n8 console=tty0 ftrace=nop
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007f686c00 (usable)
[    0.000000]  BIOS-e820: 000000007f686c00 - 000000007f688c00 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007f688c00 - 000000007f68ac00 (ACPI data)
[    0.000000]  BIOS-e820: 000000007f68ac00 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.3 present.
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x7f686 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 07F800000 mask FFF800000 uncachable
[    0.000000]   2 base 07F700000 mask FFFF00000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000001000 (usable)
[    0.000000]  modified: 0000000000001000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 00000000000a0000 (usable)
[    0.000000]  modified: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 000000007f686c00 (usable)
[    0.000000]  modified: 000000007f686c00 - 000000007f688c00 (ACPI NVS)
[    0.000000]  modified: 000000007f688c00 - 000000007f68ac00 (ACPI data)
[    0.000000]  modified: 000000007f68ac00 - 0000000080000000 (reserved)
[    0.000000]  modified: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fed00400 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000feda0000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  modified: 00000000ffb00000 - 000000100000000 (reserved)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000fe710] fe710
[    0.000000] init_memory_mapping: 0000000000000000-000000007f686000
[    0.000000]  0000000000 - 007f600000 page 2M
[    0.000000]  007f600000 - 007f686000 page 4k
[    0.000000] kernel direct mapping tables up to 7f686000 @ 16000-1a000
[    0.000000] RAMDISK: 37baa000 - 37fef4c2
[    0.000000] ACPI: RSDP 00000000000feb00 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000000fd24f 0005C (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: FACP 00000000000fd347 000F4 (v03 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: DSDT 00000000fffd32f4 03D69 (v01   DELL    dt_ex 00001000 INTL 20050309)
[    0.000000] ACPI: FACS 000000007f686c00 00040
[    0.000000] ACPI: SSDT 00000000fffd717c 000AA (v01   DELL    st_ex 00001000 INTL 20050309)
[    0.000000] ACPI: APIC 00000000000fd43b 00072 (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: BOOT 00000000000fd4ad 00028 (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: ASF! 00000000000fd4d5 00067 (v16 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: MCFG 00000000000fd53c 0003E (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: HPET 00000000000fd57a 00038 (v01 DELL    GX620   00000007 ASL  00000061)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007f686000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007f686000
[    0.000000]   NODE_DATA [0000000000018000 - 000000000002cfff]
[    0.000000]   bootmap [000000000002d000 -  000000000003ced7] pages 10
[    0.000000] (12 early reservations) ==> bootmem [0000000000 - 007f686000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0001000000 - 00029961b0]    TEXT DATA BSS ==> [0001000000 - 00029961b0]
[    0.000000]   #2 [0037baa000 - 0037fef4c2]          RAMDISK ==> [0037baa000 - 0037fef4c2]
[    0.000000]   #3 [0002997000 - 000299721c]              BRK ==> [0002997000 - 000299721c]
[    0.000000]   #4 [00000fe720 - 0000100000]    BIOS reserved ==> [00000fe720 - 0000100000]
[    0.000000]   #5 [00000fe710 - 00000fe720]     MP-table mpf ==> [00000fe710 - 00000fe720]
[    0.000000]   #6 [000009fc00 - 00000f0000]    BIOS reserved ==> [000009fc00 - 00000f0000]
[    0.000000]   #7 [00000f0284 - 00000fe710]    BIOS reserved ==> [00000f0284 - 00000fe710]
[    0.000000]   #8 [00000f0000 - 00000f0284]     MP-table mpc ==> [00000f0000 - 00000f0284]
[    0.000000]   #9 [0000010000 - 0000012000]       TRAMPOLINE ==> [0000010000 - 0000012000]
[    0.000000]   #10 [0000012000 - 0000016000]      ACPI WAKEUP ==> [0000012000 - 0000016000]
[    0.000000]   #11 [0000016000 - 0000018000]          PGTABLE ==> [0000016000 - 0000018000]
[    0.000000]  [ffffea0000000000-ffffea0001bfffff] PMD -> [ffff880002e00000-ffff8800049fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x00000001
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x0007f686
[    0.000000] On node 0 totalpages: 521751
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 104 pages reserved
[    0.000000]   DMA zone: 3825 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7079 pages used for memmap
[    0.000000]   DMA32 zone: 510687 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high level lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 0000000000001000 - 0000000000010000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:70000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 480 pages/cpu @ffff880004a00000 s1935704 r8192 d22184 u2097152
[    0.000000] pcpu-alloc: s1935704 r8192 d22184 u2097152 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 [0] 1 [0] 2 [0] 3 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 514512
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: ro root=/dev/sda6 selinux=0 debug ignore_loglevel initcall_debug printk.time=1 print_fatal_signals=1 kern=2633t console=ttyS0,115200n8 console=tty0 ftrace=nop
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 2019236k/2087448k available (4970k kernel code, 444k absent, 67768k reserved, 6933k data, 2852k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] RCU-based detection of stalled CPUs is enabled.
[    0.000000] NR_IRQS:4352 nr_irqs:440
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 6335 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] allocated 20971520 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2992.491 MHz processor.
[    0.003012] Calibrating delay loop (skipped), value calculated using timer frequency.. 5984.98 BogoMIPS (lpj=2992491)
[    0.005755] Security Framework initialized
[    0.007016] SELinux:  Disabled at boot.
[    0.009663] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.012264] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.014169] Mount-cache hash table entries: 256
[    0.017485] Initializing cgroup subsys ns
[    0.018027] Initializing cgroup subsys cpuacct
[    0.019027] Initializing cgroup subsys memory
[    0.020174] Initializing cgroup subsys devices
[    0.021013] Initializing cgroup subsys freezer
[    0.022013] Initializing cgroup subsys net_cls
[    0.023013] Initializing cgroup subsys blkio
[    0.025184] CPU: Physical Processor ID: 0
[    0.026009] CPU: Processor Core ID: 0
[    0.027011] mce: CPU supports 4 MCE banks
[    0.028024] CPU0: Thermal monitoring enabled (TM1)
[    0.029014] using mwait in idle threads.
[    0.030010] Performance Events: no PMU driver, software events only.
[    0.034659] ACPI: Core revision 20091214
[    0.203025] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.204014] ftrace: allocating 18114 entries in 72 pages
[    0.206457] Setting APIC routing to flat
[    0.208490] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.219603] CPU0: Intel(R) Pentium(R)D CPU 3.00GHz stepping 04
[    0.222999] calling  migration_init+0x0/0x7d @ 1
[    0.223246] initcall migration_init+0x0/0x7d returned 0 after 0 usecs
[    0.224009] calling  spawn_ksoftirqd+0x0/0x7c @ 1
[    0.225154] initcall spawn_ksoftirqd+0x0/0x7c returned 0 after 0 usecs
[    0.226011] calling  init_call_single_data+0x0/0xe2 @ 1
[    0.227012] initcall init_call_single_data+0x0/0xe2 returned 0 after 0 usecs
[    0.228009] calling  spawn_softlockup_task+0x0/0xa8 @ 1
[    0.230009] initcall spawn_softlockup_task+0x0/0xa8 returned 0 after 976 usecs
[    0.231010] calling  relay_init+0x0/0x22 @ 1
[    0.232037] initcall relay_init+0x0/0x22 returned 0 after 0 usecs
[    0.233008] calling  tracer_alloc_buffers+0x0/0x2e2 @ 1
[    0.238109] Starting tracer 'nop'
[    0.239059] initcall tracer_alloc_buffers+0x0/0x2e2 returned 0 after 4882 usecs
[    0.240009] calling  init_trace_printk+0x0/0x20 @ 1
[    0.241009] initcall init_trace_printk+0x0/0x20 returned 0 after 0 usecs
[    0.242008] calling  trace_workqueue_early_init+0x0/0x1a1 @ 1
[    0.243108] initcall trace_workqueue_early_init+0x0/0x1a1 returned 0 after 0 usecs
[    0.248699] lockdep: fixing up alternatives.
[    0.249152] Booting Node   0, Processors  #1
[    0.322160] Brought up 2 CPUs
[    0.323012] Total of 2 processors activated (11970.37 BogoMIPS).
[    0.327031] devtmpfs: initialized
[    0.331573] khelper used greatest stack depth: 5744 bytes left
[    0.345213] gcov: version magic: 0x34303452
[    0.351228] calling  init_mmap_min_addr+0x0/0x39 @ 1
[    0.356012] initcall init_mmap_min_addr+0x0/0x39 returned 0 after 0 usecs
[    0.363011] calling  init_cpufreq_transition_notifier_list+0x0/0x29 @ 1
[    0.369018] initcall init_cpufreq_transition_notifier_list+0x0/0x29 returned 0 after 0 usecs
[    0.378010] calling  net_ns_init+0x0/0x15e @ 1
[    0.383061] initcall net_ns_init+0x0/0x15e returned 0 after 976 usecs
[    0.389024] calling  e820_mark_nvs_memory+0x0/0x5c @ 1
[    0.394016] initcall e820_mark_nvs_memory+0x0/0x5c returned 0 after 0 usecs
[    0.401011] calling  cpufreq_tsc+0x0/0x28 @ 1
[    0.406011] initcall cpufreq_tsc+0x0/0x28 returned 0 after 0 usecs
[    0.412011] calling  pci_reboot_init+0x0/0x22 @ 1
[    0.417012] initcall pci_reboot_init+0x0/0x22 returned 0 after 0 usecs
[    0.423011] calling  init_lapic_sysfs+0x0/0x52 @ 1
[    0.429527] initcall init_lapic_sysfs+0x0/0x52 returned 0 after 976 usecs
[    0.436013] calling  init_smp_flush+0x0/0x53 @ 1
[    0.441013] initcall init_smp_flush+0x0/0x53 returned 0 after 0 usecs
[    0.447013] calling  alloc_frozen_cpus+0x0/0x14 @ 1
[    0.452011] initcall alloc_frozen_cpus+0x0/0x14 returned 0 after 0 usecs
[    0.459012] calling  sysctl_init+0x0/0x47 @ 1
[    0.463408] initcall sysctl_init+0x0/0x47 returned 0 after 976 usecs
[    0.470010] calling  ksysfs_init+0x0/0x132 @ 1
[    0.475468] initcall ksysfs_init+0x0/0x132 returned 0 after 0 usecs
[    0.481017] calling  async_init+0x0/0x8c @ 1
[    0.486355] initcall async_init+0x0/0x8c returned 0 after 0 usecs
[    0.492013] calling  init_jiffies_clocksource+0x0/0x20 @ 1
[    0.498018] initcall init_jiffies_clocksource+0x0/0x20 returned 0 after 0 usecs
[    0.505010] calling  pm_init+0x0/0x97 @ 1
[    0.509799] initcall pm_init+0x0/0x97 returned 0 after 0 usecs
[    0.515013] calling  pm_disk_init+0x0/0x27 @ 1
[    0.520033] initcall pm_disk_init+0x0/0x27 returned 0 after 0 usecs
[    0.526011] calling  swsusp_header_init+0x0/0x46 @ 1
[    0.531013] initcall swsusp_header_init+0x0/0x46 returned 0 after 0 usecs
[    0.538010] calling  init_ftrace_syscalls+0x0/0x153 @ 1
[    0.544514] initcall init_ftrace_syscalls+0x0/0x153 returned 0 after 1953 usecs
[    0.552010] calling  init_hw_breakpoint+0x0/0x20 @ 1
[    0.557016] initcall init_hw_breakpoint+0x0/0x20 returned 0 after 0 usecs
[    0.564010] calling  init_zero_pfn+0x0/0x43 @ 1
[    0.568011] initcall init_zero_pfn+0x0/0x43 returned 0 after 0 usecs
[    0.575011] calling  filelock_init+0x0/0x3c @ 1
[    0.579054] initcall filelock_init+0x0/0x3c returned 0 after 0 usecs
[    0.586010] calling  init_misc_binfmt+0x0/0x6c @ 1
[    0.591030] initcall init_misc_binfmt+0x0/0x6c returned 0 after 0 usecs
[    0.597010] calling  init_script_binfmt+0x0/0x22 @ 1
[    0.602012] initcall init_script_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.609010] calling  init_elf_binfmt+0x0/0x22 @ 1
[    0.614012] initcall init_elf_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.621010] calling  init_compat_elf_binfmt+0x0/0x22 @ 1
[    0.626012] initcall init_compat_elf_binfmt+0x0/0x22 returned 0 after 0 usecs
[    0.633010] calling  debugfs_init+0x0/0x85 @ 1
[    0.638024] initcall debugfs_init+0x0/0x85 returned 0 after 0 usecs
[    0.644010] calling  securityfs_init+0x0/0x7c @ 1
[    0.649024] initcall securityfs_init+0x0/0x7c returned 0 after 0 usecs
[    0.656011] calling  random32_init+0x0/0x119 @ 1
[    0.660013] initcall random32_init+0x0/0x119 returned 0 after 0 usecs
[    0.667011] calling  gnttab_init+0x0/0x208 @ 1
[    0.671011] initcall gnttab_init+0x0/0x208 returned -19 after 0 usecs
[    0.678010] calling  regulator_init+0x0/0x43 @ 1
[    0.683015] regulator: core version 0.5
[    0.687266] initcall regulator_init+0x0/0x43 returned 0 after 3906 usecs
[    0.694014] calling  cpufreq_core_init+0x0/0xc5 @ 1
[    0.699028] initcall cpufreq_core_init+0x0/0xc5 returned 0 after 0 usecs
[    0.705010] calling  cpuidle_init+0x0/0x5e @ 1
[    0.710028] initcall cpuidle_init+0x0/0x5e returned 0 after 0 usecs
[    0.716010] calling  sock_init+0x0/0x9d @ 1
[    0.721192] initcall sock_init+0x0/0x9d returned 0 after 976 usecs
[    0.727011] calling  net_inuse_init+0x0/0x3b @ 1
[    0.732018] initcall net_inuse_init+0x0/0x3b returned 0 after 0 usecs
[    0.738010] calling  netpoll_init+0x0/0x22 @ 1
[    0.743011] initcall netpoll_init+0x0/0x22 returned 0 after 0 usecs
[    0.749010] calling  netlink_proto_init+0x0/0x1be @ 1
[    0.754080] NET: Registered protocol family 16
[    0.759102] initcall netlink_proto_init+0x0/0x1be returned 0 after 4882 usecs
[    0.766012] calling  bdi_class_init+0x0/0x56 @ 1
[    0.771542] initcall bdi_class_init+0x0/0x56 returned 0 after 0 usecs
[    0.778018] calling  kobject_uevent_init+0x0/0x77 @ 1
[    0.783038] initcall kobject_uevent_init+0x0/0x77 returned 0 after 0 usecs
[    0.790010] calling  gpiolib_sysfs_init+0x0/0xed @ 1
[    0.795702] initcall gpiolib_sysfs_init+0x0/0xed returned 0 after 0 usecs
[    0.802013] calling  pcibus_class_init+0x0/0x27 @ 1
[    0.807926] initcall pcibus_class_init+0x0/0x27 returned 0 after 976 usecs
[    0.814013] calling  pci_driver_init+0x0/0x20 @ 1
[    0.820079] initcall pci_driver_init+0x0/0x20 returned 0 after 976 usecs
[    0.827027] calling  backlight_class_init+0x0/0x79 @ 1
[    0.832546] initcall backlight_class_init+0x0/0x79 returned 0 after 0 usecs
[    0.839014] calling  xenbus_probe_init+0x0/0x180 @ 1
[    0.844013] initcall xenbus_probe_init+0x0/0x180 returned -19 after 0 usecs
[    0.851010] calling  tty_class_init+0x0/0x4b @ 1
[    0.856694] initcall tty_class_init+0x0/0x4b returned 0 after 0 usecs
[    0.863013] calling  vtconsole_class_init+0x0/0x113 @ 1
[    0.869388] initcall vtconsole_class_init+0x0/0x113 returned 0 after 976 usecs
[    0.876013] calling  register_node_type+0x0/0x84 @ 1
[    0.882245] initcall register_node_type+0x0/0x84 returned 0 after 976 usecs
[    0.889013] calling  spi_init+0x0/0x11d @ 1
[    0.894466] initcall spi_init+0x0/0x11d returned 0 after 976 usecs
[    0.900012] calling  amd_postcore_init+0x0/0xc6 @ 1
[    0.905011] initcall amd_postcore_init+0x0/0xc6 returned 0 after 0 usecs
[    0.912010] calling  arch_kdebugfs_init+0x0/0x3a6 @ 1
[    0.917147] initcall arch_kdebugfs_init+0x0/0x3a6 returned 0 after 0 usecs
[    0.924010] calling  mtrr_if_init+0x0/0x8d @ 1
[    0.929028] initcall mtrr_if_init+0x0/0x8d returned 0 after 0 usecs
[    0.935011] calling  ffh_cstate_init+0x0/0x41 @ 1
[    0.940016] initcall ffh_cstate_init+0x0/0x41 returned 0 after 0 usecs
[    0.946010] calling  acpi_pci_init+0x0/0xa6 @ 1
[    0.951036] ACPI: bus type pci registered
[    0.955011] initcall acpi_pci_init+0x0/0xa6 returned 0 after 3906 usecs
[    0.962010] calling  setup_vcpu_hotplug_event+0x0/0x39 @ 1
[    0.967012] initcall setup_vcpu_hotplug_event+0x0/0x39 returned -19 after 0 usecs
[    0.975010] calling  dmi_id_init+0x0/0x499 @ 1
[    0.980892] initcall dmi_id_init+0x0/0x499 returned 0 after 976 usecs
[    0.987014] calling  dma_bus_init+0x0/0x5b @ 1
[    0.992443] initcall dma_bus_init+0x0/0x5b returned 0 after 0 usecs
[    0.998013] calling  dma_channel_table_init+0x0/0x11a @ 1
[    1.004046] initcall dma_channel_table_init+0x0/0x11a returned 0 after 0 usecs
[    1.011011] calling  pci_arch_init+0x0/0x9d @ 1
[    1.016052] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf0000000-0xf3ffffff] (base 0xf0000000)
[    1.025011] PCI: MMCONFIG at [mem 0xf0000000-0xf3ffffff] reserved in E820
[    1.033900] PCI: Using configuration type 1 for base access
[    1.040026] initcall pci_arch_init+0x0/0x9d returned 0 after 23437 usecs
[    1.046011] calling  topology_init+0x0/0xe4 @ 1
[    1.053162] initcall topology_init+0x0/0xe4 returned 0 after 1953 usecs
[    1.059013] calling  mtrr_init_finialize+0x0/0x70 @ 1
[    1.065011] initcall mtrr_init_finialize+0x0/0x70 returned 0 after 0 usecs
[    1.072022] calling  param_sysfs_init+0x0/0x356 @ 1
[    1.102381] initcall param_sysfs_init+0x0/0x356 returned 0 after 23437 usecs
[    1.109014] calling  pm_sysrq_init+0x0/0x2c @ 1
[    1.114027] initcall pm_sysrq_init+0x0/0x2c returned 0 after 0 usecs
[    1.120010] calling  audit_watch_init+0x0/0x4b @ 1
[    1.125015] initcall audit_watch_init+0x0/0x4b returned 0 after 0 usecs
[    1.132011] calling  init_slow_work+0x0/0x5a @ 1
[    1.136010] initcall init_slow_work+0x0/0x5a returned 0 after 0 usecs
[    1.143009] calling  default_bdi_init+0x0/0x113 @ 1
[    1.149292] initcall default_bdi_init+0x0/0x113 returned 0 after 976 usecs
[    1.156013] calling  init_bio+0x0/0x115 @ 1
[    1.161145] bio: create slab <bio-0> at 0
[    1.165166] initcall init_bio+0x0/0x115 returned 0 after 5859 usecs
[    1.172010] calling  fsnotify_init+0x0/0x20 @ 1
[    1.177028] initcall fsnotify_init+0x0/0x20 returned 0 after 0 usecs
[    1.183012] calling  fsnotify_notification_init+0x0/0x84 @ 1
[    1.189098] initcall fsnotify_notification_init+0x0/0x84 returned 0 after 0 usecs
[    1.196010] calling  cryptomgr_init+0x0/0x20 @ 1
[    1.201011] initcall cryptomgr_init+0x0/0x20 returned 0 after 0 usecs
[    1.208010] calling  blk_settings_init+0x0/0x31 @ 1
[    1.212010] initcall blk_settings_init+0x0/0x31 returned 0 after 0 usecs
[    1.219009] calling  blk_ioc_init+0x0/0x38 @ 1
[    1.224053] initcall blk_ioc_init+0x0/0x38 returned 0 after 0 usecs
[    1.230010] calling  blk_softirq_init+0x0/0x9d @ 1
[    1.235015] initcall blk_softirq_init+0x0/0x9d returned 0 after 0 usecs
[    1.242010] calling  blk_iopoll_setup+0x0/0x9d @ 1
[    1.247026] initcall blk_iopoll_setup+0x0/0x9d returned 0 after 0 usecs
[    1.253010] calling  genhd_device_init+0x0/0x92 @ 1
[    1.259125] initcall genhd_device_init+0x0/0x92 returned 0 after 976 usecs
[    1.266012] calling  blk_dev_integrity_init+0x0/0x38 @ 1
[    1.271086] initcall blk_dev_integrity_init+0x0/0x38 returned 0 after 0 usecs
[    1.278014] calling  gpiolib_debugfs_init+0x0/0x32 @ 1
[    1.284041] initcall gpiolib_debugfs_init+0x0/0x32 returned 0 after 0 usecs
[    1.291012] calling  pci_slot_init+0x0/0x6d @ 1
[    1.295024] initcall pci_slot_init+0x0/0x6d returned 0 after 0 usecs
[    1.302017] calling  fbmem_init+0x0/0xd0 @ 1
[    1.306834] initcall fbmem_init+0x0/0xd0 returned 0 after 0 usecs
[    1.313012] calling  acpi_init+0x0/0x1be @ 1
[    1.326140] ACPI: EC: Look up EC in DSDT
[    1.410529] ACPI: BIOS _OSI(Linux) query ignored
[    1.441200] ACPI: Interpreter enabled
[    1.445013] ACPI: (supports S0 S1 S3 S4 S5)
[    1.449721] ACPI: Using IOAPIC for interrupt routing
[    1.610242] initcall acpi_init+0x0/0x1be returned 0 after 286132 usecs
[    1.617015] calling  dock_init+0x0/0xde @ 1
[    1.628927] ACPI: ACPI Dock Station Driver: 1 docks/bays found
[    1.635011] initcall dock_init+0x0/0xde returned 0 after 13671 usecs
[    1.641010] calling  acpi_pci_root_init+0x0/0x46 @ 1
[    1.653700] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.659469] pci_root PNP0A03:00: ignoring host bridge windows from ACPI; boot with "pci=use_crs" to use them
[    1.683391] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7] (ignored)
[    1.691010] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff] (ignored)
[    1.698009] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff] (ignored)
[    1.706009] pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff] (ignored)
[    1.715011] pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff] (ignored)
[    1.723009] pci_root PNP0A03:00: host bridge window [mem 0x80000000-0xefffffff] (ignored)
[    1.731009] pci_root PNP0A03:00: host bridge window [mem 0xf4000000-0xfebfffff] (ignored)
[    1.740009] pci_root PNP0A03:00: host bridge window [mem 0xffa80800-0xffa80bff] (ignored)
[    1.748259] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    1.754014] pci 0000:00:01.0: PME# disabled
[    1.759119] pci 0000:00:02.0: reg 10: [mem 0xfeb00000-0xfeb7ffff]
[    1.765020] pci 0000:00:02.0: reg 14: [io  0xe898-0xe89f]
[    1.770020] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff pref]
[    1.777020] pci 0000:00:02.0: reg 1c: [mem 0xfeac0000-0xfeafffff]
[    1.783176] pci 0000:00:02.1: reg 10: [mem 0xfeb80000-0xfebfffff]
[    1.790201] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.796014] pci 0000:00:1c.0: PME# disabled
[    1.800291] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.807015] pci 0000:00:1c.1: PME# disabled
[    1.811183] pci 0000:00:1d.0: reg 20: [io  0xff80-0xff9f]
[    1.817168] pci 0000:00:1d.1: reg 20: [io  0xff60-0xff7f]
[    1.822161] pci 0000:00:1d.2: reg 20: [io  0xff40-0xff5f]
[    1.828161] pci 0000:00:1d.3: reg 20: [io  0xff20-0xff3f]
[    1.834164] pci 0000:00:1d.7: reg 10: [mem 0xffa80800-0xffa80bff]
[    1.840139] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    1.846014] pci 0000:00:1d.7: PME# disabled
[    1.850339] pci 0000:00:1e.2: reg 10: [io  0xec00-0xecff]
[    1.856021] pci 0000:00:1e.2: reg 14: [io  0xe8c0-0xe8ff]
[    1.862021] pci 0000:00:1e.2: reg 18: [mem 0xfeabfa00-0xfeabfbff]
[    1.868021] pci 0000:00:1e.2: reg 1c: [mem 0xfeabf900-0xfeabf9ff]
[    1.874085] pci 0000:00:1e.2: PME# supported from D0 D3hot D3cold
[    1.880014] pci 0000:00:1e.2: PME# disabled
[    1.884251] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
[    1.893014] pci 0000:00:1f.0: quirk: [io  0x0880-0x08bf] claimed by ICH6 GPIO
[    1.900014] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0c00 (mask 007f)
[    1.907012] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 00e0 (mask 0007)
[    1.915130] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    1.921022] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    1.926021] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    1.932021] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    1.937021] pci 0000:00:1f.1: reg 20: [io  0xffa0-0xffaf]
[    1.943134] pci 0000:00:1f.2: reg 10: [io  0xfe00-0xfe07]
[    1.948020] pci 0000:00:1f.2: reg 14: [io  0xfe10-0xfe13]
[    1.954021] pci 0000:00:1f.2: reg 18: [io  0xfe20-0xfe27]
[    1.959020] pci 0000:00:1f.2: reg 1c: [io  0xfe30-0xfe33]
[    1.965020] pci 0000:00:1f.2: reg 20: [io  0xfea0-0xfeaf]
[    1.970078] pci 0000:00:1f.2: PME# supported from D3hot
[    1.975014] pci 0000:00:1f.2: PME# disabled
[    1.980135] pci 0000:00:1f.3: reg 20: [io  0xe8a0-0xe8bf]
[    1.985321] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    1.991019] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    1.998158] pci 0000:02:00.0: reg 10: [mem 0xfe8f0000-0xfe8fffff 64bit]
[    2.004203] pci 0000:02:00.0: PME# supported from D3hot D3cold
[    2.011015] pci 0000:02:00.0: PME# disabled
[    2.015045] pci 0000:02:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    2.025228] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.030021] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    2.037261] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.043020] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    2.050199] pci 0000:00:1e.0: PCI bridge to [bus 04-04] (subtractive decode)
[    2.057092] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    2.067894] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4._PRT]
[    2.076779] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI2._PRT]
[    2.084645] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI3._PRT]
[    2.091688] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
[    3.465985] initcall acpi_pci_root_init+0x0/0x46 returned 0 after 1777343 usecs
[    3.473015] calling  acpi_pci_link_init+0x0/0x7c @ 1
[    3.478763] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11 12 15)
[    3.487301] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    3.495681] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 9 10 11 12 15)
[    3.504103] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 11 12 15) *0, disabled.
[    3.513767] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.522174] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 15)
[    3.530605] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 15)
[    3.538841] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 *10 11 12 15)
[    3.546976] initcall acpi_pci_link_init+0x0/0x7c returned 0 after 67382 usecs
[    3.554014] calling  pnp_init+0x0/0x20 @ 1
[    3.558770] initcall pnp_init+0x0/0x20 returned 0 after 0 usecs
[    3.564012] calling  setup_shutdown_event+0x0/0x22 @ 1
[    3.570011] initcall setup_shutdown_event+0x0/0x22 returned 0 after 0 usecs
[    3.577009] calling  balloon_init+0x0/0x2a5 @ 1
[    3.581010] initcall balloon_init+0x0/0x2a5 returned -19 after 0 usecs
[    3.588009] calling  misc_init+0x0/0xf6 @ 1
[    3.592913] initcall misc_init+0x0/0xf6 returned 0 after 976 usecs
[    3.599013] calling  vga_arb_device_init+0x0/0xbf @ 1
[    3.604923] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    3.613110] vgaarb: loaded
[    3.616012] initcall vga_arb_device_init+0x0/0xbf returned 0 after 11718 usecs
[    3.623011] calling  cn_init+0x0/0xd6 @ 1
[    3.627088] initcall cn_init+0x0/0xd6 returned 0 after 0 usecs
[    3.633010] calling  ezx_pcap_init+0x0/0x20 @ 1
[    3.638519] initcall ezx_pcap_init+0x0/0x20 returned 0 after 0 usecs
[    3.645013] calling  phy_init+0x0/0x5a @ 1
[    3.650429] initcall phy_init+0x0/0x5a returned 0 after 976 usecs
[    3.656013] calling  serio_init+0x0/0xda @ 1
[    3.661697] initcall serio_init+0x0/0xda returned 0 after 0 usecs
[    3.667014] calling  input_init+0x0/0x1db @ 1
[    3.672618] initcall input_init+0x0/0x1db returned 0 after 0 usecs
[    3.679015] calling  power_supply_class_init+0x0/0x4b @ 1
[    3.684801] initcall power_supply_class_init+0x0/0x4b returned 0 after 0 usecs
[    3.692013] calling  pci_subsys_init+0x0/0x1da @ 1
[    3.697007] PCI: Using ACPI for IRQ routing
[    3.701009] PCI: pci_cache_line_size set to 64 bytes
[    3.706270] initcall pci_subsys_init+0x0/0x1da returned 0 after 8789 usecs
[    3.713010] calling  proto_init+0x0/0x20 @ 1
[    3.718032] initcall proto_init+0x0/0x20 returned 0 after 0 usecs
[    3.724011] calling  net_dev_init+0x0/0x254 @ 1
[    3.730110] initcall net_dev_init+0x0/0x254 returned 0 after 1953 usecs
[    3.736017] calling  neigh_init+0x0/0x9b @ 1
[    3.741011] initcall neigh_init+0x0/0x9b returned 0 after 0 usecs
[    3.747010] calling  fib_rules_init+0x0/0xfa @ 1
[    3.752018] initcall fib_rules_init+0x0/0xfa returned 0 after 0 usecs
[    3.760010] calling  pktsched_init+0x0/0x11d @ 1
[    3.765044] initcall pktsched_init+0x0/0x11d returned 0 after 0 usecs
[    3.771010] calling  tc_filter_init+0x0/0x68 @ 1
[    3.776010] initcall tc_filter_init+0x0/0x68 returned 0 after 0 usecs
[    3.782010] calling  tc_action_init+0x0/0x68 @ 1
[    3.787011] initcall tc_action_init+0x0/0x68 returned 0 after 0 usecs
[    3.793022] calling  genl_init+0x0/0xeb @ 1
[    3.798120] initcall genl_init+0x0/0xeb returned 0 after 0 usecs
[    3.804010] calling  cipso_v4_init+0x0/0xbe @ 1
[    3.809035] initcall cipso_v4_init+0x0/0xbe returned 0 after 0 usecs
[    3.815010] calling  wireless_nlevent_init+0x0/0x20 @ 1
[    3.820014] initcall wireless_nlevent_init+0x0/0x20 returned 0 after 0 usecs
[    3.827010] calling  netlbl_init+0x0/0xdc @ 1
[    3.832008] NetLabel: Initializing
[    3.835008] NetLabel:  domain hash size = 128
[    3.840007] NetLabel:  protocols = UNLABELED CIPSOv4
[    3.845254] NetLabel:  unlabeled traffic allowed by default
[    3.851011] initcall netlbl_init+0x0/0xdc returned 0 after 18554 usecs
[    3.857010] calling  sysctl_init+0x0/0x72 @ 1
[    3.862016] initcall sysctl_init+0x0/0x72 returned 0 after 0 usecs
[    3.868012] calling  xen_mc_debugfs+0x0/0x166 @ 1
[    3.873256] initcall xen_mc_debugfs+0x0/0x166 returned 0 after 0 usecs
[    3.879010] calling  xen_mmu_debugfs+0x0/0x36e @ 1
[    3.885065] initcall xen_mmu_debugfs+0x0/0x36e returned 0 after 976 usecs
[    3.892010] calling  xen_spinlock_debugfs+0x0/0x2e2 @ 1
[    3.897503] initcall xen_spinlock_debugfs+0x0/0x2e2 returned 0 after 0 usecs
[    3.905030] calling  print_ICs+0x0/0x7a1 @ 1
[    3.909012] initcall print_ICs+0x0/0x7a1 returned 0 after 0 usecs
[    3.915010] calling  hpet_late_init+0x0/0xea @ 1
[    3.920013] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    3.927015] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    3.932286] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    3.941149] initcall hpet_late_init+0x0/0xea returned 0 after 20507 usecs
[    3.948014] calling  clocksource_done_booting+0x0/0x5b @ 1
[    3.954015] Switching to clocksource tsc
[    3.958999] initcall clocksource_done_booting+0x0/0x5b returned 0 after 4287 usecs
[    3.966151] calling  ftrace_init_debugfs+0x0/0x2f1 @ 1
[    3.971782] initcall ftrace_init_debugfs+0x0/0x2f1 returned 0 after 377 usecs
[    3.979043] calling  rb_init_debugfs+0x0/0x44 @ 1
[    3.983880] initcall rb_init_debugfs+0x0/0x44 returned 0 after 22 usecs
[    3.990596] calling  tracer_init_debugfs+0x0/0x445 @ 1
[    3.997460] initcall tracer_init_debugfs+0x0/0x445 returned 0 after 1582 usecs
[    4.004865] calling  init_trace_printk_function_export+0x0/0x4d @ 1
[    4.011263] initcall init_trace_printk_function_export+0x0/0x4d returned 0 after 24 usecs
[    4.019607] calling  stat_workqueue_init+0x0/0x49 @ 1
[    4.024793] initcall stat_workqueue_init+0x0/0x49 returned 0 after 28 usecs
[    4.031856] calling  event_trace_init+0x0/0x2ea @ 1
[    4.163817] initcall event_trace_init+0x0/0x2ea returned 0 after 123992 usecs
[    4.171063] calling  init_kprobe_trace+0x0/0xbc @ 1
[    4.176119] initcall init_kprobe_trace+0x0/0xbc returned 0 after 68 usecs
[    4.183015] calling  init_pipe_fs+0x0/0x76 @ 1
[    4.187708] initcall init_pipe_fs+0x0/0x76 returned 0 after 133 usecs
[    4.194252] calling  eventpoll_init+0x0/0x10d @ 1
[    4.199187] initcall eventpoll_init+0x0/0x10d returned 0 after 123 usecs
[    4.205989] calling  anon_inode_init+0x0/0x180 @ 1
[    4.211058] initcall anon_inode_init+0x0/0x180 returned 0 after 146 usecs
[    4.217951] calling  tomoyo_initerface_init+0x0/0x171 @ 1
[    4.223468] initcall tomoyo_initerface_init+0x0/0x171 returned 0 after 0 usecs
[    4.230859] calling  blk_scsi_ioctl_init+0x0/0x488 @ 1
[    4.236102] initcall blk_scsi_ioctl_init+0x0/0x488 returned 0 after 1 usecs
[    4.243167] calling  acpi_event_init+0x0/0xe1 @ 1
[    4.248126] initcall acpi_event_init+0x0/0xe1 returned 0 after 147 usecs
[    4.254930] calling  pnpacpi_init+0x0/0xd5 @ 1
[    4.259485] pnp: PnP ACPI init
[    4.262717] ACPI: bus type pnp registered
[    4.280341] pnp 00:01: disabling [io  0x0800-0x085f] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    4.290687] pnp 00:01: disabling [io  0x0860-0x08ff] because it overlaps 0000:00:1f.0 BAR 13 [io  0x0800-0x087f]
[    4.361722] pnp: PnP ACPI: found 10 devices
[    4.366078] ACPI: ACPI bus type pnp unregistered
[    4.370804] initcall pnpacpi_init+0x0/0xd5 returned 0 after 108705 usecs
[    4.377605] calling  pnp_system_init+0x0/0x20 @ 1
[    4.382464] system 00:01: [io  0x0c00-0x0c7f] has been reserved
[    4.388552] system 00:08: [mem 0x00000000-0x0009ffff] could not be reserved
[    4.395627] system 00:08: [mem 0x00100000-0x00ffffff] could not be reserved
[    4.402699] system 00:08: [mem 0x01000000-0x7f686bff] could not be reserved
[    4.409773] system 00:08: [mem 0x000f0000-0x000fffff] could not be reserved
[    4.416841] system 00:08: [mem 0x000c0000-0x000cffff] has been reserved
[    4.423569] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    4.430637] system 00:08: [mem 0xfee00000-0xfeefffff] has been reserved
[    4.437359] system 00:08: [mem 0xfed20000-0xfed9ffff] has been reserved
[    4.444081] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
[    4.450803] system 00:08: [mem 0xffc00000-0xffffffff] has been reserved
[    4.457557] system 00:09: [io  0x0100-0x01fe] could not be reserved
[    4.463931] system 00:09: [io  0x0200-0x0277] has been reserved
[    4.469969] system 00:09: [io  0x0280-0x02e7] has been reserved
[    4.476007] system 00:09: [io  0x02f0-0x02f7] has been reserved
[    4.482056] system 00:09: [io  0x0300-0x0377] could not be reserved
[    4.488429] system 00:09: [io  0x0380-0x03bb] has been reserved
[    4.494462] system 00:09: [io  0x03c0-0x03e7] could not be reserved
[    4.500839] system 00:09: [io  0x03f6-0x03f7] could not be reserved
[    4.507215] system 00:09: [io  0x0400-0x04cf] has been reserved
[    4.513242] system 00:09: [io  0x04d2-0x057f] has been reserved
[    4.519266] system 00:09: [io  0x0580-0x0677] has been reserved
[    4.525293] system 00:09: [io  0x0680-0x0777] has been reserved
[    4.531318] system 00:09: [io  0x0780-0x07bb] has been reserved
[    4.537345] system 00:09: [io  0x07c0-0x07ff] has been reserved
[    4.543373] system 00:09: [io  0x08e0-0x08ff] has been reserved
[    4.549399] system 00:09: [io  0x0900-0x09fe] has been reserved
[    4.555427] system 00:09: [io  0x0a00-0x0afe] has been reserved
[    4.561466] system 00:09: [io  0x0b00-0x0bfe] has been reserved
[    4.567493] system 00:09: [io  0x0c80-0x0caf] has been reserved
[    4.573520] system 00:09: [io  0x0cb0-0x0cbf] has been reserved
[    4.579548] system 00:09: [io  0x0cc0-0x0cf7] has been reserved
[    4.585576] system 00:09: [io  0x0d00-0x0dfe] has been reserved
[    4.591605] system 00:09: [io  0x0e00-0x0efe] has been reserved
[    4.597633] system 00:09: [io  0x0f00-0x0ffe] has been reserved
[    4.603660] system 00:09: [io  0x2000-0x20fe] has been reserved
[    4.609688] system 00:09: [io  0x2100-0x21fe] has been reserved
[    4.615718] system 00:09: [io  0x2200-0x22fe] has been reserved
[    4.621746] system 00:09: [io  0x2300-0x23fe] has been reserved
[    4.627773] system 00:09: [io  0x2400-0x24fe] has been reserved
[    4.633800] system 00:09: [io  0x2500-0x25fe] has been reserved
[    4.639830] system 00:09: [io  0x2600-0x26fe] has been reserved
[    4.645862] system 00:09: [io  0x2700-0x27fe] has been reserved
[    4.651889] system 00:09: [io  0x2800-0x28fe] has been reserved
[    4.657918] system 00:09: [io  0x2900-0x29fe] has been reserved
[    4.663960] system 00:09: [io  0x2a00-0x2afe] has been reserved
[    4.670001] system 00:09: [io  0x2b00-0x2bfe] has been reserved
[    4.676053] system 00:09: [io  0x2c00-0x2cfe] has been reserved
[    4.682081] system 00:09: [io  0x2d00-0x2dfe] has been reserved
[    4.688137] system 00:09: [io  0x2e00-0x2efe] has been reserved
[    4.694165] system 00:09: [io  0x2f00-0x2ffe] has been reserved
[    4.700192] system 00:09: [io  0x5000-0x50fe] has been reserved
[    4.706221] system 00:09: [io  0x5100-0x51fe] has been reserved
[    4.712249] system 00:09: [io  0x5200-0x52fe] has been reserved
[    4.718276] system 00:09: [io  0x5300-0x53fe] has been reserved
[    4.724305] system 00:09: [io  0x5400-0x54fe] has been reserved
[    4.730335] system 00:09: [io  0x5500-0x55fe] has been reserved
[    4.736364] system 00:09: [io  0x5600-0x56fe] has been reserved
[    4.742406] system 00:09: [io  0x5700-0x57fe] has been reserved
[    4.748434] system 00:09: [io  0x5800-0x58fe] has been reserved
[    4.754464] system 00:09: [io  0x5900-0x59fe] has been reserved
[    4.760491] system 00:09: [io  0x5a00-0x5afe] has been reserved
[    4.766521] system 00:09: [io  0x5b00-0x5bfe] has been reserved
[    4.772549] system 00:09: [io  0x5c00-0x5cfe] has been reserved
[    4.778579] system 00:09: [io  0x5d00-0x5dfe] has been reserved
[    4.784608] system 00:09: [io  0x5e00-0x5efe] has been reserved
[    4.790636] system 00:09: [io  0x5f00-0x5ffe] has been reserved
[    4.796666] system 00:09: [io  0x6000-0x60fe] has been reserved
[    4.802693] system 00:09: [io  0x6100-0x61fe] has been reserved
[    4.808722] system 00:09: [io  0x6200-0x62fe] has been reserved
[    4.814751] system 00:09: [io  0x6300-0x63fe] has been reserved
[    4.820779] system 00:09: [io  0x6400-0x64fe] has been reserved
[    4.826808] system 00:09: [io  0x6500-0x65fe] has been reserved
[    4.832835] system 00:09: [io  0x6600-0x66fe] has been reserved
[    4.838865] system 00:09: [io  0x6700-0x67fe] has been reserved
[    4.844894] system 00:09: [io  0x6800-0x68fe] has been reserved
[    4.850928] system 00:09: [io  0x6900-0x69fe] has been reserved
[    4.856969] system 00:09: [io  0x6a00-0x6afe] has been reserved
[    4.863018] system 00:09: [io  0x6b00-0x6bfe] has been reserved
[    4.869060] system 00:09: [io  0x6c00-0x6cfe] has been reserved
[    4.875087] system 00:09: [io  0x6d00-0x6dfe] has been reserved
[    4.881117] system 00:09: [io  0x6e00-0x6efe] has been reserved
[    4.887147] system 00:09: [io  0x6f00-0x6ffe] has been reserved
[    4.893176] system 00:09: [io  0xa000-0xa0fe] has been reserved
[    4.899204] system 00:09: [io  0xa100-0xa1fe] has been reserved
[    4.905240] system 00:09: [io  0xa200-0xa2fe] has been reserved
[    4.911271] system 00:09: [io  0xa300-0xa3fe] has been reserved
[    4.917300] system 00:09: [io  0xa400-0xa4fe] has been reserved
[    4.923340] system 00:09: [io  0xa500-0xa5fe] has been reserved
[    4.929368] system 00:09: [io  0xa600-0xa6fe] has been reserved
[    4.935398] system 00:09: [io  0xa700-0xa7fe] has been reserved
[    4.941428] system 00:09: [io  0xa800-0xa8fe] has been reserved
[    4.947458] system 00:09: [io  0xa900-0xa9fe] has been reserved
[    4.953488] system 00:09: [io  0xaa00-0xaafe] has been reserved
[    4.959520] system 00:09: [io  0xab00-0xabfe] has been reserved
[    4.965565] system 00:09: [io  0xac00-0xacfe] has been reserved
[    4.971595] system 00:09: [io  0xad00-0xadfe] has been reserved
[    4.977627] system 00:09: [io  0xae00-0xaefe] has been reserved
[    4.983656] system 00:09: [io  0xaf00-0xaffe] has been reserved
[    4.989684] system 00:09: [mem 0xf0000000-0xf3ffffff] has been reserved
[    4.996405] system 00:09: [mem 0xfeda0000-0xfedacfff] has been reserved
[    5.003574] initcall pnp_system_init+0x0/0x20 returned 0 after 606594 usecs
[    5.010653] calling  chr_dev_init+0x0/0x10c @ 1
[    5.023071] initcall chr_dev_init+0x0/0x10c returned 0 after 5850 usecs
[    5.029821] calling  firmware_class_init+0x0/0xb1 @ 1
[    5.035444] initcall firmware_class_init+0x0/0xb1 returned 0 after 455 usecs
[    5.042609] calling  cpufreq_gov_performance_init+0x0/0x20 @ 1
[    5.048567] initcall cpufreq_gov_performance_init+0x0/0x20 returned 0 after 21 usecs
[    5.056481] calling  init_acpi_pm_clocksource+0x0/0x160 @ 1
[    5.066686] initcall init_acpi_pm_clocksource+0x0/0x160 returned 0 after 4422 usecs
[    5.074510] calling  pcibios_assign_resources+0x0/0xb5 @ 1
[    5.080339] pci 0000:00:1c.0: BAR 15: assigned [mem 0x80000000-0x801fffff 64bit pref]
[    5.088341] pci 0000:00:1c.1: BAR 15: assigned [mem 0x80200000-0x803fffff 64bit pref]
[    5.096343] pci 0000:00:1c.0: BAR 13: assigned [io  0x1000-0x1fff]
[    5.102631] pci 0000:00:1c.1: BAR 13: assigned [io  0x3000-0x3fff]
[    5.108913] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    5.114252] pci 0000:00:01.0:   bridge window [io  disabled]
[    5.120050] pci 0000:00:01.0:   bridge window [mem 0xfe900000-0xfe9fffff]
[    5.126946] pci 0000:00:01.0:   bridge window [mem pref disabled]
[    5.133161] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    5.138491] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
[    5.144693] pci 0000:00:1c.0:   bridge window [mem 0xfe800000-0xfe8fffff]
[    5.151587] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x801fffff 64bit pref]
[    5.159510] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    5.164846] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    5.171055] pci 0000:00:1c.1:   bridge window [mem 0xfe700000-0xfe7fffff]
[    5.177949] pci 0000:00:1c.1:   bridge window [mem 0x80200000-0x803fffff 64bit pref]
[    5.185881] pci 0000:00:1e.0: PCI bridge to [bus 04-04]
[    5.191207] pci 0000:00:1e.0:   bridge window [io  disabled]
[    5.196975] pci 0000:00:1e.0:   bridge window [mem disabled]
[    5.202752] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    5.209002]   alloc irq_desc for 16 on node -1
[    5.209935]   alloc kstat_irqs on node -1
[    5.217685] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.224495] pci 0000:00:01.0: setting latency timer to 64
[    5.230041] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.236853] pci 0000:00:1c.0: setting latency timer to 64
[    5.242375]   alloc irq_desc for 17 on node -1
[    5.243342]   alloc kstat_irqs on node -1
[    5.251069] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.257877] pci 0000:00:1c.1: setting latency timer to 64
[    5.263392] pci 0000:00:1e.0: setting latency timer to 64
[    5.268896] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    5.274569] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffffffffff]
[    5.281632] pci_bus 0000:01: resource 1 [mem 0xfe900000-0xfe9fffff]
[    5.288001] pci_bus 0000:02: resource 0 [io  0x1000-0x1fff]
[    5.293692] pci_bus 0000:02: resource 1 [mem 0xfe800000-0xfe8fffff]
[    5.300060] pci_bus 0000:02: resource 2 [mem 0x80000000-0x801fffff 64bit pref]
[    5.307450] pci_bus 0000:03: resource 0 [io  0x3000-0x3fff]
[    5.313126] pci_bus 0000:03: resource 1 [mem 0xfe700000-0xfe7fffff]
[    5.319495] pci_bus 0000:03: resource 2 [mem 0x80200000-0x803fffff 64bit pref]
[    5.326887] pci_bus 0000:04: resource 3 [io  0x0000-0xffff]
[    5.332559] pci_bus 0000:04: resource 4 [mem 0x00000000-0xffffffffffffffff]
[    5.339624] initcall pcibios_assign_resources+0x0/0xb5 returned 0 after 253443 usecs
[    5.347536] calling  sysctl_core_init+0x0/0x54 @ 1
[    5.352520] initcall sysctl_core_init+0x0/0x54 returned 0 after 87 usecs
[    5.359324] calling  inet_init+0x0/0x387 @ 1
[    5.363989] NET: Registered protocol family 2
[    5.369190] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[    5.379633] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    5.390500] TCP bind hash table entries: 65536 (order: 10, 4718592 bytes)
[    5.405778] TCP: Hash tables configured (established 262144 bind 65536)
[    5.412575] TCP reno registered
[    5.415893] UDP hash table entries: 1024 (order: 5, 163840 bytes)
[    5.422411] UDP-Lite hash table entries: 1024 (order: 5, 163840 bytes)
[    5.429966] initcall inet_init+0x0/0x387 returned 0 after 64706 usecs
[    5.436524] calling  af_unix_init+0x0/0x7f @ 1
[    5.441149] NET: Registered protocol family 1
[    5.445656] initcall af_unix_init+0x0/0x7f returned 0 after 4477 usecs
[    5.452285] calling  pci_apply_final_quirks+0x0/0x16c @ 1
[    5.457832] pci 0000:00:02.0: Boot video device
[    5.462773] PCI: CLS 64 bytes, default 64
[    5.466887] initcall pci_apply_final_quirks+0x0/0x16c returned 0 after 8886 usecs
[    5.474552] calling  populate_rootfs+0x0/0x18b @ 1
[    5.480233] Unpacking initramfs...
[    5.674154] Freeing initrd memory: 4373k freed
[    5.681323] initcall populate_rootfs+0x0/0x18b returned 0 after 197133 usecs
[    5.688479] calling  pci_iommu_init+0x0/0x5b @ 1
[    5.693204] initcall pci_iommu_init+0x0/0x5b returned 0 after 1 usecs
[    5.699746] calling  calgary_fixup_tce_spaces+0x0/0x169 @ 1
[    5.705421] initcall calgary_fixup_tce_spaces+0x0/0x169 returned -19 after 0 usecs
[    5.713161] calling  i8259A_init_sysfs+0x0/0x3e @ 1
[    5.719130] initcall i8259A_init_sysfs+0x0/0x3e returned 0 after 961 usecs
[    5.726405] calling  vsyscall_init+0x0/0x6c @ 1
[    5.731865] initcall vsyscall_init+0x0/0x6c returned 0 after 559 usecs
[    5.738499] calling  sbf_init+0x0/0x18b @ 1
[    5.742789] Simple Boot Flag at 0x7a set to 0x1
[    5.747427] initcall sbf_init+0x0/0x18b returned 0 after 4530 usecs
[    5.753795] calling  i8237A_init_sysfs+0x0/0x3e @ 1
[    5.759670] initcall i8237A_init_sysfs+0x0/0x3e returned 0 after 868 usecs
[    5.766662] calling  add_rtc_cmos+0x0/0xea @ 1
[    5.771215] initcall add_rtc_cmos+0x0/0xea returned 0 after 6 usecs
[    5.777585] calling  cache_sysfs_init+0x0/0x98 @ 1
[    5.785439] initcall cache_sysfs_init+0x0/0x98 returned 0 after 2887 usecs
[    5.792430] calling  mcheck_init_device+0x0/0x132 @ 1
[    5.799760] initcall mcheck_init_device+0x0/0x132 returned 0 after 2121 usecs
[    5.807028] calling  threshold_init_device+0x0/0xc0 @ 1
[    5.812371] initcall threshold_init_device+0x0/0xc0 returned 0 after 1 usecs
[    5.819518] calling  thermal_throttle_init_device+0x0/0xf4 @ 1
[    5.825551] initcall thermal_throttle_init_device+0x0/0xf4 returned 0 after 92 usecs
[    5.833458] calling  ioapic_init_sysfs+0x0/0x10f @ 1
[    5.839454] initcall ioapic_init_sysfs+0x0/0x10f returned 0 after 898 usecs
[    5.846528] calling  add_pcspkr+0x0/0x3a @ 1
[    5.851450] initcall add_pcspkr+0x0/0x3a returned 0 after 531 usecs
[    5.857838] calling  start_periodic_check_for_corruption+0x0/0x61 @ 1
[    5.864378] Scanning for low memory corruption every 60 seconds
[    5.870417] initcall start_periodic_check_for_corruption+0x0/0x61 returned 0 after 5893 usecs
[    5.879109] calling  audit_classes_init+0x0/0xfc @ 1
[    5.884273] initcall audit_classes_init+0x0/0xfc returned 0 after 92 usecs
[    5.891253] calling  pt_dump_init+0x0/0x4a @ 1
[    5.895839] initcall pt_dump_init+0x0/0x4a returned 0 after 35 usecs
[    5.902295] calling  init_vdso_vars+0x0/0x207 @ 1
[    5.907123] initcall init_vdso_vars+0x0/0x207 returned 0 after 20 usecs
[    5.913839] calling  ia32_binfmt_init+0x0/0x14 @ 1
[    5.918762] initcall ia32_binfmt_init+0x0/0x14 returned 0 after 28 usecs
[    5.925564] calling  sysenter_setup+0x0/0x2d0 @ 1
[    5.930374] initcall sysenter_setup+0x0/0x2d0 returned 0 after 5 usecs
[    5.937007] calling  init_aout_binfmt+0x0/0x22 @ 1
[    5.941917] initcall init_aout_binfmt+0x0/0x22 returned 0 after 1 usecs
[    5.948643] calling  init_sched_debug_procfs+0x0/0x46 @ 1
[    5.954170] initcall init_sched_debug_procfs+0x0/0x46 returned 0 after 24 usecs
[    5.961642] calling  proc_schedstat_init+0x0/0x30 @ 1
[    5.966813] initcall proc_schedstat_init+0x0/0x30 returned 0 after 15 usecs
[    5.973876] calling  proc_execdomains_init+0x0/0x30 @ 1
[    5.979220] initcall proc_execdomains_init+0x0/0x30 returned 0 after 15 usecs
[    5.986455] calling  ioresources_init+0x0/0x51 @ 1
[    5.991379] initcall ioresources_init+0x0/0x51 returned 0 after 29 usecs
[    5.998181] calling  uid_cache_init+0x0/0xc4 @ 1
[    6.002977] initcall uid_cache_init+0x0/0xc4 returned 0 after 72 usecs
[    6.009627] calling  init_posix_timers+0x0/0x1b2 @ 1
[    6.014741] initcall init_posix_timers+0x0/0x1b2 returned 0 after 44 usecs
[    6.021719] calling  init_posix_cpu_timers+0x0/0x10f @ 1
[    6.027140] initcall init_posix_cpu_timers+0x0/0x10f returned 0 after 0 usecs
[    6.034376] calling  nsproxy_cache_init+0x0/0x3b @ 1
[    6.039512] initcall nsproxy_cache_init+0x0/0x3b returned 0 after 66 usecs
[    6.046486] calling  create_proc_profile+0x0/0x301 @ 1
[    6.051729] initcall create_proc_profile+0x0/0x301 returned 0 after 0 usecs
[    6.058792] calling  timekeeping_init_device+0x0/0x3e @ 1
[    6.065212] initcall timekeeping_init_device+0x0/0x3e returned 0 after 895 usecs
[    6.072783] calling  init_clocksource_sysfs+0x0/0x88 @ 1
[    6.079073] initcall init_clocksource_sysfs+0x0/0x88 returned 0 after 845 usecs
[    6.086564] calling  init_timer_list_procfs+0x0/0x46 @ 1
[    6.092030] initcall init_timer_list_procfs+0x0/0x46 returned 0 after 46 usecs
[    6.099428] calling  init_tstats_procfs+0x0/0x46 @ 1
[    6.104512] initcall init_tstats_procfs+0x0/0x46 returned 0 after 16 usecs
[    6.111487] calling  lockdep_proc_init+0x0/0x7b @ 1
[    6.116511] initcall lockdep_proc_init+0x0/0x7b returned 0 after 44 usecs
[    6.123399] calling  futex_init+0x0/0xa3 @ 1
[    6.127812] initcall futex_init+0x0/0xa3 returned 0 after 38 usecs
[    6.134093] calling  proc_dma_init+0x0/0x30 @ 1
[    6.138744] initcall proc_dma_init+0x0/0x30 returned 0 after 15 usecs
[    6.145287] calling  proc_modules_init+0x0/0x30 @ 1
[    6.150286] initcall proc_modules_init+0x0/0x30 returned 0 after 15 usecs
[    6.157176] calling  kallsyms_init+0x0/0x33 @ 1
[    6.161879] initcall kallsyms_init+0x0/0x33 returned 0 after 32 usecs
[    6.168424] calling  snapshot_device_init+0x0/0x20 @ 1
[    6.174265] initcall snapshot_device_init+0x0/0x20 returned 0 after 584 usecs
[    6.181507] calling  crash_save_vmcoreinfo_init+0x0/0x593 @ 1
[    6.187393] initcall crash_save_vmcoreinfo_init+0x0/0x593 returned 0 after 36 usecs
[    6.195223] calling  crash_notes_memory_init+0x0/0x52 @ 1
[    6.200737] initcall crash_notes_memory_init+0x0/0x52 returned 0 after 11 usecs
[    6.208213] calling  pid_namespaces_init+0x0/0x3b @ 1
[    6.213417] initcall pid_namespaces_init+0x0/0x3b returned 0 after 48 usecs
[    6.222296] calling  ikconfig_init+0x0/0x4e @ 1
[    6.226946] initcall ikconfig_init+0x0/0x4e returned 0 after 16 usecs
[    6.233503] calling  audit_init+0x0/0x1ac @ 1
[    6.237961] audit: initializing netlink socket (disabled)
[    6.243606] type=2000 audit(1268915081.243:1): initialized
[    6.249205] initcall audit_init+0x0/0x1ac returned 0 after 10977 usecs
[    6.255834] calling  gcov_init+0x0/0x20 @ 1
[    6.260121] initcall gcov_init+0x0/0x20 returned 0 after 1 usecs
[    6.266227] calling  gcov_fs_init+0x0/0x10d @ 1
[    6.438560] initcall gcov_fs_init+0x0/0x10d returned 0 after 163763 usecs
[    6.445460] calling  audit_tree_init+0x0/0x7a @ 1
[    6.450277] initcall audit_tree_init+0x0/0x7a returned 0 after 7 usecs
[    6.456915] calling  init_kprobes+0x0/0x220 @ 1
[    6.475340] initcall init_kprobes+0x0/0x220 returned 0 after 13452 usecs
[    6.482144] calling  hung_task_init+0x0/0x76 @ 1
[    6.487128] initcall hung_task_init+0x0/0x76 returned 0 after 257 usecs
[    6.493867] calling  rcuclassic_trace_init+0x0/0x15d @ 1
[    6.499425] initcall rcuclassic_trace_init+0x0/0x15d returned 0 after 136 usecs
[    6.506904] calling  utsname_sysctl_init+0x0/0x22 @ 1
[    6.512207] initcall utsname_sysctl_init+0x0/0x22 returned 0 after 137 usecs
[    6.519357] calling  init_tracepoints+0x0/0x25 @ 1
[    6.524253] initcall init_tracepoints+0x0/0x25 returned 0 after 0 usecs
[    6.530968] calling  init_lstats_procfs+0x0/0x33 @ 1
[    6.536082] initcall init_lstats_procfs+0x0/0x33 returned 0 after 30 usecs
[    6.543060] calling  ftrace_mod_cmd_init+0x0/0x20 @ 1
[    6.548269] initcall ftrace_mod_cmd_init+0x0/0x20 returned 0 after 51 usecs
[    6.555331] calling  init_events+0x0/0xa4 @ 1
[    6.559821] initcall init_events+0x0/0xa4 returned 0 after 27 usecs
[    6.566192] calling  init_sched_switch_trace+0x0/0x20 @ 1
[    6.571699] initcall init_sched_switch_trace+0x0/0x20 returned 0 after 4 usecs
[    6.579092] calling  init_stack_trace+0x0/0x20 @ 1
[    6.583990] initcall init_stack_trace+0x0/0x20 returned 0 after 3 usecs
[    6.590733] calling  init_function_trace+0x0/0x71 @ 1
[    6.595894] initcall init_function_trace+0x0/0x71 returned 0 after 5 usecs
[    6.602872] calling  init_wakeup_tracer+0x0/0x4d @ 1
[    6.607946] initcall init_wakeup_tracer+0x0/0x4d returned 0 after 4 usecs
[    6.614847] calling  stack_trace_init+0x0/0x95 @ 1
[    6.619821] initcall stack_trace_init+0x0/0x95 returned 0 after 76 usecs
[    6.626627] calling  init_graph_trace+0x0/0x40 @ 1
[    6.631528] initcall init_graph_trace+0x0/0x40 returned 0 after 3 usecs
[    6.638245] calling  init_kmem_tracer+0x0/0xaf @ 1
[    6.643151] initcall init_kmem_tracer+0x0/0xaf returned 0 after 10 usecs
[    6.649955] calling  init_blk_tracer+0x0/0x8f @ 1
[    6.654784] initcall init_blk_tracer+0x0/0x8f returned 0 after 6 usecs
[    6.661413] calling  perf_event_sysfs_init+0x0/0x27 @ 1
[    6.666765] initcall perf_event_sysfs_init+0x0/0x27 returned 0 after 22 usecs
[    6.674002] calling  init_per_zone_wmark_min+0x0/0xc0 @ 1
[    6.679714] initcall init_per_zone_wmark_min+0x0/0xc0 returned 0 after 181 usecs
[    6.687282] calling  kswapd_init+0x0/0xad @ 1
[    6.691982] initcall kswapd_init+0x0/0xad returned 0 after 231 usecs
[    6.698466] calling  setup_vmstat+0x0/0x104 @ 1
[    6.703240] initcall setup_vmstat+0x0/0x104 returned 0 after 85 usecs
[    6.709784] calling  mm_sysfs_init+0x0/0x43 @ 1
[    6.714459] initcall mm_sysfs_init+0x0/0x43 returned 0 after 33 usecs
[    6.721000] calling  proc_vmalloc_init+0x0/0x33 @ 1
[    6.726033] initcall proc_vmalloc_init+0x0/0x33 returned 0 after 30 usecs
[    6.732936] calling  procswaps_init+0x0/0x30 @ 1
[    6.737688] initcall procswaps_init+0x0/0x30 returned 0 after 16 usecs
[    6.744318] calling  hugetlb_init+0x0/0x560 @ 1
[    6.748956] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    6.755525] initcall hugetlb_init+0x0/0x560 returned 0 after 6418 usecs
[    6.762243] calling  ksm_init+0x0/0x314 @ 1
[    6.767056] initcall ksm_init+0x0/0x314 returned 0 after 510 usecs
[    6.773354] calling  slab_proc_init+0x0/0x33 @ 1
[    6.778095] initcall slab_proc_init+0x0/0x33 returned 0 after 18 usecs
[    6.784723] calling  slab_sysfs_init+0x0/0x157 @ 1
[    6.862748] initcall slab_sysfs_init+0x0/0x157 returned 0 after 71409 usecs
[    6.869833] calling  fasync_init+0x0/0x38 @ 1
[    6.875044] initcall fasync_init+0x0/0x38 returned 0 after 727 usecs
[    6.881523] calling  proc_filesystems_init+0x0/0x30 @ 1
[    6.886872] initcall proc_filesystems_init+0x0/0x30 returned 0 after 19 usecs
[    6.894107] calling  dnotify_init+0x0/0xa3 @ 1
[    6.900297] initcall dnotify_init+0x0/0xa3 returned 0 after 1602 usecs
[    6.906929] calling  inotify_setup+0x0/0x19 @ 1
[    6.911578] initcall inotify_setup+0x0/0x19 returned 0 after 0 usecs
[    6.918049] calling  inotify_user_setup+0x0/0xef @ 1
[    6.924780] initcall inotify_user_setup+0x0/0xef returned 0 after 1617 usecs
[    6.931941] calling  aio_setup+0x0/0x11d @ 1
[    6.938510] initcall aio_setup+0x0/0x11d returned 0 after 2128 usecs
[    6.944976] calling  proc_locks_init+0x0/0x30 @ 1
[    6.949831] initcall proc_locks_init+0x0/0x30 returned 0 after 30 usecs
[    6.956551] calling  init_sys32_ioctl+0x0/0x36 @ 1
[    6.961608] initcall init_sys32_ioctl+0x0/0x36 returned 0 after 156 usecs
[    6.968498] calling  dquot_init+0x0/0x121 @ 1
[    6.972961] VFS: Disk quotas dquot_6.5.2
[    6.978019] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    6.984592] initcall dquot_init+0x0/0x121 returned 0 after 11355 usecs
[    6.991223] calling  quota_init+0x0/0x42 @ 1
[    6.995663] initcall quota_init+0x0/0x42 returned 0 after 65 usecs
[    7.001942] calling  proc_cmdline_init+0x0/0x30 @ 1
[    7.006957] initcall proc_cmdline_init+0x0/0x30 returned 0 after 16 usecs
[    7.013858] calling  proc_cpuinfo_init+0x0/0x30 @ 1
[    7.018856] initcall proc_cpuinfo_init+0x0/0x30 returned 0 after 15 usecs
[    7.025747] calling  proc_devices_init+0x0/0x30 @ 1
[    7.030746] initcall proc_devices_init+0x0/0x30 returned 0 after 16 usecs
[    7.037637] calling  proc_interrupts_init+0x0/0x30 @ 1
[    7.042896] initcall proc_interrupts_init+0x0/0x30 returned 0 after 16 usecs
[    7.050052] calling  proc_loadavg_init+0x0/0x30 @ 1
[    7.055090] initcall proc_loadavg_init+0x0/0x30 returned 0 after 34 usecs
[    7.061981] calling  proc_meminfo_init+0x0/0x30 @ 1
[    7.066992] initcall proc_meminfo_init+0x0/0x30 returned 0 after 16 usecs
[    7.073903] calling  proc_stat_init+0x0/0x30 @ 1
[    7.078644] initcall proc_stat_init+0x0/0x30 returned 0 after 15 usecs
[    7.085274] calling  proc_uptime_init+0x0/0x30 @ 1
[    7.090186] initcall proc_uptime_init+0x0/0x30 returned 0 after 15 usecs
[    7.096988] calling  proc_version_init+0x0/0x30 @ 1
[    7.102006] initcall proc_version_init+0x0/0x30 returned 0 after 16 usecs
[    7.108910] calling  proc_softirqs_init+0x0/0x30 @ 1
[    7.114003] initcall proc_softirqs_init+0x0/0x30 returned 0 after 16 usecs
[    7.120995] calling  proc_kcore_init+0x0/0xf7 @ 1
[    7.125857] initcall proc_kcore_init+0x0/0xf7 returned 0 after 34 usecs
[    7.132572] calling  vmcore_init+0x0/0x4e1 @ 1
[    7.137121] initcall vmcore_init+0x0/0x4e1 returned 0 after 0 usecs
[    7.143492] calling  proc_kmsg_init+0x0/0x33 @ 1
[    7.148231] initcall proc_kmsg_init+0x0/0x33 returned 0 after 17 usecs
[    7.154860] calling  proc_page_init+0x0/0x57 @ 1
[    7.159614] initcall proc_page_init+0x0/0x57 returned 0 after 32 usecs
[    7.166242] calling  init_devpts_fs+0x0/0x76 @ 1
[    7.171118] initcall init_devpts_fs+0x0/0x76 returned 0 after 150 usecs
[    7.177836] calling  init_ramfs_fs+0x0/0x20 @ 1
[    7.182474] initcall init_ramfs_fs+0x0/0x20 returned 0 after 3 usecs
[    7.188932] calling  init_hugetlbfs_fs+0x0/0xf1 @ 1
[    7.194895] initcall init_hugetlbfs_fs+0x0/0xf1 returned 0 after 946 usecs
[    7.201876] calling  ipc_init+0x0/0x59 @ 1
[    7.206101] msgmni has been set to 3952
[    7.210085] initcall ipc_init+0x0/0x59 returned 0 after 3912 usecs
[    7.216365] calling  ipc_sysctl_init+0x0/0x22 @ 1
[    7.221387] initcall ipc_sysctl_init+0x0/0x22 returned 0 after 208 usecs
[    7.228196] calling  init_mqueue_fs+0x0/0x128 @ 1
[    7.234043] initcall init_mqueue_fs+0x0/0x128 returned 0 after 1012 usecs
[    7.240945] calling  key_proc_init+0x0/0x7e @ 1
[    7.245629] initcall key_proc_init+0x0/0x7e returned 0 after 33 usecs
[    7.252172] calling  selinux_nf_ip_init+0x0/0x95 @ 1
[    7.257239] initcall selinux_nf_ip_init+0x0/0x95 returned 0 after 0 usecs
[    7.264139] calling  init_sel_fs+0x0/0x9b @ 1
[    7.268601] initcall init_sel_fs+0x0/0x9b returned 0 after 0 usecs
[    7.274883] calling  selnl_init+0x0/0x69 @ 1
[    7.279294] initcall selnl_init+0x0/0x69 returned 0 after 36 usecs
[    7.285577] calling  sel_netif_init+0x0/0xa0 @ 1
[    7.290297] initcall sel_netif_init+0x0/0xa0 returned 0 after 0 usecs
[    7.296839] calling  sel_netnode_init+0x0/0xaa @ 1
[    7.301734] initcall sel_netnode_init+0x0/0xaa returned 0 after 0 usecs
[    7.308450] calling  sel_netport_init+0x0/0xaa @ 1
[    7.313345] initcall sel_netport_init+0x0/0xaa returned 0 after 0 usecs
[    7.320061] calling  aurule_init+0x0/0x4c @ 1
[    7.324526] initcall aurule_init+0x0/0x4c returned 0 after 2 usecs
[    7.330807] calling  init_smk_fs+0x0/0xc6 @ 1
[    7.335268] initcall init_smk_fs+0x0/0xc6 returned 0 after 0 usecs
[    7.341551] calling  crypto_wq_init+0x0/0x4c @ 1
[    7.346722] initcall crypto_wq_init+0x0/0x4c returned 0 after 439 usecs
[    7.353451] calling  crypto_algapi_init+0x0/0x1b @ 1
[    7.358662] initcall crypto_algapi_init+0x0/0x1b returned 0 after 129 usecs
[    7.365748] calling  skcipher_module_init+0x0/0x4e @ 1
[    7.370998] initcall skcipher_module_init+0x0/0x4e returned 0 after 1 usecs
[    7.378066] calling  chainiv_module_init+0x0/0x20 @ 1
[    7.383309] initcall chainiv_module_init+0x0/0x20 returned 0 after 77 usecs
[    7.390387] calling  eseqiv_module_init+0x0/0x20 @ 1
[    7.395471] initcall eseqiv_module_init+0x0/0x20 returned 0 after 9 usecs
[    7.402368] calling  hmac_module_init+0x0/0x20 @ 1
[    7.407276] initcall hmac_module_init+0x0/0x20 returned 0 after 9 usecs
[    7.414000] calling  md5_mod_init+0x0/0x20 @ 1
[    7.418958] initcall md5_mod_init+0x0/0x20 returned 0 after 393 usecs
[    7.425516] calling  sha1_generic_mod_init+0x0/0x20 @ 1
[    7.431262] initcall sha1_generic_mod_init+0x0/0x20 returned 0 after 405 usecs
[    7.438661] calling  krng_mod_init+0x0/0x20 @ 1
[    7.443557] alg: No test for stdrng (krng)
[    7.447840] initcall krng_mod_init+0x0/0x20 returned 0 after 4434 usecs
[    7.454590] calling  proc_genhd_init+0x0/0x51 @ 1
[    7.459487] initcall proc_genhd_init+0x0/0x51 returned 0 after 80 usecs
[    7.466213] calling  bsg_init+0x0/0x1ae @ 1
[    7.471856] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    7.479455] initcall bsg_init+0x0/0x1ae returned 0 after 8738 usecs
[    7.485831] calling  noop_init+0x0/0x22 @ 1
[    7.490149] io scheduler noop registered
[    7.494175] initcall noop_init+0x0/0x22 returned 0 after 3958 usecs
[    7.502307] calling  deadline_init+0x0/0x22 @ 1
[    7.506941] io scheduler deadline registered
[    7.511330] initcall deadline_init+0x0/0x22 returned 0 after 4284 usecs
[    7.518052] calling  cfq_init+0x0/0xed @ 1
[    7.523759] io scheduler cfq registered (default)
[    7.528601] initcall cfq_init+0x0/0xed returned 0 after 6197 usecs
[    7.534883] calling  percpu_counter_startup+0x0/0x2e @ 1
[    7.540304] initcall percpu_counter_startup+0x0/0x2e returned 0 after 4 usecs
[    7.547542] calling  dynamic_debug_init+0x0/0x1aa @ 1
[    7.553107] initcall dynamic_debug_init+0x0/0x1aa returned 0 after 399 usecs
[    7.560257] calling  lnw_gpio_init+0x0/0x29 @ 1
[    7.565462] initcall lnw_gpio_init+0x0/0x29 returned 0 after 557 usecs
[    7.572104] calling  ucb1400_gpio_init+0x0/0x20 @ 1
[    7.577563] initcall ucb1400_gpio_init+0x0/0x20 returned 0 after 458 usecs
[    7.584554] calling  pci_proc_init+0x0/0x94 @ 1
[    7.589687] initcall pci_proc_init+0x0/0x94 returned 0 after 485 usecs
[    7.596318] calling  pcie_portdrv_init+0x0/0x7d @ 1
[    7.601847] pcieport 0000:00:01.0: setting latency timer to 64
[    7.607883]   alloc irq_desc for 24 on node -1
[    7.608771]   alloc kstat_irqs on node -1
[    7.616559] pcieport 0000:00:01.0: irq 24 for MSI/MSI-X
[    7.623189] pcieport 0000:00:1c.0: setting latency timer to 64
[    7.629224]   alloc irq_desc for 25 on node -1
[    7.630129]   alloc kstat_irqs on node -1
[    7.637892] pcieport 0000:00:1c.0: irq 25 for MSI/MSI-X
[    7.644936] pcieport 0000:00:1c.1: setting latency timer to 64
[    7.650985]   alloc irq_desc for 26 on node -1
[    7.651881]   alloc kstat_irqs on node -1
[    7.659670] pcieport 0000:00:1c.1: irq 26 for MSI/MSI-X
[    7.667173] initcall pcie_portdrv_init+0x0/0x7d returned 0 after 64328 usecs
[    7.674338] calling  aer_service_init+0x0/0x50 @ 1
[    7.679693] initcall aer_service_init+0x0/0x50 returned 0 after 442 usecs
[    7.686598] calling  ioapic_init+0x0/0x29 @ 1
[    7.691582] initcall ioapic_init+0x0/0x29 returned 0 after 506 usecs
[    7.698057] calling  vesafb_init+0x0/0x30f @ 1
[    7.703769] initcall vesafb_init+0x0/0x30f returned 0 after 1092 usecs
[    7.710403] calling  efifb_init+0x0/0x2be @ 1
[    7.714873] initcall efifb_init+0x0/0x2be returned -19 after 6 usecs
[    7.721330] calling  acpi_reserve_resources+0x0/0x141 @ 1
[    7.726846] initcall acpi_reserve_resources+0x0/0x141 returned 0 after 13 usecs
[    7.734336] calling  irqrouter_init_sysfs+0x0/0x62 @ 1
[    7.740492] initcall irqrouter_init_sysfs+0x0/0x62 returned 0 after 888 usecs
[    7.747750] calling  hypervisor_subsys_init+0x0/0x35 @ 1
[    7.753167] initcall hypervisor_subsys_init+0x0/0x35 returned -19 after 0 usecs
[    7.760644] calling  hyper_sysfs_init+0x0/0x174 @ 1
[    7.765627] initcall hyper_sysfs_init+0x0/0x174 returned -19 after 0 usecs
[    7.772604] calling  rand_initialize+0x0/0x4d @ 1
[    7.777451] initcall rand_initialize+0x0/0x4d returned 0 after 37 usecs
[    7.784167] calling  tty_init+0x0/0x15a @ 1
[    7.830680] initcall tty_init+0x0/0x15a returned 0 after 41233 usecs
[    7.837145] calling  pty_init+0x0/0x603 @ 1
[    8.157654] initcall pty_init+0x0/0x603 returned 0 after 308804 usecs
[    8.164220] calling  sysrq_init+0x0/0x33 @ 1
[    8.168628] initcall sysrq_init+0x0/0x33 returned 0 after 31 usecs
[    8.174911] calling  xen_init+0x0/0xd9 @ 1
[    8.179121] initcall xen_init+0x0/0xd9 returned -19 after 0 usecs
[    8.185318] calling  hpet_init+0x0/0xab @ 1
[    8.190743] initcall hpet_init+0x0/0xab returned 0 after 1109 usecs
[    8.197128] calling  init_tis+0x0/0xe2 @ 1
[    8.201801] initcall init_tis+0x0/0xe2 returned 0 after 453 usecs
[    8.208027] calling  cn_proc_init+0x0/0x5b @ 1
[    8.212654] initcall cn_proc_init+0x0/0x5b returned 0 after 59 usecs
[    8.219109] calling  serial8250_init+0x0/0x1d7 @ 1
[    8.224001] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    8.231105] async_waiting @ 1
[    8.234204] async_continuing @ 1 after 20 usec
[    8.360287] async_waiting @ 1
[    8.363362] async_continuing @ 1 after 1 usec
ÿ[    8.489331] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.498732] initcall serial8250_init+0x0/0x1d7 returned 0 after 268286 usecs
[    8.505902] calling  serial8250_pnp_init+0x0/0x20 @ 1
[    8.512818] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    8.519693] initcall serial8250_pnp_init+0x0/0x20 returned 0 after 8418 usecs
[    8.526956] calling  serial8250_pci_init+0x0/0x29 @ 1
[    8.532660] initcall serial8250_pci_init+0x0/0x29 returned 0 after 519 usecs
[    8.539825] calling  topology_sysfs_init+0x0/0x8e @ 1
[    8.545095] initcall topology_sysfs_init+0x0/0x8e returned 0 after 110 usecs
[    8.552246] calling  init_kgdbts+0x0/0x2d @ 1
[    8.556709] initcall init_kgdbts+0x0/0x2d returned 0 after 0 usecs
[    8.562991] calling  mac_hid_init+0x0/0x12e @ 1
[    8.568371] input: Macintosh mouse button emulation as /class/input/input0
[    8.575466] initcall mac_hid_init+0x0/0x12e returned 0 after 7631 usecs
[    8.582183] calling  fixed_mdio_bus_init+0x0/0x13a @ 1
[    8.588541] Fixed MDIO Bus: probed
[    8.592062] initcall fixed_mdio_bus_init+0x0/0x13a returned 0 after 4525 usecs
[    8.599455] calling  tg3_init+0x0/0x29 @ 1
[    8.603739] tg3.c:v3.106 (January 12, 2010)
[    8.608094] tg3 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    8.614910] tg3 0000:02:00.0: setting latency timer to 64
[    8.630778] eth0: Tigon3 [partno(BCM5751PKFBG) rev 4001] (PCI Express) MAC address 00:18:8b:01:d2:2b
[    8.640079] eth0: attached PHY is 5750 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    8.647817] eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    8.654276] eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    8.660087] initcall tg3_init+0x0/0x29 returned 0 after 55103 usecs
[    8.666473] calling  bnx2_init+0x0/0x29 @ 1
[    8.671327] initcall bnx2_init+0x0/0x29 returned 0 after 550 usecs
[    8.677625] calling  net_olddevs_init+0x0/0x11c @ 1
[    8.682614] initcall net_olddevs_init+0x0/0x11c returned 0 after 6 usecs
[    8.689417] calling  init_netconsole+0x0/0x32c @ 1
[    8.694318] console [netcon0] enabled
[    8.698081] netconsole: network logging started
[    8.702731] initcall init_netconsole+0x0/0x32c returned 0 after 8221 usecs
[    8.709710] calling  i8042_init+0x0/0x581 @ 1
[    8.716311] PNP: No PS/2 controller found. Probing ports directly.
[    8.725998] serio: i8042 KBD port at 0x60,0x64 irq 1
[    8.731291] serio: i8042 AUX port at 0x60,0x64 irq 12
[    8.737642] initcall i8042_init+0x0/0x581 returned 0 after 22911 usecs
[    8.744321] calling  mousedev_init+0x0/0xd8 @ 1
[    8.751304] mice: PS/2 mouse device common for all mice
[    8.756651] initcall mousedev_init+0x0/0xd8 returned 0 after 7504 usecs
[    8.763368] calling  atkbd_init+0x0/0x3c @ 1
[    8.768286] initcall atkbd_init+0x0/0x3c returned 0 after 531 usecs
[    8.774663] calling  init_ladder+0x0/0x20 @ 1
[    8.779166] cpuidle: using governor ladder
[    8.783367] initcall init_ladder+0x0/0x20 returned 0 after 4140 usecs
[    8.789910] calling  ledtrig_ide_init+0x0/0x29 @ 1
[    8.794886] initcall ledtrig_ide_init+0x0/0x29 returned 0 after 69 usecs
[    8.801690] calling  hid_init+0x0/0xac @ 1
[    8.806889] initcall hid_init+0x0/0xac returned 0 after 973 usecs
[    8.813098] calling  flow_cache_init+0x0/0x20d @ 1
[    8.818920] initcall flow_cache_init+0x0/0x20d returned 0 after 903 usecs
[    8.825838] calling  blackhole_module_init+0x0/0x20 @ 1
[    8.831173] initcall blackhole_module_init+0x0/0x20 returned 0 after 2 usecs
[    8.838323] calling  init_cgroup_cls+0x0/0x20 @ 1
[    8.843162] initcall init_cgroup_cls+0x0/0x20 returned 0 after 22 usecs
[    8.849878] calling  sysctl_ipv4_init+0x0/0x75 @ 1
[    8.857409] initcall sysctl_ipv4_init+0x0/0x75 returned 0 after 2575 usecs
[    8.864389] calling  init_syncookies+0x0/0x27 @ 1
[    8.869246] initcall init_syncookies+0x0/0x27 returned 0 after 47 usecs
[    8.875963] calling  ipv4_netfilter_init+0x0/0x25 @ 1
[    8.881160] initcall ipv4_netfilter_init+0x0/0x25 returned 0 after 18 usecs
[    8.888224] calling  cubictcp_register+0x0/0x76 @ 1
[    8.893206] TCP cubic registered
[    8.896538] initcall cubictcp_register+0x0/0x76 returned 0 after 3253 usecs
[    8.903603] calling  packet_init+0x0/0x71 @ 1
[    8.908065] NET: Registered protocol family 17
[    8.912658] initcall packet_init+0x0/0x71 returned 0 after 4487 usecs
[    8.919202] calling  dsa_init_module+0x0/0x22 @ 1
[    8.924027] initcall dsa_init_module+0x0/0x22 returned 0 after 6 usecs
[    8.930665] calling  edsa_init_module+0x0/0x22 @ 1
[    8.935562] initcall edsa_init_module+0x0/0x22 returned 0 after 1 usecs
[    8.942281] calling  trailer_init_module+0x0/0x22 @ 1
[    8.947438] initcall trailer_init_module+0x0/0x22 returned 0 after 1 usecs
[    8.954415] calling  mv88e6060_init+0x0/0x22 @ 1
[    8.959164] initcall mv88e6060_init+0x0/0x22 returned 0 after 18 usecs
[    8.965793] calling  mv88e6123_61_65_init+0x0/0x22 @ 1
[    8.971056] initcall mv88e6123_61_65_init+0x0/0x22 returned 0 after 2 usecs
[    8.978119] calling  mv88e6131_init+0x0/0x22 @ 1
[    8.982844] initcall mv88e6131_init+0x0/0x22 returned 0 after 2 usecs
[    8.989387] calling  dsa_init_module+0x0/0x20 @ 1
[    8.994664] initcall dsa_init_module+0x0/0x20 returned 0 after 451 usecs
[    9.001485] calling  dcbnl_init+0x0/0x47 @ 1
[    9.005876] initcall dcbnl_init+0x0/0x47 returned 0 after 0 usecs
[    9.012072] calling  tboot_late_init+0x0/0x2d5 @ 1
[    9.016969] initcall tboot_late_init+0x0/0x2d5 returned 0 after 0 usecs
[    9.023698] calling  mcheck_debugfs_init+0x0/0x60 @ 1
[    9.028907] initcall mcheck_debugfs_init+0x0/0x60 returned 0 after 52 usecs
[    9.035976] calling  severities_debugfs_init+0x0/0x5e @ 1
[    9.041515] initcall severities_debugfs_init+0x0/0x5e returned 0 after 26 usecs
[    9.048992] calling  hpet_insert_resource+0x0/0x3a @ 1
[    9.054260] initcall hpet_insert_resource+0x0/0x3a returned 0 after 3 usecs
[    9.061326] calling  update_mp_table+0x0/0x85c @ 1
[    9.066223] initcall update_mp_table+0x0/0x85c returned 0 after 0 usecs
[    9.072939] calling  lapic_insert_resource+0x0/0x55 @ 1
[    9.078284] initcall lapic_insert_resource+0x0/0x55 returned 0 after 2 usecs
[    9.085435] calling  init_lapic_nmi_sysfs+0x0/0x65 @ 1
[    9.090676] initcall init_lapic_nmi_sysfs+0x0/0x65 returned 0 after 0 usecs
[    9.097740] calling  io_apic_bug_finalize+0x0/0x29 @ 1
[    9.102984] initcall io_apic_bug_finalize+0x0/0x29 returned 0 after 0 usecs
[    9.110069] calling  check_early_ioremap_leak+0x0/0x91 @ 1
[    9.115657] initcall check_early_ioremap_leak+0x0/0x91 returned 0 after 0 usecs
[    9.123141] calling  pat_memtype_list_init+0x0/0x47 @ 1
[    9.128494] initcall pat_memtype_list_init+0x0/0x47 returned 0 after 24 usecs
[    9.137543] calling  sched_init_debug+0x0/0x32 @ 1
[    9.142460] initcall sched_init_debug+0x0/0x32 returned 0 after 22 usecs
[    9.149265] calling  init_oops_id+0x0/0x4b @ 1
[    9.153822] initcall init_oops_id+0x0/0x4b returned 0 after 8 usecs
[    9.160192] calling  disable_boot_consoles+0x0/0x67 @ 1
[    9.165522] initcall disable_boot_consoles+0x0/0x67 returned 0 after 0 usecs
[    9.172671] calling  pm_qos_power_init+0x0/0xb9 @ 1
[    9.179571] initcall pm_qos_power_init+0x0/0xb9 returned 0 after 1869 usecs
[    9.186649] calling  software_resume+0x0/0x4b2 @ 1
[    9.191565] initcall software_resume+0x0/0x4b2 returned -2 after 19 usecs
[    9.198457] initcall software_resume+0x0/0x4b2 returned with error code -2 
[    9.205520] calling  debugfs_kprobe_init+0x0/0xd4 @ 1
[    9.210753] initcall debugfs_kprobe_init+0x0/0xd4 returned 0 after 73 usecs
[    9.217820] calling  taskstats_init+0x0/0xe0 @ 1
[    9.222598] registered taskstats version 1
[    9.226797] initcall taskstats_init+0x0/0xe0 returned 0 after 4155 usecs
[    9.233602] calling  clear_boot_tracer+0x0/0x44 @ 1
[    9.238586] initcall clear_boot_tracer+0x0/0x44 returned 0 after 0 usecs
[    9.245389] calling  max_swapfiles_check+0x0/0xf @ 1
[    9.250459] initcall max_swapfiles_check+0x0/0xf returned 0 after 0 usecs
[    9.257346] calling  init_ima+0x0/0x23 @ 1
[    9.261552] No TPM chip found, activating TPM-bypass!
[    9.267049] initcall init_ima+0x0/0x23 returned 0 after 5366 usecs
[    9.273342] calling  random32_reseed+0x0/0xdc @ 1
[    9.278193] initcall random32_reseed+0x0/0xdc returned 0 after 42 usecs
[    9.284911] calling  pci_resource_alignment_sysfs_init+0x0/0x27 @ 1
[    9.291318] initcall pci_resource_alignment_sysfs_init+0x0/0x27 returned 0 after 20 usecs
[    9.299664] calling  pci_sysfs_init+0x0/0x7b @ 1
[    9.305277] initcall pci_sysfs_init+0x0/0x7b returned 0 after 870 usecs
[    9.311995] calling  boot_wait_for_devices+0x0/0x27 @ 1
[    9.317344] initcall boot_wait_for_devices+0x0/0x27 returned 0 after 0 usecs
[    9.324493] calling  regulator_init_complete+0x0/0x1de @ 1
[    9.330103] initcall regulator_init_complete+0x0/0x1de returned 0 after 21 usecs
[    9.337666] calling  seqgen_init+0x0/0x1d @ 1
[    9.342161] initcall seqgen_init+0x0/0x1d returned 0 after 33 usecs
[    9.348531] calling  hd_init+0x0/0x3f9 @ 1
[    9.352857] hd: no drives specified - use hd=cyl,head,sectors on kernel command line
[    9.360976] initcall hd_init+0x0/0x3f9 returned -1 after 8049 usecs
[    9.367358] initcall hd_init+0x0/0x3f9 returned with error code -1 
[    9.373727] calling  memmap_init+0x0/0xec @ 1
[    9.378462] initcall memmap_init+0x0/0xec returned 0 after 264 usecs
[    9.384917] calling  pci_mmcfg_late_insert_resources+0x0/0x97 @ 1
[    9.391129] initcall pci_mmcfg_late_insert_resources+0x0/0x97 returned 0 after 2 usecs
[    9.399213] calling  init_net_drop_monitor+0x0/0x209 @ 1
[    9.404626] Initalizing network drop monitor service
[    9.409820] initcall init_net_drop_monitor+0x0/0x209 returned 0 after 5069 usecs
[    9.417385] calling  tcp_congestion_default+0x0/0x20 @ 1
[    9.422805] initcall tcp_congestion_default+0x0/0x20 returned 0 after 2 usecs
[    9.430047] calling  ip_auto_config+0x0/0x1287 @ 1
[    9.434962] initcall ip_auto_config+0x0/0x1287 returned 0 after 20 usecs
[    9.441780] calling  initialize_hashrnd+0x0/0x27 @ 1
[    9.446858] initcall initialize_hashrnd+0x0/0x27 returned 0 after 8 usecs
[    9.453792] async_waiting @ 1
[    9.456863] async_continuing @ 1 after 1 usec
[    9.461392] Freeing unused kernel memory: 2852k freed
[    9.468200] Write protecting the kernel read-only data: 10240k
[    9.475436] Freeing unused kernel memory: 1156k freed
[    9.482718] Freeing unused kernel memory: 1676k freed
[    9.787844] calling  video_output_class_init+0x0/0x27 [output] @ 1009
[    9.794568] initcall video_output_class_init+0x0/0x27 [output] returned 0 after 123 usecs
[    9.810450] calling  hwmon_init+0x0/0x186 [hwmon] @ 1010
[    9.816084] initcall hwmon_init+0x0/0x186 [hwmon] returned 0 after 187 usecs
[    9.832599] calling  thermal_init+0x0/0x88 [thermal_sys] @ 1011
[    9.838768] initcall thermal_init+0x0/0x88 [thermal_sys] returned 0 after 119 usecs
[    9.857084] calling  acpi_video_init+0x0/0xbb [video] @ 1012
[    9.863339] initcall acpi_video_init+0x0/0xbb [video] returned 0 after 456 usecs
[    9.883633] calling  i2c_init+0x0/0xba [i2c_core] @ 1013
[    9.889578] initcall i2c_init+0x0/0xba [i2c_core] returned 0 after 494 usecs
[    9.904655] calling  acpi_button_init+0x0/0x7d [button] @ 1014
[    9.911159] input: Power Button as /class/input/input1
[    9.916504] ACPI: Power Button [VBTN]
[    9.920746] input: Power Button as /class/input/input2
[    9.926026] ACPI: Power Button [PWRF]
[    9.929954] initcall acpi_button_init+0x0/0x7d [button] returned 0 after 18887 usecs
[    9.958763] calling  agp_init+0x0/0x3b [agpgart] @ 1016
[    9.964102] Linux agpgart interface v0.103
[    9.968307] initcall agp_init+0x0/0x3b [agpgart] returned 0 after 4100 usecs
[   10.016714] calling  drm_core_init+0x0/0x1b0 [drm] @ 1017
[   10.022475] [drm] Initialized drm 1.1.0 20060810
[   10.027220] initcall drm_core_init+0x0/0x1b0 [drm] returned 0 after 4852 usecs
[   10.035134] modprobe used greatest stack depth: 5696 bytes left
[   10.098728] calling  i915_init+0x0/0x94 [i915] @ 1019
[   10.104024] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   10.110928] i915 0000:00:02.0: setting latency timer to 64
[   10.116566] [drm:drm_fill_in_dev] *ERROR* Cannot initialize the agpgart module.
[   10.124123] DRM: Fill_in_dev failed.
[   10.127818] i915 0000:00:02.0: PCI INT A disabled
[   10.132665] i915: probe of 0000:00:02.0 failed with error -22
[   10.138801] initcall i915_init+0x0/0x94 [i915] returned 0 after 34070 usecs
[   10.172816] modprobe used greatest stack depth: 5600 bytes left
[   10.178876] loadkeys used greatest stack depth: 5576 bytes left
[   10.379573] calling  usb_init+0x0/0x2c8 [usbcore] @ 1028
[   10.385658] usbcore: registered new interface driver usbfs
[   10.391771] usbcore: registered new interface driver hub
[   10.397499] usbcore: registered new device driver usb
[   10.402676] initcall usb_init+0x0/0x2c8 [usbcore] returned 0 after 17224 usecs
[   10.415588] calling  ehci_hcd_init+0x0/0x136 [ehci_hcd] @ 1028
[   10.421541] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[   10.428287]   alloc irq_desc for 21 on node -1
[   10.429163]   alloc kstat_irqs on node -1
[   10.436964] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.444277] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   10.450218] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   10.455875] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[   10.463570] ehci_hcd 0000:00:1d.7: using broken periodic workaround
[   10.469959] ehci_hcd 0000:00:1d.7: debug port 1
[   10.478501] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[   10.485480] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[   10.501047] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[   10.507297] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[   10.514187] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.521579] usb usb1: Product: EHCI Host Controller
[   10.526561] usb usb1: Manufacturer: Linux 2.6.33 ehci_hcd
[   10.532063] usb usb1: SerialNumber: 0000:00:1d.7
[   10.538050] hub 1-0:1.0: USB hub found
[   10.541950] hub 1-0:1.0: 8 ports detected
[   10.547049] initcall ehci_hcd_init+0x0/0x136 [ehci_hcd] returned 0 after 122557 usecs
[   10.555446] modprobe used greatest stack depth: 4464 bytes left
[   10.576158] calling  init_pcmcia_cs+0x0/0x4b [pcmcia_core] @ 1031
[   10.582540] initcall init_pcmcia_cs+0x0/0x4b [pcmcia_core] returned 0 after 155 usecs
[   10.601228] calling  init_pcmcia_bus+0x0/0xca [pcmcia] @ 1031
[   10.607401] initcall init_pcmcia_bus+0x0/0xca [pcmcia] returned 0 after 300 usecs
[   10.630231] calling  mmc_init+0x0/0xd8 [mmc_core] @ 1031
[   10.636359] initcall mmc_init+0x0/0xd8 [mmc_core] returned 0 after 676 usecs
[   10.655430] calling  ssb_modinit+0x0/0xb1 [ssb] @ 1031
[   10.661144] initcall ssb_modinit+0x0/0xb1 [ssb] returned 0 after 443 usecs
[   10.673819] calling  ohci_hcd_mod_init+0x0/0x135 [ohci_hcd] @ 1031
[   10.680120] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[   10.686805] initcall ohci_hcd_mod_init+0x0/0x135 [ohci_hcd] returned 0 after 6523 usecs
[   10.705066] calling  uhci_hcd_init+0x0/0x12b [uhci_hcd] @ 1033
[   10.711024] uhci_hcd: USB Universal Host Controller Interface driver
[   10.718170] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   10.725475] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.731420] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.736825] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[   10.744499] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[   10.750846] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[   10.757741] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.765147] usb usb2: Product: UHCI Host Controller
[   10.770137] usb usb2: Manufacturer: Linux 2.6.33 uhci_hcd
[   10.775647] usb usb2: SerialNumber: 0000:00:1d.0
[   10.781379] hub 2-0:1.0: USB hub found
[   10.785334] hub 2-0:1.0: 2 ports detected
[   10.790110]   alloc irq_desc for 22 on node -1
[   10.791008]   alloc kstat_irqs on node -1
[   10.798793] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[   10.806334] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   10.812308] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   10.817738] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[   10.825434] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[   10.831559] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   10.838453] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.845848] usb usb3: Product: UHCI Host Controller
[   10.850830] usb usb3: Manufacturer: Linux 2.6.33 uhci_hcd
[   10.858172] usb usb3: SerialNumber: 0000:00:1d.1
[   10.863933] hub 3-0:1.0: USB hub found
[   10.867831] hub 3-0:1.0: 2 ports detected
[   10.872591]   alloc irq_desc for 18 on node -1
[   10.873005]   alloc kstat_irqs on node -1
[   10.881265] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   10.888526] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   10.894483] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   10.899967] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[   10.907662] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[   10.913774] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[   10.920666] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   10.928053] usb usb4: Product: UHCI Host Controller
[   10.933039] usb usb4: Manufacturer: Linux 2.6.33 uhci_hcd
[   10.938549] usb usb4: SerialNumber: 0000:00:1d.2
[   10.944129] hub 4-0:1.0: USB hub found
[   10.948050] hub 4-0:1.0: 2 ports detected
[   10.952797]   alloc irq_desc for 23 on node -1
[   10.953158]   alloc kstat_irqs on node -1
[   10.961565] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[   10.968836] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   10.974800] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   10.980344] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[   10.988049] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[   10.994173] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[   11.001066] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.008463] usb usb5: Product: UHCI Host Controller
[   11.013446] usb usb5: Manufacturer: Linux 2.6.33 uhci_hcd
[   11.018950] usb usb5: SerialNumber: 0000:00:1d.3
[   11.024642] hub 5-0:1.0: USB hub found
[   11.028541] hub 5-0:1.0: 2 ports detected
[   11.033478] initcall uhci_hcd_init+0x0/0x12b [uhci_hcd] returned 0 after 314887 usecs
[   11.051742] calling  init_mbcache+0x0/0x22 [mbcache] @ 1034
[   11.057595] initcall init_mbcache+0x0/0x22 [mbcache] returned 0 after 127 usecs
[   11.074130] calling  journal_init+0x0/0x114 [jbd] @ 1034
[   11.081575] initcall journal_init+0x0/0x114 [jbd] returned 0 after 1952 usecs
[   11.105811] calling  init_ext3_fs+0x0/0xbf [ext3] @ 1034
[   11.112278] initcall init_ext3_fs+0x0/0xbf [ext3] returned 0 after 1000 usecs
[   11.159752] calling  init_scsi+0x0/0x131 [scsi_mod] @ 1036
[   11.169330] SCSI subsystem initialized
[   11.173212] initcall init_scsi+0x0/0x131 [scsi_mod] returned 0 after 7650 usecs
[   11.182847] usb 3-1: new full speed USB device using uhci_hcd and address 2
[   11.193844] calling  init_sd+0x0/0x227 [sd_mod] @ 1037
[   11.199927] initcall init_sd+0x0/0x227 [sd_mod] returned 0 after 803 usecs
[   11.236974] calling  ide_init+0x0/0xcc [ide_core] @ 1038
[   11.242408] Uniform Multi-Platform E-IDE driver
[   11.247538] initcall ide_init+0x0/0xcc [ide_core] returned 0 after 4998 usecs
[   11.262279] calling  generic_ide_init+0x0/0x2e [ide_pci_generic] @ 1039
[   11.269411] initcall generic_ide_init+0x0/0x2e [ide_pci_generic] returned 0 after 375 usecs
[   11.315223] calling  ata_init+0x0/0x470 [libata] @ 1040
[   11.321395] libata version 3.00 loaded.
[   11.325369] initcall ata_init+0x0/0x470 [libata] returned 0 after 4649 usecs
[   11.343923] calling  piix_init+0x0/0x45 [ata_piix] @ 1044
[   11.349673] ata_piix 0000:00:1f.1: version 2.13
[   11.354437] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.361994] ata_piix 0000:00:1f.1: setting latency timer to 64
[   11.368399] scsi0 : ata_piix
[   11.373277] scsi1 : ata_piix
[   11.377482] usb 3-1: New USB device found, idVendor=413c, idProduct=1003
[   11.382977] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[   11.382983] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[   11.383137]   alloc irq_desc for 20 on node -1
[   11.383142]   alloc kstat_irqs on node -1
[   11.383162] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[   11.383178] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[   11.384089] ata2: port disabled. ignoring.
[   11.424474] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   11.431709] usb 3-1: Product: Dell USB Keyboard Hub
[   11.436687] usb 3-1: Manufacturer: Dell
[   11.449669] hub 3-1:1.0: USB hub found
[   11.454112] hub 3-1:1.0: 3 ports detected
[   11.534394] ata_piix 0000:00:1f.2: setting latency timer to 64
[   11.540785] ata1.00: ATAPI: HL-DT-STDVD+-RW GSA-H21N, A105, max UDMA/33
[   11.548113] scsi2 : ata_piix
[   11.551858] scsi3 : ata_piix
[   11.555172] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 20
[   11.555617] ata1.00: configured for UDMA/33
[   11.566896] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 20
[   11.575398] initcall piix_init+0x0/0x45 [ata_piix] returned 0 after 220599 usecs
[   11.577564] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVD+-RW GSA-H21N A105 PQ: 0 ANSI: 5
[   11.729483] ata3.00: ATA-7: WDC WD2500JS-75NCB3, 10.02E04, max UDMA/133
[   11.736216] ata3.00: 488281250 sectors, multi 8: LBA48 NCQ (depth 0/32)
[   11.745477] usb 3-1.1: new full speed USB device using uhci_hcd and address 3
[   11.753104] ata3.00: configured for UDMA/133
[   11.758116] scsi 2:0:0:0: Direct-Access     ATA      WDC WD2500JS-75N 10.0 PQ: 0 ANSI: 5
[   11.767731] sd 2:0:0:0: [sda] 488281250 512-byte logical blocks: (250 GB/232 GiB)
[   11.775953] sd 2:0:0:0: [sda] Write Protect is off
[   11.780884] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   11.786283] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   11.796708]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
[   11.837841] sd 2:0:0:0: [sda] Attached SCSI disk
[   11.888483] usb 3-1.1: New USB device found, idVendor=413c, idProduct=2010
[   11.895479] usb 3-1.1: New USB device strings: Mfr=1, Product=3, SerialNumber=0
[   11.902966] usb 3-1.1: Product: Dell USB Keyboard
[   11.907774] usb 3-1.1: Manufacturer: Dell
[   11.988484] usb 3-1.3: new low speed USB device using uhci_hcd and address 4
[   12.122488] usb 3-1.3: New USB device found, idVendor=046d, idProduct=c016
[   12.129481] usb 3-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[   12.136966] usb 3-1.3: Product: Optical USB Mouse
[   12.141774] usb 3-1.3: Manufacturer: Logitech
[   13.372461] calling  pacpi_init+0x0/0x2e [pata_acpi] @ 1053
[   13.378421] initcall pacpi_init+0x0/0x2e [pata_acpi] returned 0 after 231 usecs
[   13.394884] calling  ata_generic_init+0x0/0x2e [ata_generic] @ 1054
[   13.401528] initcall ata_generic_init+0x0/0x2e [ata_generic] returned 0 after 241 usecs
[   13.415578] calling  wait_scan_init+0x0/0x1b [scsi_wait_scan] @ 1055
[   13.422058] initcall wait_scan_init+0x0/0x1b [scsi_wait_scan] returned 0 after 3 usecs
[   13.701618] kjournald starting.  Commit interval 5 seconds
[   13.707818] EXT3-fs (sda6): mounted filesystem with writeback data mode
[   14.105097] modprobe used greatest stack depth: 3672 bytes left
[   14.544193] sh used greatest stack depth: 3480 bytes left
		Welcome to Fedora 
		Press 'I' to enter interactive startup.
Starting udev: [   16.150539] udev: starting version 141
[   16.154837] udev: deprecated sysfs layout; update the kernel or disable CONFIG_SYSFS_DEPRECATED; some udev features will not work correctly
[   16.799497] calling  dcdbas_init+0x0/0xb2 [dcdbas] @ 1164
[   16.831064] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   16.838950] initcall dcdbas_init+0x0/0xb2 [dcdbas] returned 0 after 32985 usecs
[   17.087386] calling  evdev_init+0x0/0x20 [evdev] @ 1172
[   17.109489] initcall evdev_init+0x0/0x20 [evdev] returned 0 after 16306 usecs
[   17.161043] calling  cdrom_init+0x0/0x1b [cdrom] @ 1211
[   17.188750] initcall cdrom_init+0x0/0x1b [cdrom] returned 0 after 21788 usecs
[   17.345173] calling  init_sr+0x0/0x72 [sr_mod] @ 1211
[   17.403415] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   17.410509] Uniform CD-ROM driver Revision: 3.20
[   17.461941] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   17.477616] initcall init_sr+0x0/0x72 [sr_mod] returned 0 after 124010 usecs
G[   21.202061] calling  acpi_thermal_init+0x0/0xb7 [thermal] @ 2015
[   21.287742] initcall acpi_thermal_init+0x0/0xb7 [thermal] returned 0 after 77502 usecs
[   21.324213] calling  acpi_processor_init+0x0/0x18b [processor] @ 2009
[   21.393144] initcall acpi_processor_init+0x0/0x18b [processor] returned 0 after 60837 usecs
[   21.563825] calling  rtc_init+0x0/0xa0 [rtc_core] @ 2079
[   21.599589] initcall rtc_init+0x0/0xa0 [rtc_core] returned 0 after 29299 usecs
[   21.599964] calling  parport_default_proc_register+0x0/0x29 [parport] @ 2089
[   21.600102] initcall parport_default_proc_register+0x0/0x29 [parport] returned 0 after 122 usecs
[   21.689076] calling  i2c_i801_init+0x0/0x106 [i2c_i801] @ 2124
[   21.718488] calling  parport_pc_init+0x0/0x7fa [parport_pc] @ 2089
[   21.725296] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   21.756953] parport_pc 00:06: reported by Plug and Play ACPI
[   21.767418] initcall i2c_i801_init+0x0/0x106 [i2c_i801] returned 0 after 70627 usecs
[   21.802357] parport0: PC-style at 0x378 (0x778), irq 7, using FIFO [PCSPP,TRISTATE,COMPAT,ECP]
[   21.823324] calling  snd_mem_init+0x0/0x3a [snd_page_alloc] @ 2113
[   21.843569] initcall snd_mem_init+0x0/0x3a [snd_page_alloc] returned 0 after 13490 usecs
[   21.852829] general protection fault: 0000 [#1] SMP 
[   21.856321] last sysfs file: /sys/module/parport/initstate
[   21.856321] CPU 0 
[   21.856321] Pid: 2089, comm: modprobe Not tainted 2.6.33 #11 0HH807/OptiPlex GX620               
[   21.856321] RIP: 0010:[<ffffffffa0437671>]  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
[   21.856321] RSP: 0018:ffff8800765cba78  EFLAGS: 00010283
[   21.856321] RAX: ffff10007b04a3d0 RBX: ffff88007a6a5e30 RCX: 0000000000000000
[   21.856321] RDX: 0000000000000000 RSI: ffffffffa043d1de RDI: ffff88007a6a5e30
[   21.856321] RBP: ffff8800765cbad8 R08: 0000000000000000 R09: 0000000000000000
[   21.856321] R10: ffffffffa043dff8 R11: 0000000000000000 R12: ffffffffa043d1de
[   21.856321] R13: ffffffffa043d1de R14: ffffffffa045c940 R15: 0000000000000000
[   21.856321] FS:  00007f09cc3fb6f0(0000) GS:ffff880004a00000(0000) knlGS:0000000000000000
[   21.856321] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   21.856321] CR2: 0000003fb5ad62c0 CR3: 00000000764f6000 CR4: 00000000000006f0
[   21.856321] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   21.856321] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   21.856321] Process modprobe (pid: 2089, threadinfo ffff8800765ca000, task ffff88007664a3d0)
[   21.856321] Stack:
[   21.856321]  ffff8800765cbab8 0000000000000206 0000000000000000 ffffffff812abaf2
[   21.856321] <0> 0000000000000000 0000000000000000 ffffffffa043d1de 00000000ffffffff
[   21.856321] <0> ffff88007a6a5e30 ffffffffa043d1de 0000000000000000 0000000000000378
[   21.856321] Call Trace:
[   21.856321]  [<ffffffff812abaf2>] ? do_raw_spin_unlock+0xd7/0xe7
[   21.856321]  [<ffffffffa043b385>] parport_open+0x12d/0x14d [parport]
[   21.856321]  [<ffffffffa043bccf>] parport_device_id+0x2e/0xa00 [parport]
[   21.856321]  [<ffffffff8117ab73>] ? __slab_alloc+0x560/0x5f7
[   21.856321]  [<ffffffffa043bb06>] ? parport_daisy_init+0x55f/0x665 [parport]
[   21.856321]  [<ffffffffa043bb06>] ? parport_daisy_init+0x55f/0x665 [parport]
[   21.856321]  [<ffffffffa043bb53>] parport_daisy_init+0x5ac/0x665 [parport]
[   21.856321]  [<ffffffffa0436f6d>] parport_announce_port+0x1a/0x201 [parport]
[   21.856321]  [<ffffffffa0456848>] parport_pc_probe_port+0x13a5/0x1478 [parport_pc]
[   21.856321]  [<ffffffffa0456c36>] parport_pc_pnp_probe+0x31b/0x358 [parport_pc]
[   21.856321]  [<ffffffff81323b1f>] pnp_device_probe+0x11a/0x15e
[   21.856321]  [<ffffffff81376f15>] ? driver_sysfs_add+0x61/0x9b
[   21.856321]  [<ffffffff81377223>] driver_probe_device+0x1bc/0x339
[   21.856321]  [<ffffffff8137743e>] __driver_attach+0x9e/0xde
[   21.856321]  [<ffffffff813773a0>] ? __driver_attach+0x0/0xde
[   21.856321]  [<ffffffff81376038>] bus_for_each_dev+0x83/0xdb
[   21.856321]  [<ffffffff81376e26>] driver_attach+0x25/0x2e
[   21.856321]  [<ffffffff81376823>] bus_add_driver+0x14c/0x367
[   21.856321]  [<ffffffff813778e7>] driver_register+0xf8/0x1b2
[   21.856321]  [<ffffffff81323771>] pnp_register_driver+0x28/0x31
[   21.856321]  [<ffffffffa046380b>] parport_pc_init+0x708/0x7fa [parport_pc]
[   21.856321]  [<ffffffffa0463103>] ? parport_pc_init+0x0/0x7fa [parport_pc]
[   21.856321]  [<ffffffff810020d6>] do_one_initcall+0x9c/0x223
[   21.856321]  [<ffffffff810bcfd9>] sys_init_module+0x139/0x32b
[   21.856321]  [<ffffffff8100c732>] system_call_fastpath+0x16/0x1b
[   21.856321] Code: 65 8b 14 25 d8 e3 00 00 41 83 3e 02 0f 84 80 00 00 00 48 ff 05 09 72 00 00 48 63 d2 49 8b 86 28 02 00 00 48 03 04 d5 b0 97 b9 81 <48> ff 00 49 8b 86 28 02 00 00 48 03 04 d5 b0 97 b9 81 48 8b 00 
[   21.856321] RIP  [<ffffffffa0437671>] parport_register_device+0xe4/0x48c [parport]
[   21.856321]  RSP <ffff8800765cba78>
[   22.192206] ---[ end trace 892b5882bd1f8c3e ]---
udevd-event[2070]: '/sbin/modprobe -b acpi:PNP0401:' abnormal exit

[   22.267509] calling  pcspkr_init+0x0/0x20 [pcspkr] @ 2153
[   22.276812] calling  mod_init+0x0/0x383 [intel_rng] @ 2120
[   22.279726] input: PC Speaker as /class/input/input3
[   22.280510] initcall pcspkr_init+0x0/0x20 [pcspkr] returned 0 after 7136 usecs
[   22.299610] intel_rng: Firmware space is locked read-only. If you can't or
[   22.299614] intel_rng: don't want to disable this in firmware setup, and if
[   22.299617] intel_rng: you are certain that your system has a functional
[   22.299618] intel_rng: RNG, try using the 'no_fwh_detect' option.
[   22.326686] initcall mod_init+0x0/0x383 [intel_rng] returned -16 after 30981 usecs
[   22.334506] initcall mod_init+0x0/0x383 [intel_rng] returned with error code -16 
[   22.354631] calling  cmos_init+0x0/0xad [rtc_cmos] @ 2079
[   22.355140] calling  init_soundcore+0x0/0xd9 [soundcore] @ 2113
[   22.355257] initcall init_soundcore+0x0/0xd9 [soundcore] returned 0 after 104 usecs
[   22.477509] calling  iTCO_vendor_init_module+0x0/0x2a [iTCO_vendor_support] @ 2120
[   22.485307] iTCO_vendor_support: vendor-support=0
[   22.490120] initcall iTCO_vendor_init_module+0x0/0x2a [iTCO_vendor_support] returned 0 after 4697 usecs
[   22.531155] calling  alsa_sound_init+0x0/0xce [snd] @ 2113
[   22.536950] initcall alsa_sound_init+0x0/0xce [snd] returned 0 after 187 usecs
[   22.553852] calling  serio_raw_init+0x0/0x2e [serio_raw] @ 2160
[   22.560208] initcall serio_raw_init+0x0/0x2e [serio_raw] returned 0 after 275 usecs
[   22.647358] calling  alsa_timer_init+0x0/0x21d [snd_timer] @ 2113
[   22.654281] initcall alsa_timer_init+0x0/0x21d [snd_timer] returned 0 after 620 usecs
[   22.669862] calling  init_sg+0x0/0x1a7 [sg] @ 2144
[   22.676325] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   22.683927] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   22.689610] initcall init_sg+0x0/0x1a7 [sg] returned 0 after 14257 usecs
[   22.705824] calling  ppdev_init+0x0/0x128 [ppdev] @ 2192
[   22.722422] calling  hid_init+0x0/0x149 [usbhid] @ 2188
[   22.733408] usbcore: registered new interface driver hiddev
[   22.742270] calling  iTCO_wdt_init_module+0x0/0x9b [iTCO_wdt] @ 2120
[   22.748870] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   22.755406] iTCO_wdt: failed to reset NO_REBOOT flag, reboot disabled by hardware
[   22.757770] input: Dell Dell USB Keyboard as /class/input/input4
[   22.759456] generic-usb 0003:413C:2010.0001: input,hidraw0: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input0
[   22.782337] iTCO_wdt: No card detected
[   22.786414] initcall iTCO_wdt_init_module+0x0/0x9b [iTCO_wdt] returned 0 after 36657 usecs
[   22.797361] input: Dell Dell USB Keyboard as /class/input/input5
[   22.804363] generic-usb 0003:413C:2010.0002: input,hidraw1: USB HID v1.10 Device [Dell Dell USB Keyboard] on usb-0000:00:1d.1-1.1/input1
[   22.830933] calling  leds_init+0x0/0x58 [led_class] @ 2120
[   22.831091] input: Logitech Optical USB Mouse as /class/input/input6
[   22.831840] generic-usb 0003:046D:C016.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Optical USB Mouse] on usb-0000:00:1d.1-1.3/input0
[   22.832041] usbcore: registered new interface driver usbhid
[   22.832045] usbhid: USB HID core driver
[   22.832060] initcall hid_init+0x0/0x149 [usbhid] returned 0 after 101673 usecs
[   22.903744] initcall leds_init+0x0/0x58 [led_class] returned 0 after 30211 usecs
[   22.948456] calling  psmouse_init+0x0/0xc1 [psmouse] @ 2160
[   22.956373] calling  alsa_pcm_init+0x0/0xa9 [snd_pcm] @ 2221
[   22.958040] initcall psmouse_init+0x0/0xc1 [psmouse] returned 0 after 3739 usecs
[   22.969855] initcall alsa_pcm_init+0x0/0xa9 [snd_pcm] returned 0 after 68 usecs
[   23.016861] calling  joydev_init+0x0/0x20 [joydev] @ 2250
[   23.022563] initcall joydev_init+0x0/0x20 [joydev] returned 0 after 127 usecs
[   23.045870] calling  nas_gpio_init+0x0/0x31f [leds_ss4200] @ 2120
[   23.052244] leds_ss4200: no LED devices found
[   23.056740] initcall nas_gpio_init+0x0/0x31f [leds_ss4200] returned -19 after 4386 usecs
[   23.084820] calling  alsa_seq_device_init+0x0/0x87 [snd_seq_device] @ 2272
[   23.091980] initcall alsa_seq_device_init+0x0/0x87 [snd_seq_device] returned 0 after 125 usecs
[   23.175836] calling  alsa_seq_init+0x0/0xae [snd_seq] @ 2272
[   23.182111] initcall alsa_seq_init+0x0/0xae [snd_seq] returned 0 after 480 usecs
[   23.219203] calling  ac97_bus_init+0x0/0x20 [ac97_bus] @ 2113
[   23.225361] initcall ac97_bus_init+0x0/0x20 [ac97_bus] returned 0 after 236 usecs
[   23.303586] calling  alsa_ac97_init+0x0/0xf [snd_ac97_codec] @ 2113
[   23.309994] initcall alsa_ac97_init+0x0/0xf [snd_ac97_codec] returned 0 after 0 usecs
[   23.344827] calling  alsa_card_intel8x0_init+0x0/0x2e [snd_intel8x0] @ 2113
[   23.352223] Intel ICH 0000:00:1e.2: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   23.359706] Intel ICH 0000:00:1e.2: setting latency timer to 64
[   23.730971] intel8x0: white list rate for 1028:01ad is 48000
[   23.739918] initcall alsa_card_intel8x0_init+0x0/0x2e [snd_intel8x0] returned 0 after 378857 usecs
[   23.779633] general protection fault: 0000 [#2] SMP 
[   23.780130] last sysfs file: /sys/class/sound/controlC0/dev
[   23.780130] CPU 1 
[   23.780130] Pid: 2300, comm: alsactl Tainted: G      D    2.6.33 #11 0HH807/OptiPlex GX620               
[   23.780130] RIP: 0010:[<ffffffffa04a204a>]  [<ffffffffa04a204a>] try_module_get+0x4a/0xcc [snd]
[   23.780130] RSP: 0018:ffff88007a905c98  EFLAGS: 00010287
[   23.780130] RAX: ffff10007b1047a0 RBX: 0000000000000000 RCX: ffff88007a905cf8
[   23.780130] RDX: 0000000000000001 RSI: 000000000000007e RDI: ffffffffa04af5c0
[   23.780130] RBP: ffff88007a905cb8 R08: 0000000000000206 R09: ffff88007a905cc8
[   23.780130] R10: ffffffff81a6ad48 R11: 0000000000000000 R12: ffffffffa04af5c0
[   23.780130] R13: ffff880074cafb20 R14: ffffffffa04ac7c0 R15: ffff88007a469330
[   23.780130] FS:  00007fd32f8246f0(0000) GS:ffff880004c00000(0000) knlGS:0000000000000000
[   23.780130] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   23.780130] CR2: 0000003fc1eafa60 CR3: 0000000076750000 CR4: 00000000000006e0
[   23.780130] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   23.780130] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   23.780130] Process alsactl (pid: 2300, threadinfo ffff88007a904000, task ffff88007665a3d0)
[   23.780130] Stack:
[   23.780130]  ffff88007671f500 0000000000000000 ffff88007671f500 ffff880074cafb20
[   23.780130] <0> ffff88007a905cf8 ffffffffa04a27d5 ffff88007a9304b0 ffff880074cafb20
[   23.780130] <0> ffff88007671f500 ffff88007a9304b0 0000000000000000 0000000000000000
[   23.780130] Call Trace:
[   23.780130]  [<ffffffffa04a27d5>] snd_open+0x130/0x237 [snd]
[   23.780130]  [<ffffffff81192948>] chrdev_open+0x1c8/0x207
[   23.780130]  [<ffffffff8118fc22>] ? file_move+0x31/0x6a
[   23.780130]  [<ffffffff81192780>] ? chrdev_open+0x0/0x207
[   23.780130]  [<ffffffff8118bb80>] __dentry_open+0x29f/0x470
[   23.780130]  [<ffffffff812642ff>] ? devcgroup_inode_permission+0x178/0x1c2
[   23.780130]  [<ffffffff8122f373>] ? security_inode_permission+0x31/0x3a
[   23.780130]  [<ffffffff8118be89>] nameidata_to_filp+0x46/0x6c
[   23.780130]  [<ffffffff8119def8>] do_filp_open+0x7f5/0xfed
[   23.780130]  [<ffffffff810abc84>] ? print_lock_contention_bug+0x22/0x152
[   23.780130]  [<ffffffff814d17b1>] ? _raw_spin_unlock+0x40/0x4b
[   23.780130]  [<ffffffff811ac2df>] ? spin_unlock+0x15/0x1e
[   23.780130]  [<ffffffff8118b724>] do_sys_open+0x86/0x17a
[   23.780130]  [<ffffffff8118b860>] sys_open+0x27/0x30
[   23.780130]  [<ffffffff8100c732>] system_call_fastpath+0x16/0x1b
[   23.780130] Code: 00 65 8b 14 25 d8 e3 00 00 83 3f 02 0f 84 83 00 00 00 48 ff 05 20 e0 00 00 48 63 d2 48 8b 87 28 02 00 00 48 03 04 d5 b0 97 b9 81 <48> ff 00 48 8b 87 28 02 00 00 48 03 04 d5 b0 97 b9 81 4c 8b 28 
[   23.780130] RIP  [<ffffffffa04a204a>] try_module_get+0x4a/0xcc [snd]
[   23.780130]  RSP <ffff88007a905c98>
[   24.046356] ---[ end trace 892b5882bd1f8c3f ]---
udevd-event[2299]: '/sbin/alsactl -E ALSA_CONFIG_PATH=/etc/alsa/alsactl.conf --initfile=/lib/alsa/init/00main restore /dev/snd/controlC0' abnormal exit


--------------070909020602040903010907--
