Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab2GNNtH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 09:49:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:61264 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab2GNNtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 09:49:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="177315382"
Date: Sat, 14 Jul 2012 21:48:49 +0800
From: Fengguang Wu <wfg@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel boot hangs on commit "switch fput to task_work_add"
Message-ID: <20120714134849.GA1175@localhost>
References: <20120710141830.GA5385@localhost>
 <20120714130510.GC31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="+HP7ph2BbKc20aGI"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120714130510.GC31729@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 14, 2012 at 02:05:10PM +0100, Al Viro wrote:
> On Tue, Jul 10, 2012 at 10:18:30PM +0800, wfg@linux.intel.com wrote:
> > Hi Al,
> > 
> > The linux-next kernel reliably hung after this line:
> > 
> > [    4.846260] debug: unmapping init [mem 0xffff88000182a000-0xffff8800019fffff]
> > 
> > And it's bisected to commit:
> > 
> >         commit 4a9ffe81385c2af04f296bea05482f34e02ea10d
> >         Author: Al Viro <viro@zeniv.linux.org.uk>
> >         Date:   Sun Jun 24 09:56:45 2012 +0400
> > 
> >             switch fput to task_work_add
> > 
> >             ... and schedule_work() for interrupt/kernel_thread callers
> >             (and yes, now it *is* OK to call from interrupt).
> > 
> > I tried add this debug aid:
> > 
> > init_post(void):
> > +       printk(KERN_WARNING "flush_delayed_fput\n");
> >         flush_delayed_fput();
> > +       printk(KERN_WARNING "flush_delayed_fput done\n");
> > 
> > And then it hangs after "flush_delayed_fput done". So it's not directly
> > freezing inside flush_delayed_fput()..
> 
> Could you post a stack trace, etc.?  I'll try to reproduce that one, obviously,
> but...

Hi Al, here I got the output for

(qemu) sendkey alt-sysrq-l
(qemu) sendkey alt-sysrq-t

Thanks,
Fengguang


