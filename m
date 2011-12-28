Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1L1Qat (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 11:30:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46834 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754027Ab1L1Qao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 11:30:44 -0500
Message-ID: <4EFB4429.4090002@lwfinger.net>
Date: Wed, 28 Dec 2011 10:30:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Andiry Xu <andiry.xu@amd.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, v4mp <gaigo88@hotmail.it>
Subject: Re: Question about error from xhci-hcd
References: <4EAC3C5C.5000209@lwfinger.net> <20111030050443.GC4535@xanatos> <4EB01904.10605@lwfinger.net> <4EC0DCD5.2010509@amd.com>
In-Reply-To: <4EC0DCD5.2010509@amd.com>
Content-Type: multipart/mixed;
 boundary="------------060403000704010604000306"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060403000704010604000306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 11/14/2011 03:18 AM, Andiry Xu wrote:
> On 11/02/2011 12:06 AM, Larry Finger wrote:
>> On 10/30/2011 12:04 AM, Sarah Sharp wrote:
>>
>>> The xHCI driver allocates a fixed-size endpoint ring, and only so much
>>> data can fit on it.  If the driver is allocating many URBs or many URBs
>>> with a lot of data, then you will see these messages and the URBs will
>>> fail to be submitted.  Now if neither of those conditions are true, then
>>> it's possible we just have a bug in the xHCI driver.
>>>
>>> There is a patchset in the works to dynamically expand the endpoint
>>> rings, but it's still going through revisions:
>>>
>>> http://marc.info/?l=linux-usb&m=131918645424329&w=2
>>
>> I have a bit more to report. Applying the above patch set did not help.
>>
>> I modified the xHCI driver from 3.1-rc10 to provide a stack dump
>> whenever the messages appeared. The "short transfer on control ep"
>> occurs before the rtl8192cu device has been plugged and has the
>> following dump, which is probably not informative:
>>
>> [    3.988197] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
>> [    3.988208] Pid: 0, comm: kworker/0:0 Not tainted
>> 3.1.0-0301rc9-generic #201110050905
>> [    3.988213] Call Trace:
>> [    3.988225]  [<c135788d>] ? dev_warn+0x2d/0x30
>> [    3.988238]  [<f80852d5>] xhci_irq+0x1035/0x1050 [xhci_hcd]
>> [    3.988249]  [<c1079827>] ? tick_program_event+0x27/0x40
>> [    3.988261]  [<f808531c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
>> [    3.988270]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
>> [    3.988279]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
>> [    3.988286]  [<c10ac73f>] handle_irq_event+0x3f/0x60
>> [    3.988294]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
>> [    3.988301]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
>> [    3.988305]<IRQ>   [<c1546a31>] ? do_IRQ+0x41/0xb0
>> [    3.988320]  [<c1542950>] ? notifier_call_chain+0x30/0x60
>> [    3.988328]  [<c1546970>] ? common_interrupt+0x30/0x38
>> [    3.988337]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
>> [    3.988345]  [<c12e5524>] ? intel_idle+0xa4/0x100
>> [    3.988355]  [<c142833c>] ? cpuidle_idle_call+0xac/0x160
>> [    3.988364]  [<c1001c27>] ? cpu_idle+0x97/0xd0
>> [    3.988368]  [<c1537e16>] ? start_secondary+0xf6/0x110
>>
>> Just in case it is needed, the full dmesg output is attached.
>>
>> Due to wrapping of the dmesg buffer, the first few of stack dumps for
>> the "ERROR no room on ep ring" messages were lost, but the one I got
>> came from the following code fragment in
>> drivers/net/wireless/rtlwifi/usb.c at line 87:
>>
>>          usb_fill_control_urb(urb, udev, pipe,
>>                               (unsigned char *)dr, buf, len,
>>                               usbctrl_async_callback, buf);
>>          rc = usb_submit_urb(urb, GFP_ATOMIC);
>>
>> The value of len for this call is 4. The driver only uses 1, 2, or 4 as
>> the lengths of writes, at least those that go through usb_submit_urb().
>> Even the firmware download is done one dword at a time.
>>
>> We also tested with the xHCI code from the current mainline kernel, i.e.
>> 3.1-git, but I don't have the dmesg output for that version. If you have
>> any patches in the pipeline, or anything to test, please send those to me.
>>
>
> A control transfer ring should not be full. Only isoc and bulk transfer
> will cause ring full with a lot of TDs submitted simultaneously. I
> suspect the ring is mangled.
>
> Please apply the patch attached, enable CONFIG_USB_DEBUG and
> CONFIG_USB_XHCI_HCD_DEBUGGING and post the dmesg with the "no room on ep
> ring" error.

Sorry to take so long to get this diagnostic info to you.

Attached is a dmesg output. There is one of the short transfer messages at 
216.57+ seconds.

Thanks for looking at this.

Larry


--------------060403000704010604000306
Content-Type: text/plain;
 name="composit_dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="composit_dmesg"

[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] found SMP MP-table at [c00fc9c0] fc9c0
[    0.000000] initial memory mapped : 0 - 01c00000
[    0.000000] Base memory trampoline at [c009a000] 9a000 size 16384
[    0.000000] init_memory_mapping: 0000000000000000-00000000377fe000
[    0.000000]  0000000000 - 0000400000 page 4k
[    0.000000]  0000400000 - 0037400000 page 2M
[    0.000000]  0037400000 - 00377fe000 page 4k
[    0.000000] kernel direct mapping tables up to 377fe000 @ 1bfb000-1c00000
[    0.000000] RAMDISK: 36558000 - 372a4000
[    0.000000] Reserving 128MB of memory at 384MB for crashkernel (System RAM: 3309MB)
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
[    0.000000] free_area_init_node: node 0, pgdat c17de6c0, node_mem_map f4b78200
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
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.1.0-0301rc9-generic root=UUID=779903b1-47b4-4668-a958-eaf4ed202048 ro crashkernel=384M-2G:64M,2G-:128M quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] allocated 13554704 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:000ced51)
[    0.000000] Memory: 3192792k/3388740k available (5405k kernel code, 195492k reserved, 2693k data, 756k init, 2479436k highmem)
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
[    0.004000] Detected 1728.982 MHz processor.
[    0.000002] Calibrating delay loop (skipped), value calculated using timer frequency.. 3457.96 BogoMIPS (lpj=6915928)
[    0.000007] pid_max: default: 32768 minimum: 301
[    0.000035] Security Framework initialized
[    0.000053] AppArmor: AppArmor initialized
[    0.000085] Mount-cache hash table entries: 512
[    0.000188] Initializing cgroup subsys cpuacct
[    0.000192] Initializing cgroup subsys memory
[    0.000199] Initializing cgroup subsys devices
[    0.000200] Initializing cgroup subsys freezer
[    0.000202] Initializing cgroup subsys net_cls
[    0.000203] Initializing cgroup subsys blkio
[    0.000208] Initializing cgroup subsys perf_event
[    0.000229] CPU: Physical Processor ID: 0
[    0.000230] CPU: Processor Core ID: 0
[    0.000235] mce: CPU supports 9 MCE banks
[    0.000385] CPU0: Thermal monitoring handled by SMI
[    0.000398] using mwait in idle threads.
[    0.002180] ACPI: Core revision 20110623
[    0.024967] ftrace: allocating 28114 entries in 56 pages
[    0.032316] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.032586] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=0 pin2=0
[    0.072544] CPU0: Intel(R) Core(TM) i7 CPU       Q 740  @ 1.73GHz stepping 05
[    0.180170] Performance Events: PEBS fmt1+, erratum AAJ80 worked around, Nehalem events, Intel PMU driver.
[    0.180176] ... version:                3
[    0.180177] ... bit width:              48
[    0.180178] ... generic registers:      4
[    0.180180] ... value mask:             0000ffffffffffff
[    0.180181] ... max period:             000000007fffffff
[    0.180182] ... fixed-purpose events:   3
[    0.180183] ... event mask:             000000070000000f
[    0.180312] CPU 1 irqstacks, hard=f30ce000 soft=f30d8000
[    0.180314] Booting Node   0, Processors  #1
[    0.180316] smpboot cpu 1: start_ip = 9a000
[    0.203219] Initializing CPU#1
[    0.280148] CPU1: Thermal monitoring handled by SMI
[    0.300328] CPU 2 irqstacks, hard=f30e2000 soft=f30e4000
[    0.300330]  #2
[    0.300332] smpboot cpu 2: start_ip = 9a000
[    0.310583] Initializing CPU#2
[    0.388077] CPU2: Thermal monitoring handled by SMI
[    0.408181] CPU 3 irqstacks, hard=f310e000 soft=f3110000
[    0.408184]  #3
[    0.408186] smpboot cpu 3: start_ip = 9a000
[    0.430742] Initializing CPU#3
[    0.507976] CPU3: Thermal monitoring handled by SMI
[    0.528151] CPU 4 irqstacks, hard=f3122000 soft=f3124000
[    0.528154]  #4
[    0.528156] smpboot cpu 4: start_ip = 9a000
[    0.538305] Initializing CPU#4
[    0.615886] CPU4: Thermal monitoring handled by SMI
[    0.636044] CPU 5 irqstacks, hard=f3142000 soft=f3144000
[    0.636047]  #5
[    0.636048] smpboot cpu 5: start_ip = 9a000
[    0.658446] Initializing CPU#5
[    0.735783] CPU5: Thermal monitoring handled by SMI
[    0.755950] CPU 6 irqstacks, hard=f314e000 soft=f3158000
[    0.755953]  #6
[    0.755954] smpboot cpu 6: start_ip = 9a000
[    0.766107] Initializing CPU#6
[    0.843692] CPU6: Thermal monitoring handled by SMI
[    0.863815] CPU 7 irqstacks, hard=f3180000 soft=f3182000
[    0.863818]  #7 Ok.
[    0.863819] smpboot cpu 7: start_ip = 9a000
[    0.886125] Initializing CPU#7
[    0.963591] CPU7: Thermal monitoring handled by SMI
[    0.983639] Brought up 8 CPUs
[    0.983642] Total of 8 processors activated (27653.95 BogoMIPS).
[    0.989557] devtmpfs: initialized
[    0.989718] PM: Registering ACPI NVS region at ced51000 (307200 bytes)
[    0.989731] PM: Registering ACPI NVS region at ceec0000 (73728 bytes)
[    0.989735] PM: Registering ACPI NVS region at ceed4000 (16384 bytes)
[    0.989737] PM: Registering ACPI NVS region at cef09000 (4096 bytes)
[    0.989740] PM: Registering ACPI NVS region at cef10000 (8192 bytes)
[    0.989742] PM: Registering ACPI NVS region at cef1c000 (61440 bytes)
[    0.990885] print_constraints: dummy: 
[    0.990917] RTC time: 12:16:25, date: 12/28/11
[    0.990957] NET: Registered protocol family 16
[    0.991064] EISA bus registered
[    0.991071] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.991074] ACPI: bus type pci registered
[    0.991143] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.991148] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.991150] PCI: Using MMCONFIG for extended config space
[    0.991152] PCI: Using configuration type 1 for base access
[    0.992204] bio: create slab <bio-0> at 0
[    0.992297] ACPI: Added _OSI(Module Device)
[    0.992300] ACPI: Added _OSI(Processor Device)
[    0.992303] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.992305] ACPI: Added _OSI(Processor Aggregator Device)
[    0.994787] ACPI: EC: Look up EC in DSDT
[    0.997323] ACPI: Executed 1 blocks of module-level executable AML code
[    1.011593] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.012486] ACPI: SSDT cef14a98 0032A (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    1.013215] ACPI: Dynamic OEM Table Load:
[    1.013219] ACPI: SSDT   (null) 0032A (v01  PmRef  Cpu0Ist 00003000 INTL 20051117)
[    1.013404] ACPI: SSDT cef13018 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    1.013994] ACPI: Dynamic OEM Table Load:
[    1.013998] ACPI: SSDT   (null) 00891 (v01  PmRef  Cpu0Cst 00003001 INTL 20051117)
[    1.035905] ACPI: SSDT cef14718 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    1.036587] ACPI: Dynamic OEM Table Load:
[    1.036591] ACPI: SSDT   (null) 00303 (v01  PmRef    ApIst 00003000 INTL 20051117)
[    1.047719] ACPI: SSDT cef12d98 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    1.048348] ACPI: Dynamic OEM Table Load:
[    1.048352] ACPI: SSDT   (null) 00119 (v01  PmRef    ApCst 00003000 INTL 20051117)
[    1.864084] ACPI: Interpreter enabled
[    1.864092] ACPI: (supports S0 S3 S4 S5)
[    1.864120] ACPI: Using IOAPIC for interrupt routing
[    1.905088] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.905404] ACPI: No dock devices found.
[    1.905406] HEST: Table not found.
[    1.905410] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    1.905863] \_SB_.PCI0:_OSC invalid UUID
[    1.905865] _OSC request data:1 8 1f 
[    1.905870] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.906567] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.906571] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.906574] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    1.906577] pci_root PNP0A08:00: host bridge window [mem 0x000d0000-0x000d3fff]
[    1.906580] pci_root PNP0A08:00: host bridge window [mem 0x000d4000-0x000d7fff]
[    1.906583] pci_root PNP0A08:00: host bridge window [mem 0x000d8000-0x000dbfff]
[    1.906586] pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
[    1.906589] pci_root PNP0A08:00: host bridge window [mem 0x000e0000-0x000e3fff]
[    1.906592] pci_root PNP0A08:00: host bridge window [mem 0x000e4000-0x000e7fff]
[    1.906595] pci_root PNP0A08:00: host bridge window [mem 0xd0000000-0xfeafffff]
[    1.906613] pci 0000:00:00.0: [8086:d132] type 0 class 0x000600
[    1.906670] pci 0000:00:03.0: [8086:d138] type 1 class 0x000604
[    1.906718] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    1.906722] pci 0000:00:03.0: PME# disabled
[    1.906745] pci 0000:00:08.0: [8086:d155] type 0 class 0x000880
[    1.906807] pci 0000:00:08.1: [8086:d156] type 0 class 0x000880
[    1.906868] pci 0000:00:08.2: [8086:d157] type 0 class 0x000880
[    1.906927] pci 0000:00:08.3: [8086:d158] type 0 class 0x000880
[    1.906986] pci 0000:00:10.0: [8086:d150] type 0 class 0x000880
[    1.907036] pci 0000:00:10.1: [8086:d151] type 0 class 0x000880
[    1.907110] pci 0000:00:1a.0: [8086:3b3c] type 0 class 0x000c03
[    1.907133] pci 0000:00:1a.0: reg 10: [mem 0xea208000-0xea2083ff]
[    1.907211] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    1.907216] pci 0000:00:1a.0: PME# disabled
[    1.907242] pci 0000:00:1b.0: [8086:3b56] type 0 class 0x000403
[    1.907259] pci 0000:00:1b.0: reg 10: [mem 0xea200000-0xea203fff 64bit]
[    1.907317] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    1.907322] pci 0000:00:1b.0: PME# disabled
[    1.907343] pci 0000:00:1c.0: [8086:3b42] type 1 class 0x000604
[    1.907403] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    1.907408] pci 0000:00:1c.0: PME# disabled
[    1.907430] pci 0000:00:1c.1: [8086:3b44] type 1 class 0x000604
[    1.907490] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    1.907494] pci 0000:00:1c.1: PME# disabled
[    1.907516] pci 0000:00:1c.2: [8086:3b46] type 1 class 0x000604
[    1.907576] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    1.907580] pci 0000:00:1c.2: PME# disabled
[    1.907716] pci 0000:00:1c.5: [8086:3b4c] type 1 class 0x000604
[    1.907776] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    1.907780] pci 0000:00:1c.5: PME# disabled
[    1.907803] pci 0000:00:1c.6: [8086:3b4e] type 1 class 0x000604
[    1.907863] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    1.907867] pci 0000:00:1c.6: PME# disabled
[    1.907896] pci 0000:00:1d.0: [8086:3b34] type 0 class 0x000c03
[    1.907919] pci 0000:00:1d.0: reg 10: [mem 0xea207000-0xea2073ff]
[    1.908001] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    1.908006] pci 0000:00:1d.0: PME# disabled
[    1.908028] pci 0000:00:1e.0: [8086:2448] type 1 class 0x000604
[    1.908089] pci 0000:00:1f.0: [8086:3b03] type 0 class 0x000601
[    1.908209] pci 0000:00:1f.2: [8086:3b2f] type 0 class 0x000106
[    1.908230] pci 0000:00:1f.2: reg 10: [io  0xe070-0xe077]
[    1.908239] pci 0000:00:1f.2: reg 14: [io  0xe060-0xe063]
[    1.908248] pci 0000:00:1f.2: reg 18: [io  0xe050-0xe057]
[    1.908257] pci 0000:00:1f.2: reg 1c: [io  0xe040-0xe043]
[    1.908266] pci 0000:00:1f.2: reg 20: [io  0xe020-0xe03f]
[    1.908276] pci 0000:00:1f.2: reg 24: [mem 0xea206000-0xea2067ff]
[    1.908312] pci 0000:00:1f.2: PME# supported from D3hot
[    1.908316] pci 0000:00:1f.2: PME# disabled
[    1.908334] pci 0000:00:1f.3: [8086:3b30] type 0 class 0x000c05
[    1.908351] pci 0000:00:1f.3: reg 10: [mem 0xea205000-0xea2050ff 64bit]
[    1.908374] pci 0000:00:1f.3: reg 20: [io  0xe000-0xe01f]
[    1.908447] pci 0000:01:00.0: [10de:0df0] type 0 class 0x000300
[    1.908459] pci 0000:01:00.0: reg 10: [mem 0xe2000000-0xe2ffffff]
[    1.908471] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xdfffffff 64bit pref]
[    1.908483] pci 0000:01:00.0: reg 1c: [mem 0xe0000000-0xe1ffffff 64bit pref]
[    1.908492] pci 0000:01:00.0: reg 24: [io  0xd000-0xd07f]
[    1.908501] pci 0000:01:00.0: reg 30: [mem 0xe3000000-0xe307ffff pref]
[    1.908546] pci 0000:01:00.1: [10de:0bea] type 0 class 0x000403
[    1.908557] pci 0000:01:00.1: reg 10: [mem 0xe3080000-0xe3083fff]
[    1.908632] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    1.908636] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    1.908640] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    1.908706] pci 0000:02:00.0: [168c:002e] type 0 class 0x000280
[    1.908730] pci 0000:02:00.0: reg 10: [mem 0xe8e00000-0xe8e0ffff 64bit]
[    1.908820] pci 0000:02:00.0: supports D1
[    1.908822] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    1.908827] pci 0000:02:00.0: PME# disabled
[    1.908861] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    1.908865] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    1.908870] pci 0000:00:1c.0:   bridge window [mem 0xe8e00000-0xea1fffff]
[    1.908969] pci 0000:03:00.0: [1180:e822] type 0 class 0x000805
[    1.908989] pci 0000:03:00.0: reg 10: [mem 0xe7a03000-0xe7a030ff]
[    1.909101] pci 0000:03:00.0: supports D1 D2
[    1.909104] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.909109] pci 0000:03:00.0: PME# disabled
[    1.909154] pci 0000:03:00.1: [1180:e230] type 0 class 0x000880
[    1.909173] pci 0000:03:00.1: reg 10: [mem 0xe7a02000-0xe7a020ff]
[    1.909286] pci 0000:03:00.1: supports D1 D2
[    1.909288] pci 0000:03:00.1: PME# supported from D0 D1 D2 D3hot D3cold
[    1.909294] pci 0000:03:00.1: PME# disabled
[    1.909335] pci 0000:03:00.3: [1180:e832] type 0 class 0x000c00
[    1.909355] pci 0000:03:00.3: reg 10: [mem 0xe7a01000-0xe7a017ff]
[    1.909467] pci 0000:03:00.3: supports D1 D2
[    1.909470] pci 0000:03:00.3: PME# supported from D0 D1 D2 D3hot D3cold
[    1.909476] pci 0000:03:00.3: PME# disabled
[    1.909515] pci 0000:03:00.4: [1180:e822] type 0 class 0x000805
[    1.909535] pci 0000:03:00.4: reg 10: [mem 0xe7a00000-0xe7a000ff]
[    1.909647] pci 0000:03:00.4: supports D1 D2
[    1.909650] pci 0000:03:00.4: PME# supported from D0 D1 D2 D3hot D3cold
[    1.909655] pci 0000:03:00.4: PME# disabled
[    1.909722] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    1.909726] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    1.909731] pci 0000:00:1c.1:   bridge window [mem 0xe7a00000-0xe8dfffff]
[    1.909872] pci 0000:04:00.0: [11ab:4380] type 0 class 0x000200
[    1.909977] pci 0000:04:00.0: reg 10: [mem 0xe6620000-0xe6623fff 64bit]
[    1.910036] pci 0000:04:00.0: reg 18: [io  0xa000-0xa0ff]
[    1.910242] pci 0000:04:00.0: reg 30: [mem 0xe6600000-0xe661ffff pref]
[    1.910405] pci 0000:04:00.0: supports D1 D2
[    1.910408] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    1.910427] pci 0000:04:00.0: PME# disabled
[    1.910555] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    1.910559] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    1.910564] pci 0000:00:1c.2:   bridge window [mem 0xe6600000-0xe79fffff]
[    1.910637] pci 0000:05:00.0: [1033:0194] type 0 class 0x000c03
[    1.910667] pci 0000:05:00.0: reg 10: [mem 0xe5200000-0xe5201fff 64bit]
[    1.910781] pci 0000:05:00.0: PME# supported from D0 D3hot D3cold
[    1.910787] pci 0000:05:00.0: PME# disabled
[    1.910832] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    1.910836] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    1.910841] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe65fffff]
[    1.910888] pci 0000:00:1c.6: PCI bridge to [bus 06-0d]
[    1.910893] pci 0000:00:1c.6:   bridge window [io  0x8000-0x8fff]
[    1.910897] pci 0000:00:1c.6:   bridge window [mem 0xe3200000-0xe51fffff]
[    1.910971] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e] (subtractive decode)
[    1.910982] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    1.910985] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    1.910988] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    1.910991] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000d3fff] (subtractive decode)
[    1.910994] pci 0000:00:1e.0:   bridge window [mem 0x000d4000-0x000d7fff] (subtractive decode)
[    1.910997] pci 0000:00:1e.0:   bridge window [mem 0x000d8000-0x000dbfff] (subtractive decode)
[    1.911001] pci 0000:00:1e.0:   bridge window [mem 0x000dc000-0x000dffff] (subtractive decode)
[    1.911004] pci 0000:00:1e.0:   bridge window [mem 0x000e0000-0x000e3fff] (subtractive decode)
[    1.911007] pci 0000:00:1e.0:   bridge window [mem 0x000e4000-0x000e7fff] (subtractive decode)
[    1.911010] pci 0000:00:1e.0:   bridge window [mem 0xd0000000-0xfeafffff] (subtractive decode)
[    1.911041] pci_bus 0000:00: on NUMA node 0
[    1.911044] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.911270] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.911343] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.911427] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.911529] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    1.911602] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP07._PRT]
[    1.911650] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG3._PRT]
[    1.911834] \_SB_.PCI0:_OSC invalid UUID
[    1.911836] _OSC request data:1 1f 1f 
[    1.911842]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    1.911886] \_SB_.PCI0:_OSC invalid UUID
[    1.911888] _OSC request data:1 0 1d 
[    1.911893]  pci0000:00: ACPI _OSC request failed (AE_ERROR), returned control mask: 0x1d
[    1.911895] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.920206] ACPI: PCI Root Bridge [CPBG] (domain 0000 [bus 3f])
[    1.920281] pci 0000:3f:00.0: [8086:2c52] type 0 class 0x000600
[    1.920306] pci 0000:3f:00.1: [8086:2c81] type 0 class 0x000600
[    1.920332] pci 0000:3f:02.0: [8086:2c90] type 0 class 0x000600
[    1.920356] pci 0000:3f:02.1: [8086:2c91] type 0 class 0x000600
[    1.920381] pci 0000:3f:03.0: [8086:2c98] type 0 class 0x000600
[    1.920403] pci 0000:3f:03.1: [8086:2c99] type 0 class 0x000600
[    1.920425] pci 0000:3f:03.4: [8086:2c9c] type 0 class 0x000600
[    1.920449] pci 0000:3f:04.0: [8086:2ca0] type 0 class 0x000600
[    1.920471] pci 0000:3f:04.1: [8086:2ca1] type 0 class 0x000600
[    1.920492] pci 0000:3f:04.2: [8086:2ca2] type 0 class 0x000600
[    1.920514] pci 0000:3f:04.3: [8086:2ca3] type 0 class 0x000600
[    1.920538] pci 0000:3f:05.0: [8086:2ca8] type 0 class 0x000600
[    1.920560] pci 0000:3f:05.1: [8086:2ca9] type 0 class 0x000600
[    1.920581] pci 0000:3f:05.2: [8086:2caa] type 0 class 0x000600
[    1.920603] pci 0000:3f:05.3: [8086:2cab] type 0 class 0x000600
[    1.920637] pci_bus 0000:3f: on NUMA node 0
[    1.920646]  pci0000:3f: Requesting ACPI _OSC control (0x1d)
[    1.920650]  pci0000:3f: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    1.920652] ACPI _OSC control for PCIe not granted, disabling ASPM
[    1.921265] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
[    1.921325] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    1.921383] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 *4 5 6 7 10 12 14 15)
[    1.921439] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    1.921496] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    1.921554] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    1.921612] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 *3 4 5 6 7 10 12 14 15)
[    1.921668] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.921781] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    1.921794] vgaarb: loaded
[    1.921796] vgaarb: bridge control possible 0000:01:00.0
[    1.922017] SCSI subsystem initialized
[    1.922063] libata version 3.00 loaded.
[    1.922107] usbcore: registered new interface driver usbfs
[    1.922119] usbcore: registered new interface driver hub
[    1.922142] usbcore: registered new device driver usb
[    1.922228] PCI: Using ACPI for IRQ routing
[    1.923825] PCI: pci_cache_line_size set to 64 bytes
[    1.923959] reserve RAM buffer: 000000000009e800 - 000000000009ffff 
[    1.923962] reserve RAM buffer: 00000000ced51000 - 00000000cfffffff 
[    1.924065] NetLabel: Initializing
[    1.924067] NetLabel:  domain hash size = 128
[    1.924069] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.924080] NetLabel:  unlabeled traffic allowed by default
[    1.924150] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    1.924158] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 40, 41, 42, 43, 44, 0
[    1.924166] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    1.927866] hpet: hpet2 irq 40 for MSI
[    1.928059] hpet: hpet3 irq 41 for MSI
[    1.931988] hpet: hpet4 irq 42 for MSI
[    1.936036] hpet: hpet5 irq 43 for MSI
[    1.940020] hpet: hpet6 irq 44 for MSI
[    1.952021] Switching to clocksource hpet
[    1.955286] Switched to NOHz mode on CPU #0
[    1.955352] Switched to NOHz mode on CPU #1
[    1.955384] Switched to NOHz mode on CPU #2
[    1.955644] Switched to NOHz mode on CPU #4
[    1.955646] Switched to NOHz mode on CPU #3
[    1.955928] Switched to NOHz mode on CPU #6
[    1.955939] Switched to NOHz mode on CPU #7
[    1.955973] Switched to NOHz mode on CPU #5
[    1.959800] AppArmor: AppArmor Filesystem Enabled
[    1.959820] pnp: PnP ACPI init
[    1.959832] ACPI: bus type pnp registered
[    1.960213] pnp 00:00: [bus 00-3e]
[    1.960217] pnp 00:00: [io  0x0000-0x0cf7 window]
[    1.960220] pnp 00:00: [io  0x0cf8-0x0cff]
[    1.960222] pnp 00:00: [io  0x0d00-0xffff window]
[    1.960225] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    1.960227] pnp 00:00: [mem 0x000c0000-0x000c3fff window]
[    1.960230] pnp 00:00: [mem 0x000c4000-0x000c7fff window]
[    1.960233] pnp 00:00: [mem 0x000c8000-0x000cbfff window]
[    1.960237] pnp 00:00: [mem 0x000cc000-0x000cffff window]
[    1.960240] pnp 00:00: [mem 0x000d0000-0x000d3fff window]
[    1.960242] pnp 00:00: [mem 0x000d4000-0x000d7fff window]
[    1.960245] pnp 00:00: [mem 0x000d8000-0x000dbfff window]
[    1.960247] pnp 00:00: [mem 0x000dc000-0x000dffff window]
[    1.960250] pnp 00:00: [mem 0x000e0000-0x000e3fff window]
[    1.960252] pnp 00:00: [mem 0x000e4000-0x000e7fff window]
[    1.960255] pnp 00:00: [mem 0x000e8000-0x000ebfff window]
[    1.960258] pnp 00:00: [mem 0x000ec000-0x000effff window]
[    1.960260] pnp 00:00: [mem 0x000f0000-0x000fffff window]
[    1.960263] pnp 00:00: [mem 0xd0000000-0xfeafffff window]
[    1.960338] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    1.960354] pnp 00:01: [io  0x0000-0x001f]
[    1.960357] pnp 00:01: [io  0x0081-0x0091]
[    1.960359] pnp 00:01: [io  0x0093-0x009f]
[    1.960361] pnp 00:01: [io  0x00c0-0x00df]
[    1.960364] pnp 00:01: [dma 4]
[    1.960388] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    1.960398] pnp 00:02: [mem 0xff000000-0xffffffff]
[    1.960423] pnp 00:02: Plug and Play ACPI device, IDs INT0800 (active)
[    1.960508] pnp 00:03: [mem 0xfed00000-0xfed003ff]
[    1.960535] pnp 00:03: Plug and Play ACPI device, IDs PNP0103 (active)
[    1.960547] pnp 00:04: [io  0x00f0]
[    1.960555] pnp 00:04: [irq 13]
[    1.960583] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    1.960596] pnp 00:05: [io  0x002e-0x002f]
[    1.960599] pnp 00:05: [io  0x004e-0x004f]
[    1.960601] pnp 00:05: [io  0x0061]
[    1.960603] pnp 00:05: [io  0x0063]
[    1.960605] pnp 00:05: [io  0x0065]
[    1.960607] pnp 00:05: [io  0x0067]
[    1.960609] pnp 00:05: [io  0x0070]
[    1.960611] pnp 00:05: [io  0x0080]
[    1.960613] pnp 00:05: [io  0x0092]
[    1.960615] pnp 00:05: [io  0x00b2-0x00b3]
[    1.960618] pnp 00:05: [io  0x0680-0x069f]
[    1.960620] pnp 00:05: [io  0xff00-0xff0f]
[    1.960622] pnp 00:05: [io  0xff10-0xff13]
[    1.960624] pnp 00:05: [io  0x0800-0x0803]
[    1.960627] pnp 00:05: [io  0x0400-0x047f]
[    1.960629] pnp 00:05: [io  0x0500-0x057f]
[    1.960631] pnp 00:05: [io  0x164e-0x164f]
[    1.960702] system 00:05: [io  0x0680-0x069f] has been reserved
[    1.960705] system 00:05: [io  0xff00-0xff0f] has been reserved
[    1.960708] system 00:05: [io  0xff10-0xff13] has been reserved
[    1.960711] system 00:05: [io  0x0800-0x0803] has been reserved
[    1.960714] system 00:05: [io  0x0400-0x047f] has been reserved
[    1.960717] system 00:05: [io  0x0500-0x057f] has been reserved
[    1.960720] system 00:05: [io  0x164e-0x164f] has been reserved
[    1.960724] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.960734] pnp 00:06: [io  0x0070-0x0077]
[    1.960741] pnp 00:06: [irq 8]
[    1.960767] pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.960779] pnp 00:07: [io  0x0060]
[    1.960781] pnp 00:07: [io  0x0064]
[    1.960787] pnp 00:07: [irq 1]
[    1.960815] pnp 00:07: Plug and Play ACPI device, IDs PNP0303 (active)
[    1.960829] pnp 00:08: [irq 12]
[    1.960895] pnp 00:08: Plug and Play ACPI device, IDs PNP0f13 (active)
[    1.961361] pnp 00:09: [mem 0xfed1c000-0xfed1ffff]
[    1.961364] pnp 00:09: [mem 0x00000000-0xffffffff disabled]
[    1.961367] pnp 00:09: [mem 0xfed1b000-0xfed1bfff]
[    1.961369] pnp 00:09: [mem 0x00000000-0xffffffff disabled]
[    1.961372] pnp 00:09: [mem 0xf8000000-0xfbffffff]
[    1.961374] pnp 00:09: [mem 0xfed20000-0xfed3ffff]
[    1.961377] pnp 00:09: [mem 0xfed90000-0xfed8ffff disabled]
[    1.961379] pnp 00:09: [mem 0xfed45000-0xfed8ffff]
[    1.961382] pnp 00:09: [mem 0xff000000-0xffffffff]
[    1.961384] pnp 00:09: [mem 0xfee00000-0xfeefffff]
[    1.961387] pnp 00:09: [mem 0xea20b000-0xea20bfff]
[    1.961492] system 00:09: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    1.961496] system 00:09: [mem 0xfed1b000-0xfed1bfff] has been reserved
[    1.961499] system 00:09: [mem 0xf8000000-0xfbffffff] has been reserved
[    1.961502] system 00:09: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.961506] system 00:09: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.961509] system 00:09: [mem 0xff000000-0xffffffff] could not be reserved
[    1.961513] system 00:09: [mem 0xfee00000-0xfeefffff] could not be reserved
[    1.961516] system 00:09: [mem 0xea20b000-0xea20bfff] has been reserved
[    1.961520] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.961698] pnp 00:0a: [bus 3f]
[    1.961766] pnp 00:0a: Plug and Play ACPI device, IDs PNP0a03 (active)
[    1.977393] pnp: PnP ACPI: found 11 devices
[    1.977396] ACPI: ACPI bus type pnp unregistered
[    1.977399] PnPBIOS: Disabled by ACPI PNP
[    2.014196] PCI: max bus depth: 1 pci_try_num: 2
[    2.014253] pci 0000:00:1c.6: BAR 15: assigned [mem 0xea300000-0xea4fffff 64bit pref]
[    2.014262] pci 0000:00:1c.5: BAR 15: assigned [mem 0xea500000-0xea6fffff 64bit pref]
[    2.014270] pci 0000:00:1c.2: BAR 15: assigned [mem 0xea700000-0xea8fffff 64bit pref]
[    2.014278] pci 0000:00:1c.1: BAR 15: assigned [mem 0xea900000-0xeaafffff 64bit pref]
[    2.014285] pci 0000:00:1c.0: BAR 15: assigned [mem 0xeab00000-0xeacfffff 64bit pref]
[    2.014289] pci 0000:00:03.0: PCI bridge to [bus 01-01]
[    2.014293] pci 0000:00:03.0:   bridge window [io  0xd000-0xdfff]
[    2.014298] pci 0000:00:03.0:   bridge window [mem 0xd0000000-0xe30fffff]
[    2.014305] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    2.014308] pci 0000:00:1c.0:   bridge window [io  0xc000-0xcfff]
[    2.014314] pci 0000:00:1c.0:   bridge window [mem 0xe8e00000-0xea1fffff]
[    2.014319] pci 0000:00:1c.0:   bridge window [mem 0xeab00000-0xeacfffff 64bit pref]
[    2.014326] pci 0000:00:1c.1: PCI bridge to [bus 03-03]
[    2.014329] pci 0000:00:1c.1:   bridge window [io  0xb000-0xbfff]
[    2.014335] pci 0000:00:1c.1:   bridge window [mem 0xe7a00000-0xe8dfffff]
[    2.014339] pci 0000:00:1c.1:   bridge window [mem 0xea900000-0xeaafffff 64bit pref]
[    2.014346] pci 0000:00:1c.2: PCI bridge to [bus 04-04]
[    2.014350] pci 0000:00:1c.2:   bridge window [io  0xa000-0xafff]
[    2.014355] pci 0000:00:1c.2:   bridge window [mem 0xe6600000-0xe79fffff]
[    2.014360] pci 0000:00:1c.2:   bridge window [mem 0xea700000-0xea8fffff 64bit pref]
[    2.014367] pci 0000:00:1c.5: PCI bridge to [bus 05-05]
[    2.014370] pci 0000:00:1c.5:   bridge window [io  0x9000-0x9fff]
[    2.014376] pci 0000:00:1c.5:   bridge window [mem 0xe5200000-0xe65fffff]
[    2.014380] pci 0000:00:1c.5:   bridge window [mem 0xea500000-0xea6fffff 64bit pref]
[    2.014387] pci 0000:00:1c.6: PCI bridge to [bus 06-0d]
[    2.014390] pci 0000:00:1c.6:   bridge window [io  0x8000-0x8fff]
[    2.014396] pci 0000:00:1c.6:   bridge window [mem 0xe3200000-0xe51fffff]
[    2.014401] pci 0000:00:1c.6:   bridge window [mem 0xea300000-0xea4fffff 64bit pref]
[    2.014407] pci 0000:00:1e.0: PCI bridge to [bus 0e-0e]
[    2.014431] pci 0000:00:03.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.014435] pci 0000:00:03.0: setting latency timer to 64
[    2.014442] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.014447] pci 0000:00:1c.0: setting latency timer to 64
[    2.014458] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.014462] pci 0000:00:1c.1: setting latency timer to 64
[    2.014473] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.014477] pci 0000:00:1c.2: setting latency timer to 64
[    2.014484] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.014488] pci 0000:00:1c.5: setting latency timer to 64
[    2.014495] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    2.014499] pci 0000:00:1c.6: setting latency timer to 64
[    2.014506] pci 0000:00:1e.0: setting latency timer to 64
[    2.014510] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    2.014513] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    2.014516] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    2.014519] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000d3fff]
[    2.014521] pci_bus 0000:00: resource 8 [mem 0x000d4000-0x000d7fff]
[    2.014524] pci_bus 0000:00: resource 9 [mem 0x000d8000-0x000dbfff]
[    2.014527] pci_bus 0000:00: resource 10 [mem 0x000dc000-0x000dffff]
[    2.014530] pci_bus 0000:00: resource 11 [mem 0x000e0000-0x000e3fff]
[    2.014532] pci_bus 0000:00: resource 12 [mem 0x000e4000-0x000e7fff]
[    2.014535] pci_bus 0000:00: resource 13 [mem 0xd0000000-0xfeafffff]
[    2.014538] pci_bus 0000:01: resource 0 [io  0xd000-0xdfff]
[    2.014541] pci_bus 0000:01: resource 1 [mem 0xd0000000-0xe30fffff]
[    2.014544] pci_bus 0000:02: resource 0 [io  0xc000-0xcfff]
[    2.014547] pci_bus 0000:02: resource 1 [mem 0xe8e00000-0xea1fffff]
[    2.014550] pci_bus 0000:02: resource 2 [mem 0xeab00000-0xeacfffff 64bit pref]
[    2.014553] pci_bus 0000:03: resource 0 [io  0xb000-0xbfff]
[    2.014555] pci_bus 0000:03: resource 1 [mem 0xe7a00000-0xe8dfffff]
[    2.014558] pci_bus 0000:03: resource 2 [mem 0xea900000-0xeaafffff 64bit pref]
[    2.014561] pci_bus 0000:04: resource 0 [io  0xa000-0xafff]
[    2.014564] pci_bus 0000:04: resource 1 [mem 0xe6600000-0xe79fffff]
[    2.014567] pci_bus 0000:04: resource 2 [mem 0xea700000-0xea8fffff 64bit pref]
[    2.014570] pci_bus 0000:05: resource 0 [io  0x9000-0x9fff]
[    2.014572] pci_bus 0000:05: resource 1 [mem 0xe5200000-0xe65fffff]
[    2.014575] pci_bus 0000:05: resource 2 [mem 0xea500000-0xea6fffff 64bit pref]
[    2.014578] pci_bus 0000:06: resource 0 [io  0x8000-0x8fff]
[    2.014581] pci_bus 0000:06: resource 1 [mem 0xe3200000-0xe51fffff]
[    2.014584] pci_bus 0000:06: resource 2 [mem 0xea300000-0xea4fffff 64bit pref]
[    2.014587] pci_bus 0000:0e: resource 4 [io  0x0000-0x0cf7]
[    2.014590] pci_bus 0000:0e: resource 5 [io  0x0d00-0xffff]
[    2.014592] pci_bus 0000:0e: resource 6 [mem 0x000a0000-0x000bffff]
[    2.014595] pci_bus 0000:0e: resource 7 [mem 0x000d0000-0x000d3fff]
[    2.014598] pci_bus 0000:0e: resource 8 [mem 0x000d4000-0x000d7fff]
[    2.014600] pci_bus 0000:0e: resource 9 [mem 0x000d8000-0x000dbfff]
[    2.014603] pci_bus 0000:0e: resource 10 [mem 0x000dc000-0x000dffff]
[    2.014606] pci_bus 0000:0e: resource 11 [mem 0x000e0000-0x000e3fff]
[    2.014609] pci_bus 0000:0e: resource 12 [mem 0x000e4000-0x000e7fff]
[    2.014612] pci_bus 0000:0e: resource 13 [mem 0xd0000000-0xfeafffff]
[    2.014645] NET: Registered protocol family 2
[    2.014704] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    2.014904] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    2.015696] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    2.016103] TCP: Hash tables configured (established 131072 bind 65536)
[    2.016106] TCP reno registered
[    2.016109] UDP hash table entries: 512 (order: 2, 16384 bytes)
[    2.016121] UDP-Lite hash table entries: 512 (order: 2, 16384 bytes)
[    2.016195] NET: Registered protocol family 1
[    2.143910] pci 0000:01:00.0: Boot video device
[    2.143984] PCI: CLS 64 bytes, default 64
[    2.144022] Trying to unpack rootfs image as initramfs...
[    2.572643] Freeing initrd memory: 13616k freed
[    2.575920] audit: initializing netlink socket (disabled)
[    2.575931] type=2000 audit(1325074586.332:1): initialized
[    2.610346] highmem bounce pool size: 64 pages
[    2.610352] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    2.617330] VFS: Disk quotas dquot_6.5.2
[    2.617400] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.618131] fuse init (API version 7.17)
[    2.618235] msgmni has been set to 1419
[    2.618640] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    2.618668] io scheduler noop registered
[    2.618671] io scheduler deadline registered
[    2.618687] io scheduler cfq registered (default)
[    2.619091] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.619115] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.619186] intel_idle: MWAIT substates: 0x1120
[    2.619197] intel_idle: v0.4 model 0x1E
[    2.619199] intel_idle: lapic_timer_reliable_states 0x2
[    2.624205] ACPI: Deprecated procfs I/F for AC is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.632273] ACPI: AC Adapter [ADP1] (on-line)
[    2.632395] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input0
[    2.644372] ACPI: Lid Switch [LID0]
[    2.644420] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.644425] ACPI: Power Button [PWRB]
[    2.644454] ACPI: acpi_idle yielding to intel_idle
[    2.680603] thermal LNXTHERM:00: registered as thermal_zone0
[    2.680606] ACPI: Thermal Zone [TZ00] (52 C)
[    2.696801] thermal LNXTHERM:01: registered as thermal_zone1
[    2.696804] ACPI: Thermal Zone [TZ01] (52 C)
[    2.696817] ERST: Table is not found!
[    2.696830] isapnp: Scanning for PnP cards...
[    2.760335] ACPI: Deprecated procfs I/F for battery is loaded, please retry with CONFIG_ACPI_PROCFS_POWER cleared
[    2.760342] ACPI: Battery Slot [BAT0] (battery present)
[    3.050272] isapnp: No Plug & Play device found
[    3.050335] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    3.143913] Linux agpgart interface v0.103
[    3.145424] brd: module loaded
[    3.146171] loop: module loaded
[    3.146643] Fixed MDIO Bus: probed
[    3.146668] PPP generic driver version 2.4.2
[    3.146713] tun: Universal TUN/TAP device driver, 1.6
[    3.146715] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    3.146812] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.146829] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    3.146843] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    3.146847] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    3.146891] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    3.146918] ehci_hcd 0000:00:1a.0: debug port 2
[    3.150922] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    3.150942] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xea208000
[    3.163432] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    3.163590] hub 1-0:1.0: USB hub found
[    3.163595] hub 1-0:1.0: 2 ports detected
[    3.163679] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.163691] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.163695] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    3.163742] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.163767] ehci_hcd 0000:00:1d.0: debug port 2
[    3.167755] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    3.167772] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xea207000
[    3.183426] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    3.183579] hub 2-0:1.0: USB hub found
[    3.183583] hub 2-0:1.0: 2 ports detected
[    3.183656] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    3.183672] uhci_hcd: USB Universal Host Controller Interface driver
[    3.183753] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.188929] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.188936] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.189055] mousedev: PS/2 mouse device common for all mice
[    3.189198] rtc_cmos 00:06: RTC can wake from S4
[    3.189303] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
[    3.189330] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    3.189424] device-mapper: uevent: version 1.0.3
[    3.189507] device-mapper: ioctl: 4.21.0-ioctl (2011-07-06) initialised: dm-devel@redhat.com
[    3.189545] EISA: Probing bus 0 at eisa.0
[    3.189550] EISA: Cannot allocate resource for mainboard
[    3.189552] Cannot allocate resource for EISA slot 1
[    3.189554] Cannot allocate resource for EISA slot 2
[    3.189556] Cannot allocate resource for EISA slot 3
[    3.189558] Cannot allocate resource for EISA slot 4
[    3.189560] Cannot allocate resource for EISA slot 5
[    3.189562] Cannot allocate resource for EISA slot 6
[    3.189564] Cannot allocate resource for EISA slot 7
[    3.189566] Cannot allocate resource for EISA slot 8
[    3.189568] EISA: Detected 0 cards.
[    3.189578] cpufreq-nforce2: No nForce2 chipset.
[    3.189795] cpuidle: using governor ladder
[    3.190153] cpuidle: using governor menu
[    3.190156] EFI Variables Facility v0.08 2004-May-17
[    3.190445] TCP cubic registered
[    3.190580] NET: Registered protocol family 10
[    3.191187] NET: Registered protocol family 17
[    3.191202] Registering the dns_resolver key type
[    3.191217] Using IPI No-Shortcut mode
[    3.191336] PM: Hibernation image not present or could not be loaded.
[    3.191346] registered taskstats version 1
[    3.208943]   Magic number: 7:134:280
[    3.208986] tty tty17: hash matches
[    3.209402] rtc_cmos 00:06: setting system clock to 2011-12-28 12:16:28 UTC (1325074588)
[    3.210949] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.212944] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.212946] EDD information not available.
[    3.213622] Freeing unused kernel memory: 756k freed
[    3.213958] Write protecting the kernel text: 5408k
[    3.214217] Write protecting the kernel read-only data: 2276k
[    3.231942] udevd[105]: starting version 173
[    3.282311] sky2: driver version 1.29
[    3.282357] sky2 0000:04:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.282370] sky2 0000:04:00.0: setting latency timer to 64
[    3.282403] sky2 0000:04:00.0: Yukon-2 UL 2 chip revision 0
[    3.282451] sdhci: Secure Digital Host Controller Interface driver
[    3.282454] sdhci: Copyright(c) Pierre Ossman
[    3.282972] sdhci-pci 0000:03:00.0: SDHCI controller found [1180:e822] (rev 0)
[    3.282990] sdhci-pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    3.283015] sdhci-pci 0000:03:00.0: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.283023] sdhci-pci 0000:03:00.0: setting latency timer to 64
[    3.283050] mmc0: no vmmc regulator found
[    3.283089] Registered led device: mmc0::
[    3.283138] mmc0: SDHCI controller on PCI [0000:03:00.0] using DMA
[    3.283152] sdhci-pci 0000:03:00.4: SDHCI controller found [1180:e822] (rev 0)
[    3.283178] sdhci-pci 0000:03:00.4: PCI INT C -> GSI 19 (level, low) -> IRQ 19
[    3.283196] sdhci-pci 0000:03:00.4: Will use DMA mode even though HW doesn't fully claim to support it.
[    3.283204] sdhci-pci 0000:03:00.4: setting latency timer to 64
[    3.283227] mmc1: no vmmc regulator found
[    3.283263] Registered led device: mmc1::
[    3.283305] mmc1: SDHCI controller on PCI [0000:03:00.4] using DMA
[    3.284209] sky2 0000:04:00.0: irq 45 for MSI/MSI-X
[    3.285046] sky2 0000:04:00.0: eth0: addr f0:bf:97:18:b9:90
[    3.287618] ahci 0000:00:1f.2: version 3.0
[    3.287632] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.287682] ahci 0000:00:1f.2: irq 46 for MSI/MSI-X
[    3.287726] ahci: SSS flag set, parallel bus scan disabled
[    3.287764] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x23 impl SATA mode
[    3.287770] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part sxs apst 
[    3.287777] ahci 0000:00:1f.2: setting latency timer to 64
[    3.288436] firewire_ohci 0000:03:00.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    3.288445] firewire_ohci 0000:03:00.3: setting latency timer to 64
[    3.289685] scsi0 : ahci
[    3.289856] scsi1 : ahci
[    3.289982] scsi2 : ahci
[    3.290101] scsi3 : ahci
[    3.290235] scsi4 : ahci
[    3.290342] scsi5 : ahci
[    3.290567] ata1: SATA max UDMA/133 abar m2048@0xea206000 port 0xea206100 irq 46
[    3.290571] ata2: SATA max UDMA/133 abar m2048@0xea206000 port 0xea206180 irq 46
[    3.290574] ata3: DUMMY
[    3.290575] ata4: DUMMY
[    3.290577] ata5: DUMMY
[    3.290579] ata6: SATA max UDMA/133 abar m2048@0xea206000 port 0xea206380 irq 46
[    3.343763] firewire_ohci 0000:03:00.3: irq 47 for MSI/MSI-X
[    3.343806] firewire_ohci: Added fw-ohci device 0000:03:00.3, OHCI v1.0, 4 IR + 4 IT contexts, quirks 0x1
[    3.475435] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    3.571461] Refined TSC clocksource calibration: 1728.999 MHz.
[    3.571471] Switching to clocksource tsc
[    3.607440] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.608280] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    3.608415] hub 1-1:1.0: USB hub found
[    3.608590] hub 1-1:1.0: 6 ports detected
[    3.608656] ata1.00: ATA-8: Hitachi HTS725050A9A360, PC4OC70X, max UDMA/133
[    3.608661] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
[    3.609635] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
[    3.609969] ata1.00: configured for UDMA/133
[    3.610154] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72505 PC4O PQ: 0 ANSI: 5
[    3.610382] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    3.610385] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.610436] sd 0:0:0:0: [sda] Write Protect is off
[    3.610440] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.610460] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    3.695968]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    3.697902] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.719418] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    3.843801] firewire_core: created device fw0: GUID 08004603035349c7, S400
[    3.852116] hub 2-1:1.0: USB hub found
[    3.852223] hub 2-1:1.0: 8 ports detected
[    3.923502] usb 1-1.2: new high speed USB device number 3 using ehci_hcd
[    3.927298] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.930042] ata2.00: ATAPI: PIONEER BD-RW   BDR-TD03, 1.00, max UDMA/100
[    3.932910] ata2.00: configured for UDMA/100
[    3.943705] scsi 1:0:0:0: CD-ROM            PIONEER  BD-RW   BDR-TD03 1.00 PQ: 0 ANSI: 5
[    3.960030] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[    3.960038] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.960456] sr 1:0:0:0: Attached scsi CD-ROM sr0
[    3.960703] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    4.091535] usb 1-1.6: new full speed USB device number 4 using ehci_hcd
[    4.279327] ata6: SATA link down (SStatus 0 SControl 300)
[    4.999221] kjournald starting.  Commit interval 5 seconds
[    4.999260] EXT3-fs (sda5): mounted filesystem with ordered data mode
[    5.992176] init: ureadahead main process (303) terminated with status 5
[    6.434277] CE: hpet increased min_delta_ns to 20113 nsec
[    6.759816] udevd[337]: starting version 173
[    7.341293] Adding 5124696k swap on /dev/sda6.  Priority:-1 extents:1 across:5124696k 
[    8.109473] lp: driver loaded but no devices found
[    8.475809] psmouse serio1: ID: 73 02 64
[    8.708120] [Firmware Bug]: ACPI(NGFX) defines _DOD but not _DOS
[    8.747780] wmi: Mapper loaded
[    8.749247] acpi device:5f: registered as cooling_device8
[    8.753485] acpi device:60: registered as cooling_device9
[    8.753555] input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:5e/LNXVIDEO:02/input/input3
[    8.753625] ACPI: Video Device [NGFX] (multi-head: yes  rom: no  post: no)
[    8.770386] EXT3-fs (sda5): using internal journal
[    8.828188] xhci_hcd 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    8.828210] xhci_hcd 0000:05:00.0: setting latency timer to 64
[    8.828215] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    8.828282] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 3
[    8.828301] xhci_hcd 0000:05:00.0: xHCI capability registers at f8054000:
[    8.828305] xhci_hcd 0000:05:00.0: CAPLENGTH AND HCIVERSION 0x960020:
[    8.828308] xhci_hcd 0000:05:00.0: CAPLENGTH: 0x20
[    8.828310] xhci_hcd 0000:05:00.0: HCIVERSION: 0x96
[    8.828314] xhci_hcd 0000:05:00.0: HCSPARAMS 1: 0x4000820
[    8.828316] xhci_hcd 0000:05:00.0:   Max device slots: 32
[    8.828318] xhci_hcd 0000:05:00.0:   Max interrupters: 8
[    8.828320] xhci_hcd 0000:05:00.0:   Max ports: 4
[    8.828324] xhci_hcd 0000:05:00.0: HCSPARAMS 2: 0x11
[    8.828327] xhci_hcd 0000:05:00.0:   Isoc scheduling threshold: 1
[    8.828329] xhci_hcd 0000:05:00.0:   Maximum allowed segments in event ring: 1
[    8.828333] xhci_hcd 0000:05:00.0: HCSPARAMS 3 0x0:
[    8.828335] xhci_hcd 0000:05:00.0:   Worst case U1 device exit latency: 0
[    8.828338] xhci_hcd 0000:05:00.0:   Worst case U2 device exit latency: 0
[    8.828342] xhci_hcd 0000:05:00.0: HCC PARAMS 0x14042cb:
[    8.828344] xhci_hcd 0000:05:00.0:   HC generates 64 bit addresses
[    8.828346] xhci_hcd 0000:05:00.0:   FIXME: more HCCPARAMS debugging
[    8.828351] xhci_hcd 0000:05:00.0: RTSOFF 0x600:
[    8.828353] xhci_hcd 0000:05:00.0: xHCI operational registers at f8054020:
[    8.828357] xhci_hcd 0000:05:00.0: USBCMD 0x0:
[    8.828359] xhci_hcd 0000:05:00.0:   HC is being stopped
[    8.828361] xhci_hcd 0000:05:00.0:   HC has finished hard reset
[    8.828364] xhci_hcd 0000:05:00.0:   Event Interrupts disabled
[    8.828366] xhci_hcd 0000:05:00.0:   Host System Error Interrupts disabled
[    8.828369] xhci_hcd 0000:05:00.0:   HC has finished light reset
[    8.828373] xhci_hcd 0000:05:00.0: USBSTS 0x1:
[    8.828375] xhci_hcd 0000:05:00.0:   Event ring is empty
[    8.828377] xhci_hcd 0000:05:00.0:   No Host System Error
[    8.828379] xhci_hcd 0000:05:00.0:   HC is halted
[    8.828383] xhci_hcd 0000:05:00.0: f8054420 port status reg = 0x2a0
[    8.828388] xhci_hcd 0000:05:00.0: f8054424 port power reg = 0x0
[    8.828393] xhci_hcd 0000:05:00.0: f8054428 port link reg = 0x0
[    8.828397] xhci_hcd 0000:05:00.0: f805442c port reserved reg = 0x0
[    8.828401] xhci_hcd 0000:05:00.0: f8054430 port status reg = 0x2a0
[    8.828406] xhci_hcd 0000:05:00.0: f8054434 port power reg = 0x0
[    8.828410] xhci_hcd 0000:05:00.0: f8054438 port link reg = 0x0
[    8.828414] xhci_hcd 0000:05:00.0: f805443c port reserved reg = 0x0
[    8.828419] xhci_hcd 0000:05:00.0: f8054440 port status reg = 0x2a0
[    8.828423] xhci_hcd 0000:05:00.0: f8054444 port power reg = 0x0
[    8.828427] xhci_hcd 0000:05:00.0: f8054448 port link reg = 0x0
[    8.828431] xhci_hcd 0000:05:00.0: f805444c port reserved reg = 0x0
[    8.828436] xhci_hcd 0000:05:00.0: f8054450 port status reg = 0x2a0
[    8.828440] xhci_hcd 0000:05:00.0: f8054454 port power reg = 0x0
[    8.828444] xhci_hcd 0000:05:00.0: f8054458 port link reg = 0x0
[    8.828468] xhci_hcd 0000:05:00.0: f805445c port reserved reg = 0x0
[    8.828472] xhci_hcd 0000:05:00.0: // Halt the HC
[    8.828480] xhci_hcd 0000:05:00.0: Resetting HCD
[    8.828485] xhci_hcd 0000:05:00.0: // Reset the HC
[    8.828532] xhci_hcd 0000:05:00.0: Wait for controller to be ready for doorbell rings
[    8.828537] xhci_hcd 0000:05:00.0: Reset complete
[    8.828540] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[    8.828543] xhci_hcd 0000:05:00.0: Calling HCD init
[    8.828545] xhci_hcd 0000:05:00.0: xhci_init
[    8.828547] xhci_hcd 0000:05:00.0: xHCI doesn't need link TRB QUIRK
[    8.828551] xhci_hcd 0000:05:00.0: Supported page size register = 0x1
[    8.828553] xhci_hcd 0000:05:00.0: Supported page size of 4K
[    8.828555] xhci_hcd 0000:05:00.0: HCD page size set to 4K
[    8.828559] xhci_hcd 0000:05:00.0: // xHC can handle at most 32 device slots.
[    8.828564] xhci_hcd 0000:05:00.0: // Setting Max device slots reg = 0x20.
[    8.828568] xhci_hcd 0000:05:00.0: // Device context base array address = 0x3331b000 (DMA), f331b000 (virt)
[    8.828577] xhci_hcd 0000:05:00.0: Allocating ring at f7293640
[    8.828579] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f7226860
[    8.828583] xhci_hcd 0000:05:00.0: // Allocating segment at f71f3000 (virtual) 0x371f3000 (DMA)
[    8.828588] xhci_hcd 0000:05:00.0: Linking segment 0x371f3000 to segment 0x371f3000 (DMA)
[    8.828591] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment f7226860 (virtual), 0x371f3000 (DMA)
[    8.828594] xhci_hcd 0000:05:00.0: Allocated command ring at f7293640
[    8.828597] xhci_hcd 0000:05:00.0: First segment DMA is 0x371f3000
[    8.828603] xhci_hcd 0000:05:00.0: // Setting command ring address to 0x20
[    8.828609] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[    8.828612] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[    8.828616] xhci_hcd 0000:05:00.0: // Doorbell array is located at offset 0x800 from cap regs base addr
[    8.828619] xhci_hcd 0000:05:00.0: // xHCI capability registers at f8054000:
[    8.828623] xhci_hcd 0000:05:00.0: // @f8054000 = 0x960020 (CAPLENGTH AND HCIVERSION)
[    8.828626] xhci_hcd 0000:05:00.0: //   CAPLENGTH: 0x20
[    8.828628] xhci_hcd 0000:05:00.0: // xHCI operational registers at f8054020:
[    8.828633] xhci_hcd 0000:05:00.0: // @f8054018 = 0x600 RTSOFF
[    8.828635] xhci_hcd 0000:05:00.0: // xHCI runtime registers at f8054600:
[    8.828640] xhci_hcd 0000:05:00.0: // @f8054014 = 0x800 DBOFF
[    8.828642] xhci_hcd 0000:05:00.0: // Doorbell array at f8054800:
[    8.828644] xhci_hcd 0000:05:00.0: xHCI runtime registers at f8054600:
[    8.828649] xhci_hcd 0000:05:00.0:   f8054600: Microframe index = 0x0
[    8.828662] xhci_hcd 0000:05:00.0: // Allocating event ring
[    8.828665] xhci_hcd 0000:05:00.0: Allocating ring at f7293980
[    8.828667] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f7226870
[    8.828670] xhci_hcd 0000:05:00.0: // Allocating segment at f71f3400 (virtual) 0x371f3400 (DMA)
[    8.828673] xhci_hcd 0000:05:00.0: Linking segment 0x371f3400 to segment 0x371f3400 (DMA)
[    8.828677] xhci_hcd 0000:05:00.0: TRB math tests passed.
[    8.828680] xhci_hcd 0000:05:00.0: // Allocated event ring segment table at 0x3704d000
[    8.828684] xhci_hcd 0000:05:00.0: Set ERST to 0; private num segs = 1, virt addr = f704d000, dma addr = 0x3704d000
[    8.828689] xhci_hcd 0000:05:00.0: // Write ERST size = 1 to ir_set 0 (some bits preserved)
[    8.828691] xhci_hcd 0000:05:00.0: // Set ERST entries to point to event ring.
[    8.828694] xhci_hcd 0000:05:00.0: // Set ERST base address for ir_set 0 = 0x3704d000
[    8.828704] xhci_hcd 0000:05:00.0: // Write event ring dequeue pointer, preserving EHB bit
[    8.828707] xhci_hcd 0000:05:00.0: Wrote ERST address to ir_set 0.
[    8.828711] xhci_hcd 0000:05:00.0: Allocating 0 scratchpad buffers
[    8.828721] xhci_hcd 0000:05:00.0: Ext Cap f8054510, port offset = 1, count = 2, revision = 0x3
[    8.828727] xhci_hcd 0000:05:00.0: Ext Cap f8054520, port offset = 3, count = 2, revision = 0x2
[    8.828730] xhci_hcd 0000:05:00.0: Found 2 USB 2.0 ports and 2 USB 3.0 ports.
[    8.828733] xhci_hcd 0000:05:00.0: USB 2.0 port at index 2, addr = f8054440
[    8.828736] xhci_hcd 0000:05:00.0: USB 2.0 port at index 3, addr = f8054450
[    8.828739] xhci_hcd 0000:05:00.0: USB 3.0 port at index 0, addr = f8054420
[    8.828741] xhci_hcd 0000:05:00.0: USB 3.0 port at index 1, addr = f8054430
[    8.828744] xhci_hcd 0000:05:00.0: Finished xhci_init
[    8.828746] xhci_hcd 0000:05:00.0: Called HCD init
[    8.828750] xhci_hcd 0000:05:00.0: Got SBRN 48
[    8.828758] xhci_hcd 0000:05:00.0: MWI active
[    8.828760] xhci_hcd 0000:05:00.0: Finished xhci_pci_reinit
[    8.828768] xhci_hcd 0000:05:00.0: irq 17, io mem 0xe5200000
[    8.828770] xhci_hcd 0000:05:00.0: xhci_run
[    8.828840] xhci_hcd 0000:05:00.0: irq 48 for MSI/MSI-X
[    8.828847] xhci_hcd 0000:05:00.0: irq 49 for MSI/MSI-X
[    8.828854] xhci_hcd 0000:05:00.0: irq 50 for MSI/MSI-X
[    8.828861] xhci_hcd 0000:05:00.0: irq 51 for MSI/MSI-X
[    8.828868] xhci_hcd 0000:05:00.0: irq 52 for MSI/MSI-X
[    8.828876] xhci_hcd 0000:05:00.0: irq 53 for MSI/MSI-X
[    8.828882] xhci_hcd 0000:05:00.0: irq 54 for MSI/MSI-X
[    8.828889] xhci_hcd 0000:05:00.0: irq 55 for MSI/MSI-X
[    8.828989] xhci_hcd 0000:05:00.0: Setting event ring polling timer
[    8.828992] xhci_hcd 0000:05:00.0: Command ring memory map follows:
[    8.828995] xhci_hcd 0000:05:00.0: @00000000371f3000 00000000 00000000 00000000 00000000
[    8.828998] xhci_hcd 0000:05:00.0: @00000000371f3010 00000000 00000000 00000000 00000000
[    8.829002] xhci_hcd 0000:05:00.0: @00000000371f3020 00000000 00000000 00000000 00000000
[    8.829005] xhci_hcd 0000:05:00.0: @00000000371f3030 00000000 00000000 00000000 00000000
[    8.829008] xhci_hcd 0000:05:00.0: @00000000371f3040 00000000 00000000 00000000 00000000
[    8.829011] xhci_hcd 0000:05:00.0: @00000000371f3050 00000000 00000000 00000000 00000000
[    8.829014] xhci_hcd 0000:05:00.0: @00000000371f3060 00000000 00000000 00000000 00000000
[    8.829018] xhci_hcd 0000:05:00.0: @00000000371f3070 00000000 00000000 00000000 00000000
[    8.829022] xhci_hcd 0000:05:00.0: @00000000371f3080 00000000 00000000 00000000 00000000
[    8.829036] xhci_hcd 0000:05:00.0: @00000000371f3090 00000000 00000000 00000000 00000000
[    8.829040] xhci_hcd 0000:05:00.0: @00000000371f30a0 00000000 00000000 00000000 00000000
[    8.829043] xhci_hcd 0000:05:00.0: @00000000371f30b0 00000000 00000000 00000000 00000000
[    8.829046] xhci_hcd 0000:05:00.0: @00000000371f30c0 00000000 00000000 00000000 00000000
[    8.829049] xhci_hcd 0000:05:00.0: @00000000371f30d0 00000000 00000000 00000000 00000000
[    8.829052] xhci_hcd 0000:05:00.0: @00000000371f30e0 00000000 00000000 00000000 00000000
[    8.829056] xhci_hcd 0000:05:00.0: @00000000371f30f0 00000000 00000000 00000000 00000000
[    8.829059] xhci_hcd 0000:05:00.0: @00000000371f3100 00000000 00000000 00000000 00000000
[    8.829062] xhci_hcd 0000:05:00.0: @00000000371f3110 00000000 00000000 00000000 00000000
[    8.829065] xhci_hcd 0000:05:00.0: @00000000371f3120 00000000 00000000 00000000 00000000
[    8.829068] xhci_hcd 0000:05:00.0: @00000000371f3130 00000000 00000000 00000000 00000000
[    8.829071] xhci_hcd 0000:05:00.0: @00000000371f3140 00000000 00000000 00000000 00000000
[    8.829075] xhci_hcd 0000:05:00.0: @00000000371f3150 00000000 00000000 00000000 00000000
[    8.829078] xhci_hcd 0000:05:00.0: @00000000371f3160 00000000 00000000 00000000 00000000
[    8.829081] xhci_hcd 0000:05:00.0: @00000000371f3170 00000000 00000000 00000000 00000000
[    8.829084] xhci_hcd 0000:05:00.0: @00000000371f3180 00000000 00000000 00000000 00000000
[    8.829087] xhci_hcd 0000:05:00.0: @00000000371f3190 00000000 00000000 00000000 00000000
[    8.829091] xhci_hcd 0000:05:00.0: @00000000371f31a0 00000000 00000000 00000000 00000000
[    8.829094] xhci_hcd 0000:05:00.0: @00000000371f31b0 00000000 00000000 00000000 00000000
[    8.829097] xhci_hcd 0000:05:00.0: @00000000371f31c0 00000000 00000000 00000000 00000000
[    8.829100] xhci_hcd 0000:05:00.0: @00000000371f31d0 00000000 00000000 00000000 00000000
[    8.829103] xhci_hcd 0000:05:00.0: @00000000371f31e0 00000000 00000000 00000000 00000000
[    8.829107] xhci_hcd 0000:05:00.0: @00000000371f31f0 00000000 00000000 00000000 00000000
[    8.829110] xhci_hcd 0000:05:00.0: @00000000371f3200 00000000 00000000 00000000 00000000
[    8.829113] xhci_hcd 0000:05:00.0: @00000000371f3210 00000000 00000000 00000000 00000000
[    8.829116] xhci_hcd 0000:05:00.0: @00000000371f3220 00000000 00000000 00000000 00000000
[    8.829119] xhci_hcd 0000:05:00.0: @00000000371f3230 00000000 00000000 00000000 00000000
[    8.829122] xhci_hcd 0000:05:00.0: @00000000371f3240 00000000 00000000 00000000 00000000
[    8.829126] xhci_hcd 0000:05:00.0: @00000000371f3250 00000000 00000000 00000000 00000000
[    8.829129] xhci_hcd 0000:05:00.0: @00000000371f3260 00000000 00000000 00000000 00000000
[    8.829132] xhci_hcd 0000:05:00.0: @00000000371f3270 00000000 00000000 00000000 00000000
[    8.829135] xhci_hcd 0000:05:00.0: @00000000371f3280 00000000 00000000 00000000 00000000
[    8.829138] xhci_hcd 0000:05:00.0: @00000000371f3290 00000000 00000000 00000000 00000000
[    8.829142] xhci_hcd 0000:05:00.0: @00000000371f32a0 00000000 00000000 00000000 00000000
[    8.829145] xhci_hcd 0000:05:00.0: @00000000371f32b0 00000000 00000000 00000000 00000000
[    8.829148] xhci_hcd 0000:05:00.0: @00000000371f32c0 00000000 00000000 00000000 00000000
[    8.829151] xhci_hcd 0000:05:00.0: @00000000371f32d0 00000000 00000000 00000000 00000000
[    8.829154] xhci_hcd 0000:05:00.0: @00000000371f32e0 00000000 00000000 00000000 00000000
[    8.829157] xhci_hcd 0000:05:00.0: @00000000371f32f0 00000000 00000000 00000000 00000000
[    8.829163] xhci_hcd 0000:05:00.0: @00000000371f3300 00000000 00000000 00000000 00000000
[    8.829165] xhci_hcd 0000:05:00.0: @00000000371f3310 00000000 00000000 00000000 00000000
[    8.829167] xhci_hcd 0000:05:00.0: @00000000371f3320 00000000 00000000 00000000 00000000
[    8.829169] xhci_hcd 0000:05:00.0: @00000000371f3330 00000000 00000000 00000000 00000000
[    8.829171] xhci_hcd 0000:05:00.0: @00000000371f3340 00000000 00000000 00000000 00000000
[    8.829173] xhci_hcd 0000:05:00.0: @00000000371f3350 00000000 00000000 00000000 00000000
[    8.829175] xhci_hcd 0000:05:00.0: @00000000371f3360 00000000 00000000 00000000 00000000
[    8.829177] xhci_hcd 0000:05:00.0: @00000000371f3370 00000000 00000000 00000000 00000000
[    8.829179] xhci_hcd 0000:05:00.0: @00000000371f3380 00000000 00000000 00000000 00000000
[    8.829181] xhci_hcd 0000:05:00.0: @00000000371f3390 00000000 00000000 00000000 00000000
[    8.829183] xhci_hcd 0000:05:00.0: @00000000371f33a0 00000000 00000000 00000000 00000000
[    8.829185] xhci_hcd 0000:05:00.0: @00000000371f33b0 00000000 00000000 00000000 00000000
[    8.829187] xhci_hcd 0000:05:00.0: @00000000371f33c0 00000000 00000000 00000000 00000000
[    8.829189] xhci_hcd 0000:05:00.0: @00000000371f33d0 00000000 00000000 00000000 00000000
[    8.829191] xhci_hcd 0000:05:00.0: @00000000371f33e0 00000000 00000000 00000000 00000000
[    8.829193] xhci_hcd 0000:05:00.0: @00000000371f33f0 371f3000 00000000 00000000 00001802
[    8.829195] xhci_hcd 0000:05:00.0:   Ring has not been updated
[    8.829197] xhci_hcd 0000:05:00.0: Ring deq = f71f3000 (virt), 0x371f3000 (dma)
[    8.829198] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[    8.829200] xhci_hcd 0000:05:00.0: Ring enq = f71f3000 (virt), 0x371f3000 (dma)
[    8.829202] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[    8.829206] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000000
[    8.829208] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[    8.829210] xhci_hcd 0000:05:00.0: ERST memory map follows:
[    8.829212] xhci_hcd 0000:05:00.0: @000000003704d000 371f3400 00000000 00000040 00000000
[    8.829213] xhci_hcd 0000:05:00.0: Event ring:
[    8.829215] xhci_hcd 0000:05:00.0: @00000000371f3400 00000000 00000000 00000000 00000000
[    8.829217] xhci_hcd 0000:05:00.0: @00000000371f3410 00000000 00000000 00000000 00000000
[    8.829219] xhci_hcd 0000:05:00.0: @00000000371f3420 00000000 00000000 00000000 00000000
[    8.829221] xhci_hcd 0000:05:00.0: @00000000371f3430 00000000 00000000 00000000 00000000
[    8.829223] xhci_hcd 0000:05:00.0: @00000000371f3440 00000000 00000000 00000000 00000000
[    8.829225] xhci_hcd 0000:05:00.0: @00000000371f3450 00000000 00000000 00000000 00000000
[    8.829227] xhci_hcd 0000:05:00.0: @00000000371f3460 00000000 00000000 00000000 00000000
[    8.829229] xhci_hcd 0000:05:00.0: @00000000371f3470 00000000 00000000 00000000 00000000
[    8.829231] xhci_hcd 0000:05:00.0: @00000000371f3480 00000000 00000000 00000000 00000000
[    8.829233] xhci_hcd 0000:05:00.0: @00000000371f3490 00000000 00000000 00000000 00000000
[    8.829235] xhci_hcd 0000:05:00.0: @00000000371f34a0 00000000 00000000 00000000 00000000
[    8.829237] xhci_hcd 0000:05:00.0: @00000000371f34b0 00000000 00000000 00000000 00000000
[    8.829239] xhci_hcd 0000:05:00.0: @00000000371f34c0 00000000 00000000 00000000 00000000
[    8.829241] xhci_hcd 0000:05:00.0: @00000000371f34d0 00000000 00000000 00000000 00000000
[    8.829243] xhci_hcd 0000:05:00.0: @00000000371f34e0 00000000 00000000 00000000 00000000
[    8.829245] xhci_hcd 0000:05:00.0: @00000000371f34f0 00000000 00000000 00000000 00000000
[    8.829247] xhci_hcd 0000:05:00.0: @00000000371f3500 00000000 00000000 00000000 00000000
[    8.829249] xhci_hcd 0000:05:00.0: @00000000371f3510 00000000 00000000 00000000 00000000
[    8.829251] xhci_hcd 0000:05:00.0: @00000000371f3520 00000000 00000000 00000000 00000000
[    8.829254] xhci_hcd 0000:05:00.0: @00000000371f3530 00000000 00000000 00000000 00000000
[    8.829256] xhci_hcd 0000:05:00.0: @00000000371f3540 00000000 00000000 00000000 00000000
[    8.829258] xhci_hcd 0000:05:00.0: @00000000371f3550 00000000 00000000 00000000 00000000
[    8.829260] xhci_hcd 0000:05:00.0: @00000000371f3560 00000000 00000000 00000000 00000000
[    8.829262] xhci_hcd 0000:05:00.0: @00000000371f3570 00000000 00000000 00000000 00000000
[    8.829264] xhci_hcd 0000:05:00.0: @00000000371f3580 00000000 00000000 00000000 00000000
[    8.829266] xhci_hcd 0000:05:00.0: @00000000371f3590 00000000 00000000 00000000 00000000
[    8.829268] xhci_hcd 0000:05:00.0: @00000000371f35a0 00000000 00000000 00000000 00000000
[    8.829270] xhci_hcd 0000:05:00.0: @00000000371f35b0 00000000 00000000 00000000 00000000
[    8.829272] xhci_hcd 0000:05:00.0: @00000000371f35c0 00000000 00000000 00000000 00000000
[    8.829274] xhci_hcd 0000:05:00.0: @00000000371f35d0 00000000 00000000 00000000 00000000
[    8.829276] xhci_hcd 0000:05:00.0: @00000000371f35e0 00000000 00000000 00000000 00000000
[    8.829278] xhci_hcd 0000:05:00.0: @00000000371f35f0 00000000 00000000 00000000 00000000
[    8.829280] xhci_hcd 0000:05:00.0: @00000000371f3600 00000000 00000000 00000000 00000000
[    8.829282] xhci_hcd 0000:05:00.0: @00000000371f3610 00000000 00000000 00000000 00000000
[    8.829284] xhci_hcd 0000:05:00.0: @00000000371f3620 00000000 00000000 00000000 00000000
[    8.829286] xhci_hcd 0000:05:00.0: @00000000371f3630 00000000 00000000 00000000 00000000
[    8.829288] xhci_hcd 0000:05:00.0: @00000000371f3640 00000000 00000000 00000000 00000000
[    8.829290] xhci_hcd 0000:05:00.0: @00000000371f3650 00000000 00000000 00000000 00000000
[    8.829292] xhci_hcd 0000:05:00.0: @00000000371f3660 00000000 00000000 00000000 00000000
[    8.829294] xhci_hcd 0000:05:00.0: @00000000371f3670 00000000 00000000 00000000 00000000
[    8.829296] xhci_hcd 0000:05:00.0: @00000000371f3680 00000000 00000000 00000000 00000000
[    8.829298] xhci_hcd 0000:05:00.0: @00000000371f3690 00000000 00000000 00000000 00000000
[    8.829300] xhci_hcd 0000:05:00.0: @00000000371f36a0 00000000 00000000 00000000 00000000
[    8.829302] xhci_hcd 0000:05:00.0: @00000000371f36b0 00000000 00000000 00000000 00000000
[    8.829304] xhci_hcd 0000:05:00.0: @00000000371f36c0 00000000 00000000 00000000 00000000
[    8.829306] xhci_hcd 0000:05:00.0: @00000000371f36d0 00000000 00000000 00000000 00000000
[    8.829308] xhci_hcd 0000:05:00.0: @00000000371f36e0 00000000 00000000 00000000 00000000
[    8.829310] xhci_hcd 0000:05:00.0: @00000000371f36f0 00000000 00000000 00000000 00000000
[    8.829312] xhci_hcd 0000:05:00.0: @00000000371f3700 00000000 00000000 00000000 00000000
[    8.829314] xhci_hcd 0000:05:00.0: @00000000371f3710 00000000 00000000 00000000 00000000
[    8.829316] xhci_hcd 0000:05:00.0: @00000000371f3720 00000000 00000000 00000000 00000000
[    8.829318] xhci_hcd 0000:05:00.0: @00000000371f3730 00000000 00000000 00000000 00000000
[    8.829320] xhci_hcd 0000:05:00.0: @00000000371f3740 00000000 00000000 00000000 00000000
[    8.829322] xhci_hcd 0000:05:00.0: @00000000371f3750 00000000 00000000 00000000 00000000
[    8.829324] xhci_hcd 0000:05:00.0: @00000000371f3760 00000000 00000000 00000000 00000000
[    8.829326] xhci_hcd 0000:05:00.0: @00000000371f3770 00000000 00000000 00000000 00000000
[    8.829328] xhci_hcd 0000:05:00.0: @00000000371f3780 00000000 00000000 00000000 00000000
[    8.829330] xhci_hcd 0000:05:00.0: @00000000371f3790 00000000 00000000 00000000 00000000
[    8.829332] xhci_hcd 0000:05:00.0: @00000000371f37a0 00000000 00000000 00000000 00000000
[    8.829334] xhci_hcd 0000:05:00.0: @00000000371f37b0 00000000 00000000 00000000 00000000
[    8.829336] xhci_hcd 0000:05:00.0: @00000000371f37c0 00000000 00000000 00000000 00000000
[    8.829338] xhci_hcd 0000:05:00.0: @00000000371f37d0 00000000 00000000 00000000 00000000
[    8.829340] xhci_hcd 0000:05:00.0: @00000000371f37e0 00000000 00000000 00000000 00000000
[    8.829342] xhci_hcd 0000:05:00.0: @00000000371f37f0 00000000 00000000 00000000 00000000
[    8.829344] xhci_hcd 0000:05:00.0:   Ring has not been updated
[    8.829345] xhci_hcd 0000:05:00.0: Ring deq = f71f3400 (virt), 0x371f3400 (dma)
[    8.829347] xhci_hcd 0000:05:00.0: Ring deq updated 0 times
[    8.829349] xhci_hcd 0000:05:00.0: Ring enq = f71f3400 (virt), 0x371f3400 (dma)
[    8.829350] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[    8.829355] xhci_hcd 0000:05:00.0: ERST deq = 64'h371f3400
[    8.829357] xhci_hcd 0000:05:00.0: // Set the interrupt modulation register
[    8.829362] xhci_hcd 0000:05:00.0: // Enable interrupts, cmd = 0x4.
[    8.829365] xhci_hcd 0000:05:00.0: // Enabling event ring interrupter f8054620 by writing 0x2 to irq_pending
[    8.829369] xhci_hcd 0000:05:00.0:   f8054620: ir_set[0]
[    8.829371] xhci_hcd 0000:05:00.0:   f8054620: ir_set.pending = 0x2
[    8.829374] xhci_hcd 0000:05:00.0:   f8054624: ir_set.control = 0xa0
[    8.829378] xhci_hcd 0000:05:00.0:   f8054628: ir_set.erst_size = 0x1
[    8.829384] xhci_hcd 0000:05:00.0:   f8054630: ir_set.erst_base = @3704d000
[    8.829390] xhci_hcd 0000:05:00.0:   f8054638: ir_set.erst_dequeue = @371f3400
[    8.829391] xhci_hcd 0000:05:00.0: Finished xhci_run for USB2 roothub
[    8.829584] xHCI xhci_add_endpoint called for root hub
[    8.829589] xHCI xhci_check_bandwidth called for root hub
[    8.829645] hub 3-0:1.0: USB hub found
[    8.829653] hub 3-0:1.0: 2 ports detected
[    8.829663] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[    8.829671] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[    8.829730] xhci_hcd 0000:05:00.0: xHCI Host Controller
[    8.829854] xhci_hcd 0000:05:00.0: new USB bus registered, assigned bus number 4
[    8.829866] xhci_hcd 0000:05:00.0: Enabling 64-bit DMA addresses.
[    8.829873] xhci_hcd 0000:05:00.0: // Turn on HC, cmd = 0x5.
[    8.831934] xhci_hcd 0000:05:00.0: // Ding dong!
[    8.831937] xhci_hcd 0000:05:00.0: Finished xhci_run for USB3 roothub
[    8.832116] xhci_hcd 0000:05:00.0: Vendor specific event TRB type = 48
[    8.832125] xhci_hcd 0000:05:00.0: NEC firmware version 30.25
[    8.832132] xHCI xhci_add_endpoint called for root hub
[    8.832134] xHCI xhci_check_bandwidth called for root hub
[    8.832167] hub 4-0:1.0: USB hub found
[    8.832178] hub 4-0:1.0: 2 ports detected
[    8.832191] xhci_hcd 0000:05:00.0: set port power, actual port 0 status  = 0x2a0
[    8.832206] xhci_hcd 0000:05:00.0: set port power, actual port 1 status  = 0x2a0
[    8.886575] sony_laptop: Sony Notebook Control Driver v0.6
[    8.895629] input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/SNY5001:00/input/input4
[    8.895753] input: Sony Vaio Jogdial as /devices/virtual/input/input5
[    8.895872] sony_laptop: brightness ignored, must be controlled by ACPI video driver
[    8.929132] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[    8.929141] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[    8.929153] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[    8.929158] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[    8.929174] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[    8.929181] xhci_hcd 0000:05:00.0: Get port status returned 0x2a0
[    8.929188] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[    8.929191] xhci_hcd 0000:05:00.0: Get port status returned 0x2a0
[    9.034488] [drm] Initialized drm 1.1.0 20060810
[    9.150914] input: ImPS/2 Generic Wheel Mouse as /devices/platform/i8042/serio1/input/input6
[    9.178694] MXM: GUID detected in BIOS
[    9.178734] nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.178739] nouveau 0000:01:00.0: setting latency timer to 64
[    9.180266] [drm] nouveau 0000:01:00.0: Detected an NVc0 generation card (0x0c1800a1)
[    9.180270] [drm] nouveau 0000:01:00.0: acceleration disabled by default, pass noaccel=0 to force enable
[    9.183669] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
[    9.246641] [drm] nouveau 0000:01:00.0: ... appears to be valid
[    9.246644] [drm] nouveau 0000:01:00.0: BIT BIOS found
[    9.246646] [drm] nouveau 0000:01:00.0: Bios version 70.08.19.00
[    9.246649] [drm] nouveau 0000:01:00.0: TMDS table version 2.0
[    9.246650] [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 4.0
[    9.246653] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 010003f3 00010036
[    9.246655] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 02011300 00000000
[    9.246656] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02422362 00020010
[    9.246658] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 0000000e 00000000
[    9.246660] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 4
[    9.246662] [drm] nouveau 0000:01:00.0:   0: 0x00000040: type 0x40 idx 0 tag 0xff
[    9.246664] [drm] nouveau 0000:01:00.0:   1: 0x00000100: type 0x00 idx 1 tag 0xff
[    9.246666] [drm] nouveau 0000:01:00.0:   2: 0x00002261: type 0x61 idx 2 tag 0x08
[    9.246670] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xD2F9
[    9.266764] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xD93F
[    9.273753] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xEAD4
[    9.273756] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xEAD8
[    9.273800] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xEBC0
[    9.273802] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0xEC25
[    9.293640] [drm] nouveau 0000:01:00.0: 0xD273: Condition still not met after 20ms, skipping following opcodes
[    9.313020] [drm] nouveau 0000:01:00.0: 3 available performance level(s)
[    9.313023] [drm] nouveau 0000:01:00.0: 0: memory 135MHz core 50MHz shader 101MHz voltage 830mV timing 0
[    9.313026] [drm] nouveau 0000:01:00.0: 1: memory 324MHz core 202MHz shader 405MHz voltage 830mV timing 1
[    9.313029] [drm] nouveau 0000:01:00.0: 3: memory 800MHz core 560MHz shader 1120MHz voltage 900mV timing 2
[    9.319455] [TTM] Zone  kernel: Available graphics memory: 363864 kiB.
[    9.319461] [TTM] Zone highmem: Available graphics memory: 1603582 kiB.
[    9.319465] [TTM] Initializing pool allocator.
[    9.319479] [drm] nouveau 0000:01:00.0: Detected 512MiB VRAM
[    9.322085] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[    9.332178] [drm] nouveau 0000:01:00.0: ACPI backlight interface available, not registering our own
[    9.334100] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    9.334101] [drm] No driver support for vblank timestamp query.
[    9.402339] [drm] nouveau 0000:01:00.0: allocated 1920x1080 fb: 0xc0000, bo f6b5b800
[    9.402467] fbcon: nouveaufb (fb0) is primary device
[    9.454525] Linux video capture interface: v2.00
[    9.541446] uvcvideo: Found UVC 1.00 device <unnamed> (064e:2100)
[    9.543110] input: UVC Camera (064e:2100) as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.0/input/input7
[    9.543185] usbcore: registered new interface driver uvcvideo
[    9.543187] USB Video Class driver (1.1.1)
[    9.722570] EDAC MC: Ver: 2.1.0
[    9.731612] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core #0': DEV 0000:3f:03.0
[    9.731653] EDAC PCI0: Giving out device to module 'i7core_edac' controller 'EDAC PCI controller': DEV '0000:3f:03.0' (POLLED)
[    9.731657] EDAC i7core: Driver loaded.
[    9.753056] Bluetooth: Core ver 2.16
[    9.753075] NET: Registered protocol family 31
[    9.753077] Bluetooth: HCI device and connection manager initialized
[    9.753080] Bluetooth: HCI socket layer initialized
[    9.753082] Bluetooth: L2CAP socket layer initialized
[    9.753087] Bluetooth: SCO socket layer initialized
[    9.768344] Bluetooth: Generic Bluetooth USB driver ver 0.6
[   10.476727] Console: switching to colour frame buffer device 240x67
[   10.487279] fb0: nouveaufb frame buffer device
[   10.487280] drm: registered panic notifier
[   10.487286] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on minor 0
[   11.062179] usbcore: registered new interface driver btusb
[   11.330761] snd_hda_intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   11.330823] snd_hda_intel 0000:00:1b.0: irq 56 for MSI/MSI-X
[   11.330861] snd_hda_intel 0000:00:1b.0: setting latency timer to 64
[   11.587547] hda_codec: ALC275: BIOS auto-probing.
[   11.591485] input: HDA Intel Mic as /devices/pci0000:00/0000:00:1b.0/sound/card0/input8
[   11.591563] input: HDA Intel Headphone as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   11.591715] snd_hda_intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   11.591718] hda_intel: Disabling MSI
[   11.591746] snd_hda_intel 0000:01:00.1: setting latency timer to 64
[   12.090826] type=1400 audit(1325070997.381:2): apparmor="STATUS" operation="profile_load" name="/sbin/dhclient" pid=601 comm="apparmor_parser"
[   12.090909] type=1400 audit(1325070997.381:3): apparmor="STATUS" operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=601 comm="apparmor_parser"
[   12.090986] type=1400 audit(1325070997.381:4): apparmor="STATUS" operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" pid=601 comm="apparmor_parser"
[   12.091193] type=1400 audit(1325070997.381:5): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=598 comm="apparmor_parser"
[   12.091278] type=1400 audit(1325070997.381:6): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=598 comm="apparmor_parser"
[   12.091356] type=1400 audit(1325070997.381:7): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=598 comm="apparmor_parser"
[   12.212549] init: rsyslog main process (798) terminated with status 2
[   12.212573] init: rsyslog main process ended, respawning
[   12.275752] HDMI status: Codec=0 Pin=5 Presence_Detect=0 ELD_Valid=0
[   12.383814] HDMI status: Codec=1 Pin=5 Presence_Detect=0 ELD_Valid=0
[   12.487726] HDMI status: Codec=2 Pin=5 Presence_Detect=0 ELD_Valid=0
[   12.591652] HDMI status: Codec=3 Pin=5 Presence_Detect=0 ELD_Valid=0
[   12.639977] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input10
[   12.640062] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input11
[   12.640143] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input12
[   12.640223] input: HDA NVidia HDMI/DP as /devices/pci0000:00/0000:00:03.0/0000:01:00.1/sound/card1/input13
[   15.981625] ppdev: user-space parallel port driver
[   16.727361] type=1400 audit(1325071002.021:8): apparmor="STATUS" operation="profile_replace" name="/sbin/dhclient" pid=974 comm="apparmor_parser"
[   16.727495] type=1400 audit(1325071002.021:9): apparmor="STATUS" operation="profile_replace" name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=974 comm="apparmor_parser"
[   16.727627] type=1400 audit(1325071002.021:10): apparmor="STATUS" operation="profile_replace" name="/usr/lib/connman/scripts/dhclient-script" pid=974 comm="apparmor_parser"
[   16.767559] type=1400 audit(1325071002.061:11): apparmor="STATUS" operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" pid=972 comm="apparmor_parser"
[   17.142281] audit_printk_skb: 12 callbacks suppressed
[   17.142285] type=1400 audit(1325071002.437:16): apparmor="STATUS" operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf" pid=978 comm="apparmor_parser"
[   17.142481] type=1400 audit(1325071002.437:17): apparmor="STATUS" operation="profile_replace" name="/usr/sbin/cupsd" pid=978 comm="apparmor_parser"
[   17.238629] sky2 0000:04:00.0: eth0: enabling interface
[   17.238870] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.317188] type=1400 audit(1325071002.609:18): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/mission-control-5" pid=977 comm="apparmor_parser"
[   17.317335] type=1400 audit(1325071002.609:19): apparmor="STATUS" operation="profile_load" name="/usr/lib/telepathy/telepathy-*" pid=977 comm="apparmor_parser"
[   21.879107] type=1400 audit(1325071007.173:20): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince" pid=975 comm="apparmor_parser"
[   21.879821] type=1400 audit(1325071007.177:21): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-previewer" pid=975 comm="apparmor_parser"
[   21.880504] type=1400 audit(1325071007.177:22): apparmor="STATUS" operation="profile_load" name="/usr/bin/evince-thumbnailer" pid=975 comm="apparmor_parser"
[   22.121929] init: failsafe main process (853) killed by TERM signal
[   22.150114] init: gdm main process (1046) killed by TERM signal
[   22.215001] init: apport pre-start process (1029) terminated with status 1
[   22.217504] init: apport post-stop process (1057) terminated with status 1
[   24.765015] Bluetooth: RFCOMM TTY layer initialized
[   24.765026] Bluetooth: RFCOMM socket layer initialized
[   24.765031] Bluetooth: RFCOMM ver 1.11
[   24.805111] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   24.805114] Bluetooth: BNEP filters: protocol multicast
[   30.265054] init: plymouth-stop pre-start process (1407) terminated with status 1
[   33.607390] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   33.607393] xhci_hcd 0000:05:00.0: Get port status returned 0x2a0
[   33.607400] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   33.607402] xhci_hcd 0000:05:00.0: Get port status returned 0x2a0
[   33.623274] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[   33.623277] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   33.623402] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[   33.623407] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[   68.915718] xhci_hcd 0000:05:00.0: Poll event ring: 4294909472
[   68.915734] xhci_hcd 0000:05:00.0: op reg status = 0x0
[   68.915741] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[   68.915745] xhci_hcd 0000:05:00.0: HC error bitmask = 0x4
[   68.915747] xhci_hcd 0000:05:00.0: Event ring:
[   68.915750] xhci_hcd 0000:05:00.0: @00000000371f3400 371f3000 00000000 01003025 0000c001
[   68.915754] xhci_hcd 0000:05:00.0: @00000000371f3410 00000000 00000000 00000000 00000000
[   68.915757] xhci_hcd 0000:05:00.0: @00000000371f3420 00000000 00000000 00000000 00000000
[   68.915760] xhci_hcd 0000:05:00.0: @00000000371f3430 00000000 00000000 00000000 00000000
[   68.915764] xhci_hcd 0000:05:00.0: @00000000371f3440 00000000 00000000 00000000 00000000
[   68.915767] xhci_hcd 0000:05:00.0: @00000000371f3450 00000000 00000000 00000000 00000000
[   68.915770] xhci_hcd 0000:05:00.0: @00000000371f3460 00000000 00000000 00000000 00000000
[   68.915773] xhci_hcd 0000:05:00.0: @00000000371f3470 00000000 00000000 00000000 00000000
[   68.915777] xhci_hcd 0000:05:00.0: @00000000371f3480 00000000 00000000 00000000 00000000
[   68.915780] xhci_hcd 0000:05:00.0: @00000000371f3490 00000000 00000000 00000000 00000000
[   68.915785] xhci_hcd 0000:05:00.0: @00000000371f34a0 00000000 00000000 00000000 00000000
[   68.915788] xhci_hcd 0000:05:00.0: @00000000371f34b0 00000000 00000000 00000000 00000000
[   68.915790] xhci_hcd 0000:05:00.0: @00000000371f34c0 00000000 00000000 00000000 00000000
[   68.915792] xhci_hcd 0000:05:00.0: @00000000371f34d0 00000000 00000000 00000000 00000000
[   68.915795] xhci_hcd 0000:05:00.0: @00000000371f34e0 00000000 00000000 00000000 00000000
[   68.915797] xhci_hcd 0000:05:00.0: @00000000371f34f0 00000000 00000000 00000000 00000000
[   68.915799] xhci_hcd 0000:05:00.0: @00000000371f3500 00000000 00000000 00000000 00000000
[   68.915802] xhci_hcd 0000:05:00.0: @00000000371f3510 00000000 00000000 00000000 00000000
[   68.915804] xhci_hcd 0000:05:00.0: @00000000371f3520 00000000 00000000 00000000 00000000
[   68.915806] xhci_hcd 0000:05:00.0: @00000000371f3530 00000000 00000000 00000000 00000000
[   68.915809] xhci_hcd 0000:05:00.0: @00000000371f3540 00000000 00000000 00000000 00000000
[   68.915811] xhci_hcd 0000:05:00.0: @00000000371f3550 00000000 00000000 00000000 00000000
[   68.915814] xhci_hcd 0000:05:00.0: @00000000371f3560 00000000 00000000 00000000 00000000
[   68.915816] xhci_hcd 0000:05:00.0: @00000000371f3570 00000000 00000000 00000000 00000000
[   68.915818] xhci_hcd 0000:05:00.0: @00000000371f3580 00000000 00000000 00000000 00000000
[   68.915821] xhci_hcd 0000:05:00.0: @00000000371f3590 00000000 00000000 00000000 00000000
[   68.915823] xhci_hcd 0000:05:00.0: @00000000371f35a0 00000000 00000000 00000000 00000000
[   68.915825] xhci_hcd 0000:05:00.0: @00000000371f35b0 00000000 00000000 00000000 00000000
[   68.915828] xhci_hcd 0000:05:00.0: @00000000371f35c0 00000000 00000000 00000000 00000000
[   68.915830] xhci_hcd 0000:05:00.0: @00000000371f35d0 00000000 00000000 00000000 00000000
[   68.915833] xhci_hcd 0000:05:00.0: @00000000371f35e0 00000000 00000000 00000000 00000000
[   68.915835] xhci_hcd 0000:05:00.0: @00000000371f35f0 00000000 00000000 00000000 00000000
[   68.915837] xhci_hcd 0000:05:00.0: @00000000371f3600 00000000 00000000 00000000 00000000
[   68.915840] xhci_hcd 0000:05:00.0: @00000000371f3610 00000000 00000000 00000000 00000000
[   68.915842] xhci_hcd 0000:05:00.0: @00000000371f3620 00000000 00000000 00000000 00000000
[   68.915844] xhci_hcd 0000:05:00.0: @00000000371f3630 00000000 00000000 00000000 00000000
[   68.915847] xhci_hcd 0000:05:00.0: @00000000371f3640 00000000 00000000 00000000 00000000
[   68.915849] xhci_hcd 0000:05:00.0: @00000000371f3650 00000000 00000000 00000000 00000000
[   68.915851] xhci_hcd 0000:05:00.0: @00000000371f3660 00000000 00000000 00000000 00000000
[   68.915854] xhci_hcd 0000:05:00.0: @00000000371f3670 00000000 00000000 00000000 00000000
[   68.915856] xhci_hcd 0000:05:00.0: @00000000371f3680 00000000 00000000 00000000 00000000
[   68.915859] xhci_hcd 0000:05:00.0: @00000000371f3690 00000000 00000000 00000000 00000000
[   68.915861] xhci_hcd 0000:05:00.0: @00000000371f36a0 00000000 00000000 00000000 00000000
[   68.915863] xhci_hcd 0000:05:00.0: @00000000371f36b0 00000000 00000000 00000000 00000000
[   68.915866] xhci_hcd 0000:05:00.0: @00000000371f36c0 00000000 00000000 00000000 00000000
[   68.915868] xhci_hcd 0000:05:00.0: @00000000371f36d0 00000000 00000000 00000000 00000000
[   68.915870] xhci_hcd 0000:05:00.0: @00000000371f36e0 00000000 00000000 00000000 00000000
[   68.915873] xhci_hcd 0000:05:00.0: @00000000371f36f0 00000000 00000000 00000000 00000000
[   68.915875] xhci_hcd 0000:05:00.0: @00000000371f3700 00000000 00000000 00000000 00000000
[   68.915878] xhci_hcd 0000:05:00.0: @00000000371f3710 00000000 00000000 00000000 00000000
[   68.915880] xhci_hcd 0000:05:00.0: @00000000371f3720 00000000 00000000 00000000 00000000
[   68.915882] xhci_hcd 0000:05:00.0: @00000000371f3730 00000000 00000000 00000000 00000000
[   68.915885] xhci_hcd 0000:05:00.0: @00000000371f3740 00000000 00000000 00000000 00000000
[   68.915887] xhci_hcd 0000:05:00.0: @00000000371f3750 00000000 00000000 00000000 00000000
[   68.915889] xhci_hcd 0000:05:00.0: @00000000371f3760 00000000 00000000 00000000 00000000
[   68.915892] xhci_hcd 0000:05:00.0: @00000000371f3770 00000000 00000000 00000000 00000000
[   68.915894] xhci_hcd 0000:05:00.0: @00000000371f3780 00000000 00000000 00000000 00000000
[   68.915896] xhci_hcd 0000:05:00.0: @00000000371f3790 00000000 00000000 00000000 00000000
[   68.915899] xhci_hcd 0000:05:00.0: @00000000371f37a0 00000000 00000000 00000000 00000000
[   68.915901] xhci_hcd 0000:05:00.0: @00000000371f37b0 00000000 00000000 00000000 00000000
[   68.915904] xhci_hcd 0000:05:00.0: @00000000371f37c0 00000000 00000000 00000000 00000000
[   68.915906] xhci_hcd 0000:05:00.0: @00000000371f37d0 00000000 00000000 00000000 00000000
[   68.915908] xhci_hcd 0000:05:00.0: @00000000371f37e0 00000000 00000000 00000000 00000000
[   68.915911] xhci_hcd 0000:05:00.0: @00000000371f37f0 00000000 00000000 00000000 00000000
[   68.915913] xhci_hcd 0000:05:00.0: Ring deq = f71f3410 (virt), 0x371f3410 (dma)
[   68.915915] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[   68.915917] xhci_hcd 0000:05:00.0: Ring enq = f71f3400 (virt), 0x371f3400 (dma)
[   68.915919] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[   68.915927] xhci_hcd 0000:05:00.0: ERST deq = 64'h371f3410
[   68.915928] xhci_hcd 0000:05:00.0: Command ring:
[   68.915931] xhci_hcd 0000:05:00.0: @00000000371f3000 00000000 00000000 00000000 0000c401
[   68.915933] xhci_hcd 0000:05:00.0: @00000000371f3010 00000000 00000000 00000000 00000000
[   68.915935] xhci_hcd 0000:05:00.0: @00000000371f3020 00000000 00000000 00000000 00000000
[   68.915938] xhci_hcd 0000:05:00.0: @00000000371f3030 00000000 00000000 00000000 00000000
[   68.915940] xhci_hcd 0000:05:00.0: @00000000371f3040 00000000 00000000 00000000 00000000
[   68.915943] xhci_hcd 0000:05:00.0: @00000000371f3050 00000000 00000000 00000000 00000000
[   68.915945] xhci_hcd 0000:05:00.0: @00000000371f3060 00000000 00000000 00000000 00000000
[   68.915947] xhci_hcd 0000:05:00.0: @00000000371f3070 00000000 00000000 00000000 00000000
[   68.915950] xhci_hcd 0000:05:00.0: @00000000371f3080 00000000 00000000 00000000 00000000
[   68.915952] xhci_hcd 0000:05:00.0: @00000000371f3090 00000000 00000000 00000000 00000000
[   68.915954] xhci_hcd 0000:05:00.0: @00000000371f30a0 00000000 00000000 00000000 00000000
[   68.915957] xhci_hcd 0000:05:00.0: @00000000371f30b0 00000000 00000000 00000000 00000000
[   68.915959] xhci_hcd 0000:05:00.0: @00000000371f30c0 00000000 00000000 00000000 00000000
[   68.915962] xhci_hcd 0000:05:00.0: @00000000371f30d0 00000000 00000000 00000000 00000000
[   68.915964] xhci_hcd 0000:05:00.0: @00000000371f30e0 00000000 00000000 00000000 00000000
[   68.915966] xhci_hcd 0000:05:00.0: @00000000371f30f0 00000000 00000000 00000000 00000000
[   68.915969] xhci_hcd 0000:05:00.0: @00000000371f3100 00000000 00000000 00000000 00000000
[   68.915971] xhci_hcd 0000:05:00.0: @00000000371f3110 00000000 00000000 00000000 00000000
[   68.915973] xhci_hcd 0000:05:00.0: @00000000371f3120 00000000 00000000 00000000 00000000
[   68.915976] xhci_hcd 0000:05:00.0: @00000000371f3130 00000000 00000000 00000000 00000000
[   68.915978] xhci_hcd 0000:05:00.0: @00000000371f3140 00000000 00000000 00000000 00000000
[   68.915980] xhci_hcd 0000:05:00.0: @00000000371f3150 00000000 00000000 00000000 00000000
[   68.915983] xhci_hcd 0000:05:00.0: @00000000371f3160 00000000 00000000 00000000 00000000
[   68.915985] xhci_hcd 0000:05:00.0: @00000000371f3170 00000000 00000000 00000000 00000000
[   68.915988] xhci_hcd 0000:05:00.0: @00000000371f3180 00000000 00000000 00000000 00000000
[   68.915990] xhci_hcd 0000:05:00.0: @00000000371f3190 00000000 00000000 00000000 00000000
[   68.915992] xhci_hcd 0000:05:00.0: @00000000371f31a0 00000000 00000000 00000000 00000000
[   68.915995] xhci_hcd 0000:05:00.0: @00000000371f31b0 00000000 00000000 00000000 00000000
[   68.915997] xhci_hcd 0000:05:00.0: @00000000371f31c0 00000000 00000000 00000000 00000000
[   68.915999] xhci_hcd 0000:05:00.0: @00000000371f31d0 00000000 00000000 00000000 00000000
[   68.916002] xhci_hcd 0000:05:00.0: @00000000371f31e0 00000000 00000000 00000000 00000000
[   68.916004] xhci_hcd 0000:05:00.0: @00000000371f31f0 00000000 00000000 00000000 00000000
[   68.916007] xhci_hcd 0000:05:00.0: @00000000371f3200 00000000 00000000 00000000 00000000
[   68.916009] xhci_hcd 0000:05:00.0: @00000000371f3210 00000000 00000000 00000000 00000000
[   68.916011] xhci_hcd 0000:05:00.0: @00000000371f3220 00000000 00000000 00000000 00000000
[   68.916014] xhci_hcd 0000:05:00.0: @00000000371f3230 00000000 00000000 00000000 00000000
[   68.916016] xhci_hcd 0000:05:00.0: @00000000371f3240 00000000 00000000 00000000 00000000
[   68.916018] xhci_hcd 0000:05:00.0: @00000000371f3250 00000000 00000000 00000000 00000000
[   68.916021] xhci_hcd 0000:05:00.0: @00000000371f3260 00000000 00000000 00000000 00000000
[   68.916023] xhci_hcd 0000:05:00.0: @00000000371f3270 00000000 00000000 00000000 00000000
[   68.916025] xhci_hcd 0000:05:00.0: @00000000371f3280 00000000 00000000 00000000 00000000
[   68.916028] xhci_hcd 0000:05:00.0: @00000000371f3290 00000000 00000000 00000000 00000000
[   68.916030] xhci_hcd 0000:05:00.0: @00000000371f32a0 00000000 00000000 00000000 00000000
[   68.916033] xhci_hcd 0000:05:00.0: @00000000371f32b0 00000000 00000000 00000000 00000000
[   68.916035] xhci_hcd 0000:05:00.0: @00000000371f32c0 00000000 00000000 00000000 00000000
[   68.916037] xhci_hcd 0000:05:00.0: @00000000371f32d0 00000000 00000000 00000000 00000000
[   68.916040] xhci_hcd 0000:05:00.0: @00000000371f32e0 00000000 00000000 00000000 00000000
[   68.916042] xhci_hcd 0000:05:00.0: @00000000371f32f0 00000000 00000000 00000000 00000000
[   68.916044] xhci_hcd 0000:05:00.0: @00000000371f3300 00000000 00000000 00000000 00000000
[   68.916047] xhci_hcd 0000:05:00.0: @00000000371f3310 00000000 00000000 00000000 00000000
[   68.916049] xhci_hcd 0000:05:00.0: @00000000371f3320 00000000 00000000 00000000 00000000
[   68.916052] xhci_hcd 0000:05:00.0: @00000000371f3330 00000000 00000000 00000000 00000000
[   68.916054] xhci_hcd 0000:05:00.0: @00000000371f3340 00000000 00000000 00000000 00000000
[   68.916056] xhci_hcd 0000:05:00.0: @00000000371f3350 00000000 00000000 00000000 00000000
[   68.916059] xhci_hcd 0000:05:00.0: @00000000371f3360 00000000 00000000 00000000 00000000
[   68.916061] xhci_hcd 0000:05:00.0: @00000000371f3370 00000000 00000000 00000000 00000000
[   68.916063] xhci_hcd 0000:05:00.0: @00000000371f3380 00000000 00000000 00000000 00000000
[   68.916066] xhci_hcd 0000:05:00.0: @00000000371f3390 00000000 00000000 00000000 00000000
[   68.916068] xhci_hcd 0000:05:00.0: @00000000371f33a0 00000000 00000000 00000000 00000000
[   68.916070] xhci_hcd 0000:05:00.0: @00000000371f33b0 00000000 00000000 00000000 00000000
[   68.916073] xhci_hcd 0000:05:00.0: @00000000371f33c0 00000000 00000000 00000000 00000000
[   68.916075] xhci_hcd 0000:05:00.0: @00000000371f33d0 00000000 00000000 00000000 00000000
[   68.916078] xhci_hcd 0000:05:00.0: @00000000371f33e0 00000000 00000000 00000000 00000000
[   68.916080] xhci_hcd 0000:05:00.0: @00000000371f33f0 371f3000 00000000 00000000 00001802
[   68.916082] xhci_hcd 0000:05:00.0: Ring deq = f71f3010 (virt), 0x371f3010 (dma)
[   68.916084] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[   68.916086] xhci_hcd 0000:05:00.0: Ring enq = f71f3010 (virt), 0x371f3010 (dma)
[   68.916088] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[   68.916095] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[   68.916097] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  128.922281] xhci_hcd 0000:05:00.0: Poll event ring: 4294924480
[  128.922287] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  128.922291] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  128.922293] xhci_hcd 0000:05:00.0: HC error bitmask = 0x0
[  128.922294] xhci_hcd 0000:05:00.0: Event ring:
[  128.922297] xhci_hcd 0000:05:00.0: @00000000371f3400 371f3000 00000000 01003025 0000c001
[  128.922299] xhci_hcd 0000:05:00.0: @00000000371f3410 00000000 00000000 00000000 00000000
[  128.922301] xhci_hcd 0000:05:00.0: @00000000371f3420 00000000 00000000 00000000 00000000
[  128.922303] xhci_hcd 0000:05:00.0: @00000000371f3430 00000000 00000000 00000000 00000000
[  128.922305] xhci_hcd 0000:05:00.0: @00000000371f3440 00000000 00000000 00000000 00000000
[  128.922307] xhci_hcd 0000:05:00.0: @00000000371f3450 00000000 00000000 00000000 00000000
[  128.922309] xhci_hcd 0000:05:00.0: @00000000371f3460 00000000 00000000 00000000 00000000
[  128.922311] xhci_hcd 0000:05:00.0: @00000000371f3470 00000000 00000000 00000000 00000000
[  128.922313] xhci_hcd 0000:05:00.0: @00000000371f3480 00000000 00000000 00000000 00000000
[  128.922315] xhci_hcd 0000:05:00.0: @00000000371f3490 00000000 00000000 00000000 00000000
[  128.922317] xhci_hcd 0000:05:00.0: @00000000371f34a0 00000000 00000000 00000000 00000000
[  128.922319] xhci_hcd 0000:05:00.0: @00000000371f34b0 00000000 00000000 00000000 00000000
[  128.922321] xhci_hcd 0000:05:00.0: @00000000371f34c0 00000000 00000000 00000000 00000000
[  128.922323] xhci_hcd 0000:05:00.0: @00000000371f34d0 00000000 00000000 00000000 00000000
[  128.922325] xhci_hcd 0000:05:00.0: @00000000371f34e0 00000000 00000000 00000000 00000000
[  128.922328] xhci_hcd 0000:05:00.0: @00000000371f34f0 00000000 00000000 00000000 00000000
[  128.922330] xhci_hcd 0000:05:00.0: @00000000371f3500 00000000 00000000 00000000 00000000
[  128.922332] xhci_hcd 0000:05:00.0: @00000000371f3510 00000000 00000000 00000000 00000000
[  128.922334] xhci_hcd 0000:05:00.0: @00000000371f3520 00000000 00000000 00000000 00000000
[  128.922336] xhci_hcd 0000:05:00.0: @00000000371f3530 00000000 00000000 00000000 00000000
[  128.922338] xhci_hcd 0000:05:00.0: @00000000371f3540 00000000 00000000 00000000 00000000
[  128.922340] xhci_hcd 0000:05:00.0: @00000000371f3550 00000000 00000000 00000000 00000000
[  128.922342] xhci_hcd 0000:05:00.0: @00000000371f3560 00000000 00000000 00000000 00000000
[  128.922344] xhci_hcd 0000:05:00.0: @00000000371f3570 00000000 00000000 00000000 00000000
[  128.922346] xhci_hcd 0000:05:00.0: @00000000371f3580 00000000 00000000 00000000 00000000
[  128.922348] xhci_hcd 0000:05:00.0: @00000000371f3590 00000000 00000000 00000000 00000000
[  128.922350] xhci_hcd 0000:05:00.0: @00000000371f35a0 00000000 00000000 00000000 00000000
[  128.922352] xhci_hcd 0000:05:00.0: @00000000371f35b0 00000000 00000000 00000000 00000000
[  128.922354] xhci_hcd 0000:05:00.0: @00000000371f35c0 00000000 00000000 00000000 00000000
[  128.922356] xhci_hcd 0000:05:00.0: @00000000371f35d0 00000000 00000000 00000000 00000000
[  128.922358] xhci_hcd 0000:05:00.0: @00000000371f35e0 00000000 00000000 00000000 00000000
[  128.922360] xhci_hcd 0000:05:00.0: @00000000371f35f0 00000000 00000000 00000000 00000000
[  128.922362] xhci_hcd 0000:05:00.0: @00000000371f3600 00000000 00000000 00000000 00000000
[  128.922364] xhci_hcd 0000:05:00.0: @00000000371f3610 00000000 00000000 00000000 00000000
[  128.922366] xhci_hcd 0000:05:00.0: @00000000371f3620 00000000 00000000 00000000 00000000
[  128.922368] xhci_hcd 0000:05:00.0: @00000000371f3630 00000000 00000000 00000000 00000000
[  128.922370] xhci_hcd 0000:05:00.0: @00000000371f3640 00000000 00000000 00000000 00000000
[  128.922372] xhci_hcd 0000:05:00.0: @00000000371f3650 00000000 00000000 00000000 00000000
[  128.922374] xhci_hcd 0000:05:00.0: @00000000371f3660 00000000 00000000 00000000 00000000
[  128.922376] xhci_hcd 0000:05:00.0: @00000000371f3670 00000000 00000000 00000000 00000000
[  128.922378] xhci_hcd 0000:05:00.0: @00000000371f3680 00000000 00000000 00000000 00000000
[  128.922381] xhci_hcd 0000:05:00.0: @00000000371f3690 00000000 00000000 00000000 00000000
[  128.922383] xhci_hcd 0000:05:00.0: @00000000371f36a0 00000000 00000000 00000000 00000000
[  128.922385] xhci_hcd 0000:05:00.0: @00000000371f36b0 00000000 00000000 00000000 00000000
[  128.922387] xhci_hcd 0000:05:00.0: @00000000371f36c0 00000000 00000000 00000000 00000000
[  128.922389] xhci_hcd 0000:05:00.0: @00000000371f36d0 00000000 00000000 00000000 00000000
[  128.922391] xhci_hcd 0000:05:00.0: @00000000371f36e0 00000000 00000000 00000000 00000000
[  128.922393] xhci_hcd 0000:05:00.0: @00000000371f36f0 00000000 00000000 00000000 00000000
[  128.922395] xhci_hcd 0000:05:00.0: @00000000371f3700 00000000 00000000 00000000 00000000
[  128.922397] xhci_hcd 0000:05:00.0: @00000000371f3710 00000000 00000000 00000000 00000000
[  128.922399] xhci_hcd 0000:05:00.0: @00000000371f3720 00000000 00000000 00000000 00000000
[  128.922401] xhci_hcd 0000:05:00.0: @00000000371f3730 00000000 00000000 00000000 00000000
[  128.922403] xhci_hcd 0000:05:00.0: @00000000371f3740 00000000 00000000 00000000 00000000
[  128.922405] xhci_hcd 0000:05:00.0: @00000000371f3750 00000000 00000000 00000000 00000000
[  128.922407] xhci_hcd 0000:05:00.0: @00000000371f3760 00000000 00000000 00000000 00000000
[  128.922409] xhci_hcd 0000:05:00.0: @00000000371f3770 00000000 00000000 00000000 00000000
[  128.922411] xhci_hcd 0000:05:00.0: @00000000371f3780 00000000 00000000 00000000 00000000
[  128.922413] xhci_hcd 0000:05:00.0: @00000000371f3790 00000000 00000000 00000000 00000000
[  128.922415] xhci_hcd 0000:05:00.0: @00000000371f37a0 00000000 00000000 00000000 00000000
[  128.922417] xhci_hcd 0000:05:00.0: @00000000371f37b0 00000000 00000000 00000000 00000000
[  128.922419] xhci_hcd 0000:05:00.0: @00000000371f37c0 00000000 00000000 00000000 00000000
[  128.922421] xhci_hcd 0000:05:00.0: @00000000371f37d0 00000000 00000000 00000000 00000000
[  128.922423] xhci_hcd 0000:05:00.0: @00000000371f37e0 00000000 00000000 00000000 00000000
[  128.922425] xhci_hcd 0000:05:00.0: @00000000371f37f0 00000000 00000000 00000000 00000000
[  128.922428] xhci_hcd 0000:05:00.0: Ring deq = f71f3410 (virt), 0x371f3410 (dma)
[  128.922429] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  128.922431] xhci_hcd 0000:05:00.0: Ring enq = f71f3400 (virt), 0x371f3400 (dma)
[  128.922433] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  128.922440] xhci_hcd 0000:05:00.0: ERST deq = 64'h371f3410
[  128.922441] xhci_hcd 0000:05:00.0: Command ring:
[  128.922443] xhci_hcd 0000:05:00.0: @00000000371f3000 00000000 00000000 00000000 0000c401
[  128.922445] xhci_hcd 0000:05:00.0: @00000000371f3010 00000000 00000000 00000000 00000000
[  128.922447] xhci_hcd 0000:05:00.0: @00000000371f3020 00000000 00000000 00000000 00000000
[  128.922449] xhci_hcd 0000:05:00.0: @00000000371f3030 00000000 00000000 00000000 00000000
[  128.922452] xhci_hcd 0000:05:00.0: @00000000371f3040 00000000 00000000 00000000 00000000
[  128.922454] xhci_hcd 0000:05:00.0: @00000000371f3050 00000000 00000000 00000000 00000000
[  128.922456] xhci_hcd 0000:05:00.0: @00000000371f3060 00000000 00000000 00000000 00000000
[  128.922458] xhci_hcd 0000:05:00.0: @00000000371f3070 00000000 00000000 00000000 00000000
[  128.922460] xhci_hcd 0000:05:00.0: @00000000371f3080 00000000 00000000 00000000 00000000
[  128.922462] xhci_hcd 0000:05:00.0: @00000000371f3090 00000000 00000000 00000000 00000000
[  128.922464] xhci_hcd 0000:05:00.0: @00000000371f30a0 00000000 00000000 00000000 00000000
[  128.922466] xhci_hcd 0000:05:00.0: @00000000371f30b0 00000000 00000000 00000000 00000000
[  128.922468] xhci_hcd 0000:05:00.0: @00000000371f30c0 00000000 00000000 00000000 00000000
[  128.922470] xhci_hcd 0000:05:00.0: @00000000371f30d0 00000000 00000000 00000000 00000000
[  128.922472] xhci_hcd 0000:05:00.0: @00000000371f30e0 00000000 00000000 00000000 00000000
[  128.922474] xhci_hcd 0000:05:00.0: @00000000371f30f0 00000000 00000000 00000000 00000000
[  128.922476] xhci_hcd 0000:05:00.0: @00000000371f3100 00000000 00000000 00000000 00000000
[  128.922478] xhci_hcd 0000:05:00.0: @00000000371f3110 00000000 00000000 00000000 00000000
[  128.922480] xhci_hcd 0000:05:00.0: @00000000371f3120 00000000 00000000 00000000 00000000
[  128.922482] xhci_hcd 0000:05:00.0: @00000000371f3130 00000000 00000000 00000000 00000000
[  128.922484] xhci_hcd 0000:05:00.0: @00000000371f3140 00000000 00000000 00000000 00000000
[  128.922486] xhci_hcd 0000:05:00.0: @00000000371f3150 00000000 00000000 00000000 00000000
[  128.922488] xhci_hcd 0000:05:00.0: @00000000371f3160 00000000 00000000 00000000 00000000
[  128.922490] xhci_hcd 0000:05:00.0: @00000000371f3170 00000000 00000000 00000000 00000000
[  128.922492] xhci_hcd 0000:05:00.0: @00000000371f3180 00000000 00000000 00000000 00000000
[  128.922494] xhci_hcd 0000:05:00.0: @00000000371f3190 00000000 00000000 00000000 00000000
[  128.922496] xhci_hcd 0000:05:00.0: @00000000371f31a0 00000000 00000000 00000000 00000000
[  128.922498] xhci_hcd 0000:05:00.0: @00000000371f31b0 00000000 00000000 00000000 00000000
[  128.922500] xhci_hcd 0000:05:00.0: @00000000371f31c0 00000000 00000000 00000000 00000000
[  128.922503] xhci_hcd 0000:05:00.0: @00000000371f31d0 00000000 00000000 00000000 00000000
[  128.922505] xhci_hcd 0000:05:00.0: @00000000371f31e0 00000000 00000000 00000000 00000000
[  128.922507] xhci_hcd 0000:05:00.0: @00000000371f31f0 00000000 00000000 00000000 00000000
[  128.922509] xhci_hcd 0000:05:00.0: @00000000371f3200 00000000 00000000 00000000 00000000
[  128.922511] xhci_hcd 0000:05:00.0: @00000000371f3210 00000000 00000000 00000000 00000000
[  128.922513] xhci_hcd 0000:05:00.0: @00000000371f3220 00000000 00000000 00000000 00000000
[  128.922515] xhci_hcd 0000:05:00.0: @00000000371f3230 00000000 00000000 00000000 00000000
[  128.922517] xhci_hcd 0000:05:00.0: @00000000371f3240 00000000 00000000 00000000 00000000
[  128.922519] xhci_hcd 0000:05:00.0: @00000000371f3250 00000000 00000000 00000000 00000000
[  128.922521] xhci_hcd 0000:05:00.0: @00000000371f3260 00000000 00000000 00000000 00000000
[  128.922523] xhci_hcd 0000:05:00.0: @00000000371f3270 00000000 00000000 00000000 00000000
[  128.922525] xhci_hcd 0000:05:00.0: @00000000371f3280 00000000 00000000 00000000 00000000
[  128.922527] xhci_hcd 0000:05:00.0: @00000000371f3290 00000000 00000000 00000000 00000000
[  128.922529] xhci_hcd 0000:05:00.0: @00000000371f32a0 00000000 00000000 00000000 00000000
[  128.922531] xhci_hcd 0000:05:00.0: @00000000371f32b0 00000000 00000000 00000000 00000000
[  128.922533] xhci_hcd 0000:05:00.0: @00000000371f32c0 00000000 00000000 00000000 00000000
[  128.922535] xhci_hcd 0000:05:00.0: @00000000371f32d0 00000000 00000000 00000000 00000000
[  128.922537] xhci_hcd 0000:05:00.0: @00000000371f32e0 00000000 00000000 00000000 00000000
[  128.922539] xhci_hcd 0000:05:00.0: @00000000371f32f0 00000000 00000000 00000000 00000000
[  128.922541] xhci_hcd 0000:05:00.0: @00000000371f3300 00000000 00000000 00000000 00000000
[  128.922543] xhci_hcd 0000:05:00.0: @00000000371f3310 00000000 00000000 00000000 00000000
[  128.922545] xhci_hcd 0000:05:00.0: @00000000371f3320 00000000 00000000 00000000 00000000
[  128.922547] xhci_hcd 0000:05:00.0: @00000000371f3330 00000000 00000000 00000000 00000000
[  128.922549] xhci_hcd 0000:05:00.0: @00000000371f3340 00000000 00000000 00000000 00000000
[  128.922551] xhci_hcd 0000:05:00.0: @00000000371f3350 00000000 00000000 00000000 00000000
[  128.922553] xhci_hcd 0000:05:00.0: @00000000371f3360 00000000 00000000 00000000 00000000
[  128.922556] xhci_hcd 0000:05:00.0: @00000000371f3370 00000000 00000000 00000000 00000000
[  128.922558] xhci_hcd 0000:05:00.0: @00000000371f3380 00000000 00000000 00000000 00000000
[  128.922560] xhci_hcd 0000:05:00.0: @00000000371f3390 00000000 00000000 00000000 00000000
[  128.922562] xhci_hcd 0000:05:00.0: @00000000371f33a0 00000000 00000000 00000000 00000000
[  128.922564] xhci_hcd 0000:05:00.0: @00000000371f33b0 00000000 00000000 00000000 00000000
[  128.922566] xhci_hcd 0000:05:00.0: @00000000371f33c0 00000000 00000000 00000000 00000000
[  128.922568] xhci_hcd 0000:05:00.0: @00000000371f33d0 00000000 00000000 00000000 00000000
[  128.922570] xhci_hcd 0000:05:00.0: @00000000371f33e0 00000000 00000000 00000000 00000000
[  128.922572] xhci_hcd 0000:05:00.0: @00000000371f33f0 371f3000 00000000 00000000 00001802
[  128.922574] xhci_hcd 0000:05:00.0: Ring deq = f71f3010 (virt), 0x371f3010 (dma)
[  128.922576] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  128.922577] xhci_hcd 0000:05:00.0: Ring enq = f71f3010 (virt), 0x371f3010 (dma)
[  128.922579] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  128.922585] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  128.922587] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  189.057009] xhci_hcd 0000:05:00.0: Poll event ring: 4294939520
[  189.057018] xhci_hcd 0000:05:00.0: op reg status = 0x0
[  189.057026] xhci_hcd 0000:05:00.0: ir_set 0 pending = 0x2
[  189.057031] xhci_hcd 0000:05:00.0: HC error bitmask = 0x0
[  189.057035] xhci_hcd 0000:05:00.0: Event ring:
[  189.057043] xhci_hcd 0000:05:00.0: @00000000371f3400 371f3000 00000000 01003025 0000c001
[  189.057050] xhci_hcd 0000:05:00.0: @00000000371f3410 00000000 00000000 00000000 00000000
[  189.057056] xhci_hcd 0000:05:00.0: @00000000371f3420 00000000 00000000 00000000 00000000
[  189.057063] xhci_hcd 0000:05:00.0: @00000000371f3430 00000000 00000000 00000000 00000000
[  189.057069] xhci_hcd 0000:05:00.0: @00000000371f3440 00000000 00000000 00000000 00000000
[  189.057076] xhci_hcd 0000:05:00.0: @00000000371f3450 00000000 00000000 00000000 00000000
[  189.057082] xhci_hcd 0000:05:00.0: @00000000371f3460 00000000 00000000 00000000 00000000
[  189.057088] xhci_hcd 0000:05:00.0: @00000000371f3470 00000000 00000000 00000000 00000000
[  189.057095] xhci_hcd 0000:05:00.0: @00000000371f3480 00000000 00000000 00000000 00000000
[  189.057101] xhci_hcd 0000:05:00.0: @00000000371f3490 00000000 00000000 00000000 00000000
[  189.057108] xhci_hcd 0000:05:00.0: @00000000371f34a0 00000000 00000000 00000000 00000000
[  189.057114] xhci_hcd 0000:05:00.0: @00000000371f34b0 00000000 00000000 00000000 00000000
[  189.057121] xhci_hcd 0000:05:00.0: @00000000371f34c0 00000000 00000000 00000000 00000000
[  189.057127] xhci_hcd 0000:05:00.0: @00000000371f34d0 00000000 00000000 00000000 00000000
[  189.057133] xhci_hcd 0000:05:00.0: @00000000371f34e0 00000000 00000000 00000000 00000000
[  189.057140] xhci_hcd 0000:05:00.0: @00000000371f34f0 00000000 00000000 00000000 00000000
[  189.057146] xhci_hcd 0000:05:00.0: @00000000371f3500 00000000 00000000 00000000 00000000
[  189.057153] xhci_hcd 0000:05:00.0: @00000000371f3510 00000000 00000000 00000000 00000000
[  189.057159] xhci_hcd 0000:05:00.0: @00000000371f3520 00000000 00000000 00000000 00000000
[  189.057166] xhci_hcd 0000:05:00.0: @00000000371f3530 00000000 00000000 00000000 00000000
[  189.057172] xhci_hcd 0000:05:00.0: @00000000371f3540 00000000 00000000 00000000 00000000
[  189.057178] xhci_hcd 0000:05:00.0: @00000000371f3550 00000000 00000000 00000000 00000000
[  189.057185] xhci_hcd 0000:05:00.0: @00000000371f3560 00000000 00000000 00000000 00000000
[  189.057191] xhci_hcd 0000:05:00.0: @00000000371f3570 00000000 00000000 00000000 00000000
[  189.057198] xhci_hcd 0000:05:00.0: @00000000371f3580 00000000 00000000 00000000 00000000
[  189.057204] xhci_hcd 0000:05:00.0: @00000000371f3590 00000000 00000000 00000000 00000000
[  189.057211] xhci_hcd 0000:05:00.0: @00000000371f35a0 00000000 00000000 00000000 00000000
[  189.057217] xhci_hcd 0000:05:00.0: @00000000371f35b0 00000000 00000000 00000000 00000000
[  189.057224] xhci_hcd 0000:05:00.0: @00000000371f35c0 00000000 00000000 00000000 00000000
[  189.057230] xhci_hcd 0000:05:00.0: @00000000371f35d0 00000000 00000000 00000000 00000000
[  189.057236] xhci_hcd 0000:05:00.0: @00000000371f35e0 00000000 00000000 00000000 00000000
[  189.057243] xhci_hcd 0000:05:00.0: @00000000371f35f0 00000000 00000000 00000000 00000000
[  189.057249] xhci_hcd 0000:05:00.0: @00000000371f3600 00000000 00000000 00000000 00000000
[  189.057256] xhci_hcd 0000:05:00.0: @00000000371f3610 00000000 00000000 00000000 00000000
[  189.057262] xhci_hcd 0000:05:00.0: @00000000371f3620 00000000 00000000 00000000 00000000
[  189.057269] xhci_hcd 0000:05:00.0: @00000000371f3630 00000000 00000000 00000000 00000000
[  189.057275] xhci_hcd 0000:05:00.0: @00000000371f3640 00000000 00000000 00000000 00000000
[  189.057281] xhci_hcd 0000:05:00.0: @00000000371f3650 00000000 00000000 00000000 00000000
[  189.057288] xhci_hcd 0000:05:00.0: @00000000371f3660 00000000 00000000 00000000 00000000
[  189.057294] xhci_hcd 0000:05:00.0: @00000000371f3670 00000000 00000000 00000000 00000000
[  189.057301] xhci_hcd 0000:05:00.0: @00000000371f3680 00000000 00000000 00000000 00000000
[  189.057307] xhci_hcd 0000:05:00.0: @00000000371f3690 00000000 00000000 00000000 00000000
[  189.057314] xhci_hcd 0000:05:00.0: @00000000371f36a0 00000000 00000000 00000000 00000000
[  189.057320] xhci_hcd 0000:05:00.0: @00000000371f36b0 00000000 00000000 00000000 00000000
[  189.057326] xhci_hcd 0000:05:00.0: @00000000371f36c0 00000000 00000000 00000000 00000000
[  189.057333] xhci_hcd 0000:05:00.0: @00000000371f36d0 00000000 00000000 00000000 00000000
[  189.057339] xhci_hcd 0000:05:00.0: @00000000371f36e0 00000000 00000000 00000000 00000000
[  189.057346] xhci_hcd 0000:05:00.0: @00000000371f36f0 00000000 00000000 00000000 00000000
[  189.057352] xhci_hcd 0000:05:00.0: @00000000371f3700 00000000 00000000 00000000 00000000
[  189.057359] xhci_hcd 0000:05:00.0: @00000000371f3710 00000000 00000000 00000000 00000000
[  189.057365] xhci_hcd 0000:05:00.0: @00000000371f3720 00000000 00000000 00000000 00000000
[  189.057371] xhci_hcd 0000:05:00.0: @00000000371f3730 00000000 00000000 00000000 00000000
[  189.057378] xhci_hcd 0000:05:00.0: @00000000371f3740 00000000 00000000 00000000 00000000
[  189.057384] xhci_hcd 0000:05:00.0: @00000000371f3750 00000000 00000000 00000000 00000000
[  189.057391] xhci_hcd 0000:05:00.0: @00000000371f3760 00000000 00000000 00000000 00000000
[  189.057397] xhci_hcd 0000:05:00.0: @00000000371f3770 00000000 00000000 00000000 00000000
[  189.057404] xhci_hcd 0000:05:00.0: @00000000371f3780 00000000 00000000 00000000 00000000
[  189.057410] xhci_hcd 0000:05:00.0: @00000000371f3790 00000000 00000000 00000000 00000000
[  189.057416] xhci_hcd 0000:05:00.0: @00000000371f37a0 00000000 00000000 00000000 00000000
[  189.057423] xhci_hcd 0000:05:00.0: @00000000371f37b0 00000000 00000000 00000000 00000000
[  189.057429] xhci_hcd 0000:05:00.0: @00000000371f37c0 00000000 00000000 00000000 00000000
[  189.057436] xhci_hcd 0000:05:00.0: @00000000371f37d0 00000000 00000000 00000000 00000000
[  189.057442] xhci_hcd 0000:05:00.0: @00000000371f37e0 00000000 00000000 00000000 00000000
[  189.057449] xhci_hcd 0000:05:00.0: @00000000371f37f0 00000000 00000000 00000000 00000000
[  189.057455] xhci_hcd 0000:05:00.0: Ring deq = f71f3410 (virt), 0x371f3410 (dma)
[  189.057461] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  189.057466] xhci_hcd 0000:05:00.0: Ring enq = f71f3400 (virt), 0x371f3400 (dma)
[  189.057472] xhci_hcd 0000:05:00.0: Ring enq updated 0 times
[  189.057482] xhci_hcd 0000:05:00.0: ERST deq = 64'h371f3410
[  189.057486] xhci_hcd 0000:05:00.0: Command ring:
[  189.057492] xhci_hcd 0000:05:00.0: @00000000371f3000 00000000 00000000 00000000 0000c401
[  189.057499] xhci_hcd 0000:05:00.0: @00000000371f3010 00000000 00000000 00000000 00000000
[  189.057505] xhci_hcd 0000:05:00.0: @00000000371f3020 00000000 00000000 00000000 00000000
[  189.057512] xhci_hcd 0000:05:00.0: @00000000371f3030 00000000 00000000 00000000 00000000
[  189.057518] xhci_hcd 0000:05:00.0: @00000000371f3040 00000000 00000000 00000000 00000000
[  189.057525] xhci_hcd 0000:05:00.0: @00000000371f3050 00000000 00000000 00000000 00000000
[  189.057531] xhci_hcd 0000:05:00.0: @00000000371f3060 00000000 00000000 00000000 00000000
[  189.057538] xhci_hcd 0000:05:00.0: @00000000371f3070 00000000 00000000 00000000 00000000
[  189.057544] xhci_hcd 0000:05:00.0: @00000000371f3080 00000000 00000000 00000000 00000000
[  189.057551] xhci_hcd 0000:05:00.0: @00000000371f3090 00000000 00000000 00000000 00000000
[  189.057557] xhci_hcd 0000:05:00.0: @00000000371f30a0 00000000 00000000 00000000 00000000
[  189.057563] xhci_hcd 0000:05:00.0: @00000000371f30b0 00000000 00000000 00000000 00000000
[  189.057570] xhci_hcd 0000:05:00.0: @00000000371f30c0 00000000 00000000 00000000 00000000
[  189.057576] xhci_hcd 0000:05:00.0: @00000000371f30d0 00000000 00000000 00000000 00000000
[  189.057583] xhci_hcd 0000:05:00.0: @00000000371f30e0 00000000 00000000 00000000 00000000
[  189.057589] xhci_hcd 0000:05:00.0: @00000000371f30f0 00000000 00000000 00000000 00000000
[  189.057595] xhci_hcd 0000:05:00.0: @00000000371f3100 00000000 00000000 00000000 00000000
[  189.057602] xhci_hcd 0000:05:00.0: @00000000371f3110 00000000 00000000 00000000 00000000
[  189.057608] xhci_hcd 0000:05:00.0: @00000000371f3120 00000000 00000000 00000000 00000000
[  189.057615] xhci_hcd 0000:05:00.0: @00000000371f3130 00000000 00000000 00000000 00000000
[  189.057621] xhci_hcd 0000:05:00.0: @00000000371f3140 00000000 00000000 00000000 00000000
[  189.057628] xhci_hcd 0000:05:00.0: @00000000371f3150 00000000 00000000 00000000 00000000
[  189.057634] xhci_hcd 0000:05:00.0: @00000000371f3160 00000000 00000000 00000000 00000000
[  189.057640] xhci_hcd 0000:05:00.0: @00000000371f3170 00000000 00000000 00000000 00000000
[  189.057647] xhci_hcd 0000:05:00.0: @00000000371f3180 00000000 00000000 00000000 00000000
[  189.057653] xhci_hcd 0000:05:00.0: @00000000371f3190 00000000 00000000 00000000 00000000
[  189.057660] xhci_hcd 0000:05:00.0: @00000000371f31a0 00000000 00000000 00000000 00000000
[  189.057666] xhci_hcd 0000:05:00.0: @00000000371f31b0 00000000 00000000 00000000 00000000
[  189.057673] xhci_hcd 0000:05:00.0: @00000000371f31c0 00000000 00000000 00000000 00000000
[  189.057679] xhci_hcd 0000:05:00.0: @00000000371f31d0 00000000 00000000 00000000 00000000
[  189.057686] xhci_hcd 0000:05:00.0: @00000000371f31e0 00000000 00000000 00000000 00000000
[  189.057692] xhci_hcd 0000:05:00.0: @00000000371f31f0 00000000 00000000 00000000 00000000
[  189.057698] xhci_hcd 0000:05:00.0: @00000000371f3200 00000000 00000000 00000000 00000000
[  189.057705] xhci_hcd 0000:05:00.0: @00000000371f3210 00000000 00000000 00000000 00000000
[  189.057711] xhci_hcd 0000:05:00.0: @00000000371f3220 00000000 00000000 00000000 00000000
[  189.057717] xhci_hcd 0000:05:00.0: @00000000371f3230 00000000 00000000 00000000 00000000
[  189.057724] xhci_hcd 0000:05:00.0: @00000000371f3240 00000000 00000000 00000000 00000000
[  189.057730] xhci_hcd 0000:05:00.0: @00000000371f3250 00000000 00000000 00000000 00000000
[  189.057736] xhci_hcd 0000:05:00.0: @00000000371f3260 00000000 00000000 00000000 00000000
[  189.057743] xhci_hcd 0000:05:00.0: @00000000371f3270 00000000 00000000 00000000 00000000
[  189.057749] xhci_hcd 0000:05:00.0: @00000000371f3280 00000000 00000000 00000000 00000000
[  189.057755] xhci_hcd 0000:05:00.0: @00000000371f3290 00000000 00000000 00000000 00000000
[  189.057762] xhci_hcd 0000:05:00.0: @00000000371f32a0 00000000 00000000 00000000 00000000
[  189.057768] xhci_hcd 0000:05:00.0: @00000000371f32b0 00000000 00000000 00000000 00000000
[  189.057774] xhci_hcd 0000:05:00.0: @00000000371f32c0 00000000 00000000 00000000 00000000
[  189.057781] xhci_hcd 0000:05:00.0: @00000000371f32d0 00000000 00000000 00000000 00000000
[  189.057787] xhci_hcd 0000:05:00.0: @00000000371f32e0 00000000 00000000 00000000 00000000
[  189.057793] xhci_hcd 0000:05:00.0: @00000000371f32f0 00000000 00000000 00000000 00000000
[  189.057800] xhci_hcd 0000:05:00.0: @00000000371f3300 00000000 00000000 00000000 00000000
[  189.057806] xhci_hcd 0000:05:00.0: @00000000371f3310 00000000 00000000 00000000 00000000
[  189.057812] xhci_hcd 0000:05:00.0: @00000000371f3320 00000000 00000000 00000000 00000000
[  189.057819] xhci_hcd 0000:05:00.0: @00000000371f3330 00000000 00000000 00000000 00000000
[  189.057825] xhci_hcd 0000:05:00.0: @00000000371f3340 00000000 00000000 00000000 00000000
[  189.057832] xhci_hcd 0000:05:00.0: @00000000371f3350 00000000 00000000 00000000 00000000
[  189.057838] xhci_hcd 0000:05:00.0: @00000000371f3360 00000000 00000000 00000000 00000000
[  189.058078] xhci_hcd 0000:05:00.0: @00000000371f3370 00000000 00000000 00000000 00000000
[  189.058087] xhci_hcd 0000:05:00.0: @00000000371f3380 00000000 00000000 00000000 00000000
[  189.058095] xhci_hcd 0000:05:00.0: @00000000371f3390 00000000 00000000 00000000 00000000
[  189.058101] xhci_hcd 0000:05:00.0: @00000000371f33a0 00000000 00000000 00000000 00000000
[  189.058107] xhci_hcd 0000:05:00.0: @00000000371f33b0 00000000 00000000 00000000 00000000
[  189.058114] xhci_hcd 0000:05:00.0: @00000000371f33c0 00000000 00000000 00000000 00000000
[  189.058120] xhci_hcd 0000:05:00.0: @00000000371f33d0 00000000 00000000 00000000 00000000
[  189.058126] xhci_hcd 0000:05:00.0: @00000000371f33e0 00000000 00000000 00000000 00000000
[  189.058133] xhci_hcd 0000:05:00.0: @00000000371f33f0 371f3000 00000000 00000000 00001802
[  189.058139] xhci_hcd 0000:05:00.0: Ring deq = f71f3010 (virt), 0x371f3010 (dma)
[  189.058145] xhci_hcd 0000:05:00.0: Ring deq updated 1 times
[  189.058150] xhci_hcd 0000:05:00.0: Ring enq = f71f3010 (virt), 0x371f3010 (dma)
[  189.058155] xhci_hcd 0000:05:00.0: Ring enq updated 1 times
[  189.058165] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr low bits + flags = @00000008
[  189.058171] xhci_hcd 0000:05:00.0: // xHC command ring deq ptr high bits = @00000000
[  194.959555] Calling CRDA to update world regulatory domain
[  195.000453] World regulatory domain updated:
[  195.000455]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  195.000457]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  195.000459]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  195.000461]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  195.000463]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  195.000465]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  195.075239] usbcore: registered new interface driver rtl8192cu
[  216.322158] xhci_hcd 0000:05:00.0: Port Status Change Event for port 3
[  216.322171] xhci_hcd 0000:05:00.0: resume root hub
[  216.337480] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x202e1
[  216.337491] xhci_hcd 0000:05:00.0: Get port status returned 0x10101
[  216.337509] xhci_hcd 0000:05:00.0: clear port connect change, actual port 0 status  = 0x2e1
[  216.337522] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[  216.337530] xhci_hcd 0000:05:00.0: Get port status returned 0x100
[  216.441465] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2e1
[  216.441474] xhci_hcd 0000:05:00.0: Get port status returned 0x101
[  216.441490] xhci_hcd 0000:05:00.0: // Ding dong!
[  216.441559] xhci_hcd 0000:05:00.0: Slot 1 output ctx = 0x31efd000 (dma)
[  216.441569] xhci_hcd 0000:05:00.0: Slot 1 input ctx = 0x31e54000 (dma)
[  216.441583] xhci_hcd 0000:05:00.0: Allocating ring at f270ef80
[  216.441593] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f23b49b0
[  216.441606] xhci_hcd 0000:05:00.0: // Allocating segment at f71f3800 (virtual) 0x371f3800 (DMA)
[  216.441619] xhci_hcd 0000:05:00.0: Linking segment 0x371f3800 to segment 0x371f3800 (DMA)
[  216.441632] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment f23b49b0 (virtual), 0x371f3800 (DMA)
[  216.441645] xhci_hcd 0000:05:00.0: Set slot id 1 dcbaa entry f331b008 to 0x31efd000
[  216.441665] xhci_hcd 0000:05:00.0: set port reset, actual port 0 status  = 0x331
[  216.491963] xhci_hcd 0000:05:00.0: Port Status Change Event for port 3
[  216.497392] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x200e03
[  216.497403] xhci_hcd 0000:05:00.0: Get port status returned 0x100503
[  216.553377] xhci_hcd 0000:05:00.0: clear port reset change, actual port 0 status  = 0xe03
[  216.553393] usb 3-1: new high speed USB device number 2 using xhci_hcd
[  216.553401] xhci_hcd 0000:05:00.0: Set root hub portnum to 3
[  216.553408] xhci_hcd 0000:05:00.0: Set fake root hub portnum to 1
[  216.553417] xhci_hcd 0000:05:00.0: udev->tt =   (null)
[  216.553424] xhci_hcd 0000:05:00.0: udev->ttport = 0x0
[  216.553431] xhci_hcd 0000:05:00.0: Slot ID 1 Input Context:
[  216.553442] xhci_hcd 0000:05:00.0: @f1e54000 (virt) @31e54000 (dma) 0x000000 - drop flags
[  216.553453] xhci_hcd 0000:05:00.0: @f1e54004 (virt) @31e54004 (dma) 0x000003 - add flags
[  216.553466] xhci_hcd 0000:05:00.0: @f1e54008 (virt) @31e54008 (dma) 0x000000 - rsvd2[0]
[  216.553480] xhci_hcd 0000:05:00.0: @f1e5400c (virt) @31e5400c (dma) 0x000000 - rsvd2[1]
[  216.553493] xhci_hcd 0000:05:00.0: @f1e54010 (virt) @31e54010 (dma) 0x000000 - rsvd2[2]
[  216.553503] xhci_hcd 0000:05:00.0: @f1e54014 (virt) @31e54014 (dma) 0x000000 - rsvd2[3]
[  216.553511] xhci_hcd 0000:05:00.0: @f1e54018 (virt) @31e54018 (dma) 0x000000 - rsvd2[4]
[  216.553524] xhci_hcd 0000:05:00.0: @f1e5401c (virt) @31e5401c (dma) 0x000000 - rsvd2[5]
[  216.553531] xhci_hcd 0000:05:00.0: Slot Context:
[  216.553538] xhci_hcd 0000:05:00.0: @f1e54020 (virt) @31e54020 (dma) 0x8300000 - dev_info
[  216.553546] xhci_hcd 0000:05:00.0: @f1e54024 (virt) @31e54024 (dma) 0x030000 - dev_info2
[  216.553554] xhci_hcd 0000:05:00.0: @f1e54028 (virt) @31e54028 (dma) 0x000000 - tt_info
[  216.553561] xhci_hcd 0000:05:00.0: @f1e5402c (virt) @31e5402c (dma) 0x000000 - dev_state
[  216.553569] xhci_hcd 0000:05:00.0: @f1e54030 (virt) @31e54030 (dma) 0x000000 - rsvd[0]
[  216.553577] xhci_hcd 0000:05:00.0: @f1e54034 (virt) @31e54034 (dma) 0x000000 - rsvd[1]
[  216.553590] xhci_hcd 0000:05:00.0: @f1e54038 (virt) @31e54038 (dma) 0x000000 - rsvd[2]
[  216.553598] xhci_hcd 0000:05:00.0: @f1e5403c (virt) @31e5403c (dma) 0x000000 - rsvd[3]
[  216.553605] xhci_hcd 0000:05:00.0: Endpoint 00 Context:
[  216.553612] xhci_hcd 0000:05:00.0: @f1e54040 (virt) @31e54040 (dma) 0x000000 - ep_info
[  216.553620] xhci_hcd 0000:05:00.0: @f1e54044 (virt) @31e54044 (dma) 0x400026 - ep_info2
[  216.553627] xhci_hcd 0000:05:00.0: @f1e54048 (virt) @31e54048 (dma) 0x371f3801 - deq
[  216.553635] xhci_hcd 0000:05:00.0: @f1e54050 (virt) @31e54050 (dma) 0x000000 - tx_info
[  216.553643] xhci_hcd 0000:05:00.0: @f1e54054 (virt) @31e54054 (dma) 0x000000 - rsvd[0]
[  216.553651] xhci_hcd 0000:05:00.0: @f1e54058 (virt) @31e54058 (dma) 0x000000 - rsvd[1]
[  216.553659] xhci_hcd 0000:05:00.0: @f1e5405c (virt) @31e5405c (dma) 0x000000 - rsvd[2]
[  216.553665] xhci_hcd 0000:05:00.0: Endpoint 01 Context:
[  216.553672] xhci_hcd 0000:05:00.0: @f1e54060 (virt) @31e54060 (dma) 0x000000 - ep_info
[  216.553680] xhci_hcd 0000:05:00.0: @f1e54064 (virt) @31e54064 (dma) 0x000000 - ep_info2
[  216.553687] xhci_hcd 0000:05:00.0: @f1e54068 (virt) @31e54068 (dma) 0x000000 - deq
[  216.553695] xhci_hcd 0000:05:00.0: @f1e54070 (virt) @31e54070 (dma) 0x000000 - tx_info
[  216.553703] xhci_hcd 0000:05:00.0: @f1e54074 (virt) @31e54074 (dma) 0x000000 - rsvd[0]
[  216.553711] xhci_hcd 0000:05:00.0: @f1e54078 (virt) @31e54078 (dma) 0x000000 - rsvd[1]
[  216.553719] xhci_hcd 0000:05:00.0: @f1e5407c (virt) @31e5407c (dma) 0x000000 - rsvd[2]
[  216.553731] xhci_hcd 0000:05:00.0: Endpoint 02 Context:
[  216.553738] xhci_hcd 0000:05:00.0: @f1e54080 (virt) @31e54080 (dma) 0x000000 - ep_info
[  216.553746] xhci_hcd 0000:05:00.0: @f1e54084 (virt) @31e54084 (dma) 0x000000 - ep_info2
[  216.553753] xhci_hcd 0000:05:00.0: @f1e54088 (virt) @31e54088 (dma) 0x000000 - deq
[  216.553761] xhci_hcd 0000:05:00.0: @f1e54090 (virt) @31e54090 (dma) 0x000000 - tx_info
[  216.553775] xhci_hcd 0000:05:00.0: @f1e54094 (virt) @31e54094 (dma) 0x000000 - rsvd[0]
[  216.553782] xhci_hcd 0000:05:00.0: @f1e54098 (virt) @31e54098 (dma) 0x000000 - rsvd[1]
[  216.553790] xhci_hcd 0000:05:00.0: @f1e5409c (virt) @31e5409c (dma) 0x000000 - rsvd[2]
[  216.553799] xhci_hcd 0000:05:00.0: // Ding dong!
[  216.553947] xhci_hcd 0000:05:00.0: Successful Address Device command
[  216.553962] xhci_hcd 0000:05:00.0: Op regs DCBAA ptr = 0x0000003331b000
[  216.553973] xhci_hcd 0000:05:00.0: Slot ID 1 dcbaa entry @f331b008 = 0x00000031efd000
[  216.553981] xhci_hcd 0000:05:00.0: Output Context DMA address = 0x31efd000
[  216.553989] xhci_hcd 0000:05:00.0: Slot ID 1 Input Context:
[  216.553999] xhci_hcd 0000:05:00.0: @f1e54000 (virt) @31e54000 (dma) 0x000000 - drop flags
[  216.554008] xhci_hcd 0000:05:00.0: @f1e54004 (virt) @31e54004 (dma) 0x000003 - add flags
[  216.554018] xhci_hcd 0000:05:00.0: @f1e54008 (virt) @31e54008 (dma) 0x000000 - rsvd2[0]
[  216.554028] xhci_hcd 0000:05:00.0: @f1e5400c (virt) @31e5400c (dma) 0x000000 - rsvd2[1]
[  216.554037] xhci_hcd 0000:05:00.0: @f1e54010 (virt) @31e54010 (dma) 0x000000 - rsvd2[2]
[  216.554047] xhci_hcd 0000:05:00.0: @f1e54014 (virt) @31e54014 (dma) 0x000000 - rsvd2[3]
[  216.554057] xhci_hcd 0000:05:00.0: @f1e54018 (virt) @31e54018 (dma) 0x000000 - rsvd2[4]
[  216.554066] xhci_hcd 0000:05:00.0: @f1e5401c (virt) @31e5401c (dma) 0x000000 - rsvd2[5]
[  216.554074] xhci_hcd 0000:05:00.0: Slot Context:
[  216.554082] xhci_hcd 0000:05:00.0: @f1e54020 (virt) @31e54020 (dma) 0x8300000 - dev_info
[  216.554092] xhci_hcd 0000:05:00.0: @f1e54024 (virt) @31e54024 (dma) 0x030000 - dev_info2
[  216.554101] xhci_hcd 0000:05:00.0: @f1e54028 (virt) @31e54028 (dma) 0x000000 - tt_info
[  216.554110] xhci_hcd 0000:05:00.0: @f1e5402c (virt) @31e5402c (dma) 0x000000 - dev_state
[  216.554120] xhci_hcd 0000:05:00.0: @f1e54030 (virt) @31e54030 (dma) 0x000000 - rsvd[0]
[  216.554129] xhci_hcd 0000:05:00.0: @f1e54034 (virt) @31e54034 (dma) 0x000000 - rsvd[1]
[  216.554139] xhci_hcd 0000:05:00.0: @f1e54038 (virt) @31e54038 (dma) 0x000000 - rsvd[2]
[  216.554148] xhci_hcd 0000:05:00.0: @f1e5403c (virt) @31e5403c (dma) 0x000000 - rsvd[3]
[  216.554156] xhci_hcd 0000:05:00.0: Endpoint 00 Context:
[  216.554164] xhci_hcd 0000:05:00.0: @f1e54040 (virt) @31e54040 (dma) 0x000000 - ep_info
[  216.554174] xhci_hcd 0000:05:00.0: @f1e54044 (virt) @31e54044 (dma) 0x400026 - ep_info2
[  216.554183] xhci_hcd 0000:05:00.0: @f1e54048 (virt) @31e54048 (dma) 0x371f3801 - deq
[  216.554193] xhci_hcd 0000:05:00.0: @f1e54050 (virt) @31e54050 (dma) 0x000000 - tx_info
[  216.554201] xhci_hcd 0000:05:00.0: @f1e54054 (virt) @31e54054 (dma) 0x000000 - rsvd[0]
[  216.554210] xhci_hcd 0000:05:00.0: @f1e54058 (virt) @31e54058 (dma) 0x000000 - rsvd[1]
[  216.554220] xhci_hcd 0000:05:00.0: @f1e5405c (virt) @31e5405c (dma) 0x000000 - rsvd[2]
[  216.554228] xhci_hcd 0000:05:00.0: Endpoint 01 Context:
[  216.554236] xhci_hcd 0000:05:00.0: @f1e54060 (virt) @31e54060 (dma) 0x000000 - ep_info
[  216.554245] xhci_hcd 0000:05:00.0: @f1e54064 (virt) @31e54064 (dma) 0x000000 - ep_info2
[  216.554254] xhci_hcd 0000:05:00.0: @f1e54068 (virt) @31e54068 (dma) 0x000000 - deq
[  216.554264] xhci_hcd 0000:05:00.0: @f1e54070 (virt) @31e54070 (dma) 0x000000 - tx_info
[  216.554273] xhci_hcd 0000:05:00.0: @f1e54074 (virt) @31e54074 (dma) 0x000000 - rsvd[0]
[  216.554283] xhci_hcd 0000:05:00.0: @f1e54078 (virt) @31e54078 (dma) 0x000000 - rsvd[1]
[  216.554292] xhci_hcd 0000:05:00.0: @f1e5407c (virt) @31e5407c (dma) 0x000000 - rsvd[2]
[  216.554300] xhci_hcd 0000:05:00.0: Endpoint 02 Context:
[  216.554308] xhci_hcd 0000:05:00.0: @f1e54080 (virt) @31e54080 (dma) 0x000000 - ep_info
[  216.554317] xhci_hcd 0000:05:00.0: @f1e54084 (virt) @31e54084 (dma) 0x000000 - ep_info2
[  216.554326] xhci_hcd 0000:05:00.0: @f1e54088 (virt) @31e54088 (dma) 0x000000 - deq
[  216.554335] xhci_hcd 0000:05:00.0: @f1e54090 (virt) @31e54090 (dma) 0x000000 - tx_info
[  216.554345] xhci_hcd 0000:05:00.0: @f1e54094 (virt) @31e54094 (dma) 0x000000 - rsvd[0]
[  216.554354] xhci_hcd 0000:05:00.0: @f1e54098 (virt) @31e54098 (dma) 0x000000 - rsvd[1]
[  216.554364] xhci_hcd 0000:05:00.0: @f1e5409c (virt) @31e5409c (dma) 0x000000 - rsvd[2]
[  216.554372] xhci_hcd 0000:05:00.0: Slot ID 1 Output Context:
[  216.554379] xhci_hcd 0000:05:00.0: Slot Context:
[  216.554391] xhci_hcd 0000:05:00.0: @f1efd000 (virt) @31efd000 (dma) 0x8300000 - dev_info
[  216.554400] xhci_hcd 0000:05:00.0: @f1efd004 (virt) @31efd004 (dma) 0x030000 - dev_info2
[  216.554410] xhci_hcd 0000:05:00.0: @f1efd008 (virt) @31efd008 (dma) 0x000000 - tt_info
[  216.554419] xhci_hcd 0000:05:00.0: @f1efd00c (virt) @31efd00c (dma) 0x10000001 - dev_state
[  216.554429] xhci_hcd 0000:05:00.0: @f1efd010 (virt) @31efd010 (dma) 0x000000 - rsvd[0]
[  216.554438] xhci_hcd 0000:05:00.0: @f1efd014 (virt) @31efd014 (dma) 0x000000 - rsvd[1]
[  216.554448] xhci_hcd 0000:05:00.0: @f1efd018 (virt) @31efd018 (dma) 0x000000 - rsvd[2]
[  216.554457] xhci_hcd 0000:05:00.0: @f1efd01c (virt) @31efd01c (dma) 0x000000 - rsvd[3]
[  216.554466] xhci_hcd 0000:05:00.0: Endpoint 00 Context:
[  216.554474] xhci_hcd 0000:05:00.0: @f1efd020 (virt) @31efd020 (dma) 0x000001 - ep_info
[  216.554483] xhci_hcd 0000:05:00.0: @f1efd024 (virt) @31efd024 (dma) 0x400026 - ep_info2
[  216.554493] xhci_hcd 0000:05:00.0: @f1efd028 (virt) @31efd028 (dma) 0x371f3801 - deq
[  216.554502] xhci_hcd 0000:05:00.0: @f1efd030 (virt) @31efd030 (dma) 0x000000 - tx_info
[  216.554511] xhci_hcd 0000:05:00.0: @f1efd034 (virt) @31efd034 (dma) 0x000000 - rsvd[0]
[  216.554521] xhci_hcd 0000:05:00.0: @f1efd038 (virt) @31efd038 (dma) 0x000000 - rsvd[1]
[  216.554530] xhci_hcd 0000:05:00.0: @f1efd03c (virt) @31efd03c (dma) 0x000000 - rsvd[2]
[  216.554539] xhci_hcd 0000:05:00.0: Endpoint 01 Context:
[  216.554546] xhci_hcd 0000:05:00.0: @f1efd040 (virt) @31efd040 (dma) 0x000000 - ep_info
[  216.554556] xhci_hcd 0000:05:00.0: @f1efd044 (virt) @31efd044 (dma) 0x000000 - ep_info2
[  216.554565] xhci_hcd 0000:05:00.0: @f1efd048 (virt) @31efd048 (dma) 0x000000 - deq
[  216.554574] xhci_hcd 0000:05:00.0: @f1efd050 (virt) @31efd050 (dma) 0x000000 - tx_info
[  216.554583] xhci_hcd 0000:05:00.0: @f1efd054 (virt) @31efd054 (dma) 0x000000 - rsvd[0]
[  216.554592] xhci_hcd 0000:05:00.0: @f1efd058 (virt) @31efd058 (dma) 0x000000 - rsvd[1]
[  216.554602] xhci_hcd 0000:05:00.0: @f1efd05c (virt) @31efd05c (dma) 0x000000 - rsvd[2]
[  216.554610] xhci_hcd 0000:05:00.0: Endpoint 02 Context:
[  216.554618] xhci_hcd 0000:05:00.0: @f1efd060 (virt) @31efd060 (dma) 0x000000 - ep_info
[  216.554627] xhci_hcd 0000:05:00.0: @f1efd064 (virt) @31efd064 (dma) 0x000000 - ep_info2
[  216.554636] xhci_hcd 0000:05:00.0: @f1efd068 (virt) @31efd068 (dma) 0x000000 - deq
[  216.554645] xhci_hcd 0000:05:00.0: @f1efd070 (virt) @31efd070 (dma) 0x000000 - tx_info
[  216.554654] xhci_hcd 0000:05:00.0: @f1efd074 (virt) @31efd074 (dma) 0x000000 - rsvd[0]
[  216.554663] xhci_hcd 0000:05:00.0: @f1efd078 (virt) @31efd078 (dma) 0x000000 - rsvd[1]
[  216.554672] xhci_hcd 0000:05:00.0: @f1efd07c (virt) @31efd07c (dma) 0x000000 - rsvd[2]
[  216.554680] xhci_hcd 0000:05:00.0: Internal device address = 2
[  216.569276] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.569553] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792864
[  216.569583] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.570050] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792912
[  216.570086] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.570425] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792960
[  216.570454] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.571051] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793008
[  216.571083] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.571301] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.571312] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  216.571326] Pid: 1138, comm: dd Not tainted 3.1.0-0301rc9-generic #201110050905
[  216.571337] Call Trace:
[  216.571352]  [<c135788d>] ? dev_warn+0x2d/0x30
[  216.571378]  [<f8470f3a>] xhci_irq+0x14ba/0x14c0 [xhci_hcd]
[  216.571396]  [<c1079827>] ? tick_program_event+0x27/0x40
[  216.571416]  [<f8470f6c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  216.571431]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  216.571442]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  216.571456]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.571468]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  216.571481]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.571495]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  216.571503]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  216.571525]  [<c1546970>] ? common_interrupt+0x30/0x38
[  216.571539]  [<c112007b>] ? start_khugepaged+0x8b/0x130
[  216.571552]  [<c104b123>] ? do_syslog+0x2a3/0x3f0
[  216.571568]  [<c12344f8>] ? security_file_permission+0x88/0x90
[  216.571583]  [<c1182690>] ? kmsg_poll+0x50/0x50
[  216.571594]  [<c11826c0>] ? kmsg_read+0x30/0x60
[  216.571606]  [<c1177833>] ? proc_reg_read+0x63/0x90
[  216.571618]  [<c112d4a9>] ? vfs_read+0x99/0x160
[  216.571630]  [<c11777d0>] ? proc_reg_write+0x90/0x90
[  216.571640]  [<c112da32>] ? sys_read+0x42/0x70
[  216.571650]  [<c15463df>] ? sysenter_do_call+0x12/0x28
[  216.571659] xhci_hcd 0000:05:00.0: Waiting for status stage event
[  216.571669] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793056
[  216.571696] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.572050] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.572061] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  216.572073] Pid: 1138, comm: dd Not tainted 3.1.0-0301rc9-generic #201110050905
[  216.572081] Call Trace:
[  216.572091]  [<c135788d>] ? dev_warn+0x2d/0x30
[  216.572110]  [<f8470f3a>] xhci_irq+0x14ba/0x14c0 [xhci_hcd]
[  216.572125]  [<c1079827>] ? tick_program_event+0x27/0x40
[  216.572145]  [<f8470f6c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  216.572158]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  216.572172]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  216.572186]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.572199]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  216.572212]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.572226]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  216.572231]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  216.572251]  [<c1546970>] ? common_interrupt+0x30/0x38
[  216.572260]  [<c112007b>] ? start_khugepaged+0x8b/0x130
[  216.572271]  [<c104b20a>] ? do_syslog+0x38a/0x3f0
[  216.572284]  [<c12344f8>] ? security_file_permission+0x88/0x90
[  216.572294]  [<c1182690>] ? kmsg_poll+0x50/0x50
[  216.572304]  [<c11826c0>] ? kmsg_read+0x30/0x60
[  216.572315]  [<c1177833>] ? proc_reg_read+0x63/0x90
[  216.572328]  [<c112d4a9>] ? vfs_read+0x99/0x160
[  216.572338]  [<c11777d0>] ? proc_reg_write+0x90/0x90
[  216.572351]  [<c112da32>] ? sys_read+0x42/0x70
[  216.572364]  [<c15463df>] ? sysenter_do_call+0x12/0x28
[  216.572374] xhci_hcd 0000:05:00.0: Waiting for status stage event
[  216.572385] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793104
[  216.572413] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.572674] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.572682] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  216.572694] Pid: 1138, comm: dd Not tainted 3.1.0-0301rc9-generic #201110050905
[  216.572702] Call Trace:
[  216.572711]  [<c135788d>] ? dev_warn+0x2d/0x30
[  216.572728]  [<f8470f3a>] xhci_irq+0x14ba/0x14c0 [xhci_hcd]
[  216.572743]  [<c1079827>] ? tick_program_event+0x27/0x40
[  216.572762]  [<f8470f6c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  216.572774]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  216.572787]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  216.572798]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.572807]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  216.572820]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.572834]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  216.572840]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  216.572861]  [<c101c3ea>] ? native_smp_send_reschedule+0x3a/0x50
[  216.572871]  [<c1032237>] ? ttwu_queue_remote+0x47/0x50
[  216.572883]  [<c1546970>] ? common_interrupt+0x30/0x38
[  216.572898]  [<c104007b>] ? sched_debug_show+0x11b/0x5f0
[  216.572911]  [<c10600e0>] ? sys_setpgid+0x80/0x1a0
[  216.572921]  [<c103e4b4>] ? mutex_spin_on_owner+0x4/0x70
[  216.572934]  [<c153df42>] ? __mutex_lock_slowpath+0x32/0x110
[  216.572945]  [<c104f16b>] ? current_fs_time+0x1b/0x20
[  216.572958]  [<c153dcf5>] ? mutex_lock+0x25/0x40
[  216.572970]  [<c1135847>] ? pipe_write+0x57/0x430
[  216.572984]  [<c112ce49>] ? do_sync_write+0xb9/0xf0
[  216.572998]  [<c112cfde>] ? rw_verify_area+0x6e/0x130
[  216.573010]  [<c112d34b>] ? vfs_write+0x9b/0x160
[  216.573023]  [<c112cd90>] ? do_sync_readv_writev+0xd0/0xd0
[  216.573036]  [<c112d9c2>] ? sys_write+0x42/0x70
[  216.573048]  [<c15463df>] ? sysenter_do_call+0x12/0x28
[  216.573055] xhci_hcd 0000:05:00.0: Waiting for status stage event
[  216.573067] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793152
[  216.573097] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.573425] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.573432] xhci_hcd 0000:05:00.0: WARN: short transfer on control ep
[  216.573444] Pid: 1138, comm: dd Not tainted 3.1.0-0301rc9-generic #201110050905
[  216.573454] Call Trace:
[  216.573465]  [<c135788d>] ? dev_warn+0x2d/0x30
[  216.573485]  [<f8470f3a>] xhci_irq+0x14ba/0x14c0 [xhci_hcd]
[  216.573499]  [<c1079827>] ? tick_program_event+0x27/0x40
[  216.573516]  [<f8470f6c>] xhci_msi_irq+0x2c/0x30 [xhci_hcd]
[  216.573528]  [<c10ac5b8>] handle_irq_event_percpu+0x48/0x190
[  216.573538]  [<c101fdfb>] ? msi_set_affinity+0x6b/0x80
[  216.573552]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.573563]  [<c10ac73f>] handle_irq_event+0x3f/0x60
[  216.573576]  [<c10aee40>] ? irq_set_chip_and_handler_name+0x40/0x40
[  216.573590]  [<c10aee9b>] handle_edge_irq+0x5b/0xf0
[  216.573599]  <IRQ>  [<c1546a31>] ? do_IRQ+0x41/0xb0
[  216.573617]  [<c1546970>] ? common_interrupt+0x30/0x38
[  216.573632]  [<c11607e9>] ? fsnotify+0x9/0x2a0
[  216.573642]  [<c112cfde>] ? rw_verify_area+0x6e/0x130
[  216.573652]  [<c112d3ef>] ? vfs_write+0x13f/0x160
[  216.573664]  [<c112cd90>] ? do_sync_readv_writev+0xd0/0xd0
[  216.573675]  [<c112d9c2>] ? sys_write+0x42/0x70
[  216.573685]  [<c15463df>] ? sysenter_do_call+0x12/0x28
[  216.573692] xhci_hcd 0000:05:00.0: Waiting for status stage event
[  216.573703] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793200
[  216.573993] xhci_hcd 0000:05:00.0: Allocating ring at f1d91180
[  216.574000] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f33576a0
[  216.574011] xhci_hcd 0000:05:00.0: // Allocating segment at f1ef6000 (virtual) 0x31ef6000 (DMA)
[  216.574020] xhci_hcd 0000:05:00.0: Linking segment 0x31ef6000 to segment 0x31ef6000 (DMA)
[  216.574037] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment f33576a0 (virtual), 0x31ef6000 (DMA)
[  216.574052] xhci_hcd 0000:05:00.0: add ep 0x81, slot id 1, new drop flags = 0x0, new add flags = 0x8, new slot info = 0x18300000
[  216.574066] xhci_hcd 0000:05:00.0: Allocating ring at f1d91e00
[  216.574072] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f33576d0
[  216.574080] xhci_hcd 0000:05:00.0: // Allocating segment at f1ef6400 (virtual) 0x31ef6400 (DMA)
[  216.574091] xhci_hcd 0000:05:00.0: Linking segment 0x31ef6400 to segment 0x31ef6400 (DMA)
[  216.574099] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment f33576d0 (virtual), 0x31ef6400 (DMA)
[  216.574109] xhci_hcd 0000:05:00.0: add ep 0x2, slot id 1, new drop flags = 0x0, new add flags = 0x18, new slot info = 0x20300000
[  216.574118] xhci_hcd 0000:05:00.0: Allocating ring at f1d91ac0
[  216.574124] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f33576b0
[  216.574131] xhci_hcd 0000:05:00.0: // Allocating segment at f1ef6800 (virtual) 0x31ef6800 (DMA)
[  216.574141] xhci_hcd 0000:05:00.0: Linking segment 0x31ef6800 to segment 0x31ef6800 (DMA)
[  216.574149] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment f33576b0 (virtual), 0x31ef6800 (DMA)
[  216.574158] xhci_hcd 0000:05:00.0: add ep 0x3, slot id 1, new drop flags = 0x0, new add flags = 0x58, new slot info = 0x30300000
[  216.574167] xhci_hcd 0000:05:00.0: Allocating ring at f1d913c0
[  216.574174] xhci_hcd 0000:05:00.0: Allocating priv segment structure at f33576c0
[  216.574183] xhci_hcd 0000:05:00.0: // Allocating segment at f1ed8000 (virtual) 0x31ed8000 (DMA)
[  216.574193] xhci_hcd 0000:05:00.0: Linking segment 0x31ed8000 to segment 0x31ed8000 (DMA)
[  216.574201] xhci_hcd 0000:05:00.0: Wrote link toggle flag to segment f33576c0 (virtual), 0x31ed8000 (DMA)
[  216.574211] xhci_hcd 0000:05:00.0: add ep 0x84, slot id 1, new drop flags = 0x0, new add flags = 0x258, new slot info = 0x48300000
[  216.574221] xhci_hcd 0000:05:00.0: xhci_check_bandwidth called for udev f279c800
[  216.574227] xhci_hcd 0000:05:00.0: New Input Control Context:
[  216.574235] xhci_hcd 0000:05:00.0: @f1e54000 (virt) @31e54000 (dma) 0x000000 - drop flags
[  216.574243] xhci_hcd 0000:05:00.0: @f1e54004 (virt) @31e54004 (dma) 0x000259 - add flags
[  216.574252] xhci_hcd 0000:05:00.0: @f1e54008 (virt) @31e54008 (dma) 0x000000 - rsvd2[0]
[  216.574260] xhci_hcd 0000:05:00.0: @f1e5400c (virt) @31e5400c (dma) 0x000000 - rsvd2[1]
[  216.574268] xhci_hcd 0000:05:00.0: @f1e54010 (virt) @31e54010 (dma) 0x000000 - rsvd2[2]
[  216.574276] xhci_hcd 0000:05:00.0: @f1e54014 (virt) @31e54014 (dma) 0x000000 - rsvd2[3]
[  216.574285] xhci_hcd 0000:05:00.0: @f1e54018 (virt) @31e54018 (dma) 0x000000 - rsvd2[4]
[  216.574293] xhci_hcd 0000:05:00.0: @f1e5401c (virt) @31e5401c (dma) 0x000000 - rsvd2[5]
[  216.574301] xhci_hcd 0000:05:00.0: Slot Context:
[  216.574309] xhci_hcd 0000:05:00.0: @f1e54020 (virt) @31e54020 (dma) 0x48300000 - dev_info
[  216.574317] xhci_hcd 0000:05:00.0: @f1e54024 (virt) @31e54024 (dma) 0x030000 - dev_info2
[  216.574326] xhci_hcd 0000:05:00.0: @f1e54028 (virt) @31e54028 (dma) 0x000000 - tt_info
[  216.574334] xhci_hcd 0000:05:00.0: @f1e5402c (virt) @31e5402c (dma) 0x000000 - dev_state
[  216.574343] xhci_hcd 0000:05:00.0: @f1e54030 (virt) @31e54030 (dma) 0x000000 - rsvd[0]
[  216.574351] xhci_hcd 0000:05:00.0: @f1e54034 (virt) @31e54034 (dma) 0x000000 - rsvd[1]
[  216.574359] xhci_hcd 0000:05:00.0: @f1e54038 (virt) @31e54038 (dma) 0x000000 - rsvd[2]
[  216.574367] xhci_hcd 0000:05:00.0: @f1e5403c (virt) @31e5403c (dma) 0x000000 - rsvd[3]
[  216.574375] xhci_hcd 0000:05:00.0: Endpoint 00 Context:
[  216.574382] xhci_hcd 0000:05:00.0: @f1e54040 (virt) @31e54040 (dma) 0x000000 - ep_info
[  216.574390] xhci_hcd 0000:05:00.0: @f1e54044 (virt) @31e54044 (dma) 0x400026 - ep_info2
[  216.574398] xhci_hcd 0000:05:00.0: @f1e54048 (virt) @31e54048 (dma) 0x371f3801 - deq
[  216.574407] xhci_hcd 0000:05:00.0: @f1e54050 (virt) @31e54050 (dma) 0x000000 - tx_info
[  216.574415] xhci_hcd 0000:05:00.0: @f1e54054 (virt) @31e54054 (dma) 0x000000 - rsvd[0]
[  216.574422] xhci_hcd 0000:05:00.0: @f1e54058 (virt) @31e54058 (dma) 0x000000 - rsvd[1]
[  216.574432] xhci_hcd 0000:05:00.0: @f1e5405c (virt) @31e5405c (dma) 0x000000 - rsvd[2]
[  216.574439] xhci_hcd 0000:05:00.0: Endpoint 01 Context:
[  216.574446] xhci_hcd 0000:05:00.0: @f1e54060 (virt) @31e54060 (dma) 0x000000 - ep_info
[  216.574454] xhci_hcd 0000:05:00.0: @f1e54064 (virt) @31e54064 (dma) 0x000000 - ep_info2
[  216.574462] xhci_hcd 0000:05:00.0: @f1e54068 (virt) @31e54068 (dma) 0x000000 - deq
[  216.574470] xhci_hcd 0000:05:00.0: @f1e54070 (virt) @31e54070 (dma) 0x000000 - tx_info
[  216.574478] xhci_hcd 0000:05:00.0: @f1e54074 (virt) @31e54074 (dma) 0x000000 - rsvd[0]
[  216.574487] xhci_hcd 0000:05:00.0: @f1e54078 (virt) @31e54078 (dma) 0x000000 - rsvd[1]
[  216.574495] xhci_hcd 0000:05:00.0: @f1e5407c (virt) @31e5407c (dma) 0x000000 - rsvd[2]
[  216.574502] xhci_hcd 0000:05:00.0: Endpoint 02 Context:
[  216.574511] xhci_hcd 0000:05:00.0: @f1e54080 (virt) @31e54080 (dma) 0x000000 - ep_info
[  216.574519] xhci_hcd 0000:05:00.0: @f1e54084 (virt) @31e54084 (dma) 0x2000036 - ep_info2
[  216.574527] xhci_hcd 0000:05:00.0: @f1e54088 (virt) @31e54088 (dma) 0x31ef6001 - deq
[  216.574534] xhci_hcd 0000:05:00.0: @f1e54090 (virt) @31e54090 (dma) 0x000000 - tx_info
[  216.574542] xhci_hcd 0000:05:00.0: @f1e54094 (virt) @31e54094 (dma) 0x000000 - rsvd[0]
[  216.574550] xhci_hcd 0000:05:00.0: @f1e54098 (virt) @31e54098 (dma) 0x000000 - rsvd[1]
[  216.574559] xhci_hcd 0000:05:00.0: @f1e5409c (virt) @31e5409c (dma) 0x000000 - rsvd[2]
[  216.574566] xhci_hcd 0000:05:00.0: Endpoint 03 Context:
[  216.574574] xhci_hcd 0000:05:00.0: @f1e540a0 (virt) @31e540a0 (dma) 0x000000 - ep_info
[  216.574582] xhci_hcd 0000:05:00.0: @f1e540a4 (virt) @31e540a4 (dma) 0x2000016 - ep_info2
[  216.574590] xhci_hcd 0000:05:00.0: @f1e540a8 (virt) @31e540a8 (dma) 0x31ef6401 - deq
[  216.574599] xhci_hcd 0000:05:00.0: @f1e540b0 (virt) @31e540b0 (dma) 0x000000 - tx_info
[  216.574607] xhci_hcd 0000:05:00.0: @f1e540b4 (virt) @31e540b4 (dma) 0x000000 - rsvd[0]
[  216.574615] xhci_hcd 0000:05:00.0: @f1e540b8 (virt) @31e540b8 (dma) 0x000000 - rsvd[1]
[  216.574623] xhci_hcd 0000:05:00.0: @f1e540bc (virt) @31e540bc (dma) 0x000000 - rsvd[2]
[  216.574630] xhci_hcd 0000:05:00.0: Endpoint 04 Context:
[  216.574637] xhci_hcd 0000:05:00.0: @f1e540c0 (virt) @31e540c0 (dma) 0x000000 - ep_info
[  216.574645] xhci_hcd 0000:05:00.0: @f1e540c4 (virt) @31e540c4 (dma) 0x000000 - ep_info2
[  216.574653] xhci_hcd 0000:05:00.0: @f1e540c8 (virt) @31e540c8 (dma) 0x000000 - deq
[  216.574660] xhci_hcd 0000:05:00.0: @f1e540d0 (virt) @31e540d0 (dma) 0x000000 - tx_info
[  216.574669] xhci_hcd 0000:05:00.0: @f1e540d4 (virt) @31e540d4 (dma) 0x000000 - rsvd[0]
[  216.574676] xhci_hcd 0000:05:00.0: @f1e540d8 (virt) @31e540d8 (dma) 0x000000 - rsvd[1]
[  216.574685] xhci_hcd 0000:05:00.0: @f1e540dc (virt) @31e540dc (dma) 0x000000 - rsvd[2]
[  216.574693] xhci_hcd 0000:05:00.0: Endpoint 05 Context:
[  216.574700] xhci_hcd 0000:05:00.0: @f1e540e0 (virt) @31e540e0 (dma) 0x000000 - ep_info
[  216.574708] xhci_hcd 0000:05:00.0: @f1e540e4 (virt) @31e540e4 (dma) 0x2000016 - ep_info2
[  216.574716] xhci_hcd 0000:05:00.0: @f1e540e8 (virt) @31e540e8 (dma) 0x31ef6801 - deq
[  216.574724] xhci_hcd 0000:05:00.0: @f1e540f0 (virt) @31e540f0 (dma) 0x000000 - tx_info
[  216.574732] xhci_hcd 0000:05:00.0: @f1e540f4 (virt) @31e540f4 (dma) 0x000000 - rsvd[0]
[  216.574740] xhci_hcd 0000:05:00.0: @f1e540f8 (virt) @31e540f8 (dma) 0x000000 - rsvd[1]
[  216.574749] xhci_hcd 0000:05:00.0: @f1e540fc (virt) @31e540fc (dma) 0x000000 - rsvd[2]
[  216.574756] xhci_hcd 0000:05:00.0: Endpoint 06 Context:
[  216.574764] xhci_hcd 0000:05:00.0: @f1e54100 (virt) @31e54100 (dma) 0x000000 - ep_info
[  216.574772] xhci_hcd 0000:05:00.0: @f1e54104 (virt) @31e54104 (dma) 0x000000 - ep_info2
[  216.574780] xhci_hcd 0000:05:00.0: @f1e54108 (virt) @31e54108 (dma) 0x000000 - deq
[  216.574789] xhci_hcd 0000:05:00.0: @f1e54110 (virt) @31e54110 (dma) 0x000000 - tx_info
[  216.574797] xhci_hcd 0000:05:00.0: @f1e54114 (virt) @31e54114 (dma) 0x000000 - rsvd[0]
[  216.574805] xhci_hcd 0000:05:00.0: @f1e54118 (virt) @31e54118 (dma) 0x000000 - rsvd[1]
[  216.574813] xhci_hcd 0000:05:00.0: @f1e5411c (virt) @31e5411c (dma) 0x000000 - rsvd[2]
[  216.574821] xhci_hcd 0000:05:00.0: Endpoint 07 Context:
[  216.574828] xhci_hcd 0000:05:00.0: @f1e54120 (virt) @31e54120 (dma) 0x000000 - ep_info
[  216.574836] xhci_hcd 0000:05:00.0: @f1e54124 (virt) @31e54124 (dma) 0x000000 - ep_info2
[  216.574844] xhci_hcd 0000:05:00.0: @f1e54128 (virt) @31e54128 (dma) 0x000000 - deq
[  216.574853] xhci_hcd 0000:05:00.0: @f1e54130 (virt) @31e54130 (dma) 0x000000 - tx_info
[  216.574861] xhci_hcd 0000:05:00.0: @f1e54134 (virt) @31e54134 (dma) 0x000000 - rsvd[0]
[  216.574869] xhci_hcd 0000:05:00.0: @f1e54138 (virt) @31e54138 (dma) 0x000000 - rsvd[1]
[  216.574877] xhci_hcd 0000:05:00.0: @f1e5413c (virt) @31e5413c (dma) 0x000000 - rsvd[2]
[  216.574884] xhci_hcd 0000:05:00.0: Endpoint 08 Context:
[  216.574891] xhci_hcd 0000:05:00.0: @f1e54140 (virt) @31e54140 (dma) 0x000000 - ep_info
[  216.574899] xhci_hcd 0000:05:00.0: @f1e54144 (virt) @31e54144 (dma) 0x40003e - ep_info2
[  216.574907] xhci_hcd 0000:05:00.0: @f1e54148 (virt) @31e54148 (dma) 0x31ed8001 - deq
[  216.574915] xhci_hcd 0000:05:00.0: @f1e54150 (virt) @31e54150 (dma) 0x400040 - tx_info
[  216.574923] xhci_hcd 0000:05:00.0: @f1e54154 (virt) @31e54154 (dma) 0x000000 - rsvd[0]
[  216.574932] xhci_hcd 0000:05:00.0: @f1e54158 (virt) @31e54158 (dma) 0x000000 - rsvd[1]
[  216.574940] xhci_hcd 0000:05:00.0: @f1e5415c (virt) @31e5415c (dma) 0x000000 - rsvd[2]
[  216.574948] xhci_hcd 0000:05:00.0: // Ding dong!
[  216.575298] xhci_hcd 0000:05:00.0: Completed config ep cmd
[  216.575317] usb 3-1: Successful Endpoint Configure command
[  216.575327] xhci_hcd 0000:05:00.0: Output context after successful config ep cmd:
[  216.575339] xhci_hcd 0000:05:00.0: Slot Context:
[  216.575352] xhci_hcd 0000:05:00.0: @f1efd000 (virt) @31efd000 (dma) 0x48300000 - dev_info
[  216.575366] xhci_hcd 0000:05:00.0: @f1efd004 (virt) @31efd004 (dma) 0x030000 - dev_info2
[  216.575380] xhci_hcd 0000:05:00.0: @f1efd008 (virt) @31efd008 (dma) 0x000000 - tt_info
[  216.575391] xhci_hcd 0000:05:00.0: @f1efd00c (virt) @31efd00c (dma) 0x18000001 - dev_state
[  216.575406] xhci_hcd 0000:05:00.0: @f1efd010 (virt) @31efd010 (dma) 0x000000 - rsvd[0]
[  216.575420] xhci_hcd 0000:05:00.0: @f1efd014 (virt) @31efd014 (dma) 0x000000 - rsvd[1]
[  216.575428] xhci_hcd 0000:05:00.0: @f1efd018 (virt) @31efd018 (dma) 0x000000 - rsvd[2]
[  216.575436] xhci_hcd 0000:05:00.0: @f1efd01c (virt) @31efd01c (dma) 0x000000 - rsvd[3]
[  216.575444] xhci_hcd 0000:05:00.0: Endpoint 00 Context:
[  216.575451] xhci_hcd 0000:05:00.0: @f1efd020 (virt) @31efd020 (dma) 0x000001 - ep_info
[  216.575459] xhci_hcd 0000:05:00.0: @f1efd024 (virt) @31efd024 (dma) 0x400026 - ep_info2
[  216.575467] xhci_hcd 0000:05:00.0: @f1efd028 (virt) @31efd028 (dma) 0x371f3801 - deq
[  216.575476] xhci_hcd 0000:05:00.0: @f1efd030 (virt) @31efd030 (dma) 0x000000 - tx_info
[  216.575484] xhci_hcd 0000:05:00.0: @f1efd034 (virt) @31efd034 (dma) 0x000000 - rsvd[0]
[  216.575492] xhci_hcd 0000:05:00.0: @f1efd038 (virt) @31efd038 (dma) 0x000000 - rsvd[1]
[  216.575501] xhci_hcd 0000:05:00.0: @f1efd03c (virt) @31efd03c (dma) 0x000000 - rsvd[2]
[  216.575508] xhci_hcd 0000:05:00.0: Endpoint 01 Context:
[  216.575515] xhci_hcd 0000:05:00.0: @f1efd040 (virt) @31efd040 (dma) 0x000000 - ep_info
[  216.575523] xhci_hcd 0000:05:00.0: @f1efd044 (virt) @31efd044 (dma) 0x000000 - ep_info2
[  216.575531] xhci_hcd 0000:05:00.0: @f1efd048 (virt) @31efd048 (dma) 0x000000 - deq
[  216.575539] xhci_hcd 0000:05:00.0: @f1efd050 (virt) @31efd050 (dma) 0x000000 - tx_info
[  216.575547] xhci_hcd 0000:05:00.0: @f1efd054 (virt) @31efd054 (dma) 0x000000 - rsvd[0]
[  216.575555] xhci_hcd 0000:05:00.0: @f1efd058 (virt) @31efd058 (dma) 0x000000 - rsvd[1]
[  216.575563] xhci_hcd 0000:05:00.0: @f1efd05c (virt) @31efd05c (dma) 0x000000 - rsvd[2]
[  216.575570] xhci_hcd 0000:05:00.0: Endpoint 02 Context:
[  216.575578] xhci_hcd 0000:05:00.0: @f1efd060 (virt) @31efd060 (dma) 0x000001 - ep_info
[  216.575587] xhci_hcd 0000:05:00.0: @f1efd064 (virt) @31efd064 (dma) 0x2000036 - ep_info2
[  216.575595] xhci_hcd 0000:05:00.0: @f1efd068 (virt) @31efd068 (dma) 0x31ef6001 - deq
[  216.575602] xhci_hcd 0000:05:00.0: @f1efd070 (virt) @31efd070 (dma) 0x000000 - tx_info
[  216.575611] xhci_hcd 0000:05:00.0: @f1efd074 (virt) @31efd074 (dma) 0x000000 - rsvd[0]
[  216.575618] xhci_hcd 0000:05:00.0: @f1efd078 (virt) @31efd078 (dma) 0x000000 - rsvd[1]
[  216.575626] xhci_hcd 0000:05:00.0: @f1efd07c (virt) @31efd07c (dma) 0x000000 - rsvd[2]
[  216.575633] xhci_hcd 0000:05:00.0: Endpoint 03 Context:
[  216.575640] xhci_hcd 0000:05:00.0: @f1efd080 (virt) @31efd080 (dma) 0x000001 - ep_info
[  216.575648] xhci_hcd 0000:05:00.0: @f1efd084 (virt) @31efd084 (dma) 0x2000016 - ep_info2
[  216.575656] xhci_hcd 0000:05:00.0: @f1efd088 (virt) @31efd088 (dma) 0x31ef6401 - deq
[  216.575665] xhci_hcd 0000:05:00.0: @f1efd090 (virt) @31efd090 (dma) 0x000000 - tx_info
[  216.575673] xhci_hcd 0000:05:00.0: @f1efd094 (virt) @31efd094 (dma) 0x000000 - rsvd[0]
[  216.575681] xhci_hcd 0000:05:00.0: @f1efd098 (virt) @31efd098 (dma) 0x000000 - rsvd[1]
[  216.575690] xhci_hcd 0000:05:00.0: @f1efd09c (virt) @31efd09c (dma) 0x000000 - rsvd[2]
[  216.575697] xhci_hcd 0000:05:00.0: Endpoint 04 Context:
[  216.575705] xhci_hcd 0000:05:00.0: @f1efd0a0 (virt) @31efd0a0 (dma) 0x000000 - ep_info
[  216.575713] xhci_hcd 0000:05:00.0: @f1efd0a4 (virt) @31efd0a4 (dma) 0x000000 - ep_info2
[  216.575720] xhci_hcd 0000:05:00.0: @f1efd0a8 (virt) @31efd0a8 (dma) 0x000000 - deq
[  216.575729] xhci_hcd 0000:05:00.0: @f1efd0b0 (virt) @31efd0b0 (dma) 0x000000 - tx_info
[  216.575736] xhci_hcd 0000:05:00.0: @f1efd0b4 (virt) @31efd0b4 (dma) 0x000000 - rsvd[0]
[  216.575745] xhci_hcd 0000:05:00.0: @f1efd0b8 (virt) @31efd0b8 (dma) 0x000000 - rsvd[1]
[  216.575753] xhci_hcd 0000:05:00.0: @f1efd0bc (virt) @31efd0bc (dma) 0x000000 - rsvd[2]
[  216.575760] xhci_hcd 0000:05:00.0: Endpoint 05 Context:
[  216.575767] xhci_hcd 0000:05:00.0: @f1efd0c0 (virt) @31efd0c0 (dma) 0x000001 - ep_info
[  216.575775] xhci_hcd 0000:05:00.0: @f1efd0c4 (virt) @31efd0c4 (dma) 0x2000016 - ep_info2
[  216.575783] xhci_hcd 0000:05:00.0: @f1efd0c8 (virt) @31efd0c8 (dma) 0x31ef6801 - deq
[  216.575791] xhci_hcd 0000:05:00.0: @f1efd0d0 (virt) @31efd0d0 (dma) 0x000000 - tx_info
[  216.575799] xhci_hcd 0000:05:00.0: @f1efd0d4 (virt) @31efd0d4 (dma) 0x000000 - rsvd[0]
[  216.575807] xhci_hcd 0000:05:00.0: @f1efd0d8 (virt) @31efd0d8 (dma) 0x000000 - rsvd[1]
[  216.575815] xhci_hcd 0000:05:00.0: @f1efd0dc (virt) @31efd0dc (dma) 0x000000 - rsvd[2]
[  216.575822] xhci_hcd 0000:05:00.0: Endpoint 06 Context:
[  216.575829] xhci_hcd 0000:05:00.0: @f1efd0e0 (virt) @31efd0e0 (dma) 0x000000 - ep_info
[  216.575838] xhci_hcd 0000:05:00.0: @f1efd0e4 (virt) @31efd0e4 (dma) 0x000000 - ep_info2
[  216.575846] xhci_hcd 0000:05:00.0: @f1efd0e8 (virt) @31efd0e8 (dma) 0x000000 - deq
[  216.575854] xhci_hcd 0000:05:00.0: @f1efd0f0 (virt) @31efd0f0 (dma) 0x000000 - tx_info
[  216.575863] xhci_hcd 0000:05:00.0: @f1efd0f4 (virt) @31efd0f4 (dma) 0x000000 - rsvd[0]
[  216.575871] xhci_hcd 0000:05:00.0: @f1efd0f8 (virt) @31efd0f8 (dma) 0x000000 - rsvd[1]
[  216.575878] xhci_hcd 0000:05:00.0: @f1efd0fc (virt) @31efd0fc (dma) 0x000000 - rsvd[2]
[  216.575886] xhci_hcd 0000:05:00.0: Endpoint 07 Context:
[  216.575894] xhci_hcd 0000:05:00.0: @f1efd100 (virt) @31efd100 (dma) 0x000000 - ep_info
[  216.575902] xhci_hcd 0000:05:00.0: @f1efd104 (virt) @31efd104 (dma) 0x000000 - ep_info2
[  216.575910] xhci_hcd 0000:05:00.0: @f1efd108 (virt) @31efd108 (dma) 0x000000 - deq
[  216.575918] xhci_hcd 0000:05:00.0: @f1efd110 (virt) @31efd110 (dma) 0x000000 - tx_info
[  216.575926] xhci_hcd 0000:05:00.0: @f1efd114 (virt) @31efd114 (dma) 0x000000 - rsvd[0]
[  216.575934] xhci_hcd 0000:05:00.0: @f1efd118 (virt) @31efd118 (dma) 0x000000 - rsvd[1]
[  216.575942] xhci_hcd 0000:05:00.0: @f1efd11c (virt) @31efd11c (dma) 0x000000 - rsvd[2]
[  216.575949] xhci_hcd 0000:05:00.0: Endpoint 08 Context:
[  216.575956] xhci_hcd 0000:05:00.0: @f1efd120 (virt) @31efd120 (dma) 0x000001 - ep_info
[  216.575965] xhci_hcd 0000:05:00.0: @f1efd124 (virt) @31efd124 (dma) 0x40003e - ep_info2
[  216.575973] xhci_hcd 0000:05:00.0: @f1efd128 (virt) @31efd128 (dma) 0x31ed8001 - deq
[  216.575981] xhci_hcd 0000:05:00.0: @f1efd130 (virt) @31efd130 (dma) 0x400040 - tx_info
[  216.575989] xhci_hcd 0000:05:00.0: @f1efd134 (virt) @31efd134 (dma) 0x000000 - rsvd[0]
[  216.575998] xhci_hcd 0000:05:00.0: @f1efd138 (virt) @31efd138 (dma) 0x000000 - rsvd[1]
[  216.576007] xhci_hcd 0000:05:00.0: @f1efd13c (virt) @31efd13c (dma) 0x000000 - rsvd[2]
[  216.576018] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.576175] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.576227] xhci_hcd 0000:05:00.0: Endpoint 0x81 not halted, refusing to reset.
[  216.576237] xhci_hcd 0000:05:00.0: Endpoint 0x2 not halted, refusing to reset.
[  216.576250] xhci_hcd 0000:05:00.0: Endpoint 0x3 not halted, refusing to reset.
[  216.576263] xhci_hcd 0000:05:00.0: Endpoint 0x84 not halted, refusing to reset.
[  216.576363] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.576675] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.576704] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.577050] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.577078] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.577421] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.577435] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.577796] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.577808] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.578170] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.578183] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.578189] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.578546] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.578921] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.578932] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.578938] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.579294] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.579669] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.579680] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.579686] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.580044] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.580420] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.580481] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.580796] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.580807] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.580814] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.580820] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.581294] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.581668] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.581680] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.581687] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.582043] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.582419] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.582430] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.582436] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.582795] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.583167] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.583228] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.583543] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.583554] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.583561] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.583918] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.584293] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.584305] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.584312] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.584669] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.585043] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.585055] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.585063] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.585417] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.585792] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.585855] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.586167] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.586179] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.586187] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.586543] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.586918] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.586930] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.586937] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.587291] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.587665] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.587677] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.587684] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.588041] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.588417] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.588479] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.588792] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.588805] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.588812] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.588819] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.589264] xhci_hcd 0000:05:00.0: get port status, actual port 0 status  = 0x2a0
[  216.589270] xhci_hcd 0000:05:00.0: Get port status returned 0x2a0
[  216.589279] xhci_hcd 0000:05:00.0: get port status, actual port 1 status  = 0x2a0
[  216.589284] xhci_hcd 0000:05:00.0: Get port status returned 0x2a0
[  216.589291] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.589665] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.589678] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.589686] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.590040] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.590416] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.590428] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.590435] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.590792] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.591164] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.591225] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.591539] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.591551] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.591557] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.591914] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.592290] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.592301] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.592307] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.592665] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.593040] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.593053] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.593059] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.593414] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.593813] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.593909] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.594292] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.594345] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.594351] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.594667] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.595041] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.595091] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.595096] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.595416] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.595789] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.595806] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.595815] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.596164] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.596541] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.596630] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.596913] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.596925] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.596933] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.596940] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.597412] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.597787] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.597834] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.597842] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.598161] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.598538] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.598584] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.598591] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.598912] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.599286] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.599383] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.599661] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.599705] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.599711] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.600036] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.600412] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.600422] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.600427] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.600786] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.601161] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.601171] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.601176] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.601536] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.601910] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.602009] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.602285] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.602330] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.602336] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.602661] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.603036] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.603083] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.603089] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.603409] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.603784] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.603833] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.603839] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.604159] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.604535] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.604595] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.604910] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.604919] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.604924] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.604929] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.605409] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.605783] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.605829] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.605834] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.606158] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.606534] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.606579] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.606585] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.606909] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.607282] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.607375] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.607657] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.607705] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.607710] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.608032] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.608408] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.608417] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.608422] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.608783] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.609158] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.609201] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.609206] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.609532] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.609906] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.610032] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.610563] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.610591] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.610598] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.610907] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.611282] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.611326] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.611332] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.611656] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.612031] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.612075] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.612081] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.612405] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.612782] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.612875] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.613157] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.613200] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.613207] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.613242] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.613656] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.614030] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.614075] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.614081] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.614404] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.614781] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.614833] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.614839] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.615156] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.615529] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.615622] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.615904] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.615952] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.615958] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.616279] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.616655] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.616704] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.616709] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.617030] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.617405] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.617452] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.617458] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.617778] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.618153] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.618248] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.618528] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.618570] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.618575] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.618904] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.619279] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.619324] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.619329] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.619652] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.620027] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.620074] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.620079] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.620402] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.620779] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.620846] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.621153] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.621186] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.621196] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.621204] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.621652] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.622026] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.622043] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.622050] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.622401] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.622777] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.622794] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.622802] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.623152] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.623525] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.623591] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.623901] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.623919] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.623926] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.624275] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.624652] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.624666] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.624674] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.625029] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.625403] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.625417] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.625423] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.625775] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.626150] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.626213] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.626587] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.626604] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.626609] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.626900] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.627277] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.627307] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.627315] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.627648] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.628023] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.628033] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.628037] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.628398] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.628775] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.628831] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.629149] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.629157] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.629161] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.629165] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.629648] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.630022] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.630054] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.630058] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.630398] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.630774] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.630820] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.630827] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.631149] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.631522] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.631616] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.631897] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.631943] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.631948] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.632295] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.632648] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.632695] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.632700] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.633023] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.633398] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.633477] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.633483] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.633771] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.634146] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.634251] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.634521] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.634601] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.634608] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.634897] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.635272] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.635324] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.635329] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.635646] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.636020] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.636066] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.636071] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.636395] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.636772] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.636855] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.637147] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.637192] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.637198] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.637228] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.637646] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.638020] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.638067] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.638072] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.638394] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.638771] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.638815] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.638820] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.639146] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.639519] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.639612] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.639894] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.639937] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.639942] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.640269] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.640645] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.640699] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.640704] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.641020] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.641395] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.641500] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.641506] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.641768] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.642143] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.642256] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.642643] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.642678] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.642684] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.643019] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.643394] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.643435] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.643441] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.643767] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.644142] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.644179] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.644184] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.644517] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.644893] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.644972] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.645269] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.645340] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.645346] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.645351] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.645766] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.646141] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.646198] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.646204] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.646516] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.646892] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.646937] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.646942] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.647267] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.647641] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.647733] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.648025] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.648059] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.648064] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.648390] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.648766] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.648794] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.648799] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.649141] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.649517] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.649593] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.649599] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.649890] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.650264] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.650385] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.650765] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.650810] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.650815] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.651141] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.651516] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.651559] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.651564] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.651889] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.652264] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.652311] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.652316] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.652639] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.653042] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.653107] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.653391] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.653407] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.653414] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.653421] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.653889] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.654263] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.654278] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.654286] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.654638] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.655015] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.655031] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.655039] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.655390] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.655763] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.655826] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.656141] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.656154] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.656161] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.656515] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.656891] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.656903] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.656909] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.657265] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.657640] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.657659] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.657668] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.658031] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.658528] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.658593] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.658888] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.658901] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.658907] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.659265] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.659639] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.659652] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.659658] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.660012] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.660387] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.660403] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.660411] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.660762] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.661138] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.661253] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.661639] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.661652] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.661658] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.661663] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.662136] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.662511] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.662529] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.662536] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.662886] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.663262] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.663277] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.663284] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.663637] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.664017] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.664081] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.664385] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.664399] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.664407] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.664760] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.665137] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.665151] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.665158] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.665511] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.665886] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.665907] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.665914] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.666260] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.666634] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.666719] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.667009] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.667024] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.667032] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.667385] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.667760] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.667772] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.667778] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.668133] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.668508] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.668520] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.668525] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.668883] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.669267] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.669345] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.669635] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.669645] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.669651] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.669656] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.670132] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.670507] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.670598] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.670612] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.670882] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.671258] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.671346] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.671357] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.671634] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.672006] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.672140] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.672506] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.672594] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.672605] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.672881] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.673299] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.673344] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.673351] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.673632] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.674007] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.674146] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.674153] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.674609] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.674880] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.675017] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.675380] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.675467] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.675477] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.675756] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.676131] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.676221] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.676230] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.676505] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.676879] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.676967] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.676975] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.677256] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.677631] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.677720] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.678006] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.678038] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.678044] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.678049] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.678505] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.678879] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.678921] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.678927] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.679254] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.679630] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.679718] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.679730] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.680006] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.680419] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.680500] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.680878] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.680969] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.680984] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.681254] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.681630] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.681705] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.681713] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.682005] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.682380] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.682429] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.682435] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.682753] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.683129] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.683223] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.683503] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.683550] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.683556] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.683878] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.684253] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.684295] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.684300] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.684626] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.685000] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.685044] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.685050] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.685376] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.685752] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.685820] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.686129] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.686178] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.686185] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.686191] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.686627] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.687003] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.687020] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.687029] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.687377] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.687754] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.687769] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.687777] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.688128] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.688500] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.688563] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.688875] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.688888] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.688895] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.689251] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.689627] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.689643] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.689650] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.690002] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.690522] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.690537] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.690544] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.690876] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.691250] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.691314] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.691624] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.691673] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.691679] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.692000] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.692375] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.692385] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.692391] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.692748] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.693124] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.693141] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.693149] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.693498] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.693875] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.693941] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.694250] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.694262] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.694269] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.694276] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.694749] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.695123] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.695134] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.695141] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.695497] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.695874] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.695885] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.695892] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.696249] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.696622] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.696683] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.696997] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.697008] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.697015] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.697373] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.697748] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.697761] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.697768] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.698123] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.698498] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.698509] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.698516] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.698871] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.699247] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.699309] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.699621] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.699632] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.699638] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.699998] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.700373] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.700384] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.700391] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.700746] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.701120] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.701132] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.701139] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.701496] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.701871] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.701937] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.702246] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.702259] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.702266] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.702273] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.702745] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.703120] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.703133] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.703140] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.703494] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.703870] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.703883] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.703889] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.704245] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.704619] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.704745] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.705153] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.705169] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.705177] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.705494] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.705869] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.705884] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.705892] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.706244] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.706619] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.706636] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.706644] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.706992] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.707368] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.707434] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.707743] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.707755] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.707761] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.708120] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.708494] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.708505] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.708511] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.708867] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.709242] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.709254] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.709261] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.709617] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.709994] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.710056] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.710369] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.710380] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.710387] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.710393] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.710866] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.711241] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.711253] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.711259] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.711615] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.711993] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.712005] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.712011] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.712367] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.712741] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.712803] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.713115] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.713126] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.713133] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.713490] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.713867] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.713882] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.713889] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.714241] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.714616] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.714630] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.714638] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.714990] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.715365] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.715430] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.715739] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.715754] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.715761] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.716115] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.716491] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.716508] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.716516] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.716863] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.717239] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.717253] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.717260] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.717613] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.717990] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.718053] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.718364] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.718377] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.718383] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.718387] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.718863] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.719237] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.719247] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.719252] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.719612] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.719989] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.720005] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.720015] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.720363] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.720737] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.720800] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.721114] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.721126] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.721131] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.721487] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.721864] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.721944] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.721951] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.722238] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.722613] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.722658] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.722664] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.722986] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.723362] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.723460] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.723736] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.723783] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.723789] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.724112] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.724488] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.724538] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.724544] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.724860] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.725235] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.725301] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.725308] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.725610] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.725987] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.726111] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.726487] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.726537] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.726544] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.726550] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.726985] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.727360] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.727405] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.727411] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.727734] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.728111] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.728160] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.728165] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.728485] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.728859] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.728951] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.729234] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.729316] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.729322] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.729607] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.729984] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.730027] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.730032] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.730358] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.730734] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.730779] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.730784] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.731106] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.731481] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.731577] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.731856] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.731900] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.731905] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.732245] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.732607] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.732651] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.732657] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.732981] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.733356] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.733368] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.733374] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.733730] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.734107] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.734169] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.734482] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.734494] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.734499] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.734504] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.734980] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.735355] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.735369] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.735377] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.735730] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.736106] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.736118] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.736125] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.736481] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.736854] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.736914] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.737229] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.737242] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.737249] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.737604] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.737980] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.737992] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.737998] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.738526] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.738730] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.738742] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.738749] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.739103] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.739478] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.739539] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.739853] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.739864] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.739870] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.740230] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.740604] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.740619] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.740627] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.740978] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.741353] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.741368] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.741376] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.741727] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.742104] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.742169] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.742479] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.742491] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.742498] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.742505] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.742977] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.743352] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.743362] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.743369] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.743726] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.744103] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.744116] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.744123] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.744477] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.744852] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.744916] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.745227] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.745247] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.745254] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.745601] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.746016] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.746035] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.746040] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.746385] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.746763] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.746779] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.746783] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.747135] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.747512] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.747579] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.747881] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.747896] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.747900] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.748261] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.748649] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.748663] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.748667] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.748976] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.749351] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.749366] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.749370] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.749725] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.750100] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.750164] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.750475] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.750487] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.750492] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.750496] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.750973] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.751348] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.751359] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.751363] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.751723] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.752100] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.752111] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.752115] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.752475] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.752848] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.752908] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.753271] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.753297] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.753302] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.753598] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.753974] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.753985] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.753989] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.754349] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.754724] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.754735] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.754739] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.755097] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.755475] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.755542] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.755850] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.755866] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.755873] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.756226] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.756601] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.756617] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.756624] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.756976] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.757349] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.757367] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.757374] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.757723] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.758099] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.758162] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.758474] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.758488] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.758494] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.758498] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.758972] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.759346] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.759358] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.759362] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.759729] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.760134] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.760159] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.760168] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.760511] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.760879] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.760952] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.761260] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.761282] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.761287] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.761651] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.762009] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.762028] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.762034] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.762381] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.762757] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.762775] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.762781] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.763098] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.763505] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.763575] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.763878] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.763897] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.763903] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.764254] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.764631] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.764650] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.764657] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.765007] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.765411] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.765439] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.765448] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.765754] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.766130] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.766201] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.766503] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.766524] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.766532] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.766540] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.767003] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.767377] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.767397] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.767405] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.767756] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.768132] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.768152] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.768160] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.768504] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.768877] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.768947] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.769222] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.769245] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.769255] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.769633] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.770006] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.770022] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.770028] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.770496] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.770719] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.770738] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.770746] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.771093] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.771468] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.771537] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.771843] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.771866] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.771871] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.772252] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.772626] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.772642] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.772648] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.773000] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.773397] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.773419] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.773425] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.773754] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.774126] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.774192] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.774499] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.774514] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.774520] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.774525] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.775002] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.775371] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.775387] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.775392] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.775752] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.776125] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.776141] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.776146] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.776512] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.776888] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.776954] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.777412] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.777434] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.777440] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.777745] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.778094] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.778172] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.778179] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.778498] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.778878] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.778900] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.778908] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.779245] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.779622] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.779691] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.779997] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.780016] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.780023] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.780371] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.780748] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.780767] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.780774] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.781124] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.781464] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.781483] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.781489] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.781837] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.782213] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.782279] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.782588] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.782603] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.782611] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.782618] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.783087] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.783461] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.783474] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.783482] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.783836] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.784214] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.784258] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.784267] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.784588] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.784963] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.785025] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.785336] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.785359] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.785366] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.785711] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.786087] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.786098] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.786104] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.786497] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.786837] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.786847] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.786853] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.787210] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.787584] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.787650] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.787959] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.787973] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.787981] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.788336] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.788711] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.788724] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.788731] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.789084] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.789459] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.789473] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.789480] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.789833] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.790210] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.790272] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.790585] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.790597] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.790604] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.790611] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.791083] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.791458] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.791538] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.791544] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.791834] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.792210] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.792255] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.792261] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.792584] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.792958] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.793026] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.793333] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.793410] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.793416] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.793708] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.794087] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.794107] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.794113] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.794506] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.794877] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.794892] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.794897] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.795254] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.795626] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.795691] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.796006] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.796021] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.796026] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.796380] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.796755] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.796770] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.796775] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.797125] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.797456] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.797472] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.797479] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.797831] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.798208] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.798273] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.798582] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.798597] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.798605] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.798612] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.799080] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.799455] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.799466] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.799473] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.799830] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.800206] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.800217] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.800224] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.800581] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.800954] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.801015] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.801329] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.801341] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.801347] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.801703] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.802079] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.802091] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.802097] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.802498] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.802829] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.802840] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.802846] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.803216] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.803577] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.803638] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.803953] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.803965] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.803971] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.804328] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.804703] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.804715] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.804721] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.805078] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.805485] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.805503] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.805508] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.805860] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.806237] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.806301] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.806614] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.806636] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.806645] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.806653] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.807082] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.807457] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.807482] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.807491] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.807829] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.808205] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.808224] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.808236] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.808580] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.808952] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.809017] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.809328] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.809350] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.809358] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.809701] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.810078] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.810100] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.810108] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.810452] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.810827] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.810844] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.810852] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.811201] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.811575] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.811643] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.811950] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.811967] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.811974] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.812327] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.812701] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.812724] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.812731] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.813074] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.813450] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.813467] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.813475] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.813824] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.814201] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.814267] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.814576] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.814593] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.814601] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.814609] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.815074] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.815448] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.815466] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.815474] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.815824] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.816200] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.816217] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.816224] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.816575] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.816948] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.817014] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.817323] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.817338] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.817344] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.817697] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.818073] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.818087] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.818093] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.818508] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.818827] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.818856] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.818863] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.819197] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.819572] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.819637] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.819946] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.819962] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.819968] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.820376] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.820699] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.820715] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.820721] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.821071] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.821446] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.821466] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.821473] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.821821] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.822197] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.822261] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.822572] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.822583] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.822588] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.822593] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.823070] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.823444] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.823456] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.823461] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.823818] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.824195] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.824206] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.824211] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.824569] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.824943] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.825006] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.825343] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.825358] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.825368] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.825693] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.826069] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.826113] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.826119] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.826444] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.826819] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.826833] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.826840] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.827192] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.827567] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.827633] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.827942] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.827985] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.827992] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.828343] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.828693] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.828709] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.828716] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.829066] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.829442] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.829454] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.829460] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.829816] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.830193] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.830254] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.830568] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.830579] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.830586] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.830592] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.831066] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.831440] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.831455] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.831463] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.831815] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.832192] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.832241] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.832249] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.832567] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.832940] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.833002] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.833315] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.833361] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.833368] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.833690] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.834066] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.834114] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.834120] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.834494] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.834816] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.834864] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.834871] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.835189] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.835564] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.835662] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.835938] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.835984] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.835989] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.836315] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.836690] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.836732] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.836737] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.837063] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.837438] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.837489] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.837494] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.837814] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.838191] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.838283] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.838566] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.838613] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.838620] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.838624] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.839064] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.839440] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.839490] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.839495] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.839814] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.840190] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.840242] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.840247] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.840564] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.840937] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.841032] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.841316] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.841339] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.841347] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.841754] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.842112] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.842129] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.842135] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.842442] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.842817] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.842834] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.842840] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.843188] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.843562] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.843625] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.843937] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.843949] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.843955] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.844313] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.844689] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.844701] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.844707] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.845061] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.845437] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.845452] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.845458] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.845810] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.846189] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.846260] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.846563] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.846576] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.846583] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.846588] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.847060] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.847489] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.847519] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.847524] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.847809] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.848239] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.848268] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.848274] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.848561] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.848976] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.849049] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.849475] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.849503] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.849514] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.849809] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.850240] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.850270] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.850276] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.850560] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.850936] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.850951] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.850957] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.851309] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.851711] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.851792] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.852058] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.852075] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.852081] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.852435] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.852826] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.852857] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.852863] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.853183] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.853559] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.853576] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.853582] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.853935] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.854312] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.854378] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.854684] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.854700] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.854706] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.854712] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.855183] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.855556] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.855568] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.855573] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.855930] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.856330] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.856342] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.856348] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.856682] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.857055] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.857118] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.857450] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.857467] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.857475] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.857842] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.858182] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.858196] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.858223] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.858557] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.858931] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.858945] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.858953] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.859306] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.859679] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.859743] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.860055] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.860069] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.860078] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.860431] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.860805] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.860819] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.860827] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.861179] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.861554] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.861568] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.861577] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.861934] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.862309] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.862373] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.862681] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.862695] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.862703] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.862711] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.863179] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.863553] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.863567] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.863575] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.863928] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.864304] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.864317] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.864326] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.864680] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.865052] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.865116] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.865452] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.865468] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.865475] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.865802] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.866178] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.866189] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.866196] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.866553] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.866927] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.866939] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.866945] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.867301] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.867676] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.867737] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.868051] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.868063] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.868069] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.868427] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.868802] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.868813] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.868819] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.869176] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.869550] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.869562] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.869568] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.869925] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.870305] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.870373] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.870711] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.870727] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.870732] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.870736] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.871208] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.871584] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.871599] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.871604] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.871961] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.872301] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.872316] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.872320] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.872708] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.873052] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.873117] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.873426] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.873442] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.873448] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.873801] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.874177] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.874193] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.874199] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.874552] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.874927] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.874942] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.874949] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.875300] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.875675] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.875740] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.876049] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.876064] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.876071] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.876425] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.876801] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.876816] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.876823] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.877179] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.877549] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.877568] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.877576] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.877924] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.878300] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.878366] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.878675] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.878692] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.878700] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.878707] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.879174] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.879548] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.879564] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.879572] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.879923] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.880299] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.880314] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.880321] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.880675] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.881048] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.881151] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.881424] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.881441] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.881449] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.881798] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.882173] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.882188] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.882195] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.882549] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.882953] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.882970] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.882976] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.883328] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.883702] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.883767] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.884045] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.884057] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.884061] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.884421] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.884827] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.884842] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.884847] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.885170] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.885544] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.885559] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.885576] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.885919] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.886295] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.886360] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.886670] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.886683] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.886690] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.886696] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.887168] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.887542] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.887554] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.887561] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.887919] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.888295] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.888312] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.888319] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.888671] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.889044] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.889107] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.889418] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.889429] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.889435] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.889792] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.890169] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.890179] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.890185] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.890544] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.890920] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.890932] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.890936] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.891292] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.891666] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.891726] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.892042] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.892051] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.892055] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.892418] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.892792] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.892801] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.892805] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.893207] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.893542] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.893555] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.893562] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.893917] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.894293] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.894360] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.894670] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.894684] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.894690] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.894696] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.895167] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.895540] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.895553] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.895560] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.895916] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.896292] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.896308] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.896314] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.896666] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.897039] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.897100] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.897415] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.897425] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.897431] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.897789] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.898168] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.898182] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.898189] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.898543] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.898916] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.898932] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.898939] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.899290] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.899665] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.899730] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.900040] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.900053] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.900058] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.900415] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.900793] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.900810] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.900816] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.901170] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.901541] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.901567] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.901578] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.901918] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.902293] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.902437] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.902808] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.902837] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.902848] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.902861] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.903292] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.903666] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.903692] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.903705] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.904041] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.904417] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.904441] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.904453] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.904792] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.905163] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.905234] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.905540] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.905564] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.905576] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.905915] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.906292] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.906316] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.906328] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.906666] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.907041] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.907065] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.907076] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.907415] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.907789] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.907865] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.908164] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.908190] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.908204] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.908540] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.908915] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.908940] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.908952] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.909290] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.909664] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.909692] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.909703] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.910038] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.910415] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.910489] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.910790] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.910815] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.910826] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.910838] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.911288] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.911662] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.911685] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.911698] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.912038] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.912414] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.912438] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.912450] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.912789] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.913219] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.913293] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.913659] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.913674] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.913680] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.914034] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.914512] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.914527] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.914533] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.914910] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.915285] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.915299] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.915305] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.915658] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.916033] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.916097] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.916408] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.916423] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.916428] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.916784] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.917160] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.917176] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.917182] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.917532] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.917907] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.917921] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.917928] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.918281] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.918658] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.918764] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.919033] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.919048] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.919055] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.919060] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.919532] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.919906] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.919921] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.919927] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.920281] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.920658] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.920672] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.920679] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.921032] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.921407] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.921474] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.921781] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.921797] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.921804] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.922156] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.922557] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.922585] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.922595] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.922939] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.923305] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.923329] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.923339] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.923677] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.924050] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.924124] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.924442] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.924466] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.924476] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.924820] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.925160] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.925211] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.925226] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.925531] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.925904] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.925922] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.925930] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.926280] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.926656] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.926723] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.927031] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.927049] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.927057] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.927065] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.927529] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.927904] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.927921] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.927929] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.928279] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.928655] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.928672] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.928680] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.929030] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.929403] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.929471] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.929778] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.929793] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.929798] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.930152] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.930529] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.930543] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.930549] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.930903] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.931278] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.931292] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.931298] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.931652] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.932027] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.932092] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.932401] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.932473] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.932479] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.932778] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.933207] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.933229] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.933235] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.933572] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.933945] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.933961] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.933966] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.934329] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.934696] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.934761] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.935154] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.935169] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.935174] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.935178] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.935693] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.936058] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.936072] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.936077] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.936434] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.936808] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.936822] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.936827] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.937153] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.937559] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.937636] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.938059] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.938082] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.938091] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.938432] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.938813] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.938837] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.938847] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.939185] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.939560] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.939584] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.939594] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.939930] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.940305] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.940378] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.940683] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.940707] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.940716] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.941061] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.941473] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.941507] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.941517] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.941935] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.942306] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.942331] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.942341] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.942689] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.943061] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.943134] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.943556] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.943581] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.943590] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.943599] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.944058] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.944431] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.944455] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.944465] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.944808] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.945189] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.945221] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.945230] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.945560] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.945930] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.946004] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.946553] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.946575] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.946584] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.946931] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.947309] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.947333] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.947343] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.947683] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.948057] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.948081] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.948091] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.948429] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.948804] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.948877] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.949317] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.949341] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.949348] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.949692] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.950066] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.950083] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.950088] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.950441] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.950812] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.950828] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.950832] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.951186] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.951563] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.951629] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.952067] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.952082] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.952088] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.952092] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.952564] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.952982] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.953008] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.953013] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.953437] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.953800] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.953819] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.953824] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.954174] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.954525] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.954595] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.954931] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.954949] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.954954] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.955300] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.955676] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.955694] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.955700] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.956049] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.956425] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.956443] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.956449] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.956797] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.957143] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.957212] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.957592] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.957620] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.957629] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.957960] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.958340] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.958367] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.958378] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.958712] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.959090] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.959119] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.959128] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.959433] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.959841] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.959916] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.960338] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.960366] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.960372] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.960378] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.960771] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.961153] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.961201] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.961207] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.961520] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.961969] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.961996] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.962003] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.962469] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.962716] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.962794] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.963214] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.963241] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.963247] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.963588] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.963898] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.963974] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.963980] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.964311] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.964685] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.964701] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.964706] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.965061] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.965436] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.965504] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.965935] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.965950] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.965955] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.966310] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.966684] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.966700] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.966704] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.967059] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.967435] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.967450] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.967454] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.967810] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.968170] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.968234] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.968546] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.968560] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.968566] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.968569] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.969013] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.969386] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.969402] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.969409] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.969759] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.970136] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.970150] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.970158] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.970511] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.970883] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.970946] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.971259] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.971272] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.971279] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.971634] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.972009] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.972022] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.972029] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.972385] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.972760] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.972772] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.972780] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.973134] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.973508] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.973571] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.973883] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.973896] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.973903] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.974259] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.974634] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.974647] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.974655] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.975007] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.975381] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.975394] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.975401] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.975757] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.976133] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.976195] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.976569] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.976591] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.976598] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  216.976605] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.977040] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.977382] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.977397] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.977403] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.977756] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.978132] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.978143] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.978149] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.978508] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.978918] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.978986] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.979292] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.979309] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.979315] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.979664] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  216.980042] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  216.980058] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.980064] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.980414] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  216.980793] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  216.980809] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.980815] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.981131] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  216.981504] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  216.981567] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.981879] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  216.981892] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.981898] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.982255] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  216.982630] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  216.982641] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.982648] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.983004] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  216.983378] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  216.983390] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.983396] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.983753] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  216.984129] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  216.984191] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.984505] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  216.984518] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.984525] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  216.984532] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.985003] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  216.985379] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  216.985395] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.985404] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.985753] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  216.986141] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  216.986161] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.986167] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.986541] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  216.986913] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  216.986980] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  216.987289] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  216.987308] MAC address: 00:c0:ca:52:c6:73
[  216.987313] Board Type 1
[  217.071052] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.071352] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.071514] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.071852] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.071878] rx_max_size 15360, rx_urb_num 8, in_ep 1
[  217.071884] Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[  217.071889] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071893] Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[  217.071897] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071901] Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[  217.071906] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071909] Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[  217.071914] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071918] Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[  217.071922] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071926] Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[  217.071931] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071934] Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[  217.071939] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071943] Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[  217.071948] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071951] Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[  217.071956] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071960] Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[  217.071964] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071968] Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[  217.071977] 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
[  217.071985] Disabling freq 2467 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  217.071993] Disabling freq 2472 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  217.072001] Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
[  217.072104] Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
[  217.072333] Calling CRDA for country: US
[  217.076499] Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[  217.076504] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076508] Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[  217.076513] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076517] Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
[  217.076521] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076525] Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
[  217.076529] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076532] Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
[  217.076536] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076540] Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
[  217.076544] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076548] Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
[  217.076552] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076556] Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
[  217.076561] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076564] Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
[  217.076568] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076572] Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
[  217.076577] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076580] Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
[  217.076585] 2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076588] Disabling freq 2467 MHz
[  217.076592] Disabling freq 2472 MHz
[  217.076596] Disabling freq 2484 MHz
[  217.076601] Regulatory domain changed to country: US
[  217.076605]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  217.076610]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
[  217.076615]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[  217.076621]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  217.076626]     (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  217.076631]     (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  217.076637]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
[  217.105837] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
[  217.374056] udevd[578]: renamed network interface wlan0 to wlan1
[  217.376306] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.376604] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.376647] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.376663] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.376778] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.376974] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.377344] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.377719] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.377740] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.378094] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.378113] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.378122] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.378474] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.378849] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.378923] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.379222] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.379287] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.379593] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.379613] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.379969] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.379985] MAC auto ON okay!
[  217.379993] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.380001] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.380345] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.380721] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.380739] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.380746] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  217.380752] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.381219] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.381592] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.381637] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.381646] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.381968] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.382343] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.382360] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.382718] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.382732] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.382738] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.382744] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.383091] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.383467] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.383842] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.383860] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.383866] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.384218] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.384593] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.384609] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.384615] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.384967] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.385340] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.385771] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.385778] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.386089] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.386464] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.386509] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.386514] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.386840] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.387215] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.387231] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.387237] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.387589] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.387962] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.388006] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.388011] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.388337] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.388713] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.388731] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.388740] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.388748] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  217.389091] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.389589] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.389608] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.389617] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.389964] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.390338] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.390352] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.390360] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.390714] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.391089] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.391103] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.391111] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.391462] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.391838] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.391853] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.391861] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.392212] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.392589] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.392603] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.392611] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.392965] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.393340] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.393359] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.393368] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.393713] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.394086] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.394102] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.394112] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.394461] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.394850] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.394882] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.394893] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.395249] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.395593] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.395624] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.395638] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.395969] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.396360] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.396389] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.396399] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.396744] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.397087] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.397104] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.397113] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  217.397120] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.397585] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.397958] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.397972] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.397980] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.398334] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.398709] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.398722] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.398728] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.399085] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.399458] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.399470] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.399477] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.399833] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.400207] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.400220] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.400226] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.400584] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.400977] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.400994] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.400999] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.401378] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.401754] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.401769] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.401774] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.402126] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.402502] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.402514] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.402518] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.402877] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.403211] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.403227] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.403232] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.403584] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.403957] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.403972] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.403976] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.404332] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.404708] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.404719] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.404723] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.404728] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  217.405085] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.405582] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.405603] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.405611] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.405956] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.406331] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.406349] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.406356] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.406707] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.407083] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.407100] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.407107] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.407456] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.407830] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.407847] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.407854] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.408206] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.408582] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.408600] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.408607] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.409032] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.409332] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.409350] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.409357] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.409705] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.410080] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.410096] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.410104] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.410454] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.410831] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.410848] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.410855] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.411206] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.411579] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.411597] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.411605] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.411954] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.412329] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.412345] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.412353] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.412705] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.413081] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.413100] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.413108] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  217.413115] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.413578] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.413954] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.413976] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.413984] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.414329] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.414705] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.414724] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.414731] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.415080] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.415453] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.415474] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.415482] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.415828] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.416203] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.416223] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.416231] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.416579] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.417053] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.417087] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.417095] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.417453] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.417826] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.417843] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.417849] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.418201] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.418576] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.418593] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.418599] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.418953] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.419326] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.419343] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.419350] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.419700] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.420074] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.420088] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.420094] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.420450] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.420825] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.420838] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.420844] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.420851] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  217.421201] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.421699] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.421714] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.421721] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.422074] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.422449] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.422464] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.422471] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.422825] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.423200] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.423214] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.423222] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.423573] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.423949] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.423968] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.423976] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.424323] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.424700] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.424716] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.424723] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.425075] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.425449] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.425464] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.425471] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.425822] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.426197] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.426211] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.426218] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.426573] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.426948] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.426962] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.426970] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.427323] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.427696] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.427710] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.427717] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.428072] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.428446] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.428460] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.428467] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.428823] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.429198] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.429213] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.429220] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  217.429226] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.429696] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.430070] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.430083] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.430089] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.430446] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.430821] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.430834] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.430840] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.431199] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.431610] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.431637] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.431647] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.431983] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.432355] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.432379] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.432388] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.432731] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.433091] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.433113] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.433120] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.433445] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.433818] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.433828] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.433833] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.434193] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.434694] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.434721] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.434730] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.435092] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.435468] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.435492] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.435501] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.435842] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.436195] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.436216] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.436224] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.436589] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.437048] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.437077] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.437081] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.437086] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  217.437444] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.437942] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.437957] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.437963] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.438341] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.438691] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.438705] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.438711] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.439068] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.439443] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.439455] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.439459] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.439816] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.440191] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.440202] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.440206] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.440605] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.440944] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.440977] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.440987] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.441317] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.441702] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.441734] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.441741] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.442065] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.442444] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.442461] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.442465] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.442874] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.443192] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.443205] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.443209] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.443567] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.443940] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.443950] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.443954] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.444343] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.444690] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.444703] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.444707] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.445127] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.445481] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.445502] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.445509] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  217.445516] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.445974] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.446360] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.446384] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.446391] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.446725] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.447101] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.447122] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.447129] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.447477] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.447815] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.447832] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.447839] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.448190] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.448603] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.448623] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.448630] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.448949] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.449350] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.449372] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.449379] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.449728] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.450098] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.450118] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.450125] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.450489] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.450845] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.450860] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.450865] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.451221] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.451598] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.451613] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.451618] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.451968] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.452348] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.452365] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.452370] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.452717] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.453099] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.453115] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.453120] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.453125] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  217.453471] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.453976] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.453993] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.453998] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.454347] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.454716] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.454732] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.454737] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.455064] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.455474] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.455498] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.455505] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.455850] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.456220] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.456245] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.456255] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.456567] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.456941] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.456970] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.456981] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.457314] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.457687] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.457712] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.457721] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.458061] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.458437] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.458458] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.458467] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.458810] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.459186] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.459206] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.459214] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.459561] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.459936] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.459960] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.459971] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.460310] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.460684] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.460703] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.460712] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.461061] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.461436] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.461456] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.461465] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 1
[  217.461474] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.461934] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.462309] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.462330] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.462339] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.462684] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.463060] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.463079] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.463088] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.463435] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.463808] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.463827] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.463836] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.464183] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.464560] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.464579] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.464591] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.464989] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.465308] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.465321] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.465325] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.465682] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.466055] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.466068] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.466072] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.466430] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.466805] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793472
[  217.466816] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.466822] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.467181] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793520
[  217.467556] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793568
[  217.467568] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.467573] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.467930] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793616
[  217.468305] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793664
[  217.468320] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.468325] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.468679] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793712
[  217.469058] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793760
[  217.469336] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.469343] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.469348] xhci_hcd 0000:05:00.0: Toggle cycle state for ring f270ef80 = 0
[  217.469681] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793808
[  217.470191] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792848
[  217.470217] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.470225] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.470589] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792896
[  217.470967] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792944
[  217.470987] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.470993] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.471342] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924792992
[  217.471720] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793040
[  217.471739] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.471746] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.472108] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793088
[  217.472472] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793136
[  217.472486] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.472491] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.472837] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793184
[  217.473181] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793232
[  217.473201] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.473208] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.473555] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793280
[  217.473933] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793328
[  217.473952] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.473959] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.474387] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793376
[  217.474678] xhci_hcd 0000:05:00.0: DMA address or buffer contents= 924793424
[  217.474689] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0
[  217.474694] xhci_hcd 0000:05:00.0: Queueing ctrl tx for slot id 1, ep 0

--------------060403000704010604000306--
