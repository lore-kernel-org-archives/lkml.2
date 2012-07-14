Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2GNN7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:59:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:49524 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab2GNN7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:59:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177317568"
Date: Sat, 14 Jul 2012 21:58:49 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120714135849.GA1257@localhost>
References: <20120710141830.GA5385@localhost>
 <20120714130510.GC31729@ZenIV.linux.org.uk>
 <20120714134849.GA1175@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120714134849.GA1175@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 14, 2012 at 09:48:49PM +0800, Fengguang Wu wrote:
> On Sat, Jul 14, 2012 at 02:05:10PM +0100, Al Viro wrote:
> > On Tue, Jul 10, 2012 at 10:18:30PM +0800, wfg@linux.intel.com wrote:
> > > Hi Al,
> > > 
> > > The linux-next kernel reliably hung after this line:
> > > 
> > > [    4.846260] debug: unmapping init [mem 0xffff88000182a000-0xffff8800019fffff]
> > > 
> > > And it's bisected to commit:
> > > 
> > >         commit 4a9ffe81385c2af04f296bea05482f34e02ea10d
> > >         Author: Al Viro <viro@zeniv.linux.org.uk>
> > >         Date:   Sun Jun 24 09:56:45 2012 +0400
> > > 
> > >             switch fput to task_work_add
> > > 
> > >             ... and schedule_work() for interrupt/kernel_thread callers
> > >             (and yes, now it *is* OK to call from interrupt).
> > > 
> > > I tried add this debug aid:
> > > 
> > > init_post(void):
> > > +       printk(KERN_WARNING "flush_delayed_fput\n");
> > >         flush_delayed_fput();
> > > +       printk(KERN_WARNING "flush_delayed_fput done\n");
> > > 
> > > And then it hangs after "flush_delayed_fput done". So it's not directly
> > > freezing inside flush_delayed_fput()..
> > 
> > Could you post a stack trace, etc.?  I'll try to reproduce that one, obviously,
> > but...
> 
> Hi Al, here I got the output for
> 
> (qemu) sendkey alt-sysrq-l
> (qemu) sendkey alt-sysrq-t

I repeated that several times and here are the results.

(qemu) sendkey alt-sysrq-l
(qemu) sendkey alt-sysrq-l
(qemu) sendkey alt-sysrq-l
(qemu) sendkey alt-sysrq-t
(qemu) sendkey alt-sysrq-t
(qemu) quit

The user space shutdown is polling on something, which prevents the
system from reboot..

Thanks,
Fengguang

--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=UTF-8
Content-Disposition: attachment; filename=dmesg-kvm_bisect-waimea-3828-2012-07-14-21-53-12
Content-Transfer-Encoding: 8bit

