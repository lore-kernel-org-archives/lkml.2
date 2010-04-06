Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab0DFSIe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 14:08:34 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:40625 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757274Ab0DFSIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 14:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:subject:to:cc:in-reply-to:references;
        b=HnyVjL0SIkyqrIcltxX/RVN4cNN8xLxYfA9n/KBws32HdVKROEWaIJiESXYKTZcgxZ
         MqtG6yW/iJyU/PSSdANiX7dKLGd6W5JxteZAVBUdkLoeS0LD0xAlPzTcGc1mcE48HP+g
         hMj5iDy/7qO4F9EDtUG543lPp9X14I/nLSL3c=
Message-ID: <4bbb7896.48c3f10a.30b9.365b@mx.google.com>
Date: Tue, 06 Apr 2010 11:08:22 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
Subject: Lockup inside of stop_machine() during modprobe aes (was Re: Another
	AR5008 hang)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       ath9k@venema.h4ckr.net
In-Reply-To: <4bb235fb.0baa660a.5b56.ffffa9c2@mx.google.com>
References: <4bb0e2da.04c2f10a.32b2.11ae@mx.google.com>
	<1269928986.3927.5.camel@jlt3.sipsolutions.net>
	<4bb1f940.47c2f10a.3469.609b@mx.google.com>
	<4bb235fb.0baa660a.5b56.ffffa9c2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010 10:33:47 -0700 (PDT), Ben Gamari <bgamari.foss@gmail.com> wrote:
> On Tue, 30 Mar 2010 06:14:40 -0700 (PDT), Ben Gamari <bgamari.foss@gmail.com> wrote:
> > On Tue, 30 Mar 2010 08:03:06 +0200, Johannes Berg <johannes@sipsolutions.net> wrote:
> > > On Mon, 2010-03-29 at 10:26 -0700, Ben Gamari wrote:
> > > > New (2.6.33 and greater) kernels seem to result in a selective hang on my
> > > > machine only seconds after association with an 802.11N access point
> > > > (hosted with hostapd and another ar5008).
> > > 
> > > None, I would think, this seems to be a lockup between
> > > modprobe/stop_machine and some rtnl things, but I have no idea why that
> > > would happen. Do you have lockdep enabled? And if you do, please disable
> > > RCU lockdep as it typically gives you a warning and then turns off
> > > lockdep...
> > > 
> > Thank you very much for your response. I do not currently have lockdep enabled,
> > but I'm building a new kernel as we speak. Thanks again,
> > 
> Well, it will take me a bit longer than expected to get lockdep results on
> 2.6.34 due to a recent change[1] in how sysfs attributes are exposed to
> lockdep. Hopefully this will be fixed soon.
> 
> That being said, after discovering this I went back and recompiled with
> lockdep. Unfortunately, I'm now having trouble reproducing the issue on this
> release. I still can with 2.6.34-rc1 though, so, again, hopefully soon I'll be
> able to say where the deadlock occurs. I'll let you know as soon as I have
> news. Thanks for your help,

Hey all,

I just built 2.6.34-rc3 with the appropriate fixes for the ACPI thermal lockdep
issues and have attached the dmesg output of the crash below. It appears that
modprobe is freezing with a few locks held while inserting aes.ko. In
particular, it seems that the kernel is deadlocking inside of stop_machine()
while flushing workqueues.

Any ideas?
Thanks,

- Ben

P.S. I am now quite certain that I was mistaken in saying that 2.6.33 was
affected. This seems to just be a 2.6.34 issue.


