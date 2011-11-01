Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1KAQGL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 12:06:11 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62250 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab1KAQGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 12:06:07 -0400
Message-ID: <4EB01904.10605@lwfinger.net>
Date: Tue, 01 Nov 2011 11:06:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos>
In-Reply-To: <20111030050443.GC4535@xanatos>
Content-Type: multipart/mixed;
 boundary="------------010208060608070507020607"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010208060608070507020607
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/30/2011 12:04 AM, Sarah Sharp wrote:

> The xHCI driver allocates a fixed-size endpoint ring, and only so much
> data can fit on it.  If the driver is allocating many URBs or many URBs
> with a lot of data, then you will see these messages and the URBs will
> fail to be submitted.  Now if neither of those conditions are true, then
> it's possible we just have a bug in the xHCI driver.
>
> There is a patchset in the works to dynamically expand the endpoint
> rings, but it's still going through revisions:
>
> http://marc.info/?l=linux-usb&m=131918645424329&w=2

I have a bit more to report. Applying the above patch set did not help.

I modified the xHCI driver from 3.1-rc10 to provide a stack dump whenever the 
messages appeared. The "short transfer on control ep" occurs before the 
rtl8192cu device has been plugged and has the following dump, which is probably 
not informative:

[    3.988197] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    3.988208] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-0301rc9-generic 
#201110050905
[    3.988213] Call Trace:
[    3.988225]  [<c135788d>] ? dev_warn+0x2d/0x30
[    3.988238]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
[    3.988249]  [<c1079827>] ? tick_program_event+0x27/0x40
[    3.988261]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[    3.988270]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[    3.988279]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[    3.988286]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[    3.988294]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[    3.988301]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[    3.988305]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[    3.988320]  [<c1542950>] ? notifier_call_chain+0x30/0x60
[    3.988328]  [<c1546970>] ? common_interrupt+0x30/0x38
[    3.988337]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[    3.988345]  [<c12e5524>] ? intel_idle+0xa4/0x100
[    3.988355]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
[    3.988364]  [<c1001c27>] ? cpu_idle+0x97/0xd0
[    3.988368]  [<c1537e16>] ? start_secondary+0xf6/0x110

Just in case it is needed, the full dmesg output is attached.

Due to wrapping of the dmesg buffer, the first few of stack dumps for the "ERROR 
no room on ep ring" messages were lost, but the one I got came from the 
following code fragment in drivers/net/wireless/rtlwifi/usb.c at line 87:

         usb_fill_control_urb(urb, udev, pipe,
                              (unsigned char *)dr, buf, len,
                              usbctrl_async_callback, buf);
         rc = usb_submit_urb(urb, GFP_ATOMIC);

The value of len for this call is 4. The driver only uses 1, 2, or 4 as the 
lengths of writes, at least those that go through usb_submit_urb(). Even the 
firmware download is done one dword at a time.

We also tested with the xHCI code from the current mainline kernel, i.e. 
3.1-git, but I don't have the dmesg output for that version. If you have any 
patches in the pipeline, or anything to test, please send those to me.

Thanks,

Larry