--+HP7ph2BbKc20aGI
Content-Type: text/plain; charset=UTF-8
Content-Disposition: attachment; filename=dmesg-kvm_bisect-waimea-3828-2012-07-14-21-46-27
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
[    0.010384] ENABLING IO-APIC IRQs
[    0.010984] init IO_APIC IRQs
[    0.011494]  apic 2 pin 0 not connected
[    0.012261] IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0 Dest:1)
[    0.013648] IOAPIC[0]: Set routing entry (2-2 -> 0x30 -> IRQ 0 Mode:0 Active:0 Dest:1)
[    0.015016] IOAPIC[0]: Set routing entry (2-3 -> 0x33 -> IRQ 3 Mode:0 Active:0 Dest:1)
[    0.016372] IOAPIC[0]: Set routing entry (2-4 -> 0x34 -> IRQ 4 Mode:0 Active:0 Dest:1)
[    0.017749] IOAPIC[0]: Set routing entry (2-5 -> 0x35 -> IRQ 5 Mode:0 Active:0 Dest:1)
[    0.019119] IOAPIC[0]: Set routing entry (2-6 -> 0x36 -> IRQ 6 Mode:0 Active:0 Dest:1)
[    0.020033] IOAPIC[0]: Set routing entry (2-7 -> 0x37 -> IRQ 7 Mode:0 Active:0 Dest:1)
[    0.021408] IOAPIC[0]: Set routing entry (2-8 -> 0x38 -> IRQ 8 Mode:0 Active:0 Dest:1)
[    0.022777] IOAPIC[0]: Set routing entry (2-9 -> 0x29 -> IRQ 33 Mode:1 Active:0 Dest:1)
[    0.024169] IOAPIC[0]: Set routing entry (2-10 -> 0x41 -> IRQ 34 Mode:1 Active:0 Dest:1)
[    0.025555] IOAPIC[0]: Set routing entry (2-11 -> 0x49 -> IRQ 35 Mode:1 Active:0 Dest:1)
[    0.026946] IOAPIC[0]: Set routing entry (2-12 -> 0x3c -> IRQ 12 Mode:0 Active:0 Dest:1)
[    0.028360] IOAPIC[0]: Set routing entry (2-13 -> 0x3d -> IRQ 13 Mode:0 Active:0 Dest:1)
[    0.030019] IOAPIC[0]: Set routing entry (2-14 -> 0x3e -> IRQ 14 Mode:0 Active:0 Dest:1)
[    0.031422] IOAPIC[0]: Set routing entry (2-15 -> 0x3f -> IRQ 15 Mode:0 Active:0 Dest:1)
[    0.032811]  apic 2 pin 16 not connected
[    0.033488]  apic 2 pin 17 not connected
[    0.034153]  apic 2 pin 18 not connected
[    0.034840]  apic 2 pin 19 not connected
[    0.035517]  apic 2 pin 20 not connected
[    0.036184]  apic 2 pin 21 not connected
[    0.036870]  apic 2 pin 22 not connected
[    0.037545]  apic 2 pin 23 not connected
[    0.038366] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.039548] CPU0: Intel Common KVM processor stepping 01
[    0.040767] Using local APIC timer interrupts.
[    0.040767] calibrating APIC timer ...
[    0.050000] ... lapic delta = 6249407
[    0.050000] ..... delta 6249407
[    0.050000] ..... mult: 268409986
[    0.050000] ..... calibration result: 9999051
[    0.050000] ..... CPU clock speed is 3299.6741 MHz.
[    0.050000] ..... host bus clock speed is 999.9051 MHz.
[    0.050000] ... verify APIC timer
[    0.165587] ... jiffies delta = 10
[    0.166257] ... jiffies result ok
[    0.166954] Performance Events: unsupported Netburst CPU model 6 no PMU driver, software events only.
[    0.169510] lockdep: fixing up alternatives.
[    0.170000] Booting Node   0, Processors  #1 Ok.
[    0.010000] kvm-clock: cpu 1, msr 0:dfd0ac1, secondary cpu clock
[    0.010000] masked ExtINT on CPU#1
[    0.010000] Disabled fast string operations
[    0.180000] TSC synchronization [CPU#0 -> CPU#1]:
[    0.180000] Measured 2084 cycles TSC warp between CPUs, turning off TSC clock.
[    0.180000] Marking TSC unstable due to check_tsc_sync_source failed
[    0.190058] Brought up 2 CPUs
[    0.190591] Total of 2 processors activated (13199.94 BogoMIPS).
[    0.192001] device: 'platform': device_add
[    0.192758] bus: 'platform': registered
[    0.193440] bus: 'cpu': registered
[    0.194019] device: 'cpu': device_add
[    0.195070] atomic64 test passed for x86-64 platform with CX8 and with SSE
[    0.196247] device class 'regulator': registering
[    0.197127] Registering platform device 'reg-dummy'. Parent at platform
[    0.198252] device: 'reg-dummy': device_add
[    0.198977] bus: 'platform': add device reg-dummy
[    0.200033] bus: 'platform': add driver reg-dummy
[    0.200845] bus: 'platform': driver_probe_device: matched device reg-dummy with driver reg-dummy
[    0.202327] bus: 'platform': really_probe: probing driver reg-dummy with device reg-dummy
[    0.203757] device: 'regulator.0': device_add
[    0.204562] dummy: 
[    0.205038] driver: 'reg-dummy': driver_bound: bound to device 'reg-dummy'
[    0.206214] bus: 'platform': really_probe: bound device reg-dummy to driver reg-dummy
[    0.207664] NET: Registered protocol family 16
[    0.208633] device class 'bdi': registering
[    0.209365] device class 'lcd': registering
[    0.210008] device class 'backlight': registering
[    0.210835] device class 'tty': registering
[    0.211586] bus: 'hsi': registered
[    0.212174] bus: 'i2c': registered
[    0.212783] bus: 'i2c': add driver dummy
[    0.213477] i2c-core: driver [dummy] registered
[    0.214615] device class 'dmi': registering
[    0.215332] device: 'id': device_add
[    0.216159] device: 'cpu0': device_add
[    0.216808] bus: 'cpu': add device cpu0
[    0.217502] device: 'cpu1': device_add
[    0.218147] bus: 'cpu': add device cpu1
[    0.218966] device: 'default': device_add
[    0.220189] bio: create slab <bio-0> at 0
[    0.220930] device class 'block': registering
[    0.221858] bus: 'i2c': add driver mcp230xx
[    0.222609] i2c-core: driver [mcp230xx] registered
[    0.223427] bus: 'platform': add driver stmpe-gpio
[    0.224265] bus: 'i2c': add driver sx150x
[    0.224974] i2c-core: driver [sx150x] registered
[    0.225782] bus: 'platform': add driver tps65912-gpio
[    0.226659] bus: 'platform': add driver wm831x-gpio
[    0.227488] bus: 'platform': add driver wm8350-gpio
[    0.228344] device class 'graphics': registering
[    0.229145] bus: 'platform': add driver aat2870-backlight
[    0.230010] bus: 'platform': add driver reg-fixed-voltage
[    0.230950] bus: 'platform': add driver 88pm860x-regulator
[    0.231900] bus: 'platform': add driver aat2870-regulator
[    0.232840] bus: 'i2c': add driver ad5398
[    0.233554] i2c-core: driver [ad5398] registered
[    0.234340] bus: 'i2c': add driver lp3972
[    0.235076] i2c-core: driver [lp3972] registered
[    0.235897] bus: 'i2c': add driver max1586
[    0.236615] i2c-core: driver [max1586] registered
[    0.237409] bus: 'platform': add driver max8925-regulator
[    0.238341] bus: 'platform': add driver mc13892-regulator
[    0.239274] bus: 'platform': add driver palmas-pmic
[    0.240009] bus: 'platform': add driver tps6105x-regulator
[    0.240959] bus: 'i2c': add driver tps62360
[    0.241691] i2c-core: driver [tps62360] registered
[    0.242532] bus: 'i2c': add driver tps65023
[    0.243239] i2c-core: driver [tps65023] registered
[    0.244081] bus: 'platform': add driver tps6507x-pmic
[    0.244957] bus: 'platform': add driver tps65217-pmic
[    0.245832] bus: 'platform': add driver tps65912-pmic
[    0.246705] bus: 'platform': add driver wm831x-buckv
[    0.247555] bus: 'platform': add driver wm831x-buckp
[    0.248417] bus: 'platform': add driver wm831x-boostp
[    0.249268] bus: 'platform': add driver wm831x-epe
[    0.250010] bus: 'platform': add driver wm831x-isink
[    0.250879] bus: 'platform': add driver wm831x-ldo
[    0.251705] bus: 'platform': add driver wm831x-aldo
[    0.252569] bus: 'platform': add driver wm831x-alive-ldo
[    0.253491] bus: 'platform': add driver wm8350-regulator
[    0.254414] bus: 'platform': add driver wm8400-regulator
[    0.255334] device class 'misc': registering
[    0.256062] bus: 'i2c': add driver 88PM860x
[    0.256797] i2c-core: driver [88PM860x] registered
[    0.257631] bus: 'i2c': add driver stmpe-i2c
[    0.258379] i2c-core: driver [stmpe-i2c] registered
[    0.259203] bus: 'i2c': add driver WM8400
[    0.260008] i2c-core: driver [WM8400] registered
[    0.260811] bus: 'i2c': add driver wm831x
[    0.261517] i2c-core: driver [wm831x] registered
[    0.262296] bus: 'i2c': add driver wm8350
[    0.263012] i2c-core: driver [wm8350] registered
[    0.263815] bus: 'i2c': add driver tps6105x
[    0.264546] i2c-core: driver [tps6105x] registered
[    0.265455] bus: 'i2c': add driver tps6507x
[    0.266168] i2c-core: driver [tps6507x] registered
[    0.266997] bus: 'i2c': add driver tps65217
[    0.267726] i2c-core: driver [tps65217] registered
[    0.268555] bus: 'i2c': add driver tps65912
[    0.269267] i2c-core: driver [tps65912] registered
[    0.270006] bus: 'i2c': add driver mc13xxx
[    0.270722] i2c-core: driver [mc13xxx] registered
[    0.271536] bus: 'i2c': add driver da903x
[    0.272218] i2c-core: driver [da903x] registered
[    0.273040] bus: 'i2c': add driver da9052
[    0.273744] i2c-core: driver [da9052] registered
[    0.274544] bus: 'i2c': add driver max8925
[    0.275239] i2c-core: driver [max8925] registered
[    0.276053] bus: 'i2c': add driver max8997
[    0.276769] i2c-core: driver [max8997] registered
[    0.277582] bus: 'i2c': add driver aat2870
[    0.278296] i2c-core: driver [aat2870] registered
[    0.279092] bus: 'i2c': add driver palmas
[    0.280008] i2c-core: driver [palmas] registered
[    0.280820] bus: 'platform': add driver nop_usb_xceiv
[    0.281695] device class 'udc': registering
[    0.282409] bus: 'serio': registered
[    0.283057] bus: 'gameport': registered
[    0.283731] device class 'input': registering
[    0.284492] Linux video capture interface: v2.00
[    0.285272] device class 'video4linux': registering
[    0.286122] device class 'dvb': registering
[    0.286854] device class 'power_supply': registering
[    0.287713] device class 'hwmon': registering
[    0.288471] device class 'leds': registering
[    0.289203] device class 'devfreq': registering
[    0.290014] device class 'net': registering
[    0.290766] device: 'lo': device_add
[    0.320238] Switching to clocksource kvm-clock
[    0.321052] FS-Cache: Loaded
[    0.321497] device: 'cachefiles': device_add
[    0.322289] CacheFiles: Loaded
[    0.322849] device class 'mem': registering
[    0.323578] device: 'mem': device_add
[    0.324222] device: 'null': device_add
[    0.324943] device: 'zero': device_add
[    0.325603] device: 'full': device_add
[    0.326263] device: 'random': device_add
[    0.326938] device: 'urandom': device_add
[    0.327640] device: 'kmsg': device_add
[    0.328299] device: 'oldmem': device_add
[    0.328974] device: 'tty': device_add
[    0.329627] device: 'console': device_add
[    0.329627] device class 'thermal': registering
[    0.330419] NET: Registered protocol family 2
[    0.331219] IP route cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.332573] TCP established hash table entries: 8192 (order: 5, 131072 bytes)
[    0.333910] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    0.336218] TCP: Hash tables configured (established 8192 bind 8192)
[    0.337304] TCP: reno registered
[    0.337879] UDP hash table entries: 256 (order: 3, 49152 bytes)
[    0.338923] UDP-Lite hash table entries: 256 (order: 3, 49152 bytes)
[    0.340142] NET: Registered protocol family 1
[    0.341012] Unpacking initramfs...
[    1.065766] debug: unmapping init [mem 0xffff88000e8d6000-0xffff88000ffeffff]
[    1.079767] DMA-API: preallocated 32768 debug entries
[    1.080661] DMA-API: debugging enabled by kernel config
[    1.081803] Registering platform device 'rtc_cmos'. Parent at platform
[    1.082912] device: 'rtc_cmos': device_add
[    1.083620] bus: 'platform': add device rtc_cmos
[    1.084461] platform rtc_cmos: registered platform RTC device (no PNP device found)
[    1.086046] camellia-x86_64: performance on this CPU would be suboptimal: disabling camellia-x86_64.
[    1.087603] blowfish-x86_64: performance on this CPU would be suboptimal: disabling blowfish-x86_64.
[    1.089159] bus: 'platform': add driver alarmtimer
[    1.089990] Registering platform device 'alarmtimer'. Parent at platform
[    1.091146] device: 'alarmtimer': device_add
[    1.091899] bus: 'platform': add device alarmtimer
[    1.092742] bus: 'platform': driver_probe_device: matched device alarmtimer with driver alarmtimer
[    1.094246] bus: 'platform': really_probe: probing driver alarmtimer with device alarmtimer
[    1.095665] driver: 'alarmtimer': driver_bound: bound to device 'alarmtimer'
[    1.096855] bus: 'platform': really_probe: bound device alarmtimer to driver alarmtimer
[    1.098226] audit: initializing netlink socket (disabled)
[    1.099167] type=2000 audit(1342273300.090:1): initialized
[    1.100271] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    1.105988] bus: 'event_source': registered
[    1.106754] device: 'breakpoint': device_add
[    1.107485] bus: 'event_source': add device breakpoint
[    1.108370] device: 'software': device_add
[    1.109077] bus: 'event_source': add device software
[    1.110149] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.111627] VFS: Disk quotas dquot_6.5.2
[    1.112341] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.113622] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    1.114757] jffs2: version 2.2. Â© 2001-2006 Red Hat, Inc.
[    1.115864] ROMFS MTD (C) 2007 Red Hat, Inc.
[    1.116615] QNX4 filesystem 0.2.3 registered.
[    1.117361] QNX6 filesystem 1.0.0 registered.
[    1.118117] device: 'autofs': device_add
[    1.118818] SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
[    1.122234] alg: No test for cipher_null (cipher_null-generic)
[    1.123329] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[    1.124433] alg: No test for digest_null (digest_null-generic)
[    1.125548] alg: No test for compress_null (compress_null-generic)
[    1.131445] alg: No test for stdrng (krng)
[    1.138613] alg: No test for fips(ansi_cprng) (fips_ansi_cprng)
[    1.139769] NET: Registered protocol family 38
[    1.140649] device class 'bsg': registering
[    1.141371] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    1.142662] io scheduler noop registered
[    1.143339] io scheduler cfq registered (default)
[    1.144148] list_sort_test: start testing list_sort()
[    1.146347] crc32: CRC_LE_BITS = 8, CRC_BE BITS = 8
[    1.147185] crc32: self tests passed, processed 225944 bytes in 592882 nsec
[    1.148957] crc32c: CRC_LE_BITS = 8
[    1.149563] crc32c: self tests passed, processed 225944 bytes in 292592 nsec
[    1.151234] bus: 'platform': add driver adp5520-gpio
[    1.152112] bus: 'i2c': add driver adp5588-gpio
[    1.152896] i2c-core: driver [adp5588-gpio] registered
[    1.153859] bus: 'i2c': add driver lp855x
[    1.154557] i2c-core: driver [lp855x] registered
[    1.155340] bus: 'platform': add driver max8925-backlight
[    1.156265] bus: 'platform': add driver adp5520-backlight
[    1.157194] bus: 'i2c': add driver adp8860_bl
[    1.157947] i2c-core: driver [adp8860_bl] using legacy suspend method
[    1.159033] i2c-core: driver [adp8860_bl] using legacy resume method
[    1.160151] i2c-core: driver [adp8860_bl] registered
[    1.161003] bus: 'platform': add driver 88pm860x-backlight
[    1.161962] bus: 'platform': add driver hecubafb
[    1.162761] no IO addresses supplied
[    1.163372] bus: 'platform': add driver broadsheetfb
[    1.164226] bus: 'platform': add driver s1d13xxxfb
[    1.165053] bus: 'platform': add driver sm501-fb
[    1.165854] bus: 'platform': add driver reg-virt-consumer
[    1.166855] bus: 'platform': add driver reg-userspace-consumer
[    1.167870] device: 'ptmx': device_add
[    1.168540] r3964: Philips r3964 Driver $Revision: 1.10 $
[    1.169448] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    1.170554] Registering platform device 'serial8250'. Parent at platform
[    1.171694] device: 'serial8250': device_add
[    1.172413] bus: 'platform': add device serial8250
ÿ[    1.470340] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    1.471400] device: 'ttyS0': device_add
[    1.472179] device: 'ttyS1': device_add
[    1.472914] device: 'ttyS2': device_add
[    1.473615] device: 'ttyS3': device_add
[    1.474274] bus: 'platform': add driver serial8250
[    1.475099] bus: 'platform': driver_probe_device: matched device serial8250 with driver serial8250
[    1.476614] bus: 'platform': really_probe: probing driver serial8250 with device serial8250
[    1.478019] driver: 'serial8250': driver_bound: bound to device 'serial8250'
[    1.479209] bus: 'platform': really_probe: bound device serial8250 to driver serial8250
[    1.480597] bus: 'platform': add driver timb-uart
[    1.481410] bus: 'platform': add driver altera_jtaguart
[    1.482343] bus: 'platform': add driver xuartps
[    1.483149] device: 'ttyprintk': device_add
[    1.483880] device: 'rtc': device_add
[    1.484525] Real Time Clock Driver v1.12b
[    1.485208] device class 'ppdev': registering
[    1.485965] ppdev: user-space parallel port driver
[    1.486807] smapi::smapi_init, ERROR invalid usSmapiID
[    1.487687] mwave: tp3780i::tp3780I_InitializeBoardData: Error: SMAPI is not available on this machine
[    1.489242] mwave: mwavedd::mwave_init: Error: Failed to initialize board data
[    1.490485] mwave: mwavedd::mwave_init: Error: Failed to initialize
[    1.491553] bus: 'platform': add driver ipmi
[    1.492281] ipmi message handler version 39.2
[    1.493031] ipmi device interface
[    1.493605] device class 'ipmi': registering
[    1.494347] bus: 'platform': add driver ipmi_si
[    1.495133] IPMI System Interface driver.
[    1.495835] ipmi_si: Adding default-specified kcs state machine
[    1.496968] ipmi_si: Trying default-specified kcs state machine at i/o address 0xca2, slave address 0x0, irq 0
[    1.498658] ipmi_si: Interface detection failed
[    1.530051] ipmi_si: Adding default-specified smic state machine
[    1.531117] ipmi_si: Trying default-specified smic state machine at i/o address 0xca9, slave address 0x0, irq 0
[    1.532842] ipmi_si: Interface detection failed
[    1.570047] ipmi_si: Adding default-specified bt state machine
[    1.571078] ipmi_si: Trying default-specified bt state machine at i/o address 0xe4, slave address 0x0, irq 0
[    1.572767] ipmi_si: Interface detection failed
[    1.610062] bus: 'platform': remove driver ipmi_si
[    1.610909] driver: 'ipmi_si': driver_release
[    1.611670] ipmi_si: Unable to find any System Interface(s)
[    1.612613] IPMI Watchdog: driver initialized
[    1.613348] Copyright (C) 2004 MontaVista Software - IPMI Powerdown via sys_reboot.
[    1.614649] device class 'drm': registering
[    1.615364] [drm:drm_core_init] *ERROR* Cannot create /proc/dri
[    1.616369] device class 'drm': unregistering
[    1.617121] class 'drm': release.
[    1.617789] class_create_release called for drm
[    1.618577] bus: 'platform': add driver parport_pc
[    1.619392] Registering platform device 'parport_pc.956'. Parent at platform
[    1.620609] device: 'parport_pc.956': device_add
[    1.621387] bus: 'platform': add device parport_pc.956
[    1.622291] bus: 'platform': driver_probe_device: matched device parport_pc.956 with driver parport_pc
[    1.623856] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.956
[    1.625315] driver: 'parport_pc.956': driver_bound: bound to device 'parport_pc'
[    1.626566] bus: 'platform': really_probe: bound device parport_pc.956 to driver parport_pc
[    1.628052] bus: 'platform': remove device parport_pc.956
[    1.628994] Registering platform device 'parport_pc.888'. Parent at platform
[    1.630206] device: 'parport_pc.888': device_add
[    1.630999] bus: 'platform': add device parport_pc.888
[    1.631917] bus: 'platform': driver_probe_device: matched device parport_pc.888 with driver parport_pc
[    1.633494] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.888
[    1.634955] driver: 'parport_pc.888': driver_bound: bound to device 'parport_pc'
[    1.636206] bus: 'platform': really_probe: bound device parport_pc.888 to driver parport_pc
[    1.637705] parport0: PC-style at 0x378 [PCSPP(,...)]
[    1.638710] parport0: irq 0 detected
[    1.639342] device: 'parport0': device_add
[    1.640104] Registering platform device 'parport_pc.632'. Parent at platform
[    1.641301] device: 'parport_pc.632': device_add
[    1.642105] bus: 'platform': add device parport_pc.632
[    1.643000] bus: 'platform': driver_probe_device: matched device parport_pc.632 with driver parport_pc
[    1.644569] bus: 'platform': really_probe: probing driver parport_pc with device parport_pc.632
[    1.646030] driver: 'parport_pc.632': driver_bound: bound to device 'parport_pc'
[    1.647370] bus: 'platform': really_probe: bound device parport_pc.632 to driver parport_pc
[    1.648852] bus: 'platform': remove device parport_pc.632
[    1.649782] device class 'enclosure': registering
[    1.650612] bus: 'i2c': add driver apds9802als
[    1.651367] i2c-core: driver [apds9802als] using legacy suspend method
[    1.652498] i2c-core: driver [apds9802als] using legacy resume method
[    1.653595] i2c-core: driver [apds9802als] registered
[    1.654444] bus: 'i2c': add driver isl29020
[    1.655166] i2c-core: driver [isl29020] registered
[    1.655988] bus: 'i2c': add driver hmc6352
[    1.656695] i2c-core: driver [hmc6352] registered
[    1.657504] bus: 'i2c': add driver fsa9480
[    1.658202] i2c-core: driver [fsa9480] using legacy suspend method
[    1.659250] i2c-core: driver [fsa9480] using legacy resume method
[    1.660298] i2c-core: driver [fsa9480] registered
[    1.661102] bus: 'platform': add driver sm501
[    1.661868] bus: 'i2c': add driver twl6040
[    1.662576] i2c-core: driver [twl6040] registered
[    1.663370] bus: 'i2c': add driver adp5520
[    1.664078] i2c-core: driver [adp5520] registered
[    1.664885] Uniform Multi-Platform E-IDE driver
[    1.665667] bus: 'ide': registered
[    1.666249] device class 'ide_port': registering
[    1.667047] ide_generic: please use "probe_mask=0x3f" module parameter for probing all legacy ISA IDE ports
[    1.668707] Probing IDE interface ide0...
[    2.270075] device: 'ide0': device_add
[    2.270769] device: 'ide0': device_add
[    2.271536] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.272341] Probing IDE interface ide1...
[    3.140116] hdc: QEMU DVD-ROM, ATAPI CD/DVD-ROM drive
[    3.890054] device: 'ide1': device_add
[    3.890737] device: 'ide1': device_add
[    3.891445] ide1 at 0x170-0x177,0x376 on irq 15
[    3.892365] device: '1.0': device_add
[    3.893016] bus: 'ide': add device 1.0
[    3.893669] ide-cd driver 5.00
[    3.894207] bus: 'ide': add driver ide-cdrom
[    3.894953] bus: 'ide': driver_probe_device: matched device 1.0 with driver ide-cdrom
[    3.896267] bus: 'ide': really_probe: probing driver ide-cdrom with device 1.0
[    3.897501] device: '1.0': device_add
[    3.898443] ide-cd: hdc: ATAPI 4X CD-ROM drive, 512kB Cache
[    3.899483] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.901457] device: '22:0': device_add
[    3.902183] device: 'hdc': device_add
[    3.902880] driver: '1.0': driver_bound: bound to device 'ide-cdrom'
[    3.904294] bus: 'ide': really_probe: bound device 1.0 to driver ide-cdrom
[    3.905458] device class 'ide_tape': registering
[    3.906274] bus: 'ide': add driver ide-tape
[    3.907023] device class 'mtd': registering
[    3.907756] device: 'mtd-unmap': device_add
[    3.908506] device: 'mtd-romap': device_add
[    3.909268] device: 'mtd-rwmap': device_add
[    3.910197] SSFDC read-only Flash Translation layer
[    3.911045] Generic platform RAM MTD, (c) 2004 Simtec Electronics
[    3.912092] bus: 'platform': add driver mtd-ram
[    3.912911] bus: 'platform': add driver docg3
[    3.913658] bus: 'platform': remove driver docg3
[    3.914451] driver: 'docg3': driver_release
[    3.943189] No recognised DiskOnChip devices found
[    3.943989] slram: not enough parameters.
[    3.946045] device: 'mtd0': device_add
[    3.946722] device: 'mtd0ro': device_add
[    3.947611] device: '31:0': device_add
[    3.948316] device: 'mtdblock0': device_add
[    3.990036] onenand_wait: timeout! ctrl=0x0000 intr=0x0000
[    3.991002] OneNAND Manufacturer: Samsung (0xec)
[    3.991893] OneNAND 16MB 1.8V 16-bit (0x04)
[    3.992598] OneNAND version = 0x001e
[    3.993193] Lock scheme is Continuous Lock
[    3.993886] Scanning device for bad blocks
[    3.995220] Creating 1 MTD partitions on "OneNAND simulator":
[    3.996179] 0x000000000000-0x000001000000 : "OneNAND simulator partition"
[    3.997583] device: 'mtd1': device_add
[    3.998228] device: 'mtd1ro': device_add
[    3.999094] device: '31:1': device_add
[    3.999780] device: 'mtdblock1': device_add
[    4.000534] device class 'ubi': registering
[    4.001232] device: 'ubi_ctrl': device_add
[    4.001959] bus: 'hsi': add driver hsi_char
[    4.002705] HSI/SSI char device loaded
[    4.003326] eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
[    4.004831] device: 'eql': device_add
[    4.005531] device: 'ifb0': device_add
[    4.006191] device: 'ifb1': device_add
[    4.007079] bus: 'platform': add driver cfspi_sspi
[    4.007920] bus: 'platform': add driver cfhsi
[    4.008665] plip: parport0 has no IRQ. Using IRQ-less mode,which is fairly inefficient!
[    4.010049] device: 'plip0': device_add
[    4.010734] NET3 PLIP version 2.4-parport gniibe@mri.co.jp
[    4.011660] plip0: Parallel port at 0x378, not using IRQ.
[    4.012551] PPP generic driver version 2.4.2
[    4.013289] device class 'ppp': registering
[    4.014003] device: 'ppp': device_add
[    4.014671] PPP Deflate Compression module registered
[    4.015513] SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256).
[    4.016674] CSLIP: code copyright 1989 Regents of the University of California.
[    4.017878] SLIP linefill/keepalive option.
[    4.018580] hdlc: HDLC support module revision 1.22
[    4.019390] device class 'uio': registering
[    4.020205] bus: 'platform': add driver uio_pdrv_genirq
[    4.021088] bus: 'platform': add driver gpio-vbus
[    4.021970] bus: 'platform': remove driver gpio-vbus
[    4.022830] driver: 'gpio-vbus': driver_release
[    4.023593] bus: 'platform': add driver net2272
[    4.024347] bus: 'platform': add driver m66592_udc
[    4.025177] bus: 'platform': remove driver m66592_udc
[    4.026023] driver: 'm66592_udc': driver_release
[    4.026795] bus: 'platform': add driver r8a66597_udc
[    4.027631] bus: 'platform': remove driver r8a66597_udc
[    4.028503] driver: 'r8a66597_udc': driver_release
[    4.029310] bus: 'platform': add driver mv-udc
[    4.030147] Registering platform device 'i8042'. Parent at platform
[    4.031184] device: 'i8042': device_add
[    4.031844] bus: 'platform': add device i8042
[    4.032629] bus: 'platform': add driver i8042
[    4.033373] bus: 'platform': driver_probe_device: matched device i8042 with driver i8042
[    4.034742] bus: 'platform': really_probe: probing driver i8042 with device i8042
[    4.036696] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.037548] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.038377] driver: 'i8042': driver_bound: bound to device 'i8042'
[    4.039429] device: 'serio0': device_add
[    4.040138] bus: 'serio': add device serio0
[    4.040870] device: 'serio1': device_add
[    4.041549] bus: 'serio': add device serio1
[    4.042254] bus: 'platform': really_probe: bound device i8042 to driver i8042
[    4.111626] bus: 'serio': add driver atkbd
[    4.112403] bus: 'i2c': add driver synaptics_i2c
[    4.113183] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
[    4.114517] bus: 'serio': really_probe: probing driver atkbd with device serio0
[    4.116105] device: 'input0': device_add
[    4.116815] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    4.118277] device: 'event0': device_add
[    4.118981] evbug: Connected device: input0 (AT Translated Set 2 keyboard at isa0060/serio0/input0)
[    4.120531] driver: 'serio0': driver_bound: bound to device 'atkbd'
[    4.121612] i2c-core: driver [synaptics_i2c] registered
[    4.122524] bus: 'i2c': add driver smbus_alert
[    4.123298] i2c-core: driver [smbus_alert] registered
[    4.124159] bus: 'platform': add driver simtec-i2c
[    4.125003] i2c-parport-light: adapter type unspecified
[    4.125894] Colour QuickCam for Video4Linux v0.06
[    4.634032] bus: 'i2c': add driver saa7706h
[    4.634762] bus: 'serio': really_probe: bound device serio0 to driver atkbd
[    4.634792] i2c-core: driver [saa7706h] registered
[    4.634795] Driver for 1-wire Dallas network protocol.
[    4.634802] bus: 'w1': registered
[    4.634804] bus: 'w1': add driver w1_master_driver
[    4.634809] bus: 'w1': add driver w1_slave_driver
[    4.634815] bus: 'platform': add driver w1-gpio
[    4.634825] bus: 'platform': remove driver w1-gpio
[    4.634828] driver: 'w1-gpio': driver_release
[    4.634856] bus: 'platform': add driver pda-power
[    4.634864] bus: 'platform': add driver wm831x-power
[    4.634872] device: 'test_ac': device_add
[    4.634897] device: 'test_battery': device_add
[    4.634940] bus: 'platform': add driver ds2780-battery
[    4.634958] bus: 'platform': add driver ds2781-battery
[    4.634965] bus: 'i2c': add driver sbs-battery
[    4.634973] i2c-core: driver [sbs-battery] using legacy suspend method
[    4.634974] i2c-core: driver [sbs-battery] registered
[    4.634977] bus: 'platform': add driver da903x-battery
[    4.634984] bus: 'i2c': add driver max17042
[    4.634988] i2c-core: driver [max17042] registered
[    4.634990] bus: 'platform': add driver isp1704_charger
[    4.634997] bus: 'platform': add driver max8903-charger
[    4.635004] bus: 'i2c': add driver lp8727
[    4.635008] i2c-core: driver [lp8727] registered
[    4.635010] bus: 'platform': add driver gpio-charger
[    4.635017] bus: 'i2c': add driver smb347
[    4.635020] i2c-core: driver [smb347] registered
[    4.635112] bus: 'i2c': add driver w83781d
[    4.635117] i2c-core: driver [w83781d] registered
[    4.635120] bus: 'i2c': add driver adm1021
[    4.635123] i2c-core: driver [adm1021] registered
[    4.635126] bus: 'i2c': add driver adm1026
[    4.635129] i2c-core: driver [adm1026] registered
[    4.635132] bus: 'i2c': add driver adm1029
[    4.635135] i2c-core: driver [adm1029] registered
[    4.635137] bus: 'i2c': add driver adm1031
[    4.635141] i2c-core: driver [adm1031] registered
[    4.635143] bus: 'i2c': add driver adm9240
[    4.635147] i2c-core: driver [adm9240] registered
[    4.635149] bus: 'i2c': add driver ads1015
[    4.635152] i2c-core: driver [ads1015] registered
[    4.635157] bus: 'i2c': add driver asc7621
[    4.635161] i2c-core: driver [asc7621] registered
[    4.635163] bus: 'i2c': add driver ds1621
[    4.635170] i2c-core: driver [ds1621] registered
[    4.635173] bus: 'i2c': add driver emc2103
[    4.635176] i2c-core: driver [emc2103] registered
[    4.635508] bus: 'i2c': add driver f75375
[    4.635513] i2c-core: driver [f75375] registered
[    4.635515] bus: 'i2c': add driver gl520sm
[    4.635519] i2c-core: driver [gl520sm] registered
[    4.635671] bus: 'i2c': add driver jc42
[    4.635680] i2c-core: driver [jc42] registered
[    4.635682] bus: 'i2c': add driver lm73
[    4.635686] i2c-core: driver [lm73] registered
[    4.635689] bus: 'i2c': add driver lm75
[    4.635693] i2c-core: driver [lm75] registered
[    4.635695] bus: 'i2c': add driver lm77
[    4.635699] i2c-core: driver [lm77] registered
[    4.635701] bus: 'i2c': add driver lm78
[    4.635705] i2c-core: driver [lm78] registered
[    4.635707] bus: 'i2c': add driver lm85
[    4.635710] i2c-core: driver [lm85] registered
[    4.635713] bus: 'i2c': add driver lm90
[    4.635716] i2c-core: driver [lm90] registered
[    4.635719] bus: 'i2c': add driver lm93
[    4.635722] i2c-core: driver [lm93] registered
[    4.635725] bus: 'i2c': add driver lm95241
[    4.635728] i2c-core: driver [lm95241] registered
[    4.635731] bus: 'i2c': add driver ltc4151
[    4.635734] i2c-core: driver [ltc4151] registered
[    4.635737] bus: 'i2c': add driver max16065
[    4.635741] i2c-core: driver [max16065] registered
[    4.635743] bus: 'i2c': add driver max1619
[    4.635747] i2c-core: driver [max1619] registered
[    4.635805] bus: 'i2c': add driver sht21
[    4.635827] i2c-core: driver [sht21] registered
[    4.635830] bus: 'i2c': add driver smsc47m192
[    4.635834] i2c-core: driver [smsc47m192] registered
[    4.635837] bus: 'platform': add driver wm831x-hwmon
[    4.635845] bus: 'platform': add driver wm8350-hwmon
[    4.635861] cpuidle: using governor ladder
[    4.635863] bus: 'platform': add driver 88pm860x-led
[    4.635871] bus: 'platform': add driver leds-gpio
[    4.635878] bus: 'i2c': add driver lp3944
[    4.635882] i2c-core: driver [lp3944] registered
[    4.635885] bus: 'i2c': add driver lp5521
[    4.635889] i2c-core: driver [lp5521] registered
[    4.635891] bus: 'platform': add driver leds-ot200
[    4.635898] bus: 'i2c': add driver leds-pca9633
[    4.635902] i2c-core: driver [leds-pca9633] registered
[    4.635905] bus: 'platform': add driver da903x-led
[    4.635912] bus: 'platform': add driver wm831x-status
[    4.635919] bus: 'platform': add driver leds-lt3593
[    4.635926] bus: 'platform': add driver max8997-led
[    4.635940] bus: 'platform': add driver dcdbas
[    4.635948] Registering platform device 'dcdbas'. Parent at platform
[    4.635949] device: 'dcdbas': device_add
[    4.635951] bus: 'platform': add device dcdbas
[    4.635987] bus: 'platform': driver_probe_device: matched device dcdbas with driver dcdbas
[    4.635989] bus: 'platform': really_probe: probing driver dcdbas with device dcdbas
[    4.635991] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[    4.635992] driver: 'dcdbas': driver_bound: bound to device 'dcdbas'
[    4.635994] bus: 'platform': really_probe: bound device dcdbas to driver dcdbas
[    4.635999] bus: 'i2c': add driver cptm1217
[    4.636015] i2c-core: driver [cptm1217] using legacy suspend method
[    4.636016] i2c-core: driver [cptm1217] using legacy resume method
[    4.636017] i2c-core: driver [cptm1217] registered
[    4.636020] bus: 'i2c': add driver synaptics_rmi4_i2c
[    4.636024] i2c-core: driver [synaptics_rmi4_i2c] registered
[    4.636140] device: 'binder': device_add
[    4.636256] device: 'log_main': device_add
[    4.636264] logger: created 256K log 'log_main'
[    4.636336] device: 'log_events': device_add
[    4.636343] logger: created 256K log 'log_events'
[    4.636415] device: 'log_radio': device_add
[    4.636422] logger: created 256K log 'log_radio'
[    4.636525] device: 'log_system': device_add
[    4.636541] logger: created 256K log 'log_system'
[    4.636542] Linux telephony interface: v1.00
[    4.636546] device class 'extcon': registering
[    4.636552] bus: 'platform': add driver extcon-gpio
[    4.636560] bus: 'platform': add driver max8997-muic
[    4.636648] GACT probability on
[    4.636650] Mirror/redirect action on
[    4.636652] Simple TC action Loaded
[    4.636710] TCP: bic registered
[    4.636711] TCP: cubic registered
[    4.636712] Initializing XFRM netlink socket
[    4.636752] NET: Registered protocol family 10
[    4.637066] sit: IPv6 over IPv4 tunneling driver
[    4.637080] device: 'sit0': device_add
[    4.637140] device: 'ip6tnl0': device_add
[    4.637174] l2tp_core: L2TP core driver, V2.0
[    4.637175] NET4: DECnet for Linux: V.2.5.68s (C) 1995-2003 Linux DECnet Project Team
[    4.637202] DECnet: Routing cache hash table of 128 buckets, 10Kbytes
[    4.637227] NET: Registered protocol family 12
[    4.742407] bus: 'serio': driver_probe_device: matched device serio1 with driver atkbd
[    4.743833] bus: 'serio': really_probe: probing driver atkbd with device serio1
[    4.745329] atkbd: probe of serio1 rejects match -19
[    4.760053] 8021q: 802.1Q VLAN Support v1.8
[    4.760796] lib80211: common routines for IEEE802.11 drivers
[    4.761748] lib80211_crypt: registered algorithm 'NULL'
[    4.762620] lib80211_crypt: registered algorithm 'WEP'
[    4.763467] lib80211_crypt: registered algorithm 'CCMP'
[    4.764387] lib80211_crypt: registered algorithm 'TKIP'
[    4.765309] NET: Registered protocol family 37
[    4.766120] Key type dns_resolver registered
[    4.767025] batman_adv: B.A.T.M.A.N. advanced 2012.2.0 (compatibility version 14) loaded
[    4.768563] 
[    4.768563] printing PIC contents
[    4.769359] ... PIC  IMR: fffb
[    4.769882] ... PIC  IRR: 9013
[    4.770417] ... PIC  ISR: 0000
[    4.770943] ... PIC ELCR: 0c00
[    4.771455] printing local APIC contents on CPU#0/0:
[    4.772304] ... APIC ID:      00000000 (0)
[    4.772991] ... APIC VERSION: 00050014
[    4.773705] ... APIC TASKPRI: 00000000 (00)
[    4.774520] ... APIC PROCPRI: 00000000
[    4.775143] ... APIC LDR: 01000000
[    4.775723] ... APIC DFR: ffffffff
[    4.776291] ... APIC SPIV: 000001ff
[    4.776878] ... APIC ISR field:
[    4.777403] 0000000000000000000000000000000000000000000000000000000000000000
[    4.778759] ... APIC TMR field:
[    4.779285] 0000000000000000000000000000000000000000000000000000000000000000
[    4.780408] ... APIC IRR field:
[    4.780408] 0000000000000000000000000000000000000000000000000000000000008000
[    4.780408] ... APIC ESR: 00000000
[    4.780408] ... APIC ICR: 000008fd
[    4.780408] ... APIC ICR2: 02000000
[    4.780408] ... APIC LVTT: 000000ef
[    4.780408] ... APIC LVTPC: 00010000
[    4.780408] ... APIC LVT0: 00010700
[    4.780408] ... APIC LVT1: 00000400
[    4.780408] ... APIC LVTERR: 000000fe
[    4.780408] ... APIC TMICT: 000924f8
[    4.780408] ... APIC TMCCT: 00000000
[    4.780408] ... APIC TDCR: 00000003
[    4.780408] 
[    4.789345] number of MP IRQ sources: 20.
[    4.790036] number of IO-APIC #2 registers: 24.
[    4.790794] testing the IO APIC.......................
[    4.791674] 
[    4.791933] IO APIC #2......
[    4.792413] .... register #00: 00000000
[    4.793055] .......    : physical APIC id: 00
[    4.793782] .......    : Delivery Type: 0
[    4.794443] .......    : LTS          : 0
[    4.795114] .... register #01: 00170011
[    4.795760] .......     : max redirection entries: 17
[    4.796599] .......     : PRQ implemented: 0
[    4.797305] .......     : IO APIC version: 11
[    4.798034] .... register #02: 00000000
[    4.798681] .......     : arbitration: 00
[    4.799342] .... IRQ redirection table:
[    4.799987]  NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:
[    4.800920]  00 00  1    0    0   0   0    0    0    00
[    4.801831]  01 03  0    0    0   0   0    1    1    31
[    4.802776]  02 03  0    0    0   0   0    1    1    30
[    4.803710]  03 03  1    0    0   0   0    1    1    33
[    4.804610]  04 03  1    0    0   0   0    1    1    34
[    4.805507]  05 03  1    0    0   0   0    1    1    35
[    4.806388]  06 03  1    0    0   0   0    1    1    36
[    4.807286]  07 03  1    0    0   0   0    1    1    37
[    4.808184]  08 03  1    0    0   0   0    1    1    38
[    4.809080]  09 03  1    1    0   0   0    1    1    29
[    4.809992]  0a 03  1    1    0   0   0    1    1    41
[    4.810917]  0b 03  1    1    0   0   0    1    1    49
[    4.811829]  0c 03  0    0    0   0   0    1    1    3C
[    4.812728]  0d 03  1    0    0   0   0    1    1    3D
[    4.813650]  0e 03  0    0    0   0   0    1    1    3E
[    4.814545]  0f 03  0    0    0   0   0    1    1    3F
[    4.815436]  10 00  1    0    0   0   0    0    0    00
[    4.816334]  11 00  1    0    0   0   0    0    0    00
[    4.817231]  12 00  1    0    0   0   0    0    0    00
[    4.818127]  13 00  1    0    0   0   0    0    0    00
[    4.819025]  14 00  1    0    0   0   0    0    0    00
[    4.819921]  15 00  1    0    0   0   0    0    0    00
[    4.820835]  16 00  1    0    0   0   0    0    0    00
[    4.821743]  17 00  1    0    0   0   0    0    0    00
[    4.822630] IRQ to pin mappings:
[    4.823167] IRQ0 -> 0:2
[    4.823631] IRQ1 -> 0:1
[    4.824082] IRQ3 -> 0:3
[    4.824570] IRQ4 -> 0:4
[    4.825022] IRQ5 -> 0:5
[    4.825483] IRQ6 -> 0:6
[    4.825937] IRQ7 -> 0:7
[    4.826389] IRQ8 -> 0:8
[    4.826849] IRQ12 -> 0:12
[    4.827328] IRQ13 -> 0:13
[    4.827819] IRQ14 -> 0:14
[    4.828298] IRQ15 -> 0:15
[    4.828787] IRQ33 -> 0:9
[    4.829251] IRQ34 -> 0:10
[    4.829740] IRQ35 -> 0:11
[    4.830237] .................................... done.
[    4.831104] device: 'cpu_dma_latency': device_add
[    4.831914] device: 'network_latency': device_add
[    4.832713] device: 'network_throughput': device_add
[    4.833666] registered taskstats version 1
[    4.835004] console [netcon0] enabled
[    4.835639] netconsole: network logging started
[    4.836389] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.837386] EDD information not available.
[    4.838847] debug: unmapping init [mem 0xffffffff81a91000-0xffffffff81cb7fff]
[    4.840268] Write protecting the kernel read-only data: 10240k
[    4.841437] debug: unmapping init [mem 0xffff88000148b000-0xffff8800015fffff]
[    4.842753] debug: unmapping init [mem 0xffff880001826000-0xffff8800019fffff]
[  250.927264] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  250.928286] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  250.929270] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  250.930034] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  250.930034] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  250.932905] SysRq : Show backtrace of all active CPUs
[  250.933935] CPU0:
[  250.934250] CPU 0 
[  250.934611] Pid: 0, comm: swapper/0 Not tainted 3.5.0-rc5-bisect-00089-gdab5369 #113 Bochs Bochs
[  250.936053] RIP: 0010:[<ffffffff81035f4b>]  [<ffffffff81035f4b>] arch_local_irq_enable+0x8/0xd
[  250.937563] RSP: 0018:ffff88000dc03ee0  EFLAGS: 00000202
[  250.938427] RAX: ffffffff81a0e3f0 RBX: 0000003a6d308700 RCX: 0000000000000020
[  250.939586] RDX: ffffffff81a01fd8 RSI: 0000000000000000 RDI: ffffffff81a0e3f0
[  250.940746] RBP: ffff88000dc03ee0 R08: 0000000000000000 R09: ffffffff8104a1ad
[  250.941890] R10: ffffffff8104a1ad R11: ffff88000dc0d440 R12: ffff88000dc03e58
[  250.942842] R13: ffffffff814879ef R14: ffff88000dc03ee0 R15: 000000000000000a
[  250.942842] FS:  0000000000000000(0000) GS:ffff88000dc00000(0000) knlGS:0000000000000000
[  250.942842] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  250.942842] CR2: 00007f80998bf3b0 CR3: 0000000005046000 CR4: 00000000000006b0
[  250.942842] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  250.942842] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  250.942842] Process swapper/0 (pid: 0, threadinfo ffffffff81a00000, task ffffffff81a0e3f0)
[  250.942842] Stack:
[  250.942842]  ffff88000dc03f40 ffffffff81036425 ffffffff8105c383 0000000000000000
[  250.942842]  0000003a6cc33c3b 0000000000000003 0000003a6cc33c3b 0000000000000046
[  250.942842]  ffffffff81a01fd8 ffffffff81c98080 ffff88000fff6280 0000000000000000
[  250.942842] Call Trace:
[  250.942842]  <IRQ> 
[  250.942842] 
[  250.942842]  [<ffffffff81036425>] __do_softirq+0x6e/0x140
[  250.942842]  [<ffffffff8105c383>] ? clockevents_program_event+0x9c/0xb9
[  250.942842]  [<ffffffff8148962c>] call_softirq+0x1c/0x26
[  250.942842]  [<ffffffff81003367>] do_softirq+0x45/0x9a
[  250.942842]  [<ffffffff81036747>] irq_exit+0x4c/0x81
[  250.942842]  [<ffffffff8101285e>] smp_apic_timer_interrupt+0x77/0x85
[  250.942842]  [<ffffffff81488daf>] apic_timer_interrupt+0x6f/0x80
[  250.942842]  <EOI> 
[  250.942842] 
[  250.942842]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  250.942842]  [<ffffffff8101659f>] ? native_safe_halt+0x6/0x8
[  250.942842]  [<ffffffff8105fba8>] ? trace_hardirqs_on+0xd/0xf
[  250.942842]  [<ffffffff81008230>] default_idle+0x2a/0x4a
[  250.942842]  [<ffffffff81008b0a>] cpu_idle+0xad/0xf3
[  250.942842]  [<ffffffff8146160b>] rest_init+0x13f/0x146
[  250.942842]  [<ffffffff814614cc>] ? csum_partial_copy_generic+0x16c/0x16c
[  250.942842]  [<ffffffff81c63bb9>] start_kernel+0x3f8/0x405
[  250.942842]  [<ffffffff81c635c9>] ? repair_env_string+0x5a/0x5a
[  250.942842]  [<ffffffff81c632b5>] x86_64_start_reservations+0xb1/0xb5
[  250.942842]  [<ffffffff81c633b7>] x86_64_start_kernel+0xfe/0x10b
[  250.942842] Code: 9c 58 66 66 90 66 90 5d c3 55 48 89 e5 57 9d 66 66 90 66 90 5d c3 55 48 89 e5 fa 66 66 90 66 66 90 5d c3 55 48 89 e5 fb 66 66 90 <66> 66 90 5d c3 55 48 89 e5 f0 80 67 08 fd 5d c3 65 48 8b 3c 25 
[  250.942842] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  251.027265] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  251.028437] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  251.029487] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  251.030031] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  271.866844] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 56
[  271.867904] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 1
[  271.868942] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  271.870012] evbug: Event. Dev: input0, Type: 4, Code: 4, Value: 84
[  271.870076] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  271.872157] SysRq : Show State
[  271.872707]   task                        PC stack   pid father
[  271.873807] init            S 0000000000000000     0     1      0 0x00000000
[  271.875408]  ffff88000001dcd8 0000000000000046 ffff880000028000 ffff88000001dfd8
[  271.876823]  00000000001d0b80 ffff88000001dfd8 ffff88000002eb40 ffff880000028000
[  271.878203]  ffff8800000285a0 ffff88000504e000 ffff880008f92280 ffff88000001df60
[  271.879576] Call Trace:
[  271.880018]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.880872]  [<ffffffff810b4856>] pipe_wait+0x5c/0x77
[  271.881748]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  271.882125]  [<ffffffff810b4fe5>] pipe_read+0x330/0x3ad
[  271.882125]  [<ffffffff8103a555>] ? spin_unlock_irq+0x9/0xb
[  271.882125]  [<ffffffff810163b3>] ? kvm_clock_read+0x2e/0x35
[  271.882125]  [<ffffffff810acc92>] ? wait_on_retry_sync_kiocb+0x4e/0x4e
[  271.882125]  [<ffffffff810acd55>] do_sync_read+0xc3/0xfe
[  271.882125]  [<ffffffff810609d1>] ? lock_is_held+0x8a/0x9c
[  271.882125]  [<ffffffff810ae192>] ? fcheck_files+0xa7/0xe9
[  271.882125]  [<ffffffff810ad461>] vfs_read+0x93/0xf6
[  271.882125]  [<ffffffff810ae848>] ? fget_light+0x33/0x9b
[  271.882125]  [<ffffffff810ad6fd>] sys_read+0x41/0x71
[  271.882125]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  271.882125] kthreadd        S 0000000000000000     0     2      0 0x00000000
[  271.882125]  ffff88000001fef0 0000000000000046 ffff8800000291e0 ffff88000001ffd8
[  271.882125]  00000000001d0b80 ffff88000001ffd8 ffff880000028000 ffff8800000291e0
[  271.882125]  ffff8800000291e0 ffffffff81a17f20 ffff8800000291e0 ffff88000001dd28
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81046e8c>] kthreadd+0x75/0xf7
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046e17>] ? kthread_stop+0x57/0x57
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] ksoftirqd/0     S ffff880000041fd8     0     3      2 0x00000000
[  271.882125]  ffff880000041df0 0000000000000046 ffff88000002a3c0 ffff880000041fd8
[  271.882125]  00000000001d0b80 ffff880000041fd8 ffff88000002b5a0 ffff88000002a3c0
[  271.882125]  0000000000000000 ffff880000040000 0000000000000000 ffff880000041fd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff814862be>] schedule_preempt_disabled+0x1f/0x27
[  271.882125]  [<ffffffff81036556>] run_ksoftirqd+0x5f/0x193
[  271.882125]  [<ffffffff810364f7>] ? __do_softirq+0x140/0x140
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kworker/0:0     S ffff880000095320     0     4      2 0x00000000
[  271.882125]  ffff880000045e40 0000000000000046 ffff88000002b5a0 ffff880000045fd8
[  271.882125]  00000000001d0b80 ffff880000045fd8 ffffffff81a0e3f0 ffff88000002b5a0
[  271.882125]  ffff880000045e20 ffff880000095300 ffff88000dc0d000 ffff88000002b5a0
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kworker/u:0     S ffff8800000954a0     0     5      2 0x00000000
[  271.882125]  ffff880000049e40 0000000000000046 ffff88000002c780 ffff880000049fd8
[  271.882125]  00000000001d0b80 ffff880000049fd8 ffff880000028000 ffff88000002c780
[  271.882125]  ffff880000049e20 ffff880000095480 ffffffff81d0f540 ffff88000002c780
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] migration/0     S 0000000000000000     0     6      2 0x00000000
[  271.882125]  ffff88000004bd90 0000000000000046 ffff88000002d960 ffff88000004bfd8
[  271.882125]  00000000001d0b80 ffff88000004bfd8 ffffffff81a0e3f0 ffff88000002d960
[  271.882125]  ffff88000ddcd6a0 ffff88000002d960 ffff88000ddcd6a0 ffff88000004bfd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81066feb>] cpu_stopper_thread+0x186/0x1a2
[  271.882125]  [<ffffffff8104f16a>] ? __migrate_task+0xf8/0xf8
[  271.882125]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  271.882125]  [<ffffffff81066e65>] ? cpumask_weight+0x14/0x14
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] migration/1     S 0000000000000000     0     7      2 0x00000000
[  271.882125]  ffff88000004fd90 0000000000000046 ffff880000050000 ffff88000004ffd8
[  271.882125]  00000000001d0b80 ffff88000004ffd8 ffff88000002eb40 ffff880000050000
[  271.882125]  ffff88000dfcd6a0 ffff880000050000 ffff88000dfcd6a0 ffff88000004ffd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81066feb>] cpu_stopper_thread+0x186/0x1a2
[  271.882125]  [<ffffffff8104f16a>] ? __migrate_task+0xf8/0xf8
[  271.882125]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  271.882125]  [<ffffffff81066e65>] ? cpumask_weight+0x14/0x14
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kworker/1:0     S ffff880000095860     0     8      2 0x00000000
[  271.882125]  ffff880000059e40 0000000000000046 ffff8800000511e0 ffff880000059fd8
[  271.882125]  00000000001d0b80 ffff880000059fd8 ffff8800000791e0 ffff8800000511e0
[  271.882125]  ffff880000059e20 ffff880000095840 ffff88000de0d000 ffff8800000511e0
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] ksoftirqd/1     S ffff88000005bfd8     0     9      2 0x00000000
[  271.882125]  ffff88000005bdf0 0000000000000046 ffff8800000523c0 ffff88000005bfd8
[  271.882125]  00000000001d0b80 ffff88000005bfd8 ffff880000028000 ffff8800000523c0
[  271.882125]  ffff88000005bdf0 ffff88000005a000 0000000000000001 ffff88000005bfd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff814862be>] schedule_preempt_disabled+0x1f/0x27
[  271.882125]  [<ffffffff81036556>] run_ksoftirqd+0x5f/0x193
[  271.882125]  [<ffffffff810364f7>] ? __do_softirq+0x140/0x140
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] khelper         S ffff880000097700     0    10      2 0x00000000
[  271.882125]  ffff880000061e00 0000000000000046 ffff8800000535a0 ffff880000061fd8
[  271.882125]  00000000001d0b80 ffff880000061fd8 ffff88000002eb40 ffff8800000535a0
[  271.882125]  ffff880000061e10 ffff8800000535a0 ffff880000095c00 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] sync_supers     S 0000000000000000     0    11      2 0x00000000
[  271.882125]  ffff880000063e50 0000000000000046 ffff880000054780 ffff880000063fd8
[  271.882125]  00000000001d0b80 ffff880000063fd8 ffffffff81a0e3f0 ffff880000054780
[  271.882125]  0000000000000000 ffff880000054780 0000000000000000 ffffffff81093d1d
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff81093d1d>] ? bdi_sched_wait+0xd/0xd
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81093d57>] bdi_sync_supers+0x3a/0x51
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] bdi-default     S ffffffff81a1b900     0    12      2 0x00000000
[  271.882125]  ffff880000069d80 0000000000000046 ffff880000055960 ffff880000069fd8
[  271.882125]  00000000001d0b80 ffff880000069fd8 ffff88000002eb40 ffff880000055960
[  271.882125]  ffff880000069d80 0000000100000016 ffff880000055960 0000000000000000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81487038>] ? _raw_spin_unlock_bh+0x3c/0x41
[  271.882125]  [<ffffffff810942a6>] bdi_forker_thread+0x2e5/0x2ea
[  271.882125]  [<ffffffff81093fc1>] ? wb_has_dirty_io+0x3f/0x3f
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kintegrityd     S ffff880000097d00     0    13      2 0x00000000
[  271.882125]  ffff88000006be00 0000000000000046 ffff880000056b40 ffff88000006bfd8
[  271.882125]  00000000001d0b80 ffff88000006bfd8 ffff88000002eb40 ffff880000056b40
[  271.882125]  ffff88000006be10 ffff880000056b40 ffff880000012840 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kblockd         S ffff880000097f00     0    14      2 0x00000000
[  271.882125]  ffff880000101e00 0000000000000046 ffff880000078000 ffff880000101fd8
[  271.882125]  00000000001d0b80 ffff880000101fd8 ffff88000002eb40 ffff880000078000
[  271.882125]  ffff880000101e10 ffff880000078000 ffff8800000129c0 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kworker/1:1     S ffff88000ccf9020     0    15      2 0x00000000
[  271.882125]  ffff880000129e40 0000000000000046 ffff8800000791e0 ffff880000129fd8
[  271.882125]  00000000001d0b80 ffff880000129fd8 ffff88000007eb40 ffff8800000791e0
[  271.882125]  ffff880000129e20 ffff88000ccf9000 ffff88000de0d000 ffff8800000791e0
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] khungtaskd      S 00000000003fffd2     0    17      2 0x00000000
[  271.882125]  ffff88000689bd80 0000000000000046 ffff88000007b5a0 ffff88000689bfd8
[  271.882125]  00000000001d0b80 ffff88000689bfd8 ffff88000002eb40 ffff88000007b5a0
[  271.882125]  ffff88000689bd80 00000001000017de ffff8800057cb5a0 0000000000000078
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81071366>] watchdog+0x42/0x232
[  271.882125]  [<ffffffff81071324>] ? rcu_read_lock+0x79/0x79
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_wri S 0000000000000000     0    18      2 0x00000000
[  271.882125]  ffff88000689dd90 0000000000000046 ffff88000007c780 ffff88000689dfd8
[  271.882125]  00000000001d0b80 ffff88000689dfd8 ffff8800068a8000 ffff88000007c780
[  271.882125]  ffff88000689dd90 00000000fffff511 0000000000000000 ffff88000007c780
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81077a2f>] rcu_torture_writer+0x1a1/0x201
[  271.882125]  [<ffffffff8107788e>] ? srcu_read_lock_held.constprop.28+0x38/0x38
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_fak S 0000000000000000     0    19      2 0x00000000
[  271.882125]  ffff88000689fda0 0000000000000046 ffff88000007d960 ffff88000689ffd8
[  271.882125]  00000000001d0b80 ffff88000689ffd8 ffff8800068ab5a0 ffff88000007d960
[  271.882125]  ffff88000689fda0 00000000fffff511 0000000000000000 ffffffff81076400
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_fak S 0000000000000000     0    20      2 0x00000000
[  271.882125]  ffff8800068a1da0 0000000000000046 ffff88000007eb40 ffff8800068a1fd8
[  271.882125]  00000000001d0b80 ffff8800068a1fd8 ffff8800068a91e0 ffff88000007eb40
[  271.882125]  ffff8800068a1da0 00000000fffff511 0000000000000000 ffffffff81076400
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_fak S 0000000000000000     0    21      2 0x00000000
[  271.882125]  ffff8800068a3da0 0000000000000046 ffff8800068a8000 ffff8800068a3fd8
[  271.882125]  00000000001d0b80 ffff8800068a3fd8 ffff8800068ad960 ffff8800068a8000
[  271.882125]  ffff8800068a3da0 00000000fffff511 0000000000000000 ffffffff81076400
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_fak S 0000000000000000     0    22      2 0x00000000
[  271.882125]  ffff8800068a5da0 0000000000000046 ffff8800068a91e0 ffff8800068a5fd8
[  271.882125]  00000000001d0b80 ffff8800068a5fd8 ffff8800068ac780 ffff8800068a91e0
[  271.882125]  ffff8800068a5da0 00000000fffff511 0000000000000000 ffffffff81076400
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff81076400>] ? rcu_torture_barrier+0x1dd/0x1dd
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81076491>] rcu_torture_fakewriter+0x91/0xe6
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_rea S 00000000ffffff0a     0    23      2 0x00000000
[  271.882125]  ffff8800068a7d00 0000000000000046 ffff8800068aa3c0 ffff8800068a7fd8
[  271.882125]  00000000001d0b80 ffff8800068a7fd8 ffff88000007d960 ffff8800068aa3c0
[  271.882125]  ffff8800068a7d00 00000000fffff511 ffff8800068a7fd8 ffff8800068a7fd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  271.882125]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_rea S 00000000ffffff0a     0    24      2 0x00000000
[  271.882125]  ffff8800068b1d00 0000000000000046 ffff8800068ab5a0 ffff8800068b1fd8
[  271.882125]  00000000001d0b80 ffff8800068b1fd8 ffff88000007c780 ffff8800068ab5a0
[  271.882125]  ffff8800068b1d00 00000000fffff511 ffff8800068b1fd8 ffff8800068b1fd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  271.882125]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_rea S 00000000ffffff0a     0    25      2 0x00000000
[  271.882125]  ffff8800068b3d00 0000000000000046 ffff8800068ac780 ffff8800068b3fd8
[  271.882125]  00000000001d0b80 ffff8800068b3fd8 ffff8800068aa3c0 ffff8800068ac780
[  271.882125]  ffff8800068b3d00 00000000fffff511 ffff8800068b3fd8 ffff8800068b3fd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  271.882125]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_rea S 00000000ffffff0a     0    26      2 0x00000000
[  271.882125]  ffff8800068b5d00 0000000000000046 ffff8800068ad960 ffff8800068b5fd8
[  271.882125]  00000000001d0b80 ffff8800068b5fd8 ffff88000002eb40 ffff8800068ad960
[  271.882125]  ffff8800068b5d00 00000000fffff511 ffff8800068b5fd8 ffff8800068b5fd8
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81039a40>] ? __round_jiffies_relative+0x16/0x1c
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff81075fa7>] rcu_stutter_wait+0x2b/0x49
[  271.882125]  [<ffffffff81077e78>] rcu_torture_reader+0x217/0x2a2
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff81077f03>] ? rcu_torture_reader+0x2a2/0x2a2
[  271.882125]  [<ffffffff81077c61>] ? rcutorture_trace_dump+0x30/0x30
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rcu_torture_stu S 0000000000000000     0    27      2 0x00000000
[  271.882125]  ffff8800068b7dd0 0000000000000046 ffff8800068aeb40 ffff8800068b7fd8
[  271.882125]  00000000001d0b80 ffff8800068b7fd8 ffff88000002eb40 ffff8800068aeb40
[  271.882125]  ffff8800068b7dd0 00000000fffff6b0 0000000000000000 ffffffff810766e9
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff810766e9>] ? rcutorture_cpu_notify+0x3a/0x3a
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81484e2a>] schedule_timeout+0x9b/0xbe
[  271.882125]  [<ffffffff810395bd>] ? internal_add_timer+0xc2/0xc2
[  271.882125]  [<ffffffff81484e66>] schedule_timeout_interruptible+0x19/0x1b
[  271.882125]  [<ffffffff8107671a>] rcu_torture_stutter+0x31/0x94
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kswapd0         S 0000000000000000     0    28      2 0x00000000
[  271.882125]  ffff8800068bdd70 0000000000000046 ffff8800068c0000 ffff8800068bdfd8
[  271.882125]  00000000001d0b80 ffff8800068bdfd8 ffff8800068a8000 ffff8800068c0000
[  271.882125]  ffff880000000000 ffffffff81a769c0 0000000000000000 0000000000000000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff8109283e>] kswapd+0x1ca/0x6ae
[  271.882125]  [<ffffffff8105fba8>] ? trace_hardirqs_on+0xd/0xf
[  271.882125]  [<ffffffff8104e5fa>] ? finish_task_switch+0x88/0xad
[  271.882125]  [<ffffffff8104e5af>] ? finish_task_switch+0x3d/0xad
[  271.882125]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  271.882125]  [<ffffffff81092674>] ? try_to_free_pages+0x2f8/0x2f8
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] ksmd            S 0000000000000000     0    29      2 0x00000000
[  271.882125]  ffff8800068bfe20 0000000000000046 ffff8800068c11e0 ffff8800068bffd8
[  271.882125]  00000000001d0b80 ffff8800068bffd8 ffff88000002eb40 ffff8800068c11e0
[  271.882125]  ffff8800068bfe30 ffff8800068bfe48 ffff8800068c11e0 ffff8800068bfe60
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff810a9838>] ksm_scan_thread+0xdd/0x10a
[  271.882125]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  271.882125]  [<ffffffff810a975b>] ? ksm_do_scan+0x899/0x899
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] fsnotify_mark   S ffff8800068c9e28     0    30      2 0x00000000
[  271.882125]  ffff8800068c9df0 0000000000000046 ffff8800068c23c0 ffff8800068c9fd8
[  271.882125]  00000000001d0b80 ffff8800068c9fd8 ffff880000028000 ffff8800068c23c0
[  271.882125]  ffff8800068c9e00 ffff8800068c9e38 ffff8800068c23c0 ffff8800068c9e50
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff810db95d>] fsnotify_mark_destroy+0x152/0x168
[  271.882125]  [<ffffffff814861cb>] ? __schedule+0x4ed/0x55f
[  271.882125]  [<ffffffff81047563>] ? abort_exclusive_wait+0x8a/0x8a
[  271.882125]  [<ffffffff810db80b>] ? fsnotify_put_mark+0x1a/0x1a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] xfsalloc        S ffff88000012f300     0    31      2 0x00000000
[  271.882125]  ffff880006927e00 0000000000000046 ffff8800068c35a0 ffff880006927fd8
[  271.882125]  00000000001d0b80 ffff880006927fd8 ffff88000002eb40 ffff8800068c35a0
[  271.882125]  ffff880006927e10 ffff8800068c35a0 ffff880006884a80 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] xfs_mru_cache   S ffff88000012f500     0    32      2 0x00000000
[  271.882125]  ffff880006929e00 0000000000000046 ffff8800068c4780 ffff880006929fd8
[  271.882125]  00000000001d0b80 ffff880006929fd8 ffff88000002eb40 ffff8800068c4780
[  271.882125]  ffff880006929e10 ffff8800068c4780 ffff880006884b40 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] xfslogd         S ffff88000012f700     0    33      2 0x00000000
[  271.882125]  ffff88000692be00 0000000000000046 ffff8800068c5960 ffff88000692bfd8
[  271.882125]  00000000001d0b80 ffff88000692bfd8 ffff88000002eb40 ffff8800068c5960
[  271.882125]  ffff88000692be10 ffff8800068c5960 ffff880006884c00 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] crypto          S ffff88000012f900     0    34      2 0x00000000
[  271.882125]  ffff88000692de00 0000000000000046 ffff8800068c6b40 ffff88000692dfd8
[  271.882125]  00000000001d0b80 ffff88000692dfd8 ffff88000002eb40 ffff8800068c6b40
[  271.882125]  ffff88000692de10 ffff8800068c6b40 ffff880006884cc0 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kworker/0:1     S 0000000000000000     0    69      2 0x00000000
[  271.882125]  ffff880006989e40 0000000000000046 ffff8800069c5960 ffff880006989fd8
[  271.882125]  00000000001d0b80 ffff880006989fd8 ffffffff81a0e3f0 ffff8800069c5960
[  271.882125]  ffff880006989e20 ffff88000010f840 ffff88000dc0d000 ffff8800069c5960
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff8104fe74>] ? complete+0x1a/0x4b
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff8104fe74>] ? complete+0x1a/0x4b
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] mtdblock0       S 0000000000000000     0    71      2 0x00000000
[  271.882125]  ffff880006577e00 0000000000000046 ffff8800069c6b40 ffff880006577fd8
[  271.882125]  00000000001d0b80 ffff880006577fd8 ffffffff81a0e3f0 ffff8800069c6b40
[  271.882125]  ffff880006578108 0000000000000000 ffff880006578000 ffff880006980b30
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff812bedcb>] mtd_blktrans_thread+0x10d/0x2e4
[  271.882125]  [<ffffffff812becbe>] ? blktrans_open+0xec/0xec
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] mtdblock1       S 0000000000000000     0    72      2 0x00000000
[  271.882125]  ffff880005633e00 0000000000000046 ffff8800069c4780 ffff880005633fd8
[  271.882125]  00000000001d0b80 ffff880005633fd8 ffff880000028000 ffff8800069c4780
[  271.882125]  ffff880006579d08 0000000000000000 ffff880006579c00 ffff880006981660
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff812bedcb>] mtd_blktrans_thread+0x10d/0x2e4
[  271.882125]  [<ffffffff812becbe>] ? blktrans_open+0xec/0xec
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] binder          S ffff880000092100     0    73      2 0x00000000
[  271.882125]  ffff880005651e00 0000000000000046 ffff8800069c35a0 ffff880005651fd8
[  271.882125]  00000000001d0b80 ffff880005651fd8 ffffffff81a0e3f0 ffff8800069c35a0
[  271.882125]  ffff880005651e10 ffff8800069c35a0 ffff88000010fd80 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] bat_events      S ffff880005756d00     0    74      2 0x00000000
[  271.882125]  ffff880005775e00 0000000000000046 ffff8800069c23c0 ffff880005775fd8
[  271.882125]  00000000001d0b80 ffff880005775fd8 ffff88000002eb40 ffff8800069c23c0
[  271.882125]  ffff880005775e10 ffff8800069c23c0 ffff88000010f540 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] deferwq         S ffff880005757500     0    75      2 0x00000000
[  271.882125]  ffff8800057c1e00 0000000000000046 ffff8800069c11e0 ffff8800057c1fd8
[  271.882125]  00000000001d0b80 ffff8800057c1fd8 ffff88000002eb40 ffff8800069c11e0
[  271.882125]  ffff8800057c1e10 ffff8800069c11e0 ffff88000010f180 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] kworker/u:1     S 0000000000000000     0    76      2 0x00000000
[  271.882125]  ffff8800057c3e40 0000000000000046 ffff8800069c0000 ffff8800057c3fd8
[  271.882125]  00000000001d0b80 ffff8800057c3fd8 ffff88000002eb40 ffff8800069c0000
[  271.882125]  ffff8800057c3e20 ffff88000010f000 ffffffff81d0f540 ffff8800069c0000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042de5>] worker_thread+0x13e/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81042ca7>] ? rescuer_thread+0x175/0x175
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] devfreq_wq      S ffff880005757900     0    77      2 0x00000000
[  271.882125]  ffff8800057c5e00 0000000000000046 ffff8800057c8000 ffff8800057c5fd8
[  271.882125]  00000000001d0b80 ffff8800057c5fd8 ffff88000002eb40 ffff8800057c8000
[  271.882125]  ffff8800057c5e10 ffff8800057c8000 ffff880000108e40 0000000000000008
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81042c91>] rescuer_thread+0x15f/0x175
[  271.882125]  [<ffffffff81042b32>] ? process_scheduled_works+0x2a/0x2a
[  271.882125]  [<ffffffff81046b99>] kthread+0xaa/0xb2
[  271.882125]  [<ffffffff8105fb00>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  271.882125]  [<ffffffff81489534>] kernel_thread_helper+0x4/0x10
[  271.882125]  [<ffffffff81487ab0>] ? retint_restore_args+0x13/0x13
[  271.882125]  [<ffffffff81046aef>] ? kthread_flush_work_fn+0xf/0xf
[  271.882125]  [<ffffffff81489530>] ? gs_change+0x13/0x13
[  271.882125] rc.local        S ffff88000007a3b0     0    78      1 0x00000000
[  271.882125]  ffff880005015e58 0000000000000046 ffff88000007a3c0 ffff880005015fd8
[  271.882125]  00000000001d0b80 ffff880005015fd8 ffff88000002eb40 ffff88000007a3c0
[  271.882125]  ffff88000007a3c0 ffff880005015f00 ffff88000007a3c0 ffff88000007a3c0
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff8103417e>] do_wait+0x189/0x1fc
[  271.882125]  [<ffffffff81035216>] sys_wait4+0x91/0xbd
[  271.882125]  [<ffffffff814882a5>] ? sysret_check+0x22/0x5d
[  271.882125]  [<ffffffff81033039>] ? kill_orphaned_pgrp+0xce/0xce
[  271.882125]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  271.882125] hostname        x ffff88000697d950     0    80      1 0x00000002
[  271.882125]  ffff880005055ea8 0000000000000046 ffff88000697d960 ffff880005055fd8
[  271.882125]  00000000001d0b80 ffff880005055fd8 ffff880000028000 ffff88000697d960
[  271.882125]  ffffffff81a04080 ffff88000697d960 0000000000000000 ffff880000028000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81034eda>] do_exit+0x6e3/0x6ef
[  271.882125]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  271.882125]  [<ffffffff81034f89>] do_group_exit+0x76/0xb5
[  271.882125]  [<ffffffff81034fda>] sys_exit_group+0x12/0x12
[  271.882125]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  271.882125] sh              t ffff88000697c780     0    81      1 0x00000002
[  271.882125]  ffff880005075d58 0000000000000046 ffff88000697c780 ffff880005075fd8
[  271.882125]  00000000001d0b80 ffff880005075fd8 ffff880000028000 ffff88000697c780
[  271.882125]  0000000000040004 ffff880005074000 0000000000040004 0000000000000000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff8103bc29>] ptrace_stop+0x153/0x20b
[  271.882125]  [<ffffffff8103cdbd>] get_signal_to_deliver+0x24a/0x4b3
[  271.882125]  [<ffffffff810015e7>] do_signal+0x2f/0x43c
[  271.882125]  [<ffffffff810ab13c>] ? kfree+0x84/0x88
[  271.882125]  [<ffffffff810aab27>] ? kmem_cache_free+0x6a/0x6f
[  271.882125]  [<ffffffff8148855b>] ? int_very_careful+0x5/0xd
[  271.882125]  [<ffffffff81001a30>] do_notify_resume+0x28/0x5a
[  271.882125]  [<ffffffff814885b2>] int_signal+0x12/0x17
[  271.882125] shutdown        S 0000000000000000     0    91     78 0x00000000
[  271.882125]  ffff880005077a68 0000000000000046 ffff8800050d11e0 ffff880005077fd8
[  271.882125]  00000000001d0b80 ffff880005077fd8 ffffffff81a0e3f0 ffff8800050d11e0
[  271.882125]  ffff88000507c680 0000000000000000 0000000000000000 0000000000000000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff814858db>] schedule_hrtimeout_range_clock+0x37/0xe1
[  271.882125]  [<ffffffff810472f2>] ? add_wait_queue+0x3f/0x44
[  271.882125]  [<ffffffff810bc541>] ? __pollwait+0xc0/0xc9
[  271.882125]  [<ffffffff81485993>] schedule_hrtimeout_range+0xe/0x10
[  271.882125]  [<ffffffff810bc939>] poll_schedule_timeout+0x3e/0x61
[  271.882125]  [<ffffffff810bd76d>] do_sys_poll+0x2ed/0x388
[  271.882125]  [<ffffffff8100774f>] ? sched_clock+0x9/0xb
[  271.882125]  [<ffffffff810524ba>] ? sched_clock_local+0x12/0x75
[  271.882125]  [<ffffffff81052641>] ? sched_clock_cpu+0xbd/0xcf
[  271.882125]  [<ffffffff8105fcd2>] ? trace_hardirqs_off+0xd/0xf
[  271.882125]  [<ffffffff81052780>] ? local_clock+0x3b/0x53
[  271.882125]  [<ffffffff8105e39c>] ? lock_release_holdtime.part.25+0x4e/0x55
[  271.882125]  [<ffffffff81061e33>] ? lock_release+0x189/0x1c3
[  271.882125]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  271.882125]  [<ffffffff810bc620>] ? rcu_read_lock_held+0x38/0x38
[  271.882125]  [<ffffffff8100748a>] ? paravirt_sched_clock+0x9/0xd
[  271.882125]  [<ffffffff8100774f>] ? sched_clock+0x9/0xb
[  271.882125]  [<ffffffff810524ba>] ? sched_clock_local+0x12/0x75
[  271.882125]  [<ffffffff81052641>] ? sched_clock_cpu+0xbd/0xcf
[  271.882125]  [<ffffffff8105fcd2>] ? trace_hardirqs_off+0xd/0xf
[  271.882125]  [<ffffffff81052780>] ? local_clock+0x3b/0x53
[  271.882125]  [<ffffffff8105e39c>] ? lock_release_holdtime.part.25+0x4e/0x55
[  271.882125]  [<ffffffff81061e33>] ? lock_release+0x189/0x1c3
[  271.882125]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  271.882125]  [<ffffffff8104ad91>] ? up_read+0x1c/0x34
[  271.882125]  [<ffffffff81017e70>] ? do_page_fault+0x2e8/0x36c
[  271.882125]  [<ffffffff813813bc>] ? sys_sendto+0x12f/0x15c
[  271.882125]  [<ffffffff8105fc4c>] ? trace_hardirqs_off_caller+0xa2/0x11b
[  271.882125]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  271.882125]  [<ffffffff810bd89f>] sys_poll+0x4a/0xb3
[  271.882125]  [<ffffffff81097272>] ? spin_lock+0x9/0xb
[  271.882125]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  271.882125] shutdown        x ffff8800057cb590     0    92     91 0x00000002
[  271.882125]  ffff880005045ea8 0000000000000046 ffff8800057cb5a0 ffff880005045fd8
[  271.882125]  00000000001d0b80 ffff880005045fd8 ffff88000002eb40 ffff8800057cb5a0
[  271.882125]  ffffffff81a04080 ffff8800057cb5a0 0000000000000000 ffff880000028000
[  271.882125] Call Trace:
[  271.882125]  [<ffffffff8148629d>] schedule+0x60/0x62
[  271.882125]  [<ffffffff81034eda>] do_exit+0x6e3/0x6ef
[  271.882125]  [<ffffffff81487a95>] ? retint_swapgs+0x13/0x1b
[  271.882125]  [<ffffffff81034f89>] do_group_exit+0x76/0xb5
[  271.882125]  [<ffffffff81034fda>] sys_exit_group+0x12/0x12
[  271.882125]  [<ffffffff81488279>] system_call_fastpath+0x16/0x1b
[  271.882125] 
[  271.882125] Showing all locks held in the system:
[  271.882125] 
[  271.882125] =============================================
[  271.882125] 
[  271.882125] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  271.882125] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  272.642496] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
[  272.643535] evbug: Event. Dev: input0, Type: 1, Code: 56, Value: 0
[  272.644551] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0
Kernel crashed on [  272.644551] evbug: Event. Dev: input0, Type: 0, Code: 0, Value: 0

--+HP7ph2BbKc20aGI--