[1] dmesg output
======================================================================
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.34-rc3-ben (ben@ben-laptop) (gcc version 4.4.3 (Ubuntu 4.4.3-4ubuntu5) ) #145 SMP Tue Apr 6 13:44:12 EDT 2010
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-ben root=/dev/sda6 ro quiet splash pciehp.pciehp_force=1
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
[    0.000000]  BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  BIOS-e820: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  BIOS-e820: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 0DF800000 mask FFF800000 uncachable
[    0.000000]   5 base 0DF700000 mask FFFF00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000df700000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdf65a max_arch_pfn = 0x400000000
[    0.000000] e820 update range: 0000000000001000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009f000 (usable)
[    0.000000]  modified: 000000000009f000 - 00000000000a0000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000df65a800 (usable)
[    0.000000]  modified: 00000000df65a800 - 00000000e0000000 (reserved)
[    0.000000]  modified: 00000000f8000000 - 00000000fc000000 (reserved)
[    0.000000]  modified: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  modified: 00000000fed18000 - 00000000fed1c000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed90000 (reserved)
[    0.000000]  modified: 00000000feda0000 - 00000000feda6000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee10000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000df65a000
[    0.000000]  0000000000 - 00df600000 page 2M
[    0.000000]  00df600000 - 00df65a000 page 4k
[    0.000000] kernel direct mapping tables up to df65a000 @ 16000-1c000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 1a000-20000
[    0.000000] RAMDISK: 35efe000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fbb10 00024 (v02 DELL  )
[    0.000000] ACPI: XSDT 00000000df65d200 00064 (v01 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: FACP 00000000df65d09c 000F4 (v04 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: DSDT 00000000df65d800 063B2 (v02 INT430 SYSFexxx 00001001 INTL 20050624)
[    0.000000] ACPI: FACS 00000000df66c000 00040
[    0.000000] ACPI: HPET 00000000df65d300 00038 (v01 DELL    M08     00000001 ASL  00000061)
[    0.000000] ACPI: APIC 00000000df65d400 00068 (v01 DELL    M08     27D80C0B ASL  00000047)
[    0.000000] ACPI: ASF! 00000000df65d000 0007E (v32 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: MCFG 00000000df65d3c0 0003E (v16 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: TCPA 00000000df65d700 00032 (v01                 00000000 ASL  00000000)
[    0.000000] ACPI: SLIC 00000000df65d49c 00176 (v01 DELL    M08     27D80C0B ASL  00000061)
[    0.000000] ACPI: SSDT 00000000df65b9c0 004CC (v01  PmRef    CpuPm 00003000 INTL 20050624)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880100200000-ffff880103bfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000df65a
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1045993
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3927 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 896658 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] early_res array is doubled to 64 at [1b000 - 1b7ff]
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000df65a000 - 00000000df65b000
[    0.000000] PM: Registered nosave memory: 00000000df65b000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000f8000000
[    0.000000] PM: Registered nosave memory: 00000000f8000000 - 00000000fc000000
[    0.000000] PM: Registered nosave memory: 00000000fc000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fed18000
[    0.000000] PM: Registered nosave memory: 00000000fed18000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed20000
[    0.000000] PM: Registered nosave memory: 00000000fed20000 - 00000000fed90000
[    0.000000] PM: Registered nosave memory: 00000000fed90000 - 00000000feda0000
[    0.000000] PM: Registered nosave memory: 00000000feda0000 - 00000000feda6000
[    0.000000] PM: Registered nosave memory: 00000000feda6000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee10000
[    0.000000] PM: Registered nosave memory: 00000000fee10000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:18000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880002600000 s92008 r8192 d22680 u1048576
[    0.000000] pcpu-alloc: s92008 r8192 d22680 u1048576 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1029865
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-2.6.34-rc3-ben root=/dev/sda6 ro quiet splash pciehp.pciehp_force=1
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Subtract (52 early reservations)
[    0.000000]   #1 [0001000000 - 00024d9ed8]   TEXT DATA BSS
[    0.000000]   #2 [0035efe000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [000009f000 - 0000100000]   BIOS reserved
[    0.000000]   #4 [00024da000 - 00024da1ec]             BRK
[    0.000000]   #5 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #6 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #7 [0000016000 - 000001a000]         PGTABLE
[    0.000000]   #8 [000001a000 - 000001b000]         PGTABLE
[    0.000000]   #9 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #10 [00024da200 - 00024db200]         BOOTMEM
[    0.000000]   #11 [00028db200 - 00028db500]         BOOTMEM
[    0.000000]   #12 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #13 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #14 [0100200000 - 0103c00000]        MEMMAP 0
[    0.000000]   #15 [00024db200 - 00024db600]         BOOTMEM
[    0.000000]   #16 [00024db600 - 000251b600]         BOOTMEM
[    0.000000]   #17 [000251b600 - 0002523600]         BOOTMEM
[    0.000000]   #18 [0002524000 - 0002525000]         BOOTMEM
[    0.000000]   #19 [00024d9f00 - 00024d9f41]         BOOTMEM
[    0.000000]   #20 [00024d9f80 - 00024d9fc3]         BOOTMEM
[    0.000000]   #21 [0002523600 - 00025238d8]         BOOTMEM
[    0.000000]   #22 [0002523900 - 0002523968]         BOOTMEM
[    0.000000]   #23 [0002523980 - 00025239e8]         BOOTMEM
[    0.000000]   #24 [0002523a00 - 0002523a68]         BOOTMEM
[    0.000000]   #25 [0002523a80 - 0002523ae8]         BOOTMEM
[    0.000000]   #26 [0002523b00 - 0002523b68]         BOOTMEM
[    0.000000]   #27 [0002523b80 - 0002523be8]         BOOTMEM
[    0.000000]   #28 [0002523c00 - 0002523c68]         BOOTMEM
[    0.000000]   #29 [0002523c80 - 0002523ce8]         BOOTMEM
[    0.000000]   #30 [0002523d00 - 0002523d68]         BOOTMEM
[    0.000000]   #31 [0002523d80 - 0002523de8]         BOOTMEM
[    0.000000]   #32 [0002523e00 - 0002523e68]         BOOTMEM
[    0.000000]   #33 [0002523e80 - 0002523ee8]         BOOTMEM
[    0.000000]   #34 [0002523f00 - 0002523f20]         BOOTMEM
[    0.000000]   #35 [0002523f40 - 0002523f60]         BOOTMEM
[    0.000000]   #36 [0002523f80 - 0002523fd8]         BOOTMEM
[    0.000000]   #37 [0002525000 - 0002525058]         BOOTMEM
[    0.000000]   #38 [0002600000 - 000261e000]         BOOTMEM
[    0.000000]   #39 [0002700000 - 000271e000]         BOOTMEM
[    0.000000]   #40 [0002527080 - 0002527088]         BOOTMEM
[    0.000000]   #41 [00025270c0 - 00025270c8]         BOOTMEM
[    0.000000]   #42 [0002527100 - 0002527108]         BOOTMEM
[    0.000000]   #43 [0002527140 - 0002527150]         BOOTMEM
[    0.000000]   #44 [0002527180 - 00025272c0]         BOOTMEM
[    0.000000]   #45 [00025272c0 - 0002527320]         BOOTMEM
[    0.000000]   #46 [0002527340 - 00025273a0]         BOOTMEM
[    0.000000]   #47 [00025273c0 - 000252f3c0]         BOOTMEM
[    0.000000]   #48 [00028dc000 - 00068dc000]         BOOTMEM
[    0.000000]   #49 [000252f3c0 - 000254f3c0]         BOOTMEM
[    0.000000]   #50 [000254f3c0 - 000258f3c0]         BOOTMEM
[    0.000000]   #51 [000001b800 - 0000023800]         BOOTMEM
[    0.000000] Memory: 4002880k/4718592k available (5910k kernel code, 534620k absent, 181092k reserved, 5275k data, 820k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.000000] ... MAX_LOCKDEP_CHAINS:      32768
[    0.000000] ... CHAINHASH_SIZE:          16384
[    0.000000]  memory used by lock dependency info: 5855 kB
[    0.000000]  per task-struct memory footprint: 1920 bytes
[    0.000000] allocated 41943040 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2194.349 MHz processor.
[    0.004017] Calibrating delay loop (skipped), value calculated using timer frequency.. 4388.69 BogoMIPS (lpj=8777396)
[    0.004086] Security Framework initialized
[    0.004095] SELinux:  Disabled at boot.
[    0.004619] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.009214] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.010397] Mount-cache hash table entries: 256
[    0.011337] Initializing cgroup subsys ns
[    0.011343] Initializing cgroup subsys cpuacct
[    0.011351] Initializing cgroup subsys memory
[    0.011396] Initializing cgroup subsys freezer
[    0.011399] Initializing cgroup subsys net_cls
[    0.011461] CPU: Physical Processor ID: 0
[    0.011463] CPU: Processor Core ID: 0
[    0.011467] mce: CPU supports 6 MCE banks
[    0.011475] CPU0: Thermal monitoring enabled (TM2)
[    0.011481] using mwait in idle threads.
[    0.011483] Performance Events: Core2 events, Intel PMU driver.
[    0.011497] ... version:                2
[    0.011498] ... bit width:              40
[    0.011500] ... generic registers:      2
[    0.011502] ... value mask:             000000ffffffffff
[    0.011504] ... max period:             000000007fffffff
[    0.011506] ... fixed-purpose events:   3
[    0.011508] ... event mask:             0000000700000003
[    0.012843] ACPI: Core revision 20100121
[    0.026909] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.026915] ftrace: allocating 21071 entries in 83 pages
[    0.028136] Setting APIC routing to flat
[    0.032349] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.072041] CPU0: Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz stepping 0b
[    0.076000] lockdep: fixing up alternatives.
[    0.076000] Booting Node   0, Processors  #1 Ok.
[    0.164051] Brought up 2 CPUs
[    0.164055] Total of 2 processors activated (8777.68 BogoMIPS).
[    0.165263] Time: 17:51:45  Date: 04/06/10
[    0.165263] NET: Registered protocol family 16
[    0.165263] ACPI: bus type pci registered
[    0.168018] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.168022] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in E820
[    0.184532] PCI: Using configuration type 1 for base access
[    0.188094] bio: create slab <bio-0> at 0
[    0.196196] ACPI: EC: Look up EC in DSDT
[    0.212326] ACPI: BIOS _OSI(Linux) query ignored
[    0.218679] ACPI: SSDT 00000000df66c080 00043 (v01  LMPWR  DELLLOM 00001001 INTL 20050624)
[    0.240066] ACPI: SSDT 00000000df65c4f6 00286 (v01  PmRef  Cpu0Ist 00003000 INTL 20050624)
[    0.241425] ACPI: SSDT 00000000df65be8c 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20050624)
[    0.242928] ACPI: SSDT 00000000df65c77c 000C4 (v01  PmRef  Cpu1Ist 00003000 INTL 20050624)
[    0.244140] ACPI: SSDT 00000000df65c471 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050624)
[    0.245253] ACPI: Interpreter enabled
[    0.245257] ACPI: (supports S0 S3 S4 S5)
[    0.245303] ACPI: Using IOAPIC for interrupt routing
[    0.336134] ACPI: ACPI Dock Station Driver: 3 docks/bays found
[    0.336138] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.353763] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.389123] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.389127] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.389130] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.389133] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.389136] pci_root PNP0A03:00: host bridge window [mem 0xe0000000-0xf7ffffff]
[    0.389139] pci_root PNP0A03:00: host bridge window [mem 0xfc000000-0xfebfffff]
[    0.389142] pci_root PNP0A03:00: host bridge window [mem 0xfec10000-0xfecfffff]
[    0.389145] pci_root PNP0A03:00: host bridge window [mem 0xfed1c000-0xfed1ffff]
[    0.389148] pci_root PNP0A03:00: host bridge window [mem 0xfed90000-0xfed9ffff]
[    0.389151] pci_root PNP0A03:00: host bridge window [mem 0xfed40000-0xfed44fff]
[    0.389154] pci_root PNP0A03:00: host bridge window [mem 0xfeda7000-0xfedfffff]
[    0.389156] pci_root PNP0A03:00: host bridge window [mem 0xfee10000-0xff9fffff]
[    0.389159] pci_root PNP0A03:00: host bridge window [mem 0xffc00000-0xffdfffff]
[    0.389294] pci 0000:00:02.0: reg 10: [mem 0xf6e00000-0xf6efffff 64bit]
[    0.389304] pci 0000:00:02.0: reg 18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.389310] pci 0000:00:02.0: reg 20: [io  0xeff8-0xefff]
[    0.389368] pci 0000:00:02.1: reg 10: [mem 0xf6f00000-0xf6ffffff 64bit]
[    0.389520] pci 0000:00:1a.0: reg 20: [io  0x6f20-0x6f3f]
[    0.389601] pci 0000:00:1a.1: reg 20: [io  0x6f00-0x6f1f]
[    0.389683] pci 0000:00:1a.7: reg 10: [mem 0xfed1c400-0xfed1c7ff]
[    0.389765] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.389772] pci 0000:00:1a.7: PME# disabled
[    0.389828] pci 0000:00:1b.0: reg 10: [mem 0xf6dfc000-0xf6dfffff 64bit]
[    0.389908] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.389914] pci 0000:00:1b.0: PME# disabled
[    0.390039] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.390045] pci 0000:00:1c.0: PME# disabled
[    0.390173] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.390179] pci 0000:00:1c.1: PME# disabled
[    0.390309] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.390315] pci 0000:00:1c.3: PME# disabled
[    0.390446] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.390451] pci 0000:00:1c.5: PME# disabled
[    0.390528] pci 0000:00:1d.0: reg 20: [io  0x6f80-0x6f9f]
[    0.390611] pci 0000:00:1d.1: reg 20: [io  0x6f60-0x6f7f]
[    0.390693] pci 0000:00:1d.2: reg 20: [io  0x6f40-0x6f5f]
[    0.390772] pci 0000:00:1d.7: reg 10: [mem 0xfed1c000-0xfed1c3ff]
[    0.390854] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.390861] pci 0000:00:1d.7: PME# disabled
[    0.391068] pci 0000:00:1f.0: quirk: [io  0x1000-0x107f] claimed by ICH6 ACPI/GPIO/TCO
[    0.391074] pci 0000:00:1f.0: quirk: [io  0x1080-0x10bf] claimed by ICH6 GPIO
[    0.391079] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0900 (mask 007f)
[    0.391086] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 0c80 (mask 003f)
[    0.391151] pci 0000:00:1f.1: reg 10: [io  0x01f0-0x01f7]
[    0.391161] pci 0000:00:1f.1: reg 14: [io  0x03f4-0x03f7]
[    0.391171] pci 0000:00:1f.1: reg 18: [io  0x0170-0x0177]
[    0.391180] pci 0000:00:1f.1: reg 1c: [io  0x0374-0x0377]
[    0.391190] pci 0000:00:1f.1: reg 20: [io  0x6fa0-0x6faf]
[    0.391270] pci 0000:00:1f.2: reg 10: [io  0x6eb0-0x6eb7]
[    0.391280] pci 0000:00:1f.2: reg 14: [io  0x6eb8-0x6ebb]
[    0.391289] pci 0000:00:1f.2: reg 18: [io  0x6ec0-0x6ec7]
[    0.391298] pci 0000:00:1f.2: reg 1c: [io  0x6ec8-0x6ecb]
[    0.391308] pci 0000:00:1f.2: reg 20: [io  0x6ee0-0x6eff]
[    0.391317] pci 0000:00:1f.2: reg 24: [mem 0xf6dfb800-0xf6dfbfff]
[    0.391373] pci 0000:00:1f.2: PME# supported from D3hot
[    0.391379] pci 0000:00:1f.2: PME# disabled
[    0.391419] pci 0000:00:1f.3: reg 10: [mem 0xf6dfb700-0xf6dfb7ff]
[    0.391450] pci 0000:00:1f.3: reg 20: [io  0x10c0-0x10df]
[    0.391566] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.391572] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.391578] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.391588] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.391722] pci 0000:0c:00.0: reg 10: [mem 0xf6cf0000-0xf6cfffff 64bit]
[    0.391833] pci 0000:0c:00.0: supports D1
[    0.391835] pci 0000:0c:00.0: PME# supported from D0 D1 D3hot
[    0.391842] pci 0000:0c:00.0: PME# disabled
[    0.391874] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.391880] pci 0000:00:1c.1:   bridge window [io  0xf000-0x0000] (disabled)
[    0.391886] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.391896] pci 0000:00:1c.1:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.391976] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.391982] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.391988] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.392007] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.392152] pci 0000:09:00.0: reg 10: [mem 0xf69f0000-0xf69fffff 64bit]
[    0.392282] pci 0000:09:00.0: PME# supported from D3hot D3cold
[    0.392289] pci 0000:09:00.0: PME# disabled
[    0.392313] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.392319] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.392325] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.392335] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.392420] pci 0000:03:01.0: reg 10: [mem 0x00000000-0x00000fff]
[    0.392455] pci 0000:03:01.0: supports D1 D2
[    0.392457] pci 0000:03:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.392464] pci 0000:03:01.0: PME# disabled
[    0.392516] pci 0000:03:01.4: reg 10: [mem 0xf68ff000-0xf68fffff]
[    0.392526] pci 0000:03:01.4: reg 14: [mem 0xf68fe800-0xf68fefff]
[    0.392593] pci 0000:03:01.4: supports D1 D2
[    0.392595] pci 0000:03:01.4: PME# supported from D0 D1 D2 D3hot D3cold
[    0.392601] pci 0000:03:01.4: PME# disabled
[    0.392690] pci 0000:00:1e.0: PCI bridge to [bus 03-04] (subtractive decode)
[    0.392696] pci 0000:00:1e.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.392702] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.392712] pci 0000:00:1e.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.392715] pci 0000:00:1e.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.392717] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.392720] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.392723] pci 0000:00:1e.0:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.392726] pci 0000:00:1e.0:   bridge window [mem 0xe0000000-0xf7ffffff] (subtractive decode)
[    0.392728] pci 0000:00:1e.0:   bridge window [mem 0xfc000000-0xfebfffff] (subtractive decode)
[    0.392731] pci 0000:00:1e.0:   bridge window [mem 0xfec10000-0xfecfffff] (subtractive decode)
[    0.392733] pci 0000:00:1e.0:   bridge window [mem 0xfed1c000-0xfed1ffff] (subtractive decode)
[    0.392736] pci 0000:00:1e.0:   bridge window [mem 0xfed90000-0xfed9ffff] (subtractive decode)
[    0.392739] pci 0000:00:1e.0:   bridge window [mem 0xfed40000-0xfed44fff] (subtractive decode)
[    0.392742] pci 0000:00:1e.0:   bridge window [mem 0xfeda7000-0xfedfffff] (subtractive decode)
[    0.392744] pci 0000:00:1e.0:   bridge window [mem 0xfee10000-0xff9fffff] (subtractive decode)
[    0.392747] pci 0000:00:1e.0:   bridge window [mem 0xffc00000-0xffdfffff] (subtractive decode)
[    0.392813] pci_bus 0000:04: [bus 04-07] partially hidden behind transparent bridge 0000:03 [bus 03-04]
[    0.392860] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.393371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIE._PRT]
[    0.393654] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.393764] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.393884] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
[    0.394013] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.426192] ACPI: PCI Interrupt Link [LNKA] (IRQs 9 10 *11)
[    0.426192] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 7) *3
[    0.426192] ACPI: PCI Interrupt Link [LNKC] (IRQs 9 *10 11)
[    0.426192] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 7 9 10 *11)
[    0.426192] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
[    0.426192] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
[    0.426192] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
[    0.426192] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
[    0.428257] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.428293] vgaarb: loaded
[    0.428328] SCSI subsystem initialized
[    0.428328] libata version 3.00 loaded.
[    0.428328] usbcore: registered new interface driver usbfs
[    0.428328] usbcore: registered new interface driver hub
[    0.428328] usbcore: registered new device driver usb
[    0.428328] ACPI: WMI: Mapper loaded
[    0.428328] PCI: Using ACPI for IRQ routing
[    0.428328] PCI: pci_cache_line_size set to 64 bytes
[    0.428328] reserve RAM buffer: 000000000009f000 - 000000000009ffff 
[    0.428328] reserve RAM buffer: 00000000df65a800 - 00000000dfffffff 
[    0.428328] Bluetooth: Core ver 2.15
[    0.428328] NET: Registered protocol family 31
[    0.428328] Bluetooth: HCI device and connection manager initialized
[    0.428328] Bluetooth: HCI socket layer initialized
[    0.428328] NetLabel: Initializing
[    0.428328] NetLabel:  domain hash size = 128
[    0.428328] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.428328] NetLabel:  unlabeled traffic allowed by default
[    0.428328] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.428328] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.428328] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.440055] Switching to clocksource tsc
[    0.467119] pnp: PnP ACPI init
[    0.467158] ACPI: bus type pnp registered
[    0.517404] pnp 00:0b: disabling [io  0x1000-0x1005] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.517408] pnp 00:0b: disabling [io  0x1008-0x100f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.517649] pnp 00:0c: disabling [io  0x1006-0x1007] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.517652] pnp 00:0c: disabling [io  0x100a-0x1059] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.517656] pnp 00:0c: disabling [io  0x1060-0x107f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.517659] pnp 00:0c: disabling [io  0x1010-0x102f] because it overlaps 0000:00:1f.0 BAR 7 [io  0x1000-0x107f]
[    0.541664] pnp: PnP ACPI: found 14 devices
[    0.541667] ACPI: ACPI bus type pnp unregistered
[    0.541685] system 00:05: [io  0x0c80-0x0caf] has been reserved
[    0.541689] system 00:05: [io  0x0cc0-0x0cff] could not be reserved
[    0.541702] system 00:08: [mem 0xfed00000-0xfed003ff] has been reserved
[    0.541712] system 00:0a: [io  0x0cb0-0x0cbb] has been reserved
[    0.541716] system 00:0a: [mem 0xfed40000-0xfed44fff] has been reserved
[    0.541725] system 00:0b: [io  0x0900-0x097f] has been reserved
[    0.541731] system 00:0b: [io  0x04d0-0x04d1] has been reserved
[    0.541741] system 00:0c: [io  0xf400-0xf4fe] has been reserved
[    0.541744] system 00:0c: [io  0x1080-0x10bf] has been reserved
[    0.541747] system 00:0c: [io  0x10c0-0x10df] has been reserved
[    0.541750] system 00:0c: [io  0x0809] has been reserved
[    0.541760] system 00:0d: [mem 0x00000000-0x0009efff] could not be reserved
[    0.541763] system 00:0d: [mem 0x0009f000-0x0009ffff] could not be reserved
[    0.541766] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
[    0.541769] system 00:0d: [mem 0x000e0000-0x000fffff] has been reserved
[    0.541773] system 00:0d: [mem 0x00100000-0xdf65a7ff] could not be reserved
[    0.541776] system 00:0d: [mem 0xdf65a800-0xdf6fffff] has been reserved
[    0.541779] system 00:0d: [mem 0xdf700000-0xdf7fffff] has been reserved
[    0.541782] system 00:0d: [mem 0xdf700000-0xdfefffff] could not be reserved
[    0.541785] system 00:0d: [mem 0xffe00000-0xffffffff] has been reserved
[    0.541788] system 00:0d: [mem 0xffa00000-0xffbfffff] has been reserved
[    0.541792] system 00:0d: [mem 0xfec00000-0xfec0ffff] could not be reserved
[    0.541795] system 00:0d: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.541798] system 00:0d: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.541801] system 00:0d: [mem 0xfed45000-0xfed8ffff] has been reserved
[    0.541804] system 00:0d: [mem 0xfeda0000-0xfeda3fff] has been reserved
[    0.541807] system 00:0d: [mem 0xfeda4000-0xfeda4fff] has been reserved
[    0.541810] system 00:0d: [mem 0xfeda5000-0xfeda5fff] has been reserved
[    0.541813] system 00:0d: [mem 0xfeda6000-0xfeda6fff] has been reserved
[    0.541816] system 00:0d: [mem 0xfed18000-0xfed1bfff] has been reserved
[    0.541819] system 00:0d: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.547143] PCI: max bus depth: 2 pci_try_num: 3
[    0.547223] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547227] pci 0000:00:1c.0: BAR 8: assigned [mem 0xf0200000-0xf03fffff]
[    0.547232] pci 0000:00:1c.0: BAR 9: assigned [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.547236] pci 0000:00:1c.1: BAR 9: assigned [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.547240] pci 0000:00:1c.5: BAR 9: assigned [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.547243] pci 0000:00:1c.0: BAR 7: assigned [io  0x2000-0x2fff]
[    0.547247] pci 0000:00:1c.1: BAR 7: assigned [io  0x3000-0x3fff]
[    0.547250] pci 0000:00:1c.5: BAR 7: assigned [io  0x4000-0x4fff]
[    0.547253] pci 0000:00:1e.0: BAR 7: assigned [io  0x5000-0x5fff]
[    0.547255] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.547260] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.547268] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.547274] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.547285] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.547289] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.547297] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.547303] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.547313] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.547317] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.547325] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.547331] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.547340] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.547344] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.547352] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.547358] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.547377] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547387] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    0.547390] pci 0000:03:01.0: BAR 0: assigned [mem 0xf6800000-0xf6800fff]
[    0.547398] pci 0000:03:01.0: BAR 0: set to [mem 0xf6800000-0xf6800fff] (PCI address [0xf6800000-0xf6800fff]
[    0.547401] pci 0000:03:01.0: BAR 7: assigned [io  0x5000-0x50ff]
[    0.547403] pci 0000:03:01.0: BAR 8: assigned [io  0x5400-0x54ff]
[    0.547406] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    0.547408] pci 0000:03:01.0:   bridge window [io  0x5000-0x50ff]
[    0.547414] pci 0000:03:01.0:   bridge window [io  0x5400-0x54ff]
[    0.547421] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.547425] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.547432] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.547438] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.547448] PCI: No. 2 try to assign unassigned res
[    0.547516] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547519] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.547523] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.547530] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.547537] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.547547] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.547550] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.547558] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.547564] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.547574] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.547578] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.547586] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.547592] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.547602] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.547606] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.547614] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.547620] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.547638] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547648] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    0.547650] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    0.547652] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.547659] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.547665] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.547669] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.547677] pci 0000:00:1e.0:   bridge window [mem 0xf6800000-0xf68fffff]
[    0.547683] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.547692] PCI: No. 3 try to assign unassigned res
[    0.547695] release child resource [mem 0xf6800000-0xf6800fff]
[    0.547697] release child resource [mem 0xf68fe800-0xf68fefff]
[    0.547699] release child resource [mem 0xf68ff000-0xf68fffff]
[    0.547702] pci 0000:00:1e.0: resource 8 [mem 0xf6800000-0xf68fffff] released
[    0.547704] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.547706] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.547788] pci 0000:00:1e.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547794] pci 0000:00:1e.0: BAR 8: can't assign mem (size 0x6000000)
[    0.547797] pci 0000:00:1c.0: PCI bridge to [bus 0b-0b]
[    0.547801] pci 0000:00:1c.0:   bridge window [io  0x2000-0x2fff]
[    0.547809] pci 0000:00:1c.0:   bridge window [mem 0xf0200000-0xf03fffff]
[    0.547815] pci 0000:00:1c.0:   bridge window [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.547825] pci 0000:00:1c.1: PCI bridge to [bus 0c-0c]
[    0.547829] pci 0000:00:1c.1:   bridge window [io  0x3000-0x3fff]
[    0.547837] pci 0000:00:1c.1:   bridge window [mem 0xf6c00000-0xf6cfffff]
[    0.547843] pci 0000:00:1c.1:   bridge window [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.547853] pci 0000:00:1c.3: PCI bridge to [bus 0d-0e]
[    0.547857] pci 0000:00:1c.3:   bridge window [io  0xd000-0xdfff]
[    0.547865] pci 0000:00:1c.3:   bridge window [mem 0xf6a00000-0xf6bfffff]
[    0.547871] pci 0000:00:1c.3:   bridge window [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.547881] pci 0000:00:1c.5: PCI bridge to [bus 09-09]
[    0.547885] pci 0000:00:1c.5:   bridge window [io  0x4000-0x4fff]
[    0.547892] pci 0000:00:1c.5:   bridge window [mem 0xf6900000-0xf69fffff]
[    0.547899] pci 0000:00:1c.5:   bridge window [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.547917] pci 0000:03:01.0: BAR 9: can't assign mem pref (size 0x4000000)
[    0.547926] pci 0000:03:01.0: BAR 10: can't assign mem (size 0x4000000)
[    0.547929] pci 0000:03:01.0: BAR 0: assigned [mem 0x000a0000-0x000a0fff]
[    0.547936] pci 0000:03:01.0: BAR 0: set to [mem 0x000a0000-0x000a0fff] (PCI address [0xa0000-0xa0fff]
[    0.547940] pci 0000:03:01.4: BAR 0: assigned [mem 0x000a1000-0x000a1fff]
[    0.547946] pci 0000:03:01.4: BAR 0: set to [mem 0x000a1000-0x000a1fff] (PCI address [0xa1000-0xa1fff]
[    0.547949] pci 0000:03:01.4: BAR 1: assigned [mem 0x000a2000-0x000a27ff]
[    0.547955] pci 0000:03:01.4: BAR 1: set to [mem 0x000a2000-0x000a27ff] (PCI address [0xa2000-0xa27ff]
[    0.547958] pci 0000:03:01.0: CardBus bridge to [bus 04-07]
[    0.547960] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.547967] pci 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[    0.547973] pci 0000:00:1e.0: PCI bridge to [bus 03-04]
[    0.547977] pci 0000:00:1e.0:   bridge window [io  0x5000-0x5fff]
[    0.547985] pci 0000:00:1e.0:   bridge window [mem disabled]
[    0.547990] pci 0000:00:1e.0:   bridge window [mem pref disabled]
[    0.548021]   alloc irq_desc for 16 on node -1
[    0.548023]   alloc kstat_irqs on node -1
[    0.548030] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.548038] pci 0000:00:1c.0: setting latency timer to 64
[    0.548051]   alloc irq_desc for 17 on node -1
[    0.548053]   alloc kstat_irqs on node -1
[    0.548058] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.548064] pci 0000:00:1c.1: setting latency timer to 64
[    0.548077]   alloc irq_desc for 19 on node -1
[    0.548079]   alloc kstat_irqs on node -1
[    0.548083] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.548089] pci 0000:00:1c.3: setting latency timer to 64
[    0.548102] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.548108] pci 0000:00:1c.5: setting latency timer to 64
[    0.548118] pci 0000:00:1e.0: setting latency timer to 64
[    0.548133] pci 0000:03:01.0: enabling device (0000 -> 0003)
[    0.548138] pci 0000:03:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.548148] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.548151] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.548153] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.548155] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.548158] pci_bus 0000:00: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.548160] pci_bus 0000:00: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.548162] pci_bus 0000:00: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.548165] pci_bus 0000:00: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.548167] pci_bus 0000:00: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.548169] pci_bus 0000:00: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.548172] pci_bus 0000:00: resource 14 [mem 0xfeda7000-0xfedfffff]
[    0.548174] pci_bus 0000:00: resource 15 [mem 0xfee10000-0xff9fffff]
[    0.548176] pci_bus 0000:00: resource 16 [mem 0xffc00000-0xffdfffff]
[    0.548179] pci_bus 0000:0b: resource 0 [io  0x2000-0x2fff]
[    0.548181] pci_bus 0000:0b: resource 1 [mem 0xf0200000-0xf03fffff]
[    0.548184] pci_bus 0000:0b: resource 2 [mem 0xf0400000-0xf05fffff 64bit pref]
[    0.548186] pci_bus 0000:0c: resource 0 [io  0x3000-0x3fff]
[    0.548188] pci_bus 0000:0c: resource 1 [mem 0xf6c00000-0xf6cfffff]
[    0.548191] pci_bus 0000:0c: resource 2 [mem 0xf0600000-0xf07fffff 64bit pref]
[    0.548193] pci_bus 0000:0d: resource 0 [io  0xd000-0xdfff]
[    0.548195] pci_bus 0000:0d: resource 1 [mem 0xf6a00000-0xf6bfffff]
[    0.548198] pci_bus 0000:0d: resource 2 [mem 0xf0000000-0xf01fffff 64bit pref]
[    0.548200] pci_bus 0000:09: resource 0 [io  0x4000-0x4fff]
[    0.548203] pci_bus 0000:09: resource 1 [mem 0xf6900000-0xf69fffff]
[    0.548205] pci_bus 0000:09: resource 2 [mem 0xf0800000-0xf09fffff 64bit pref]
[    0.548207] pci_bus 0000:03: resource 0 [io  0x5000-0x5fff]
[    0.548210] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.548212] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.548214] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.548216] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.548219] pci_bus 0000:03: resource 8 [mem 0xe0000000-0xf7ffffff]
[    0.548221] pci_bus 0000:03: resource 9 [mem 0xfc000000-0xfebfffff]
[    0.548223] pci_bus 0000:03: resource 10 [mem 0xfec10000-0xfecfffff]
[    0.548226] pci_bus 0000:03: resource 11 [mem 0xfed1c000-0xfed1ffff]
[    0.548228] pci_bus 0000:03: resource 12 [mem 0xfed90000-0xfed9ffff]
[    0.548230] pci_bus 0000:03: resource 13 [mem 0xfed40000-0xfed44fff]
[    0.548232] pci_bus 0000:03: resource 14 [mem 0xfeda7000-0xfedfffff]
[    0.548235] pci_bus 0000:03: resource 15 [mem 0xfee10000-0xff9fffff]
[    0.548237] pci_bus 0000:03: resource 16 [mem 0xffc00000-0xffdfffff]
[    0.548239] pci_bus 0000:04: resource 0 [io  0x0000-0x00ff]
[    0.548242] pci_bus 0000:04: resource 1 [io  0x0000-0x00ff]
[    0.548305] NET: Registered protocol family 2
[    0.548581] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.550434] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.555177] TCP bind hash table entries: 65536 (order: 9, 3670016 bytes)
[    0.560383] TCP: Hash tables configured (established 524288 bind 65536)
[    0.560440] TCP reno registered
[    0.560489] UDP hash table entries: 2048 (order: 6, 262144 bytes)
[    0.560850] UDP-Lite hash table entries: 2048 (order: 6, 262144 bytes)
[    0.561363] NET: Registered protocol family 1
[    0.561397] pci 0000:00:02.0: Boot video device
[    0.561653] PCI: CLS 64 bytes, default 64
[    0.561797] Trying to unpack rootfs image as initramfs...
[    1.342803] Freeing initrd memory: 33736k freed
[    1.362165] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.362172] Placing 64MB software IO TLB between ffff8800028dc000 - ffff8800068dc000
[    1.362175] software IO TLB at phys 0x28dc000 - 0x68dc000
[    1.363681] Scanning for low memory corruption every 60 seconds
[    1.364202] audit: initializing netlink socket (disabled)
[    1.364246] type=2000 audit(1270576306.364:1): initialized
[    1.378454] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.383697] VFS: Disk quotas dquot_6.5.2
[    1.383856] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.385865] fuse init (API version 7.13)
[    1.386819] Btrfs loaded
[    1.386828] msgmni has been set to 7884
[    1.387428] alg: No test for stdrng (krng)
[    1.387457] io scheduler noop registered
[    1.387459] io scheduler deadline registered
[    1.387656] io scheduler cfq registered (default)
[    1.387899] pcieport 0000:00:1c.0: setting latency timer to 64
[    1.387974]   alloc irq_desc for 24 on node -1
[    1.387976]   alloc kstat_irqs on node -1
[    1.387992] pcieport 0000:00:1c.0: irq 24 for MSI/MSI-X
[    1.388297] pcieport 0000:00:1c.1: setting latency timer to 64
[    1.388356]   alloc irq_desc for 25 on node -1
[    1.388358]   alloc kstat_irqs on node -1
[    1.388370] pcieport 0000:00:1c.1: irq 25 for MSI/MSI-X
[    1.388650] pcieport 0000:00:1c.3: setting latency timer to 64
[    1.388709]   alloc irq_desc for 26 on node -1
[    1.388711]   alloc kstat_irqs on node -1
[    1.388723] pcieport 0000:00:1c.3: irq 26 for MSI/MSI-X
[    1.389010] pcieport 0000:00:1c.5: setting latency timer to 64
[    1.389068]   alloc irq_desc for 27 on node -1
[    1.389070]   alloc kstat_irqs on node -1
[    1.389082] pcieport 0000:00:1c.5: irq 27 for MSI/MSI-X
[    1.389487] pcieport 0000:00:1c.0: Requesting control of PCIe PME from ACPI BIOS
[    1.389500] pcieport 0000:00:1c.0: Failed to receive control of PCIe PME service: no _OSC support
[    1.389515] pcie_pme: probe of 0000:00:1c.0:pcie01 failed with error -13
[    1.389524] pcieport 0000:00:1c.1: Requesting control of PCIe PME from ACPI BIOS
[    1.389528] pcieport 0000:00:1c.1: Failed to receive control of PCIe PME service: no _OSC support
[    1.389533] pcie_pme: probe of 0000:00:1c.1:pcie01 failed with error -13
[    1.389541] pcieport 0000:00:1c.3: Requesting control of PCIe PME from ACPI BIOS
[    1.389545] pcieport 0000:00:1c.3: Failed to receive control of PCIe PME service: no _OSC support
[    1.389550] pcie_pme: probe of 0000:00:1c.3:pcie01 failed with error -13
[    1.389558] pcieport 0000:00:1c.5: Requesting control of PCIe PME from ACPI BIOS
[    1.389562] pcieport 0000:00:1c.5: Failed to receive control of PCIe PME service: no _OSC support
[    1.389567] pcie_pme: probe of 0000:00:1c.5:pcie01 failed with error -13
[    1.389699] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.389988] pciehp 0000:00:1c.0:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.0
[    1.390065] pciehp 0000:00:1c.0:pcie04: HPC vendor_id 8086 device_id 283f ss_vid 1028 ss_did 1fe
[    1.390371] pciehp 0000:00:1c.0:pcie04: service driver pciehp loaded
[    1.390381] pciehp 0000:00:1c.1:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.1
[    1.390396] pciehp 0000:00:1c.1:pcie04: HPC vendor_id 8086 device_id 2841 ss_vid 1028 ss_did 1fe
[    1.492016] pciehp 0000:00:1c.1:pcie04: Device 0000:0c:00.0 already exists at 0000:0c:00, cannot hot-add
[    1.492026] pciehp 0000:00:1c.1:pcie04: Cannot add device at 0000:0c:00
[    1.492034] pciehp 0000:00:1c.1:pcie04: service driver pciehp loaded
[    1.492045] pciehp 0000:00:1c.3:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.3
[    1.492061] pciehp 0000:00:1c.3:pcie04: HPC vendor_id 8086 device_id 2845 ss_vid 1028 ss_did 1fe
[    1.492166] pciehp 0000:00:1c.3:pcie04: service driver pciehp loaded
[    1.492176] pciehp 0000:00:1c.5:pcie04: Bypassing BIOS check for pciehp use on 0000:00:1c.5
[    1.492191] pciehp 0000:00:1c.5:pcie04: HPC vendor_id 8086 device_id 2849 ss_vid 1028 ss_did 1fe
[    1.596015] pciehp 0000:00:1c.5:pcie04: Device 0000:09:00.0 already exists at 0000:09:00, cannot hot-add
[    1.596023] pciehp 0000:00:1c.5:pcie04: Cannot add device at 0000:09:00
[    1.596031] pciehp 0000:00:1c.5:pcie04: service driver pciehp loaded
[    1.596089] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.596657] ACPI: AC Adapter [AC] (on-line)
[    1.597043] input: Lid Switch as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input0
[    1.597581] ACPI: Lid Switch [LID]
[    1.597702] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input1
[    1.597707] ACPI: Power Button [PBTN]
[    1.597822] input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    1.597826] ACPI: Sleep Button [SBTN]
[    1.598713] Monitor-Mwait will be used to enter C-1 state
[    1.598763] Monitor-Mwait will be used to enter C-2 state
[    1.598804] Monitor-Mwait will be used to enter C-3 state
[    1.598814] Marking TSC unstable due to TSC halts in idle
[    1.598980] Switching to clocksource hpet
[    1.635812] thermal LNXTHERM:01: registered as thermal_zone0
[    1.635828] ACPI: Thermal Zone [THM] (90 C)
[    1.669242] ACPI: Battery Slot [BAT0] (battery present)
[    1.669313] ACPI: Battery Slot [BAT1] (battery absent)
[    1.670105] Linux agpgart interface v0.103
[    1.670275] ipmi message handler version 39.2
[    1.670299] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.670594] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.671927] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.675900] brd: module loaded
[    1.677816] loop: module loaded
[    1.678357] ahci 0000:00:1f.2: version 3.0
[    1.678379]   alloc irq_desc for 18 on node -1
[    1.678381]   alloc kstat_irqs on node -1
[    1.678390] ahci 0000:00:1f.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    1.678451]   alloc irq_desc for 28 on node -1
[    1.678454]   alloc kstat_irqs on node -1
[    1.678467] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    1.678557] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x5 impl SATA mode
[    1.678561] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ccc ems 
[    1.678568] ahci 0000:00:1f.2: setting latency timer to 64
[    1.684267] scsi0 : ahci
[    1.684647] scsi1 : ahci
[    1.684850] scsi2 : ahci
[    1.685347] ata1: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfb900 irq 28
[    1.685350] ata2: DUMMY
[    1.685353] ata3: SATA max UDMA/133 abar m2048@0xf6dfb800 port 0xf6dfba00 irq 28
[    1.685523] ata_piix 0000:00:1f.1: version 2.13
[    1.685534] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.685585] ata_piix 0000:00:1f.1: setting latency timer to 64
[    1.685690] scsi3 : ata_piix
[    1.685899] scsi4 : ata_piix
[    1.688783] ata4: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x6fa0 irq 14
[    1.688786] ata5: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x6fa8 irq 15
[    1.688976] ata5: port disabled. ignoring.
[    1.689257] Fixed MDIO Bus: probed
[    1.689263] PPP generic driver version 2.4.2
[    1.689697] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.689729]   alloc irq_desc for 22 on node -1
[    1.689731]   alloc kstat_irqs on node -1
[    1.689737] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.689757] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    1.689762] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    1.690203] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    1.690269] ehci_hcd 0000:00:1a.7: debug port 1
[    1.694163] ehci_hcd 0000:00:1a.7: cache line size of 64 is not supported
[    1.694189] ehci_hcd 0000:00:1a.7: irq 22, io mem 0xfed1c400
[    1.709029] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    1.709771] hub 1-0:1.0: USB hub found
[    1.709780] hub 1-0:1.0: 4 ports detected
[    1.710106]   alloc irq_desc for 20 on node -1
[    1.710109]   alloc kstat_irqs on node -1
[    1.710115] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.710135] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    1.710140] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    1.710251] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    1.710289] ehci_hcd 0000:00:1d.7: debug port 1
[    1.714183] ehci_hcd 0000:00:1d.7: cache line size of 64 is not supported
[    1.714204] ehci_hcd 0000:00:1d.7: irq 20, io mem 0xfed1c000
[    1.729018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    1.729295] hub 2-0:1.0: USB hub found
[    1.729304] hub 2-0:1.0: 6 ports detected
[    1.729513] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.729590] uhci_hcd: USB Universal Host Controller Interface driver
[    1.729725] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.729734] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    1.729738] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    1.729884] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    1.729917] uhci_hcd 0000:00:1a.0: irq 20, io base 0x00006f20
[    1.730198] hub 3-0:1.0: USB hub found
[    1.730240] hub 3-0:1.0: 2 ports detected
[    1.730400]   alloc irq_desc for 21 on node -1
[    1.730402]   alloc kstat_irqs on node -1
[    1.730408] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.730417] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    1.730421] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    1.730526] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    1.730570] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00006f00
[    1.730864] hub 4-0:1.0: USB hub found
[    1.730872] hub 4-0:1.0: 2 ports detected
[    1.731024] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    1.731033] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    1.731037] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    1.731142] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[    1.731179] uhci_hcd 0000:00:1d.0: irq 20, io base 0x00006f80
[    1.731510] hub 5-0:1.0: USB hub found
[    1.731518] hub 5-0:1.0: 2 ports detected
[    1.731675] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    1.731684] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    1.731688] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    1.731793] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[    1.731826] uhci_hcd 0000:00:1d.1: irq 21, io base 0x00006f60
[    1.732105] hub 6-0:1.0: USB hub found
[    1.732113] hub 6-0:1.0: 2 ports detected
[    1.732247] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
[    1.732255] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    1.732259] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    1.732366] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[    1.732397] uhci_hcd 0000:00:1d.2: irq 22, io base 0x00006f40
[    1.732677] hub 7-0:1.0: USB hub found
[    1.732684] hub 7-0:1.0: 2 ports detected
[    1.733023] usbcore: registered new interface driver usbserial
[    1.733088] USB Serial support registered for generic
[    1.733167] usbcore: registered new interface driver usbserial_generic
[    1.733170] usbserial: USB Serial Driver core
[    1.733334] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    1.737146] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.737177] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.737658] mice: PS/2 mouse device common for all mice
[    1.738169] rtc_cmos 00:03: RTC can wake from S4
[    1.738446] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.738484] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    1.738849] device-mapper: uevent: version 1.0.3
[    1.739102] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
[    1.739206] device-mapper: multipath: version 1.1.1 loaded
[    1.739222] device-mapper: multipath round-robin: version 1.0.0 loaded
[    1.740164] cpuidle: using governor ladder
[    1.741481] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
[    1.741571] cpuidle: using governor menu
[    1.742686] TCP cubic registered
[    1.743449] NET: Registered protocol family 10
[    1.744517] lo: Disabled Privacy Extensions
[    1.745202] NET: Registered protocol family 17
[    1.745392] Bluetooth: L2CAP ver 2.14
[    1.745395] Bluetooth: L2CAP socket layer initialized
[    1.745403] Bluetooth: SCO (Voice Link) ver 0.6
[    1.745405] Bluetooth: SCO socket layer initialized
[    1.745491] Bluetooth: RFCOMM TTY layer initialized
[    1.745499] Bluetooth: RFCOMM socket layer initialized
[    1.745500] Bluetooth: RFCOMM ver 1.11
[    1.748372] PM: Resume from disk failed.
[    1.748399] registered taskstats version 1
[    1.748902]   Magic number: 6:579:895
[    1.749053] rtc_cmos 00:03: setting system clock to 2010-04-06 17:51:47 UTC (1270576307)
[    1.749057] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    1.749059] EDD information not available.
[    1.852690] ata4.00: ATAPI: Optiarc DVD+/-RW AD-5560A, DD11, max UDMA/33
[    1.868538] ata4.00: configured for UDMA/33
[    2.004251] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.004287] ata3: SATA link down (SStatus 0 SControl 300)
[    2.006287] ata1.00: ATA-8: ST9500420AS, 0002SDM1, max UDMA/133
[    2.006292] ata1.00: 976773168 sectors, multi 8: LBA48 NCQ (depth 31/32)
[    2.017049] ata1.00: configured for UDMA/133
[    2.032789] scsi 0:0:0:0: Direct-Access     ATA      ST9500420AS      0002 PQ: 0 ANSI: 5
[    2.033727] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.033825] sd 0:0:0:0: [sda] Write Protect is off
[    2.033828] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.033868] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.034238] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.034580]  sda:
[    2.035511] scsi 3:0:0:0: CD-ROM            Optiarc  DVD+-RW AD-5560A DD11 PQ: 0 ANSI: 5
[    2.041853] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.041859] Uniform CD-ROM driver Revision: 3.20
[    2.042513] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    2.042877] sr 3:0:0:0: Attached scsi generic sg1 type 5
[    2.045184]  sda1 sda2 < sda5 sda6 >
[    2.052681] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.052729] Freeing unused kernel memory: 820k freed
[    2.053074] Write protecting the kernel read-only data: 10240k
[    2.053361] Freeing unused kernel memory: 216k freed
[    2.053847] Freeing unused kernel memory: 1692k freed
[    2.307639] tg3.c:v3.108 (February 17, 2010)
[    2.307663] tg3 0000:09:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.307676] tg3 0000:09:00.0: setting latency timer to 64
[    2.313524] ohci1394 0000:03:01.4: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    2.327527] tg3 0000:09:00.0: eth0: Tigon3 [partno(BCM95755m) rev a002] (PCI Express) MAC address 00:22:19:e5:83:a2
[    2.327531] tg3 0000:09:00.0: eth0: attached PHY is 5755 (10/100/1000Base-T Ethernet) (WireSpeed[1])
[    2.327534] tg3 0000:09:00.0: eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] TSOcap[1]
[    2.327537] tg3 0000:09:00.0: eth0: dma_rwctrl[76180000] dma_mask[64-bit]
[    2.370130] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[a1000-a17ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    2.377073] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    2.516854] device fsid aa42dc58a86076ac-da4384233df9d5b0 devid 1 transid 73862 /dev/sda6
[    2.528585] hub 7-1:1.0: USB hub found
[    2.530495] hub 7-1:1.0: 4 ports detected
[    2.813498] usb 7-1.2: new full speed USB device using uhci_hcd and address 3
[    3.645750] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[384fc0001a532da1]
[   12.260607] Adding 4883756k swap on /dev/sda5.  Priority:-1 extents:1 across:4883756k 
[   14.039402] udev: starting version 151
[   15.627666] kjournald starting.  Commit interval 5 seconds
[   15.628154] EXT3-fs (sda1): using internal journal
[   15.628355] EXT3-fs (sda1): mounted filesystem with writeback data mode
[   16.592909] input: Dell WMI hotkeys as /devices/virtual/input/input4
[   16.872656] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   16.961810] yenta_cardbus 0000:03:01.0: CardBus bridge found [1028:01fe]
[   16.961851] yenta_cardbus 0000:03:01.0: CardBus bridge to [bus 04-07]
[   16.961855] yenta_cardbus 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[   16.961862] yenta_cardbus 0000:03:01.0:   bridge window [io  0x0000-0x00ff]
[   16.961869] yenta_cardbus 0000:03:01.0:   bridge window [mem 0xf0c00000-0xf0ffffff]
[   16.961876] yenta_cardbus 0000:03:01.0:   bridge window [mem 0xf1000000-0xf13fffff]
[   16.961888] yenta_cardbus 0000:03:01.0: O2: enabling read prefetch/write burst
[   17.089025] yenta_cardbus 0000:03:01.0: ISA IRQ mask 0x0cb8, PCI irq 19
[   17.089029] yenta_cardbus 0000:03:01.0: Socket status: 30000006
[   17.089033] pci_bus 0000:03: Raising subordinate bus# of parent bus (#03) from #04 to #07
[   17.089110] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [io  0x5000-0x5fff]
[   17.089113] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [io  0x0000-0x0cf7]
[   17.089116] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [io  0x0d00-0xffff]
[   17.089119] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0x000a0000-0x000bffff]
[   17.089122] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0a0000-0x0bffff: excluding 0xa0000-0xa3fff
[   17.089167] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0x000d0000-0x000dffff]
[   17.089169] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0d0000-0x0dffff: clean.
[   17.089186] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xe0000000-0xf7ffffff]
[   17.089189] pcmcia_socket pcmcia_socket0: cs: memory probe 0xe0000000-0xf7ffffff: excluding 0xe0000000-0xf17fffff 0xf6800000-0xf6ffffff
[   17.089262] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfc000000-0xfebfffff]
[   17.089264] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfc000000-0xfebfffff: clean.
[   17.089295] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfec10000-0xfecfffff]
[   17.089297] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfec10000-0xfecfffff: excluding 0xfecfe000-0xfed0bfff
[   17.089335] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfed1c000-0xfed1ffff]
[   17.089337] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfed1c000-0xfed1ffff: excluding 0xfed1c000-0xfed1dfff
[   17.089347] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfed90000-0xfed9ffff]
[   17.089350] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfed90000-0xfed9ffff: clean.
[   17.089368] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfed40000-0xfed44fff]
[   17.089371] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfed40000-0xfed44fff: excluding 0xfed40000-0xfed45fff
[   17.089381] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfeda7000-0xfedfffff]
[   17.089384] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfeda7000-0xfedfffff: excluding 0xfedff000-0xfee02fff
[   17.089436] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xfee10000-0xff9fffff]
[   17.089439] pcmcia_socket pcmcia_socket0: cs: memory probe 0xfee10000-0xff9fffff: excluding 0xff9f0000-0xffaadfff
[   17.089480] yenta_cardbus 0000:03:01.0: pcmcia: parent PCI bridge window: [mem 0xffc00000-0xffdfffff]
[   17.089483] pcmcia_socket pcmcia_socket0: cs: memory probe 0xffc00000-0xffdfffff: clean.
[   17.360692] agpgart-intel 0000:00:00.0: Intel 965GM Chipset
[   17.361871] agpgart-intel 0000:00:00.0: detected 7676K stolen memory
[   17.366846] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xe0000000
[   17.779250] cfg80211: Calling CRDA to update world regulatory domain
[   17.873556] input: DualPoint Stick as /devices/platform/i8042/serio1/input/input5
[   17.894275] input: AlpsPS/2 ALPS DualPoint TouchPad as /devices/platform/i8042/serio1/input/input6
[   18.961637] [drm] Initialized drm 1.1.0 20060810
[   19.462316] cfg80211: World regulatory domain updated:
[   19.462319]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   19.462322]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.462324]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.462327]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   19.462329]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.462331]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   19.876629] pcmcia_socket pcmcia_socket0: cs: memory probe 0x0c0000-0x0fffff: excluding 0xc0000-0xcffff 0xe0000-0xfffff
[   19.876765] pcmcia_socket pcmcia_socket0: cs: memory probe 0xa0000000-0xa0ffffff: excluding 0xa0000000-0xa0ffffff
[   19.876891] pcmcia_socket pcmcia_socket0: cs: memory probe 0x60000000-0x60ffffff: excluding 0x60000000-0x60ffffff
[   20.451256] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   20.451263] i915 0000:00:02.0: setting latency timer to 64
[   20.547013]   alloc irq_desc for 29 on node -1
[   20.547018]   alloc kstat_irqs on node -1
[   20.547030] i915 0000:00:02.0: irq 29 for MSI/MSI-X
[   20.547040] [drm] set up 7M of stolen space
[   20.740418] RPC: Registered udp transport module.
[   20.740421] RPC: Registered tcp transport module.
[   20.740423] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   20.760173] ath9k 0000:0c:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   20.760188] ath9k 0000:0c:00.0: setting latency timer to 64
[   20.891322] ath: EEPROM regdomain: 0x6a
[   20.891324] ath: EEPROM indicates we should expect a direct regpair map
[   20.891329] ath: Country alpha2 being used: 00
[   20.891331] ath: Regpair used: 0x6a
[   21.014684] [drm] initialized overlay support
[   21.483893] phy0: Selected rate control algorithm 'ath9k_rate_control'
[   21.485681] Registered led device: ath9k-phy0::radio
[   21.485758] Registered led device: ath9k-phy0::assoc
[   21.485825] Registered led device: ath9k-phy0::tx
[   21.485889] Registered led device: ath9k-phy0::rx
[   21.485899] phy0: Atheros AR5418 MAC/BB Rev:2 AR5133 RF Rev:81 mem=0xffffc900053a0000, irq=17
[   21.709630] fb0: inteldrmfb frame buffer device
[   21.709633] registered panic notifier
[   21.711223] input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A03:00/LNXVIDEO:01/input/input7
[   21.711348] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
[   21.711449] [Firmware Bug]: Duplicate ACPI video bus devices for the same VGA controller, please try module parameter "video.allow_duplicates=1"if the current driver doesn't work.
[   21.711588] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   21.830292] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[   21.830390]   alloc irq_desc for 30 on node -1
[   21.830393]   alloc kstat_irqs on node -1
[   21.830410] HDA Intel 0000:00:1b.0: irq 30 for MSI/MSI-X
[   21.830461] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   22.136620] input: HDA Digital PCBeep as /devices/pci0000:00/0000:00:1b.0/input/input8
[   22.157684] input: HDA Intel Mic at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input9
[   22.157872] input: HDA Intel HP Out at Ext Left Jack as /devices/pci0000:00/0000:00:1b.0/sound/card0/input10
[   22.168315] Console: switching to colour frame buffer device 240x75
[   26.437139] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   34.712037] CE: hpet increased min_delta_ns to 7500 nsec
[   35.388556] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[   35.399696]   alloc irq_desc for 31 on node -1
[   35.399700]   alloc kstat_irqs on node -1
[   35.399740] tg3 0000:09:00.0: irq 31 for MSI/MSI-X
[   35.435257] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  107.420140] wlan0: deauthenticating from 00:21:63:2f:fe:6f by local choice (reason=3)
[  107.427074] wlan0: authenticate with 00:21:63:2f:fe:6f (try 1)
[  107.429370] wlan0: authenticated
[  107.429578] wlan0: associate with 00:21:63:2f:fe:6f (try 1)
[  107.452122] wlan0: RX AssocResp from 00:21:63:2f:fe:6f (capab=0x411 status=0 aid=1)
[  107.452130] wlan0: associated
[  107.453430] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  117.459916] wlan0: deauthenticating from 00:21:63:2f:fe:6f by local choice (reason=3)
[  117.474685] cfg80211: All devices are disconnected, going to restore regulatory settings
[  117.474759] cfg80211: Restoring regulatory settings
[  117.475109] cfg80211: Calling CRDA to update world regulatory domain
[  117.484465] cfg80211: World regulatory domain updated:
[  117.484473]     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  117.484481]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  117.484489]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  117.484496]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  117.484504]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  117.484511]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  117.662240] ath9k: Two wiphys trying to scan at the same time
[  117.662381] wlan0: deauthenticating from 00:21:63:2f:fe:6f by local choice (reason=3)
[  117.848319] wlan0: authenticate with 00:21:63:2f:fe:6f (try 1)
[  117.850541] wlan0: authenticated
[  117.850694] wlan0: associate with 00:21:63:2f:fe:6f (try 1)
[  117.868146] wlan0: no IPv6 routers present
[  117.884334] wlan0: RX AssocResp from 00:21:63:2f:fe:6f (capab=0x411 status=0 aid=1)
[  117.884345] wlan0: associated
[  118.032119] Intel AES-NI instructions are not detected.
[  121.834732] SysRq : HELP : loglevel(0-9) reBoot Crash show-all-locks(D) terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount force-fb(V) show-blocked-tasks(W) dump-ftrace-buffer(Z) 
[  132.043918] SysRq : Show Locks Held
[  132.043933] 
[  132.043935] Showing all locks held in the system:
[  132.043970] 1 lock held by getty/4259:
[  132.043975]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044006] 1 lock held by getty/4264:
[  132.044010]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044029] 1 lock held by getty/4278:
[  132.044033]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044051] 1 lock held by getty/4279:
[  132.044056]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044074] 1 lock held by getty/4281:
[  132.044078]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044115] 3 locks held by wpa_supplicant/4427:
[  132.044120]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  132.044138]  #1:  (&rdev->devlist_mtx){+.+.+.}, at: [<ffffffffa00ed526>] cfg80211_set_encryption+0x46/0x540 [cfg80211]
[  132.044186]  #2:  (&wdev->mtx){+.+.+.}, at: [<ffffffffa00ed538>] cfg80211_set_encryption+0x58/0x540 [cfg80211]
[  132.044218] 1 lock held by getty/4901:
[  132.044223]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044252] 1 lock held by bash/5088:
[  132.044256]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044278] 1 lock held by clock-applet/5451:
[  132.044283]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  132.044301] 1 lock held by clock-applet/5452:
[  132.044305]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  132.044322] 1 lock held by clock-applet/5453:
[  132.044326]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  132.044344] 1 lock held by clock-applet/5454:
[  132.044348]  #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  132.044368] 1 lock held by bash/5294:
[  132.044373]  #0:  (&tty->atomic_read_lock){+.+.+.}, at: [<ffffffff8138c07e>] n_tty_read+0x4ce/0x980
[  132.044392] 2 locks held by modprobe/5422:
[  132.044396]  #0:  (module_mutex){+.+.+.}, at: [<ffffffff8109f7a2>] sys_init_module+0x222/0x260
[  132.044415]  #1:  (lock){+.+...}, at: [<ffffffff810b49c7>] __stop_machine+0x27/0x140
[  132.044432] 
[  132.044436] =============================================
[  132.044439] 
[  165.964754] SysRq : Show Blocked State
[  165.964762]   task                        PC stack   pid father
[  165.964799] wpa_supplican D 00000000ffff4df2     0  4427      1 0x00000000
[  165.964804]  ffff880112681678 0000000000000046 ffffffff00000000 0000000000015c80
[  165.964809]  ffff880112681fd8 0000000000015c80 ffff880112681fd8 ffff88011254a020
[  165.964814]  0000000000015c80 0000000000015c80 ffff880112681fd8 0000000000015c80
[  165.964819] Call Trace:
[  165.964827]  [<ffffffff815b99ed>] schedule_timeout+0x23d/0x310
[  165.964833]  [<ffffffff8109086b>] ? mark_held_locks+0x6b/0xa0
[  165.964837]  [<ffffffff815bc240>] ? _raw_spin_unlock_irq+0x30/0x40
[  165.964841]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.964845]  [<ffffffff815b95df>] wait_for_common+0xcf/0x170
[  165.964849]  [<ffffffff810525f0>] ? default_wake_function+0x0/0x20
[  165.964853]  [<ffffffff810769f1>] ? __queue_work+0x41/0x50
[  165.964856]  [<ffffffff815b973d>] wait_for_completion+0x1d/0x20
[  165.964860]  [<ffffffff81074f88>] call_usermodehelper_exec+0x158/0x170
[  165.964865]  [<ffffffff81082fe7>] ? prepare_usermodehelper_creds+0xe7/0x130
[  165.964870]  [<ffffffff812dc563>] ? crypto_larval_lookup+0x93/0x180
[  165.964873]  [<ffffffff8107536f>] __request_module+0x16f/0x1f0
[  165.964877]  [<ffffffff812dc0be>] ? crypto_alg_lookup+0x2e/0x60
[  165.964888]  [<ffffffff812dc563>] crypto_larval_lookup+0x93/0x180
[  165.964891]  [<ffffffff8109086b>] ? mark_held_locks+0x6b/0xa0
[  165.964895]  [<ffffffff812dc673>] crypto_alg_mod_lookup+0x23/0x90
[  165.964898]  [<ffffffff812dc751>] crypto_alloc_base+0x41/0xb0
[  165.964902]  [<ffffffff81138024>] ? __kmalloc+0x134/0x1f0
[  165.964915]  [<ffffffffa022e74f>] ieee80211_aes_key_setup_encrypt+0x2f/0x60 [mac80211]
[  165.964926]  [<ffffffffa0237f6d>] ieee80211_key_alloc+0x22d/0x260 [mac80211]
[  165.964934]  [<ffffffffa022f9cb>] ieee80211_add_key+0x8b/0x150 [mac80211]
[  165.964949]  [<ffffffffa00ed865>] cfg80211_set_encryption+0x385/0x540 [cfg80211]
[  165.964953]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.964961]  [<ffffffffa00edb4b>] cfg80211_wext_siwencodeext+0x12b/0x1d0 [cfg80211]
[  165.964966]  [<ffffffff81598f34>] ioctl_standard_iw_point+0x1c4/0x3b0
[  165.964974]  [<ffffffffa00eda20>] ? cfg80211_wext_siwencodeext+0x0/0x1d0 [cfg80211]
[  165.964978]  [<ffffffff814c25b0>] ? dev_load+0x0/0xa0
[  165.964982]  [<ffffffff815991c1>] ioctl_standard_call+0xa1/0xd0
[  165.964985]  [<ffffffff814c02b3>] ? __dev_get_by_name+0xa3/0xc0
[  165.964989]  [<ffffffff81599120>] ? ioctl_standard_call+0x0/0xd0
[  165.964992]  [<ffffffff81598be3>] T.715+0x163/0x170
[  165.964995]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.964998]  [<ffffffff81598c2f>] wext_handle_ioctl+0x3f/0x90
[  165.965001]  [<ffffffff81112e8e>] ? might_fault+0x8e/0xa0
[  165.965004]  [<ffffffff814c4362>] dev_ioctl+0x6f2/0x820
[  165.965007]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965012]  [<ffffffff814ad139>] sock_ioctl+0xe9/0x280
[  165.965017]  [<ffffffff81153aad>] vfs_ioctl+0x3d/0xd0
[  165.965020]  [<ffffffff8115403a>] do_vfs_ioctl+0x8a/0x5b0
[  165.965024]  [<ffffffff810805e3>] ? up_read+0x23/0x40
[  165.965028]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  165.965032]  [<ffffffff811545e1>] sys_ioctl+0x81/0xa0
[  165.965035]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  165.965048] clock-applet  D 00000000ffffffff     0  5451      1 0x00000000
[  165.965053]  ffff8800d6f7fac8 0000000000000046 0000000000000000 0000000000015c80
[  165.965058]  ffff8800d6f7ffd8 0000000000015c80 ffff8800d6f7ffd8 ffff8800dda44040
[  165.965063]  0000000000015c80 0000000000015c80 ffff8800d6f7ffd8 0000000000015c80
[  165.965068] Call Trace:
[  165.965071]  [<ffffffff815ba24a>] __mutex_lock_common+0x19a/0x3d0
[  165.965075]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965079]  [<ffffffff81092817>] ? lock_release_non_nested+0xa7/0x330
[  165.965083]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965086]  [<ffffffff815ba535>] mutex_lock_nested+0x35/0x40
[  165.965089]  [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  165.965093]  [<ffffffff814cdec6>] rtnetlink_rcv+0x16/0x40
[  165.965097]  [<ffffffff814e3a36>] netlink_unicast+0x2a6/0x2f0
[  165.965101]  [<ffffffff814e47fe>] netlink_sendmsg+0x1fe/0x2e0
[  165.965104]  [<ffffffff814ad4b0>] sock_sendmsg+0xe0/0x110
[  165.965107]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965110]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965114]  [<ffffffff814ad665>] sys_sendto+0x125/0x180
[  165.965117]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965121]  [<ffffffff81141957>] ? fd_install+0x67/0x80
[  165.965124]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  165.965128]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.965132]  [<ffffffff815bb8a2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  165.965136]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  165.965138] clock-applet  D 00000000ffffffff     0  5452      1 0x00000000
[  165.965142]  ffff8800c69cfac8 0000000000000046 0000000000000000 0000000000015c80
[  165.965147]  ffff8800c69cffd8 0000000000015c80 ffff8800c69cffd8 ffff8800dda38000
[  165.965152]  0000000000015c80 0000000000015c80 ffff8800c69cffd8 0000000000015c80
[  165.965156] Call Trace:
[  165.965160]  [<ffffffff815ba24a>] __mutex_lock_common+0x19a/0x3d0
[  165.965163]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965167]  [<ffffffff81092817>] ? lock_release_non_nested+0xa7/0x330
[  165.965170]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965173]  [<ffffffff815ba535>] mutex_lock_nested+0x35/0x40
[  165.965177]  [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  165.965180]  [<ffffffff814cdec6>] rtnetlink_rcv+0x16/0x40
[  165.965184]  [<ffffffff814e3a36>] netlink_unicast+0x2a6/0x2f0
[  165.965187]  [<ffffffff814e47fe>] netlink_sendmsg+0x1fe/0x2e0
[  165.965191]  [<ffffffff814ad4b0>] sock_sendmsg+0xe0/0x110
[  165.965194]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965197]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965200]  [<ffffffff814ad665>] sys_sendto+0x125/0x180
[  165.965203]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965207]  [<ffffffff81141957>] ? fd_install+0x67/0x80
[  165.965210]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  165.965214]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.965217]  [<ffffffff815bb8a2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  165.965221]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  165.965223] clock-applet  D 00000000ffffffff     0  5453      1 0x00000000
[  165.965227]  ffff8800c69b5ac8 0000000000000046 0000000000000000 0000000000015c80
[  165.965232]  ffff8800c69b5fd8 0000000000015c80 ffff8800c69b5fd8 ffff8801181f8000
[  165.965237]  0000000000015c80 0000000000015c80 ffff8800c69b5fd8 0000000000015c80
[  165.965241] Call Trace:
[  165.965244]  [<ffffffff815ba24a>] __mutex_lock_common+0x19a/0x3d0
[  165.965248]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965252]  [<ffffffff81092817>] ? lock_release_non_nested+0xa7/0x330
[  165.965255]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965258]  [<ffffffff815ba535>] mutex_lock_nested+0x35/0x40
[  165.965262]  [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  165.965265]  [<ffffffff814cdec6>] rtnetlink_rcv+0x16/0x40
[  165.965268]  [<ffffffff814e3a36>] netlink_unicast+0x2a6/0x2f0
[  165.965272]  [<ffffffff814e47fe>] netlink_sendmsg+0x1fe/0x2e0
[  165.965275]  [<ffffffff814ad4b0>] sock_sendmsg+0xe0/0x110
[  165.965278]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965281]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965285]  [<ffffffff814ad665>] sys_sendto+0x125/0x180
[  165.965288]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965291]  [<ffffffff81141957>] ? fd_install+0x67/0x80
[  165.965295]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  165.965298]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.965302]  [<ffffffff815bb8a2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  165.965305]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  165.965308] clock-applet  D 00000000ffffffff     0  5454      1 0x00000000
[  165.965312]  ffff8800c69b7ac8 0000000000000046 0000000000000000 0000000000015c80
[  165.965317]  ffff8800c69b7fd8 0000000000015c80 ffff8800c69b7fd8 ffff8800cadfc040
[  165.965321]  0000000000015c80 0000000000015c80 ffff8800c69b7fd8 0000000000015c80
[  165.965326] Call Trace:
[  165.965329]  [<ffffffff815ba24a>] __mutex_lock_common+0x19a/0x3d0
[  165.965333]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965336]  [<ffffffff81092817>] ? lock_release_non_nested+0xa7/0x330
[  165.965339]  [<ffffffff814cdea7>] ? rtnl_lock+0x17/0x20
[  165.965343]  [<ffffffff815ba535>] mutex_lock_nested+0x35/0x40
[  165.965346]  [<ffffffff814cdea7>] rtnl_lock+0x17/0x20
[  165.965349]  [<ffffffff814cdec6>] rtnetlink_rcv+0x16/0x40
[  165.965353]  [<ffffffff814e3a36>] netlink_unicast+0x2a6/0x2f0
[  165.965356]  [<ffffffff814e47fe>] netlink_sendmsg+0x1fe/0x2e0
[  165.965360]  [<ffffffff814ad4b0>] sock_sendmsg+0xe0/0x110
[  165.965363]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965366]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965369]  [<ffffffff814ad665>] sys_sendto+0x125/0x180
[  165.965372]  [<ffffffff81112e45>] ? might_fault+0x45/0xa0
[  165.965375]  [<ffffffff81141957>] ? fd_install+0x67/0x80
[  165.965379]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  165.965382]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.965386]  [<ffffffff815bb8a2>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  165.965390]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  165.965394] modprobe      D 00000000ffffffff     0  5422   5421 0x00000000
[  165.965398]  ffff8800caf2dc68 0000000000000046 ffffffff81e60e90 0000000000015c80
[  165.965403]  ffff8800caf2dfd8 0000000000015c80 ffff8800caf2dfd8 ffff8800cadf8000
[  165.965408]  0000000000015c80 0000000000015c80 ffff8800caf2dfd8 0000000000015c80
[  165.965412] Call Trace:
[  165.965416]  [<ffffffff815b99ed>] schedule_timeout+0x23d/0x310
[  165.965419]  [<ffffffff8109086b>] ? mark_held_locks+0x6b/0xa0
[  165.965422]  [<ffffffff815bc240>] ? _raw_spin_unlock_irq+0x30/0x40
[  165.965426]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.965429]  [<ffffffff815b95df>] wait_for_common+0xcf/0x170
[  165.965433]  [<ffffffff810525f0>] ? default_wake_function+0x0/0x20
[  165.965436]  [<ffffffff81090b7d>] ? trace_hardirqs_on_caller+0x14d/0x190
[  165.965440]  [<ffffffff815b973d>] wait_for_completion+0x1d/0x20
[  165.965443]  [<ffffffff8107665d>] flush_cpu_workqueue+0x6d/0xd0
[  165.965446]  [<ffffffff81076820>] ? wq_barrier_func+0x0/0x20
[  165.965450]  [<ffffffff81077123>] flush_workqueue+0x83/0xb0
[  165.965453]  [<ffffffff810770a0>] ? flush_workqueue+0x0/0xb0
[  165.965457]  [<ffffffff810b4ab4>] __stop_machine+0x114/0x140
[  165.965461]  [<ffffffff81099ad0>] ? __unlink_module+0x0/0x40
[  165.965464]  [<ffffffff810b4d1e>] stop_machine+0x3e/0x60
[  165.965468]  [<ffffffff8109c110>] free_module+0x30/0x150
[  165.965471]  [<ffffffff8109f7aa>] sys_init_module+0x22a/0x260
[  165.965475]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  165.965481] Sched Debug Version: v0.09, 2.6.34-rc3-ben #145
[  165.965483] now at 165965.482356 msecs
[  165.965485]   .jiffies                                 : 4294933787
[  165.965488]   .sysctl_sched_latency                    : 10.000000
[  165.965490]   .sysctl_sched_min_granularity            : 2.000000
[  165.965492]   .sysctl_sched_wakeup_granularity         : 2.000000
[  165.965495]   .sysctl_sched_child_runs_first           : 0.000000
[  165.965497]   .sysctl_sched_features                   : 7917179
[  165.965499]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[  165.965502] 
[  165.965502] cpu#0, 2194.349 MHz
[  165.965504]   .nr_running                    : 4
[  165.965506]   .load                          : 1536
[  165.965508]   .nr_switches                   : 180867
[  165.965510]   .nr_load_updates               : 23136
[  165.965512]   .nr_uninterruptible            : 6
[  165.965514]   .next_balance                  : 4294.934750
[  165.965516]   .curr->pid                     : 5486
[  165.965518]   .clock                         : 165964.746955
[  165.965520]   .cpu_load[0]                   : 1024
[  165.965521]   .cpu_load[1]                   : 1120
[  165.965523]   .cpu_load[2]                   : 1213
[  165.965525]   .cpu_load[3]                   : 1188
[  165.965527]   .cpu_load[4]                   : 1125
[  165.965529]   .yld_count                     : 2380
[  165.965530]   .sched_switch                  : 0
[  165.965532]   .sched_count                   : 199939
[  165.965534]   .sched_goidle                  : 64722
[  165.965536]   .avg_idle                      : 922746
[  165.965538]   .ttwu_count                    : 98324
[  165.965540]   .ttwu_local                    : 59861
[  165.965541]   .bkl_count                     : 916
[  165.965545] 
[  165.965545] cfs_rq[0]:/sysdefault
[  165.965547]   .exec_clock                    : 3658.316377
[  165.965566]   .MIN_vruntime                  : 14375.279496
[  165.965568]   .min_vruntime                  : 14380.279496
[  165.965570]   .max_vruntime                  : 14375.279496
[  165.965572]   .spread                        : 0.000000
[  165.965574]   .spread0                       : -15770.404058
[  165.965576]   .nr_running                    : 2
[  165.965578]   .load                          : 2048
[  165.965579]   .nr_spread_over                : 4
[  165.965581]   .shares                        : 0
[  165.965583]   .se->exec_start                : 165956.044852
[  165.965586]   .se->vruntime                  : 30145.683554
[  165.965588]   .se->sum_exec_runtime          : 3658.316377
[  165.965590]   .se->wait_start                : 165964.739211
[  165.965592]   .se->sleep_start               : 0.000000
[  165.965594]   .se->block_start               : 0.000000
[  165.965596]   .se->sleep_max                 : 0.000000
[  165.965598]   .se->block_max                 : 0.000000
[  165.965600]   .se->exec_max                  : 4.040923
[  165.965602]   .se->slice_max                 : 5.273472
[  165.965604]   .se->wait_max                  : 20.587303
[  165.965606]   .se->wait_sum                  : 2482.673077
[  165.965608]   .se->wait_count                : 58205
[  165.965609]   .se->load.weight               : 512
[  165.965611] 
[  165.965612] cfs_rq[0]:/
[  165.965614]   .exec_clock                    : 21869.487029
[  165.965616]   .MIN_vruntime                  : 30145.683554
[  165.965618]   .min_vruntime                  : 30150.683554
[  165.965620]   .max_vruntime                  : 30145.683554
[  165.965622]   .spread                        : 0.000000
[  165.965624]   .spread0                       : 0.000000
[  165.965626]   .nr_running                    : 2
[  165.965628]   .load                          : 1536
[  165.965630]   .nr_spread_over                : 30
[  165.965632]   .shares                        : 0
[  165.965634] 
[  165.965635] rt_rq[0]:/sysdefault
[  165.965636]   .rt_nr_running                 : 1
[  165.965638]   .rt_throttled                  : 1
[  165.965640]   .rt_time                       : 0.004946
[  165.965642]   .rt_runtime                    : 0.000000
[  165.965644] 
[  165.965645] rt_rq[0]:/
[  165.965646]   .rt_nr_running                 : 0
[  165.965648]   .rt_throttled                  : 0
[  165.965650]   .rt_time                       : 0.000000
[  165.965652]   .rt_runtime                    : 950.000000
[  165.965654] 
[  165.965655] runnable tasks:
[  165.965655]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  165.965657] ----------------------------------------------------------------------------------------------------------
[  165.965661]         events/0     9     14375.279496       610   120     14375.279496        21.182708    165548.589243 /sysdefault
[  165.965685]  hald-addon-inpu  4361     14375.279496       186   120     14375.279496        12.226106    130949.335457 /sysdefault
[  165.965709]          kstop/0  5425     13245.862909         2     0     13245.862909         0.016139         0.000000 /sysdefault
[  165.965718] Rgnome-screensho  5486     30150.683554        27   120     30150.683554        20.215140         0.000000 /
[  165.965725] 
[  165.965726] cpu#1, 2194.349 MHz
[  165.965728]   .nr_running                    : 4
[  165.965730]   .load                          : 3072
[  165.965731]   .nr_switches                   : 159508
[  165.965733]   .nr_load_updates               : 21350
[  165.965735]   .nr_uninterruptible            : 0
[  165.965737]   .next_balance                  : 4294.933892
[  165.965739]   .curr->pid                     : 5131
[  165.965741]   .clock                         : 165965.015982
[  165.965743]   .cpu_load[0]                   : 3072
[  165.965745]   .cpu_load[1]                   : 2548
[  165.965747]   .cpu_load[2]                   : 2067
[  165.965748]   .cpu_load[3]                   : 1444
[  165.965750]   .cpu_load[4]                   : 953
[  165.965752]   .yld_count                     : 325
[  165.965754]   .sched_switch                  : 0
[  165.965756]   .sched_count                   : 174334
[  165.965758]   .sched_goidle                  : 60643
[  165.965760]   .avg_idle                      : 927715
[  165.965761]   .ttwu_count                    : 83628
[  165.965763]   .ttwu_local                    : 33968
[  165.965765]   .bkl_count                     : 1680
[  165.965768] 
[  165.965768] cfs_rq[1]:/sysdefault
[  165.965770]   .exec_clock                    : 2937.855433
[  165.965773]   .MIN_vruntime                  : 0.000001
[  165.965775]   .min_vruntime                  : 12850.626936
[  165.965777]   .max_vruntime                  : 0.000001
[  165.965779]   .spread                        : 0.000000
[  165.965781]   .spread0                       : -17300.056618
[  165.965783]   .nr_running                    : 0
[  165.965785]   .load                          : 0
[  165.965786]   .nr_spread_over                : 5
[  165.965788]   .shares                        : 0
[  165.965790]   .se->exec_start                : 165957.029502
[  165.965792]   .se->vruntime                  : 70200.366339
[  165.965794]   .se->sum_exec_runtime          : 2937.856233
[  165.965796]   .se->wait_start                : 0.000000
[  165.965798]   .se->sleep_start               : 0.000000
[  165.965800]   .se->block_start               : 0.000000
[  165.965802]   .se->sleep_max                 : 0.000000
[  165.965804]   .se->block_max                 : 0.000000
[  165.965806]   .se->exec_max                  : 4.202928
[  165.965808]   .se->slice_max                 : 6.494733
[  165.965810]   .se->wait_max                  : 36.413369
[  165.965812]   .se->wait_sum                  : 1651.434883
[  165.965814]   .se->wait_count                : 35739
[  165.965815]   .se->load.weight               : 512
[  165.965817] 
[  165.965818] cfs_rq[1]:/
[  165.965820]   .exec_clock                    : 23970.265876
[  165.965822]   .MIN_vruntime                  : 70208.662989
[  165.965824]   .min_vruntime                  : 70208.661563
[  165.965826]   .max_vruntime                  : 70209.970046
[  165.965828]   .spread                        : 1.307057
[  165.965830]   .spread0                       : 40057.978009
[  165.965832]   .nr_running                    : 3
[  165.965834]   .load                          : 3072
[  165.965836]   .nr_spread_over                : 8
[  165.965838]   .shares                        : 0
[  165.965840] 
[  165.965840] rt_rq[1]:/sysdefault
[  165.965842]   .rt_nr_running                 : 1
[  165.965844]   .rt_throttled                  : 1
[  165.965846]   .rt_time                       : 0.008010
[  165.965848]   .rt_runtime                    : 0.000000
[  165.965850] 
[  165.965850] rt_rq[1]:/
[  165.965852]   .rt_nr_running                 : 0
[  165.965854]   .rt_throttled                  : 0
[  165.965856]   .rt_time                       : 0.000000
[  165.965858]   .rt_runtime                    : 950.000000
[  165.965860] 
[  165.965860] runnable tasks:
[  165.965861]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[  165.965862] ----------------------------------------------------------------------------------------------------------
[  165.965875]             Xorg  4507     70208.662989     25145   120     70208.662989      9369.764131    116117.570517 /
[  165.965885] R    wnck-applet  5131     70207.152852      2311   120     70207.152852       224.420088     76121.036673 /
[  165.965893]          kstop/1  5426     13249.199354         2     0     13249.199354         0.018332         0.000000 /sysdefault
[  165.965900]  gnome-screensho  5481     70209.970046       284   120     70209.970046       213.201846       151.674206 /
[  165.965907] 
[  206.587331] SysRq : Show backtrace of all active CPUs
[  206.587338] sending NMI to all CPUs:
[  206.587341] NMI backtrace for cpu 1
[  206.587344] CPU 1 
[  206.587346] Modules linked in: aesni_intel(-) cryptd aes_x86_64 aes_generic binfmt_misc nfsd exportfs nfs lockd nfs_acl auth_rpcgss fbcon tileblit font snd_hda_codec_idt bitblit softcursor snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss ath9k sunrpc i915 snd_pcm ath9k_common drm_kms_helper snd_seq_dummy mac80211 drm snd_seq_oss snd_seq_midi snd_rawmidi joydev i2c_algo_bit ath9k_hw i2c_core ath snd_seq_midi_event video pcmcia snd_seq output cfg80211 snd_timer snd_seq_device snd intel_agp dell_laptop psmouse soundcore snd_page_alloc yenta_socket rsrc_nonstatic pcmcia_core serio_raw dcdbas dell_wmi led_class ohci1394 ieee1394 tg3
[  206.587409] 
[  206.587412] Pid: 4507, comm: Xorg Not tainted 2.6.34-rc3-ben #145       /Latitude D830                   
[  206.587415] RIP: 0010:[<ffffffff815bba9f>]  [<ffffffff815bba9f>] _raw_spin_lock+0x3f/0x40
[  206.587424] RSP: 0018:ffff880119ad5b90  EFLAGS: 00000292
[  206.587426] RAX: ffff880119fb2020 RBX: ffff880113be8c80 RCX: 0000000000000001
[  206.587429] RDX: 0000000000008301 RSI: 000000000002abb0 RDI: ffff880113be8c80
[  206.587431] RBP: ffff880119ad5bb8 R08: ffffffff821df610 R09: 0000000000000001
[  206.587434] R10: 0000000000000001 R11: 0000000000000246 R12: ffff880113be8c00
[  206.587437] R13: 0000000000000253 R14: ffffc9000795e160 R15: ffff8800cae1cb10
[  206.587440] FS:  00007f30d53dc700(0000) GS:ffff880002700000(0000) knlGS:0000000000000000
[  206.587442] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  206.587445] CR2: 00007f30cf4e1008 CR3: 00000001179f7000 CR4: 00000000000006e0
[  206.587447] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  206.587450] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  206.587453] Process Xorg (pid: 4507, threadinfo ffff880119ad4000, task ffff880119fb2020)
[  206.587455] Stack:
[  206.587457]  ffffffffa01dcd7e ffff880119ad5bb8 00000000000000e9 ffffc9000795fe80
[  206.587461] <0> ffff880119f1d780 ffff880119ad5cb8 ffffffffa02b156f ffff880119ad5c98
[  206.587466] <0> 0000000000000046 0000000002c7a3e0 0000000000000100 ffff880115489050
[  206.587471] Call Trace:
[  206.587488]  [<ffffffffa01dcd7e>] ? drm_gem_object_lookup+0x2e/0x70 [drm]
[  206.587501]  [<ffffffffa02b156f>] i915_gem_do_execbuffer+0x81f/0x1530 [i915]
[  206.587512]  [<ffffffffa02b2d44>] i915_gem_execbuffer+0x184/0x360 [i915]
[  206.587521]  [<ffffffffa01db3aa>] drm_ioctl+0x35a/0x4d0 [drm]
[  206.587531]  [<ffffffffa02b2bc0>] ? i915_gem_execbuffer+0x0/0x360 [i915]
[  206.587537]  [<ffffffff81143b2a>] ? do_sync_read+0xda/0x120
[  206.587541]  [<ffffffff81153aad>] vfs_ioctl+0x3d/0xd0
[  206.587545]  [<ffffffff8115403a>] do_vfs_ioctl+0x8a/0x5b0
[  206.587550]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  206.587553]  [<ffffffff811545e1>] sys_ioctl+0x81/0xa0
[  206.587557]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  206.587559] Code: 08 48 89 fb 48 89 04 24 48 8d 7f 18 41 b8 02 00 00 00 31 c9 31 d2 31 f6 e8 8f 6b ad ff 48 89 df e8 87 5d d5 ff 48 83 c4 18 5b c9 <c3> 55 48 89 e5 48 83 ec 30 48 89 5d e8 4c 89 65 f0 4c 89 6d f8 
[  206.587605] Call Trace:
[  206.587613]  [<ffffffffa01dcd7e>] ? drm_gem_object_lookup+0x2e/0x70 [drm]
[  206.587623]  [<ffffffffa02b156f>] i915_gem_do_execbuffer+0x81f/0x1530 [i915]
[  206.587633]  [<ffffffffa02b2d44>] i915_gem_execbuffer+0x184/0x360 [i915]
[  206.587642]  [<ffffffffa01db3aa>] drm_ioctl+0x35a/0x4d0 [drm]
[  206.587651]  [<ffffffffa02b2bc0>] ? i915_gem_execbuffer+0x0/0x360 [i915]
[  206.587655]  [<ffffffff81143b2a>] ? do_sync_read+0xda/0x120
[  206.587659]  [<ffffffff81153aad>] vfs_ioctl+0x3d/0xd0
[  206.587662]  [<ffffffff8115403a>] do_vfs_ioctl+0x8a/0x5b0
[  206.587666]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  206.587669]  [<ffffffff811545e1>] sys_ioctl+0x81/0xa0
[  206.587672]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  206.587676] Pid: 4507, comm: Xorg Not tainted 2.6.34-rc3-ben #145
[  206.587678] Call Trace:
[  206.587679]  <NMI>  [<ffffffff81012abb>] ? show_regs+0x2b/0x40
[  206.587687]  [<ffffffff815be252>] nmi_watchdog_tick+0x1b2/0x1e0
[  206.587690]  [<ffffffff815bd133>] do_nmi+0x1c3/0x2f0
[  206.587693]  [<ffffffff815bcc90>] nmi+0x20/0x39
[  206.587696]  [<ffffffff815bba9f>] ? _raw_spin_lock+0x3f/0x40
[  206.587698]  <<EOE>>  [<ffffffffa01dcd7e>] ? drm_gem_object_lookup+0x2e/0x70 [drm]
[  206.587716]  [<ffffffffa02b156f>] i915_gem_do_execbuffer+0x81f/0x1530 [i915]
[  206.587726]  [<ffffffffa02b2d44>] i915_gem_execbuffer+0x184/0x360 [i915]
[  206.587735]  [<ffffffffa01db3aa>] drm_ioctl+0x35a/0x4d0 [drm]
[  206.587745]  [<ffffffffa02b2bc0>] ? i915_gem_execbuffer+0x0/0x360 [i915]
[  206.587749]  [<ffffffff81143b2a>] ? do_sync_read+0xda/0x120
[  206.587752]  [<ffffffff81153aad>] vfs_ioctl+0x3d/0xd0
[  206.587756]  [<ffffffff8115403a>] do_vfs_ioctl+0x8a/0x5b0
[  206.587759]  [<ffffffff8100a0aa>] ? sysret_check+0x2e/0x69
[  206.587763]  [<ffffffff811545e1>] sys_ioctl+0x81/0xa0
[  206.587766]  [<ffffffff8100a072>] system_call_fastpath+0x16/0x1b
[  206.587772] NMI backtrace for cpu 0
[  206.587774] CPU 0 
[  206.587775] Modules linked in: aesni_intel(-) cryptd aes_x86_64 aes_generic binfmt_misc nfsd exportfs nfs lockd nfs_acl auth_rpcgss fbcon tileblit font snd_hda_codec_idt bitblit softcursor snd_hda_intel snd_hda_codec arc4 snd_pcm_oss snd_mixer_oss ath9k sunrpc i915 snd_pcm ath9k_common drm_kms_helper snd_seq_dummy mac80211 drm snd_seq_oss snd_seq_midi snd_rawmidi joydev i2c_algo_bit ath9k_hw i2c_core ath snd_seq_midi_event video pcmcia snd_seq output cfg80211 snd_timer snd_seq_device snd intel_agp dell_laptop psmouse soundcore snd_page_alloc yenta_socket rsrc_nonstatic pcmcia_core serio_raw dcdbas dell_wmi led_class ohci1394 ieee1394 tg3
[  206.587826] 
[  206.587829] Pid: 5500, comm: gnome-screensho Not tainted 2.6.34-rc3-ben #145       /Latitude D830                   
[  206.587832] RIP: 0010:[<ffffffff81012149>]  [<ffffffff81012149>] native_read_tsc+0x9/0x20
[  206.587837] RSP: 0000:ffff880002603b80  EFLAGS: 00000803
[  206.587840] RAX: 000000006d0aa94a RBX: 0000000000000001 RCX: 000000006d0aa94a
[  206.587842] RDX: 0000000000000051 RSI: 0000000000000000 RDI: 000000000021372b
[  206.587845] RBP: ffff880002603ba8 R08: 0000000000000001 R09: 0000000000000000
[  206.587847] R10: 0000000000000000 R11: 00000000000000aa R12: ffff880118010000
[  206.587850] R13: 0000000000000000 R14: 000000000021372b R15: 0000000000000004
[  206.587853] FS:  00007fcc6405e7a0(0000) GS:ffff880002600000(0000) knlGS:0000000000000000
[  206.587855] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  206.587858] CR2: 00007fff508857d8 CR3: 00000000b981c000 CR4: 00000000000006f0
[  206.587860] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  206.587863] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  206.587865] Process gnome-screensho (pid: 5500, threadinfo ffff8800b9fd0000, task ffff8800c68cc040)
[  206.587867] Stack:
[  206.587869]  ffffffff8130bfb7 0000000000000001 ffff880118010000 ffffffff81a862c0
[  206.587873] <0> 0000000000000082 ffff880002603bb8 ffffffff8130bf80 ffff880002603bd8
[  206.587878] <0> ffffffff810280e4 0000000000000001 000000000000006c ffff880002603be8
[  206.587883] Call Trace:
[  206.587885]  <IRQ> 
[  206.587891]  [<ffffffff8130bfb7>] ? delay_tsc+0x27/0x80
[  206.587895]  [<ffffffff8130bf80>] __const_udelay+0x40/0x50
[  206.587899]  [<ffffffff810280e4>] arch_trigger_all_cpu_backtrace+0x54/0x70
[  206.587904]  [<ffffffff813a160e>] sysrq_handle_showallcpus+0xe/0x10
[  206.587907]  [<ffffffff813a1a1a>] __handle_sysrq+0x12a/0x190
[  206.587910]  [<ffffffff813a1afb>] handle_sysrq+0x2b/0x30
[  206.587914]  [<ffffffff81398759>] kbd_event+0x749/0x820
[  206.587919]  [<ffffffff81454588>] input_pass_event+0x108/0x110
[  206.587923]  [<ffffffff81454480>] ? input_pass_event+0x0/0x110
[  206.587927]  [<ffffffff81454733>] input_handle_event+0x93/0x470
[  206.587930]  [<ffffffff81454ea4>] input_event+0x84/0xa0
[  206.587934]  [<ffffffff8145abab>] atkbd_interrupt+0x60b/0x6c0
[  206.587938]  [<ffffffff8144fcd2>] serio_interrupt+0x52/0xa0
[  206.587941]  [<ffffffff81450082>] i8042_interrupt+0x132/0x3a0
[  206.587945]  [<ffffffff810c5dc2>] ? handle_edge_irq+0x22/0x170
[  206.587949]  [<ffffffff810c3830>] handle_IRQ_event+0x50/0x160
[  206.587953]  [<ffffffff810c5e5e>] handle_edge_irq+0xbe/0x170
[  206.587956]  [<ffffffff8100cca2>] handle_irq+0x22/0x30
[  206.587960]  [<ffffffff815c32fc>] do_IRQ+0x6c/0xf0
[  206.587963]  [<ffffffff815bc613>] ret_from_intr+0x0/0x16
[  206.587965]  <EOI> 
[  206.587967] Code: 90 90 55 89 f8 48 89 e5 e6 70 e4 71 c9 c3 0f 1f 40 00 55 89 f0 48 89 e5 e6 70 89 f8 e6 71 c9 c3 66 90 55 48 89 e5 0f 31 89 c1 c9 <48> 89 d0 89 c9 48 c1 e0 20 48 09 c8 c3 66 2e 0f 1f 84 00 00 00 
[  206.588013] Call Trace:
[  206.588015]  <IRQ>  [<ffffffff8130bfb7>] ? delay_tsc+0x27/0x80
[  206.588021]  [<ffffffff8130bf80>] __const_udelay+0x40/0x50
[  206.588025]  [<ffffffff810280e4>] arch_trigger_all_cpu_backtrace+0x54/0x70
[  206.588028]  [<ffffffff813a160e>] sysrq_handle_showallcpus+0xe/0x10
[  206.588031]  [<ffffffff813a1a1a>] __handle_sysrq+0x12a/0x190
[  206.588034]  [<ffffffff813a1afb>] handle_sysrq+0x2b/0x30
[  206.588038]  [<ffffffff81398759>] kbd_event+0x749/0x820
[  206.588041]  [<ffffffff81454588>] input_pass_event+0x108/0x110
[  206.588044]  [<ffffffff81454480>] ? input_pass_event+0x0/0x110
[  206.588048]  [<ffffffff81454733>] input_handle_event+0x93/0x470
[  206.588051]  [<ffffffff81454ea4>] input_event+0x84/0xa0
[  206.588055]  [<ffffffff8145abab>] atkbd_interrupt+0x60b/0x6c0
[  206.588058]  [<ffffffff8144fcd2>] serio_interrupt+0x52/0xa0
[  206.588061]  [<ffffffff81450082>] i8042_interrupt+0x132/0x3a0
[  206.588064]  [<ffffffff810c5dc2>] ? handle_edge_irq+0x22/0x170
[  206.588068]  [<ffffffff810c3830>] handle_IRQ_event+0x50/0x160
[  206.588071]  [<ffffffff810c5e5e>] handle_edge_irq+0xbe/0x170
[  206.588074]  [<ffffffff8100cca2>] handle_irq+0x22/0x30
[  206.588077]  [<ffffffff815c32fc>] do_IRQ+0x6c/0xf0
[  206.588080]  [<ffffffff815bc613>] ret_from_intr+0x0/0x16
[  206.588082]  <EOI> Pid: 5500, comm: gnome-screensho Not tainted 2.6.34-rc3-ben #145
[  206.588086] Call Trace:
[  206.588088]  <NMI>  [<ffffffff81012abb>] ? show_regs+0x2b/0x40
[  206.588094]  [<ffffffff815be252>] nmi_watchdog_tick+0x1b2/0x1e0
[  206.588097]  [<ffffffff815bd133>] do_nmi+0x1c3/0x2f0
[  206.588100]  [<ffffffff815bcc90>] nmi+0x20/0x39
[  206.588104]  [<ffffffff81012149>] ? native_read_tsc+0x9/0x20
[  206.588106]  <<EOE>>  <IRQ>  [<ffffffff8130bfb7>] ? delay_tsc+0x27/0x80
[  206.588113]  [<ffffffff8130bf80>] __const_udelay+0x40/0x50
[  206.588116]  [<ffffffff810280e4>] arch_trigger_all_cpu_backtrace+0x54/0x70
[  206.588119]  [<ffffffff813a160e>] sysrq_handle_showallcpus+0xe/0x10
[  206.588123]  [<ffffffff813a1a1a>] __handle_sysrq+0x12a/0x190
[  206.588126]  [<ffffffff813a1afb>] handle_sysrq+0x2b/0x30
[  206.588129]  [<ffffffff81398759>] kbd_event+0x749/0x820
[  206.588133]  [<ffffffff81454588>] input_pass_event+0x108/0x110
[  206.588136]  [<ffffffff81454480>] ? input_pass_event+0x0/0x110
[  206.588139]  [<ffffffff81454733>] input_handle_event+0x93/0x470
[  206.588143]  [<ffffffff81454ea4>] input_event+0x84/0xa0
[  206.588146]  [<ffffffff8145abab>] atkbd_interrupt+0x60b/0x6c0
[  206.588149]  [<ffffffff8144fcd2>] serio_interrupt+0x52/0xa0
[  206.588153]  [<ffffffff81450082>] i8042_interrupt+0x132/0x3a0
[  206.588156]  [<ffffffff810c5dc2>] ? handle_edge_irq+0x22/0x170
[  206.588159]  [<ffffffff810c3830>] handle_IRQ_event+0x50/0x160
[  206.588162]  [<ffffffff810c5e5e>] handle_edge_irq+0xbe/0x170
[  206.588166]  [<ffffffff8100cca2>] handle_irq+0x22/0x30
[  206.588168]  [<ffffffff815c32fc>] do_IRQ+0x6c/0xf0
[  206.588172]  [<ffffffff815bc613>] ret_from_intr+0x0/0x16
[  206.588173]  <EOI> 