--------------010208060608070507020607
Content-Type: text/x-log;
 name="dmesg1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg1.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.1.0-0301rc9-generic (root@zinc) (gcc version 4.2.3 (Ubuntu 4.2.3-2ubuntu7)) #201110050905 SMP Wed Oct 5 11:20:31 UTC 2011
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   NSC Geode by NSC
[    0.000000]   Cyrix CyrixInstead
[    0.000000]   Centaur CentaurHauls
[    0.000000]   Transmeta GenuineTMx86
[    0.000000]   Transmeta TransmetaCPU
[    0.000000]   UMC UMC UMC UMC
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000ced51000 (usable)
[    0.000000]  BIOS-e820: 00000000ced51000 - 00000000ced9c000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ced9c000 - 00000000ceec0000 (reserved)
[    0.000000]  BIOS-e820: 00000000ceec0000 - 00000000ceed2000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ceed2000 - 00000000ceed4000 (reserved)
[    0.000000]  BIOS-e820: 00000000ceed4000 - 00000000ceed8000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000ceed8000 - 00000000cef09000 (reserved)
[    0.000000]  BIOS-e820: 00000000cef09000 - 00000000cef0a000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cef0a000 - 00000000cef10000 (reserved)
[    0.000000]  BIOS-e820: 00000000cef10000 - 00000000cef12000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cef12000 - 00000000cef15000 (reserved)
[    0.000000]  BIOS-e820: 00000000cef15000 - 00000000cef18000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cef18000 - 00000000cef1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000cef1c000 - 00000000cef2b000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cef2b000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1b000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffa00000 - 00000000ffc00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000230000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection cannot be enabled: non-PAE kernel!
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: Sony Corporation VPCF13C5E/VAIO, BIOS R0190Y9 10/20/2010
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] last_pfn = 0xced51 max_arch_pfn = 0x100000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FF0000000 write-back
[    0.000000]   3 base 100000000 mask F00000000 write-back
[    0.000000]   4 base 200000000 mask FC0000000 write-back
[    0.000000]   5 base 230000000 mask FF0000000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] original variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 4GB, range: 4GB, type WB
[    0.000000] reg 4, base: 8GB, range: 1GB, type WB
[    0.000000] reg 5, base: 8960MB, range: 256MB, type UC
[    0.000000] total RAM covered: 8192M
[    0.000000] Found optimal setting for mtrr clean up
[    0.000000]  gran_size: 64K 	chunk_size: 64K 	num_reg: 6  	lose cover RAM: 0G
[    0.000000] New variable MTRRs
[    0.000000] reg 0, base: 0GB, range: 2GB, type WB
[    0.000000] reg 1, base: 2GB, range: 1GB, type WB
[    0.000000] reg 2, base: 3GB, range: 256MB, type WB
[    0.000000] reg 3, base: 4GB, range: 4GB, type WB
[    0.000000] reg 4, base: 8GB, range: 512MB, type WB
[    0.000000] reg 5, base: 8704MB, range: 256MB, type WB
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00fc9c0] fc9c0
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] RAMDISK: 3655e000 - 372a7000
[    0.000000] ACPI: RSDP 000f0410 00024 (v02   Sony)
[    0.000000] ACPI: XSDT cef16e18 0005C (v01   Sony     VAIO 20101020 MSFT 00010013)
[    0.000000] ACPI: FACP cef10d98 000F4 (v04   Sony     VAIO 20101020 MSFT 00010013)
[    0.000000] ACPI Warning: 32/64 FACS address mismatch in FADT - two FACS tables! (20110623/tbfadt-369)
[    0.000000] ACPI Warning: 32/64X FACS address mismatch in FADT - 0xCEF27F40/0x00000000CEF2AD40, using 32 (20110623/tbfadt-489)
[    0.000000] ACPI: DSDT ceec0018 0BED8 (v01   Sony     VAIO 20101020 INTL 20051117)
[    0.000000] ACPI: FACS cef27f40 00040
[    0.000000] ACPI: APIC cef15f18 0008C (v02   Sony     VAIO 20101020 MSFT 00010013)
[    0.000000] ACPI: MCFG cef29d18 0003C (v01   Sony     VAIO 20101020 MSFT 00000097)
[    0.000000] ACPI: HPET cef29c98 00038 (v01   Sony     VAIO 20101020 MSFT 00000003)
[    0.000000] ACPI: SLIC cef22a18 00176 (v01   Sony     VAIO 20101020 Sony 01000000)
[    0.000000] ACPI: SSDT cef11018 009F1 (v01   Sony     VAIO 20101020 INTL 20051117)
[    0.000000] ACPI: SSDT cef10c18 0011D (v01   Sony     VAIO 20101020 INTL 20051117)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 2421MB HIGHMEM available.
[    0.000000] 887MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 377fe000
[    0.000000]   low ram: 0 - 377fe000
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000377fe
[    0.000000]   HighMem  0x000377fe -> 0x000ced51
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000ced51
[    0.000000] On node 0 totalpages: 847071
[    0.000000] free_area_init_node: node 0, pgdat c17de6c0, node_mem_map f4b7e200
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3950 pages, LIFO batch:0
[    0.000000]   Normal zone: 1744 pages used for memmap
[    0.000000]   Normal zone: 221486 pages, LIFO batch:31
[    0.000000]   HighMem zone: 4843 pages used for memmap
[    0.000000]   HighMem zone: 615016 pages, LIFO batch:31
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x05] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x07] enabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:28000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
[    0.000000] PERCPU: Embedded 13 pages/cpu @f4400000 s30144 r0 d23104 u524288
[    0.000000] pcpu-alloc: s30144 r0 d23104 u524288 alloc=1*4194304
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 840452
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-0301rc9-generic root=UUID=779903b1-47b4-4668-a958-eaf4ed202048 ro quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 13554704 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:000ced51)
[    0.000000] Memory: 3323876k/3388740k available (5405k kernel code, 64408k reserved, 2693k data, 756k init, 2479436k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff16000 - 0xfffff000   ( 932 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc17e9000 - 0xc18a6000   ( 756 kB)
[    0.000000]       .data : 0xc154756f - 0xc17e89c0   (2693 kB)
[    0.000000]       .text : 0xc1000000 - 0xc154756f   (5405 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:2304 nr_irqs:744 16
[    0.000000] CPU 0 irqstacks, hard=f300a000 soft=f300c000
[    0.000000] Extended CMOS year: 2000
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.004000] Detected 1728.761 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3457.52 BogoMIPS (lpj=6915044)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000032] Security Framework initialized
[    0.000046] AppArmor: AppArmor initialized
[    0.000079] Mount-cache hash table entries: 512
[    0.000181] Initializing cgroup subsys cpuacct
[    0.000185] Initializing cgroup subsys memory
[    0.000192] Initializing cgroup subsys devices
[    0.000193] Initializing cgroup subsys freezer
[    0.000195] Initializing cgroup subsys net_cls
[    0.000197] Initializing cgroup subsys blkio
[    0.000201] Initializing cgroup subsys perf_event
[    0.000222] CPU: Physical Processor ID: 0
[    0.000223] CPU: Processor Core ID: 0
[    0.000228] mce: CPU supports 9 MCE banks
[    0.000235] CPU0: Thermal monitoring handled by SMI
[    0.000241] using mwait in idle threads.
[    0.002061] ACPI: Core revision 20110623
[    0.027924] ftrace: allocating 28114 entries in 56 pages
[    0.035348] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.035616] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.075278] CPU0: Intel(R) Core(TM) i7 CPU       Q 740  @ 1.73GHz stepping 05
[    0.180273] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.180279] ... version:                3
[    0.180280] ... bit width:              48
[    0.180281] ... generic registers:      4
[    0.180283] ... value mask:             0000ffffffffffff
[    0.180284] ... max period:             000000007fffffff
[    0.180285] ... fixed-purpose events:   3
[    0.180286] ... event mask:             000000070000000f
[    0.180415] CPU 1 irqstacks, hard=f30ce000 soft=f30d8000
[    0.180417] Booting Node   0, Processors  #1
[    0.180418] smpboot cpu 1: start_ip = 9a000
[    0.202613] Initializing CPU#1
[    0.280251] CPU1: Thermal monitoring handled by SMI
[    0.300409] CPU 2 irqstacks, hard=f30e2000 soft=f30e4000
[    0.300411]  #2
[    0.300412] smpboot cpu 2: start_ip = 9a000
[    0.310675] Initializing CPU#2
[    0.388180] CPU2: Thermal monitoring handled by SMI
[    0.408335] CPU 3 irqstacks, hard=f310e000 soft=f3110000
[    0.408338]  #3
[    0.408339] smpboot cpu 3: start_ip = 9a000
[    0.430877] Initializing CPU#3
[    0.508079] CPU3: Thermal monitoring handled by SMI
[    0.528190] CPU 4 irqstacks, hard=f3122000 soft=f3124000
[    0.528193]  #4
[    0.528194] smpboot cpu 4: start_ip = 9a000
[    0.538340] Initializing CPU#4
[    0.615990] CPU4: Thermal monitoring handled by SMI
[    0.636172] CPU 5 irqstacks, hard=f3142000 soft=f3144000
[    0.636175]  #5
[    0.636176] smpboot cpu 5: start_ip = 9a000
[    0.658345] Initializing CPU#5
[    0.735887] CPU5: Thermal monitoring handled by SMI
[    0.756059] CPU 6 irqstacks, hard=f314e000 soft=f3158000
[    0.756062]  #6
[    0.756064] smpboot cpu 6: start_ip = 9a000
[    0.766215] Initializing CPU#6
[    0.843795] CPU6: Thermal monitoring handled by SMI
[    0.863923] CPU 7 irqstacks, hard=f3180000 soft=f3182000
[    0.863927]  #7 Ok.
[    0.863928] smpboot cpu 7: start_ip = 9a000
[    0.886809] Initializing CPU#7
[    0.963694] CPU7: Thermal monitoring handled by SMI
[    0.983770] Brought up 8 CPUs
[    0.983773] Total of 8 processors activated (27653.50 BogoMIPS).
[    0.989691] devtmpfs: initialized
[    0.989852] PM: Registering ACPI NVS region at ced51000 (307200 bytes)
[    0.989865] PM: Registering ACPI NVS region at ceec0000 (73728 bytes)
[    0.989869] PM: Registering ACPI NVS region at ceed4000 (16384 bytes)
[    0.989871] PM: Registering ACPI NVS region at cef09000 (4096 bytes)
[    0.989874] PM: Registering ACPI NVS region at cef10000 (8192 bytes)
[    0.989876] PM: Registering ACPI NVS region at cef1c000 (61440 bytes)
[    0.991018] print_constraints: dummy: 
[    0.991050] RTC time: 10:39:19, date: 11/01/11
[    0.991091] NET: Registered protocol family 16
[    0.991198] EISA bus registered
[    0.991205] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.991208] ACPI: bus type pci registered
[    0.991277] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.991281] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.991284] PCI: Using MMCONFIG for extended config space
[    0.991286] PCI: Using configuration type 1 for base access
[    0.992339] bio: create slab <bio-0> at 0
[    0.992433] ACPI: Added _OSI(Module Device)
[    0.992435] ACPI: Added _OSI(Processor Device)
[    0.992438] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.992441] ACPI: Added _OSI(Processor Aggregator Device)
[    0.994914] ACPI: EC: Look up EC in DSDT
[    0.997334] ACPI: Executed 1 blocks of module-level executable AML code
[    1.011698] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.012595] ACPI: SSDT cef14a98 0032A (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    1.013210] ACPI: Dynamic OEM Table Load:
[    1.013214] ACPI: SSDT   (null) 0032A (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    1.013397] ACPI: SSDT cef13018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    1.014099] ACPI: Dynamic OEM Table Load:
[    1.014103] ACPI: SSDT   (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    1.036010] ACPI: SSDT cef14718 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    1.036691] ACPI: Dynamic OEM Table Load:
[    1.036695] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    1.047834] ACPI: SSDT cef12d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    1.048464] ACPI: Dynamic OEM Table Load:
[    1.048467] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    1.864199] ACPI: Interpreter enabled
[    1.864207] ACPI: (supports S0 S3 S4 S5)
[    1.864236] ACPI: Using IOAPIC for interrupt routing
[    1.905801] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.906117] ACPI: No dock devices found.
[    1.906120] HEST: Table not found.
[    1.906123] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.906577] \_SB_.PCI0:_OSC invalid UUID
[    1.906579] _OSC request data:1 8 1f 
[    1.906584] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.907281] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.907285] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.907288] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.907291] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    1.907294] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.907297] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.907300] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    1.907303] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    1.907306] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    1.907309] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfeafffff]
[    1.907327] pci 0000:00:00.0: [8086:d132] type 0 class 0x000600
[    1.907384] pci 0000:00:03.0: [8086:d138] type 1 class 0x000604
[    1.907432] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.907436] pci 0000:00:03.0: PME# disabled
[    1.907459] pci 0000:00:08.0: [8086:d155] type 0 class 0x000880
[    1.907521] pci 0000:00:08.1: [8086:d156] type 0 class 0x000880
[    1.907583] pci 0000:00:08.2: [8086:d157] type 0 class 0x000880
[    1.907642] pci 0000:00:08.3: [8086:d158] type 0 class 0x000880
[    1.907811] pci 0000:00:10.0: [8086:d150] type 0 class 0x000880
[    1.907861] pci 0000:00:10.1: [8086:d151] type 0 class 0x000880
[    1.907935] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    1.907959] pci 0000:00:1a.0: reg 10: [mem 0xea208000-0xea2083ff]
[    1.908036] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.908041] pci 0000:00:1a.0: PME# disabled
[    1.908067] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    1.908084] pci 0000:00:1b.0: reg 10: [mem 0xea200000-0xea203fff 64bit]
[    1.908148] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.908153] pci 0000:00:1b.0: PME# disabled
[    1.908174] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    1.908234] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.908239] pci 0000:00:1c.0: PME# disabled
[    1.908261] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    1.908321] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.908325] pci 0000:00:1c.1: PME# disabled
[    1.908348] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
[    1.908407] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.908412] pci 0000:00:1c.2: PME# disabled
[    1.908436] pci 0000:00:1c.5: [8086:3b4c] type 1 class 0x000604
[    1.908496] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.908500] pci 0000:00:1c.5: PME# disabled
[    1.908523] pci 0000:00:1c.6: [8086:3b4e] type 1 class 0x000604
[    1.908582] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.908587] pci 0000:00:1c.6: PME# disabled
[    1.908615] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    1.908638] pci 0000:00:1d.0: reg 10: [mem 0xea207000-0xea2073ff]
[    1.908716] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.908721] pci 0000:00:1d.0: PME# disabled
[    1.908743] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.908804] pci 0000:00:1f.0: [8086:3b03] type 0 class 0x000601
[    1.908924] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    1.908945] pci 0000:00:1f.2: reg 10: [io  0xe070-0xe077]
[    1.908954] pci 0000:00:1f.2: reg 14: [io  0xe060-0xe063]
[    1.908964] pci 0000:00:1f.2: reg 18: [io  0xe050-0xe057]
[    1.908973] pci 0000:00:1f.2: reg 1c: [io  0xe040-0xe043]
[    1.908981] pci 0000:00:1f.2: reg 20: [io  0xe020-0xe03f]
[    1.908991] pci 0000:00:1f.2: reg 24: [mem 0xea206000-0xea2067ff]
[    1.909027] pci 0000:00:1f.2: PME# supported from D3hot
[    1.909031] pci 0000:00:1f.2: PME# disabled
[    1.909049] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    1.909066] pci 0000:00:1f.3: reg 10: [mem 0xea205000-0xea2050ff 64bit]
[    1.909089] pci 0000:00:1f.3: reg 20: [io  0xe000-0xe01f]
[    1.909162] pci 0000:01:00.0: [10de:0df0] type 0 class 0x000300
[    1.909173] pci 0000:01:00.0: reg 10: [mem 0xe2000000-0xe2ffffff]
[    1.909185] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.909197] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.909206] pci 0000:01:00.0: reg 24: [io  0xd000-0xd07f]
[    1.909215] pci 0000:01:00.0: reg 30: [mem 0xe3000000-0xe307ffff pref]
[    1.909260] pci 0000:01:00.1: [10de:0bea] type 0 class 0x000403
[    1.909271] pci 0000:01:00.1: reg 10: [mem 0xe3080000-0xe3083fff]
[    1.909346] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.909350] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.909354] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    1.909420] pci 0000:02:00.0: [168c:002e] type 0 class 0x000280
[    1.909444] pci 0000:02:00.0: reg 10: [mem 0xe8e00000-0xe8e0ffff 64bit]
[    1.909534] pci 0000:02:00.0: supports D1
[    1.909537] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    1.909542] pci 0000:02:00.0: PME# disabled
[    1.909575] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.909580] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.909584] pci 0000:00:1c.0:   bridge window [mem 0xe8e00000-0xea1fffff]
[    1.909683] pci 0000:03:00.0: [1180:e822] type 0 class 0x000805
[    1.909703] pci 0000:03:00.0: reg 10: [mem 0xe7a03000-0xe7a030ff]
[    1.909815] pci 0000:03:00.0: supports D1 D2
[    1.909818] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.909824] pci 0000:03:00.0: PME# disabled
[    1.909868] pci 0000:03:00.1: [1180:e230] type 0 class 0x000880
[    1.909887] pci 0000:03:00.1: reg 10: [mem 0xe7a02000-0xe7a020ff]
[    1.910000] pci 0000:03:00.1: supports D1 D2
[    1.910002] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.910008] pci 0000:03:00.1: PME# disabled
[    1.910049] pci 0000:03:00.3: [1180:e832] type 0 class 0x000c00
[    1.910068] pci 0000:03:00.3: reg 10: [mem 0xe7a01000-0xe7a017ff]
[    1.910181] pci 0000:03:00.3: supports D1 D2
[    1.910183] pci 0000:03:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.910189] pci 0000:03:00.3: PME# disabled
[    1.910228] pci 0000:03:00.4: [1180:e822] type 0 class 0x000805
[    1.910248] pci 0000:03:00.4: reg 10: [mem 0xe7a00000-0xe7a000ff]
[    1.910360] pci 0000:03:00.4: supports D1 D2
[    1.910362] pci 0000:03:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.910368] pci 0000:03:00.4: PME# disabled
[    1.910434] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.910438] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    1.910443] pci 0000:00:1c.1:   bridge window [mem 0xe7a00000-0xe8dfffff]
[    1.910594] pci 0000:04:00.0: [11ab:4380] type 0 class 0x000200
[    1.910704] pci 0000:04:00.0: reg 10: [mem 0xe6620000-0xe6623fff 64bit]
[    1.910769] pci 0000:04:00.0: reg 18: [io  0xa000-0xa0ff]
[    1.910979] pci 0000:04:00.0: reg 30: [mem 0xe6600000-0xe661ffff pref]
[    1.911143] pci 0000:04:00.0: supports D1 D2
[    1.911145] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.911165] pci 0000:04:00.0: PME# disabled
[    1.911292] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    1.911297] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    1.911301] pci 0000:00:1c.2:   bridge window [mem 0xe6600000-0xe79fffff]
[    1.911375] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[    1.911404] pci 0000:05:00.0: reg 10: [mem 0xe5200000-0xe5201fff 64bit]
[    1.911518] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.911524] pci 0000:05:00.0: PME# disabled
[    1.911569] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    1.911574] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    1.911578] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe65fffff]
[    1.911626] pci 0000:00:1c.6: PCI bridge to [bus 06-0d]
[    1.911630] pci 0000:00:1c.6:   bridge window [io  0x8000-0x8fff]
[    1.911635] pci 0000:00:1c.6:   bridge window [mem 0xe3200000-0xe51fffff]
[    1.911708] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    1.911719] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.911722] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.911725] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.911728] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    1.911732] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.911735] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.911738] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    1.911741] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    1.911744] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    1.911747] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfeafffff] (subtractive decode)
[    1.911778] pci_bus 0000:00: on NUMA node 0
[    1.911782] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.912008] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.912081] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.912171] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.912274] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.912348] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
[    1.912396] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    1.912580] \_SB_.PCI0:_OSC invalid UUID
[    1.912582] _OSC request data:1 1f 1f 
[    1.912587]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.912632] \_SB_.PCI0:_OSC invalid UUID
[    1.912634] _OSC request data:1 0 1d 
[    1.912638]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.912641] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.920936] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    1.921012] pci 0000:3f:00.0: [8086:2c52] type 0 class 0x000600
[    1.921037] pci 0000:3f:00.1: [8086:2c81] type 0 class 0x000600
[    1.921062] pci 0000:3f:02.0: [8086:2c90] type 0 class 0x000600
[    1.921087] pci 0000:3f:02.1: [8086:2c91] type 0 class 0x000600
[    1.921111] pci 0000:3f:03.0: [8086:2c98] type 0 class 0x000600
[    1.921133] pci 0000:3f:03.1: [8086:2c99] type 0 class 0x000600
[    1.921156] pci 0000:3f:03.4: [8086:2c9c] type 0 class 0x000600
[    1.921179] pci 0000:3f:04.0: [8086:2ca0] type 0 class 0x000600
[    1.921201] pci 0000:3f:04.1: [8086:2ca1] type 0 class 0x000600
[    1.921223] pci 0000:3f:04.2: [8086:2ca2] type 0 class 0x000600
[    1.921244] pci 0000:3f:04.3: [8086:2ca3] type 0 class 0x000600
[    1.921268] pci 0000:3f:05.0: [8086:2ca8] type 0 class 0x000600
[    1.921290] pci 0000:3f:05.1: [8086:2ca9] type 0 class 0x000600
[    1.921312] pci 0000:3f:05.2: [8086:2caa] type 0 class 0x000600
[    1.921334] pci 0000:3f:05.3: [8086:2cab] type 0 class 0x000600
[    1.921367] pci_bus 0000:3f: on NUMA node 0
[    1.921376]  pci0000:3f: Requesting ACPI _OSC control (0x1d)
[    1.921380]  pci0000:3f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.921382] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.921996] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.922056] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.922113] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 7 10 12 14 15)
[    1.922170] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    1.922227] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    1.922284] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.922342] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.922398] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.922510] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.922524] vgaarb: loaded
[    1.922525] vgaarb: bridge control possible 0000:01:00.0
[    1.922746] SCSI subsystem initialized
[    1.922792] libata version 3.00 loaded.
[    1.922836] usbcore: registered new interface driver usbfs
[    1.922848] usbcore: registered new interface driver hub
[    1.922871] usbcore: registered new device driver usb
[    1.922957] PCI: Using ACPI for IRQ routing
[    1.924558] PCI: pci_cache_line_size set to 64 bytes
[    1.924691] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
[    1.924694] reserve RAM buffer: 00000000ced51000 - 00000000cfffffff 
[    1.924794] NetLabel: Initializing
[    1.924796] NetLabel:  domain hash size = 128
[    1.924798] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.924809] NetLabel:  unlabeled traffic allowed by default
[    1.924878] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    1.924887] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    1.924895] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.928055] hpet: hpet2 irq 40 for MSI
[    1.928202] hpet: hpet3 irq 41 for MSI
[    1.932218] hpet: hpet4 irq 42 for MSI
[    1.936161] hpet: hpet5 irq 43 for MSI
[    1.940210] hpet: hpet6 irq 44 for MSI
[    1.952222] Switching to clocksource hpet
[    1.955365] Switched to NOHz mode on CPU #0
[    1.955500] Switched to NOHz mode on CPU #1
[    1.955692] Switched to NOHz mode on CPU #2
[    1.955695] Switched to NOHz mode on CPU #3
[    1.955810] Switched to NOHz mode on CPU #4
[    1.956112] Switched to NOHz mode on CPU #6
[    1.956148] Switched to NOHz mode on CPU #7
[    1.956160] Switched to NOHz mode on CPU #5
[    1.960001] AppArmor: AppArmor Filesystem Enabled
[    1.960021] pnp: PnP ACPI init
[    1.960033] ACPI: bus type pnp registered
[    1.960412] pnp 00:00: [bus 00-3e]
[    1.960416] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.960418] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.960421] pnp 00:00: [io  0x0d00-0xffff window]
[    1.960424] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.960426] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.960429] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.960431] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.960436] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.960438] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.960441] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.960444] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.960446] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.960449] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.960451] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.960454] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.960456] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.960459] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.960462] pnp 00:00: [mem 0xd0000000-0xfeafffff window]
[    1.960537] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.960554] pnp 00:01: [io  0x0000-0x001f]
[    1.960556] pnp 00:01: [io  0x0081-0x0091]
[    1.960558] pnp 00:01: [io  0x0093-0x009f]
[    1.960560] pnp 00:01: [io  0x00c0-0x00df]
[    1.960563] pnp 00:01: [dma 4]
[    1.960588] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.960598] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.960622] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.960707] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.960734] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.960747] pnp 00:04: [io  0x00f0]
[    1.960755] pnp 00:04: [irq 13]
[    1.960783] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.960796] pnp 00:05: [io  0x002e-0x002f]
[    1.960799] pnp 00:05: [io  0x004e-0x004f]
[    1.960801] pnp 00:05: [io  0x0061]
[    1.960803] pnp 00:05: [io  0x0063]
[    1.960805] pnp 00:05: [io  0x0065]
[    1.960807] pnp 00:05: [io  0x0067]
[    1.960809] pnp 00:05: [io  0x0070]
[    1.960811] pnp 00:05: [io  0x0080]
[    1.960813] pnp 00:05: [io  0x0092]
[    1.960815] pnp 00:05: [io  0x00b2-0x00b3]
[    1.960818] pnp 00:05: [io  0x0680-0x069f]
[    1.960820] pnp 00:05: [io  0xff00-0xff0f]
[    1.960822] pnp 00:05: [io  0xff10-0xff13]
[    1.960825] pnp 00:05: [io  0x0800-0x0803]
[    1.960827] pnp 00:05: [io  0x0400-0x047f]
[    1.960829] pnp 00:05: [io  0x0500-0x057f]
[    1.960831] pnp 00:05: [io  0x164e-0x164f]
[    1.960902] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.960905] system 00:05: [io  0xff00-0xff0f] has been reserved
[    1.960908] system 00:05: [io  0xff10-0xff13] has been reserved
[    1.960911] system 00:05: [io  0x0800-0x0803] has been reserved
[    1.960914] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.960917] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.960920] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.960924] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.960935] pnp 00:06: [io  0x0070-0x0077]
[    1.960941] pnp 00:06: [irq 8]
[    1.960967] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.960979] pnp 00:07: [io  0x0060]
[    1.960981] pnp 00:07: [io  0x0064]
[    1.960987] pnp 00:07: [irq 1]
[    1.961016] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.961029] pnp 00:08: [irq 12]
[    1.961096] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.961561] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    1.961564] pnp 00:09: [mem 0x00000000-0xffffffff disabled]
[    1.961567] pnp 00:09: [mem 0xfed1b000-0xfed1bfff]
[    1.961569] pnp 00:09: [mem 0x00000000-0xffffffff disabled]
[    1.961572] pnp 00:09: [mem 0xf8000000-0xfbffffff]
[    1.961575] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    1.961577] pnp 00:09: [mem 0xfed90000-0xfed8ffff disabled]
[    1.961580] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    1.961582] pnp 00:09: [mem 0xff000000-0xffffffff]
[    1.961584] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    1.961587] pnp 00:09: [mem 0xea20b000-0xea20bfff]
[    1.961693] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.961696] system 00:09: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    1.961699] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.961703] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.961706] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.961709] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    1.961713] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.961716] system 00:09: [mem 0xea20b000-0xea20bfff] has been reserved
[    1.961720] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.961898] pnp 00:0a: [bus 3f]
[    1.961967] pnp 00:0a: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.976761] pnp: PnP ACPI: found 11 devices
[    1.976764] ACPI: ACPI bus type pnp unregistered
[    1.976767] PnPBIOS: Disabled by ACPI PNP
[    2.013567] PCI: max bus depth: 1 pci_try_num: 2
[    2.013625] pci 0000:00:1c.6: BAR 15: assigned [mem 0xea300000-0xea4fffff 64bit pref]
[    2.013633] pci 0000:00:1c.5: BAR 15: assigned [mem 0xea500000-0xea6fffff 64bit pref]
[    2.013641] pci 0000:00:1c.2: BAR 15: assigned [mem 0xea700000-0xea8fffff 64bit pref]
[    2.013649] pci 0000:00:1c.1: BAR 15: assigned [mem 0xea900000-0xeaafffff 64bit pref]
[    2.013657] pci 0000:00:1c.0: BAR 15: assigned [mem 0xeab00000-0xeacfffff 64bit pref]
[    2.013661] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    2.013665] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.013670] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    2.013677] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.013680] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    2.013686] pci 0000:00:1c.0:   bridge window [mem 0xe8e00000-0xea1fffff]
[    2.013691] pci 0000:00:1c.0:   bridge window [mem 0xeab00000-0xeacfffff 64bit pref]
[    2.013698] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.013701] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    2.013707] pci 0000:00:1c.1:   bridge window [mem 0xe7a00000-0xe8dfffff]
[    2.013711] pci 0000:00:1c.1:   bridge window [mem 0xea900000-0xeaafffff 64bit pref]
[    2.013718] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    2.013722] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    2.013727] pci 0000:00:1c.2:   bridge window [mem 0xe6600000-0xe79fffff]
[    2.013732] pci 0000:00:1c.2:   bridge window [mem 0xea700000-0xea8fffff 64bit pref]
[    2.013739] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    2.013742] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    2.013747] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe65fffff]
[    2.013752] pci 0000:00:1c.5:   bridge window [mem 0xea500000-0xea6fffff 64bit pref]
[    2.013759] pci 0000:00:1c.6: PCI bridge to [bus 06-0d]
[    2.013762] pci 0000:00:1c.6:   bridge window [io  0x8000-0x8fff]
[    2.013768] pci 0000:00:1c.6:   bridge window [mem 0xe3200000-0xe51fffff]
[    2.013773] pci 0000:00:1c.6:   bridge window [mem 0xea300000-0xea4fffff 64bit pref]
[    2.013779] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    2.013803] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.013807] pci 0000:00:03.0: setting latency timer to 64
[    2.013814] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.013819] pci 0000:00:1c.0: setting latency timer to 64
[    2.013830] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.013834] pci 0000:00:1c.1: setting latency timer to 64
[    2.013844] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.013849] pci 0000:00:1c.2: setting latency timer to 64
[    2.013856] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.013860] pci 0000:00:1c.5: setting latency timer to 64
[    2.013867] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.013871] pci 0000:00:1c.6: setting latency timer to 64
[    2.013878] pci 0000:00:1e.0: setting latency timer to 64
[    2.013882] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.013885] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.013888] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.013891] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    2.013893] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    2.013896] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    2.013899] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    2.013902] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    2.013904] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    2.013907] pci_bus 0000:00: resource 13 [mem 0xd0000000-0xfeafffff]
[    2.013910] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    2.013913] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xe30fffff]
[    2.013916] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    2.013919] pci_bus 0000:02: resource 1 [mem 0xe8e00000-0xea1fffff]
[    2.013922] pci_bus 0000:02: resource 2 [mem 0xeab00000-0xeacfffff 64bit pref]
[    2.013925] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    2.013927] pci_bus 0000:03: resource 1 [mem 0xe7a00000-0xe8dfffff]
[    2.013930] pci_bus 0000:03: resource 2 [mem 0xea900000-0xeaafffff 64bit pref]
[    2.013933] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
[    2.013936] pci_bus 0000:04: resource 1 [mem 0xe6600000-0xe79fffff]
[    2.013939] pci_bus 0000:04: resource 2 [mem 0xea700000-0xea8fffff 64bit pref]
[    2.013942] pci_bus 0000:05: resource 0 [io  0x9000-0x9fff]
[    2.013944] pci_bus 0000:05: resource 1 [mem 0xe5200000-0xe65fffff]
[    2.013947] pci_bus 0000:05: resource 2 [mem 0xea500000-0xea6fffff 64bit pref]
[    2.013950] pci_bus 0000:06: resource 0 [io  0x8000-0x8fff]
[    2.013953] pci_bus 0000:06: resource 1 [mem 0xe3200000-0xe51fffff]
[    2.013956] pci_bus 0000:06: resource 2 [mem 0xea300000-0xea4fffff 64bit pref]
[    2.013959] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    2.013961] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    2.013964] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    2.013967] pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
[    2.013970] pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
[    2.013972] pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
[    2.013975] pci_bus 0000:0e: resource 10 [mem 0x000dc000-0x000dffff]
[    2.013978] pci_bus 0000:0e: resource 11 [mem 0x000e0000-0x000e3fff]
[    2.013981] pci_bus 0000:0e: resource 12 [mem 0x000e4000-0x000e7fff]
[    2.013984] pci_bus 0000:0e: resource 13 [mem 0xd0000000-0xfeafffff]
[    2.014017] NET: Registered protocol family 2
[    2.014076] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    2.014276] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.015067] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    2.015461] TCP: Hash tables configured (established 131072 bind 65536)
[    2.015464] TCP reno registered
[    2.015467] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.015479] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.015552] NET: Registered protocol family 1
[    2.140112] pci 0000:01:00.0: Boot video device
[    2.140191] PCI: CLS 64 bytes, default 64
[    2.140229] Trying to unpack rootfs image as initramfs...
[    2.567921] Freeing initrd memory: 13604k freed
[    2.571067] audit: initializing netlink socket (disabled)
[    2.571079] type=2000 audit(1320143960.316:1): initialized
[    2.605545] highmem bounce pool size: 64 pages
[    2.605551] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.612852] VFS: Disk quotas dquot_6.5.2
[    2.612923] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.613663] fuse init (API version 7.17)
[    2.613768] msgmni has been set to 1675
[    2.614149] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.614176] io scheduler noop registered
[    2.614178] io scheduler deadline registered
[    2.614193] io scheduler cfq registered (default)
[    2.614597] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.614622] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.614693] intel_idle: MWAIT substates: 0x1120
[    2.614704] intel_idle: v0.4 model 0x1E
[    2.614706] intel_idle: lapic_timer_reliable_states 0x2
[    2.620590] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.628678] ACPI: AC Adapter [ADP1] (on-line)
[    2.628806] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.640745] ACPI: Lid Switch [LID0]
[    2.640793] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.640798] ACPI: Power Button [PWRB]
[    2.640828] ACPI: acpi_idle yielding to intel_idle
[    2.673025] thermal LNXTHERM:00: registered as thermal_zone0
[    2.673028] ACPI: Thermal Zone [TZ00] (58 C)
[    2.688999] thermal LNXTHERM:01: registered as thermal_zone1
[    2.689002] ACPI: Thermal Zone [TZ01] (58 C)
[    2.689015] ERST: Table is not found!
[    2.689028] isapnp: Scanning for PnP cards...
[    2.752776] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.752783] ACPI: Battery Slot [BAT0] (battery present)
[    3.042451] isapnp: No Plug & Play device found
[    3.042510] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    3.132125] Linux agpgart interface v0.103
[    3.133750] brd: module loaded
[    3.134500] loop: module loaded
[    3.134971] Fixed MDIO Bus: probed
[    3.134996] PPP generic driver version 2.4.2
[    3.135041] tun: Universal TUN/TAP device driver, 1.6
[    3.135043] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.135140] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.135157] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.135170] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.135175] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.135219] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.135246] ehci_hcd 0000:00:1a.0: debug port 2
[    3.139151] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.139169] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xea208000
[    3.151643] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.151804] hub 1-0:1.0: USB hub found
[    3.151809] hub 1-0:1.0: 2 ports detected
[    3.151893] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.151905] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.151909] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.151956] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.151981] ehci_hcd 0000:00:1d.0: debug port 2
[    3.155861] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.155877] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xea207000
[    3.171634] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.171784] hub 2-0:1.0: USB hub found
[    3.171788] hub 2-0:1.0: 2 ports detected
[    3.171862] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.171877] uhci_hcd: USB Universal Host Controller Interface driver
[    3.171958] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.176570] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.176577] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.176696] mousedev: PS/2 mouse device common for all mice
[    3.176840] rtc_cmos 00:06: RTC can wake from S4
[    3.176944] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.176971] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    3.177065] device-mapper: uevent: version 1.0.3
[    3.177147] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    3.177185] EISA: Probing bus 0 at eisa.0
[    3.177189] EISA: Cannot allocate resource for mainboard
[    3.177191] Cannot allocate resource for EISA slot 1
[    3.177194] Cannot allocate resource for EISA slot 2
[    3.177195] Cannot allocate resource for EISA slot 3
[    3.177197] Cannot allocate resource for EISA slot 4
[    3.177199] Cannot allocate resource for EISA slot 5
[    3.177201] Cannot allocate resource for EISA slot 6
[    3.177203] Cannot allocate resource for EISA slot 7
[    3.177205] Cannot allocate resource for EISA slot 8
[    3.177207] EISA: Detected 0 cards.
[    3.177218] cpufreq-nforce2: No nForce2 chipset.
[    3.177435] cpuidle: using governor ladder
[    3.177794] cpuidle: using governor menu
[    3.177797] EFI Variables Facility v0.08 2004-May-17
[    3.178086] TCP cubic registered
[    3.178221] NET: Registered protocol family 10
[    3.178826] NET: Registered protocol family 17
[    3.178841] Registering the dns_resolver key type
[    3.178856] Using IPI No-Shortcut mode
[    3.178983] PM: Hibernation image not present or could not be loaded.
[    3.178993] registered taskstats version 1
[    3.198887]   Magic number: 3:297:678
[    3.199274] rtc_cmos 00:06: setting system clock to 2011-11-01 10:39:21 UTC (1320143961)
[    3.202905] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.202910] EDD information not available.
[    3.203662] Freeing unused kernel memory: 756k freed
[    3.203931] Write protecting the kernel text: 5408k
[    3.204134] Write protecting the kernel read-only data: 2276k
[    3.204209] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.222780] udevd[106]: starting version 173
[    3.279759] sdhci: Secure Digital Host Controller Interface driver
[    3.279763] sdhci: Copyright(c) Pierre Ossman
[    3.280219] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 0)
[    3.280240] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.280271] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.280281] sdhci-pci 0000:03:00.0: setting latency timer to 64
[    3.280308] mmc0: no vmmc regulator found
[    3.280350] Registered led device: mmc0::
[    3.280400] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[    3.280415] sdhci-pci 0000:03:00.4: SDHCI controller found [1180:e822] (rev 0)
[    3.280443] sdhci-pci 0000:03:00.4: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    3.280462] sdhci-pci 0000:03:00.4: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.280471] sdhci-pci 0000:03:00.4: setting latency timer to 64
[    3.280493] mmc1: no vmmc regulator found
[    3.280534] Registered led device: mmc1::
[    3.280594] mmc1: SDHCI controller on PCI [0000:03:00.4] using DMA
[    3.281019] sky2: driver version 1.29
[    3.281049] sky2 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.281061] sky2 0000:04:00.0: setting latency timer to 64
[    3.281088] sky2 0000:04:00.0: Yukon-2 UL 2 chip revision 0
[    3.281179] sky2 0000:04:00.0: irq 45 for MSI/MSI-X
[    3.282012] sky2 0000:04:00.0: eth0: addr f0:bf:97:18:b9:90
[    3.282481] firewire_ohci 0000:03:00.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.282490] firewire_ohci 0000:03:00.3: setting latency timer to 64
[    3.283679] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.283697] xhci_hcd 0000:05:00.0: setting latency timer to 64
[    3.283701] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    3.283774] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 3
[    3.283935] xhci_hcd 0000:05:00.0: irq 17, io mem 0xe5200000
[    3.284002] xhci_hcd 0000:05:00.0: irq 46 for MSI/MSI-X
[    3.284009] xhci_hcd 0000:05:00.0: irq 47 for MSI/MSI-X
[    3.284016] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[    3.284023] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[    3.284030] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[    3.284040] xhci_hcd 0000:05:00.0: irq 51 for MSI/MSI-X
[    3.284050] xhci_hcd 0000:05:00.0: irq 52 for MSI/MSI-X
[    3.284060] xhci_hcd 0000:05:00.0: irq 53 for MSI/MSI-X
[    3.284595] xHCI xhci_add_endpoint called for root hub
[    3.284599] xHCI xhci_check_bandwidth called for root hub
[    3.284605] ahci 0000:00:1f.2: version 3.0
[    3.284618] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.284645] hub 3-0:1.0: USB hub found
[    3.284655] hub 3-0:1.0: 2 ports detected
[    3.284669] ahci 0000:00:1f.2: irq 54 for MSI/MSI-X
[    3.284716] ahci: SSS flag set, parallel bus scan disabled
[    3.284752] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x23 impl SATA mode
[    3.284758] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part sxs apst 
[    3.284763] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    3.284769] ahci 0000:00:1f.2: setting latency timer to 64
[    3.284840] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 4
[    3.287345] scsi0 : ahci
[    3.287499] xHCI xhci_add_endpoint called for root hub
[    3.287503] xHCI xhci_check_bandwidth called for root hub
[    3.287548] hub 4-0:1.0: USB hub found
[    3.287563] hub 4-0:1.0: 2 ports detected
[    3.287882] scsi1 : ahci
[    3.288010] scsi2 : ahci
[    3.288520] scsi3 : ahci
[    3.288638] scsi4 : ahci
[    3.288743] scsi5 : ahci
[    3.288984] ata1: SATA max UDMA/133 abar m2048@0xea206000 port 0xea206100 irq 54
[    3.288988] ata2: SATA max UDMA/133 abar m2048@0xea206000 port 0xea206180 irq 54
[    3.288991] ata3: DUMMY
[    3.288992] ata4: DUMMY
[    3.288994] ata5: DUMMY
[    3.288996] ata6: SATA max UDMA/133 abar m2048@0xea206000 port 0xea206380 irq 54
[    3.340009] firewire_ohci 0000:03:00.3: irq 55 for MSI/MSI-X
[    3.340051] firewire_ohci: Added fw-ohci device 0000:03:00.3, OHCI v1.0, 4 IR + 4 IT contexts, quirks 0x1
[    3.463734] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    3.567529] Refined TSC clocksource calibration: 1728.999 MHz.
[    3.567534] Switching to clocksource tsc
[    3.596643] hub 1-1:1.0: USB hub found
[    3.596815] hub 1-1:1.0: 6 ports detected
[    3.611768] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.612691] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    3.613161] ata1.00: ATA-8: Hitachi HTS725050A9A360, PC4OC70X, max UDMA/133
[    3.613170] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.614320] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    3.614733] ata1.00: configured for UDMA/133
[    3.615028] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
[    3.615379] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    3.615584] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.615666] sd 0:0:0:0: [sda] Write Protect is off
[    3.615674] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.615714] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.701422]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    3.703208] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.707600] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    3.839773] firewire_core: created device fw0: GUID 08004603035349c7, S400
[    3.840310] hub 2-1:1.0: USB hub found
[    3.840452] hub 2-1:1.0: 8 ports detected
[    3.935439] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.938182] ata2.00: ATAPI: PIONEER BD-RW   BDR-TD03, 1.00, max UDMA/100
[    3.941082] ata2.00: configured for UDMA/100
[    3.951361] scsi 1:0:0:0: CD-ROM            PIONEER  BD-RW   BDR-TD03 1.00 PQ: 0 ANSI: 5
[    3.951372] usb 3-2: new low speed USB device number 2 using xhci_hcd
[    3.967462] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.967470] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.967731] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.967946] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    3.988197] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    3.988208] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-0301rc9-generic #201110050905
[    3.988213] Call Trace:
[    3.988225]  [<c135788d>] ? dev_warn+0x2d/0x30
[    3.988238]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
[    3.988249]  [<c1079827>] ? tick_program_event+0x27/0x40
[    3.988261]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[    3.988270]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[    3.988279]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[    3.988286]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[    3.988294]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[    3.988301]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[    3.988305]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[    3.988320]  [<c1542950>] ? notifier_call_chain+0x30/0x60
[    3.988328]  [<c1546970>] ? common_interrupt+0x30/0x38
[    3.988337]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[    3.988345]  [<c12e5524>] ? intel_idle+0xa4/0x100
[    3.988355]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
[    3.988364]  [<c1001c27>] ? cpu_idle+0x97/0xd0
[    3.988368]  [<c1537e16>] ? start_secondary+0xf6/0x110
[    3.995193] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[    3.995203] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-0301rc9-generic #201110050905
[    3.995209] Call Trace:
[    3.995218]  [<c135788d>] ? dev_warn+0x2d/0x30
[    3.995231]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
[    3.995240]  [<c1079827>] ? tick_program_event+0x27/0x40
[    3.995252]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[    3.995260]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[    3.995268]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[    3.995275]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[    3.995283]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[    3.995290]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[    3.995294]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[    3.995308]  [<c1542950>] ? notifier_call_chain+0x30/0x60
[    3.995315]  [<c1546970>] ? common_interrupt+0x30/0x38
[    3.995323]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[    3.995330]  [<c12e5524>] ? intel_idle+0xa4/0x100
[    3.995338]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
[    3.995345]  [<c1001c27>] ? cpu_idle+0x97/0xd0
[    3.995352]  [<c1537e16>] ? start_secondary+0xf6/0x110
[    3.996481] usb 3-2: ep 0x81 - rounding interval to 64 microframes, ep desc says 80 microframes
[    4.067784] usb 1-1.2: new high speed USB device number 3 using ehci_hcd
[    4.235523] usb 1-1.6: new full speed USB device number 4 using ehci_hcd
[    4.287434] ata6: SATA link down (SStatus 0 SControl 300)
[    4.300266] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1c.5/0000:05:00.0/usb3/3-2/3-2:1.0/input/input3
[    4.300706] generic-usb 0003:192F:0916.0001: input,hidraw0: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:05:00.0-2/input0
[    4.300751] usbcore: registered new interface driver usbhid
[    4.300756] usbhid: USB HID core driver
[    5.025748] EXT3-fs (sda5): recovery required on readonly filesystem
[    5.025755] EXT3-fs (sda5): write access will be enabled during recovery
[    6.350596] kjournald starting.  Commit interval 5 seconds
[    6.350654] EXT3-fs (sda5): recovery complete
[    6.351026] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    7.493876] init: ureadahead main process (310) terminated with status 5
[    8.338105] Adding 5124696k swap on /dev/sda6.  Priority:-1 extents:1 across:5124696k 
[    8.435858] udevd[351]: starting version 173
[    9.788077] EXT3-fs (sda5): using internal journal
[   10.603733] lp: driver loaded but no devices found
[   10.756249] wmi: Mapper loaded
[   10.847703] sony_laptop: Sony Notebook Control Driver v0.6
[   10.928520] input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/SNY5001:00/input/input4
[   10.928669] input: Sony Vaio Jogdial as /devices/virtual/input/input5
[   10.928977] sony_laptop: brightness ignored, must be controlled by ACPI video driver
[   11.054275] [Firmware Bug]: ACPI(NGFX) defines _DOD but not _DOS
[   11.058147] acpi device:5f: registered as cooling_device8
[   11.061988] acpi device:60: registered as cooling_device9
[   11.062050] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:5e/LNXVIDEO:02/input/input6
[   11.062126] ACPI: Video Device [NGFX] (multi-head: yes  rom: no  post: no)
[   11.085926] EDAC MC: Ver: 2.1.0
[   11.198179] [drm] Initialized drm 1.1.0 20060810
[   11.315026] MXM: GUID detected in BIOS
[   11.315066] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   11.315070] nouveau 0000:01:00.0: setting latency timer to 64
[   11.316161] [drm] nouveau 0000:01:00.0: Detected an NVc0 generation card (0x0c1800a1)
[   11.316163] [drm] nouveau 0000:01:00.0: acceleration disabled by default, pass noaccel=0 to force enable
[   11.319240] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[   11.382571] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   11.382574] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   11.382576] [drm] nouveau 0000:01:00.0: Bios version 70.08.19.00
[   11.382579] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[   11.382581] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[   11.382583] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 010003f3 00010036
[   11.382585] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000000
[   11.382587] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02422362 00020010
[   11.382588] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000
[   11.382591] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[   11.382593] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[   11.382595] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[   11.382597] [drm] nouveau 0000:01:00.0:   2: 0x00002261: type 0x61 idx 2 tag 0x08
[   11.382600] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD2F9
[   11.402739] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD93F
[   11.409724] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEAD4
[   11.409727] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEAD8
[   11.409770] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEBC0
[   11.409772] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEC25
[   11.417951] Linux video capture interface: v2.00
[   11.429601] [drm] nouveau 0000:01:00.0: 0xD273: Condition still not met after 20ms, skipping following opcodes
[   11.448971] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[   11.448977] [drm] nouveau 0000:01:00.0: 0: memory 135MHz core 50MHz shader 101MHz voltage 830mV timing 0
[   11.448982] [drm] nouveau 0000:01:00.0: 1: memory 324MHz core 202MHz shader 405MHz voltage 830mV timing 1
[   11.448987] [drm] nouveau 0000:01:00.0: 3: memory 800MHz core 560MHz shader 1120MHz voltage 900mV timing 2
[   11.450515] Bluetooth: Core ver 2.16
[   11.450534] NET: Registered protocol family 31
[   11.450537] Bluetooth: HCI device and connection manager initialized
[   11.450540] Bluetooth: HCI socket layer initialized
[   11.450543] Bluetooth: L2CAP socket layer initialized
[   11.450550] Bluetooth: SCO socket layer initialized
[   11.455907] [TTM] Zone  kernel: Available graphics memory: 429400 kiB.
[   11.455909] [TTM] Zone highmem: Available graphics memory: 1669118 kiB.
[   11.455911] [TTM] Initializing pool allocator.
[   11.455918] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[   11.458566] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   11.468864] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[   11.470753] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   11.470755] [drm] No driver support for vblank timestamp query.
[   11.490002] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   11.518143] uvcvideo: Found UVC 1.00 device <unnamed> (064e:2100)
[   11.519982] input: UVC Camera (064e:2100) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
[   11.520101] usbcore: registered new interface driver uvcvideo
[   11.520105] USB Video Class driver (1.1.1)
[   11.538879] [drm] nouveau 0000:01:00.0: allocated 1920x1080 fb: 0xc0000, bo f272ea00
[   11.539096] fbcon: nouveaufb (fb0) is primary device
[   11.753533] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:3f:03.0
[   11.753562] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:3f:03.0' (POLLED)
[   11.753566] EDAC i7core: Driver loaded.
[   11.937652] usbcore: registered new interface driver btusb
[   11.965740] psmouse serio1: ID: 73 02 64
[   12.098709] type=1400 audit(1320140370.396:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=541 comm="apparmor_parser"
[   12.098791] type=1400 audit(1320140370.396:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=541 comm="apparmor_parser"
[   12.098853] type=1400 audit(1320140370.396:4): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=542 comm="apparmor_parser"
[   12.098867] type=1400 audit(1320140370.396:5): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=541 comm="apparmor_parser"
[   12.098940] type=1400 audit(1320140370.396:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=542 comm="apparmor_parser"
[   12.099017] type=1400 audit(1320140370.396:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=542 comm="apparmor_parser"
[   12.612162] Console: switching to colour frame buffer device 240x67
[   12.620067] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input8
[   12.624148] fb0: nouveaufb frame buffer device
[   12.624150] drm: registered panic notifier
[   12.624156] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   13.818258] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   13.818310] snd_hda_intel 0000:00:1b.0: irq 56 for MSI/MSI-X
[   13.818336] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   14.283731] hda_codec: ALC275: BIOS auto-probing.
[   14.288410] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   14.288610] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   14.289006] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   14.289009] hda_intel: Disabling MSI
[   14.289034] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   15.338739] HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
[   15.442696] HDMI status: Codec=1 Pin=5 Presence_Detect=0 ELD_Valid=0
[   15.546692] HDMI status: Codec=2 Pin=5 Presence_Detect=0 ELD_Valid=0
[   15.650614] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[   15.699373] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input11
[   15.699468] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input12
[   15.699618] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input13
[   15.699737] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input14
[   18.516126] type=1400 audit(1320140376.816:8): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=989 comm="apparmor_parser"
[   18.518714] ppdev: user-space parallel port driver
[   18.534482] sky2 0000:04:00.0: eth0: enabling interface
[   18.534849] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.568088] type=1400 audit(1320140376.868:9): apparmor="STATUS" operation="profile_load" name="/usr/lib/lightdm/lightdm-guest-session-wrapper" pid=990 comm="apparmor_parser"
[   18.661069] type=1400 audit(1320140376.960:10): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=991 comm="apparmor_parser"
[   18.661229] type=1400 audit(1320140376.964:11): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=991 comm="apparmor_parser"
[   18.661365] type=1400 audit(1320140376.964:12): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=991 comm="apparmor_parser"
[   18.688658] type=1400 audit(1320140376.988:13): apparmor="STATUS" operation="profile_load" name="/usr/sbin/tcpdump" pid=996 comm="apparmor_parser"
[   18.980671] type=1400 audit(1320140377.280:14): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=994 comm="apparmor_parser"
[   18.980884] type=1400 audit(1320140377.280:15): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=994 comm="apparmor_parser"
[   19.126743] type=1400 audit(1320140377.428:16): apparmor="STATUS" operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=995 comm="apparmor_parser"
[   19.126965] type=1400 audit(1320140377.428:17): apparmor="STATUS" operation="profile_load" name="/usr/sbin/cupsd" pid=995 comm="apparmor_parser"
[   23.576913] init: failsafe main process (821) killed by TERM signal
[   23.628744] init: apport pre-start process (1048) terminated with status 1
[   23.638741] init: apport post-stop process (1072) terminated with status 1
[   23.705010] init: gdm main process (1064) killed by TERM signal
[   25.020025] Bluetooth: RFCOMM TTY layer initialized
[   25.020032] Bluetooth: RFCOMM socket layer initialized
[   25.020034] Bluetooth: RFCOMM ver 1.11
[   25.043396] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   25.043399] Bluetooth: BNEP filters: protocol multicast
[   28.346538] init: plymouth-stop pre-start process (1342) terminated with status 1
[   52.083262] CE: hpet increased min_delta_ns to 20113 nsec
[  236.831261] cfg80211: Calling CRDA to update world regulatory domain
[  236.940259] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[  236.940274] ath9k 0000:02:00.0: setting latency timer to 64
[  237.030469] ath: EEPROM regdomain: 0x65
[  237.030474] ath: EEPROM indicates we should expect a direct regpair map
[  237.030481] ath: Country alpha2 being used: 00
[  237.030484] ath: Regpair used: 0x65
[  237.030490] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[  237.030498] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030503] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[  237.030510] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030515] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[  237.030522] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030527] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[  237.030534] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030539] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[  237.030545] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030550] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[  237.030557] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030562] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[  237.030569] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030574] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[  237.030581] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030586] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[  237.030592] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030597] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[  237.030604] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030609] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[  237.030616] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030621] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
[  237.030628] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030633] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
[  237.030639] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  237.030645] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  237.031976] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[  237.049251] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[  237.049254] cfg80211: World regulatory domain updated:
[  237.049255] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  237.049257] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  237.049259] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  237.049261] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  237.049263] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  237.049265] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  237.079898] ieee80211 phy0: Selected rate control algorithm 'ath9k_rate_control'
[  237.081613] Registered led device: ath9k-phy0
[  237.081631] ieee80211 phy0: Atheros AR9287 Rev:2 mem=0xfb760000, irq=16
[  237.144237] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  238.784576] cfg80211: Found new beacon on frequency: 2467 MHz (Ch 12) on phy0
[  240.167441] wlan0: authenticate with 00:17:c2:58:4b:f3 (try 1)
[  240.169453] wlan0: authenticated
[  240.204235] wlan0: associate with 00:17:c2:58:4b:f3 (try 1)
[  240.206805] wlan0: RX AssocResp from 00:17:c2:58:4b:f3 (capab=0x411 status=0 aid=1)
[  240.206812] wlan0: associated
[  240.207322] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  244.551976] usbcore: registered new interface driver rtl8192cu
[  251.046977] wlan0: no IPv6 routers present
[  268.279935] usb 3-1: new high speed USB device number 3 using xhci_hcd
[  268.297957] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  268.297967] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-0301rc9-generic #201110050905
[  268.297973] Call Trace:
[  268.297985]  [<c135788d>] ? dev_warn+0x2d/0x30
[  268.298010]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
[  268.298028]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  268.298038]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  268.298047]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  268.298058]  [<c12c7c63>] ? msi_set_mask_bit+0x23/0x60
[  268.298066]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  268.298073]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  268.298081]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  268.298088]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  268.298092]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  268.298108]  [<c1542950>] ? notifier_call_chain+0x30/0x60
[  268.298115]  [<c1546970>] ? common_interrupt+0x30/0x38
[  268.298124]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[  268.298132]  [<c12e5524>] ? intel_idle+0xa4/0x100
[  268.298142]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
[  268.298149]  [<c1001c27>] ? cpu_idle+0x97/0xd0
[  268.298158]  [<c1537e16>] ? start_secondary+0xf6/0x110
[  268.298581] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  268.298589] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-0301rc9-generic #201110050905
[  268.298593] Call Trace:
[  268.298600]  [<c135788d>] ? dev_warn+0x2d/0x30
[  268.298616]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
[  268.298633]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  268.298641]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  268.298649]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  268.298658]  [<c12c7c63>] ? msi_set_mask_bit+0x23/0x60
[  268.298665]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  268.298672]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  268.298680]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  268.298687]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  268.298691]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  268.298703]  [<c1542950>] ? notifier_call_chain+0x30/0x60
[  268.298711]  [<c1546970>] ? common_interrupt+0x30/0x38
[  268.298719]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[  268.298726]  [<c12e5524>] ? intel_idle+0xa4/0x100
[  268.298734]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
[  268.298740]  [<c1001c27>] ? cpu_idle+0x97/0xd0
[  268.298748]  [<c1537e16>] ? start_secondary+0xf6/0x110
[  268.298949] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  268.298956] Pid: 0, comm: kworker/0:0 Not tainted 3.1.0-0301rc9-generic #201110050905
[  268.298961] Call Trace:
[  268.298968]  [<c135788d>] ? dev_warn+0x2d/0x30
[  268.298986]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
[  268.299003]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  268.299011]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  268.299019]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  268.299028]  [<c12c7c63>] ? msi_set_mask_bit+0x23/0x60
[  268.299035]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  268.299042]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  268.299050]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  268.299057]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  268.299061]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  268.299073]  [<c1542950>] ? notifier_call_chain+0x30/0x60
[  268.299081]  [<c1546970>] ? common_interrupt+0x30/0x38
[  268.299089]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[  268.299096]  [<c12e5524>] ? intel_idle+0xa4/0x100
[  268.299104]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
[  268.299111]  [<c1001c27>] ? cpu_idle+0x97/0xd0
[  268.299118]  [<c1537e16>] ? start_secondary+0xf6/0x110
[  268.299455] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  268.716791] rtl8192cu: MAC address: 00:c0:ca:52:c6:73
[  268.716803] rtl8192cu: Board Type 1
[  268.792248] rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1
[  268.792261] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[  268.792273] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792282] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[  268.792293] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792301] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[  268.792312] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792320] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[  268.792331] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792339] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[  268.792349] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792357] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[  268.792366] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792374] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[  268.792384] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792391] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[  268.792401] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792410] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[  268.792419] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792426] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[  268.792435] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792443] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[  268.792452] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  268.792460] cfg80211: Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  268.792468] cfg80211: Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  268.792476] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  268.792572] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[  268.792833] ieee80211 phy1: Selected rate control algorithm 'rtl_rc'
[  269.002289] rtl8192cu: MAC auto ON okay!

--------------010208060608070507020607--