[    0.000000] Linux version 3.5.0-rc5-bisect-00089-gdab5369 (wfg@bee) (gcc version 4.7.0 (Debian 4.7.1-1) ) #113 SMP Sat Jul 14 21:40:41 CST 2012
[    0.000000] Command line: bisect-reboot x86_64-randconfig run_test= trinity=0 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=x86_64/vmlinuz-bisect
[    0.000000] Disabled fast string operations
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] debug: ignoring loglevel setting.
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] e820: last_pfn = 0xfffd max_arch_pfn = 0x400000000
[    0.000000] Scan for SMP in [mem 0x00000000-0x000003ff]
[    0.000000] Scan for SMP in [mem 0x0009fc00-0x0009ffff]
[    0.000000] Scan for SMP in [mem 0x000f0000-0x000fffff]
[    0.000000] found SMP MP-table at [mem 0x000f8860-0x000f886f] mapped at [ffff8800000f8860]
[    0.000000]   mpc: f8870-f898c
[    0.000000] initial memory mapped: [mem 0x00000000-0x1fffffff]
[    0.000000] Base memory trampoline at [ffff880000099000] 99000 size 24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x0fffcfff]
[    0.000000]  [mem 0x00000000-0x0fffcfff] page 4k
[    0.000000] kernel direct mapping tables up to 0xfffcfff @ [mem 0x0e854000-0x0e8d5fff]
[    0.000000] log_buf_len: 8388608
[    0.000000] early log buf free: 128884(98%)
[    0.000000] RAMDISK: [mem 0x0e8d6000-0x0ffeffff]
[    0.000000] kvm-clock: cpu 0, msr 0:1c61ac1, boot clock
[    0.000000] Zone ranges:
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00010000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x0fffcfff]
[    0.000000] On node 0 totalpages: 65420
[    0.000000]   DMA32 zone: 1024 pages used for memmap
[    0.000000]   DMA32 zone: 6 pages reserved
[    0.000000]   DMA32 zone: 64390 pages, LIFO batch:15
[    0.000000] SFI: Simple Firmware Interface v0.81 http://simplefirmware.org
[    0.000000] Intel MultiProcessor Specification v1.4
[    0.000000]   mpc: f8870-f898c
[    0.000000] MPTABLE: OEM ID: BOCHSCPU
[    0.000000] MPTABLE: Product ID: 0.1         
[    0.000000] MPTABLE: APIC at: 0xFEE00000
[    0.000000] mapped APIC to ffffffffff5fb000 (        fee00000)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] Processor #1
[    0.000000] Bus #0 is PCI   
[    0.000000] Bus #1 is ISA   
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 09
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 10, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 14, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 18, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 1c, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 20, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 1, trig 0, bus 00, IRQ 24, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] Int: type 0, pol 0, trig 0, bus 01, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] Lint: type 3, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 00
[    0.000000] Lint: type 1, pol 0, trig 0, bus 01, IRQ 00, APIC ID 0, APIC LINT 01
[    0.000000] Processors: 2
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped IOAPIC to ffffffffff5fa000 (fec00000)
[    0.000000] nr_irqs_gsi: 40
[    0.000000] e820: [mem 0x10000000-0xfffbbfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 471 pages/cpu @ffff88000dc00000 s1906656 r0 d22560 u2097152
[    0.000000] kvm-clock: cpu 0, msr 0:ddd0ac1, primary cpu clock
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 64390
[    0.000000] Kernel command line: bisect-reboot x86_64-randconfig run_test= trinity=0 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10 hung_task_panic=1 softlockup_panic=1 unknown_nmi_panic=1 nmi_watchdog=panic,lapic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw BOOT_IMAGE=x86_64/vmlinuz-bisect
[    0.000000] sysrq: sysrq always enabled.
[    0.000000] PID hash table entries: 1024 (order: 1, 8192 bytes)
[    0.000000] Dentry cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.000000] Inode-cache hash table entries: 16384 (order: 5, 131072 bytes)
[    0.000000] __ex_table already sorted, skipping sort
[    0.000000] Memory: 198596k/262132k available (4647k kernel code, 452k absent, 63084k reserved, 6165k data, 2204k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU debugfs-based tracing is enabled.
[    0.000000] 	RCU lockdep checking is enabled.
[    0.000000] 	Additional per-CPU info printed with stalls.
[    0.000000] NR_IRQS:4352 nr_irqs:56 16
[    0.000000] console [ttyS0] enabled
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
[    0.000000] Detected 3299.986 MHz processor.
[    0.010000] Calibrating delay loop (skipped) preset value.. 6599.97 BogoMIPS (lpj=32999860)
[    0.010000] pid_max: default: 32768 minimum: 301
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Disabled fast string operations
[    0.010000] Getting VERSION: 50014
[    0.010000] Getting VERSION: 50014
[    0.010000] Getting ID: 0
[    0.010000] Getting ID: ff000000
[    0.010000] Getting LVT0: 8700
[    0.010000] Getting LVT1: 8400
[    0.010000] enabled ExtINT on CPU#0
[    0.010219] ENABLING IO-APIC IRQs
[    0.010779] init IO_APIC IRQs
[    0.011414]  apic 2 pin 0 not connected
[    0.012090] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.013449] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.014777] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.016129] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.017478] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.018812] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.020019] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.021388] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.022728] IOAPIC[0]: Set routing entry (2-9 -> 0x29 -> IRQ 33 Mode:1 Active:0 Dest:1)
[    0.024080] IOAPIC[0]: Set routing entry (2-10 -> 0x41 -> IRQ 34 Mode:1 Active:0 Dest:1)
[    0.025449] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:0 Dest:1)
[    0.026796] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.028172] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.029545] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.030019] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.031392]  apic 2 pin 16 not connected
[    0.032071]  apic 2 pin 17 not connected
[    0.032730]  apic 2 pin 18 not connected
[    0.033380]  apic 2 pin 19 not connected
[    0.034040]  apic 2 pin 20 not connected
[    0.034701]  apic 2 pin 21 not connected
[    0.035368]  apic 2 pin 22 not connected
[    0.036044]  apic 2 pin 23 not connected
[    0.036853] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.037966] CPU0: Intel Common KVM processor stepping 01
[    0.040003] Using local APIC timer interrupts.
[    0.040003] calibrating APIC timer ...
[    0.050000] ... lapic delta = 6249341
[    0.050000] ..... delta 6249341
[    0.050000] ..... mult: 268407152
[    0.050000] ..... calibration result: 9998945
[    0.050000] ..... CPU clock speed is 3299.6351 MHz.
[    0.050000] ..... host bus clock speed is 999.8945 MHz.
[    0.050000] ... verify APIC timer
[    0.165412] ... jiffies delta = 10
[    0.166068] ... jiffies result ok
[    0.166718] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.169265] lockdep: fixing up alternatives.
[    0.170000] Booting Node   0, Processors  #1 Ok.
[    0.010000] kvm-clock: cpu 1, msr 0:dfd0ac1, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.010000] Disabled fast string operations
[    0.180000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.180000] Measured 797 cycles TSC warp between CPUs, turning off TSC clock.
[    0.180000] Marking TSC unstable due to check_tsc_sync_source failed
[    0.190056] Brought up 2 CPUs
[    0.190565] Total of 2 processors activated (13199.94 BogoMIPS).
[    0.191981] device: 'platform': device_add
[    0.192690] bus: 'platform': registered
[    0.193343] bus: 'cpu': registered
[    0.193938] device: 'cpu': device_add
[    0.194974] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.196126] device class 'regulator': registering
[    0.196983] Registering platform device 'reg-dummy'. Parent at platform
[    0.198076] device: 'reg-dummy': device_add
[    0.198779] bus: 'platform': add device reg-dummy
[    0.199605] bus: 'platform': add driver reg-dummy
[    0.200008] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.201461] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.202842] device: 'regulator.0': device_add
[    0.203653] dummy: 
[    0.204039] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.205309] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.206731] NET: Registered protocol family 16
[    0.207681] device class 'bdi': registering
[    0.208393] device class 'lcd': registering
[    0.209098] device class 'backlight': registering
[    0.210007] device class 'tty': registering
[    0.210742] bus: 'hsi': registered
[    0.211327] bus: 'i2c': registered
[    0.211914] bus: 'i2c': add driver dummy
[    0.212578] i2c-core: driver [dummy] registered
[    0.213699] device class 'dmi': registering
[    0.214414] device: 'id': device_add
[    0.215230] device: 'cpu0': device_add
[    0.215874] bus: 'cpu': add device cpu0
[    0.216530] device: 'cpu1': device_add
[    0.217173] bus: 'cpu': add device cpu1
[    0.217967] device: 'default': device_add
[    0.218983] bio: create slab <bio-0> at 0
[    0.220055] device class 'block': registering
[    0.220955] bus: 'i2c': add driver mcp230xx
[    0.221654] i2c-core: driver [mcp230xx] registered
[    0.222470] bus: 'platform': add driver stmpe-gpio
[    0.223297] bus: 'i2c': add driver sx150x
[    0.224002] i2c-core: driver [sx150x] registered
[    0.224763] bus: 'platform': add driver tps65912-gpio
[    0.225605] bus: 'platform': add driver wm831x-gpio
[    0.226437] bus: 'platform': add driver wm8350-gpio
[    0.227285] device class 'graphics': registering
[    0.228086] bus: 'platform': add driver aat2870-backlight
[    0.229016] bus: 'platform': add driver reg-fixed-voltage
[    0.230009] bus: 'platform': add driver 88pm860x-regulator
[    0.230980] bus: 'platform': add driver aat2870-regulator
[    0.231900] bus: 'i2c': add driver ad5398
[    0.232605] i2c-core: driver [ad5398] registered
[    0.233402] bus: 'i2c': add driver lp3972
[    0.234128] i2c-core: driver [lp3972] registered
[    0.234942] bus: 'i2c': add driver max1586
[    0.235720] i2c-core: driver [max1586] registered
[    0.236519] bus: 'platform': add driver max8925-regulator
[    0.237445] bus: 'platform': add driver mc13892-regulator
[    0.238347] bus: 'platform': add driver palmas-pmic
[    0.239178] bus: 'platform': add driver tps6105x-regulator
[    0.240009] bus: 'i2c': add driver tps62360
[    0.240712] i2c-core: driver [tps62360] registered
[    0.241513] bus: 'i2c': add driver tps65023
[    0.242219] i2c-core: driver [tps65023] registered
[    0.243036] bus: 'platform': add driver tps6507x-pmic
[    0.243914] bus: 'platform': add driver tps65217-pmic
[    0.244758] bus: 'platform': add driver tps65912-pmic
[    0.245608] bus: 'platform': add driver wm831x-buckv
[    0.246439] bus: 'platform': add driver wm831x-buckp
[    0.247288] bus: 'platform': add driver wm831x-boostp
[    0.248151] bus: 'platform': add driver wm831x-epe
[    0.248956] bus: 'platform': add driver wm831x-isink
[    0.250024] bus: 'platform': add driver wm831x-ldo
[    0.250823] bus: 'platform': add driver wm831x-aldo
[    0.251658] bus: 'platform': add driver wm831x-alive-ldo
[    0.252560] bus: 'platform': add driver wm8350-regulator
[    0.253447] bus: 'platform': add driver wm8400-regulator
[    0.254342] device class 'misc': registering
[    0.255073] bus: 'i2c': add driver 88PM860x
[    0.255781] i2c-core: driver [88PM860x] registered
[    0.256593] bus: 'i2c': add driver stmpe-i2c
[    0.257315] i2c-core: driver [stmpe-i2c] registered
[    0.258131] bus: 'i2c': add driver WM8400
[    0.258800] i2c-core: driver [WM8400] registered
[    0.259590] bus: 'i2c': add driver wm831x
[    0.260007] i2c-core: driver [wm831x] registered
[    0.260784] bus: 'i2c': add driver wm8350
[    0.261448] i2c-core: driver [wm8350] registered
[    0.262223] bus: 'i2c': add driver tps6105x
[    0.262942] i2c-core: driver [tps6105x] registered
[    0.263775] bus: 'i2c': add driver tps6507x
[    0.264505] i2c-core: driver [tps6507x] registered
[    0.265303] bus: 'i2c': add driver tps65217
[    0.266125] i2c-core: driver [tps65217] registered
[    0.266938] bus: 'i2c': add driver tps65912
[    0.267647] i2c-core: driver [tps65912] registered
[    0.268457] bus: 'i2c': add driver mc13xxx
[    0.269143] i2c-core: driver [mc13xxx] registered
[    0.270005] bus: 'i2c': add driver da903x
[    0.270688] i2c-core: driver [da903x] registered
[    0.271476] bus: 'i2c': add driver da9052
[    0.272162] i2c-core: driver [da9052] registered
[    0.272930] bus: 'i2c': add driver max8925
[    0.273608] i2c-core: driver [max8925] registered
[    0.274408] bus: 'i2c': add driver max8997
[    0.275113] i2c-core: driver [max8997] registered
[    0.275916] bus: 'i2c': add driver aat2870
[    0.276595] i2c-core: driver [aat2870] registered
[    0.277380] bus: 'i2c': add driver palmas
[    0.278057] i2c-core: driver [palmas] registered
[    0.278848] bus: 'platform': add driver nop_usb_xceiv
[    0.280009] device class 'udc': registering
[    0.280726] bus: 'serio': registered
[    0.281335] bus: 'gameport': registered
[    0.281970] device class 'input': registering
[    0.282705] Linux video capture interface: v2.00
[    0.283491] device class 'video4linux': registering
[    0.284343] device class 'dvb': registering
[    0.285040] device class 'power_supply': registering
[    0.285863] device class 'hwmon': registering
[    0.286599] device class 'leds': registering
[    0.287331] device class 'devfreq': registering
[    0.288111] device class 'net': registering
[    0.288830] device: 'lo': device_add
[    0.310309] Switching to clocksource kvm-clock
[    0.311115] FS-Cache: Loaded
[    0.311619] device: 'cachefiles': device_add
[    0.312446] CacheFiles: Loaded
[    0.313062] device class 'mem': registering
[    0.313770] device: 'mem': device_add
[    0.314477] device: 'null': device_add
[    0.315162] device: 'zero': device_add
[    0.315789] device: 'full': device_add
[    0.316483] device: 'random': device_add
[    0.317215] device: 'urandom': device_add
[    0.317962] device: 'kmsg': device_add
[    0.318605] device: 'oldmem': device_add
[    0.319317] device: 'tty': device_add
[    0.319317] device: 'console': device_add
[    0.319805] device class 'thermal': registering
[    0.320674] NET: Registered protocol family 2
[    0.321512] IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.322854] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[    0.324315] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    0.326672] TCP: Hash tables configured (established 8192 bind 8192)
[    0.327761] TCP: reno registered
[    0.328341] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.329398] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.330611] NET: Registered protocol family 1
[    0.331478] Unpacking initramfs...
[    1.041327] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.054925] DMA-API: preallocated 32768 debug entries
[    1.055795] DMA-API: debugging enabled by kernel config
[    1.056925] Registering platform device 'rtc_cmos'. Parent at platform
[    1.058015] device: 'rtc_cmos': device_add
[    1.058704] bus: 'platform': add device rtc_cmos
[    1.059551] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.061256] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    1.062786] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    1.064360] bus: 'platform': add driver alarmtimer
[    1.065173] Registering platform device 'alarmtimer'. Parent at platform
[    1.066283] device: 'alarmtimer': device_add
[    1.067012] bus: 'platform': add device alarmtimer
[    1.067973] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.069441] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.070843] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.072041] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.073388] audit: initializing netlink socket (disabled)
[    1.074322] type=2000 audit(1342273593.070:1): initialized
[    1.075469] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    1.081636] bus: 'event_source': registered
[    1.082351] device: 'breakpoint': device_add
[    1.083096] bus: 'event_source': add device breakpoint
[    1.084019] device: 'software': device_add
[    1.084720] bus: 'event_source': add device software
[    1.085709] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.087085] VFS: Disk quotas dquot_6.5.2
[    1.087809] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.089102] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.090243] jffs2: version 2.2. Â© 2001-2006 Red Hat, Inc.
[    1.091343] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.092101] QNX4 filesystem 0.2.3 registered.
[    1.092863] QNX6 filesystem 1.0.0 registered.
[    1.093607] device: 'autofs': device_add
[    1.094285] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.096331] alg: No test for cipher_null (cipher_null-generic)
[    1.097485] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.098614] alg: No test for digest_null (digest_null-generic)
[    1.099759] alg: No test for compress_null (compress_null-generic)
[    1.106099] alg: No test for stdrng (krng)
[    1.113324] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.114571] NET: Registered protocol family 38
[    1.115378] device class 'bsg': registering
[    1.116124] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.117443] io scheduler noop registered
[    1.118111] io scheduler cfq registered (default)
[    1.118886] list_sort_test: start testing list_sort()
[    1.121157] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
[    1.121991] crc32: self tests passed, processed 225944 bytes in 627385 nsec
[    1.123727] crc32c: CRC_LE_BITS = 8
[    1.124331] crc32c: self tests passed, processed 225944 bytes in 284667 nsec
[    1.125550] bus: 'platform': add driver adp5520-gpio
[    1.126402] bus: 'i2c': add driver adp5588-gpio
[    1.127180] i2c-core: driver [adp5588-gpio] registered
[    1.128144] bus: 'i2c': add driver lp855x
[    1.128821] i2c-core: driver [lp855x] registered
[    1.129663] bus: 'platform': add driver max8925-backlight
[    1.130583] bus: 'platform': add driver adp5520-backlight
[    1.131520] bus: 'i2c': add driver adp8860_bl
[    1.132266] i2c-core: driver [adp8860_bl] using legacy suspend method
[    1.133368] i2c-core: driver [adp8860_bl] using legacy resume method
[    1.134420] i2c-core: driver [adp8860_bl] registered
[    1.135248] bus: 'platform': add driver 88pm860x-backlight
[    1.136177] bus: 'platform': add driver hecubafb
[    1.136964] no IO addresses supplied
[    1.137557] bus: 'platform': add driver broadsheetfb
[    1.138437] bus: 'platform': add driver s1d13xxxfb
[    1.139293] bus: 'platform': add driver sm501-fb
[    1.140106] bus: 'platform': add driver reg-virt-consumer
[    1.141021] bus: 'platform': add driver reg-userspace-consumer
[    1.142004] device: 'ptmx': device_add
[    1.142640] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.143563] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.144641] Registering platform device 'serial8250'. Parent at platform
[    1.145746] device: 'serial8250': device_add
[    1.146459] bus: 'platform': add device serial8250
ÿ[    1.450336] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.451386] device: 'ttyS0': device_add
[    1.452113] device: 'ttyS1': device_add
[    1.452808] device: 'ttyS2': device_add
[    1.453527] device: 'ttyS3': device_add
[    1.454198] bus: 'platform': add driver serial8250
[    1.455025] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    1.456536] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    1.457948] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    1.459134] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    1.460472] bus: 'platform': add driver timb-uart
[    1.461272] bus: 'platform': add driver altera_jtaguart
[    1.462171] bus: 'platform': add driver xuartps
[    1.462988] device: 'ttyprintk': device_add
[    1.463698] device: 'rtc': device_add
[    1.464324] Real Time Clock Driver v1.12b
[    1.465002] device class 'ppdev': registering
[    1.465741] ppdev: user-space parallel port driver
[    1.466572] smapi::smapi_init, ERROR invalid usSmapiID
[    1.467443] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    1.469090] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    1.470322] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.471385] bus: 'platform': add driver ipmi
[    1.472121] ipmi message handler version 39.2
[    1.472842] ipmi device interface
[    1.473419] device class 'ipmi': registering
[    1.474169] bus: 'platform': add driver ipmi_si
[    1.474946] IPMI System Interface driver.
[    1.475626] ipmi_si: Adding default-specified kcs state machine
[    1.476630] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    1.478294] ipmi_si: Interface detection failed
[    1.490064] ipmi_si: Adding default-specified smic state machine
[    1.491128] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    1.492786] ipmi_si: Interface detection failed
[    1.550138] ipmi_si: Adding default-specified bt state machine
[    1.551179] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    1.552862] ipmi_si: Interface detection failed
[    1.610076] bus: 'platform': remove driver ipmi_si
[    1.610902] driver: 'ipmi_si': driver_release
[    1.611654] ipmi_si: Unable to find any System Interface(s)
[    1.612579] IPMI Watchdog: driver initialized
[    1.613321] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    1.614605] device class 'drm': registering
[    1.615331] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    1.616311] device class 'drm': unregistering
[    1.617039] class 'drm': release.
[    1.617597] class_create_release called for drm
[    1.618382] bus: 'platform': add driver parport_pc
[    1.619295] Registering platform device 'parport_pc.956'. Parent at platform
[    1.620473] device: 'parport_pc.956': device_add
[    1.621244] bus: 'platform': add device parport_pc.956
[    1.622138] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[    1.623703] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[    1.625138] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[    1.626375] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[    1.627844] bus: 'platform': remove device parport_pc.956
[    1.628764] Registering platform device 'parport_pc.888'. Parent at platform
[    1.629946] device: 'parport_pc.888': device_add
[    1.630740] bus: 'platform': add device parport_pc.888
[    1.631629] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[    1.633171] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[    1.634614] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[    1.635839] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[    1.637291] parport0: PC-style at 0x378 [PCSPP(,...)]
[    1.638290] parport0: irq 0 detected
[    1.638920] device: 'parport0': device_add
[    1.639647] Registering platform device 'parport_pc.632'. Parent at platform
[    1.640820] device: 'parport_pc.632': device_add
[    1.641598] bus: 'platform': add device parport_pc.632
[    1.642488] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[    1.644048] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[    1.645468] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[    1.646701] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[    1.648154] bus: 'platform': remove device parport_pc.632
[    1.649126] device class 'enclosure': registering
[    1.649919] bus: 'i2c': add driver apds9802als
[    1.650704] i2c-core: driver [apds9802als] using legacy suspend method
[    1.651790] i2c-core: driver [apds9802als] using legacy resume method
[    1.652853] i2c-core: driver [apds9802als] registered
[    1.653722] bus: 'i2c': add driver isl29020
[    1.654441] i2c-core: driver [isl29020] registered
[    1.655254] bus: 'i2c': add driver hmc6352
[    1.655943] i2c-core: driver [hmc6352] registered
[    1.656720] bus: 'i2c': add driver fsa9480
[    1.657418] i2c-core: driver [fsa9480] using legacy suspend method
[    1.658455] i2c-core: driver [fsa9480] using legacy resume method
[    1.659471] i2c-core: driver [fsa9480] registered
[    1.660269] bus: 'platform': add driver sm501
[    1.661002] bus: 'i2c': add driver twl6040
[    1.661694] i2c-core: driver [twl6040] registered
[    1.662496] bus: 'i2c': add driver adp5520
[    1.663211] i2c-core: driver [adp5520] registered
[    1.663996] Uniform Multi-Platform E-IDE driver
[    1.664745] bus: 'ide': registered
[    1.665326] device class 'ide_port': registering
[    1.666118] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.667737] Probing IDE interface ide0...
[    2.270059] device: 'ide0': device_add
[    2.270704] device: 'ide0': device_add
[    2.271438] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.272231] Probing IDE interface ide1...
[    3.060172] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    3.780128] device: 'ide1': device_add
[    3.780828] device: 'ide1': device_add
[    3.781530] ide1 at 0x170-0x177,0x376 on irq 15
[    3.782462] device: '1.0': device_add
[    3.783100] bus: 'ide': add device 1.0
[    3.783744] ide-cd driver 5.00
[    3.784299] bus: 'ide': add driver ide-cdrom
[    3.785025] bus: 'ide': driver_probe_device: matched device 1.0 with driver ide-cdrom
[    3.786491] bus: 'ide': really_probe: probing driver ide-cdrom with device 1.0
[    3.788107] device: '1.0': device_add
[    3.789097] ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
[    3.790196] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.792019] device: '22:0': device_add
[    3.792725] device: 'hdc': device_add
[    3.793422] driver: '1.0': driver_bound: bound to device 'ide-cdrom'
[    3.794858] bus: 'ide': really_probe: bound device 1.0 to driver ide-cdrom
[    3.796013] device class 'ide_tape': registering
[    3.796776] bus: 'ide': add driver ide-tape
[    3.797490] device class 'mtd': registering
[    3.798225] device: 'mtd-unmap': device_add
[    3.798977] device: 'mtd-romap': device_add
[    3.799701] device: 'mtd-rwmap': device_add
[    3.800509] SSFDC read-only Flash Translation layer
[    3.801345] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.802377] bus: 'platform': add driver mtd-ram
[    3.803173] bus: 'platform': add driver docg3
[    3.803898] bus: 'platform': remove driver docg3
[    3.804671] driver: 'docg3': driver_release
[    3.833384] No recognised DiskOnChip devices found
[    3.834207] slram: not enough parameters.
[    3.836018] device: 'mtd0': device_add
[    3.836667] device: 'mtd0ro': device_add
[    3.837601] device: '31:0': device_add
[    3.838294] device: 'mtdblock0': device_add
[    3.880036] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    3.880957] OneNAND Manufacturer: Samsung (0xec)
[    3.881718] OneNAND 16MB 1.8V 16-bit (0x04)
[    3.882431] OneNAND version = 0x001e
[    3.883051] Lock scheme is Continuous Lock
[    3.883738] Scanning device for bad blocks
[    3.885076] Creating 1 MTD partitions on "OneNAND simulator":
[    3.886046] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    3.887461] device: 'mtd1': device_add
[    3.888113] device: 'mtd1ro': device_add
[    3.888978] device: '31:1': device_add
[    3.889647] device: 'mtdblock1': device_add
[    3.890399] device class 'ubi': registering
[    3.891154] device: 'ubi_ctrl': device_add
[    3.891860] bus: 'hsi': add driver hsi_char
[    3.892567] HSI/SSI char device loaded
[    3.893212] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    3.894724] device: 'eql': device_add
[    3.895433] device: 'ifb0': device_add
[    3.896107] device: 'ifb1': device_add
[    3.896974] bus: 'platform': add driver cfspi_sspi
[    3.897787] bus: 'platform': add driver cfhsi
[    3.898564] plip: parport0 has no IRQ. Using IRQ-less mode,which is fairly inefficient!
[    3.899926] device: 'plip0': device_add
[    3.900807] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    3.901744] plip0: Parallel port at 0x378, not using IRQ.
[    3.902656] PPP generic driver version 2.4.2
[    3.903441] device class 'ppp': registering
[    3.904154] device: 'ppp': device_add
[    3.904779] PPP Deflate Compression module registered
[    3.905623] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    3.906797] CSLIP: code copyright 1989 Regents of the University of California.
[    3.908019] SLIP linefill/keepalive option.
[    3.908705] hdlc: HDLC support module revision 1.22
[    3.909524] device class 'uio': registering
[    3.910254] bus: 'platform': add driver uio_pdrv_genirq
[    3.911149] bus: 'platform': add driver gpio-vbus
[    3.911947] bus: 'platform': remove driver gpio-vbus
[    3.912766] driver: 'gpio-vbus': driver_release
[    3.913532] bus: 'platform': add driver net2272
[    3.914306] bus: 'platform': add driver m66592_udc
[    3.915132] bus: 'platform': remove driver m66592_udc
[    3.915978] driver: 'm66592_udc': driver_release
[    3.916739] bus: 'platform': add driver r8a66597_udc
[    3.917569] bus: 'platform': remove driver r8a66597_udc
[    3.918456] driver: 'r8a66597_udc': driver_release
[    3.919272] bus: 'platform': add driver mv-udc
[    3.920062] Registering platform device 'i8042'. Parent at platform
[    3.921092] device: 'i8042': device_add
[    3.921723] bus: 'platform': add device i8042
[    3.922503] bus: 'platform': add driver i8042
[    3.923268] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    3.924593] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    3.926553] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.927424] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.928269] driver: 'i8042': driver_bound: bound to device 'i8042'
[    3.929313] device: 'serio0': device_add
[    3.929984] bus: 'serio': add device serio0
[    3.930734] device: 'serio1': device_add
[    3.931503] bus: 'serio': add device serio1
[    3.932242] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    4.001595] bus: 'serio': add driver atkbd
[    4.002319] bus: 'i2c': add driver synaptics_i2c
[    4.003134] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    4.004450] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    4.006001] device: 'input0': device_add
[    4.006712] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.008239] device: 'event0': device_add
[    4.008914] evbug: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    4.010472] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.011572] i2c-core: driver [synaptics_i2c] registered
[    4.012453] bus: 'i2c': add driver smbus_alert
[    4.013214] i2c-core: driver [smbus_alert] registered
[    4.014061] bus: 'platform': add driver simtec-i2c
[    4.014872] i2c-parport-light: adapter type unspecified
[    4.015757] Colour QuickCam for Video4Linux v0.06
[    4.523897] bus: 'i2c': add driver saa7706h
[    4.524635] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    4.524671] i2c-core: driver [saa7706h] registered
[    4.524674] Driver for 1-wire Dallas network protocol.
[    4.524683] bus: 'w1': registered
[    4.524685] bus: 'w1': add driver w1_master_driver
[    4.524691] bus: 'w1': add driver w1_slave_driver
[    4.524699] bus: 'platform': add driver w1-gpio
[    4.524711] bus: 'platform': remove driver w1-gpio
[    4.524714] driver: 'w1-gpio': driver_release
[    4.524742] bus: 'platform': add driver pda-power
[    4.524750] bus: 'platform': add driver wm831x-power
[    4.524758] device: 'test_ac': device_add
[    4.524788] device: 'test_battery': device_add
[    4.524833] bus: 'platform': add driver ds2780-battery
[    4.524850] bus: 'platform': add driver ds2781-battery
[    4.524858] bus: 'i2c': add driver sbs-battery
[    4.524862] i2c-core: driver [sbs-battery] using legacy suspend method
[    4.524863] i2c-core: driver [sbs-battery] registered
[    4.524865] bus: 'platform': add driver da903x-battery
[    4.524872] bus: 'i2c': add driver max17042
[    4.524876] i2c-core: driver [max17042] registered
[    4.524879] bus: 'platform': add driver isp1704_charger
[    4.524886] bus: 'platform': add driver max8903-charger
[    4.524892] bus: 'i2c': add driver lp8727
[    4.524898] i2c-core: driver [lp8727] registered
[    4.524900] bus: 'platform': add driver gpio-charger
[    4.524907] bus: 'i2c': add driver smb347
[    4.524910] i2c-core: driver [smb347] registered
[    4.525055] bus: 'i2c': add driver w83781d
[    4.525060] i2c-core: driver [w83781d] registered
[    4.525062] bus: 'i2c': add driver adm1021
[    4.525066] i2c-core: driver [adm1021] registered
[    4.525068] bus: 'i2c': add driver adm1026
[    4.525072] i2c-core: driver [adm1026] registered
[    4.525074] bus: 'i2c': add driver adm1029
[    4.525078] i2c-core: driver [adm1029] registered
[    4.525080] bus: 'i2c': add driver adm1031
[    4.525084] i2c-core: driver [adm1031] registered
[    4.525086] bus: 'i2c': add driver adm9240
[    4.525089] i2c-core: driver [adm9240] registered
[    4.525091] bus: 'i2c': add driver ads1015
[    4.525095] i2c-core: driver [ads1015] registered
[    4.525099] bus: 'i2c': add driver asc7621
[    4.525103] i2c-core: driver [asc7621] registered
[    4.525105] bus: 'i2c': add driver ds1621
[    4.525109] i2c-core: driver [ds1621] registered
[    4.525111] bus: 'i2c': add driver emc2103
[    4.525115] i2c-core: driver [emc2103] registered
[    4.525448] bus: 'i2c': add driver f75375
[    4.525454] i2c-core: driver [f75375] registered
[    4.525456] bus: 'i2c': add driver gl520sm
[    4.525466] i2c-core: driver [gl520sm] registered
[    4.525607] bus: 'i2c': add driver jc42
[    4.525612] i2c-core: driver [jc42] registered
[    4.525614] bus: 'i2c': add driver lm73
[    4.525618] i2c-core: driver [lm73] registered
[    4.525620] bus: 'i2c': add driver lm75
[    4.525624] i2c-core: driver [lm75] registered
[    4.525626] bus: 'i2c': add driver lm77
[    4.525630] i2c-core: driver [lm77] registered
[    4.525632] bus: 'i2c': add driver lm78
[    4.525636] i2c-core: driver [lm78] registered
[    4.525638] bus: 'i2c': add driver lm85
[    4.525641] i2c-core: driver [lm85] registered
[    4.525644] bus: 'i2c': add driver lm90
[    4.525647] i2c-core: driver [lm90] registered
[    4.525649] bus: 'i2c': add driver lm93
[    4.525653] i2c-core: driver [lm93] registered
[    4.525655] bus: 'i2c': add driver lm95241
[    4.525659] i2c-core: driver [lm95241] registered
[    4.525661] bus: 'i2c': add driver ltc4151
[    4.525665] i2c-core: driver [ltc4151] registered
[    4.525667] bus: 'i2c': add driver max16065
[    4.525671] i2c-core: driver [max16065] registered
[    4.525673] bus: 'i2c': add driver max1619
[    4.525677] i2c-core: driver [max1619] registered
[    4.525794] bus: 'i2c': add driver sht21
[    4.525800] i2c-core: driver [sht21] registered
[    4.525802] bus: 'i2c': add driver smsc47m192
[    4.525806] i2c-core: driver [smsc47m192] registered
[    4.525809] bus: 'platform': add driver wm831x-hwmon
[    4.525817] bus: 'platform': add driver wm8350-hwmon
[    4.525834] cpuidle: using governor ladder
[    4.525837] bus: 'platform': add driver 88pm860x-led
[    4.525844] bus: 'platform': add driver leds-gpio
[    4.525852] bus: 'i2c': add driver lp3944
[    4.525856] i2c-core: driver [lp3944] registered
[    4.525858] bus: 'i2c': add driver lp5521
[    4.525862] i2c-core: driver [lp5521] registered
[    4.525864] bus: 'platform': add driver leds-ot200
[    4.525871] bus: 'i2c': add driver leds-pca9633
[    4.525875] i2c-core: driver [leds-pca9633] registered
[    4.525878] bus: 'platform': add driver da903x-led
[    4.525885] bus: 'platform': add driver wm831x-status
[    4.525892] bus: 'platform': add driver leds-lt3593
[    4.525899] bus: 'platform': add driver max8997-led
[    4.525913] bus: 'platform': add driver dcdbas
[    4.525921] Registering platform device 'dcdbas'. Parent at platform
[    4.525922] device: 'dcdbas': device_add
[    4.525923] bus: 'platform': add device dcdbas
[    4.525980] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[    4.525983] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[    4.525985] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.525986] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[    4.525988] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[    4.525994] bus: 'i2c': add driver cptm1217
[    4.525999] i2c-core: driver [cptm1217] using legacy suspend method
[    4.525999] i2c-core: driver [cptm1217] using legacy resume method
[    4.526000] i2c-core: driver [cptm1217] registered
[    4.526002] bus: 'i2c': add driver synaptics_rmi4_i2c
[    4.526006] i2c-core: driver [synaptics_rmi4_i2c] registered
[    4.526098] device: 'binder': device_add
[    4.526253] device: 'log_main': device_add
[    4.526261] logger: created 256K log 'log_main'
[    4.526334] device: 'log_events': device_add
[    4.526341] logger: created 256K log 'log_events'
[    4.526414] device: 'log_radio': device_add
[    4.526420] logger: created 256K log 'log_radio'
[    4.526502] device: 'log_system': device_add
[    4.526509] logger: created 256K log 'log_system'
[    4.526510] Linux telephony interface: v1.00
[    4.526514] device class 'extcon': registering
[    4.526546] bus: 'platform': add driver extcon-gpio
[    4.526554] bus: 'platform': add driver max8997-muic
[    4.526612] GACT probability on
[    4.526615] Mirror/redirect action on
[    4.526617] Simple TC action Loaded
[    4.526677] TCP: bic registered
[    4.526678] TCP: cubic registered
[    4.526678] Initializing XFRM netlink socket
[    4.526731] NET: Registered protocol family 10
[    4.527065] sit: IPv6 over IPv4 tunneling driver
[    4.527082] device: 'sit0': device_add
[    4.527126] device: 'ip6tnl0': device_add
[    4.527158] l2tp_core: L2TP core driver, V2.0
[    4.527159] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.527186] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[    4.527210] NET: Registered protocol family 12
[    4.632517] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    4.633822] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.635332] atkbd: probe of serio1 rejects match -19
[    4.640088] 8021q: 802.1Q VLAN Support v1.8
[    4.640812] lib80211: common routines for IEEE802.11 drivers
[    4.641775] lib80211_crypt: registered algorithm 'NULL'
[    4.642662] lib80211_crypt: registered algorithm 'WEP'
[    4.643553] lib80211_crypt: registered algorithm 'CCMP'
[    4.644422] lib80211_crypt: registered algorithm 'TKIP'
[    4.645315] NET: Registered protocol family 37
[    4.646111] Key type dns_resolver registered
[    4.647032] batman_adv: B.A.T.M.A.N. advanced 2012.2.0 (compatibility version 14) loaded
[    4.648568] 
[    4.648568] printing PIC contents
[    4.649400] ... PIC  IMR: fffb
[    4.649949] ... PIC  IRR: 9013
[    4.650491] ... PIC  ISR: 0000
[    4.651025] ... PIC ELCR: 0c00
[    4.651545] printing local APIC contents on CPU#0/0:
[    4.652538] ... APIC ID:      00000000 (0)
[    4.653241] ... APIC VERSION: 00050014
[    4.653862] ... APIC TASKPRI: 00000000 (00)
[    4.654585] ... APIC PROCPRI: 00000000
[    4.655224] ... APIC LDR: 01000000
[    4.655795] ... APIC DFR: ffffffff
[    4.656368] ... APIC SPIV: 000001ff
[    4.656953] ... APIC ISR field:
[    4.657474] 0000000000000000000000000000000000000000000000000000000000000000
[    4.658835] ... APIC TMR field:
[    4.659380] 0000000000000000000000000000000000000000000000000000000000000000
[    4.660482] ... APIC IRR field:
[    4.660482] 0000000000000000000000000000000000000000000000000000000000008000
[    4.660482] ... APIC ESR: 00000000
[    4.660482] ... APIC ICR: 000008fd
[    4.660482] ... APIC ICR2: 02000000
[    4.660482] ... APIC LVTT: 000000ef
[    4.660482] ... APIC LVTPC: 00010000
[    4.660482] ... APIC LVT0: 00010700
[    4.660482] ... APIC LVT1: 00000400
[    4.660482] ... APIC LVTERR: 000000fe
[    4.660482] ... APIC TMICT: 000912e9
[    4.660482] ... APIC TMCCT: 00000000
[    4.660482] ... APIC TDCR: 00000003
[    4.660482] 
[    4.669463] number of MP IRQ sources: 20.
[    4.670165] number of IO-APIC #2 registers: 24.
[    4.670955] testing the IO APIC.......................
[    4.671857] 
[    4.672128] IO APIC #2......
[    4.672606] .... register #00: 00000000
[    4.673255] .......    : physical APIC id: 00
[    4.673989] .......    : Delivery Type: 0
[    4.674661] .......    : LTS          : 0
[    4.675343] .... register #01: 00170011
[    4.675992] .......     : max redirection entries: 17
[    4.676814] .......     : PRQ implemented: 0
[    4.677523] .......     : IO APIC version: 11
[    4.678257] .... register #02: 00000000
[    4.678898] .......     : arbitration: 00
[    4.679619] .... IRQ redirection table:
[    4.680305]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    4.681337]  00 00  1    0    0   0   0    0    0    00
[    4.682311]  01 03  0    0    0   0   0    1    1    31
[    4.683233]  02 03  0    0    0   0   0    1    1    30
[    4.684137]  03 03  1    0    0   0   0    1    1    33
[    4.685028]  04 03  1    0    0   0   0    1    1    34
[    4.685906]  05 03  1    0    0   0   0    1    1    35
[    4.686812]  06 03  1    0    0   0   0    1    1    36
[    4.687715]  07 03  1    0    0   0   0    1    1    37
[    4.688606]  08 03  1    0    0   0   0    1    1    38
[    4.689494]  09 03  1    1    0   0   0    1    1    29
[    4.690412]  0a 03  1    1    0   0   0    1    1    41
[    4.691323]  0b 03  1    1    0   0   0    1    1    49
[    4.692221]  0c 03  0    0    0   0   0    1    1    3C
[    4.693121]  0d 03  1    0    0   0   0    1    1    3D
[    4.694012]  0e 03  0    0    0   0   0    1    1    3E
[    4.694906]  0f 03  0    0    0   0   0    1    1    3F
[    4.695810]  10 00  1    0    0   0   0    0    0    00
[    4.696702]  11 00  1    0    0   0   0    0    0    00
[    4.697594]  12 00  1    0    0   0   0    0    0    00
[    4.698502]  13 00  1    0    0   0   0    0    0    00
[    4.699419]  14 00  1    0    0   0   0    0    0    00
[    4.700358]  15 00  1    0    0   0   0    0    0    00
[    4.701252]  16 00  1    0    0   0   0    0    0    00
[    4.702152]  17 00  1    0    0   0   0    0    0    00
[    4.703061] IRQ to pin mappings:
[    4.703605] IRQ0 -> 0:2
[    4.704070] IRQ1 -> 0:1
[    4.704520] IRQ3 -> 0:3
[    4.704981] IRQ4 -> 0:4
[    4.705428] IRQ5 -> 0:5
[    4.705878] IRQ6 -> 0:6
[    4.706345] IRQ7 -> 0:7
[    4.706805] IRQ8 -> 0:8
[    4.707274] IRQ12 -> 0:12
[    4.707756] IRQ13 -> 0:13
[    4.708243] IRQ14 -> 0:14
[    4.708719] IRQ15 -> 0:15
[    4.709209] IRQ33 -> 0:9
[    4.709719] IRQ34 -> 0:10
[    4.710238] IRQ35 -> 0:11
[    4.710726] .................................... done.
[    4.711672] device: 'cpu_dma_latency': device_add
[    4.712571] device: 'network_latency': device_add
[    4.713385] device: 'network_throughput': device_add
[    4.714232] registered taskstats version 1
[    4.715560] console [netcon0] enabled
[    4.716185] netconsole: network logging started
[    4.716926] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.717923] EDD information not available.
[    4.719360] debug: unmapping init [mem 0xffffffff81a91000-0xffffffff81cb7fff]
[    4.721102] Write protecting the kernel read-only data: 10240k
[    4.722323] debug: unmapping init [mem 0xffff88000148b000-0xffff8800015fffff]
[    4.723706] debug: unmapping init [mem 0xffff880001826000-0xffff8800019fffff]
[  379.649270] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  379.650038] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  379.650038] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  379.650038] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  379.650038] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  379.655052] SysRq : Show backtrace of all active CPUs
[  379.655903] CPU1:
[  379.656258] CPU 1 
[  379.656618] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc5-bisect-00089-gdab5369 #113 Bochs Bochs
[  379.658148] RIP: 0010:[<ffffffff81035f4b>]  [<ffffffff81035f4b>] arch_local_irq_enable+0x8/0xd
[  379.659856] RSP: 0018:ffff88000de03ee0  EFLAGS: 00000206
[  379.660942] RAX: ffff88000002eb40 RBX: 00000058657fdb00 RCX: 0000000000000020
[  379.662302] RDX: ffff88000004dfd8 RSI: 0000000000000000 RDI: ffff88000002eb40
[  379.663497] RBP: ffff88000de03ee0 R08: 0000000000000000 R09: ffffffff8104a1ad
[  379.664687] R10: ffffffff8104a1ad R11: ffff88000de0d440 R12: ffff88000de03e58
[  379.665004] R13: ffffffff814879ef R14: ffff88000de03ee0 R15: 000000000000000a
[  379.665004] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[  379.665004] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  379.665004] CR2: 00007f654bea5655 CR3: 0000000001a06000 CR4: 00000000000006a0
[  379.665004] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  379.665004] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  379.665004] Process swapper/1 (pid: 0, threadinfo ffff88000004c000, task ffff88000002eb40)
[  379.665004] Stack:
[  379.665004]  ffff88000de03f40 ffffffff81036425 ffffffff8105c383 0000000000000000
[  379.665004]  0000005865339b91 0000000100000003 0000005865339b91 0000000000000046
[  379.665004]  ffff88000004dfd8 0000000000000000 0000000000000000 0000000000000000
[  379.665004] Call Trace:
[  379.665004]  <IRQ> 
[  379.665004] 
[  379.665004]  [<ffffffff81036425>] __do_softirq+0x6e/0x140
[  379.665004]  [<ffffffff8105c383>] ? clockevents_program_event+0x9c/0xb9
[  379.665004]  [<ffffffff8148962c>] call_softirq+0x1c/0x26
[  379.665004]  [<ffffffff81003367>] do_softirq+0x45/0x9a
[  379.665004]  [<ffffffff81036747>] irq_exit+0x4c/0x81
[  379.665004]  [<ffffffff8101285e>] smp_apic_timer_interrupt+0x77/0x85
[  379.665004]  [<ffffffff81488daf>] apic_timer_interrupt+0x6f/0x80
[  379.665004]  <EOI> 
[  379.665004] 
[  379.665004]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  379.665004]  [<ffffffff8101659f>] ? native_safe_halt+0x6/0x8
[  379.665004]  [<ffffffff8105fba8>] ? trace_hardirqs_on+0xd/0xf
[  379.665004]  [<ffffffff81008230>] default_idle+0x2a/0x4a
[  379.665004]  [<ffffffff81008b0a>] cpu_idle+0xad/0xf3
[  379.665004]  [<ffffffff81478f92>] start_secondary+0x25b/0x25d
[  379.665004] Code: 9c 58 66 66 90 66 90 5d c3 55 48 89 e5 57 9d 66 66 90 66 90 5d c3 55 48 89 e5 fa 66 66 90 66 66 90 5d c3 55 48 89 e5 fb 66 66 90 <66> 66 90 5d c3 55 48 89 e5 f0 80 67 08 fd 5d c3 65 48 8b 3c 25 
[  379.665004] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  379.749271] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  379.750035] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  379.751626] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  379.753128] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  381.174244] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  381.175322] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  381.176384] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  381.177447] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  381.178565] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  381.179652] SysRq : Show backtrace of all active CPUs
[  381.180025] CPU1:
[  381.180025] CPU 1 
[  381.180025] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc5-bisect-00089-gdab5369 #113 Bochs Bochs
[  381.180025] RIP: 0010:[<ffffffff8101659f>]  [<ffffffff8101659f>] native_safe_halt+0x6/0x8
[  381.180025] RSP: 0018:ffff88000004dee8  EFLAGS: 00000202
[  381.180025] RAX: ffff88000002eb40 RBX: ffffffff81487ab0 RCX: 00000058bf812bbe
[  381.180025] RDX: 0000000000000046 RSI: 0000000000000001 RDI: ffff88000002eb40
[  381.180025] RBP: ffff88000004dee8 R08: 0000000000000002 R09: ffffffff81a17b40
[  381.180025] R10: ffffffff81a17b40 R11: ffff88000004c000 R12: ffff88000004de58
[  381.180025] R13: 0000000000000046 R14: ffff88000004c000 R15: 0000000000000001
[  381.180025] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[  381.180025] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  381.180025] CR2: 00007f654bea5655 CR3: 0000000001a06000 CR4: 00000000000006a0
[  381.180025] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  381.180025] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  381.180025] Process swapper/1 (pid: 0, threadinfo ffff88000004c000, task ffff88000002eb40)
[  381.180025] Stack:
[  381.180025]  ffff88000004def8 ffffffff81008230 ffff88000004df28 ffffffff81008b0a
[  381.180025]  ffff88000004df18 650b97e456a812c9 0000000000000000 0000000000000000
[  381.180025]  ffff88000004df48 ffffffff81478f92 0000000000000000 9f56f7e60f860088
[  381.180025] Call Trace:
[  381.180025]  [<ffffffff81008230>] default_idle+0x2a/0x4a
[  381.180025]  [<ffffffff81008b0a>] cpu_idle+0xad/0xf3
[  381.180025]  [<ffffffff81478f92>] start_secondary+0x25b/0x25d
[  381.180025] Code: 48 89 e5 0f 09 5d c3 55 48 89 e5 9c 58 5d c3 55 48 89 e5 57 9d 5d c3 55 48 89 e5 fa 5d c3 55 48 89 e5 fb 5d c3 55 48 89 e5 fb f4 <5d> c3 55 48 89 e5 f4 5d c3 55 8b 07 49 89 ca 49 89 d1 48 89 e5 
[  381.180025] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  381.274308] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  381.275412] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  381.276447] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  381.277486] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  382.262042] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  382.263112] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  382.264154] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  382.265973] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  382.268864] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  382.271565] SysRq : Show backtrace of all active CPUs
[  382.274025] CPU1:
[  382.274869] CPU 1 
[  382.275830] Pid: 0, comm: swapper/1 Not tainted 3.5.0-rc5-bisect-00089-gdab5369 #113 Bochs Bochs
[  382.279558] RIP: 0010:[<ffffffff81035f4b>]  [<ffffffff81035f4b>] arch_local_irq_enable+0x8/0xd
[  382.281474] RSP: 0018:ffff88000de03ee0  EFLAGS: 00000202
[  382.281474] RAX: ffff88000002eb40 RBX: 0000005901a9e200 RCX: 0000000000000020
[  382.281474] RDX: ffff88000004dfd8 RSI: 0000000000000000 RDI: ffff88000002eb40
[  382.281474] RBP: ffff88000de03ee0 R08: 0000000000000000 R09: ffffffff8104a1ad
[  382.281474] R10: ffffffff8104a1ad R11: ffff88000de0d440 R12: ffff88000de03e58
[  382.281474] R13: ffffffff814879ef R14: ffff88000de03ee0 R15: 000000000000000a
[  382.281474] FS:  0000000000000000(0000) GS:ffff88000de00000(0000) knlGS:0000000000000000
[  382.281474] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  382.281474] CR2: 00007f654bea5655 CR3: 0000000001a06000 CR4: 00000000000006a0
[  382.281474] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  382.281474] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  382.281474] Process swapper/1 (pid: 0, threadinfo ffff88000004c000, task ffff88000002eb40)
[  382.281474] Stack:
[  382.281474]  ffff88000de03f40 ffffffff81036425 ffffffff8105c383 0000000000000000
[  382.281474]  000000590127b620 0000000100000003 000000590127b620 0000000000000046
[  382.281474]  ffff88000004dfd8 0000000000000000 0000000000000000 0000000000000000
[  382.281474] Call Trace:
[  382.281474]  <IRQ> 
[  382.281474] 
[  382.281474]  [<ffffffff81036425>] __do_softirq+0x6e/0x140
[  382.281474]  [<ffffffff8105c383>] ? clockevents_program_event+0x9c/0xb9
[  382.281474]  [<ffffffff8148962c>] call_softirq+0x1c/0x26
[  382.281474]  [<ffffffff81003367>] do_softirq+0x45/0x9a
[  382.281474]  [<ffffffff81036747>] irq_exit+0x4c/0x81
[  382.281474]  [<ffffffff8101285e>] smp_apic_timer_interrupt+0x77/0x85
[  382.281474]  [<ffffffff81488daf>] apic_timer_interrupt+0x6f/0x80
[  382.281474]  <EOI> 
[  382.281474] 
[  382.281474]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  382.281474]  [<ffffffff8101659f>] ? native_safe_halt+0x6/0x8
[  382.281474]  [<ffffffff8105fba8>] ? trace_hardirqs_on+0xd/0xf
[  382.281474]  [<ffffffff81008230>] default_idle+0x2a/0x4a
[  382.281474]  [<ffffffff81008b0a>] cpu_idle+0xad/0xf3
[  382.281474]  [<ffffffff81478f92>] start_secondary+0x25b/0x25d
[  382.281474] Code: 9c 58 66 66 90 66 90 5d c3 55 48 89 e5 57 9d 66 66 90 66 90 5d c3 55 48 89 e5 fa 66 66 90 66 66 90 5d c3 55 48 89 e5 fb 66 66 90 <66> 66 90 5d c3 55 48 89 e5 f0 80 67 08 fd 5d c3 65 48 8b 3c 25 
[  382.281474] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  382.362096] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  382.363199] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  382.364360] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  382.365449] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  385.690608] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  385.692017] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  385.693094] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  385.694184] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  385.695246] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  385.696378] SysRq : Show State
[  385.697038]   task                        PC stack   pid father
[  385.698029] init            S 0000000000000000     0     1      0 0x00000000
[  385.699228]  ffff88000001dcd8 0000000000000046 ffff880000028000 ffff88000001dfd8
[  385.700037]  00000000001d0b80 ffff88000001dfd8 ffff88000002eb40 ffff880000028000
[  385.700037]  ffff8800000285a0 ffff88000ccf9e40 ffff88000915d280 ffff88000001df60
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff810b4856>] pipe_wait+0x5c/0x77
[  385.700037]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  385.700037]  [<ffffffff810b4fe5>] pipe_read+0x330/0x3ad
[  385.700037]  [<ffffffff8103a555>] ? spin_unlock_irq+0x9/0xb
[  385.700037]  [<ffffffff810163b3>] ? kvm_clock_read+0x2e/0x35
[  385.700037]  [<ffffffff810acc92>] ? wait_on_retry_sync_kiocb+0x4e/0x4e
[  385.700037]  [<ffffffff810acd55>] do_sync_read+0xc3/0xfe
[  385.700037]  [<ffffffff810609d1>] ? lock_is_held+0x8a/0x9c
[  385.700037]  [<ffffffff810ae192>] ? fcheck_files+0xa7/0xe9
[  385.700037]  [<ffffffff810ad461>] vfs_read+0x93/0xf6
[  385.700037]  [<ffffffff810ae848>] ? fget_light+0x33/0x9b
[  385.700037]  [<ffffffff810ad6fd>] sys_read+0x41/0x71
[  385.700037]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  385.700037] kthreadd        S 0000000000000000     0     2      0 0x00000000
[  385.700037]  ffff88000001fef0 0000000000000046 ffff8800000291e0 ffff88000001ffd8
[  385.700037]  00000000001d0b80 ffff88000001ffd8 ffff880000028000 ffff8800000291e0
[  385.700037]  ffff8800000291e0 ffffffff81a17f20 ffff8800000291e0 ffff88000001dd28
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81046e8c>] kthreadd+0x75/0xf7
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046e17>] ? kthread_stop+0x57/0x57
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] ksoftirqd/0     S ffff880000041fd8     0     3      2 0x00000000
[  385.700037]  ffff880000041df0 0000000000000046 ffff88000002a3c0 ffff880000041fd8
[  385.700037]  00000000001d0b80 ffff880000041fd8 ffff880000028000 ffff88000002a3c0
[  385.700037]  ffff880000041df0 ffff880000040000 0000000000000000 ffff880000041fd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff814862be>] schedule_preempt_disabled+0x1f/0x27
[  385.700037]  [<ffffffff81036556>] run_ksoftirqd+0x5f/0x193
[  385.700037]  [<ffffffff810364f7>] ? __do_softirq+0x140/0x140
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kworker/0:0     S ffff880000095320     0     4      2 0x00000000
[  385.700037]  ffff880000045e40 0000000000000046 ffff88000002b5a0 ffff880000045fd8
[  385.700037]  00000000001d0b80 ffff880000045fd8 ffff88000007a3c0 ffff88000002b5a0
[  385.700037]  ffff880000045e20 ffff880000095300 ffff88000dc0d000 ffff88000002b5a0
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kworker/u:0     S ffff8800000954a0     0     5      2 0x00000000
[  385.700037]  ffff880000049e40 0000000000000046 ffff88000002c780 ffff880000049fd8
[  385.700037]  00000000001d0b80 ffff880000049fd8 ffff880000028000 ffff88000002c780
[  385.700037]  ffff880000049e20 ffff880000095480 ffffffff81d0f540 ffff88000002c780
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] migration/0     S 0000000000000000     0     6      2 0x00000000
[  385.700037]  ffff88000004bd90 0000000000000046 ffff88000002d960 ffff88000004bfd8
[  385.700037]  00000000001d0b80 ffff88000004bfd8 ffffffff81a0e3f0 ffff88000002d960
[  385.700037]  ffff88000ddcd6a0 ffff88000002d960 ffff88000ddcd6a0 ffff88000004bfd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81066feb>] cpu_stopper_thread+0x186/0x1a2
[  385.700037]  [<ffffffff8104f16a>] ? __migrate_task+0xf8/0xf8
[  385.700037]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  385.700037]  [<ffffffff81066e65>] ? cpumask_weight+0x14/0x14
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] migration/1     S 0000000000000000     0     7      2 0x00000000
[  385.700037]  ffff88000004fd90 0000000000000046 ffff880000050000 ffff88000004ffd8
[  385.700037]  00000000001d0b80 ffff88000004ffd8 ffff88000002eb40 ffff880000050000
[  385.700037]  ffff88000dfcd6a0 ffff880000050000 ffff88000dfcd6a0 ffff88000004ffd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81066feb>] cpu_stopper_thread+0x186/0x1a2
[  385.700037]  [<ffffffff8104f16a>] ? __migrate_task+0xf8/0xf8
[  385.700037]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  385.700037]  [<ffffffff81066e65>] ? cpumask_weight+0x14/0x14
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] ksoftirqd/1     S ffff88000005bfd8     0     9      2 0x00000000
[  385.700037]  ffff88000005bdf0 0000000000000046 ffff8800000523c0 ffff88000005bfd8
[  385.700037]  00000000001d0b80 ffff88000005bfd8 ffff88000002eb40 ffff8800000523c0
[  385.700037]  ffff88000005bdf0 ffff88000005a000 0000000000000001 ffff88000005bfd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff814862be>] schedule_preempt_disabled+0x1f/0x27
[  385.700037]  [<ffffffff81036556>] run_ksoftirqd+0x5f/0x193
[  385.700037]  [<ffffffff810364f7>] ? __do_softirq+0x140/0x140
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] khelper         S ffff880000097700     0    10      2 0x00000000
[  385.700037]  ffff880000061e00 0000000000000046 ffff8800000535a0 ffff880000061fd8
[  385.700037]  00000000001d0b80 ffff880000061fd8 ffff88000002eb40 ffff8800000535a0
[  385.700037]  ffff880000061e10 ffff8800000535a0 ffff880000095c00 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] sync_supers     S 0000000000000000     0    11      2 0x00000000
[  385.700037]  ffff880000063e50 0000000000000046 ffff880000054780 ffff880000063fd8
[  385.700037]  00000000001d0b80 ffff880000063fd8 ffffffff81a0e3f0 ffff880000054780
[  385.700037]  0000000000000000 ffff880000054780 0000000000000000 ffffffff81093d1d
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff81093d1d>] ? bdi_sched_wait+0xd/0xd
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81093d57>] bdi_sync_supers+0x3a/0x51
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] bdi-default     S ffffffff81a1b900     0    12      2 0x00000000
[  385.700037]  ffff880000069d80 0000000000000046 ffff880000055960 ffff880000069fd8
[  385.700037]  00000000001d0b80 ffff880000069fd8 ffff88000002eb40 ffff880000055960
[  385.700037]  ffff880000069d80 0000000100007545 ffff880000055960 0000000000000000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81487038>] ? _raw_spin_unlock_bh+0x3c/0x41
[  385.700037]  [<ffffffff810940fa>] ? bdi_forker_thread+0x139/0x2ea
[  385.700037]  [<ffffffff810942a6>] bdi_forker_thread+0x2e5/0x2ea
[  385.700037]  [<ffffffff81093fc1>] ? wb_has_dirty_io+0x3f/0x3f
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kintegrityd     S ffff880000097d00     0    13      2 0x00000000
[  385.700037]  ffff88000006be00 0000000000000046 ffff880000056b40 ffff88000006bfd8
[  385.700037]  00000000001d0b80 ffff88000006bfd8 ffff88000002eb40 ffff880000056b40
[  385.700037]  ffff88000006be10 ffff880000056b40 ffff880000012840 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kblockd         S ffff880000097f00     0    14      2 0x00000000
[  385.700037]  ffff880000101e00 0000000000000046 ffff880000078000 ffff880000101fd8
[  385.700037]  00000000001d0b80 ffff880000101fd8 ffff88000002eb40 ffff880000078000
[  385.700037]  ffff880000101e10 ffff880000078000 ffff8800000129c0 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kworker/1:1     S ffff88000ccf9020     0    15      2 0x00000000
[  385.700037]  ffff880000129e40 0000000000000046 ffff8800000791e0 ffff880000129fd8
[  385.700037]  00000000001d0b80 ffff880000129fd8 ffff8800069e23c0 ffff8800000791e0
[  385.700037]  ffff880000129e20 ffff88000ccf9000 ffff88000de0d000 ffff8800000791e0
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kworker/0:1     S ffff88000010a020     0    16      2 0x00000000
[  385.700037]  ffff880009215e40 0000000000000046 ffff88000007a3c0 ffff880009215fd8
[  385.700037]  00000000001d0b80 ffff880009215fd8 ffff8800068d11e0 ffff88000007a3c0
[  385.700037]  ffff880009215e20 ffff88000010a000 ffff88000dc0d000 ffff88000007a3c0
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] khungtaskd      S 00000000003fffd2     0    18      2 0x00000000
[  385.700037]  ffff8800068c5d80 0000000000000046 ffff88000007c780 ffff8800068c5fd8
[  385.700037]  00000000001d0b80 ffff8800068c5fd8 ffff88000002eb40 ffff88000007c780
[  385.700037]  ffff8800068c5d80 00000001000046bc ffff8800069ab5a0 0000000000000078
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81071366>] watchdog+0x42/0x232
[  385.700037]  [<ffffffff81071324>] ? rcu_read_lock+0x79/0x79
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_wri S 0000000000000000     0    19      2 0x00000000
[  385.700037]  ffff8800068c7d90 0000000000000046 ffff88000007d960 ffff8800068c7fd8
[  385.700037]  00000000001d0b80 ffff8800068c7fd8 ffff8800068d23c0 ffff88000007d960
[  385.700037]  ffff8800068c7d90 0000000100002199 0000000000000000 ffff88000007d960
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81077a2f>] rcu_torture_writer+0x1a1/0x201
[  385.700037]  [<ffffffff8107788e>] ? srcu_read_lock_held.constprop.28+0x38/0x38
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_fak S 0000000000000000     0    20      2 0x00000000
[  385.700037]  ffff8800068c9da0 0000000000000046 ffff88000007eb40 ffff8800068c9fd8
[  385.700037]  00000000001d0b80 ffff8800068c9fd8 ffff8800068d0000 ffff88000007eb40
[  385.700037]  ffff8800068c9da0 0000000100002199 0000000000000000 ffffffff81076400
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_fak S 0000000000000000     0    21      2 0x00000000
[  385.700037]  ffff8800068cbda0 0000000000000046 ffff8800068d0000 ffff8800068cbfd8
[  385.700037]  00000000001d0b80 ffff8800068cbfd8 ffff88000007d960 ffff8800068d0000
[  385.700037]  ffff8800068cbda0 0000000100002199 0000000000000000 ffffffff81076400
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_fak S 0000000000000000     0    22      2 0x00000000
[  385.700037]  ffff8800068cdda0 0000000000000046 ffff8800068d11e0 ffff8800068cdfd8
[  385.700037]  00000000001d0b80 ffff8800068cdfd8 ffffffff81a0e3f0 ffff8800068d11e0
[  385.700037]  ffff8800068cdda0 000000010000219c 0000000000000000 ffffffff81076400
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_fak S 0000000000000000     0    23      2 0x00000000
[  385.700037]  ffff8800068cfda0 0000000000000046 ffff8800068d23c0 ffff8800068cffd8
[  385.700037]  00000000001d0b80 ffff8800068cffd8 ffff88000002eb40 ffff8800068d23c0
[  385.700037]  ffff8800068cfda0 0000000100002199 0000000000000000 ffffffff81076400
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_rea S 00000000ffffff0a     0    24      2 0x00000000
[  385.700037]  ffff8800068d9d00 0000000000000046 ffff8800068d35a0 ffff8800068d9fd8
[  385.700037]  00000000001d0b80 ffff8800068d9fd8 ffff8800068d4780 ffff8800068d35a0
[  385.700037]  ffff8800068d9d00 0000000100002199 ffff8800068d9fd8 ffff8800068d9fd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  385.700037]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_rea S 00000000ffffff0a     0    25      2 0x00000000
[  385.700037]  ffff8800068dbd00 0000000000000046 ffff8800068d4780 ffff8800068dbfd8
[  385.700037]  00000000001d0b80 ffff8800068dbfd8 ffff8800068d5960 ffff8800068d4780
[  385.700037]  ffff8800068dbd00 0000000100002199 ffff8800068dbfd8 ffff8800068dbfd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  385.700037]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_rea S 00000000ffffff0a     0    26      2 0x00000000
[  385.700037]  ffff8800068ddd00 0000000000000046 ffff8800068d5960 ffff8800068ddfd8
[  385.700037]  00000000001d0b80 ffff8800068ddfd8 ffff88000007eb40 ffff8800068d5960
[  385.700037]  ffff8800068ddd00 0000000100002199 ffff8800068ddfd8 ffff8800068ddfd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  385.700037]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_rea S 00000000ffffff0a     0    27      2 0x00000000
[  385.700037]  ffff8800068dfd00 0000000000000046 ffff8800068d6b40 ffff8800068dffd8
[  385.700037]  00000000001d0b80 ffff8800068dffd8 ffff8800068d35a0 ffff8800068d6b40
[  385.700037]  ffff8800068dfd00 0000000100002199 ffff8800068dffd8 ffff8800068dffd8
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  385.700037]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  385.700037]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rcu_torture_stu S 0000000000000000     0    28      2 0x00000000
[  385.700037]  ffff8800068e5dd0 0000000000000046 ffff8800068e8000 ffff8800068e5fd8
[  385.700037]  00000000001d0b80 ffff8800068e5fd8 ffff88000002eb40 ffff8800068e8000
[  385.700037]  ffff8800068e5dd0 00000001000021a5 0000000000000000 ffffffff810766e9
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff810766e9>] ? rcutorture_cpu_notify+0x3a/0x3a
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  385.700037]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  385.700037]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  385.700037]  [<ffffffff8107671a>] rcu_torture_stutter+0x31/0x94
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kswapd0         S 0000000000000000     0    29      2 0x00000000
[  385.700037]  ffff8800068e7d70 0000000000000046 ffff8800068e91e0 ffff8800068e7fd8
[  385.700037]  00000000001d0b80 ffff8800068e7fd8 ffff88000002eb40 ffff8800068e91e0
[  385.700037]  ffff880000000000 ffffffff81a769c0 0000000000000000 0000000000000000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff8109283e>] kswapd+0x1ca/0x6ae
[  385.700037]  [<ffffffff8105fba8>] ? trace_hardirqs_on+0xd/0xf
[  385.700037]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  385.700037]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  385.700037]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  385.700037]  [<ffffffff81092674>] ? try_to_free_pages+0x2f8/0x2f8
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] ksmd            S 0000000000000000     0    30      2 0x00000000
[  385.700037]  ffff8800068f5e20 0000000000000046 ffff8800068ea3c0 ffff8800068f5fd8
[  385.700037]  00000000001d0b80 ffff8800068f5fd8 ffff88000002eb40 ffff8800068ea3c0
[  385.700037]  ffff8800068f5e30 ffff8800068f5e48 ffff8800068ea3c0 ffff8800068f5e60
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff810a9838>] ksm_scan_thread+0xdd/0x10a
[  385.700037]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  385.700037]  [<ffffffff810a975b>] ? ksm_do_scan+0x899/0x899
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] fsnotify_mark   S ffff8800068f7e28     0    31      2 0x00000000
[  385.700037]  ffff8800068f7df0 0000000000000046 ffff8800068eb5a0 ffff8800068f7fd8
[  385.700037]  00000000001d0b80 ffff8800068f7fd8 ffff88000002eb40 ffff8800068eb5a0
[  385.700037]  ffff8800068f7e00 ffff8800068f7e38 ffff8800068eb5a0 ffff8800068f7e50
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff810db95d>] fsnotify_mark_destroy+0x152/0x168
[  385.700037]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  385.700037]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  385.700037]  [<ffffffff810db80b>] ? fsnotify_put_mark+0x1a/0x1a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] xfsalloc        S ffff8800068c2700     0    32      2 0x00000000
[  385.700037]  ffff88000695fe00 0000000000000046 ffff8800068ec780 ffff88000695ffd8
[  385.700037]  00000000001d0b80 ffff88000695ffd8 ffff88000002eb40 ffff8800068ec780
[  385.700037]  ffff88000695fe10 ffff8800068ec780 ffff8800068bf6c0 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] xfs_mru_cache   S ffff8800068c2900     0    33      2 0x00000000
[  385.700037]  ffff880006961e00 0000000000000046 ffff8800068ed960 ffff880006961fd8
[  385.700037]  00000000001d0b80 ffff880006961fd8 ffff88000002eb40 ffff8800068ed960
[  385.700037]  ffff880006961e10 ffff8800068ed960 ffff8800068bf840 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] xfslogd         S ffff8800068c2b00     0    34      2 0x00000000
[  385.700037]  ffff880006963e00 0000000000000046 ffff8800068eeb40 ffff880006963fd8
[  385.700037]  00000000001d0b80 ffff880006963fd8 ffff88000002eb40 ffff8800068eeb40
[  385.700037]  ffff880006963e10 ffff8800068eeb40 ffff8800068bf9c0 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] crypto          S ffff8800068c2d00     0    35      2 0x00000000
[  385.700037]  ffff880006965e00 0000000000000046 ffff880006968000 ffff880006965fd8
[  385.700037]  00000000001d0b80 ffff880006965fd8 ffff88000002eb40 ffff880006968000
[  385.700037]  ffff880006965e10 ffff880006968000 ffff8800068bfb40 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] mtdblock0       S 0000000000000000     0    71      2 0x00000000
[  385.700037]  ffff8800065cde00 0000000000000046 ffff8800069e5960 ffff8800065cdfd8
[  385.700037]  00000000001d0b80 ffff8800065cdfd8 ffffffff81a0e3f0 ffff8800069e5960
[  385.700037]  ffff8800069bd508 0000000000000000 ffff8800069bd400 ffff8800065d0000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff812bedcb>] mtd_blktrans_thread+0x10d/0x2e4
[  385.700037]  [<ffffffff812becbe>] ? blktrans_open+0xec/0xec
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] mtdblock1       S 0000000000000000     0    72      2 0x00000000
[  385.700037]  ffff88000567de00 0000000000000046 ffff8800069e4780 ffff88000567dfd8
[  385.700037]  00000000001d0b80 ffff88000567dfd8 ffffffff81a0e3f0 ffff8800069e4780
[  385.700037]  ffff8800069bf108 0000000000000000 ffff8800069bf000 ffff8800065d0b30
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff812bedcb>] mtd_blktrans_thread+0x10d/0x2e4
[  385.700037]  [<ffffffff812becbe>] ? blktrans_open+0xec/0xec
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] binder          S ffff8800069d0700     0    73      2 0x00000000
[  385.700037]  ffff880005685e00 0000000000000046 ffff8800069e35a0 ffff880005685fd8
[  385.700037]  00000000001d0b80 ffff880005685fd8 ffffffff81a0e3f0 ffff8800069e35a0
[  385.700037]  ffff880005685e10 ffff8800069e35a0 ffff88000695d000 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kworker/1:2     S ffff88000ccf96e0     0    74      2 0x00000000
[  385.700037]  ffff8800057a3e40 0000000000000046 ffff8800069e23c0 ffff8800057a3fd8
[  385.700037]  00000000001d0b80 ffff8800057a3fd8 ffff88000002eb40 ffff8800069e23c0
[  385.700037]  ffff8800057a3e20 ffff88000ccf96c0 ffff88000de0d000 ffff8800069e23c0
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] bat_events      S ffff8800057a1500     0    75      2 0x00000000
[  385.700037]  ffff8800057a9e00 0000000000000046 ffff8800069e11e0 ffff8800057a9fd8
[  385.700037]  00000000001d0b80 ffff8800057a9fd8 ffff88000002eb40 ffff8800069e11e0
[  385.700037]  ffff8800057a9e10 ffff8800069e11e0 ffff88000695d3c0 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] deferwq         S ffff8800057a1d00     0    76      2 0x00000000
[  385.700037]  ffff8800057ffe00 0000000000000046 ffff8800069e0000 ffff8800057fffd8
[  385.700037]  00000000001d0b80 ffff8800057fffd8 ffff88000002eb40 ffff8800069e0000
[  385.700037]  ffff8800057ffe10 ffff8800069e0000 ffff8800057860c0 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] kworker/u:1     S 0000000000000000     0    77      2 0x00000000
[  385.700037]  ffff880005001e40 0000000000000046 ffff8800069e6b40 ffff880005001fd8
[  385.700037]  00000000001d0b80 ffff880005001fd8 ffff88000002eb40 ffff8800069e6b40
[  385.700037]  ffff880005001e20 ffff880005786240 ffffffff81d0f540 ffff8800069e6b40
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] devfreq_wq      S ffff880005002100     0    78      2 0x00000000
[  385.700037]  ffff880005005e00 0000000000000046 ffff8800069aeb40 ffff880005005fd8
[  385.700037]  00000000001d0b80 ffff880005005fd8 ffff88000002eb40 ffff8800069aeb40
[  385.700037]  ffff880005005e10 ffff8800069aeb40 ffff8800057863c0 0000000000000008
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  385.700037]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  385.700037]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  385.700037]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  385.700037]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  385.700037]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  385.700037]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  385.700037]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  385.700037] rc.local        S ffff8800069c6b30     0    79      1 0x00000000
[  385.700037]  ffff880005049e58 0000000000000046 ffff8800069c6b40 ffff880005049fd8
[  385.700037]  00000000001d0b80 ffff880005049fd8 ffff88000002eb40 ffff8800069c6b40
[  385.700037]  ffff8800069c6b40 ffff880005049f00 ffff8800069c6b40 ffff8800069c6b40
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff8103417e>] do_wait+0x189/0x1fc
[  385.700037]  [<ffffffff81035216>] sys_wait4+0x91/0xbd
[  385.700037]  [<ffffffff814882a5>] ? sysret_check+0x22/0x5d
[  385.700037]  [<ffffffff81033039>] ? kill_orphaned_pgrp+0xce/0xce
[  385.700037]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  385.700037] hostname        x ffff8800069c4770     0    81      1 0x00000002
[  385.700037]  ffff880005085ea8 0000000000000046 ffff8800069c4780 ffff880005085fd8
[  385.700037]  00000000001d0b80 ffff880005085fd8 ffff880000028000 ffff8800069c4780
[  385.700037]  ffffffff81a04080 ffff8800069c4780 0000000000000000 ffff880000028000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81034eda>] do_exit+0x6e3/0x6ef
[  385.700037]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  385.700037]  [<ffffffff81034f89>] do_group_exit+0x76/0xb5
[  385.700037]  [<ffffffff81034fda>] sys_exit_group+0x12/0x12
[  385.700037]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  385.700037] sh              t ffff8800069c35a0     0    82      1 0x00000002
[  385.700037]  ffff8800050a5d58 0000000000000046 ffff8800069c35a0 ffff8800050a5fd8
[  385.700037]  00000000001d0b80 ffff8800050a5fd8 ffff880000028000 ffff8800069c35a0
[  385.700037]  0000000000040004 ffff8800050a4000 0000000000040004 0000000000000000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff8103bc29>] ptrace_stop+0x153/0x20b
[  385.700037]  [<ffffffff8103cdbd>] get_signal_to_deliver+0x24a/0x4b3
[  385.700037]  [<ffffffff810015e7>] do_signal+0x2f/0x43c
[  385.700037]  [<ffffffff810ab13c>] ? kfree+0x84/0x88
[  385.700037]  [<ffffffff810aab27>] ? kmem_cache_free+0x6a/0x6f
[  385.700037]  [<ffffffff8148855b>] ? int_very_careful+0x5/0xd
[  385.700037]  [<ffffffff81001a30>] do_notify_resume+0x28/0x5a
[  385.700037]  [<ffffffff814885b2>] int_signal+0x12/0x17
[  385.700037] shutdown        S 0000000000000000     0    92     79 0x00000000
[  385.700037]  ffff88000500fa68 0000000000000046 ffff88000696c780 ffff88000500ffd8
[  385.700037]  00000000001d0b80 ffff88000500ffd8 ffffffff81a0e3f0 ffff88000696c780
[  385.700037]  ffff8800057fce80 0000000000000000 0000000000000000 0000000000000000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff814858db>] schedule_hrtimeout_range_clock+0x37/0xe1
[  385.700037]  [<ffffffff810472f2>] ? add_wait_queue+0x3f/0x44
[  385.700037]  [<ffffffff810bc541>] ? __pollwait+0xc0/0xc9
[  385.700037]  [<ffffffff81485993>] schedule_hrtimeout_range+0xe/0x10
[  385.700037]  [<ffffffff810bc939>] poll_schedule_timeout+0x3e/0x61
[  385.700037]  [<ffffffff810bd76d>] do_sys_poll+0x2ed/0x388
[  385.700037]  [<ffffffff8100774f>] ? sched_clock+0x9/0xb
[  385.700037]  [<ffffffff810524ba>] ? sched_clock_local+0x12/0x75
[  385.700037]  [<ffffffff81052641>] ? sched_clock_cpu+0xbd/0xcf
[  385.700037]  [<ffffffff8105fcd2>] ? trace_hardirqs_off+0xd/0xf
[  385.700037]  [<ffffffff81052780>] ? local_clock+0x3b/0x53
[  385.700037]  [<ffffffff8105e39c>] ? lock_release_holdtime.part.25+0x4e/0x55
[  385.700037]  [<ffffffff81061e33>] ? lock_release+0x189/0x1c3
[  385.700037]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  385.700037]  [<ffffffff810bc620>] ? rcu_read_lock_held+0x38/0x38
[  385.700037]  [<ffffffff8100748a>] ? paravirt_sched_clock+0x9/0xd
[  385.700037]  [<ffffffff8100774f>] ? sched_clock+0x9/0xb
[  385.700037]  [<ffffffff810524ba>] ? sched_clock_local+0x12/0x75
[  385.700037]  [<ffffffff81052641>] ? sched_clock_cpu+0xbd/0xcf
[  385.700037]  [<ffffffff8105fcd2>] ? trace_hardirqs_off+0xd/0xf
[  385.700037]  [<ffffffff81052780>] ? local_clock+0x3b/0x53
[  385.700037]  [<ffffffff8105e39c>] ? lock_release_holdtime.part.25+0x4e/0x55
[  385.700037]  [<ffffffff81061e33>] ? lock_release+0x189/0x1c3
[  385.700037]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  385.700037]  [<ffffffff8104ad91>] ? up_read+0x1c/0x34
[  385.700037]  [<ffffffff81017e70>] ? do_page_fault+0x2e8/0x36c
[  385.700037]  [<ffffffff813813bc>] ? sys_sendto+0x12f/0x15c
[  385.700037]  [<ffffffff8105fc4c>] ? trace_hardirqs_off_caller+0xa2/0x11b
[  385.700037]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  385.700037]  [<ffffffff810bd89f>] sys_poll+0x4a/0xb3
[  385.700037]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  385.700037]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  385.700037] shutdown        x ffff8800069ab590     0    93     92 0x00000002
[  385.700037]  ffff880005075ea8 0000000000000046 ffff8800069ab5a0 ffff880005075fd8
[  385.700037]  00000000001d0b80 ffff880005075fd8 ffff88000002eb40 ffff8800069ab5a0
[  385.700037]  ffffffff81a04080 ffff8800069ab5a0 0000000000000000 ffff880000028000
[  385.700037] Call Trace:
[  385.700037]  [<ffffffff8148629d>] schedule+0x60/0x62
[  385.700037]  [<ffffffff81034eda>] do_exit+0x6e3/0x6ef
[  385.700037]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  385.700037]  [<ffffffff81034f89>] do_group_exit+0x76/0xb5
[  385.700037]  [<ffffffff81034fda>] sys_exit_group+0x12/0x12
[  385.700037]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  385.700037] 
[  385.700037] Showing all locks held in the system:
[  385.700037] 
[  385.700037] =============================================
[  385.700037] 
[  385.700037] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  385.700037] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  386.465803] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  386.466856] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  386.467904] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  397.059414] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  397.060095] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  397.060095] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  397.060095] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  397.060095] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  397.066860] SysRq : Show State
[  397.067478]   task                        PC stack   pid father
[  397.068474] init            S 0000000000000000     0     1      0 0x00000000
[  397.069638]  ffff88000001dcd8 0000000000000046 ffff880000028000 ffff88000001dfd8
[  397.070943]  00000000001d0b80 ffff88000001dfd8 ffff88000002eb40 ffff880000028000
[  397.072225]  ffff8800000285a0 ffff88000ccf9e40 ffff88000915d280 ffff88000001df60
[  397.073506] Call Trace:
[  397.073902]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.074691]  [<ffffffff810b4856>] pipe_wait+0x5c/0x77
[  397.075518]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  397.076509]  [<ffffffff810b4fe5>] pipe_read+0x330/0x3ad
[  397.076830]  [<ffffffff8103a555>] ? spin_unlock_irq+0x9/0xb
[  397.076830]  [<ffffffff810163b3>] ? kvm_clock_read+0x2e/0x35
[  397.076830]  [<ffffffff810acc92>] ? wait_on_retry_sync_kiocb+0x4e/0x4e
[  397.076830]  [<ffffffff810acd55>] do_sync_read+0xc3/0xfe
[  397.076830]  [<ffffffff810609d1>] ? lock_is_held+0x8a/0x9c
[  397.076830]  [<ffffffff810ae192>] ? fcheck_files+0xa7/0xe9
[  397.076830]  [<ffffffff810ad461>] vfs_read+0x93/0xf6
[  397.076830]  [<ffffffff810ae848>] ? fget_light+0x33/0x9b
[  397.076830]  [<ffffffff810ad6fd>] sys_read+0x41/0x71
[  397.076830]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  397.076830] kthreadd        S 0000000000000000     0     2      0 0x00000000
[  397.076830]  ffff88000001fef0 0000000000000046 ffff8800000291e0 ffff88000001ffd8
[  397.076830]  00000000001d0b80 ffff88000001ffd8 ffff880000028000 ffff8800000291e0
[  397.076830]  ffff8800000291e0 ffffffff81a17f20 ffff8800000291e0 ffff88000001dd28
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81046e8c>] kthreadd+0x75/0xf7
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046e17>] ? kthread_stop+0x57/0x57
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] ksoftirqd/0     S ffff880000041fd8     0     3      2 0x00000000
[  397.076830]  ffff880000041df0 0000000000000046 ffff88000002a3c0 ffff880000041fd8
[  397.076830]  00000000001d0b80 ffff880000041fd8 ffff880000028000 ffff88000002a3c0
[  397.076830]  ffff880000041df0 ffff880000040000 0000000000000000 ffff880000041fd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff814862be>] schedule_preempt_disabled+0x1f/0x27
[  397.076830]  [<ffffffff81036556>] run_ksoftirqd+0x5f/0x193
[  397.076830]  [<ffffffff810364f7>] ? __do_softirq+0x140/0x140
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kworker/0:0     S ffff880000095320     0     4      2 0x00000000
[  397.076830]  ffff880000045e40 0000000000000046 ffff88000002b5a0 ffff880000045fd8
[  397.076830]  00000000001d0b80 ffff880000045fd8 ffff88000007a3c0 ffff88000002b5a0
[  397.076830]  ffff880000045e20 ffff880000095300 ffff88000dc0d000 ffff88000002b5a0
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kworker/u:0     S ffff8800000954a0     0     5      2 0x00000000
[  397.076830]  ffff880000049e40 0000000000000046 ffff88000002c780 ffff880000049fd8
[  397.076830]  00000000001d0b80 ffff880000049fd8 ffff880000028000 ffff88000002c780
[  397.076830]  ffff880000049e20 ffff880000095480 ffffffff81d0f540 ffff88000002c780
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] migration/0     S 0000000000000000     0     6      2 0x00000000
[  397.076830]  ffff88000004bd90 0000000000000046 ffff88000002d960 ffff88000004bfd8
[  397.076830]  00000000001d0b80 ffff88000004bfd8 ffffffff81a0e3f0 ffff88000002d960
[  397.076830]  ffff88000ddcd6a0 ffff88000002d960 ffff88000ddcd6a0 ffff88000004bfd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81066feb>] cpu_stopper_thread+0x186/0x1a2
[  397.076830]  [<ffffffff8104f16a>] ? __migrate_task+0xf8/0xf8
[  397.076830]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  397.076830]  [<ffffffff81066e65>] ? cpumask_weight+0x14/0x14
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] migration/1     S 0000000000000000     0     7      2 0x00000000
[  397.076830]  ffff88000004fd90 0000000000000046 ffff880000050000 ffff88000004ffd8
[  397.076830]  00000000001d0b80 ffff88000004ffd8 ffff88000002eb40 ffff880000050000
[  397.076830]  ffff88000dfcd6a0 ffff880000050000 ffff88000dfcd6a0 ffff88000004ffd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81066feb>] cpu_stopper_thread+0x186/0x1a2
[  397.076830]  [<ffffffff8104f16a>] ? __migrate_task+0xf8/0xf8
[  397.076830]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  397.076830]  [<ffffffff81066e65>] ? cpumask_weight+0x14/0x14
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] ksoftirqd/1     S ffff88000005bfd8     0     9      2 0x00000000
[  397.076830]  ffff88000005bdf0 0000000000000046 ffff8800000523c0 ffff88000005bfd8
[  397.076830]  00000000001d0b80 ffff88000005bfd8 ffff88000002eb40 ffff8800000523c0
[  397.076830]  ffff88000005bdf0 ffff88000005a000 0000000000000001 ffff88000005bfd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff814862be>] schedule_preempt_disabled+0x1f/0x27
[  397.076830]  [<ffffffff81036556>] run_ksoftirqd+0x5f/0x193
[  397.076830]  [<ffffffff810364f7>] ? __do_softirq+0x140/0x140
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] khelper         S ffff880000097700     0    10      2 0x00000000
[  397.076830]  ffff880000061e00 0000000000000046 ffff8800000535a0 ffff880000061fd8
[  397.076830]  00000000001d0b80 ffff880000061fd8 ffff88000002eb40 ffff8800000535a0
[  397.076830]  ffff880000061e10 ffff8800000535a0 ffff880000095c00 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] sync_supers     S 0000000000000000     0    11      2 0x00000000
[  397.076830]  ffff880000063e50 0000000000000046 ffff880000054780 ffff880000063fd8
[  397.076830]  00000000001d0b80 ffff880000063fd8 ffffffff81a0e3f0 ffff880000054780
[  397.076830]  0000000000000000 ffff880000054780 0000000000000000 ffffffff81093d1d
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff81093d1d>] ? bdi_sched_wait+0xd/0xd
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81093d57>] bdi_sync_supers+0x3a/0x51
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] bdi-default     S ffffffff81a1b900     0    12      2 0x00000000
[  397.076830]  ffff880000069d80 0000000000000046 ffff880000055960 ffff880000069fd8
[  397.076830]  00000000001d0b80 ffff880000069fd8 ffff88000002eb40 ffff880000055960
[  397.076830]  ffff880000069d80 0000000100007545 ffff880000055960 0000000000000000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81487038>] ? _raw_spin_unlock_bh+0x3c/0x41
[  397.076830]  [<ffffffff810940fa>] ? bdi_forker_thread+0x139/0x2ea
[  397.076830]  [<ffffffff810942a6>] bdi_forker_thread+0x2e5/0x2ea
[  397.076830]  [<ffffffff81093fc1>] ? wb_has_dirty_io+0x3f/0x3f
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kintegrityd     S ffff880000097d00     0    13      2 0x00000000
[  397.076830]  ffff88000006be00 0000000000000046 ffff880000056b40 ffff88000006bfd8
[  397.076830]  00000000001d0b80 ffff88000006bfd8 ffff88000002eb40 ffff880000056b40
[  397.076830]  ffff88000006be10 ffff880000056b40 ffff880000012840 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kblockd         S ffff880000097f00     0    14      2 0x00000000
[  397.076830]  ffff880000101e00 0000000000000046 ffff880000078000 ffff880000101fd8
[  397.076830]  00000000001d0b80 ffff880000101fd8 ffff88000002eb40 ffff880000078000
[  397.076830]  ffff880000101e10 ffff880000078000 ffff8800000129c0 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kworker/1:1     S ffff88000ccf9020     0    15      2 0x00000000
[  397.076830]  ffff880000129e40 0000000000000046 ffff8800000791e0 ffff880000129fd8
[  397.076830]  00000000001d0b80 ffff880000129fd8 ffff8800069e23c0 ffff8800000791e0
[  397.076830]  ffff880000129e20 ffff88000ccf9000 ffff88000de0d000 ffff8800000791e0
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kworker/0:1     S ffff88000010a020     0    16      2 0x00000000
[  397.076830]  ffff880009215e40 0000000000000046 ffff88000007a3c0 ffff880009215fd8
[  397.076830]  00000000001d0b80 ffff880009215fd8 ffff8800068d11e0 ffff88000007a3c0
[  397.076830]  ffff880009215e20 ffff88000010a000 ffff88000dc0d000 ffff88000007a3c0
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] khungtaskd      S 00000000003fffd2     0    18      2 0x00000000
[  397.076830]  ffff8800068c5d80 0000000000000046 ffff88000007c780 ffff8800068c5fd8
[  397.076830]  00000000001d0b80 ffff8800068c5fd8 ffff88000002eb40 ffff88000007c780
[  397.076830]  ffff8800068c5d80 00000001000046bc ffff8800069ab5a0 0000000000000078
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81071366>] watchdog+0x42/0x232
[  397.076830]  [<ffffffff81071324>] ? rcu_read_lock+0x79/0x79
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_wri S 0000000000000000     0    19      2 0x00000000
[  397.076830]  ffff8800068c7d90 0000000000000046 ffff88000007d960 ffff8800068c7fd8
[  397.076830]  00000000001d0b80 ffff8800068c7fd8 ffff8800068d23c0 ffff88000007d960
[  397.076830]  ffff8800068c7d90 0000000100002649 0000000000000000 ffff88000007d960
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81077a2f>] rcu_torture_writer+0x1a1/0x201
[  397.076830]  [<ffffffff8107788e>] ? srcu_read_lock_held.constprop.28+0x38/0x38
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_fak S 0000000000000000     0    20      2 0x00000000
[  397.076830]  ffff8800068c9da0 0000000000000046 ffff88000007eb40 ffff8800068c9fd8
[  397.076830]  00000000001d0b80 ffff8800068c9fd8 ffff8800068d5960 ffff88000007eb40
[  397.076830]  ffff8800068c9da0 0000000100002649 0000000000000000 ffffffff81076400
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_fak S 0000000000000000     0    21      2 0x00000000
[  397.076830]  ffff8800068cbda0 0000000000000046 ffff8800068d0000 ffff8800068cbfd8
[  397.076830]  00000000001d0b80 ffff8800068cbfd8 ffff88000007d960 ffff8800068d0000
[  397.076830]  ffff8800068cbda0 0000000100002649 0000000000000000 ffffffff81076400
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_fak S 0000000000000000     0    22      2 0x00000000
[  397.076830]  ffff8800068cdda0 0000000000000046 ffff8800068d11e0 ffff8800068cdfd8
[  397.076830]  00000000001d0b80 ffff8800068cdfd8 ffffffff81a0e3f0 ffff8800068d11e0
[  397.076830]  ffff8800068cdda0 000000010000264c 0000000000000000 ffffffff81076400
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_fak S 0000000000000000     0    23      2 0x00000000
[  397.076830]  ffff8800068cfda0 0000000000000046 ffff8800068d23c0 ffff8800068cffd8
[  397.076830]  00000000001d0b80 ffff8800068cffd8 ffff88000002eb40 ffff8800068d23c0
[  397.076830]  ffff8800068cfda0 0000000100002649 0000000000000000 ffffffff81076400
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_rea S 00000000ffffff0a     0    24      2 0x00000000
[  397.076830]  ffff8800068d9d00 0000000000000046 ffff8800068d35a0 ffff8800068d9fd8
[  397.076830]  00000000001d0b80 ffff8800068d9fd8 ffff88000007eb40 ffff8800068d35a0
[  397.076830]  ffff8800068d9d00 0000000100002649 ffff8800068d9fd8 ffff8800068d9fd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  397.076830]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_rea S 00000000ffffff0a     0    25      2 0x00000000
[  397.076830]  ffff8800068dbd00 0000000000000046 ffff8800068d4780 ffff8800068dbfd8
[  397.076830]  00000000001d0b80 ffff8800068dbfd8 ffff8800068d35a0 ffff8800068d4780
[  397.076830]  ffff8800068dbd00 0000000100002649 ffff8800068dbfd8 ffff8800068dbfd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  397.076830]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_rea S 00000000ffffff0a     0    26      2 0x00000000
[  397.076830]  ffff8800068ddd00 0000000000000046 ffff8800068d5960 ffff8800068ddfd8
[  397.076830]  00000000001d0b80 ffff8800068ddfd8 ffff8800068d0000 ffff8800068d5960
[  397.076830]  ffff8800068ddd00 0000000100002649 ffff8800068ddfd8 ffff8800068ddfd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  397.076830]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_rea S 00000000ffffff0a     0    27      2 0x00000000
[  397.076830]  ffff8800068dfd00 0000000000000046 ffff8800068d6b40 ffff8800068dffd8
[  397.076830]  00000000001d0b80 ffff8800068dffd8 ffff8800068d4780 ffff8800068d6b40
[  397.076830]  ffff8800068dfd00 0000000100002649 ffff8800068dffd8 ffff8800068dffd8
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  397.076830]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  397.076830]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rcu_torture_stu S 0000000000000000     0    28      2 0x00000000
[  397.076830]  ffff8800068e5dd0 0000000000000046 ffff8800068e8000 ffff8800068e5fd8
[  397.076830]  00000000001d0b80 ffff8800068e5fd8 ffff88000002eb40 ffff8800068e8000
[  397.076830]  ffff8800068e5dd0 00000001000027a2 0000000000000000 ffffffff810766e9
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff810766e9>] ? rcutorture_cpu_notify+0x3a/0x3a
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  397.076830]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  397.076830]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  397.076830]  [<ffffffff8107673c>] rcu_torture_stutter+0x53/0x94
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kswapd0         S 0000000000000000     0    29      2 0x00000000
[  397.076830]  ffff8800068e7d70 0000000000000046 ffff8800068e91e0 ffff8800068e7fd8
[  397.076830]  00000000001d0b80 ffff8800068e7fd8 ffff88000002eb40 ffff8800068e91e0
[  397.076830]  ffff880000000000 ffffffff81a769c0 0000000000000000 0000000000000000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff8109283e>] kswapd+0x1ca/0x6ae
[  397.076830]  [<ffffffff8105fba8>] ? trace_hardirqs_on+0xd/0xf
[  397.076830]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  397.076830]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  397.076830]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  397.076830]  [<ffffffff81092674>] ? try_to_free_pages+0x2f8/0x2f8
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] ksmd            S 0000000000000000     0    30      2 0x00000000
[  397.076830]  ffff8800068f5e20 0000000000000046 ffff8800068ea3c0 ffff8800068f5fd8
[  397.076830]  00000000001d0b80 ffff8800068f5fd8 ffff88000002eb40 ffff8800068ea3c0
[  397.076830]  ffff8800068f5e30 ffff8800068f5e48 ffff8800068ea3c0 ffff8800068f5e60
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff810a9838>] ksm_scan_thread+0xdd/0x10a
[  397.076830]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  397.076830]  [<ffffffff810a975b>] ? ksm_do_scan+0x899/0x899
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] fsnotify_mark   S ffff8800068f7e28     0    31      2 0x00000000
[  397.076830]  ffff8800068f7df0 0000000000000046 ffff8800068eb5a0 ffff8800068f7fd8
[  397.076830]  00000000001d0b80 ffff8800068f7fd8 ffff88000002eb40 ffff8800068eb5a0
[  397.076830]  ffff8800068f7e00 ffff8800068f7e38 ffff8800068eb5a0 ffff8800068f7e50
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff810db95d>] fsnotify_mark_destroy+0x152/0x168
[  397.076830]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  397.076830]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  397.076830]  [<ffffffff810db80b>] ? fsnotify_put_mark+0x1a/0x1a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] xfsalloc        S ffff8800068c2700     0    32      2 0x00000000
[  397.076830]  ffff88000695fe00 0000000000000046 ffff8800068ec780 ffff88000695ffd8
[  397.076830]  00000000001d0b80 ffff88000695ffd8 ffff88000002eb40 ffff8800068ec780
[  397.076830]  ffff88000695fe10 ffff8800068ec780 ffff8800068bf6c0 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] xfs_mru_cache   S ffff8800068c2900     0    33      2 0x00000000
[  397.076830]  ffff880006961e00 0000000000000046 ffff8800068ed960 ffff880006961fd8
[  397.076830]  00000000001d0b80 ffff880006961fd8 ffff88000002eb40 ffff8800068ed960
[  397.076830]  ffff880006961e10 ffff8800068ed960 ffff8800068bf840 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] xfslogd         S ffff8800068c2b00     0    34      2 0x00000000
[  397.076830]  ffff880006963e00 0000000000000046 ffff8800068eeb40 ffff880006963fd8
[  397.076830]  00000000001d0b80 ffff880006963fd8 ffff88000002eb40 ffff8800068eeb40
[  397.076830]  ffff880006963e10 ffff8800068eeb40 ffff8800068bf9c0 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] crypto          S ffff8800068c2d00     0    35      2 0x00000000
[  397.076830]  ffff880006965e00 0000000000000046 ffff880006968000 ffff880006965fd8
[  397.076830]  00000000001d0b80 ffff880006965fd8 ffff88000002eb40 ffff880006968000
[  397.076830]  ffff880006965e10 ffff880006968000 ffff8800068bfb40 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] mtdblock0       S 0000000000000000     0    71      2 0x00000000
[  397.076830]  ffff8800065cde00 0000000000000046 ffff8800069e5960 ffff8800065cdfd8
[  397.076830]  00000000001d0b80 ffff8800065cdfd8 ffffffff81a0e3f0 ffff8800069e5960
[  397.076830]  ffff8800069bd508 0000000000000000 ffff8800069bd400 ffff8800065d0000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff812bedcb>] mtd_blktrans_thread+0x10d/0x2e4
[  397.076830]  [<ffffffff812becbe>] ? blktrans_open+0xec/0xec
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] mtdblock1       S 0000000000000000     0    72      2 0x00000000
[  397.076830]  ffff88000567de00 0000000000000046 ffff8800069e4780 ffff88000567dfd8
[  397.076830]  00000000001d0b80 ffff88000567dfd8 ffffffff81a0e3f0 ffff8800069e4780
[  397.076830]  ffff8800069bf108 0000000000000000 ffff8800069bf000 ffff8800065d0b30
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff812bedcb>] mtd_blktrans_thread+0x10d/0x2e4
[  397.076830]  [<ffffffff812becbe>] ? blktrans_open+0xec/0xec
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] binder          S ffff8800069d0700     0    73      2 0x00000000
[  397.076830]  ffff880005685e00 0000000000000046 ffff8800069e35a0 ffff880005685fd8
[  397.076830]  00000000001d0b80 ffff880005685fd8 ffffffff81a0e3f0 ffff8800069e35a0
[  397.076830]  ffff880005685e10 ffff8800069e35a0 ffff88000695d000 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kworker/1:2     S ffff88000ccf96e0     0    74      2 0x00000000
[  397.076830]  ffff8800057a3e40 0000000000000046 ffff8800069e23c0 ffff8800057a3fd8
[  397.076830]  00000000001d0b80 ffff8800057a3fd8 ffff8800068d6b40 ffff8800069e23c0
[  397.076830]  ffff8800057a3e20 ffff88000ccf96c0 ffff88000de0d000 ffff8800069e23c0
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] bat_events      S ffff8800057a1500     0    75      2 0x00000000
[  397.076830]  ffff8800057a9e00 0000000000000046 ffff8800069e11e0 ffff8800057a9fd8
[  397.076830]  00000000001d0b80 ffff8800057a9fd8 ffff88000002eb40 ffff8800069e11e0
[  397.076830]  ffff8800057a9e10 ffff8800069e11e0 ffff88000695d3c0 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] deferwq         S ffff8800057a1d00     0    76      2 0x00000000
[  397.076830]  ffff8800057ffe00 0000000000000046 ffff8800069e0000 ffff8800057fffd8
[  397.076830]  00000000001d0b80 ffff8800057fffd8 ffff88000002eb40 ffff8800069e0000
[  397.076830]  ffff8800057ffe10 ffff8800069e0000 ffff8800057860c0 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] kworker/u:1     S 0000000000000000     0    77      2 0x00000000
[  397.076830]  ffff880005001e40 0000000000000046 ffff8800069e6b40 ffff880005001fd8
[  397.076830]  00000000001d0b80 ffff880005001fd8 ffff88000002eb40 ffff8800069e6b40
[  397.076830]  ffff880005001e20 ffff880005786240 ffffffff81d0f540 ffff8800069e6b40
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] devfreq_wq      S ffff880005002100     0    78      2 0x00000000
[  397.076830]  ffff880005005e00 0000000000000046 ffff8800069aeb40 ffff880005005fd8
[  397.076830]  00000000001d0b80 ffff880005005fd8 ffff88000002eb40 ffff8800069aeb40
[  397.076830]  ffff880005005e10 ffff8800069aeb40 ffff8800057863c0 0000000000000008
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  397.076830]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  397.076830]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  397.076830]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  397.076830]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  397.076830]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  397.076830]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  397.076830]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  397.076830] rc.local        S ffff8800069c6b30     0    79      1 0x00000000
[  397.076830]  ffff880005049e58 0000000000000046 ffff8800069c6b40 ffff880005049fd8
[  397.076830]  00000000001d0b80 ffff880005049fd8 ffff88000002eb40 ffff8800069c6b40
[  397.076830]  ffff8800069c6b40 ffff880005049f00 ffff8800069c6b40 ffff8800069c6b40
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff8103417e>] do_wait+0x189/0x1fc
[  397.076830]  [<ffffffff81035216>] sys_wait4+0x91/0xbd
[  397.076830]  [<ffffffff814882a5>] ? sysret_check+0x22/0x5d
[  397.076830]  [<ffffffff81033039>] ? kill_orphaned_pgrp+0xce/0xce
[  397.076830]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  397.076830] hostname        x ffff8800069c4770     0    81      1 0x00000002
[  397.076830]  ffff880005085ea8 0000000000000046 ffff8800069c4780 ffff880005085fd8
[  397.076830]  00000000001d0b80 ffff880005085fd8 ffff880000028000 ffff8800069c4780
[  397.076830]  ffffffff81a04080 ffff8800069c4780 0000000000000000 ffff880000028000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81034eda>] do_exit+0x6e3/0x6ef
[  397.076830]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  397.076830]  [<ffffffff81034f89>] do_group_exit+0x76/0xb5
[  397.076830]  [<ffffffff81034fda>] sys_exit_group+0x12/0x12
[  397.076830]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  397.076830] sh              t ffff8800069c35a0     0    82      1 0x00000002
[  397.076830]  ffff8800050a5d58 0000000000000046 ffff8800069c35a0 ffff8800050a5fd8
[  397.076830]  00000000001d0b80 ffff8800050a5fd8 ffff880000028000 ffff8800069c35a0
[  397.076830]  0000000000040004 ffff8800050a4000 0000000000040004 0000000000000000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff8103bc29>] ptrace_stop+0x153/0x20b
[  397.076830]  [<ffffffff8103cdbd>] get_signal_to_deliver+0x24a/0x4b3
[  397.076830]  [<ffffffff810015e7>] do_signal+0x2f/0x43c
[  397.076830]  [<ffffffff810ab13c>] ? kfree+0x84/0x88
[  397.076830]  [<ffffffff810aab27>] ? kmem_cache_free+0x6a/0x6f
[  397.076830]  [<ffffffff8148855b>] ? int_very_careful+0x5/0xd
[  397.076830]  [<ffffffff81001a30>] do_notify_resume+0x28/0x5a
[  397.076830]  [<ffffffff814885b2>] int_signal+0x12/0x17
[  397.076830] shutdown        S 0000000000000000     0    92     79 0x00000000
[  397.076830]  ffff88000500fa68 0000000000000046 ffff88000696c780 ffff88000500ffd8
[  397.076830]  00000000001d0b80 ffff88000500ffd8 ffffffff81a0e3f0 ffff88000696c780
[  397.076830]  ffff8800057fce80 0000000000000000 0000000000000000 0000000000000000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff814858db>] schedule_hrtimeout_range_clock+0x37/0xe1
[  397.076830]  [<ffffffff810472f2>] ? add_wait_queue+0x3f/0x44
[  397.076830]  [<ffffffff810bc541>] ? __pollwait+0xc0/0xc9
[  397.076830]  [<ffffffff81485993>] schedule_hrtimeout_range+0xe/0x10
[  397.076830]  [<ffffffff810bc939>] poll_schedule_timeout+0x3e/0x61
[  397.076830]  [<ffffffff810bd76d>] do_sys_poll+0x2ed/0x388
[  397.076830]  [<ffffffff8100774f>] ? sched_clock+0x9/0xb
[  397.076830]  [<ffffffff810524ba>] ? sched_clock_local+0x12/0x75
[  397.076830]  [<ffffffff81052641>] ? sched_clock_cpu+0xbd/0xcf
[  397.076830]  [<ffffffff8105fcd2>] ? trace_hardirqs_off+0xd/0xf
[  397.076830]  [<ffffffff81052780>] ? local_clock+0x3b/0x53
[  397.076830]  [<ffffffff8105e39c>] ? lock_release_holdtime.part.25+0x4e/0x55
[  397.076830]  [<ffffffff81061e33>] ? lock_release+0x189/0x1c3
[  397.076830]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  397.076830]  [<ffffffff810bc620>] ? rcu_read_lock_held+0x38/0x38
[  397.076830]  [<ffffffff8100748a>] ? paravirt_sched_clock+0x9/0xd
[  397.076830]  [<ffffffff8100774f>] ? sched_clock+0x9/0xb
[  397.076830]  [<ffffffff810524ba>] ? sched_clock_local+0x12/0x75
[  397.076830]  [<ffffffff81052641>] ? sched_clock_cpu+0xbd/0xcf
[  397.076830]  [<ffffffff8105fcd2>] ? trace_hardirqs_off+0xd/0xf
[  397.076830]  [<ffffffff81052780>] ? local_clock+0x3b/0x53
[  397.076830]  [<ffffffff8105e39c>] ? lock_release_holdtime.part.25+0x4e/0x55
[  397.076830]  [<ffffffff81061e33>] ? lock_release+0x189/0x1c3
[  397.076830]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  397.076830]  [<ffffffff8104ad91>] ? up_read+0x1c/0x34
[  397.076830]  [<ffffffff81017e70>] ? do_page_fault+0x2e8/0x36c
[  397.076830]  [<ffffffff813813bc>] ? sys_sendto+0x12f/0x15c
[  397.076830]  [<ffffffff8105fc4c>] ? trace_hardirqs_off_caller+0xa2/0x11b
[  397.076830]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  397.076830]  [<ffffffff810bd89f>] sys_poll+0x4a/0xb3
[  397.076830]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  397.076830]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  397.076830] shutdown        x ffff8800069ab590     0    93     92 0x00000002
[  397.076830]  ffff880005075ea8 0000000000000046 ffff8800069ab5a0 ffff880005075fd8
[  397.076830]  00000000001d0b80 ffff880005075fd8 ffff88000002eb40 ffff8800069ab5a0
[  397.076830]  ffffffff81a04080 ffff8800069ab5a0 0000000000000000 ffff880000028000
[  397.076830] Call Trace:
[  397.076830]  [<ffffffff8148629d>] schedule+0x60/0x62
[  397.076830]  [<ffffffff81034eda>] do_exit+0x6e3/0x6ef
[  397.076830]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  397.076830]  [<ffffffff81034f89>] do_group_exit+0x76/0xb5
[  397.076830]  [<ffffffff81034fda>] sys_exit_group+0x12/0x12
[  397.076830]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  397.076830] 
[  397.076830] Showing all locks held in the system:
[  397.076830] 
[  397.076830] =============================================
[  397.076830] 
[  397.076830] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  397.076830] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  397.826783] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  397.827838] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  397.828837] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
Kernel crashed on [  397.828837] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0

--HcAYCG3uE/tztfnV--
